
; A.COM V0.9, Source: AS.C, Output asm: AS.S
org  256 
jmp main

;-1 char Version1[]="AS.C V0.2";//BAS.BAT, AS TE, NAS.BAT

Version1 db "AS.C V0.2",0

;-2 //#include "DECL.C"


;-3 #define SYMBOLMAX    31


;-4 char Symbol[SYMBOLMAX]; //next symbol to decode

section .bss
absolute 30000
Symbol resb 31
section .text

;-5 char SymbolUpper[SYMBOLMAX];//set toupper in getName

section .bss
absolute 30031
SymbolUpper resb 31
section .text

;-6 char ProcName[SYMBOLMAX];//name of actual proc

section .bss
absolute 30062
ProcName resb 31
section .text

;-7 char isInProc=0;        //is inside a procedure

isInProc db 0

;-8 unsigned int SymbolInt; //integer value set in getDigit

SymbolInt dw 0

;-9 unsigned long SymbolLong;//integer value set in getDigit

SymbolLong dd 0

;-10 #define INPUTBUFMAX 255


;-11 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test

section .bss
absolute 30093
InputBuf resb 255
section .text

;-12 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0

;-13 char namein [67];       //input file name  .S

section .bss
absolute 30348
namein resb 67
section .text

;-14 char namelst[67];       //list file name   .LST

section .bss
absolute 30415
namelst resb 67
section .text

;-15 char namebin[67];       //output file name .COM

section .bss
absolute 30482
namebin resb 67
section .text

;-16 int  asm_fd;            //input file descriptor

asm_fd dw 0

;-17 int lst_fd;             //list file descriptor

lst_fd dw 0

;-18 int bin_fd;             //output file descriptor

bin_fd dw 0

;-19 int DOS_ERR=0;          //global var

DOS_ERR dw 0

;-20 int ErrorCount=0;       //number of errors

ErrorCount dw 0

;-21 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0

;-22 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0

;-23 


;-24 unsigned int PC=0;      //program counter

PC dw 0

;-25 unsigned int Origin=0;  //ORG nn

Origin dw 0

;-26 unsigned int AbsoluteLab=0;//uninitialised data

AbsoluteLab dw 0

;-27 unsigned int PCStart;   //PC at start of line by PrintLine()

PCStart dw 0

;-28 char isLabel;           //by getName()

isLabel db 0

;-29 #define DIGIT    1      //0-9


;-30 #define LETTERE  2      //a-z A-Z @ . _


;-31 #define ALNUME   3      //a-z A-Z @ . _  0-9


;-32 #define NOALNUME 4      //other char


;-33 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME

TokeType db 0

;-34 #define BYTE     1


;-35 #define WORD     2


;-36 #define DWORD    3


;-37 #define SEGREG   4


;-38 #define IMM      1      //const  ,123


;-39 #define REG      2      //       ,BX    mode=11


;-40 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110


;-41 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16


;-42 char Op;                //1. operand: 0, IMM, REG, ADR, MEM

Op db 0

;-43 char Op2;               //2. operand

Op2 db 0

;-44 char CodeType;          //1-207 by searchSymbol(), must be byte size

CodeType db 0

;-45 char Code1;             //1. Opcode

Code1 db 0

;-46 char Code2;             //2. Opcode

Code2 db 0

;-47 char Code3;             //3. Opcode

Code3 db 0

;-48 char R2No;              //0 - 7 AL, CL, ...  set in testReg()

R2No db 0

;-49 char R1No;              //temp for 1. register

R1No db 0

;-50 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG

R2Type db 0

;-51 char R1Type;            //temp for 1. register

R1Type db 0

;-52 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0

;-53 char wflag;             //wordflag: 0=byte, 1=word/dword

wflag db 0

;-54 char dflag;             //directionflag: 1=to reg MOV,ALU

dflag db 0

;-55 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3

sflag db 0

;-56 char rm;                //combination of index and base reg

rm db 0

;-57 char isDirect;          //set in process and getMeM, need in WriteEA

isDirect db 0

;-58 int disp;               //displacement      0-8 bytes

disp dw 0

;-59 unsigned int imme;      //immediate         0-8 bytes

imme dw 0

;-60 


;-61 #define OPMAXLEN 5


;-62 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 30549
OpPos resb 5
section .text

;-63 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0

;-64 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0

;-65 char PrintRA;           //print * for forward relocative jmp

PrintRA db 0

;-66 


;-67 #define LABELNAMESMAX 5969//next number - SYMBOLMAX


;-68 char LabelNames[6000];  //space for names of all labels

section .bss
absolute 30554
LabelNames resb 6000
section .text

;-69 char *LabelNamePtr;     //first free position

LabelNamePtr dw 0

;-70 char *tmpLabelNamePtr;  //set after PROC to LabelNamePtr

tmpLabelNamePtr dw 0

;-71 


;-72 #define LABELADRMAX 600


;-73 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 36554
LabelAddr resw 600
section .text

;-74 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0

;-75 int tmpLabelMaxIx;      //set after PROC to LabelMaxIx

tmpLabelMaxIx dw 0

;-76 int LabelIx;            //actual # of just searched label

LabelIx dw 0

;-77 


;-78 #define JMPNAMESMAX 3969//next number - SYMBOLMAX


;-79 char JmpNames[4000];    //space for names of jmp, call

section .bss
absolute 37754
JmpNames resb 4000
section .text

;-80 char *JmpNamePtr;       //first free position

JmpNamePtr dw 0

;-81 char *tmpJmpNamePtr;    //set after PROC to JmpNamePtr

tmpJmpNamePtr dw 0

;-82 


;-83 #define JMPMAX 200      //max. jmp and call


;-84 unsigned int JmpAddr[JMPMAX];//addr to be fixed

section .bss
absolute 41754
JmpAddr resw 200
section .text

;-85 int JmpMaxIx=0;         //actual # of jmp, call. 1 to JMPMAX-1

JmpMaxIx dw 0

;-86 int tmpJmpMaxIx=0;      //set after PROC to JmpMaxIx

tmpJmpMaxIx dw 0

;-87 


;-88 #define FILEBINMAX 17000


;-89 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 42154
FileBin resb 17000
section .text

;-90 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-91 


;-92 char *arglen=0x80;      // for main only

arglen dw 128

;-93 char *argv=0x82;        // for main only

argv dw 130

;-94 


;-95 


;-96 //#include "HELPER.C"


;-97 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }


writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16

;-98 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
ENDP

putch: PROC
;Function : putch, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    98 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .putch1
 mov  al, 13
 call writetty
.putch1:
 mov  al, [bp+4]
 call writetty

;-99 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
ENDP

cputs: PROC
;Function : cputs, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    99 NULL s = bp+4
;  201 var sign byte    99 NULL c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
 inc  word[bp+4]
 jmp .cputs2
.cputs3:

;-100 


;-101 int DosInt() {
 LEAVE
 ret
ENDP

DosInt: PROC

;-102     __emit__(0xCD,0x21);//inth 0x21;

 db 205,33

;-103     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4

;-104     DOS_ERR++;

 inc  word[DOS_ERR]

;-105 }


;-106 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC
;Function : openR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   106 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-107 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP

creatR: PROC
;Function : creatR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   107 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-108 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP

fcloseR: PROC
;Function : fcloseR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   108 NULL fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt

;-109 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP

exitR: PROC
;Function : exitR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   109 NULL c = bp+4;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt

;-110 int readRL(char *s, int fd, int len){
 LEAVE
 ret
ENDP

readRL: PROC

;-111     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}

;Function : readRL, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   110 NULL s = bp+4
;  201 var sign word   110 NULL fd = bp+6
;  202 var sign word   110 NULL len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-112 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP

fputcR: PROC
;Function : fputcR, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   112 NULL n = bp+4
;  201 var sign word   112 NULL fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]

;-113   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-114 


;-115 int letterE(char c) {
 LEAVE
 ret
ENDP

letterE: PROC

;-116   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   115 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE4
 mov ax, 1
 jmp .retnletterE

;-117   if (c=='.') return 1;

.letterE4:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE5
 mov ax, 1
 jmp .retnletterE

;-118   if (c=='?') return 1;

.letterE5:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE6
 mov ax, 1
 jmp .retnletterE

;-119   if (c=='$') return 1;

.letterE6:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE7
 mov ax, 1
 jmp .retnletterE

;-120   if (c> 'z') return 0;

.letterE7:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE8
 mov ax, 0
 jmp .retnletterE

;-121   if (c< '@') return 0; // at included

.letterE8:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE9
 mov ax, 0
 jmp .retnletterE

;-122   if (c> 'Z') { if (c< 'a') return 0; }

.letterE9:
 mov al, [bp+4]
 cmp al, 90
 jle .letterE10
 mov al, [bp+4]
 cmp al, 97
 jge .letterE11
 mov ax, 0
 jmp .retnletterE
.letterE11:

;-123   return 1;

.letterE10:
 mov ax, 1
 jmp .retnletterE

;-124 }


;-125 int digit(char c){

 .retnletterE: LEAVE
 ret
ENDP

digit: PROC

;-126     if(c<'0') return 0;

;Function : digit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   125 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit12
 mov ax, 0
 jmp .retndigit

;-127     if(c>'9') return 0;

.digit12:
 mov al, [bp+4]
 cmp al, 57
 jle .digit13
 mov ax, 0
 jmp .retndigit

;-128     return 1;

.digit13:
 mov ax, 1
 jmp .retndigit

;-129 }


;-130 int alnumE(char c) {

 .retndigit: LEAVE
 ret
ENDP

alnumE: PROC

;-131   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   130 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .alnumE14
 mov ax, 1
 jmp .retnalnumE

;-132   if (letterE(c)) return 1;

.alnumE14:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .alnumE15
 mov ax, 1
 jmp .retnalnumE

;-133   return 0;

.alnumE15:
 mov ax, 0
 jmp .retnalnumE

;-134 }


;-135 int strlen(char *s) { int c;

 .retnalnumE: LEAVE
 ret
ENDP

strlen: PROC

;-136     c=0;

;Function : strlen, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   135 NULL s = bp+4
;  201 var sign word   135 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax

;-137     while (*s!=0) {s++; c++;}

.strlen16:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen17
 inc  word[bp+4]
 inc  word[bp-2]

;-138     return c;

 jmp .strlen16
.strlen17:
 mov ax, [bp-2]
 jmp .retnstrlen

;-139     }


;-140 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP

strcpy: PROC

;-141     do { *s=*t; s++; t++; }

;Function : strcpy, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   140 NULL s = bp+4
;  201 ptr sign byte   140 NULL t = bp+6;
 ENTER  0,0
.strcpy18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]

;-142     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy19
 jmp .strcpy18
.strcpy19:

;-143     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al

;-144     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy

;-145     }


;-146 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP

eqstr: PROC

;-147     while(*p) {

;Function : eqstr, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   146 NULL p = bp+4
;  201 ptr sign byte   146 NULL q = bp+6;
 ENTER  0,0
.eqstr20:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr21

;-148         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr22
 mov ax, 0
 jmp .retneqstr

;-149             p++;

.eqstr22:
 inc  word[bp+4]

;-150             q++;

 inc  word[bp+6]

;-151             }


;-152     if(*q) return 0;

 jmp .eqstr20
.eqstr21:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr23
 mov ax, 0
 jmp .retneqstr

;-153     return 1;

.eqstr23:
 mov ax, 1
 jmp .retneqstr

;-154     }


;-155 int strcat1(char *s, char *t) {

 .retneqstr: LEAVE
 ret
ENDP

strcat1: PROC

;-156     while (*s != 0) s++;

;Function : strcat1, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   155 NULL s = bp+4
;  201 ptr sign byte   155 NULL t = bp+6;
 ENTER  0,0
.strcat124:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat125
 inc  word[bp+4]

;-157     strcpy(s, t);

 jmp .strcat124
.strcat125:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-158     }


;-159 int toupper(char *s) {
 LEAVE
 ret
ENDP

toupper: PROC

;-160     while(*s) {

;Function : toupper, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   159 NULL s = bp+4;
 ENTER  0,0
.toupper26:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper27

;-161         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper28
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper29
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al

;-162             s++;

.toupper29:
.toupper28:
 inc  word[bp+4]

;-163               }


;-164     }

 jmp .toupper26
.toupper27:

;-165 


