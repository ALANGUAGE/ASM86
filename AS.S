;PLA compiler A.COM V0.9.6, Input: AS.C, Output: AS.S
org  256 
jmp main
;-1 char Version1[]="ASM.C V1.0.1";//Assembler like NASM

Version1 db "ASM.C V1.0.1",0
;-2 //todo: CS:with adr, not implemented: 14,15,16,41,51

;-3 #define SYMBOLMAX    31

;-4 char Symbol[SYMBOLMAX]; //next symbol to decode

section .bss
absolute 25000
Symbol resb 31
section .text
;-5 char SymbolUpper[SYMBOLMAX];//set toupper in getName

section .bss
absolute 25031
SymbolUpper resb 31
section .text
;-6 char ProcName[SYMBOLMAX];//name of actual proc

section .bss
absolute 25062
ProcName resb 31
section .text
;-7 char isPrint=1;         //print to screen on

isPrint db 1
;-8 char isInProc=0;        //is inside a procedure

isInProc db 0
;-9 unsigned int SymbolInt; //integer value set in getDigit

SymbolInt dw 0
;-10 #define INPUTBUFMAX 255

;-11 char InputBuf[INPUTBUFMAX];//filled in getLine

section .bss
absolute 25093
InputBuf resb 255
section .text
;-12 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0
;-13 char namein [67];       //input file name  .S

section .bss
absolute 25348
namein resb 67
section .text
;-14 char namelst[67];       //list file name   .LST

section .bss
absolute 25415
namelst resb 67
section .text
;-15 char namebin[67];       //output file name .COM

section .bss
absolute 25482
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
;-46 char R2No;              //0 - 7 AL, CL, ...  set in testReg()

R2No db 0
;-47 char R1No;              //temp for 1. register

R1No db 0
;-48 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG

R2Type db 0
;-49 char R1Type;            //temp for 1. register

R1Type db 0
;-50 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0
;-51 char wflag;             //wordflag: 0=byte, 1=word/dword

wflag db 0
;-52 char dflag;             //directionflag: 1=to reg MOV,ALU

dflag db 0
;-53 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3

sflag db 0
;-54 char rm;                //combination of index and base reg

rm db 0
;-55 char isDirect;          //set in process and getMeM, need in WriteEA

isDirect db 0
;-56 int disp;               //displacement      0-8 bytes

disp dw 0
;-57 unsigned int imme;      //immediate         0-8 bytes

imme dw 0
;-58 

;-59 #define OPMAXLEN 5

;-60 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 25549
OpPos resb 5
section .text
;-61 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0
;-62 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0
;-63 char PrintRA;           //print * for forward relocative jmp

PrintRA db 0
;-64 

;-65 #define LABELNAMESMAX 5969//next number - SYMBOLMAX

;-66 char LabelNames[6000];  //space for names of all labels

section .bss
absolute 25554
LabelNames resb 6000
section .text
;-67 char *LabelNamePtr;     //first free position

LabelNamePtr dw 0
;-68 char *tmpLabelNamePtr;  //set after PROC to LabelNamePtr

tmpLabelNamePtr dw 0
;-69 

;-70 #define LABELADRMAX 600

;-71 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 31554
LabelAddr resw 600
section .text
;-72 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0
;-73 int tmpLabelMaxIx;      //set after PROC to LabelMaxIx

tmpLabelMaxIx dw 0
;-74 int LabelIx;            //actual # of just searched label

LabelIx dw 0
;-75 

;-76 #define JMPNAMESMAX 3969//next number - SYMBOLMAX

;-77 char JmpNames[4000];    //space for names of jmp, call

section .bss
absolute 32754
JmpNames resb 4000
section .text
;-78 char *JmpNamePtr;       //first free position

JmpNamePtr dw 0
;-79 char *tmpJmpNamePtr;    //set after PROC to JmpNamePtr

tmpJmpNamePtr dw 0
;-80 

;-81 #define JMPMAX 200      //max. jmp and call

;-82 unsigned int JmpAddr[JMPMAX];//addr to be fixed

section .bss
absolute 36754
JmpAddr resw 200
section .text
;-83 int JmpMaxIx=0;         //actual # of jmp, call. 1 to JMPMAX-1

JmpMaxIx dw 0
;-84 int tmpJmpMaxIx=0;      //set after PROC to JmpMaxIx

tmpJmpMaxIx dw 0
;-85 

;-86 #define FILEBINMAX 25000

;-87 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 37154
FileBin resb 25000
section .text
;-88 unsigned int BinLen=0;  //length of binary file

BinLen dw 0
;-89 

;-90 char *arglen=0x80;      // for main only

arglen dw 128
;-91 char *argv=0x82;        // for main only

argv dw 130
;-92 

;-93 int writetty()     {//char in AL


writetty: PROC
;-94     ah=0x0E;

 mov  ah, 14
;-95     asm push bx

 push bx
;-96     bx=0;     //page in BH

 mov  bx, 0
;-97     inth 0x10;

 int  16
;-98     asm pop bx

 pop bx
;-99 }

;-100 int putch(char c)  {

 ret
ENDP

putch: PROC
;-101     if (c==10)  {// LF

;Function : putch, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-102         al=13;   // CR, write CR first and then LF

 mov  al, 13
;-103         writetty();

 call writetty
;-104     }

;-105     al=c;

.putch1:
 mov  al, [bp+4]
;-106     writetty();

 call writetty
;-107 }

;-108 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-109     char c;

;-110     while(*s) {

;Function : cputs, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign byte c = bp-2;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-111         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-112         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-113         s++;

 inc  word[bp+4]
;-114     }

;-115 }

 jmp .cputs2
.cputs3:
;-116 int mkneg(int n)   {

 LEAVE
 ret
ENDP

mkneg: PROC
;-117     n; // ax=n;

;Function : mkneg, Number local Var: 1
; # type sign width local variables
;300 var sign word n = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
;-118     asm neg ax

 neg ax
;-119 }

;-120 

;-121 int DosInt() {

 LEAVE
 ret
ENDP

DosInt: PROC
;-122     inth 0x21;

 int  33
;-123     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-124     DOS_ERR++;

 inc  word[DOS_ERR]
;-125 }

;-126 int openR (char *s) {

 ret
ENDP

openR: PROC
;-127     dx=s;

;Function : openR, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
;-128     ax=0x3D02;

 mov  ax, 15618
;-129     DosInt();

 call DosInt
;-130 }

;-131 int creatR(char *s) {

 LEAVE
 ret
ENDP

creatR: PROC
;-132     dx=s;

;Function : creatR, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
;-133     cx=0;

 mov  cx, 0
;-134     ax=0x3C00;

 mov  ax, 15360
;-135     DosInt();

 call DosInt
;-136 }

;-137 int fcloseR(int fd) {

 LEAVE
 ret
ENDP

fcloseR: PROC
;-138     bx=fd;

;Function : fcloseR, Number local Var: 1
; # type sign width local variables
;300 var sign word fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
;-139     ax=0x3E00;

 mov  ax, 15872
;-140     DosInt();

 call DosInt
;-141 }

;-142 int exitR  (char c) {

 LEAVE
 ret
ENDP

exitR: PROC
;-143     ah=0x4C;

;Function : exitR, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov  ah, 76
;-144     al=c;

 mov  al, [bp+4]
;-145     DosInt();

 call DosInt
;-146 }

;-147 int readRL(char *s, int fd, int len){

 LEAVE
 ret
ENDP

readRL: PROC
;-148     dx=s;

;Function : readRL, Number local Var: 3
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign word fd = bp+6
;302 var sign word len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
;-149     cx=len;

 mov  cx, [bp+8]
;-150     bx=fd;

 mov  bx, [bp+6]
;-151     ax=0x3F00;

 mov  ax, 16128
;-152     DosInt();

 call DosInt
;-153 }

;-154 int fputcR(char *n, int fd) {

 LEAVE
 ret
ENDP

fputcR: PROC
;-155     __asm{lea dx, [bp+4]}; /* = *n */

;Function : fputcR, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte n = bp+4
;301 var sign word fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]
;-156     cx=1;

 mov  cx, 1
;-157     bx=fd;

 mov  bx, [bp+6]
;-158     ax=0x4000;

 mov  ax, 16384
;-159     DosInt();

 call DosInt
;-160 }

;-161 

;-162 int letterE(char c) {

 LEAVE
 ret
ENDP

letterE: PROC
;-163   if (c=='_') return 1;

;Function : letterE, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE4
 mov ax, 1
 jmp .retnletterE
;-164   if (c=='.') return 1;

.letterE4:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE5
 mov ax, 1
 jmp .retnletterE
;-165   if (c=='?') return 1;

.letterE5:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE6
 mov ax, 1
 jmp .retnletterE
;-166   if (c=='$') return 1;

.letterE6:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE7
 mov ax, 1
 jmp .retnletterE
;-167   if (c> 'z') return 0;

.letterE7:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE8
 mov ax, 0
 jmp .retnletterE
;-168   if (c< '@') return 0; // at included

.letterE8:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE9
 mov ax, 0
 jmp .retnletterE
;-169   if (c> 'Z') { if (c< 'a') return 0; }

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
;-170   return 1;

.letterE10:
 mov ax, 1
 jmp .retnletterE
;-171 }

;-172 int digit(char c){

 .retnletterE:
 LEAVE
 ret
ENDP

digit: PROC
;-173     if(c<'0') return 0;

;Function : digit, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit12
 mov ax, 0
 jmp .retndigit
;-174     if(c>'9') return 0;

.digit12:
 mov al, [bp+4]
 cmp al, 57
 jle .digit13
 mov ax, 0
 jmp .retndigit
;-175     return 1;

.digit13:
 mov ax, 1
 jmp .retndigit
;-176 }

;-177 int alnumE(char c) {

 .retndigit:
 LEAVE
 ret
ENDP

alnumE: PROC
;-178   if (digit(c)) return 1;

;Function : alnumE, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
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
;-179   if (letterE(c)) return 1;

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
;-180   return 0;

.alnumE15:
 mov ax, 0
 jmp .retnalnumE
;-181 }

;-182 int strlen(char *s) { int c;

 .retnalnumE:
 LEAVE
 ret
ENDP

strlen: PROC
;-183     c=0;

;Function : strlen, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 var sign word c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-184     while (*s!=0) {s++; c++;}

.strlen16:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen17
 inc  word[bp+4]
 inc  word[bp-2]
;-185     return c;

 jmp .strlen16
.strlen17:
 mov ax, [bp-2]
 jmp .retnstrlen
;-186     }

;-187 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-188     do { *s=*t; s++; t++; }

;Function : strcpy, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 ptr sign byte t = bp+6;
 ENTER  0,0
.strcpy18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]
;-189     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy19
 jmp .strcpy18
.strcpy19:
;-190     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-191     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-192     }

;-193 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-194     while(*p) {

;Function : eqstr, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte p = bp+4
;301 ptr sign byte q = bp+6;
 ENTER  0,0
.eqstr20:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr21
;-195         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr22
 mov ax, 0
 jmp .retneqstr
;-196             p++;

.eqstr22:
 inc  word[bp+4]
;-197             q++;

 inc  word[bp+6]
;-198             }

;-199     if(*q) return 0;

 jmp .eqstr20
.eqstr21:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr23
 mov ax, 0
 jmp .retneqstr
;-200     return 1;

.eqstr23:
 mov ax, 1
 jmp .retneqstr
;-201     }

