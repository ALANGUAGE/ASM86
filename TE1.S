org 256
nop                ;90
VA dw 8            ;08 00
les ax,  [bx+di]    ;C4 01
lss cx, [VA]        ;0F B2 0E [0400]  
les cx, [bx+di-4]   ;C4 49 FC 
lgs ax, [bx+di]     ;0F B5 01