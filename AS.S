
;A.COM V0.9.4, Input: AS.C, Output: AS.S
org  256 
jmp main

;-1 char Version1[]="NASM like AS.C V1.0";//Assembler like NASM

Version1 db "NASM like AS.C V1.0",0

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


;-297     isPrint=1;
;
 ENTER  6,0
 mov ax, 1
 mov byte [isPrint], al

;-298     prs("Errors:");

 push epilog_0
 call prs
 add  sp, 2

;-299     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-300     if (ErrorCount) prs("\n****** ERRORS *** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog83
 push epilog_1
 call prs
 add  sp, 2

;-301     prs("\nOut: ");

.epilog83:
 push epilog_2
 call prs
 add  sp, 2

;-302     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-303     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-304     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-305     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-306     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-307     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-308     i=0;

 mov ax, 0
 mov [bp-2], ax

;-309     do {

.epilog84:

;-310         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-311         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-312         i++;

 inc  word[bp-2]

;-313     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog85
 jmp .epilog84
.epilog85:

;-314 }


;-315 


;-316 int end1(int n) {
 LEAVE
 ret
epilog_0 db "Errors:",0
epilog_1 db "\n****** ERRORS *** ",0
epilog_2 db "\nOut: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
ENDP

end1: PROC

;-317     fcloseR(asm_fd);
;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-318     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-319     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-320     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-321 }


;-322 


;-323 


;-324 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-325     isPrint=1;
;
 ENTER  0,0
 mov ax, 1
 mov byte [isPrint], al

;-326     ErrorCount++;

 inc  word[ErrorCount]

;-327     prs("\n\n******* next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-328     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-329     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-330     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-331 }


;-332 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n\n******* next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-333     error1(s);
;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-334     epilog();

 call epilog

;-335     end1(1);

 push 1
 call end1
 add  sp, 2

;-336 }


;-337 int dataexit(){errorexit("DB,DW,DD or RESB,W,D expected");}
 LEAVE
 ret
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-338 


;-339 int notfounderror(){

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

notfounderror: PROC

;-340     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al

;-341     ErrorCount++;

 inc  word[ErrorCount]

;-342     prs("\n\n******* ERROR: label not found: ");

 push notfounderror_0
 call prs
 add  sp, 2

;-343     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-344     prs(" ");

 push notfounderror_1
 call prs
 add  sp, 2

;-345 }


;-346 int addrerror()    {error1("address missing");}

 ret
notfounderror_0 db "\n\n******* ERROR: label not found: ",0
notfounderror_1 db " ",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-347 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-348 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-349 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-350 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-351 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-352 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-353 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-354 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-355 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-356 


;-357 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
syntaxerror_0 db "syntax",0
ENDP

ifEOL: PROC

;-358   if (c == 10) return 1;//LF
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL86
 mov ax, 1
 jmp .retnifEOL

;-359   if (c == 13) {//CR

.ifEOL86:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL87

;-360     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-361     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL88
 push ifEOL_0
 call errorexit
 add  sp, 2

;-362     return 1;

.ifEOL88:
 mov ax, 1
 jmp .retnifEOL

;-363   }


;-364   return 0;

.ifEOL87:
 mov ax, 0
 jmp .retnifEOL

;-365 }


;-366 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC

;-367   unsigned int i;


;-368   InputPtr= &InputBuf;
;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-369   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-370   do {

.getLine89:

;-371     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-372     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine90
 push getLine_0
 call errorexit
 add  sp, 2

;-373     if (DOS_NoBytes == 0) return;

.getLine90:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine91
 jmp .retngetLine

;-374     *InputPtr = DOS_ByteRead;

.getLine91:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-375     InputPtr++;

 inc  word[InputPtr]

;-376     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-377     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine92
 push getLine_1
 call errorexit
 add  sp, 2

;-378   } while (ifEOL(DOS_ByteRead) == 0);

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

;-379   InputPtr--;

 dec  word[InputPtr]

;-380   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-381 }


;-382 int skipBlank() {

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC

;-383   skipblank1:

.skipblank1:

;-384     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank94
 inc  word[InputPtr]
 jmp .skipblank1

;-385     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank94:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank95
 inc  word[InputPtr]
 jmp .skipblank1

;-386 }

.skipBlank95:

;-387 


;-388 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC

;-389   unsigned int CastInt;


;-390   SymbolInt=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-391   do {

.getDigit96:

;-392     c-='0';

 sub  byte[bp+4], 48

;-393     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-394     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-395     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-396     InputPtr++;

 inc  word[InputPtr]

;-397     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-398   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit97
 jmp .getDigit96
.getDigit97:

;-399 }


;-400 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-401   char *p; unsigned int i;


;-402   p = &Symbol;
;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-403   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-404   p++;

 inc  word[bp-2]

;-405   while (alnumE(c)) {

.getName98:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName99

;-406     InputPtr++;

 inc  word[InputPtr]

;-407     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-408     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-409     p++;

 inc  word[bp-2]

;-410     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-411     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName100
 push getName_0
 call errorexit
 add  sp, 2

;-412   }

.getName100:

;-413   if (c == ':') isLabel=1; else isLabel=0;

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

;-414   p--;

.getName102:
 dec  word[bp-2]

;-415   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-416   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-417   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-418 }


;-419 


;-420 char I_START=0xF1;
 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
I_START db 241

;-421 //OpName, 0, CodeType, OpCode1-n, F1h


;-422 //  1:   1 byte opcode


;-423 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-424 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-425 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-426 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-427 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-428 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-429 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-430 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-431 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-432 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-433 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-434 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-435 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-436 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-437 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-438 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-439 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-440 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-441 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-442 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-443 // 2: mem reg 16 bit


;-444 char I_INC[]=  {'I','N','C',0,          2, 0,0xF1};

I_INC db 73,78,67,0,2,0,241

;-445 char I_DEC[]=  {'D','E','C',0,          2, 1,0xF1};

I_DEC db 68,69,67,0,2,1,241

;-446 char I_NOT[]=  {'N','O','T',0,          2, 2,     0xF1};

I_NOT db 78,79,84,0,2,2,241

;-447 char I_NEG[]=  {'N','E','G',0,          2, 3,     0xF1};

I_NEG db 78,69,71,0,2,3,241

;-448 char I_MUL[]=  {'M','U','L',0,          2, 4,     0xF1};

I_MUL db 77,85,76,0,2,4,241

