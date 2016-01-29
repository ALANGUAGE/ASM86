
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

;-2 char Version1[]="AS.C V0.07 29.1.2016";

 ret
; ENDP
Version1 db "AS.C V0.07 29.1.2016",0

;-3 #include "DECL.C"

;Use include file: DECL.C

;-1 char LIST;              // listing on/off

LIST db 0

;-2 #define SYMBOLMAX    31


;-3 char Symbol[SYMBOLMAX]; //next symbol to decode

section .bss
absolute 30000
Symbol resb 31
section .text

;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName

section .bss
absolute 30031
SymbolUpper resb 31
section .text

;-5 unsigned int SymbolInt; //integer value set in getDigit

SymbolInt dw 0

;-6 #define INPUTBUFMAX 127


;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test

section .bss
absolute 30062
InputBuf resb 127
section .text

;-8 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0

;-9 char namein [67];       //input file name  .S

section .bss
absolute 30189
namein resb 67
section .text

;-10 char namelst[67];       //list file name   .LST

section .bss
absolute 30256
namelst resb 67
section .text

;-11 char namebin[67];       //output file name .COM

section .bss
absolute 30323
namebin resb 67
section .text

;-12 int  asm_fd;            //input file descriptor

asm_fd dw 0

;-13 int lst_fd;             //list file descriptor

lst_fd dw 0

;-14 int bin_fd;             //output file descriptor

bin_fd dw 0

;-15 int DOS_ERR;            //global var

DOS_ERR dw 0

;-16 int ErrorCount;         //number of errors

ErrorCount dw 0

;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0

;-18 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0

;-19 


;-20 unsigned int PC;        //program counter, ORG nn

PC dw 0

;-21 unsigned int PCStart;   //PC at start of line by PrintLine()

PCStart dw 0

;-22 char isLabel;           //by getName()

isLabel db 0

;-23 #define DIGIT    1      //0-9


;-24 #define LETTERE  2      //a-z A-Z @ . _


;-25 #define ALNUME   3      //a-z A-Z @ . _  0-9


;-26 #define NOALNUME 4      //other char


;-27 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME

TokeType db 0

;-28 #define BYTE     1


;-29 #define WORD     2


;-30 #define DWORD    3


;-31 #define SEGREG   4


;-32 #define IMM      1      //const  ,123


;-33 #define REG      2      //       ,BX    mode=11


;-34 #define ADR      3      //VALUE  ,var1  mod=00, r/m=110


;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16


;-36 char Op1;               //0, IMM, REG, ADR, MEM

Op1 db 0

;-37 char CodeType;          //1-207 by searchSymbol(), must be byte size

CodeType db 0

;-38 char Code1;             // first  Opcode

Code1 db 0

;-39 char Code2;             // second Opcode

Code2 db 0

;-40 char Code3;             // third  Opcode

Code3 db 0

;-41 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG

RegType db 0

;-42 char RegNo;             //0 - 7 AL, CL, ...  by testReg()

RegNo db 0

;-43 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0

;-44 char wflag;             //0=byte, 1=word/dword

wflag db 0

;-45 //char AddrSize;          //67h:


;-46 //char NumOprns;          //0-2


;-47 //char dflag;             //0=source is reg,  1=dest is reg


;-48 //char modrm;           //mod, r/m


;-49 char regindexbase;      //combination of index and base reg

regindexbase db 0

;-50 char isDirect;          //is direct addressing

isDirect db 0

;-51 int disp;               //displacement      0-8 bytes

disp dw 0

;-52 int imme;               //immediate         0-8 bytes

imme dw 0

;-53 


;-54 #define OPMAXLEN 5


;-55 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 30390
OpPos resb 5
section .text

;-56 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0

;-57 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0

;-58 char PrintR;           //print 'R' if relocative

PrintR db 0

;-59 


;-60 #define LABELNAMESMAX 969//next number - 31


;-61 char LabelNames[1000];  //space for names of all labels

section .bss
absolute 30395
LabelNames resb 1000
section .text

;-62 char *LabelNamePtr;     // first free position

LabelNamePtr dw 0

;-63 #define LABELADRMAX 100


;-64 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 31395
LabelAddr resw 100
section .text

;-65 int LabelMaxIx=0;       //actual number of stored labels

LabelMaxIx dw 0

;-66 int LabelIx;            //actual number of just searched label

LabelIx dw 0

;-67 


;-68 #define FILEBINMAX 1990 //next number - max. oplemgth


;-69 char FileBin  [2000];   //output binary file

section .bss
absolute 31595
FileBin resb 2000
section .text

;-70 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-71 


;-72 char *arglen=0x80;      // for main only

arglen dw 128

;-73 char *argv=0x82;        // for main only

argv dw 130
;Back to main program: AS.C

;-4 #include "OPTABL.C"

;Use include file: OPTABL.C

;-1 char I_START=0xF1;

I_START db 241

;-2 //OpName, 0, CodeType, OpCode1-n, F1h


;-3 //  1:   1 byte opcode


;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241

;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};

I_POPA db 80,79,80,65,0,1,97,241

;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};

I_NOP db 78,79,80,0,1,144,241

;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};

I_CBW db 67,66,87,0,1,152,241

;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};

I_CWDE db 67,87,68,69,0,1,152,241

;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};

I_CWD db 67,87,68,0,1,153,241

;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};

I_CDQ db 67,68,81,0,1,153,241

;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};

I_WAIT db 87,65,73,84,0,1,155,241

;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241

;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};

I_POPF db 80,79,80,70,0,1,157,241

;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};

I_SAHF db 83,65,72,70,0,1,158,241

;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};

I_LAHF db 76,65,72,70,0,1,159,241

;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241

;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};

I_MOVSW db 77,79,86,83,87,0,1,165,241

;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241

;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};

I_CMPSW db 67,77,80,83,87,0,1,167,241

;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241

;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};

I_STOSW db 83,84,79,83,87,0,1,171,241

;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241

;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};

I_LODSW db 76,79,68,83,87,0,1,173,241

;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241

;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};

I_SCASW db 83,67,65,83,87,0,1,175,241

;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241

;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};

I_IRET db 73,82,69,84,0,1,207,241

;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};

I_XLAT db 88,76,65,84,0,1,215,241

;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};

I_LOCK db 76,79,67,75,0,1,240,241

;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241

;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};

I_REPNZ db 82,69,80,78,90,0,1,242,241

;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};

I_REPE db 82,69,80,69,0,1,243,241

;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};

I_REPZ db 82,69,80,90,0,1,243,241

;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};

I_HLT db 72,76,84,0,1,244,241

;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry

I_CLC db 67,76,67,0,1,248,241

;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry

I_STC db 83,84,67,0,1,249,241

;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt

I_CLI db 67,76,73,0,1,250,241

;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt

I_STI db 83,84,73,0,1,251,241

;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction

I_CLD db 67,76,68,0,1,252,241

;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction

I_STD db 83,84,68,0,1,253,241

;-41 // 52: mem reg 16 bit


;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-50 //  3: les, lda, lea


;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16

I_LES db 76,69,83,0,3,196,241

;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16

I_LDS db 76,68,83,0,3,197,241

;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16

I_LEA db 76,69,65,0,3,141,241

;-54 //  4: acc,imm  reg,imm  index,reg


;-55 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-56 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-57 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-58 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-59 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-60 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-61 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-62 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-63 //  5: mov


;-64 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-65 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,5,190,241

;-66 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,5,182,241

;-67 //  6: single byte relative jump


;-68 char I_JO []=  {'J','O',0,              6, 0,     0xF1};

I_JO db 74,79,0,6,0,241

;-69 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};

I_JNO db 74,78,79,0,6,1,241

;-70 char I_JB []=  {'J','B',0,              6, 2,     0xF1};

I_JB db 74,66,0,6,2,241

;-71 char I_JC []=  {'J','C',0,              6, 2,     0xF1};

I_JC db 74,67,0,6,2,241

;-72 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};

I_JNB db 74,78,66,0,6,3,241

;-73 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};

I_JAE db 74,65,69,0,6,3,241

;-74 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};

I_JNC db 74,78,67,0,6,3,241

;-75 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel

I_JE db 74,69,0,6,4,241

;-76 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r

I_JZ db 74,90,0,6,4,241

;-77 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};

I_JNE db 74,78,69,0,6,5,241

;-78 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};

I_JNZ db 74,78,90,0,6,5,241

;-79 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};

I_JBE db 74,66,69,0,6,6,241

;-80 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};

I_JNA db 74,78,65,0,6,6,241

;-81 char I_JA []=  {'J','A',0,              6, 7,     0xF1};

I_JA db 74,65,0,6,7,241

;-82 char I_JS []=  {'J','S',0,              6, 8,     0xF1};

I_JS db 74,83,0,6,8,241

;-83 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};

I_JNS db 74,78,83,0,6,9,241

;-84 char I_JP []=  {'J','P',0,              6,10,     0xF1};

I_JP db 74,80,0,6,10,241

;-85 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};

I_JPE db 74,80,69,0,6,10,241

;-86 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};

I_JNP db 74,78,80,0,6,11,241

;-87 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};

I_JPO db 74,80,79,0,6,11,241

;-88 char I_JL []=  {'J','L',0,              6,12,     0xF1};

I_JL db 74,76,0,6,12,241

;-89 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};

I_JNL db 74,78,76,0,6,13,241

;-90 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};

I_JGE db 74,71,69,0,6,13,241

;-91 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};

I_JLE db 74,76,69,0,6,14,241

;-92 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};

I_JNG db 74,78,71,0,6,14,241

;-93 char I_JG []=  {'J','G',0,              6,15,     0xF1};

I_JG db 74,71,0,6,15,241

;-94 //  7: jmp, call


;-95 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-96 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-97 //  8: ret


;-98 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-99 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-100 //  9: seg, r/m


;-101 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,241

;-102 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16

I_POP db 80,79,80,0,9,88,241

;-103 //  11: shift, rotates


;-104 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};

I_ROL db 82,79,76,0,11,0,241

;-105 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};

I_ROR db 82,79,82,0,11,1,241

;-106 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};

I_RCL db 82,67,76,0,11,2,241

;-107 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};

