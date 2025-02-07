Convert the following   TCL code 
in to well defined Control Data Flow (CDFG) form. Only dive DOT file input format
No explanation is required. Note that the translation is syntactic. No semantic 
optimization is required.  Syntax of TCL code is given Here 



Kindly follow the syntactic rules of Instruction of OLD compiler 

Syntactic Rules: This is a complete list of instructions used by the old compiler:
// Operator name. Defines the operator of an IC instruction. The enum contains
// one value for each defined IC operator.
enum teOperatorName {
  // ASSIGN OP1 RES
  // Assign to variable.
  ASSIGN,
  
  // FUNCCALL OP1 RES
  // Function call to function given by OP1. Function return value is placed in RES.
  FUNCCALL,
  // PROCCALL OP1
  // Procedure call to procedure given by OP1. 
  PROCCALL,
  // FBCALL OP1
  // Function block call to function block given by OP1.
  FBCALL,
  // NEG OP1 RES
  // Unary arithmetic negation (-). 
  NEG,
  // NOT OP1 RES.
  // Unary logical negation. 
  NOT, 
  // ADD OP1 OP2 RES.
  // Arithmetic addition.
  ADD, 
  // SUB OP1 OP2 RES.
  // Arithmetic subtraction.
  SUB,
  // MUL OP1 OP2 RES.
  // Arithmetic multiplication.
  MUL,
  // DIV OP1 OP2 RES.
  // Arithmetic division.
  DIV,
  // EQ OP1 OP2 RES.
  // Equality comparison.
  EQ,
  // GT OP1 OP2 RES.
  // Strictly greater than comparison OP1 > OP2.
  GT,
  // GE OP1 OP2 RES.
  // Greater than or equal to comparison OP1 >= OP2.
  GE,
  // LT OP1 OP2 RES.
  // Strictly less than comparison OP1 < OP2.
  LT, 
  // LE OP1 OP2 RES.
  // Less than or equal to comparison OP1 <= OP2.
  LE,
  // NE OP1 OP2 RES.
  // Not equal comparison.
  NE,
  // AND OP1 OP2 RES
  // Logical and.
  AND,
  // OR OP1 OP2 RES
  // Logical or.
  OR,
  // JMP RES
  // Jump to label RES (unconditional).
  JMP,
  // JMPFALSE OP1 RES.
  // Jump to label RES if condition OP1 is false.
  JMPFALSE,
  // JMPTRUE OP1 RES
  // Jump to label RES if condition OP1 is true.
  JMPTRUE,
  // PARAM OP1
  // Sets up a parameter for a function or procedure call (PROCCALL/FUNCCALL).
  // Parameters shall be set up in the reversed order compared to the declaration.
  PARAM, 
  // PARAMADR OP1
  // Sets up a parameter for a function or procedure call (PROCCALL/FUNCCALL).
  // This operation differs from PARAM in the way that PARAMADR shall be used when
  // passing a temporary as a reference to a procedure or function.
  // Parameters shall be set up in the reversed order compared to the declaration.
  PARAMADR,
  
  // LABEL RES
  // Defines a label. RES shall contain the label.
  LABEL, 
  // NOP 
  // No operation. 
  NOP, 
  // Undefined operator. Used as initialization and internal error handling. An operator of this kind
  // shall never be added as an instruction.
  UNDEFNAME,
  
  // DINTTOINT OP1 RES
  // DINT -> INT type cast.
  DINTTOINT,
  // DINTTOUINT OP1 RES
  // DINT -> UINT type cast.
  DINTTOUINT,
  // DINTTOWORD OP1 RES
  // DINT -> WORD type cast.
  DINTTOWORD,
  // DINTTOREAL OP1 RES.
  // DINT -> REAL type cast.
  DINTTOREAL, 
  // BOOLTODINT OP1 RES.
  // BOOL -> DINT type cast. 
  BOOLTODINT,

