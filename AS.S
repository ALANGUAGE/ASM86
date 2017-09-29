
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

;-76 


;-77 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX


;-78 char JmpCallNames[2000];//space for names of jmp, call

section .bss
absolute 35754
JmpCallNames resb 2000
section .text

;-79 char *JmpCallNamePtr;   //first free position

JmpCallNamePtr dw 0

;-80 #define JMPCALLMAX 500  //max. jmp and call


;-81 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed

section .bss
absolute 37754
JmpCallAddr resw 500
section .text

;-82 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1

JmpCallMaxIx dw 0

;-83 


;-84 #define FILEBINMAX 20000


;-85 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 38754
FileBin resb 20000
section .text

;-86 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-87 


;-88 char *arglen=0x80;      // for main only

arglen dw 128

;-89 char *argv=0x82;        // for main only

argv dw 130

;-90 


;-91 


;-92 //#include "OPTABL.C"


;-93 char I_START=0xF1;

I_START db 241

;-94 //OpName, 0, CodeType, OpCode1-n, F1h


;-95 //  1:   1 byte opcode


;-96 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};

I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241

;-97 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};

I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241

;-98 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};

I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241

;-99 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};

I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241

;-100 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};

I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241

;-101 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};

I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241

;-102 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};

I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241

;-103 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};

I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241

;-104 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};

I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241

;-105 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};

I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241

;-106 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};

I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241

;-107 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};

I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241

;-108 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};

I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241

;-109 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};

I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241

;-110 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241

;-111 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};

I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241

;-112 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};

I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241

;-113 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};

I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241

;-114 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};

I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241

;-115 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};

I_STD db 83,84,68,0,1,253,241

;-116 // 2: mem reg 16 bit


;-117 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-118 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-119 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-120 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-121 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-122 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-123 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-124 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-125 //  3: les, lda, lea, lss, lfs, lgs


;-126 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-127 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-128 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-129 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-130 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-131 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-132 //  4: acc,imm  reg,imm  index,reg


;-133 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-134 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-135 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-136 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-137 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-138 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-139 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-140 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-141 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-142 //  5: mov


;-143 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-144 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-145 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-146 //  6: single byte relative jump


;-147 char I_JO []=  {'J','O',0,     6, 0,0xF1};

I_JO db 74,79,0,6,0,241

;-148 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};

I_JNO db 74,78,79,0,6,1,241

;-149 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};

I_JB db 74,66,0,6,2,241,74,67,0,6,2,241

;-150 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};

I_JNB db 74,78,66,0,6,3,241

;-151 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};

I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241

;-152 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};

I_JE db 74,69,0,6,4,241,74,90,0,6,4,241

;-153 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};

I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241

;-154 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};

I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241

;-155 char I_JA []=  {'J','A',0,     6, 7,0xF1};

I_JA db 74,65,0,6,7,241

;-156 char I_JS []=  {'J','S',0,     6, 8,0xF1};

I_JS db 74,83,0,6,8,241

;-157 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};

I_JNS db 74,78,83,0,6,9,241

;-158 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};

I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241

;-159 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};

I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241

;-160 char I_JL []=  {'J','L',0,     6,12,0xF1};

I_JL db 74,76,0,6,12,241

;-161 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};

I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241

;-162 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};

I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241

;-163 char I_JG []=  {'J','G',0,     6,15,0xF1};

I_JG db 74,71,0,6,15,241

;-164 //  7: jmp, call


;-165 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-166 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-167 //  8: ret


;-168 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-169 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-170 //  9: seg, r/m


;-171 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,255,6,6,241

;-172 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16

I_POP db 80,79,80,0,9,88,143,0,7,241

;-173 //  11: shift, rotates


;-174 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};

I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241

;-175 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};

I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241

;-176 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};

I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241

;-177 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};

I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241

;-178 //  12: int


;-179 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-180 //  14: in/out


;-181 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-182 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-183 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-184 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-185 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-186 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-187 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-188 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

;-189 //  15: xchg


;-190 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-191 //  16: loop, jcxz


;-192 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-193 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-194 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-195 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-196 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-197 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-198 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-199 //  30: enter


;-200 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-201 // 100: directives


;-202 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-203 // section, segment .TEXT .DATA .BSS


;-204 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-205 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-206 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-207 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};

I_PROC db 80,82,79,67,0,111,241

;-208 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};

I_ENDP db 69,78,68,80,0,112,241

;-209 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-210 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-211 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-212 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-213 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-214 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

;-215 char I_END=0;// end of table char

I_END db 0

;-216 


;-217 


;-218 //#include "OPS.C"


;-219 int ChangeDirection() {


ChangeDirection: PROC

;-220     char c;


;-221     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   220 NULL c = bp-2;
 ENTER  2,0
 mov al, [Op]
 mov [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-222     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-223     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-224     dflag=2;

 mov ax, 2
 mov byte [dflag], al

;-225 }


;-226 


;-227 int checkOpL() {
 LEAVE
 ret
ENDP

checkOpL: PROC

;-228     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne .checkOpL1
 call implerror

;-229     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

.checkOpL1:
 mov al, [R1Type]
 cmp al, 4
 jne .checkOpL2
 call segregerror
 jmp .retncheckOpL

;-230     setwflag();

.checkOpL2:
 call setwflag

;-231     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne .checkOpL3
 push checkOpL_0
 call error1
 add  sp, 2

;-232     if (OpSize == R1Type) return;

.checkOpL3:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne .checkOpL4
 jmp .retncheckOpL

;-233     if (Op == REG) if (R1Type==0) error1("no register defined");

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

;-234 }

.checkOpL6:
.checkOpL5:

;-235 


;-236 int check2Ops() {

 .retncheckOpL:
 ret
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0
ENDP

check2Ops: PROC

;-237     get2Ops();

 call get2Ops

;-238     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne .check2Ops7
 call addrerror

;-239     if (Op == ADR) invaloperror();

.check2Ops7:
 mov al, [Op]
 cmp al, 3
 jne .check2Ops8
 call invaloperror

;-240     if (Op == IMM) immeerror();

.check2Ops8:
 mov al, [Op]
 cmp al, 1
 jne .check2Ops9
 call immeerror

;-241     if (Op2==   0) addrerror();

.check2Ops9:
 mov al, [Op2]
 cmp al, 0
 jne .check2Ops10
 call addrerror

;-242     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov

.check2Ops10:
 mov al, [CodeType]
 cmp al, 5
 je  .check2Ops11
 mov al, [Op2]
 cmp al, 3
 jne .check2Ops12
 call invaloperror

;-243     setwflag();

.check2Ops12:
.check2Ops11:
 call setwflag

;-244 }


;-245 int get2Ops() {

 ret
ENDP

get2Ops: PROC

;-246     getOpL();

 call getOpL

;-247     need(',');

 push 44
 call need
 add  sp, 2

;-248     getOpR();

 call getOpR

;-249 }


;-250 


;-251 int getOpL() {

 ret
ENDP

getOpL: PROC

;-252 //set: op=0,IMM,REG,ADR,MEM


;-253     getOpR();

 call getOpR

;-254     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov ax, 0
 mov byte [Op2], al

;-255     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov ax, 0
 mov byte [R2No], al

;-256     R1Type=R2Type; R2Type=0;

 mov al, [R2Type]
 mov byte [R1Type], al
 mov ax, 0
 mov byte [R2Type], al

;-257 }


;-258 


;-259 int getOpR() {

 ret
ENDP

getOpR: PROC

;-260     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-261     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je .getOpR13
 mov ax, 4
 mov byte [Op2], al
 call getMEM
 jmp .retngetOpR

;-262     if (Op2 == 0)     {invaloperror();         return;}

.getOpR13:
 mov al, [Op2]
 cmp al, 0
 jne .getOpR14
 call invaloperror
 jmp .retngetOpR

;-263     if (Op2 == IMM)   {imme=SymbolInt;         return;}

.getOpR14:
 mov al, [Op2]
 cmp al, 1
 jne .getOpR15
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp .retngetOpR

;-264     if (Op2 == REG)                            return;

.getOpR15:
 mov al, [Op2]
 cmp al, 2
 jne .getOpR16
 jmp .retngetOpR

;-265     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}

.getOpR16:
 mov al, [Op2]
 cmp al, 3
 jne .getOpR17
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp .retngetOpR

;-266     error1("Name of operand expected");

.getOpR17:
 push getOpR_0
 call error1
 add  sp, 2

;-267 }


;-268 


;-269 int getOp1() {//scan for a single operand

 .retngetOpR:
 ret
getOpR_0 db "Name of operand expected",0
ENDP

getOp1: PROC

;-270 //return:0, IMM, REG, ADR (not MEM)


;-271 //set   :R2Type, R2No by testReg


;-272 //set   :LabelIx by searchLabel


;-273     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne .getOp118
 mov ax, 0
 jmp .retngetOp1

;-274     if (TokeType == DIGIT)  return IMM;

.getOp118:
 mov al, [TokeType]
 cmp al, 1
 jne .getOp119
 mov ax, 1
 jmp .retngetOp1

;-275     if (TokeType == ALNUME) {

.getOp119:
 mov al, [TokeType]
 cmp al, 3
 jne .getOp120

;-276         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-277         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je .getOp121
 mov ax, 2
 jmp .retngetOp1

;-278         LabelIx=searchLabel();

.getOp121:
 call searchLabel
 mov word [LabelIx], ax

;-279         if (LabelIx)        return ADR;

 mov ax, [LabelIx]
 or  al, al
 je .getOp122
 mov ax, 3
 jmp .retngetOp1

;-280         else error1("variable not found");

 jmp .getOp123
.getOp122:
 push getOp1_0
 call error1
 add  sp, 2

;-281     }

.getOp123:

;-282     return 0;

.getOp120:
 mov ax, 0
 jmp .retngetOp1

;-283 }


;-284 


;-285 int getMEM() {// e.g. [array+bp+si-4]

 .retngetOp1:
 ret
getOp1_0 db "variable not found",0
ENDP

getMEM: PROC

;-286 //set: disp, rm, R2Type


;-287     char c;


;-288     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   287 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [disp], ax
 mov ax, 0
 mov byte [rm], al

;-289     do {

.getMEM24:

;-290         getTokeType();

 call getTokeType

;-291         c=getOp1();

 call getOp1
 mov [bp-2], al

;-292         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne .getMEM25
 call syntaxerror

;-293         if (c == REG) {

.getMEM25:
 mov al, [bp-2]
 cmp al, 2
 jne .getMEM26

;-294             isDirect=0;

 mov ax, 0
 mov byte [isDirect], al

;-295             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je .getMEM27
 call getIndReg2
 mov byte [rm], al

;-296             else getIndReg1();

 jmp .getMEM28
.getMEM27:
 call getIndReg1

;-297         }

.getMEM28:

;-298         if (c == ADR) disp=disp+LabelAddr[LabelIx];

.getMEM26:
 mov al, [bp-2]
 cmp al, 3
 jne .getMEM29
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-299         if (c == IMM) disp=disp+SymbolInt;

.getMEM29:
 mov al, [bp-2]
 cmp al, 1
 jne .getMEM30
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-300         if (isToken('-')) {

.getMEM30:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM31

;-301             getTokeType();

 call getTokeType

;-302             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .getMEM32
 call numbererror

;-303             disp = disp - SymbolInt;

.getMEM32:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-304         }


;-305     } while (isToken('+'));

.getMEM31:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je .getMEM33
 jmp .getMEM24
.getMEM33:

;-306     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne .getMEM34
 push getMEM_0
 call errorexit
 add  sp, 2

;-307 }

.getMEM34:

;-308 int getIndReg1() {
 LEAVE
 ret
getMEM_0 db "] expected",0
ENDP

getIndReg1: PROC

;-309     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg135
 call indexerror

;-310     if (R2No==3) rm=7;//BX

.getIndReg135:
 mov al, [R2No]
 cmp al, 3
 jne .getIndReg136
 mov ax, 7
 mov byte [rm], al

;-311     if (R2No==5) rm=6;//BP, change to BP+0

.getIndReg136:
 mov al, [R2No]
 cmp al, 5
 jne .getIndReg137
 mov ax, 6
 mov byte [rm], al

;-312     if (R2No==7) rm=5;//DI

.getIndReg137:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg138
 mov ax, 5
 mov byte [rm], al

;-313     if (R2No==6) rm=4;//SI

.getIndReg138:
 mov al, [R2No]
 cmp al, 6
 jne .getIndReg139
 mov ax, 4
 mov byte [rm], al

;-314     if (rm==0) indexerror();

.getIndReg139:
 mov al, [rm]
 cmp al, 0
 jne .getIndReg140
 call indexerror

;-315 }

