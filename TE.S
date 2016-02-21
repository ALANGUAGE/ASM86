;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
;1=IMM, 2=REG, 3=ADR, 4=MEM   
org 256             ;NASM
not al              ;F6 D0       
VA dw 8             ;08 00  
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
add ax, 4           ;05 04 00 ;83 C0 04 XXXXXXXX
add ax, 259         ;05 03 01
or  al, 4           ;0C 04         
adc ax, 259         ;15 03 01     
add cl, 4           ;80 C1 04
add cx, 4           ;83 C1 04 
add cx, 259         ;81 C1 03 01
add  sp, 2          ;83 C4 02 
add byte [VA], 4    ;80 06 02 01 04
add word [VA], 4    ;83 06 02 01 04  
add word [VA+3],4   ;83 06 05 00 04   
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