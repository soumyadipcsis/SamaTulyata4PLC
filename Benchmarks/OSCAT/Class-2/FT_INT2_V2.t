PROC FT_TN64_CIRCULAR_AVG;
VAR
    IN : REAL;
    _T : TIME;

    OUT : REAL;
    TRIG : BOOL;

    length : INT := 64;
    X : ARRAY [0..63] OF REAL;
    cnt : INT;
    last : TIME;
    tx : TIME;
    init : BOOL;
    sum : REAL;
    i : INT;
BEGIN
STEP 'CIRCULAR_AVG_SAMPLE'

tx := UDINT_TO_TIME(T_PLC_MS(en := TRUE));

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

        sum := 0.0;
        FOR i := 0 TO length - 1 DO
            sum := sum + X[i];
        END_FOR;
        OUT := sum / length;
    ELSE
        TRIG := FALSE;
    END_IF;
END_IF;

ENDSTEP
END.
