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
    data1 : INT;   (* Data variable 1 for parallel computation *)
    data2 : INT;   (* Data variable 2 for parallel computation *)
    data3 : INT;   (* Data variable 3 for parallel computation *)
    data4 : INT;   (* Data variable 4 for parallel computation *)
    data5 : INT;   (* Data variable 5 for parallel computation *)
    data6 : INT;   (* Data variable 6 for parallel computation *)
    data7 : INT;   (* Data variable 7 for parallel computation *)
    data8 : INT;   (* Data variable 8 for parallel computation *)
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

STEP 'DATA_PARALLEL_LOOP_3'
    (* Parallel loop 3 for data computation *)
    FOR i := 1 TO 8 DO
        data3 := i * 4;  (* Simple computation for parallel data loop 3 *)
    END_FOR;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_4'
    (* Parallel loop 4 for data computation *)
    FOR i := 1 TO 8 DO
        data4 := i * 5;  (* Simple computation for parallel data loop 4 *)
    END_FOR;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_5'
    (* Parallel loop 5 for data computation *)
    FOR i := 1 TO 8 DO
        data5 := i * 6;  (* Simple computation for parallel data loop 5 *)
    END_FOR;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_6'
    (* Parallel loop 6 for data computation *)
    FOR i := 1 TO 8 DO
        data6 := i * 7;  (* Simple computation for parallel data loop 6 *)
    END_FOR;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_7'
    (* Parallel loop 7 for data computation *)
    FOR i := 1 TO 8 DO
        data7 := i * 8;  (* Simple computation for parallel data loop 7 *)
    END_FOR;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP_8'
    (* Parallel loop 8 for data computation *)
    FOR i := 1 TO 8 DO
        data8 := i * 9;  (* Simple computation for parallel data loop 8 *)
    END_FOR;
ENDSTEP

STEP 'NESTED_LOOP_1'
    (* 8-level nested loop *)
    FOR i := 1 TO 4 DO
        FOR j := 1 TO 4 DO
            FOR k := 1 TO 4 DO
                FOR l := 1 TO 4 DO
                    FOR m := 1 TO 4 DO
                        FOR n := 1 TO 4 DO
                            FOR o := 1 TO 4 DO
                                FOR p := 1 TO 4 DO
                                    Q0 := Q0 AND IN0;  (* Example nested loop logic *)
                                END_FOR;
                            END_FOR;
                        END_FOR;
                    END_FOR;
                END_FOR;
            END_FOR;
        END_FOR;
    END_FOR;
ENDSTEP

END_PROC