;-166 int testReg() {
 LEAVE
 ret
ENDP

testReg: PROC

;-167 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-168   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al

;-169   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg30
 mov ax, 0
 jmp .retntestReg

;-170   if (strlen(Symbol) > 3) return 0;

.testReg30:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg31
 mov ax, 0
 jmp .retntestReg

;-171   R2Type=BYTE;

.testReg31:
 mov ax, 1
 mov byte [R2Type], al

;-172   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg32
 mov ax, 0
 jmp .retntestReg

;-173   if (eqstr(SymbolUpper, "CL")) return 1;

.testReg32:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg33
 mov ax, 1
 jmp .retntestReg

;-174   if (eqstr(SymbolUpper, "DL")) return 2;

.testReg33:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg34
 mov ax, 2
 jmp .retntestReg

;-175   if (eqstr(SymbolUpper, "BL")) return 3;

.testReg34:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg35
 mov ax, 3
 jmp .retntestReg

;-176   if (eqstr(SymbolUpper, "AH")) return 4;

.testReg35:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg36
 mov ax, 4
 jmp .retntestReg

;-177   if (eqstr(SymbolUpper, "CH")) return 5;

.testReg36:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg37
 mov ax, 5
 jmp .retntestReg

;-178   if (eqstr(SymbolUpper, "DH")) return 6;

.testReg37:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg38
 mov ax, 6
 jmp .retntestReg

;-179   if (eqstr(SymbolUpper, "BH")) return 7;

.testReg38:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg39
 mov ax, 7
 jmp .retntestReg

;-180   R2Type=WORD;

.testReg39:
 mov ax, 2
 mov byte [R2Type], al

;-181   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg40
 mov ax, 0
 jmp .retntestReg

;-182   if (eqstr(SymbolUpper, "CX")) return 1;

.testReg40:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg41
 mov ax, 1
 jmp .retntestReg

;-183   if (eqstr(SymbolUpper, "DX")) return 2;

.testReg41:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg42
 mov ax, 2
 jmp .retntestReg

;-184   if (eqstr(SymbolUpper, "BX")) return 3;

.testReg42:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg43
 mov ax, 3
 jmp .retntestReg

;-185   if (eqstr(SymbolUpper, "SP")) return 4;

.testReg43:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg44
 mov ax, 4
 jmp .retntestReg

;-186   if (eqstr(SymbolUpper, "BP")) return 5;

.testReg44:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg45
 mov ax, 5
 jmp .retntestReg

;-187   if (eqstr(SymbolUpper, "SI")) return 6;

.testReg45:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg46
 mov ax, 6
 jmp .retntestReg

;-188   if (eqstr(SymbolUpper, "DI")) return 7;

.testReg46:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg47
 mov ax, 7
 jmp .retntestReg

;-189   R2Type=SEGREG;

.testReg47:
 mov ax, 4
 mov byte [R2Type], al

;-190   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg48
 mov ax, 0
 jmp .retntestReg

;-191   if (eqstr(SymbolUpper, "CS")) return 1;

.testReg48:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg49
 mov ax, 1
 jmp .retntestReg

;-192   if (eqstr(SymbolUpper, "SS")) return 2;

.testReg49:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg50
 mov ax, 2
 jmp .retntestReg

;-193   if (eqstr(SymbolUpper, "DS")) return 3;

.testReg50:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg51
 mov ax, 3
 jmp .retntestReg

;-194   if (eqstr(SymbolUpper, "FS")) return 4;

.testReg51:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg52
 mov ax, 4
 jmp .retntestReg

;-195   if (eqstr(SymbolUpper, "GS")) return 5;

.testReg52:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg53
 mov ax, 5
 jmp .retntestReg

;-196   R2Type=DWORD;

.testReg53:
 mov ax, 3
 mov byte [R2Type], al

;-197   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg54
 mov ax, 0
 jmp .retntestReg

;-198   if (eqstr(SymbolUpper, "ECX"))return 1;

.testReg54:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg55
 mov ax, 1
 jmp .retntestReg

;-199   if (eqstr(SymbolUpper, "EDX"))return 2;

.testReg55:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg56
 mov ax, 2
 jmp .retntestReg

;-200   if (eqstr(SymbolUpper, "EBX"))return 3;

.testReg56:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg57
 mov ax, 3
 jmp .retntestReg

;-201   if (eqstr(SymbolUpper, "ESP"))return 4;

.testReg57:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg58
 mov ax, 4
 jmp .retntestReg

;-202   if (eqstr(SymbolUpper, "EBP"))return 5;

.testReg58:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg59
 mov ax, 5
 jmp .retntestReg

;-203   if (eqstr(SymbolUpper, "ESI"))return 6;

.testReg59:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg60
 mov ax, 6
 jmp .retntestReg

;-204   if (eqstr(SymbolUpper, "EDI"))return 7;

.testReg60:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg61
 mov ax, 7
 jmp .retntestReg

;-205   R2Type=0; return 0;

.testReg61:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg

;-206 }


;-207 


;-208 


;-209 int prc(unsigned char c) {//print char

 .retntestReg:
 ret
testReg_0 db "AL",0
testReg_1 db "CL",0
testReg_2 db "DL",0
testReg_3 db "BL",0
testReg_4 db "AH",0
testReg_5 db "CH",0
testReg_6 db "DH",0
testReg_7 db "BH",0
testReg_8 db "AX",0
testReg_9 db "CX",0
testReg_10 db "DX",0
testReg_11 db "BX",0
testReg_12 db "SP",0
testReg_13 db "BP",0
testReg_14 db "SI",0
testReg_15 db "DI",0
testReg_16 db "ES",0
testReg_17 db "CS",0
testReg_18 db "SS",0
testReg_19 db "DS",0
testReg_20 db "FS",0
testReg_21 db "GS",0
testReg_22 db "EAX",0
testReg_23 db "ECX",0
testReg_24 db "EDX",0
testReg_25 db "EBX",0
testReg_26 db "ESP",0
testReg_27 db "EBP",0
testReg_28 db "ESI",0
testReg_29 db "EDI",0
ENDP

prc: PROC

;-210         if ( _ c==10) {

;Function : prc, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   209 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .prc62

;-211             ax=13;

 mov  ax, 13

;-212             writetty();

 call writetty

;-213             }


;-214         al=c;

.prc62:
 mov  al, [bp+4]

;-215         writetty();

 call writetty

;-216     fputcR(c,lst_fd);

 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-217 }


;-218 


;-219 int prscomment(unsigned char *s) {
 LEAVE
 ret
ENDP

prscomment: PROC

;-220     unsigned char c;


;-221     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   219 NULL s = bp+4
;  201 var unsg byte   220 NULL c = bp-2;
 ENTER  2,0
.prscomment63:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment64

;-222         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-223         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-224         s++;

 inc  word[bp+4]

;-225     }


;-226 }

 jmp .prscomment63
.prscomment64:

;-227 int prs(unsigned char *s) {
 LEAVE
 ret
ENDP

prs: PROC

;-228     unsigned char c;


;-229     int com;


;-230     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   227 NULL s = bp+4
;  201 var unsg byte   228 NULL c = bp-2
;  202 var sign word   229 NULL com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax

;-231     while (*s) {

.prs65:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs66

;-232         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-233         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs67

;-234             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs68
 mov ax, 0
 mov [bp-4], ax

;-235                 else com=1;

 jmp .prs69
.prs68:
 mov ax, 1
 mov [bp-4], ax

;-236         }

.prs69:

;-237         if (c==92) {

.prs67:
 mov al, [bp-2]
 cmp al, 92
 jne .prs70

;-238             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs71

;-239                 s++;

 inc  word[bp+4]

;-240                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-241                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs72
 mov ax, 10
 mov [bp-2], al

;-242                 if (c=='t') c= 9;

.prs72:
 mov al, [bp-2]
 cmp al, 116
 jne .prs73
 mov ax, 9
 mov [bp-2], al

;-243             }

.prs73:

;-244         }

.prs71:

;-245         prc(c);

.prs70:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-246         s++;

 inc  word[bp+4]

;-247     }


;-248 }

 jmp .prs65
.prs66:

;-249 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP

printhex4: PROC

;-250     c += 48;

;Function : printhex4, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   249 NULL c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48

;-251     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex474
 add  byte[bp+4], 7

;-252     prc(c);

.printhex474:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-253 }


;-254 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP

printhex8a: PROC

;-255     unsigned char nib;


;-256     nib = c >> 4; printhex4(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   254 NULL c = bp+4
;  201 var unsg byte   255 NULL nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-257     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-258 }


;-259 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP

printhex16: PROC

;-260     unsigned int half;


;-261     half = i >>  8; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   259 NULL i = bp+4
;  201 var unsg word   260 NULL half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-262     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-263 }


;-264 int printIntU(unsigned int n) {
 LEAVE
 ret
ENDP

printIntU: PROC

;-265     unsigned int e;


;-266     if ( _ n >= 10) {

;Function : printIntU, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   264 NULL n = bp+4
;  201 var unsg word   265 NULL e = bp-2;
 ENTER  2,0 ; constant expression
cmp word[bp+4], 10 ;unsigned : 0
 jb  .printIntU75

;-267         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax

;-268         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-269     }


;-270     n = n % 10; //unsigned mod

.printIntU75:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax

;-271     n += '0';

 add  word[bp+4], 48

;-272     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-273 }


