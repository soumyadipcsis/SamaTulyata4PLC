PROC CarProcess;
VAR_INPUT
    MasterStart : BOOL;             (* Master Start Button *)
    CarDetection : BOOL;            (* Car Detection Sensor *)
    ConveyorLimitSwitch : BOOL;     (* Conveyor Limit Switch *)
    MasterStop : BOOL;              (* Master Stop Button *)
END_VAR

VAR_OUTPUT
    MasterCoil : BOOL;              (* Master Coil Output *)
    SoapSprinkler : BOOL;           (* Soap Sprinkler Output *)
    Washer : BOOL;                  (* Washer Output *)
    Conveyor : BOOL;                (* Conveyor Output *)
    Dryer : BOOL;                   (* Dryer Output *)
END_VAR

VAR
    SoapingTimeElapsed : INT := 0;  (* Elapsed Time for Soaping in seconds *)
    WashingTimeElapsed : INT := 0;  (* Elapsed Time for Washing in seconds *)
    DryingTimeElapsed : INT := 0;   (* Elapsed Time for Drying in seconds *)
END_VAR

VAR
    SoapingTimePreset : INT := 10;  (* Soaping Time Preset in seconds *)
    WashingTimePreset : INT := 25;  (* Washing Time Preset in seconds *)
    DryingTimePreset : INT := 10;   (* Drying Time Preset in seconds *)
END_VAR

BEGIN

(* Master Coil Control *)
IF MasterStart AND NOT MasterStop THEN
    MasterCoil := TRUE;
ELSE
    MasterCoil := FALSE;
END_IF;

(* Soaping Process *)
IF MasterCoil AND CarDetection THEN
    SoapSprinkler := TRUE;
    SoapingTimeElapsed := SoapingTimeElapsed + 1; (* Increment elapsed time every cycle *)
    IF SoapingTimeElapsed >= SoapingTimePreset THEN
        SoapSprinkler := FALSE; (* Stop Soap Sprinkler after preset time *)
    END_IF;
ELSE
    SoapSprinkler := FALSE;
    SoapingTimeElapsed := 0; (* Reset time if MasterCoil is OFF or Car is not detected *)
END_IF;

(* Washing Process *)
IF MasterCoil AND SoapSprinkler AND SoapingTimeElapsed >= SoapingTimePreset THEN
    Washer := TRUE;
    WashingTimeElapsed := WashingTimeElapsed + 1; (* Increment elapsed time every cycle *)
    IF WashingTimeElapsed >= WashingTimePreset THEN
        Washer := FALSE; (* Stop Washer after preset time *)
    END_IF;
ELSE
    Washer := FALSE;
    WashingTimeElapsed := 0; (* Reset time if conditions are not met *)
END_IF;

(* Conveyor Process *)
IF MasterCoil AND Washer AND WashingTimeElapsed >= WashingTimePreset AND ConveyorLimitSwitch THEN
    Conveyor := TRUE;
ELSE
    Conveyor := FALSE;
END_IF;

(* Drying Process *)
IF MasterCoil AND Conveyor AND NOT ConveyorLimitSwitch THEN
    Dryer := TRUE;
    DryingTimeElapsed := DryingTimeElapsed + 1; (* Increment elapsed time every cycle *)
    IF DryingTimeElapsed >= DryingTimePreset THEN
        Dryer := FALSE; (* Stop Dryer after preset time *)
    END_IF;
ELSE
    Dryer := FALSE;
    DryingTimeElapsed := 0; (* Reset time if conditions are not met *)
END_IF;

PARALLEL
    FOR i := 1 TO 4 DO
        STEP 'SOAP_SPRINKLER_CONTROL'
            IF MasterCoil AND CarDetection THEN
                SoapSprinkler := TRUE;
                SoapingTimeElapsed := SoapingTimeElapsed + 1; (* Increment elapsed time every cycle *)
                IF SoapingTimeElapsed >= SoapingTimePreset THEN
                    SoapSprinkler := FALSE; (* Stop Soap Sprinkler after preset time *)
                END_IF;
            ELSE
                SoapSprinkler := FALSE;
                SoapingTimeElapsed := 0; (* Reset time if MasterCoil is OFF or Car is not detected *)
            END_IF;
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR j := 1 TO 4 DO
        STEP 'WASHER_CONTROL'
            IF MasterCoil AND SoapSprinkler AND SoapingTimeElapsed >= SoapingTimePreset THEN
                Washer := TRUE;
                WashingTimeElapsed := WashingTimeElapsed + 1; (* Increment elapsed time every cycle *)
                IF WashingTimeElapsed >= WashingTimePreset THEN
                    Washer := FALSE; (* Stop Washer after preset time *)
                END_IF;
            ELSE
                Washer := FALSE;
                WashingTimeElapsed := 0; (* Reset time if conditions are not met *)
            END_IF;
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR k := 1 TO 4 DO
        STEP 'CONVEYOR_CONTROL'
            IF MasterCoil AND Washer AND WashingTimeElapsed >= WashingTimePreset AND ConveyorLimitSwitch THEN
                Conveyor := TRUE;
            ELSE
                Conveyor := FALSE;
            END_IF;
        ENDSTEP
    END_FOR
ENDPARALLEL

PARALLEL
    FOR l := 1 TO 4 DO
        STEP 'DRYER_CONTROL'
            IF MasterCoil AND Conveyor AND NOT ConveyorLimitSwitch THEN
                Dryer := TRUE;
                DryingTimeElapsed := DryingTimeElapsed + 1; (* Increment elapsed time every cycle *)
                IF DryingTimeElapsed >= DryingTimePreset THEN
                    Dryer := FALSE; (* Stop Dryer after preset time *)
                END_IF;
            ELSE
                Dryer := FALSE;
                DryingTimeElapsed := 0; (* Reset time if conditions are not met *)
            END_IF;
        ENDSTEP
    END_FOR
ENDPARALLEL

END