;-202 int strcat1(char *s, char *t) {

 .retneqstr:
 LEAVE
 ret
ENDP

strcat1: PROC
;-203     while (*s != 0) s++;

;Function : strcat1, Number local Var: 2
; # type sign width local variables
;300 ptr sign byte s = bp+4
;301 ptr sign byte t = bp+6;
 ENTER  0,0
.strcat124:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat125
 inc  word[bp+4]
;-204     strcpy(s, t);

 jmp .strcat124
.strcat125:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-205     }

;-206 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-207     while(*s) {

;Function : toupper, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
.toupper26:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper27
;-208         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-209             s++;

.toupper29:
.toupper28:
 inc  word[bp+4]
;-210               }

;-211     }

 jmp .toupper26
.toupper27:
;-212 

;-213 int testReg() {

 LEAVE
 ret
ENDP

testReg: PROC
;-214 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD

;-215   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al
;-216   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg30
 mov ax, 0
 jmp .retntestReg
;-217   if (strlen(Symbol) > 3) return 0;

.testReg30:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg31
 mov ax, 0
 jmp .retntestReg
;-218   R2Type=BYTE;

.testReg31:
 mov ax, 1
 mov byte [R2Type], al
;-219   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg32
 mov ax, 0
 jmp .retntestReg
;-220   if (eqstr(SymbolUpper, "CL")) return 1;

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
;-221   if (eqstr(SymbolUpper, "DL")) return 2;

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
;-222   if (eqstr(SymbolUpper, "BL")) return 3;

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
;-223   if (eqstr(SymbolUpper, "AH")) return 4;

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
;-224   if (eqstr(SymbolUpper, "CH")) return 5;

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
;-225   if (eqstr(SymbolUpper, "DH")) return 6;

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
;-226   if (eqstr(SymbolUpper, "BH")) return 7;

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
;-227   R2Type=WORD;

.testReg39:
 mov ax, 2
 mov byte [R2Type], al
;-228   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg40
 mov ax, 0
 jmp .retntestReg
;-229   if (eqstr(SymbolUpper, "CX")) return 1;

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
;-230   if (eqstr(SymbolUpper, "DX")) return 2;

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
;-231   if (eqstr(SymbolUpper, "BX")) return 3;

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
;-232   if (eqstr(SymbolUpper, "SP")) return 4;

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
;-233   if (eqstr(SymbolUpper, "BP")) return 5;

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
;-234   if (eqstr(SymbolUpper, "SI")) return 6;

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
;-235   if (eqstr(SymbolUpper, "DI")) return 7;

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
;-236   R2Type=SEGREG;

.testReg47:
 mov ax, 4
 mov byte [R2Type], al
;-237   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg48
 mov ax, 0
 jmp .retntestReg
;-238   if (eqstr(SymbolUpper, "CS")) return 1;

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
;-239   if (eqstr(SymbolUpper, "SS")) return 2;

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
;-240   if (eqstr(SymbolUpper, "DS")) return 3;

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
;-241   if (eqstr(SymbolUpper, "FS")) return 4;

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
;-242   if (eqstr(SymbolUpper, "GS")) return 5;

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
;-243   R2Type=DWORD;

.testReg53:
 mov ax, 3
 mov byte [R2Type], al
;-244   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg54
 mov ax, 0
 jmp .retntestReg
;-245   if (eqstr(SymbolUpper, "ECX"))return 1;

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
;-246   if (eqstr(SymbolUpper, "EDX"))return 2;

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
;-247   if (eqstr(SymbolUpper, "EBX"))return 3;

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
;-248   if (eqstr(SymbolUpper, "ESP"))return 4;

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
;-249   if (eqstr(SymbolUpper, "EBP"))return 5;

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
;-250   if (eqstr(SymbolUpper, "ESI"))return 6;

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
;-251   if (eqstr(SymbolUpper, "EDI"))return 7;

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
;-252   R2Type=0; return 0;

.testReg61:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg
;-253 }

;-254 

;-255 int prc(unsigned char c) {

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
;-256     if (isPrint) {

;Function : prc, Number local Var: 1
; # type sign width local variables
;300 var unsg byte c = bp+4;
 ENTER  0,0
 mov al, [isPrint]
 or  al, al
 je .prc62
;-257         if (c==10) {

 mov al, [bp+4]
 cmp al, 10
 jne .prc63
;-258             ax=13;

 mov  ax, 13
;-259             writetty();

 call writetty
;-260         }

;-261         al=c;

.prc63:
 mov  al, [bp+4]
;-262         writetty();

 call writetty
;-263     }

;-264     fputcR(c, lst_fd);

.prc62:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-265 }

;-266 

;-267 int prscomment(unsigned char *s) {

 LEAVE
 ret
ENDP

prscomment: PROC
;-268     unsigned char c;

;-269     while (*s){

;Function : prscomment, Number local Var: 2
; # type sign width local variables
;300 ptr unsg byte s = bp+4
;301 var unsg byte c = bp-2;
 ENTER  2,0
.prscomment64:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment65
;-270         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-271         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-272         s++;

 inc  word[bp+4]
;-273     }

;-274 }

 jmp .prscomment64
.prscomment65:
;-275 int printstring(unsigned char *s) {

 LEAVE
 ret
ENDP

printstring: PROC
;-276     unsigned char c;

;-277     int com;

;-278     com=0;

;Function : printstring, Number local Var: 3
; # type sign width local variables
;300 ptr unsg byte s = bp+4
;301 var unsg byte c = bp-2
;302 var sign word com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax
;-279     while (*s) {

.printstring66:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .printstring67
;-280         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-281         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .printstring68
;-282             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .printstring69
 mov ax, 0
 mov [bp-4], ax
;-283                 else com=1;

 jmp .printstring70
.printstring69:
 mov ax, 1
 mov [bp-4], ax
;-284         }

.printstring70:
;-285         if (c==92) {

.printstring68:
 mov al, [bp-2]
 cmp al, 92
 jne .printstring71
;-286             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .printstring72
;-287                 s++;

 inc  word[bp+4]
;-288                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-289                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .printstring73
 mov ax, 10
 mov [bp-2], al
;-290                 if (c=='t') c= 9;

.printstring73:
 mov al, [bp-2]
 cmp al, 116
 jne .printstring74
 mov ax, 9
 mov [bp-2], al
;-291             }

.printstring74:
;-292         }

.printstring72:
;-293         prc(c);

.printstring71:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-294         s++;

 inc  word[bp+4]
;-295     }

;-296 }

 jmp .printstring66
.printstring67:
;-297 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-298     c += 48;

;Function : printhex4, Number local Var: 1
; # type sign width local variables
;300 var unsg byte c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48
;-299     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex475
 add  byte[bp+4], 7
;-300     prc(c);

.printhex475:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-301 }

;-302 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-303     unsigned char nib;

;-304     nib = c >> 4; printhex4(nib);

;Function : printhex8, Number local Var: 2
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 var unsg byte nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-305     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-306 }

;-307 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-308     unsigned int half;

;-309     half = i >>  8; printhex8(half);

;Function : printhex16, Number local Var: 2
; # type sign width local variables
;300 var unsg word i = bp+4
;301 var unsg word half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-310     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-311 }

;-312 int printunsigned(unsigned int n) {

 LEAVE
 ret
ENDP

printunsigned: PROC
;-313     unsigned int e;

;-314     if (n >= 10) {

;Function : printunsigned, Number local Var: 2
; # type sign width local variables
;300 var unsg word n = bp+4
;301 var unsg word e = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printunsigned76
;-315         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-316         printunsigned(e);

 push word [bp-2]
 call printunsigned
 add  sp, 2
;-317     }

;-318     n = n % 10; //unsigned mod

.printunsigned76:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-319     n += '0';

 add  word[bp+4], 48
;-320     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2
;-321 }

;-322 int printLine() {

 LEAVE
 ret
ENDP

printLine: PROC
;-323     unsigned int i; char c;

;-324     printstring("\n");

;Function : printLine, Number local Var: 2
; # type sign width local variables
;300 var unsg word i = bp-2
;301 var sign byte c = bp-4;
 ENTER  4,0
 push printLine_0
 call printstring
 add  sp, 2
;-325     i=PCStart + Origin;

 mov ax, [PCStart]
 add ax, [Origin]
 mov [bp-2], ax
;-326     printhex16(i);

 push word [bp-2]
 call printhex16
 add  sp, 2
;-327     if (OpPrintIndex == 0) printstring("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine77
 push printLine_1
 call printstring
 add  sp, 2
;-328     else {

 jmp .printLine78
.printLine77:
;-329 //        prc(' ');

;-330         i=0;

 mov ax, 0
 mov [bp-2], ax
;-331         do {

.printLine79:
;-332             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al
;-333             prc(' ');

 push 32
 call prc
 add  sp, 2
;-334             printhex8(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-335             i++;

 inc  word[bp-2]
;-336         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine80
 jmp .printLine79
.printLine80:
;-337         while (i < OPMAXLEN) {// fill rest with blank

.printLine81:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine82
;-338             printstring("   ");

 push printLine_2
 call printstring
 add  sp, 2
;-339             i++;

 inc  word[bp-2]
;-340         }

;-341     }

 jmp .printLine81
.printLine82:
;-342     prc(PrintRA);

.printLine78:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-343     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2
;-344 }

;-345 

;-346 int epilog() {

 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

epilog: PROC
;-347     unsigned int i; int j; char c;

;-348     isPrint=1;

;Function : epilog, Number local Var: 3
; # type sign width local variables
;300 var unsg word i = bp-2
;301 var sign word j = bp-4
;302 var sign byte c = bp-6;
 ENTER  6,0
 mov ax, 1
 mov byte [isPrint], al
;-349     printstring("Errors:");

 push epilog_0
 call printstring
 add  sp, 2
;-350     printunsigned(ErrorCount);

 push word [ErrorCount]
 call printunsigned
 add  sp, 2
;-351     if (ErrorCount) printstring("\n****** ERRORS *** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog83
 push epilog_1
 call printstring
 add  sp, 2
;-352     printstring("\nOutput: ");

.epilog83:
 push epilog_2
 call printstring
 add  sp, 2
;-353     printstring(namelst);

 lea  ax, [namelst]
 push ax
 call printstring
 add  sp, 2
;-354     if (ErrorCount == 0) {

 mov ax, [ErrorCount]
 cmp ax, 0
 jne .epilog84
;-355         printstring(", ");

 push epilog_3
 call printstring
 add  sp, 2
;-356         printstring(namebin);

 lea  ax, [namebin]
 push ax
 call printstring
 add  sp, 2
;-357         printstring("= ");

 push epilog_4
 call printstring
 add  sp, 2
;-358         printunsigned(BinLen);

 push word [BinLen]
 call printunsigned
 add  sp, 2
;-359         printstring(" bytes.");

 push epilog_5
 call printstring
 add  sp, 2
;-360         bin_fd=creatR(namebin);

 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax
;-361         if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .epilog85
;-362             cputs("can not create COM file: ");

 push epilog_6
 call cputs
 add  sp, 2
;-363             cputs(namebin);

 lea  ax, [namebin]
 push ax
 call cputs
 add  sp, 2
;-364             exitR(2);

 push 2
 call exitR
 add  sp, 2
;-365         }

;-366         i=0;

.epilog85:
 mov ax, 0
 mov [bp-2], ax
;-367         do {

.epilog86:
;-368             c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-6], al
;-369             fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-370             i++;

 inc  word[bp-2]
;-371         } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog87
 jmp .epilog86
.epilog87:
;-372     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2
;-373     }

;-374 }

.epilog84:
;-375 

;-376 int end1(int n) {

 LEAVE
 ret
epilog_0 db "Errors:",0
epilog_1 db "\n****** ERRORS *** ",0
epilog_2 db "\nOutput: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
epilog_6 db "can not create COM file: ",0
ENDP

end1: PROC
;-377     fcloseR(asm_fd);

;Function : end1, Number local Var: 1
; # type sign width local variables
;300 var sign word n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2
;-378     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2
;-379     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2
;-380 }

;-381 

;-382 

;-383 int error1(char *s) {

 LEAVE
 ret
ENDP

error1: PROC
;-384     isPrint=1;

;Function : error1, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov ax, 1
 mov byte [isPrint], al
;-385     ErrorCount++;

 inc  word[ErrorCount]
;-386     printstring("\n\n******* next line ERROR: ");

 push error1_0
 call printstring
 add  sp, 2
;-387     printstring(s);

 push word [bp+4]
 call printstring
 add  sp, 2
;-388     printstring(", Symbol: ");

 push error1_1
 call printstring
 add  sp, 2
;-389     printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-390 }

;-391 int errorexit(char *s) {

 LEAVE
 ret
error1_0 db "\n\n******* next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC
;-392     error1(s);

;Function : errorexit, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2
;-393     epilog();

 call epilog
;-394     end1(1);

 push 1
 call end1
 add  sp, 2
;-395 }

;-396 int dataexit(){

 LEAVE
 ret
ENDP

dataexit: PROC
;-397     errorexit("DB,DW,DD or RESB,W,D expected");

 push dataexit_0
 call errorexit
 add  sp, 2
;-398 }

;-399 int notfounderror(){

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

notfounderror: PROC
;-400     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al
;-401     ErrorCount++;

 inc  word[ErrorCount]
;-402     printstring("\n\n******* ERROR: label not found: ");

 push notfounderror_0
 call printstring
 add  sp, 2
;-403     printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-404     printstring(" in proc ");

 push notfounderror_1
 call printstring
 add  sp, 2
;-405     printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-406     end1(1);

 push 1
 call end1
 add  sp, 2
;-407 

;-408 }

;-409 int addrerror()    {error1("address missing");}

 ret
notfounderror_0 db "\n\n******* ERROR: label not found: ",0
notfounderror_1 db " in proc ",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2
;-410 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2
;-411 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2
;-412 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2
;-413 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2
;-414 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2
;-415 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2
;-416 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2
;-417 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2
;-418 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2
;-419 

;-420 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
syntaxerror_0 db "syntax",0
ENDP

ifEOL: PROC
;-421   if (c == 10) return 1;//LF

;Function : ifEOL, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL88
 mov ax, 1
 jmp .retnifEOL
;-422   if (c == 13) {//CR

.ifEOL88:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL89
;-423     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-424     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL90
 push ifEOL_0
 call errorexit
 add  sp, 2
;-425     return 1;

.ifEOL90:
 mov ax, 1
 jmp .retnifEOL
;-426   }

;-427   return 0;

.ifEOL89:
 mov ax, 0
 jmp .retnifEOL
;-428 }

;-429 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL:
 LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC
;-430   unsigned int i;

;-431   InputPtr= &InputBuf;

;Function : getLine, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax
;-432   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-433   do {

.getLine91:
;-434     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-435     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine92
 push getLine_0
 call errorexit
 add  sp, 2
;-436     if (DOS_NoBytes == 0) return;

.getLine92:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine93
 jmp .retngetLine
;-437     *InputPtr = DOS_ByteRead;

.getLine93:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al
;-438     InputPtr++;

 inc  word[InputPtr]
;-439     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax
;-440     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine94
 push getLine_1
 call errorexit
 add  sp, 2
;-441   } while (ifEOL(DOS_ByteRead) == 0);

.getLine94:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne .getLine95
 jmp .getLine91
.getLine95:
;-442   InputPtr--;

 dec  word[InputPtr]
;-443   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-444 }

