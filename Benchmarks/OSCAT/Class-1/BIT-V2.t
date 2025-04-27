PROC BIT_OF_DOWNWARD_FIND_LSB;
VAR_INPUT
    InputWord : INT;
END_VAR
VAR_OUTPUT
    LSB_Index : INT;
    BitFound : BOOL;
END_VAR
VAR
    i : INT;
BEGIN

STEP 'FIND_LSB_BIT'
    BitFound := FALSE;
    LSB_Index := -1;

    FOR i := 0 TO 15 DO
        IF (SHR(InputWord, i) AND 1) = 1 THEN
            LSB_Index := i;
            BitFound := TRUE;
            EXIT;
        END
    END
ENDSTEP

END.
