
; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
;PROTECTED: 0 V86 OFF.  32bit: ON. 
org  256 ; NASM ON
jmp main

;-1 char Version1[]="AS.C V0.07";//BAS.BAT, AS TE, NAS.BAT

Version1 db "AS.C V0.07",0

;-2 #include "DECL.C"

;Use include file: DECL.C

;-1 char LIST;              //listing on/off     

LIST db 0

;-2 #define SYMBOLMAX    31


;-3 char Symbol[SYMBOLMAX]; //next symbol to decode

Symbol resb 31

;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName

SymbolUpper resb 31

;-5 unsigned int SymbolInt; //integer value set in getDigit

SymbolInt dw 0

;-6 #define INPUTBUFMAX 127


;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test

InputBuf resb 127

;-8 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0

;-9 char namein [67];       //input file name  .S

namein resb 67

;-10 char namelst[67];       //list file name   .LST

namelst resb 67

;-11 char namebin[67];       //output file name .COM

namebin resb 67

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


;-34 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110


;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16


;-36 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  

Op db 0

;-37 char Op2;               //2. operand

Op2 db 0

;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size

CodeType db 0

;-39 char Code1;             //1. Opcode

Code1 db 0

;-40 char Code2;             //2. Opcode

Code2 db 0

;-41 char Code3;             //3. Opcode

Code3 db 0

;-42 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  

R2No db 0

;-43 char R1No;              //temp for 1. register

R1No db 0

;-44 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG

R2Type db 0

;-45 char R1Type;            //temp for 1. register 

R1Type db 0

;-46 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0

;-47 char wflag;             //wordflag: 0=byte, 1=word/dword

wflag db 0

;-48 char dflag;             //directionflag: 1=to reg MOV,ALU    

dflag db 0

;-49 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 

sflag db 0

;-50 char rm;                //combination of index and base reg

rm db 0

;-51 char isDirect;          //set in getOpL and getMeM, need in WriteEA

isDirect db 0

;-52 int disp;               //displacement      0-8 bytes

disp dw 0

;-53 unsigned int imme;      //immediate         0-8 bytes

imme dw 0

;-54 


;-55 #define OPMAXLEN 5


;-56 char OpPos[OPMAXLEN];   //array for one opcode to list

OpPos resb 5

;-57 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0

;-58 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0

;-59 char PrintR;            //print 'R' if relocative

PrintR db 0

;-60 


;-61 #define LABELNAMESMAX 969//next number - 31


;-62 char LabelNames[1000];  //space for names of all labels

LabelNames resb 1000

;-63 char *LabelNamePtr;     // first free position

LabelNamePtr dw 0

;-64 #define LABELADRMAX 100


;-65 unsigned int LabelAddr[LABELADRMAX];//addr of each label

LabelAddr resw 100

;-66 int LabelMaxIx=0;       //actual number of stored labels

LabelMaxIx dw 0

;-67 int LabelIx;            //actual number of just searched label

LabelIx dw 0

;-68 


;-69 #define FILEBINMAX 2000 //next number - max. oplength


;-70 char FileBin  [FILEBINMAX];//output binary file

FileBin resb 2000

;-71 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-72 


;-73 char *arglen=0x80;      // for main only

arglen dw 128

;-74 char *argv=0x82;        // for main only

argv dw 130
;Back to main program: AS.C

;-3 #include "OPTABL.C"   

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

;-41 // 2: mem reg 16 bit


;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-50 //  3: les, lda, lea, lss, lfs, lgs


;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-57 //  4: acc,imm  reg,imm  index,reg


;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-67 //  5: mov


;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-69 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-70 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-71 //  6: single byte relative jump


;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};

I_JO db 74,79,0,6,0,241

;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};

I_JNO db 74,78,79,0,6,1,241

;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};

I_JB db 74,66,0,6,2,241

;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};

I_JC db 74,67,0,6,2,241

;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};

I_JNB db 74,78,66,0,6,3,241

;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};

I_JAE db 74,65,69,0,6,3,241

;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};

I_JNC db 74,78,67,0,6,3,241

;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel

I_JE db 74,69,0,6,4,241

;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r

I_JZ db 74,90,0,6,4,241

;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};

I_JNE db 74,78,69,0,6,5,241

;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};

I_JNZ db 74,78,90,0,6,5,241

;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};

I_JBE db 74,66,69,0,6,6,241

;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};

I_JNA db 74,78,65,0,6,6,241

;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};

I_JA db 74,65,0,6,7,241

;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};

I_JS db 74,83,0,6,8,241

;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};

I_JNS db 74,78,83,0,6,9,241

;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};

I_JP db 74,80,0,6,10,241

;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};

I_JPE db 74,80,69,0,6,10,241

;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};

I_JNP db 74,78,80,0,6,11,241

;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};

I_JPO db 74,80,79,0,6,11,241

;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};

I_JL db 74,76,0,6,12,241

;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};

I_JNL db 74,78,76,0,6,13,241

;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};

I_JGE db 74,71,69,0,6,13,241

;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};

I_JLE db 74,76,69,0,6,14,241

;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};

I_JNG db 74,78,71,0,6,14,241

;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};

I_JG db 74,71,0,6,15,241

;-98 //  7: jmp, call


;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-101 //  8: ret


;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-104 //  9: seg, r/m


;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,241

;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16

I_POP db 80,79,80,0,9,88,241

;-107 //  11: shift, rotates


;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};

I_ROL db 82,79,76,0,11,0,241

;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};

I_ROR db 82,79,82,0,11,1,241

;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};

I_RCL db 82,67,76,0,11,2,241

;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};

I_RCR db 82,67,82,0,11,3,241

;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};

I_SHL db 83,72,76,0,11,4,241

;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};

I_SAL db 83,65,76,0,11,5,241

;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};

I_SHR db 83,72,82,0,11,6,241

;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};

I_SAR db 83,65,82,0,11,7,241

;-116 //  12: int


;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};

I_INTO db 73,78,84,79,0,12,206,241

;-119 //  14: in/out


;-120 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};


;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};


;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};


;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};


;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};


;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};


;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};


;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/


;-128 //  15: xchg


;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-130 //  16: loop, jcxz


;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-138 //  30: enter


;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};

I_ENTER db 69,78,84,69,82,0,30,200,241

;-140 // 100: directives


;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-142 // section, segment .TEXT .DATA .BSS


;-143 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};


;-144 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};


;-145 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/


;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};

I_RESB db 82,69,83,66,0,205,241

;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};

I_RESW db 82,69,83,87,0,206,241

;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};

I_RESD db 82,69,83,68,0,207,241

;-152 char I_END=0;// end of table char

I_END db 0
;Back to main program: AS.C

;-4 #include "OPS.C"

;Use include file: OPS.C

;-1 int ChangeDirection() {


ChangeDirection:  ; *** PROC ***

;-2     char c;


;-3     c=Op;     Op    =Op2;    Op2   =c;

;Function : ChangeDirection, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte     2 NULL bp-2    c;
 ENTER  2,0
 mov al, [Op]
 mov byte [bp-2], al
 mov al, [Op2]
 mov byte [Op], al
 mov al, [bp-2]
 mov byte [Op2], al

;-4     c=R1Type; R1Type=R2Type; R2Type=c;

 mov al, [R1Type]
 mov byte [bp-2], al
 mov al, [R2Type]
 mov byte [R1Type], al
 mov al, [bp-2]
 mov byte [R2Type], al

;-5     c=R1No;   R1No  =R2No;   R2No  =c;

 mov al, [R1No]
 mov byte [bp-2], al
 mov al, [R2No]
 mov byte [R1No], al
 mov al, [bp-2]
 mov byte [R2No], al

;-6     dflag=2;     

 mov eax, 2
 mov byte [dflag], al

;-7 }


;-8      


;-9 int checkOpL() {
 LEAVE
 ret
; ENDP

checkOpL:  ; *** PROC ***

;-10     if (Op == ADR) implerror();

 mov al, [Op]
 cmp al, 3
 jne @@checkOpL1
 call implerror

;-11     if (R2Type == SEGREG) {segregerror(); return;}//only move,push,pop

@@checkOpL1:
 mov al, [R2Type]
 cmp al, 4
 jne @@checkOpL2
 call segregerror
 jmp @@retn

;-12     setwflag();

@@checkOpL2:
 call setwflag

;-13     if (OpSize == 0) error1("no op size declared");

 mov al, [OpSize]
 cmp al, 0
 jne @@checkOpL3
 push checkOpL_0
 call error1
 add  sp, 2

;-14     if (OpSize == R1Type) return;

@@checkOpL3:
 mov al, [OpSize]
 cmp al, [R1Type]
 jne @@checkOpL4
 jmp @@retn

;-15     if (OpSize){

@@checkOpL4:
 mov al, [OpSize]
 or  al, al
 je @@checkOpL5

;-16         if (Op == MEM) return;

 mov al, [Op]
 cmp al, 4
 jne @@checkOpL6
 jmp @@retn

;-17         error1("Conflict OpSize and RegSize"); 

@@checkOpL6:
 push checkOpL_1
 call error1
 add  sp, 2

;-18         }


;-19     if (R1Type==0) error1("no register defined");

@@checkOpL5:
 mov al, [R1Type]
 cmp al, 0
 jne @@checkOpL7
 push checkOpL_2
 call error1
 add  sp, 2

;-20 }

@@checkOpL7:

;-21     


;-22 int check2Ops() {

@@retn:
 ret
; ENDP
checkOpL_0 db "no op size declared",0
checkOpL_1 db "Conflict OpSize and RegSize",0
checkOpL_2 db "no register defined",0

check2Ops:  ; *** PROC ***

;-23     get2Ops();

 call get2Ops

;-24     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne @@check2Ops8
 call addrerror

;-25     if (Op == ADR) invaloperror(); 

@@check2Ops8:
 mov al, [Op]
 cmp al, 3
 jne @@check2Ops9
 call invaloperror

;-26     if (Op == IMM) immeerror();   

@@check2Ops9:
 mov al, [Op]
 cmp al, 1
 jne @@check2Ops10
 call immeerror

;-27     if (Op2==   0) addrerror();

@@check2Ops10:
 mov al, [Op2]
 cmp al, 0
 jne @@check2Ops11
 call addrerror

;-28 //    if (Op2== ADR) invaloperror();//allowed in mov           


;-29     setwflag();       

@@check2Ops11:
 call setwflag

;-30 }    


;-31 int get2Ops() {

 ret
; ENDP

get2Ops:  ; *** PROC ***

;-32     getOpL();

 call getOpL

;-33     need(',');    

 push 44
 call need
 add  sp, 2

;-34     getOpR();         

 call getOpR

;-35 } 


;-36         


;-37 int getOpL() {

 ret
; ENDP

getOpL:  ; *** PROC ***

;-38 //set: op=0,IMM,REG,ADR,MEM


;-39     disp=0; imme=0; isDirect=1; 

 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov word [imme], ax
 mov eax, 1
 mov byte [isDirect], al

;-40     getOpR();

 call getOpR

;-41     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov eax, 0
 mov byte [Op2], al

;-42     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov eax, 0
 mov byte [R2No], al

;-43     R1Type=R2Type; R2Type=0; 

 mov al, [R2Type]
 mov byte [R1Type], al
 mov eax, 0
 mov byte [R2Type], al

;-44 }  


;-45 


;-46 int getOpR() {

 ret
; ENDP

getOpR:  ; *** PROC ***

;-47     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-48     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je @@getOpR12
 mov eax, 4
 mov byte [Op2], al
 call getMEM
 jmp @@retn

;-49     if (Op2 == 0)     {invaloperror();         return;}

@@getOpR12:
 mov al, [Op2]
 cmp al, 0
 jne @@getOpR13
 call invaloperror
 jmp @@retn

;-50     if (Op2 == IMM)   {imme=SymbolInt;         return;}

@@getOpR13:
 mov al, [Op2]
 cmp al, 1
 jne @@getOpR14
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp @@retn

;-51     if (Op2 == REG)                            return;

@@getOpR14:
 mov al, [Op2]
 cmp al, 2
 jne @@getOpR15
 jmp @@retn

;-52     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}

@@getOpR15:
 mov al, [Op2]
 cmp al, 3
 jne @@getOpR16
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp @@retn

;-53     error1("Name of operand expected");

@@getOpR16:
 push getOpR_0
 call error1
 add  sp, 2

;-54 }


;-55 


