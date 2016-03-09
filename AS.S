
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

;-51 char isDirect;          //set in process and getMeM, need in WriteEA

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

;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};

I_INT3 db 73,78,84,51,0,1,204,241

;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};

I_INTO db 73,78,84,79,0,1,206,241

;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};

I_IRET db 73,82,69,84,0,1,207,241

;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};

I_XLAT db 88,76,65,84,0,1,215,241

;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};

I_LOCK db 76,79,67,75,0,1,240,241

;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};

I_REPNE db 82,69,80,78,69,0,1,242,241

;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};

I_REPNZ db 82,69,80,78,90,0,1,242,241

;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};

I_REPE db 82,69,80,69,0,1,243,241

;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};

I_REPZ db 82,69,80,90,0,1,243,241

;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};

I_HLT db 72,76,84,0,1,244,241

;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry

I_CLC db 67,76,67,0,1,248,241

;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry

I_STC db 83,84,67,0,1,249,241

;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt

I_CLI db 67,76,73,0,1,250,241

;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt

I_STI db 83,84,73,0,1,251,241

;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction

I_CLD db 67,76,68,0,1,252,241

;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction

I_STD db 83,84,68,0,1,253,241

;-43 // 2: mem reg 16 bit


;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};

I_INC db 73,78,67,0,2,254,0,64,241

;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};

I_DEC db 68,69,67,0,2,254,1,72,241

;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};

I_NOT db 78,79,84,0,2,246,2,241

;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};

I_NEG db 78,69,71,0,2,246,3,241

;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};

I_MUL db 77,85,76,0,2,246,4,241

;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc

I_IMUL db 73,77,85,76,0,2,246,5,241

;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};

I_DIV db 68,73,86,0,2,246,6,241

;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};

I_IDIV db 73,68,73,86,0,2,246,7,241

;-52 //  3: les, lda, lea, lss, lfs, lgs


;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};

I_LES db 76,69,83,0,3,196,241

;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};

I_LDS db 76,68,83,0,3,197,241

;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16

I_LEA db 76,69,65,0,3,141,241

;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};

I_LSS db 76,83,83,0,3,15,178,241

;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};

I_LFS db 76,70,83,0,3,15,180,241

;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};

I_LGS db 76,71,83,0,3,15,181,241

;-59 //  4: acc,imm  reg,imm  index,reg


;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};

I_ADD db 65,68,68,0,4,0,241

;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};

I_OR db 79,82,0,4,1,241

;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};

I_ADC db 65,68,67,0,4,2,241

;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};

I_SBB db 83,66,66,0,4,3,241

;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};

I_AND db 65,78,68,0,4,4,241

;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};

I_SUB db 83,85,66,0,4,5,241

;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};

I_XOR db 88,79,82,0,4,6,241

;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};

I_CMP db 67,77,80,0,4,7,241

;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};

I_TEST db 84,69,83,84,0,41,168,132,246,0,241

;-69 //  5: mov


;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};

I_MOV db 77,79,86,0,5,241

;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};

I_MOVSX db 77,79,86,83,88,0,51,190,241

;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};

I_MOVZX db 77,79,86,90,88,0,51,182,241

;-73 //  6: single byte relative jump


;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};

I_JO db 74,79,0,6,0,241

;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};

I_JNO db 74,78,79,0,6,1,241

;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};

I_JB db 74,66,0,6,2,241

;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};

I_JC db 74,67,0,6,2,241

;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};

I_JNB db 74,78,66,0,6,3,241

;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};

I_JAE db 74,65,69,0,6,3,241

;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};

I_JNC db 74,78,67,0,6,3,241

;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel

I_JE db 74,69,0,6,4,241

;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r

I_JZ db 74,90,0,6,4,241

;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};

I_JNE db 74,78,69,0,6,5,241

;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};

I_JNZ db 74,78,90,0,6,5,241

;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};

I_JBE db 74,66,69,0,6,6,241

;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};

I_JNA db 74,78,65,0,6,6,241

;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};

I_JA db 74,65,0,6,7,241

;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};

I_JS db 74,83,0,6,8,241

;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};

I_JNS db 74,78,83,0,6,9,241

;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};

I_JP db 74,80,0,6,10,241

;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};

I_JPE db 74,80,69,0,6,10,241

;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};

I_JNP db 74,78,80,0,6,11,241

;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};

I_JPO db 74,80,79,0,6,11,241

;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};

I_JL db 74,76,0,6,12,241

;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};

I_JNL db 74,78,76,0,6,13,241

;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};

I_JGE db 74,71,69,0,6,13,241

;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};

I_JLE db 74,76,69,0,6,14,241

;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};

I_JNG db 74,78,71,0,6,14,241

;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};

I_JG db 74,71,0,6,15,241

;-100 //  7: jmp, call


;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};

I_JMP db 74,77,80,0,7,233,4,241

;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};

I_CALL db 67,65,76,76,0,7,232,2,241

;-103 //  8: ret


;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};

I_RET db 82,69,84,0,8,195,194,241

;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};

I_RETF db 82,69,84,70,0,8,203,202,241

;-106 //  9: seg, r/m


;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16

I_PUSH db 80,85,83,72,0,9,80,255,6,6,241

;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16

I_POP db 80,79,80,0,9,88,143,0,7,241

;-109 //  11: shift, rotates


;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};

I_ROL db 82,79,76,0,11,0,241

;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};

I_ROR db 82,79,82,0,11,1,241

;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};

I_RCL db 82,67,76,0,11,2,241

;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};

I_RCR db 82,67,82,0,11,3,241

;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};

I_SHL db 83,72,76,0,11,4,241

;-115 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};

I_SAL db 83,65,76,0,11,5,241

;-116 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};

I_SHR db 83,72,82,0,11,6,241

;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};

I_SAR db 83,65,82,0,11,7,241

;-118 //  12: int


;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-120 //  14: in/out


;-121 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};


;-122 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};


;-123 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};


;-124 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};


;-125 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};


;-126 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};


;-127 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};


;-128 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/


;-129 //  15: xchg


;-130 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};

I_XCHG db 88,67,72,71,0,15,134,144,241

;-131 //  16: loop, jcxz


;-132 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};

I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241

;-133 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};

I_LOOPNE db 76,79,79,80,78,69,0,16,224,241

;-134 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};

I_LOOPZ db 76,79,79,80,90,0,16,225,241

;-135 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};

I_LOOPE db 76,79,79,80,69,0,16,225,241

;-136 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};

I_LOOP db 76,79,79,80,0,16,226,241

;-137 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};

I_JCXZ db 74,67,88,90,0,16,227,241

;-138 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};

I_JECXZ db 74,69,67,88,90,0,16,227,241

;-139 //  30: enter


;-140 char I_ENTER[]={'E','N','T','E','R',0,  30,       0xF1};

I_ENTER db 69,78,84,69,82,0,30,241

;-141 // 100: directives


;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};

I_ORG db 79,82,71,0,101,241

;-143 // section, segment .TEXT .DATA .BSS


;-144 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};


;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};


;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/


;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-150 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};

I_RESB db 82,69,83,66,0,205,241

;-151 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};

I_RESW db 82,69,83,87,0,206,241

;-152 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};

I_RESD db 82,69,83,68,0,207,241

;-153 char I_END=0;// end of table char

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

;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop

@@checkOpL1:
 mov al, [R1Type]
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

;-15     if (Op == REG) if (R1Type==0) error1("no register defined");

@@checkOpL4:
 mov al, [Op]
 cmp al, 2
 jne @@checkOpL5
 mov al, [R1Type]
 cmp al, 0
 jne @@checkOpL6
 push checkOpL_1
 call error1
 add  sp, 2

;-16 }

@@checkOpL6:
@@checkOpL5:

;-17     


;-18 int check2Ops() {

@@retn:
 ret
; ENDP
checkOpL_0 db "no op size declared",0
checkOpL_1 db "no register defined",0

check2Ops:  ; *** PROC ***

;-19     get2Ops();

 call get2Ops

;-20     if (Op ==   0) addrerror();

 mov al, [Op]
 cmp al, 0
 jne @@check2Ops7
 call addrerror

;-21     if (Op == ADR) invaloperror(); 

@@check2Ops7:
 mov al, [Op]
 cmp al, 3
 jne @@check2Ops8
 call invaloperror

;-22     if (Op == IMM) immeerror();   

@@check2Ops8:
 mov al, [Op]
 cmp al, 1
 jne @@check2Ops9
 call immeerror

;-23     if (Op2==   0) addrerror();

@@check2Ops9:
 mov al, [Op2]
 cmp al, 0
 jne @@check2Ops10
 call addrerror

;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           

@@check2Ops10:
 mov al, [CodeType]
 cmp al, 5
 je  @@check2Ops11
 mov al, [Op2]
 cmp al, 3
 jne @@check2Ops12
 call invaloperror

;-25     setwflag();       

@@check2Ops12:
@@check2Ops11:
 call setwflag

;-26 }    


;-27 int get2Ops() {

 ret
; ENDP

get2Ops:  ; *** PROC ***

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
; ENDP

getOpL:  ; *** PROC ***

;-34 //set: op=0,IMM,REG,ADR,MEM


;-35     getOpR();

 call getOpR

;-36     Op=Op2;         Op2=0;

 mov al, [Op2]
 mov byte [Op], al
 mov eax, 0
 mov byte [Op2], al

;-37     R1No=R2No;      R2No=0;

 mov al, [R2No]
 mov byte [R1No], al
 mov eax, 0
 mov byte [R2No], al

;-38     R1Type=R2Type; R2Type=0; 

 mov al, [R2Type]
 mov byte [R1Type], al
 mov eax, 0
 mov byte [R2Type], al

;-39 }  


