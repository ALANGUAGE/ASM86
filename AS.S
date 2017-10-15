
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


;-88 #define FILEBINMAX 20000


;-89 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 42154
FileBin resb 20000
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


;-96 //#include "OPTABL.C"


;-97 char I_START=0xF1;

I_START db 241

;-98 //OpName, 0, CodeType, OpCode1-n, F1h


;-99 //  1:   1 byte opcode


;-100 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-101 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-102 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-103 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-104 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-105 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-106 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-107 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-108 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-109 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-110 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-111 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-112 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-113 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-114 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-115 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-116 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-117 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-118 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-119 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-120 // 2: mem reg 16 bit


;-121 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-122 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-123 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-124 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-125 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-126 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-127 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-128 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-129 //  3: les, lda, lea, lss, lfs, lgs


;-130 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-131 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-132 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-133 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-134 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-135 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-136 //  4: acc,imm  reg,imm  index,reg


;-137 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-138 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-139 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-140 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-141 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-142 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-143 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-144 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-145 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-146 //  5: mov


;-147 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-148 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-149 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-150 //  6: single byte relative jump


;-151 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-152 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-153 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-154 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-155 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-156 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-157 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-158 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-159 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-160 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-161 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-162 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-163 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-164 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-165 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-166 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-167 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-168 //  7: jmp, call


;-169 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-170 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-171 //  8: ret


;-172 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-173 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-174 //  9: seg, r/m


;-175 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,255,6,6,241

;-176 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16

I_POP db 80,79,80,0,9,88,143,0,7,241

;-177 //  11: shift, rotates


;-178 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-179 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-180 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-181 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-182 //  12: int


;-183 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-184 //  14: in/out


;-185 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-186 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-187 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-188 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-189 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-190 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-191 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-192 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-193 //  15: xchg


;-194 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-195 //  16: loop, jcxz


;-196 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-197 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-198 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-199 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-200 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-201 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-202 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-203 //  30: enter


;-204 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-205 // 100: directives


;-206 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-207 // section, segment .TEXT .DATA .BSS


;-208 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-209 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-210 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-211 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-212 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-213 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-214 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-215 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-216 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-217 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-218 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-219 char I_END=0;// end of table char

I_END db 0

;-220 


;-221 int lookCode() {//ret: CodeType, *OpCodePtr


lookCode: PROC

;-222     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-223     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-224     OpCodePtr++;

 inc  word[OpCodePtr]

;-225     do  {

.lookCode1:

;-226         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode2

;-227             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode3:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode4
 inc  word[OpCodePtr]

;-228             OpCodePtr++;

 jmp .lookCode3
.lookCode4:
 inc  word[OpCodePtr]

;-229             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-230             return;

 jmp .retnlookCode

;-231         }


;-232     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode2:
.lookCode5:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode6
 inc  word[OpCodePtr]

;-233     OpCodePtr++;

 jmp .lookCode5
.lookCode6:
 inc  word[OpCodePtr]

;-234     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode7
 jmp .lookCode1
.lookCode7:

;-235 }


;-236 


;-237 //#include "OPS.C"


;-238 int ChangeDirection() {

 .retnlookCode:
 ret
ENDP

ChangeDirection: PROC

;-239     char c;


;-240     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   239 NULL c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-241     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-242     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-243     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-244 }


;-245 


;-246 int checkOpL() {
 LEAVE
 ret
ENDP

checkOpL: PROC

;-247     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL8
 call implerror

;-248     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL8:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL9
 call segregerror
 jmp .retncheckOpL

;-249     setwflag();

.checkOpL9:
 call setwflag

;-250     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL10
 push checkOpL_0
 call error1
 add  sp, 2

;-251     if (OpSize == R1Type) return;

.checkOpL10:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL11
 jmp .retncheckOpL

;-252     if (Op == REG) if (R1Type==0) error1("no register defined");

.checkOpL11:
 mov al, [Op]
 cmp al, 2
 jne .checkOpL12
 mov al, [R1Type]
 cmp al, 0
 jne .checkOpL13
 push checkOpL_1
 call error1
 add  sp, 2

;-253 }

.checkOpL13:
.checkOpL12:

;-254 


;-255 int check2Ops() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

check2Ops: PROC

;-256     get2Ops();

 call get2Ops

;-257     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops14
 call addrerror

;-258     if (Op == ADR) invaloperror();

.check2Ops14:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops15
 call invaloperror

;-259     if (Op == IMM) immeerror();

.check2Ops15:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops16
 call immeerror

;-260     if (Op2==   0) addrerror();

.check2Ops16:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops17
 call addrerror

;-261     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov

.check2Ops17:
 mov al, [CodeType]
 cmp al, 5
 je  .check2Ops18
 mov al, [Op2]
 cmp al, 3
 jne .check2Ops19
 call invaloperror

;-262     setwflag();

.check2Ops19:
.check2Ops18:
 call setwflag

;-263 }


;-264 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-265     getOpL();

 call getOpL

;-266     need(',');

 push 44
 call need
 add  sp, 2

;-267     getOpR();

 call getOpR

;-268 }


;-269 


;-270 int getOpL() {

 ret
ENDP

getOpL: PROC

;-271 //set: op=0,IMM,REG,ADR,MEM


;-272     getOpR();

 call getOpR

;-273     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-274     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-275     R1Type=R2Type; R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-276 }


;-277 


;-278 int getOpR() {

 ret
ENDP

getOpR: PROC

;-279     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-280     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR20
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-281     if (Op2 == 0)     {invaloperror();         return;}

.getOpR20:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR21
 call invaloperror
 jmp .retngetOpR

;-282     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR21:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR22
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-283     if (Op2 == REG)                            return;

.getOpR22:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR23
 jmp .retngetOpR

;-284     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}

.getOpR23:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR24
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp .retngetOpR

;-285     error1("Name of operand expected");

.getOpR24:
 push getOpR_0
 call error1
 add  sp, 2

;-286 }


;-287 


;-288 int getOp1() {//scan for a single operand

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOp1: PROC

;-289 //return:0, IMM, REG, ADR (not MEM)


;-290 //set   :R2Type, R2No by testReg


;-291 //set   :LabelIx by searchLabel


;-292     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp125
 mov ax, 0
 jmp .retngetOp1

;-293     if (TokeType == DIGIT)  return IMM;

.getOp125:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp126
 mov ax, 1
 jmp .retngetOp1

;-294     if (TokeType == ALNUME) {

.getOp126:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp127

;-295         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-296         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp128
 mov ax, 2
 jmp .retngetOp1

;-297         LabelIx=searchLabel();

.getOp128:
 call searchLabel
 mov word [LabelIx], ax

;-298         return ADR;

 mov ax, 3
 jmp .retngetOp1

;-299 //        if (LabelIx)        return ADR;


;-300 //        else error1("variable not found");


;-301     }


;-302     return 0;

.getOp127:
 mov ax, 0
 jmp .retngetOp1

;-303 }


;-304 


;-305 int getMEM() {// e.g. [array+bp+si-4]

 .retngetOp1:
 ret
ENDP

getMEM: PROC

;-306 //set: disp, rm, R2Type


;-307     char c;


;-308     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   307 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-309     do {

.getMEM29:

;-310         getTokeType();

 call getTokeType

;-311         c=getOp1();

 call getOp1
 mov [bp-2], al

;-312         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM30
 call syntaxerror

;-313         if (c == REG) {

.getMEM30:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM31

;-314             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-315             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM32
 call getIndReg2
 mov byte [rm], al

;-316             else getIndReg1();

 jmp .getMEM33
.getMEM32:
 call getIndReg1

;-317         }

.getMEM33:

;-318         if (c == ADR) {

.getMEM31:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM34

;-319             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM35
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-320             else notfounderror();

 jmp .getMEM36
.getMEM35:
 call notfounderror

;-321         }

.getMEM36:

;-322         if (c == IMM) disp=disp+SymbolInt;

.getMEM34:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM37
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-323         if (isToken('-')) {

.getMEM37:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM38

;-324             getTokeType();

 call getTokeType

;-325             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM39
 call numbererror

;-326             disp = disp - SymbolInt;

.getMEM39:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-327         }


;-328     } while (isToken('+'));

.getMEM38:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM40
 jmp .getMEM29
.getMEM40:

;-329     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM41
 push getMEM_0
 call errorexit
 add  sp, 2

;-330 }

.getMEM41:

;-331 int getIndReg1() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getIndReg1: PROC

;-332     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg142
 call indexerror

;-333     if (R2No==3) rm=7;//BX

.getIndReg142:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg143
 mov ax, 7
 mov byte [rm], al

;-334     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg143:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg144
 mov ax, 6
 mov byte [rm], al

;-335     if (R2No==7) rm=5;//DI

.getIndReg144:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg145
 mov ax, 5
 mov byte [rm], al

;-336     if (R2No==6) rm=4;//SI

.getIndReg145:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg146
 mov ax, 4
 mov byte [rm], al

;-337     if (rm==0) indexerror();

.getIndReg146:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg147
 call indexerror

;-338 }

.getIndReg147:

;-339 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   339 NULL m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-340     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg248
 call indexerror

;-341     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg248:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg249
 mov al, [rm]
 cmp al, 6
 jne .getIndReg250
 mov ax, 3
 mov [bp-2], al

;-342              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg251
.getIndReg250:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg252
 mov ax, 1
 mov [bp-2], al

;-343     if (R2No==6) if (rm==6) m=2;//BP+SI

.getIndReg252:
.getIndReg251:
.getIndReg249:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg253
 mov al, [rm]
 cmp al, 6
 jne .getIndReg254
 mov ax, 2
 mov [bp-2], al

;-344              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg255
.getIndReg254:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg256
 mov ax, 0
 mov [bp-2], al

;-345     if (m > 3) indexerror();

.getIndReg256:
.getIndReg255:
.getIndReg253:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg257
 call indexerror

;-346     return m;

.getIndReg257:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-347 }


;-348 


;-349 int setwflag() {//word size, bit 0

 .retngetIndReg2: LEAVE
 ret
ENDP

setwflag: PROC

;-350     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-351     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag58

;-352         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag59
 mov al, [R1Type]
 mov byte [OpSize], al

;-353         if (Op2== REG) OpSize=R2Type;

.setwflag59:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag60
 mov al, [R2Type]
 mov byte [OpSize], al

;-354         if (R2Type== SEGREG) OpSize=WORD;

.setwflag60:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag61
 mov ax, 2
 mov byte [OpSize], al

;-355         if (R1Type == SEGREG) OpSize=WORD;

.setwflag61:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag62
 mov ax, 2
 mov byte [OpSize], al

;-356     }

.setwflag62:

;-357     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag58:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag63
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-358     if (OpSize  ==  WORD) wflag=1;

.setwflag63:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag64
 mov ax, 1
 mov byte [wflag], al

;-359 }

.setwflag64:

;-360 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-361     unsigned int ui;


;-362     sflag=2;

;Function : setsflag, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   361 NULL ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-363     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-364     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag65
 mov ax, 0
 mov byte [sflag], al

;-365     if (OpSize == BYTE) {

.setsflag65:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag66

;-366         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag67
 push setsflag_0
 call error1
 add  sp, 2

;-367         sflag=0;//byte reg does not need sign extended

.setsflag67:
 mov ax, 0
 mov byte [sflag], al

;-368     }


;-369 }

.setsflag66:

;-370 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-371     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   370 NULL ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize68
 mov ax, 0
 jmp .retncheckConstSize

;-372     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize68:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize69
 mov ax, 0
 jmp .retncheckConstSize

;-373     return 2;// is short

