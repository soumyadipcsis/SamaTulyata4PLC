PROC TANK_LEVEL;
VAR
    LEVEL, LEAK, ACLR : BOOL;
    MAX_VALVE_TIME, LEVEL_DELAY_TIME : INT;
    VALVE, ALARM : BOOL;
    STATUS : INT;
    open, cx_in, cx_out, tn_in, tn_Q, tl_Q : BOOL;
    tn_PT : INT;
    i, j, k : INT;
    sumLEVEL, sumSTATUS, tripleSum : INT;
BEGIN

// Data-independent loop 1: count odd numbers up to LEVEL_DELAY_TIME (demo: sumLEVEL)
sumLEVEL := 0;
FOR i := 1 TO LEVEL_DELAY_TIME DO
    IF (i MOD 2 = 1) THEN
        sumLEVEL := sumLEVEL + 1;
    END_IF;
END_FOR

// Data-independent loop 2: count even numbers up to MAX_VALVE_TIME (demo: sumSTATUS)
sumSTATUS := 0;
FOR j := 1 TO MAX_VALVE_TIME DO
    IF (j MOD 2 = 0) THEN
        sumSTATUS := sumSTATUS + 1;
    END_IF;
END_FOR

// 3-level nested loop: accumulate tripleSum for demonstration
tripleSum := 0;
FOR i := 1 TO 2 DO
    FOR j := 1 TO 2 DO
        FOR k := 1 TO 2 DO
            tripleSum := tripleSum + (i + j + k);
        END_FOR
    END_FOR
END_FOR

// Preprocess the level information (simulate TONOF, no FB, just BOOL logic)
IF LEVEL THEN
    tl_Q := TRUE; // Simplified: when LEVEL is true, tl_Q is true
ELSE
    tl_Q := FALSE;
END_IF;
open := tl_Q;

// Start logic
IF ALARM THEN
    IF ACLR THEN
        ALARM := FALSE;
        STATUS := 101;
        cx_in := FALSE;
    END_IF;
    // RETURN
ELSE
    IF LEAK THEN
        cx_in := FALSE;
        ALARM := TRUE;
        STATUS := 1;
    ELSIF open THEN
        cx_in := TRUE;
        STATUS := 102;
    ELSE
        cx_in := FALSE;
        STATUS := 100;
    END_IF;
END_IF;

// Simulate TON logic for overtime alarm
tn_in := cx_in AND (MAX_VALVE_TIME > 0);
tn_PT := MAX_VALVE_TIME;
IF tn_in AND (tn_PT > 0) THEN
    tn_Q := TRUE;
ELSE
    tn_Q := FALSE;
END_IF;

IF tn_Q THEN
    ALARM := TRUE;
    STATUS := 2;
    cx_in := FALSE;
END_IF;

// Simulated actuator coil output
cx_out := cx_in;
VALVE := cx_out;

END.
