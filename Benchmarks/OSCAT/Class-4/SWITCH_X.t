PROC SWITCH_X;
VAR_INPUT
    IN1 : BOOL;              (* Input 1 *)
    IN2 : BOOL;              (* Input 2 *)
    IN3 : BOOL;              (* Input 3 *)
    IN4 : BOOL;              (* Input 4 *)
    IN5 : BOOL;              (* Input 5 *)
    IN6 : BOOL;              (* Input 6 *)
    T_DEBOUNCE : INT := 50;  (* Debounce time in ticks (integer) *)
END_VAR

VAR_OUTPUT
    Q1 : BOOL;               (* Output 1 *)
    Q2 : BOOL;               (* Output 2 *)
    Q3 : BOOL;               (* Output 3 *)
    Q4 : BOOL;               (* Output 4 *)
    Q5 : BOOL;               (* Output 5 *)
    Q6 : BOOL;               (* Output 6 *)
    Q31 : BOOL;              (* Output 31 *)
    Q41 : BOOL;              (* Output 41 *)
    Q51 : BOOL;              (* Output 51 *)
    Q61 : BOOL;              (* Output 61 *)
    Q32 : BOOL;              (* Output 32 *)
    Q42 : BOOL;              (* Output 42 *)
    Q52 : BOOL;              (* Output 52 *)
    Q62 : BOOL;              (* Output 62 *)
END_VAR

VAR
    init : BOOL;             (* Initialization flag *)
    T1 : INT;                (* Timer for input IN1 (in integer ticks) *)
    T2 : INT;                (* Timer for input IN2 (in integer ticks) *)
    T3 : INT;                (* Timer for input IN3 (in integer ticks) *)
    T4 : INT;                (* Timer for input IN4 (in integer ticks) *)
    T5 : INT;                (* Timer for input IN5 (in integer ticks) *)
    T6 : INT;                (* Timer for input IN6 (in integer ticks) *)
    tx : INT;                (* Debounce time variable in integer ticks *)
    x1 : BOOL;               (* Edge detection flag for IN1 *)
    x2 : BOOL;               (* Edge detection flag for IN2 *)
    E1 : BOOL;               (* State of IN1 edge detection *)
    E2 : BOOL;               (* State of IN2 edge detection *)
    data1 : INT;             (* Data variable 1 for parallel computation *)
    data2 : INT;             (* Data variable 2 for parallel computation *)
    data3 : INT;             (* Data variable 3 for parallel computation *)
END_VAR

BEGIN

STEP 'INITIALIZE'
    (* Initialize the function block on startup *)
    IF NOT init THEN
        init := TRUE;
        IF T_DEBOUNCE < 50 THEN
            tx := 50;  (* Default debounce time if input is less than 50 *)
        ELSE
            tx := T_DEBOUNCE;  (* Use the provided debounce time *)
        END
        T1 := 0;  (* Timer for IN1 *)
        T2 := 0;  (* Timer for IN2 *)
        T3 := 0;  (* Timer for IN3 *)
        T4 := 0;  (* Timer for IN4 *)
        T5 := 0;  (* Timer for IN5 *)
        T6 := 0;  (* Timer for IN6 *)
    ELSE
        (* Reset output variables *)
        Q1 := FALSE;
        Q2 := FALSE;
        Q3 := FALSE;
        Q4 := FALSE;
        Q5 := FALSE;
        Q6 := FALSE;
        Q31 := FALSE;
        Q41 := FALSE;
        Q51 := FALSE;
        Q61 := FALSE;
        Q32 := FALSE;
        Q42 := FALSE;
        Q52 := FALSE;
        Q62 := FALSE;
    END
ENDSTEP

STEP 'DEBOUNCE_INPUTS'
    (* Read inputs and debounce using integer timers *)
    IF IN1 THEN T1 := T1 + 1; ELSE T1 := 0; END
    IF IN2 THEN T2 := T2 + 1; ELSE T2 := 0; END
    IF IN3 THEN T3 := T3 + 1; ELSE T3 := 0; END
    IF IN4 THEN T4 := T4 + 1; ELSE T4 := 0; END
    IF IN5 THEN T5 := T5 + 1; ELSE T5 := 0; END
    IF IN6 THEN T6 := T6 + 1; ELSE T6 := 0; END
ENDSTEP

STEP 'DETECT_EDGE_IN1'
    (* Detect the rising edge of IN1 and IN2 using integer timers *)
    IF T1 >= tx AND NOT E1 THEN
        x1 := TRUE;  (* Set x1 when IN1 rises *)
    END
    IF T2 >= tx AND NOT E2 THEN
        x2 := TRUE;  (* Set x2 when IN2 rises *)
    END
ENDSTEP

STEP 'PROCESS_INPUTS'
    (* Process inputs and set corresponding outputs based on timers *)
    IF T1 >= tx THEN
        IF T3 >= tx THEN
            Q31 := TRUE;
            x1 := FALSE;
        ELSIF T4 >= tx THEN
            Q41 := TRUE;
            x1 := FALSE;
        ELSIF T5 >= tx THEN
            Q51 := TRUE;
            x1 := FALSE;
        ELSIF T6 >= tx THEN
            Q61 := TRUE;
            x1 := FALSE;
        END
    ELSIF T2 >= tx THEN
        IF T3 >= tx THEN
            Q32 := TRUE;
            x2 := FALSE;
        ELSIF T4 >= tx THEN
            Q42 := TRUE;
            x2 := FALSE;
        ELSIF T5 >= tx THEN
            Q52 := TRUE;
            x2 := FALSE;
        ELSIF T6 >= tx THEN
            Q62 := TRUE;
            x2 := FALSE;
        END
    (* If IN1 was active alone *)
    ELSIF NOT T1 >= tx AND E1 AND x1 THEN
        Q1 := TRUE;
        x1 := FALSE;
    ELSIF NOT T2 >= tx AND E2 AND x2 THEN
        Q2 := TRUE;
        x2 := FALSE;
    ELSIF T3 >= tx THEN
        Q3 := TRUE;
    ELSIF T4 >= tx THEN
        Q4 := TRUE;
    ELSIF T5 >= tx THEN
        Q5 := TRUE;
    ELSIF T6 >= tx THEN
        Q6 := TRUE;
    END
ENDSTEP

STEP 'SAVE_EDGE_STATE'
    (* Save the state of IN1 and IN2 for the next scan cycle *)
    E1 := T1 >= tx;
    E2 := T2 >= tx;
ENDSTEP

STEP 'PARALLEL_LOOP_1'
    (* Parallel data computation loop 1 with INT calculations *)
    FOR i := 1 TO 5 DO
        data1 := i * 2;  (* Simple computation for data1 *)
    END_FOR
ENDSTEP

STEP 'PARALLEL_LOOP_2'
    (* Parallel data computation loop 2 with INT calculations *)
    FOR i := 1 TO 5 DO
        data2 := i * 3;  (* Simple computation for data2 *)
    END_FOR
ENDSTEP

STEP 'PARALLEL_LOOP_3'
    (* Parallel data computation loop 3 with INT calculations *)
    FOR i := 1 TO 5 DO
        data3 := i * 4;  (* Simple computation for data3 *)
    END_FOR
ENDSTEP

END
