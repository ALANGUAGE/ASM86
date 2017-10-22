
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

;-374 }


;-375 int allowederror() {error1("not allowed here"); }

 ret
notfounderror_0 db "\n;***** ERROR: label not found: ",0
ENDP

allowederror: PROC
 push allowederror_0
 call error1
 add  sp, 2

;-376 int addrerror()    {error1("address missing");}

 ret
allowederror_0 db "not allowed here",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-377 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-378 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-379 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-380 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-381 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-382 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-383 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-384 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-385 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-386 


;-387 int addrexit()     {errorexit("illegal address");}

 ret
syntaxerror_0 db "syntax",0
ENDP

addrexit: PROC
 push addrexit_0
 call errorexit
 add  sp, 2

;-388 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
addrexit_0 db "illegal address",0
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-389 int internexit()   {errorexit("intern compiler error");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

internexit: PROC
 push internexit_0
 call errorexit
 add  sp, 2

;-390 


;-391 


;-392 //#include "OPTABL.C"


;-393 char I_START=0xF1;

 ret
internexit_0 db "intern compiler error",0
ENDP
I_START db 241

;-394 //OpName, 0, CodeType, OpCode1-n, F1h


;-395 //  1:   1 byte opcode


;-396 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-397 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-398 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-399 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-400 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-401 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-402 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-403 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-404 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-405 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-406 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-407 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-408 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-409 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-410 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-411 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-412 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-413 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-414 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-415 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-416 // 2: mem reg 16 bit


;-417 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-418 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-419 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-420 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-421 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-422 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-423 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-424 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-425 //  3: les, lda, lea, lss, lfs, lgs


;-426 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-427 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-428 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-429 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-430 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-431 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-432 //  4: acc,imm  reg,imm  index,reg


;-433 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-434 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-435 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-436 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-437 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-438 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-439 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-440 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-441 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-442 //  5: mov


;-443 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-444 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-445 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-446 //  6: single byte relative jump


;-447 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-448 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-449 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-450 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-451 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-452 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-453 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-454 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-455 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-456 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-457 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-458 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-459 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-460 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-461 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-462 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-463 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-464 //  7: jmp, call


;-465 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-466 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-467 //  8: ret


;-468 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-469 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-470 //  9: seg, r/m


;-471 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,255,6,6,241

;-472 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16

I_POP db 80,79,80,0,9,88,143,0,7,241

;-473 //  11: shift, rotates


;-474 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-475 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-476 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-477 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-478 //  12: int


;-479 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-480 //  14: in/out


;-481 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-482 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-483 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-484 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-485 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-486 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-487 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-488 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-489 //  15: xchg


;-490 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-491 //  16: loop, jcxz


;-492 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-493 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-494 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-495 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-496 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-497 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-498 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-499 //  30: enter


;-500 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-501 // 100: directives


;-502 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-503 // section, segment .TEXT .DATA .BSS


;-504 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-505 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-506 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-507 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-508 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-509 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-510 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-511 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-512 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-513 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-514 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-515 char I_END=0;// end of table char

I_END db 0

;-516 


;-517 int lookCode() {//ret: CodeType, *OpCodePtr


lookCode: PROC

;-518     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-519     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-520     OpCodePtr++;

 inc  word[OpCodePtr]

;-521     do  {

.lookCode99:

;-522         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode100

;-523             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode101:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode102
 inc  word[OpCodePtr]

;-524             OpCodePtr++;

 jmp .lookCode101
.lookCode102:
 inc  word[OpCodePtr]

;-525             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-526             return;

 jmp .retnlookCode

;-527         }


;-528     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode100:
.lookCode103:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode104
 inc  word[OpCodePtr]

;-529     OpCodePtr++;

 jmp .lookCode103
.lookCode104:
 inc  word[OpCodePtr]

;-530     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode105
 jmp .lookCode99
.lookCode105:

;-531 }


;-532 


;-533 //#include "OPS.C"


;-534 int ChangeDirection() {

 .retnlookCode:
 ret
ENDP

ChangeDirection: PROC

;-535     char c;


;-536     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   535 NULL c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-537     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-538     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-539     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-540 }


;-541 


;-542 int checkOpL() {
 LEAVE
 ret
ENDP

checkOpL: PROC

;-543     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL106
 call implerror

;-544     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL106:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL107
 call segregerror
 jmp .retncheckOpL

;-545     setwflag();

.checkOpL107:
 call setwflag

;-546     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL108
 push checkOpL_0
 call error1
 add  sp, 2

;-547     if (OpSize == R1Type) return;

.checkOpL108:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL109
 jmp .retncheckOpL

;-548     if (Op == REG) if (R1Type==0) error1("no register defined");

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

;-549 }

.checkOpL111:
.checkOpL110:

;-550 


;-551 int check2Ops() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

check2Ops: PROC

;-552     get2Ops();

 call get2Ops

;-553     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops112
 call addrerror

;-554     if (Op == ADR) invaloperror();

.check2Ops112:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops113
 call invaloperror

;-555     if (Op == IMM) immeerror();

.check2Ops113:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops114
 call immeerror

;-556     if (Op2==   0) addrerror();

.check2Ops114:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops115
 call addrerror

;-557     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov

.check2Ops115:
 mov al, [CodeType]
 cmp al, 5
 je  .check2Ops116
 mov al, [Op2]
 cmp al, 3
 jne .check2Ops117
 call invaloperror

;-558     setwflag();

.check2Ops117:
.check2Ops116:
 call setwflag

;-559 }


;-560 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-561     getOpL();

 call getOpL

;-562     need(',');

 push 44
 call need
 add  sp, 2

;-563     getOpR();

 call getOpR

;-564 }


;-565 


;-566 int getOpL() {

 ret
ENDP

getOpL: PROC

;-567 //set: op=0,IMM,REG,ADR,MEM


;-568     getOpR();

 call getOpR

;-569     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-570     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-571     R1Type=R2Type; R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-572 }


;-573 


;-574 int getOpR() {

 ret
ENDP

getOpR: PROC

;-575     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-576     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR118
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-577     if (Op2 == 0)     {invaloperror();         return;}

.getOpR118:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR119
 call invaloperror
 jmp .retngetOpR

;-578     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR119:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR120
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-579     if (Op2 == REG)                            return;

.getOpR120:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR121
 jmp .retngetOpR

;-580     if (Op2 == ADR)   {

.getOpR121:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR122

;-581         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR123
 mov ax, 0
 mov word [disp], ax

;-582         else disp=LabelAddr[LabelIx];

 jmp .getOpR124
.getOpR123:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-583         return;}

.getOpR124:
 jmp .retngetOpR

;-584     error1("Name of operand expected");

.getOpR122:
 push getOpR_0
 call error1
 add  sp, 2

;-585 }


;-586 


;-587 int getOp1() {//scan for a single operand

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOp1: PROC

;-588 //return:0, IMM, REG, ADR (not MEM)


;-589 //set   :R2Type, R2No by testReg


;-590 //set   :LabelIx by searchLabel


;-591     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1125
 mov ax, 0
 jmp .retngetOp1

;-592     if (TokeType == DIGIT)  return IMM;

.getOp1125:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1126
 mov ax, 1
 jmp .retngetOp1

;-593     if (TokeType == ALNUME) {

.getOp1126:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1127

;-594         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-595         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1128
 mov ax, 2
 jmp .retngetOp1

;-596         LabelIx=searchLabel();

.getOp1128:
 call searchLabel
 mov word [LabelIx], ax

;-597         return ADR;

 mov ax, 3
 jmp .retngetOp1

;-598 //        if (LabelIx)        return ADR;


;-599 //        else error1("variable not found");


;-600     }


;-601     return 0;

.getOp1127:
 mov ax, 0
 jmp .retngetOp1

;-602 }


;-603 


