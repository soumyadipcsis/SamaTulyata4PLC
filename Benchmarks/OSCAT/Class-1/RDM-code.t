PROC RDM;
  VAR_INPUT
    LAST : INT;
  END_VAR
  VAR_OUTPUT
    _RDM : INT;
    tn   : INT;
    tc   : INT;
  END_VAR
  VAR
    i : INT;
    base : INT;
    last_limited : INT;
  END_VAR

  IF LAST < 0 THEN
    last_limited := 0;
  ELSE
    IF LAST > 1000 THEN
      last_limited := 1000;
    ELSE
      last_limited := LAST;
    END
  END

  base := 137 * last_limited + 913;
  tc := 0;
  FOR i := 0 TO 7 DO
    IF ((base / (2 ** i)) MOD 2) = 1 THEN
      tc := tc + 1;
    ELSE
      tc := tc;
    END
  END_FOR;

  _RDM := (base * tc) / 100;
END.
