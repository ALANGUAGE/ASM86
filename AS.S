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
;-349     printstring(", Output: ");

 push epilog_0
 call printstring
 add  sp, 2
;-350     printstring(namelst);

 lea  ax, [namelst]
 push ax
 call printstring
 add  sp, 2
;-351     if (ErrorCount == 0) {

 mov ax, [ErrorCount]
 cmp ax, 0
 jne .epilog83
;-352         printstring(", no errors, ");

 push epilog_1
 call printstring
 add  sp, 2
;-353         printstring(namebin);

 lea  ax, [namebin]
 push ax
 call printstring
 add  sp, 2
;-354         printstring("= ");

 push epilog_2
 call printstring
 add  sp, 2
;-355         printunsigned(BinLen);

 push word [BinLen]
 call printunsigned
 add  sp, 2
;-356         printstring(" bytes.");

 push epilog_3
 call printstring
 add  sp, 2
;-357         bin_fd=creatR(namebin);

 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax
;-358         if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .epilog84
;-359             cputs("can not create COM file: ");

 push epilog_4
 call cputs
 add  sp, 2
;-360             cputs(namebin);

 lea  ax, [namebin]
 push ax
 call cputs
 add  sp, 2
;-361             exitR(2);

 push 2
 call exitR
 add  sp, 2
;-362         }

;-363         i=0;

.epilog84:
 mov ax, 0
 mov [bp-2], ax
;-364         do {

.epilog85:
;-365             c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-6], al
;-366             fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-367             i++;

 inc  word[bp-2]
;-368         } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog86
 jmp .epilog85
.epilog86:
;-369     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2
;-370     }

;-371     fcloseR(asm_fd);

.epilog83:
 push word [asm_fd]
 call fcloseR
 add  sp, 2
;-372     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2
;-373     exitR(ErrorCount);

 push word [ErrorCount]
 call exitR
 add  sp, 2
;-374 }

;-375 

;-376 int error1(char *s) {

 LEAVE
 ret
epilog_0 db ", Output: ",0
epilog_1 db ", no errors, ",0
epilog_2 db "= ",0
epilog_3 db " bytes.",0
epilog_4 db "can not create COM file: ",0
ENDP

error1: PROC
;-377     isPrint=1;

;Function : error1, Number local Var: 1
; # type sign width local variables
;300 ptr sign byte s = bp+4;
 ENTER  0,0
 mov ax, 1
 mov byte [isPrint], al
;-378     ErrorCount++;

 inc  word[ErrorCount]
;-379     printstring("\n******* next line ERROR: ");

 push error1_0
 call printstring
 add  sp, 2
;-380     printstring(s);

 push word [bp+4]
 call printstring
 add  sp, 2
;-381     printstring(", Symbol >>");

 push error1_1
 call printstring
 add  sp, 2
;-382     printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-383     printstring("<< in proc ");

 push error1_2
 call printstring
 add  sp, 2
;-384     printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-385     epilog();

 call epilog
;-386 }

;-387 int notfounderror(){error1("label not found: ");}

 LEAVE
 ret
error1_0 db "\n******* next line ERROR: ",0
error1_1 db ", Symbol >>",0
error1_2 db "<< in proc ",0
ENDP

notfounderror: PROC
 push notfounderror_0
 call error1
 add  sp, 2
;-388 int dataexit()     {error1("DB,DW,DD or RESB,W,D expected");}

 ret
notfounderror_0 db "label not found: ",0
ENDP

dataexit: PROC
 push dataexit_0
 call error1
 add  sp, 2
