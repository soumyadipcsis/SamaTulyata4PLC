PROGRAM program1
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

  MasterCoil := (Start AND NOT Stop) OR (MasterCoil AND NOT Stop);
  Conveyor := MasterCoil;
  LighSource := MasterCoil;
  CoilBits := (LDR OR CoilBits) AND NOT Timer;
  CoilBits := (LDR OR CoilBits) AND NOT Timer;
  Blowers := MasterCoil AND CoilBits AND Timer;
  Blowers := MasterCoil AND CoilBits AND Timer;
END_PROGRAM