;-274 int printLine() {
 LEAVE
 ret
ENDP

printLine: PROC

;-275     int i; char c;


;-276     prs("\n");

;Function : printLine, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   275 NULL i = bp-2
;  201 var sign byte   275 NULL c = bp-4;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-277     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-278     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine76
 push printLine_1
 call prs
 add  sp, 2

;-279     else {

 jmp .printLine77
.printLine76:

;-280 //        prc(' ');


;-281         i=0;

 mov ax, 0
 mov [bp-2], ax

;-282         do {

.printLine78:

;-283             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al

;-284             prc(' ');

 push 32
 call prc
 add  sp, 2

;-285             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-286             i++;

 inc  word[bp-2]

;-287         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine79
 jmp .printLine78
.printLine79:

;-288         while (i < OPMAXLEN) {// fill rest with blank

.printLine80:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine81

;-289             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-290             i++;

 inc  word[bp-2]

;-291         }


;-292     }

 jmp .printLine80
.printLine81:

;-293     prc(PrintRA);

.printLine77:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-294     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-295 }


;-296 


;-297 int epilog() {
 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

epilog: PROC

;-298     unsigned int i; char c;     int j;


;-299     prs("\n Errors: ");

;Function : epilog, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word   298 NULL i = bp-2
;  201 var sign byte   298 NULL c = bp-4
;  202 var sign word   298 NULL j = bp-6;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-300     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-301     if (ErrorCount) prs(" *** ERRORS *** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog82
 push epilog_1
 call prs
 add  sp, 2

;-302     prs(", Out: ");

.epilog82:
 push epilog_2
 call prs
 add  sp, 2

;-303     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-304     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-305     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-306     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-307     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-308     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-309     prs(" Labels: ");

 push epilog_6
 call prs
 add  sp, 2

;-310     printIntU(LabelMaxIx);

 push word [LabelMaxIx]
 call printIntU
 add  sp, 2

;-311 // prs(", code:\n ");//debug


;-312 


;-313     i=0;

 mov ax, 0
 mov [bp-2], ax

;-314     do {

.epilog83:

;-315         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-316         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-317 // printhex8a(c); prc(' ');//debug


;-318         i++;

 inc  word[bp-2]

;-319     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog84
 jmp .epilog83
.epilog84:

;-320 


;-321 /* 


;-322   prs("\n\n LabelNamePtr:"); printIntU(LabelNamePtr);


;-323   i= &LabelNames;


;-324   prs(" &LabelNames:"); printIntU(i);


;-325   i=LabelNamePtr-i;


;-326   prs(", size: ");


;-327   printIntU(i);


;-328   prs(".\n >>");


;-329   i= &LabelNames;


;-330   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-331   } while (i < LabelNamePtr); prs("<< \n");


;-332    i = 1;


;-333     LabelNamePtr= &LabelNames;


;-334     do {


;-335       prs(LabelNamePtr); prc(' ');


;-336       j=LabelAddr[i]; printhex16(j); prs(", ");


;-337       j=strlen(LabelNamePtr);//get end of actual name


;-338       LabelNamePtr=LabelNamePtr+j;


;-339       LabelNamePtr++;


;-340       i++;


;-341     } while (i <= LabelMaxIx);


;-342 */


;-343 }


;-344 


;-345 int end1(int n) {
 LEAVE
 ret
epilog_0 db "\n Errors: ",0
epilog_1 db " *** ERRORS *** ",0
epilog_2 db ", Out: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
epilog_6 db " Labels: ",0
ENDP

end1: PROC

;-346     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   345 NULL n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-347     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-348     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-349     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-350 }


;-351 


;-352 


;-353 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-354     ErrorCount++;

;Function : error1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   353 NULL s = bp+4;
 ENTER  0,0
 inc  word[ErrorCount]

;-355     prs("\n******* next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-356     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-357     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-358     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-359 }


;-360 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n******* next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-361     error1(s);

;Function : errorexit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   360 NULL s = bp+4;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-362     epilog();

 call epilog

;-363     end1(1);

 push 1
 call end1
 add  sp, 2

;-364 }


;-365 int notfounderror(){
 LEAVE
 ret
ENDP

notfounderror: PROC

;-366     ErrorCount++;

 inc  word[ErrorCount]

;-367     prs("\n******* ERROR: label not found: ");

 push notfounderror_0
 call prs
 add  sp, 2

;-368     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-369     prs(" ");

 push notfounderror_1
 call prs
 add  sp, 2

;-370 }


;-371 int allowederror() {error1("not allowed here"); }

 ret
notfounderror_0 db "\n******* ERROR: label not found: ",0
notfounderror_1 db " ",0
ENDP

allowederror: PROC
 push allowederror_0
 call error1
 add  sp, 2

;-372 int addrerror()    {error1("address missing");}

 ret
allowederror_0 db "not allowed here",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-373 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-374 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-375 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-376 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-377 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-378 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-379 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-380 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-381 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-382 


;-383 int addrexit()     {errorexit("illegal address");}

 ret
syntaxerror_0 db "syntax",0
ENDP

addrexit: PROC
 push addrexit_0
 call errorexit
 add  sp, 2

;-384 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
addrexit_0 db "illegal address",0
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-385 int internexit()   {errorexit("intern compiler error");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

internexit: PROC
 push internexit_0
 call errorexit
 add  sp, 2

;-386 


;-387 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
internexit_0 db "intern compiler error",0
ENDP

ifEOL: PROC

;-388   if (c == 10) return 1;//LF

;Function : ifEOL, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   387 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL85
 mov ax, 1
 jmp .retnifEOL

;-389   if (c == 13) {//CR

.ifEOL85:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL86

;-390     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-391     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL87
 push ifEOL_0
 call errorexit
 add  sp, 2

;-392     return 1;

.ifEOL87:
 mov ax, 1
 jmp .retnifEOL

;-393   }


;-394   return 0;

.ifEOL86:
 mov ax, 0
 jmp .retnifEOL

;-395 }


;-396 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC

;-397   unsigned int i;


;-398   InputPtr= &InputBuf;

;Function : getLine, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   397 NULL i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-399   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-400   do {

.getLine88:

;-401     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-402     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine89
 push getLine_0
 call errorexit
 add  sp, 2

;-403     if (DOS_NoBytes == 0) return;

.getLine89:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine90
 jmp .retngetLine

;-404     *InputPtr = DOS_ByteRead;

.getLine90:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-405     InputPtr++;

 inc  word[InputPtr]

;-406     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-407     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine91
 push getLine_1
 call errorexit
 add  sp, 2

;-408   } while (ifEOL(DOS_ByteRead) == 0);

.getLine91:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne .getLine92
 jmp .getLine88
.getLine92:

;-409   InputPtr--;

 dec  word[InputPtr]

;-410   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-411 }


;-412 int skipBlank() {

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC

;-413   skipblank1:

.skipblank1:

;-414     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank93
 inc  word[InputPtr]
 jmp .skipblank1

;-415     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank93:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank94
 inc  word[InputPtr]
 jmp .skipblank1

;-416 }

.skipBlank94:

;-417 


;-418 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC

;-419   unsigned int CastInt;


;-420   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   418 NULL c = bp+4
;  201 var unsg word   419 NULL CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-421   do {

.getDigit95:

;-422     c-='0';

 sub  byte[bp+4], 48

;-423     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-424     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-425     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-426     InputPtr++;

 inc  word[InputPtr]

;-427     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-428   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit96
 jmp .getDigit95
.getDigit96:

;-429 }


;-430 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-431   char *p; unsigned int i;


;-432   p = &Symbol;

;Function : getName, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   430 NULL c = bp+4
;  201 ptr sign byte   431 NULL p = bp-2
;  202 var unsg word   431 NULL i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-433   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-434   p++;

 inc  word[bp-2]

;-435   while (alnumE(c)) {

.getName97:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName98

;-436     InputPtr++;

 inc  word[InputPtr]

;-437     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-438     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-439     p++;

 inc  word[bp-2]

;-440     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-441     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName99
 push getName_0
 call errorexit
 add  sp, 2

;-442   }

.getName99:

;-443   if (c == ':') isLabel=1; else isLabel=0;

 jmp .getName97
.getName98:
 mov al, [bp+4]
 cmp al, 58
 jne .getName100
 mov ax, 1
 mov byte [isLabel], al
 jmp .getName101
.getName100:
 mov ax, 0
 mov byte [isLabel], al

;-444   p--;

.getName101:
 dec  word[bp-2]

;-445   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-446   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-447   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-448 }


;-449 


;-450 //#include "OPTABL.C"


;-451 char I_START=0xF1;
 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
I_START db 241

;-452 //OpName, 0, CodeType, OpCode1-n, F1h


;-453 //  1:   1 byte opcode


;-454 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-455 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-456 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-457 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-458 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-459 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-460 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-461 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-462 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-463 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-464 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-465 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-466 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-467 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-468 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-469 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-470 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-471 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-472 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-473 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-474 // 2: mem reg 16 bit


;-475 char I_INC[]=  {'I','N','C',0,          2, 0,0xF1};

I_INC db 73,78,67,0,2,0,241

;-476 char I_DEC[]=  {'D','E','C',0,          2, 1,0xF1};

I_DEC db 68,69,67,0,2,1,241

;-477 char I_NOT[]=  {'N','O','T',0,          2, 2,     0xF1};

I_NOT db 78,79,84,0,2,2,241

;-478 char I_NEG[]=  {'N','E','G',0,          2, 3,     0xF1};

I_NEG db 78,69,71,0,2,3,241

;-479 char I_MUL[]=  {'M','U','L',0,          2, 4,     0xF1};

I_MUL db 77,85,76,0,2,4,241

;-480 char I_IMUL[]= {'I','M','U','L',0,      2, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,5,241

;-481 char I_DIV[]=  {'D','I','V',0,          2, 6,     0xF1};

I_DIV db 68,73,86,0,2,6,241

;-482 char I_IDIV[]= {'I','D','I','V',0,      2, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,7,241

;-483 //  3: les, lda, lea, lss, lfs, lgs


;-484 char I_LES[]=  {'L','E','S',0,          3,0xC4,0xF1};

I_LES db 76,69,83,0,3,196,241

;-485 char I_LDS[]=  {'L','D','S',0,          3,0xC5,0xF1};

I_LDS db 76,68,83,0,3,197,241

;-486 char I_LEA[]=  {'L','E','A',0,          3,0x8D,0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-487 char I_LSS[]=  {'L','S','S',0,          3,0xB2,0xF1};

I_LSS db 76,83,83,0,3,178,241

;-488 char I_LFS[]=  {'L','F','S',0,          3,0xB4,0xF1};

I_LFS db 76,70,83,0,3,180,241

;-489 char I_LGS[]=  {'L','G','S',0,          3,0xB5,0xF1};

I_LGS db 76,71,83,0,3,181,241

;-490 //  4: acc,imm  reg,imm  index,reg


;-491 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-492 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-493 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-494 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-495 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-496 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-497 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-498 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-499 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-500 //  5: mov


;-501 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-502 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-503 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-504 //  6: single byte relative jump


;-505 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-506 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-507 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-508 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-509 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-510 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-511 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-512 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-513 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-514 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-515 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-516 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-517 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-518 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-519 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-520 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-521 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-522 //  7: jmp, call


;-523 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-524 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-525 //  8: ret


;-526 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-527 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-528 //  9: seg, r/m


;-529 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xF1};

I_PUSH db 80,85,83,72,0,9,80,241

;-530 char I_POP[]=  {'P','O','P',0,          9,0x58,0xF1};

I_POP db 80,79,80,0,9,88,241

;-531 //  11: shift, rotates


;-532 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-533 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-534 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-535 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-536 //  12: int


;-537 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-538 //  14: in/out


;-539 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-540 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-541 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-542 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-543 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-544 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-545 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-546 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-547 //  15: xchg


;-548 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-549 //  16: loop, jcxz


;-550 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-551 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-552 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-553 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-554 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-555 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-556 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-557 //  30: enter


;-558 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-559 // 100: directives


;-560 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-561 // section, segment .TEXT .DATA .BSS


;-562 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-563 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-564 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-565 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-566 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-567 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-568 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-569 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-570 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-571 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-572 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-573 char I_END=0;// end of table char

I_END db 0

;-574 


;-575 int lookCode() {//ret: CodeType, *OpCodePtr


lookCode: PROC

;-576     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-577     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-578     OpCodePtr++;

 inc  word[OpCodePtr]

;-579     do  {

.lookCode102:

;-580         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode103

;-581             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode104:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode105
 inc  word[OpCodePtr]

;-582             OpCodePtr++;

 jmp .lookCode104
.lookCode105:
 inc  word[OpCodePtr]

;-583             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-584             return;

 jmp .retnlookCode

;-585         }


;-586     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode103:
.lookCode106:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode107
 inc  word[OpCodePtr]

;-587     OpCodePtr++;

 jmp .lookCode106
.lookCode107:
 inc  word[OpCodePtr]

;-588     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode108
 jmp .lookCode102
.lookCode108:

;-589 }


;-590 


;-591 int genCode8(char c) {

 .retnlookCode:
 ret
ENDP

genCode8: PROC

;-592 //set: BinLen++, OpPrintIndex++


;-593     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   591 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-594     BinLen++;

 inc  word[BinLen]

;-595     PC++;

 inc  word[PC]

;-596     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 17000 ;unsigned : 0
 jb  .genCode8109
 push genCode8_0
 call errorexit
 add  sp, 2

;-597     if (OpPrintIndex < OPMAXLEN) {

.genCode8109:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8110

;-598         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-599         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-600     }


;-601 }

.genCode8110:

;-602 int gen66h() {genCode8(0x66);
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-603 }


;-604 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-605     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   604 NULL c = bp+4
;  201 var sign byte   604 NULL d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-606     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-607 }


;-608 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-609     c = c + wflag;

;Function : genCodeW, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   608 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-610     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-611 }


;-612 int genCode16(unsigned int i) {
 LEAVE
 ret
ENDP

genCode16: PROC

;-613     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   612 NULL i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-614     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-615 }


;-616 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-617     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg dwrd   616 NULL L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-618     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-619 } 


;-620 /*


;-621 int getLen(unsigned int i) {


;-622     if (i >  127) return 2;


;-623     if (i < 0x80) return 2;//-128


;-624     return 1;


;-625 }


;-626 */        


;-627 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-628 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-629 //mod-bits: mode76, reg/opcode543, r/m210


;-630 //Op: 0, IMM, REG, ADR, MEM


;-631     char len;


;-632     len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   627 NULL xxx = bp+4
;  201 var sign byte   631 NULL len = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-633     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-634     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA111

;-635         xxx |= 0xC0;

 or  byte[bp+4], 192

;-636         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA112
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-637             else {

 jmp .writeEA113
.writeEA112:

;-638                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA114
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-639                 else            xxx = xxx + R2No;

 jmp .writeEA115
.writeEA114:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-640             }

.writeEA115:

;-641         }

.writeEA113:

;-642     if (Op == MEM) {

.writeEA111:
 mov al, [Op]
 cmp al, 4
 jne .writeEA116

;-643         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA117

;-644             xxx |= 6;

 or  byte[bp+4], 6

;-645             len = 2;

 mov ax, 2
 mov [bp-2], al

;-646         }


;-647         else {

 jmp .writeEA118
.writeEA117:

;-648             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-649             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA119

;-650                 len=1;

 mov ax, 1
 mov [bp-2], al

;-651                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA120
 or  byte[bp+4], 64

;-652             }

.writeEA120:

;-653 


;-654             if (disp) {  

.writeEA119:
 mov ax, [disp]
 or  al, al
 je .writeEA121

;-655                 ax = disp;

 mov  ax, [disp]

;-656                 if (ax < 0) __asm{ neg ax }

 cmp  ax, 0
 jge .writeEA122
 neg ax 

;-657                 if (ax > 127) len=2;

.writeEA122:
 cmp  ax, 127
 jle .writeEA123
 mov ax, 2
 mov [bp-2], al

;-658                 else len=1;

 jmp .writeEA124
.writeEA123:
 mov ax, 1
 mov [bp-2], al

;-659                 if (len == 1) xxx |= 0x40;

.writeEA124:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA125
 or  byte[bp+4], 64

;-660                 else xxx |= 0x80;

 jmp .writeEA126
.writeEA125:
 or  byte[bp+4], 128

;-661             }

.writeEA126:

;-662         }

.writeEA121:

;-663     }

.writeEA118:

;-664 


;-665     genCode8(xxx);// gen second byte

.writeEA116:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-666     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA127
 push word [disp]
 call genCode8
 add  sp, 2

;-667     if (len == 2) genCode16(disp);

.writeEA127:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA128
 push word [disp]
 call genCode16
 add  sp, 2

;-668 }

.writeEA128:

;-669 


;-670 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-671     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate129
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate130
 push word [imme]
 call genCode32
 add  sp, 2

;-672         //todo imme long


;-673         else genCode16(imme);

 jmp .genImmediate131
.genImmediate130:
 push word [imme]
 call genCode16
 add  sp, 2

;-674     else       genCode8 (imme);

.genImmediate131:
 jmp .genImmediate132
.genImmediate129:
 push word [imme]
 call genCode8
 add  sp, 2

;-675 }

.genImmediate132:

;-676 


;-677 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC

;-678     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-679     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag133

;-680         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag134
 mov al, [R1Type]
 mov byte [OpSize], al

;-681         if (Op2== REG) OpSize=R2Type;

.setwflag134:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag135
 mov al, [R2Type]
 mov byte [OpSize], al

;-682         if (R2Type== SEGREG) OpSize=WORD;

.setwflag135:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag136
 mov ax, 2
 mov byte [OpSize], al

;-683         if (R1Type == SEGREG) OpSize=WORD;

.setwflag136:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag137
 mov ax, 2
 mov byte [OpSize], al

;-684     }

.setwflag137:

;-685     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag133:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag138
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-686     if (OpSize  ==  WORD) wflag=1;

.setwflag138:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag139
 mov ax, 1
 mov byte [wflag], al

;-687 }

.setwflag139:

;-688 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-689     unsigned int ui;


;-690     sflag=2;

;Function : setsflag, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   689 NULL ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-691     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-692     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag140
 mov ax, 0
 mov byte [sflag], al

;-693     if (OpSize == BYTE) {

.setsflag140:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag141

;-694         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag142
 push setsflag_0
 call error1
 add  sp, 2

;-695         sflag=0;//byte reg does not need sign extended

.setsflag142:
 mov ax, 0
 mov byte [sflag], al

;-696     }


;-697 }

.setsflag141:

;-698 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-699     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   698 NULL ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize143
 mov ax, 0
 jmp .retncheckConstSize

;-700     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize143:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize144
 mov ax, 0
 jmp .retncheckConstSize

;-701     return 2;// is short

.checkConstSize144:
 mov ax, 2
 jmp .retncheckConstSize

;-702 }


;-703 


;-704 


