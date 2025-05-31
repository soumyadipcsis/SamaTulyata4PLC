PROGRAM program0
  VAR_INPUT
    Start : BOOL;
    Stop : BOOL;
  END_VAR
  VAR_IN_OUT
    MasterCoil : BOOL;
  END_VAR
  VAR_OUTPUT
    Conveyor : BOOL;
    LighSource : BOOL;
  END_VAR
  VAR_INPUT
    LDR : BOOL;
  END_VAR
  VAR
    CoilBits : BOOL;
  END_VAR
  VAR_OUTPUT
    Blowers : BOOL;
  END_VAR
  VAR
    Timer : BOOL;
  END_VAR

  MasterCoil := (MasterCoil OR Start) AND NOT Stop;
  Conveyor := MasterCoil;
  LighSource := MasterCoil;
  CoilBits := NOT Timer AND (LDR OR CoilBits);
  CoilBits := NOT Timer AND (LDR OR CoilBits);
  Blowers := NOT Stop AND Timer AND CoilBits AND MasterCoil;
  Blowers := NOT Stop AND Timer AND CoilBits AND MasterCoil;
END_PROGRAM
