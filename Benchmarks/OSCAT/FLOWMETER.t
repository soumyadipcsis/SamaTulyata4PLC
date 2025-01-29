PROC FlowmeterControl;
VAR
    // Flowmeter Readings (Integer Only)
    FlowRate : INTEGER; // Current flow rate
    FlowSetpoint : INTEGER; // Desired flow rate
    FlowCorrection : INTEGER; // Correction value
    ValveControl : INTEGER; // Valve position control
    Kp_Flow, Ti_Flow, Td_Flow : INTEGER;
    e_Flow, e_Flow_prev : INTEGER;
    P_Flow, I_Flow, D_Flow : INTEGER;
    Integral_Flow : INTEGER; Derivative_Flow : INTEGER;
    Alarm_HighFlow : BOOLEAN;
    Alarm_LowFlow : BOOLEAN;
    TempValue1 : INTEGER; TempValue2 : INTEGER;

BEGIN
STEP 'EXECUTE_FLOWMETER'
    // ****************** FLOW MEASUREMENT ******************
    IF FlowRate > (FlowSetpoint + 50) THEN
        Alarm_HighFlow := TRUE;
    ELSE
        Alarm_HighFlow := FALSE;
    END

    IF FlowRate < (FlowSetpoint - 10) THEN
        Alarm_LowFlow := TRUE;
    ELSE
        Alarm_LowFlow := FALSE;
    END

    // ****************** FLOW CONTROL (PID) ******************
    e_Flow := FlowSetpoint - FlowRate;

    // Proportional Term
    P_Flow := Kp_Flow * e_Flow;

    // Integral Term with Anti-Windup
    TempValue1 := e_Flow * Ti_Flow;
    TempValue1 := TempValue1 / 100;
    IF ABS(Integral_Flow) < 10000 THEN
        Integral_Flow := Integral_Flow + TempValue1;
    END
    I_Flow := Integral_Flow;

    // Derivative Term
    TempValue2 := e_Flow - e_Flow_prev;
    TempValue2 := (TempValue2 * 100) / Td_Flow;
    D_Flow := (Td_Flow * TempValue2) / 100;

    // Compute Output for Valve Control
    ValveControl := P_Flow + I_Flow + D_Flow;

    // Apply Output Limits
    IF ValveControl > 100 THEN
        ValveControl := 100;
    ELSE
        IF ValveControl < 0 THEN
            ValveControl := 0;
    END

    // Store Previous Error
    e_Flow_prev := e_Flow;
ENDSTEP

END.
