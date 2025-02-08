FUNCTION_BLOCK SHR_8PLE
  VAR_INPUT
    DIN : BOOL;
    DLOAD : BYTE;
    CLK : BOOL;
    UP : BOOL := TRUE;
    LOAD : BOOL;
    RST : BOOL;
  END_VAR
  VAR_OUTPUT
    DOUT : BOOL;
  END_VAR
  VAR
    edge : BOOL := TRUE;
    register : BYTE;
  END_VAR

  IF CLK AND edge AND NOT rst THEN
  	edge := FALSE;	(* flanke wurde erkannt und weitere flankenerkennung wird verhindert bis edge wieder true ist *)
  	(* hier ist der code für das flankenevent *)
  	IF UP THEN						(*shift up *)
  		register := SHL(register,1);
          register := BIT_LOAD_B(register,Din,0);  (* register.X0 := Din; *)
          Dout     := BIT_OF_DWORD(BYTE_TO_DWORD(register),7);     (* Dout := register.X7; *)
  	ELSE						    (* shift down *)
  		register := SHR(register,1);
          register := BIT_LOAD_B(register,Din,7);  (* register.X7 := Din; *)
          Dout     := BIT_OF_DWORD(BYTE_TO_DWORD(register),0);     (* Dout := register.X0; *)
  	END_IF;
  	IF load THEN							(* the byte on Din will be loaded if load = true *)
  		register := Dload;
  		IF up THEN
              Dout := BIT_OF_DWORD(BYTE_TO_DWORD(register),7); (* register.X7 *)
          ELSE
              Dout := BIT_OF_DWORD(BYTE_TO_DWORD(register),0); (* register.X0 *)
          END_IF;
  	END_IF;
  END_IF;
  IF NOT clk THEN edge := TRUE; END_IF;	(* sobald clk wieder low wird warten auf nächste flanke *)
  IF rst THEN									(* wenn reset aktiv dann ausgang rücksetzen *)
  	register := BYTE#0;
  	Dout := FALSE;
  END_IF;

  (*From OSCAT Library, www.oscat.de *)
END_FUNCTION_BLOCK
