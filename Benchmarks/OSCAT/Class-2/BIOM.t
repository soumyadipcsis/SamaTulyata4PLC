PROC BinomialCoefficient;
VAR
    N : INTEGER; // Total elements
    K : INTEGER; // Chosen elements
    Result : INTEGER; // Final binomial coefficient

    FactorialN : INTEGER; 
    FactorialK : INTEGER;
    FactorialNK : INTEGER;

    TempValue1 : INTEGER;
    TempValue2 : INTEGER;

    I : INTEGER;
    J : INTEGER;
    L : INTEGER;
BEGIN
STEP 'EXECUTE_BINOMIAL_COEFFICIENT'
IF (K = 0 OR K = N) THEN
    Result := 1;
ELSE
    IF (K > N) THEN
        Result := 0; // Invalid case
    ELSE
    BEGIN
        // Compute N!
        FactorialN := 1;
        FOR I := 1 TO N DO
            FactorialN := FactorialN * I;
        END
        
        // Compute K!
        FactorialK := 1;
        FOR J := 1 TO K DO
            FactorialK := FactorialK * J;
        END

        // Compute (N-K)!
        FactorialNK := 1;
        FOR L := 1 TO (N-K) DO
            FactorialNK := FactorialNK * L;
        END

        // Compute Result = N! / (K!(N-K)!)
        TempValue1 := FactorialN / FactorialK; // Integer division
        Result := TempValue1 / FactorialNK; // Final integer division
    END
ENDSTEP

END.
