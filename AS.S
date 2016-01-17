
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

;-2 char Version1[]="AS.C V0.07 16.1.2016";

 ret
; ENDP
Version1 db "AS.C V0.07 16.1.2016",0

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


;-32 //char CodeSize;          //0, BYTE, WORD, DWORD


;-33 #define IMM      1      //const  ,123


;-34 #define REG      2      //       ,BX    mode=11


;-35 #define ADR      3      //VALUE  ,var1  mod=00, r/m=110


;-36 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16


;-37 char Op1;               //0, IMM, REG, ADR, MEM

Op1 db 0

;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size

CodeType db 0

;-39 


;-40 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG

RegType db 0

;-41 char RegNo;             //0 - 7 AL, CL, ...  by testReg()

RegNo db 0

;-42 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0

;-43 char wflag;             //0=byte, 1=word/dword

wflag db 0

;-44 //char AddrSize;          //67h:


;-45 //char NumOprns;          //0-2


;-46 //char dflag;             //0=source is reg,  1=dest is reg


;-47 //char modrm;           //mod, r/m


;-48 char regindexbase;      //combination of index and base reg

regindexbase db 0

;-49 int disp;               //displacement      0-8 bytes

disp dw 0

;-50 int imme;               //immediate         0-8 bytes

imme dw 0

;-51 


;-52 #define OPMAXLEN 5


;-53 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 30390
OpPos resb 5
section .text

;-54 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0

;-55 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0

;-56 char PrintR;           //print 'R' if relocative

PrintR db 0

;-57 


;-58 #define LABELNAMESMAX 969//next number - 31


;-59 char LabelNames[1000];  //space for names of all labels

section .bss
absolute 30395
LabelNames resb 1000
section .text

;-60 char *LabelNamePtr;     // first free position

LabelNamePtr dw 0

;-61 #define LABELADRMAX 100


;-62 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 31395
LabelAddr resw 100
section .text

;-63 int LabelMaxIx=0;       //actual number of stored labels

LabelMaxIx dw 0

;-64 int LabelIx;            //actual number of just searched label

LabelIx dw 0

;-65 


;-66 #define FILEBINMAX 1990 //next number - max. oplemgth


;-67 char FileBin  [2000];   //output binary file

section .bss
absolute 31595
FileBin resb 2000
section .text

;-68 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-69 


;-70 char *arglen=0x80;      // for main only

arglen dw 128

;-71 char *argv=0x82;        // for main only

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

;-41 //  2: inc,dec


;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-44 // 52: mem reg 16 bit


;-45 char I_NOT[]=  {'N','O','T',0,         52,0xF6, 2,0xF1};

I_NOT db 78,79,84,0,52,246,2,241

;-46 char I_NEG[]=  {'N','E','G',0,         52,0xF6, 3,0xF1};

I_NEG db 78,69,71,0,52,246,3,241

;-47 char I_MUL[]=  {'M','U','L',0,         52,0xF6, 4,0xF1};

I_MUL db 77,85,76,0,52,246,4,241

;-48 char I_IMUL[]= {'I','M','U','L',0,     52,0xF6, 5,0xF1};//only acc

I_IMUL db 73,77,85,76,0,52,246,5,241

;-49 char I_DIV[]=  {'D','I','V',0,         52,0xF6, 6,0xF1};

I_DIV db 68,73,86,0,52,246,6,241

;-50 char I_IDIV[]= {'I','D','I','V',0,     52,0xF6, 7,0xF1};

I_IDIV db 73,68,73,86,0,52,246,7,241

;-51 //  3: les, lda, lea


;-52 char I_LES[]=  {'L','E','S',0,          3,0xC4,   0xF1};// /r, a16

I_LES db 76,69,83,0,3,196,241

;-53 char I_LDS[]=  {'L','D','S',0,          3,0xC5,   0xF1};// /r, a16

I_LDS db 76,68,83,0,3,197,241

;-54 char I_LEA[]=  {'L','E','A',0,          3,0x8D,   0xF1};// /r, a16

I_LEA db 76,69,65,0,3,141,241

;-55 //  4: acc,imm  reg,imm  index,reg


;-56 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-57 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-58 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-59 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-60 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-61 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-62 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-63 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-64 //  5: mov


;-65 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-66 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,5,190,241

;-67 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,5,182,241

;-68 //  6: single byte relative jump


;-69 char I_JO []=  {'J','O',0,              6, 0,     0xF1};

I_JO db 74,79,0,6,0,241

;-70 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};

I_JNO db 74,78,79,0,6,1,241

;-71 char I_JB []=  {'J','B',0,              6, 2,     0xF1};

I_JB db 74,66,0,6,2,241

;-72 char I_JC []=  {'J','C',0,              6, 2,     0xF1};

I_JC db 74,67,0,6,2,241

;-73 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};

I_JNB db 74,78,66,0,6,3,241

;-74 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};

I_JAE db 74,65,69,0,6,3,241

;-75 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};

I_JNC db 74,78,67,0,6,3,241

;-76 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel

I_JE db 74,69,0,6,4,241

;-77 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r

I_JZ db 74,90,0,6,4,241

;-78 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};

I_JNE db 74,78,69,0,6,5,241

;-79 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};

I_JNZ db 74,78,90,0,6,5,241

;-80 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};

I_JBE db 74,66,69,0,6,6,241

;-81 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};

I_JNA db 74,78,65,0,6,6,241

;-82 char I_JA []=  {'J','A',0,              6, 7,     0xF1};

I_JA db 74,65,0,6,7,241

;-83 char I_JS []=  {'J','S',0,              6, 8,     0xF1};

I_JS db 74,83,0,6,8,241

;-84 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};

I_JNS db 74,78,83,0,6,9,241

;-85 char I_JP []=  {'J','P',0,              6,10,     0xF1};

I_JP db 74,80,0,6,10,241

;-86 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};

I_JPE db 74,80,69,0,6,10,241

;-87 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};

I_JNP db 74,78,80,0,6,11,241

;-88 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};

I_JPO db 74,80,79,0,6,11,241

;-89 char I_JL []=  {'J','L',0,              6,12,     0xF1};

I_JL db 74,76,0,6,12,241

;-90 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};

I_JNL db 74,78,76,0,6,13,241

;-91 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};

I_JGE db 74,71,69,0,6,13,241

;-92 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};

I_JLE db 74,76,69,0,6,14,241

;-93 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};

I_JNG db 74,78,71,0,6,14,241

;-94 char I_JG []=  {'J','G',0,              6,15,     0xF1};

I_JG db 74,71,0,6,15,241

;-95 //  7: jmp, call


;-96 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-97 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-98 //  8: ret


;-99 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-100 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-101 //  9: seg, r/m


;-102 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,241

;-103 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16

I_POP db 80,79,80,0,9,88,241

;-104 //  11: shift, rotates


;-105 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};

I_ROL db 82,79,76,0,11,0,241

;-106 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};

I_ROR db 82,79,82,0,11,1,241

;-107 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};

I_RCL db 82,67,76,0,11,2,241

;-108 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};

I_RCR db 82,67,82,0,11,3,241

;-109 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};

I_SHL db 83,72,76,0,11,4,241

;-110 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};

I_SAL db 83,65,76,0,11,5,241

;-111 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};

I_SHR db 83,72,82,0,11,6,241

;-112 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};

I_SAR db 83,65,82,0,11,7,241

;-113 //  12: int


;-114 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-115 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};

I_INTO db 73,78,84,79,0,12,206,241

;-116 //  14: in/out


;-117 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-118 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-119 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-120 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-121 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-122 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-123 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-124 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-125 //  15: xchg


;-126 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-127 //  16: loop, jcxz


;-128 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-129 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-130 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-131 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-132 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-133 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-134 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-135 //  30: enter


;-136 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};

I_ENTER db 69,78,84,69,82,0,30,200,241

;-137 // 100: directives


;-138 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-139 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-140 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-141 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-142 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};

I_RESB db 82,69,83,66,0,205,241

;-143 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};

I_RESW db 82,69,83,87,0,206,241

;-144 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};

I_RESD db 82,69,83,68,0,207,241

;-145 char I_END=0;// end of table char

I_END db 0
;Back to main program: AS.C

;-5 


;-6 int process() { int i; char c;


process:  ; *** PROC ***

;-7   getTokeType();

;Function : process, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word     6 NULL bp-2    i
;  201 var sign byte     6 NULL bp-4    c;
 ENTER  4,0
 call getTokeType

;-8   OpSize=getCodeSize();////

 call getCodeSize
 mov byte [OpSize], al

;-9 


;-10   if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne @@process1

;-11     genInstruction(0, 1);

 push 1
 push 0
 call genInstruction
 add  sp, 4

;-12     return;

 jmp @@retn

;-13   }


