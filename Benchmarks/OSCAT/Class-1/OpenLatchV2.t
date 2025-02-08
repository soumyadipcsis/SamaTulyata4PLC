PROC program0;
VAR
    SW1 : BOOL;
    SW2 : BOOL;
    Latch : BOOL;
    Unlatch : BOOL;
    DelayCounter : INTEGER;
    Counter : INTEGER;

BEGIN
STEP 'LATCH_UNLATCH_LOGIC'
    IF SW1 THEN
        Latch := TRUE;
        DelayCounter := 0;
    END

    IF SW2 THEN
        FOR DelayCounter := 1 TO 5 DO
            (* Keep Latch active for some time after SW2 is pressed *)
        END
        Latch := FALSE;
    END

    Unlatch := SW2;
ENDSTEP

END.