I_RCR db 82,67,82,0,11,3,241

;-108 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};

I_SHL db 83,72,76,0,11,4,241

;-109 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};

I_SAL db 83,65,76,0,11,5,241

;-110 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};

I_SHR db 83,72,82,0,11,6,241

;-111 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};

I_SAR db 83,65,82,0,11,7,241

;-112 //  12: int


;-113 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-114 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};

I_INTO db 73,78,84,79,0,12,206,241

;-115 //  14: in/out


;-116 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-117 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-118 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-119 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-120 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-121 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-122 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-123 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-124 //  15: xchg


;-125 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-126 //  16: loop, jcxz


;-127 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-128 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-129 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-130 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-131 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-132 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-133 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-134 //  30: enter


;-135 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};

I_ENTER db 69,78,84,69,82,0,30,200,241

;-136 // 100: directives


;-137 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-138 // section, segment .TEXT .DATA .BSS


;-139 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-140 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-141 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-142 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-143 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-144 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-145 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};

I_RESB db 82,69,83,66,0,205,241

;-146 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};

I_RESW db 82,69,83,87,0,206,241

;-147 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};

I_RESD db 82,69,83,68,0,207,241

;-148 char I_END=0;// end of table char

I_END db 0
;Back to main program: AS.C

;-5 


;-6 int process() {


process:  ; *** PROC ***

;-7   getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-8   OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-9   getCodes();//set: Code1, Code2, Code3

 call getCodes

;-10 


;-11   if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne @@process1

;-12     genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-13     return;

 jmp @@retn

;-14   }


;-15   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

@@process1:
 mov al, [CodeType]
 cmp al, 2
 jne @@process2

;-16     checkLeftOp();

 call checkLeftOp

;-17       if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  @@process3

;-18     	if (Op1 == REG) {

 mov al, [Op1]
 cmp al, 2
 jne @@process4

;-19         if (RegType == WORD) {genCode(Code3, RegNo); return; }//short

 mov al, [RegType]
 cmp al, 2
 jne @@process5
 mov al, byte [RegNo]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode
 add  sp, 4
 jmp @@retn

;-20         if (RegType ==DWORD) {genCode(Code3, RegNo); return; }

@@process5:
 mov al, [RegType]
 cmp al, 3
 jne @@process6
 mov al, byte [RegNo]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode
 add  sp, 4
 jmp @@retn

;-21         }

@@process6:

;-22       }

@@process4:

;-23       if (Code2 == 5) {//imul extension?

@@process3:
 mov al, [Code2]
 cmp al, 5
 jne @@process7

;-24         getTokeType();

 call getTokeType

;-25         if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je @@process8
 call implerror

;-26       }

@@process8:

;-27       genCode(Code1, wflag);

@@process7:
 mov al, byte [wflag]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode
 add  sp, 4

;-28       writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-29       return;

 jmp @@retn

;-30   }


;-31  


;-32   if (CodeType ==  8) {//ret,retf

@@process2:
 mov al, [CodeType]
 cmp al, 8
 jne @@process9

;-33     if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne @@process10

;-34       genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-35       genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-36       return;

 jmp @@retn

;-37     }


;-38     genCode8(Code1); 

@@process10:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-39     return;

 jmp @@retn

;-40   }


;-41 


;-42   if (CodeType==101) {// ORG nn

@@process9:
 mov al, [CodeType]
 cmp al, 101
 jne @@process11

;-43     if (TokeType != DIGIT) error1("only digit allowed");

 mov al, [TokeType]
 cmp al, 1
 je  @@process12
 push process_0
 call error1
 add  sp, 2

;-44     PC=SymbolInt;return;

@@process12:
 mov ax, [SymbolInt]
 mov word [PC], ax
 jmp @@retn

;-45   }


;-46   error1("unknown CodeType");

@@process11:
 push process_1
 call error1
 add  sp, 2

;-47 }


;-48 


;-49 int setwflag() {//only Op1 (first operand)

@@retn:
 ret
; ENDP
process_0 db "only digit allowed",0
process_1 db "unknown CodeType",0

setwflag:  ; *** PROC ***

;-50   wflag=0;

 mov eax, 0
 mov byte [wflag], al

;-51   if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne @@setwflag13

;-52     if (Op1 == REG) {

 mov al, [Op1]
 cmp al, 2
 jne @@setwflag14

;-53       OpSize=RegType;

 mov al, [RegType]
 mov byte [OpSize], al

;-54       if (RegType == SEGREG) OpSize=WORD;

 mov al, [RegType]
 cmp al, 4
 jne @@setwflag15
 mov eax, 2
 mov byte [OpSize], al

;-55     }

@@setwflag15:

;-56   }

@@setwflag14:

;-57   if (OpSize  == DWORD) {gen66h(); wflag=1;}

@@setwflag13:
 mov al, [OpSize]
 cmp al, 3
 jne @@setwflag16
 call gen66h
 mov eax, 1
 mov byte [wflag], al

;-58   if (OpSize  ==  WORD) wflag=1;

@@setwflag16:
 mov al, [OpSize]
 cmp al, 2
 jne @@setwflag17
 mov eax, 1
 mov byte [wflag], al

;-59 }

@@setwflag17:

;-60 


;-61 int Check2Op(char left, char rigth) {

 ret
; ENDP

Check2Op:  ; *** PROC ***

;-62 }

;Function : Check2Op, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte    61 NULL bp+4    left
;  201 var sign byte    61 NULL bp+6    rigth;
 ENTER  0,0

;-63 int checkLeftOp() {
 LEAVE
 ret
; ENDP

checkLeftOp:  ; *** PROC ***

;-64   getOp();

 call getOp

;-65   if (Op1 == ADR) implerror();

 mov al, [Op1]
 cmp al, 3
 jne @@checkLeftOp18
 call implerror

;-66   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop

@@checkLeftOp18:
 mov al, [RegType]
 cmp al, 4
 jne @@checkLeftOp19
 call segregerror
 jmp @@retn

;-67   setwflag();

@@checkLeftOp19:
 call setwflag

;-68   if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne @@checkLeftOp20
 push checkLeftOp_0
 call error1
 add  sp, 2

;-69   if (OpSize == RegType) return;

@@checkLeftOp20:
 mov al, [OpSize]
 cmp al, [RegType]
 jne @@checkLeftOp21
 jmp @@retn

;-70   if (OpSize){if (Op1 == MEM) return;

@@checkLeftOp21:
 mov al, [OpSize]
 or  al, al
 je @@checkLeftOp22
 mov al, [Op1]
 cmp al, 4
 jne @@checkLeftOp23
 jmp @@retn

;-71     error1("Conflict OpSize and RegSize"); }

@@checkLeftOp23:
 push checkLeftOp_1
 call error1
 add  sp, 2

;-72   if (RegType==0) error1("no register defined");

@@checkLeftOp22:
 mov al, [RegType]
 cmp al, 0
 jne @@checkLeftOp24
 push checkLeftOp_2
 call error1
 add  sp, 2

;-73 }

@@checkLeftOp24:

;-74 


;-75 int saveLeftOp(){

@@retn:
 ret
; ENDP
checkLeftOp_0 db "no op size declared",0
checkLeftOp_1 db "Conflict OpSize and RegSize",0
checkLeftOp_2 db "no register defined",0

saveLeftOp:  ; *** PROC ***

;-76 }


;-77 int checkRightOp(char mode){

 ret
; ENDP

checkRightOp:  ; *** PROC ***

;-78 }

;Function : checkRightOp, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    77 NULL bp+4    mode;
 ENTER  0,0

;-79 /*        Op      = 0, IMM, REG, ADR, MEM


;-80 IMM       imme    = 0, SymbolInt    


;-81 REG     R RegNo   = 0 - 7


;-82 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 


;-83 MEM,ADR   disp    = 0,LabelAddr[LabelIx]


;-84 MEM       regindexbase = 0 - 7


;-85 


;-86           OpSize  = 0, BYTE, WORD, DWORD (set wflag)


;-87 */


;-88 int getOp() {
 LEAVE
 ret
; ENDP

getOp:  ; *** PROC ***

;-89 //set: op1=0,IMM,REG,ADR,MEM


;-90   disp=0; imme=0; regindexbase=0; isDirect=1;

 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov word [imme], ax
 mov eax, 0
 mov byte [regindexbase], al
 mov eax, 1
 mov byte [isDirect], al

;-91 


;-92   Op1=getOp1();

 call getOp1
 mov byte [Op1], al

;-93   if (isToken('[')) {Op1 = MEM; getMEM();  return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je @@getOp25
 mov eax, 4
 mov byte [Op1], al
 call getMEM
 jmp @@retn

;-94   if (Op1 == 0) error1("Name of operand expected");

@@getOp25:
 mov al, [Op1]
 cmp al, 0
 jne @@getOp26
 push getOp_0
 call error1
 add  sp, 2

;-95   if (Op1 == IMM) {imme=SymbolInt;         return;}

@@getOp26:
 mov al, [Op1]
 cmp al, 1
 jne @@getOp27
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp @@retn

;-96   if (Op1 == REG)                          return;

@@getOp27:
 mov al, [Op1]
 cmp al, 2
 jne @@getOp28
 jmp @@retn

;-97   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;}

@@getOp28:
 mov al, [Op1]
 cmp al, 3
 jne @@getOp29
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp @@retn

;-98   error1("Name of operand expected #1");

@@getOp29:
 push getOp_1
 call error1
 add  sp, 2

;-99 }


;-100 


