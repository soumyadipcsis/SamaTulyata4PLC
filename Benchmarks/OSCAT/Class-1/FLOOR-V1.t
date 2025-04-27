PROC FLOOR_HYSTERESIS;
VAR
    INPUT     : INT;
    THRESH    : INT;
    HYST      : INT;  // e.g. 5 units of hysteresis
    OUTPUT    : BOOL;
BEGIN

STEP 'FLOOR_WITH_HYSTERESIS'
    IF OUTPUT THEN
        IF INPUT >= THRESH + HYST THEN
            OUTPUT := FALSE;
        END
    ELSE
        IF INPUT < THRESH THEN
            OUTPUT := TRUE;
        END
    END
ENDSTEP

END.