;-449 char I_IMUL[]= {'I','M','U','L',0,      2, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,5,241

;-450 char I_DIV[]=  {'D','I','V',0,          2, 6,     0xF1};

I_DIV db 68,73,86,0,2,6,241

;-451 char I_IDIV[]= {'I','D','I','V',0,      2, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,7,241

;-452 //  3: les, lda, lea, lss, lfs, lgs


;-453 char I_LES[]=  {'L','E','S',0,          3,0xC4,0xF1};

I_LES db 76,69,83,0,3,196,241

;-454 char I_LDS[]=  {'L','D','S',0,          3,0xC5,0xF1};

I_LDS db 76,68,83,0,3,197,241

;-455 char I_LEA[]=  {'L','E','A',0,          3,0x8D,0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-456 char I_LSS[]=  {'L','S','S',0,          3,0xB2,0xF1};

I_LSS db 76,83,83,0,3,178,241

;-457 char I_LFS[]=  {'L','F','S',0,          3,0xB4,0xF1};

I_LFS db 76,70,83,0,3,180,241

;-458 char I_LGS[]=  {'L','G','S',0,          3,0xB5,0xF1};

I_LGS db 76,71,83,0,3,181,241

;-459 //  4: acc,imm  reg,imm  index,reg


;-460 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-461 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-462 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-463 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-464 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-465 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-466 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-467 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-468 //  5: mov


;-469 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-470 //  6: single byte relative jump


;-471 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-472 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-473 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-474 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-475 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-476 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-477 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-478 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-479 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-480 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-481 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-482 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-483 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-484 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-485 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-486 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-487 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-488 //  7: jmp, call


;-489 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 0xF1};

I_JMP db 74,77,80,0,7,233,241

;-490 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 0xF1};

I_CALL db 67,65,76,76,0,7,232,241

;-491 //  8: ret


;-492 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xF1};

I_RET db 82,69,84,0,8,195,241

;-493 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xF1};

I_RETF db 82,69,84,70,0,8,203,241

;-494 //  9: seg, r/m


;-495 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xF1};

I_PUSH db 80,85,83,72,0,9,80,241

;-496 char I_POP[]=  {'P','O','P',0,          9,0x58,0xF1};

I_POP db 80,79,80,0,9,88,241

;-497 //  11: shift, rotates


;-498 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-499 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-500 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-501 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-502 //  12: int


;-503 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xF1};

I_INT db 73,78,84,0,12,205,241

;-504 //  14: in/out


;-505 char I_IN[]=   {'I','N',0,              14,0xE4,0xF1};

I_IN db 73,78,0,14,228,241

;-506 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-507 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-508 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-509 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xF1};

I_OUT db 79,85,84,0,14,230,241

;-510 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-511 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-512 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-513 //  15: xchg


;-514 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0xF1};

I_XCHG db 88,67,72,71,0,15,134,241

;-515 //  16: loop, jcxz


;-516 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-517 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-518 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-519 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-520 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-521 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-522 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-523 //  30: other


;-524 char I_ENTER[]={'E','N','T','E','R',0, 30,     0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-525 char I_TEST[]= {'T','E','S','T',0,     41,0xF6,0xF1};

I_TEST db 84,69,83,84,0,41,246,241

;-526 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-527 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-528 // 100: directives


;-529 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-530 // section, segment .TEXT .DATA .BSS


;-531 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-532 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-533 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-534 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-535 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-536 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-537 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-538 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-539 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-540 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-541 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-542 char I_END=0;// end of table char

I_END db 0

;-543 


;-544 int lookCode() {//ret: CodeType, *OpCodePtr


lookCode: PROC

;-545     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-546     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-547     OpCodePtr++;

 inc  word[OpCodePtr]

;-548     do  {

.lookCode103:

;-549         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode104

;-550             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode105:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode106
 inc  word[OpCodePtr]

;-551             OpCodePtr++;

 jmp .lookCode105
.lookCode106:
 inc  word[OpCodePtr]

;-552             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-553             return;

 jmp .retnlookCode

;-554         }


;-555     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode104:
.lookCode107:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode108
 inc  word[OpCodePtr]

;-556     OpCodePtr++;

 jmp .lookCode107
.lookCode108:
 inc  word[OpCodePtr]

;-557     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode109
 jmp .lookCode103
.lookCode109:

;-558 }


;-559 


;-560 int genCode8(char c) {

 .retnlookCode:
 ret
ENDP

genCode8: PROC

;-561 //set: BinLen++, OpPrintIndex++


;-562     FileBin[BinLen]=c;
;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-563     BinLen++;

 inc  word[BinLen]

;-564     PC++;

 inc  word[PC]

;-565     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 22000 ;unsigned : 0
 jb  .genCode8110
 push genCode8_0
 call errorexit
 add  sp, 2

;-566     if (OpPrintIndex < OPMAXLEN) {

.genCode8110:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8111

;-567         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-568         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-569     }


;-570 }

.genCode8111:

;-571 int gen66h() {genCode8(0x66);
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-572 }


;-573 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-574     c = c + d;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-575     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-576 }


;-577 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-578     c = c + wflag;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-579     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-580 }


;-581 int genCode16(unsigned int i) {
 LEAVE
 ret
ENDP

genCode16: PROC

;-582     genCode8(i); i=i >> 8;
;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-583     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-584 }


;-585 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-586     genCode16(L); L=L >>16;
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

;-587     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-588 }


;-589 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-590 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-591 //mod-bits: mode76, reg/opcode543, r/m210


;-592 //Op: 0, IMM, REG, ADR, MEM


;-593     char len;


;-594     len=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-595     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-596     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA112

;-597         xxx |= 0xC0;

 or  byte[bp+4], 192

;-598         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA113
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-599             else {

 jmp .writeEA114
.writeEA113:

;-600                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA115
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-601                 else            xxx = xxx + R2No;

 jmp .writeEA116
.writeEA115:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-602             }

.writeEA116:

;-603         }

.writeEA114:

;-604     if (Op == MEM) {

.writeEA112:
 mov al, [Op]
 cmp al, 4
 jne .writeEA117

;-605         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA118

;-606             xxx |= 6;

 or  byte[bp+4], 6

;-607             len = 2;

 mov ax, 2
 mov [bp-2], al

;-608         }


;-609         else {

 jmp .writeEA119
.writeEA118:

;-610             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-611             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA120

;-612                 len=1;

 mov ax, 1
 mov [bp-2], al

;-613                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA121
 or  byte[bp+4], 64

;-614             }

.writeEA121:

;-615 


;-616             if (disp) {

.writeEA120:
 mov ax, [disp]
 or  al, al
 je .writeEA122

;-617                 ax = disp;

 mov  ax, [disp]

;-618                 if (ax < 0) __asm{ neg ax }

 cmp  ax, 0
 jge .writeEA123
 neg ax 

;-619                 if (ax > 127) len=2;

.writeEA123:
 cmp  ax, 127
 jle .writeEA124
 mov ax, 2
 mov [bp-2], al

;-620                 else len=1;

 jmp .writeEA125
.writeEA124:
 mov ax, 1
 mov [bp-2], al

;-621                 if (len == 1) xxx |= 0x40;

.writeEA125:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA126
 or  byte[bp+4], 64

;-622                 else xxx |= 0x80;

 jmp .writeEA127
.writeEA126:
 or  byte[bp+4], 128

;-623             }

