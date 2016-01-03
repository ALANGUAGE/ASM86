
; A.COM CComp V0.7 16.11.2014, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
;PROTECTED: 0 V86 OFF.  32bit: ON. 
org  256 ; NASM ON
jmp main

;-1 int main() {getarg(); parse(); epilog(); end1();}//BAS   AS TE


main:  ; *** PROC ***
 call getarg
 call parse
 call epilog
 call end1

;-2 char Version1[]="AS.C V0.06 4.1.2015";//alt-re 5[  7|  8{  N~  7Caps \

 ret
; ENDP
Version1 db "AS.C V0.06 4.1.2015",0

;-3 char LIST;

LIST db 0

;-4 char Symbol[80]; char SymbolUpper[80]; unsigned int SymbolInt;

section .bss
absolute 30000
Symbol resb 80
section .text
section .bss
absolute 30080
SymbolUpper resb 80
section .text
SymbolInt dw 0

;-5 char InputBuf[128];  unsigned char *InputPtr;

section .bss
absolute 30160
InputBuf resb 128
section .text
InputPtr dw 0

;-6 char namein [67]; char namelst[67]; char namebin[67];

section .bss
absolute 30288
namein resb 67
section .text
section .bss
absolute 30355
namelst resb 67
section .text
section .bss
absolute 30422
namebin resb 67
section .text

;-7 int  asm_fd;       int lst_fd;       int bin_fd;

asm_fd dw 0
lst_fd dw 0
bin_fd dw 0

;-8 int DOS_ERR;     int ErrorCount;

DOS_ERR dw 0
ErrorCount dw 0

;-9 int DOS_NoBytes; char DOS_ByteRead;

DOS_NoBytes dw 0
DOS_ByteRead db 0

;-10 


;-11 unsigned int PC;   //program counter, ORG nn

PC dw 0

;-12 unsigned int PCStart;//PC at start of line by PrintLine()

PCStart dw 0

;-13 char isLabel;      //by getName()

isLabel db 0

;-14 #define LABEL    1


;-15 #define VARIABLE 2


;-16 #define DIGIT    1 //0-9


;-17 #define ALNUM    2 //0-9 _ a-z A-Z


;-18 char TokeType;     //0, DIGIT, ALNUM, noalnum

TokeType db 0

;-19 #define BYTE     1


;-20 #define WORD     2


;-21 #define DWORD    3


;-22 #define SEGREG   4


;-23 //char CodeSize;     //0, BYTE, WORD, DWORD


;-24 #define IMM      1 //const  ,123


;-25 #define REG      2 //       ,BX    mode=11


;-26 #define DIR      3 //VALUE  ,var1  mod=00, r/m=110


;-27 #define IND      4 //indirec,[var1], [BX+SI], [table+BX], [bp-4]  disp 0,8,16


;-28 char Op1;          //0, IMM, REG, DIR, IND

Op1 db 0

;-29 int  CodeType;     //1-207 by searchSymbol()

CodeType dw 0

;-30 


;-31 char RegType;      //0=no reg, BYTE, WORD, DWORD, SEGREG

RegType db 0

;-32 char RegNo;        //0 - 7 AL, CL, ...  by testReg()

RegNo db 0

;-33 char OpSize;       //0, BYTE, WORD, DWORD

OpSize db 0

;-34 //char AddrSize;   //67h:


;-35 char NumOprns;     //0-2

NumOprns db 0

;-36 char wflag;        //0=byte, 1=word/dword

wflag db 0

;-37 char dflag;        //0=source is reg,  1=dest is reg

dflag db 0

;-38 //char modrm;        //mod, r/m


;-39 char reg;          //combination of index and base reg

reg db 0

;-40 int disp;          //displacement      0-8 bytes

disp dw 0

;-41 int imme;          //immediate         0-8 bytes

imme dw 0

;-42 


;-43 #define OPMAXLEN  5


;-44 char OpPos[OPMAXLEN];

section .bss
absolute 30489
OpPos resb 5
section .text

;-45 int OpPrintIndex;  //0-OPMAXLEN, Position to print opcode, by genCode8()

OpPrintIndex dw 0

;-46 char *OpCodePtr;   //position in OpCodeTable by searchSymbol(), div.

OpCodePtr dw 0

;-47 char PrReloc;      //print 'R' if relocative

PrReloc db 0

;-48 char LabelNames[1000]; char *LabelNamePtr;

section .bss
absolute 30494
LabelNames resb 1000
section .text
LabelNamePtr dw 0

;-49 char LabelType  [100]; unsigned int LabelAddr[100];

section .bss
absolute 31494
LabelType resb 100
section .text
section .bss
absolute 31594
LabelAddr resw 100
section .text

;-50 int LabelMaxIx=0;  int LabelIx;

LabelMaxIx dw 0
LabelIx dw 0

;-51 char FileBin  [2000]; unsigned int BinLen=0;

section .bss
absolute 31794
FileBin resb 2000
section .text
BinLen dw 0

;-52 


;-53 int process() { int i; char c;


process:  ; *** PROC ***

;-54   setTokeType();

;Function : process, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word    53 NULL bp-2    i
;  201 var sign byte    53 NULL bp-4    c;
 ENTER  4,0
 call setTokeType

;-55   OpSize=getCodeSize();

 call getCodeSize
 mov byte [OpSize], al

;-56 


;-57   if (CodeType ==  1) {//1 byte opcode

 mov ax, [CodeType]
 cmp ax, 1
 jne @@process1

;-58     genInstruction(0, 1); return;

 push 1
 push 0
 call genInstruction
 add  sp, 4
 jmp @@retn

;-59   }


;-60   if (CodeType ==  2) {//inc, dec

@@process1:
 mov ax, [CodeType]
 cmp ax, 2
 jne @@process2

;-61     LeftOpwCheck();

 call LeftOpwCheck

;-62     	if (Op1 == REG) {

 mov al, [Op1]
 cmp al, 2
 jne @@process3

;-63         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form

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

;-64         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }

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

;-65       genInstruction(wflag, 1); genCodeInREG(); return; 

@@process3:
 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 call genCodeInREG
 jmp @@retn

;-66   }


;-67 


;-68   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul

@@process2:
 mov ax, [CodeType]
 cmp ax, 52
 jne @@process6

;-69     LeftOpwCheck();

 call LeftOpwCheck

;-70     genInstruction(wflag, 1); genCodeInREG(); return; 

 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 call genCodeInREG
 jmp @@retn

;-71   }


;-72 


;-73   if (CodeType==  8) {// ret

@@process6:
 mov ax, [CodeType]
 cmp ax, 8
 jne @@process7

;-74     if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}

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

;-75     genInstruction(0, 1); return; 

@@process8:
 push 1
 push 0
 call genInstruction
 add  sp, 4
 jmp @@retn

;-76   }


;-77 


;-78   if (CodeType==101) {// ORG nn

@@process7:
 mov ax, [CodeType]
 cmp ax, 101
 jne @@process9

;-79     if (TokeType != DIGIT) error1("only digit allowed");

 mov al, [TokeType]
 cmp al, 1
 je  @@process10
 push process_0
 call error1
 add  sp, 2

;-80     PC=SymbolInt;return;

@@process10:
 mov ax, [SymbolInt]
 mov word [PC], ax
 jmp @@retn

;-81   }


;-82   error1("unknown CodeType");

@@process9:
 push process_1
 call error1
 add  sp, 2

;-83 }


;-84 


;-85 // scan code .....................................


;-86 int setTokeType() { char c; //set: TokeType

@@retn: LEAVE
 ret
; ENDP
process_0 db "only digit allowed",0
process_1 db "unknown CodeType",0

setTokeType:  ; *** PROC ***

;-87   skipBlank();

;Function : setTokeType, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    86 NULL bp-2    c;
 ENTER  2,0
 call skipBlank

;-88   c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-89   if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne @@setTokeType11
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-90   if (c == ';') {TokeType=0; return; }//comment

@@setTokeType11:
 mov al, [bp-2]
 cmp al, 59
 jne @@setTokeType12
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-91   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

@@setTokeType12:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@setTokeType13
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov eax, 1
 mov byte [TokeType], al
 jmp @@retn

;-92   if (alnum (c)) {getName(c); TokeType=ALNUM; return;}//ret:2=Symbol

@@setTokeType13:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call alnum
 add  sp, 2
 or  al, al
 je @@setTokeType14
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov eax, 2
 mov byte [TokeType], al
 jmp @@retn

;-93   TokeType=3; return;               //no alnum

@@setTokeType14:
 mov eax, 3
 mov byte [TokeType], al
 jmp @@retn

;-94 }


;-95 int Ops() {

@@retn: LEAVE
 ret
; ENDP

Ops:  ; *** PROC ***

;-96 //O2=rr,rm,ri,mr,mi


;-97 //NumOprns==2, seg reg not allowed only mov and push


;-98 //size: 1.declaration CodeSize, 2.reg size, 3.error1


;-99 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);


;-100 //2. rm , imm 80  


;-101 //2a sign ext 83


;-102 //3. reg, rm  02  if (dest==reg) set direction bit; else default;


;-103 //4. rm , reg 00


;-104 //5. error1(mem2mem)


;-105 }


;-106 int LeftOpwCheck() {

 ret
; ENDP

LeftOpwCheck:  ; *** PROC ***

;-107   getLeftOp();

 call getLeftOp

;-108   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop

 mov al, [RegType]
 cmp al, 4
 jne @@LeftOpwCheck15
 call segregerror
 jmp @@retn

;-109   setwflag();

@@LeftOpwCheck15:
 call setwflag

;-110   if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne @@LeftOpwCheck16
 push LeftOpwCheck_0
 call error1
 add  sp, 2

;-111   if (OpSize == RegType) return;

@@LeftOpwCheck16:
 mov al, [OpSize]
 cmp al, [RegType]
 jne @@LeftOpwCheck17
 jmp @@retn

;-112   if (OpSize){if (Op1 == IND) return; 

@@LeftOpwCheck17:
 mov al, [OpSize]
 or  al, al
 je @@LeftOpwCheck18
 mov al, [Op1]
 cmp al, 4
 jne @@LeftOpwCheck19
 jmp @@retn

;-113     error1("Conflict OpSize and RegSize"); }

@@LeftOpwCheck19:
 push LeftOpwCheck_1
 call error1
 add  sp, 2

;-114   if (RegType==0) error1("no register defined");

@@LeftOpwCheck18:
 mov al, [RegType]
 cmp al, 0
 jne @@LeftOpwCheck20
 push LeftOpwCheck_2
 call error1
 add  sp, 2

;-115 }

