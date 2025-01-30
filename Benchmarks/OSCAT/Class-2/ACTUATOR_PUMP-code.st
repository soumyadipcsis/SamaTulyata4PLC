FUNCTION_BLOCK ACTUATOR_PUMP
  VAR_INPUT
    IN : BOOL;
    MANUAL : BOOL;
    RST : BOOL := FALSE;
    MIN_ONTIME : TIME := t#10s;
    MIN_OFFTIME : TIME := t#10s;
    RUN_EVERY : TIME := t#10000m;
  END_VAR
  VAR_OUTPUT
    PUMP : BOOL;
    RUNTIME : UDINT;
    CYCLES : UDINT;
  END_VAR
  VAR
    tx : TIME;
    last_change : TIME;
    meter : ONTIME;
    old_man : BOOL;
    init : BOOL;
  END_VAR

  tx:= UDINT_TO_TIME(T_PLC_MS(en:=true));

  IF NOT init THEN
  	init := TRUE;
  	last_change := tx;
  ELSIF rst THEN
  	rst := FALSE;
  	runtime := UDINT#0;
  	cycles := UDINT#0;
  ELSIF manual AND NOT pump AND NOT old_man THEN
  	last_change := tx;
  	pump := TRUE;
  ELSIF NOT manual AND old_man AND pump AND NOT in THEN
  	last_change := tx;
  	pump := FALSE;
  ELSIF in AND NOT pump AND tx - last_change >= min_offtime THEN
  	last_change := tx;
  	pump := TRUE;
  ELSIF pump AND NOT in AND NOT manual AND tx - last_change >= min_ontime THEN
  	last_change := tx;
  	pump := FALSE;
  ELSIF NOT pump AND (tx - last_change >= run_every) AND (run_every > T#0s) THEN
  	last_change := tx;
  	pump := TRUE;
  END_IF;

  meter(in := pump, SECONDS := runtime, CYCLES := cycles);
  cycles := meter.CYCLES;
  runtime := meter.SECONDS;

  old_man := manual;

  (* From OSCAT Library, www.OSCAT.de *)
  (* T_PLC_MS, ONTIME required *)
END_FUNCTION_BLOCK

