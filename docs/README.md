# ASM86
Small subset of a X86 assembler with the syntax of NASM.
It is written in PLA and a DOS COM-program with only 12 KBytes!
You get source code and binaries.   
AS is a one pass compiler, so you have the following restrictions: 
* global variables must be declared before use
* code must be in procedures, surrounded by PROC and ENDP
* jmp and jcc are relative (NEAR,SHORT) and must be in the same procedure
* call for a procedure is near, relative and must be backwards,
  so the MAIN procedure is the last procedure in the program.
* jmp to the main proc is automatically made by the PLA compiler

AS is a COM-program and uses only one segment with 64 KByte. 
About 12 KByte for program and constants, the rest for tables and the
binary output file.    

Adjust the following constants to your needs:
1. FILEBINMAX 22000 max. length of output file
2. LABELADRMAX 600  max. global and local labels
   all local labels will be destroyed after leaving the procedure. 
   it is roughly the number of the procedures and a bit for local names.
   LabelNames[6000] array for storing the label names
3. JMPMAX 200 max.jmp and call
   JmpNames[4000] space for names of jmp, call
   
The output com file must be the same with ASM86 and NASM.
NASM must be calles the the options: -dPROC -dENDP
because NASM does not know the two words.
AS NASM is a multi pass compiler set off the optimization with -O1
  
                                    