;-705 int ChangeDirection() {

 .retncheckConstSize: LEAVE
 ret
ENDP

ChangeDirection: PROC

;-706     char c;


;-707     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   706 NULL c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-708     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-709     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-710     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-711 }


;-712 


;-713 int getTokeType() {
 LEAVE
 ret
ENDP

getTokeType: PROC

;-714     char c;


;-715     skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   714 NULL c = bp-2;
 ENTER  2,0
 call skipBlank

;-716     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-717     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType145
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-718     if (c == ';') {TokeType=0; return; }//comment

.getTokeType145:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType146
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-719     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

.getTokeType146:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getTokeType147
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov ax, 1
 mov byte [TokeType], al
 jmp .retngetTokeType

;-720     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

.getTokeType147:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .getTokeType148
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov ax, 3
 mov byte [TokeType], al
 jmp .retngetTokeType

;-721     TokeType=NOALNUME;

.getTokeType148:
 mov ax, 4
 mov byte [TokeType], al

;-722 }


;-723 


;-724 int isToken(char c) {

 .retngetTokeType: LEAVE
 ret
ENDP

isToken: PROC

;-725     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   724 NULL c = bp+4;
 ENTER  0,0
 call skipBlank

;-726     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken149

;-727         InputPtr++;

 inc  word[InputPtr]

;-728         return 1;

 mov ax, 1
 jmp .retnisToken

;-729         }


;-730     return 0;

.isToken149:
 mov ax, 0
 jmp .retnisToken

;-731 }


;-732 


;-733 


;-734 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-735     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   734 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need150

;-736         getTokeType();

 call getTokeType

;-737         return;

 jmp .retnneed

;-738         }


;-739     error1();

.need150:
 call error1

;-740     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-741     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-742 }


;-743 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-744     getTokeType();

 call getTokeType

;-745     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest151
 push skipRest_0
 call error1
 add  sp, 2

;-746 }

.skipRest151:

;-747 


;-748 


;-749 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC

;-750     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL152
 call implerror

;-751     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL152:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL153
 call segregerror
 jmp .retncheckOpL

;-752     setwflag();

.checkOpL153:
 call setwflag

;-753     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL154
 push checkOpL_0
 call error1
 add  sp, 2

;-754     if (OpSize == R1Type) return;

.checkOpL154:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL155
 jmp .retncheckOpL

;-755     if (Op == REG) if (R1Type==0) error1("no register defined");

.checkOpL155:
 mov al, [Op]
 cmp al, 2
 jne .checkOpL156
 mov al, [R1Type]
 cmp al, 0
 jne .checkOpL157
 push checkOpL_1
 call error1
 add  sp, 2

;-756 }

.checkOpL157:
.checkOpL156:

;-757 


;-758 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC

;-759     int LIx; char *p;


;-760     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   759 NULL LIx = bp-2
;  201 ptr sign byte   759 NULL p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-761     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-762     while (LIx <= LabelMaxIx) {

.searchLabel158:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel159

;-763         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel160
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-764         p=strlen(p) + p;

.searchLabel160:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-765         p++;

 inc  word[bp-4]

;-766         LIx++;

 inc  word[bp-2]

;-767     }


;-768     return 0;

 jmp .searchLabel158
.searchLabel159:
 mov ax, 0
 jmp .retnsearchLabel

;-769 }


;-770 


;-771 int getOp1() {//scan for a single operand

 .retnsearchLabel: LEAVE
 ret
ENDP

getOp1: PROC

;-772 //return:0, IMM, REG, ADR (not MEM)


;-773 //set   :R2Type, R2No by testReg


;-774 //set   :LabelIx by searchLabel


;-775     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1161
 mov ax, 0
 jmp .retngetOp1

;-776     if (TokeType == DIGIT)  return IMM;

.getOp1161:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1162
 mov ax, 1
 jmp .retngetOp1

;-777     if (TokeType == ALNUME) {

.getOp1162:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1163

;-778         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-779         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1164
 mov ax, 2
 jmp .retngetOp1

;-780         LabelIx=searchLabel();

.getOp1164:
 call searchLabel
 mov word [LabelIx], ax

;-781         return ADR;

 mov ax, 3
 jmp .retngetOp1

;-782     }


;-783     return 0;

.getOp1163:
 mov ax, 0
 jmp .retngetOp1

;-784 }


;-785 


;-786 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC

;-787     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1165
 call indexerror

;-788     if (R2No==3) rm=7;//BX

.getIndReg1165:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1166
 mov ax, 7
 mov byte [rm], al

;-789     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1166:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1167
 mov ax, 6
 mov byte [rm], al

;-790     if (R2No==7) rm=5;//DI

.getIndReg1167:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1168
 mov ax, 5
 mov byte [rm], al

;-791     if (R2No==6) rm=4;//SI

.getIndReg1168:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1169
 mov ax, 4
 mov byte [rm], al

;-792     if (rm==0) indexerror();

.getIndReg1169:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1170
 call indexerror

;-793 }

.getIndReg1170:

;-794 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   794 NULL m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-795     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2171
 call indexerror

;-796     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2171:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2172
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2173
 mov ax, 3
 mov [bp-2], al

;-797              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2174
.getIndReg2173:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2175
 mov ax, 1
 mov [bp-2], al

;-798     if (R2No==6) if (rm==6) m=2;//BP+SI

.getIndReg2175:
.getIndReg2174:
.getIndReg2172:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg2176
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2177
 mov ax, 2
 mov [bp-2], al

;-799              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2178
.getIndReg2177:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2179
 mov ax, 0
 mov [bp-2], al

;-800     if (m > 3) indexerror();

.getIndReg2179:
.getIndReg2178:
.getIndReg2176:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2180
 call indexerror

;-801     return m;

.getIndReg2180:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-802 }


;-803 int getMEM() {// e.g. [array+bp+si-4]

 .retngetIndReg2: LEAVE
 ret
ENDP

getMEM: PROC

;-804 //set: disp, rm, R2Type


;-805     char c;


;-806     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   805 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-807     do {

.getMEM181:

;-808         getTokeType();

 call getTokeType

;-809         c=getOp1();

 call getOp1
 mov [bp-2], al

;-810         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM182
 call syntaxerror

;-811         if (c == REG) {

.getMEM182:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM183

;-812             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-813             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM184
 call getIndReg2
 mov byte [rm], al

;-814             else getIndReg1();

 jmp .getMEM185
.getMEM184:
 call getIndReg1

;-815         }

.getMEM185:

;-816         if (c == ADR) {

.getMEM183:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM186

;-817             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM187
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-818             else notfounderror();

 jmp .getMEM188
.getMEM187:
 call notfounderror

;-819         }

.getMEM188:

;-820         if (c == IMM) disp=disp+SymbolInt;

.getMEM186:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM189
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-821         if (isToken('-')) {

.getMEM189:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM190

;-822             getTokeType();

 call getTokeType

;-823             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM191
 call numbererror

;-824             disp = disp - SymbolInt;

.getMEM191:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-825         }


;-826     } while (isToken('+'));

.getMEM190:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM192
 jmp .getMEM181
.getMEM192:

;-827     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM193
 push getMEM_0
 call errorexit
 add  sp, 2

;-828 }

.getMEM193:

;-829 


;-830 int getOpR() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC

;-831     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-832     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR194
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-833     if (Op2 == 0)     {invaloperror();         return;}

.getOpR194:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR195
 call invaloperror
 jmp .retngetOpR

;-834     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR195:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR196
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-835     if (Op2 == REG)                            return;

.getOpR196:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR197
 jmp .retngetOpR

;-836     if (Op2 == ADR)   {

.getOpR197:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR198

;-837         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR199
 mov ax, 0
 mov word [disp], ax

;-838         else disp=LabelAddr[LabelIx];

 jmp .getOpR200
.getOpR199:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-839         return;}

.getOpR200:
 jmp .retngetOpR

;-840     error1("Name of operand expected");

.getOpR198:
 push getOpR_0
 call error1
 add  sp, 2

;-841 }


;-842 


;-843 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC

;-844     getOpR();

 call getOpR

;-845     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-846     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-847     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-848 }


;-849 


;-850 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-851     getOpL();

 call getOpL

;-852     need(',');

 push 44
 call need
 add  sp, 2

;-853     getOpR();

 call getOpR

;-854 }


;-855 int check2Ops() {

 ret
ENDP

check2Ops: PROC

;-856     get2Ops();

 call get2Ops

;-857     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops201
 call addrerror

;-858     if (Op == ADR) invaloperror();

.check2Ops201:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops202
 call invaloperror

;-859     if (Op == IMM) immeerror();

.check2Ops202:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops203
 call immeerror

;-860     if (Op2==   0) addrerror();

.check2Ops203:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops204
 call addrerror

;-861 //if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov,add


;-862     setwflag();

.check2Ops204:
 call setwflag

;-863 }


;-864 


;-865 int storeJmp() {

 ret
ENDP

storeJmp: PROC

;-866     unsigned int i;


;-867     JmpMaxIx++;

;Function : storeJmp, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   866 NULL i = bp-2;
 ENTER  2,0
 inc  word[JmpMaxIx]

;-868     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp205
 push storeJmp_0
 call errorexit
 add  sp, 2

;-869     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp205:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax

;-870     JmpNamePtr++;

 inc  word[JmpNamePtr]

;-871     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax

;-872     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp206
 push storeJmp_1
 call errorexit
 add  sp, 2

;-873     JmpAddr[JmpMaxIx] = PC;

.storeJmp206:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax

;-874 }


;-875 


;-876 int storeLabel() {
 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC

;-877     unsigned int i;


;-878     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   877 NULL i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel207
 push storeLabel_0
 call error1
 add  sp, 2

;-879     LabelMaxIx++;

.storeLabel207:
 inc  word[LabelMaxIx]

;-880     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel208
 push storeLabel_1
 call errorexit
 add  sp, 2

;-881     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel208:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-882     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-883     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-884     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel209
 push storeLabel_2
 call errorexit
 add  sp, 2

;-885     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel209:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-886 }


;-887 


;-888 


;-889 int genDB() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC

;-890     char c;  char isloop;


;-891         isloop = 0;

;Function : genDB, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   890 NULL c = bp-2
;  201 var sign byte   890 NULL isloop = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al

;-892             do {

.genDB210:

;-893                 if (isloop) getTokeType();//omit ,  

 mov al, [bp-4]
 or  al, al
 je .genDB211
 call getTokeType

;-894                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB211:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB212
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-895                 else {

 jmp .genDB213
.genDB212:

;-896                     skipBlank();

 call skipBlank

;-897                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB214

;-898                         do {

.genDB215:

;-899                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-900                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-901                             InputPtr++;

 inc  word[InputPtr]

;-902                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB216
 jmp .genDB215
.genDB216:

;-903                         InputPtr++;

 inc  word[InputPtr]

;-904                     }


;-905                 } 

.genDB214:

;-906                 isloop = 1;

.genDB213:
 mov ax, 1
 mov [bp-4], al

;-907             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB217
 jmp .genDB210
.genDB217:

;-908 }


;-909 


;-910 int getVariable() {
 LEAVE
 ret
ENDP

getVariable: PROC

;-911     char c;


;-912     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   911 NULL c = bp-2;
 ENTER  2,0
 call storeLabel

;-913     getTokeType();

 call getTokeType

;-914     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable218

;-915         lookCode();

 call lookCode

;-916         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable219
 call dataexit

;-917         if (CodeType > 205) dataexit();

.getVariable219:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable220
 call dataexit

;-918         if (CodeType== 200) {//DB

.getVariable220:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable221

;-919             do {

.getVariable222:

;-920                 getTokeType();

 call getTokeType

;-921                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable223
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-922                 else {

 jmp .getVariable224
.getVariable223:

;-923                     skipBlank();

 call skipBlank

;-924                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable225

;-925                         do {

.getVariable226:

;-926                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-927                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-928                             InputPtr++;

 inc  word[InputPtr]

;-929                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable227
 jmp .getVariable226
.getVariable227:

;-930                         InputPtr++;

 inc  word[InputPtr]

;-931                     }


;-932                 }

.getVariable225:

;-933             } while (isToken(','));

.getVariable224:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable228
 jmp .getVariable222
.getVariable228:

;-934         }


;-935         if (CodeType == 201) {//DW

.getVariable221:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable229

;-936             do {

.getVariable230:

;-937                 getTokeType();

 call getTokeType

;-938                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable231
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-939             } while (isToken(','));

.getVariable231:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable232
 jmp .getVariable230
.getVariable232:

;-940         }


;-941         if (CodeType == 202) {//DD

.getVariable229:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable233

;-942             do {

.getVariable234:

;-943                 getTokeType();

 call getTokeType

;-944                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable235
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-945                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-946             } while (isToken(','));

.getVariable235:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable236
 jmp .getVariable234
.getVariable236:

;-947         }


;-948         if (CodeType >= 203) {//resb, resw, resd

.getVariable233:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable237

;-949             getTokeType();

 call getTokeType

;-950             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable238

;-951                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable239
 call syntaxerror

;-952                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable239:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable240
 push getVariable_0
 call error1
 add  sp, 2

;-953                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable240:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-954                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable241
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-955                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable241:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable242
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-956                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable242:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-957             } else numbererror();

 jmp .getVariable243
.getVariable238:
 call numbererror

;-958         }

.getVariable243:

;-959     }

.getVariable237:

;-960     else dataexit();

 jmp .getVariable244
.getVariable218:
 call dataexit

;-961 }

.getVariable244:

;-962 


