
; A.COM CComp V0.7 16.11.2014, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
;PROTECTED: 0 V86 OFF.  32bit: ON. 
org  256 ; NASM ON
jmp main

;-1 int main() {getarg(); parse(); epilog(); end1();}//BAS.BAT,   AS TE


main:  ; *** PROC ***
 call getarg
 call parse
 call epilog
 call end1

;-2 char Version1[]="AS.C V0.07 5.1.2016";

 ret
; ENDP
Version1 db "AS.C V0.07 5.1.2016",0

;-3 #include "DECL.C"

;Use include file: DECL.C

;-1 char LIST;              // listing on/off

LIST db 0

;-2 char Symbol[80];        //next symbol to decode

section .bss
absolute 30000
Symbol resb 80
section .text

;-3 char SymbolUpper[80];   //set toupper in getName

section .bss
absolute 30080
SymbolUpper resb 80
section .text

;-4 unsigned int SymbolInt; //integer value set in getDigit

SymbolInt dw 0

;-5 char InputBuf[128];     //filled in getLine, no overflow test

section .bss
absolute 30160
InputBuf resb 128
section .text

;-6 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0

;-7 char namein [67];       //input file name  .S

section .bss
absolute 30288
namein resb 67
section .text

;-8 char namelst[67];       //list file name   .LST

section .bss
absolute 30355
namelst resb 67
section .text

;-9 char namebin[67];       //output file name .COM

section .bss
absolute 30422
namebin resb 67
section .text

;-10 int  asm_fd;            //input file descriptor

asm_fd dw 0

;-11 int lst_fd;             //list file descriptor

lst_fd dw 0

;-12 int bin_fd;             //output file descriptor

bin_fd dw 0

;-13 int DOS_ERR;            //global var

DOS_ERR dw 0

;-14 int ErrorCount;         //number of errors

ErrorCount dw 0

;-15 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0

;-16 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0

;-17 


;-18 unsigned int PC;        //program counter, ORG nn

PC dw 0

;-19 unsigned int PCStart;   //PC at start of line by PrintLine()

PCStart dw 0

;-20 char isLabel;           //by getName()

isLabel db 0

;-21 #define DIGIT    1      //0-9


;-22 #define LETTERE  2      //a-z A-Z @ . _


;-23 #define ALNUME   3      //a-z A-Z @ . _  0-9


;-24 #define NOALNUME 4      //other char


;-25 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME

TokeType db 0

;-26 #define BYTE     1


;-27 #define WORD     2


;-28 #define DWORD    3


;-29 #define SEGREG   4


;-30 //char CodeSize;          //0, BYTE, WORD, DWORD


;-31 #define IMM      1      //const  ,123


;-32 #define REG      2      //       ,BX    mode=11


;-33 #define DIR      3      //VALUE  ,var1  mod=00, r/m=110


;-34 #define IND      4      //indirec,[var1],[BX+SI],[table+BX],[bp-4] disp 0,8,16


;-35 char Op1;               //0, IMM, REG, DIR, IND

Op1 db 0

;-36 char CodeType;          //1-207 by searchSymbol(), must be byte size 

CodeType db 0

;-37 


;-38 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG

RegType db 0

;-39 char RegNo;             //0 - 7 AL, CL, ...  by testReg()

RegNo db 0

;-40 char OpSize;            //0, BYTE, WORD, DWORD

OpSize db 0

;-41 //char AddrSize;          //67h:


;-42 char NumOprns;          //0-2

NumOprns db 0

;-43 char wflag;             //0=byte, 1=word/dword

wflag db 0

;-44 char dflag;             //0=source is reg,  1=dest is reg

dflag db 0

;-45 //char modrm;           //mod, r/m


;-46 char reg;               //combination of index and base reg

reg db 0

;-47 int disp;               //displacement      0-8 bytes

disp dw 0

;-48 int imme;               //immediate         0-8 bytes

imme dw 0

;-49 


;-50 #define OPMAXLEN  5


;-51 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 30489
OpPos resb 5
section .text

;-52 int OpPrintIndex;       //0-OPMAXLEN, Position to print opcode, by genCode8()

OpPrintIndex dw 0

;-53 char *OpCodePtr;        //position in OpCodeTable by searchSymbol(), div.

OpCodePtr dw 0

;-54 char PrReloc;           //print 'R' if relocative

PrReloc db 0

;-55 


;-56 char LabelNames[1000];  //space for names of all labels

section .bss
absolute 30494
LabelNames resb 1000
section .text

;-57 char *LabelNamePtr;     // first free position

LabelNamePtr dw 0

;-58 unsigned int LabelAddr[100];//addr of each label

section .bss
absolute 31494
LabelAddr resw 100
section .text

;-59 int LabelMaxIx=0;       //actual number of stored labels

LabelMaxIx dw 0

;-60 int LabelIx;            //actual number of just searched label

LabelIx dw 0

;-61 


;-62 char FileBin  [2000];   //output binary file

section .bss
absolute 31694
FileBin resb 2000
section .text

;-63 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-64 


;-65 char *arglen=0x80;      // for main only

arglen dw 128

;-66 char *argv=0x82;        // for main only

argv dw 130
;Back to main program: AS.C

;-4 


;-5 int process() { int i; char c;


process:  ; *** PROC ***

;-6   getTokeType();

;Function : process, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word     5 NULL bp-2    i
;  201 var sign byte     5 NULL bp-4    c;
 ENTER  4,0
 call getTokeType

;-7   OpSize=getCodeSize();

 call getCodeSize
 mov byte [OpSize], al

;-8 


;-9   if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne @@process1

;-10     genInstruction(0, 1); return;

 push 1
 push 0
 call genInstruction
 add  sp, 4
 jmp @@retn

;-11   }


;-12   if (CodeType ==  2) {//inc, dec

@@process1:
 mov al, [CodeType]
 cmp al, 2
 jne @@process2

;-13     LeftOpwCheck();

 call LeftOpwCheck

;-14     	if (Op1 == REG) {

 mov al, [Op1]
 cmp al, 2
 jne @@process3

;-15         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form

 mov al, [RegType]
 cmp al, 2
 jne @@process4
 push 3
 mov al, byte [RegNo]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 jmp @@retn

;-16         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }

@@process4:
 mov al, [RegType]
 cmp al, 3
 jne @@process5
 push 3
 mov al, byte [RegNo]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 jmp @@retn
@@process5:

;-17       genInstruction(wflag, 1); genCodeInREG(); return;

@@process3:
 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 call genCodeInREG
 jmp @@retn

;-18   }


;-19 


;-20   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul

@@process2:
 mov al, [CodeType]
 cmp al, 52
 jne @@process6

;-21     LeftOpwCheck();

 call LeftOpwCheck

;-22     genInstruction(wflag, 1); genCodeInREG(); return;

 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 call genCodeInREG
 jmp @@retn

;-23   }


;-24 


;-25   if (CodeType==  8) {// ret

@@process6:
 mov al, [CodeType]
 cmp al, 8
 jne @@process7

;-26     if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}

 mov al, [TokeType]
 cmp al, 1
 jne @@process8
 push 2
 push 0
 call genInstruction
 add  sp, 4
 push word [SymbolInt]
 call genCode16
 add  sp, 2
 jmp @@retn

;-27     genInstruction(0, 1); return;

@@process8:
 push 1
 push 0
 call genInstruction
 add  sp, 4
 jmp @@retn

;-28   }


;-29 


;-30   if (CodeType==101) {// ORG nn

@@process7:
 mov al, [CodeType]
 cmp al, 101
 jne @@process9

;-31     if (TokeType != DIGIT) error1("only digit allowed");

 mov al, [TokeType]
 cmp al, 1
 je  @@process10
 push process_0
 call error1
 add  sp, 2

;-32     PC=SymbolInt;return;

@@process10:
 mov ax, [SymbolInt]
 mov word [PC], ax
 jmp @@retn

;-33   }


;-34   error1("unknown CodeType");

@@process9:
 push process_1
 call error1
 add  sp, 2

;-35 }


;-36 


;-37 // scan code .....................................


;-38 int getTokeType() { char c;

@@retn: LEAVE
 ret
; ENDP
process_0 db "only digit allowed",0
process_1 db "unknown CodeType",0

getTokeType:  ; *** PROC ***

;-39   skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    38 NULL bp-2    c;
 ENTER  2,0
 call skipBlank

;-40   c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-41   if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne @@getTokeType11
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-42   if (c == ';') {TokeType=0; return; }//comment

@@getTokeType11:
 mov al, [bp-2]
 cmp al, 59
 jne @@getTokeType12
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-43   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

@@getTokeType12:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getTokeType13
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov eax, 1
 mov byte [TokeType], al
 jmp @@retn

;-44   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

@@getTokeType13:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@getTokeType14
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov eax, 3
 mov byte [TokeType], al
 jmp @@retn

;-45   TokeType=NOALNUME; return;

@@getTokeType14:
 mov eax, 4
 mov byte [TokeType], al
 jmp @@retn

;-46 }


;-47 int Ops() {

@@retn: LEAVE
 ret
; ENDP

Ops:  ; *** PROC ***

;-48 //O2=rr,rm,ri,mr,mi


;-49 //NumOprns==2, seg reg not allowed only mov and push


;-50 //size: 1.declaration CodeSize, 2.reg size, 3.error1


;-51 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);


;-52 //2. rm , imm 80


;-53 //2a sign ext 83


;-54 //3. reg, rm  02  if (dest==reg) set direction bit; else default;


;-55 //4. rm , reg 00


;-56 //5. error1(mem2mem)


;-57 }


;-58 int LeftOpwCheck() {

 ret
; ENDP

LeftOpwCheck:  ; *** PROC ***

;-59   getLeftOp();

 call getLeftOp

;-60   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop

 mov al, [RegType]
 cmp al, 4
 jne @@LeftOpwCheck15
 call segregerror
 jmp @@retn

;-61   setwflag();

@@LeftOpwCheck15:
 call setwflag

;-62   if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne @@LeftOpwCheck16
 push LeftOpwCheck_0
 call error1
 add  sp, 2

;-63   if (OpSize == RegType) return;

@@LeftOpwCheck16:
 mov al, [OpSize]
 cmp al, [RegType]
 jne @@LeftOpwCheck17
 jmp @@retn

;-64   if (OpSize){if (Op1 == IND) return;

@@LeftOpwCheck17:
 mov al, [OpSize]
 or  al, al
 je @@LeftOpwCheck18
 mov al, [Op1]
 cmp al, 4
 jne @@LeftOpwCheck19
 jmp @@retn

;-65     error1("Conflict OpSize and RegSize"); }

@@LeftOpwCheck19:
 push LeftOpwCheck_1
 call error1
 add  sp, 2

;-66   if (RegType==0) error1("no register defined");

@@LeftOpwCheck18:
 mov al, [RegType]
 cmp al, 0
 jne @@LeftOpwCheck20
 push LeftOpwCheck_2
 call error1
 add  sp, 2

;-67 }

@@LeftOpwCheck20:

;-68 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)

@@retn:
 ret
