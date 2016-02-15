;inc 0  dec 1  //BAS.BAT, AS TE, NAS.BAT     
;1=IMM, 2=REG, 3=ADR, 4=MEM   
org 256
not al              ;F6 D0       
VA dw 8             ;08 00  
not cx              ;F7 D1       
not byte [bx+258]   ;F6 97 02 01   
not byte [bx+di]    ;F6 11       
not byte [bx+di-4]  ;F6 51 FC     
not byte [VA]       ;F6 16 01 00 
not word [VA]       ;F7 16 01 00     
neg cx             
neg byte [bx+258]  
neg byte [bx+di]   
neg byte [bx+di-4] 
neg byte [VA]      
neg word [VA]      
mul al             
mul ax             
mul cx             
mul byte [bx+258]  
mul byte [bx+di]   
mul byte [bx+di-4] 
mul byte [VA]      
mul word [VA]      
div al             
div ax             
div cx             
div byte [bx+258]  
div byte [bx+di]   
div byte [bx+di-4] 
div byte [VA]      
div word [VA]      
idiv al            
idiv ax            
idiv cx            
idiv byte [bx+258] 
idiv byte [bx+di]  
idiv byte [bx+di-4]
idiv byte [VA]     
idiv word [VA]     
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
add ax, 4           ;05 04 00 ;83 C0 04 
add ax, 259         ;05 03 01
or  al, 4           ;0C 04         
adc ax, 259         ;15 03 01     
add cl, 4           ;80 C1 04
add cx, 259         ;81 C1 03 01
add byte [VA], 4    ;80 06 02 01 04
add word [VA], 4    ;83 06 02 01 04  
add word [VA+3],4   ;83 06 05 00 04
;add word [VA+di]
add al, [bx+di-4]   ;02 41 FC    
add bx, ax          ;01 C3
add ax, bx          ;01 D8
add al, [bx]        ;02 07
add ax, [bx]        ;03 07
add [bx+di], al     ;00 01
add [bx+di], ax     ;01 01
add al, [bx+di]     ;02 01
add ax, [bx+di]     ;03 01