;-56 int getOp1() {//scan for a single operand

@@retn:
 ret
; ENDP
getOpR_0 db "Name of operand expected",0

getOp1:  ; *** PROC ***

;-57 //return:0, IMM, REG, ADR (not MEM)


;-58 //set   :R2Type, R2No by testReg


;-59 //set   :LabelIx by searchLabel


;-60     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne @@getOp117
 mov eax, 0
 jmp @@retn

;-61     if (TokeType == DIGIT)  return IMM;

@@getOp117:
 mov al, [TokeType]
 cmp al, 1
 jne @@getOp118
 mov eax, 1
 jmp @@retn

;-62     if (TokeType == ALNUME) {

@@getOp118:
 mov al, [TokeType]
 cmp al, 3
 jne @@getOp119

;-63         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-64         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je @@getOp120
 mov eax, 2
 jmp @@retn

;-65         LabelIx=searchLabel();

@@getOp120:
 call searchLabel
 mov word [LabelIx], ax

;-66         if (LabelIx)        return ADR;

 mov ax, [LabelIx]
 or  al, al
 je @@getOp121
 mov eax, 3
 jmp @@retn

;-67         else error1("variable not found"); 

 jmp @@getOp122
@@getOp121:
 push getOp1_0
 call error1
 add  sp, 2

;-68     }

@@getOp122:

;-69     return 0;

@@getOp119:
 mov eax, 0
 jmp @@retn

;-70 }


;-71 


;-72 int getMEM() {// e.g. [array+bp+si-4]

@@retn:
 ret
; ENDP
getOp1_0 db "variable not found",0

getMEM:  ; *** PROC ***

;-73 //set: disp, rm, R2Type


;-74     char c;


;-75     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    74 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov byte [rm], al

;-76     do {

@@getMEM23:

;-77         getTokeType();

 call getTokeType

;-78         c=getOp1();

 call getOp1
 mov byte [bp-2], al

;-79         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne @@getMEM24
 call syntaxerror

;-80         if (c == REG) {isDirect=0;

@@getMEM24:
 mov al, [bp-2]
 cmp al, 2
 jne @@getMEM25
 mov eax, 0
 mov byte [isDirect], al

;-81             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je @@getMEM26
 call getIndReg2
 mov byte [rm], al

;-82             else getIndReg1();

 jmp @@getMEM27
@@getMEM26:
 call getIndReg1

;-83         }

@@getMEM27:

;-84         if (c == ADR) disp=disp+LabelAddr[LabelIx];

@@getMEM25:
 mov al, [bp-2]
 cmp al, 3
 jne @@getMEM28
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-85         if (c == IMM) disp=disp+SymbolInt;

@@getMEM28:
 mov al, [bp-2]
 cmp al, 1
 jne @@getMEM29
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-86         if (isToken('-')) {

@@getMEM29:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM30

;-87             getTokeType();

 call getTokeType

;-88             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  @@getMEM31
 call numbererror

;-89             disp = disp - SymbolInt;

@@getMEM31:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-90         }


;-91     } while (isToken('+'));

@@getMEM30:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM32
 jmp @@getMEM23
@@getMEM32:

;-92     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne @@getMEM33
 push getMEM_0
 call errorexit
 add  sp, 2

;-93 }

@@getMEM33:

;-94 int getIndReg1() {
 LEAVE
 ret
; ENDP
getMEM_0 db "] expected",0

getIndReg1:  ; *** PROC ***

;-95     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  @@getIndReg134
 call indexerror

;-96     if (R2No==3) rm=7;//BX

@@getIndReg134:
 mov al, [R2No]
 cmp al, 3
 jne @@getIndReg135
 mov eax, 7
 mov byte [rm], al

;-97     if (R2No==5) rm=6;//BP, change to BP+0

@@getIndReg135:
 mov al, [R2No]
 cmp al, 5
 jne @@getIndReg136
 mov eax, 6
 mov byte [rm], al

;-98     if (R2No==7) rm=5;//DI

@@getIndReg136:
 mov al, [R2No]
 cmp al, 7
 jne @@getIndReg137
 mov eax, 5
 mov byte [rm], al

;-99     if (R2No==6) rm=4;//SI

@@getIndReg137:
 mov al, [R2No]
 cmp al, 6
 jne @@getIndReg138
 mov eax, 4
 mov byte [rm], al

;-100     if (rm==0) indexerror();

@@getIndReg138:
 mov al, [rm]
 cmp al, 0
 jne @@getIndReg139
 call indexerror

;-101 }

@@getIndReg139:

;-102 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
; ENDP

getIndReg2:  ; *** PROC ***
;Function : getIndReg2, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   102 NULL bp-2    m;
 ENTER  2,0
 mov eax, 4
 mov byte [bp-2], al

;-103     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  @@getIndReg240
 call indexerror

;-104     if (R2No==7) if (rm==6) m=3;//BP+DI

@@getIndReg240:
 mov al, [R2No]
 cmp al, 7
 jne @@getIndReg241
 mov al, [rm]
 cmp al, 6
 jne @@getIndReg242
 mov eax, 3
 mov byte [bp-2], al

;-105              else if (rm==7) m=1;//BX+DI

 jmp @@getIndReg243
@@getIndReg242:
 mov al, [rm]
 cmp al, 7
 jne @@getIndReg244
 mov eax, 1
 mov byte [bp-2], al

;-106     if (R2No==6) if (rm==6) m=2;//BP+SI

@@getIndReg244:
@@getIndReg243:
@@getIndReg241:
 mov al, [R2No]
 cmp al, 6
 jne @@getIndReg245
 mov al, [rm]
 cmp al, 6
 jne @@getIndReg246
 mov eax, 2
 mov byte [bp-2], al

;-107              else if (rm==7) m=0;//BX+SI

 jmp @@getIndReg247
@@getIndReg246:
 mov al, [rm]
 cmp al, 7
 jne @@getIndReg248
 mov eax, 0
 mov byte [bp-2], al

;-108     if (m > 3) indexerror();

@@getIndReg248:
@@getIndReg247:
@@getIndReg245:
 mov al, [bp-2]
 cmp al, 3
 jle @@getIndReg249
 call indexerror

;-109     return m;

@@getIndReg249:
 mov al, [bp-2]
 jmp @@retn

;-110 }


;-111                   


;-112 int setwflag() {//word size, bit 0

@@retn: LEAVE
 ret
; ENDP

setwflag:  ; *** PROC ***

;-113     wflag=0;

 mov eax, 0
 mov byte [wflag], al

;-114     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne @@setwflag50

;-115         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne @@setwflag51
 mov al, [R1Type]
 mov byte [OpSize], al

;-116         if (Op2== REG) OpSize=R2Type;        

@@setwflag51:
 mov al, [Op2]
 cmp al, 2
 jne @@setwflag52
 mov al, [R2Type]
 mov byte [OpSize], al

;-117         if (R2Type== SEGREG) OpSize=WORD;

@@setwflag52:
 mov al, [R2Type]
 cmp al, 4
 jne @@setwflag53
 mov eax, 2
 mov byte [OpSize], al

;-118         if (R1Type == SEGREG) OpSize=WORD;        

@@setwflag53:
 mov al, [R1Type]
 cmp al, 4
 jne @@setwflag54
 mov eax, 2
 mov byte [OpSize], al

;-119     }

@@setwflag54:

;-120     if (OpSize  == DWORD) {gen66h(); wflag=1;}

@@setwflag50:
 mov al, [OpSize]
 cmp al, 3
 jne @@setwflag55
 call gen66h
 mov eax, 1
 mov byte [wflag], al

;-121     if (OpSize  ==  WORD) wflag=1;

@@setwflag55:
 mov al, [OpSize]
 cmp al, 2
 jne @@setwflag56
 mov eax, 1
 mov byte [wflag], al

;-122 }

@@setwflag56:

;-123 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3     

 ret
; ENDP

setsflag:  ; *** PROC ***

;-124     sflag=2;  

 mov eax, 2
 mov byte [sflag], al

;-125     if(imme > 127) sflag = 0;

 mov ax, [imme]
 cmp ax, 127
 jle @@setsflag57
 mov eax, 0
 mov byte [sflag], al

;-126     if (OpSize == BYTE) {

@@setsflag57:
 mov al, [OpSize]
 cmp al, 1
 jne @@setsflag58

;-127         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle @@setsflag59
 push setsflag_0
 call error1
 add  sp, 2

;-128         sflag=0;//byte reg does not need sign extended   

@@setsflag59:
 mov eax, 0
 mov byte [sflag], al

;-129     }


;-130 }

@@setsflag58:
 ret
; ENDP
setsflag_0 db "too big for byte r/m",0
;Back to main program: AS.C

;-5 #include "PARSE.C"

;Use include file: PARSE.C

;-1 int parse() {


parse:  ; *** PROC ***

;-2   LabelNamePtr= &LabelNames;

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-3   do {

@@parse60:

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
 jne @@parse61

;-9       if (isLabel) { //set in getName

 mov al, [isLabel]
 or  al, al
 je @@parse62

;-10         storeLabel();

 call storeLabel

;-11         InputPtr++;//remove :

 inc  word [InputPtr]

;-12         getTokeType();

 call getTokeType

;-13       }


;-14     }

@@parse62:

;-15     if (TokeType == ALNUME) {

@@parse61:
 mov al, [TokeType]
 cmp al, 3
 jne @@parse63

;-16       lookCode();// and OpCodePtr

 call lookCode

;-17       if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je @@parse64
 call process

;-18       else getVariable();

 jmp @@parse65
@@parse64:
 call getVariable

;-19       skipRest();

@@parse65:
 call skipRest

;-20     }


;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp @@parse66
@@parse63:
 mov al, [TokeType]
 cmp al, 3
 jle @@parse67
 push parse_0
 call error1
 add  sp, 2

;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");

 jmp @@parse68
@@parse67:
 mov al, [TokeType]
 cmp al, 1
 jne @@parse69
 push parse_1
 call error1
 add  sp, 2

;-23     printLine();

@@parse69:
@@parse68:
@@parse66:
 call printLine

;-24   } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  @@parse70
 jmp @@parse60
@@parse70:

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
 jne @@getTokeType71
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-31   if (c == ';') {TokeType=0; return; }//comment

@@getTokeType71:
 mov al, [bp-2]
 cmp al, 59
 jne @@getTokeType72
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

@@getTokeType72:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getTokeType73
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov eax, 1
 mov byte [TokeType], al
 jmp @@retn

;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

@@getTokeType73:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@getTokeType74
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov eax, 3
 mov byte [TokeType], al
 jmp @@retn

;-34   TokeType=NOALNUME; return;

@@getTokeType74:
 mov eax, 4
 mov byte [TokeType], al
 jmp @@retn

;-35 }


;-36 int storeLabel() {unsigned int i;

@@retn: LEAVE
 ret
; ENDP

storeLabel:  ; *** PROC ***

;-37   if(searchLabel()) error1("duplicate label");

;Function : storeLabel, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg word    36 NULL bp-2    i;
 ENTER  2,0
 call searchLabel
 or  al, al
 je @@storeLabel75
 push storeLabel_0
 call error1
 add  sp, 2

;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);

@@storeLabel75:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-39   LabelNamePtr++;

 inc  word [LabelNamePtr]

;-40   i = LabelNamePtr - &LabelNames;//todo

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov word [bp-2], ax

;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");

 mov ax, [bp-2]
 cmp ax, 969 ;unsigned : 0
 jb  @@storeLabel76
 push storeLabel_1
 call errorexit
 add  sp, 2

;-42   LabelMaxIx++;

@@storeLabel76:
 inc  word [LabelMaxIx]

;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 100 ;unsigned : 1
 jl  @@storeLabel77
 push storeLabel_2
 call errorexit
 add  sp, 2

;-44   LabelAddr[LabelMaxIx] = PC;

@@storeLabel77:
 mov ax, [PC]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-45 }


;-46 int searchLabel() {
 LEAVE
 ret
; ENDP
storeLabel_0 db "duplicate label",0
storeLabel_1 db "too long label names",0
storeLabel_2 db "too many labels",0

searchLabel:  ; *** PROC ***

;-47   int LIx; char *p; int j;


;-48   p = &LabelNames;

;Function : searchLabel, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word    47 NULL bp-2    LIx
;  201 ptr sign byte    47 NULL bp-4    p
;  202 var sign word    47 NULL bp-6    j;
 ENTER  6,0
 mov ax, LabelNames
 mov word [bp-4], ax

;-49   LIx=1;

 mov eax, 1
 mov word [bp-2], ax

;-50   while (LIx <= LabelMaxIx) {

@@searchLabel78:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel79

;-51     if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel80
 mov ax, [bp-2]
 jmp @@retn

;-52     j=strlen(p);

@@searchLabel80:
 push word [bp-4]
 call strlen
 add  sp, 2
 mov word [bp-6], ax

;-53     p=p+j; p++; LIx++;

 mov ax, [bp-4]
 add ax, [bp-6]
 mov word [bp-4], ax
 inc  word [bp-4]
 inc  word [bp-2]

;-54   }


;-55   return 0;

 jmp @@searchLabel78
@@searchLabel79:
 mov eax, 0
 jmp @@retn

;-56 }