;-604 int getMEM() {// e.g. [array+bp+si-4]

 .retngetOp1:
 ret
ENDP

getMEM: PROC

;-605 //set: disp, rm, R2Type


;-606     char c;


;-607     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   606 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-608     do {

.getMEM129:

;-609         getTokeType();

 call getTokeType

;-610         c=getOp1();

 call getOp1
 mov [bp-2], al

;-611         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM130
 call syntaxerror

;-612         if (c == REG) {

.getMEM130:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM131

;-613             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-614             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM132
 call getIndReg2
 mov byte [rm], al

;-615             else getIndReg1();

 jmp .getMEM133
.getMEM132:
 call getIndReg1

;-616         }

.getMEM133:

;-617         if (c == ADR) {

.getMEM131:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM134

;-618             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM135
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-619             else notfounderror();

 jmp .getMEM136
.getMEM135:
 call notfounderror

;-620         }

.getMEM136:

;-621         if (c == IMM) disp=disp+SymbolInt;

.getMEM134:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM137
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-622         if (isToken('-')) {

.getMEM137:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM138

;-623             getTokeType();

 call getTokeType

;-624             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM139
 call numbererror

;-625             disp = disp - SymbolInt;

.getMEM139:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-626         }


;-627     } while (isToken('+'));

.getMEM138:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM140
 jmp .getMEM129
.getMEM140:

;-628     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM141
 push getMEM_0
 call errorexit
 add  sp, 2

;-629 }

.getMEM141:

;-630 int getIndReg1() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getIndReg1: PROC

;-631     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1142
 call indexerror

;-632     if (R2No==3) rm=7;//BX

.getIndReg1142:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1143
 mov ax, 7
 mov byte [rm], al

;-633     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1143:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1144
 mov ax, 6
 mov byte [rm], al

;-634     if (R2No==7) rm=5;//DI

.getIndReg1144:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1145
 mov ax, 5
 mov byte [rm], al

;-635     if (R2No==6) rm=4;//SI

.getIndReg1145:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1146
 mov ax, 4
 mov byte [rm], al

;-636     if (rm==0) indexerror();

.getIndReg1146:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1147
 call indexerror

;-637 }

.getIndReg1147:

;-638 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   638 NULL m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-639     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2148
 call indexerror

;-640     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2148:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2149
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2150
 mov ax, 3
 mov [bp-2], al

;-641              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2151
.getIndReg2150:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2152
 mov ax, 1
 mov [bp-2], al

;-642     if (R2No==6) if (rm==6) m=2;//BP+SI

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

;-643              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2155
.getIndReg2154:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2156
 mov ax, 0
 mov [bp-2], al

;-644     if (m > 3) indexerror();

.getIndReg2156:
.getIndReg2155:
.getIndReg2153:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2157
 call indexerror

;-645     return m;

.getIndReg2157:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-646 }


;-647 


;-648 int setwflag() {//word size, bit 0

 .retngetIndReg2: LEAVE
 ret
ENDP

setwflag: PROC

;-649     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-650     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag158

;-651         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag159
 mov al, [R1Type]
 mov byte [OpSize], al

;-652         if (Op2== REG) OpSize=R2Type;

.setwflag159:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag160
 mov al, [R2Type]
 mov byte [OpSize], al

;-653         if (R2Type== SEGREG) OpSize=WORD;

.setwflag160:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag161
 mov ax, 2
 mov byte [OpSize], al

;-654         if (R1Type == SEGREG) OpSize=WORD;

.setwflag161:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag162
 mov ax, 2
 mov byte [OpSize], al

;-655     }

.setwflag162:

;-656     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag158:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag163
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-657     if (OpSize  ==  WORD) wflag=1;

.setwflag163:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag164
 mov ax, 1
 mov byte [wflag], al

;-658 }

.setwflag164:

;-659 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-660     unsigned int ui;


;-661     sflag=2;

;Function : setsflag, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   660 NULL ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-662     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-663     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag165
 mov ax, 0
 mov byte [sflag], al

;-664     if (OpSize == BYTE) {

.setsflag165:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag166

;-665         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag167
 push setsflag_0
 call error1
 add  sp, 2

;-666         sflag=0;//byte reg does not need sign extended

.setsflag167:
 mov ax, 0
 mov byte [sflag], al

;-667     }


;-668 }

.setsflag166:

;-669 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-670     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   669 NULL ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize168
 mov ax, 0
 jmp .retncheckConstSize

;-671     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize168:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize169
 mov ax, 0
 jmp .retncheckConstSize

;-672     return 2;// is short

.checkConstSize169:
 mov ax, 2
 jmp .retncheckConstSize

;-673 }


;-674 


;-675 


;-676 //#include "PARSE.C"


;-677 int parse() {

 .retncheckConstSize: LEAVE
 ret
ENDP

parse: PROC

;-678     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-679     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax

;-680     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-681     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax

;-682     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-683     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-684 


;-685     do {//process a new line

.parse170:

;-686         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-687         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-688         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-689         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-690         getLine();

 call getLine

;-691         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-692         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-693         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse171

;-694             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse172

;-695               if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse173
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-696                 storeLabel();

.parse173:
 call storeLabel

;-697                 InputPtr++;//remove :

 inc  word[InputPtr]

;-698                 getTokeType();

 call getTokeType

;-699             }


;-700         }

.parse172:

;-701         if (TokeType == ALNUME) {

.parse171:
 mov al, [TokeType]
 cmp al, 3
 jne .parse174

;-702             lookCode();// and OpCodePtr

 call lookCode

;-703             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse175
 call process

;-704             else getVariable();

 jmp .parse176
.parse175:
 call getVariable

;-705             skipRest();

.parse176:
 call skipRest

;-706         }


;-707         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp .parse177
.parse174:
 mov al, [TokeType]
 cmp al, 3
 jle .parse178
 push parse_0
 call error1
 add  sp, 2

;-708         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp .parse179
.parse178:
 mov al, [TokeType]
 cmp al, 1
 jne .parse180
 push parse_1
 call error1
 add  sp, 2

;-709         printLine();

.parse180:
.parse179:
.parse177:
 call printLine

;-710     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse181
 jmp .parse170
.parse181:

;-711 }


;-712 


;-713 int getTokeType() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0
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
 jne .getTokeType182
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-718     if (c == ';') {TokeType=0; return; }//comment

.getTokeType182:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType183
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-719     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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

;-720     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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

;-721     TokeType=NOALNUME;

.getTokeType185:
 mov ax, 4
 mov byte [TokeType], al

;-722 }


;-723 


;-724 int storeJmp() {

 .retngetTokeType: LEAVE
 ret
ENDP

storeJmp: PROC

;-725     unsigned int i;


;-726     JmpMaxIx++;

;Function : storeJmp, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   725 NULL i = bp-2;
 ENTER  2,0
 inc  word[JmpMaxIx]

;-727     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp186
 push storeJmp_0
 call errorexit
 add  sp, 2

;-728     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp186:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax

;-729     JmpNamePtr++;

 inc  word[JmpNamePtr]

;-730     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax

;-731     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp187
 push storeJmp_1
 call errorexit
 add  sp, 2

;-732     JmpAddr[JmpMaxIx] = PC;

.storeJmp187:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax

;-733 }


;-734 


;-735 int storeLabel() {
 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC

;-736     unsigned int i;


;-737     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   736 NULL i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel188
 push storeLabel_0
 call error1
 add  sp, 2

;-738     LabelMaxIx++;

.storeLabel188:
 inc  word[LabelMaxIx]

;-739     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel189
 push storeLabel_1
 call errorexit
 add  sp, 2

;-740     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel189:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-741     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-742     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-743     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel190
 push storeLabel_2
 call errorexit
 add  sp, 2

;-744     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel190:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-745 }


;-746 


;-747 int searchLabel() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

searchLabel: PROC

;-748     int LIx; char *p;


;-749     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   748 NULL LIx = bp-2
;  201 ptr sign byte   748 NULL p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-750     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-751     while (LIx <= LabelMaxIx) {

.searchLabel191:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel192

;-752         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel193
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-753         p=strlen(p) + p;

.searchLabel193:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-754         p++;

 inc  word[bp-4]

;-755         LIx++;

 inc  word[bp-2]

;-756     }


;-757     return 0;

 jmp .searchLabel191
.searchLabel192:
 mov ax, 0
 jmp .retnsearchLabel

;-758 }


;-759 