.checkConstSize69:
 mov ax, 2
 jmp .retncheckConstSize

;-374 }


;-375 


;-376 


;-377 //#include "PARSE.C"


;-378 int parse() {

 .retncheckConstSize: LEAVE
 ret
ENDP

parse: PROC

;-379     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-380     JmpNamePtr= &JmpNames;

 mov ax, JmpNames
 mov word [JmpNamePtr], ax

;-381     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-382     JmpMaxIx=0;

 mov ax, 0
 mov word [JmpMaxIx], ax

;-383     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-384     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-385 


;-386     do {//process a new line

.parse70:

;-387         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-388         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-389         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-390         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-391         getLine();

 call getLine

;-392         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-393         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-394         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse71

;-395             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse72

;-396               if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse73
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-397                 storeLabel();

.parse73:
 call storeLabel

;-398                 InputPtr++;//remove :

 inc  word[InputPtr]

;-399                 getTokeType();

 call getTokeType

;-400             }


;-401         }

.parse72:

;-402         if (TokeType == ALNUME) {

.parse71:
 mov al, [TokeType]
 cmp al, 3
 jne .parse74

;-403             lookCode();// and OpCodePtr

 call lookCode

;-404             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse75
 call process

;-405             else getVariable();

 jmp .parse76
.parse75:
 call getVariable

;-406             skipRest();

.parse76:
 call skipRest

;-407         }


;-408         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp .parse77
.parse74:
 mov al, [TokeType]
 cmp al, 3
 jle .parse78
 push parse_0
 call error1
 add  sp, 2

;-409         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp .parse79
.parse78:
 mov al, [TokeType]
 cmp al, 1
 jne .parse80
 push parse_1
 call error1
 add  sp, 2

;-410         printLine();

.parse80:
.parse79:
.parse77:
 call printLine

;-411     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse81
 jmp .parse70
.parse81:

;-412 }


;-413 


;-414 int getTokeType() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0
ENDP

getTokeType: PROC

;-415     char c;


;-416     skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   415 NULL c = bp-2;
 ENTER  2,0
 call skipBlank

;-417     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-418     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType82
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-419     if (c == ';') {TokeType=0; return; }//comment

.getTokeType82:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType83
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-420     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

.getTokeType83:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getTokeType84
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov ax, 1
 mov byte [TokeType], al
 jmp .retngetTokeType

;-421     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

.getTokeType84:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je .getTokeType85
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov ax, 3
 mov byte [TokeType], al
 jmp .retngetTokeType

;-422     TokeType=NOALNUME;

.getTokeType85:
 mov ax, 4
 mov byte [TokeType], al

;-423 }


;-424 


;-425 int storeJmp() {

 .retngetTokeType: LEAVE
 ret
ENDP

storeJmp: PROC

;-426     unsigned int i;


;-427     JmpMaxIx++;

;Function : storeJmp, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   426 NULL i = bp-2;
 ENTER  2,0
 inc  word[JmpMaxIx]

;-428     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");

 mov ax, [JmpMaxIx]
 cmp ax, 200 ;unsigned : 1
 jl  .storeJmp86
 push storeJmp_0
 call errorexit
 add  sp, 2

;-429     JmpNamePtr=strcpy(JmpNamePtr, Symbol);

.storeJmp86:
 lea  ax, [Symbol]
 push ax
 push word [JmpNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpNamePtr], ax

;-430     JmpNamePtr++;

 inc  word[JmpNamePtr]

;-431     i = JmpNamePtr - &JmpNames;

 mov ax, [JmpNamePtr]
 sub ax, JmpNames
 mov [bp-2], ax

;-432     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeJmp87
 push storeJmp_1
 call errorexit
 add  sp, 2

;-433     JmpAddr[JmpMaxIx] = PC;

.storeJmp87:
 mov ax, [PC]
 mov bx, [JmpMaxIx]
 shl bx, 1
 mov [JmpAddr+bx], ax

;-434 }


;-435 


;-436 int storeLabel() {
 LEAVE
 ret
storeJmp_0 db "too many Jmp",0
storeJmp_1 db "too many Jmp names",0
ENDP

storeLabel: PROC

;-437     unsigned int i;


;-438     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   437 NULL i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel88
 push storeLabel_0
 call error1
 add  sp, 2

;-439     LabelMaxIx++;

.storeLabel88:
 inc  word[LabelMaxIx]

;-440     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel89
 push storeLabel_1
 call errorexit
 add  sp, 2

;-441     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel89:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-442     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-443     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-444     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 5969 ;unsigned : 0
 jb  .storeLabel90
 push storeLabel_2
 call errorexit
 add  sp, 2

;-445     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel90:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-446 }


;-447 


;-448 int searchLabel() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

searchLabel: PROC

;-449     int LIx; char *p;


;-450     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   449 NULL LIx = bp-2
;  201 ptr sign byte   449 NULL p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-451     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-452     while (LIx <= LabelMaxIx) {

.searchLabel91:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel92

;-453         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel93
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-454         p=strlen(p) + p;

.searchLabel93:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-455         p++;

 inc  word[bp-4]

;-456         LIx++;

 inc  word[bp-2]

;-457     }


;-458     return 0;

 jmp .searchLabel91
.searchLabel92:
 mov ax, 0
 jmp .retnsearchLabel

;-459 }


;-460 


;-461 int getVariable() {

 .retnsearchLabel: LEAVE
 ret
ENDP

getVariable: PROC

;-462     char c;


;-463     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   462 NULL c = bp-2;
 ENTER  2,0
 call storeLabel

;-464     getTokeType();

 call getTokeType

;-465     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable94

;-466         lookCode();

 call lookCode

;-467         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable95
 call dataexit

;-468         if (CodeType > 205) dataexit();

.getVariable95:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable96
 call dataexit

;-469         if (CodeType== 200) {//DB

.getVariable96:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable97

;-470             do {

.getVariable98:

;-471                 getTokeType();

 call getTokeType

;-472                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable99
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-473                 else {

 jmp .getVariable100
.getVariable99:

;-474                     skipBlank();

 call skipBlank

;-475                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable101

;-476                         do {

.getVariable102:

;-477                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-478                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-479                             InputPtr++;

 inc  word[InputPtr]

;-480                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable103
 jmp .getVariable102
.getVariable103:

;-481                         InputPtr++;

 inc  word[InputPtr]

;-482                     }


;-483                 }

.getVariable101:

;-484             } while (isToken(','));

.getVariable100:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable104
 jmp .getVariable98
.getVariable104:

;-485         }


;-486         if (CodeType == 201) {//DW

.getVariable97:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable105

;-487             do {

.getVariable106:

;-488                 getTokeType();

 call getTokeType

;-489                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable107
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-490             } while (isToken(','));

.getVariable107:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable108
 jmp .getVariable106
.getVariable108:

;-491         }


;-492         if (CodeType == 202) {//DD

.getVariable105:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable109

;-493             do {

.getVariable110:

;-494                 getTokeType();

 call getTokeType

;-495                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable111
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-496                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-497             } while (isToken(','));

.getVariable111:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable112
 jmp .getVariable110
.getVariable112:

;-498         }


;-499         if (CodeType >= 203) {//resb, resw, resd

.getVariable109:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable113

;-500             getTokeType();

 call getTokeType

;-501             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable114

;-502                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable115
 call syntaxerror

;-503                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable115:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable116
 push getVariable_0
 call error1
 add  sp, 2

;-504                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable116:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-505                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable117
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-506                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable117:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable118
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-507                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable118:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-508             } else numbererror();

 jmp .getVariable119
.getVariable114:
 call numbererror

;-509         }

.getVariable119:

;-510     }

.getVariable113:

;-511     else dataexit();

 jmp .getVariable120
.getVariable94:
 call dataexit

;-512 }

.getVariable120:

;-513 


;-514 int getCodeSize() {
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC

;-515     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize121

;-516         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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

;-517         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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

;-518         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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

;-519     }

.getCodeSize124:

;-520     return 0;

.getCodeSize121:
 mov ax, 0
 jmp .retngetCodeSize

;-521 }


;-522 int isToken(char c) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

isToken: PROC

;-523     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   522 NULL c = bp+4;
 ENTER  0,0
 call skipBlank

;-524     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken125

;-525         InputPtr++;

 inc  word[InputPtr]

;-526         return 1;

 mov ax, 1
 jmp .retnisToken

;-527         }


;-528     return 0;

.isToken125:
 mov ax, 0
 jmp .retnisToken

;-529 }


;-530 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-531     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   530 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need126

;-532         getTokeType();

 call getTokeType

;-533         return;

 jmp .retnneed

;-534         }


;-535     error1();

.need126:
 call error1

;-536     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-537     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-538 }


;-539 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-540     getTokeType();

 call getTokeType

;-541     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest127
 push skipRest_0
 call error1
 add  sp, 2

;-542 }

.skipRest127:

;-543 


;-544 


;-545 //#include "HELPER.C"


;-546 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }

 ret
skipRest_0 db "extra char ignored",0
ENDP

writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16

;-547 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
ENDP

putch: PROC
;Function : putch, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   547 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .putch128
 mov  al, 13
 call writetty
.putch128:
 mov  al, [bp+4]
 call writetty

;-548 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
ENDP

cputs: PROC
;Function : cputs, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   548 NULL s = bp+4
;  201 var sign byte   548 NULL c = bp-2;
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

;-549 


;-550 int DosInt() {
 LEAVE
 ret
ENDP

DosInt: PROC

;-551     __emit__(0xCD,0x21);//inth 0x21;

 db 205,33

;-552     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4

;-553     DOS_ERR++;

 inc  word[DOS_ERR]

;-554 }


;-555 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC
;Function : openR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   555 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-556 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP

creatR: PROC
;Function : creatR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   556 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-557 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP

fcloseR: PROC
;Function : fcloseR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   557 NULL fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt

;-558 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP

exitR: PROC
;Function : exitR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   558 NULL c = bp+4;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt

;-559 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
 LEAVE
 ret
ENDP

readRL: PROC
;Function : readRL, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   559 NULL s = bp+4
;  201 var sign word   559 NULL fd = bp+6
;  202 var sign word   559 NULL len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-560 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP

fputcR: PROC
;Function : fputcR, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   560 NULL n = bp+4
;  201 var sign word   560 NULL fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]

;-561   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-562 


;-563 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
 LEAVE
 ret
ENDP

getLine: PROC

;-564   unsigned int i;


;-565   InputPtr= &InputBuf;

;Function : getLine, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   564 NULL i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-566   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-567   do {

.getLine131:

;-568     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-569     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine132
 push getLine_0
 call errorexit
 add  sp, 2

;-570     if (DOS_NoBytes == 0) return;

.getLine132:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine133
 jmp .retngetLine

;-571     *InputPtr = DOS_ByteRead;

.getLine133:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-572     InputPtr++;

 inc  word[InputPtr]

;-573     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-574     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine134
 push getLine_1
 call errorexit
 add  sp, 2

;-575   } while (ifEOL(DOS_ByteRead) == 0);

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

;-576   InputPtr--;

 dec  word[InputPtr]

;-577   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-578 }


;-579 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

ifEOL: PROC

;-580   if (c == 10) return 1;//LF

;Function : ifEOL, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   579 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL136
 mov ax, 1
 jmp .retnifEOL

;-581   if (c == 13) {//CR

.ifEOL136:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL137

;-582     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-583     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL138
 push ifEOL_0
 call errorexit
 add  sp, 2

;-584     return 1;

.ifEOL138:
 mov ax, 1
 jmp .retnifEOL

;-585   }


;-586   return 0;

.ifEOL137:
 mov ax, 0
 jmp .retnifEOL

;-587 }


