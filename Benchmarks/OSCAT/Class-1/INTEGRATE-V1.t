PROC INTEGRATE_FIXED_TIME;
VAR
    INPUT       : BOOL;
    ENABLE      : BOOL;
    RESET       : BOOL;
    Accumulator : INT;
    TimeStep    : INT;
    ActiveCount : INT;
    i           : INT;  (* Loop variable *)
BEGIN

STEP 'FIXED_TIME_ACCUMULATION'
    TimeStep := 1;

    IF RESET THEN
        Accumulator := 0;
        ActiveCount := 0;
    ELSIF ENABLE THEN
        IF INPUT THEN
            ActiveCount := 5;  // Count for 5 cycles
        END

        (* Loop added to simulate repeated accumulation *)
        FOR i := 0 TO 4 DO
            IF ActiveCount > 0 THEN
                Accumulator := Accumulator + TimeStep;
                ActiveCount := ActiveCount - 1;
            END
        END_FOR;
    END
ENDSTEP

END.
