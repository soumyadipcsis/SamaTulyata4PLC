PROC FT_TN64;
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
BEGIN
STEP 'TIME_SHIFT_SAMPLE'

// Get current time in ms
tx := UDINT_TO_TIME(T_PLC_MS(en := TRUE));

// First initialization
IF NOT init THEN
    X[cnt] := IN;
    init := TRUE;
    last := tx;
    TRIG := FALSE;
ELSE
    // Perform sampling every _T / length
    IF (tx - last) >= (_T / length) THEN
        IF cnt = (length - 1) THEN
            cnt := 0;
        ELSE
            cnt := cnt + 1;
        END_IF;

        OUT := X[cnt];
        X[cnt] := IN;
        last := tx;
        TRIG := TRUE;
    ELSE
        TRIG := FALSE;
    END_IF;
END_IF;

ENDSTEP
END.
