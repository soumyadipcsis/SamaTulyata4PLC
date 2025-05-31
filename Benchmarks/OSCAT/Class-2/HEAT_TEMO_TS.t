PROC HEAT_TEMP_V3_COMPLEX;
VAR
    T_INT : INT;
    T_EXT : INT;
    OFFSET : INT;
    T_REQ : INT;
    TY : INT;
    HEAT : BOOL;

    LOAD : INT;
    I : INT;
    J : INT;
BEGIN
STEP 'LOAD_ADAPTIVE_LOGIC'

LOAD := (T_INT + OFFSET) - T_EXT;

I := 0;
WHILE I < 3 DO
    J := 0;
    WHILE J < 2 DO
        IF LOAD > 15 THEN
            TY := T_REQ + 8;
        ELSE
            TY := T_REQ - 3;
        END

        IF TY > 68 THEN
            HEAT := FALSE;
        ELSE
            HEAT := TRUE;
        END

        IF HEAT THEN
            TY := TY + 2;
        ELSE
            TY := TY - 2;
        END

        J := J + 1;
    END_WHILE;
    I := I + 1;
END_WHILE;

ENDSTEP
END.
(* Loop Addaptive Mode*)
