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

  MasterCoil := NOT(Stop) AND (MasterCoil OR Start);
  Conveyor := MasterCoil;
  LighSource := MasterCoil;
  CoilBits := NOT(Timer) AND (CoilBits OR LDR);
  CoilBits := NOT(Timer) AND (CoilBits OR LDR);
  Blowers := Timer AND CoilBits AND MasterCoil;
  Blowers := Timer AND CoilBits AND MasterCoil;
END_PROGRAM