;-963 int getCodeSize() {
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC

;-964     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize245

;-965         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize246
 call getTokeType
 mov ax, 1
 jmp .retngetCodeSize

;-966         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

.getCodeSize246:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize247
 call getTokeType
 mov ax, 2
 jmp .retngetCodeSize

;-967         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

.getCodeSize247:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize248
 call getTokeType
 mov ax, 3
 jmp .retngetCodeSize

;-968     }

.getCodeSize248:

;-969     return 0;

.getCodeSize245:
 mov ax, 0
 jmp .retngetCodeSize

;-970 }


;-971 


;-972 


;-973 int getarg() {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

getarg: PROC

;-974     int arglen1; int i; char *c;


;-975     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var sign word   974 NULL arglen1 = bp-2
;  201 var sign word   974 NULL i = bp-4
;  202 ptr sign byte   974 NULL c = bp-6;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-976     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg249

;-977         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-978         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-979         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-980     }


;-981     i=arglen1+129;

.getarg249:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-982     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-983     arglen1--;

 dec  word[bp-2]

;-984     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-985 


;-986     strcpy(namein, argv); strcat1(namein, ".S");

 push word [argv]
 lea  ax, [namein]
 push ax
 call strcpy
 add  sp, 4
 push getarg_1
 lea  ax, [namein]
 push ax
 call strcat1
 add  sp, 4

;-987     strcpy(namelst,argv); strcat1(namelst,".LST");

 push word [argv]
 lea  ax, [namelst]
 push ax
 call strcpy
 add  sp, 4
 push getarg_2
 lea  ax, [namelst]
 push ax
 call strcat1
 add  sp, 4

;-988     strcpy(namebin,argv); strcat1(namebin,".COM");

 push word [argv]
 lea  ax, [namebin]
 push ax
 call strcpy
 add  sp, 4
 push getarg_3
 lea  ax, [namebin]
 push ax
 call strcat1
 add  sp, 4

;-989 


;-990   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-991 


;-992     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-993     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg250
 push getarg_4
 call cputs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call cputs
 add  sp, 2
 push 1
 call exitR
 add  sp, 2

;-994     lst_fd=creatR(namelst);

.getarg250:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-995     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg251
 push getarg_5
 call cputs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call cputs
 add  sp, 2
 push 2
 call exitR
 add  sp, 2

;-996     bin_fd=creatR(namebin);

.getarg251:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-997     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg252
 push getarg_6
 call cputs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call cputs
 add  sp, 2
 push 2
 call exitR
 add  sp, 2

;-998 


;-999     prs(";");

.getarg252:
 push getarg_7
 call prs
 add  sp, 2

;-1000     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-1001     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-1002     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-1003     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-1004     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-1005 }


;-1006 


;-1007 int FixOneJmp(unsigned int hex) {
 LEAVE
 ret
getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
getarg_1 db ".S",0
getarg_2 db ".LST",0
getarg_3 db ".COM",0
getarg_4 db "Source file missing: ",0
getarg_5 db "List file not create: ",0
getarg_6 db "COM file not create: ",0
getarg_7 db ";",0
getarg_8 db ", Source: ",0
getarg_9 db ", Output: ",0
getarg_10 db ", ",0
getarg_11 db "\n",0
ENDP

FixOneJmp: PROC

;-1008     int Ix; char c;


;-1009     Ix=searchLabel();

;Function : FixOneJmp, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word  1007 NULL hex = bp+4
;  201 var sign word  1008 NULL Ix = bp-2
;  202 var sign byte  1008 NULL c = bp-4;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax

;-1010     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp253
 call notfounderror

;-1011     disp = LabelAddr[Ix];   

.FixOneJmp253:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1012     c = FileBin[hex];//look for 'A' push Absolute 

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-1013     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp254

;-1014         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax

;-1015         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax

;-1016         disp = disp - Origin; 

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1017         prs(",rel:"); printhex16(disp);

 push FixOneJmp_0
 call prs
 add  sp, 2
 push word [disp]
 call printhex16
 add  sp, 2

;-1018     }


;-1019     FileBin[hex] = disp;//fix low byte

.FixOneJmp254:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al

;-1020     hex++;

 inc  word[bp+4]

;-1021     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-1022     FileBin[hex] = disp;     

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al

;-1023 }


;-1024 int fixJmp() {   
 LEAVE
 ret
FixOneJmp_0 db ",rel:",0
ENDP

fixJmp: PROC

;-1025     unsigned int hex; int i;


;-1026     char *p; 


;-1027 //    prs("\, jmp to fix:"); printIntU(JmpMaxIx);


;-1028     p = &JmpNames;

;Function : fixJmp, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word  1025 NULL hex = bp-2
;  201 var sign word  1025 NULL i = bp-4
;  202 ptr sign byte  1026 NULL p = bp-6;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax

;-1029     i = 1;

 mov ax, 1
 mov [bp-4], ax

;-1030     while (i <= JmpMaxIx) {

.fixJmp255:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp256

;-1031         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-1032         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-1033         p++;

 inc  word[bp-6]

;-1034         hex = JmpAddr[i];  

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax

;-1035         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2

;-1036         i++;  

 inc  word[bp-4]

;-1037     }


;-1038 }

 jmp .fixJmp255
.fixJmp256:

;-1039 int fixJmpMain() {   
 LEAVE
 ret
ENDP

fixJmpMain: PROC

;-1040     prs("\nfix jmp to main. resting global jmp: ");

 push fixJmpMain_0
 call prs
 add  sp, 2

;-1041     printIntU(JmpMaxIx);  

 push word [JmpMaxIx]
 call printIntU
 add  sp, 2

;-1042     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain257
 push fixJmpMain_1
 call error1
 add  sp, 2

;-1043     strcpy(Symbol, "main");

.fixJmpMain257:
 push fixJmpMain_2
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-1044     FixOneJmp(1);//first instruction, PC=1 

 push 1
 call FixOneJmp
 add  sp, 2

;-1045     prs("\nmain ,Label+ORG:"); printhex16(disp);

 push fixJmpMain_3
 call prs
 add  sp, 2
 push word [disp]
 call printhex16
 add  sp, 2

;-1046 }


;-1047 


;-1048 


;-1049 int process() {

 ret
fixJmpMain_0 db "\nfix jmp to main. resting global jmp: ",0
fixJmpMain_1 db "resting global jmp",0
fixJmpMain_2 db "main",0
fixJmpMain_3 db "\nmain ,Label+ORG:",0
ENDP

process: PROC

;-1050     char c;


;-1051     int i;


;-1052     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1050 NULL c = bp-2
;  201 var sign word  1051 NULL i = bp-4;
 ENTER  4,0
 mov ax, 0
 mov byte [rm], al
 mov byte [wflag], al
 mov byte [dflag], al
 mov byte [R2No], al
 mov byte [R1No], al
 mov byte [R2Type], al
 mov byte [R1Type], al
 mov byte [Op2], al
 mov byte [Op], al

;-1053     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-1054     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-1055     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-1056     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-1057     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-1058     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-1059     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-1060 


;-1061     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process258

;-1062         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1063         return;

 jmp .retnprocess

;-1064     }


;-1065 


;-1066     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process258:
 mov al, [CodeType]
 cmp al, 2
 jne .process259

;-1067         getOpL();

 call getOpL

;-1068         checkOpL();

 call checkOpL

;-1069         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process260

;-1070   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process261

;-1071                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process262

;-1072                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process263
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4

;-1073                         else   genCode2(0x40, R1No);//INC 

 jmp .process264
.process263:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4

;-1074                     return; 

.process264:
 jmp .retnprocess

;-1075                     }


;-1076             }

.process262:

;-1077         }

.process261:

;-1078         if (Code1 == 5) {//imul extension?

.process260:
 mov al, [Code1]
 cmp al, 5
 jne .process265

;-1079             getTokeType();

 call getTokeType

;-1080             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process266
 call implerror

;-1081         }

.process266:

;-1082         if (Code1 < 2) genCodeW(0xFE);

.process265:
 mov al, [Code1]
 cmp al, 2
 jge .process267
 push 254
 call genCodeW
 add  sp, 2

;-1083             else genCodeW(0xF6);

 jmp .process268
.process267:
 push 246
 call genCodeW
 add  sp, 2

;-1084         writeEA(Code1);

.process268:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1085         return;

 jmp .retnprocess

;-1086     }


;-1087 


;-1088     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process259:
 mov al, [CodeType]
 cmp al, 3
 jne .process269

;-1089         check2Ops();    //setwflag not applicable

 call check2Ops

;-1090         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process270
 call reg16error

;-1091         if (Op2 != MEM) addrerror();//only m16

.process270:
 mov al, [Op2]
 cmp al, 4
 je  .process271
 call addrerror

;-1092 


;-1093         if (Code1 >= 0xB2) {   

.process271:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process272

;-1094             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process273
 push 15
 call genCode8
 add  sp, 2

;-1095         }

.process273:

;-1096         genCode8(Code1);

.process272:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1097         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1098         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1099         return;

 jmp .retnprocess

;-1100     }


;-1101 


;-1102     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process269:
 mov al, [CodeType]
 cmp al, 4
 jne .process274

;-1103         check2Ops();  

 call check2Ops

;-1104         if (Op2 == ADR) {  

 mov al, [Op2]
 cmp al, 3
 jne .process275

;-1105             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process276
 call notfounderror

;-1106             imme=LabelAddr[LabelIx];

.process276:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax

;-1107             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al

;-1108         }


;-1109         if (Op2 == IMM) {//second operand is imm

.process275:
 mov al, [Op2]
 cmp al, 1
 jne .process277

;-1110             setsflag();

 call setsflag

;-1111             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process278

;-1112                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process279

;-1113                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process280

;-1114                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1115                         c += 4;

 add  byte[bp-2], 4

;-1116                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1117                         genImmediate();

 call genImmediate

;-1118                         return;

 jmp .retnprocess

;-1119                     }


;-1120                 }

.process280:

;-1121             }

.process279:

;-1122             //r/m, imm: 80 sign-extended,TTT,imm


;-1123             c = sflag + 0x80;

.process278:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1124             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1125             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1126             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process281
 push word [imme]
 call genCode8
 add  sp, 2

;-1127             else genImmediate();

 jmp .process282
.process281:
 call genImmediate

;-1128             return;

.process282:
 jmp .retnprocess

;-1129         }


;-1130         c = Code1 << 3;//r/m, r/r

.process277:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1131         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process283

;-1132             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process284

;-1133                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1134                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1135                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1136                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1137                 return;

 jmp .retnprocess

;-1138             }


;-1139         }

.process284:

;-1140         if (Op2 == REG) {//mem,reg    reg,reg

.process283:
 mov al, [Op2]
 cmp al, 2
 jne .process285

;-1141             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1142             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1143             return;

 jmp .retnprocess

;-1144         }


;-1145         syntaxerror();

.process285:
 call syntaxerror

;-1146         return;

 jmp .retnprocess

;-1147     }


;-1148 


;-1149     if (CodeType == 5) {//mov (movsx, movzx=51)

.process274:
 mov al, [CodeType]
 cmp al, 5
 jne .process286

;-1150         check2Ops();

 call check2Ops

;-1151         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process287

;-1152             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process288
 mov ax, [disp]
 mov word [imme], ax

;-1153             else notfounderror();

 jmp .process289
.process288:
 call notfounderror

;-1154             Op2=IMM;//continue with IMM

.process289:
 mov ax, 1
 mov byte [Op2], al

;-1155         }


;-1156         if (Op2 == IMM) {// r,i

.process287:
 mov al, [Op2]
 cmp al, 1
 jne .process290

;-1157             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process291

;-1158                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1159                 c += 0xB0;

 add  byte[bp-2], 176

;-1160                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1161                 genImmediate();

 call genImmediate

;-1162                 return;

 jmp .retnprocess

;-1163             }


;-1164             if (Op == MEM) {// m,i

.process291:
 mov al, [Op]
 cmp al, 4
 jne .process292

;-1165                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1166                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1167                 genImmediate();

 call genImmediate

;-1168                 return;

 jmp .retnprocess

;-1169             }


;-1170             regmemerror();

.process292:
 call regmemerror

;-1171             return;

 jmp .retnprocess

;-1172         }


;-1173         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process290:
 mov al, [R1Type]
 cmp al, 4
 jne .process293
 call ChangeDirection

;-1174         if (R2Type == SEGREG) {//rm,sreg

.process293:
 mov al, [R2Type]
 cmp al, 4
 jne .process294

;-1175             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process295
 call reg16error

;-1176                 genCode2(0x8C, dflag);

.process295:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1177                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1178                 return;

 jmp .retnprocess

;-1179         }


;-1180         if (Op2 == MEM) {//acc, moffs16

.process294:
 mov al, [Op2]
 cmp al, 4
 jne .process296

;-1181             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process297

;-1182                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process298

;-1183                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process299

;-1184                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1185                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1186                         return;

 jmp .retnprocess

;-1187                     }


;-1188                 }

.process299:

;-1189             }

.process298:

;-1190         }

.process297:

;-1191         if (Op == MEM) {//moffs16, acc

.process296:
 mov al, [Op]
 cmp al, 4
 jne .process300

;-1192             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process301

;-1193                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process302

;-1194                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process303

;-1195                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1196                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1197                         return;

 jmp .retnprocess

;-1198                     }


;-1199                 }

.process303:

;-1200             }

.process302:

;-1201 


;-1202         }

.process301:

;-1203         if (Op2 == REG) {//rm, r

.process300:
 mov al, [Op2]
 cmp al, 2
 jne .process304

;-1204             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1205             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1206             return;

 jmp .retnprocess

;-1207         }


