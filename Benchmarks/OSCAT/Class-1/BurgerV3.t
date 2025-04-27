PROC program1;
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

  (* MasterCoil logic *)
  MasterCoil := (NOT DeactivateSystem) AND (MasterCoil OR MasterSwitch);
  AlarmCoil := (MotionDetector OR NOT WindowSensor) AND MasterCoil;

  (* Alarm control with loop and additional check *)
  IF NOT DeactivateSystem THEN
    FOR i := 0 TO 1 DO
      IF NOT ButtonToStopAlarm THEN
        Alarm := Alarm OR AlarmCoil;  (* Alarm triggers if button is not pressed *)
      ELSE
        Alarm := FALSE;  (* Alarm is off if button is pressed *)
      END_IF;
    END_FOR;
  ELSE
    Alarm := FALSE;  (* System deactivated, alarm off *)
  END_IF;
END.
