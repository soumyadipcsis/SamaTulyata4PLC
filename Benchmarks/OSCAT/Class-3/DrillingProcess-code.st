FUNCTION_BLOCK DrillingProcess  
VAR_INPUT  
    Start : BOOL;  
    Stop : BOOL;  
    ObjectDetect : BOOL;  
    LowerLimit : BOOL;  
    UpperLimit : BOOL;  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL;  
    ClampingDevice : BOOL;  
    DrillingMotor : BOOL;  
    MotorDown : BOOL;  
    MotorUp : BOOL;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF Start AND NOT Stop THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
  
    (* Clamping and Drilling Control *)  
    IF MasterCoil AND ObjectDetect AND NOT UpperLimit THEN  
        ClampingDevice := TRUE;  
        MotorDown := TRUE;  
        IF LowerLimit THEN  
            ClampingDevice := FALSE;  
            MotorDown := FALSE;  
            DrillingMotor := FALSE;  
        ELSE  
            DrillingMotor := TRUE;  
        END_IF;  
    ELSE  
        ClampingDevice := FALSE;  
        MotorDown := FALSE;  
        DrillingMotor := FALSE;  
    END_IF;  
  
    (* Motor Up Control *)  
    IF MasterCoil AND LowerLimit AND NOT UpperLimit THEN  
        MotorUp := TRUE;  
    ELSE  
        MotorUp := FALSE;  
    END_IF;  
END_FUNCTION_BLOCK  
