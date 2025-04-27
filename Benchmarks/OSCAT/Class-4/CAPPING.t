PROC CAPPING;
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
    BitShiftRegister : ARRAY[0..15] OF BOOL;  
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
    FOR i := 15 TO 1 BY -1 DO BitShiftRegister[i] := BitShiftRegister[i - 1]; END_FOR  
ENDSTEP  

STEP 'FINALIZE_SHIFT'
    BitShiftRegister[0] := ControlRegister;  
ENDSTEP  

STEP 'ADDITIONAL_LOOP'
    FOR i := 0 TO 15 DO
        IF BitShiftRegister[i] THEN
            BitShiftRegister[i] := FALSE;
        ELSE
            BitShiftRegister[i] := TRUE;
        END_IF;
    END_FOR;
ENDSTEP  

STEP 'CAPPING_MACHINE_CONTROL'
    IF BitShiftRegister[7] THEN CappingMachine := TRUE; ELSE CappingMachine := FALSE; END_IF;  
ENDSTEP

END
//Convert array to scalar variables during running the modelconstructor
