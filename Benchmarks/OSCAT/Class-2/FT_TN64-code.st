FUNCTION_BLOCK FT_TN64
  VAR_INPUT
    IN : REAL;
    _T : TIME;
  END_VAR
  VAR_OUTPUT
    OUT : REAL;
    TRIG : BOOL;
  END_VAR
  VAR
    length : INT := 64;
    X : ARRAY [0..63] OF REAL;
    cnt : INT;
    last : TIME;
    tx : TIME;
    init : BOOL;
  END_VAR

  tx:= UDINT_TO_TIME(T_PLC_MS(en:=true));

  trig := FALSE;
  IF NOT init THEN
  	x[cnt] := in;
  	init := TRUE;
  	last := tx;
  ELSIF tx - last >= _T / length THEN
  	IF cnt = length - 1 THEN cnt := 0; ELSE cnt := cnt + 1; END_IF;
  	Out := X[cnt];
  	x[cnt] := in;
  	last := tx;
  	trig := TRUE;
  END_IF;


  (* From OSCAT Library, www.oscat.de *)
  (* T_PLC_MS required *)
END_FUNCTION_BLOCK