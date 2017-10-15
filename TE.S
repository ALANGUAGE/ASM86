;BAS.BAT, AS TE, NAS.BAT
org 256     
jmp main            ;E9 01 00
VA db 8       

main: PROC
text1 db "T"
jmp L9              ;E9 04 00
call L9             ;E8 01 00
nop
L9: 
push text1          ;68 04 01
push text2          ;68 14 01     
leave
ret

text2 db "E"
ENDP
L10:
nop
