;PLA comp. A.COM V0.9.5, Input: AS.C, Output: AS.S
org  256 
jmp main
;-1 char Version1[]="AS.C V1.0";//Assembler like NASM 11774 bytes

Version1 db "AS.C V1.0",0
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

;-93 int writetty()     {//ah=0x0E; bx=0; __emit__(0xCD,0x10);


writetty: PROC
;-94 asm mov ah, 14

 mov ah, 14
;-95 asm mov bx, 0

 mov bx, 0
;-96 asm int 16

 int 16
;-97 }

;-98 int putch(char c)  {

 ret
ENDP

putch: PROC
;-99     if (c==10)  {
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-100         asm mov al, 13

 mov al, 13
;-101         writetty();

 call writetty
;-102     }

;-103     asm mov al, [bp+4]; parameter c

.putch1:
 mov al, [bp+4]; parameter c
;-104     writetty();

 call writetty
;-105 }

;-106 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-107     char c;

;-108     while(*s) {
;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-109         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-110         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-111         s++;

 inc  word[bp+4]
;-112     }

;-113 }

 jmp .cputs2
.cputs3:
;-114 int mkneg(int n)   {

 LEAVE
 ret
ENDP

mkneg: PROC
;-115     asm mov ax, [bp+4]; parameter n
;
 ENTER  0,0
 mov ax, [bp+4]; parameter n
;-116     asm neg ax

 neg ax
;-117 }

;-118 

;-119 int DosInt() {

 LEAVE
 ret
ENDP

DosInt: PROC
;-120     asm int 33; 21h

 int 33; 21h
;-121     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-122     DOS_ERR++;

 inc  word[DOS_ERR]
;-123 }

;-124 int openR (char *s) {

 ret
ENDP

openR: PROC
;-125     asm mov dx, [bp+4]; dx=s;
;
 ENTER  0,0
 mov dx, [bp+4]; dx=s;
;-126     asm mov ax, 15618; ax=0x3D02;

 mov ax, 15618; ax=0x3D02;
;-127     DosInt();

 call DosInt
;-128 }

;-129 int creatR(char *s) {

 LEAVE
 ret
ENDP

creatR: PROC
;-130     asm mov dx, [bp+4]; dx=s;
;
 ENTER  0,0
 mov dx, [bp+4]; dx=s;
;-131     asm mov cx, 0

 mov cx, 0
;-132     asm mov ax, 15360; ax=0x3C00;

 mov ax, 15360; ax=0x3C00;
;-133     DosInt();

 call DosInt
;-134 }

;-135 int fcloseR(int fd) {

 LEAVE
 ret
ENDP

fcloseR: PROC
;-136     asm mov bx, [bp+4]; bx=fd;
;
 ENTER  0,0
 mov bx, [bp+4]; bx=fd;
;-137     asm mov ax, 15872; ax=0x3E00;

 mov ax, 15872; ax=0x3E00;
;-138     DosInt();

 call DosInt
;-139 }

;-140 int exitR  (char c) {

 LEAVE
 ret
ENDP

exitR: PROC
;-141     asm mov ah, 76; ah=0x4C;
;
 ENTER  0,0
 mov ah, 76; ah=0x4C;
;-142     asm mov al, [bp+4]; al=c;

 mov al, [bp+4]; al=c;
;-143     DosInt();

 call DosInt
;-144 }

;-145 int readRL(char *s, int fd, int len){

 LEAVE
 ret
ENDP

readRL: PROC
;-146     asm mov dx, [bp+4]; dx=s;
;
 ENTER  0,0
 mov dx, [bp+4]; dx=s;
;-147     asm mov cx, [bp+8]; cx=len;

 mov cx, [bp+8]; cx=len;
;-148     asm mov bx, [bp+6]; bx=fd;

 mov bx, [bp+6]; bx=fd;
;-149     asm mov ax, 16128;  ax=0x3F00;

 mov ax, 16128;  ax=0x3F00;
;-150     DosInt();

 call DosInt
;-151 }

;-152 int fputcR(char *n, int fd) {

 LEAVE
 ret
ENDP

fputcR: PROC
;-153     asm lea dx, [bp+4]; *n  todo: why not mov ?????
;
 ENTER  0,0
 lea dx, [bp+4]; *n  todo: why not mov ?????
;-154     asm mov cx, 1;      cx=1;

 mov cx, 1;      cx=1;
;-155     asm mov bx, [bp+6]; bx=fd;

 mov bx, [bp+6]; bx=fd;
;-156     asm mov ax, 16384;  ax=0x4000;

 mov ax, 16384;  ax=0x4000;
;-157     DosInt();

 call DosInt
;-158 }

;-159 

;-160 int letterE(char c) {

 LEAVE
 ret
ENDP

letterE: PROC
;-161   if (c=='_') return 1;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE4
 mov ax, 1
 jmp .retnletterE
;-162   if (c=='.') return 1;

.letterE4:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE5
 mov ax, 1
 jmp .retnletterE
;-163   if (c=='?') return 1;

.letterE5:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE6
 mov ax, 1
 jmp .retnletterE
;-164   if (c=='$') return 1;

.letterE6:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE7
 mov ax, 1
 jmp .retnletterE
;-165   if (c> 'z') return 0;

.letterE7:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE8
 mov ax, 0
 jmp .retnletterE
;-166   if (c< '@') return 0; // at included

.letterE8:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE9
 mov ax, 0
 jmp .retnletterE
;-167   if (c> 'Z') { if (c< 'a') return 0; }

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
;-168   return 1;

.letterE10:
 mov ax, 1
 jmp .retnletterE
;-169 }

;-170 int digit(char c){

 .retnletterE:
 LEAVE
 ret
ENDP

digit: PROC
;-171     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit12
 mov ax, 0
 jmp .retndigit
;-172     if(c>'9') return 0;

.digit12:
 mov al, [bp+4]
 cmp al, 57
 jle .digit13
 mov ax, 0
 jmp .retndigit
;-173     return 1;

.digit13:
 mov ax, 1
 jmp .retndigit
;-174 }

;-175 int alnumE(char c) {

 .retndigit:
 LEAVE
 ret
ENDP

alnumE: PROC
;-176   if (digit(c)) return 1;
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
;-177   if (letterE(c)) return 1;

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
;-178   return 0;

.alnumE15:
 mov ax, 0
 jmp .retnalnumE
;-179 }

;-180 int strlen(char *s) { int c;

 .retnalnumE:
 LEAVE
 ret
ENDP

strlen: PROC
;-181     c=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-182     while (*s!=0) {s++; c++;}

.strlen16:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen17
 inc  word[bp+4]
 inc  word[bp-2]
;-183     return c;

 jmp .strlen16
.strlen17:
 mov ax, [bp-2]
 jmp .retnstrlen
;-184     }

;-185 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-186     do { *s=*t; s++; t++; }
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
;-187     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy19
 jmp .strcpy18
.strcpy19:
;-188     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-189     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-190     }

;-191 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-192     while(*p) {
;
 ENTER  0,0
.eqstr20:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr21
;-193         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr22
 mov ax, 0
 jmp .retneqstr
;-194             p++;

.eqstr22:
 inc  word[bp+4]
;-195             q++;

 inc  word[bp+6]
;-196             }

;-197     if(*q) return 0;

 jmp .eqstr20
.eqstr21:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr23
 mov ax, 0
 jmp .retneqstr
;-198     return 1;

.eqstr23:
 mov ax, 1
 jmp .retneqstr
;-199     }

;-200 int strcat1(char *s, char *t) {

 .retneqstr:
 LEAVE
 ret
ENDP

strcat1: PROC
;-201     while (*s != 0) s++;
;
 ENTER  0,0
.strcat124:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat125
 inc  word[bp+4]
;-202     strcpy(s, t);

 jmp .strcat124
.strcat125:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-203     }

;-204 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-205     while(*s) {
;
 ENTER  0,0
.toupper26:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper27
;-206         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-207             s++;

.toupper29:
.toupper28:
 inc  word[bp+4]
;-208               }

;-209     }

 jmp .toupper26
.toupper27:
;-210 

;-211 int testReg() {

 LEAVE
 ret
ENDP

testReg: PROC
;-212 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD

;-213   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al
;-214   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg30
 mov ax, 0
 jmp .retntestReg
;-215   if (strlen(Symbol) > 3) return 0;

.testReg30:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg31
 mov ax, 0
 jmp .retntestReg
;-216   R2Type=BYTE;

.testReg31:
 mov ax, 1
 mov byte [R2Type], al
;-217   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg32
 mov ax, 0
 jmp .retntestReg
;-218   if (eqstr(SymbolUpper, "CL")) return 1;

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
;-219   if (eqstr(SymbolUpper, "DL")) return 2;

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
;-220   if (eqstr(SymbolUpper, "BL")) return 3;

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
;-221   if (eqstr(SymbolUpper, "AH")) return 4;

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
;-222   if (eqstr(SymbolUpper, "CH")) return 5;

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
;-223   if (eqstr(SymbolUpper, "DH")) return 6;

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
;-224   if (eqstr(SymbolUpper, "BH")) return 7;

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
;-225   R2Type=WORD;

.testReg39:
 mov ax, 2
 mov byte [R2Type], al
;-226   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg40
 mov ax, 0
 jmp .retntestReg
;-227   if (eqstr(SymbolUpper, "CX")) return 1;

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
;-228   if (eqstr(SymbolUpper, "DX")) return 2;

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
;-229   if (eqstr(SymbolUpper, "BX")) return 3;

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
;-230   if (eqstr(SymbolUpper, "SP")) return 4;

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
;-231   if (eqstr(SymbolUpper, "BP")) return 5;

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
;-232   if (eqstr(SymbolUpper, "SI")) return 6;

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
;-233   if (eqstr(SymbolUpper, "DI")) return 7;

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
;-234   R2Type=SEGREG;

.testReg47:
 mov ax, 4
 mov byte [R2Type], al
;-235   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg48
 mov ax, 0
 jmp .retntestReg
;-236   if (eqstr(SymbolUpper, "CS")) return 1;

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
;-237   if (eqstr(SymbolUpper, "SS")) return 2;

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
;-238   if (eqstr(SymbolUpper, "DS")) return 3;

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
;-239   if (eqstr(SymbolUpper, "FS")) return 4;

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
;-240   if (eqstr(SymbolUpper, "GS")) return 5;

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
;-241   R2Type=DWORD;

.testReg53:
 mov ax, 3
 mov byte [R2Type], al
;-242   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg54
 mov ax, 0
 jmp .retntestReg
;-243   if (eqstr(SymbolUpper, "ECX"))return 1;

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
;-244   if (eqstr(SymbolUpper, "EDX"))return 2;

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
;-245   if (eqstr(SymbolUpper, "EBX"))return 3;

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
;-246   if (eqstr(SymbolUpper, "ESP"))return 4;

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
;-247   if (eqstr(SymbolUpper, "EBP"))return 5;

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
;-248   if (eqstr(SymbolUpper, "ESI"))return 6;

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
;-249   if (eqstr(SymbolUpper, "EDI"))return 7;

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
;-250   R2Type=0; return 0;

.testReg61:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg
;-251 }

