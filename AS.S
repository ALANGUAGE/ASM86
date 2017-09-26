
; A.COM V0.9, Source: AS.C, Output asm: AS.S
org  256 
jmp main

;-1 char Version1[]="AS.C V0.1";//BAS.BAT, AS TE, NAS.BAT

Version1 db "AS.C V0.1",0

;-2 #include "DECL.C"

;Use include file: DECL.C

;-1 char LIST;              ///< listing on/off

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

;-5 char ProcName[SYMBOLMAX];//name of actual proc

section .bss
absolute 30062
ProcName resb 31
section .text

;-6 char isInProc=0;        //is inside a procedure

isInProc db 0

;-7 unsigned int SymbolInt; //integer value set in getDigit

SymbolInt dw 0

;-8 unsigned long SymbolLong;//integer value set in getDigit

SymbolLong dd 0

;-9 #define INPUTBUFMAX 255


;-10 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test

section .bss
absolute 30093
InputBuf resb 255
section .text

;-11 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0

;-12 char namein [67];       //input file name  .S

section .bss
absolute 30348
namein resb 67
section .text

;-13 char namelst[67];       //list file name   .LST

section .bss
absolute 30415
namelst resb 67
section .text

;-14 char namebin[67];       //output file name .COM

section .bss
absolute 30482
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

;-45 char Code2;             //2. Opcode

Code2 db 0

;-46 char Code3;             //3. Opcode

Code3 db 0

;-47 char R2No;              //0 - 7 AL, CL, ...  set in testReg()

R2No db 0

;-48 char R1No;              //temp for 1. register

R1No db 0

;-49 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG

R2Type db 0

;-50 char R1Type;            //temp for 1. register

R1Type db 0

;-51 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0

;-52 char wflag;             //wordflag: 0=byte, 1=word/dword

wflag db 0

;-53 char dflag;             //directionflag: 1=to reg MOV,ALU

dflag db 0

;-54 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3

sflag db 0

;-55 char rm;                //combination of index and base reg

rm db 0

;-56 char isDirect;          //set in process and getMeM, need in WriteEA

isDirect db 0

;-57 int disp;               //displacement      0-8 bytes

disp dw 0

;-58 unsigned int imme;      //immediate         0-8 bytes

imme dw 0

;-59 


;-60 #define OPMAXLEN 5


;-61 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 30549
OpPos resb 5
section .text

;-62 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0

;-63 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0

;-64 char PrintRA;           //print * for forward relocative jmp

PrintRA db 0

;-65 


;-66 #define LABELNAMESMAX 3969//next number - SYMBOLMAX


;-67 char LabelNames[4000];  //space for names of all labels

section .bss
absolute 30554
LabelNames resb 4000
section .text

;-68 char *LabelNamePtr;     //first free position

LabelNamePtr dw 0

;-69 #define LABELADRMAX 600


;-70 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 34554
LabelAddr resw 600
section .text

;-71 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0

;-72 int LabelIx;            //actual # of just searched label

LabelIx dw 0

;-73 


;-74 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX


;-75 char JmpCallNames[2000];//space for names of jmp, call

section .bss
absolute 35754
JmpCallNames resb 2000
section .text

;-76 char *JmpCallNamePtr;   //first free position

JmpCallNamePtr dw 0

;-77 #define JMPCALLMAX 500  //max. jmp and call


;-78 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed

section .bss
absolute 37754
JmpCallAddr resw 500
section .text

;-79 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1

JmpCallMaxIx dw 0

;-80 


;-81 #define FILEBINMAX 20000


;-82 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 38754
FileBin resb 20000
section .text

;-83 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-84 


;-85 char *arglen=0x80;      // for main only

arglen dw 128

;-86 char *argv=0x82;        // for main only

argv dw 130
;Back to main program: AS.C

;-3 #include "OPTABL.C"

;Use include file: OPTABL.C

;-1 char I_START=0xF1;

I_START db 241

;-2 //OpName, 0, CodeType, OpCode1-n, F1h


;-3 //  1:   1 byte opcode


;-4 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-5 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-6 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-7 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-8 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-9 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-10 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-11 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-12 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-13 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-14 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-15 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-16 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-17 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-18 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-19 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-20 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-21 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-22 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-23 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-24 // 2: mem reg 16 bit


;-25 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-26 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-27 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-28 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-29 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-30 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-31 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-32 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-33 //  3: les, lda, lea, lss, lfs, lgs


;-34 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-35 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-36 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-37 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-38 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-39 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-40 //  4: acc,imm  reg,imm  index,reg


;-41 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-42 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-43 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-44 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-45 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-46 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-47 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-48 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-49 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-50 //  5: mov


;-51 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-52 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-53 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-54 //  6: single byte relative jump


;-55 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-56 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-57 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-58 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-59 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-60 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-61 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-62 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-63 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-64 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-65 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-66 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-67 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-68 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-69 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-70 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-71 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-72 //  7: jmp, call


;-73 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-74 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-75 //  8: ret


;-76 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-77 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-78 //  9: seg, r/m


;-79 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,255,6,6,241

;-80 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16

I_POP db 80,79,80,0,9,88,143,0,7,241

;-81 //  11: shift, rotates


;-82 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-83 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-84 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-85 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-86 //  12: int


;-87 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-88 //  14: in/out


;-89 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-90 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-91 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-92 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-93 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-94 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-95 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-96 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-97 //  15: xchg


;-98 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-99 //  16: loop, jcxz


;-100 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-101 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-102 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-103 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-104 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-105 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-106 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-107 //  30: enter


;-108 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-109 // 100: directives


;-110 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-111 // section, segment .TEXT .DATA .BSS


;-112 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-113 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-114 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-115 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-116 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-117 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-118 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-119 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-120 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-121 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-122 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-123 char I_END=0;// end of table char

I_END db 0
;Back to main program: AS.C

;-4 #include "OPS.C"

;Use include file: OPS.C

;-1 int ChangeDirection() {


ChangeDirection: PROC

;-2     char c;


;-3     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte     2 NULL c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-4     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-5     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-6     dflag=2;     

 mov ax, 2
 mov byte [dflag], al

;-7 }


;-8      


;-9 int checkOpL() {
 LEAVE
 ret
ENDP

checkOpL: PROC

;-10     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL1
 call implerror

;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL1:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL2
 call segregerror
 jmp .retncheckOpL

;-12     setwflag();

.checkOpL2:
 call setwflag

;-13     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL3
 push checkOpL_0
 call error1
 add  sp, 2

;-14     if (OpSize == R1Type) return;

.checkOpL3:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL4
 jmp .retncheckOpL

;-15     if (Op == REG) if (R1Type==0) error1("no register defined");

.checkOpL4:
 mov al, [Op]
 cmp al, 2
 jne .checkOpL5
 mov al, [R1Type]
 cmp al, 0
 jne .checkOpL6
 push checkOpL_1
 call error1
 add  sp, 2

;-16 }

.checkOpL6:
.checkOpL5:

;-17     


;-18 int check2Ops() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

check2Ops: PROC

;-19     get2Ops();

 call get2Ops

;-20     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops7
 call addrerror

;-21     if (Op == ADR) invaloperror(); 

.check2Ops7:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops8
 call invaloperror

;-22     if (Op == IMM) immeerror();   

.check2Ops8:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops9
 call immeerror

;-23     if (Op2==   0) addrerror();

.check2Ops9:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops10
 call addrerror

;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov           

.check2Ops10:
 mov al, [CodeType]
 cmp al, 5
 je  .check2Ops11
 mov al, [Op2]
 cmp al, 3
 jne .check2Ops12
 call invaloperror

;-25     setwflag();       

.check2Ops12:
.check2Ops11:
 call setwflag

;-26 }    


;-27 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-28     getOpL();

 call getOpL

;-29     need(',');    

 push 44
 call need
 add  sp, 2

;-30     getOpR();         

 call getOpR

;-31 } 


;-32         


;-33 int getOpL() {

 ret
ENDP

getOpL: PROC

;-34 //set: op=0,IMM,REG,ADR,MEM


;-35     getOpR();

 call getOpR

;-36     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-37     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-38     R1Type=R2Type; R2Type=0; 

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-39 }  


;-40 


;-41 int getOpR() {

 ret
ENDP

getOpR: PROC

;-42     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR13
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-44     if (Op2 == 0)     {invaloperror();         return;}

.getOpR13:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR14
 call invaloperror
 jmp .retngetOpR

;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR14:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR15
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-46     if (Op2 == REG)                            return;

.getOpR15:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR16
 jmp .retngetOpR

;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}

.getOpR16:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR17
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp .retngetOpR

;-48     error1("Name of operand expected");

.getOpR17:
 push getOpR_0
 call error1
 add  sp, 2

;-49 }


;-50 


;-51 int getOp1() {//scan for a single operand

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOp1: PROC

;-52 //return:0, IMM, REG, ADR (not MEM)


;-53 //set   :R2Type, R2No by testReg


;-54 //set   :LabelIx by searchLabel


;-55     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp118
 mov ax, 0
 jmp .retngetOp1

;-56     if (TokeType == DIGIT)  return IMM;

.getOp118:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp119
 mov ax, 1
 jmp .retngetOp1

;-57     if (TokeType == ALNUME) {

.getOp119:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp120

;-58         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-59         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp121
 mov ax, 2
 jmp .retngetOp1

;-60         LabelIx=searchLabel();

.getOp121:
 call searchLabel
 mov word [LabelIx], ax

;-61         if (LabelIx)        return ADR;

 mov ax, [LabelIx]
 or  al, al
 je .getOp122
 mov ax, 3
 jmp .retngetOp1

;-62         else error1("variable not found"); 

 jmp .getOp123
.getOp122:
 push getOp1_0
 call error1
 add  sp, 2

;-63     }

.getOp123:

;-64     return 0;

.getOp120:
 mov ax, 0
 jmp .retngetOp1

;-65 }


;-66 


;-67 int getMEM() {// e.g. [array+bp+si-4]

 .retngetOp1:
 ret
getOp1_0 db "variable not found",0
ENDP

getMEM: PROC

;-68 //set: disp, rm, R2Type


;-69     char c;


;-70     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    69 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-71     do {

.getMEM24:

;-72         getTokeType();

 call getTokeType

;-73         c=getOp1();

 call getOp1
 mov [bp-2], al

;-74         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM25
 call syntaxerror

;-75         if (c == REG) {

.getMEM25:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM26

;-76             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-77             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM27
 call getIndReg2
 mov byte [rm], al

;-78             else getIndReg1();

 jmp .getMEM28
.getMEM27:
 call getIndReg1

;-79         }

.getMEM28:

;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];

.getMEM26:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM29
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-81         if (c == IMM) disp=disp+SymbolInt;

.getMEM29:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM30
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-82         if (isToken('-')) {

.getMEM30:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM31

;-83             getTokeType();

 call getTokeType

;-84             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM32
 call numbererror

;-85             disp = disp - SymbolInt;

.getMEM32:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-86         }


;-87     } while (isToken('+'));

.getMEM31:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM33
 jmp .getMEM24
.getMEM33:

;-88     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM34
 push getMEM_0
 call errorexit
 add  sp, 2

;-89 }

.getMEM34:

;-90 int getIndReg1() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getIndReg1: PROC

;-91     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg135
 call indexerror

;-92     if (R2No==3) rm=7;//BX

.getIndReg135:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg136
 mov ax, 7
 mov byte [rm], al

;-93     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg136:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg137
 mov ax, 6
 mov byte [rm], al

;-94     if (R2No==7) rm=5;//DI

.getIndReg137:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg138
 mov ax, 5
 mov byte [rm], al

;-95     if (R2No==6) rm=4;//SI

.getIndReg138:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg139
 mov ax, 4
 mov byte [rm], al

;-96     if (rm==0) indexerror();

.getIndReg139:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg140
 call indexerror

;-97 }

.getIndReg140:

;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    98 NULL m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-99     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg241
 call indexerror

;-100     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg241:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg242
 mov al, [rm]
 cmp al, 6
 jne .getIndReg243
 mov ax, 3
 mov [bp-2], al

