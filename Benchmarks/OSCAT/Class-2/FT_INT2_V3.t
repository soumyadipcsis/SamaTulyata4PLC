PROC FT_TN64_V3;
VAR
    IN : BOOL;
    OUT1 : BOOL;
    CNT : INT;
    I : INT;
    J : INT;
    INIT : BOOL;
    TRIG : BOOL;
BEGIN
STEP 'NESTED_LOOP_SAMPLE_V4'
IF NOT INIT THEN
    CNT := 0;
    INIT := TRUE;
    TRIG := FALSE;
ELSE
    I := 0;
    WHILE I < 2 DO
        J := 0;
        WHILE J < 2 DO
            CNT := CNT + 1;

            IF CNT >= 6 THEN
                CNT := 0;
            ELSE
                CNT := CNT;
            END

            IF CNT MOD 3 = 0 THEN
                OUT1 := NOT IN;
            ELSE
                OUT1 := IN;
            END

            J := J + 1;
        END_WHILE;
        I := I + 1;
    END_WHILE;
    TRIG := TRUE;
END
ENDSTEP
END.
