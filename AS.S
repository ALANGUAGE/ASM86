
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

;-110 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
 LEAVE
 ret
ENDP

readRL: PROC
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

;-111 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP

fputcR: PROC
;Function : fputcR, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   111 NULL n = bp+4
;  201 var sign word   111 NULL fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]

;-112   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-113 


;-114 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
 LEAVE
 ret
ENDP

getLine: PROC

;-115   unsigned int i;


;-116   InputPtr= &InputBuf;

;Function : getLine, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   115 NULL i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-117   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-118   do {

.getLine4:

;-119     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-120     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine5
 push getLine_0
 call errorexit
 add  sp, 2

;-121     if (DOS_NoBytes == 0) return;

.getLine5:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine6
 jmp .retngetLine

;-122     *InputPtr = DOS_ByteRead;

.getLine6:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-123     InputPtr++;

 inc  word[InputPtr]

;-124     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-125     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine7
 push getLine_1
 call errorexit
 add  sp, 2

;-126   } while (ifEOL(DOS_ByteRead) == 0);

.getLine7:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne .getLine8
 jmp .getLine4
.getLine8:

;-127   InputPtr--;

 dec  word[InputPtr]

;-128   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-129 }


;-130 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

ifEOL: PROC

;-131   if (c == 10) return 1;//LF

;Function : ifEOL, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   130 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL9
 mov ax, 1
 jmp .retnifEOL

;-132   if (c == 13) {//CR

.ifEOL9:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL10

;-133     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-134     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL11
 push ifEOL_0
 call errorexit
 add  sp, 2

;-135     return 1;

.ifEOL11:
 mov ax, 1
 jmp .retnifEOL

;-136   }


;-137   return 0;

.ifEOL10:
 mov ax, 0
 jmp .retnifEOL

;-138 }


;-139 int skipBlank() {

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

skipBlank: PROC

;-140   skipblank1:

.skipblank1:

;-141     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank12
 inc  word[InputPtr]
 jmp .skipblank1

;-142     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank12:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank13
 inc  word[InputPtr]
 jmp .skipblank1

;-143 }

.skipBlank13:

;-144 int letterE(char c) {

 ret
ENDP

letterE: PROC

;-145   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   144 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE14
 mov ax, 1
 jmp .retnletterE

;-146   if (c=='.') return 1;

.letterE14:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE15
 mov ax, 1
 jmp .retnletterE

;-147   if (c=='?') return 1;

.letterE15:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE16
 mov ax, 1
 jmp .retnletterE

;-148   if (c=='$') return 1;

.letterE16:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE17
 mov ax, 1
 jmp .retnletterE

;-149   if (c> 'z') return 0;

.letterE17:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE18
 mov ax, 0
 jmp .retnletterE

;-150   if (c< '@') return 0; // at included

.letterE18:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE19
 mov ax, 0
 jmp .retnletterE

;-151   if (c> 'Z') { if (c< 'a') return 0; }

.letterE19:
 mov al, [bp+4]
 cmp al, 90
 jle .letterE20
 mov al, [bp+4]
 cmp al, 97
 jge .letterE21
 mov ax, 0
 jmp .retnletterE
.letterE21:

;-152   return 1;

.letterE20:
 mov ax, 1
 jmp .retnletterE

;-153 }


;-154 int alnumE(char c) {

 .retnletterE: LEAVE
 ret
ENDP

alnumE: PROC

;-155   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   154 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .alnumE22
 mov ax, 1
 jmp .retnalnumE

;-156   if (letterE(c)) return 1;

.alnumE22:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .alnumE23
 mov ax, 1
 jmp .retnalnumE

;-157   return 0;

.alnumE23:
 mov ax, 0
 jmp .retnalnumE

;-158 }


;-159 int digit(char c){

 .retnalnumE: LEAVE
 ret
ENDP

digit: PROC

;-160     if(c<'0') return 0;

;Function : digit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   159 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit24
 mov ax, 0
 jmp .retndigit

;-161     if(c>'9') return 0;

.digit24:
 mov al, [bp+4]
 cmp al, 57
 jle .digit25
 mov ax, 0
 jmp .retndigit

;-162     return 1;

.digit25:
 mov ax, 1
 jmp .retndigit

;-163 }


;-164 int strlen(char *s) { int c;

 .retndigit: LEAVE
 ret
ENDP

strlen: PROC

;-165     c=0;

;Function : strlen, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   164 NULL s = bp+4
;  201 var sign word   164 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax

;-166     while (*s!=0) {s++; c++;}

.strlen26:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen27
 inc  word[bp+4]
 inc  word[bp-2]

;-167     return c;

 jmp .strlen26
.strlen27:
 mov ax, [bp-2]
 jmp .retnstrlen

;-168     }


;-169 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP

strcpy: PROC

;-170     do { *s=*t; s++; t++; }

;Function : strcpy, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   169 NULL s = bp+4
;  201 ptr sign byte   169 NULL t = bp+6;
 ENTER  0,0
.strcpy28:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]

;-171     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy29
 jmp .strcpy28
.strcpy29:

;-172     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al

;-173     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy

;-174     }


;-175 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP

eqstr: PROC

;-176     while(*p) {

;Function : eqstr, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   175 NULL p = bp+4
;  201 ptr sign byte   175 NULL q = bp+6;
 ENTER  0,0
.eqstr30:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr31

;-177         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr32
 mov ax, 0
 jmp .retneqstr

;-178             p++;

.eqstr32:
 inc  word[bp+4]

;-179             q++;

 inc  word[bp+6]

;-180             }


;-181     if(*q) return 0;

 jmp .eqstr30
.eqstr31:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr33
 mov ax, 0
 jmp .retneqstr

;-182     return 1;

.eqstr33:
 mov ax, 1
 jmp .retneqstr

;-183     }


;-184 int strcat1(char *s, char *t) {

 .retneqstr: LEAVE
 ret
ENDP

strcat1: PROC

;-185     while (*s != 0) s++;

;Function : strcat1, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   184 NULL s = bp+4
;  201 ptr sign byte   184 NULL t = bp+6;
 ENTER  0,0
.strcat134:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat135
 inc  word[bp+4]

;-186     strcpy(s, t);

 jmp .strcat134
.strcat135:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-187     }


;-188 int toupper(char *s) {
 LEAVE
 ret
ENDP

toupper: PROC

;-189     while(*s) {

;Function : toupper, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   188 NULL s = bp+4;
 ENTER  0,0
.toupper36:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper37

;-190         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper38
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper39
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al

;-191             s++;

.toupper39:
.toupper38:
 inc  word[bp+4]

;-192               }


;-193     }

 jmp .toupper36
.toupper37:

;-194 


;-195 int getDigit(unsigned char c) {//ret: SymbolInt
 LEAVE
 ret
ENDP

getDigit: PROC

;-196   unsigned int CastInt;


;-197   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   195 NULL c = bp+4
;  201 var unsg word   196 NULL CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-198   do {

.getDigit40:

;-199     c-='0';

 sub  byte[bp+4], 48

;-200     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-201     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-202     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-203     InputPtr++;

 inc  word[InputPtr]

;-204     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-205   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit41
 jmp .getDigit40
.getDigit41:

;-206 }


;-207 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-208   char *p; unsigned int i;


;-209   p = &Symbol;

;Function : getName, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   207 NULL c = bp+4
;  201 ptr sign byte   208 NULL p = bp-2
;  202 var unsg word   208 NULL i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-210   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-211   p++;

 inc  word[bp-2]

;-212   while (alnumE(c)) {

.getName42:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName43

;-213     InputPtr++;

 inc  word[InputPtr]

;-214     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-215     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-216     p++;

 inc  word[bp-2]

;-217     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-218     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName44
 push getName_0
 call errorexit
 add  sp, 2

;-219   }

.getName44:

;-220   if (c == ':') isLabel=1; else isLabel=0;

 jmp .getName42
.getName43:
 mov al, [bp+4]
 cmp al, 58
 jne .getName45
 mov ax, 1
 mov byte [isLabel], al
 jmp .getName46
.getName45:
 mov ax, 0
 mov byte [isLabel], al

;-221   p--;

.getName46:
 dec  word[bp-2]

;-222   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-223   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-224   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-225 }


;-226 int testReg() {
 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP

testReg: PROC

;-227 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-228   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al

;-229   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg47
 mov ax, 0
 jmp .retntestReg

;-230   if (strlen(Symbol) > 3) return 0;

.testReg47:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg48
 mov ax, 0
 jmp .retntestReg

;-231   R2Type=BYTE;

.testReg48:
 mov ax, 1
 mov byte [R2Type], al

;-232   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg49
 mov ax, 0
 jmp .retntestReg

;-233   if (eqstr(SymbolUpper, "CL")) return 1;

.testReg49:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg50
 mov ax, 1
 jmp .retntestReg

;-234   if (eqstr(SymbolUpper, "DL")) return 2;

.testReg50:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg51
 mov ax, 2
 jmp .retntestReg

;-235   if (eqstr(SymbolUpper, "BL")) return 3;

.testReg51:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg52
 mov ax, 3
 jmp .retntestReg

;-236   if (eqstr(SymbolUpper, "AH")) return 4;

.testReg52:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg53
 mov ax, 4
 jmp .retntestReg

;-237   if (eqstr(SymbolUpper, "CH")) return 5;

.testReg53:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg54
 mov ax, 5
 jmp .retntestReg

;-238   if (eqstr(SymbolUpper, "DH")) return 6;

.testReg54:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg55
 mov ax, 6
 jmp .retntestReg

;-239   if (eqstr(SymbolUpper, "BH")) return 7;

.testReg55:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg56
 mov ax, 7
 jmp .retntestReg

;-240   R2Type=WORD;

.testReg56:
 mov ax, 2
 mov byte [R2Type], al

;-241   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg57
 mov ax, 0
 jmp .retntestReg

;-242   if (eqstr(SymbolUpper, "CX")) return 1;

.testReg57:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg58
 mov ax, 1
 jmp .retntestReg

;-243   if (eqstr(SymbolUpper, "DX")) return 2;

.testReg58:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg59
 mov ax, 2
 jmp .retntestReg

;-244   if (eqstr(SymbolUpper, "BX")) return 3;

.testReg59:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg60
 mov ax, 3
 jmp .retntestReg

;-245   if (eqstr(SymbolUpper, "SP")) return 4;

.testReg60:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg61
 mov ax, 4
 jmp .retntestReg

;-246   if (eqstr(SymbolUpper, "BP")) return 5;

.testReg61:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg62
 mov ax, 5
 jmp .retntestReg

;-247   if (eqstr(SymbolUpper, "SI")) return 6;

.testReg62:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg63
 mov ax, 6
 jmp .retntestReg

;-248   if (eqstr(SymbolUpper, "DI")) return 7;

.testReg63:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg64
 mov ax, 7
 jmp .retntestReg

;-249   R2Type=SEGREG;

.testReg64:
 mov ax, 4
 mov byte [R2Type], al

;-250   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg65
 mov ax, 0
 jmp .retntestReg

;-251   if (eqstr(SymbolUpper, "CS")) return 1;

.testReg65:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg66
 mov ax, 1
 jmp .retntestReg

;-252   if (eqstr(SymbolUpper, "SS")) return 2;

.testReg66:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg67
 mov ax, 2
 jmp .retntestReg

;-253   if (eqstr(SymbolUpper, "DS")) return 3;

.testReg67:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg68
 mov ax, 3
 jmp .retntestReg

;-254   if (eqstr(SymbolUpper, "FS")) return 4;

.testReg68:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg69
 mov ax, 4
 jmp .retntestReg

;-255   if (eqstr(SymbolUpper, "GS")) return 5;

.testReg69:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg70
 mov ax, 5
 jmp .retntestReg

;-256   R2Type=DWORD;

.testReg70:
 mov ax, 3
 mov byte [R2Type], al

;-257   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg71
 mov ax, 0
 jmp .retntestReg

;-258   if (eqstr(SymbolUpper, "ECX"))return 1;

.testReg71:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg72
 mov ax, 1
 jmp .retntestReg

;-259   if (eqstr(SymbolUpper, "EDX"))return 2;

.testReg72:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg73
 mov ax, 2
 jmp .retntestReg

;-260   if (eqstr(SymbolUpper, "EBX"))return 3;

.testReg73:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg74
 mov ax, 3
 jmp .retntestReg

;-261   if (eqstr(SymbolUpper, "ESP"))return 4;

.testReg74:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg75
 mov ax, 4
 jmp .retntestReg

;-262   if (eqstr(SymbolUpper, "EBP"))return 5;

.testReg75:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg76
 mov ax, 5
 jmp .retntestReg

;-263   if (eqstr(SymbolUpper, "ESI"))return 6;

.testReg76:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg77
 mov ax, 6
 jmp .retntestReg

;-264   if (eqstr(SymbolUpper, "EDI"))return 7;

.testReg77:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg78
 mov ax, 7
 jmp .retntestReg

;-265   R2Type=0; return 0;

.testReg78:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg

;-266 }


