PROC FactorialCalculation;
VAR
    N : INTEGER; // Input number
    Result : INTEGER; // Factorial result
    I : INTEGER; // Loop counter

BEGIN
STEP 'EXECUTE_FACTORIAL'
IF (N = 0 OR N = 1) THEN
    Result := 1; // Base case: 0! = 1 and 1! = 1
ELSE
    Result := 1;
    FOR I := 2 TO N DO
        Result := Result * I;
    END
ENDSTEP

END.
