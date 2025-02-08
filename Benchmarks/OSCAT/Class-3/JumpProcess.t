FUNCTION_BLOCK JumpProcess  
VAR_INPUT  
    ManualInput : BOOL; (* Input to Jump to Label *)  
    InputA : BOOL; (* Input A *)  
    InputB : BOOL; (* Input B *)  
    InputC : BOOL; (* Input C *)  
    SensorInput : BOOL; (* Sensor Input *)  
END_VAR  
  
VAR_OUTPUT  
    Output0 : BOOL; (* Output 0 *)  
    Output1 : BOOL; (* Output 1 *)  
    Output2 : BOOL; (* Output 2 *)  
    Output3 : BOOL; (* Output 3 *)  
END_VAR  
  
VAR  
    Jump : BOOL; (* Jump Control *)  
END_VAR  
  
BEGIN  
    (* Jump Control *)  
    IF ManualInput THEN  
        Jump := TRUE;  
    ELSE  
        Jump := FALSE;  
    END_IF;  
  
    (* Outputs Control *)  
    IF NOT Jump THEN  
        (* Normal operation *)  
        IF InputA THEN  
            Output0 := TRUE;  
        ELSE  
            Output0 := FALSE;  
        END_IF;  
  
        IF InputB THEN  
            Output1 := TRUE;  
        ELSE  
            Output1 := FALSE;  
        END_IF;  
  
        IF InputC THEN  
            Output2 := TRUE;  
        ELSE  
            Output2 := FALSE;  
        END_IF;  
    END_IF;  
  
    (* Jump to Label *)  
    IF Jump THEN  
        IF SensorInput THEN  
            Output3 := TRUE;  
        ELSE  
            Output3 := FALSE;  
        END_IF;  
    END_IF;  
END_FUNCTION_BLOCK  
