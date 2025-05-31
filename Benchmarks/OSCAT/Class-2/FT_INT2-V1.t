PROC FT_TN64_NOARRAY_DELAY;
VAR
    IN : REAL;
    _T : TIME;

    OUT : REAL;
    TRIG : BOOL;

    last : TIME;
    tx : TIME;
    init : BOOL;
BEGIN
STEP 'DELAYED_SAMPLE_NO_ARRAY'

tx := UDINT_TO_TIME(T_PLC_MS(en := TRUE));

IF NOT init THEN
    OUT := IN;
    init := TRUE;
    last := tx;
    TRIG := FALSE;
ELSE
    IF (tx - last) >= _T THEN
        OUT := IN;
        TRIG := TRUE;
        last := tx;
    ELSE
        TRIG := FALSE;
    END_IF;
END_IF;

ENDSTEP
END.
