PROC MEASURE_SCAN_CYCLE;
VAR
    StartPB : BOOL;
    ResetPB : BOOL;

    ToggleOutput : BOOL;
    Display : INT;

    LatchingBit : BOOL;
    TimerCounter : INT;      // Simulated timer counter in seconds
    Counter : INT;

    I : INT;
    J : INT;
BEGIN
STEP 'MEASURE_SCAN_CYCLE_LOGIC'

// Toggle output every cycle
ToggleOutput := NOT ToggleOutput;

// Simulate timer counting if latched
IF LatchingBit THEN
    TimerCounter := TimerCounter + 1;
ELSE
    TimerCounter := 0;
END

// Two level nested loops simulating scan cycles and sub-cycles
I := 0;
WHILE I < 3 DO
    J := 0;
    WHILE J < 2 DO

        // IF-ELSE 1: StartPB and timer check to latch bit
        IF StartPB AND (TimerCounter = 0) THEN
            LatchingBit := TRUE;
        ELSE
            LatchingBit := LatchingBit;
        END

        // IF-ELSE 2: Timer running or stopped controls latched timer counter
        IF LatchingBit THEN
            TimerCounter := TimerCounter + 1;
        ELSE
            TimerCounter := 0;
        END

        // IF-ELSE 3: ResetPB resets counter, else increment if timer active
        IF ResetPB THEN
            Counter := 0;
        ELSE
            IF TimerCounter > 0 THEN
                Counter := Counter + 1;
            ELSE
                Counter := Counter;
            END
        END

        J := J + 1;
    END_WHILE;
    I := I + 1;
END_WHILE;

// Display current counter value
Display := Counter;

ENDSTEP
END.