; ENDP
LeftOpwCheck_0 db "no op size declared",0
LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
LeftOpwCheck_2 db "no register defined",0

getLeftOp:  ; *** PROC ***

;-69 //set: op1, disp->imm, reg, regt->size


;-70   disp=0; imme=0; reg=0;

 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov word [imme], ax
 mov eax, 0
 mov byte [reg], al

;-71 


;-72   Op1=getOp1();

 call getOp1
 mov byte [Op1], al

;-73   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je @@getLeftOp21
 mov eax, 4
 mov byte [Op1], al
 call getIND
 jmp @@retn

;-74   if (Op1 == 0) error1("Name of operand expected");

@@getLeftOp21:
 mov al, [Op1]
 cmp al, 0
 jne @@getLeftOp22
 push getLeftOp_0
 call error1
 add  sp, 2

;-75   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1

@@getLeftOp22:
 mov al, [Op1]
 cmp al, 1
 jne @@getLeftOp23
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp @@retn

;-76   if (Op1 == REG) return;                                    //2

@@getLeftOp23:
 mov al, [Op1]
 cmp al, 2
 jne @@getLeftOp24
 jmp @@retn

;-77   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3

@@getLeftOp24:
 mov al, [Op1]
 cmp al, 3
 jne @@getLeftOp25
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp @@retn

;-78   error1("Name of operand expected #1");

@@getLeftOp25:
 push getLeftOp_1
 call error1
 add  sp, 2

;-79 }


;-80 int setwflag() {//only Op1 (first operand)

@@retn:
 ret
; ENDP
getLeftOp_0 db "Name of operand expected",0
getLeftOp_1 db "Name of operand expected #1",0

setwflag:  ; *** PROC ***

;-81   wflag=0;

 mov eax, 0
 mov byte [wflag], al

;-82   if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne @@setwflag26

;-83     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}

 mov al, [Op1]
 cmp al, 2
 jne @@setwflag27
 mov al, [RegType]
 mov byte [OpSize], al
 mov al, [RegType]
 cmp al, 4
 jne @@setwflag28
 mov eax, 2
 mov byte [OpSize], al
@@setwflag28:

;-84   }

@@setwflag27:

;-85   if (OpSize  == DWORD) {gen66h(); wflag=1;}

@@setwflag26:
 mov al, [OpSize]
 cmp al, 3
 jne @@setwflag29
 call gen66h
 mov eax, 1
 mov byte [wflag], al

;-86   if (OpSize  ==  WORD) wflag=1;

@@setwflag29:
 mov al, [OpSize]
 cmp al, 2
 jne @@setwflag30
 mov eax, 1
 mov byte [wflag], al

;-87 }

@@setwflag30:

;-88 int getOp1() {//scan for a single operand

 ret
; ENDP

getOp1:  ; *** PROC ***

;-89   //set:Op1, imme, disp, RegType, TegNo, reg


;-90   if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne @@getOp131
 mov eax, 0
 jmp @@retn

;-91   if (TokeType == DIGIT)  return IMM;// 1

@@getOp131:
 mov al, [TokeType]
 cmp al, 1
 jne @@getOp132
 mov eax, 1
 jmp @@retn

;-92   if (TokeType == ALNUME) {

@@getOp132:
 mov al, [TokeType]
 cmp al, 3
 jne @@getOp133

;-93     RegNo=testReg();//set global RegType

 call testReg
 mov byte [RegNo], al

;-94     if (RegType)          return REG;// 2

 mov al, [RegType]
 or  al, al
 je @@getOp134
 mov eax, 2
 jmp @@retn

;-95     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];

@@getOp134:
 call searchLabel
 mov word [LabelIx], ax

;-96     if (LabelIx)          return DIR;// 3

 mov ax, [LabelIx]
 or  al, al
 je @@getOp135
 mov eax, 3
 jmp @@retn

;-97     else error1("variable not found"); }

 jmp @@getOp136
@@getOp135:
 push getOp1_0
 call error1
 add  sp, 2
@@getOp136:

;-98   return 0;

@@getOp133:
 mov eax, 0
 jmp @@retn

;-99 }


;-100 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]

@@retn:
 ret
; ENDP
getOp1_0 db "variable not found",0

getIND:  ; *** PROC ***

;-101   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI

;Function : getIND, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   101 NULL bp-2    op2
;  201 var sign byte   101 NULL bp-4    r1;
 ENTER  4,0
 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov byte [bp-4], al
 mov eax, 0
 mov byte [RegType], al

;-102   do {

@@getIND37:

;-103     getTokeType();

 call getTokeType

;-104     op2=getOp1();

 call getOp1
 mov byte [bp-2], al

;-105     if (op2 ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne @@getIND38
 call syntaxerror

;-106     if (op2 == IMM) disp=disp+SymbolInt;

@@getIND38:
 mov al, [bp-2]
 cmp al, 1
 jne @@getIND39
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-107     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();

@@getIND39:
 mov al, [bp-2]
 cmp al, 2
 jne @@getIND40
 mov al, [bp-4]
 or  al, al
 je @@getIND41
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call getIndReg2
 add  sp, 2
 mov byte [bp-4], al
 jmp @@getIND42
@@getIND41:
 call getIndReg1
 mov byte [bp-4], al

;-108     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable

@@getIND42:
@@getIND40:
 mov al, [bp-2]
 cmp al, 3
 jne @@getIND43
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-109     if (isToken('-')) {getTokeType();

@@getIND43:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je @@getIND44
 call getTokeType

;-110       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}

 mov al, [TokeType]
 cmp al, 1
 je  @@getIND45
 call numbererror
@@getIND45:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-111   } while (isToken('+'));

@@getIND44:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je @@getIND46
 jmp @@getIND37
@@getIND46:

;-112   if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne @@getIND47
 push getIND_0
 call errorexit
 add  sp, 2

;-113   reg=r1;

@@getIND47:
 mov al, [bp-4]
 mov byte [reg], al

;-114 }


;-115 int getIndReg1() {char m; m=0;
 LEAVE
 ret
; ENDP
getIND_0 db "] expected",0

getIndReg1:  ; *** PROC ***
;Function : getIndReg1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   115 NULL bp-2    m;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-116   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg148
 call indexerror

;-117   if (RegNo==3) m=7;//BX

@@getIndReg148:
 mov al, [RegNo]
 cmp al, 3
 jne @@getIndReg149
 mov eax, 7
 mov byte [bp-2], al

;-118   if (RegNo==5) m=6;//BP change to BP+0

@@getIndReg149:
 mov al, [RegNo]
 cmp al, 5
 jne @@getIndReg150
 mov eax, 6
 mov byte [bp-2], al

;-119   if (RegNo==7) m=5;//DI

@@getIndReg150:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg151
 mov eax, 5
 mov byte [bp-2], al

;-120   if (RegNo==6) m=4;//SI

@@getIndReg151:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg152
 mov eax, 4
 mov byte [bp-2], al

;-121   if (m    ==0) indexerror();

@@getIndReg152:
 mov al, [bp-2]
 cmp al, 0
 jne @@getIndReg153
 call indexerror

;-122   return m;

@@getIndReg153:
 mov al, [bp-2]
 jmp @@retn

;-123 }


;-124 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI

@@retn: LEAVE
 ret
; ENDP

getIndReg2:  ; *** PROC ***
;Function : getIndReg2, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   124 NULL bp+4    r1
;  201 var sign byte   124 NULL bp-2    m;
 ENTER  2,0
 mov eax, 4
 mov byte [bp-2], al

;-125   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg254
 call indexerror

;-126   if (RegNo==7) if (r1==6) m=3;//BP+DI

@@getIndReg254:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg255
 mov al, [bp+4]
 cmp al, 6
 jne @@getIndReg256
 mov eax, 3
 mov byte [bp-2], al

;-127            else if (r1==7) m=1;//BX+DI

 jmp @@getIndReg257
@@getIndReg256:
 mov al, [bp+4]
 cmp al, 7
 jne @@getIndReg258
 mov eax, 1
 mov byte [bp-2], al

;-128   if (RegNo==6) if (r1==6) m=2;//BP+SI

@@getIndReg258:
@@getIndReg257:
@@getIndReg255:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg259
 mov al, [bp+4]
 cmp al, 6
 jne @@getIndReg260
 mov eax, 2
 mov byte [bp-2], al

;-129            else if (r1==7) m=0;//BX+DI

 jmp @@getIndReg261
@@getIndReg260:
 mov al, [bp+4]
 cmp al, 7
 jne @@getIndReg262
 mov eax, 0
 mov byte [bp-2], al

;-130   if (m > 3) indexerror();

@@getIndReg262:
@@getIndReg261:
@@getIndReg259:
 mov al, [bp-2]
 cmp al, 3
 jle @@getIndReg263
 call indexerror

;-131   return m;

@@getIndReg263:
 mov al, [bp-2]
 jmp @@retn

;-132 }


;-133 


;-134 int getCodeSize() {

@@retn: LEAVE
 ret
; ENDP

getCodeSize:  ; *** PROC ***

;-135   if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@getCodeSize64

;-136     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize65
 call getTokeType
 mov eax, 1
 jmp @@retn

;-137     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

@@getCodeSize65:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize66
 call getTokeType
 mov eax, 2
 jmp @@retn

;-138     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

@@getCodeSize66:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize67
 call getTokeType
 mov eax, 3
 jmp @@retn

;-139   } return 0;

@@getCodeSize67:
@@getCodeSize64:
 mov eax, 0
 jmp @@retn

;-140 }


;-141 int isToken(char c) {

@@retn:
 ret
; ENDP
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0

isToken:  ; *** PROC ***

;-142   skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   141 NULL bp+4    c;
 ENTER  0,0
 call skipBlank

;-143   if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne @@isToken68

;-144     InputPtr++; return 1;} return 0;

 inc  word [InputPtr]
 mov eax, 1
 jmp @@retn
@@isToken68:
 mov eax, 0
 jmp @@retn

;-145 }


;-146 int skipRest() {

@@retn: LEAVE
 ret
; ENDP

skipRest:  ; *** PROC ***

;-147   getTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");

 call getTokeType
 mov al, [TokeType]
 cmp al, 0
 je  @@skipRest69
 push skipRest_0
 call prs
 add  sp, 2

;-148 }

@@skipRest69:

;-149 // generate code ...........................................................


;-150 int gen66h() {genCode8(0x66);}

 ret
; ENDP
skipRest_0 db "\n; ********** extra char ignored",0

gen66h:  ; *** PROC ***
 push 102
 call genCode8
 add  sp, 2

;-151 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++

 ret
; ENDP

genCode8:  ; *** PROC ***

;-152   FileBin[BinLen]=c; BinLen++; PC++;

;Function : genCode8, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   151 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
 inc  word [BinLen]
 inc  word [PC]

;-153   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }

 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode870
 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
 inc  word [OpPrintIndex]

;-154 }

@@genCode870:

;-155 int genCode16(int i) {
 LEAVE
 ret
; ENDP

genCode16:  ; *** PROC ***

;-156   genCode8(i); i=i >> 8; genCode8(i);

;Function : genCode16, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   155 NULL bp+4    i;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov word [bp+4], ax
 push word [bp+4]
 call genCode8
 add  sp, 2

;-157 }


;-158 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
 LEAVE
 ret
; ENDP

genInstruction:  ; *** PROC ***

;-159   if(loc) OpCodePtr=OpCodePtr+loc;

;Function : genInstruction, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign byte   158 NULL bp+4    No
;  201 var sign word   158 NULL bp+6    loc
;  202 var sign byte   158 NULL bp-2    c;
 ENTER  2,0
 mov ax, [bp+6]
 or  al, al
 je @@genInstruction71
 mov ax, [OpCodePtr]
 add ax, [bp+6]
 mov word [OpCodePtr], ax

;-160   c= *OpCodePtr + No; genCode8(c);

@@genInstruction71:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 add al, [bp+4]
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-161 }


;-162 int genCodeInREG() {char x; //get Code for second byte
 LEAVE
 ret
; ENDP

genCodeInREG:  ; *** PROC ***

;-163   OpCodePtr++; x= *OpCodePtr; writeEA(x);

;Function : genCodeInREG, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   162 NULL bp-2    x;
 ENTER  2,0
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-164 }


;-165 int genModRegRM(){ writeEA(reg);//todo
 LEAVE
 ret
; ENDP

genModRegRM:  ; *** PROC ***
 mov al, byte [reg]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-166 }


;-167 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg

 ret
; ENDP

writeEA:  ; *** PROC ***

;-168   len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   167 NULL bp+4    xxx
;  201 var sign byte   167 NULL bp-2    len;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-169   xxx = xxx << 3;//in reg field of mod r/m

 mov al, [bp+4]
 shl al, 3
 mov byte [bp+4], al

;-170   if (Op1 ==   0) addrexit();

 mov al, [Op1]
 cmp al, 0
 jne @@writeEA72
 call addrexit

;-171   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2

@@writeEA72:
 mov al, [Op1]
 cmp al, 2
 jne @@writeEA73
 or  byte [bp+4], 192
 mov al, [bp+4]
 add al, [RegNo]
 mov byte [bp+4], al

;-172   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3

@@writeEA73:
 mov al, [Op1]
 cmp al, 3
 jne @@writeEA74
 or  byte [bp+4], 6
 mov eax, 2
 mov byte [bp-2], al

;-173   if (Op1 == IND) { xxx = xxx + reg;                       //4

@@writeEA74:
 mov al, [Op1]
 cmp al, 4
 jne @@writeEA75
 mov al, [bp+4]
 add al, [reg]
 mov byte [bp+4], al

;-174     if (disp) {disp; if(ax > 127) len=2; else len=1;

 mov ax, [disp]
 or  al, al
 je @@writeEA76
 mov ax, [disp]
 cmp  ax, 127
 jle @@writeEA77
 mov eax, 2
 mov byte [bp-2], al
 jmp @@writeEA78
@@writeEA77:
 mov eax, 1
 mov byte [bp-2], al

;-175       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}

@@writeEA78:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA79
 or  byte [bp+4], 64
 jmp @@writeEA80
@@writeEA79:
 or  byte [bp+4], 128
@@writeEA80:

;-176     }

@@writeEA76:

;-177   genCode8(xxx);// gen second byte

@@writeEA75:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-178   if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA81
 push word [disp]
 call genCode8
 add  sp, 2

;-179   if (len == 2) genCode16(disp);

@@writeEA81:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA82
 push word [disp]
 call genCode16
 add  sp, 2

;-180 }

@@writeEA82:

;-181 int test1() { __asm {
 LEAVE
 ret
; ENDP

test1:  ; *** PROC ***


;-182 inc byte [Version1]   ;FE 06 [1000]

inc byte [Version1]   ;FE 06 [1000]

;-183 add bx, ax    ;01 C3

add bx, ax    ;01 C3

;-184 add ax, bx    ;01 D8

add ax, bx    ;01 D8

;-185 add word ax, [bx] ;03 07

add word ax, [bx] ;03 07

;-186 VA dw 8

VA dw 8

;-187 mov byte [bp- 4], al ;88 46 FC

mov byte [bp- 4], al ;88 46 FC

;-188 mov      [VA+bx], al ;88 87 [300F]

mov      [VA+bx], al ;88 87 [300F]

;-189 }  }



;-190 #include "AS1.C"

 ret
; ENDP
;Use include file: AS1.C

;-1 //AS1.C  5.12.2014  BAS,  AS TE


;-2 int parse() {


parse:  ; *** PROC ***

;-3   LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-4   do {

@@parse83:

;-5     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';

 mov ax, [PC]
 mov word [PCStart], ax
 mov eax, 0
 mov byte [OpSize], al
 mov eax, 0
 mov word [OpPrintIndex], ax
 mov eax, 32
 mov byte [PrReloc], al

;-6     getLine();

 call getLine

;-7     InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-8     getTokeType();// getCode in SymbolUpper,set TokeType,set isLabel by getName

 call getTokeType

;-9     if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@parse84

;-10       if (isLabel) { //set in getName

 mov al, [isLabel]
 or  al, al
 je @@parse85

;-11         storeLabel();

 call storeLabel

;-12         InputPtr++;//remove :

 inc  word [InputPtr]

;-13         getTokeType();

 call getTokeType

;-14       }


;-15     }

@@parse85:

;-16     if (TokeType == ALNUME) {

@@parse84:
 mov al, [TokeType]
 cmp al, 3
 jne @@parse86

;-17       lookCode();// and OpCodePtr

 call lookCode

;-18       if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je @@parse87
 call process

;-19       else getVariable();

 jmp @@parse88
@@parse87:
 call getVariable

;-20       skipRest();

@@parse88:
 call skipRest

;-21     }


;-22     else if (TokeType >  ALNUME) error1("Label or instruction expected");

 jmp @@parse89
@@parse86:
 mov al, [TokeType]
 cmp al, 3
 jle @@parse90
 push parse_0
 call error1
 add  sp, 2

;-23     else if (TokeType == DIGIT) error1("No digit allowed at start of line");

 jmp @@parse91
@@parse90:
 mov al, [TokeType]
 cmp al, 1
 jne @@parse92
 push parse_1
 call error1
 add  sp, 2

;-24     printLine();

@@parse92:
@@parse91:
@@parse89:
 call printLine

;-25   } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  @@parse93
 jmp @@parse83
@@parse93:

;-26 }


;-27 int storeLabel() {

 ret
; ENDP
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0

storeLabel:  ; *** PROC ***

;-28   if(searchLabel()) error1("duplicate symbol");

 call searchLabel
 or  al, al
 je @@storeLabel94
 push storeLabel_0
 call error1
 add  sp, 2

;-29   LabelNamePtr=strcpy(LabelNamePtr, Symbol);

@@storeLabel94:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-30   LabelNamePtr++;

 inc  word [LabelNamePtr]

;-31   LabelMaxIx++;

 inc  word [LabelMaxIx]

;-32   LabelAddr[LabelMaxIx] = PC;

 mov ax, [PC]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-33 }


;-34 int searchLabel() {

 ret
; ENDP
storeLabel_0 db "duplicate symbol",0

searchLabel:  ; *** PROC ***

;-35   int LIx; char *p; int j;


;-36   p = &LabelNames;

;Function : searchLabel, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word    35 NULL bp-2    LIx
;  201 ptr sign byte    35 NULL bp-4    p
;  202 var sign word    35 NULL bp-6    j;
 ENTER  6,0
 mov ax, LabelNames
 mov word [bp-4], ax

;-37   LIx=1;

 mov eax, 1
 mov word [bp-2], ax

;-38   while (LIx <= LabelMaxIx) {

@@searchLabel95:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel96

;-39     if (eqstr(p, Symbol)) return LIx;//and searchType

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel97
 mov ax, [bp-2]
 jmp @@retn

;-40     j=strlen(p);

@@searchLabel97:
 push word [bp-4]
 call strlen
 add  sp, 2
 mov word [bp-6], ax

;-41     p=p+j; p++; LIx++;

 mov ax, [bp-4]
 add ax, [bp-6]
 mov word [bp-4], ax
 inc  word [bp-4]
 inc  word [bp-2]

;-42   }


;-43   return 0;

 jmp @@searchLabel95
@@searchLabel96:
 mov eax, 0
 jmp @@retn

;-44 }


;-45 int getVariable() { char c;

@@retn: LEAVE
 ret
; ENDP

getVariable:  ; *** PROC ***

;-46   storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    45 NULL bp-2    c;
 ENTER  2,0
 call storeLabel

;-47   getTokeType(); if(TokeType==ALNUME) {// getName

 call getTokeType
 mov al, [TokeType]
 cmp al, 3
 jne @@getVariable98

;-48     lookCode();

 call lookCode

;-49     if (CodeType < 200) errorexit("D or RES B,W,D expected");

 mov al, [CodeType]
 cmp al, 200
 jge @@getVariable99
 push getVariable_0
 call errorexit
 add  sp, 2

;-50     if (CodeType > 207) errorexit("D or RES B,W,D expected");

@@getVariable99:
 mov al, [CodeType]
 cmp al, 207
 jle @@getVariable100
 push getVariable_1
 call errorexit
 add  sp, 2

;-51     if (CodeType== 200) {// DB

@@getVariable100:
 mov al, [CodeType]
 cmp al, 200
 jne @@getVariable101

;-52       do { getTokeType();

@@getVariable102:
 call getTokeType

;-53         if (TokeType ==DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable103
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-54         else {

 jmp @@getVariable104
@@getVariable103:

;-55           skipBlank();

 call skipBlank

;-56           if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable105

;-57             do { c= *InputPtr;

@@getVariable106:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-58               genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-59               InputPtr++;

 inc  word [InputPtr]

;-60             } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  @@getVariable107
 jmp @@getVariable106
@@getVariable107:

;-61             InputPtr++;

 inc  word [InputPtr]

;-62           }


;-63         }

@@getVariable105:

;-64       } while (isToken(','));

@@getVariable104:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable108
 jmp @@getVariable102
@@getVariable108:

;-65     }


;-66     if (CodeType== 201) {// DW

@@getVariable101:
 mov al, [CodeType]
 cmp al, 201
 jne @@getVariable109

;-67       do { getTokeType();

@@getVariable110:
 call getTokeType

;-68         if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable111
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-69       } while (isToken(','));

@@getVariable111:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable112
 jmp @@getVariable110
@@getVariable112:

;-70     }


;-71   }

@@getVariable109:

;-72   else errorexit("DB,DW,DD or RESB,W,D expected");

 jmp @@getVariable113
@@getVariable98:
 push getVariable_2
 call errorexit
 add  sp, 2

;-73 }

@@getVariable113:

;-74 // helper functions XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;-75 


;-76 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
 LEAVE
 ret
; ENDP
getVariable_0 db "D or RES B,W,D expected",0
getVariable_1 db "D or RES B,W,D expected",0
getVariable_2 db "DB,DW,DD or RESB,W,D expected",0