;-445 int skipBlank() {

 .retngetLine:
 LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC
;-446   skipblank1:

.skipblank1:
;-447     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank96
 inc  word[InputPtr]
 jmp .skipblank1
;-448     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank96:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank97
 inc  word[InputPtr]
 jmp .skipblank1
;-449 }

.skipBlank97:
;-450 

;-451 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC
;-452   unsigned int CastInt;

;-453   SymbolInt=0;

;Function : getDigit, Number local Var: 2
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 var unsg word CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax
;-454   do {

.getDigit98:
;-455     c-='0';

 sub  byte[bp+4], 48
;-456     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax
;-457     asm mov ax, 0

 mov ax, 0
;-458     CastInt=c; //cast b2w

 mov al, [bp+4]
 mov [bp-2], ax
;-459     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax
;-460     InputPtr++;

 inc  word[InputPtr]
;-461     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-462   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit99
 jmp .getDigit98
.getDigit99:
;-463 }

;-464 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel

 LEAVE
 ret
ENDP

getName: PROC
;-465   char *p; unsigned int i;

;-466   p = &Symbol;

;Function : getName, Number local Var: 3
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 ptr sign byte p = bp-2
;302 var unsg word i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax
;-467   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-468   p++;

 inc  word[bp-2]
;-469   while (alnumE(c)) {

.getName100:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName101
;-470     InputPtr++;

 inc  word[InputPtr]
;-471     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-472     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-473     p++;

 inc  word[bp-2]
;-474     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax
;-475     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName102
 push getName_0
 call errorexit
 add  sp, 2
;-476   }

.getName102:
;-477   if (c == ':') isLabel=1; else isLabel=0;

 jmp .getName100
.getName101:
 mov al, [bp+4]
 cmp al, 58
 jne .getName103
 mov ax, 1
 mov byte [isLabel], al
 jmp .getName104
.getName103:
 mov ax, 0
 mov byte [isLabel], al
;-478   p--;

.getName104:
 dec  word[bp-2]
;-479   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-480   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4
;-481   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2
;-482 }

;-483 

;-484 //OpName, 0, CodeType, Code1

;-485 //  1:   1 byte opcod

;-486 char T00[]={'P','U','S','H','A',0,1,0x60, 'P','O','P','A',0,    1,0x61};

 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
T00 db 80,85,83,72,65,0,1,96,80,79,80,65,0,1,97
;-487 char T01[]={'N','O','P',0,        1,0x90, 'C','B','W',0,        1,0x98};

T01 db 78,79,80,0,1,144,67,66,87,0,1,152
;-488 char T02[]={'C','W','D','E',0,    1,0x98, 'C','W','D',0,        1,0x99};

T02 db 67,87,68,69,0,1,152,67,87,68,0,1,153
;-489 char T03[]={'C','D','Q',0,        1,0x99, 'W','A','I','T',0,    1,0x9B};

T03 db 67,68,81,0,1,153,87,65,73,84,0,1,155
;-490 char T04[]={'P','U','S','H','F',0,1,0x9C, 'P','O','P','F',0,    1,0x9D};

T04 db 80,85,83,72,70,0,1,156,80,79,80,70,0,1,157
;-491 char T05[]={'S','A','H','F',0,    1,0x9E, 'L','A','H','F',0,    1,0x9F};

T05 db 83,65,72,70,0,1,158,76,65,72,70,0,1,159
;-492 char T06[]={'M','O','V','S','B',0,1,0xA4, 'M','O','V','S','W',0,1,0xA5};

T06 db 77,79,86,83,66,0,1,164,77,79,86,83,87,0,1,165
;-493 char T07[]={'C','M','P','S','B',0,1,0xA6, 'C','M','P','S','W',0,1,0xA7};

T07 db 67,77,80,83,66,0,1,166,67,77,80,83,87,0,1,167
;-494 char T08[]={'S','T','O','S','B',0,1,0xAA, 'S','T','O','S','W',0,1,0xAB};

T08 db 83,84,79,83,66,0,1,170,83,84,79,83,87,0,1,171
;-495 char T09[]={'L','O','D','S','B',0,1,0xAC, 'L','O','D','S','W',0,1,0xAD};

T09 db 76,79,68,83,66,0,1,172,76,79,68,83,87,0,1,173
;-496 char T10[]={'S','C','A','S','B',0,1,0xAE, 'S','C','A','S','W',0,1,0xAF};

T10 db 83,67,65,83,66,0,1,174,83,67,65,83,87,0,1,175
;-497 char T11[]={'L','E','A','V','E',0,1,0xC9, 'I','N','T','3',0,    1,0xCC};

T11 db 76,69,65,86,69,0,1,201,73,78,84,51,0,1,204
;-498 char T12[]={'I','N','T','O',0,    1,0xCE, 'I','R','E','T',0,    1,0xCF};

T12 db 73,78,84,79,0,1,206,73,82,69,84,0,1,207
;-499 char T13[]={'X','L','A','T',0,    1,0xD7, 'L','O','C','K',0,    1,0xF0};

T13 db 88,76,65,84,0,1,215,76,79,67,75,0,1,240
;-500 char T14[]={'R','E','P','N','E',0,1,0xF2, 'R','E','P','N','Z',0,1,0xF2};

T14 db 82,69,80,78,69,0,1,242,82,69,80,78,90,0,1,242
;-501 char T15[]={'R','E','P','E',0,    1,0xF3, 'R','E','P','Z',0,    1,0xF3};

T15 db 82,69,80,69,0,1,243,82,69,80,90,0,1,243
;-502 char T16[]={'H','L','T',0,        1,0xF4, 'C','L','C',0,        1,0xF8};

T16 db 72,76,84,0,1,244,67,76,67,0,1,248
;-503 char T17[]={'S','T','C',0,        1,0xF9, 'C','L','I',0,        1,0xFA};

T17 db 83,84,67,0,1,249,67,76,73,0,1,250
;-504 char T18[]={'S','T','I',0,        1,0xFB, 'C','L','D',0,        1,0xFC};

T18 db 83,84,73,0,1,251,67,76,68,0,1,252
;-505 char T19[]={'S','T','D',0,        1,0xFD};

T19 db 83,84,68,0,1,253
;-506 // 2: mem reg 16 bit

;-507 char T20[]={'I','N','C',0,        2, 0,   'D','E','C',0,        2, 1};

T20 db 73,78,67,0,2,0,68,69,67,0,2,1
;-508 char T21[]={'N','O','T',0,        2, 2,   'N','E','G',0,        2, 3};

T21 db 78,79,84,0,2,2,78,69,71,0,2,3
;-509 char T22[]={'M','U','L',0,        2, 4,   'I','M','U','L',0,    2, 5};

T22 db 77,85,76,0,2,4,73,77,85,76,0,2,5
;-510 //IMUL acc only

;-511 char T23[]={'D','I','V',0,        2, 6,   'I','D','I','V',0,    2, 7};

T23 db 68,73,86,0,2,6,73,68,73,86,0,2,7
;-512 //  3: les, lda, lea, lss, lfs, lgs

;-513 char T24[]={'L','E','S',0,        3,0xC4, 'L','D','S',0,        3,0xC5};

T24 db 76,69,83,0,3,196,76,68,83,0,3,197
;-514 char T25[]={'L','E','A',0,        3,0x8D, 'L','S','S',0,        3,0xB2};

T25 db 76,69,65,0,3,141,76,83,83,0,3,178
;-515 char T26[]={'L','F','S',0,        3,0xB4, 'L','G','S',0,        3,0xB5};

T26 db 76,70,83,0,3,180,76,71,83,0,3,181
;-516 //  4: acc,imm  reg,imm  index,reg

;-517 char T27[]={'A','D','D',0,        4, 0,   'O','R',0,            4, 1};

T27 db 65,68,68,0,4,0,79,82,0,4,1
;-518 char T28[]={'A','D','C',0,        4, 2,   'S','B','B',0,        4, 3};

T28 db 65,68,67,0,4,2,83,66,66,0,4,3
;-519 char T29[]={'A','N','D',0,        4, 4,   'S','U','B',0,        4, 5};