;-1208         if (Op2 == MEM) {//r, m

.process304:
 mov al, [Op2]
 cmp al, 4
 jne .process305

;-1209             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process306

;-1210                 ChangeDirection();

 call ChangeDirection

;-1211                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1212                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1213                 return;

 jmp .retnprocess

;-1214             }


;-1215         }

.process306:

;-1216         syntaxerror();

.process305:
 call syntaxerror

;-1217         return;

 jmp .retnprocess

;-1218     }


;-1219 


;-1220     if (CodeType == 6) {//Jcc

.process286:
 mov al, [CodeType]
 cmp al, 6
 jne .process307

;-1221         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process308

;-1222             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1223             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process309

;-1224                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1225                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1226                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1227                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process310

;-1228                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1229                     disp -= 2;

 sub  word[disp], 2

;-1230                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1231                 } else {

 jmp .process311
.process310:

;-1232                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1233                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1234                     disp -= 4;

 sub  word[disp], 4

;-1235                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1236                 }


;-1237             }

.process311:

;-1238             else {//jump forward, near only

 jmp .process312
.process309:

;-1239                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1240                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1241                 storeJmp();

 call storeJmp

;-1242                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1243                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1244             }


;-1245         return;

.process312:
 jmp .retnprocess

;-1246         }


;-1247     }

.process308:

;-1248 


;-1249     if (CodeType == 7) {//jmp, call

.process307:
 mov al, [CodeType]
 cmp al, 7
 jne .process313

;-1250         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process314

;-1251             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1252             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process315

;-1253                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1254                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1255                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1256                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process316

;-1257                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process317

;-1258                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1259                         disp -= 2;

 sub  word[disp], 2

;-1260                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1261                     }


;-1262                     else {

 jmp .process318
.process317:

;-1263                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1264                         disp -= 3;

 sub  word[disp], 3

;-1265                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1266                     }


;-1267                 }

.process318:

;-1268                 else {

 jmp .process319
.process316:

;-1269                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1270                     disp -= 3;

 sub  word[disp], 3

;-1271                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1272                 }


;-1273             }

.process319:

;-1274             else {//jump forward, near only

 jmp .process320
.process315:

;-1275                 genCode8(Code1);  

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1276                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process321
 call storeJmp

;-1277                 genCode16(0);

.process321:
 push 0
 call genCode16
 add  sp, 2

;-1278                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1279             }


;-1280         return;

.process320:
 jmp .retnprocess

;-1281         }


;-1282     }

.process314:

;-1283 


;-1284     if (CodeType ==  8) {//ret,retf

.process313:
 mov al, [CodeType]
 cmp al, 8
 jne .process322

;-1285         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process323

;-1286             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1287             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1288             return;

 jmp .retnprocess

;-1289         }


;-1290         genCode8(Code1);

.process323:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1291         return;

 jmp .retnprocess

;-1292     }


;-1293 


;-1294     if (CodeType == 9) {//push, pop

.process322:
 mov al, [CodeType]
 cmp al, 9
 jne .process324

;-1295         getOpL();

 call getOpL

;-1296         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process325

;-1297             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process326

;-1298                 setsflag();

 call setsflag

;-1299                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1300                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process327
 push word [imme]
 call genCode8
 add  sp, 2

;-1301                 else       genCode16(imme);

 jmp .process328
.process327:
 push word [imme]
 call genCode16
 add  sp, 2

;-1302                 return;

.process328:
 jmp .retnprocess

;-1303             }


;-1304             if (Op == ADR) {//push string ABSOLUTE i16 

.process326:
 mov al, [Op]
 cmp al, 3
 jne .process329

;-1305                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process330

;-1306                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1307                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1308                     return;

 jmp .retnprocess

;-1309                 }


;-1310                 else {

 jmp .process331
.process330:

;-1311                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1312                     storeJmp();

 call storeJmp

;-1313                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2

;-1314                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al

;-1315                     return;

 jmp .retnprocess

;-1316                 }


;-1317             }

.process331:

;-1318         }

.process329:

;-1319         if (R1Type == SEGREG) {

.process325:
 mov al, [R1Type]
 cmp al, 4
 jne .process332

;-1320             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process333

;-1321                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process334
 push process_0
 call error1
 add  sp, 2

;-1322             }

.process334:

;-1323             c = R1No <<3;

.process333:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1324             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process335

;-1325                 c += 122;  //0x7A

 add  byte[bp-2], 122

;-1326                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1327             }


;-1328             if (Code1 == 0x50) c +=6;//push

.process335:
 mov al, [Code1]
 cmp al, 80
 jne .process336
 add  byte[bp-2], 6

;-1329                 else c += 7;//pop

 jmp .process337
.process336:
 add  byte[bp-2], 7

;-1330             genCode8(c);

.process337:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1331             return;

 jmp .retnprocess

;-1332         } 


;-1333         


;-1334         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM    

.process332:
 call checkOpL

;-1335 //prs("\nOp: "); printIntU(Op); prs(", R1Type: "); printIntU(R1Type);


;-1336 


;-1337         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process338

;-1338             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process339

;-1339                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2

;-1340                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2

;-1341             }else {

 jmp .process340
.process339:

;-1342                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2

;-1343                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2

;-1344             }


;-1345             return;

.process340:
 jmp .retnprocess

;-1346         }


;-1347         


;-1348         if (R1Type == BYTE) reg16error();

.process338:
 mov al, [R1Type]
 cmp al, 1
 jne .process341
 call reg16error

;-1349         if (R1Type == WORD) {//is REG, w/o SEGREG

.process341:
 mov al, [R1Type]
 cmp al, 2
 jne .process342

;-1350             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1351             return;

 jmp .retnprocess

;-1352         }  


;-1353         


;-1354         syntaxerror();

.process342:
 call syntaxerror

;-1355         return;

 jmp .retnprocess

;-1356     }


;-1357 


;-1358     if (CodeType == 11) {//shift, rotate

.process324:
 mov al, [CodeType]
 cmp al, 11
 jne .process343

;-1359         check2Ops();

 call check2Ops

;-1360         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process344

;-1361             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process345

;-1362                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1363                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1364                 return;

 jmp .retnprocess

;-1365             }


;-1366             genCodeW(0xC0);//80186

.process345:
 push 192
 call genCodeW
 add  sp, 2

;-1367             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1368             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1369             return;

 jmp .retnprocess

;-1370         }


;-1371         if (Op2 == REG) {

.process344:
 mov al, [Op2]
 cmp al, 2
 jne .process346

;-1372             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process347

;-1373                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process348

;-1374                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process349
 mov ax, 1
 mov byte [wflag], al

;-1375                     genCodeW(0xD2);

.process349:
 push 210
 call genCodeW
 add  sp, 2

;-1376                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1377                     return;

 jmp .retnprocess

;-1378                 }


;-1379             }

.process348:

;-1380         }

.process347:

;-1381     }

.process346:

;-1382 


;-1383     if (CodeType == 12) {//int

.process343:
 mov al, [CodeType]
 cmp al, 12
 jne .process350

;-1384         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process351

;-1385             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1386             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1387             return;

 jmp .retnprocess

;-1388         }


;-1389     }

.process351:

;-1390 


;-1391     if (CodeType == 14) {//in, out

.process350:
 mov al, [CodeType]
 cmp al, 14
 jne .process352

;-1392         implerror();

 call implerror

;-1393         return;   

 jmp .retnprocess

;-1394     }


;-1395     if (CodeType == 15) {//xchg

.process352:
 mov al, [CodeType]
 cmp al, 15
 jne .process353

;-1396         implerror();

 call implerror

;-1397         return;   

 jmp .retnprocess

;-1398     }


;-1399     if (CodeType == 16) {//loop

.process353:
 mov al, [CodeType]
 cmp al, 16
 jne .process354

;-1400         implerror();

 call implerror

;-1401         return;   

 jmp .retnprocess

;-1402     }


;-1403 


;-1404     if (CodeType == 30) {//enter i18,i8

.process354:
 mov al, [CodeType]
 cmp al, 30
 jne .process355

;-1405         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1406         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1407         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process356
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1408         else numbererror();

 jmp .process357
.process356:
 call numbererror

;-1409         need(',');

.process357:
 push 44
 call need
 add  sp, 2

;-1410         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1411         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process358
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1412         else numbererror();

 jmp .process359
.process358:
 call numbererror

;-1413         return;

.process359:
 jmp .retnprocess

;-1414     }


;-1415 


;-1416     if (CodeType == 41) {//test

.process355:
 mov al, [CodeType]
 cmp al, 41
 jne .process360

;-1417         implerror();

 call implerror

;-1418         return;   

 jmp .retnprocess

;-1419     }


;-1420 


;-1421     if (CodeType == 51) {//movsx, movzx=51

.process360:
 mov al, [CodeType]
 cmp al, 51
 jne .process361

;-1422         implerror();

 call implerror

;-1423         return;   

 jmp .retnprocess

;-1424     }


;-1425 


;-1426     if (CodeType==101) {//ORG nn

.process361:
 mov al, [CodeType]
 cmp al, 101
 jne .process362

;-1427         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process363
 call numbererror

;-1428         Origin=SymbolInt;

.process363:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1429         return;

 jmp .retnprocess

;-1430     }


;-1431 


;-1432     if (CodeType == 102) {//section, segment

.process362:
 mov al, [CodeType]
 cmp al, 102
 jne .process364

;-1433         //getTokeType();//ignore .bss .text .data


;-1434         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1435         return;

 jmp .retnprocess

;-1436     }


;-1437 


;-1438     if (CodeType == 110) {//absolute

.process364:
 mov al, [CodeType]
 cmp al, 110
 jne .process365

;-1439         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process366
 call numbererror

;-1440         AbsoluteLab=SymbolInt;

.process366:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1441         return;

 jmp .retnprocess

;-1442     }


;-1443     if (CodeType == 111) {//name: PROC

.process365:
 mov al, [CodeType]
 cmp al, 111
 jne .process367

;-1444         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process368

;-1445             prs("\nentering: ");

 push process_1
 call prs
 add  sp, 2

;-1446             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1447             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1448             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax

;-1449             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax

;-1450             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax

;-1451             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax

;-1452         } else error1("already in PROC");

 jmp .process369
.process368:
 push process_2
 call error1
 add  sp, 2

;-1453         return;

.process369:
 jmp .retnprocess

;-1454     }


;-1455     if (CodeType == 112) {//ENDP 

.process367:
 mov al, [CodeType]
 cmp al, 112
 jne .process370

;-1456         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process371
 push process_3
 call error1
 add  sp, 2

;-1457         prs("\nleaving: ");

.process371:
 push process_4
 call prs
 add  sp, 2

;-1458         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1459         prs(", loc labels: ");

 push process_5
 call prs
 add  sp, 2

;-1460         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax

;-1461         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1462         prs(", loc jmp forward: ");

 push process_6
 call prs
 add  sp, 2

;-1463         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax

;-1464         printIntU(i);        

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1465         fixJmp();

 call fixJmp

;-1466         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1467         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax

;-1468         LabelMaxIx   = tmpLabelMaxIx;                       

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax

;-1469         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax

;-1470         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax

;-1471         return;

 jmp .retnprocess

;-1472     } 


;-1473     if (CodeType == 200) {//db  

.process370:
 mov al, [CodeType]
 cmp al, 200
 jne .process372

;-1474         genDB();

 call genDB

;-1475         return;

 jmp .retnprocess

;-1476     }


;-1477     


;-1478     error1("Command not implemented or syntax error");

.process372:
 push process_7
 call error1
 add  sp, 2

;-1479 }


;-1480 


;-1481 int parse() {

 .retnprocess: LEAVE
 ret
process_0 db "pop cs not allowed",0
process_1 db "\nentering: ",0
process_2 db "already in PROC",0
process_3 db "not in PROC",0
process_4 db "\nleaving: ",0
process_5 db ", loc labels: ",0
process_6 db ", loc jmp forward: ",0
process_7 db "Command not implemented or syntax error",0
ENDP

parse: PROC

;-1482     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-1483     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax

;-1484     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-1485     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax

;-1486     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-1487     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1488 


;-1489     do {//process a new line

.parse373:

;-1490         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-1491         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-1492         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-1493         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-1494         getLine();

 call getLine

;-1495         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-1496         getTokeType();//getCode in SymbolUpper,

 call getTokeType

;-1497                       //set TokeType,isLabel by getName


;-1498         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse374

;-1499             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse375

;-1500               if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse376
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-1501                 storeLabel();

.parse376:
 call storeLabel

;-1502                 InputPtr++;//remove :

 inc  word[InputPtr]

;-1503                 getTokeType();

 call getTokeType

;-1504             }


;-1505         }

.parse375:

;-1506         if (TokeType == ALNUME) {

.parse374:
 mov al, [TokeType]
 cmp al, 3
 jne .parse377

;-1507             lookCode();// and OpCodePtr

 call lookCode

;-1508             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse378
 call process

;-1509             else getVariable();

 jmp .parse379
.parse378:
 call getVariable

;-1510             skipRest();

.parse379:
 call skipRest

;-1511         }


;-1512         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp .parse380
.parse377:
 mov al, [TokeType]
 cmp al, 3
 jle .parse381
 push parse_0
 call error1
 add  sp, 2

;-1513         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp .parse382
.parse381:
 mov al, [TokeType]
 cmp al, 1
 jne .parse383
 push parse_1
 call error1
 add  sp, 2

;-1514         printLine();