getLine:  ; *** PROC ***

;-77   InputPtr= &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-78   *InputPtr=0;//if last line is empty

 mov eax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-79   do {

@@getLine114:

;-80     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-81     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je @@getLine115
 push getLine_0
 call errorexit
 add  sp, 2

;-82     if (DOS_NoBytes == 0) return;

@@getLine115:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne @@getLine116
 jmp @@retn

;-83     *InputPtr = DOS_ByteRead;

@@getLine116:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-84     InputPtr++;

 inc  word [InputPtr]

;-85   } while (ifEOL(DOS_ByteRead) == 0);

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne @@getLine117
 jmp @@getLine114
@@getLine117:

;-86   InputPtr--;

 dec  word [InputPtr]

;-87   *InputPtr=0;

 mov eax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-88 }


;-89 int ifEOL(char c) {

@@retn:
 ret
; ENDP
getLine_0 db "Reading Source",0

ifEOL:  ; *** PROC ***

;-90   if (c == 10) return 1;

;Function : ifEOL, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    89 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne @@ifEOL118
 mov eax, 1
 jmp @@retn

;-91   if (c == 13) {

@@ifEOL118:
 mov al, [bp+4]
 cmp al, 13
 jne @@ifEOL119

;-92     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-93     return 1;}

 mov eax, 1
 jmp @@retn

;-94   return 0;

@@ifEOL119:
 mov eax, 0
 jmp @@retn

;-95 }


;-96 int skipBlank() {

@@retn: LEAVE
 ret
; ENDP

skipBlank:  ; *** PROC ***

;-97   skipblank1:

@@skipblank1:

;-98     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne @@skipBlank120
 inc  word [InputPtr]
 jmp @@skipblank1

;-99     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

@@skipBlank120:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne @@skipBlank121
 inc  word [InputPtr]
 jmp @@skipblank1

;-100 }

@@skipBlank121:

;-101 int letterE(char c) {

 ret
; ENDP

letterE:  ; *** PROC ***

;-102   if (digit(c)) return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   101 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@letterE122
 mov eax, 1
 jmp @@retn

;-103   if (c=='_') return 1;

@@letterE122:
 mov al, [bp+4]
 cmp al, 95
 jne @@letterE123
 mov eax, 1
 jmp @@retn

;-104   if (c=='.') return 1;

@@letterE123:
 mov al, [bp+4]
 cmp al, 46
 jne @@letterE124
 mov eax, 1
 jmp @@retn

;-105   if (c> 'z') return 0;

@@letterE124:
 mov al, [bp+4]
 cmp al, 122
 jle @@letterE125
 mov eax, 0
 jmp @@retn

;-106   if (c< '@') return 0; // at included

@@letterE125:
 mov al, [bp+4]
 cmp al, 64
 jge @@letterE126
 mov eax, 0
 jmp @@retn

;-107   if (c> 'Z') { if (c< 'a') return 0; }

@@letterE126:
 mov al, [bp+4]
 cmp al, 90
 jle @@letterE127
 mov al, [bp+4]
 cmp al, 97
 jge @@letterE128
 mov eax, 0
 jmp @@retn
@@letterE128:

;-108   return 1;

@@letterE127:
 mov eax, 1
 jmp @@retn

;-109 }


;-110 int alnumE(char c) {

@@retn: LEAVE
 ret
; ENDP

alnumE:  ; *** PROC ***

;-111   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   110 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@alnumE129
 mov eax, 1
 jmp @@retn

;-112   if (letterE(c)) return 1;

@@alnumE129:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@alnumE130
 mov eax, 1
 jmp @@retn

;-113   return 0;

@@alnumE130:
 mov eax, 0
 jmp @@retn

;-114 }


;-115 int getDigit(unsigned char c) {//ret: SymbolInt

@@retn: LEAVE
 ret
; ENDP

getDigit:  ; *** PROC ***

;-116   unsigned int CastInt;


;-117   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte   115 NULL bp+4    c
;  201 var unsg word   116 NULL bp-2    CastInt;
 ENTER  2,0
 mov eax, 0
 mov word [SymbolInt], ax

;-118   do {

@@getDigit131:

;-119     c-='0';

 sub  byte [bp+4], 48

;-120     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov ebx, 10
 mul ebx
 mov word [SymbolInt], ax

;-121     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov word [bp-2], ax

;-122     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-123     InputPtr++;

 inc  word [InputPtr]

;-124     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-125   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getDigit132
 jmp @@getDigit131
@@getDigit132:

;-126 }


;-127 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
; ENDP

getName:  ; *** PROC ***

;-128   char *p;


;-129   p = &Symbol;

;Function : getName, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte   127 NULL bp+4    c
;  201 ptr sign byte   128 NULL bp-2    p;
 ENTER  2,0
 mov ax, Symbol
 mov word [bp-2], ax

;-130   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-131   p++;

 inc  word [bp-2]

;-132   while (alnumE(c)) {

@@getName133:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je @@getName134

;-133     InputPtr++;

 inc  word [InputPtr]

;-134     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-135     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-136     p++;

 inc  word [bp-2]

;-137   }


;-138   if (c == ':') isLabel=1; else isLabel=0;

 jmp @@getName133
@@getName134:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName135
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName136
@@getName135:
 mov eax, 0
 mov byte [isLabel], al

;-139   p--;

@@getName136:
 dec  word [bp-2]

;-140   *p = 0;

 mov eax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-141   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-142   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-143 }


;-144 int testReg() {
 LEAVE
 ret
; ENDP

testReg:  ; *** PROC ***

;-145 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-146   RegType=0;

 mov eax, 0
 mov byte [RegType], al

;-147   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge @@testReg137
 mov eax, 0
 jmp @@retn

;-148   if (strlen(Symbol) > 3) return 0;

@@testReg137:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg138
 mov eax, 0
 jmp @@retn

;-149   RegType=BYTE;

@@testReg138:
 mov eax, 1
 mov byte [RegType], al

;-150   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg139
 mov eax, 0
 jmp @@retn

;-151   if (eqstr(SymbolUpper, "CL")) return 1;

@@testReg139:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg140
 mov eax, 1
 jmp @@retn

;-152   if (eqstr(SymbolUpper, "DL")) return 2;

@@testReg140:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg141
 mov eax, 2
 jmp @@retn

;-153   if (eqstr(SymbolUpper, "BL")) return 3;

@@testReg141:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg142
 mov eax, 3
 jmp @@retn

;-154   if (eqstr(SymbolUpper, "AH")) return 4;

@@testReg142:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg143
 mov eax, 4
 jmp @@retn

;-155   if (eqstr(SymbolUpper, "CH")) return 5;

@@testReg143:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg144
 mov eax, 5
 jmp @@retn

;-156   if (eqstr(SymbolUpper, "DH")) return 6;

@@testReg144:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg145
 mov eax, 6
 jmp @@retn

;-157   if (eqstr(SymbolUpper, "BH")) return 7;

@@testReg145:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg146
 mov eax, 7
 jmp @@retn

;-158   RegType=WORD;

@@testReg146:
 mov eax, 2
 mov byte [RegType], al

;-159   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg147
 mov eax, 0
 jmp @@retn

;-160   if (eqstr(SymbolUpper, "CX")) return 1;

@@testReg147:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg148
 mov eax, 1
 jmp @@retn

;-161   if (eqstr(SymbolUpper, "DX")) return 2;

@@testReg148:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg149
 mov eax, 2
 jmp @@retn

;-162   if (eqstr(SymbolUpper, "BX")) return 3;

@@testReg149:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg150
 mov eax, 3
 jmp @@retn

;-163   if (eqstr(SymbolUpper, "SP")) return 4;

@@testReg150:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg151
 mov eax, 4
 jmp @@retn

;-164   if (eqstr(SymbolUpper, "BP")) return 5;

@@testReg151:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg152
 mov eax, 5
 jmp @@retn

;-165   if (eqstr(SymbolUpper, "SI")) return 6;

@@testReg152:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg153
 mov eax, 6
 jmp @@retn

;-166   if (eqstr(SymbolUpper, "DI")) return 7;

@@testReg153:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg154
 mov eax, 7
 jmp @@retn

;-167   RegType=SEGREG;

@@testReg154:
 mov eax, 4
 mov byte [RegType], al

;-168   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 0
 jmp @@retn

;-169   if (eqstr(SymbolUpper, "CS")) return 1;

@@testReg155:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg156
 mov eax, 1
 jmp @@retn

;-170   if (eqstr(SymbolUpper, "SS")) return 2;

@@testReg156:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg157
 mov eax, 2
 jmp @@retn

;-171   if (eqstr(SymbolUpper, "DS")) return 3;

@@testReg157:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg158
 mov eax, 3
 jmp @@retn

;-172   if (eqstr(SymbolUpper, "FS")) return 4;

@@testReg158:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg159
 mov eax, 4
 jmp @@retn

;-173   if (eqstr(SymbolUpper, "GS")) return 5;

@@testReg159:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg160
 mov eax, 5
 jmp @@retn

;-174   RegType=DWORD;

@@testReg160:
 mov eax, 3
 mov byte [RegType], al

;-175   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg161
 mov eax, 0
 jmp @@retn

;-176   if (eqstr(SymbolUpper, "ECX"))return 1;

@@testReg161:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg162
 mov eax, 1
 jmp @@retn

;-177   if (eqstr(SymbolUpper, "EDX"))return 2;

@@testReg162:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg163
 mov eax, 2
 jmp @@retn

;-178   if (eqstr(SymbolUpper, "EBX"))return 3;

@@testReg163:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg164
 mov eax, 3
 jmp @@retn

;-179   if (eqstr(SymbolUpper, "ESP"))return 4;

@@testReg164:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg165
 mov eax, 4
 jmp @@retn

;-180   if (eqstr(SymbolUpper, "EBP"))return 5;

@@testReg165:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg166
 mov eax, 5
 jmp @@retn

;-181   if (eqstr(SymbolUpper, "ESI"))return 6;

@@testReg166:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg167
 mov eax, 6
 jmp @@retn

;-182   if (eqstr(SymbolUpper, "EDI"))return 7;

@@testReg167:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg168
 mov eax, 7
 jmp @@retn

;-183   RegType=0; return 0;

@@testReg168:
 mov eax, 0
 mov byte [RegType], al
 mov eax, 0
 jmp @@retn

;-184 }


;-185 // opcodes XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;-186 char I_START=0xF1;//OpName,0,CodeType,OpCode1,OpCodeN,F1h

@@retn:
 ret
; ENDP
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
I_START db 241

;-187 //  1:   1 byte opcode


;-188 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241

;-189 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};

I_POPA db 80,79,80,65,0,1,97,241

;-190 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};

I_NOP db 78,79,80,0,1,144,241

;-191 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};

I_CBW db 67,66,87,0,1,152,241

;-192 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};

I_CWDE db 67,87,68,69,0,1,152,241

;-193 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};

I_CWD db 67,87,68,0,1,153,241

;-194 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};

I_CDQ db 67,68,81,0,1,153,241

