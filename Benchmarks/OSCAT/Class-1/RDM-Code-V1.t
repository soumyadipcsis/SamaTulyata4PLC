PROC RDM_INT;
  VAR_INPUT
    LAST : INT;
  END_VAR
  VAR_OUTPUT
    _RDM : INT;
    tn   : INT;
    tc   : INT;
  END_VAR
  VAR
    i        : INT;
    temp     : INT;
    last_limited : INT;
  END_VAR

  (* Clamp LAST between 0 and 1000 manually *)
  IF LAST < 0 THEN
    last_limited := 0;
  ELSE
    IF LAST > 1000 THEN
      last_limited := 1000;
    ELSE
      last_limited := LAST;
    END
  END

  tn := (LAST * 37 + 1234) - ((LAST * 37 + 1234) / 10000) * 10000;  // simulate MOD
  tc := 0;

  FOR i := 0 TO 7 DO
    IF ((tn / (2 ** i)) MOD 2) = 1 THEN
      tc := tc + 1;
    ELSE
      tc := tc;
    END
  END_FOR;

  _RDM := (tn * tc * last_limited) / 10000;
END.