;-588 int skipBlank() {

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

skipBlank: PROC

;-589   skipblank1:

.skipblank1:

;-590     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank139
 inc  word[InputPtr]
 jmp .skipblank1

;-591     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank139:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank140
 inc  word[InputPtr]
 jmp .skipblank1

;-592 }

.skipBlank140:

;-593 int letterE(char c) {

 ret
ENDP

letterE: PROC

;-594   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   593 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE141
 mov ax, 1
 jmp .retnletterE

;-595   if (c=='.') return 1;

.letterE141:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE142
 mov ax, 1
 jmp .retnletterE

;-596   if (c=='?') return 1;

.letterE142:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE143
 mov ax, 1
 jmp .retnletterE

;-597   if (c=='$') return 1;

.letterE143:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE144
 mov ax, 1
 jmp .retnletterE

;-598   if (c> 'z') return 0;

.letterE144:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE145
 mov ax, 0
 jmp .retnletterE

;-599   if (c< '@') return 0; // at included

.letterE145:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE146
 mov ax, 0
 jmp .retnletterE

;-600   if (c> 'Z') { if (c< 'a') return 0; }

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

;-601   return 1;

.letterE147:
 mov ax, 1
 jmp .retnletterE

;-602 }


;-603 int alnumE(char c) {

 .retnletterE: LEAVE
 ret
ENDP

alnumE: PROC

;-604   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   603 NULL c = bp+4;
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

;-605   if (letterE(c)) return 1;

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

;-606   return 0;

.alnumE150:
 mov ax, 0
 jmp .retnalnumE

;-607 }


;-608 int digit(char c){

 .retnalnumE: LEAVE
 ret
ENDP

digit: PROC

;-609     if(c<'0') return 0;

;Function : digit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   608 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit151
 mov ax, 0
 jmp .retndigit

;-610     if(c>'9') return 0;

.digit151:
 mov al, [bp+4]
 cmp al, 57
 jle .digit152
 mov ax, 0
 jmp .retndigit

;-611     return 1;

.digit152:
 mov ax, 1
 jmp .retndigit

;-612 }


;-613 int strlen(char *s) { int c;

 .retndigit: LEAVE
 ret
ENDP

strlen: PROC

;-614     c=0;

;Function : strlen, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   613 NULL s = bp+4
;  201 var sign word   613 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax

;-615     while (*s!=0) {s++; c++;}

.strlen153:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen154
 inc  word[bp+4]
 inc  word[bp-2]

;-616     return c;

 jmp .strlen153
.strlen154:
 mov ax, [bp-2]
 jmp .retnstrlen

;-617     }


;-618 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP

strcpy: PROC

;-619     do { *s=*t; s++; t++; }

;Function : strcpy, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   618 NULL s = bp+4
;  201 ptr sign byte   618 NULL t = bp+6;
 ENTER  0,0
.strcpy155:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]

;-620     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy156
 jmp .strcpy155
.strcpy156:

;-621     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al

;-622     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy

;-623     }


;-624 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP

eqstr: PROC

;-625     while(*p) {

;Function : eqstr, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   624 NULL p = bp+4
;  201 ptr sign byte   624 NULL q = bp+6;
 ENTER  0,0
.eqstr157:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr158

;-626         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr159
 mov ax, 0
 jmp .retneqstr

;-627             p++;

.eqstr159:
 inc  word[bp+4]

;-628             q++;

 inc  word[bp+6]

;-629             }


;-630     if(*q) return 0;

 jmp .eqstr157
.eqstr158:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr160
 mov ax, 0
 jmp .retneqstr

;-631     return 1;

.eqstr160:
 mov ax, 1
 jmp .retneqstr

;-632     }


;-633 int strcat1(char *s, char *t) {

 .retneqstr: LEAVE
 ret
ENDP

strcat1: PROC

;-634     while (*s != 0) s++;

;Function : strcat1, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   633 NULL s = bp+4
;  201 ptr sign byte   633 NULL t = bp+6;
 ENTER  0,0
.strcat1161:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat1162
 inc  word[bp+4]

;-635     strcpy(s, t);

 jmp .strcat1161
.strcat1162:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-636     }


;-637 int toupper(char *s) {
 LEAVE
 ret
ENDP

toupper: PROC

;-638     while(*s) {

;Function : toupper, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   637 NULL s = bp+4;
 ENTER  0,0
.toupper163:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper164

;-639         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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

;-640             s++;

.toupper166:
.toupper165:
 inc  word[bp+4]

;-641               }


;-642     }

 jmp .toupper163
.toupper164:

;-643 


;-644 int getDigit(unsigned char c) {//ret: SymbolInt
 LEAVE
 ret
ENDP

getDigit: PROC

;-645   unsigned int CastInt;


;-646   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   644 NULL c = bp+4
;  201 var unsg word   645 NULL CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-647   do {

.getDigit167:

;-648     c-='0';

 sub  byte[bp+4], 48

;-649     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-650     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-651     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-652     InputPtr++;

 inc  word[InputPtr]

;-653     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-654   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit168
 jmp .getDigit167
.getDigit168:

;-655 }


;-656 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-657   char *p; unsigned int i;


;-658   p = &Symbol;

;Function : getName, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   656 NULL c = bp+4
;  201 ptr sign byte   657 NULL p = bp-2
;  202 var unsg word   657 NULL i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-659   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-660   p++;

 inc  word[bp-2]

;-661   while (alnumE(c)) {

.getName169:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName170

;-662     InputPtr++;

 inc  word[InputPtr]

;-663     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-664     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-665     p++;

 inc  word[bp-2]

;-666     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-667     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName171
 push getName_0
 call errorexit
 add  sp, 2

;-668   }

.getName171:

;-669   if (c == ':') isLabel=1; else isLabel=0;

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

;-670   p--;

.getName173:
 dec  word[bp-2]

;-671   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-672   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-673   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-674 }


;-675 int testReg() {
 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP

testReg: PROC

;-676 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-677   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al

;-678   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg174
 mov ax, 0
 jmp .retntestReg

;-679   if (strlen(Symbol) > 3) return 0;

.testReg174:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg175
 mov ax, 0
 jmp .retntestReg

;-680   R2Type=BYTE;

.testReg175:
 mov ax, 1
 mov byte [R2Type], al

;-681   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg176
 mov ax, 0
 jmp .retntestReg

;-682   if (eqstr(SymbolUpper, "CL")) return 1;

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

;-683   if (eqstr(SymbolUpper, "DL")) return 2;

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

;-684   if (eqstr(SymbolUpper, "BL")) return 3;

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

;-685   if (eqstr(SymbolUpper, "AH")) return 4;

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

;-686   if (eqstr(SymbolUpper, "CH")) return 5;

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

;-687   if (eqstr(SymbolUpper, "DH")) return 6;

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

;-688   if (eqstr(SymbolUpper, "BH")) return 7;

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

;-689   R2Type=WORD;

.testReg183:
 mov ax, 2
 mov byte [R2Type], al

;-690   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg184
 mov ax, 0
 jmp .retntestReg

;-691   if (eqstr(SymbolUpper, "CX")) return 1;

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

;-692   if (eqstr(SymbolUpper, "DX")) return 2;

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

;-693   if (eqstr(SymbolUpper, "BX")) return 3;

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

;-694   if (eqstr(SymbolUpper, "SP")) return 4;

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

;-695   if (eqstr(SymbolUpper, "BP")) return 5;

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

;-696   if (eqstr(SymbolUpper, "SI")) return 6;

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

;-697   if (eqstr(SymbolUpper, "DI")) return 7;

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

;-698   R2Type=SEGREG;

.testReg191:
 mov ax, 4
 mov byte [R2Type], al

;-699   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg192
 mov ax, 0
 jmp .retntestReg

;-700   if (eqstr(SymbolUpper, "CS")) return 1;

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

;-701   if (eqstr(SymbolUpper, "SS")) return 2;

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

;-702   if (eqstr(SymbolUpper, "DS")) return 3;

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

;-703   if (eqstr(SymbolUpper, "FS")) return 4;

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

;-704   if (eqstr(SymbolUpper, "GS")) return 5;

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

;-705   R2Type=DWORD;

.testReg197:
 mov ax, 3
 mov byte [R2Type], al

;-706   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg198
 mov ax, 0
 jmp .retntestReg

;-707   if (eqstr(SymbolUpper, "ECX"))return 1;

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

;-708   if (eqstr(SymbolUpper, "EDX"))return 2;

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

;-709   if (eqstr(SymbolUpper, "EBX"))return 3;

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

;-710   if (eqstr(SymbolUpper, "ESP"))return 4;

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

;-711   if (eqstr(SymbolUpper, "EBP"))return 5;

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

;-712   if (eqstr(SymbolUpper, "ESI"))return 6;

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

;-713   if (eqstr(SymbolUpper, "EDI"))return 7;

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

;-714   R2Type=0; return 0;

.testReg205:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg

;-715 }


;-716 


;-717 


;-718 //#include "OUTPUT.C"


;-719 int printLine() {

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

;-720     int i; char c;


;-721     prs("\n");

;Function : printLine, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   720 NULL i = bp-2
;  201 var sign byte   720 NULL c = bp-4;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-722     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-723     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine206
 push printLine_1
 call prs
 add  sp, 2

;-724     else {

 jmp .printLine207
.printLine206:

;-725 //        prc(' ');


;-726         i=0;

 mov ax, 0
 mov [bp-2], ax

;-727         do {

.printLine208:

;-728             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al

;-729             prc(' ');

 push 32
 call prc
 add  sp, 2

;-730             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-731             i++;

 inc  word[bp-2]

;-732         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine209
 jmp .printLine208
.printLine209:

;-733         while (i < OPMAXLEN) {// fill rest with blank

.printLine210:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine211

;-734             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-735             i++;

 inc  word[bp-2]

;-736         }


;-737     }

 jmp .printLine210
.printLine211:

;-738     prc(PrintRA);

.printLine207:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-739     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-740 }


;-741 int prc(unsigned char c) {//print char
 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

prc: PROC

;-742         if ( _ c==10) {

;Function : prc, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   741 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .prc212

;-743             ax=13;

 mov  ax, 13

;-744             writetty();

 call writetty

;-745             }


;-746         al=c;

.prc212:
 mov  al, [bp+4]

;-747         writetty();

 call writetty

;-748     fputcR(c,lst_fd);

 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-749 }


;-750 


;-751 int prscomment(unsigned char *s) {
 LEAVE
 ret
ENDP

prscomment: PROC

;-752     unsigned char c;


;-753     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   751 NULL s = bp+4
;  201 var unsg byte   752 NULL c = bp-2;
 ENTER  2,0
.prscomment213:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment214

;-754         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-755         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-756         s++;

 inc  word[bp+4]

;-757     }


;-758 }

 jmp .prscomment213
.prscomment214:

;-759 int prs(unsigned char *s) {
 LEAVE
 ret
ENDP

prs: PROC

;-760     unsigned char c;


;-761     int com;


;-762     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   759 NULL s = bp+4
;  201 var unsg byte   760 NULL c = bp-2
;  202 var sign word   761 NULL com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax

;-763     while (*s) {

.prs215:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs216

;-764         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-765         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs217

;-766             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs218
 mov ax, 0
 mov [bp-4], ax

;-767                 else com=1;

 jmp .prs219
.prs218:
 mov ax, 1
 mov [bp-4], ax

;-768         }

.prs219:

;-769         if (c==92) {

.prs217:
 mov al, [bp-2]
 cmp al, 92
 jne .prs220

;-770             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs221

;-771                 s++;

 inc  word[bp+4]

;-772                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-773                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs222
 mov ax, 10
 mov [bp-2], al

;-774                 if (c=='t') c= 9;

.prs222:
 mov al, [bp-2]
 cmp al, 116
 jne .prs223
 mov ax, 9
 mov [bp-2], al

;-775             }

.prs223:

;-776         }