;-40 


;-41 int getOpR() {

 ret
; ENDP

getOpR:  ; *** PROC ***

;-42     Op2=getOp1();

 call getOp1
 mov byte [Op2], al

;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}

 push 91
 call isToken
 add  sp, 2
 or  al, al
 je @@getOpR13
 mov eax, 4
 mov byte [Op2], al
 call getMEM
 jmp @@retn

;-44     if (Op2 == 0)     {invaloperror();         return;}

@@getOpR13:
 mov al, [Op2]
 cmp al, 0
 jne @@getOpR14
 call invaloperror
 jmp @@retn

;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}

@@getOpR14:
 mov al, [Op2]
 cmp al, 1
 jne @@getOpR15
 mov ax, [SymbolInt]
 mov word [imme], ax
 jmp @@retn

;-46     if (Op2 == REG)                            return;

@@getOpR15:
 mov al, [Op2]
 cmp al, 2
 jne @@getOpR16
 jmp @@retn

;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}

@@getOpR16:
 mov al, [Op2]
 cmp al, 3
 jne @@getOpR17
 mov bx, [LabelIx]
 shl bx, 1
 mov ax, [LabelAddr + bx]
 mov word [disp], ax
 jmp @@retn

;-48     error1("Name of operand expected");

@@getOpR17:
 push getOpR_0
 call error1
 add  sp, 2

;-49 }


;-50 


;-51 int getOp1() {//scan for a single operand

@@retn:
 ret
; ENDP
getOpR_0 db "Name of operand expected",0

getOp1:  ; *** PROC ***

;-52 //return:0, IMM, REG, ADR (not MEM)


;-53 //set   :R2Type, R2No by testReg


;-54 //set   :LabelIx by searchLabel


;-55     if (TokeType == 0)      return 0;

 mov al, [TokeType]
 cmp al, 0
 jne @@getOp118
 mov eax, 0
 jmp @@retn

;-56     if (TokeType == DIGIT)  return IMM;

@@getOp118:
 mov al, [TokeType]
 cmp al, 1
 jne @@getOp119
 mov eax, 1
 jmp @@retn

;-57     if (TokeType == ALNUME) {

@@getOp119:
 mov al, [TokeType]
 cmp al, 3
 jne @@getOp120

;-58         R2No=testReg();

 call testReg
 mov byte [R2No], al

;-59         if (R2Type)        return REG;

 mov al, [R2Type]
 or  al, al
 je @@getOp121
 mov eax, 2
 jmp @@retn

;-60         LabelIx=searchLabel();

@@getOp121:
 call searchLabel
 mov word [LabelIx], ax

;-61         if (LabelIx)        return ADR;

 mov ax, [LabelIx]
 or  al, al
 je @@getOp122
 mov eax, 3
 jmp @@retn

;-62         else error1("variable not found"); 

 jmp @@getOp123
@@getOp122:
 push getOp1_0
 call error1
 add  sp, 2

;-63     }

@@getOp123:

;-64     return 0;

@@getOp120:
 mov eax, 0
 jmp @@retn

;-65 }


;-66 


;-67 int getMEM() {// e.g. [array+bp+si-4]

@@retn:
 ret
; ENDP
getOp1_0 db "variable not found",0

getMEM:  ; *** PROC ***

;-68 //set: disp, rm, R2Type


;-69     char c;


;-70     disp=0; rm=0;

;Function : getMEM, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    69 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [disp], ax
 mov eax, 0
 mov byte [rm], al

;-71     do {

@@getMEM24:

;-72         getTokeType();

 call getTokeType

;-73         c=getOp1();

 call getOp1
 mov byte [bp-2], al

;-74         if (c ==   0) syntaxerror();

 mov al, [bp-2]
 cmp al, 0
 jne @@getMEM25
 call syntaxerror

;-75         if (c == REG) {

@@getMEM25:
 mov al, [bp-2]
 cmp al, 2
 jne @@getMEM26

;-76             isDirect=0;

 mov eax, 0
 mov byte [isDirect], al

;-77             if (rm) rm=getIndReg2();

 mov al, [rm]
 or  al, al
 je @@getMEM27
 call getIndReg2
 mov byte [rm], al

;-78             else getIndReg1();

 jmp @@getMEM28
@@getMEM27:
 call getIndReg1

;-79         }

@@getMEM28:

;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];

@@getMEM26:
 mov al, [bp-2]
 cmp al, 3
 jne @@getMEM29
 mov ax, [disp]
 mov bx, [LabelIx]
 shl bx, 1
 add ax, [LabelAddr + bx]
 mov word [disp], ax

;-81         if (c == IMM) disp=disp+SymbolInt;

@@getMEM29:
 mov al, [bp-2]
 cmp al, 1
 jne @@getMEM30
 mov ax, [disp]
 add ax, [SymbolInt]
 mov word [disp], ax

;-82         if (isToken('-')) {

@@getMEM30:
 push 45
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM31

;-83             getTokeType();

 call getTokeType

;-84             if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  @@getMEM32
 call numbererror

;-85             disp = disp - SymbolInt;

@@getMEM32:
 mov ax, [disp]
 sub ax, [SymbolInt]
 mov word [disp], ax

;-86         }


;-87     } while (isToken('+'));

@@getMEM31:
 push 43
 call isToken
 add  sp, 2
 or  al, al
 je @@getMEM33
 jmp @@getMEM24
@@getMEM33:

;-88     if (isToken(']') == 0) errorexit("] expected");

 push 93
 call isToken
 add  sp, 2
 cmp ax, 0
 jne @@getMEM34
 push getMEM_0
 call errorexit
 add  sp, 2

;-89 }

@@getMEM34:

;-90 int getIndReg1() {
 LEAVE
 ret
; ENDP
getMEM_0 db "] expected",0

getIndReg1:  ; *** PROC ***

;-91     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  @@getIndReg135
 call indexerror

;-92     if (R2No==3) rm=7;//BX

@@getIndReg135:
 mov al, [R2No]
 cmp al, 3
 jne @@getIndReg136
 mov eax, 7
 mov byte [rm], al

;-93     if (R2No==5) rm=6;//BP, change to BP+0

@@getIndReg136:
 mov al, [R2No]
 cmp al, 5
 jne @@getIndReg137
 mov eax, 6
 mov byte [rm], al

;-94     if (R2No==7) rm=5;//DI

@@getIndReg137:
 mov al, [R2No]
 cmp al, 7
 jne @@getIndReg138
 mov eax, 5
 mov byte [rm], al

;-95     if (R2No==6) rm=4;//SI

@@getIndReg138:
 mov al, [R2No]
 cmp al, 6
 jne @@getIndReg139
 mov eax, 4
 mov byte [rm], al

;-96     if (rm==0) indexerror();

@@getIndReg139:
 mov al, [rm]
 cmp al, 0
 jne @@getIndReg140
 call indexerror

;-97 }

@@getIndReg140:

;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI

 ret
; ENDP

getIndReg2:  ; *** PROC ***
;Function : getIndReg2, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    98 NULL bp-2    m;
 ENTER  2,0
 mov eax, 4
 mov byte [bp-2], al

;-99     if (R2Type !=WORD) indexerror();

 mov al, [R2Type]
 cmp al, 2
 je  @@getIndReg241
 call indexerror

;-100     if (R2No==7) if (rm==6) m=3;//BP+DI

@@getIndReg241:
 mov al, [R2No]
 cmp al, 7
 jne @@getIndReg242
 mov al, [rm]
 cmp al, 6
 jne @@getIndReg243
 mov eax, 3
 mov byte [bp-2], al

;-101              else if (rm==7) m=1;//BX+DI

 jmp @@getIndReg244
@@getIndReg243:
 mov al, [rm]
 cmp al, 7
 jne @@getIndReg245
 mov eax, 1
 mov byte [bp-2], al

;-102     if (R2No==6) if (rm==6) m=2;//BP+SI

@@getIndReg245:
@@getIndReg244:
@@getIndReg242:
 mov al, [R2No]
 cmp al, 6
 jne @@getIndReg246
 mov al, [rm]
 cmp al, 6
 jne @@getIndReg247
 mov eax, 2
 mov byte [bp-2], al

;-103              else if (rm==7) m=0;//BX+SI

 jmp @@getIndReg248
@@getIndReg247:
 mov al, [rm]
 cmp al, 7
 jne @@getIndReg249
 mov eax, 0
 mov byte [bp-2], al

;-104     if (m > 3) indexerror();

@@getIndReg249:
@@getIndReg248:
@@getIndReg246:
 mov al, [bp-2]
 cmp al, 3
 jle @@getIndReg250
 call indexerror

;-105     return m;

@@getIndReg250:
 mov al, [bp-2]
 jmp @@retn

;-106 }


;-107                   


;-108 int setwflag() {//word size, bit 0

@@retn: LEAVE
 ret
; ENDP

setwflag:  ; *** PROC ***

;-109     wflag=0;

 mov eax, 0
 mov byte [wflag], al

;-110     if (OpSize == 0) {//do not override OpSize

 mov al, [OpSize]
 cmp al, 0
 jne @@setwflag51

;-111         if (Op == REG) OpSize=R1Type;

 mov al, [Op]
 cmp al, 2
 jne @@setwflag52
 mov al, [R1Type]
 mov byte [OpSize], al

;-112         if (Op2== REG) OpSize=R2Type;        

@@setwflag52:
 mov al, [Op2]
 cmp al, 2
 jne @@setwflag53
 mov al, [R2Type]
 mov byte [OpSize], al

;-113         if (R2Type== SEGREG) OpSize=WORD;

@@setwflag53:
 mov al, [R2Type]
 cmp al, 4
 jne @@setwflag54
 mov eax, 2
 mov byte [OpSize], al

;-114         if (R1Type == SEGREG) OpSize=WORD;        

@@setwflag54:
 mov al, [R1Type]
 cmp al, 4
 jne @@setwflag55
 mov eax, 2
 mov byte [OpSize], al

;-115     }

@@setwflag55:

;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}