;-760 int getVariable() {

 .retnsearchLabel: LEAVE
 ret
ENDP

getVariable: PROC

;-761     char c;


;-762     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   761 NULL c = bp-2;
 ENTER  2,0
 call storeLabel

;-763     getTokeType();

 call getTokeType

;-764     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable194

;-765         lookCode();

 call lookCode

;-766         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable195
 call dataexit

;-767         if (CodeType > 205) dataexit();

.getVariable195:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable196
 call dataexit

;-768         if (CodeType== 200) {//DB

.getVariable196:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable197

;-769             do {

.getVariable198:

;-770                 getTokeType();

 call getTokeType

;-771                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable199
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-772                 else {

 jmp .getVariable200
.getVariable199:

;-773                     skipBlank();

 call skipBlank

;-774                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable201

;-775                         do {

.getVariable202:

;-776                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-777                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-778                             InputPtr++;

 inc  word[InputPtr]

;-779                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable203
 jmp .getVariable202
.getVariable203:

;-780                         InputPtr++;

 inc  word[InputPtr]

;-781                     }


;-782                 }

.getVariable201:

;-783             } while (isToken(','));

.getVariable200:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable204
 jmp .getVariable198
.getVariable204:

;-784         }


;-785         if (CodeType == 201) {//DW

.getVariable197:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable205

;-786             do {

.getVariable206:

;-787                 getTokeType();

 call getTokeType

;-788                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable207
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-789             } while (isToken(','));

.getVariable207:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable208
 jmp .getVariable206
.getVariable208:

;-790         }


;-791         if (CodeType == 202) {//DD

.getVariable205:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable209

;-792             do {

.getVariable210:

;-793                 getTokeType();

 call getTokeType

;-794                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable211
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-795                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-796             } while (isToken(','));

.getVariable211:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable212
 jmp .getVariable210
.getVariable212:

;-797         }


;-798         if (CodeType >= 203) {//resb, resw, resd

.getVariable209:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable213

;-799             getTokeType();

 call getTokeType

;-800             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable214

;-801                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable215
 call syntaxerror

;-802                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable215:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable216
 push getVariable_0
 call error1
 add  sp, 2

;-803                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable216:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-804                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable217
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-805                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable217:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable218
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-806                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable218:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-807             } else numbererror();

 jmp .getVariable219
.getVariable214:
 call numbererror

;-808         }

.getVariable219:

;-809     }

.getVariable213:

;-810     else dataexit();

 jmp .getVariable220
.getVariable194:
 call dataexit

;-811 }

.getVariable220:

;-812 


;-813 int getCodeSize() {
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC

;-814     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize221

;-815         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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

;-816         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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

;-817         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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

;-818     }

.getCodeSize224:

;-819     return 0;

.getCodeSize221:
 mov ax, 0
 jmp .retngetCodeSize

;-820 }


;-821 int isToken(char c) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

isToken: PROC

;-822     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   821 NULL c = bp+4;
 ENTER  0,0
 call skipBlank

;-823     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken225

;-824         InputPtr++;

 inc  word[InputPtr]

;-825         return 1;

 mov ax, 1
 jmp .retnisToken

;-826         }


;-827     return 0;

.isToken225:
 mov ax, 0
 jmp .retnisToken

;-828 }


;-829 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-830     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   829 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need226

;-831         getTokeType();

 call getTokeType

;-832         return;

 jmp .retnneed

;-833         }


;-834     error1();

.need226:
 call error1

;-835     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-836     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-837 }


;-838 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-839     getTokeType();

 call getTokeType

;-840     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest227
 push skipRest_0
 call error1
 add  sp, 2

;-841 }

.skipRest227:

;-842 


;-843 


;-844 


;-845 int getarg() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

getarg: PROC

;-846     int arglen1; int i; char *c;


;-847     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var sign word   846 NULL arglen1 = bp-2
;  201 var sign word   846 NULL i = bp-4
;  202 ptr sign byte   846 NULL c = bp-6;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-848     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg228

;-849         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-850         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-851         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-852     }


;-853     i=arglen1+129;

.getarg228:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-854     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-855     arglen1--;

 dec  word[bp-2]

;-856     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-857 


;-858     strcpy(namein, argv); strcat1(namein, ".S");

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

;-859     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-860     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-861 


;-862   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-863 


;-864     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-865     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

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

;-866     lst_fd=creatR(namelst);

.getarg229:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-867     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

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

;-868     bin_fd=creatR(namebin);

.getarg230:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-869     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

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

;-870 


;-871     prs(";");

.getarg231:
 push getarg_7
 call prs
 add  sp, 2

;-872     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-873     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-874     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-875     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-876     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-877 }


;-878 


;-879 int fixJmp() {   
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

;-880     //todo ENDP: search backwards until tmpJmpMaxIx    


;-881     unsigned int hex; int i;


;-882     char *p; int Ix; char c;


;-883     if (isInProc) i = tmpJmpMaxIx;

;Function : fixJmp, Number of local variables: 5
;   # type sign width addr used name   list of local variables
;  200 var unsg word   881 NULL hex = bp-2
;  201 var sign word   881 NULL i = bp-4
;  202 ptr sign byte   882 NULL p = bp-6
;  203 var sign word   882 NULL Ix = bp-8
;  204 var sign byte   882 NULL c = bp-10;
 ENTER  10,0
 mov al, [isInProc]
 or  al, al
 je .fixJmp232
 mov ax, [tmpJmpMaxIx]
 mov [bp-4], ax

;-884     else i = 1;//at the end look at all open jmp   

 jmp .fixJmp233
.fixJmp232:
 mov ax, 1
 mov [bp-4], ax

;-885     prs("\n;jmp to fix:");

.fixJmp233:
 push fixJmp_0
 call prs
 add  sp, 2

;-886     printIntU(JmpMaxIx);

 push word [JmpMaxIx]
 call printIntU
 add  sp, 2

;-887     p = &JmpNames;

 mov ax, JmpNames
 mov [bp-6], ax

;-888     while (i <= JmpMaxIx) {

.fixJmp234:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp235

;-889         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-890         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-891         p++;

 inc  word[bp-6]

;-892         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax

;-893 //prs("\nSymbol:"); prs(Symbol); prs(",from:");                                       


;-894 //printhex16(hex);//debug


;-895         


;-896         Ix=searchLabel();

 call searchLabel
 mov [bp-8], ax

;-897         if (Ix == 0) notfounderror();

 mov ax, [bp-8]
 cmp ax, 0
 jne .fixJmp236
 call notfounderror

;-898         disp = LabelAddr[Ix];   

.fixJmp236:
 mov bx, [bp-8]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-899         c = FileBin[hex];//look for 'A' push Absolute 

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-10], al

;-900 //prs(",=00/AA:["); printhex8a(c);


;-901 //prs("],Lab:"); printhex16(disp);


;-902         if (c != 0xAA) {

 mov al, [bp-10]
 cmp al, 170
 je  .fixJmp237

;-903             disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp-2]
 mov word [disp], ax

;-904             disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax

;-905             disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-906         }


;-907             FileBin[hex] = disp;//fix low byte

.fixJmp237:
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

 jmp .fixJmp234
.fixJmp235:

;-914 


;-915 int epilog() {
 LEAVE
 ret
fixJmp_0 db "\n;jmp to fix:",0
ENDP

epilog: PROC

;-916     unsigned int i; char c;     int j;


;-917     prs("\n Errors: ");

;Function : epilog, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word   916 NULL i = bp-2
;  201 var sign byte   916 NULL c = bp-4
;  202 var sign word   916 NULL j = bp-6;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-918     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-919     if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog238
 push epilog_1
 call prs
 add  sp, 2

;-920     prs(", Out: ");

.epilog238:
 push epilog_2
 call prs
 add  sp, 2

;-921     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-922     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-923     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-924     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-925     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-926     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-927     prs(" Labels: ");

 push epilog_6
 call prs
 add  sp, 2

;-928     printIntU(LabelMaxIx);

 push word [LabelMaxIx]
 call printIntU
 add  sp, 2

;-929 // prs(", code:\n ");//debug


;-930 


;-931     i=0;

 mov ax, 0
 mov [bp-2], ax

;-932     do {

.epilog239:

;-933         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-934         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-935 // printhex8a(c); prc(' ');//debug


;-936         i++;

 inc  word[bp-2]

;-937     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog240
 jmp .epilog239
.epilog240:

;-938 


;-939 /* 


;-940   prs("\n\n LabelNamePtr:"); printIntU(LabelNamePtr);


;-941   i= &LabelNames;


;-942   prs(" &LabelNames:"); printIntU(i);


;-943   i=LabelNamePtr-i;


;-944   prs(", size: ");


;-945   printIntU(i);


;-946   prs(".\n >>");


;-947   i= &LabelNames;


;-948   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-949   } while (i < LabelNamePtr); prs("<< \n");


;-950    i = 1;


;-951     LabelNamePtr= &LabelNames;


;-952     do {


;-953       prs(LabelNamePtr); prc(' ');


;-954       j=LabelAddr[i]; printhex16(j); prs(", ");


;-955       j=strlen(LabelNamePtr);//get end of actual name


;-956       LabelNamePtr=LabelNamePtr+j;


;-957       LabelNamePtr++;


;-958       i++;


;-959     } while (i <= LabelMaxIx);


;-960 */


;-961 }


;-962 


;-963 int end1(int n) {
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

;-964     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   963 NULL n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-965     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-966     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-967     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-968 }


;-969 


;-970 


;-971 //#include "GENCODE.C"


;-972 // generate code


;-973 int getCodes() {
 LEAVE
 ret
ENDP

getCodes: PROC

;-974     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-975     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-976     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-977 }


;-978 int gen66h() {genCode8(0x66);

 ret
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-979 }


;-980 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-981     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   980 NULL c = bp+4
;  201 var sign byte   980 NULL d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-982     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-983 }


