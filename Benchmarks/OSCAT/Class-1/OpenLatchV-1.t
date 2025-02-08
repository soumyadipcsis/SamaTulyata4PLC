PROC program0;
VAR
    SW1 : BOOL;
    SW2 : BOOL;
    Latch : BOOL;
    Unlatch : BOOL;
    ToggleState : BOOL;
    Counter : INTEGER;

BEGIN
STEP 'LATCH_UNLATCH_LOGIC'
    IF SW1 THEN
        ToggleState := SW1;
    END

    Latch := ToggleState;
    Unlatch := SW2;

    FOR Counter := 1 TO 5 DO
        IF SW1 THEN
            Latch := TRUE;
        END
    END
ENDSTEP

END.