;-14   if (CodeType ==  2) {//inc, dec

@@process1:
 mov al, [CodeType]
 cmp al, 2
 jne @@process2

;-15     checkLeftOp(1);

 push 1
 call checkLeftOp
 add  sp, 2

;-16     	if (Op1 == REG) {

 mov al, [Op1]
 cmp al, 2
 jne @@process3

;-17         if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short

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

;-18         if (RegType ==DWORD) {genInstruction(RegNo, 3); return; }

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

;-19       }

@@process5:

;-20       genInstruction(wflag, 1);

@@process3:
 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4

;-21       genCodeInREG();

 call genCodeInREG

;-22       return;

 jmp @@retn

;-23   }


;-24 


;-25   if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul

@@process2:
 mov al, [CodeType]
 cmp al, 52
 jne @@process6

;-26     checkLeftOp(2);

 push 2
 call checkLeftOp
 add  sp, 2

;-27     genInstruction(wflag, 1);

 push 1
 mov al, byte [wflag]
 mov ah, 0
 push ax
 call genInstruction
 add  sp, 4

;-28     genCodeInREG();

 call genCodeInREG

;-29     return;

 jmp @@retn

;-30   }


;-31 


;-32   if (CodeType==  8) {// ret

@@process6:
 mov al, [CodeType]
 cmp al, 8
 jne @@process7

;-33     if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne @@process8

;-34       genInstruction(0, 2);

 push 2
 push 0
 call genInstruction
 add  sp, 4

;-35       genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-36       return;

 jmp @@retn

;-37     }


;-38     genInstruction(0, 1); return;

@@process8:
 push 1
 push 0
 call genInstruction
 add  sp, 4
 jmp @@retn

;-39   }


;-40 


;-41   if (CodeType==101) {// ORG nn

@@process7:
 mov al, [CodeType]
 cmp al, 101
 jne @@process9

;-42     if (TokeType != DIGIT) error1("only digit allowed");

 mov al, [TokeType]
 cmp al, 1
 je  @@process10
 push process_0
 call error1
 add  sp, 2

;-43     PC=SymbolInt;return;

@@process10:
 mov ax, [SymbolInt]
 mov word [PC], ax
 jmp @@retn

;-44   }


;-45   error1("unknown CodeType");

@@process9:
 push process_1
 call error1
 add  sp, 2

;-46 }


;-47 


;-48 int setwflag() {//only Op1 (first operand)

@@retn: LEAVE
 ret
; ENDP
process_0 db "only digit allowed",0
process_1 db "unknown CodeType",0

setwflag:  ; *** PROC ***

;-49   wflag=0;

 mov eax, 0
 mov byte [wflag], al

;-50   if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne @@setwflag11

;-51     if (Op1 == REG) {

 mov al, [Op1]
 cmp al, 2
 jne @@setwflag12

;-52       OpSize=RegType;

 mov al, [RegType]
 mov byte [OpSize], al

;-53       if (RegType == SEGREG) OpSize=WORD;

 mov al, [RegType]
 cmp al, 4
 jne @@setwflag13
 mov eax, 2
 mov byte [OpSize], al

;-54     }

@@setwflag13:

;-55   }

@@setwflag12:

;-56   if (OpSize  == DWORD) {gen66h(); wflag=1;}

@@setwflag11:
 mov al, [OpSize]
 cmp al, 3
 jne @@setwflag14
 call gen66h
 mov eax, 1
 mov byte [wflag], al

;-57   if (OpSize  ==  WORD) wflag=1;

@@setwflag14:
 mov al, [OpSize]
 cmp al, 2
 jne @@setwflag15
 mov eax, 1
 mov byte [wflag], al

;-58 }

@@setwflag15:

;-59 


;-60 int Check2Op(char left, char rigth) {

 ret
; ENDP

Check2Op:  ; *** PROC ***

;-61 }

;Function : Check2Op, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte    60 NULL bp+4    left
;  201 var sign byte    60 NULL bp+6    rigth;
 ENTER  0,0

;-62 int checkLeftOp(char mode) {
 LEAVE
 ret
; ENDP

checkLeftOp:  ; *** PROC ***

;-63   getOp();

;Function : checkLeftOp, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    62 NULL bp+4    mode;
 ENTER  0,0
 call getOp

;-64   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop

 mov al, [RegType]
 cmp al, 4
 jne @@checkLeftOp16
 call segregerror
 jmp @@retn

;-65   setwflag();

@@checkLeftOp16:
 call setwflag

;-66   if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne @@checkLeftOp17
 push checkLeftOp_0
 call error1
 add  sp, 2

;-67   if (OpSize == RegType) return;

@@checkLeftOp17:
 mov al, [OpSize]
 cmp al, [RegType]
 jne @@checkLeftOp18
 jmp @@retn

;-68   if (OpSize){if (Op1 == MEM) return;

@@checkLeftOp18:
 mov al, [OpSize]
 or  al, al
 je @@checkLeftOp19
 mov al, [Op1]
 cmp al, 4
 jne @@checkLeftOp20
 jmp @@retn

;-69     error1("Conflict OpSize and RegSize"); }

@@checkLeftOp20:
 push checkLeftOp_1
 call error1
 add  sp, 2

;-70   if (RegType==0) error1("no register defined");

@@checkLeftOp19:
 mov al, [RegType]
 cmp al, 0
 jne @@checkLeftOp21
 push checkLeftOp_2
 call error1
 add  sp, 2

;-71 }

@@checkLeftOp21:

;-72 


;-73 int saveLeftOp(){

@@retn: LEAVE
 ret
; ENDP
checkLeftOp_0 db "no op size declared",0
checkLeftOp_1 db "Conflict OpSize and RegSize",0
checkLeftOp_2 db "no register defined",0

saveLeftOp:  ; *** PROC ***

;-74 }


;-75 int checkRightOp(char mode){

 ret
; ENDP

checkRightOp:  ; *** PROC ***

;-76 }

;Function : checkRightOp, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    75 NULL bp+4    mode;
 ENTER  0,0

;-77 


;-78 /*        Op      = 0, IMM, REG, ADR, MEM


;-79 IMM       imme    = 0, SymbolInt    


;-80 REG     R RegNo   = 0 - 7


;-81 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 


;-82 MEM,ADR   disp    = 0,LabelAddr[LabelIx]


;-83 MEM       regindexbase = 0 - 7


;-84 


;-85           OpSize  = 0, BYTE, WORD, DWORD (set wflag)


;-86 */


;-87 int getOp() {
 LEAVE
 ret
; ENDP

getOp:  ; *** PROC ***

;-88 //set: op1=0,IMM,REG,ADR,MEM


;-89   disp=0; imme=0; regindexbase=0;

 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov word [imme], ax
 mov eax, 0
 mov byte [regindexbase], al

;-90 


;-91   Op1=getOp1();

 call getOp1
 mov byte [Op1], al

;-92   if (isToken('[')) {Op1 = MEM; getMEM();  return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je @@getOp22
 mov eax, 4
 mov byte [Op1], al
 call getMEM
 jmp @@retn

;-93   if (Op1 == 0) error1("Name of operand expected");

@@getOp22:
 mov al, [Op1]
 cmp al, 0
 jne @@getOp23
 push getOp_0
 call error1
 add  sp, 2

;-94   if (Op1 == IMM) {imme=SymbolInt;         return;}

@@getOp23:
 mov al, [Op1]
 cmp al, 1
 jne @@getOp24
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp @@retn

;-95   if (Op1 == REG)                          return;

@@getOp24:
 mov al, [Op1]
 cmp al, 2
 jne @@getOp25
 jmp @@retn

;-96   if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;}

@@getOp25:
 mov al, [Op1]
 cmp al, 3
 jne @@getOp26
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp @@retn

;-97   error1("Name of operand expected #1");

@@getOp26:
 push getOp_1
 call error1
 add  sp, 2

;-98 }


;-99 


