PROC STORE_8_PROC_INT_BOOL_2LEVEL_NESTED_LOOP;
VAR
    SET, D0, D1, D2, D3, D4, D5, D6, D7, CLR, RST : BOOL;
    Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 : BOOL;
    edge : BOOL;
    sumD, sumQ, i, j : INT;
BEGIN

// 2-level nested loop: simulate some data-independent computation
sumD := 0;
FOR i := 0 TO 1 DO
    FOR j := 0 TO 3 DO
        sumD := sumD + (i + j);
    END_FOR
END_FOR

sumQ := 0;
FOR i := 0 TO 1 DO
    FOR j := 0 TO 3 DO
        sumQ := sumQ + (i * j);
    END_FOR
END_FOR

IF RST OR SET THEN
    Q0 := NOT RST;
    Q1 := Q0;
    Q2 := Q0;
    Q3 := Q0;
    Q4 := Q0;
    Q5 := Q0;
    Q6 := Q0;
    Q7 := Q0;
ELSE
    IF D0 THEN Q0 := TRUE; END_IF;
    IF D1 THEN Q1 := TRUE; END_IF;
    IF D2 THEN Q2 := TRUE; END_IF;
    IF D3 THEN Q3 := TRUE; END_IF;
    IF D4 THEN Q4 := TRUE; END_IF;
    IF D5 THEN Q5 := TRUE; END_IF;
    IF D6 THEN Q6 := TRUE; END_IF;
    IF D7 THEN Q7 := TRUE; END_IF;

    IF CLR AND NOT edge THEN
        IF Q0 THEN Q0 := FALSE;
        ELSIF Q1 THEN Q1 := FALSE;
        ELSIF Q2 THEN Q2 := FALSE;
        ELSIF Q3 THEN Q3 := FALSE;
        ELSIF Q4 THEN Q4 := FALSE;
        ELSIF Q5 THEN Q5 := FALSE;
        ELSIF Q6 THEN Q6 := FALSE;
        ELSE Q7 := FALSE;
        END_IF;
    END_IF;
    edge := CLR;
END_IF;

END.
