FUNCTION_BLOCK TC_S
  VAR_OUTPUT
    TC : REAL;
  END_VAR
  VAR
    init : BOOL;
    tx : UDINT;
    last : UDINT;
  END_VAR

  tx:= T_PLC_US(en:=true);

  IF NOT init THEN
  	init := TRUE;
  	TC := 0.0;
  ELSE
  	tc := UDINT_TO_REAL(tx - last) * 1.0E-6;
  END_IF;
  last := tx;

  (* From OSCAT Library, www.oscat.de *)
  (* T_PLC_MS, R2_ADD required *)
END_FUNCTION_BLOCK

FUNCTION T_PLC_MS : UDINT
  VAR
    tx : UDINT;
  END_VAR
  VAR_INPUT
    debug : BOOL;
  END_VAR
  VAR
    N : INT := 0;
    offset : UDINT := 0;
    temp : DWORD := 1;
  END_VAR

  tx := 0;
  {extern unsigned long __tick;
  extern unsigned long long common_ticktime__;
  unsigned long long ticktime_ms = (common_ticktime__)/1000000;
  UDINT plc_time = (UDINT)(ticktime_ms * (unsigned long long)__tick);
  TX = plc_time}
  T_PLC_MS := tx;
  IF debug THEN
  	T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N))-1) + OFFSET;
  END_IF;
  

  IF debug THEN
  	T_PLC_MS := (DWORD_TO_UDINT(SHL(UDINT_TO_DWORD(T_PLC_MS),N) OR SHL(temp,N))-1) + OFFSET;
  END_IF;

  (* Original Code:
  tx := TIME();
  T_PLC_MS := TIME_TO_DWORD(Tx);
  IF debug THEN
  	T_PLC_MS := (SHL(T_PLC_MS,N) OR SHL(DWORD#1,N)-1) + OFFSET;
  END_IF;
  *)

  (* From OSCAT library, www.oscat.de

  this is a temporary T_PLC_MS FB until OpenPLC gets it´s own time() functionality *)

  (* PLC_TIME and Global variables PLC_SCAN_CYCL and PLC_CYCL_TIME required *)
END_FUNCTION

FUNCTION_BLOCK R2_ADD
  VAR_INPUT
    X : REAL2;
    Y : REAL;
    _R2_ADD : REAL2;
  END_VAR
  VAR
    temp : REAL;
  END_VAR

  temp := X.RX;
  _R2_ADD.RX := Y + X.R1 + X.RX;
  _R2_ADD.R1 := temp - _R2_ADD.RX + Y + X.R1;

  (* From OSCAT Library, www.oscat.de *)
  (* Datatype REAL2 required *)
END_FUNCTION_BLOCK

TYPE
  REAL2 : STRUCT
    R1 : REAL;
    RX : REAL;
  END_STRUCT;
END_TYPE
