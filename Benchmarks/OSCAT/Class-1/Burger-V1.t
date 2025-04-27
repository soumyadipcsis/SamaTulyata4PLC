PROC program3;
  VAR_INPUT
    MasterSwitch : BOOL;
    DeactivateSystem : BOOL;
    MotionDetector : BOOL;
    WindowSensor : BOOL;
    ButtonToStopAlarm : BOOL;
  END_VAR
  VAR_OUTPUT
    MasterCoil : BOOL;
    AlarmCoil : BOOL;
    Alarm : BOOL;
  END_VAR
  VAR
    MotionCount : INT;
  END_VAR

  MasterCoil := (NOT DeactivateSystem) AND (MasterCoil OR MasterSwitch);
WHILE(1);
  IF MotionDetector THEN
    MotionCount := MotionCount + 1;
  ELSE
    MotionCount := 0;
  END

  IF MotionCount >= 3 THEN
    AlarmCoil := TRUE;
  ELSE
    AlarmCoil := FALSE;
  END

  Alarm := (NOT ButtonToStopAlarm) AND (Alarm OR (AlarmCoil AND MasterCoil));
END.
