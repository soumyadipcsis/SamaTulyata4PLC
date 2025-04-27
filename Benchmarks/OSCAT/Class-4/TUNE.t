PROC TUNE
VAR_INPUT
    SET : BOOL;            (* Start setting *)
    SU : BOOL;             (* Step up *)
    SD : BOOL;             (* Step down *)
    RST : BOOL;            (* Reset *)
    SS : INT := 1;         (* Step size in integer *)
    LIMIT_L : INT;         (* Lower limit *)
    LIMIT_H : INT := 100;  (* Upper limit *)
    RST_VAL : INT;         (* Reset value *)
    SET_VAL : INT := 100;  (* Set value *)
    T1 : TIME := t#500ms;  (* Slow ramp time *)
    T2 : TIME := t#2s;     (* Fast ramp time *)
    S1 : INT := 2;         (* Slow step rate *)
    S2 : INT := 10;        (* Fast step rate *)
END_VAR

VAR_OUTPUT
    Y : INT;               (* Output value *)
END_VAR

VAR
    tx : UDINT;            (* Time tick in milliseconds *)
    start : UDINT;         (* Start time for operation *)
    start2 : UDINT;        (* Second start time for fast ramp *)
    state : INT;           (* State machine state *)
    in : BOOL;             (* Input for step direction *)
    _step : INT;           (* Step size for operation *)
    speed : INT;           (* Speed of ramping *)
    y_start : INT;         (* Starting Y value for ramp *)
    y_start2 : INT;        (* Starting Y value for fast ramp *)
    Timer_ET : TIME;       (* Timer elapsed time *)
    TimerRunning : BOOL;   (* Timer state flag *)
END_VAR

tx := T_PLC_MS(en := TRUE); (* Get current system time in milliseconds *)

BEGIN

STEP 'RESET'
    IF RST THEN
        Y := RST_VAL;          (* Reset to the defined reset value *)
        state := 0;
    END
ENDSTEP

STEP 'SET_VALUE'
    IF SET THEN
        Y := SET_VAL;          (* Set the value if SET is active *)
        state := 0;
    END
ENDSTEP

STEP 'STATE_MACHINE'
    IF state > 0 THEN
        (* State machine logic for ramping or stepping *)
        IF state = 1 THEN
            (* Step up logic *)
            in := SU;
        ELSE
            (* Step down logic *)
            in := SD;
        END_IF;

        (* Single step operation check *)
        IF NOT in AND (tx - start <= TIME_TO_UDINT(T1)) THEN
            Y := y_start + _step;      (* Apply the step increment *)
            state := 0;
        (* Fast ramp check *)
        ELSIF in AND (tx - start >= TIME_TO_UDINT(T2)) THEN
            Y := y_start2 + UDINT_TO_REAL(tx - start2) * S2 / speed;
        (* Slow ramp check *)
        ELSIF in AND (tx - start >= TIME_TO_UDINT(T1)) THEN
            Y := y_start + UDINT_TO_REAL(tx - start - TIME_TO_UDINT(T1)) * S1 / speed;
            start2 := tx;
            y_start2 := Y;
        ELSIF NOT in THEN
            state := 0;
        END_IF;
    END
ENDSTEP

STEP 'SLOW_STEP_UP'
    IF SU THEN
        (* Slow step up *)
        state := 1;
        start := tx;
        _step := SS;            (* Step increment for slow ramp *)
        speed := 1000;          (* Set speed for ramping *)
        y_start := Y;
    END
ENDSTEP

STEP 'SLOW_STEP_DOWN'
    IF SD THEN
        (* Slow step down *)
        state := 2;
        start := tx;
        _step := -SS;           (* Step decrement for slow ramp *)
        speed := -1000;         (* Set negative speed for ramping *)
        y_start := Y;
    END
ENDSTEP

STEP 'LIMIT_CHECK'
    (* Ensure the output does not exceed the limits *)
    Y := LIMIT(LIMIT_L, Y, LIMIT_H);  (* Clamping Y to the specified limits *)
ENDSTEP

END
