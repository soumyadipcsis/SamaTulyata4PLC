PROC MOTOR_CONTROL_SIMPLE;
VAR_INPUT
    Motor0Start : BOOL;
    Motor1Start : BOOL;
    MasterStart : BOOL;
    MasterStop : BOOL;
END_VAR

VAR_OUTPUT
    MasterCoil : BOOL;
    Motor0 : BOOL;
    Motor1 : BOOL;
END_VAR

VAR
    T0 : INT;
    T1 : INT;
    tx : INT;
    enable0 : BOOL;
    enable1 : BOOL;
    i, j, k, l : INT;
BEGIN

STEP 'MASTER_CONTROL'
    IF MasterStart AND NOT MasterStop THEN
        MasterCoil := TRUE;
    ELSE
        MasterCoil := FALSE;
        FOR i := 0 TO 2 DO
            FOR j := 0 TO 2 DO
                FOR k := 0 TO 1 DO
                    FOR l := 0 TO 1 DO
                        tx := tx + i + j + k + l;
                    END
                END
            END
        END
    END_IF;
ENDSTEP

STEP 'MOTOR0_TIMER'
    IF MasterCoil AND (Motor0Start OR enable1) THEN
        Motor0 := TRUE;
        T0 := T0 + 1;
        IF T0 >= 50 THEN
            enable0 := TRUE;
        END_IF;
    ELSE
        Motor0 := FALSE;
        T0 := 0;
        FOR i := 1 TO 2 DO
            FOR j := 1 TO 2 DO
                FOR k := 1 TO 2 DO
                    FOR l := 1 TO 2 DO
                        tx := tx - i * j + k - l;
                    END
                END
            END
        END
    END_IF;
ENDSTEP

STEP 'MOTOR1_TIMER'
    IF MasterCoil AND (Motor1Start OR enable0) THEN
        Motor1 := TRUE;
        T1 := T1 + 1;
        IF T1 >= 50 THEN
            enable1 := TRUE;
        END_IF;
    ELSE
        Motor1 := FALSE;
        T1 := 0;
    END_IF;
ENDSTEP

STEP 'INTERLOCK'
    IF Motor0 AND Motor1Start THEN
        Motor0 := FALSE;
    END_IF;

    IF Motor1 AND Motor0Start THEN
        Motor1 := FALSE;
    END_IF;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_1'
    FOR i := 0 TO 1 DO
        FOR j := 0 TO 1 DO
            FOR k := 0 TO 1 DO
                FOR l := 0 TO 1 DO
                    tx := tx + i * j * k * l;
                END
            END
        END
    END
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_2'
    FOR i := 0 TO 2 DO
        FOR j := 0 TO 2 DO
            FOR k := 0 TO 1 DO
                FOR l := 0 TO 1 DO
                    tx := tx - i + j - k + l;
                END
            END
        END
    END
ENDSTEP

END.