@@LeftOpwCheck20:

;-116 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)

@@retn:
 ret
; ENDP
LeftOpwCheck_0 db "no op size declared",0
LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
LeftOpwCheck_2 db "no register defined",0

getLeftOp:  ; *** PROC ***

;-117 //set: op1, disp->imm, reg, regt->size  


;-118   disp=0; imme=0; reg=0; 

 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov word [imme], ax
 mov eax, 0
 mov byte [reg], al

;-119 


;-120   Op1=getOp1();

 call getOp1
 mov byte [Op1], al

;-121   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je @@getLeftOp21
 mov eax, 4
 mov byte [Op1], al
 call getIND
 jmp @@retn

;-122   if (Op1 == 0) error1("Name of operand expected");

@@getLeftOp21:
 mov al, [Op1]
 cmp al, 0
 jne @@getLeftOp22
 push getLeftOp_0
 call error1
 add  sp, 2

;-123   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1

@@getLeftOp22:
 mov al, [Op1]
 cmp al, 1
 jne @@getLeftOp23
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp @@retn

;-124   if (Op1 == REG) return;                                    //2

@@getLeftOp23:
 mov al, [Op1]
 cmp al, 2
 jne @@getLeftOp24
 jmp @@retn

;-125   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3

@@getLeftOp24:
 mov al, [Op1]
 cmp al, 3
 jne @@getLeftOp25
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp @@retn

;-126   error1("Name of operand expected #1");

@@getLeftOp25:
 push getLeftOp_1
 call error1
 add  sp, 2

;-127 }


;-128 int setwflag() {//only Op1 (first operand)

@@retn:
 ret
; ENDP
getLeftOp_0 db "Name of operand expected",0
getLeftOp_1 db "Name of operand expected #1",0

setwflag:  ; *** PROC ***

;-129   wflag=0;

 mov eax, 0
 mov byte [wflag], al

;-130   if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne @@setwflag26

;-131     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}

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

;-132   }

@@setwflag27:

;-133   if (OpSize  == DWORD) {gen66h(); wflag=1;}

@@setwflag26:
 mov al, [OpSize]
 cmp al, 3
 jne @@setwflag29
 call gen66h
 mov eax, 1
 mov byte [wflag], al

;-134   if (OpSize  ==  WORD) wflag=1;

@@setwflag29:
 mov al, [OpSize]
 cmp al, 2
 jne @@setwflag30
 mov eax, 1
 mov byte [wflag], al

;-135 }

@@setwflag30:

;-136 int getOp1() {//scan for a single operand 

 ret
; ENDP

getOp1:  ; *** PROC ***

;-137   //set:Op1, imme, disp, RegType, TegNo, reg


;-138   if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne @@getOp131
 mov eax, 0
 jmp @@retn

;-139   if (TokeType == DIGIT)  return IMM;// 1

@@getOp131:
 mov al, [TokeType]
 cmp al, 1
 jne @@getOp132
 mov eax, 1
 jmp @@retn

;-140   if (TokeType == ALNUM) {

@@getOp132:
 mov al, [TokeType]
 cmp al, 2
 jne @@getOp133

;-141     RegNo=testReg();//set global RegType

 call testReg
 mov byte [RegNo], al

;-142     if (RegType)          return REG;// 2

 mov al, [RegType]
 or  al, al
 je @@getOp134
 mov eax, 2
 jmp @@retn

;-143     LabelIx=searchLabel(VARIABLE);//disp=LabelAddr[LabelIx];

@@getOp134:
 push 2
 call searchLabel
 add  sp, 2
 mov word [LabelIx], ax

;-144     if (LabelIx)          return DIR;// 3

 mov ax, [LabelIx]
 or  al, al
 je @@getOp135
 mov eax, 3
 jmp @@retn

;-145     else error1("variable not found"); }

 jmp @@getOp136
@@getOp135:
 push getOp1_0
 call error1
 add  sp, 2
@@getOp136:

;-146   return 0;

@@getOp133:
 mov eax, 0
 jmp @@retn

;-147 }


;-148 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]

@@retn:
 ret
; ENDP
getOp1_0 db "variable not found",0

getIND:  ; *** PROC ***

;-149   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI

;Function : getIND, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   149 NULL bp-2    op2
;  201 var sign byte   149 NULL bp-4    r1;
 ENTER  4,0
 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov byte [bp-4], al
 mov eax, 0
 mov byte [RegType], al

;-150   do {

@@getIND37:

;-151     setTokeType();// 0, DIGIT, ALNUM, no alnum

 call setTokeType

;-152     op2=getOp1();

 call getOp1
 mov byte [bp-2], al

;-153     if (op2 ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne @@getIND38
 call syntaxerror

;-154     if (op2 == IMM) disp=disp+SymbolInt;

@@getIND38:
 mov al, [bp-2]
 cmp al, 1
 jne @@getIND39
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-155     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();

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

;-156     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable

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

;-157     if (isToken('-')) {setTokeType(); 

@@getIND43:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je @@getIND44
 call setTokeType

;-158       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}

 mov al, [TokeType]
 cmp al, 1
 je  @@getIND45
 call numbererror
@@getIND45:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-159   } while (isToken('+'));

@@getIND44:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je @@getIND46
 jmp @@getIND37
@@getIND46:

;-160   if (isToken(']') == 0) errorexit("] expected"); 

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne @@getIND47
 push getIND_0
 call errorexit
 add  sp, 2

;-161   reg=r1;

@@getIND47:
 mov al, [bp-4]
 mov byte [reg], al

;-162 }


;-163 int getIndReg1() {char m; m=0;
 LEAVE
 ret
; ENDP
getIND_0 db "] expected",0

getIndReg1:  ; *** PROC ***
;Function : getIndReg1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   163 NULL bp-2    m;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-164   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg148
 call indexerror

;-165   if (RegNo==3) m=7;//BX

@@getIndReg148:
 mov al, [RegNo]
 cmp al, 3
 jne @@getIndReg149
 mov eax, 7
 mov byte [bp-2], al

;-166   if (RegNo==5) m=6;//BP change to BP+0

@@getIndReg149:
 mov al, [RegNo]
 cmp al, 5
 jne @@getIndReg150
 mov eax, 6
 mov byte [bp-2], al

;-167   if (RegNo==7) m=5;//DI

@@getIndReg150:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg151
 mov eax, 5
 mov byte [bp-2], al

;-168   if (RegNo==6) m=4;//SI

@@getIndReg151:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg152
 mov eax, 4
 mov byte [bp-2], al

;-169   if (m    ==0) indexerror();

@@getIndReg152:
 mov al, [bp-2]
 cmp al, 0
 jne @@getIndReg153
 call indexerror

;-170   return m;

@@getIndReg153:
 mov al, [bp-2]
 jmp @@retn

;-171 }


;-172 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI

@@retn: LEAVE
 ret
; ENDP

getIndReg2:  ; *** PROC ***
;Function : getIndReg2, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   172 NULL bp+4    r1
;  201 var sign byte   172 NULL bp-2    m;
 ENTER  2,0
 mov eax, 4
 mov byte [bp-2], al

;-173   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg254
 call indexerror

;-174   if (RegNo==7) if (r1==6) m=3;//BP+DI

@@getIndReg254:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg255
 mov al, [bp+4]
 cmp al, 6
 jne @@getIndReg256
 mov eax, 3
 mov byte [bp-2], al

;-175            else if (r1==7) m=1;//BX+DI

 jmp @@getIndReg257
@@getIndReg256:
 mov al, [bp+4]
 cmp al, 7
 jne @@getIndReg258
 mov eax, 1
 mov byte [bp-2], al

;-176   if (RegNo==6) if (r1==6) m=2;//BP+SI

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

;-177            else if (r1==7) m=0;//BX+DI

 jmp @@getIndReg261
@@getIndReg260:
 mov al, [bp+4]
 cmp al, 7
 jne @@getIndReg262
 mov eax, 0
 mov byte [bp-2], al

;-178   if (m > 3) indexerror();

@@getIndReg262:
@@getIndReg261:
@@getIndReg259:
 mov al, [bp-2]
 cmp al, 3
 jle @@getIndReg263
 call indexerror

;-179   return m;

@@getIndReg263:
 mov al, [bp-2]
 jmp @@retn

;-180 }


;-181 


;-182 int getCodeSize() {

@@retn: LEAVE
 ret
; ENDP

getCodeSize:  ; *** PROC ***

;-183   if (TokeType ==ALNUM) {

 mov al, [TokeType]
 cmp al, 2
 jne @@getCodeSize64

;-184     if (eqstr(SymbolUpper,"BYTE")) {setTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize65
 call setTokeType
 mov eax, 1
 jmp @@retn

;-185     if (eqstr(SymbolUpper,"WORD")) {setTokeType(); return WORD;}

@@getCodeSize65:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize66
 call setTokeType
 mov eax, 2
 jmp @@retn

;-186     if (eqstr(SymbolUpper,"DWORD")){setTokeType(); return DWORD;}

@@getCodeSize66:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize67
 call setTokeType
 mov eax, 3
 jmp @@retn

;-187   } return 0;

@@getCodeSize67:
@@getCodeSize64:
 mov eax, 0
 jmp @@retn

;-188 }


;-189 int isToken(char c) {

@@retn:
 ret
; ENDP
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0

isToken:  ; *** PROC ***

;-190   skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   189 NULL bp+4    c;
 ENTER  0,0
 call skipBlank

;-191   if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne @@isToken68

;-192     InputPtr++; return 1;} return 0;

 inc  word [InputPtr]
 mov eax, 1
 jmp @@retn
@@isToken68:
 mov eax, 0
 jmp @@retn

;-193 }


;-194 /*int need(char c) {


;-195   if (isToken(c) == 0) {


;-196     prs("\n; ************** expected >> "); prc(c);


;-197     prs(" <<\\n"); errorexit("token expected"); }  }*/


;-198 int skipRest() {

@@retn: LEAVE
 ret
; ENDP

skipRest:  ; *** PROC ***

;-199   setTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");

 call setTokeType
 mov al, [TokeType]
 cmp al, 0
 je  @@skipRest69
 push skipRest_0
 call prs
 add  sp, 2

;-200 }

@@skipRest69:

;-201 // generate code ...........................................................


;-202 int gen66h() {genCode8(0x66);}

 ret
; ENDP
skipRest_0 db "\n; ********** extra char ignored",0

