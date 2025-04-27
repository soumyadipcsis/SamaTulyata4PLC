PROC TPLC;
VAR_INPUT
    SET, INCREASE, DECREASE, RESET : BOOL;
    STEP_SIZE : INT := 1;
    MIN_LIMIT, MAX_LIMIT : INT;
    RESET_VALUE, TARGET_VALUE : INT := 50;
    SLOW_RAMP_TIME, FAST_RAMP_TIME : TIME := t#500ms, t#2s;
    SLOW_STEP_RATE, FAST_STEP_RATE : INT := 2, 10;
    STEP_DELAY : TIME := t#1s;
    ERROR_THRESHOLD : INT := 5;
END_VAR

VAR_OUTPUT
    OutputValue : INT;
    SystemError : BOOL := FALSE;
    StepComplete : BOOL := FALSE;
END_VAR

VAR
    TimeTick, StartTime, FastStartTime : UDINT;
    OperationState, StepDirection, CurrentStep : INT;
    RampSpeed, InitialValue, FastInitialValue : INT;
    ElapsedTime : TIME;
    TimerActive, StepDelayTimer : BOOL;
    StepsWithoutChange : INT := 0;
END_VAR

TimeTick := T_PLC_MS(en := TRUE); 

BEGIN

STEP 'RESET_STEP'
    IF RESET THEN
        OutputValue := RESET_VALUE;
        OperationState := 0;
        StepComplete := TRUE;
        StepsWithoutChange := 0;
    END
ENDSTEP

STEP 'SET_STEP'
    IF SET THEN
        OutputValue := TARGET_VALUE;
        OperationState := 0;
        StepComplete := TRUE;
        StepsWithoutChange := 0;
    END
ENDSTEP

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'OPERATION_STATE_MACHINE'
            IF OperationState > 0 THEN
                IF OperationState = 1 THEN
                    StepDirection := INCREASE;
                ELSE
                    StepDirection := DECREASE;
                END_IF;
                IF NOT StepDirection AND (TimeTick - StartTime <= TIME_TO_UDINT(SLOW_RAMP_TIME)) THEN
                    OutputValue := InitialValue + CurrentStep;
                    OperationState := 0;
                    StepComplete := TRUE;
                ELSIF StepDirection AND (TimeTick - StartTime >= TIME_TO_UDINT(FAST_RAMP_TIME)) THEN
                    OutputValue := FastInitialValue + UDINT_TO_REAL(TimeTick - FastStartTime) * FAST_STEP_RATE / RampSpeed;
                ELSIF StepDirection AND (TimeTick - StartTime >= TIME_TO_UDINT(SLOW_RAMP_TIME)) THEN
                    OutputValue := InitialValue + UDINT_TO_REAL(TimeTick - StartTime - TIME_TO_UDINT(SLOW_RAMP_TIME)) * SLOW_STEP_RATE / RampSpeed;
                    FastStartTime := TimeTick;
                    FastInitialValue := OutputValue;
                ELSIF NOT StepDirection THEN
                    OperationState := 0;
                    StepComplete := TRUE;
                END_IF;
            END
        ENDSTEP

        STEP 'SLOW_INCREMENT'
            IF INCREASE THEN
                OperationState := 1;
                StartTime := TimeTick;
                CurrentStep := STEP_SIZE;
                RampSpeed := 1000;
                InitialValue := OutputValue;
                StepsWithoutChange := StepsWithoutChange + 1;
                StepComplete := FALSE;
            END
        ENDSTEP

        STEP 'SLOW_DECREMENT'
            IF DECREASE THEN
                OperationState := 2;
                StartTime := TimeTick;
                CurrentStep := -STEP_SIZE;
                RampSpeed := -1000;
                InitialValue := OutputValue;
                StepsWithoutChange := StepsWithoutChange + 1;
                StepComplete := FALSE;
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'LIMIT_CHECK'
            OutputValue := LIMIT(MIN_LIMIT, OutputValue, MAX_LIMIT);
            IF OutputValue = MIN_LIMIT OR OutputValue = MAX_LIMIT THEN
                IF StepsWithoutChange >= ERROR_THRESHOLD THEN
                    SystemError := TRUE;
                END
            END
        ENDSTEP

        STEP 'STEP_DELAY'
            IF NOT StepComplete THEN
                StepDelayTimer := StepDelayTimer + T#1s;
                IF StepDelayTimer >= STEP_DELAY THEN
                    StepComplete := TRUE;
                    StepDelayTimer := T#0s;
                END
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

END