.prs221:

;-777         prc(c);

.prs220:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-778         s++;

 inc  word[bp+4]

;-779     }


;-780 }

 jmp .prs215
.prs216:

;-781 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP

printhex8a: PROC

;-782     unsigned char nib;


;-783     nib = c >> 4; printhex4(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   781 NULL c = bp+4
;  201 var unsg byte   782 NULL nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-784     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-785 }


;-786 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP

printhex4: PROC

;-787     c += 48;

;Function : printhex4, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   786 NULL c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48

;-788     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex4224
 add  byte[bp+4], 7

;-789     prc(c);

.printhex4224:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-790 }


;-791 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP

printhex16: PROC

;-792     unsigned int half;


;-793     half = i >>  8; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   791 NULL i = bp+4
;  201 var unsg word   792 NULL half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-794     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-795 }


;-796 int printIntU(unsigned int n) {
 LEAVE
 ret
ENDP

printIntU: PROC

;-797     unsigned int e;


;-798     if ( _ n >= 10) {

;Function : printIntU, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   796 NULL n = bp+4
;  201 var unsg word   797 NULL e = bp-2;
 ENTER  2,0 ; constant expression
cmp word[bp+4], 10 ;unsigned : 0
 jb  .printIntU225

;-799         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax

;-800         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-801     }


;-802     n = n % 10; //unsigned mod

.printIntU225:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax

;-803     n += '0';

 add  word[bp+4], 48

;-804     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-805 }


;-806 


;-807 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-808     ErrorCount++;

;Function : error1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   807 NULL s = bp+4;
 ENTER  0,0
 inc  word[ErrorCount]

;-809     prs("\n;***** next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-810     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-811     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-812     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-813 }


;-814 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-815     error1(s);

;Function : errorexit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   814 NULL s = bp+4;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-816     epilog();

 call epilog

;-817     end1(1);

 push 1
 call end1
 add  sp, 2

;-818 }


;-819 int notfounderror(){error1("label not found"); }
 LEAVE
 ret
ENDP

notfounderror: PROC
 push notfounderror_0
 call error1
 add  sp, 2

;-820 int allowederror() {error1("not allowed here"); }

 ret
notfounderror_0 db "label not found",0
ENDP

allowederror: PROC
 push allowederror_0
 call error1
 add  sp, 2

;-821 int addrerror()    {error1("address missing");}

 ret
allowederror_0 db "not allowed here",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-822 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-823 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-824 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-825 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-826 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-827 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-828 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-829 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-830 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-831 


;-832 int addrexit()     {errorexit("illegal address");}

 ret
syntaxerror_0 db "syntax",0
ENDP

addrexit: PROC
 push addrexit_0
 call errorexit
 add  sp, 2

;-833 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
addrexit_0 db "illegal address",0
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-834 int internexit()   {errorexit("intern compiler error");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

internexit: PROC
 push internexit_0
 call errorexit
 add  sp, 2

;-835 


;-836 


;-837 //#include "MAIN.C"


;-838 int main() {

 ret
internexit_0 db "intern compiler error",0
ENDP

main: PROC

;-839     getarg();

 call getarg

;-840     parse();

 call parse

;-841     fixJmp();

 call fixJmp

;-842     epilog();

 call epilog

;-843     end1();

 call end1

;-844 }


;-845 


;-846 int getarg() {

 ret
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
 jne .getarg226

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

.getarg226:
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
 je .getarg227
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

.getarg227:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-868     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg228
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

.getarg228:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-870     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je .getarg229
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

.getarg229:
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

;-881     //todo ENDP: search backwards until tmpJmpMaxIx


;-882     


;-883     int i;  unsigned int hex; unsigned int hex1; 


;-884     char *p; int Ix; char c;


;-885     i=1;

;Function : fixJmp, Number of local variables: 6
;   # type sign width addr used name   list of local variables
;  200 var sign word   883 NULL i = bp-2
;  201 var unsg word   883 NULL hex = bp-4
;  202 var unsg word   883 NULL hex1 = bp-6
;  203 ptr sign byte   884 NULL p = bp-8
;  204 var sign word   884 NULL Ix = bp-10
;  205 var sign byte   884 NULL c = bp-12;
 ENTER  12,0
 mov ax, 1
 mov [bp-2], ax

;-886     prs("\n;END open jmp: ");

 push fixJmp_0
 call prs
 add  sp, 2

;-887     printIntU(JmpMaxIx);

 push word [JmpMaxIx]
 call printIntU
 add  sp, 2

;-888     p = &JmpNames;

 mov ax, JmpNames
 mov [bp-8], ax

;-889     while (i <= JmpMaxIx) {

.fixJmp230:
 mov ax, [bp-2]
 cmp ax, [JmpMaxIx]
 jg  .fixJmp231

;-890         strcpy(Symbol, p);

 push word [bp-8]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-891         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-8]
 mov [bp-8], ax

;-892         p++;

 inc  word[bp-8]

;-893         hex = JmpAddr[i];//hex point to PC at low byte of addr 

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [JmpAddr + bx]
 mov [bp-4], ax

;-894         hex1 = hex + 1;

 mov ax, [bp-4]
 add ax, 1
 mov [bp-6], ax

;-895 prs(" Symbol: "); prs(Symbol); prc(' '); printhex16(hex);//debug

 push fixJmp_1
 call prs
 add  sp, 2
 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2
 push 32
 call prc
 add  sp, 2
 push word [bp-4]
 call printhex16
 add  sp, 2

;-896         


;-897         Ix=searchLabel();

 call searchLabel
 mov [bp-10], ax

;-898         if (Ix == 0) error1("Label not found");

 mov ax, [bp-10]
 cmp ax, 0
 jne .fixJmp232
 push fixJmp_2
 call error1
 add  sp, 2

;-899         disp = LabelAddr[Ix];   

.fixJmp232:
 mov bx, [bp-10]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-900         c = FileBin[hex1];//look for 'A' push Absolute 

 mov bx, [bp-6]
 mov al, [FileBin + bx]
 mov [bp-12], al

;-901 prs(", c: "); printhex8a(c);

 push fixJmp_3
 call prs
 add  sp, 2
 mov al, byte [bp-12]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-902         if (c == 'A') disp = hex;

 mov al, [bp-12]
 cmp al, 65
 jne .fixJmp233
 mov ax, [bp-4]
 mov word [disp], ax

;-903         else {

 jmp .fixJmp234
.fixJmp233:

;-904             disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp-4]
 mov word [disp], ax

;-905             disp = disp +2;//PC points to next instruction

 mov ax, [disp]
 add ax, 2
 mov word [disp], ax

;-906             disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-907         }


;-908 


;-909             FileBin[hex] = disp;//fix low byte

.fixJmp234:
 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-910             hex++;

 inc  word[bp-4]

;-911             disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-912             FileBin[hex] = disp; 

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-913 prs(", ");

 push fixJmp_4
 call prs
 add  sp, 2

;-914         i++;

 inc  word[bp-2]

;-915     }


;-916 }

 jmp .fixJmp230
.fixJmp231:

;-917 


;-918 int epilog() {
 LEAVE
 ret
fixJmp_0 db "\n;END open jmp: ",0
fixJmp_1 db " Symbol: ",0
fixJmp_2 db "Label not found",0
fixJmp_3 db ", c: ",0
fixJmp_4 db ", ",0
ENDP

epilog: PROC

;-919     unsigned int i; char c;     int j;


;-920     prs("\n Errors: ");

;Function : epilog, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word   919 NULL i = bp-2
;  201 var sign byte   919 NULL c = bp-4
;  202 var sign word   919 NULL j = bp-6;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-921     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-922     if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog235
 push epilog_1
 call prs
 add  sp, 2

;-923     prs(", Out: ");

.epilog235:
 push epilog_2
 call prs
 add  sp, 2

;-924     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-925     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-926     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-927     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-928     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-929     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-930     prs(" Labels: ");

 push epilog_6
 call prs
 add  sp, 2

;-931     printIntU(LabelMaxIx);

 push word [LabelMaxIx]
 call printIntU
 add  sp, 2

;-932 prs(", code:\n ");//debug

 push epilog_7
 call prs
 add  sp, 2

;-933 


;-934     i=0;

 mov ax, 0
 mov [bp-2], ax

;-935     do {

.epilog236:

;-936         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-937         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-938 printhex8a(c); prc(' ');//debug

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-939         i++;

 inc  word[bp-2]

;-940     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog237
 jmp .epilog236
.epilog237:

;-941 


;-942 /* */


;-943   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);

 push epilog_8
 call prs
 add  sp, 2
 push word [LabelNamePtr]
 call printIntU
 add  sp, 2

;-944   i= &LabelNames;

 mov ax, LabelNames
 mov [bp-2], ax

;-945   prs(" &LabelNames:"); printIntU(i);

 push epilog_9
 call prs
 add  sp, 2
 push word [bp-2]
 call printIntU
 add  sp, 2

;-946   i=LabelNamePtr-i;

 mov ax, [LabelNamePtr]
 sub ax, [bp-2]
 mov [bp-2], ax

;-947   prs("size: ");

 push epilog_10
 call prs
 add  sp, 2

;-948   printIntU(i);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-949   prs(". >>");

 push epilog_11
 call prs
 add  sp, 2

;-950   i= &LabelNames;

 mov ax, LabelNames
 mov [bp-2], ax

;-951   do { c=*i; if (c==0) c=' '; prc(c); i++;

.epilog238:
 mov bx, [bp-2]
 mov ax, [bx]
 mov [bp-4], al
 mov al, [bp-4]
 cmp al, 0
 jne .epilog239
 mov ax, 32
 mov [bp-4], al
.epilog239:
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2
 inc  word[bp-2]

;-952   } while (i < LabelNamePtr); prs("<< \n");

 mov ax, [bp-2]
 cmp ax, [LabelNamePtr]
 jge .epilog240
 jmp .epilog238
.epilog240:
 push epilog_12
 call prs
 add  sp, 2

;-953    i = 1;

 mov ax, 1
 mov [bp-2], ax

;-954     LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-955     do {

.epilog241:

;-956       prs(LabelNamePtr); prc(' ');

 push word [LabelNamePtr]
 call prs
 add  sp, 2
 push 32
 call prc
 add  sp, 2

;-957       j=LabelAddr[i]; printhex16(j); prs(", ");

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov [bp-6], ax
 push word [bp-6]
 call printhex16
 add  sp, 2
 push epilog_13
 call prs
 add  sp, 2

;-958       j=strlen(LabelNamePtr);//get end of actual name

 push word [LabelNamePtr]
 call strlen
 add  sp, 2
 mov [bp-6], ax

;-959       LabelNamePtr=LabelNamePtr+j;

 mov ax, [LabelNamePtr]
 add ax, [bp-6]
 mov word [LabelNamePtr], ax

;-960       LabelNamePtr++;

 inc  word[LabelNamePtr]

;-961       i++;

 inc  word[bp-2]

;-962     } while (i <= LabelMaxIx);

 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 ja  .epilog242
 jmp .epilog241
.epilog242:

;-963 /**/


;-964 }


;-965 


;-966 int end1(int n) {
 LEAVE
 ret
epilog_0 db "\n Errors: ",0
epilog_1 db " ***ERROR*** ",0
epilog_2 db ", Out: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
epilog_6 db " Labels: ",0
epilog_7 db ", code:\n ",0
epilog_8 db " LabelNamePtr:",0
epilog_9 db " &LabelNames:",0
epilog_10 db "size: ",0
epilog_11 db ". >>",0
epilog_12 db "<< \n",0
epilog_13 db ", ",0
ENDP

end1: PROC

;-967     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   966 NULL n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-968     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-969     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-970     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-971 }