T29 db 65,78,68,0,4,4,83,85,66,0,4,5
;-520 char T30[]={'X','O','R',0,        4, 6,   'C','M','P',0,        4, 7};

T30 db 88,79,82,0,4,6,67,77,80,0,4,7
;-521 //  5: mov

;-522 char T31[]={'M','O','V',0,        5, 0};

T31 db 77,79,86,0,5,0
;-523 //  6: single byte relative jump

;-524 char T32[]={'J','O',0,            6, 0,    'J','N','O',0,       6, 1};

T32 db 74,79,0,6,0,74,78,79,0,6,1
;-525 char T33[]={'J','B',0,            6, 2,    'J','C',0,           6, 2};

T33 db 74,66,0,6,2,74,67,0,6,2
;-526 char T34[]={'J','N','B',0,        6, 3};

T34 db 74,78,66,0,6,3
;-527 char T35[]={'J','A','E',0,        6, 3,    'J','N','C',0,       6, 3};

T35 db 74,65,69,0,6,3,74,78,67,0,6,3
;-528 char T36[]={'J','E',0,            6, 4,    'J','Z',0,           6, 4};

T36 db 74,69,0,6,4,74,90,0,6,4
;-529 char T37[]={'J','N','E',0,        6, 5,    'J','N','Z',0,       6, 5};

T37 db 74,78,69,0,6,5,74,78,90,0,6,5
;-530 char T38[]={'J','B','E',0,        6, 6,    'J','N','A',0,       6, 6};

T38 db 74,66,69,0,6,6,74,78,65,0,6,6
;-531 char T39[]={'J','A',0,            6, 7,    'J','S',0,           6, 8};

T39 db 74,65,0,6,7,74,83,0,6,8
;-532 char T40[]={'J','N','S',0,        6, 9};

T40 db 74,78,83,0,6,9
;-533 char T41[]={'J','P',0,            6,10,    'J','P','E',0,       6,10};

T41 db 74,80,0,6,10,74,80,69,0,6,10
;-534 char T42[]={'J','N','P',0,        6,11,    'J','P','O',0,       6,11};

T42 db 74,78,80,0,6,11,74,80,79,0,6,11
;-535 char T43[]={'J','L',0,            6,12};

T43 db 74,76,0,6,12
;-536 char T44[]={'J','N','L',0,        6,13,    'J','G','E',0,       6,13};

T44 db 74,78,76,0,6,13,74,71,69,0,6,13
;-537 char T45[]={'J','L','E',0,        6,14,    'J','N','G',0,       6,14};

T45 db 74,76,69,0,6,14,74,78,71,0,6,14
;-538 char T46[]={'J','G',0,            6,15};

T46 db 74,71,0,6,15
;-539 //  7: jmp, call

;-540 char T47[]={'J','M','P',0,        7,0xE9,  'C','A','L','L',0,   7,0xE8};

T47 db 74,77,80,0,7,233,67,65,76,76,0,7,232
;-541 //  8: ret

;-542 char T48[]={'R','E','T',0,        8,0xC3,  'R','E','T','F',0,   8,0xCB};

T48 db 82,69,84,0,8,195,82,69,84,70,0,8,203
;-543 //  9: seg, r/m

;-544 char T49[]={'P','U','S','H',0,    9,0x50,  'P','O','P',0,       9,0x58};

T49 db 80,85,83,72,0,9,80,80,79,80,0,9,88
;-545 //  11: shift, rotates

;-546 char T50[]={'R','O','L',0,       11, 0,    'R','O','R',0,      11, 1};

T50 db 82,79,76,0,11,0,82,79,82,0,11,1
;-547 char T51[]={'R','C','L',0,       11, 2,    'R','C','R',0,      11, 3};

T51 db 82,67,76,0,11,2,82,67,82,0,11,3
;-548 char T52[]={'S','H','L',0,       11, 4,    'S','A','L',0,      11, 4};

T52 db 83,72,76,0,11,4,83,65,76,0,11,4
;-549 char T53[]={'S','H','R',0,       11, 5,    'S','A','R',0,      11, 7};

T53 db 83,72,82,0,11,5,83,65,82,0,11,7
;-550 //  12: int

;-551 char T54[]={'I','N','T',0,       12,0xCD};

T54 db 73,78,84,0,12,205
;-552 //  14: in/out                   not implemented

;-553 char T55[]={'I','N',0,           14,0xE4,  'I','N','S','B',0,  14,0x6C};

T55 db 73,78,0,14,228,73,78,83,66,0,14,108
;-554 char T56[]={'I','N','S','W',0,   14,0x6D,  'I','N','S','D',0,  14,0x6D};

T56 db 73,78,83,87,0,14,109,73,78,83,68,0,14,109
;-555 char T57[]={'O','U','T',0,       14,0xE6,  'O','U','T','B',0,  14,0x6E};

T57 db 79,85,84,0,14,230,79,85,84,66,0,14,110
;-556 char T58[]={'O','U','T','W',0,   14,0x6F,  'O','U','T','D',0,  14,0x6F};

T58 db 79,85,84,87,0,14,111,79,85,84,68,0,14,111
;-557 //  15: xch                      not implemented

;-558 char T59[]={'X','C','H','G',0,   15,0x86};

T59 db 88,67,72,71,0,15,134
;-559 //  16: loop, jcxz               not implemented

;-560 char T60 []={'L','O','O','P','N','Z',0,16,0xE0};

T60 db 76,79,79,80,78,90,0,16,224
;-561 char T60a[]={'L','O','O','P','N','E',0,16,0xE0};

T60a db 76,79,79,80,78,69,0,16,224
;-562 char T61[]={'L','O','O','P','Z',0,16,0xE1,'L','O','O','P','E',0,16,0xE1};

T61 db 76,79,79,80,90,0,16,225,76,79,79,80,69,0,16,225
;-563 char T62[]={'L','O','O','P',0,    16,0xE2};

T62 db 76,79,79,80,0,16,226
;-564 char T63[]={'J','C','X','Z',0,    16,0xE3,'J','E','C','X','Z',0,16,0xE3};

T63 db 74,67,88,90,0,16,227,74,69,67,88,90,0,16,227
;-565 //  30: other

;-566 char T64[]={'E','N','T','E','R',0,30,0};

T64 db 69,78,84,69,82,0,30,0
;-567 //                                not implemented

;-568 char T65[]={'T','E','S','T',0,    41,0xF6};

T65 db 84,69,83,84,0,41,246
;-569 char T66[]={'M','O','V','S','X',0,51,0xBE,'M','O','V','Z','X',0,51,0xB6};

T66 db 77,79,86,83,88,0,51,190,77,79,86,90,88,0,51,182
;-570 // 100: directives

;-571 char T67[]={'O','R','G',0,      101, 0};

T67 db 79,82,71,0,101,0
;-572 // section, segment .TEXT .DATA .BSS

;-573 char T68[]={'S','E','C','T','I','O','N',0,      102, 0};

T68 db 83,69,67,84,73,79,78,0,102,0
;-574 char T69[]={'S','E','G','M','E','N','T',0,      102, 0};

T69 db 83,69,71,77,69,78,84,0,102,0
;-575 char T70[]={'A','B','S','O','L','U','T','E',0,  110, 0};

T70 db 65,66,83,79,76,85,84,69,0,110,0
;-576 char T71[]={'P','R','O','C',0,    111, 0, 'E','N','D','P',0, 112, 0};

T71 db 80,82,79,67,0,111,0,69,78,68,80,0,112,0
;-577 char T72[]={'D','B',0,            200, 0, 'D','W',0,         201, 0};

T72 db 68,66,0,200,0,68,87,0,201,0
;-578 char T73[]={'D','D',0,            202, 0, 'R','E','S','B',0, 203, 0};

T73 db 68,68,0,202,0,82,69,83,66,0,203,0
;-579 char T74[]={'R','E','S','W',0,    204, 0, 'R','E','S','D',0, 205, 0};

T74 db 82,69,83,87,0,204,0,82,69,83,68,0,205,0
;-580 char TEND=0;// end of table char

TEND db 0
;-581 

;-582 int lookCode1() {//ret: CodeType, Code1


lookCode1: PROC
;-583     OpCodePtr= &T00;

 mov ax, T00
 mov word [OpCodePtr], ax
;-584     do  {

.lookCode1105:
;-585         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode1106
;-586             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1107:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1108
 inc  word[OpCodePtr]
;-587             OpCodePtr++;

 jmp .lookCode1107
.lookCode1108:
 inc  word[OpCodePtr]
;-588             CodeType = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al
;-589             OpCodePtr++;

 inc  word[OpCodePtr]
;-590             Code1    = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al
;-591             return;

 jmp .retnlookCode1
;-592         }

;-593         while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1106:
.lookCode1109:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1110
 inc  word[OpCodePtr]
;-594         OpCodePtr += 3;

 jmp .lookCode1109
.lookCode1110:
 add  word[OpCodePtr], 3
;-595 

;-596         } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1111
 jmp .lookCode1105
.lookCode1111:
;-597     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al
;-598 }

;-599 

;-600 

;-601 int genCode8(char c) {

 .retnlookCode1:
 ret
ENDP

genCode8: PROC
;-602 //set: BinLen++, OpPrintIndex++

;-603     FileBin[BinLen]=c;

;Function : genCode8, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
;-604     BinLen++;

 inc  word[BinLen]
;-605     PC++;

 inc  word[PC]
;-606     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 25000 ;unsigned : 0
 jb  .genCode8112
 push genCode8_0
 call errorexit
 add  sp, 2
;-607     if (OpPrintIndex < OPMAXLEN) {

.genCode8112:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8113
;-608         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
;-609         OpPrintIndex++;

 inc  word[OpPrintIndex]
;-610     }

;-611 }

.genCode8113:
;-612 int gen66h() {genCode8(0x66);

 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2
;-613 }

;-614 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC
;-615     c = c + d;

;Function : genCode2, Number local Var: 2
; # type sign width local variables
;300 var sign byte c = bp+4
;301 var sign byte d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al
;-616     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-617 }

;-618 int genCodeW(char c) {

 LEAVE
 ret
ENDP

genCodeW: PROC
;-619     c = c + wflag;

;Function : genCodeW, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al
;-620     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-621 }

;-622 int genCode16(unsigned int i) {

 LEAVE
 ret
ENDP

genCode16: PROC
;-623     genCode8(i); i=i >> 8;

;Function : genCode16, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax
;-624     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2
;-625 }

;-626 int genCode32(unsigned long L) {

 LEAVE
 ret
ENDP

genCode32: PROC
;-627     genCode16(L); L=L >>16;

;Function : genCode32, Number local Var: 1
; # type sign width local variables
;300 var unsg long L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax
;-628     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
;-629 }

;-630 int writeEA(char xxx) {//value for reg/operand

 LEAVE
 ret
ENDP

writeEA: PROC
;-631 //need: Op, Op2, disp, R1No, R2No, rm, isDirect

;-632 //mod-bits: mode76, reg/opcode543, r/m210

;-633 //Op: 0, IMM, REG, ADR, MEM

;-634     int disploc;

;-635     char len;

;-636     len=0;

;Function : writeEA, Number local Var: 3
; # type sign width local variables
;300 var sign byte xxx = bp+4
;301 var sign word disploc = bp-2
;302 var sign byte len = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-637     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al
;-638     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA114
;-639         xxx |= 0xC0;

 or  byte[bp+4], 192
;-640         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA115
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-641             else {

 jmp .writeEA116
.writeEA115:
;-642                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA117
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-643                 else            xxx = xxx + R2No;

 jmp .writeEA118
.writeEA117:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al
;-644             }

.writeEA118:
;-645         }