;-101              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg244
.getIndReg243:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg245
 mov ax, 1
 mov [bp-2], al

;-102     if (R2No==6) if (rm==6) m=2;//BP+SI

.getIndReg245:
.getIndReg244:
.getIndReg242:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg246
 mov al, [rm]
 cmp al, 6
 jne .getIndReg247
 mov ax, 2
 mov [bp-2], al

;-103              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg248
.getIndReg247:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg249
 mov ax, 0
 mov [bp-2], al

;-104     if (m > 3) indexerror();

.getIndReg249:
.getIndReg248:
.getIndReg246:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg250
 call indexerror

;-105     return m;

.getIndReg250:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-106 }


;-107                   


;-108 int setwflag() {//word size, bit 0

 .retngetIndReg2: LEAVE
 ret
ENDP

setwflag: PROC

;-109     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-110     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag51

;-111         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag52
 mov al, [R1Type]
 mov byte [OpSize], al

;-112         if (Op2== REG) OpSize=R2Type;        

.setwflag52:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag53
 mov al, [R2Type]
 mov byte [OpSize], al

;-113         if (R2Type== SEGREG) OpSize=WORD;

.setwflag53:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag54
 mov ax, 2
 mov byte [OpSize], al

;-114         if (R1Type == SEGREG) OpSize=WORD;        

.setwflag54:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag55
 mov ax, 2
 mov byte [OpSize], al

;-115     }

.setwflag55:

;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag51:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag56
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-117     if (OpSize  ==  WORD) wflag=1;

.setwflag56:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag57
 mov ax, 1
 mov byte [wflag], al

;-118 }

.setwflag57:

;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 

 ret
ENDP

setsflag: PROC

;-120     unsigned int ui;    


;-121     sflag=2;   

;Function : setsflag, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   120 NULL ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-122     ui = imme & 0xFF80;//is greater than signed 127? 

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-123     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag58
 mov ax, 0
 mov byte [sflag], al

;-124     if (OpSize == BYTE) {

.setsflag58:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag59

;-125         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag60
 push setsflag_0
 call error1
 add  sp, 2

;-126         sflag=0;//byte reg does not need sign extended   

.setsflag60:
 mov ax, 0
 mov byte [sflag], al

;-127     }


;-128 }

.setsflag59:

;-129 int checkConstSize(unsigned int ui) {    
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-130     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   129 NULL ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize61
 mov ax, 0
 jmp .retncheckConstSize

;-131     if (ui < 0xFF80) return 0;//-128dez    

.checkConstSize61:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize62
 mov ax, 0
 jmp .retncheckConstSize

;-132     return 2;// is short        

.checkConstSize62:
 mov ax, 2
 jmp .retncheckConstSize

;-133 }

 .retncheckConstSize: LEAVE
 ret
ENDP
;Back to main program: AS.C

;-5 #include "PARSE.C"

;Use include file: PARSE.C

;-1 int parse() {


parse: PROC

;-2     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-3     JmpCallNamePtr= &JmpCallNames;

 mov ax, JmpCallNames
 mov word [JmpCallNamePtr], ax

;-4     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-5     JmpCallMaxIx=0;

 mov ax, 0
 mov word [JmpCallMaxIx], ax

;-6     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-7     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-8 


;-9     do {//process a new line

.parse63:

;-10         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-11         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-12         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-13         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-14         getLine();

 call getLine

;-15         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-16         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-17         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse64

;-18             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse65

;-19               if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse66
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-20                 storeLabel();

.parse66:
 call storeLabel

;-21                 InputPtr++;//remove :

 inc  word[InputPtr]

;-22                 getTokeType();

 call getTokeType

;-23             }


;-24         }

.parse65:

;-25         if (TokeType == ALNUME) {

.parse64:
 mov al, [TokeType]
 cmp al, 3
 jne .parse67

;-26             lookCode();// and OpCodePtr

 call lookCode

;-27             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse68
 call process

;-28             else getVariable();

 jmp .parse69
.parse68:
 call getVariable

;-29             skipRest();

.parse69:
 call skipRest

;-30         }


;-31         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp .parse70
.parse67:
 mov al, [TokeType]
 cmp al, 3
 jle .parse71
 push parse_0
 call error1
 add  sp, 2

;-32         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp .parse72
.parse71:
 mov al, [TokeType]
 cmp al, 1
 jne .parse73
 push parse_1
 call error1
 add  sp, 2

;-33         printLine();

.parse73:
.parse72:
.parse70:
 call printLine

;-34     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse74
 jmp .parse63
.parse74:

;-35 }


;-36 


;-37 int getTokeType() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0
ENDP

getTokeType: PROC

;-38     char c;


;-39     skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    38 NULL c = bp-2;
 ENTER  2,0
 call skipBlank

;-40     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-41     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType75
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-42     if (c == ';') {TokeType=0; return; }//comment

.getTokeType75:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType76
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-43     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

.getTokeType76:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getTokeType77
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov ax, 1
 mov byte [TokeType], al
 jmp .retngetTokeType

;-44     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

.getTokeType77:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .getTokeType78
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov ax, 3
 mov byte [TokeType], al
 jmp .retngetTokeType

;-45     TokeType=NOALNUME;

.getTokeType78:
 mov ax, 4
 mov byte [TokeType], al

;-46 }


;-47 


;-48 int storeJmpCall() {

 .retngetTokeType: LEAVE
 ret
ENDP

storeJmpCall: PROC

;-49     unsigned int i;


;-50     JmpCallMaxIx++;

;Function : storeJmpCall, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word    49 NULL i = bp-2;
 ENTER  2,0
 inc  word[JmpCallMaxIx]

;-51     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");

 mov ax, [JmpCallMaxIx]
 cmp ax, 500 ;unsigned : 1
 jl  .storeJmpCall79
 push storeJmpCall_0
 call errorexit
 add  sp, 2

;-52     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);

.storeJmpCall79:
 lea  ax, [Symbol]
 push ax
 push word [JmpCallNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpCallNamePtr], ax

;-53     JmpCallNamePtr++;

 inc  word[JmpCallNamePtr]

;-54     i = JmpCallNamePtr - &JmpCallNames;

 mov ax, [JmpCallNamePtr]
 sub ax, JmpCallNames
 mov [bp-2], ax

;-55     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");

 mov ax, [bp-2]
 cmp ax, 1969 ;unsigned : 0
 jb  .storeJmpCall80
 push storeJmpCall_1
 call errorexit
 add  sp, 2

;-56     JmpCallAddr[JmpCallMaxIx] = PC;

.storeJmpCall80:
 mov ax, [PC]
 mov bx, [JmpCallMaxIx]
 shl bx, 1
 mov [JmpCallAddr+bx], ax

;-57 }


;-58 


;-59 int storeLabel() {
 LEAVE
 ret
storeJmpCall_0 db "too many JmpCalls",0
storeJmpCall_1 db "too many JmpCall names",0
ENDP

storeLabel: PROC

;-60     unsigned int i;


;-61     LabelMaxIx++;

;Function : storeLabel, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word    60 NULL i = bp-2;
 ENTER  2,0
 inc  word[LabelMaxIx]

;-62     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel81
 push storeLabel_0
 call errorexit
 add  sp, 2

;-63     if(searchLabel()) error1("duplicate label");

.storeLabel81:
 call searchLabel
 or  al, al
 je .storeLabel82
 push storeLabel_1
 call error1
 add  sp, 2

;-64     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel82:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-65     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-66     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-67     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeLabel83
 push storeLabel_2
 call errorexit
 add  sp, 2

;-68     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel83:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-69 }


;-70 


;-71 int searchLabel() {
 LEAVE
 ret
storeLabel_0 db "too many labels",0
storeLabel_1 db "duplicate label",0
storeLabel_2 db "too many label names",0
ENDP

searchLabel: PROC

;-72     int LIx; char *p;


;-73     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word    72 NULL LIx = bp-2
;  201 ptr sign byte    72 NULL p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-74     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-75     while (LIx <= LabelMaxIx) {

.searchLabel84:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel85

;-76         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel86
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-77         p=strlen(p) + p;

.searchLabel86:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-78         p++;

 inc  word[bp-4]

;-79         LIx++;

 inc  word[bp-2]

;-80     }


;-81     return 0;

 jmp .searchLabel84
.searchLabel85:
 mov ax, 0
 jmp .retnsearchLabel

;-82 }


;-83 


;-84 int getVariable() {

 .retnsearchLabel: LEAVE
 ret
ENDP

getVariable: PROC

;-85     char c;


;-86     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    85 NULL c = bp-2;
 ENTER  2,0
 call storeLabel

;-87     getTokeType();

 call getTokeType

;-88     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable87

;-89         lookCode();

 call lookCode

;-90         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable88
 call dataexit

;-91         if (CodeType > 205) dataexit();

.getVariable88:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable89
 call dataexit

;-92         if (CodeType== 200) {//DB

.getVariable89:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable90

;-93             do {

.getVariable91:

;-94                 getTokeType();

 call getTokeType

;-95                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable92
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-96                 else {

 jmp .getVariable93
.getVariable92:

;-97                     skipBlank();

 call skipBlank

;-98                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable94

;-99                         do {

.getVariable95:

;-100                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-101                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-102                             InputPtr++;

 inc  word[InputPtr]

;-103                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable96
 jmp .getVariable95
.getVariable96:

;-104                         InputPtr++;

 inc  word[InputPtr]

;-105                     }


;-106                 }

.getVariable94:

;-107             } while (isToken(','));

.getVariable93:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable97
 jmp .getVariable91
.getVariable97:

;-108         }


;-109         if (CodeType == 201) {//DW

.getVariable90:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable98

;-110             do {

.getVariable99:

;-111                 getTokeType();

 call getTokeType

;-112                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable100
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-113             } while (isToken(','));

.getVariable100:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable101
 jmp .getVariable99
.getVariable101:

;-114         }


;-115         if (CodeType == 202) {//DD

.getVariable98:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable102

;-116             do {

.getVariable103:

;-117                 getTokeType();

 call getTokeType

;-118                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable104
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-119                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-120             } while (isToken(','));

.getVariable104:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable105
 jmp .getVariable103
.getVariable105:

;-121         }


;-122         if (CodeType >= 203) {//resb, resw, resd

.getVariable102:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable106

;-123             getTokeType();

 call getTokeType

;-124             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable107

;-125                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable108
 call syntaxerror

;-126                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable108:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable109
 push getVariable_0
 call error1
 add  sp, 2

;-127                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable109:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-128                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable110
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-129                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable110:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable111
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-130                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable111:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-131             } else numbererror();

 jmp .getVariable112
.getVariable107:
 call numbererror

;-132         }

.getVariable112:

;-133     }

.getVariable106:

;-134     else dataexit();

 jmp .getVariable113
.getVariable87:
 call dataexit

;-135 }

.getVariable113:

;-136 


;-137 int lookCode() {//ret: CodeType, *OpCodePtr
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

lookCode: PROC

;-138     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-139     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-140     OpCodePtr++;

 inc  word[OpCodePtr]

;-141     do  {

.lookCode114:

;-142         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode115

;-143             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode116:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode117
 inc  word[OpCodePtr]

;-144             OpCodePtr++;

 jmp .lookCode116
.lookCode117:
 inc  word[OpCodePtr]

;-145             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-146             return;

 jmp .retnlookCode

;-147         }


;-148     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode115:
.lookCode118:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode119
 inc  word[OpCodePtr]

;-149     OpCodePtr++;

 jmp .lookCode118
.lookCode119:
 inc  word[OpCodePtr]

;-150     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode120
 jmp .lookCode114
.lookCode120:

;-151 }


;-152 


;-153 int getCodeSize() {

 .retnlookCode:
 ret
ENDP

getCodeSize: PROC

;-154     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize121

;-155         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize122
 call getTokeType
 mov ax, 1
 jmp .retngetCodeSize

;-156         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

.getCodeSize122:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize123
 call getTokeType
 mov ax, 2
 jmp .retngetCodeSize

;-157         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

.getCodeSize123:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .getCodeSize124
 call getTokeType
 mov ax, 3
 jmp .retngetCodeSize

;-158     }

