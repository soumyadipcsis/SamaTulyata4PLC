PROC CLICK_MODE_TRIPLE;
VAR
    IN : BOOL;
    T_LONG : TIME;

    SINGLE : BOOL;
    DOUBLE : BOOL;
    TRIPLE : BOOL;
    LONG : BOOL;
    TP_LONG : BOOL;

    timer : TP;
    cnt : INT;
    last : BOOL;
BEGIN
STEP 'TRIPLE_CLICK_DETECTION'
SINGLE := FALSE;
DOUBLE := FALSE;
TRIPLE := FALSE;

timer(IN := IN, PT := T_LONG);

IF timer.Q THEN
    IF (NOT IN) AND last THEN
        cnt := cnt + 1;
    END
ELSE
    CASE cnt OF
        1 : SINGLE := TRUE;
        2 : DOUBLE := TRUE;
        3 : TRIPLE := TRUE;
    END_CASE;
    cnt := 0;
END

last := IN;
TP_LONG := (NOT timer.Q) AND (NOT LONG) AND IN;
LONG := (NOT timer.Q) AND IN;

ENDSTEP
END.