;-267 


;-268 


;-269 //#include "OUTPUT.C"


;-270 int printLine() {

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

printLine: PROC

;-271     int i; char c;


;-272     prs("\n");

;Function : printLine, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   271 NULL i = bp-2
;  201 var sign byte   271 NULL c = bp-4;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-273     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-274     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine79
 push printLine_1
 call prs
 add  sp, 2

;-275     else {

 jmp .printLine80
.printLine79:

;-276 //        prc(' ');


;-277         i=0;

 mov ax, 0
 mov [bp-2], ax

;-278         do {

.printLine81:

;-279             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al

;-280             prc(' ');

 push 32
 call prc
 add  sp, 2

;-281             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-282             i++;

 inc  word[bp-2]

;-283         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine82
 jmp .printLine81
.printLine82:

;-284         while (i < OPMAXLEN) {// fill rest with blank

.printLine83:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine84

;-285             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-286             i++;

 inc  word[bp-2]

;-287         }


;-288     }

 jmp .printLine83
.printLine84:

;-289     prc(PrintRA);

.printLine80:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-290     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-291 }


;-292 int prc(unsigned char c) {//print char
 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

prc: PROC

;-293         if ( _ c==10) {

;Function : prc, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   292 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .prc85

;-294             ax=13;

 mov  ax, 13

;-295             writetty();

 call writetty

;-296             }


;-297         al=c;

.prc85:
 mov  al, [bp+4]

;-298         writetty();

 call writetty

;-299     fputcR(c,lst_fd);

 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-300 }


;-301 


;-302 int prscomment(unsigned char *s) {
 LEAVE
 ret
ENDP

prscomment: PROC

;-303     unsigned char c;


;-304     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   302 NULL s = bp+4
;  201 var unsg byte   303 NULL c = bp-2;
 ENTER  2,0
.prscomment86:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment87

;-305         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-306         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-307         s++;

 inc  word[bp+4]

;-308     }


;-309 }

 jmp .prscomment86
.prscomment87:

;-310 int prs(unsigned char *s) {
 LEAVE
 ret
ENDP

prs: PROC

;-311     unsigned char c;


;-312     int com;


;-313     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   310 NULL s = bp+4
;  201 var unsg byte   311 NULL c = bp-2
;  202 var sign word   312 NULL com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax

;-314     while (*s) {

.prs88:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs89

;-315         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-316         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs90

;-317             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs91
 mov ax, 0
 mov [bp-4], ax

;-318                 else com=1;

 jmp .prs92
.prs91:
 mov ax, 1
 mov [bp-4], ax

;-319         }

.prs92:

;-320         if (c==92) {

.prs90:
 mov al, [bp-2]
 cmp al, 92
 jne .prs93

;-321             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs94

;-322                 s++;

 inc  word[bp+4]

;-323                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-324                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs95
 mov ax, 10
 mov [bp-2], al

;-325                 if (c=='t') c= 9;

.prs95:
 mov al, [bp-2]
 cmp al, 116
 jne .prs96
 mov ax, 9
 mov [bp-2], al

;-326             }

.prs96:

;-327         }

.prs94:

;-328         prc(c);

.prs93:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-329         s++;

 inc  word[bp+4]

;-330     }


;-331 }

 jmp .prs88
.prs89:

;-332 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP

printhex8a: PROC

;-333     unsigned char nib;


;-334     nib = c >> 4; printhex4(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   332 NULL c = bp+4
;  201 var unsg byte   333 NULL nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-335     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-336 }


;-337 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP

printhex4: PROC

;-338     c += 48;

;Function : printhex4, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   337 NULL c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48

;-339     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex497
 add  byte[bp+4], 7

;-340     prc(c);

.printhex497:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-341 }


;-342 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP

printhex16: PROC

;-343     unsigned int half;


;-344     half = i >>  8; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   342 NULL i = bp+4
;  201 var unsg word   343 NULL half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-345     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-346 }


;-347 int printIntU(unsigned int n) {
 LEAVE
 ret
ENDP

printIntU: PROC

;-348     unsigned int e;


;-349     if ( _ n >= 10) {

;Function : printIntU, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   347 NULL n = bp+4
;  201 var unsg word   348 NULL e = bp-2;
 ENTER  2,0 ; constant expression
cmp word[bp+4], 10 ;unsigned : 0
 jb  .printIntU98

;-350         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax

;-351         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-352     }


;-353     n = n % 10; //unsigned mod

.printIntU98:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax

;-354     n += '0';

 add  word[bp+4], 48

;-355     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-356 }


;-357 


;-358 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-359     ErrorCount++;

;Function : error1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   358 NULL s = bp+4;
 ENTER  0,0
 inc  word[ErrorCount]

;-360     prs("\n;***** next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-361     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-362     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-363     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-364 }


;-365 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-366     error1(s);

;Function : errorexit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   365 NULL s = bp+4;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-367     epilog();

 call epilog

;-368     end1(1);

 push 1
 call end1
 add  sp, 2

;-369 }


;-370 int notfounderror(){
 LEAVE
 ret
ENDP

notfounderror: PROC

;-371     ErrorCount++;

 inc  word[ErrorCount]

;-372     prs("\n;***** ERROR: label not found: ");

 push notfounderror_0
 call prs
 add  sp, 2

;-373     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-374     prs(" ");

 push notfounderror_1
 call prs
 add  sp, 2

;-375 }


;-376 int allowederror() {error1("not allowed here"); }

 ret
notfounderror_0 db "\n;***** ERROR: label not found: ",0
notfounderror_1 db " ",0
ENDP

allowederror: PROC
 push allowederror_0
 call error1
 add  sp, 2

;-377 int addrerror()    {error1("address missing");}

 ret
allowederror_0 db "not allowed here",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-378 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-379 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-380 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-381 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-382 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-383 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-384 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-385 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-386 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-387 


;-388 int addrexit()     {errorexit("illegal address");}

 ret
syntaxerror_0 db "syntax",0
ENDP

addrexit: PROC
 push addrexit_0
 call errorexit
 add  sp, 2

;-389 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
addrexit_0 db "illegal address",0
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-390 int internexit()   {errorexit("intern compiler error");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

internexit: PROC
 push internexit_0
 call errorexit
 add  sp, 2

;-391 


;-392 


;-393 //#include "OPTABL.C"


;-394 char I_START=0xF1;

 ret
internexit_0 db "intern compiler error",0
ENDP
I_START db 241

;-395 //OpName, 0, CodeType, OpCode1-n, F1h


;-396 //  1:   1 byte opcode


;-397 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-398 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-399 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-400 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-401 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-402 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-403 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-404 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-405 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-406 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-407 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-408 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-409 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-410 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-411 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-412 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-413 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-414 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-415 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-416 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-417 // 2: mem reg 16 bit


;-418 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-419 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-420 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-421 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-422 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-423 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-424 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-425 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-426 //  3: les, lda, lea, lss, lfs, lgs


;-427 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-428 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-429 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-430 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-431 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-432 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-433 //  4: acc,imm  reg,imm  index,reg


;-434 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-435 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-436 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-437 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-438 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-439 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-440 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-441 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-442 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-443 //  5: mov


;-444 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-445 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-446 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-447 //  6: single byte relative jump


;-448 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-449 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-450 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-451 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-452 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-453 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-454 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-455 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-456 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-457 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-458 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-459 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-460 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-461 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-462 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-463 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-464 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-465 //  7: jmp, call


;-466 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-467 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-468 //  8: ret


;-469 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-470 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-471 //  9: seg, r/m


;-472 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,255,6,6,241

;-473 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16

I_POP db 80,79,80,0,9,88,143,0,7,241

;-474 //  11: shift, rotates


;-475 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-476 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-477 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-478 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-479 //  12: int


;-480 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-481 //  14: in/out


;-482 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-483 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-484 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-485 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-486 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-487 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-488 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-489 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-490 //  15: xchg


;-491 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-492 //  16: loop, jcxz


;-493 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-494 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-495 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-496 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-497 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-498 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-499 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-500 //  30: enter


;-501 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-502 // 100: directives


;-503 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-504 // section, segment .TEXT .DATA .BSS


;-505 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-506 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-507 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-508 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-509 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-510 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-511 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-512 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-513 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-514 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-515 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-516 char I_END=0;// end of table char

I_END db 0

;-517 


;-518 int lookCode() {//ret: CodeType, *OpCodePtr


lookCode: PROC

;-519     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-520     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-521     OpCodePtr++;

 inc  word[OpCodePtr]

;-522     do  {

.lookCode99:

;-523         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode100

;-524             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode101:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode102
 inc  word[OpCodePtr]

;-525             OpCodePtr++;

 jmp .lookCode101
.lookCode102:
 inc  word[OpCodePtr]

;-526             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-527             return;

 jmp .retnlookCode

;-528         }


;-529     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode100:
.lookCode103:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode104
 inc  word[OpCodePtr]

;-530     OpCodePtr++;

 jmp .lookCode103
.lookCode104:
 inc  word[OpCodePtr]

;-531     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode105
 jmp .lookCode99
.lookCode105:

;-532 }


;-533 


;-534 //#include "OPS.C"


;-535 int ChangeDirection() {

 .retnlookCode:
 ret
ENDP

ChangeDirection: PROC

;-536     char c;


;-537     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   536 NULL c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-538     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-539     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-540     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-541 }


;-542 


;-543 int checkOpL() {
 LEAVE
 ret
ENDP

checkOpL: PROC

;-544     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL106
 call implerror

;-545     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL106:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL107
 call segregerror
 jmp .retncheckOpL

;-546     setwflag();

.checkOpL107:
 call setwflag

;-547     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL108
 push checkOpL_0
 call error1
 add  sp, 2

;-548     if (OpSize == R1Type) return;

.checkOpL108:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL109
 jmp .retncheckOpL

;-549     if (Op == REG) if (R1Type==0) error1("no register defined");

.checkOpL109:
 mov al, [Op]
 cmp al, 2
 jne .checkOpL110
 mov al, [R1Type]
 cmp al, 0
 jne .checkOpL111
 push checkOpL_1
 call error1
 add  sp, 2

;-550 }

.checkOpL111:
.checkOpL110:

;-551 


;-552 int check2Ops() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

check2Ops: PROC

;-553     get2Ops();

 call get2Ops

;-554     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops112
 call addrerror

;-555     if (Op == ADR) invaloperror();

.check2Ops112:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops113
 call invaloperror

;-556     if (Op == IMM) immeerror();

.check2Ops113:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops114
 call immeerror

;-557     if (Op2==   0) addrerror();

.check2Ops114:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops115
 call addrerror

;-558     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov

.check2Ops115:
 mov al, [CodeType]
 cmp al, 5
 je  .check2Ops116
 mov al, [Op2]
 cmp al, 3
 jne .check2Ops117
 call invaloperror

;-559     setwflag();

.check2Ops117:
.check2Ops116:
 call setwflag

;-560 }


;-561 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-562     getOpL();

 call getOpL

