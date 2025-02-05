# SamaTulyata4PLC
The tool is written in python

Its is a verifier for PLC programs. It is also open source.

For our experiemntation, we translate TCL code to Petri net and SFC to Petri net 

Now the current version of SamaTulyata4PLC works on those generated Petri net 

TCL to SFC Migration is carried out propitory tool.

SamaTulyata4PLC integrated with the propitory tool. So the verification time includes the tool initial set up time.

In each benchmark, the initial setup of the tool is performed.

In the benchmark file is  contains all tcl files for experimentation.

All bechmarks are opensource benchmarks. 

Tool demo is also available for a small bechmarks.

The tool output for a smaple program gives exhaustive results for the --detail flag option.

Overall verification time including tool initialization takes 10-20 sec for large benchmarks.

On the other hand for small benchmarks its carried out within a second. 

That is because during initialization of tool program is loaded. For large programs, seperate variable list file is generated and the tool takes ~1-2 sec of time for small program and for large program it takes ~10-15 sec of time. 

First version of Demo video is also uploaded. It is not integrated with propitory tool.

All experimental time is taken with the version of tool which is integrated with propitory tool. 

One can experiment the tool in isolation as an opensouce. However, the time calculation is missing in the code. one can use time() for path Equivalence routine. 

# Ecclipse plugin
 First version of PN based equivalence checker Ecclipse plugin version is also uploaded for further comparison if possible. 
 However, it works on C language.(Published at ATVA 2017)

 
  
