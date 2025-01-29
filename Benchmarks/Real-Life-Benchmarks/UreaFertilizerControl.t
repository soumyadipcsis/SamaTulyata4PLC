PROC UreaFertilizerControl;
VAR
    // Control Mode and Process State
    ManualButton : BOOLEAN; AutoButton : BOOLEAN;
    Mode : INTEGER := 0; AutoProcess : BOOLEAN := FALSE;

    // Process Control Variables
    MixingTank_Level : INTEGER; Granulator_Level : INTEGER;
    Heating_Temp : INTEGER; Packing_Weight : INTEGER;

    // Actuators & Control Outputs
    Mixer_Speed : INTEGER; Granulator_Speed : INTEGER;
    Heater_Power : INTEGER; Conveyor_Speed : INTEGER;
    Packing_Machine : BOOLEAN;

    // Setpoints
    SP_MixingTank : INTEGER; SP_Granulator : INTEGER;
    SP_Temperature : INTEGER; SP_PackingWeight : INTEGER;

    // Integer-Based PID Control for Heating
    Kp_Heat, Ti_Heat, Td_Heat : INTEGER;
    e_Heat, e_Heat_prev : INTEGER;
    P_Heat, I_Heat, D_Heat : INTEGER;
    Integral_Heat : INTEGER; Derivative_Heat : INTEGER;
    Heater_Power_Min, Heater_Power_Max : INTEGER;

    // Safety & Interlocks
    Emergency_Stop : BOOLEAN; Alarm_HighTemp : BOOLEAN;
    Alarm_LowLevel : BOOLEAN; 

    // Temporary Variables (Converted to INTEGER)
    TempValue1 : INTEGER; TempValue2 : INTEGER;
    LocalValue : INTEGER; I : INTEGER := 0;
    CustomScaling : INTEGER;

BEGIN
STEP 'EXECUTE_UREA_PROCESS'
IF ManualButton THEN
    Mode := 0; // Set mode to manual

IF Mode = 0 THEN // Manual Mode
BEGIN
    Heater_Power := 0;
    Mixer_Speed := 0;
    Granulator_Speed := 0;
    Conveyor_Speed := 0;
    Packing_Machine := FALSE;
END

IF AutoButton THEN
    Mode := 1;

IF Mode = 1 THEN // Auto Mode
BEGIN
    IF Emergency_Stop THEN
    BEGIN
        Heater_Power := 0;
        Mixer_Speed := 0;
        Granulator_Speed := 0;
        Conveyor_Speed := 0;
        Packing_Machine := FALSE;
        AutoProcess := FALSE;
    END
    ELSE IF NOT AutoProcess THEN
    BEGIN
        // ****************** MIXING STAGE ******************
        IF MixingTank_Level > SP_MixingTank THEN
        BEGIN
            Mixer_Speed := Mixer_Speed + 10; // Increase Mixing
        ELSE
            Mixer_Speed := Mixer_Speed - 10; // Decrease Mixing
        END

        // ****************** HEATING CONTROL (INTEGER-BASED PID) ******************
        // Compute Error
        e_Heat := SP_Temperature - Heating_Temp;

        // Proportional Term
        P_Heat := Kp_Heat * e_Heat;

        // Integral Term with Anti-Windup
        TempValue1 := e_Heat * Ti_Heat;  // Use integer multiplication
        TempValue1 := TempValue1 / 100;  // Scale down to prevent overflow
        IF ABS(Integral_Heat) < Heater_Power_Max THEN
            Integral_Heat := Integral_Heat + TempValue1;
        END
        I_Heat := Integral_Heat;

        // Derivative Term
        TempValue2 := e_Heat - e_Heat_prev;
        TempValue2 := (TempValue2 * 100) / Td_Heat;  // Integer-based division
        D_Heat := (Td_Heat * TempValue2) / 100;

        // Compute Output
        Heater_Power := P_Heat + I_Heat + D_Heat;

        // Apply Output Limits
        IF Heater_Power > Heater_Power_Max THEN
            Heater_Power := Heater_Power_Max;
        ELSE
            IF Heater_Power < Heater_Power_Min THEN
                Heater_Power := Heater_Power_Min;
        END

        // Store Previous Error
        e_Heat_prev := e_Heat;

        // Temperature Alarm
        IF Heating_Temp > (SP_Temperature + 20) THEN
            Alarm_HighTemp := TRUE;
        ELSE
            Alarm_HighTemp := FALSE;
        END

        // ****************** GRANULATION STAGE ******************
        IF Granulator_Level > SP_Granulator THEN
        BEGIN
            Granulator_Speed := Granulator_Speed + 5;
        ELSE
            Granulator_Speed := Granulator_Speed - 5;
        END

        // ****************** PACKAGING STAGE ******************
        IF Packing_Weight >= SP_PackingWeight THEN
        BEGIN
            Packing_Machine := TRUE;
        ELSE
            Packing_Machine := FALSE;
        END

        // Mark Process Active
        AutoProcess := TRUE;
    END

    // **************** POST-CONTROL SCALING ****************
    IF AutoProcess THEN
    BEGIN
        WHILE (I < LocalValue) DO
        BEGIN
            Mixer_Speed := Mixer_Speed * 10;
            Heater_Power := Heater_Power / 10;
            I := I + 1;
        END
        CustomScaling := Mixer_Speed + Heater_Power;
        
        // Reset Process
        AutoProcess := FALSE;
    END
END
ENDSTEP

END.
