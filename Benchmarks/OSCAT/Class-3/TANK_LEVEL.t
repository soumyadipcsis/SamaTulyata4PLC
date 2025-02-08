FUNCTION_BLOCK TANK_LEVEL
  VAR_INPUT
    LEVEL : BOOL;
    LEAK : BOOL;
    ACLR : BOOL;
    MAX_VALVE_TIME : TIME;
    LEVEL_DELAY_TIME : TIME;
  END_VAR
  VAR_OUTPUT
    VALVE : BOOL;
    ALARM : BOOL;
    STATUS : BYTE;
  END_VAR
  VAR
    cx : ACTUATOR_COIL;
    tn : TON;
    tl : TONOF;
    open : BOOL;
  END_VAR

  (* preprocess the level information *)
  tl(in := level, T_ON := level_delay_time, T_OFF := level_delay_time);
  open := tl.Q;

  (* start logic *)
  IF ALARM THEN
  	(* check for ACLR if ALARM is present *)
  	IF ACLR THEN
  		ALARM := FALSE;
  		STATUS := BYTE#101; (* aclr pressed *)
  		cx(in := FALSE);
  	END_IF;
  	RETURN;
  ELSIF LEAK THEN
  	(* leakeage detected *)
  	cx(in := FALSE);
  	ALARM := TRUE;
  	STATUS := BYTE#1;	(* leakeage error *)
  ELSIF open THEN
  	(* valve needs to be opened because level is too low *)
  	cx(in := TRUE);
  	STATUS := BYTE#102; (* valve open by low level *)
  ELSE
  	(* valve needs to be closed *)
  	cx(in := FALSE);
  	STATUS := BYTE#100; (* valve idle *)
  END_IF;

  (* check if valve is open too long and generate alarm if necessary *)
  tn(in := cx.out AND (MAX_VALVE_TIME > T#0s), PT := MAX_VALVE_TIME);
  IF tn.Q THEN
  	ALARM := TRUE;
  	STATUS := BYTE#2; (* overtime error *)
  	cx(in := FALSE);
  END_IF;

  (* set output signal *)
  VALVE := cx.out;

  (* From OSCAT Library, www.OSCAT.de *)
  (* TON, TONOF, ACTUATOR_COIL required *)
END_FUNCTION_BLOCK