FUNCTION_BLOCK SprayPainting  
VAR_INPUT  
    Start : BOOL;  
    Stop : BOOL;  
    HangerSwitch : BOOL;  
    PartDetect : BOOL;  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL;  
    Oven : BOOL;  
    Spray : BOOL;  
END_VAR  
  
VAR  
    BitShiftRegister : ARRAY[0..5] OF BOOL;  
    ControlRegister : BOOL;  
END_VAR  
  
BEGIN  
    (* Master Coil Control *)  
    IF Start AND NOT Stop THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
  
    (* Oven Control *)  
    IF MasterCoil THEN  
        Oven := TRUE;  
    ELSE  
        Oven := FALSE;  
    END_IF;  
  
    (* Bit Shift Left Operation *)  
    IF MasterCoil AND HangerSwitch THEN  
        ControlRegister := PartDetect;  
          
        (* Shift bits left *)  
        BitShiftRegister[5] := BitShiftRegister[4];  
        BitShiftRegister[4] := BitShiftRegister[3];  
        BitShiftRegister[3] := BitShiftRegister[2];  
        BitShiftRegister[2] := BitShiftRegister[1];  
        BitShiftRegister[1] := BitShiftRegister[0];  
        BitShiftRegister[0] := ControlRegister;  
    END_IF;  
  
    (* Spray Control *)  
    IF BitShiftRegister[2] THEN  
        Spray := TRUE;  
    ELSE  
        Spray := FALSE;  
    END_IF;  
END_FUNCTION_BLOCK  
