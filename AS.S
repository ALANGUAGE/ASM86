;PLA compiler A.COM V0.9.6, Input: AS.C, Output: AS.S
org  256 
jmp main
;-1 char Version1[]="ASM.C V1.0.2";//Assembler like NASM

Version1 db "ASM.C V1.0.2",0
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
;-379     printLine();

 call printLine
;-380     printstring("\n*** ERROR: ");

 push error1_0
 call printstring
 add  sp, 2
;-381     printstring(s);

 push word [bp+4]
 call printstring
 add  sp, 2
;-382     printstring(", Symbol >>");

 push error1_1
 call printstring
 add  sp, 2
;-383     printstring(Symbol);

 lea  ax, [Symbol]
 push ax
 call printstring
 add  sp, 2
;-384     printstring("<< in proc ");

 push error1_2
 call printstring
 add  sp, 2
;-385     printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-386     epilog();

 call epilog
;-387 }

;-388 int notfounderror(){error1("label not found: ");}

 LEAVE
 ret
error1_0 db "\n*** ERROR: ",0
error1_1 db ", Symbol >>",0
error1_2 db "<< in proc ",0
ENDP

notfounderror: PROC
 push notfounderror_0
 call error1
 add  sp, 2
;-389 int dataexit()     {error1("DB,DW,DD or RESB,W,D expected");}

 ret
notfounderror_0 db "label not found: ",0
ENDP

dataexit: PROC
 push dataexit_0
 call error1
 add  sp, 2