;-389 int addrerror()    {error1("address missing");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2
;-390 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2
;-391 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2
;-392 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2
;-393 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2
;-394 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2
;-395 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2
;-396 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2
;-397 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2
;-398 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2
;-399 

;-400 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
syntaxerror_0 db "syntax",0
ENDP

ifEOL: PROC
;-401   if (c == 10) return 1;//LF

;Function : ifEOL, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL87
 mov ax, 1
 jmp .retnifEOL
;-402   if (c == 13) {//CR

.ifEOL87:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL88
;-403     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-404     if (DOS_ByteRead != 10) error1("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL89
 push ifEOL_0
 call error1
 add  sp, 2
;-405     return 1;

.ifEOL89:
 mov ax, 1
 jmp .retnifEOL
;-406   }

;-407   return 0;

.ifEOL88:
 mov ax, 0
 jmp .retnifEOL
;-408 }

;-409 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL:
 LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC
;-410   unsigned int i;

;-411   InputPtr= &InputBuf;

;Function : getLine, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax
;-412   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-413   do {

.getLine90:
;-414     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-415     if (DOS_ERR) error1("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine91
 push getLine_0
 call error1
 add  sp, 2
;-416     if (DOS_NoBytes == 0) return;

.getLine91:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine92
 jmp .retngetLine
;-417     *InputPtr = DOS_ByteRead;

.getLine92:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al
;-418     InputPtr++;

 inc  word[InputPtr]
;-419     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax
;-420     if (i >= INPUTBUFMAX) error1("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine93
 push getLine_1
 call error1
 add  sp, 2
;-421   } while (ifEOL(DOS_ByteRead) == 0);

.getLine93:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne .getLine94
 jmp .getLine90
.getLine94:
;-422   InputPtr--;

 dec  word[InputPtr]
;-423   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-424 }

;-425 int skipBlank() {

 .retngetLine:
 LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC
;-426   skipblank1:

.skipblank1:
;-427     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank95
 inc  word[InputPtr]
 jmp .skipblank1
;-428     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank95:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank96
 inc  word[InputPtr]
 jmp .skipblank1
;-429 }

.skipBlank96:
;-430 

;-431 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC
;-432   unsigned int CastInt;

;-433   SymbolInt=0;

;Function : getDigit, Number local Var: 2
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 var unsg word CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax
;-434   do {

.getDigit97:
;-435     c-='0';

 sub  byte[bp+4], 48
;-436     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax
;-437     ax=0;

 mov  ax, 0
;-438     CastInt=c; //cast b2w

 mov al, [bp+4]
 mov [bp-2], ax
;-439     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax
;-440     InputPtr++;

 inc  word[InputPtr]
;-441     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-442   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit98
 jmp .getDigit97
.getDigit98:
;-443 }

;-444 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel

 LEAVE
 ret
ENDP

getName: PROC
;-445   char *p; unsigned int i;

;-446   p = &Symbol;

;Function : getName, Number local Var: 3
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 ptr sign byte p = bp-2
;302 var unsg word i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax
;-447   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-448   p++;

 inc  word[bp-2]
;-449   while (alnumE(c)) {

.getName99:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName100
;-450     InputPtr++;

 inc  word[InputPtr]
;-451     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-452     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-453     p++;

 inc  word[bp-2]
;-454     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax
;-455     if (i >= SYMBOLMAX) error1("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName101
 push getName_0
 call error1
 add  sp, 2
;-456   }

.getName101:
;-457   if (c == ':') isLabel=1; else isLabel=0;

 jmp .getName99
.getName100:
 mov al, [bp+4]
 cmp al, 58
 jne .getName102
 mov ax, 1
 mov byte [isLabel], al
 jmp .getName103
.getName102:
 mov ax, 0
 mov byte [isLabel], al
;-458   p--;

.getName103:
 dec  word[bp-2]
;-459   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-460   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4
;-461   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2
;-462 }

;-463 

;-464 //OpName, 0, CodeType, Code1

;-465 //  1:   1 byte opcod

;-466 char T00[]={'P','U','S','H','A',0,1,0x60, 'P','O','P','A',0,    1,0x61};

 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
T00 db 80,85,83,72,65,0,1,96,80,79,80,65,0,1,97
;-467 char T01[]={'N','O','P',0,        1,0x90, 'C','B','W',0,        1,0x98};

T01 db 78,79,80,0,1,144,67,66,87,0,1,152
;-468 char T02[]={'C','W','D','E',0,    1,0x98, 'C','W','D',0,        1,0x99};

T02 db 67,87,68,69,0,1,152,67,87,68,0,1,153
;-469 char T03[]={'C','D','Q',0,        1,0x99, 'W','A','I','T',0,    1,0x9B};

T03 db 67,68,81,0,1,153,87,65,73,84,0,1,155
;-470 char T04[]={'P','U','S','H','F',0,1,0x9C, 'P','O','P','F',0,    1,0x9D};

T04 db 80,85,83,72,70,0,1,156,80,79,80,70,0,1,157
;-471 char T05[]={'S','A','H','F',0,    1,0x9E, 'L','A','H','F',0,    1,0x9F};

T05 db 83,65,72,70,0,1,158,76,65,72,70,0,1,159
;-472 char T06[]={'M','O','V','S','B',0,1,0xA4, 'M','O','V','S','W',0,1,0xA5};

T06 db 77,79,86,83,66,0,1,164,77,79,86,83,87,0,1,165
;-473 char T07[]={'C','M','P','S','B',0,1,0xA6, 'C','M','P','S','W',0,1,0xA7};

T07 db 67,77,80,83,66,0,1,166,67,77,80,83,87,0,1,167
;-474 char T08[]={'S','T','O','S','B',0,1,0xAA, 'S','T','O','S','W',0,1,0xAB};

T08 db 83,84,79,83,66,0,1,170,83,84,79,83,87,0,1,171
;-475 char T09[]={'L','O','D','S','B',0,1,0xAC, 'L','O','D','S','W',0,1,0xAD};

T09 db 76,79,68,83,66,0,1,172,76,79,68,83,87,0,1,173
;-476 char T10[]={'S','C','A','S','B',0,1,0xAE, 'S','C','A','S','W',0,1,0xAF};

T10 db 83,67,65,83,66,0,1,174,83,67,65,83,87,0,1,175
;-477 char T11[]={'L','E','A','V','E',0,1,0xC9, 'I','N','T','3',0,    1,0xCC};

T11 db 76,69,65,86,69,0,1,201,73,78,84,51,0,1,204
;-478 char T12[]={'I','N','T','O',0,    1,0xCE, 'I','R','E','T',0,    1,0xCF};

T12 db 73,78,84,79,0,1,206,73,82,69,84,0,1,207
;-479 char T13[]={'X','L','A','T',0,    1,0xD7, 'L','O','C','K',0,    1,0xF0};

T13 db 88,76,65,84,0,1,215,76,79,67,75,0,1,240
;-480 char T14[]={'R','E','P','N','E',0,1,0xF2, 'R','E','P','N','Z',0,1,0xF2};

T14 db 82,69,80,78,69,0,1,242,82,69,80,78,90,0,1,242
;-481 char T15[]={'R','E','P','E',0,    1,0xF3, 'R','E','P','Z',0,    1,0xF3};

T15 db 82,69,80,69,0,1,243,82,69,80,90,0,1,243
;-482 char T16[]={'H','L','T',0,        1,0xF4, 'C','L','C',0,        1,0xF8};

T16 db 72,76,84,0,1,244,67,76,67,0,1,248
;-483 char T17[]={'S','T','C',0,        1,0xF9, 'C','L','I',0,        1,0xFA};

T17 db 83,84,67,0,1,249,67,76,73,0,1,250
;-484 char T18[]={'S','T','I',0,        1,0xFB, 'C','L','D',0,        1,0xFC};

T18 db 83,84,73,0,1,251,67,76,68,0,1,252
;-485 char T19[]={'S','T','D',0,        1,0xFD};

T19 db 83,84,68,0,1,253
;-486 // 2: mem reg 16 bit

;-487 char T20[]={'I','N','C',0,        2, 0,   'D','E','C',0,        2, 1};

T20 db 73,78,67,0,2,0,68,69,67,0,2,1
;-488 char T21[]={'N','O','T',0,        2, 2,   'N','E','G',0,        2, 3};

T21 db 78,79,84,0,2,2,78,69,71,0,2,3
;-489 char T22[]={'M','U','L',0,        2, 4,   'I','M','U','L',0,    2, 5};

T22 db 77,85,76,0,2,4,73,77,85,76,0,2,5
;-490 //IMUL acc only

;-491 char T23[]={'D','I','V',0,        2, 6,   'I','D','I','V',0,    2, 7};

T23 db 68,73,86,0,2,6,73,68,73,86,0,2,7
;-492 //  3: les, lda, lea, lss, lfs, lgs

;-493 char T24[]={'L','E','S',0,        3,0xC4, 'L','D','S',0,        3,0xC5};

T24 db 76,69,83,0,3,196,76,68,83,0,3,197
;-494 char T25[]={'L','E','A',0,        3,0x8D, 'L','S','S',0,        3,0xB2};

T25 db 76,69,65,0,3,141,76,83,83,0,3,178
;-495 char T26[]={'L','F','S',0,        3,0xB4, 'L','G','S',0,        3,0xB5};

T26 db 76,70,83,0,3,180,76,71,83,0,3,181
;-496 //  4: acc,imm  reg,imm  index,reg

;-497 char T27[]={'A','D','D',0,        4, 0,   'O','R',0,            4, 1};

T27 db 65,68,68,0,4,0,79,82,0,4,1
;-498 char T28[]={'A','D','C',0,        4, 2,   'S','B','B',0,        4, 3};

T28 db 65,68,67,0,4,2,83,66,66,0,4,3
;-499 char T29[]={'A','N','D',0,        4, 4,   'S','U','B',0,        4, 5};

T29 db 65,78,68,0,4,4,83,85,66,0,4,5
;-500 char T30[]={'X','O','R',0,        4, 6,   'C','M','P',0,        4, 7};

T30 db 88,79,82,0,4,6,67,77,80,0,4,7
;-501 //  5: mov

;-502 char T31[]={'M','O','V',0,        5, 0};

T31 db 77,79,86,0,5,0
;-503 //  6: single byte relative jump

;-504 char T32[]={'J','O',0,            6, 0,    'J','N','O',0,       6, 1};

T32 db 74,79,0,6,0,74,78,79,0,6,1
;-505 char T33[]={'J','B',0,            6, 2,    'J','C',0,           6, 2};

T33 db 74,66,0,6,2,74,67,0,6,2
;-506 char T34[]={'J','N','B',0,        6, 3};

T34 db 74,78,66,0,6,3
;-507 char T35[]={'J','A','E',0,        6, 3,    'J','N','C',0,       6, 3};

T35 db 74,65,69,0,6,3,74,78,67,0,6,3
;-508 char T36[]={'J','E',0,            6, 4,    'J','Z',0,           6, 4};

T36 db 74,69,0,6,4,74,90,0,6,4
;-509 char T37[]={'J','N','E',0,        6, 5,    'J','N','Z',0,       6, 5};

T37 db 74,78,69,0,6,5,74,78,90,0,6,5
;-510 char T38[]={'J','B','E',0,        6, 6,    'J','N','A',0,       6, 6};

T38 db 74,66,69,0,6,6,74,78,65,0,6,6
;-511 char T39[]={'J','A',0,            6, 7,    'J','S',0,           6, 8};

T39 db 74,65,0,6,7,74,83,0,6,8
;-512 char T40[]={'J','N','S',0,        6, 9};

T40 db 74,78,83,0,6,9
;-513 char T41[]={'J','P',0,            6,10,    'J','P','E',0,       6,10};

T41 db 74,80,0,6,10,74,80,69,0,6,10
;-514 char T42[]={'J','N','P',0,        6,11,    'J','P','O',0,       6,11};

T42 db 74,78,80,0,6,11,74,80,79,0,6,11
;-515 char T43[]={'J','L',0,            6,12};

T43 db 74,76,0,6,12
;-516 char T44[]={'J','N','L',0,        6,13,    'J','G','E',0,       6,13};

T44 db 74,78,76,0,6,13,74,71,69,0,6,13
;-517 char T45[]={'J','L','E',0,        6,14,    'J','N','G',0,       6,14};

T45 db 74,76,69,0,6,14,74,78,71,0,6,14
;-518 char T46[]={'J','G',0,            6,15};

T46 db 74,71,0,6,15
;-519 //  7: jmp, call

;-520 char T47[]={'J','M','P',0,        7,0xE9,  'C','A','L','L',0,   7,0xE8};

T47 db 74,77,80,0,7,233,67,65,76,76,0,7,232
;-521 //  8: ret

;-522 char T48[]={'R','E','T',0,        8,0xC3,  'R','E','T','F',0,   8,0xCB};

T48 db 82,69,84,0,8,195,82,69,84,70,0,8,203
;-523 //  9: seg, r/m

;-524 char T49[]={'P','U','S','H',0,    9,0x50,  'P','O','P',0,       9,0x58};

T49 db 80,85,83,72,0,9,80,80,79,80,0,9,88
;-525 //  11: shift, rotates

;-526 char T50[]={'R','O','L',0,       11, 0,    'R','O','R',0,      11, 1};

T50 db 82,79,76,0,11,0,82,79,82,0,11,1
;-527 char T51[]={'R','C','L',0,       11, 2,    'R','C','R',0,      11, 3};

T51 db 82,67,76,0,11,2,82,67,82,0,11,3
;-528 char T52[]={'S','H','L',0,       11, 4,    'S','A','L',0,      11, 4};

T52 db 83,72,76,0,11,4,83,65,76,0,11,4
;-529 char T53[]={'S','H','R',0,       11, 5,    'S','A','R',0,      11, 7};

T53 db 83,72,82,0,11,5,83,65,82,0,11,7
;-530 //  12: int

;-531 char T54[]={'I','N','T',0,       12,0xCD};

T54 db 73,78,84,0,12,205
;-532 //  14: in/out                   not implemented

;-533 char T55[]={'I','N',0,           14,0xE4,  'I','N','S','B',0,  14,0x6C};

T55 db 73,78,0,14,228,73,78,83,66,0,14,108
;-534 char T56[]={'I','N','S','W',0,   14,0x6D,  'I','N','S','D',0,  14,0x6D};

T56 db 73,78,83,87,0,14,109,73,78,83,68,0,14,109
;-535 char T57[]={'O','U','T',0,       14,0xE6,  'O','U','T','B',0,  14,0x6E};

T57 db 79,85,84,0,14,230,79,85,84,66,0,14,110
;-536 char T58[]={'O','U','T','W',0,   14,0x6F,  'O','U','T','D',0,  14,0x6F};

T58 db 79,85,84,87,0,14,111,79,85,84,68,0,14,111
;-537 //  15: xch                      not implemented

;-538 char T59[]={'X','C','H','G',0,   15,0x86};

T59 db 88,67,72,71,0,15,134
;-539 //  16: loop, jcxz               not implemented

;-540 char T60 []={'L','O','O','P','N','Z',0,16,0xE0};

T60 db 76,79,79,80,78,90,0,16,224
;-541 char T60a[]={'L','O','O','P','N','E',0,16,0xE0};

T60a db 76,79,79,80,78,69,0,16,224
;-542 char T61[]={'L','O','O','P','Z',0,16,0xE1,'L','O','O','P','E',0,16,0xE1};

T61 db 76,79,79,80,90,0,16,225,76,79,79,80,69,0,16,225
;-543 char T62[]={'L','O','O','P',0,    16,0xE2};

T62 db 76,79,79,80,0,16,226
;-544 char T63[]={'J','C','X','Z',0,    16,0xE3,'J','E','C','X','Z',0,16,0xE3};

T63 db 74,67,88,90,0,16,227,74,69,67,88,90,0,16,227
;-545 //  30: other

;-546 char T64[]={'E','N','T','E','R',0,30,0};

T64 db 69,78,84,69,82,0,30,0
;-547 //                                not implemented

;-548 char T65[]={'T','E','S','T',0,    41,0xF6};

T65 db 84,69,83,84,0,41,246
;-549 char T66[]={'M','O','V','S','X',0,51,0xBE,'M','O','V','Z','X',0,51,0xB6};

T66 db 77,79,86,83,88,0,51,190,77,79,86,90,88,0,51,182
;-550 // 100: directives

;-551 char T67[]={'O','R','G',0,      101, 0};

T67 db 79,82,71,0,101,0
;-552 // section, segment .TEXT .DATA .BSS

;-553 char T68[]={'S','E','C','T','I','O','N',0,      102, 0};

T68 db 83,69,67,84,73,79,78,0,102,0
;-554 char T69[]={'S','E','G','M','E','N','T',0,      102, 0};

T69 db 83,69,71,77,69,78,84,0,102,0
;-555 char T70[]={'A','B','S','O','L','U','T','E',0,  110, 0};

T70 db 65,66,83,79,76,85,84,69,0,110,0
;-556 char T71[]={'P','R','O','C',0,    111, 0, 'E','N','D','P',0, 112, 0};

T71 db 80,82,79,67,0,111,0,69,78,68,80,0,112,0
;-557 char T72[]={'D','B',0,            200, 0, 'D','W',0,         201, 0};

T72 db 68,66,0,200,0,68,87,0,201,0
;-558 char T73[]={'D','D',0,            202, 0, 'R','E','S','B',0, 203, 0};

T73 db 68,68,0,202,0,82,69,83,66,0,203,0
;-559 char T74[]={'R','E','S','W',0,    204, 0, 'R','E','S','D',0, 205, 0};

T74 db 82,69,83,87,0,204,0,82,69,83,68,0,205,0
;-560 char TEND=0;// end of table char

TEND db 0
;-561 

;-562 int lookCode1() {//ret: CodeType, Code1


lookCode1: PROC
;-563     OpCodePtr= &T00;

 mov ax, T00
 mov word [OpCodePtr], ax
;-564     do  {

.lookCode1104:
;-565         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode1105
;-566             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1106:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1107
 inc  word[OpCodePtr]
;-567             OpCodePtr++;

 jmp .lookCode1106
.lookCode1107:
 inc  word[OpCodePtr]
;-568             CodeType = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al
;-569             OpCodePtr++;

 inc  word[OpCodePtr]
;-570             Code1    = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al
;-571             return;

 jmp .retnlookCode1
;-572         }

;-573         while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1105:
.lookCode1108:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1109
 inc  word[OpCodePtr]
;-574         OpCodePtr += 3;

 jmp .lookCode1108
.lookCode1109:
 add  word[OpCodePtr], 3
;-575 

;-576         } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1110
 jmp .lookCode1104
.lookCode1110:
;-577     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al
;-578 }

;-579 

;-580 

;-581 int genCode8(char c) {

 .retnlookCode1:
 ret
ENDP

genCode8: PROC
;-582 //set: BinLen++, OpPrintIndex++

;-583     FileBin[BinLen]=c;

;Function : genCode8, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
;-584     BinLen++;

 inc  word[BinLen]
;-585     PC++;

 inc  word[PC]
;-586     if (BinLen >= FILEBINMAX) error1("COM file too long");

 mov ax, [BinLen]
 cmp ax, 25000 ;unsigned : 0
 jb  .genCode8111
 push genCode8_0
 call error1
 add  sp, 2
;-587     if (OpPrintIndex < OPMAXLEN) {

.genCode8111:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8112
;-588         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
;-589         OpPrintIndex++;

 inc  word[OpPrintIndex]
;-590     }

;-591 }

.genCode8112:
;-592 int gen66h() {genCode8(0x66);

 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2
;-593 }

;-594 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC
;-595     c = c + d;

;Function : genCode2, Number local Var: 2
; # type sign width local variables
;300 var sign byte c = bp+4
;301 var sign byte d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al
;-596     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-597 }

