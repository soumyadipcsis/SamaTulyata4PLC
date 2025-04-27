PROC INTEGRATE_FIXED_TIME;
VAR
    INPUT       : BOOL;
    ENABLE      : BOOL;
    RESET       : BOOL;
    Accumulator : INT;
    TimeStep    : INT;
    ActiveCount : INT;
BEGIN

STEP 'FIXED_TIME_ACCUMULATION'
    TimeStep := 1;

    IF RESET THEN
        Accumulator := 0;
        ActiveCount := 0;
    ELSIF ENABLE THEN
        IF INPUT THEN
            ActiveCount := 5; // count for 5 cycles
        END

        IF ActiveCount > 0 THEN
            Accumulator := Accumulator + TimeStep;
            ActiveCount := ActiveCount - 1;
        END
    END
ENDSTEP

END.