;-100 int getOp1() {//scan for a single operand

@@retn:
 ret
; ENDP
getOp_0 db "Name of operand expected",0
getOp_1 db "Name of operand expected #1",0

getOp1:  ; *** PROC ***

;-101 //return:0, IMM, REG, ADR (not MEM)


;-102 //set   :RegType, RegNo by testReg


;-103 //set   :LabelIx by searchLabel


;-104   if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne @@getOp127
 mov eax, 0
 jmp @@retn

;-105   if (TokeType == DIGIT)  return IMM;

@@getOp127:
 mov al, [TokeType]
 cmp al, 1
 jne @@getOp128
 mov eax, 1
 jmp @@retn

;-106   if (TokeType == ALNUME) {

@@getOp128:
 mov al, [TokeType]
 cmp al, 3
 jne @@getOp129

;-107     RegNo=testReg();

 call testReg
 mov byte [RegNo], al

;-108     if (RegType)          return REG;

 mov al, [RegType]
 or  al, al
 je @@getOp130
 mov eax, 2
 jmp @@retn

;-109     LabelIx=searchLabel();

@@getOp130:
 call searchLabel
 mov word [LabelIx], ax

;-110     if (LabelIx)          return ADR;

 mov ax, [LabelIx]
 or  al, al
 je @@getOp131
 mov eax, 3
 jmp @@retn

;-111     else error1("variable not found"); 

 jmp @@getOp132
@@getOp131:
 push getOp1_0
 call error1
 add  sp, 2

;-112   }

@@getOp132:

;-113   return 0;

@@getOp129:
 mov eax, 0
 jmp @@retn

;-114 }


;-115 


;-116 int getMEM() {// e.g. [array+bp+si-4]

@@retn:
 ret
; ENDP
getOp1_0 db "variable not found",0

getMEM:  ; *** PROC ***

;-117 //set: disp, regindexbase, RegType


;-118   char op2;


;-119   disp=0; regindexbase=0; RegType=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   118 NULL bp-2    op2;
 ENTER  2,0
 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov byte [regindexbase], al
 mov eax, 0
 mov byte [RegType], al

;-120   do {

@@getMEM33:

;-121     getTokeType();

 call getTokeType

;-122     op2=getOp1();

 call getOp1
 mov byte [bp-2], al

;-123     if (op2 ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne @@getMEM34
 call syntaxerror

;-124     if (op2 == REG) if (regindexbase) regindexbase=getIndReg2();

@@getMEM34:
 mov al, [bp-2]
 cmp al, 2
 jne @@getMEM35
 mov al, [regindexbase]
 or  al, al
 je @@getMEM36
 call getIndReg2
 mov byte [regindexbase], al

;-125                     else getIndReg1();

 jmp @@getMEM37
@@getMEM36:
 call getIndReg1

;-126     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];

@@getMEM37:
@@getMEM35:
 mov al, [bp-2]
 cmp al, 3
 jne @@getMEM38
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-127     if (op2 == IMM) disp=disp+SymbolInt;

@@getMEM38:
 mov al, [bp-2]
 cmp al, 1
 jne @@getMEM39
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-128     if (isToken('-')) {

@@getMEM39:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM40

;-129       getTokeType();

 call getTokeType

;-130       if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  @@getMEM41
 call numbererror

;-131       disp = disp - SymbolInt;

@@getMEM41:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-132     }


;-133   } while (isToken('+'));

@@getMEM40:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM42
 jmp @@getMEM33
@@getMEM42:

;-134   if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne @@getMEM43
 push getMEM_0
 call errorexit
 add  sp, 2

;-135 }

@@getMEM43:

;-136 int getIndReg1() {
 LEAVE
 ret
; ENDP
getMEM_0 db "] expected",0

getIndReg1:  ; *** PROC ***

;-137   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg144
 call indexerror

;-138   if (RegNo==3) regindexbase=7;//BX

@@getIndReg144:
 mov al, [RegNo]
 cmp al, 3
 jne @@getIndReg145
 mov eax, 7
 mov byte [regindexbase], al

;-139   if (RegNo==5) regindexbase=6;//BP, change to BP+0

@@getIndReg145:
 mov al, [RegNo]
 cmp al, 5
 jne @@getIndReg146
 mov eax, 6
 mov byte [regindexbase], al

;-140   if (RegNo==7) regindexbase=5;//DI

@@getIndReg146:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg147
 mov eax, 5
 mov byte [regindexbase], al

;-141   if (RegNo==6) regindexbase=4;//SI

@@getIndReg147:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg148
 mov eax, 4
 mov byte [regindexbase], al

;-142   if (regindexbase==0) indexerror();

@@getIndReg148:
 mov al, [regindexbase]
 cmp al, 0
 jne @@getIndReg149
 call indexerror

;-143 }

@@getIndReg149:

;-144 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
; ENDP

getIndReg2:  ; *** PROC ***
;Function : getIndReg2, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   144 NULL bp-2    m;
 ENTER  2,0
 mov eax, 4
 mov byte [bp-2], al

;-145   if (RegType !=WORD) indexerror();

 mov al, [RegType]
 cmp al, 2
 je  @@getIndReg250
 call indexerror

;-146   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI

@@getIndReg250:
 mov al, [RegNo]
 cmp al, 7
 jne @@getIndReg251
 mov al, [regindexbase]
 cmp al, 6
 jne @@getIndReg252
 mov eax, 3
 mov byte [bp-2], al

;-147            else if (regindexbase==7) m=1;//BX+DI

 jmp @@getIndReg253
@@getIndReg252:
 mov al, [regindexbase]
 cmp al, 7
 jne @@getIndReg254
 mov eax, 1
 mov byte [bp-2], al

;-148   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI

@@getIndReg254:
@@getIndReg253:
@@getIndReg251:
 mov al, [RegNo]
 cmp al, 6
 jne @@getIndReg255
 mov al, [regindexbase]
 cmp al, 6
 jne @@getIndReg256
 mov eax, 2
 mov byte [bp-2], al

;-149            else if (regindexbase==7) m=0;//BX+SI

 jmp @@getIndReg257
@@getIndReg256:
 mov al, [regindexbase]
 cmp al, 7
 jne @@getIndReg258
 mov eax, 0
 mov byte [bp-2], al

;-150   if (m > 3) indexerror();

@@getIndReg258:
@@getIndReg257:
@@getIndReg255:
 mov al, [bp-2]
 cmp al, 3
 jle @@getIndReg259
 call indexerror

;-151   return m;

@@getIndReg259:
 mov al, [bp-2]
 jmp @@retn

;-152 }


;-153 


;-154 // generate code ...........................................................


;-155 int genInstruction(char No, int loc) {

@@retn: LEAVE
 ret
; ENDP

genInstruction:  ; *** PROC ***

;-156   char c;//add OpCodePtr with loc, emits contents  + No


;-157   if(loc) OpCodePtr=OpCodePtr+loc;

;Function : genInstruction, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign byte   155 NULL bp+4    No
;  201 var sign word   155 NULL bp+6    loc
;  202 var sign byte   156 NULL bp-2    c;
 ENTER  2,0
 mov ax, [bp+6]
 or  al, al
 je @@genInstruction60
 mov ax, [OpCodePtr]
 add ax, [bp+6]
 mov word [OpCodePtr], ax

;-158   c= *OpCodePtr + No;

@@genInstruction60:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 add al, [bp+4]
 mov byte [bp-2], al

;-159   genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-160 }


;-161 int gen66h() {genCode8(0x66);
 LEAVE
 ret
; ENDP

gen66h:  ; *** PROC ***
 push 102
 call genCode8
 add  sp, 2

;-162 }


;-163 int genCode8(char c) {

 ret
; ENDP

genCode8:  ; *** PROC ***

;-164 //set: BinLen++, OpPrintIndex++


;-165   FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   163 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-166   BinLen++;

 inc  word [BinLen]

;-167   PC++;

 inc  word [PC]

;-168   if (OpPrintIndex < OPMAXLEN) {

 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode861

;-169     OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-170     OpPrintIndex++;

 inc  word [OpPrintIndex]

;-171   }


;-172 }

@@genCode861:

;-173 int genCode16(int i) {
 LEAVE
 ret
; ENDP

genCode16:  ; *** PROC ***

;-174   genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   173 NULL bp+4    i;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov word [bp+4], ax

;-175   genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-176 }


;-177 int genCodeInREG() {char x; //get Code for second byte
 LEAVE
 ret
; ENDP

genCodeInREG:  ; *** PROC ***

;-178   OpCodePtr++;

;Function : genCodeInREG, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   177 NULL bp-2    x;
 ENTER  2,0
 inc  word [OpCodePtr]

;-179   x= *OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-180   writeEA(x);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-181 }


;-182 int genModRegRM(){ writeEA(regindexbase);//todo
 LEAVE
 ret
; ENDP

genModRegRM:  ; *** PROC ***
 mov al, byte [regindexbase]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-183 }


;-184 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase

 ret
; ENDP

writeEA:  ; *** PROC ***

;-185   char len;