;-390 int addrerror()    {error1("address missing");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2
;-391 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2
;-392 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2
;-393 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2
;-394 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2
;-395 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2
;-396 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2
;-397 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2
;-398 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2
;-399 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2
;-400 

;-401 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
syntaxerror_0 db "syntax",0
ENDP

ifEOL: PROC
;-402   if (c == 10) return 1;//LF

;Function : ifEOL, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL87
 mov ax, 1
 jmp .retnifEOL
;-403   if (c == 13) {//CR

.ifEOL87:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL88
;-404     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-405     if (DOS_ByteRead != 10) error1("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL89
 push ifEOL_0
 call error1
 add  sp, 2
;-406     return 1;

.ifEOL89:
 mov ax, 1
 jmp .retnifEOL
;-407   }

;-408   return 0;

.ifEOL88:
 mov ax, 0
 jmp .retnifEOL
;-409 }

;-410 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL:
 LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC
;-411   unsigned int i;

;-412   InputPtr= &InputBuf;

;Function : getLine, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax
;-413   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-414   do {

.getLine90:
;-415     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-416     if (DOS_ERR) error1("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine91
 push getLine_0
 call error1
 add  sp, 2
;-417     if (DOS_NoBytes == 0) return;

.getLine91:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine92
 jmp .retngetLine
;-418     *InputPtr = DOS_ByteRead;

.getLine92:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al
;-419     InputPtr++;

 inc  word[InputPtr]
;-420     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax
;-421     if (i >= INPUTBUFMAX) error1("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine93
 push getLine_1
 call error1
 add  sp, 2
;-422   } while (ifEOL(DOS_ByteRead) == 0);

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
;-423   InputPtr--;

 dec  word[InputPtr]
;-424   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-425 }

;-426 int skipBlank() {

 .retngetLine:
 LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC
;-427   skipblank1:

.skipblank1:
;-428     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank95
 inc  word[InputPtr]
 jmp .skipblank1
;-429     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank95:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank96
 inc  word[InputPtr]
 jmp .skipblank1
;-430 }

.skipBlank96:
;-431 

;-432 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC
;-433   unsigned int CastInt;

;-434   SymbolInt=0;

;Function : getDigit, Number local Var: 2
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 var unsg word CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax
;-435   do {

.getDigit97:
;-436     c-='0';

 sub  byte[bp+4], 48
;-437     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax
;-438     ax=0;

 mov  ax, 0
;-439     CastInt=c; //cast b2w

 mov al, [bp+4]
 mov [bp-2], ax
;-440     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax
;-441     InputPtr++;

 inc  word[InputPtr]
;-442     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-443   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit98
 jmp .getDigit97
.getDigit98:
;-444 }

;-445 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel

 LEAVE
 ret
ENDP

getName: PROC
;-446   char *p; unsigned int i;

;-447   p = &Symbol;

;Function : getName, Number local Var: 3
; # type sign width local variables
;300 var unsg byte c = bp+4
;301 ptr sign byte p = bp-2
;302 var unsg word i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax
;-448   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-449   p++;

 inc  word[bp-2]
;-450   while (alnumE(c)) {

.getName99:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName100
;-451     InputPtr++;

 inc  word[InputPtr]
;-452     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-453     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-454     p++;

 inc  word[bp-2]
;-455     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax
;-456     if (i >= SYMBOLMAX) error1("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName101
 push getName_0
 call error1
 add  sp, 2
;-457   }

.getName101:
;-458   if (c == ':') isLabel=1; else isLabel=0;

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
;-459   p--;

.getName103:
 dec  word[bp-2]
;-460   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-461   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4
;-462   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2
;-463 }

;-464 

;-465 //OpName, 0, CodeType, Code1

;-466 //  1:   1 byte opcod

;-467 char T00[]={'P','U','S','H','A',0,1,0x60, 'P','O','P','A',0,    1,0x61};

 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
T00 db 80,85,83,72,65,0,1,96,80,79,80,65,0,1,97
;-468 char T01[]={'N','O','P',0,        1,0x90, 'C','B','W',0,        1,0x98};

T01 db 78,79,80,0,1,144,67,66,87,0,1,152
;-469 char T02[]={'C','W','D','E',0,    1,0x98, 'C','W','D',0,        1,0x99};

T02 db 67,87,68,69,0,1,152,67,87,68,0,1,153
;-470 char T03[]={'C','D','Q',0,        1,0x99, 'W','A','I','T',0,    1,0x9B};

T03 db 67,68,81,0,1,153,87,65,73,84,0,1,155
;-471 char T04[]={'P','U','S','H','F',0,1,0x9C, 'P','O','P','F',0,    1,0x9D};

T04 db 80,85,83,72,70,0,1,156,80,79,80,70,0,1,157
;-472 char T05[]={'S','A','H','F',0,    1,0x9E, 'L','A','H','F',0,    1,0x9F};

T05 db 83,65,72,70,0,1,158,76,65,72,70,0,1,159
;-473 char T06[]={'M','O','V','S','B',0,1,0xA4, 'M','O','V','S','W',0,1,0xA5};

T06 db 77,79,86,83,66,0,1,164,77,79,86,83,87,0,1,165
;-474 char T07[]={'C','M','P','S','B',0,1,0xA6, 'C','M','P','S','W',0,1,0xA7};

T07 db 67,77,80,83,66,0,1,166,67,77,80,83,87,0,1,167
;-475 char T08[]={'S','T','O','S','B',0,1,0xAA, 'S','T','O','S','W',0,1,0xAB};

T08 db 83,84,79,83,66,0,1,170,83,84,79,83,87,0,1,171
;-476 char T09[]={'L','O','D','S','B',0,1,0xAC, 'L','O','D','S','W',0,1,0xAD};

T09 db 76,79,68,83,66,0,1,172,76,79,68,83,87,0,1,173
;-477 char T10[]={'S','C','A','S','B',0,1,0xAE, 'S','C','A','S','W',0,1,0xAF};

T10 db 83,67,65,83,66,0,1,174,83,67,65,83,87,0,1,175
;-478 char T11[]={'L','E','A','V','E',0,1,0xC9, 'I','N','T','3',0,    1,0xCC};

T11 db 76,69,65,86,69,0,1,201,73,78,84,51,0,1,204
;-479 char T12[]={'I','N','T','O',0,    1,0xCE, 'I','R','E','T',0,    1,0xCF};

T12 db 73,78,84,79,0,1,206,73,82,69,84,0,1,207
;-480 char T13[]={'X','L','A','T',0,    1,0xD7, 'L','O','C','K',0,    1,0xF0};

T13 db 88,76,65,84,0,1,215,76,79,67,75,0,1,240
;-481 char T14[]={'R','E','P','N','E',0,1,0xF2, 'R','E','P','N','Z',0,1,0xF2};

T14 db 82,69,80,78,69,0,1,242,82,69,80,78,90,0,1,242
;-482 char T15[]={'R','E','P','E',0,    1,0xF3, 'R','E','P','Z',0,    1,0xF3};

T15 db 82,69,80,69,0,1,243,82,69,80,90,0,1,243
;-483 char T16[]={'H','L','T',0,        1,0xF4, 'C','L','C',0,        1,0xF8};

T16 db 72,76,84,0,1,244,67,76,67,0,1,248
;-484 char T17[]={'S','T','C',0,        1,0xF9, 'C','L','I',0,        1,0xFA};

T17 db 83,84,67,0,1,249,67,76,73,0,1,250
;-485 char T18[]={'S','T','I',0,        1,0xFB, 'C','L','D',0,        1,0xFC};

T18 db 83,84,73,0,1,251,67,76,68,0,1,252
;-486 char T19[]={'S','T','D',0,        1,0xFD};

T19 db 83,84,68,0,1,253
;-487 // 2: mem reg 16 bit

;-488 char T20[]={'I','N','C',0,        2, 0,   'D','E','C',0,        2, 1};

T20 db 73,78,67,0,2,0,68,69,67,0,2,1
;-489 char T21[]={'N','O','T',0,        2, 2,   'N','E','G',0,        2, 3};

T21 db 78,79,84,0,2,2,78,69,71,0,2,3
;-490 char T22[]={'M','U','L',0,        2, 4,   'I','M','U','L',0,    2, 5};

T22 db 77,85,76,0,2,4,73,77,85,76,0,2,5
;-491 //IMUL acc only

;-492 char T23[]={'D','I','V',0,        2, 6,   'I','D','I','V',0,    2, 7};

T23 db 68,73,86,0,2,6,73,68,73,86,0,2,7
;-493 //  3: les, lda, lea, lss, lfs, lgs

;-494 char T24[]={'L','E','S',0,        3,0xC4, 'L','D','S',0,        3,0xC5};

T24 db 76,69,83,0,3,196,76,68,83,0,3,197
;-495 char T25[]={'L','E','A',0,        3,0x8D, 'L','S','S',0,        3,0xB2};

T25 db 76,69,65,0,3,141,76,83,83,0,3,178
;-496 char T26[]={'L','F','S',0,        3,0xB4, 'L','G','S',0,        3,0xB5};

T26 db 76,70,83,0,3,180,76,71,83,0,3,181
;-497 //  4: acc,imm  reg,imm  index,reg

;-498 char T27[]={'A','D','D',0,        4, 0,   'O','R',0,            4, 1};

T27 db 65,68,68,0,4,0,79,82,0,4,1
;-499 char T28[]={'A','D','C',0,        4, 2,   'S','B','B',0,        4, 3};

T28 db 65,68,67,0,4,2,83,66,66,0,4,3
;-500 char T29[]={'A','N','D',0,        4, 4,   'S','U','B',0,        4, 5};

T29 db 65,78,68,0,4,4,83,85,66,0,4,5
;-501 char T30[]={'X','O','R',0,        4, 6,   'C','M','P',0,        4, 7};

T30 db 88,79,82,0,4,6,67,77,80,0,4,7
;-502 //  5: mov

;-503 char T31[]={'M','O','V',0,        5, 0};

T31 db 77,79,86,0,5,0
;-504 //  6: single byte relative jump

;-505 char T32[]={'J','O',0,            6, 0,    'J','N','O',0,       6, 1};

T32 db 74,79,0,6,0,74,78,79,0,6,1
;-506 char T33[]={'J','B',0,            6, 2,    'J','C',0,           6, 2};

T33 db 74,66,0,6,2,74,67,0,6,2
;-507 char T34[]={'J','N','B',0,        6, 3};

T34 db 74,78,66,0,6,3
;-508 char T35[]={'J','A','E',0,        6, 3,    'J','N','C',0,       6, 3};

T35 db 74,65,69,0,6,3,74,78,67,0,6,3
;-509 char T36[]={'J','E',0,            6, 4,    'J','Z',0,           6, 4};

T36 db 74,69,0,6,4,74,90,0,6,4
;-510 char T37[]={'J','N','E',0,        6, 5,    'J','N','Z',0,       6, 5};

T37 db 74,78,69,0,6,5,74,78,90,0,6,5
;-511 char T38[]={'J','B','E',0,        6, 6,    'J','N','A',0,       6, 6};

T38 db 74,66,69,0,6,6,74,78,65,0,6,6
;-512 char T39[]={'J','A',0,            6, 7,    'J','S',0,           6, 8};

T39 db 74,65,0,6,7,74,83,0,6,8
;-513 char T40[]={'J','N','S',0,        6, 9};

T40 db 74,78,83,0,6,9
;-514 char T41[]={'J','P',0,            6,10,    'J','P','E',0,       6,10};

T41 db 74,80,0,6,10,74,80,69,0,6,10
;-515 char T42[]={'J','N','P',0,        6,11,    'J','P','O',0,       6,11};

T42 db 74,78,80,0,6,11,74,80,79,0,6,11
;-516 char T43[]={'J','L',0,            6,12};

T43 db 74,76,0,6,12
;-517 char T44[]={'J','N','L',0,        6,13,    'J','G','E',0,       6,13};

T44 db 74,78,76,0,6,13,74,71,69,0,6,13
;-518 char T45[]={'J','L','E',0,        6,14,    'J','N','G',0,       6,14};

T45 db 74,76,69,0,6,14,74,78,71,0,6,14
;-519 char T46[]={'J','G',0,            6,15};

T46 db 74,71,0,6,15
;-520 //  7: jmp, call

;-521 char T47[]={'J','M','P',0,        7,0xE9,  'C','A','L','L',0,   7,0xE8};

T47 db 74,77,80,0,7,233,67,65,76,76,0,7,232
;-522 //  8: ret

;-523 char T48[]={'R','E','T',0,        8,0xC3,  'R','E','T','F',0,   8,0xCB};

T48 db 82,69,84,0,8,195,82,69,84,70,0,8,203
;-524 //  9: seg, r/m

;-525 char T49[]={'P','U','S','H',0,    9,0x50,  'P','O','P',0,       9,0x58};

T49 db 80,85,83,72,0,9,80,80,79,80,0,9,88
;-526 //  11: shift, rotates

;-527 char T50[]={'R','O','L',0,       11, 0,    'R','O','R',0,      11, 1};

T50 db 82,79,76,0,11,0,82,79,82,0,11,1
;-528 char T51[]={'R','C','L',0,       11, 2,    'R','C','R',0,      11, 3};

T51 db 82,67,76,0,11,2,82,67,82,0,11,3
;-529 char T52[]={'S','H','L',0,       11, 4,    'S','A','L',0,      11, 4};

T52 db 83,72,76,0,11,4,83,65,76,0,11,4
;-530 char T53[]={'S','H','R',0,       11, 5,    'S','A','R',0,      11, 7};

T53 db 83,72,82,0,11,5,83,65,82,0,11,7
;-531 //  12: int

;-532 char T54[]={'I','N','T',0,       12,0xCD};

T54 db 73,78,84,0,12,205
;-533 //  14: in/out                   not implemented

;-534 char T55[]={'I','N',0,           14,0xE4,  'I','N','S','B',0,  14,0x6C};

T55 db 73,78,0,14,228,73,78,83,66,0,14,108
;-535 char T56[]={'I','N','S','W',0,   14,0x6D,  'I','N','S','D',0,  14,0x6D};

T56 db 73,78,83,87,0,14,109,73,78,83,68,0,14,109
;-536 char T57[]={'O','U','T',0,       14,0xE6,  'O','U','T','B',0,  14,0x6E};

T57 db 79,85,84,0,14,230,79,85,84,66,0,14,110
;-537 char T58[]={'O','U','T','W',0,   14,0x6F,  'O','U','T','D',0,  14,0x6F};

T58 db 79,85,84,87,0,14,111,79,85,84,68,0,14,111
;-538 //  15: xch                      not implemented

;-539 char T59[]={'X','C','H','G',0,   15,0x86};

T59 db 88,67,72,71,0,15,134
;-540 //  16: loop, jcxz               not implemented

;-541 char T60 []={'L','O','O','P','N','Z',0,16,0xE0};

T60 db 76,79,79,80,78,90,0,16,224
;-542 char T60a[]={'L','O','O','P','N','E',0,16,0xE0};

T60a db 76,79,79,80,78,69,0,16,224
;-543 char T61[]={'L','O','O','P','Z',0,16,0xE1,'L','O','O','P','E',0,16,0xE1};

T61 db 76,79,79,80,90,0,16,225,76,79,79,80,69,0,16,225
;-544 char T62[]={'L','O','O','P',0,    16,0xE2};

T62 db 76,79,79,80,0,16,226
;-545 char T63[]={'J','C','X','Z',0,    16,0xE3,'J','E','C','X','Z',0,16,0xE3};

T63 db 74,67,88,90,0,16,227,74,69,67,88,90,0,16,227
;-546 //  30: other

;-547 char T64[]={'E','N','T','E','R',0,30,0};

T64 db 69,78,84,69,82,0,30,0
;-548 //                                not implemented

;-549 char T65[]={'T','E','S','T',0,    41,0xF6};

T65 db 84,69,83,84,0,41,246
;-550 char T66[]={'M','O','V','S','X',0,51,0xBE,'M','O','V','Z','X',0,51,0xB6};

T66 db 77,79,86,83,88,0,51,190,77,79,86,90,88,0,51,182
;-551 // 100: directives

;-552 char T67[]={'O','R','G',0,      101, 0};

T67 db 79,82,71,0,101,0
;-553 // section, segment .TEXT .DATA .BSS

;-554 char T68[]={'S','E','C','T','I','O','N',0,      102, 0};

T68 db 83,69,67,84,73,79,78,0,102,0
;-555 char T69[]={'S','E','G','M','E','N','T',0,      102, 0};

T69 db 83,69,71,77,69,78,84,0,102,0
;-556 char T70[]={'A','B','S','O','L','U','T','E',0,  110, 0};

T70 db 65,66,83,79,76,85,84,69,0,110,0
;-557 char T71[]={'P','R','O','C',0,    111, 0, 'E','N','D','P',0, 112, 0};

T71 db 80,82,79,67,0,111,0,69,78,68,80,0,112,0
;-558 char T72[]={'D','B',0,            200, 0, 'D','W',0,         201, 0};

T72 db 68,66,0,200,0,68,87,0,201,0
;-559 char T73[]={'D','D',0,            202, 0, 'R','E','S','B',0, 203, 0};

T73 db 68,68,0,202,0,82,69,83,66,0,203,0
;-560 char T74[]={'R','E','S','W',0,    204, 0, 'R','E','S','D',0, 205, 0};

T74 db 82,69,83,87,0,204,0,82,69,83,68,0,205,0
;-561 char TEND=0;// end of table char

TEND db 0
;-562 

;-563 int lookCode1() {//ret: CodeType, Code1


lookCode1: PROC
;-564     OpCodePtr= &T00;

 mov ax, T00
 mov word [OpCodePtr], ax
;-565     do  {

.lookCode1104:
;-566         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode1105
;-567             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1106:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1107
 inc  word[OpCodePtr]
;-568             OpCodePtr++;

 jmp .lookCode1106
.lookCode1107:
 inc  word[OpCodePtr]
;-569             CodeType = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al
;-570             OpCodePtr++;

 inc  word[OpCodePtr]
;-571             Code1    = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al
;-572             return;

 jmp .retnlookCode1
;-573         }

;-574         while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1105:
.lookCode1108:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1109
 inc  word[OpCodePtr]
;-575         OpCodePtr += 3;

 jmp .lookCode1108
.lookCode1109:
 add  word[OpCodePtr], 3
;-576 

;-577         } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1110
 jmp .lookCode1104
.lookCode1110:
;-578     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al
;-579 }

;-580 

;-581 

;-582 int genCode8(char c) {

 .retnlookCode1:
 ret
ENDP

genCode8: PROC
;-583 //set: BinLen++, OpPrintIndex++

;-584     FileBin[BinLen]=c;

;Function : genCode8, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
;-585     BinLen++;

 inc  word[BinLen]
;-586     PC++;

 inc  word[PC]
;-587     if (BinLen >= FILEBINMAX) error1("COM file too long");

 mov ax, [BinLen]
 cmp ax, 25000 ;unsigned : 0
 jb  .genCode8111
 push genCode8_0
 call error1
 add  sp, 2
;-588     if (OpPrintIndex < OPMAXLEN) {

.genCode8111:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8112
;-589         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
;-590         OpPrintIndex++;

 inc  word[OpPrintIndex]
;-591     }

;-592 }

.genCode8112:
;-593 int gen66h() {genCode8(0x66);

 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2
;-594 }

;-595 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC
;-596     c = c + d;

;Function : genCode2, Number local Var: 2
; # type sign width local variables
;300 var sign byte c = bp+4
;301 var sign byte d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al
;-597     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-598 }

