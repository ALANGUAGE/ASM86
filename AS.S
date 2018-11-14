;PLA compiler A.COM V0.9.5, Input: AS.C, Output: AS.S
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

;-92 int writetty()     {//ah=0x0E; bx=0; __emit__(0xCD,0x10);


writetty: PROC
;-93 asm mov ah, 14

 mov ah, 14
;-94 asm mov bx, 0

 mov bx, 0
;-95 asm int 16

 int 16
;-96 }

;-97 int putch(char c)  {

 ret
ENDP

putch: PROC
;-98     if (c==10)  {
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .putch1
;-99         asm mov al, 13

 mov al, 13
;-100         writetty();

 call writetty
;-101     }

;-102     asm mov al, [bp+4]; parameter c

.putch1:
 mov al, [bp+4]; parameter c
;-103     writetty();

 call writetty
;-104 }

;-105 int cputs(char *s) {

 LEAVE
 ret
ENDP

cputs: PROC
;-106     char c;

;-107     while(*s) {
;
 ENTER  2,0
.cputs2:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs3
;-108         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-109         putch(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
;-110         s++;

 inc  word[bp+4]
;-111     }

;-112 }

 jmp .cputs2
.cputs3:
;-113 int mkneg(int n)   {

 LEAVE
 ret
ENDP

mkneg: PROC
;-114     asm mov ax, [bp+4]; parameter n
;
 ENTER  0,0
 mov ax, [bp+4]; parameter n
;-115     asm neg ax

 neg ax
;-116 }

;-117 

;-118 int DosInt() {

 LEAVE
 ret
ENDP

DosInt: PROC
;-119     asm int 33; 21h

 int 33; 21h
;-120     __emit__(0x73, 04); //jnc over DOS_ERR++

 db 115,4
;-121     DOS_ERR++;

 inc  word[DOS_ERR]
;-122 }

;-123 int openR (char *s) {

 ret
ENDP

openR: PROC
;-124     asm mov dx, [bp+4]; dx=s;
;
 ENTER  0,0
 mov dx, [bp+4]; dx=s;
;-125     asm mov ax, 15618; ax=0x3D02;

 mov ax, 15618; ax=0x3D02;
;-126     DosInt();

 call DosInt
;-127 }

;-128 int creatR(char *s) {

 LEAVE
 ret
ENDP

creatR: PROC
;-129     asm mov dx, [bp+4]; dx=s;
;
 ENTER  0,0
 mov dx, [bp+4]; dx=s;
;-130     asm mov cx, 0

 mov cx, 0
;-131     asm mov ax, 15360; ax=0x3C00;

 mov ax, 15360; ax=0x3C00;
;-132     DosInt();

 call DosInt
;-133 }

;-134 int fcloseR(int fd) {

 LEAVE
 ret
ENDP

fcloseR: PROC
;-135     asm mov bx, [bp+4]; bx=fd;
;
 ENTER  0,0
 mov bx, [bp+4]; bx=fd;
;-136     asm mov ax, 15872; ax=0x3E00;

 mov ax, 15872; ax=0x3E00;
;-137     DosInt();

 call DosInt
;-138 }

;-139 int exitR  (char c) {

 LEAVE
 ret
ENDP

exitR: PROC
;-140     asm mov ah, 76; ah=0x4C;
;
 ENTER  0,0
 mov ah, 76; ah=0x4C;
;-141     asm mov al, [bp+4]; al=c;

 mov al, [bp+4]; al=c;
;-142     DosInt();

 call DosInt
;-143 }

;-144 int readRL(char *s, int fd, int len){

 LEAVE
 ret
ENDP

readRL: PROC
;-145     asm mov dx, [bp+4]; dx=s;
;
 ENTER  0,0
 mov dx, [bp+4]; dx=s;
;-146     asm mov cx, [bp+8]; cx=len;

 mov cx, [bp+8]; cx=len;
;-147     asm mov bx, [bp+6]; bx=fd;

 mov bx, [bp+6]; bx=fd;
;-148     asm mov ax, 16128;  ax=0x3F00;

 mov ax, 16128;  ax=0x3F00;
;-149     DosInt();

 call DosInt
;-150 }

;-151 int fputcR(char *n, int fd) {

 LEAVE
 ret
ENDP

fputcR: PROC
;-152     asm lea dx, [bp+4]; *n  todo: why not mov ?????
;
 ENTER  0,0
 lea dx, [bp+4]; *n  todo: why not mov ?????
;-153     asm mov cx, 1;      cx=1;

 mov cx, 1;      cx=1;
;-154     asm mov bx, [bp+6]; bx=fd;

 mov bx, [bp+6]; bx=fd;
;-155     asm mov ax, 16384;  ax=0x4000;

 mov ax, 16384;  ax=0x4000;
;-156     DosInt();

 call DosInt
;-157 }

;-158 

;-159 int letterE(char c) {

 LEAVE
 ret
ENDP

letterE: PROC
;-160   if (c=='_') return 1;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE4
 mov ax, 1
 jmp .retnletterE
;-161   if (c=='.') return 1;

.letterE4:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE5
 mov ax, 1
 jmp .retnletterE
;-162   if (c=='?') return 1;

.letterE5:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE6
 mov ax, 1
 jmp .retnletterE
;-163   if (c=='$') return 1;

.letterE6:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE7
 mov ax, 1
 jmp .retnletterE
;-164   if (c> 'z') return 0;

.letterE7:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE8
 mov ax, 0
 jmp .retnletterE
;-165   if (c< '@') return 0; // at included

.letterE8:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE9
 mov ax, 0
 jmp .retnletterE
;-166   if (c> 'Z') { if (c< 'a') return 0; }

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
;-167   return 1;

.letterE10:
 mov ax, 1
 jmp .retnletterE
;-168 }

;-169 int digit(char c){

 .retnletterE:
 LEAVE
 ret
ENDP

digit: PROC
;-170     if(c<'0') return 0;
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit12
 mov ax, 0
 jmp .retndigit
;-171     if(c>'9') return 0;

.digit12:
 mov al, [bp+4]
 cmp al, 57
 jle .digit13
 mov ax, 0
 jmp .retndigit
;-172     return 1;

.digit13:
 mov ax, 1
 jmp .retndigit
;-173 }

;-174 int alnumE(char c) {

 .retndigit:
 LEAVE
 ret
ENDP

alnumE: PROC
;-175   if (digit(c)) return 1;
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
;-176   if (letterE(c)) return 1;

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
;-177   return 0;

.alnumE15:
 mov ax, 0
 jmp .retnalnumE
;-178 }

;-179 int strlen(char *s) { int c;

 .retnalnumE:
 LEAVE
 ret
ENDP

strlen: PROC
;-180     c=0;
;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax
;-181     while (*s!=0) {s++; c++;}

.strlen16:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen17
 inc  word[bp+4]
 inc  word[bp-2]
;-182     return c;

 jmp .strlen16
.strlen17:
 mov ax, [bp-2]
 jmp .retnstrlen
;-183     }

;-184 int strcpy(char *s, char *t) {

 .retnstrlen:
 LEAVE
 ret
ENDP

strcpy: PROC
;-185     do { *s=*t; s++; t++; }
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
;-186     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy19
 jmp .strcpy18
.strcpy19:
;-187     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al
;-188     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy
;-189     }

;-190 int eqstr(char *p, char *q) {

 .retnstrcpy:
 LEAVE
 ret
ENDP

eqstr: PROC
;-191     while(*p) {
;
 ENTER  0,0
.eqstr20:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr21
;-192         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr22
 mov ax, 0
 jmp .retneqstr
;-193             p++;

.eqstr22:
 inc  word[bp+4]
;-194             q++;

 inc  word[bp+6]
;-195             }

;-196     if(*q) return 0;

 jmp .eqstr20
.eqstr21:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr23
 mov ax, 0
 jmp .retneqstr
;-197     return 1;

.eqstr23:
 mov ax, 1
 jmp .retneqstr
;-198     }

;-199 int strcat1(char *s, char *t) {

 .retneqstr:
 LEAVE
 ret
ENDP

strcat1: PROC
;-200     while (*s != 0) s++;
;
 ENTER  0,0
.strcat124:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat125
 inc  word[bp+4]
;-201     strcpy(s, t);

 jmp .strcat124
.strcat125:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4
;-202     }

;-203 int toupper(char *s) {

 LEAVE
 ret
ENDP

toupper: PROC
;-204     while(*s) {
;
 ENTER  0,0
.toupper26:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper27
;-205         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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
;-206             s++;

.toupper29:
.toupper28:
 inc  word[bp+4]
;-207               }

;-208     }

 jmp .toupper26
.toupper27:
;-209 

;-210 int testReg() {

 LEAVE
 ret
ENDP

testReg: PROC
;-211 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD

;-212   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al
;-213   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg30
 mov ax, 0
 jmp .retntestReg
;-214   if (strlen(Symbol) > 3) return 0;

.testReg30:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg31
 mov ax, 0
 jmp .retntestReg
;-215   R2Type=BYTE;

.testReg31:
 mov ax, 1
 mov byte [R2Type], al
;-216   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg32
 mov ax, 0
 jmp .retntestReg
;-217   if (eqstr(SymbolUpper, "CL")) return 1;

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
;-218   if (eqstr(SymbolUpper, "DL")) return 2;

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
;-219   if (eqstr(SymbolUpper, "BL")) return 3;

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
;-220   if (eqstr(SymbolUpper, "AH")) return 4;

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
;-221   if (eqstr(SymbolUpper, "CH")) return 5;

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
;-222   if (eqstr(SymbolUpper, "DH")) return 6;

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
;-223   if (eqstr(SymbolUpper, "BH")) return 7;

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
;-224   R2Type=WORD;

.testReg39:
 mov ax, 2
 mov byte [R2Type], al
;-225   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg40
 mov ax, 0
 jmp .retntestReg
;-226   if (eqstr(SymbolUpper, "CX")) return 1;

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
;-227   if (eqstr(SymbolUpper, "DX")) return 2;

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
;-228   if (eqstr(SymbolUpper, "BX")) return 3;

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
;-229   if (eqstr(SymbolUpper, "SP")) return 4;

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
;-230   if (eqstr(SymbolUpper, "BP")) return 5;

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
;-231   if (eqstr(SymbolUpper, "SI")) return 6;

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
;-232   if (eqstr(SymbolUpper, "DI")) return 7;

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
;-233   R2Type=SEGREG;

.testReg47:
 mov ax, 4
 mov byte [R2Type], al
;-234   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg48
 mov ax, 0
 jmp .retntestReg
;-235   if (eqstr(SymbolUpper, "CS")) return 1;

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
;-236   if (eqstr(SymbolUpper, "SS")) return 2;

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
;-237   if (eqstr(SymbolUpper, "DS")) return 3;

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
;-238   if (eqstr(SymbolUpper, "FS")) return 4;

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
;-239   if (eqstr(SymbolUpper, "GS")) return 5;

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
;-240   R2Type=DWORD;

.testReg53:
 mov ax, 3
 mov byte [R2Type], al
;-241   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg54
 mov ax, 0
 jmp .retntestReg
;-242   if (eqstr(SymbolUpper, "ECX"))return 1;

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
;-243   if (eqstr(SymbolUpper, "EDX"))return 2;

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
;-244   if (eqstr(SymbolUpper, "EBX"))return 3;

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
;-245   if (eqstr(SymbolUpper, "ESP"))return 4;

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
;-246   if (eqstr(SymbolUpper, "EBP"))return 5;

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
;-247   if (eqstr(SymbolUpper, "ESI"))return 6;

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
;-248   if (eqstr(SymbolUpper, "EDI"))return 7;

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
;-249   R2Type=0; return 0;

.testReg61:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg
;-250 }

;-251 

;-252 

;-253 int prc(unsigned char c) {//print char

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
;-254     if (isPrint) {
;
 ENTER  0,0
 mov al, [isPrint]
 or  al, al
 je .prc62
;-255         if (c==10) {

 mov al, [bp+4]
 cmp al, 10
 jne .prc63
;-256             asm mov ax, 13

 mov ax, 13
;-257             writetty();

 call writetty
;-258             }

;-259         asm mov al, [bp+4]; al=c;

.prc63:
 mov al, [bp+4]; al=c;
;-260         writetty();

 call writetty
;-261     }

;-262     fputcR(c,lst_fd);

.prc62:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-263 }

;-264 

;-265 int prscomment(unsigned char *s) {

 LEAVE
 ret
ENDP

prscomment: PROC
;-266     unsigned char c;

;-267     while (*s){
;
 ENTER  2,0
.prscomment64:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment65
;-268         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-269         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-270         s++;

 inc  word[bp+4]
;-271     }

;-272 }

 jmp .prscomment64
.prscomment65:
;-273 int prs(unsigned char *s) {

 LEAVE
 ret
ENDP

prs: PROC
;-274     unsigned char c;

;-275     int com;

;-276     com=0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax
;-277     while (*s) {

.prs66:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs67
;-278         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-279         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs68
;-280             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs69
 mov ax, 0
 mov [bp-4], ax
;-281                 else com=1;

 jmp .prs70
.prs69:
 mov ax, 1
 mov [bp-4], ax
;-282         }

.prs70:
;-283         if (c==92) {

.prs68:
 mov al, [bp-2]
 cmp al, 92
 jne .prs71
;-284             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs72
;-285                 s++;

 inc  word[bp+4]
;-286                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-287                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs73
 mov ax, 10
 mov [bp-2], al
;-288                 if (c=='t') c= 9;

.prs73:
 mov al, [bp-2]
 cmp al, 116
 jne .prs74
 mov ax, 9
 mov [bp-2], al
;-289             }

.prs74:
;-290         }

.prs72:
;-291         prc(c);

.prs71:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-292         s++;

 inc  word[bp+4]
;-293     }

