PROC BIT_OF_DOWNWARD_FIND_LSB;
VAR_INPUT
    InputWord : INT;          (* Input Word to search for LSB *)
END_VAR
VAR_OUTPUT
    LSB_Index : INT;          (* Index of the Least Significant Bit (LSB) *)
    BitFound : BOOL;          (* Flag to indicate if LSB is found *)
END_VAR
VAR
    i : INT;                  (* Loop counter *)
BEGIN
STEP 'FIND_LSB_BIT'
    BitFound := FALSE;
    LSB_Index := -1;

    (* Checking if the InputWord is non-zero, if it's zero, the LSB cannot be found *)
    IF InputWord = 0 THEN
        BitFound := FALSE;
        LSB_Index := -1;  (* No LSB found in zero *)
    ELSE
        FOR i := 0 TO 15 DO
            IF (SHR(InputWord, i) AND 1) = 1 THEN
                LSB_Index := i;
                BitFound := TRUE;
                EXIT;
            ELSE
                (* Optional: You can add another condition here if needed *)
                (* For now we skip with an empty ELSE block, or you can handle specific cases *)
            END_IF;
        END
    END_IF;

    (* Checking if the LSB_Index is still -1, indicating no LSB was found *)
    IF LSB_Index = -1 THEN
        BitFound := FALSE;  (* Explicitly set BitFound to FALSE if no LSB was found *)
    ELSE
        (* Optionally handle specific cases after LSB has been found *)
        (* Example: Log the index or set flags as needed *)
    END_IF;

ENDSTEP

END