;-598 int genCodeW(char c) {

 LEAVE
 ret
ENDP

genCodeW: PROC
;-599     c = c + wflag;

;Function : genCodeW, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al
;-600     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-601 }

;-602 int genCode16(unsigned int i) {

 LEAVE
 ret
ENDP

genCode16: PROC
;-603     genCode8(i); i=i >> 8;

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
;-604     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2
;-605 }

;-606 int genCode32(unsigned long L) {

 LEAVE
 ret
ENDP

genCode32: PROC
;-607     genCode16(L); L=L >>16;

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
;-608     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
;-609 }

;-610 int writeEA(char xxx) {//value for reg/operand

 LEAVE
 ret
ENDP

writeEA: PROC
;-611 //need: Op, Op2, disp, R1No, R2No, rm, isDirect

;-612 //mod-bits: mode76, reg/opcode543, r/m210

;-613 //Op: 0, IMM, REG, ADR, MEM

;-614     int disploc;

;-615     char len;

;-616     len=0;

;Function : writeEA, Number local Var: 3
; # type sign width local variables
;300 var sign byte xxx = bp+4
;301 var sign word disploc = bp-2
;302 var sign byte len = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-617     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al
;-618     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA113
;-619         xxx |= 0xC0;

 or  byte[bp+4], 192
;-620         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA114
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-621             else {

 jmp .writeEA115
.writeEA114:
;-622                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA116
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-623                 else            xxx = xxx + R2No;

 jmp .writeEA117
.writeEA116:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al
;-624             }

.writeEA117:
;-625         }

.writeEA115:
;-626     if (Op == MEM) {

.writeEA113:
 mov al, [Op]
 cmp al, 4
 jne .writeEA118
;-627         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA119
;-628             xxx |= 6;

 or  byte[bp+4], 6
;-629             len = 2;

 mov ax, 2
 mov [bp-4], al
;-630         }

;-631         else {

 jmp .writeEA120
.writeEA119:
;-632             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al
;-633             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA121
;-634                 len=1;

 mov ax, 1
 mov [bp-4], al
;-635                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA122
 or  byte[bp+4], 64
;-636             }

.writeEA122:
;-637 

;-638             if (disp) {

.writeEA121:
 mov ax, [disp]
 or  al, al
 je .writeEA123
;-639                 disploc=disp;

 mov ax, [disp]
 mov [bp-2], ax
;-640                 if (disploc  < 0) disploc=mkneg(disploc);

 mov ax, [bp-2]
 cmp ax, 0
 jge .writeEA124
 push word [bp-2]
 call mkneg
 add  sp, 2
 mov [bp-2], ax
;-641                 if (disploc > 127) len=2;

.writeEA124:
 mov ax, [bp-2]
 cmp ax, 127
 jle .writeEA125
 mov ax, 2
 mov [bp-4], al
;-642                 else len=1;

 jmp .writeEA126
.writeEA125:
 mov ax, 1
 mov [bp-4], al
;-643                 if (len == 1) xxx |= 0x40;

.writeEA126:
 mov al, [bp-4]
 cmp al, 1
 jne .writeEA127
 or  byte[bp+4], 64
;-644                 else xxx |= 0x80;

 jmp .writeEA128
.writeEA127:
 or  byte[bp+4], 128
;-645             }

.writeEA128:
;-646         }

.writeEA123:
;-647     }

.writeEA120:
;-648 

;-649     genCode8(xxx);// gen second byte

.writeEA118:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-650     if (len == 1) genCode8 (disp);

 mov al, [bp-4]
 cmp al, 1
 jne .writeEA129
 push word [disp]
 call genCode8
 add  sp, 2
;-651     if (len == 2) genCode16(disp);

.writeEA129:
 mov al, [bp-4]
 cmp al, 2
 jne .writeEA130
 push word [disp]
 call genCode16
 add  sp, 2
;-652 }

.writeEA130:
;-653 

