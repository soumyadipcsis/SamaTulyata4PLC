PROC CAPPING_PROCESS;
VAR_INPUT  
    Start : BOOL; (* Start input *)  
    Stop : BOOL; (* Stop input *)  
    Proximity : BOOL; (* Proximity sensor input *)  
END_VAR  
  
VAR_OUTPUT  
    MasterCoil : BOOL; (* Master coil output *)  
    ConveyorMotor : BOOL; (* Conveyor motor output *)  
    CappingMachine : BOOL; (* Capping machine output *)  
END_VAR  
  
VAR  
    BitShiftRegister : ARRAY[0..15] OF BOOL;  
    ControlRegister : BOOL;  
    TimerPreset : INT := 1000; (* Timer preset in ticks *)
    TimerBase : INT := 100; (* Timer base time in ticks *)
    TimerCount : INT := 0; (* Timer count variable *)
    i : INT; (* Loop variable for bit shift *)
    j : INT; (* Second loop variable for parallel operation *)  
END_VAR  
  
BEGIN  

STEP 'MASTER_COIL_CONTROL'
    (* Master Coil Control *)
    IF Start AND NOT Stop THEN  
        MasterCoil := TRUE;  
    ELSE  
        MasterCoil := FALSE;  
    END_IF;  
ENDSTEP

STEP 'CONVEYOR_MOTOR_CONTROL'
    (* Conveyor Motor Control *)
    IF MasterCoil AND TimerCount < TimerPreset THEN  
        ConveyorMotor := TRUE;  
    ELSE  
        ConveyorMotor := FALSE;  
    END_IF;  
ENDSTEP

STEP 'TIMER_CONTROL'
    (* Timer Control without TON block, using manual timer count *)
    IF MasterCoil AND TimerCount < TimerPreset THEN  
        TimerCount := TimerCount + TimerBase;  
    ELSE  
        TimerCount := 0;  
    END_IF;  
ENDSTEP  

STEP 'CONTROL_REGISTER_UPDATE'
    (* Update Control Register based on proximity and conveyor motor status *)
    IF ConveyorMotor AND Proximity THEN  
        ControlRegister := TRUE;  
    ELSE  
        ControlRegister := FALSE;  
    END_IF;  
ENDSTEP

STEP 'BIT_SHIFT_OPERATION'
    (* Data parallel loop 1: Update Bit Shift Register in parallel *)
    FOR i := 15 TO 1 BY -1 DO
        IF ConveyorMotor THEN  
            BitShiftRegister[i] := BitShiftRegister[i - 1];  
        END_IF;  
    END_FOR  
ENDSTEP  

STEP 'BIT_SHIFT_FINALIZATION'
    (* Data parallel loop 2: Finalize Bit Shift Register with control register *)
    FOR j := 0 TO 15 DO
        IF ConveyorMotor THEN  
            IF j = 0 THEN
                BitShiftRegister[0] := ControlRegister;  
            END_IF;
        END_IF;  
    END_FOR  
ENDSTEP  

STEP 'CAPPING_MACHINE_CONTROL'
    (* Capping Machine Control based on bit shift register *)
    IF BitShiftRegister[7] THEN  
        CappingMachine := TRUE;  
    ELSE  
        CappingMachine := FALSE;  
    END_IF;  
ENDSTEP

END
