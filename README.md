
# SamaTulyata4PLC
**SamaTulyata4PLC** is an equivalence checking tool written in Python for verifying software migration of Programmable Logic Controller (PLC) programs. It checks whether the migrated implementation behaves identically to the original using one-safe **Petri net** semantics.
 To run the tool use the following command
 
 ```python main.py <TCL_FILE_NAME> <SFC_FILE_NAME>```.
 
 To get exhaustive tool output use 
 `--detail` flag option. It is an equivalence checker for verifying software migration for PLC programs. 


## ⚙️ Installation

Make sure you have Python 3 installed. You can check using:

```bash
python3 --version
```

### Running the Tool
 For Version 3 of Equivalence Checker:- 
 
To run the tool, use the following command:

```bash
python3 SoftwareMigrationVerifier-V3.py
```
### Input Format

The input format used in the `main()` routine of `SoftwareMigrationVerifier-V3.py` is as follows for the **Factorial** program:


 

    SFC:  steps1 = [
        {"name": "Start", "function": "i := 1; fact := 1"},
        {"name": "Check", "function": ""},
        {"name": "Multiply", "function": "fact := fact * i"},
        {"name": "Increment", "function": "i := i + 1"},
        {"name": "End", "function": ""}
    ]
    transitions1 = [
        {"src": "Start", "tgt": "Check", "guard": "init"},
        {"src": "Check", "tgt": "Multiply", "guard": "i <= n"},
        {"src": "Multiply", "tgt": "Increment", "guard": "True"},
        {"src": "Increment", "tgt": "Check", "guard": "True"},
        {"src": "Check", "tgt": "End", "guard": "i > n"}
    ]
    sfc1 = SFC(
        steps=steps1,
        variables=["i", "fact", "n", "init"],
        transitions=transitions1,
        initial_step="Start"
    )
    
    and Petri net Generated from TCL2PN tool for factorial TCL code is 

    pn_NAIVE_PLACE = {
        "places": ["Init", "Check", "Multiply", "Decrement", "End"],
        "functions": {
            "Init": "fact := 1; i := n; add := n + 10",
            "Check": "",
            "Multiply": "fact := fact * i",
            "Decrement": "i := i + 1",
            "End": ""
        },
        "transitions": ["t_0", "t_1", "t_2", "t_3", "t_4"],
        "transition_guards": {
            "t_0": "init",
            "t_1": "i <= n",
            "t_2": "True",
            "t_3": "True",
            "t_4": "i > n"
        },
        "input_arcs": [
            ("Init", "t_0"),
            ("Check", "t_1"),
            ("Multiply", "t_2"),
            ("Decrement", "t_3"),
            ("Check", "t_4")
        ],
        "output_arcs": [
            ("t_0", "Check"),
            ("t_1", "Multiply"),
            ("t_2", "Decrement"),
            ("t_3", "Check"),
            ("t_4", "End")
        ],
        "initial_marking": ["Init"]
        
 The Equivalence  checker works on one-safe and deterministic *Petri net* based model

# Work Flow
<img src="https://github.com/soumyadipcsis/SamaTulyata4PLC/blob/main/workFlow.jpg" width="50%">  
P<sub>s</sub>: TCL Program <br>
P<sub>m</sub>: SFC Program  <br>
N<sub>0</sub> and N<sub>1</sub>: Two Petri net models  <br>
S<sub>0</sub>: Set of Paths for N<sub>0</sub>  <br>
S<sub>1</sub>: Set of Paths for N<sub>1</sub>  <br>

In current version we have used [Normalizer](https://ieeexplore.ieee.org/document/58767) for checking equivalence between two expressions.
In future version our plan to integrate SMT solver instade of current Normalizer.
# Tool Output
 ##### For Version 2: For **a simple** program. 
<img src="https://github.com/soumyadipcsis/SamaTulyata4PLC/blob/main/Report/result-Equivalencechecking.png" width="50%">

 
 ##### For Version 3: For **Factorial** program. 
<img src="https://github.com/soumyadipcsis/SamaTulyata4PLC/blob/main/Report/EqChk-Report-Factorial.jpeg" width="50%">

# Benchmarks
 Currently our benchmark directory contains 84 TCL code (.t extension). 80 benchmarks we have taken from [OSCAT](https://www.oscat.de) repo and 4 are 
 standerd industrial benchmarks.
    
# Experimentation
 For our experiemntation, we translate TCL code to Petri net and SFC to Petri net model. 
 Our Equivalece checker is Petri net based equivalence checker. *SamaTulyata4PLC* is integrated 
 with the *Control Builder Machine (CBM)* tool. So the verification time includes the *CBM* initial set up time. 
 For each benchmark, the initial setup of the tool is performed. Overall verification time including *CBM* 
 initialization time which takes 10-20 sec for large benchmarks. On the other hand, for small benchmarks 
 its carried out within a second. One can do experiment with the tool in isolation. 
 The overall verification time is in microseceond range. 
 
 In every initialization phase of *CBM* variable creation table time is generated first which is one of the 
 input of equivalence checker. The benchmark file  contains all TCL files for experimentation. The Tool demo video 
 is also avaibale. In first line of experiment, the experimental time is taken with the version of tool 
 which is integrated with  *CBM*.  
 

    
# Migration tool 
TCL to SFC Migration is carried out propitory tool.



# Tool Demo Video
Here we use TCL version 3.
 [Demo Video](https://youtu.be/adc4NG8LuoI)

# Ecclipse plugin
 First version of *Petri net* based equivalence checker Ecclipse plugin version is also available [SamaTulyata](https://github.com/santonus/equivchecker) and Published at [ATVA 2017](https://link.springer.com/chapter/10.1007/978-3-319-68167-2_8) for further comparison. 
However, it works on C language. 

 
  