;-654 int genImmediate() {

 LEAVE
 ret
ENDP

genImmediate: PROC
;-655     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate131
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate132
 push word [imme]
 call genCode32
 add  sp, 2
;-656         //todo imme long

;-657         else genCode16(imme);

 jmp .genImmediate133
.genImmediate132:
 push word [imme]
 call genCode16
 add  sp, 2
;-658     else       genCode8 (imme);

.genImmediate133:
 jmp .genImmediate134
.genImmediate131:
 push word [imme]
 call genCode8
 add  sp, 2
;-659 }

.genImmediate134:
;-660 

;-661 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC
;-662     wflag=0;

 mov ax, 0
 mov byte [wflag], al
;-663     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag135
;-664         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag136
 mov al, [R1Type]
 mov byte [OpSize], al
;-665         if (Op2== REG) OpSize=R2Type;

.setwflag136:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag137
 mov al, [R2Type]
 mov byte [OpSize], al
;-666         if (R2Type== SEGREG) OpSize=WORD;

.setwflag137:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag138
 mov ax, 2
 mov byte [OpSize], al
;-667         if (R1Type == SEGREG) OpSize=WORD;

.setwflag138:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag139
 mov ax, 2
 mov byte [OpSize], al
;-668     }

.setwflag139:
;-669     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag135:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag140
 call gen66h
 mov ax, 1
 mov byte [wflag], al
;-670     if (OpSize  ==  WORD) wflag=1;

.setwflag140:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag141
 mov ax, 1
 mov byte [wflag], al
;-671 }

.setwflag141:
;-672 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC
;-673     unsigned int ui;

;-674     sflag=2;

;Function : setsflag, Number local Var: 1
; # type sign width local variables
;300 var unsg word ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al
;-675     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax
;-676     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag142
 mov ax, 0
 mov byte [sflag], al
;-677     if (OpSize == BYTE) {

.setsflag142:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag143
;-678         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag144
 push setsflag_0
 call error1
 add  sp, 2
;-679         sflag=0;//byte reg does not need sign extended

.setsflag144:
 mov ax, 0
 mov byte [sflag], al
;-680     }

;-681 }

.setsflag143:
;-682 int checkConstSize(unsigned int ui) {

 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC
;-683     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number local Var: 1
; # type sign width local variables
;300 var unsg word ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize145
 mov ax, 0
 jmp .retncheckConstSize
;-684     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize145:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize146
 mov ax, 0
 jmp .retncheckConstSize
;-685     return 2;// is short

.checkConstSize146:
 mov ax, 2
 jmp .retncheckConstSize
;-686 }

;-687 

;-688 

;-689 int ChangeDirection() {

 .retncheckConstSize:
 LEAVE
 ret
ENDP

ChangeDirection: PROC
;-690     char c;

;-691     c=Op;     Op    =Op2;    Op2   =c;

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
;-692     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al
;-693     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al
;-694     dflag=2;

 mov ax, 2
 mov byte [dflag], al
;-695 }

;-696 

;-697 int getTokeType() {

 LEAVE
 ret
ENDP

getTokeType: PROC
;-698     char c;

;-699     skipBlank();

;Function : getTokeType, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 call skipBlank
;-700     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-701     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType147
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-702     if (c == ';') {TokeType=0; return; }//comment

.getTokeType147:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType148
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-703     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

.getTokeType148:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getTokeType149
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov ax, 1
 mov byte [TokeType], al
 jmp .retngetTokeType
;-704     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

.getTokeType149:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .getTokeType150
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov ax, 3
 mov byte [TokeType], al
 jmp .retngetTokeType
;-705     TokeType=NOALNUME;

.getTokeType150:
 mov ax, 4
 mov byte [TokeType], al
;-706 }

;-707 

;-708 int isToken(char c) {

 .retngetTokeType:
 LEAVE
 ret
ENDP

isToken: PROC
;-709     skipBlank();

;Function : isToken, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 call skipBlank
;-710     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken151
;-711         InputPtr++;

 inc  word[InputPtr]
;-712         return 1;

 mov ax, 1
 jmp .retnisToken
;-713         }

;-714     return 0;

.isToken151:
 mov ax, 0
 jmp .retnisToken
;-715 }

;-716 

;-717 

;-718 int need(char c) {

 .retnisToken:
 LEAVE
 ret
ENDP

need: PROC
;-719     if (isToken(c)) {

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
 je .need152
;-720         getTokeType();

 call getTokeType
;-721         return;

 jmp .retnneed
;-722         }

;-723     printstring(" need: ");

.need152:
 push need_0
 call printstring
 add  sp, 2
;-724     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-725     error1("character misssing");

 push need_1
 call error1
 add  sp, 2
;-726 }

;-727 int skipRest() {

 .retnneed:
 LEAVE
 ret
need_0 db " need: ",0
need_1 db "character misssing",0
ENDP

skipRest: PROC
;-728     getTokeType();

 call getTokeType
;-729     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest153
 push skipRest_0
 call error1
 add  sp, 2
;-730 }

.skipRest153:
;-731 

;-732 

;-733 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC
;-734     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL154
 call implerror
;-735     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL154:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL155
 call segregerror
 jmp .retncheckOpL
;-736     setwflag();

.checkOpL155:
 call setwflag
;-737     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL156
 push checkOpL_0
 call error1
 add  sp, 2
;-738     if (OpSize == R1Type) return;

.checkOpL156:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL157
 jmp .retncheckOpL
;-739     if (Op == REG) if (R1Type==0) error1("no register defined");

.checkOpL157:
 mov al, [Op]
 cmp al, 2
 jne .checkOpL158
 mov al, [R1Type]
 cmp al, 0
 jne .checkOpL159
 push checkOpL_1
 call error1
 add  sp, 2
;-740 }

.checkOpL159:
.checkOpL158:
;-741 

;-742 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC
;-743     int LIx; char *p;

;-744     p = &LabelNames;

;Function : searchLabel, Number local Var: 2
; # type sign width local variables
;300 var sign word LIx = bp-2
;301 ptr sign byte p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax
;-745     LIx = 1;

 mov ax, 1
 mov [bp-2], ax
;-746     while (LIx <= LabelMaxIx) {

.searchLabel160:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel161
;-747         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel162
 mov ax, [bp-2]
 jmp .retnsearchLabel
;-748         p=strlen(p) + p;

.searchLabel162:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax
;-749         p++;

 inc  word[bp-4]
;-750         LIx++;

 inc  word[bp-2]
;-751     }

;-752     return 0;

 jmp .searchLabel160
.searchLabel161:
 mov ax, 0
 jmp .retnsearchLabel
;-753 }

;-754 

;-755 int getOp1() {//scan for a single operand

 .retnsearchLabel:
 LEAVE
 ret
ENDP

getOp1: PROC
;-756 //return:0, IMM, REG, ADR (not MEM)

;-757 //set   :R2Type, R2No by testReg

;-758 //set   :LabelIx by searchLabel

;-759     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1163
 mov ax, 0
 jmp .retngetOp1
;-760     if (TokeType == DIGIT)  return IMM;

.getOp1163:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1164
 mov ax, 1
 jmp .retngetOp1
;-761     if (TokeType == ALNUME) {

.getOp1164:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1165
;-762         R2No=testReg();

 call testReg
 mov byte [R2No], al
;-763         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1166
 mov ax, 2
 jmp .retngetOp1
;-764         LabelIx=searchLabel();

.getOp1166:
 call searchLabel
 mov word [LabelIx], ax
;-765         return ADR;

 mov ax, 3
 jmp .retngetOp1
;-766     }

;-767     return 0;

.getOp1165:
 mov ax, 0
 jmp .retngetOp1
;-768 }

;-769 

;-770 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC
;-771     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1167
 call indexerror
;-772     if (R2No==3) rm=7;//BX

.getIndReg1167:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1168
 mov ax, 7
 mov byte [rm], al
;-773     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1168:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1169
 mov ax, 6
 mov byte [rm], al
;-774     if (R2No==7) rm=5;//DI

.getIndReg1169:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1170
 mov ax, 5
 mov byte [rm], al
;-775     if (R2No==6) rm=4;//SI

.getIndReg1170:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1171
 mov ax, 4
 mov byte [rm], al
;-776     if (rm==0) indexerror();

.getIndReg1171:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1172
 call indexerror
;-777 }

.getIndReg1172:
;-778 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number local Var: 1
; # type sign width local variables
;300 var sign byte m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al
;-779     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2173
 call indexerror
;-780     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2173:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2174
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2175
 mov ax, 3
 mov [bp-2], al
;-781              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2176
.getIndReg2175:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2177
 mov ax, 1
 mov [bp-2], al
;-782     if (R2No==6) if (rm==6) m=2;//BP+SI

.getIndReg2177:
.getIndReg2176:
.getIndReg2174:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg2178
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2179
 mov ax, 2
 mov [bp-2], al
;-783              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2180
.getIndReg2179:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2181
 mov ax, 0
 mov [bp-2], al
;-784     if (m > 3) indexerror();

.getIndReg2181:
.getIndReg2180:
.getIndReg2178:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2182
 call indexerror
;-785     return m;

