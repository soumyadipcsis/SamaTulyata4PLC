FUNCTION_BLOCK HEAT_TEMP
  VAR_INPUT
    T_EXT : REAL;
    T_INT : REAL;
    OFFSET : REAL;
    T_REQ : REAL;
    TY_MAX : REAL := 70.0;
    TY_MIN : REAL := 25.0;
    TY_CONFIG : REAL := 70.0;
    T_INT_CONFIG : REAL := 20.0;
    T_EXT_CONFIG : REAL := -15.0;
    T_DIFF : REAL := 10.0;
    C : REAL := 1.33;
    H : REAL := 3.0;
  END_VAR
  VAR_OUTPUT
    TY : REAL;
    HEAT : BOOL;
  END_VAR
  VAR
    tr : REAL;
    tx : REAL;
  END_VAR

  tr := T_INT + OFFSET;
  tx := (tr - T_EXT) / (T_INT_CONFIG - T_EXT_CONFIG);

  IF T_EXT + H > tr THEN
  	TY := 0.0;
  ELSE
  	TY := LIMIT(TY_MIN, tr + T_DIFF * 0.5 * tx + (TY_CONFIG - T_DIFF * 0.5 - tr) * EXPT(tx, 1.0 / C), TY_MAX);
  END_IF;

  TY := MAX(TY, T_REQ);
  HEAT := TY > 0.0;

  (* from OSCAT library www.oscat.de *)
END_FUNCTION_BLOCK