;-563     need(',');

 push 44
 call need
 add  sp, 2

;-564     getOpR();

 call getOpR

;-565 }


;-566 


;-567 int getOpL() {

 ret
ENDP

getOpL: PROC

;-568 //set: op=0,IMM,REG,ADR,MEM


;-569     getOpR();

 call getOpR

;-570     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-571     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-572     R1Type=R2Type; R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-573 }


;-574 


;-575 int getOpR() {

 ret
ENDP

getOpR: PROC

;-576     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-577     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR118
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-578     if (Op2 == 0)     {invaloperror();         return;}

.getOpR118:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR119
 call invaloperror
 jmp .retngetOpR

;-579     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR119:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR120
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-580     if (Op2 == REG)                            return;

.getOpR120:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR121
 jmp .retngetOpR

;-581     if (Op2 == ADR)   {

.getOpR121:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR122

;-582         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR123
 mov ax, 0
 mov word [disp], ax

;-583         else disp=LabelAddr[LabelIx];

 jmp .getOpR124
.getOpR123:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-584         return;}

.getOpR124:
 jmp .retngetOpR

;-585     error1("Name of operand expected");

.getOpR122:
 push getOpR_0
 call error1
 add  sp, 2

;-586 }


;-587 


;-588 int getOp1() {//scan for a single operand

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOp1: PROC

;-589 //return:0, IMM, REG, ADR (not MEM)


;-590 //set   :R2Type, R2No by testReg


;-591 //set   :LabelIx by searchLabel


;-592     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1125
 mov ax, 0
 jmp .retngetOp1

;-593     if (TokeType == DIGIT)  return IMM;

.getOp1125:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1126
 mov ax, 1
 jmp .retngetOp1

;-594     if (TokeType == ALNUME) {

.getOp1126:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1127

;-595         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-596         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1128
 mov ax, 2
 jmp .retngetOp1

;-597         LabelIx=searchLabel();

.getOp1128:
 call searchLabel
 mov word [LabelIx], ax

;-598         return ADR;

 mov ax, 3
 jmp .retngetOp1

;-599 //        if (LabelIx)        return ADR;


;-600 //        else error1("variable not found");


;-601     }


;-602     return 0;

.getOp1127:
 mov ax, 0
 jmp .retngetOp1

;-603 }


;-604 


;-605 int getMEM() {// e.g. [array+bp+si-4]

 .retngetOp1:
 ret
ENDP

getMEM: PROC

;-606 //set: disp, rm, R2Type


;-607     char c;


;-608     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   607 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-609     do {

.getMEM129:

;-610         getTokeType();

 call getTokeType

;-611         c=getOp1();

 call getOp1
 mov [bp-2], al

;-612         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM130
 call syntaxerror

;-613         if (c == REG) {

.getMEM130:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM131

;-614             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-615             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM132
 call getIndReg2
 mov byte [rm], al

;-616             else getIndReg1();

 jmp .getMEM133
.getMEM132:
 call getIndReg1

;-617         }

.getMEM133:

;-618         if (c == ADR) {

.getMEM131:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM134

;-619             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM135
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-620             else notfounderror();

 jmp .getMEM136
.getMEM135:
 call notfounderror

;-621         }

.getMEM136:

;-622         if (c == IMM) disp=disp+SymbolInt;

.getMEM134:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM137
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-623         if (isToken('-')) {

.getMEM137:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM138

;-624             getTokeType();

 call getTokeType

;-625             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM139
 call numbererror

;-626             disp = disp - SymbolInt;

.getMEM139:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-627         }


;-628     } while (isToken('+'));

.getMEM138:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM140
 jmp .getMEM129
.getMEM140:

;-629     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM141
 push getMEM_0
 call errorexit
 add  sp, 2

;-630 }

.getMEM141:

;-631 int getIndReg1() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getIndReg1: PROC

;-632     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1142
 call indexerror

;-633     if (R2No==3) rm=7;//BX

.getIndReg1142:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1143
 mov ax, 7
 mov byte [rm], al

;-634     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1143:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1144
 mov ax, 6
 mov byte [rm], al

;-635     if (R2No==7) rm=5;//DI

.getIndReg1144:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1145
 mov ax, 5
 mov byte [rm], al

;-636     if (R2No==6) rm=4;//SI

.getIndReg1145:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1146
 mov ax, 4
 mov byte [rm], al

;-637     if (rm==0) indexerror();

.getIndReg1146:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1147
 call indexerror

;-638 }

.getIndReg1147:

;-639 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   639 NULL m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-640     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2148
 call indexerror

;-641     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2148:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2149
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2150
 mov ax, 3
 mov [bp-2], al

;-642              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2151
.getIndReg2150:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2152
 mov ax, 1
 mov [bp-2], al

;-643     if (R2No==6) if (rm==6) m=2;//BP+SI

.getIndReg2152:
.getIndReg2151:
.getIndReg2149:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg2153
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2154
 mov ax, 2
 mov [bp-2], al

;-644              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2155
.getIndReg2154:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2156
 mov ax, 0
 mov [bp-2], al

;-645     if (m > 3) indexerror();

.getIndReg2156:
.getIndReg2155:
.getIndReg2153:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2157
 call indexerror

;-646     return m;

.getIndReg2157:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-647 }


;-648 


;-649 int setwflag() {//word size, bit 0

 .retngetIndReg2: LEAVE
 ret
ENDP

setwflag: PROC

;-650     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-651     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag158

;-652         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag159
 mov al, [R1Type]
 mov byte [OpSize], al

;-653         if (Op2== REG) OpSize=R2Type;

.setwflag159:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag160
 mov al, [R2Type]
 mov byte [OpSize], al

;-654         if (R2Type== SEGREG) OpSize=WORD;

.setwflag160:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag161
 mov ax, 2
 mov byte [OpSize], al

;-655         if (R1Type == SEGREG) OpSize=WORD;

.setwflag161:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag162
 mov ax, 2
 mov byte [OpSize], al

;-656     }

.setwflag162:

;-657     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag158:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag163
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-658     if (OpSize  ==  WORD) wflag=1;

.setwflag163:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag164
 mov ax, 1
 mov byte [wflag], al

;-659 }

.setwflag164:

;-660 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-661     unsigned int ui;


;-662     sflag=2;

;Function : setsflag, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   661 NULL ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-663     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-664     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag165
 mov ax, 0
 mov byte [sflag], al

;-665     if (OpSize == BYTE) {

.setsflag165:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag166

;-666         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag167
 push setsflag_0
 call error1
 add  sp, 2

;-667         sflag=0;//byte reg does not need sign extended

.setsflag167:
 mov ax, 0
 mov byte [sflag], al

;-668     }


;-669 }

.setsflag166:

;-670 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-671     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   670 NULL ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize168
 mov ax, 0
 jmp .retncheckConstSize

;-672     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize168:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize169
 mov ax, 0
 jmp .retncheckConstSize

;-673     return 2;// is short

.checkConstSize169:
 mov ax, 2
 jmp .retncheckConstSize

;-674 }


;-675 


;-676 


;-677 //#include "PARSE.C"


;-678 int parse() {

 .retncheckConstSize: LEAVE
 ret
ENDP

parse: PROC

;-679     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-680     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax

;-681     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-682     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax

;-683     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-684     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-685 


;-686     do {//process a new line

.parse170:

;-687         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-688         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-689         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-690         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-691         getLine();

 call getLine

;-692         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-693         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-694         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse171

;-695             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse172

;-696               if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse173
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-697                 storeLabel();

.parse173:
 call storeLabel

;-698                 InputPtr++;//remove :

 inc  word[InputPtr]

;-699                 getTokeType();

 call getTokeType

;-700             }


;-701         }

.parse172:

;-702         if (TokeType == ALNUME) {

.parse171:
 mov al, [TokeType]
 cmp al, 3
 jne .parse174

;-703             lookCode();// and OpCodePtr

 call lookCode

;-704             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse175
 call process

;-705             else getVariable();

 jmp .parse176
.parse175:
 call getVariable

;-706             skipRest();

.parse176:
 call skipRest

;-707         }


;-708         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp .parse177
.parse174:
 mov al, [TokeType]
 cmp al, 3
 jle .parse178
 push parse_0
 call error1
 add  sp, 2

;-709         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp .parse179
.parse178:
 mov al, [TokeType]
 cmp al, 1
 jne .parse180
 push parse_1
 call error1
 add  sp, 2

;-710         printLine();

.parse180:
.parse179:
.parse177:
 call printLine

;-711     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse181
 jmp .parse170
.parse181:

;-712 }


;-713 


;-714 int getTokeType() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0
ENDP

getTokeType: PROC

;-715     char c;


;-716     skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   715 NULL c = bp-2;
 ENTER  2,0
 call skipBlank

;-717     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-718     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType182
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-719     if (c == ';') {TokeType=0; return; }//comment

.getTokeType182:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType183
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-720     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

.getTokeType183:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getTokeType184
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov ax, 1
 mov byte [TokeType], al
 jmp .retngetTokeType

;-721     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

.getTokeType184:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .getTokeType185
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov ax, 3
 mov byte [TokeType], al
 jmp .retngetTokeType

;-722     TokeType=NOALNUME;

.getTokeType185:
 mov ax, 4
 mov byte [TokeType], al

;-723 }


;-724 


;-725 int storeJmp() {

 .retngetTokeType: LEAVE
 ret
ENDP

storeJmp: PROC

;-726     unsigned int i;


;-727     JmpMaxIx++;

;Function : storeJmp, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   726 NULL i = bp-2;
 ENTER  2,0
 inc  word[JmpMaxIx]

;-728     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp186
 push storeJmp_0
 call errorexit
 add  sp, 2

;-729     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp186:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax

;-730     JmpNamePtr++;

 inc  word[JmpNamePtr]

;-731     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax

;-732     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp187
 push storeJmp_1
 call errorexit
 add  sp, 2

;-733     JmpAddr[JmpMaxIx] = PC;

.storeJmp187:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax

;-734 }


;-735 


;-736 int storeLabel() {
 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC

;-737     unsigned int i;


;-738     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   737 NULL i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel188
 push storeLabel_0
 call error1
 add  sp, 2

;-739     LabelMaxIx++;

.storeLabel188:
 inc  word[LabelMaxIx]

;-740     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel189
 push storeLabel_1
 call errorexit
 add  sp, 2

;-741     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel189:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-742     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-743     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-744     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel190
 push storeLabel_2
 call errorexit
 add  sp, 2

;-745     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel190:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-746 }


;-747 


;-748 int searchLabel() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

searchLabel: PROC

;-749     int LIx; char *p;


;-750     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   749 NULL LIx = bp-2
;  201 ptr sign byte   749 NULL p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-751     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-752     while (LIx <= LabelMaxIx) {

.searchLabel191:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel192

;-753         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel193
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-754         p=strlen(p) + p;

.searchLabel193:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-755         p++;

 inc  word[bp-4]

;-756         LIx++;

 inc  word[bp-2]

;-757     }


;-758     return 0;

 jmp .searchLabel191
.searchLabel192:
 mov ax, 0
 jmp .retnsearchLabel

;-759 }


;-760 