.getIndReg2182:
 mov al, [bp-2]
 jmp .retngetIndReg2
;-786 }

;-787 int getMEM() {// e.g. [array+bp+si-4]

 .retngetIndReg2:
 LEAVE
 ret
ENDP

getMEM: PROC
;-788 //set: disp, rm, R2Type

;-789     char c;

;-790     disp=0; rm=0;

;Function : getMEM, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al
;-791     do {

.getMEM183:
;-792         getTokeType();

 call getTokeType
;-793         c=getOp1();

 call getOp1
 mov [bp-2], al
;-794         if (R2Type == SEGREG) {//put segment prefix

 mov al, [R2Type]
 cmp al, 4
 jne .getMEM184
;-795             if (R2No == 0) genCode8(0x26);//ES:

 mov al, [R2No]
 cmp al, 0
 jne .getMEM185
 push 38
 call genCode8
 add  sp, 2
;-796             if (R2No == 1) genCode8(0x2E);//CS:

.getMEM185:
 mov al, [R2No]
 cmp al, 1
 jne .getMEM186
 push 46
 call genCode8
 add  sp, 2
;-797             if (R2No == 2) genCode8(0x36);//SS:

.getMEM186:
 mov al, [R2No]
 cmp al, 2
 jne .getMEM187
 push 54
 call genCode8
 add  sp, 2
;-798             if (R2No == 3) genCode8(0x3E);//DS:

.getMEM187:
 mov al, [R2No]
 cmp al, 3
 jne .getMEM188
 push 62
 call genCode8
 add  sp, 2
;-799             if (R2No == 4) genCode8(0x64);//FS:

.getMEM188:
 mov al, [R2No]
 cmp al, 4
 jne .getMEM189
 push 100
 call genCode8
 add  sp, 2
;-800             if (R2No == 5) genCode8(0x65);//GS:

.getMEM189:
 mov al, [R2No]
 cmp al, 5
 jne .getMEM190
 push 101
 call genCode8
 add  sp, 2
;-801             need(':');

.getMEM190:
 push 58
 call need
 add  sp, 2
;-802             c=getOp1();

 call getOp1
 mov [bp-2], al
;-803         }

;-804         if (c ==   0) syntaxerror();

.getMEM184:
 mov al, [bp-2]
 cmp al, 0
 jne .getMEM191
 call syntaxerror
;-805         if (c == REG) {

.getMEM191:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM192
;-806             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al
;-807             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM193
 call getIndReg2
 mov byte [rm], al
;-808             else getIndReg1();

 jmp .getMEM194
.getMEM193:
 call getIndReg1
;-809         }

.getMEM194:
;-810         if (c == ADR) {

.getMEM192:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM195
;-811             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM196
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax
;-812             else notfounderror();

 jmp .getMEM197
.getMEM196:
 call notfounderror
;-813         }

.getMEM197:
;-814         if (c == IMM) disp=disp+SymbolInt;

.getMEM195:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM198
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax
;-815         if (isToken('-')) {

.getMEM198:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM199
;-816             getTokeType();

 call getTokeType
;-817             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM200
 call numbererror
;-818             disp = disp - SymbolInt;

.getMEM200:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax
;-819         }

;-820     } while (isToken('+'));

.getMEM199:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM201
 jmp .getMEM183
.getMEM201:
;-821     if (isToken(']') == 0) error1("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM202
 push getMEM_0
 call error1
 add  sp, 2
;-822 }

.getMEM202:
;-823 

;-824 int getOpR() {

 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC
;-825     Op2=getOp1();

 call getOp1
 mov byte [Op2], al
;-826     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR203
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR
;-827     if (Op2 == 0)     {invaloperror();         return;}

.getOpR203:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR204
 call invaloperror
 jmp .retngetOpR
;-828     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR204:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR205
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR
;-829     if (Op2 == REG)                            return;

.getOpR205:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR206
 jmp .retngetOpR
;-830     if (Op2 == ADR)   {

.getOpR206:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR207
;-831         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR208
 mov ax, 0
 mov word [disp], ax
;-832         else disp=LabelAddr[LabelIx];

 jmp .getOpR209
.getOpR208:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-833         return;}

.getOpR209:
 jmp .retngetOpR
;-834     error1("Name of operand expected");

.getOpR207:
 push getOpR_0
 call error1
 add  sp, 2
;-835 }

;-836 

;-837 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC
;-838     getOpR();

 call getOpR
;-839     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al
;-840     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al
;-841     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al
;-842 }

;-843 

;-844 int get2Ops() {

 ret
ENDP

get2Ops: PROC
;-845     getOpL();

 call getOpL
;-846     need(',');

 push 44
 call need
 add  sp, 2
;-847     getOpR();

 call getOpR
;-848 }

;-849 int check2Ops() {

 ret
ENDP

check2Ops: PROC
;-850     get2Ops();

 call get2Ops
;-851     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops210
 call addrerror
;-852     if (Op == ADR) invaloperror();

.check2Ops210:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops211
 call invaloperror
;-853     if (Op == IMM) immeerror();

.check2Ops211:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops212
 call immeerror
;-854     if (Op2==   0) addrerror();

.check2Ops212:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops213
 call addrerror
;-855     setwflag();

.check2Ops213:
 call setwflag
;-856 }

;-857 

;-858 int storeJmp() {

 ret
ENDP

storeJmp: PROC
;-859     unsigned int i;

;-860     JmpMaxIx++;

;Function : storeJmp, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 inc  word[JmpMaxIx]
;-861     if (JmpMaxIx >= JMPMAX) error1("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp214
 push storeJmp_0
 call error1
 add  sp, 2
;-862     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp214:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax
;-863     JmpNamePtr++;

 inc  word[JmpNamePtr]
;-864     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax
;-865     if ( i >= JMPNAMESMAX) error1("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp215
 push storeJmp_1
 call error1
 add  sp, 2
;-866     JmpAddr[JmpMaxIx] = PC;

.storeJmp215:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax
;-867 }

;-868 

;-869 int storeLabel() {

 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC
;-870     unsigned int i;

;-871     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel216
 push storeLabel_0
 call error1
 add  sp, 2
;-872     LabelMaxIx++;

.storeLabel216:
 inc  word[LabelMaxIx]
;-873     if (LabelMaxIx >= LABELADRMAX) error1("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel217
 push storeLabel_1
 call error1
 add  sp, 2
;-874     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel217:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax
;-875     LabelNamePtr++;

 inc  word[LabelNamePtr]
;-876     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax
;-877     if (i >= LABELNAMESMAX) error1("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel218
 push storeLabel_2
 call error1
 add  sp, 2
;-878     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel218:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-879 }

;-880 

;-881 

;-882 int genDB() {

 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC
;-883     char c;  char isloop;

;-884         isloop = 0;

;Function : genDB, Number local Var: 2
; # type sign width local variables
;300 var sign byte c = bp-2
;301 var sign byte isloop = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-885             do {

.genDB219:
;-886                 if (isloop) getTokeType();//omit ,

 mov al, [bp-4]
 or  al, al
 je .genDB220
 call getTokeType
;-887                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB220:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB221
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-888                 else {

 jmp .genDB222
.genDB221:
;-889                     skipBlank();

 call skipBlank
;-890                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB223
;-891                         do {

.genDB224:
;-892                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-893                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-894                             InputPtr++;

 inc  word[InputPtr]
;-895                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB225
 jmp .genDB224
.genDB225:
;-896                         InputPtr++;

 inc  word[InputPtr]
;-897                     }

;-898                 }

.genDB223:
;-899                 isloop = 1;

.genDB222:
 mov ax, 1
 mov [bp-4], al
;-900             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB226
 jmp .genDB219
.genDB226:
;-901 }

;-902 

;-903 int getVariable() {

 LEAVE
 ret
ENDP

getVariable: PROC
;-904     char c;

;-905     storeLabel();

;Function : getVariable, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 call storeLabel
;-906     getTokeType();

 call getTokeType
;-907     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable227
;-908         lookCode1();

 call lookCode1
;-909         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable228
 call dataexit
;-910         if (CodeType > 205) dataexit();

.getVariable228:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable229
 call dataexit
;-911         if (CodeType== 200) {//DB

.getVariable229:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable230
;-912             do {

.getVariable231:
;-913                 getTokeType();

 call getTokeType
;-914                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable232
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-915                 else {

 jmp .getVariable233
.getVariable232:
;-916                     skipBlank();

 call skipBlank
;-917                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable234
;-918                         do {

.getVariable235:
;-919                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-920                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-921                             InputPtr++;

 inc  word[InputPtr]
;-922                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable236
 jmp .getVariable235
.getVariable236:
;-923                         InputPtr++;

 inc  word[InputPtr]
;-924                     }

;-925                 }

.getVariable234:
;-926             } while (isToken(','));

.getVariable233:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable237
 jmp .getVariable231
.getVariable237:
;-927         }

;-928         if (CodeType == 201) {//DW

.getVariable230:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable238
;-929             do {

.getVariable239:
;-930                 getTokeType();

 call getTokeType
;-931                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable240
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-932             } while (isToken(','));

.getVariable240:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable241
 jmp .getVariable239
.getVariable241:
;-933         }

;-934         if (CodeType == 202) {//DD

.getVariable238:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable242
;-935             do {

.getVariable243:
;-936                 getTokeType();

 call getTokeType
;-937                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable244
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-938                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2
;-939             } while (isToken(','));

.getVariable244:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable245
 jmp .getVariable243
.getVariable245:
;-940         }

;-941         if (CodeType >= 203) {//resb, resw, resd

.getVariable242:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable246
;-942             getTokeType();

 call getTokeType
;-943             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable247
;-944                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable248
 call syntaxerror
;-945                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable248:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable249
 push getVariable_0
 call error1
 add  sp, 2
;-946                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable249:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-947                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable250
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax
;-948                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable250:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable251
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax
;-949                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable251:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-950             } else numbererror();

 jmp .getVariable252
.getVariable247:
 call numbererror
;-951         }

.getVariable252:
;-952     }

.getVariable246:
;-953     else dataexit();

 jmp .getVariable253
.getVariable227:
 call dataexit
;-954 }

.getVariable253:
;-955 

;-956 int getCodeSize() {

 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC
;-957     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize254
;-958         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize255
 call getTokeType
 mov ax, 1
 jmp .retngetCodeSize
;-959         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

.getCodeSize255:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize256
 call getTokeType
 mov ax, 2
 jmp .retngetCodeSize
;-960         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

.getCodeSize256:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize257
 call getTokeType
 mov ax, 3
 jmp .retngetCodeSize
;-961     }

.getCodeSize257:
;-962     return 0;

.getCodeSize254:
 mov ax, 0
 jmp .retngetCodeSize
;-963 }

;-964 

;-965 int FixOneJmp(unsigned int hex) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

FixOneJmp: PROC
;-966     int Ix; char c;

;-967     Ix=searchLabel();

;Function : FixOneJmp, Number local Var: 3
; # type sign width local variables
;300 var unsg word hex = bp+4
;301 var sign word Ix = bp-2
;302 var sign byte c = bp-4;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax
;-968     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp258
 call notfounderror
;-969     disp = LabelAddr[Ix];

.FixOneJmp258:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-970     c = FileBin[hex];//look for 'A' push Absolute

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al
;-971     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp259
;-972         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax
;-973         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax
;-974         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-975     }

;-976     FileBin[hex] = disp;//fix low byte

.FixOneJmp259:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-977     hex++;

 inc  word[bp+4]
;-978     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax
;-979     FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-980 }

