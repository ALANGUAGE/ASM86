
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

;-4 #include "OPTABL.C"

;Use include file: OPTABL.C

;-1 char I_START=0xF1;

I_START db 241

;-2 //todo change CodeType and Opcode (2 bytes only)


;-3 //OpName,0,CodeType,OpCode1,OpCodeN,F1h


;-4 //  1:   1 byte opcode


;-5 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241

;-6 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};

I_POPA db 80,79,80,65,0,1,97,241

;-7 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};

I_NOP db 78,79,80,0,1,144,241

;-8 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};

I_CBW db 67,66,87,0,1,152,241

;-9 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};

I_CWDE db 67,87,68,69,0,1,152,241

;-10 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};

I_CWD db 67,87,68,0,1,153,241

;-11 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};

I_CDQ db 67,68,81,0,1,153,241

;-12 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};

I_WAIT db 87,65,73,84,0,1,155,241

;-13 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241

;-14 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};

I_POPF db 80,79,80,70,0,1,157,241

;-15 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};

I_SAHF db 83,65,72,70,0,1,158,241

;-16 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};

I_LAHF db 76,65,72,70,0,1,159,241

;-17 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241

;-18 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};

I_MOVSW db 77,79,86,83,87,0,1,165,241

;-19 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241

;-20 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};

I_CMPSW db 67,77,80,83,87,0,1,167,241

;-21 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241

;-22 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};

I_STOSW db 83,84,79,83,87,0,1,171,241

;-23 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241

;-24 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};

I_LODSW db 76,79,68,83,87,0,1,173,241

;-25 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241

;-26 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};

I_SCASW db 83,67,65,83,87,0,1,175,241

;-27 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241

;-28 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};

I_IRET db 73,82,69,84,0,1,207,241

;-29 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};

I_XLAT db 88,76,65,84,0,1,215,241

;-30 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};

I_LOCK db 76,79,67,75,0,1,240,241

;-31 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241

;-32 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};

I_REPNZ db 82,69,80,78,90,0,1,242,241

;-33 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};

I_REPE db 82,69,80,69,0,1,243,241

;-34 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};

I_REPZ db 82,69,80,90,0,1,243,241

;-35 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};

I_HLT db 72,76,84,0,1,244,241

;-36 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry

I_CLC db 67,76,67,0,1,248,241

;-37 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry

I_STC db 83,84,67,0,1,249,241

;-38 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt

I_CLI db 67,76,73,0,1,250,241

;-39 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt

I_STI db 83,84,73,0,1,251,241

;-40 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction

I_CLD db 67,76,68,0,1,252,241

;-41 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction

I_STD db 83,84,68,0,1,253,241

;-42 //  2: inc,dec


;-43 char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-44 char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-45 // 52: mem reg 16 bit


;-46 char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};

I_NOT db 78,79,84,0,52,246,2,241

;-47 char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};

I_NEG db 78,69,71,0,52,246,3,241

;-48 char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};

I_MUL db 77,85,76,0,52,246,4,241

;-49 char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc

I_IMUL db 73,77,85,76,0,52,246,5,241

;-50 char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};

I_DIV db 68,73,86,0,52,246,6,241

;-51 char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};

I_IDIV db 73,68,73,86,0,52,246,7,241

;-52 //  3: les, lda, lea


;-53 char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16

I_LES db 76,69,83,0,3,196,241

;-54 char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16

I_LDS db 76,68,83,0,3,197,241

;-55 char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16

I_LEA db 76,69,65,0,3,141,241

;-56 //  4: acc,imm  reg,imm  index,reg


;-57 char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-58 char I_OR []={'O','R',0,                4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-59 char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-60 char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-61 char I_AND[]={'A','N','D',0,            4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-62 char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-63 char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-64 char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-65 //  5: mov


;-66 char I_MOV[]={'M','O','V',0,            5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-67 //  6: single byte relative jump


;-68 char I_JO []={'J','O',0,                6, 0,     0xF1};

I_JO db 74,79,0,6,0,241

;-69 char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};

I_JNO db 74,78,79,0,6,1,241

;-70 char I_JB []={'J','B',0,                6, 2,     0xF1};

I_JB db 74,66,0,6,2,241

;-71 char I_JC []={'J','C',0,                6, 2,     0xF1};

I_JC db 74,67,0,6,2,241

;-72 char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};

I_JNB db 74,78,66,0,6,3,241

;-73 char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};

I_JAE db 74,65,69,0,6,3,241

;-74 char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};

I_JNC db 74,78,67,0,6,3,241

;-75 char I_JE []={'J','E',0,                6, 4,     0xF1};//    74 je i8rel

I_JE db 74,69,0,6,4,241

;-76 char I_JZ []={'J','Z',0,                6, 4,     0xF1};//  0F84 je i16rel

I_JZ db 74,90,0,6,4,241

;-77 char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//660F84 je i32rel

I_JNE db 74,78,69,0,6,5,241

;-78 char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};

I_JNZ db 74,78,90,0,6,5,241

;-79 char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};

I_JBE db 74,66,69,0,6,6,241

;-80 char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};

I_JNA db 74,78,65,0,6,6,241

;-81 char I_JA []={'J','A',0,                6, 7,     0xF1};

I_JA db 74,65,0,6,7,241

;-82 char I_JS []={'J','S',0,                6, 8,     0xF1};

I_JS db 74,83,0,6,8,241

;-83 char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};

I_JNS db 74,78,83,0,6,9,241

;-84 char I_JP[]={'J','P',0,                 6,10,     0xF1};

I_JP db 74,80,0,6,10,241

;-85 char I_JPE[]={'J','P','E',0,            6,10,     0xF1};

I_JPE db 74,80,69,0,6,10,241

;-86 char I_JNP[]={'J','N','P',0,            6,11,     0xF1};

I_JNP db 74,78,80,0,6,11,241

;-87 char I_JPO[]={'J','P','O',0,            6,11,     0xF1};

I_JPO db 74,80,79,0,6,11,241

;-88 char I_JL[]={'J','L',0,                 6,12,     0xF1};

I_JL db 74,76,0,6,12,241

;-89 char I_JNL[]={'J','N','L',0,            6,13,     0xF1};

I_JNL db 74,78,76,0,6,13,241

;-90 char I_JGE[]={'J','G','E',0,            6,13,     0xF1};

I_JGE db 74,71,69,0,6,13,241

;-91 char I_JLE[]={'J','L','E',0,            6,14,     0xF1};

I_JLE db 74,76,69,0,6,14,241

;-92 char I_JNG[]={'J','N','G',0,            6,14,     0xF1};

I_JNG db 74,78,71,0,6,14,241

;-93 char I_JG []={'J','G',0,                6,15,     0xF1};

I_JG db 74,71,0,6,15,241

;-94 //  8: ret


;-95 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-96 //  9: seg, r/m


;-97 char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,241

;-98 char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16

I_POP db 80,79,80,0,9,88,241

;-99 //  100 directives


;-100 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-101 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-102 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-103 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-104 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};

I_RESB db 82,69,83,66,0,205,241

;-105 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};

I_RESW db 82,69,83,87,0,206,241

;-106 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};

I_RESD db 82,69,83,68,0,207,241

;-107 char I_END=0;// end of table char

I_END db 0
;Back to main program: AS.C

;-5 /*


;-6 process:


;-7   getOpcode1


;-8   if (,) getOpcode2


;-9   genInstruction


;-10 */


;-11 int process() { int i; char c;


process:  ; *** PROC ***

;-12   getTokeType();

;Function : process, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word    11 NULL bp-2    i
;  201 var sign byte    11 NULL bp-4    c;
 ENTER  4,0
 call getTokeType

;-13   OpSize=getCodeSize();

 call getCodeSize
 mov byte [OpSize], al

;-14 


;-15   if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne @@process1

;-16     genInstruction(0, 1); return;

 push 1
 push 0
 call genInstruction
 add  sp, 4
 jmp @@retn

;-17   }


;-18   if (CodeType ==  2) {//inc, dec

@@process1:
 mov al, [CodeType]
 cmp al, 2
 jne @@process2

;-19     LeftOpwCheck();

 call LeftOpwCheck

;-20     	if (Op1 == REG) {

 mov al, [Op1]
 cmp al, 2
 jne @@process3

;-21         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form

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

;-22         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }

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

;-23       genInstruction(wflag, 1); genCodeInREG(); return;

@@process3:
 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 call genCodeInREG
 jmp @@retn

;-24   }


;-25 


;-26   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul

@@process2:
 mov al, [CodeType]
 cmp al, 52
 jne @@process6

;-27     LeftOpwCheck();

 call LeftOpwCheck

;-28     genInstruction(wflag, 1); genCodeInREG(); return;

 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4
 call genCodeInREG
 jmp @@retn

;-29   }


;-30 


;-31   if (CodeType==  8) {// ret

@@process6:
 mov al, [CodeType]
 cmp al, 8
 jne @@process7

;-32     if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}

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

;-33     genInstruction(0, 1); return;

@@process8:
 push 1
 push 0
 call genInstruction
 add  sp, 4
 jmp @@retn

;-34   }


;-35 


;-36   if (CodeType==101) {// ORG nn

@@process7:
 mov al, [CodeType]
 cmp al, 101
 jne @@process9

;-37     if (TokeType != DIGIT) error1("only digit allowed");

 mov al, [TokeType]
 cmp al, 1
 je  @@process10
 push process_0
 call error1
 add  sp, 2

;-38     PC=SymbolInt;return;

@@process10:
 mov ax, [SymbolInt]
 mov word [PC], ax
 jmp @@retn

;-39   }