.parse383:
.parse382:
.parse380:
 call printLine

;-1515     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse384
 jmp .parse373
.parse384:

;-1516 }


;-1517 


;-1518 int main() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0
ENDP

main: PROC

;-1519     getarg();

 call getarg

;-1520     parse();

 call parse

;-1521     fixJmpMain();

 call fixJmpMain

;-1522     epilog();

 call epilog

;-1523     end1();

 call end1

;-1524 }

 ret
ENDP
 
; missing functions: 
; Number of unresolved CALLs :    0 All FUNCTIONs in place
 
;   # type sign width  adr used name   list of global variables

;    1 arr sign byte     1    2 Version1[9]
;    2 def unsg byte     3    - SYMBOLMAX=31
;    3 arr sign byte     4   14 Symbol[31]
;    4 arr sign byte     5   36 SymbolUpper[31]
;    5 arr sign byte     6    3 ProcName[31]
;    6 var sign byte     7    6 isInProc
;    7 var unsg word     8   25 SymbolInt
;    8 var unsg dwrd     9 NULL SymbolLong
;    9 def unsg byte    10    - INPUTBUFMAX=255
;   10 arr sign byte    11    4 InputBuf[255]
;   11 ptr unsg byte    12   28 InputPtr
;   12 arr sign byte    13    5 namein[67]
;   13 arr sign byte    14    6 namelst[67]
;   14 arr sign byte    15    6 namebin[67]
;   15 var sign word    16    4 asm_fd
;   16 var sign word    17    3 lst_fd
;   17 var sign word    18    3 bin_fd
;   18 var sign word    19    6 DOS_ERR
;   19 var sign word    20    5 ErrorCount
;   20 var sign word    21    4 DOS_NoBytes
;   21 var sign byte    22    5 DOS_ByteRead
;   22 var unsg word    24    8 PC
;   23 var unsg word    25    5 Origin
;   24 var unsg word    26    6 AbsoluteLab
;   25 var unsg word    27    2 PCStart
;   26 var sign byte    28    3 isLabel
;   27 def unsg byte    29    - DIGIT=1
;   28 def unsg byte    30    - LETTERE=2
;   29 def unsg byte    31    - ALNUME=3
;   30 def unsg byte    32    - NOALNUME=4
;   31 var sign byte    33   28 TokeType
;   32 def unsg byte    34    - BYTE=1
;   33 def unsg byte    35    - WORD=2
;   34 def unsg byte    36    - DWORD=3
;   35 def unsg byte    37    - SEGREG=4
;   36 def unsg byte    38    - IMM=1
;   37 def unsg byte    39    - REG=2
;   38 def unsg byte    40    - ADR=3
;   39 def unsg byte    41    - MEM=4
;   40 var sign byte    42   29 Op
;   41 var sign byte    43   32 Op2
;   42 var sign byte    44   34 CodeType
;   43 var sign byte    45   30 Code1
;   44 var sign byte    46    2 Code2
;   45 var sign byte    47    1 Code3
;   46 var sign byte    48   19 R2No
;   47 var sign byte    49   17 R1No
;   48 var sign byte    50   18 R2Type
;   49 var sign byte    51   15 R1Type
;   50 var sign byte    52   14 OpSize
;   51 var sign byte    53    9 wflag
;   52 var sign byte    54    3 dflag
;   53 var sign byte    55    8 sflag
;   54 var sign byte    56   15 rm
;   55 var sign byte    57    5 isDirect
;   56 var sign word    58   56 disp
;   57 var unsg word    59   14 imme
;   58 def unsg byte    61    - OPMAXLEN=5
;   59 arr sign byte    62    2 OpPos[5]
;   60 var sign word    63    6 OpPrintIndex
;   61 ptr sign byte    64   17 OpCodePtr
;   62 var sign byte    65    5 PrintRA
;   63 def unsg byte    67    - LABELNAMESMAX=5969
;   64 arr sign byte    68    3 LabelNames[6000]
;   65 ptr sign byte    69    7 LabelNamePtr
;   66 ptr sign byte    70    2 tmpLabelNamePtr
;   67 def unsg byte    72    - LABELADRMAX=600
;   68 arr unsg word    73    8 LabelAddr[600]
;   69 var sign word    74   10 LabelMaxIx
;   70 var sign word    75    3 tmpLabelMaxIx
;   71 var sign word    76   13 LabelIx
;   72 def unsg byte    78    - JMPNAMESMAX=3969
;   73 arr sign byte    79    3 JmpNames[4000]
;   74 ptr sign byte    80    7 JmpNamePtr
;   75 ptr sign byte    81    2 tmpJmpNamePtr
;   76 def unsg byte    83    - JMPMAX=200
;   77 arr unsg word    84    2 JmpAddr[200]
;   78 var sign word    85   10 JmpMaxIx
;   79 var sign word    86    3 tmpJmpMaxIx
;   80 def unsg byte    88    - FILEBINMAX=17000
;   81 arr sign byte    89    5 FileBin[17000]
;   82 var unsg word    90    6 BinLen
;   83 ptr sign byte    92    1 arglen
;   84 ptr sign byte    93    4 argv
;   85 var sign byte   451    1 I_START
;   86 arr sign byte   454 NULL I_PUSHA[8125]
;   87 arr sign byte   455 NULL I_NOP[24260]
;   88 arr sign byte   456 NULL I_CWDE[9734]
;   89 arr sign byte   457 NULL I_CDQ[1931]
;   90 arr sign byte   458 NULL I_PUSHF[35622]
;   91 arr sign byte   459 NULL I_SAHF[599]
;   92 arr sign byte   460 NULL I_MOVSB[53495]
;   93 arr sign byte   461 NULL I_CMPSB[54007]
;   94 arr sign byte   462 NULL I_STOSB[37]
;   95 arr sign byte   463 NULL I_LODSB[33600]
;   96 arr sign byte   464 NULL I_SCASB[8418]
;   97 arr sign byte   465 NULL I_LEAVE[53259]
;   98 arr sign byte   466 NULL I_INTO[12917]
;   99 arr sign byte   467 NULL I_XLAT[35622]
;  100 arr sign byte   468 NULL I_REPNE[2119]
;  101 arr sign byte   469 NULL I_REPE[18057]
;  102 arr sign byte   470 NULL I_HLT[9982]
;  103 arr sign byte   471 NULL I_STC[18315]
;  104 arr sign byte   472 NULL I_STI[9734]
;  105 arr sign byte   473 NULL I_STD[32643]
;  106 arr sign byte   475 NULL I_INC[10]
;  107 arr sign byte   476 NULL I_DEC[1397]
;  108 arr sign byte   477 NULL I_NOT[18119]
;  109 arr sign byte   478 NULL I_NEG[65534]
;  110 arr sign byte   479 NULL I_MUL[33791]
;  111 arr sign byte   480 NULL I_IMUL[65150]
;  112 arr sign byte   481 NULL I_DIV[30207]
;  113 arr sign byte   482 NULL I_IDIV[15642]
;  114 arr sign byte   484 NULL I_LES[65535]
;  115 arr sign byte   485 NULL I_LDS[5493]
;  116 arr sign byte   486 NULL I_LEA[33574]
;  117 arr sign byte   487 NULL I_LSS[1151]
;  118 arr sign byte   488 NULL I_LFS[29696]
;  119 arr sign byte   489 NULL I_LGS[35593]
;  120 arr sign byte   491 NULL I_ADD[2630]
;  121 arr sign byte   492 NULL I_OR[14630]
;  122 arr sign byte   493 NULL I_ADC[1095]
;  123 arr sign byte   494 NULL I_SBB[26997]
;  124 arr sign byte   495 NULL I_AND[49203]
;  125 arr sign byte   496 NULL I_SUB[52169]
;  126 arr sign byte   497 NULL I_XOR[33680]
;  127 arr sign byte   498 NULL I_CMP[65150]
;  128 arr sign byte   499 NULL I_TEST[29729]
;  129 arr sign byte   501 NULL I_MOV[33618]
;  130 arr sign byte   502 NULL I_MOVSX[65150]
;  131 arr sign byte   503 NULL I_MOVZX[29731]
;  132 arr sign byte   505 NULL I_JO[33612]
;  133 arr sign byte   506 NULL I_JNO[65150]
;  134 arr sign byte   507 NULL I_JB[29732]
;  135 arr sign byte   508 NULL I_JNB[33606]
;  136 arr sign byte   509 NULL I_JAE[65150]
;  137 arr sign byte   510 NULL I_JE[29734]
;  138 arr sign byte   511 NULL I_JNE[33600]
;  139 arr sign byte   512 NULL I_JBE[65150]
;  140 arr sign byte   513 NULL I_JA[29730]
;  141 arr sign byte   514 NULL I_JS[33594]
;  142 arr sign byte   515 NULL I_JNS[65150]
;  143 arr sign byte   516 NULL I_JP[29737]
;  144 arr sign byte   517 NULL I_JNP[33588]
;  145 arr sign byte   518 NULL I_JL[65150]
;  146 arr sign byte   519 NULL I_JNL[29736]
;  147 arr sign byte   520 NULL I_JLE[33582]
;  148 arr sign byte   521 NULL I_JG[65150]
;  149 arr sign byte   523 NULL I_JMP[29733]
;  150 arr sign byte   524 NULL I_CALL[15656]
;  151 arr sign byte   526 NULL I_RET[33]
;  152 arr sign byte   527 NULL I_RETF[9076]
;  153 arr sign byte   529 NULL I_PUSH[9021]
;  154 arr sign byte   530 NULL I_POP[29696]
;  155 arr sign byte   532 NULL I_ROL[15646]
;  156 arr sign byte   533 NULL I_RCL[36]
;  157 arr sign byte   534 NULL I_SHL[6516]
;  158 arr sign byte   535 NULL I_SHR[9789]
;  159 arr sign byte   537 NULL I_INT[29696]
;  160 arr sign byte   539 NULL I_IN[15636]
;  161 arr sign byte   540 NULL I_INSB[34]
;  162 arr sign byte   541 NULL I_INSW[3956]
;  163 arr sign byte   542 NULL I_INSD[10557]
;  164 arr sign byte   543 NULL I_OUT[29696]
;  165 arr sign byte   544 NULL I_OUTSB[15626]
;  166 arr sign byte   545 NULL I_OUTSW[40]
;  167 arr sign byte   546 NULL I_OUTSD[1396]
;  168 arr sign byte   548 NULL I_XCHG[9533]
;  169 arr sign byte   550 NULL I_LOOPNZ[29952]
;  170 arr sign byte   551 NULL I_LOOPNE[33542]
;  171 arr sign byte   552 NULL I_LOOPZ[2686]
;  172 arr sign byte   553 NULL I_LOOPE[60176]
;  173 arr sign byte   554 NULL I_LOOP[33540]
;  174 arr sign byte   555 NULL I_JCXZ[2686]
;  175 arr sign byte   556 NULL I_JECXZ[29984]
;  176 arr sign byte   558 NULL I_ENTER[47255]
;  177 arr sign byte   560 NULL I_ORG[1]
;  178 arr sign byte   562 NULL I_SECTION[52169]
;  179 arr sign byte   563 NULL I_SEGMENT[21904]
;  180 arr sign byte   564 NULL I_ABSOLUTE[60555]
;  181 arr sign byte   565 NULL I_PROC[5816]
;  182 arr sign byte   566 NULL I_ENDP[39424]
;  183 arr sign byte   567 NULL I_DB[674]
;  184 arr sign byte   568 NULL I_DW[8125]
;  185 arr sign byte   569 NULL I_DD[51030]
;  186 arr sign byte   570 NULL I_RESB[65094]
;  187 arr sign byte   571 NULL I_RESW[0]
;  188 arr sign byte   572 NULL I_RESD[1678]
;  189 var sign byte   573 NULL I_END


;   # Calls Line Width  Name   list of functions

;    0    4   97   writetty
;    1    1   98   putch
;    2    8   99   cputs
;    3    6  101   DosInt
;    4    1  106   openR
;    5    2  107   creatR
;    6    3  108   fcloseR
;    7    5  109   exitR
;    8    2  110   readRL
;    9    2  112   fputcR
;   10    2  115   letterE
;   11    3  125   digit
;   12    1  130   alnumE
;   13    4  135   strlen
;   14   10  140   strcpy
;   15   35  146   eqstr
;   16    3  155   strcat1
;   17    2  159   toupper
;   18    1  166   testReg
;   19    7  209   prc
;   20    1  219   prscomment
;   21   38  227   prs
;   22    2  249   printhex4
;   23    3  254   printhex8a
;   24    3  259   printhex16
;   25    7  264   printIntU
;   26    1  274   printLine
;   27    2  297   epilog
;   28    2  345   end1
;   29   27  353   error1
;   30   13  360   errorexit
;   31    4  365   notfounderror
;   32 NULL  371   allowederror
;   33    3  372   addrerror
;   34    1  373   immeerror
;   35    7  374   implerror
;   36    4  375   indexerror
;   37    2  376   invaloperror
;   38    6  377   numbererror
;   39    1  378   regmemerror
;   40    3  379   reg16error
;   41    1  380   segregerror
;   42    5  381   syntaxerror
;   43 NULL  383   addrexit
;   44    3  384   dataexit
;   45 NULL  385   internexit
;   46    1  387   ifEOL
;   47    1  396   getLine
;   48    4  412   skipBlank
;   49    1  418   getDigit
;   50    1  430   getName
;   51    2  575   lookCode
;   52   38  591   genCode8
;   53    1  602   gen66h
;   54    9  604   genCode2
;   55   14  608   genCodeW
;   56   19  612   genCode16
;   57    1  616   genCode32
;   58   14  627   writeEA
;   59    4  670   genImmediate
;   60    2  677   setwflag
;   61    2  688   setsflag
;   62    2  698   checkConstSize
;   63    2  705   ChangeDirection
;   64   17  713   getTokeType
;   65   11  724   isToken
;   66    2  734   need
;   67    1  743   skipRest
;   68    2  749   checkOpL
;   69    5  758   searchLabel
;   70    4  771   getOp1
;   71    1  786   getIndReg1
;   72    1  794   getIndReg2
;   73    1  803   getMEM
;   74    2  830   getOpR
;   75    3  843   getOpL
;   76    1  850   get2Ops
;   77    4  855   check2Ops
;   78    3  865   storeJmp
;   79    2  876   storeLabel
;   80    1  889   genDB
;   81    1  910   getVariable
;   82    1  963   getCodeSize
;   83    1  973   getarg
;   84    2 1007   FixOneJmp
;   85    1 1024   fixJmp
;   86    1 1039   fixJmpMain
;   87    1 1049   process
;   88    1 1481   parse
;   89 NULL 1518   main