;-761 int getVariable() {

 .retnsearchLabel: LEAVE
 ret
ENDP

getVariable: PROC

;-762     char c;


;-763     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   762 NULL c = bp-2;
 ENTER  2,0
 call storeLabel

;-764     getTokeType();

 call getTokeType

;-765     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable194

;-766         lookCode();

 call lookCode

;-767         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable195
 call dataexit

;-768         if (CodeType > 205) dataexit();

.getVariable195:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable196
 call dataexit

;-769         if (CodeType== 200) {//DB

.getVariable196:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable197

;-770             do {

.getVariable198:

;-771                 getTokeType();

 call getTokeType

;-772                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable199
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-773                 else {

 jmp .getVariable200
.getVariable199:

;-774                     skipBlank();

 call skipBlank

;-775                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable201

;-776                         do {

.getVariable202:

;-777                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-778                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-779                             InputPtr++;

 inc  word[InputPtr]

;-780                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable203
 jmp .getVariable202
.getVariable203:

;-781                         InputPtr++;

 inc  word[InputPtr]

;-782                     }


;-783                 }

.getVariable201:

;-784             } while (isToken(','));

.getVariable200:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable204
 jmp .getVariable198
.getVariable204:

;-785         }


;-786         if (CodeType == 201) {//DW

.getVariable197:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable205

;-787             do {

.getVariable206:

;-788                 getTokeType();

 call getTokeType

;-789                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable207
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-790             } while (isToken(','));

.getVariable207:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable208
 jmp .getVariable206
.getVariable208:

;-791         }


;-792         if (CodeType == 202) {//DD

.getVariable205:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable209

;-793             do {

.getVariable210:

;-794                 getTokeType();

 call getTokeType

;-795                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable211
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-796                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-797             } while (isToken(','));

.getVariable211:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable212
 jmp .getVariable210
.getVariable212:

;-798         }


;-799         if (CodeType >= 203) {//resb, resw, resd

.getVariable209:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable213

;-800             getTokeType();

 call getTokeType

;-801             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable214

;-802                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable215
 call syntaxerror

;-803                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable215:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable216
 push getVariable_0
 call error1
 add  sp, 2

;-804                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable216:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-805                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable217
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-806                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable217:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable218
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-807                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable218:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-808             } else numbererror();

 jmp .getVariable219
.getVariable214:
 call numbererror

;-809         }

.getVariable219:

;-810     }

.getVariable213:

;-811     else dataexit();

 jmp .getVariable220
.getVariable194:
 call dataexit

;-812 }

.getVariable220:

;-813 


;-814 int getCodeSize() {
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC

;-815     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize221

;-816         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize222
 call getTokeType
 mov ax, 1
 jmp .retngetCodeSize

;-817         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

.getCodeSize222:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize223
 call getTokeType
 mov ax, 2
 jmp .retngetCodeSize

;-818         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

.getCodeSize223:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize224
 call getTokeType
 mov ax, 3
 jmp .retngetCodeSize

;-819     }

.getCodeSize224:

;-820     return 0;

.getCodeSize221:
 mov ax, 0
 jmp .retngetCodeSize

;-821 }


;-822 int isToken(char c) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

isToken: PROC

;-823     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   822 NULL c = bp+4;
 ENTER  0,0
 call skipBlank

;-824     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken225

;-825         InputPtr++;

 inc  word[InputPtr]

;-826         return 1;

 mov ax, 1
 jmp .retnisToken

;-827         }


;-828     return 0;

.isToken225:
 mov ax, 0
 jmp .retnisToken

;-829 }


;-830 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-831     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   830 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need226

;-832         getTokeType();

 call getTokeType

;-833         return;

 jmp .retnneed

;-834         }


;-835     error1();

.need226:
 call error1

;-836     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-837     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-838 }


;-839 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-840     getTokeType();

 call getTokeType

;-841     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest227
 push skipRest_0
 call error1
 add  sp, 2

;-842 }

.skipRest227:

;-843 


;-844 


;-845 


;-846 int getarg() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

getarg: PROC

;-847     int arglen1; int i; char *c;


;-848     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var sign word   847 NULL arglen1 = bp-2
;  201 var sign word   847 NULL i = bp-4
;  202 ptr sign byte   847 NULL c = bp-6;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-849     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg228

;-850         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-851         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-852         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-853     }


;-854     i=arglen1+129;

.getarg228:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-855     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-856     arglen1--;

 dec  word[bp-2]

;-857     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-858 


;-859     strcpy(namein, argv); strcat1(namein, ".S");

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

;-860     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-861     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-862 


;-863   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-864 


;-865     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-866     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg229
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

;-867     lst_fd=creatR(namelst);

.getarg229:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-868     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg230
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

;-869     bin_fd=creatR(namebin);

.getarg230:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-870     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg231
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

;-871 


;-872     prs(";");

.getarg231:
 push getarg_7
 call prs
 add  sp, 2

;-873     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-874     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-875     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-876     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-877     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-878 }


;-879 


;-880 int fixJmp() {   
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

fixJmp: PROC

;-881     unsigned int hex; int i;


;-882     char *p; int Ix; char c;


;-883     prs("\n;jmp to fix:");

;Function : fixJmp, Number of local variables: 5
;   # type sign width addr used name   list of local variables
;  200 var unsg word   881 NULL hex = bp-2
;  201 var sign word   881 NULL i = bp-4
;  202 ptr sign byte   882 NULL p = bp-6
;  203 var sign word   882 NULL Ix = bp-8
;  204 var sign byte   882 NULL c = bp-10;
 ENTER  10,0
 push fixJmp_0
 call prs
 add  sp, 2

;-884     printIntU(JmpMaxIx);

 push word [JmpMaxIx]
 call printIntU
 add  sp, 2

;-885     p = &JmpNames;

 mov ax, JmpNames
 mov [bp-6], ax

;-886     i = 1;

 mov ax, 1
 mov [bp-4], ax

;-887     while (i <= JmpMaxIx) {

.fixJmp232:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp233

;-888         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-889         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-890         p++;

 inc  word[bp-6]

;-891         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax

;-892         prs("\n"); printIntU(i);

 push fixJmp_1
 call prs
 add  sp, 2
 push word [bp-4]
 call printIntU
 add  sp, 2

;-893         prs(". "); prs(Symbol); prs(",from:");

 push fixJmp_2
 call prs
 add  sp, 2
 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2
 push fixJmp_3
 call prs
 add  sp, 2

;-894         printhex16(hex);

 push word [bp-2]
 call printhex16
 add  sp, 2

;-895         


;-896         Ix=searchLabel();

 call searchLabel
 mov [bp-8], ax

;-897         if (Ix == 0) notfounderror();

 mov ax, [bp-8]
 cmp ax, 0
 jne .fixJmp234
 call notfounderror

;-898         disp = LabelAddr[Ix];   

.fixJmp234:
 mov bx, [bp-8]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-899         c = FileBin[hex];//look for 'A' push Absolute 

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-10], al

;-900         prs(",Label+ORG:"); printhex16(disp);

 push fixJmp_4
 call prs
 add  sp, 2
 push word [disp]
 call printhex16
 add  sp, 2

;-901         if (c != 0xAA) {

 mov al, [bp-10]
 cmp al, 170
 je  .fixJmp235

;-902             disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp-2]
 mov word [disp], ax

;-903             disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax

;-904             disp = disp - Origin; 

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-905             prs(",rel:"); printhex16(disp);

 push fixJmp_5
 call prs
 add  sp, 2
 push word [disp]
 call printhex16
 add  sp, 2

;-906         }


;-907             FileBin[hex] = disp;//fix low byte

.fixJmp235:
 mov ax, [disp]
 mov bx, [bp-2]
 mov [FileBin+bx], al

;-908             hex++;

 inc  word[bp-2]

;-909             disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-910             FileBin[hex] = disp; 

 mov ax, [disp]
 mov bx, [bp-2]
 mov [FileBin+bx], al

;-911         i++;  

 inc  word[bp-4]

;-912     }


;-913 }

 jmp .fixJmp232
.fixJmp233:

;-914 int fixJmpMain() {   
 LEAVE
 ret
fixJmp_0 db "\n;jmp to fix:",0
fixJmp_1 db "\n",0
fixJmp_2 db ". ",0
fixJmp_3 db ",from:",0
fixJmp_4 db ",Label+ORG:",0
fixJmp_5 db ",rel:",0
ENDP

fixJmpMain: PROC

;-915     unsigned int hex; 


;-916     int Ix; char c;


;-917     prs("\n;fix jmp to main. resting global jmp:");

;Function : fixJmpMain, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word   915 NULL hex = bp-2
;  201 var sign word   916 NULL Ix = bp-4
;  202 var sign byte   916 NULL c = bp-6;
 ENTER  6,0
 push fixJmpMain_0
 call prs
 add  sp, 2

;-918     printIntU(JmpMaxIx);  

 push word [JmpMaxIx]
 call printIntU
 add  sp, 2

;-919     if (JmpMaxIx != 1) error1(" too many resting global jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 1
 je  .fixJmpMain236
 push fixJmpMain_1
 call error1
 add  sp, 2

;-920         strcpy(Symbol, "main");

.fixJmpMain236:
 push fixJmpMain_2
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-921         hex = 1;//first instruction, PC=1

 mov ax, 1
 mov [bp-2], ax

;-922         prs("\nonly one global variable: "); 

 push fixJmpMain_3
 call prs
 add  sp, 2

;-923         prs(Symbol); prs(",from:");

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2
 push fixJmpMain_4
 call prs
 add  sp, 2

;-924         printhex16(hex);

 push word [bp-2]
 call printhex16
 add  sp, 2

;-925         


;-926         Ix=searchLabel();

 call searchLabel
 mov [bp-4], ax

;-927         if (Ix == 0) notfounderror();

 mov ax, [bp-4]
 cmp ax, 0
 jne .fixJmpMain237
 call notfounderror

;-928         disp = LabelAddr[Ix];   

.fixJmpMain237:
 mov bx, [bp-4]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-929         c = FileBin[hex];//look for 'A' push Absolute 

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-6], al

;-930         prs(",Label+ORG:"); printhex16(disp);

 push fixJmpMain_5
 call prs
 add  sp, 2
 push word [disp]
 call printhex16
 add  sp, 2

;-931         if (c != 0xAA) {

 mov al, [bp-6]
 cmp al, 170
 je  .fixJmpMain238

;-932             disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp-2]
 mov word [disp], ax

;-933             disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax

;-934             disp = disp - Origin; 

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-935             prs(",rel:"); printhex16(disp);

 push fixJmpMain_6
 call prs
 add  sp, 2
 push word [disp]
 call printhex16
 add  sp, 2

;-936         }


;-937             FileBin[hex] = disp;//fix low byte

.fixJmpMain238:
 mov ax, [disp]
 mov bx, [bp-2]
 mov [FileBin+bx], al

;-938             hex++;

 inc  word[bp-2]

;-939             disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-940             FileBin[hex] = disp; 

 mov ax, [disp]
 mov bx, [bp-2]
 mov [FileBin+bx], al

;-941 }


;-942 


