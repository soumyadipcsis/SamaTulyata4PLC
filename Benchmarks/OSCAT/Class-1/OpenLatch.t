PROGRAM program0
  VAR_INPUT
    SW1 : BOOL;
    SW2 : BOOL;
  END_VAR
  VAR_OUTPUT
    Latch : BOOL;
    Unlatch : BOOL;
  END_VAR

  Latch := SW1;
  Unlatch := SW2;
END_PROGRAM