.getCodeSize124:

;-159     return 0;

.getCodeSize121:
 mov ax, 0
 jmp .retngetCodeSize

;-160 }


;-161 int isToken(char c) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

isToken: PROC

;-162     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   161 NULL c = bp+4;
 ENTER  0,0
 call skipBlank

;-163     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken125

;-164         InputPtr++;

 inc  word[InputPtr]

;-165         return 1;

 mov ax, 1
 jmp .retnisToken

;-166         }


;-167     return 0;

.isToken125:
 mov ax, 0
 jmp .retnisToken

;-168 }


;-169 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-170     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   169 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need126

;-171         getTokeType();

 call getTokeType

;-172         return;

 jmp .retnneed

;-173         }


;-174     error1();

.need126:
 call error1

;-175     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-176     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-177 }


;-178 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-179     getTokeType();

 call getTokeType

;-180     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest127
 push skipRest_0
 call error1
 add  sp, 2

;-181 }

.skipRest127:
 ret
skipRest_0 db "extra char ignored",0
ENDP
;Back to main program: AS.C

;-6 #include "HELPER.C"

;Use include file: HELPER.C

;-1 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }


writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16

;-2 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
ENDP

putch: PROC
;Function : putch, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte     2 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .putch128
 mov  al, 13
 call writetty
.putch128:
 mov  al, [bp+4]
 call writetty

;-3 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
ENDP

cputs: PROC
;Function : cputs, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte     3 NULL s = bp+4
;  201 var sign byte     3 NULL c = bp-2;
 ENTER  2,0
.cputs129:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .cputs130
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
 jmp .cputs129
.cputs130:

;-4 


;-5 int DosInt() {
 LEAVE
 ret
ENDP

DosInt: PROC

;-6     __emit__(0xCD,0x21);//inth 0x21;

 db 205,33

;-7     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4

;-8     DOS_ERR++;

 inc  word[DOS_ERR]

;-9 }


;-10 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC
;Function : openR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    10 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-11 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP

creatR: PROC
;Function : creatR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    11 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-12 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP

fcloseR: PROC
;Function : fcloseR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word    12 NULL fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt

;-13 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP

exitR: PROC
;Function : exitR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    13 NULL c = bp+4;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt

;-14 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
 LEAVE
 ret
ENDP

readRL: PROC
;Function : readRL, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    14 NULL s = bp+4
;  201 var sign word    14 NULL fd = bp+6
;  202 var sign word    14 NULL len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-15 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP

fputcR: PROC
;Function : fputcR, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    15 NULL n = bp+4
;  201 var sign word    15 NULL fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]

;-16   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-17 


;-18 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
 LEAVE
 ret
ENDP

getLine: PROC

;-19   unsigned int i;


;-20   InputPtr= &InputBuf;

;Function : getLine, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word    19 NULL i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-21   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-22   do {

.getLine131:

;-23     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-24     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine132
 push getLine_0
 call errorexit
 add  sp, 2

;-25     if (DOS_NoBytes == 0) return;

.getLine132:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine133
 jmp .retngetLine

;-26     *InputPtr = DOS_ByteRead;

.getLine133:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-27     InputPtr++;

 inc  word[InputPtr]

;-28     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-29     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine134
 push getLine_1
 call errorexit
 add  sp, 2

;-30   } while (ifEOL(DOS_ByteRead) == 0);

.getLine134:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne .getLine135
 jmp .getLine131
.getLine135:

;-31   InputPtr--;

 dec  word[InputPtr]

;-32   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-33 }


;-34 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

ifEOL: PROC

;-35   if (c == 10) return 1;//LF

;Function : ifEOL, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    34 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL136
 mov ax, 1
 jmp .retnifEOL

;-36   if (c == 13) {//CR

.ifEOL136:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL137

;-37     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-38     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL138
 push ifEOL_0
 call errorexit
 add  sp, 2

;-39     return 1;

.ifEOL138:
 mov ax, 1
 jmp .retnifEOL

;-40   }


;-41   return 0;

.ifEOL137:
 mov ax, 0
 jmp .retnifEOL

;-42 }


;-43 int skipBlank() {

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

skipBlank: PROC

;-44   skipblank1:

.skipblank1:

;-45     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank139
 inc  word[InputPtr]
 jmp .skipblank1

;-46     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank139:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank140
 inc  word[InputPtr]
 jmp .skipblank1

;-47 }

.skipBlank140:

;-48 int letterE(char c) {

 ret
ENDP

letterE: PROC

;-49   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    48 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE141
 mov ax, 1
 jmp .retnletterE

;-50   if (c=='.') return 1;

.letterE141:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE142
 mov ax, 1
 jmp .retnletterE

;-51   if (c=='?') return 1;

.letterE142:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE143
 mov ax, 1
 jmp .retnletterE

;-52   if (c=='$') return 1;

.letterE143:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE144
 mov ax, 1
 jmp .retnletterE

;-53   if (c> 'z') return 0;

.letterE144:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE145
 mov ax, 0
 jmp .retnletterE

;-54   if (c< '@') return 0; // at included

.letterE145:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE146
 mov ax, 0
 jmp .retnletterE

;-55   if (c> 'Z') { if (c< 'a') return 0; }

.letterE146:
 mov al, [bp+4]
 cmp al, 90
 jle .letterE147
 mov al, [bp+4]
 cmp al, 97
 jge .letterE148
 mov ax, 0
 jmp .retnletterE
.letterE148:

;-56   return 1;

.letterE147:
 mov ax, 1
 jmp .retnletterE

;-57 }


;-58 int alnumE(char c) {

 .retnletterE: LEAVE
 ret
ENDP

alnumE: PROC

;-59   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    58 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .alnumE149
 mov ax, 1
 jmp .retnalnumE

;-60   if (letterE(c)) return 1;

.alnumE149:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .alnumE150
 mov ax, 1
 jmp .retnalnumE

;-61   return 0;

.alnumE150:
 mov ax, 0
 jmp .retnalnumE

;-62 }


;-63 int digit(char c){

 .retnalnumE: LEAVE
 ret
ENDP

digit: PROC

;-64     if(c<'0') return 0;

;Function : digit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    63 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit151
 mov ax, 0
 jmp .retndigit

;-65     if(c>'9') return 0;

.digit151:
 mov al, [bp+4]
 cmp al, 57
 jle .digit152
 mov ax, 0
 jmp .retndigit

;-66     return 1;

.digit152:
 mov ax, 1
 jmp .retndigit

;-67 }


;-68 int strlen(char *s) { int c;

 .retndigit: LEAVE
 ret
ENDP

strlen: PROC

;-69     c=0;

;Function : strlen, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    68 NULL s = bp+4
;  201 var sign word    68 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax

;-70     while (*s!=0) {s++; c++;}

.strlen153:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen154
 inc  word[bp+4]
 inc  word[bp-2]

;-71     return c;

 jmp .strlen153
.strlen154:
 mov ax, [bp-2]
 jmp .retnstrlen

;-72     }


;-73 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP

strcpy: PROC

;-74     do { *s=*t; s++; t++; }

;Function : strcpy, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    73 NULL s = bp+4
;  201 ptr sign byte    73 NULL t = bp+6;
 ENTER  0,0
.strcpy155:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]

;-75     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy156
 jmp .strcpy155
.strcpy156:

;-76     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al

;-77     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy

;-78     }


;-79 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP

eqstr: PROC

;-80     while(*p) {

;Function : eqstr, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    79 NULL p = bp+4
;  201 ptr sign byte    79 NULL q = bp+6;
 ENTER  0,0
.eqstr157:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr158

;-81         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr159
 mov ax, 0
 jmp .retneqstr

;-82             p++;

.eqstr159:
 inc  word[bp+4]

;-83             q++;

 inc  word[bp+6]

;-84             }


;-85     if(*q) return 0;

 jmp .eqstr157
.eqstr158:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr160
 mov ax, 0
 jmp .retneqstr

;-86     return 1;

.eqstr160:
 mov ax, 1
 jmp .retneqstr

;-87     }


;-88 int strcat1(char *s, char *t) {

 .retneqstr: LEAVE
 ret
ENDP

strcat1: PROC

;-89     while (*s != 0) s++;

;Function : strcat1, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    88 NULL s = bp+4
;  201 ptr sign byte    88 NULL t = bp+6;
 ENTER  0,0
.strcat1161:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat1162
 inc  word[bp+4]

;-90     strcpy(s, t);

 jmp .strcat1161
.strcat1162:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-91     }


;-92 int toupper(char *s) {
 LEAVE
 ret
ENDP

toupper: PROC

;-93     while(*s) {

;Function : toupper, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    92 NULL s = bp+4;
 ENTER  0,0
.toupper163:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper164

;-94         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  .toupper165
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  .toupper166
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al

;-95             s++;

.toupper166:
.toupper165:
 inc  word[bp+4]

;-96               }


;-97     }

 jmp .toupper163
.toupper164:

;-98 


