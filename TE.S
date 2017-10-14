;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT
;1=IMM, 2=REG, 3=ADR, 4=MEM
org 256            ;NASM
jmp main
VA dw 8            ;08 00
VB db "AB",6       ;41 42 06
dec ax             ;48
dec word cx        ;49
inc ax             ;40
inc di             ;47
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
;dec word [cx];inv effective adr
;inc word  VA ;inv comb opcode+operands
inc byte [VA]      ;FE 06 04 00
inc word [VB]      ;FF 06 06 00
inc word [VB+4]    ;FF 06 0A 00
inc byte [bp]      ;FE 46 00  special case
inc byte [bp+4]    ;FE 46 04
inc byte [bp+258]  ;FE 86 02 01
inc byte [bx+di+258];FE81 02 01
inc byte [bp-4]    ;FE 46 FC
inc byte [bx+di]   ;FE 01
inc byte [bx+di-4] ;FE 41 FC
not cx              ;F7 D1
not DX              ;F7 D2
not byte [bx+258]   ;F6 97 02 01
not byte [bx+di]    ;F6 11
not byte [bx+di-4]  ;F6 51 FC
not byte [VA]       ;F6 16 01 00
not word [VA]       ;F7 16 01 00
neg cx              ;F7 D9
neg byte [bx+258]   ;F6 9F 02 01
neg byte [bx+di]    ;F6 19
neg byte [bx+di-4]  ;F6 59 FC
neg byte [VA]       ;F6 1E 02 00
neg word [VA]       ;F7 1E 02 00
mul al              ;F6 E0
mul ax              ;F7 E0
mul cx              ;F7 E1
mul byte [bx+258]   ;F6 A7 02 01
mul byte [bx+di]    ;F6 21
mul byte [bx+di-4]  ;F6 61 FC
mul byte [VA]       ;F6 26 02 00
mul word [VA]       ;F7 26 02 00
div al              ;F6 F0
div ax              ;F7 F0
div cx              ;F7 F1
div byte [bx+258]   ;F6 B7 02 01
div byte [bx+di]    ;F6 31
div byte [bx+di-4]  ;F6 71 FC
div byte [VA]       ;F6 36 02 00
div word [VA]       ;F7 36 02 00
idiv al             ;F6 F8
idiv ax             ;F7 F8
idiv cx             ;F7 F9
idiv byte [bx+258]  ;F6 BF 02 01
idiv byte [bx+di]   ;F6 39
idiv byte [bx+di-4] ;F6 79 FC
idiv byte [VA]      ;F6 3E 02 00
idiv word [VA]      ;F7 3E 02 00
;acc, rm
imul al             ;F6 E8
imul ax             ;F7 E8
imul cx             ;F7 E9
imul byte [bx+258]  ;F6 AF 02 01
imul byte [bx+di]   ;F6 29
imul byte [bx+di-4] ;F6 69 FC
imul byte [VA]      ;F6 2E 01 00
imul word [VA]      ;F7 2E 01 00

les ax,  [bx+di]    ;C4 01
lss cx, [VA]        ;0F B2 0E [0400]
les cx, [bx+di-4]   ;C4 49 FC
lgs ax, [bx+di]     ;0F B5 01
lgs ax, [VA+bx+di]  ;0F B5 81 01 00
;mov al, [bp-4]     ;8A 46 FC
;mov al, [VB+bx]    ;8A 87 06 00

add al, 4           ;04 04
;add al, 259      ;;;04 03 bounds
add ax, 4           ;83 C0 04
add ax, 259         ;05 03 01
or  al, 4           ;0C 04
adc ax, 259         ;15 03 01
add cl, 4           ;80 C1 04
add cx, 4           ;83 C1 04
add cx, 259         ;81 C1 03 01
or  cl, 4           ;80 C9 04
or  cl, 255         ;80 C9 FF
or  cx, 4           ;83 C9 04
or  cx, 127         ;83 C9 7F
or  cx, 128         ;81 C9 80 00
or  cx, 255         ;81 C9 FF 00
or  cx, 259         ;81 C9 03 01
add  sp, 2          ;83 C4 02
add byte [VA], 4    ;80 06 02 01 04
add word [VA], 4    ;83 06 02 01 04
add word [VA+3],4   ;83 06 05 01 04
;add word [VA+di]
add al, [bx+di-4]   ;02 41 FC
add bx, ax          ;01 C3
add ax, bx          ;01 D8
add al, [bx]        ;02 07
add ax, [bx]        ;03 07
add cx, [bx]        ;03 0F
add [bx], cx        ;01 0F
add [bx+si], al     ;00 00
add [bx+di], al     ;00 01
add [bx+di], ax     ;01 01
add al, [bx+di]     ;02 01
add ax, [bx+di]     ;03 01