;-972 


;-973 


;-974 //#include "GENCODE.C"


;-975 // generate code


;-976 int getCodes() {
 LEAVE
 ret
ENDP

getCodes: PROC

;-977     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-978     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-979     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-980 }


;-981 int gen66h() {genCode8(0x66);

 ret
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-982 }


;-983 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-984     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   983 NULL c = bp+4
;  201 var sign byte   983 NULL d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-985     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-986 }


;-987 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-988     c = c + wflag;

;Function : genCodeW, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   987 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-989     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-990 }


;-991 int genCode8(char c) {
 LEAVE
 ret
ENDP

genCode8: PROC

;-992 //set: BinLen++, OpPrintIndex++


;-993     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   991 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-994     BinLen++;

 inc  word[BinLen]

;-995     PC++;

 inc  word[PC]

;-996     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 20000 ;unsigned : 0
 jb  .genCode8243
 push genCode8_0
 call errorexit
 add  sp, 2

;-997     if (OpPrintIndex < OPMAXLEN) {

.genCode8243:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8244

;-998         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-999         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-1000     }


;-1001 }

.genCode8244:

;-1002 int genCode16(unsigned int i) {
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

genCode16: PROC

;-1003     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word  1002 NULL i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-1004     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-1005 }


;-1006 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-1007     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg dwrd  1006 NULL L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-1008     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-1009 }


;-1010 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-1011 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-1012 //mod-bits: mode76, reg/opcode543, r/m210


;-1013 //Op: 0, IMM, REG, ADR, MEM


;-1014     char len;


;-1015     len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1010 NULL xxx = bp+4
;  201 var sign byte  1014 NULL len = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-1016     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-1017     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA245

;-1018         xxx |= 0xC0;

 or  byte[bp+4], 192

;-1019         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA246
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1020             else {

 jmp .writeEA247
.writeEA246:

;-1021                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA248
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1022                 else            xxx = xxx + R2No;

 jmp .writeEA249
.writeEA248:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-1023             }

.writeEA249:

;-1024         }

.writeEA247:

;-1025     if (Op == MEM) {

.writeEA245:
 mov al, [Op]
 cmp al, 4
 jne .writeEA250

;-1026         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA251

;-1027             xxx |= 6;

 or  byte[bp+4], 6

;-1028             len = 2;

 mov ax, 2
 mov [bp-2], al

;-1029         }


;-1030         else {

 jmp .writeEA252
.writeEA251:

;-1031             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-1032             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA253

;-1033                 len=1;

 mov ax, 1
 mov [bp-2], al

;-1034                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA254
 or  byte[bp+4], 64

;-1035             }

.writeEA254:

;-1036 


;-1037             if (disp) {

.writeEA253:
 mov ax, [disp]
 or  al, al
 je .writeEA255

;-1038                 ax = disp;

 mov  ax, [disp]

;-1039                 if(ax > 127) len=2;

 cmp  ax, 127
 jle .writeEA256
 mov ax, 2
 mov [bp-2], al

;-1040                 else len=1;

 jmp .writeEA257
.writeEA256:
 mov ax, 1
 mov [bp-2], al

;-1041                 if (len == 1) xxx |= 0x40;

.writeEA257:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA258
 or  byte[bp+4], 64

;-1042                 else xxx |= 0x80;

 jmp .writeEA259
.writeEA258:
 or  byte[bp+4], 128

;-1043             }

.writeEA259:

;-1044         }

.writeEA255:

;-1045     }

.writeEA252:

;-1046 


;-1047     genCode8(xxx);// gen second byte

.writeEA250:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1048     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA260
 push word [disp]
 call genCode8
 add  sp, 2

;-1049     if (len == 2) genCode16(disp);

.writeEA260:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA261
 push word [disp]
 call genCode16
 add  sp, 2

;-1050 }

.writeEA261:

;-1051 


;-1052 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-1053     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long

 mov al, [wflag]
 or  al, al
 je .genImmediate262
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate263
 push word [imme]
 call genCode32
 add  sp, 2

;-1054         else genCode16(imme);

 jmp .genImmediate264
.genImmediate263:
 push word [imme]
 call genCode16
 add  sp, 2

;-1055     else       genCode8 (imme);

.genImmediate264:
 jmp .genImmediate265
.genImmediate262:
 push word [imme]
 call genCode8
 add  sp, 2

;-1056 }

.genImmediate265:

;-1057 


;-1058 //AS.C


;-1059 int process() {

 ret
ENDP

process: PROC

;-1060     char c;


;-1061     int i;


;-1062     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1060 NULL c = bp-2
;  201 var sign word  1061 NULL i = bp-4;
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

;-1063     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-1064     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-1065     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-1066     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-1067     getCodes();//set: Code1, Code2, Code3

 call getCodes

;-1068 


;-1069     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process266

;-1070         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1071         return;

 jmp .retnprocess

;-1072     }


;-1073 


;-1074     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process266:
 mov al, [CodeType]
 cmp al, 2
 jne .process267

;-1075         getOpL();

 call getOpL

;-1076         checkOpL();

 call checkOpL

;-1077         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  .process268

;-1078   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process269

;-1079                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je .process270
 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
 jmp .retnprocess

;-1080             }

.process270:

;-1081         }

.process269:

;-1082         if (Code2 == 5) {//imul extension?

.process268:
 mov al, [Code2]
 cmp al, 5
 jne .process271

;-1083             getTokeType();

 call getTokeType

;-1084             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process272
 call implerror

;-1085         }

.process272:

;-1086         genCodeW(Code1);

.process271:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1087         writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1088         return;

 jmp .retnprocess

;-1089     }


;-1090 


;-1091     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process267:
 mov al, [CodeType]
 cmp al, 3
 jne .process273

;-1092         check2Ops();    //setwflag not applicable

 call check2Ops

;-1093         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process274
 call reg16error

;-1094         if (Op2 != MEM) addrerror();//only m16

.process274:
 mov al, [Op2]
 cmp al, 4
 je  .process275
 call addrerror

;-1095 


;-1096         genCode8(Code1);//les,lds,lea

.process275:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1097         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 15
 jne .process276
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1098         Op=Op2;//set MEM for writeEA

.process276:
 mov al, [Op2]
 mov byte [Op], al

;-1099         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1100         return;

 jmp .retnprocess

;-1101     }


;-1102 


;-1103     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process273:
 mov al, [CodeType]
 cmp al, 4
 jne .process277

;-1104         check2Ops();

 call check2Ops

;-1105         if (Op2 == IMM) {//second operand is imm

 mov al, [Op2]
 cmp al, 1
 jne .process278

;-1106             setsflag();

 call setsflag

;-1107             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process279

;-1108                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process280

;-1109                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process281

;-1110                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1111                         c += 4;

 add  byte[bp-2], 4

;-1112                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1113                         genImmediate();

 call genImmediate

;-1114                         return;

 jmp .retnprocess

;-1115                     }


;-1116                 }

.process281:

;-1117             }

.process280:

;-1118             //r/m, imm: 80 sign-extended,TTT,imm


;-1119             c = sflag + 0x80;

.process279:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1120             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1121             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1122             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process282
 push word [imme]
 call genCode8
 add  sp, 2

;-1123             else genImmediate();

 jmp .process283
.process282:
 call genImmediate

;-1124             return;

.process283:
 jmp .retnprocess

;-1125         }


;-1126         c = Code1 << 3;//r/m, r/r

.process278:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1127         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process284

;-1128             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process285

;-1129                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1130                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1131                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1132                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1133                 return;

 jmp .retnprocess

;-1134             }


;-1135         }

.process285:

;-1136         if (Op2 == REG) {//mem,reg    reg,reg

.process284:
 mov al, [Op2]
 cmp al, 2
 jne .process286

;-1137             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1138             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1139             return;

 jmp .retnprocess

;-1140         }


;-1141         syntaxerror();

.process286:
 call syntaxerror

;-1142         return;

 jmp .retnprocess

;-1143     }


;-1144 


;-1145     if (CodeType == 5) {//mov (movsx, movzx=51)

.process277:
 mov al, [CodeType]
 cmp al, 5
 jne .process287

;-1146         check2Ops();

 call check2Ops

;-1147 /*    prs("\n Op:"); printhex8a(Op);


;-1148     prs(", Op2:"); printhex8a(Op2);


;-1149     prs(", R1No:"); printhex8a(R1No);


;-1150     prs(", R2No:"); printhex8a(R2No);   */


;-1151         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process288

;-1152             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process289
 mov ax, [disp]
 mov word [imme], ax

;-1153             else notfounderror();

 jmp .process290
.process289:
 call notfounderror

;-1154             Op2=IMM;//continue with IMM

.process290:
 mov ax, 1
 mov byte [Op2], al

;-1155         }


;-1156         if (Op2 == IMM) {// r,i

.process288:
 mov al, [Op2]
 cmp al, 1
 jne .process291

;-1157             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process292

;-1158                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1159                 c += 0xB0;

 add  byte[bp-2], 176

;-1160                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1161                 genImmediate();

 call genImmediate

;-1162                 return;

 jmp .retnprocess

;-1163             }


;-1164             if (Op == MEM) {// m,i

.process292:
 mov al, [Op]
 cmp al, 4
 jne .process293

;-1165                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1166                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1167                 genImmediate();

 call genImmediate

;-1168                 return;

 jmp .retnprocess

;-1169             }


;-1170             regmemerror();

.process293:
 call regmemerror

;-1171             return;

 jmp .retnprocess

;-1172         }


;-1173         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process291:
 mov al, [R1Type]
 cmp al, 4
 jne .process294
 call ChangeDirection

;-1174         if (R2Type == SEGREG) {//rm,sreg

.process294:
 mov al, [R2Type]
 cmp al, 4
 jne .process295

;-1175             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process296
 call reg16error

;-1176                 genCode2(0x8C, dflag);

.process296:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1177                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1178                 return;

 jmp .retnprocess

;-1179         }


;-1180         if (Op2 == MEM) {//acc, moffs16

.process295:
 mov al, [Op2]
 cmp al, 4
 jne .process297

;-1181             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process298

;-1182                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process299

;-1183                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process300

;-1184                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1185                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1186                         return;

 jmp .retnprocess

;-1187                     }


;-1188                 }

.process300:

;-1189             }

.process299:

;-1190         }

.process298:

;-1191         if (Op == MEM) {//moffs16, acc

.process297:
 mov al, [Op]
 cmp al, 4
 jne .process301

;-1192             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process302

;-1193                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process303

;-1194                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process304

;-1195                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1196                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1197                         return;

 jmp .retnprocess

;-1198                     }


;-1199                 }

.process304:

;-1200             }

.process303:

;-1201 


;-1202         }

.process302:

;-1203         if (Op2 == REG) {//rm, r

.process301:
 mov al, [Op2]
 cmp al, 2
 jne .process305

;-1204             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1205             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1206             return;

 jmp .retnprocess

;-1207         }


;-1208         if (Op2 == MEM) {//r, m

.process305:
 mov al, [Op2]
 cmp al, 4
 jne .process306

;-1209             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process307

;-1210                 ChangeDirection();

 call ChangeDirection

;-1211                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1212                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1213                 return;

 jmp .retnprocess

;-1214             }


;-1215         }

.process307:

;-1216         syntaxerror();

.process306:
 call syntaxerror

;-1217         return;

 jmp .retnprocess

;-1218     }