;-101 int getOp1() {//scan for a single operand

@@retn:
 ret
; ENDP
getOp_0 db "Name of operand expected",0
getOp_1 db "Name of operand expected #1",0

getOp1:  ; *** PROC ***

;-102 //return:0, IMM, REG, ADR (not MEM)


;-103 //set   :RegType, RegNo by testReg


;-104 //set   :LabelIx by searchLabel


;-105   if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne @@getOp130
 mov eax, 0
 jmp @@retn

;-106   if (TokeType == DIGIT)  return IMM;

@@getOp130:
 mov al, [TokeType]
 cmp al, 1
 jne @@getOp131
 mov eax, 1
 jmp @@retn

;-107   if (TokeType == ALNUME) {

@@getOp131:
 mov al, [TokeType]
 cmp al, 3
 jne @@getOp132

;-108     RegNo=testReg();

 call testReg
 mov byte [RegNo], al

;-109     if (RegType)          return REG;

 mov al, [RegType]
 or  al, al
 je @@getOp133
 mov eax, 2
 jmp @@retn

;-110     LabelIx=searchLabel();

@@getOp133:
 call searchLabel
 mov word [LabelIx], ax

;-111     if (LabelIx)          return ADR;

 mov ax, [LabelIx]
 or  al, al
 je @@getOp134
 mov eax, 3
 jmp @@retn

;-112     else error1("variable not found"); 

 jmp @@getOp135
@@getOp134:
 push getOp1_0
 call error1
 add  sp, 2

;-113   }

@@getOp135:

;-114   return 0;

@@getOp132:
 mov eax, 0
 jmp @@retn

;-115 }


;-116 


;-117 int getMEM() {// e.g. [array+bp+si-4]

@@retn:
 ret
; ENDP
getOp1_0 db "variable not found",0

getMEM:  ; *** PROC ***

;-118 //set: disp, regindexbase, RegType


;-119   char op2;


;-120   disp=0; regindexbase=0; RegType=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   119 NULL bp-2    op2;
 ENTER  2,0
 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov byte [regindexbase], al
 mov eax, 0
 mov byte [RegType], al

;-121   do {

@@getMEM36:

;-122     getTokeType();

 call getTokeType

;-123     op2=getOp1();

 call getOp1
 mov byte [bp-2], al

;-124     if (op2 ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne @@getMEM37
 call syntaxerror

;-125     if (op2 == REG) {isDirect=0;

@@getMEM37:
 mov al, [bp-2]
 cmp al, 2
 jne @@getMEM38
 mov eax, 0
 mov byte [isDirect], al

;-126                       if (regindexbase) regindexbase=getIndReg2();

 mov al, [regindexbase]
 or  al, al
 je @@getMEM39
 call getIndReg2
 mov byte [regindexbase], al

;-127                       else getIndReg1();

 jmp @@getMEM40
@@getMEM39:
 call getIndReg1

;-128                     }

@@getMEM40:

;-129     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];

@@getMEM38:
 mov al, [bp-2]
 cmp al, 3
 jne @@getMEM41
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-130     if (op2 == IMM) disp=disp+SymbolInt;

@@getMEM41:
 mov al, [bp-2]
 cmp al, 1
 jne @@getMEM42
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-131     if (isToken('-')) {

@@getMEM42:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM43

;-132       getTokeType();

 call getTokeType

;-133       if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  @@getMEM44
 call numbererror

;-134       disp = disp - SymbolInt;

@@getMEM44:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-135     }


;-136   } while (isToken('+'));

@@getMEM43:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM45
 jmp @@getMEM36
@@getMEM45:

;-137   if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne @@getMEM46
 push getMEM_0
 call errorexit
 add  sp, 2

;-138 }

@@getMEM46:

;-139 int getIndReg1() {
 LEAVE
 ret
; ENDP
getMEM_0 db "] expected",0

getIndReg1:  ; *** PROC ***

;-140   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg147
 call indexerror

;-141   if (RegNo==3) regindexbase=7;//BX

@@getIndReg147:
 mov al, [RegNo]
 cmp al, 3
 jne @@getIndReg148
 mov eax, 7
 mov byte [regindexbase], al

;-142   if (RegNo==5) regindexbase=6;//BP, change to BP+0

@@getIndReg148:
 mov al, [RegNo]
 cmp al, 5
 jne @@getIndReg149
 mov eax, 6
 mov byte [regindexbase], al

;-143   if (RegNo==7) regindexbase=5;//DI

@@getIndReg149:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg150
 mov eax, 5
 mov byte [regindexbase], al

;-144   if (RegNo==6) regindexbase=4;//SI

@@getIndReg150:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg151
 mov eax, 4
 mov byte [regindexbase], al

;-145   if (regindexbase==0) indexerror();

@@getIndReg151:
 mov al, [regindexbase]
 cmp al, 0
 jne @@getIndReg152
 call indexerror

;-146 }

@@getIndReg152:

;-147 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
; ENDP

getIndReg2:  ; *** PROC ***
;Function : getIndReg2, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   147 NULL bp-2    m;
 ENTER  2,0
 mov eax, 4
 mov byte [bp-2], al

;-148   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg253
 call indexerror

;-149   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI

@@getIndReg253:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg254
 mov al, [regindexbase]
 cmp al, 6
 jne @@getIndReg255
 mov eax, 3
 mov byte [bp-2], al

;-150            else if (regindexbase==7) m=1;//BX+DI

 jmp @@getIndReg256
@@getIndReg255:
 mov al, [regindexbase]
 cmp al, 7
 jne @@getIndReg257
 mov eax, 1
 mov byte [bp-2], al

;-151   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI

@@getIndReg257:
@@getIndReg256:
@@getIndReg254:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg258
 mov al, [regindexbase]
 cmp al, 6
 jne @@getIndReg259
 mov eax, 2
 mov byte [bp-2], al

;-152            else if (regindexbase==7) m=0;//BX+SI

 jmp @@getIndReg260
@@getIndReg259:
 mov al, [regindexbase]
 cmp al, 7
 jne @@getIndReg261
 mov eax, 0
 mov byte [bp-2], al

;-153   if (m > 3) indexerror();

@@getIndReg261:
@@getIndReg260:
@@getIndReg258:
 mov al, [bp-2]
 cmp al, 3
 jle @@getIndReg262
 call indexerror

;-154   return m;

@@getIndReg262:
 mov al, [bp-2]
 jmp @@retn

;-155 }


;-156 


;-157 // generate code ........................................


;-158 int getCodes() {

@@retn: LEAVE
 ret
; ENDP

getCodes:  ; *** PROC ***

;-159   OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-160   OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-161   OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-162 }


;-163 int gen66h() {genCode8(0x66);

 ret
; ENDP

gen66h:  ; *** PROC ***
 push 102
 call genCode8
 add  sp, 2

;-164 }


;-165 int genCode(char c, char d) {

 ret
; ENDP

genCode:  ; *** PROC ***

;-166     c = c + d;

;Function : genCode, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   165 NULL bp+4    c
;  201 var sign byte   165 NULL bp+6    d;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov byte [bp+4], al

;-167     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-168 }


;-169 int genCode8(char c) {
 LEAVE
 ret
; ENDP

genCode8:  ; *** PROC ***

;-170 //set: BinLen++, OpPrintIndex++


;-171   FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   169 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-172   BinLen++;

 inc  word [BinLen]

;-173   PC++;

 inc  word [PC]

;-174   if (OpPrintIndex < OPMAXLEN) {

 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode863

;-175     OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-176     OpPrintIndex++;

 inc  word [OpPrintIndex]

;-177   }


;-178 }

@@genCode863:

;-179 int genCode16(int i) {
 LEAVE
 ret
; ENDP

genCode16:  ; *** PROC ***

;-180   genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   179 NULL bp+4    i;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov word [bp+4], ax

;-181   genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-182 }


;-183 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
 LEAVE
 ret
; ENDP

writeEA:  ; *** PROC ***

;-184 //mod-byte: mode76, reg/opcode543, r/m210    


;-185   char len;


;-186   len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   183 NULL bp+4    xxx
;  201 var sign byte   185 NULL bp-2    len;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-187 //  prs("\nxxx:"); printhex8a(xxx);


;-188   xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov byte [bp+4], al

;-189   if (Op1 ==   0) addrexit();

 mov al, [Op1]
 cmp al, 0
 jne @@writeEA64
 call addrexit

;-190   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 

@@writeEA64:
 mov al, [Op1]
 cmp al, 2
 jne @@writeEA65
 or  byte [bp+4], 192
 mov al, [bp+4]
 add al, [RegNo]
 mov byte [bp+4], al

;-191   if (Op1 == ADR) error1("writeEA");           

@@writeEA65:
 mov al, [Op1]
 cmp al, 3
 jne @@writeEA66
 push writeEA_0
 call error1
 add  sp, 2

;-192   if (Op1 == MEM) {

@@writeEA66:
 mov al, [Op1]
 cmp al, 4
 jne @@writeEA67

;-193     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@writeEA68

;-194         xxx |= 6;

 or  byte [bp+4], 6

;-195         len = 2;

 mov eax, 2
 mov byte [bp-2], al

;-196     }


;-197     else { 

 jmp @@writeEA69
@@writeEA68:

;-198       xxx = xxx + regindexbase;   

 mov al, [bp+4]
 add al, [regindexbase]
 mov byte [bp+4], al

;-199       if (regindexbase == 6) {//make [BP+00]

 mov al, [regindexbase]
 cmp al, 6
 jne @@writeEA70

;-200         len=1;

 mov eax, 1
 mov byte [bp-2], al

;-201         if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne @@writeEA71
 or  byte [bp+4], 64

;-202       }

@@writeEA71:

;-203 


;-204       if (disp) {

@@writeEA70:
 mov ax, [disp]
 or  al, al
 je @@writeEA72

;-205         ax = disp;

 mov  ax, [disp]

;-206         if(ax > 127) len=2;

 cmp  ax, 127
 jle @@writeEA73
 mov eax, 2
 mov byte [bp-2], al

;-207         else len=1;

 jmp @@writeEA74
@@writeEA73:
 mov eax, 1
 mov byte [bp-2], al

;-208         if (len == 1) xxx |= 0x40;

@@writeEA74:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA75
 or  byte [bp+4], 64

;-209         else xxx |= 0x80;

 jmp @@writeEA76
@@writeEA75:
 or  byte [bp+4], 128

;-210       }

@@writeEA76:

;-211     }

@@writeEA72:

;-212   }

@@writeEA69:

;-213   genCode8(xxx);// gen second byte

@@writeEA67:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-214   if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA77
 push word [disp]
 call genCode8
 add  sp, 2

;-215   if (len == 2) genCode16(disp);

@@writeEA77:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA78
 push word [disp]
 call genCode16
 add  sp, 2

;-216 }

@@writeEA78:

;-217 


;-218 #include "PARSE.C"
 LEAVE
 ret
