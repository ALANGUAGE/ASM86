;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT
org 256
nop                ;90
VA dw 8            ;08 00
;mov al, [bp-4]     ;8A 46 FC
;mov al, [VB+bx]    ;8A 87 06 00
add al, 4
add al, 259
add ax, 4
add ax, 259
add cl, 4
add cl, 259
add cx, 4
add cx, 259
add bx, ax         ;00 C3
add ax, bx         ;01 D8
add word ax, [bx]  ;03 07
add [bx+di], al
add [bx+di], ax
add al, [bx+di]
add ax, [bx+di]