;-984 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-985     c = c + wflag;

;Function : genCodeW, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   984 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-986     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-987 }


;-988 int genCode8(char c) {
 LEAVE
 ret
ENDP

genCode8: PROC

;-989 //set: BinLen++, OpPrintIndex++


;-990     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   988 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-991     BinLen++;

 inc  word[BinLen]

;-992     PC++;

 inc  word[PC]

;-993     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 17000 ;unsigned : 0
 jb  .genCode8241
 push genCode8_0
 call errorexit
 add  sp, 2

;-994     if (OpPrintIndex < OPMAXLEN) {

.genCode8241:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8242

;-995         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-996         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-997     }


;-998 }

.genCode8242:

;-999 int genCode16(unsigned int i) {
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

genCode16: PROC

;-1000     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   999 NULL i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-1001     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-1002 }


;-1003 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-1004     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg dwrd  1003 NULL L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-1005     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-1006 }


;-1007 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-1008 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-1009 //mod-bits: mode76, reg/opcode543, r/m210


;-1010 //Op: 0, IMM, REG, ADR, MEM


;-1011     char len;


;-1012     len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1007 NULL xxx = bp+4
;  201 var sign byte  1011 NULL len = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-1013     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-1014     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA243

;-1015         xxx |= 0xC0;

 or  byte[bp+4], 192

;-1016         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA244
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1017             else {

 jmp .writeEA245
.writeEA244:

;-1018                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA246
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1019                 else            xxx = xxx + R2No;

 jmp .writeEA247
.writeEA246:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-1020             }

.writeEA247:

;-1021         }

.writeEA245:

;-1022     if (Op == MEM) {

.writeEA243:
 mov al, [Op]
 cmp al, 4
 jne .writeEA248

;-1023         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA249

;-1024             xxx |= 6;

 or  byte[bp+4], 6

;-1025             len = 2;

 mov ax, 2
 mov [bp-2], al

;-1026         }


;-1027         else {

 jmp .writeEA250
.writeEA249:

;-1028             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-1029             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA251

;-1030                 len=1;

 mov ax, 1
 mov [bp-2], al

;-1031                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA252
 or  byte[bp+4], 64

;-1032             }

.writeEA252:

;-1033 


;-1034             if (disp) {

.writeEA251:
 mov ax, [disp]
 or  al, al
 je .writeEA253

;-1035                 ax = disp;

 mov  ax, [disp]

;-1036                 if(ax > 127) len=2;

 cmp  ax, 127
 jle .writeEA254
 mov ax, 2
 mov [bp-2], al

;-1037                 else len=1;

 jmp .writeEA255
.writeEA254:
 mov ax, 1
 mov [bp-2], al

;-1038                 if (len == 1) xxx |= 0x40;

.writeEA255:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA256
 or  byte[bp+4], 64

;-1039                 else xxx |= 0x80;

 jmp .writeEA257
.writeEA256:
 or  byte[bp+4], 128

;-1040             }

.writeEA257:

;-1041         }

.writeEA253:

;-1042     }

.writeEA250:

;-1043 


;-1044     genCode8(xxx);// gen second byte

.writeEA248:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1045     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA258
 push word [disp]
 call genCode8
 add  sp, 2

;-1046     if (len == 2) genCode16(disp);

.writeEA258:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA259
 push word [disp]
 call genCode16
 add  sp, 2

;-1047 }

.writeEA259:

;-1048 


;-1049 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-1050     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long

 mov al, [wflag]
 or  al, al
 je .genImmediate260
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate261
 push word [imme]
 call genCode32
 add  sp, 2

;-1051         else genCode16(imme);

 jmp .genImmediate262
.genImmediate261:
 push word [imme]
 call genCode16
 add  sp, 2

;-1052     else       genCode8 (imme);

.genImmediate262:
 jmp .genImmediate263
.genImmediate260:
 push word [imme]
 call genCode8
 add  sp, 2

;-1053 }

.genImmediate263:

;-1054 


;-1055 //AS.C


;-1056 int process() {

 ret
ENDP

process: PROC

;-1057     char c;


;-1058     int i;


;-1059     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1057 NULL c = bp-2
;  201 var sign word  1058 NULL i = bp-4;
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

;-1060     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-1061     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-1062     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-1063     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-1064     getCodes();//set: Code1, Code2, Code3

 call getCodes

;-1065 


;-1066     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process264

;-1067         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1068         return;

 jmp .retnprocess

;-1069     }


;-1070 


;-1071     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process264:
 mov al, [CodeType]
 cmp al, 2
 jne .process265

;-1072         getOpL();

 call getOpL

;-1073         checkOpL();

 call checkOpL

;-1074         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  .process266

;-1075   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process267

;-1076                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je .process268
 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
 jmp .retnprocess

;-1077             }

.process268:

;-1078         }

.process267:

;-1079         if (Code2 == 5) {//imul extension?

.process266:
 mov al, [Code2]
 cmp al, 5
 jne .process269

;-1080             getTokeType();

 call getTokeType

;-1081             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process270
 call implerror

;-1082         }

.process270:

;-1083         genCodeW(Code1);

.process269:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1084         writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1085         return;

 jmp .retnprocess

;-1086     }


;-1087 


;-1088     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process265:
 mov al, [CodeType]
 cmp al, 3
 jne .process271

;-1089         check2Ops();    //setwflag not applicable

 call check2Ops

;-1090         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process272
 call reg16error

;-1091         if (Op2 != MEM) addrerror();//only m16

.process272:
 mov al, [Op2]
 cmp al, 4
 je  .process273
 call addrerror

;-1092 


;-1093         genCode8(Code1);//les,lds,lea

.process273:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1094         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 15
 jne .process274
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1095         Op=Op2;//set MEM for writeEA

.process274:
 mov al, [Op2]
 mov byte [Op], al

;-1096         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1097         return;

 jmp .retnprocess

;-1098     }


;-1099 


;-1100     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process271:
 mov al, [CodeType]
 cmp al, 4
 jne .process275

;-1101         check2Ops();

 call check2Ops

;-1102         if (Op2 == IMM) {//second operand is imm

 mov al, [Op2]
 cmp al, 1
 jne .process276

;-1103             setsflag();

 call setsflag

;-1104             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process277

;-1105                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process278

;-1106                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process279

;-1107                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1108                         c += 4;

 add  byte[bp-2], 4

;-1109                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1110                         genImmediate();

 call genImmediate

;-1111                         return;

 jmp .retnprocess

;-1112                     }


;-1113                 }

.process279:

;-1114             }

.process278:

;-1115             //r/m, imm: 80 sign-extended,TTT,imm


;-1116             c = sflag + 0x80;

.process277:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1117             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1118             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1119             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process280
 push word [imme]
 call genCode8
 add  sp, 2

;-1120             else genImmediate();

 jmp .process281
.process280:
 call genImmediate

;-1121             return;

.process281:
 jmp .retnprocess

;-1122         }


;-1123         c = Code1 << 3;//r/m, r/r

.process276:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1124         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process282

;-1125             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process283

;-1126                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1127                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1128                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1129                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1130                 return;

 jmp .retnprocess

;-1131             }


;-1132         }

.process283:

;-1133         if (Op2 == REG) {//mem,reg    reg,reg

.process282:
 mov al, [Op2]
 cmp al, 2
 jne .process284

;-1134             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1135             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1136             return;

 jmp .retnprocess

;-1137         }


