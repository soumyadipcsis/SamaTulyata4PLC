FUNCTION_BLOCK LEGIONELLA
  VAR_INPUT
    MANUAL : BOOL;
    TEMP_BOILER : REAL;
    TEMP_RETURN : REAL := 100.0;
    DT_IN : UDINT;
    RST : BOOL;
    T_START : UDINT := 10800000;
    DAY : INT := 7;
    TEMP_SET : REAL := 70.0;
    TEMP_OFFSET : REAL := 10.0;
    TEMP_HYS : REAL := 5.0;
    T_MAX_HEAT : TIME := t#10m;
    T_MAX_RET : TIME := t#10m;
    TP_0 : TIME := t#5m;
    TP_1 : TIME := t#5m;
    TP_2 : TIME := t#5m;
    TP_3 : TIME := t#5m;
    TP_4 : TIME := t#5m;
    TP_5 : TIME := t#5m;
    TP_6 : TIME := t#5m;
    TP_7 : TIME := t#5m;
  END_VAR
  VAR_OUTPUT
    HEAT : BOOL;
    PUMP : BOOL;
    VALVE0 : BOOL;
    VALVE1 : BOOL;
    VALVE2 : BOOL;
    VALVE3 : BOOL;
    VALVE4 : BOOL;
    VALVE5 : BOOL;
    VALVE6 : BOOL;
    VALVE7 : BOOL;
    RUN : BOOL;
    STATUS : BYTE;
  END_VAR
  VAR
    X1 : TIMER_1;
    X2 : SEQUENCE_8;
    X3 : HYST_1;
    init : BOOL;
  END_VAR

  (* startup initialization *)
  IF NOT init THEN
  	init := TRUE;
  	X1.day := SHR(BYTE#128,day);
  	X1.start := T_start;
  	X3.low := Temp_offset + temp_set;
  	X3.high := Temp_hys + X3.low;
  	X2.wait0 := T_max_heat;
  	X2.delay0 := TP_0;
  	X2.delay1 := TP_1;
  	X2.delay2 := TP_2;
  	X2.delay3 := TP_3;
  	X2.delay4 := TP_4;
  	X2.delay5 := TP_5;
  	X2.delay6 := TP_6;
  	X2.delay7 := TP_7;
  	X2.wait1 := T_max_ret;
  	X2.wait2 := T_max_ret;
  	X2.wait3 := T_max_ret;
  	X2.wait4 := T_max_ret;
  	X2.wait5 := T_max_ret;
  	X2.wait6 := T_max_ret;
  	X2.wait7 := T_max_ret;
  	X2();
  END_IF;

  (* oerational code *)
  X1(DTi := DT_in);
  IF X1.Q OR MANUAL OR x2.run THEN
  	X3(in := temp_boiler);
  	X2.in0 := X3.Q OR x3.win;
  	X2.in1 := temp_return >= temp_set;
  	X2.in2 := x2.in1;
  	X2.in3 := x2.in1;
  	X2.in4 := x2.in1;
  	X2.in5 := x2.in1;
  	X2.in6 := x2.in1;
  	X2.in7 := x2.in1;
  	X2.rst := rst;
  	X2(start := X1.Q OR MANUAL);
  	run := x2.run;
  	pump := x2.QX;
  	Heat := NOT X3.Q AND x2.run;
  	valve0 := X2.Q0;
  	valve1 := X2.Q1;
  	valve2 := X2.Q2;
  	valve3 := X2.Q3;
  	valve4 := X2.Q4;
  	valve5 := X2.Q5;
  	valve6 := X2.Q6;
  	valve7 := X2.Q7;
  	pump := X2.QX;
  	status := X2.status;
  ELSE
  	X2(start := false);
  	status := x2.status;
  END_IF;

  (* From OSCAT Library, www.OSCAT.de *)
  (* TIMER_1, SEQUENCE_8, HYST_1 required *)
END_FUNCTION_BLOCK