A.COM AS.C
if errorlevel 1 goto err
NASM.EXE -o AS.COM -f bin -l AS.LS -O1 -t AS.S 
:err