; ENDP
writeEA_0 db "writeEA",0
;Use include file: PARSE.C

;-1 int parse() {


parse:  ; *** PROC ***

;-2   LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-3   do {

@@parse79:

;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';

 mov ax, [PC]
 mov word [PCStart], ax
 mov eax, 0
 mov byte [OpSize], al
 mov eax, 0
 mov word [OpPrintIndex], ax
 mov eax, 32
 mov byte [PrintR], al

;-5     getLine();

 call getLine

;-6     InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-8     if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@parse80

;-9       if (isLabel) { //set in getName

 mov al, [isLabel]
 or  al, al
 je @@parse81

;-10         storeLabel();

 call storeLabel

;-11         InputPtr++;//remove :

 inc  word [InputPtr]

;-12         getTokeType();

 call getTokeType

;-13       }


;-14     }

@@parse81:

;-15     if (TokeType == ALNUME) {

@@parse80:
 mov al, [TokeType]
 cmp al, 3
 jne @@parse82

;-16       lookCode();// and OpCodePtr

 call lookCode

;-17       if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je @@parse83
 call process

;-18       else getVariable();

 jmp @@parse84
@@parse83:
 call getVariable

;-19       skipRest();

@@parse84:
 call skipRest

;-20     }


;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp @@parse85
@@parse82:
 mov al, [TokeType]
 cmp al, 3
 jle @@parse86
 push parse_0
 call error1
 add  sp, 2

;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");

 jmp @@parse87
@@parse86:
 mov al, [TokeType]
 cmp al, 1
 jne @@parse88
 push parse_1
 call error1
 add  sp, 2

;-23     printLine();

@@parse88:
@@parse87:
@@parse85:
 call printLine

;-24   } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  @@parse89
 jmp @@parse79
@@parse89:

;-25 }


;-26 // scan code .....................................


;-27 int getTokeType() { char c;

 ret
; ENDP
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed @ start of line",0

getTokeType:  ; *** PROC ***

;-28   skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    27 NULL bp-2    c;
 ENTER  2,0
 call skipBlank

;-29   c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne @@getTokeType90
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-31   if (c == ';') {TokeType=0; return; }//comment

@@getTokeType90:
 mov al, [bp-2]
 cmp al, 59
 jne @@getTokeType91
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

@@getTokeType91:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getTokeType92
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov eax, 1
 mov byte [TokeType], al
 jmp @@retn

;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

@@getTokeType92:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@getTokeType93
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov eax, 3
 mov byte [TokeType], al
 jmp @@retn

;-34   TokeType=NOALNUME; return;

@@getTokeType93:
 mov eax, 4
 mov byte [TokeType], al
 jmp @@retn

;-35 }


;-36 int storeLabel() {

@@retn: LEAVE
 ret
; ENDP

storeLabel:  ; *** PROC ***

;-37   if(searchLabel()) error1("duplicate label");

 call searchLabel
 or  al, al
 je @@storeLabel94
 push storeLabel_0
 call error1
 add  sp, 2

;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);

@@storeLabel94:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-39   LabelNamePtr++;

 inc  word [LabelNamePtr]

;-40   LabelMaxIx++;

 inc  word [LabelMaxIx]

;-41   LabelAddr[LabelMaxIx] = PC;

 mov ax, [PC]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-42 }


;-43 int searchLabel() {

 ret
; ENDP
storeLabel_0 db "duplicate label",0

searchLabel:  ; *** PROC ***

;-44   int LIx; char *p; int j;


;-45   p = &LabelNames;

;Function : searchLabel, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word    44 NULL bp-2    LIx
;  201 ptr sign byte    44 NULL bp-4    p
;  202 var sign word    44 NULL bp-6    j;
 ENTER  6,0
 mov ax, LabelNames
 mov word [bp-4], ax

;-46   LIx=1;

 mov eax, 1
 mov word [bp-2], ax

;-47   while (LIx <= LabelMaxIx) {

@@searchLabel95:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel96

;-48     if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel97
 mov ax, [bp-2]
 jmp @@retn

;-49     j=strlen(p);

@@searchLabel97:
 push word [bp-4]
 call strlen
 add  sp, 2
 mov word [bp-6], ax

;-50     p=p+j; p++; LIx++;

 mov ax, [bp-4]
 add ax, [bp-6]
 mov word [bp-4], ax
 inc  word [bp-4]
 inc  word [bp-2]

;-51   }


;-52   return 0;

 jmp @@searchLabel95
@@searchLabel96:
 mov eax, 0
 jmp @@retn

;-53 }


;-54 int getVariable() { char c;

@@retn: LEAVE
 ret
; ENDP

getVariable:  ; *** PROC ***

;-55   storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    54 NULL bp-2    c;
 ENTER  2,0
 call storeLabel

;-56   getTokeType(); if(TokeType==ALNUME) {// getName

 call getTokeType
 mov al, [TokeType]
 cmp al, 3
 jne @@getVariable98

;-57     lookCode();

 call lookCode

;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");

 mov al, [CodeType]
 cmp al, 200
 jge @@getVariable99
 push getVariable_0
 call errorexit
 add  sp, 2

;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");

@@getVariable99:
 mov al, [CodeType]
 cmp al, 207
 jle @@getVariable100
 push getVariable_1
 call errorexit
 add  sp, 2

;-60     if (CodeType== 200) {// DB

@@getVariable100:
 mov al, [CodeType]
 cmp al, 200
 jne @@getVariable101

;-61       do { getTokeType();

@@getVariable102:
 call getTokeType

;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable103
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-63         else {

 jmp @@getVariable104
@@getVariable103:

;-64           skipBlank();

 call skipBlank

;-65           if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable105

;-66             do { c= *InputPtr;

@@getVariable106:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-67               genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-68               InputPtr++;

 inc  word [InputPtr]

;-69             } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  @@getVariable107
 jmp @@getVariable106
@@getVariable107:

;-70             InputPtr++;

 inc  word [InputPtr]

;-71           }


;-72         }

@@getVariable105:

;-73       } while (isToken(','));

@@getVariable104:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable108
 jmp @@getVariable102
@@getVariable108:

;-74     }


;-75     if (CodeType== 201) {// DW

@@getVariable101:
 mov al, [CodeType]
 cmp al, 201
 jne @@getVariable109

;-76       do { getTokeType();

@@getVariable110:
 call getTokeType

;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable111
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-78       } while (isToken(','));

@@getVariable111:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable112
 jmp @@getVariable110
@@getVariable112:

;-79     }


;-80   }

@@getVariable109:

;-81   else errorexit("DB,DW,DD or RESB,W,D expected");

 jmp @@getVariable113
@@getVariable98:
 push getVariable_2
 call errorexit
 add  sp, 2

;-82 }

@@getVariable113:

;-83 int lookCode() { // ret: CodeType, *OpCodePtr
 LEAVE
 ret
; ENDP
getVariable_0 db "D or RES B,W,D expected",0
getVariable_1 db "D or RES B,W,D expected",0
getVariable_2 db "DB,DW,DD or RESB,W,D expected",0

lookCode:  ; *** PROC ***

;-84   CodeType=0;

 mov eax, 0
 mov byte [CodeType], al

;-85   OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-86   OpCodePtr++;

 inc  word [OpCodePtr]

;-87   do  {

@@lookCode114:

;-88     if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode115

;-89       while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode116:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode117
 inc  word [OpCodePtr]

;-90       OpCodePtr++; CodeType =*OpCodePtr;

 jmp @@lookCode116
@@lookCode117:
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-91       return;

 jmp @@retn

;-92     }


;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode115:
@@lookCode118:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode119
 inc  word [OpCodePtr]

;-94   OpCodePtr++;

 jmp @@lookCode118
@@lookCode119:
 inc  word [OpCodePtr]

;-95   } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode120
 jmp @@lookCode114
@@lookCode120:

;-96 }


;-97 int getCodeSize() {

@@retn:
 ret
; ENDP

getCodeSize:  ; *** PROC ***

;-98   if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@getCodeSize121

;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize122
 call getTokeType
 mov eax, 1
 jmp @@retn

;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

@@getCodeSize122:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize123
 call getTokeType
 mov eax, 2
 jmp @@retn

;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

@@getCodeSize123:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize124
 call getTokeType
 mov eax, 3
 jmp @@retn

;-102   } return 0;

@@getCodeSize124:
@@getCodeSize121:
 mov eax, 0
 jmp @@retn

;-103 }


;-104 int isToken(char c) {

@@retn:
 ret
; ENDP
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0

isToken:  ; *** PROC ***

;-105   skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   104 NULL bp+4    c;
 ENTER  0,0
 call skipBlank

;-106   if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne @@isToken125

;-107     InputPtr++; return 1;} return 0;

 inc  word [InputPtr]
 mov eax, 1
 jmp @@retn
@@isToken125:
 mov eax, 0
 jmp @@retn

;-108 }


;-109 int skipRest() {

@@retn: LEAVE
 ret
; ENDP

skipRest:  ; *** PROC ***

;-110   getTokeType(); 

 call getTokeType

;-111   if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je @@skipRest126
 push skipRest_0
 call error1
 add  sp, 2

;-112 }

@@skipRest126:
 ret
; ENDP
skipRest_0 db "extra char ignored",0
;Back to main program: AS.C

;-219 #include "HELPER.C"

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

@@getLine127:

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
 je @@getLine128
 push getLine_0
 call errorexit
 add  sp, 2

;-7     if (DOS_NoBytes == 0) return;

@@getLine128:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne @@getLine129
 jmp @@retn

;-8     *InputPtr = DOS_ByteRead;

@@getLine129:
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
 jne @@getLine130
 jmp @@getLine127
@@getLine130:

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
 jne @@ifEOL131
 mov eax, 1
 jmp @@retn

;-16   if (c == 13) {

@@ifEOL131:
 mov al, [bp+4]
 cmp al, 13
 jne @@ifEOL132

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

@@ifEOL132:
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
 jne @@skipBlank133
 inc  word [InputPtr]
 jmp @@skipblank1

;-24     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

@@skipBlank133:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne @@skipBlank134
 inc  word [InputPtr]
 jmp @@skipblank1

;-25 }