;-195 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};

I_WAIT db 87,65,73,84,0,1,155,241

;-196 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241

;-197 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};

I_POPF db 80,79,80,70,0,1,157,241

;-198 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};

I_SAHF db 83,65,72,70,0,1,158,241

;-199 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};

I_LAHF db 76,65,72,70,0,1,159,241

;-200 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241

;-201 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};

I_MOVSW db 77,79,86,83,87,0,1,165,241

;-202 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241

;-203 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};

I_CMPSW db 67,77,80,83,87,0,1,167,241

;-204 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241

;-205 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};

I_STOSW db 83,84,79,83,87,0,1,171,241

;-206 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241

;-207 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};

I_LODSW db 76,79,68,83,87,0,1,173,241

;-208 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241

;-209 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};

I_SCASW db 83,67,65,83,87,0,1,175,241

;-210 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241

;-211 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};

I_IRET db 73,82,69,84,0,1,207,241

;-212 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};

I_XLAT db 88,76,65,84,0,1,215,241

;-213 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};

I_LOCK db 76,79,67,75,0,1,240,241

;-214 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241

;-215 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};

I_REPNZ db 82,69,80,78,90,0,1,242,241

;-216 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};

I_REPE db 82,69,80,69,0,1,243,241

;-217 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};

I_REPZ db 82,69,80,90,0,1,243,241

;-218 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};

I_HLT db 72,76,84,0,1,244,241

;-219 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry

I_CLC db 67,76,67,0,1,248,241

;-220 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry

I_STC db 83,84,67,0,1,249,241

;-221 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt

I_CLI db 67,76,73,0,1,250,241

;-222 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt

I_STI db 83,84,73,0,1,251,241

;-223 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction

I_CLD db 67,76,68,0,1,252,241

;-224 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction

I_STD db 83,84,68,0,1,253,241

;-225 //  2: inc,dec


;-226 char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-227 char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-228 // 52: mem reg 16 bit


;-229 char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};

I_NOT db 78,79,84,0,52,246,2,241

;-230 char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};

I_NEG db 78,69,71,0,52,246,3,241

;-231 char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};

I_MUL db 77,85,76,0,52,246,4,241

;-232 char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc

I_IMUL db 73,77,85,76,0,52,246,5,241

;-233 char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};

I_DIV db 68,73,86,0,52,246,6,241

;-234 char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};

I_IDIV db 73,68,73,86,0,52,246,7,241

;-235 //  3: les, lda, lea


;-236 char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16

I_LES db 76,69,83,0,3,196,241

;-237 char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16

I_LDS db 76,68,83,0,3,197,241

;-238 char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16

I_LEA db 76,69,65,0,3,141,241

;-239 //  4: acc,imm  reg,imm  index,reg


;-240 char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-241 char I_OR []={'O','R',0,                4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-242 char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-243 char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-244 char I_AND[]={'A','N','D',0,            4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-245 char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-246 char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-247 char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-248 //  5: mov


;-249 char I_MOV[]={'M','O','V',0,            5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-250 //  6: single byte relative jump


;-251 char I_JO []={'J','O',0,                6, 0,     0xF1};

I_JO db 74,79,0,6,0,241

;-252 char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};

I_JNO db 74,78,79,0,6,1,241

;-253 char I_JB []={'J','B',0,                6, 2,     0xF1};

I_JB db 74,66,0,6,2,241

;-254 char I_JC []={'J','C',0,                6, 2,     0xF1};

I_JC db 74,67,0,6,2,241

;-255 char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};

I_JNB db 74,78,66,0,6,3,241

;-256 char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};

I_JAE db 74,65,69,0,6,3,241

;-257 char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};

I_JNC db 74,78,67,0,6,3,241

;-258 char I_JE []={'J','E',0,                6, 4,     0xF1};//      74 je i8 rel

I_JE db 74,69,0,6,4,241

;-259 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//   0F 84 je i16 rel

I_JZ db 74,90,0,6,4,241

;-260 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//66 0F 84 je i32 rel

I_JNE db 74,78,69,0,6,5,241

;-261 char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};

I_JNZ db 74,78,90,0,6,5,241

;-262 char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};

I_JBE db 74,66,69,0,6,6,241

;-263 char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};

I_JNA db 74,78,65,0,6,6,241

;-264 char I_JA []={'J','A',0,                6, 7,     0xF1};

I_JA db 74,65,0,6,7,241

;-265 char I_JS []={'J','S',0,                6, 8,     0xF1};

I_JS db 74,83,0,6,8,241

;-266 char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};

I_JNS db 74,78,83,0,6,9,241

;-267 char I_JP[]={'J','P',0,                 6,10,     0xF1};

I_JP db 74,80,0,6,10,241

;-268 char I_JPE[]={'J','P','E',0,            6,10,     0xF1};

I_JPE db 74,80,69,0,6,10,241

;-269 char I_JNP[]={'J','N','P',0,            6,11,     0xF1};

I_JNP db 74,78,80,0,6,11,241

;-270 char I_JPO[]={'J','P','O',0,            6,11,     0xF1};

I_JPO db 74,80,79,0,6,11,241

;-271 char I_JL[]={'J','L',0,                 6,12,     0xF1};

I_JL db 74,76,0,6,12,241

;-272 char I_JNL[]={'J','N','L',0,            6,13,     0xF1};

I_JNL db 74,78,76,0,6,13,241

;-273 char I_JGE[]={'J','G','E',0,            6,13,     0xF1};

I_JGE db 74,71,69,0,6,13,241

;-274 char I_JLE[]={'J','L','E',0,            6,14,     0xF1};

I_JLE db 74,76,69,0,6,14,241

;-275 char I_JNG[]={'J','N','G',0,            6,14,     0xF1};

I_JNG db 74,78,71,0,6,14,241

;-276 char I_JG []={'J','G',0,                6,15,     0xF1};

I_JG db 74,71,0,6,15,241

;-277 //  8: ret


;-278 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-279 //  9: seg, r/m


;-280 char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,241

;-281 char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16

I_POP db 80,79,80,0,9,88,241

;-282 //  100 directives


;-283 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-284 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-285 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-286 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-287 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};

I_RESB db 82,69,83,66,0,205,241

;-288 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};

I_RESW db 82,69,83,87,0,206,241

;-289 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};

I_RESD db 82,69,83,68,0,207,241

;-290 char I_END=0;// end of table char

I_END db 0

;-291 


;-292 int lookCode() { // ret: CodeType, *OpCodePtr


lookCode:  ; *** PROC ***

;-293   CodeType=0;

 mov eax, 0
 mov byte [CodeType], al

;-294   OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-295   OpCodePtr++;

 inc  word [OpCodePtr]

;-296   do  {

@@lookCode169:

;-297     if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode170

;-298       while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode171:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode172
 inc  word [OpCodePtr]

;-299       OpCodePtr++; CodeType =*OpCodePtr;

 jmp @@lookCode171
@@lookCode172:
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-300       return;

 jmp @@retn

;-301     }


;-302   while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode170:
@@lookCode173:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode174
 inc  word [OpCodePtr]

;-303   OpCodePtr++;

 jmp @@lookCode173
@@lookCode174:
 inc  word [OpCodePtr]

;-304   } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode175
 jmp @@lookCode169
@@lookCode175:

;-305 }


;-306 // string functions error epilog XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;-307 int printLine() { int i; char c;

@@retn:
 ret
; ENDP

printLine:  ; *** PROC ***

;-308   prs("\n"); printhex16(PCStart);

;Function : printLine, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word   307 NULL bp-2    i
;  201 var sign byte   307 NULL bp-4    c;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2
 push word [PCStart]
 call printhex16
 add  sp, 2

;-309   if (OpPrintIndex == 0) prs("                ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne @@printLine176
 push printLine_1
 call prs
 add  sp, 2

;-310   else {

 jmp @@printLine177
@@printLine176:

;-311     prc(PrReloc);

 mov al, byte [PrReloc]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-312     i=0;

 mov eax, 0
 mov word [bp-2], ax

;-313     do {

@@printLine178:

;-314       c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov byte [bp-4], al

;-315       printhex8a(c); prc(' ');

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-316       i++;

 inc  word [bp-2]

;-317     } while(i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge @@printLine179
 jmp @@printLine178
@@printLine179:

;-318     do {// fill rest with blank

@@printLine180:

;-319       prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-320       i++;

 inc  word [bp-2]

;-321     } while(i < OPMAXLEN);

 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine181
 jmp @@printLine180
@@printLine181:

;-322   }


;-323   prscomment(InputBuf);

@@printLine177:
 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-324 }


;-325 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
 LEAVE
 ret
; ENDP
printLine_0 db "\n",0
printLine_1 db "                ",0
printLine_2 db "   ",0

prc:  ; *** PROC ***
;Function : prc, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg byte   325 NULL bp+4    c;
 ENTER  0,0
 mov al, [LIST]
 or  al, al
 je @@prc182
cmp byte [bp+4], 10
 jne @@prc183
 mov  ax, 13
 call writetty

;-326      al=c; writetty(); }

@@prc183:
 mov  al, [bp+4]
 call writetty

;-327    fputcR(c,lst_fd); }

@@prc182:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-328 


;-329 int prscomment(unsigned char *s) {unsigned char c;
 LEAVE
 ret
; ENDP

prscomment:  ; *** PROC ***

;-330   while(*s){c=*s;prc(c);s++;}

;Function : prscomment, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte   329 NULL bp+4    s
;  201 var unsg byte   329 NULL bp-2    c;
 ENTER  2,0
@@prscomment184:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment185
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
 inc  word [bp+4]

;-331 }

 jmp @@prscomment184
@@prscomment185:

;-332 int prs(unsigned char *s) {unsigned char c; int com; com=0;
 LEAVE
 ret
; ENDP

prs:  ; *** PROC ***
;Function : prs, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte   332 NULL bp+4    s
;  201 var unsg byte   332 NULL bp-2    c
;  202 var sign word   332 NULL bp-4    com;
 ENTER  4,0
 mov eax, 0
 mov word [bp-4], ax

;-333   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;

@@prs186:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs187
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, [bp-2]
 cmp al, 34
 jne @@prs188
 mov ax, [bp-4]
 or  al, al
 je @@prs189
 mov eax, 0
 mov word [bp-4], ax
 jmp @@prs190
@@prs189:
 mov eax, 1
 mov word [bp-4], ax

;-334     if (c==92) { if (com==0) { s++; c=*s;

@@prs190:
@@prs188:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs191
 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs192
 inc  word [bp+4]
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-335           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }

 mov al, [bp-2]
 cmp al, 110
 jne @@prs193
 mov eax, 10
 mov byte [bp-2], al
@@prs193:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs194
 mov eax, 9
 mov byte [bp-2], al
@@prs194:
@@prs192:
@@prs191:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
 inc  word [bp+4]

;-336 }

 jmp @@prs186
@@prs187:

;-337 int printhex8a(unsigned int c) { unsigned int nib;
 LEAVE
 ret
; ENDP

printhex8a:  ; *** PROC ***

;-338   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word   337 NULL bp+4    c
;  201 var unsg word   337 NULL bp-2    nib;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 4
 mov word [bp-2], ax
 add  word [bp-2], 48
 mov ax, [bp-2]
 cmp ax, 57
 jle @@printhex8a195
 add  word [bp-2], 7
@@printhex8a195:
 push word [bp-2]
 call prc
 add  sp, 2

;-339   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);

 mov ax, [bp+4]
 and ax, 15
 mov word [bp-2], ax
 add  word [bp-2], 48
 mov ax, [bp-2]
 cmp ax, 57
 jle @@printhex8a196
 add  word [bp-2], 7
@@printhex8a196:
 push word [bp-2]
 call prc
 add  sp, 2

;-340 }


