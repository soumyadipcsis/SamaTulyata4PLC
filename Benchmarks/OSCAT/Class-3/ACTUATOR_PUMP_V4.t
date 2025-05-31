PROC ACTUATOR_PUMP_VARIANT6;
VAR_INPUT
    IN : BOOL;
    MANUAL : BOOL;
    RST : BOOL;
    MIN_ONTIME : INT;
    MIN_OFFTIME : INT;
    RUN_EVERY : INT;
END_VAR
VAR_OUTPUT
    PUMP : BOOL;
    RUNTIME : INT;
    CYCLES : INT;
END_VAR
VAR
    tx : INT;
    last_change : INT;
    old_man : BOOL;
    init : BOOL;
    i, j, f, g, val1, val2 : INT;
BEGIN

LOC=60

STEP 'BEGIN_INIT_LOOP1'
    FOR f := 0 TO 2 DO
        val1 := f * 3;
    END_FOR
ENDSTEP

STEP 'BEGIN_INIT_LOOP2'
    FOR g := 2 TO 4 DO
        val2 := g - 2;
    END_FOR
ENDSTEP

STEP 'BEGIN_INIT'
    IF NOT init THEN
        init := TRUE;
        last_change := 0;
        tx := 0;
        RUNTIME := 0;
        CYCLES := 0;
    END_IF;
    IF RST THEN
        RST := FALSE;
        RUNTIME := 0;
        CYCLES := 0;
        last_change := 0;
        PUMP := FALSE;
    END_IF;
ENDSTEP

STEP 'PUMP_LOGIC_NESTED'
    tx := tx + 1;
    FOR i := 0 TO 2 DO
        FOR j := 0 TO 1 DO
            val1 := i + j;
        END_FOR
    END_FOR

    IF MANUAL AND NOT PUMP THEN
        last_change := tx;
        PUMP := TRUE;
    END_IF;

    IF NOT MANUAL AND old_man AND PUMP AND NOT IN THEN
        last_change := tx;
        PUMP := FALSE;
    END_IF;

    IF IN AND NOT PUMP AND (tx - last_change) >= MIN_OFFTIME THEN
        last_change := tx;
        PUMP := TRUE;
    END_IF;

    IF PUMP AND NOT IN AND NOT MANUAL AND (tx - last_change) >= MIN_ONTIME THEN
        last_change := tx;
        PUMP := FALSE;
    END_IF;

    IF NOT PUMP AND ((tx - last_change) >= RUN_EVERY) AND (RUN_EVERY > 0) THEN
        last_change := tx;
        PUMP := TRUE;
    END_IF;
ENDSTEP

STEP 'TALLY'
    IF PUMP THEN
        RUNTIME := RUNTIME + 1;
        IF (tx - last_change) = 1 THEN
            CYCLES := CYCLES + 1;
        END_IF;
    END_IF;
    old_man := MANUAL;
ENDSTEP

END
