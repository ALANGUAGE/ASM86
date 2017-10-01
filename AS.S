
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


;-67 #define LABELNAMESMAX 3969//next number - SYMBOLMAX


;-68 char LabelNames[4000];  //space for names of all labels

section .bss
absolute 30554
LabelNames resb 4000
section .text

;-69 char *LabelNamePtr;     //first free position

LabelNamePtr dw 0

;-70 unsigned int locLabelNamePtr;//set after PROC to LabelNamePtr

locLabelNamePtr dw 0

;-71 #define LABELADRMAX 600


;-72 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 34554
LabelAddr resw 600
section .text

;-73 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0

;-74 int localLabelMaxIx;    //set after PROC to LabelMaxIx

localLabelMaxIx dw 0

;-75 int LabelIx;            //actual # of just searched label

LabelIx dw 0

;-76 int locStrAdrIx=0;      //push string not known

locStrAdrIx dw 0

;-77 unsigned int locStrAdr[100];//list of push of strings not known

section .bss
absolute 35754
locStrAdr resw 100
section .text

;-78 


;-79 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX


;-80 char JmpCallNames[2000];//space for names of jmp, call

section .bss
absolute 35954
JmpCallNames resb 2000
section .text

;-81 char *JmpCallNamePtr;   //first free position

JmpCallNamePtr dw 0

;-82 #define JMPCALLMAX 500  //max. jmp and call


;-83 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed

section .bss
absolute 37954
JmpCallAddr resw 500
section .text

;-84 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1

JmpCallMaxIx dw 0

;-85 


;-86 #define FILEBINMAX 20000


;-87 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 38954
FileBin resb 20000
section .text

;-88 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-89 


;-90 char *arglen=0x80;      // for main only

arglen dw 128

;-91 char *argv=0x82;        // for main only

argv dw 130

;-92 


;-93 


;-94 //#include "OPTABL.C"


;-95 char I_START=0xF1;

I_START db 241

;-96 //OpName, 0, CodeType, OpCode1-n, F1h


;-97 //  1:   1 byte opcode


;-98 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-99 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-100 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-101 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-102 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-103 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-104 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-105 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-106 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-107 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-108 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-109 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-110 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-111 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-112 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-113 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-114 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-115 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-116 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-117 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-118 // 2: mem reg 16 bit


;-119 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-120 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-121 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-122 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-123 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-124 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-125 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-126 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-127 //  3: les, lda, lea, lss, lfs, lgs


;-128 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-129 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-130 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-131 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-132 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-133 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-134 //  4: acc,imm  reg,imm  index,reg


;-135 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-136 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-137 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-138 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-139 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-140 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-141 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-142 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-143 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-144 //  5: mov


;-145 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-146 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-147 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-148 //  6: single byte relative jump


;-149 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-150 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-151 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-152 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-153 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-154 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-155 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-156 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-157 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-158 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-159 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-160 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-161 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-162 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-163 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-164 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-165 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-166 //  7: jmp, call


;-167 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-168 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-169 //  8: ret


;-170 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-171 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-172 //  9: seg, r/m


;-173 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,255,6,6,241

;-174 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16

I_POP db 80,79,80,0,9,88,143,0,7,241

;-175 //  11: shift, rotates


;-176 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-177 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-178 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-179 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-180 //  12: int


;-181 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-182 //  14: in/out


;-183 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-184 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-185 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-186 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-187 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-188 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-189 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-190 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-191 //  15: xchg


;-192 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-193 //  16: loop, jcxz


;-194 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-195 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-196 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-197 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-198 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-199 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-200 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-201 //  30: enter


;-202 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-203 // 100: directives


;-204 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-205 // section, segment .TEXT .DATA .BSS


;-206 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-207 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-208 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-209 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-210 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-211 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-212 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-213 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-214 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-215 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-216 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-217 char I_END=0;// end of table char

I_END db 0

;-218 


;-219 int lookCode() {//ret: CodeType, *OpCodePtr


lookCode: PROC

;-220     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-221     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-222     OpCodePtr++;

 inc  word[OpCodePtr]

;-223     do  {

.lookCode1:

;-224         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode2

;-225             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode3:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode4
 inc  word[OpCodePtr]

;-226             OpCodePtr++;

 jmp .lookCode3
.lookCode4:
 inc  word[OpCodePtr]

;-227             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-228             return;

 jmp .retnlookCode

;-229         }


;-230     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode2:
.lookCode5:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode6
 inc  word[OpCodePtr]

;-231     OpCodePtr++;

 jmp .lookCode5
.lookCode6:
 inc  word[OpCodePtr]

;-232     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode7
 jmp .lookCode1
.lookCode7:

;-233 }


;-234 


;-235 //#include "OPS.C"


;-236 int ChangeDirection() {

 .retnlookCode:
 ret
ENDP

ChangeDirection: PROC

;-237     char c;


;-238     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   237 NULL c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-239     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-240     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-241     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-242 }


;-243 


;-244 int checkOpL() {
 LEAVE
 ret
ENDP

checkOpL: PROC

;-245     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL8
 call implerror

;-246     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL8:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL9
 call segregerror
 jmp .retncheckOpL

;-247     setwflag();

.checkOpL9:
 call setwflag

;-248     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL10
 push checkOpL_0
 call error1
 add  sp, 2

;-249     if (OpSize == R1Type) return;

.checkOpL10:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL11
 jmp .retncheckOpL

;-250     if (Op == REG) if (R1Type==0) error1("no register defined");

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

;-251 }

.checkOpL13:
.checkOpL12:

;-252 


;-253 int check2Ops() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

check2Ops: PROC

;-254     get2Ops();

 call get2Ops

;-255     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops14
 call addrerror

;-256     if (Op == ADR) invaloperror();

.check2Ops14:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops15
 call invaloperror

;-257     if (Op == IMM) immeerror();

.check2Ops15:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops16
 call immeerror

;-258     if (Op2==   0) addrerror();

.check2Ops16:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops17
 call addrerror

;-259     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov

.check2Ops17:
 mov al, [CodeType]
 cmp al, 5
 je  .check2Ops18
 mov al, [Op2]
 cmp al, 3
 jne .check2Ops19
 call invaloperror

;-260     setwflag();

.check2Ops19:
.check2Ops18:
 call setwflag

;-261 }


;-262 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-263     getOpL();

 call getOpL

;-264     need(',');

 push 44
 call need
 add  sp, 2

;-265     getOpR();

 call getOpR

;-266 }


;-267 


;-268 int getOpL() {

 ret
ENDP

getOpL: PROC

;-269 //set: op=0,IMM,REG,ADR,MEM


;-270     getOpR();

 call getOpR

;-271     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-272     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-273     R1Type=R2Type; R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-274 }


;-275 


;-276 int getOpR() {

 ret
ENDP

getOpR: PROC

;-277     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-278     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR20
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-279     if (Op2 == 0)     {invaloperror();         return;}

.getOpR20:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR21
 call invaloperror
 jmp .retngetOpR

;-280     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR21:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR22
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-281     if (Op2 == REG)                            return;

.getOpR22:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR23
 jmp .retngetOpR

;-282     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}

.getOpR23:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR24
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp .retngetOpR

;-283     error1("Name of operand expected");

.getOpR24:
 push getOpR_0
 call error1
 add  sp, 2

;-284 }


;-285 


;-286 int getOp1() {//scan for a single operand

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOp1: PROC

;-287 //return:0, IMM, REG, ADR (not MEM)


;-288 //set   :R2Type, R2No by testReg


;-289 //set   :LabelIx by searchLabel


;-290     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp125
 mov ax, 0
 jmp .retngetOp1

;-291     if (TokeType == DIGIT)  return IMM;

.getOp125:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp126
 mov ax, 1
 jmp .retngetOp1

;-292     if (TokeType == ALNUME) {

.getOp126:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp127

;-293         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-294         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp128
 mov ax, 2
 jmp .retngetOp1

;-295         LabelIx=searchLabel();

.getOp128:
 call searchLabel
 mov word [LabelIx], ax

;-296         return ADR;

 mov ax, 3
 jmp .retngetOp1

;-297 //        if (LabelIx)        return ADR;


;-298 //        else error1("variable not found");


;-299     }


;-300     return 0;

.getOp127:
 mov ax, 0
 jmp .retngetOp1

;-301 }


;-302 


;-303 int getMEM() {// e.g. [array+bp+si-4]

 .retngetOp1:
 ret
ENDP

getMEM: PROC

;-304 //set: disp, rm, R2Type


;-305     char c;


;-306     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   305 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-307     do {

.getMEM29:

;-308         getTokeType();

 call getTokeType

;-309         c=getOp1();

 call getOp1
 mov [bp-2], al

;-310         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM30
 call syntaxerror

;-311         if (c == REG) {

.getMEM30:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM31

;-312             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-313             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM32
 call getIndReg2
 mov byte [rm], al

;-314             else getIndReg1();

 jmp .getMEM33
.getMEM32:
 call getIndReg1

;-315         }

.getMEM33:

;-316         if (c == ADR) {

.getMEM31:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM34

;-317             if (LabelIx)    disp=disp+LabelAddr[LabelIx];

 mov ax, [LabelIx]
 or  al, al
 je .getMEM35
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-318             else notfounderror();

 jmp .getMEM36
.getMEM35:
 call notfounderror

;-319         }

.getMEM36:

;-320         if (c == IMM) disp=disp+SymbolInt;

.getMEM34:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM37
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-321         if (isToken('-')) {

.getMEM37:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM38

;-322             getTokeType();

 call getTokeType

;-323             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM39
 call numbererror

;-324             disp = disp - SymbolInt;

.getMEM39:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-325         }


;-326     } while (isToken('+'));

.getMEM38:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM40
 jmp .getMEM29
.getMEM40:

;-327     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM41
 push getMEM_0
 call errorexit
 add  sp, 2

;-328 }

.getMEM41:

;-329 int getIndReg1() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getIndReg1: PROC

;-330     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg142
 call indexerror

;-331     if (R2No==3) rm=7;//BX

.getIndReg142:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg143
 mov ax, 7
 mov byte [rm], al

;-332     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg143:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg144
 mov ax, 6
 mov byte [rm], al

;-333     if (R2No==7) rm=5;//DI

.getIndReg144:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg145
 mov ax, 5
 mov byte [rm], al

;-334     if (R2No==6) rm=4;//SI

.getIndReg145:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg146
 mov ax, 4
 mov byte [rm], al

;-335     if (rm==0) indexerror();

.getIndReg146:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg147
 call indexerror

;-336 }

.getIndReg147:

