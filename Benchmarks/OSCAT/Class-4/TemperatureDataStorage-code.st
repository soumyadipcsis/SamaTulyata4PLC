FUNCTION_BLOCK TemperatureDataStorage  
VAR_INPUT  
    StartPB : BOOL; (* Start PB *)  
    StopPB : BOOL; (* Stop PB *)  
    TempInput1 : INT; (* Input from temperature transmitter 1 *)  
    TempInput2 : INT; (* Input from temperature transmitter 2 *)  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL; (* Master coil *)  
    Temp1InC : INT; (* Temperature 1 in Centigrade *)  
    Temp2InC : INT; (* Temperature 2 in Centigrade *)  
END_VAR  
  
VAR  
    Timer : TON;  
    TempRegister1 : INT;  
    TempRegister2 : INT;  
    UpdateTimer : BOOL;  
END_VAR  
  
VAR  
    TimerPreset : TIME := T#5s;  
    TempReal1 : REAL;  
    TempReal2 : REAL;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF StartPB AND NOT StopPB THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
  
    (* Timer Control *)  
    IF MasterCoil THEN  
        Timer(IN := TRUE, PT := TimerPreset);  
    ELSE  
        Timer(IN := FALSE);  
    END_IF;  
  
    (* Temperature Conversion *)  
    TempRegister1 := TempInput1;  
    TempRegister2 := TempInput2;  
  
    TempReal1 := TIME_TO_REAL(TempRegister1);  
    TempReal2 := TIME_TO_REAL(TempRegister2);  
  
    Temp1InC := REAL_TO_INT(TempReal1 / 82.0);  
    Temp2InC := REAL_TO_INT(TempReal2 / 82.0);  
  
    (* Update Display Every 5 seconds *)  
    IF Timer.Q THEN  
        UpdateTimer := TRUE;  
        Timer(IN := FALSE);  
    ELSE  
        UpdateTimer := FALSE;  
    END_IF;  
  
    IF UpdateTimer THEN  
        Temp1InC := TempRegister1 / 82;  
        Temp2InC := TempRegister2 / 82;  
    END_IF;  
END_FUNCTION_BLOCK  