;-99 int getDigit(unsigned char c) {//ret: SymbolInt
 LEAVE
 ret
ENDP

getDigit: PROC

;-100   unsigned int CastInt;


;-101   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte    99 NULL c = bp+4
;  201 var unsg word   100 NULL CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-102   do {

.getDigit167:

;-103     c-='0';

 sub  byte[bp+4], 48

;-104     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-105     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-106     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-107     InputPtr++;

 inc  word[InputPtr]

;-108     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-109   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit168
 jmp .getDigit167
.getDigit168:

;-110 }


;-111 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-112   char *p; unsigned int i;


;-113   p = &Symbol;

;Function : getName, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   111 NULL c = bp+4
;  201 ptr sign byte   112 NULL p = bp-2
;  202 var unsg word   112 NULL i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-114   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-115   p++;

 inc  word[bp-2]

;-116   while (alnumE(c)) {

.getName169:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName170

;-117     InputPtr++;

 inc  word[InputPtr]

;-118     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-119     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-120     p++;

 inc  word[bp-2]

;-121     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-122     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName171
 push getName_0
 call errorexit
 add  sp, 2

;-123   }

.getName171:

;-124   if (c == ':') isLabel=1; else isLabel=0;

 jmp .getName169
.getName170:
 mov al, [bp+4]
 cmp al, 58
 jne .getName172
 mov ax, 1
 mov byte [isLabel], al
 jmp .getName173
.getName172:
 mov ax, 0
 mov byte [isLabel], al

;-125   p--;

.getName173:
 dec  word[bp-2]

;-126   *p = 0;

 mov ax, 0
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
getName_0 db "symbol too long",0
ENDP

testReg: PROC

;-131 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-132   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al

;-133   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg174
 mov ax, 0
 jmp .retntestReg

;-134   if (strlen(Symbol) > 3) return 0;

.testReg174:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg175
 mov ax, 0
 jmp .retntestReg

;-135   R2Type=BYTE;

.testReg175:
 mov ax, 1
 mov byte [R2Type], al

;-136   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg176
 mov ax, 0
 jmp .retntestReg

;-137   if (eqstr(SymbolUpper, "CL")) return 1;

.testReg176:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg177
 mov ax, 1
 jmp .retntestReg

;-138   if (eqstr(SymbolUpper, "DL")) return 2;

.testReg177:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg178
 mov ax, 2
 jmp .retntestReg

;-139   if (eqstr(SymbolUpper, "BL")) return 3;

.testReg178:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg179
 mov ax, 3
 jmp .retntestReg

;-140   if (eqstr(SymbolUpper, "AH")) return 4;

.testReg179:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg180
 mov ax, 4
 jmp .retntestReg

;-141   if (eqstr(SymbolUpper, "CH")) return 5;

.testReg180:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg181
 mov ax, 5
 jmp .retntestReg

;-142   if (eqstr(SymbolUpper, "DH")) return 6;

.testReg181:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg182
 mov ax, 6
 jmp .retntestReg

;-143   if (eqstr(SymbolUpper, "BH")) return 7;

.testReg182:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg183
 mov ax, 7
 jmp .retntestReg

;-144   R2Type=WORD;

.testReg183:
 mov ax, 2
 mov byte [R2Type], al

;-145   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg184
 mov ax, 0
 jmp .retntestReg

;-146   if (eqstr(SymbolUpper, "CX")) return 1;

.testReg184:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg185
 mov ax, 1
 jmp .retntestReg

;-147   if (eqstr(SymbolUpper, "DX")) return 2;

.testReg185:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg186
 mov ax, 2
 jmp .retntestReg

;-148   if (eqstr(SymbolUpper, "BX")) return 3;

.testReg186:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg187
 mov ax, 3
 jmp .retntestReg

;-149   if (eqstr(SymbolUpper, "SP")) return 4;

.testReg187:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg188
 mov ax, 4
 jmp .retntestReg

;-150   if (eqstr(SymbolUpper, "BP")) return 5;

.testReg188:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg189
 mov ax, 5
 jmp .retntestReg

;-151   if (eqstr(SymbolUpper, "SI")) return 6;

.testReg189:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg190
 mov ax, 6
 jmp .retntestReg

;-152   if (eqstr(SymbolUpper, "DI")) return 7;

.testReg190:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg191
 mov ax, 7
 jmp .retntestReg

;-153   R2Type=SEGREG;

.testReg191:
 mov ax, 4
 mov byte [R2Type], al

;-154   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg192
 mov ax, 0
 jmp .retntestReg

;-155   if (eqstr(SymbolUpper, "CS")) return 1;

.testReg192:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg193
 mov ax, 1
 jmp .retntestReg

;-156   if (eqstr(SymbolUpper, "SS")) return 2;

.testReg193:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg194
 mov ax, 2
 jmp .retntestReg

;-157   if (eqstr(SymbolUpper, "DS")) return 3;

.testReg194:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg195
 mov ax, 3
 jmp .retntestReg

;-158   if (eqstr(SymbolUpper, "FS")) return 4;

.testReg195:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg196
 mov ax, 4
 jmp .retntestReg

;-159   if (eqstr(SymbolUpper, "GS")) return 5;

.testReg196:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg197
 mov ax, 5
 jmp .retntestReg

;-160   R2Type=DWORD;

.testReg197:
 mov ax, 3
 mov byte [R2Type], al

;-161   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg198
 mov ax, 0
 jmp .retntestReg

;-162   if (eqstr(SymbolUpper, "ECX"))return 1;

.testReg198:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg199
 mov ax, 1
 jmp .retntestReg

;-163   if (eqstr(SymbolUpper, "EDX"))return 2;

.testReg199:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg200
 mov ax, 2
 jmp .retntestReg

;-164   if (eqstr(SymbolUpper, "EBX"))return 3;

.testReg200:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg201
 mov ax, 3
 jmp .retntestReg

;-165   if (eqstr(SymbolUpper, "ESP"))return 4;

.testReg201:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg202
 mov ax, 4
 jmp .retntestReg

;-166   if (eqstr(SymbolUpper, "EBP"))return 5;

.testReg202:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg203
 mov ax, 5
 jmp .retntestReg

;-167   if (eqstr(SymbolUpper, "ESI"))return 6;

.testReg203:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg204
 mov ax, 6
 jmp .retntestReg

;-168   if (eqstr(SymbolUpper, "EDI"))return 7;

.testReg204:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg205
 mov ax, 7
 jmp .retntestReg

;-169   R2Type=0; return 0;

.testReg205:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg

;-170 }

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
;Back to main program: AS.C

;-7 #include "OUTPUT.C"

;Use include file: OUTPUT.C

;-1 int printLine() {


printLine: PROC

;-2     int i; char c;


;-3     prs("\n");

;Function : printLine, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word     2 NULL i = bp-2
;  201 var sign byte     2 NULL c = bp-4;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-4     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-5     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine206
 push printLine_1
 call prs
 add  sp, 2

;-6     else {

 jmp .printLine207
.printLine206:

;-7 //        prc(' ');


;-8         i=0;

 mov ax, 0
 mov [bp-2], ax

;-9         do {

.printLine208:

;-10             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al

;-11             prc(' ');

 push 32
 call prc
 add  sp, 2

;-12             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-13             i++;

 inc  word[bp-2]

;-14         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine209
 jmp .printLine208
.printLine209:

;-15         while (i < OPMAXLEN) {// fill rest with blank

.printLine210:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine211

;-16             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-17             i++;

 inc  word[bp-2]

;-18         }


;-19     }

 jmp .printLine210
.printLine211:

;-20     prc(PrintRA);

.printLine207:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-21     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-22 }


;-23 int prc(unsigned char c) {//print char
 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

prc: PROC

;-24     if (LIST) {

;Function : prc, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte    23 NULL c = bp+4;
 ENTER  0,0
 mov al, [LIST]
 or  al, al
 je .prc212

;-25         if ( _ c==10) {
 ; constant expression
cmp byte[bp+4], 10
 jne .prc213

;-26             ax=13;

 mov  ax, 13

;-27             writetty();

 call writetty

;-28             }


;-29         al=c;

.prc213:
 mov  al, [bp+4]

;-30         writetty();

 call writetty

;-31         }


;-32     fputcR(c,lst_fd);

.prc212:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-33 }


;-34 


;-35 int prscomment(unsigned char *s) {
 LEAVE
 ret
ENDP

prscomment: PROC

;-36     unsigned char c;


;-37     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte    35 NULL s = bp+4
;  201 var unsg byte    36 NULL c = bp-2;
 ENTER  2,0
.prscomment214:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment215

;-38         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-39         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-40         s++;

 inc  word[bp+4]

;-41     }


;-42 }

 jmp .prscomment214
.prscomment215:

;-43 int prs(unsigned char *s) {
 LEAVE
 ret
ENDP

prs: PROC

;-44     unsigned char c;


;-45     int com;


;-46     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte    43 NULL s = bp+4
;  201 var unsg byte    44 NULL c = bp-2
;  202 var sign word    45 NULL com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax

;-47     while (*s) {

.prs216:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs217

;-48         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-49         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs218

;-50             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs219
 mov ax, 0
 mov [bp-4], ax

;-51                 else com=1;

 jmp .prs220
.prs219:
 mov ax, 1
 mov [bp-4], ax

;-52         }

.prs220:

;-53         if (c==92) {

.prs218:
 mov al, [bp-2]
 cmp al, 92
 jne .prs221

;-54             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs222

;-55                 s++;

 inc  word[bp+4]

;-56                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-57                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs223
 mov ax, 10
 mov [bp-2], al

;-58                 if (c=='t') c= 9;

.prs223:
 mov al, [bp-2]
 cmp al, 116
 jne .prs224
 mov ax, 9
 mov [bp-2], al

;-59             }

.prs224:

;-60         }

.prs222:

;-61         prc(c);

.prs221:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-62         s++;

 inc  word[bp+4]

;-63     }


;-64 }

 jmp .prs216
.prs217:

;-65 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP

printhex8a: PROC

;-66     unsigned char nib;


;-67     nib = c >> 4; printhex4(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte    65 NULL c = bp+4
;  201 var unsg byte    66 NULL nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-68     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-69 }


;-70 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP

printhex4: PROC

;-71     c += 48;

;Function : printhex4, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte    70 NULL c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48

;-72     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex4225
 add  byte[bp+4], 7

;-73     prc(c);

.printhex4225:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-74 }


;-75 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP

printhex16: PROC

;-76     unsigned int half;


;-77     half = i >>  8; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word    75 NULL i = bp+4
;  201 var unsg word    76 NULL half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-78     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-79 }


;-80 int printIntU(unsigned int n) {
 LEAVE
 ret
ENDP

printIntU: PROC

;-81     unsigned int e;


;-82     if ( _ n >= 10) {

;Function : printIntU, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word    80 NULL n = bp+4
;  201 var unsg word    81 NULL e = bp-2;
 ENTER  2,0 ; constant expression
cmp word[bp+4], 10 ;unsigned : 0
 jb  .printIntU226

;-83         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax

;-84         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-85     }


;-86     n = n % 10; //unsigned mod

.printIntU226:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax

;-87     n += '0';

 add  word[bp+4], 48

;-88     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-89 }


;-90 


;-91 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-92     LIST=1;

;Function : error1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    91 NULL s = bp+4;
 ENTER  0,0
 mov ax, 1
 mov byte [LIST], al

;-93     ErrorCount++;

 inc  word[ErrorCount]

;-94     prs("\n;***** next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-95     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-96     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-97     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-98 }


;-99 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-100     error1(s);

;Function : errorexit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte    99 NULL s = bp+4;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-101     epilog(); 

 call epilog

;-102     end1(1);

 push 1
 call end1
 add  sp, 2

;-103 }


;-104 int allowederror() {error1("not allowed here"); }
 LEAVE
 ret
ENDP

allowederror: PROC
 push allowederror_0
 call error1
 add  sp, 2

;-105 int addrerror()    {error1("address missing");}

 ret
allowederror_0 db "not allowed here",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-106 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-107 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-108 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-109 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-110 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-111 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-112 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-113 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-114 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-115 


;-116 int addrexit()     {errorexit("illegal address");}

 ret
syntaxerror_0 db "syntax",0
ENDP

addrexit: PROC
 push addrexit_0
 call errorexit
 add  sp, 2

;-117 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
addrexit_0 db "illegal address",0
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-118 int internexit()   {errorexit("intern compiler error");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

internexit: PROC
 push internexit_0
 call errorexit
 add  sp, 2
 ret
internexit_0 db "intern compiler error",0
ENDP
;Back to main program: AS.C

;-8 #include "MAIN.C"

;Use include file: MAIN.C

;-1 int main() {


main: PROC

;-2     getarg();

 call getarg

;-3     parse();

 call parse

;-4     fixJmpCall();

 call fixJmpCall

;-5     epilog();

 call epilog

;-6     end1();

 call end1

;-7 }


;-8 


;-9 int getarg() {

 ret
ENDP

getarg: PROC

;-10     int arglen1; int i; char *c;


;-11     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var sign word    10 NULL arglen1 = bp-2
;  201 var sign word    10 NULL i = bp-4
;  202 ptr sign byte    10 NULL c = bp-6;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-12     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg227

;-13         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-15         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-16     }


;-17     i=arglen1+129;

.getarg227:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-18     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-19     arglen1--;

 dec  word[bp-2]

;-20     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-21 


;-22     strcpy(namein, argv); strcat1(namein, ".S");

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

;-23     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-24     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-25 


;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 1
 mov byte [LIST], al
 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-27 


;-28     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg228
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

;-30     lst_fd=creatR(namelst);

.getarg228:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg229
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

;-32     bin_fd=creatR(namebin);

.getarg229:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg230
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

;-34 


;-35     prs(";");

.getarg230:
 push getarg_7
 call prs
 add  sp, 2

;-36     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-37     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-38     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-39     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-40     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-41 }


;-42 


;-43 int fixJmpCall() {
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

fixJmpCall: PROC

;-44     int i;  unsigned int hex;  char *p; int Ix; char c;


;-45     i=1;

;Function : fixJmpCall, Number of local variables: 5
;   # type sign width addr used name   list of local variables
;  200 var sign word    44 NULL i = bp-2
;  201 var unsg word    44 NULL hex = bp-4
;  202 ptr sign byte    44 NULL p = bp-6
;  203 var sign word    44 NULL Ix = bp-8
;  204 var sign byte    44 NULL c = bp-10;
 ENTER  10,0
 mov ax, 1
 mov [bp-2], ax

;-46     prs("\n;END open jmp/call: ");

 push fixJmpCall_0
 call prs
 add  sp, 2

;-47     printIntU(JmpCallMaxIx);

 push word [JmpCallMaxIx]
 call printIntU
 add  sp, 2

;-48     p = &JmpCallNames;

 mov ax, JmpCallNames
 mov [bp-6], ax

;-49     while (i <= JmpCallMaxIx) {

.fixJmpCall231:
 mov ax, [bp-2]
 cmp ax, [JmpCallMaxIx]
 jg  .fixJmpCall232

;-50         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-51         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-52         p++;

 inc  word[bp-6]

;-53 //        prs(Symbol);


;-54 //        prc(' ');


;-55         hex = JmpCallAddr[i];

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [JmpCallAddr + bx]
 mov [bp-4], ax

;-56 //        printhex16(hex);


;-57 


;-58         Ix=searchLabel();

 call searchLabel
 mov [bp-8], ax

;-59         if (Ix == 0) error1("Label not found");

 mov ax, [bp-8]
 cmp ax, 0
 jne .fixJmpCall233
 push fixJmpCall_1
 call error1
 add  sp, 2

;-60         disp = LabelAddr[Ix];

.fixJmpCall233:
 mov bx, [bp-8]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-61         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp-4]
 mov word [disp], ax

;-62         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-63 //        prs(", ");


;-64 


;-65             hex = hex - 2;//fix at start of word

 mov ax, [bp-4]
 sub ax, 2
 mov [bp-4], ax

;-66             FileBin[hex] = disp;//fix low byte

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-67             hex++;

 inc  word[bp-4]

;-68             disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-69             FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-70         i++;

 inc  word[bp-2]

;-71     }


