# NOTE For MODEL 2025 Reviewer
It is a Petri net-based equivalence checker. Our Petri net model is a restricted CPN (Colored Petri Net) model with two properties: it is 1-safe and deterministic. Places are associated with sets of functions, and transitions are associated with guard conditions. By mistake in two places CPN is mentioned. Whenever a CPN model is mentioned, it refers to a model that satisfies these two properties. In revised version we will modified for removing confusion and bettter redablility.
# SamaTulyata4PLC
 The tool is written in python. To run the tool use the following command
 `python main.py <TCL_FILE_NAME> <SFC_FILE_NAME>`. To get exhaustive tool output use 
 `--detail` flag option. It is an equivalence checker for verifying software migration for PLC programs. 
 The Equivalence  checker works on one-safe *Petri net* based model.
# Work Flow
<img src="https://github.com/soumyadipcsis/SamaTulyata4PLC/blob/main/workFlow.jpg" width="50%">  
P<sub>s</sub>: TCL Program <br>
P<sub>m</sub>: SFC Program  <br>
N<sub>0</sub> and N<sub>1</sub>: Two Petri net models  <br>
S<sub>0</sub>: Set of Paths for N<sub>0</sub>  <br>
S<sub>1</sub>: Set of Paths for N<sub>1</sub>  <br>

In current version we have used [Normalizer](https://ieeexplore.ieee.org/document/58767) for checking equivalence between two expressions.
In future version our plan to integrate SMT solver instade of current Normalizer.

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

 
  