;-294 }

 jmp .prs66
.prs67:
;-295 int printhex4(unsigned char c) {

 LEAVE
 ret
ENDP

printhex4: PROC
;-296     c += 48;
;
 ENTER  0,0
 add  byte[bp+4], 48
;-297     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex475
 add  byte[bp+4], 7
;-298     prc(c);

.printhex475:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-299 }

;-300 int printhex8a(unsigned char c) {

 LEAVE
 ret
ENDP

printhex8a: PROC
;-301     unsigned char nib;

;-302     nib = c >> 4; printhex4(nib);
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
;-303     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2
;-304 }

;-305 int printhex16(unsigned int i) {

 LEAVE
 ret
ENDP

printhex16: PROC
;-306     unsigned int half;

;-307     half = i >>  8; printhex8a(half);
;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2
;-308     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2
;-309 }

;-310 int printIntU(unsigned int n) {

 LEAVE
 ret
ENDP

printIntU: PROC
;-311     unsigned int e;

;-312     if (n >= 10) {
;
 ENTER  2,0
 mov ax, [bp+4]
 cmp ax, 10 ;unsigned : 0
 jb  .printIntU76
;-313         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax
;-314         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2
;-315     }

;-316     n = n % 10; //unsigned mod

.printIntU76:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax
;-317     n += '0';

 add  word[bp+4], 48
;-318     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2
;-319 }

