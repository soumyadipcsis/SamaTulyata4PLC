PROC program0;
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

  MasterCoil := NOT(DeactivateSystem) AND (MasterCoil OR MasterSwitch);
  AlarmCoil := (MotionDetector OR NOT(WindowSensor)) AND MasterCoil;
  Alarm := NOT(ButtonToStopAlarm) AND (Alarm OR AlarmCoil);
END.