;-599 int genCodeW(char c) {

 LEAVE
 ret
ENDP

genCodeW: PROC
;-600     c = c + wflag;

;Function : genCodeW, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al
;-601     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-602 }

;-603 int genCode16(unsigned int i) {

 LEAVE
 ret
ENDP

genCode16: PROC
;-604     genCode8(i); i=i >> 8;

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
;-605     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2
;-606 }

;-607 int genCode32(unsigned long L) {

 LEAVE
 ret
ENDP

genCode32: PROC
;-608     genCode16(L); L=L >>16;

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
;-609     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
;-610 }

;-611 int writeEA(char xxx) {//value for reg/operand

 LEAVE
 ret
ENDP

writeEA: PROC
;-612 //need: Op, Op2, disp, R1No, R2No, rm, isDirect

;-613 //mod-bits: mode76, reg/opcode543, r/m210

;-614 //Op: 0, IMM, REG, ADR, MEM

;-615     int disploc;

;-616     char len;

;-617     len=0;

;Function : writeEA, Number local Var: 3
; # type sign width local variables
;300 var sign byte xxx = bp+4
;301 var sign word disploc = bp-2
;302 var sign byte len = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-618     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al
;-619     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA113
;-620         xxx |= 0xC0;

 or  byte[bp+4], 192
;-621         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA114
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-622             else {

 jmp .writeEA115
.writeEA114:
;-623                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA116
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-624                 else            xxx = xxx + R2No;

 jmp .writeEA117
.writeEA116:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al
;-625             }

.writeEA117:
;-626         }

.writeEA115:
;-627     if (Op == MEM) {

.writeEA113:
 mov al, [Op]
 cmp al, 4
 jne .writeEA118
;-628         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA119
;-629             xxx |= 6;

 or  byte[bp+4], 6
;-630             len = 2;

 mov ax, 2
 mov [bp-4], al
;-631         }

;-632         else {

 jmp .writeEA120
.writeEA119:
;-633             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al
;-634             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA121
;-635                 len=1;

 mov ax, 1
 mov [bp-4], al
;-636                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA122
 or  byte[bp+4], 64
;-637             }

.writeEA122:
;-638 

;-639             if (disp) {

.writeEA121:
 mov ax, [disp]
 or  al, al
 je .writeEA123
;-640                 disploc=disp;

 mov ax, [disp]
 mov [bp-2], ax
;-641                 if (disploc  < 0) disploc=mkneg(disploc);

 mov ax, [bp-2]
 cmp ax, 0
 jge .writeEA124
 push word [bp-2]
 call mkneg
 add  sp, 2
 mov [bp-2], ax
;-642                 if (disploc > 127) len=2;

.writeEA124:
 mov ax, [bp-2]
 cmp ax, 127
 jle .writeEA125
 mov ax, 2
 mov [bp-4], al
;-643                 else len=1;

 jmp .writeEA126
.writeEA125:
 mov ax, 1
 mov [bp-4], al
;-644                 if (len == 1) xxx |= 0x40;

.writeEA126:
 mov al, [bp-4]
 cmp al, 1
 jne .writeEA127
 or  byte[bp+4], 64
;-645                 else xxx |= 0x80;

 jmp .writeEA128
.writeEA127:
 or  byte[bp+4], 128
;-646             }

.writeEA128:
;-647         }

.writeEA123:
;-648     }

.writeEA120:
;-649 

;-650     genCode8(xxx);// gen second byte

.writeEA118:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-651     if (len == 1) genCode8 (disp);

 mov al, [bp-4]
 cmp al, 1
 jne .writeEA129
 push word [disp]
 call genCode8
 add  sp, 2
;-652     if (len == 2) genCode16(disp);

.writeEA129:
 mov al, [bp-4]
 cmp al, 2
 jne .writeEA130
 push word [disp]
 call genCode16
 add  sp, 2
;-653 }

.writeEA130:
;-654 

;-655 int genImmediate() {

 LEAVE
 ret
ENDP

genImmediate: PROC
;-656     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate131
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate132
 push word [imme]
 call genCode32
 add  sp, 2
;-657         //todo imme long

;-658         else genCode16(imme);

 jmp .genImmediate133
.genImmediate132:
 push word [imme]
 call genCode16
 add  sp, 2
;-659     else       genCode8 (imme);

.genImmediate133:
 jmp .genImmediate134
.genImmediate131:
 push word [imme]
 call genCode8
 add  sp, 2
;-660 }

.genImmediate134:
;-661 

;-662 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC
;-663     wflag=0;

 mov ax, 0
 mov byte [wflag], al
;-664     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag135
;-665         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag136
 mov al, [R1Type]
 mov byte [OpSize], al
;-666         if (Op2== REG) OpSize=R2Type;

.setwflag136:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag137
 mov al, [R2Type]
 mov byte [OpSize], al
;-667         if (R2Type== SEGREG) OpSize=WORD;

.setwflag137:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag138
 mov ax, 2
 mov byte [OpSize], al
;-668         if (R1Type == SEGREG) OpSize=WORD;

.setwflag138:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag139
 mov ax, 2
 mov byte [OpSize], al
;-669     }