.writeEA116:
;-646     if (Op == MEM) {

.writeEA114:
 mov al, [Op]
 cmp al, 4
 jne .writeEA119
;-647         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA120
;-648             xxx |= 6;

 or  byte[bp+4], 6
;-649             len = 2;

 mov ax, 2
 mov [bp-4], al
;-650         }

;-651         else {

 jmp .writeEA121
.writeEA120:
;-652             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al
;-653             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA122
;-654                 len=1;

 mov ax, 1
 mov [bp-4], al
;-655                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA123
 or  byte[bp+4], 64
;-656             }

.writeEA123:
;-657 

;-658             if (disp) {

.writeEA122:
 mov ax, [disp]
 or  al, al
 je .writeEA124
;-659                 disploc=disp;

 mov ax, [disp]
 mov [bp-2], ax
;-660                 if (disploc  < 0) disploc=mkneg(disploc);

 mov ax, [bp-2]
 cmp ax, 0
 jge .writeEA125
 push word [bp-2]
 call mkneg
 add  sp, 2
 mov [bp-2], ax
;-661                 if (disploc > 127) len=2;

.writeEA125:
 mov ax, [bp-2]
 cmp ax, 127
 jle .writeEA126
 mov ax, 2
 mov [bp-4], al
;-662                 else len=1;

 jmp .writeEA127
.writeEA126:
 mov ax, 1
 mov [bp-4], al
;-663                 if (len == 1) xxx |= 0x40;

.writeEA127:
 mov al, [bp-4]
 cmp al, 1
 jne .writeEA128
 or  byte[bp+4], 64
;-664                 else xxx |= 0x80;

 jmp .writeEA129
.writeEA128:
 or  byte[bp+4], 128
;-665             }

.writeEA129:
;-666         }

.writeEA124:
;-667     }

.writeEA121:
;-668 

;-669     genCode8(xxx);// gen second byte

.writeEA119:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-670     if (len == 1) genCode8 (disp);

 mov al, [bp-4]
 cmp al, 1
 jne .writeEA130
 push word [disp]
 call genCode8
 add  sp, 2
;-671     if (len == 2) genCode16(disp);

.writeEA130:
 mov al, [bp-4]
 cmp al, 2
 jne .writeEA131
 push word [disp]
 call genCode16
 add  sp, 2
;-672 }

.writeEA131:
;-673 

;-674 int genImmediate() {

 LEAVE
 ret
ENDP

genImmediate: PROC
;-675     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate132
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate133
 push word [imme]
 call genCode32
 add  sp, 2
;-676         //todo imme long

;-677         else genCode16(imme);

 jmp .genImmediate134
.genImmediate133:
 push word [imme]
 call genCode16
 add  sp, 2
;-678     else       genCode8 (imme);

.genImmediate134:
 jmp .genImmediate135
.genImmediate132:
 push word [imme]
 call genCode8
 add  sp, 2
;-679 }

.genImmediate135:
;-680 

;-681 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC
;-682     wflag=0;

 mov ax, 0
 mov byte [wflag], al
;-683     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag136
;-684         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag137
 mov al, [R1Type]
 mov byte [OpSize], al
;-685         if (Op2== REG) OpSize=R2Type;

.setwflag137:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag138
 mov al, [R2Type]
 mov byte [OpSize], al
;-686         if (R2Type== SEGREG) OpSize=WORD;

.setwflag138:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag139
 mov ax, 2
 mov byte [OpSize], al
;-687         if (R1Type == SEGREG) OpSize=WORD;

.setwflag139:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag140
 mov ax, 2
 mov byte [OpSize], al
;-688     }

.setwflag140:
;-689     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag136:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag141
 call gen66h
 mov ax, 1
 mov byte [wflag], al
;-690     if (OpSize  ==  WORD) wflag=1;

.setwflag141:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag142
 mov ax, 1
 mov byte [wflag], al
;-691 }

.setwflag142:
;-692 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC
;-693     unsigned int ui;

;-694     sflag=2;

;Function : setsflag, Number local Var: 1
; # type sign width local variables
;300 var unsg word ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al
;-695     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax
;-696     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag143
 mov ax, 0
 mov byte [sflag], al
;-697     if (OpSize == BYTE) {

.setsflag143:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag144
;-698         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag145
 push setsflag_0
 call error1
 add  sp, 2
;-699         sflag=0;//byte reg does not need sign extended

.setsflag145:
 mov ax, 0
 mov byte [sflag], al
;-700     }

;-701 }

.setsflag144:
;-702 int checkConstSize(unsigned int ui) {

 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC
;-703     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number local Var: 1
; # type sign width local variables
;300 var unsg word ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize146
 mov ax, 0
 jmp .retncheckConstSize
;-704     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize146:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize147
 mov ax, 0
 jmp .retncheckConstSize
;-705     return 2;// is short

.checkConstSize147:
 mov ax, 2
 jmp .retncheckConstSize
;-706 }

;-707 

;-708 

;-709 int ChangeDirection() {

 .retncheckConstSize:
 LEAVE
 ret
ENDP

ChangeDirection: PROC
;-710     char c;

;-711     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al
;-712     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al
;-713     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al
;-714     dflag=2;

 mov ax, 2
 mov byte [dflag], al
;-715 }

;-716 

;-717 int getTokeType() {

 LEAVE
 ret
ENDP

getTokeType: PROC
;-718     char c;

;-719     skipBlank();

;Function : getTokeType, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 call skipBlank
;-720     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-721     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType148
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-722     if (c == ';') {TokeType=0; return; }//comment

.getTokeType148:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType149
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-723     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

.getTokeType149:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getTokeType150
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov ax, 1
 mov byte [TokeType], al
 jmp .retngetTokeType
;-724     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

.getTokeType150:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .getTokeType151
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov ax, 3
 mov byte [TokeType], al
 jmp .retngetTokeType
;-725     TokeType=NOALNUME;

.getTokeType151:
 mov ax, 4
 mov byte [TokeType], al
;-726 }

;-727 

;-728 int isToken(char c) {

 .retngetTokeType:
 LEAVE
 ret
ENDP

isToken: PROC
;-729     skipBlank();

;Function : isToken, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 call skipBlank
;-730     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken152
;-731         InputPtr++;

 inc  word[InputPtr]
;-732         return 1;

 mov ax, 1
 jmp .retnisToken
;-733         }

;-734     return 0;

.isToken152:
 mov ax, 0
 jmp .retnisToken
;-735 }

;-736 

;-737 

;-738 int need(char c) {

 .retnisToken:
 LEAVE
 ret
ENDP

need: PROC
;-739     if (isToken(c)) {

;Function : need, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need153
;-740         getTokeType();

 call getTokeType
;-741         return;

 jmp .retnneed
;-742         }

;-743     error1();

.need153:
 call error1
;-744     printstring(". need: ");

 push need_0
 call printstring
 add  sp, 2
;-745     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-746 }

;-747 int skipRest() {

 .retnneed:
 LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC
;-748     getTokeType();

 call getTokeType
;-749     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest154
 push skipRest_0
 call error1
 add  sp, 2
;-750 }

.skipRest154:
;-751 

;-752 

;-753 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC
;-754     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL155
 call implerror
;-755     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL155:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL156
 call segregerror
 jmp .retncheckOpL
;-756     setwflag();

.checkOpL156:
 call setwflag
;-757     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL157
 push checkOpL_0
 call error1
 add  sp, 2
;-758     if (OpSize == R1Type) return;

.checkOpL157:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL158
 jmp .retncheckOpL
;-759     if (Op == REG) if (R1Type==0) error1("no register defined");

.checkOpL158:
 mov al, [Op]
 cmp al, 2
 jne .checkOpL159
 mov al, [R1Type]
 cmp al, 0
 jne .checkOpL160
 push checkOpL_1
 call error1
 add  sp, 2
;-760 }

.checkOpL160:
.checkOpL159:
;-761 

;-762 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC
;-763     int LIx; char *p;

;-764     p = &LabelNames;

;Function : searchLabel, Number local Var: 2
; # type sign width local variables
;300 var sign word LIx = bp-2
;301 ptr sign byte p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax
;-765     LIx = 1;

 mov ax, 1
 mov [bp-2], ax
;-766     while (LIx <= LabelMaxIx) {

.searchLabel161:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel162
;-767         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel163
 mov ax, [bp-2]
 jmp .retnsearchLabel
;-768         p=strlen(p) + p;

.searchLabel163:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax
;-769         p++;

 inc  word[bp-4]
;-770         LIx++;

 inc  word[bp-2]
;-771     }

;-772     return 0;

 jmp .searchLabel161
.searchLabel162:
 mov ax, 0
 jmp .retnsearchLabel
;-773 }

;-774 

;-775 int getOp1() {//scan for a single operand

 .retnsearchLabel:
 LEAVE
 ret
ENDP

getOp1: PROC
;-776 //return:0, IMM, REG, ADR (not MEM)

;-777 //set   :R2Type, R2No by testReg

;-778 //set   :LabelIx by searchLabel

;-779     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1164
 mov ax, 0
 jmp .retngetOp1
;-780     if (TokeType == DIGIT)  return IMM;

.getOp1164:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1165
 mov ax, 1
 jmp .retngetOp1
;-781     if (TokeType == ALNUME) {

.getOp1165:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1166
;-782         R2No=testReg();

 call testReg
 mov byte [R2No], al
;-783         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1167
 mov ax, 2
 jmp .retngetOp1
;-784         LabelIx=searchLabel();

.getOp1167:
 call searchLabel
 mov word [LabelIx], ax
;-785         return ADR;

 mov ax, 3
 jmp .retngetOp1
;-786     }

;-787     return 0;

.getOp1166:
 mov ax, 0
 jmp .retngetOp1
;-788 }

;-789 

;-790 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC
;-791     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1168
 call indexerror
;-792     if (R2No==3) rm=7;//BX

.getIndReg1168:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1169
 mov ax, 7
 mov byte [rm], al
;-793     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1169:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1170
 mov ax, 6
 mov byte [rm], al
;-794     if (R2No==7) rm=5;//DI

.getIndReg1170:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1171
 mov ax, 5
 mov byte [rm], al
;-795     if (R2No==6) rm=4;//SI

.getIndReg1171:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1172
 mov ax, 4
 mov byte [rm], al
;-796     if (rm==0) indexerror();

.getIndReg1172:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1173
 call indexerror
;-797 }

.getIndReg1173:
;-798 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number local Var: 1
; # type sign width local variables
;300 var sign byte m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al
;-799     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2174
 call indexerror
;-800     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2174:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2175
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2176
 mov ax, 3
 mov [bp-2], al
;-801              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2177
.getIndReg2176:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2178
 mov ax, 1
 mov [bp-2], al
;-802     if (R2No==6) if (rm==6) m=2;//BP+SI

.getIndReg2178:
.getIndReg2177:
.getIndReg2175:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg2179
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2180
 mov ax, 2
 mov [bp-2], al
;-803              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2181
.getIndReg2180:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2182
 mov ax, 0
 mov [bp-2], al
;-804     if (m > 3) indexerror();

.getIndReg2182:
.getIndReg2181:
.getIndReg2179:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2183
 call indexerror
;-805     return m;

.getIndReg2183:
 mov al, [bp-2]
 jmp .retngetIndReg2
;-806 }