@@setwflag51:
 mov al, [OpSize]
 cmp al, 3
 jne @@setwflag56
 call gen66h
 mov eax, 1
 mov byte [wflag], al

;-117     if (OpSize  ==  WORD) wflag=1;

@@setwflag56:
 mov al, [OpSize]
 cmp al, 2
 jne @@setwflag57
 mov eax, 1
 mov byte [wflag], al

;-118 }

@@setwflag57:

;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 

 ret
; ENDP

setsflag:  ; *** PROC ***

;-120     unsigned int ui;    


;-121     sflag=2;   

;Function : setsflag, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var unsg word   120 NULL bp-2    ui;
 ENTER  2,0
 mov eax, 2
 mov byte [sflag], al

;-122     ui = imme & 0xFF80; 

 mov ax, [imme]
 and ax, 65408
 mov word [bp-2], ax

;-123     if(ui != 0) sflag = 0;    //vvv

 mov ax, [bp-2]
 cmp ax, 0
 je  @@setsflag58
 mov eax, 0
 mov byte [sflag], al

;-124     if (OpSize == BYTE) {

@@setsflag58:
 mov al, [OpSize]
 cmp al, 1
 jne @@setsflag59

;-125         if (imme > 255) error1("too big for byte r/m");

 mov ax, [imme]
 cmp ax, 255
 jle @@setsflag60
 push setsflag_0
 call error1
 add  sp, 2

;-126         sflag=0;//byte reg does not need sign extended   

@@setsflag60:
 mov eax, 0
 mov byte [sflag], al

;-127     }


;-128 }

@@setsflag59: LEAVE
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

@@parse61:

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
 jne @@parse62

;-9       if (isLabel) { //set in getName

 mov al, [isLabel]
 or  al, al
 je @@parse63

;-10         storeLabel();

 call storeLabel

;-11         InputPtr++;//remove :

 inc  word [InputPtr]

;-12         getTokeType();

 call getTokeType

;-13       }


;-14     }

@@parse63:

;-15     if (TokeType == ALNUME) {

@@parse62:
 mov al, [TokeType]
 cmp al, 3
 jne @@parse64

;-16       lookCode();// and OpCodePtr

 call lookCode

;-17       if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je @@parse65
 call process

;-18       else getVariable();

 jmp @@parse66
@@parse65:
 call getVariable

;-19       skipRest();

@@parse66:
 call skipRest

;-20     }


;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp @@parse67
@@parse64:
 mov al, [TokeType]
 cmp al, 3
 jle @@parse68
 push parse_0
 call error1
 add  sp, 2

;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");

 jmp @@parse69
@@parse68:
 mov al, [TokeType]
 cmp al, 1
 jne @@parse70
 push parse_1
 call error1
 add  sp, 2

;-23     printLine();

@@parse70:
@@parse69:
@@parse67:
 call printLine

;-24   } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  @@parse71
 jmp @@parse61
@@parse71:

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
 jne @@getTokeType72
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-31   if (c == ';') {TokeType=0; return; }//comment

@@getTokeType72:
 mov al, [bp-2]
 cmp al, 59
 jne @@getTokeType73
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

@@getTokeType73:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getTokeType74
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov eax, 1
 mov byte [TokeType], al
 jmp @@retn

;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

@@getTokeType74:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@getTokeType75
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov eax, 3
 mov byte [TokeType], al
 jmp @@retn

;-34   TokeType=NOALNUME; return;

@@getTokeType75:
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
 je @@storeLabel76
 push storeLabel_0
 call error1
 add  sp, 2

;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);

@@storeLabel76:
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
 jb  @@storeLabel77
 push storeLabel_1
 call errorexit
 add  sp, 2

;-42   LabelMaxIx++;

@@storeLabel77:
 inc  word [LabelMaxIx]

;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 100 ;unsigned : 1
 jl  @@storeLabel78
 push storeLabel_2
 call errorexit
 add  sp, 2

;-44   LabelAddr[LabelMaxIx] = PC;

@@storeLabel78:
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

@@searchLabel79:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel80

;-51     if (eqstr(p, Symbol)) return LIx;//pos of label

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel81
 mov ax, [bp-2]
 jmp @@retn

;-52     j=strlen(p);

@@searchLabel81:
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

 jmp @@searchLabel79
@@searchLabel80:
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
 jne @@getVariable82

;-60     lookCode();

 call lookCode

;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");

 mov al, [CodeType]
 cmp al, 200
 jge @@getVariable83
 push getVariable_0
 call errorexit
 add  sp, 2

;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");

@@getVariable83:
 mov al, [CodeType]
 cmp al, 207
 jle @@getVariable84
 push getVariable_1
 call errorexit
 add  sp, 2

;-63     if (CodeType== 200) {// DB

@@getVariable84:
 mov al, [CodeType]
 cmp al, 200
 jne @@getVariable85

;-64       do { getTokeType();

@@getVariable86:
 call getTokeType

;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable87
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-66         else {

 jmp @@getVariable88
@@getVariable87:

;-67           skipBlank();

 call skipBlank

;-68           if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable89

;-69             do { c= *InputPtr;

@@getVariable90:
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
 je  @@getVariable91
 jmp @@getVariable90
@@getVariable91:

;-73             InputPtr++;

 inc  word [InputPtr]

;-74           }


;-75         }

@@getVariable89:

;-76       } while (isToken(','));

@@getVariable88:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable92
 jmp @@getVariable86
@@getVariable92:

;-77     }


;-78     if (CodeType== 201) {// DW

@@getVariable85:
 mov al, [CodeType]
 cmp al, 201
 jne @@getVariable93

;-79       do { getTokeType();

@@getVariable94:
 call getTokeType

;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable95
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-81       } while (isToken(','));

@@getVariable95:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable96
 jmp @@getVariable94
@@getVariable96:

;-82     }


;-83   }

@@getVariable93:

;-84   else errorexit("DB,DW,DD or RESB,W,D expected");

 jmp @@getVariable97
@@getVariable82:
 push getVariable_2
 call errorexit
 add  sp, 2

;-85 }

@@getVariable97:

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

@@lookCode98:

;-91     if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode99

;-92       while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode100:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode101
 inc  word [OpCodePtr]

;-93       OpCodePtr++; CodeType =*OpCodePtr;

 jmp @@lookCode100
@@lookCode101:
 inc  word [OpCodePtr]
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-94       return;

 jmp @@retn

;-95     }


;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode99:
@@lookCode102:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode103
 inc  word [OpCodePtr]

;-97   OpCodePtr++;

 jmp @@lookCode102
@@lookCode103:
 inc  word [OpCodePtr]

;-98   } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode104
 jmp @@lookCode98
@@lookCode104:

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
 jne @@getCodeSize105

;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize106
 call getTokeType
 mov eax, 1
 jmp @@retn

;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

@@getCodeSize106:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize107
 call getTokeType
 mov eax, 2
 jmp @@retn

;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

@@getCodeSize107:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize108
 call getTokeType
 mov eax, 3
 jmp @@retn

;-106   } return 0;

@@getCodeSize108:
@@getCodeSize105:
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
 jne @@isToken109

;-111     InputPtr++; return 1;} return 0;

 inc  word [InputPtr]
 mov eax, 1
 jmp @@retn
@@isToken109:
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
 je @@need110

;-115       getTokeType();

 call getTokeType

;-116       return;

 jmp @@retn

;-117       }


;-118   error1();

@@need110:
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
 je @@skipRest111
 push skipRest_0
 call error1
 add  sp, 2

;-126 }

@@skipRest111:
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

@@getLine112:

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
 je @@getLine113
 push getLine_0
 call errorexit
 add  sp, 2

;-8     if (DOS_NoBytes == 0) return;

@@getLine113:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne @@getLine114
 jmp @@retn

;-9     *InputPtr = DOS_ByteRead;

@@getLine114:
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
 jb  @@getLine115
 push getLine_1
 call errorexit
 add  sp, 2

;-13   } while (ifEOL(DOS_ByteRead) == 0);

@@getLine115:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne @@getLine116
 jmp @@getLine112
@@getLine116:

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
 jne @@ifEOL117
 mov eax, 1
 jmp @@retn

;-19   if (c == 13) {

@@ifEOL117:
 mov al, [bp+4]
 cmp al, 13
 jne @@ifEOL118

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

@@ifEOL118:
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
 jne @@skipBlank119
 inc  word [InputPtr]
 jmp @@skipblank1

;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

@@skipBlank119:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne @@skipBlank120
 inc  word [InputPtr]
 jmp @@skipblank1

;-28 }

@@skipBlank120:

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
 jne @@letterE121
 mov eax, 1
 jmp @@retn

;-31   if (c=='.') return 1;

@@letterE121:
 mov al, [bp+4]
 cmp al, 46
 jne @@letterE122
 mov eax, 1
 jmp @@retn

;-32   if (c=='?') return 1;

@@letterE122:
 mov al, [bp+4]
 cmp al, 63
 jne @@letterE123
 mov eax, 1
 jmp @@retn

;-33   if (c=='$') return 1;

@@letterE123:
 mov al, [bp+4]
 cmp al, 36
 jne @@letterE124
 mov eax, 1
 jmp @@retn

;-34   if (c> 'z') return 0;

