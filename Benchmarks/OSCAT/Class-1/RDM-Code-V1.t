FUNCTION_BLOCK RDM_INT
  VAR_INPUT
    LAST : INT; // LAST must now be between 0 and 1000 to simulate "fraction" effect
  END_VAR
  VAR_OUTPUT
    _RDM : INT;
    tn : UDINT;
    tc : INT;
  END_VAR

  VAR
    temp : UDINT;
    last_limited : INT;
  END_VAR

  tn := UDINT_TO_DWORD(T_PLC_MS(en:=true));
  tc := Bit_Count(tn);

  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,2), 31); // tn.31 := tn.2;
  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,5), 30);
  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,4), 29);
  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,1), 28);
  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,0), 27);
  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,7), 26);
  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,6), 25);
  tn := BIT_LOAD_DW(tn, BIT_OF_DWORD(tn,3), 24);

  tn := ROL(tn, tc) OR DWORD#16#80000001;
  tn := DWORD_TO_UDINT(DWORD_TO_UDINT(tn) MOD UDINT#71474513 + INT_TO_UDINT(tc) + UDINT#77);

  // Simulate fractional effect using integer scaling
  last_limited := LIMIT(0, LAST, 1000); // scale LAST between 0 and 1000
  temp := tn MOD 10000; // keep within a smaller range
  _RDM := INT((temp * 2718) / 1000 * last_limited / 1000); // simulate: fract * e * LAST

END_FUNCTION_BLOCK