.writeEA127:

;-624         }

.writeEA122:

;-625     }

.writeEA119:

;-626 


;-627     genCode8(xxx);// gen second byte

.writeEA117:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-628     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA128
 push word [disp]
 call genCode8
 add  sp, 2

;-629     if (len == 2) genCode16(disp);

.writeEA128:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA129
 push word [disp]
 call genCode16
 add  sp, 2

;-630 }

.writeEA129:

;-631 


;-632 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-633     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate130
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate131
 push word [imme]
 call genCode32
 add  sp, 2

;-634         //todo imme long


;-635         else genCode16(imme);

 jmp .genImmediate132
.genImmediate131:
 push word [imme]
 call genCode16
 add  sp, 2

;-636     else       genCode8 (imme);

.genImmediate132:
 jmp .genImmediate133
.genImmediate130:
 push word [imme]
 call genCode8
 add  sp, 2

;-637 }

.genImmediate133:

;-638 


;-639 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC

;-640     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-641     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag134

;-642         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag135
 mov al, [R1Type]
 mov byte [OpSize], al

;-643         if (Op2== REG) OpSize=R2Type;

.setwflag135:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag136
 mov al, [R2Type]
 mov byte [OpSize], al

;-644         if (R2Type== SEGREG) OpSize=WORD;

.setwflag136:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag137
 mov ax, 2
 mov byte [OpSize], al

;-645         if (R1Type == SEGREG) OpSize=WORD;

.setwflag137:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag138
 mov ax, 2
 mov byte [OpSize], al

;-646     }

.setwflag138:

;-647     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag134:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag139
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-648     if (OpSize  ==  WORD) wflag=1;

.setwflag139:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag140
 mov ax, 1
 mov byte [wflag], al

;-649 }

.setwflag140:

;-650 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-651     unsigned int ui;


;-652     sflag=2;
;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-653     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-654     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag141
 mov ax, 0
 mov byte [sflag], al

;-655     if (OpSize == BYTE) {

.setsflag141:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag142

;-656         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag143
 push setsflag_0
 call error1
 add  sp, 2

;-657         sflag=0;//byte reg does not need sign extended

.setsflag143:
 mov ax, 0
 mov byte [sflag], al

;-658     }


;-659 }

.setsflag142:

;-660 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-661     if (ui > 127   ) return 0;//is near; return sflag
;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize144
 mov ax, 0
 jmp .retncheckConstSize

;-662     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize144:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize145
 mov ax, 0
 jmp .retncheckConstSize

;-663     return 2;// is short

.checkConstSize145:
 mov ax, 2
 jmp .retncheckConstSize

;-664 }


;-665 


;-666 


;-667 int ChangeDirection() {

 .retncheckConstSize: LEAVE
 ret
ENDP

ChangeDirection: PROC

;-668     char c;


;-669     c=Op;     Op    =Op2;    Op2   =c;
;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-670     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-671     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-672     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-673 }


;-674 


;-675 int getTokeType() {
 LEAVE
 ret
ENDP

getTokeType: PROC

;-676     char c;


;-677     skipBlank();
;
 ENTER  2,0
 call skipBlank

;-678     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-679     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType146
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-680     if (c == ';') {TokeType=0; return; }//comment

.getTokeType146:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType147
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-681     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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

;-682     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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

;-683     TokeType=NOALNUME;

.getTokeType149:
 mov ax, 4
 mov byte [TokeType], al

;-684 }


;-685 


;-686 int isToken(char c) {

 .retngetTokeType: LEAVE
 ret
ENDP

isToken: PROC

;-687     skipBlank();
;
 ENTER  0,0
 call skipBlank

;-688     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken150

;-689         InputPtr++;

 inc  word[InputPtr]

;-690         return 1;

 mov ax, 1
 jmp .retnisToken

;-691         }


;-692     return 0;

.isToken150:
 mov ax, 0
 jmp .retnisToken

;-693 }


;-694 


;-695 


;-696 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-697     if (isToken(c)) {
;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need151

;-698         getTokeType();

 call getTokeType

;-699         return;

 jmp .retnneed

;-700         }


;-701     error1();

.need151:
 call error1

;-702     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-703     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-704 }


;-705 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-706     getTokeType();

 call getTokeType

;-707     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest152
 push skipRest_0
 call error1
 add  sp, 2

;-708 }

.skipRest152:

;-709 


;-710 


;-711 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC

;-712     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL153
 call implerror

;-713     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL153:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL154
 call segregerror
 jmp .retncheckOpL

;-714     setwflag();

.checkOpL154:
 call setwflag

;-715     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL155
 push checkOpL_0
 call error1
 add  sp, 2

;-716     if (OpSize == R1Type) return;

.checkOpL155:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL156
 jmp .retncheckOpL

;-717     if (Op == REG) if (R1Type==0) error1("no register defined");

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

;-718 }

.checkOpL158:
.checkOpL157:

;-719 


;-720 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC

;-721     int LIx; char *p;


;-722     p = &LabelNames;
;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-723     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-724     while (LIx <= LabelMaxIx) {

.searchLabel159:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel160

;-725         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel161
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-726         p=strlen(p) + p;

.searchLabel161:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-727         p++;

 inc  word[bp-4]

;-728         LIx++;

 inc  word[bp-2]

;-729     }


;-730     return 0;

 jmp .searchLabel159
.searchLabel160:
 mov ax, 0
 jmp .retnsearchLabel

;-731 }


;-732 


;-733 int getOp1() {//scan for a single operand

 .retnsearchLabel: LEAVE
 ret
ENDP

getOp1: PROC

;-734 //return:0, IMM, REG, ADR (not MEM)


;-735 //set   :R2Type, R2No by testReg


;-736 //set   :LabelIx by searchLabel


;-737     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1162
 mov ax, 0
 jmp .retngetOp1

;-738     if (TokeType == DIGIT)  return IMM;

.getOp1162:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1163
 mov ax, 1
 jmp .retngetOp1

;-739     if (TokeType == ALNUME) {

.getOp1163:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1164

;-740         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-741         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1165
 mov ax, 2
 jmp .retngetOp1

;-742         LabelIx=searchLabel();

.getOp1165:
 call searchLabel
 mov word [LabelIx], ax

;-743         return ADR;

 mov ax, 3
 jmp .retngetOp1

;-744     }


;-745     return 0;

.getOp1164:
 mov ax, 0
 jmp .retngetOp1

;-746 }