;-337 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   337 NULL m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-338     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg248
 call indexerror

;-339     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg248:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg249
 mov al, [rm]
 cmp al, 6
 jne .getIndReg250
 mov ax, 3
 mov [bp-2], al

;-340              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg251
.getIndReg250:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg252
 mov ax, 1
 mov [bp-2], al

;-341     if (R2No==6) if (rm==6) m=2;//BP+SI

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

;-342              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg255
.getIndReg254:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg256
 mov ax, 0
 mov [bp-2], al

;-343     if (m > 3) indexerror();

.getIndReg256:
.getIndReg255:
.getIndReg253:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg257
 call indexerror

;-344     return m;

.getIndReg257:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-345 }


;-346 


;-347 int setwflag() {//word size, bit 0

 .retngetIndReg2: LEAVE
 ret
ENDP

setwflag: PROC

;-348     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-349     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag58

;-350         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag59
 mov al, [R1Type]
 mov byte [OpSize], al

;-351         if (Op2== REG) OpSize=R2Type;

.setwflag59:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag60
 mov al, [R2Type]
 mov byte [OpSize], al

;-352         if (R2Type== SEGREG) OpSize=WORD;

.setwflag60:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag61
 mov ax, 2
 mov byte [OpSize], al

;-353         if (R1Type == SEGREG) OpSize=WORD;

.setwflag61:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag62
 mov ax, 2
 mov byte [OpSize], al

;-354     }

.setwflag62:

;-355     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag58:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag63
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-356     if (OpSize  ==  WORD) wflag=1;

.setwflag63:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag64
 mov ax, 1
 mov byte [wflag], al

;-357 }

.setwflag64:

;-358 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-359     unsigned int ui;


;-360     sflag=2;

;Function : setsflag, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   359 NULL ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-361     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-362     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag65
 mov ax, 0
 mov byte [sflag], al

;-363     if (OpSize == BYTE) {

.setsflag65:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag66

;-364         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag67
 push setsflag_0
 call error1
 add  sp, 2

;-365         sflag=0;//byte reg does not need sign extended

.setsflag67:
 mov ax, 0
 mov byte [sflag], al

;-366     }


;-367 }

.setsflag66:

;-368 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-369     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   368 NULL ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize68
 mov ax, 0
 jmp .retncheckConstSize

;-370     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize68:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize69
 mov ax, 0
 jmp .retncheckConstSize

;-371     return 2;// is short

.checkConstSize69:
 mov ax, 2
 jmp .retncheckConstSize

;-372 }


;-373 


;-374 


;-375 //#include "PARSE.C"


;-376 int parse() {

 .retncheckConstSize: LEAVE
 ret
ENDP

parse: PROC

;-377     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-378     JmpCallNamePtr= &JmpCallNames;

 mov ax, JmpCallNames
 mov word [JmpCallNamePtr], ax

;-379     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-380     JmpCallMaxIx=0;

 mov ax, 0
 mov word [JmpCallMaxIx], ax

;-381     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-382     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-383 


;-384     do {//process a new line

.parse70:

;-385         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-386         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-387         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-388         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-389         getLine();

 call getLine

;-390         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-391         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-392         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse71

;-393             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse72

;-394               if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse73
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-395                 storeLabel();

.parse73:
 call storeLabel

;-396                 InputPtr++;//remove :

 inc  word[InputPtr]

;-397                 getTokeType();

 call getTokeType

;-398             }


;-399         }

.parse72:

;-400         if (TokeType == ALNUME) {

.parse71:
 mov al, [TokeType]
 cmp al, 3
 jne .parse74

;-401             lookCode();// and OpCodePtr

 call lookCode

;-402             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse75
 call process

;-403             else getVariable();

 jmp .parse76
.parse75:
 call getVariable

;-404             skipRest();

.parse76:
 call skipRest

;-405         }


;-406         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp .parse77
.parse74:
 mov al, [TokeType]
 cmp al, 3
 jle .parse78
 push parse_0
 call error1
 add  sp, 2

;-407         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp .parse79
.parse78:
 mov al, [TokeType]
 cmp al, 1
 jne .parse80
 push parse_1
 call error1
 add  sp, 2

;-408         printLine();

.parse80:
.parse79:
.parse77:
 call printLine

;-409     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse81
 jmp .parse70
.parse81:

;-410 }


;-411 


;-412 int getTokeType() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0
ENDP

getTokeType: PROC

;-413     char c;


;-414     skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   413 NULL c = bp-2;
 ENTER  2,0
 call skipBlank

;-415     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-416     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType82
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-417     if (c == ';') {TokeType=0; return; }//comment

.getTokeType82:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType83
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-418     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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

;-419     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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

;-420     TokeType=NOALNUME;

.getTokeType85:
 mov ax, 4
 mov byte [TokeType], al

;-421 }


;-422 


;-423 int storeJmpCall() {

 .retngetTokeType: LEAVE
 ret
ENDP

storeJmpCall: PROC

;-424     unsigned int i;


;-425     JmpCallMaxIx++;

;Function : storeJmpCall, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   424 NULL i = bp-2;
 ENTER  2,0
 inc  word[JmpCallMaxIx]

;-426     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");

 mov ax, [JmpCallMaxIx]
 cmp ax, 500 ;unsigned : 1
 jl  .storeJmpCall86
 push storeJmpCall_0
 call errorexit
 add  sp, 2

;-427     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);

.storeJmpCall86:
 lea  ax, [Symbol]
 push ax
 push word [JmpCallNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpCallNamePtr], ax

;-428     JmpCallNamePtr++;

 inc  word[JmpCallNamePtr]

;-429     i = JmpCallNamePtr - &JmpCallNames;

 mov ax, [JmpCallNamePtr]
 sub ax, JmpCallNames
 mov [bp-2], ax

;-430     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");

 mov ax, [bp-2]
 cmp ax, 1969 ;unsigned : 0
 jb  .storeJmpCall87
 push storeJmpCall_1
 call errorexit
 add  sp, 2

;-431     JmpCallAddr[JmpCallMaxIx] = PC;

.storeJmpCall87:
 mov ax, [PC]
 mov bx, [JmpCallMaxIx]
 shl bx, 1
 mov [JmpCallAddr+bx], ax

;-432 }


;-433 


;-434 int storeLabel() {
 LEAVE
 ret
storeJmpCall_0 db "too many JmpCalls",0
storeJmpCall_1 db "too many JmpCall names",0
ENDP

storeLabel: PROC

;-435     unsigned int i;


;-436     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   435 NULL i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel88
 push storeLabel_0
 call error1
 add  sp, 2

;-437     LabelMaxIx++;

.storeLabel88:
 inc  word[LabelMaxIx]

;-438     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel89
 push storeLabel_1
 call errorexit
 add  sp, 2

;-439     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel89:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-440     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-441     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-442     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeLabel90
 push storeLabel_2
 call errorexit
 add  sp, 2

;-443     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel90:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-444 }


;-445 


;-446 int searchLabel() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

searchLabel: PROC

;-447     int LIx; char *p;


;-448     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   447 NULL LIx = bp-2
;  201 ptr sign byte   447 NULL p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-449     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-450     while (LIx <= LabelMaxIx) {

.searchLabel91:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel92

;-451         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel93
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-452         p=strlen(p) + p;

.searchLabel93:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-453         p++;

 inc  word[bp-4]

;-454         LIx++;

 inc  word[bp-2]

;-455     }


;-456     return 0;

 jmp .searchLabel91
.searchLabel92:
 mov ax, 0
 jmp .retnsearchLabel

;-457 }


;-458 


;-459 int getVariable() {

 .retnsearchLabel: LEAVE
 ret
ENDP

getVariable: PROC

;-460     char c;


;-461     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   460 NULL c = bp-2;
 ENTER  2,0
 call storeLabel

;-462     getTokeType();

 call getTokeType

;-463     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable94

;-464         lookCode();

 call lookCode

;-465         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable95
 call dataexit

;-466         if (CodeType > 205) dataexit();

.getVariable95:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable96
 call dataexit

;-467         if (CodeType== 200) {//DB

.getVariable96:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable97

;-468             do {

.getVariable98:

;-469                 getTokeType();

 call getTokeType

;-470                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable99
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-471                 else {

 jmp .getVariable100
.getVariable99:

;-472                     skipBlank();

 call skipBlank

;-473                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable101

;-474                         do {

.getVariable102:

;-475                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-476                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-477                             InputPtr++;

 inc  word[InputPtr]

;-478                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable103
 jmp .getVariable102
.getVariable103:

;-479                         InputPtr++;

 inc  word[InputPtr]

;-480                     }


;-481                 }

.getVariable101:

;-482             } while (isToken(','));

.getVariable100:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable104
 jmp .getVariable98
.getVariable104:

;-483         }


;-484         if (CodeType == 201) {//DW

.getVariable97:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable105

;-485             do {

.getVariable106:

;-486                 getTokeType();

 call getTokeType

;-487                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable107
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-488             } while (isToken(','));

.getVariable107:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable108
 jmp .getVariable106
.getVariable108:

;-489         }


;-490         if (CodeType == 202) {//DD

.getVariable105:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable109

;-491             do {

.getVariable110:

;-492                 getTokeType();

 call getTokeType

;-493                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable111
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-494                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-495             } while (isToken(','));

.getVariable111:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable112
 jmp .getVariable110
.getVariable112:

;-496         }


;-497         if (CodeType >= 203) {//resb, resw, resd

.getVariable109:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable113

;-498             getTokeType();

 call getTokeType

;-499             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable114

;-500                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable115
 call syntaxerror

;-501                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable115:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable116
 push getVariable_0
 call error1
 add  sp, 2

;-502                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable116:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-503                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable117
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-504                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable117:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable118
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-505                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable118:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-506             } else numbererror();

 jmp .getVariable119
.getVariable114:
 call numbererror

;-507         }

.getVariable119:

;-508     }

.getVariable113:

;-509     else dataexit();

 jmp .getVariable120
.getVariable94:
 call dataexit

;-510 }

.getVariable120:

;-511 


;-512 int getCodeSize() {
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

getCodeSize: PROC

;-513     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize121

;-514         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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

;-515         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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

;-516         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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

;-517     }

.getCodeSize124:

;-518     return 0;

.getCodeSize121:
 mov ax, 0
 jmp .retngetCodeSize

;-519 }


;-520 int isToken(char c) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

isToken: PROC

;-521     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   520 NULL c = bp+4;
 ENTER  0,0
 call skipBlank

;-522     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken125

;-523         InputPtr++;

 inc  word[InputPtr]

