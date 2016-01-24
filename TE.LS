     1                                  org 256;com
     2 00000000 90                      nop
     3                                  ;next line empty
     4                                  
     5 00000001 0800                    VA dw 8
     6 00000003 4106                    VB db "A",6
     7 00000005 FEC9                    L1: dec byte cl ;com
     8 00000007 49                      dec word cx
     9 00000008 FE07                    inc byte [bx]
    10 0000000A FE0F                    dec byte [bx]
    11 0000000C FE4F03                  dec byte [bx+3]
    12 0000000F FE4FFC                  dec byte [bx-4]
    13 00000012 F6D1                    not cl
    14 00000014 FEC9                    dec cl             ;FE C9
    15 00000016 6649                    dec ecx            ;66 49
    16 00000018 FE0F                    dec byte [bx]      ;FE 0F
    17 0000001A FE4F03                  dec byte [bx+3]    ;FE 4F 03
    18 0000001D FE8F0201                dec byte [bx+258]  ;
    19 00000021 FE4FFC                  dec byte [bx-4]    ;FE 4F FC
    20                                  ;dec word [cx];invalid effective address
    21                                  ;inc word  VA ;invalid comb opcode+operands
    22 00000024 FE06[0100]              inc byte [VA]      ;FE 06 [300F]
    23 00000028 FF06[0300]              inc word [VB]      ;FF 06 [300F]
    24 0000002C FF06[0600]              inc word [VB+3]    ;
    25                                  ;inc      [VB];no opsize declared
    26 00000030 FE4600                  inc byte [bp]      ;FE 46 00  special case
    27 00000033 FE4604                  inc byte [bp+4]    ;FE 46 04
    28 00000036 FE860201                inc byte [bp+258]  ;FE 86 02 01
    29 0000003A FE46FC                  inc byte [bp-4]    ;FE 46 FC
