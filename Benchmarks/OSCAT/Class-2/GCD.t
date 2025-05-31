PROC GCD_PROC_STYLE;
VAR
    A : INT;
    B : INT;
    _A : INT;
    _B : INT;
    T : INT;
    I : INT;
    J : INT;
    OUT1 : INT;
    INIT : BOOL;
BEGIN
STEP 'CALC_GCD_INT'

// Initialization
IF NOT INIT THEN
    _A := A;
    _B := B;
    OUT1 := 0;
    INIT := TRUE;
ELSE
    // Make positive
    IF _A < 0 THEN
        _A := -_A;
    ELSE
        _A := _A;
    END

    IF _B < 0 THEN
        _B := -_B;
    ELSE
        _B := _B;
    END

    // Nested loop to simulate stepwise GCD using subtraction
    I := 0;
    WHILE (_A <> 0) AND (_B <> 0) AND (I < 10) DO
        J := 0;
        WHILE (_A <> _B) AND (J < 10) DO
            IF _A > _B THEN
                _A := _A - _B;
            ELSE
                _B := _B - _A;
            END
            J := J + 1;
        END_WHILE;
        I := I + 1;
    END_WHILE;

    // Final assignment
    IF _A = 0 THEN
        OUT1 := _B;
    ELSE
        OUT1 := _A;
    END
END
ENDSTEP
END.