;-524         return 1;

 mov ax, 1
 jmp .retnisToken

;-525         }


;-526     return 0;

.isToken125:
 mov ax, 0
 jmp .retnisToken

;-527 }


;-528 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-529     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   528 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need126

;-530         getTokeType();

 call getTokeType

;-531         return;

 jmp .retnneed

;-532         }


;-533     error1();

.need126:
 call error1

;-534     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-535     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-536 }


;-537 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-538     getTokeType();

 call getTokeType

;-539     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest127
 push skipRest_0
 call error1
 add  sp, 2

;-540 }

.skipRest127:

;-541 


;-542 


;-543 //#include "HELPER.C"


;-544 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }

 ret
skipRest_0 db "extra char ignored",0
ENDP

writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16

;-545 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
ENDP

putch: PROC
;Function : putch, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   545 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .putch128
 mov  al, 13
 call writetty
.putch128:
 mov  al, [bp+4]
 call writetty

;-546 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
ENDP

cputs: PROC
;Function : cputs, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   546 NULL s = bp+4
;  201 var sign byte   546 NULL c = bp-2;
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

;-547 


;-548 int DosInt() {
 LEAVE
 ret
ENDP

DosInt: PROC

;-549     __emit__(0xCD,0x21);//inth 0x21;

 db 205,33

;-550     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4

;-551     DOS_ERR++;

 inc  word[DOS_ERR]

;-552 }


;-553 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC
;Function : openR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   553 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-554 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP

creatR: PROC
;Function : creatR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   554 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-555 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP

fcloseR: PROC
;Function : fcloseR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   555 NULL fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt

;-556 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP

exitR: PROC
;Function : exitR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   556 NULL c = bp+4;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt

;-557 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
 LEAVE
 ret
ENDP

readRL: PROC
;Function : readRL, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   557 NULL s = bp+4
;  201 var sign word   557 NULL fd = bp+6
;  202 var sign word   557 NULL len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-558 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP

fputcR: PROC
;Function : fputcR, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   558 NULL n = bp+4
;  201 var sign word   558 NULL fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]

;-559   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-560 


;-561 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
 LEAVE
 ret
ENDP

getLine: PROC

;-562   unsigned int i;


;-563   InputPtr= &InputBuf;

;Function : getLine, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   562 NULL i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-564   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-565   do {

.getLine131:

;-566     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-567     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine132
 push getLine_0
 call errorexit
 add  sp, 2

;-568     if (DOS_NoBytes == 0) return;

.getLine132:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine133
 jmp .retngetLine

;-569     *InputPtr = DOS_ByteRead;

.getLine133:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-570     InputPtr++;

 inc  word[InputPtr]

;-571     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-572     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine134
 push getLine_1
 call errorexit
 add  sp, 2

;-573   } while (ifEOL(DOS_ByteRead) == 0);

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

;-574   InputPtr--;

 dec  word[InputPtr]

;-575   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-576 }


;-577 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

ifEOL: PROC

;-578   if (c == 10) return 1;//LF

;Function : ifEOL, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   577 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL136
 mov ax, 1
 jmp .retnifEOL

;-579   if (c == 13) {//CR

.ifEOL136:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL137

;-580     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-581     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL138
 push ifEOL_0
 call errorexit
 add  sp, 2

;-582     return 1;

.ifEOL138:
 mov ax, 1
 jmp .retnifEOL

;-583   }


;-584   return 0;

.ifEOL137:
 mov ax, 0
 jmp .retnifEOL

;-585 }


;-586 int skipBlank() {

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

skipBlank: PROC

;-587   skipblank1:

.skipblank1:

;-588     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank139
 inc  word[InputPtr]
 jmp .skipblank1

;-589     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank139:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank140
 inc  word[InputPtr]
 jmp .skipblank1

;-590 }

.skipBlank140:

;-591 int letterE(char c) {

 ret
ENDP

letterE: PROC

;-592   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   591 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE141
 mov ax, 1
 jmp .retnletterE

;-593   if (c=='.') return 1;

.letterE141:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE142
 mov ax, 1
 jmp .retnletterE

;-594   if (c=='?') return 1;

.letterE142:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE143
 mov ax, 1
 jmp .retnletterE

;-595   if (c=='$') return 1;

.letterE143:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE144
 mov ax, 1
 jmp .retnletterE

;-596   if (c> 'z') return 0;

.letterE144:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE145
 mov ax, 0
 jmp .retnletterE

;-597   if (c< '@') return 0; // at included

.letterE145:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE146
 mov ax, 0
 jmp .retnletterE

;-598   if (c> 'Z') { if (c< 'a') return 0; }

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

;-599   return 1;

.letterE147:
 mov ax, 1
 jmp .retnletterE

;-600 }


;-601 int alnumE(char c) {

 .retnletterE: LEAVE
 ret
ENDP

alnumE: PROC

;-602   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   601 NULL c = bp+4;
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

;-603   if (letterE(c)) return 1;

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

;-604   return 0;

.alnumE150:
 mov ax, 0
 jmp .retnalnumE

;-605 }


;-606 int digit(char c){

 .retnalnumE: LEAVE
 ret
ENDP

digit: PROC

;-607     if(c<'0') return 0;

;Function : digit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   606 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit151
 mov ax, 0
 jmp .retndigit

;-608     if(c>'9') return 0;

.digit151:
 mov al, [bp+4]
 cmp al, 57
 jle .digit152
 mov ax, 0
 jmp .retndigit

;-609     return 1;

.digit152:
 mov ax, 1
 jmp .retndigit

;-610 }


;-611 int strlen(char *s) { int c;

 .retndigit: LEAVE
 ret
ENDP

strlen: PROC

;-612     c=0;

;Function : strlen, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   611 NULL s = bp+4
;  201 var sign word   611 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax

;-613     while (*s!=0) {s++; c++;}

.strlen153:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen154
 inc  word[bp+4]
 inc  word[bp-2]

;-614     return c;

 jmp .strlen153
.strlen154:
 mov ax, [bp-2]
 jmp .retnstrlen

;-615     }


;-616 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP

strcpy: PROC

;-617     do { *s=*t; s++; t++; }

;Function : strcpy, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   616 NULL s = bp+4
;  201 ptr sign byte   616 NULL t = bp+6;
 ENTER  0,0
.strcpy155:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]

;-618     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy156
 jmp .strcpy155
.strcpy156:

;-619     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al

;-620     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy

;-621     }


;-622 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP

eqstr: PROC

;-623     while(*p) {

;Function : eqstr, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   622 NULL p = bp+4
;  201 ptr sign byte   622 NULL q = bp+6;
 ENTER  0,0
.eqstr157:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr158

;-624         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr159
 mov ax, 0
 jmp .retneqstr

;-625             p++;

.eqstr159:
 inc  word[bp+4]

;-626             q++;

 inc  word[bp+6]

;-627             }


;-628     if(*q) return 0;

 jmp .eqstr157
.eqstr158:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr160
 mov ax, 0
 jmp .retneqstr

;-629     return 1;

.eqstr160:
 mov ax, 1
 jmp .retneqstr

;-630     }


;-631 int strcat1(char *s, char *t) {

 .retneqstr: LEAVE
 ret
ENDP

strcat1: PROC

;-632     while (*s != 0) s++;

;Function : strcat1, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   631 NULL s = bp+4
;  201 ptr sign byte   631 NULL t = bp+6;
 ENTER  0,0
.strcat1161:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat1162
 inc  word[bp+4]

;-633     strcpy(s, t);

 jmp .strcat1161
.strcat1162:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-634     }


;-635 int toupper(char *s) {
 LEAVE
 ret
ENDP

toupper: PROC

;-636     while(*s) {

;Function : toupper, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   635 NULL s = bp+4;
 ENTER  0,0
.toupper163:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper164

;-637         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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

;-638             s++;

.toupper166:
.toupper165:
 inc  word[bp+4]

;-639               }


;-640     }

 jmp .toupper163
.toupper164:

;-641 


;-642 int getDigit(unsigned char c) {//ret: SymbolInt
 LEAVE
 ret
ENDP

getDigit: PROC

;-643   unsigned int CastInt;


;-644   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   642 NULL c = bp+4
;  201 var unsg word   643 NULL CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-645   do {

.getDigit167:

;-646     c-='0';

 sub  byte[bp+4], 48

;-647     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-648     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-649     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-650     InputPtr++;

 inc  word[InputPtr]

;-651     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-652   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit168
 jmp .getDigit167
.getDigit168:

;-653 }


;-654 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-655   char *p; unsigned int i;


;-656   p = &Symbol;

;Function : getName, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   654 NULL c = bp+4
;  201 ptr sign byte   655 NULL p = bp-2
;  202 var unsg word   655 NULL i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-657   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-658   p++;

 inc  word[bp-2]

;-659   while (alnumE(c)) {

.getName169:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName170

;-660     InputPtr++;

 inc  word[InputPtr]

;-661     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-662     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-663     p++;

 inc  word[bp-2]

;-664     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-665     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName171
 push getName_0
 call errorexit
 add  sp, 2

;-666   }

.getName171:

;-667   if (c == ':') isLabel=1; else isLabel=0;

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

;-668   p--;

.getName173:
 dec  word[bp-2]

;-669   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-670   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-671   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-672 }


