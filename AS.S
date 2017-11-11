
;A.COM V0.9.4, Input: AS.C, Output: AS.S
org  256 
jmp main

;-1 char Version1[]="AS.C V1.0";//Assembler like NASM

Version1 db "AS.C V1.0",0

;-2 #define SYMBOLMAX    31


;-3 char Symbol[SYMBOLMAX]; //next symbol to decode

section .bss
absolute 25000
Symbol resb 31
section .text

;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName

section .bss
absolute 25031
SymbolUpper resb 31
section .text

;-5 char ProcName[SYMBOLMAX];//name of actual proc

section .bss
absolute 25062
ProcName resb 31
section .text

;-6 char isPrint=1;         //print to screen on

isPrint db 1

;-7 char isInProc=0;        //is inside a procedure

isInProc db 0

;-8 unsigned int SymbolInt; //integer value set in getDigit

SymbolInt dw 0

;-9 #define INPUTBUFMAX 255


;-10 char InputBuf[INPUTBUFMAX];//filled in getLine

section .bss
absolute 25093
InputBuf resb 255
section .text

;-11 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0

;-12 char namein [67];       //input file name  .S

section .bss
absolute 25348
namein resb 67
section .text

;-13 char namelst[67];       //list file name   .LST

section .bss
absolute 25415
namelst resb 67
section .text

;-14 char namebin[67];       //output file name .COM

section .bss
absolute 25482
namebin resb 67
section .text

;-15 int  asm_fd;            //input file descriptor

asm_fd dw 0

;-16 int lst_fd;             //list file descriptor

lst_fd dw 0

;-17 int bin_fd;             //output file descriptor

bin_fd dw 0

;-18 int DOS_ERR=0;          //global var

DOS_ERR dw 0

;-19 int ErrorCount=0;       //number of errors

ErrorCount dw 0

;-20 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0

;-21 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0

;-22 


;-23 unsigned int PC=0;      //program counter

PC dw 0

;-24 unsigned int Origin=0;  //ORG nn

Origin dw 0

;-25 unsigned int AbsoluteLab=0;//uninitialised data

AbsoluteLab dw 0

;-26 unsigned int PCStart;   //PC at start of line by PrintLine()

PCStart dw 0

;-27 char isLabel;           //by getName()

isLabel db 0

;-28 #define DIGIT    1      //0-9


;-29 #define LETTERE  2      //a-z A-Z @ . _


;-30 #define ALNUME   3      //a-z A-Z @ . _  0-9


;-31 #define NOALNUME 4      //other char


;-32 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME

TokeType db 0

;-33 #define BYTE     1


;-34 #define WORD     2


;-35 #define DWORD    3


;-36 #define SEGREG   4


;-37 #define IMM      1      //const  ,123


;-38 #define REG      2      //       ,BX    mode=11


;-39 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110


;-40 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16


;-41 char Op;                //1. operand: 0, IMM, REG, ADR, MEM

Op db 0

;-42 char Op2;               //2. operand

Op2 db 0

;-43 char CodeType;          //1-207 by searchSymbol(), must be byte size

CodeType db 0

;-44 char Code1;             //1. Opcode

Code1 db 0

;-45 char R2No;              //0 - 7 AL, CL, ...  set in testReg()

R2No db 0

;-46 char R1No;              //temp for 1. register

R1No db 0

;-47 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG

R2Type db 0

;-48 char R1Type;            //temp for 1. register

R1Type db 0

;-49 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0

;-50 char wflag;             //wordflag: 0=byte, 1=word/dword

wflag db 0

;-51 char dflag;             //directionflag: 1=to reg MOV,ALU

dflag db 0

;-52 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3

sflag db 0

;-53 char rm;                //combination of index and base reg

rm db 0

;-54 char isDirect;          //set in process and getMeM, need in WriteEA

isDirect db 0

;-55 int disp;               //displacement      0-8 bytes

disp dw 0

;-56 unsigned int imme;      //immediate         0-8 bytes

imme dw 0

;-57 


;-58 #define OPMAXLEN 5


;-59 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 25549
OpPos resb 5
section .text

;-60 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0

;-61 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0

;-62 char PrintRA;           //print * for forward relocative jmp

PrintRA db 0

;-63 


;-64 #define LABELNAMESMAX 5969//next number - SYMBOLMAX


;-65 char LabelNames[6000];  //space for names of all labels

section .bss
absolute 25554
LabelNames resb 6000
section .text

;-66 char *LabelNamePtr;     //first free position

LabelNamePtr dw 0

;-67 char *tmpLabelNamePtr;  //set after PROC to LabelNamePtr

tmpLabelNamePtr dw 0

;-68 


;-69 #define LABELADRMAX 600


;-70 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 31554
LabelAddr resw 600
section .text

;-71 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0

;-72 int tmpLabelMaxIx;      //set after PROC to LabelMaxIx

tmpLabelMaxIx dw 0

;-73 int LabelIx;            //actual # of just searched label

LabelIx dw 0

;-74 


;-75 #define JMPNAMESMAX 3969//next number - SYMBOLMAX


;-76 char JmpNames[4000];    //space for names of jmp, call

section .bss
absolute 32754
JmpNames resb 4000
section .text

;-77 char *JmpNamePtr;       //first free position

JmpNamePtr dw 0

;-78 char *tmpJmpNamePtr;    //set after PROC to JmpNamePtr

tmpJmpNamePtr dw 0

;-79 


;-80 #define JMPMAX 200      //max. jmp and call


;-81 unsigned int JmpAddr[JMPMAX];//addr to be fixed

section .bss
absolute 36754
JmpAddr resw 200
section .text

;-82 int JmpMaxIx=0;         //actual # of jmp, call. 1 to JMPMAX-1

JmpMaxIx dw 0

;-83 int tmpJmpMaxIx=0;      //set after PROC to JmpMaxIx

tmpJmpMaxIx dw 0

;-84 


;-85 #define FILEBINMAX 22000


;-86 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 37154
FileBin resb 22000
section .text

;-87 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-88 


;-89 char *arglen=0x80;      // for main only

arglen dw 128

;-90 char *argv=0x82;        // for main only

argv dw 130

;-91 


;-92 


;-93 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }


writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16

;-94 int putch(char c)  {if (c==10) {al=13; writetty();} al=c; writetty(); }

 ret
ENDP

putch: PROC;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
 mov  al, 13
 call writetty
.putch1:
 mov  al, [bp+4]
 call writetty

;-95 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
ENDP

cputs: PROC;
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

;-96 


;-97 int DosInt() {
 LEAVE
 ret
ENDP

DosInt: PROC

;-98     __emit__(0xCD,0x21);//inth 0x21;

 db 205,33

;-99     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4

;-100     DOS_ERR++;

 inc  word[DOS_ERR]

;-101 }


;-102 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-103 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP

creatR: PROC;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-104 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP

fcloseR: PROC;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt

;-105 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP

exitR: PROC;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt

;-106 int readRL(char *s, int fd, int len){
 LEAVE
 ret
ENDP

readRL: PROC

;-107     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-108 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP

fputcR: PROC;
 ENTER  0,0
lea dx, [bp+4]

;-109   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-110 


;-111 int letterE(char c) {
 LEAVE
 ret
ENDP

letterE: PROC

;-112   if (c=='_') return 1;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE4
 mov ax, 1
 jmp .retnletterE

;-113   if (c=='.') return 1;

.letterE4:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE5
 mov ax, 1
 jmp .retnletterE

;-114   if (c=='?') return 1;

.letterE5:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE6
 mov ax, 1
 jmp .retnletterE

;-115   if (c=='$') return 1;

.letterE6:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE7
 mov ax, 1
 jmp .retnletterE

;-116   if (c> 'z') return 0;

.letterE7:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE8
 mov ax, 0
 jmp .retnletterE

;-117   if (c< '@') return 0; // at included

.letterE8:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE9
 mov ax, 0
 jmp .retnletterE

;-118   if (c> 'Z') { if (c< 'a') return 0; }

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

;-119   return 1;

.letterE10:
 mov ax, 1
 jmp .retnletterE

;-120 }


;-121 int digit(char c){

 .retnletterE: LEAVE
 ret
ENDP

digit: PROC

;-122     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit12
 mov ax, 0
 jmp .retndigit

;-123     if(c>'9') return 0;

.digit12:
 mov al, [bp+4]
 cmp al, 57
 jle .digit13
 mov ax, 0
 jmp .retndigit

;-124     return 1;

.digit13:
 mov ax, 1
 jmp .retndigit

;-125 }


;-126 int alnumE(char c) {

 .retndigit: LEAVE
 ret
ENDP

alnumE: PROC

;-127   if (digit(c)) return 1;
;
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

;-128   if (letterE(c)) return 1;

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

;-129   return 0;

.alnumE15:
 mov ax, 0
 jmp .retnalnumE

;-130 }


;-131 int strlen(char *s) { int c;

 .retnalnumE: LEAVE
 ret
ENDP

strlen: PROC

;-132     c=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax

;-133     while (*s!=0) {s++; c++;}

.strlen16:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen17
 inc  word[bp+4]
 inc  word[bp-2]

;-134     return c;

 jmp .strlen16
.strlen17:
 mov ax, [bp-2]
 jmp .retnstrlen

;-135     }


;-136 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP

strcpy: PROC

;-137     do { *s=*t; s++; t++; }
;
 ENTER  0,0
.strcpy18:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]

