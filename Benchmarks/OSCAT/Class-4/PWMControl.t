FUNCTION_BLOCK PWMControl  
VAR_INPUT  
    MasterStart : BOOL;  
    MasterStop : BOOL;  
    BCDInput : WORD; (* 0-99 BCD input *)  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL;  
    PWMOutput : BOOL;  
END_VAR  
  
VAR  
    TimerON : TON;  
    TimerOFF : TON;  
    BCDToHex : WORD;  
    TimerPresetON : TIME;  
    TimerPresetOFF : TIME;  
    TempReal : REAL;  
END_VAR  
  
VAR  
    TimerPresetONTime : TIME := T#0s;  
    TimerPresetOFFTime : TIME := T#0s;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF MasterStart AND NOT MasterStop THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
  
    (* BCD to HEX Conversion *)  
    BCDToHex := WORD_TO_UINT(BCDInput); (* Convert BCD input to UINT *)  
    TempReal := TIME_TO_REAL(T#100s); (* Convert 100s to REAL for calculations *)  
  
    (* Calculate ON and OFF times *)  
    TimerPresetONTime := TIME_OF_REAL(BCDToHex); (* Convert BCDToHex to TIME *)  
    TimerPresetOFFTime := TIME_OF_REAL(TempReal - TIME_TO_REAL(TimerPresetONTime)); (* 100s - ON time *)  
  
    (* ON Timer Control *)  
    IF MasterCoil AND NOT TimerOFF.Q THEN  
        TimerON(IN := TRUE, PT := TimerPresetONTime);  
    ELSE  
        TimerON(IN := FALSE);  
    END_IF;  
  
    (* OFF Timer Control *)  
    IF MasterCoil AND TimerON.Q THEN  
        TimerOFF(IN := TRUE, PT := TimerPresetOFFTime);  
    ELSE  
        TimerOFF(IN := FALSE);  
    END_IF;  
  
    (* PWM Output Control *)  
    IF TimerON.Q THEN  
        PWMOutput := TRUE;  
    ELSE  
        PWMOutput := FALSE;  
    END_IF;  
END_FUNCTION_BLOCK  
