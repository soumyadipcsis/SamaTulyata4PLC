PROC HEAT_METER_V1;
VAR_INPUT
    TF, TR, LPH, CP, DENSITY, CONTENT, AVG_TIME : INT;
    _E, RST : BOOL;
END_VAR
VAR_OUTPUT
    C : INT;
END_VAR
VAR
    x, Y, last, tx : INT;
    init : BOOL;
BEGIN
    IF RST THEN
        Y := 0;
        C := 0;
        init := FALSE;
    END_IF;

    IF _E THEN
        x := (TF - TR) * (1 - CONTENT);
        Y := Y + x * LPH;
    END_IF;

    tx := T_PLC_MS();
    IF NOT init THEN
        last := tx;
        init := TRUE;
    END_IF;

    IF tx - last >= AVG_TIME THEN
        C := Y;
        last := tx;
    END_IF;

    (* 4-level nested loops for data parallelism *)
    FOR i := 1 TO 4 DO
        FOR j := 1 TO 4 DO
            FOR k := 1 TO 4 DO
                FOR l := 1 TO 4 DO
                    (* Perform some operation in the loop *)
                    C := C + (x * LPH);  (* Example operation: accumulate heat consumption *)
                END_FOR;
            END_FOR;
        END_FOR;
    END_FOR;

    (* 4-level nested parallel loop (additional) *)
    FOR i := 1 TO 4 DO
        FOR j := 1 TO 4 DO
            (* Parallel task, calculating and adding to C in parallel *)
            C := C + (x * LPH);  (* Example of a parallel addition operation *)
        END_FOR;
    END_FOR;

    (* 4-level nested IF-ELSE statements for complex decision-making *)
    IF C < 10 THEN
        IF C > 5 THEN
            IF C > 2 THEN
                IF C > 1 THEN
                    (* Perform operation when C is between 1 and 2 *)
                    C := C + 1;
                ELSE
                    (* Perform operation when C is between 0 and 1 *)
                    C := C - 1;
                END_IF;
            ELSE
                (* Perform operation when C is between 0 and 5 *)
                C := C + 2;
            END_IF;
        ELSE
            (* Perform operation when C is less than 5 *)
            C := C + 3;
        END_IF;
    ELSE
        (* Perform operation when C is greater than or equal to 10 *)
        C := C * 2;  (* Example operation: double the heat consumption *)
    END_IF;
END