.getIndReg140:

;-316 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
ENDP

getIndReg2: PROC
;Function : getIndReg2, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   316 NULL m = bp-2;
 ENTER  2,0
 mov ax, 4
 mov [bp-2], al

;-317     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  .getIndReg241
 call indexerror

;-318     if (R2No==7) if (rm==6) m=3;//BP+DI

.getIndReg241:
 mov al, [R2No]
 cmp al, 7
 jne .getIndReg242
 mov al, [rm]
 cmp al, 6
 jne .getIndReg243
 mov ax, 3
 mov [bp-2], al

;-319              else if (rm==7) m=1;//BX+DI

 jmp .getIndReg244
.getIndReg243:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg245
 mov ax, 1
 mov [bp-2], al

;-320     if (R2No==6) if (rm==6) m=2;//BP+SI

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

;-321              else if (rm==7) m=0;//BX+SI

 jmp .getIndReg248
.getIndReg247:
 mov al, [rm]
 cmp al, 7
 jne .getIndReg249
 mov ax, 0
 mov [bp-2], al

;-322     if (m > 3) indexerror();

.getIndReg249:
.getIndReg248:
.getIndReg246:
 mov al, [bp-2]
 cmp al, 3
 jle .getIndReg250
 call indexerror

;-323     return m;

.getIndReg250:
 mov al, [bp-2]
 jmp .retngetIndReg2

;-324 }


;-325 


;-326 int setwflag() {//word size, bit 0

 .retngetIndReg2: LEAVE
 ret
ENDP

setwflag: PROC

;-327     wflag=0;

 mov ax, 0
 mov byte [wflag], al

;-328     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne .setwflag51

;-329         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne .setwflag52
 mov al, [R1Type]
 mov byte [OpSize], al

;-330         if (Op2== REG) OpSize=R2Type;

.setwflag52:
 mov al, [Op2]
 cmp al, 2
 jne .setwflag53
 mov al, [R2Type]
 mov byte [OpSize], al

;-331         if (R2Type== SEGREG) OpSize=WORD;

.setwflag53:
 mov al, [R2Type]
 cmp al, 4
 jne .setwflag54
 mov ax, 2
 mov byte [OpSize], al

;-332         if (R1Type == SEGREG) OpSize=WORD;

.setwflag54:
 mov al, [R1Type]
 cmp al, 4
 jne .setwflag55
 mov ax, 2
 mov byte [OpSize], al

;-333     }

.setwflag55:

;-334     if (OpSize  == DWORD) {gen66h(); wflag=1;}

.setwflag51:
 mov al, [OpSize]
 cmp al, 3
 jne .setwflag56
 call gen66h
 mov ax, 1
 mov byte [wflag], al

;-335     if (OpSize  ==  WORD) wflag=1;

.setwflag56:
 mov al, [OpSize]
 cmp al, 2
 jne .setwflag57
 mov ax, 1
 mov byte [wflag], al

;-336 }

.setwflag57:

;-337 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3

 ret
ENDP

setsflag: PROC

;-338     unsigned int ui;


;-339     sflag=2;

;Function : setsflag, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   338 NULL ui = bp-2;
 ENTER  2,0
 mov ax, 2
 mov byte [sflag], al

;-340     ui = imme & 0xFF80;//is greater than signed 127?

 mov ax, [imme]
 and ax, 65408
 mov [bp-2], ax

;-341     if(ui != 0) sflag = 0;

 mov ax, [bp-2]
 cmp ax, 0
 je  .setsflag58
 mov ax, 0
 mov byte [sflag], al

;-342     if (OpSize == BYTE) {

.setsflag58:
 mov al, [OpSize]
 cmp al, 1
 jne .setsflag59

;-343         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle .setsflag60
 push setsflag_0
 call error1
 add  sp, 2

;-344         sflag=0;//byte reg does not need sign extended

.setsflag60:
 mov ax, 0
 mov byte [sflag], al

;-345     }


;-346 }

.setsflag59:

;-347 int checkConstSize(unsigned int ui) {
 LEAVE
 ret
setsflag_0 db "too big for byte r/m",0
ENDP

checkConstSize: PROC

;-348     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   347 NULL ui = bp+4;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle .checkConstSize61
 mov ax, 0
 jmp .retncheckConstSize

;-349     if (ui < 0xFF80) return 0;//-128dez

.checkConstSize61:
 mov ax, [bp+4]
 cmp ax, 65408
 jge .checkConstSize62
 mov ax, 0
 jmp .retncheckConstSize

;-350     return 2;// is short

.checkConstSize62:
 mov ax, 2
 jmp .retncheckConstSize

;-351 }


;-352 


;-353 


;-354 //#include "PARSE.C"


;-355 int parse() {

 .retncheckConstSize: LEAVE
 ret
ENDP

parse: PROC

;-356     LabelNamePtr  = &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-357     JmpCallNamePtr= &JmpCallNames;

 mov ax, JmpCallNames
 mov word [JmpCallNamePtr], ax

;-358     LabelMaxIx=0;

 mov ax, 0
 mov word [LabelMaxIx], ax

;-359     JmpCallMaxIx=0;

 mov ax, 0
 mov word [JmpCallMaxIx], ax

;-360     BinLen=0;

 mov ax, 0
 mov word [BinLen], ax

;-361     isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-362 


;-363     do {//process a new line

.parse63:

;-364         PCStart=PC;

 mov ax, [PC]
 mov word [PCStart], ax

;-365         OpSize=0;

 mov ax, 0
 mov byte [OpSize], al

;-366         OpPrintIndex=0;

 mov ax, 0
 mov word [OpPrintIndex], ax

;-367         PrintRA=' ';

 mov ax, 32
 mov byte [PrintRA], al

;-368         getLine();

 call getLine

;-369         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-370         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-371         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .parse64

;-372             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je .parse65

;-373               if (isInProc == 0)  strcpy(ProcName, Symbol);

 mov al, [isInProc]
 cmp al, 0
 jne .parse66
 lea  ax, [Symbol]
 push ax
 lea  ax, [ProcName]
 push ax
 call strcpy
 add  sp, 4

;-374                 storeLabel();

.parse66:
 call storeLabel

;-375                 InputPtr++;//remove :

 inc  word[InputPtr]

;-376                 getTokeType();

 call getTokeType

;-377             }


;-378         }

.parse65:

;-379         if (TokeType == ALNUME) {

.parse64:
 mov al, [TokeType]
 cmp al, 3
 jne .parse67

;-380             lookCode();// and OpCodePtr

 call lookCode

;-381             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je .parse68
 call process

;-382             else getVariable();

 jmp .parse69
.parse68:
 call getVariable

;-383             skipRest();

.parse69:
 call skipRest

;-384         }


;-385         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp .parse70
.parse67:
 mov al, [TokeType]
 cmp al, 3
 jle .parse71
 push parse_0
 call error1
 add  sp, 2

;-386         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp .parse72
.parse71:
 mov al, [TokeType]
 cmp al, 1
 jne .parse73
 push parse_1
 call error1
 add  sp, 2

;-387         printLine();

.parse73:
.parse72:
.parse70:
 call printLine

;-388     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  .parse74
 jmp .parse63
.parse74:

;-389 }


;-390 


;-391 int getTokeType() {

 ret
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0
ENDP

getTokeType: PROC

;-392     char c;


;-393     skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   392 NULL c = bp-2;
 ENTER  2,0
 call skipBlank

;-394     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-395     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne .getTokeType75
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-396     if (c == ';') {TokeType=0; return; }//comment

.getTokeType75:
 mov al, [bp-2]
 cmp al, 59
 jne .getTokeType76
 mov ax, 0
 mov byte [TokeType], al
 jmp .retngetTokeType

;-397     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

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

;-398     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

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

;-399     TokeType=NOALNUME;

.getTokeType78:
 mov ax, 4
 mov byte [TokeType], al

;-400 }


;-401 


;-402 int storeJmpCall() {

 .retngetTokeType: LEAVE
 ret
ENDP

storeJmpCall: PROC

;-403     unsigned int i;


;-404     JmpCallMaxIx++;

;Function : storeJmpCall, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   403 NULL i = bp-2;
 ENTER  2,0
 inc  word[JmpCallMaxIx]

;-405     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");

 mov ax, [JmpCallMaxIx]
 cmp ax, 500 ;unsigned : 1
 jl  .storeJmpCall79
 push storeJmpCall_0
 call errorexit
 add  sp, 2

;-406     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);

.storeJmpCall79:
 lea  ax, [Symbol]
 push ax
 push word [JmpCallNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpCallNamePtr], ax

;-407     JmpCallNamePtr++;

 inc  word[JmpCallNamePtr]

;-408     i = JmpCallNamePtr - &JmpCallNames;

 mov ax, [JmpCallNamePtr]
 sub ax, JmpCallNames
 mov [bp-2], ax

;-409     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");

 mov ax, [bp-2]
 cmp ax, 1969 ;unsigned : 0
 jb  .storeJmpCall80
 push storeJmpCall_1
 call errorexit
 add  sp, 2

;-410     JmpCallAddr[JmpCallMaxIx] = PC;

.storeJmpCall80:
 mov ax, [PC]
 mov bx, [JmpCallMaxIx]
 shl bx, 1
 mov [JmpCallAddr+bx], ax

;-411 }


;-412 


;-413 int storeLabel() {
 LEAVE
 ret
storeJmpCall_0 db "too many JmpCalls",0
storeJmpCall_1 db "too many JmpCall names",0
ENDP

storeLabel: PROC

;-414     unsigned int i;


;-415     if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   414 NULL i = bp-2;
 ENTER  2,0
 call searchLabel
 or  al, al
 je .storeLabel81
 push storeLabel_0
 call error1
 add  sp, 2

;-416     LabelMaxIx++;

.storeLabel81:
 inc  word[LabelMaxIx]

;-417     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  .storeLabel82
 push storeLabel_1
 call errorexit
 add  sp, 2

;-418     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

.storeLabel82:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-419     LabelNamePtr++;

 inc  word[LabelNamePtr]

;-420     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov [bp-2], ax

;-421     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  .storeLabel83
 push storeLabel_2
 call errorexit
 add  sp, 2

;-422     LabelAddr[LabelMaxIx] = PC + Origin;

.storeLabel83:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-423 }


;-424 


;-425 int searchLabel() {
 LEAVE
 ret
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too many labels",0
storeLabel_2 db "too many label names",0
ENDP

searchLabel: PROC

;-426     int LIx; char *p;


;-427     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   426 NULL LIx = bp-2
;  201 ptr sign byte   426 NULL p = bp-4;
 ENTER  4,0
 mov ax, LabelNames
 mov [bp-4], ax

;-428     LIx = 1;

 mov ax, 1
 mov [bp-2], ax

;-429     while (LIx <= LabelMaxIx) {

.searchLabel84:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  .searchLabel85

;-430         if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je .searchLabel86
 mov ax, [bp-2]
 jmp .retnsearchLabel

;-431         p=strlen(p) + p;

.searchLabel86:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov [bp-4], ax

;-432         p++;

 inc  word[bp-4]

;-433         LIx++;

 inc  word[bp-2]

;-434     }


;-435     return 0;

 jmp .searchLabel84
.searchLabel85:
 mov ax, 0
 jmp .retnsearchLabel

;-436 }


;-437 


