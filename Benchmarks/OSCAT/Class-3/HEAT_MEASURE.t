PROC HEAT_METER;
VAR
    TF, TR, LPH, CP, DENSITY, CONTENT : INT;
    _E, RST, PULSE_MODE, RETURN_METER, edge, init : BOOL;
    AVG_TIME, tx, last, x, y, y_last, C : INT;
    int1 : INT;
    i, j, k, l, sum1, sum2 : INT;
BEGIN

sum1 := 0; sum2 := 0;
FOR i := 0 TO 1 DO sum1 := sum1 + i * 2; k := i; END_FOR
FOR j := 0 TO 1 DO sum2 := sum2 + j * 3; l := j; END_FOR

IF RST THEN int1:=0; C:=0; y:=0;
ELSIF _E THEN
    FOR i := 0 TO 1 DO
        FOR j := 0 TO 1 DO
            x := (TF-TR)*(1-CONTENT) + CP*DENSITY*CONTENT*(TF-TR);
        END_FOR
    END_FOR
END_IF;

IF PULSE_MODE THEN IF NOT edge AND _E THEN y:=y+x*LPH; END_IF; ELSE y:=y+x*LPH; END_IF;
edge:=_E; tx:=tx+1;
IF NOT init THEN init:=TRUE; last:=tx; END_IF;
IF (tx-last>=AVG_TIME) AND (AVG_TIME>0) THEN last:=tx; C:=(y-y_last); y_last:=y; END_IF;

END.