;-320 int printLine() {

 LEAVE
 ret
ENDP

printLine: PROC
;-321     int i; char c;

;-322     prs("\n");
;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2
;-323     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2
;-324     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine77
 push printLine_1
 call prs
 add  sp, 2
;-325     else {

 jmp .printLine78
.printLine77:
;-326 //        prc(' ');

;-327         i=0;

 mov ax, 0
 mov [bp-2], ax
;-328         do {

.printLine79:
;-329             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al
;-330             prc(' ');

 push 32
 call prc
 add  sp, 2
;-331             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2
;-332             i++;

 inc  word[bp-2]
;-333         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine80
 jmp .printLine79
.printLine80:
;-334         while (i < OPMAXLEN) {// fill rest with blank

.printLine81:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine82
;-335             prs("   ");

 push printLine_2
 call prs
 add  sp, 2
;-336             i++;

 inc  word[bp-2]
;-337         }

;-338     }

 jmp .printLine81
.printLine82:
;-339     prc(PrintRA);

.printLine78:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-340     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2
;-341 }

;-342 

;-343 int epilog() {

 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

epilog: PROC
;-344     unsigned int i; char c;     int j;

;-345     isPrint=1;
;
 ENTER  6,0
 mov ax, 1
 mov byte [isPrint], al
;-346     prs("Errors:");

 push epilog_0
 call prs
 add  sp, 2
;-347     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2
;-348     if (ErrorCount) prs("\n****** ERRORS *** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog83
 push epilog_1
 call prs
 add  sp, 2
;-349     prs("\nOutput: ");

.epilog83:
 push epilog_2
 call prs
 add  sp, 2
;-350     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2
;-351     prs(", ");

 push epilog_3
 call prs
 add  sp, 2
;-352     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2
;-353     prs("= ");

 push epilog_4
 call prs
 add  sp, 2
;-354     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2
;-355     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2
;-356     i=0;

 mov ax, 0
 mov [bp-2], ax
;-357     do {

.epilog84:
;-358         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al
;-359         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4
;-360         i++;

 inc  word[bp-2]
;-361     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog85
 jmp .epilog84
.epilog85:
;-362 }

;-363 

;-364 int end1(int n) {

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
;-365     fcloseR(asm_fd);
;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2
;-366     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2
;-367     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2
;-368     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2
;-369 }

;-370 

;-371 

;-372 int error1(char *s) {

 LEAVE
 ret
ENDP

error1: PROC
;-373     isPrint=1;
;
 ENTER  0,0
 mov ax, 1
 mov byte [isPrint], al
;-374     ErrorCount++;

 inc  word[ErrorCount]
;-375     prs("\n\n******* next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2
;-376     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2
;-377     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2
;-378     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2
;-379 }

;-380 int errorexit(char *s) {

 LEAVE
 ret
error1_0 db "\n\n******* next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC
;-381     error1(s);
;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2
;-382     epilog();

 call epilog
;-383     end1(1);

 push 1
 call end1
 add  sp, 2
;-384 }

;-385 int dataexit(){errorexit("DB,DW,DD or RESB,W,D expected");}

 LEAVE
 ret
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2
;-386 

;-387 int notfounderror(){

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

notfounderror: PROC
;-388     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al
;-389     ErrorCount++;

 inc  word[ErrorCount]
;-390     prs("\n\n******* ERROR: label not found: ");

 push notfounderror_0
 call prs
 add  sp, 2
;-391     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2
;-392     prs(" ");

 push notfounderror_1
 call prs
 add  sp, 2
;-393 }

;-394 int addrerror()    {error1("address missing");}

 ret
notfounderror_0 db "\n\n******* ERROR: label not found: ",0
notfounderror_1 db " ",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2
;-395 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2
;-396 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2
;-397 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2
;-398 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2
;-399 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2
;-400 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2
;-401 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2
;-402 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2
;-403 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2
;-404 

;-405 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 ret
syntaxerror_0 db "syntax",0
ENDP

ifEOL: PROC
;-406   if (c == 10) return 1;//LF
;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL86
 mov ax, 1
 jmp .retnifEOL
;-407   if (c == 13) {//CR

.ifEOL86:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL87
;-408     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-409     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL88
 push ifEOL_0
 call errorexit
 add  sp, 2
;-410     return 1;

.ifEOL88:
 mov ax, 1
 jmp .retnifEOL
;-411   }

;-412   return 0;

.ifEOL87:
 mov ax, 0
 jmp .retnifEOL
;-413 }

;-414 int getLine() {// make ASCIIZ, skip LF=10 and CR=13

 .retnifEOL:
 LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

getLine: PROC
;-415   unsigned int i;

;-416   InputPtr= &InputBuf;
;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax
;-417   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-418   do {

.getLine89:
;-419     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax
;-420     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine90
 push getLine_0
 call errorexit
 add  sp, 2
;-421     if (DOS_NoBytes == 0) return;

.getLine90:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine91
 jmp .retngetLine
;-422     *InputPtr = DOS_ByteRead;

.getLine91:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al
;-423     InputPtr++;

 inc  word[InputPtr]
;-424     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax
;-425     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine92
 push getLine_1
 call errorexit
 add  sp, 2
;-426   } while (ifEOL(DOS_ByteRead) == 0);

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
;-427   InputPtr--;

 dec  word[InputPtr]
;-428   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al
;-429 }

;-430 int skipBlank() {

 .retngetLine:
 LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

skipBlank: PROC
;-431   skipblank1:

.skipblank1:
;-432     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank94
 inc  word[InputPtr]
 jmp .skipblank1
;-433     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank94:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank95
 inc  word[InputPtr]
 jmp .skipblank1
;-434 }

.skipBlank95:
;-435 

;-436 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
ENDP

getDigit: PROC
;-437   unsigned int CastInt;

;-438   SymbolInt=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax
;-439   do {

.getDigit96:
;-440     c-='0';

 sub  byte[bp+4], 48
;-441     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax
;-442     asm mov ax, 0

 mov ax, 0
;-443     CastInt=c; //cast b2w

 mov al, [bp+4]
 mov [bp-2], ax
;-444     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax
;-445     InputPtr++;

 inc  word[InputPtr]
;-446     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-447   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit97
 jmp .getDigit96
.getDigit97:
;-448 }

;-449 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel

 LEAVE
 ret
ENDP

getName: PROC
;-450   char *p; unsigned int i;

;-451   p = &Symbol;
;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax
;-452   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-453   p++;

 inc  word[bp-2]
;-454   while (alnumE(c)) {

.getName98:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName99
;-455     InputPtr++;

 inc  word[InputPtr]
;-456     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al
;-457     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al
;-458     p++;

 inc  word[bp-2]
;-459     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax
;-460     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName100
 push getName_0
 call errorexit
 add  sp, 2
;-461   }

.getName100:
;-462   if (c == ':') isLabel=1; else isLabel=0;

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
;-463   p--;

.getName102:
 dec  word[bp-2]
;-464   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al
;-465   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4
;-466   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2
;-467 }

;-468 

;-469 //OpName, 0, CodeType, Code1

;-470 //  1:   1 byte opcod

;-471 char T00[]={'P','U','S','H','A',0,1,0x60, 'P','O','P','A',0,    1,0x61};

 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP
T00 db 80,85,83,72,65,0,1,96,80,79,80,65,0,1,97
;-472 char T01[]={'N','O','P',0,        1,0x90, 'C','B','W',0,        1,0x98};

T01 db 78,79,80,0,1,144,67,66,87,0,1,152
;-473 char T02[]={'C','W','D','E',0,    1,0x98, 'C','W','D',0,        1,0x99};

T02 db 67,87,68,69,0,1,152,67,87,68,0,1,153
;-474 char T03[]={'C','D','Q',0,        1,0x99, 'W','A','I','T',0,    1,0x9B};

T03 db 67,68,81,0,1,153,87,65,73,84,0,1,155
;-475 char T04[]={'P','U','S','H','F',0,1,0x9C, 'P','O','P','F',0,    1,0x9D};

T04 db 80,85,83,72,70,0,1,156,80,79,80,70,0,1,157
;-476 char T05[]={'S','A','H','F',0,    1,0x9E, 'L','A','H','F',0,    1,0x9F};

T05 db 83,65,72,70,0,1,158,76,65,72,70,0,1,159
;-477 char T06[]={'M','O','V','S','B',0,1,0xA4, 'M','O','V','S','W',0,1,0xA5};

T06 db 77,79,86,83,66,0,1,164,77,79,86,83,87,0,1,165
;-478 char T07[]={'C','M','P','S','B',0,1,0xA6, 'C','M','P','S','W',0,1,0xA7};

T07 db 67,77,80,83,66,0,1,166,67,77,80,83,87,0,1,167
;-479 char T08[]={'S','T','O','S','B',0,1,0xAA, 'S','T','O','S','W',0,1,0xAB};

T08 db 83,84,79,83,66,0,1,170,83,84,79,83,87,0,1,171
;-480 char T09[]={'L','O','D','S','B',0,1,0xAC, 'L','O','D','S','W',0,1,0xAD};

T09 db 76,79,68,83,66,0,1,172,76,79,68,83,87,0,1,173
;-481 char T10[]={'S','C','A','S','B',0,1,0xAE, 'S','C','A','S','W',0,1,0xAF};

T10 db 83,67,65,83,66,0,1,174,83,67,65,83,87,0,1,175
;-482 char T11[]={'L','E','A','V','E',0,1,0xC9, 'I','N','T','3',0,    1,0xCC};

T11 db 76,69,65,86,69,0,1,201,73,78,84,51,0,1,204
;-483 char T12[]={'I','N','T','O',0,    1,0xCE, 'I','R','E','T',0,    1,0xCF};

T12 db 73,78,84,79,0,1,206,73,82,69,84,0,1,207
;-484 char T13[]={'X','L','A','T',0,    1,0xD7, 'L','O','C','K',0,    1,0xF0};

T13 db 88,76,65,84,0,1,215,76,79,67,75,0,1,240
;-485 char T14[]={'R','E','P','N','E',0,1,0xF2, 'R','E','P','N','Z',0,1,0xF2};

T14 db 82,69,80,78,69,0,1,242,82,69,80,78,90,0,1,242
;-486 char T15[]={'R','E','P','E',0,    1,0xF3, 'R','E','P','Z',0,    1,0xF3};

T15 db 82,69,80,69,0,1,243,82,69,80,90,0,1,243
;-487 char T16[]={'H','L','T',0,        1,0xF4, 'C','L','C',0,        1,0xF8};

T16 db 72,76,84,0,1,244,67,76,67,0,1,248
;-488 char T17[]={'S','T','C',0,        1,0xF9, 'C','L','I',0,        1,0xFA};

T17 db 83,84,67,0,1,249,67,76,73,0,1,250
;-489 char T18[]={'S','T','I',0,        1,0xFB, 'C','L','D',0,        1,0xFC};

T18 db 83,84,73,0,1,251,67,76,68,0,1,252
;-490 char T19[]={'S','T','D',0,        1,0xFD};

T19 db 83,84,68,0,1,253
;-491 // 2: mem reg 16 bit

;-492 char T20[]={'I','N','C',0,        2, 0,   'D','E','C',0,        2, 1};

T20 db 73,78,67,0,2,0,68,69,67,0,2,1
;-493 char T21[]={'N','O','T',0,        2, 2,   'N','E','G',0,        2, 3};

T21 db 78,79,84,0,2,2,78,69,71,0,2,3
;-494 char T22[]={'M','U','L',0,        2, 4,   'I','M','U','L',0,    2, 5};//acc

T22 db 77,85,76,0,2,4,73,77,85,76,0,2,5
;-495 char T23[]={'D','I','V',0,        2, 6,   'I','D','I','V',0,    2, 7};

T23 db 68,73,86,0,2,6,73,68,73,86,0,2,7
;-496 //  3: les, lda, lea, lss, lfs, lgs

;-497 char T24[]={'L','E','S',0,        3,0xC4, 'L','D','S',0,        3,0xC5};

T24 db 76,69,83,0,3,196,76,68,83,0,3,197
;-498 char T25[]={'L','E','A',0,        3,0x8D, 'L','S','S',0,        3,0xB2};

T25 db 76,69,65,0,3,141,76,83,83,0,3,178
;-499 char T26[]={'L','F','S',0,        3,0xB4, 'L','G','S',0,        3,0xB5};

T26 db 76,70,83,0,3,180,76,71,83,0,3,181
;-500 //  4: acc,imm  reg,imm  index,reg

;-501 char T27[]={'A','D','D',0,        4, 0,   'O','R',0,            4, 1};

T27 db 65,68,68,0,4,0,79,82,0,4,1
;-502 char T28[]={'A','D','C',0,        4, 2,   'S','B','B',0,        4, 3};

T28 db 65,68,67,0,4,2,83,66,66,0,4,3
;-503 char T29[]={'A','N','D',0,        4, 4,   'S','U','B',0,        4, 5};

T29 db 65,78,68,0,4,4,83,85,66,0,4,5
;-504 char T30[]={'X','O','R',0,        4, 6,   'C','M','P',0,        4, 7};

T30 db 88,79,82,0,4,6,67,77,80,0,4,7
;-505 //  5: mov

;-506 char T31[]={'M','O','V',0,        5, 0};

T31 db 77,79,86,0,5,0
;-507 //  6: single byte relative jump

;-508 char T32[]={'J','O',0,            6, 0,    'J','N','O',0,       6, 1};

T32 db 74,79,0,6,0,74,78,79,0,6,1
;-509 char T33[]={'J','B',0,            6, 2,    'J','C',0,           6, 2};

T33 db 74,66,0,6,2,74,67,0,6,2
;-510 char T34[]={'J','N','B',0,        6, 3};

T34 db 74,78,66,0,6,3
;-511 char T35[]={'J','A','E',0,        6, 3,    'J','N','C',0,       6, 3};

T35 db 74,65,69,0,6,3,74,78,67,0,6,3
;-512 char T36[]={'J','E',0,            6, 4,    'J','Z',0,           6, 4};

T36 db 74,69,0,6,4,74,90,0,6,4
;-513 char T37[]={'J','N','E',0,        6, 5,    'J','N','Z',0,       6, 5};

T37 db 74,78,69,0,6,5,74,78,90,0,6,5
;-514 char T38[]={'J','B','E',0,        6, 6,    'J','N','A',0,       6, 6};

T38 db 74,66,69,0,6,6,74,78,65,0,6,6
;-515 char T39[]={'J','A',0,            6, 7,    'J','S',0,           6, 8};

T39 db 74,65,0,6,7,74,83,0,6,8
;-516 char T40[]={'J','N','S',0,        6, 9};

T40 db 74,78,83,0,6,9
;-517 char T41[]={'J','P',0,            6,10,    'J','P','E',0,       6,10};

T41 db 74,80,0,6,10,74,80,69,0,6,10
;-518 char T42[]={'J','N','P',0,        6,11,    'J','P','O',0,       6,11};

T42 db 74,78,80,0,6,11,74,80,79,0,6,11
;-519 char T43[]={'J','L',0,            6,12};

T43 db 74,76,0,6,12
;-520 char T44[]={'J','N','L',0,        6,13,    'J','G','E',0,       6,13};

T44 db 74,78,76,0,6,13,74,71,69,0,6,13
;-521 char T45[]={'J','L','E',0,        6,14,    'J','N','G',0,       6,14};

T45 db 74,76,69,0,6,14,74,78,71,0,6,14
;-522 char T46[]={'J','G',0,            6,15};

T46 db 74,71,0,6,15
;-523 //  7: jmp, call

;-524 char T47[]={'J','M','P',0,        7,0xE9,  'C','A','L','L',0,   7,0xE8};

T47 db 74,77,80,0,7,233,67,65,76,76,0,7,232
;-525 //  8: ret

;-526 char T48[]={'R','E','T',0,        8,0xC3,  'R','E','T','F',0,   8,0xCB};

T48 db 82,69,84,0,8,195,82,69,84,70,0,8,203
;-527 //  9: seg, r/m

;-528 char T49[]={'P','U','S','H',0,    9,0x50,  'P','O','P',0,       9,0x58};

T49 db 80,85,83,72,0,9,80,80,79,80,0,9,88
;-529 //  11: shift, rotates

;-530 char T50[]={'R','O','L',0,       11, 0,    'R','O','R',0,      11, 1};

T50 db 82,79,76,0,11,0,82,79,82,0,11,1
;-531 char T51[]={'R','C','L',0,       11, 2,    'R','C','R',0,      11, 3};

T51 db 82,67,76,0,11,2,82,67,82,0,11,3
;-532 char T52[]={'S','H','L',0,       11, 4,    'S','A','L',0,      11, 4};

T52 db 83,72,76,0,11,4,83,65,76,0,11,4
;-533 char T53[]={'S','H','R',0,       11, 5,    'S','A','R',0,      11, 7};

T53 db 83,72,82,0,11,5,83,65,82,0,11,7
;-534 //  12: int

;-535 char T54[]={'I','N','T',0,       12,0xCD};

T54 db 73,78,84,0,12,205
;-536 //  14: in/out                   not implemented

;-537 char T55[]={'I','N',0,           14,0xE4,  'I','N','S','B',0,  14,0x6C};

T55 db 73,78,0,14,228,73,78,83,66,0,14,108
;-538 char T56[]={'I','N','S','W',0,   14,0x6D,  'I','N','S','D',0,  14,0x6D};

T56 db 73,78,83,87,0,14,109,73,78,83,68,0,14,109
;-539 char T57[]={'O','U','T',0,       14,0xE6,  'O','U','T','B',0,  14,0x6E};

T57 db 79,85,84,0,14,230,79,85,84,66,0,14,110
;-540 char T58[]={'O','U','T','W',0,   14,0x6F,  'O','U','T','D',0,  14,0x6F};

T58 db 79,85,84,87,0,14,111,79,85,84,68,0,14,111
;-541 //  15: xch                      not implemented

;-542 char T59[]={'X','C','H','G',0,   15,0x86};

T59 db 88,67,72,71,0,15,134
;-543 //  16: loop, jcxz               not implemented

;-544 char T60[]={'L','O','O','P','N','Z',0,16,0xE0,'L','O','O','P','N','E',0,16,0xE0};

T60 db 76,79,79,80,78,90,0,16,224,76,79,79,80,78,69,0,16,224
;-545 char T61[]={'L','O','O','P','Z',0,16,0xE1,'L','O','O','P','E',0,16,0xE1};

T61 db 76,79,79,80,90,0,16,225,76,79,79,80,69,0,16,225
;-546 char T62[]={'L','O','O','P',0,    16,0xE2};

T62 db 76,79,79,80,0,16,226
;-547 char T63[]={'J','C','X','Z',0,    16,0xE3,'J','E','C','X','Z',0,16,0xE3};

T63 db 74,67,88,90,0,16,227,74,69,67,88,90,0,16,227
;-548 //  30: other

;-549 char T64[]={'E','N','T','E','R',0,30,0};

T64 db 69,78,84,69,82,0,30,0
;-550 //                                not implemented

;-551 char T65[]={'T','E','S','T',0,    41,0xF6};

T65 db 84,69,83,84,0,41,246
;-552 char T66[]={'M','O','V','S','X',0,51,0xBE,'M','O','V','Z','X',0,51,0xB6};

T66 db 77,79,86,83,88,0,51,190,77,79,86,90,88,0,51,182
;-553 // 100: directives

;-554 char T67[]={'O','R','G',0,      101, 0};

T67 db 79,82,71,0,101,0
;-555 // section, segment .TEXT .DATA .BSS

;-556 char T68[]={'S','E','C','T','I','O','N',0,      102, 0};

T68 db 83,69,67,84,73,79,78,0,102,0
;-557 char T69[]={'S','E','G','M','E','N','T',0,      102, 0};

T69 db 83,69,71,77,69,78,84,0,102,0
;-558 char T70[]={'A','B','S','O','L','U','T','E',0,  110, 0};

T70 db 65,66,83,79,76,85,84,69,0,110,0
;-559 char T71[]={'P','R','O','C',0,    111, 0, 'E','N','D','P',0, 112, 0};

T71 db 80,82,79,67,0,111,0,69,78,68,80,0,112,0
;-560 char T72[]={'D','B',0,            200, 0, 'D','W',0,         201, 0};

T72 db 68,66,0,200,0,68,87,0,201,0
;-561 char T73[]={'D','D',0,            202, 0, 'R','E','S','B',0, 203, 0};

T73 db 68,68,0,202,0,82,69,83,66,0,203,0
;-562 char T74[]={'R','E','S','W',0,    204, 0, 'R','E','S','D',0, 205, 0};

T74 db 82,69,83,87,0,204,0,82,69,83,68,0,205,0
;-563 char TEND=0;// end of table char

TEND db 0
;-564 

;-565 int lookCode1() {//ret: CodeType, Code1


lookCode1: PROC
;-566     OpCodePtr= &T00;

 mov ax, T00
 mov word [OpCodePtr], ax
;-567     do  {

.lookCode1103:
;-568         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode1104
;-569             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1105:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1106
 inc  word[OpCodePtr]
;-570             OpCodePtr++;

 jmp .lookCode1105
.lookCode1106:
 inc  word[OpCodePtr]
;-571             CodeType = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al
;-572             OpCodePtr++;

 inc  word[OpCodePtr]
;-573             Code1    = *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al
;-574             return;

 jmp .retnlookCode1
;-575         }

;-576         while(*OpCodePtr!=0) OpCodePtr++;

.lookCode1104:
.lookCode1107:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1108
 inc  word[OpCodePtr]
;-577         OpCodePtr += 3;

 jmp .lookCode1107
.lookCode1108:
 add  word[OpCodePtr], 3
;-578 

;-579         } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode1109
 jmp .lookCode1103
.lookCode1109:
;-580     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al
;-581 }

;-582 

;-583 

;-584 int genCode8(char c) {

 .retnlookCode1:
 ret
ENDP

genCode8: PROC
;-585 //set: BinLen++, OpPrintIndex++

;-586     FileBin[BinLen]=c;
;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
;-587     BinLen++;

 inc  word[BinLen]
;-588     PC++;

 inc  word[PC]
;-589     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 22000 ;unsigned : 0
 jb  .genCode8110
 push genCode8_0
 call errorexit
 add  sp, 2
;-590     if (OpPrintIndex < OPMAXLEN) {

.genCode8110:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8111
;-591         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
;-592         OpPrintIndex++;

 inc  word[OpPrintIndex]
;-593     }

;-594 }

.genCode8111:
;-595 int gen66h() {genCode8(0x66);

 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2
;-596 }

;-597 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC
;-598     c = c + d;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al
;-599     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-600 }

