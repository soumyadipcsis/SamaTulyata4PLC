PROC JUMPPROCESS;
VAR
    ManualInput, InputA, InputB, InputC, SensorInput : BOOL;
    Output0, Output1, Output2, Output3 : BOOL;
    Jump : BOOL;
    i, j, sum1, sum2 : INT;
BEGIN

sum1 := 0; sum2 := 0;
FOR i := 0 TO 1 DO sum1 := sum1 + i * 3; END_FOR
FOR j := 0 TO 1 DO sum2 := sum2 + j * 2; END_FOR

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
        FOR j := 0 TO 0 DO
            IF SensorInput THEN Output3 := TRUE; ELSE Output3 := FALSE; END_IF;
        END_FOR
    END_FOR
END_IF;

END.
