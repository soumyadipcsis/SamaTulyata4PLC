PROC TPLC;
VAR_INPUT
    SET : BOOL;            (* Start setting *)
    INCREASE : BOOL;       (* Increase value *)
    DECREASE : BOOL;       (* Decrease value *)
    RESET : BOOL;          (* Reset value *)
    STEP_SIZE : INT := 1;  (* Step size in integer *)
    MIN_LIMIT : INT;       (* Lower limit for output *)
    MAX_LIMIT : INT := 100; (* Upper limit for output *)
    RESET_VALUE : INT;     (* Value to reset to *)
    TARGET_VALUE : INT := 50; (* Value to set when SET is active *)
    SLOW_RAMP_TIME : TIME := t#500ms; (* Time for slow ramp *)
    FAST_RAMP_TIME : TIME := t#2s;    (* Time for fast ramp *)
    SLOW_STEP_RATE : INT := 2; (* Slow step increment *)
    FAST_STEP_RATE : INT := 10; (* Fast step increment *)
    STEP_DELAY : TIME := t#1s; (* Delay after each step operation *)
    ERROR_THRESHOLD : INT := 5; (* Number of steps after which to indicate an error if system isn't responding *)
END_VAR

VAR_OUTPUT
    OutputValue : INT;      (* Output value *)
    SystemError : BOOL := FALSE; (* Error flag *)
    StepComplete : BOOL := FALSE; (* Step completion flag *)
END_VAR

VAR
    TimeTick : UDINT;       (* Time tick in milliseconds *)
    StartTime : UDINT;      (* Start time for ramping *)
    FastStartTime : UDINT;  (* Start time for fast ramp *)
    OperationState : INT;   (* Current state of the machine *)
    StepDirection : BOOL;   (* Direction of step: increase or decrease *)
    CurrentStep : INT;      (* Step increment or decrement *)
    RampSpeed : INT;        (* Speed of ramping (for slow/fast) *)
    InitialValue : INT;     (* Starting value for ramping *)
    FastInitialValue : INT; (* Starting value for fast ramp *)
    ElapsedTime : TIME;     (* Elapsed time for operation *)
    TimerActive : BOOL;     (* Flag for active timer *)
    StepDelayTimer : TIME;  (* Timer to introduce delay after each step *)
    StepsWithoutChange : INT := 0; (* Counter for tracking if steps were executed without change *)
END_VAR

TimeTick := T_PLC_MS(en := TRUE); (* Get system time in milliseconds *)

BEGIN

STEP 'RESET_STEP'
    IF RESET THEN
        OutputValue := RESET_VALUE;  (* Reset the output to a predefined value *)
        OperationState := 0;
        StepComplete := TRUE;  (* Indicate that step is complete *)
        StepsWithoutChange := 0;  (* Reset steps counter *)
    END
ENDSTEP

STEP 'SET_STEP'
    IF SET THEN
        OutputValue := TARGET_VALUE;  (* Set the output to the target value when SET is active *)
        OperationState := 0;
        StepComplete := TRUE;  (* Indicate that step is complete *)
        StepsWithoutChange := 0;  (* Reset steps counter *)
    END
ENDSTEP

STEP 'OPERATION_STATE_MACHINE'
    IF OperationState > 0 THEN
        (* State machine handles the ramping and stepping logic *)
        IF OperationState = 1 THEN
            (* Increase step logic *)
            StepDirection := INCREASE;
        ELSE
            (* Decrease step logic *)
            StepDirection := DECREASE;
        END_IF;

        (* If not increasing or decreasing and the slow ramp time has elapsed *)
        IF NOT StepDirection AND (TimeTick - StartTime <= TIME_TO_UDINT(SLOW_RAMP_TIME)) THEN
            OutputValue := InitialValue + CurrentStep;  (* Apply the step value *)
            OperationState := 0;
            StepComplete := TRUE;  (* Mark step as complete *)

        (* Fast ramp logic if increase or decrease has been pressed for a longer period *)
        ELSIF StepDirection AND (TimeTick - StartTime >= TIME_TO_UDINT(FAST_RAMP_TIME)) THEN
            OutputValue := FastInitialValue + UDINT_TO_REAL(TimeTick - FastStartTime) * FAST_STEP_RATE / RampSpeed;

        (* Slow ramp logic if increase or decrease is pressed for a longer period *)
        ELSIF StepDirection AND (TimeTick - StartTime >= TIME_TO_UDINT(SLOW_RAMP_TIME)) THEN
            OutputValue := InitialValue + UDINT_TO_REAL(TimeTick - StartTime - TIME_TO_UDINT(SLOW_RAMP_TIME)) * SLOW_STEP_RATE / RampSpeed;
            FastStartTime := TimeTick;
            FastInitialValue := OutputValue;
        ELSIF NOT StepDirection THEN
            OperationState := 0;
            StepComplete := TRUE;  (* Mark step as complete *)
        END_IF;
    END
ENDSTEP

STEP 'SLOW_INCREMENT'
    IF INCREASE THEN
        (* Slow increment operation *)
        OperationState := 1;
        StartTime := TimeTick;
        CurrentStep := STEP_SIZE;        (* Increment step size *)
        RampSpeed := 1000;                (* Set ramp speed for slow operation *)
        InitialValue := OutputValue;
        StepsWithoutChange := StepsWithoutChange + 1;  (* Increment step counter *)
        StepComplete := FALSE;  (* Mark as not complete yet *)
    END
ENDSTEP

STEP 'SLOW_DECREMENT'
    IF DECREASE THEN
        (* Slow decrement operation *)
        OperationState := 2;
        StartTime := TimeTick;
        CurrentStep := -STEP_SIZE;       (* Decrement step size *)
        RampSpeed := -1000;               (* Set negative speed for decrement *)
        InitialValue := OutputValue;
        StepsWithoutChange := StepsWithoutChange + 1;  (* Increment step counter *)
        StepComplete := FALSE;  (* Mark as not complete yet *)
    END
ENDSTEP

STEP 'LIMIT_CHECK'
    (* Make sure the output value stays within the defined limits *)
    OutputValue := LIMIT(MIN_LIMIT, OutputValue, MAX_LIMIT);  (* Clamps the output to the defined limits *)

    (* If output is at a limit and no change has occurred, flag an error *)
    IF OutputValue = MIN_LIMIT OR OutputValue = MAX_LIMIT THEN
        IF StepsWithoutChange >= ERROR_THRESHOLD THEN
            SystemError := TRUE;  (* Flag an error if the output is stuck at limits for too long *)
        END
    END
ENDSTEP

STEP 'STEP_DELAY'
    (* Add a delay after each step to simulate step rate *)
    IF NOT StepComplete THEN
        StepDelayTimer := StepDelayTimer + T#1s;  (* Delay timer for steps *)
        IF StepDelayTimer >= STEP_DELAY THEN
            StepComplete := TRUE;  (* Mark step as completed after delay *)
            StepDelayTimer := T#0s; (* Reset delay timer *)
        END
    END
ENDSTEP

END
