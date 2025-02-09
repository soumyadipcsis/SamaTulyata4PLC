FUNCTION_BLOCK BOILER
  VAR_INPUT
    T_UPPER : REAL;
    T_LOWER : REAL;
    PRESSURE : BOOL := TRUE;
    ENABLE : BOOL := TRUE;
    REQ_1 : BOOL;
    REQ_2 : BOOL;
    BOOST : BOOL;
    T_UPPER_MIN : REAL := 50.0;
    T_UPPER_MAX : REAL := 60.0;
    T_LOWER_ENABLE : BOOL;
    T_LOWER_MAX : REAL := 60.0;
    T_REQUEST_1 : REAL := 70.0;
    T_REQUEST_2 : REAL := 50.0;
    T_REQUEST_HYS : REAL := 5.0;
    T_PROTECT_HIGH : REAL := 80.0;
    T_PROTECT_LOW : REAL := 10.0;
  END_VAR
  VAR_OUTPUT
    HEAT : BOOL;
    ERROR : BOOL;
    STATUS : BYTE;
  END_VAR
  VAR
    edge : BOOL;
    boost_mode : BOOL;
    flag_0 : BOOL;
    flag_1 : BOOL;
    flag_2 : BOOL;
  END_VAR

  (* read sensors and check for valid data *)
  IF t_upper > t_protect_high THEN
  	status := BYTE#1;
  	heat := FALSE;
  	error := TRUE;
  ELSIF t_upper < t_protect_low THEN
  	status := BYTE#2;
  	heat := TRUE;
  	error := TRUE;
  ELSIF t_lower > T_protect_high AND t_lower_enable THEN
  	status := BYTE#3;
  	heat := FALSE;
  	error := TRUE;
  ELSIF t_lower < t_protect_low AND t_lower_enable THEN
  	status := BYTE#4;
  	heat := TRUE;
  	error := TRUE;
  ELSIF NOT pressure THEN
  	status := BYTE#5;
  	heat := FALSE;
  	error := TRUE;
  ELSIF req_1 OR req_2 OR enable OR boost THEN
  	error := FALSE;

  	(* determine if heat needs to be turned on *)
  	IF boost AND NOT edge AND t_upper < t_upper_max THEN
  		status := BYTE#101;
  		heat := TRUE;
  		boost_mode := TRUE;
  	ELSIF enable AND t_upper < T_upper_min THEN
  		status := BYTE#102;
  		heat := TRUE;
  	ELSIF req_1 AND t_upper < T_request_1 THEN
  		status := BYTE#103;
  		heat := TRUE;
  	ELSIF req_2 AND t_upper < t_request_2 THEN
  		status := BYTE#104;
  		heat := TRUE;
  	END_IF;

  	(* determine the shut off temperature *)
  	IF heat THEN
  		IF (enable OR boost_mode) THEN
  			flag_0 := TRUE;
  			IF T_lower_enable AND T_lower > T_lower_max THEN
  				flag_0 := FALSE;
  				boost_mode := FALSE;
  			ELSIF NOT T_lower_enable AND T_upper > T_upper_max THEN
  				flag_0 := FALSE;
  				boost_mode := FALSE;
  			END_IF;
  		ELSE
  			flag_0 := FALSE;
  		END_IF;
  		flag_1 := (req_1 AND T_upper > T_request_1 + T_request_hys) AND req_1;
  		flag_2 := (req_2 AND T_upper > T_request_2 + T_request_hys) AND req_2;

  		(* shut off heat if no longer needed *)
  		heat := flag_0 OR flag_1 OR flag_2;
  		IF heat = FALSE THEN status := BYTE#100; END_IF;
  	END_IF;
  ELSE
  	status := BYTE#100;
  	heat := FALSE;
  	error := FALSE;
  END_IF;
  edge := boost;

  (* From OSCAT Library, www.OSCAT.de *)
END_FUNCTION_BLOCK
