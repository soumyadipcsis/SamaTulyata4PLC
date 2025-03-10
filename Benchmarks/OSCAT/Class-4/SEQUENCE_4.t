FUNCTION_BLOCK SEQUENCE_4
  VAR_INPUT
    IN0 : BOOL := TRUE;
    IN1 : BOOL := TRUE;
    IN2 : BOOL := TRUE;
    IN3 : BOOL := TRUE;
    START : BOOL;
    RST : BOOL;
    WAIT0 : TIME;
    DELAY0 : TIME;
    WAIT1 : TIME;
    DELAY1 : TIME;
    WAIT2 : TIME;
    DELAY2 : TIME;
    WAIT3 : TIME;
    DELAY3 : TIME;
    STOP_ON_ERROR : BOOL;
  END_VAR
  VAR_OUTPUT
    Q0 : BOOL;
    Q1 : BOOL;
    Q2 : BOOL;
    Q3 : BOOL;
    QX : BOOL;
    RUN : BOOL;
    _STEP : INT := -1;
    STATUS : BYTE;
  END_VAR
  VAR
    last : TIME;
    edge : BOOL;
    tx : TIME;
    init : BOOL;
  END_VAR

  tx:= UDINT_TO_TIME(T_PLC_MS(en:=true));

  (* initialize on startup *)
  IF NOT init THEN
  	last := tx;
  	init := TRUE;
  	status := BYTE#110;
  END_IF;

  (* asynchronous reset *)
  IF rst THEN
  	_step := -1;
  	Q0 := FALSE;
  	Q1 := FALSE;
  	Q2 := FALSE;
  	Q3 := FALSE;
  	status := BYTE#110;
  	run := FALSE;

  (* edge on start input restarts the sequencer *)
  ELSIF start AND NOT edge THEN
  	_step := 0;
  	last := tx;
  	status := BYTE#111;
  	Q0 := FALSE;
  	Q1 := FALSE;
  	Q2 := FALSE;
  	Q3 := FALSE;
  	run := TRUE;
  END_IF;
  edge := start;

  (* check if stop on status is necessary *)
  IF status > BYTE#0 AND status < BYTE#100 AND stop_on_error THEN RETURN; END_IF;

  (* sequence is running *)
  IF run AND _step = 0 THEN
  	IF NOT q0 AND in0 AND tx - last <= wait0 THEN
  		Q0 := TRUE;
  		last := tx;
  	ELSIF NOT q0 AND tx - last > wait0 THEN
  		status := BYTE#1;
  		run := FALSE;
  	ELSIF q0 AND tx - last >= delay0 THEN
  		_step := 1;
  		last := tx;
  	END_IF;
  END_IF;
  IF run AND _step = 1 THEN
  	IF NOT q1 AND in1 AND tx - last <= DELAY0 THEN
  		Q0 := FALSE;
  		Q1 := TRUE;
  		last := tx;
  	ELSIF NOT q1 AND Tx - last > DELAY0 THEN
  		status := BYTE#2;
  		q0 := FALSE;
  		run := FALSE;
  	ELSIF q1 AND tx - last >= WAIT1 THEN
  		_step := 2;
  		last := tx;
  	END_IF;
  END_IF;
  IF run AND _step = 2 THEN
  	IF NOT q2 AND in2 AND tx - last <= DELAY1 THEN
  		Q1 := FALSE;
  		Q2 := TRUE;
  		last := tx;
  	ELSIF NOT q2 AND Tx - last > DELAY1 THEN
  		status := BYTE#3;
  		q1 := FALSE;
  		run := FALSE;
  	ELSIF q2 AND tx - last >= WAIT2 THEN
  		_step := 3;
  		last := tx;
  	END_IF;
  END_IF;
  IF run AND _step = 3 THEN
  	IF NOT q3 AND in3 AND tx - last <= DELAY2 THEN
  		Q2 := FALSE;
  		Q3 := TRUE;
  		last := tx;
  	ELSIF NOT q3 AND Tx - last > DELAY2 THEN
  		status := BYTE#4;
  		q2 := FALSE;
  		run := FALSE;
  	ELSIF q3 AND tx - last >= WAIT3 THEN
  		_step := -1;
  		q3 := FALSE;
  		run := FALSE;
  		status := BYTE#110;
  	END_IF;
  END_IF;
  QX := q0 OR q1 OR q2 OR q3;

  (*From OSCAT Library, www.oscat.de *)
  (* T_PLC_MS required *)
END_FUNCTION_BLOCK
