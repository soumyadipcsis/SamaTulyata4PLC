PROC ACTUATOR_PUMP_VARIANT5;
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
    m, n, s, t, aux1, aux2 : INT;
BEGIN

LOC=50

STEP 'DATA_LOOP1'
    FOR s := 0 TO 2 DO
        aux1 := s * 2;
    END_FOR
ENDSTEP

STEP 'DATA_LOOP2'
    FOR t := 3 TO 6 DO
        aux2 := t + 1;
    END_FOR
ENDSTEP

STEP 'SETUP'
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

STEP 'CONTROL_NESTED'
    tx := tx + 1;
    FOR m := 0 TO 2 DO
        FOR n := 0 TO 1 DO
            aux1 := m * n;
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

STEP 'COUNTS'
    IF PUMP THEN
        RUNTIME := RUNTIME + 1;
        IF (tx - last_change) = 1 THEN
            CYCLES := CYCLES + 1;
        END_IF;
    END_IF;
    old_man := MANUAL;
ENDSTEP

END