@@skipBlank134:

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
 jne @@letterE135
 mov eax, 1
 jmp @@retn

;-28   if (c=='.') return 1;

@@letterE135:
 mov al, [bp+4]
 cmp al, 46
 jne @@letterE136
 mov eax, 1
 jmp @@retn

;-29   if (c=='?') return 1;

@@letterE136:
 mov al, [bp+4]
 cmp al, 63
 jne @@letterE137
 mov eax, 1
 jmp @@retn

;-30   if (c=='$') return 1;

@@letterE137:
 mov al, [bp+4]
 cmp al, 36
 jne @@letterE138
 mov eax, 1
 jmp @@retn

;-31   if (c> 'z') return 0;

@@letterE138:
 mov al, [bp+4]
 cmp al, 122
 jle @@letterE139
 mov eax, 0
 jmp @@retn

;-32   if (c< '@') return 0; // at included

@@letterE139:
 mov al, [bp+4]
 cmp al, 64
 jge @@letterE140
 mov eax, 0
 jmp @@retn

;-33   if (c> 'Z') { if (c< 'a') return 0; }

@@letterE140:
 mov al, [bp+4]
 cmp al, 90
 jle @@letterE141
 mov al, [bp+4]
 cmp al, 97
 jge @@letterE142
 mov eax, 0
 jmp @@retn
@@letterE142:

;-34   return 1;

@@letterE141:
 mov eax, 1
 jmp @@retn

;-35 }


;-36 int alnumE(char c) {

@@retn: LEAVE
 ret
; ENDP

alnumE:  ; *** PROC ***

;-37   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    36 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@alnumE143
 mov eax, 1
 jmp @@retn

;-38   if (letterE(c)) return 1;

@@alnumE143:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@alnumE144
 mov eax, 1
 jmp @@retn

;-39   return 0;

@@alnumE144:
 mov eax, 0
 jmp @@retn

;-40 }


;-41 int getDigit(unsigned char c) {//ret: SymbolInt

@@retn: LEAVE
 ret
; ENDP

getDigit:  ; *** PROC ***

;-42   unsigned int CastInt;


;-43   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    41 NULL bp+4    c
;  201 var unsg word    42 NULL bp-2    CastInt;
 ENTER  2,0
 mov eax, 0
 mov word [SymbolInt], ax

;-44   do {

@@getDigit145:

;-45     c-='0';

 sub  byte [bp+4], 48

;-46     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov ebx, 10
 mul ebx
 mov word [SymbolInt], ax

;-47     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov word [bp-2], ax

;-48     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-49     InputPtr++;

 inc  word [InputPtr]

;-50     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-51   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getDigit146
 jmp @@getDigit145
@@getDigit146:

;-52 }


;-53 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
; ENDP

getName:  ; *** PROC ***

;-54   char *p;


;-55   p = &Symbol;

;Function : getName, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    53 NULL bp+4    c
;  201 ptr sign byte    54 NULL bp-2    p;
 ENTER  2,0
 mov ax, Symbol
 mov word [bp-2], ax

;-56   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-57   p++;

 inc  word [bp-2]

;-58   while (alnumE(c)) {

@@getName147:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je @@getName148

;-59     InputPtr++;

 inc  word [InputPtr]

;-60     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-61     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-62     p++;

 inc  word [bp-2]

;-63   }


;-64   if (c == ':') isLabel=1; else isLabel=0;

 jmp @@getName147
@@getName148:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName149
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName150
@@getName149:
 mov eax, 0
 mov byte [isLabel], al

;-65   p--;

@@getName150:
 dec  word [bp-2]

;-66   *p = 0;

 mov eax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-67   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-68   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-69 }


;-70 int testReg() {
 LEAVE
 ret
; ENDP

testReg:  ; *** PROC ***

;-71 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-72   RegType=0;

 mov eax, 0
 mov byte [RegType], al

;-73   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge @@testReg151
 mov eax, 0
 jmp @@retn

;-74   if (strlen(Symbol) > 3) return 0;

@@testReg151:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg152
 mov eax, 0
 jmp @@retn

;-75   RegType=BYTE;

@@testReg152:
 mov eax, 1
 mov byte [RegType], al

;-76   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg153
 mov eax, 0
 jmp @@retn

;-77   if (eqstr(SymbolUpper, "CL")) return 1;

@@testReg153:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg154
 mov eax, 1
 jmp @@retn

;-78   if (eqstr(SymbolUpper, "DL")) return 2;

@@testReg154:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 2
 jmp @@retn

;-79   if (eqstr(SymbolUpper, "BL")) return 3;

@@testReg155:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg156
 mov eax, 3
 jmp @@retn

;-80   if (eqstr(SymbolUpper, "AH")) return 4;

@@testReg156:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg157
 mov eax, 4
 jmp @@retn

;-81   if (eqstr(SymbolUpper, "CH")) return 5;

@@testReg157:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg158
 mov eax, 5
 jmp @@retn

;-82   if (eqstr(SymbolUpper, "DH")) return 6;

@@testReg158:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg159
 mov eax, 6
 jmp @@retn

;-83   if (eqstr(SymbolUpper, "BH")) return 7;

@@testReg159:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg160
 mov eax, 7
 jmp @@retn

;-84   RegType=WORD;

@@testReg160:
 mov eax, 2
 mov byte [RegType], al

;-85   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg161
 mov eax, 0
 jmp @@retn

;-86   if (eqstr(SymbolUpper, "CX")) return 1;

@@testReg161:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg162
 mov eax, 1
 jmp @@retn

;-87   if (eqstr(SymbolUpper, "DX")) return 2;

@@testReg162:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg163
 mov eax, 2
 jmp @@retn

;-88   if (eqstr(SymbolUpper, "BX")) return 3;

@@testReg163:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg164
 mov eax, 3
 jmp @@retn

;-89   if (eqstr(SymbolUpper, "SP")) return 4;

@@testReg164:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg165
 mov eax, 4
 jmp @@retn

;-90   if (eqstr(SymbolUpper, "BP")) return 5;

@@testReg165:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg166
 mov eax, 5
 jmp @@retn

;-91   if (eqstr(SymbolUpper, "SI")) return 6;

@@testReg166:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg167
 mov eax, 6
 jmp @@retn

;-92   if (eqstr(SymbolUpper, "DI")) return 7;

@@testReg167:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg168
 mov eax, 7
 jmp @@retn

;-93   RegType=SEGREG;

@@testReg168:
 mov eax, 4
 mov byte [RegType], al

;-94   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg169
 mov eax, 0
 jmp @@retn

;-95   if (eqstr(SymbolUpper, "CS")) return 1;

@@testReg169:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg170
 mov eax, 1
 jmp @@retn

;-96   if (eqstr(SymbolUpper, "SS")) return 2;

@@testReg170:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg171
 mov eax, 2
 jmp @@retn

;-97   if (eqstr(SymbolUpper, "DS")) return 3;

@@testReg171:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg172
 mov eax, 3
 jmp @@retn

;-98   if (eqstr(SymbolUpper, "FS")) return 4;

@@testReg172:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg173
 mov eax, 4
 jmp @@retn

;-99   if (eqstr(SymbolUpper, "GS")) return 5;

@@testReg173:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg174
 mov eax, 5
 jmp @@retn

;-100   RegType=DWORD;

@@testReg174:
 mov eax, 3
 mov byte [RegType], al

;-101   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg175
 mov eax, 0
 jmp @@retn

;-102   if (eqstr(SymbolUpper, "ECX"))return 1;

@@testReg175:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg176
 mov eax, 1
 jmp @@retn

;-103   if (eqstr(SymbolUpper, "EDX"))return 2;

@@testReg176:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg177
 mov eax, 2
 jmp @@retn

;-104   if (eqstr(SymbolUpper, "EBX"))return 3;

@@testReg177:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg178
 mov eax, 3
 jmp @@retn

;-105   if (eqstr(SymbolUpper, "ESP"))return 4;

@@testReg178:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg179
 mov eax, 4
 jmp @@retn

;-106   if (eqstr(SymbolUpper, "EBP"))return 5;

@@testReg179:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg180
 mov eax, 5
 jmp @@retn

;-107   if (eqstr(SymbolUpper, "ESI"))return 6;

@@testReg180:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg181
 mov eax, 6
 jmp @@retn

;-108   if (eqstr(SymbolUpper, "EDI"))return 7;

@@testReg181:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg182
 mov eax, 7
 jmp @@retn

;-109   RegType=0; return 0;

@@testReg182:
 mov eax, 0
 mov byte [RegType], al
 mov eax, 0
 jmp @@retn

;-110 }

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

;-220 #include "OUTPUT.C"

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
 jne @@printLine183
 push printLine_1
 call prs
 add  sp, 2

;-4   else {

 jmp @@printLine184
@@printLine183:

;-5     prc(PrintR);

 mov al, byte [PrintR]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-6     i=0;

 mov eax, 0
 mov word [bp-2], ax

;-7     do {

@@printLine185:

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
 jge @@printLine186
 jmp @@printLine185
@@printLine186:

;-12     do {// fill rest with blank

@@printLine187:

;-13       prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-14       i++;

 inc  word [bp-2]

;-15     } while(i < OPMAXLEN);

 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine188
 jmp @@printLine187
@@printLine188:

;-16   }


;-17   prscomment(InputBuf);

@@printLine184:
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
 je @@prc189
cmp byte [bp+4], 10
 jne @@prc190
 mov  ax, 13
 call writetty

;-20      al=c; writetty(); }

@@prc190:
 mov  al, [bp+4]
 call writetty

;-21    fputcR(c,lst_fd); }

@@prc189:
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
@@prscomment191:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment192
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

 jmp @@prscomment191
@@prscomment192:

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

@@prs193:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs194
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, [bp-2]
 cmp al, 34
 jne @@prs195
 mov ax, [bp-4]
 or  al, al
 je @@prs196
 mov eax, 0
 mov word [bp-4], ax
 jmp @@prs197
@@prs196:
 mov eax, 1
 mov word [bp-4], ax

