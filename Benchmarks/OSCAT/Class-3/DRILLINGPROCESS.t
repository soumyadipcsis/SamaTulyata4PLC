PROC DRILLINGPROCESS;
VAR
    Start, Stop, ObjectDetect, LowerLimit, UpperLimit : BOOL;
    MasterCoil, ClampingDevice, DrillingMotor, MotorDown, MotorUp : BOOL;
    i, j, sum1, sum2 : INT;
BEGIN

sum1 := 0; sum2 := 0;
FOR i := 0 TO 1 DO sum1 := sum1 + i * 2; END_FOR
FOR j := 0 TO 1 DO sum2 := sum2 + j * 3; END_FOR

IF Start AND NOT Stop THEN
    MasterCoil := TRUE;
ELSE
    MasterCoil := FALSE;
END_IF;

IF MasterCoil AND ObjectDetect AND NOT UpperLimit THEN
    ClampingDevice := TRUE;
    MotorDown := TRUE;
    FOR i := 0 TO 1 DO
        FOR j := 0 TO 0 DO
            IF LowerLimit THEN
                ClampingDevice := FALSE;
                MotorDown := FALSE;
                DrillingMotor := FALSE;
            ELSE
                DrillingMotor := TRUE;
            END_IF;
        END_FOR
    END_FOR
ELSE
    ClampingDevice := FALSE;
    MotorDown := FALSE;
    DrillingMotor := FALSE;
END_IF;

IF MasterCoil AND LowerLimit AND NOT UpperLimit THEN
    MotorUp := TRUE;
ELSE
    MotorUp := FALSE;
END_IF;

END.