;-40   error1("unknown CodeType");

@@process9:
 push process_1
 call error1
 add  sp, 2

;-41 }


;-42 


;-43 // scan code .....................................


;-44 int getTokeType() { char c;

@@retn: LEAVE
 ret
; ENDP
process_0 db "only digit allowed",0
process_1 db "unknown CodeType",0

getTokeType:  ; *** PROC ***

;-45   skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    44 NULL bp-2    c;
 ENTER  2,0
 call skipBlank

;-46   c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-47   if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne @@getTokeType11
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-48   if (c == ';') {TokeType=0; return; }//comment

@@getTokeType11:
 mov al, [bp-2]
 cmp al, 59
 jne @@getTokeType12
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-49   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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

;-50   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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

;-51   TokeType=NOALNUME; return;

@@getTokeType14:
 mov eax, 4
 mov byte [TokeType], al
 jmp @@retn

;-52 }


;-53 /*


;-54 operand::=


;-55   none


;-56   ac  (al, ax, eax)


;-57   r   (b, w, s, d)


;-58   [m] (b, w, d)


;-59   i   (b, w)


;-60   disp(b, w)


;-61 


;-62 //O2=rr,rm,ri,mr,mi


;-63 //NumOprns==2, seg reg not allowed only mov and push


;-64 //size: 1.declaration CodeSize, 2.reg size, 3.error1


;-65 //1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);


;-66 //2. rm , imm 80


;-67 //2a sign ext 83


;-68 //3. reg, rm  02  if (dest==reg) set direction bit; else default;


;-69 //4. rm , reg 00


;-70 //5. error1(mem2mem)


;-71 */


;-72 int LeftOpwCheck() {

@@retn: LEAVE
 ret
; ENDP

LeftOpwCheck:  ; *** PROC ***

;-73   getLeftOp();

 call getLeftOp

;-74   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop

 mov al, [RegType]
 cmp al, 4
 jne @@LeftOpwCheck15
 call segregerror
 jmp @@retn

;-75   setwflag();

@@LeftOpwCheck15:
 call setwflag

;-76   if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne @@LeftOpwCheck16
 push LeftOpwCheck_0
 call error1
 add  sp, 2

;-77   if (OpSize == RegType) return;

@@LeftOpwCheck16:
 mov al, [OpSize]
 cmp al, [RegType]
 jne @@LeftOpwCheck17
 jmp @@retn

;-78   if (OpSize){if (Op1 == IND) return;

@@LeftOpwCheck17:
 mov al, [OpSize]
 or  al, al
 je @@LeftOpwCheck18
 mov al, [Op1]
 cmp al, 4
 jne @@LeftOpwCheck19
 jmp @@retn

;-79     error1("Conflict OpSize and RegSize"); }

@@LeftOpwCheck19:
 push LeftOpwCheck_1
 call error1
 add  sp, 2

;-80   if (RegType==0) error1("no register defined");

@@LeftOpwCheck18:
 mov al, [RegType]
 cmp al, 0
 jne @@LeftOpwCheck20
 push LeftOpwCheck_2
 call error1
 add  sp, 2

;-81 }

@@LeftOpwCheck20:

;-82 int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)

@@retn:
 ret
; ENDP
LeftOpwCheck_0 db "no op size declared",0
LeftOpwCheck_1 db "Conflict OpSize and RegSize",0
LeftOpwCheck_2 db "no register defined",0

getLeftOp:  ; *** PROC ***

;-83 //set: op1, disp->imm, reg, regt->size


;-84   disp=0; imme=0; reg=0;

 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov word [imme], ax
 mov eax, 0
 mov byte [reg], al

;-85 


;-86   Op1=getOp1();

 call getOp1
 mov byte [Op1], al

;-87   if (isToken('[')) {Op1 = IND; getIND(); return; }          //4

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je @@getLeftOp21
 mov eax, 4
 mov byte [Op1], al
 call getIND
 jmp @@retn

;-88   if (Op1 == 0) error1("Name of operand expected");

@@getLeftOp21:
 mov al, [Op1]
 cmp al, 0
 jne @@getLeftOp22
 push getLeftOp_0
 call error1
 add  sp, 2

;-89   if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1

@@getLeftOp22:
 mov al, [Op1]
 cmp al, 1
 jne @@getLeftOp23
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp @@retn

;-90   if (Op1 == REG) return;                                    //2

@@getLeftOp23:
 mov al, [Op1]
 cmp al, 2
 jne @@getLeftOp24
 jmp @@retn

;-91   if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3

@@getLeftOp24:
 mov al, [Op1]
 cmp al, 3
 jne @@getLeftOp25
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp @@retn

;-92   error1("Name of operand expected #1");

@@getLeftOp25:
 push getLeftOp_1
 call error1
 add  sp, 2

;-93 }


;-94 int setwflag() {//only Op1 (first operand)

@@retn:
 ret
; ENDP
getLeftOp_0 db "Name of operand expected",0
getLeftOp_1 db "Name of operand expected #1",0

setwflag:  ; *** PROC ***

;-95   wflag=0;

 mov eax, 0
 mov byte [wflag], al

;-96   if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne @@setwflag26

;-97     if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}

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

;-98   }

@@setwflag27:

;-99   if (OpSize  == DWORD) {gen66h(); wflag=1;}

@@setwflag26:
 mov al, [OpSize]
 cmp al, 3
 jne @@setwflag29
 call gen66h
 mov eax, 1
 mov byte [wflag], al

;-100   if (OpSize  ==  WORD) wflag=1;

@@setwflag29:
 mov al, [OpSize]
 cmp al, 2
 jne @@setwflag30
 mov eax, 1
 mov byte [wflag], al

;-101 }

@@setwflag30:

;-102 int getOp1() {//scan for a single operand

 ret
; ENDP

getOp1:  ; *** PROC ***

;-103   //set:Op1, imme, disp, RegType, TegNo, reg


;-104   if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne @@getOp131
 mov eax, 0
 jmp @@retn

;-105   if (TokeType == DIGIT)  return IMM;// 1

@@getOp131:
 mov al, [TokeType]
 cmp al, 1
 jne @@getOp132
 mov eax, 1
 jmp @@retn

;-106   if (TokeType == ALNUME) {

@@getOp132:
 mov al, [TokeType]
 cmp al, 3
 jne @@getOp133

;-107     RegNo=testReg();//set global RegType

 call testReg
 mov byte [RegNo], al

;-108     if (RegType)          return REG;// 2

 mov al, [RegType]
 or  al, al
 je @@getOp134
 mov eax, 2
 jmp @@retn

;-109     LabelIx=searchLabel();//disp=LabelAddr[LabelIx];

@@getOp134:
 call searchLabel
 mov word [LabelIx], ax

;-110     if (LabelIx)          return DIR;// 3

 mov ax, [LabelIx]
 or  al, al
 je @@getOp135
 mov eax, 3
 jmp @@retn

;-111     else error1("variable not found"); }

 jmp @@getOp136
@@getOp135:
 push getOp1_0
 call error1
 add  sp, 2
@@getOp136:

;-112   return 0;

@@getOp133:
 mov eax, 0
 jmp @@retn

;-113 }


;-114 int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]

@@retn:
 ret
; ENDP
getOp1_0 db "variable not found",0

getIND:  ; *** PROC ***

;-115   char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI

;Function : getIND, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   115 NULL bp-2    op2
;  201 var sign byte   115 NULL bp-4    r1;
 ENTER  4,0
 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov byte [bp-4], al
 mov eax, 0
 mov byte [RegType], al

;-116   do {

@@getIND37:

;-117     getTokeType();

 call getTokeType

;-118     op2=getOp1();

 call getOp1
 mov byte [bp-2], al

;-119     if (op2 ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne @@getIND38
 call syntaxerror

;-120     if (op2 == IMM) disp=disp+SymbolInt;

@@getIND38:
 mov al, [bp-2]
 cmp al, 1
 jne @@getIND39
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-121     if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();

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

;-122     if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable

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

;-123     if (isToken('-')) {getTokeType();

@@getIND43:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je @@getIND44
 call getTokeType

;-124       if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}

 mov al, [TokeType]
 cmp al, 1
 je  @@getIND45
 call numbererror
@@getIND45:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-125   } while (isToken('+'));

@@getIND44:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je @@getIND46
 jmp @@getIND37
@@getIND46:

;-126   if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne @@getIND47
 push getIND_0
 call errorexit
 add  sp, 2

;-127   reg=r1;

@@getIND47:
 mov al, [bp-4]
 mov byte [reg], al

;-128 }


;-129 int getIndReg1() {char m; m=0;
 LEAVE
 ret
; ENDP
getIND_0 db "] expected",0

getIndReg1:  ; *** PROC ***
;Function : getIndReg1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   129 NULL bp-2    m;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-130   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg148
 call indexerror

;-131   if (RegNo==3) m=7;//BX

@@getIndReg148:
 mov al, [RegNo]
 cmp al, 3
 jne @@getIndReg149
 mov eax, 7
 mov byte [bp-2], al

;-132   if (RegNo==5) m=6;//BP change to BP+0

@@getIndReg149:
 mov al, [RegNo]
 cmp al, 5
 jne @@getIndReg150
 mov eax, 6
 mov byte [bp-2], al

;-133   if (RegNo==7) m=5;//DI

@@getIndReg150:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg151
 mov eax, 5
 mov byte [bp-2], al

;-134   if (RegNo==6) m=4;//SI

@@getIndReg151:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg152
 mov eax, 4
 mov byte [bp-2], al

;-135   if (m    ==0) indexerror();

@@getIndReg152:
 mov al, [bp-2]
 cmp al, 0
 jne @@getIndReg153
 call indexerror

;-136   return m;

@@getIndReg153:
 mov al, [bp-2]
 jmp @@retn

;-137 }