;-252 

;-253 

;-254 int prc(unsigned char c) {//print char

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
;-255     if (isPrint) {
;
 ENTER  0,0
 mov al, [isPrint]
 or  al, al
 je .prc62
;-256         if (c==10) {

 mov al, [bp+4]
 cmp al, 10
 jne .prc63
;-257             asm mov ax, 13

 mov ax, 13
;-258             writetty();

 call writetty
;-259             }

;-260         asm mov al, [bp+4]; al=c;

.prc63:
 mov al, [bp+4]; al=c;
;-261         writetty();

 call writetty
;-262     }

;-263     fputcR(c,lst_fd);

.prc62:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-264 }

;-265 

;-266 int prscomment(unsigned char *s) {

 LEAVE
 ret
ENDP

prscomment: PROC
;-267     unsigned char c;

;-268     while (*s){
;
 ENTER  2,0
.prscomment64:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment65
;-269         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-270         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-271         s++;

 inc  word[bp+4]
;-272     }

;-273 }

 jmp .prscomment64
.prscomment65:
;-274 int prs(unsigned char *s) {

 LEAVE
 ret
ENDP

prs: PROC
;-275     unsigned char c;

;-276     int com;

;-277     com=0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax
;-278     while (*s) {

.prs66:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs67
;-279         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-280         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs68
;-281             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs69
 mov ax, 0
 mov [bp-4], ax
;-282                 else com=1;

 jmp .prs70
.prs69:
 mov ax, 1
 mov [bp-4], ax
;-283         }

.prs70:
;-284         if (c==92) {

.prs68:
 mov al, [bp-2]
 cmp al, 92
 jne .prs71
;-285             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs72
;-286                 s++;

 inc  word[bp+4]
;-287                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-288                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs73
 mov ax, 10
 mov [bp-2], al
;-289                 if (c=='t') c= 9;

.prs73:
 mov al, [bp-2]
 cmp al, 116
 jne .prs74
 mov ax, 9
 mov [bp-2], al
;-290             }

.prs74:
;-291         }

.prs72:
;-292         prc(c);

.prs71:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-293         s++;

 inc  word[bp+4]
;-294     }

;-295 }

 jmp .prs66
.prs67:
;-296 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-297     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-298     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex475
 add  byte[bp+4], 7
;-299     prc(c);

.printhex475:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-300 }

;-301 int printhex8(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8: PROC
;-302     unsigned char nib;

;-303     nib = c >> 4; printhex4(nib);
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
;-304     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-305 }

;-306 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-307     unsigned int half;

;-308     half = i >>  8; printhex8(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-309     half = i & 255; printhex8(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8
 add  sp, 2
;-310 }

;-311 int printIntU(unsigned int n) {

 LEAVE
 ret
ENDP

printIntU: PROC
;-312     unsigned int e;

;-313     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printIntU76
;-314         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-315         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2
;-316     }

;-317     n = n % 10; //unsigned mod

.printIntU76:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-318     n += '0';

 add  word[bp+4], 48
;-319     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2
;-320 }

