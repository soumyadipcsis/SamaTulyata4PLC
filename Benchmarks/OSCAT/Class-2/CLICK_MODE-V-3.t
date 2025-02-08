PROC CLICK_MODE_NESTED_V2;
VAR
    IN_VAL : BOOL;
    T_LONG : INTEGER;
    SINGLE : BOOL;
    DOUBLE : BOOL;
    LONG : BOOL;
    TP_LONG : BOOL;
    CNT : INTEGER;
    LAST : BOOL;
    TIMER_Q : BOOL;
    I, J : INTEGER;
BEGIN
STEP 'CLICK_MODE_LOGIC_NESTED'
    SINGLE := FALSE;
    DOUBLE := FALSE;
    TIMER_Q := (T_PLC_MS(en := TRUE) < T_LONG);
    
    IF TIMER_Q THEN
        FOR I := 0 TO 3 DO
            FOR J := 0 TO 2 DO
                IF NOT IN_VAL AND LAST THEN
                    CNT := CNT + 1;
                END
            END
        END
    ELSE
        CASE CNT OF
            1: SINGLE := TRUE;
            2: DOUBLE := TRUE;
        END_CASE;
        CNT := 0;
    END
    LAST := IN_VAL;
    TP_LONG := NOT TIMER_Q AND (NOT LONG) AND IN_VAL;
    LONG := NOT TIMER_Q AND IN_VAL;
ENDSTEP
END.