.setwflag139:
;-670     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag135:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag140
 call gen66h
 mov ax, 1
 mov byte [wflag], al
;-671     if (OpSize  ==  WORD) wflag=1;

.setwflag140:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag141
 mov ax, 1
 mov byte [wflag], al
;-672 }

.setwflag141:
;-673 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC
;-674     unsigned int ui;

;-675     sflag=2;

;Function : setsflag, Number local Var: 1
; # type sign width local variables
;300 var unsg word ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al
;-676     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax
;-677     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag142
 mov ax, 0
 mov byte [sflag], al
;-678     if (OpSize == BYTE) {

.setsflag142:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag143
;-679         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag144
 push setsflag_0
 call error1
 add  sp, 2
;-680         sflag=0;//byte reg does not need sign extended

.setsflag144:
 mov ax, 0
 mov byte [sflag], al
;-681     }

;-682 }

.setsflag143:
;-683 int checkConstSize(unsigned int ui) {

 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC
;-684     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number local Var: 1
; # type sign width local variables
;300 var unsg word ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize145
 mov ax, 0
 jmp .retncheckConstSize
;-685     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize145:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize146
 mov ax, 0
 jmp .retncheckConstSize
;-686     return 2;// is short

.checkConstSize146:
 mov ax, 2
 jmp .retncheckConstSize
;-687 }

;-688 

;-689 

;-690 int ChangeDirection() {

 .retncheckConstSize:
 LEAVE
 ret
ENDP

ChangeDirection: PROC
;-691     char c;

;-692     c=Op;     Op    =Op2;    Op2   =c;

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
;-693     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al
;-694     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al
;-695     dflag=2;

 mov ax, 2
 mov byte [dflag], al
;-696 }

;-697 

;-698 int getTokeType() {

 LEAVE
 ret
ENDP

getTokeType: PROC
;-699     char c;

;-700     skipBlank();

;Function : getTokeType, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 call skipBlank
;-701     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-702     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType147
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-703     if (c == ';') {TokeType=0; return; }//comment

.getTokeType147:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType148
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-704     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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
;-705     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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
;-706     TokeType=NOALNUME;

.getTokeType150:
 mov ax, 4
 mov byte [TokeType], al
;-707 }

;-708 

;-709 int isToken(char c) {

 .retngetTokeType:
 LEAVE
 ret
ENDP

isToken: PROC
;-710     skipBlank();

;Function : isToken, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp+4;
 ENTER  0,0
 call skipBlank
;-711     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken151
;-712         InputPtr++;

 inc  word[InputPtr]
;-713         return 1;

 mov ax, 1
 jmp .retnisToken
;-714         }

;-715     return 0;

.isToken151:
 mov ax, 0
 jmp .retnisToken
;-716 }

;-717 

;-718 

;-719 int need(char c) {

 .retnisToken:
 LEAVE
 ret
ENDP

need: PROC
;-720     if (isToken(c)) {

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
;-721         getTokeType();

 call getTokeType
;-722         return;

 jmp .retnneed
;-723         }

;-724     printstring(" need: ");

.need152:
 push need_0
 call printstring
 add  sp, 2
;-725     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-726     error1("character misssing");

 push need_1
 call error1
 add  sp, 2
;-727 }

;-728 int skipRest() {

 .retnneed:
 LEAVE
 ret
need_0 db " need: ",0
need_1 db "character misssing",0
ENDP

skipRest: PROC
;-729     getTokeType();

 call getTokeType
;-730     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest153
 push skipRest_0
 call error1
 add  sp, 2
;-731 }

.skipRest153:
;-732 

;-733 

;-734 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC
;-735     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL154
 call implerror
;-736     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL154:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL155
 call segregerror
 jmp .retncheckOpL
;-737     setwflag();

.checkOpL155:
 call setwflag
;-738     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL156
 push checkOpL_0
 call error1
 add  sp, 2
;-739     if (OpSize == R1Type) return;

.checkOpL156:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL157
 jmp .retncheckOpL
;-740     if (Op == REG) if (R1Type==0) error1("no register defined");

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
;-741 }

.checkOpL159:
.checkOpL158:
;-742 

;-743 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC
;-744     int LIx; char *p;

;-745     p = &LabelNames;

;Function : searchLabel, Number local Var: 2
; # type sign width local variables
;300 var sign word LIx = bp-2
;301 ptr sign byte p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax
;-746     LIx = 1;

 mov ax, 1
 mov [bp-2], ax
;-747     while (LIx <= LabelMaxIx) {

.searchLabel160:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel161
;-748         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel162
 mov ax, [bp-2]
 jmp .retnsearchLabel
;-749         p=strlen(p) + p;

.searchLabel162:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax
;-750         p++;

 inc  word[bp-4]
;-751         LIx++;

 inc  word[bp-2]
;-752     }

;-753     return 0;

 jmp .searchLabel160
.searchLabel161:
 mov ax, 0
 jmp .retnsearchLabel
;-754 }

;-755 

;-756 int getOp1() {//scan for a single operand

 .retnsearchLabel:
 LEAVE
 ret
ENDP

getOp1: PROC
;-757 //return:0, IMM, REG, ADR (not MEM)

;-758 //set   :R2Type, R2No by testReg

;-759 //set   :LabelIx by searchLabel

;-760     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1163
 mov ax, 0
 jmp .retngetOp1
;-761     if (TokeType == DIGIT)  return IMM;

.getOp1163:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1164
 mov ax, 1
 jmp .retngetOp1
;-762     if (TokeType == ALNUME) {

.getOp1164:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1165
;-763         R2No=testReg();

 call testReg
 mov byte [R2No], al
;-764         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1166
 mov ax, 2
 jmp .retngetOp1
;-765         LabelIx=searchLabel();

.getOp1166:
 call searchLabel
 mov word [LabelIx], ax
;-766         return ADR;

 mov ax, 3
 jmp .retngetOp1
;-767     }

;-768     return 0;

.getOp1165:
 mov ax, 0
 jmp .retngetOp1
;-769 }

;-770 

;-771 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC
;-772     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1167
 call indexerror
;-773     if (R2No==3) rm=7;//BX

.getIndReg1167:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1168
 mov ax, 7
 mov byte [rm], al
;-774     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1168:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1169
 mov ax, 6
 mov byte [rm], al
;-775     if (R2No==7) rm=5;//DI

.getIndReg1169:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1170
 mov ax, 5
 mov byte [rm], al
;-776     if (R2No==6) rm=4;//SI

.getIndReg1170:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1171
 mov ax, 4
 mov byte [rm], al
;-777     if (rm==0) indexerror();

.getIndReg1171:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1172
 call indexerror
;-778 }

.getIndReg1172:
;-779 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number local Var: 1
; # type sign width local variables
;300 var sign byte m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al
;-780     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2173
 call indexerror
;-781     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2173:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2174
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2175
 mov ax, 3
 mov [bp-2], al
;-782              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2176
.getIndReg2175:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2177
 mov ax, 1
 mov [bp-2], al
;-783     if (R2No==6) if (rm==6) m=2;//BP+SI

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
;-784              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2180
.getIndReg2179:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2181
 mov ax, 0
 mov [bp-2], al
;-785     if (m > 3) indexerror();

.getIndReg2181:
.getIndReg2180:
.getIndReg2178:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2182
 call indexerror
;-786     return m;

.getIndReg2182:
 mov al, [bp-2]
 jmp .retngetIndReg2
;-787 }