;-1219 


;-1220     if (CodeType == 6) {//Jcc

.process287:
 mov al, [CodeType]
 cmp al, 6
 jne .process308

;-1221         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process309

;-1222             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1223             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process310

;-1224                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1225                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1226                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1227                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process311

;-1228                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1229                     disp -= 2;

 sub  word[disp], 2

;-1230                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1231                 } else {

 jmp .process312
.process311:

;-1232                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1233                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1234                     disp -= 4;

 sub  word[disp], 4

;-1235                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1236                 }


;-1237             }

.process312:

;-1238             else {//jump forward, near only

 jmp .process313
.process310:

;-1239                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1240                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1241                 storeJmp();

 call storeJmp

;-1242                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1243                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1244             }


;-1245         return;

.process313:
 jmp .retnprocess

;-1246         }


;-1247     }

.process309:

;-1248 


;-1249     if (CodeType == 7) {//jmp, call

.process308:
 mov al, [CodeType]
 cmp al, 7
 jne .process314

;-1250         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process315

;-1251             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1252             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process316

;-1253                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1254                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1255                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1256                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process317

;-1257                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process318

;-1258                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1259                         disp -= 2;

 sub  word[disp], 2

;-1260                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1261                     }


;-1262                     else {

 jmp .process319
.process318:

;-1263                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1264                         disp -= 3;

 sub  word[disp], 3

;-1265                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1266                     }


;-1267                 }

.process319:

;-1268                 else {

 jmp .process320
.process317:

;-1269                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1270                     disp -= 3;

 sub  word[disp], 3

;-1271                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1272                 }


;-1273             }

.process320:

;-1274             else {//jump forward, near only

 jmp .process321
.process316:

;-1275                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1276                 storeJmp();

 call storeJmp

;-1277                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1278                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1279             }


;-1280         return;

.process321:
 jmp .retnprocess

;-1281         }


;-1282     }

.process315:

;-1283 


;-1284     if (CodeType ==  8) {//ret,retf

.process314:
 mov al, [CodeType]
 cmp al, 8
 jne .process322

;-1285         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process323

;-1286             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1287             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1288             return;

 jmp .retnprocess

;-1289         }


;-1290         genCode8(Code1);

.process323:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1291         return;

 jmp .retnprocess

;-1292     }


;-1293 


;-1294     if (CodeType == 9) {//push, pop

.process322:
 mov al, [CodeType]
 cmp al, 9
 jne .process324

;-1295         getOpL();

 call getOpL

;-1296         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process325

;-1297             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process326

;-1298                 setsflag();

 call setsflag

;-1299                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1300                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process327
 push word [imme]
 call genCode8
 add  sp, 2

;-1301                 else       genCode16(imme);

 jmp .process328
.process327:
 push word [imme]
 call genCode16
 add  sp, 2

;-1302                 return;

.process328:
 jmp .retnprocess

;-1303             }


;-1304             if (Op == ADR) {//push string ABSOLUTE i16 

.process326:
 mov al, [Op]
 cmp al, 3
 jne .process329

;-1305 prs(" push disp: "); printIntU (disp);

 push process_0
 call prs
 add  sp, 2
 push word [disp]
 call printIntU
 add  sp, 2

;-1306                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process330

;-1307                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1308                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1309                     return;

 jmp .retnprocess

;-1310                 }


;-1311                 else {

 jmp .process331
.process330:

;-1312                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1313                     storeJmp();

 call storeJmp

;-1314                     genCode8(65);//'A'

 push 65
 call genCode8
 add  sp, 2

;-1315                     genCode8(65);

 push 65
 call genCode8
 add  sp, 2

;-1316                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al

;-1317                 }


;-1318             }

.process331:

;-1319         }

.process329:

;-1320         if (R1Type == SEGREG) {

.process325:
 mov al, [R1Type]
 cmp al, 4
 jne .process332

;-1321             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process333

;-1322                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process334
 push process_1
 call error1
 add  sp, 2

;-1323             }

.process334:

;-1324             c = R1No <<3;

.process333:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1325             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process335

;-1326                 c += 122;

 add  byte[bp-2], 122

;-1327                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1328             }


;-1329             OpCodePtr++;

.process335:
 inc  word[OpCodePtr]

;-1330             c = c + *OpCodePtr;////////////////is Code4

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov [bp-2], al

;-1331             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1332             return;

 jmp .retnprocess

;-1333         }


;-1334         checkOpL();//no ADR, SEGREG

.process332:
 call checkOpL

;-1335         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne .process336
 call reg16error

;-1336         if (R1Type == WORD) {

.process336:
 mov al, [R1Type]
 cmp al, 2
 jne .process337

;-1337             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1338             return;

 jmp .retnprocess

;-1339         }


;-1340         if (Op == MEM) {

.process337:
 mov al, [Op]
 cmp al, 4
 jne .process338

;-1341             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1342             writeEA(Code3);//////////////////Code3

 mov al, byte [Code3]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1343             return;

 jmp .retnprocess

;-1344         }


;-1345         syntaxerror();

.process338:
 call syntaxerror

;-1346         return;

 jmp .retnprocess

;-1347     }


;-1348 


;-1349     if (CodeType == 11) {//shift, rotate

.process324:
 mov al, [CodeType]
 cmp al, 11
 jne .process339

;-1350         check2Ops();

 call check2Ops

;-1351         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process340

;-1352             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process341

;-1353                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1354                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1355                 return;

 jmp .retnprocess

;-1356             }


;-1357             genCodeW(0xC0);//80186

.process341:
 push 192
 call genCodeW
 add  sp, 2

;-1358             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1359             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1360             return;

 jmp .retnprocess

;-1361         }


;-1362         if (Op2 == REG) {

.process340:
 mov al, [Op2]
 cmp al, 2
 jne .process342

;-1363             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process343

;-1364                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process344

;-1365                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process345
 mov ax, 1
 mov byte [wflag], al

;-1366                     genCodeW(0xD2);

.process345:
 push 210
 call genCodeW
 add  sp, 2

;-1367                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1368                     return;

 jmp .retnprocess

;-1369                 }


;-1370             }

.process344:

;-1371         }

.process343:

;-1372     }

.process342:

;-1373 


;-1374     if (CodeType == 12) {//int

.process339:
 mov al, [CodeType]
 cmp al, 12
 jne .process346

;-1375         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process347

;-1376             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1377             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1378             return;

 jmp .retnprocess

;-1379         }


;-1380     }

.process347:

;-1381 


;-1382     if (CodeType == 30) {//enter i18,i8

.process346:
 mov al, [CodeType]
 cmp al, 30
 jne .process348

;-1383         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1384         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1385         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process349
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1386         else numbererror();

 jmp .process350
.process349:
 call numbererror

;-1387         need(',');

.process350:
 push 44
 call need
 add  sp, 2

;-1388         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1389         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process351
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1390         else numbererror();

 jmp .process352
.process351:
 call numbererror

;-1391         return;

.process352:
 jmp .retnprocess

;-1392     }


;-1393 


;-1394     if (CodeType==101) {//ORG nn

.process348:
 mov al, [CodeType]
 cmp al, 101
 jne .process353

;-1395         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process354
 call numbererror

;-1396         Origin=SymbolInt;

.process354:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1397         return;

 jmp .retnprocess

;-1398     }


;-1399 


;-1400     if (CodeType == 102) {//section, segment

.process353:
 mov al, [CodeType]
 cmp al, 102
 jne .process355

;-1401         //getTokeType();//ignore .bss .text .data


;-1402         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1403         return;

 jmp .retnprocess

;-1404     }


;-1405 


;-1406     if (CodeType == 110) {//absolute

.process355:
 mov al, [CodeType]
 cmp al, 110
 jne .process356

;-1407         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process357
 call numbererror

;-1408         AbsoluteLab=SymbolInt;

.process357:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1409         return;

 jmp .retnprocess

;-1410     }


;-1411     if (CodeType == 111) {//name: PROC

.process356:
 mov al, [CodeType]
 cmp al, 111
 jne .process358

;-1412         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process359

;-1413             prs("\n;entering: ");

 push process_2
 call prs
 add  sp, 2

;-1414             prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1415             isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1416             tmpLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [tmpLabelNamePtr], ax

;-1417             tmpLabelMaxIx   = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [tmpLabelMaxIx], ax

;-1418             tmpJmpNamePtr   = JmpNamePtr;

 mov ax, [JmpNamePtr]
 mov word [tmpJmpNamePtr], ax

;-1419             tmpJmpMaxIx     = JmpMaxIx;

 mov ax, [JmpMaxIx]
 mov word [tmpJmpMaxIx], ax

;-1420         } else error1("already in PROC");

 jmp .process360
.process359:
 push process_3
 call error1
 add  sp, 2

;-1421         return;

.process360:
 jmp .retnprocess

;-1422     }


;-1423     if (CodeType == 112) {//ENDP 

.process358:
 mov al, [CodeType]
 cmp al, 112
 jne .process361

;-1424         if (isInProc == 0) error1("not in PROC");

 mov al, [isInProc]
 cmp al, 0
 jne .process362
 push process_4
 call error1
 add  sp, 2

;-1425         prs("\n;leaving: ");

.process362:
 push process_5
 call prs
 add  sp, 2

;-1426         prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1427         isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1428         prs(". local labels :");

 push process_6
 call prs
 add  sp, 2

;-1429         i = LabelMaxIx - tmpLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [tmpLabelMaxIx]
 mov [bp-4], ax

;-1430         printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1431         prs(", local jmp :");

 push process_7
 call prs
 add  sp, 2

;-1432         i = JmpMaxIx - tmpJmpMaxIx;

 mov ax, [JmpMaxIx]
 sub ax, [tmpJmpMaxIx]
 mov [bp-4], ax

;-1433         


;-1434         fixJmp();

 call fixJmp

;-1435         LabelNamePtr = tmpLabelNamePtr;//delete local Labels

 mov ax, [tmpLabelNamePtr]
 mov word [LabelNamePtr], ax

;-1436         LabelMaxIx   = tmpLabelMaxIx;                       

 mov ax, [tmpLabelMaxIx]
 mov word [LabelMaxIx], ax

;-1437         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp

 mov ax, [tmpJmpNamePtr]
 mov word [JmpNamePtr], ax

;-1438         JmpMaxIx     = tmpJmpMaxIx;

 mov ax, [tmpJmpMaxIx]
 mov word [JmpMaxIx], ax

;-1439         return;

 jmp .retnprocess

;-1440     }


;-1441     error1("Command not implemented or syntax error");

.process361:
 push process_8
 call error1
 add  sp, 2

;-1442 }


;-1443 

 .retnprocess: LEAVE
 ret