;-438 int getVariable() {

 .retnsearchLabel: LEAVE
 ret
ENDP

getVariable: PROC

;-439     char c;


;-440     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   439 NULL c = bp-2;
 ENTER  2,0
 call storeLabel

;-441     getTokeType();

 call getTokeType

;-442     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne .getVariable87

;-443         lookCode();

 call lookCode

;-444         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge .getVariable88
 call dataexit

;-445         if (CodeType > 205) dataexit();

.getVariable88:
 mov al, [CodeType]
 cmp al, 205
 jle .getVariable89
 call dataexit

;-446         if (CodeType== 200) {//DB

.getVariable89:
 mov al, [CodeType]
 cmp al, 200
 jne .getVariable90

;-447             do {

.getVariable91:

;-448                 getTokeType();

 call getTokeType

;-449                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable92
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-450                 else {

 jmp .getVariable93
.getVariable92:

;-451                     skipBlank();

 call skipBlank

;-452                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable94

;-453                         do {

.getVariable95:

;-454                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-455                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-456                             InputPtr++;

 inc  word[InputPtr]

;-457                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  .getVariable96
 jmp .getVariable95
.getVariable96:

;-458                         InputPtr++;

 inc  word[InputPtr]

;-459                     }


;-460                 }

.getVariable94:

;-461             } while (isToken(','));

.getVariable93:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable97
 jmp .getVariable91
.getVariable97:

;-462         }


;-463         if (CodeType == 201) {//DW

.getVariable90:
 mov al, [CodeType]
 cmp al, 201
 jne .getVariable98

;-464             do {

.getVariable99:

;-465                 getTokeType();

 call getTokeType

;-466                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable100
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-467             } while (isToken(','));

.getVariable100:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable101
 jmp .getVariable99
.getVariable101:

;-468         }


;-469         if (CodeType == 202) {//DD

.getVariable98:
 mov al, [CodeType]
 cmp al, 202
 jne .getVariable102

;-470             do {

.getVariable103:

;-471                 getTokeType();

 call getTokeType

;-472                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable104
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-473                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-474             } while (isToken(','));

.getVariable104:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je .getVariable105
 jmp .getVariable103
.getVariable105:

;-475         }


;-476         if (CodeType >= 203) {//resb, resw, resd

.getVariable102:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  .getVariable106

;-477             getTokeType();

 call getTokeType

;-478             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .getVariable107

;-479                 if (SymbolInt <= 0) syntaxerror();

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  .getVariable108
 call syntaxerror

;-480                 if (AbsoluteLab == 0) error1("Absolute is null");

.getVariable108:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne .getVariable109
 push getVariable_0
 call error1
 add  sp, 2

;-481                 LabelAddr[LabelMaxIx] = AbsoluteLab;

.getVariable109:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-482                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne .getVariable110
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-483                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd

.getVariable110:
 mov al, [CodeType]
 cmp al, 205
 jne .getVariable111
 mov ax, [SymbolInt]
 mov bx, 4
 mul bx
 mov word [SymbolInt], ax

;-484                 AbsoluteLab = AbsoluteLab + SymbolInt;

.getVariable111:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-485             } else numbererror();

 jmp .getVariable112
.getVariable107:
 call numbererror

;-486         }

.getVariable112:

;-487     }

.getVariable106:

;-488     else dataexit();

 jmp .getVariable113
.getVariable87:
 call dataexit

;-489 }

.getVariable113:

;-490 


;-491 int lookCode() {//ret: CodeType, *OpCodePtr
 LEAVE
 ret
getVariable_0 db "Absolute is null",0
ENDP

lookCode: PROC

;-492     CodeType=0;

 mov ax, 0
 mov byte [CodeType], al

;-493     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-494     OpCodePtr++;

 inc  word[OpCodePtr]

;-495     do  {

.lookCode114:

;-496         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .lookCode115

;-497             while(*OpCodePtr!=0) OpCodePtr++;

.lookCode116:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode117
 inc  word[OpCodePtr]

;-498             OpCodePtr++;

 jmp .lookCode116
.lookCode117:
 inc  word[OpCodePtr]

;-499             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-500             return;

 jmp .retnlookCode

;-501         }


;-502     while(*OpCodePtr!=0xF1) OpCodePtr++;

.lookCode115:
.lookCode118:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  .lookCode119
 inc  word[OpCodePtr]

;-503     OpCodePtr++;

 jmp .lookCode118
.lookCode119:
 inc  word[OpCodePtr]

;-504     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .lookCode120
 jmp .lookCode114
.lookCode120:

;-505 }


;-506 


;-507 int getCodeSize() {

 .retnlookCode:
 ret
ENDP

getCodeSize: PROC

;-508     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .getCodeSize121

;-509         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

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

;-510         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

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

;-511         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

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

;-512     }

.getCodeSize124:

;-513     return 0;

.getCodeSize121:
 mov ax, 0
 jmp .retngetCodeSize

;-514 }


;-515 int isToken(char c) {

 .retngetCodeSize:
 ret
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0
ENDP

isToken: PROC

;-516     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   515 NULL c = bp+4;
 ENTER  0,0
 call skipBlank

;-517     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne .isToken125

;-518         InputPtr++;

 inc  word[InputPtr]

;-519         return 1;

 mov ax, 1
 jmp .retnisToken

;-520         }


;-521     return 0;

.isToken125:
 mov ax, 0
 jmp .retnisToken

;-522 }


;-523 int need(char c) {

 .retnisToken: LEAVE
 ret
ENDP

need: PROC

;-524     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   523 NULL c = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je .need126

;-525         getTokeType();

 call getTokeType

;-526         return;

 jmp .retnneed

;-527         }


;-528     error1();

.need126:
 call error1

;-529     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-530     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-531 }


;-532 int skipRest() {

 .retnneed: LEAVE
 ret
need_0 db ". need: ",0
ENDP

skipRest: PROC

;-533     getTokeType();

 call getTokeType

;-534     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je .skipRest127
 push skipRest_0
 call error1
 add  sp, 2

;-535 }

.skipRest127:

;-536 


;-537 


;-538 //#include "HELPER.C"


;-539 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }

 ret
skipRest_0 db "extra char ignored",0
ENDP

writetty: PROC
 mov  ah, 14
 mov  bx, 0
 db 205,16

;-540 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
ENDP

putch: PROC
;Function : putch, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   540 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .putch128
 mov  al, 13
 call writetty
.putch128:
 mov  al, [bp+4]
 call writetty

;-541 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
ENDP

cputs: PROC
;Function : cputs, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   541 NULL s = bp+4
;  201 var sign byte   541 NULL c = bp-2;
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

;-542 


;-543 int DosInt() {
 LEAVE
 ret
ENDP

DosInt: PROC

;-544     __emit__(0xCD,0x21);//inth 0x21;

 db 205,33

;-545     __emit__(0x73, 04); //ifcarry DOS_ERR++;

 db 115,4

;-546     DOS_ERR++;

 inc  word[DOS_ERR]

;-547 }


;-548 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }

 ret
ENDP

openR: PROC
;Function : openR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   548 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-549 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
ENDP

creatR: PROC
;Function : creatR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   549 NULL s = bp+4;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-550 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
 LEAVE
 ret
ENDP

fcloseR: PROC
;Function : fcloseR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   550 NULL fd = bp+4;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 call DosInt

;-551 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
 LEAVE
 ret
ENDP

exitR: PROC
;Function : exitR, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   551 NULL c = bp+4;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 call DosInt

;-552 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
 LEAVE
 ret
ENDP

readRL: PROC
;Function : readRL, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   552 NULL s = bp+4
;  201 var sign word   552 NULL fd = bp+6
;  202 var sign word   552 NULL len = bp+8;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-553 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
ENDP

fputcR: PROC
;Function : fputcR, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   553 NULL n = bp+4
;  201 var sign word   553 NULL fd = bp+6;
 ENTER  0,0
lea dx, [bp+4]

;-554   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-555 


;-556 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
 LEAVE
 ret
ENDP

getLine: PROC

;-557   unsigned int i;


;-558   InputPtr= &InputBuf;

;Function : getLine, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   557 NULL i = bp-2;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-559   *InputPtr=0;//if last line is empty

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-560   do {

.getLine131:

;-561     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-562     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je .getLine132
 push getLine_0
 call errorexit
 add  sp, 2

;-563     if (DOS_NoBytes == 0) return;

.getLine132:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne .getLine133
 jmp .retngetLine

;-564     *InputPtr = DOS_ByteRead;

.getLine133:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-565     InputPtr++;

 inc  word[InputPtr]

;-566     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov [bp-2], ax

;-567     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 255 ;unsigned : 0
 jb  .getLine134
 push getLine_1
 call errorexit
 add  sp, 2

;-568   } while (ifEOL(DOS_ByteRead) == 0);

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

;-569   InputPtr--;

 dec  word[InputPtr]

;-570   *InputPtr=0;

 mov ax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-571 }


;-572 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR

 .retngetLine: LEAVE
 ret
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0
ENDP

ifEOL: PROC

;-573   if (c == 10) return 1;//LF

;Function : ifEOL, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   572 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne .ifEOL136
 mov ax, 1
 jmp .retnifEOL

;-574   if (c == 13) {//CR

.ifEOL136:
 mov al, [bp+4]
 cmp al, 13
 jne .ifEOL137

;-575     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-576     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");

 mov al, [DOS_ByteRead]
 cmp al, 10
 je  .ifEOL138
 push ifEOL_0
 call errorexit
 add  sp, 2

;-577     return 1;

.ifEOL138:
 mov ax, 1
 jmp .retnifEOL

;-578   }


;-579   return 0;

.ifEOL137:
 mov ax, 0
 jmp .retnifEOL

;-580 }


;-581 int skipBlank() {

 .retnifEOL: LEAVE
 ret
ifEOL_0 db "missing LF(10) after CR(13)",0
ENDP

skipBlank: PROC

;-582   skipblank1:

.skipblank1:

;-583     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne .skipBlank139
 inc  word[InputPtr]
 jmp .skipblank1

;-584     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

.skipBlank139:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne .skipBlank140
 inc  word[InputPtr]
 jmp .skipblank1

;-585 }

.skipBlank140:

;-586 int letterE(char c) {

 ret
ENDP

letterE: PROC

;-587   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   586 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne .letterE141
 mov ax, 1
 jmp .retnletterE

;-588   if (c=='.') return 1;

.letterE141:
 mov al, [bp+4]
 cmp al, 46
 jne .letterE142
 mov ax, 1
 jmp .retnletterE

;-589   if (c=='?') return 1;

.letterE142:
 mov al, [bp+4]
 cmp al, 63
 jne .letterE143
 mov ax, 1
 jmp .retnletterE

;-590   if (c=='$') return 1;

.letterE143:
 mov al, [bp+4]
 cmp al, 36
 jne .letterE144
 mov ax, 1
 jmp .retnletterE

;-591   if (c> 'z') return 0;

.letterE144:
 mov al, [bp+4]
 cmp al, 122
 jle .letterE145
 mov ax, 0
 jmp .retnletterE

;-592   if (c< '@') return 0; // at included

.letterE145:
 mov al, [bp+4]
 cmp al, 64
 jge .letterE146
 mov ax, 0
 jmp .retnletterE

;-593   if (c> 'Z') { if (c< 'a') return 0; }

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

;-594   return 1;

.letterE147:
 mov ax, 1
 jmp .retnletterE

;-595 }


;-596 int alnumE(char c) {

 .retnletterE: LEAVE
 ret
ENDP

alnumE: PROC

;-597   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   596 NULL c = bp+4;
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

;-598   if (letterE(c)) return 1;

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

;-599   return 0;

.alnumE150:
 mov ax, 0
 jmp .retnalnumE

;-600 }


;-601 int digit(char c){

 .retnalnumE: LEAVE
 ret
ENDP

digit: PROC

;-602     if(c<'0') return 0;

;Function : digit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   601 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge .digit151
 mov ax, 0
 jmp .retndigit

;-603     if(c>'9') return 0;

.digit151:
 mov al, [bp+4]
 cmp al, 57
 jle .digit152
 mov ax, 0
 jmp .retndigit

;-604     return 1;

.digit152:
 mov ax, 1
 jmp .retndigit

;-605 }


;-606 int strlen(char *s) { int c;

 .retndigit: LEAVE
 ret
ENDP

strlen: PROC

;-607     c=0;

;Function : strlen, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   606 NULL s = bp+4
;  201 var sign word   606 NULL c = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], ax

;-608     while (*s!=0) {s++; c++;}

.strlen153:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strlen154
 inc  word[bp+4]
 inc  word[bp-2]

;-609     return c;

 jmp .strlen153
.strlen154:
 mov ax, [bp-2]
 jmp .retnstrlen

;-610     }


;-611 int strcpy(char *s, char *t) {

 .retnstrlen: LEAVE
 ret
ENDP

strcpy: PROC

;-612     do { *s=*t; s++; t++; }

;Function : strcpy, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   611 NULL s = bp+4
;  201 ptr sign byte   611 NULL t = bp+6;
 ENTER  0,0
.strcpy155:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word[bp+4]
 inc  word[bp+6]

;-613     while (*t!=0);

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcpy156
 jmp .strcpy155
.strcpy156:

;-614     *s=0;

 mov ax, 0
 mov  bx, [bp+4]
 mov  [bx], al

;-615     return s;

 mov ax, [bp+4]
 jmp .retnstrcpy

;-616     }