;-341 int printhex16(unsigned int i) {unsigned int half;
 LEAVE
 ret
; ENDP

printhex16:  ; *** PROC ***

;-342   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word   341 NULL bp+4    i
;  201 var unsg word   341 NULL bp-2    half;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov word [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2
 mov ax, [bp+4]
 and ax, 255
 mov word [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-343 }


;-344 int printIntU(unsigned int n) { unsigned int e;
 LEAVE
 ret
; ENDP

printIntU:  ; *** PROC ***

;-345   if ( _ n >= 10) {  e=n/10; //DIV

;Function : printIntU, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word   344 NULL bp+4    n
;  201 var unsg word   344 NULL bp-2    e;
 ENTER  2,0
cmp word [bp+4], 10 ;unsigned : 0
 jb  @@printIntU197
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov word [bp-2], ax

;-346     printIntU(e); }

 push word [bp-2]
 call printIntU
 add  sp, 2

;-347     n = n % 10; //unsigned mod

@@printIntU197:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov word [bp+4], ax

;-348     n += '0'; prc(n);

 add  word [bp+4], 48
 push word [bp+4]
 call prc
 add  sp, 2

;-349 }


;-350 /*int printLineHex(unsigned char *s) { int L; char c;


;-351   L = strlen(s);


;-352   prs(" L:");


;-353   printIntU(L);


;-354   if (L <= 0) return;


;-355   if (L > 80) errorexit("Line > 80 char");


;-356   while ( *s ) {


;-357     c = *s;


;-358     prc(' ');


;-359     printhex8a(c);


;-360     s++;


;-361   }


;-362 } */


;-363 int error1(char *s) { LIST=1; ErrorCount++;
 LEAVE
 ret
; ENDP

error1:  ; *** PROC ***
;Function : error1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   363 NULL bp+4    s;
 ENTER  0,0
 mov eax, 1
 mov byte [LIST], al
 inc  word [ErrorCount]

;-364   prs("\n;***** next line ERROR: "); prs(s);

 push error1_0
 call prs
 add  sp, 2
 push word [bp+4]
 call prs
 add  sp, 2

;-365   prs(", Symbol: "); prs(Symbol);}

 push error1_1
 call prs
 add  sp, 2
 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-366 int allowederror(){error1("not allowed here"); }
 LEAVE
 ret
; ENDP
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0

allowederror:  ; *** PROC ***
 push allowederror_0
 call error1
 add  sp, 2

;-367 int implmerror(){error1("not implemented");}

 ret
; ENDP
allowederror_0 db "not allowed here",0

implmerror:  ; *** PROC ***
 push implmerror_0
 call error1
 add  sp, 2

;-368 int indexerror (){error1("invalid index register");}

 ret
; ENDP
implmerror_0 db "not implemented",0

indexerror:  ; *** PROC ***
 push indexerror_0
 call error1
 add  sp, 2

;-369 int numbererror(){error1("number expected");}

 ret
; ENDP
indexerror_0 db "invalid index register",0

numbererror:  ; *** PROC ***
 push numbererror_0
 call error1
 add  sp, 2

;-370 int regmemerror(){error1("only register or memory allowed");}

 ret
; ENDP
numbererror_0 db "number expected",0

regmemerror:  ; *** PROC ***
 push regmemerror_0
 call error1
 add  sp, 2

;-371 int segregerror(){error1("segment register not allowed");}

 ret
; ENDP
regmemerror_0 db "only register or memory allowed",0

segregerror:  ; *** PROC ***
 push segregerror_0
 call error1
 add  sp, 2

;-372 int syntaxerror(){error1("syntax");}

 ret
; ENDP
segregerror_0 db "segment register not allowed",0

syntaxerror:  ; *** PROC ***
 push syntaxerror_0
 call error1
 add  sp, 2

;-373 


;-374 int errorexit(char *s) { error1(s); end1(1);}

 ret
; ENDP
syntaxerror_0 db "syntax",0

errorexit:  ; *** PROC ***
;Function : errorexit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   374 NULL bp+4    s;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2
 push 1
 call end1
 add  sp, 2

;-375 int addrexit(){errorexit("illegal addres");}
 LEAVE
 ret
; ENDP

addrexit:  ; *** PROC ***
 push addrexit_0
 call errorexit
 add  sp, 2

;-376 int internexit(){errorexit("intern compiler error");}

 ret
; ENDP
addrexit_0 db "illegal addres",0

internexit:  ; *** PROC ***
 push internexit_0
 call errorexit
 add  sp, 2

;-377 


;-378 int getarg() { int arglen1; int i; char *c;

 ret
; ENDP
internexit_0 db "intern compiler error",0

getarg:  ; *** PROC ***

;-379   arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word   378 NULL bp-2    arglen1
;  201 var sign word   378 NULL bp-4    i
;  202 ptr sign byte   378 NULL bp-6    c;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov word [bp-2], ax

;-380   if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne @@getarg198

;-381     cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-382     cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-383     exitR(3);

 push 3
 call exitR
 add  sp, 2

;-384   }


;-385   i=arglen1+129; *i=0;  arglen1--;

@@getarg198:
 mov ax, [bp-2]
 add ax, 129
 mov word [bp-4], ax
 mov eax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
 dec  word [bp-2]

;-386   toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-387   strcpy(namein, argv); strcat1(namein, ".S");

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

;-388   strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-389   strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-390 


;-391   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;

 mov eax, 1
 mov byte [LIST], al
 mov eax, 0
 mov word [DOS_ERR], ax
 mov eax, 0
 mov word [PC], ax
 mov eax, 0
 mov word [ErrorCount], ax

;-392   asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-393   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg199
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

;-394   lst_fd=creatR(namelst);

@@getarg199:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-395   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg200
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

;-396   bin_fd=creatR(namebin);

@@getarg200:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-397   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg201
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

;-398   prs(";");prs(Version1);

@@getarg201:
 push getarg_7
 call prs
 add  sp, 2
 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-399   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2
 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-400   prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-401   prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-402 }


;-403 int epilog() { int i; int j; char c;
 LEAVE
 ret
; ENDP
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

epilog:  ; *** PROC ***

;-404   prs("\n;END Errors: "); printIntU(ErrorCount);

;Function : epilog, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word   403 NULL bp-2    i
;  201 var sign word   403 NULL bp-4    j
;  202 var sign byte   403 NULL bp-6    c;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2
 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-405   if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je @@epilog202
 push epilog_1
 call prs
 add  sp, 2

;-406   prs(", Label & Var: ");

@@epilog202:
 push epilog_2
 call prs
 add  sp, 2

;-407 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");


;-408   i= &LabelNames;


;-409   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-410   } while (i < LabelNamePtr); prs("<< \n"); */


;-411   if (LabelMaxIx) {

 mov ax, [LabelMaxIx]
 or  al, al
 je @@epilog203

;-412     i = 1;

 mov eax, 1
 mov word [bp-2], ax

;-413     LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-414     do {

@@epilog204:

;-415       prs(LabelNamePtr); prc(' ');

 push word [LabelNamePtr]
 call prs
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-416       j=LabelAddr[i]; printhex16(j); prs(",  ");

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [bp-4], ax
 push word [bp-4]
 call printhex16
 add  sp, 2
 push epilog_3
 call prs
 add  sp, 2

;-417       j=strlen(LabelNamePtr);//get end of actual name

 push word [LabelNamePtr]
 call strlen
 add  sp, 2
 mov word [bp-4], ax

;-418       LabelNamePtr=LabelNamePtr+j;

 mov ax, [LabelNamePtr]
 add ax, [bp-4]
 mov word [LabelNamePtr], ax

;-419       LabelNamePtr++;

 inc  word [LabelNamePtr]

;-420       i++;

 inc  word [bp-2]

;-421     } while (i <= LabelMaxIx);

 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@epilog205
 jmp @@epilog204
@@epilog205:

;-422   }


;-423   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");

@@epilog203:
 push epilog_4
 call prs
 add  sp, 2
 push word [BinLen]
 call printIntU
 add  sp, 2
 push epilog_5
 call prs
 add  sp, 2

;-424   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-425   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;

@@epilog206:
 push 32
 call prc
 add  sp, 2
 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov word [bp-4], ax
 push word [bp-4]
 call printhex8a
 add  sp, 2
 inc  word [bp-2]

;-426   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog207
 jmp @@epilog206
@@epilog207:

;-427   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-428   do {

@@epilog208:

;-429     c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov byte [bp-6], al

;-430     fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-431     i++;

 inc  word [bp-2]

;-432   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog209
 jmp @@epilog208
@@epilog209:

;-433 }


;-434 int end1(int n) {
 LEAVE
 ret
; ENDP
epilog_0 db "\n;END Errors: ",0
epilog_1 db " ***ERROR*** ",0
epilog_2 db ", Label & Var: ",0
epilog_3 db ",  ",0
epilog_4 db "\n;COM file ",0
epilog_5 db " bytes:",0

end1:  ; *** PROC ***

;-435   fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   434 NULL bp+4    n;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-436   fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-437   fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-438   exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-439 }
 LEAVE
 ret
; ENDP
;Back to main program: AS.C
 
; missing functions: 
; digit
; eqstr
; eqstr
; eqstr
; strcpy
; eqstr
; strlen
; readRL
; readRL
; digit
; digit
; digit
; strcpy
; toupper
; strlen
; strlen
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; eqstr
; writetty
; writetty
; fputcR
; cputs
; cputs
; exitR
; toupper
; strcpy
; strcat1
; strcpy
; strcat1
; strcpy
; strcat1
; openR
; cputs
; cputs
; exitR
; creatR
; cputs
; cputs
; exitR
; creatR
; cputs
; cputs
; exitR
; strlen
; fputcR
; fcloseR
; fcloseR
; fcloseR
; exitR
; Number of unresolved CALLs :   78
;use archive file: AR.C

;-191 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-192 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   192 NULL bp+4    s
;  201 var sign byte   192 NULL bp-2    c;
 ENTER  2,0
@@cputs210:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs211
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call putch
 add  sp, 2
 inc  word [bp+4]
 jmp @@cputs210
@@cputs211:

;-193 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   193 NULL bp+4    s;
 ENTER  0,0
@@toupper212:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper213
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper214
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper215
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper215:
@@toupper214:
 inc  word [bp+4]
 jmp @@toupper212
@@toupper213:

;-194 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-195 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   195 NULL bp+4    s
;  201 var sign word   195 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen216:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen217
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen216
@@strlen217:
 mov ax, [bp-2]
 jmp @@retn

;-196 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    5 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   196 NULL bp+4    s
;  201 ptr sign byte   196 NULL bp+6    t;
 ENTER  0,0
@@strcpy218:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-197   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy219
 jmp @@strcpy218
@@strcpy219:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-198 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    4 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   198 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit220
 mov eax, 0
 jmp @@retn
@@digit220:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit221
 mov eax, 0
 jmp @@retn
@@digit221:
 mov eax, 1
 jmp @@retn

;-199 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   199 NULL bp+4    p
;  201 ptr sign byte   199 NULL bp+6    q;
 ENTER  0,0
@@eqstr222:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr223

;-200     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr224
 mov eax, 0
 jmp @@retn
@@eqstr224:
 inc  word [bp+4]
 inc  word [bp+6]

;-201     if(*q) return 0; return 1; }

 jmp @@eqstr222