;-57 int getVariable() { char c;

@@retn: LEAVE
 ret
; ENDP

getVariable:  ; *** PROC ***

;-58   storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    57 NULL bp-2    c;
 ENTER  2,0
 call storeLabel

;-59   getTokeType(); if(TokeType==ALNUME) {// getName

 call getTokeType
 mov al, [TokeType]
 cmp al, 3
 jne @@getVariable81

;-60     lookCode();

 call lookCode

;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");

 mov al, [CodeType]
 cmp al, 200
 jge @@getVariable82
 push getVariable_0
 call errorexit
 add  sp, 2

;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");

@@getVariable82:
 mov al, [CodeType]
 cmp al, 207
 jle @@getVariable83
 push getVariable_1
 call errorexit
 add  sp, 2

;-63     if (CodeType== 200) {// DB

@@getVariable83:
 mov al, [CodeType]
 cmp al, 200
 jne @@getVariable84

;-64       do { getTokeType();

@@getVariable85:
 call getTokeType

;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable86
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-66         else {

 jmp @@getVariable87
@@getVariable86:

;-67           skipBlank();

 call skipBlank

;-68           if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable88

;-69             do { c= *InputPtr;

@@getVariable89:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-70               genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-71               InputPtr++;

 inc  word [InputPtr]

;-72             } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  @@getVariable90
 jmp @@getVariable89
@@getVariable90:

;-73             InputPtr++;

 inc  word [InputPtr]

;-74           }


;-75         }

@@getVariable88:

;-76       } while (isToken(','));

@@getVariable87:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable91
 jmp @@getVariable85
@@getVariable91:

;-77     }


;-78     if (CodeType== 201) {// DW

@@getVariable84:
 mov al, [CodeType]
 cmp al, 201
 jne @@getVariable92

;-79       do { getTokeType();

@@getVariable93:
 call getTokeType

;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable94
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-81       } while (isToken(','));

@@getVariable94:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable95
 jmp @@getVariable93
@@getVariable95:

;-82     }


;-83   }

@@getVariable92:

;-84   else errorexit("DB,DW,DD or RESB,W,D expected");

 jmp @@getVariable96
@@getVariable81:
 push getVariable_2
 call errorexit
 add  sp, 2

;-85 }

@@getVariable96:

;-86 int lookCode() { // ret: CodeType, *OpCodePtr
 LEAVE
 ret
; ENDP
getVariable_0 db "D or RES B,W,D expected",0
getVariable_1 db "D or RES B,W,D expected",0
getVariable_2 db "DB,DW,DD or RESB,W,D expected",0

lookCode:  ; *** PROC ***

;-87   CodeType=0;

 mov eax, 0
 mov byte [CodeType], al

;-88   OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-89   OpCodePtr++;

 inc  word [OpCodePtr]

;-90   do  {

@@lookCode97:

;-91     if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode98

;-92       while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode99:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode100
 inc  word [OpCodePtr]

;-93       OpCodePtr++; CodeType =*OpCodePtr;

 jmp @@lookCode99
@@lookCode100:
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-94       return;

 jmp @@retn

;-95     }


;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode98:
@@lookCode101:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode102
 inc  word [OpCodePtr]

;-97   OpCodePtr++;

 jmp @@lookCode101
@@lookCode102:
 inc  word [OpCodePtr]

;-98   } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode103
 jmp @@lookCode97
@@lookCode103:

;-99 }


;-100 


;-101 int getCodeSize() {

@@retn:
 ret
; ENDP

getCodeSize:  ; *** PROC ***

;-102   if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@getCodeSize104

;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize105
 call getTokeType
 mov eax, 1
 jmp @@retn

;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

@@getCodeSize105:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize106
 call getTokeType
 mov eax, 2
 jmp @@retn

;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

@@getCodeSize106:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize107
 call getTokeType
 mov eax, 3
 jmp @@retn

;-106   } return 0;

@@getCodeSize107:
@@getCodeSize104:
 mov eax, 0
 jmp @@retn

;-107 }


;-108 int isToken(char c) {

@@retn:
 ret
; ENDP
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0

isToken:  ; *** PROC ***

;-109   skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   108 NULL bp+4    c;
 ENTER  0,0
 call skipBlank

;-110   if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne @@isToken108

;-111     InputPtr++; return 1;} return 0;

 inc  word [InputPtr]
 mov eax, 1
 jmp @@retn
@@isToken108:
 mov eax, 0
 jmp @@retn

;-112 }


;-113 int need(char c) {

@@retn: LEAVE
 ret
; ENDP

need:  ; *** PROC ***

;-114   if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   113 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je @@need109

;-115       getTokeType();

 call getTokeType

;-116       return;

 jmp @@retn

;-117       }


;-118   error1();

@@need109:
 call error1

;-119   prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-120   prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-121 }


;-122 


;-123 int skipRest() {

@@retn: LEAVE
 ret
; ENDP
need_0 db ". need: ",0

skipRest:  ; *** PROC ***

;-124   getTokeType(); 

 call getTokeType

;-125   if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je @@skipRest110
 push skipRest_0
 call error1
 add  sp, 2

;-126 }

@@skipRest110:
 ret
; ENDP
skipRest_0 db "extra char ignored",0
;Back to main program: AS.C

;-6 #include "HELPER.C"

;Use include file: HELPER.C

;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13


getLine:  ; *** PROC ***

;-2   unsigned int i;


;-3   InputPtr= &InputBuf;

;Function : getLine, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg word     2 NULL bp-2    i;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-4   *InputPtr=0;//if last line is empty

 mov eax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-5   do {

@@getLine111:

;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-7     if (DOS_ERR) errorexit("Reading Source");

 mov ax, [DOS_ERR]
 or  al, al
 je @@getLine112
 push getLine_0
 call errorexit
 add  sp, 2

;-8     if (DOS_NoBytes == 0) return;

@@getLine112:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne @@getLine113
 jmp @@retn

;-9     *InputPtr = DOS_ByteRead;

@@getLine113:
 mov al, [DOS_ByteRead]
 mov  bx, [InputPtr]
 mov  [bx], al

;-10     InputPtr++;

 inc  word [InputPtr]

;-11     i = InputPtr - &InputBuf;

 mov ax, [InputPtr]
 sub ax, InputBuf
 mov word [bp-2], ax

;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");

 mov ax, [bp-2]
 cmp ax, 127 ;unsigned : 0
 jb  @@getLine114
 push getLine_1
 call errorexit
 add  sp, 2

;-13   } while (ifEOL(DOS_ByteRead) == 0);

@@getLine114:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne @@getLine115
 jmp @@getLine111
@@getLine115:

;-14   InputPtr--;

 dec  word [InputPtr]

;-15   *InputPtr=0;

 mov eax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-16 }


;-17 int ifEOL(char c) {

@@retn: LEAVE
 ret
; ENDP
getLine_0 db "Reading Source",0
getLine_1 db "input line too long",0

ifEOL:  ; *** PROC ***

;-18   if (c == 10) return 1;

;Function : ifEOL, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    17 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne @@ifEOL116
 mov eax, 1
 jmp @@retn

;-19   if (c == 13) {

@@ifEOL116:
 mov al, [bp+4]
 cmp al, 13
 jne @@ifEOL117

;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);

 push 1
 push word [asm_fd]
 lea  ax, [DOS_ByteRead]
 push ax
 call readRL
 add  sp, 6
 mov word [DOS_NoBytes], ax

;-21     return 1;}

 mov eax, 1
 jmp @@retn

;-22   return 0;

@@ifEOL117:
 mov eax, 0
 jmp @@retn

;-23 }


;-24 int skipBlank() {

@@retn: LEAVE
 ret
; ENDP

skipBlank:  ; *** PROC ***

;-25   skipblank1:

@@skipblank1:

;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 32
 jne @@skipBlank118
 inc  word [InputPtr]
 jmp @@skipblank1

;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

@@skipBlank118:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne @@skipBlank119
 inc  word [InputPtr]
 jmp @@skipblank1

;-28 }

@@skipBlank119:

;-29 int letterE(char c) {

 ret
; ENDP

letterE:  ; *** PROC ***

;-30   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    29 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne @@letterE120
 mov eax, 1
 jmp @@retn

;-31   if (c=='.') return 1;

@@letterE120:
 mov al, [bp+4]
 cmp al, 46
 jne @@letterE121
 mov eax, 1
 jmp @@retn

;-32   if (c=='?') return 1;

@@letterE121:
 mov al, [bp+4]
 cmp al, 63
 jne @@letterE122
 mov eax, 1
 jmp @@retn

;-33   if (c=='$') return 1;

@@letterE122:
 mov al, [bp+4]
 cmp al, 36
 jne @@letterE123
 mov eax, 1
 jmp @@retn

;-34   if (c> 'z') return 0;

@@letterE123:
 mov al, [bp+4]
 cmp al, 122
 jle @@letterE124
 mov eax, 0
 jmp @@retn

;-35   if (c< '@') return 0; // at included

@@letterE124:
 mov al, [bp+4]
 cmp al, 64
 jge @@letterE125
 mov eax, 0
 jmp @@retn

;-36   if (c> 'Z') { if (c< 'a') return 0; }

@@letterE125:
 mov al, [bp+4]
 cmp al, 90
 jle @@letterE126
 mov al, [bp+4]
 cmp al, 97
 jge @@letterE127
 mov eax, 0
 jmp @@retn
@@letterE127:

;-37   return 1;

@@letterE126:
 mov eax, 1
 jmp @@retn

;-38 }


;-39 int alnumE(char c) {

@@retn: LEAVE
 ret
; ENDP

alnumE:  ; *** PROC ***

;-40   if (digit(c)) return 1;

;Function : alnumE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    39 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@alnumE128
 mov eax, 1
 jmp @@retn

;-41   if (letterE(c)) return 1;

@@alnumE128:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@alnumE129
 mov eax, 1
 jmp @@retn

;-42   return 0;

@@alnumE129:
 mov eax, 0
 jmp @@retn

;-43 }


;-44 int getDigit(unsigned char c) {//ret: SymbolInt

@@retn: LEAVE
 ret
; ENDP

getDigit:  ; *** PROC ***

;-45   unsigned int CastInt;


;-46   SymbolInt=0;

;Function : getDigit, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    44 NULL bp+4    c
;  201 var unsg word    45 NULL bp-2    CastInt;
 ENTER  2,0
 mov eax, 0
 mov word [SymbolInt], ax

;-47   do {

@@getDigit130:

;-48     c-='0';

 sub  byte [bp+4], 48

;-49     SymbolInt=SymbolInt*10;

 mov ax, [SymbolInt]
 mov ebx, 10
 mul ebx
 mov word [SymbolInt], ax

;-50     ax=0; CastInt=c; //cast b2w

 mov  ax, 0
 mov al, [bp+4]
 mov word [bp-2], ax

;-51     SymbolInt=SymbolInt+CastInt;

 mov ax, [SymbolInt]
 add ax, [bp-2]
 mov word [SymbolInt], ax

;-52     InputPtr++;

 inc  word [InputPtr]

;-53     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-54   } while(digit(c));

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getDigit131
 jmp @@getDigit130
@@getDigit131:

;-55 }


;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
 LEAVE
 ret
; ENDP

getName:  ; *** PROC ***

;-57   char *p; unsigned int i;


;-58   p = &Symbol;

;Function : getName, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    56 NULL bp+4    c
;  201 ptr sign byte    57 NULL bp-2    p
;  202 var unsg word    57 NULL bp-4    i;
 ENTER  4,0
 mov ax, Symbol
 mov word [bp-2], ax

;-59   *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-60   p++;

 inc  word [bp-2]

;-61   while (alnumE(c)) {

@@getName132:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je @@getName133

;-62     InputPtr++;

 inc  word [InputPtr]

;-63     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp+4], al

