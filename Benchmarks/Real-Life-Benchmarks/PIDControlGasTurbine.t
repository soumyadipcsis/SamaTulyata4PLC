PROC PIDControlGasTurbine;
VAR
    // Control Mode & Process State
    ManualButton : BOOLEAN; AutoButton : BOOLEAN;
    Mode : INTEGER := 0; AutoProcess : BOOLEAN := FALSE;

    // Process Variables
    TurbineSpeed : INTEGER; TurbineTemperature : INTEGER;
    FuelPressure : INTEGER; LoadDemand : INTEGER;
    
    // Actuators & Outputs
    FuelValve : INTEGER; CoolingFan : BOOLEAN;
    GeneratorOutput : INTEGER; TurbineStart : BOOLEAN;
    
    // Setpoints
    SP_TurbineSpeed : INTEGER; SP_TurbineTemp : INTEGER;
    SP_FuelPressure : INTEGER; SP_LoadDemand : INTEGER;

    // Integer-Based PID Control for Speed & Temperature
    Kp_Speed, Ti_Speed, Td_Speed : INTEGER;
    e_Speed, e_Speed_prev : INTEGER;
    P_Speed, I_Speed, D_Speed : INTEGER;
    Integral_Speed : INTEGER; Derivative_Speed : INTEGER;
    
    Kp_Temp, Ti_Temp, Td_Temp : INTEGER;
    e_Temp, e_Temp_prev : INTEGER;
    P_Temp, I_Temp, D_Temp : INTEGER;
    Integral_Temp : INTEGER; Derivative_Temp : INTEGER;

    // Safety & Interlocks
    Emergency_Stop : BOOLEAN; Alarm_HighTemp : BOOLEAN;
    Alarm_LowFuel : BOOLEAN; 

    // Temporary Integer Variables
    TempValue1 : INTEGER; TempValue2 : INTEGER;
    LocalValue : INTEGER; I : INTEGER := 0;
    CustomScaling : INTEGER;

BEGIN
STEP 'EXECUTE_GAS_TURBINE_CONTROL'
IF ManualButton THEN
    Mode := 0; // Set mode to manual

IF Mode = 0 THEN // Manual Mode
BEGIN
    FuelValve := 0;
    GeneratorOutput := 0;
    CoolingFan := FALSE;
    TurbineStart := FALSE;
END

IF AutoButton THEN
    Mode := 1;

IF Mode = 1 THEN // Auto Mode
BEGIN
    IF Emergency_Stop THEN
    BEGIN
        FuelValve := 0;
        GeneratorOutput := 0;
        CoolingFan := FALSE;
        TurbineStart := FALSE;
        AutoProcess := FALSE;
    END
    ELSE IF NOT AutoProcess THEN
    BEGIN
        // ****************** TURBINE SPEED CONTROL ******************
        // Compute Error
        e_Speed := SP_TurbineSpeed - TurbineSpeed;

        // Proportional Term
        P_Speed := Kp_Speed * e_Speed;

        // Integral Term with Anti-Windup
        TempValue1 := e_Speed * Ti_Speed;  // Use integer multiplication
        TempValue1 := TempValue1 / 100;  // Scale down to prevent overflow
        IF ABS(Integral_Speed) < 10000 THEN
            Integral_Speed := Integral_Speed + TempValue1;
        END
        I_Speed := Integral_Speed;

        // Derivative Term
        TempValue2 := e_Speed - e_Speed_prev;
        TempValue2 := (TempValue2 * 100) / Td_Speed;  // Integer-based division
        D_Speed := (Td_Speed * TempValue2) / 100;

        // Compute Output
        FuelValve := P_Speed + I_Speed + D_Speed;

        // Apply Output Limits
        IF FuelValve > 100 THEN
            FuelValve := 100;
        ELSE
            IF FuelValve < 0 THEN
                FuelValve := 0;
        END

        // Store Previous Error
        e_Speed_prev := e_Speed;

        // ****************** TEMPERATURE CONTROL ******************
        // Compute Error
        e_Temp := SP_TurbineTemp - TurbineTemperature;

        // Proportional Term
        P_Temp := Kp_Temp * e_Temp;

        // Integral Term with Anti-Windup
        TempValue1 := e_Temp * Ti_Temp;  // Use integer multiplication
        TempValue1 := TempValue1 / 100;  // Scale down to prevent overflow
        IF ABS(Integral_Temp) < 10000 THEN
            Integral_Temp := Integral_Temp + TempValue1;
        END
        I_Temp := Integral_Temp;

        // Derivative Term
        TempValue2 := e_Temp - e_Temp_prev;
        TempValue2 := (TempValue2 * 100) / Td_Temp;  // Integer-based division
        D_Temp := (Td_Temp * TempValue2) / 100;

        // Compute Output (Cooling Fan Control)
        IF (P_Temp + I_Temp + D_Temp) > 0 THEN
            CoolingFan := TRUE;
        ELSE
            CoolingFan := FALSE;
        END

        // Store Previous Error
        e_Temp_prev := e_Temp;

        // ****************** SAFETY ALARMS ******************
        IF TurbineTemperature > (SP_TurbineTemp + 50) THEN
            Alarm_HighTemp := TRUE;
        ELSE
            Alarm_HighTemp := FALSE;
        END

        IF FuelPressure < (SP_FuelPressure - 10) THEN
            Alarm_LowFuel := TRUE;
        ELSE
            Alarm_LowFuel := FALSE;
        END

        // ****************** GENERATOR OUTPUT CONTROL ******************
        IF TurbineSpeed > (SP_TurbineSpeed - 10) THEN
        BEGIN
            GeneratorOutput := SP_LoadDemand;
            TurbineStart := TRUE;
        ELSE
            GeneratorOutput := 0;
            TurbineStart := FALSE;
        END

        // Mark Process Active
        AutoProcess := TRUE;
    END

    // **************** POST-CONTROL SCALING ****************
    IF AutoProcess THEN
    BEGIN
        WHILE (I < LocalValue) DO
        BEGIN
            GeneratorOutput := GeneratorOutput * 10;
            FuelValve := FuelValve / 10;
            I := I + 1;
        END
        CustomScaling := GeneratorOutput + FuelValve;
        
        // Reset Process
        AutoProcess := FALSE;
    END
END
ENDSTEP

END.
