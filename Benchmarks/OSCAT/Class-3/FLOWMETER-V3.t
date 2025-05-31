PROC FlowmeterControl_V3;
VAR
    FlowRate : INTEGER;
    FlowSetpoint : INTEGER;
    ValveControl : INTEGER;
    Kp_Flow, Ti_Flow, Td_Flow : INTEGER;
    e_Flow, e_Flow_prev : INTEGER;
    P_Flow, I_Flow, D_Flow : INTEGER;
    Integral_Flow : INTEGER;
    Alarm_HighFlow : BOOLEAN;
    Alarm_LowFlow : BOOLEAN;
    Temp : INTEGER;
    a, b, x, y : INTEGER;
BEGIN

STEP 'DATA_LOOP_1'
    FOR a := 1 TO 2 DO
        Temp := a * 6;
    END_FOR
ENDSTEP

STEP 'DATA_LOOP_2'
    FOR b := 2 TO 4 DO
        Temp := b - 2;
    END_FOR
ENDSTEP

STEP 'EXECUTE_FLOWMETER'
    IF FlowRate > FlowSetpoint + 40 THEN
        Alarm_HighFlow := TRUE;
    ELSE
        Alarm_HighFlow := FALSE;
    END

    IF FlowRate < FlowSetpoint - 20 THEN
        Alarm_LowFlow := TRUE;
    ELSE
        Alarm_LowFlow := FALSE;
    END

    e_Flow := FlowSetpoint - FlowRate;

    FOR x := 0 TO 2 DO
        FOR y := 0 TO 0 DO
            P_Flow := Kp_Flow * e_Flow;
        END_FOR
    END_FOR

    Temp := e_Flow * Ti_Flow / 100;
    IF ABS(Integral_Flow) < 10000 THEN
        Integral_Flow := Integral_Flow + Temp;
    END
    I_Flow := Integral_Flow;

    D_Flow := (Td_Flow * (e_Flow - e_Flow_prev)) / 100;

    ValveControl := P_Flow + I_Flow + D_Flow;
    IF ValveControl > 100 THEN
        ValveControl := 100;
    ELSE
        IF ValveControl < 0 THEN
            ValveControl := 0;
        END
    END

    e_Flow_prev := e_Flow;
ENDSTEP

END.