;-64     *p = c;

 mov al, [bp+4]
 mov  bx, [bp-2]
 mov  [bx], al

;-65     p++;

 inc  word [bp-2]

;-66     i = p - &Symbol;

 mov ax, [bp-2]
 sub ax, Symbol
 mov word [bp-4], ax

;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");

 mov ax, [bp-4]
 cmp ax, 31 ;unsigned : 0
 jb  @@getName134
 push getName_0
 call errorexit
 add  sp, 2

;-68   }

@@getName134:

;-69   if (c == ':') isLabel=1; else isLabel=0;

 jmp @@getName132
@@getName133:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName135
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName136
@@getName135:
 mov eax, 0
 mov byte [isLabel], al

;-70   p--;

@@getName136:
 dec  word [bp-2]

;-71   *p = 0;

 mov eax, 0
 mov  bx, [bp-2]
 mov  [bx], al

;-72   strcpy(SymbolUpper, Symbol);

 lea  ax, [Symbol]
 push ax
 lea  ax, [SymbolUpper]
 push ax
 call strcpy
 add  sp, 4

;-73   toupper(SymbolUpper);

 lea  ax, [SymbolUpper]
 push ax
 call toupper
 add  sp, 2

;-74 }


;-75 int testReg() {
 LEAVE
 ret
; ENDP
getName_0 db "symbol too long",0

testReg:  ; *** PROC ***

;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD


;-77   R2Type=0;

 mov eax, 0
 mov byte [R2Type], al

;-78   if (strlen(Symbol) < 2) return 0;

 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 2
 jge @@testReg137
 mov eax, 0
 jmp @@retn

;-79   if (strlen(Symbol) > 3) return 0;

@@testReg137:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg138
 mov eax, 0
 jmp @@retn

;-80   R2Type=BYTE;

@@testReg138:
 mov eax, 1
 mov byte [R2Type], al

;-81   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg139
 mov eax, 0
 jmp @@retn

;-82   if (eqstr(SymbolUpper, "CL")) return 1;

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

;-83   if (eqstr(SymbolUpper, "DL")) return 2;

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

;-84   if (eqstr(SymbolUpper, "BL")) return 3;

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

;-85   if (eqstr(SymbolUpper, "AH")) return 4;

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

;-86   if (eqstr(SymbolUpper, "CH")) return 5;

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

;-87   if (eqstr(SymbolUpper, "DH")) return 6;

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

;-88   if (eqstr(SymbolUpper, "BH")) return 7;

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

;-89   R2Type=WORD;

@@testReg146:
 mov eax, 2
 mov byte [R2Type], al

;-90   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg147
 mov eax, 0
 jmp @@retn

;-91   if (eqstr(SymbolUpper, "CX")) return 1;

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

;-92   if (eqstr(SymbolUpper, "DX")) return 2;

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

;-93   if (eqstr(SymbolUpper, "BX")) return 3;

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

;-94   if (eqstr(SymbolUpper, "SP")) return 4;

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

;-95   if (eqstr(SymbolUpper, "BP")) return 5;

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

;-96   if (eqstr(SymbolUpper, "SI")) return 6;

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

;-97   if (eqstr(SymbolUpper, "DI")) return 7;

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

;-98   R2Type=SEGREG;

@@testReg154:
 mov eax, 4
 mov byte [R2Type], al

;-99   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 0
 jmp @@retn

;-100   if (eqstr(SymbolUpper, "CS")) return 1;

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

;-101   if (eqstr(SymbolUpper, "SS")) return 2;

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

;-102   if (eqstr(SymbolUpper, "DS")) return 3;

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

;-103   if (eqstr(SymbolUpper, "FS")) return 4;

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

;-104   if (eqstr(SymbolUpper, "GS")) return 5;

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

;-105   R2Type=DWORD;                         

@@testReg160:
 mov eax, 3
 mov byte [R2Type], al

;-106   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg161
 mov eax, 0
 jmp @@retn

;-107   if (eqstr(SymbolUpper, "ECX"))return 1;

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

;-108   if (eqstr(SymbolUpper, "EDX"))return 2;

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

;-109   if (eqstr(SymbolUpper, "EBX"))return 3;

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

;-110   if (eqstr(SymbolUpper, "ESP"))return 4;

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

;-111   if (eqstr(SymbolUpper, "EBP"))return 5;

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

;-112   if (eqstr(SymbolUpper, "ESI"))return 6;

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

;-113   if (eqstr(SymbolUpper, "EDI"))return 7;

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

;-114   R2Type=0; return 0;

@@testReg168:
 mov eax, 0
 mov byte [R2Type], al
 mov eax, 0
 jmp @@retn

;-115 }

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

;-7 #include "OUTPUT.C"

;Use include file: OUTPUT.C

;-1 int printLine() { 


printLine:  ; *** PROC ***

;-2     int i; char c;


;-3     prs("\n"); 

;Function : printLine, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign word     2 NULL bp-2    i
;  201 var sign byte     2 NULL bp-4    c;
 ENTER  4,0
 push printLine_0
 call prs
 add  sp, 2

;-4     printhex16(PCStart);

 push word [PCStart]
 call printhex16
 add  sp, 2

;-5     if (OpPrintIndex == 0) prs("                ");

 mov ax, [OpPrintIndex]
 cmp ax, 0
 jne @@printLine169
 push printLine_1
 call prs
 add  sp, 2

;-6     else {

 jmp @@printLine170
@@printLine169:

;-7         prc(PrintR);

 mov al, byte [PrintR]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-8         i=0;

 mov eax, 0
 mov word [bp-2], ax

;-9         do {

@@printLine171:

;-10             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov byte [bp-4], al

;-11             printhex8a(c); 

 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call printhex8a
 add  sp, 2

;-12             prc(' ');

 push 32
 call prc
 add  sp, 2

;-13             i++;

 inc  word [bp-2]

;-14         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge @@printLine172
 jmp @@printLine171
@@printLine172:

;-15         do {// fill rest with blank

@@printLine173:

;-16             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-17             i++;

 inc  word [bp-2]

;-18         } while (i < OPMAXLEN);

 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine174
 jmp @@printLine173
@@printLine174:

;-19     }


;-20     prscomment(InputBuf);

@@printLine170:
 lea  ax, [InputBuf]
 push ax
 call prscomment
 add  sp, 2

;-21 }


;-22 int prc(unsigned char c) {//print char 
 LEAVE
 ret
; ENDP
printLine_0 db "\n",0
printLine_1 db "                ",0
printLine_2 db "   ",0

prc:  ; *** PROC ***

;-23     if (LIST) { 

;Function : prc, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    22 NULL bp+4    c;
 ENTER  0,0
 mov al, [LIST]
 or  al, al
 je @@prc175

;-24         if ( _ c==10) {

cmp byte [bp+4], 10
 jne @@prc176

;-25             ax=13; 

 mov  ax, 13

;-26             writetty(); 

 call writetty

;-27             }


;-28         al=c; 

@@prc176:
 mov  al, [bp+4]

;-29         writetty(); 

 call writetty

;-30         }


;-31     fputcR(c,lst_fd); 

@@prc175:
 push word [lst_fd]
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-32 }


;-33 


;-34 int prscomment(unsigned char *s) {
 LEAVE
 ret
; ENDP

prscomment:  ; *** PROC ***

;-35     unsigned char c;


;-36     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte    34 NULL bp+4    s
;  201 var unsg byte    35 NULL bp-2    c;
 ENTER  2,0
@@prscomment177:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment178

;-37         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-38         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-39         s++;

 inc  word [bp+4]

;-40     }


;-41 }

 jmp @@prscomment177
@@prscomment178:

;-42 int prs(unsigned char *s) {
 LEAVE
 ret
; ENDP

prs:  ; *** PROC ***

;-43     unsigned char c; 


;-44     int com; 


;-45     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr unsg byte    42 NULL bp+4    s
;  201 var unsg byte    43 NULL bp-2    c
;  202 var sign word    44 NULL bp-4    com;
 ENTER  4,0
 mov eax, 0
 mov word [bp-4], ax

;-46     while (*s) { 

@@prs179:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs180

;-47         c=*s; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-48         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne @@prs181

;-49             if (com) com=0; 

 mov ax, [bp-4]
 or  al, al
 je @@prs182
 mov eax, 0
 mov word [bp-4], ax

;-50                 else com=1;  

 jmp @@prs183
@@prs182:
 mov eax, 1
 mov word [bp-4], ax

;-51         }

@@prs183:

;-52         if (c==92) { 

@@prs181:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs184

;-53             if (com==0) { 

 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs185

;-54                 s++; 

 inc  word [bp+4]

;-55                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-56                 if (c=='n') c=10; 

 mov al, [bp-2]
 cmp al, 110
 jne @@prs186
 mov eax, 10
 mov byte [bp-2], al

;-57                 if (c=='t') c= 9; 

@@prs186:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs187
 mov eax, 9
 mov byte [bp-2], al

;-58             } 

@@prs187:

;-59         } 

@@prs185:

;-60         prc(c); 

@@prs184:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-61         s++;  

 inc  word [bp+4]

;-62     }


;-63 }

 jmp @@prs179
@@prs180:

;-64 int printhex8a(unsigned char c) { 
 LEAVE
 ret
; ENDP

printhex8a:  ; *** PROC ***

;-65     unsigned char nib;


;-66     nib = c >> 4; printhex4(nib);                    

;Function : printhex8a, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    64 NULL bp+4    c
;  201 var unsg byte    65 NULL bp-2    nib;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-67     nib = c & 15; printhex4(nib);                    

 mov al, [bp+4]
 and al, 15
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-68 } 


;-69 int printhex4(unsigned char c) {
 LEAVE
 ret
; ENDP

printhex4:  ; *** PROC ***

;-70     c += 48; 

;Function : printhex4, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg byte    69 NULL bp+4    c;
 ENTER  0,0
 add  byte [bp+4], 48

;-71     if (c > 57) c += 7; 

 mov al, [bp+4]
 cmp al, 57
 jle @@printhex4188
 add  byte [bp+4], 7

;-72     prc(c);      

@@printhex4188:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-73 }