;-186   len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte   184 NULL bp+4    xxx
;  201 var sign byte   185 NULL bp-2    len;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-187   xxx = xxx << 3;//in regindexbase field of mod r/m

 mov al, [bp+4]
 shl al, 3
 mov byte [bp+4], al

;-188   if (Op1 ==   0) addrexit();

 mov al, [Op1]
 cmp al, 0
 jne @@writeEA62
 call addrexit

;-189   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} //2

@@writeEA62:
 mov al, [Op1]
 cmp al, 2
 jne @@writeEA63
 or  byte [bp+4], 192
 mov al, [bp+4]
 add al, [RegNo]
 mov byte [bp+4], al

;-190   if (Op1 == ADR) {xxx |= 6; len=2; }               //3

@@writeEA63:
 mov al, [Op1]
 cmp al, 3
 jne @@writeEA64
 or  byte [bp+4], 6
 mov eax, 2
 mov byte [bp-2], al

;-191   if (Op1 == MEM) { xxx = xxx + regindexbase;       //4

@@writeEA64:
 mov al, [Op1]
 cmp al, 4
 jne @@writeEA65
 mov al, [bp+4]
 add al, [regindexbase]
 mov byte [bp+4], al

;-192     if (disp) {

 mov ax, [disp]
 or  al, al
 je @@writeEA66

;-193       disp;

 mov ax, [disp]

;-194       if(ax > 127) len=2;

 cmp  ax, 127
 jle @@writeEA67
 mov eax, 2
 mov byte [bp-2], al

;-195       else len=1;

 jmp @@writeEA68
@@writeEA67:
 mov eax, 1
 mov byte [bp-2], al

;-196       if (len == 1) xxx |= 0x40;

@@writeEA68:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA69
 or  byte [bp+4], 64

;-197       else xxx |= 0x80;

 jmp @@writeEA70
@@writeEA69:
 or  byte [bp+4], 128

;-198     }

@@writeEA70:

;-199   }

@@writeEA66:

;-200   genCode8(xxx);// gen second byte

@@writeEA65:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-201   if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA71
 push word [disp]
 call genCode8
 add  sp, 2

;-202   if (len == 2) genCode16(disp);

@@writeEA71:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA72
 push word [disp]
 call genCode16
 add  sp, 2

;-203 }

@@writeEA72:

;-204 


;-205 int testx() { __asm {
 LEAVE
 ret
; ENDP

testx:  ; *** PROC ***


;-206 inc byte [Version1]   ;FE 06 [1000]

inc byte [Version1]   ;FE 06 [1000]

;-207 add bx, ax    ;01 C3

add bx, ax    ;01 C3

;-208 add ax, bx    ;01 D8

add ax, bx    ;01 D8

;-209 add word ax, [bx] ;03 07

add word ax, [bx] ;03 07

;-210 VA dw 8

VA dw 8

;-211 mov byte [bp- 4], al ;88 46 FC

mov byte [bp- 4], al ;88 46 FC

;-212 mov      [VA+bx], al ;88 87 [300F]

mov      [VA+bx], al ;88 87 [300F]

;-213 }  



;-214 }


;-215 #include "PARSE.C"

 ret
; ENDP
;Use include file: PARSE.C

;-1 int parse() {


parse:  ; *** PROC ***

;-2   LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-3   do {

@@parse73:

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
 jne @@parse74

;-9       if (isLabel) { //set in getName

 mov al, [isLabel]
 or  al, al
 je @@parse75

;-10         storeLabel();

 call storeLabel

;-11         InputPtr++;//remove :

 inc  word [InputPtr]

;-12         getTokeType();

 call getTokeType

;-13       }


;-14     }

@@parse75:

;-15     if (TokeType == ALNUME) {

@@parse74:
 mov al, [TokeType]
 cmp al, 3
 jne @@parse76

;-16       lookCode();// and OpCodePtr

 call lookCode

;-17       if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je @@parse77
 call process

;-18       else getVariable();

 jmp @@parse78
@@parse77:
 call getVariable

;-19       skipRest();

@@parse78:
 call skipRest

;-20     }


;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp @@parse79
@@parse76:
 mov al, [TokeType]
 cmp al, 3
 jle @@parse80
 push parse_0
 call error1
 add  sp, 2

;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");

 jmp @@parse81
@@parse80:
 mov al, [TokeType]
 cmp al, 1
 jne @@parse82
 push parse_1
 call error1
 add  sp, 2

;-23     printLine();

@@parse82:
@@parse81:
@@parse79:
 call printLine

;-24   } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  @@parse83
 jmp @@parse73
@@parse83:

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
 jne @@getTokeType84
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-31   if (c == ';') {TokeType=0; return; }//comment

@@getTokeType84:
 mov al, [bp-2]
 cmp al, 59
 jne @@getTokeType85
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

@@getTokeType85:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getTokeType86
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov eax, 1
 mov byte [TokeType], al
 jmp @@retn

;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

@@getTokeType86:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@getTokeType87
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov eax, 3
 mov byte [TokeType], al
 jmp @@retn

;-34   TokeType=NOALNUME; return;

@@getTokeType87:
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
 je @@storeLabel88
 push storeLabel_0
 call error1
 add  sp, 2

;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);

@@storeLabel88:
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

@@searchLabel89:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel90

;-48     if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel91
 mov ax, [bp-2]
 jmp @@retn

;-49     j=strlen(p);

@@searchLabel91:
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

 jmp @@searchLabel89
@@searchLabel90:
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
 jne @@getVariable92

;-57     lookCode();

 call lookCode

;-58     if (CodeType < 200) errorexit("D or RES B,W,D expected");

 mov al, [CodeType]
 cmp al, 200
 jge @@getVariable93
 push getVariable_0
 call errorexit
 add  sp, 2

;-59     if (CodeType > 207) errorexit("D or RES B,W,D expected");

@@getVariable93:
 mov al, [CodeType]
 cmp al, 207
 jle @@getVariable94
 push getVariable_1
 call errorexit
 add  sp, 2

;-60     if (CodeType== 200) {// DB

@@getVariable94:
 mov al, [CodeType]
 cmp al, 200
 jne @@getVariable95

;-61       do { getTokeType();

@@getVariable96:
 call getTokeType

;-62         if (TokeType ==DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable97
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-63         else {

 jmp @@getVariable98
@@getVariable97:

;-64           skipBlank();

 call skipBlank

;-65           if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable99

;-66             do { c= *InputPtr;

@@getVariable100:
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
 je  @@getVariable101
 jmp @@getVariable100
@@getVariable101:

;-70             InputPtr++;

 inc  word [InputPtr]

;-71           }


;-72         }

@@getVariable99:

;-73       } while (isToken(','));

@@getVariable98:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable102
 jmp @@getVariable96
@@getVariable102:

;-74     }


;-75     if (CodeType== 201) {// DW

@@getVariable95:
 mov al, [CodeType]
 cmp al, 201
 jne @@getVariable103

;-76       do { getTokeType();

@@getVariable104:
 call getTokeType

;-77         if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable105
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-78       } while (isToken(','));

@@getVariable105:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable106
 jmp @@getVariable104
@@getVariable106:

;-79     }


;-80   }

@@getVariable103:

;-81   else errorexit("DB,DW,DD or RESB,W,D expected");

 jmp @@getVariable107
@@getVariable92:
 push getVariable_2
 call errorexit
 add  sp, 2

;-82 }

@@getVariable107:

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

@@lookCode108:

;-88     if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode109

;-89       while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode110:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode111
 inc  word [OpCodePtr]

;-90       OpCodePtr++; CodeType =*OpCodePtr;

 jmp @@lookCode110
@@lookCode111:
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-91       return;

 jmp @@retn

;-92     }


;-93   while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode109:
@@lookCode112:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode113
 inc  word [OpCodePtr]

;-94   OpCodePtr++;

 jmp @@lookCode112
@@lookCode113:
 inc  word [OpCodePtr]

;-95   } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode114
 jmp @@lookCode108
@@lookCode114:

;-96 }


;-97 int getCodeSize() {

@@retn:
 ret
; ENDP

getCodeSize:  ; *** PROC ***

;-98   if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@getCodeSize115

;-99     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize116
 call getTokeType
 mov eax, 1
 jmp @@retn

;-100     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

@@getCodeSize116:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize117
 call getTokeType
 mov eax, 2
 jmp @@retn

;-101     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

@@getCodeSize117:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize118
 call getTokeType
 mov eax, 3
 jmp @@retn

;-102   } return 0;

@@getCodeSize118:
@@getCodeSize115:
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
 jne @@isToken119

