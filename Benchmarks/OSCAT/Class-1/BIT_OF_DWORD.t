PROC BIT_OF_DOWNWARD_ROLL;
VAR_INPUT
    InputWord : INT;
END_VAR
VAR_OUTPUT
    OutputWord : INT;
END_VAR
VAR
    Temp : INT;
BEGIN

STEP 'ROLL_BITS_DOWN'
    Temp := InputWord;
    OutputWord := SHR(Temp, 1); // One-bit downward shift
ENDSTEP

END.