;-617 int eqstr(char *p, char *q) {

 .retnstrcpy: LEAVE
 ret
ENDP

eqstr: PROC

;-618     while(*p) {

;Function : eqstr, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   617 NULL p = bp+4
;  201 ptr sign byte   617 NULL q = bp+6;
 ENTER  0,0
.eqstr157:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr158

;-619         if (*p != *q) return 0;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  .eqstr159
 mov ax, 0
 jmp .retneqstr

;-620             p++;

.eqstr159:
 inc  word[bp+4]

;-621             q++;

 inc  word[bp+6]

;-622             }


;-623     if(*q) return 0;

 jmp .eqstr157
.eqstr158:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .eqstr160
 mov ax, 0
 jmp .retneqstr

;-624     return 1;

.eqstr160:
 mov ax, 1
 jmp .retneqstr

;-625     }


;-626 int strcat1(char *s, char *t) {

 .retneqstr: LEAVE
 ret
ENDP

strcat1: PROC

;-627     while (*s != 0) s++;

;Function : strcat1, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   626 NULL s = bp+4
;  201 ptr sign byte   626 NULL t = bp+6;
 ENTER  0,0
.strcat1161:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  .strcat1162
 inc  word[bp+4]

;-628     strcpy(s, t);

 jmp .strcat1161
.strcat1162:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-629     }


;-630 int toupper(char *s) {
 LEAVE
 ret
ENDP

toupper: PROC

;-631     while(*s) {

;Function : toupper, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   630 NULL s = bp+4;
 ENTER  0,0
.toupper163:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .toupper164

;-632         if (*s >= 'a') if (*s <= 'z') *s=*s-32;

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

;-633             s++;

.toupper166:
.toupper165:
 inc  word[bp+4]

;-634               }


;-635     }

 jmp .toupper163
.toupper164:

;-636 


;-637 int getDigit(unsigned char c) {//ret: SymbolInt
 LEAVE
 ret
ENDP

getDigit: PROC

;-638   unsigned int CastInt;


;-639   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   637 NULL c = bp+4
;  201 var unsg word   638 NULL CastInt = bp-2;
 ENTER  2,0
 mov ax, 0
 mov word [SymbolInt], ax

;-640   do {

.getDigit167:

;-641     c-='0';

 sub  byte[bp+4], 48

;-642     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov bx, 10
 mul bx
 mov word [SymbolInt], ax

;-643     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov [bp-2], ax

;-644     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-645     InputPtr++;

 inc  word[InputPtr]

;-646     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-647   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je .getDigit168
 jmp .getDigit167
.getDigit168:

;-648 }


;-649 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
ENDP

getName: PROC

;-650   char *p; unsigned int i;


;-651   p = &Symbol;

;Function : getName, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   649 NULL c = bp+4
;  201 ptr sign byte   650 NULL p = bp-2
;  202 var unsg word   650 NULL i = bp-4;
 ENTER  4,0
 mov ax, Symbol
 mov [bp-2], ax

;-652   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-653   p++;

 inc  word[bp-2]

;-654   while (alnumE(c)) {

.getName169:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je .getName170

;-655     InputPtr++;

 inc  word[InputPtr]

;-656     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov [bp+4], al

;-657     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-658     p++;

 inc  word[bp-2]

;-659     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov [bp-4], ax

;-660     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  .getName171
 push getName_0
 call errorexit
 add  sp, 2

;-661   }

.getName171:

;-662   if (c == ':') isLabel=1; else isLabel=0;

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

;-663   p--;

.getName173:
 dec  word[bp-2]

;-664   *p = 0;

 mov ax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-665   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-666   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-667 }


;-668 int testReg() {
 LEAVE
 ret
getName_0 db "symbol too long",0
ENDP

testReg: PROC

;-669 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-670   R2Type=0;

 mov ax, 0
 mov byte [R2Type], al

;-671   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge .testReg174
 mov ax, 0
 jmp .retntestReg

;-672   if (strlen(Symbol) > 3) return 0;

.testReg174:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle .testReg175
 mov ax, 0
 jmp .retntestReg

;-673   R2Type=BYTE;

.testReg175:
 mov ax, 1
 mov byte [R2Type], al

;-674   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg176
 mov ax, 0
 jmp .retntestReg

;-675   if (eqstr(SymbolUpper, "CL")) return 1;

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

;-676   if (eqstr(SymbolUpper, "DL")) return 2;

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

;-677   if (eqstr(SymbolUpper, "BL")) return 3;

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

;-678   if (eqstr(SymbolUpper, "AH")) return 4;

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

;-679   if (eqstr(SymbolUpper, "CH")) return 5;

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

;-680   if (eqstr(SymbolUpper, "DH")) return 6;

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

;-681   if (eqstr(SymbolUpper, "BH")) return 7;

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

;-682   R2Type=WORD;

.testReg183:
 mov ax, 2
 mov byte [R2Type], al

;-683   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg184
 mov ax, 0
 jmp .retntestReg

;-684   if (eqstr(SymbolUpper, "CX")) return 1;

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

;-685   if (eqstr(SymbolUpper, "DX")) return 2;

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

;-686   if (eqstr(SymbolUpper, "BX")) return 3;

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

;-687   if (eqstr(SymbolUpper, "SP")) return 4;

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

;-688   if (eqstr(SymbolUpper, "BP")) return 5;

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

;-689   if (eqstr(SymbolUpper, "SI")) return 6;

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

;-690   if (eqstr(SymbolUpper, "DI")) return 7;

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

;-691   R2Type=SEGREG;

.testReg191:
 mov ax, 4
 mov byte [R2Type], al

;-692   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg192
 mov ax, 0
 jmp .retntestReg

;-693   if (eqstr(SymbolUpper, "CS")) return 1;

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

;-694   if (eqstr(SymbolUpper, "SS")) return 2;

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

;-695   if (eqstr(SymbolUpper, "DS")) return 3;

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

;-696   if (eqstr(SymbolUpper, "FS")) return 4;

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

;-697   if (eqstr(SymbolUpper, "GS")) return 5;

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

;-698   R2Type=DWORD;

.testReg197:
 mov ax, 3
 mov byte [R2Type], al

;-699   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je .testReg198
 mov ax, 0
 jmp .retntestReg

;-700   if (eqstr(SymbolUpper, "ECX"))return 1;

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

;-701   if (eqstr(SymbolUpper, "EDX"))return 2;

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

;-702   if (eqstr(SymbolUpper, "EBX"))return 3;

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

;-703   if (eqstr(SymbolUpper, "ESP"))return 4;

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

;-704   if (eqstr(SymbolUpper, "EBP"))return 5;

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

;-705   if (eqstr(SymbolUpper, "ESI"))return 6;

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

;-706   if (eqstr(SymbolUpper, "EDI"))return 7;

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

;-707   R2Type=0; return 0;

.testReg205:
 mov ax, 0
 mov byte [R2Type], al
 mov ax, 0
 jmp .retntestReg

;-708 }


;-709 


;-710 


;-711 //#include "OUTPUT.C"


;-712 int printLine() {

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

;-713     int i; char c;


;-714     prs("\n");

;Function : printLine, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign word   713 NULL i = bp-2
;  201 var sign byte   713 NULL c = bp-4;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-715     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-716     if (OpPrintIndex == 0) prs("               ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne .printLine206
 push printLine_1
 call prs
 add  sp, 2

;-717     else {

 jmp .printLine207
.printLine206:

;-718 //        prc(' ');


;-719         i=0;

 mov ax, 0
 mov [bp-2], ax

;-720         do {

.printLine208:

;-721             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov [bp-4], al

;-722             prc(' ');

 push 32
 call prc
 add  sp, 2

;-723             printhex8a(c);

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-724             i++;

 inc  word[bp-2]

;-725         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge .printLine209
 jmp .printLine208
.printLine209:

;-726         while (i < OPMAXLEN) {// fill rest with blank

.printLine210:
 mov ax, [bp-2]
 cmp ax, 5
 jge .printLine211

;-727             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-728             i++;

 inc  word[bp-2]

;-729         }


;-730     }

 jmp .printLine210
.printLine211:

;-731     prc(PrintRA);

.printLine207:
 mov al, byte [PrintRA]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-732     prscomment(InputBuf);

 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-733 }


;-734 int prc(unsigned char c) {//print char
 LEAVE
 ret
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0
ENDP

prc: PROC

;-735         if ( _ c==10) {

;Function : prc, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   734 NULL c = bp+4;
 ENTER  0,0 ; constant expression
cmp byte[bp+4], 10
 jne .prc212

;-736             ax=13;

 mov  ax, 13

;-737             writetty();

 call writetty

;-738             }


;-739         al=c;

.prc212:
 mov  al, [bp+4]

;-740         writetty();

 call writetty

;-741     fputcR(c,lst_fd);

 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-742 }


;-743 


;-744 int prscomment(unsigned char *s) {
 LEAVE
 ret
ENDP

prscomment: PROC

;-745     unsigned char c;


;-746     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   744 NULL s = bp+4
;  201 var unsg byte   745 NULL c = bp-2;
 ENTER  2,0
.prscomment213:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prscomment214

;-747         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-748         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-749         s++;

 inc  word[bp+4]

;-750     }


;-751 }

 jmp .prscomment213
.prscomment214:

;-752 int prs(unsigned char *s) {
 LEAVE
 ret
ENDP

prs: PROC

;-753     unsigned char c;


;-754     int com;


;-755     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 ptr unsg byte   752 NULL s = bp+4
;  201 var unsg byte   753 NULL c = bp-2
;  202 var sign word   754 NULL com = bp-4;
 ENTER  4,0
 mov ax, 0
 mov [bp-4], ax

;-756     while (*s) {

.prs215:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je .prs216

;-757         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-758         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne .prs217

;-759             if (com) com=0;

 mov ax, [bp-4]
 or  al, al
 je .prs218
 mov ax, 0
 mov [bp-4], ax

;-760                 else com=1;

 jmp .prs219
.prs218:
 mov ax, 1
 mov [bp-4], ax

;-761         }

.prs219:

;-762         if (c==92) {

.prs217:
 mov al, [bp-2]
 cmp al, 92
 jne .prs220

;-763             if (com==0) {

 mov ax, [bp-4]
 cmp ax, 0
 jne .prs221

;-764                 s++;

 inc  word[bp+4]

;-765                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], al

;-766                 if (c=='n') c=10;

 mov al, [bp-2]
 cmp al, 110
 jne .prs222
 mov ax, 10
 mov [bp-2], al

;-767                 if (c=='t') c= 9;

.prs222:
 mov al, [bp-2]
 cmp al, 116
 jne .prs223
 mov ax, 9
 mov [bp-2], al

;-768             }

.prs223:

;-769         }

.prs221:

;-770         prc(c);

.prs220:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-771         s++;

 inc  word[bp+4]

;-772     }


;-773 }

 jmp .prs215
.prs216:

;-774 int printhex8a(unsigned char c) {
 LEAVE
 ret
ENDP

printhex8a: PROC

;-775     unsigned char nib;


;-776     nib = c >> 4; printhex4(nib);

;Function : printhex8a, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   774 NULL c = bp+4
;  201 var unsg byte   775 NULL nib = bp-2;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-777     nib = c & 15; printhex4(nib);

 mov al, [bp+4]
 and al, 15
 mov [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-778 }


;-779 int printhex4(unsigned char c) {
 LEAVE
 ret
ENDP

printhex4: PROC

;-780     c += 48;

;Function : printhex4, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg byte   779 NULL c = bp+4;
 ENTER  0,0
 add  byte[bp+4], 48

;-781     if (c > 57) c += 7;

 mov al, [bp+4]
 cmp al, 57
 jle .printhex4224
 add  byte[bp+4], 7

;-782     prc(c);

.printhex4224:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-783 }


;-784 int printhex16(unsigned int i) {
 LEAVE
 ret
ENDP

printhex16: PROC

;-785     unsigned int half;


;-786     half = i >>  8; printhex8a(half);

;Function : printhex16, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   784 NULL i = bp+4
;  201 var unsg word   785 NULL half = bp-2;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-787     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-788 }


;-789 int printIntU(unsigned int n) {
 LEAVE
 ret
ENDP

printIntU: PROC

;-790     unsigned int e;


;-791     if ( _ n >= 10) {

;Function : printIntU, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var unsg word   789 NULL n = bp+4
;  201 var unsg word   790 NULL e = bp-2;
 ENTER  2,0 ; constant expression
cmp word[bp+4], 10 ;unsigned : 0
 jb  .printIntU225

;-792         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov [bp-2], ax

;-793         printIntU(e);

 push word [bp-2]
 call printIntU
 add  sp, 2

;-794     }


;-795     n = n % 10; //unsigned mod

.printIntU225:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov [bp+4], ax

;-796     n += '0';

 add  word[bp+4], 48

;-797     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-798 }


;-799 


;-800 int error1(char *s) {
 LEAVE
 ret
ENDP

error1: PROC

;-801     ErrorCount++;

;Function : error1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   800 NULL s = bp+4;
 ENTER  0,0
 inc  word[ErrorCount]

;-802     prs("\n;***** next line ERROR: ");

 push error1_0
 call prs
 add  sp, 2

;-803     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-804     prs(", Symbol: ");

 push error1_1
 call prs
 add  sp, 2

;-805     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-806 }


;-807 int errorexit(char *s) {
 LEAVE
 ret
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0
ENDP

errorexit: PROC

;-808     error1(s);

;Function : errorexit, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 ptr sign byte   807 NULL s = bp+4;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-809     epilog();

 call epilog

;-810     end1(1);

 push 1
 call end1
 add  sp, 2

;-811 }


;-812 int allowederror() {error1("not allowed here"); }
 LEAVE
 ret
ENDP

allowederror: PROC
 push allowederror_0
 call error1
 add  sp, 2

;-813 int addrerror()    {error1("address missing");}

 ret
allowederror_0 db "not allowed here",0
ENDP

addrerror: PROC
 push addrerror_0
 call error1
 add  sp, 2

;-814 int immeerror()    {error1("immediate not allowed here");}

 ret
addrerror_0 db "address missing",0
ENDP

immeerror: PROC
 push immeerror_0
 call error1
 add  sp, 2

;-815 int implerror()    {error1("not implemented");}

 ret
immeerror_0 db "immediate not allowed here",0
ENDP

implerror: PROC
 push implerror_0
 call error1
 add  sp, 2

;-816 int indexerror()   {error1("invalid index register");}

 ret
implerror_0 db "not implemented",0
ENDP

indexerror: PROC
 push indexerror_0
 call error1
 add  sp, 2

;-817 int invaloperror() {error1("invalid or no operands");}

 ret
indexerror_0 db "invalid index register",0
ENDP

invaloperror: PROC
 push invaloperror_0
 call error1
 add  sp, 2

;-818 int numbererror()  {error1("number expected");}

 ret
invaloperror_0 db "invalid or no operands",0
ENDP

numbererror: PROC
 push numbererror_0
 call error1
 add  sp, 2

;-819 int regmemerror()  {error1("only register or memory allowed");}

 ret
numbererror_0 db "number expected",0
ENDP

regmemerror: PROC
 push regmemerror_0
 call error1
 add  sp, 2

;-820 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
regmemerror_0 db "only register or memory allowed",0
ENDP

reg16error: PROC
 push reg16error_0
 call error1
 add  sp, 2

;-821 int segregerror()  {error1("segment register not allowed");}

 ret
reg16error_0 db "only reg16, no segreg allowed",0
ENDP

segregerror: PROC
 push segregerror_0
 call error1
 add  sp, 2

;-822 int syntaxerror()  {error1("syntax");}

 ret
segregerror_0 db "segment register not allowed",0
ENDP

syntaxerror: PROC
 push syntaxerror_0
 call error1
 add  sp, 2

;-823 


;-824 int addrexit()     {errorexit("illegal address");}

 ret
syntaxerror_0 db "syntax",0
ENDP

addrexit: PROC
 push addrexit_0
 call errorexit
 add  sp, 2

;-825 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
addrexit_0 db "illegal address",0
ENDP

dataexit: PROC
 push dataexit_0
 call errorexit
 add  sp, 2

;-826 int internexit()   {errorexit("intern compiler error");}

 ret
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
ENDP

internexit: PROC
 push internexit_0
 call errorexit
 add  sp, 2

;-827 


;-828 


;-829 //#include "MAIN.C"


;-830 int main() {

 ret
internexit_0 db "intern compiler error",0
ENDP

main: PROC

;-831     getarg();

 call getarg

;-832     parse();

 call parse

;-833     fixJmpCall();

 call fixJmpCall

;-834     epilog();

 call epilog

;-835     end1();

 call end1

;-836 }


;-837 


;-838 int getarg() {

 ret
ENDP

getarg: PROC

;-839     int arglen1; int i; char *c;


;-840     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var sign word   839 NULL arglen1 = bp-2
;  201 var sign word   839 NULL i = bp-4
;  202 ptr sign byte   839 NULL c = bp-6;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov [bp-2], ax

;-841     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne .getarg226

;-842         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-843         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-844         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-845     }


;-846     i=arglen1+129;

.getarg226:
 mov ax, [bp-2]
 add ax, 129
 mov [bp-4], ax

;-847     *i=0;

 mov ax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-848     arglen1--;

 dec  word[bp-2]

;-849     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-850 


;-851     strcpy(namein, argv); strcat1(namein, ".S");

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

;-852     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-853     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-854 


;-855   DOS_ERR=0; PC=0; ErrorCount=0;

 mov ax, 0
 mov word [DOS_ERR], ax
 mov ax, 0
 mov word [PC], ax
 mov ax, 0
 mov word [ErrorCount], ax

;-856 


;-857     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-858     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

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

;-859     lst_fd=creatR(namelst);

.getarg227:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-860     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

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

;-861     bin_fd=creatR(namebin);

.getarg228:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-862     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

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

;-863 


;-864     prs(";");

.getarg229:
 push getarg_7
 call prs
 add  sp, 2

;-865     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-866     prs(", Source: "); prs(namein);

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-867     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-868     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-869     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-870 }


;-871 


;-872 int fixJmpCall() {
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

;-873     int i;  unsigned int hex;  char *p; int Ix; char c;


;-874     i=1;

;Function : fixJmpCall, Number of local variables: 5
;   # type sign width addr used name   list of local variables
;  200 var sign word   873 NULL i = bp-2
;  201 var unsg word   873 NULL hex = bp-4
;  202 ptr sign byte   873 NULL p = bp-6
;  203 var sign word   873 NULL Ix = bp-8
;  204 var sign byte   873 NULL c = bp-10;
 ENTER  10,0
 mov ax, 1
 mov [bp-2], ax

;-875     prs("\n;END open jmp/call: ");

 push fixJmpCall_0
 call prs
 add  sp, 2

;-876     printIntU(JmpCallMaxIx);

 push word [JmpCallMaxIx]
 call printIntU
 add  sp, 2

;-877     p = &JmpCallNames;

 mov ax, JmpCallNames
 mov [bp-6], ax

;-878     while (i <= JmpCallMaxIx) {

.fixJmpCall230:
 mov ax, [bp-2]
 cmp ax, [JmpCallMaxIx]
 jg  .fixJmpCall231

;-879         strcpy(Symbol, p);

 push word [bp-6]
 lea  ax, [Symbol]
 push ax
 call strcpy
 add  sp, 4

;-880         p = strlen(Symbol) + p;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 add ax, [bp-6]
 mov [bp-6], ax

;-881         p++;

 inc  word[bp-6]

;-882 //        prs(Symbol);


;-883 //        prc(' ');


;-884         hex = JmpCallAddr[i];

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [JmpCallAddr + bx]
 mov [bp-4], ax

;-885 //        printhex16(hex);


;-886 


;-887         Ix=searchLabel();

 call searchLabel
 mov [bp-8], ax

;-888         if (Ix == 0) error1("Label not found");

 mov ax, [bp-8]
 cmp ax, 0
 jne .fixJmpCall232
 push fixJmpCall_1
 call error1
 add  sp, 2

;-889         disp = LabelAddr[Ix];

.fixJmpCall232:
 mov bx, [bp-8]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-890         disp = disp - hex;

 mov ax, [disp]
 sub ax, [bp-4]
 mov word [disp], ax

;-891         disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-892 //        prs(", ");


;-893 


;-894             hex = hex - 2;//fix at start of word

 mov ax, [bp-4]
 sub ax, 2
 mov [bp-4], ax

;-895             FileBin[hex] = disp;//fix low byte

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-896             hex++;

 inc  word[bp-4]

;-897             disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-898             FileBin[hex] = disp;

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-899         i++;

 inc  word[bp-2]

;-900     }


;-901 }

 jmp .fixJmpCall230
.fixJmpCall231:

;-902 


;-903 int epilog() {
 LEAVE
 ret
fixJmpCall_0 db "\n;END open jmp/call: ",0
fixJmpCall_1 db "Label not found",0
ENDP

epilog: PROC

;-904     unsigned int i; char c;     int j;


;-905     prs("\n Errors: ");

;Function : epilog, Number of local variables: 3
;   # type sign width addr used name   list of local variables
;  200 var unsg word   904 NULL i = bp-2
;  201 var sign byte   904 NULL c = bp-4
;  202 var sign word   904 NULL j = bp-6;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-906     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-907     if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je .epilog233
 push epilog_1
 call prs
 add  sp, 2

;-908     prs(", Out: ");

.epilog233:
 push epilog_2
 call prs
 add  sp, 2

;-909     prs(namelst);

 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-910     prs(", ");

 push epilog_3
 call prs
 add  sp, 2

;-911     prs(namebin);

 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-912     prs("= ");

 push epilog_4
 call prs
 add  sp, 2

;-913     printIntU(BinLen);

 push word [BinLen]
 call printIntU
 add  sp, 2

;-914     prs(" bytes.");

 push epilog_5
 call prs
 add  sp, 2

;-915 


;-916     i=0;

 mov ax, 0
 mov [bp-2], ax

;-917     do {

.epilog234:

;-918         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov [bp-4], al

;-919         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-920 //printhex8a(c); prc(' ');


;-921         i++;

 inc  word[bp-2]

;-922     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge .epilog235
 jmp .epilog234
.epilog235:

;-923 


;-924   prs(" Labels: ");

 push epilog_6
 call prs
 add  sp, 2

;-925   printIntU(LabelMaxIx);

 push word [LabelMaxIx]
 call printIntU
 add  sp, 2

;-926   prs(". ");

 push epilog_7
 call prs
 add  sp, 2

;-927 /*


;-928   prs(" LabelNamePtr:"); printIntU(LabelNamePtr);


;-929   i= &LabelNames;


;-930   prs(" &LabelNames:"); printIntU(i);


;-931   i=LabelNamePtr-i;


;-932   prs("size: ");


;-933   printIntU(i);


;-934   prs(". >>");


;-935   i= &LabelNames;


;-936   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-937   } while (i < LabelNamePtr); prs("<< \n");


;-938    i = 1;


;-939     LabelNamePtr= &LabelNames;


;-940     do {


;-941       prs(LabelNamePtr); prc(' ');


;-942       j=LabelAddr[i]; printhex16(j); prs(", ");


;-943       j=strlen(LabelNamePtr);//get end of actual name


;-944       LabelNamePtr=LabelNamePtr+j;


;-945       LabelNamePtr++;


;-946       i++;


;-947     } while (i <= LabelMaxIx);


;-948 */


;-949 }


;-950 


;-951 int end1(int n) {
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

;-952     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign word   951 NULL n = bp+4;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-953     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-954     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-955     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-956 }


;-957 


;-958 


;-959 //#include "GENCODE.C"


;-960 // generate code


;-961 int getCodes() {
 LEAVE
 ret
ENDP

getCodes: PROC

;-962     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-963     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-964     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word[OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-965 }


;-966 int gen66h() {genCode8(0x66);

 ret
ENDP

gen66h: PROC
 push 102
 call genCode8
 add  sp, 2

;-967 }


;-968 int genCode2(char c, char d) {

 ret
ENDP

genCode2: PROC

;-969     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   968 NULL c = bp+4
;  201 var sign byte   968 NULL d = bp+6;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov [bp+4], al

;-970     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-971 }


;-972 int genCodeW(char c) {
 LEAVE
 ret
ENDP

genCodeW: PROC

;-973     c = c + wflag;

;Function : genCodeW, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   972 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov [bp+4], al

;-974     genCode8(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-975 }


;-976 int genCode8(char c) {
 LEAVE
 ret
ENDP

genCode8: PROC

;-977 //set: BinLen++, OpPrintIndex++


;-978     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var sign byte   976 NULL c = bp+4;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-979     BinLen++;

 inc  word[BinLen]

;-980     PC++;

 inc  word[PC]

;-981     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 20000 ;unsigned : 0
 jb  .genCode8236
 push genCode8_0
 call errorexit
 add  sp, 2

;-982     if (OpPrintIndex < OPMAXLEN) {

.genCode8236:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge .genCode8237

;-983         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-984         OpPrintIndex++;

 inc  word[OpPrintIndex]

;-985     }


;-986 }

.genCode8237:

;-987 int genCode16(unsigned int i) {
 LEAVE
 ret
genCode8_0 db "COM file too long",0
ENDP

genCode16: PROC

;-988     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg word   987 NULL i = bp+4;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov [bp+4], ax

;-989     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-990 }


;-991 int genCode32(unsigned long L) {
 LEAVE
 ret
ENDP

genCode32: PROC

;-992     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width addr used name   list of local variables
;  200 var unsg dwrd   991 NULL L = bp+4;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2
 mov eax, [bp+4]
 shr eax, 16
 mov [bp+4], eax

;-993     genCode16(L);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode16
 add  sp, 2

;-994 }


;-995 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
ENDP

writeEA: PROC

;-996 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-997 //mod-bits: mode76, reg/opcode543, r/m210


;-998 //Op: 0, IMM, REG, ADR, MEM


;-999     char len;


;-1000     len=0;

;Function : writeEA, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte   995 NULL xxx = bp+4
;  201 var sign byte   999 NULL len = bp-2;
 ENTER  2,0
 mov ax, 0
 mov [bp-2], al

;-1001     xxx = xxx << 3;//in reg/opcode field

 mov al, [bp+4]
 shl al, 3
 mov [bp+4], al

;-1002     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .writeEA238

;-1003         xxx |= 0xC0;

 or  byte[bp+4], 192

;-1004         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM

 mov al, [Op2]
 cmp al, 1
 jg  .writeEA239
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1005             else {

 jmp .writeEA240
.writeEA239:

;-1006                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne .writeEA241
 mov al, [bp+4]
 add al, [R1No]
 mov [bp+4], al

;-1007                 else            xxx = xxx + R2No;

 jmp .writeEA242
.writeEA241:
 mov al, [bp+4]
 add al, [R2No]
 mov [bp+4], al

;-1008             }

.writeEA242:

;-1009         }

.writeEA240:

;-1010     if (Op == MEM) {

.writeEA238:
 mov al, [Op]
 cmp al, 4
 jne .writeEA243

;-1011         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .writeEA244

;-1012             xxx |= 6;

 or  byte[bp+4], 6

;-1013             len = 2;

 mov ax, 2
 mov [bp-2], al

;-1014         }


;-1015         else {

 jmp .writeEA245
.writeEA244:

;-1016             xxx = xxx + rm;

 mov al, [bp+4]
 add al, [rm]
 mov [bp+4], al

;-1017             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne .writeEA246

;-1018                 len=1;

 mov ax, 1
 mov [bp-2], al

;-1019                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne .writeEA247
 or  byte[bp+4], 64

;-1020             }

.writeEA247:

;-1021 


;-1022             if (disp) {

.writeEA246:
 mov ax, [disp]
 or  al, al
 je .writeEA248

;-1023                 ax = disp;

 mov  ax, [disp]

;-1024                 if(ax > 127) len=2;

 cmp  ax, 127
 jle .writeEA249
 mov ax, 2
 mov [bp-2], al

;-1025                 else len=1;

 jmp .writeEA250
.writeEA249:
 mov ax, 1
 mov [bp-2], al

;-1026                 if (len == 1) xxx |= 0x40;

.writeEA250:
 mov al, [bp-2]
 cmp al, 1
 jne .writeEA251
 or  byte[bp+4], 64

;-1027                 else xxx |= 0x80;

 jmp .writeEA252
.writeEA251:
 or  byte[bp+4], 128

;-1028             }

.writeEA252:

;-1029         }

.writeEA248:

;-1030     }