;-28     if (c==92) { if (com==0) { s++; c=*s;

@@prs197:
@@prs195:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs198
 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs199
 inc  word [bp+4]
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }

 mov al, [bp-2]
 cmp al, 110
 jne @@prs200
 mov eax, 10
 mov byte [bp-2], al
@@prs200:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs201
 mov eax, 9
 mov byte [bp-2], al
@@prs201:
@@prs199:
@@prs198:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
 inc  word [bp+4]

;-30 }

 jmp @@prs193
@@prs194:

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
 jle @@printhex8a202
 add  word [bp-2], 7
@@printhex8a202:
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
 jle @@printhex8a203
 add  word [bp-2], 7
@@printhex8a203:
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
 jb  @@printIntU204
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

@@printIntU204:
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

;-49 int implerror()  {error1("not implemented");}

 ret
; ENDP
allowederror_0 db "not allowed here",0

implerror:  ; *** PROC ***
 push implerror_0
 call error1
 add  sp, 2

;-50 int indexerror (){error1("invalid index register");}

 ret
; ENDP
implerror_0 db "not implemented",0

indexerror:  ; *** PROC ***
 push indexerror_0
 call error1
 add  sp, 2

;-51 int invaloperror (){error1("invalid operands");}

 ret
; ENDP
indexerror_0 db "invalid index register",0

invaloperror:  ; *** PROC ***
 push invaloperror_0
 call error1
 add  sp, 2

;-52 int numbererror(){error1("number expected");}

 ret
; ENDP
invaloperror_0 db "invalid operands",0

numbererror:  ; *** PROC ***
 push numbererror_0
 call error1
 add  sp, 2

;-53 int regmemerror(){error1("only register or memory allowed");}

 ret
; ENDP
numbererror_0 db "number expected",0

regmemerror:  ; *** PROC ***
 push regmemerror_0
 call error1
 add  sp, 2

;-54 int segregerror(){error1("segment register not allowed");}

 ret
; ENDP
regmemerror_0 db "only register or memory allowed",0

segregerror:  ; *** PROC ***
 push segregerror_0
 call error1
 add  sp, 2

;-55 int syntaxerror(){error1("syntax");}

 ret
; ENDP
segregerror_0 db "segment register not allowed",0

syntaxerror:  ; *** PROC ***
 push syntaxerror_0
 call error1
 add  sp, 2

;-56 


;-57 int errorexit(char *s) { error1(s); end1(1);}

 ret
; ENDP
syntaxerror_0 db "syntax",0

errorexit:  ; *** PROC ***
;Function : errorexit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte    57 NULL bp+4    s;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2
 push 1
 call end1
 add  sp, 2

;-58 int addrexit(){errorexit("illegal address");}
 LEAVE
 ret
; ENDP

addrexit:  ; *** PROC ***
 push addrexit_0
 call errorexit
 add  sp, 2

;-59 int internexit(){errorexit("intern compiler error");}

 ret
; ENDP
addrexit_0 db "illegal address",0

internexit:  ; *** PROC ***
 push internexit_0
 call errorexit
 add  sp, 2
 ret
; ENDP
internexit_0 db "intern compiler error",0
;Back to main program: AS.C

;-221 #include "MAIN.C"

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
 jne @@getarg205

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

@@getarg205:
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
 je @@getarg206
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

@@getarg206:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg207
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

@@getarg207:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg208
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

@@getarg208:
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
 je @@epilog209
 push epilog_1
 call prs
 add  sp, 2

;-29   prs(", Label & Var: ");

@@epilog209:
 push epilog_2
 call prs
 add  sp, 2

;-30   if (LabelMaxIx) {

 mov ax, [LabelMaxIx]
 or  al, al
 je @@epilog210

;-31     i = 1;

 mov eax, 1
 mov word [bp-2], ax

;-32     LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-33     do {

@@epilog211:

;-34       prs(LabelNamePtr); prc(' ');

 push word [LabelNamePtr]
 call prs
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-35       j=LabelAddr[i]; printhex16(j); prs(",  ");

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

;-36       j=strlen(LabelNamePtr);//get end of actual name

 push word [LabelNamePtr]
 call strlen
 add  sp, 2
 mov word [bp-4], ax

;-37       LabelNamePtr=LabelNamePtr+j;

 mov ax, [LabelNamePtr]
 add ax, [bp-4]
 mov word [LabelNamePtr], ax

;-38       LabelNamePtr++;

 inc  word [LabelNamePtr]

;-39       i++;

 inc  word [bp-2]

;-40     } while (i <= LabelMaxIx);

 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@epilog212
 jmp @@epilog211
@@epilog212:

;-41   }


;-42   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");

@@epilog210:
 push epilog_4
 call prs
 add  sp, 2
 push word [BinLen]
 call printIntU
 add  sp, 2
 push epilog_5
 call prs
 add  sp, 2

;-43 //  i=0;


;-44 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;


;-45 //  } while (i < BinLen);


;-46   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-47   do {

@@epilog213:

;-48     c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov byte [bp-6], al

;-49     fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-50     i++;

 inc  word [bp-2]

;-51   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog214
 jmp @@epilog213
@@epilog214:

;-52 }


;-53 int end1(int n) {
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

;-54   fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word    53 NULL bp+4    n;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-55   fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-56   fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-57   exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-58 }
 LEAVE
 ret
; ENDP
;Back to main program: AS.C
 
; missing functions: 
; digit
; strcpy
; eqstr
; strlen
; eqstr
; eqstr
; eqstr
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

;-222 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-223 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   223 NULL bp+4    s
;  201 var sign byte   223 NULL bp-2    c;
 ENTER  2,0
@@cputs215:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs216
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
 jmp @@cputs215
@@cputs216:

;-224 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   224 NULL bp+4    s;
 ENTER  0,0
@@toupper217:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper218
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper219
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper220
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper220:
@@toupper219:
 inc  word [bp+4]
 jmp @@toupper217
@@toupper218:

;-225 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-226 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   226 NULL bp+4    s
;  201 var sign word   226 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen221:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen222
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen221
@@strlen222:
 mov ax, [bp-2]
 jmp @@retn

;-227 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    5 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   227 NULL bp+4    s
;  201 ptr sign byte   227 NULL bp+6    t;
 ENTER  0,0
@@strcpy223:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-228   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy224
 jmp @@strcpy223
@@strcpy224:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-229 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   229 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit225
 mov eax, 0
 jmp @@retn
@@digit225:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit226
 mov eax, 0
 jmp @@retn
@@digit226:
 mov eax, 1
 jmp @@retn

;-230 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   230 NULL bp+4    p
;  201 ptr sign byte   230 NULL bp+6    q;
 ENTER  0,0
@@eqstr227:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr228

;-231     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr229
 mov eax, 0
 jmp @@retn
@@eqstr229:
 inc  word [bp+4]
 inc  word [bp+6]

;-232     if(*q) return 0; return 1; }

 jmp @@eqstr227
@@eqstr228:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr230
 mov eax, 0
 jmp @@retn
@@eqstr230:
 mov eax, 1
 jmp @@retn

;-233 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   233 NULL bp+4    s
;  201 ptr sign byte   233 NULL bp+6    t;
 ENTER  0,0
@@strcat1231:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1232
 inc  word [bp+4]
 jmp @@strcat1231
@@strcat1232:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-234 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   234 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-235 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   235 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-236 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   236 NULL bp+4    s
;  201 var sign word   236 NULL bp+6    fd
;  202 var sign word   236 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-237 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   237 NULL bp+4    n
;  201 var sign word   237 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-238   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-239 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   239 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-240 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   240 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-241 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
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

;-242 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   242 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch233
 mov  al, 13
 call writetty
@@putch233:
 mov  al, [bp+4]
 call writetty

;-243 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt234
 inc  word [DOS_ERR]
@@DosInt234:

;-244 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

 ret
; ENDP
;End of archive file. 
 
; missing functions:  All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width line used  address name   list of global variables