;-673 int testReg() {
 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP

testReg: PROC

;-674 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-675   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al

;-676   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg174
 mov ax, 0
 jmp .retntestReg

;-677   if (strlen(Symbol) > 3) return 0;

.testReg174:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg175
 mov ax, 0
 jmp .retntestReg

;-678   R2Type=BYTE;

.testReg175:
 mov ax, 1
 mov byte [R2Type], al

;-679   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg176
 mov ax, 0
 jmp .retntestReg

;-680   if (eqstr(SymbolUpper, "CL")) return 1;

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

;-681   if (eqstr(SymbolUpper, "DL")) return 2;

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

;-682   if (eqstr(SymbolUpper, "BL")) return 3;

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

;-683   if (eqstr(SymbolUpper, "AH")) return 4;

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

;-684   if (eqstr(SymbolUpper, "CH")) return 5;

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

;-685   if (eqstr(SymbolUpper, "DH")) return 6;

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

;-686   if (eqstr(SymbolUpper, "BH")) return 7;

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

;-687   R2Type=WORD;

.testReg183:
 mov ax, 2
 mov byte [R2Type], al

;-688   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg184
 mov ax, 0
 jmp .retntestReg

;-689   if (eqstr(SymbolUpper, "CX")) return 1;

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

;-690   if (eqstr(SymbolUpper, "DX")) return 2;

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

;-691   if (eqstr(SymbolUpper, "BX")) return 3;

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

;-692   if (eqstr(SymbolUpper, "SP")) return 4;

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

;-693   if (eqstr(SymbolUpper, "BP")) return 5;

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

;-694   if (eqstr(SymbolUpper, "SI")) return 6;

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

;-695   if (eqstr(SymbolUpper, "DI")) return 7;

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

;-696   R2Type=SEGREG;

.testReg191:
 mov ax, 4
 mov byte [R2Type], al

;-697   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg192
 mov ax, 0
 jmp .retntestReg

;-698   if (eqstr(SymbolUpper, "CS")) return 1;

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

;-699   if (eqstr(SymbolUpper, "SS")) return 2;

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

;-700   if (eqstr(SymbolUpper, "DS")) return 3;

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

;-701   if (eqstr(SymbolUpper, "FS")) return 4;

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

;-702   if (eqstr(SymbolUpper, "GS")) return 5;

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

;-703   R2Type=DWORD;

.testReg197:
 mov ax, 3
 mov byte [R2Type], al

;-704   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg198
 mov ax, 0
 jmp .retntestReg

;-705   if (eqstr(SymbolUpper, "ECX"))return 1;

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

;-706   if (eqstr(SymbolUpper, "EDX"))return 2;

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

;-707   if (eqstr(SymbolUpper, "EBX"))return 3;

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

;-708   if (eqstr(SymbolUpper, "ESP"))return 4;

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

;-709   if (eqstr(SymbolUpper, "EBP"))return 5;

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

;-710   if (eqstr(SymbolUpper, "ESI"))return 6;

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

;-711   if (eqstr(SymbolUpper, "EDI"))return 7;

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

;-712   R2Type=0; return 0;

.testReg205:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg

;-713 }


;-714 


;-715 


;-716 //#include "OUTPUT.C"


;-717 int printLine() {

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

;-718     int i; char c;


;-719     prs("\n");

;Function : printLine, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   718 NULL i = bp-2
;  201 var sign byte   718 NULL c = bp-4;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-720     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-721     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine206
 push printLine_1
 call prs
 add  sp, 2

;-722     else {

 jmp .printLine207
.printLine206:

;-723 //        prc(' ');


;-724         i=0;

 mov ax, 0
 mov [bp-2], ax

;-725         do {

.printLine208:

;-726             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al

;-727             prc(' ');

 push 32
 call prc
 add  sp, 2

;-728             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-729             i++;

 inc  word[bp-2]

;-730         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine209
 jmp .printLine208
.printLine209:

;-731         while (i < OPMAXLEN) {// fill rest with blank

.printLine210:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine211

;-732             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-733             i++;

 inc  word[bp-2]

;-734         }


;-735     }

 jmp .printLine210
.printLine211:

;-736     prc(PrintRA);

.printLine207:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-737     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-738 }


;-739 int prc(unsigned char c) {//print char
 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

prc: PROC

;-740         if ( _ c==10) {

;Function : prc, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   739 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .prc212

;-741             ax=13;

 mov  ax, 13

;-742             writetty();

 call writetty

;-743             }


;-744         al=c;

.prc212:
 mov  al, [bp+4]

;-745         writetty();

 call writetty

;-746     fputcR(c,lst_fd);

 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-747 }


;-748 


;-749 int prscomment(unsigned char *s) {
 LEAVE
 ret
ENDP

prscomment: PROC

;-750     unsigned char c;


;-751     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   749 NULL s = bp+4
;  201 var unsg byte   750 NULL c = bp-2;
 ENTER  2,0
.prscomment213:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment214

;-752         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-753         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-754         s++;

 inc  word[bp+4]

;-755     }


;-756 }

 jmp .prscomment213
.prscomment214:

;-757 int prs(unsigned char *s) {
 LEAVE
 ret
ENDP

prs: PROC

;-758     unsigned char c;


;-759     int com;


;-760     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   757 NULL s = bp+4
;  201 var unsg byte   758 NULL c = bp-2
;  202 var sign word   759 NULL com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax

;-761     while (*s) {

.prs215:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs216

;-762         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-763         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs217

;-764             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs218
 mov ax, 0
 mov [bp-4], ax

;-765                 else com=1;

 jmp .prs219
.prs218:
 mov ax, 1
 mov [bp-4], ax

;-766         }

.prs219:

;-767         if (c==92) {

.prs217:
 mov al, [bp-2]
 cmp al, 92
 jne .prs220

;-768             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs221

;-769                 s++;

 inc  word[bp+4]

;-770                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-771                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs222
 mov ax, 10
 mov [bp-2], al

;-772                 if (c=='t') c= 9;

.prs222:
 mov al, [bp-2]
 cmp al, 116
 jne .prs223
 mov ax, 9
 mov [bp-2], al

;-773             }

.prs223:

;-774         }

.prs221:

;-775         prc(c);

.prs220:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-776         s++;

 inc  word[bp+4]

;-777     }


;-778 }

 jmp .prs215
.prs216:

;-779 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP

printhex8a: PROC

;-780     unsigned char nib;


;-781     nib = c >> 4; printhex4(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   779 NULL c = bp+4
;  201 var unsg byte   780 NULL nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-782     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-783 }


;-784 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP

printhex4: PROC

;-785     c += 48;

;Function : printhex4, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   784 NULL c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48

;-786     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex4224
 add  byte[bp+4], 7

;-787     prc(c);

.printhex4224:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-788 }


;-789 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP

printhex16: PROC

;-790     unsigned int half;


;-791     half = i >>  8; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   789 NULL i = bp+4
;  201 var unsg word   790 NULL half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-792     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-793 }


;-794 int printIntU(unsigned int n) {
 LEAVE
 ret
ENDP

printIntU: PROC

;-795     unsigned int e;


;-796     if ( _ n >= 10) {

;Function : printIntU, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   794 NULL n = bp+4
;  201 var unsg word   795 NULL e = bp-2;
 ENTER  2,0 ; constant expression
cmp word[bp+4], 10 ;unsigned : 0
 jb  .printIntU225

;-797         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax

;-798         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-799     }


;-800     n = n % 10; //unsigned mod

.printIntU225:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax

;-801     n += '0';

 add  word[bp+4], 48

;-802     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-803 }


;-804 


;-805 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-806     ErrorCount++;

;Function : error1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   805 NULL s = bp+4;
 ENTER  0,0
 inc  word[ErrorCount]

;-807     prs("\n;***** next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-808     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-809     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-810     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-811 }


;-812 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-813     error1(s);

;Function : errorexit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   812 NULL s = bp+4;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-814     epilog();

 call epilog

;-815     end1(1);

 push 1
 call end1
 add  sp, 2

;-816 }


;-817 int notfounderror(){error1("label not found"); }
 LEAVE
 ret
ENDP

notfounderror: PROC
 push notfounderror_0
 call error1
 add  sp, 2

;-818 int allowederror() {error1("not allowed here"); }

 ret
notfounderror_0 db "label not found",0
ENDP

allowederror: PROC
 push allowederror_0
 call error1
 add  sp, 2

;-819 int addrerror()    {error1("address missing");}

 ret
allowederror_0 db "not allowed here",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-820 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-821 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-822 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-823 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-824 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-825 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-826 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-827 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-828 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-829 


;-830 int addrexit()     {errorexit("illegal address");}

 ret
syntaxerror_0 db "syntax",0
ENDP

addrexit: PROC
 push addrexit_0
 call errorexit
 add  sp, 2

;-831 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
addrexit_0 db "illegal address",0
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-832 int internexit()   {errorexit("intern compiler error");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

internexit: PROC
 push internexit_0
 call errorexit
 add  sp, 2

;-833 


;-834 


;-835 //#include "MAIN.C"


;-836 int main() {

 ret
internexit_0 db "intern compiler error",0
ENDP

main: PROC

;-837     getarg();

 call getarg

;-838     parse();

 call parse

;-839     fixJmpCall();

 call fixJmpCall

;-840     epilog();

 call epilog

;-841     end1();

 call end1

;-842 }


;-843 


;-844 int getarg() {

 ret
ENDP

getarg: PROC

;-845     int arglen1; int i; char *c;


;-846     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var sign word   845 NULL arglen1 = bp-2
;  201 var sign word   845 NULL i = bp-4
;  202 ptr sign byte   845 NULL c = bp-6;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-847     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg226

;-848         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-849         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-850         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-851     }


;-852     i=arglen1+129;

.getarg226:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-853     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-854     arglen1--;

 dec  word[bp-2]

;-855     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-856 


;-857     strcpy(namein, argv); strcat1(namein, ".S");

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

;-858     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-859     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-860 


;-861   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-862 


;-863     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-864     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

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

;-865     lst_fd=creatR(namelst);

.getarg227:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-866     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

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

;-867     bin_fd=creatR(namebin);

.getarg228:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-868     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

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

;-869 


;-870     prs(";");

.getarg229:
 push getarg_7
 call prs
 add  sp, 2

;-871     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-872     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-873     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-874     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-875     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-876 }


;-877 


;-878 int fixJmpCall() {
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

;-879     int i;  unsigned int hex;  char *p; int Ix; char c;


;-880     i=1;

;Function : fixJmpCall, Number of local variables: 5
;   # type sign width addr used name   list of local variables
;  200 var sign word   879 NULL i = bp-2
;  201 var unsg word   879 NULL hex = bp-4
;  202 ptr sign byte   879 NULL p = bp-6
;  203 var sign word   879 NULL Ix = bp-8
;  204 var sign byte   879 NULL c = bp-10;
 ENTER  10,0
 mov ax, 1
 mov [bp-2], ax

;-881     prs("\n;END open jmp/call: ");

 push fixJmpCall_0
 call prs
 add  sp, 2

;-882     printIntU(JmpCallMaxIx);

 push word [JmpCallMaxIx]
 call printIntU
 add  sp, 2

;-883     p = &JmpCallNames;

 mov ax, JmpCallNames
 mov [bp-6], ax

;-884     while (i <= JmpCallMaxIx) {

.fixJmpCall230:
 mov ax, [bp-2]
 cmp ax, [JmpCallMaxIx]
 jg  .fixJmpCall231

;-885         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-886         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-887         p++;

 inc  word[bp-6]

;-888 //        prs(Symbol);


;-889 //        prc(' ');


;-890         hex = JmpCallAddr[i];

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [JmpCallAddr + bx]
 mov [bp-4], ax

;-891 //        printhex16(hex);


;-892 


;-893         Ix=searchLabel();

 call searchLabel
 mov [bp-8], ax

;-894         if (Ix == 0) error1("Label not found");

 mov ax, [bp-8]
 cmp ax, 0
 jne .fixJmpCall232
 push fixJmpCall_1
 call error1
 add  sp, 2

;-895         disp = LabelAddr[Ix];

.fixJmpCall232:
 mov bx, [bp-8]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-896         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp-4]
 mov word [disp], ax

;-897         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-898 //        prs(", ");


;-899 


;-900             hex = hex - 2;//fix at start of word

 mov ax, [bp-4]
 sub ax, 2
 mov [bp-4], ax

;-901             FileBin[hex] = disp;//fix low byte

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-902             hex++;

 inc  word[bp-4]

;-903             disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-904             FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-905         i++;

 inc  word[bp-2]

;-906     }


