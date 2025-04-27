PROC program0;
  VAR_INPUT
    SW1 : BOOL;SW2 : BOOL;
  END_VAR
  VAR_OUTPUT
    Latch : BOOL;Unlatch : BOOL;
  END_VAR
  VAR
    i : INT;
BEGIN
  IF SW1 THEN
    Latch := TRUE;
  ELSE
    Latch := FALSE;
  END
  FOR i := 0 TO 1 DO
    IF SW2 THEN
      Unlatch := TRUE;
    ELSE
      Unlatch := FALSE;
    END
  END_FOR;
END.