;-747 


;-748 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC

;-749     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1166
 call indexerror

;-750     if (R2No==3) rm=7;//BX

.getIndReg1166:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1167
 mov ax, 7
 mov byte [rm], al

;-751     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1167:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1168
 mov ax, 6
 mov byte [rm], al

;-752     if (R2No==7) rm=5;//DI

.getIndReg1168:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1169
 mov ax, 5
 mov byte [rm], al

;-753     if (R2No==6) rm=4;//SI

.getIndReg1169:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1170
 mov ax, 4
 mov byte [rm], al

;-754     if (rm==0) indexerror();

.getIndReg1170:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1171
 call indexerror

;-755 }

.getIndReg1171:

;-756 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-757     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2172
 call indexerror

;-758     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2172:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2173
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2174
 mov ax, 3
 mov [bp-2], al

;-759              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2175
.getIndReg2174:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2176
 mov ax, 1
 mov [bp-2], al

;-760     if (R2No==6) if (rm==6) m=2;//BP+SI

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

;-761              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2179
.getIndReg2178:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2180
 mov ax, 0
 mov [bp-2], al

;-762     if (m > 3) indexerror();

.getIndReg2180:
.getIndReg2179:
.getIndReg2177:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2181
 call indexerror

;-763     return m;

.getIndReg2181:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-764 }


;-765 int getMEM() {// e.g. [array+bp+si-4]

 .retngetIndReg2: LEAVE
 ret
ENDP

getMEM: PROC

;-766 //set: disp, rm, R2Type


;-767     char c;


;-768     disp=0; rm=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-769     do {

.getMEM182:

;-770         getTokeType();

 call getTokeType

;-771         c=getOp1();

 call getOp1
 mov [bp-2], al

;-772         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM183
 call syntaxerror

;-773         if (c == REG) {

.getMEM183:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM184

;-774             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-775             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM185
 call getIndReg2
 mov byte [rm], al

;-776             else getIndReg1();

 jmp .getMEM186
.getMEM185:
 call getIndReg1

;-777         }

.getMEM186:

;-778         if (c == ADR) {

.getMEM184:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM187

;-779             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM188
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-780             else notfounderror();

 jmp .getMEM189
.getMEM188:
 call notfounderror

;-781         }

.getMEM189:

;-782         if (c == IMM) disp=disp+SymbolInt;

.getMEM187:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM190
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-783         if (isToken('-')) {

.getMEM190:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM191

;-784             getTokeType();

 call getTokeType

;-785             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM192
 call numbererror

;-786             disp = disp - SymbolInt;

.getMEM192:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-787         }


;-788     } while (isToken('+'));

.getMEM191:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM193
 jmp .getMEM182
.getMEM193:

;-789     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM194
 push getMEM_0
 call errorexit
 add  sp, 2

;-790 }

.getMEM194:

;-791 


;-792 int getOpR() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC

;-793     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-794     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR195
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-795     if (Op2 == 0)     {invaloperror();         return;}

.getOpR195:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR196
 call invaloperror
 jmp .retngetOpR

;-796     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR196:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR197
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-797     if (Op2 == REG)                            return;

.getOpR197:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR198
 jmp .retngetOpR

;-798     if (Op2 == ADR)   {

.getOpR198:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR199

;-799         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR200
 mov ax, 0
 mov word [disp], ax

;-800         else disp=LabelAddr[LabelIx];

 jmp .getOpR201
.getOpR200:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-801         return;}

.getOpR201:
 jmp .retngetOpR

;-802     error1("Name of operand expected");

.getOpR199:
 push getOpR_0
 call error1
 add  sp, 2

;-803 }


;-804 


;-805 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC

;-806     getOpR();

 call getOpR

;-807     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-808     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-809     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-810 }


;-811 


;-812 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-813     getOpL();

 call getOpL

;-814     need(',');

 push 44
 call need
 add  sp, 2

;-815     getOpR();

 call getOpR

;-816 }


;-817 int check2Ops() {

 ret
ENDP

check2Ops: PROC

;-818     get2Ops();

 call get2Ops

;-819     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops202
 call addrerror

;-820     if (Op == ADR) invaloperror();

.check2Ops202:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops203
 call invaloperror

;-821     if (Op == IMM) immeerror();

.check2Ops203:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops204
 call immeerror

;-822     if (Op2==   0) addrerror();

.check2Ops204:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops205
 call addrerror

;-823     setwflag();

.check2Ops205:
 call setwflag

;-824 }


;-825 


;-826 int storeJmp() {

 ret
ENDP

storeJmp: PROC

;-827     unsigned int i;


;-828     JmpMaxIx++;
;
 ENTER  2,0
 inc  word[JmpMaxIx]

;-829     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp206
 push storeJmp_0
 call errorexit
 add  sp, 2

;-830     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp206:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax

;-831     JmpNamePtr++;

 inc  word[JmpNamePtr]

;-832     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax

;-833     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp207
 push storeJmp_1
 call errorexit
 add  sp, 2

;-834     JmpAddr[JmpMaxIx] = PC;

.storeJmp207:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax

;-835 }


;-836 


;-837 int storeLabel() {
 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC

;-838     unsigned int i;


;-839     if(searchLabel()) error1("duplicate label");
;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel208
 push storeLabel_0
 call error1
 add  sp, 2

;-840     LabelMaxIx++;

.storeLabel208:
 inc  word[LabelMaxIx]

;-841     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel209
 push storeLabel_1
 call errorexit
 add  sp, 2

;-842     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel209:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-843     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-844     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-845     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel210
 push storeLabel_2
 call errorexit
 add  sp, 2

;-846     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel210:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-847 }


;-848 


;-849 


;-850 int genDB() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC

;-851     char c;  char isloop;


;-852         isloop = 0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al

;-853             do {

.genDB211:

;-854                 if (isloop) getTokeType();//omit ,

 mov al, [bp-4]
 or  al, al
 je .genDB212
 call getTokeType

;-855                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB212:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB213
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-856                 else {

 jmp .genDB214
.genDB213:

;-857                     skipBlank();

 call skipBlank

;-858                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB215

;-859                         do {

.genDB216:

;-860                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-861                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-862                             InputPtr++;

 inc  word[InputPtr]

;-863                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB217
 jmp .genDB216
.genDB217:

;-864                         InputPtr++;

 inc  word[InputPtr]

;-865                     }


;-866                 }

.genDB215:

;-867                 isloop = 1;

.genDB214:
 mov ax, 1
 mov [bp-4], al

;-868             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB218
 jmp .genDB211
.genDB218:

;-869 }