process_0 db " push disp: ",0
process_1 db "pop cs not allowed",0
process_2 db "\n;entering: ",0
process_3 db "already in PROC",0
process_4 db "not in PROC",0
process_5 db "\n;leaving: ",0
process_6 db ". local labels :",0
process_7 db ", local jmp :",0
process_8 db "Command not implemented or syntax error",0
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
;   19 var sign word    20    4 ErrorCount
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
;   56 var sign word    58   55 disp
;   57 var unsg word    59   13 imme
;   58 def unsg byte    61    - OPMAXLEN=5
;   59 arr sign byte    62    2 OpPos[5]
;   60 var sign word    63    6 OpPrintIndex
;   61 ptr sign byte    64   19 OpCodePtr
;   62 var sign byte    65    5 PrintRA
;   63 def unsg byte    67    - LABELNAMESMAX=5969
;   64 arr sign byte    68    6 LabelNames[6000]
;   65 ptr sign byte    69   16 LabelNamePtr
;   66 ptr sign byte    70    2 tmpLabelNamePtr
;   67 def unsg byte    72    - LABELADRMAX=600
;   68 arr unsg word    73    8 LabelAddr[600]
;   69 var sign word    74   11 LabelMaxIx
;   70 var sign word    75    3 tmpLabelMaxIx
;   71 var sign word    76   10 LabelIx
;   72 def unsg byte    78    - JMPNAMESMAX=3969
;   73 arr sign byte    79    3 JmpNames[4000]
;   74 ptr sign byte    80    7 JmpNamePtr
;   75 ptr sign byte    81    2 tmpJmpNamePtr
;   76 def unsg byte    83    - JMPMAX=200
;   77 arr unsg word    84    2 JmpAddr[200]
;   78 var sign word    85    9 JmpMaxIx
;   79 var sign word    86    3 tmpJmpMaxIx
;   80 def unsg byte    88    - FILEBINMAX=20000
;   81 arr sign byte    89    5 FileBin[20000]
;   82 var unsg word    90    6 BinLen
;   83 ptr sign byte    92    1 arglen
;   84 ptr sign byte    93    4 argv
;   85 var sign byte    97    1 I_START
;   86 arr sign byte   100 NULL I_PUSHA[8125]
;   87 arr sign byte   101 NULL I_NOP[24260]
;   88 arr sign byte   102 NULL I_CWDE[9734]
;   89 arr sign byte   103 NULL I_CDQ[1931]
;   90 arr sign byte   104 NULL I_PUSHF[35622]
;   91 arr sign byte   105 NULL I_SAHF[599]
;   92 arr sign byte   106 NULL I_MOVSB[53495]
;   93 arr sign byte   107 NULL I_CMPSB[54007]
;   94 arr sign byte   108 NULL I_STOSB[37]
;   95 arr sign byte   109 NULL I_LODSB[33600]
;   96 arr sign byte   110 NULL I_SCASB[8418]
;   97 arr sign byte   111 NULL I_LEAVE[53259]
;   98 arr sign byte   112 NULL I_INTO[12917]
;   99 arr sign byte   113 NULL I_XLAT[35622]
;  100 arr sign byte   114 NULL I_REPNE[2119]
;  101 arr sign byte   115 NULL I_REPE[18057]
;  102 arr sign byte   116 NULL I_HLT[9982]
;  103 arr sign byte   117 NULL I_STC[18315]
;  104 arr sign byte   118 NULL I_STI[9734]
;  105 arr sign byte   119 NULL I_STD[32643]
;  106 arr sign byte   121 NULL I_INC[10]
;  107 arr sign byte   122 NULL I_DEC[1397]
;  108 arr sign byte   123 NULL I_NOT[18119]
;  109 arr sign byte   124 NULL I_NEG[65534]
;  110 arr sign byte   125 NULL I_MUL[33791]
;  111 arr sign byte   126 NULL I_IMUL[65150]
;  112 arr sign byte   127 NULL I_DIV[30207]
;  113 arr sign byte   128 NULL I_IDIV[15642]
;  114 arr sign byte   130 NULL I_LES[65535]
;  115 arr sign byte   131 NULL I_LDS[5493]
;  116 arr sign byte   132 NULL I_LEA[33574]
;  117 arr sign byte   133 NULL I_LSS[1151]
;  118 arr sign byte   134 NULL I_LFS[29696]
;  119 arr sign byte   135 NULL I_LGS[35593]
;  120 arr sign byte   137 NULL I_ADD[2630]
;  121 arr sign byte   138 NULL I_OR[14630]
;  122 arr sign byte   139 NULL I_ADC[1095]
;  123 arr sign byte   140 NULL I_SBB[26997]
;  124 arr sign byte   141 NULL I_AND[49203]
;  125 arr sign byte   142 NULL I_SUB[52169]
;  126 arr sign byte   143 NULL I_XOR[33680]
;  127 arr sign byte   144 NULL I_CMP[65150]
;  128 arr sign byte   145 NULL I_TEST[29729]
;  129 arr sign byte   147 NULL I_MOV[33618]
;  130 arr sign byte   148 NULL I_MOVSX[65150]
;  131 arr sign byte   149 NULL I_MOVZX[29731]
;  132 arr sign byte   151 NULL I_JO[33612]
;  133 arr sign byte   152 NULL I_JNO[65150]
;  134 arr sign byte   153 NULL I_JB[29732]
;  135 arr sign byte   154 NULL I_JNB[33606]
;  136 arr sign byte   155 NULL I_JAE[65150]
;  137 arr sign byte   156 NULL I_JE[29734]
;  138 arr sign byte   157 NULL I_JNE[33600]
;  139 arr sign byte   158 NULL I_JBE[65150]
;  140 arr sign byte   159 NULL I_JA[29730]
;  141 arr sign byte   160 NULL I_JS[33594]
;  142 arr sign byte   161 NULL I_JNS[65150]
;  143 arr sign byte   162 NULL I_JP[29737]
;  144 arr sign byte   163 NULL I_JNP[33588]
;  145 arr sign byte   164 NULL I_JL[65150]
;  146 arr sign byte   165 NULL I_JNL[29736]
;  147 arr sign byte   166 NULL I_JLE[33582]
;  148 arr sign byte   167 NULL I_JG[65150]
;  149 arr sign byte   169 NULL I_JMP[29733]
;  150 arr sign byte   170 NULL I_CALL[15656]
;  151 arr sign byte   172 NULL I_RET[33]
;  152 arr sign byte   173 NULL I_RETF[9076]
;  153 arr sign byte   175 NULL I_PUSH[9021]
;  154 arr sign byte   176 NULL I_POP[29696]
;  155 arr sign byte   178 NULL I_ROL[15646]
;  156 arr sign byte   179 NULL I_RCL[36]
;  157 arr sign byte   180 NULL I_SHL[6516]
;  158 arr sign byte   181 NULL I_SHR[9789]
;  159 arr sign byte   183 NULL I_INT[29696]
;  160 arr sign byte   185 NULL I_IN[15636]
;  161 arr sign byte   186 NULL I_INSB[34]
;  162 arr sign byte   187 NULL I_INSW[3956]
;  163 arr sign byte   188 NULL I_INSD[10557]
;  164 arr sign byte   189 NULL I_OUT[29696]
;  165 arr sign byte   190 NULL I_OUTSB[15626]
;  166 arr sign byte   191 NULL I_OUTSW[40]
;  167 arr sign byte   192 NULL I_OUTSD[1396]
;  168 arr sign byte   194 NULL I_XCHG[9533]
;  169 arr sign byte   196 NULL I_LOOPNZ[29952]
;  170 arr sign byte   197 NULL I_LOOPNE[33542]
;  171 arr sign byte   198 NULL I_LOOPZ[2686]
;  172 arr sign byte   199 NULL I_LOOPE[60176]
;  173 arr sign byte   200 NULL I_LOOP[33540]
;  174 arr sign byte   201 NULL I_JCXZ[2686]
;  175 arr sign byte   202 NULL I_JECXZ[29984]
;  176 arr sign byte   204 NULL I_ENTER[47255]
;  177 arr sign byte   206 NULL I_ORG[1]
;  178 arr sign byte   208 NULL I_SECTION[52169]
;  179 arr sign byte   209 NULL I_SEGMENT[21904]
;  180 arr sign byte   210 NULL I_ABSOLUTE[60555]
;  181 arr sign byte   211 NULL I_PROC[5816]
;  182 arr sign byte   212 NULL I_ENDP[39424]
;  183 arr sign byte   213 NULL I_DB[674]
;  184 arr sign byte   214 NULL I_DW[8125]
;  185 arr sign byte   215 NULL I_DD[51030]
;  186 arr sign byte   216 NULL I_RESB[65094]
;  187 arr sign byte   217 NULL I_RESW[0]
;  188 arr sign byte   218 NULL I_RESD[1678]
;  189 var sign byte   219 NULL I_END


;   # Calls Line Width  Name   list of functions

;    0    2  221   lookCode
;    1    2  238   ChangeDirection
;    2    2  246   checkOpL
;    3    4  255   check2Ops
;    4    1  264   get2Ops
;    5    3  270   getOpL
;    6    2  278   getOpR
;    7    4  288   getOp1
;    8    1  305   getMEM
;    9    1  331   getIndReg1
;   10    1  339   getIndReg2
;   11    2  349   setwflag
;   12    2  360   setsflag
;   13    2  370   checkConstSize
;   14    1  378   parse
;   15   16  414   getTokeType
;   16    3  425   storeJmp
;   17    2  436   storeLabel
;   18    5  448   searchLabel
;   19    1  461   getVariable
;   20    1  514   getCodeSize
;   21    9  522   isToken
;   22    2  530   need
;   23    1  539   skipRest
;   24    4  546   writetty
;   25    1  547   putch
;   26    8  548   cputs
;   27    6  550   DosInt
;   28    1  555   openR
;   29    2  556   creatR
;   30    3  557   fcloseR
;   31    5  558   exitR
;   32    2  559   readRL
;   33    2  560   fputcR
;   34    1  563   getLine
;   35    1  579   ifEOL
;   36    3  588   skipBlank
;   37    2  593   letterE
;   38    1  603   alnumE
;   39    3  608   digit
;   40    5  613   strlen
;   41    9  618   strcpy
;   42   35  624   eqstr
;   43    3  633   strcat1
;   44    2  637   toupper
;   45    1  644   getDigit
;   46    1  656   getName
;   47    1  675   testReg
;   48    1  719   printLine
;   49   11  741   prc
;   50    1  751   prscomment
;   51   46  759   prs
;   52    5  781   printhex8a
;   53    2  786   printhex4
;   54    3  791   printhex16
;   55   10  796   printIntU
;   56   28  807   error1
;   57   13  814   errorexit
;   58    2  819   notfounderror
;   59 NULL  820   allowederror
;   60    3  821   addrerror
;   61    1  822   immeerror
;   62    2  823   implerror
;   63    4  824   indexerror
;   64    3  825   invaloperror
;   65    6  826   numbererror
;   66    1  827   regmemerror
;   67    3  828   reg16error
;   68    1  829   segregerror
;   69    5  830   syntaxerror
;   70 NULL  832   addrexit
;   71    3  833   dataexit
;   72 NULL  834   internexit
;   73 NULL  838   main
;   74    1  846   getarg
;   75    2  880   fixJmp
;   76    2  918   epilog
;   77    2  966   end1
;   78    1  976   getCodes
;   79    1  981   gen66h
;   80    8  983   genCode2
;   81   13  987   genCodeW
;   82   37  991   genCode8
;   83   18 1002   genCode16
;   84    1 1006   genCode32
;   85   13 1010   writeEA
;   86    4 1052   genImmediate
;   87    1 1059   process
;   88 NULL 1443   LastFunctionByt

;    #  addr name   list of CALLs

