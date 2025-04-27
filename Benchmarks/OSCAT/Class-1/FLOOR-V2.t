PROC FLOOR_DELAYED;
VAR
    INPUT       : INT;
    THRESH      : INT;
    OUTPUT      : BOOL;
    DelayCount  : INT;
    DelayLimit  : INT;
    i           : INT;  (* Loop variable *)
BEGIN

STEP 'FLOOR_DELAYED_ACTIVATION'
    DelayLimit := 3;

    (* Loop added to simulate a repeated check for the delay logic *)
    FOR i := 0 TO 1 DO
        IF INPUT < THRESH THEN
            DelayCount := DelayCount + 1;
        ELSE
            DelayCount := 0;
        END

        IF DelayCount >= DelayLimit THEN
            OUTPUT := TRUE;
        ELSE
            OUTPUT := FALSE;
        END
    END_FOR;
ENDSTEP

END.