mov al, 0           ;B0 00
mov al, 3           ;B0 03
mov al, 127         ;B0 7F
mov al, 255         ;B0 FF
mov ax, 0           ;B8 00 00
mov ax, 259         ;B8 03 01
mov ax, 65535       ;B8 FF FF
mov bl, 3           ;B3 03
mov bx, 3           ;BB 03 00
mov bx, 259         ;BB 03 01
mov byte [VA], 3    ;C6 06 02 00 03
mov word [VA], 3    ;C7 06 02 00 03 00
mov word [VA], 259  ;C7 06 02 00 03 01

mov ax, es          ;8C C0
mov ax, cs          ;8C C8
mov ax, ss          ;8C D0
mov ax, ds          ;8C D8
mov ax, fs          ;8C E0
mov ax, gs          ;8C E8
mov cx, es          ;8C C1
mov dx, es          ;8C C2
mov bx, ss          ;8C D3
mov sp, ss          ;8C D4
mov bp, fs          ;8C E5
mov si, fs          ;8C E6
mov di, fs          ;8C E7
mov [bx+di-4], es   ;8C 41 FC
mov [VA], es        ;8C 06 02 00
mov [bp-4], ss      ;8C 56 FC
mov word [bx+si],cs ;8C 08
mov es, ax          ;8E C0
mov ss, ax          ;8E D0
mov es, [bx+di-4]   ;8E 41 FC
mov es, [VA]        ;8E 06 02 00
mov al, [VA]        ;A0 02 00
mov al, [VA+3]      ;A0 05 00
mov ax, [VA]        ;A1 02 00
mov [VA], al        ;A2 02 00
mov [VA], ax        ;A3 02 00
mov al, VA          ;B0 02 00
mov ax, VA          ;B8 02 00
mov word[VA], VA    ;C7 06 02 00 02 00
mov [bx+si], al     ;88 00
mov [bx+si], cl     ;88 08
mov al, cl          ;88 C8
mov cl, al          ;88 C1
mov al, [bx+si]     ;8A 00
mov al, [bx+di-4]   ;8A 41 FC
mov cl, [bx+si]     ;8A 08
mov al, [VA+bx+si]  ;8A 80 02 00
mov al, [VA+bx+si-4];8A 80 FE FF

push ax             ;50
push di             ;57
push word [VA]      ;FF 36 02 00
push word [VB]      ;FF 36 04 00
push VA             ;68 03(01 ORG incl.)
push VB             ;68 05 01

pop ax              ;58
pop di              ;5F
pop word [VA]       ;8F 06 02 00
push es             ;06
push cs             ;0E
push ss             ;16
push ds             ;1E
push fs             ;0F A0
push gs             ;0F A8
pop es              ;07
pop ss              ;17
pop ds              ;1F
pop fs              ;0F A1
pop gs              ;0F A9
push 0              ;6A 00
push 127            ;6A 7F
push 128            ;68 80 00
push 255            ;68 FF 00
push 256            ;68 00 01
push 32767          ;68 FF 7F
push 32768          ;68 00 80
push 65535          ;68 FF FF
L2: int 33          ;CD 21
int 3               ;CD 03
int3                ;CC
into                ;CE
enter 0,0           ;C8 0000 00
enter 256,0         ;C8 0001 00
enter 32768,255     ;C8 0080 FF
ENTER 1234,16       ;C8 D204 10
L1:
jo L1               ;70 FE
JG L1               ;7F FC
jc L2               ;72 E4
jc VB               ;0F 82 EA FD
jno VA              ;0F 81 E4 FD
jc L5               ;0F 82 04 00
jo L6               ;0F 80 01 00
L5:  nop            ;90
L6:  jc L7          ;0F 82 02 00
xor ax, ax          ;31 C0
L7:
jmp L1              ;EB E1
jmp VA              ;E9 D0 FD
call L1             ;E8 DB FF
call VA             ;E8 CA FD
jmp L8              ;E9 04 00
call L8             ;E8 01 00
nop                 ;90
L8:
nop                 ;90
ror bl, 1           ;D0 CB
ror bx, 1           ;D1 CB
shl bx, 1           ;D1 E3
rol ax, 1           ;D1 C0
shl al, cl          ;D2 E0
shl ax, cl          ;D3 E0
sal al, 3           ;C0 E0 03
sal bx, 3           ;C1 E3 03
shr byte [VA], 3    ;C0 2E 02 00 03
shr word [VA], 3    ;C1 2E 02 00 03
section .bss
absolute 4096
eins resb 1
acht resd 2
sechs resw 3
zwei resb 2
absolute 1044
Einsd resd 1
dreiw resw 3
section .text
mov al, [eins]      ;A0 00 10
mov al, [acht]      ;A0 01 10
mov al, [sechs]     ;A0 09 10
mov ax, [zwei]      ;A1 0F 10
mov al, [Einsd]     ;A0 14 04
mov al, [dreiw]     ;A0 18 04
;push fehler         ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

name: PROC
nop
endp

nop
getarg_1 db "S",0

main: PROC
text1 db "T"
ENTER  6,0
jmp L9              ;E9 04 00
call L9             ;E8 01 00
nop                 ;90
L9:
push text1
push text2
leave
ret
text2 db "E"
ENDP

L10:nop
