PROC TUNE;
VAR_INPUT
    SET, SU, SD, RST : BOOL;    (* Start, Step Up, Step Down, Reset *)
    SS : INT := 1;              (* Step size in integer *)
    LIMIT_L, LIMIT_H : INT;     (* Lower and upper limits *)
    RST_VAL : INT;              (* Reset value *)
    SET_VAL : INT := 100;       (* Set value *)
    S1 : INT := 2;              (* Slow step rate *)
    S2 : INT := 10;             (* Fast step rate *)
    STEP_DELAY : UDINT := 1000; (* Delay in milliseconds for steps *)
END_VAR

VAR_OUTPUT
    Y : INT;                    (* Output value *)
END_VAR

VAR
    tx : UDINT;                 (* Time tick in milliseconds *)
    start, start2 : UDINT;      (* Start times for ramping *)
    state : INT;                (* State machine state *)
    in : BOOL;                  (* Input for step direction *)
    _step : INT;                (* Step size for operation *)
    speed : INT;                (* Speed of ramping *)
    y_start, y_start2 : INT;    (* Starting Y values for ramp *)
    Timer_ET : UDINT;           (* Elapsed time counter for delay *)
    TimerRunning : BOOL;        (* Timer state flag *)
END_VAR

tx := T_PLC_MS(en := TRUE);   (* Get current system time in milliseconds *)

BEGIN

STEP 'RESET'
    IF RST THEN
        Y := RST_VAL;           (* Reset to the defined reset value *)
        state := 0;
    END
ENDSTEP

STEP 'SET_VALUE'
    IF SET THEN
        Y := SET_VAL;           (* Set the value if SET is active *)
        state := 0;
    END
ENDSTEP

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'STATE_MACHINE'
            IF state > 0 THEN
                (* State machine logic for ramping or stepping *)
                IF state = 1 THEN
                    in := SU;  (* Step up logic *)
                ELSE
                    in := SD;  (* Step down logic *)
                END_IF;

                (* Single step operation check *)
                IF NOT in AND (tx - start <= STEP_DELAY) THEN
                    Y := y_start + _step;      (* Apply the step increment *)
                    state := 0;
                (* Fast ramp check *)
                ELSIF in AND (tx - start >= STEP_DELAY * 2) THEN
                    Y := y_start2 + (tx - start2) * S2 / speed;
                (* Slow ramp check *)
                ELSIF in AND (tx - start >= STEP_DELAY) THEN
                    Y := y_start + (tx - start - STEP_DELAY) * S1 / speed;
                    start2 := tx;
                    y_start2 := Y;
                ELSIF NOT in THEN
                    state := 0;
                END_IF;
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'SLOW_STEP_UP'
            IF SU THEN
                state := 1;
                start := tx;
                _step := SS;            (* Step increment for slow ramp *)
                speed := 1000;          (* Set speed for ramping *)
                y_start := Y;
            END
        ENDSTEP

        STEP 'SLOW_STEP_DOWN'
            IF SD THEN
                state := 2;
                start := tx;
                _step := -SS;           (* Step decrement for slow ramp *)
                speed := -1000;         (* Set negative speed for ramping *)
                y_start := Y;
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR i := 1 TO 2 DO
        STEP 'LIMIT_CHECK'
            Y := LIMIT(LIMIT_L, Y, LIMIT_H);  (* Clamping Y to the specified limits *)
        ENDSTEP

        STEP 'STEP_DELAY'
            IF NOT TimerRunning THEN
                Timer_ET := 0; (* Start the timer for delay *)
                TimerRunning := TRUE;
            ELSE
                Timer_ET := Timer_ET + 1;
                IF Timer_ET >= STEP_DELAY THEN
                    TimerRunning := FALSE;  (* Timer complete, stop the delay *)
                END_IF;
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR i := 1 TO 1 DO
        STEP 'FINAL_STATE'
            IF state = 0 THEN
                (* Reset or finalize the current operation *)
                TimerRunning := FALSE;
                state := 0;
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

END