;    0     0 eqstr
;    1     6 implerror
;    2    16 segregerror
;    3    28 setwflag
;    4    37 error1
;    5    44 error1
;    6    51 get2Ops
;    7    59 addrerror
;    8    69 invaloperror
;    9    82 immeerror
;   10    92 addrerror
;   11   102 invaloperror
;   12   115 setwflag
;   13   124 getOpL
;   14   131 need
;   15   136 getOpR
;   16   143 getOpR
;   17   150 getOp1
;   18   157 isToken
;   19   165 getMEM
;   20   172 invaloperror
;   21   185 error1
;   22   192 testReg
;   23   200 searchLabel
;   24   212 getTokeType
;   25   224 getOp1
;   26   231 syntaxerror
;   27   243 getIndReg2
;   28   254 getIndReg1
;   29   265 notfounderror
;   30   279 isToken
;   31   287 getTokeType
;   32   299 numbererror
;   33   311 isToken
;   34   319 isToken
;   35   327 errorexit
;   36   337 indexerror
;   37   348 indexerror
;   38   359 indexerror
;   39   370 indexerror
;   40   381 gen66h
;   41   388 error1
;   42   395 getLine
;   43   403 getTokeType
;   44   415 strcpy
;   45   422 storeLabel
;   46   433 getTokeType
;   47   445 lookCode
;   48   454 process
;   49   462 getVariable
;   50   474 skipRest
;   51   483 error1
;   52   490 error1
;   53   497 printLine
;   54   507 skipBlank
;   55   517 digit
;   56   523 getDigit
;   57   532 letterE
;   58   540 getName
;   59   548 errorexit
;   60   558 strcpy
;   61   565 errorexit
;   62   575 searchLabel
;   63   587 error1
;   64   594 errorexit
;   65   604 strcpy
;   66   611 errorexit
;   67   621 eqstr
;   68   627 strlen
;   69   634 storeLabel
;   70   645 getTokeType
;   71   657 lookCode
;   72   666 dataexit
;   73   675 dataexit
;   74   684 getTokeType
;   75   696 genCode8
;   76   705 skipBlank
;   77   715 isToken
;   78   723 genCode8
;   79   732 isToken
;   80   740 getTokeType
;   81   752 genCode16
;   82   762 isToken
;   83   770 getTokeType
;   84   782 genCode16
;   85   792 genCode16
;   86   802 isToken
;   87   810 getTokeType
;   88   822 syntaxerror
;   89   834 error1
;   90   841 numbererror
;   91   853 dataexit
;   92   862 eqstr
;   93   868 getTokeType
;   94   880 eqstr
;   95   886 getTokeType
;   96   898 eqstr
;   97   904 getTokeType
;   98   916 skipBlank
;   99   926 isToken
;  100   934 getTokeType
;  101   946 error1
;  102   953 prs
;  103   957 prc
;  104   961 getTokeType
;  105   973 error1
;  106   980 writetty
;  107   989 writetty
;  108   998 putch
;  109  1004 DosInt
;  110  1011 DosInt
;  111  1018 DosInt
;  112  1025 DosInt
;  113  1032 DosInt
;  114  1039 DosInt
;  115  1046 readRL
;  116  1053 errorexit
;  117  1063 errorexit
;  118  1073 ifEOL
;  119  1079 readRL
;  120  1086 errorexit
;  121  1096 digit
;  122  1102 letterE
;  123  1110 strcpy
;  124  1117 digit
;  125  1123 alnumE
;  126  1130 errorexit
;  127  1140 strcpy
;  128  1147 toupper
;  129  1155 strlen
;  130  1162 strlen
;  131  1169 eqstr
;  132  1175 eqstr
;  133  1181 eqstr
;  134  1187 eqstr
;  135  1193 eqstr
;  136  1199 eqstr
;  137  1205 eqstr
;  138  1211 eqstr
;  139  1217 eqstr
;  140  1223 eqstr
;  141  1229 eqstr
;  142  1235 eqstr
;  143  1241 eqstr
;  144  1247 eqstr
;  145  1253 eqstr
;  146  1259 eqstr
;  147  1265 eqstr
;  148  1271 eqstr
;  149  1277 eqstr
;  150  1283 eqstr
;  151  1289 eqstr
;  152  1295 eqstr
;  153  1301 eqstr
;  154  1307 eqstr
;  155  1313 eqstr
;  156  1319 eqstr
;  157  1325 eqstr
;  158  1331 eqstr
;  159  1337 eqstr
;  160  1343 eqstr
;  161  1349 prs
;  162  1353 printhex16
;  163  1364 prs
;  164  1368 prc
;  165  1372 printhex8a
;  166  1383 prs
;  167  1387 prc
;  168  1391 prscomment
;  169  1402 writetty
;  170  1411 writetty
;  171  1420 fputcR
;  172  1427 prc
;  173  1431 prc
;  174  1435 printhex4
;  175  1445 printhex4
;  176  1455 prc
;  177  1459 printhex8a
;  178  1470 printhex8a
;  179  1481 printIntU
;  180  1491 prc
;  181  1495 prs
;  182  1499 prs
;  183  1503 prs
;  184  1507 prs
;  185  1511 error1
;  186  1518 epilog
;  187  1525 end1
;  188  1530 error1
;  189  1537 error1
;  190  1544 error1
;  191  1551 error1
;  192  1558 error1
;  193  1565 error1
;  194  1572 error1
;  195  1579 error1
;  196  1586 error1
;  197  1593 error1
;  198  1600 error1
;  199  1607 error1
;  200  1614 errorexit
;  201  1624 errorexit
;  202  1634 errorexit
;  203  1644 getarg
;  204  1651 parse
;  205  1657 fixJmp
;  206  1664 epilog
;  207  1671 end1
;  208  1676 cputs
;  209  1682 cputs
;  210  1688 exitR
;  211  1694 toupper
;  212  1702 strcpy
;  213  1709 strcat1
;  214  1717 strcpy
;  215  1724 strcat1
;  216  1732 strcpy
;  217  1739 strcat1
;  218  1747 openR
;  219  1753 cputs
;  220  1759 cputs
;  221  1765 exitR
;  222  1771 creatR
;  223  1778 cputs
;  224  1784 cputs
;  225  1790 exitR
;  226  1796 creatR
;  227  1803 cputs
;  228  1809 cputs
;  229  1815 exitR
;  230  1821 prs
;  231  1825 prs
;  232  1829 prs
;  233  1833 prs
;  234  1837 prs
;  235  1841 prs
;  236  1845 prs
;  237  1849 prs
;  238  1853 prs
;  239  1857 prs
;  240  1861 printIntU
;  241  1871 strcpy
;  242  1878 strlen
;  243  1885 prs
;  244  1889 prs
;  245  1893 prc
;  246  1897 printhex16
;  247  1908 searchLabel
;  248  1920 error1
;  249  1927 prs
;  250  1931 printhex8a
;  251  1942 prs
;  252  1946 prs
;  253  1950 printIntU
;  254  1960 prs
;  255  1964 prs
;  256  1968 prs
;  257  1972 prs
;  258  1976 prs
;  259  1980 prs
;  260  1984 printIntU
;  261  1994 prs
;  262  1998 prs
;  263  2002 printIntU
;  264  2012 prs
;  265  2016 fputcR
;  266  2023 printhex8a
;  267  2034 prc
;  268  2038 prs
;  269  2042 printIntU
;  270  2052 prs
;  271  2056 printIntU
;  272  2066 prs
;  273  2070 printIntU
;  274  2080 prs
;  275  2084 prc
;  276  2088 prs
;  277  2092 prs
;  278  2096 prc
;  279  2100 printhex16
;  280  2111 prs
;  281  2115 strlen
;  282  2122 fcloseR
;  283  2130 fcloseR
;  284  2138 fcloseR
;  285  2146 exitR
;  286  2152 genCode8
;  287  2161 genCode8
;  288  2170 genCode8
;  289  2179 errorexit
;  290  2189 genCode8
;  291  2198 genCode8
;  292  2207 genCode16
;  293  2217 genCode16
;  294  2227 genCode8
;  295  2236 genCode8
;  296  2245 genCode16
;  297  2255 genCode32
;  298  2265 genCode16
;  299  2275 genCode8
;  300  2284 getTokeType
;  301  2296 getCodeSize
;  302  2308 getCodes
;  303  2317 genCode8
;  304  2326 getOpL
;  305  2333 checkOpL
;  306  2342 genCode2
;  307  2351 getTokeType
;  308  2363 implerror
;  309  2373 genCodeW
;  310  2382 writeEA
;  311  2390 check2Ops
;  312  2400 reg16error
;  313  2411 addrerror
;  314  2421 genCode8
;  315  2430 genCode8
;  316  2439 writeEA
;  317  2447 check2Ops
;  318  2457 setsflag
;  319  2466 genCodeW
;  320  2475 genImmediate
;  321  2488 genCodeW
;  322  2497 writeEA
;  323  2505 genCode8
;  324  2514 genImmediate
;  325  2527 genCodeW
;  326  2536 writeEA
;  327  2544 genCodeW
;  328  2553 writeEA
;  329  2561 syntaxerror
;  330  2573 check2Ops
;  331  2583 notfounderror
;  332  2597 genCode2
;  333  2606 genImmediate
;  334  2619 genCodeW
;  335  2628 writeEA
;  336  2636 genImmediate
;  337  2649 regmemerror
;  338  2661 ChangeDirection
;  339  2677 reg16error
;  340  2688 genCode2
;  341  2697 writeEA
;  342  2705 genCodeW
;  343  2714 genCode16
;  344  2724 genCodeW
;  345  2733 genCode16
;  346  2743 genCodeW
;  347  2752 writeEA
;  348  2760 ChangeDirection
;  349  2776 genCodeW
;  350  2785 writeEA
;  351  2793 syntaxerror
;  352  2805 searchLabel
;  353  2817 checkConstSize
;  354  2832 genCode2
;  355  2841 genCode8
;  356  2850 genCode8
;  357  2859 genCode2
;  358  2868 genCode16
;  359  2878 genCode8
;  360  2887 genCode2
;  361  2896 storeJmp
;  362  2905 genCode16
;  363  2915 searchLabel
;  364  2927 checkConstSize
;  365  2942 genCode8
;  366  2951 genCode8
;  367  2960 genCode8
;  368  2969 genCode16
;  369  2979 genCode8
;  370  2988 genCode16
;  371  2998 genCode8
;  372  3007 storeJmp
;  373  3016 genCode16
;  374  3026 genCode8
;  375  3035 genCode16
;  376  3045 genCode8
;  377  3054 getOpL
;  378  3061 setsflag
;  379  3070 genCode2
;  380  3079 genCode8
;  381  3088 genCode16
;  382  3098 prs
;  383  3102 printIntU
;  384  3112 genCode8
;  385  3121 genCode16
;  386  3131 genCode8
;  387  3140 storeJmp
;  388  3149 genCode8
;  389  3158 genCode8
;  390  3167 error1
;  391  3174 genCode8
;  392  3183 genCode8
;  393  3192 checkOpL
;  394  3201 reg16error
;  395  3212 genCode2
;  396  3221 genCode8
;  397  3230 writeEA
;  398  3238 syntaxerror
;  399  3250 check2Ops
;  400  3260 genCodeW
;  401  3269 writeEA
;  402  3277 genCodeW
;  403  3286 writeEA
;  404  3294 genCode8
;  405  3303 genCodeW
;  406  3312 writeEA
;  407  3320 genCode8
;  408  3329 genCode8
;  409  3338 genCode8
;  410  3347 getOp1
;  411  3354 genCode16
;  412  3364 numbererror
;  413  3376 need
;  414  3381 getOp1
;  415  3388 genCode8
;  416  3397 numbererror
;  417  3409 numbererror
;  418  3421 numbererror
;  419  3433 prs
;  420  3437 prs
;  421  3441 error1
;  422  3448 error1
;  423  3455 prs
;  424  3459 prs
;  425  3463 prs
;  426  3467 printIntU
;  427  3477 prs
;  428  3481 fixJmp
;  429  3488 error1
;Input: AS.C, List: AS.S,  Lines: 1444
;Glob. variables:  189 max.:  200
;Functions      :   89 max.:  300
;Calls          :  430 max.: 2000, NameField: 3495 max.:    65535
;Code until     :21667 max.: 30000, free: 8333
;Data (HeapEnd) :62154, resting stacksize:  3381 *** Warning *** Stack too small
;Max. Const in 'testReg' :  658 max. 3000, free: 2342