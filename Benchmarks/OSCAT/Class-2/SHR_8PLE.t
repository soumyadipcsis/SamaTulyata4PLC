PROC SHR_8PLE_SIM;
VAR
    DIN : BOOL;
    DLOAD : INT;    // simulate BYTE (8 bits)
    CLK : BOOL;
    UP : BOOL;
    LOAD : BOOL;
    RST : BOOL;

    DOUT : BOOL;

    edge : BOOL;
    register : INT;  // 8-bit register (0..7 bits used)
    tempReg : INT;
    I : INT;
    J : INT;
    bitVal : BOOL;
BEGIN
STEP 'SHR_8PLE_WITH_LOOP'

// On rising edge of CLK and not reset
IF CLK AND edge AND NOT RST THEN
    edge := FALSE;

    // Prepare temp register for shift operations
    tempReg := 0;

    IF UP THEN
        // Shift left bit by bit using nested loops
        FOR I := 7 TO 1 BY -1 DO
            FOR J := I TO I DO  // Single iteration loop for demo complexity
                // Copy bit I-1 to bit I of tempReg
                IF (register AND (1 << (I-1))) > 0 THEN
                    tempReg := tempReg OR (1 << I);
                ELSE
                    tempReg := tempReg AND NOT (1 << I);
                END
            END
        END

        // Insert DIN at bit 0
        IF DIN THEN
            tempReg := tempReg OR 1;
        ELSE
            tempReg := tempReg AND NOT 1;
        END

        register := tempReg;

        // DOUT := bit 7
        IF (register AND 128) > 0 THEN
            DOUT := TRUE;
        ELSE
            DOUT := FALSE;
        END

    ELSE
        // Shift right bit by bit using nested loops
        FOR I := 0 TO 6 DO
            FOR J := I TO I DO  // Single iteration nested loop for complexity
                // Copy bit I+1 to bit I of tempReg
                IF (register AND (1 << (I+1))) > 0 THEN
                    tempReg := tempReg OR (1 << I);
                ELSE
                    tempReg := tempReg AND NOT (1 << I);
                END
            END
        END

        // Insert DIN at bit 7
        IF DIN THEN
            tempReg := tempReg OR 128;
        ELSE
            tempReg := tempReg AND NOT 128;
        END

        register := tempReg;

        // DOUT := bit 0
        IF (register AND 1) > 0 THEN
            DOUT := TRUE;
        ELSE
            DOUT := FALSE;
        END
    END_IF;

    // Load operation
    IF LOAD THEN
        register := DLOAD AND 255;

        IF UP THEN
            IF (register AND 128) > 0 THEN
                DOUT := TRUE;
            ELSE
                DOUT := FALSE;
            END
        ELSE
            IF (register AND 1) > 0 THEN
                DOUT := TRUE;
            ELSE
                DOUT := FALSE;
            END
        END_IF;
    END_IF;
END_IF;

// Reset edge flag when CLK is low
IF NOT CLK THEN
    edge := TRUE;
END_IF;

// Reset logic
IF RST THEN
    register := 0;
    DOUT := FALSE;
END_IF;

ENDSTEP
END.
