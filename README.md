# SamaTulyata4PLC

    # The tool is written in python
   
    # Its is a verifier for PLC programs. It is also open source.
   
    # For our experiemntation, we translate TCL code to Petri net 
      and SFC to Petri net 
    
    # Now the current version of SamaTulyata4PLC works on those generated Petri net 
    
    # TCL to SFC Migration is carried out propitory tool.
    
    # SamaTulyata4PLC integrated with the propitory tool. So the verification 
      time includes the tool initial set up time.
   
    # In each benchmark, the initial setup of the tool is performed.
    
    # The benchmark file  contains all TCL files for experimentation.
    
    # All bechmarks are opensource benchmarks. 
    
    # Tool demo vedio is avaibale.
   
    # To get exhaustive tool output use --detail flag option.

    # Run the tool use "python main.py <TCL_FILE_NAME> <SFC_FILE_NAME>"
   
    # Results: Overall verification time including tool initialization time which takes 10-20 sec for large benchmarks.
      On the other hand for small benchmarks its carried out within a second.
    
    # Reason: Variable creation table time at OpenPlC/ CBM which is one  of the input of equivalence checker.
   
    # In first version of Demo video which is uploaded, it is not integrated with OpenPLC/ CBM.
   
    # All experimental time is taken with the version of tool which is integrated with  OpenPLC/ CBM. 
   
    # One can experiment the tool in isolation. The overall verification time is in microseceond range.



# Ecclipse plugin
 First version of PN based equivalence checker Ecclipse plugin version is also available (Published at ATVA 2017(SamaTulyata: An Efficient Path Based Equivalence Checking Tool,https://link.springer.com/chapter/10.1007/978-3-319-68167-2_8) for further comparison if possible. 
However, it works on C language.

 
  