gen66h:  ; *** PROC ***
 push 102
 call genCode8
 add  sp, 2

;-203 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++

 ret
; ENDP

genCode8:  ; *** PROC ***

;-204   FileBin[BinLen]=c; BinLen++; PC++;

;Function : genCode8, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   203 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
 inc  word [BinLen]
 inc  word [PC]

;-205   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }

 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode870
 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
 inc  word [OpPrintIndex]

;-206 }

@@genCode870:

;-207 int genCode16(int i) {
 LEAVE
 ret
; ENDP

genCode16:  ; *** PROC ***

;-208   genCode8(i); i=i >> 8; genCode8(i);

;Function : genCode16, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   207 NULL bp+4    i;
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

;-209 }


;-210 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
 LEAVE
 ret
; ENDP

genInstruction:  ; *** PROC ***

;-211   if(loc) OpCodePtr=OpCodePtr+loc;

;Function : genInstruction, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign byte   210 NULL bp+4    No
;  201 var sign word   210 NULL bp+6    loc
;  202 var sign byte   210 NULL bp-2    c;
 ENTER  2,0
 mov ax, [bp+6]
 or  al, al
 je @@genInstruction71
 mov ax, [OpCodePtr]
 add ax, [bp+6]
 mov word [OpCodePtr], ax

;-212   c= *OpCodePtr + No; genCode8(c);

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

;-213 }


;-214 int genCodeInREG() {char x; //get Code for second byte
 LEAVE
 ret
; ENDP

genCodeInREG:  ; *** PROC ***

;-215   OpCodePtr++; x= *OpCodePtr; writeEA(x);

;Function : genCodeInREG, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   214 NULL bp-2    x;
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

;-216 }


;-217 int genModRegRM(){ writeEA(reg);//todo
 LEAVE
 ret
; ENDP

genModRegRM:  ; *** PROC ***
 mov al, byte [reg]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-218 }


;-219 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg

 ret
; ENDP

writeEA:  ; *** PROC ***

;-220   len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   219 NULL bp+4    xxx
;  201 var sign byte   219 NULL bp-2    len;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-221   xxx = xxx << 3;//in reg field of mod r/m

 mov al, [bp+4]
 shl al, 3
 mov byte [bp+4], al

;-222   if (Op1 ==   0) addrexit();  

 mov al, [Op1]
 cmp al, 0
 jne @@writeEA72
 call addrexit

;-223   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2

@@writeEA72:
 mov al, [Op1]
 cmp al, 2
 jne @@writeEA73
 or  byte [bp+4], 192
 mov al, [bp+4]
 add al, [RegNo]
 mov byte [bp+4], al

;-224   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3

@@writeEA73:
 mov al, [Op1]
 cmp al, 3
 jne @@writeEA74
 or  byte [bp+4], 6
 mov eax, 2
 mov byte [bp-2], al

;-225   if (Op1 == IND) { xxx = xxx + reg;                       //4

@@writeEA74:
 mov al, [Op1]
 cmp al, 4
 jne @@writeEA75
 mov al, [bp+4]
 add al, [reg]
 mov byte [bp+4], al

;-226     if (disp) {disp; if(ax > 127) len=2; else len=1;

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

;-227       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}

@@writeEA78:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA79
 or  byte [bp+4], 64
 jmp @@writeEA80
@@writeEA79:
 or  byte [bp+4], 128
@@writeEA80:

;-228     }

@@writeEA76:

;-229   genCode8(xxx);// gen second byte

@@writeEA75:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-230   if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA81
 push word [disp]
 call genCode8
 add  sp, 2

;-231   if (len == 2) genCode16(disp);

@@writeEA81:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA82
 push word [disp]
 call genCode16
 add  sp, 2

;-232 }

@@writeEA82:

;-233 int test1() { __asm {
 LEAVE
 ret
; ENDP

test1:  ; *** PROC ***


;-234 inc byte [Version1]   ;FE 06 [1000]

inc byte [Version1]   ;FE 06 [1000]

;-235 add bx, ax    ;01 C3

add bx, ax    ;01 C3

;-236 add ax, bx    ;01 D8

add ax, bx    ;01 D8

;-237 add word ax, [bx] ;03 07

add word ax, [bx] ;03 07

;-238 VA dw 8

VA dw 8

;-239 mov byte [bp- 4], al ;88 46 FC

mov byte [bp- 4], al ;88 46 FC

;-240 mov      [VA+bx], al ;88 87 [300F]

mov      [VA+bx], al ;88 87 [300F]

;-241 }  }



;-242 #include "AS1.C"

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

;-8     setTokeType();// getCode in SymbolUpper, set TokeType, set isLabel by getName

 call setTokeType

;-9     if (TokeType == ALNUM) {

 mov al, [TokeType]
 cmp al, 2
 jne @@parse84

;-10       if (isLabel) {

 mov al, [isLabel]
 or  al, al
 je @@parse85

;-11         storeLabel(LABEL); 

 push 1
 call storeLabel
 add  sp, 2

;-12         InputPtr++;//remove :

 inc  word [InputPtr]

;-13         setTokeType();

 call setTokeType

;-14       }


;-15     }

@@parse85:

;-16     if (TokeType == ALNUM) {

@@parse84:
 mov al, [TokeType]
 cmp al, 2
 jne @@parse86

;-17       lookCode();// and OpCodePtr

 call lookCode

;-18       if(CodeType) process();

 mov ax, [CodeType]
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


;-22     else if (TokeType >  ALNUM) error1("Label or instruction expected");

 jmp @@parse89
@@parse86:
 mov al, [TokeType]
 cmp al, 2
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


;-27 int storeLabel(char LabType) {

 ret
; ENDP
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0

storeLabel:  ; *** PROC ***

;-28   if(searchLabel(LabType)) error1("duplicate symbol");

;Function : storeLabel, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    27 NULL bp+4    LabType;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call searchLabel
 add  sp, 2
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

;-32   LabelType[LabelMaxIx] = LabType;// 1=LABEL, 2=VARIABLE

 mov al, [bp+4]
 mov bx, [LabelMaxIx]
 mov [LabelType+bx], al

;-33   LabelAddr[LabelMaxIx] = PC;

 mov ax, [PC]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-34 }


;-35 int searchLabel(char searchType) {
 LEAVE
 ret
; ENDP
storeLabel_0 db "duplicate symbol",0

searchLabel:  ; *** PROC ***

;-36   int LIx; char *p; int j;


;-37   p = &LabelNames;

;Function : searchLabel, Number of local variables: 4
;   # type sign width line used address name   list of local variables
;  200 var sign byte    35 NULL bp+4    searchType
;  201 var sign word    36 NULL bp-2    LIx
;  202 ptr sign byte    36 NULL bp-4    p
;  203 var sign word    36 NULL bp-6    j;
 ENTER  6,0
 mov ax, LabelNames
 mov word [bp-4], ax

;-38   LIx=1;

 mov eax, 1
 mov word [bp-2], ax

;-39   while (LIx <= LabelMaxIx) {

@@searchLabel95:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel96

;-40     if (eqstr(p, Symbol)) return LIx;//and searchType

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel97
 mov ax, [bp-2]
 jmp @@retn

;-41     j=strlen(p);

@@searchLabel97:
 push word [bp-4]
 call strlen
 add  sp, 2
 mov word [bp-6], ax

;-42     p=p+j; p++; LIx++;

 mov ax, [bp-4]
 add ax, [bp-6]
 mov word [bp-4], ax
 inc  word [bp-4]
 inc  word [bp-2]

;-43   }


;-44   return 0;

 jmp @@searchLabel95
@@searchLabel96:
 mov eax, 0
 jmp @@retn

;-45 }


;-46 int getVariable() { char c;

@@retn: LEAVE
 ret
; ENDP

getVariable:  ; *** PROC ***

;-47   storeLabel(VARIABLE);

;Function : getVariable, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    46 NULL bp-2    c;
 ENTER  2,0
 push 2
 call storeLabel
 add  sp, 2

;-48   setTokeType(); if(TokeType==ALNUM) {// getName

 call setTokeType
 mov al, [TokeType]
 cmp al, 2
 jne @@getVariable98

;-49     lookCode();

 call lookCode

;-50     if (CodeType < 200) errorexit("D or RES B,W,D expected");

 mov ax, [CodeType]
 cmp ax, 200
 jge @@getVariable99
 push getVariable_0
 call errorexit
 add  sp, 2

;-51     if (CodeType > 207) errorexit("D or RES B,W,D expected");

@@getVariable99:
 mov ax, [CodeType]
 cmp ax, 207
 jle @@getVariable100
 push getVariable_1
 call errorexit
 add  sp, 2

;-52     if (CodeType== 200) {// DB

@@getVariable100:
 mov ax, [CodeType]
 cmp ax, 200
 jne @@getVariable101

;-53       do { setTokeType();

@@getVariable102:
 call setTokeType

;-54         if (TokeType ==DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable103
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-55         else {

 jmp @@getVariable104
@@getVariable103:

;-56           skipBlank();

 call skipBlank

;-57           if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable105

;-58             do { c= *InputPtr;

@@getVariable106:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-59               genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-60               InputPtr++;

 inc  word [InputPtr]

;-61             } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  @@getVariable107
 jmp @@getVariable106
@@getVariable107:

;-62             InputPtr++;

 inc  word [InputPtr]

;-63           }


;-64         }

@@getVariable105:

;-65       } while (isToken(','));

@@getVariable104:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable108
 jmp @@getVariable102
@@getVariable108:

;-66     }


;-67     if (CodeType== 201) {// DW

@@getVariable101:
 mov ax, [CodeType]
 cmp ax, 201
 jne @@getVariable109

;-68       do { setTokeType();

@@getVariable110:
 call setTokeType

;-69         if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable111
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-70       } while (isToken(','));

@@getVariable111:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable112
 jmp @@getVariable110
@@getVariable112:

;-71     }


;-72   }

@@getVariable109:

;-73   else errorexit("DB,DW,DD or RESB,W,D expected");

 jmp @@getVariable113
@@getVariable98:
 push getVariable_2
 call errorexit
 add  sp, 2

;-74 }

@@getVariable113:

;-75 // helper functions XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


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

;-101 int getDigit(unsigned char c) {//ret: SymbolInt

 ret
; ENDP

getDigit:  ; *** PROC ***

;-102   unsigned int CastInt;


;-103   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte   101 NULL bp+4    c
;  201 var unsg word   102 NULL bp-2    CastInt;
 ENTER  2,0
 mov eax, 0
 mov word [SymbolInt], ax

;-104   do {

@@getDigit122:

;-105     c-='0';

 sub  byte [bp+4], 48

;-106     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov ebx, 10
 mul ebx
 mov word [SymbolInt], ax

;-107     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov word [bp-2], ax

;-108     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-109     InputPtr++;

 inc  word [InputPtr]

;-110     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-111   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getDigit123
 jmp @@getDigit122
@@getDigit123:

;-112 }


;-113 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
; ENDP

getName:  ; *** PROC ***

;-114   char *p;


;-115   p = &Symbol;

;Function : getName, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte   113 NULL bp+4    c
;  201 ptr sign byte   114 NULL bp-2    p;
 ENTER  2,0
 mov ax, Symbol
 mov word [bp-2], ax

;-116   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-117   p++;

 inc  word [bp-2]

;-118   while (alnum(c)) {

@@getName124:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnum
 add  sp, 2
 or  al, al
 je @@getName125

;-119     InputPtr++;

 inc  word [InputPtr]

;-120     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-121     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-122     p++;

 inc  word [bp-2]

;-123   }


;-124   if (c == ':') isLabel=1; else isLabel=0;

 jmp @@getName124
@@getName125:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName126
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName127
@@getName126:
 mov eax, 0
 mov byte [isLabel], al

;-125   p--;

@@getName127:
 dec  word [bp-2]

;-126   *p = 0;

 mov eax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-127   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-128   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-129 }


;-130 int testReg() {
 LEAVE
 ret
; ENDP

testReg:  ; *** PROC ***

;-131 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-132   RegType=0;

 mov eax, 0
 mov byte [RegType], al

;-133   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge @@testReg128
 mov eax, 0
 jmp @@retn

;-134   if (strlen(Symbol) > 3) return 0;

@@testReg128:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg129
 mov eax, 0
 jmp @@retn

;-135   RegType=BYTE;

@@testReg129:
 mov eax, 1
 mov byte [RegType], al

;-136   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg130
 mov eax, 0
 jmp @@retn

;-137   if (eqstr(SymbolUpper, "CL")) return 1;

@@testReg130:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg131
 mov eax, 1
 jmp @@retn

;-138   if (eqstr(SymbolUpper, "DL")) return 2;

@@testReg131:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg132
 mov eax, 2
 jmp @@retn

;-139   if (eqstr(SymbolUpper, "BL")) return 3;

@@testReg132:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg133
 mov eax, 3
 jmp @@retn

;-140   if (eqstr(SymbolUpper, "AH")) return 4;

@@testReg133:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg134
 mov eax, 4
 jmp @@retn

;-141   if (eqstr(SymbolUpper, "CH")) return 5;

@@testReg134:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg135
 mov eax, 5
 jmp @@retn

;-142   if (eqstr(SymbolUpper, "DH")) return 6;

@@testReg135:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg136
 mov eax, 6
 jmp @@retn

;-143   if (eqstr(SymbolUpper, "BH")) return 7;

@@testReg136:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg137
 mov eax, 7
 jmp @@retn

;-144   RegType=WORD;

@@testReg137:
 mov eax, 2
 mov byte [RegType], al

;-145   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg138
 mov eax, 0
 jmp @@retn

;-146   if (eqstr(SymbolUpper, "CX")) return 1;

@@testReg138:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg139
 mov eax, 1
 jmp @@retn

;-147   if (eqstr(SymbolUpper, "DX")) return 2;

@@testReg139:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg140
 mov eax, 2
 jmp @@retn

;-148   if (eqstr(SymbolUpper, "BX")) return 3;

@@testReg140:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg141
 mov eax, 3
 jmp @@retn

;-149   if (eqstr(SymbolUpper, "SP")) return 4;

@@testReg141:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg142
 mov eax, 4
 jmp @@retn

;-150   if (eqstr(SymbolUpper, "BP")) return 5;

@@testReg142:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg143
 mov eax, 5
 jmp @@retn

;-151   if (eqstr(SymbolUpper, "SI")) return 6;

@@testReg143:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg144
 mov eax, 6
 jmp @@retn

;-152   if (eqstr(SymbolUpper, "DI")) return 7;

@@testReg144:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg145
 mov eax, 7
 jmp @@retn

;-153   RegType=SEGREG;

@@testReg145:
 mov eax, 4
 mov byte [RegType], al

;-154   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg146
 mov eax, 0
 jmp @@retn

;-155   if (eqstr(SymbolUpper, "CS")) return 1;

@@testReg146:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg147
 mov eax, 1
 jmp @@retn

;-156   if (eqstr(SymbolUpper, "SS")) return 2;

@@testReg147:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg148
 mov eax, 2
 jmp @@retn

;-157   if (eqstr(SymbolUpper, "DS")) return 3;

@@testReg148:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg149
 mov eax, 3
 jmp @@retn

;-158   if (eqstr(SymbolUpper, "FS")) return 4;

@@testReg149:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg150
 mov eax, 4
 jmp @@retn

;-159   if (eqstr(SymbolUpper, "GS")) return 5;

@@testReg150:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg151
 mov eax, 5
 jmp @@retn

;-160   RegType=DWORD;

@@testReg151:
 mov eax, 3
 mov byte [RegType], al

;-161   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg152
 mov eax, 0
 jmp @@retn

;-162   if (eqstr(SymbolUpper, "ECX"))return 1;

@@testReg152:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg153
 mov eax, 1
 jmp @@retn

;-163   if (eqstr(SymbolUpper, "EDX"))return 2;

@@testReg153:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg154
 mov eax, 2
 jmp @@retn

;-164   if (eqstr(SymbolUpper, "EBX"))return 3;

@@testReg154:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 3
 jmp @@retn

;-165   if (eqstr(SymbolUpper, "ESP"))return 4;

@@testReg155:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg156
 mov eax, 4
 jmp @@retn

;-166   if (eqstr(SymbolUpper, "EBP"))return 5;

@@testReg156:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg157
 mov eax, 5
 jmp @@retn

;-167   if (eqstr(SymbolUpper, "ESI"))return 6;

@@testReg157:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg158
 mov eax, 6
 jmp @@retn

;-168   if (eqstr(SymbolUpper, "EDI"))return 7;

@@testReg158:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg159
 mov eax, 7
 jmp @@retn

;-169   RegType=0; return 0;

@@testReg159:
 mov eax, 0
 mov byte [RegType], al
 mov eax, 0
 jmp @@retn

;-170 }


;-171 // opcodes XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;-172 char I_START=0xF1;//OpName,0,CodeType,OpCode1,OpCodeN,F1h

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

;-173 //  1:   1 byte opcode


;-174 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241

;-175 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};

I_POPA db 80,79,80,65,0,1,97,241

;-176 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};

I_NOP db 78,79,80,0,1,144,241

;-177 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};

I_CBW db 67,66,87,0,1,152,241

;-178 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};

I_CWDE db 67,87,68,69,0,1,152,241

;-179 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};

I_CWD db 67,87,68,0,1,153,241

;-180 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};

I_CDQ db 67,68,81,0,1,153,241

;-181 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};

I_WAIT db 87,65,73,84,0,1,155,241

;-182 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241

;-183 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};

I_POPF db 80,79,80,70,0,1,157,241

;-184 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};

I_SAHF db 83,65,72,70,0,1,158,241

;-185 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};

I_LAHF db 76,65,72,70,0,1,159,241

;-186 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241

;-187 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};

I_MOVSW db 77,79,86,83,87,0,1,165,241

;-188 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241

;-189 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};

I_CMPSW db 67,77,80,83,87,0,1,167,241

;-190 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241

;-191 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};

I_STOSW db 83,84,79,83,87,0,1,171,241

;-192 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241

;-193 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};

I_LODSW db 76,79,68,83,87,0,1,173,241

;-194 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241

;-195 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};

I_SCASW db 83,67,65,83,87,0,1,175,241

;-196 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241

;-197 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};

I_IRET db 73,82,69,84,0,1,207,241

;-198 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};

I_XLAT db 88,76,65,84,0,1,215,241

;-199 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};

I_LOCK db 76,79,67,75,0,1,240,241

;-200 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241

;-201 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};

I_REPNZ db 82,69,80,78,90,0,1,242,241

;-202 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};

I_REPE db 82,69,80,69,0,1,243,241

;-203 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};

I_REPZ db 82,69,80,90,0,1,243,241

;-204 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};

I_HLT db 72,76,84,0,1,244,241

;-205 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry

I_CLC db 67,76,67,0,1,248,241

;-206 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry

I_STC db 83,84,67,0,1,249,241

;-207 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt

I_CLI db 67,76,73,0,1,250,241

;-208 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt

I_STI db 83,84,73,0,1,251,241

;-209 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction

I_CLD db 67,76,68,0,1,252,241

;-210 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction

I_STD db 83,84,68,0,1,253,241

;-211 //  2: inc,dec


;-212 char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-213 char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-214 // 52: mem reg 16 bit


;-215 char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};

I_NOT db 78,79,84,0,52,246,2,241

;-216 char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};

I_NEG db 78,69,71,0,52,246,3,241

;-217 char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};

I_MUL db 77,85,76,0,52,246,4,241

;-218 char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc

I_IMUL db 73,77,85,76,0,52,246,5,241

;-219 char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};

I_DIV db 68,73,86,0,52,246,6,241

;-220 char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};

I_IDIV db 73,68,73,86,0,52,246,7,241

;-221 //  3: les, lda, lea


;-222 char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16

I_LES db 76,69,83,0,3,196,241

;-223 char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16

I_LDS db 76,68,83,0,3,197,241

;-224 char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16

I_LEA db 76,69,65,0,3,141,241

;-225 //  4: acc,imm  reg,imm  index,reg


;-226 char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-227 char I_OR []={'O','R',0,                4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-228 char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-229 char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-230 char I_AND[]={'A','N','D',0,            4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-231 char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-232 char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-233 char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-234 //  5: mov


;-235 char I_MOV[]={'M','O','V',0,            5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-236 //  6: single byte relative jump


;-237 char I_JO []={'J','O',0,                6, 0,     0xF1};

I_JO db 74,79,0,6,0,241

;-238 char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};

I_JNO db 74,78,79,0,6,1,241

;-239 char I_JB []={'J','B',0,                6, 2,     0xF1};

I_JB db 74,66,0,6,2,241

;-240 char I_JC []={'J','C',0,                6, 2,     0xF1};

I_JC db 74,67,0,6,2,241

;-241 char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};

I_JNB db 74,78,66,0,6,3,241

;-242 char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};