;-72 }

 jmp .fixJmpCall231
.fixJmpCall232:

;-73 


;-74 int epilog() {
 LEAVE
 ret
fixJmpCall_0 db "\n;END open jmp/call: ",0
fixJmpCall_1 db "Label not found",0
ENDP

epilog: PROC

;-75     unsigned int i; char c;     int j;


;-76     prs("\n Errors: ");

;Function : epilog, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word    75 NULL i = bp-2
;  201 var sign byte    75 NULL c = bp-4
;  202 var sign word    75 NULL j = bp-6;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-77     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-78     if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog234
 push epilog_1
 call prs
 add  sp, 2

;-79     prs(", Out: ");

.epilog234:
 push epilog_2
 call prs
 add  sp, 2

;-80     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-81     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-82     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-83     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-84     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-85     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-86 


;-87     i=0;

 mov ax, 0
 mov [bp-2], ax

;-88     do {

.epilog235:

;-89         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-90         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-91 //printhex8a(c); prc(' ');


;-92         i++;

 inc  word[bp-2]

;-93     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog236
 jmp .epilog235
.epilog236:

;-94 


;-95   prs(" Labels: ");

 push epilog_6
 call prs
 add  sp, 2

;-96   printIntU(LabelMaxIx);

 push word [LabelMaxIx]
 call printIntU
 add  sp, 2

;-97   prs(". ");

 push epilog_7
 call prs
 add  sp, 2

;-98 /*


;-99   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);


;-100   i= &LabelNames;


;-101   prs(" &LabelNames:"); printIntU(i);


;-102   i=LabelNamePtr-i;


;-103   prs("size: ");


;-104   printIntU(i);


;-105   prs(". >>");


;-106   i= &LabelNames;


;-107   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-108   } while (i < LabelNamePtr); prs("<< \n");


;-109    i = 1;


;-110     LabelNamePtr= &LabelNames;


;-111     do {


;-112       prs(LabelNamePtr); prc(' ');


;-113       j=LabelAddr[i]; printhex16(j); prs(", ");


;-114       j=strlen(LabelNamePtr);//get end of actual name


;-115       LabelNamePtr=LabelNamePtr+j;


;-116       LabelNamePtr++;


;-117       i++;


;-118     } while (i <= LabelMaxIx);


;-119 */    


;-120 }


;-121 


;-122 int end1(int n) {
 LEAVE
 ret
epilog_0 db "\n Errors: ",0
epilog_1 db " ***ERROR*** ",0
epilog_2 db ", Out: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
epilog_6 db " Labels: ",0
epilog_7 db ". ",0
ENDP

end1: PROC

;-123     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   122 NULL n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-124     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-125     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-126     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-127 }
 LEAVE
 ret
ENDP
;Back to main program: AS.C

;-9 #include "GENCODE.C"

;Use include file: GENCODE.C

;-1 // generate code


;-2 int getCodes() {


getCodes: PROC

;-3     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-4     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-5     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-6 }


;-7 int gen66h() {genCode8(0x66);

 ret
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-8 }


;-9 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-10     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte     9 NULL c = bp+4
;  201 var sign byte     9 NULL d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-11     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-12 }                             


;-13 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-14     c = c + wflag;  

;Function : genCodeW, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    13 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-15     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-16 }   


;-17 int genCode8(char c) {
 LEAVE
 ret
ENDP

genCode8: PROC

;-18 //set: BinLen++, OpPrintIndex++


;-19     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    17 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-20     BinLen++;

 inc  word[BinLen]

;-21     PC++;

 inc  word[PC]

;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 20000 ;unsigned : 0
 jb  .genCode8237
 push genCode8_0
 call errorexit
 add  sp, 2

;-23     if (OpPrintIndex < OPMAXLEN) {

.genCode8237:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8238

;-24         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-25         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-26     }


;-27 }

.genCode8238:

;-28 int genCode16(unsigned int i) {
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

genCode16: PROC

;-29     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word    28 NULL i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-30     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-31 }


;-32 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-33     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg dwrd    32 NULL L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-34     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-35 }


;-36 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-37 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-38 //mod-bits: mode76, reg/opcode543, r/m210   


;-39 //Op: 0, IMM, REG, ADR, MEM   


;-40     char len;


;-41     len=0;   

;Function : writeEA, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte    36 NULL xxx = bp+4
;  201 var sign byte    40 NULL len = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-42     xxx = xxx << 3;//in reg/opcode field      

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-43     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA239

;-44         xxx |= 0xC0;     

 or  byte[bp+4], 192

;-45         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA240
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-46             else {

 jmp .writeEA241
.writeEA240:

;-47                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA242
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-48                 else            xxx = xxx + R2No;  

 jmp .writeEA243
.writeEA242:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-49             }

.writeEA243:

;-50         } 

.writeEA241:

;-51     if (Op == MEM) {

.writeEA239:
 mov al, [Op]
 cmp al, 4
 jne .writeEA244

;-52         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA245

;-53             xxx |= 6;

 or  byte[bp+4], 6

;-54             len = 2;

 mov ax, 2
 mov [bp-2], al

;-55         }


;-56         else { 

 jmp .writeEA246
.writeEA245:

;-57             xxx = xxx + rm;   

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-58             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA247

;-59                 len=1;

 mov ax, 1
 mov [bp-2], al

;-60                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA248
 or  byte[bp+4], 64

;-61             }

.writeEA248:

;-62 


;-63             if (disp) {

.writeEA247:
 mov ax, [disp]
 or  al, al
 je .writeEA249

;-64                 ax = disp;

 mov  ax, [disp]

;-65                 if(ax > 127) len=2;

 cmp  ax, 127
 jle .writeEA250
 mov ax, 2
 mov [bp-2], al

;-66                 else len=1;

 jmp .writeEA251
.writeEA250:
 mov ax, 1
 mov [bp-2], al

;-67                 if (len == 1) xxx |= 0x40;

.writeEA251:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA252
 or  byte[bp+4], 64

;-68                 else xxx |= 0x80;

 jmp .writeEA253
.writeEA252:
 or  byte[bp+4], 128

;-69             }

.writeEA253:

;-70         }

.writeEA249:

;-71     }  

.writeEA246:

;-72     


;-73     genCode8(xxx);// gen second byte

.writeEA244:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-74     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA254
 push word [disp]
 call genCode8
 add  sp, 2

;-75     if (len == 2) genCode16(disp);

.writeEA254:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA255
 push word [disp]
 call genCode16
 add  sp, 2

;-76 }

.writeEA255:

;-77 


;-78 int genImmediate() { 
 LEAVE
 ret
ENDP

genImmediate: PROC

;-79     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long

 mov al, [wflag]
 or  al, al
 je .genImmediate256
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate257
 push word [imme]
 call genCode32
 add  sp, 2

;-80         else genCode16(imme);

 jmp .genImmediate258
.genImmediate257:
 push word [imme]
 call genCode16
 add  sp, 2

;-81     else       genCode8 (imme);  

.genImmediate258:
 jmp .genImmediate259
.genImmediate256:
 push word [imme]
 call genCode8
 add  sp, 2

;-82 }    

.genImmediate259:
 ret
ENDP
;Back to main program: AS.C

;-10 


;-11 int process() {


process: PROC

;-12     char c;


;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte    12 NULL c = bp-2;
 ENTER  2,0
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

;-14     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-15     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-18     getCodes();//set: Code1, Code2, Code3

 call getCodes

;-19 


;-20     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process260

;-21         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-22         return;

 jmp .retnprocess

;-23     }


;-24 


;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process260:
 mov al, [CodeType]
 cmp al, 2
 jne .process261

;-26         getOpL();

 call getOpL

;-27         checkOpL();

 call checkOpL

;-28         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  .process262

;-29   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process263

;-30                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je .process264
 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
 jmp .retnprocess

;-31             }

.process264:

;-32         }

.process263:

;-33         if (Code2 == 5) {//imul extension?

.process262:
 mov al, [Code2]
 cmp al, 5
 jne .process265

;-34             getTokeType();

 call getTokeType

;-35             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process266
 call implerror

;-36         }

.process266:

;-37         genCodeW(Code1);

.process265:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-38         writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-39         return;

 jmp .retnprocess

;-40     }


;-41 


;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process261:
 mov al, [CodeType]
 cmp al, 3
 jne .process267

;-43         check2Ops();    //setwflag not applicable

 call check2Ops

;-44         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process268
 call reg16error

;-45         if (Op2 != MEM) addrerror();//only m16

.process268:
 mov al, [Op2]
 cmp al, 4
 je  .process269
 call addrerror

;-46 


;-47         genCode8(Code1);//les,lds,lea

.process269:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 15
 jne .process270
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-49         Op=Op2;//set MEM for writeEA

.process270:
 mov al, [Op2]
 mov byte [Op], al

;-50         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-51         return;

 jmp .retnprocess

;-52     }


;-53 


;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process267:
 mov al, [CodeType]
 cmp al, 4
 jne .process271

;-55         check2Ops();

 call check2Ops

;-56         if (Op2 == IMM) {//second operand is imm

 mov al, [Op2]
 cmp al, 1
 jne .process272

;-57             setsflag();

 call setsflag

;-58             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process273

;-59                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process274

;-60                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process275

;-61                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-62                         c += 4;

 add  byte[bp-2], 4

;-63                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-64                         genImmediate();

 call genImmediate

;-65                         return;

 jmp .retnprocess

;-66                     }


;-67                 }

.process275:

;-68             }

.process274:

;-69             //r/m, imm: 80 sign-extended,TTT,imm


;-70             c = sflag + 0x80;

.process273:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-71             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-72             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-73             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process276
 push word [imme]
 call genCode8
 add  sp, 2

;-74             else genImmediate();

 jmp .process277
.process276:
 call genImmediate

;-75             return;

.process277:
 jmp .retnprocess

;-76         }


;-77         c = Code1 << 3;//r/m, r/r

.process272:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-78         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process278

;-79             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process279

;-80                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-81                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-82                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-83                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-84                 return;

 jmp .retnprocess

;-85             }


;-86         }

.process279:

;-87         if (Op2 == REG) {//mem,reg    reg,reg

.process278:
 mov al, [Op2]
 cmp al, 2
 jne .process280

;-88             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-89             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-90             return;

 jmp .retnprocess

;-91         }


;-92         syntaxerror();

.process280:
 call syntaxerror

;-93         return;

 jmp .retnprocess

;-94     }


;-95 


;-96     if (CodeType == 5) {//mov (movsx, movzx=51)

.process271:
 mov al, [CodeType]
 cmp al, 5
 jne .process281

;-97         check2Ops();

 call check2Ops

;-98 /*    prs("\n Op:"); printhex8a(Op);


;-99     prs(", Op2:"); printhex8a(Op2);


;-100     prs(", R1No:"); printhex8a(R1No);


;-101     prs(", R2No:"); printhex8a(R2No);   */


;-102         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process282

;-103             imme=disp;

 mov ax, [disp]
 mov word [imme], ax

;-104             Op2=IMM;//continue with IMM

 mov ax, 1
 mov byte [Op2], al

;-105         }