;-321 int printLine() {

 LEAVE
 ret
ENDP

printLine: PROC
;-322     unsigned int i; char c;

;-323     prs("\n");
;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2
;-324     i=PCStart + Origin;

 mov ax, [PCStart]
 add ax, [Origin]
 mov [bp-2], ax
;-325     printhex16(i);

 push word [bp-2]
 call printhex16
 add  sp, 2
;-326     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine77
 push printLine_1
 call prs
 add  sp, 2
;-327     else {

 jmp .printLine78
.printLine77:
;-328 //        prc(' ');

;-329         i=0;

 mov ax, 0
 mov [bp-2], ax
;-330         do {

.printLine79:
;-331             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al
;-332             prc(' ');

 push 32
 call prc
 add  sp, 2
;-333             printhex8(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8
 add  sp, 2
;-334             i++;

 inc  word[bp-2]
;-335         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine80
 jmp .printLine79
.printLine80:
;-336         while (i < OPMAXLEN) {// fill rest with blank

.printLine81:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine82
;-337             prs("   ");

 push printLine_2
 call prs
 add  sp, 2
;-338             i++;

 inc  word[bp-2]
;-339         }

;-340     }

 jmp .printLine81
.printLine82:
;-341     prc(PrintRA);

.printLine78:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-342     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2
;-343 }

;-344 

;-345 int epilog() {

 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

epilog: PROC
;-346     unsigned int i; char c;     int j;

;-347     isPrint=1;
;
 ENTER  6,0
 mov ax, 1
 mov byte [isPrint], al
;-348     prs("Errors:");

 push epilog_0
 call prs
 add  sp, 2
;-349     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2
;-350     if (ErrorCount) prs("\n****** ERRORS *** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog83
 push epilog_1
 call prs
 add  sp, 2
;-351     prs("\nOutput: ");

.epilog83:
 push epilog_2
 call prs
 add  sp, 2
;-352     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2
;-353     if (ErrorCount == 0) {

 mov ax, [ErrorCount]
 cmp ax, 0
 jne .epilog84
;-354         prs(", ");

 push epilog_3
 call prs
 add  sp, 2
;-355         prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2
;-356         prs("= ");

 push epilog_4
 call prs
 add  sp, 2
;-357         printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2
;-358         prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2
;-359         i=0;

 mov ax, 0
 mov [bp-2], ax
;-360         do {

.epilog85:
;-361             c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al
;-362             fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-363             i++;

 inc  word[bp-2]
;-364         } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog86
 jmp .epilog85
.epilog86:
;-365     }

;-366 }

.epilog84:
;-367 

;-368 int end1(int n) {

 LEAVE
 ret
epilog_0 db "Errors:",0
epilog_1 db "\n****** ERRORS *** ",0
epilog_2 db "\nOutput: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
ENDP

end1: PROC
;-369     fcloseR(asm_fd);
;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2
;-370     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2
;-371     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2
;-372     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2
;-373 }

;-374 

;-375 

;-376 int error1(char *s) {

 LEAVE
 ret
ENDP

error1: PROC
;-377     isPrint=1;
;
 ENTER  0,0
 mov ax, 1
 mov byte [isPrint], al
;-378     ErrorCount++;

 inc  word[ErrorCount]
;-379     prs("\n\n******* next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2
;-380     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2
;-381     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2
;-382     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2
;-383 }

;-384 int errorexit(char *s) {

 LEAVE
 ret
error1_0 db "\n\n******* next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC
;-385     error1(s);
;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2
;-386     epilog();

 call epilog
;-387     end1(1);

 push 1
 call end1
 add  sp, 2
;-388 }

;-389 int dataexit(){

 LEAVE
 ret
ENDP

dataexit: PROC
;-390     errorexit("DB,DW,DD or RESB,W,D expected");

 push dataexit_0
 call errorexit
 add  sp, 2
;-391 }

;-392 int notfounderror(){

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

notfounderror: PROC
;-393     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al
;-394     ErrorCount++;

 inc  word[ErrorCount]
;-395     prs("\n\n******* ERROR: label not found: ");

 push notfounderror_0
 call prs
 add  sp, 2
;-396     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2
;-397     prs(" in proc ");

 push notfounderror_1
 call prs
 add  sp, 2
;-398     prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2
;-399     end1(1);

 push 1
 call end1
 add  sp, 2
;-400 

;-401 }

;-402 int addrerror()    {error1("address missing");}

 ret
notfounderror_0 db "\n\n******* ERROR: label not found: ",0
notfounderror_1 db " in proc ",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2
;-403 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2
;-404 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2
;-405 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2
;-406 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2
;-407 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2
;-408 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2
;-409 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2
;-410 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2
;-411 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2
;-412 

;-413 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
syntaxerror_0 db "syntax",0
ENDP

ifEOL: PROC
;-414   if (c == 10) return 1;//LF
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL87
 mov ax, 1
 jmp .retnifEOL
;-415   if (c == 13) {//CR

.ifEOL87:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL88
;-416     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-417     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL89
 push ifEOL_0
 call errorexit
 add  sp, 2
;-418     return 1;

.ifEOL89:
 mov ax, 1
 jmp .retnifEOL
;-419   }

;-420   return 0;

.ifEOL88:
 mov ax, 0
 jmp .retnifEOL
;-421 }

;-422 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL:
 LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC
;-423   unsigned int i;

;-424   InputPtr= &InputBuf;
;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax
;-425   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-426   do {

.getLine90:
;-427     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-428     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine91
 push getLine_0
 call errorexit
 add  sp, 2
;-429     if (DOS_NoBytes == 0) return;

.getLine91:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine92
 jmp .retngetLine
;-430     *InputPtr = DOS_ByteRead;

.getLine92:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al
;-431     InputPtr++;

 inc  word[InputPtr]
;-432     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax
;-433     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine93
 push getLine_1
 call errorexit
 add  sp, 2
;-434   } while (ifEOL(DOS_ByteRead) == 0);

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
;-435   InputPtr--;

 dec  word[InputPtr]
;-436   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-437 }

;-438 int skipBlank() {

 .retngetLine:
 LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC
;-439   skipblank1:

.skipblank1:
;-440     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank95
 inc  word[InputPtr]
 jmp .skipblank1
;-441     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank95:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank96
 inc  word[InputPtr]
 jmp .skipblank1
;-442 }

.skipBlank96:
;-443 

;-444 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC
;-445   unsigned int CastInt;

;-446   SymbolInt=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax
;-447   do {

.getDigit97:
;-448     c-='0';

 sub  byte[bp+4], 48
;-449     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax
;-450     asm mov ax, 0

 mov ax, 0
;-451     CastInt=c; //cast b2w

 mov al, [bp+4]
 mov [bp-2], ax
;-452     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax
;-453     InputPtr++;

 inc  word[InputPtr]
;-454     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-455   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit98
 jmp .getDigit97
.getDigit98:
;-456 }

;-457 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel

 LEAVE
 ret
ENDP

getName: PROC
;-458   char *p; unsigned int i;

;-459   p = &Symbol;
;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax
;-460   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-461   p++;

 inc  word[bp-2]
;-462   while (alnumE(c)) {

.getName99:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName100
;-463     InputPtr++;

 inc  word[InputPtr]
;-464     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-465     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-466     p++;

 inc  word[bp-2]
;-467     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax
;-468     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName101
 push getName_0
 call errorexit
 add  sp, 2
;-469   }

.getName101:
;-470   if (c == ':') isLabel=1; else isLabel=0;

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
;-471   p--;

.getName103:
 dec  word[bp-2]
;-472   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-473   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4
;-474   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2
;-475 }

;-476 

;-477 //OpName, 0, CodeType, Code1

;-478 //  1:   1 byte opcod

;-479 char T00[]={'P','U','S','H','A',0,1,0x60, 'P','O','P','A',0,    1,0x61};

 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
T00 db 80,85,83,72,65,0,1,96,80,79,80,65,0,1,97
;-480 char T01[]={'N','O','P',0,        1,0x90, 'C','B','W',0,        1,0x98};

T01 db 78,79,80,0,1,144,67,66,87,0,1,152
;-481 char T02[]={'C','W','D','E',0,    1,0x98, 'C','W','D',0,        1,0x99};

T02 db 67,87,68,69,0,1,152,67,87,68,0,1,153
;-482 char T03[]={'C','D','Q',0,        1,0x99, 'W','A','I','T',0,    1,0x9B};

T03 db 67,68,81,0,1,153,87,65,73,84,0,1,155
;-483 char T04[]={'P','U','S','H','F',0,1,0x9C, 'P','O','P','F',0,    1,0x9D};

T04 db 80,85,83,72,70,0,1,156,80,79,80,70,0,1,157
;-484 char T05[]={'S','A','H','F',0,    1,0x9E, 'L','A','H','F',0,    1,0x9F};

T05 db 83,65,72,70,0,1,158,76,65,72,70,0,1,159
;-485 char T06[]={'M','O','V','S','B',0,1,0xA4, 'M','O','V','S','W',0,1,0xA5};

T06 db 77,79,86,83,66,0,1,164,77,79,86,83,87,0,1,165
;-486 char T07[]={'C','M','P','S','B',0,1,0xA6, 'C','M','P','S','W',0,1,0xA7};

T07 db 67,77,80,83,66,0,1,166,67,77,80,83,87,0,1,167
;-487 char T08[]={'S','T','O','S','B',0,1,0xAA, 'S','T','O','S','W',0,1,0xAB};

T08 db 83,84,79,83,66,0,1,170,83,84,79,83,87,0,1,171
;-488 char T09[]={'L','O','D','S','B',0,1,0xAC, 'L','O','D','S','W',0,1,0xAD};

T09 db 76,79,68,83,66,0,1,172,76,79,68,83,87,0,1,173
;-489 char T10[]={'S','C','A','S','B',0,1,0xAE, 'S','C','A','S','W',0,1,0xAF};

T10 db 83,67,65,83,66,0,1,174,83,67,65,83,87,0,1,175
;-490 char T11[]={'L','E','A','V','E',0,1,0xC9, 'I','N','T','3',0,    1,0xCC};

T11 db 76,69,65,86,69,0,1,201,73,78,84,51,0,1,204
;-491 char T12[]={'I','N','T','O',0,    1,0xCE, 'I','R','E','T',0,    1,0xCF};

T12 db 73,78,84,79,0,1,206,73,82,69,84,0,1,207
;-492 char T13[]={'X','L','A','T',0,    1,0xD7, 'L','O','C','K',0,    1,0xF0};

T13 db 88,76,65,84,0,1,215,76,79,67,75,0,1,240
;-493 char T14[]={'R','E','P','N','E',0,1,0xF2, 'R','E','P','N','Z',0,1,0xF2};

T14 db 82,69,80,78,69,0,1,242,82,69,80,78,90,0,1,242
;-494 char T15[]={'R','E','P','E',0,    1,0xF3, 'R','E','P','Z',0,    1,0xF3};

T15 db 82,69,80,69,0,1,243,82,69,80,90,0,1,243
;-495 char T16[]={'H','L','T',0,        1,0xF4, 'C','L','C',0,        1,0xF8};

T16 db 72,76,84,0,1,244,67,76,67,0,1,248
;-496 char T17[]={'S','T','C',0,        1,0xF9, 'C','L','I',0,        1,0xFA};

T17 db 83,84,67,0,1,249,67,76,73,0,1,250
;-497 char T18[]={'S','T','I',0,        1,0xFB, 'C','L','D',0,        1,0xFC};

T18 db 83,84,73,0,1,251,67,76,68,0,1,252
;-498 char T19[]={'S','T','D',0,        1,0xFD};

T19 db 83,84,68,0,1,253
;-499 // 2: mem reg 16 bit

;-500 char T20[]={'I','N','C',0,        2, 0,   'D','E','C',0,        2, 1};

T20 db 73,78,67,0,2,0,68,69,67,0,2,1
;-501 char T21[]={'N','O','T',0,        2, 2,   'N','E','G',0,        2, 3};

T21 db 78,79,84,0,2,2,78,69,71,0,2,3
;-502 char T22[]={'M','U','L',0,        2, 4,   'I','M','U','L',0,    2, 5};

T22 db 77,85,76,0,2,4,73,77,85,76,0,2,5
;-503 //IMUL acc only

;-504 char T23[]={'D','I','V',0,        2, 6,   'I','D','I','V',0,    2, 7};

T23 db 68,73,86,0,2,6,73,68,73,86,0,2,7
;-505 //  3: les, lda, lea, lss, lfs, lgs

;-506 char T24[]={'L','E','S',0,        3,0xC4, 'L','D','S',0,        3,0xC5};

T24 db 76,69,83,0,3,196,76,68,83,0,3,197
;-507 char T25[]={'L','E','A',0,        3,0x8D, 'L','S','S',0,        3,0xB2};

T25 db 76,69,65,0,3,141,76,83,83,0,3,178
;-508 char T26[]={'L','F','S',0,        3,0xB4, 'L','G','S',0,        3,0xB5};

T26 db 76,70,83,0,3,180,76,71,83,0,3,181
;-509 //  4: acc,imm  reg,imm  index,reg

;-510 char T27[]={'A','D','D',0,        4, 0,   'O','R',0,            4, 1};

T27 db 65,68,68,0,4,0,79,82,0,4,1
;-511 char T28[]={'A','D','C',0,        4, 2,   'S','B','B',0,        4, 3};

T28 db 65,68,67,0,4,2,83,66,66,0,4,3
;-512 char T29[]={'A','N','D',0,        4, 4,   'S','U','B',0,        4, 5};

T29 db 65,78,68,0,4,4,83,85,66,0,4,5
;-513 char T30[]={'X','O','R',0,        4, 6,   'C','M','P',0,        4, 7};

T30 db 88,79,82,0,4,6,67,77,80,0,4,7
;-514 //  5: mov

;-515 char T31[]={'M','O','V',0,        5, 0};

T31 db 77,79,86,0,5,0
;-516 //  6: single byte relative jump

;-517 char T32[]={'J','O',0,            6, 0,    'J','N','O',0,       6, 1};

T32 db 74,79,0,6,0,74,78,79,0,6,1
;-518 char T33[]={'J','B',0,            6, 2,    'J','C',0,           6, 2};

T33 db 74,66,0,6,2,74,67,0,6,2
;-519 char T34[]={'J','N','B',0,        6, 3};

T34 db 74,78,66,0,6,3
;-520 char T35[]={'J','A','E',0,        6, 3,    'J','N','C',0,       6, 3};

T35 db 74,65,69,0,6,3,74,78,67,0,6,3
;-521 char T36[]={'J','E',0,            6, 4,    'J','Z',0,           6, 4};

T36 db 74,69,0,6,4,74,90,0,6,4
;-522 char T37[]={'J','N','E',0,        6, 5,    'J','N','Z',0,       6, 5};

T37 db 74,78,69,0,6,5,74,78,90,0,6,5
;-523 char T38[]={'J','B','E',0,        6, 6,    'J','N','A',0,       6, 6};

T38 db 74,66,69,0,6,6,74,78,65,0,6,6
;-524 char T39[]={'J','A',0,            6, 7,    'J','S',0,           6, 8};

T39 db 74,65,0,6,7,74,83,0,6,8
;-525 char T40[]={'J','N','S',0,        6, 9};

T40 db 74,78,83,0,6,9
;-526 char T41[]={'J','P',0,            6,10,    'J','P','E',0,       6,10};

T41 db 74,80,0,6,10,74,80,69,0,6,10
;-527 char T42[]={'J','N','P',0,        6,11,    'J','P','O',0,       6,11};

T42 db 74,78,80,0,6,11,74,80,79,0,6,11
;-528 char T43[]={'J','L',0,            6,12};

T43 db 74,76,0,6,12
;-529 char T44[]={'J','N','L',0,        6,13,    'J','G','E',0,       6,13};

T44 db 74,78,76,0,6,13,74,71,69,0,6,13
;-530 char T45[]={'J','L','E',0,        6,14,    'J','N','G',0,       6,14};

T45 db 74,76,69,0,6,14,74,78,71,0,6,14
;-531 char T46[]={'J','G',0,            6,15};

T46 db 74,71,0,6,15
;-532 //  7: jmp, call

;-533 char T47[]={'J','M','P',0,        7,0xE9,  'C','A','L','L',0,   7,0xE8};

T47 db 74,77,80,0,7,233,67,65,76,76,0,7,232
;-534 //  8: ret

;-535 char T48[]={'R','E','T',0,        8,0xC3,  'R','E','T','F',0,   8,0xCB};

T48 db 82,69,84,0,8,195,82,69,84,70,0,8,203
;-536 //  9: seg, r/m

;-537 char T49[]={'P','U','S','H',0,    9,0x50,  'P','O','P',0,       9,0x58};

T49 db 80,85,83,72,0,9,80,80,79,80,0,9,88
;-538 //  11: shift, rotates

;-539 char T50[]={'R','O','L',0,       11, 0,    'R','O','R',0,      11, 1};

T50 db 82,79,76,0,11,0,82,79,82,0,11,1
;-540 char T51[]={'R','C','L',0,       11, 2,    'R','C','R',0,      11, 3};

T51 db 82,67,76,0,11,2,82,67,82,0,11,3
;-541 char T52[]={'S','H','L',0,       11, 4,    'S','A','L',0,      11, 4};

T52 db 83,72,76,0,11,4,83,65,76,0,11,4
;-542 char T53[]={'S','H','R',0,       11, 5,    'S','A','R',0,      11, 7};

T53 db 83,72,82,0,11,5,83,65,82,0,11,7
;-543 //  12: int

;-544 char T54[]={'I','N','T',0,       12,0xCD};

T54 db 73,78,84,0,12,205
;-545 //  14: in/out                   not implemented

;-546 char T55[]={'I','N',0,           14,0xE4,  'I','N','S','B',0,  14,0x6C};

T55 db 73,78,0,14,228,73,78,83,66,0,14,108
;-547 char T56[]={'I','N','S','W',0,   14,0x6D,  'I','N','S','D',0,  14,0x6D};

T56 db 73,78,83,87,0,14,109,73,78,83,68,0,14,109
;-548 char T57[]={'O','U','T',0,       14,0xE6,  'O','U','T','B',0,  14,0x6E};

T57 db 79,85,84,0,14,230,79,85,84,66,0,14,110
;-549 char T58[]={'O','U','T','W',0,   14,0x6F,  'O','U','T','D',0,  14,0x6F};

T58 db 79,85,84,87,0,14,111,79,85,84,68,0,14,111
;-550 //  15: xch                      not implemented

;-551 char T59[]={'X','C','H','G',0,   15,0x86};

T59 db 88,67,72,71,0,15,134
;-552 //  16: loop, jcxz               not implemented

;-553 char T60 []={'L','O','O','P','N','Z',0,16,0xE0};

T60 db 76,79,79,80,78,90,0,16,224
;-554 char T60a[]={'L','O','O','P','N','E',0,16,0xE0};

T60a db 76,79,79,80,78,69,0,16,224
;-555 char T61[]={'L','O','O','P','Z',0,16,0xE1,'L','O','O','P','E',0,16,0xE1};

T61 db 76,79,79,80,90,0,16,225,76,79,79,80,69,0,16,225
;-556 char T62[]={'L','O','O','P',0,    16,0xE2};

T62 db 76,79,79,80,0,16,226
;-557 char T63[]={'J','C','X','Z',0,    16,0xE3,'J','E','C','X','Z',0,16,0xE3};

T63 db 74,67,88,90,0,16,227,74,69,67,88,90,0,16,227
;-558 //  30: other

;-559 char T64[]={'E','N','T','E','R',0,30,0};

T64 db 69,78,84,69,82,0,30,0
;-560 //                                not implemented

;-561 char T65[]={'T','E','S','T',0,    41,0xF6};

T65 db 84,69,83,84,0,41,246
;-562 char T66[]={'M','O','V','S','X',0,51,0xBE,'M','O','V','Z','X',0,51,0xB6};

T66 db 77,79,86,83,88,0,51,190,77,79,86,90,88,0,51,182
;-563 // 100: directives

;-564 char T67[]={'O','R','G',0,      101, 0};

T67 db 79,82,71,0,101,0
;-565 // section, segment .TEXT .DATA .BSS

;-566 char T68[]={'S','E','C','T','I','O','N',0,      102, 0};

T68 db 83,69,67,84,73,79,78,0,102,0
;-567 char T69[]={'S','E','G','M','E','N','T',0,      102, 0};

T69 db 83,69,71,77,69,78,84,0,102,0
;-568 char T70[]={'A','B','S','O','L','U','T','E',0,  110, 0};

T70 db 65,66,83,79,76,85,84,69,0,110,0
;-569 char T71[]={'P','R','O','C',0,    111, 0, 'E','N','D','P',0, 112, 0};

T71 db 80,82,79,67,0,111,0,69,78,68,80,0,112,0
;-570 char T72[]={'D','B',0,            200, 0, 'D','W',0,         201, 0};

T72 db 68,66,0,200,0,68,87,0,201,0
;-571 char T73[]={'D','D',0,            202, 0, 'R','E','S','B',0, 203, 0};

T73 db 68,68,0,202,0,82,69,83,66,0,203,0
;-572 char T74[]={'R','E','S','W',0,    204, 0, 'R','E','S','D',0, 205, 0};

T74 db 82,69,83,87,0,204,0,82,69,83,68,0,205,0
;-573 char TEND=0;// end of table char

TEND db 0
;-574 

;-575 int lookCode1() {//ret: CodeType, Code1


lookCode1: PROC
;-576     OpCodePtr= &T00;

 mov ax, T00
 mov word [OpCodePtr], ax
;-577     do  {

.lookCode1104:
;-578         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode1105
;-579             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1106:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1107
 inc  word[OpCodePtr]
;-580             OpCodePtr++;

 jmp .lookCode1106
.lookCode1107:
 inc  word[OpCodePtr]
;-581             CodeType = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al
;-582             OpCodePtr++;

 inc  word[OpCodePtr]
;-583             Code1    = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al
;-584             return;

 jmp .retnlookCode1
;-585         }

;-586         while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1105:
.lookCode1108:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1109
 inc  word[OpCodePtr]
;-587         OpCodePtr += 3;

 jmp .lookCode1108
.lookCode1109:
 add  word[OpCodePtr], 3
;-588 

;-589         } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1110
 jmp .lookCode1104
.lookCode1110:
;-590     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al
;-591 }

