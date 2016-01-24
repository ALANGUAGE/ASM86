org 256
nop                ;90
;inc 0        dec 1

VA dw 8            ;08 00
VB db "A",6        ;41 06
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
inc byte [VA]      ;FE 06 01 00
inc word [VB]      ;FF 06 03 00
inc word [VB+3]    ;FF 06 06 00
;inc      [VB];no opsize declared
inc byte [bp]      ;FE 46 00  special case
inc byte [bp+4]    ;FE 46 04
inc byte [bp+258]  ;FE 86 02 01
inc byte [bp-4]    ;FE 46 FC