;-870 


;-871 int getVariable() {
 LEAVE
 ret
ENDP

getVariable: PROC

;-872     char c;


;-873     storeLabel();
;
 ENTER  2,0
 call storeLabel

;-874     getTokeType();

 call getTokeType

;-875     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable219

;-876         lookCode();

 call lookCode

;-877         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable220
 call dataexit

;-878         if (CodeType > 205) dataexit();

.getVariable220:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable221
 call dataexit

;-879         if (CodeType== 200) {//DB

.getVariable221:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable222

;-880             do {

.getVariable223:

;-881                 getTokeType();

 call getTokeType

;-882                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable224
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-883                 else {

 jmp .getVariable225
.getVariable224:

;-884                     skipBlank();

 call skipBlank

;-885                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable226

;-886                         do {

.getVariable227:

;-887                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-888                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-889                             InputPtr++;

 inc  word[InputPtr]

;-890                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable228
 jmp .getVariable227
.getVariable228:

;-891                         InputPtr++;

 inc  word[InputPtr]

;-892                     }


;-893                 }

.getVariable226:

;-894             } while (isToken(','));

.getVariable225:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable229
 jmp .getVariable223
.getVariable229:

;-895         }


;-896         if (CodeType == 201) {//DW

.getVariable222:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable230

;-897             do {

.getVariable231:

;-898                 getTokeType();

 call getTokeType

;-899                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable232
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-900             } while (isToken(','));

.getVariable232:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable233
 jmp .getVariable231
.getVariable233:

;-901         }


;-902         if (CodeType == 202) {//DD

.getVariable230:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable234

;-903             do {

.getVariable235:

;-904                 getTokeType();

 call getTokeType

;-905                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable236
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-906                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-907             } while (isToken(','));

.getVariable236:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable237
 jmp .getVariable235
.getVariable237:

;-908         }


;-909         if (CodeType >= 203) {//resb, resw, resd

.getVariable234:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable238

;-910             getTokeType();

 call getTokeType

;-911             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable239

;-912                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable240
 call syntaxerror

;-913                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable240:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable241
 push getVariable_0
 call error1
 add  sp, 2

;-914                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable241:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-915                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable242
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-916                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable242:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable243
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-917                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable243:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-918             } else numbererror();

 jmp .getVariable244
.getVariable239:
 call numbererror

;-919         }

.getVariable244:

;-920     }

.getVariable238:

;-921     else dataexit();

 jmp .getVariable245
.getVariable219:
 call dataexit

;-922 }

.getVariable245:

;-923 


;-924 int getCodeSize() {
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC

;-925     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize246

;-926         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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

;-927         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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

;-928         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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

;-929     }

.getCodeSize249:

;-930     return 0;

.getCodeSize246:
 mov ax, 0
 jmp .retngetCodeSize

;-931 }


;-932 


;-933 int FixOneJmp(unsigned int hex) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

FixOneJmp: PROC

;-934     int Ix; char c;


;-935     Ix=searchLabel();
;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax

;-936     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp250
 call notfounderror

;-937     disp = LabelAddr[Ix];

.FixOneJmp250:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-938     c = FileBin[hex];//look for 'A' push Absolute

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-939     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp251

;-940         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax

;-941         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax

;-942         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-943     }


;-944     FileBin[hex] = disp;//fix low byte

.FixOneJmp251:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al

;-945     hex++;

 inc  word[bp+4]

;-946     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-947     FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al

;-948 }


;-949 int fixJmp() {
 LEAVE
 ret
ENDP

fixJmp: PROC

;-950     unsigned int hex; int i;


;-951     char *p;


;-952     p = &JmpNames;
;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax

;-953     i = 1;

 mov ax, 1
 mov [bp-4], ax

;-954     while (i <= JmpMaxIx) {

.fixJmp252:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp253

;-955         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-956         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-957         p++;

 inc  word[bp-6]

;-958         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax

;-959         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2

;-960         i++;

 inc  word[bp-4]

;-961     }


;-962 }

 jmp .fixJmp252
.fixJmp253:

;-963 int fixJmpMain() {
 LEAVE
 ret
ENDP

fixJmpMain: PROC

;-964     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain254
 push fixJmpMain_0
 call error1
 add  sp, 2

;-965     strcpy(Symbol, "main");

.fixJmpMain254:
 push fixJmpMain_1
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-966     FixOneJmp(1);//first instruction, PC=1

 push 1
 call FixOneJmp
 add  sp, 2

;-967 }


;-968 


;-969 


;-970 int process() {

 ret
fixJmpMain_0 db "resting global jmp",0
fixJmpMain_1 db "main",0
ENDP

process: PROC

;-971     char c;


;-972     int i;


;-973     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
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

;-974     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-975     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-976     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-977     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-978     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-979 


;-980     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process255

;-981         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-982         return;

 jmp .retnprocess

;-983     }


;-984 


;-985     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process255:
 mov al, [CodeType]
 cmp al, 2
 jne .process256

;-986         getOpL();

 call getOpL

;-987         checkOpL();

 call checkOpL

;-988         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process257

;-989   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process258

;-990                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process259

;-991                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process260
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4

;-992                         else   genCode2(0x40, R1No);//INC

 jmp .process261
.process260:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4

;-993                     return;

.process261:
 jmp .retnprocess

;-994                     }


;-995             }

.process259:

;-996         }

.process258:

;-997         if (Code1 == 5) {//imul extension?

.process257:
 mov al, [Code1]
 cmp al, 5
 jne .process262

;-998             getTokeType();

 call getTokeType

;-999             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process263
 call implerror

;-1000         }

.process263:

;-1001         if (Code1 < 2) genCodeW(0xFE);

.process262:
 mov al, [Code1]
 cmp al, 2
 jge .process264
 push 254
 call genCodeW
 add  sp, 2

;-1002             else genCodeW(0xF6);

 jmp .process265
.process264:
 push 246
 call genCodeW
 add  sp, 2

;-1003         writeEA(Code1);

.process265:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1004         return;

 jmp .retnprocess

;-1005     }


;-1006 


;-1007     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process256:
 mov al, [CodeType]
 cmp al, 3
 jne .process266

;-1008         check2Ops();    //setwflag not applicable

 call check2Ops

;-1009         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process267
 call reg16error

;-1010         if (Op2 != MEM) addrerror();//only m16

.process267:
 mov al, [Op2]
 cmp al, 4
 je  .process268
 call addrerror

;-1011 


;-1012         if (Code1 >= 0xB2) {

.process268:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process269

;-1013             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process270
 push 15
 call genCode8
 add  sp, 2

;-1014         }

.process270:

;-1015         genCode8(Code1);

