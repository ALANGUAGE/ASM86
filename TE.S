org 256;com
nop
;next line empty

VA dw 8
VB db "A",6
L1: dec byte cl ;com
dec word cx
inc byte [bx]
dec byte [bx]
dec byte [bx+3]
dec byte [bx-4]
not cl
dec cl             ;FE C9
dec ecx            ;66 49
dec byte [bx]      ;FE 0F
dec byte [bx+3]    ;FE 4F 03
dec byte [bx-4]    ;FE 4F FC
;dec word [cx];invalid effective address
;inc word  VA ;invalid comb opcode+operands
inc byte [VA]      ;FE 06 [300F]
inc word [VB]      ;FF 06 [300F]
inc      [VB]      ;FE 06 [0101]
inc byte [bp]      ;FE 46 00  special case
inc byte [bp+4]    ;FE 46 04
inc byte [bp+258]  ;FE 86 02 01
inc byte [bp-4]    ;FE 46 FC