;-138     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy19
 jmp .strcpy18
.strcpy19:

;-139     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al

;-140     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy

;-141     }


;-142 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP

eqstr: PROC

;-143     while(*p) {
;
 ENTER  0,0
.eqstr20:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr21

;-144         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr22
 mov ax, 0
 jmp .retneqstr

;-145             p++;

.eqstr22:
 inc  word[bp+4]

;-146             q++;

 inc  word[bp+6]

;-147             }


;-148     if(*q) return 0;

 jmp .eqstr20
.eqstr21:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr23
 mov ax, 0
 jmp .retneqstr

;-149     return 1;

.eqstr23:
 mov ax, 1
 jmp .retneqstr

;-150     }


;-151 int strcat1(char *s, char *t) {

 .retneqstr: LEAVE
 ret
ENDP

strcat1: PROC

;-152     while (*s != 0) s++;
;
 ENTER  0,0
.strcat124:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat125
 inc  word[bp+4]

;-153     strcpy(s, t);

 jmp .strcat124
.strcat125:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-154     }


;-155 int toupper(char *s) {
 LEAVE
 ret
ENDP

toupper: PROC

;-156     while(*s) {
;
 ENTER  0,0
.toupper26:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper27

;-157         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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

;-158             s++;

.toupper29:
.toupper28:
 inc  word[bp+4]

;-159               }


;-160     }

 jmp .toupper26
.toupper27:

;-161 


;-162 int testReg() {
 LEAVE
 ret
ENDP

testReg: PROC

;-163 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-164   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al

;-165   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg30
 mov ax, 0
 jmp .retntestReg

;-166   if (strlen(Symbol) > 3) return 0;

.testReg30:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg31
 mov ax, 0
 jmp .retntestReg

;-167   R2Type=BYTE;

.testReg31:
 mov ax, 1
 mov byte [R2Type], al

;-168   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg32
 mov ax, 0
 jmp .retntestReg

;-169   if (eqstr(SymbolUpper, "CL")) return 1;

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

;-170   if (eqstr(SymbolUpper, "DL")) return 2;

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

;-171   if (eqstr(SymbolUpper, "BL")) return 3;

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

;-172   if (eqstr(SymbolUpper, "AH")) return 4;

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

;-173   if (eqstr(SymbolUpper, "CH")) return 5;

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

;-174   if (eqstr(SymbolUpper, "DH")) return 6;

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

;-175   if (eqstr(SymbolUpper, "BH")) return 7;

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

;-176   R2Type=WORD;

.testReg39:
 mov ax, 2
 mov byte [R2Type], al

;-177   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg40
 mov ax, 0
 jmp .retntestReg

;-178   if (eqstr(SymbolUpper, "CX")) return 1;

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

;-179   if (eqstr(SymbolUpper, "DX")) return 2;

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

;-180   if (eqstr(SymbolUpper, "BX")) return 3;

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

;-181   if (eqstr(SymbolUpper, "SP")) return 4;

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

;-182   if (eqstr(SymbolUpper, "BP")) return 5;

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

;-183   if (eqstr(SymbolUpper, "SI")) return 6;

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

;-184   if (eqstr(SymbolUpper, "DI")) return 7;

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

;-185   R2Type=SEGREG;

.testReg47:
 mov ax, 4
 mov byte [R2Type], al

;-186   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg48
 mov ax, 0
 jmp .retntestReg

;-187   if (eqstr(SymbolUpper, "CS")) return 1;

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

;-188   if (eqstr(SymbolUpper, "SS")) return 2;

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

;-189   if (eqstr(SymbolUpper, "DS")) return 3;

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

;-190   if (eqstr(SymbolUpper, "FS")) return 4;

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

;-191   if (eqstr(SymbolUpper, "GS")) return 5;

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

;-192   R2Type=DWORD;

.testReg53:
 mov ax, 3
 mov byte [R2Type], al

;-193   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg54
 mov ax, 0
 jmp .retntestReg

;-194   if (eqstr(SymbolUpper, "ECX"))return 1;

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

;-195   if (eqstr(SymbolUpper, "EDX"))return 2;

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

;-196   if (eqstr(SymbolUpper, "EBX"))return 3;

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

;-197   if (eqstr(SymbolUpper, "ESP"))return 4;

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

;-198   if (eqstr(SymbolUpper, "EBP"))return 5;

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

;-199   if (eqstr(SymbolUpper, "ESI"))return 6;

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

;-200   if (eqstr(SymbolUpper, "EDI"))return 7;

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

;-201   R2Type=0; return 0;

.testReg61:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg

;-202 }


;-203 


;-204 


;-205 int prc(unsigned char c) {//print char

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

;-206     if (isPrint) {
;
 ENTER  0,0
 mov al, [isPrint]
 or  al, al
 je .prc62

;-207         if (c==10) {

 mov al, [bp+4]
 cmp al, 10
 jne .prc63

;-208             ax=13;

 mov  ax, 13

;-209             writetty();

 call writetty

;-210             }


;-211         al=c;

.prc63:
 mov  al, [bp+4]

;-212         writetty(); 

 call writetty

;-213     }


;-214     fputcR(c,lst_fd);

.prc62:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-215 }


;-216 


;-217 int prscomment(unsigned char *s) {
 LEAVE
 ret
ENDP

prscomment: PROC

;-218     unsigned char c;


;-219     while (*s){
;
 ENTER  2,0
.prscomment64:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment65

;-220         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-221         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-222         s++;

 inc  word[bp+4]

;-223     }


;-224 }

 jmp .prscomment64
.prscomment65:

;-225 int prs(unsigned char *s) {
 LEAVE
 ret
ENDP

prs: PROC

;-226     unsigned char c;


;-227     int com;


;-228     com=0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax

;-229     while (*s) {

.prs66:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs67

;-230         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-231         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs68

;-232             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs69
 mov ax, 0
 mov [bp-4], ax

;-233                 else com=1;

 jmp .prs70
.prs69:
 mov ax, 1
 mov [bp-4], ax

;-234         }

.prs70:

;-235         if (c==92) {

.prs68:
 mov al, [bp-2]
 cmp al, 92
 jne .prs71

;-236             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs72

;-237                 s++;

 inc  word[bp+4]

;-238                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-239                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs73
 mov ax, 10
 mov [bp-2], al

;-240                 if (c=='t') c= 9;

.prs73:
 mov al, [bp-2]
 cmp al, 116
 jne .prs74
 mov ax, 9
 mov [bp-2], al

;-241             }

.prs74:

;-242         }

.prs72:

;-243         prc(c);

.prs71:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-244         s++;

 inc  word[bp+4]

;-245     }


;-246 }

 jmp .prs66
.prs67:

;-247 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP

printhex4: PROC

;-248     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48

;-249     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex475
 add  byte[bp+4], 7

;-250     prc(c);

.printhex475:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-251 }


;-252 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP

printhex8a: PROC

;-253     unsigned char nib;


;-254     nib = c >> 4; printhex4(nib);
;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-255     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-256 }


;-257 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP

printhex16: PROC

;-258     unsigned int half;


;-259     half = i >>  8; printhex8a(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-260     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-261 }


;-262 int printIntU(unsigned int n) {
 LEAVE
 ret
ENDP

printIntU: PROC

;-263     unsigned int e;


;-264     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printIntU76

;-265         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax

;-266         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-267     }


;-268     n = n % 10; //unsigned mod

.printIntU76:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax

;-269     n += '0';

 add  word[bp+4], 48

;-270     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-271 }


