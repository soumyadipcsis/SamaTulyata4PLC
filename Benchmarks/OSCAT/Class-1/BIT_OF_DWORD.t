PROC BIT_OF_DOWNWARD_ROLL;
VAR_INPUT
    InputWord : INT;          (* Input word to shift down *)
END_VAR
VAR_OUTPUT
    OutputWord : INT;         (* Output word after downward roll shift *)
END_VAR
VAR
    Temp : INT; i : INT;    (* Loop counter *)
BEGIN
STEP 'ROLL_BITS_DOWN'
    IF InputWord = 0 THEN
        OutputWord := 0;       (* No shift needed if input is zero *)
    ELSE
        OutputWord := SHR(Temp, 1);  (* One-bit downward shift *)
        IF (InputWord AND 1) = 1 THEN
            OutputWord := OutputWord OR (1 SHL 15);  (* Roll the bit to the MSB position *)
        ELSE
            OutputWord := OutputWord;  (* No change if the LSB is 0 *)
        END_IF;
    END_IF;
    FOR i := 1 TO 3 DO  (* Perform a downward shift 3 more times, one each loop iteration *)
        OutputWord := SHR(OutputWord, 1);  (* Shift one bit down each time *)
        IF (OutputWord AND 1) = 1 THEN
            OutputWord := OutputWord OR (1 SHL 15);  (* Roll the bit to MSB *)
        END_IF;
    END_FOR;
ENDSTEP
END