;    1 arr sign byte     2    2        0 Version1[20]
;    2 var sign byte     1    3        0 LIST
;    3 def unsg byte     2    -        0 SYMBOLMAX=31
;    4 arr sign byte     3    7    30000 Symbol[31]
;    5 arr sign byte     4   36    30031 SymbolUpper[31]
;    6 var unsg word     5   12        0 SymbolInt
;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
;    8 arr sign byte     7    3    30062 InputBuf[127]
;    9 ptr unsg byte     8   23        0 InputPtr
;   10 arr sign byte     9    5    30189 namein[67]
;   11 arr sign byte    10    5    30256 namelst[67]
;   12 arr sign byte    11    5    30323 namebin[67]
;   13 var sign word    12    4        0 asm_fd
;   14 var sign word    13    3        0 lst_fd
;   15 var sign word    14    3        0 bin_fd
;   16 var sign word    15    6        0 DOS_ERR
;   17 var sign word    16    4        0 ErrorCount
;   18 var sign word    17    4        0 DOS_NoBytes
;   19 var sign byte    18    4        0 DOS_ByteRead
;   20 var unsg word    20    5        0 PC
;   21 var unsg word    21    2        0 PCStart
;   22 var sign byte    22    3        0 isLabel
;   23 def unsg byte    23    -        0 DIGIT=1
;   24 def unsg byte    24    -        0 LETTERE=2
;   25 def unsg byte    25    -        0 ALNUME=3
;   26 def unsg byte    26    -        0 NOALNUME=4
;   27 var sign byte    27   21        0 TokeType
;   28 def unsg byte    28    -        0 BYTE=1
;   29 def unsg byte    29    -        0 WORD=2
;   30 def unsg byte    30    -        0 DWORD=3
;   31 def unsg byte    31    -        0 SEGREG=4
;   32 def unsg byte    32    -        0 IMM=1
;   33 def unsg byte    33    -        0 REG=2
;   34 def unsg byte    34    -        0 ADR=3
;   35 def unsg byte    35    -        0 MEM=4
;   36 var sign byte    36   14        0 Op1
;   37 var sign byte    37   11        0 CodeType
;   38 var sign byte    38    4        0 Code1
;   39 var sign byte    39    5        0 Code2
;   40 var sign byte    40    3        0 Code3
;   41 var sign byte    41   17        0 RegType
;   42 var sign byte    42   10        0 RegNo
;   43 var sign byte    43   10        0 OpSize
;   44 var sign byte    44    4        0 wflag
;   45 var sign byte    49   15        0 regindexbase
;   46 var sign byte    50    3        0 isDirect
;   47 var sign word    51   14        0 disp
;   48 var sign word    52    2        0 imme
;   49 def unsg byte    54    -        0 OPMAXLEN=5
;   50 arr sign byte    55    2    30390 OpPos[5]
;   51 var sign word    56    6        0 OpPrintIndex
;   52 ptr sign byte    57   17        0 OpCodePtr
;   53 var sign byte    58    2        0 PrintR
;   54 def unsg byte    60    -        0 LABELNAMESMAX=969
;   55 arr sign byte    61    3    30395 LabelNames[1000]
;   56 ptr sign byte    62   10        0 LabelNamePtr
;   57 def unsg byte    63    -        0 LABELADRMAX=100
;   58 arr unsg word    64    4    31395 LabelAddr[100]
;   59 var sign word    65    5        0 LabelMaxIx
;   60 var sign word    66    4        0 LabelIx
;   61 def unsg byte    68    -        0 FILEBINMAX=1990
;   62 arr sign byte    69    2    31595 FileBin[2000]
;   63 var unsg word    70    4        0 BinLen
;   64 ptr sign byte    72    1        0 arglen
;   65 ptr sign byte    73    4        0 argv
;   66 var sign byte     1    1        0 I_START
;   67 arr sign byte     4 NULL        0 I_PUSHA[9]
;   68 arr sign byte     5 NULL        0 I_POPA[8]
;   69 arr sign byte     6 NULL        0 I_NOP[7]
;   70 arr sign byte     7 NULL        0 I_CBW[7]
;   71 arr sign byte     8 NULL        0 I_CWDE[8]
;   72 arr sign byte     9 NULL        0 I_CWD[7]
;   73 arr sign byte    10 NULL        0 I_CDQ[7]
;   74 arr sign byte    11 NULL        0 I_WAIT[8]
;   75 arr sign byte    12 NULL        0 I_PUSHF[9]
;   76 arr sign byte    13 NULL        0 I_POPF[8]
;   77 arr sign byte    14 NULL        0 I_SAHF[8]
;   78 arr sign byte    15 NULL        0 I_LAHF[8]
;   79 arr sign byte    16 NULL        0 I_MOVSB[9]
;   80 arr sign byte    17 NULL        0 I_MOVSW[9]
;   81 arr sign byte    18 NULL        0 I_CMPSB[9]
;   82 arr sign byte    19 NULL        0 I_CMPSW[9]
;   83 arr sign byte    20 NULL        0 I_STOSB[9]
;   84 arr sign byte    21 NULL        0 I_STOSW[9]
;   85 arr sign byte    22 NULL        0 I_LODSB[9]
;   86 arr sign byte    23 NULL        0 I_LODSW[9]
;   87 arr sign byte    24 NULL        0 I_SCASB[9]
;   88 arr sign byte    25 NULL        0 I_SCASW[9]
;   89 arr sign byte    26 NULL        0 I_LEAVE[9]
;   90 arr sign byte    27 NULL        0 I_IRET[8]
;   91 arr sign byte    28 NULL        0 I_XLAT[8]
;   92 arr sign byte    29 NULL        0 I_LOCK[8]
;   93 arr sign byte    30 NULL        0 I_REPNE[9]
;   94 arr sign byte    31 NULL        0 I_REPNZ[9]
;   95 arr sign byte    32 NULL        0 I_REPE[8]
;   96 arr sign byte    33 NULL        0 I_REPZ[8]
;   97 arr sign byte    34 NULL        0 I_HLT[7]
;   98 arr sign byte    35 NULL        0 I_CLC[7]
;   99 arr sign byte    36 NULL        0 I_STC[7]
;  100 arr sign byte    37 NULL        0 I_CLI[7]
;  101 arr sign byte    38 NULL        0 I_STI[7]
;  102 arr sign byte    39 NULL        0 I_CLD[7]
;  103 arr sign byte    40 NULL        0 I_STD[7]
;  104 arr sign byte    42 NULL        0 I_INC[9]
;  105 arr sign byte    43 NULL        0 I_DEC[9]
;  106 arr sign byte    44 NULL        0 I_NOT[8]
;  107 arr sign byte    45 NULL        0 I_NEG[8]
;  108 arr sign byte    46 NULL        0 I_MUL[8]
;  109 arr sign byte    47 NULL        0 I_IMUL[9]
;  110 arr sign byte    48 NULL        0 I_DIV[8]
;  111 arr sign byte    49 NULL        0 I_IDIV[9]
;  112 arr sign byte    51 NULL        0 I_LES[7]
;  113 arr sign byte    52 NULL        0 I_LDS[7]
;  114 arr sign byte    53 NULL        0 I_LEA[7]
;  115 arr sign byte    55 NULL        0 I_ADD[7]
;  116 arr sign byte    56 NULL        0 I_OR[6]
;  117 arr sign byte    57 NULL        0 I_ADC[7]
;  118 arr sign byte    58 NULL        0 I_SBB[7]
;  119 arr sign byte    59 NULL        0 I_AND[7]
;  120 arr sign byte    60 NULL        0 I_SUB[7]
;  121 arr sign byte    61 NULL        0 I_XOR[7]
;  122 arr sign byte    62 NULL        0 I_CMP[7]
;  123 arr sign byte    64 NULL        0 I_MOV[6]
;  124 arr sign byte    65 NULL        0 I_MOVSX[9]
;  125 arr sign byte    66 NULL        0 I_MOVZX[9]
;  126 arr sign byte    68 NULL        0 I_JO[6]
;  127 arr sign byte    69 NULL        0 I_JNO[7]
;  128 arr sign byte    70 NULL        0 I_JB[6]
;  129 arr sign byte    71 NULL        0 I_JC[6]
;  130 arr sign byte    72 NULL        0 I_JNB[7]
;  131 arr sign byte    73 NULL        0 I_JAE[7]
;  132 arr sign byte    74 NULL        0 I_JNC[7]
;  133 arr sign byte    75 NULL        0 I_JE[6]
;  134 arr sign byte    76 NULL        0 I_JZ[6]
;  135 arr sign byte    77 NULL        0 I_JNE[7]
;  136 arr sign byte    78 NULL        0 I_JNZ[7]
;  137 arr sign byte    79 NULL        0 I_JBE[7]
;  138 arr sign byte    80 NULL        0 I_JNA[7]
;  139 arr sign byte    81 NULL        0 I_JA[6]
;  140 arr sign byte    82 NULL        0 I_JS[6]
;  141 arr sign byte    83 NULL        0 I_JNS[7]
;  142 arr sign byte    84 NULL        0 I_JP[6]
;  143 arr sign byte    85 NULL        0 I_JPE[7]
;  144 arr sign byte    86 NULL        0 I_JNP[7]
;  145 arr sign byte    87 NULL        0 I_JPO[7]
;  146 arr sign byte    88 NULL        0 I_JL[6]
;  147 arr sign byte    89 NULL        0 I_JNL[7]
;  148 arr sign byte    90 NULL        0 I_JGE[7]
;  149 arr sign byte    91 NULL        0 I_JLE[7]
;  150 arr sign byte    92 NULL        0 I_JNG[7]
;  151 arr sign byte    93 NULL        0 I_JG[6]
;  152 arr sign byte    95 NULL        0 I_JMP[8]
;  153 arr sign byte    96 NULL        0 I_CALL[9]
;  154 arr sign byte    98 NULL        0 I_RET[8]
;  155 arr sign byte    99 NULL        0 I_RETF[9]
;  156 arr sign byte   101 NULL        0 I_PUSH[8]
;  157 arr sign byte   102 NULL        0 I_POP[7]
;  158 arr sign byte   104 NULL        0 I_ROL[7]
;  159 arr sign byte   105 NULL        0 I_ROR[7]
;  160 arr sign byte   106 NULL        0 I_RCL[7]
;  161 arr sign byte   107 NULL        0 I_RCR[7]
;  162 arr sign byte   108 NULL        0 I_SHL[7]
;  163 arr sign byte   109 NULL        0 I_SAL[7]
;  164 arr sign byte   110 NULL        0 I_SHR[7]
;  165 arr sign byte   111 NULL        0 I_SAR[7]
;  166 arr sign byte   113 NULL        0 I_INT[8]
;  167 arr sign byte   114 NULL        0 I_INTO[8]
;  168 arr sign byte   116 NULL        0 I_IN[7]
;  169 arr sign byte   117 NULL        0 I_INSB[8]
;  170 arr sign byte   118 NULL        0 I_INSW[8]
;  171 arr sign byte   119 NULL        0 I_INSD[8]
;  172 arr sign byte   120 NULL        0 I_OUT[8]
;  173 arr sign byte   121 NULL        0 I_OUTSB[8]
;  174 arr sign byte   122 NULL        0 I_OUTSW[8]
;  175 arr sign byte   123 NULL        0 I_OUTSD[8]
;  176 arr sign byte   125 NULL        0 I_XCHG[9]
;  177 arr sign byte   127 NULL        0 I_LOOPNZ[10]
;  178 arr sign byte   128 NULL        0 I_LOOPNE[10]
;  179 arr sign byte   129 NULL        0 I_LOOPZ[9]
;  180 arr sign byte   130 NULL        0 I_LOOPE[9]
;  181 arr sign byte   131 NULL        0 I_LOOP[8]
;  182 arr sign byte   132 NULL        0 I_JCXZ[8]
;  183 arr sign byte   133 NULL        0 I_JECXZ[9]
;  184 arr sign byte   135 NULL        0 I_ENTER[9]
;  185 arr sign byte   137 NULL        0 I_ORG[6]
;  186 arr sign byte   139 NULL        0 I_SECTION[10]
;  187 arr sign byte   140 NULL        0 I_SEGMENT[10]
;  188 arr sign byte   141 NULL        0 I_ABSOLUTE[11]
;  189 arr sign byte   142 NULL        0 I_DB[5]
;  190 arr sign byte   143 NULL        0 I_DW[5]
;  191 arr sign byte   144 NULL        0 I_DD[5]
;  192 arr sign byte   145 NULL        0 I_RESB[7]
;  193 arr sign byte   146 NULL        0 I_RESW[7]
;  194 arr sign byte   147 NULL        0 I_RESD[7]
;  195 var sign byte   148 NULL        0 I_END


