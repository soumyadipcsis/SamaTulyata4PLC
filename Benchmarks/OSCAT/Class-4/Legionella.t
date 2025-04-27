PROC LEGIONELLA
VAR_INPUT
    MANUAL : BOOL;
    TEMP_BOILER : INT;        (* Integer temperature for boiler *)
    TEMP_RETURN : INT := 100; (* Integer temperature for return *)
    DT_IN : UDINT;           (* Input time value *)
    RST : BOOL;
    T_START : UDINT := 10800000;  (* Start time in integer format *)
    DAY : INT := 7;          (* Day of the week (integer value) *)
    TEMP_SET : INT := 70;    (* Target setpoint temperature for boiler *)
    TEMP_OFFSET : INT := 10; (* Temperature offset *)
    TEMP_HYS : INT := 5;     (* Hysteresis value *)
    T_MAX_HEAT : INT := 600; (* Max heating time in seconds *)
    T_MAX_RET : INT := 600;  (* Max return time in seconds *)
    TP_0 : INT := 300;       (* Time periods as integers (in seconds) *)
    TP_1 : INT := 300;
    TP_2 : INT := 300;
    TP_3 : INT := 300;
    TP_4 : INT := 300;
    TP_5 : INT := 300;
    TP_6 : INT := 300;
    TP_7 : INT := 300;
END_VAR

VAR_OUTPUT
    HEAT : BOOL;
    PUMP : BOOL;
    VALVE0 : BOOL;
    VALVE1 : BOOL;
    VALVE2 : BOOL;
    VALVE3 : BOOL;
    VALVE4 : BOOL;
    VALVE5 : BOOL;
    VALVE6 : BOOL;
    VALVE7 : BOOL;
    RUN : BOOL;
    STATUS : BYTE;
END_VAR

VAR
    X1 : TIMER_1;    (* Timer 1 control structure *)
    X2 : SEQUENCE_8; (* Sequence logic control *)
    X3 : HYST_1;     (* Hysteresis logic *)
    init : BOOL;     (* Initialization flag *)
END_VAR

BEGIN

STEP 'INITIALIZE'
    (* Initialization at startup *)
    IF NOT init THEN
        init := TRUE;
        X1.day := SHR(BYTE#128, DAY);      (* Set day value for the timer *)
        X1.start := T_START;               (* Set the start time for the timer *)
        X3.low := TEMP_OFFSET + TEMP_SET;  (* Set hysteresis low threshold *)
        X3.high := TEMP_HYS + X3.low;     (* Set hysteresis high threshold *)
        X2.wait0 := T_MAX_HEAT;           (* Set max heat waiting time *)
        X2.delay0 := TP_0;                (* Set time delays for sequence *)
        X2.delay1 := TP_1;
        X2.delay2 := TP_2;
        X2.delay3 := TP_3;
        X2.delay4 := TP_4;
        X2.delay5 := TP_5;
        X2.delay6 := TP_6;
        X2.delay7 := TP_7;
        X2.wait1 := T_MAX_RET;            (* Set max return waiting time *)
        X2.wait2 := T_MAX_RET;
        X2.wait3 := T_MAX_RET;
        X2.wait4 := T_MAX_RET;
        X2.wait5 := T_MAX_RET;
        X2.wait6 := T_MAX_RET;
        X2.wait7 := T_MAX_RET;
        X2();                             (* Execute the sequence *)
    END
ENDSTEP

STEP 'OPERATION_LOOP_1'
    (* Parallel Loop 1: Process temperature and hysteresis for valves 0 to 3 *)
    X1(DTi := DT_IN);                   (* Input time processing for X1 *)
    IF X1.Q OR MANUAL OR X2.run THEN
        X3(in := TEMP_BOILER);           (* Hysteresis control for temperature *)
        
        LOOP i := 0 TO 3 DO
            (* Process valves 0 to 3 *)
            CASE i OF
                0: X2.in0 := X3.Q OR X3.win;
                1: X2.in1 := TEMP_RETURN >= TEMP_SET;
                2: X2.in2 := X2.in1;
                3: X2.in3 := X2.in1;
            END_CASE;
        END_LOOP;
    END
ENDSTEP

STEP 'OPERATION_LOOP_2'
    (* Parallel Loop 2: Process valves 4 to 7 and check temperature for heating *)
    IF X1.Q OR MANUAL OR X2.run THEN
        LOOP i := 4 TO 7 DO
            (* Process valves 4 to 7 *)
            CASE i OF
                4: X2.in4 := X2.in1;
                5: X2.in5 := X2.in1;
                6: X2.in6 := X2.in1;
                7: X2.in7 := X2.in1;
            END_CASE;
        END_LOOP;
    END
ENDSTEP

STEP 'OPERATION_LOOP_3'
    (* Parallel Loop 3: Run pump and heat logic *)
    IF X1.Q OR MANUAL OR X2.run THEN
        LOOP i := 0 TO 1 DO
            CASE i OF
                0: RUN := X2.run;               (* Set the run status from sequence output *)
                1: PUMP := X2.QX;               (* Control pump based on sequence output *)
            END_CASE;
        END_LOOP;
        HEAT := NOT X3.Q AND X2.run;     (* Activate heat if no hysteresis and sequence is running *)
    END
ENDSTEP

STEP 'OPERATION_LOOP_4'
    (* Parallel Loop 4: Control valves and final status updates *)
    IF X1.Q OR MANUAL OR X2.run THEN
        LOOP i := 0 TO 7 DO
            (* Control valves 0 to 7 based on the sequence output *)
            CASE i OF
                0: VALVE0 := X2.Q0;
                1: VALVE1 := X2.Q1;
                2: VALVE2 := X2.Q2;
                3: VALVE3 := X2.Q3;
                4: VALVE4 := X2.Q4;
                5: VALVE5 := X2.Q5;
                6: VALVE6 := X2.Q6;
                7: VALVE7 := X2.Q7;
            END_CASE;
        END_LOOP;
        PUMP := X2.QX;                   (* Update pump status *)
        STATUS := X2.status;             (* Update status from sequence logic *)
    ELSE
        X2(start := FALSE);              (* Stop the sequence if conditions aren't met *)
        STATUS := X2.status;             (* Maintain the current status *)
    END
ENDSTEP

END