;-106         if (Op2 == IMM) {// r,i

.process282:
 mov al, [Op2]
 cmp al, 1
 jne .process283

;-107             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process284

;-108                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-109                 c += 0xB0;

 add  byte[bp-2], 176

;-110                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-111                 genImmediate();

 call genImmediate

;-112                 return;

 jmp .retnprocess

;-113             }


;-114             if (Op == MEM) {// m,i

.process284:
 mov al, [Op]
 cmp al, 4
 jne .process285

;-115                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-116                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-117                 genImmediate();

 call genImmediate

;-118                 return;

 jmp .retnprocess

;-119             }


;-120             regmemerror();

.process285:
 call regmemerror

;-121             return;

 jmp .retnprocess

;-122         }


;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process283:
 mov al, [R1Type]
 cmp al, 4
 jne .process286
 call ChangeDirection

;-124         if (R2Type == SEGREG) {//rm,sreg

.process286:
 mov al, [R2Type]
 cmp al, 4
 jne .process287

;-125             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process288
 call reg16error

;-126                 genCode2(0x8C, dflag);

.process288:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-127                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-128                 return;

 jmp .retnprocess

;-129         }


;-130         if (Op2 == MEM) {//acc, moffs16

.process287:
 mov al, [Op2]
 cmp al, 4
 jne .process289

;-131             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process290

;-132                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process291

;-133                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process292

;-134                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-135                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-136                         return;

 jmp .retnprocess

;-137                     }


;-138                 }

.process292:

;-139             }

.process291:

;-140         }

.process290:

;-141         if (Op == MEM) {//moffs16, acc

.process289:
 mov al, [Op]
 cmp al, 4
 jne .process293

;-142             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process294

;-143                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process295

;-144                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process296

;-145                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-146                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-147                         return;

 jmp .retnprocess

;-148                     }


;-149                 }

.process296:

;-150             }

.process295:

;-151 


;-152         }

.process294:

;-153         if (Op2 == REG) {//rm, r

.process293:
 mov al, [Op2]
 cmp al, 2
 jne .process297

;-154             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-155             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-156             return;

 jmp .retnprocess

;-157         }


;-158         if (Op2 == MEM) {//r, m

.process297:
 mov al, [Op2]
 cmp al, 4
 jne .process298

;-159             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process299

;-160                 ChangeDirection();

 call ChangeDirection

;-161                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-162                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-163                 return;

 jmp .retnprocess

;-164             }


;-165         }

.process299:

;-166         syntaxerror();

.process298:
 call syntaxerror

;-167         return;

 jmp .retnprocess

;-168     }


;-169 


;-170     if (CodeType == 6) {//Jcc

.process281:
 mov al, [CodeType]
 cmp al, 6
 jne .process300

;-171         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process301

;-172             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-173             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process302

;-174                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-175                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-176                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-177                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process303

;-178                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-179                     disp -= 2;

 sub  word[disp], 2

;-180                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-181                 } else {

 jmp .process304
.process303:

;-182                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-183                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-184                     disp -= 4;

 sub  word[disp], 4

;-185                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-186                 }


;-187             }

.process304:

;-188             else {//jump forward, near only

 jmp .process305
.process302:

;-189                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-190                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-191                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-192                 PrintRA='*';

 mov ax, 42
 mov byte [PrintRA], al

;-193                 storeJmpCall();

 call storeJmpCall

;-194             }


;-195         return;

.process305:
 jmp .retnprocess

;-196         }


;-197     }

.process301:

;-198 


;-199     if (CodeType == 7) {//jmp, call

.process300:
 mov al, [CodeType]
 cmp al, 7
 jne .process306

;-200         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process307

;-201             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-202             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process308

;-203                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-204                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-205                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-206                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process309

;-207                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process310

;-208                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-209                         disp -= 2;

 sub  word[disp], 2

;-210                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-211                     }


;-212                     else {

 jmp .process311
.process310:

;-213                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-214                         disp -= 3;

 sub  word[disp], 3

;-215                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-216                     }


;-217                 }

.process311:

;-218                 else {

 jmp .process312
.process309:

;-219                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-220                     disp -= 3;

 sub  word[disp], 3

;-221                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-222                 }


;-223             }

.process312:

;-224             else {//jump forward, near only

 jmp .process313
.process308:

;-225                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-226                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-227                 PrintRA='*';

 mov ax, 42
 mov byte [PrintRA], al

;-228                 storeJmpCall();

 call storeJmpCall

;-229             }


;-230         return;

.process313:
 jmp .retnprocess

;-231         }


;-232     }

.process307:

;-233 


;-234     if (CodeType ==  8) {//ret,retf

.process306:
 mov al, [CodeType]
 cmp al, 8
 jne .process314

;-235         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process315

;-236             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-237             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-238             return;

 jmp .retnprocess

;-239         }


;-240         genCode8(Code1);

.process315:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-241         return;

 jmp .retnprocess

;-242     }


;-243 


;-244     if (CodeType == 9) {//push, pop

.process314:
 mov al, [CodeType]
 cmp al, 9
 jne .process316

;-245         getOpL();

 call getOpL

;-246         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process317

;-247             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process318

;-248                 setsflag();

 call setsflag

;-249                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-250                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process319
 push word [imme]
 call genCode8
 add  sp, 2

;-251                 else       genCode16(imme);

 jmp .process320
.process319:
 push word [imme]
 call genCode16
 add  sp, 2

;-252                 return;

.process320:
 jmp .retnprocess

;-253             }


;-254         }

.process318:

;-255         if (R1Type == SEGREG) {

.process317:
 mov al, [R1Type]
 cmp al, 4
 jne .process321

;-256             if (Code1 == 0x58) {

 mov al, [Code1]
 cmp al, 88
 jne .process322

;-257                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process323
 push process_0
 call error1
 add  sp, 2

;-258             }

.process323:

;-259             c = R1No <<3;

.process322:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-260             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process324

;-261                 c += 122;

 add  byte[bp-2], 122

;-262                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-263             }


;-264             OpCodePtr++;

.process324:
 inc  word[OpCodePtr]

;-265             c = c + *OpCodePtr;//is Code4

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov [bp-2], al

;-266             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-267             return;

 jmp .retnprocess

;-268         }


;-269         checkOpL();

.process321:
 call checkOpL

;-270         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne .process325
 call reg16error

;-271         if (R1Type == WORD) {

.process325:
 mov al, [R1Type]
 cmp al, 2
 jne .process326

;-272             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-273             return;

 jmp .retnprocess

;-274         }


;-275         if (Op == MEM) {

.process326:
 mov al, [Op]
 cmp al, 4
 jne .process327

;-276             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-277             writeEA(Code3);

 mov al, byte [Code3]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-278             return;

 jmp .retnprocess

;-279         }


;-280         syntaxerror();

.process327:
 call syntaxerror

;-281         return;

 jmp .retnprocess

;-282     }


;-283 


;-284     if (CodeType == 11) {//shift, rotate

.process316:
 mov al, [CodeType]
 cmp al, 11
 jne .process328

;-285         check2Ops();

 call check2Ops

;-286         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process329

;-287             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process330

;-288                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-289                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-290                 return;

 jmp .retnprocess

;-291             }


;-292             genCodeW(0xC0);//80186

.process330:
 push 192
 call genCodeW
 add  sp, 2

;-293             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-294             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-295             return;

 jmp .retnprocess

;-296         }


;-297         if (Op2 == REG) {

.process329:
 mov al, [Op2]
 cmp al, 2
 jne .process331

;-298             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process332

;-299                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process333

;-300                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process334
 mov ax, 1
 mov byte [wflag], al

;-301                     genCodeW(0xD2);

.process334:
 push 210
 call genCodeW
 add  sp, 2

;-302                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-303                     return;

 jmp .retnprocess

;-304                 }


;-305             }

.process333:

;-306         }

.process332:

;-307     }

.process331:

;-308 


;-309     if (CodeType == 12) {//int

.process328:
 mov al, [CodeType]
 cmp al, 12
 jne .process335

;-310         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process336

;-311             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-312             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-313             return;

 jmp .retnprocess

;-314         }


;-315     }

.process336:

;-316 


;-317     if (CodeType == 30) {//enter i18,i8

.process335:
 mov al, [CodeType]
 cmp al, 30
 jne .process337

;-318         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-319         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-320         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process338
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-321         else numbererror();

 jmp .process339
.process338:
 call numbererror

;-322         need(',');

.process339:
 push 44
 call need
 add  sp, 2

;-323         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-324         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process340
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-325         else numbererror();

 jmp .process341
.process340:
 call numbererror

;-326         return;

.process341:
 jmp .retnprocess

;-327     }


;-328 


;-329     if (CodeType==101) {//ORG nn

.process337:
 mov al, [CodeType]
 cmp al, 101
 jne .process342

;-330         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process343
 call numbererror

;-331         Origin=SymbolInt;

.process343:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-332         return;

 jmp .retnprocess

;-333     }


;-334 


;-335     if (CodeType == 102) {//section, segment

.process342:
 mov al, [CodeType]
 cmp al, 102
 jne .process344

;-336         //getTokeType();//ignore .bss .text .data


;-337         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-338         return;

 jmp .retnprocess

;-339     }


;-340 


;-341     if (CodeType == 110) {//absolute

.process344:
 mov al, [CodeType]
 cmp al, 110
 jne .process345

;-342         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process346
 call numbererror

;-343         AbsoluteLab=SymbolInt;

.process346:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-344         return;

 jmp .retnprocess

;-345     }


;-346     if (CodeType == 111) {//name: PROC

.process345:
 mov al, [CodeType]
 cmp al, 111
 jne .process347

;-347         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process348

;-348           prs("\n;entering: ");

 push process_1
 call prs
 add  sp, 2

;-349           prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-350           isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-351         } else error1("already in proc");

 jmp .process349
.process348:
 push process_2
 call error1
 add  sp, 2

;-352         return;

.process349:
 jmp .retnprocess

;-353     }


;-354     if (CodeType == 112) {//ENDP

.process347:
 mov al, [CodeType]
 cmp al, 112
 jne .process350

;-355       prs("\n;leaving: ");

 push process_3
 call prs
 add  sp, 2

;-356       prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-357       isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-358       return;

 jmp .retnprocess

;-359     }


;-360     error1("Command not implemented or syntax error");

.process350:
 push process_4
 call error1
 add  sp, 2

;-361 }

 .retnprocess: LEAVE
 ret
process_0 db "pop cs not allowed",0
process_1 db "\n;entering: ",0
process_2 db "already in proc",0
process_3 db "\n;leaving: ",0
process_4 db "Command not implemented or syntax error",0
ENDP
 
; missing functions: 
; Number of unresolved CALLs :    0 All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width  adr used name   list of global variables