;-788 int getMEM() {// e.g. [CS: array + bp+si -4]

 .retngetIndReg2:
 LEAVE
 ret
ENDP

getMEM: PROC
;-789 //set: disp, rm, R2Type

;-790     char c;

;-791     disp=0; rm=0;

;Function : getMEM, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al
;-792     do {

.getMEM183:
;-793         getTokeType();

 call getTokeType
;-794         c=getOp1();

 call getOp1
 mov [bp-2], al
;-795         if (R2Type == SEGREG) {//put segment prefix

 mov al, [R2Type]
 cmp al, 4
 jne .getMEM184
;-796             if (R2No == 0) genCode8(0x26);//ES:

 mov al, [R2No]
 cmp al, 0
 jne .getMEM185
 push 38
 call genCode8
 add  sp, 2
;-797             if (R2No == 1) genCode8(0x2E);//CS:

.getMEM185:
 mov al, [R2No]
 cmp al, 1
 jne .getMEM186
 push 46
 call genCode8
 add  sp, 2
;-798             if (R2No == 2) genCode8(0x36);//SS:

.getMEM186:
 mov al, [R2No]
 cmp al, 2
 jne .getMEM187
 push 54
 call genCode8
 add  sp, 2
;-799             if (R2No == 3) genCode8(0x3E);//DS:

.getMEM187:
 mov al, [R2No]
 cmp al, 3
 jne .getMEM188
 push 62
 call genCode8
 add  sp, 2
;-800             if (R2No == 4) genCode8(0x64);//FS:

.getMEM188:
 mov al, [R2No]
 cmp al, 4
 jne .getMEM189
 push 100
 call genCode8
 add  sp, 2
;-801             if (R2No == 5) genCode8(0x65);//GS:

.getMEM189:
 mov al, [R2No]
 cmp al, 5
 jne .getMEM190
 push 101
 call genCode8
 add  sp, 2
;-802             need(':');

.getMEM190:
 push 58
 call need
 add  sp, 2
;-803             getTokeType();

 call getTokeType
;-804             c=getOp1();

 call getOp1
 mov [bp-2], al
;-805         }

;-806         if (c ==   0) syntaxerror();

.getMEM184:
 mov al, [bp-2]
 cmp al, 0
 jne .getMEM191
 call syntaxerror
;-807         if (c == REG) {

.getMEM191:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM192
;-808             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al
;-809             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM193
 call getIndReg2
 mov byte [rm], al
;-810             else getIndReg1();

 jmp .getMEM194
.getMEM193:
 call getIndReg1
;-811         }

.getMEM194:
;-812         if (c == ADR) {

.getMEM192:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM195
;-813             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM196
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax
;-814             else notfounderror();

 jmp .getMEM197
.getMEM196:
 call notfounderror
;-815         }

.getMEM197:
;-816         if (c == IMM) disp=disp+SymbolInt;

.getMEM195:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM198
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax
;-817         if (isToken('-')) {

.getMEM198:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM199
;-818             getTokeType();

 call getTokeType
;-819             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM200
 call numbererror
;-820             disp = disp - SymbolInt;

.getMEM200:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax
;-821         }

;-822     } while (isToken('+'));

.getMEM199:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM201
 jmp .getMEM183
.getMEM201:
;-823     if (isToken(']') == 0) error1("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM202
 push getMEM_0
 call error1
 add  sp, 2
;-824 }

.getMEM202:
;-825 

;-826 int getOpR() {

 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC
;-827     Op2=getOp1();

 call getOp1
 mov byte [Op2], al
;-828     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR203
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR
;-829     if (Op2 == 0)     {invaloperror();         return;}

.getOpR203:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR204
 call invaloperror
 jmp .retngetOpR
;-830     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR204:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR205
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR
;-831     if (Op2 == REG)                            return;

.getOpR205:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR206
 jmp .retngetOpR
;-832     if (Op2 == ADR)   {

.getOpR206:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR207
;-833         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR208
 mov ax, 0
 mov word [disp], ax
;-834         else disp=LabelAddr[LabelIx];

 jmp .getOpR209
.getOpR208:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-835         return;}

.getOpR209:
 jmp .retngetOpR
;-836     error1("Name of operand expected");

.getOpR207:
 push getOpR_0
 call error1
 add  sp, 2
;-837 }

;-838 

;-839 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC
;-840     getOpR();

 call getOpR
;-841     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al
;-842     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al
;-843     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al
;-844 }

;-845 

;-846 int get2Ops() {

 ret
ENDP

get2Ops: PROC
;-847     getOpL();

 call getOpL
;-848     need(',');

 push 44
 call need
 add  sp, 2
;-849     getOpR();

 call getOpR
;-850 }

;-851 int check2Ops() {

 ret
ENDP

check2Ops: PROC
;-852     get2Ops();

 call get2Ops
;-853     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops210
 call addrerror
;-854     if (Op == ADR) invaloperror();

.check2Ops210:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops211
 call invaloperror
;-855     if (Op == IMM) immeerror();

.check2Ops211:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops212
 call immeerror
;-856     if (Op2==   0) addrerror();

.check2Ops212:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops213
 call addrerror
;-857     setwflag();

.check2Ops213:
 call setwflag
;-858 }

;-859 

;-860 int storeJmp() {

 ret
ENDP

storeJmp: PROC
;-861     unsigned int i;

;-862     JmpMaxIx++;

;Function : storeJmp, Number local Var: 1
; # type sign width local variables
;300 var unsg word i = bp-2;
 ENTER  2,0
 inc  word[JmpMaxIx]
;-863     if (JmpMaxIx >= JMPMAX) error1("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp214
 push storeJmp_0
 call error1
 add  sp, 2
;-864     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp214:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax
;-865     JmpNamePtr++;

 inc  word[JmpNamePtr]
;-866     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax
;-867     if ( i >= JMPNAMESMAX) error1("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp215
 push storeJmp_1
 call error1
 add  sp, 2
;-868     JmpAddr[JmpMaxIx] = PC;

.storeJmp215:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax
;-869 }

;-870 

;-871 int storeLabel() {

 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC
;-872     unsigned int i;

;-873     if(searchLabel()) error1("duplicate label");

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
;-874     LabelMaxIx++;

.storeLabel216:
 inc  word[LabelMaxIx]
;-875     if (LabelMaxIx >= LABELADRMAX) error1("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel217
 push storeLabel_1
 call error1
 add  sp, 2
;-876     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel217:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax
;-877     LabelNamePtr++;

 inc  word[LabelNamePtr]
;-878     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax
;-879     if (i >= LABELNAMESMAX) error1("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel218
 push storeLabel_2
 call error1
 add  sp, 2
;-880     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel218:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-881 }

;-882 

;-883 

;-884 int genDB() {

 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC
;-885     char c;  char isloop;

;-886         isloop = 0;

;Function : genDB, Number local Var: 2
; # type sign width local variables
;300 var sign byte c = bp-2
;301 var sign byte isloop = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-887             do {

.genDB219:
;-888                 if (isloop) getTokeType();//omit ,

 mov al, [bp-4]
 or  al, al
 je .genDB220
 call getTokeType
;-889                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB220:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB221
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-890                 else {

 jmp .genDB222
.genDB221:
;-891                     skipBlank();

 call skipBlank
;-892                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB223
;-893                         do {

.genDB224:
;-894                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-895                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-896                             InputPtr++;

 inc  word[InputPtr]
;-897                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB225
 jmp .genDB224
.genDB225:
;-898                         InputPtr++;

 inc  word[InputPtr]
;-899                     }

;-900                 }

.genDB223:
;-901                 isloop = 1;

.genDB222:
 mov ax, 1
 mov [bp-4], al
;-902             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB226
 jmp .genDB219
.genDB226:
;-903 }

;-904 

;-905 int getVariable() {

 LEAVE
 ret
ENDP

getVariable: PROC
;-906     char c;

;-907     storeLabel();

;Function : getVariable, Number local Var: 1
; # type sign width local variables
;300 var sign byte c = bp-2;
 ENTER  2,0
 call storeLabel
;-908     getTokeType();

 call getTokeType
;-909     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable227
;-910         lookCode1();

 call lookCode1
;-911         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable228
 call dataexit
;-912         if (CodeType > 205) dataexit();

.getVariable228:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable229
 call dataexit
;-913         if (CodeType== 200) {//DB

.getVariable229:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable230
;-914             do {

.getVariable231:
;-915                 getTokeType();

 call getTokeType
;-916                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable232
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-917                 else {

 jmp .getVariable233
.getVariable232:
;-918                     skipBlank();

 call skipBlank
;-919                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable234
;-920                         do {

.getVariable235:
;-921                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-922                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-923                             InputPtr++;

 inc  word[InputPtr]
;-924                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable236
 jmp .getVariable235
.getVariable236:
;-925                         InputPtr++;

 inc  word[InputPtr]
;-926                     }

;-927                 }

.getVariable234:
;-928             } while (isToken(','));

.getVariable233:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable237
 jmp .getVariable231
.getVariable237:
;-929         }

;-930         if (CodeType == 201) {//DW

.getVariable230:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable238
;-931             do {

.getVariable239:
;-932                 getTokeType();

 call getTokeType
;-933                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable240
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-934             } while (isToken(','));

.getVariable240:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable241
 jmp .getVariable239
.getVariable241:
;-935         }

;-936         if (CodeType == 202) {//DD

.getVariable238:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable242
;-937             do {

.getVariable243:
;-938                 getTokeType();

 call getTokeType
;-939                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable244
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-940                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2
;-941             } while (isToken(','));

.getVariable244:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable245
 jmp .getVariable243
.getVariable245:
;-942         }

;-943         if (CodeType >= 203) {//resb, resw, resd

.getVariable242:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable246
;-944             getTokeType();

 call getTokeType
;-945             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable247
;-946                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable248
 call syntaxerror
;-947                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable248:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable249
 push getVariable_0
 call error1
 add  sp, 2
;-948                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable249:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-949                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable250
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax
;-950                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable250:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable251
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax
;-951                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable251:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-952             } else numbererror();

 jmp .getVariable252
.getVariable247:
 call numbererror
;-953         }

.getVariable252:
;-954     }

.getVariable246:
;-955     else dataexit();

 jmp .getVariable253
.getVariable227:
 call dataexit
;-956 }

.getVariable253:
;-957 

;-958 int getCodeSize() {

 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC
;-959     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize254
;-960         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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
;-961         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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
;-962         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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
;-963     }

.getCodeSize257:
;-964     return 0;

.getCodeSize254:
 mov ax, 0
 jmp .retngetCodeSize
;-965 }

;-966 

;-967 int FixOneJmp(unsigned int hex) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

FixOneJmp: PROC
;-968     int Ix; char c;

;-969     Ix=searchLabel();

;Function : FixOneJmp, Number local Var: 3
; # type sign width local variables
;300 var unsg word hex = bp+4
;301 var sign word Ix = bp-2
;302 var sign byte c = bp-4;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax
;-970     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp258
 call notfounderror
;-971     disp = LabelAddr[Ix];

.FixOneJmp258:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-972     c = FileBin[hex];//look for 'A' push Absolute

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al
;-973     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp259
;-974         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax
;-975         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax
;-976         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-977     }

;-978     FileBin[hex] = disp;//fix low byte

.FixOneJmp259:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-979     hex++;

 inc  word[bp+4]
;-980     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax
;-981     FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-982 }