;-272 int printLine() {
 LEAVE
 ret
ENDP

printLine: PROC

;-273     int i; char c;


;-274     prs("\n");
;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-275     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-276     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine77
 push printLine_1
 call prs
 add  sp, 2

;-277     else {

 jmp .printLine78
.printLine77:

;-278 //        prc(' ');


;-279         i=0;

 mov ax, 0
 mov [bp-2], ax

;-280         do {

.printLine79:

;-281             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al

;-282             prc(' ');

 push 32
 call prc
 add  sp, 2

;-283             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-284             i++;

 inc  word[bp-2]

;-285         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine80
 jmp .printLine79
.printLine80:

;-286         while (i < OPMAXLEN) {// fill rest with blank

.printLine81:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine82

;-287             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-288             i++;

 inc  word[bp-2]

;-289         }


;-290     }

 jmp .printLine81
.printLine82:

;-291     prc(PrintRA);

.printLine78:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-292     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-293 }


;-294 


;-295 int epilog() {
 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

epilog: PROC

;-296     unsigned int i; char c;     int j;


;-297     prs("Errors:");
;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-298     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-299     if (ErrorCount) prs(" *** ERRORS *** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog83
 push epilog_1
 call prs
 add  sp, 2

;-300     prs(", Out: ");

.epilog83:
 push epilog_2
 call prs
 add  sp, 2

;-301     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-302     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-303     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-304     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-305     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-306     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-307     i=0;

 mov ax, 0
 mov [bp-2], ax

;-308     do {

.epilog84:

;-309         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-310         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-311         i++;

 inc  word[bp-2]

;-312     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog85
 jmp .epilog84
.epilog85:

;-313 }


;-314 


;-315 int end1(int n) {
 LEAVE
 ret
epilog_0 db "Errors:",0
epilog_1 db " *** ERRORS *** ",0
epilog_2 db ", Out: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
ENDP

end1: PROC

;-316     fcloseR(asm_fd);
;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-317     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-318     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-319     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-320 }


;-321 


;-322 


;-323 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-324     isPrint=1;
;
 ENTER  0,0
 mov ax, 1
 mov byte [isPrint], al

;-325     ErrorCount++;

 inc  word[ErrorCount]

;-326     prs("\n******* next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-327     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-328     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-329     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-330 }


;-331 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n******* next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-332     error1(s);
;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-333     epilog();

 call epilog

;-334     end1(1);

 push 1
 call end1
 add  sp, 2

;-335 }


;-336 int dataexit(){errorexit("DB,DW,DD or RESB,W,D expected");}
 LEAVE
 ret
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-337 


;-338 int notfounderror(){

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

notfounderror: PROC

;-339     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al

;-340     ErrorCount++;

 inc  word[ErrorCount]

;-341     prs("\n******* ERROR: label not found: ");

 push notfounderror_0
 call prs
 add  sp, 2

;-342     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-343     prs(" ");

 push notfounderror_1
 call prs
 add  sp, 2

;-344 }


;-345 int addrerror()    {error1("address missing");}

 ret
notfounderror_0 db "\n******* ERROR: label not found: ",0
notfounderror_1 db " ",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-346 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-347 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-348 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-349 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-350 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-351 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-352 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-353 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-354 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-355 


;-356 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
syntaxerror_0 db "syntax",0
ENDP

ifEOL: PROC

;-357   if (c == 10) return 1;//LF
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL86
 mov ax, 1
 jmp .retnifEOL

;-358   if (c == 13) {//CR

.ifEOL86:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL87

;-359     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-360     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL88
 push ifEOL_0
 call errorexit
 add  sp, 2

;-361     return 1;

.ifEOL88:
 mov ax, 1
 jmp .retnifEOL

;-362   }


;-363   return 0;

.ifEOL87:
 mov ax, 0
 jmp .retnifEOL

;-364 }


;-365 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC

;-366   unsigned int i;


;-367   InputPtr= &InputBuf;
;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-368   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-369   do {

.getLine89:

;-370     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-371     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine90
 push getLine_0
 call errorexit
 add  sp, 2

;-372     if (DOS_NoBytes == 0) return;

.getLine90:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine91
 jmp .retngetLine

;-373     *InputPtr = DOS_ByteRead;

.getLine91:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-374     InputPtr++;

 inc  word[InputPtr]

;-375     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-376     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine92
 push getLine_1
 call errorexit
 add  sp, 2

;-377   } while (ifEOL(DOS_ByteRead) == 0);

.getLine92:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne .getLine93
 jmp .getLine89
.getLine93:

;-378   InputPtr--;

 dec  word[InputPtr]

;-379   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-380 }


;-381 int skipBlank() {

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC

;-382   skipblank1:

.skipblank1:

;-383     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank94
 inc  word[InputPtr]
 jmp .skipblank1

;-384     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank94:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank95
 inc  word[InputPtr]
 jmp .skipblank1

;-385 }

.skipBlank95:

;-386 


;-387 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC

;-388   unsigned int CastInt;


;-389   SymbolInt=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-390   do {

.getDigit96:

;-391     c-='0';

 sub  byte[bp+4], 48

;-392     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-393     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-394     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-395     InputPtr++;

 inc  word[InputPtr]

;-396     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-397   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit97
 jmp .getDigit96
.getDigit97:

;-398 }


;-399 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-400   char *p; unsigned int i;


;-401   p = &Symbol;
;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-402   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-403   p++;

 inc  word[bp-2]

;-404   while (alnumE(c)) {

.getName98:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName99

;-405     InputPtr++;

 inc  word[InputPtr]

;-406     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-407     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-408     p++;

 inc  word[bp-2]

;-409     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-410     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName100
 push getName_0
 call errorexit
 add  sp, 2

;-411   }

.getName100:

;-412   if (c == ':') isLabel=1; else isLabel=0;

 jmp .getName98
.getName99:
 mov al, [bp+4]
 cmp al, 58
 jne .getName101
 mov ax, 1
 mov byte [isLabel], al
 jmp .getName102
.getName101:
 mov ax, 0
 mov byte [isLabel], al

;-413   p--;

.getName102:
 dec  word[bp-2]

;-414   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-415   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-416   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-417 }


;-418 


;-419 char I_START=0xF1;
 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
I_START db 241

;-420 //OpName, 0, CodeType, OpCode1-n, F1h


;-421 //  1:   1 byte opcode


;-422 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-423 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-424 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-425 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-426 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-427 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-428 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-429 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-430 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-431 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-432 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-433 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-434 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-435 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-436 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-437 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-438 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-439 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-440 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-441 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-442 // 2: mem reg 16 bit


;-443 char I_INC[]=  {'I','N','C',0,          2, 0,0xF1};

I_INC db 73,78,67,0,2,0,241

;-444 char I_DEC[]=  {'D','E','C',0,          2, 1,0xF1};

I_DEC db 68,69,67,0,2,1,241

;-445 char I_NOT[]=  {'N','O','T',0,          2, 2,     0xF1};

I_NOT db 78,79,84,0,2,2,241

;-446 char I_NEG[]=  {'N','E','G',0,          2, 3,     0xF1};

I_NEG db 78,69,71,0,2,3,241

;-447 char I_MUL[]=  {'M','U','L',0,          2, 4,     0xF1};

I_MUL db 77,85,76,0,2,4,241

;-448 char I_IMUL[]= {'I','M','U','L',0,      2, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,5,241

;-449 char I_DIV[]=  {'D','I','V',0,          2, 6,     0xF1};

I_DIV db 68,73,86,0,2,6,241

;-450 char I_IDIV[]= {'I','D','I','V',0,      2, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,7,241

;-451 //  3: les, lda, lea, lss, lfs, lgs


;-452 char I_LES[]=  {'L','E','S',0,          3,0xC4,0xF1};

I_LES db 76,69,83,0,3,196,241

;-453 char I_LDS[]=  {'L','D','S',0,          3,0xC5,0xF1};

I_LDS db 76,68,83,0,3,197,241

;-454 char I_LEA[]=  {'L','E','A',0,          3,0x8D,0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-455 char I_LSS[]=  {'L','S','S',0,          3,0xB2,0xF1};

I_LSS db 76,83,83,0,3,178,241

;-456 char I_LFS[]=  {'L','F','S',0,          3,0xB4,0xF1};

I_LFS db 76,70,83,0,3,180,241

;-457 char I_LGS[]=  {'L','G','S',0,          3,0xB5,0xF1};

I_LGS db 76,71,83,0,3,181,241

;-458 //  4: acc,imm  reg,imm  index,reg


;-459 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-460 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-461 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-462 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-463 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-464 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-465 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-466 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-467 //  5: mov


;-468 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-469 //  6: single byte relative jump


;-470 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-471 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-472 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-473 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-474 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-475 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-476 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-477 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-478 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-479 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-480 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-481 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-482 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-483 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-484 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-485 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-486 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-487 //  7: jmp, call


;-488 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 0xF1};

I_JMP db 74,77,80,0,7,233,241

;-489 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 0xF1};

I_CALL db 67,65,76,76,0,7,232,241

;-490 //  8: ret


;-491 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xF1};

I_RET db 82,69,84,0,8,195,241

;-492 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xF1};

I_RETF db 82,69,84,70,0,8,203,241

;-493 //  9: seg, r/m


;-494 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xF1};

I_PUSH db 80,85,83,72,0,9,80,241

;-495 char I_POP[]=  {'P','O','P',0,          9,0x58,0xF1};

I_POP db 80,79,80,0,9,88,241

;-496 //  11: shift, rotates


;-497 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-498 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-499 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-500 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-501 //  12: int


;-502 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xF1};

I_INT db 73,78,84,0,12,205,241

;-503 //  14: in/out


;-504 char I_IN[]=   {'I','N',0,              14,0xE4,0xF1};

I_IN db 73,78,0,14,228,241

;-505 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-506 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-507 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-508 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xF1};

I_OUT db 79,85,84,0,14,230,241

;-509 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-510 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-511 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-512 //  15: xchg


;-513 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0xF1};

I_XCHG db 88,67,72,71,0,15,134,241