;    #  addr name   list of CALLs

;    0     0 writetty
;    1     9 writetty
;    2    18 putch
;    3    24 DosInt
;    4    31 DosInt
;    5    38 DosInt
;    6    45 DosInt
;    7    52 DosInt
;    8    59 DosInt
;    9    66 digit
;   10    72 letterE
;   11    80 strcpy
;   12    87 strlen
;   13    94 strlen
;   14   101 eqstr
;   15   107 eqstr
;   16   113 eqstr
;   17   119 eqstr
;   18   125 eqstr
;   19   131 eqstr
;   20   137 eqstr
;   21   143 eqstr
;   22   149 eqstr
;   23   155 eqstr
;   24   161 eqstr
;   25   167 eqstr
;   26   173 eqstr
;   27   179 eqstr
;   28   185 eqstr
;   29   191 eqstr
;   30   197 eqstr
;   31   203 eqstr
;   32   209 eqstr
;   33   215 eqstr
;   34   221 eqstr
;   35   227 eqstr
;   36   233 eqstr
;   37   239 eqstr
;   38   245 eqstr
;   39   251 eqstr
;   40   257 eqstr
;   41   263 eqstr
;   42   269 eqstr
;   43   275 eqstr
;   44   281 writetty
;   45   290 writetty
;   46   299 fputcR
;   47   306 prc
;   48   310 prc
;   49   314 prc
;   50   318 printhex4
;   51   328 printhex4
;   52   338 printhex8a
;   53   349 printhex8a
;   54   360 printIntU
;   55   370 prc
;   56   374 prs
;   57   378 printhex16
;   58   389 prs
;   59   393 prc
;   60   397 printhex8a
;   61   408 prs
;   62   412 prc
;   63   416 prscomment
;   64   427 prs
;   65   431 printIntU
;   66   441 prs
;   67   445 prs
;   68   449 prs
;   69   453 prs
;   70   457 prs
;   71   461 prs
;   72   465 printIntU
;   73   475 prs
;   74   479 prs
;   75   483 printIntU
;   76   493 fputcR
;   77   500 fcloseR
;   78   508 fcloseR
;   79   516 fcloseR
;   80   524 exitR
;   81   530 prs
;   82   534 prs
;   83   538 prs
;   84   542 prs
;   85   546 error1
;   86   553 epilog
;   87   560 end1
;   88   565 prs
;   89   569 prs
;   90   573 prs
;   91   577 error1
;   92   584 error1
;   93   591 error1
;   94   598 error1
;   95   605 error1
;   96   612 error1
;   97   619 error1
;   98   626 error1
;   99   633 error1
;  100   640 error1
;  101   647 error1
;  102   654 errorexit
;  103   664 errorexit
;  104   674 errorexit
;  105   684 readRL
;  106   691 errorexit
;  107   701 readRL
;  108   708 errorexit
;  109   718 errorexit
;  110   728 ifEOL
;  111   734 digit
;  112   740 alnumE
;  113   747 errorexit
;  114   757 strcpy
;  115   764 toupper
;  116   772 eqstr
;  117   778 errorexit
;  118   788 genCode8
;  119   797 genCode8
;  120   806 genCode8
;  121   815 genCode8
;  122   824 genCode8
;  123   833 genCode16
;  124   843 genCode16
;  125   853 genCode8
;  126   862 genCode8
;  127   871 genCode16
;  128   881 genCode32
;  129   891 genCode16
;  130   901 genCode8
;  131   910 gen66h
;  132   917 error1
;  133   924 skipBlank
;  134   934 digit
;  135   940 getDigit
;  136   949 letterE
;  137   957 getName
;  138   965 skipBlank
;  139   975 isToken
;  140   983 getTokeType
;  141   995 error1
;  142  1002 prs
;  143  1006 prc
;  144  1010 getTokeType
;  145  1022 error1
;  146  1029 implerror
;  147  1039 segregerror
;  148  1051 setwflag
;  149  1060 error1
;  150  1067 error1
;  151  1074 eqstr
;  152  1080 strlen
;  153  1087 testReg
;  154  1095 searchLabel
;  155  1107 indexerror
;  156  1118 indexerror
;  157  1129 indexerror
;  158  1140 indexerror
;  159  1151 getTokeType
;  160  1163 getOp1
;  161  1170 syntaxerror
;  162  1182 getIndReg2
;  163  1193 getIndReg1
;  164  1204 notfounderror
;  165  1218 isToken
;  166  1226 getTokeType
;  167  1238 numbererror
;  168  1250 isToken
;  169  1258 isToken
;  170  1266 errorexit
;  171  1276 getOp1
;  172  1283 isToken
;  173  1291 getMEM
;  174  1298 invaloperror
;  175  1311 error1
;  176  1318 getOpR
;  177  1325 getOpL
;  178  1332 need
;  179  1337 getOpR
;  180  1344 get2Ops
;  181  1352 addrerror
;  182  1362 invaloperror
;  183  1375 immeerror
;  184  1385 addrerror
;  185  1395 setwflag
;  186  1404 errorexit
;  187  1414 strcpy
;  188  1421 errorexit
;  189  1431 searchLabel
;  190  1443 error1
;  191  1450 errorexit
;  192  1460 strcpy
;  193  1467 errorexit
;  194  1477 getTokeType
;  195  1489 genCode8
;  196  1498 skipBlank
;  197  1508 isToken
;  198  1516 genCode8
;  199  1525 isToken
;  200  1533 storeLabel
;  201  1544 getTokeType
;  202  1556 lookCode
;  203  1565 dataexit
;  204  1574 dataexit
;  205  1583 getTokeType
;  206  1595 genCode8
;  207  1604 skipBlank
;  208  1614 isToken
;  209  1622 genCode8
;  210  1631 isToken
;  211  1639 getTokeType
;  212  1651 genCode16
;  213  1661 isToken
;  214  1669 getTokeType
;  215  1681 genCode16
;  216  1691 genCode16
;  217  1701 isToken
;  218  1709 getTokeType
;  219  1721 syntaxerror
;  220  1733 error1
;  221  1740 numbererror
;  222  1752 dataexit
;  223  1761 eqstr
;  224  1767 getTokeType
;  225  1779 eqstr
;  226  1785 getTokeType
;  227  1797 eqstr
;  228  1803 getTokeType
;  229  1815 cputs
;  230  1821 cputs
;  231  1827 exitR
;  232  1833 toupper
;  233  1841 strcpy
;  234  1848 strcat1
;  235  1856 strcpy
;  236  1863 strcat1
;  237  1871 strcpy
;  238  1878 strcat1
;  239  1886 openR
;  240  1892 cputs
;  241  1898 cputs
;  242  1904 exitR
;  243  1910 creatR
;  244  1917 cputs
;  245  1923 cputs
;  246  1929 exitR
;  247  1935 creatR
;  248  1942 cputs
;  249  1948 cputs
;  250  1954 exitR
;  251  1960 prs
;  252  1964 prs
;  253  1968 prs
;  254  1972 prs
;  255  1976 prs
;  256  1980 prs
;  257  1984 prs
;  258  1988 prs
;  259  1992 prs
;  260  1996 searchLabel
;  261  2008 notfounderror
;  262  2022 prs
;  263  2026 printhex16
;  264  2037 strcpy
;  265  2044 strlen
;  266  2051 FixOneJmp
;  267  2061 prs
;  268  2065 printIntU
;  269  2075 error1
;  270  2082 strcpy
;  271  2089 FixOneJmp
;  272  2099 prs
;  273  2103 printhex16
;  274  2114 getTokeType
;  275  2126 getCodeSize
;  276  2138 genCode8
;  277  2147 getOpL
;  278  2154 checkOpL
;  279  2163 genCode2
;  280  2172 genCode2
;  281  2181 getTokeType
;  282  2193 implerror
;  283  2203 genCodeW
;  284  2212 genCodeW
;  285  2221 writeEA
;  286  2229 check2Ops
;  287  2239 reg16error
;  288  2250 addrerror
;  289  2260 genCode8
;  290  2269 genCode8
;  291  2278 writeEA
;  292  2286 check2Ops
;  293  2296 notfounderror
;  294  2310 setsflag
;  295  2319 genCodeW
;  296  2328 genImmediate
;  297  2341 genCodeW
;  298  2350 writeEA
;  299  2358 genCode8
;  300  2367 genImmediate
;  301  2380 genCodeW
;  302  2389 writeEA
;  303  2397 genCodeW
;  304  2406 writeEA
;  305  2414 syntaxerror
;  306  2426 check2Ops
;  307  2436 notfounderror
;  308  2450 genCode2
;  309  2459 genImmediate
;  310  2472 genCodeW
;  311  2481 writeEA
;  312  2489 genImmediate
;  313  2502 regmemerror
;  314  2514 ChangeDirection
;  315  2530 reg16error
;  316  2541 genCode2
;  317  2550 writeEA
;  318  2558 genCodeW
;  319  2567 genCode16
;  320  2577 genCodeW
;  321  2586 genCode16
;  322  2596 genCodeW
;  323  2605 writeEA
;  324  2613 ChangeDirection
;  325  2629 genCodeW
;  326  2638 writeEA
;  327  2646 syntaxerror
;  328  2658 searchLabel
;  329  2670 checkConstSize
;  330  2685 genCode2
;  331  2694 genCode8
;  332  2703 genCode8
;  333  2712 genCode2
;  334  2721 genCode16
;  335  2731 genCode8
;  336  2740 genCode2
;  337  2749 storeJmp
;  338  2758 genCode16
;  339  2768 searchLabel
;  340  2780 checkConstSize
;  341  2795 genCode8
;  342  2804 genCode8
;  343  2813 genCode8
;  344  2822 genCode16
;  345  2832 genCode8
;  346  2841 genCode16
;  347  2851 genCode8
;  348  2860 storeJmp
;  349  2869 genCode16
;  350  2879 genCode8
;  351  2888 genCode16
;  352  2898 genCode8
;  353  2907 getOpL
;  354  2914 setsflag
;  355  2923 genCode2
;  356  2932 genCode8
;  357  2941 genCode16
;  358  2951 genCode8
;  359  2960 genCode16
;  360  2970 genCode8
;  361  2979 storeJmp
;  362  2988 genCode16
;  363  2998 error1
;  364  3005 genCode8
;  365  3014 genCode8
;  366  3023 checkOpL
;  367  3032 genCode8
;  368  3041 writeEA
;  369  3049 genCode8
;  370  3058 writeEA
;  371  3066 reg16error
;  372  3077 genCode2
;  373  3086 syntaxerror
;  374  3098 check2Ops
;  375  3108 genCodeW
;  376  3117 writeEA
;  377  3125 genCodeW
;  378  3134 writeEA
;  379  3142 genCode8
;  380  3151 genCodeW
;  381  3160 writeEA
;  382  3168 genCode8
;  383  3177 genCode8
;  384  3186 implerror
;  385  3196 implerror
;  386  3206 implerror
;  387  3216 genCode8
;  388  3225 getOp1
;  389  3232 genCode16
;  390  3242 numbererror
;  391  3254 need
;  392  3259 getOp1
;  393  3266 genCode8
;  394  3275 numbererror
;  395  3287 implerror
;  396  3297 implerror
;  397  3307 numbererror
;  398  3319 numbererror
;  399  3331 prs
;  400  3335 prs
;  401  3339 error1
;  402  3346 error1
;  403  3353 prs
;  404  3357 prs
;  405  3361 prs
;  406  3365 printIntU
;  407  3375 prs
;  408  3379 printIntU
;  409  3389 fixJmp
;  410  3396 genDB
;  411  3402 error1
;  412  3409 getLine
;  413  3417 getTokeType
;  414  3429 strcpy
;  415  3436 storeLabel
;  416  3447 getTokeType
;  417  3459 lookCode
;  418  3468 process
;  419  3476 getVariable
;  420  3488 skipRest
;  421  3497 error1
;  422  3504 error1
;  423  3511 printLine
;  424  3521 getarg
;  425  3528 parse
;  426  3534 fixJmpMain
;  427  3545 epilog
;  428  3552 end1
;Input: AS.C, List: AS.S,  Lines: 1525
;Glob. variables:  189 max.:  200
;Functions      :   90 max.:  300
;Calls          :  429 max.: 2000, NameField: 3557 max.:    65535
;Data (HeapEnd) :59154, resting stacksize:  6381
;Max. Const in 'testReg' :  658 max. 3000, free: 2342