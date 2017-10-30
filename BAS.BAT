A.COM AS.C
if errorlevel 1 goto err
NASM.EXE -oAS.COM -fbin -O1 -dENDP -dPROC -lAS.LS AS.S  
NASM.EXE  -oT.COM -fbin -O1 -dENDP -dPROC -lTE.LS AS.S 
:err