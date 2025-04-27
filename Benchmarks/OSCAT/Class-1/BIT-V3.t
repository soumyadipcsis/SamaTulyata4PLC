PROC BIT_OF_DOWNWARD_SINGLEBIT;
VAR_INPUT
    InputWord : INT;
END_VAR
VAR_OUTPUT
    BitFound : BOOL;
END_VAR
VAR
    Isolated : INT;
BEGIN

STEP 'CHECK_SINGLE_ACTIVE_BIT'
    IF InputWord > 0 THEN
        Isolated := InputWord AND (InputWord - 1);
        BitFound := (Isolated = 0); // True only if one bit is set
    ELSE
        BitFound := FALSE;
    END
ENDSTEP

END.