;-138 int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI

@@retn: LEAVE
 ret
; ENDP

getIndReg2:  ; *** PROC ***
;Function : getIndReg2, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   138 NULL bp+4    r1
;  201 var sign byte   138 NULL bp-2    m;
 ENTER  2,0
 mov eax, 4
 mov byte [bp-2], al

;-139   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg254
 call indexerror

;-140   if (RegNo==7) if (r1==6) m=3;//BP+DI

@@getIndReg254:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg255
 mov al, [bp+4]
 cmp al, 6
 jne @@getIndReg256
 mov eax, 3
 mov byte [bp-2], al

;-141            else if (r1==7) m=1;//BX+DI

 jmp @@getIndReg257
@@getIndReg256:
 mov al, [bp+4]
 cmp al, 7
 jne @@getIndReg258
 mov eax, 1
 mov byte [bp-2], al

;-142   if (RegNo==6) if (r1==6) m=2;//BP+SI

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

;-143            else if (r1==7) m=0;//BX+DI

 jmp @@getIndReg261
@@getIndReg260:
 mov al, [bp+4]
 cmp al, 7
 jne @@getIndReg262
 mov eax, 0
 mov byte [bp-2], al

;-144   if (m > 3) indexerror();

@@getIndReg262:
@@getIndReg261:
@@getIndReg259:
 mov al, [bp-2]
 cmp al, 3
 jle @@getIndReg263
 call indexerror

;-145   return m;

@@getIndReg263:
 mov al, [bp-2]
 jmp @@retn

;-146 }


;-147 


;-148 int getCodeSize() {

@@retn: LEAVE
 ret
; ENDP

getCodeSize:  ; *** PROC ***

;-149   if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@getCodeSize64

;-150     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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

;-151     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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

;-152     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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

;-153   } return 0;

@@getCodeSize67:
@@getCodeSize64:
 mov eax, 0
 jmp @@retn

;-154 }


;-155 int isToken(char c) {

@@retn:
 ret
; ENDP
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0

isToken:  ; *** PROC ***

;-156   skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   155 NULL bp+4    c;
 ENTER  0,0
 call skipBlank

;-157   if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne @@isToken68

;-158     InputPtr++; return 1;} return 0;

 inc  word [InputPtr]
 mov eax, 1
 jmp @@retn
@@isToken68:
 mov eax, 0
 jmp @@retn

;-159 }


;-160 int skipRest() {

@@retn: LEAVE
 ret
; ENDP

skipRest:  ; *** PROC ***

;-161   getTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");

 call getTokeType
 mov al, [TokeType]
 cmp al, 0
 je  @@skipRest69
 push skipRest_0
 call prs
 add  sp, 2

;-162 }

@@skipRest69:

;-163 // generate code ...........................................................


;-164 int gen66h() {genCode8(0x66);}

 ret
; ENDP
skipRest_0 db "\n; ********** extra char ignored",0

gen66h:  ; *** PROC ***
 push 102
 call genCode8
 add  sp, 2

;-165 int genCode8(char c) {//ret: BinLen++, OpPrintIndex++

 ret
; ENDP

genCode8:  ; *** PROC ***

;-166   FileBin[BinLen]=c; BinLen++; PC++;

;Function : genCode8, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   165 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al
 inc  word [BinLen]
 inc  word [PC]

;-167   if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }

 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode870
 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al
 inc  word [OpPrintIndex]

;-168 }

@@genCode870:

;-169 int genCode16(int i) {
 LEAVE
 ret
; ENDP

genCode16:  ; *** PROC ***

;-170   genCode8(i); i=i >> 8; genCode8(i);

;Function : genCode16, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   169 NULL bp+4    i;
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

;-171 }


;-172 int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
 LEAVE
 ret
; ENDP

genInstruction:  ; *** PROC ***

;-173   if(loc) OpCodePtr=OpCodePtr+loc;

;Function : genInstruction, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign byte   172 NULL bp+4    No
;  201 var sign word   172 NULL bp+6    loc
;  202 var sign byte   172 NULL bp-2    c;
 ENTER  2,0
 mov ax, [bp+6]
 or  al, al
 je @@genInstruction71
 mov ax, [OpCodePtr]
 add ax, [bp+6]
 mov word [OpCodePtr], ax

;-174   c= *OpCodePtr + No; genCode8(c);

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

;-175 }


;-176 int genCodeInREG() {char x; //get Code for second byte
 LEAVE
 ret
; ENDP

genCodeInREG:  ; *** PROC ***

;-177   OpCodePtr++; x= *OpCodePtr; writeEA(x);

;Function : genCodeInREG, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   176 NULL bp-2    x;
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

;-178 }


;-179 int genModRegRM(){ writeEA(reg);//todo
 LEAVE
 ret
; ENDP

genModRegRM:  ; *** PROC ***
 mov al, byte [reg]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-180 }


;-181 int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg

 ret
; ENDP

writeEA:  ; *** PROC ***

;-182   len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   181 NULL bp+4    xxx
;  201 var sign byte   181 NULL bp-2    len;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-183   xxx = xxx << 3;//in reg field of mod r/m

 mov al, [bp+4]
 shl al, 3
 mov byte [bp+4], al

;-184   if (Op1 ==   0) addrexit();

 mov al, [Op1]
 cmp al, 0
 jne @@writeEA72
 call addrexit

;-185   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2

@@writeEA72:
 mov al, [Op1]
 cmp al, 2
 jne @@writeEA73
 or  byte [bp+4], 192
 mov al, [bp+4]
 add al, [RegNo]
 mov byte [bp+4], al

;-186   if (Op1 == DIR) {xxx |= 6; len=2; }                      //3

@@writeEA73:
 mov al, [Op1]
 cmp al, 3
 jne @@writeEA74
 or  byte [bp+4], 6
 mov eax, 2
 mov byte [bp-2], al

;-187   if (Op1 == IND) { xxx = xxx + reg;                       //4

@@writeEA74:
 mov al, [Op1]
 cmp al, 4
 jne @@writeEA75
 mov al, [bp+4]
 add al, [reg]
 mov byte [bp+4], al

;-188     if (disp) {disp; if(ax > 127) len=2; else len=1;

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

;-189       if (len == 1) xxx |= 0x40; else xxx |= 0x80;}

@@writeEA78:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA79
 or  byte [bp+4], 64
 jmp @@writeEA80
@@writeEA79:
 or  byte [bp+4], 128
@@writeEA80:

;-190     }

@@writeEA76:

;-191   genCode8(xxx);// gen second byte

@@writeEA75:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-192   if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA81
 push word [disp]
 call genCode8
 add  sp, 2

;-193   if (len == 2) genCode16(disp);

@@writeEA81:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA82
 push word [disp]
 call genCode16
 add  sp, 2

;-194 }

@@writeEA82:

;-195 int test1() { __asm {
 LEAVE
 ret
; ENDP

test1:  ; *** PROC ***


;-196 inc byte [Version1]   ;FE 06 [1000]

inc byte [Version1]   ;FE 06 [1000]

;-197 add bx, ax    ;01 C3

add bx, ax    ;01 C3

;-198 add ax, bx    ;01 D8

add ax, bx    ;01 D8

;-199 add word ax, [bx] ;03 07

add word ax, [bx] ;03 07

;-200 VA dw 8

VA dw 8

;-201 mov byte [bp- 4], al ;88 46 FC

mov byte [bp- 4], al ;88 46 FC

;-202 mov      [VA+bx], al ;88 87 [300F]

mov      [VA+bx], al ;88 87 [300F]

;-203 }  }



;-204 //#include "AS1.C"


;-205 #include "PARSE.C"

 ret
; ENDP
;Use include file: PARSE.C

;-1 /*


;-2 parse:


;-3   do


;-4     getLine


;-5     do


;-6       getToken (getTokeType)


;-7       if (! letterX) error


;-8       checkOpcode


;-9       if (! Codetype) storeLabel


;-10     while (! CodeType)


;-11     if (CodeType) process


;-12     skipRest


;-13     printLine


;-14   while (DOS_NoBytes !=0)


;-15 */


;-16 int parse() {


parse:  ; *** PROC ***

;-17   LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-18   do {

@@parse83:

;-19     PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';

 mov ax, [PC]
 mov word [PCStart], ax
 mov eax, 0
 mov byte [OpSize], al
 mov eax, 0
 mov word [OpPrintIndex], ax
 mov eax, 32
 mov byte [PrReloc], al

;-20     getLine();

 call getLine

;-21     InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-22     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-23     if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@parse84

;-24       if (isLabel) { //set in getName

 mov al, [isLabel]
 or  al, al
 je @@parse85

;-25         storeLabel();

 call storeLabel

;-26         InputPtr++;//remove :

 inc  word [InputPtr]

;-27         getTokeType();

 call getTokeType

;-28       }


;-29     }

@@parse85:

;-30     if (TokeType == ALNUME) {

@@parse84:
 mov al, [TokeType]
 cmp al, 3
 jne @@parse86

;-31       lookCode();// and OpCodePtr

 call lookCode

;-32       if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je @@parse87
 call process

;-33       else getVariable();

 jmp @@parse88
@@parse87:
 call getVariable

;-34       skipRest();

@@parse88:
 call skipRest

;-35     }


;-36     else if (TokeType >  ALNUME) error1("Label or instruction expected");

 jmp @@parse89
@@parse86:
 mov al, [TokeType]
 cmp al, 3
 jle @@parse90
 push parse_0
 call error1
 add  sp, 2

;-37     else if (TokeType == DIGIT) error1("No digit allowed at start of line");

 jmp @@parse91
@@parse90:
 mov al, [TokeType]
 cmp al, 1
 jne @@parse92
 push parse_1
 call error1
 add  sp, 2

;-38     printLine();

@@parse92:
@@parse91:
@@parse89:
 call printLine

;-39   } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  @@parse93
 jmp @@parse83
