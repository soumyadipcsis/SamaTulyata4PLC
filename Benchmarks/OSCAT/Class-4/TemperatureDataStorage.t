PROC TEMPERATURE_DATA_STORAGE;
VAR_INPUT
    StartPB : BOOL;
    StopPB : BOOL;
    TempInput1 : INT;
    TempInput2 : INT;
END_VAR

VAR_OUTPUT
    MasterCoil : BOOL;
    Temp1InC : INT;
    Temp2InC : INT;
END_VAR

VAR
    Timer_Q : BOOL;
    Timer_ET : TIME;
    TimerPreset : TIME := T#5s;
    TimerStartTime : TIME;
    TimerRunning : BOOL;
    TempRegister1 : INT;
    TempRegister2 : INT;
    TempReal1 : REAL;
    TempReal2 : REAL;
    UpdateTimer : BOOL;
    CurrentTime : TIME;
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
            TimerStartTime := TIME(); (* get current system time *)
            TimerRunning := TRUE;
        END
        CurrentTime := TIME();
        Timer_ET := CurrentTime - TimerStartTime;
        IF Timer_ET >= TimerPreset THEN
            Timer_Q := TRUE;
        ELSE
            Timer_Q := FALSE;
        END
    ELSE
        TimerRunning := FALSE;
        Timer_ET := T#0s;
        Timer_Q := FALSE;
    END
ENDSTEP

STEP 'TEMP_CONVERSION'
    TempRegister1 := TempInput1;
    TempRegister2 := TempInput2;

    TempReal1 := REAL(TempRegister1);
    TempReal2 := REAL(TempRegister2);

    Temp1InC := REAL_TO_INT(TempReal1 / 82.0);
    Temp2InC := REAL_TO_INT(TempReal2 / 82.0);
ENDSTEP

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

END