;-74 int printhex16(unsigned int i) {
 LEAVE
 ret
; ENDP

printhex16:  ; *** PROC ***

;-75     unsigned int half;


;-76     half = i >>  8; printhex8a(half); 

;Function : printhex16, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word    74 NULL bp+4    i
;  201 var unsg word    75 NULL bp-2    half;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov word [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-77     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov word [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-78 }


;-79 int printIntU(unsigned int n) { 
 LEAVE
 ret
; ENDP

printIntU:  ; *** PROC ***

;-80     unsigned int e;


;-81     if ( _ n >= 10) {  

;Function : printIntU, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var unsg word    79 NULL bp+4    n
;  201 var unsg word    80 NULL bp-2    e;
 ENTER  2,0
cmp word [bp+4], 10 ;unsigned : 0
 jb  @@printIntU189

;-82         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov word [bp-2], ax

;-83         printIntU(e); 

 push word [bp-2]
 call printIntU
 add  sp, 2

;-84     }


;-85     n = n % 10; //unsigned mod

@@printIntU189:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov word [bp+4], ax

;-86     n += '0'; 

 add  word [bp+4], 48

;-87     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-88 }


;-89 


;-90 int error1(char *s) { 
 LEAVE
 ret
; ENDP

error1:  ; *** PROC ***

;-91     LIST=1; 

;Function : error1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte    90 NULL bp+4    s;
 ENTER  0,0
 mov eax, 1
 mov byte [LIST], al

;-92     ErrorCount++;

 inc  word [ErrorCount]

;-93     prs("\n;***** next line ERROR: "); 

 push error1_0
 call prs
 add  sp, 2

;-94     prs(s);

 push word [bp+4]
 call prs
 add  sp, 2

;-95     prs(", Symbol: "); 

 push error1_1
 call prs
 add  sp, 2

;-96     prs(Symbol);

 lea  ax, [Symbol]
 push ax
 call prs
 add  sp, 2

;-97 }


;-98 int errorexit(char *s) { 
 LEAVE
 ret
; ENDP
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0

errorexit:  ; *** PROC ***

;-99     error1(s); 

;Function : errorexit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte    98 NULL bp+4    s;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-100     end1(1);

 push 1
 call end1
 add  sp, 2

;-101 }


;-102 int allowederror() {error1("not allowed here"); }
 LEAVE
 ret
; ENDP

allowederror:  ; *** PROC ***
 push allowederror_0
 call error1
 add  sp, 2

;-103 int addrerror()    {error1("address missing");} 

 ret
; ENDP
allowederror_0 db "not allowed here",0

addrerror:  ; *** PROC ***
 push addrerror_0
 call error1
 add  sp, 2

;-104 int immeerror()    {error1("immediate not allowed here");}

 ret
; ENDP
addrerror_0 db "address missing",0

immeerror:  ; *** PROC ***
 push immeerror_0
 call error1
 add  sp, 2

;-105 int implerror()    {error1("not implemented");}

 ret
; ENDP
immeerror_0 db "immediate not allowed here",0

implerror:  ; *** PROC ***
 push implerror_0
 call error1
 add  sp, 2

;-106 int indexerror()   {error1("invalid index register");}

 ret
; ENDP
implerror_0 db "not implemented",0

indexerror:  ; *** PROC ***
 push indexerror_0
 call error1
 add  sp, 2

;-107 int invaloperror() {error1("invalid or no operands");}

 ret
; ENDP
indexerror_0 db "invalid index register",0

invaloperror:  ; *** PROC ***
 push invaloperror_0
 call error1
 add  sp, 2

;-108 int numbererror()  {error1("number expected");}

 ret
; ENDP
invaloperror_0 db "invalid or no operands",0

numbererror:  ; *** PROC ***
 push numbererror_0
 call error1
 add  sp, 2

;-109 int regmemerror()  {error1("only register or memory allowed");}

 ret
; ENDP
numbererror_0 db "number expected",0

regmemerror:  ; *** PROC ***
 push regmemerror_0
 call error1
 add  sp, 2

;-110 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
; ENDP
regmemerror_0 db "only register or memory allowed",0

reg16error:  ; *** PROC ***
 push reg16error_0
 call error1
 add  sp, 2

;-111 int segregerror()  {error1("segment register not allowed");}

 ret
; ENDP
reg16error_0 db "only reg16, no segreg allowed",0

segregerror:  ; *** PROC ***
 push segregerror_0
 call error1
 add  sp, 2

;-112 int syntaxerror()  {error1("syntax");}

 ret
; ENDP
segregerror_0 db "segment register not allowed",0

syntaxerror:  ; *** PROC ***
 push syntaxerror_0
 call error1
 add  sp, 2

;-113          


;-114 int addrexit()     {errorexit("illegal address");}

 ret
; ENDP
syntaxerror_0 db "syntax",0

addrexit:  ; *** PROC ***
 push addrexit_0
 call errorexit
 add  sp, 2

;-115 int internexit()   {errorexit("intern compiler error");}

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

;-8 #include "MAIN.C"

;Use include file: MAIN.C

;-1 int main() {


main:  ; *** PROC ***

;-2     getarg(); 

 call getarg

;-3     parse(); 

 call parse

;-4     epilog(); 

 call epilog

;-5     end1();

 call end1

;-6 }


;-7 


;-8 int getarg() { 

 ret
; ENDP

getarg:  ; *** PROC ***

;-9     int arglen1; int i; char *c;


;-10     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word     9 NULL bp-2    arglen1
;  201 var sign word     9 NULL bp-4    i
;  202 ptr sign byte     9 NULL bp-6    c;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov word [bp-2], ax

;-11     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne @@getarg190

;-12         cputs(Version1);

 lea  ax, [Version1]
 push ax
 call cputs
 add  sp, 2

;-13         cputs(", Usage: AS.COM filename [w/o .S] : ");

 push getarg_0
 call cputs
 add  sp, 2

;-14         exitR(3);

 push 3
 call exitR
 add  sp, 2

;-15     }


;-16     i=arglen1+129; 

@@getarg190:
 mov ax, [bp-2]
 add ax, 129
 mov word [bp-4], ax

;-17     *i=0;  

 mov eax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-18     arglen1--;

 dec  word [bp-2]

;-19     toupper(argv);

 push word [argv]
 call toupper
 add  sp, 2

;-20   


;-21     strcpy(namein, argv); strcat1(namein, ".S");

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

;-22     strcpy(namelst,argv); strcat1(namelst,".LST");

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

;-23     strcpy(namebin,argv); strcat1(namebin,".COM");

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

;-24 


;-25     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;

 mov eax, 1
 mov byte [LIST], al
 mov eax, 0
 mov word [DOS_ERR], ax
 mov eax, 0
 mov word [PC], ax
 mov eax, 0
 mov word [ErrorCount], ax

;-26   


;-27     asm_fd=openR (namein);

 lea  ax, [namein]
 push ax
 call openR
 add  sp, 2
 mov word [asm_fd], ax

;-28     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg191
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

;-29     lst_fd=creatR(namelst);

@@getarg191:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg192
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

;-31     bin_fd=creatR(namebin);

@@getarg192:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg193
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

;-33   


;-34     prs(";"); 

@@getarg193:
 push getarg_7
 call prs
 add  sp, 2

;-35     prs(Version1);

 lea  ax, [Version1]
 push ax
 call prs
 add  sp, 2

;-36     prs(", Source: "); prs(namein);  

 push getarg_8
 call prs
 add  sp, 2
 lea  ax, [namein]
 push ax
 call prs
 add  sp, 2

;-37     prs(", Output: "); prs(namelst);

 push getarg_9
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-38     prs(", "); prs(namebin);

 push getarg_10
 call prs
 add  sp, 2
 lea  ax, [namebin]
 push ax
 call prs
 add  sp, 2

;-39     prs("\n");

 push getarg_11
 call prs
 add  sp, 2

;-40 }


;-41 


;-42 int epilog() { 
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

;-43     int i; int j; char c;


;-44     prs("\n;END Errors: "); 

;Function : epilog, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 var sign word    43 NULL bp-2    i
;  201 var sign word    43 NULL bp-4    j
;  202 var sign byte    43 NULL bp-6    c;
 ENTER  6,0
 push epilog_0
 call prs
 add  sp, 2

;-45     printIntU(ErrorCount);

 push word [ErrorCount]
 call printIntU
 add  sp, 2

;-46     if (ErrorCount) prs(" ***ERROR*** ");

 mov ax, [ErrorCount]
 or  al, al
 je @@epilog194
 push epilog_1
 call prs
 add  sp, 2

;-47     prs(", Output: "); prs(namelst);

@@epilog194:
 push epilog_2
 call prs
 add  sp, 2
 lea  ax, [namelst]
 push ax
 call prs
 add  sp, 2

;-48     prs(", COM file "); 

 push epilog_3
 call prs
 add  sp, 2

;-49     printIntU(BinLen); 

 push word [BinLen]
 call printIntU
 add  sp, 2

;-50     prs(" bytes.");

 push epilog_4
 call prs
 add  sp, 2

;-51 


;-52     i=0;

 mov eax, 0
 mov word [bp-2], ax

;-53     do {

@@epilog195:

;-54         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov byte [bp-6], al

;-55         fputcR(c, bin_fd);

 push word [bin_fd]
 mov al, byte [bp-6]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-56         i++;

 inc  word [bp-2]

;-57     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog196
 jmp @@epilog195
@@epilog196:

;-58 }


;-59 


;-60 int end1(int n) {
 LEAVE
 ret
; ENDP
epilog_0 db "\n;END Errors: ",0
epilog_1 db " ***ERROR*** ",0
epilog_2 db ", Output: ",0
epilog_3 db ", COM file ",0
epilog_4 db " bytes.",0

end1:  ; *** PROC ***

;-61   fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word    60 NULL bp+4    n;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-62   fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-63   fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-64   exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-65 }
 LEAVE
 ret
; ENDP
;Back to main program: AS.C

;-9 #include "GENCODE.C"

;Use include file: GENCODE.C

;-1 // generate code


;-2 int getCodes() {


getCodes:  ; *** PROC ***

;-3     OpCodePtr ++; Code1 = *OpCodePtr;

 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code1], al

;-4     OpCodePtr ++; Code2 = *OpCodePtr;

 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code2], al

;-5     OpCodePtr ++; Code3 = *OpCodePtr;

 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [Code3], al

;-6 }


;-7 int gen66h() {genCode8(0x66);

 ret
; ENDP

gen66h:  ; *** PROC ***
 push 102
 call genCode8
 add  sp, 2

;-8 }


;-9 int genCode2(char c, char d) {

 ret
; ENDP

genCode2:  ; *** PROC ***

;-10     c = c + d;

;Function : genCode2, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte     9 NULL bp+4    c
;  201 var sign byte     9 NULL bp+6    d;
 ENTER  0,0
 mov al, [bp+4]
 add al, [bp+6]
 mov byte [bp+4], al

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
; ENDP

genCodeW:  ; *** PROC ***

;-14     c = c + wflag;  

;Function : genCodeW, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    13 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 add al, [wflag]
 mov byte [bp+4], al

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
; ENDP

genCode8:  ; *** PROC ***

;-18 //set: BinLen++, OpPrintIndex++


;-19     FileBin[BinLen]=c;

;Function : genCode8, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    17 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 mov bx, [BinLen]
 mov [FileBin+bx], al

;-20     BinLen++;

 inc  word [BinLen]

;-21     PC++;

 inc  word [PC]

;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");

 mov ax, [BinLen]
 cmp ax, 2000 ;unsigned : 0
 jb  @@genCode8197
 push genCode8_0
 call errorexit
 add  sp, 2

;-23     if (OpPrintIndex < OPMAXLEN) {

@@genCode8197:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode8198

;-24         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-25         OpPrintIndex++;

 inc  word [OpPrintIndex]

;-26     }


;-27 }

@@genCode8198:

;-28 int genCode16(unsigned int i) {
 LEAVE
 ret
; ENDP
genCode8_0 db "COM file too long",0

genCode16:  ; *** PROC ***

;-29     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg word    28 NULL bp+4    i;
 ENTER  0,0
 push word [bp+4]
 call genCode8
 add  sp, 2
 mov ax, [bp+4]
 shr ax, 8
 mov word [bp+4], ax

;-30     genCode8(i);

 push word [bp+4]
 call genCode8
 add  sp, 2

;-31 }


;-32 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
; ENDP

writeEA:  ; *** PROC ***

;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-34 //mod-bits: mode76, reg/opcode543, r/m210   


;-35 //Op: 0, IMM, REG, ADR, MEM   


;-36     char len;


;-37     len=0;   

;Function : writeEA, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 var sign byte    32 NULL bp+4    xxx
;  201 var sign byte    36 NULL bp-2    len;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-38     xxx = xxx << 3;//in reg/opcode field      

 mov al, [bp+4]
 shl al, 3
 mov byte [bp+4], al

;-39     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@writeEA199

;-40         xxx |= 0xC0;     

 or  byte [bp+4], 192

;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 

 mov al, [Op2]
 cmp al, 1
 jg  @@writeEA200
 mov al, [bp+4]
 add al, [R1No]
 mov byte [bp+4], al

;-42             else {

 jmp @@writeEA201
@@writeEA200:

;-43                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne @@writeEA202
 mov al, [bp+4]
 add al, [R1No]
 mov byte [bp+4], al

;-44                 else            xxx = xxx + R2No;  

 jmp @@writeEA203
@@writeEA202:
 mov al, [bp+4]
 add al, [R2No]
 mov byte [bp+4], al

;-45             }

@@writeEA203:

;-46         } 

@@writeEA201:

;-47     if (Op == MEM) {

@@writeEA199:
 mov al, [Op]
 cmp al, 4
 jne @@writeEA204

;-48         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@writeEA205

;-49             xxx |= 6;

 or  byte [bp+4], 6

;-50             len = 2;

 mov eax, 2
 mov byte [bp-2], al

;-51         }


;-52         else { 

 jmp @@writeEA206
@@writeEA205:

;-53             xxx = xxx + rm;   

 mov al, [bp+4]
 add al, [rm]
 mov byte [bp+4], al

;-54             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne @@writeEA207

;-55                 len=1;

 mov eax, 1
 mov byte [bp-2], al

;-56                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne @@writeEA208
 or  byte [bp+4], 64

;-57             }

@@writeEA208:

;-58 


;-59             if (disp) {

@@writeEA207:
 mov ax, [disp]
 or  al, al
 je @@writeEA209

;-60                 ax = disp;

 mov  ax, [disp]

;-61                 if(ax > 127) len=2;

 cmp  ax, 127
 jle @@writeEA210
 mov eax, 2
 mov byte [bp-2], al

;-62                 else len=1;

 jmp @@writeEA211
@@writeEA210:
 mov eax, 1
 mov byte [bp-2], al

;-63                 if (len == 1) xxx |= 0x40;

@@writeEA211:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA212
 or  byte [bp+4], 64

;-64                 else xxx |= 0x80;

 jmp @@writeEA213
@@writeEA212:
 or  byte [bp+4], 128

;-65             }

