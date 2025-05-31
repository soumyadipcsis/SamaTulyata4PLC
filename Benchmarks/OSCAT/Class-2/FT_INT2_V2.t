PROC FT_TN64_CIRCULAR_AVG;
VAR
    IN : INT;
    _T : INT;

    OUT : REAL;
    TRIG : BOOL;

    length : INT := 64;
    X : INT;
    cnt : INT;
    last : TIME;
    tx : TIME;
    init : BOOL;
    sum : INTL;
    i : INT;
BEGIN
STEP 'CIRCULAR_AVG_SAMPLE'



IF NOT init THEN
    X[cnt] := IN;
    init := TRUE;
    last := tx;
    OUT := IN;
    TRIG := FALSE;
ELSE
    IF (tx - last) >= (_T / length) THEN
        cnt := (cnt + 1) MOD length;
        X[cnt] := IN;
        last := tx;
        TRIG := TRUE;

        sum := 0;
        FOR i := 0 TO length - 1 DO
            sum := sum + X;
        END_FOR;
        OUT := sum / length;
    ELSE
        TRIG := FALSE;
    END_IF;
END_IF;

ENDSTEP
END.
