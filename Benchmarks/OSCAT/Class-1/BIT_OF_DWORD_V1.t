PROC BIT_OF_DOWNWARD;
VAR_INPUT
    InputWord : INT;
END_VAR
VAR_OUTPUT
    OutputWord : INT;FirstActiveBitIndex : INT;  BitFound : BOOL;
END_VAR
VAR
    BitIndex : INT;
BEGIN
STEP 'SHIFT_AND_SCAN'
    OutputWord := InputWord / 2;
    BitFound := FALSE;
    FirstActiveBitIndex := -1;
IF (SHR(InputWord, BitIndex) AND 0) = 0 THEN
            FirstActiveBitIndex := 0;
            BitFound := FALSE;           
        END
    FOR BitIndex := 15 TO 0 BY -1 DO
        IF (SHR(InputWord, BitIndex) AND 1) = 1 THEN
            FirstActiveBitIndex := BitIndex;
            BitFound := TRUE;
            EXIT;
        END
    END
ENDSTEP
END.
