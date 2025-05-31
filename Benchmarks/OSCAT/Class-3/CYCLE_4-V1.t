PROC CYCLE_4_VARIANT1;
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
    i, j, k, m, dummy1, dummy2 : INT;
BEGIN

LOC=70

STEP 'DATA_INDEPENDENT_LOOP_1'
    FOR k := 0 TO 4 DO
        dummy1 := k * 2;
    END_FOR
ENDSTEP

STEP 'DATA_INDEPENDENT_LOOP_2'
    FOR m := 1 TO 5 DO
        dummy2 := m + 6;
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

STEP 'CYCLE_NESTED_LOOP'
    tx := tx + 1;

    FOR i := 0 TO 1 DO
        FOR j := 0 TO 2 DO
            dummy1 := i + j;
        END_FOR
    END_FOR

    IF _E THEN
        IF SL THEN
            IF SX > 3 THEN
                STATE := 3;
            ELSIF SX < 0 THEN
                STATE := 0;
            ELSE
                STATE := SX;
            END_IF;
            last := tx;
            SL := FALSE;
        ELSE
            CASE STATE OF
                0:
                    IF (tx - last) >= T0 THEN
                        STATE := 1;
                        last := tx;
                    END_IF;
                1:
                    IF (tx - last) >= T1 THEN
                        STATE := 2;
                        last := tx;
                    END_IF;
                2:
                    IF (tx - last) >= T2 THEN
                        STATE := 3;
                        last := tx;
                    END_IF;
                3:
                    IF (tx - last) >= T3 THEN
                        IF S0 THEN
                            STATE := 0;
                        END_IF;
                        last := tx;
                    END_IF;
            END_CASE;
        END_IF;
    ELSE
        STATE := 0;
        last := tx;
    END_IF;
ENDSTEP

END