;-981 int fixJmp() {

 LEAVE
 ret
ENDP

fixJmp: PROC
;-982     unsigned int hex; int i;

;-983     char *p;

;-984     p = &JmpNames;

;Function : fixJmp, Number local Var: 3
; # type sign width local variables
;300 var unsg word hex = bp-2
;301 var sign word i = bp-4
;302 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax
;-985     i = 1;

 mov ax, 1
 mov [bp-4], ax
;-986     while (i <= JmpMaxIx) {

.fixJmp260:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp261
;-987         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-988         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax
;-989         p++;

 inc  word[bp-6]
;-990         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax
;-991         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2
;-992         i++;

 inc  word[bp-4]
;-993     }

;-994 }

 jmp .fixJmp260
.fixJmp261:
;-995 int fixJmpMain() {

 LEAVE
 ret
ENDP

fixJmpMain: PROC
;-996     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain262
 push fixJmpMain_0
 call error1
 add  sp, 2
;-997     strcpy(Symbol, "main");

.fixJmpMain262:
 push fixJmpMain_1
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-998     FixOneJmp(1);//first instruction, PC=1

 push 1
 call FixOneJmp
 add  sp, 2
;-999 }

;-1000 

;-1001 

;-1002 int process() {

 ret
fixJmpMain_0 db "resting global jmp",0
fixJmpMain_1 db "main",0
ENDP

process: PROC
;-1003     char c;

;-1004     int i;

;-1005     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

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
;-1006     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax
;-1007     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al
;-1008     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType
;-1009     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al
;-1010 

;-1011     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process263
;-1012         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1013         return;

 jmp .retnprocess
;-1014     }

;-1015 

;-1016     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process263:
 mov al, [CodeType]
 cmp al, 2
 jne .process264
;-1017         getOpL();

 call getOpL
;-1018         checkOpL();

 call checkOpL
;-1019         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process265
;-1020   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process266
;-1021                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process267
;-1022                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process268
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4
;-1023                         else   genCode2(0x40, R1No);//INC

 jmp .process269
.process268:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4
;-1024                     return;

.process269:
 jmp .retnprocess
;-1025                     }

;-1026             }

.process267:
;-1027         }

.process266:
;-1028         if (Code1 == 5) {//imul extension?

.process265:
 mov al, [Code1]
 cmp al, 5
 jne .process270
;-1029             getTokeType();

 call getTokeType
;-1030             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process271
 call implerror
;-1031         }

.process271:
;-1032         if (Code1 < 2) genCodeW(0xFE);

.process270:
 mov al, [Code1]
 cmp al, 2
 jge .process272
 push 254
 call genCodeW
 add  sp, 2
;-1033             else genCodeW(0xF6);

 jmp .process273
.process272:
 push 246
 call genCodeW
 add  sp, 2
;-1034         writeEA(Code1);

.process273:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1035         return;

 jmp .retnprocess
;-1036     }

;-1037 

;-1038     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process264:
 mov al, [CodeType]
 cmp al, 3
 jne .process274
;-1039         check2Ops();    //setwflag not applicable

 call check2Ops
;-1040         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process275
 call reg16error
;-1041         if (Op2 != MEM) addrerror();//only m16

.process275:
 mov al, [Op2]
 cmp al, 4
 je  .process276
 call addrerror
;-1042 

;-1043         if (Code1 >= 0xB2) {

.process276:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process277
;-1044             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process278
 push 15
 call genCode8
 add  sp, 2
;-1045         }

.process278:
;-1046         genCode8(Code1);

.process277:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1047         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1048         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1049         return;

 jmp .retnprocess
;-1050     }

;-1051 

;-1052     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process274:
 mov al, [CodeType]
 cmp al, 4
 jne .process279
;-1053         check2Ops();

 call check2Ops
;-1054         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process280
;-1055             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process281
 call notfounderror
;-1056             imme=LabelAddr[LabelIx];

.process281:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax
;-1057             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al
;-1058         }

;-1059         if (Op2 == IMM) {//second operand is imm

.process280:
 mov al, [Op2]
 cmp al, 1
 jne .process282
;-1060             setsflag();

 call setsflag
;-1061             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process283
;-1062                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process284
;-1063                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process285
;-1064                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1065                         c += 4;

 add  byte[bp-2], 4
;-1066                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1067                         genImmediate();

 call genImmediate
;-1068                         return;

 jmp .retnprocess
;-1069                     }

;-1070                 }

.process285:
;-1071             }

.process284:
;-1072             //r/m, imm: 80 sign-extended,TTT,imm

;-1073             c = sflag + 0x80;

.process283:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al
;-1074             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1075             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1076             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process286
 push word [imme]
 call genCode8
 add  sp, 2
;-1077             else genImmediate();

 jmp .process287
.process286:
 call genImmediate
;-1078             return;

.process287:
 jmp .retnprocess
;-1079         }

;-1080         c = Code1 << 3;//r/m, r/r

.process282:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1081         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process288
;-1082             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process289
;-1083                 c += 2;//add direction flag

 add  byte[bp-2], 2
;-1084                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1085                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1086                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1087                 return;

 jmp .retnprocess
;-1088             }

;-1089         }

.process289:
;-1090         if (Op2 == REG) {//mem,reg    reg,reg

.process288:
 mov al, [Op2]
 cmp al, 2
 jne .process290
;-1091             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1092             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1093             return;

 jmp .retnprocess
;-1094         }

;-1095         syntaxerror();

.process290:
 call syntaxerror
;-1096         return;

 jmp .retnprocess
;-1097     }

;-1098 

;-1099     if (CodeType == 5) {//mov (movsx, movzx=51)

.process279:
 mov al, [CodeType]
 cmp al, 5
 jne .process291
;-1100         check2Ops();

 call check2Ops
;-1101         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process292
;-1102             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process293
 mov ax, [disp]
 mov word [imme], ax
;-1103             else notfounderror();

 jmp .process294
.process293:
 call notfounderror
;-1104             Op2=IMM;//continue with IMM

.process294:
 mov ax, 1
 mov byte [Op2], al
;-1105         }

;-1106         if (Op2 == IMM) {// r,i

.process292:
 mov al, [Op2]
 cmp al, 1
 jne .process295
;-1107             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process296
;-1108                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al
;-1109                 c += 0xB0;

 add  byte[bp-2], 176
;-1110                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1111                 genImmediate();

 call genImmediate
;-1112                 return;

 jmp .retnprocess
;-1113             }

;-1114             if (Op == MEM) {// m,i

.process296:
 mov al, [Op]
 cmp al, 4
 jne .process297
;-1115                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2
;-1116                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2
;-1117                 genImmediate();

 call genImmediate
;-1118                 return;

 jmp .retnprocess
;-1119             }

;-1120             regmemerror();

