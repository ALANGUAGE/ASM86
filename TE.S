;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
;1=IMM, 2=REG, 3=ADR, 4=MEM
org 256
nop                 ;90
VA dw 8             ;08 00
;mov al, [bp-4]     ;8A 46 FC
;mov al, [VB+bx]    ;8A 87 06 00           
add [bx+di], al     ;00 01
add [bx+di], ax     ;01 01
add al, [bx+di]     ;02 01
add ax, [bx+di]     ;03 01
add al, 4           ;04 04
;add al, 259      ;;;04 03 bounds
add ax, 4           ;83 C0 04 ;05 04 00
add ax, 259         ;05 03 01
or  al, 4           ;0C 04         
adc ax, 259         ;15 03 01     
add cl, 4           ;80 C1 04
add cx, 259         ;81 C1 03 01
add byte [VA], 4    ;80 06 01 01 04
add word [VA], 4  ;;;83 06 01 01 04
add al, [bx+di-4]   ;02 41 FC    
add bx, ax          ;01 C3
add ax, bx          ;01 D8
add al, [bx]        ;02 07
add ax, [bx]        ;03 07
