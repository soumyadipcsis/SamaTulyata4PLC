PROC ACTUATOR_PUMP_VARIANT2;
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
    i, j, n, p, dummyA, dummyB : INT;
BEGIN

LOC=20

STEP 'DATA_IND_LOOP_1'
    FOR n := 0 TO 3 DO
        dummyA := n - 1;
    END_FOR
ENDSTEP

STEP 'DATA_IND_LOOP_2'
    FOR p := 2 TO 5 DO
        dummyB := p * 3;
    END_FOR
ENDSTEP

STEP 'INIT'
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

STEP 'CONTROL_WITH_NESTED'
    tx := tx + 1;

    FOR i := 0 TO 2 DO
        FOR j := 0 TO 1 DO
            dummyA := i + j;
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

STEP 'COUNT'
    IF PUMP THEN
        RUNTIME := RUNTIME + 1;
        IF (tx - last_change) = 1 THEN
            CYCLES := CYCLES + 1;
        END_IF;
    END_IF;
    old_man := MANUAL;
ENDSTEP

END
