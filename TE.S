;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
;1=IMM, 2=REG, 3=ADR, 4=MEM   
org 256            ;NASM
not al             ;F6 D0       
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
