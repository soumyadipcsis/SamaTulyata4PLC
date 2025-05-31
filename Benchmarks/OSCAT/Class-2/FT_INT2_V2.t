PROC FT_TN64_V2;
VAR
    IN : BOOL;
    OUT1 : BOOL;
    CNT : INT;
    DIR : BOOL;
    I : INT;
    J : INT;
    INIT : BOOL;
    TRIG : BOOL;
BEGIN
STEP 'NESTED_LOOP_SAMPLE_V3'
IF NOT INIT THEN
    CNT := 0;
    DIR := TRUE;
    INIT := TRUE;
    TRIG := FALSE;
ELSE
    I := 0;
    WHILE I < 2 DO
        J := 0;
        WHILE J < 2 DO
            IF DIR THEN
                CNT := CNT + 1;
            ELSE
                CNT := CNT - 1;
            END

            IF CNT >= 3 THEN
                DIR := FALSE;
            ELSE
                DIR := DIR;
            END

            IF CNT <= 0 THEN
                DIR := TRUE;
            ELSE
                DIR := DIR;
            END

            OUT1 := DIR;
            J := J + 1;
        END_WHILE;
        I := I + 1;
    END_WHILE;
    TRIG := TRUE;
END
ENDSTEP
END.