@@eqstr223:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr225
 mov eax, 0
 jmp @@retn
@@eqstr225:
 mov eax, 1
 jmp @@retn

;-202 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   202 NULL bp+4    s
;  201 ptr sign byte   202 NULL bp+6    t;
 ENTER  0,0
@@strcat1226:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1227
 inc  word [bp+4]
 jmp @@strcat1226
@@strcat1227:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-203 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   203 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-204 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   204 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-205 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   205 NULL bp+4    s
;  201 var sign word   205 NULL bp+6    fd
;  202 var sign word   205 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-206 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   206 NULL bp+4    n
;  201 var sign word   206 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-207   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-208 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   208 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-209 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   209 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-210 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
 LEAVE
 ret
; ENDP
;End of archive file. 
 
; missing functions: 
; putch
; DosInt
; DosInt
; DosInt
; DosInt
; Number of unresolved CALLs :    5
;use archive file: AR.C

;-211 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   211 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch228
 mov  al, 13
 call writetty
@@putch228:
 mov  al, [bp+4]
 call writetty

;-212 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt229
 inc  word [DOS_ERR]
@@DosInt229:

;-213 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

 ret
; ENDP
;End of archive file. 
 
; missing functions:  All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width line used  address name   list of global variables

;    1 arr sign byte     2    2        0 Version1[19]
;    2 var sign byte     1    3        0 LIST
;    3 arr sign byte     2    7    30000 Symbol[80]
;    4 arr sign byte     3   36    30080 SymbolUpper[80]
;    5 var unsg word     4   12        0 SymbolInt
;    6 arr sign byte     5    3    30160 InputBuf[128]
;    7 ptr unsg byte     6   23        0 InputPtr
;    8 arr sign byte     7    5    30288 namein[67]
;    9 arr sign byte     8    5    30355 namelst[67]
;   10 arr sign byte     9    5    30422 namebin[67]
;   11 var sign word    10    4        0 asm_fd
;   12 var sign word    11    3        0 lst_fd
;   13 var sign word    12    3        0 bin_fd
;   14 var sign word    13    6        0 DOS_ERR
;   15 var sign word    14    4        0 ErrorCount
;   16 var sign word    15    4        0 DOS_NoBytes
;   17 var sign byte    16    4        0 DOS_ByteRead
;   18 var unsg word    18    5        0 PC
;   19 var unsg word    19    2        0 PCStart
;   20 var sign byte    20    3        0 isLabel
;   21 def unsg byte    21    -        0 DIGIT=1
;   22 def unsg byte    22    -        0 LETTERE=2
;   23 def unsg byte    23    -        0 ALNUME=3
;   24 def unsg byte    24    -        0 NOALNUME=4
;   25 var sign byte    25   20        0 TokeType
;   26 def unsg byte    26    -        0 BYTE=1
;   27 def unsg byte    27    -        0 WORD=2
;   28 def unsg byte    28    -        0 DWORD=3
;   29 def unsg byte    29    -        0 SEGREG=4
;   30 def unsg byte    31    -        0 IMM=1
;   31 def unsg byte    32    -        0 REG=2
;   32 def unsg byte    33    -        0 DIR=3
;   33 def unsg byte    34    -        0 IND=4
;   34 var sign byte    35   13        0 Op1
;   35 var sign byte    36   12        0 CodeType
;   36 var sign byte    38   17        0 RegType
;   37 var sign byte    39   10        0 RegNo
;   38 var sign byte    40   10        0 OpSize
;   39 var sign byte    42 NULL        0 NumOprns
;   40 var sign byte    43    5        0 wflag
;   41 var sign byte    44 NULL        0 dflag
;   42 var sign byte    46    4        0 reg
;   43 var sign word    47   13        0 disp
;   44 var sign word    48    2        0 imme
;   45 def unsg byte    50    -        0 OPMAXLEN=5
;   46 arr sign byte    51    2    30489 OpPos[5]
;   47 var sign word    52    6        0 OpPrintIndex
;   48 ptr sign byte    53   16        0 OpCodePtr
;   49 var sign byte    54    2        0 PrReloc
;   50 arr sign byte    56    3    30494 LabelNames[1000]
;   51 ptr sign byte    57   10        0 LabelNamePtr
;   52 arr unsg word    58    4    31494 LabelAddr[100]
;   53 var sign word    59    5        0 LabelMaxIx
;   54 var sign word    60    4        0 LabelIx
;   55 arr sign byte    62    3    31694 FileBin[2000]
;   56 var unsg word    63    5        0 BinLen
;   57 ptr sign byte    65    1        0 arglen
;   58 ptr sign byte    66    4        0 argv
;   59 var sign byte   186    1        0 I_START
;   60 arr sign byte   188 NULL        0 I_PUSHA[9]
;   61 arr sign byte   189 NULL        0 I_POPA[8]
;   62 arr sign byte   190 NULL        0 I_NOP[7]
;   63 arr sign byte   191 NULL        0 I_CBW[7]
;   64 arr sign byte   192 NULL        0 I_CWDE[8]
;   65 arr sign byte   193 NULL        0 I_CWD[7]
;   66 arr sign byte   194 NULL        0 I_CDQ[7]
;   67 arr sign byte   195 NULL        0 I_WAIT[8]
;   68 arr sign byte   196 NULL        0 I_PUSHF[9]
;   69 arr sign byte   197 NULL        0 I_POPF[8]
;   70 arr sign byte   198 NULL        0 I_SAHF[8]
;   71 arr sign byte   199 NULL        0 I_LAHF[8]
;   72 arr sign byte   200 NULL        0 I_MOVSB[9]
;   73 arr sign byte   201 NULL        0 I_MOVSW[9]
;   74 arr sign byte   202 NULL        0 I_CMPSB[9]
;   75 arr sign byte   203 NULL        0 I_CMPSW[9]
;   76 arr sign byte   204 NULL        0 I_STOSB[9]
;   77 arr sign byte   205 NULL        0 I_STOSW[9]
;   78 arr sign byte   206 NULL        0 I_LODSB[9]
;   79 arr sign byte   207 NULL        0 I_LODSW[9]
;   80 arr sign byte   208 NULL        0 I_SCASB[9]
;   81 arr sign byte   209 NULL        0 I_SCASW[9]
;   82 arr sign byte   210 NULL        0 I_LEAVE[9]
;   83 arr sign byte   211 NULL        0 I_IRET[8]
;   84 arr sign byte   212 NULL        0 I_XLAT[8]
;   85 arr sign byte   213 NULL        0 I_LOCK[8]
;   86 arr sign byte   214 NULL        0 I_REPNE[9]
;   87 arr sign byte   215 NULL        0 I_REPNZ[9]
;   88 arr sign byte   216 NULL        0 I_REPE[8]
;   89 arr sign byte   217 NULL        0 I_REPZ[8]
;   90 arr sign byte   218 NULL        0 I_HLT[7]
;   91 arr sign byte   219 NULL        0 I_CLC[7]
;   92 arr sign byte   220 NULL        0 I_STC[7]
;   93 arr sign byte   221 NULL        0 I_CLI[7]
;   94 arr sign byte   222 NULL        0 I_STI[7]
;   95 arr sign byte   223 NULL        0 I_CLD[7]
;   96 arr sign byte   224 NULL        0 I_STD[7]
;   97 arr sign byte   226 NULL        0 I_INC[9]
;   98 arr sign byte   227 NULL        0 I_DEC[9]
;   99 arr sign byte   229 NULL        0 I_NOT[8]
;  100 arr sign byte   230 NULL        0 I_NEG[8]
;  101 arr sign byte   231 NULL        0 I_MUL[8]
;  102 arr sign byte   232 NULL        0 I_IMUL[9]
;  103 arr sign byte   233 NULL        0 I_DIV[8]
;  104 arr sign byte   234 NULL        0 I_IDIV[9]
;  105 arr sign byte   236 NULL        0 I_LES[7]
;  106 arr sign byte   237 NULL        0 I_LDS[7]
;  107 arr sign byte   238 NULL        0 I_LEA[7]
;  108 arr sign byte   240 NULL        0 I_ADD[7]
;  109 arr sign byte   241 NULL        0 I_OR[6]
;  110 arr sign byte   242 NULL        0 I_ADC[7]
;  111 arr sign byte   243 NULL        0 I_SBB[7]
;  112 arr sign byte   244 NULL        0 I_AND[7]
;  113 arr sign byte   245 NULL        0 I_SUB[7]
;  114 arr sign byte   246 NULL        0 I_XOR[7]
;  115 arr sign byte   247 NULL        0 I_CMP[7]
;  116 arr sign byte   249 NULL        0 I_MOV[6]
;  117 arr sign byte   251 NULL        0 I_JO[6]
;  118 arr sign byte   252 NULL        0 I_JNO[7]
;  119 arr sign byte   253 NULL        0 I_JB[6]
;  120 arr sign byte   254 NULL        0 I_JC[6]
;  121 arr sign byte   255 NULL        0 I_JNB[7]
;  122 arr sign byte   256 NULL        0 I_JAE[7]
;  123 arr sign byte   257 NULL        0 I_JNC[7]
;  124 arr sign byte   258 NULL        0 I_JE[6]
;  125 arr sign byte   259 NULL        0 I_JZ[6]
;  126 arr sign byte   260 NULL        0 I_JNE[7]
;  127 arr sign byte   261 NULL        0 I_JNZ[7]
;  128 arr sign byte   262 NULL        0 I_JBE[7]
;  129 arr sign byte   263 NULL        0 I_JNA[7]
;  130 arr sign byte   264 NULL        0 I_JA[6]
;  131 arr sign byte   265 NULL        0 I_JS[6]
;  132 arr sign byte   266 NULL        0 I_JNS[7]
;  133 arr sign byte   267 NULL        0 I_JP[6]
;  134 arr sign byte   268 NULL        0 I_JPE[7]
;  135 arr sign byte   269 NULL        0 I_JNP[7]
;  136 arr sign byte   270 NULL        0 I_JPO[7]
;  137 arr sign byte   271 NULL        0 I_JL[6]
;  138 arr sign byte   272 NULL        0 I_JNL[7]
;  139 arr sign byte   273 NULL        0 I_JGE[7]
;  140 arr sign byte   274 NULL        0 I_JLE[7]
;  141 arr sign byte   275 NULL        0 I_JNG[7]
;  142 arr sign byte   276 NULL        0 I_JG[6]
;  143 arr sign byte   278 NULL        0 I_RET[8]
;  144 arr sign byte   280 NULL        0 I_PUSH[8]
;  145 arr sign byte   281 NULL        0 I_POP[7]
;  146 arr sign byte   283 NULL        0 I_ORG[6]
;  147 arr sign byte   284 NULL        0 I_DB[5]
;  148 arr sign byte   285 NULL        0 I_DW[5]
;  149 arr sign byte   286 NULL        0 I_DD[5]
;  150 arr sign byte   287 NULL        0 I_RESB[7]
;  151 arr sign byte   288 NULL        0 I_RESW[7]
;  152 arr sign byte   289 NULL        0 I_RESD[7]
;  153 var sign byte   290 NULL        0 I_END