;    1 arr sign byte     1    2 Version1[9]
;    2 var sign byte     1    3 LIST
;    3 def unsg byte     2    - SYMBOLMAX=31
;    4 arr sign byte     3   12 Symbol[31]
;    5 arr sign byte     4   36 SymbolUpper[31]
;    6 arr sign byte     5    3 ProcName[31]
;    7 var sign byte     6    5 isInProc
;    8 var unsg word     7   24 SymbolInt
;    9 var unsg dwrd     8 NULL SymbolLong
;   10 def unsg byte     9    - INPUTBUFMAX=255
;   11 arr sign byte    10    4 InputBuf[255]
;   12 ptr unsg byte    11   24 InputPtr
;   13 arr sign byte    12    5 namein[67]
;   14 arr sign byte    13    6 namelst[67]
;   15 arr sign byte    14    6 namebin[67]
;   16 var sign word    15    4 asm_fd
;   17 var sign word    16    3 lst_fd
;   18 var sign word    17    3 bin_fd
;   19 var sign word    18    6 DOS_ERR
;   20 var sign word    19    4 ErrorCount
;   21 var sign word    20    4 DOS_NoBytes
;   22 var sign byte    21    5 DOS_ByteRead
;   23 var unsg word    23    7 PC
;   24 var unsg word    24    5 Origin
;   25 var unsg word    25    6 AbsoluteLab
;   26 var unsg word    26    2 PCStart
;   27 var sign byte    27    3 isLabel
;   28 def unsg byte    28    - DIGIT=1
;   29 def unsg byte    29    - LETTERE=2
;   30 def unsg byte    30    - ALNUME=3
;   31 def unsg byte    31    - NOALNUME=4
;   32 var sign byte    32   27 TokeType
;   33 def unsg byte    33    - BYTE=1
;   34 def unsg byte    34    - WORD=2
;   35 def unsg byte    35    - DWORD=3
;   36 def unsg byte    36    - SEGREG=4
;   37 def unsg byte    37    - IMM=1
;   38 def unsg byte    38    - REG=2
;   39 def unsg byte    39    - ADR=3
;   40 def unsg byte    40    - MEM=4
;   41 var sign byte    41   28 Op
;   42 var sign byte    42   31 Op2
;   43 var sign byte    43   29 CodeType
;   44 var sign byte    44   23 Code1
;   45 var sign byte    45    7 Code2
;   46 var sign byte    46    3 Code3
;   47 var sign byte    47   19 R2No
;   48 var sign byte    48   16 R1No
;   49 var sign byte    49   18 R2Type
;   50 var sign byte    50   15 R1Type
;   51 var sign byte    51   14 OpSize
;   52 var sign byte    52    9 wflag
;   53 var sign byte    53    3 dflag
;   54 var sign byte    54    8 sflag
;   55 var sign byte    55   15 rm
;   56 var sign byte    56    5 isDirect
;   57 var sign word    57   48 disp
;   58 var unsg word    58   13 imme
;   59 def unsg byte    60    - OPMAXLEN=5
;   60 arr sign byte    61    2 OpPos[5]
;   61 var sign word    62    6 OpPrintIndex
;   62 ptr sign byte    63   19 OpCodePtr
;   63 var sign byte    64    4 PrintRA
;   64 def unsg byte    66    - LABELNAMESMAX=3969
;   65 arr sign byte    67    3 LabelNames[4000]
;   66 ptr sign byte    68    5 LabelNamePtr
;   67 def unsg byte    69    - LABELADRMAX=600
;   68 arr unsg word    70    7 LabelAddr[600]
;   69 var sign word    71    7 LabelMaxIx
;   70 var sign word    72   10 LabelIx
;   71 def unsg byte    74    - JMPCALLNAMESMAX=1969
;   72 arr sign byte    75    3 JmpCallNames[2000]
;   73 ptr sign byte    76    5 JmpCallNamePtr
;   74 def unsg byte    77    - JMPCALLMAX=500
;   75 arr unsg word    78    2 JmpCallAddr[500]
;   76 var sign word    79    6 JmpCallMaxIx
;   77 def unsg byte    81    - FILEBINMAX=20000
;   78 arr sign byte    82    4 FileBin[20000]
;   79 var unsg word    83    6 BinLen
;   80 ptr sign byte    85    1 arglen
;   81 ptr sign byte    86    4 argv
;   82 var sign byte     1    1 I_START
;   83 arr sign byte     4 NULL I_PUSHA[1208]
;   84 arr sign byte     5 NULL I_NOP[39424]
;   85 arr sign byte     6 NULL I_CWDE[674]
;   86 arr sign byte     7 NULL I_CDQ[8125]
;   87 arr sign byte     8 NULL I_PUSHF[24260]
;   88 arr sign byte     9 NULL I_SAHF[9734]
;   89 arr sign byte    10 NULL I_MOVSB[1931]
;   90 arr sign byte    11 NULL I_CMPSB[35622]
;   91 arr sign byte    12 NULL I_STOSB[599]
;   92 arr sign byte    13 NULL I_LODSB[53495]
;   93 arr sign byte    14 NULL I_SCASB[54007]
;   94 arr sign byte    15 NULL I_LEAVE[37]
;   95 arr sign byte    16 NULL I_INTO[19520]
;   96 arr sign byte    17 NULL I_XLAT[53]
;   97 arr sign byte    18 NULL I_REPNE[13900]
;   98 arr sign byte    19 NULL I_REPE[19456]
;   99 arr sign byte    20 NULL I_HLT[55]
;  100 arr sign byte    21 NULL I_STC[14412]
;  101 arr sign byte    22 NULL I_STI[19456]
;  102 arr sign byte    23 NULL I_STD[56]
;  103 arr sign byte    25 NULL I_INC[18315]
;  104 arr sign byte    26 NULL I_DEC[9734]
;  105 arr sign byte    27 NULL I_NOT[32643]
;  106 arr sign byte    28 NULL I_NEG[10]
;  107 arr sign byte    29 NULL I_MUL[1397]
;  108 arr sign byte    30 NULL I_IMUL[18119]
;  109 arr sign byte    31 NULL I_DIV[65534]
;  110 arr sign byte    32 NULL I_IDIV[33791]
;  111 arr sign byte    34 NULL I_LES[65150]
;  112 arr sign byte    35 NULL I_LDS[30207]
;  113 arr sign byte    36 NULL I_LEA[15642]
;  114 arr sign byte    37 NULL I_LSS[65535]
;  115 arr sign byte    38 NULL I_LFS[5493]
;  116 arr sign byte    39 NULL I_LGS[33574]
;  117 arr sign byte    41 NULL I_ADD[1151]
;  118 arr sign byte    42 NULL I_OR[29696]
;  119 arr sign byte    43 NULL I_ADC[35593]
;  120 arr sign byte    44 NULL I_SBB[2630]
;  121 arr sign byte    45 NULL I_AND[14630]
;  122 arr sign byte    46 NULL I_SUB[1095]
;  123 arr sign byte    47 NULL I_XOR[26997]
;  124 arr sign byte    48 NULL I_CMP[49203]
;  125 arr sign byte    49 NULL I_TEST[52169]
;  126 arr sign byte    51 NULL I_MOV[33680]
;  127 arr sign byte    52 NULL I_MOVSX[65150]
;  128 arr sign byte    53 NULL I_MOVZX[29729]
;  129 arr sign byte    55 NULL I_JO[33618]
;  130 arr sign byte    56 NULL I_JNO[65150]
;  131 arr sign byte    57 NULL I_JB[29731]
;  132 arr sign byte    58 NULL I_JNB[33612]
;  133 arr sign byte    59 NULL I_JAE[65150]
;  134 arr sign byte    60 NULL I_JE[29732]
;  135 arr sign byte    61 NULL I_JNE[33606]
;  136 arr sign byte    62 NULL I_JBE[65150]
;  137 arr sign byte    63 NULL I_JA[29734]
;  138 arr sign byte    64 NULL I_JS[33600]
;  139 arr sign byte    65 NULL I_JNS[65150]
;  140 arr sign byte    66 NULL I_JP[29730]
;  141 arr sign byte    67 NULL I_JNP[33594]
;  142 arr sign byte    68 NULL I_JL[65150]
;  143 arr sign byte    69 NULL I_JNL[29737]
;  144 arr sign byte    70 NULL I_JLE[33588]
;  145 arr sign byte    71 NULL I_JG[65150]
;  146 arr sign byte    73 NULL I_JMP[29736]
;  147 arr sign byte    74 NULL I_CALL[33582]
;  148 arr sign byte    76 NULL I_RET[65150]
;  149 arr sign byte    77 NULL I_RETF[29733]
;  150 arr sign byte    79 NULL I_PUSH[15656]
;  151 arr sign byte    80 NULL I_POP[33]
;  152 arr sign byte    82 NULL I_ROL[9076]
;  153 arr sign byte    83 NULL I_RCL[9021]
;  154 arr sign byte    84 NULL I_SHL[29696]
;  155 arr sign byte    85 NULL I_SHR[15646]
;  156 arr sign byte    87 NULL I_INT[36]
;  157 arr sign byte    89 NULL I_IN[6516]
;  158 arr sign byte    90 NULL I_INSB[9789]
;  159 arr sign byte    91 NULL I_INSW[29696]
;  160 arr sign byte    92 NULL I_INSD[15636]
;  161 arr sign byte    93 NULL I_OUT[34]
;  162 arr sign byte    94 NULL I_OUTSB[3956]
;  163 arr sign byte    95 NULL I_OUTSW[10557]
;  164 arr sign byte    96 NULL I_OUTSD[29696]
;  165 arr sign byte    98 NULL I_XCHG[15626]
;  166 arr sign byte   100 NULL I_LOOPNZ[40]
;  167 arr sign byte   101 NULL I_LOOPNE[1396]
;  168 arr sign byte   102 NULL I_LOOPZ[9533]
;  169 arr sign byte   103 NULL I_LOOPE[29952]
;  170 arr sign byte   104 NULL I_LOOP[33542]
;  171 arr sign byte   105 NULL I_JCXZ[2686]
;  172 arr sign byte   106 NULL I_JECXZ[60176]
;  173 arr sign byte   108 NULL I_ENTER[33540]
;  174 arr sign byte   110 NULL I_ORG[2686]
;  175 arr sign byte   112 NULL I_SECTION[29984]
;  176 arr sign byte   113 NULL I_SEGMENT[47255]
;  177 arr sign byte   114 NULL I_ABSOLUTE[1]
;  178 arr sign byte   115 NULL I_PROC[52169]
;  179 arr sign byte   116 NULL I_ENDP[21904]
;  180 arr sign byte   117 NULL I_DB[60555]
;  181 arr sign byte   118 NULL I_DW[5816]
;  182 arr sign byte   119 NULL I_DD[39424]
;  183 arr sign byte   120 NULL I_RESB[674]
;  184 arr sign byte   121 NULL I_RESW[8125]
;  185 arr sign byte   122 NULL I_RESD[51030]
;  186 var sign byte   123 NULL I_END


;   # Calls Line Width  Name   list of functions

;    0    2    1   ChangeDirection
;    1    2    9   checkOpL
;    2    4   18   check2Ops
;    3    1   27   get2Ops
;    4    3   33   getOpL
;    5    2   41   getOpR
;    6    4   51   getOp1
;    7    1   67   getMEM
;    8    1   90   getIndReg1
;    9    1   98   getIndReg2
;   10    2  108   setwflag
;   11    2  119   setsflag
;   12    2  129   checkConstSize
;   13    1    1   parse
;   14   16   37   getTokeType
;   15    2   48   storeJmpCall
;   16    2   59   storeLabel
;   17    5   71   searchLabel
;   18    1   84   getVariable
;   19    2  137   lookCode
;   20    1  153   getCodeSize
;   21    9  161   isToken
;   22    2  169   need
;   23    1  178   skipRest
;   24    4    1   writetty
;   25    1    2   putch
;   26    8    3   cputs
;   27    6    5   DosInt
;   28    1   10   openR
;   29    2   11   creatR
;   30    3   12   fcloseR
;   31    5   13   exitR
;   32    2   14   readRL
;   33    2   15   fputcR
;   34    1   18   getLine
;   35    1   34   ifEOL
;   36    3   43   skipBlank
;   37    2   48   letterE
;   38    1   58   alnumE
;   39    3   63   digit
;   40    4   68   strlen
;   41    9   73   strcpy
;   42   35   79   eqstr
;   43    3   88   strcat1
;   44    2   92   toupper
;   45    1   99   getDigit
;   46    1  111   getName
;   47    1  130   testReg
;   48    1    1   printLine
;   49    7   23   prc
;   50    1   35   prscomment
;   51   32   43   prs
;   52    3   65   printhex8a
;   53    2   70   printhex4
;   54    1   75   printhex16
;   55    5   80   printIntU
;   56   27   91   error1
;   57   13   99   errorexit
;   58 NULL  104   allowederror
;   59    3  105   addrerror
;   60    1  106   immeerror
;   61    2  107   implerror
;   62    4  108   indexerror
;   63    3  109   invaloperror
;   64    6  110   numbererror
;   65    1  111   regmemerror
;   66    3  112   reg16error
;   67    1  113   segregerror
;   68    5  114   syntaxerror
;   69 NULL  116   addrexit
;   70    3  117   dataexit
;   71 NULL  118   internexit
;   72 NULL    1   main
;   73    1    9   getarg
;   74    1   43   fixJmpCall
;   75    2   74   epilog
;   76    2  122   end1
;   77    1    2   getCodes
;   78    1    7   gen66h
;   79    8    9   genCode2
;   80   13   13   genCodeW
;   81   33   17   genCode8
;   82   17   28   genCode16
;   83    1   32   genCode32
;   84   13   36   writeEA
;   85    4   78   genImmediate
;   86    1   11   process
;   87 NULL  361   LastFunctionByt

