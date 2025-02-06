# SamaTulyata4PLC
 The tool is written in python. To run the tool use the following command
 `python main.py <TCL_FILE_NAME> <SFC_FILE_NAME>`. To get exhaustive tool output use `--detail` flag option.
 It is an equivalence checker for verifying software migration for PLC programs. 
 The Equivalence checker works on one-safe *Petri net* based model.
 
   
# Experimentation
 For our experiemntation, we translate TCL code to Petri net and SFC to Petri net model. Our Equivalece checker 
 is Petri net based equivalence checker. SamaTulyata4PLC is integrated with the *CBM* tool. So the verification 
 time includes the *CBM* initial set up time. For each benchmark, the initial setup of the tool is performed.
 Overall verification time including OpenPLC/CBM initialization time which takes 10-20 sec for large benchmarks.
 On the other hand, for small benchmarks its carried out within a second. One can experiment with the tool in isolation. 
 The overall verification time is in microseceond range. 
 
 In every initialization phase of *CBM* variable creation table time is generated first  which is one  
 of the input of equivalence checker. The benchmark file  contains all TCL files for experimentation.
 The Tool demo video is also avaibale. In first line of experiment, the experimental time is taken with the 
 version of tool which is integrated with  *CBM*.  
 
 # Benchmarks
 Currently our benchmark directory contains 84 TCL code. 80 benchmarks we have taken from [OSCAT](https://www.oscat.de) repo.
    
# Migration tool 
TCL to SFC Migration is carried out propitory tool.
    



# Ecclipse plugin
 First version of PN based equivalence checker Ecclipse plugin version is also available Published at [ATVA 2017](https://link.springer.com/chapter/10.1007/978-3-319-68167-2_8) for further comparison. 
However, it works on C language.

 
  