.writeEA245:

;-1031 


;-1032     genCode8(xxx);// gen second byte

.writeEA243:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1033     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne .writeEA253
 push word [disp]
 call genCode8
 add  sp, 2

;-1034     if (len == 2) genCode16(disp);

.writeEA253:
 mov al, [bp-2]
 cmp al, 2
 jne .writeEA254
 push word [disp]
 call genCode16
 add  sp, 2

;-1035 }

.writeEA254:

;-1036 


;-1037 int genImmediate() {
 LEAVE
 ret
ENDP

genImmediate: PROC

;-1038     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long

 mov al, [wflag]
 or  al, al
 je .genImmediate255
 mov al, [OpSize]
 cmp al, 3
 jne .genImmediate256
 push word [imme]
 call genCode32
 add  sp, 2

;-1039         else genCode16(imme);

 jmp .genImmediate257
.genImmediate256:
 push word [imme]
 call genCode16
 add  sp, 2

;-1040     else       genCode8 (imme);

.genImmediate257:
 jmp .genImmediate258
.genImmediate255:
 push word [imme]
 call genCode8
 add  sp, 2

;-1041 }

.genImmediate258:

;-1042 


;-1043 //AS.C


;-1044 int process() {

 ret
ENDP

process: PROC

;-1045     char c;


;-1046     int i;


;-1047     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 2
;   # type sign width addr used name   list of local variables
;  200 var sign byte  1045 NULL c = bp-2
;  201 var sign word  1046 NULL i = bp-4;
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

;-1048     disp=imme=0;//int

 mov ax, 0
 mov word [imme], ax
 mov word [disp], ax

;-1049     isDirect=1; //set in getMeM=0, need in WriteEA

 mov ax, 1
 mov byte [isDirect], al

;-1050     getTokeType();//0, DIGIT, ALNUME, NOALNUME

 call getTokeType

;-1051     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-1052     getCodes();//set: Code1, Code2, Code3

 call getCodes

;-1053 


;-1054     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne .process259

;-1055         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1056         return;

 jmp .retnprocess

;-1057     }


;-1058 


;-1059     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

.process259:
 mov al, [CodeType]
 cmp al, 2
 jne .process260

;-1060         getOpL();

 call getOpL

;-1061         checkOpL();

 call checkOpL

;-1062         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  .process261

;-1063   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne .process262

;-1064                 if (wflag) {genCode2(Code3, R1No); return; }

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

;-1065             }

.process263:

;-1066         }

.process262:

;-1067         if (Code2 == 5) {//imul extension?

.process261:
 mov al, [Code2]
 cmp al, 5
 jne .process264

;-1068             getTokeType();

 call getTokeType

;-1069             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je .process265
 call implerror

;-1070         }

.process265:

;-1071         genCodeW(Code1);

.process264:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1072         writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1073         return;

 jmp .retnprocess

;-1074     }


;-1075 


;-1076     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

.process260:
 mov al, [CodeType]
 cmp al, 3
 jne .process266

;-1077         check2Ops();    //setwflag not applicable

 call check2Ops

;-1078         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  .process267
 call reg16error

;-1079         if (Op2 != MEM) addrerror();//only m16

.process267:
 mov al, [Op2]
 cmp al, 4
 je  .process268
 call addrerror

;-1080 


;-1081         genCode8(Code1);//les,lds,lea

.process268:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1082         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs

 mov al, [Code1]
 cmp al, 15
 jne .process269
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1083         Op=Op2;//set MEM for writeEA

.process269:
 mov al, [Op2]
 mov byte [Op], al

;-1084         writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1085         return;

 jmp .retnprocess

;-1086     }


;-1087 


;-1088     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

.process266:
 mov al, [CodeType]
 cmp al, 4
 jne .process270

;-1089         check2Ops();

 call check2Ops

;-1090         if (Op2 == IMM) {//second operand is imm

 mov al, [Op2]
 cmp al, 1
 jne .process271

;-1091             setsflag();

 call setsflag

;-1092             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process272

;-1093                 if (R1No == 0) {// acc,imm

 mov al, [R1No]
 cmp al, 0
 jne .process273

;-1094                     if (sflag == 0) {

 mov al, [sflag]
 cmp al, 0
 jne .process274

;-1095                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1096                         c += 4;

 add  byte[bp-2], 4

;-1097                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1098                         genImmediate();

 call genImmediate

;-1099                         return;

 jmp .retnprocess

;-1100                     }


;-1101                 }

.process274:

;-1102             }

.process273:

;-1103             //r/m, imm: 80 sign-extended,TTT,imm


;-1104             c = sflag + 0x80;

.process272:
 mov al, [sflag]
 add al, 128
 mov [bp-2], al

;-1105             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1106             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1107             if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je .process275
 push word [imme]
 call genCode8
 add  sp, 2

;-1108             else genImmediate();

 jmp .process276
.process275:
 call genImmediate

;-1109             return;

.process276:
 jmp .retnprocess

;-1110         }


;-1111         c = Code1 << 3;//r/m, r/r

.process271:
 mov al, [Code1]
 shl al, 3
 mov [bp-2], al

;-1112         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process277

;-1113             if (Op2 == MEM) {//reg, mem

 mov al, [Op2]
 cmp al, 4
 jne .process278

;-1114                 c += 2;//add direction flag

 add  byte[bp-2], 2

;-1115                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1116                 Op=Op2;//set MEM for writeEA

 mov al, [Op2]
 mov byte [Op], al

;-1117                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1118                 return;

 jmp .retnprocess

;-1119             }


;-1120         }

.process278:

;-1121         if (Op2 == REG) {//mem,reg    reg,reg

.process277:
 mov al, [Op2]
 cmp al, 2
 jne .process279

;-1122             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-1123             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1124             return;

 jmp .retnprocess

;-1125         }


;-1126         syntaxerror();

.process279:
 call syntaxerror

;-1127         return;

 jmp .retnprocess

;-1128     }


;-1129 


;-1130     if (CodeType == 5) {//mov (movsx, movzx=51)

.process270:
 mov al, [CodeType]
 cmp al, 5
 jne .process280

;-1131         check2Ops();

 call check2Ops

;-1132 /*    prs("\n Op:"); printhex8a(Op);


;-1133     prs(", Op2:"); printhex8a(Op2);


;-1134     prs(", R1No:"); printhex8a(R1No);


;-1135     prs(", R2No:"); printhex8a(R2No);   */


;-1136         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne .process281

;-1137             imme=disp;

 mov ax, [disp]
 mov word [imme], ax

;-1138             Op2=IMM;//continue with IMM

 mov ax, 1
 mov byte [Op2], al

;-1139         }


;-1140         if (Op2 == IMM) {// r,i

.process281:
 mov al, [Op2]
 cmp al, 1
 jne .process282

;-1141             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process283

;-1142                 c = wflag << 3;

 mov al, [wflag]
 shl al, 3
 mov [bp-2], al

;-1143                 c += 0xB0;

 add  byte[bp-2], 176

;-1144                 genCode2(c, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1145                 genImmediate();

 call genImmediate

;-1146                 return;

 jmp .retnprocess

;-1147             }


;-1148             if (Op == MEM) {// m,i

.process283:
 mov al, [Op]
 cmp al, 4
 jne .process284

;-1149                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-1150                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-1151                 genImmediate();

 call genImmediate

;-1152                 return;

 jmp .retnprocess

;-1153             }


;-1154             regmemerror();

.process284:
 call regmemerror

;-1155             return;

 jmp .retnprocess

;-1156         }


;-1157         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

.process282:
 mov al, [R1Type]
 cmp al, 4
 jne .process285
 call ChangeDirection

;-1158         if (R2Type == SEGREG) {//rm,sreg

.process285:
 mov al, [R2Type]
 cmp al, 4
 jne .process286

;-1159             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  .process287
 call reg16error

;-1160                 genCode2(0x8C, dflag);

.process287:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-1161                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1162                 return;

 jmp .retnprocess

;-1163         }


;-1164         if (Op2 == MEM) {//acc, moffs16

.process286:
 mov al, [Op2]
 cmp al, 4
 jne .process288

;-1165             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process289

;-1166                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne .process290

;-1167                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process291

;-1168                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-1169                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1170                         return;

 jmp .retnprocess

;-1171                     }


;-1172                 }

.process291:

;-1173             }

.process290:

;-1174         }

.process289:

;-1175         if (Op == MEM) {//moffs16, acc

.process288:
 mov al, [Op]
 cmp al, 4
 jne .process292

;-1176             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne .process293

;-1177                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne .process294

;-1178                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je .process295

;-1179                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-1180                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1181                         return;

 jmp .retnprocess

;-1182                     }


;-1183                 }

.process295:

;-1184             }

.process294:

;-1185 


;-1186         }

.process293:

