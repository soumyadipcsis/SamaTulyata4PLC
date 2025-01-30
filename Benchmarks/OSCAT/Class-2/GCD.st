FUNCTION_BLOCK GCD 
  VAR_INPUT
    A : DINT;
    B : DINT;
  END_VAR
  VAR
    _t : DINT;
    _a : DINT;
    _b : DINT;
  END_VAR

  VAR_OUTPUT
    out: INT;
  END_VAR	


  _A := A;
  _B := B;

  IF _A = DINT#0 THEN
  	out := DINT_TO_INT(ABS(_B));
  ELSIF _B = DINT#0 THEN
  	out := DINT_TO_INT(ABS(_A));
  ELSE
  	_A := ABS(_A);
  	_B := ABS(_B);
  	out := 1;

  	WHILE NOT((DINT_TO_DWORD(_A) AND DWORD#1) > DWORD#0 OR (DINT_TO_DWORD(_B) AND DWORD#1) > DWORD#0) DO
  		_A := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_A),1));
  		_B := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_B),1));
  		out := DWORD_TO_INT(SHR(INT_TO_DWORD(GCD),1));
  	END_WHILE;
  	WHILE _A > DINT#0 DO
  		IF NOT((DINT_TO_DWORD(_A) AND DWORD#1) > DWORD#0) THEN
  			_A := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_A),1));
  		ELSIF NOT((DINT_TO_DWORD(_B) AND DWORD#1) > DWORD#0) THEN
  			_B := DWORD_TO_DINT(SHR(DINT_TO_DWORD(_B),1));
  		ELSE
  			_t := DWORD_TO_DINT(SHR(DINT_TO_DWORD(ABS(_A-_B)),1));
  			IF _A < _B THEN
  				_B := _t;
  			ELSE
  				_A := _t;
  			END_IF;
  		END_IF;
  	END_WHILE;
  	out := out * DINT_TO_INT(_B);
  END_IF;
  (* from OSCAT library; www.oscat.de  *)
END_FUNCTION_BLOCK