;-907 }

 jmp .fixJmpCall230
.fixJmpCall231:

;-908 


;-909 int epilog() {
 LEAVE
 ret
fixJmpCall_0 db "\n;END open jmp/call: ",0
fixJmpCall_1 db "Label not found",0
ENDP

epilog: PROC

;-910     unsigned int i; char c;     int j;


;-911     prs("\n Errors: ");

;Function : epilog, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word   910 NULL i = bp-2
;  201 var sign byte   910 NULL c = bp-4
;  202 var sign word   910 NULL j = bp-6;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-912     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-913     if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog233
 push epilog_1
 call prs
 add  sp, 2

;-914     prs(", Out: ");

.epilog233:
 push epilog_2
 call prs
 add  sp, 2

;-915     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-916     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-917     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-918     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-919     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-920     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-921 


;-922     i=0;

 mov ax, 0
 mov [bp-2], ax

;-923     do {

.epilog234:

;-924         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-925         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-926 //printhex8a(c); prc(' ');


;-927         i++;

 inc  word[bp-2]

;-928     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog235
 jmp .epilog234
.epilog235:

;-929 


;-930   prs(" Labels: ");

 push epilog_6
 call prs
 add  sp, 2

;-931   printIntU(LabelMaxIx);

 push word [LabelMaxIx]
 call printIntU
 add  sp, 2

;-932   prs(". ");

 push epilog_7
 call prs
 add  sp, 2

;-933 /*


;-934   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);


;-935   i= &LabelNames;


;-936   prs(" &LabelNames:"); printIntU(i);


;-937   i=LabelNamePtr-i;


;-938   prs("size: ");


;-939   printIntU(i);


;-940   prs(". >>");


;-941   i= &LabelNames;


;-942   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-943   } while (i < LabelNamePtr); prs("<< \n");


;-944    i = 1;


;-945     LabelNamePtr= &LabelNames;


;-946     do {


;-947       prs(LabelNamePtr); prc(' ');


;-948       j=LabelAddr[i]; printhex16(j); prs(", ");


;-949       j=strlen(LabelNamePtr);//get end of actual name


;-950       LabelNamePtr=LabelNamePtr+j;


;-951       LabelNamePtr++;


;-952       i++;


;-953     } while (i <= LabelMaxIx);


;-954 */


;-955 }


;-956 


;-957 int end1(int n) {
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

;-958     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   957 NULL n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-959     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-960     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-961     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-962 }


;-963 


;-964 


;-965 //#include "GENCODE.C"


;-966 // generate code


;-967 int getCodes() {
 LEAVE
 ret
ENDP

getCodes: PROC

;-968     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-969     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-970     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-971 }


;-972 int gen66h() {genCode8(0x66);

 ret
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-973 }


;-974 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-975     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   974 NULL c = bp+4
;  201 var sign byte   974 NULL d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-976     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-977 }


;-978 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-979     c = c + wflag;

;Function : genCodeW, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   978 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-980     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-981 }


;-982 int genCode8(char c) {
 LEAVE
 ret
ENDP

genCode8: PROC

;-983 //set: BinLen++, OpPrintIndex++


;-984     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   982 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-985     BinLen++;

 inc  word[BinLen]

;-986     PC++;

 inc  word[PC]

;-987     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 20000 ;unsigned : 0
 jb  .genCode8236
 push genCode8_0
 call errorexit
 add  sp, 2

;-988     if (OpPrintIndex < OPMAXLEN) {

.genCode8236:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8237

;-989         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-990         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-991     }


;-992 }

.genCode8237:

;-993 int genCode16(unsigned int i) {
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

genCode16: PROC

;-994     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   993 NULL i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-995     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-996 }


;-997 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-998     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg dwrd   997 NULL L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-999     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-1000 }


;-1001 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-1002 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-1003 //mod-bits: mode76, reg/opcode543, r/m210


;-1004 //Op: 0, IMM, REG, ADR, MEM


;-1005     char len;


;-1006     len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1001 NULL xxx = bp+4
;  201 var sign byte  1005 NULL len = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-1007     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-1008     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA238

;-1009         xxx |= 0xC0;

 or  byte[bp+4], 192

;-1010         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA239
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1011             else {

 jmp .writeEA240
.writeEA239:

;-1012                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA241
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1013                 else            xxx = xxx + R2No;

 jmp .writeEA242
.writeEA241:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-1014             }

.writeEA242:

;-1015         }

.writeEA240:

;-1016     if (Op == MEM) {

.writeEA238:
 mov al, [Op]
 cmp al, 4
 jne .writeEA243

;-1017         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA244

;-1018             xxx |= 6;

 or  byte[bp+4], 6

;-1019             len = 2;

 mov ax, 2
 mov [bp-2], al

;-1020         }


;-1021         else {

 jmp .writeEA245
.writeEA244:

;-1022             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-1023             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA246

;-1024                 len=1;

 mov ax, 1
 mov [bp-2], al

;-1025                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA247
 or  byte[bp+4], 64

;-1026             }

.writeEA247:

;-1027 


;-1028             if (disp) {

.writeEA246:
 mov ax, [disp]
 or  al, al
 je .writeEA248

;-1029                 ax = disp;

 mov  ax, [disp]

;-1030                 if(ax > 127) len=2;

 cmp  ax, 127
 jle .writeEA249
 mov ax, 2
 mov [bp-2], al

;-1031                 else len=1;

 jmp .writeEA250
.writeEA249:
 mov ax, 1
 mov [bp-2], al

;-1032                 if (len == 1) xxx |= 0x40;

.writeEA250:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA251
 or  byte[bp+4], 64

;-1033                 else xxx |= 0x80;

 jmp .writeEA252
.writeEA251:
 or  byte[bp+4], 128

;-1034             }

.writeEA252:

;-1035         }

.writeEA248:

;-1036     }

.writeEA245:

;-1037 


;-1038     genCode8(xxx);// gen second byte

.writeEA243:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1039     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA253
 push word [disp]
 call genCode8
 add  sp, 2

;-1040     if (len == 2) genCode16(disp);

.writeEA253:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA254
 push word [disp]
 call genCode16
 add  sp, 2

;-1041 }

.writeEA254:

;-1042 


;-1043 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-1044     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long

 mov al, [wflag]
 or  al, al
 je .genImmediate255
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate256
 push word [imme]
 call genCode32
 add  sp, 2

;-1045         else genCode16(imme);

 jmp .genImmediate257
.genImmediate256:
 push word [imme]
 call genCode16
 add  sp, 2

;-1046     else       genCode8 (imme);

.genImmediate257:
 jmp .genImmediate258
.genImmediate255:
 push word [imme]
 call genCode8
 add  sp, 2

;-1047 }

.genImmediate258:

;-1048 


;-1049 //AS.C


;-1050 int process() {

 ret
ENDP

process: PROC

;-1051     char c;


;-1052     int i;


;-1053     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1051 NULL c = bp-2
;  201 var sign word  1052 NULL i = bp-4;
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

;-1054     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-1055     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-1056     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-1057     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-1058     getCodes();//set: Code1, Code2, Code3

 call getCodes

;-1059 


;-1060     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process259

;-1061         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1062         return;

 jmp .retnprocess

;-1063     }


;-1064 


;-1065     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process259:
 mov al, [CodeType]
 cmp al, 2
 jne .process260

;-1066         getOpL();

 call getOpL

;-1067         checkOpL();

 call checkOpL

;-1068         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  .process261

;-1069   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process262

;-1070                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je .process263
 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
 jmp .retnprocess

;-1071             }

.process263:

;-1072         }

.process262:

;-1073         if (Code2 == 5) {//imul extension?

.process261:
 mov al, [Code2]
 cmp al, 5
 jne .process264

;-1074             getTokeType();

 call getTokeType

;-1075             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process265
 call implerror

;-1076         }

.process265:

;-1077         genCodeW(Code1);

.process264:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1078         writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1079         return;

 jmp .retnprocess

;-1080     }


;-1081 


;-1082     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process260:
 mov al, [CodeType]
 cmp al, 3
 jne .process266

;-1083         check2Ops();    //setwflag not applicable

 call check2Ops

;-1084         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process267
 call reg16error

;-1085         if (Op2 != MEM) addrerror();//only m16

.process267:
 mov al, [Op2]
 cmp al, 4
 je  .process268
 call addrerror

;-1086 


;-1087         genCode8(Code1);//les,lds,lea

.process268:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1088         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 15
 jne .process269
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1089         Op=Op2;//set MEM for writeEA

.process269:
 mov al, [Op2]
 mov byte [Op], al

;-1090         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1091         return;

 jmp .retnprocess

;-1092     }


;-1093 


;-1094     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process266:
 mov al, [CodeType]
 cmp al, 4
 jne .process270

;-1095         check2Ops();

 call check2Ops

;-1096         if (Op2 == IMM) {//second operand is imm

 mov al, [Op2]
 cmp al, 1
 jne .process271

;-1097             setsflag();

 call setsflag

;-1098             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process272

;-1099                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process273

;-1100                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process274

;-1101                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1102                         c += 4;

 add  byte[bp-2], 4

;-1103                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1104                         genImmediate();

 call genImmediate

;-1105                         return;

 jmp .retnprocess

;-1106                     }


;-1107                 }

.process274:

;-1108             }

.process273:

;-1109             //r/m, imm: 80 sign-extended,TTT,imm


;-1110             c = sflag + 0x80;

.process272:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1111             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1112             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1113             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process275
 push word [imme]
 call genCode8
 add  sp, 2

;-1114             else genImmediate();

 jmp .process276
.process275:
 call genImmediate

;-1115             return;

.process276:
 jmp .retnprocess

;-1116         }


;-1117         c = Code1 << 3;//r/m, r/r

.process271:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1118         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process277

;-1119             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process278