;-514 //  16: loop, jcxz


;-515 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-516 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-517 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-518 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-519 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-520 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-521 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-522 //  30: other


;-523 char I_ENTER[]={'E','N','T','E','R',0, 30,     0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-524 char I_TEST[]= {'T','E','S','T',0,     41,0xF6,0xF1};

I_TEST db 84,69,83,84,0,41,246,241

;-525 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-526 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-527 // 100: directives


;-528 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-529 // section, segment .TEXT .DATA .BSS


;-530 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-531 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-532 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-533 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-534 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-535 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-536 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-537 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-538 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-539 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-540 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-541 char I_END=0;// end of table char

I_END db 0

;-542 


;-543 int lookCode() {//ret: CodeType, *OpCodePtr


lookCode: PROC

;-544     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-545     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-546     OpCodePtr++;

 inc  word[OpCodePtr]

;-547     do  {

.lookCode103:

;-548         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode104

;-549             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode105:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode106
 inc  word[OpCodePtr]

;-550             OpCodePtr++;

 jmp .lookCode105
.lookCode106:
 inc  word[OpCodePtr]

;-551             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-552             return;

 jmp .retnlookCode

;-553         }


;-554     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode104:
.lookCode107:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode108
 inc  word[OpCodePtr]

;-555     OpCodePtr++;

 jmp .lookCode107
.lookCode108:
 inc  word[OpCodePtr]

;-556     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode109
 jmp .lookCode103
.lookCode109:

;-557 }


;-558 


;-559 int genCode8(char c) {

 .retnlookCode:
 ret
ENDP

genCode8: PROC

;-560 //set: BinLen++, OpPrintIndex++


;-561     FileBin[BinLen]=c;
;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-562     BinLen++;

 inc  word[BinLen]

;-563     PC++;

 inc  word[PC]

;-564     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 22000 ;unsigned : 0
 jb  .genCode8110
 push genCode8_0
 call errorexit
 add  sp, 2

;-565     if (OpPrintIndex < OPMAXLEN) {

.genCode8110:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8111

;-566         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-567         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-568     }


;-569 }

.genCode8111:

;-570 int gen66h() {genCode8(0x66);
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-571 }


;-572 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-573     c = c + d;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-574     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-575 }


;-576 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-577     c = c + wflag;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-578     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-579 }


;-580 int genCode16(unsigned int i) {
 LEAVE
 ret
ENDP

genCode16: PROC

;-581     genCode8(i); i=i >> 8;
;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-582     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-583 }


;-584 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-585     genCode16(L); L=L >>16;
;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-586     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-587 }


;-588 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-589 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-590 //mod-bits: mode76, reg/opcode543, r/m210


;-591 //Op: 0, IMM, REG, ADR, MEM


;-592     char len;


;-593     len=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-594     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-595     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA112

;-596         xxx |= 0xC0;

 or  byte[bp+4], 192

;-597         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA113
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-598             else {

 jmp .writeEA114
.writeEA113:

;-599                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA115
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-600                 else            xxx = xxx + R2No;

 jmp .writeEA116
.writeEA115:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-601             }

.writeEA116:

;-602         }

.writeEA114:

;-603     if (Op == MEM) {

.writeEA112:
 mov al, [Op]
 cmp al, 4
 jne .writeEA117

;-604         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA118

;-605             xxx |= 6;

 or  byte[bp+4], 6

;-606             len = 2;

 mov ax, 2
 mov [bp-2], al

;-607         }


;-608         else {

 jmp .writeEA119
.writeEA118:

;-609             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-610             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA120

;-611                 len=1;

 mov ax, 1
 mov [bp-2], al

;-612                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA121
 or  byte[bp+4], 64

;-613             }

.writeEA121:

;-614 


;-615             if (disp) {

.writeEA120:
 mov ax, [disp]
 or  al, al
 je .writeEA122

;-616                 ax = disp;

 mov  ax, [disp]

;-617                 if (ax < 0) __asm{ neg ax }

 cmp  ax, 0
 jge .writeEA123
 neg ax 

;-618                 if (ax > 127) len=2;

.writeEA123:
 cmp  ax, 127
 jle .writeEA124
 mov ax, 2
 mov [bp-2], al

;-619                 else len=1;

 jmp .writeEA125
.writeEA124:
 mov ax, 1
 mov [bp-2], al

;-620                 if (len == 1) xxx |= 0x40;

.writeEA125:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA126
 or  byte[bp+4], 64

;-621                 else xxx |= 0x80;

 jmp .writeEA127
.writeEA126:
 or  byte[bp+4], 128

;-622             }

.writeEA127:

;-623         }

.writeEA122:

;-624     }

.writeEA119:

;-625 


;-626     genCode8(xxx);// gen second byte

.writeEA117:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-627     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA128
 push word [disp]
 call genCode8
 add  sp, 2

;-628     if (len == 2) genCode16(disp);

.writeEA128:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA129
 push word [disp]
 call genCode16
 add  sp, 2

;-629 }

.writeEA129:

;-630 


;-631 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-632     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate130
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate131
 push word [imme]
 call genCode32
 add  sp, 2

;-633         //todo imme long


;-634         else genCode16(imme);

 jmp .genImmediate132
.genImmediate131:
 push word [imme]
 call genCode16
 add  sp, 2

;-635     else       genCode8 (imme);

.genImmediate132:
 jmp .genImmediate133
.genImmediate130:
 push word [imme]
 call genCode8
 add  sp, 2

;-636 }

.genImmediate133:

;-637 


;-638 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC

;-639     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-640     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag134

;-641         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag135
 mov al, [R1Type]
 mov byte [OpSize], al

;-642         if (Op2== REG) OpSize=R2Type;

.setwflag135:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag136
 mov al, [R2Type]
 mov byte [OpSize], al

;-643         if (R2Type== SEGREG) OpSize=WORD;

.setwflag136:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag137
 mov ax, 2
 mov byte [OpSize], al

;-644         if (R1Type == SEGREG) OpSize=WORD;

.setwflag137:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag138
 mov ax, 2
 mov byte [OpSize], al

;-645     }

.setwflag138:

;-646     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag134:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag139
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-647     if (OpSize  ==  WORD) wflag=1;

.setwflag139:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag140
 mov ax, 1
 mov byte [wflag], al

;-648 }

.setwflag140:

;-649 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-650     unsigned int ui;


;-651     sflag=2;
;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-652     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-653     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag141
 mov ax, 0
 mov byte [sflag], al

;-654     if (OpSize == BYTE) {

.setsflag141:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag142

;-655         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag143
 push setsflag_0
 call error1
 add  sp, 2

;-656         sflag=0;//byte reg does not need sign extended

.setsflag143:
 mov ax, 0
 mov byte [sflag], al

;-657     }


;-658 }

.setsflag142:

;-659 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-660     if (ui > 127   ) return 0;//is near; return sflag
;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize144
 mov ax, 0
 jmp .retncheckConstSize

;-661     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize144:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize145
 mov ax, 0
 jmp .retncheckConstSize

;-662     return 2;// is short

.checkConstSize145:
 mov ax, 2
 jmp .retncheckConstSize

;-663 }


;-664 


;-665 


;-666 int ChangeDirection() {

 .retncheckConstSize: LEAVE
 ret
ENDP

ChangeDirection: PROC

;-667     char c;


;-668     c=Op;     Op    =Op2;    Op2   =c;
;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-669     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-670     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-671     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-672 }


;-673 


;-674 int getTokeType() {
 LEAVE
 ret
ENDP

getTokeType: PROC

;-675     char c;


;-676     skipBlank();
;
 ENTER  2,0
 call skipBlank

;-677     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-678     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType146
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-679     if (c == ';') {TokeType=0; return; }//comment

.getTokeType146:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType147
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-680     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

.getTokeType147:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getTokeType148
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov ax, 1
 mov byte [TokeType], al
 jmp .retngetTokeType

;-681     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

.getTokeType148:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .getTokeType149
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov ax, 3
 mov byte [TokeType], al
 jmp .retngetTokeType

;-682     TokeType=NOALNUME;

.getTokeType149:
 mov ax, 4
 mov byte [TokeType], al

;-683 }


;-684 


;-685 int isToken(char c) {

 .retngetTokeType: LEAVE
 ret
ENDP

isToken: PROC

;-686     skipBlank();
;
 ENTER  0,0
 call skipBlank

;-687     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken150

;-688         InputPtr++;

 inc  word[InputPtr]

;-689         return 1;

 mov ax, 1
 jmp .retnisToken

;-690         }


;-691     return 0;

.isToken150:
 mov ax, 0
 jmp .retnisToken

;-692 }


;-693 


;-694 


;-695 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-696     if (isToken(c)) {
;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need151

;-697         getTokeType();

 call getTokeType

;-698         return;

 jmp .retnneed

;-699         }


;-700     error1();

.need151:
 call error1

;-701     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-702     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-703 }


