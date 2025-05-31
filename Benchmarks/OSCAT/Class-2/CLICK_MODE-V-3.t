PROC CLICK_MODE_BASIC_V2;
VAR
    IN : BOOL;
    SINGLE : BOOL;
    DOUBLE : BOOL;
    LONG : BOOL;
    TP_LONG : BOOL;

    press_count : INT;
    hold_count : INT;
    i : INT;
    last : BOOL;
BEGIN
STEP 'CLICK_MODE_LOOP_V2'
SINGLE := FALSE;
DOUBLE := FALSE;
LONG := FALSE;
TP_LONG := FALSE;

IF IN THEN
    i := 0;
    WHILE i < 10 DO
        hold_count := hold_count + 1;
        i := i + 1;
    END_WHILE;
ELSE
    IF last THEN
        IF hold_count > 40 THEN
            LONG := TRUE;
            TP_LONG := TRUE;
        ELSE
            press_count := press_count + 1;
        END
    END
    hold_count := 0;
END

IF press_count = 1 THEN
    SINGLE := TRUE;
ELSIF press_count = 2 THEN
    DOUBLE := TRUE;
    press_count := 0;
ELSE
    press_count := 0;
END

last := IN;
ENDSTEP
END.
