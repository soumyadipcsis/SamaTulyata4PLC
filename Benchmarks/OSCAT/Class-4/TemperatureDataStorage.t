PROC TEMPERATURE_DATA_STORAGE;
VAR_INPUT
    StartPB : BOOL;           (* Start Push Button *)
    StopPB : BOOL;            (* Stop Push Button *)
    TempInput1 : INT;         (* Temperature Input 1 *)
    TempInput2 : INT;         (* Temperature Input 2 *)
END_VAR

VAR_OUTPUT
    MasterCoil : BOOL;        (* Master Coil Output *)
    Temp1InC : INT;           (* Temperature 1 in Celsius *)
    Temp2InC : INT;           (* Temperature 2 in Celsius *)
END_VAR

VAR
    Timer_Q : BOOL;           (* Timer Q Output *)
    Timer_ET : INT;           (* Timer Elapsed Time in ms *)
    TimerPreset : INT := 5000; (* Timer Preset (5s) in ms *)
    TimerStartTime : INT;     (* Timer Start Time in ms *)
    TimerRunning : BOOL;      (* Timer Running Flag *)
    TempRegister1 : INT;      (* Temperature Register 1 *)
    TempRegister2 : INT;      (* Temperature Register 2 *)
    UpdateTimer : BOOL;       (* Update Timer Flag *)
    CurrentTime : INT;        (* Current Time in ms *)
END_VAR

BEGIN

STEP 'MASTER_COIL_CONTROL'
    IF StartPB AND NOT StopPB THEN
        MasterCoil := TRUE;
    ELSE
        MasterCoil := FALSE;
    END
ENDSTEP

STEP 'TIMER_CONTROL'
    IF MasterCoil THEN
        IF NOT TimerRunning THEN
            TimerStartTime := CURRENT_TIME();  (* Start Timer *)
            TimerRunning := TRUE;
        END
        CurrentTime := CURRENT_TIME();
        Timer_ET := CurrentTime - TimerStartTime;
        IF Timer_ET >= TimerPreset THEN
            Timer_Q := TRUE;
        ELSE
            Timer_Q := FALSE;
        END
    ELSE
        TimerRunning := FALSE;
        Timer_ET := 0;
        Timer_Q := FALSE;
    END
ENDSTEP

PARALLEL
    FOR i := 1 TO 10 DO
        STEP 'TEMP_CONVERSION'
            IF i = 1 THEN
                TempRegister1 := TempInput1;
                TempReal1 :=TempRegister1;
                Temp1InC := TempReal1 / 82;
            ELSE
                TempRegister2 := TempInput2;
                TempReal2 := TempRegister2;
                Temp2InC := TempReal2 / 82;
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR j := 1 TO 6 DO
        STEP 'DISPLAY_UPDATE_CHECK'
            IF Timer_Q THEN
                UpdateTimer := TRUE;
                TimerRunning := FALSE;
            ELSE
                UpdateTimer := FALSE;
            END
        ENDSTEP

        STEP 'DISPLAY_UPDATE'
            IF UpdateTimer THEN
                Temp1InC := TempRegister1 / 82;
                Temp2InC := TempRegister2 / 82;
            END
        ENDSTEP
    END_FOR
ENDPARALLEL

END
