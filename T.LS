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
    26                                  ;dec word [cx];inv effective adr
    27                                  ;inc word  VA ;inv comb opcode+operands
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
    39 00000049 F6D0                    not al             ;F6 D0
    40 0000004B F7D0                    not ax             ;F7 D0
    41 0000004D F7D1                    not cx             ;F7 D1
    42 0000004F F6970201                not byte [bx+258]  ;F6 
    43 00000053 F611                    not byte [bx+di]   ;F6
    44 00000055 F651FC                  not byte [bx+di-4] ;F6
    45 00000058 F616[0400]              not byte [VA]      ;F6
    46 0000005C F716[0400]              not word [VA]      ;F7
    47 00000060 F6D8                    neg al             ;F6 
    48 00000062 F7D8                    neg ax             ;F7
    49 00000064 F7D9                    neg cx             ;F7
    50 00000066 F69F0201                neg byte [bx+258]  ;F6
    51 0000006A F619                    neg byte [bx+di]   ;F6
    52 0000006C F659FC                  neg byte [bx+di-4] ;F6
    53 0000006F F61E[0400]              neg byte [VA]      ;F6
    54 00000073 F71E[0400]              neg word [VA]      ;F7
    55 00000077 F6E0                    mul al             ;F6 
    56 00000079 F7E0                    mul ax             ;F7
    57 0000007B F7E1                    mul cx             ;F7
    58 0000007D F6A70201                mul byte [bx+258]  ;F6
    59 00000081 F621                    mul byte [bx+di]   ;F6
    60 00000083 F661FC                  mul byte [bx+di-4] ;F6
    61 00000086 F626[0400]              mul byte [VA]      ;F6
    62 0000008A F726[0400]              mul word [VA]      ;F7
    63 0000008E F6F0                    div al             ;F6 
    64 00000090 F7F0                    div ax             ;F7
    65 00000092 F7F1                    div cx             ;F7
    66 00000094 F6B70201                div byte [bx+258]  ;F6
    67 00000098 F631                    div byte [bx+di]   ;F6
    68 0000009A F671FC                  div byte [bx+di-4] ;F6
    69 0000009D F636[0400]              div byte [VA]      ;F6
    70 000000A1 F736[0400]              div word [VA]      ;F7
    71 000000A5 F6F8                    idiv al            ;F6 
    72 000000A7 F7F8                    idiv ax            ;F7
    73 000000A9 F7F9                    idiv cx            ;F7
    74 000000AB F6BF0201                idiv byte [bx+258] ;F6
    75 000000AF F639                    idiv byte [bx+di]  ;F6
    76 000000B1 F679FC                  idiv byte [bx+di-4];F6
    77 000000B4 F63E[0400]              idiv byte [VA]     ;F6
    78 000000B8 F73E[0400]              idiv word [VA]     ;F7
    79                                  ;acc, rm           ;F6
    80 000000BC F6E8                    imul al            ;F6 
    81 000000BE F7E8                    imul ax            ;F7
    82 000000C0 F7E9                    imul cx            ;F7
    83 000000C2 F6AF0201                imul byte [bx+258] ;F6
    84 000000C6 F629                    imul byte [bx+di]  ;F6
    85 000000C8 F669FC                  imul byte [bx+di-4];F6
    86 000000CB F62E[0400]              imul byte [VA]     ;F6
    87 000000CF F72E[0400]              imul word [VA]     ;F7
    88                                  ;r16, rm           ;0F AF
    89 000000D3 0FAFD8                  imul bx, ax
    90 000000D6 0FAFC3                  imul ax, bx
    91 000000D9 F7EB                    imul bx
    92 000000DB 0FAF16[0400]            imul dx, [VA]
    93                                  ;rm, i
    94 000000E0 6BDB0E                  imul bx, 14
    95 000000E3 691E[0400]0201          imul bx, [VA], 258