;-1120                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1121                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1122                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1123                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1124                 return;

 jmp .retnprocess

;-1125             }


;-1126         }

.process278:

;-1127         if (Op2 == REG) {//mem,reg    reg,reg

.process277:
 mov al, [Op2]
 cmp al, 2
 jne .process279

;-1128             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1129             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1130             return;

 jmp .retnprocess

;-1131         }


;-1132         syntaxerror();

.process279:
 call syntaxerror

;-1133         return;

 jmp .retnprocess

;-1134     }


;-1135 


;-1136     if (CodeType == 5) {//mov (movsx, movzx=51)

.process270:
 mov al, [CodeType]
 cmp al, 5
 jne .process280

;-1137         check2Ops();

 call check2Ops

;-1138 /*    prs("\n Op:"); printhex8a(Op);


;-1139     prs(", Op2:"); printhex8a(Op2);


;-1140     prs(", R1No:"); printhex8a(R1No);


;-1141     prs(", R2No:"); printhex8a(R2No);   */


;-1142         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process281

;-1143             if (disp) imme=disp;

 mov ax, [disp]
 or  al, al
 je .process282
 mov ax, [disp]
 mov word [imme], ax

;-1144             else notfounderror();

 jmp .process283
.process282:
 call notfounderror

;-1145             Op2=IMM;//continue with IMM

.process283:
 mov ax, 1
 mov byte [Op2], al

;-1146         }


;-1147         if (Op2 == IMM) {// r,i

.process281:
 mov al, [Op2]
 cmp al, 1
 jne .process284

;-1148             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process285

;-1149                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1150                 c += 0xB0;

 add  byte[bp-2], 176

;-1151                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1152                 genImmediate();

 call genImmediate

;-1153                 return;

 jmp .retnprocess

;-1154             }


;-1155             if (Op == MEM) {// m,i

.process285:
 mov al, [Op]
 cmp al, 4
 jne .process286

;-1156                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1157                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1158                 genImmediate();

 call genImmediate

;-1159                 return;

 jmp .retnprocess

;-1160             }


;-1161             regmemerror();

.process286:
 call regmemerror

;-1162             return;

 jmp .retnprocess

;-1163         }


;-1164         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process284:
 mov al, [R1Type]
 cmp al, 4
 jne .process287
 call ChangeDirection

;-1165         if (R2Type == SEGREG) {//rm,sreg

.process287:
 mov al, [R2Type]
 cmp al, 4
 jne .process288

;-1166             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process289
 call reg16error

;-1167                 genCode2(0x8C, dflag);

.process289:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1168                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1169                 return;

 jmp .retnprocess

;-1170         }


;-1171         if (Op2 == MEM) {//acc, moffs16

.process288:
 mov al, [Op2]
 cmp al, 4
 jne .process290

;-1172             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process291

;-1173                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process292

;-1174                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process293

;-1175                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1176                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1177                         return;

 jmp .retnprocess

;-1178                     }


;-1179                 }

.process293:

;-1180             }

.process292:

;-1181         }

.process291:

;-1182         if (Op == MEM) {//moffs16, acc

.process290:
 mov al, [Op]
 cmp al, 4
 jne .process294

;-1183             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process295

;-1184                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process296

;-1185                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process297

;-1186                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1187                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1188                         return;

 jmp .retnprocess

;-1189                     }


;-1190                 }

.process297:

;-1191             }

.process296:

;-1192 


;-1193         }

.process295:

;-1194         if (Op2 == REG) {//rm, r

.process294:
 mov al, [Op2]
 cmp al, 2
 jne .process298

;-1195             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1196             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1197             return;

 jmp .retnprocess

;-1198         }


;-1199         if (Op2 == MEM) {//r, m

.process298:
 mov al, [Op2]
 cmp al, 4
 jne .process299

;-1200             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process300

;-1201                 ChangeDirection();

 call ChangeDirection

;-1202                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1203                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1204                 return;

 jmp .retnprocess

;-1205             }


;-1206         }

.process300:

;-1207         syntaxerror();

.process299:
 call syntaxerror

;-1208         return;

 jmp .retnprocess

;-1209     }


;-1210 


;-1211     if (CodeType == 6) {//Jcc

.process280:
 mov al, [CodeType]
 cmp al, 6
 jne .process301

;-1212         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process302

;-1213             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1214             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process303

;-1215                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1216                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1217                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1218                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process304

;-1219                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1220                     disp -= 2;

 sub  word[disp], 2

;-1221                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1222                 } else {

 jmp .process305
.process304:

;-1223                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1224                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1225                     disp -= 4;

 sub  word[disp], 4

;-1226                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1227                 }


;-1228             }

.process305:

;-1229             else {//jump forward, near only

 jmp .process306
.process303:

;-1230                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1231                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1232                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1233                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1234                 storeJmpCall();

 call storeJmpCall

;-1235             }


;-1236         return;

.process306:
 jmp .retnprocess

;-1237         }


;-1238     }

.process302:

;-1239 


;-1240     if (CodeType == 7) {//jmp, call

.process301:
 mov al, [CodeType]
 cmp al, 7
 jne .process307

;-1241         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process308

;-1242             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1243             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process309

;-1244                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1245                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1246                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1247                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process310

;-1248                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process311

;-1249                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1250                         disp -= 2;

 sub  word[disp], 2

;-1251                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1252                     }


;-1253                     else {

 jmp .process312
.process311:

;-1254                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1255                         disp -= 3;

 sub  word[disp], 3

;-1256                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1257                     }


;-1258                 }

.process312:

;-1259                 else {

 jmp .process313
.process310:

;-1260                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1261                     disp -= 3;

 sub  word[disp], 3

;-1262                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1263                 }


;-1264             }

.process313:

;-1265             else {//jump forward, near only

 jmp .process314
.process309:

;-1266                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1267                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1268                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1269                 storeJmpCall();

 call storeJmpCall

;-1270             }


;-1271         return;

.process314:
 jmp .retnprocess

;-1272         }


;-1273     }

.process308:

;-1274 


;-1275     if (CodeType ==  8) {//ret,retf

.process307:
 mov al, [CodeType]
 cmp al, 8
 jne .process315

;-1276         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process316

;-1277             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1278             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1279             return;

 jmp .retnprocess

;-1280         }


;-1281         genCode8(Code1);

.process316:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1282         return;

 jmp .retnprocess

;-1283     }


;-1284 


;-1285     if (CodeType == 9) {//push, pop

.process315:
 mov al, [CodeType]
 cmp al, 9
 jne .process317

;-1286         getOpL();

 call getOpL

;-1287         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process318

;-1288             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process319

;-1289                 setsflag();

 call setsflag

;-1290                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1291                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process320
 push word [imme]
 call genCode8
 add  sp, 2

;-1292                 else       genCode16(imme);

 jmp .process321
.process320:
 push word [imme]
 call genCode16
 add  sp, 2

;-1293                 return;

.process321:
 jmp .retnprocess

;-1294             }


;-1295             if (Op == ADR) {//push string ABSOLUTE i16

.process319:
 mov al, [Op]
 cmp al, 3
 jne .process322

;-1296                 if (disp) {

 mov ax, [disp]
 or  al, al
 je .process323

;-1297                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1298                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1299                     return;

 jmp .retnprocess

;-1300                 }


;-1301                 else {

 jmp .process324
.process323:

;-1302                     genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1303                     genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1304                     PrintRA='A';

 mov ax, 65
 mov byte [PrintRA], al

;-1305 //todo store Adr of push code, as storeJmpCall


;-1306 


;-1307                 }


;-1308             }

.process324:

;-1309         }

.process322:

;-1310         if (R1Type == SEGREG) {

.process318:
 mov al, [R1Type]
 cmp al, 4
 jne .process325

;-1311             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process326

;-1312                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process327
 push process_0
 call error1
 add  sp, 2

;-1313             }

.process327:

;-1314             c = R1No <<3;

.process326:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1315             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process328

;-1316                 c += 122;

 add  byte[bp-2], 122

;-1317                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1318             }


;-1319             OpCodePtr++;

.process328:
 inc  word[OpCodePtr]

;-1320             c = c + *OpCodePtr;//is Code4

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov [bp-2], al

;-1321             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1322             return;

 jmp .retnprocess

;-1323         }


;-1324         checkOpL();//no ADR, SEGREG

.process325:
 call checkOpL

;-1325         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne .process329
 call reg16error

;-1326         if (R1Type == WORD) {

.process329:
 mov al, [R1Type]
 cmp al, 2
 jne .process330

;-1327             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1328             return;

 jmp .retnprocess

;-1329         }


;-1330         if (Op == MEM) {

.process330:
 mov al, [Op]
 cmp al, 4
 jne .process331

;-1331             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1332             writeEA(Code3);

 mov al, byte [Code3]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1333             return;

 jmp .retnprocess

;-1334         }


;-1335         syntaxerror();

.process331:
 call syntaxerror

;-1336         return;

 jmp .retnprocess

;-1337     }


;-1338 


;-1339     if (CodeType == 11) {//shift, rotate

.process317:
 mov al, [CodeType]
 cmp al, 11
 jne .process332

;-1340         check2Ops();

 call check2Ops

;-1341         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process333

;-1342             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process334

;-1343                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1344                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1345                 return;

 jmp .retnprocess

;-1346             }


;-1347             genCodeW(0xC0);//80186

.process334:
 push 192
 call genCodeW
 add  sp, 2

;-1348             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1349             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1350             return;

 jmp .retnprocess

;-1351         }


;-1352         if (Op2 == REG) {

.process333:
 mov al, [Op2]
 cmp al, 2
 jne .process335

;-1353             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process336

;-1354                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process337

;-1355                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process338
 mov ax, 1
 mov byte [wflag], al

;-1356                     genCodeW(0xD2);

.process338:
 push 210
 call genCodeW
 add  sp, 2

;-1357                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1358                     return;

 jmp .retnprocess

;-1359                 }


;-1360             }

.process337:

;-1361         }

.process336:

;-1362     }

.process335:

;-1363 


;-1364     if (CodeType == 12) {//int

.process332:
 mov al, [CodeType]
 cmp al, 12
 jne .process339

;-1365         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process340

;-1366             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1367             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1368             return;

 jmp .retnprocess

;-1369         }


;-1370     }

.process340:

;-1371 


;-1372     if (CodeType == 30) {//enter i18,i8

.process339:
 mov al, [CodeType]
 cmp al, 30
 jne .process341

;-1373         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1374         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1375         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process342
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1376         else numbererror();

 jmp .process343
.process342:
 call numbererror

;-1377         need(',');

.process343:
 push 44
 call need
 add  sp, 2

;-1378         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1379         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process344
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1380         else numbererror();

 jmp .process345
.process344:
 call numbererror

;-1381         return;

.process345:
 jmp .retnprocess

;-1382     }