;-983 int fixJmp() {

 LEAVE
 ret
ENDP

fixJmp: PROC
;-984     unsigned int hex; int i;

;-985     char *p;

;-986     p = &JmpNames;

;Function : fixJmp, Number local Var: 3
; # type sign width local variables
;300 var unsg word hex = bp-2
;301 var sign word i = bp-4
;302 ptr sign byte p = bp-6;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax
;-987     i = 1;

 mov ax, 1
 mov [bp-4], ax
;-988     while (i <= JmpMaxIx) {

.fixJmp260:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp261
;-989         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-990         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax
;-991         p++;

 inc  word[bp-6]
;-992         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax
;-993         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2
;-994         i++;

 inc  word[bp-4]
;-995     }

;-996 }

 jmp .fixJmp260
.fixJmp261:
;-997 int fixJmpMain() {

 LEAVE
 ret
ENDP

fixJmpMain: PROC
;-998     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain262
 push fixJmpMain_0
 call error1
 add  sp, 2
;-999     strcpy(Symbol, "main");

.fixJmpMain262:
 push fixJmpMain_1
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-1000     FixOneJmp(1);//first instruction, PC=1

 push 1
 call FixOneJmp
 add  sp, 2
;-1001 }

;-1002 

;-1003 

;-1004 int process() {

 ret
fixJmpMain_0 db "resting global jmp",0
fixJmpMain_1 db "main",0
ENDP

process: PROC
;-1005     char c;

;-1006     int i;

;-1007     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

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
;-1008     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax
;-1009     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al
;-1010     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType
;-1011     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al
;-1012 

;-1013     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process263
;-1014         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1015         return;

 jmp .retnprocess
;-1016     }

;-1017 

;-1018     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process263:
 mov al, [CodeType]
 cmp al, 2
 jne .process264
;-1019         getOpL();

 call getOpL
;-1020         checkOpL();

 call checkOpL
;-1021         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process265
;-1022   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process266
;-1023                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process267
;-1024                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process268
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4
;-1025                         else   genCode2(0x40, R1No);//INC

 jmp .process269
.process268:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4
;-1026                     return;

.process269:
 jmp .retnprocess
;-1027                     }

;-1028             }

.process267:
;-1029         }

.process266:
;-1030         if (Code1 == 5) {//imul extension?

.process265:
 mov al, [Code1]
 cmp al, 5
 jne .process270
;-1031             getTokeType();

 call getTokeType
;-1032             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process271
 call implerror
;-1033         }

.process271:
;-1034         if (Code1 < 2) genCodeW(0xFE);

.process270:
 mov al, [Code1]
 cmp al, 2
 jge .process272
 push 254
 call genCodeW
 add  sp, 2
;-1035             else genCodeW(0xF6);

 jmp .process273
.process272:
 push 246
 call genCodeW
 add  sp, 2
;-1036         writeEA(Code1);

.process273:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1037         return;

 jmp .retnprocess
;-1038     }

;-1039 

;-1040     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process264:
 mov al, [CodeType]
 cmp al, 3
 jne .process274
;-1041         check2Ops();    //setwflag not applicable

 call check2Ops
;-1042         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process275
 call reg16error
;-1043         if (Op2 != MEM) addrerror();//only m16

.process275:
 mov al, [Op2]
 cmp al, 4
 je  .process276
 call addrerror
;-1044 

;-1045         if (Code1 >= 0xB2) {

.process276:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process277
;-1046             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process278
 push 15
 call genCode8
 add  sp, 2
;-1047         }

.process278:
;-1048         genCode8(Code1);

.process277:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1049         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1050         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1051         return;

 jmp .retnprocess
;-1052     }

;-1053 

;-1054     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process274:
 mov al, [CodeType]
 cmp al, 4
 jne .process279
;-1055         check2Ops();

 call check2Ops
;-1056         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process280
;-1057             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process281
 call notfounderror
;-1058             imme=LabelAddr[LabelIx];

.process281:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax
;-1059             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al
;-1060         }

;-1061         if (Op2 == IMM) {//second operand is imm

.process280:
 mov al, [Op2]
 cmp al, 1
 jne .process282
;-1062             setsflag();

 call setsflag
;-1063             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process283
;-1064                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process284
;-1065                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process285
;-1066                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1067                         c += 4;

 add  byte[bp-2], 4
;-1068                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1069                         genImmediate();

 call genImmediate
;-1070                         return;

 jmp .retnprocess
;-1071                     }

;-1072                 }

.process285:
;-1073             }

.process284:
;-1074             //r/m, imm: 80 sign-extended,TTT,imm

;-1075             c = sflag + 0x80;

.process283:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al
;-1076             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1077             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1078             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process286
 push word [imme]
 call genCode8
 add  sp, 2
;-1079             else genImmediate();

 jmp .process287
.process286:
 call genImmediate
;-1080             return;

.process287:
 jmp .retnprocess
;-1081         }

;-1082         c = Code1 << 3;//r/m, r/r

.process282:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1083         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process288
;-1084             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process289
;-1085                 c += 2;//add direction flag

 add  byte[bp-2], 2
;-1086                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1087                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1088                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1089                 return;

 jmp .retnprocess
;-1090             }

;-1091         }

.process289:
;-1092         if (Op2 == REG) {//mem,reg    reg,reg

.process288:
 mov al, [Op2]
 cmp al, 2
 jne .process290
;-1093             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1094             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1095             return;

 jmp .retnprocess
;-1096         }

;-1097         syntaxerror();

.process290:
 call syntaxerror
;-1098         return;

 jmp .retnprocess
;-1099     }

;-1100 

;-1101     if (CodeType == 5) {//mov (movsx, movzx=51)

.process279:
 mov al, [CodeType]
 cmp al, 5
 jne .process291
;-1102         check2Ops();

 call check2Ops
;-1103         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process292
;-1104             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process293
 mov ax, [disp]
 mov word [imme], ax
;-1105             else notfounderror();

 jmp .process294
.process293:
 call notfounderror
;-1106             Op2=IMM;//continue with IMM

.process294:
 mov ax, 1
 mov byte [Op2], al
;-1107         }

;-1108         if (Op2 == IMM) {// r,i

.process292:
 mov al, [Op2]
 cmp al, 1
 jne .process295
;-1109             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process296
;-1110                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al
;-1111                 c += 0xB0;

 add  byte[bp-2], 176
;-1112                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1113                 genImmediate();

 call genImmediate
;-1114                 return;

 jmp .retnprocess
;-1115             }

;-1116             if (Op == MEM) {// m,i

.process296:
 mov al, [Op]
 cmp al, 4
 jne .process297
;-1117                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2
;-1118                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2
;-1119                 genImmediate();

 call genImmediate
;-1120                 return;

 jmp .retnprocess
;-1121             }

;-1122             regmemerror();

.process297:
 call regmemerror
;-1123             return;

 jmp .retnprocess
;-1124         }

;-1125         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process295:
 mov al, [R1Type]
 cmp al, 4
 jne .process298
 call ChangeDirection
;-1126         if (R2Type == SEGREG) {//rm,sreg

.process298:
 mov al, [R2Type]
 cmp al, 4
 jne .process299
;-1127             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process300
 call reg16error
;-1128                 genCode2(0x8C, dflag);

.process300:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4
;-1129                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1130                 return;

 jmp .retnprocess
;-1131         }

;-1132         if (Op2 == MEM) {//acc, moffs16

.process299:
 mov al, [Op2]
 cmp al, 4
 jne .process301
;-1133             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process302
;-1134                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process303
;-1135                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process304
;-1136                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2
;-1137                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1138                         return;

 jmp .retnprocess
;-1139                     }