;-807 int getMEM() {// e.g. [array+bp+si-4]

 .retngetIndReg2:
 LEAVE
 ret
ENDP

getMEM: PROC
;-808 //set: disp, rm, R2Type

;-809     char c;

;-810     disp=0; rm=0;

;Function : getMEM, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al
;-811     do {

.getMEM184:
;-812         getTokeType();

 call getTokeType
;-813         c=getOp1();

 call getOp1
 mov [bp-2], al
;-814         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM185
 call syntaxerror
;-815         if (c == REG) {

.getMEM185:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM186
;-816             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al
;-817             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM187
 call getIndReg2
 mov byte [rm], al
;-818             else getIndReg1();

 jmp .getMEM188
.getMEM187:
 call getIndReg1
;-819         }

.getMEM188:
;-820         if (c == ADR) {

.getMEM186:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM189
;-821             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM190
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax
;-822             else notfounderror();

 jmp .getMEM191
.getMEM190:
 call notfounderror
;-823         }

.getMEM191:
;-824         if (c == IMM) disp=disp+SymbolInt;

.getMEM189:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM192
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax
;-825         if (isToken('-')) {

.getMEM192:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM193
;-826             getTokeType();

 call getTokeType
;-827             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM194
 call numbererror
;-828             disp = disp - SymbolInt;

.getMEM194:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax
;-829         }

;-830     } while (isToken('+'));

.getMEM193:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM195
 jmp .getMEM184
.getMEM195:
;-831     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM196
 push getMEM_0
 call errorexit
 add  sp, 2
;-832 }

.getMEM196:
;-833 

;-834 int getOpR() {

 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC
;-835     Op2=getOp1();

 call getOp1
 mov byte [Op2], al
;-836     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR197
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR
;-837     if (Op2 == 0)     {invaloperror();         return;}

.getOpR197:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR198
 call invaloperror
 jmp .retngetOpR
;-838     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR198:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR199
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR
;-839     if (Op2 == REG)                            return;

.getOpR199:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR200
 jmp .retngetOpR
;-840     if (Op2 == ADR)   {

.getOpR200:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR201
;-841         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR202
 mov ax, 0
 mov word [disp], ax
;-842         else disp=LabelAddr[LabelIx];

 jmp .getOpR203
.getOpR202:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-843         return;}

.getOpR203:
 jmp .retngetOpR
;-844     error1("Name of operand expected");

.getOpR201:
 push getOpR_0
 call error1
 add  sp, 2
;-845 }

;-846 

;-847 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC
;-848     getOpR();

 call getOpR
;-849     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al
;-850     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al
;-851     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al
;-852 }

;-853 

;-854 int get2Ops() {

 ret
ENDP

get2Ops: PROC
;-855     getOpL();

 call getOpL
;-856     need(',');

 push 44
 call need
 add  sp, 2
;-857     getOpR();

 call getOpR
;-858 }

;-859 int check2Ops() {

 ret
ENDP

check2Ops: PROC
;-860     get2Ops();

 call get2Ops
;-861     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops204
 call addrerror
;-862     if (Op == ADR) invaloperror();

.check2Ops204:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops205
 call invaloperror
;-863     if (Op == IMM) immeerror();

.check2Ops205:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops206
 call immeerror
;-864     if (Op2==   0) addrerror();

.check2Ops206:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops207
 call addrerror
;-865     setwflag();

.check2Ops207:
 call setwflag
;-866 }

;-867 

;-868 int storeJmp() {

 ret
ENDP

storeJmp: PROC
;-869     unsigned int i;

;-870     JmpMaxIx++;

;Function : storeJmp, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 inc  word[JmpMaxIx]
;-871     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp208
 push storeJmp_0
 call errorexit
 add  sp, 2
;-872     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp208:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax
;-873     JmpNamePtr++;

 inc  word[JmpNamePtr]
;-874     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax
;-875     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp209
 push storeJmp_1
 call errorexit
 add  sp, 2
;-876     JmpAddr[JmpMaxIx] = PC;

.storeJmp209:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax
;-877 }

;-878 

;-879 int storeLabel() {

 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC
;-880     unsigned int i;

;-881     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel210
 push storeLabel_0
 call error1
 add  sp, 2
;-882     LabelMaxIx++;

.storeLabel210:
 inc  word[LabelMaxIx]
;-883     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel211
 push storeLabel_1
 call errorexit
 add  sp, 2
;-884     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel211:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax
;-885     LabelNamePtr++;

 inc  word[LabelNamePtr]
;-886     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax
;-887     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel212
 push storeLabel_2
 call errorexit
 add  sp, 2
;-888     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel212:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-889 }

;-890 

;-891 

;-892 int genDB() {

 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC
;-893     char c;  char isloop;

;-894         isloop = 0;

;Function : genDB, Number local Var: 2
; # type sign width local variables
;300 var sign byte c = bp-2
;301 var sign byte isloop = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-895             do {

.genDB213:
;-896                 if (isloop) getTokeType();//omit ,

 mov al, [bp-4]
 or  al, al
 je .genDB214
 call getTokeType
;-897                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB214:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB215
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-898                 else {

 jmp .genDB216
.genDB215:
;-899                     skipBlank();

 call skipBlank
;-900                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB217
;-901                         do {

.genDB218:
;-902                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-903                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-904                             InputPtr++;

 inc  word[InputPtr]
;-905                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB219
 jmp .genDB218
.genDB219:
;-906                         InputPtr++;

 inc  word[InputPtr]
;-907                     }

;-908                 }

.genDB217:
;-909                 isloop = 1;

.genDB216:
 mov ax, 1
 mov [bp-4], al
;-910             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB220
 jmp .genDB213
.genDB220:
;-911 }

;-912 

;-913 int getVariable() {

 LEAVE
 ret
ENDP

getVariable: PROC
;-914     char c;

;-915     storeLabel();

;Function : getVariable, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 call storeLabel
;-916     getTokeType();

 call getTokeType
;-917     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable221
;-918         lookCode1();

 call lookCode1
;-919         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable222
 call dataexit
;-920         if (CodeType > 205) dataexit();

.getVariable222:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable223
 call dataexit
;-921         if (CodeType== 200) {//DB

.getVariable223:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable224
;-922             do {

.getVariable225:
;-923                 getTokeType();

 call getTokeType
;-924                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable226
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-925                 else {

 jmp .getVariable227
.getVariable226:
;-926                     skipBlank();

 call skipBlank
;-927                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable228
;-928                         do {

.getVariable229:
;-929                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-930                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-931                             InputPtr++;

 inc  word[InputPtr]
;-932                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable230
 jmp .getVariable229
.getVariable230:
;-933                         InputPtr++;

 inc  word[InputPtr]
;-934                     }

;-935                 }

.getVariable228:
;-936             } while (isToken(','));

.getVariable227:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable231
 jmp .getVariable225
.getVariable231:
;-937         }

;-938         if (CodeType == 201) {//DW

.getVariable224:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable232
;-939             do {

.getVariable233:
;-940                 getTokeType();

 call getTokeType
;-941                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable234
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-942             } while (isToken(','));

.getVariable234:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable235
 jmp .getVariable233
.getVariable235:
;-943         }

;-944         if (CodeType == 202) {//DD

.getVariable232:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable236
;-945             do {

.getVariable237:
;-946                 getTokeType();

 call getTokeType
;-947                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable238
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-948                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2
;-949             } while (isToken(','));

.getVariable238:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable239
 jmp .getVariable237
.getVariable239:
;-950         }

;-951         if (CodeType >= 203) {//resb, resw, resd

.getVariable236:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable240
;-952             getTokeType();

 call getTokeType
;-953             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable241
;-954                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable242
 call syntaxerror
;-955                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable242:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable243
 push getVariable_0
 call error1
 add  sp, 2
;-956                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable243:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-957                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable244
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax
;-958                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable244:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable245
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax
;-959                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable245:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-960             } else numbererror();

 jmp .getVariable246
.getVariable241:
 call numbererror
;-961         }

.getVariable246:
;-962     }

.getVariable240:
;-963     else dataexit();

 jmp .getVariable247
.getVariable221:
 call dataexit
;-964 }

.getVariable247:
;-965 

;-966 int getCodeSize() {

 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC
;-967     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize248
;-968         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize249
 call getTokeType
 mov ax, 1
 jmp .retngetCodeSize
;-969         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

.getCodeSize249:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize250
 call getTokeType
 mov ax, 2
 jmp .retngetCodeSize
;-970         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

.getCodeSize250:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize251
 call getTokeType
 mov ax, 3
 jmp .retngetCodeSize
;-971     }

.getCodeSize251:
;-972     return 0;

.getCodeSize248:
 mov ax, 0
 jmp .retngetCodeSize
;-973 }

;-974 

;-975 int FixOneJmp(unsigned int hex) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

FixOneJmp: PROC
;-976     int Ix; char c;

;-977     Ix=searchLabel();

;Function : FixOneJmp, Number local Var: 3
; # type sign width local variables
;300 var unsg word hex = bp+4
;301 var sign word Ix = bp-2
;302 var sign byte c = bp-4;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax
;-978     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp252
 call notfounderror
;-979     disp = LabelAddr[Ix];

.FixOneJmp252:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-980     c = FileBin[hex];//look for 'A' push Absolute

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al
;-981     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp253
;-982         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax
;-983         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax
;-984         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-985     }

;-986     FileBin[hex] = disp;//fix low byte

.FixOneJmp253:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-987     hex++;

 inc  word[bp+4]
;-988     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax
;-989     FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-990 }

;-991 int fixJmp() {

 LEAVE
 ret
ENDP

fixJmp: PROC
;-992     unsigned int hex; int i;

;-993     char *p;

;-994     p = &JmpNames;

;Function : fixJmp, Number local Var: 3
; # type sign width local variables
;300 var unsg word hex = bp-2
;301 var sign word i = bp-4
;302 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax
;-995     i = 1;

 mov ax, 1
 mov [bp-4], ax
;-996     while (i <= JmpMaxIx) {

.fixJmp254:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp255
;-997         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-998         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax
;-999         p++;

 inc  word[bp-6]
;-1000         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax
;-1001         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2
;-1002         i++;

 inc  word[bp-4]
;-1003     }

;-1004 }

 jmp .fixJmp254
.fixJmp255:
;-1005 int fixJmpMain() {

 LEAVE
 ret
ENDP

fixJmpMain: PROC
;-1006     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain256
 push fixJmpMain_0
 call error1
 add  sp, 2
;-1007     strcpy(Symbol, "main");

.fixJmpMain256:
 push fixJmpMain_1
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-1008     FixOneJmp(1);//first instruction, PC=1

 push 1
 call FixOneJmp
 add  sp, 2
;-1009 }

;-1010 

;-1011 

;-1012 int process() {

 ret
fixJmpMain_0 db "resting global jmp",0
fixJmpMain_1 db "main",0
ENDP

process: PROC
;-1013     char c;

;-1014     int i;

;-1015     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number local Var: 2
; # type sign width local variables
;300 var sign byte c = bp-2
;301 var sign word i = bp-4;
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
;-1016     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax
;-1017     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al
;-1018     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType
;-1019     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al
;-1020 

;-1021     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process257
;-1022         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1023         return;

 jmp .retnprocess
;-1024     }

;-1025 

;-1026     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process257:
 mov al, [CodeType]
 cmp al, 2
 jne .process258
;-1027         getOpL();

 call getOpL
;-1028         checkOpL();

 call checkOpL
;-1029         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process259
;-1030   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process260
;-1031                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process261
;-1032                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process262
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4
;-1033                         else   genCode2(0x40, R1No);//INC

 jmp .process263
.process262:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4
;-1034                     return;

.process263:
 jmp .retnprocess
;-1035                     }

;-1036             }

.process261:
;-1037         }

.process260:
;-1038         if (Code1 == 5) {//imul extension?

.process259:
 mov al, [Code1]
 cmp al, 5
 jne .process264
;-1039             getTokeType();

 call getTokeType
;-1040             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process265
 call implerror
;-1041         }