;-601 int genCodeW(char c) {

 LEAVE
 ret
ENDP

genCodeW: PROC
;-602     c = c + wflag;
;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al
;-603     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-604 }

;-605 int genCode16(unsigned int i) {

 LEAVE
 ret
ENDP

genCode16: PROC
;-606     genCode8(i); i=i >> 8;
;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax
;-607     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2
;-608 }

;-609 int genCode32(unsigned long L) {

 LEAVE
 ret
ENDP

genCode32: PROC
;-610     genCode16(L); L=L >>16;
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
;-611     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
;-612 }

;-613 int writeEA(char xxx) {//value for reg/operand

 LEAVE
 ret
ENDP

writeEA: PROC
;-614 //need: Op, Op2, disp, R1No, R2No, rm, isDirect

;-615 //mod-bits: mode76, reg/opcode543, r/m210

;-616 //Op: 0, IMM, REG, ADR, MEM

;-617     int disploc;

;-618     char len;

;-619     len=0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-620     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al
;-621     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA112
;-622         xxx |= 0xC0;

 or  byte[bp+4], 192
;-623         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA113
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-624             else {

 jmp .writeEA114
.writeEA113:
;-625                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA115
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al
;-626                 else            xxx = xxx + R2No;

 jmp .writeEA116
.writeEA115:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al
;-627             }

.writeEA116:
;-628         }

.writeEA114:
;-629     if (Op == MEM) {

.writeEA112:
 mov al, [Op]
 cmp al, 4
 jne .writeEA117
;-630         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA118
;-631             xxx |= 6;

 or  byte[bp+4], 6
;-632             len = 2;

 mov ax, 2
 mov [bp-4], al
;-633         }

;-634         else {

 jmp .writeEA119
.writeEA118:
;-635             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al
;-636             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA120
;-637                 len=1;

 mov ax, 1
 mov [bp-4], al
;-638                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA121
 or  byte[bp+4], 64
;-639             }

.writeEA121:
;-640 

;-641             if (disp) {

.writeEA120:
 mov ax, [disp]
 or  al, al
 je .writeEA122
;-642                 disploc=disp;

 mov ax, [disp]
 mov [bp-2], ax
;-643                 if (disploc  < 0) disploc=mkneg(disploc);

 mov ax, [bp-2]
 cmp ax, 0
 jge .writeEA123
 push word [bp-2]
 call mkneg
 add  sp, 2
 mov [bp-2], ax
;-644                 if (disploc > 127) len=2;

.writeEA123:
 mov ax, [bp-2]
 cmp ax, 127
 jle .writeEA124
 mov ax, 2
 mov [bp-4], al
;-645                 else len=1;

 jmp .writeEA125
.writeEA124:
 mov ax, 1
 mov [bp-4], al
;-646                 if (len == 1) xxx |= 0x40;

.writeEA125:
 mov al, [bp-4]
 cmp al, 1
 jne .writeEA126
 or  byte[bp+4], 64
;-647                 else xxx |= 0x80;

 jmp .writeEA127
.writeEA126:
 or  byte[bp+4], 128
;-648             }

.writeEA127:
;-649         }

.writeEA122:
;-650     }

.writeEA119:
;-651 

;-652     genCode8(xxx);// gen second byte

.writeEA117:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-653     if (len == 1) genCode8 (disp);

 mov al, [bp-4]
 cmp al, 1
 jne .writeEA128
 push word [disp]
 call genCode8
 add  sp, 2
;-654     if (len == 2) genCode16(disp);

.writeEA128:
 mov al, [bp-4]
 cmp al, 2
 jne .writeEA129
 push word [disp]
 call genCode16
 add  sp, 2
;-655 }

.writeEA129:
;-656 

;-657 int genImmediate() {

 LEAVE
 ret
ENDP

genImmediate: PROC
;-658     if (wflag) if (OpSize == DWORD) genCode32(imme);

 mov al, [wflag]
 or  al, al
 je .genImmediate130
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate131
 push word [imme]
 call genCode32
 add  sp, 2
;-659         //todo imme long

;-660         else genCode16(imme);

 jmp .genImmediate132
.genImmediate131:
 push word [imme]
 call genCode16
 add  sp, 2
;-661     else       genCode8 (imme);

.genImmediate132:
 jmp .genImmediate133
.genImmediate130:
 push word [imme]
 call genCode8
 add  sp, 2
;-662 }

.genImmediate133:
;-663 

;-664 int setwflag() {//word size, bit 0

 ret
ENDP

setwflag: PROC
;-665     wflag=0;

 mov ax, 0
 mov byte [wflag], al
;-666     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag134
;-667         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag135
 mov al, [R1Type]
 mov byte [OpSize], al
;-668         if (Op2== REG) OpSize=R2Type;

.setwflag135:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag136
 mov al, [R2Type]
 mov byte [OpSize], al
;-669         if (R2Type== SEGREG) OpSize=WORD;

.setwflag136:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag137
 mov ax, 2
 mov byte [OpSize], al
;-670         if (R1Type == SEGREG) OpSize=WORD;

.setwflag137:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag138
 mov ax, 2
 mov byte [OpSize], al
;-671     }

.setwflag138:
;-672     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag134:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag139
 call gen66h
 mov ax, 1
 mov byte [wflag], al
;-673     if (OpSize  ==  WORD) wflag=1;

.setwflag139:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag140
 mov ax, 1
 mov byte [wflag], al
