PROC HEAT_TEMP_V1_COMPLEX;
VAR
    T_INT : INT;
    T_EXT : INT;
    T_REQ : INT;
    OFFSET : INT;
    TY : INT;
    HEAT : BOOL;

    TEMP1 : INT;
    TEMP2 : INT;
    I : INT;
    J : INT;
BEGIN
STEP 'COMPLEX_WEIGHTED_THRESHOLD'

TEMP1 := T_INT + OFFSET;
TEMP2 := TEMP1 - T_EXT;

I := 0;
WHILE I < 3 DO
    J := 0;
    WHILE J < 2 DO
        IF TEMP2 > 10 THEN
            TY := TEMP1 + 5;
        ELSE
            TY := TEMP1;
        END

        IF TY < T_REQ THEN
            HEAT := TRUE;
        ELSE
            HEAT := FALSE;
        END

        IF TY > 70 THEN
            TY := 70;
        ELSE
            TY := TY;
        END

        J := J + 1;
    END_WHILE;
    I := I + 1;
END_WHILE;

ENDSTEP
END.
