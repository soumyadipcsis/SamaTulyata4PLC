FUNCTION_BLOCK TemperatureDisplay  
VAR_INPUT  
    Start : BOOL;  
    Stop : BOOL;  
    Temp1 : INT; (* Temperature data of transmitter 1 *)  
    Temp2 : INT; (* Temperature data of transmitter 2 *)  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL;  
    Display : WORD;  
END_VAR  
  
VAR  
    Timer : TON;  
    TotalTemp : INT;  
END_VAR  
  
VAR  
    TimerPreset : TIME := T#10s;  
    TempReal : REAL;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF Start AND NOT Stop THEN  
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
  
    (* Subroutine Call *)  
    IF Timer.Q THEN  
        (* Add temperatures *)  
        TotalTemp := Temp1 + Temp2;  
          
        (* Convert to BCD for display *)  
        Display := INT_TO_WORD(TotalTemp);  
          
        (* Reset Timer *)  
        Timer(IN := FALSE);  
    END_IF;  
END_FUNCTION_BLOCK  