;-674 }

.setwflag140:
;-675 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC
;-676     unsigned int ui;

;-677     sflag=2;
;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al
;-678     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax
;-679     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag141
 mov ax, 0
 mov byte [sflag], al
;-680     if (OpSize == BYTE) {

.setsflag141:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag142
;-681         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag143
 push setsflag_0
 call error1
 add  sp, 2
;-682         sflag=0;//byte reg does not need sign extended

.setsflag143:
 mov ax, 0
 mov byte [sflag], al
;-683     }

;-684 }

.setsflag142:
;-685 int checkConstSize(unsigned int ui) {

 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC
;-686     if (ui > 127   ) return 0;//is near; return sflag
;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize144
 mov ax, 0
 jmp .retncheckConstSize
;-687     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize144:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize145
 mov ax, 0
 jmp .retncheckConstSize
;-688     return 2;// is short

.checkConstSize145:
 mov ax, 2
 jmp .retncheckConstSize
;-689 }

;-690 

;-691 

;-692 int ChangeDirection() {

 .retncheckConstSize:
 LEAVE
 ret
ENDP

ChangeDirection: PROC
;-693     char c;

;-694     c=Op;     Op    =Op2;    Op2   =c;
;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al
;-695     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al
;-696     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al
;-697     dflag=2;

 mov ax, 2
 mov byte [dflag], al
;-698 }

;-699 

;-700 int getTokeType() {

 LEAVE
 ret
ENDP

getTokeType: PROC
;-701     char c;

;-702     skipBlank();
;
 ENTER  2,0
 call skipBlank
;-703     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-704     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType146
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-705     if (c == ';') {TokeType=0; return; }//comment

.getTokeType146:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType147
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType
;-706     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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
;-707     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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
;-708     TokeType=NOALNUME;

.getTokeType149:
 mov ax, 4
 mov byte [TokeType], al
;-709 }

;-710 

;-711 int isToken(char c) {

 .retngetTokeType:
 LEAVE
 ret
ENDP

isToken: PROC
;-712     skipBlank();
;
 ENTER  0,0
 call skipBlank
;-713     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken150
;-714         InputPtr++;

 inc  word[InputPtr]
;-715         return 1;

 mov ax, 1
 jmp .retnisToken
;-716         }

;-717     return 0;

.isToken150:
 mov ax, 0
 jmp .retnisToken
;-718 }

;-719 

;-720 

;-721 int need(char c) {

 .retnisToken:
 LEAVE
 ret
ENDP

need: PROC
;-722     if (isToken(c)) {
;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need151
;-723         getTokeType();

 call getTokeType
;-724         return;

 jmp .retnneed
;-725         }

;-726     error1();

.need151:
 call error1
;-727     prs(". need: ");

 push need_0
 call prs
 add  sp, 2
;-728     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
;-729 }

;-730 int skipRest() {

 .retnneed:
 LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC
;-731     getTokeType();

 call getTokeType
;-732     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest152
 push skipRest_0
 call error1
 add  sp, 2
;-733 }

.skipRest152:
;-734 

;-735 

;-736 int checkOpL() {

 ret
skipRest_0 db "extra char ignored",0
ENDP

checkOpL: PROC
;-737     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL153
 call implerror
;-738     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL153:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL154
 call segregerror
 jmp .retncheckOpL
;-739     setwflag();

.checkOpL154:
 call setwflag
;-740     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL155
 push checkOpL_0
 call error1
 add  sp, 2
;-741     if (OpSize == R1Type) return;

.checkOpL155:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL156
 jmp .retncheckOpL
;-742     if (Op == REG) if (R1Type==0) error1("no register defined");

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
;-743 }

.checkOpL158:
.checkOpL157:
;-744 

;-745 int searchLabel() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

searchLabel: PROC
;-746     int LIx; char *p;

;-747     p = &LabelNames;
;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax
;-748     LIx = 1;

 mov ax, 1
 mov [bp-2], ax
;-749     while (LIx <= LabelMaxIx) {

.searchLabel159:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel160
;-750         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel161
 mov ax, [bp-2]
 jmp .retnsearchLabel
;-751         p=strlen(p) + p;

.searchLabel161:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax
;-752         p++;

 inc  word[bp-4]
;-753         LIx++;

 inc  word[bp-2]
;-754     }

;-755     return 0;

 jmp .searchLabel159
.searchLabel160:
 mov ax, 0
 jmp .retnsearchLabel
;-756 }

;-757 

;-758 int getOp1() {//scan for a single operand

 .retnsearchLabel:
 LEAVE
 ret
ENDP

getOp1: PROC
;-759 //return:0, IMM, REG, ADR (not MEM)

;-760 //set   :R2Type, R2No by testReg

;-761 //set   :LabelIx by searchLabel

;-762     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp1162
 mov ax, 0
 jmp .retngetOp1
;-763     if (TokeType == DIGIT)  return IMM;

.getOp1162:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp1163
 mov ax, 1
 jmp .retngetOp1
;-764     if (TokeType == ALNUME) {

.getOp1163:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp1164
;-765         R2No=testReg();

 call testReg
 mov byte [R2No], al
;-766         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp1165
 mov ax, 2
 jmp .retngetOp1
;-767         LabelIx=searchLabel();

.getOp1165:
 call searchLabel
 mov word [LabelIx], ax
;-768         return ADR;

 mov ax, 3
 jmp .retngetOp1
;-769     }

;-770     return 0;

.getOp1164:
 mov ax, 0
 jmp .retngetOp1
;-771 }

;-772 

;-773 int getIndReg1() {

 .retngetOp1:
 ret
ENDP

getIndReg1: PROC
;-774     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg1166
 call indexerror
;-775     if (R2No==3) rm=7;//BX

.getIndReg1166:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg1167
 mov ax, 7
 mov byte [rm], al
;-776     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg1167:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg1168
 mov ax, 6
 mov byte [rm], al
;-777     if (R2No==7) rm=5;//DI

.getIndReg1168:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg1169
 mov ax, 5
 mov byte [rm], al
;-778     if (R2No==6) rm=4;//SI

.getIndReg1169:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg1170
 mov ax, 4
 mov byte [rm], al
;-779     if (rm==0) indexerror();

.getIndReg1170:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg1171
 call indexerror
;-780 }

.getIndReg1171:
;-781 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al
;-782     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg2172
 call indexerror
;-783     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg2172:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg2173
 mov al, [rm]
 cmp al, 6
 jne .getIndReg2174
 mov ax, 3
 mov [bp-2], al
;-784              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg2175
.getIndReg2174:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2176
 mov ax, 1
 mov [bp-2], al
;-785     if (R2No==6) if (rm==6) m=2;//BP+SI

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
;-786              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg2179
.getIndReg2178:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg2180
 mov ax, 0
 mov [bp-2], al
;-787     if (m > 3) indexerror();

.getIndReg2180:
.getIndReg2179:
.getIndReg2177:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg2181
 call indexerror
;-788     return m;

.getIndReg2181:
 mov al, [bp-2]
 jmp .retngetIndReg2
;-789 }

;-790 int getMEM() {// e.g. [array+bp+si-4]

 .retngetIndReg2:
 LEAVE
 ret
ENDP

getMEM: PROC
;-791 //set: disp, rm, R2Type

;-792     char c;

;-793     disp=0; rm=0;
;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al
;-794     do {

.getMEM182:
;-795         getTokeType();

 call getTokeType
;-796         c=getOp1();

 call getOp1
 mov [bp-2], al
;-797         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM183
 call syntaxerror
;-798         if (c == REG) {

.getMEM183:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM184
;-799             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al
;-800             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM185
 call getIndReg2
 mov byte [rm], al
;-801             else getIndReg1();

 jmp .getMEM186
.getMEM185:
 call getIndReg1
;-802         }

.getMEM186:
;-803         if (c == ADR) {

.getMEM184:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM187
;-804             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM188
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax
;-805             else notfounderror();

 jmp .getMEM189
.getMEM188:
 call notfounderror
;-806         }

.getMEM189:
;-807         if (c == IMM) disp=disp+SymbolInt;

.getMEM187:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM190
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax
;-808         if (isToken('-')) {

.getMEM190:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM191
;-809             getTokeType();

 call getTokeType
;-810             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM192
 call numbererror
;-811             disp = disp - SymbolInt;

.getMEM192:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax
;-812         }

;-813     } while (isToken('+'));

.getMEM191:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM193
 jmp .getMEM182
.getMEM193:
;-814     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM194
 push getMEM_0
 call errorexit
 add  sp, 2
;-815 }

.getMEM194:
;-816 

;-817 int getOpR() {

 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getOpR: PROC
;-818     Op2=getOp1();

 call getOp1
 mov byte [Op2], al
;-819     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR195
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR
;-820     if (Op2 == 0)     {invaloperror();         return;}

.getOpR195:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR196
 call invaloperror
 jmp .retngetOpR
;-821     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR196:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR197
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR
;-822     if (Op2 == REG)                            return;

.getOpR197:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR198
 jmp .retngetOpR
;-823     if (Op2 == ADR)   {

.getOpR198:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR199
;-824         if (LabelIx == 0) disp=0;

 mov ax, [LabelIx]
 cmp ax, 0
 jne .getOpR200
 mov ax, 0
 mov word [disp], ax
;-825         else disp=LabelAddr[LabelIx];

 jmp .getOpR201
.getOpR200:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-826         return;}

.getOpR201:
 jmp .retngetOpR
;-827     error1("Name of operand expected");

.getOpR199:
 push getOpR_0
 call error1
 add  sp, 2
;-828 }

;-829 

;-830 int getOpL() {//set: op=0,IMM,REG,ADR,MEM

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOpL: PROC
;-831     getOpR();

 call getOpR
;-832     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al
;-833     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al
;-834     R1Type=R2Type;  R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al
;-835 }

;-836 

;-837 int get2Ops() {

 ret
ENDP

get2Ops: PROC
;-838     getOpL();

 call getOpL
;-839     need(',');

 push 44
 call need
 add  sp, 2
;-840     getOpR();

 call getOpR
;-841 }

;-842 int check2Ops() {

 ret
ENDP

check2Ops: PROC
;-843     get2Ops();

 call get2Ops
;-844     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops202
 call addrerror
;-845     if (Op == ADR) invaloperror();

.check2Ops202:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops203
 call invaloperror
;-846     if (Op == IMM) immeerror();

.check2Ops203:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops204
 call immeerror
;-847     if (Op2==   0) addrerror();

.check2Ops204:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops205
 call addrerror
;-848     setwflag();

.check2Ops205:
 call setwflag
;-849 }

;-850 