;-1187         if (Op2 == REG) {//rm, r

.process292:
 mov al, [Op2]
 cmp al, 2
 jne .process296

;-1188             genCodeW(0x88);

 push 136
 call genCodeW
 add  sp, 2

;-1189             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1190             return;

 jmp .retnprocess

;-1191         }


;-1192         if (Op2 == MEM) {//r, m

.process296:
 mov al, [Op2]
 cmp al, 4
 jne .process297

;-1193             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne .process298

;-1194                 ChangeDirection();

 call ChangeDirection

;-1195                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-1196                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1197                 return;

 jmp .retnprocess

;-1198             }


;-1199         }

.process298:

;-1200         syntaxerror();

.process297:
 call syntaxerror

;-1201         return;

 jmp .retnprocess

;-1202     }


;-1203 


;-1204     if (CodeType == 6) {//Jcc

.process280:
 mov al, [CodeType]
 cmp al, 6
 jne .process299

;-1205         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process300

;-1206             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1207             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process301

;-1208                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1209                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1210                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1211                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process302

;-1212                     genCode2(Code1, 0x70);//short

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1213                     disp -= 2;

 sub  word[disp], 2

;-1214                     genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1215                 } else {

 jmp .process303
.process302:

;-1216                     genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1217                     genCode2(Code1, 0x80);//near

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1218                     disp -= 4;

 sub  word[disp], 4

;-1219                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1220                 }


;-1221             }

.process303:

;-1222             else {//jump forward, near only

 jmp .process304
.process301:

;-1223                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1224                 genCode2(Code1, 0x80);

 push 128
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1225                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1226                 PrintRA='r';

 mov ax, 114
 mov byte [PrintRA], al

;-1227                 storeJmpCall();

 call storeJmpCall

;-1228             }


;-1229         return;

.process304:
 jmp .retnprocess

;-1230         }


;-1231     }

.process300:

;-1232 


;-1233     if (CodeType == 7) {//jmp, call

.process299:
 mov al, [CodeType]
 cmp al, 7
 jne .process305

;-1234         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne .process306

;-1235             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-1236             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle .process307

;-1237                 disp=LabelAddr[LabelIx];

 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax

;-1238                 disp = disp - PC;

 mov ax, [disp]
 sub ax, [PC]
 mov word [disp], ax

;-1239                 disp = disp - Origin;

 mov ax, [disp]
 sub ax, [Origin]
 mov word [disp], ax

;-1240                 if (checkConstSize(disp) ) {

 push word [disp]
 call checkConstSize
 add  sp, 2
 or  al, al
 je .process308

;-1241                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne .process309

;-1242                         genCode8(0xEB);//short

 push 235
 call genCode8
 add  sp, 2

;-1243                         disp -= 2;

 sub  word[disp], 2

;-1244                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-1245                     }


;-1246                     else {

 jmp .process310
.process309:

;-1247                         genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1248                         disp -= 3;

 sub  word[disp], 3

;-1249                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1250                     }


;-1251                 }

.process310:

;-1252                 else {

 jmp .process311
.process308:

;-1253                     genCode8(Code1);//near

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1254                     disp -= 3;

 sub  word[disp], 3

;-1255                     genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1256                 }


;-1257             }

.process311:

;-1258             else {//jump forward, near only

 jmp .process312
.process307:

;-1259                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1260                 genCode16(0);

 push 0
 call genCode16
 add  sp, 2

;-1261                 PrintRA='R';

 mov ax, 82
 mov byte [PrintRA], al

;-1262                 storeJmpCall();

 call storeJmpCall

;-1263             }


;-1264         return;

.process312:
 jmp .retnprocess

;-1265         }


;-1266     }

.process306:

;-1267 


;-1268     if (CodeType ==  8) {//ret,retf

.process305:
 mov al, [CodeType]
 cmp al, 8
 jne .process313

;-1269         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process314

;-1270             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1271             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1272             return;

 jmp .retnprocess

;-1273         }


;-1274         genCode8(Code1);

.process314:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1275         return;

 jmp .retnprocess

;-1276     }


;-1277 


;-1278     if (CodeType == 9) {//push, pop

.process313:
 mov al, [CodeType]
 cmp al, 9
 jne .process315

;-1279         getOpL();

 call getOpL

;-1280         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne .process316

;-1281             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne .process317

;-1282                 setsflag();

 call setsflag

;-1283                 genCode2(0x68, sflag);

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-1284                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je .process318
 push word [imme]
 call genCode8
 add  sp, 2

;-1285                 else       genCode16(imme);

 jmp .process319
.process318:
 push word [imme]
 call genCode16
 add  sp, 2

;-1286                 return;

.process319:
 jmp .retnprocess

;-1287             }


;-1288             if (Op == ADR) {//push string ABSOLUTE i16

.process317:
 mov al, [Op]
 cmp al, 3
 jne .process320

;-1289                 genCode8(0x68);

 push 104
 call genCode8
 add  sp, 2

;-1290                 genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-1291                 return;

 jmp .retnprocess

;-1292             }


;-1293         }

.process320:

;-1294         if (R1Type == SEGREG) {

.process316:
 mov al, [R1Type]
 cmp al, 4
 jne .process321

;-1295             if (Code1 == 0x58) {//pop only

 mov al, [Code1]
 cmp al, 88
 jne .process322

;-1296                 if (R1No == 1) error1("pop cs not allowed");

 mov al, [R1No]
 cmp al, 1
 jne .process323
 push process_0
 call error1
 add  sp, 2

;-1297             }

.process323:

;-1298             c = R1No <<3;

.process322:
 mov al, [R1No]
 shl al, 3
 mov [bp-2], al

;-1299             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle .process324

;-1300                 c += 122;

 add  byte[bp-2], 122

;-1301                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-1302             }


;-1303             OpCodePtr++;

.process324:
 inc  word[OpCodePtr]

;-1304             c = c + *OpCodePtr;//is Code4

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov [bp-2], al

;-1305             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1306             return;

 jmp .retnprocess

;-1307         }


;-1308         checkOpL();

.process321:
 call checkOpL

;-1309         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne .process325
 call reg16error

;-1310         if (R1Type == WORD) {

.process325:
 mov al, [R1Type]
 cmp al, 2
 jne .process326

;-1311             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-1312             return;

 jmp .retnprocess

;-1313         }


;-1314         if (Op == MEM) {

.process326:
 mov al, [Op]
 cmp al, 4
 jne .process327

;-1315             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1316             writeEA(Code3);

 mov al, byte [Code3]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1317             return;

 jmp .retnprocess

;-1318         }


;-1319         syntaxerror();

.process327:
 call syntaxerror

;-1320         return;

 jmp .retnprocess

;-1321     }


;-1322 


;-1323     if (CodeType == 11) {//shift, rotate

.process315:
 mov al, [CodeType]
 cmp al, 11
 jne .process328

;-1324         check2Ops();

 call check2Ops

;-1325         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne .process329

;-1326             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne .process330

;-1327                 genCodeW(0xD0);

 push 208
 call genCodeW
 add  sp, 2

;-1328                 writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1329                 return;

 jmp .retnprocess

;-1330             }


;-1331             genCodeW(0xC0);//80186

.process330:
 push 192
 call genCodeW
 add  sp, 2

;-1332             writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1333             genCode8(imme);

 push word [imme]
 call genCode8
 add  sp, 2

;-1334             return;

 jmp .retnprocess

;-1335         }


;-1336         if (Op2 == REG) {

.process329:
 mov al, [Op2]
 cmp al, 2
 jne .process331

;-1337             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne .process332

;-1338                 if (R2No == 1) {//CL-REG

 mov al, [R2No]
 cmp al, 1
 jne .process333

;-1339                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne .process334
 mov ax, 1
 mov byte [wflag], al

;-1340                     genCodeW(0xD2);

.process334:
 push 210
 call genCodeW
 add  sp, 2

;-1341                     writeEA(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-1342                     return;

 jmp .retnprocess

;-1343                 }


;-1344             }

.process333:

;-1345         }

.process332:

;-1346     }

.process331:

;-1347 


;-1348     if (CodeType == 12) {//int

.process328:
 mov al, [CodeType]
 cmp al, 12
 jne .process335

;-1349         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne .process336

;-1350             genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-1351             genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1352             return;

 jmp .retnprocess

;-1353         }


;-1354     }

.process336:

;-1355 


;-1356     if (CodeType == 30) {//enter i18,i8

.process335:
 mov al, [CodeType]
 cmp al, 30
 jne .process337

;-1357         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-1358         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1359         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process338
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-1360         else numbererror();

 jmp .process339
.process338:
 call numbererror

;-1361         need(',');

.process339:
 push 44
 call need
 add  sp, 2

;-1362         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-1363         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne .process340
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-1364         else numbererror();

 jmp .process341
.process340:
 call numbererror

;-1365         return;

.process341:
 jmp .retnprocess

;-1366     }


;-1367 


;-1368     if (CodeType==101) {//ORG nn

.process337:
 mov al, [CodeType]
 cmp al, 101
 jne .process342

;-1369         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process343
 call numbererror

;-1370         Origin=SymbolInt;

.process343:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-1371         return;

 jmp .retnprocess

;-1372     }


;-1373 


;-1374     if (CodeType == 102) {//section, segment

.process342:
 mov al, [CodeType]
 cmp al, 102
 jne .process344

;-1375         //getTokeType();//ignore .bss .text .data


;-1376         AbsoluteLab=0;//nasm resets erevy time

 mov ax, 0
 mov word [AbsoluteLab], ax

;-1377         return;

 jmp .retnprocess

;-1378     }


;-1379 


;-1380     if (CodeType == 110) {//absolute

.process344:
 mov al, [CodeType]
 cmp al, 110
 jne .process345

;-1381         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  .process346
 call numbererror

;-1382         AbsoluteLab=SymbolInt;

.process346:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-1383         return;

 jmp .retnprocess

;-1384     }


;-1385     if (CodeType == 111) {//name: PROC

.process345:
 mov al, [CodeType]
 cmp al, 111
 jne .process347

;-1386         if (isInProc == 0)  {

 mov al, [isInProc]
 cmp al, 0
 jne .process348

;-1387           prs("\n;entering: ");

 push process_1
 call prs
 add  sp, 2

;-1388           prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1389           isInProc=1;

 mov ax, 1
 mov byte [isInProc], al

;-1390           locLabelNamePtr = LabelNamePtr;

 mov ax, [LabelNamePtr]
 mov word [locLabelNamePtr], ax

;-1391           localLabelMaxIx = LabelMaxIx;

 mov ax, [LabelMaxIx]
 mov word [localLabelMaxIx], ax

;-1392         } else error1("already in proc");

 jmp .process349
.process348:
 push process_2
 call error1
 add  sp, 2

;-1393         return;

.process349:
 jmp .retnprocess

;-1394     }


;-1395     if (CodeType == 112) {//ENDP

.process347:
 mov al, [CodeType]
 cmp al, 112
 jne .process350

;-1396       prs("\n;leaving: ");

 push process_3
 call prs
 add  sp, 2

;-1397       prs(ProcName);

 lea  ax, [ProcName]
 push ax
 call prs
 add  sp, 2

;-1398       isInProc=0;

 mov ax, 0
 mov byte [isInProc], al

;-1399       i = LabelMaxIx - localLabelMaxIx;

 mov ax, [LabelMaxIx]
 sub ax, [localLabelMaxIx]
 mov [bp-4], ax

;-1400       prs(". # local labels :");

 push process_4
 call prs
 add  sp, 2

;-1401       printIntU(i);

 push word [bp-4]
 call printIntU
 add  sp, 2

;-1402 // 1. close push string


;-1403 // 2. close open call/jmp


;-1404 // 3. delete all local labels


;-1405       return;

 jmp .retnprocess

;-1406     }


;-1407     error1("Command not implemented or syntax error");

.process350:
 push process_5
 call error1
 add  sp, 2

;-1408 }

 .retnprocess: LEAVE
 ret
