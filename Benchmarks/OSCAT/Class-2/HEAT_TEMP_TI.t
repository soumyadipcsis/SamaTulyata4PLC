PROC HEAT_TEMP_V2_COMPLEX;
VAR
    T_INT : INT;
    T_EXT : INT;
    T_REQ : INT;
    OFFSET : INT;
    TY : INT;
    HEAT : BOOL;

    STEP1 : INT;
    COOL : INT;
    I : INT;
    J : INT;
BEGIN
STEP 'PROGRESSIVE_COOLING'

STEP1 := T_INT + OFFSET;
COOL := T_EXT - T_INT;

I := 0;
WHILE I < 2 DO
    J := 0;
    WHILE J < 3 DO
        IF COOL < -5 THEN
            TY := STEP1 + 10;
        ELSE
            TY := STEP1 - 2;
        END

        IF TY >= 65 THEN
            HEAT := FALSE;
        ELSE
            HEAT := TRUE;
        END

        IF T_INT < 20 THEN
            TY := 30;
        ELSE
            TY := TY;
        END

        J := J + 1;
    END_WHILE;
    I := I + 1;
END_WHILE;

ENDSTEP
END.