@@letterE124:
 mov al, [bp+4]
 cmp al, 122
 jle @@letterE125
 mov eax, 0
 jmp @@retn

;-35   if (c< '@') return 0; // at included

@@letterE125:
 mov al, [bp+4]
 cmp al, 64
 jge @@letterE126
 mov eax, 0
 jmp @@retn

;-36   if (c> 'Z') { if (c< 'a') return 0; }

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

;-37   return 1;

@@letterE127:
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
 je @@alnumE129
 mov eax, 1
 jmp @@retn

;-41   if (letterE(c)) return 1;

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

;-42   return 0;

@@alnumE130:
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

@@getDigit131:

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
 je @@getDigit132
 jmp @@getDigit131
@@getDigit132:

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

@@getName133:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je @@getName134

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
 jb  @@getName135
 push getName_0
 call errorexit
 add  sp, 2

;-68   }

@@getName135:

;-69   if (c == ':') isLabel=1; else isLabel=0;

 jmp @@getName133
@@getName134:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName136
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName137
@@getName136:
 mov eax, 0
 mov byte [isLabel], al

;-70   p--;

@@getName137:
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
 jge @@testReg138
 mov eax, 0
 jmp @@retn

;-79   if (strlen(Symbol) > 3) return 0;

@@testReg138:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg139
 mov eax, 0
 jmp @@retn

;-80   R2Type=BYTE;

@@testReg139:
 mov eax, 1
 mov byte [R2Type], al

;-81   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg140
 mov eax, 0
 jmp @@retn

;-82   if (eqstr(SymbolUpper, "CL")) return 1;

@@testReg140:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg141
 mov eax, 1
 jmp @@retn

;-83   if (eqstr(SymbolUpper, "DL")) return 2;

@@testReg141:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg142
 mov eax, 2
 jmp @@retn

;-84   if (eqstr(SymbolUpper, "BL")) return 3;

@@testReg142:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg143
 mov eax, 3
 jmp @@retn

;-85   if (eqstr(SymbolUpper, "AH")) return 4;

@@testReg143:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg144
 mov eax, 4
 jmp @@retn

;-86   if (eqstr(SymbolUpper, "CH")) return 5;

@@testReg144:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg145
 mov eax, 5
 jmp @@retn

;-87   if (eqstr(SymbolUpper, "DH")) return 6;

@@testReg145:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg146
 mov eax, 6
 jmp @@retn

;-88   if (eqstr(SymbolUpper, "BH")) return 7;

@@testReg146:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg147
 mov eax, 7
 jmp @@retn

;-89   R2Type=WORD;

@@testReg147:
 mov eax, 2
 mov byte [R2Type], al

;-90   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg148
 mov eax, 0
 jmp @@retn

;-91   if (eqstr(SymbolUpper, "CX")) return 1;

@@testReg148:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg149
 mov eax, 1
 jmp @@retn

;-92   if (eqstr(SymbolUpper, "DX")) return 2;

@@testReg149:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg150
 mov eax, 2
 jmp @@retn

;-93   if (eqstr(SymbolUpper, "BX")) return 3;

@@testReg150:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg151
 mov eax, 3
 jmp @@retn

;-94   if (eqstr(SymbolUpper, "SP")) return 4;

@@testReg151:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg152
 mov eax, 4
 jmp @@retn

;-95   if (eqstr(SymbolUpper, "BP")) return 5;

@@testReg152:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg153
 mov eax, 5
 jmp @@retn

;-96   if (eqstr(SymbolUpper, "SI")) return 6;

@@testReg153:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg154
 mov eax, 6
 jmp @@retn

;-97   if (eqstr(SymbolUpper, "DI")) return 7;

@@testReg154:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 7
 jmp @@retn

;-98   R2Type=SEGREG;

@@testReg155:
 mov eax, 4
 mov byte [R2Type], al

;-99   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg156
 mov eax, 0
 jmp @@retn

;-100   if (eqstr(SymbolUpper, "CS")) return 1;

@@testReg156:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg157
 mov eax, 1
 jmp @@retn

;-101   if (eqstr(SymbolUpper, "SS")) return 2;

@@testReg157:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg158
 mov eax, 2
 jmp @@retn

;-102   if (eqstr(SymbolUpper, "DS")) return 3;

@@testReg158:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg159
 mov eax, 3
 jmp @@retn

;-103   if (eqstr(SymbolUpper, "FS")) return 4;

@@testReg159:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg160
 mov eax, 4
 jmp @@retn

;-104   if (eqstr(SymbolUpper, "GS")) return 5;

@@testReg160:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg161
 mov eax, 5
 jmp @@retn

;-105   R2Type=DWORD;                         

@@testReg161:
 mov eax, 3
 mov byte [R2Type], al

;-106   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg162
 mov eax, 0
 jmp @@retn

;-107   if (eqstr(SymbolUpper, "ECX"))return 1;

@@testReg162:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg163
 mov eax, 1
 jmp @@retn

;-108   if (eqstr(SymbolUpper, "EDX"))return 2;

@@testReg163:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg164
 mov eax, 2
 jmp @@retn

;-109   if (eqstr(SymbolUpper, "EBX"))return 3;

@@testReg164:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg165
 mov eax, 3
 jmp @@retn

;-110   if (eqstr(SymbolUpper, "ESP"))return 4;

@@testReg165:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg166
 mov eax, 4
 jmp @@retn

;-111   if (eqstr(SymbolUpper, "EBP"))return 5;

@@testReg166:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg167
 mov eax, 5
 jmp @@retn

;-112   if (eqstr(SymbolUpper, "ESI"))return 6;

@@testReg167:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg168
 mov eax, 6
 jmp @@retn

;-113   if (eqstr(SymbolUpper, "EDI"))return 7;

@@testReg168:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg169
 mov eax, 7
 jmp @@retn

;-114   R2Type=0; return 0;

@@testReg169:
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
 jne @@printLine170
 push printLine_1
 call prs
 add  sp, 2

;-6     else {

 jmp @@printLine171
@@printLine170:

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

@@printLine172:

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
 jge @@printLine173
 jmp @@printLine172
@@printLine173:

;-15         do {// fill rest with blank

@@printLine174:

;-16             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-17             i++;

 inc  word [bp-2]

;-18         } while (i < OPMAXLEN);

 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine175
 jmp @@printLine174
@@printLine175:

;-19     }


;-20     prscomment(InputBuf);

@@printLine171:
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
 je @@prc176

;-24         if ( _ c==10) {

cmp byte [bp+4], 10
 jne @@prc177

;-25             ax=13; 

 mov  ax, 13

;-26             writetty(); 

 call writetty

;-27             }


;-28         al=c; 

@@prc177:
 mov  al, [bp+4]

;-29         writetty(); 

 call writetty

;-30         }


;-31     fputcR(c,lst_fd); 

@@prc176:
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
@@prscomment178:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment179

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

 jmp @@prscomment178
@@prscomment179:

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

@@prs180:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs181

;-47         c=*s; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-48         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne @@prs182

;-49             if (com) com=0; 

 mov ax, [bp-4]
 or  al, al
 je @@prs183
 mov eax, 0
 mov word [bp-4], ax

;-50                 else com=1;  

 jmp @@prs184
@@prs183:
 mov eax, 1
 mov word [bp-4], ax

;-51         }

@@prs184:

;-52         if (c==92) { 

@@prs182:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs185

;-53             if (com==0) { 

 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs186

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
 jne @@prs187
 mov eax, 10
 mov byte [bp-2], al

;-57                 if (c=='t') c= 9; 

@@prs187:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs188
 mov eax, 9
 mov byte [bp-2], al

;-58             } 

@@prs188:

;-59         } 

@@prs186:

;-60         prc(c); 

@@prs185:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-61         s++;  

 inc  word [bp+4]

;-62     }


;-63 }

 jmp @@prs180
@@prs181:

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
 jle @@printhex4189
 add  byte [bp+4], 7

;-72     prc(c);      

@@printhex4189:
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
 jb  @@printIntU190

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

@@printIntU190:
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
 jne @@getarg191

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

@@getarg191:
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
 je @@getarg192
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

@@getarg192:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-30     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg193
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

@@getarg193:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-32     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg194
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

@@getarg194:
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
 je @@epilog195
 push epilog_1
 call prs
 add  sp, 2

;-47     prs(", Output: "); prs(namelst);

@@epilog195:
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

@@epilog196:

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
 jge @@epilog197
 jmp @@epilog196
@@epilog197:

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
 jb  @@genCode8198
 push genCode8_0
 call errorexit
 add  sp, 2

;-23     if (OpPrintIndex < OPMAXLEN) {

@@genCode8198:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode8199

;-24         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-25         OpPrintIndex++;

 inc  word [OpPrintIndex]

;-26     }


;-27 }

@@genCode8199:

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
 jne @@writeEA200

;-40         xxx |= 0xC0;     

 or  byte [bp+4], 192

;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 

 mov al, [Op2]
 cmp al, 1
 jg  @@writeEA201
 mov al, [bp+4]
 add al, [R1No]
 mov byte [bp+4], al

;-42             else {

 jmp @@writeEA202
@@writeEA201:

;-43                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne @@writeEA203
 mov al, [bp+4]
 add al, [R1No]
 mov byte [bp+4], al

;-44                 else            xxx = xxx + R2No;  

 jmp @@writeEA204
@@writeEA203:
 mov al, [bp+4]
 add al, [R2No]
 mov byte [bp+4], al

;-45             }

@@writeEA204:

;-46         } 

@@writeEA202:

