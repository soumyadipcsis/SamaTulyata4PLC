PROC CLICK_MODE_BASIC_V1;
VAR
    IN : BOOL;
    SINGLE : BOOL;
    DOUBLE : BOOL;
    LONG : BOOL;
    TP_LONG : BOOL;

    cnt : INT;
    hold : INT;
    loop_idx : INT;
    last : BOOL;
BEGIN
STEP 'CLICK_MODE_LOOP_V1'
SINGLE := FALSE;
DOUBLE := FALSE;
TP_LONG := FALSE;
LONG := FALSE;

(* Simulated nested loop for debounce *)
IF IN THEN
    loop_idx := 0;
    WHILE loop_idx < 5 DO
        hold := hold + 1;
        loop_idx := loop_idx + 1;
    END_WHILE;
ELSE
    IF last THEN
        IF hold > 50 THEN
            LONG := TRUE;
            TP_LONG := TRUE;
        ELSE
            cnt := cnt + 1;
        END
    END
    hold := 0;
END

IF NOT IN THEN
    IF cnt = 1 THEN
        SINGLE := TRUE;
    ELSIF cnt = 2 THEN
        DOUBLE := TRUE;
        cnt := 0;
    ELSE
        cnt := 0;
    END
END

last := IN;
ENDSTEP
END.