;-1140                 }

.process304:
;-1141             }

.process303:
;-1142         }

.process302:
;-1143         if (Op == MEM) {//moffs16, acc

.process301:
 mov al, [Op]
 cmp al, 4
 jne .process305
;-1144             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process306
;-1145                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process307
;-1146                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process308
;-1147                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2
;-1148                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1149                         return;

 jmp .retnprocess
;-1150                     }

;-1151                 }

.process308:
;-1152             }

.process307:
;-1153 

;-1154         }

.process306:
;-1155         if (Op2 == REG) {//rm, r

.process305:
 mov al, [Op2]
 cmp al, 2
 jne .process309
;-1156             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2
;-1157             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1158             return;

 jmp .retnprocess
;-1159         }

;-1160         if (Op2 == MEM) {//r, m

.process309:
 mov al, [Op2]
 cmp al, 4
 jne .process310
;-1161             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process311
;-1162                 ChangeDirection();

 call ChangeDirection
;-1163                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2
;-1164                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1165                 return;

 jmp .retnprocess
;-1166             }

;-1167         }

.process311:
;-1168         syntaxerror();

.process310:
 call syntaxerror
;-1169         return;

 jmp .retnprocess
;-1170     }

;-1171 

;-1172     if (CodeType == 6) {//Jcc

.process291:
 mov al, [CodeType]
 cmp al, 6
 jne .process312
;-1173         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process313
;-1174             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1175             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process314
;-1176                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1177                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1178                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1179                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process315
;-1180                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1181                     disp -= 2;

 sub  word[disp], 2
;-1182                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1183                 } else {

 jmp .process316
.process315:
;-1184                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1185                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1186                     disp -= 4;

 sub  word[disp], 4
;-1187                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1188                 }

;-1189             }

.process316:
;-1190             else {//jump forward, near only

 jmp .process317
.process314:
;-1191                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1192                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1193                 storeJmp();

 call storeJmp
;-1194                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2
;-1195                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al
;-1196             }

;-1197         return;

.process317:
 jmp .retnprocess
;-1198         }

;-1199     }

.process313:
;-1200 

;-1201     if (CodeType == 7) {//jmp, call

.process312:
 mov al, [CodeType]
 cmp al, 7
 jne .process318
;-1202         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process319
;-1203             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1204             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process320
;-1205                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1206                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1207                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1208                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process321
;-1209                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process322
;-1210                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2
;-1211                         disp -= 2;

 sub  word[disp], 2
;-1212                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1213                     }

;-1214                     else {

 jmp .process323
.process322:
;-1215                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1216                         disp -= 3;

 sub  word[disp], 3
;-1217                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1218                     }

;-1219                 }

.process323:
;-1220                 else {

 jmp .process324
.process321:
;-1221                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1222                     disp -= 3;

 sub  word[disp], 3
;-1223                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1224                 }

;-1225             }

.process324:
;-1226             else {//jump forward, near only

 jmp .process325
.process320:
;-1227                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1228                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process326
 call storeJmp
;-1229                 genCode16(0);

.process326:
 push 0
 call genCode16
 add  sp, 2
;-1230                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al
;-1231             }

;-1232         return;

.process325:
 jmp .retnprocess
;-1233         }

;-1234     }

.process319:
;-1235 

;-1236     if (CodeType ==  8) {//ret,retf

.process318:
 mov al, [CodeType]
 cmp al, 8
 jne .process327
;-1237         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process328
;-1238             if (Code1 == 0xC3) genCode8(0xC2);//ret n

 mov al, [Code1]
 cmp al, 195
 jne .process329
 push 194
 call genCode8
 add  sp, 2
;-1239                 else genCode8(0xCA);//retf n

 jmp .process330
.process329:
 push 202
 call genCode8
 add  sp, 2
;-1240             genCode16(SymbolInt);

.process330:
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1241             return;

 jmp .retnprocess
;-1242         }

;-1243         genCode8(Code1);

.process328:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1244         return;

 jmp .retnprocess
;-1245     }

;-1246 

;-1247     if (CodeType == 9) {//push, pop

.process327:
 mov al, [CodeType]
 cmp al, 9
 jne .process331
;-1248         getOpL();

 call getOpL
;-1249         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process332
;-1250             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process333
;-1251                 setsflag();

 call setsflag
;-1252                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4
;-1253                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process334
 push word [imme]
 call genCode8
 add  sp, 2
;-1254                 else       genCode16(imme);

 jmp .process335
.process334:
 push word [imme]
 call genCode16
 add  sp, 2
;-1255                 return;

.process335:
 jmp .retnprocess
;-1256             }

;-1257             if (Op == ADR) {//push string ABSOLUTE i16

.process333:
 mov al, [Op]
 cmp al, 3
 jne .process336
;-1258                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process337
;-1259                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1260                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1261                     return;

 jmp .retnprocess
;-1262                 }

;-1263                 else {

 jmp .process338
.process337:
;-1264                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1265                     storeJmp();

 call storeJmp
;-1266                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2
;-1267                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al
;-1268                     return;

 jmp .retnprocess
;-1269                 }

;-1270             }

.process338:
;-1271         }

.process336:
;-1272         if (R1Type == SEGREG) {

.process332:
 mov al, [R1Type]
 cmp al, 4
 jne .process339
;-1273             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process340
;-1274                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process341
 push process_0
 call error1
 add  sp, 2
;-1275             }

.process341:
;-1276             c = R1No <<3;

.process340:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al
;-1277             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process342
;-1278                 c += 122;  //0x7A

 add  byte[bp-2], 122
;-1279                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1280             }

;-1281             if (Code1 == 0x50) c +=6;//push

.process342:
 mov al, [Code1]
 cmp al, 80
 jne .process343
 add  byte[bp-2], 6
;-1282                 else c += 7;//pop

 jmp .process344
.process343:
 add  byte[bp-2], 7
;-1283             genCode8(c);

.process344:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1284             return;

 jmp .retnprocess
;-1285         }

;-1286         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

.process339:
 call checkOpL
;-1287 

;-1288         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process345
;-1289             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process346
;-1290                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2
;-1291                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2
;-1292             }else {

 jmp .process347
.process346:
;-1293                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2
;-1294                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2
;-1295             }

;-1296             return;

.process347:
 jmp .retnprocess
;-1297         }

;-1298         if (R1Type == BYTE) reg16error();

.process345:
 mov al, [R1Type]
 cmp al, 1
 jne .process348
 call reg16error
;-1299         if (R1Type == WORD) {//is REG, w/o SEGREG

.process348:
 mov al, [R1Type]
 cmp al, 2
 jne .process349
;-1300             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1301             return;

 jmp .retnprocess
;-1302         }

;-1303         syntaxerror();

.process349:
 call syntaxerror
;-1304         return;

 jmp .retnprocess
;-1305     }

;-1306 

;-1307     if (CodeType == 11) {//shift, rotate

.process331:
 mov al, [CodeType]
 cmp al, 11
 jne .process350
;-1308         check2Ops();

 call check2Ops
;-1309         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process351
;-1310             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process352
;-1311                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2
;-1312                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1313                 return;

 jmp .retnprocess
;-1314             }

;-1315             genCodeW(0xC0);//80186

.process352:
 push 192
 call genCodeW
 add  sp, 2
;-1316             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1317             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2
;-1318             return;

 jmp .retnprocess
;-1319         }

;-1320         if (Op2 == REG) {

.process351:
 mov al, [Op2]
 cmp al, 2
 jne .process353
;-1321             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process354
;-1322                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process355
;-1323                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process356
 mov ax, 1
 mov byte [wflag], al
;-1324                     genCodeW(0xD2);

.process356:
 push 210
 call genCodeW
 add  sp, 2
;-1325                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1326                     return;

 jmp .retnprocess
;-1327                 }

;-1328             }

.process355:
;-1329         }

.process354:
;-1330     }

.process353:
;-1331 

;-1332     if (CodeType == 12) {//int

.process350:
 mov al, [CodeType]
 cmp al, 12
 jne .process357
;-1333         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process358
;-1334             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1335             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1336             return;

 jmp .retnprocess
;-1337         }

;-1338     }

.process358:
;-1339 

;-1340     if (CodeType == 14) {//in, out

.process357:
 mov al, [CodeType]
 cmp al, 14
 jne .process359
;-1341         implerror();

 call implerror
;-1342         return;

 jmp .retnprocess
;-1343     }

;-1344     if (CodeType == 15) {//xchg

.process359:
 mov al, [CodeType]
 cmp al, 15
 jne .process360
;-1345         implerror();

 call implerror
;-1346         return;

 jmp .retnprocess
;-1347     }

;-1348     if (CodeType == 16) {//loop

.process360:
 mov al, [CodeType]
 cmp al, 16
 jne .process361
;-1349         implerror();

 call implerror
;-1350         return;

 jmp .retnprocess
;-1351     }

