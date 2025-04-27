PROC CAPPING_PROCESS_2;
VAR_INPUT  
    Start : BOOL;  
    Stop : BOOL;  
    Proximity : BOOL;  
END_VAR  

VAR_OUTPUT  
    MasterCoil : BOOL;  
    ConveyorMotor : BOOL;  
    CappingMachine : BOOL;  
END_VAR  

VAR  
    BitShift0 : BOOL;  
    BitShift1 : BOOL;  
    BitShift2 : BOOL;  
    BitShift3 : BOOL;  
    BitShift4 : BOOL;  
    BitShift5 : BOOL;  
    BitShift6 : BOOL;  
    BitShift7 : BOOL;  
    BitShift8 : BOOL;  
    BitShift9 : BOOL;  
    BitShift10 : BOOL;  
    BitShift11 : BOOL;  
    BitShift12 : BOOL;  
    BitShift13 : BOOL;  
    BitShift14 : BOOL;  
    BitShift15 : BOOL;  
    ControlRegister : BOOL;  
    TimerCount : INT := 0;  
    TimerPreset : INT := 1000;  
    TimerBase : INT := 100;  
    i : INT;  
END_VAR  

BEGIN  
STEP 'MASTER_COIL_CONTROL'
    IF Start AND NOT Stop THEN MasterCoil := TRUE; ELSE MasterCoil := FALSE; END_IF;  
ENDSTEP

STEP 'CONVEYOR_MOTOR_CONTROL'
    IF MasterCoil AND TimerCount < TimerPreset THEN ConveyorMotor := TRUE; ELSE ConveyorMotor := FALSE; END_IF;  
ENDSTEP

STEP 'TIMER_CONTROL'
    IF MasterCoil AND TimerCount < TimerPreset THEN TimerCount := TimerCount + TimerBase; ELSE TimerCount := 0; END_IF;  
ENDSTEP  

STEP 'BIT_SHIFT_OPERATION'
    BitShift0 := BitShift1;  
    BitShift1 := BitShift2;  
    BitShift2 := BitShift3;  
    BitShift3 := BitShift4;  
    BitShift4 := BitShift5;  
    BitShift5 := BitShift6;  
    BitShift6 := BitShift7;  
    BitShift7 := BitShift8;  
    BitShift8 := BitShift9;  
    BitShift9 := BitShift10;  
    BitShift10 := BitShift11;  
    BitShift11 := BitShift12;  
    BitShift12 := BitShift13;  
    BitShift13 := BitShift14;  
    BitShift14 := BitShift15;  
ENDSTEP  

STEP 'FINALIZE_SHIFT'
    BitShift15 := ControlRegister;  
ENDSTEP  

STEP 'CAPPING_MACHINE_CONTROL'
    IF BitShift7 THEN CappingMachine := TRUE; ELSE CappingMachine := FALSE; END_IF;  
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_1'
    FOR i := 0 TO 3 DO
        BitShift0 := BitShift0 AND NOT BitShift1;
        BitShift1 := BitShift1 OR BitShift2;
    END_FOR;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_2'
    FOR i := 0 TO 3 DO
        BitShift4 := BitShift4 AND NOT BitShift5;
        BitShift5 := BitShift5 OR BitShift6;
    END_FOR;
ENDSTEP

END.
