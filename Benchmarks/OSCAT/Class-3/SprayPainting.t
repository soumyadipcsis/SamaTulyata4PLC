PROC SPRAYPAINTING_PROC_INT_BOOL_2LEVEL_NESTED_LOOP;
VAR
    Start, Stop, HangerSwitch, PartDetect : BOOL;
    MasterCoil, Oven, Spray : BOOL;
    SR0, SR1, SR2, SR3, SR4, SR5 : BOOL; // BitShiftRegister[0..5]
    ControlRegister : BOOL;
    i, j : INT;
BEGIN

// 2-level nested loop 1: set all bit shift registers to FALSE before operation
FOR i := 0 TO 1 DO
    FOR j := 0 TO 2 DO
        IF (i*3 + j = 0) THEN SR0 := FALSE; END_IF;
        IF (i*3 + j = 1) THEN SR1 := FALSE; END_IF;
        IF (i*3 + j = 2) THEN SR2 := FALSE; END_IF;
        IF (i*3 + j = 3) THEN SR3 := FALSE; END_IF;
        IF (i*3 + j = 4) THEN SR4 := FALSE; END_IF;
        IF (i*3 + j = 5) THEN SR5 := FALSE; END_IF;
    END_FOR
END_FOR

// Master Coil Control
IF Start AND NOT Stop THEN
    MasterCoil := TRUE;
ELSE
    MasterCoil := FALSE;
END_IF;

// Oven Control
IF MasterCoil THEN
    Oven := TRUE;
ELSE
    Oven := FALSE;
END_IF;

// Bit Shift Left Operation (unrolled, no array)
IF MasterCoil AND HangerSwitch THEN
    ControlRegister := PartDetect;
    SR5 := SR4;
    SR4 := SR3;
    SR3 := SR2;
    SR2 := SR1;
    SR1 := SR0;
    SR0 := ControlRegister;
END_IF;

// Spray Control
IF SR2 THEN
    Spray := TRUE;
ELSE
    Spray := FALSE;
END_IF;

END.