;   # Calls Line Width  Name   list of functions

;    0 NULL    1 word   main
;    1    1    5 word   process
;    2   12   38 word   getTokeType
;    3 NULL   47 word   Ops
;    4    2   58 word   LeftOpwCheck
;    5    1   68 word   getLeftOp
;    6    1   80 word   setwflag
;    7    2   88 word   getOp1
;    8    1  100 word   getIND
;    9    1  115 word   getIndReg1
;   10    1  124 word   getIndReg2
;   11    1  134 word   getCodeSize
;   12    7  141 word   isToken
;   13    1  146 word   skipRest
;   14    1  150 word   gen66h
;   15    8  151 word   genCode8
;   16    3  155 word   genCode16
;   17    7  158 word   genInstruction
;   18    2  162 word   genCodeInREG
;   19 NULL  165 word   genModRegRM
;   20    2  167 word   writeEA
;   21 NULL  181 word   test1
;   22    1    2 word   parse
;   23    2   27 word   storeLabel
;   24    2   34 word   searchLabel
;   25    1   45 word   getVariable
;   26    1   76 word   getLine
;   27    1   89 word   ifEOL
;   28    3   96 word   skipBlank
;   29    2  101 word   letterE
;   30    1  110 word   alnumE
;   31    1  115 word   getDigit
;   32    1  127 word   getName
;   33    1  144 word   testReg
;   34    2  292 word   lookCode
;   35    1  307 word   printLine
;   36    9  325 word   prc
;   37    1  329 word   prscomment
;   38   24  332 word   prs
;   39    4  337 word   printhex8a
;   40    2  341 word   printhex16
;   41    3  344 word   printIntU
;   42   19  363 word   error1
;   43 NULL  366 word   allowederror
;   44 NULL  367 word   implmerror
;   45    4  368 word   indexerror
;   46    1  369 word   numbererror
;   47 NULL  370 word   regmemerror
;   48    1  371 word   segregerror
;   49    1  372 word   syntaxerror
;   50    7  374 word   errorexit
;   51    1  375 word   addrexit
;   52 NULL  376 word   internexit
;   53    1  378 word   getarg
;   54    1  403 word   epilog
;   55    2  434 word   end1
;   56    4  191 word   writetty
;   57    8  192 word   cputs
;   58    2  193 word   toupper
;   59    4  195 word   strlen
;   60    6  196 word   strcpy
;   61    4  198 word   digit
;   62   35  199 word   eqstr
;   63    3  202 word   strcat1
;   64    1  203 word   openR
;   65    2  204 word   creatR
;   66    2  205 word   readRL
;   67    2  206 word   fputcR
;   68    3  208 word   fcloseR
;   69    5  209 word   exitR
;   70    1  211 word   putch
;   71    4  212 word   DosInt
;   72 NULL  213 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0     5 getarg
;    1    12 parse
;    2    18 epilog
;    3    25 end1
;    4   483 getTokeType
;    5   495 getCodeSize
;    6   507 genInstruction
;    7   522 LeftOpwCheck
;    8   535 genInstruction
;    9   550 genInstruction
;   10   565 genInstruction
;   11   580 genCodeInREG
;   12   593 LeftOpwCheck
;   13   606 genInstruction
;   14   621 genCodeInREG
;   15   634 genInstruction
;   16   649 genCode16
;   17   659 genInstruction
;   18   674 error1
;   19   681 error1
;   20   702 skipBlank
;   21   712 digit
;   22   718 getDigit
;   23   727 letterE
;   24   735 getName
;   25   760 getLeftOp
;   26   770 segregerror
;   27   782 setwflag
;   28   791 error1
;   29   798 error1
;   30   805 error1
;   31   822 getOp1
;   32   829 isToken
;   33   837 getIND
;   34   844 error1
;   35   851 error1
;   36   867 gen66h
;   37   881 testReg
;   38   889 searchLabel
;   39   901 error1
;   40   922 getTokeType
;   41   934 getOp1
;   42   941 syntaxerror
;   43   953 getIndReg2
;   44   964 getIndReg1
;   45   975 isToken
;   46   983 getTokeType
;   47   995 numbererror
;   48  1007 isToken
;   49  1015 isToken
;   50  1023 errorexit
;   51  1046 indexerror
;   52  1057 indexerror
;   53  1084 indexerror
;   54  1095 indexerror
;   55  1118 eqstr
;   56  1124 getTokeType
;   57  1136 eqstr
;   58  1142 getTokeType
;   59  1154 eqstr
;   60  1160 getTokeType
;   61  1182 skipBlank
;   62  1201 getTokeType
;   63  1213 prs
;   64  1224 genCode8
;   65  1256 genCode8
;   66  1265 genCode8
;   67  1298 genCode8
;   68  1322 writeEA
;   69  1342 writeEA
;   70  1366 addrexit
;   71  1375 genCode8
;   72  1384 genCode8
;   73  1393 genCode16
;   74  1415 getLine
;   75  1423 getTokeType
;   76  1435 storeLabel
;   77  1446 getTokeType
;   78  1458 lookCode
;   79  1467 process
;   80  1475 getVariable
;   81  1487 skipRest
;   82  1496 error1
;   83  1503 error1
;   84  1510 printLine
;   85  1531 searchLabel
;   86  1543 error1
;   87  1550 strcpy
;   88  1577 eqstr
;   89  1583 strlen
;   90  1604 storeLabel
;   91  1615 getTokeType
;   92  1627 lookCode
;   93  1636 errorexit
;   94  1646 errorexit
;   95  1656 getTokeType
;   96  1668 genCode8
;   97  1677 skipBlank
;   98  1687 isToken
;   99  1695 genCode8
;  100  1704 isToken
;  101  1712 getTokeType
;  102  1724 genCode16
;  103  1734 isToken
;  104  1742 errorexit
;  105  1760 readRL
;  106  1767 errorexit
;  107  1777 ifEOL
;  108  1791 readRL
;  109  1818 digit
;  110  1833 digit
;  111  1839 letterE
;  112  1866 digit
;  113  1884 alnumE
;  114  1891 strcpy
;  115  1898 toupper
;  116  1914 strlen
;  117  1921 strlen
;  118  1928 eqstr
;  119  1934 eqstr
;  120  1940 eqstr
;  121  1946 eqstr
;  122  1952 eqstr
;  123  1958 eqstr
;  124  1964 eqstr
;  125  1970 eqstr
;  126  1976 eqstr
;  127  1982 eqstr
;  128  1988 eqstr
;  129  1994 eqstr
;  130  2000 eqstr
;  131  2006 eqstr
;  132  2012 eqstr
;  133  2018 eqstr
;  134  2024 eqstr
;  135  2030 eqstr
;  136  2036 eqstr
;  137  2042 eqstr
;  138  2048 eqstr
;  139  2054 eqstr
;  140  2060 eqstr
;  141  2066 eqstr
;  142  2072 eqstr
;  143  2078 eqstr
;  144  2084 eqstr
;  145  2090 eqstr
;  146  2096 eqstr
;  147  2102 eqstr
;  148  2722 eqstr
;  149  2742 prs
;  150  2746 printhex16
;  151  2757 prs
;  152  2761 prc
;  153  2765 printhex8a
;  154  2776 prc
;  155  2780 prs
;  156  2784 prscomment
;  157  2801 writetty
;  158  2810 writetty
;  159  2819 fputcR
;  160  2841 prc
;  161  2857 prc
;  162  2878 prc
;  163  2882 prc
;  164  2904 printhex8a
;  165  2915 printhex8a
;  166  2940 printIntU
;  167  2950 prc
;  168  2963 prs
;  169  2967 prs
;  170  2971 prs
;  171  2975 prs
;  172  2992 error1
;  173  3010 error1
;  174  3028 error1
;  175  3047 error1
;  176  3066 error1
;  177  3085 error1
;  178  3104 error1
;  179  3123 error1
;  180  3130 end1
;  181  3144 errorexit
;  182  3165 errorexit
;  183  3194 cputs
;  184  3200 cputs
;  185  3206 exitR
;  186  3212 toupper
;  187  3220 strcpy
;  188  3227 strcat1
;  189  3235 strcpy
;  190  3242 strcat1
;  191  3250 strcpy
;  192  3257 strcat1
;  193  3265 openR
;  194  3271 cputs
;  195  3277 cputs
;  196  3283 exitR
;  197  3289 creatR
;  198  3296 cputs
;  199  3302 cputs
;  200  3308 exitR
;  201  3314 creatR
;  202  3321 cputs
;  203  3327 cputs
;  204  3333 exitR
;  205  3339 prs
;  206  3343 prs
;  207  3347 prs
;  208  3351 prs
;  209  3355 prs
;  210  3359 prs
;  211  3363 prs
;  212  3367 prs
;  213  3371 prs
;  214  3388 prs
;  215  3392 printIntU
;  216  3402 prs
;  217  3406 prs
;  218  3410 prs
;  219  3414 prc
;  220  3418 printhex16
;  221  3429 prs
;  222  3433 strlen
;  223  3440 prs
;  224  3444 printIntU
;  225  3454 prs
;  226  3458 prc
;  227  3462 printhex8a
;  228  3473 fputcR
;  229  3487 fcloseR
;  230  3495 fcloseR
;  231  3503 fcloseR
;  232  3511 exitR
;  233  3536 putch
;  234  3604 strcpy
;  235  3619 DosInt
;  236  3635 DosInt
;  237  3658 DosInt
;  238  3677 DosInt
;  239  3711 writetty
;  240  3720 writetty
;Input: AS.C, List: AS.S,  Lines:  214
;Glob. variables:  153 max.:  200
;Local variables:    3 max.:  100, in 'genInstruction'
;Functions      :   73 max.:  300
;Calls          :  241 max.: 2000, NameField: 3752 max.:    65535
;Code until     :26009 max.: 30000, free: 3991
;Data (HeapEnd) :33694, resting stacksize: 31841
;Max. Const in 'testReg' :  658 max. 3000, free: 2342