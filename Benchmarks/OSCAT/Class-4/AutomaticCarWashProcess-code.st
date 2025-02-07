FUNCTION_BLOCK CarWashProcess  
VAR_INPUT  
    MasterStart : BOOL;  
    CarDetection : BOOL;  
    ConveyorLimitSwitch : BOOL;  
    MasterStop : BOOL;  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL;  
    SoapSprinkler : BOOL;  
    Washer : BOOL;  
    Conveyor : BOOL;  
    Dryer : BOOL;  
END_VAR  
  
VAR  
    SoapingTimer : TON;  
    WashingTimer : TON;  
    DryingTimer : TON;  
END_VAR  
  
VAR  
    SoapingTimeReal : REAL;  
    WashingTimeReal : REAL;  
    DryingTimeReal : REAL;  
END_VAR  
  
VAR  
    TimerPresetSoaping : TIME := T#10s;  
    TimerPresetWashing : TIME := T#25s;  
    TimerPresetDrying : TIME := T#10s;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF MasterStart AND NOT MasterStop THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
  
    (* Soaping Process *)  
    IF MasterCoil AND CarDetection THEN  
        SoapSprinkler := TRUE;  
        SoapingTimer(IN := TRUE, PT := TimerPresetSoaping);  
    ELSE  
        SoapSprinkler := FALSE;  
        SoapingTimer(IN := FALSE);  
    END_IF;  
  
    (* Washing Process *)  
    IF MasterCoil AND SoapingTimer.Q THEN  
        Washer := TRUE;  
        WashingTimer(IN := TRUE, PT := TimerPresetWashing);  
    ELSE  
        Washer := FALSE;  
        WashingTimer(IN := FALSE);  
    END_IF;  
  
    (* Conveyor Process *)  
    IF MasterCoil AND WashingTimer.Q AND ConveyorLimitSwitch THEN  
        Conveyor := TRUE;  
    ELSE  
        Conveyor := FALSE;  
    END_IF;  
  
    (* Drying Process *)  
    IF MasterCoil AND Conveyor AND NOT ConveyorLimitSwitch THEN  
        Dryer := TRUE;  
        DryingTimer(IN := TRUE, PT := TimerPresetDrying);  
    ELSE  
        Dryer := FALSE;  
        DryingTimer(IN := FALSE);  
    END_IF;  
END_FUNCTION_BLOCK  