@@writeEA213:

;-66         }

@@writeEA209:

;-67     }  

@@writeEA206:

;-68     


;-69     genCode8(xxx);// gen second byte

@@writeEA204:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-70     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA214
 push word [disp]
 call genCode8
 add  sp, 2

;-71     if (len == 2) genCode16(disp);

@@writeEA214:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA215
 push word [disp]
 call genCode16
 add  sp, 2

;-72 }

@@writeEA215:

;-73 


;-74 int genImmediateSE() {
 LEAVE
 ret
; ENDP

genImmediateSE:  ; *** PROC ***

;-75     if (sflag) genCode8(imme);

 mov al, [sflag]
 or  al, al
 je @@genImmediateSE216
 push word [imme]
 call genCode8
 add  sp, 2

;-76     else genImmediate();    

 jmp @@genImmediateSE217
@@genImmediateSE216:
 call genImmediate

;-77 }

@@genImmediateSE217:

;-78 int genImmediate() { 

 ret
; ENDP

genImmediate:  ; *** PROC ***

;-79     if (wflag) genCode16(imme);

 mov al, [wflag]
 or  al, al
 je @@genImmediate218
 push word [imme]
 call genCode16
 add  sp, 2

;-80     else       genCode8 (imme);  

 jmp @@genImmediate219
@@genImmediate218:
 push word [imme]
 call genCode8
 add  sp, 2

;-81 }    

@@genImmediate219:
 ret
; ENDP
;Back to main program: AS.C

;-10 


;-11 int process() { 


process:  ; *** PROC ***

;-12     char c;


;-13     getTokeType();//0, DIGIT, ALNUME, NOALNUME

;Function : process, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    12 NULL bp-2    c;
 ENTER  2,0
 call getTokeType

;-14     OpSize=getCodeSize();//0, BYTE, WORD, DWORD

 call getCodeSize
 mov byte [OpSize], al

;-15     getCodes();//set: Code1, Code2, Code3

 call getCodes

;-16 


;-17     if (CodeType ==  1) {//1 byte opcode

 mov al, [CodeType]
 cmp al, 1
 jne @@process220

;-18         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-19         return;

 jmp @@retn

;-20     }


;-21   


;-22     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv

@@process220:
 mov al, [CodeType]
 cmp al, 2
 jne @@process221

;-23         getOpL();

 call getOpL

;-24         checkOpL();        

 call checkOpL

;-25         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  @@process222

;-26   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne @@process223

;-27                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je @@process224
 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
 jmp @@retn

;-28             }

@@process224:

;-29         }

@@process223:

;-30         if (Code2 == 5) {//imul extension?

@@process222:
 mov al, [Code2]
 cmp al, 5
 jne @@process225

;-31             getTokeType();

 call getTokeType

;-32             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je @@process226
 call implerror

;-33         }

@@process226:

;-34         genCodeW(Code1);           

@@process225:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-35         writeEA(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-36         return;

 jmp @@retn

;-37     }


;-38   


;-39     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

@@process221:
 mov al, [CodeType]
 cmp al, 3
 jne @@process227

;-40         check2Ops();    //setwflag not applicable

 call check2Ops

;-41         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  @@process228
 call reg16error

;-42         if (Op2 != MEM) addrerror();//only m16 

@@process228:
 mov al, [Op2]
 cmp al, 4
 je  @@process229
 call addrerror

;-43         


;-44         genCode8(Code1);//les,lds,lea

@@process229:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-45         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   

 mov al, [Code1]
 cmp al, 15
 jne @@process230
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-46         Op=Op2;//set MEM for writeEA

@@process230:
 mov al, [Op2]
 mov byte [Op], al

;-47         writeEA(R1No);           

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-48         return;

 jmp @@retn

;-49     }


;-50 


;-51     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

@@process227:
 mov al, [CodeType]
 cmp al, 4
 jne @@process231

;-52         check2Ops();    

 call check2Ops

;-53         if (Op2 == IMM) {//second operand is imm     

 mov al, [Op2]
 cmp al, 1
 jne @@process232

;-54             setsflag();   

 call setsflag

;-55             if (Op == REG) {                

 mov al, [Op]
 cmp al, 2
 jne @@process233

;-56                 if (R1No == 0) {// acc,imm   

 mov al, [R1No]
 cmp al, 0
 jne @@process234

;-57                     if (sflag == 0) {                        

 mov al, [sflag]
 cmp al, 0
 jne @@process235

;-58                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov byte [bp-2], al

;-59                         c += 4;    

 add  byte [bp-2], 4

;-60                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-61                         genImmediate();

 call genImmediate

;-62                         return;

 jmp @@retn

;-63                     }


;-64                 }

@@process235:

;-65             }

@@process234:

;-66             //r/m, imm: 80 sign-extended,TTT,imm


;-67             c = sflag + 0x80;   

@@process233:
 mov al, [sflag]
 add al, 128
 mov byte [bp-2], al

;-68             genCodeW(c); 

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-69             writeEA(Code1);  

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-70             genImmediateSE();

 call genImmediateSE

;-71             return;     

 jmp @@retn

;-72         }  


;-73         c = Code1 << 3;//r/m, r/r  

@@process232:
 mov al, [Code1]
 shl al, 3
 mov byte [bp-2], al

;-74         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process236

;-75             if (Op2 == MEM) {//reg, mem      

 mov al, [Op2]
 cmp al, 4
 jne @@process237

;-76                 c += 2;//add direction flag

 add  byte [bp-2], 2

;-77                 genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-78                 Op=Op2;//set MEM for writeEA                

 mov al, [Op2]
 mov byte [Op], al

;-79                 writeEA(R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-80                 return;    

 jmp @@retn

;-81             }


;-82         }

@@process237:

;-83         if (Op2 == REG) {//mem,reg    reg,reg

@@process236:
 mov al, [Op2]
 cmp al, 2
 jne @@process238

;-84             genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-85             writeEA(R2No);//2. Op in reg-field

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-86             return;            

 jmp @@retn

;-87         }          


;-88         syntaxerror();        

@@process238:
 call syntaxerror

;-89         return;

 jmp @@retn

;-90     }


;-91  


;-92     if (CodeType == 5) {//mov (movsx, movzx=51)

@@process231:
 mov al, [CodeType]
 cmp al, 5
 jne @@process239

;-93         dflag=0;

 mov eax, 0
 mov byte [dflag], al

;-94         check2Ops();    

 call check2Ops

;-95 /*    prs("\n Op:"); printhex8a(Op);


;-96     prs(", Op2:"); printhex8a(Op2);


;-97     prs(", R1No:"); printhex8a(R1No);


;-98     prs(", R2No:"); printhex8a(R2No);   */  


;-99         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne @@process240

;-100             imme=disp;

 mov ax, [disp]
 mov word [imme], ax

;-101             Op2=IMM;//continue with IMM    

 mov eax, 1
 mov byte [Op2], al

;-102         }  


;-103         if (Op2 == IMM) {// r,i     

@@process240:
 mov al, [Op2]
 cmp al, 1
 jne @@process241

;-104             if (Op == REG) {               

 mov al, [Op]
 cmp al, 2
 jne @@process242

;-105                 c = wflag << 3;   

 mov al, [wflag]
 shl al, 3
 mov byte [bp-2], al

;-106                 c += 0xB0;                                     

 add  byte [bp-2], 176

;-107                 genCode2(c, R1No);   

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-108                 genImmediate();

 call genImmediate

;-109                 return; 

 jmp @@retn

;-110             }


;-111             if (Op == MEM) {// m,i  

@@process242:
 mov al, [Op]
 cmp al, 4
 jne @@process243

;-112                 genCodeW(0xC6);

 push 198
 call genCodeW
 add  sp, 2

;-113                 writeEA( 0 );

 push 0
 call writeEA
 add  sp, 2

;-114                 genImmediate();

 call genImmediate

;-115                 return;  

 jmp @@retn

;-116             }


;-117             regmemerror();

@@process243:
 call regmemerror

;-118             return;

 jmp @@retn

;-119         }      


;-120         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

@@process241:
 mov al, [R1Type]
 cmp al, 4
 jne @@process244
 call ChangeDirection

;-121         if (R2Type == SEGREG) {//rm,sreg

@@process244:
 mov al, [R2Type]
 cmp al, 4
 jne @@process245

;-122             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  @@process246
 call reg16error

;-123                 genCode2(0x8C, dflag);

@@process246:
 mov al, byte [dflag]
 mov ah, 0
 push ax
 push 140
 call genCode2
 add  sp, 4

;-124                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-125                 return;   

 jmp @@retn

;-126         }          


;-127         if (Op2 == MEM) {//acc, moffs16

@@process245:
 mov al, [Op2]
 cmp al, 4
 jne @@process247

;-128             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process248

;-129                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne @@process249

;-130                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@process250

;-131                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-132                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-133                         return;   

 jmp @@retn

;-134                     }   


;-135                 }   

@@process250:

;-136             }   

@@process249:

;-137         } 

@@process248:

;-138         if (Op == MEM) {//moffs16, acc

@@process247:
 mov al, [Op]
 cmp al, 4
 jne @@process251

;-139             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne @@process252

;-140                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne @@process253

;-141                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@process254

;-142                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-143                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-144                         return;   

 jmp @@retn

;-145                     }   


;-146                 }   

@@process254:

;-147             }

@@process253:

;-148         


;-149         }

@@process252:

;-150         if (Op2 == REG) {//rm, r

@@process251:
 mov al, [Op2]
 cmp al, 2
 jne @@process255

;-151             genCodeW(0x88);     

 push 136
 call genCodeW
 add  sp, 2

;-152             writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-153             return;

 jmp @@retn

;-154         }


;-155         if (Op2 == MEM) {//r, m

@@process255:
 mov al, [Op2]
 cmp al, 4
 jne @@process256

;-156             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process257

;-157                 ChangeDirection();

 call ChangeDirection

;-158                 genCodeW(0x8A);

 push 138
 call genCodeW
 add  sp, 2

;-159                 writeEA(R2No);

 mov al, byte [R2No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-160                 return;   

 jmp @@retn

;-161             }   


;-162         }         

@@process257:

;-163         syntaxerror();

@@process256:
 call syntaxerror

;-164         return;

 jmp @@retn

;-165     }    


;-166     


;-167     if (CodeType ==  8) {//ret,retf

@@process239:
 mov al, [CodeType]
 cmp al, 8
 jne @@process258

;-168         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne @@process259

;-169             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-170             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-171             return;

 jmp @@retn

;-172         }


;-173         genCode8(Code1); 

@@process259:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-174         return;

 jmp @@retn

;-175     }


;-176 


;-177     if (CodeType==101) {// ORG nn

@@process258:
 mov al, [CodeType]
 cmp al, 101
 jne @@process260

;-178         if (TokeType != DIGIT) error1("only digit allowed");

 mov al, [TokeType]
 cmp al, 1
 je  @@process261
 push process_0
 call error1
 add  sp, 2

;-179         PC=SymbolInt;

@@process261:
 mov ax, [SymbolInt]
 mov word [PC], ax

;-180         return;

 jmp @@retn

;-181     }


;-182     error1("Command not implemented");

@@process260:
 push process_1
 call error1
 add  sp, 2

;-183 }    

@@retn: LEAVE
 ret
; ENDP
process_0 db "only digit allowed",0
process_1 db "Command not implemented",0
 
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
; fputcR
; fcloseR
; fcloseR
; fcloseR
; exitR
; Number of unresolved CALLs :   76
;use archive file: AR.C

;-184 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-185 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   185 NULL bp+4    s
;  201 var sign byte   185 NULL bp-2    c;
 ENTER  2,0
@@cputs262:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs263
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
 jmp @@cputs262
@@cputs263:

;-186 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   186 NULL bp+4    s;
 ENTER  0,0
@@toupper264:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper265
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper266
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper267
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper267:
@@toupper266:
 inc  word [bp+4]
 jmp @@toupper264
@@toupper265:

;-187 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-188 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   188 NULL bp+4    s
;  201 var sign word   188 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen268:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen269
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen268
@@strlen269:
 mov ax, [bp-2]
 jmp @@retn

;-189 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    5 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   189 NULL bp+4    s
;  201 ptr sign byte   189 NULL bp+6    t;
 ENTER  0,0