I_JAE db 74,65,69,0,6,3,241

;-243 char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};

I_JNC db 74,78,67,0,6,3,241

;-244 char I_JE []={'J','E',0,                6, 4,     0xF1};//      74 je i8 rel

I_JE db 74,69,0,6,4,241

;-245 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//   0F 84 je i16 rel

I_JZ db 74,90,0,6,4,241

;-246 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//66 0F 84 je i32 rel

I_JNE db 74,78,69,0,6,5,241

;-247 char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};

I_JNZ db 74,78,90,0,6,5,241

;-248 char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};

I_JBE db 74,66,69,0,6,6,241

;-249 char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};

I_JNA db 74,78,65,0,6,6,241

;-250 char I_JA []={'J','A',0,                6, 7,     0xF1};

I_JA db 74,65,0,6,7,241

;-251 char I_JS []={'J','S',0,                6, 8,     0xF1};

I_JS db 74,83,0,6,8,241

;-252 char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};

I_JNS db 74,78,83,0,6,9,241

;-253 char I_JP[]={'J','P',0,                 6,10,     0xF1};

I_JP db 74,80,0,6,10,241

;-254 char I_JPE[]={'J','P','E',0,            6,10,     0xF1};

I_JPE db 74,80,69,0,6,10,241

;-255 char I_JNP[]={'J','N','P',0,            6,11,     0xF1};

I_JNP db 74,78,80,0,6,11,241

;-256 char I_JPO[]={'J','P','O',0,            6,11,     0xF1};

I_JPO db 74,80,79,0,6,11,241

;-257 char I_JL[]={'J','L',0,                 6,12,     0xF1};

I_JL db 74,76,0,6,12,241

;-258 char I_JNL[]={'J','N','L',0,            6,13,     0xF1};

I_JNL db 74,78,76,0,6,13,241

;-259 char I_JGE[]={'J','G','E',0,            6,13,     0xF1};

I_JGE db 74,71,69,0,6,13,241

;-260 char I_JLE[]={'J','L','E',0,            6,14,     0xF1};

I_JLE db 74,76,69,0,6,14,241

;-261 char I_JNG[]={'J','N','G',0,            6,14,     0xF1};

I_JNG db 74,78,71,0,6,14,241

;-262 char I_JG []={'J','G',0,                6,15,     0xF1};

I_JG db 74,71,0,6,15,241

;-263 //  8: ret


;-264 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-265 //  9: seg, r/m


;-266 char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,241

;-267 char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16

I_POP db 80,79,80,0,9,88,241

;-268 //  100 directives


;-269 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-270 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-271 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-272 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-273 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};

I_RESB db 82,69,83,66,0,205,241

;-274 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};

I_RESW db 82,69,83,87,0,206,241

;-275 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};

I_RESD db 82,69,83,68,0,207,241

;-276 char I_END=0;// end of table char

I_END db 0

;-277 


;-278 int lookCode() { // ret: CodeType, OpCodePtr


lookCode:  ; *** PROC ***

;-279   CodeType=0;

 mov eax, 0
 mov word [CodeType], ax

;-280   OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-281   OpCodePtr++;

 inc  word [OpCodePtr]

;-282   do  {

@@lookCode160:

;-283     if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode161

;-284       while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode162:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode163
 inc  word [OpCodePtr]

;-285       OpCodePtr++; CodeType =*OpCodePtr;

 jmp @@lookCode162
@@lookCode163:
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov word [CodeType], ax

;-286       return;

 jmp @@retn

;-287     }


;-288   while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode161:
@@lookCode164:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode165
 inc  word [OpCodePtr]

;-289   OpCodePtr++;

 jmp @@lookCode164
@@lookCode165:
 inc  word [OpCodePtr]

;-290   } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode166
 jmp @@lookCode160
@@lookCode166:

;-291 }


;-292 // string functions error epilog XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX


;-293 int printLine() { int i; char c;

@@retn:
 ret
; ENDP

printLine:  ; *** PROC ***

;-294   prs("\n"); printhex16(PCStart);

;Function : printLine, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word   293 NULL bp-2    i
;  201 var sign byte   293 NULL bp-4    c;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2
 push word [PCStart]
 call printhex16
 add  sp, 2

;-295   if (OpPrintIndex == 0) prs("                ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne @@printLine167
 push printLine_1
 call prs
 add  sp, 2

;-296   else {

 jmp @@printLine168
@@printLine167:

;-297     prc(PrReloc);

 mov al, byte [PrReloc]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-298     i=0;

 mov eax, 0
 mov word [bp-2], ax

;-299     do {

@@printLine169:

;-300       c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov byte [bp-4], al

;-301       printhex8a(c); prc(' ');

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-302       i++;

 inc  word [bp-2]

;-303     } while(i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge @@printLine170
 jmp @@printLine169
@@printLine170:

;-304     do {// fill rest with blank

@@printLine171:

;-305       prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-306       i++;

 inc  word [bp-2]

;-307     } while(i < OPMAXLEN);

 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine172
 jmp @@printLine171
@@printLine172:

;-308   }


;-309   prscomment(InputBuf);

@@printLine168:
 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-310 }


;-311 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
 LEAVE
 ret
; ENDP
printLine_0 db "\n",0
printLine_1 db "                ",0
printLine_2 db "   ",0

prc:  ; *** PROC ***
;Function : prc, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg byte   311 NULL bp+4    c;
 ENTER  0,0
 mov al, [LIST]
 or  al, al
 je @@prc173
cmp byte [bp+4], 10
 jne @@prc174
 mov  ax, 13
 call writetty

;-312      al=c; writetty(); }

@@prc174:
 mov  al, [bp+4]
 call writetty

;-313    fputcR(c,lst_fd); }

@@prc173:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-314 


;-315 int prscomment(unsigned char *s) {unsigned char c;
 LEAVE
 ret
; ENDP

prscomment:  ; *** PROC ***

;-316   while(*s){c=*s;prc(c);s++;}

;Function : prscomment, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte   315 NULL bp+4    s
;  201 var unsg byte   315 NULL bp-2    c;
 ENTER  2,0
@@prscomment175:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment176
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

;-317 }

 jmp @@prscomment175
@@prscomment176:

;-318 int prs(unsigned char *s) {unsigned char c; int com; com=0;
 LEAVE
 ret
; ENDP

prs:  ; *** PROC ***
;Function : prs, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte   318 NULL bp+4    s
;  201 var unsg byte   318 NULL bp-2    c
;  202 var sign word   318 NULL bp-4    com;
 ENTER  4,0
 mov eax, 0
 mov word [bp-4], ax

;-319   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;

@@prs177:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs178
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, [bp-2]
 cmp al, 34
 jne @@prs179
 mov ax, [bp-4]
 or  al, al
 je @@prs180
 mov eax, 0
 mov word [bp-4], ax
 jmp @@prs181
@@prs180:
 mov eax, 1
 mov word [bp-4], ax

;-320     if (c==92) { if (com==0) { s++; c=*s;

@@prs181:
@@prs179:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs182
 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs183
 inc  word [bp+4]
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-321           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }

 mov al, [bp-2]
 cmp al, 110
 jne @@prs184
 mov eax, 10
 mov byte [bp-2], al
@@prs184:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs185
 mov eax, 9
 mov byte [bp-2], al
@@prs185:
@@prs183:
@@prs182:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
 inc  word [bp+4]

;-322 }

 jmp @@prs177
@@prs178:

;-323 int printhex8a(unsigned int c) { unsigned int nib;
 LEAVE
 ret
; ENDP

printhex8a:  ; *** PROC ***

;-324   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word   323 NULL bp+4    c
;  201 var unsg word   323 NULL bp-2    nib;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 4
 mov word [bp-2], ax
 add  word [bp-2], 48
 mov ax, [bp-2]
 cmp ax, 57
 jle @@printhex8a186
 add  word [bp-2], 7
@@printhex8a186:
 push word [bp-2]
 call prc
 add  sp, 2

;-325   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);

 mov ax, [bp+4]
 and ax, 15
 mov word [bp-2], ax
 add  word [bp-2], 48
 mov ax, [bp-2]
 cmp ax, 57
 jle @@printhex8a187
 add  word [bp-2], 7
@@printhex8a187:
 push word [bp-2]
 call prc
 add  sp, 2

;-326 }


;-327 int printhex16(unsigned int i) {unsigned int half;
 LEAVE
 ret
; ENDP

printhex16:  ; *** PROC ***

;-328   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word   327 NULL bp+4    i
;  201 var unsg word   327 NULL bp-2    half;
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

;-329 }


;-330 int printIntU(unsigned int n) { unsigned int e;
 LEAVE
 ret
; ENDP

printIntU:  ; *** PROC ***

;-331   if ( _ n >= 10) {  e=n/10; //DIV

;Function : printIntU, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word   330 NULL bp+4    n
;  201 var unsg word   330 NULL bp-2    e;
 ENTER  2,0
cmp word [bp+4], 10 ;unsigned : 0
 jb  @@printIntU188
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov word [bp-2], ax

;-332     printIntU(e); }

 push word [bp-2]
 call printIntU
 add  sp, 2

;-333     n = n % 10; //unsigned mod

@@printIntU188:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov word [bp+4], ax

;-334     n += '0'; prc(n);

 add  word [bp+4], 48
 push word [bp+4]
 call prc
 add  sp, 2

;-335 }


;-336 /*int printLineHex(unsigned char *s) { int L; char c;


;-337   L = strlen(s);


;-338   prs(" L:");


;-339   printIntU(L);  


;-340   if (L <= 0) return;


;-341   if (L > 80) errorexit("Line > 80 char");


;-342   while ( *s ) {


;-343     c = *s;


;-344     prc(' ');


;-345     printhex8a(c);


;-346     s++;


;-347   }


;-348 } */


;-349 int error1(char *s) { LIST=1; ErrorCount++;
 LEAVE
 ret
; ENDP

error1:  ; *** PROC ***
;Function : error1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   349 NULL bp+4    s;
 ENTER  0,0
 mov eax, 1
 mov byte [LIST], al
 inc  word [ErrorCount]

;-350   prs("\n;***** next line ERROR: "); prs(s);

 push error1_0
 call prs
 add  sp, 2
 push word [bp+4]
 call prs
 add  sp, 2

;-351   prs(", Symbol: "); prs(Symbol);}

 push error1_1
 call prs
 add  sp, 2
 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-352 int allowederror(){error1("not allowed here"); }
 LEAVE
 ret
; ENDP
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0