;-107     InputPtr++; return 1;} return 0;

 inc  word [InputPtr]
 mov eax, 1
 jmp @@retn
@@isToken119:
 mov eax, 0
 jmp @@retn

;-108 }


;-109 int skipRest() {

@@retn: LEAVE
 ret
; ENDP

skipRest:  ; *** PROC ***

;-110   getTokeType(); if(TokeType!=0)error1("extra char ignored");

 call getTokeType
 mov al, [TokeType]
 cmp al, 0
 je  @@skipRest120
 push skipRest_0
 call error1
 add  sp, 2

;-111 }

@@skipRest120:
 ret
; ENDP
skipRest_0 db "extra char ignored",0
;Back to main program: AS.C

;-216 #include "HELPER.C"

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

;-29   if (c=='?') return 1;

@@letterE130:
 mov al, [bp+4]
 cmp al, 63
 jne @@letterE131
 mov eax, 1
 jmp @@retn

;-30   if (c=='$') return 1;

@@letterE131:
 mov al, [bp+4]
 cmp al, 36
 jne @@letterE132
 mov eax, 1
 jmp @@retn

;-31   if (c> 'z') return 0;

@@letterE132:
 mov al, [bp+4]
 cmp al, 122
 jle @@letterE133
 mov eax, 0
 jmp @@retn

;-32   if (c< '@') return 0; // at included

@@letterE133:
 mov al, [bp+4]
 cmp al, 64
 jge @@letterE134
 mov eax, 0
 jmp @@retn

;-33   if (c> 'Z') { if (c< 'a') return 0; }

@@letterE134:
 mov al, [bp+4]
 cmp al, 90
 jle @@letterE135
 mov al, [bp+4]
 cmp al, 97
 jge @@letterE136
 mov eax, 0
 jmp @@retn
@@letterE136:

;-34   return 1;

@@letterE135:
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
 je @@alnumE137
 mov eax, 1
 jmp @@retn

;-38   if (letterE(c)) return 1;

@@alnumE137:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@alnumE138
 mov eax, 1
 jmp @@retn

;-39   return 0;

@@alnumE138:
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

@@getDigit139:

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
 je @@getDigit140
 jmp @@getDigit139
@@getDigit140:

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

@@getName141:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je @@getName142

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

 jmp @@getName141
@@getName142:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName143
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName144
@@getName143:
 mov eax, 0
 mov byte [isLabel], al

;-65   p--;

@@getName144:
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
 jge @@testReg145
 mov eax, 0
 jmp @@retn

;-74   if (strlen(Symbol) > 3) return 0;

@@testReg145:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg146
 mov eax, 0
 jmp @@retn

;-75   RegType=BYTE;

@@testReg146:
 mov eax, 1
 mov byte [RegType], al

;-76   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg147
 mov eax, 0
 jmp @@retn

;-77   if (eqstr(SymbolUpper, "CL")) return 1;

@@testReg147:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg148
 mov eax, 1
 jmp @@retn

;-78   if (eqstr(SymbolUpper, "DL")) return 2;

@@testReg148:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg149
 mov eax, 2
 jmp @@retn

;-79   if (eqstr(SymbolUpper, "BL")) return 3;

@@testReg149:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg150
 mov eax, 3
 jmp @@retn

;-80   if (eqstr(SymbolUpper, "AH")) return 4;

@@testReg150:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg151
 mov eax, 4
 jmp @@retn

;-81   if (eqstr(SymbolUpper, "CH")) return 5;

@@testReg151:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg152
 mov eax, 5
 jmp @@retn

;-82   if (eqstr(SymbolUpper, "DH")) return 6;

@@testReg152:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg153
 mov eax, 6
 jmp @@retn

;-83   if (eqstr(SymbolUpper, "BH")) return 7;

@@testReg153:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg154
 mov eax, 7
 jmp @@retn

;-84   RegType=WORD;

@@testReg154:
 mov eax, 2
 mov byte [RegType], al

;-85   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 0
 jmp @@retn

;-86   if (eqstr(SymbolUpper, "CX")) return 1;

@@testReg155:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg156
 mov eax, 1
 jmp @@retn

;-87   if (eqstr(SymbolUpper, "DX")) return 2;

@@testReg156:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg157
 mov eax, 2
 jmp @@retn

;-88   if (eqstr(SymbolUpper, "BX")) return 3;

@@testReg157:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg158
 mov eax, 3
 jmp @@retn

;-89   if (eqstr(SymbolUpper, "SP")) return 4;

@@testReg158:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg159
 mov eax, 4
 jmp @@retn

;-90   if (eqstr(SymbolUpper, "BP")) return 5;

@@testReg159:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg160
 mov eax, 5
 jmp @@retn

;-91   if (eqstr(SymbolUpper, "SI")) return 6;

@@testReg160:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg161
 mov eax, 6
 jmp @@retn

;-92   if (eqstr(SymbolUpper, "DI")) return 7;

@@testReg161:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg162
 mov eax, 7
 jmp @@retn

;-93   RegType=SEGREG;

@@testReg162:
 mov eax, 4
 mov byte [RegType], al

;-94   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg163
 mov eax, 0
 jmp @@retn

;-95   if (eqstr(SymbolUpper, "CS")) return 1;

@@testReg163:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg164
 mov eax, 1
 jmp @@retn

;-96   if (eqstr(SymbolUpper, "SS")) return 2;

@@testReg164:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg165
 mov eax, 2
 jmp @@retn

;-97   if (eqstr(SymbolUpper, "DS")) return 3;

@@testReg165:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg166
 mov eax, 3
 jmp @@retn

;-98   if (eqstr(SymbolUpper, "FS")) return 4;

@@testReg166:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg167
 mov eax, 4
 jmp @@retn

;-99   if (eqstr(SymbolUpper, "GS")) return 5;

@@testReg167:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg168
 mov eax, 5
 jmp @@retn

;-100   RegType=DWORD;

@@testReg168:
 mov eax, 3
 mov byte [RegType], al

;-101   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg169
 mov eax, 0
 jmp @@retn

;-102   if (eqstr(SymbolUpper, "ECX"))return 1;

@@testReg169:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg170
 mov eax, 1
 jmp @@retn

;-103   if (eqstr(SymbolUpper, "EDX"))return 2;

@@testReg170:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg171
 mov eax, 2
 jmp @@retn

;-104   if (eqstr(SymbolUpper, "EBX"))return 3;

@@testReg171:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg172
 mov eax, 3
 jmp @@retn

;-105   if (eqstr(SymbolUpper, "ESP"))return 4;

@@testReg172:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg173
 mov eax, 4
 jmp @@retn

;-106   if (eqstr(SymbolUpper, "EBP"))return 5;

@@testReg173:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg174
 mov eax, 5
 jmp @@retn

;-107   if (eqstr(SymbolUpper, "ESI"))return 6;

@@testReg174:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg175
 mov eax, 6
 jmp @@retn

;-108   if (eqstr(SymbolUpper, "EDI"))return 7;

@@testReg175:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg176
 mov eax, 7
 jmp @@retn

;-109   RegType=0; return 0;

@@testReg176:
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

;-217 #include "OUTPUT.C"

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
 jne @@printLine177
 push printLine_1
 call prs
 add  sp, 2

;-4   else {

 jmp @@printLine178
@@printLine177:

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

@@printLine179:

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
 jge @@printLine180
 jmp @@printLine179
@@printLine180:

;-12     do {// fill rest with blank

@@printLine181:

;-13       prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-14       i++;

 inc  word [bp-2]

;-15     } while(i < OPMAXLEN);

 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine182
 jmp @@printLine181
@@printLine182:

;-16   }


;-17   prscomment(InputBuf);

@@printLine178:
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
 je @@prc183
cmp byte [bp+4], 10
 jne @@prc184
 mov  ax, 13
 call writetty

;-20      al=c; writetty(); }

@@prc184:
 mov  al, [bp+4]
 call writetty

;-21    fputcR(c,lst_fd); }

@@prc183:
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
@@prscomment185:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment186
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

 jmp @@prscomment185
@@prscomment186:

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

@@prs187:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs188
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al
 mov al, [bp-2]
 cmp al, 34
 jne @@prs189
 mov ax, [bp-4]
 or  al, al
 je @@prs190
 mov eax, 0
 mov word [bp-4], ax
 jmp @@prs191
@@prs190:
 mov eax, 1
 mov word [bp-4], ax

