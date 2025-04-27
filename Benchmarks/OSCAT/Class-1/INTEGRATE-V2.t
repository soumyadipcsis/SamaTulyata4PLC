PROC INTEGRATE_EDGE;
VAR
    INPUT       : BOOL;
    ENABLE      : BOOL;
    RESET       : BOOL;
    Accumulator : INT;
    TimeStep    : INT;

    PrevInput   : BOOL;
BEGIN

STEP 'EDGE_BASED_INTEGRATION'
    TimeStep := 1;

    IF RESET THEN
        Accumulator := 0;
    ELSIF ENABLE AND (INPUT AND NOT PrevInput) THEN
        Accumulator := Accumulator + TimeStep;
    END

    PrevInput := INPUT;
ENDSTEP

END.
