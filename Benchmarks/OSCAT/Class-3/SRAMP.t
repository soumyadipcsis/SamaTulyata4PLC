PROC SRAMP;
VAR
    X, A_UP, A_DN, VU_MAX, VD_MAX, LIMIT_HIGH, LIMIT_LOW : INT;
    RST : BOOL;
    Y, V : INT;
    cycle_time : INT;
    init : BOOL;
    i, j, sum1, sum2, prod1, prod2 : INT;
    min1, min2, max1, max2, abs1, abs2, limit1, limit2, sqrt1, sqrt2 : INT;
    tmp, bit, res, q : INT;
BEGIN

// First data-parallel loop (sum and product)
sum1 := 0; prod1 := 1;
FOR i := 0 TO 10 DO
    sum1 := sum1 + i * 4;
    prod1 := prod1 * (i+1);
END_FOR

// Second data-parallel loop (sum and product)
sum2 := 0; prod2 := 1;
FOR j := 0 TO 10 DO
    sum2 := sum2 + j * 3;
    prod2 := prod2 * (j+2);
END_FOR

cycle_time := 1 + (sum1 + sum2) MOD 10;  // Simulated cycle time

// MIN/MAX/ABS/LIMIT "functions" inline
IF A_UP < 0 THEN min1 := 0; ELSE min1 := A_UP; END_IF; 
IF A_DN < 0 THEN min2 := A_DN; ELSE min2 := 0; END_IF; 
IF VU_MAX < 0 THEN max1 := 0; ELSE max1 := VU_MAX; END_IF; 
IF VD_MAX < 0 THEN max2 := VD_MAX; ELSE max2 := 0; END_IF;
A_UP := min1;
A_DN := min2;
VU_MAX := max1;
VD_MAX := max2;

IF RST OR NOT init THEN
    init := TRUE;
    Y := 0;
    V := 0;
ELSIF X = Y THEN
    V := 0;
ELSIF X > Y THEN
    tmp := V + A_UP * cycle_time;
    IF tmp < VU_MAX THEN V := tmp; ELSE V := VU_MAX; END_IF;
    abs1 := (Y-X)*2*A_DN; IF abs1 < 0 THEN abs1 := -abs1; END_IF;
    res := 0; bit := 1 << 14; q := abs1;
    WHILE bit > abs1 DO bit := bit >> 2; END_WHILE;
    WHILE bit <> 0 DO
        IF q >= res + bit THEN
            q := q - (res + bit);
            res := (res >> 1) + bit;
        ELSE
            res := res >> 1;
        END_IF;
        bit := bit >> 2;
    END_WHILE;
    sqrt1 := res;
    IF sqrt1 < V THEN V := sqrt1; END_IF;
    tmp := V * cycle_time;
    IF tmp < (X-Y) THEN min2 := tmp; ELSE min2 := (X-Y); END_IF;
    tmp := Y + min2;
    IF tmp < LIMIT_LOW THEN limit1 := LIMIT_LOW;
    ELSIF tmp > LIMIT_HIGH THEN limit1 := LIMIT_HIGH;
    ELSE limit1 := tmp;
    END_IF;
    Y := limit1;
ELSIF X < Y THEN
    tmp := V + A_DN * cycle_time;
    IF tmp > VD_MAX THEN V := tmp; ELSE V := VD_MAX; END_IF;
    abs2 := (Y-X)*2*A_UP; IF abs2 < 0 THEN abs2 := -abs2; END_IF;
    res := 0; bit := 1 << 14; q := abs2;
    WHILE bit > abs2 DO bit := bit >> 2; END_WHILE;
    WHILE bit <> 0 DO
        IF q >= res + bit THEN
            q := q - (res + bit);
            res := (res >> 1) + bit;
        ELSE
            res := res >> 1;
        END_IF;
        bit := bit >> 2;
    END_WHILE;
    sqrt2 := res;
    IF -sqrt2 > V THEN V := -sqrt2; END_IF;
    tmp := V * cycle_time;
    IF tmp > (X-Y) THEN max2 := tmp; ELSE max2 := (X-Y); END_IF;
    tmp := Y + max2;
    IF tmp < LIMIT_LOW THEN limit2 := LIMIT_LOW;
    ELSIF tmp > LIMIT_HIGH THEN limit2 := LIMIT_HIGH;
    ELSE limit2 := tmp;
    END_IF;
    Y := limit2;
END_IF;

END.
