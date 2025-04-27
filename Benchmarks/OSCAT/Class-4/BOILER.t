PROC BOILER;
VAR_INPUT
    T_UPPER : INT;          (* Upper temperature input *)
    T_LOWER : INT;          (* Lower temperature input *)
    PRESSURE : BOOL := TRUE; (* Pressure status *)
    ENABLE : BOOL := TRUE;   (* Enable heating *)
    REQ_1 : BOOL;            (* Request 1 *)
    REQ_2 : BOOL;            (* Request 2 *)
    BOOST : BOOL;            (* Boost mode *)
    T_UPPER_MIN : INT := 50;   (* Min upper temperature *)
    T_UPPER_MAX : INT := 60;   (* Max upper temperature *)
    T_LOWER_ENABLE : BOOL;   (* Lower temperature enable flag *)
    T_LOWER_MAX : INT := 60;   (* Max lower temperature *)
    T_REQUEST_1 : INT := 70;   (* Request 1 temperature *)
    T_REQUEST_2 : INT := 50;   (* Request 2 temperature *)
    T_REQUEST_HYS : INT := 5;  (* Hysteresis for request *)
    T_PROTECT_HIGH : INT := 80; (* Protect high temperature *)
    T_PROTECT_LOW : INT := 10;  (* Protect low temperature *)
END_VAR

VAR_OUTPUT
    HEAT : BOOL;      (* Heating status output *)
    ERROR : BOOL;     (* Error status output *)
    STATUS : INT;     (* Current status code *)
END_VAR

VAR
    edge : BOOL;      (* Edge detection flag for boost mode *)
    boost_mode : BOOL; (* Boost mode flag *)
    flag_0 : BOOL;    (* Flag for shutdown conditions *)
    flag_1 : BOOL;    (* Flag for request 1 conditions *)
    flag_2 : BOOL;    (* Flag for request 2 conditions *)
    i : INT;          (* Loop index *)
BEGIN

STEP 'CHECK_SENSOR_CONDITIONS'
    (* Read sensors and check for valid data *)
    IF T_UPPER > T_PROTECT_HIGH THEN
        STATUS := 1;
        HEAT := FALSE;
        ERROR := TRUE;
    ELSIF T_UPPER < T_PROTECT_LOW THEN
        STATUS := 2;
        HEAT := TRUE;
        ERROR := TRUE;
    ELSIF T_LOWER > T_PROTECT_HIGH AND T_LOWER_ENABLE THEN
        STATUS := 3;
        HEAT := FALSE;
        ERROR := TRUE;
    ELSIF T_LOWER < T_PROTECT_LOW AND T_LOWER_ENABLE THEN
        STATUS := 4;
        HEAT := TRUE;
        ERROR := TRUE;
    ELSIF NOT PRESSURE THEN
        STATUS := 5;
        HEAT := FALSE;
        ERROR := TRUE;
    ELSIF REQ_1 OR REQ_2 OR ENABLE OR BOOST THEN
        ERROR := FALSE;

        (* Determine if heat needs to be turned on *)
        IF BOOST AND NOT edge AND T_UPPER < T_UPPER_MAX THEN
            STATUS := 101;
            HEAT := TRUE;
            boost_mode := TRUE;
        ELSIF ENABLE AND T_UPPER < T_UPPER_MIN THEN
            STATUS := 102;
            HEAT := TRUE;
        ELSIF REQ_1 AND T_UPPER < T_REQUEST_1 THEN
            STATUS := 103;
            HEAT := TRUE;
        ELSIF REQ_2 AND T_UPPER < T_REQUEST_2 THEN
            STATUS := 104;
            HEAT := TRUE;
        END_IF;

        (* Determine the shut-off temperature *)
        IF HEAT THEN
            IF (ENABLE OR boost_mode) THEN
                flag_0 := TRUE;
                IF T_LOWER_ENABLE AND T_LOWER > T_LOWER_MAX THEN
                    flag_0 := FALSE;
                    boost_mode := FALSE;
                ELSIF NOT T_LOWER_ENABLE AND T_UPPER > T_UPPER_MAX THEN
                    flag_0 := FALSE;
                    boost_mode := FALSE;
                END_IF;
            ELSE
                flag_0 := FALSE;
            END_IF;
            
            flag_1 := (REQ_1 AND T_UPPER > T_REQUEST_1 + T_REQUEST_HYS) AND REQ_1;
            flag_2 := (REQ_2 AND T_UPPER > T_REQUEST_2 + T_REQUEST_HYS) AND REQ_2;

            (* Shut off heat if no longer needed *)
            HEAT := flag_0 OR flag_1 OR flag_2;
            IF HEAT = FALSE THEN STATUS := 100; END_IF;
        END_IF;
    ELSE
        STATUS := 100;
        HEAT := FALSE;
        ERROR := FALSE;
    END_IF;

    edge := BOOST;

ENDSTEP

(* Parallel data computation loop 1 *)
STEP 'LOOP_1'
    FOR i := 1 TO 5 DO
        (* Simple computation for data1 using INT *)
        flag_0 := i MOD 2 = 0;  (* Example computation to flag even numbers *)
    END_FOR
ENDSTEP

(* Parallel data computation loop 2 *)
STEP 'LOOP_2'
    FOR i := 1 TO 5 DO
        (* Simple computation for data2 using INT *)
        flag_1 := i MOD 3 = 0;  (* Example computation for every 3rd value *)
    END_FOR
ENDSTEP

(* Parallel data computation loop 3 *)
STEP 'LOOP_3'
    FOR i := 1 TO 5 DO
        (* Simple computation for data3 using INT *)
        flag_2 := i MOD 4 = 0;  (* Example computation for every 4th value *)
    END_FOR
ENDSTEP

END