.process269:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1016         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1017         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1018         return;

 jmp .retnprocess

;-1019     }


;-1020 


;-1021     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process266:
 mov al, [CodeType]
 cmp al, 4
 jne .process271

;-1022         check2Ops();

 call check2Ops

;-1023         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process272

;-1024             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process273
 call notfounderror

;-1025             imme=LabelAddr[LabelIx];

.process273:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax

;-1026             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al

;-1027         }


;-1028         if (Op2 == IMM) {//second operand is imm

.process272:
 mov al, [Op2]
 cmp al, 1
 jne .process274

;-1029             setsflag();

 call setsflag

;-1030             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process275

;-1031                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process276

;-1032                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process277

;-1033                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1034                         c += 4;

 add  byte[bp-2], 4

;-1035                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1036                         genImmediate();

 call genImmediate

;-1037                         return;

 jmp .retnprocess

;-1038                     }


;-1039                 }

.process277:

;-1040             }

.process276:

;-1041             //r/m, imm: 80 sign-extended,TTT,imm


;-1042             c = sflag + 0x80;

.process275:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1043             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1044             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1045             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process278
 push word [imme]
 call genCode8
 add  sp, 2

;-1046             else genImmediate();

 jmp .process279
.process278:
 call genImmediate

;-1047             return;

.process279:
 jmp .retnprocess

;-1048         }


;-1049         c = Code1 << 3;//r/m, r/r

.process274:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1050         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process280

;-1051             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process281

;-1052                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1053                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1054                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1055                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1056                 return;

 jmp .retnprocess

;-1057             }


;-1058         }

.process281:

;-1059         if (Op2 == REG) {//mem,reg    reg,reg

.process280:
 mov al, [Op2]
 cmp al, 2
 jne .process282

;-1060             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1061             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1062             return;

 jmp .retnprocess

;-1063         }


;-1064         syntaxerror();

.process282:
 call syntaxerror

;-1065         return;

 jmp .retnprocess

;-1066     }


;-1067 


;-1068     if (CodeType == 5) {//mov (movsx, movzx=51)

.process271:
 mov al, [CodeType]
 cmp al, 5
 jne .process283

;-1069         check2Ops();

 call check2Ops

;-1070         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process284

;-1071             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process285
 mov ax, [disp]
 mov word [imme], ax

;-1072             else notfounderror();

 jmp .process286
.process285:
 call notfounderror

;-1073             Op2=IMM;//continue with IMM

.process286:
 mov ax, 1
 mov byte [Op2], al

;-1074         }


;-1075         if (Op2 == IMM) {// r,i

.process284:
 mov al, [Op2]
 cmp al, 1
 jne .process287

;-1076             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process288

;-1077                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1078                 c += 0xB0;

 add  byte[bp-2], 176

;-1079                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1080                 genImmediate();

 call genImmediate

;-1081                 return;

 jmp .retnprocess

;-1082             }


;-1083             if (Op == MEM) {// m,i

.process288:
 mov al, [Op]
 cmp al, 4
 jne .process289

;-1084                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1085                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1086                 genImmediate();

 call genImmediate

;-1087                 return;

 jmp .retnprocess

;-1088             }


;-1089             regmemerror();

.process289:
 call regmemerror

;-1090             return;

 jmp .retnprocess

;-1091         }


;-1092         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process287:
 mov al, [R1Type]
 cmp al, 4
 jne .process290
 call ChangeDirection

;-1093         if (R2Type == SEGREG) {//rm,sreg

.process290:
 mov al, [R2Type]
 cmp al, 4
 jne .process291

;-1094             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process292
 call reg16error

;-1095                 genCode2(0x8C, dflag);

.process292:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1096                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1097                 return;

 jmp .retnprocess

;-1098         }


;-1099         if (Op2 == MEM) {//acc, moffs16

.process291:
 mov al, [Op2]
 cmp al, 4
 jne .process293

;-1100             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process294

;-1101                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process295

;-1102                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process296

;-1103                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1104                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1105                         return;

 jmp .retnprocess

;-1106                     }


;-1107                 }

.process296:

;-1108             }

.process295:

;-1109         }

.process294:

;-1110         if (Op == MEM) {//moffs16, acc

.process293:
 mov al, [Op]
 cmp al, 4
 jne .process297

;-1111             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process298

;-1112                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process299

;-1113                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process300

;-1114                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1115                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1116                         return;

 jmp .retnprocess

;-1117                     }


;-1118                 }

.process300:

;-1119             }

.process299:

;-1120 


;-1121         }

.process298:

;-1122         if (Op2 == REG) {//rm, r

.process297:
 mov al, [Op2]
 cmp al, 2
 jne .process301

;-1123             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1124             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1125             return;

 jmp .retnprocess

;-1126         }


;-1127         if (Op2 == MEM) {//r, m

.process301:
 mov al, [Op2]
 cmp al, 4
 jne .process302

;-1128             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process303

;-1129                 ChangeDirection();

 call ChangeDirection

;-1130                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1131                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1132                 return;

 jmp .retnprocess

;-1133             }


;-1134         }

.process303:

;-1135         syntaxerror();

.process302:
 call syntaxerror

;-1136         return;

 jmp .retnprocess

;-1137     }


;-1138 


;-1139     if (CodeType == 6) {//Jcc

.process283:
 mov al, [CodeType]
 cmp al, 6
 jne .process304

;-1140         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process305

;-1141             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1142             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process306

;-1143                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1144                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1145                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1146                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process307

;-1147                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1148                     disp -= 2;

 sub  word[disp], 2

;-1149                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1150                 } else {

 jmp .process308
.process307:

;-1151                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1152                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1153                     disp -= 4;

 sub  word[disp], 4

;-1154                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1155                 }


;-1156             }

.process308:

;-1157             else {//jump forward, near only

 jmp .process309
.process306:

;-1158                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1159                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1160                 storeJmp();

 call storeJmp

;-1161                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1162                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1163             }


;-1164         return;

.process309:
 jmp .retnprocess

;-1165         }


;-1166     }

.process305:

;-1167 


;-1168     if (CodeType == 7) {//jmp, call

.process304:
 mov al, [CodeType]
 cmp al, 7
 jne .process310

;-1169         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process311

;-1170             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1171             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process312

;-1172                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1173                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1174                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1175                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process313

;-1176                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process314

;-1177                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1178                         disp -= 2;

 sub  word[disp], 2

;-1179                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1180                     }


;-1181                     else {

 jmp .process315
.process314:

;-1182                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1183                         disp -= 3;

 sub  word[disp], 3

;-1184                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1185                     }


;-1186                 }

.process315:

;-1187                 else {

 jmp .process316
.process313:

;-1188                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1189                     disp -= 3;

 sub  word[disp], 3

;-1190                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1191                 }


