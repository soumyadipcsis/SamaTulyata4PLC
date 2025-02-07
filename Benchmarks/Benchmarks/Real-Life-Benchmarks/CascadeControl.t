PROC CascadeControl;
VAR
    // Auto/Manual Control
    ManualButton : BOOLEAN; AutoButton: BOOLEAN;
    Mode: INTEGER := 0; AutoProcess: BOOLEAN := FALSE;

    // Master Loop Variables (Integer-based PID)
    SP_Master: INTEGER; PV_Master: INTEGER;
    MV_Master: INTEGER; Kp_Master, Ti_Master, Td_Master: INTEGER;
    e_Master, e_Master_prev: INTEGER;
    P_Master, I_Master, D_Master: INTEGER;
    Integral_Master: INTEGER; Derivative_Master: INTEGER;
    Windup_Limit_Master: INTEGER;
    MV_Master_Min, MV_Master_Max: INTEGER;

    // Slave Loop Variables (Integer-based PID)
    SP_Slave: INTEGER; PV_Slave: INTEGER;
    MV_Slave: INTEGER; Kp_Slave, Ti_Slave, Td_Slave: INTEGER;
    e_Slave, e_Slave_prev: INTEGER;
    P_Slave, I_Slave, D_Slave: INTEGER;
    Integral_Slave: INTEGER; Derivative_Slave: INTEGER;
    Windup_Limit_Slave: INTEGER;
    MV_Slave_Min, MV_Slave_Max: INTEGER;

    // Feedforward Control
    Feedforward_Signal: INTEGER; Gain_FF: INTEGER;

    // Other Variables
    LocalValue: INTEGER; I: INTEGER := 0;
    CustomScaling: INTEGER;

BEGIN
STEP 'EXECUTE_CASCADE'
IF ManualButton THEN
    Mode := 0; // Set mode to manual

IF Mode = 0 THEN // Manual Mode
BEGIN
    MV_Master := SP_Master;  // Directly set output in manual mode
    MV_Slave := SP_Slave;
END

IF AutoButton THEN
    Mode := 1;

IF Mode = 1 THEN // Auto Mode
BEGIN
    IF NOT AutoProcess THEN
    BEGIN
        // **************** MASTER CONTROLLER ****************
        // Compute Error
        e_Master := SP_Master - PV_Master;

        // Proportional Term
        P_Master := Kp_Master * e_Master;

        // Integral Term with Anti-Windup
        IF ABS(Integral_Master) < Windup_Limit_Master THEN
            Integral_Master := Integral_Master + (e_Master * Ti_Master) / 100;
        END
        I_Master := Integral_Master;

        // Derivative Term
        Derivative_Master := ((e_Master - e_Master_prev) * 100) / Td_Master;
        D_Master := (Td_Master * Derivative_Master) / 100;

        // Compute Output
        MV_Master := P_Master + I_Master + D_Master;

        // Apply Output Limits
        IF MV_Master > MV_Master_Max THEN
            MV_Master := MV_Master_Max;
        ELSE
            IF MV_Master < MV_Master_Min THEN
                MV_Master := MV_Master_Min;
        END

        // Store Previous Error
        e_Master_prev := e_Master;

        // **************** FEEDFORWARD CONTROL ****************
        SP_Slave := MV_Master + ((Gain_FF * Feedforward_Signal) / 100);

        // **************** SLAVE CONTROLLER ****************
        // Compute Error
        e_Slave := SP_Slave - PV_Slave;

        // Proportional Term
        P_Slave := Kp_Slave * e_Slave;

        // Integral Term with Anti-Windup
        IF ABS(Integral_Slave) < Windup_Limit_Slave THEN
            Integral_Slave := Integral_Slave + (e_Slave * Ti_Slave) / 100;
        END
        I_Slave := Integral_Slave;

        // Derivative Term
        Derivative_Slave := ((e_Slave - e_Slave_prev) * 100) / Td_Slave;
        D_Slave := (Td_Slave * Derivative_Slave) / 100;

        // Compute Output
        MV_Slave := P_Slave + I_Slave + D_Slave;

        // Apply Output Limits
        IF MV_Slave > MV_Slave_Max THEN
            MV_Slave := MV_Slave_Max;
        ELSE
            IF MV_Slave < MV_Slave_Min THEN
                MV_Slave := MV_Slave_Min;
        END

        // Store Previous Error
        e_Slave_prev := e_Slave;

        // Mark Process Active
        AutoProcess := TRUE;
    END

    // **************** POST-CONTROL SCALING ****************
    IF AutoProcess THEN
    BEGIN
        WHILE (I < LocalValue) DO
        BEGIN
            MV_Master := MV_Master * 10;
            MV_Slave := MV_Slave / 10;
            I := I + 1;
        END
        CustomScaling := MV_Master + MV_Slave;
        
        // Reset Process
        AutoProcess := FALSE;
    END
END
ENDSTEP

END.