;-704 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-705     getTokeType();

 call getTokeType

;-706     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest152
 push skipRest_0
 call error1
 add  sp, 2

;-707 }

.skipRest152:

;-708 


;-709 


;-710 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC

;-711     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL153
 call implerror

;-712     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL153:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL154
 call segregerror
 jmp .retncheckOpL

;-713     setwflag();

.checkOpL154:
 call setwflag

;-714     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL155
 push checkOpL_0
 call error1
 add  sp, 2

;-715     if (OpSize == R1Type) return;

.checkOpL155:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL156
 jmp .retncheckOpL

;-716     if (Op == REG) if (R1Type==0) error1("no register defined");

.checkOpL156:
 mov al, [Op]
 cmp al, 2
 jne .checkOpL157
 mov al, [R1Type]
 cmp al, 0
 jne .checkOpL158
 push checkOpL_1
 call error1
 add  sp, 2

;-717 }

.checkOpL158:
.checkOpL157:

;-718 


;-719 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC

;-720     int LIx; char *p;


;-721     p = &LabelNames;
;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-722     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-723     while (LIx <= LabelMaxIx) {

.searchLabel159:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel160

;-724         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel161
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-725         p=strlen(p) + p;

.searchLabel161:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-726         p++;

 inc  word[bp-4]

;-727         LIx++;

 inc  word[bp-2]

;-728     }


;-729     return 0;

 jmp .searchLabel159
.searchLabel160:
 mov ax, 0
 jmp .retnsearchLabel

;-730 }


;-731 


;-732 int getOp1() {//scan for a single operand

 .retnsearchLabel: LEAVE
 ret
ENDP

getOp1: PROC

;-733 //return:0, IMM, REG, ADR (not MEM)


;-734 //set   :R2Type, R2No by testReg


;-735 //set   :LabelIx by searchLabel


;-736     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1162
 mov ax, 0
 jmp .retngetOp1

;-737     if (TokeType == DIGIT)  return IMM;

.getOp1162:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1163
 mov ax, 1
 jmp .retngetOp1

;-738     if (TokeType == ALNUME) {

.getOp1163:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1164

;-739         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-740         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1165
 mov ax, 2
 jmp .retngetOp1

;-741         LabelIx=searchLabel();

.getOp1165:
 call searchLabel
 mov word [LabelIx], ax

;-742         return ADR;

 mov ax, 3
 jmp .retngetOp1

;-743     }


;-744     return 0;

.getOp1164:
 mov ax, 0
 jmp .retngetOp1

;-745 }


;-746 


;-747 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC

;-748     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1166
 call indexerror

;-749     if (R2No==3) rm=7;//BX

.getIndReg1166:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1167
 mov ax, 7
 mov byte [rm], al

;-750     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1167:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1168
 mov ax, 6
 mov byte [rm], al

;-751     if (R2No==7) rm=5;//DI

.getIndReg1168:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1169
 mov ax, 5
 mov byte [rm], al

;-752     if (R2No==6) rm=4;//SI

.getIndReg1169:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1170
 mov ax, 4
 mov byte [rm], al

;-753     if (rm==0) indexerror();

.getIndReg1170:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1171
 call indexerror

;-754 }

.getIndReg1171:

;-755 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-756     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2172
 call indexerror

;-757     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2172:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2173
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2174
 mov ax, 3
 mov [bp-2], al

;-758              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2175
.getIndReg2174:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2176
 mov ax, 1
 mov [bp-2], al

;-759     if (R2No==6) if (rm==6) m=2;//BP+SI

.getIndReg2176:
.getIndReg2175:
.getIndReg2173:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg2177
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2178
 mov ax, 2
 mov [bp-2], al

;-760              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2179
.getIndReg2178:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2180
 mov ax, 0
 mov [bp-2], al

;-761     if (m > 3) indexerror();

.getIndReg2180:
.getIndReg2179:
.getIndReg2177:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2181
 call indexerror

;-762     return m;

.getIndReg2181:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-763 }


;-764 int getMEM() {// e.g. [array+bp+si-4]

 .retngetIndReg2: LEAVE
 ret
ENDP

getMEM: PROC

;-765 //set: disp, rm, R2Type


;-766     char c;


;-767     disp=0; rm=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-768     do {

.getMEM182:

;-769         getTokeType();

 call getTokeType

;-770         c=getOp1();

 call getOp1
 mov [bp-2], al

;-771         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM183
 call syntaxerror

;-772         if (c == REG) {

.getMEM183:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM184

;-773             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-774             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM185
 call getIndReg2
 mov byte [rm], al

;-775             else getIndReg1();

 jmp .getMEM186
.getMEM185:
 call getIndReg1

;-776         }

.getMEM186:

;-777         if (c == ADR) {

.getMEM184:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM187

;-778             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM188
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-779             else notfounderror();

 jmp .getMEM189
.getMEM188:
 call notfounderror

;-780         }

.getMEM189:

;-781         if (c == IMM) disp=disp+SymbolInt;

.getMEM187:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM190
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-782         if (isToken('-')) {

.getMEM190:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM191

;-783             getTokeType();

 call getTokeType

;-784             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM192
 call numbererror

;-785             disp = disp - SymbolInt;

.getMEM192:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-786         }


;-787     } while (isToken('+'));

.getMEM191:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM193
 jmp .getMEM182
.getMEM193:

;-788     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM194
 push getMEM_0
 call errorexit
 add  sp, 2

;-789 }

.getMEM194:

;-790 


;-791 int getOpR() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC

;-792     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-793     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR195
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-794     if (Op2 == 0)     {invaloperror();         return;}

.getOpR195:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR196
 call invaloperror
 jmp .retngetOpR

;-795     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR196:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR197
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-796     if (Op2 == REG)                            return;

.getOpR197:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR198
 jmp .retngetOpR

;-797     if (Op2 == ADR)   {

.getOpR198:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR199

;-798         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR200
 mov ax, 0
 mov word [disp], ax

;-799         else disp=LabelAddr[LabelIx];

 jmp .getOpR201
.getOpR200:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-800         return;}

.getOpR201:
 jmp .retngetOpR

;-801     error1("Name of operand expected");

.getOpR199:
 push getOpR_0
 call error1
 add  sp, 2

;-802 }


;-803 


;-804 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC

;-805     getOpR();

 call getOpR

;-806     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-807     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-808     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-809 }


;-810 


;-811 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-812     getOpL();

 call getOpL

;-813     need(',');

 push 44
 call need
 add  sp, 2

;-814     getOpR();

 call getOpR

;-815 }


;-816 int check2Ops() {

 ret
ENDP

check2Ops: PROC

;-817     get2Ops();

 call get2Ops

;-818     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops202
 call addrerror

;-819     if (Op == ADR) invaloperror();

.check2Ops202:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops203
 call invaloperror

;-820     if (Op == IMM) immeerror();

.check2Ops203:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops204
 call immeerror

;-821     if (Op2==   0) addrerror();

.check2Ops204:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops205
 call addrerror

;-822     setwflag();

.check2Ops205:
 call setwflag

;-823 }


;-824 


;-825 int storeJmp() {

 ret
ENDP

storeJmp: PROC

;-826     unsigned int i;


;-827     JmpMaxIx++;
;
 ENTER  2,0
 inc  word[JmpMaxIx]

;-828     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp206
 push storeJmp_0
 call errorexit
 add  sp, 2

;-829     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp206:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax

;-830     JmpNamePtr++;

 inc  word[JmpNamePtr]

;-831     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax

;-832     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp207
 push storeJmp_1
 call errorexit
 add  sp, 2

;-833     JmpAddr[JmpMaxIx] = PC;

.storeJmp207:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax

;-834 }


;-835 


;-836 int storeLabel() {
 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC

;-837     unsigned int i;


;-838     if(searchLabel()) error1("duplicate label");
;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel208
 push storeLabel_0
 call error1
 add  sp, 2

;-839     LabelMaxIx++;

.storeLabel208:
 inc  word[LabelMaxIx]

;-840     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel209
 push storeLabel_1
 call errorexit
 add  sp, 2

;-841     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel209:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-842     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-843     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-844     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel210
 push storeLabel_2
 call errorexit
 add  sp, 2

;-845     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel210:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-846 }


;-847 


;-848 


;-849 int genDB() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC

;-850     char c;  char isloop;


;-851         isloop = 0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al

;-852             do {

.genDB211:

;-853                 if (isloop) getTokeType();//omit ,

 mov al, [bp-4]
 or  al, al
 je .genDB212
 call getTokeType

;-854                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB212:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB213
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-855                 else {

 jmp .genDB214
.genDB213:

;-856                     skipBlank();

 call skipBlank

;-857                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB215

;-858                         do {

.genDB216:

;-859                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-860                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-861                             InputPtr++;

 inc  word[InputPtr]

;-862                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB217
 jmp .genDB216
.genDB217:

;-863                         InputPtr++;

 inc  word[InputPtr]

;-864                     }


;-865                 }

.genDB215:

;-866                 isloop = 1;

.genDB214:
 mov ax, 1
 mov [bp-4], al

;-867             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB218
 jmp .genDB211
.genDB218:

;-868 }