@@strcpy270:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-190   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy271
 jmp @@strcpy270
@@strcpy271:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-191 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   191 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit272
 mov eax, 0
 jmp @@retn
@@digit272:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit273
 mov eax, 0
 jmp @@retn
@@digit273:
 mov eax, 1
 jmp @@retn

;-192 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   192 NULL bp+4    p
;  201 ptr sign byte   192 NULL bp+6    q;
 ENTER  0,0
@@eqstr274:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr275

;-193     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr276
 mov eax, 0
 jmp @@retn
@@eqstr276:
 inc  word [bp+4]
 inc  word [bp+6]

;-194     if(*q) return 0; return 1; }

 jmp @@eqstr274
@@eqstr275:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr277
 mov eax, 0
 jmp @@retn
@@eqstr277:
 mov eax, 1
 jmp @@retn

;-195 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   195 NULL bp+4    s
;  201 ptr sign byte   195 NULL bp+6    t;
 ENTER  0,0
@@strcat1278:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1279
 inc  word [bp+4]
 jmp @@strcat1278
@@strcat1279:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-196 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   196 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-197 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   197 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-198 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   198 NULL bp+4    s
;  201 var sign word   198 NULL bp+6    fd
;  202 var sign word   198 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-199 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   199 NULL bp+4    n
;  201 var sign word   199 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-200   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-201 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   201 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-202 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   202 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-203 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
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

;-204 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   204 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch280
 mov  al, 13
 call writetty
@@putch280:
 mov  al, [bp+4]
 call writetty

;-205 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt281
 inc  word [DOS_ERR]
@@DosInt281:

;-206 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

 ret
; ENDP
;End of archive file. 
 
; missing functions:  All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width line used  address name   list of global variables

;    1 arr sign byte     1    2        0 Version1[10]
;    2 var sign byte     1    3        0 LIST
;    3 def unsg byte     2    -        0 SYMBOLMAX=31
;    4 arr sign byte     3    8        0 Symbol[31]
;    5 arr sign byte     4   36        0 SymbolUpper[31]
;    6 var unsg word     5   12        0 SymbolInt
;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
;    8 arr sign byte     7    4        0 InputBuf[127]
;    9 ptr unsg byte     8   24        0 InputPtr
;   10 arr sign byte     9    5        0 namein[67]
;   11 arr sign byte    10    6        0 namelst[67]
;   12 arr sign byte    11    5        0 namebin[67]
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
;   36 var sign byte    36   21        0 Op
;   37 var sign byte    37   27        0 Op2
;   38 var sign byte    38   14        0 CodeType
;   39 var sign byte    39    9        0 Code1
;   40 var sign byte    40    6        0 Code2
;   41 var sign byte    41    2        0 Code3
;   42 var sign byte    42   17        0 R2No
;   43 var sign byte    43   11        0 R1No
;   44 var sign byte    44   17        0 R2Type
;   45 var sign byte    45    9        0 R1Type
;   46 var sign byte    46   14        0 OpSize
;   47 var sign byte    47    7        0 wflag
;   48 var sign byte    48    3        0 dflag
;   49 var sign byte    49    6        0 sflag
;   50 var sign byte    50   14        0 rm
;   51 var sign byte    51    5        0 isDirect
;   52 var sign word    52   17        0 disp
;   53 var unsg word    53    8        0 imme
;   54 def unsg byte    55    -        0 OPMAXLEN=5
;   55 arr sign byte    56    2        0 OpPos[5]
;   56 var sign word    57    6        0 OpPrintIndex
;   57 ptr sign byte    58   17        0 OpCodePtr
;   58 var sign byte    59    2        0 PrintR
;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
;   60 arr sign byte    62    3        0 LabelNames[1000]
;   61 ptr sign byte    63    5        0 LabelNamePtr
;   62 def unsg byte    64    -        0 LABELADRMAX=100
;   63 arr unsg word    65    3        0 LabelAddr[100]
;   64 var sign word    66    4        0 LabelMaxIx
;   65 var sign word    67    4        0 LabelIx
;   66 def unsg byte    69    -        0 FILEBINMAX=2000
;   67 arr sign byte    70    2        0 FileBin[2000]
;   68 var unsg word    71    5        0 BinLen
;   69 ptr sign byte    73    1        0 arglen
;   70 ptr sign byte    74    4        0 argv
;   71 var sign byte     1    1        0 I_START
;   72 arr sign byte     4 NULL        0 I_PUSHA[9]
;   73 arr sign byte     5 NULL        0 I_POPA[8]
;   74 arr sign byte     6 NULL        0 I_NOP[7]
;   75 arr sign byte     7 NULL        0 I_CBW[7]
;   76 arr sign byte     8 NULL        0 I_CWDE[8]
;   77 arr sign byte     9 NULL        0 I_CWD[7]
;   78 arr sign byte    10 NULL        0 I_CDQ[7]
;   79 arr sign byte    11 NULL        0 I_WAIT[8]
;   80 arr sign byte    12 NULL        0 I_PUSHF[9]
;   81 arr sign byte    13 NULL        0 I_POPF[8]
;   82 arr sign byte    14 NULL        0 I_SAHF[8]
;   83 arr sign byte    15 NULL        0 I_LAHF[8]
;   84 arr sign byte    16 NULL        0 I_MOVSB[9]
;   85 arr sign byte    17 NULL        0 I_MOVSW[9]
;   86 arr sign byte    18 NULL        0 I_CMPSB[9]
;   87 arr sign byte    19 NULL        0 I_CMPSW[9]
;   88 arr sign byte    20 NULL        0 I_STOSB[9]
;   89 arr sign byte    21 NULL        0 I_STOSW[9]
;   90 arr sign byte    22 NULL        0 I_LODSB[9]
;   91 arr sign byte    23 NULL        0 I_LODSW[9]
;   92 arr sign byte    24 NULL        0 I_SCASB[9]
;   93 arr sign byte    25 NULL        0 I_SCASW[9]
;   94 arr sign byte    26 NULL        0 I_LEAVE[9]
;   95 arr sign byte    27 NULL        0 I_IRET[8]
;   96 arr sign byte    28 NULL        0 I_XLAT[8]
;   97 arr sign byte    29 NULL        0 I_LOCK[8]
;   98 arr sign byte    30 NULL        0 I_REPNE[9]
;   99 arr sign byte    31 NULL        0 I_REPNZ[9]
;  100 arr sign byte    32 NULL        0 I_REPE[8]
;  101 arr sign byte    33 NULL        0 I_REPZ[8]
;  102 arr sign byte    34 NULL        0 I_HLT[7]
;  103 arr sign byte    35 NULL        0 I_CLC[7]
;  104 arr sign byte    36 NULL        0 I_STC[7]
;  105 arr sign byte    37 NULL        0 I_CLI[7]
;  106 arr sign byte    38 NULL        0 I_STI[7]
;  107 arr sign byte    39 NULL        0 I_CLD[7]
;  108 arr sign byte    40 NULL        0 I_STD[7]
;  109 arr sign byte    42 NULL        0 I_INC[9]
;  110 arr sign byte    43 NULL        0 I_DEC[9]
;  111 arr sign byte    44 NULL        0 I_NOT[8]
;  112 arr sign byte    45 NULL        0 I_NEG[8]
;  113 arr sign byte    46 NULL        0 I_MUL[8]
;  114 arr sign byte    47 NULL        0 I_IMUL[9]
;  115 arr sign byte    48 NULL        0 I_DIV[8]
;  116 arr sign byte    49 NULL        0 I_IDIV[9]
;  117 arr sign byte    51 NULL        0 I_LES[7]
;  118 arr sign byte    52 NULL        0 I_LDS[7]
;  119 arr sign byte    53 NULL        0 I_LEA[7]
;  120 arr sign byte    54 NULL        0 I_LSS[8]
;  121 arr sign byte    55 NULL        0 I_LFS[8]
;  122 arr sign byte    56 NULL        0 I_LGS[8]
;  123 arr sign byte    58 NULL        0 I_ADD[7]
;  124 arr sign byte    59 NULL        0 I_OR[6]
;  125 arr sign byte    60 NULL        0 I_ADC[7]
;  126 arr sign byte    61 NULL        0 I_SBB[7]
;  127 arr sign byte    62 NULL        0 I_AND[7]
;  128 arr sign byte    63 NULL        0 I_SUB[7]
;  129 arr sign byte    64 NULL        0 I_XOR[7]
;  130 arr sign byte    65 NULL        0 I_CMP[7]
;  131 arr sign byte    66 NULL        0 I_TEST[11]
;  132 arr sign byte    68 NULL        0 I_MOV[6]
;  133 arr sign byte    69 NULL        0 I_MOVSX[9]
;  134 arr sign byte    70 NULL        0 I_MOVZX[9]
;  135 arr sign byte    72 NULL        0 I_JO[6]
;  136 arr sign byte    73 NULL        0 I_JNO[7]
;  137 arr sign byte    74 NULL        0 I_JB[6]
;  138 arr sign byte    75 NULL        0 I_JC[6]
;  139 arr sign byte    76 NULL        0 I_JNB[7]
;  140 arr sign byte    77 NULL        0 I_JAE[7]
;  141 arr sign byte    78 NULL        0 I_JNC[7]
;  142 arr sign byte    79 NULL        0 I_JE[6]
;  143 arr sign byte    80 NULL        0 I_JZ[6]
;  144 arr sign byte    81 NULL        0 I_JNE[7]
;  145 arr sign byte    82 NULL        0 I_JNZ[7]
;  146 arr sign byte    83 NULL        0 I_JBE[7]
;  147 arr sign byte    84 NULL        0 I_JNA[7]
;  148 arr sign byte    85 NULL        0 I_JA[6]
;  149 arr sign byte    86 NULL        0 I_JS[6]
;  150 arr sign byte    87 NULL        0 I_JNS[7]
;  151 arr sign byte    88 NULL        0 I_JP[6]
;  152 arr sign byte    89 NULL        0 I_JPE[7]
;  153 arr sign byte    90 NULL        0 I_JNP[7]
;  154 arr sign byte    91 NULL        0 I_JPO[7]
;  155 arr sign byte    92 NULL        0 I_JL[6]
;  156 arr sign byte    93 NULL        0 I_JNL[7]
;  157 arr sign byte    94 NULL        0 I_JGE[7]
;  158 arr sign byte    95 NULL        0 I_JLE[7]
;  159 arr sign byte    96 NULL        0 I_JNG[7]
;  160 arr sign byte    97 NULL        0 I_JG[6]
;  161 arr sign byte    99 NULL        0 I_JMP[8]
;  162 arr sign byte   100 NULL        0 I_CALL[9]
;  163 arr sign byte   102 NULL        0 I_RET[8]
;  164 arr sign byte   103 NULL        0 I_RETF[9]
;  165 arr sign byte   105 NULL        0 I_PUSH[8]
;  166 arr sign byte   106 NULL        0 I_POP[7]
;  167 arr sign byte   108 NULL        0 I_ROL[7]
;  168 arr sign byte   109 NULL        0 I_ROR[7]
;  169 arr sign byte   110 NULL        0 I_RCL[7]
;  170 arr sign byte   111 NULL        0 I_RCR[7]
;  171 arr sign byte   112 NULL        0 I_SHL[7]
;  172 arr sign byte   113 NULL        0 I_SAL[7]
;  173 arr sign byte   114 NULL        0 I_SHR[7]
;  174 arr sign byte   115 NULL        0 I_SAR[7]
;  175 arr sign byte   117 NULL        0 I_INT[8]
;  176 arr sign byte   118 NULL        0 I_INTO[8]
;  177 arr sign byte   129 NULL        0 I_XCHG[9]
;  178 arr sign byte   131 NULL        0 I_LOOPNZ[10]
;  179 arr sign byte   132 NULL        0 I_LOOPNE[10]
;  180 arr sign byte   133 NULL        0 I_LOOPZ[9]
;  181 arr sign byte   134 NULL        0 I_LOOPE[9]
;  182 arr sign byte   135 NULL        0 I_LOOP[8]
;  183 arr sign byte   136 NULL        0 I_JCXZ[8]
;  184 arr sign byte   137 NULL        0 I_JECXZ[9]
;  185 arr sign byte   139 NULL        0 I_ENTER[9]
;  186 arr sign byte   141 NULL        0 I_ORG[6]
;  187 arr sign byte   146 NULL        0 I_DB[5]
;  188 arr sign byte   147 NULL        0 I_DW[5]
;  189 arr sign byte   148 NULL        0 I_DD[5]
;  190 arr sign byte   149 NULL        0 I_RESB[7]
;  191 arr sign byte   150 NULL        0 I_RESW[7]
;  192 arr sign byte   151 NULL        0 I_RESD[7]
;  193 var sign byte   152 NULL        0 I_END


