PROC BIT_OF_DOWNWARD_SINGLEBIT;
VAR_INPUT
    InputWord : INT;          (* Input word to check for a single active bit *)
END_VAR
VAR_OUTPUT
    BitFound : BOOL;          (* Flag to indicate if a single bit is found *)
END_VAR
VAR
    Isolated : INT;           (* Variable to isolate a single bit *)
    i : INT;                  (* Loop counter *)
BEGIN

LOC=10

STEP 'CHECK_SINGLE_ACTIVE_BIT'
    BitFound := FALSE;        (* Initialize BitFound to FALSE *)

    IF InputWord > 0 THEN
        FOR i := 0 TO 15 DO  (* Loop through all bits in InputWord (16 bits max) *)
            Isolated := InputWord AND (InputWord - 1);  (* Isolate the bit *)
            IF Isolated = 0 THEN
                BitFound := TRUE;  (* True if only one bit is set *)
                EXIT;               (* Exit the loop once the condition is met *)
            END_IF;
        END_FOR
    ELSE
        BitFound := FALSE;      (* No active bit if InputWord is zero *)
    END_IF;

ENDSTEP

END