;-592 

;-593 

;-594 int genCode8(char c) {

 .retnlookCode1:
 ret
ENDP

genCode8: PROC
;-595 //set: BinLen++, OpPrintIndex++

;-596     FileBin[BinLen]=c;
;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
;-597     BinLen++;

 inc  word[BinLen]
;-598     PC++;

 inc  word[PC]
;-599     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 25000 ;unsigned : 0
 jb  .genCode8111
 push genCode8_0
 call errorexit
 add  sp, 2
;-600     if (OpPrintIndex < OPMAXLEN) {

.genCode8111:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8112
;-601         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
;-602         OpPrintIndex++;

 inc  word[OpPrintIndex]
;-603     }

;-604 }

.genCode8112:
;-605 int gen66h() {genCode8(0x66);

 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2
;-606 }

;-607 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC
;-608     c = c + d;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al
;-609     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-610 }

;-611 int genCodeW(char c) {

 LEAVE
 ret
ENDP

genCodeW: PROC
;-612     c = c + wflag;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al
;-613     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-614 }

;-615 int genCode16(unsigned int i) {

 LEAVE
 ret
ENDP

genCode16: PROC
;-616     genCode8(i); i=i >> 8;
;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax
;-617     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2
;-618 }

;-619 int genCode32(unsigned long L) {

 LEAVE
 ret
ENDP

genCode32: PROC
;-620     genCode16(L); L=L >>16;
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
;-621     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
;-622 }

;-623 int writeEA(char xxx) {//value for reg/operand

 LEAVE
 ret
ENDP

writeEA: PROC
;-624 //need: Op, Op2, disp, R1No, R2No, rm, isDirect

;-625 //mod-bits: mode76, reg/opcode543, r/m210

;-626 //Op: 0, IMM, REG, ADR, MEM

;-627     int disploc;

;-628     char len;

;-629     len=0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-630     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al
;-631     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA113
;-632         xxx |= 0xC0;

 or  byte[bp+4], 192
;-633         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA114
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-634             else {

 jmp .writeEA115
.writeEA114:
;-635                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA116
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-636                 else            xxx = xxx + R2No;

 jmp .writeEA117
.writeEA116:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al
;-637             }

.writeEA117:
;-638         }

.writeEA115:
;-639     if (Op == MEM) {

.writeEA113:
 mov al, [Op]
 cmp al, 4
 jne .writeEA118
;-640         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA119
;-641             xxx |= 6;

 or  byte[bp+4], 6
;-642             len = 2;

 mov ax, 2
 mov [bp-4], al
;-643         }

;-644         else {

 jmp .writeEA120
.writeEA119:
;-645             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al
;-646             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA121
;-647                 len=1;

 mov ax, 1
 mov [bp-4], al
;-648                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA122
 or  byte[bp+4], 64
;-649             }

.writeEA122:
;-650 

;-651             if (disp) {

.writeEA121:
 mov ax, [disp]
 or  al, al
 je .writeEA123
;-652                 disploc=disp;

 mov ax, [disp]
 mov [bp-2], ax
;-653                 if (disploc  < 0) disploc=mkneg(disploc);

 mov ax, [bp-2]
 cmp ax, 0
 jge .writeEA124
 push word [bp-2]
 call mkneg
 add  sp, 2
 mov [bp-2], ax
;-654                 if (disploc > 127) len=2;

.writeEA124:
 mov ax, [bp-2]
 cmp ax, 127
 jle .writeEA125
 mov ax, 2
 mov [bp-4], al
;-655                 else len=1;

 jmp .writeEA126
.writeEA125:
 mov ax, 1
 mov [bp-4], al
;-656                 if (len == 1) xxx |= 0x40;

.writeEA126:
 mov al, [bp-4]
 cmp al, 1
 jne .writeEA127
 or  byte[bp+4], 64
;-657                 else xxx |= 0x80;

 jmp .writeEA128
.writeEA127:
 or  byte[bp+4], 128
;-658             }

.writeEA128:
;-659         }

.writeEA123:
;-660     }

.writeEA120:
;-661 

;-662     genCode8(xxx);// gen second byte

.writeEA118:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-663     if (len == 1) genCode8 (disp);

 mov al, [bp-4]
 cmp al, 1
 jne .writeEA129
 push word [disp]
 call genCode8
 add  sp, 2
