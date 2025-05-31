PROC PROGRAM0_VARIANT5;
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
    ACTIVE_ZONE : BOOL;
    OVERRIDE : BOOL;
BEGIN
STEP 'CONTROL_LOGIC_COMPLEX'
MASTERCOIL := (START OR MASTERCOIL) AND (NOT STOP);
CONVEYOR := MASTERCOIL;
LIGHTSOURCE := MASTERCOIL;

(* Simulate zone logic with flags *)
ACTIVE_ZONE := FALSE;
OVERRIDE := FALSE;

I := 0;
WHILE I < 3 DO
    J := 0;
    WHILE J < 2 DO
        IF (MASTERCOIL AND LDR) THEN
            COILBITS := TRUE;
            ACTIVE_ZONE := TRUE;
        ELSE
            COILBITS := FALSE;
        END

        IF TIMER THEN
            OVERRIDE := TRUE;
        ELSE
            OVERRIDE := FALSE;
        END

        IF (COILBITS AND NOT OVERRIDE) THEN
            BLOWERS := TRUE;
        ELSE
            BLOWERS := FALSE;
        END

        J := J + 1;
    END_WHILE;
    I := I + 1;
END_WHILE;

ENDSTEP
END.