;-943 int epilog() {
 LEAVE
 ret
fixJmpMain_0 db "\n;fix jmp to main. resting global jmp:",0
fixJmpMain_1 db " too many resting global jmp",0
fixJmpMain_2 db "main",0
fixJmpMain_3 db "\nonly one global variable: ",0
fixJmpMain_4 db ",from:",0
fixJmpMain_5 db ",Label+ORG:",0
fixJmpMain_6 db ",rel:",0
ENDP

epilog: PROC

;-944     unsigned int i; char c;     int j;


;-945     prs("\n Errors: ");

;Function : epilog, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word   944 NULL i = bp-2
;  201 var sign byte   944 NULL c = bp-4
;  202 var sign word   944 NULL j = bp-6;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-946     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-947     if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog239
 push epilog_1
 call prs
 add  sp, 2

;-948     prs(", Out: ");

.epilog239:
 push epilog_2
 call prs
 add  sp, 2

;-949     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-950     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-951     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-952     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-953     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-954     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-955     prs(" Labels: ");

 push epilog_6
 call prs
 add  sp, 2

;-956     printIntU(LabelMaxIx);

 push word [LabelMaxIx]
 call printIntU
 add  sp, 2

;-957 // prs(", code:\n ");//debug


;-958 


;-959     i=0;

 mov ax, 0
 mov [bp-2], ax

;-960     do {

.epilog240:

;-961         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-962         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-963 // printhex8a(c); prc(' ');//debug


;-964         i++;

 inc  word[bp-2]

;-965     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog241
 jmp .epilog240
.epilog241:

;-966 


;-967 /* 


;-968   prs("\n\n LabelNamePtr:"); printIntU(LabelNamePtr);


;-969   i= &LabelNames;


;-970   prs(" &LabelNames:"); printIntU(i);


;-971   i=LabelNamePtr-i;


;-972   prs(", size: ");


;-973   printIntU(i);


;-974   prs(".\n >>");


;-975   i= &LabelNames;


;-976   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-977   } while (i < LabelNamePtr); prs("<< \n");


;-978    i = 1;


;-979     LabelNamePtr= &LabelNames;


;-980     do {


;-981       prs(LabelNamePtr); prc(' ');


;-982       j=LabelAddr[i]; printhex16(j); prs(", ");


;-983       j=strlen(LabelNamePtr);//get end of actual name


;-984       LabelNamePtr=LabelNamePtr+j;


;-985       LabelNamePtr++;


;-986       i++;


;-987     } while (i <= LabelMaxIx);


;-988 */


;-989 }


;-990 


;-991 int end1(int n) {
 LEAVE
 ret
epilog_0 db "\n Errors: ",0
epilog_1 db " ***ERROR*** ",0
epilog_2 db ", Out: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
epilog_6 db " Labels: ",0
ENDP

end1: PROC

;-992     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   991 NULL n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-993     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-994     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-995     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-996 }


;-997 


;-998 


;-999 //#include "GENCODE.C"


;-1000 // generate code


;-1001 int getCodes() {
 LEAVE
 ret
ENDP

getCodes: PROC

;-1002     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-1003     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-1004     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-1005 }


;-1006 int genCode8(char c) {

 ret
ENDP

genCode8: PROC

;-1007 //set: BinLen++, OpPrintIndex++


;-1008     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1006 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-1009     BinLen++;

 inc  word[BinLen]

;-1010     PC++;

 inc  word[PC]

;-1011     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 17000 ;unsigned : 0
 jb  .genCode8242
 push genCode8_0
 call errorexit
 add  sp, 2

;-1012     if (OpPrintIndex < OPMAXLEN) {

.genCode8242:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8243

;-1013         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-1014         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-1015     }


;-1016 }

.genCode8243:

;-1017 int gen66h() {genCode8(0x66);
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-1018 }


;-1019 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-1020     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1019 NULL c = bp+4
;  201 var sign byte  1019 NULL d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-1021     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1022 }


;-1023 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-1024     c = c + wflag;

;Function : genCodeW, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1023 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-1025     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1026 }


;-1027 int genCode16(unsigned int i) {
 LEAVE
 ret
ENDP

genCode16: PROC

;-1028     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word  1027 NULL i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-1029     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-1030 }


;-1031 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-1032     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg dwrd  1031 NULL L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-1033     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-1034 }


;-1035 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-1036 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-1037 //mod-bits: mode76, reg/opcode543, r/m210


;-1038 //Op: 0, IMM, REG, ADR, MEM


;-1039     char len;


;-1040     len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1035 NULL xxx = bp+4
;  201 var sign byte  1039 NULL len = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-1041     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-1042     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA244

;-1043         xxx |= 0xC0;

 or  byte[bp+4], 192

;-1044         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA245
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1045             else {

 jmp .writeEA246
.writeEA245:

;-1046                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA247
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1047                 else            xxx = xxx + R2No;

 jmp .writeEA248
.writeEA247:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-1048             }

.writeEA248:

;-1049         }

.writeEA246:

;-1050     if (Op == MEM) {

.writeEA244:
 mov al, [Op]
 cmp al, 4
 jne .writeEA249

;-1051         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA250

;-1052             xxx |= 6;

 or  byte[bp+4], 6

;-1053             len = 2;

 mov ax, 2
 mov [bp-2], al

;-1054         }


;-1055         else {

 jmp .writeEA251
.writeEA250:

;-1056             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-1057             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA252

;-1058                 len=1;

 mov ax, 1
 mov [bp-2], al

;-1059                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA253
 or  byte[bp+4], 64

;-1060             }

.writeEA253:

;-1061 


;-1062             if (disp) {

.writeEA252:
 mov ax, [disp]
 or  al, al
 je .writeEA254

;-1063                 ax = disp;

 mov  ax, [disp]

;-1064                 if(ax > 127) len=2;

 cmp  ax, 127
 jle .writeEA255
 mov ax, 2
 mov [bp-2], al

;-1065                 else len=1;

 jmp .writeEA256
.writeEA255:
 mov ax, 1
 mov [bp-2], al

;-1066                 if (len == 1) xxx |= 0x40;

.writeEA256:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA257
 or  byte[bp+4], 64

;-1067                 else xxx |= 0x80;

 jmp .writeEA258
.writeEA257:
 or  byte[bp+4], 128

;-1068             }

.writeEA258:

;-1069         }

.writeEA254:

;-1070     }

.writeEA251:

;-1071 


;-1072     genCode8(xxx);// gen second byte

.writeEA249:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1073     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA259
 push word [disp]
 call genCode8
 add  sp, 2

;-1074     if (len == 2) genCode16(disp);

.writeEA259:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA260
 push word [disp]
 call genCode16
 add  sp, 2

;-1075 }

.writeEA260:

;-1076 


;-1077 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-1078     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long

 mov al, [wflag]
 or  al, al
 je .genImmediate261
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate262
 push word [imme]
 call genCode32
 add  sp, 2

;-1079         else genCode16(imme);

 jmp .genImmediate263
.genImmediate262:
 push word [imme]
 call genCode16
 add  sp, 2

;-1080     else       genCode8 (imme);

.genImmediate263:
 jmp .genImmediate264
.genImmediate261:
 push word [imme]
 call genCode8
 add  sp, 2

;-1081 }

.genImmediate264:

;-1082 


;-1083 //AS.C


;-1084 int process() {

 ret
ENDP

process: PROC

;-1085     char c;


;-1086     int i;


;-1087     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1085 NULL c = bp-2
;  201 var sign word  1086 NULL i = bp-4;
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

;-1088     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-1089     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-1090     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-1091     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-1092     getCodes();//set: Code1, Code2, Code3

 call getCodes

;-1093 


;-1094     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process265

;-1095         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1096         return;

 jmp .retnprocess

;-1097     }


;-1098 


;-1099     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process265:
 mov al, [CodeType]
 cmp al, 2
 jne .process266

;-1100         getOpL();

 call getOpL

;-1101         checkOpL();

 call checkOpL

;-1102         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  .process267

;-1103   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process268

;-1104                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je .process269
 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
 jmp .retnprocess

;-1105             }

.process269:

;-1106         }

.process268:

;-1107         if (Code2 == 5) {//imul extension?

.process267:
 mov al, [Code2]
 cmp al, 5
 jne .process270

;-1108             getTokeType();

 call getTokeType

;-1109             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process271
 call implerror

;-1110         }

.process271:

;-1111         genCodeW(Code1);

.process270:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1112         writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1113         return;

 jmp .retnprocess

;-1114     }


;-1115 


;-1116     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process266:
 mov al, [CodeType]
 cmp al, 3
 jne .process272

;-1117         check2Ops();    //setwflag not applicable

 call check2Ops

;-1118         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process273
 call reg16error

;-1119         if (Op2 != MEM) addrerror();//only m16

.process273:
 mov al, [Op2]
 cmp al, 4
 je  .process274
 call addrerror

;-1120 


;-1121         genCode8(Code1);//les,lds,lea

.process274:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1122         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 15
 jne .process275
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1123         Op=Op2;//set MEM for writeEA

.process275:
 mov al, [Op2]
 mov byte [Op], al

;-1124         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1125         return;

 jmp .retnprocess

;-1126     }


;-1127 


;-1128     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process272:
 mov al, [CodeType]
 cmp al, 4
 jne .process276

;-1129         check2Ops();

 call check2Ops

;-1130         if (Op2 == IMM) {//second operand is imm

 mov al, [Op2]
 cmp al, 1
 jne .process277

;-1131             setsflag();

 call setsflag

;-1132             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process278

;-1133                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process279

;-1134                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process280

;-1135                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1136                         c += 4;

 add  byte[bp-2], 4

;-1137                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1138                         genImmediate();

 call genImmediate

;-1139                         return;

 jmp .retnprocess

;-1140                     }


;-1141                 }

.process280:

;-1142             }

.process279:

;-1143             //r/m, imm: 80 sign-extended,TTT,imm


;-1144             c = sflag + 0x80;

.process278:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1145             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1146             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1147             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process281
 push word [imme]
 call genCode8
 add  sp, 2

;-1148             else genImmediate();

 jmp .process282
.process281:
 call genImmediate

;-1149             return;

.process282:
 jmp .retnprocess

;-1150         }


;-1151         c = Code1 << 3;//r/m, r/r

.process277:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1152         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process283

;-1153             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process284

;-1154                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1155                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1156                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1157                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1158                 return;

 jmp .retnprocess

;-1159             }


;-1160         }

.process284:

;-1161         if (Op2 == REG) {//mem,reg    reg,reg

.process283:
 mov al, [Op2]
 cmp al, 2
 jne .process285

;-1162             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1163             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1164             return;

 jmp .retnprocess

;-1165         }


;-1166         syntaxerror();

.process285:
 call syntaxerror

;-1167         return;

 jmp .retnprocess

;-1168     }


;-1169 


;-1170     if (CodeType == 5) {//mov (movsx, movzx=51)

.process276:
 mov al, [CodeType]
 cmp al, 5
 jne .process286

;-1171         check2Ops();

 call check2Ops

;-1172 /*    prs("\n Op:"); printhex8a(Op);


;-1173     prs(", Op2:"); printhex8a(Op2);


;-1174     prs(", R1No:"); printhex8a(R1No);


;-1175     prs(", R2No:"); printhex8a(R2No);   */


;-1176         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process287

;-1177             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process288
 mov ax, [disp]
 mov word [imme], ax

;-1178             else notfounderror();

 jmp .process289
.process288:
 call notfounderror

;-1179             Op2=IMM;//continue with IMM

.process289:
 mov ax, 1
 mov byte [Op2], al

;-1180         }


;-1181         if (Op2 == IMM) {// r,i

.process287:
 mov al, [Op2]
 cmp al, 1
 jne .process290

;-1182             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process291

;-1183                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1184                 c += 0xB0;

 add  byte[bp-2], 176

;-1185                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1186                 genImmediate();

 call genImmediate

;-1187                 return;

 jmp .retnprocess

;-1188             }


;-1189             if (Op == MEM) {// m,i

.process291:
 mov al, [Op]
 cmp al, 4
 jne .process292

;-1190                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1191                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1192                 genImmediate();

 call genImmediate

;-1193                 return;

 jmp .retnprocess

;-1194             }


;-1195             regmemerror();

.process292:
 call regmemerror

;-1196             return;

 jmp .retnprocess

;-1197         }


;-1198         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process290:
 mov al, [R1Type]
 cmp al, 4
 jne .process293
 call ChangeDirection

;-1199         if (R2Type == SEGREG) {//rm,sreg

.process293:
 mov al, [R2Type]
 cmp al, 4
 jne .process294

;-1200             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process295
 call reg16error

;-1201                 genCode2(0x8C, dflag);

.process295:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1202                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1203                 return;

 jmp .retnprocess

;-1204         }


;-1205         if (Op2 == MEM) {//acc, moffs16

.process294:
 mov al, [Op2]
 cmp al, 4
 jne .process296

;-1206             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process297

;-1207                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process298

;-1208                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process299

;-1209                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1210                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1211                         return;

 jmp .retnprocess

;-1212                     }


;-1213                 }

.process299:

;-1214             }

.process298:

;-1215         }

.process297:

;-1216         if (Op == MEM) {//moffs16, acc

.process296:
 mov al, [Op]
 cmp al, 4
 jne .process300

;-1217             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process301

;-1218                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process302

;-1219                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process303

;-1220                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1221                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1222                         return;

 jmp .retnprocess

;-1223                     }


;-1224                 }

.process303:

;-1225             }

.process302:

;-1226 


;-1227         }

.process301:

;-1228         if (Op2 == REG) {//rm, r

.process300:
 mov al, [Op2]
 cmp al, 2
 jne .process304

;-1229             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1230             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1231             return;

 jmp .retnprocess

;-1232         }


