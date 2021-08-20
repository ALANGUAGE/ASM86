A.COM TEST.C
if errorlevel 1 goto err  
AS TEST
NASM.EXE -oTESTNASM.COM -fbin -O1 -dENDP -dPROC -lTESTNASM.LST TEST.S  
