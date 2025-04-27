PROC FLOOR_BASIC;
VAR
    INPUT    : INT;
    THRESH   : INT;
    OUTPUT   : BOOL;
    i        : INT;  (* Loop variable *)
BEGIN

STEP 'FLOOR_COMPARISON'
    (* Loop added to check the condition multiple times *)
    FOR i := 0 TO 1 DO
        IF INPUT < THRESH THEN
            OUTPUT := TRUE;
        ELSE
            (* Additional IF ELSE inside the ELSE block *)
            IF INPUT = THRESH THEN
                OUTPUT := FALSE;  (* Handle case when input equals threshold *)
            ELSE
                OUTPUT := FALSE;  (* Handle case when input is greater than threshold *)
            END
        END
    END_FOR;
ENDSTEP

END.