;-1233         if (Op2 == MEM) {//r, m

.process304:
 mov al, [Op2]
 cmp al, 4
 jne .process305

;-1234             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process306

;-1235                 ChangeDirection();

 call ChangeDirection

;-1236                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1237                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1238                 return;

 jmp .retnprocess

;-1239             }


;-1240         }

.process306:

;-1241         syntaxerror();

.process305:
 call syntaxerror

;-1242         return;

 jmp .retnprocess

;-1243     }


;-1244 


;-1245     if (CodeType == 6) {//Jcc

.process286:
 mov al, [CodeType]
 cmp al, 6
 jne .process307

;-1246         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process308

;-1247             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1248             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process309

;-1249                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1250                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1251                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1252                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process310

;-1253                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1254                     disp -= 2;

 sub  word[disp], 2

;-1255                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1256                 } else {

 jmp .process311
.process310:

;-1257                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1258                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1259                     disp -= 4;

 sub  word[disp], 4

;-1260                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1261                 }


;-1262             }

.process311:

;-1263             else {//jump forward, near only

 jmp .process312
.process309:

;-1264                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1265                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1266                 storeJmp();

 call storeJmp

;-1267                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1268                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1269             }


;-1270         return;

.process312:
 jmp .retnprocess

;-1271         }


;-1272     }

.process308:

;-1273 


;-1274     if (CodeType == 7) {//jmp, call

.process307:
 mov al, [CodeType]
 cmp al, 7
 jne .process313

;-1275         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process314

;-1276             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1277             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process315

;-1278                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1279                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1280                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1281                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process316

;-1282                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process317

;-1283                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1284                         disp -= 2;

 sub  word[disp], 2

;-1285                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1286                     }


;-1287                     else {

 jmp .process318
.process317:

;-1288                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1289                         disp -= 3;

 sub  word[disp], 3

;-1290                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1291                     }


;-1292                 }

.process318:

;-1293                 else {

 jmp .process319
.process316:

;-1294                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1295                     disp -= 3;

 sub  word[disp], 3

;-1296                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1297                 }


;-1298             }

.process319:

;-1299             else {//jump forward, near only

 jmp .process320
.process315:

;-1300                 genCode8(Code1);  

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1301                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process321
 call storeJmp

;-1302                 genCode16(0);

.process321:
 push 0
 call genCode16
 add  sp, 2

;-1303                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1304             }


;-1305         return;

.process320:
 jmp .retnprocess

;-1306         }


;-1307     }

.process314:

;-1308 


;-1309     if (CodeType ==  8) {//ret,retf

.process313:
 mov al, [CodeType]
 cmp al, 8
 jne .process322

;-1310         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process323

;-1311             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1312             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1313             return;

 jmp .retnprocess

;-1314         }


;-1315         genCode8(Code1);

.process323:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1316         return;

 jmp .retnprocess

;-1317     }


;-1318 


;-1319     if (CodeType == 9) {//push, pop

.process322:
 mov al, [CodeType]
 cmp al, 9
 jne .process324

;-1320         getOpL();

 call getOpL

;-1321         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process325

;-1322             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process326

;-1323                 setsflag();

 call setsflag

;-1324                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1325                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process327
 push word [imme]
 call genCode8
 add  sp, 2

;-1326                 else       genCode16(imme);

 jmp .process328
.process327:
 push word [imme]
 call genCode16
 add  sp, 2

;-1327                 return;

.process328:
 jmp .retnprocess

;-1328             }


;-1329             if (Op == ADR) {//push string ABSOLUTE i16 

.process326:
 mov al, [Op]
 cmp al, 3
 jne .process329

;-1330 //prscomment("\n push disp: "); printhex16 (disp);


;-1331                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process330

;-1332                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1333                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1334                     return;

 jmp .retnprocess

;-1335                 }


;-1336                 else {

 jmp .process331
.process330:

;-1337                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1338                     storeJmp();

 call storeJmp

;-1339                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2

;-1340                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al

;-1341                     return;

 jmp .retnprocess

;-1342                 }


;-1343             }

.process331:

;-1344         }

.process329:

;-1345         if (R1Type == SEGREG) {

.process325:
 mov al, [R1Type]
 cmp al, 4
 jne .process332

;-1346             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process333

;-1347                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process334
 push process_0
 call error1
 add  sp, 2

;-1348             }

.process334:

;-1349             c = R1No <<3;

.process333:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1350             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process335

;-1351                 c += 122;

 add  byte[bp-2], 122

;-1352                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1353             }


;-1354             OpCodePtr++;

.process335:
 inc  word[OpCodePtr]

;-1355             c = c + *OpCodePtr;////////////////is Code4

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov [bp-2], al

;-1356             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1357             return;

 jmp .retnprocess

;-1358         }


;-1359         checkOpL();//no ADR, SEGREG

.process332:
 call checkOpL

;-1360         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne .process336
 call reg16error

;-1361         if (R1Type == WORD) {

.process336:
 mov al, [R1Type]
 cmp al, 2
 jne .process337

;-1362             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1363             return;

 jmp .retnprocess

;-1364         }


;-1365         if (Op == MEM) {

.process337:
 mov al, [Op]
 cmp al, 4
 jne .process338

;-1366             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1367             writeEA(Code3);//////////////////Code3

 mov al, byte [Code3]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1368             return;

 jmp .retnprocess

;-1369         }


;-1370         syntaxerror();

.process338:
 call syntaxerror

;-1371         return;

 jmp .retnprocess

;-1372     }


;-1373 


;-1374     if (CodeType == 11) {//shift, rotate

.process324:
 mov al, [CodeType]
 cmp al, 11
 jne .process339

;-1375         check2Ops();

 call check2Ops

;-1376         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process340

;-1377             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process341

;-1378                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1379                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1380                 return;

 jmp .retnprocess

;-1381             }


;-1382             genCodeW(0xC0);//80186

.process341:
 push 192
 call genCodeW
 add  sp, 2

;-1383             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1384             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1385             return;

 jmp .retnprocess

;-1386         }


;-1387         if (Op2 == REG) {

.process340:
 mov al, [Op2]
 cmp al, 2
 jne .process342

;-1388             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process343

;-1389                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process344

;-1390                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process345
 mov ax, 1
 mov byte [wflag], al

;-1391                     genCodeW(0xD2);

.process345:
 push 210
 call genCodeW
 add  sp, 2

;-1392                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1393                     return;

 jmp .retnprocess

;-1394                 }


;-1395             }

.process344:

;-1396         }

.process343:

;-1397     }

.process342:

;-1398 


;-1399     if (CodeType == 12) {//int

.process339:
 mov al, [CodeType]
 cmp al, 12
 jne .process346

;-1400         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process347

;-1401             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1402             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1403             return;

 jmp .retnprocess

;-1404         }


;-1405     }

.process347:

;-1406 


;-1407     if (CodeType == 30) {//enter i18,i8

.process346:
 mov al, [CodeType]
 cmp al, 30
 jne .process348

;-1408         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1409         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1410         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process349
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1411         else numbererror();

 jmp .process350
.process349:
 call numbererror

;-1412         need(',');

.process350:
 push 44
 call need
 add  sp, 2

;-1413         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1414         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process351
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1415         else numbererror();

 jmp .process352
.process351:
 call numbererror

;-1416         return;

.process352:
 jmp .retnprocess

;-1417     }


;-1418 


;-1419     if (CodeType==101) {//ORG nn

.process348:
 mov al, [CodeType]
 cmp al, 101
 jne .process353

;-1420         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process354
 call numbererror

;-1421         Origin=SymbolInt;

.process354:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1422         return;

 jmp .retnprocess

;-1423     }


;-1424 


;-1425     if (CodeType == 102) {//section, segment

.process353:
 mov al, [CodeType]
 cmp al, 102
 jne .process355

;-1426         //getTokeType();//ignore .bss .text .data


;-1427         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1428         return;

 jmp .retnprocess

;-1429     }


;-1430 


;-1431     if (CodeType == 110) {//absolute

.process355:
 mov al, [CodeType]
 cmp al, 110
 jne .process356

;-1432         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process357
 call numbererror

;-1433         AbsoluteLab=SymbolInt;

.process357:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1434         return;

 jmp .retnprocess

;-1435     }


;-1436     if (CodeType == 111) {//name: PROC

.process356:
 mov al, [CodeType]
 cmp al, 111
 jne .process358

;-1437         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process359

;-1438             prs("\n;entering: ");

 push process_1
 call prs
 add  sp, 2

;-1439             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1440             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1441             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax

;-1442             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax

;-1443             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax

;-1444             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax

;-1445         } else error1("already in PROC");

 jmp .process360
.process359:
 push process_2
 call error1
 add  sp, 2

;-1446         return;

.process360:
 jmp .retnprocess

;-1447     }


;-1448     if (CodeType == 112) {//ENDP 

.process358:
 mov al, [CodeType]
 cmp al, 112
 jne .process361

;-1449         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process362
 push process_3
 call error1
 add  sp, 2

;-1450         prs("\n;leaving: ");

.process362:
 push process_4
 call prs
 add  sp, 2

;-1451         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1452         prs(". loc labels:");

 push process_5
 call prs
 add  sp, 2

;-1453         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax

;-1454         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1455         prs(",loc jmp forward:");

 push process_6
 call prs
 add  sp, 2

;-1456         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax

;-1457         printIntU(i);        

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1458         fixJmp();

 call fixJmp

;-1459         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1460         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax

;-1461         LabelMaxIx   = tmpLabelMaxIx;                       

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax

;-1462         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax

;-1463         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax

;-1464         return;

 jmp .retnprocess

;-1465     }


;-1466     error1("Command not implemented or syntax error");

.process361:
 push process_7
 call error1
 add  sp, 2

;-1467 }


;-1468 


;-1469 int main() {

 .retnprocess: LEAVE
 ret
process_0 db "pop cs not allowed",0
process_1 db "\n;entering: ",0
process_2 db "already in PROC",0
process_3 db "not in PROC",0
process_4 db "\n;leaving: ",0
process_5 db ". loc labels:",0
process_6 db ",loc jmp forward:",0
process_7 db "Command not implemented or syntax error",0
ENDP

main: PROC

;-1470     getarg();

 call getarg

;-1471     parse();

 call parse

;-1472     fixJmpMain();

 call fixJmpMain

;-1473     epilog();

 call epilog

;-1474     end1();

 call end1

;-1475 }

 ret
ENDP
 
; missing functions: 
; Number of unresolved CALLs :    0 All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width  adr used name   list of global variables

