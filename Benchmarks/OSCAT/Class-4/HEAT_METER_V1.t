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
                    (* Perform some operation *)
                END_FOR;
            END_FOR;
        END_FOR;
    END_FOR;

    (* 4-level nested IF-ELSE statements for complex decision-making *)
    IF C < 10 THEN
        IF C > 5 THEN
            IF C > 2 THEN
                IF C > 1 THEN
                    (* Perform operation *)
                ELSE
                    (* Perform operation *)
                END_IF;
            ELSE
                (* Perform operation *)
            END_IF;
        ELSE
            (* Perform operation *)
        END_IF;
    ELSE
        (* Perform operation *)
    END_IF;
END