;-47     if (Op == MEM) {

@@writeEA200:
 mov al, [Op]
 cmp al, 4
 jne @@writeEA205

;-48         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@writeEA206

;-49             xxx |= 6;

 or  byte [bp+4], 6

;-50             len = 2;

 mov eax, 2
 mov byte [bp-2], al

;-51         }


;-52         else { 

 jmp @@writeEA207
@@writeEA206:

;-53             xxx = xxx + rm;   

 mov al, [bp+4]
 add al, [rm]
 mov byte [bp+4], al

;-54             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne @@writeEA208

;-55                 len=1;

 mov eax, 1
 mov byte [bp-2], al

;-56                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne @@writeEA209
 or  byte [bp+4], 64

;-57             }

@@writeEA209:

;-58 


;-59             if (disp) {

@@writeEA208:
 mov ax, [disp]
 or  al, al
 je @@writeEA210

;-60                 ax = disp;

 mov  ax, [disp]

;-61                 if(ax > 127) len=2;

 cmp  ax, 127
 jle @@writeEA211
 mov eax, 2
 mov byte [bp-2], al

;-62                 else len=1;

 jmp @@writeEA212
@@writeEA211:
 mov eax, 1
 mov byte [bp-2], al

;-63                 if (len == 1) xxx |= 0x40;

@@writeEA212:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA213
 or  byte [bp+4], 64

;-64                 else xxx |= 0x80;

 jmp @@writeEA214
@@writeEA213:
 or  byte [bp+4], 128

;-65             }

@@writeEA214:

;-66         }

@@writeEA210:

;-67     }  

@@writeEA207:

;-68     


;-69     genCode8(xxx);// gen second byte

@@writeEA205:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-70     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA215
 push word [disp]
 call genCode8
 add  sp, 2

;-71     if (len == 2) genCode16(disp);

@@writeEA215:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA216
 push word [disp]
 call genCode16
 add  sp, 2

;-72 }

@@writeEA216:

;-73 


;-74 int genImmediate() { 
 LEAVE
 ret
; ENDP

genImmediate:  ; *** PROC ***

;-75     if (wflag) genCode16(imme);

 mov al, [wflag]
 or  al, al
 je @@genImmediate217
 push word [imme]
 call genCode16
 add  sp, 2

;-76     else       genCode8 (imme);  

 jmp @@genImmediate218
@@genImmediate217:
 push word [imme]
 call genCode8
 add  sp, 2

;-77 }    

@@genImmediate218:
 ret
; ENDP
;Back to main program: AS.C

;-10 


;-11 int process() { 


process:  ; *** PROC ***

;-12     char c;           


;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char

;Function : process, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte    12 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
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

 mov eax, 0
 mov word [imme], ax
 mov word [disp], ax

;-15     isDirect=1; //set in getMeM=0, need in WriteEA

 mov eax, 1
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
 jne @@process219

;-21         genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-22         return;

 jmp @@retn

;-23     }


;-24   


;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     

@@process219:
 mov al, [CodeType]
 cmp al, 2
 jne @@process220

;-26         getOpL();    

 call getOpL

;-27         checkOpL();        

 call checkOpL

;-28         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  @@process221

;-29   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne @@process222

;-30                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je @@process223
 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code3]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4
 jmp @@retn

;-31             }

@@process223:

;-32         }

@@process222:

;-33         if (Code2 == 5) {//imul extension?

@@process221:
 mov al, [Code2]
 cmp al, 5
 jne @@process224

;-34             getTokeType();

 call getTokeType

;-35             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je @@process225
 call implerror

;-36         }

@@process225:

;-37         genCodeW(Code1);           

@@process224:
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

 jmp @@retn

;-40     }


;-41   


;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs

@@process220:
 mov al, [CodeType]
 cmp al, 3
 jne @@process226

;-43         check2Ops();    //setwflag not applicable

 call check2Ops

;-44         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  @@process227
 call reg16error

;-45         if (Op2 != MEM) addrerror();//only m16 

@@process227:
 mov al, [Op2]
 cmp al, 4
 je  @@process228
 call addrerror

;-46         


;-47         genCode8(Code1);//les,lds,lea

@@process228:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   

 mov al, [Code1]
 cmp al, 15
 jne @@process229
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-49         Op=Op2;//set MEM for writeEA

@@process229:
 mov al, [Op2]
 mov byte [Op], al

;-50         writeEA(R1No);           

 mov al, byte [R1No]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-51         return;

 jmp @@retn

;-52     }


;-53 


;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test

@@process226:
 mov al, [CodeType]
 cmp al, 4
 jne @@process230

;-55         check2Ops();    

 call check2Ops

;-56         if (Op2 == IMM) {//second operand is imm     

 mov al, [Op2]
 cmp al, 1
 jne @@process231

;-57             setsflag();   

 call setsflag

;-58             if (Op == REG) {                

 mov al, [Op]
 cmp al, 2
 jne @@process232

;-59                 if (R1No == 0) {// acc,imm   

 mov al, [R1No]
 cmp al, 0
 jne @@process233

;-60                     if (sflag == 0) {                        

 mov al, [sflag]
 cmp al, 0
 jne @@process234

;-61                         c = Code1 << 3;

 mov al, [Code1]
 shl al, 3
 mov byte [bp-2], al

;-62                         c += 4;    

 add  byte [bp-2], 4

;-63                         genCodeW(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCodeW
 add  sp, 2

;-64                         genImmediate();

 call genImmediate

;-65                         return;

 jmp @@retn

;-66                     }


;-67                 }

@@process234:

;-68             }

@@process233:

;-69             //r/m, imm: 80 sign-extended,TTT,imm


;-70             c = sflag + 0x80;   

@@process232:
 mov al, [sflag]
 add al, 128
 mov byte [bp-2], al

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
 je @@process235
 push word [imme]
 call genCode8
 add  sp, 2

;-74             else genImmediate();    

 jmp @@process236
@@process235:
 call genImmediate

;-75             return;     

@@process236:
 jmp @@retn

;-76         }  


;-77         c = Code1 << 3;//r/m, r/r  

@@process231:
 mov al, [Code1]
 shl al, 3
 mov byte [bp-2], al

;-78         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process237

;-79             if (Op2 == MEM) {//reg, mem      

 mov al, [Op2]
 cmp al, 4
 jne @@process238

;-80                 c += 2;//add direction flag

 add  byte [bp-2], 2

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

 jmp @@retn

;-85             }


;-86         }

@@process238:

;-87         if (Op2 == REG) {//mem,reg    reg,reg

@@process237:
 mov al, [Op2]
 cmp al, 2
 jne @@process239

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

 jmp @@retn

;-91         }          


;-92         syntaxerror();        

@@process239:
 call syntaxerror

;-93         return;

 jmp @@retn

;-94     }


;-95  


;-96     if (CodeType == 5) {//mov (movsx, movzx=51)

@@process230:
 mov al, [CodeType]
 cmp al, 5
 jne @@process240

;-97         check2Ops();    

 call check2Ops

;-98 /*    prs("\n Op:"); printhex8a(Op);


;-99     prs(", Op2:"); printhex8a(Op2);


;-100     prs(", R1No:"); printhex8a(R1No);


;-101     prs(", R2No:"); printhex8a(R2No);   */  


;-102         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne @@process241

;-103             imme=disp;

 mov ax, [disp]
 mov word [imme], ax

;-104             Op2=IMM;//continue with IMM    

 mov eax, 1
 mov byte [Op2], al

;-105         }  


;-106         if (Op2 == IMM) {// r,i     

@@process241:
 mov al, [Op2]
 cmp al, 1
 jne @@process242

;-107             if (Op == REG) {               

 mov al, [Op]
 cmp al, 2
 jne @@process243

;-108                 c = wflag << 3;   

 mov al, [wflag]
 shl al, 3
 mov byte [bp-2], al

;-109                 c += 0xB0;                                     

 add  byte [bp-2], 176

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

 jmp @@retn

;-113             }


;-114             if (Op == MEM) {// m,i  

@@process243:
 mov al, [Op]
 cmp al, 4
 jne @@process244

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

 jmp @@retn

;-119             }


;-120             regmemerror();

@@process244:
 call regmemerror

;-121             return;

 jmp @@retn

;-122         }      


;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

@@process242:
 mov al, [R1Type]
 cmp al, 4
 jne @@process245
 call ChangeDirection

;-124         if (R2Type == SEGREG) {//rm,sreg

@@process245:
 mov al, [R2Type]
 cmp al, 4
 jne @@process246

;-125             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  @@process247
 call reg16error

;-126                 genCode2(0x8C, dflag);

@@process247:
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

 jmp @@retn

;-129         }          


;-130         if (Op2 == MEM) {//acc, moffs16

@@process246:
 mov al, [Op2]
 cmp al, 4
 jne @@process248

;-131             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process249

;-132                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne @@process250

;-133                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@process251

;-134                         genCodeW(0xA0);

 push 160
 call genCodeW
 add  sp, 2

;-135                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-136                         return;   

 jmp @@retn

;-137                     }   


;-138                 }   

@@process251:

;-139             }   

@@process250:

;-140         } 

@@process249:

;-141         if (Op == MEM) {//moffs16, acc

@@process248:
 mov al, [Op]
 cmp al, 4
 jne @@process252

;-142             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne @@process253

;-143                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne @@process254

;-144                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@process255

;-145                         genCodeW(0xA2);

 push 162
 call genCodeW
 add  sp, 2

;-146                         genCode16(disp);

 push word [disp]
 call genCode16
 add  sp, 2

;-147                         return;   

 jmp @@retn

;-148                     }   


;-149                 }   

@@process255:

;-150             }

@@process254:

;-151         


;-152         }

@@process253:

;-153         if (Op2 == REG) {//rm, r

@@process252:
 mov al, [Op2]
 cmp al, 2
 jne @@process256

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

 jmp @@retn

;-157         }


;-158         if (Op2 == MEM) {//r, m

@@process256:
 mov al, [Op2]
 cmp al, 4
 jne @@process257

;-159             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process258

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

 jmp @@retn

;-164             }   


;-165         }         

@@process258:

;-166         syntaxerror();

@@process257:
 call syntaxerror

;-167         return;

 jmp @@retn

;-168     }    


;-169     


;-170     if (CodeType ==  8) {//ret,retf

@@process240:
 mov al, [CodeType]
 cmp al, 8
 jne @@process259

;-171         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne @@process260

;-172             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-173             genCode16(SymbolInt);

 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-174             return;

 jmp @@retn

;-175         }


;-176         genCode8(Code1); 

@@process260:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-177         return;

 jmp @@retn

;-178     }


;-179        


;-180     if (CodeType == 9) {//push, pop  

@@process259:
 mov al, [CodeType]
 cmp al, 9
 jne @@process261

;-181         getOpL();

 call getOpL

;-182         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne @@process262

;-183             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne @@process263

;-184                 setsflag();

 call setsflag

;-185                 genCode2(0x68, sflag);     

 mov al, byte [sflag]
 mov ah, 0
 push ax
 push 104
 call genCode2
 add  sp, 4

;-186                 if (sflag) genCode8 (imme);

 mov al, [sflag]
 or  al, al
 je @@process264
 push word [imme]
 call genCode8
 add  sp, 2

;-187                 else       genCode16(imme);    

 jmp @@process265
@@process264:
 push word [imme]
 call genCode16
 add  sp, 2

;-188                 return;   

@@process265:
 jmp @@retn

;-189             }   


;-190         }

@@process263:

;-191         if (R1Type == SEGREG) {

@@process262:
 mov al, [R1Type]
 cmp al, 4
 jne @@process266

;-192             if (Code1 == 0x58) {

 mov al, [Code1]
 cmp al, 88
 jne @@process267

;-193                 if (R1No == 1) error1("pop cs not allowed");   

 mov al, [R1No]
 cmp al, 1
 jne @@process268
 push process_0
 call error1
 add  sp, 2

;-194             }

@@process268:

;-195             c = R1No <<3;

@@process267:
 mov al, [R1No]
 shl al, 3
 mov byte [bp-2], al

;-196             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle @@process269

;-197                 c += 122;

 add  byte [bp-2], 122

;-198                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-199             }


;-200             OpCodePtr++;

@@process269:
 inc  word [OpCodePtr]

;-201             c = c + *OpCodePtr;//is Code4   

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-202             genCode8(c);  

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-203             return; 

 jmp @@retn

;-204         }  


;-205   


;-206         checkOpL();    

@@process266:
 call checkOpL

;-207         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne @@process270
 call reg16error

;-208         if (R1Type == WORD) {

@@process270:
 mov al, [R1Type]
 cmp al, 2
 jne @@process271

;-209             genCode2(Code1, R1No);

 mov al, byte [R1No]
 mov ah, 0
 push ax
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-210             return;   

 jmp @@retn

;-211         }                


;-212         if (Op == MEM) {

@@process271:
 mov al, [Op]
 cmp al, 4
 jne @@process272

;-213             genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-214             writeEA(Code3);

 mov al, byte [Code3]
 mov ah, 0
 push ax
 call writeEA
 add  sp, 2

;-215             return;   

 jmp @@retn

;-216         }


;-217       


;-218         syntaxerror();

@@process272:
 call syntaxerror

;-219         return;        

 jmp @@retn

;-220     }


;-221     


;-222     if (CodeType == 12) {//int, int3

@@process261:
 mov al, [CodeType]
 cmp al, 12
 jne @@process273

;-223         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne @@process274

;-224             if (SymbolInt == 3) {

 mov ax, [SymbolInt]
 cmp ax, 3
 jne @@process275

;-225                 genCode8(Code2);

 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-226                 return;   

 jmp @@retn

;-227             }


;-228             else {

 jmp @@process276
@@process275:

;-229                 genCode8(Code1);

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-230                 genCode8(SymbolInt);

 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-231                 return;   

 jmp @@retn

;-232             }


;-233         }

@@process276:

;-234     }

@@process274:

;-235     


;-236     if (CodeType == 30) {//enter i18,i8

@@process273:
 mov al, [CodeType]
 cmp al, 30
 jne @@process277

;-237         genCode8(0xC8);

 push 200
 call genCode8
 add  sp, 2

;-238         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-239         if (Op == IMM) genCode16(SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne @@process278
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-240         else numbererror();

 jmp @@process279
@@process278:
 call numbererror

;-241         need(',');

@@process279:
 push 44
 call need
 add  sp, 2

;-242         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-243         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne @@process280
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-244         else numbererror();           

 jmp @@process281
@@process280:
 call numbererror

;-245         return;

@@process281:
 jmp @@retn

;-246     }


;-247        


;-248     if (CodeType==101) {// ORG nn

@@process277:
 mov al, [CodeType]
 cmp al, 101
 jne @@process282

;-249         if (TokeType != DIGIT) error1("only digit allowed");

 mov al, [TokeType]
 cmp al, 1
 je  @@process283
 push process_1
 call error1
 add  sp, 2

;-250         PC=SymbolInt;

@@process283:
 mov ax, [SymbolInt]
 mov word [PC], ax

;-251         return;

 jmp @@retn

;-252     }


;-253     error1("Command not implemented or syntax error");

@@process282:
 push process_2
 call error1
 add  sp, 2

;-254 }    

@@retn: LEAVE
 ret
; ENDP
process_0 db "pop cs not allowed",0
process_1 db "only digit allowed",0
process_2 db "Command not implemented or syntax error",0
 
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

;-255 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-256 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   256 NULL bp+4    s
;  201 var sign byte   256 NULL bp-2    c;
 ENTER  2,0
@@cputs284:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs285
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
 jmp @@cputs284
@@cputs285:

;-257 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   257 NULL bp+4    s;
 ENTER  0,0
@@toupper286:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper287
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper288
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper289
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper289:
@@toupper288:
 inc  word [bp+4]
 jmp @@toupper286
@@toupper287:

;-258 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-259 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   259 NULL bp+4    s
;  201 var sign word   259 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen290:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen291
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen290
@@strlen291:
 mov ax, [bp-2]
 jmp @@retn

;-260 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    5 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   260 NULL bp+4    s
;  201 ptr sign byte   260 NULL bp+6    t;
 ENTER  0,0
@@strcpy292:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-261   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy293
 jmp @@strcpy292
@@strcpy293:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-262 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   262 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit294
 mov eax, 0
 jmp @@retn
@@digit294:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit295
 mov eax, 0
 jmp @@retn
@@digit295:
 mov eax, 1
 jmp @@retn

;-263 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   263 NULL bp+4    p
;  201 ptr sign byte   263 NULL bp+6    q;
 ENTER  0,0
@@eqstr296:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr297

;-264     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr298
 mov eax, 0
 jmp @@retn
@@eqstr298:
 inc  word [bp+4]
 inc  word [bp+6]

;-265     if(*q) return 0; return 1; }

 jmp @@eqstr296
@@eqstr297:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr299
 mov eax, 0
 jmp @@retn
@@eqstr299:
 mov eax, 1
 jmp @@retn

;-266 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   266 NULL bp+4    s
;  201 ptr sign byte   266 NULL bp+6    t;
 ENTER  0,0
@@strcat1300:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1301
 inc  word [bp+4]
 jmp @@strcat1300
@@strcat1301:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-267 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   267 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-268 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   268 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-269 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   269 NULL bp+4    s
;  201 var sign word   269 NULL bp+6    fd
;  202 var sign word   269 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-270 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  200 ptr sign byte   270 NULL bp+4    n
;  201 var sign word   270 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-271   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-272 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign word   272 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-273 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   273 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-274 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
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

;-275 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  200 var sign byte   275 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch302
 mov  al, 13
 call writetty
@@putch302:
 mov  al, [bp+4]
 call writetty

;-276 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt303
 inc  word [DOS_ERR]
@@DosInt303:

;-277 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

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
;    6 var unsg word     5   16        0 SymbolInt
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
;   27 var sign byte    27   22        0 TokeType
;   28 def unsg byte    28    -        0 BYTE=1
;   29 def unsg byte    29    -        0 WORD=2
;   30 def unsg byte    30    -        0 DWORD=3
;   31 def unsg byte    31    -        0 SEGREG=4
;   32 def unsg byte    32    -        0 IMM=1
;   33 def unsg byte    33    -        0 REG=2
;   34 def unsg byte    34    -        0 ADR=3
;   35 def unsg byte    35    -        0 MEM=4
;   36 var sign byte    36   28        0 Op
;   37 var sign byte    37   29        0 Op2
;   38 var sign byte    38   18        0 CodeType
;   39 var sign byte    39   13        0 Code1
;   40 var sign byte    40    8        0 Code2
;   41 var sign byte    41    3        0 Code3
;   42 var sign byte    42   18        0 R2No
;   43 var sign byte    43   16        0 R1No
;   44 var sign byte    44   17        0 R2Type
;   45 var sign byte    45   14        0 R1Type
;   46 var sign byte    46   13        0 OpSize
;   47 var sign byte    47    8        0 wflag
;   48 var sign byte    48    3        0 dflag
;   49 var sign byte    49    8        0 sflag
;   50 var sign byte    50   15        0 rm
;   51 var sign byte    51    5        0 isDirect
;   52 var sign word    52   17        0 disp
;   53 var unsg word    53   10        0 imme
;   54 def unsg byte    55    -        0 OPMAXLEN=5
;   55 arr sign byte    56    2        0 OpPos[5]
;   56 var sign word    57    6        0 OpPrintIndex
;   57 ptr sign byte    58   19        0 OpCodePtr
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
;   95 arr sign byte    27 NULL        0 I_INT3[8]
;   96 arr sign byte    28 NULL        0 I_INTO[8]
;   97 arr sign byte    29 NULL        0 I_IRET[8]
;   98 arr sign byte    30 NULL        0 I_XLAT[8]
;   99 arr sign byte    31 NULL        0 I_LOCK[8]
;  100 arr sign byte    32 NULL        0 I_REPNE[9]
;  101 arr sign byte    33 NULL        0 I_REPNZ[9]
;  102 arr sign byte    34 NULL        0 I_REPE[8]
;  103 arr sign byte    35 NULL        0 I_REPZ[8]
;  104 arr sign byte    36 NULL        0 I_HLT[7]
;  105 arr sign byte    37 NULL        0 I_CLC[7]
;  106 arr sign byte    38 NULL        0 I_STC[7]
;  107 arr sign byte    39 NULL        0 I_CLI[7]
;  108 arr sign byte    40 NULL        0 I_STI[7]
;  109 arr sign byte    41 NULL        0 I_CLD[7]
;  110 arr sign byte    42 NULL        0 I_STD[7]
;  111 arr sign byte    44 NULL        0 I_INC[9]
;  112 arr sign byte    45 NULL        0 I_DEC[9]
;  113 arr sign byte    46 NULL        0 I_NOT[8]
;  114 arr sign byte    47 NULL        0 I_NEG[8]
;  115 arr sign byte    48 NULL        0 I_MUL[8]
;  116 arr sign byte    49 NULL        0 I_IMUL[9]
;  117 arr sign byte    50 NULL        0 I_DIV[8]
;  118 arr sign byte    51 NULL        0 I_IDIV[9]
;  119 arr sign byte    53 NULL        0 I_LES[7]
;  120 arr sign byte    54 NULL        0 I_LDS[7]
;  121 arr sign byte    55 NULL        0 I_LEA[7]
;  122 arr sign byte    56 NULL        0 I_LSS[8]
;  123 arr sign byte    57 NULL        0 I_LFS[8]
;  124 arr sign byte    58 NULL        0 I_LGS[8]
;  125 arr sign byte    60 NULL        0 I_ADD[7]
;  126 arr sign byte    61 NULL        0 I_OR[6]
;  127 arr sign byte    62 NULL        0 I_ADC[7]
;  128 arr sign byte    63 NULL        0 I_SBB[7]
;  129 arr sign byte    64 NULL        0 I_AND[7]
;  130 arr sign byte    65 NULL        0 I_SUB[7]
;  131 arr sign byte    66 NULL        0 I_XOR[7]
;  132 arr sign byte    67 NULL        0 I_CMP[7]
;  133 arr sign byte    68 NULL        0 I_TEST[11]
;  134 arr sign byte    70 NULL        0 I_MOV[6]
;  135 arr sign byte    71 NULL        0 I_MOVSX[9]
;  136 arr sign byte    72 NULL        0 I_MOVZX[9]
;  137 arr sign byte    74 NULL        0 I_JO[6]
;  138 arr sign byte    75 NULL        0 I_JNO[7]
;  139 arr sign byte    76 NULL        0 I_JB[6]
;  140 arr sign byte    77 NULL        0 I_JC[6]
;  141 arr sign byte    78 NULL        0 I_JNB[7]
;  142 arr sign byte    79 NULL        0 I_JAE[7]
;  143 arr sign byte    80 NULL        0 I_JNC[7]
;  144 arr sign byte    81 NULL        0 I_JE[6]
;  145 arr sign byte    82 NULL        0 I_JZ[6]
;  146 arr sign byte    83 NULL        0 I_JNE[7]
;  147 arr sign byte    84 NULL        0 I_JNZ[7]
;  148 arr sign byte    85 NULL        0 I_JBE[7]
;  149 arr sign byte    86 NULL        0 I_JNA[7]
;  150 arr sign byte    87 NULL        0 I_JA[6]
;  151 arr sign byte    88 NULL        0 I_JS[6]
;  152 arr sign byte    89 NULL        0 I_JNS[7]
;  153 arr sign byte    90 NULL        0 I_JP[6]
;  154 arr sign byte    91 NULL        0 I_JPE[7]
;  155 arr sign byte    92 NULL        0 I_JNP[7]
;  156 arr sign byte    93 NULL        0 I_JPO[7]
;  157 arr sign byte    94 NULL        0 I_JL[6]
;  158 arr sign byte    95 NULL        0 I_JNL[7]
;  159 arr sign byte    96 NULL        0 I_JGE[7]
;  160 arr sign byte    97 NULL        0 I_JLE[7]
;  161 arr sign byte    98 NULL        0 I_JNG[7]
;  162 arr sign byte    99 NULL        0 I_JG[6]
;  163 arr sign byte   101 NULL        0 I_JMP[8]
;  164 arr sign byte   102 NULL        0 I_CALL[9]
;  165 arr sign byte   104 NULL        0 I_RET[8]
;  166 arr sign byte   105 NULL        0 I_RETF[9]
;  167 arr sign byte   107 NULL        0 I_PUSH[11]
;  168 arr sign byte   108 NULL        0 I_POP[10]
;  169 arr sign byte   110 NULL        0 I_ROL[7]
;  170 arr sign byte   111 NULL        0 I_ROR[7]
;  171 arr sign byte   112 NULL        0 I_RCL[7]
;  172 arr sign byte   113 NULL        0 I_RCR[7]
;  173 arr sign byte   114 NULL        0 I_SHL[7]
;  174 arr sign byte   115 NULL        0 I_SAL[7]
;  175 arr sign byte   116 NULL        0 I_SHR[7]
;  176 arr sign byte   117 NULL        0 I_SAR[7]
;  177 arr sign byte   119 NULL        0 I_INT[8]
;  178 arr sign byte   130 NULL        0 I_XCHG[9]
;  179 arr sign byte   132 NULL        0 I_LOOPNZ[10]
;  180 arr sign byte   133 NULL        0 I_LOOPNE[10]
;  181 arr sign byte   134 NULL        0 I_LOOPZ[9]
;  182 arr sign byte   135 NULL        0 I_LOOPE[9]
;  183 arr sign byte   136 NULL        0 I_LOOP[8]
;  184 arr sign byte   137 NULL        0 I_JCXZ[8]
;  185 arr sign byte   138 NULL        0 I_JECXZ[9]
;  186 arr sign byte   140 NULL        0 I_ENTER[8]
;  187 arr sign byte   142 NULL        0 I_ORG[6]
;  188 arr sign byte   147 NULL        0 I_DB[5]
;  189 arr sign byte   148 NULL        0 I_DW[5]
;  190 arr sign byte   149 NULL        0 I_DD[5]
;  191 arr sign byte   150 NULL        0 I_RESB[7]
;  192 arr sign byte   151 NULL        0 I_RESW[7]
;  193 arr sign byte   152 NULL        0 I_RESD[7]
;  194 var sign byte   153 NULL        0 I_END


;   # Calls Line Width  Name   list of functions