;-664     if (len == 2) genCode16(disp);

.writeEA129:
 mov al, [bp-4]
 cmp al, 2
 jne .writeEA130
 push word [disp]
 call genCode16
 add  sp, 2
;-665 }

.writeEA130:
;-666 

;-667 int genImmediate() {

 LEAVE
 ret
ENDP

genImmediate: PROC
;-668     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate131
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate132
 push word [imme]
 call genCode32
 add  sp, 2
;-669         //todo imme long

;-670         else genCode16(imme);

 jmp .genImmediate133
.genImmediate132:
 push word [imme]
 call genCode16
 add  sp, 2
;-671     else       genCode8 (imme);

.genImmediate133:
 jmp .genImmediate134
.genImmediate131:
 push word [imme]
 call genCode8
 add  sp, 2
;-672 }

.genImmediate134:
;-673 

;-674 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC
;-675     wflag=0;

 mov ax, 0
 mov byte [wflag], al
;-676     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag135
;-677         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag136
 mov al, [R1Type]
 mov byte [OpSize], al
;-678         if (Op2== REG) OpSize=R2Type;

.setwflag136:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag137
 mov al, [R2Type]
 mov byte [OpSize], al
;-679         if (R2Type== SEGREG) OpSize=WORD;

.setwflag137:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag138
 mov ax, 2
 mov byte [OpSize], al
;-680         if (R1Type == SEGREG) OpSize=WORD;

.setwflag138:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag139
 mov ax, 2
 mov byte [OpSize], al
;-681     }

.setwflag139:
;-682     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag135:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag140
 call gen66h
 mov ax, 1
 mov byte [wflag], al
;-683     if (OpSize  ==  WORD) wflag=1;

.setwflag140:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag141
 mov ax, 1
 mov byte [wflag], al
;-684 }

.setwflag141:
;-685 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC
;-686     unsigned int ui;

;-687     sflag=2;
;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al
;-688     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax
;-689     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag142
 mov ax, 0
 mov byte [sflag], al
;-690     if (OpSize == BYTE) {

.setsflag142:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag143
;-691         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag144
 push setsflag_0
 call error1
 add  sp, 2
;-692         sflag=0;//byte reg does not need sign extended

.setsflag144:
 mov ax, 0
 mov byte [sflag], al
;-693     }

;-694 }

.setsflag143:
;-695 int checkConstSize(unsigned int ui) {

 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC
;-696     if (ui > 127   ) return 0;//is near; return sflag
;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize145
 mov ax, 0
 jmp .retncheckConstSize
;-697     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize145:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize146
 mov ax, 0
 jmp .retncheckConstSize
;-698     return 2;// is short

.checkConstSize146:
 mov ax, 2
 jmp .retncheckConstSize
;-699 }

;-700 

;-701 

;-702 int ChangeDirection() {

 .retncheckConstSize:
 LEAVE
 ret
ENDP

ChangeDirection: PROC
;-703     char c;

;-704     c=Op;     Op    =Op2;    Op2   =c;
;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al
;-705     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al
;-706     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al
;-707     dflag=2;

 mov ax, 2
 mov byte [dflag], al
;-708 }

;-709 

;-710 int getTokeType() {

 LEAVE
 ret
ENDP

getTokeType: PROC
;-711     char c;

;-712     skipBlank();
;
 ENTER  2,0
 call skipBlank
;-713     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-714     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType147
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-715     if (c == ';') {TokeType=0; return; }//comment

.getTokeType147:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType148
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-716     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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
;-717     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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
;-718     TokeType=NOALNUME;

.getTokeType150:
 mov ax, 4
 mov byte [TokeType], al
;-719 }

;-720 

;-721 int isToken(char c) {

 .retngetTokeType:
 LEAVE
 ret
ENDP

isToken: PROC
;-722     skipBlank();
;
 ENTER  0,0
 call skipBlank
;-723     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken151
;-724         InputPtr++;

 inc  word[InputPtr]
;-725         return 1;

 mov ax, 1
 jmp .retnisToken
;-726         }

;-727     return 0;

.isToken151:
 mov ax, 0
 jmp .retnisToken
;-728 }

;-729 

;-730 

;-731 int need(char c) {

 .retnisToken:
 LEAVE
 ret
ENDP

need: PROC
;-732     if (isToken(c)) {
;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need152
;-733         getTokeType();

 call getTokeType
;-734         return;

 jmp .retnneed
;-735         }

;-736     error1();

.need152:
 call error1
;-737     prs(". need: ");

 push need_0
 call prs
 add  sp, 2
;-738     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-739 }

;-740 int skipRest() {

 .retnneed:
 LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC
;-741     getTokeType();

 call getTokeType
;-742     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest153
 push skipRest_0
 call error1
 add  sp, 2
;-743 }

.skipRest153:
;-744 

;-745 

;-746 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC
;-747     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL154
 call implerror
;-748     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL154:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL155
 call segregerror
 jmp .retncheckOpL
;-749     setwflag();

.checkOpL155:
 call setwflag
;-750     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL156
 push checkOpL_0
 call error1
 add  sp, 2
;-751     if (OpSize == R1Type) return;

.checkOpL156:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL157
 jmp .retncheckOpL
;-752     if (Op == REG) if (R1Type==0) error1("no register defined");

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
;-753 }

.checkOpL159:
.checkOpL158:
;-754 

;-755 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC
;-756     int LIx; char *p;

;-757     p = &LabelNames;
;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax
;-758     LIx = 1;

 mov ax, 1
 mov [bp-2], ax
;-759     while (LIx <= LabelMaxIx) {

.searchLabel160:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel161
;-760         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel162
 mov ax, [bp-2]
 jmp .retnsearchLabel
;-761         p=strlen(p) + p;

.searchLabel162:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax
;-762         p++;

 inc  word[bp-4]
;-763         LIx++;

 inc  word[bp-2]
;-764     }

;-765     return 0;

 jmp .searchLabel160
.searchLabel161:
 mov ax, 0
 jmp .retnsearchLabel
;-766 }

;-767 

;-768 int getOp1() {//scan for a single operand

 .retnsearchLabel:
 LEAVE
 ret
ENDP

getOp1: PROC
;-769 //return:0, IMM, REG, ADR (not MEM)

;-770 //set   :R2Type, R2No by testReg

;-771 //set   :LabelIx by searchLabel

;-772     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1163
 mov ax, 0
 jmp .retngetOp1
;-773     if (TokeType == DIGIT)  return IMM;

.getOp1163:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1164
 mov ax, 1
 jmp .retngetOp1
;-774     if (TokeType == ALNUME) {

.getOp1164:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1165
;-775         R2No=testReg();

 call testReg
 mov byte [R2No], al
;-776         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1166
 mov ax, 2
 jmp .retngetOp1
;-777         LabelIx=searchLabel();

.getOp1166:
 call searchLabel
 mov word [LabelIx], ax
;-778         return ADR;

 mov ax, 3
 jmp .retngetOp1
;-779     }

;-780     return 0;

.getOp1165:
 mov ax, 0
 jmp .retngetOp1
;-781 }

;-782 

;-783 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC
;-784     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1167
 call indexerror
;-785     if (R2No==3) rm=7;//BX

.getIndReg1167:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1168
 mov ax, 7
 mov byte [rm], al
;-786     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1168:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1169
 mov ax, 6
 mov byte [rm], al
;-787     if (R2No==7) rm=5;//DI

.getIndReg1169:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1170
 mov ax, 5
 mov byte [rm], al
;-788     if (R2No==6) rm=4;//SI

.getIndReg1170:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1171
 mov ax, 4
 mov byte [rm], al
;-789     if (rm==0) indexerror();

.getIndReg1171:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1172
 call indexerror
;-790 }

.getIndReg1172:
;-791 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al
;-792     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2173
 call indexerror
;-793     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2173:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2174
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2175
 mov ax, 3
 mov [bp-2], al
;-794              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2176
.getIndReg2175:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2177
 mov ax, 1
 mov [bp-2], al
;-795     if (R2No==6) if (rm==6) m=2;//BP+SI

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
;-796              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2180
.getIndReg2179:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2181
 mov ax, 0
 mov [bp-2], al
;-797     if (m > 3) indexerror();

.getIndReg2181:
.getIndReg2180:
.getIndReg2178:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2182
 call indexerror
;-798     return m;

.getIndReg2182:
 mov al, [bp-2]
 jmp .retngetIndReg2
;-799 }

;-800 int getMEM() {// e.g. [array+bp+si-4]

 .retngetIndReg2:
 LEAVE
 ret
ENDP

getMEM: PROC
;-801 //set: disp, rm, R2Type

;-802     char c;

;-803     disp=0; rm=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al
;-804     do {

.getMEM183:
;-805         getTokeType();

 call getTokeType
;-806         c=getOp1();

 call getOp1
 mov [bp-2], al
;-807         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM184
 call syntaxerror
;-808         if (c == REG) {

.getMEM184:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM185
;-809             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al
;-810             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM186
 call getIndReg2
 mov byte [rm], al
;-811             else getIndReg1();

 jmp .getMEM187
.getMEM186:
 call getIndReg1
;-812         }

.getMEM187:
;-813         if (c == ADR) {

.getMEM185:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM188
;-814             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM189
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax
;-815             else notfounderror();

 jmp .getMEM190
.getMEM189:
 call notfounderror
;-816         }

.getMEM190:
;-817         if (c == IMM) disp=disp+SymbolInt;

.getMEM188:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM191
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax
;-818         if (isToken('-')) {

.getMEM191:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM192
;-819             getTokeType();

 call getTokeType
;-820             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM193
 call numbererror
;-821             disp = disp - SymbolInt;

.getMEM193:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax
;-822         }

;-823     } while (isToken('+'));

.getMEM192:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM194
 jmp .getMEM183
.getMEM194:
;-824     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM195
 push getMEM_0
 call errorexit
 add  sp, 2
;-825 }

.getMEM195:
;-826 