;-851 int storeJmp() {

 ret
ENDP

storeJmp: PROC
;-852     unsigned int i;

;-853     JmpMaxIx++;
;
 ENTER  2,0
 inc  word[JmpMaxIx]
;-854     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp206
 push storeJmp_0
 call errorexit
 add  sp, 2
;-855     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp206:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax
;-856     JmpNamePtr++;

 inc  word[JmpNamePtr]
;-857     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax
;-858     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp207
 push storeJmp_1
 call errorexit
 add  sp, 2
;-859     JmpAddr[JmpMaxIx] = PC;

.storeJmp207:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax
;-860 }

;-861 

;-862 int storeLabel() {

 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC
;-863     unsigned int i;

;-864     if(searchLabel()) error1("duplicate label");
;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel208
 push storeLabel_0
 call error1
 add  sp, 2
;-865     LabelMaxIx++;

.storeLabel208:
 inc  word[LabelMaxIx]
;-866     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel209
 push storeLabel_1
 call errorexit
 add  sp, 2
;-867     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel209:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax
;-868     LabelNamePtr++;

 inc  word[LabelNamePtr]
;-869     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax
;-870     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel210
 push storeLabel_2
 call errorexit
 add  sp, 2
;-871     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel210:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-872 }

;-873 

;-874 

;-875 int genDB() {

 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

genDB: PROC
;-876     char c;  char isloop;

;-877         isloop = 0;
;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], al
;-878             do {

.genDB211:
;-879                 if (isloop) getTokeType();//omit ,

 mov al, [bp-4]
 or  al, al
 je .genDB212
 call getTokeType
;-880                 if (TokeType == DIGIT) genCode8(SymbolInt);

.genDB212:
 mov al, [TokeType]
 cmp al, 1
 jne .genDB213
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-881                 else {

 jmp .genDB214
.genDB213:
;-882                     skipBlank();

 call skipBlank
;-883                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .genDB215
;-884                         do {

.genDB216:
;-885                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-886                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-887                             InputPtr++;

 inc  word[InputPtr]
;-888                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .genDB217
 jmp .genDB216
.genDB217:
;-889                         InputPtr++;

 inc  word[InputPtr]
;-890                     }

;-891                 }

.genDB215:
;-892                 isloop = 1;

.genDB214:
 mov ax, 1
 mov [bp-4], al
;-893             } while (isToken(','));

 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .genDB218
 jmp .genDB211
.genDB218:
;-894 }

;-895 

;-896 int getVariable() {

 LEAVE
 ret
ENDP

getVariable: PROC
;-897     char c;

;-898     storeLabel();
;
 ENTER  2,0
 call storeLabel
;-899     getTokeType();

 call getTokeType
;-900     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable219
;-901         lookCode1();

 call lookCode1
;-902         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable220
 call dataexit
;-903         if (CodeType > 205) dataexit();

.getVariable220:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable221
 call dataexit
;-904         if (CodeType== 200) {//DB

.getVariable221:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable222
;-905             do {

.getVariable223:
;-906                 getTokeType();

 call getTokeType
;-907                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable224
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-908                 else {

 jmp .getVariable225
.getVariable224:
;-909                     skipBlank();

 call skipBlank
;-910                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable226
;-911                         do {

.getVariable227:
;-912                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al
;-913                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-914                             InputPtr++;

 inc  word[InputPtr]
;-915                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable228
 jmp .getVariable227
.getVariable228:
;-916                         InputPtr++;

 inc  word[InputPtr]
;-917                     }

;-918                 }

.getVariable226:
;-919             } while (isToken(','));

.getVariable225:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable229
 jmp .getVariable223
.getVariable229:
;-920         }

;-921         if (CodeType == 201) {//DW

.getVariable222:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable230
;-922             do {

.getVariable231:
;-923                 getTokeType();

 call getTokeType
;-924                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable232
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-925             } while (isToken(','));

.getVariable232:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable233
 jmp .getVariable231
.getVariable233:
;-926         }

;-927         if (CodeType == 202) {//DD

.getVariable230:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable234
;-928             do {

.getVariable235:
;-929                 getTokeType();

 call getTokeType
;-930                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable236
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-931                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2
;-932             } while (isToken(','));

.getVariable236:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable237
 jmp .getVariable235
.getVariable237:
;-933         }

;-934         if (CodeType >= 203) {//resb, resw, resd

.getVariable234:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable238
;-935             getTokeType();

 call getTokeType
;-936             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable239
;-937                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable240
 call syntaxerror
;-938                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable240:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable241
 push getVariable_0
 call error1
 add  sp, 2
;-939                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable241:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax
;-940                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable242
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax
;-941                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable242:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable243
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax
;-942                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable243:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-943             } else numbererror();

 jmp .getVariable244
.getVariable239:
 call numbererror
;-944         }

.getVariable244:
;-945     }

.getVariable238:
;-946     else dataexit();

 jmp .getVariable245
.getVariable219:
 call dataexit
;-947 }

.getVariable245:
;-948 

;-949 int getCodeSize() {

 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC
;-950     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize246
;-951         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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
;-952         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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
;-953         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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
;-954     }

.getCodeSize249:
;-955     return 0;

.getCodeSize246:
 mov ax, 0
 jmp .retngetCodeSize
;-956 }

;-957 

;-958 int FixOneJmp(unsigned int hex) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

FixOneJmp: PROC
;-959     int Ix; char c;

;-960     Ix=searchLabel();
;
 ENTER  4,0
 call searchLabel
 mov [bp-2], ax
;-961     if (Ix == 0) notfounderror();

 mov ax, [bp-2]
 cmp ax, 0
 jne .FixOneJmp250
 call notfounderror
;-962     disp = LabelAddr[Ix];

.FixOneJmp250:
 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-963     c = FileBin[hex];//look for 'A' push Absolute

 mov bx, [bp+4]
 mov al, [FileBin + bx]
 mov [bp-4], al
;-964     if (c != 0xAA) {

 mov al, [bp-4]
 cmp al, 170
 je  .FixOneJmp251
;-965         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp+4]
 mov word [disp], ax
;-966         disp = disp -2;//PC points to next instruction

 mov ax, [disp]
 sub ax, 2
 mov word [disp], ax
;-967         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-968     }

;-969     FileBin[hex] = disp;//fix low byte

.FixOneJmp251:
 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-970     hex++;

 inc  word[bp+4]
;-971     disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax
;-972     FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp+4]
 mov [FileBin+bx], al
;-973 }

;-974 int fixJmp() {

 LEAVE
 ret
ENDP

fixJmp: PROC
;-975     unsigned int hex; int i;

;-976     char *p;

;-977     p = &JmpNames;
;
 ENTER  6,0
 mov ax, JmpNames
 mov [bp-6], ax
;-978     i = 1;

 mov ax, 1
 mov [bp-4], ax
;-979     while (i <= JmpMaxIx) {

.fixJmp252:
 mov ax, [bp-4]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp253
;-980         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-981         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax
;-982         p++;

 inc  word[bp-6]
;-983         hex = JmpAddr[i];

 mov bx, [bp-4]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-2], ax
;-984         FixOneJmp(hex);

 push word [bp-2]
 call FixOneJmp
 add  sp, 2
;-985         i++;

 inc  word[bp-4]
;-986     }

;-987 }

 jmp .fixJmp252
.fixJmp253:
;-988 int fixJmpMain() {

 LEAVE
 ret
ENDP

fixJmpMain: PROC
;-989     if (JmpMaxIx ) error1("resting global jmp");

 mov ax, [JmpMaxIx]
 or  al, al
 je .fixJmpMain254
 push fixJmpMain_0
 call error1
 add  sp, 2
;-990     strcpy(Symbol, "main");

.fixJmpMain254:
 push fixJmpMain_1
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4
;-991     FixOneJmp(1);//first instruction, PC=1

 push 1
 call FixOneJmp
 add  sp, 2
;-992 }

;-993 

;-994 

;-995 int process() {

 ret
fixJmpMain_0 db "resting global jmp",0
fixJmpMain_1 db "main",0
ENDP

process: PROC
;-996     char c;

;-997     int i;

;-998     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
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
;-999     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax
;-1000     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al
;-1001     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType
;-1002     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al
;-1003 

;-1004     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process255
;-1005         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1006         return;

 jmp .retnprocess
;-1007     }

;-1008 

;-1009     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process255:
 mov al, [CodeType]
 cmp al, 2
 jne .process256
;-1010         getOpL();

 call getOpL
;-1011         checkOpL();

 call checkOpL
;-1012         if (Code1 < 2) {//inc,dec

 mov al, [Code1]
 cmp al, 2
 jge .process257
;-1013   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process258
;-1014                 if (wflag) {

 mov al, [wflag]
 or  al, al
 je .process259
;-1015                     if (Code1) genCode2(0x48, R1No);//DEC

 mov al, [Code1]
 or  al, al
 je .process260
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 72
 call genCode2
 add  sp, 4
;-1016                         else   genCode2(0x40, R1No);//INC

 jmp .process261
.process260:
 mov al, byte [R1No]
 mov ah, 0
 push ax
 push 64
 call genCode2
 add  sp, 4
;-1017                     return;

.process261:
 jmp .retnprocess
;-1018                     }

;-1019             }

.process259:
;-1020         }

.process258:
;-1021         if (Code1 == 5) {//imul extension?

.process257:
 mov al, [Code1]
 cmp al, 5
 jne .process262
;-1022             getTokeType();

 call getTokeType
;-1023             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process263
 call implerror
;-1024         }

.process263:
;-1025         if (Code1 < 2) genCodeW(0xFE);

.process262:
 mov al, [Code1]
 cmp al, 2
 jge .process264
 push 254
 call genCodeW
 add  sp, 2
;-1026             else genCodeW(0xF6);

 jmp .process265
.process264:
 push 246
 call genCodeW
 add  sp, 2
;-1027         writeEA(Code1);

.process265:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1028         return;

 jmp .retnprocess
;-1029     }

;-1030 

;-1031     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process256:
 mov al, [CodeType]
 cmp al, 3
 jne .process266
;-1032         check2Ops();    //setwflag not applicable

 call check2Ops
;-1033         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process267
 call reg16error
;-1034         if (Op2 != MEM) addrerror();//only m16

.process267:
 mov al, [Op2]
 cmp al, 4
 je  .process268
 call addrerror
;-1035 

;-1036         if (Code1 >= 0xB2) {

.process268:
 mov al, [Code1]
 cmp al, 178 ;unsigned : 1
 jl  .process269
;-1037             if (Code1 <= 0xB5) genCode8(0x0F);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 181
 jg  .process270
 push 15
 call genCode8
 add  sp, 2
;-1038         }

.process270:
;-1039         genCode8(Code1);

.process269:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1040         Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1041         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1042         return;

 jmp .retnprocess
;-1043     }

;-1044 

;-1045     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process266:
 mov al, [CodeType]
 cmp al, 4
 jne .process271
;-1046         check2Ops();

 call check2Ops
