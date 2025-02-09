FUNCTION_BLOCK TUNE
  VAR_INPUT
    SET : BOOL;
    SU : BOOL;
    SD : BOOL;
    RST : BOOL;
    SS : REAL := 0.1;
    LIMIT_L : REAL;
    LIMIT_H : REAL := 100.0;
    RST_VAL : REAL;
    SET_VAL : REAL := 100.0;
    T1 : TIME := t#500ms;
    T2 : TIME := t#2s;
    S1 : REAL := 2.0;
    S2 : REAL := 10.0;
    Y : REAL;
  END_VAR
  VAR
    tx : UDINT;
    start : UDINT;
    start2 : UDINT;
    state : INT;
    in : BOOL;
    _step : REAL;
    speed : REAL;
    y_start : REAL;
    y_start2 : REAL;
  END_VAR

  tx:= T_PLC_MS(en:=true);

  IF rst THEN
  	Y := RST_val;
  	state := 0;
  ELSIF set THEN
  	Y := SET_val;
  	state := 0;
  ELSIF state > 0 THEN
  	(* key has been pushed state machine operating *)
  	(* first read the correct input *)
  	IF state = 1 THEN
  		(* step up *)
  		in := su;
  	ELSE
  		(* step down *)
  		in := sd;
  	END_IF;
  	(* check for single step operation *)
  	IF NOT in AND tx - start <= TIME_TO_UDINT(T1) THEN
  		Y := Y_start + _step;
  		state := 0;
  	(* check if fast ramp needs to be generated *)
  	ELSIF in AND tx - start >= TIME_TO_UDINT(T2) THEN
  		Y := Y_start2 + UDINT_TO_REAL(tx - start2) * s2 / speed;
  	(* check if slow ramp needs to be generated *)
  	ELSIF in AND tx - start >= TIME_TO_UDINT(T1) THEN
  		Y := Y_start + UDINT_TO_REAL(tx - start - TIME_TO_UDINT(T1)) * S1 / speed;
  		start2 := tx;
  		Y_start2 := Y;
  	ELSIF NOT in THEN
  		state := 0;
  	END_IF;
  ELSIF su THEN
  	(* slow step up *)
  	state := 1;
  	start := tx;
  	_step := ss;
  	speed := 1000.0;
  	Y_start := Y;
  ELSIF sd THEN
  	(* slow step down *)
  	state := 2;
  	start := tx;
  	_step := -ss;
  	speed := -1000.0;
  	Y_start := Y;
  END_IF;

  (* make sure output does not exceed limits *)
  Y := LIMIT(LIMIT_L, Y, LIMIT_H);

  (*From OSCAT Library, www.oscat.de *)
  (* T_PLC_MS required *)
END_FUNCTION_BLOCK