;-1138         syntaxerror();

.process284:
 call syntaxerror

;-1139         return;

 jmp .retnprocess

;-1140     }


;-1141 


;-1142     if (CodeType == 5) {//mov (movsx, movzx=51)

.process275:
 mov al, [CodeType]
 cmp al, 5
 jne .process285

;-1143         check2Ops();

 call check2Ops

;-1144 /*    prs("\n Op:"); printhex8a(Op);


;-1145     prs(", Op2:"); printhex8a(Op2);


;-1146     prs(", R1No:"); printhex8a(R1No);


;-1147     prs(", R2No:"); printhex8a(R2No);   */


;-1148         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process286

;-1149             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process287
 mov ax, [disp]
 mov word [imme], ax

;-1150             else notfounderror();

 jmp .process288
.process287:
 call notfounderror

;-1151             Op2=IMM;//continue with IMM

.process288:
 mov ax, 1
 mov byte [Op2], al

;-1152         }


;-1153         if (Op2 == IMM) {// r,i

.process286:
 mov al, [Op2]
 cmp al, 1
 jne .process289

;-1154             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process290

;-1155                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1156                 c += 0xB0;

 add  byte[bp-2], 176

;-1157                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1158                 genImmediate();

 call genImmediate

;-1159                 return;

 jmp .retnprocess

;-1160             }


;-1161             if (Op == MEM) {// m,i

.process290:
 mov al, [Op]
 cmp al, 4
 jne .process291

;-1162                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1163                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1164                 genImmediate();

 call genImmediate

;-1165                 return;

 jmp .retnprocess

;-1166             }


;-1167             regmemerror();

.process291:
 call regmemerror

;-1168             return;

 jmp .retnprocess

;-1169         }


;-1170         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process289:
 mov al, [R1Type]
 cmp al, 4
 jne .process292
 call ChangeDirection

;-1171         if (R2Type == SEGREG) {//rm,sreg

.process292:
 mov al, [R2Type]
 cmp al, 4
 jne .process293

;-1172             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process294
 call reg16error

;-1173                 genCode2(0x8C, dflag);

.process294:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1174                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1175                 return;

 jmp .retnprocess

;-1176         }


;-1177         if (Op2 == MEM) {//acc, moffs16

.process293:
 mov al, [Op2]
 cmp al, 4
 jne .process295

;-1178             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process296

;-1179                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process297

;-1180                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process298

;-1181                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1182                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1183                         return;

 jmp .retnprocess

;-1184                     }


;-1185                 }

.process298:

;-1186             }

.process297:

;-1187         }

.process296:

;-1188         if (Op == MEM) {//moffs16, acc

.process295:
 mov al, [Op]
 cmp al, 4
 jne .process299

;-1189             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process300

;-1190                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process301

;-1191                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process302

;-1192                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1193                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1194                         return;

 jmp .retnprocess

;-1195                     }


;-1196                 }

.process302:

;-1197             }

.process301:

;-1198 


;-1199         }

.process300:

;-1200         if (Op2 == REG) {//rm, r

.process299:
 mov al, [Op2]
 cmp al, 2
 jne .process303

;-1201             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1202             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1203             return;

 jmp .retnprocess

;-1204         }


;-1205         if (Op2 == MEM) {//r, m

.process303:
 mov al, [Op2]
 cmp al, 4
 jne .process304

;-1206             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process305

;-1207                 ChangeDirection();

 call ChangeDirection

;-1208                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1209                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1210                 return;

 jmp .retnprocess

;-1211             }


;-1212         }

.process305:

;-1213         syntaxerror();

.process304:
 call syntaxerror

;-1214         return;

 jmp .retnprocess

;-1215     }


;-1216 


;-1217     if (CodeType == 6) {//Jcc

.process285:
 mov al, [CodeType]
 cmp al, 6
 jne .process306

;-1218         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process307

;-1219             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1220             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process308

;-1221                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1222                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1223                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1224                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process309

;-1225                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1226                     disp -= 2;

 sub  word[disp], 2

;-1227                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1228                 } else {

 jmp .process310
.process309:

;-1229                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1230                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1231                     disp -= 4;

 sub  word[disp], 4

;-1232                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1233                 }


;-1234             }

.process310:

;-1235             else {//jump forward, near only

 jmp .process311
.process308:

;-1236                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1237                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1238                 storeJmp();

 call storeJmp

;-1239                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1240                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1241             }


;-1242         return;

.process311:
 jmp .retnprocess

;-1243         }


;-1244     }

.process307:

;-1245 


;-1246     if (CodeType == 7) {//jmp, call

.process306:
 mov al, [CodeType]
 cmp al, 7
 jne .process312

;-1247         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process313

;-1248             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1249             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process314

;-1250                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1251                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1252                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1253                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process315

;-1254                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process316

;-1255                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1256                         disp -= 2;

 sub  word[disp], 2

;-1257                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1258                     }


;-1259                     else {

 jmp .process317
.process316:

;-1260                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1261                         disp -= 3;

 sub  word[disp], 3

;-1262                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1263                     }


;-1264                 }

.process317:

;-1265                 else {

 jmp .process318
.process315:

;-1266                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1267                     disp -= 3;

 sub  word[disp], 3

;-1268                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1269                 }


;-1270             }

.process318:

;-1271             else {//jump forward, near only

 jmp .process319
.process314:

;-1272                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1273                 storeJmp();

 call storeJmp

;-1274                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1275                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1276             }


;-1277         return;

.process319:
 jmp .retnprocess

;-1278         }


;-1279     }

.process313:

;-1280 


;-1281     if (CodeType ==  8) {//ret,retf

.process312:
 mov al, [CodeType]
 cmp al, 8
 jne .process320

;-1282         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process321

;-1283             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1284             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1285             return;

 jmp .retnprocess

;-1286         }


;-1287         genCode8(Code1);

.process321:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1288         return;

 jmp .retnprocess

;-1289     }


;-1290 


;-1291     if (CodeType == 9) {//push, pop

.process320:
 mov al, [CodeType]
 cmp al, 9
 jne .process322

;-1292         getOpL();

 call getOpL

;-1293         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process323

;-1294             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process324

;-1295                 setsflag();

 call setsflag

;-1296                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1297                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process325
 push word [imme]
 call genCode8
 add  sp, 2

;-1298                 else       genCode16(imme);

 jmp .process326
.process325:
 push word [imme]
 call genCode16
 add  sp, 2

;-1299                 return;

.process326:
 jmp .retnprocess

;-1300             }


;-1301             if (Op == ADR) {//push string ABSOLUTE i16 

.process324:
 mov al, [Op]
 cmp al, 3
 jne .process327

;-1302 //prscomment("\n push disp: "); printhex16 (disp);


;-1303                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process328

;-1304                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1305                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1306                     return;

 jmp .retnprocess

;-1307                 }


;-1308                 else {

 jmp .process329
.process328:

;-1309                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1310                     storeJmp();

 call storeJmp

;-1311                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2

;-1312                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al

;-1313                     return;

 jmp .retnprocess

;-1314                 }


;-1315             }

.process329:

;-1316         }

.process327:

;-1317         if (R1Type == SEGREG) {

.process323:
 mov al, [R1Type]
 cmp al, 4
 jne .process330

;-1318             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process331

;-1319                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process332
 push process_0
 call error1
 add  sp, 2

;-1320             }

.process332:

;-1321             c = R1No <<3;

.process331:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1322             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process333

;-1323                 c += 122;

 add  byte[bp-2], 122

;-1324                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1325             }


;-1326             OpCodePtr++;

.process333:
 inc  word[OpCodePtr]

;-1327             c = c + *OpCodePtr;////////////////is Code4

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov [bp-2], al

;-1328             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1329             return;

 jmp .retnprocess

;-1330         }


;-1331         checkOpL();//no ADR, SEGREG

.process330:
 call checkOpL

;-1332         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne .process334
 call reg16error

;-1333         if (R1Type == WORD) {

.process334:
 mov al, [R1Type]
 cmp al, 2
 jne .process335

;-1334             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1335             return;

 jmp .retnprocess

;-1336         }


;-1337         if (Op == MEM) {

.process335:
 mov al, [Op]
 cmp al, 4
 jne .process336

;-1338             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1339             writeEA(Code3);//////////////////Code3

 mov al, byte [Code3]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1340             return;

 jmp .retnprocess

;-1341         }


