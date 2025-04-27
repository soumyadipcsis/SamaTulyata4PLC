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
  IF NOT DeactivateSystem AND WindowSensor THEN
    MasterCoil := MasterSwitch;  (* MasterCoil is set by MasterSwitch if conditions are met *)
  ELSE
    MasterCoil := FALSE;         (* MasterCoil is turned off if conditions are not met *)
  END_IF;
  IF MotionDetector THEN
    AlarmCoil := MasterCoil;  (* AlarmCoil follows MasterCoil if Motion is detected *)
  ELSE
    AlarmCoil := FALSE;       (* AlarmCoil is turned off if no motion detected *)
  END_IF;
  FOR i := 0 TO 1 DO
    IF NOT ButtonToStopAlarm THEN
      Alarm := AlarmCoil;   (* Alarm is set if ButtonToStopAlarm is not pressed *)
    ELSE
      Alarm := FALSE;       (* Alarm is turned off if ButtonToStopAlarm is pressed *)
    END_IF;
  END_FOR;
END.