.process265:
;-1042         if (Code1 < 2) genCodeW(0xFE);

.process264:
 mov al, [Code1]
 cmp al, 2
 jge .process266
 push 254
 call genCodeW
 add  sp, 2
;-1043             else genCodeW(0xF6);

 jmp .process267
.process266:
 push 246
 call genCodeW
 add  sp, 2
;-1044         writeEA(Code1);

.process267:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1045         return;

 jmp .retnprocess
;-1046     }

;-1047 

;-1048     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process258:
 mov al, [CodeType]
 cmp al, 3
 jne .process268
;-1049         check2Ops();    //setwflag not applicable

 call check2Ops
;-1050         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process269
 call reg16error
;-1051         if (Op2 != MEM) addrerror();//only m16

.process269:
 mov al, [Op2]
 cmp al, 4
 je  .process270
 call addrerror
;-1052 

;-1053         if (Code1 >= 0xB2) {

.process270:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process271
;-1054             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process272
 push 15
 call genCode8
 add  sp, 2
;-1055         }

.process272:
;-1056         genCode8(Code1);

.process271:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1057         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1058         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1059         return;

 jmp .retnprocess
;-1060     }

;-1061 

;-1062     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process268:
 mov al, [CodeType]
 cmp al, 4
 jne .process273
;-1063         check2Ops();

 call check2Ops
;-1064         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process274
;-1065             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process275
 call notfounderror
;-1066             imme=LabelAddr[LabelIx];

.process275:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax
;-1067             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al
;-1068         }

;-1069         if (Op2 == IMM) {//second operand is imm

.process274:
 mov al, [Op2]
 cmp al, 1
 jne .process276
;-1070             setsflag();

 call setsflag
;-1071             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process277
;-1072                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process278
;-1073                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process279
;-1074                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1075                         c += 4;

 add  byte[bp-2], 4
;-1076                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1077                         genImmediate();

 call genImmediate
;-1078                         return;

 jmp .retnprocess
;-1079                     }

;-1080                 }

.process279:
;-1081             }

.process278:
;-1082             //r/m, imm: 80 sign-extended,TTT,imm

;-1083             c = sflag + 0x80;

.process277:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al
;-1084             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1085             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1086             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process280
 push word [imme]
 call genCode8
 add  sp, 2
;-1087             else genImmediate();

 jmp .process281
.process280:
 call genImmediate
;-1088             return;

.process281:
 jmp .retnprocess
;-1089         }

;-1090         c = Code1 << 3;//r/m, r/r

.process276:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1091         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process282
;-1092             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process283
;-1093                 c += 2;//add direction flag

 add  byte[bp-2], 2
;-1094                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1095                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1096                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1097                 return;

 jmp .retnprocess
;-1098             }

;-1099         }

.process283:
;-1100         if (Op2 == REG) {//mem,reg    reg,reg

.process282:
 mov al, [Op2]
 cmp al, 2
 jne .process284
;-1101             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1102             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1103             return;

 jmp .retnprocess
;-1104         }

;-1105         syntaxerror();

.process284:
 call syntaxerror
;-1106         return;

 jmp .retnprocess
;-1107     }

;-1108 

;-1109     if (CodeType == 5) {//mov (movsx, movzx=51)

.process273:
 mov al, [CodeType]
 cmp al, 5
 jne .process285
;-1110         check2Ops();

 call check2Ops
;-1111         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process286
;-1112             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process287
 mov ax, [disp]
 mov word [imme], ax
;-1113             else notfounderror();

 jmp .process288
.process287:
 call notfounderror
;-1114             Op2=IMM;//continue with IMM

.process288:
 mov ax, 1
 mov byte [Op2], al
;-1115         }

;-1116         if (Op2 == IMM) {// r,i

.process286:
 mov al, [Op2]
 cmp al, 1
 jne .process289
;-1117             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process290
;-1118                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al
;-1119                 c += 0xB0;

 add  byte[bp-2], 176
;-1120                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1121                 genImmediate();

 call genImmediate
;-1122                 return;

 jmp .retnprocess
;-1123             }

;-1124             if (Op == MEM) {// m,i

.process290:
 mov al, [Op]
 cmp al, 4
 jne .process291
;-1125                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2
;-1126                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2
;-1127                 genImmediate();

 call genImmediate
;-1128                 return;

 jmp .retnprocess
;-1129             }

;-1130             regmemerror();

.process291:
 call regmemerror
;-1131             return;

 jmp .retnprocess
;-1132         }

;-1133         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process289:
 mov al, [R1Type]
 cmp al, 4
 jne .process292
 call ChangeDirection
;-1134         if (R2Type == SEGREG) {//rm,sreg

.process292:
 mov al, [R2Type]
 cmp al, 4
 jne .process293
;-1135             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process294
 call reg16error
;-1136                 genCode2(0x8C, dflag);

.process294:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4
;-1137                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1138                 return;

 jmp .retnprocess
;-1139         }

;-1140         if (Op2 == MEM) {//acc, moffs16

.process293:
 mov al, [Op2]
 cmp al, 4
 jne .process295
;-1141             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process296
;-1142                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process297
;-1143                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process298
;-1144                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2
;-1145                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1146                         return;

 jmp .retnprocess
;-1147                     }

;-1148                 }

.process298:
;-1149             }

.process297:
;-1150         }

.process296:
;-1151         if (Op == MEM) {//moffs16, acc

.process295:
 mov al, [Op]
 cmp al, 4
 jne .process299
;-1152             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process300
;-1153                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process301
;-1154                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process302
;-1155                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2
;-1156                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1157                         return;

 jmp .retnprocess
;-1158                     }

;-1159                 }

.process302:
;-1160             }

.process301:
;-1161 

;-1162         }

.process300:
;-1163         if (Op2 == REG) {//rm, r

.process299:
 mov al, [Op2]
 cmp al, 2
 jne .process303
;-1164             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2
;-1165             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1166             return;

 jmp .retnprocess
;-1167         }

;-1168         if (Op2 == MEM) {//r, m

.process303:
 mov al, [Op2]
 cmp al, 4
 jne .process304
;-1169             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process305
;-1170                 ChangeDirection();

 call ChangeDirection
;-1171                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2
;-1172                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1173                 return;

 jmp .retnprocess
;-1174             }

;-1175         }

.process305:
;-1176         syntaxerror();

.process304:
 call syntaxerror
;-1177         return;

 jmp .retnprocess
;-1178     }

;-1179 

;-1180     if (CodeType == 6) {//Jcc

.process285:
 mov al, [CodeType]
 cmp al, 6
 jne .process306
;-1181         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process307
;-1182             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1183             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process308
;-1184                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1185                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1186                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1187                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process309
;-1188                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1189                     disp -= 2;

 sub  word[disp], 2
;-1190                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1191                 } else {

 jmp .process310
.process309:
;-1192                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1193                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1194                     disp -= 4;

 sub  word[disp], 4
;-1195                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1196                 }

;-1197             }

.process310:
;-1198             else {//jump forward, near only

 jmp .process311
.process308:
;-1199                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1200                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1201                 storeJmp();

 call storeJmp
;-1202                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2
;-1203                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al
;-1204             }

;-1205         return;

.process311:
 jmp .retnprocess
;-1206         }

;-1207     }

.process307:
;-1208 

;-1209     if (CodeType == 7) {//jmp, call

.process306:
 mov al, [CodeType]
 cmp al, 7
 jne .process312
;-1210         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process313
;-1211             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1212             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process314
;-1213                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1214                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1215                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1216                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process315
;-1217                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process316
;-1218                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2
;-1219                         disp -= 2;

 sub  word[disp], 2
;-1220                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1221                     }

;-1222                     else {

 jmp .process317
.process316:
;-1223                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1224                         disp -= 3;

 sub  word[disp], 3
;-1225                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1226                     }

;-1227                 }

.process317:
;-1228                 else {

 jmp .process318
.process315:
;-1229                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1230                     disp -= 3;

 sub  word[disp], 3
;-1231                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1232                 }

;-1233             }

.process318:
;-1234             else {//jump forward, near only

 jmp .process319
.process314:
;-1235                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1236                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process320
 call storeJmp
;-1237                 genCode16(0);

.process320:
 push 0
 call genCode16
 add  sp, 2
;-1238                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al
;-1239             }

;-1240         return;

.process319:
 jmp .retnprocess
;-1241         }

;-1242     }

.process313:
;-1243 

;-1244     if (CodeType ==  8) {//ret,retf

.process312:
 mov al, [CodeType]
 cmp al, 8
 jne .process321
;-1245         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process322
;-1246             if (Code1 == 0xC3) genCode8(0xC2);//ret n

 mov al, [Code1]
 cmp al, 195
 jne .process323
 push 194
 call genCode8
 add  sp, 2
;-1247                 else genCode8(0xCA);//retf n

 jmp .process324
.process323:
 push 202
 call genCode8
 add  sp, 2
;-1248             genCode16(SymbolInt);

.process324:
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1249             return;

 jmp .retnprocess
;-1250         }

;-1251         genCode8(Code1);

.process322:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1252         return;

 jmp .retnprocess
;-1253     }

;-1254 

;-1255     if (CodeType == 9) {//push, pop

.process321:
 mov al, [CodeType]
 cmp al, 9
 jne .process325
;-1256         getOpL();

 call getOpL
;-1257         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process326
;-1258             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process327
;-1259                 setsflag();

 call setsflag
;-1260                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4
;-1261                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process328
 push word [imme]
 call genCode8
 add  sp, 2
;-1262                 else       genCode16(imme);

 jmp .process329
.process328:
 push word [imme]
 call genCode16
 add  sp, 2
;-1263                 return;

.process329:
 jmp .retnprocess
;-1264             }

;-1265             if (Op == ADR) {//push string ABSOLUTE i16

.process327:
 mov al, [Op]
 cmp al, 3
 jne .process330
;-1266                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process331
;-1267                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1268                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1269                     return;

 jmp .retnprocess
;-1270                 }

;-1271                 else {

 jmp .process332
.process331:
;-1272                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1273                     storeJmp();

 call storeJmp
;-1274                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2
;-1275                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al
;-1276                     return;

 jmp .retnprocess
;-1277                 }

;-1278             }

.process332:
;-1279         }

.process330:
;-1280         if (R1Type == SEGREG) {

.process326:
 mov al, [R1Type]
 cmp al, 4
 jne .process333
;-1281             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process334
;-1282                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process335
 push process_0
 call error1
 add  sp, 2
;-1283             }

.process335:
;-1284             c = R1No <<3;

.process334:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al
;-1285             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process336
;-1286                 c += 122;  //0x7A

 add  byte[bp-2], 122
;-1287                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1288             }

;-1289             if (Code1 == 0x50) c +=6;//push

.process336:
 mov al, [Code1]
 cmp al, 80
 jne .process337
 add  byte[bp-2], 6
;-1290                 else c += 7;//pop

 jmp .process338
.process337:
 add  byte[bp-2], 7
;-1291             genCode8(c);

.process338:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1292             return;

 jmp .retnprocess
;-1293         }

;-1294         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

.process333:
 call checkOpL
;-1295 

;-1296         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process339
;-1297             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process340
;-1298                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2
;-1299                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2
;-1300             }else {

 jmp .process341
.process340:
;-1301                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2
;-1302                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2
;-1303             }

;-1304             return;

.process341:
 jmp .retnprocess
;-1305         }

;-1306         if (R1Type == BYTE) reg16error();

.process339:
 mov al, [R1Type]
 cmp al, 1
 jne .process342
 call reg16error