@@parse93:

;-40 }


;-41 int storeLabel() {

 ret
; ENDP
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0

storeLabel:  ; *** PROC ***

;-42   if(searchLabel()) error1("duplicate symbol");

 call searchLabel
 or  al, al
 je @@storeLabel94
 push storeLabel_0
 call error1
 add  sp, 2

;-43   LabelNamePtr=strcpy(LabelNamePtr, Symbol);

@@storeLabel94:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-44   LabelNamePtr++;

 inc  word [LabelNamePtr]

;-45   LabelMaxIx++;

 inc  word [LabelMaxIx]

;-46   LabelAddr[LabelMaxIx] = PC;

 mov ax, [PC]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-47 }


;-48 int searchLabel() {

 ret
; ENDP
storeLabel_0 db "duplicate symbol",0

searchLabel:  ; *** PROC ***

;-49   int LIx; char *p; int j;


;-50   p = &LabelNames;

;Function : searchLabel, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word    49 NULL bp-2    LIx
;  201 ptr sign byte    49 NULL bp-4    p
;  202 var sign word    49 NULL bp-6    j;
 ENTER  6,0
 mov ax, LabelNames
 mov word [bp-4], ax

;-51   LIx=1;

 mov eax, 1
 mov word [bp-2], ax

;-52   while (LIx <= LabelMaxIx) {

@@searchLabel95:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel96

;-53     if (eqstr(p, Symbol)) return LIx;//and searchType

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel97
 mov ax, [bp-2]
 jmp @@retn

;-54     j=strlen(p);

@@searchLabel97:
 push word [bp-4]
 call strlen
 add  sp, 2
 mov word [bp-6], ax

;-55     p=p+j; p++; LIx++;

 mov ax, [bp-4]
 add ax, [bp-6]
 mov word [bp-4], ax
 inc  word [bp-4]
 inc  word [bp-2]

;-56   }


;-57   return 0;

 jmp @@searchLabel95
@@searchLabel96:
 mov eax, 0
 jmp @@retn

;-58 }


;-59 int getVariable() { char c;

@@retn: LEAVE
 ret
; ENDP

getVariable:  ; *** PROC ***

;-60   storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    59 NULL bp-2    c;
 ENTER  2,0
 call storeLabel

;-61   getTokeType(); if(TokeType==ALNUME) {// getName

 call getTokeType
 mov al, [TokeType]
 cmp al, 3
 jne @@getVariable98

;-62     lookCode();

 call lookCode

;-63     if (CodeType < 200) errorexit("D or RES B,W,D expected");

 mov al, [CodeType]
 cmp al, 200
 jge @@getVariable99
 push getVariable_0
 call errorexit
 add  sp, 2

;-64     if (CodeType > 207) errorexit("D or RES B,W,D expected");

@@getVariable99:
 mov al, [CodeType]
 cmp al, 207
 jle @@getVariable100
 push getVariable_1
 call errorexit
 add  sp, 2

;-65     if (CodeType== 200) {// DB

@@getVariable100:
 mov al, [CodeType]
 cmp al, 200
 jne @@getVariable101

;-66       do { getTokeType();

@@getVariable102:
 call getTokeType

;-67         if (TokeType ==DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable103
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-68         else {

 jmp @@getVariable104
@@getVariable103:

;-69           skipBlank();

 call skipBlank

;-70           if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable105

;-71             do { c= *InputPtr;

@@getVariable106:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-72               genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-73               InputPtr++;

 inc  word [InputPtr]

;-74             } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  @@getVariable107
 jmp @@getVariable106
@@getVariable107:

;-75             InputPtr++;

 inc  word [InputPtr]

;-76           }


;-77         }

@@getVariable105:

;-78       } while (isToken(','));

@@getVariable104:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable108
 jmp @@getVariable102
@@getVariable108:

;-79     }


;-80     if (CodeType== 201) {// DW

@@getVariable101:
 mov al, [CodeType]
 cmp al, 201
 jne @@getVariable109

;-81       do { getTokeType();

@@getVariable110:
 call getTokeType

;-82         if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable111
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-83       } while (isToken(','));

@@getVariable111:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable112
 jmp @@getVariable110
@@getVariable112:

;-84     }


;-85   }

@@getVariable109:

;-86   else errorexit("DB,DW,DD or RESB,W,D expected");

 jmp @@getVariable113
@@getVariable98:
 push getVariable_2
 call errorexit
 add  sp, 2

;-87 }

@@getVariable113:

;-88 int lookCode() { // ret: CodeType, *OpCodePtr
 LEAVE
 ret
; ENDP
getVariable_0 db "D or RES B,W,D expected",0
getVariable_1 db "D or RES B,W,D expected",0
getVariable_2 db "DB,DW,DD or RESB,W,D expected",0

lookCode:  ; *** PROC ***

;-89   CodeType=0;

 mov eax, 0
 mov byte [CodeType], al

;-90   OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-91   OpCodePtr++;

 inc  word [OpCodePtr]

;-92   do  {

@@lookCode114:

;-93     if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode115

;-94       while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode116:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode117
 inc  word [OpCodePtr]

;-95       OpCodePtr++; CodeType =*OpCodePtr;

 jmp @@lookCode116
@@lookCode117:
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-96       return;

 jmp @@retn

;-97     }


;-98   while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode115:
@@lookCode118:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode119
 inc  word [OpCodePtr]

;-99   OpCodePtr++;

 jmp @@lookCode118
@@lookCode119:
 inc  word [OpCodePtr]

;-100   } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode120
 jmp @@lookCode114
@@lookCode120:

;-101 }

@@retn:
 ret
; ENDP
;Back to main program: AS.C

;-206 #include "HELPER.C"

;Use include file: HELPER.C

;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13


getLine:  ; *** PROC ***

;-2   InputPtr= &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-3   *InputPtr=0;//if last line is empty

 mov eax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-4   do {

@@getLine121:

;-5     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-6     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je @@getLine122
 push getLine_0
 call errorexit
 add  sp, 2

;-7     if (DOS_NoBytes == 0) return;

@@getLine122:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne @@getLine123
 jmp @@retn

;-8     *InputPtr = DOS_ByteRead;

@@getLine123:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-9     InputPtr++;

 inc  word [InputPtr]

;-10   } while (ifEOL(DOS_ByteRead) == 0);

 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne @@getLine124
 jmp @@getLine121
@@getLine124:

;-11   InputPtr--;

 dec  word [InputPtr]

;-12   *InputPtr=0;

 mov eax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-13 }


;-14 int ifEOL(char c) {

@@retn:
 ret
; ENDP
getLine_0 db "Reading Source",0

ifEOL:  ; *** PROC ***

;-15   if (c == 10) return 1;

;Function : ifEOL, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    14 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne @@ifEOL125
 mov eax, 1
 jmp @@retn

;-16   if (c == 13) {

@@ifEOL125:
 mov al, [bp+4]
 cmp al, 13
 jne @@ifEOL126

;-17     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-18     return 1;}

 mov eax, 1
 jmp @@retn

;-19   return 0;

@@ifEOL126:
 mov eax, 0
 jmp @@retn

;-20 }


;-21 int skipBlank() {

@@retn: LEAVE
 ret
; ENDP

skipBlank:  ; *** PROC ***

;-22   skipblank1:

@@skipblank1:

;-23     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne @@skipBlank127
 inc  word [InputPtr]
 jmp @@skipblank1

;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

@@skipBlank127:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne @@skipBlank128
 inc  word [InputPtr]
 jmp @@skipblank1

;-25 }

@@skipBlank128:

;-26 int letterE(char c) {

 ret
; ENDP

letterE:  ; *** PROC ***

;-27   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    26 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne @@letterE129
 mov eax, 1
 jmp @@retn

;-28   if (c=='.') return 1;

@@letterE129:
 mov al, [bp+4]
 cmp al, 46
 jne @@letterE130
 mov eax, 1
 jmp @@retn

;-29   if (c> 'z') return 0;

@@letterE130:
 mov al, [bp+4]
 cmp al, 122
 jle @@letterE131
 mov eax, 0
 jmp @@retn

;-30   if (c< '@') return 0; // at included

@@letterE131:
 mov al, [bp+4]
 cmp al, 64
 jge @@letterE132
 mov eax, 0
 jmp @@retn

;-31   if (c> 'Z') { if (c< 'a') return 0; }

@@letterE132:
 mov al, [bp+4]
 cmp al, 90
 jle @@letterE133
 mov al, [bp+4]
 cmp al, 97
 jge @@letterE134
 mov eax, 0
 jmp @@retn
@@letterE134:

;-32   return 1;

@@letterE133:
 mov eax, 1
 jmp @@retn

;-33 }


;-34 int alnumE(char c) {

@@retn: LEAVE
 ret
; ENDP

alnumE:  ; *** PROC ***

;-35   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    34 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@alnumE135
 mov eax, 1
 jmp @@retn

;-36   if (letterE(c)) return 1;

@@alnumE135:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@alnumE136
 mov eax, 1
 jmp @@retn

;-37   return 0;

@@alnumE136:
 mov eax, 0
 jmp @@retn

;-38 }