;    #  addr name   list of CALLs

;    0     0 implerror
;    1    10 segregerror
;    2    22 setwflag
;    3    31 error1
;    4    38 error1
;    5    45 get2Ops
;    6    53 addrerror
;    7    63 invaloperror
;    8    76 immeerror
;    9    86 addrerror
;   10    96 invaloperror
;   11   109 setwflag
;   12   118 getOpL
;   13   125 need
;   14   130 getOpR
;   15   137 getOpR
;   16   144 getOp1
;   17   151 isToken
;   18   159 getMEM
;   19   166 invaloperror
;   20   179 error1
;   21   186 testReg
;   22   194 searchLabel
;   23   206 error1
;   24   213 getTokeType
;   25   225 getOp1
;   26   232 syntaxerror
;   27   244 getIndReg2
;   28   255 getIndReg1
;   29   266 isToken
;   30   274 getTokeType
;   31   286 numbererror
;   32   298 isToken
;   33   306 isToken
;   34   314 errorexit
;   35   324 indexerror
;   36   335 indexerror
;   37   346 indexerror
;   38   357 indexerror
;   39   368 gen66h
;   40   375 error1
;   41   382 getLine
;   42   390 getTokeType
;   43   402 strcpy
;   44   409 storeLabel
;   45   420 getTokeType
;   46   432 lookCode
;   47   441 process
;   48   449 getVariable
;   49   461 skipRest
;   50   470 error1
;   51   477 error1
;   52   484 printLine
;   53   494 skipBlank
;   54   504 digit
;   55   510 getDigit
;   56   519 letterE
;   57   527 getName
;   58   535 errorexit
;   59   545 strcpy
;   60   552 errorexit
;   61   562 errorexit
;   62   572 searchLabel
;   63   584 error1
;   64   591 strcpy
;   65   598 errorexit
;   66   608 eqstr
;   67   614 strlen
;   68   621 storeLabel
;   69   632 getTokeType
;   70   644 lookCode
;   71   653 dataexit
;   72   662 dataexit
;   73   671 getTokeType
;   74   683 genCode8
;   75   692 skipBlank
;   76   702 isToken
;   77   710 genCode8
;   78   719 isToken
;   79   727 getTokeType
;   80   739 genCode16
;   81   749 isToken
;   82   757 getTokeType
;   83   769 genCode16
;   84   779 genCode16
;   85   789 isToken
;   86   797 getTokeType
;   87   809 syntaxerror
;   88   821 error1
;   89   828 numbererror
;   90   840 dataexit
;   91   849 eqstr
;   92   855 eqstr
;   93   861 getTokeType
;   94   873 eqstr
;   95   879 getTokeType
;   96   891 eqstr
;   97   897 getTokeType
;   98   909 skipBlank
;   99   919 isToken
;  100   927 getTokeType
;  101   939 error1
;  102   946 prs
;  103   950 prc
;  104   954 getTokeType
;  105   966 error1
;  106   973 writetty
;  107   982 writetty
;  108   991 putch
;  109   997 DosInt
;  110  1004 DosInt
;  111  1011 DosInt
;  112  1018 DosInt
;  113  1025 DosInt
;  114  1032 DosInt
;  115  1039 readRL
;  116  1046 errorexit
;  117  1056 errorexit
;  118  1066 ifEOL
;  119  1072 readRL
;  120  1079 errorexit
;  121  1089 digit
;  122  1095 letterE
;  123  1103 strcpy
;  124  1110 digit
;  125  1116 alnumE
;  126  1123 errorexit
;  127  1133 strcpy
;  128  1140 toupper
;  129  1148 strlen
;  130  1155 strlen
;  131  1162 eqstr
;  132  1168 eqstr
;  133  1174 eqstr
;  134  1180 eqstr
;  135  1186 eqstr
;  136  1192 eqstr
;  137  1198 eqstr
;  138  1204 eqstr
;  139  1210 eqstr
;  140  1216 eqstr
;  141  1222 eqstr
;  142  1228 eqstr
;  143  1234 eqstr
;  144  1240 eqstr
;  145  1246 eqstr
;  146  1252 eqstr
;  147  1258 eqstr
;  148  1264 eqstr
;  149  1270 eqstr
;  150  1276 eqstr
;  151  1282 eqstr
;  152  1288 eqstr
;  153  1294 eqstr
;  154  1300 eqstr
;  155  1306 eqstr
;  156  1312 eqstr
;  157  1318 eqstr
;  158  1324 eqstr
;  159  1330 eqstr
;  160  1336 eqstr
;  161  1342 prs
;  162  1346 printhex16
;  163  1357 prs
;  164  1361 prc
;  165  1365 printhex8a
;  166  1376 prs
;  167  1380 prc
;  168  1384 prscomment
;  169  1395 writetty
;  170  1404 writetty
;  171  1413 fputcR
;  172  1420 prc
;  173  1424 prc
;  174  1428 printhex4
;  175  1438 printhex4
;  176  1448 prc
;  177  1452 printhex8a
;  178  1463 printhex8a
;  179  1474 printIntU
;  180  1484 prc
;  181  1488 prs
;  182  1492 prs
;  183  1496 prs
;  184  1500 prs
;  185  1504 error1
;  186  1511 epilog
;  187  1518 end1
;  188  1523 error1
;  189  1530 error1
;  190  1537 error1
;  191  1544 error1
;  192  1551 error1
;  193  1558 error1
;  194  1565 error1
;  195  1572 error1
;  196  1579 error1
;  197  1586 error1
;  198  1593 error1
;  199  1600 errorexit
;  200  1610 errorexit
;  201  1620 errorexit
;  202  1630 getarg
;  203  1637 parse
;  204  1643 fixJmpCall
;  205  1654 epilog
;  206  1661 end1
;  207  1666 cputs
;  208  1672 cputs
;  209  1678 exitR
;  210  1684 toupper
;  211  1692 strcpy
;  212  1699 strcat1
;  213  1707 strcpy
;  214  1714 strcat1
;  215  1722 strcpy
;  216  1729 strcat1
;  217  1737 openR
;  218  1743 cputs
;  219  1749 cputs
;  220  1755 exitR
;  221  1761 creatR
;  222  1768 cputs
;  223  1774 cputs
;  224  1780 exitR
;  225  1786 creatR
;  226  1793 cputs
;  227  1799 cputs
;  228  1805 exitR
;  229  1811 prs
;  230  1815 prs
;  231  1819 prs
;  232  1823 prs
;  233  1827 prs
;  234  1831 prs
;  235  1835 prs
;  236  1839 prs
;  237  1843 prs
;  238  1847 prs
;  239  1851 printIntU
;  240  1861 strcpy
;  241  1868 strlen
;  242  1875 searchLabel
;  243  1887 error1
;  244  1894 prs
;  245  1898 printIntU
;  246  1908 prs
;  247  1912 prs
;  248  1916 prs
;  249  1920 prs
;  250  1924 prs
;  251  1928 prs
;  252  1932 printIntU
;  253  1942 prs
;  254  1946 fputcR
;  255  1953 prs
;  256  1957 printIntU
;  257  1967 prs
;  258  1971 fcloseR
;  259  1979 fcloseR
;  260  1987 fcloseR
;  261  1995 exitR
;  262  2001 genCode8
;  263  2010 genCode8
;  264  2019 genCode8
;  265  2028 errorexit
;  266  2038 genCode8
;  267  2047 genCode8
;  268  2056 genCode16
;  269  2066 genCode16
;  270  2076 genCode8
;  271  2085 genCode8
;  272  2094 genCode16
;  273  2104 genCode32
;  274  2114 genCode16
;  275  2124 genCode8
;  276  2133 getTokeType
;  277  2145 getCodeSize
;  278  2157 getCodes
;  279  2166 genCode8
;  280  2175 getOpL
;  281  2182 checkOpL
;  282  2191 genCode2
;  283  2200 getTokeType
;  284  2212 implerror
;  285  2222 genCodeW
;  286  2231 writeEA
;  287  2239 check2Ops
;  288  2249 reg16error
;  289  2260 addrerror
;  290  2270 genCode8
;  291  2279 genCode8
;  292  2288 writeEA
;  293  2296 check2Ops
;  294  2306 setsflag
;  295  2315 genCodeW
;  296  2324 genImmediate
;  297  2337 genCodeW
;  298  2346 writeEA
;  299  2354 genCode8
;  300  2363 genImmediate
;  301  2376 genCodeW
;  302  2385 writeEA
;  303  2393 genCodeW
;  304  2402 writeEA
;  305  2410 syntaxerror
;  306  2422 check2Ops
;  307  2432 genCode2
;  308  2441 genImmediate
;  309  2454 genCodeW
;  310  2463 writeEA
;  311  2471 genImmediate
;  312  2484 regmemerror
;  313  2496 ChangeDirection
;  314  2512 reg16error
;  315  2523 genCode2
;  316  2532 writeEA
;  317  2540 genCodeW
;  318  2549 genCode16
;  319  2559 genCodeW
;  320  2568 genCode16
;  321  2578 genCodeW
;  322  2587 writeEA
;  323  2595 ChangeDirection
;  324  2611 genCodeW
;  325  2620 writeEA
;  326  2628 syntaxerror
;  327  2640 searchLabel
;  328  2652 checkConstSize
;  329  2667 genCode2
;  330  2676 genCode8
;  331  2685 genCode8
;  332  2694 genCode2
;  333  2703 genCode16
;  334  2713 genCode8
;  335  2722 genCode2
;  336  2731 genCode16
;  337  2741 storeJmpCall
;  338  2754 searchLabel
;  339  2766 checkConstSize
;  340  2781 genCode8
;  341  2790 genCode8
;  342  2799 genCode8
;  343  2808 genCode16
;  344  2818 genCode8
;  345  2827 genCode16
;  346  2837 genCode8
;  347  2846 genCode16
;  348  2856 storeJmpCall
;  349  2869 genCode8
;  350  2878 genCode16
;  351  2888 genCode8
;  352  2897 getOpL
;  353  2904 setsflag
;  354  2913 genCode2
;  355  2922 genCode8
;  356  2931 genCode16
;  357  2941 error1
;  358  2948 genCode8
;  359  2957 genCode8
;  360  2966 checkOpL
;  361  2975 reg16error
;  362  2986 genCode2
;  363  2995 genCode8
;  364  3004 writeEA
;  365  3012 syntaxerror
;  366  3024 check2Ops
;  367  3034 genCodeW
;  368  3043 writeEA
;  369  3051 genCodeW
;  370  3060 writeEA
;  371  3068 genCode8
;  372  3077 genCodeW
;  373  3086 writeEA
;  374  3094 genCode8
;  375  3103 genCode8
;  376  3112 genCode8
;  377  3121 getOp1
;  378  3128 genCode16
;  379  3138 numbererror
;  380  3150 need
;  381  3155 getOp1
;  382  3162 genCode8
;  383  3171 numbererror
;  384  3183 numbererror
;  385  3195 numbererror
;  386  3207 prs
;  387  3211 prs
;  388  3215 error1
;  389  3222 prs
;  390  3226 prs
;  391  3230 error1
;Input: AS.C, List: AS.S,  Lines:  362
;Glob. variables:  186 max.:  200
;Functions      :   88 max.:  300
;Calls          :  392 max.: 2000, NameField: 3237 max.:    65535
;Code until     :21667 max.: 30000, free: 8333
;Data (HeapEnd) :58754, resting stacksize:  6781
;Max. Const in 'testReg' :  658 max. 3000, free: 2342