;-869 


;-870 int getVariable() {
 LEAVE
 ret
ENDP

getVariable: PROC

;-871     char c;


;-872     storeLabel();
;
 ENTER  2,0
 call storeLabel

;-873     getTokeType();

 call getTokeType

;-874     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable219

;-875         lookCode();

 call lookCode

;-876         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable220
 call dataexit

;-877         if (CodeType > 205) dataexit();

.getVariable220:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable221
 call dataexit

;-878         if (CodeType== 200) {//DB

.getVariable221:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable222

;-879             do {

.getVariable223:

;-880                 getTokeType();

 call getTokeType

;-881                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable224
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-882                 else {

 jmp .getVariable225
.getVariable224:

;-883                     skipBlank();

 call skipBlank

;-884                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable226

;-885                         do {

.getVariable227:

;-886                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-887                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-888                             InputPtr++;

 inc  word[InputPtr]

;-889                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable228
 jmp .getVariable227
.getVariable228:

;-890                         InputPtr++;

 inc  word[InputPtr]

;-891                     }


;-892                 }

.getVariable226:

;-893             } while (isToken(','));

.getVariable225:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable229
 jmp .getVariable223
.getVariable229:

;-894         }


;-895         if (CodeType == 201) {//DW

.getVariable222:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable230

;-896             do {

.getVariable231:

;-897                 getTokeType();

 call getTokeType

;-898                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable232
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-899             } while (isToken(','));

.getVariable232:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable233
 jmp .getVariable231
.getVariable233:

;-900         }


;-901         if (CodeType == 202) {//DD

.getVariable230:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable234

;-902             do {

.getVariable235:

;-903                 getTokeType();

 call getTokeType

;-904                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable236
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-905                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-906             } while (isToken(','));

.getVariable236:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable237
 jmp .getVariable235
.getVariable237:

;-907         }


;-908         if (CodeType >= 203) {//resb, resw, resd

.getVariable234:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable238

;-909             getTokeType();

 call getTokeType

;-910             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable239

;-911                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable240
 call syntaxerror

;-912                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable240:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable241
 push getVariable_0
 call error1
 add  sp, 2

;-913                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable241:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-914                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable242
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-915                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable242:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable243
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-916                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable243:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-917             } else numbererror();

 jmp .getVariable244
.getVariable239:
 call numbererror

;-918         }

.getVariable244:

;-919     }

.getVariable238:

;-920     else dataexit();

 jmp .getVariable245
.getVariable219:
 call dataexit

;-921 }

.getVariable245:

;-922 


;-923 int getCodeSize() {
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC

;-924     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize246

;-925         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize247
 call getTokeType
 mov ax, 1
 jmp .retngetCodeSize

;-926         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

.getCodeSize247:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize248
 call getTokeType
 mov ax, 2
 jmp .retngetCodeSize

;-927         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

.getCodeSize248:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize249
 call getTokeType
 mov ax, 3
 jmp .retngetCodeSize

;-928     }

.getCodeSize249:

;-929     return 0;

.getCodeSize246:
 mov ax, 0
 jmp .retngetCodeSize

;-930 }


;-931 


;-932 int FixOneJmp(unsigned int hex) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

FixOneJmp: PROC

;-933     int Ix; char c;


;-934     Ix=searchLabel();
;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax

;-935     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp250
 call notfounderror

;-936     disp = LabelAddr[Ix];

.FixOneJmp250:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-937     c = FileBin[hex];//look for 'A' push Absolute

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-938     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp251

;-939         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax

;-940         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax

;-941         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-942     }


;-943     FileBin[hex] = disp;//fix low byte

.FixOneJmp251:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al

;-944     hex++;

 inc  word[bp+4]

;-945     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-946     FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al

;-947 }


;-948 int fixJmp() {
 LEAVE
 ret
ENDP

fixJmp: PROC

;-949     unsigned int hex; int i;


;-950     char *p;


;-951     p = &JmpNames;
;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax

;-952     i = 1;

 mov ax, 1
 mov [bp-4], ax

;-953     while (i <= JmpMaxIx) {

.fixJmp252:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp253

;-954         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-955         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-956         p++;

 inc  word[bp-6]

;-957         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax

;-958         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2

;-959         i++;

 inc  word[bp-4]

;-960     }


;-961 }

 jmp .fixJmp252
.fixJmp253:

;-962 int fixJmpMain() {
 LEAVE
 ret
ENDP

fixJmpMain: PROC

;-963     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain254
 push fixJmpMain_0
 call error1
 add  sp, 2

;-964     strcpy(Symbol, "main");

.fixJmpMain254:
 push fixJmpMain_1
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-965     FixOneJmp(1);//first instruction, PC=1

 push 1
 call FixOneJmp
 add  sp, 2

;-966 }


;-967 


;-968 


;-969 int process() {

 ret
fixJmpMain_0 db "resting global jmp",0
fixJmpMain_1 db "main",0
ENDP

process: PROC

;-970     char c;


;-971     int i;


;-972     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
;
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

;-973     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-974     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-975     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-976     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-977     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-978 


;-979     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process255

;-980         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-981         return;

 jmp .retnprocess

;-982     }


;-983 


;-984     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process255:
 mov al, [CodeType]
 cmp al, 2
 jne .process256

;-985         getOpL();

 call getOpL

;-986         checkOpL();

 call checkOpL

;-987         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process257

;-988   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process258

;-989                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process259

;-990                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process260
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4

;-991                         else   genCode2(0x40, R1No);//INC

 jmp .process261
.process260:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4

;-992                     return;

.process261:
 jmp .retnprocess

;-993                     }


;-994             }

.process259:

;-995         }

.process258:

;-996         if (Code1 == 5) {//imul extension?

.process257:
 mov al, [Code1]
 cmp al, 5
 jne .process262

;-997             getTokeType();

 call getTokeType

;-998             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process263
 call implerror

;-999         }

.process263:

;-1000         if (Code1 < 2) genCodeW(0xFE);

.process262:
 mov al, [Code1]
 cmp al, 2
 jge .process264
 push 254
 call genCodeW
 add  sp, 2

;-1001             else genCodeW(0xF6);

 jmp .process265
.process264:
 push 246
 call genCodeW
 add  sp, 2

;-1002         writeEA(Code1);

.process265:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1003         return;

 jmp .retnprocess

;-1004     }


;-1005 


;-1006     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process256:
 mov al, [CodeType]
 cmp al, 3
 jne .process266

;-1007         check2Ops();    //setwflag not applicable

 call check2Ops

;-1008         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process267
 call reg16error

;-1009         if (Op2 != MEM) addrerror();//only m16

.process267:
 mov al, [Op2]
 cmp al, 4
 je  .process268
 call addrerror

;-1010 


;-1011         if (Code1 >= 0xB2) {

.process268:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process269

;-1012             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process270
 push 15
 call genCode8
 add  sp, 2

;-1013         }

.process270:

;-1014         genCode8(Code1);

.process269:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1015         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1016         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1017         return;

 jmp .retnprocess

;-1018     }


;-1019 


;-1020     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process266:
 mov al, [CodeType]
 cmp al, 4
 jne .process271

;-1021         check2Ops();

 call check2Ops

;-1022         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process272

;-1023             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process273
 call notfounderror

;-1024             imme=LabelAddr[LabelIx];

.process273:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax

;-1025             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al

;-1026         }


;-1027         if (Op2 == IMM) {//second operand is imm

.process272:
 mov al, [Op2]
 cmp al, 1
 jne .process274

;-1028             setsflag();

 call setsflag

;-1029             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process275

;-1030                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process276

;-1031                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process277

;-1032                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1033                         c += 4;

 add  byte[bp-2], 4

;-1034                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1035                         genImmediate();

 call genImmediate

;-1036                         return;

 jmp .retnprocess

;-1037                     }


;-1038                 }

.process277:

;-1039             }

.process276:

;-1040             //r/m, imm: 80 sign-extended,TTT,imm


;-1041             c = sflag + 0x80;

.process275:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1042             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1043             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1044             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process278
 push word [imme]
 call genCode8
 add  sp, 2

;-1045             else genImmediate();

 jmp .process279
.process278:
 call genImmediate

;-1046             return;

.process279:
 jmp .retnprocess

;-1047         }


;-1048         c = Code1 << 3;//r/m, r/r

.process274:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1049         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process280

;-1050             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process281

;-1051                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1052                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1053                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1054                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1055                 return;

 jmp .retnprocess

;-1056             }


;-1057         }

.process281:

;-1058         if (Op2 == REG) {//mem,reg    reg,reg

.process280:
 mov al, [Op2]
 cmp al, 2
 jne .process282

;-1059             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1060             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1061             return;

 jmp .retnprocess

;-1062         }


;-1063         syntaxerror();

.process282:
 call syntaxerror

;-1064         return;

 jmp .retnprocess