;-39 int getDigit(unsigned char c) {//ret: SymbolInt

@@retn: LEAVE
 ret
; ENDP

getDigit:  ; *** PROC ***

;-40   unsigned int CastInt;


;-41   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    39 NULL bp+4    c
;  201 var unsg word    40 NULL bp-2    CastInt;
 ENTER  2,0
 mov eax, 0
 mov word [SymbolInt], ax

;-42   do {

@@getDigit137:

;-43     c-='0';

 sub  byte [bp+4], 48

;-44     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov ebx, 10
 mul ebx
 mov word [SymbolInt], ax

;-45     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov word [bp-2], ax

;-46     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-47     InputPtr++;

 inc  word [InputPtr]

;-48     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-49   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getDigit138
 jmp @@getDigit137
@@getDigit138:

;-50 }


;-51 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
; ENDP

getName:  ; *** PROC ***

;-52   char *p;


;-53   p = &Symbol;

;Function : getName, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    51 NULL bp+4    c
;  201 ptr sign byte    52 NULL bp-2    p;
 ENTER  2,0
 mov ax, Symbol
 mov word [bp-2], ax

;-54   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-55   p++;

 inc  word [bp-2]

;-56   while (alnumE(c)) {

@@getName139:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je @@getName140

;-57     InputPtr++;

 inc  word [InputPtr]

;-58     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-59     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-60     p++;

 inc  word [bp-2]

;-61   }


;-62   if (c == ':') isLabel=1; else isLabel=0;

 jmp @@getName139
@@getName140:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName141
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName142
@@getName141:
 mov eax, 0
 mov byte [isLabel], al

;-63   p--;

@@getName142:
 dec  word [bp-2]

;-64   *p = 0;

 mov eax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-65   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-66   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-67 }


;-68 int testReg() {
 LEAVE
 ret
; ENDP

testReg:  ; *** PROC ***

;-69 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-70   RegType=0;

 mov eax, 0
 mov byte [RegType], al

;-71   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge @@testReg143
 mov eax, 0
 jmp @@retn

;-72   if (strlen(Symbol) > 3) return 0;

@@testReg143:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg144
 mov eax, 0
 jmp @@retn

;-73   RegType=BYTE;

@@testReg144:
 mov eax, 1
 mov byte [RegType], al

;-74   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg145
 mov eax, 0
 jmp @@retn

;-75   if (eqstr(SymbolUpper, "CL")) return 1;

@@testReg145:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg146
 mov eax, 1
 jmp @@retn

;-76   if (eqstr(SymbolUpper, "DL")) return 2;

@@testReg146:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg147
 mov eax, 2
 jmp @@retn

;-77   if (eqstr(SymbolUpper, "BL")) return 3;

@@testReg147:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg148
 mov eax, 3
 jmp @@retn

;-78   if (eqstr(SymbolUpper, "AH")) return 4;

@@testReg148:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg149
 mov eax, 4
 jmp @@retn

;-79   if (eqstr(SymbolUpper, "CH")) return 5;

@@testReg149:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg150
 mov eax, 5
 jmp @@retn

;-80   if (eqstr(SymbolUpper, "DH")) return 6;

@@testReg150:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg151
 mov eax, 6
 jmp @@retn

;-81   if (eqstr(SymbolUpper, "BH")) return 7;

@@testReg151:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg152
 mov eax, 7
 jmp @@retn

;-82   RegType=WORD;

@@testReg152:
 mov eax, 2
 mov byte [RegType], al

;-83   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg153
 mov eax, 0
 jmp @@retn

;-84   if (eqstr(SymbolUpper, "CX")) return 1;

@@testReg153:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg154
 mov eax, 1
 jmp @@retn

;-85   if (eqstr(SymbolUpper, "DX")) return 2;

@@testReg154:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 2
 jmp @@retn

;-86   if (eqstr(SymbolUpper, "BX")) return 3;

@@testReg155:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg156
 mov eax, 3
 jmp @@retn

;-87   if (eqstr(SymbolUpper, "SP")) return 4;

@@testReg156:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg157
 mov eax, 4
 jmp @@retn

;-88   if (eqstr(SymbolUpper, "BP")) return 5;

@@testReg157:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg158
 mov eax, 5
 jmp @@retn

;-89   if (eqstr(SymbolUpper, "SI")) return 6;

@@testReg158:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg159
 mov eax, 6
 jmp @@retn

;-90   if (eqstr(SymbolUpper, "DI")) return 7;

@@testReg159:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg160
 mov eax, 7
 jmp @@retn

;-91   RegType=SEGREG;

@@testReg160:
 mov eax, 4
 mov byte [RegType], al

;-92   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg161
 mov eax, 0
 jmp @@retn

;-93   if (eqstr(SymbolUpper, "CS")) return 1;

@@testReg161:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg162
 mov eax, 1
 jmp @@retn

;-94   if (eqstr(SymbolUpper, "SS")) return 2;

@@testReg162:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg163
 mov eax, 2
 jmp @@retn

;-95   if (eqstr(SymbolUpper, "DS")) return 3;

@@testReg163:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg164
 mov eax, 3
 jmp @@retn

;-96   if (eqstr(SymbolUpper, "FS")) return 4;

@@testReg164:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg165
 mov eax, 4
 jmp @@retn

;-97   if (eqstr(SymbolUpper, "GS")) return 5;

@@testReg165:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg166
 mov eax, 5
 jmp @@retn

;-98   RegType=DWORD;

@@testReg166:
 mov eax, 3
 mov byte [RegType], al

;-99   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg167
 mov eax, 0
 jmp @@retn

;-100   if (eqstr(SymbolUpper, "ECX"))return 1;

@@testReg167:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg168
 mov eax, 1
 jmp @@retn

;-101   if (eqstr(SymbolUpper, "EDX"))return 2;

@@testReg168:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg169
 mov eax, 2
 jmp @@retn

;-102   if (eqstr(SymbolUpper, "EBX"))return 3;

@@testReg169:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg170
 mov eax, 3
 jmp @@retn

;-103   if (eqstr(SymbolUpper, "ESP"))return 4;

@@testReg170:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg171
 mov eax, 4
 jmp @@retn

;-104   if (eqstr(SymbolUpper, "EBP"))return 5;

@@testReg171:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg172
 mov eax, 5
 jmp @@retn

;-105   if (eqstr(SymbolUpper, "ESI"))return 6;

@@testReg172:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg173
 mov eax, 6
 jmp @@retn

;-106   if (eqstr(SymbolUpper, "EDI"))return 7;

@@testReg173:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg174
 mov eax, 7
 jmp @@retn

;-107   RegType=0; return 0;

@@testReg174:
 mov eax, 0
 mov byte [RegType], al
 mov eax, 0
 jmp @@retn

;-108 }

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
;Back to main program: AS.C

;-207 #include "OUTPUT.C"

;Use include file: OUTPUT.C

;-1 int printLine() { int i; char c;


printLine:  ; *** PROC ***

;-2   prs("\n"); printhex16(PCStart);

;Function : printLine, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word     1 NULL bp-2    i
;  201 var sign byte     1 NULL bp-4    c;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2
 push word [PCStart]
 call printhex16
 add  sp, 2

;-3   if (OpPrintIndex == 0) prs("                ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne @@printLine175
 push printLine_1
 call prs
 add  sp, 2

;-4   else {

 jmp @@printLine176
@@printLine175:

;-5     prc(PrReloc);

 mov al, byte [PrReloc]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-6     i=0;

 mov eax, 0
 mov word [bp-2], ax

;-7     do {

@@printLine177:

;-8       c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov byte [bp-4], al

;-9       printhex8a(c); prc(' ');

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-10       i++;

 inc  word [bp-2]

;-11     } while(i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge @@printLine178
 jmp @@printLine177
@@printLine178:

;-12     do {// fill rest with blank

@@printLine179:

;-13       prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-14       i++;

 inc  word [bp-2]

;-15     } while(i < OPMAXLEN);

 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine180
 jmp @@printLine179
@@printLine180:

;-16   }


;-17   prscomment(InputBuf);

@@printLine176:
 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-18 }


;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
 LEAVE
 ret
; ENDP
printLine_0 db "\n",0
printLine_1 db "                ",0
printLine_2 db "   ",0

prc:  ; *** PROC ***
;Function : prc, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    19 NULL bp+4    c;
 ENTER  0,0
 mov al, [LIST]
 or  al, al
 je @@prc181
cmp byte [bp+4], 10
 jne @@prc182
 mov  ax, 13
 call writetty

;-20      al=c; writetty(); }

@@prc182:
 mov  al, [bp+4]
 call writetty

;-21    fputcR(c,lst_fd); }

@@prc181:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-22 


;-23 int prscomment(unsigned char *s) {unsigned char c;
 LEAVE
 ret
; ENDP

prscomment:  ; *** PROC ***

;-24   while(*s){c=*s;prc(c);s++;}

;Function : prscomment, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte    23 NULL bp+4    s
;  201 var unsg byte    23 NULL bp-2    c;
 ENTER  2,0
@@prscomment183:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment184
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

;-25 }

 jmp @@prscomment183
@@prscomment184:

;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
 LEAVE
 ret
; ENDP

prs:  ; *** PROC ***
;Function : prs, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte    26 NULL bp+4    s
;  201 var unsg byte    26 NULL bp-2    c
;  202 var sign word    26 NULL bp-4    com;
 ENTER  4,0
 mov eax, 0
 mov word [bp-4], ax

