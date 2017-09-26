### To do next for AS
1. PROC, ENDP map every jmp after ENDP
1. goto is local in proc
1. segment, Section .text .data .bss
1. absolute n
1. Label1.local1 attached to preceeding label
1. Optable rewrite

#### To do next for PLA (A.COM)
* enable PROC, ENDP
* return ax
* org 100h; E9 _main
* symbol table: addr, Type, Kind, Name
* goto is local in proc

```
Jcc short rel 70    i8
Jcc near  rel 0F 80 i16
Jmp short rel EB    i8
Jmp near rel  E9    i16
call near rel E8    i16
```

- cmd+shift+B list modified files
- alt+cmd+Z   checkout HEAD revision

I use the following programs:
- Atom as Editor, Github Desktop,
UltraCompareX for comparing the output with NASM, Boxer                                                                                      

BAS.BAT     for compiling and assembling:
            A.COM AS.C   
            NASM.EXE -oAS.COM -fbin  -O1 -dENDP -dPROC -lAS.LS AS.S
AS TE       Assemble the test program to TE.LST
NAS.BAT     nasm assembles test file TE.S, listing TE.LS
            NASM.EXE -oT.COM -fbin -O1 -dENDP -dPROC -lTE.LS TE.S 