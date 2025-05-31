PROC FT_TN64_V1;
VAR
    IN : BOOL;
    OUT1 : BOOL;
    CNT : INT;
    I : INT;
    J : INT;
    TRIG : BOOL;
    INIT : BOOL;
BEGIN
STEP 'NESTED_LOOP_SAMPLE_V1'
IF NOT INIT THEN
    CNT := 0;
    INIT := TRUE;
    TRIG := FALSE;
ELSE
    I := 0;
    WHILE I < 3 DO
        J := 0;
        WHILE J < 2 DO
            CNT := CNT + 1;

            IF CNT > 5 THEN
                CNT := 0;
            ELSE
                CNT := CNT;
            END

            IF CNT MOD 2 = 0 THEN
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