;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;

@@prs185:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs186
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, [bp-2]
 cmp al, 34
 jne @@prs187
 mov ax, [bp-4]
 or  al, al
 je @@prs188
 mov eax, 0
 mov word [bp-4], ax
 jmp @@prs189
@@prs188:
 mov eax, 1
 mov word [bp-4], ax

;-28     if (c==92) { if (com==0) { s++; c=*s;

@@prs189:
@@prs187:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs190
 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs191
 inc  word [bp+4]
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }

 mov al, [bp-2]
 cmp al, 110
 jne @@prs192
 mov eax, 10
 mov byte [bp-2], al
@@prs192:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs193
 mov eax, 9
 mov byte [bp-2], al
@@prs193:
@@prs191:
@@prs190:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
 inc  word [bp+4]

;-30 }

 jmp @@prs185
@@prs186:

;-31 int printhex8a(unsigned int c) { unsigned int nib;
 LEAVE
 ret
; ENDP

printhex8a:  ; *** PROC ***

;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word    31 NULL bp+4    c
;  201 var unsg word    31 NULL bp-2    nib;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 4
 mov word [bp-2], ax
 add  word [bp-2], 48
 mov ax, [bp-2]
 cmp ax, 57
 jle @@printhex8a194
 add  word [bp-2], 7
@@printhex8a194:
 push word [bp-2]
 call prc
 add  sp, 2

;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);

 mov ax, [bp+4]
 and ax, 15
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

;-34 }


;-35 int printhex16(unsigned int i) {unsigned int half;
 LEAVE
 ret
; ENDP

printhex16:  ; *** PROC ***

;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word    35 NULL bp+4    i
;  201 var unsg word    35 NULL bp-2    half;
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

;-37 }


;-38 int printIntU(unsigned int n) { unsigned int e;
 LEAVE
 ret
; ENDP

printIntU:  ; *** PROC ***

;-39   if ( _ n >= 10) {  e=n/10; //DIV

;Function : printIntU, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word    38 NULL bp+4    n
;  201 var unsg word    38 NULL bp-2    e;
 ENTER  2,0
cmp word [bp+4], 10 ;unsigned : 0
 jb  @@printIntU196
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov word [bp-2], ax

;-40     printIntU(e); }

 push word [bp-2]
 call printIntU
 add  sp, 2

;-41     n = n % 10; //unsigned mod

@@printIntU196:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov word [bp+4], ax

;-42     n += '0'; prc(n);

 add  word [bp+4], 48
 push word [bp+4]
 call prc
 add  sp, 2

;-43 }


;-44 


;-45 int error1(char *s) { LIST=1; ErrorCount++;
 LEAVE
 ret
; ENDP

error1:  ; *** PROC ***
;Function : error1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte    45 NULL bp+4    s;
 ENTER  0,0
 mov eax, 1
 mov byte [LIST], al
 inc  word [ErrorCount]

;-46   prs("\n;***** next line ERROR: "); prs(s);

 push error1_0
 call prs
 add  sp, 2
 push word [bp+4]
 call prs
 add  sp, 2

;-47   prs(", Symbol: "); prs(Symbol);}

 push error1_1
 call prs
 add  sp, 2
 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-48 int allowederror(){error1("not allowed here"); }
 LEAVE
 ret
; ENDP
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0

allowederror:  ; *** PROC ***
 push allowederror_0
 call error1
 add  sp, 2

;-49 int implmerror(){error1("not implemented");}

 ret
; ENDP
allowederror_0 db "not allowed here",0

implmerror:  ; *** PROC ***
 push implmerror_0
 call error1
 add  sp, 2

;-50 int indexerror (){error1("invalid index register");}

 ret
; ENDP
implmerror_0 db "not implemented",0

indexerror:  ; *** PROC ***
 push indexerror_0
 call error1
 add  sp, 2

;-51 int numbererror(){error1("number expected");}

 ret
; ENDP
indexerror_0 db "invalid index register",0

numbererror:  ; *** PROC ***
 push numbererror_0
 call error1
 add  sp, 2

;-52 int regmemerror(){error1("only register or memory allowed");}

 ret
; ENDP
numbererror_0 db "number expected",0

regmemerror:  ; *** PROC ***
 push regmemerror_0
 call error1
 add  sp, 2

;-53 int segregerror(){error1("segment register not allowed");}

 ret
; ENDP
regmemerror_0 db "only register or memory allowed",0

segregerror:  ; *** PROC ***
 push segregerror_0
 call error1
 add  sp, 2

;-54 int syntaxerror(){error1("syntax");}

 ret
; ENDP
segregerror_0 db "segment register not allowed",0

syntaxerror:  ; *** PROC ***
 push syntaxerror_0
 call error1
 add  sp, 2

;-55 


;-56 int errorexit(char *s) { error1(s); end1(1);}

 ret
; ENDP
syntaxerror_0 db "syntax",0

errorexit:  ; *** PROC ***
;Function : errorexit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte    56 NULL bp+4    s;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2
 push 1
 call end1
 add  sp, 2

;-57 int addrexit(){errorexit("illegal addres");}
 LEAVE
 ret
; ENDP

addrexit:  ; *** PROC ***
 push addrexit_0
 call errorexit
 add  sp, 2

;-58 int internexit(){errorexit("intern compiler error");}

 ret
; ENDP
addrexit_0 db "illegal addres",0

internexit:  ; *** PROC ***
 push internexit_0
 call errorexit
 add  sp, 2
 ret
; ENDP
internexit_0 db "intern compiler error",0
;Back to main program: AS.C

;-208 #include "MAIN.C"

;Use include file: MAIN.C

;-1 int getarg() { int arglen1; int i; char *c;


getarg:  ; *** PROC ***

;-2   arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word     1 NULL bp-2    arglen1
;  201 var sign word     1 NULL bp-4    i
;  202 ptr sign byte     1 NULL bp-6    c;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov word [bp-2], ax

;-3   if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne @@getarg197

;-4     cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-5     cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-6     exitR(3);

 push 3
 call exitR
 add  sp, 2

;-7   }


;-8   i=arglen1+129; *i=0;  arglen1--;

@@getarg197:
 mov ax, [bp-2]
 add ax, 129
 mov word [bp-4], ax
 mov eax, 0
 mov  bx, [bp-4]
 mov  [bx], ax
 dec  word [bp-2]

;-9   toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-10   strcpy(namein, argv); strcat1(namein, ".S");

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

;-11   strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-12   strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-13 


;-14   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;

 mov eax, 1
 mov byte [LIST], al
 mov eax, 0
 mov word [DOS_ERR], ax
 mov eax, 0
 mov word [PC], ax
 mov eax, 0
 mov word [ErrorCount], ax

;-15   asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-16   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg198
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

;-17   lst_fd=creatR(namelst);

@@getarg198:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg199
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

;-19   bin_fd=creatR(namebin);

@@getarg199:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg200
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

;-21   prs(";");prs(Version1);

@@getarg200:
 push getarg_7
 call prs
 add  sp, 2
 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-22   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);

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

;-23   prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-24   prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-25 }


;-26 int epilog() { int i; int j; char c;
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

;-27   prs("\n;END Errors: "); printIntU(ErrorCount);

;Function : epilog, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word    26 NULL bp-2    i
;  201 var sign word    26 NULL bp-4    j
;  202 var sign byte    26 NULL bp-6    c;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2
 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-28   if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je @@epilog201
 push epilog_1
 call prs
 add  sp, 2

;-29   prs(", Label & Var: ");

@@epilog201:
 push epilog_2
 call prs
 add  sp, 2

;-30 /*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");


;-31   i= &LabelNames;


;-32   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-33   } while (i < LabelNamePtr); prs("<< \n"); */


;-34   if (LabelMaxIx) {

 mov ax, [LabelMaxIx]
 or  al, al
 je @@epilog202

;-35     i = 1;

 mov eax, 1
 mov word [bp-2], ax

;-36     LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-37     do {

@@epilog203:

;-38       prs(LabelNamePtr); prc(' ');

 push word [LabelNamePtr]
 call prs
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-39       j=LabelAddr[i]; printhex16(j); prs(",  ");

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

;-40       j=strlen(LabelNamePtr);//get end of actual name

 push word [LabelNamePtr]
 call strlen
 add  sp, 2
 mov word [bp-4], ax

;-41       LabelNamePtr=LabelNamePtr+j;

 mov ax, [LabelNamePtr]
 add ax, [bp-4]
 mov word [LabelNamePtr], ax

;-42       LabelNamePtr++;

 inc  word [LabelNamePtr]

;-43       i++;

 inc  word [bp-2]

;-44     } while (i <= LabelMaxIx);

 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@epilog204
 jmp @@epilog203
@@epilog204:

;-45   }


;-46   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");

@@epilog202:
 push epilog_4
 call prs
 add  sp, 2
 push word [BinLen]
 call printIntU
 add  sp, 2
 push epilog_5
 call prs
 add  sp, 2

;-47   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-48   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;

@@epilog205:
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

;-49   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog206
 jmp @@epilog205
@@epilog206:

;-50   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-51   do {

@@epilog207:

;-52     c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov byte [bp-6], al

;-53     fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-54     i++;

 inc  word [bp-2]

;-55   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog208
 jmp @@epilog207
@@epilog208:

;-56 }


;-57 int end1(int n) {
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

;-58   fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word    57 NULL bp+4    n;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-59   fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-60   fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-61   exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-62 }
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
; eqstr
; readRL
; readRL
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
; Number of unresolved CALLs :   77
;use archive file: AR.C

;-209 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-210 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   210 NULL bp+4    s
;  201 var sign byte   210 NULL bp-2    c;
 ENTER  2,0
@@cputs209:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs210
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
 jmp @@cputs209
@@cputs210:

;-211 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   211 NULL bp+4    s;
 ENTER  0,0
@@toupper211:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper212
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper213
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper214
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper214:
@@toupper213:
 inc  word [bp+4]
 jmp @@toupper211
@@toupper212:

;-212 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-213 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   213 NULL bp+4    s
;  201 var sign word   213 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen215:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen216
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen215
@@strlen216:
 mov ax, [bp-2]
 jmp @@retn

;-214 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    5 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   214 NULL bp+4    s
;  201 ptr sign byte   214 NULL bp+6    t;
 ENTER  0,0
@@strcpy217:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-215   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy218
 jmp @@strcpy217
@@strcpy218:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-216 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   216 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit219
 mov eax, 0
 jmp @@retn
@@digit219:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit220
 mov eax, 0
 jmp @@retn
@@digit220:
 mov eax, 1
 jmp @@retn

;-217 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   217 NULL bp+4    p
;  201 ptr sign byte   217 NULL bp+6    q;
 ENTER  0,0
@@eqstr221:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr222

;-218     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr223
 mov eax, 0
 jmp @@retn
@@eqstr223:
 inc  word [bp+4]
 inc  word [bp+6]

;-219     if(*q) return 0; return 1; }

 jmp @@eqstr221
