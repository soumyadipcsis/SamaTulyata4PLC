PROC CLICK_MODE;
VAR
    IN : BOOL; // Input signal
    T_LONG : TIME; // Long press threshold
    SINGLE : BOOL; // Single click detected
    DOUBLE : BOOL; // Double click detected
    LONG : BOOL; // Long press detected
    TP_LONG : BOOL; // Transition to long press

    timer : TP; // Pulse timer
    cnt : INT; // Click counter
    last : BOOL; // Previous input state

BEGIN
STEP 'EXECUTE_CLICK_MODE_LOGIC'

// Default values
SINGLE := FALSE;
DOUBLE := FALSE;

// Start timer when input goes high
timer(IN := IN, PT := T_LONG);

// Count rising edges during timer duration
IF timer.Q THEN
    IF (NOT IN) AND last THEN
        cnt := cnt + 1;
    END
ELSE
    CASE cnt OF
        1 : SINGLE := TRUE;
        2 : DOUBLE := TRUE;
    END_CASE;
    cnt := 0;
END

// Store previous input state
last := IN;

// Determine long press transitions
TP_LONG := (NOT timer.Q) AND (NOT LONG) AND IN;
LONG := (NOT timer.Q) AND IN;

ENDSTEP

END.