;-1047         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process272
;-1048             if (LabelIx == 0) notfounderror();

 mov ax, [LabelIx]
 cmp ax, 0
 jne .process273
 call notfounderror
;-1049             imme=LabelAddr[LabelIx];

.process273:
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [imme], ax
;-1050             Op2=IMM;//got the addr and fall through

 mov ax, 1
 mov byte [Op2], al
;-1051         }

;-1052         if (Op2 == IMM) {//second operand is imm

.process272:
 mov al, [Op2]
 cmp al, 1
 jne .process274
;-1053             setsflag();

 call setsflag
;-1054             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process275
;-1055                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process276
;-1056                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process277
;-1057                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1058                         c += 4;

 add  byte[bp-2], 4
;-1059                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1060                         genImmediate();

 call genImmediate
;-1061                         return;

 jmp .retnprocess
;-1062                     }

;-1063                 }

.process277:
;-1064             }

.process276:
;-1065             //r/m, imm: 80 sign-extended,TTT,imm

;-1066             c = sflag + 0x80;

.process275:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al
;-1067             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1068             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1069             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process278
 push word [imme]
 call genCode8
 add  sp, 2
;-1070             else genImmediate();

 jmp .process279
.process278:
 call genImmediate
;-1071             return;

.process279:
 jmp .retnprocess
;-1072         }

;-1073         c = Code1 << 3;//r/m, r/r

.process274:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al
;-1074         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process280
;-1075             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process281
;-1076                 c += 2;//add direction flag

 add  byte[bp-2], 2
;-1077                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1078                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al
;-1079                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1080                 return;

 jmp .retnprocess
;-1081             }

;-1082         }

.process281:
;-1083         if (Op2 == REG) {//mem,reg    reg,reg

.process280:
 mov al, [Op2]
 cmp al, 2
 jne .process282
;-1084             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2
;-1085             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1086             return;

 jmp .retnprocess
;-1087         }

;-1088         syntaxerror();

.process282:
 call syntaxerror
;-1089         return;

 jmp .retnprocess
;-1090     }

;-1091 

;-1092     if (CodeType == 5) {//mov (movsx, movzx=51)

.process271:
 mov al, [CodeType]
 cmp al, 5
 jne .process283
;-1093         check2Ops();

 call check2Ops
;-1094         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process284
;-1095             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process285
 mov ax, [disp]
 mov word [imme], ax
;-1096             else notfounderror();

 jmp .process286
.process285:
 call notfounderror
;-1097             Op2=IMM;//continue with IMM

.process286:
 mov ax, 1
 mov byte [Op2], al
;-1098         }

;-1099         if (Op2 == IMM) {// r,i

.process284:
 mov al, [Op2]
 cmp al, 1
 jne .process287
;-1100             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process288
;-1101                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al
;-1102                 c += 0xB0;

 add  byte[bp-2], 176
;-1103                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1104                 genImmediate();

 call genImmediate
;-1105                 return;

 jmp .retnprocess
;-1106             }

;-1107             if (Op == MEM) {// m,i

.process288:
 mov al, [Op]
 cmp al, 4
 jne .process289
;-1108                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2
;-1109                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2
;-1110                 genImmediate();

 call genImmediate
;-1111                 return;

 jmp .retnprocess
;-1112             }

;-1113             regmemerror();

.process289:
 call regmemerror
;-1114             return;

 jmp .retnprocess
;-1115         }

;-1116         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process287:
 mov al, [R1Type]
 cmp al, 4
 jne .process290
 call ChangeDirection
;-1117         if (R2Type == SEGREG) {//rm,sreg

.process290:
 mov al, [R2Type]
 cmp al, 4
 jne .process291
;-1118             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process292
 call reg16error
;-1119                 genCode2(0x8C, dflag);

.process292:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4
;-1120                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1121                 return;

 jmp .retnprocess
;-1122         }

;-1123         if (Op2 == MEM) {//acc, moffs16

.process291:
 mov al, [Op2]
 cmp al, 4
 jne .process293
;-1124             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process294
;-1125                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process295
;-1126                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process296
;-1127                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2
;-1128                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1129                         return;

 jmp .retnprocess
;-1130                     }

;-1131                 }

.process296:
;-1132             }

.process295:
;-1133         }

.process294:
;-1134         if (Op == MEM) {//moffs16, acc

.process293:
 mov al, [Op]
 cmp al, 4
 jne .process297
;-1135             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process298
;-1136                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process299
;-1137                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process300
;-1138                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2
;-1139                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1140                         return;

 jmp .retnprocess
;-1141                     }

;-1142                 }

.process300:
;-1143             }

.process299:
;-1144 

;-1145         }

.process298:
;-1146         if (Op2 == REG) {//rm, r

.process297:
 mov al, [Op2]
 cmp al, 2
 jne .process301
;-1147             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2
;-1148             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1149             return;

 jmp .retnprocess
;-1150         }

;-1151         if (Op2 == MEM) {//r, m

.process301:
 mov al, [Op2]
 cmp al, 4
 jne .process302
;-1152             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process303
;-1153                 ChangeDirection();

 call ChangeDirection
;-1154                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2
;-1155                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1156                 return;

 jmp .retnprocess
;-1157             }

;-1158         }

.process303:
;-1159         syntaxerror();

.process302:
 call syntaxerror
;-1160         return;

 jmp .retnprocess
;-1161     }

;-1162 

;-1163     if (CodeType == 6) {//Jcc

.process283:
 mov al, [CodeType]
 cmp al, 6
 jne .process304
;-1164         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process305
;-1165             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1166             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process306
;-1167                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1168                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1169                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1170                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process307
;-1171                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1172                     disp -= 2;

 sub  word[disp], 2
;-1173                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1174                 } else {

 jmp .process308
.process307:
;-1175                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1176                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1177                     disp -= 4;

 sub  word[disp], 4
;-1178                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1179                 }

;-1180             }

.process308:
;-1181             else {//jump forward, near only

 jmp .process309
.process306:
;-1182                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1183                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1184                 storeJmp();

 call storeJmp
;-1185                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2
;-1186                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al
;-1187             }

;-1188         return;

.process309:
 jmp .retnprocess
;-1189         }

;-1190     }

.process305:
;-1191 

;-1192     if (CodeType == 7) {//jmp, call

.process304:
 mov al, [CodeType]
 cmp al, 7
 jne .process310
;-1193         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process311
;-1194             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax
;-1195             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process312
;-1196                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
;-1197                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax
;-1198                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax
;-1199                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process313
;-1200                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process314
;-1201                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2
;-1202                         disp -= 2;

 sub  word[disp], 2
;-1203                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2
;-1204                     }

;-1205                     else {

 jmp .process315
.process314:
;-1206                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1207                         disp -= 3;

 sub  word[disp], 3
;-1208                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1209                     }

;-1210                 }

.process315:
;-1211                 else {

 jmp .process316
.process313:
;-1212                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1213                     disp -= 3;

 sub  word[disp], 3
;-1214                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1215                 }

;-1216             }

.process316:
;-1217             else {//jump forward, near only

 jmp .process317
.process312:
;-1218                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1219                 if (PC != 1) storeJmp();//omit jmp main

 mov ax, [PC]
 cmp ax, 1
 je  .process318
 call storeJmp
;-1220                 genCode16(0);

.process318:
 push 0
 call genCode16
 add  sp, 2
;-1221                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al
;-1222             }

;-1223         return;

.process317:
 jmp .retnprocess
;-1224         }

;-1225     }

.process311:
;-1226 

;-1227     if (CodeType ==  8) {//ret,retf

.process310:
 mov al, [CodeType]
 cmp al, 8
 jne .process319
;-1228         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process320
;-1229             if (Code1 == 0xC3) genCode8(0xC2);//ret n

 mov al, [Code1]
 cmp al, 195
 jne .process321
 push 194
 call genCode8
 add  sp, 2
;-1230                 else genCode8(0xCA);//retf n

 jmp .process322
.process321:
 push 202
 call genCode8
 add  sp, 2
;-1231             genCode16(SymbolInt);

.process322:
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1232             return;

 jmp .retnprocess
;-1233         }

;-1234         genCode8(Code1);

.process320:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1235         return;

 jmp .retnprocess
;-1236     }

;-1237 

;-1238     if (CodeType == 9) {//push, pop

.process319:
 mov al, [CodeType]
 cmp al, 9
 jne .process323
;-1239         getOpL();

 call getOpL
;-1240         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process324
;-1241             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process325
;-1242                 setsflag();

 call setsflag
;-1243                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4
;-1244                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process326
 push word [imme]
 call genCode8
 add  sp, 2
;-1245                 else       genCode16(imme);

 jmp .process327
.process326:
 push word [imme]
 call genCode16
 add  sp, 2
;-1246                 return;

.process327:
 jmp .retnprocess
;-1247             }

;-1248             if (Op == ADR) {//push string ABSOLUTE i16

.process325:
 mov al, [Op]
 cmp al, 3
 jne .process328
;-1249                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process329
;-1250                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1251                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2
;-1252                     return;

 jmp .retnprocess
;-1253                 }

;-1254                 else {

 jmp .process330
.process329:
;-1255                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2
;-1256                     storeJmp();

 call storeJmp
;-1257                     genCode16(0xAAAA);//magic for abs ADR

 push 43690
 call genCode16
 add  sp, 2
;-1258                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al
;-1259                     return;

 jmp .retnprocess
;-1260                 }

;-1261             }

.process330:
;-1262         }

.process328:
;-1263         if (R1Type == SEGREG) {

.process324:
 mov al, [R1Type]
 cmp al, 4
 jne .process331
;-1264             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process332
;-1265                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process333
 push process_0
 call error1
 add  sp, 2
;-1266             }

.process333:
;-1267             c = R1No <<3;

.process332:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al
;-1268             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process334
;-1269                 c += 122;  //0x7A

 add  byte[bp-2], 122
;-1270                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2
;-1271             }

;-1272             if (Code1 == 0x50) c +=6;//push

.process334:
 mov al, [Code1]
 cmp al, 80
 jne .process335
 add  byte[bp-2], 6
;-1273                 else c += 7;//pop

 jmp .process336
.process335:
 add  byte[bp-2], 7
;-1274             genCode8(c);

.process336:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1275             return;

 jmp .retnprocess
;-1276         }

;-1277         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM

.process331:
 call checkOpL
;-1278 

;-1279         if (Op == MEM) {

 mov al, [Op]
 cmp al, 4
 jne .process337
;-1280             if (Code1 == 0x50) {//push word [bp+6]

 mov al, [Code1]
 cmp al, 80
 jne .process338
;-1281                 genCode8(0xFF);

 push 255
 call genCode8
 add  sp, 2
;-1282                 writeEA(6);

 push 6
 call writeEA
 add  sp, 2
;-1283             }else {

 jmp .process339
.process338:
;-1284                 genCode8(0x8F);

 push 143
 call genCode8
 add  sp, 2
;-1285                 writeEA(0);

 push 0
 call writeEA
 add  sp, 2
;-1286             }

;-1287             return;

.process339:
 jmp .retnprocess
;-1288         }