@@eqstr222:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr224
 mov eax, 0
 jmp @@retn
@@eqstr224:
 mov eax, 1
 jmp @@retn

;-220 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   220 NULL bp+4    s
;  201 ptr sign byte   220 NULL bp+6    t;
 ENTER  0,0
@@strcat1225:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1226
 inc  word [bp+4]
 jmp @@strcat1225
@@strcat1226:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-221 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   221 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-222 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   222 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-223 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   223 NULL bp+4    s
;  201 var sign word   223 NULL bp+6    fd
;  202 var sign word   223 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-224 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   224 NULL bp+4    n
;  201 var sign word   224 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-225   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-226 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   226 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-227 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   227 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-228 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
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

;-229 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   229 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch227
 mov  al, 13
 call writetty
@@putch227:
 mov  al, [bp+4]
 call writetty

;-230 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt228
 inc  word [DOS_ERR]
@@DosInt228:

;-231 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

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
;   59 var sign byte     1    1        0 I_START
;   60 arr sign byte     5 NULL        0 I_PUSHA[9]
;   61 arr sign byte     6 NULL        0 I_POPA[8]
;   62 arr sign byte     7 NULL        0 I_NOP[7]
;   63 arr sign byte     8 NULL        0 I_CBW[7]
;   64 arr sign byte     9 NULL        0 I_CWDE[8]
;   65 arr sign byte    10 NULL        0 I_CWD[7]
;   66 arr sign byte    11 NULL        0 I_CDQ[7]
;   67 arr sign byte    12 NULL        0 I_WAIT[8]
;   68 arr sign byte    13 NULL        0 I_PUSHF[9]
;   69 arr sign byte    14 NULL        0 I_POPF[8]
;   70 arr sign byte    15 NULL        0 I_SAHF[8]
;   71 arr sign byte    16 NULL        0 I_LAHF[8]
;   72 arr sign byte    17 NULL        0 I_MOVSB[9]
;   73 arr sign byte    18 NULL        0 I_MOVSW[9]
;   74 arr sign byte    19 NULL        0 I_CMPSB[9]
;   75 arr sign byte    20 NULL        0 I_CMPSW[9]
;   76 arr sign byte    21 NULL        0 I_STOSB[9]
;   77 arr sign byte    22 NULL        0 I_STOSW[9]
;   78 arr sign byte    23 NULL        0 I_LODSB[9]
;   79 arr sign byte    24 NULL        0 I_LODSW[9]
;   80 arr sign byte    25 NULL        0 I_SCASB[9]
;   81 arr sign byte    26 NULL        0 I_SCASW[9]
;   82 arr sign byte    27 NULL        0 I_LEAVE[9]
;   83 arr sign byte    28 NULL        0 I_IRET[8]
;   84 arr sign byte    29 NULL        0 I_XLAT[8]
;   85 arr sign byte    30 NULL        0 I_LOCK[8]
;   86 arr sign byte    31 NULL        0 I_REPNE[9]
;   87 arr sign byte    32 NULL        0 I_REPNZ[9]
;   88 arr sign byte    33 NULL        0 I_REPE[8]
;   89 arr sign byte    34 NULL        0 I_REPZ[8]
;   90 arr sign byte    35 NULL        0 I_HLT[7]
;   91 arr sign byte    36 NULL        0 I_CLC[7]
;   92 arr sign byte    37 NULL        0 I_STC[7]
;   93 arr sign byte    38 NULL        0 I_CLI[7]
;   94 arr sign byte    39 NULL        0 I_STI[7]
;   95 arr sign byte    40 NULL        0 I_CLD[7]
;   96 arr sign byte    41 NULL        0 I_STD[7]
;   97 arr sign byte    43 NULL        0 I_INC[9]
;   98 arr sign byte    44 NULL        0 I_DEC[9]
;   99 arr sign byte    46 NULL        0 I_NOT[8]
;  100 arr sign byte    47 NULL        0 I_NEG[8]
;  101 arr sign byte    48 NULL        0 I_MUL[8]
;  102 arr sign byte    49 NULL        0 I_IMUL[9]
;  103 arr sign byte    50 NULL        0 I_DIV[8]
;  104 arr sign byte    51 NULL        0 I_IDIV[9]
;  105 arr sign byte    53 NULL        0 I_LES[7]
;  106 arr sign byte    54 NULL        0 I_LDS[7]
;  107 arr sign byte    55 NULL        0 I_LEA[7]
;  108 arr sign byte    57 NULL        0 I_ADD[7]
;  109 arr sign byte    58 NULL        0 I_OR[6]
;  110 arr sign byte    59 NULL        0 I_ADC[7]
;  111 arr sign byte    60 NULL        0 I_SBB[7]
;  112 arr sign byte    61 NULL        0 I_AND[7]
;  113 arr sign byte    62 NULL        0 I_SUB[7]
;  114 arr sign byte    63 NULL        0 I_XOR[7]
;  115 arr sign byte    64 NULL        0 I_CMP[7]
;  116 arr sign byte    66 NULL        0 I_MOV[6]
;  117 arr sign byte    68 NULL        0 I_JO[6]
;  118 arr sign byte    69 NULL        0 I_JNO[7]
;  119 arr sign byte    70 NULL        0 I_JB[6]
;  120 arr sign byte    71 NULL        0 I_JC[6]
;  121 arr sign byte    72 NULL        0 I_JNB[7]
;  122 arr sign byte    73 NULL        0 I_JAE[7]
;  123 arr sign byte    74 NULL        0 I_JNC[7]
;  124 arr sign byte    75 NULL        0 I_JE[6]
;  125 arr sign byte    76 NULL        0 I_JZ[6]
;  126 arr sign byte    77 NULL        0 I_JNE[7]
;  127 arr sign byte    78 NULL        0 I_JNZ[7]
;  128 arr sign byte    79 NULL        0 I_JBE[7]
;  129 arr sign byte    80 NULL        0 I_JNA[7]
;  130 arr sign byte    81 NULL        0 I_JA[6]
;  131 arr sign byte    82 NULL        0 I_JS[6]
;  132 arr sign byte    83 NULL        0 I_JNS[7]
;  133 arr sign byte    84 NULL        0 I_JP[6]
;  134 arr sign byte    85 NULL        0 I_JPE[7]
;  135 arr sign byte    86 NULL        0 I_JNP[7]
;  136 arr sign byte    87 NULL        0 I_JPO[7]
;  137 arr sign byte    88 NULL        0 I_JL[6]
;  138 arr sign byte    89 NULL        0 I_JNL[7]
;  139 arr sign byte    90 NULL        0 I_JGE[7]
;  140 arr sign byte    91 NULL        0 I_JLE[7]
;  141 arr sign byte    92 NULL        0 I_JNG[7]
;  142 arr sign byte    93 NULL        0 I_JG[6]
;  143 arr sign byte    95 NULL        0 I_RET[8]
;  144 arr sign byte    97 NULL        0 I_PUSH[8]
;  145 arr sign byte    98 NULL        0 I_POP[7]
;  146 arr sign byte   100 NULL        0 I_ORG[6]
;  147 arr sign byte   101 NULL        0 I_DB[5]
;  148 arr sign byte   102 NULL        0 I_DW[5]
;  149 arr sign byte   103 NULL        0 I_DD[5]
;  150 arr sign byte   104 NULL        0 I_RESB[7]
;  151 arr sign byte   105 NULL        0 I_RESW[7]
;  152 arr sign byte   106 NULL        0 I_RESD[7]
;  153 var sign byte   107 NULL        0 I_END


;   # Calls Line Width  Name   list of functions