;-1192             }

.process316:

;-1193             else {//jump forward, near only

 jmp .process317
.process312:

;-1194                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1195                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process318
 call storeJmp

;-1196                 genCode16(0);

.process318:
 push 0
 call genCode16
 add  sp, 2

;-1197                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1198             }


;-1199         return;

.process317:
 jmp .retnprocess

;-1200         }


;-1201     }

.process311:

;-1202 


;-1203     if (CodeType ==  8) {//ret,retf

.process310:
 mov al, [CodeType]
 cmp al, 8
 jne .process319

;-1204         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process320

;-1205             if (Code1 == 0xC3) genCode8(0xC2);//ret n

 mov al, [Code1]
 cmp al, 195
 jne .process321
 push 194
 call genCode8
 add  sp, 2

;-1206                 else genCode8(0xCA);//retf n

 jmp .process322
.process321:
 push 202
 call genCode8
 add  sp, 2

;-1207             genCode16(SymbolInt);

.process322:
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1208             return;

 jmp .retnprocess

;-1209         }


;-1210         genCode8(Code1);

.process320:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1211         return;

 jmp .retnprocess

;-1212     }


;-1213 


;-1214     if (CodeType == 9) {//push, pop

.process319:
 mov al, [CodeType]
 cmp al, 9
 jne .process323

;-1215         getOpL();

 call getOpL

;-1216         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process324

;-1217             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process325

;-1218                 setsflag();

 call setsflag

;-1219                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1220                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process326
 push word [imme]
 call genCode8
 add  sp, 2

;-1221                 else       genCode16(imme);

 jmp .process327
.process326:
 push word [imme]
 call genCode16
 add  sp, 2

;-1222                 return;

.process327:
 jmp .retnprocess

;-1223             }


;-1224             if (Op == ADR) {//push string ABSOLUTE i16

.process325:
 mov al, [Op]
 cmp al, 3
 jne .process328

;-1225                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process329

;-1226                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1227                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1228                     return;

 jmp .retnprocess

;-1229                 }


;-1230                 else {

 jmp .process330
.process329:

;-1231                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1232                     storeJmp();

 call storeJmp

;-1233                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2

;-1234                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al

;-1235                     return;

 jmp .retnprocess

;-1236                 }


;-1237             }

.process330:

;-1238         }

.process328:

;-1239         if (R1Type == SEGREG) {

.process324:
 mov al, [R1Type]
 cmp al, 4
 jne .process331

;-1240             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process332

;-1241                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process333
 push process_0
 call error1
 add  sp, 2

;-1242             }

.process333:

;-1243             c = R1No <<3;

.process332:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1244             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process334

;-1245                 c += 122;  //0x7A

 add  byte[bp-2], 122

;-1246                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1247             }


;-1248             if (Code1 == 0x50) c +=6;//push

.process334:
 mov al, [Code1]
 cmp al, 80
 jne .process335
 add  byte[bp-2], 6

;-1249                 else c += 7;//pop

 jmp .process336
.process335:
 add  byte[bp-2], 7

;-1250             genCode8(c);

.process336:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1251             return;

 jmp .retnprocess

;-1252         }


;-1253         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

.process331:
 call checkOpL

;-1254 


;-1255         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process337

;-1256             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process338

;-1257                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2

;-1258                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2

;-1259             }else {

 jmp .process339
.process338:

;-1260                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2

;-1261                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2

;-1262             }


;-1263             return;

.process339:
 jmp .retnprocess

;-1264         }


;-1265         if (R1Type == BYTE) reg16error();

.process337:
 mov al, [R1Type]
 cmp al, 1
 jne .process340
 call reg16error

;-1266         if (R1Type == WORD) {//is REG, w/o SEGREG

.process340:
 mov al, [R1Type]
 cmp al, 2
 jne .process341

;-1267             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1268             return;

 jmp .retnprocess

;-1269         }


;-1270         syntaxerror();

.process341:
 call syntaxerror

;-1271         return;

 jmp .retnprocess

;-1272     }


;-1273 


;-1274     if (CodeType == 11) {//shift, rotate

.process323:
 mov al, [CodeType]
 cmp al, 11
 jne .process342

;-1275         check2Ops();

 call check2Ops

;-1276         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process343

;-1277             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process344

;-1278                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1279                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1280                 return;

 jmp .retnprocess

;-1281             }


;-1282             genCodeW(0xC0);//80186

.process344:
 push 192
 call genCodeW
 add  sp, 2

;-1283             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1284             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1285             return;

 jmp .retnprocess

;-1286         }


;-1287         if (Op2 == REG) {

.process343:
 mov al, [Op2]
 cmp al, 2
 jne .process345

;-1288             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process346

;-1289                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process347

;-1290                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process348
 mov ax, 1
 mov byte [wflag], al

;-1291                     genCodeW(0xD2);

.process348:
 push 210
 call genCodeW
 add  sp, 2

;-1292                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1293                     return;

 jmp .retnprocess

;-1294                 }


;-1295             }

.process347:

;-1296         }

.process346:

;-1297     }

.process345:

;-1298 


;-1299     if (CodeType == 12) {//int

.process342:
 mov al, [CodeType]
 cmp al, 12
 jne .process349

;-1300         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process350

;-1301             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1302             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1303             return;

 jmp .retnprocess

;-1304         }


;-1305     }

.process350:

;-1306 


;-1307     if (CodeType == 14) {//in, out

.process349:
 mov al, [CodeType]
 cmp al, 14
 jne .process351

;-1308         implerror();

 call implerror

;-1309         return;

 jmp .retnprocess

;-1310     }


;-1311     if (CodeType == 15) {//xchg

.process351:
 mov al, [CodeType]
 cmp al, 15
 jne .process352

;-1312         implerror();

 call implerror

;-1313         return;

 jmp .retnprocess

;-1314     }


;-1315     if (CodeType == 16) {//loop

.process352:
 mov al, [CodeType]
 cmp al, 16
 jne .process353

;-1316         implerror();

 call implerror

;-1317         return;

 jmp .retnprocess

;-1318     }


;-1319 


;-1320     if (CodeType == 30) {//enter i18,i8

.process353:
 mov al, [CodeType]
 cmp al, 30
 jne .process354

;-1321         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1322         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1323         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process355
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1324         else numbererror();

 jmp .process356
.process355:
 call numbererror

;-1325         need(',');

.process356:
 push 44
 call need
 add  sp, 2

;-1326         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1327         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process357
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1328         else numbererror();

 jmp .process358
.process357:
 call numbererror

;-1329         return;

.process358:
 jmp .retnprocess

;-1330     }


;-1331 