;-827 int getOpR() {

 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC
;-828     Op2=getOp1();

 call getOp1
 mov byte [Op2], al
;-829     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR196
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR
;-830     if (Op2 == 0)     {invaloperror();         return;}

.getOpR196:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR197
 call invaloperror
 jmp .retngetOpR
;-831     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR197:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR198
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR
;-832     if (Op2 == REG)                            return;

.getOpR198:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR199
 jmp .retngetOpR
;-833     if (Op2 == ADR)   {

.getOpR199:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR200
;-834         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR201
 mov ax, 0
 mov word [disp], ax
;-835         else disp=LabelAddr[LabelIx];

 jmp .getOpR202
.getOpR201:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-836         return;}

.getOpR202:
 jmp .retngetOpR
;-837     error1("Name of operand expected");

.getOpR200:
 push getOpR_0
 call error1
 add  sp, 2
;-838 }

;-839 

;-840 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC
;-841     getOpR();

 call getOpR
;-842     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al
;-843     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al
;-844     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al
;-845 }

;-846 

;-847 int get2Ops() {

 ret
ENDP

get2Ops: PROC
;-848     getOpL();

 call getOpL
;-849     need(',');

 push 44
 call need
 add  sp, 2
;-850     getOpR();

 call getOpR
;-851 }

;-852 int check2Ops() {

 ret
ENDP

check2Ops: PROC
;-853     get2Ops();

 call get2Ops
;-854     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops203
 call addrerror
;-855     if (Op == ADR) invaloperror();

.check2Ops203:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops204
 call invaloperror
;-856     if (Op == IMM) immeerror();

.check2Ops204:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops205
 call immeerror
;-857     if (Op2==   0) addrerror();

.check2Ops205:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops206
 call addrerror
;-858     setwflag();

.check2Ops206:
 call setwflag
;-859 }

;-860 

;-861 int storeJmp() {

 ret
ENDP

storeJmp: PROC
;-862     unsigned int i;

;-863     JmpMaxIx++;
;
 ENTER  2,0
 inc  word[JmpMaxIx]
;-864     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp207
 push storeJmp_0
 call errorexit
 add  sp, 2
;-865     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp207:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax
;-866     JmpNamePtr++;

 inc  word[JmpNamePtr]
;-867     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax
;-868     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp208
 push storeJmp_1
 call errorexit
 add  sp, 2
;-869     JmpAddr[JmpMaxIx] = PC;

.storeJmp208:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax
;-870 }

;-871 

;-872 int storeLabel() {

 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC
;-873     unsigned int i;

;-874     if(searchLabel()) error1("duplicate label");
;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel209
 push storeLabel_0
 call error1
 add  sp, 2
;-875     LabelMaxIx++;

.storeLabel209:
 inc  word[LabelMaxIx]
;-876     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel210
 push storeLabel_1
 call errorexit
 add  sp, 2
;-877     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel210:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax
;-878     LabelNamePtr++;

 inc  word[LabelNamePtr]
;-879     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax
;-880     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel211
 push storeLabel_2
 call errorexit
 add  sp, 2
;-881     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel211:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-882 }

;-883 

;-884 

;-885 int genDB() {

 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC
;-886     char c;  char isloop;

;-887         isloop = 0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-888             do {

.genDB212:
;-889                 if (isloop) getTokeType();//omit ,

 mov al, [bp-4]
 or  al, al
 je .genDB213
 call getTokeType
;-890                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB213:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB214
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-891                 else {

 jmp .genDB215
.genDB214:
;-892                     skipBlank();

 call skipBlank
;-893                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB216
;-894                         do {

.genDB217:
;-895                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-896                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-897                             InputPtr++;

 inc  word[InputPtr]
;-898                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB218
 jmp .genDB217
.genDB218:
;-899                         InputPtr++;

 inc  word[InputPtr]
;-900                     }

;-901                 }

.genDB216:
;-902                 isloop = 1;

.genDB215:
 mov ax, 1
 mov [bp-4], al
;-903             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB219
 jmp .genDB212
.genDB219:
;-904 }

;-905 

;-906 int getVariable() {

 LEAVE
 ret
ENDP

getVariable: PROC
;-907     char c;

;-908     storeLabel();
;
 ENTER  2,0
 call storeLabel
;-909     getTokeType();

 call getTokeType
;-910     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable220
;-911         lookCode1();

 call lookCode1
;-912         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable221
 call dataexit
;-913         if (CodeType > 205) dataexit();

.getVariable221:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable222
 call dataexit
;-914         if (CodeType== 200) {//DB

.getVariable222:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable223
;-915             do {

.getVariable224:
;-916                 getTokeType();

 call getTokeType
;-917                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable225
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-918                 else {

 jmp .getVariable226
.getVariable225:
;-919                     skipBlank();

 call skipBlank
;-920                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable227
;-921                         do {

.getVariable228:
;-922                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-923                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-924                             InputPtr++;

 inc  word[InputPtr]
;-925                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable229
 jmp .getVariable228
.getVariable229:
;-926                         InputPtr++;

 inc  word[InputPtr]
;-927                     }

;-928                 }

.getVariable227:
;-929             } while (isToken(','));

.getVariable226:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable230
 jmp .getVariable224
.getVariable230:
;-930         }

;-931         if (CodeType == 201) {//DW

.getVariable223:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable231
;-932             do {

.getVariable232:
;-933                 getTokeType();

 call getTokeType
;-934                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable233
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-935             } while (isToken(','));

.getVariable233:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable234
 jmp .getVariable232
.getVariable234:
;-936         }

;-937         if (CodeType == 202) {//DD

.getVariable231:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable235
;-938             do {

.getVariable236:
;-939                 getTokeType();

 call getTokeType
;-940                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable237
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-941                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2
;-942             } while (isToken(','));

.getVariable237:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable238
 jmp .getVariable236
.getVariable238:
;-943         }

;-944         if (CodeType >= 203) {//resb, resw, resd

.getVariable235:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable239
;-945             getTokeType();

 call getTokeType
;-946             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable240
;-947                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable241
 call syntaxerror
;-948                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable241:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable242
 push getVariable_0
 call error1
 add  sp, 2
;-949                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable242:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-950                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable243
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax
;-951                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable243:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable244
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax
;-952                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable244:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-953             } else numbererror();

 jmp .getVariable245
.getVariable240:
 call numbererror
;-954         }

.getVariable245:
;-955     }

.getVariable239:
;-956     else dataexit();

 jmp .getVariable246
.getVariable220:
 call dataexit
;-957 }

.getVariable246:
;-958 

;-959 int getCodeSize() {

 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC
;-960     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize247
;-961         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize248
 call getTokeType
 mov ax, 1
 jmp .retngetCodeSize
;-962         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

.getCodeSize248:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize249
 call getTokeType
 mov ax, 2
 jmp .retngetCodeSize
;-963         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

.getCodeSize249:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize250
 call getTokeType
 mov ax, 3
 jmp .retngetCodeSize
;-964     }

.getCodeSize250:
;-965     return 0;

.getCodeSize247:
 mov ax, 0
 jmp .retngetCodeSize
;-966 }

;-967 

;-968 int FixOneJmp(unsigned int hex) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

FixOneJmp: PROC
;-969     int Ix; char c;

;-970     Ix=searchLabel();
;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax
;-971     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp251
 call notfounderror
;-972     disp = LabelAddr[Ix];

.FixOneJmp251:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-973     c = FileBin[hex];//look for 'A' push Absolute

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al
;-974     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp252
;-975         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax
;-976         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax
;-977         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-978     }

;-979     FileBin[hex] = disp;//fix low byte

.FixOneJmp252:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-980     hex++;

 inc  word[bp+4]
;-981     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax
;-982     FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-983 }

;-984 int fixJmp() {

 LEAVE
 ret
ENDP

fixJmp: PROC
;-985     unsigned int hex; int i;

;-986     char *p;

;-987     p = &JmpNames;
;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax
;-988     i = 1;

 mov ax, 1
 mov [bp-4], ax
;-989     while (i <= JmpMaxIx) {

.fixJmp253:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp254
;-990         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-991         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax
;-992         p++;

 inc  word[bp-6]
;-993         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax
;-994         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2
;-995         i++;

 inc  word[bp-4]
;-996     }

;-997 }

 jmp .fixJmp253
.fixJmp254:
;-998 int fixJmpMain() {

 LEAVE
 ret
ENDP

fixJmpMain: PROC
;-999     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain255
 push fixJmpMain_0
 call error1
 add  sp, 2
;-1000     strcpy(Symbol, "main");

.fixJmpMain255:
 push fixJmpMain_1
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-1001     FixOneJmp(1);//first instruction, PC=1

 push 1
 call FixOneJmp
 add  sp, 2
;-1002 }

;-1003 

;-1004 

;-1005 int process() {

 ret
fixJmpMain_0 db "resting global jmp",0
fixJmpMain_1 db "main",0
ENDP

process: PROC
;-1006     char c;

;-1007     int i;

;-1008     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
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
;-1009     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax
;-1010     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al
;-1011     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType
;-1012     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al
;-1013 

;-1014     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process256
;-1015         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1016         return;

 jmp .retnprocess
;-1017     }

;-1018 

;-1019     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process256:
 mov al, [CodeType]
 cmp al, 2
 jne .process257
;-1020         getOpL();

 call getOpL
;-1021         checkOpL();

 call checkOpL
;-1022         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process258
;-1023   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process259
;-1024                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process260
;-1025                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process261
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4
;-1026                         else   genCode2(0x40, R1No);//INC

 jmp .process262
.process261:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4
;-1027                     return;

.process262:
 jmp .retnprocess
;-1028                     }

;-1029             }

.process260:
;-1030         }

.process259:
;-1031         if (Code1 == 5) {//imul extension?

.process258:
 mov al, [Code1]
 cmp al, 5
 jne .process263
;-1032             getTokeType();

 call getTokeType
;-1033             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process264
 call implerror
;-1034         }

.process264:
;-1035         if (Code1 < 2) genCodeW(0xFE);

.process263:
 mov al, [Code1]
 cmp al, 2
 jge .process265
 push 254
 call genCodeW
 add  sp, 2
;-1036             else genCodeW(0xF6);

 jmp .process266
.process265:
 push 246
 call genCodeW
 add  sp, 2
;-1037         writeEA(Code1);

.process266:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1038         return;

 jmp .retnprocess
;-1039     }

;-1040 

;-1041     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process257:
 mov al, [CodeType]
 cmp al, 3
 jne .process267