;-1065     }


;-1066 


;-1067     if (CodeType == 5) {//mov (movsx, movzx=51)

.process271:
 mov al, [CodeType]
 cmp al, 5
 jne .process283

;-1068         check2Ops();

 call check2Ops

;-1069         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process284

;-1070             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process285
 mov ax, [disp]
 mov word [imme], ax

;-1071             else notfounderror();

 jmp .process286
.process285:
 call notfounderror

;-1072             Op2=IMM;//continue with IMM

.process286:
 mov ax, 1
 mov byte [Op2], al

;-1073         }


;-1074         if (Op2 == IMM) {// r,i

.process284:
 mov al, [Op2]
 cmp al, 1
 jne .process287

;-1075             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process288

;-1076                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1077                 c += 0xB0;

 add  byte[bp-2], 176

;-1078                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1079                 genImmediate();

 call genImmediate

;-1080                 return;

 jmp .retnprocess

;-1081             }


;-1082             if (Op == MEM) {// m,i

.process288:
 mov al, [Op]
 cmp al, 4
 jne .process289

;-1083                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1084                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1085                 genImmediate();

 call genImmediate

;-1086                 return;

 jmp .retnprocess

;-1087             }


;-1088             regmemerror();

.process289:
 call regmemerror

;-1089             return;

 jmp .retnprocess

;-1090         }


;-1091         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process287:
 mov al, [R1Type]
 cmp al, 4
 jne .process290
 call ChangeDirection

;-1092         if (R2Type == SEGREG) {//rm,sreg

.process290:
 mov al, [R2Type]
 cmp al, 4
 jne .process291

;-1093             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process292
 call reg16error

;-1094                 genCode2(0x8C, dflag);

.process292:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1095                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1096                 return;

 jmp .retnprocess

;-1097         }


;-1098         if (Op2 == MEM) {//acc, moffs16

.process291:
 mov al, [Op2]
 cmp al, 4
 jne .process293

;-1099             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process294

;-1100                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process295

;-1101                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process296

;-1102                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1103                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1104                         return;

 jmp .retnprocess

;-1105                     }


;-1106                 }

.process296:

;-1107             }

.process295:

;-1108         }

.process294:

;-1109         if (Op == MEM) {//moffs16, acc

.process293:
 mov al, [Op]
 cmp al, 4
 jne .process297

;-1110             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process298

;-1111                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process299

;-1112                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process300

;-1113                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1114                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1115                         return;

 jmp .retnprocess

;-1116                     }


;-1117                 }

.process300:

;-1118             }

.process299:

;-1119 


;-1120         }

.process298:

;-1121         if (Op2 == REG) {//rm, r

.process297:
 mov al, [Op2]
 cmp al, 2
 jne .process301

;-1122             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1123             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1124             return;

 jmp .retnprocess

;-1125         }


;-1126         if (Op2 == MEM) {//r, m

.process301:
 mov al, [Op2]
 cmp al, 4
 jne .process302

;-1127             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process303

;-1128                 ChangeDirection();

 call ChangeDirection

;-1129                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1130                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1131                 return;

 jmp .retnprocess

;-1132             }


;-1133         }

.process303:

;-1134         syntaxerror();

.process302:
 call syntaxerror

;-1135         return;

 jmp .retnprocess

;-1136     }


;-1137 


;-1138     if (CodeType == 6) {//Jcc

.process283:
 mov al, [CodeType]
 cmp al, 6
 jne .process304

;-1139         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process305

;-1140             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1141             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process306

;-1142                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1143                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1144                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1145                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process307

;-1146                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1147                     disp -= 2;

 sub  word[disp], 2

;-1148                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1149                 } else {

 jmp .process308
.process307:

;-1150                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1151                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1152                     disp -= 4;

 sub  word[disp], 4

;-1153                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1154                 }


;-1155             }

.process308:

;-1156             else {//jump forward, near only

 jmp .process309
.process306:

;-1157                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1158                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1159                 storeJmp();

 call storeJmp

;-1160                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1161                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1162             }


;-1163         return;

.process309:
 jmp .retnprocess

;-1164         }


;-1165     }

.process305:

;-1166 


;-1167     if (CodeType == 7) {//jmp, call

.process304:
 mov al, [CodeType]
 cmp al, 7
 jne .process310

;-1168         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process311

;-1169             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1170             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process312

;-1171                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1172                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1173                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1174                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process313

;-1175                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process314

;-1176                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1177                         disp -= 2;

 sub  word[disp], 2

;-1178                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1179                     }


;-1180                     else {

 jmp .process315
.process314:

;-1181                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1182                         disp -= 3;

 sub  word[disp], 3

;-1183                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1184                     }


;-1185                 }

.process315:

;-1186                 else {

 jmp .process316
.process313:

;-1187                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1188                     disp -= 3;

 sub  word[disp], 3

;-1189                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1190                 }


;-1191             }

.process316:

;-1192             else {//jump forward, near only

 jmp .process317
.process312:

;-1193                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1194                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process318
 call storeJmp

;-1195                 genCode16(0);

.process318:
 push 0
 call genCode16
 add  sp, 2

;-1196                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1197             }


;-1198         return;

.process317:
 jmp .retnprocess

;-1199         }


;-1200     }

.process311:

;-1201 


;-1202     if (CodeType ==  8) {//ret,retf

.process310:
 mov al, [CodeType]
 cmp al, 8
 jne .process319

;-1203         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process320

;-1204             if (Code1 == 0xC3) genCode8(0xC2);//ret n

 mov al, [Code1]
 cmp al, 195
 jne .process321
 push 194
 call genCode8
 add  sp, 2

;-1205                 else genCode8(0xCA);//retf n

 jmp .process322
.process321:
 push 202
 call genCode8
 add  sp, 2

;-1206             genCode16(SymbolInt);

.process322:
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1207             return;

 jmp .retnprocess

;-1208         }


;-1209         genCode8(Code1);

.process320:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1210         return;

 jmp .retnprocess

;-1211     }


;-1212 


;-1213     if (CodeType == 9) {//push, pop

.process319:
 mov al, [CodeType]
 cmp al, 9
 jne .process323

;-1214         getOpL();

 call getOpL

;-1215         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process324

;-1216             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process325

;-1217                 setsflag();

 call setsflag

;-1218                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1219                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process326
 push word [imme]
 call genCode8
 add  sp, 2

;-1220                 else       genCode16(imme);

 jmp .process327
.process326:
 push word [imme]
 call genCode16
 add  sp, 2

;-1221                 return;

.process327:
 jmp .retnprocess

;-1222             }


;-1223             if (Op == ADR) {//push string ABSOLUTE i16

.process325:
 mov al, [Op]
 cmp al, 3
 jne .process328

;-1224                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process329

;-1225                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1226                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1227                     return;

 jmp .retnprocess

;-1228                 }


;-1229                 else {

 jmp .process330
.process329:

;-1230                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1231                     storeJmp();

 call storeJmp

;-1232                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2

;-1233                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al

;-1234                     return;

 jmp .retnprocess

;-1235                 }


;-1236             }

.process330:

;-1237         }

.process328:

;-1238         if (R1Type == SEGREG) {

.process324:
 mov al, [R1Type]
 cmp al, 4
 jne .process331

;-1239             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process332

;-1240                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process333
 push process_0
 call error1
 add  sp, 2

;-1241             }

.process333:

;-1242             c = R1No <<3;

.process332:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1243             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process334

;-1244                 c += 122;  //0x7A

 add  byte[bp-2], 122

;-1245                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1246             }


;-1247             if (Code1 == 0x50) c +=6;//push

.process334:
 mov al, [Code1]
 cmp al, 80
 jne .process335
 add  byte[bp-2], 6

;-1248                 else c += 7;//pop

 jmp .process336
.process335:
 add  byte[bp-2], 7

;-1249             genCode8(c);

.process336:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1250             return;

 jmp .retnprocess

;-1251         }


;-1252         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

.process331:
 call checkOpL

;-1253 


;-1254         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process337

;-1255             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process338

;-1256                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2

;-1257                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2

;-1258             }else {

 jmp .process339
.process338:

;-1259                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2

;-1260                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2

;-1261             }


;-1262             return;

.process339:
 jmp .retnprocess

;-1263         }


;-1264         if (R1Type == BYTE) reg16error();

.process337:
 mov al, [R1Type]
 cmp al, 1
 jne .process340
 call reg16error

;-1265         if (R1Type == WORD) {//is REG, w/o SEGREG

.process340:
 mov al, [R1Type]
 cmp al, 2
 jne .process341

;-1266             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1267             return;

 jmp .retnprocess

;-1268         }


;-1269         syntaxerror();

.process341:
 call syntaxerror

;-1270         return;

 jmp .retnprocess

;-1271     }


;-1272 


;-1273     if (CodeType == 11) {//shift, rotate

.process323:
 mov al, [CodeType]
 cmp al, 11
 jne .process342

;-1274         check2Ops();

 call check2Ops

;-1275         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process343

;-1276             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process344

;-1277                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1278                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1279                 return;

 jmp .retnprocess

;-1280             }


