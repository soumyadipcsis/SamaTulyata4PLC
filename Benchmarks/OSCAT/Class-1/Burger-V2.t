PROC program2;
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

  // Master only activates if system not deactivated AND window is closed
  MasterCoil := (NOT DeactivateSystem) AND WindowSensor AND (MasterCoil OR MasterSwitch);
  AlarmCoil := MotionDetector AND MasterCoil;

  Alarm := (NOT ButtonToStopAlarm) AND (Alarm OR AlarmCoil);
END.