;-1042         check2Ops();    //setwflag not applicable

 call check2Ops
;-1043         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process268
 call reg16error
;-1044         if (Op2 != MEM) addrerror();//only m16

.process268:
 mov al, [Op2]
 cmp al, 4
 je  .process269
 call addrerror
;-1045 

;-1046         if (Code1 >= 0xB2) {

.process269:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process270
;-1047             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process271
 push 15
 call genCode8
 add  sp, 2
;-1048         }

.process271:
;-1049         genCode8(Code1);

.process270:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1050         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1051         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1052         return;

 jmp .retnprocess
;-1053     }

;-1054 

;-1055     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process267:
 mov al, [CodeType]
 cmp al, 4
 jne .process272
;-1056         check2Ops();

 call check2Ops
;-1057         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process273
;-1058             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process274
 call notfounderror
;-1059             imme=LabelAddr[LabelIx];

.process274:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax
;-1060             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al
;-1061         }

;-1062         if (Op2 == IMM) {//second operand is imm

.process273:
 mov al, [Op2]
 cmp al, 1
 jne .process275
;-1063             setsflag();

 call setsflag
;-1064             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process276
;-1065                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process277
;-1066                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process278
;-1067                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1068                         c += 4;

 add  byte[bp-2], 4
;-1069                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1070                         genImmediate();

 call genImmediate
;-1071                         return;

 jmp .retnprocess
;-1072                     }

;-1073                 }

.process278:
;-1074             }

.process277:
;-1075             //r/m, imm: 80 sign-extended,TTT,imm

;-1076             c = sflag + 0x80;

.process276:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al
;-1077             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1078             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1079             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process279
 push word [imme]
 call genCode8
 add  sp, 2
;-1080             else genImmediate();

 jmp .process280
.process279:
 call genImmediate
;-1081             return;

.process280:
 jmp .retnprocess
;-1082         }

;-1083         c = Code1 << 3;//r/m, r/r

.process275:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1084         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process281
;-1085             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process282
;-1086                 c += 2;//add direction flag

 add  byte[bp-2], 2
;-1087                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1088                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1089                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1090                 return;

 jmp .retnprocess
;-1091             }

;-1092         }

.process282:
;-1093         if (Op2 == REG) {//mem,reg    reg,reg

.process281:
 mov al, [Op2]
 cmp al, 2
 jne .process283
;-1094             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1095             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1096             return;

 jmp .retnprocess
;-1097         }

;-1098         syntaxerror();

.process283:
 call syntaxerror
;-1099         return;

 jmp .retnprocess
;-1100     }

;-1101 

;-1102     if (CodeType == 5) {//mov (movsx, movzx=51)

.process272:
 mov al, [CodeType]
 cmp al, 5
 jne .process284
;-1103         check2Ops();

 call check2Ops
;-1104         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process285
;-1105             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process286
 mov ax, [disp]
 mov word [imme], ax
;-1106             else notfounderror();

 jmp .process287
.process286:
 call notfounderror
;-1107             Op2=IMM;//continue with IMM

.process287:
 mov ax, 1
 mov byte [Op2], al
;-1108         }

;-1109         if (Op2 == IMM) {// r,i

.process285:
 mov al, [Op2]
 cmp al, 1
 jne .process288
;-1110             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process289
;-1111                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al
;-1112                 c += 0xB0;

 add  byte[bp-2], 176
;-1113                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1114                 genImmediate();

 call genImmediate
;-1115                 return;

 jmp .retnprocess
;-1116             }

;-1117             if (Op == MEM) {// m,i

.process289:
 mov al, [Op]
 cmp al, 4
 jne .process290
;-1118                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2
;-1119                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2
;-1120                 genImmediate();

 call genImmediate
;-1121                 return;

 jmp .retnprocess
;-1122             }

;-1123             regmemerror();

.process290:
 call regmemerror
;-1124             return;

 jmp .retnprocess
;-1125         }

;-1126         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process288:
 mov al, [R1Type]
 cmp al, 4
 jne .process291
 call ChangeDirection
;-1127         if (R2Type == SEGREG) {//rm,sreg

.process291:
 mov al, [R2Type]
 cmp al, 4
 jne .process292
;-1128             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process293
 call reg16error
;-1129                 genCode2(0x8C, dflag);

.process293:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4
;-1130                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1131                 return;

 jmp .retnprocess
;-1132         }

;-1133         if (Op2 == MEM) {//acc, moffs16

.process292:
 mov al, [Op2]
 cmp al, 4
 jne .process294
;-1134             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process295
;-1135                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process296
;-1136                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process297
;-1137                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2
;-1138                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1139                         return;

 jmp .retnprocess
;-1140                     }

;-1141                 }

.process297:
;-1142             }

.process296:
;-1143         }

.process295:
;-1144         if (Op == MEM) {//moffs16, acc

.process294:
 mov al, [Op]
 cmp al, 4
 jne .process298
;-1145             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process299
;-1146                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process300
;-1147                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process301
;-1148                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2
;-1149                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1150                         return;

 jmp .retnprocess
;-1151                     }

;-1152                 }

.process301:
;-1153             }

.process300:
;-1154 

;-1155         }

.process299:
;-1156         if (Op2 == REG) {//rm, r

.process298:
 mov al, [Op2]
 cmp al, 2
 jne .process302
;-1157             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2
;-1158             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1159             return;

 jmp .retnprocess
;-1160         }

;-1161         if (Op2 == MEM) {//r, m

.process302:
 mov al, [Op2]
 cmp al, 4
 jne .process303
;-1162             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process304
;-1163                 ChangeDirection();

 call ChangeDirection
;-1164                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2
;-1165                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1166                 return;

 jmp .retnprocess
;-1167             }

;-1168         }

.process304:
;-1169         syntaxerror();

.process303:
 call syntaxerror
;-1170         return;

 jmp .retnprocess
;-1171     }

;-1172 

;-1173     if (CodeType == 6) {//Jcc

.process284:
 mov al, [CodeType]
 cmp al, 6
 jne .process305
;-1174         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process306
;-1175             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1176             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process307
;-1177                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1178                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1179                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1180                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process308
;-1181                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1182                     disp -= 2;

 sub  word[disp], 2
;-1183                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1184                 } else {

 jmp .process309
.process308:
;-1185                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1186                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1187                     disp -= 4;

 sub  word[disp], 4
;-1188                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1189                 }

;-1190             }

.process309:
;-1191             else {//jump forward, near only

 jmp .process310
.process307:
;-1192                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1193                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1194                 storeJmp();

 call storeJmp
;-1195                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2
;-1196                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al
;-1197             }

;-1198         return;

.process310:
 jmp .retnprocess
;-1199         }

;-1200     }

.process306:
;-1201 

;-1202     if (CodeType == 7) {//jmp, call

.process305:
 mov al, [CodeType]
 cmp al, 7
 jne .process311
;-1203         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process312
;-1204             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1205             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process313
;-1206                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1207                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1208                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1209                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process314
;-1210                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process315
;-1211                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2
;-1212                         disp -= 2;

 sub  word[disp], 2
;-1213                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1214                     }

;-1215                     else {

 jmp .process316
.process315:
;-1216                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1217                         disp -= 3;

 sub  word[disp], 3
;-1218                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1219                     }

;-1220                 }

.process316:
;-1221                 else {

 jmp .process317
.process314:
;-1222                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1223                     disp -= 3;

 sub  word[disp], 3
;-1224                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1225                 }

;-1226             }

.process317:
;-1227             else {//jump forward, near only

 jmp .process318
.process313:
;-1228                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1229                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process319
 call storeJmp
;-1230                 genCode16(0);

.process319:
 push 0
 call genCode16
 add  sp, 2
;-1231                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al
;-1232             }

;-1233         return;

.process318:
 jmp .retnprocess
;-1234         }

;-1235     }

.process312:
;-1236 

;-1237     if (CodeType ==  8) {//ret,retf

.process311:
 mov al, [CodeType]
 cmp al, 8
 jne .process320
;-1238         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process321
;-1239             if (Code1 == 0xC3) genCode8(0xC2);//ret n

 mov al, [Code1]
 cmp al, 195
 jne .process322
 push 194
 call genCode8
 add  sp, 2
;-1240                 else genCode8(0xCA);//retf n

 jmp .process323
.process322:
 push 202
 call genCode8
 add  sp, 2
;-1241             genCode16(SymbolInt);

.process323:
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1242             return;

 jmp .retnprocess
;-1243         }

;-1244         genCode8(Code1);

.process321:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1245         return;

 jmp .retnprocess
;-1246     }

;-1247 

;-1248     if (CodeType == 9) {//push, pop

.process320:
 mov al, [CodeType]
 cmp al, 9
 jne .process324
;-1249         getOpL();

 call getOpL
;-1250         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process325
;-1251             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process326
;-1252                 setsflag();

 call setsflag
;-1253                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4
;-1254                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process327
 push word [imme]
 call genCode8
 add  sp, 2
;-1255                 else       genCode16(imme);

 jmp .process328
.process327:
 push word [imme]
 call genCode16
 add  sp, 2
;-1256                 return;

.process328:
 jmp .retnprocess
;-1257             }

;-1258             if (Op == ADR) {//push string ABSOLUTE i16

.process326:
 mov al, [Op]
 cmp al, 3
 jne .process329
;-1259                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process330
;-1260                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1261                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1262                     return;

 jmp .retnprocess
;-1263                 }

;-1264                 else {

 jmp .process331
.process330:
;-1265                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1266                     storeJmp();

 call storeJmp
;-1267                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2
;-1268                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al
;-1269                     return;

 jmp .retnprocess
;-1270                 }

;-1271             }

.process331:
;-1272         }

.process329:
;-1273         if (R1Type == SEGREG) {

.process325:
 mov al, [R1Type]
 cmp al, 4
 jne .process332
;-1274             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process333
;-1275                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process334
 push process_0
 call error1
 add  sp, 2
;-1276             }

.process334:
;-1277             c = R1No <<3;

.process333:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al
;-1278             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process335
;-1279                 c += 122;  //0x7A

 add  byte[bp-2], 122
;-1280                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1281             }

;-1282             if (Code1 == 0x50) c +=6;//push