.process297:
 call regmemerror
;-1121             return;

 jmp .retnprocess
;-1122         }

;-1123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process295:
 mov al, [R1Type]
 cmp al, 4
 jne .process298
 call ChangeDirection
;-1124         if (R2Type == SEGREG) {//rm,sreg

.process298:
 mov al, [R2Type]
 cmp al, 4
 jne .process299
;-1125             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process300
 call reg16error
;-1126                 genCode2(0x8C, dflag);

.process300:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4
;-1127                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1128                 return;

 jmp .retnprocess
;-1129         }

;-1130         if (Op2 == MEM) {//acc, moffs16

.process299:
 mov al, [Op2]
 cmp al, 4
 jne .process301
;-1131             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process302
;-1132                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process303
;-1133                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process304
;-1134                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2
;-1135                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1136                         return;

 jmp .retnprocess
;-1137                     }

;-1138                 }

.process304:
;-1139             }

.process303:
;-1140         }

.process302:
;-1141         if (Op == MEM) {//moffs16, acc

.process301:
 mov al, [Op]
 cmp al, 4
 jne .process305
;-1142             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process306
;-1143                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process307
;-1144                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process308
;-1145                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2
;-1146                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1147                         return;

 jmp .retnprocess
;-1148                     }

;-1149                 }

.process308:
;-1150             }

.process307:
;-1151 

;-1152         }

.process306:
;-1153         if (Op2 == REG) {//rm, r

.process305:
 mov al, [Op2]
 cmp al, 2
 jne .process309
;-1154             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2
;-1155             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1156             return;

 jmp .retnprocess
;-1157         }

;-1158         if (Op2 == MEM) {//r, m

.process309:
 mov al, [Op2]
 cmp al, 4
 jne .process310
;-1159             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process311
;-1160                 ChangeDirection();

 call ChangeDirection
;-1161                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2
;-1162                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1163                 return;

 jmp .retnprocess
;-1164             }

;-1165         }

.process311:
;-1166         syntaxerror();

.process310:
 call syntaxerror
;-1167         return;

 jmp .retnprocess
;-1168     }

;-1169 

;-1170     if (CodeType == 6) {//Jcc

.process291:
 mov al, [CodeType]
 cmp al, 6
 jne .process312
;-1171         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process313
;-1172             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1173             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process314
;-1174                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1175                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1176                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1177                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process315
;-1178                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1179                     disp -= 2;

 sub  word[disp], 2
;-1180                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1181                 } else {

 jmp .process316
.process315:
;-1182                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1183                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1184                     disp -= 4;

 sub  word[disp], 4
;-1185                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1186                 }

;-1187             }

.process316:
;-1188             else {//jump forward, near only

 jmp .process317
.process314:
;-1189                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1190                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1191                 storeJmp();

 call storeJmp
;-1192                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2
;-1193                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al
;-1194             }

;-1195         return;

.process317:
 jmp .retnprocess
;-1196         }

;-1197     }

.process313:
;-1198 

;-1199     if (CodeType == 7) {//jmp, call

.process312:
 mov al, [CodeType]
 cmp al, 7
 jne .process318
;-1200         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process319
;-1201             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1202             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process320
;-1203                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1204                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1205                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1206                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process321
;-1207                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process322
;-1208                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2
;-1209                         disp -= 2;

 sub  word[disp], 2
;-1210                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1211                     }

;-1212                     else {

 jmp .process323
.process322:
;-1213                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1214                         disp -= 3;

 sub  word[disp], 3
;-1215                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1216                     }

;-1217                 }

.process323:
;-1218                 else {

 jmp .process324
.process321:
;-1219                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1220                     disp -= 3;

 sub  word[disp], 3
;-1221                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1222                 }

;-1223             }

.process324:
;-1224             else {//jump forward, near only

 jmp .process325
.process320:
;-1225                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1226                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process326
 call storeJmp
;-1227                 genCode16(0);

.process326:
 push 0
 call genCode16
 add  sp, 2
;-1228                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al
;-1229             }

;-1230         return;

.process325:
 jmp .retnprocess
;-1231         }

;-1232     }

.process319:
;-1233 

;-1234     if (CodeType ==  8) {//ret,retf

.process318:
 mov al, [CodeType]
 cmp al, 8
 jne .process327
;-1235         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process328
;-1236             if (Code1 == 0xC3) genCode8(0xC2);//ret n

 mov al, [Code1]
 cmp al, 195
 jne .process329
 push 194
 call genCode8
 add  sp, 2
;-1237                 else genCode8(0xCA);//retf n

 jmp .process330
.process329:
 push 202
 call genCode8
 add  sp, 2
;-1238             genCode16(SymbolInt);

.process330:
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1239             return;

 jmp .retnprocess
;-1240         }

;-1241         genCode8(Code1);

.process328:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1242         return;

 jmp .retnprocess
;-1243     }

;-1244 

;-1245     if (CodeType == 9) {//push, pop

.process327:
 mov al, [CodeType]
 cmp al, 9
 jne .process331
;-1246         getOpL();

 call getOpL
;-1247         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process332
;-1248             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process333
;-1249                 setsflag();

 call setsflag
;-1250                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4
;-1251                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process334
 push word [imme]
 call genCode8
 add  sp, 2
;-1252                 else       genCode16(imme);

 jmp .process335
.process334:
 push word [imme]
 call genCode16
 add  sp, 2
;-1253                 return;

.process335:
 jmp .retnprocess
;-1254             }

;-1255             if (Op == ADR) {//push string ABSOLUTE i16

.process333:
 mov al, [Op]
 cmp al, 3
 jne .process336
;-1256                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process337
;-1257                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1258                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1259                     return;

 jmp .retnprocess
;-1260                 }

;-1261                 else {

 jmp .process338
.process337:
;-1262                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1263                     storeJmp();

 call storeJmp
;-1264                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2
;-1265                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al
;-1266                     return;

 jmp .retnprocess
;-1267                 }

;-1268             }

.process338:
;-1269         }

.process336:
;-1270         if (R1Type == SEGREG) {

.process332:
 mov al, [R1Type]
 cmp al, 4
 jne .process339
;-1271             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process340
;-1272                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process341
 push process_0
 call error1
 add  sp, 2
;-1273             }

.process341:
;-1274             c = R1No <<3;

.process340:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al
;-1275             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process342
;-1276                 c += 122;  //0x7A

 add  byte[bp-2], 122
;-1277                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1278             }

;-1279             if (Code1 == 0x50) c +=6;//push

.process342:
 mov al, [Code1]
 cmp al, 80
 jne .process343
 add  byte[bp-2], 6
;-1280                 else c += 7;//pop

 jmp .process344
.process343:
 add  byte[bp-2], 7
;-1281             genCode8(c);

.process344:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1282             return;

 jmp .retnprocess
;-1283         }

;-1284         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

.process339:
 call checkOpL
;-1285 

;-1286         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process345
;-1287             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process346
;-1288                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2
;-1289                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2
;-1290             }else {

 jmp .process347
.process346:
;-1291                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2
;-1292                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2
;-1293             }

;-1294             return;

.process347:
 jmp .retnprocess
;-1295         }

;-1296         if (R1Type == BYTE) reg16error();

.process345:
 mov al, [R1Type]
 cmp al, 1
 jne .process348
 call reg16error
;-1297         if (R1Type == WORD) {//is REG, w/o SEGREG

.process348:
 mov al, [R1Type]
 cmp al, 2
 jne .process349
;-1298             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1299             return;

 jmp .retnprocess
;-1300         }

;-1301         syntaxerror();

.process349:
 call syntaxerror
;-1302         return;

 jmp .retnprocess
;-1303     }

;-1304 

;-1305     if (CodeType == 11) {//shift, rotate

.process331:
 mov al, [CodeType]
 cmp al, 11
 jne .process350
;-1306         check2Ops();

 call check2Ops
;-1307         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process351
;-1308             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process352
;-1309                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2
;-1310                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1311                 return;

 jmp .retnprocess
;-1312             }

;-1313             genCodeW(0xC0);//80186

.process352:
 push 192
 call genCodeW
 add  sp, 2
;-1314             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1315             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2
;-1316             return;

 jmp .retnprocess
;-1317         }

;-1318         if (Op2 == REG) {

.process351:
 mov al, [Op2]
 cmp al, 2
 jne .process353
;-1319             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process354
;-1320                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process355
;-1321                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process356
 mov ax, 1
 mov byte [wflag], al
;-1322                     genCodeW(0xD2);

.process356:
 push 210
 call genCodeW
 add  sp, 2
;-1323                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1324                     return;

 jmp .retnprocess
;-1325                 }

;-1326             }

.process355:
;-1327         }

.process354:
;-1328     }

.process353:
;-1329 

;-1330     if (CodeType == 12) {//int

.process350:
 mov al, [CodeType]
 cmp al, 12
 jne .process357
;-1331         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process358
;-1332             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1333             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1334             return;

 jmp .retnprocess
;-1335         }

;-1336     }

.process358:
;-1337 

;-1338     if (CodeType == 14) {//in, out

.process357:
 mov al, [CodeType]
 cmp al, 14
 jne .process359
;-1339         implerror();

 call implerror
;-1340         return;

 jmp .retnprocess
;-1341     }

