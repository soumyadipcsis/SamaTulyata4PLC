PROC RDM;
  VAR_INPUT
    LAST : INT;
  END_VAR
  VAR_OUTPUT
    _RDM : INT;
    tn : DWORD;
    tc : INT;
  END_VAR

  tn := UDINT_TO_DWORD(T_PLC_MS(en:=true));
  tc := Bit_Count(tn);

  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,2),31); (* tn.31 := tn.2; *)
  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,5),30); (* tn.30 := tn.5; *)
  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,4),29); (* tn.29 := tn.4; *)
  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,1),28); (* tn.28 := tn.1; *)
  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,0),27); (* tn.27 := tn.0; *)
  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,7),26); (* tn.26 := tn.7; *)
  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,6),25); (* tn.25 := tn.6; *)
  tn:=BIT_LOAD_DW(tn,BIT_OF_DWORD(tn,3),24); (* tn.24 := tn.3; *)

  tn := ROL(tn,Bit_Count(tn)) OR DWORD#16#80000001;
  tn := UDINT_TO_DWORD(DWORD_TO_UDINT(tn) MOD UDINT#71474513 + INT_TO_UDINT(tc) + UDINT#77);
  _RDM := fract(DWORD_TO_INT(tn) / 10000000.0 * (2.71828182845904523536028747135266249 - LIMIT(0.0,last,1.0)));

  (* From OSCAT Library, www.oscat.de *)
  (* T_PLC_MS required*)
END
