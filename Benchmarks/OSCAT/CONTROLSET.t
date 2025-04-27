PROC CONTROLSET;
VAR
    // Control Variables
    SP : INT; // Setpoint
    PV : INT; // Process Value
    OUT : INT; // Output Control Value

    // PID Tuning Parameters (Integer-Based)
    Kp : INT; // Proportional Gain
    Ti : INT; // Integral Time
    Td : INT; // Derivative Time

    // PID Internal Variables
    e : INT; // Error
    e_prev : INT; // Previous Error
    P : INT; // Proportional Term
    I : INT; // Integral Term
    D : INT; // Derivative Term
    Integral : INT; // Accumulated Integral
    Derivative : INT; // Derivative Term Storage

    // Control Mode
    ManualMode : BOOL; // Manual/Auto Mode
    ManualOutput : INT; // Output in Manual Mode

    // Safety & Limits
    MinOutput : INT := 0; // Minimum Output Limit
    MaxOutput : INT := 100; // Maximum Output Limit

    // Temporary Integer Variables
    TempValue1 : INT; 
    TempValue2 : INT;
    TempValue3 : INT; // Added for additional parallel loop

BEGIN

STEP 'EXECUTE_CONTROLSET3'
    IF ManualMode THEN
        OUT := ManualOutput; // Direct Control in Manual Mode
    ELSE
        // ****************** PID CONTROL CALCULATIONS ******************
        e := SP - PV; // Compute Error

        // Proportional Term
        P := Kp * e;

        // Integral Term with Anti-Windup
        TempValue1 := e * Ti;
        TempValue1 := TempValue1 / 100; // Scale down to prevent overflow
        IF ABS(Integral) < 10000 THEN
            Integral := Integral + TempValue1;
        END
        I := Integral;

        // Derivative Term
        TempValue2 := e - e_prev;
        TempValue2 := (TempValue2 * 100) / Td; // Integer-based scaling
        D := (Td * TempValue2) / 100;

        // Compute Final Output
        OUT := P + I + D;

        // Apply Output Limits
        IF OUT > MaxOutput THEN
            OUT := MaxOutput;
        ELSE
            IF OUT < MinOutput THEN
                OUT := MinOutput;
            END
        END

        // Store Previous Error for Next Cycle
        e_prev := e;
    END
ENDSTEP

PARALLEL
    FOR i := 1 TO 4 DO
        STEP 'ADDITIONAL_CONTROL1'
            (* Additional control logic or computations can be added here *)
            TempValue3 := OUT; // Example of using OUT for another control loop
            (* Perform control operations in this loop *)
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR j := 1 TO 4 DO
        STEP 'ADDITIONAL_CONTROL2'
            (* Another control task or action *)
            TempValue1 := TempValue3 * 2; // Example calculation for this loop
            (* Perform actions for this loop *)
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR k := 1 TO 4 DO
        STEP 'ADDITIONAL_CONTROL3'
            (* Control loop computation, can be extended further *)
            TempValue2 := TempValue1 + TempValue3; // Further control actions
            (* Perform actions for this loop *)
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR l := 1 TO 4 DO
        STEP 'ADDITIONAL_CONTROL4'
            (* Final control task or adjustment *)
            OUT := TempValue2 - 5; // Example adjustment based on previous calculations
            (* Perform final actions for control *)
        ENDSTEP
    END_FOR
ENDPARALLEL

END