;-1383 


;-1384     if (CodeType==101) {//ORG nn

.process341:
 mov al, [CodeType]
 cmp al, 101
 jne .process346

;-1385         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process347
 call numbererror

;-1386         Origin=SymbolInt;

.process347:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1387         return;

 jmp .retnprocess

;-1388     }


;-1389 


;-1390     if (CodeType == 102) {//section, segment

.process346:
 mov al, [CodeType]
 cmp al, 102
 jne .process348

;-1391         //getTokeType();//ignore .bss .text .data


;-1392         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1393         return;

 jmp .retnprocess

;-1394     }


;-1395 


;-1396     if (CodeType == 110) {//absolute

.process348:
 mov al, [CodeType]
 cmp al, 110
 jne .process349

;-1397         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process350
 call numbererror

;-1398         AbsoluteLab=SymbolInt;

.process350:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1399         return;

 jmp .retnprocess

;-1400     }


;-1401     if (CodeType == 111) {//name: PROC

.process349:
 mov al, [CodeType]
 cmp al, 111
 jne .process351

;-1402         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process352

;-1403           prs("\n;entering: ");

 push process_1
 call prs
 add  sp, 2

;-1404           prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1405           isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1406           locLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [locLabelNamePtr], ax

;-1407           localLabelMaxIx = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [localLabelMaxIx], ax

;-1408           locStrAdrIx = 0;  //push string is local to proc

 mov ax, 0
 mov word [locStrAdrIx], ax

;-1409 


;-1410         } else error1("already in proc");

 jmp .process353
.process352:
 push process_2
 call error1
 add  sp, 2

;-1411         return;

.process353:
 jmp .retnprocess

;-1412     }


;-1413     if (CodeType == 112) {//ENDP

.process351:
 mov al, [CodeType]
 cmp al, 112
 jne .process354

;-1414       prs("\n;leaving: ");

 push process_3
 call prs
 add  sp, 2

;-1415       prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1416       isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1417       i = LabelMaxIx - localLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [localLabelMaxIx]
 mov [bp-4], ax

;-1418       prs(". # local labels :");

 push process_4
 call prs
 add  sp, 2

;-1419       printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1420       prs(". local strings to push :");

 push process_5
 call prs
 add  sp, 2

;-1421       printIntU(locStrAdrIx);

 push word [locStrAdrIx]
 call printIntU
 add  sp, 2

;-1422 // 1. close push string


;-1423 


;-1424 // 2. close open call/jmp


;-1425 // 3. delete all local labels


;-1426       return;

 jmp .retnprocess

;-1427     }


;-1428     error1("Command not implemented or syntax error");

.process354:
 push process_6
 call error1
 add  sp, 2

;-1429 }

 .retnprocess: LEAVE
 ret
process_0 db "pop cs not allowed",0
process_1 db "\n;entering: ",0
process_2 db "already in proc",0
process_3 db "\n;leaving: ",0
process_4 db ". # local labels :",0
process_5 db ". local strings to push :",0
process_6 db "Command not implemented or syntax error",0
ENDP
 
; missing functions: 
; Number of unresolved CALLs :    0 All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width  adr used name   list of global variables

;    1 arr sign byte     1    2 Version1[9]
;    2 def unsg byte     3    - SYMBOLMAX=31
;    3 arr sign byte     4   12 Symbol[31]
;    4 arr sign byte     5   36 SymbolUpper[31]
;    5 arr sign byte     6    3 ProcName[31]
;    6 var sign byte     7    5 isInProc
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
;   56 var sign word    58   51 disp
;   57 var unsg word    59   13 imme
;   58 def unsg byte    61    - OPMAXLEN=5
;   59 arr sign byte    62    2 OpPos[5]
;   60 var sign word    63    6 OpPrintIndex
;   61 ptr sign byte    64   19 OpCodePtr
;   62 var sign byte    65    5 PrintRA
;   63 def unsg byte    67    - LABELNAMESMAX=3969
;   64 arr sign byte    68    3 LabelNames[4000]
;   65 ptr sign byte    69    6 LabelNamePtr
;   66 var unsg word    70    1 locLabelNamePtr
;   67 def unsg byte    71    - LABELADRMAX=600
;   68 arr unsg word    72    7 LabelAddr[600]
;   69 var sign word    73    9 LabelMaxIx
;   70 var sign word    74    2 localLabelMaxIx
;   71 var sign word    75   10 LabelIx
;   72 var sign word    76    2 locStrAdrIx
;   73 arr unsg word    77 NULL locStrAdr[100]
;   74 def unsg byte    79    - JMPCALLNAMESMAX=1969
;   75 arr sign byte    80    3 JmpCallNames[2000]
;   76 ptr sign byte    81    5 JmpCallNamePtr
;   77 def unsg byte    82    - JMPCALLMAX=500
;   78 arr unsg word    83    2 JmpCallAddr[500]
;   79 var sign word    84    6 JmpCallMaxIx
;   80 def unsg byte    86    - FILEBINMAX=20000
;   81 arr sign byte    87    4 FileBin[20000]
;   82 var unsg word    88    6 BinLen
;   83 ptr sign byte    90    1 arglen
;   84 ptr sign byte    91    4 argv
;   85 var sign byte    95    1 I_START
;   86 arr sign byte    98 NULL I_PUSHA[3584]
;   87 arr sign byte    99 NULL I_NOP[27]
;   88 arr sign byte   100 NULL I_CWDE[1550]
;   89 arr sign byte   101 NULL I_CDQ[1542]
;   90 arr sign byte   102 NULL I_PUSHF[26118]
;   91 arr sign byte   103 NULL I_SAHF[15462]
;   92 arr sign byte   104 NULL I_MOVSB[0]
;   93 arr sign byte   105 NULL I_CMPSB[6156]
;   94 arr sign byte   106 NULL I_STOSB[48]
;   95 arr sign byte   107 NULL I_LODSB[28024]
;   96 arr sign byte   108 NULL I_SCASB[26977]
;   97 arr sign byte   109 NULL I_LEAVE[110]
;   98 arr sign byte   110 NULL I_INTO[13644]
;   99 arr sign byte   111 NULL I_XLAT[19456]
;  100 arr sign byte   112 NULL I_REPNE[54]
;  101 arr sign byte   113 NULL I_REPE[14156]
;  102 arr sign byte   114 NULL I_HLT[19456]
;  103 arr sign byte   115 NULL I_STC[56]
;  104 arr sign byte   116 NULL I_STI[14412]
;  105 arr sign byte   117 NULL I_STD[19456]
;  106 arr sign byte   119 NULL I_INC[57]
;  107 arr sign byte   120 NULL I_DEC[14668]
;  108 arr sign byte   121 NULL I_NOT[0]
;  109 arr sign byte   122 NULL I_NEG[50812]
;  110 arr sign byte   123 NULL I_MUL[50886]
;  111 arr sign byte   124 NULL I_IMUL[31942]
;  112 arr sign byte   125 NULL I_DIV[0]
;  113 arr sign byte   126 NULL I_IDIV[0]
;  114 arr sign byte   128 NULL I_LES[6156]
;  115 arr sign byte   129 NULL I_LDS[48]
;  116 arr sign byte   130 NULL I_LEA[52428]
;  117 arr sign byte   131 NULL I_LSS[52428]
;  118 arr sign byte   132 NULL I_LFS[30412]
;  119 arr sign byte   133 NULL I_LGS[0]
;  120 arr sign byte   135 NULL I_ADD[0]
;  121 arr sign byte   136 NULL I_OR[30208]
;  122 arr sign byte   137 NULL I_ADC[220]
;  123 arr sign byte   138 NULL I_SBB[26332]
;  124 arr sign byte   139 NULL I_AND[26214]
;  125 arr sign byte   140 NULL I_SUB[26214]
;  126 arr sign byte   141 NULL I_XOR[0]
;  127 arr sign byte   142 NULL I_CMP[56438]
;  128 arr sign byte   143 NULL I_TEST[50688]
;  129 arr sign byte   145 NULL I_MOV[63206]
;  130 arr sign byte   146 NULL I_MOVSX[57086]
;  131 arr sign byte   147 NULL I_MOVZX[50894]
;  132 arr sign byte   149 NULL I_JO[50886]
;  133 arr sign byte   150 NULL I_JNO[0]
;  134 arr sign byte   151 NULL I_JB[31942]
;  135 arr sign byte   152 NULL I_JNB[15360]
;  136 arr sign byte   153 NULL I_JAE[49766]
;  137 arr sign byte   154 NULL I_JE[49344]
;  138 arr sign byte   155 NULL I_JNE[50910]
;  139 arr sign byte   156 NULL I_JBE[14950]
;  140 arr sign byte   157 NULL I_JA[0]
;  141 arr sign byte   158 NULL I_JS[0]
;  142 arr sign byte   159 NULL I_JNS[50688]
;  143 arr sign byte   160 NULL I_JP[124]
;  144 arr sign byte   161 NULL I_JNP[52342]
;  145 arr sign byte   162 NULL I_JL[52428]
;  146 arr sign byte   163 NULL I_JNL[31948]
;  147 arr sign byte   164 NULL I_JLE[30732]
;  148 arr sign byte   165 NULL I_JG[27704]
;  149 arr sign byte   167 NULL I_JMP[50688]
;  150 arr sign byte   168 NULL I_CALL[50886]
;  151 arr sign byte   170 NULL I_RET[50942]
;  152 arr sign byte   171 NULL I_RETF[50886]
;  153 arr sign byte   173 NULL I_PUSH[50886]
;  154 arr sign byte   174 NULL I_POP[0]
;  155 arr sign byte   176 NULL I_ROL[27704]
;  156 arr sign byte   177 NULL I_RCL[57344]
;  157 arr sign byte   178 NULL I_SHL[24672]
;  158 arr sign byte   179 NULL I_SHR[30316]
;  159 arr sign byte   181 NULL I_INT[26214]
;  160 arr sign byte   183 NULL I_IN[58982]
;  161 arr sign byte   184 NULL I_INSB[0]
;  162 arr sign byte   185 NULL I_INSW[0]
;  163 arr sign byte   186 NULL I_INSD[0]
;  164 arr sign byte   187 NULL I_OUT[0]
;  165 arr sign byte   188 NULL I_OUTSB[0]
;  166 arr sign byte   189 NULL I_OUTSW[0]
;  167 arr sign byte   190 NULL I_OUTSD[0]
;  168 arr sign byte   192 NULL I_XCHG[0]
;  169 arr sign byte   194 NULL I_LOOPNZ[24576]
;  170 arr sign byte   195 NULL I_LOOPNE[25568]
;  171 arr sign byte   196 NULL I_LOOPZ[27750]
;  172 arr sign byte   197 NULL I_LOOPE[12312]
;  173 arr sign byte   198 NULL I_LOOP[50030]
;  174 arr sign byte   199 NULL I_JCXZ[3078]
;  175 arr sign byte   200 NULL I_JECXZ[31]
;  176 arr sign byte   202 NULL I_ENTER[13852]
;  177 arr sign byte   204 NULL I_ORG[7680]
;  178 arr sign byte   206 NULL I_SECTION[3084]
;  179 arr sign byte   207 NULL I_SEGMENT[3084]
;  180 arr sign byte   208 NULL I_ABSOLUTE[52236]
;  181 arr sign byte   209 NULL I_PROC[30924]
;  182 arr sign byte   210 NULL I_ENDP[0]
;  183 arr sign byte   211 NULL I_DB[0]
;  184 arr sign byte   212 NULL I_DW[0]
;  185 arr sign byte   213 NULL I_DD[0]
;  186 arr sign byte   214 NULL I_RESB[50812]
;  187 arr sign byte   215 NULL I_RESW[7280]
;  188 arr sign byte   216 NULL I_RESD[31942]
;  189 var sign byte   217 NULL I_END


