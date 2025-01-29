PROC RatioControl;
VAR
    // Control Mode & Process State
    ManualButton : BOOLEAN; AutoButton : BOOLEAN;
    Mode : INTEGER := 0; AutoProcess : BOOLEAN := FALSE;

    // Process Variables (Flow Rates)
    PrimaryFlow : INTEGER; SecondaryFlow : INTEGER;
    TargetRatio : INTEGER; ActualRatio : INTEGER;

    // Actuators & Outputs
    SecondaryValve : INTEGER; PrimaryValve : INTEGER;
    
    // Setpoints
    SP_PrimaryFlow : INTEGER; SP_SecondaryFlow : INTEGER;
    
    // Integer-Based Ratio Control
    Kp_Ratio, Ti_Ratio, Td_Ratio : INTEGER;
    e_Ratio, e_Ratio_prev : INTEGER;
    P_Ratio, I_Ratio, D_Ratio : INTEGER;
    Integral_Ratio : INTEGER; Derivative_Ratio : INTEGER;

    // Safety & Interlocks
    Emergency_Stop : BOOLEAN; Alarm_HighFlow : BOOLEAN;
    Alarm_LowFlow : BOOLEAN;

    // Temporary Integer Variables
    TempValue1 : INTEGER; TempValue2 : INTEGER;
    LocalValue : INTEGER; I : INTEGER := 0;
    CustomScaling : INTEGER;

BEGIN
STEP 'EXECUTE_RATIO_CONTROL'
IF ManualButton THEN
    Mode := 0; // Set mode to manual

IF Mode = 0 THEN // Manual Mode
BEGIN
    SecondaryValve := 0;
    PrimaryValve := 0;
END

IF AutoButton THEN
    Mode := 1;

IF Mode = 1 THEN // Auto Mode
BEGIN
    IF Emergency_Stop THEN
    BEGIN
        SecondaryValve := 0;
        PrimaryValve := 0;
        AutoProcess := FALSE;
    END
    ELSE IF NOT AutoProcess THEN
    BEGIN
        // ****************** RATIO CONTROL LOGIC ******************
        
        // Compute Actual Ratio (Integer-Based Division)
        IF PrimaryFlow > 0 THEN
            ActualRatio := (SecondaryFlow * 100) / PrimaryFlow;
        ELSE
            ActualRatio := 0; // Prevent division by zero
        END

        // Compute Error (Deviation from Target Ratio)
        e_Ratio := TargetRatio - ActualRatio;

        // Proportional Term
        P_Ratio := Kp_Ratio * e_Ratio;

        // Integral Term with Anti-Windup
        TempValue1 := e_Ratio * Ti_Ratio;  // Integer multiplication
        TempValue1 := TempValue1 / 100;    // Scale down to prevent overflow
        IF ABS(Integral_Ratio) < 10000 THEN
            Integral_Ratio := Integral_Ratio + TempValue1;
        END
        I_Ratio := Integral_Ratio;

        // Derivative Term
        TempValue2 := e_Ratio - e_Ratio_prev;
        TempValue2 := (TempValue2 * 100) / Td_Ratio;  // Integer division
        D_Ratio := (Td_Ratio * TempValue2) / 100;

        // Compute Output for Secondary Valve
        SecondaryValve := P_Ratio + I_Ratio + D_Ratio;

        // Apply Output Limits
        IF SecondaryValve > 100 THEN
            SecondaryValve := 100;
        ELSE
            IF SecondaryValve < 0 THEN
                SecondaryValve := 0;
        END

        // Store Previous Error
        e_Ratio_prev := e_Ratio;

        // ****************** SAFETY ALARMS ******************
        IF PrimaryFlow > (SP_PrimaryFlow + 50) THEN
            Alarm_HighFlow := TRUE;
        ELSE
            Alarm_HighFlow := FALSE;
        END

        IF SecondaryFlow < (SP_SecondaryFlow - 10) THEN
            Alarm_LowFlow := TRUE;
        ELSE
            Alarm_LowFlow := FALSE;
        END

        // Mark Process Active
        AutoProcess := TRUE;
    END

    // **************** POST-CONTROL SCALING ****************
    IF AutoProcess THEN
    BEGIN
        WHILE (I < LocalValue) DO
        BEGIN
            SecondaryValve := SecondaryValve * 10;
            PrimaryValve := PrimaryValve / 10;
            I := I + 1;
        END
        CustomScaling := SecondaryValve + PrimaryValve;
        
        // Reset Process
        AutoProcess := FALSE;
    END
END
ENDSTEP

END.
