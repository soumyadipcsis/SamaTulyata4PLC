PROC FT_TN64_V1;
VAR
    IN : BOOL;
    OUT1 : BOOL;
    CNT : INT;
    I : INT;
    J : INT;
    INIT : BOOL;
    TRIG : BOOL;
BEGIN
STEP 'NESTED_LOOP_SAMPLE_V2'
IF NOT INIT THEN
    CNT := 0;
    TRIG := FALSE;
    INIT := TRUE;
ELSE
    I := 0;
    WHILE I < 2 DO
        J := 0;
        WHILE J < 3 DO
            IF CNT = 3 THEN
                CNT := 0;
            ELSE
                CNT := CNT + 1;
            END

            IF CNT = 1 THEN
                OUT1 := IN;
            ELSE
                OUT1 := NOT IN;
            END

            J := J + 1;
        END_WHILE;
        I := I + 1;
    END_WHILE;
    TRIG := TRUE;
END
ENDSTEP
END.