;   # Calls Line Width  Name   list of functions

;    0    2  219   lookCode
;    1    2  236   ChangeDirection
;    2    2  244   checkOpL
;    3    4  253   check2Ops
;    4    1  262   get2Ops
;    5    3  268   getOpL
;    6    2  276   getOpR
;    7    4  286   getOp1
;    8    1  303   getMEM
;    9    1  329   getIndReg1
;   10    1  337   getIndReg2
;   11    2  347   setwflag
;   12    2  358   setsflag
;   13    2  368   checkConstSize
;   14    1  376   parse
;   15   16  412   getTokeType
;   16    2  423   storeJmpCall
;   17    2  434   storeLabel
;   18    5  446   searchLabel
;   19    1  459   getVariable
;   20    1  512   getCodeSize
;   21    9  520   isToken
;   22    2  528   need
;   23    1  537   skipRest
;   24    4  544   writetty
;   25    1  545   putch
;   26    8  546   cputs
;   27    6  548   DosInt
;   28    1  553   openR
;   29    2  554   creatR
;   30    3  555   fcloseR
;   31    5  556   exitR
;   32    2  557   readRL
;   33    2  558   fputcR
;   34    1  561   getLine
;   35    1  577   ifEOL
;   36    3  586   skipBlank
;   37    2  591   letterE
;   38    1  601   alnumE
;   39    3  606   digit
;   40    4  611   strlen
;   41    9  616   strcpy
;   42   35  622   eqstr
;   43    3  631   strcat1
;   44    2  635   toupper
;   45    1  642   getDigit
;   46    1  654   getName
;   47    1  673   testReg
;   48    1  717   printLine
;   49    7  739   prc
;   50    1  749   prscomment
;   51   34  757   prs
;   52    3  779   printhex8a
;   53    2  784   printhex4
;   54    1  789   printhex16
;   55    7  794   printIntU
;   56   27  805   error1
;   57   13  812   errorexit
;   58    2  817   notfounderror
;   59 NULL  818   allowederror
;   60    3  819   addrerror
;   61    1  820   immeerror
;   62    2  821   implerror
;   63    4  822   indexerror
;   64    3  823   invaloperror
;   65    6  824   numbererror
;   66    1  825   regmemerror
;   67    3  826   reg16error
;   68    1  827   segregerror
;   69    5  828   syntaxerror
;   70 NULL  830   addrexit
;   71    3  831   dataexit
;   72 NULL  832   internexit
;   73 NULL  836   main
;   74    1  844   getarg
;   75    1  878   fixJmpCall
;   76    2  909   epilog
;   77    2  957   end1
;   78    1  967   getCodes
;   79    1  972   gen66h
;   80    8  974   genCode2
;   81   13  978   genCodeW
;   82   35  982   genCode8
;   83   19  993   genCode16
;   84    1  997   genCode32
;   85   13 1001   writeEA
;   86    4 1043   genImmediate
;   87    1 1050   process
;   88 NULL 1429   LastFunctionByt

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
;  205  1657 fixJmpCall
;  206  1668 epilog
;  207  1675 end1
;  208  1680 cputs
;  209  1686 cputs
;  210  1692 exitR
;  211  1698 toupper
;  212  1706 strcpy
;  213  1713 strcat1
;  214  1721 strcpy
;  215  1728 strcat1
;  216  1736 strcpy
;  217  1743 strcat1
;  218  1751 openR
;  219  1757 cputs
;  220  1763 cputs
;  221  1769 exitR
;  222  1775 creatR
;  223  1782 cputs
;  224  1788 cputs
;  225  1794 exitR
;  226  1800 creatR
;  227  1807 cputs
;  228  1813 cputs
;  229  1819 exitR
;  230  1825 prs
;  231  1829 prs
;  232  1833 prs
;  233  1837 prs
;  234  1841 prs
;  235  1845 prs
;  236  1849 prs
;  237  1853 prs
;  238  1857 prs
;  239  1861 prs
;  240  1865 printIntU
;  241  1875 strcpy
;  242  1882 strlen
;  243  1889 searchLabel
;  244  1901 error1
;  245  1908 prs
;  246  1912 printIntU
;  247  1922 prs
;  248  1926 prs
;  249  1930 prs
;  250  1934 prs
;  251  1938 prs
;  252  1942 prs
;  253  1946 printIntU
;  254  1956 prs
;  255  1960 fputcR
;  256  1967 prs
;  257  1971 printIntU
;  258  1981 prs
;  259  1985 fcloseR
;  260  1993 fcloseR
;  261  2001 fcloseR
;  262  2009 exitR
;  263  2015 genCode8
;  264  2024 genCode8
;  265  2033 genCode8
;  266  2042 errorexit
;  267  2052 genCode8
;  268  2061 genCode8
;  269  2070 genCode16
;  270  2080 genCode16
;  271  2090 genCode8
;  272  2099 genCode8
;  273  2108 genCode16
;  274  2118 genCode32
;  275  2128 genCode16
;  276  2138 genCode8
;  277  2147 getTokeType
;  278  2159 getCodeSize
;  279  2171 getCodes
;  280  2180 genCode8
;  281  2189 getOpL
;  282  2196 checkOpL
;  283  2205 genCode2
;  284  2214 getTokeType
;  285  2226 implerror
;  286  2236 genCodeW
;  287  2245 writeEA
;  288  2253 check2Ops
;  289  2263 reg16error
;  290  2274 addrerror
;  291  2284 genCode8
;  292  2293 genCode8
;  293  2302 writeEA
;  294  2310 check2Ops
;  295  2320 setsflag
;  296  2329 genCodeW
;  297  2338 genImmediate
;  298  2351 genCodeW
;  299  2360 writeEA
;  300  2368 genCode8
;  301  2377 genImmediate
;  302  2390 genCodeW
;  303  2399 writeEA
;  304  2407 genCodeW
;  305  2416 writeEA
;  306  2424 syntaxerror
;  307  2436 check2Ops
;  308  2446 notfounderror
;  309  2460 genCode2
;  310  2469 genImmediate
;  311  2482 genCodeW
;  312  2491 writeEA
;  313  2499 genImmediate
;  314  2512 regmemerror
;  315  2524 ChangeDirection
;  316  2540 reg16error
;  317  2551 genCode2
;  318  2560 writeEA
;  319  2568 genCodeW
;  320  2577 genCode16
;  321  2587 genCodeW
;  322  2596 genCode16
;  323  2606 genCodeW
;  324  2615 writeEA
;  325  2623 ChangeDirection
;  326  2639 genCodeW
;  327  2648 writeEA
;  328  2656 syntaxerror
;  329  2668 searchLabel
;  330  2680 checkConstSize
;  331  2695 genCode2
;  332  2704 genCode8
;  333  2713 genCode8
;  334  2722 genCode2
;  335  2731 genCode16
;  336  2741 genCode8
;  337  2750 genCode2
;  338  2759 genCode16
;  339  2769 storeJmpCall
;  340  2782 searchLabel
;  341  2794 checkConstSize
;  342  2809 genCode8
;  343  2818 genCode8
;  344  2827 genCode8
;  345  2836 genCode16
;  346  2846 genCode8
;  347  2855 genCode16
;  348  2865 genCode8
;  349  2874 genCode16
;  350  2884 storeJmpCall
;  351  2897 genCode8
;  352  2906 genCode16
;  353  2916 genCode8
;  354  2925 getOpL
;  355  2932 setsflag
;  356  2941 genCode2
;  357  2950 genCode8
;  358  2959 genCode16
;  359  2969 genCode8
;  360  2978 genCode16
;  361  2988 genCode8
;  362  2997 genCode16
;  363  3007 error1
;  364  3014 genCode8
;  365  3023 genCode8
;  366  3032 checkOpL
;  367  3041 reg16error
;  368  3052 genCode2
;  369  3061 genCode8
;  370  3070 writeEA
;  371  3078 syntaxerror
;  372  3090 check2Ops
;  373  3100 genCodeW
;  374  3109 writeEA
;  375  3117 genCodeW
;  376  3126 writeEA
;  377  3134 genCode8
;  378  3143 genCodeW
;  379  3152 writeEA
;  380  3160 genCode8
;  381  3169 genCode8
;  382  3178 genCode8
;  383  3187 getOp1
;  384  3194 genCode16
;  385  3204 numbererror
;  386  3216 need
;  387  3221 getOp1
;  388  3228 genCode8
;  389  3237 numbererror
;  390  3249 numbererror
;  391  3261 numbererror
;  392  3273 prs
;  393  3277 prs
;  394  3281 error1
;  395  3288 prs
;  396  3292 prs
;  397  3296 prs
;  398  3300 printIntU
;  399  3310 prs
;  400  3314 printIntU
;  401  3324 error1
;Input: AS.C, List: AS.S,  Lines: 1430
;Glob. variables:  189 max.:  200
;Functions      :   89 max.:  300
;Calls          :  402 max.: 2000, NameField: 3331 max.:    65535
;Code until     :21667 max.: 30000, free: 8333
;Data (HeapEnd) :58954, resting stacksize:  6581
;Max. Const in 'testReg' :  658 max. 3000, free: 2342