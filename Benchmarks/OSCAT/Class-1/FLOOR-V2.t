PROC FLOOR_DELAYED;
VAR
    INPUT       : INT;
    THRESH      : INT;
    OUTPUT      : BOOL;
    DelayCount  : INT;
    DelayLimit  : INT;
BEGIN

STEP 'FLOOR_DELAYED_ACTIVATION'
    DelayLimit := 3;

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
ENDSTEP

END.
