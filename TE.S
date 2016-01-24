;inc 0             dec 1
org 256
nop                ;90
AB db "AB",0       ;41 42 00

VA dw 8            ;08 00
VB db "A",6        ;41 06
;add bx, ax         ;01 C3
;add ax, bx         ;01 D8
;add word ax, [bx]  ;03 07
;mov al, [bp-4]     ;8A 46 FC
;mov al, [VB+bx]    ;8A 87 06 00
L1: dec byte cl    ;FE C9
dec word cx        ;49
inc byte [bx]      ;FE 07
dec byte [bx]      ;FE 0F
dec byte [bx+3]    ;FE 4F 03
dec byte [bx-4]    ;FE 4F FC
not cl             ;F6 D1
dec cl             ;FE C9
dec ecx            ;66 49
dec byte [bx]      ;FE 0F
dec byte [bx+3]    ;FE 4F 03
dec byte [bx+258]  ;FE 8F 02 01
dec byte [bx-4]    ;FE 4F FC
;dec word [cx];invalid effective address
;inc word  VA ;invalid comb opcode+operands
inc byte [VA]      ;FE 06 04 00
inc word [VB]      ;FF 06 06 00
inc word [VB+4]    ;FF 06 0A 00
;inc      [VB];no opsize declared
inc byte [bp]      ;FE 46 00  special case
inc byte [bp+4]    ;FE 46 04
inc byte [bp+258]  ;FE 86 02 01
inc byte [bx+di+258];FE81 02 01
inc byte [bp-4]    ;FE 46 FC
inc byte [bx+di]   ;FE 01
inc byte [bx+di-4] ;FE 41 FC