;-1281             genCodeW(0xC0);//80186

.process344:
 push 192
 call genCodeW
 add  sp, 2

;-1282             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1283             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1284             return;

 jmp .retnprocess

;-1285         }


;-1286         if (Op2 == REG) {

.process343:
 mov al, [Op2]
 cmp al, 2
 jne .process345

;-1287             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process346

;-1288                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process347

;-1289                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process348
 mov ax, 1
 mov byte [wflag], al

;-1290                     genCodeW(0xD2);

.process348:
 push 210
 call genCodeW
 add  sp, 2

;-1291                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1292                     return;

 jmp .retnprocess

;-1293                 }


;-1294             }

.process347:

;-1295         }

.process346:

;-1296     }

.process345:

;-1297 


;-1298     if (CodeType == 12) {//int

.process342:
 mov al, [CodeType]
 cmp al, 12
 jne .process349

;-1299         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process350

;-1300             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1301             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1302             return;

 jmp .retnprocess

;-1303         }


;-1304     }

.process350:

;-1305 


;-1306     if (CodeType == 14) {//in, out

.process349:
 mov al, [CodeType]
 cmp al, 14
 jne .process351

;-1307         implerror();

 call implerror

;-1308         return;

 jmp .retnprocess

;-1309     }


;-1310     if (CodeType == 15) {//xchg

.process351:
 mov al, [CodeType]
 cmp al, 15
 jne .process352

;-1311         implerror();

 call implerror

;-1312         return;

 jmp .retnprocess

;-1313     }


;-1314     if (CodeType == 16) {//loop

.process352:
 mov al, [CodeType]
 cmp al, 16
 jne .process353

;-1315         implerror();

 call implerror

;-1316         return;

 jmp .retnprocess

;-1317     }


;-1318 


;-1319     if (CodeType == 30) {//enter i18,i8

.process353:
 mov al, [CodeType]
 cmp al, 30
 jne .process354

;-1320         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1321         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1322         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process355
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1323         else numbererror();

 jmp .process356
.process355:
 call numbererror

;-1324         need(',');

.process356:
 push 44
 call need
 add  sp, 2

;-1325         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1326         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process357
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1327         else numbererror();

 jmp .process358
.process357:
 call numbererror

;-1328         return;

.process358:
 jmp .retnprocess

;-1329     }


;-1330 


;-1331     if (CodeType == 41) {//test

.process354:
 mov al, [CodeType]
 cmp al, 41
 jne .process359

;-1332         implerror();

 call implerror

;-1333         return;

 jmp .retnprocess

;-1334     }


;-1335 


;-1336     if (CodeType == 51) {//movsx, movzx=51

.process359:
 mov al, [CodeType]
 cmp al, 51
 jne .process360

;-1337         implerror();

 call implerror

;-1338         return;

 jmp .retnprocess

;-1339     }


;-1340 


;-1341     if (CodeType==101) {//ORG nn

.process360:
 mov al, [CodeType]
 cmp al, 101
 jne .process361

;-1342         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process362
 call numbererror

;-1343         Origin=SymbolInt;

.process362:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1344         return;

 jmp .retnprocess

;-1345     }


;-1346 


;-1347     if (CodeType == 102) {//section, segment

.process361:
 mov al, [CodeType]
 cmp al, 102
 jne .process363

;-1348         //getTokeType();//ignore .bss .text .data


;-1349         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1350         return;

 jmp .retnprocess

;-1351     }


;-1352 


;-1353     if (CodeType == 110) {//absolute

.process363:
 mov al, [CodeType]
 cmp al, 110
 jne .process364

;-1354         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process365
 call numbererror

;-1355         AbsoluteLab=SymbolInt;

.process365:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1356         return;

 jmp .retnprocess

;-1357     }


;-1358     if (CodeType == 111) {//name: PROC

.process364:
 mov al, [CodeType]
 cmp al, 111
 jne .process366

;-1359         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process367

;-1360             prs("\nentering: ");

 push process_1
 call prs
 add  sp, 2

;-1361             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1362             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1363             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax

;-1364             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax

;-1365             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax

;-1366             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax

;-1367         } else error1("already in PROC");

 jmp .process368
.process367:
 push process_2
 call error1
 add  sp, 2

;-1368         return;

.process368:
 jmp .retnprocess

;-1369     }


;-1370     if (CodeType == 112) {//ENDP

.process366:
 mov al, [CodeType]
 cmp al, 112
 jne .process369

;-1371         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process370
 push process_3
 call error1
 add  sp, 2

;-1372         prs("\nleaving: ");

.process370:
 push process_4
 call prs
 add  sp, 2

;-1373         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1374         prs(", loc labels: ");

 push process_5
 call prs
 add  sp, 2

;-1375         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax

;-1376         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1377         prs(", loc jmp forward: ");

 push process_6
 call prs
 add  sp, 2

;-1378         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax

;-1379         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1380         fixJmp();

 call fixJmp

;-1381         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1382         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax

;-1383         LabelMaxIx   = tmpLabelMaxIx;

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax

;-1384         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax

;-1385         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax

;-1386         return;

 jmp .retnprocess

;-1387     }


;-1388     if (CodeType == 200) {//db

.process369:
 mov al, [CodeType]
 cmp al, 200
 jne .process371

;-1389         genDB();

 call genDB

;-1390         return;

 jmp .retnprocess

;-1391     }


;-1392 


;-1393     error1("Command not implemented or syntax error");

.process371:
 push process_7
 call error1
 add  sp, 2

;-1394 }


;-1395 


;-1396 int parse() {

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

;-1397     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-1398     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax

;-1399     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-1400     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax

;-1401     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-1402     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1403     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al

;-1404 


;-1405     do {//process a new line

.parse372:

;-1406         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-1407         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-1408         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-1409         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-1410         getLine();

 call getLine

;-1411         if (DOS_NoBytes) {

 mov ax, [DOS_NoBytes]
 or  al, al
 je .parse373

;-1412             InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-1413             getTokeType();//getCode in SymbolUpper,

 call getTokeType

;-1414                           //set TokeType,isLabel by getName


;-1415             if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse374

;-1416                 if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse375

;-1417                   if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse376
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-1418                     storeLabel();

.parse376:
 call storeLabel

;-1419                     InputPtr++;//remove :

 inc  word[InputPtr]

;-1420                     getTokeType();

 call getTokeType

;-1421                 }


;-1422             }

.parse375:

;-1423             if (TokeType == ALNUME) {

.parse374:
 mov al, [TokeType]
 cmp al, 3
 jne .parse377

;-1424                 lookCode();

 call lookCode

;-1425                 if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse378
 call process

;-1426                 else getVariable();

 jmp .parse379
.parse378:
 call getVariable

;-1427                 skipRest();

.parse379:
 call skipRest

;-1428             }


;-1429             else if(TokeType >ALNUME)error1("Label or instruction expected");

 jmp .parse380
.parse377:
 mov al, [TokeType]
 cmp al, 3
 jle .parse381
 push parse_0
 call error1
 add  sp, 2

;-1430             else if(TokeType==DIGIT )error1("No digit allowed at start");

 jmp .parse382
.parse381:
 mov al, [TokeType]
 cmp al, 1
 jne .parse383
 push parse_1
 call error1
 add  sp, 2

;-1431             printLine();  

.parse383:
.parse382:
.parse380:
 call printLine

;-1432         }


;-1433     } while (DOS_NoBytes != 0 );

.parse373:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse384
 jmp .parse372
.parse384:

;-1434     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al

;-1435 }


;-1436 


;-1437 int getarg() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start",0
ENDP

getarg: PROC

;-1438     int arglen1; int i; char *c;


;-1439     arglen1=*arglen;
;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-1440     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg385

;-1441         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-1442         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-1443         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-1444     }


;-1445     i=arglen1+129;

.getarg385:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-1446     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-1447     arglen1--;

 dec  word[bp-2]

;-1448     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-1449 


;-1450     strcpy(namein, argv); strcat1(namein, ".S");

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

;-1451     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-1452     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-1453 


;-1454   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-1455 


;-1456     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-1457     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg386
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

;-1458     lst_fd=creatR(namelst);

.getarg386:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-1459     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg387
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

;-1460     bin_fd=creatR(namebin);

.getarg387:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-1461     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg388
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

;-1462 


;-1463     prs(";");

.getarg388:
 push getarg_7
 call prs
 add  sp, 2

;-1464     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-1465     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-1466     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-1467     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-1468     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-1469 }


;-1470 


;-1471 int main() {
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

main: PROC

;-1472     getarg();

 call getarg

;-1473     parse();

 call parse

;-1474     fixJmpMain();

 call fixJmpMain

;-1475     epilog();

 call epilog

;-1476     end1();

 call end1

;-1477 }

 ret
ENDP
;Glob. variables:187 (200), Functions:87 (300), Lines:1478
;Constant: 658 (3000), stacksize: 6482..........