;    1 arr sign byte     1    2 Version1[9]
;    2 def unsg byte     3    - SYMBOLMAX=31
;    3 arr sign byte     4   16 Symbol[31]
;    4 arr sign byte     5   36 SymbolUpper[31]
;    5 arr sign byte     6    3 ProcName[31]
;    6 var sign byte     7    6 isInProc
;    7 var unsg word     8   24 SymbolInt
;    8 var unsg dwrd     9 NULL SymbolLong
;    9 def unsg byte    10    - INPUTBUFMAX=255
;   10 arr sign byte    11    4 InputBuf[255]
;   11 ptr unsg byte    12   24 InputPtr
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
;   23 var unsg word    25    6 Origin
;   24 var unsg word    26    6 AbsoluteLab
;   25 var unsg word    27    2 PCStart
;   26 var sign byte    28    3 isLabel
;   27 def unsg byte    29    - DIGIT=1
;   28 def unsg byte    30    - LETTERE=2
;   29 def unsg byte    31    - ALNUME=3
;   30 def unsg byte    32    - NOALNUME=4
;   31 var sign byte    33   27 TokeType
;   32 def unsg byte    34    - BYTE=1
;   33 def unsg byte    35    - WORD=2
;   34 def unsg byte    36    - DWORD=3
;   35 def unsg byte    37    - SEGREG=4
;   36 def unsg byte    38    - IMM=1
;   37 def unsg byte    39    - REG=2
;   38 def unsg byte    40    - ADR=3
;   39 def unsg byte    41    - MEM=4
;   40 var sign byte    42   29 Op
;   41 var sign byte    43   31 Op2
;   42 var sign byte    44   29 CodeType
;   43 var sign byte    45   23 Code1
;   44 var sign byte    46    7 Code2
;   45 var sign byte    47    3 Code3
;   46 var sign byte    48   19 R2No
;   47 var sign byte    49   16 R1No
;   48 var sign byte    50   18 R2Type
;   49 var sign byte    51   15 R1Type
;   50 var sign byte    52   14 OpSize
;   51 var sign byte    53    9 wflag
;   52 var sign byte    54    3 dflag
;   53 var sign byte    55    8 sflag
;   54 var sign byte    56   15 rm
;   55 var sign byte    57    5 isDirect
;   56 var sign word    58   69 disp
;   57 var unsg word    59   13 imme
;   58 def unsg byte    61    - OPMAXLEN=5
;   59 arr sign byte    62    2 OpPos[5]
;   60 var sign word    63    6 OpPrintIndex
;   61 ptr sign byte    64   19 OpCodePtr
;   62 var sign byte    65    5 PrintRA
;   63 def unsg byte    67    - LABELNAMESMAX=5969
;   64 arr sign byte    68    3 LabelNames[6000]
;   65 ptr sign byte    69    7 LabelNamePtr
;   66 ptr sign byte    70    2 tmpLabelNamePtr
;   67 def unsg byte    72    - LABELADRMAX=600
;   68 arr unsg word    73    8 LabelAddr[600]
;   69 var sign word    74   10 LabelMaxIx
;   70 var sign word    75    3 tmpLabelMaxIx
;   71 var sign word    76   11 LabelIx
;   72 def unsg byte    78    - JMPNAMESMAX=3969
;   73 arr sign byte    79    3 JmpNames[4000]
;   74 ptr sign byte    80    7 JmpNamePtr
;   75 ptr sign byte    81    2 tmpJmpNamePtr
;   76 def unsg byte    83    - JMPMAX=200
;   77 arr unsg word    84    2 JmpAddr[200]
;   78 var sign word    85   11 JmpMaxIx
;   79 var sign word    86    3 tmpJmpMaxIx
;   80 def unsg byte    88    - FILEBINMAX=17000
;   81 arr sign byte    89    8 FileBin[17000]
;   82 var unsg word    90    6 BinLen
;   83 ptr sign byte    92    1 arglen
;   84 ptr sign byte    93    4 argv
;   85 var sign byte   394    1 I_START
;   86 arr sign byte   397 NULL I_PUSHA[8125]
;   87 arr sign byte   398 NULL I_NOP[24260]
;   88 arr sign byte   399 NULL I_CWDE[9734]
;   89 arr sign byte   400 NULL I_CDQ[1931]
;   90 arr sign byte   401 NULL I_PUSHF[35622]
;   91 arr sign byte   402 NULL I_SAHF[599]
;   92 arr sign byte   403 NULL I_MOVSB[53495]
;   93 arr sign byte   404 NULL I_CMPSB[54007]
;   94 arr sign byte   405 NULL I_STOSB[37]
;   95 arr sign byte   406 NULL I_LODSB[33600]
;   96 arr sign byte   407 NULL I_SCASB[8418]
;   97 arr sign byte   408 NULL I_LEAVE[53259]
;   98 arr sign byte   409 NULL I_INTO[12917]
;   99 arr sign byte   410 NULL I_XLAT[35622]
;  100 arr sign byte   411 NULL I_REPNE[2119]
;  101 arr sign byte   412 NULL I_REPE[18057]
;  102 arr sign byte   413 NULL I_HLT[9982]
;  103 arr sign byte   414 NULL I_STC[18315]
;  104 arr sign byte   415 NULL I_STI[9734]
;  105 arr sign byte   416 NULL I_STD[32643]
;  106 arr sign byte   418 NULL I_INC[10]
;  107 arr sign byte   419 NULL I_DEC[1397]
;  108 arr sign byte   420 NULL I_NOT[18119]
;  109 arr sign byte   421 NULL I_NEG[65534]
;  110 arr sign byte   422 NULL I_MUL[33791]
;  111 arr sign byte   423 NULL I_IMUL[65150]
;  112 arr sign byte   424 NULL I_DIV[30207]
;  113 arr sign byte   425 NULL I_IDIV[15642]
;  114 arr sign byte   427 NULL I_LES[65535]
;  115 arr sign byte   428 NULL I_LDS[5493]
;  116 arr sign byte   429 NULL I_LEA[33574]
;  117 arr sign byte   430 NULL I_LSS[1151]
;  118 arr sign byte   431 NULL I_LFS[29696]
;  119 arr sign byte   432 NULL I_LGS[35593]
;  120 arr sign byte   434 NULL I_ADD[2630]
;  121 arr sign byte   435 NULL I_OR[14630]
;  122 arr sign byte   436 NULL I_ADC[1095]
;  123 arr sign byte   437 NULL I_SBB[26997]
;  124 arr sign byte   438 NULL I_AND[49203]
;  125 arr sign byte   439 NULL I_SUB[52169]
;  126 arr sign byte   440 NULL I_XOR[33680]
;  127 arr sign byte   441 NULL I_CMP[65150]
;  128 arr sign byte   442 NULL I_TEST[29729]
;  129 arr sign byte   444 NULL I_MOV[33618]
;  130 arr sign byte   445 NULL I_MOVSX[65150]
;  131 arr sign byte   446 NULL I_MOVZX[29731]
;  132 arr sign byte   448 NULL I_JO[33612]
;  133 arr sign byte   449 NULL I_JNO[65150]
;  134 arr sign byte   450 NULL I_JB[29732]
;  135 arr sign byte   451 NULL I_JNB[33606]
;  136 arr sign byte   452 NULL I_JAE[65150]
;  137 arr sign byte   453 NULL I_JE[29734]
;  138 arr sign byte   454 NULL I_JNE[33600]
;  139 arr sign byte   455 NULL I_JBE[65150]
;  140 arr sign byte   456 NULL I_JA[29730]
;  141 arr sign byte   457 NULL I_JS[33594]
;  142 arr sign byte   458 NULL I_JNS[65150]
;  143 arr sign byte   459 NULL I_JP[29737]
;  144 arr sign byte   460 NULL I_JNP[33588]
;  145 arr sign byte   461 NULL I_JL[65150]
;  146 arr sign byte   462 NULL I_JNL[29736]
;  147 arr sign byte   463 NULL I_JLE[33582]
;  148 arr sign byte   464 NULL I_JG[65150]
;  149 arr sign byte   466 NULL I_JMP[29733]
;  150 arr sign byte   467 NULL I_CALL[15656]
;  151 arr sign byte   469 NULL I_RET[33]
;  152 arr sign byte   470 NULL I_RETF[9076]
;  153 arr sign byte   472 NULL I_PUSH[9021]
;  154 arr sign byte   473 NULL I_POP[29696]
;  155 arr sign byte   475 NULL I_ROL[15646]
;  156 arr sign byte   476 NULL I_RCL[36]
;  157 arr sign byte   477 NULL I_SHL[6516]
;  158 arr sign byte   478 NULL I_SHR[9789]
;  159 arr sign byte   480 NULL I_INT[29696]
;  160 arr sign byte   482 NULL I_IN[15636]
;  161 arr sign byte   483 NULL I_INSB[34]
;  162 arr sign byte   484 NULL I_INSW[3956]
;  163 arr sign byte   485 NULL I_INSD[10557]
;  164 arr sign byte   486 NULL I_OUT[29696]
;  165 arr sign byte   487 NULL I_OUTSB[15626]
;  166 arr sign byte   488 NULL I_OUTSW[40]
;  167 arr sign byte   489 NULL I_OUTSD[1396]
;  168 arr sign byte   491 NULL I_XCHG[9533]
;  169 arr sign byte   493 NULL I_LOOPNZ[29952]
;  170 arr sign byte   494 NULL I_LOOPNE[33542]
;  171 arr sign byte   495 NULL I_LOOPZ[2686]
;  172 arr sign byte   496 NULL I_LOOPE[60176]
;  173 arr sign byte   497 NULL I_LOOP[33540]
;  174 arr sign byte   498 NULL I_JCXZ[2686]
;  175 arr sign byte   499 NULL I_JECXZ[29984]
;  176 arr sign byte   501 NULL I_ENTER[47255]
;  177 arr sign byte   503 NULL I_ORG[1]
;  178 arr sign byte   505 NULL I_SECTION[52169]
;  179 arr sign byte   506 NULL I_SEGMENT[21904]
;  180 arr sign byte   507 NULL I_ABSOLUTE[60555]
;  181 arr sign byte   508 NULL I_PROC[5816]
;  182 arr sign byte   509 NULL I_ENDP[39424]
;  183 arr sign byte   510 NULL I_DB[674]
;  184 arr sign byte   511 NULL I_DW[8125]
;  185 arr sign byte   512 NULL I_DD[51030]
;  186 arr sign byte   513 NULL I_RESB[65094]
;  187 arr sign byte   514 NULL I_RESW[0]
;  188 arr sign byte   515 NULL I_RESD[1678]
;  189 var sign byte   516 NULL I_END


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
;    9    2  111   fputcR
;   10    1  114   getLine
;   11    1  130   ifEOL
;   12    3  139   skipBlank
;   13    2  144   letterE
;   14    1  154   alnumE
;   15    3  159   digit
;   16    4  164   strlen
;   17   10  169   strcpy
;   18   35  175   eqstr
;   19    3  184   strcat1
;   20    2  188   toupper
;   21    1  195   getDigit
;   22    1  207   getName
;   23    1  226   testReg
;   24    1  270   printLine
;   25    7  292   prc
;   26    1  302   prscomment
;   27   48  310   prs
;   28    3  332   printhex8a
;   29    2  337   printhex4
;   30    7  342   printhex16
;   31    9  347   printIntU
;   32   27  358   error1
;   33   13  365   errorexit
;   34    4  370   notfounderror
;   35 NULL  376   allowederror
;   36    3  377   addrerror
;   37    1  378   immeerror
;   38    2  379   implerror
;   39    4  380   indexerror
;   40    3  381   invaloperror
;   41    6  382   numbererror
;   42    1  383   regmemerror
;   43    3  384   reg16error
;   44    1  385   segregerror
;   45    5  386   syntaxerror
;   46 NULL  388   addrexit
;   47    3  389   dataexit
;   48 NULL  390   internexit
;   49    2  518   lookCode
;   50    2  535   ChangeDirection
;   51    2  543   checkOpL
;   52    4  552   check2Ops
;   53    1  561   get2Ops
;   54    3  567   getOpL
;   55    2  575   getOpR
;   56    4  588   getOp1
;   57    1  605   getMEM
;   58    1  631   getIndReg1
;   59    1  639   getIndReg2
;   60    2  649   setwflag
;   61    2  660   setsflag
;   62    2  670   checkConstSize
;   63    1  678   parse
;   64   16  714   getTokeType
;   65    3  725   storeJmp
;   66    2  736   storeLabel
;   67    6  748   searchLabel
;   68    1  761   getVariable
;   69    1  814   getCodeSize
;   70    9  822   isToken
;   71    2  830   need
;   72    1  839   skipRest
;   73    1  846   getarg
;   74    1  880   fixJmp
;   75    1  914   fixJmpMain
;   76    2  943   epilog
;   77    2  991   end1
;   78    1 1001   getCodes
;   79   35 1006   genCode8
;   80    1 1017   gen66h
;   81    8 1019   genCode2
;   82   13 1023   genCodeW
;   83   19 1027   genCode16
;   84    1 1031   genCode32
;   85   13 1035   writeEA
;   86    4 1077   genImmediate
;   87    1 1084   process
;   88 NULL 1469   main
;   89 NULL 1475   LastFunctionByt

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
;    9    66 readRL
;   10    73 errorexit
;   11    83 errorexit
;   12    93 ifEOL
;   13    99 readRL
;   14   106 errorexit
;   15   116 digit
;   16   122 letterE
;   17   130 strcpy
;   18   137 digit
;   19   143 alnumE
;   20   150 errorexit
;   21   160 strcpy
;   22   167 toupper
;   23   175 strlen
;   24   182 strlen
;   25   189 eqstr
;   26   195 eqstr
;   27   201 eqstr
;   28   207 eqstr
;   29   213 eqstr
;   30   219 eqstr
;   31   225 eqstr
;   32   231 eqstr
;   33   237 eqstr
;   34   243 eqstr
;   35   249 eqstr
;   36   255 eqstr
;   37   261 eqstr
;   38   267 eqstr
;   39   273 eqstr
;   40   279 eqstr
;   41   285 eqstr
;   42   291 eqstr
;   43   297 eqstr
;   44   303 eqstr
;   45   309 eqstr
;   46   315 eqstr
;   47   321 eqstr
;   48   327 eqstr
;   49   333 eqstr
;   50   339 eqstr
;   51   345 eqstr
;   52   351 eqstr
;   53   357 eqstr
;   54   363 eqstr
;   55   369 prs
;   56   373 printhex16
;   57   384 prs
;   58   388 prc
;   59   392 printhex8a
;   60   403 prs
;   61   407 prc
;   62   411 prscomment
;   63   422 writetty
;   64   431 writetty
;   65   440 fputcR
;   66   447 prc
;   67   451 prc
;   68   455 printhex4
;   69   465 printhex4
;   70   475 prc
;   71   479 printhex8a
;   72   490 printhex8a
;   73   501 printIntU
;   74   511 prc
;   75   515 prs
;   76   519 prs
;   77   523 prs
;   78   527 prs
;   79   531 error1
;   80   538 epilog
;   81   545 end1
;   82   550 prs
;   83   554 prs
;   84   558 prs
;   85   562 error1
;   86   569 error1
;   87   576 error1
;   88   583 error1
;   89   590 error1
;   90   597 error1
;   91   604 error1
;   92   611 error1
;   93   618 error1
;   94   625 error1
;   95   632 error1
;   96   639 errorexit
;   97   649 errorexit
;   98   659 errorexit
;   99   669 eqstr
;  100   675 implerror
;  101   685 segregerror
;  102   697 setwflag
;  103   706 error1
;  104   713 error1
;  105   720 get2Ops
;  106   728 addrerror
;  107   738 invaloperror
;  108   751 immeerror
;  109   761 addrerror
;  110   771 invaloperror
;  111   784 setwflag
;  112   793 getOpL
;  113   800 need
;  114   805 getOpR
;  115   812 getOpR
;  116   819 getOp1
;  117   826 isToken
;  118   834 getMEM
;  119   841 invaloperror
;  120   854 error1
;  121   861 testReg
;  122   869 searchLabel
;  123   881 getTokeType
;  124   893 getOp1
;  125   900 syntaxerror
;  126   912 getIndReg2
;  127   923 getIndReg1
;  128   934 notfounderror
;  129   948 isToken
;  130   956 getTokeType
;  131   968 numbererror
;  132   980 isToken
;  133   988 isToken
;  134   996 errorexit
;  135  1006 indexerror
;  136  1017 indexerror
;  137  1028 indexerror
;  138  1039 indexerror
;  139  1050 gen66h
;  140  1057 error1
;  141  1064 getLine
;  142  1072 getTokeType
;  143  1084 strcpy
;  144  1091 storeLabel
;  145  1102 getTokeType
;  146  1114 lookCode
;  147  1123 process
;  148  1131 getVariable
;  149  1143 skipRest
;  150  1152 error1
;  151  1159 error1
;  152  1166 printLine
;  153  1176 skipBlank
;  154  1186 digit
;  155  1192 getDigit
;  156  1201 letterE
;  157  1209 getName
;  158  1217 errorexit
;  159  1227 strcpy
;  160  1234 errorexit
;  161  1244 searchLabel
;  162  1256 error1
;  163  1263 errorexit
;  164  1273 strcpy
;  165  1280 errorexit
;  166  1290 eqstr
;  167  1296 strlen
;  168  1303 storeLabel
;  169  1314 getTokeType
;  170  1326 lookCode
;  171  1335 dataexit
;  172  1344 dataexit
;  173  1353 getTokeType
;  174  1365 genCode8
;  175  1374 skipBlank
;  176  1384 isToken
;  177  1392 genCode8
;  178  1401 isToken
;  179  1409 getTokeType
;  180  1421 genCode16
;  181  1431 isToken
;  182  1439 getTokeType
;  183  1451 genCode16
;  184  1461 genCode16
;  185  1471 isToken
;  186  1479 getTokeType
;  187  1491 syntaxerror
;  188  1503 error1
;  189  1510 numbererror
;  190  1522 dataexit
;  191  1531 eqstr
;  192  1537 getTokeType
;  193  1549 eqstr
;  194  1555 getTokeType
;  195  1567 eqstr
;  196  1573 getTokeType
;  197  1585 skipBlank
;  198  1595 isToken
;  199  1603 getTokeType
;  200  1615 error1
;  201  1622 prs
;  202  1626 prc
;  203  1630 getTokeType
;  204  1642 error1
;  205  1649 cputs
;  206  1655 cputs
;  207  1661 exitR
;  208  1667 toupper
;  209  1675 strcpy
;  210  1682 strcat1
;  211  1690 strcpy
;  212  1697 strcat1
;  213  1705 strcpy
;  214  1712 strcat1
;  215  1720 openR
;  216  1726 cputs
;  217  1732 cputs
;  218  1738 exitR
;  219  1744 creatR
;  220  1751 cputs
;  221  1757 cputs
;  222  1763 exitR
;  223  1769 creatR
;  224  1776 cputs
;  225  1782 cputs
;  226  1788 exitR
;  227  1794 prs
;  228  1798 prs
;  229  1802 prs
;  230  1806 prs
;  231  1810 prs
;  232  1814 prs
;  233  1818 prs
;  234  1822 prs
;  235  1826 prs
;  236  1830 prs
;  237  1834 printIntU
;  238  1844 strcpy
;  239  1851 strlen
;  240  1858 prs
;  241  1862 printIntU
;  242  1872 prs
;  243  1876 prs
;  244  1880 prs
;  245  1884 printhex16
;  246  1895 searchLabel
;  247  1907 notfounderror
;  248  1921 prs
;  249  1925 printhex16
;  250  1936 prs
;  251  1940 printhex16
;  252  1951 prs
;  253  1955 printIntU
;  254  1965 error1
;  255  1972 strcpy
;  256  1979 prs
;  257  1983 prs
;  258  1987 prs
;  259  1991 printhex16
;  260  2002 searchLabel
;  261  2014 notfounderror
;  262  2028 prs
;  263  2032 printhex16
;  264  2043 prs
;  265  2047 printhex16
;  266  2058 prs
;  267  2062 printIntU
;  268  2072 prs
;  269  2076 prs
;  270  2080 prs
;  271  2084 prs
;  272  2088 prs
;  273  2092 prs
;  274  2096 printIntU
;  275  2106 prs
;  276  2110 prs
;  277  2114 printIntU
;  278  2124 fputcR
;  279  2131 fcloseR
;  280  2139 fcloseR
;  281  2147 fcloseR
;  282  2155 exitR
;  283  2161 errorexit
;  284  2171 genCode8
;  285  2180 genCode8
;  286  2189 genCode8
;  287  2198 genCode8
;  288  2207 genCode8
;  289  2216 genCode16
;  290  2226 genCode16
;  291  2236 genCode8
;  292  2245 genCode8
;  293  2254 genCode16
;  294  2264 genCode32
;  295  2274 genCode16
;  296  2284 genCode8
;  297  2293 getTokeType
;  298  2305 getCodeSize
;  299  2317 getCodes
;  300  2326 genCode8
;  301  2335 getOpL
;  302  2342 checkOpL
;  303  2351 genCode2
;  304  2360 getTokeType
;  305  2372 implerror
;  306  2382 genCodeW
;  307  2391 writeEA
;  308  2399 check2Ops
;  309  2409 reg16error
;  310  2420 addrerror
;  311  2430 genCode8
;  312  2439 genCode8
;  313  2448 writeEA
;  314  2456 check2Ops
;  315  2466 setsflag
;  316  2475 genCodeW
;  317  2484 genImmediate
;  318  2497 genCodeW
;  319  2506 writeEA
;  320  2514 genCode8
;  321  2523 genImmediate
;  322  2536 genCodeW
;  323  2545 writeEA
;  324  2553 genCodeW
;  325  2562 writeEA
;  326  2570 syntaxerror
;  327  2582 check2Ops
;  328  2592 notfounderror
;  329  2606 genCode2
;  330  2615 genImmediate
;  331  2628 genCodeW
;  332  2637 writeEA
;  333  2645 genImmediate
;  334  2658 regmemerror
;  335  2670 ChangeDirection
;  336  2686 reg16error
;  337  2697 genCode2
;  338  2706 writeEA
;  339  2714 genCodeW
;  340  2723 genCode16
;  341  2733 genCodeW
;  342  2742 genCode16
;  343  2752 genCodeW
;  344  2761 writeEA
;  345  2769 ChangeDirection
;  346  2785 genCodeW
;  347  2794 writeEA
;  348  2802 syntaxerror
;  349  2814 searchLabel
;  350  2826 checkConstSize
;  351  2841 genCode2
;  352  2850 genCode8
;  353  2859 genCode8
;  354  2868 genCode2
;  355  2877 genCode16
;  356  2887 genCode8
;  357  2896 genCode2
;  358  2905 storeJmp
;  359  2914 genCode16
;  360  2924 searchLabel
;  361  2936 checkConstSize
;  362  2951 genCode8
;  363  2960 genCode8
;  364  2969 genCode8
;  365  2978 genCode16
;  366  2988 genCode8
;  367  2997 genCode16
;  368  3007 genCode8
;  369  3016 storeJmp
;  370  3025 genCode16
;  371  3035 genCode8
;  372  3044 genCode16
;  373  3054 genCode8
;  374  3063 getOpL
;  375  3070 setsflag
;  376  3079 genCode2
;  377  3088 genCode8
;  378  3097 genCode16
;  379  3107 genCode8
;  380  3116 genCode16
;  381  3126 genCode8
;  382  3135 storeJmp
;  383  3144 genCode16
;  384  3154 error1
;  385  3161 genCode8
;  386  3170 genCode8
;  387  3179 checkOpL
;  388  3188 reg16error
;  389  3199 genCode2
;  390  3208 genCode8
;  391  3217 writeEA
;  392  3225 syntaxerror
;  393  3237 check2Ops
;  394  3247 genCodeW
;  395  3256 writeEA
;  396  3264 genCodeW
;  397  3273 writeEA
;  398  3281 genCode8
;  399  3290 genCodeW
;  400  3299 writeEA
;  401  3307 genCode8
;  402  3316 genCode8
;  403  3325 genCode8
;  404  3334 getOp1
;  405  3341 genCode16
;  406  3351 numbererror
;  407  3363 need
;  408  3368 getOp1
;  409  3375 genCode8
;  410  3384 numbererror
;  411  3396 numbererror
;  412  3408 numbererror
;  413  3420 prs
;  414  3424 prs
;  415  3428 error1
;  416  3435 error1
;  417  3442 prs
;  418  3446 prs
;  419  3450 prs
;  420  3454 printIntU
;  421  3464 prs
;  422  3468 printIntU
;  423  3478 fixJmp
;  424  3485 error1
;  425  3492 getarg
;  426  3499 parse
;  427  3505 fixJmpMain
;  428  3516 epilog
;  429  3523 end1
;Input: AS.C, List: AS.S,  Lines: 1476
;Glob. variables:  189 max.:  200
;Functions      :   90 max.:  300
;Calls          :  430 max.: 2000, NameField: 3528 max.:    65535
;Code until     :21667 max.: 30000, free: 8333
;Data (HeapEnd) :59154, resting stacksize:  6381
;Max. Const in 'testReg' :  658 max. 3000, free: 2342