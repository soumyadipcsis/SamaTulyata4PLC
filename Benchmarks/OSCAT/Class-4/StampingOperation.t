FUNCTION_BLOCK StampingOperation  
VAR_INPUT  
    StartButton : BOOL;  
    StopButton : BOOL;  
    LS1 : BOOL;  
    LS2 : BOOL;  
    LS3 : BOOL;  
    LSDN : BOOL;  
    LSUP : BOOL;  
END_VAR  
   
VAR_OUTPUT  
    CR1 : BOOL;  
    CR2 : BOOL;  
    CR3 : BOOL;  
    CR4 : BOOL;  
    UP_MOTOR : BOOL;  
    DN_MOTOR : BOOL;  
    MOTOR : BOOL;  
END_VAR  
   
VAR  
    CR : BOOL;  
END_VAR  
   
(* Latching logic for CR *)  
IF StartButton AND LS1 THEN  
    CR := TRUE;  
END_IF;  
   
IF StopButton THEN  
    CR := FALSE;  
END_IF;  
   
(* Rung 000 *)  
IF CR THEN  
    CR1 := TRUE;  
ELSE  
    CR1 := FALSE;  
END_IF;  
   
(* Rung 001 *)  
IF CR THEN  
    MOTOR := TRUE;  
ELSE  
    IF LS2 OR LS3 THEN  
        MOTOR := FALSE;  
    ELSE  
        MOTOR := MOTOR;  
    END_IF;  
END_IF;  
   
(* Rung 002 *)  
IF LS1 OR LS3 THEN  
    CR2 := TRUE;  
ELSE  
    CR2 := FALSE;  
END_IF;  
   
(* Rung 003 *)  
IF LS1 OR CR2 OR CR4 THEN  
    CR3 := TRUE;  
ELSE  
    CR3 := FALSE;  
END_IF;  
   
(* Rung 004 *)  
IF CR3 THEN  
    UP_MOTOR := TRUE;  
ELSE  
    IF LSUP THEN  
        UP_MOTOR := FALSE;  
    ELSE  
        UP_MOTOR := UP_MOTOR;  
    END_IF;  
END_IF;  
   
(* Rung 005 *)  
IF LSDN AND LS3 THEN  
    CR4 := TRUE;  
ELSE  
    CR4 := FALSE;  
END_IF;  
   
(* Rung 006 *)  
IF LS2 THEN  
    DN_MOTOR := TRUE;  
ELSE  
    IF CR4 AND CR2 THEN  
        DN_MOTOR := FALSE;  
    ELSE  
        DN_MOTOR := DN_MOTOR;  
    END_IF;  
END_IF;  
   
(* Rung 007 *)  
IF MOTOR THEN  
    MOTOR := TRUE;  
ELSE  
    IF LS1 AND LSDN THEN  
        MOTOR := TRUE;  
    ELSE  
        MOTOR := FALSE;  
    END_IF;  
END_IF;  
   
END_FUNCTION_BLOCK  