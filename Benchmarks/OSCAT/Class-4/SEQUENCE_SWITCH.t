PROC SEQUENCE_4_V2;
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

STEP 'TIMEOUT_CHECK'
    (* Timeout check to stop the sequence if it exceeds a limit *)
    IF tx - last > TIMEOUT_LIMIT THEN
        TIMEOUT := TRUE;
        RUN := FALSE;  (* Stop the sequence if timeout occurs *)
        STATUS := BYTE#100;  (* Timeout status *)
    END
ENDSTEP

STEP 'SEQUENCE_RUNNING'
    (* Main sequence logic *)
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

    (* Similar steps for Q1, Q2, Q3 handling *)
ENDSTEP

STEP 'COMBINE_OUTPUT'
    (* Combine outputs into QX *)
    QX := Q0 OR Q1 OR Q2 OR Q3;
ENDSTEP

END
