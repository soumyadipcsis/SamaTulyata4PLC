PROC FLOOR_HYSTERESIS;
VAR
    INPUT   : INT;
    THRESH  : INT;
    HYST    : INT;   // e.g. 5 units of hysteresis
    OUTPUT  : BOOL;
    i       : INT;   // Loop variable
BEGIN

STEP 'FLOOR_WITH_HYSTERESIS'
    FOR i := 0 TO 1 DO  (* Loop added to check the hysteresis logic multiple times *)
        IF OUTPUT THEN
            IF INPUT >= THRESH + HYST THEN
                OUTPUT := FALSE;
            END
        ELSE
            IF INPUT < THRESH THEN
                OUTPUT := TRUE;
            END
        END
    END_FOR;
ENDSTEP

END.
