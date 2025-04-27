PROC SEQUENCE_SWITCH_CONTROL;
VAR_INPUT
    IN0 : BOOL := TRUE;    (* Input 0 *)
    IN1 : BOOL := TRUE;    (* Input 1 *)
    IN2 : BOOL := TRUE;    (* Input 2 *)
    IN3 : BOOL := TRUE;    (* Input 3 *)
    START : BOOL;          (* Start input *)
    RST : BOOL;            (* Reset input *)
    TIMEOUT_LIMIT : INT := 5000;  (* Timeout limit in integer ticks *)
END_VAR

VAR_OUTPUT
    Q0 : BOOL;   (* Output 0 *)
    Q1 : BOOL;   (* Output 1 *)
    Q2 : BOOL;   (* Output 2 *)
    Q3 : BOOL;   (* Output 3 *)
    QX : BOOL;   (* Combined output *)
    RUN : BOOL;  (* Running status *)
    _STEP : INT := -1;  (* Step tracking *)
    STATUS : BYTE;      (* Status flag *)
    TIMEOUT : BOOL := FALSE; (* Timeout detection flag *)
END_VAR

VAR
    last : INT;    (* Last time check, replaced TIME with INT *)
    tx : INT;      (* Time value tracking *)
    init : BOOL;   (* Initialization flag *)
    data1 : INT;   (* Data variable 1 for parallel computation *)
    data2 : INT;   (* Data variable 2 for parallel computation *)
    data3 : INT;   (* Data variable 3 for parallel computation *)
    data4 : INT;   (* Data variable 4 for parallel computation *)
END_VAR

BEGIN

STEP 'INITIALIZE'
    (* Initialize on startup *)
    IF NOT init THEN
        last := tx;
        init := TRUE;
        STATUS := BYTE#110;  (* Default status *)
        TIMEOUT := FALSE;
    END
ENDSTEP

STEP 'RESET'
    (* Asynchronous reset logic *)
    IF RST THEN
        _STEP := -1;
        Q0 := FALSE;
        Q1 := FALSE;
        Q2 := FALSE;
        Q3 := FALSE;
        STATUS := BYTE#110;  (* Reset status *)
        RUN := FALSE;
        TIMEOUT := FALSE;
    END
ENDSTEP

STEP 'START'
    (* Check if the sequence should start *)
    IF START AND NOT TIMEOUT THEN
        _STEP := 0;
        last := tx;
        STATUS := BYTE#111;  (* Start status *)
        Q0 := FALSE;
        Q1 := FALSE;
        Q2 := FALSE;
        Q3 := FALSE;
        RUN := TRUE;
    END
ENDSTEP

STEP 'SEQUENCE_RUNNING'
    (* Main sequence logic for Q0, Q1, Q2, Q3 *)
    IF RUN AND _STEP = 0 THEN
        IF NOT Q0 AND IN0 THEN
            Q0 := TRUE;
            last := tx;
        ELSIF NOT Q0 AND tx - last > 1000 THEN
            STATUS := BYTE#1;
            RUN := FALSE;
        ELSIF Q0 AND tx - last >= 1000 THEN
            _STEP := 1;
            last := tx;
        END
    END

    IF RUN AND _STEP = 3 THEN
        IF NOT Q3 AND IN3 THEN
            Q2 := FALSE;
            Q3 := TRUE;
            last := tx;
        ELSIF NOT Q3 AND tx - last > 1000 THEN
            STATUS := BYTE#4;
            Q2 := FALSE;
            RUN := FALSE;
        ELSIF Q3 AND tx - last >= 1000 THEN
            _STEP := -1;
            Q3 := FALSE;
            RUN := FALSE;
            STATUS := BYTE#110;  (* Reset status *)
        END
    END
ENDSTEP

STEP 'COMBINE_OUTPUT'
    (* Combine outputs into QX *)
    QX := Q0 OR Q1 OR Q2 OR Q3;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_1'
    (* Parallel loop 1 for data computation *)
    FOR i := 1 TO 8 DO
        data1 := i * 2;  (* Simple computation for parallel data loop 1 *)
    END_FOR;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_2'
    (* Parallel loop 2 for data computation *)
    FOR i := 1 TO 8 DO
        data2 := i * 3;  (* Simple computation for parallel data loop 2 *)
    END_FOR;
ENDSTEP

ENDSTEP

END_PROC
`