;    0 NULL    1 word   main
;    1    1   11 word   process
;    2   12   44 word   getTokeType
;    3    2   72 word   LeftOpwCheck
;    4    1   82 word   getLeftOp
;    5    1   94 word   setwflag
;    6    2  102 word   getOp1
;    7    1  114 word   getIND
;    8    1  129 word   getIndReg1
;    9    1  138 word   getIndReg2
;   10    1  148 word   getCodeSize
;   11    7  155 word   isToken
;   12    1  160 word   skipRest
;   13    1  164 word   gen66h
;   14    8  165 word   genCode8
;   15    3  169 word   genCode16
;   16    7  172 word   genInstruction
;   17    2  176 word   genCodeInREG
;   18 NULL  179 word   genModRegRM
;   19    2  181 word   writeEA
;   20 NULL  195 word   test1
;   21    1   16 word   parse
;   22    2   41 word   storeLabel
;   23    2   48 word   searchLabel
;   24    1   59 word   getVariable
;   25    2   88 word   lookCode
;   26    1    1 word   getLine
;   27    1   14 word   ifEOL
;   28    3   21 word   skipBlank
;   29    2   26 word   letterE
;   30    1   34 word   alnumE
;   31    1   39 word   getDigit
;   32    1   51 word   getName
;   33    1   68 word   testReg
;   34    1    1 word   printLine
;   35    9   19 word   prc
;   36    1   23 word   prscomment
;   37   24   26 word   prs
;   38    4   31 word   printhex8a
;   39    2   35 word   printhex16
;   40    3   38 word   printIntU
;   41   19   45 word   error1
;   42 NULL   48 word   allowederror
;   43 NULL   49 word   implmerror
;   44    4   50 word   indexerror
;   45    1   51 word   numbererror
;   46 NULL   52 word   regmemerror
;   47    1   53 word   segregerror
;   48    1   54 word   syntaxerror
;   49    7   56 word   errorexit
;   50    1   57 word   addrexit
;   51 NULL   58 word   internexit
;   52    1    1 word   getarg
;   53    1   26 word   epilog
;   54    2   57 word   end1
;   55    4  209 word   writetty
;   56    8  210 word   cputs
;   57    2  211 word   toupper
;   58    4  213 word   strlen
;   59    6  214 word   strcpy
;   60    3  216 word   digit
;   61   35  217 word   eqstr
;   62    3  220 word   strcat1
;   63    1  221 word   openR
;   64    2  222 word   creatR
;   65    2  223 word   readRL
;   66    2  224 word   fputcR
;   67    3  226 word   fcloseR
;   68    5  227 word   exitR
;   69    1  229 word   putch
;   70    4  230 word   DosInt
;   71 NULL  231 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0     5 getarg
;    1    12 parse
;    2    18 epilog
;    3    25 end1
;    4  1088 getTokeType
;    5  1100 getCodeSize
;    6  1112 genInstruction
;    7  1127 LeftOpwCheck
;    8  1140 genInstruction
;    9  1155 genInstruction
;   10  1170 genInstruction
;   11  1185 genCodeInREG
;   12  1198 LeftOpwCheck
;   13  1211 genInstruction
;   14  1226 genCodeInREG
;   15  1239 genInstruction
;   16  1254 genCode16
;   17  1264 genInstruction
;   18  1279 error1
;   19  1286 error1
;   20  1307 skipBlank
;   21  1317 digit
;   22  1323 getDigit
;   23  1332 letterE
;   24  1340 getName
;   25  1361 getLeftOp
;   26  1371 segregerror
;   27  1383 setwflag
;   28  1392 error1
;   29  1399 error1
;   30  1406 error1
;   31  1423 getOp1
;   32  1430 isToken
;   33  1438 getIND
;   34  1445 error1
;   35  1452 error1
;   36  1468 gen66h
;   37  1482 testReg
;   38  1490 searchLabel
;   39  1502 error1
;   40  1523 getTokeType
;   41  1535 getOp1
;   42  1542 syntaxerror
;   43  1554 getIndReg2
;   44  1565 getIndReg1
;   45  1576 isToken
;   46  1584 getTokeType
;   47  1596 numbererror
;   48  1608 isToken
;   49  1616 isToken
;   50  1624 errorexit
;   51  1647 indexerror
;   52  1658 indexerror
;   53  1685 indexerror
;   54  1696 indexerror
;   55  1719 eqstr
;   56  1725 getTokeType
;   57  1737 eqstr
;   58  1743 getTokeType
;   59  1755 eqstr
;   60  1761 getTokeType
;   61  1783 skipBlank
;   62  1802 getTokeType
;   63  1814 prs
;   64  1825 genCode8
;   65  1857 genCode8
;   66  1866 genCode8
;   67  1899 genCode8
;   68  1923 writeEA
;   69  1943 writeEA
;   70  1967 addrexit
;   71  1976 genCode8
;   72  1985 genCode8
;   73  1994 genCode16
;   74  2016 getLine
;   75  2024 getTokeType
;   76  2036 storeLabel
;   77  2047 getTokeType
;   78  2059 lookCode
;   79  2068 process
;   80  2076 getVariable
;   81  2088 skipRest
;   82  2097 error1
;   83  2104 error1
;   84  2111 printLine
;   85  2132 searchLabel
;   86  2144 error1
;   87  2151 strcpy
;   88  2178 eqstr
;   89  2184 strlen
;   90  2205 storeLabel
;   91  2216 getTokeType
;   92  2228 lookCode
;   93  2237 errorexit
;   94  2247 errorexit
;   95  2257 getTokeType
;   96  2269 genCode8
;   97  2278 skipBlank
;   98  2288 isToken
;   99  2296 genCode8
;  100  2305 isToken
;  101  2313 getTokeType
;  102  2325 genCode16
;  103  2335 isToken
;  104  2343 errorexit
;  105  2362 eqstr
;  106  2376 readRL
;  107  2383 errorexit
;  108  2393 ifEOL
;  109  2407 readRL
;  110  2443 digit
;  111  2449 letterE
;  112  2476 digit
;  113  2494 alnumE
;  114  2501 strcpy
;  115  2508 toupper
;  116  2524 strlen
;  117  2531 strlen
;  118  2538 eqstr
;  119  2544 eqstr
;  120  2550 eqstr
;  121  2556 eqstr
;  122  2562 eqstr
;  123  2568 eqstr
;  124  2574 eqstr
;  125  2580 eqstr
;  126  2586 eqstr
;  127  2592 eqstr
;  128  2598 eqstr
;  129  2604 eqstr
;  130  2610 eqstr
;  131  2616 eqstr
;  132  2622 eqstr
;  133  2628 eqstr
;  134  2634 eqstr
;  135  2640 eqstr
;  136  2646 eqstr
;  137  2652 eqstr
;  138  2658 eqstr
;  139  2664 eqstr
;  140  2670 eqstr
;  141  2676 eqstr
;  142  2682 eqstr
;  143  2688 eqstr
;  144  2694 eqstr
;  145  2700 eqstr
;  146  2706 eqstr
;  147  2712 eqstr
;  148  2732 prs
;  149  2736 printhex16
;  150  2747 prs
;  151  2751 prc
;  152  2755 printhex8a
;  153  2766 prc
;  154  2770 prs
;  155  2774 prscomment
;  156  2791 writetty
;  157  2800 writetty
;  158  2809 fputcR
;  159  2831 prc
;  160  2847 prc
;  161  2868 prc
;  162  2872 prc
;  163  2894 printhex8a
;  164  2905 printhex8a
;  165  2930 printIntU
;  166  2940 prc
;  167  2953 prs
;  168  2957 prs
;  169  2961 prs
;  170  2965 prs
;  171  2982 error1
;  172  3000 error1
;  173  3018 error1
;  174  3037 error1
;  175  3056 error1
;  176  3075 error1
;  177  3094 error1
;  178  3113 error1
;  179  3120 end1
;  180  3134 errorexit
;  181  3155 errorexit
;  182  3184 cputs
;  183  3190 cputs
;  184  3196 exitR
;  185  3202 toupper
;  186  3210 strcpy
;  187  3217 strcat1
;  188  3225 strcpy
;  189  3232 strcat1
;  190  3240 strcpy
;  191  3247 strcat1
;  192  3255 openR
;  193  3261 cputs
;  194  3267 cputs
;  195  3273 exitR
;  196  3279 creatR
;  197  3286 cputs
;  198  3292 cputs
;  199  3298 exitR
;  200  3304 creatR
;  201  3311 cputs
;  202  3317 cputs
;  203  3323 exitR
;  204  3329 prs
;  205  3333 prs
;  206  3337 prs
;  207  3341 prs
;  208  3345 prs
;  209  3349 prs
;  210  3353 prs
;  211  3357 prs
;  212  3361 prs
;  213  3378 prs
;  214  3382 printIntU
;  215  3392 prs
;  216  3396 prs
;  217  3400 prs
;  218  3404 prc
;  219  3408 printhex16
;  220  3419 prs
;  221  3423 strlen
;  222  3430 prs
;  223  3434 printIntU
;  224  3444 prs
;  225  3448 prc
;  226  3452 printhex8a
;  227  3463 fputcR
;  228  3477 fcloseR
;  229  3485 fcloseR
;  230  3493 fcloseR
;  231  3501 exitR
;  232  3526 putch
;  233  3594 strcpy
;  234  3609 DosInt
;  235  3625 DosInt
;  236  3648 DosInt
;  237  3667 DosInt
;  238  3701 writetty
;  239  3710 writetty
;Input: AS.C, List: AS.S,  Lines:  232
;Glob. variables:  153 max.:  200
;Local variables:    3 max.:  100, in 'genInstruction'
;Functions      :   72 max.:  300
;Calls          :  240 max.: 2000, NameField: 3742 max.:    65535
;Code until     :26009 max.: 30000, free: 3991
;Data (HeapEnd) :33694, resting stacksize: 31841
;Max. Const in 'testReg' :  658 max. 3000, free: 2342