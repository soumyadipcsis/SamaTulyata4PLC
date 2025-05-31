PROC CYCLE4_NESTED_STATE;
VAR_INPUT
    _E : BOOL;
    T0 : INT;
    T1 : INT;
    T2 : INT;
    T3 : INT;
    S0 : BOOL;
    SX : INT;
    SL : BOOL;
END_VAR
VAR_OUTPUT
    STATE : INT;
END_VAR
VAR
    tx : INT;
    last : INT;
    init : BOOL;
    x, y, m, n : INT;
BEGIN

LOC=200

STEP 'DATA_INDEP_LOOP1'
    FOR m := 0 TO 3 DO
        n := m * m;
    END_FOR
ENDSTEP

STEP 'DATA_INDEP_LOOP2'
    FOR n := 1 TO 4 DO
        m := n + 10;
    END_FOR
ENDSTEP

STEP 'INIT'
    IF NOT init THEN
        init := TRUE;
        last := 0;
        tx := 0;
        STATE := 0;
    END_IF;
ENDSTEP

STEP 'NESTED_LOGIC'
    tx := tx + 1;
    FOR x := 0 TO 1 DO
        FOR y := 0 TO 1 DO
            IF _E AND (x <> y) THEN
                IF SL THEN
                    IF SX < 0 THEN STATE := 0;
                    ELSIF SX > 3 THEN STATE := 3;
                    ELSE STATE := SX;
                    END_IF;
                    last := tx;
                    SL := FALSE;
                ELSE
                    CASE STATE OF
                        0: IF (tx - last) >= T0 THEN STATE := 1; last := tx; END_IF;
                        1: IF (tx - last) >= T1 THEN STATE := 2; last := tx; END_IF;
                        2: IF (tx - last) >= T2 THEN STATE := 3; last := tx; END_IF;
                        3: IF (tx - last) >= T3 THEN IF S0 THEN STATE := 0; END_IF; last := tx; END_IF;
                    END_CASE;
                END_IF;
            END_IF;
        END_FOR
    END_FOR
    IF NOT _E THEN
        STATE := 0;
        last := tx;
    END_IF;
ENDSTEP

END
