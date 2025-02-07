FUNCTION_BLOCK MotorControl  
VAR_INPUT  
    Motor0Start : BOOL;  
    Motor1Start : BOOL;  
    MasterStart : BOOL;  
    MasterStop : BOOL;  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL;  
    Motor0 : BOOL;  
    Motor1 : BOOL;  
END_VAR  
  
VAR  
    Motor0Timer : TON;  
    Motor1Timer : TON;  
END_VAR  
  
VAR  
    Motor0TimeReal : REAL;  
    Motor1TimeReal : REAL;  
END_VAR  
  
VAR  
    TimerPresetMotor0 : TIME := T#5s;  
    TimerPresetMotor1 : TIME := T#5s;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF MasterStart AND NOT MasterStop THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
  
    (* Motor0 Control *)  
    IF MasterCoil AND (Motor0Start OR Motor1Timer.Q) THEN  
        Motor0 := TRUE;  
        Motor0Timer(IN := TRUE, PT := TimerPresetMotor0);  
    ELSE  
        Motor0 := FALSE;  
        Motor0Timer(IN := FALSE);  
    END_IF;  
  
    (* Motor1 Control *)  
    IF MasterCoil AND (Motor1Start OR Motor0Timer.Q) THEN  
        Motor1 := TRUE;  
        Motor1Timer(IN := TRUE, PT := TimerPresetMotor1);  
    ELSE  
        Motor1 := FALSE;  
        Motor1Timer(IN := FALSE);  
    END_IF;  
  
    (* Interlocking Control *)  
    IF Motor0 AND Motor1Start THEN  
        Motor0 := FALSE;  
    END_IF;  
  
    IF Motor1 AND Motor0Start THEN  
        Motor1 := FALSE;  
    END_IF;  
END_FUNCTION_BLOCK  