allowederror:  ; *** PROC ***
 push allowederror_0
 call error1
 add  sp, 2

;-353 int implmerror(){error1("not implemented");}

 ret
; ENDP
allowederror_0 db "not allowed here",0

implmerror:  ; *** PROC ***
 push implmerror_0
 call error1
 add  sp, 2

;-354 int indexerror (){error1("invalid index register");}

 ret
; ENDP
implmerror_0 db "not implemented",0

indexerror:  ; *** PROC ***
 push indexerror_0
 call error1
 add  sp, 2

;-355 int numbererror(){error1("number expected");}  

 ret
; ENDP
indexerror_0 db "invalid index register",0

numbererror:  ; *** PROC ***
 push numbererror_0
 call error1
 add  sp, 2

;-356 int regmemerror(){error1("only register or memory allowed");}

 ret
; ENDP
numbererror_0 db "number expected",0

regmemerror:  ; *** PROC ***
 push regmemerror_0
 call error1
 add  sp, 2

;-357 int segregerror(){error1("segment register not allowed");}

 ret
; ENDP
regmemerror_0 db "only register or memory allowed",0

segregerror:  ; *** PROC ***
 push segregerror_0
 call error1
 add  sp, 2

;-358 int syntaxerror(){error1("syntax");}

 ret
; ENDP
segregerror_0 db "segment register not allowed",0

syntaxerror:  ; *** PROC ***
 push syntaxerror_0
 call error1
 add  sp, 2

;-359 


;-360 int errorexit(char *s) { error1(s); end1(1);}

 ret
; ENDP
syntaxerror_0 db "syntax",0

errorexit:  ; *** PROC ***
;Function : errorexit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   360 NULL bp+4    s;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2
 push 1
 call end1
 add  sp, 2

;-361 int addrexit(){errorexit("illegal addres");}
 LEAVE
 ret
; ENDP

addrexit:  ; *** PROC ***
 push addrexit_0
 call errorexit
 add  sp, 2

;-362 int internexit(){errorexit("intern compiler error");}

 ret
; ENDP
addrexit_0 db "illegal addres",0

internexit:  ; *** PROC ***
 push internexit_0
 call errorexit
 add  sp, 2

;-363 


;-364 //int main() {getarg(); parse(); epilog(); end1();}//NB AS, AS TE


;-365 char *arglen=0x80; char *argv=0x82;

 ret
; ENDP
internexit_0 db "intern compiler error",0
arglen dw 128
argv dw 130

;-366 int getarg() { int arglen1; int i; char *c;


getarg:  ; *** PROC ***

;-367   arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word   366 NULL bp-2    arglen1
;  201 var sign word   366 NULL bp-4    i
;  202 ptr sign byte   366 NULL bp-6    c;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov word [bp-2], ax

;-368   if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne @@getarg189

;-369     cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-370     cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-371     exitR(3);

 push 3
 call exitR
 add  sp, 2

;-372   }


;-373   i=arglen1+129; *i=0;  arglen1--;

@@getarg189:
 mov ax, [bp-2]
 add ax, 129
 mov word [bp-4], ax
 mov eax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
 dec  word [bp-2]

;-374   toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-375   strcpy(namein, argv); strcat1(namein, ".S");

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

;-376   strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-377   strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-378 


;-379   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;

 mov eax, 1
 mov byte [LIST], al
 mov eax, 0
 mov word [DOS_ERR], ax
 mov eax, 0
 mov word [PC], ax
 mov eax, 0
 mov word [ErrorCount], ax

;-380   asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-381   if(DOS_ERR){cputs("Source file missing: "); cputs(namein); exitR(1); }

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg190
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

;-382   lst_fd=creatR(namelst);

@@getarg190:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-383   if(DOS_ERR){cputs("List file not creatable: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg191
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

;-384   bin_fd=creatR(namebin);

@@getarg191:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-385   if(DOS_ERR){cputs("COM file not creatable: ");cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg192
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

;-386   prs(";");prs(Version1);

@@getarg192:
 push getarg_7
 call prs
 add  sp, 2
 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-387   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);

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

;-388   prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-389   prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-390 }


;-391 int epilog() { int i; int j; char c;
 LEAVE
 ret
; ENDP
getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
getarg_1 db ".S",0
getarg_2 db ".LST",0
getarg_3 db ".COM",0
getarg_4 db "Source file missing: ",0
getarg_5 db "List file not creatable: ",0
getarg_6 db "COM file not creatable: ",0
getarg_7 db ";",0
getarg_8 db ", Source: ",0
getarg_9 db ", Output: ",0
getarg_10 db ", ",0
getarg_11 db "\n",0

epilog:  ; *** PROC ***

;-392   prs("\n;END Errors: "); printIntU(ErrorCount);

;Function : epilog, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word   391 NULL bp-2    i
;  201 var sign word   391 NULL bp-4    j
;  202 var sign byte   391 NULL bp-6    c;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2
 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-393   if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je @@epilog193
 push epilog_1
 call prs
 add  sp, 2

;-394   prs(", Label & Var: ");

@@epilog193:
 push epilog_2
 call prs
 add  sp, 2

;-395 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");


;-396   i= &LabelNames;


;-397   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-398   } while (i < LabelNamePtr); prs("<< \n"); */


;-399   if (LabelMaxIx) {

 mov ax, [LabelMaxIx]
 or  al, al
 je @@epilog194

;-400     i = 1;

 mov eax, 1
 mov word [bp-2], ax

;-401     LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-402     do {

@@epilog195:

;-403       prs(LabelNamePtr); prc(' ');

 push word [LabelNamePtr]
 call prs
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-404  /*     j=LabelType[i]; //printIntU(j);


;-405       if (j == 1) prc('L');


;-406       if (j == 2) prc('V');


;-407       prc('.'); */


;-408       j=LabelAddr[i]; printhex16(j); prs(",  ");

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

;-409       j=strlen(LabelNamePtr);//get end of act. name

 push word [LabelNamePtr]
 call strlen
 add  sp, 2
 mov word [bp-4], ax

;-410       LabelNamePtr=LabelNamePtr+j;

 mov ax, [LabelNamePtr]
 add ax, [bp-4]
 mov word [LabelNamePtr], ax

;-411       LabelNamePtr++;

 inc  word [LabelNamePtr]

;-412       i++;

 inc  word [bp-2]

;-413     } while (i <= LabelMaxIx);

 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@epilog196
 jmp @@epilog195
@@epilog196:

;-414   }


;-415   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");

@@epilog194:
 push epilog_4
 call prs
 add  sp, 2
 push word [BinLen]
 call printIntU
 add  sp, 2
 push epilog_5
 call prs
 add  sp, 2

;-416   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-417   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;

@@epilog197:
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

;-418   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog198
 jmp @@epilog197
@@epilog198:

;-419   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-420   do {

@@epilog199:

;-421     c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov byte [bp-6], al

;-422     fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-423     i++;

 inc  word [bp-2]

;-424   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog200
 jmp @@epilog199
@@epilog200:

;-425 }


;-426 int end1(int n) {fcloseR(asm_fd); fcloseR(lst_fd); fcloseR(bin_fd);exitR(n);
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
;Function : end1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   426 NULL bp+4    n;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2
 push word [lst_fd]
 call fcloseR
 add  sp, 2
 push word [bin_fd]
 call fcloseR
 add  sp, 2
 push word [bp+4]
 call exitR
 add  sp, 2

;-427 }


;-428 /*


;-429 Hierarchical software diagram, except string & DOS functions,  .=end


;-430 main:  getarg. parse epilog. end1.


;-431 parse: getLine. getToken storeLabel. searchLabel. lookCode. process


;-432        getVariable printLine.


;-433 getToken: skipBlank. getDigit. getName.


;-434 process: genInstruction getToken testReg. genAddr16.


;-435 genInstruction: genCode8.


;-436 getVariable: storeLabel. getToken lookCode. skipBlank. isToken. genAddr16.


;-437 */
 LEAVE
 ret
; ENDP
;Back to main program: AS.C
 
; missing functions: 
; digit
; alnum
; eqstr
; eqstr
; eqstr
; strcpy
; eqstr
; strlen
; readRL
; readRL
; digit
; alnum
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

;-243 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-244 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   244 NULL bp+4    s
;  201 var sign byte   244 NULL bp-2    c;
 ENTER  2,0
@@cputs201:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs202
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
 jmp @@cputs201
@@cputs202:

;-245 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   245 NULL bp+4    s;
 ENTER  0,0
@@toupper203:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper204
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper205
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper206
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper206:
@@toupper205:
 inc  word [bp+4]
 jmp @@toupper203
@@toupper204:

;-246 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-247 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   247 NULL bp+4    s
;  201 var sign word   247 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen207:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen208
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen207
@@strlen208:
 mov ax, [bp-2]
 jmp @@retn

;-248 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    5 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   248 NULL bp+4    s
;  201 ptr sign byte   248 NULL bp+6    t;
 ENTER  0,0
@@strcpy209:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-249   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy210
 jmp @@strcpy209
@@strcpy210:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-250 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    2 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   250 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit211
 mov eax, 0
 jmp @@retn
@@digit211:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit212
 mov eax, 0
 jmp @@retn
@@digit212:
 mov eax, 1
 jmp @@retn

;-251 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    2 : alnum

alnum:  ; *** PROC ***
;Function : alnum, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   251 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@alnum213
 mov eax, 1
 jmp @@retn
@@alnum213:
 mov al, [bp+4]
 cmp al, 95
 jne @@alnum214
 mov eax, 1
 jmp @@retn

;-252   if (c> 'z') return 0; if (c< '@') return 0;

@@alnum214:
 mov al, [bp+4]
 cmp al, 122
 jle @@alnum215
 mov eax, 0
 jmp @@retn
@@alnum215:
 mov al, [bp+4]
 cmp al, 64
 jge @@alnum216
 mov eax, 0
 jmp @@retn

;-253   if (c> 'Z') { if (c< 'a') return 0; }  return 1; }//same as letter

@@alnum216:
 mov al, [bp+4]
 cmp al, 90
 jle @@alnum217
 mov al, [bp+4]
 cmp al, 97
 jge @@alnum218
 mov eax, 0
 jmp @@retn
@@alnum218:
@@alnum217:
 mov eax, 1
 jmp @@retn