;   # Calls Line Width  Name   list of functions

;    0 NULL    1 word   main
;    1    1    6 word   process
;    2    1   49 word   setwflag
;    3 NULL   61 word   Check2Op
;    4    1   63 word   checkLeftOp
;    5 NULL   75 word   saveLeftOp
;    6 NULL   77 word   checkRightOp
;    7    1   88 word   getOp
;    8    2  101 word   getOp1
;    9    1  117 word   getMEM
;   10    1  139 word   getIndReg1
;   11    1  147 word   getIndReg2
;   12    1  158 word   getCodes
;   13    1  163 word   gen66h
;   14    3  165 word   genCode
;   15   11  169 word   genCode8
;   16    3  179 word   genCode16
;   17    1  183 word   writeEA
;   18    1    1 word   parse
;   19   13   27 word   getTokeType
;   20    2   36 word   storeLabel
;   21    2   43 word   searchLabel
;   22    1   54 word   getVariable
;   23    2   83 word   lookCode
;   24    1   97 word   getCodeSize
;   25    7  104 word   isToken
;   26    1  109 word   skipRest
;   27    1    1 word   getLine
;   28    1   14 word   ifEOL
;   29    3   21 word   skipBlank
;   30    2   26 word   letterE
;   31    1   36 word   alnumE
;   32    1   41 word   getDigit
;   33    1   53 word   getName
;   34    1   70 word   testReg
;   35    1    1 word   printLine
;   36    8   19 word   prc
;   37    1   23 word   prscomment
;   38   23   26 word   prs
;   39    3   31 word   printhex8a
;   40    2   35 word   printhex16
;   41    3   38 word   printIntU
;   42   22   45 word   error1
;   43 NULL   48 word   allowederror
;   44    2   49 word   implerror
;   45    4   50 word   indexerror
;   46 NULL   51 word   invaloperror
;   47    1   52 word   numbererror
;   48 NULL   53 word   regmemerror
;   49    1   54 word   segregerror
;   50    1   55 word   syntaxerror
;   51    7   57 word   errorexit
;   52    1   58 word   addrexit
;   53 NULL   59 word   internexit
;   54    1    1 word   getarg
;   55    1   26 word   epilog
;   56    2   53 word   end1
;   57    4  222 word   writetty
;   58    8  223 word   cputs
;   59    2  224 word   toupper
;   60    4  226 word   strlen
;   61    6  227 word   strcpy
;   62    3  229 word   digit
;   63   35  230 word   eqstr
;   64    3  233 word   strcat1
;   65    1  234 word   openR
;   66    2  235 word   creatR
;   67    2  236 word   readRL
;   68    2  237 word   fputcR
;   69    3  239 word   fcloseR
;   70    5  240 word   exitR
;   71    1  242 word   putch
;   72    4  243 word   DosInt
;   73 NULL  244 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0     5 getarg
;    1    12 parse
;    2    18 epilog
;    3    25 end1
;    4  1418 getTokeType
;    5  1430 getCodeSize
;    6  1442 getCodes
;    7  1451 genCode8
;    8  1460 checkLeftOp
;    9  1472 genCode
;   10  1480 genCode
;   11  1488 getTokeType
;   12  1500 implerror
;   13  1510 genCode
;   14  1518 writeEA
;   15  1526 genCode8
;   16  1535 genCode16
;   17  1545 genCode8
;   18  1554 error1
;   19  1561 error1
;   20  1577 gen66h
;   21  1616 getOp
;   22  1622 implerror
;   23  1632 segregerror
;   24  1644 setwflag
;   25  1653 error1
;   26  1660 error1
;   27  1667 error1
;   28  1709 getOp1
;   29  1716 isToken
;   30  1724 getMEM
;   31  1731 error1
;   32  1738 error1
;   33  1752 testReg
;   34  1760 searchLabel
;   35  1772 error1
;   36  1790 getTokeType
;   37  1802 getOp1
;   38  1809 syntaxerror
;   39  1821 getIndReg2
;   40  1832 getIndReg1
;   41  1843 isToken
;   42  1851 getTokeType
;   43  1863 numbererror
;   44  1875 isToken
;   45  1883 isToken
;   46  1891 errorexit
;   47  1912 indexerror
;   48  1923 indexerror
;   49  1947 indexerror
;   50  1958 indexerror
;   51  1985 genCode8
;   52  2006 genCode8
;   53  2038 genCode8
;   54  2047 genCode8
;   55  2072 addrexit
;   56  2081 error1
;   57  2088 genCode8
;   58  2097 genCode8
;   59  2106 genCode16
;   60  2122 getLine
;   61  2130 getTokeType
;   62  2142 storeLabel
;   63  2153 getTokeType
;   64  2165 lookCode
;   65  2174 process
;   66  2182 getVariable
;   67  2194 skipRest
;   68  2203 error1
;   69  2210 error1
;   70  2217 printLine
;   71  2241 skipBlank
;   72  2251 digit
;   73  2257 getDigit
;   74  2266 letterE
;   75  2274 getName
;   76  2293 searchLabel
;   77  2305 error1
;   78  2312 strcpy
;   79  2339 eqstr
;   80  2345 strlen
;   81  2366 storeLabel
;   82  2377 getTokeType
;   83  2389 lookCode
;   84  2398 errorexit
;   85  2408 errorexit
;   86  2418 getTokeType
;   87  2430 genCode8
;   88  2439 skipBlank
;   89  2449 isToken
;   90  2457 genCode8
;   91  2466 isToken
;   92  2474 getTokeType
;   93  2486 genCode16
;   94  2496 isToken
;   95  2504 errorexit
;   96  2523 eqstr
;   97  2541 eqstr
;   98  2547 getTokeType
;   99  2559 eqstr
;  100  2565 getTokeType
;  101  2577 eqstr
;  102  2583 getTokeType
;  103  2605 skipBlank
;  104  2624 getTokeType
;  105  2636 error1
;  106  2651 readRL
;  107  2658 errorexit
;  108  2668 ifEOL
;  109  2682 readRL
;  110  2718 digit
;  111  2724 letterE
;  112  2751 digit
;  113  2769 alnumE
;  114  2776 strcpy
;  115  2783 toupper
;  116  2799 strlen
;  117  2806 strlen
;  118  2813 eqstr
;  119  2819 eqstr
;  120  2825 eqstr
;  121  2831 eqstr
;  122  2837 eqstr
;  123  2843 eqstr
;  124  2849 eqstr
;  125  2855 eqstr
;  126  2861 eqstr
;  127  2867 eqstr
;  128  2873 eqstr
;  129  2879 eqstr
;  130  2885 eqstr
;  131  2891 eqstr
;  132  2897 eqstr
;  133  2903 eqstr
;  134  2909 eqstr
;  135  2915 eqstr
;  136  2921 eqstr
;  137  2927 eqstr
;  138  2933 eqstr
;  139  2939 eqstr
;  140  2945 eqstr
;  141  2951 eqstr
;  142  2957 eqstr
;  143  2963 eqstr
;  144  2969 eqstr
;  145  2975 eqstr
;  146  2981 eqstr
;  147  2987 eqstr
;  148  3007 prs
;  149  3011 printhex16
;  150  3022 prs
;  151  3026 prc
;  152  3030 printhex8a
;  153  3041 prc
;  154  3045 prs
;  155  3049 prscomment
;  156  3066 writetty
;  157  3075 writetty
;  158  3084 fputcR
;  159  3106 prc
;  160  3122 prc
;  161  3143 prc
;  162  3147 prc
;  163  3169 printhex8a
;  164  3180 printhex8a
;  165  3205 printIntU
;  166  3215 prc
;  167  3228 prs
;  168  3232 prs
;  169  3236 prs
;  170  3240 prs
;  171  3257 error1
;  172  3274 error1
;  173  3292 error1
;  174  3312 error1
;  175  3331 error1
;  176  3350 error1
;  177  3369 error1
;  178  3388 error1
;  179  3407 error1
;  180  3414 end1
;  181  3428 errorexit
;  182  3449 errorexit
;  183  3478 cputs
;  184  3484 cputs
;  185  3490 exitR
;  186  3496 toupper
;  187  3504 strcpy
;  188  3511 strcat1
;  189  3519 strcpy
;  190  3526 strcat1
;  191  3534 strcpy
;  192  3541 strcat1
;  193  3549 openR
;  194  3555 cputs
;  195  3561 cputs
;  196  3567 exitR
;  197  3573 creatR
;  198  3580 cputs
;  199  3586 cputs
;  200  3592 exitR
;  201  3598 creatR
;  202  3605 cputs
;  203  3611 cputs
;  204  3617 exitR
;  205  3623 prs
;  206  3627 prs
;  207  3631 prs
;  208  3635 prs
;  209  3639 prs
;  210  3643 prs
;  211  3647 prs
;  212  3651 prs
;  213  3655 prs
;  214  3672 prs
;  215  3676 printIntU
;  216  3686 prs
;  217  3690 prs
;  218  3694 prs
;  219  3698 prc
;  220  3702 printhex16
;  221  3713 prs
;  222  3717 strlen
;  223  3724 prs
;  224  3728 printIntU
;  225  3738 prs
;  226  3742 fputcR
;  227  3756 fcloseR
;  228  3764 fcloseR
;  229  3772 fcloseR
;  230  3780 exitR
;  231  3805 putch
;  232  3873 strcpy
;  233  3888 DosInt
;  234  3904 DosInt
;  235  3927 DosInt
;  236  3946 DosInt
;  237  3980 writetty
;  238  3989 writetty
;Input: AS.C, List: AS.S,  Lines:  245
;Glob. variables:  195 max.:  200
;Local variables:    3 max.:  100, in 'searchLabel'
;Functions      :   74 max.:  300
;Calls          :  239 max.: 2000, NameField: 4021 max.:    65535
;Code until     :26009 max.: 30000, free: 3991
;Data (HeapEnd) :33595, resting stacksize: 31940
;Max. Const in 'testReg' :  658 max. 3000, free: 2342