.process335:
 mov al, [Code1]
 cmp al, 80
 jne .process336
 add  byte[bp-2], 6
;-1283                 else c += 7;//pop

 jmp .process337
.process336:
 add  byte[bp-2], 7
;-1284             genCode8(c);

.process337:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1285             return;

 jmp .retnprocess
;-1286         }

;-1287         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

.process332:
 call checkOpL
;-1288 

;-1289         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process338
;-1290             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process339
;-1291                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2
;-1292                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2
;-1293             }else {

 jmp .process340
.process339:
;-1294                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2
;-1295                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2
;-1296             }

;-1297             return;

.process340:
 jmp .retnprocess
;-1298         }

;-1299         if (R1Type == BYTE) reg16error();

.process338:
 mov al, [R1Type]
 cmp al, 1
 jne .process341
 call reg16error
;-1300         if (R1Type == WORD) {//is REG, w/o SEGREG

.process341:
 mov al, [R1Type]
 cmp al, 2
 jne .process342
;-1301             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1302             return;

 jmp .retnprocess
;-1303         }

;-1304         syntaxerror();

.process342:
 call syntaxerror
;-1305         return;

 jmp .retnprocess
;-1306     }

;-1307 

;-1308     if (CodeType == 11) {//shift, rotate

.process324:
 mov al, [CodeType]
 cmp al, 11
 jne .process343
;-1309         check2Ops();

 call check2Ops
;-1310         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process344
;-1311             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process345
;-1312                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2
;-1313                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1314                 return;

 jmp .retnprocess
;-1315             }

;-1316             genCodeW(0xC0);//80186

.process345:
 push 192
 call genCodeW
 add  sp, 2
;-1317             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1318             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2
;-1319             return;

 jmp .retnprocess
;-1320         }

;-1321         if (Op2 == REG) {

.process344:
 mov al, [Op2]
 cmp al, 2
 jne .process346
;-1322             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process347
;-1323                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process348
;-1324                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process349
 mov ax, 1
 mov byte [wflag], al
;-1325                     genCodeW(0xD2);

.process349:
 push 210
 call genCodeW
 add  sp, 2
;-1326                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1327                     return;

 jmp .retnprocess
;-1328                 }

;-1329             }

.process348:
;-1330         }

.process347:
;-1331     }

.process346:
;-1332 

;-1333     if (CodeType == 12) {//int

.process343:
 mov al, [CodeType]
 cmp al, 12
 jne .process350
;-1334         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process351
;-1335             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1336             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1337             return;

 jmp .retnprocess
;-1338         }

;-1339     }

.process351:
;-1340 

;-1341     if (CodeType == 14) {//in, out

.process350:
 mov al, [CodeType]
 cmp al, 14
 jne .process352
;-1342         implerror();

 call implerror
;-1343         return;

 jmp .retnprocess
;-1344     }

;-1345     if (CodeType == 15) {//xchg

.process352:
 mov al, [CodeType]
 cmp al, 15
 jne .process353
;-1346         implerror();

 call implerror
;-1347         return;

 jmp .retnprocess
;-1348     }

;-1349     if (CodeType == 16) {//loop

.process353:
 mov al, [CodeType]
 cmp al, 16
 jne .process354
;-1350         implerror();

 call implerror
;-1351         return;

 jmp .retnprocess
;-1352     }

;-1353 

;-1354     if (CodeType == 30) {//enter i18,i8

.process354:
 mov al, [CodeType]
 cmp al, 30
 jne .process355
;-1355         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2
;-1356         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1357         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process356
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1358         else numbererror();

 jmp .process357
.process356:
 call numbererror
;-1359         need(',');

.process357:
 push 44
 call need
 add  sp, 2
;-1360         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1361         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process358
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1362         else numbererror();

 jmp .process359
.process358:
 call numbererror
;-1363         return;

.process359:
 jmp .retnprocess
;-1364     }

;-1365 

;-1366     if (CodeType == 41) {//test

.process355:
 mov al, [CodeType]
 cmp al, 41
 jne .process360
;-1367         implerror();

 call implerror
;-1368         return;

 jmp .retnprocess
;-1369     }

;-1370 

;-1371     if (CodeType == 51) {//movsx, movzx=51

.process360:
 mov al, [CodeType]
 cmp al, 51
 jne .process361
;-1372         implerror();

 call implerror
;-1373         return;

 jmp .retnprocess
;-1374     }

;-1375 

;-1376     if (CodeType==101) {//ORG nn

.process361:
 mov al, [CodeType]
 cmp al, 101
 jne .process362
;-1377         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process363
 call numbererror
;-1378         Origin=SymbolInt;

.process363:
 mov ax, [SymbolInt]
 mov word [Origin], ax
;-1379         return;

 jmp .retnprocess
;-1380     }

;-1381 

;-1382     if (CodeType == 102) {//section, segment

.process362:
 mov al, [CodeType]
 cmp al, 102
 jne .process364
;-1383         //getTokeType();//ignore .bss .text .data

;-1384         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax
;-1385         return;

 jmp .retnprocess
;-1386     }

;-1387 

;-1388     if (CodeType == 110) {//absolute

.process364:
 mov al, [CodeType]
 cmp al, 110
 jne .process365
;-1389         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process366
 call numbererror
;-1390         AbsoluteLab=SymbolInt;

.process366:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-1391         return;

 jmp .retnprocess
;-1392     }

;-1393     if (CodeType == 111) {//name: PROC

.process365:
 mov al, [CodeType]
 cmp al, 111
 jne .process367
;-1394         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process368
;-1395             prs("\nentering: ");

 push process_1
 call prs
 add  sp, 2
;-1396             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2
;-1397             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al
;-1398             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax
;-1399             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax
;-1400             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax
;-1401             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax
;-1402         } else error1("already in PROC");

 jmp .process369
.process368:
 push process_2
 call error1
 add  sp, 2
;-1403         return;

.process369:
 jmp .retnprocess
;-1404     }

;-1405     if (CodeType == 112) {//ENDP

.process367:
 mov al, [CodeType]
 cmp al, 112
 jne .process370
;-1406         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process371
 push process_3
 call error1
 add  sp, 2
;-1407         prs("\nleaving: ");

.process371:
 push process_4
 call prs
 add  sp, 2
;-1408         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2
;-1409         prs(", loc labels: ");

 push process_5
 call prs
 add  sp, 2
;-1410         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax
;-1411         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2
;-1412         prs(", loc jmp forward: ");

 push process_6
 call prs
 add  sp, 2
;-1413         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax
;-1414         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2
;-1415         fixJmp();

 call fixJmp
;-1416         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1417         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax
;-1418         LabelMaxIx   = tmpLabelMaxIx;

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax
;-1419         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax
;-1420         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax
;-1421         return;

 jmp .retnprocess
;-1422     }

;-1423     if (CodeType == 200) {//db

.process370:
 mov al, [CodeType]
 cmp al, 200
 jne .process372
;-1424         genDB();

 call genDB
;-1425         return;

 jmp .retnprocess
;-1426     }

;-1427 

;-1428     error1("Command not implemented or syntax error");

.process372:
 push process_7
 call error1
 add  sp, 2
;-1429 }

;-1430 

;-1431 int parse() {

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
;-1432     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax
;-1433     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax
;-1434     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax
;-1435     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax
;-1436     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax
;-1437     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1438     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al
;-1439 

;-1440     do {//process a new line

.parse373:
;-1441         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax
;-1442         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al
;-1443         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax
;-1444         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al
;-1445         getLine();

 call getLine
;-1446         if (DOS_NoBytes) {

 mov ax, [DOS_NoBytes]
 or  al, al
 je .parse374
;-1447             InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax
;-1448             getTokeType();//getCode in SymbolUpper,

 call getTokeType
;-1449                           //set TokeType,isLabel by getName

;-1450             if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse375
;-1451                 if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse376
;-1452                   if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse377
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4
;-1453                     storeLabel();

.parse377:
 call storeLabel
;-1454                     InputPtr++;//remove :

 inc  word[InputPtr]
;-1455                     getTokeType();

 call getTokeType
;-1456                 }

;-1457             }

.parse376:
;-1458             if (TokeType == ALNUME) {

.parse375:
 mov al, [TokeType]
 cmp al, 3
 jne .parse378
;-1459                 lookCode1();

 call lookCode1
;-1460                 if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse379
 call process
;-1461                 else getVariable();

 jmp .parse380
.parse379:
 call getVariable
;-1462                 skipRest();

.parse380:
 call skipRest
;-1463             }

;-1464             else if(TokeType >ALNUME)error1(

 jmp .parse381
.parse378:
 mov al, [TokeType]
 cmp al, 3
 jle .parse382
;-1465                 "Label or instruction expected");

 push parse_0
 call error1
 add  sp, 2
;-1466             else if(TokeType==DIGIT )error1("No digit allowed at start");

 jmp .parse383
.parse382:
 mov al, [TokeType]
 cmp al, 1
 jne .parse384
 push parse_1
 call error1
 add  sp, 2
;-1467             printLine();

.parse384:
.parse383:
.parse381:
 call printLine
;-1468         }

;-1469     } while (DOS_NoBytes != 0 );

.parse374:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse385
 jmp .parse373
.parse385:
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
;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax
;-1476     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg386
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

.getarg386:
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
;-1493     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg387
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
;-1494     lst_fd=creatR(namelst);

.getarg387:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax
;-1495     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg388
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
;-1496     bin_fd=creatR(namebin);

.getarg388:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax
;-1497     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg389
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
;-1498 

;-1499     prs(";");

.getarg389:
 push getarg_7
 call prs
 add  sp, 2
;-1500     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2
;-1501     prs(", Input: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2
;-1502     prs(", ");

 push getarg_9
 call prs
 add  sp, 2
;-1503 }

;-1504 

;-1505 int main() {

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
getarg_8 db ", Input: ",0
getarg_9 db ", ",0
ENDP

main: PROC
;-1506     getarg();

 call getarg
;-1507     parse();

 call parse
;-1508     fixJmpMain();

 call fixJmpMain
;-1509     epilog();

 call epilog
;-1510     end1();

 call end1
;-1511 }

 ret
ENDP
;Glob. variables:159 (400), Functions:88 (400), Lines:1512
;Constant: 658 (3000), stacksize: 3382