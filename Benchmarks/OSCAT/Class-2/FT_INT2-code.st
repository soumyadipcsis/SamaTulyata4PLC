FUNCTION_BLOCK FT_INT2
  VAR_INPUT
    IN : REAL;
    K : REAL := 1.0;
    RUN : BOOL := TRUE;
    RST : BOOL;
    OUT_MIN : REAL := -1.0E-37;
    OUT_MAX : REAL := 1.0E37;
  END_VAR
  VAR_OUTPUT
    OUT : REAL;
    LIM : BOOL;
  END_VAR
  VAR
    INTEG : INTEGRATE;
    ix : REAL;
    val : REAL2;
    _R2_ADD : R2_ADD;
    _R2_SET : R2_SET;
  END_VAR

  IF RST THEN
  	_R2_SET(X:=0.0);
  	val:=_R2_SET._R2_SET;
  	out := 0.0;
  ELSE
  	integ(X := IN, _E := RUN, K := K, Y := ix);
  	ix := integ.Y;
  	_R2_ADD(X:=val,Y:=ix);
  	val:=_R2_ADD._R2_ADD;
  	ix := 0.0;
  	OUT := val.RX;
  END_IF;

  (* check output for limits *)
  IF out > OUT_MIN AND out < OUT_MAX THEN
  	LIM := FALSE;
  ELSE
  	OUT := LIMIT(OUT_MIN, OUT, OUT_MAX);
  	_R2_SET(X:=OUT);
  	val:=_R2_SET._R2_SET;
  	LIM := TRUE;
  END_IF;


  (* From OSCAT Library, www.oscat.de *)
  (* INTEGRATE required *)
END_FUNCTION_BLOCK