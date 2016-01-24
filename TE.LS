     1                                  ;inc 0             dec 1
     2                                  org 256
     3 00000000 90                      nop                ;90
     4 00000001 414200                  AB db "AB",0       ;41 42 00
     5                                  
     6 00000004 0800                    VA dw 8            ;08 00
     7 00000006 4106                    VB db "A",6        ;41 06
     8                                  ;add bx, ax         ;01 C3
     9                                  ;add ax, bx         ;01 D8
    10                                  ;add word ax, [bx]  ;03 07
    11                                  ;mov al, [bp-4]     ;8A 46 FC
    12                                  ;mov al, [VB+bx]    ;8A 87 06 00
    13 00000008 FEC9                    L1: dec byte cl    ;FE C9
    14 0000000A 49                      dec word cx        ;49
    15 0000000B FE07                    inc byte [bx]      ;FE 07
    16 0000000D FE0F                    dec byte [bx]      ;FE 0F
    17 0000000F FE4F03                  dec byte [bx+3]    ;FE 4F 03
    18 00000012 FE4FFC                  dec byte [bx-4]    ;FE 4F FC
    19 00000015 F6D1                    not cl             ;F6 D1
    20 00000017 FEC9                    dec cl             ;FE C9
    21 00000019 6649                    dec ecx            ;66 49
    22 0000001B FE0F                    dec byte [bx]      ;FE 0F
    23 0000001D FE4F03                  dec byte [bx+3]    ;FE 4F 03
    24 00000020 FE8F0201                dec byte [bx+258]  ;FE 8F 02 01
    25 00000024 FE4FFC                  dec byte [bx-4]    ;FE 4F FC
    26                                  ;dec word [cx];invalid effective address
    27                                  ;inc word  VA ;invalid comb opcode+operands
    28 00000027 FE06[0400]              inc byte [VA]      ;FE 06 04 00
    29 0000002B FF06[0600]              inc word [VB]      ;FF 06 06 00
    30 0000002F FF06[0A00]              inc word [VB+4]    ;FF 06 0A 00
    31                                  ;inc      [VB];no opsize declared
    32 00000033 FE4600                  inc byte [bp]      ;FE 46 00  special case
    33 00000036 FE4604                  inc byte [bp+4]    ;FE 46 04
    34 00000039 FE860201                inc byte [bp+258]  ;FE 86 02 01
    35 0000003D FE810201                inc byte [bx+di+258];FE81 02 01
    36 00000041 FE46FC                  inc byte [bp-4]    ;FE 46 FC
    37 00000044 FE01                    inc byte [bx+di]   ;FE 01
    38 00000046 FE41FC                  inc byte [bx+di-4] ;FE 41 FC
