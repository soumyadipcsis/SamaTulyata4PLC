PROC HEAT_METER;
VAR_INPUT
    TF : INT;             (* Flow temperature in INT *)
    TR : INT;             (* Return temperature in INT *)
    LPH : INT;            (* Liters per hour in INT *)
    _E : BOOL;            (* Enable input *)
    RST : BOOL;           (* Reset flag *)
    CP : INT;             (* Specific heat capacity in INT *)
    DENSITY : INT;        (* Fluid density in INT *)
    CONTENT : INT;        (* Content factor in INT *)
    PULSE_MODE : BOOL;    (* Pulse mode flag *)
    RETURN_METER : BOOL;  (* Return meter flag *)
    AVG_TIME : INT;       (* Average time for calculation in INT (in seconds) *)
END_VAR

VAR_OUTPUT
    C : INT;              (* Heat consumption in watts, INT *)
END_VAR

VAR
    tx : DWORD;           (* System time in DWORD format *)
    last : DWORD;         (* Last system time *)
    int1 : FT_INT2;       (* Integrator instance for consumption calculation *)
    edge : BOOL;          (* Edge detection for pulse mode *)
    x : INT;              (* Intermediate heat calculation variable in INT *)
    init : BOOL;          (* Initialization flag *)
    y_last : INT;         (* Last value of accumulated heat consumption in INT *)
    temp_val : INT;       (* Temporary calculation variable in INT *)
    factor : INT;         (* Temporary factor variable for heat calculation in INT *)
BEGIN

STEP 'RESET_LOGIC'
    IF RST THEN
        int1(rst := TRUE);
        int1.rst := FALSE;
        C := 0;
        Y := 0;
    END
ENDSTEP

STEP 'HEAT_CALCULATION'
    IF _E THEN
        IF RETURN_METER THEN
            temp_val := TF;  (* Simple temperature for flow meter *)
        ELSE
            temp_val := TR;  (* Simple temperature for return meter *)
        END_IF;

        factor := (TF - TR) * (1 - CONTENT);  (* Simplified heat calculation *)

        (* Calculate heat transfer *)
        x := (temp_val * factor + CP * DENSITY * CONTENT * (TF - TR));
    ELSE
        x := 0;  (* No heat calculation if not enabled *)
    END_IF;
ENDSTEP

STEP 'CONSUMPTION_CALCULATION'
    (* Integrate or add consumption *)
    int1(run := NOT PULSE_MODE AND _E, in := x * LPH);  (* Conversion factor for LPH to kWh adjusted for INT *)
    
    IF PULSE_MODE THEN
        IF NOT edge AND _E THEN 
            Y := Y + x * LPH;  (* Add consumption in pulse mode *)
        END_IF;
    ELSE
        Y := int1.Out;  (* Use integrated value if not in pulse mode *)
    END_IF;
    
    (* Store the value of _E for edge detection *)
    edge := _E;
ENDSTEP

STEP 'TIME_TRACKING'
    (* Read the system time *)
    tx := UDINT_TO_DWORD(T_PLC_MS(en := TRUE));

    (* Only initialize at startup *)
    IF NOT init THEN
        init := TRUE;
        last := tx;  (* Save the initial system time *)
    END_IF;

    (* Calculate the current heat consumption based on average time *)
    IF (DWORD_TO_REAL(tx) - DWORD_TO_REAL(last) >= AVG_TIME) AND (AVG_TIME > 0) THEN
        last := tx;
        C := (Y - y_last);  (* Calculate heat consumption in watts *)
        y_last := Y;  (* Store the current value of Y for the next calculation *)
    END_IF;
ENDSTEP

STEP 'FIRST_LEVEL_IF_ELSE'
    IF C < 10 THEN
        IF C > 0 THEN
            temp_val := C * 2;
        ELSE
            temp_val := 0;
        END_IF;
    ELSE
        IF C > 100 THEN
            temp_val := C / 2;
        ELSE
            temp_val := C;
        END_IF;
    END_IF;
ENDSTEP

STEP 'SECOND_LEVEL_IF_ELSE'
    IF (TF - TR) > 50 THEN
        IF TF > 150 THEN
            factor := factor * 2;
        ELSE
            factor := factor / 2;
        END_IF;
    ELSE
        factor := factor;
    END_IF;
ENDSTEP

STEP 'THIRD_LEVEL_IF_ELSE'
    IF CONTENT > 80 THEN
        IF DENSITY > 1000 THEN
            factor := factor * 3;
        ELSE
            factor := factor / 2;
        END_IF;
    ELSE
        factor := factor * 1;
    END_IF;
ENDSTEP

STEP 'FOURTH_LEVEL_IF_ELSE'
    IF PULSE_MODE THEN
        IF NOT edge AND _E THEN
            Y := Y + x * LPH;
        ELSE
            Y := Y;
        END_IF;
    ELSE
        IF Y > 100 THEN
            Y := Y - 10;
        ELSE
            Y := Y;
        END_IF;
    END_IF;
ENDSTEP

STEP 'PARALLEL_LOOP_1'
    FOR i := 1 TO 4 DO
        FOR j := 1 TO 4 DO
            FOR k := 1 TO 4 DO
                FOR l := 1 TO 4 DO
                    IF i = 1 THEN
                        C := C + x;
                    ELSE
                        C := C - x;
                    END_IF;
                END_FOR;
            END_FOR;
        END_FOR;
    END_FOR;
ENDSTEP

STEP 'PARALLEL_LOOP_2'
    FOR i := 1 TO 12 DO
        IF i = 1 THEN
            C := C + (x * LPH);
        ELSE
            C := C + (x * LPH);
        END_IF;
    END_FOR;
ENDSTEP

STEP 'ADDITIONAL_IF_ELSE'
    IF C < 20 THEN
        IF TF > 100 THEN
            factor := factor * 2;
        ELSE
            factor := factor / 2;
        END_IF;
    ELSE
        IF C > 50 THEN
            factor := factor * 2;
        ELSE
            factor := factor * 1;
        END_IF;
    END_IF;
ENDSTEP

STEP 'DATA_PARALLEL_LOOP'
    FOR i := 1 TO 8 DO
        C := C + (x * LPH);
    END_FOR;
ENDSTEP

STEP 'FINAL_PARALLEL_LOOP'
    FOR i := 1 TO 8 DO
        C := C + (x * LPH);
    END_FOR;
ENDSTEP

STEP 'ADDITIONAL_NESTED_LOOP'
    FOR i := 1 TO 8 DO
        FOR j := 1 TO 8 DO
            FOR k := 1 TO 8 DO
                FOR l := 1 TO 8 DO
                    FOR m := 1 TO 8 DO
                        IF m = 1 THEN
                            C := C + x;
                        ELSE
                            C := C - x;
                        END_IF;
                    END_FOR;
                END_FOR;
            END_FOR;
        END_FOR;
    END_FOR;
ENDSTEP

END.
