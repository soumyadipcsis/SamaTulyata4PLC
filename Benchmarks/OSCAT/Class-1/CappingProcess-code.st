FUNCTION_BLOCK CappingProcess  
VAR_INPUT  
    Start : BOOL; (* Start *)  
    Stop : BOOL; (* Stop *)  
    Proximity : BOOL; (* Proximity sensor *)  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL; (* Master coil *)  
    ConveyorMotor : BOOL; (* Conveyor motor *)  
    CappingMachine : BOOL; (* Capping machine *)  
END_VAR  
  
VAR  
    Timer : TON;  
    BitShiftRegister : ARRAY[0..15] OF BOOL;  
    ControlRegister : BOOL;  
    TimerPreset : TIME := T#1s;  
    TimerBase : TIME := T#100ms;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF Start AND NOT Stop THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
  
    (* Conveyor Motor Control *)  
    IF MasterCoil THEN  
        IF NOT Timer.Q THEN  
            ConveyorMotor := TRUE;  
        ELSE  
            ConveyorMotor := FALSE;  
        END_IF;  
    ELSE  
        ConveyorMotor := FALSE;  
    END_IF;  
  
    (* Timer Control *)  
    IF MasterCoil THEN  
        Timer(IN := NOT Timer.Q, PT := TimerPreset);  
    ELSE  
        Timer(IN := FALSE);  
    END_IF;  
  
    (* Bit Shift Left Operation *)  
    IF ConveyorMotor AND Proximity THEN  
        ControlRegister := TRUE;  
    ELSE  
        ControlRegister := FALSE;  
    END_IF;  
  
    IF ConveyorMotor THEN  
        BitShiftRegister[15] := BitShiftRegister[14];  
        BitShiftRegister[14] := BitShiftRegister[13];  
        BitShiftRegister[13] := BitShiftRegister[12];  
        BitShiftRegister[12] := BitShiftRegister[11];  
        BitShiftRegister[11] := BitShiftRegister[10];  
        BitShiftRegister[10] := BitShiftRegister[9];  
        BitShiftRegister[9] := BitShiftRegister[8];  
        BitShiftRegister[8] := BitShiftRegister[7];  
        BitShiftRegister[7] := BitShiftRegister[6];  
        BitShiftRegister[6] := BitShiftRegister[5];  
        BitShiftRegister[5] := BitShiftRegister[4];  
        BitShiftRegister[4] := BitShiftRegister[3];  
        BitShiftRegister[3] := BitShiftRegister[2];  
        BitShiftRegister[2] := BitShiftRegister[1];  
        BitShiftRegister[1] := BitShiftRegister[0];  
        BitShiftRegister[0] := ControlRegister;  
    END_IF;  
  
    (* Capping Machine Control *)  
    IF BitShiftRegister[7] THEN  
        CappingMachine := TRUE;  
    ELSE  
        CappingMachine := FALSE;  
    END_IF;  
END_FUNCTION_BLOCK  
