PROC SEQUENCE_4
VAR_INPUT
    IN0 : BOOL := TRUE;    (* Input 0 *)
    IN1 : BOOL := TRUE;    (* Input 1 *)
    IN2 : BOOL := TRUE;    (* Input 2 *)
    IN3 : BOOL := TRUE;    (* Input 3 *)
    START : BOOL;          (* Start input *)
    RST : BOOL;            (* Reset input *)
    STOP_ON_ERROR : BOOL;  (* Stop on error flag *)
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
END_VAR

VAR
    last : INT;    (* Last time check, replaced TIME with INT *)
    edge : BOOL;   (* Edge detection flag *)
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
    END
ENDSTEP

STEP 'START_EDGE'
    (* Edge detection for the start input *)
    IF START AND NOT edge THEN
        _STEP := 0;
        last := tx;
        STATUS := BYTE#111;  (* Start status *)
        Q0 := FALSE;
        Q1 := FALSE;
        Q2 := FALSE;
        Q3 := FALSE;
        RUN := TRUE;
    END
    edge := START;
ENDSTEP

STEP 'STOP_ON_ERROR'
    (* Check if stop on error is necessary *)
    IF STATUS > BYTE#0 AND STATUS < BYTE#100 AND STOP_ON_ERROR THEN
        RETURN;
    END
ENDSTEP

STEP 'SEQUENCE_RUNNING'
    (* Main sequence logic *)
    IF RUN AND _STEP = 0 THEN
        IF NOT Q0 AND IN0 AND tx - last <= 0 THEN
            Q0 := TRUE;
            last := tx;
        ELSIF NOT Q0 AND tx - last > 0 THEN
            STATUS := BYTE#1;
            RUN := FALSE;
        ELSIF Q0 AND tx - last >= 0 THEN
            _STEP := 1;
            last := tx;
        END
    END

    IF RUN AND _STEP = 1 THEN
        IF NOT Q1 AND IN1 AND tx - last <= 0 THEN
            Q0 := FALSE;
            Q1 := TRUE;
            last := tx;
        ELSIF NOT Q1 AND tx - last > 0 THEN
            STATUS := BYTE#2;
            Q0 := FALSE;
            RUN := FALSE;
        ELSIF Q1 AND tx - last >= 0 THEN
            _STEP := 2;
            last := tx;
        END
    END

    IF RUN AND _STEP = 2 THEN
        IF NOT Q2 AND IN2 AND tx - last <= 0 THEN
            Q1 := FALSE;
            Q2 := TRUE;
            last := tx;
        ELSIF NOT Q2 AND tx - last > 0 THEN
            STATUS := BYTE#3;
            Q1 := FALSE;
            RUN := FALSE;
        ELSIF Q2 AND tx - last >= 0 THEN
            _STEP := 3;
            last := tx;
        END
    END

    IF RUN AND _STEP = 3 THEN
        IF NOT Q3 AND IN3 AND tx - last <= 0 THEN
            Q2 := FALSE;
            Q3 := TRUE;
            last := tx;
        ELSIF NOT Q3 AND tx - last > 0 THEN
            STATUS := BYTE#4;
            Q2 := FALSE;
            RUN := FALSE;
        ELSIF Q3 AND tx - last >= 0 THEN
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

END
