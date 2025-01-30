FUNCTION_BLOCK MeasureScanCycle  
VAR_INPUT  
    StartPB : BOOL; (* Start measurement PB *)  
    ResetPB : BOOL; (* Reset Counter PB *)  
END_VAR  
  
VAR_OUTPUT  
    ToggleOutput : BOOL; (* Toggling output *)  
    Display : WORD; (* Display address *)  
END_VAR  
  
VAR  
    LatchingBit : BOOL; (* Latching Bit *)  
    Timer : TON;  
    Counter : CTU;  
    TimeBase : TIME := T#1s;  
    TempReal : REAL;  
END_VAR  
  
BEGIN  
    (* Toggling Output Control *)  
    ToggleOutput := NOT ToggleOutput;  
  
    (* Counter Control *)  
    IF NOT Timer.Q THEN  
        Counter(CU := TRUE, R := FALSE, PV := 0);  
    END_IF;  
  
    (* Convert Accumulator to BCD *)  
    Display := INT_TO_WORD(Counter.CV);  
  
    (* Start Measurement *)  
    IF StartPB AND NOT Timer.Q THEN  
        LatchingBit := TRUE;  
        Timer(IN := TRUE, PT := TimeBase);  
    END_IF;  
  
    (* Timer Control *)  
    IF LatchingBit THEN  
        Timer(IN := TRUE, PT := TimeBase);  
    ELSE  
        Timer(IN := FALSE);  
    END_IF;  
  
    (* Reset Counter *)  
    IF ResetPB THEN  
        Counter(R := TRUE);  
    END_IF;  
END_FUNCTION_BLOCK  