;-1332     if (CodeType == 41) {//test

.process354:
 mov al, [CodeType]
 cmp al, 41
 jne .process359

;-1333         implerror();

 call implerror

;-1334         return;

 jmp .retnprocess

;-1335     }


;-1336 


;-1337     if (CodeType == 51) {//movsx, movzx=51

.process359:
 mov al, [CodeType]
 cmp al, 51
 jne .process360

;-1338         implerror();

 call implerror

;-1339         return;

 jmp .retnprocess

;-1340     }


;-1341 


;-1342     if (CodeType==101) {//ORG nn

.process360:
 mov al, [CodeType]
 cmp al, 101
 jne .process361

;-1343         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process362
 call numbererror

;-1344         Origin=SymbolInt;

.process362:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1345         return;

 jmp .retnprocess

;-1346     }


;-1347 


;-1348     if (CodeType == 102) {//section, segment

.process361:
 mov al, [CodeType]
 cmp al, 102
 jne .process363

;-1349         //getTokeType();//ignore .bss .text .data


;-1350         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1351         return;

 jmp .retnprocess

;-1352     }


;-1353 


;-1354     if (CodeType == 110) {//absolute

.process363:
 mov al, [CodeType]
 cmp al, 110
 jne .process364

;-1355         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process365
 call numbererror

;-1356         AbsoluteLab=SymbolInt;

.process365:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1357         return;

 jmp .retnprocess

;-1358     }


;-1359     if (CodeType == 111) {//name: PROC

.process364:
 mov al, [CodeType]
 cmp al, 111
 jne .process366

;-1360         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process367

;-1361             prs("\nentering: ");

 push process_1
 call prs
 add  sp, 2

;-1362             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1363             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1364             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax

;-1365             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax

;-1366             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax

;-1367             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax

;-1368         } else error1("already in PROC");

 jmp .process368
.process367:
 push process_2
 call error1
 add  sp, 2

;-1369         return;

.process368:
 jmp .retnprocess

;-1370     }


;-1371     if (CodeType == 112) {//ENDP

.process366:
 mov al, [CodeType]
 cmp al, 112
 jne .process369

;-1372         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process370
 push process_3
 call error1
 add  sp, 2

;-1373         prs("\nleaving: ");

.process370:
 push process_4
 call prs
 add  sp, 2

;-1374         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1375         prs(", loc labels: ");

 push process_5
 call prs
 add  sp, 2

;-1376         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax

;-1377         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1378         prs(", loc jmp forward: ");

 push process_6
 call prs
 add  sp, 2

;-1379         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax

;-1380         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1381         fixJmp();

 call fixJmp

;-1382         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1383         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax

;-1384         LabelMaxIx   = tmpLabelMaxIx;

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax

;-1385         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax

;-1386         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax

;-1387         return;

 jmp .retnprocess

;-1388     }


;-1389     if (CodeType == 200) {//db

.process369:
 mov al, [CodeType]
 cmp al, 200
 jne .process371

;-1390         genDB();

 call genDB

;-1391         return;

 jmp .retnprocess

;-1392     }


;-1393 


;-1394     error1("Command not implemented or syntax error");

.process371:
 push process_7
 call error1
 add  sp, 2

;-1395 }


;-1396 


;-1397 int parse() {

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

;-1398     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-1399     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax

;-1400     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-1401     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax

;-1402     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-1403     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1404     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al

;-1405 


;-1406     do {//process a new line

.parse372:

;-1407         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-1408         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-1409         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-1410         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-1411         getLine();

 call getLine

;-1412         if (DOS_NoBytes) {

 mov ax, [DOS_NoBytes]
 or  al, al
 je .parse373

;-1413             InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-1414             getTokeType();//getCode in SymbolUpper,

 call getTokeType

;-1415                           //set TokeType,isLabel by getName


;-1416             if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse374

;-1417                 if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse375

;-1418                   if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse376
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-1419                     storeLabel();

.parse376:
 call storeLabel

;-1420                     InputPtr++;//remove :

 inc  word[InputPtr]

;-1421                     getTokeType();

 call getTokeType

;-1422                 }


;-1423             }

.parse375:

;-1424             if (TokeType == ALNUME) {

.parse374:
 mov al, [TokeType]
 cmp al, 3
 jne .parse377

;-1425                 lookCode();

 call lookCode

;-1426                 if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse378
 call process

;-1427                 else getVariable();

 jmp .parse379
.parse378:
 call getVariable

;-1428                 skipRest();

.parse379:
 call skipRest

;-1429             }


;-1430             else if(TokeType >ALNUME)error1("Label or instruction expected");

 jmp .parse380
.parse377:
 mov al, [TokeType]
 cmp al, 3
 jle .parse381
 push parse_0
 call error1
 add  sp, 2

;-1431             else if(TokeType==DIGIT )error1("No digit allowed at start");

 jmp .parse382
.parse381:
 mov al, [TokeType]
 cmp al, 1
 jne .parse383
 push parse_1
 call error1
 add  sp, 2

;-1432             printLine();  

.parse383:
.parse382:
.parse380:
 call printLine

;-1433         }


;-1434     } while (DOS_NoBytes != 0 );

.parse373:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse384
 jmp .parse372
.parse384:

;-1435     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al

;-1436 }


;-1437 


;-1438 int getarg() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start",0
ENDP

getarg: PROC

;-1439     int arglen1; int i; char *c;


;-1440     arglen1=*arglen;
;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-1441     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg385

;-1442         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-1443         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-1444         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-1445     }


;-1446     i=arglen1+129;

.getarg385:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-1447     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-1448     arglen1--;

 dec  word[bp-2]

;-1449     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-1450 


;-1451     strcpy(namein, argv); strcat1(namein, ".S");

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

;-1452     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-1453     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-1454 


;-1455   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-1456 


;-1457     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-1458     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

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

;-1459     lst_fd=creatR(namelst);

.getarg386:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-1460     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

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

;-1461     bin_fd=creatR(namebin);

.getarg387:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-1462     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

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

;-1463 


;-1464     prs(";");

.getarg388:
 push getarg_7
 call prs
 add  sp, 2

;-1465     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-1466     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-1467     prs("\n");

 push getarg_9
 call prs
 add  sp, 2

;-1468 }


;-1469 


;-1470 int main() {
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
getarg_9 db "\n",0
ENDP

main: PROC

;-1471     getarg();

 call getarg

;-1472     parse();

 call parse

;-1473     fixJmpMain();

 call fixJmpMain

;-1474     epilog();

 call epilog

;-1475     end1();

 call end1

;-1476 }

 ret
ENDP
;Glob. variables:187 (200), Functions:87 (300), Lines:1477
;Constant: 658 (3000), stacksize: 6482