PROC STAMPING_OPERATION;
VAR_INPUT
    StartButton, StopButton, LS1, LS2, LS3, LSDN, LSUP : BOOL;
END_VAR

VAR_OUTPUT
    CR1, CR2, CR3, CR4, UP_MOTOR, DN_MOTOR, MOTOR : BOOL;
END_VAR

VAR
    CR : BOOL; TimerTick, StartTime : UDINT;
    TimerActive, i : INT;
END_VAR

BEGIN

STEP 'LATCH_CR'
    IF StartButton AND LS1 THEN CR := TRUE; 
    IF StopButton THEN CR := FALSE; 
ENDSTEP

STEP 'RUNG_000' 
    CR1 := CR;
ENDSTEP

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'RUNG_001'
            IF CR AND NOT (LS2 OR LS3) THEN MOTOR := TRUE; ELSE MOTOR := FALSE;
        ENDSTEP
        STEP 'RUNG_002'
            CR2 := LS1 OR LS3;
        ENDSTEP
    END_FOR
ENDPARALLEL

STEP 'RUNG_003'
    CR3 := LS1 OR CR2 OR CR4;
ENDSTEP

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'RUNG_004'
            IF CR3 THEN UP_MOTOR := TRUE; ELSE IF LSUP THEN UP_MOTOR := FALSE; END;
        ENDSTEP
        STEP 'RUNG_005'
            CR4 := LSDN AND LS3;
        ENDSTEP
    END_FOR
ENDPARALLEL

STEP 'RUNG_006'
    DN_MOTOR := LS2 OR (CR4 AND CR2);
ENDSTEP

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'RUNG_007'
            IF LS1 AND LSDN THEN MOTOR := TRUE; ELSE MOTOR := FALSE;
        ENDSTEP
        STEP 'RUNG_008'
            (* Additional parallel logic can be added here *)
        ENDSTEP
    END_FOR
ENDPARALLEL

END