;   # Calls Line Width  Name   list of functions

;    0    2    1 word   ChangeDirection
;    1    1    9 word   checkOpL
;    2    3   22 word   check2Ops
;    3    1   31 word   get2Ops
;    4    2   37 word   getOpL
;    5    2   46 word   getOpR
;    6    2   56 word   getOp1
;    7    1   72 word   getMEM
;    8    1   94 word   getIndReg1
;    9    1  102 word   getIndReg2
;   10    2  112 word   setwflag
;   11    1  123 word   setsflag
;   12    1    1 word   parse
;   13   14   27 word   getTokeType
;   14    2   36 word   storeLabel
;   15    2   46 word   searchLabel
;   16    1   57 word   getVariable
;   17    2   86 word   lookCode
;   18    1  101 word   getCodeSize
;   19    8  108 word   isToken
;   20    1  113 word   need
;   21    1  123 word   skipRest
;   22    1    1 word   getLine
;   23    1   17 word   ifEOL
;   24    3   24 word   skipBlank
;   25    2   29 word   letterE
;   26    1   39 word   alnumE
;   27    1   44 word   getDigit
;   28    1   56 word   getName
;   29    1   75 word   testReg
;   30    1    1 word   printLine
;   31    7   22 word   prc
;   32    1   34 word   prscomment
;   33   23   42 word   prs
;   34    3   64 word   printhex8a
;   35    2   69 word   printhex4
;   36    1   74 word   printhex16
;   37    3   79 word   printIntU
;   38   25   90 word   error1
;   39   12   98 word   errorexit
;   40 NULL  102 word   allowederror
;   41    3  103 word   addrerror
;   42    1  104 word   immeerror
;   43    2  105 word   implerror
;   44    4  106 word   indexerror
;   45    2  107 word   invaloperror
;   46    1  108 word   numbererror
;   47    1  109 word   regmemerror
;   48    2  110 word   reg16error
;   49    1  111 word   segregerror
;   50    3  112 word   syntaxerror
;   51 NULL  114 word   addrexit
;   52 NULL  115 word   internexit
;   53 NULL    1 word   main
;   54    1    8 word   getarg
;   55    1   42 word   epilog
;   56    2   60 word   end1
;   57    1    2 word   getCodes
;   58    1    7 word   gen66h
;   59    3    9 word   genCode2
;   60   10   13 word   genCodeW
;   61   16   17 word   genCode8
;   62    6   28 word   genCode16
;   63    9   32 word   writeEA
;   64    1   74 word   genImmediateSE
;   65    4   78 word   genImmediate
;   66    1   11 word   process
;   67    4  184 word   writetty
;   68    8  185 word   cputs
;   69    2  186 word   toupper
;   70    3  188 word   strlen
;   71    6  189 word   strcpy
;   72    3  191 word   digit
;   73   35  192 word   eqstr
;   74    3  195 word   strcat1
;   75    1  196 word   openR
;   76    2  197 word   creatR
;   77    2  198 word   readRL
;   78    2  199 word   fputcR
;   79    3  201 word   fcloseR
;   80    5  202 word   exitR
;   81    1  204 word   putch
;   82    4  205 word   DosInt
;   83 NULL  206 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0  1360 implerror
;    1  1370 segregerror
;    2  1382 setwflag
;    3  1391 error1
;    4  1398 error1
;    5  1405 error1
;    6  1422 get2Ops
;    7  1430 addrerror
;    8  1440 invaloperror
;    9  1453 immeerror
;   10  1463 addrerror
;   11  1473 setwflag
;   12  1490 getOpL
;   13  1497 need
;   14  1502 getOpR
;   15  1516 getOpR
;   16  1530 getOp1
;   17  1537 isToken
;   18  1545 getMEM
;   19  1552 invaloperror
;   20  1565 error1
;   21  1579 testReg
;   22  1587 searchLabel
;   23  1599 error1
;   24  1615 getTokeType
;   25  1627 getOp1
;   26  1634 syntaxerror
;   27  1646 getIndReg2
;   28  1657 getIndReg1
;   29  1668 isToken
;   30  1676 getTokeType
;   31  1688 numbererror
;   32  1700 isToken
;   33  1708 isToken
;   34  1716 errorexit
;   35  1737 indexerror
;   36  1748 indexerror
;   37  1772 indexerror
;   38  1783 indexerror
;   39  1803 gen66h
;   40  1819 error1
;   41  1832 getLine
;   42  1840 getTokeType
;   43  1852 storeLabel
;   44  1863 getTokeType
;   45  1875 lookCode
;   46  1884 process
;   47  1892 getVariable
;   48  1904 skipRest
;   49  1913 error1
;   50  1920 error1
;   51  1927 printLine
;   52  1951 skipBlank
;   53  1961 digit
;   54  1967 getDigit
;   55  1976 letterE
;   56  1984 getName
;   57  2005 searchLabel
;   58  2017 error1
;   59  2024 strcpy
;   60  2031 errorexit
;   61  2041 errorexit
;   62  2071 eqstr
;   63  2077 strlen
;   64  2098 storeLabel
;   65  2109 getTokeType
;   66  2121 lookCode
;   67  2130 errorexit
;   68  2140 errorexit
;   69  2150 getTokeType
;   70  2162 genCode8
;   71  2171 skipBlank
;   72  2181 isToken
;   73  2189 genCode8
;   74  2198 isToken
;   75  2206 getTokeType
;   76  2218 genCode16
;   77  2228 isToken
;   78  2236 errorexit
;   79  2255 eqstr
;   80  2273 eqstr
;   81  2279 getTokeType
;   82  2291 eqstr
;   83  2297 getTokeType
;   84  2309 eqstr
;   85  2315 getTokeType
;   86  2337 skipBlank
;   87  2354 isToken
;   88  2362 getTokeType
;   89  2374 error1
;   90  2381 prs
;   91  2385 prc
;   92  2398 getTokeType
;   93  2410 error1
;   94  2427 readRL
;   95  2434 errorexit
;   96  2444 errorexit
;   97  2454 ifEOL
;   98  2468 readRL
;   99  2504 digit
;  100  2510 letterE
;  101  2537 digit
;  102  2557 alnumE
;  103  2564 errorexit
;  104  2574 strcpy
;  105  2581 toupper
;  106  2597 strlen
;  107  2604 strlen
;  108  2611 eqstr
;  109  2617 eqstr
;  110  2623 eqstr
;  111  2629 eqstr
;  112  2635 eqstr
;  113  2641 eqstr
;  114  2647 eqstr
;  115  2653 eqstr
;  116  2659 eqstr
;  117  2665 eqstr
;  118  2671 eqstr
;  119  2677 eqstr
;  120  2683 eqstr
;  121  2689 eqstr
;  122  2695 eqstr
;  123  2701 eqstr
;  124  2707 eqstr
;  125  2713 eqstr
;  126  2719 eqstr
;  127  2725 eqstr
;  128  2731 eqstr
;  129  2737 eqstr
;  130  2743 eqstr
;  131  2749 eqstr
;  132  2755 eqstr
;  133  2761 eqstr
;  134  2767 eqstr
;  135  2773 eqstr
;  136  2779 eqstr
;  137  2785 eqstr
;  138  2805 prs
;  139  2809 printhex16
;  140  2820 prs
;  141  2824 prc
;  142  2828 printhex8a
;  143  2839 prc
;  144  2843 prs
;  145  2847 prscomment
;  146  2864 writetty
;  147  2873 writetty
;  148  2882 fputcR
;  149  2904 prc
;  150  2920 prc
;  151  2941 printhex4
;  152  2951 printhex4
;  153  2973 prc
;  154  2995 printhex8a
;  155  3006 printhex8a
;  156  3031 printIntU
;  157  3041 prc
;  158  3054 prs
;  159  3058 prs
;  160  3062 prs
;  161  3066 prs
;  162  3082 error1
;  163  3089 end1
;  164  3107 error1
;  165  3124 error1
;  166  3141 error1
;  167  3158 error1
;  168  3176 error1
;  169  3196 error1
;  170  3215 error1
;  171  3234 error1
;  172  3252 error1
;  173  3271 error1
;  174  3290 error1
;  175  3306 errorexit
;  176  3327 errorexit
;  177  3342 getarg
;  178  3349 parse
;  179  3355 epilog
;  180  3362 end1
;  181  3386 cputs
;  182  3392 cputs
;  183  3398 exitR
;  184  3404 toupper
;  185  3412 strcpy
;  186  3419 strcat1
;  187  3427 strcpy
;  188  3434 strcat1
;  189  3442 strcpy
;  190  3449 strcat1
;  191  3457 openR
;  192  3463 cputs
;  193  3469 cputs
;  194  3475 exitR
;  195  3481 creatR
;  196  3488 cputs
;  197  3494 cputs
;  198  3500 exitR
;  199  3506 creatR
;  200  3513 cputs
;  201  3519 cputs
;  202  3525 exitR
;  203  3531 prs
;  204  3535 prs
;  205  3539 prs
;  206  3543 prs
;  207  3547 prs
;  208  3551 prs
;  209  3555 prs
;  210  3559 prs
;  211  3563 prs
;  212  3580 prs
;  213  3584 printIntU
;  214  3594 prs
;  215  3598 prs
;  216  3602 prs
;  217  3606 prs
;  218  3610 printIntU
;  219  3620 prs
;  220  3624 fputcR
;  221  3638 fcloseR
;  222  3646 fcloseR
;  223  3654 fcloseR
;  224  3662 exitR
;  225  3684 genCode8
;  226  3706 genCode8
;  227  3726 genCode8
;  228  3746 errorexit
;  229  3768 genCode8
;  230  3777 genCode8
;  231  3802 genCode8
;  232  3811 genCode8
;  233  3820 genCode16
;  234  3845 genCode8
;  235  3854 genImmediate
;  236  3880 genCode16
;  237  3890 genCode8
;  238  3909 getTokeType
;  239  3921 getCodeSize
;  240  3933 getCodes
;  241  3942 genCode8
;  242  3951 getOpL
;  243  3958 checkOpL
;  244  3967 genCode2
;  245  3976 getTokeType
;  246  3988 implerror
;  247  3998 genCodeW
;  248  4007 writeEA
;  249  4015 check2Ops
;  250  4025 reg16error
;  251  4036 addrerror
;  252  4046 genCode8
;  253  4055 genCode8
;  254  4064 writeEA
;  255  4072 check2Ops
;  256  4082 setsflag
;  257  4091 genCodeW
;  258  4100 genImmediate
;  259  4113 genCodeW
;  260  4122 writeEA
;  261  4130 genImmediateSE
;  262  4145 genCodeW
;  263  4154 writeEA
;  264  4162 genCodeW
;  265  4171 writeEA
;  266  4179 syntaxerror
;  267  4191 check2Ops
;  268  4201 genCode2
;  269  4210 genImmediate
;  270  4223 genCodeW
;  271  4232 writeEA
;  272  4240 genImmediate
;  273  4253 regmemerror
;  274  4265 ChangeDirection
;  275  4281 reg16error
;  276  4292 genCode2
;  277  4301 writeEA
;  278  4309 genCodeW
;  279  4318 genCode16
;  280  4328 genCodeW
;  281  4337 genCode16
;  282  4347 genCodeW
;  283  4356 writeEA
;  284  4364 ChangeDirection
;  285  4380 genCodeW
;  286  4389 writeEA
;  287  4397 syntaxerror
;  288  4409 genCode8
;  289  4418 genCode16
;  290  4428 genCode8
;  291  4437 error1
;  292  4444 error1
;  293  4470 putch
;  294  4538 strcpy
;  295  4553 DosInt
;  296  4569 DosInt
;  297  4592 DosInt
;  298  4611 DosInt
;  299  4645 writetty
;  300  4654 writetty
;Input: AS.C, List: AS.S,  Lines:  207
;Glob. variables:  193 max.:  200
;Local variables:    3 max.:  100, in 'searchLabel'
;Functions      :   84 max.:  300
;Calls          :  301 max.: 2000, NameField: 4686 max.:    65535
;Code until     :25998 max.: 30000, free: 4002
;Data (HeapEnd) :33595, resting stacksize: 31940
;Max. Const in 'testReg' :  658 max. 3000, free: 2342