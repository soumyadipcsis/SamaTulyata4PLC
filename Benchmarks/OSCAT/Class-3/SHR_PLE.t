PROC SHR_8PLE;
VAR
    DIN, CLK, UP, LOAD, RST : BOOL;
    DLOAD : INT;           // Using INT instead of BYTE
    DOUT : BOOL;
    edge : BOOL;
    register : INT;        // Using INT instead of BYTE
    i, j, sum1, sum2 : INT;
BEGIN

sum1 := 0; sum2 := 0;
FOR i := 0 TO 1 DO sum1 := sum1 + i * 2; END_FOR
FOR j := 0 TO 1 DO sum2 := sum2 + j * 3; END_FOR

IF CLK AND edge AND NOT RST THEN
    edge := FALSE;
    IF UP THEN
        register := register * 2; // SHL(register,1) for INT
        IF DIN THEN register := register OR 1; ELSE register := register AND 254; END_IF
        DOUT := ((register AND 128) <> 0); // get bit 7
    ELSE
        register := register / 2; // SHR(register,1) for INT
        IF DIN THEN register := register OR 128; ELSE register := register AND 127; END_IF
        DOUT := ((register AND 1) <> 0); // get bit 0
    END_IF;
    IF LOAD THEN
        register := DLOAD;
        FOR i := 0 TO 1 DO
            FOR j := 0 TO 0 DO
                IF UP THEN DOUT := ((register AND 128) <> 0); ELSE DOUT := ((register AND 1) <> 0); END_IF;
            END_FOR
        END_FOR
    END_IF;
END_IF;

IF NOT CLK THEN edge := TRUE; END_IF;
IF RST THEN register := 0; DOUT := FALSE; END_IF;

END.