process_0 db "pop cs not allowed",0
process_1 db "\n;entering: ",0
process_2 db "already in proc",0
process_3 db "\n;leaving: ",0
process_4 db ". # local labels :",0
process_5 db "Command not implemented or syntax error",0
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
;   56 var sign word    58   49 disp
;   57 var unsg word    59   13 imme
;   58 def unsg byte    61    - OPMAXLEN=5
;   59 arr sign byte    62    2 OpPos[5]
;   60 var sign word    63    6 OpPrintIndex
;   61 ptr sign byte    64   19 OpCodePtr
;   62 var sign byte    65    4 PrintRA
;   63 def unsg byte    67    - LABELNAMESMAX=3969
;   64 arr sign byte    68    3 LabelNames[4000]
;   65 ptr sign byte    69    6 LabelNamePtr
;   66 var unsg word    70    1 locLabelNamePtr
;   67 def unsg byte    71    - LABELADRMAX=600
;   68 arr unsg word    72    7 LabelAddr[600]
;   69 var sign word    73    9 LabelMaxIx
;   70 var sign word    74    2 localLabelMaxIx
;   71 var sign word    75   10 LabelIx
;   72 def unsg byte    77    - JMPCALLNAMESMAX=1969
;   73 arr sign byte    78    3 JmpCallNames[2000]
;   74 ptr sign byte    79    5 JmpCallNamePtr
;   75 def unsg byte    80    - JMPCALLMAX=500
;   76 arr unsg word    81    2 JmpCallAddr[500]
;   77 var sign word    82    6 JmpCallMaxIx
;   78 def unsg byte    84    - FILEBINMAX=20000
;   79 arr sign byte    85    4 FileBin[20000]
;   80 var unsg word    86    6 BinLen
;   81 ptr sign byte    88    1 arglen
;   82 ptr sign byte    89    4 argv
;   83 var sign byte    93    1 I_START
;   84 arr sign byte    96 NULL I_PUSHA[39424]
;   85 arr sign byte    97 NULL I_NOP[674]
;   86 arr sign byte    98 NULL I_CWDE[8125]
;   87 arr sign byte    99 NULL I_CDQ[24260]
;   88 arr sign byte   100 NULL I_PUSHF[9734]
;   89 arr sign byte   101 NULL I_SAHF[1931]
;   90 arr sign byte   102 NULL I_MOVSB[35622]
;   91 arr sign byte   103 NULL I_CMPSB[599]
;   92 arr sign byte   104 NULL I_STOSB[53495]
;   93 arr sign byte   105 NULL I_LODSB[54007]
;   94 arr sign byte   106 NULL I_SCASB[37]
;   95 arr sign byte   107 NULL I_LEAVE[27968]
;   96 arr sign byte   108 NULL I_INTO[26977]
;   97 arr sign byte   109 NULL I_XLAT[110]
;   98 arr sign byte   110 NULL I_REPNE[13644]
;   99 arr sign byte   111 NULL I_REPE[19456]
;  100 arr sign byte   112 NULL I_HLT[54]
;  101 arr sign byte   113 NULL I_STC[14156]
;  102 arr sign byte   114 NULL I_STI[19456]
;  103 arr sign byte   115 NULL I_STD[56]
;  104 arr sign byte   117 NULL I_INC[14412]
;  105 arr sign byte   118 NULL I_DEC[19456]
;  106 arr sign byte   119 NULL I_NOT[57]
;  107 arr sign byte   120 NULL I_NEG[14668]
;  108 arr sign byte   121 NULL I_MUL[17920]
;  109 arr sign byte   122 NULL I_IMUL[65534]
;  110 arr sign byte   123 NULL I_DIV[33791]
;  111 arr sign byte   124 NULL I_IDIV[65150]
;  112 arr sign byte   126 NULL I_LES[30207]
;  113 arr sign byte   127 NULL I_LDS[15642]
;  114 arr sign byte   128 NULL I_LEA[65535]
;  115 arr sign byte   129 NULL I_LSS[5493]
;  116 arr sign byte   130 NULL I_LFS[33574]
;  117 arr sign byte   131 NULL I_LGS[1151]
;  118 arr sign byte   133 NULL I_ADD[29696]
;  119 arr sign byte   134 NULL I_OR[35593]
;  120 arr sign byte   135 NULL I_ADC[2630]
;  121 arr sign byte   136 NULL I_SBB[14630]
;  122 arr sign byte   137 NULL I_AND[1095]
;  123 arr sign byte   138 NULL I_SUB[26997]
;  124 arr sign byte   139 NULL I_XOR[49203]
;  125 arr sign byte   140 NULL I_CMP[52169]
;  126 arr sign byte   141 NULL I_TEST[33680]
;  127 arr sign byte   143 NULL I_MOV[65150]
;  128 arr sign byte   144 NULL I_MOVSX[29729]
;  129 arr sign byte   145 NULL I_MOVZX[33618]
;  130 arr sign byte   147 NULL I_JO[65150]
;  131 arr sign byte   148 NULL I_JNO[29731]
;  132 arr sign byte   149 NULL I_JB[33612]
;  133 arr sign byte   150 NULL I_JNB[65150]
;  134 arr sign byte   151 NULL I_JAE[29732]
;  135 arr sign byte   152 NULL I_JE[33606]
;  136 arr sign byte   153 NULL I_JNE[65150]
;  137 arr sign byte   154 NULL I_JBE[29734]
;  138 arr sign byte   155 NULL I_JA[33600]
;  139 arr sign byte   156 NULL I_JS[65150]
;  140 arr sign byte   157 NULL I_JNS[29730]
;  141 arr sign byte   158 NULL I_JP[33594]
;  142 arr sign byte   159 NULL I_JNP[65150]
;  143 arr sign byte   160 NULL I_JL[29737]
;  144 arr sign byte   161 NULL I_JNL[33588]
;  145 arr sign byte   162 NULL I_JLE[65150]
;  146 arr sign byte   163 NULL I_JG[29736]
;  147 arr sign byte   165 NULL I_JMP[33582]
;  148 arr sign byte   166 NULL I_CALL[65150]
;  149 arr sign byte   168 NULL I_RET[29733]
;  150 arr sign byte   169 NULL I_RETF[15656]
;  151 arr sign byte   171 NULL I_PUSH[33]
;  152 arr sign byte   172 NULL I_POP[9076]
;  153 arr sign byte   174 NULL I_ROL[9021]
;  154 arr sign byte   175 NULL I_RCL[29696]
;  155 arr sign byte   176 NULL I_SHL[15646]
;  156 arr sign byte   177 NULL I_SHR[36]
;  157 arr sign byte   179 NULL I_INT[6516]
;  158 arr sign byte   181 NULL I_IN[9789]
;  159 arr sign byte   182 NULL I_INSB[29696]
;  160 arr sign byte   183 NULL I_INSW[15636]
;  161 arr sign byte   184 NULL I_INSD[34]
;  162 arr sign byte   185 NULL I_OUT[3956]
;  163 arr sign byte   186 NULL I_OUTSB[10557]
;  164 arr sign byte   187 NULL I_OUTSW[29696]
;  165 arr sign byte   188 NULL I_OUTSD[15626]
;  166 arr sign byte   190 NULL I_XCHG[40]
;  167 arr sign byte   192 NULL I_LOOPNZ[1396]
;  168 arr sign byte   193 NULL I_LOOPNE[9533]
;  169 arr sign byte   194 NULL I_LOOPZ[29952]
;  170 arr sign byte   195 NULL I_LOOPE[33542]
;  171 arr sign byte   196 NULL I_LOOP[2686]
;  172 arr sign byte   197 NULL I_JCXZ[60176]
;  173 arr sign byte   198 NULL I_JECXZ[33540]
;  174 arr sign byte   200 NULL I_ENTER[2686]
;  175 arr sign byte   202 NULL I_ORG[29984]
;  176 arr sign byte   204 NULL I_SECTION[47255]
;  177 arr sign byte   205 NULL I_SEGMENT[1]
;  178 arr sign byte   206 NULL I_ABSOLUTE[52169]
;  179 arr sign byte   207 NULL I_PROC[21904]
;  180 arr sign byte   208 NULL I_ENDP[60555]
;  181 arr sign byte   209 NULL I_DB[5816]
;  182 arr sign byte   210 NULL I_DW[39424]
;  183 arr sign byte   211 NULL I_DD[674]
;  184 arr sign byte   212 NULL I_RESB[8125]
;  185 arr sign byte   213 NULL I_RESW[51030]
;  186 arr sign byte   214 NULL I_RESD[65094]
;  187 var sign byte   215 NULL I_END


;   # Calls Line Width  Name   list of functions

;    0    2  219   ChangeDirection
;    1    2  227   checkOpL
;    2    4  236   check2Ops
;    3    1  245   get2Ops
;    4    3  251   getOpL
;    5    2  259   getOpR
;    6    4  269   getOp1
;    7    1  285   getMEM
;    8    1  308   getIndReg1
;    9    1  316   getIndReg2
;   10    2  326   setwflag
;   11    2  337   setsflag
;   12    2  347   checkConstSize
;   13    1  355   parse
;   14   16  391   getTokeType
;   15    2  402   storeJmpCall
;   16    2  413   storeLabel
;   17    5  425   searchLabel
;   18    1  438   getVariable
;   19    2  491   lookCode
;   20    1  507   getCodeSize
;   21    9  515   isToken
;   22    2  523   need
;   23    1  532   skipRest
;   24    4  539   writetty
;   25    1  540   putch
;   26    8  541   cputs
;   27    6  543   DosInt
;   28    1  548   openR
;   29    2  549   creatR
;   30    3  550   fcloseR
;   31    5  551   exitR
;   32    2  552   readRL
;   33    2  553   fputcR
;   34    1  556   getLine
;   35    1  572   ifEOL
;   36    3  581   skipBlank
;   37    2  586   letterE
;   38    1  596   alnumE
;   39    3  601   digit
;   40    4  606   strlen
;   41    9  611   strcpy
;   42   35  617   eqstr
;   43    3  626   strcat1
;   44    2  630   toupper
;   45    1  637   getDigit
;   46    1  649   getName
;   47    1  668   testReg
;   48    1  712   printLine
;   49    7  734   prc
;   50    1  744   prscomment
;   51   33  752   prs
;   52    3  774   printhex8a
;   53    2  779   printhex4
;   54    1  784   printhex16
;   55    6  789   printIntU
;   56   27  800   error1
;   57   13  807   errorexit
;   58 NULL  812   allowederror
;   59    3  813   addrerror
;   60    1  814   immeerror
;   61    2  815   implerror
;   62    4  816   indexerror
;   63    3  817   invaloperror
;   64    6  818   numbererror
;   65    1  819   regmemerror
;   66    3  820   reg16error
;   67    1  821   segregerror
;   68    5  822   syntaxerror
;   69 NULL  824   addrexit
;   70    3  825   dataexit
;   71 NULL  826   internexit
;   72 NULL  830   main
;   73    1  838   getarg
;   74    1  872   fixJmpCall
;   75    2  903   epilog
;   76    2  951   end1
;   77    1  961   getCodes
;   78    1  966   gen66h
;   79    8  968   genCode2
;   80   13  972   genCodeW
;   81   34  976   genCode8
;   82   18  987   genCode16
;   83    1  991   genCode32
;   84   13  995   writeEA
;   85    4 1037   genImmediate
;   86    1 1044   process
;   87 NULL 1408   LastFunctionByt

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
;   61   562 searchLabel
;   62   574 error1
;   63   581 errorexit
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
;  357  2941 genCode8
;  358  2950 genCode16
;  359  2960 error1
;  360  2967 genCode8
;  361  2976 genCode8
;  362  2985 checkOpL
;  363  2994 reg16error
;  364  3005 genCode2
;  365  3014 genCode8
;  366  3023 writeEA
;  367  3031 syntaxerror
;  368  3043 check2Ops
;  369  3053 genCodeW
;  370  3062 writeEA
;  371  3070 genCodeW
;  372  3079 writeEA
;  373  3087 genCode8
;  374  3096 genCodeW
;  375  3105 writeEA
;  376  3113 genCode8
;  377  3122 genCode8
;  378  3131 genCode8
;  379  3140 getOp1
;  380  3147 genCode16
;  381  3157 numbererror
;  382  3169 need
;  383  3174 getOp1
;  384  3181 genCode8
;  385  3190 numbererror
;  386  3202 numbererror
;  387  3214 numbererror
;  388  3226 prs
;  389  3230 prs
;  390  3234 error1
;  391  3241 prs
;  392  3245 prs
;  393  3249 prs
;  394  3253 printIntU
;  395  3263 error1
;Input: AS.C, List: AS.S,  Lines: 1409
;Glob. variables:  187 max.:  200
;Functions      :   88 max.:  300
;Calls          :  396 max.: 2000, NameField: 3270 max.:    65535
;Code until     :21667 max.: 30000, free: 8333
;Data (HeapEnd) :58754, resting stacksize:  6781
;Max. Const in 'testReg' :  658 max. 3000, free: 2342