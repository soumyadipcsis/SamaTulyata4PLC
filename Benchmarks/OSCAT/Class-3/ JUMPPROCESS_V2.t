PROC JUMPPROCESS_V2;
VAR
    ManualInput, InputA, InputB, InputC, SensorInput : BOOL;
    Output0, Output1, Output2, Output3 : BOOL;
    Jump : BOOL;
    i, j, prod1, prod2 : INT;
BEGIN

prod1 := 1; prod2 := 1;
FOR i := 0 TO 1 DO prod1 := prod1 * (i + 2); END_FOR
FOR j := 0 TO 1 DO prod2 := prod2 * (j + 3); END_FOR

IF ManualInput THEN
    Jump := TRUE;
ELSE
    Jump := FALSE;
END_IF;

IF NOT Jump THEN
    IF InputA THEN Output0 := TRUE; ELSE Output0 := FALSE; END_IF;
    IF InputB THEN Output1 := TRUE; ELSE Output1 := FALSE; END_IF;
    IF InputC THEN Output2 := TRUE; ELSE Output2 := FALSE; END_IF;
END_IF;

IF Jump THEN
    FOR i := 0 TO 1 DO
        FOR j := 1 TO 1 DO
            Output3 := SensorInput AND (prod1 > 0) AND (prod2 > 0);
        END_FOR
    END_FOR
END_IF;

END.