;-1352 

;-1353     if (CodeType == 30) {//enter i18,i8

.process361:
 mov al, [CodeType]
 cmp al, 30
 jne .process362
;-1354         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2
;-1355         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1356         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process363
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1357         else numbererror();

 jmp .process364
.process363:
 call numbererror
;-1358         need(',');

.process364:
 push 44
 call need
 add  sp, 2
;-1359         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1360         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process365
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1361         else numbererror();

 jmp .process366
.process365:
 call numbererror
;-1362         return;

.process366:
 jmp .retnprocess
;-1363     }

;-1364 

;-1365     if (CodeType == 41) {//test

.process362:
 mov al, [CodeType]
 cmp al, 41
 jne .process367
;-1366         implerror();

 call implerror
;-1367         return;

 jmp .retnprocess
;-1368     }

;-1369 

;-1370     if (CodeType == 51) {//movsx, movzx=51

.process367:
 mov al, [CodeType]
 cmp al, 51
 jne .process368
;-1371         implerror();

 call implerror
;-1372         return;

 jmp .retnprocess
;-1373     }

;-1374 

;-1375     if (CodeType==101) {//ORG nn

.process368:
 mov al, [CodeType]
 cmp al, 101
 jne .process369
;-1376         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process370
 call numbererror
;-1377         Origin=SymbolInt;

.process370:
 mov ax, [SymbolInt]
 mov word [Origin], ax
;-1378         return;

 jmp .retnprocess
;-1379     }

;-1380 

;-1381     if (CodeType == 102) {//section, segment

.process369:
 mov al, [CodeType]
 cmp al, 102
 jne .process371
;-1382         //getTokeType();//ignore .bss .text .data

;-1383         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax
;-1384         return;

 jmp .retnprocess
;-1385     }

;-1386 

;-1387     if (CodeType == 110) {//absolute

.process371:
 mov al, [CodeType]
 cmp al, 110
 jne .process372
;-1388         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process373
 call numbererror
;-1389         AbsoluteLab=SymbolInt;

.process373:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-1390         return;

 jmp .retnprocess
;-1391     }

;-1392     if (CodeType == 111) {//name: PROC

.process372:
 mov al, [CodeType]
 cmp al, 111
 jne .process374
;-1393         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process375
;-1394             printstring("\nentering: ");

 push process_1
 call printstring
 add  sp, 2
;-1395             printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-1396             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al
;-1397             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax
;-1398             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax
;-1399             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax
;-1400             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax
;-1401         } else error1("already in PROC");

 jmp .process376
.process375:
 push process_2
 call error1
 add  sp, 2
;-1402         return;

.process376:
 jmp .retnprocess
;-1403     }

;-1404     if (CodeType == 112) {//ENDP

.process374:
 mov al, [CodeType]
 cmp al, 112
 jne .process377
;-1405         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process378
 push process_3
 call error1
 add  sp, 2
;-1406         printstring("\nleaving: ");

.process378:
 push process_4
 call printstring
 add  sp, 2
;-1407         printstring(ProcName);

 lea  ax, [ProcName]
 push ax
 call printstring
 add  sp, 2
;-1408         printstring(", loc labels: ");

 push process_5
 call printstring
 add  sp, 2
;-1409         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax
;-1410         printunsigned(i);

 push word [bp-4]
 call printunsigned
 add  sp, 2
;-1411         printstring(", loc jmp forward: ");

 push process_6
 call printstring
 add  sp, 2
;-1412         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax
;-1413         printunsigned(i);

 push word [bp-4]
 call printunsigned
 add  sp, 2
;-1414         fixJmp();

 call fixJmp
;-1415         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1416         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax
;-1417         LabelMaxIx   = tmpLabelMaxIx;

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax
;-1418         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax
;-1419         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax
;-1420         return;

 jmp .retnprocess
;-1421     }

;-1422     if (CodeType == 200) {//db

.process377:
 mov al, [CodeType]
 cmp al, 200
 jne .process379
;-1423         genDB();

 call genDB
;-1424         return;

 jmp .retnprocess
;-1425     }

;-1426 

;-1427     error1("Command not implemented or syntax error");

.process379:
 push process_7
 call error1
 add  sp, 2
;-1428 }

;-1429 

;-1430 int parse() {

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
;-1431     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax
;-1432     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax
;-1433     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax
;-1434     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax
;-1435     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax
;-1436     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1437     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al
;-1438 

;-1439     do {//process a new line

.parse380:
;-1440         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax
;-1441         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al
;-1442         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax
;-1443         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al
;-1444         getLine();

 call getLine
;-1445         if (DOS_NoBytes) {

 mov ax, [DOS_NoBytes]
 or  al, al
 je .parse381
;-1446             InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax
;-1447             getTokeType();//getCode in SymbolUpper,

 call getTokeType
;-1448                           //set TokeType,isLabel by getName

;-1449             if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse382
;-1450                 if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse383
;-1451                   if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse384
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4
;-1452                     storeLabel();

.parse384:
 call storeLabel
;-1453                     InputPtr++;//remove :

 inc  word[InputPtr]
;-1454                     getTokeType();

 call getTokeType
;-1455                 }

;-1456             }

.parse383:
;-1457             if (TokeType == ALNUME) {

.parse382:
 mov al, [TokeType]
 cmp al, 3
 jne .parse385
;-1458                 lookCode1();

 call lookCode1
;-1459                 if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse386
 call process
;-1460                 else getVariable();

 jmp .parse387
.parse386:
 call getVariable
;-1461                 skipRest();

.parse387:
 call skipRest
;-1462             }

;-1463             else if(TokeType >ALNUME)error1(

 jmp .parse388
.parse385:
 mov al, [TokeType]
 cmp al, 3
 jle .parse389
;-1464                 "Label or instruction expected");

 push parse_0
 call error1
 add  sp, 2
;-1465             else if(TokeType==DIGIT )error1(

 jmp .parse390
.parse389:
 mov al, [TokeType]
 cmp al, 1
 jne .parse391
;-1466                 "No digit allowed at start");

 push parse_1
 call error1
 add  sp, 2
;-1467             printLine();

.parse391:
.parse390:
.parse388:
 call printLine
;-1468         }

;-1469     } while (DOS_NoBytes != 0 );

.parse381:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse392
 jmp .parse380
.parse392:
;-1470     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al
;-1471 }

;-1472 

;-1473 int getarg() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start",0
ENDP

getarg: PROC
;-1474     int arglen1; int i; char *c;

;-1475     arglen1=*arglen;

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
;-1476     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg393
;-1477         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-1478         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2
;-1479         exitR(3);

 push 3
 call exitR
 add  sp, 2
;-1480     }

;-1481     i=arglen1+129;

.getarg393:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax
;-1482     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
;-1483     arglen1--;

 dec  word[bp-2]
;-1484     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2
;-1485 

;-1486     strcpy(namein, argv); strcat1(namein, ".S");

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
;-1487     strcpy(namelst,argv); strcat1(namelst,".LST");

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
;-1488     strcpy(namebin,argv); strcat1(namebin,".COM");

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
;-1489 

;-1490   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax
;-1491 

;-1492     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax
;-1493     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg394
;-1494         cputs("Source file missing: ");

 push getarg_4
 call cputs
 add  sp, 2
;-1495         cputs(namein);

 lea  ax, [namein]
 push ax
 call cputs
 add  sp, 2
;-1496         exitR(1);

 push 1
 call exitR
 add  sp, 2
;-1497     }

;-1498     lst_fd=creatR(namelst);

.getarg394:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax
;-1499     if(DOS_ERR){

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg395
;-1500         cputs("can not create list file: ");

 push getarg_5
 call cputs
 add  sp, 2
;-1501         cputs(namelst);

 lea  ax, [namelst]
 push ax
 call cputs
 add  sp, 2
;-1502         exitR(2);

 push 2
 call exitR
 add  sp, 2
;-1503     }

;-1504     printstring(";");

.getarg395:
 push getarg_6
 call printstring
 add  sp, 2
;-1505     printstring(Version1);

 lea  ax, [Version1]
 push ax
 call printstring
 add  sp, 2
;-1506     printstring(", Input: "); printstring(namein);

 push getarg_7
 call printstring
 add  sp, 2
 lea  ax, [namein]
 push ax
 call printstring
 add  sp, 2
;-1507 }

;-1508 

;-1509 int main() {

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
;-1510     getarg();

 call getarg
;-1511     parse();

 call parse
;-1512     fixJmpMain();

 call fixJmpMain
;-1513     epilog();

 call epilog
;-1514 }

 ret
ENDP
;Glob. variables:159 (300), Functions:86 (300), Lines:1515
;Constant: 658 (3000), stacksize: 3382