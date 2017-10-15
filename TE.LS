     1                                  ;BAS.BAT, AS TE, NAS.BAT
     2                                  org 256     
     3 00000000 E90100                  jmp main            ;E9 01 00
     4 00000003 08                      VA db 8       
     5                                  
     6                                  main: PROC
     7 00000004 54                      text1 db "T"
     8 00000005 E90400                  jmp L9              ;E9 04 00
     9 00000008 E80100                  call L9             ;E8 01 00
    10 0000000B 90                      nop
    11                                  L9: 
    12 0000000C 68[0400]                push text1          ;68 04 00
    13 0000000F 68[1400]                push text2          ;68 14 00     
    14 00000012 C9                      leave
    15 00000013 C3                      ret
    16                                  
    17 00000014 45                      text2 db "E"
    18                                  ENDP
    19                                  L10:
    20 00000015 90                      nop