;-1289         if (R1Type == BYTE) reg16error();

.process337:
 mov al, [R1Type]
 cmp al, 1
 jne .process340
 call reg16error
;-1290         if (R1Type == WORD) {//is REG, w/o SEGREG

.process340:
 mov al, [R1Type]
 cmp al, 2
 jne .process341
;-1291             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
;-1292             return;

 jmp .retnprocess
;-1293         }

;-1294         syntaxerror();

.process341:
 call syntaxerror
;-1295         return;

 jmp .retnprocess
;-1296     }

;-1297 

;-1298     if (CodeType == 11) {//shift, rotate

.process323:
 mov al, [CodeType]
 cmp al, 11
 jne .process342
;-1299         check2Ops();

 call check2Ops
;-1300         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process343
;-1301             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process344
;-1302                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2
;-1303                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1304                 return;

 jmp .retnprocess
;-1305             }

;-1306             genCodeW(0xC0);//80186

.process344:
 push 192
 call genCodeW
 add  sp, 2
;-1307             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1308             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2
;-1309             return;

 jmp .retnprocess
;-1310         }

;-1311         if (Op2 == REG) {

.process343:
 mov al, [Op2]
 cmp al, 2
 jne .process345
;-1312             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process346
;-1313                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process347
;-1314                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process348
 mov ax, 1
 mov byte [wflag], al
;-1315                     genCodeW(0xD2);

.process348:
 push 210
 call genCodeW
 add  sp, 2
;-1316                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2
;-1317                     return;

 jmp .retnprocess
;-1318                 }

;-1319             }

.process347:
;-1320         }

.process346:
;-1321     }

.process345:
;-1322 

;-1323     if (CodeType == 12) {//int

.process342:
 mov al, [CodeType]
 cmp al, 12
 jne .process349
;-1324         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process350
;-1325             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2
;-1326             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1327             return;

 jmp .retnprocess
;-1328         }

;-1329     }

.process350:
;-1330 

;-1331     if (CodeType == 14) {//in, out

.process349:
 mov al, [CodeType]
 cmp al, 14
 jne .process351
;-1332         implerror();

 call implerror
;-1333         return;

 jmp .retnprocess
;-1334     }

;-1335     if (CodeType == 15) {//xchg

.process351:
 mov al, [CodeType]
 cmp al, 15
 jne .process352
;-1336         implerror();

 call implerror
;-1337         return;

 jmp .retnprocess
;-1338     }

;-1339     if (CodeType == 16) {//loop

.process352:
 mov al, [CodeType]
 cmp al, 16
 jne .process353
;-1340         implerror();

 call implerror
;-1341         return;

 jmp .retnprocess
;-1342     }

;-1343 

;-1344     if (CodeType == 30) {//enter i18,i8

.process353:
 mov al, [CodeType]
 cmp al, 30
 jne .process354
;-1345         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2
;-1346         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1347         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process355
 push word [SymbolInt]
 call genCode16
 add  sp, 2
;-1348         else numbererror();

 jmp .process356
.process355:
 call numbererror
;-1349         need(',');

.process356:
 push 44
 call need
 add  sp, 2
;-1350         Op=getOp1();

 call getOp1
 mov byte [Op], al
;-1351         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process357
 push word [SymbolInt]
 call genCode8
 add  sp, 2
;-1352         else numbererror();

 jmp .process358
.process357:
 call numbererror
;-1353         return;

.process358:
 jmp .retnprocess
;-1354     }

;-1355 

;-1356     if (CodeType == 41) {//test

.process354:
 mov al, [CodeType]
 cmp al, 41
 jne .process359
;-1357         implerror();

 call implerror
;-1358         return;

 jmp .retnprocess
;-1359     }

;-1360 

;-1361     if (CodeType == 51) {//movsx, movzx=51

.process359:
 mov al, [CodeType]
 cmp al, 51
 jne .process360
;-1362         implerror();

 call implerror
;-1363         return;

 jmp .retnprocess
;-1364     }

;-1365 

;-1366     if (CodeType==101) {//ORG nn

.process360:
 mov al, [CodeType]
 cmp al, 101
 jne .process361
;-1367         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process362
 call numbererror
;-1368         Origin=SymbolInt;

.process362:
 mov ax, [SymbolInt]
 mov word [Origin], ax
;-1369         return;

 jmp .retnprocess
;-1370     }

;-1371 

;-1372     if (CodeType == 102) {//section, segment

.process361:
 mov al, [CodeType]
 cmp al, 102
 jne .process363
;-1373         //getTokeType();//ignore .bss .text .data

;-1374         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax
;-1375         return;

 jmp .retnprocess
;-1376     }

;-1377 

;-1378     if (CodeType == 110) {//absolute

.process363:
 mov al, [CodeType]
 cmp al, 110
 jne .process364
;-1379         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process365
 call numbererror
;-1380         AbsoluteLab=SymbolInt;

.process365:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax
;-1381         return;

 jmp .retnprocess
;-1382     }

;-1383     if (CodeType == 111) {//name: PROC

.process364:
 mov al, [CodeType]
 cmp al, 111
 jne .process366
;-1384         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process367
;-1385             prs("\nentering: ");

 push process_1
 call prs
 add  sp, 2
;-1386             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2
;-1387             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al
;-1388             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax
;-1389             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax
;-1390             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax
;-1391             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax
;-1392         } else error1("already in PROC");

 jmp .process368
.process367:
 push process_2
 call error1
 add  sp, 2
;-1393         return;

.process368:
 jmp .retnprocess
;-1394     }

;-1395     if (CodeType == 112) {//ENDP

.process366:
 mov al, [CodeType]
 cmp al, 112
 jne .process369
;-1396         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process370
 push process_3
 call error1
 add  sp, 2
;-1397         prs("\nleaving: ");

.process370:
 push process_4
 call prs
 add  sp, 2
;-1398         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2
;-1399         prs(", loc labels: ");

 push process_5
 call prs
 add  sp, 2
;-1400         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax
;-1401         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2
;-1402         prs(", loc jmp forward: ");

 push process_6
 call prs
 add  sp, 2
;-1403         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax
;-1404         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2
;-1405         fixJmp();

 call fixJmp
;-1406         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1407         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax
;-1408         LabelMaxIx   = tmpLabelMaxIx;

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax
;-1409         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax
;-1410         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax
;-1411         return;

 jmp .retnprocess
;-1412     }

;-1413     if (CodeType == 200) {//db

.process369:
 mov al, [CodeType]
 cmp al, 200
 jne .process371
;-1414         genDB();

 call genDB
;-1415         return;

 jmp .retnprocess
;-1416     }

;-1417 

;-1418     error1("Command not implemented or syntax error");

.process371:
 push process_7
 call error1
 add  sp, 2
;-1419 }

;-1420 

;-1421 int parse() {

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
;-1422     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax
;-1423     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax
;-1424     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax
;-1425     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax
;-1426     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax
;-1427     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al
;-1428     isPrint=0;

 mov ax, 0
 mov byte [isPrint], al
;-1429 

;-1430     do {//process a new line

.parse372:
;-1431         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax
;-1432         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al
;-1433         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax
;-1434         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al
;-1435         getLine();

 call getLine
;-1436         if (DOS_NoBytes) {

 mov ax, [DOS_NoBytes]
 or  al, al
 je .parse373
;-1437             InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax
;-1438             getTokeType();//getCode in SymbolUpper,

 call getTokeType
;-1439                           //set TokeType,isLabel by getName

;-1440             if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse374
;-1441                 if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse375
;-1442                   if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse376
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4
;-1443                     storeLabel();

.parse376:
 call storeLabel
;-1444                     InputPtr++;//remove :

 inc  word[InputPtr]
;-1445                     getTokeType();

 call getTokeType
;-1446                 }

;-1447             }

.parse375:
;-1448             if (TokeType == ALNUME) {

.parse374:
 mov al, [TokeType]
 cmp al, 3
 jne .parse377
;-1449                 lookCode1();

 call lookCode1
;-1450                 if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse378
 call process
;-1451                 else getVariable();

 jmp .parse379
.parse378:
 call getVariable
;-1452                 skipRest();

.parse379:
 call skipRest
;-1453             }

;-1454             else if(TokeType >ALNUME)error1("Label or instruction expected");

 jmp .parse380
.parse377:
 mov al, [TokeType]
 cmp al, 3
 jle .parse381
 push parse_0
 call error1
 add  sp, 2
;-1455             else if(TokeType==DIGIT )error1("No digit allowed at start");

 jmp .parse382
.parse381:
 mov al, [TokeType]
 cmp al, 1
 jne .parse383
 push parse_1
 call error1
 add  sp, 2
;-1456             printLine();

.parse383:
.parse382:
.parse380:
 call printLine
;-1457         }

;-1458     } while (DOS_NoBytes != 0 );

.parse373:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse384
 jmp .parse372
.parse384:
;-1459     isPrint=1;

 mov ax, 1
 mov byte [isPrint], al
;-1460 }

;-1461 

;-1462 int getarg() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start",0
ENDP

getarg: PROC
;-1463     int arglen1; int i; char *c;

;-1464     arglen1=*arglen;
;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax
;-1465     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg385
;-1466         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2
;-1467         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2
;-1468         exitR(3);

 push 3
 call exitR
 add  sp, 2
;-1469     }

;-1470     i=arglen1+129;

.getarg385:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax
;-1471     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
;-1472     arglen1--;

 dec  word[bp-2]
;-1473     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2
;-1474 

;-1475     strcpy(namein, argv); strcat1(namein, ".S");

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
;-1476     strcpy(namelst,argv); strcat1(namelst,".LST");

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
;-1477     strcpy(namebin,argv); strcat1(namebin,".COM");

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
;-1478 

;-1479   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax
;-1480 

;-1481     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax
;-1482     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

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
;-1483     lst_fd=creatR(namelst);

.getarg386:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax
;-1484     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

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
;-1485     bin_fd=creatR(namebin);

.getarg387:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax
;-1486     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

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
;-1487 

;-1488     prs(";");

.getarg388:
 push getarg_7
 call prs
 add  sp, 2
;-1489     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2
;-1490     prs(", Input: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2
;-1491     prs(", ");

 push getarg_9
 call prs
 add  sp, 2
;-1492 }

;-1493 

;-1494 int main() {

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
;-1495     getarg();

 call getarg
;-1496     parse();

 call parse
;-1497     fixJmpMain();

 call fixJmpMain
;-1498     epilog();

 call epilog
;-1499     end1();

 call end1
;-1500 }

 ret
ENDP
;Glob. variables:158 (300), Functions:88 (300), Lines:1501
;Constant: 658 (3000), stacksize: 6482