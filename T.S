
; A.COM V0.9, Source: T.C, Output asm: T.S
org  256 
jmp main

;-1 char LIST;

LIST db 0

;-2 char V;

V db 0

;-3 int main() { 


main: PROC

;-4     char c; 


;-5     V=0; 

;Function : main, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte     4 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov byte [V], al

;-6         c=0;

 mov ax, 0
 mov [bp-2], al

;-7 } 


;-8 
 LEAVE
 ret
ENDP
 
; missing functions: 
; Number of unresolved CALLs :    0 All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width  adr used name   list of global variables

;    1 var sign byte     1 NULL LIST
;    2 var sign byte     2    1 V


;   # Calls Line Width  Name   list of functions

;    0 NULL    3   main
;    1 NULL    8   LastFunctionByt

;    #  addr name   list of CALLs

;Input: T.C, List: T.S,  Lines:    9
;Glob. variables:    2 max.:  200
;Functions      :    2 max.:  300
;Calls          :    0 max.: 2000, NameField:    0 max.:    65535
;Code until     :21667 max.: 30000, free: 8333
;Data (HeapEnd) :30000, resting stacksize:     35535
;Max. Const in '' :    0 max. 3000, free: 3000