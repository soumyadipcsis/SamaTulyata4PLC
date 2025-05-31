PROC FT_TN64_ADVANCED;
VAR
    IN : REAL;
    _T : TIME;
    EN : BOOL;           // Enable sampling
    MODE_AVG : BOOL;     // If TRUE, output average instead of delayed value

    OUT : REAL;
    TRIG : BOOL;

    length : INT;        // Variable length (set externally, max 64)
    X : ARRAY [0..63] OF REAL;
    cnt : INT;
    last : TIME;
    tx : TIME;
    init : BOOL;

    i : INT;
    sum : REAL;
    sample_interval : TIME;
BEGIN
STEP 'ADVANCED_SHIFT_SAMPLE'

// Current time in PLC ms
tx := UDINT_TO_TIME(T_PLC_MS(en := TRUE));

// Compute dynamic sampling interval
IF length > 0 THEN
    sample_interval := _T / length;
ELSE
    sample_interval := _T; // Fallback
END_IF;

// Initialize on first call
IF NOT init THEN
    X[cnt] := IN;
    last := tx;
    init := TRUE;
    TRIG := FALSE;
    OUT := IN;
ELSE
    IF EN THEN
        // If enough time has passed, advance buffer
        IF (tx - last) >= sample_interval THEN
            cnt := (cnt + 1) MOD length;
            X[cnt] := IN;
            last := tx;
            TRIG := TRUE;

            // Output mode: average or sampled value
            IF MODE_AVG THEN
                sum := 0.0;
                FOR i := 0 TO length - 1 DO
                    sum := sum + X[i];
                END_FOR;
                OUT := sum / length;
            ELSE
                OUT := X[cnt];
            END_IF;

        ELSE
            TRIG := FALSE;
        END_IF;
    ELSE
        TRIG := FALSE;
    END_IF;
END_IF;

ENDSTEP
END.
