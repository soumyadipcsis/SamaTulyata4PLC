PROC SWITCH_X;
VAR_INPUT
    IN1 : BOOL;              (* Input 1 *)
    IN2 : BOOL;              (* Input 2 *)
    IN3 : BOOL;              (* Input 3 *)
    IN4 : BOOL;              (* Input 4 *)
    IN5 : BOOL;              (* Input 5 *)
    IN6 : BOOL;              (* Input 6 *)
    T_DEBOUNCE : TIME := t#50ms;  (* Debounce time *)
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
    T1 : TOF;                (* Timer for input IN1 *)
    T2 : TOF;                (* Timer for input IN2 *)
    T3 : TOF;                (* Timer for input IN3 *)
    T4 : TOF;                (* Timer for input IN4 *)
    T5 : TOF;                (* Timer for input IN5 *)
    T6 : TOF;                (* Timer for input IN6 *)
    tx : TIME;               (* Debounce time variable *)
    x1 : BOOL;               (* Edge detection flag for IN1 *)
    x2 : BOOL;               (* Edge detection flag for IN2 *)
    E1 : BOOL;               (* State of IN1 edge detection *)
    E2 : BOOL;               (* State of IN2 edge detection *)
END_VAR

BEGIN

STEP 'INITIALIZE'
    (* Initialize the function block on startup *)
    IF NOT init THEN
        init := TRUE;
        IF T_DEBOUNCE < t#50ms THEN
            tx := t#50ms;
        ELSE
            tx := T_DEBOUNCE;
        END
        T1(PT := tx);  (* Timer for IN1 *)
        T2(PT := tx);  (* Timer for IN2 *)
        T3(PT := tx);  (* Timer for IN3 *)
        T4(PT := tx);  (* Timer for IN4 *)
        T5(PT := tx);  (* Timer for IN5 *)
        T6(PT := tx);  (* Timer for IN6 *)
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
    (* Read inputs and debounce using timers *)
    T1(IN := IN1);
    T2(IN := IN2);
    T3(IN := IN3);
    T4(IN := IN4);
    T5(IN := IN5);
    T6(IN := IN6);
ENDSTEP

STEP 'DETECT_EDGE_IN1'
    (* Detect the rising edge of IN1 and IN2 *)
    IF T1.Q AND NOT E1 THEN
        x1 := TRUE;  (* Set x1 when IN1 rises *)
    END
    IF T2.Q AND NOT E2 THEN
        x2 := TRUE;  (* Set x2 when IN2 rises *)
    END
ENDSTEP

STEP 'PROCESS_INPUTS'
    (* Process inputs and set corresponding outputs based on timers *)
    IF T1.Q THEN
        IF T3.Q THEN
            Q31 := TRUE;
            x1 := FALSE;
        ELSIF T4.Q THEN
            Q41 := TRUE;
            x1 := FALSE;
        ELSIF T5.Q THEN
            Q51 := TRUE;
            x1 := FALSE;
        ELSIF T6.Q THEN
            Q61 := TRUE;
            x1 := FALSE;
        END
    ELSIF T2.Q THEN
        IF T3.Q THEN
            Q32 := TRUE;
            x2 := FALSE;
        ELSIF T4.Q THEN
            Q42 := TRUE;
            x2 := FALSE;
        ELSIF T5.Q THEN
            Q52 := TRUE;
            x2 := FALSE;
        ELSIF T6.Q THEN
            Q62 := TRUE;
            x2 := FALSE;
        END
    (* If IN1 was active alone *)
    ELSIF NOT T1.Q AND E1 AND x1 THEN
        Q1 := TRUE;
        x1 := FALSE;
    ELSIF NOT T2.Q AND E2 AND x2 THEN
        Q2 := TRUE;
        x2 := FALSE;
    ELSIF T3.Q THEN
        Q3 := TRUE;
    ELSIF T4.Q THEN
        Q4 := TRUE;
    ELSIF T5.Q THEN
        Q5 := TRUE;
    ELSIF T6.Q THEN
        Q6 := TRUE;
    END
ENDSTEP

STEP 'SAVE_EDGE_STATE'
    (* Save the state of IN1 and IN2 for the next scan cycle *)
    E1 := T1.Q;
    E2 := T2.Q;
ENDSTEP

END