;-254 int eqstr(char *p, char *q) { while(*p) {

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   254 NULL bp+4    p
;  201 ptr sign byte   254 NULL bp+6    q;
 ENTER  0,0
@@eqstr219:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr220

;-255     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr221
 mov eax, 0
 jmp @@retn
@@eqstr221:
 inc  word [bp+4]
 inc  word [bp+6]

;-256     if(*q) return 0; return 1; }

 jmp @@eqstr219
@@eqstr220:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr222
 mov eax, 0
 jmp @@retn
@@eqstr222:
 mov eax, 1
 jmp @@retn

;-257 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   257 NULL bp+4    s
;  201 ptr sign byte   257 NULL bp+6    t;
 ENTER  0,0
@@strcat1223:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1224
 inc  word [bp+4]
 jmp @@strcat1223
@@strcat1224:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-258 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   258 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-259 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   259 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-260 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   260 NULL bp+4    s
;  201 var sign word   260 NULL bp+6    fd
;  202 var sign word   260 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-261 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   261 NULL bp+4    n
;  201 var sign word   261 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-262   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-263 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   263 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-264 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   264 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-265 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
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

;-266 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   266 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch225
 mov  al, 13
 call writetty
@@putch225:
 mov  al, [bp+4]
 call writetty

;-267 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt226
 inc  word [DOS_ERR]
@@DosInt226:

;-268 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

 ret
; ENDP
;End of archive file. 
 
; missing functions:  All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width line used  address name   list of global variables

;    1 arr sign byte     2    2        0 Version1[19]
;    2 var sign byte     3    3        0 LIST
;    3 arr sign byte     4    7    30000 Symbol[80]
;    4 arr sign byte     4   36    30080 SymbolUpper[80]
;    5 var unsg word     4   12        0 SymbolInt
;    6 arr sign byte     5    3    30160 InputBuf[128]
;    7 ptr unsg byte     5   23        0 InputPtr
;    8 arr sign byte     6    5    30288 namein[67]
;    9 arr sign byte     6    5    30355 namelst[67]
;   10 arr sign byte     6    5    30422 namebin[67]
;   11 var sign word     7    4        0 asm_fd
;   12 var sign word     7    3        0 lst_fd
;   13 var sign word     7    3        0 bin_fd
;   14 var sign word     8    6        0 DOS_ERR
;   15 var sign word     8    4        0 ErrorCount
;   16 var sign word     9    4        0 DOS_NoBytes
;   17 var sign byte     9    4        0 DOS_ByteRead
;   18 var unsg word    11    5        0 PC
;   19 var unsg word    12    2        0 PCStart
;   20 var sign byte    13    3        0 isLabel
;   21 def unsg byte    14    -        0 LABEL=1
;   22 def unsg byte    15    -        0 VARIABLE=2
;   23 def unsg byte    16    -        0 DIGIT=1
;   24 def unsg byte    17    -        0 ALNUM=2
;   25 var sign byte    18   20        0 TokeType
;   26 def unsg byte    19    -        0 BYTE=1
;   27 def unsg byte    20    -        0 WORD=2
;   28 def unsg byte    21    -        0 DWORD=3
;   29 def unsg byte    22    -        0 SEGREG=4
;   30 def unsg byte    24    -        0 IMM=1
;   31 def unsg byte    25    -        0 REG=2
;   32 def unsg byte    26    -        0 DIR=3
;   33 def unsg byte    27    -        0 IND=4
;   34 var sign byte    28   13        0 Op1
;   35 var sign word    29   12        0 CodeType
;   36 var sign byte    31   17        0 RegType
;   37 var sign byte    32   10        0 RegNo
;   38 var sign byte    33   10        0 OpSize
;   39 var sign byte    35 NULL        0 NumOprns
;   40 var sign byte    36    5        0 wflag
;   41 var sign byte    37 NULL        0 dflag
;   42 var sign byte    39    4        0 reg
;   43 var sign word    40   13        0 disp
;   44 var sign word    41    2        0 imme
;   45 def unsg byte    43    -        0 OPMAXLEN=5
;   46 arr sign byte    44    2    30489 OpPos[5]
;   47 var sign word    45    6        0 OpPrintIndex
;   48 ptr sign byte    46   16        0 OpCodePtr
;   49 var sign byte    47    2        0 PrReloc
;   50 arr sign byte    48    3    30494 LabelNames[1000]
;   51 ptr sign byte    48   10        0 LabelNamePtr
;   52 arr sign byte    49    1    31494 LabelType[100]
;   53 arr unsg word    49    4    31594 LabelAddr[100]
;   54 var sign word    50    6        0 LabelMaxIx
;   55 var sign word    50    4        0 LabelIx
;   56 arr sign byte    51    3    31794 FileBin[2000]
;   57 var unsg word    51    5        0 BinLen
;   58 var sign byte   172    1        0 I_START
;   59 arr sign byte   174 NULL        0 I_PUSHA[9]
;   60 arr sign byte   175 NULL        0 I_POPA[8]
;   61 arr sign byte   176 NULL        0 I_NOP[7]
;   62 arr sign byte   177 NULL        0 I_CBW[7]
;   63 arr sign byte   178 NULL        0 I_CWDE[8]
;   64 arr sign byte   179 NULL        0 I_CWD[7]
;   65 arr sign byte   180 NULL        0 I_CDQ[7]
;   66 arr sign byte   181 NULL        0 I_WAIT[8]
;   67 arr sign byte   182 NULL        0 I_PUSHF[9]
;   68 arr sign byte   183 NULL        0 I_POPF[8]
;   69 arr sign byte   184 NULL        0 I_SAHF[8]
;   70 arr sign byte   185 NULL        0 I_LAHF[8]
;   71 arr sign byte   186 NULL        0 I_MOVSB[9]
;   72 arr sign byte   187 NULL        0 I_MOVSW[9]
;   73 arr sign byte   188 NULL        0 I_CMPSB[9]
;   74 arr sign byte   189 NULL        0 I_CMPSW[9]
;   75 arr sign byte   190 NULL        0 I_STOSB[9]
;   76 arr sign byte   191 NULL        0 I_STOSW[9]
;   77 arr sign byte   192 NULL        0 I_LODSB[9]
;   78 arr sign byte   193 NULL        0 I_LODSW[9]
;   79 arr sign byte   194 NULL        0 I_SCASB[9]
;   80 arr sign byte   195 NULL        0 I_SCASW[9]
;   81 arr sign byte   196 NULL        0 I_LEAVE[9]
;   82 arr sign byte   197 NULL        0 I_IRET[8]
;   83 arr sign byte   198 NULL        0 I_XLAT[8]
;   84 arr sign byte   199 NULL        0 I_LOCK[8]
;   85 arr sign byte   200 NULL        0 I_REPNE[9]
;   86 arr sign byte   201 NULL        0 I_REPNZ[9]
;   87 arr sign byte   202 NULL        0 I_REPE[8]
;   88 arr sign byte   203 NULL        0 I_REPZ[8]
;   89 arr sign byte   204 NULL        0 I_HLT[7]
;   90 arr sign byte   205 NULL        0 I_CLC[7]
;   91 arr sign byte   206 NULL        0 I_STC[7]
;   92 arr sign byte   207 NULL        0 I_CLI[7]
;   93 arr sign byte   208 NULL        0 I_STI[7]
;   94 arr sign byte   209 NULL        0 I_CLD[7]
;   95 arr sign byte   210 NULL        0 I_STD[7]
;   96 arr sign byte   212 NULL        0 I_INC[9]
;   97 arr sign byte   213 NULL        0 I_DEC[9]
;   98 arr sign byte   215 NULL        0 I_NOT[8]
;   99 arr sign byte   216 NULL        0 I_NEG[8]
;  100 arr sign byte   217 NULL        0 I_MUL[8]
;  101 arr sign byte   218 NULL        0 I_IMUL[9]
;  102 arr sign byte   219 NULL        0 I_DIV[8]
;  103 arr sign byte   220 NULL        0 I_IDIV[9]
;  104 arr sign byte   222 NULL        0 I_LES[7]
;  105 arr sign byte   223 NULL        0 I_LDS[7]
;  106 arr sign byte   224 NULL        0 I_LEA[7]
;  107 arr sign byte   226 NULL        0 I_ADD[7]
;  108 arr sign byte   227 NULL        0 I_OR[6]
;  109 arr sign byte   228 NULL        0 I_ADC[7]
;  110 arr sign byte   229 NULL        0 I_SBB[7]
;  111 arr sign byte   230 NULL        0 I_AND[7]
;  112 arr sign byte   231 NULL        0 I_SUB[7]
;  113 arr sign byte   232 NULL        0 I_XOR[7]
;  114 arr sign byte   233 NULL        0 I_CMP[7]
;  115 arr sign byte   235 NULL        0 I_MOV[6]
;  116 arr sign byte   237 NULL        0 I_JO[6]
;  117 arr sign byte   238 NULL        0 I_JNO[7]
;  118 arr sign byte   239 NULL        0 I_JB[6]
;  119 arr sign byte   240 NULL        0 I_JC[6]
;  120 arr sign byte   241 NULL        0 I_JNB[7]
;  121 arr sign byte   242 NULL        0 I_JAE[7]
;  122 arr sign byte   243 NULL        0 I_JNC[7]
;  123 arr sign byte   244 NULL        0 I_JE[6]
;  124 arr sign byte   245 NULL        0 I_JZ[6]
;  125 arr sign byte   246 NULL        0 I_JNE[7]
;  126 arr sign byte   247 NULL        0 I_JNZ[7]
;  127 arr sign byte   248 NULL        0 I_JBE[7]
;  128 arr sign byte   249 NULL        0 I_JNA[7]
;  129 arr sign byte   250 NULL        0 I_JA[6]
;  130 arr sign byte   251 NULL        0 I_JS[6]
;  131 arr sign byte   252 NULL        0 I_JNS[7]
;  132 arr sign byte   253 NULL        0 I_JP[6]
;  133 arr sign byte   254 NULL        0 I_JPE[7]
;  134 arr sign byte   255 NULL        0 I_JNP[7]
;  135 arr sign byte   256 NULL        0 I_JPO[7]
;  136 arr sign byte   257 NULL        0 I_JL[6]
;  137 arr sign byte   258 NULL        0 I_JNL[7]
;  138 arr sign byte   259 NULL        0 I_JGE[7]
;  139 arr sign byte   260 NULL        0 I_JLE[7]
;  140 arr sign byte   261 NULL        0 I_JNG[7]
;  141 arr sign byte   262 NULL        0 I_JG[6]
;  142 arr sign byte   264 NULL        0 I_RET[8]
;  143 arr sign byte   266 NULL        0 I_PUSH[8]
;  144 arr sign byte   267 NULL        0 I_POP[7]
;  145 arr sign byte   269 NULL        0 I_ORG[6]
;  146 arr sign byte   270 NULL        0 I_DB[5]
;  147 arr sign byte   271 NULL        0 I_DW[5]
;  148 arr sign byte   272 NULL        0 I_DD[5]
;  149 arr sign byte   273 NULL        0 I_RESB[7]
;  150 arr sign byte   274 NULL        0 I_RESW[7]
;  151 arr sign byte   275 NULL        0 I_RESD[7]
;  152 var sign byte   276 NULL        0 I_END
;  153 ptr sign byte   365    1        0 arglen
;  154 ptr sign byte   365    4        0 argv


;   # Calls Line Width  Name   list of functions

;    0 NULL    1 word   main
;    1    1   53 word   process
;    2   12   86 word   setTokeType
;    3 NULL   95 word   Ops
;    4    2  106 word   LeftOpwCheck
;    5    1  116 word   getLeftOp
;    6    1  128 word   setwflag
;    7    2  136 word   getOp1
;    8    1  148 word   getIND
;    9    1  163 word   getIndReg1
;   10    1  172 word   getIndReg2
;   11    1  182 word   getCodeSize
;   12    7  189 word   isToken
;   13    1  198 word   skipRest
;   14    1  202 word   gen66h
;   15    8  203 word   genCode8
;   16    3  207 word   genCode16
;   17    7  210 word   genInstruction
;   18    2  214 word   genCodeInREG
;   19 NULL  217 word   genModRegRM
;   20    2  219 word   writeEA
;   21 NULL  233 word   test1
;   22    1    2 word   parse
;   23    2   27 word   storeLabel
;   24    2   35 word   searchLabel
;   25    1   46 word   getVariable
;   26    1   76 word   getLine
;   27    1   89 word   ifEOL
;   28    3   96 word   skipBlank
;   29    1  101 word   getDigit
;   30    1  113 word   getName
;   31    1  130 word   testReg
;   32    2  278 word   lookCode
;   33    1  293 word   printLine
;   34    9  311 word   prc
;   35    1  315 word   prscomment
;   36   24  318 word   prs
;   37    4  323 word   printhex8a
;   38    2  327 word   printhex16
;   39    3  330 word   printIntU
;   40   19  349 word   error1
;   41 NULL  352 word   allowederror
;   42 NULL  353 word   implmerror
;   43    4  354 word   indexerror
;   44    1  355 word   numbererror
;   45 NULL  356 word   regmemerror
;   46    1  357 word   segregerror
;   47    1  358 word   syntaxerror
;   48    7  360 word   errorexit
;   49    1  361 word   addrexit
;   50 NULL  362 word   internexit
;   51    1  366 word   getarg
;   52    1  391 word   epilog
;   53    2  426 word   end1
;   54    4  243 word   writetty
;   55    8  244 word   cputs
;   56    2  245 word   toupper
;   57    4  247 word   strlen
;   58    6  248 word   strcpy
;   59    3  250 word   digit
;   60    2  251 word   alnum
;   61   35  254 word   eqstr
;   62    3  257 word   strcat1
;   63    1  258 word   openR
;   64    2  259 word   creatR
;   65    2  260 word   readRL
;   66    2  261 word   fputcR
;   67    3  263 word   fcloseR
;   68    5  264 word   exitR
;   69    1  266 word   putch
;   70    4  267 word   DosInt
;   71 NULL  268 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0     5 getarg
;    1    12 parse
;    2    18 epilog
;    3    25 end1
;    4   478 setTokeType
;    5   490 getCodeSize
;    6   502 genInstruction
;    7   517 LeftOpwCheck
;    8   530 genInstruction
;    9   545 genInstruction
;   10   560 genInstruction
;   11   575 genCodeInREG
;   12   588 LeftOpwCheck
;   13   601 genInstruction
;   14   616 genCodeInREG
;   15   629 genInstruction
;   16   644 genCode16
;   17   654 genInstruction
;   18   669 error1
;   19   676 error1
;   20   697 skipBlank
;   21   707 digit
;   22   713 getDigit
;   23   722 alnum
;   24   728 getName
;   25   753 getLeftOp
;   26   763 segregerror
;   27   775 setwflag
;   28   784 error1
;   29   791 error1
;   30   798 error1
;   31   815 getOp1
;   32   822 isToken
;   33   830 getIND
;   34   837 error1
;   35   844 error1
;   36   860 gen66h
;   37   874 testReg
;   38   882 searchLabel
;   39   894 error1
;   40   915 setTokeType
;   41   927 getOp1
;   42   934 syntaxerror
;   43   946 getIndReg2
;   44   957 getIndReg1
;   45   968 isToken
;   46   976 setTokeType
;   47   988 numbererror
;   48  1000 isToken
;   49  1008 isToken
;   50  1016 errorexit
;   51  1039 indexerror
;   52  1050 indexerror
;   53  1077 indexerror
;   54  1088 indexerror
;   55  1111 eqstr
;   56  1117 setTokeType
;   57  1129 eqstr
;   58  1135 setTokeType
;   59  1147 eqstr
;   60  1153 setTokeType
;   61  1175 skipBlank
;   62  1194 setTokeType
;   63  1206 prs
;   64  1217 genCode8
;   65  1249 genCode8
;   66  1258 genCode8
;   67  1291 genCode8
;   68  1315 writeEA
;   69  1335 writeEA
;   70  1359 addrexit
;   71  1368 genCode8
;   72  1377 genCode8
;   73  1386 genCode16
;   74  1408 getLine
;   75  1416 setTokeType
;   76  1428 storeLabel
;   77  1439 setTokeType
;   78  1451 lookCode
;   79  1460 process
;   80  1468 getVariable
;   81  1480 skipRest
;   82  1489 error1
;   83  1496 error1
;   84  1503 printLine
;   85  1532 searchLabel
;   86  1544 error1
;   87  1551 strcpy
;   88  1589 eqstr
;   89  1595 strlen
;   90  1616 storeLabel
;   91  1627 setTokeType
;   92  1639 lookCode
;   93  1648 errorexit
;   94  1658 errorexit
;   95  1668 setTokeType
;   96  1680 genCode8
;   97  1689 skipBlank
;   98  1699 isToken
;   99  1707 genCode8
;  100  1716 isToken
;  101  1724 setTokeType
;  102  1736 genCode16
;  103  1746 isToken
;  104  1754 errorexit
;  105  1772 readRL
;  106  1779 errorexit
;  107  1789 ifEOL
;  108  1803 readRL
;  109  1839 digit
;  110  1857 alnum
;  111  1863 strcpy
;  112  1870 toupper
;  113  1886 strlen
;  114  1893 strlen
;  115  1900 eqstr
;  116  1906 eqstr
;  117  1912 eqstr
;  118  1918 eqstr
;  119  1924 eqstr
;  120  1930 eqstr
;  121  1936 eqstr
;  122  1942 eqstr
;  123  1948 eqstr
;  124  1954 eqstr
;  125  1960 eqstr
;  126  1966 eqstr
;  127  1972 eqstr
;  128  1978 eqstr
;  129  1984 eqstr
;  130  1990 eqstr
;  131  1996 eqstr
;  132  2002 eqstr
;  133  2008 eqstr
;  134  2014 eqstr
;  135  2020 eqstr
;  136  2026 eqstr
;  137  2032 eqstr
;  138  2038 eqstr
;  139  2044 eqstr
;  140  2050 eqstr
;  141  2056 eqstr
;  142  2062 eqstr
;  143  2068 eqstr
;  144  2074 eqstr
;  145  2694 eqstr
;  146  2714 prs
;  147  2718 printhex16
;  148  2729 prs
;  149  2733 prc
;  150  2737 printhex8a
;  151  2748 prc
;  152  2752 prs
;  153  2756 prscomment
;  154  2773 writetty
;  155  2782 writetty
;  156  2791 fputcR
;  157  2813 prc
;  158  2829 prc
;  159  2850 prc
;  160  2854 prc
;  161  2876 printhex8a
;  162  2887 printhex8a
;  163  2912 printIntU
;  164  2922 prc
;  165  2935 prs
;  166  2939 prs
;  167  2943 prs
;  168  2947 prs
;  169  2964 error1
;  170  2982 error1
;  171  3000 error1
;  172  3019 error1
;  173  3038 error1
;  174  3057 error1
;  175  3076 error1
;  176  3095 error1
;  177  3102 end1
;  178  3116 errorexit
;  179  3137 errorexit
;  180  3178 cputs
;  181  3184 cputs
;  182  3190 exitR
;  183  3196 toupper
;  184  3204 strcpy
;  185  3211 strcat1
;  186  3219 strcpy
;  187  3226 strcat1
;  188  3234 strcpy
;  189  3241 strcat1
;  190  3249 openR
;  191  3255 cputs
;  192  3261 cputs
;  193  3267 exitR
;  194  3273 creatR
;  195  3280 cputs
;  196  3286 cputs
;  197  3292 exitR
;  198  3298 creatR
;  199  3305 cputs
;  200  3311 cputs
;  201  3317 exitR
;  202  3323 prs
;  203  3327 prs
;  204  3331 prs
;  205  3335 prs
;  206  3339 prs
;  207  3343 prs
;  208  3347 prs
;  209  3351 prs
;  210  3355 prs
;  211  3372 prs
;  212  3376 printIntU
;  213  3386 prs
;  214  3390 prs
;  215  3394 prs
;  216  3398 prc
;  217  3402 printhex16
;  218  3413 prs
;  219  3417 strlen
;  220  3424 prs
;  221  3428 printIntU
;  222  3438 prs
;  223  3442 prc
;  224  3446 printhex8a
;  225  3457 fputcR
;  226  3471 fcloseR
;  227  3479 fcloseR
;  228  3487 fcloseR
;  229  3495 exitR
;  230  3520 putch
;  231  3574 digit
;  232  3602 strcpy
;  233  3617 DosInt
;  234  3633 DosInt
;  235  3656 DosInt
;  236  3675 DosInt
;  237  3709 writetty
;  238  3718 writetty
;Input: AS.C, List: AS.S,  Lines:  269
;Glob. variables:  154 max.:  200
;Local variables:    4 max.:  100, in 'searchLabel'
;Functions      :   72 max.:  300
;Calls          :  239 max.: 2000, NameField: 3750 max.:    65535
;Code until     :26009 max.: 30000, free: 3991
;Data (HeapEnd) :33794, resting stacksize: 31741
;Max. Const in 'testReg' :  658 max. 3000, free: 2342