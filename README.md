# SamaTulyata4PLC
The tool SamaTulyata Works on C 
Its PLC version is not open source.
For our experiemntation, we translate TCL code to Petri net and SFC to Petri net 
Now the current version of SamaTulyata works on those generated Petri net 

In the benchmark file is also added which contains tcl file SFC file and generated Petri net models.

Structure of Benchmarks zip file

1. Software migration
  1.1 Correct migration
     1.1.1 List of benchmarks
           1.1.1.* TCL file , SFC file, PRES file for TCL, PRES file for SFC
  1.2 Faulty Migration
      1.2.1 List of benchmarks
           1.2.1.*  SFC file, PRES file for SFC faulty
2. Software upgradation
      2.1 Correct upgrades
     2.1.1 List of benchmarks
           2.1.1.* two SFC file, two PRES file for two SFC
   2.2 Faulty upgrades
      2.2.1 List of benchmarks
           1.2.1.* SFC file, PRES file for SFC faulty 