;-28     if (c==92) { if (com==0) { s++; c=*s;

@@prs191:
@@prs189:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs192
 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs193
 inc  word [bp+4]
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }

 mov al, [bp-2]
 cmp al, 110
 jne @@prs194
 mov eax, 10
 mov byte [bp-2], al
@@prs194:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs195
 mov eax, 9
 mov byte [bp-2], al
@@prs195:
@@prs193:
@@prs192:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
 inc  word [bp+4]

;-30 }

 jmp @@prs187
@@prs188:

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
 jle @@printhex8a196
 add  word [bp-2], 7
@@printhex8a196:
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
 jle @@printhex8a197
 add  word [bp-2], 7
@@printhex8a197:
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
 jb  @@printIntU198
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

@@printIntU198:
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

;-57 int addrexit(){errorexit("illegal address");}
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
addrexit_0 db "illegal address",0

internexit:  ; *** PROC ***
 push internexit_0
 call errorexit
 add  sp, 2
 ret
; ENDP
internexit_0 db "intern compiler error",0
;Back to main program: AS.C

;-218 #include "MAIN.C"

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
 jne @@getarg199

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

@@getarg199:
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
 je @@getarg200
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

@@getarg200:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-18   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg201
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

@@getarg201:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-20   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg202
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

@@getarg202:
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
 je @@epilog203
 push epilog_1
 call prs
 add  sp, 2

;-29   prs(", Label & Var: ");

@@epilog203:
 push epilog_2
 call prs
 add  sp, 2

