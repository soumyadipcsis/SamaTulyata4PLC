PROC CLICK_MODE_BASIC;
VAR
    IN : BOOL;
    T_LONG : TIME;

    SINGLE : BOOL;
    DOUBLE : BOOL;
    LONG : BOOL;
    TP_LONG : BOOL;

    timer : TP;
    cnt : INT;
    last : BOOL;
BEGIN
STEP 'BASIC_CLICK_DETECTION'
SINGLE := FALSE;
DOUBLE := FALSE;

timer(IN := IN, PT := T_LONG);

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

last := IN;
TP_LONG := (NOT timer.Q) AND (NOT LONG) AND IN;
LONG := (NOT timer.Q) AND IN;

ENDSTEP
END.
