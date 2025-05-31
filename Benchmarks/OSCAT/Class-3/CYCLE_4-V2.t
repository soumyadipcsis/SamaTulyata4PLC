PROC CYCLE_4_VARIANT2;
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
    a, b, c, d, dummyA, dummyB : INT;
BEGIN

LOC=80

STEP 'DUMMY_LOOP_1'
    FOR c := 0 TO 4 DO
        dummyA := c * 3;
    END_FOR
ENDSTEP

STEP 'DUMMY_LOOP_2'
    FOR d := 0 TO 3 DO
        dummyB := d + 8;
    END_FOR
ENDSTEP

STEP 'STARTUP'
    IF NOT init THEN
        init := TRUE;
        last := 0;
        tx := 0;
        STATE := 0;
    END_IF;
ENDSTEP

STEP 'MAIN_NESTED'
    tx := tx + 1;

    FOR a := 0 TO 2 DO
        FOR b := 0 TO 1 DO
            dummyA := a * b;
        END_FOR
    END_FOR

    IF _E THEN
        IF SL THEN
            IF SX < 0 THEN
                STATE := 0;
            ELSIF SX > 3 THEN
                STATE := 3;
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