;-30   if (LabelMaxIx) {

 mov ax, [LabelMaxIx]
 or  al, al
 je @@epilog204

;-31     i = 1;

 mov eax, 1
 mov word [bp-2], ax

;-32     LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-33     do {

@@epilog205:

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
 jg  @@epilog206
 jmp @@epilog205
@@epilog206:

;-41   }


;-42   prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");

@@epilog204:
 push epilog_4
 call prs
 add  sp, 2
 push word [BinLen]
 call printIntU
 add  sp, 2
 push epilog_5
 call prs
 add  sp, 2

;-43   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-44   do { prc(' '); j = FileBin[i]; printhex8a(j); i++;

@@epilog207:
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

;-45   } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog208
 jmp @@epilog207
@@epilog208:

;-46   i=0;

 mov eax, 0
 mov word [bp-2], ax

;-47   do {

@@epilog209:

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
 jge @@epilog210
 jmp @@epilog209
@@epilog210:

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

;-219 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-220 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   220 NULL bp+4    s
;  201 var sign byte   220 NULL bp-2    c;
 ENTER  2,0
@@cputs211:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs212
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
 jmp @@cputs211
@@cputs212:

;-221 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   221 NULL bp+4    s;
 ENTER  0,0
@@toupper213:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper214
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper215
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper216
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper216:
@@toupper215:
 inc  word [bp+4]
 jmp @@toupper213
@@toupper214:

;-222 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-223 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   223 NULL bp+4    s
;  201 var sign word   223 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen217:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen218
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen217
@@strlen218:
 mov ax, [bp-2]
 jmp @@retn

;-224 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    5 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   224 NULL bp+4    s
;  201 ptr sign byte   224 NULL bp+6    t;
 ENTER  0,0
@@strcpy219:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-225   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy220
 jmp @@strcpy219
@@strcpy220:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-226 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   226 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit221
 mov eax, 0
 jmp @@retn
@@digit221:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit222
 mov eax, 0
 jmp @@retn
@@digit222:
 mov eax, 1
 jmp @@retn

;-227 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   227 NULL bp+4    p
;  201 ptr sign byte   227 NULL bp+6    q;
 ENTER  0,0
@@eqstr223:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr224

;-228     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr225
 mov eax, 0
 jmp @@retn
@@eqstr225:
 inc  word [bp+4]
 inc  word [bp+6]

;-229     if(*q) return 0; return 1; }

 jmp @@eqstr223
@@eqstr224:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr226
 mov eax, 0
 jmp @@retn
@@eqstr226:
 mov eax, 1
 jmp @@retn

;-230 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   230 NULL bp+4    s
;  201 ptr sign byte   230 NULL bp+6    t;
 ENTER  0,0
@@strcat1227:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1228
 inc  word [bp+4]
 jmp @@strcat1227
@@strcat1228:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-231 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   231 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-232 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   232 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-233 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   233 NULL bp+4    s
;  201 var sign word   233 NULL bp+6    fd
;  202 var sign word   233 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-234 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   234 NULL bp+4    n
;  201 var sign word   234 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-235   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-236 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   236 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-237 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   237 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-238 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
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

;-239 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   239 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch229
 mov  al, 13
 call writetty
@@putch229:
 mov  al, [bp+4]
 call writetty

;-240 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt230
 inc  word [DOS_ERR]
@@DosInt230:

;-241 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

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
;   27 var sign byte    27   20        0 TokeType
;   28 def unsg byte    28    -        0 BYTE=1
;   29 def unsg byte    29    -        0 WORD=2
;   30 def unsg byte    30    -        0 DWORD=3
;   31 def unsg byte    31    -        0 SEGREG=4
;   32 def unsg byte    33    -        0 IMM=1
;   33 def unsg byte    34    -        0 REG=2
;   34 def unsg byte    35    -        0 ADR=3
;   35 def unsg byte    36    -        0 MEM=4
;   36 var sign byte    37   13        0 Op1
;   37 var sign byte    38   12        0 CodeType
;   38 var sign byte    40   17        0 RegType
;   39 var sign byte    41   10        0 RegNo
;   40 var sign byte    42   10        0 OpSize
;   41 var sign byte    43    5        0 wflag
;   42 var sign byte    48   15        0 regindexbase
;   43 var sign word    49   13        0 disp
;   44 var sign word    50    2        0 imme
;   45 def unsg byte    52    -        0 OPMAXLEN=5
;   46 arr sign byte    53    2    30390 OpPos[5]
;   47 var sign word    54    6        0 OpPrintIndex
;   48 ptr sign byte    55   16        0 OpCodePtr
;   49 var sign byte    56    2        0 PrintR
;   50 def unsg byte    58    -        0 LABELNAMESMAX=969
;   51 arr sign byte    59    3    30395 LabelNames[1000]
;   52 ptr sign byte    60   10        0 LabelNamePtr
;   53 def unsg byte    61    -        0 LABELADRMAX=100
;   54 arr unsg word    62    4    31395 LabelAddr[100]
;   55 var sign word    63    5        0 LabelMaxIx
;   56 var sign word    64    4        0 LabelIx
;   57 def unsg byte    66    -        0 FILEBINMAX=1990
;   58 arr sign byte    67    3    31595 FileBin[2000]
;   59 var unsg word    68    5        0 BinLen
;   60 ptr sign byte    70    1        0 arglen
;   61 ptr sign byte    71    4        0 argv
;   62 var sign byte     1    1        0 I_START
;   63 arr sign byte     4 NULL        0 I_PUSHA[9]
;   64 arr sign byte     5 NULL        0 I_POPA[8]
;   65 arr sign byte     6 NULL        0 I_NOP[7]
;   66 arr sign byte     7 NULL        0 I_CBW[7]
;   67 arr sign byte     8 NULL        0 I_CWDE[8]
;   68 arr sign byte     9 NULL        0 I_CWD[7]
;   69 arr sign byte    10 NULL        0 I_CDQ[7]
;   70 arr sign byte    11 NULL        0 I_WAIT[8]
;   71 arr sign byte    12 NULL        0 I_PUSHF[9]
;   72 arr sign byte    13 NULL        0 I_POPF[8]
;   73 arr sign byte    14 NULL        0 I_SAHF[8]
;   74 arr sign byte    15 NULL        0 I_LAHF[8]
;   75 arr sign byte    16 NULL        0 I_MOVSB[9]
;   76 arr sign byte    17 NULL        0 I_MOVSW[9]
;   77 arr sign byte    18 NULL        0 I_CMPSB[9]
;   78 arr sign byte    19 NULL        0 I_CMPSW[9]
;   79 arr sign byte    20 NULL        0 I_STOSB[9]
;   80 arr sign byte    21 NULL        0 I_STOSW[9]
;   81 arr sign byte    22 NULL        0 I_LODSB[9]
;   82 arr sign byte    23 NULL        0 I_LODSW[9]
;   83 arr sign byte    24 NULL        0 I_SCASB[9]
;   84 arr sign byte    25 NULL        0 I_SCASW[9]
;   85 arr sign byte    26 NULL        0 I_LEAVE[9]
;   86 arr sign byte    27 NULL        0 I_IRET[8]
;   87 arr sign byte    28 NULL        0 I_XLAT[8]
;   88 arr sign byte    29 NULL        0 I_LOCK[8]
;   89 arr sign byte    30 NULL        0 I_REPNE[9]
;   90 arr sign byte    31 NULL        0 I_REPNZ[9]
;   91 arr sign byte    32 NULL        0 I_REPE[8]
;   92 arr sign byte    33 NULL        0 I_REPZ[8]
;   93 arr sign byte    34 NULL        0 I_HLT[7]
;   94 arr sign byte    35 NULL        0 I_CLC[7]
;   95 arr sign byte    36 NULL        0 I_STC[7]
;   96 arr sign byte    37 NULL        0 I_CLI[7]
;   97 arr sign byte    38 NULL        0 I_STI[7]
;   98 arr sign byte    39 NULL        0 I_CLD[7]
;   99 arr sign byte    40 NULL        0 I_STD[7]
;  100 arr sign byte    42 NULL        0 I_INC[9]
;  101 arr sign byte    43 NULL        0 I_DEC[9]
;  102 arr sign byte    45 NULL        0 I_NOT[8]
;  103 arr sign byte    46 NULL        0 I_NEG[8]
;  104 arr sign byte    47 NULL        0 I_MUL[8]
;  105 arr sign byte    48 NULL        0 I_IMUL[9]
;  106 arr sign byte    49 NULL        0 I_DIV[8]
;  107 arr sign byte    50 NULL        0 I_IDIV[9]
;  108 arr sign byte    52 NULL        0 I_LES[7]
;  109 arr sign byte    53 NULL        0 I_LDS[7]
;  110 arr sign byte    54 NULL        0 I_LEA[7]
;  111 arr sign byte    56 NULL        0 I_ADD[7]
;  112 arr sign byte    57 NULL        0 I_OR[6]
;  113 arr sign byte    58 NULL        0 I_ADC[7]
;  114 arr sign byte    59 NULL        0 I_SBB[7]
;  115 arr sign byte    60 NULL        0 I_AND[7]
;  116 arr sign byte    61 NULL        0 I_SUB[7]
;  117 arr sign byte    62 NULL        0 I_XOR[7]
;  118 arr sign byte    63 NULL        0 I_CMP[7]
;  119 arr sign byte    65 NULL        0 I_MOV[6]
;  120 arr sign byte    66 NULL        0 I_MOVSX[9]
;  121 arr sign byte    67 NULL        0 I_MOVZX[9]
;  122 arr sign byte    69 NULL        0 I_JO[6]
;  123 arr sign byte    70 NULL        0 I_JNO[7]
;  124 arr sign byte    71 NULL        0 I_JB[6]
;  125 arr sign byte    72 NULL        0 I_JC[6]
;  126 arr sign byte    73 NULL        0 I_JNB[7]
;  127 arr sign byte    74 NULL        0 I_JAE[7]
;  128 arr sign byte    75 NULL        0 I_JNC[7]
;  129 arr sign byte    76 NULL        0 I_JE[6]
;  130 arr sign byte    77 NULL        0 I_JZ[6]
;  131 arr sign byte    78 NULL        0 I_JNE[7]
;  132 arr sign byte    79 NULL        0 I_JNZ[7]
;  133 arr sign byte    80 NULL        0 I_JBE[7]
;  134 arr sign byte    81 NULL        0 I_JNA[7]
;  135 arr sign byte    82 NULL        0 I_JA[6]
;  136 arr sign byte    83 NULL        0 I_JS[6]
;  137 arr sign byte    84 NULL        0 I_JNS[7]
;  138 arr sign byte    85 NULL        0 I_JP[6]
;  139 arr sign byte    86 NULL        0 I_JPE[7]
;  140 arr sign byte    87 NULL        0 I_JNP[7]
;  141 arr sign byte    88 NULL        0 I_JPO[7]
;  142 arr sign byte    89 NULL        0 I_JL[6]
;  143 arr sign byte    90 NULL        0 I_JNL[7]
;  144 arr sign byte    91 NULL        0 I_JGE[7]
;  145 arr sign byte    92 NULL        0 I_JLE[7]
;  146 arr sign byte    93 NULL        0 I_JNG[7]
;  147 arr sign byte    94 NULL        0 I_JG[6]
;  148 arr sign byte    96 NULL        0 I_JMP[8]
;  149 arr sign byte    97 NULL        0 I_CALL[9]
;  150 arr sign byte    99 NULL        0 I_RET[8]
;  151 arr sign byte   100 NULL        0 I_RETF[9]
;  152 arr sign byte   102 NULL        0 I_PUSH[8]
;  153 arr sign byte   103 NULL        0 I_POP[7]
;  154 arr sign byte   105 NULL        0 I_ROL[7]
;  155 arr sign byte   106 NULL        0 I_ROR[7]
;  156 arr sign byte   107 NULL        0 I_RCL[7]
;  157 arr sign byte   108 NULL        0 I_RCR[7]
;  158 arr sign byte   109 NULL        0 I_SHL[7]
;  159 arr sign byte   110 NULL        0 I_SAL[7]
;  160 arr sign byte   111 NULL        0 I_SHR[7]
;  161 arr sign byte   112 NULL        0 I_SAR[7]
;  162 arr sign byte   114 NULL        0 I_INT[8]
;  163 arr sign byte   115 NULL        0 I_INTO[8]
;  164 arr sign byte   117 NULL        0 I_IN[7]
;  165 arr sign byte   118 NULL        0 I_INSB[8]
;  166 arr sign byte   119 NULL        0 I_INSW[8]
;  167 arr sign byte   120 NULL        0 I_INSD[8]
;  168 arr sign byte   121 NULL        0 I_OUT[8]
;  169 arr sign byte   122 NULL        0 I_OUTSB[8]
;  170 arr sign byte   123 NULL        0 I_OUTSW[8]
;  171 arr sign byte   124 NULL        0 I_OUTSD[8]
;  172 arr sign byte   126 NULL        0 I_XCHG[9]
;  173 arr sign byte   128 NULL        0 I_LOOPNZ[10]
;  174 arr sign byte   129 NULL        0 I_LOOPNE[10]
;  175 arr sign byte   130 NULL        0 I_LOOPZ[9]
;  176 arr sign byte   131 NULL        0 I_LOOPE[9]
;  177 arr sign byte   132 NULL        0 I_LOOP[8]
;  178 arr sign byte   133 NULL        0 I_JCXZ[8]
;  179 arr sign byte   134 NULL        0 I_JECXZ[9]
;  180 arr sign byte   136 NULL        0 I_ENTER[9]
;  181 arr sign byte   138 NULL        0 I_ORG[6]
;  182 arr sign byte   139 NULL        0 I_DB[5]
;  183 arr sign byte   140 NULL        0 I_DW[5]
;  184 arr sign byte   141 NULL        0 I_DD[5]
;  185 arr sign byte   142 NULL        0 I_RESB[7]
;  186 arr sign byte   143 NULL        0 I_RESW[7]
;  187 arr sign byte   144 NULL        0 I_RESD[7]
;  188 var sign byte   145 NULL        0 I_END


;   # Calls Line Width  Name   list of functions

;    0 NULL    1 word   main
;    1    1    6 word   process
;    2    1   48 word   setwflag
;    3 NULL   60 word   Check2Op
;    4    2   62 word   checkLeftOp
;    5 NULL   73 word   saveLeftOp
;    6 NULL   75 word   checkRightOp
;    7    1   87 word   getOp
;    8    2  100 word   getOp1
;    9    1  116 word   getMEM
;   10    1  136 word   getIndReg1
;   11    1  144 word   getIndReg2
;   12    7  155 word   genInstruction
;   13    1  161 word   gen66h
;   14    8  163 word   genCode8
;   15    3  173 word   genCode16
;   16    2  177 word   genCodeInREG
;   17 NULL  182 word   genModRegRM
;   18    2  184 word   writeEA
;   19 NULL  205 word   testx
;   20    1    1 word   parse
;   21   12   27 word   getTokeType
;   22    2   36 word   storeLabel
;   23    2   43 word   searchLabel
;   24    1   54 word   getVariable
;   25    2   83 word   lookCode
;   26    1   97 word   getCodeSize
;   27    7  104 word   isToken
;   28    1  109 word   skipRest
;   29    1    1 word   getLine
;   30    1   14 word   ifEOL
;   31    3   21 word   skipBlank
;   32    2   26 word   letterE
;   33    1   36 word   alnumE
;   34    1   41 word   getDigit
;   35    1   53 word   getName
;   36    1   70 word   testReg
;   37    1    1 word   printLine
;   38    9   19 word   prc
;   39    1   23 word   prscomment
;   40   23   26 word   prs
;   41    4   31 word   printhex8a
;   42    2   35 word   printhex16
;   43    3   38 word   printIntU
;   44   20   45 word   error1
;   45 NULL   48 word   allowederror
;   46 NULL   49 word   implmerror
;   47    4   50 word   indexerror
;   48    1   51 word   numbererror
;   49 NULL   52 word   regmemerror
;   50    1   53 word   segregerror
;   51    1   54 word   syntaxerror
;   52    7   56 word   errorexit
;   53    1   57 word   addrexit
;   54 NULL   58 word   internexit
;   55    1    1 word   getarg
;   56    1   26 word   epilog
;   57    2   53 word   end1
;   58    4  219 word   writetty
;   59    8  220 word   cputs
;   60    2  221 word   toupper
;   61    4  223 word   strlen
;   62    6  224 word   strcpy
;   63    3  226 word   digit
;   64   35  227 word   eqstr
;   65    3  230 word   strcat1
;   66    1  231 word   openR
;   67    2  232 word   creatR
;   68    2  233 word   readRL
;   69    2  234 word   fputcR
;   70    3  236 word   fcloseR
;   71    5  237 word   exitR
;   72    1  239 word   putch
;   73    4  240 word   DosInt
;   74 NULL  241 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0     5 getarg
;    1    12 parse
;    2    18 epilog
;    3    25 end1
;    4  1364 getTokeType
;    5  1376 getCodeSize
;    6  1388 genInstruction
;    7  1403 checkLeftOp
;    8  1415 genInstruction
;    9  1430 genInstruction
;   10  1445 genInstruction
;   11  1460 genCodeInREG
;   12  1473 checkLeftOp
;   13  1485 genInstruction
;   14  1500 genCodeInREG
;   15  1513 genInstruction
;   16  1528 genCode16
;   17  1538 genInstruction
;   18  1553 error1
;   19  1560 error1
;   20  1576 gen66h
;   21  1620 getOp
;   22  1626 segregerror
;   23  1638 setwflag
;   24  1647 error1
;   25  1654 error1
;   26  1661 error1
;   27  1703 getOp1
;   28  1710 isToken
;   29  1718 getMEM
;   30  1725 error1
;   31  1732 error1
;   32  1746 testReg
;   33  1754 searchLabel
;   34  1766 error1
;   35  1784 getTokeType
;   36  1796 getOp1
;   37  1803 syntaxerror
;   38  1815 getIndReg2
;   39  1826 getIndReg1
;   40  1837 isToken
;   41  1845 getTokeType
;   42  1857 numbererror
;   43  1869 isToken
;   44  1877 isToken
;   45  1885 errorexit
;   46  1906 indexerror
;   47  1917 indexerror
;   48  1941 indexerror
;   49  1952 indexerror
;   50  1987 genCode8
;   51  2003 genCode8
;   52  2035 genCode8
;   53  2044 genCode8
;   54  2068 writeEA
;   55  2088 writeEA
;   56  2112 addrexit
;   57  2121 genCode8
;   58  2130 genCode8
;   59  2139 genCode16
;   60  2161 getLine
;   61  2169 getTokeType
;   62  2181 storeLabel
;   63  2192 getTokeType
;   64  2204 lookCode
;   65  2213 process
;   66  2221 getVariable
;   67  2233 skipRest
;   68  2242 error1
;   69  2249 error1
;   70  2256 printLine
;   71  2280 skipBlank
;   72  2290 digit
;   73  2296 getDigit
;   74  2305 letterE
;   75  2313 getName
;   76  2332 searchLabel
;   77  2344 error1
;   78  2351 strcpy
;   79  2378 eqstr
;   80  2384 strlen
;   81  2405 storeLabel
;   82  2416 getTokeType
;   83  2428 lookCode
;   84  2437 errorexit
;   85  2447 errorexit
;   86  2457 getTokeType
;   87  2469 genCode8
;   88  2478 skipBlank
;   89  2488 isToken
;   90  2496 genCode8
;   91  2505 isToken
;   92  2513 getTokeType
;   93  2525 genCode16
;   94  2535 isToken
;   95  2543 errorexit
;   96  2562 eqstr
;   97  2580 eqstr
;   98  2586 getTokeType
;   99  2598 eqstr
;  100  2604 getTokeType
;  101  2616 eqstr
;  102  2622 getTokeType
;  103  2644 skipBlank
;  104  2663 getTokeType
;  105  2675 error1
;  106  2690 readRL
;  107  2697 errorexit
;  108  2707 ifEOL
;  109  2721 readRL
;  110  2757 digit
;  111  2763 letterE
;  112  2790 digit
;  113  2808 alnumE
;  114  2815 strcpy
;  115  2822 toupper
;  116  2838 strlen
;  117  2845 strlen
;  118  2852 eqstr
;  119  2858 eqstr
;  120  2864 eqstr
;  121  2870 eqstr
;  122  2876 eqstr
;  123  2882 eqstr
;  124  2888 eqstr
;  125  2894 eqstr
;  126  2900 eqstr
;  127  2906 eqstr
;  128  2912 eqstr
;  129  2918 eqstr
;  130  2924 eqstr
;  131  2930 eqstr
;  132  2936 eqstr
;  133  2942 eqstr
;  134  2948 eqstr
;  135  2954 eqstr
;  136  2960 eqstr
;  137  2966 eqstr
;  138  2972 eqstr
;  139  2978 eqstr
;  140  2984 eqstr
;  141  2990 eqstr
;  142  2996 eqstr
;  143  3002 eqstr
;  144  3008 eqstr
;  145  3014 eqstr
;  146  3020 eqstr
;  147  3026 eqstr
;  148  3046 prs
;  149  3050 printhex16
;  150  3061 prs
;  151  3065 prc
;  152  3069 printhex8a
;  153  3080 prc
;  154  3084 prs
;  155  3088 prscomment
;  156  3105 writetty
;  157  3114 writetty
;  158  3123 fputcR
;  159  3145 prc
;  160  3161 prc
;  161  3182 prc
;  162  3186 prc
;  163  3208 printhex8a
;  164  3219 printhex8a
;  165  3244 printIntU
;  166  3254 prc
;  167  3267 prs
;  168  3271 prs
;  169  3275 prs
;  170  3279 prs
;  171  3296 error1
;  172  3314 error1
;  173  3332 error1
;  174  3351 error1
;  175  3370 error1
;  176  3389 error1
;  177  3408 error1
;  178  3427 error1
;  179  3434 end1
;  180  3448 errorexit
;  181  3469 errorexit
;  182  3498 cputs
;  183  3504 cputs
;  184  3510 exitR
;  185  3516 toupper
;  186  3524 strcpy
;  187  3531 strcat1
;  188  3539 strcpy
;  189  3546 strcat1
;  190  3554 strcpy
;  191  3561 strcat1
;  192  3569 openR
;  193  3575 cputs
;  194  3581 cputs
;  195  3587 exitR
;  196  3593 creatR
;  197  3600 cputs
;  198  3606 cputs
;  199  3612 exitR
;  200  3618 creatR
;  201  3625 cputs
;  202  3631 cputs
;  203  3637 exitR
;  204  3643 prs
;  205  3647 prs
;  206  3651 prs
;  207  3655 prs
;  208  3659 prs
;  209  3663 prs
;  210  3667 prs
;  211  3671 prs
;  212  3675 prs
;  213  3692 prs
;  214  3696 printIntU
;  215  3706 prs
;  216  3710 prs
;  217  3714 prs
;  218  3718 prc
;  219  3722 printhex16
;  220  3733 prs
;  221  3737 strlen
;  222  3744 prs
;  223  3748 printIntU
;  224  3758 prs
;  225  3762 prc
;  226  3766 printhex8a
;  227  3777 fputcR
;  228  3791 fcloseR
;  229  3799 fcloseR
;  230  3807 fcloseR
;  231  3815 exitR
;  232  3840 putch
;  233  3908 strcpy
;  234  3923 DosInt
;  235  3939 DosInt
;  236  3962 DosInt
;  237  3981 DosInt
;  238  4015 writetty
;  239  4024 writetty
;Input: AS.C, List: AS.S,  Lines:  242
;Glob. variables:  188 max.:  200
;Local variables:    3 max.:  100, in 'genInstruction'
;Functions      :   75 max.:  300
;Calls          :  240 max.: 2000, NameField: 4056 max.:    65535
;Code until     :26009 max.: 30000, free: 3991
;Data (HeapEnd) :33595, resting stacksize: 31940
;Max. Const in 'testReg' :  658 max. 3000, free: 2342