  // XOR_ OP1 OP2 RES
  // Boolean exclusive or.
  XOR_, 
  // bAND OP1 OP2 RES
  // Bitwise and.
  bAND,
  // bOR OP1 OP2 RES
  // Bitwise or.
  bOR,
  // bXOR OP1 OP2 RES
  // Bitwise exclusive or.
  bXOR,
  // bXOR OP1 OP2 RES
  // Bitwise negation.
  bNOT,
  // bSHL OP1 OP2 RES
  // Left-shift.
  bSHL, 
  // bSHR OP1 OP2 RES
  // Right-shift.
  bSHR,
  
  // SCHEDULE
  // Scheduler call. Used to yield conntrol to other tasks with higher priority.
  SCHEDULE,
  // FRAME RES
  // Creation/destruction of frame. NOTE: The RES operand shall contain whether the frame
  // shall be created or destroyed.
  FRAME,
  // FLOWLOG OP1 RES
  // Log of codeblock invocation for sequence verification in HI controller.
  // OP1 shall contain the flow logging firmware procedure to use. RES shall contain
  // the literal integral value 0 (due to internal implementation).
  FLOWLOG,
  // END RES
  // End mark of a codeblock. RES shall contain whether the codeblock shall be
  // linked to the next codeblock (in function blocks and programs) or if a call return
  // shall be made.
  END,
  
  // IDX_RL OP1 OP2 RES
  // Read from index OP2 in local array OP1 and write to RES.
  // Same as ASSIGN except for the indexing.
  IDX_RL,
  // IDX_RE OP1 OP2 RES
  // Read from index OP2 in external array OP1 and write to RES.
  // Same as ASSIGN except for the indexing.
  IDX_RE,
  // IDX_WL OP1 OP2 RES
  // Read from OP1 and write at index OP2 in local array RES.
  // Same as ASSIGN except for the indexing.
  IDX_WL,
  // IDX_WE OP1 OP2 RES
  // Read from OP1 and write at index OP2 in external array RES.
  // Same as ASSIGN except for the indexing.
  IDX_WE,
  // IDX_LIM OP1 OP2 RES
  // Check index in OP1 against the range [0, OP2-1] where OP2 contains
  // of the array size in number of elements. If OP1 is outside the
  // boundaries, RES gets the limited value in the range [0, OP2-1] and a
  // status flag is set in the run-time system.
  IDX_LIM,
  // PF_TEST
  // Tests the power fail flag. If the flag is set the scheduler is invoked in
  // and the power fail situation is handled by the run-time system.
  PF_TEST
};

 


TCL : OPER BD_CASE3_2S;

DBVAR
   SETPOINT,MEASURE  : REAL;

VAR
	SP,SP2,G,H:REAL;
	A,B:INTEGER;

BEGIN  /*BD_CASE3_2S*/

   	STEP   'CHECK PIDC1 SETPOINT'
		G:=0.0;
		H:=0.0;
		A:=0;
		B:=0;
		SP:=$'PIDC1'.SETPOINT;
		IF SP< 25 THEN A:=1; 
			ELSE
				IF (SP>=25 AND SP <=75) THEN A:=2;
					ELSE A:=3;
	

          	CASE A OF 	
			1: G:=$'PIDC1'. MEASURE;
			2: G:=$'PIDC2'. MEASURE;
			3: G:=$'PIDC3'. MEASURE;
		END;
    
   ENDSTEP


	STEP   'CHECK PIDC2 SETPOINT'

		SP2:=$'PIDC2'.SETPOINT;
		IF SP2< 625.0 THEN B:=1; 
			ELSE
				IF (SP2>=625.0 AND SP2 <=875.0) THEN B:=2;
					ELSE B:=3;
	

          	CASE B OF 	
			1: H:=$'PIDM'. MEASURE;
			2: H:=$'PIDC'. MEASURE;
			3: H:=$'FC200'. MEASURE;
		END;
    
   ENDSTEP


END.   /*BD_CASE3_2S*/