;-1307         if (R1Type == WORD) {//is REG, w/o SEGREG

.process342:
 mov al, [R1Type]
 cmp al, 2
 jne .process343
;-1308             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1309             return;

 jmp .retnprocess
;-1310         }

;-1311         syntaxerror();

.process343:
 call syntaxerror
;-1312         return;

 jmp .retnprocess
;-1313     }

;-1314 

;-1315     if (CodeType == 11) {//shift, rotate

.process325:
 mov al, [CodeType]
 cmp al, 11
 jne .process344
;-1316         check2Ops();

 call check2Ops
;-1317         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process345
;-1318             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process346
;-1319                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2
;-1320                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1321                 return;

 jmp .retnprocess
;-1322             }

;-1323             genCodeW(0xC0);//80186

.process346:
 push 192
 call genCodeW
 add  sp, 2
;-1324             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1325             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2
;-1326             return;

 jmp .retnprocess
;-1327         }

;-1328         if (Op2 == REG) {

.process345:
 mov al, [Op2]
 cmp al, 2
 jne .process347
;-1329             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process348
;-1330                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process349
;-1331                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process350
 mov ax, 1
 mov byte [wflag], al
;-1332                     genCodeW(0xD2);

.process350:
 push 210
 call genCodeW
 add  sp, 2
;-1333                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1334                     return;

 jmp .retnprocess
;-1335                 }

;-1336             }

.process349:
;-1337         }

.process348:
;-1338     }

.process347:
;-1339 

;-1340     if (CodeType == 12) {//int

.process344:
 mov al, [CodeType]
 cmp al, 12
 jne .process351
;-1341         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process352
;-1342             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1343             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1344             return;

 jmp .retnprocess
;-1345         }

;-1346     }

.process352:
;-1347 

;-1348     if (CodeType == 14) {//in, out

.process351:
 mov al, [CodeType]
 cmp al, 14
 jne .process353
;-1349         implerror();

 call implerror
;-1350         return;

 jmp .retnprocess
;-1351     }

;-1352     if (CodeType == 15) {//xchg

.process353:
 mov al, [CodeType]
 cmp al, 15
 jne .process354
;-1353         implerror();

 call implerror
;-1354         return;

 jmp .retnprocess
;-1355     }

;-1356     if (CodeType == 16) {//loop

.process354:
 mov al, [CodeType]
 cmp al, 16
 jne .process355
;-1357         implerror();

 call implerror
;-1358         return;

 jmp .retnprocess
;-1359     }

;-1360 

;-1361     if (CodeType == 30) {//enter i18,i8

.process355:
 mov al, [CodeType]
 cmp al, 30
 jne .process356
;-1362         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2
;-1363         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1364         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process357
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1365         else numbererror();

 jmp .process358
.process357:
 call numbererror
;-1366         need(',');

.process358:
 push 44
 call need
 add  sp, 2
;-1367         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1368         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process359
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1369         else numbererror();

 jmp .process360
.process359:
 call numbererror
;-1370         return;

.process360:
 jmp .retnprocess
;-1371     }

;-1372 

;-1373     if (CodeType == 41) {//test

.process356:
 mov al, [CodeType]
 cmp al, 41
 jne .process361
;-1374         implerror();

 call implerror
;-1375         return;

 jmp .retnprocess
;-1376     }

;-1377 

;-1378     if (CodeType == 51) {//movsx, movzx=51

.process361:
 mov al, [CodeType]
 cmp al, 51
 jne .process362
;-1379         implerror();

 call implerror
;-1380         return;

 jmp .retnprocess
;-1381     }

;-1382 

;-1383     if (CodeType==101) {//ORG nn

.process362:
 mov al, [CodeType]
 cmp al, 101
 jne .process363
;-1384         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process364
 call numbererror
;-1385         Origin=SymbolInt;

.process364:
 mov ax, [SymbolInt]
 mov word [Origin], ax
;-1386         return;

 jmp .retnprocess
;-1387     }

;-1388 

;-1389     if (CodeType == 102) {//section, segment

.process363:
 mov al, [CodeType]
 cmp al, 102
 jne .process365
;-1390         //getTokeType();//ignore .bss .text .data

;-1391         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax
;-1392         return;

 jmp .retnprocess
;-1393     }

;-1394 

;-1395     if (CodeType == 110) {//absolute

.process365:
 mov al, [CodeType]
 cmp al, 110
 jne .process366
;-1396         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process367
 call numbererror
;-1397         AbsoluteLab=SymbolInt;

.process367:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-1398         return;

 jmp .retnprocess
;-1399     }

;-1400     if (CodeType == 111) {//name: PROC

.process366:
 mov al, [CodeType]
 cmp al, 111
 jne .process368
;-1401         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process369
;-1402             printstring("\nentering: ");

 push process_1
 call printstring
 add  sp, 2
;-1403             printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-1404             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al
;-1405             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax
;-1406             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax
;-1407             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax
;-1408             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax
;-1409         } else error1("already in PROC");

 jmp .process370
.process369:
 push process_2
 call error1
 add  sp, 2
;-1410         return;

.process370:
 jmp .retnprocess
;-1411     }

;-1412     if (CodeType == 112) {//ENDP

.process368:
 mov al, [CodeType]
 cmp al, 112
 jne .process371
;-1413         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process372
 push process_3
 call error1
 add  sp, 2
;-1414         printstring("\nleaving: ");

.process372:
 push process_4
 call printstring
 add  sp, 2
;-1415         printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-1416         printstring(", loc labels: ");

 push process_5
 call printstring
 add  sp, 2
;-1417         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax
;-1418         printunsigned(i);

 push word [bp-4]
 call printunsigned
 add  sp, 2
;-1419         printstring(", loc jmp forward: ");

 push process_6
 call printstring
 add  sp, 2
;-1420         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax
;-1421         printunsigned(i);

 push word [bp-4]
 call printunsigned
 add  sp, 2
;-1422         fixJmp();

 call fixJmp
;-1423         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1424         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax
;-1425         LabelMaxIx   = tmpLabelMaxIx;

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax
;-1426         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax
;-1427         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax
;-1428         return;

 jmp .retnprocess
;-1429     }

;-1430     if (CodeType == 200) {//db

.process371:
 mov al, [CodeType]
 cmp al, 200
 jne .process373
;-1431         genDB();

 call genDB
;-1432         return;

 jmp .retnprocess
;-1433     }

;-1434 

;-1435     error1("Command not implemented or syntax error");

.process373:
 push process_7
 call error1
 add  sp, 2
;-1436 }

;-1437 

;-1438 int parse() {

 .retnprocess:
 LEAVE
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
;-1439     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax
;-1440     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax
;-1441     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax
;-1442     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax
;-1443     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax
;-1444     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1445     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al
;-1446 

;-1447     do {//process a new line

.parse374:
;-1448         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax
;-1449         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al
;-1450         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax
;-1451         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al
;-1452         getLine();

 call getLine
;-1453         if (DOS_NoBytes) {

 mov ax, [DOS_NoBytes]
 or  al, al
 je .parse375
;-1454             InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax
;-1455             getTokeType();//getCode in SymbolUpper,

 call getTokeType
;-1456                           //set TokeType,isLabel by getName

;-1457             if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse376
;-1458                 if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse377
;-1459                   if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse378
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4
;-1460                     storeLabel();

.parse378:
 call storeLabel
;-1461                     InputPtr++;//remove :

 inc  word[InputPtr]
;-1462                     getTokeType();

 call getTokeType
;-1463                 }

;-1464             }

.parse377:
;-1465             if (TokeType == ALNUME) {

.parse376:
 mov al, [TokeType]
 cmp al, 3
 jne .parse379
;-1466                 lookCode1();

 call lookCode1
;-1467                 if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse380
 call process
;-1468                 else getVariable();

 jmp .parse381
.parse380:
 call getVariable
;-1469                 skipRest();

.parse381:
 call skipRest
;-1470             }

;-1471             else if(TokeType >ALNUME)error1(

 jmp .parse382
.parse379:
 mov al, [TokeType]
 cmp al, 3
 jle .parse383
;-1472                 "Label or instruction expected");

 push parse_0
 call error1
 add  sp, 2
;-1473             else if(TokeType==DIGIT )error1("No digit allowed at start");

 jmp .parse384
.parse383:
 mov al, [TokeType]
 cmp al, 1
 jne .parse385
 push parse_1
 call error1
 add  sp, 2
;-1474             printLine();

.parse385:
.parse384:
.parse382:
 call printLine
;-1475         }

;-1476     } while (DOS_NoBytes != 0 );

.parse375:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse386
 jmp .parse374
.parse386:
;-1477     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al
;-1478 }

;-1479 

;-1480 int getarg() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start",0
ENDP

getarg: PROC
;-1481     int arglen1; int i; char *c;

;-1482     arglen1=*arglen;

;Function : getarg, Number local Var: 3
; # type sign width local variables
;300 var sign word arglen1 = bp-2
;301 var sign word i = bp-4
;302 ptr sign byte c = bp-6;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax
;-1483     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg387
;-1484         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-1485         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2
;-1486         exitR(3);

 push 3
 call exitR
 add  sp, 2
;-1487     }

;-1488     i=arglen1+129;

.getarg387:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax
;-1489     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
;-1490     arglen1--;

 dec  word[bp-2]
;-1491     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2
;-1492 

;-1493     strcpy(namein, argv); strcat1(namein, ".S");

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
;-1494     strcpy(namelst,argv); strcat1(namelst,".LST");

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
;-1495     strcpy(namebin,argv); strcat1(namebin,".COM");

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
;-1496 

;-1497   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax
;-1498 

;-1499     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax
;-1500     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg388
;-1501         cputs("Source file missing: ");

 push getarg_4
 call cputs
 add  sp, 2
;-1502         cputs(namein);

 lea  ax, [namein]
 push ax
 call cputs
 add  sp, 2
;-1503         exitR(1);

 push 1
 call exitR
 add  sp, 2
;-1504     }

;-1505     lst_fd=creatR(namelst);

.getarg388:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax
;-1506     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg389
;-1507         cputs("can not create list file: ");

 push getarg_5
 call cputs
 add  sp, 2
;-1508         cputs(namelst);

 lea  ax, [namelst]
 push ax
 call cputs
 add  sp, 2
;-1509         exitR(2);

 push 2
 call exitR
 add  sp, 2
;-1510     }

;-1511     printstring(";");

.getarg389:
 push getarg_6
 call printstring
 add  sp, 2
;-1512     printstring(Version1);

 lea  ax, [Version1]
 push ax
 call printstring
 add  sp, 2
;-1513     printstring(", Input: "); printstring(namein);

 push getarg_7
 call printstring
 add  sp, 2
 lea  ax, [namein]
 push ax
 call printstring
 add  sp, 2
;-1514     printstring(", ");

 push getarg_8
 call printstring
 add  sp, 2
;-1515 }

;-1516 

;-1517 int main() {

 LEAVE
 ret
getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
getarg_1 db ".S",0
getarg_2 db ".LST",0
getarg_3 db ".COM",0
getarg_4 db "Source file missing: ",0
getarg_5 db "can not create list file: ",0
getarg_6 db ";",0
getarg_7 db ", Input: ",0
getarg_8 db ", ",0
ENDP

main: PROC
;-1518     getarg();

 call getarg
;-1519     parse();

 call parse
;-1520     fixJmpMain();

 call fixJmpMain
;-1521     epilog();

 call epilog
;-1522     end1();

 call end1
;-1523 }

 ret
ENDP
;Glob. variables:159 (300), Functions:88 (300), Lines:1524
;Constant: 658 (3000), stacksize: 3382