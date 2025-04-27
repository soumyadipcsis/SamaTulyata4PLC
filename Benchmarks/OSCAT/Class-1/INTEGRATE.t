PROC INTEGRATE_PROGRAM;
VAR
    INPUT    : BOOL;
    ENABLE   : BOOL;
    RESET    : BOOL;
    Accumulator : INT;
    TimeStep    : INT;  // Simulated time step per cycle (e.g., 1 unit per scan)
BEGIN

STEP 'INTEGRATION_LOGIC'
    TimeStep := 1;

    IF RESET THEN
        Accumulator := 0;
    ELSIF ENABLE AND INPUT THEN
        Accumulator := Accumulator + TimeStep;
    END

    // Optional limit to prevent overflow
    IF Accumulator > 32767 THEN
        Accumulator := 32767;
    END
ENDSTEP

END.