;    0    2    1 word   ChangeDirection
;    1    2    9 word   checkOpL
;    2    3   18 word   check2Ops
;    3    1   27 word   get2Ops
;    4    3   33 word   getOpL
;    5    2   41 word   getOpR
;    6    4   51 word   getOp1
;    7    1   67 word   getMEM
;    8    1   90 word   getIndReg1
;    9    1   98 word   getIndReg2
;   10    2  108 word   setwflag
;   11    2  119 word   setsflag
;   12    1    1 word   parse
;   13   14   27 word   getTokeType
;   14    2   36 word   storeLabel
;   15    2   46 word   searchLabel
;   16    1   57 word   getVariable
;   17    2   86 word   lookCode
;   18    1  101 word   getCodeSize
;   19    8  108 word   isToken
;   20    2  113 word   need
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
;   45    3  107 word   invaloperror
;   46    3  108 word   numbererror
;   47    1  109 word   regmemerror
;   48    3  110 word   reg16error
;   49    1  111 word   segregerror
;   50    4  112 word   syntaxerror
;   51 NULL  114 word   addrexit
;   52 NULL  115 word   internexit
;   53 NULL    1 word   main
;   54    1    8 word   getarg
;   55    1   42 word   epilog
;   56    2   60 word   end1
;   57    1    2 word   getCodes
;   58    1    7 word   gen66h
;   59    5    9 word   genCode2
;   60   10   13 word   genCodeW
;   61   25   17 word   genCode8
;   62    8   28 word   genCode16
;   63   10   32 word   writeEA
;   64    4   74 word   genImmediate
;   65    1   11 word   process
;   66    4  255 word   writetty
;   67    8  256 word   cputs
;   68    2  257 word   toupper
;   69    3  259 word   strlen
;   70    6  260 word   strcpy
;   71    3  262 word   digit
;   72   35  263 word   eqstr
;   73    3  266 word   strcat1
;   74    1  267 word   openR
;   75    2  268 word   creatR
;   76    2  269 word   readRL
;   77    2  270 word   fputcR
;   78    3  272 word   fcloseR
;   79    5  273 word   exitR
;   80    1  275 word   putch
;   81    4  276 word   DosInt
;   82 NULL  277 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0  1367 implerror
;    1  1377 segregerror
;    2  1389 setwflag
;    3  1398 error1
;    4  1405 error1
;    5  1422 get2Ops
;    6  1430 addrerror
;    7  1440 invaloperror
;    8  1453 immeerror
;    9  1463 addrerror
;   10  1473 invaloperror
;   11  1486 setwflag
;   12  1503 getOpL
;   13  1510 need
;   14  1515 getOpR
;   15  1529 getOpR
;   16  1543 getOp1
;   17  1550 isToken
;   18  1558 getMEM
;   19  1565 invaloperror
;   20  1578 error1
;   21  1592 testReg
;   22  1600 searchLabel
;   23  1612 error1
;   24  1628 getTokeType
;   25  1640 getOp1
;   26  1647 syntaxerror
;   27  1659 getIndReg2
;   28  1670 getIndReg1
;   29  1681 isToken
;   30  1689 getTokeType
;   31  1701 numbererror
;   32  1713 isToken
;   33  1721 isToken
;   34  1729 errorexit
;   35  1750 indexerror
;   36  1761 indexerror
;   37  1785 indexerror
;   38  1796 indexerror
;   39  1816 gen66h
;   40  1835 error1
;   41  1848 getLine
;   42  1856 getTokeType
;   43  1868 storeLabel
;   44  1879 getTokeType
;   45  1891 lookCode
;   46  1900 process
;   47  1908 getVariable
;   48  1920 skipRest
;   49  1929 error1
;   50  1936 error1
;   51  1943 printLine
;   52  1967 skipBlank
;   53  1977 digit
;   54  1983 getDigit
;   55  1992 letterE
;   56  2000 getName
;   57  2021 searchLabel
;   58  2033 error1
;   59  2040 strcpy
;   60  2047 errorexit
;   61  2057 errorexit
;   62  2087 eqstr
;   63  2093 strlen
;   64  2114 storeLabel
;   65  2125 getTokeType
;   66  2137 lookCode
;   67  2146 errorexit
;   68  2156 errorexit
;   69  2166 getTokeType
;   70  2178 genCode8
;   71  2187 skipBlank
;   72  2197 isToken
;   73  2205 genCode8
;   74  2214 isToken
;   75  2222 getTokeType
;   76  2234 genCode16
;   77  2244 isToken
;   78  2252 errorexit
;   79  2271 eqstr
;   80  2289 eqstr
;   81  2295 getTokeType
;   82  2307 eqstr
;   83  2313 getTokeType
;   84  2325 eqstr
;   85  2331 getTokeType
;   86  2353 skipBlank
;   87  2370 isToken
;   88  2378 getTokeType
;   89  2390 error1
;   90  2397 prs
;   91  2401 prc
;   92  2414 getTokeType
;   93  2426 error1
;   94  2443 readRL
;   95  2450 errorexit
;   96  2460 errorexit
;   97  2470 ifEOL
;   98  2484 readRL
;   99  2520 digit
;  100  2526 letterE
;  101  2553 digit
;  102  2573 alnumE
;  103  2580 errorexit
;  104  2590 strcpy
;  105  2597 toupper
;  106  2613 strlen
;  107  2620 strlen
;  108  2627 eqstr
;  109  2633 eqstr
;  110  2639 eqstr
;  111  2645 eqstr
;  112  2651 eqstr
;  113  2657 eqstr
;  114  2663 eqstr
;  115  2669 eqstr
;  116  2675 eqstr
;  117  2681 eqstr
;  118  2687 eqstr
;  119  2693 eqstr
;  120  2699 eqstr
;  121  2705 eqstr
;  122  2711 eqstr
;  123  2717 eqstr
;  124  2723 eqstr
;  125  2729 eqstr
;  126  2735 eqstr
;  127  2741 eqstr
;  128  2747 eqstr
;  129  2753 eqstr
;  130  2759 eqstr
;  131  2765 eqstr
;  132  2771 eqstr
;  133  2777 eqstr
;  134  2783 eqstr
;  135  2789 eqstr
;  136  2795 eqstr
;  137  2801 eqstr
;  138  2821 prs
;  139  2825 printhex16
;  140  2836 prs
;  141  2840 prc
;  142  2844 printhex8a
;  143  2855 prc
;  144  2859 prs
;  145  2863 prscomment
;  146  2880 writetty
;  147  2889 writetty
;  148  2898 fputcR
;  149  2920 prc
;  150  2936 prc
;  151  2957 printhex4
;  152  2967 printhex4
;  153  2989 prc
;  154  3011 printhex8a
;  155  3022 printhex8a
;  156  3047 printIntU
;  157  3057 prc
;  158  3070 prs
;  159  3074 prs
;  160  3078 prs
;  161  3082 prs
;  162  3098 error1
;  163  3105 end1
;  164  3123 error1
;  165  3140 error1
;  166  3157 error1
;  167  3174 error1
;  168  3192 error1
;  169  3212 error1
;  170  3231 error1
;  171  3250 error1
;  172  3268 error1
;  173  3287 error1
;  174  3306 error1
;  175  3322 errorexit
;  176  3343 errorexit
;  177  3358 getarg
;  178  3365 parse
;  179  3371 epilog
;  180  3378 end1
;  181  3402 cputs
;  182  3408 cputs
;  183  3414 exitR
;  184  3420 toupper
;  185  3428 strcpy
;  186  3435 strcat1
;  187  3443 strcpy
;  188  3450 strcat1
;  189  3458 strcpy
;  190  3465 strcat1
;  191  3473 openR
;  192  3479 cputs
;  193  3485 cputs
;  194  3491 exitR
;  195  3497 creatR
;  196  3504 cputs
;  197  3510 cputs
;  198  3516 exitR
;  199  3522 creatR
;  200  3529 cputs
;  201  3535 cputs
;  202  3541 exitR
;  203  3547 prs
;  204  3551 prs
;  205  3555 prs
;  206  3559 prs
;  207  3563 prs
;  208  3567 prs
;  209  3571 prs
;  210  3575 prs
;  211  3579 prs
;  212  3596 prs
;  213  3600 printIntU
;  214  3610 prs
;  215  3614 prs
;  216  3618 prs
;  217  3622 prs
;  218  3626 printIntU
;  219  3636 prs
;  220  3640 fputcR
;  221  3654 fcloseR
;  222  3662 fcloseR
;  223  3670 fcloseR
;  224  3678 exitR
;  225  3700 genCode8
;  226  3722 genCode8
;  227  3742 genCode8
;  228  3762 errorexit
;  229  3784 genCode8
;  230  3793 genCode8
;  231  3818 genCode8
;  232  3827 genCode8
;  233  3836 genCode16
;  234  3859 genCode16
;  235  3869 genCode8
;  236  3888 getTokeType
;  237  3900 getCodeSize
;  238  3912 getCodes
;  239  3921 genCode8
;  240  3930 getOpL
;  241  3937 checkOpL
;  242  3946 genCode2
;  243  3955 getTokeType
;  244  3967 implerror
;  245  3977 genCodeW
;  246  3986 writeEA
;  247  3994 check2Ops
;  248  4004 reg16error
;  249  4015 addrerror
;  250  4025 genCode8
;  251  4034 genCode8
;  252  4043 writeEA
;  253  4051 check2Ops
;  254  4061 setsflag
;  255  4070 genCodeW
;  256  4079 genImmediate
;  257  4092 genCodeW
;  258  4101 writeEA
;  259  4109 genCode8
;  260  4118 genImmediate
;  261  4131 genCodeW
;  262  4140 writeEA
;  263  4148 genCodeW
;  264  4157 writeEA
;  265  4165 syntaxerror
;  266  4177 check2Ops
;  267  4187 genCode2
;  268  4196 genImmediate
;  269  4209 genCodeW
;  270  4218 writeEA
;  271  4226 genImmediate
;  272  4239 regmemerror
;  273  4251 ChangeDirection
;  274  4267 reg16error
;  275  4278 genCode2
;  276  4287 writeEA
;  277  4295 genCodeW
;  278  4304 genCode16
;  279  4314 genCodeW
;  280  4323 genCode16
;  281  4333 genCodeW
;  282  4342 writeEA
;  283  4350 ChangeDirection
;  284  4366 genCodeW
;  285  4375 writeEA
;  286  4383 syntaxerror
;  287  4395 genCode8
;  288  4404 genCode16
;  289  4414 genCode8
;  290  4423 getOpL
;  291  4430 setsflag
;  292  4439 genCode2
;  293  4448 genCode8
;  294  4457 genCode16
;  295  4467 error1
;  296  4474 genCode8
;  297  4483 genCode8
;  298  4492 checkOpL
;  299  4501 reg16error
;  300  4512 genCode2
;  301  4521 genCode8
;  302  4530 writeEA
;  303  4538 syntaxerror
;  304  4550 genCode8
;  305  4559 genCode8
;  306  4568 genCode8
;  307  4577 genCode8
;  308  4586 getOp1
;  309  4593 genCode16
;  310  4603 numbererror
;  311  4615 need
;  312  4620 getOp1
;  313  4627 genCode8
;  314  4636 numbererror
;  315  4648 error1
;  316  4655 error1
;  317  4681 putch
;  318  4749 strcpy
;  319  4764 DosInt
;  320  4780 DosInt
;  321  4803 DosInt
;  322  4822 DosInt
;  323  4856 writetty
;  324  4865 writetty
;Input: AS.C, List: AS.S,  Lines:  278
;Glob. variables:  194 max.:  200
;Local variables:    3 max.:  100, in 'searchLabel'
;Functions      :   83 max.:  300
;Calls          :  325 max.: 2000, NameField: 4897 max.:    65535
;Code until     :25998 max.: 30000, free: 4002
;Data (HeapEnd) :33595, resting stacksize: 31940
;Max. Const in 'testReg' :  658 max. 3000, free: 2342