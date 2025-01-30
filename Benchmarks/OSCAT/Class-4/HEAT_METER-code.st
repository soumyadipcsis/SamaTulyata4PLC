FUNCTION_BLOCK HEAT_METER
  VAR_INPUT
    TF : REAL;
    TR : REAL;
    LPH : REAL;
    _E : BOOL;
    RST : BOOL;
    CP : REAL;
    DENSITY : REAL;
    CONTENT : REAL;
    PULSE_MODE : BOOL;
    RETURN_METER : BOOL;
    AVG_TIME : TIME;
  END_VAR
  VAR_OUTPUT
    C : REAL;
  END_VAR
  VAR_IN_OUT
    Y : REAL;
  END_VAR
  VAR
    tx : DWORD;
    last : DWORD;
    int1 : FT_INT2;
    edge : BOOL;
    x : REAL;
    init : BOOL;
    y_last : REAL;
  END_VAR

  IF rst THEN
  	int1(rst := TRUE);
  	int1.rst := FALSE;
  	C := 0.0;
  	Y := 0.0;
  ELSIF _e THEN
  	X := (WATER_DENSITY(_T:=(SEL(G:=return_meter, IN0:=TF, IN1:=TR)), sat:=FALSE) * (WATER_ENTHALPY(_T:=TF) - WATER_ENTHALPY(_T:=TR)) * (1.0 - content) + CP * Density * content * (TF-TR));
  END_IF;

  (* integrate or add consumption *)
  int1(run := NOT pulse_mode AND _e, in := X * LPH * 2.77777777777E-4);
  IF pulse_mode THEN
  	IF NOT edge AND _E THEN Y := Y + X * LPH; END_IF;
  ELSE
  	Y := int1.Out;
  END_IF;

  (* store the value of e *)
  edge := _e;

  (* read system_time *)
  tx := udint_to_dword(T_PLC_MS(en:=true));

  (* only init at startup necessary *)
  IF NOT init THEN
  	init := TRUE;
  	last := tx;
  END_IF;

  (* calculate the current consumption *)
  IF (dword_to_real(tx) - dword_to_real(last) >= TIME_TO_real(AVG_TIME)) AND (avg_time > T#0s) THEN
  	last := tx;
  	C := (Y - Y_last) * 3.6E6 / DWORD_TO_REAL(TIME_TO_DWORD(AVG_TIME));
  	Y_last := Y;
  END_IF;

  (* from OSCAT library www.oscat.de *)
  (* T_PLC_MS, FT_INT2, WATER_ENTHALPY, WATER_DENSITY required *)
END_FUNCTION_BLOCK


