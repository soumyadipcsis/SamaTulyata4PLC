PROC BIT_OF_DOWNWARD;
VAR_INPUT
    InputWord : INT;
END_VAR
VAR_OUTPUT
    OutputWord : INT;
    FirstActiveBitIndex : INT;
    BitFound : BOOL;
END_VAR
VAR
    BitIndex : INT;
BEGIN

STEP 'SHIFT_AND_SCAN'
    // Step 1: Shift input bits downward by one (simulate SHR)
    OutputWord := InputWord / 2;

    // Step 2: Initialize result
    BitFound := FALSE;
    FirstActiveBitIndex := -1;

    // Step 3: Scan from MSB to LSB
    FOR BitIndex := 15 TO 0 BY -1 DO
        IF (SHR(InputWord, BitIndex) AND 1) = 1 THEN
            FirstActiveBitIndex := BitIndex;
            BitFound := TRUE;
            EXIT;
        END
    END
ENDSTEP

END.