;-1342         syntaxerror();

.process336:
 call syntaxerror

;-1343         return;

 jmp .retnprocess

;-1344     }


;-1345 


;-1346     if (CodeType == 11) {//shift, rotate

.process322:
 mov al, [CodeType]
 cmp al, 11
 jne .process337

;-1347         check2Ops();

 call check2Ops

;-1348         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process338

;-1349             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process339

;-1350                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1351                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1352                 return;

 jmp .retnprocess

;-1353             }


;-1354             genCodeW(0xC0);//80186

.process339:
 push 192
 call genCodeW
 add  sp, 2

;-1355             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1356             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1357             return;

 jmp .retnprocess

;-1358         }


;-1359         if (Op2 == REG) {

.process338:
 mov al, [Op2]
 cmp al, 2
 jne .process340

;-1360             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process341

;-1361                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process342

;-1362                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process343
 mov ax, 1
 mov byte [wflag], al

;-1363                     genCodeW(0xD2);

.process343:
 push 210
 call genCodeW
 add  sp, 2

;-1364                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1365                     return;

 jmp .retnprocess

;-1366                 }


;-1367             }

.process342:

;-1368         }

.process341:

;-1369     }

.process340:

;-1370 


;-1371     if (CodeType == 12) {//int

.process337:
 mov al, [CodeType]
 cmp al, 12
 jne .process344

;-1372         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process345

;-1373             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1374             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1375             return;

 jmp .retnprocess

;-1376         }


;-1377     }

.process345:

;-1378 


;-1379     if (CodeType == 30) {//enter i18,i8

.process344:
 mov al, [CodeType]
 cmp al, 30
 jne .process346

;-1380         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1381         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1382         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process347
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1383         else numbererror();

 jmp .process348
.process347:
 call numbererror

;-1384         need(',');

.process348:
 push 44
 call need
 add  sp, 2

;-1385         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1386         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process349
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1387         else numbererror();

 jmp .process350
.process349:
 call numbererror

;-1388         return;

.process350:
 jmp .retnprocess

;-1389     }


;-1390 


;-1391     if (CodeType==101) {//ORG nn

.process346:
 mov al, [CodeType]
 cmp al, 101
 jne .process351

;-1392         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process352
 call numbererror

;-1393         Origin=SymbolInt;

.process352:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1394         return;

 jmp .retnprocess

;-1395     }


;-1396 


;-1397     if (CodeType == 102) {//section, segment

.process351:
 mov al, [CodeType]
 cmp al, 102
 jne .process353

;-1398         //getTokeType();//ignore .bss .text .data


;-1399         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1400         return;

 jmp .retnprocess

;-1401     }


;-1402 


;-1403     if (CodeType == 110) {//absolute

.process353:
 mov al, [CodeType]
 cmp al, 110
 jne .process354

;-1404         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process355
 call numbererror

;-1405         AbsoluteLab=SymbolInt;

.process355:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1406         return;

 jmp .retnprocess

;-1407     }


;-1408     if (CodeType == 111) {//name: PROC

.process354:
 mov al, [CodeType]
 cmp al, 111
 jne .process356

;-1409         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process357

;-1410             prs("\n;entering: ");

 push process_1
 call prs
 add  sp, 2

;-1411             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1412             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1413             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax

;-1414             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax

;-1415             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax

;-1416             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax

;-1417         } else error1("already in PROC");

 jmp .process358
.process357:
 push process_2
 call error1
 add  sp, 2

;-1418         return;

.process358:
 jmp .retnprocess

;-1419     }


;-1420     if (CodeType == 112) {//ENDP 

.process356:
 mov al, [CodeType]
 cmp al, 112
 jne .process359

;-1421         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process360
 push process_3
 call error1
 add  sp, 2

;-1422         prs("\n;leaving: ");

.process360:
 push process_4
 call prs
 add  sp, 2

;-1423         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1424         prs(". loc labels:");

 push process_5
 call prs
 add  sp, 2

;-1425         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax

;-1426         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1427         prs(",loc jmp forward:");

 push process_6
 call prs
 add  sp, 2

;-1428         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax

;-1429         printIntU(i);        

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1430         fixJmp();

 call fixJmp

;-1431         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1432         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax

;-1433         LabelMaxIx   = tmpLabelMaxIx;                       

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax

;-1434         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax

;-1435         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax

;-1436         return;

 jmp .retnprocess

;-1437     }


;-1438     error1("Command not implemented or syntax error");

.process359:
 push process_7
 call error1
 add  sp, 2

;-1439 }


;-1440 


