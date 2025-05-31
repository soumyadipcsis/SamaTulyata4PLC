PROC PROGRAM0_VARIANT1;
VAR
    START : BOOL;
    STOP : BOOL;
    MASTERCOIL : BOOL;
    CONVEYOR : BOOL;
    LIGHTSOURCE : BOOL;
    LDR : BOOL;
    COILBITS : BOOL;
    BLOWERS : BOOL;
    TIMER : BOOL;
    I : INT;
    J : INT;
BEGIN
STEP 'CONTROL_LOGIC'
MASTERCOIL := NOT(STOP) AND (MASTERCOIL OR START);
CONVEYOR := MASTERCOIL;
LIGHTSOURCE := MASTERCOIL;

I := 0;
WHILE I < 3 DO
    J := 0;
    WHILE J < 3 DO
        COILBITS := (NOT TIMER) AND (COILBITS OR LDR);
        IF COILBITS THEN
            IF MASTERCOIL THEN
                BLOWERS := TRUE;
            ELSE
                BLOWERS := FALSE;
            END
        ELSE
            BLOWERS := FALSE;
        END
        J := J + 1;
    END_WHILE;
    I := I + 1;
END_WHILE;

ENDSTEP
END.