;-1342     if (CodeType == 15) {//xchg

.process359:
 mov al, [CodeType]
 cmp al, 15
 jne .process360
;-1343         implerror();

 call implerror
;-1344         return;

 jmp .retnprocess
;-1345     }

;-1346     if (CodeType == 16) {//loop

.process360:
 mov al, [CodeType]
 cmp al, 16
 jne .process361
;-1347         implerror();

 call implerror
;-1348         return;

 jmp .retnprocess
;-1349     }

;-1350 

;-1351     if (CodeType == 30) {//enter i18,i8

.process361:
 mov al, [CodeType]
 cmp al, 30
 jne .process362
;-1352         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2
;-1353         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1354         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process363
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1355         else numbererror();

 jmp .process364
.process363:
 call numbererror
;-1356         need(',');

.process364:
 push 44
 call need
 add  sp, 2
;-1357         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1358         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process365
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1359         else numbererror();

 jmp .process366
.process365:
 call numbererror
;-1360         return;

.process366:
 jmp .retnprocess
;-1361     }

;-1362 

;-1363     if (CodeType == 41) {//test

.process362:
 mov al, [CodeType]
 cmp al, 41
 jne .process367
;-1364         implerror();

 call implerror
;-1365         return;

 jmp .retnprocess
;-1366     }

;-1367 

;-1368     if (CodeType == 51) {//movsx, movzx=51

.process367:
 mov al, [CodeType]
 cmp al, 51
 jne .process368
;-1369         implerror();

 call implerror
;-1370         return;

 jmp .retnprocess
;-1371     }

;-1372 

;-1373     if (CodeType==101) {//ORG nn

.process368:
 mov al, [CodeType]
 cmp al, 101
 jne .process369
;-1374         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process370
 call numbererror
;-1375         Origin=SymbolInt;

.process370:
 mov ax, [SymbolInt]
 mov word [Origin], ax
;-1376         return;

 jmp .retnprocess
;-1377     }

;-1378 

;-1379     if (CodeType == 102) {//section, segment

.process369:
 mov al, [CodeType]
 cmp al, 102
 jne .process371
;-1380         //getTokeType();//ignore .bss .text .data

;-1381         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax
;-1382         return;

 jmp .retnprocess
;-1383     }

;-1384 

;-1385     if (CodeType == 110) {//absolute

.process371:
 mov al, [CodeType]
 cmp al, 110
 jne .process372
;-1386         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process373
 call numbererror
;-1387         AbsoluteLab=SymbolInt;

.process373:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-1388         return;

 jmp .retnprocess
;-1389     }

;-1390     if (CodeType == 111) {//name: PROC

.process372:
 mov al, [CodeType]
 cmp al, 111
 jne .process374
;-1391         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process375
;-1392             printstring("\nentering: ");

 push process_1
 call printstring
 add  sp, 2
;-1393             printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-1394             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al
;-1395             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax
;-1396             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax
;-1397             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax
;-1398             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax
;-1399         } else error1("already in PROC");

 jmp .process376
.process375:
 push process_2
 call error1
 add  sp, 2
;-1400         return;

.process376:
 jmp .retnprocess
;-1401     }

;-1402     if (CodeType == 112) {//ENDP

.process374:
 mov al, [CodeType]
 cmp al, 112
 jne .process377
;-1403         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process378
 push process_3
 call error1
 add  sp, 2
;-1404         printstring("\nleaving: ");

.process378:
 push process_4
 call printstring
 add  sp, 2
;-1405         printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-1406         printstring(", loc labels: ");

 push process_5
 call printstring
 add  sp, 2
;-1407         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax
;-1408         printunsigned(i);

 push word [bp-4]
 call printunsigned
 add  sp, 2
;-1409         printstring(", loc jmp forward: ");

 push process_6
 call printstring
 add  sp, 2
;-1410         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax
;-1411         printunsigned(i);

 push word [bp-4]
 call printunsigned
 add  sp, 2
;-1412         fixJmp();

 call fixJmp
;-1413         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1414         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax
;-1415         LabelMaxIx   = tmpLabelMaxIx;

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax
;-1416         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax
;-1417         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax
;-1418         return;

 jmp .retnprocess
;-1419     }

;-1420     if (CodeType == 200) {//db

.process377:
 mov al, [CodeType]
 cmp al, 200
 jne .process379
;-1421         genDB();

 call genDB
;-1422         return;

 jmp .retnprocess
;-1423     }

;-1424 

;-1425     error1("Command not implemented or syntax error");

.process379:
 push process_7
 call error1
 add  sp, 2
;-1426 }

;-1427 

;-1428 int parse() {

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
;-1429     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax
;-1430     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax
;-1431     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax
;-1432     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax
;-1433     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax
;-1434     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1435     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al
;-1436 

;-1437     do {//process a new line

.parse380:
;-1438         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax
;-1439         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al
;-1440         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax
;-1441         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al
;-1442         getLine();

 call getLine
;-1443         if (DOS_NoBytes) {

 mov ax, [DOS_NoBytes]
 or  al, al
 je .parse381
;-1444             InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax
;-1445             getTokeType();//getCode in SymbolUpper,

 call getTokeType
;-1446                           //set TokeType,isLabel by getName

;-1447             if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse382
;-1448                 if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse383
;-1449                   if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse384
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4
;-1450                     storeLabel();

.parse384:
 call storeLabel
;-1451                     InputPtr++;//remove :

 inc  word[InputPtr]
;-1452                     getTokeType();

 call getTokeType
;-1453                 }

;-1454             }

.parse383:
;-1455             if (TokeType == ALNUME) {

.parse382:
 mov al, [TokeType]
 cmp al, 3
 jne .parse385
;-1456                 lookCode1();

 call lookCode1
;-1457                 if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse386
 call process
;-1458                 else getVariable();

 jmp .parse387
.parse386:
 call getVariable
;-1459                 skipRest();

.parse387:
 call skipRest
;-1460             }

;-1461             else if(TokeType >ALNUME)error1(

 jmp .parse388
.parse385:
 mov al, [TokeType]
 cmp al, 3
 jle .parse389
;-1462                 "Label or instruction expected");

 push parse_0
 call error1
 add  sp, 2
;-1463             else if(TokeType==DIGIT )error1(

 jmp .parse390
.parse389:
 mov al, [TokeType]
 cmp al, 1
 jne .parse391
;-1464                 "No digit allowed at start");

 push parse_1
 call error1
 add  sp, 2
;-1465             printLine();

.parse391:
.parse390:
.parse388:
 call printLine
;-1466         }

;-1467     } while (DOS_NoBytes != 0 );

.parse381:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse392
 jmp .parse380
.parse392:
;-1468     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al
;-1469 }

;-1470 

;-1471 int getarg() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start",0
ENDP

getarg: PROC
;-1472     int arglen1; int i; char *c;

;-1473     arglen1=*arglen;

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
;-1474     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg393
;-1475         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-1476         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2
;-1477         exitR(3);

 push 3
 call exitR
 add  sp, 2
;-1478     }

;-1479     i=arglen1+129;

.getarg393:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax
;-1480     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
;-1481     arglen1--;

 dec  word[bp-2]
;-1482     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2
;-1483 

;-1484     strcpy(namein, argv); strcat1(namein, ".S");

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
;-1485     strcpy(namelst,argv); strcat1(namelst,".LST");

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
;-1486     strcpy(namebin,argv); strcat1(namebin,".COM");

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
;-1487 

;-1488   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax
;-1489 

;-1490     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax
;-1491     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg394
;-1492         cputs("Source file missing: ");

 push getarg_4
 call cputs
 add  sp, 2
;-1493         cputs(namein);

 lea  ax, [namein]
 push ax
 call cputs
 add  sp, 2
;-1494         exitR(1);

 push 1
 call exitR
 add  sp, 2
;-1495     }

;-1496     lst_fd=creatR(namelst);

.getarg394:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax
;-1497     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg395
;-1498         cputs("can not create list file: ");

 push getarg_5
 call cputs
 add  sp, 2
;-1499         cputs(namelst);

 lea  ax, [namelst]
 push ax
 call cputs
 add  sp, 2
;-1500         exitR(2);

 push 2
 call exitR
 add  sp, 2
;-1501     }

;-1502     printstring(";");

.getarg395:
 push getarg_6
 call printstring
 add  sp, 2
;-1503     printstring(Version1);

 lea  ax, [Version1]
 push ax
 call printstring
 add  sp, 2
;-1504     printstring(", Input: "); printstring(namein);

 push getarg_7
 call printstring
 add  sp, 2
 lea  ax, [namein]
 push ax
 call printstring
 add  sp, 2
;-1505 }

;-1506 

;-1507 int main() {

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
ENDP

main: PROC
;-1508     getarg();

 call getarg
;-1509     parse();

 call parse
;-1510     fixJmpMain();

 call fixJmpMain
;-1511     epilog();

 call epilog
;-1512 }

 ret
ENDP
;Glob. variables:159 (300), Functions:86 (300), Lines:1513
;Constant: 658 (3000), stacksize: 3382