;-1441 int main() {

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

;-1442     getarg();

 call getarg

;-1443     parse();

 call parse

;-1444     fixJmp();

 call fixJmp

;-1445     epilog();

 call epilog

;-1446     end1();

 call end1

;-1447 }

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
;    3 arr sign byte     4   13 Symbol[31]
;    4 arr sign byte     5   36 SymbolUpper[31]
;    5 arr sign byte     6    3 ProcName[31]
;    6 var sign byte     7    7 isInProc
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
;   22 var unsg word    24    7 PC
;   23 var unsg word    25    5 Origin
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
;   56 var sign word    58   54 disp
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
;   68 arr unsg word    73    7 LabelAddr[600]
;   69 var sign word    74   10 LabelMaxIx
;   70 var sign word    75    3 tmpLabelMaxIx
;   71 var sign word    76   11 LabelIx
;   72 def unsg byte    78    - JMPNAMESMAX=3969
;   73 arr sign byte    79    3 JmpNames[4000]
;   74 ptr sign byte    80    7 JmpNamePtr
;   75 ptr sign byte    81    2 tmpJmpNamePtr
;   76 def unsg byte    83    - JMPMAX=200
;   77 arr unsg word    84    2 JmpAddr[200]
;   78 var sign word    85    9 JmpMaxIx
;   79 var sign word    86    4 tmpJmpMaxIx
;   80 def unsg byte    88    - FILEBINMAX=17000
;   81 arr sign byte    89    5 FileBin[17000]
;   82 var unsg word    90    6 BinLen
;   83 ptr sign byte    92    1 arglen
;   84 ptr sign byte    93    4 argv
;   85 var sign byte   393    1 I_START
;   86 arr sign byte   396 NULL I_PUSHA[8125]
;   87 arr sign byte   397 NULL I_NOP[24260]
;   88 arr sign byte   398 NULL I_CWDE[9734]
;   89 arr sign byte   399 NULL I_CDQ[1931]
;   90 arr sign byte   400 NULL I_PUSHF[35622]
;   91 arr sign byte   401 NULL I_SAHF[599]
;   92 arr sign byte   402 NULL I_MOVSB[53495]
;   93 arr sign byte   403 NULL I_CMPSB[54007]
;   94 arr sign byte   404 NULL I_STOSB[37]
;   95 arr sign byte   405 NULL I_LODSB[33600]
;   96 arr sign byte   406 NULL I_SCASB[8418]
;   97 arr sign byte   407 NULL I_LEAVE[53259]
;   98 arr sign byte   408 NULL I_INTO[12917]
;   99 arr sign byte   409 NULL I_XLAT[35622]
;  100 arr sign byte   410 NULL I_REPNE[2119]
;  101 arr sign byte   411 NULL I_REPE[18057]
;  102 arr sign byte   412 NULL I_HLT[9982]
;  103 arr sign byte   413 NULL I_STC[18315]
;  104 arr sign byte   414 NULL I_STI[9734]
;  105 arr sign byte   415 NULL I_STD[32643]
;  106 arr sign byte   417 NULL I_INC[10]
;  107 arr sign byte   418 NULL I_DEC[1397]
;  108 arr sign byte   419 NULL I_NOT[18119]
;  109 arr sign byte   420 NULL I_NEG[65534]
;  110 arr sign byte   421 NULL I_MUL[33791]
;  111 arr sign byte   422 NULL I_IMUL[65150]
;  112 arr sign byte   423 NULL I_DIV[30207]
;  113 arr sign byte   424 NULL I_IDIV[15642]
;  114 arr sign byte   426 NULL I_LES[65535]
;  115 arr sign byte   427 NULL I_LDS[5493]
;  116 arr sign byte   428 NULL I_LEA[33574]
;  117 arr sign byte   429 NULL I_LSS[1151]
;  118 arr sign byte   430 NULL I_LFS[29696]
;  119 arr sign byte   431 NULL I_LGS[35593]
;  120 arr sign byte   433 NULL I_ADD[2630]
;  121 arr sign byte   434 NULL I_OR[14630]
;  122 arr sign byte   435 NULL I_ADC[1095]
;  123 arr sign byte   436 NULL I_SBB[26997]
;  124 arr sign byte   437 NULL I_AND[49203]
;  125 arr sign byte   438 NULL I_SUB[52169]
;  126 arr sign byte   439 NULL I_XOR[33680]
;  127 arr sign byte   440 NULL I_CMP[65150]
;  128 arr sign byte   441 NULL I_TEST[29729]
;  129 arr sign byte   443 NULL I_MOV[33618]
;  130 arr sign byte   444 NULL I_MOVSX[65150]
;  131 arr sign byte   445 NULL I_MOVZX[29731]
;  132 arr sign byte   447 NULL I_JO[33612]
;  133 arr sign byte   448 NULL I_JNO[65150]
;  134 arr sign byte   449 NULL I_JB[29732]
;  135 arr sign byte   450 NULL I_JNB[33606]
;  136 arr sign byte   451 NULL I_JAE[65150]
;  137 arr sign byte   452 NULL I_JE[29734]
;  138 arr sign byte   453 NULL I_JNE[33600]
;  139 arr sign byte   454 NULL I_JBE[65150]
;  140 arr sign byte   455 NULL I_JA[29730]
;  141 arr sign byte   456 NULL I_JS[33594]
;  142 arr sign byte   457 NULL I_JNS[65150]
;  143 arr sign byte   458 NULL I_JP[29737]
;  144 arr sign byte   459 NULL I_JNP[33588]
;  145 arr sign byte   460 NULL I_JL[65150]
;  146 arr sign byte   461 NULL I_JNL[29736]
;  147 arr sign byte   462 NULL I_JLE[33582]
;  148 arr sign byte   463 NULL I_JG[65150]
;  149 arr sign byte   465 NULL I_JMP[29733]
;  150 arr sign byte   466 NULL I_CALL[15656]
;  151 arr sign byte   468 NULL I_RET[33]
;  152 arr sign byte   469 NULL I_RETF[9076]
;  153 arr sign byte   471 NULL I_PUSH[9021]
;  154 arr sign byte   472 NULL I_POP[29696]
;  155 arr sign byte   474 NULL I_ROL[15646]
;  156 arr sign byte   475 NULL I_RCL[36]
;  157 arr sign byte   476 NULL I_SHL[6516]
;  158 arr sign byte   477 NULL I_SHR[9789]
;  159 arr sign byte   479 NULL I_INT[29696]
;  160 arr sign byte   481 NULL I_IN[15636]
;  161 arr sign byte   482 NULL I_INSB[34]
;  162 arr sign byte   483 NULL I_INSW[3956]
;  163 arr sign byte   484 NULL I_INSD[10557]
;  164 arr sign byte   485 NULL I_OUT[29696]
;  165 arr sign byte   486 NULL I_OUTSB[15626]
;  166 arr sign byte   487 NULL I_OUTSW[40]
;  167 arr sign byte   488 NULL I_OUTSD[1396]
;  168 arr sign byte   490 NULL I_XCHG[9533]
;  169 arr sign byte   492 NULL I_LOOPNZ[29952]
;  170 arr sign byte   493 NULL I_LOOPNE[33542]
;  171 arr sign byte   494 NULL I_LOOPZ[2686]
;  172 arr sign byte   495 NULL I_LOOPE[60176]
;  173 arr sign byte   496 NULL I_LOOP[33540]
;  174 arr sign byte   497 NULL I_JCXZ[2686]
;  175 arr sign byte   498 NULL I_JECXZ[29984]
;  176 arr sign byte   500 NULL I_ENTER[47255]
;  177 arr sign byte   502 NULL I_ORG[1]
;  178 arr sign byte   504 NULL I_SECTION[52169]
;  179 arr sign byte   505 NULL I_SEGMENT[21904]
;  180 arr sign byte   506 NULL I_ABSOLUTE[60555]
;  181 arr sign byte   507 NULL I_PROC[5816]
;  182 arr sign byte   508 NULL I_ENDP[39424]
;  183 arr sign byte   509 NULL I_DB[674]
;  184 arr sign byte   510 NULL I_DW[8125]
;  185 arr sign byte   511 NULL I_DD[51030]
;  186 arr sign byte   512 NULL I_RESB[65094]
;  187 arr sign byte   513 NULL I_RESW[0]
;  188 arr sign byte   514 NULL I_RESD[1678]
;  189 var sign byte   515 NULL I_END


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
;   17    9  169   strcpy
;   18   35  175   eqstr
;   19    3  184   strcat1
;   20    2  188   toupper
;   21    1  195   getDigit
;   22    1  207   getName
;   23    1  226   testReg
;   24    1  270   printLine
;   25    7  292   prc
;   26    1  302   prscomment
;   27   35  310   prs
;   28    3  332   printhex8a
;   29    2  337   printhex4
;   30    1  342   printhex16
;   31    7  347   printIntU
;   32   26  358   error1
;   33   13  365   errorexit
;   34    3  370   notfounderror
;   35 NULL  375   allowederror
;   36    3  376   addrerror
;   37    1  377   immeerror
;   38    2  378   implerror
;   39    4  379   indexerror
;   40    3  380   invaloperror
;   41    6  381   numbererror
;   42    1  382   regmemerror
;   43    3  383   reg16error
;   44    1  384   segregerror
;   45    5  385   syntaxerror
;   46 NULL  387   addrexit
;   47    3  388   dataexit
;   48 NULL  389   internexit
;   49    2  517   lookCode
;   50    2  534   ChangeDirection
;   51    2  542   checkOpL
;   52    4  551   check2Ops
;   53    1  560   get2Ops
;   54    3  566   getOpL
;   55    2  574   getOpR
;   56    4  587   getOp1
;   57    1  604   getMEM
;   58    1  630   getIndReg1
;   59    1  638   getIndReg2
;   60    2  648   setwflag
;   61    2  659   setsflag
;   62    2  669   checkConstSize
;   63    1  677   parse
;   64   16  713   getTokeType
;   65    3  724   storeJmp
;   66    2  735   storeLabel
;   67    5  747   searchLabel
;   68    1  760   getVariable
;   69    1  813   getCodeSize
;   70    9  821   isToken
;   71    2  829   need
;   72    1  838   skipRest
;   73    1  845   getarg
;   74    2  879   fixJmp
;   75    2  915   epilog
;   76    2  963   end1
;   77    1  973   getCodes
;   78    1  978   gen66h
;   79    8  980   genCode2
;   80   13  984   genCodeW
;   81   35  988   genCode8
;   82   19  999   genCode16
;   83    1 1003   genCode32
;   84   13 1007   writeEA
;   85    4 1049   genImmediate
;   86    1 1056   process
;   87 NULL 1441   main
;   88 NULL 1447   LastFunctionByt

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
;   84   558 error1
;   85   565 error1
;   86   572 error1
;   87   579 error1
;   88   586 error1
;   89   593 error1
;   90   600 error1
;   91   607 error1
;   92   614 error1
;   93   621 error1
;   94   628 error1
;   95   635 errorexit
;   96   645 errorexit
;   97   655 errorexit
;   98   665 eqstr
;   99   671 implerror
;  100   681 segregerror
;  101   693 setwflag
;  102   702 error1
;  103   709 error1
;  104   716 get2Ops
;  105   724 addrerror
;  106   734 invaloperror
;  107   747 immeerror
;  108   757 addrerror
;  109   767 invaloperror
;  110   780 setwflag
;  111   789 getOpL
;  112   796 need
;  113   801 getOpR
;  114   808 getOpR
;  115   815 getOp1
;  116   822 isToken
;  117   830 getMEM
;  118   837 invaloperror
;  119   850 error1
;  120   857 testReg
;  121   865 searchLabel
;  122   877 getTokeType
;  123   889 getOp1
;  124   896 syntaxerror
;  125   908 getIndReg2
;  126   919 getIndReg1
;  127   930 notfounderror
;  128   944 isToken
;  129   952 getTokeType
;  130   964 numbererror
;  131   976 isToken
;  132   984 isToken
;  133   992 errorexit
;  134  1002 indexerror
;  135  1013 indexerror
;  136  1024 indexerror
;  137  1035 indexerror
;  138  1046 gen66h
;  139  1053 error1
;  140  1060 getLine
;  141  1068 getTokeType
;  142  1080 strcpy
;  143  1087 storeLabel
;  144  1098 getTokeType
;  145  1110 lookCode
;  146  1119 process
;  147  1127 getVariable
;  148  1139 skipRest
;  149  1148 error1
;  150  1155 error1
;  151  1162 printLine
;  152  1172 skipBlank
;  153  1182 digit
;  154  1188 getDigit
;  155  1197 letterE
;  156  1205 getName
;  157  1213 errorexit
;  158  1223 strcpy
;  159  1230 errorexit
;  160  1240 searchLabel
;  161  1252 error1
;  162  1259 errorexit
;  163  1269 strcpy
;  164  1276 errorexit
;  165  1286 eqstr
;  166  1292 strlen
;  167  1299 storeLabel
;  168  1310 getTokeType
;  169  1322 lookCode
;  170  1331 dataexit
;  171  1340 dataexit
;  172  1349 getTokeType
;  173  1361 genCode8
;  174  1370 skipBlank
;  175  1380 isToken
;  176  1388 genCode8
;  177  1397 isToken
;  178  1405 getTokeType
;  179  1417 genCode16
;  180  1427 isToken
;  181  1435 getTokeType
;  182  1447 genCode16
;  183  1457 genCode16
;  184  1467 isToken
;  185  1475 getTokeType
;  186  1487 syntaxerror
;  187  1499 error1
;  188  1506 numbererror
;  189  1518 dataexit
;  190  1527 eqstr
;  191  1533 getTokeType
;  192  1545 eqstr
;  193  1551 getTokeType
;  194  1563 eqstr
;  195  1569 getTokeType
;  196  1581 skipBlank
;  197  1591 isToken
;  198  1599 getTokeType
;  199  1611 error1
;  200  1618 prs
;  201  1622 prc
;  202  1626 getTokeType
;  203  1638 error1
;  204  1645 cputs
;  205  1651 cputs
;  206  1657 exitR
;  207  1663 toupper
;  208  1671 strcpy
;  209  1678 strcat1
;  210  1686 strcpy
;  211  1693 strcat1
;  212  1701 strcpy
;  213  1708 strcat1
;  214  1716 openR
;  215  1722 cputs
;  216  1728 cputs
;  217  1734 exitR
;  218  1740 creatR
;  219  1747 cputs
;  220  1753 cputs
;  221  1759 exitR
;  222  1765 creatR
;  223  1772 cputs
;  224  1778 cputs
;  225  1784 exitR
;  226  1790 prs
;  227  1794 prs
;  228  1798 prs
;  229  1802 prs
;  230  1806 prs
;  231  1810 prs
;  232  1814 prs
;  233  1818 prs
;  234  1822 prs
;  235  1826 prs
;  236  1830 printIntU
;  237  1840 strcpy
;  238  1847 strlen
;  239  1854 searchLabel
;  240  1866 notfounderror
;  241  1880 prs
;  242  1884 printIntU
;  243  1894 prs
;  244  1898 prs
;  245  1902 prs
;  246  1906 prs
;  247  1910 prs
;  248  1914 prs
;  249  1918 printIntU
;  250  1928 prs
;  251  1932 prs
;  252  1936 printIntU
;  253  1946 fputcR
;  254  1953 fcloseR
;  255  1961 fcloseR
;  256  1969 fcloseR
;  257  1977 exitR
;  258  1983 genCode8
;  259  1992 genCode8
;  260  2001 genCode8
;  261  2010 errorexit
;  262  2020 genCode8
;  263  2029 genCode8
;  264  2038 genCode16
;  265  2048 genCode16
;  266  2058 genCode8
;  267  2067 genCode8
;  268  2076 genCode16
;  269  2086 genCode32
;  270  2096 genCode16
;  271  2106 genCode8
;  272  2115 getTokeType
;  273  2127 getCodeSize
;  274  2139 getCodes
;  275  2148 genCode8
;  276  2157 getOpL
;  277  2164 checkOpL
;  278  2173 genCode2
;  279  2182 getTokeType
;  280  2194 implerror
;  281  2204 genCodeW
;  282  2213 writeEA
;  283  2221 check2Ops
;  284  2231 reg16error
;  285  2242 addrerror
;  286  2252 genCode8
;  287  2261 genCode8
;  288  2270 writeEA
;  289  2278 check2Ops
;  290  2288 setsflag
;  291  2297 genCodeW
;  292  2306 genImmediate
;  293  2319 genCodeW
;  294  2328 writeEA
;  295  2336 genCode8
;  296  2345 genImmediate
;  297  2358 genCodeW
;  298  2367 writeEA
;  299  2375 genCodeW
;  300  2384 writeEA
;  301  2392 syntaxerror
;  302  2404 check2Ops
;  303  2414 notfounderror
;  304  2428 genCode2
;  305  2437 genImmediate
;  306  2450 genCodeW
;  307  2459 writeEA
;  308  2467 genImmediate
;  309  2480 regmemerror
;  310  2492 ChangeDirection
;  311  2508 reg16error
;  312  2519 genCode2
;  313  2528 writeEA
;  314  2536 genCodeW
;  315  2545 genCode16
;  316  2555 genCodeW
;  317  2564 genCode16
;  318  2574 genCodeW
;  319  2583 writeEA
;  320  2591 ChangeDirection
;  321  2607 genCodeW
;  322  2616 writeEA
;  323  2624 syntaxerror
;  324  2636 searchLabel
;  325  2648 checkConstSize
;  326  2663 genCode2
;  327  2672 genCode8
;  328  2681 genCode8
;  329  2690 genCode2
;  330  2699 genCode16
;  331  2709 genCode8
;  332  2718 genCode2
;  333  2727 storeJmp
;  334  2736 genCode16
;  335  2746 searchLabel
;  336  2758 checkConstSize
;  337  2773 genCode8
;  338  2782 genCode8
;  339  2791 genCode8
;  340  2800 genCode16
;  341  2810 genCode8
;  342  2819 genCode16
;  343  2829 genCode8
;  344  2838 storeJmp
;  345  2847 genCode16
;  346  2857 genCode8
;  347  2866 genCode16
;  348  2876 genCode8
;  349  2885 getOpL
;  350  2892 setsflag
;  351  2901 genCode2
;  352  2910 genCode8
;  353  2919 genCode16
;  354  2929 genCode8
;  355  2938 genCode16
;  356  2948 genCode8
;  357  2957 storeJmp
;  358  2966 genCode16
;  359  2976 error1
;  360  2983 genCode8
;  361  2992 genCode8
;  362  3001 checkOpL
;  363  3010 reg16error
;  364  3021 genCode2
;  365  3030 genCode8
;  366  3039 writeEA
;  367  3047 syntaxerror
;  368  3059 check2Ops
;  369  3069 genCodeW
;  370  3078 writeEA
;  371  3086 genCodeW
;  372  3095 writeEA
;  373  3103 genCode8
;  374  3112 genCodeW
;  375  3121 writeEA
;  376  3129 genCode8
;  377  3138 genCode8
;  378  3147 genCode8
;  379  3156 getOp1
;  380  3163 genCode16
;  381  3173 numbererror
;  382  3185 need
;  383  3190 getOp1
;  384  3197 genCode8
;  385  3206 numbererror
;  386  3218 numbererror
;  387  3230 numbererror
;  388  3242 prs
;  389  3246 prs
;  390  3250 error1
;  391  3257 error1
;  392  3264 prs
;  393  3268 prs
;  394  3272 prs
;  395  3276 printIntU
;  396  3286 prs
;  397  3290 printIntU
;  398  3300 fixJmp
;  399  3307 error1
;  400  3314 getarg
;  401  3321 parse
;  402  3327 fixJmp
;  403  3334 epilog
;  404  3341 end1
;Input: AS.C, List: AS.S,  Lines: 1448
;Glob. variables:  189 max.:  200
;Functions      :   89 max.:  300
;Calls          :  405 max.: 2000, NameField: 3346 max.:    65535
;Code until     :21667 max.: 30000, free: 8333
;Data (HeapEnd) :59154, resting stacksize:  6381
;Max. Const in 'testReg' :  658 max. 3000, free: 2342