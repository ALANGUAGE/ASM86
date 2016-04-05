
; A.COM V0.8, Source: AS.C, Out asm: AS.S
org  256 
jmp main

;-1 char Version1[]="AS.C V0.1";//BAS.BAT, AS TE, NAS.BAT

Version1 db "AS.C V0.1",0

;-2 #include "DECL.C"

;Use include file: DECL.C

;-1 char LIST;              //listing on/off     

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

;-6 unsigned long SymbolLong;//integer value set in getDigit

SymbolLong dd 0

;-7 #define INPUTBUFMAX 255


;-8 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test

section .bss
absolute 30062
InputBuf resb 255
section .text

;-9 unsigned char *InputPtr;//position in InputBuf

InputPtr dw 0

;-10 char namein [67];       //input file name  .S

section .bss
absolute 30317
namein resb 67
section .text

;-11 char namelst[67];       //list file name   .LST

section .bss
absolute 30384
namelst resb 67
section .text

;-12 char namebin[67];       //output file name .COM

section .bss
absolute 30451
namebin resb 67
section .text

;-13 int  asm_fd;            //input file descriptor

asm_fd dw 0

;-14 int lst_fd;             //list file descriptor

lst_fd dw 0

;-15 int bin_fd;             //output file descriptor

bin_fd dw 0

;-16 int DOS_ERR=0;          //global var

DOS_ERR dw 0

;-17 int ErrorCount=0;       //number of errors

ErrorCount dw 0

;-18 int DOS_NoBytes;        //number of bytes read (0 or 1)

DOS_NoBytes dw 0

;-19 char DOS_ByteRead;      //the byte just read by DOS

DOS_ByteRead db 0

;-20 


;-21 unsigned int PC=0;      //program counter

PC dw 0

;-22 unsigned int Origin=0;  //ORG nn   

Origin dw 0

;-23 unsigned int AbsoluteLab=0;//uninitialised data

AbsoluteLab dw 0

;-24 unsigned int PCStart;   //PC at start of line by PrintLine()

PCStart dw 0

;-25 char isLabel;           //by getName()

isLabel db 0

;-26 #define DIGIT    1      //0-9


;-27 #define LETTERE  2      //a-z A-Z @ . _


;-28 #define ALNUME   3      //a-z A-Z @ . _  0-9


;-29 #define NOALNUME 4      //other char


;-30 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME

TokeType db 0

;-31 #define BYTE     1


;-32 #define WORD     2


;-33 #define DWORD    3


;-34 #define SEGREG   4


;-35 #define IMM      1      //const  ,123


;-36 #define REG      2      //       ,BX    mode=11


;-37 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110


;-38 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16


;-39 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  

Op db 0

;-40 char Op2;               //2. operand

Op2 db 0

;-41 char CodeType;          //1-207 by searchSymbol(), must be byte size

CodeType db 0

;-42 char Code1;             //1. Opcode

Code1 db 0

;-43 char Code2;             //2. Opcode

Code2 db 0

;-44 char Code3;             //3. Opcode

Code3 db 0

;-45 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  

R2No db 0

;-46 char R1No;              //temp for 1. register

R1No db 0

;-47 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG

R2Type db 0

;-48 char R1Type;            //temp for 1. register 

R1Type db 0

;-49 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()

OpSize db 0

;-50 char wflag;             //wordflag: 0=byte, 1=word/dword

wflag db 0

;-51 char dflag;             //directionflag: 1=to reg MOV,ALU    

dflag db 0

;-52 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 

sflag db 0

;-53 char rm;                //combination of index and base reg

rm db 0

;-54 char isDirect;          //set in process and getMeM, need in WriteEA

isDirect db 0

;-55 int disp;               //displacement      0-8 bytes

disp dw 0

;-56 unsigned int imme;      //immediate         0-8 bytes

imme dw 0

;-57 


;-58 #define OPMAXLEN 5


;-59 char OpPos[OPMAXLEN];   //array for one opcode to list

section .bss
absolute 30518
OpPos resb 5
section .text

;-60 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8

OpPrintIndex dw 0

;-61 char *OpCodePtr;        //position in OpCodeTable by searchSymbol

OpCodePtr dw 0

;-62 char PrintRA;           //print * for forward relocative jmp

PrintRA db 0

;-63 


;-64 #define LABELNAMESMAX 3969//next number - SYMBOLMAX


;-65 char LabelNames[4000];  //space for names of all labels

section .bss
absolute 30523
LabelNames resb 4000
section .text

;-66 char *LabelNamePtr;     //first free position

LabelNamePtr dw 0

;-67 #define LABELADRMAX 600


;-68 unsigned int LabelAddr[LABELADRMAX];//addr of each label

section .bss
absolute 34523
LabelAddr resw 600
section .text

;-69 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1

LabelMaxIx dw 0

;-70 int LabelIx;            //actual # of just searched label

LabelIx dw 0

;-71 


;-72 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX


;-73 char JmpCallNames[2000];//space for names of jmp, call

section .bss
absolute 35723
JmpCallNames resb 2000
section .text

;-74 char *JmpCallNamePtr;   //first free position 

JmpCallNamePtr dw 0

;-75 #define JMPCALLMAX 500  //max. jmp and call


;-76 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed

section .bss
absolute 37723
JmpCallAddr resw 500
section .text

;-77 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1

JmpCallMaxIx dw 0

;-78  


;-79 #define FILEBINMAX 20000 


;-80 char FileBin  [FILEBINMAX];//output binary file

section .bss
absolute 38723
FileBin resb 20000
section .text

;-81 unsigned int BinLen=0;  //length of binary file

BinLen dw 0

;-82 


;-83 char *arglen=0x80;      // for main only

arglen dw 128

;-84 char *argv=0x82;        // for main only

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

;-115 char I_SAL[]=  {'S','A','L',0,          11, 4,    0xF1};

I_SAL db 83,65,76,0,11,4,241

;-116 char I_SHR[]=  {'S','H','R',0,          11, 5,    0xF1};

I_SHR db 83,72,82,0,11,5,241

;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};

I_SAR db 83,65,82,0,11,7,241

;-118 //  12: int


;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};

I_INT db 73,78,84,0,12,205,204,241

;-120 //  14: in/out


;-121 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};

I_IN db 73,78,0,14,228,236,241

;-122 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};

I_INSB db 73,78,83,66,0,14,108,241

;-123 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};

I_INSW db 73,78,83,87,0,14,109,241

;-124 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};

I_INSD db 73,78,83,68,0,14,109,241

;-125 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};

I_OUT db 79,85,84,0,14,230,238,241

;-126 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};

I_OUTSB db 79,85,84,66,0,14,110,241

;-127 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};

I_OUTSW db 79,85,84,87,0,14,111,241

;-128 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};

I_OUTSD db 79,85,84,68,0,14,111,241

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


;-144 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};

I_SECTION db 83,69,67,84,73,79,78,0,102,241

;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};

I_SEGMENT db 83,69,71,77,69,78,84,0,102,241

;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};

I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241

;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};

I_DB db 68,66,0,200,241

;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};

I_DW db 68,87,0,201,241

;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};

I_DD db 68,68,0,202,241

;-150 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};

I_RESB db 82,69,83,66,0,203,241

;-151 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};

I_RESW db 82,69,83,87,0,204,241

;-152 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};

I_RESD db 82,69,83,68,0,205,241

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
;  250 var sign byte     2 NULL bp-2    c;
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

;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov           

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
;  250 var sign byte    69 NULL bp-2    c;
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
;  250 var sign byte    98 NULL bp-2    m;
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
;  250 var unsg word   120 NULL bp-2    ui;
 ENTER  2,0
 mov eax, 2
 mov byte [sflag], al

;-122     ui = imme & 0xFF80;//is greater than signed 127? 

 mov ax, [imme]
 and ax, 65408
 mov word [bp-2], ax

;-123     if(ui != 0) sflag = 0;

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

@@setsflag59:

;-129 int checkConstSize(unsigned int ui) {    
 LEAVE
 ret
; ENDP
setsflag_0 db "too big for byte r/m",0

checkConstSize:  ; *** PROC ***

;-130     if (ui > 127   ) return 0;//is near; return sflag

;Function : checkConstSize, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var unsg word   129 NULL bp+4    ui;
 ENTER  0,0
 mov ax, [bp+4]
 cmp ax, 127
 jle @@checkConstSize61
 mov eax, 0
 jmp @@retn

;-131     if (ui < 0xFF80) return 0;//-128dez    

@@checkConstSize61:
 mov ax, [bp+4]
 cmp ax, 65408
 jge @@checkConstSize62
 mov eax, 0
 jmp @@retn

;-132     return 2;// is short        

@@checkConstSize62:
 mov eax, 2
 jmp @@retn

;-133 }

@@retn: LEAVE
 ret
; ENDP
;Back to main program: AS.C

;-5 #include "PARSE.C"

;Use include file: PARSE.C

;-1 int parse() {


parse:  ; *** PROC ***

;-2     LabelNamePtr  = &LabelNames;    

 mov ax, LabelNames
 mov word [LabelNamePtr], ax

;-3     JmpCallNamePtr= &JmpCallNames;

 mov ax, JmpCallNames
 mov word [JmpCallNamePtr], ax

;-4     LabelMaxIx=0;    

 mov eax, 0
 mov word [LabelMaxIx], ax

;-5     JmpCallMaxIx=0;  

 mov eax, 0
 mov word [JmpCallMaxIx], ax

;-6     BinLen=0;

 mov eax, 0
 mov word [BinLen], ax

;-7     


;-8     do {//process a new line

@@parse63:

;-9         PCStart=PC; 

 mov ax, [PC]
 mov word [PCStart], ax

;-10         OpSize=0;

 mov eax, 0
 mov byte [OpSize], al

;-11         OpPrintIndex=0; 

 mov eax, 0
 mov word [OpPrintIndex], ax

;-12         PrintRA=' ';

 mov eax, 32
 mov byte [PrintRA], al

;-13         getLine();

 call getLine

;-14         InputPtr = &InputBuf;

 mov ax, InputBuf
 mov word [InputPtr], ax

;-15         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName

 call getTokeType

;-16         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@parse64

;-17             if (isLabel) {//set in getName

 mov al, [isLabel]
 or  al, al
 je @@parse65

;-18                 storeLabel();

 call storeLabel

;-19                 InputPtr++;//remove :

 inc  word [InputPtr]

;-20                 getTokeType();

 call getTokeType

;-21             }


;-22         }

@@parse65:

;-23         if (TokeType == ALNUME) {

@@parse64:
 mov al, [TokeType]
 cmp al, 3
 jne @@parse66

;-24             lookCode();// and OpCodePtr

 call lookCode

;-25             if(CodeType) process();

 mov al, [CodeType]
 or  al, al
 je @@parse67
 call process

;-26             else getVariable();

 jmp @@parse68
@@parse67:
 call getVariable

;-27             skipRest();

@@parse68:
 call skipRest

;-28         }


;-29         else if (TokeType >ALNUME) error1("Label or instruction expected");

 jmp @@parse69
@@parse66:
 mov al, [TokeType]
 cmp al, 3
 jle @@parse70
 push parse_0
 call error1
 add  sp, 2

;-30         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");

 jmp @@parse71
@@parse70:
 mov al, [TokeType]
 cmp al, 1
 jne @@parse72
 push parse_1
 call error1
 add  sp, 2

;-31         printLine();

@@parse72:
@@parse71:
@@parse69:
 call printLine

;-32     } while (DOS_NoBytes != 0 );

 mov ax, [DOS_NoBytes]
 cmp ax, 0
 je  @@parse73
 jmp @@parse63
@@parse73:

;-33 }


;-34 


;-35 int getTokeType() { 

 ret
; ENDP
parse_0 db "Label or instruction expected",0
parse_1 db "No digit allowed at start of line",0

getTokeType:  ; *** PROC ***

;-36     char c;


;-37     skipBlank();

;Function : getTokeType, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte    36 NULL bp-2    c;
 ENTER  2,0
 call skipBlank

;-38     c = *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-39     if (c == 0)   {TokeType=0; return; }//last line or empty line

 mov al, [bp-2]
 cmp al, 0
 jne @@getTokeType74
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-40     if (c == ';') {TokeType=0; return; }//comment

@@getTokeType74:
 mov al, [bp-2]
 cmp al, 59
 jne @@getTokeType75
 mov eax, 0
 mov byte [TokeType], al
 jmp @@retn

;-41     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt

@@getTokeType75:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@getTokeType76
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getDigit
 add  sp, 2
 mov eax, 1
 mov byte [TokeType], al
 jmp @@retn

;-42     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol

@@getTokeType76:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@getTokeType77
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call getName
 add  sp, 2
 mov eax, 3
 mov byte [TokeType], al
 jmp @@retn

;-43     TokeType=NOALNUME;

@@getTokeType77:
 mov eax, 4
 mov byte [TokeType], al

;-44 }                     


;-45 


;-46 int storeJmpCall() {

@@retn: LEAVE
 ret
; ENDP

storeJmpCall:  ; *** PROC ***

;-47     unsigned int i;


;-48     JmpCallMaxIx++;

;Function : storeJmpCall, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var unsg word    47 NULL bp-2    i;
 ENTER  2,0
 inc  word [JmpCallMaxIx]

;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");

 mov ax, [JmpCallMaxIx]
 cmp ax, 500 ;unsigned : 1
 jl  @@storeJmpCall78
 push storeJmpCall_0
 call errorexit
 add  sp, 2

;-50     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);

@@storeJmpCall78:
 lea  ax, [Symbol]
 push ax
 push word [JmpCallNamePtr]
 call strcpy
 add  sp, 4
 mov word [JmpCallNamePtr], ax

;-51     JmpCallNamePtr++;

 inc  word [JmpCallNamePtr]

;-52     i = JmpCallNamePtr - &JmpCallNames;    

 mov ax, [JmpCallNamePtr]
 sub ax, JmpCallNames
 mov word [bp-2], ax

;-53     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");

 mov ax, [bp-2]
 cmp ax, 1969 ;unsigned : 0
 jb  @@storeJmpCall79
 push storeJmpCall_1
 call errorexit
 add  sp, 2

;-54     JmpCallAddr[JmpCallMaxIx] = PC;   

@@storeJmpCall79:
 mov ax, [PC]
 mov bx, [JmpCallMaxIx]
 shl bx, 1
 mov [JmpCallAddr+bx], ax

;-55 }


;-56 


;-57 int storeLabel() {
 LEAVE
 ret
; ENDP
storeJmpCall_0 db "too many JmpCalls",0
storeJmpCall_1 db "too many JmpCall names",0

storeLabel:  ; *** PROC ***

;-58     unsigned int i;


;-59     LabelMaxIx++;

;Function : storeLabel, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var unsg word    58 NULL bp-2    i;
 ENTER  2,0
 inc  word [LabelMaxIx]

;-60     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");

 mov ax, [LabelMaxIx]
 cmp ax, 600 ;unsigned : 1
 jl  @@storeLabel80
 push storeLabel_0
 call errorexit
 add  sp, 2

;-61     if(searchLabel()) error1("duplicate label");

@@storeLabel80:
 call searchLabel
 or  al, al
 je @@storeLabel81
 push storeLabel_1
 call error1
 add  sp, 2

;-62     LabelNamePtr=strcpy(LabelNamePtr, Symbol);

@@storeLabel81:
 lea  ax, [Symbol]
 push ax
 push word [LabelNamePtr]
 call strcpy
 add  sp, 4
 mov word [LabelNamePtr], ax

;-63     LabelNamePtr++;

 inc  word [LabelNamePtr]

;-64     i = LabelNamePtr - &LabelNames;

 mov ax, [LabelNamePtr]
 sub ax, LabelNames
 mov word [bp-2], ax

;-65     if (i >= LABELNAMESMAX) errorexit("too many label names");

 mov ax, [bp-2]
 cmp ax, 3969 ;unsigned : 0
 jb  @@storeLabel82
 push storeLabel_2
 call errorexit
 add  sp, 2

;-66     LabelAddr[LabelMaxIx] = PC + Origin;

@@storeLabel82:
 mov ax, [PC]
 add ax, [Origin]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-67 }   


;-68 


;-69 int searchLabel() {
 LEAVE
 ret
; ENDP
storeLabel_0 db "too many labels",0
storeLabel_1 db "duplicate label",0
storeLabel_2 db "too many label names",0

searchLabel:  ; *** PROC ***

;-70     int LIx; char *p;


;-71     p = &LabelNames;

;Function : searchLabel, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 var sign word    70 NULL bp-2    LIx
;  251 ptr sign byte    70 NULL bp-4    p;
 ENTER  4,0
 mov ax, LabelNames
 mov word [bp-4], ax

;-72     LIx = 1;

 mov eax, 1
 mov word [bp-2], ax

;-73     while (LIx <= LabelMaxIx) {

@@searchLabel83:
 mov ax, [bp-2]
 cmp ax, [LabelMaxIx]
 jg  @@searchLabel84

;-74         if (eqstr(p, Symbol)) return LIx;//pos of label                    

 lea  ax, [Symbol]
 push ax
 push word [bp-4]
 call eqstr
 add  sp, 4
 or  al, al
 je @@searchLabel85
 mov ax, [bp-2]
 jmp @@retn

;-75         p=strlen(p) + p;                  

@@searchLabel85:
 push word [bp-4]
 call strlen
 add  sp, 2
 add ax, [bp-4]
 mov word [bp-4], ax

;-76         p++; 

 inc  word [bp-4]

;-77         LIx++;

 inc  word [bp-2]

;-78     }


;-79     return 0;

 jmp @@searchLabel83
@@searchLabel84:
 mov eax, 0
 jmp @@retn

;-80 }   


;-81 


;-82 int getVariable() { 

@@retn: LEAVE
 ret
; ENDP

getVariable:  ; *** PROC ***

;-83     char c; 


;-84     storeLabel();

;Function : getVariable, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte    83 NULL bp-2    c;
 ENTER  2,0
 call storeLabel

;-85     getTokeType(); 

 call getTokeType

;-86     if(TokeType==ALNUME) {//getName

 mov al, [TokeType]
 cmp al, 3
 jne @@getVariable86

;-87         lookCode();

 call lookCode

;-88         if (CodeType < 200) dataexit();

 mov al, [CodeType]
 cmp al, 200
 jge @@getVariable87
 call dataexit

;-89         if (CodeType > 205) dataexit();

@@getVariable87:
 mov al, [CodeType]
 cmp al, 205
 jle @@getVariable88
 call dataexit

;-90         if (CodeType== 200) {//DB

@@getVariable88:
 mov al, [CodeType]
 cmp al, 200
 jne @@getVariable89

;-91             do { 

@@getVariable90:

;-92                 getTokeType();

 call getTokeType

;-93                 if (TokeType == DIGIT) genCode8(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable91
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-94                 else {

 jmp @@getVariable92
@@getVariable91:

;-95                     skipBlank();

 call skipBlank

;-96                     if (isToken('"')) {

 push 34
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable93

;-97                         do { 

@@getVariable94:

;-98                             c= *InputPtr;

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-99                             genCode8(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-100                             InputPtr++;

 inc  word [InputPtr]

;-101                         } while (*InputPtr != '"' );

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 34
 je  @@getVariable95
 jmp @@getVariable94
@@getVariable95:

;-102                         InputPtr++;

 inc  word [InputPtr]

;-103                     }


;-104                 }

@@getVariable93:

;-105             } while (isToken(','));

@@getVariable92:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable96
 jmp @@getVariable90
@@getVariable96:

;-106         }


;-107         if (CodeType == 201) {//DW

@@getVariable89:
 mov al, [CodeType]
 cmp al, 201
 jne @@getVariable97

;-108             do { 

@@getVariable98:

;-109                 getTokeType();

 call getTokeType

;-110                 if (TokeType ==DIGIT) genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable99
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-111             } while (isToken(','));

@@getVariable99:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable100
 jmp @@getVariable98
@@getVariable100:

;-112         } 


;-113         if (CodeType == 202) {//DD

@@getVariable97:
 mov al, [CodeType]
 cmp al, 202
 jne @@getVariable101

;-114             do { 

@@getVariable102:

;-115                 getTokeType();

 call getTokeType

;-116                 if (TokeType ==DIGIT) { genCode16(SymbolInt);

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable103
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-117                                     genCode16(0);}//todo genCode32(SymbolLong);

 push 0
 call genCode16
 add  sp, 2

;-118             } while (isToken(','));

@@getVariable103:
 push 44
 call isToken
 add  sp, 2
 or  al, al
 je @@getVariable104
 jmp @@getVariable102
@@getVariable104:

;-119         } 


;-120         if (CodeType >= 203) {//resb, resw, resd

@@getVariable101:
 mov al, [CodeType]
 cmp al, 203 ;unsigned : 1
 jl  @@getVariable105

;-121             getTokeType();

 call getTokeType

;-122             if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne @@getVariable106

;-123                 if (SymbolInt <= 0) syntaxerror();   

 mov ax, [SymbolInt]
 cmp ax, 0
 ja  @@getVariable107
 call syntaxerror

;-124                 if (AbsoluteLab == 0) error1("Absolute is null");

@@getVariable107:
 mov ax, [AbsoluteLab]
 cmp ax, 0
 jne @@getVariable108
 push getVariable_0
 call error1
 add  sp, 2

;-125                 LabelAddr[LabelMaxIx] = AbsoluteLab; 

@@getVariable108:
 mov ax, [AbsoluteLab]
 mov bx, [LabelMaxIx]
 shl bx, 1
 mov [LabelAddr+bx], ax

;-126                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw

 mov al, [CodeType]
 cmp al, 204
 jne @@getVariable109
 mov ax, [SymbolInt]
 add ax, [SymbolInt]
 mov word [SymbolInt], ax

;-127                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd                  

@@getVariable109:
 mov al, [CodeType]
 cmp al, 205
 jne @@getVariable110
 mov ax, [SymbolInt]
 mov ebx, 4
 mul ebx
 mov word [SymbolInt], ax

;-128                 AbsoluteLab = AbsoluteLab + SymbolInt;

@@getVariable110:
 mov ax, [AbsoluteLab]
 add ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-129             } else numbererror();  

 jmp @@getVariable111
@@getVariable106:
 call numbererror

;-130         }    

@@getVariable111:

;-131     }

@@getVariable105:

;-132     else dataexit();

 jmp @@getVariable112
@@getVariable86:
 call dataexit

;-133 }

@@getVariable112:

;-134 


;-135 int lookCode() {//ret: CodeType, *OpCodePtr
 LEAVE
 ret
; ENDP
getVariable_0 db "Absolute is null",0

lookCode:  ; *** PROC ***

;-136     CodeType=0;

 mov eax, 0
 mov byte [CodeType], al

;-137     OpCodePtr= &I_START;

 mov ax, I_START
 mov word [OpCodePtr], ax

;-138     OpCodePtr++;

 inc  word [OpCodePtr]

;-139     do  {

@@lookCode113:

;-140         if (eqstr(SymbolUpper, OpCodePtr))  {

 push word [OpCodePtr]
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@lookCode114

;-141             while(*OpCodePtr!=0) OpCodePtr++;

@@lookCode115:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode116
 inc  word [OpCodePtr]

;-142             OpCodePtr++; 

 jmp @@lookCode115
@@lookCode116:
 inc  word [OpCodePtr]

;-143             CodeType =*OpCodePtr;

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 mov byte [CodeType], al

;-144             return;

 jmp @@retn

;-145         }


;-146     while(*OpCodePtr!=0xF1) OpCodePtr++;

@@lookCode114:
@@lookCode117:
 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 241
 je  @@lookCode118
 inc  word [OpCodePtr]

;-147     OpCodePtr++;

 jmp @@lookCode117
@@lookCode118:
 inc  word [OpCodePtr]

;-148     } while(*OpCodePtr!=0);

 mov bx, [OpCodePtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@lookCode119
 jmp @@lookCode113
@@lookCode119:

;-149 }


;-150 


;-151 int getCodeSize() {

@@retn:
 ret
; ENDP

getCodeSize:  ; *** PROC ***

;-152     if (TokeType ==ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@getCodeSize120

;-153         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}

 push getCodeSize_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize121
 call getTokeType
 mov eax, 1
 jmp @@retn

;-154         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}

@@getCodeSize121:
 push getCodeSize_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize122
 call getTokeType
 mov eax, 2
 jmp @@retn

;-155         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}

@@getCodeSize122:
 push getCodeSize_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@getCodeSize123
 call getTokeType
 mov eax, 3
 jmp @@retn

;-156     } 

@@getCodeSize123:

;-157     return 0;

@@getCodeSize120:
 mov eax, 0
 jmp @@retn

;-158 }


;-159 int isToken(char c) {

@@retn:
 ret
; ENDP
getCodeSize_0 db "BYTE",0
getCodeSize_1 db "WORD",0
getCodeSize_2 db "DWORD",0

isToken:  ; *** PROC ***

;-160     skipBlank();

;Function : isToken, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte   159 NULL bp+4    c;
 ENTER  0,0
 call skipBlank

;-161     if (*InputPtr == c) {

 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp al, [bp+4]
 jne @@isToken124

;-162         InputPtr++; 

 inc  word [InputPtr]

;-163         return 1;

 mov eax, 1
 jmp @@retn

;-164         } 


;-165     return 0;

@@isToken124:
 mov eax, 0
 jmp @@retn

;-166 }


;-167 int need(char c) {

@@retn: LEAVE
 ret
; ENDP

need:  ; *** PROC ***

;-168     if (isToken(c)) {

;Function : need, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte   167 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call isToken
 add  sp, 2
 or  al, al
 je @@need125

;-169         getTokeType();

 call getTokeType

;-170         return;

 jmp @@retn

;-171         }


;-172     error1();

@@need125:
 call error1

;-173     prs(". need: ");

 push need_0
 call prs
 add  sp, 2

;-174     prc(c);

 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-175 }


;-176 int skipRest() {

@@retn: LEAVE
 ret
; ENDP
need_0 db ". need: ",0

skipRest:  ; *** PROC ***

;-177     getTokeType(); 

 call getTokeType

;-178     if(TokeType)error1("extra char ignored");

 mov al, [TokeType]
 or  al, al
 je @@skipRest126
 push skipRest_0
 call error1
 add  sp, 2

;-179 }

@@skipRest126:
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
;  250 var unsg word     2 NULL bp-2    i;
 ENTER  2,0
 mov ax, InputBuf
 mov word [InputPtr], ax

;-4   *InputPtr=0;//if last line is empty

 mov eax, 0
 mov  bx, [InputPtr]
 mov  [bx], al

;-5   do {

@@getLine127:

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
 je @@getLine128
 push getLine_0
 call errorexit
 add  sp, 2

;-8     if (DOS_NoBytes == 0) return;

@@getLine128:
 mov ax, [DOS_NoBytes]
 cmp ax, 0
 jne @@getLine129
 jmp @@retn

;-9     *InputPtr = DOS_ByteRead;

@@getLine129:
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
 cmp ax, 255 ;unsigned : 0
 jb  @@getLine130
 push getLine_1
 call errorexit
 add  sp, 2

;-13   } while (ifEOL(DOS_ByteRead) == 0);

@@getLine130:
 mov al, byte [DOS_ByteRead]
 mov ah, 0
 push ax
 call ifEOL
 add  sp, 2
 cmp al, 0
 jne @@getLine131
 jmp @@getLine127
@@getLine131:

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
;  250 var sign byte    17 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 10
 jne @@ifEOL132
 mov eax, 1
 jmp @@retn

;-19   if (c == 13) {

@@ifEOL132:
 mov al, [bp+4]
 cmp al, 13
 jne @@ifEOL133

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

@@ifEOL133:
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
 jne @@skipBlank134
 inc  word [InputPtr]
 jmp @@skipblank1

;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }

@@skipBlank134:
 mov bx, [InputPtr]
 mov al, [bx]
 mov ah, 0
 cmp ax, 9
 jne @@skipBlank135
 inc  word [InputPtr]
 jmp @@skipblank1

;-28 }

@@skipBlank135:

;-29 int letterE(char c) {

 ret
; ENDP

letterE:  ; *** PROC ***

;-30   if (c=='_') return 1;

;Function : letterE, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte    29 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 95
 jne @@letterE136
 mov eax, 1
 jmp @@retn

;-31   if (c=='.') return 1;

@@letterE136:
 mov al, [bp+4]
 cmp al, 46
 jne @@letterE137
 mov eax, 1
 jmp @@retn

;-32   if (c=='?') return 1;

@@letterE137:
 mov al, [bp+4]
 cmp al, 63
 jne @@letterE138
 mov eax, 1
 jmp @@retn

;-33   if (c=='$') return 1;

@@letterE138:
 mov al, [bp+4]
 cmp al, 36
 jne @@letterE139
 mov eax, 1
 jmp @@retn

;-34   if (c> 'z') return 0;

@@letterE139:
 mov al, [bp+4]
 cmp al, 122
 jle @@letterE140
 mov eax, 0
 jmp @@retn

;-35   if (c< '@') return 0; // at included

@@letterE140:
 mov al, [bp+4]
 cmp al, 64
 jge @@letterE141
 mov eax, 0
 jmp @@retn

;-36   if (c> 'Z') { if (c< 'a') return 0; }

@@letterE141:
 mov al, [bp+4]
 cmp al, 90
 jle @@letterE142
 mov al, [bp+4]
 cmp al, 97
 jge @@letterE143
 mov eax, 0
 jmp @@retn
@@letterE143:

;-37   return 1;

@@letterE142:
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
;  250 var sign byte    39 NULL bp+4    c;
 ENTER  0,0
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call digit
 add  sp, 2
 or  al, al
 je @@alnumE144
 mov eax, 1
 jmp @@retn

;-41   if (letterE(c)) return 1;

@@alnumE144:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call letterE
 add  sp, 2
 or  al, al
 je @@alnumE145
 mov eax, 1
 jmp @@retn

;-42   return 0;

@@alnumE145:
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
;  250 var unsg byte    44 NULL bp+4    c
;  251 var unsg word    45 NULL bp-2    CastInt;
 ENTER  2,0
 mov eax, 0
 mov word [SymbolInt], ax

;-47   do {

@@getDigit146:

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
 je @@getDigit147
 jmp @@getDigit146
@@getDigit147:

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
;  250 var unsg byte    56 NULL bp+4    c
;  251 ptr sign byte    57 NULL bp-2    p
;  252 var unsg word    57 NULL bp-4    i;
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

@@getName148:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call alnumE
 add  sp, 2
 or  al, al
 je @@getName149

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
 jb  @@getName150
 push getName_0
 call errorexit
 add  sp, 2

;-68   }

@@getName150:

;-69   if (c == ':') isLabel=1; else isLabel=0;

 jmp @@getName148
@@getName149:
 mov al, [bp+4]
 cmp al, 58
 jne @@getName151
 mov eax, 1
 mov byte [isLabel], al
 jmp @@getName152
@@getName151:
 mov eax, 0
 mov byte [isLabel], al

;-70   p--;

@@getName152:
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
 jge @@testReg153
 mov eax, 0
 jmp @@retn

;-79   if (strlen(Symbol) > 3) return 0;

@@testReg153:
 lea  ax, [Symbol]
 push ax
 call strlen
 add  sp, 2
 cmp al, 3
 jle @@testReg154
 mov eax, 0
 jmp @@retn

;-80   R2Type=BYTE;

@@testReg154:
 mov eax, 1
 mov byte [R2Type], al

;-81   if (eqstr(SymbolUpper, "AL")) return 0;

 push testReg_0
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg155
 mov eax, 0
 jmp @@retn

;-82   if (eqstr(SymbolUpper, "CL")) return 1;

@@testReg155:
 push testReg_1
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg156
 mov eax, 1
 jmp @@retn

;-83   if (eqstr(SymbolUpper, "DL")) return 2;

@@testReg156:
 push testReg_2
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg157
 mov eax, 2
 jmp @@retn

;-84   if (eqstr(SymbolUpper, "BL")) return 3;

@@testReg157:
 push testReg_3
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg158
 mov eax, 3
 jmp @@retn

;-85   if (eqstr(SymbolUpper, "AH")) return 4;

@@testReg158:
 push testReg_4
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg159
 mov eax, 4
 jmp @@retn

;-86   if (eqstr(SymbolUpper, "CH")) return 5;

@@testReg159:
 push testReg_5
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg160
 mov eax, 5
 jmp @@retn

;-87   if (eqstr(SymbolUpper, "DH")) return 6;

@@testReg160:
 push testReg_6
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg161
 mov eax, 6
 jmp @@retn

;-88   if (eqstr(SymbolUpper, "BH")) return 7;

@@testReg161:
 push testReg_7
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg162
 mov eax, 7
 jmp @@retn

;-89   R2Type=WORD;

@@testReg162:
 mov eax, 2
 mov byte [R2Type], al

;-90   if (eqstr(SymbolUpper, "AX")) return 0;

 push testReg_8
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg163
 mov eax, 0
 jmp @@retn

;-91   if (eqstr(SymbolUpper, "CX")) return 1;

@@testReg163:
 push testReg_9
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg164
 mov eax, 1
 jmp @@retn

;-92   if (eqstr(SymbolUpper, "DX")) return 2;

@@testReg164:
 push testReg_10
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg165
 mov eax, 2
 jmp @@retn

;-93   if (eqstr(SymbolUpper, "BX")) return 3;

@@testReg165:
 push testReg_11
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg166
 mov eax, 3
 jmp @@retn

;-94   if (eqstr(SymbolUpper, "SP")) return 4;

@@testReg166:
 push testReg_12
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg167
 mov eax, 4
 jmp @@retn

;-95   if (eqstr(SymbolUpper, "BP")) return 5;

@@testReg167:
 push testReg_13
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg168
 mov eax, 5
 jmp @@retn

;-96   if (eqstr(SymbolUpper, "SI")) return 6;

@@testReg168:
 push testReg_14
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg169
 mov eax, 6
 jmp @@retn

;-97   if (eqstr(SymbolUpper, "DI")) return 7;

@@testReg169:
 push testReg_15
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg170
 mov eax, 7
 jmp @@retn

;-98   R2Type=SEGREG;

@@testReg170:
 mov eax, 4
 mov byte [R2Type], al

;-99   if (eqstr(SymbolUpper, "ES")) return 0;

 push testReg_16
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg171
 mov eax, 0
 jmp @@retn

;-100   if (eqstr(SymbolUpper, "CS")) return 1;

@@testReg171:
 push testReg_17
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg172
 mov eax, 1
 jmp @@retn

;-101   if (eqstr(SymbolUpper, "SS")) return 2;

@@testReg172:
 push testReg_18
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg173
 mov eax, 2
 jmp @@retn

;-102   if (eqstr(SymbolUpper, "DS")) return 3;

@@testReg173:
 push testReg_19
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg174
 mov eax, 3
 jmp @@retn

;-103   if (eqstr(SymbolUpper, "FS")) return 4;

@@testReg174:
 push testReg_20
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg175
 mov eax, 4
 jmp @@retn

;-104   if (eqstr(SymbolUpper, "GS")) return 5;

@@testReg175:
 push testReg_21
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg176
 mov eax, 5
 jmp @@retn

;-105   R2Type=DWORD;                         

@@testReg176:
 mov eax, 3
 mov byte [R2Type], al

;-106   if (eqstr(SymbolUpper, "EAX"))return 0;

 push testReg_22
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg177
 mov eax, 0
 jmp @@retn

;-107   if (eqstr(SymbolUpper, "ECX"))return 1;

@@testReg177:
 push testReg_23
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg178
 mov eax, 1
 jmp @@retn

;-108   if (eqstr(SymbolUpper, "EDX"))return 2;

@@testReg178:
 push testReg_24
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg179
 mov eax, 2
 jmp @@retn

;-109   if (eqstr(SymbolUpper, "EBX"))return 3;

@@testReg179:
 push testReg_25
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg180
 mov eax, 3
 jmp @@retn

;-110   if (eqstr(SymbolUpper, "ESP"))return 4;

@@testReg180:
 push testReg_26
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg181
 mov eax, 4
 jmp @@retn

;-111   if (eqstr(SymbolUpper, "EBP"))return 5;

@@testReg181:
 push testReg_27
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg182
 mov eax, 5
 jmp @@retn

;-112   if (eqstr(SymbolUpper, "ESI"))return 6;

@@testReg182:
 push testReg_28
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg183
 mov eax, 6
 jmp @@retn

;-113   if (eqstr(SymbolUpper, "EDI"))return 7;

@@testReg183:
 push testReg_29
 lea  ax, [SymbolUpper]
 push ax
 call eqstr
 add  sp, 4
 or  al, al
 je @@testReg184
 mov eax, 7
 jmp @@retn

;-114   R2Type=0; return 0;

@@testReg184:
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
;  250 var sign word     2 NULL bp-2    i
;  251 var sign byte     2 NULL bp-4    c;
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
 jne @@printLine185
 push printLine_1
 call prs
 add  sp, 2

;-6     else {

 jmp @@printLine186
@@printLine185:

;-7 //        prc(' ');


;-8         i=0;

 mov eax, 0
 mov word [bp-2], ax

;-9         do {

@@printLine187:

;-10             c=OpPos[i];

 mov bx, [bp-2]
 mov al, [OpPos + bx]
 mov byte [bp-4], al

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

 inc  word [bp-2]

;-14         } while (i < OpPrintIndex);

 mov ax, [bp-2]
 cmp ax, [OpPrintIndex]
 jge @@printLine188
 jmp @@printLine187
@@printLine188:

;-15         while (i < OPMAXLEN) {// fill rest with blank

@@printLine189:
 mov ax, [bp-2]
 cmp ax, 5
 jge @@printLine190

;-16             prs("   ");

 push printLine_2
 call prs
 add  sp, 2

;-17             i++;

 inc  word [bp-2]

;-18         }


;-19     }

 jmp @@printLine189
@@printLine190:

;-20     prc(PrintRA);

@@printLine186:
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
; ENDP
printLine_0 db "\n",0
printLine_1 db "               ",0
printLine_2 db "   ",0

prc:  ; *** PROC ***

;-24     if (LIST) { 

;Function : prc, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var unsg byte    23 NULL bp+4    c;
 ENTER  0,0
 mov al, [LIST]
 or  al, al
 je @@prc191

;-25         if ( _ c==10) {

cmp byte [bp+4], 10
 jne @@prc192

;-26             ax=13; 

 mov  ax, 13

;-27             writetty(); 

 call writetty

;-28             }


;-29         al=c; 

@@prc192:
 mov  al, [bp+4]

;-30         writetty(); 

 call writetty

;-31         }


;-32     fputcR(c,lst_fd); 

@@prc191:
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
; ENDP

prscomment:  ; *** PROC ***

;-36     unsigned char c;


;-37     while (*s){

;Function : prscomment, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 ptr unsg byte    35 NULL bp+4    s
;  251 var unsg byte    36 NULL bp-2    c;
 ENTER  2,0
@@prscomment193:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prscomment194

;-38         c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-39         prc(c);

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-40         s++;

 inc  word [bp+4]

;-41     }


;-42 }

 jmp @@prscomment193
@@prscomment194:

;-43 int prs(unsigned char *s) {
 LEAVE
 ret
; ENDP

prs:  ; *** PROC ***

;-44     unsigned char c; 


;-45     int com; 


;-46     com=0;

;Function : prs, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  250 ptr unsg byte    43 NULL bp+4    s
;  251 var unsg byte    44 NULL bp-2    c
;  252 var sign word    45 NULL bp-4    com;
 ENTER  4,0
 mov eax, 0
 mov word [bp-4], ax

;-47     while (*s) { 

@@prs195:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@prs196

;-48         c=*s; 

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-49         if (c==34) {

 mov al, [bp-2]
 cmp al, 34
 jne @@prs197

;-50             if (com) com=0; 

 mov ax, [bp-4]
 or  al, al
 je @@prs198
 mov eax, 0
 mov word [bp-4], ax

;-51                 else com=1;  

 jmp @@prs199
@@prs198:
 mov eax, 1
 mov word [bp-4], ax

;-52         }

@@prs199:

;-53         if (c==92) { 

@@prs197:
 mov al, [bp-2]
 cmp al, 92
 jne @@prs200

;-54             if (com==0) { 

 mov ax, [bp-4]
 cmp ax, 0
 jne @@prs201

;-55                 s++; 

 inc  word [bp+4]

;-56                 c=*s;

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-57                 if (c=='n') c=10; 

 mov al, [bp-2]
 cmp al, 110
 jne @@prs202
 mov eax, 10
 mov byte [bp-2], al

;-58                 if (c=='t') c= 9; 

@@prs202:
 mov al, [bp-2]
 cmp al, 116
 jne @@prs203
 mov eax, 9
 mov byte [bp-2], al

;-59             } 

@@prs203:

;-60         } 

@@prs201:

;-61         prc(c); 

@@prs200:
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-62         s++;  

 inc  word [bp+4]

;-63     }


;-64 }

 jmp @@prs195
@@prs196:

;-65 int printhex8a(unsigned char c) { 
 LEAVE
 ret
; ENDP

printhex8a:  ; *** PROC ***

;-66     unsigned char nib;


;-67     nib = c >> 4; printhex4(nib);                    

;Function : printhex8a, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 var unsg byte    65 NULL bp+4    c
;  251 var unsg byte    66 NULL bp-2    nib;
 ENTER  2,0
 mov al, [bp+4]
 shr al, 4
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-68     nib = c & 15; printhex4(nib);                    

 mov al, [bp+4]
 and al, 15
 mov byte [bp-2], al
 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call printhex4
 add  sp, 2

;-69 } 


;-70 int printhex4(unsigned char c) {
 LEAVE
 ret
; ENDP

printhex4:  ; *** PROC ***

;-71     c += 48; 

;Function : printhex4, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var unsg byte    70 NULL bp+4    c;
 ENTER  0,0
 add  byte [bp+4], 48

;-72     if (c > 57) c += 7; 

 mov al, [bp+4]
 cmp al, 57
 jle @@printhex4204
 add  byte [bp+4], 7

;-73     prc(c);      

@@printhex4204:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call prc
 add  sp, 2

;-74 }


;-75 int printhex16(unsigned int i) {
 LEAVE
 ret
; ENDP

printhex16:  ; *** PROC ***

;-76     unsigned int half;


;-77     half = i >>  8; printhex8a(half); 

;Function : printhex16, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 var unsg word    75 NULL bp+4    i
;  251 var unsg word    76 NULL bp-2    half;
 ENTER  2,0
 mov ax, [bp+4]
 shr ax, 8
 mov word [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-78     half = i & 255; printhex8a(half);

 mov ax, [bp+4]
 and ax, 255
 mov word [bp-2], ax
 push word [bp-2]
 call printhex8a
 add  sp, 2

;-79 }


;-80 int printIntU(unsigned int n) { 
 LEAVE
 ret
; ENDP

printIntU:  ; *** PROC ***

;-81     unsigned int e;


;-82     if ( _ n >= 10) {  

;Function : printIntU, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 var unsg word    80 NULL bp+4    n
;  251 var unsg word    81 NULL bp-2    e;
 ENTER  2,0
cmp word [bp+4], 10 ;unsigned : 0
 jb  @@printIntU205

;-83         e=n/10; //DIV

 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov word [bp-2], ax

;-84         printIntU(e); 

 push word [bp-2]
 call printIntU
 add  sp, 2

;-85     }


;-86     n = n % 10; //unsigned mod

@@printIntU205:
 mov ax, [bp+4]
 mov bx, 10
 mov dx, 0
 div bx
 mov ax, dx
 mov word [bp+4], ax

;-87     n += '0'; 

 add  word [bp+4], 48

;-88     prc(n);

 push word [bp+4]
 call prc
 add  sp, 2

;-89 }


;-90 


;-91 int error1(char *s) { 
 LEAVE
 ret
; ENDP

error1:  ; *** PROC ***

;-92     LIST=1; 

;Function : error1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte    91 NULL bp+4    s;
 ENTER  0,0
 mov eax, 1
 mov byte [LIST], al

;-93     ErrorCount++;

 inc  word [ErrorCount]

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
; ENDP
error1_0 db "\n;***** next line ERROR: ",0
error1_1 db ", Symbol: ",0

errorexit:  ; *** PROC ***

;-100     error1(s); 

;Function : errorexit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte    99 NULL bp+4    s;
 ENTER  0,0
 push word [bp+4]
 call error1
 add  sp, 2

;-101     end1(1);

 push 1
 call end1
 add  sp, 2

;-102 }


;-103 int allowederror() {error1("not allowed here"); }
 LEAVE
 ret
; ENDP

allowederror:  ; *** PROC ***
 push allowederror_0
 call error1
 add  sp, 2

;-104 int addrerror()    {error1("address missing");} 

 ret
; ENDP
allowederror_0 db "not allowed here",0

addrerror:  ; *** PROC ***
 push addrerror_0
 call error1
 add  sp, 2

;-105 int immeerror()    {error1("immediate not allowed here");}

 ret
; ENDP
addrerror_0 db "address missing",0

immeerror:  ; *** PROC ***
 push immeerror_0
 call error1
 add  sp, 2

;-106 int implerror()    {error1("not implemented");}

 ret
; ENDP
immeerror_0 db "immediate not allowed here",0

implerror:  ; *** PROC ***
 push implerror_0
 call error1
 add  sp, 2

;-107 int indexerror()   {error1("invalid index register");}

 ret
; ENDP
implerror_0 db "not implemented",0

indexerror:  ; *** PROC ***
 push indexerror_0
 call error1
 add  sp, 2

;-108 int invaloperror() {error1("invalid or no operands");}

 ret
; ENDP
indexerror_0 db "invalid index register",0

invaloperror:  ; *** PROC ***
 push invaloperror_0
 call error1
 add  sp, 2

;-109 int numbererror()  {error1("number expected");}

 ret
; ENDP
invaloperror_0 db "invalid or no operands",0

numbererror:  ; *** PROC ***
 push numbererror_0
 call error1
 add  sp, 2

;-110 int regmemerror()  {error1("only register or memory allowed");}

 ret
; ENDP
numbererror_0 db "number expected",0

regmemerror:  ; *** PROC ***
 push regmemerror_0
 call error1
 add  sp, 2

;-111 int reg16error()   {error1("only reg16, no segreg allowed");}

 ret
; ENDP
regmemerror_0 db "only register or memory allowed",0

reg16error:  ; *** PROC ***
 push reg16error_0
 call error1
 add  sp, 2

;-112 int segregerror()  {error1("segment register not allowed");}

 ret
; ENDP
reg16error_0 db "only reg16, no segreg allowed",0

segregerror:  ; *** PROC ***
 push segregerror_0
 call error1
 add  sp, 2

;-113 int syntaxerror()  {error1("syntax");}

 ret
; ENDP
segregerror_0 db "segment register not allowed",0

syntaxerror:  ; *** PROC ***
 push syntaxerror_0
 call error1
 add  sp, 2

;-114          


;-115 int addrexit()     {errorexit("illegal address");}   

 ret
; ENDP
syntaxerror_0 db "syntax",0

addrexit:  ; *** PROC ***
 push addrexit_0
 call errorexit
 add  sp, 2

;-116 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}

 ret
; ENDP
addrexit_0 db "illegal address",0

dataexit:  ; *** PROC ***
 push dataexit_0
 call errorexit
 add  sp, 2

;-117 int internexit()   {errorexit("intern compiler error");}

 ret
; ENDP
dataexit_0 db "DB,DW,DD or RESB,W,D expected",0

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
; ENDP

getarg:  ; *** PROC ***

;-10     int arglen1; int i; char *c;


;-11     arglen1=*arglen;

;Function : getarg, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  250 var sign word    10 NULL bp-2    arglen1
;  251 var sign word    10 NULL bp-4    i
;  252 ptr sign byte    10 NULL bp-6    c;
 ENTER  6,0
 mov bx, [arglen]
 mov al, [bx]
 mov ah, 0
 mov word [bp-2], ax

;-12     if (arglen1==0) {

 mov ax, [bp-2]
 cmp ax, 0
 jne @@getarg206

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

@@getarg206:
 mov ax, [bp-2]
 add ax, 129
 mov word [bp-4], ax

;-18     *i=0;  

 mov eax, 0
 mov  bx, [bp-4]
 mov  [bx], ax

;-19     arglen1--;

 dec  word [bp-2]

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

 mov eax, 1
 mov byte [LIST], al
 mov eax, 0
 mov word [DOS_ERR], ax
 mov eax, 0
 mov word [PC], ax
 mov eax, 0
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
 je @@getarg207
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

@@getarg207:
 lea  ax, [namelst]
 push ax
 call creatR
 add  sp, 2
 mov word [lst_fd], ax

;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg208
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

@@getarg208:
 lea  ax, [namebin]
 push ax
 call creatR
 add  sp, 2
 mov word [bin_fd], ax

;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}

 mov ax, [DOS_ERR]
 or  al, al
 je @@getarg209
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

@@getarg209:
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

fixJmpCall:  ; *** PROC ***

;-44     int i;  unsigned int hex;  char *p; int Ix; char c;


;-45     i=1;     

;Function : fixJmpCall, Number of local variables: 5
;   # type sign width line used address name   list of local variables
;  250 var sign word    44 NULL bp-2    i
;  251 var unsg word    44 NULL bp-4    hex
;  252 ptr sign byte    44 NULL bp-6    p
;  253 var sign word    44 NULL bp-8    Ix
;  254 var sign byte    44 NULL bp-10    c;
 ENTER  10,0
 mov eax, 1
 mov word [bp-2], ax

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
 mov word [bp-6], ax

;-49     while (i <= JmpCallMaxIx) {

@@fixJmpCall210:
 mov ax, [bp-2]
 cmp ax, [JmpCallMaxIx]
 jg  @@fixJmpCall211

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
 mov word [bp-6], ax

;-52         p++;

 inc  word [bp-6]

;-53 //        prs(Symbol);


;-54 //        prc(' ');  


;-55         hex = JmpCallAddr[i];

 mov bx, [bp-2]
 shl bx, 1
 mov ax, [JmpCallAddr + bx]
 mov word [bp-4], ax

;-56 //        printhex16(hex);


;-57             


;-58         Ix=searchLabel();

 call searchLabel
 mov word [bp-8], ax

;-59         if (Ix == 0) error1("Label not found");

 mov ax, [bp-8]
 cmp ax, 0
 jne @@fixJmpCall212
 push fixJmpCall_1
 call error1
 add  sp, 2

;-60         disp = LabelAddr[Ix];

@@fixJmpCall212:
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
 mov word [bp-4], ax

;-66             FileBin[hex] = disp;//fix low byte    

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-67             hex++;

 inc  word [bp-4]

;-68             disp = disp >> 8;

 mov ax, [disp]
 shr ax, 8
 mov word [disp], ax

;-69             FileBin[hex] = disp;            

 mov ax, [disp]
 mov bx, [bp-4]
 mov [FileBin+bx], al

;-70         i++;

 inc  word [bp-2]

;-71     }


;-72 }

 jmp @@fixJmpCall210
@@fixJmpCall211:

;-73 


;-74 int epilog() { 
 LEAVE
 ret
; ENDP
fixJmpCall_0 db "\n;END open jmp/call: ",0
fixJmpCall_1 db "Label not found",0

epilog:  ; *** PROC ***

;-75     unsigned int i; char c;     int j;


;-76     prs("\n Errors: "); 

;Function : epilog, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  250 var unsg word    75 NULL bp-2    i
;  251 var sign byte    75 NULL bp-4    c
;  252 var sign word    75 NULL bp-6    j;
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
 je @@epilog213
 push epilog_1
 call prs
 add  sp, 2

;-79     prs(", Out: "); 

@@epilog213:
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

 mov eax, 0
 mov word [bp-2], ax

;-88     do {

@@epilog214:

;-89         c = FileBin[i];

 mov bx, [bp-2]
 mov al, [FileBin + bx]
 mov byte [bp-4], al

;-90         fputcR(c, bin_fd);  

 push word [bin_fd]
 mov al, byte [bp-4]
 mov ah, 0
 push ax
 call fputcR
 add  sp, 4

;-91 //printhex8a(c); prc(' ');      


;-92         i++;

 inc  word [bp-2]

;-93     } while (i < BinLen);

 mov ax, [bp-2]
 cmp ax, [BinLen]
 jge @@epilog215
 jmp @@epilog214
@@epilog215:

;-94 


;-95   prs("\ Labels: "); 

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

;-98 /*  prs("size: ");


;-99   i= &LabelNames; i=LabelNamePtr-i; printIntU(i); 


;-100   prs(". >>");


;-101   i= &LabelNames;


;-102   do { c=*i; if (c==0) c=' '; prc(c); i++;


;-103   } while (i < LabelNamePtr); prs("<< \n");  */


;-104 /*    i = 1;


;-105     LabelNamePtr= &LabelNames;


;-106     do {


;-107       prs(LabelNamePtr); prc(' ');


;-108       j=LabelAddr[i]; printhex16(j); prs(", ");


;-109       j=strlen(LabelNamePtr);//get end of actual name


;-110       LabelNamePtr=LabelNamePtr+j;


;-111       LabelNamePtr++;


;-112       i++;


;-113     } while (i <= LabelMaxIx);


;-114 */


;-115 }


;-116 


;-117 int end1(int n) {
 LEAVE
 ret
; ENDP
epilog_0 db "\n Errors: ",0
epilog_1 db " ***ERROR*** ",0
epilog_2 db ", Out: ",0
epilog_3 db ", ",0
epilog_4 db "= ",0
epilog_5 db " bytes.",0
epilog_6 db "\ Labels: ",0
epilog_7 db ". ",0

end1:  ; *** PROC ***

;-118     fcloseR(asm_fd);

;Function : end1, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign word   117 NULL bp+4    n;
 ENTER  0,0
 push word [asm_fd]
 call fcloseR
 add  sp, 2

;-119     fcloseR(lst_fd);

 push word [lst_fd]
 call fcloseR
 add  sp, 2

;-120     fcloseR(bin_fd);

 push word [bin_fd]
 call fcloseR
 add  sp, 2

;-121     exitR(n);

 push word [bp+4]
 call exitR
 add  sp, 2

;-122 }
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
;  250 var sign byte     9 NULL bp+4    c
;  251 var sign byte     9 NULL bp+6    d;
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
;  250 var sign byte    13 NULL bp+4    c;
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
;  250 var sign byte    17 NULL bp+4    c;
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
 cmp ax, 20000 ;unsigned : 0
 jb  @@genCode8216
 push genCode8_0
 call errorexit
 add  sp, 2

;-23     if (OpPrintIndex < OPMAXLEN) {

@@genCode8216:
 mov ax, [OpPrintIndex]
 cmp ax, 5
 jge @@genCode8217

;-24         OpPos[OpPrintIndex]=c;

 mov al, [bp+4]
 mov bx, [OpPrintIndex]
 mov [OpPos+bx], al

;-25         OpPrintIndex++;

 inc  word [OpPrintIndex]

;-26     }


;-27 }

@@genCode8217:

;-28 int genCode16(unsigned int i) {
 LEAVE
 ret
; ENDP
genCode8_0 db "COM file too long",0

genCode16:  ; *** PROC ***

;-29     genCode8(i); i=i >> 8;

;Function : genCode16, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var unsg word    28 NULL bp+4    i;
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


;-32 int genCode32(unsigned long L) {
 LEAVE
 ret
; ENDP

genCode32:  ; *** PROC ***

;-33     genCode16(L); L=L >>16;

;Function : genCode32, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var unsg dwrd    32 NULL bp+4    L;
 ENTER  0,0
 push dword [bp+4]
 call genCode16
 add  sp, 4
 mov eax, [bp+4]
 shr eax, 16
 mov dword [bp+4], eax

;-34     genCode16(L);

 push dword [bp+4]
 call genCode16
 add  sp, 4

;-35 }


;-36 int writeEA(char xxx) {//value for reg/operand
 LEAVE
 ret
; ENDP

writeEA:  ; *** PROC ***

;-37 //need: Op, Op2, disp, R1No, R2No, rm, isDirect


;-38 //mod-bits: mode76, reg/opcode543, r/m210   


;-39 //Op: 0, IMM, REG, ADR, MEM   


;-40     char len;


;-41     len=0;   

;Function : writeEA, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 var sign byte    36 NULL bp+4    xxx
;  251 var sign byte    40 NULL bp-2    len;
 ENTER  2,0
 mov eax, 0
 mov byte [bp-2], al

;-42     xxx = xxx << 3;//in reg/opcode field      

 mov al, [bp+4]
 shl al, 3
 mov byte [bp+4], al

;-43     if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@writeEA218

;-44         xxx |= 0xC0;     

 or  byte [bp+4], 192

;-45         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 

 mov al, [Op2]
 cmp al, 1
 jg  @@writeEA219
 mov al, [bp+4]
 add al, [R1No]
 mov byte [bp+4], al

;-46             else {

 jmp @@writeEA220
@@writeEA219:

;-47                 if (Op2 == REG) xxx = xxx + R1No;

 mov al, [Op2]
 cmp al, 2
 jne @@writeEA221
 mov al, [bp+4]
 add al, [R1No]
 mov byte [bp+4], al

;-48                 else            xxx = xxx + R2No;  

 jmp @@writeEA222
@@writeEA221:
 mov al, [bp+4]
 add al, [R2No]
 mov byte [bp+4], al

;-49             }

@@writeEA222:

;-50         } 

@@writeEA220:

;-51     if (Op == MEM) {

@@writeEA218:
 mov al, [Op]
 cmp al, 4
 jne @@writeEA223

;-52         if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@writeEA224

;-53             xxx |= 6;

 or  byte [bp+4], 6

;-54             len = 2;

 mov eax, 2
 mov byte [bp-2], al

;-55         }


;-56         else { 

 jmp @@writeEA225
@@writeEA224:

;-57             xxx = xxx + rm;   

 mov al, [bp+4]
 add al, [rm]
 mov byte [bp+4], al

;-58             if (rm == 6) {//make [BP+00]

 mov al, [rm]
 cmp al, 6
 jne @@writeEA226

;-59                 len=1;

 mov eax, 1
 mov byte [bp-2], al

;-60                 if (disp == 0) xxx |= 0x40;

 mov ax, [disp]
 cmp ax, 0
 jne @@writeEA227
 or  byte [bp+4], 64

;-61             }

@@writeEA227:

;-62 


;-63             if (disp) {

@@writeEA226:
 mov ax, [disp]
 or  al, al
 je @@writeEA228

;-64                 ax = disp;

 mov  ax, [disp]

;-65                 if(ax > 127) len=2;

 cmp  ax, 127
 jle @@writeEA229
 mov eax, 2
 mov byte [bp-2], al

;-66                 else len=1;

 jmp @@writeEA230
@@writeEA229:
 mov eax, 1
 mov byte [bp-2], al

;-67                 if (len == 1) xxx |= 0x40;

@@writeEA230:
 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA231
 or  byte [bp+4], 64

;-68                 else xxx |= 0x80;

 jmp @@writeEA232
@@writeEA231:
 or  byte [bp+4], 128

;-69             }

@@writeEA232:

;-70         }

@@writeEA228:

;-71     }  

@@writeEA225:

;-72     


;-73     genCode8(xxx);// gen second byte

@@writeEA223:
 mov al, byte [bp+4]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-74     if (len == 1) genCode8 (disp);

 mov al, [bp-2]
 cmp al, 1
 jne @@writeEA233
 push word [disp]
 call genCode8
 add  sp, 2

;-75     if (len == 2) genCode16(disp);

@@writeEA233:
 mov al, [bp-2]
 cmp al, 2
 jne @@writeEA234
 push word [disp]
 call genCode16
 add  sp, 2

;-76 }

@@writeEA234:

;-77 


;-78 int genImmediate() { 
 LEAVE
 ret
; ENDP

genImmediate:  ; *** PROC ***

;-79     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long

 mov al, [wflag]
 or  al, al
 je @@genImmediate235
 mov al, [OpSize]
 cmp al, 3
 jne @@genImmediate236
 push word [imme]
 call genCode32
 add  sp, 2

;-80         else genCode16(imme);

 jmp @@genImmediate237
@@genImmediate236:
 push word [imme]
 call genCode16
 add  sp, 2

;-81     else       genCode8 (imme);  

@@genImmediate237:
 jmp @@genImmediate238
@@genImmediate235:
 push word [imme]
 call genCode8
 add  sp, 2

;-82 }    

@@genImmediate238:
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
;  250 var sign byte    12 NULL bp-2    c;
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
 jne @@process239

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

@@process239:
 mov al, [CodeType]
 cmp al, 2
 jne @@process240

;-26         getOpL();    

 call getOpL

;-27         checkOpL();        

 call checkOpL

;-28         if (Code2 <= 1) {//inc,dec

 mov al, [Code2]
 cmp al, 1
 jg  @@process241

;-29   	        if (Op == REG) {//short

 mov al, [Op]
 cmp al, 2
 jne @@process242

;-30                 if (wflag) {genCode2(Code3, R1No); return; }

 mov al, [wflag]
 or  al, al
 je @@process243
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

@@process243:

;-32         }

@@process242:

;-33         if (Code2 == 5) {//imul extension?

@@process241:
 mov al, [Code2]
 cmp al, 5
 jne @@process244

;-34             getTokeType();

 call getTokeType

;-35             if (TokeType) implerror();

 mov al, [TokeType]
 or  al, al
 je @@process245
 call implerror

;-36         }

@@process245:

;-37         genCodeW(Code1);           

@@process244:
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

@@process240:
 mov al, [CodeType]
 cmp al, 3
 jne @@process246

;-43         check2Ops();    //setwflag not applicable

 call check2Ops

;-44         if (R1Type != WORD) reg16error();//only r16

 mov al, [R1Type]
 cmp al, 2
 je  @@process247
 call reg16error

;-45         if (Op2 != MEM) addrerror();//only m16 

@@process247:
 mov al, [Op2]
 cmp al, 4
 je  @@process248
 call addrerror

;-46         


;-47         genCode8(Code1);//les,lds,lea

@@process248:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   

 mov al, [Code1]
 cmp al, 15
 jne @@process249
 mov al, byte [Code2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-49         Op=Op2;//set MEM for writeEA

@@process249:
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

@@process246:
 mov al, [CodeType]
 cmp al, 4
 jne @@process250

;-55         check2Ops();    

 call check2Ops

;-56         if (Op2 == IMM) {//second operand is imm     

 mov al, [Op2]
 cmp al, 1
 jne @@process251

;-57             setsflag();   

 call setsflag

;-58             if (Op == REG) {                

 mov al, [Op]
 cmp al, 2
 jne @@process252

;-59                 if (R1No == 0) {// acc,imm   

 mov al, [R1No]
 cmp al, 0
 jne @@process253

;-60                     if (sflag == 0) {                        

 mov al, [sflag]
 cmp al, 0
 jne @@process254

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

@@process254:

;-68             }

@@process253:

;-69             //r/m, imm: 80 sign-extended,TTT,imm


;-70             c = sflag + 0x80;   

@@process252:
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
 je @@process255
 push word [imme]
 call genCode8
 add  sp, 2

;-74             else genImmediate();    

 jmp @@process256
@@process255:
 call genImmediate

;-75             return;     

@@process256:
 jmp @@retn

;-76         }  


;-77         c = Code1 << 3;//r/m, r/r  

@@process251:
 mov al, [Code1]
 shl al, 3
 mov byte [bp-2], al

;-78         if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process257

;-79             if (Op2 == MEM) {//reg, mem      

 mov al, [Op2]
 cmp al, 4
 jne @@process258

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

@@process258:

;-87         if (Op2 == REG) {//mem,reg    reg,reg

@@process257:
 mov al, [Op2]
 cmp al, 2
 jne @@process259

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

@@process259:
 call syntaxerror

;-93         return;

 jmp @@retn

;-94     }


;-95  


;-96     if (CodeType == 5) {//mov (movsx, movzx=51)

@@process250:
 mov al, [CodeType]
 cmp al, 5
 jne @@process260

;-97         check2Ops();    

 call check2Ops

;-98 /*    prs("\n Op:"); printhex8a(Op);


;-99     prs(", Op2:"); printhex8a(Op2);


;-100     prs(", R1No:"); printhex8a(R1No);


;-101     prs(", R2No:"); printhex8a(R2No);   */  


;-102         if (Op2 == ADR) {

 mov al, [Op2]
 cmp al, 3
 jne @@process261

;-103             imme=disp;

 mov ax, [disp]
 mov word [imme], ax

;-104             Op2=IMM;//continue with IMM    

 mov eax, 1
 mov byte [Op2], al

;-105         }  


;-106         if (Op2 == IMM) {// r,i     

@@process261:
 mov al, [Op2]
 cmp al, 1
 jne @@process262

;-107             if (Op == REG) {               

 mov al, [Op]
 cmp al, 2
 jne @@process263

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

@@process263:
 mov al, [Op]
 cmp al, 4
 jne @@process264

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

@@process264:
 call regmemerror

;-121             return;

 jmp @@retn

;-122         }      


;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm

@@process262:
 mov al, [R1Type]
 cmp al, 4
 jne @@process265
 call ChangeDirection

;-124         if (R2Type == SEGREG) {//rm,sreg

@@process265:
 mov al, [R2Type]
 cmp al, 4
 jne @@process266

;-125             if (OpSize != WORD) reg16error();

 mov al, [OpSize]
 cmp al, 2
 je  @@process267
 call reg16error

;-126                 genCode2(0x8C, dflag);

@@process267:
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

@@process266:
 mov al, [Op2]
 cmp al, 4
 jne @@process268

;-131             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process269

;-132                 if (R1No == 0) {

 mov al, [R1No]
 cmp al, 0
 jne @@process270

;-133                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@process271

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

@@process271:

;-139             }   

@@process270:

;-140         } 

@@process269:

;-141         if (Op == MEM) {//moffs16, acc

@@process268:
 mov al, [Op]
 cmp al, 4
 jne @@process272

;-142             if (Op2 == REG) {

 mov al, [Op2]
 cmp al, 2
 jne @@process273

;-143                 if (R2No == 0) {

 mov al, [R2No]
 cmp al, 0
 jne @@process274

;-144                     if (isDirect) {

 mov al, [isDirect]
 or  al, al
 je @@process275

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

@@process275:

;-150             }

@@process274:

;-151         


;-152         }

@@process273:

;-153         if (Op2 == REG) {//rm, r

@@process272:
 mov al, [Op2]
 cmp al, 2
 jne @@process276

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

@@process276:
 mov al, [Op2]
 cmp al, 4
 jne @@process277

;-159             if (Op == REG) {

 mov al, [Op]
 cmp al, 2
 jne @@process278

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

@@process278:

;-166         syntaxerror();

@@process277:
 call syntaxerror

;-167         return;

 jmp @@retn

;-168     }    


;-169     


;-170     if (CodeType == 6) {//Jcc       

@@process260:
 mov al, [CodeType]
 cmp al, 6
 jne @@process279

;-171         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@process280

;-172             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-173             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle @@process281

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
 je @@process282

;-178                     genCode2(Code1, 0x70);//short       

 push 112
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode2
 add  sp, 4

;-179                     disp -= 2; 

 sub  word [disp], 2

;-180                     genCode8(disp);   

 push word [disp]
 call genCode8
 add  sp, 2

;-181                 } else {     

 jmp @@process283
@@process282:

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

 sub  word [disp], 4

;-185                     genCode16(disp);                       

 push word [disp]
 call genCode16
 add  sp, 2

;-186                 }    


;-187             }

@@process283:

;-188             else {//jump forward, near only

 jmp @@process284
@@process281:

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

 mov eax, 42
 mov byte [PrintRA], al

;-193                 storeJmpCall();

 call storeJmpCall

;-194             }   


;-195         return; 

@@process284:
 jmp @@retn

;-196         }  


;-197     }

@@process280:

;-198 


;-199     if (CodeType == 7) {//jmp, call

@@process279:
 mov al, [CodeType]
 cmp al, 7
 jne @@process285

;-200         if (TokeType == ALNUME) {

 mov al, [TokeType]
 cmp al, 3
 jne @@process286

;-201             LabelIx=searchLabel();

 call searchLabel
 mov word [LabelIx], ax

;-202             if (LabelIx > 0) {

 mov ax, [LabelIx]
 cmp ax, 0
 jle @@process287

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
 je @@process288

;-207                     if (Code1 == 0xE9) {//jmp only

 mov al, [Code1]
 cmp al, 233
 jne @@process289

;-208                         genCode8(0xEB);//short       

 push 235
 call genCode8
 add  sp, 2

;-209                         disp -= 2; 

 sub  word [disp], 2

;-210                         genCode8(disp);

 push word [disp]
 call genCode8
 add  sp, 2

;-211                     } 


;-212                     else {     

 jmp @@process290
@@process289:

;-213                         genCode8(Code1);//near    

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-214                         disp -= 3; 

 sub  word [disp], 3

;-215                         genCode16(disp);                       

 push word [disp]
 call genCode16
 add  sp, 2

;-216                     }    


;-217                 } 

@@process290:

;-218                 else {     

 jmp @@process291
@@process288:

;-219                     genCode8(Code1);//near    

 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-220                     disp -= 3; 

 sub  word [disp], 3

;-221                     genCode16(disp);                       

 push word [disp]
 call genCode16
 add  sp, 2

;-222                 }    


;-223             }

@@process291:

;-224             else {//jump forward, near only

 jmp @@process292
@@process287:

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

 mov eax, 42
 mov byte [PrintRA], al

;-228                 storeJmpCall();

 call storeJmpCall

;-229             }   


;-230         return; 

@@process292:
 jmp @@retn

;-231         }


;-232     }

@@process286:

;-233     


;-234     if (CodeType ==  8) {//ret,retf

@@process285:
 mov al, [CodeType]
 cmp al, 8
 jne @@process293

;-235         if (TokeType == DIGIT) {

 mov al, [TokeType]
 cmp al, 1
 jne @@process294

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

 jmp @@retn

;-239         }


;-240         genCode8(Code1); 

@@process294:
 mov al, byte [Code1]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-241         return;

 jmp @@retn

;-242     }


;-243        


;-244     if (CodeType == 9) {//push, pop  

@@process293:
 mov al, [CodeType]
 cmp al, 9
 jne @@process295

;-245         getOpL();

 call getOpL

;-246         if (Code1 == 0x50) {//push only

 mov al, [Code1]
 cmp al, 80
 jne @@process296

;-247             if (Op == IMM) {//push imm8,16

 mov al, [Op]
 cmp al, 1
 jne @@process297

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
 je @@process298
 push word [imme]
 call genCode8
 add  sp, 2

;-251                 else       genCode16(imme);    

 jmp @@process299
@@process298:
 push word [imme]
 call genCode16
 add  sp, 2

;-252                 return;   

@@process299:
 jmp @@retn

;-253             }   


;-254         }

@@process297:

;-255         if (R1Type == SEGREG) {

@@process296:
 mov al, [R1Type]
 cmp al, 4
 jne @@process300

;-256             if (Code1 == 0x58) {

 mov al, [Code1]
 cmp al, 88
 jne @@process301

;-257                 if (R1No == 1) error1("pop cs not allowed");   

 mov al, [R1No]
 cmp al, 1
 jne @@process302
 push process_0
 call error1
 add  sp, 2

;-258             }

@@process302:

;-259             c = R1No <<3;

@@process301:
 mov al, [R1No]
 shl al, 3
 mov byte [bp-2], al

;-260             if (R1No > 3) {//FS, GS

 mov al, [R1No]
 cmp al, 3
 jle @@process303

;-261                 c += 122;

 add  byte [bp-2], 122

;-262                 genCode8(0x0F);

 push 15
 call genCode8
 add  sp, 2

;-263             }


;-264             OpCodePtr++;

@@process303:
 inc  word [OpCodePtr]

;-265             c = c + *OpCodePtr;//is Code4   

 mov al, [bp-2]
 mov bx, [OpCodePtr]
 add al, [bx]
 mov ah, 0
 mov byte [bp-2], al

;-266             genCode8(c);  

 mov al, byte [bp-2]
 mov ah, 0
 push ax
 call genCode8
 add  sp, 2

;-267             return; 

 jmp @@retn

;-268         }  


;-269         checkOpL();    

@@process300:
 call checkOpL

;-270         if (R1Type == BYTE) reg16error();

 mov al, [R1Type]
 cmp al, 1
 jne @@process304
 call reg16error

;-271         if (R1Type == WORD) {

@@process304:
 mov al, [R1Type]
 cmp al, 2
 jne @@process305

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

 jmp @@retn

;-274         }                


;-275         if (Op == MEM) {

@@process305:
 mov al, [Op]
 cmp al, 4
 jne @@process306

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

 jmp @@retn

;-279         }


;-280         syntaxerror();

@@process306:
 call syntaxerror

;-281         return;        

 jmp @@retn

;-282     }


;-283     


;-284     if (CodeType == 11) {//shift, rotate

@@process295:
 mov al, [CodeType]
 cmp al, 11
 jne @@process307

;-285         check2Ops();

 call check2Ops

;-286         if (Op2 == IMM) {

 mov al, [Op2]
 cmp al, 1
 jne @@process308

;-287             if (imme == 1) {

 mov ax, [imme]
 cmp ax, 1
 jne @@process309

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

 jmp @@retn

;-291             }


;-292             genCodeW(0xC0);//80186

@@process309:
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

 jmp @@retn

;-296         }


;-297         if (Op2 == REG) {

@@process308:
 mov al, [Op2]
 cmp al, 2
 jne @@process310

;-298             if (R2Type == BYTE) {

 mov al, [R2Type]
 cmp al, 1
 jne @@process311

;-299                 if (R2No == 1) {//CL-REG 

 mov al, [R2No]
 cmp al, 1
 jne @@process312

;-300                     if (R1Type == WORD) wflag=1;//hack

 mov al, [R1Type]
 cmp al, 2
 jne @@process313
 mov eax, 1
 mov byte [wflag], al

;-301                     genCodeW(0xD2);

@@process313:
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

 jmp @@retn

;-304                 }   


;-305             }

@@process312:

;-306         }    

@@process311:

;-307     }     

@@process310:

;-308     


;-309     if (CodeType == 12) {//int

@@process307:
 mov al, [CodeType]
 cmp al, 12
 jne @@process314

;-310         if (TokeType == DIGIT) {            

 mov al, [TokeType]
 cmp al, 1
 jne @@process315

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

 jmp @@retn

;-314         }


;-315     }

@@process315:

;-316     


;-317     if (CodeType == 30) {//enter i18,i8

@@process314:
 mov al, [CodeType]
 cmp al, 30
 jne @@process316

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
 jne @@process317
 push word [SymbolInt]
 call genCode16
 add  sp, 2

;-321         else numbererror();

 jmp @@process318
@@process317:
 call numbererror

;-322         need(',');

@@process318:
 push 44
 call need
 add  sp, 2

;-323         Op=getOp1();

 call getOp1
 mov byte [Op], al

;-324         if (Op == IMM) genCode8 (SymbolInt);

 mov al, [Op]
 cmp al, 1
 jne @@process319
 push word [SymbolInt]
 call genCode8
 add  sp, 2

;-325         else numbererror();           

 jmp @@process320
@@process319:
 call numbererror

;-326         return;

@@process320:
 jmp @@retn

;-327     }


;-328        


;-329     if (CodeType==101) {//ORG nn

@@process316:
 mov al, [CodeType]
 cmp al, 101
 jne @@process321

;-330         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  @@process322
 call numbererror

;-331         Origin=SymbolInt;

@@process322:
 mov ax, [SymbolInt]
 mov word [Origin], ax

;-332         return;

 jmp @@retn

;-333     }


;-334     


;-335     if (CodeType == 102) {//section, segment  

@@process321:
 mov al, [CodeType]
 cmp al, 102
 jne @@process323

;-336         //getTokeType();//ignore .bss .text .data 


;-337         AbsoluteLab=0;//nasm resets erevy time

 mov eax, 0
 mov word [AbsoluteLab], ax

;-338         return;  

 jmp @@retn

;-339     }


;-340                


;-341     if (CodeType == 110) {//absolute

@@process323:
 mov al, [CodeType]
 cmp al, 110
 jne @@process324

;-342         if (TokeType != DIGIT) numbererror();

 mov al, [TokeType]
 cmp al, 1
 je  @@process325
 call numbererror

;-343         AbsoluteLab=SymbolInt;

@@process325:
 mov ax, [SymbolInt]
 mov word [AbsoluteLab], ax

;-344         return;           

 jmp @@retn

;-345     }


;-346                


;-347     error1("Command not implemented or syntax error");

@@process324:
 push process_1
 call error1
 add  sp, 2

;-348 }    

@@retn: LEAVE
 ret
; ENDP
process_0 db "pop cs not allowed",0
process_1 db "Command not implemented or syntax error",0
 
; missing functions: 
; digit
; strcpy
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
; strcpy
; strlen
; fputcR
; fcloseR
; fcloseR
; fcloseR
; exitR
; Number of unresolved CALLs :   79
;use archive file: AR.C

;-349 // AR.C Archive

;Number of CALLs:    2 : writetty

writetty:  ; *** PROC ***
 mov  ah, 14
 mov  bx, 0
 int  16

;-350 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }

 ret
; ENDP
;Number of CALLs:    8 : cputs

cputs:  ; *** PROC ***
;Function : cputs, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   350 NULL bp+4    s
;  251 var sign byte   350 NULL bp-2    c;
 ENTER  2,0
@@cputs326:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@cputs327
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
 jmp @@cputs326
@@cputs327:

;-351 int mkneg(int n) { n; __asm {neg ax} }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : toupper

toupper:  ; *** PROC ***
;Function : toupper, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   351 NULL bp+4    s;
 ENTER  0,0
@@toupper328:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@toupper329
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 97 ;unsigned : 1
 jl  @@toupper330
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 122
 jg  @@toupper331
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 sub ax, 32
 mov  bx, [bp+4]
 mov  [bx], al
@@toupper331:
@@toupper330:
 inc  word [bp+4]
 jmp @@toupper328
@@toupper329:

;-352 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }


;-353 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : strlen

strlen:  ; *** PROC ***
;Function : strlen, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   353 NULL bp+4    s
;  251 var sign word   353 NULL bp-2    c;
 ENTER  2,0
 mov eax, 0
 mov word [bp-2], ax
@@strlen332:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strlen333
 inc  word [bp+4]
 inc  word [bp-2]
 jmp @@strlen332
@@strlen333:
 mov ax, [bp-2]
 jmp @@retn

;-354 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    7 : strcpy

strcpy:  ; *** PROC ***
;Function : strcpy, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   354 NULL bp+4    s
;  251 ptr sign byte   354 NULL bp+6    t;
 ENTER  0,0
@@strcpy334:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 mov  bx, [bp+4]
 mov  [bx], al
 inc  word [bp+4]
 inc  word [bp+6]

;-355   while (*t!=0); *s=0; return s; }

 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcpy335
 jmp @@strcpy334
@@strcpy335:
 mov eax, 0
 mov  bx, [bp+4]
 mov  [bx], al
 mov ax, [bp+4]
 jmp @@retn

;-356 int strncpy(char *s, char *t, int n) { if (_ n==0) return;

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : digit

digit:  ; *** PROC ***
;Function : digit, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte   356 NULL bp+4    c;
 ENTER  0,0
 mov al, [bp+4]
 cmp al, 48
 jge @@digit336
 mov eax, 0
 jmp @@retn
@@digit336:
 mov al, [bp+4]
 cmp al, 57
 jle @@digit337
 mov eax, 0
 jmp @@retn
@@digit337:
 mov eax, 1
 jmp @@retn

;-357 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:   35 : eqstr

eqstr:  ; *** PROC ***
;Function : eqstr, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   357 NULL bp+4    p
;  251 ptr sign byte   357 NULL bp+6    q;
 ENTER  0,0
@@eqstr338:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr339

;-358     if (*p != *q) return 0; p++; q++; }

 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 mov bx, [bp+6]
 cmp al, [bx]
 mov ah, 0
 je  @@eqstr340
 mov eax, 0
 jmp @@retn
@@eqstr340:
 inc  word [bp+4]
 inc  word [bp+6]

;-359     if(*q) return 0; return 1; }

 jmp @@eqstr338
@@eqstr339:
 mov bx, [bp+6]
 mov al, [bx]
 mov ah, 0
 or  al, al
 je @@eqstr341
 mov eax, 0
 jmp @@retn
@@eqstr341:
 mov eax, 1
 jmp @@retn

;-360 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }

@@retn: LEAVE
 ret
; ENDP
;Number of CALLs:    3 : strcat1

strcat1:  ; *** PROC ***
;Function : strcat1, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   360 NULL bp+4    s
;  251 ptr sign byte   360 NULL bp+6    t;
 ENTER  0,0
@@strcat1342:
 mov bx, [bp+4]
 mov al, [bx]
 mov ah, 0
 cmp ax, 0
 je  @@strcat1343
 inc  word [bp+4]
 jmp @@strcat1342
@@strcat1343:
 push word [bp+6]
 push word [bp+4]
 call strcpy
 add  sp, 4

;-361 int basename(char *s) { char *p; p=0;
 LEAVE
 ret
; ENDP
;Number of CALLs:    1 : openR

openR:  ; *** PROC ***
;Function : openR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   361 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  ax, 15618
 call DosInt

;-362 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : creatR

creatR:  ; *** PROC ***
;Function : creatR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   362 NULL bp+4    s;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, 0
 mov  ax, 15360
 call DosInt

;-363 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : readRL

readRL:  ; *** PROC ***
;Function : readRL, Number of local variables: 3
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   363 NULL bp+4    s
;  251 var sign word   363 NULL bp+6    fd
;  252 var sign word   363 NULL bp+8    len;
 ENTER  0,0
 mov  dx, [bp+4]
 mov  cx, [bp+8]
 mov  bx, [bp+6]
 mov  ax, 16128
 call DosInt

;-364 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
 LEAVE
 ret
; ENDP
;Number of CALLs:    2 : fputcR

fputcR:  ; *** PROC ***
;Function : fputcR, Number of local variables: 2
;   # type sign width line used address name   list of local variables
;  250 ptr sign byte   364 NULL bp+4    n
;  251 var sign word   364 NULL bp+6    fd;
 ENTER  0,0
lea dx, [bp+4]

;-365   cx=1; bx=fd; ax=0x4000; DosInt(); }

 mov  cx, 1
 mov  bx, [bp+6]
 mov  ax, 16384
 call DosInt

;-366 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
 LEAVE
 ret
; ENDP
;Number of CALLs:    3 : fcloseR

fcloseR:  ; *** PROC ***
;Function : fcloseR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign word   366 NULL bp+4    fd;
 ENTER  0,0
 mov  bx, [bp+4]
 mov  ax, 15872
 int  33

;-367 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
 LEAVE
 ret
; ENDP
;Number of CALLs:    5 : exitR

exitR:  ; *** PROC ***
;Function : exitR, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte   367 NULL bp+4    c;
 ENTER  0,0
 mov  ah, 76
 mov  al, [bp+4]
 int  33

;-368 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
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

;-369 // AR.C Archive

;Number of CALLs:    1 : putch

putch:  ; *** PROC ***
;Function : putch, Number of local variables: 1
;   # type sign width line used address name   list of local variables
;  250 var sign byte   369 NULL bp+4    c;
 ENTER  0,0
cmp byte [bp+4], 10
 jne @@putch344
 mov  al, 13
 call writetty
@@putch344:
 mov  al, [bp+4]
 call writetty

;-370 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
 LEAVE
 ret
; ENDP
;Number of CALLs:    4 : DosInt

DosInt:  ; *** PROC ***
 int  33
 jae short @@DosInt345
 inc  word [DOS_ERR]
@@DosInt345:

;-371 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }

 ret
; ENDP
;End of archive file. 
 
; missing functions:  All FUNCTIONs in place
LastFunctionByt:db 0E8h, 0, 0
pop ax
ret
 
;   # type sign width line used  address name   list of global variables

;    1 arr sign byte     1    2        0 Version1[9]
;    2 var sign byte     1    3        0 LIST
;    3 def unsg byte     2    -        0 SYMBOLMAX=31
;    4 arr sign byte     3   11    30000 Symbol[31]
;    5 arr sign byte     4   36    30031 SymbolUpper[31]
;    6 var unsg word     5   24        0 SymbolInt
;    7 var unsg dwrd     6 NULL        0 SymbolLong
;    8 def unsg byte     7    -        0 INPUTBUFMAX=255
;    9 arr sign byte     8    4    30062 InputBuf[255]
;   10 ptr unsg byte     9   24        0 InputPtr
;   11 arr sign byte    10    5    30317 namein[67]
;   12 arr sign byte    11    6    30384 namelst[67]
;   13 arr sign byte    12    6    30451 namebin[67]
;   14 var sign word    13    4        0 asm_fd
;   15 var sign word    14    3        0 lst_fd
;   16 var sign word    15    3        0 bin_fd
;   17 var sign word    16    6        0 DOS_ERR
;   18 var sign word    17    4        0 ErrorCount
;   19 var sign word    18    4        0 DOS_NoBytes
;   20 var sign byte    19    4        0 DOS_ByteRead
;   21 var unsg word    21    7        0 PC
;   22 var unsg word    22    5        0 Origin
;   23 var unsg word    23    6        0 AbsoluteLab
;   24 var unsg word    24    2        0 PCStart
;   25 var sign byte    25    3        0 isLabel
;   26 def unsg byte    26    -        0 DIGIT=1
;   27 def unsg byte    27    -        0 LETTERE=2
;   28 def unsg byte    28    -        0 ALNUME=3
;   29 def unsg byte    29    -        0 NOALNUME=4
;   30 var sign byte    30   27        0 TokeType
;   31 def unsg byte    31    -        0 BYTE=1
;   32 def unsg byte    32    -        0 WORD=2
;   33 def unsg byte    33    -        0 DWORD=3
;   34 def unsg byte    34    -        0 SEGREG=4
;   35 def unsg byte    35    -        0 IMM=1
;   36 def unsg byte    36    -        0 REG=2
;   37 def unsg byte    37    -        0 ADR=3
;   38 def unsg byte    38    -        0 MEM=4
;   39 var sign byte    39   28        0 Op
;   40 var sign byte    40   31        0 Op2
;   41 var sign byte    41   27        0 CodeType
;   42 var sign byte    42   23        0 Code1
;   43 var sign byte    43    7        0 Code2
;   44 var sign byte    44    3        0 Code3
;   45 var sign byte    45   19        0 R2No
;   46 var sign byte    46   16        0 R1No
;   47 var sign byte    47   18        0 R2Type
;   48 var sign byte    48   15        0 R1Type
;   49 var sign byte    49   14        0 OpSize
;   50 var sign byte    50    9        0 wflag
;   51 var sign byte    51    3        0 dflag
;   52 var sign byte    52    8        0 sflag
;   53 var sign byte    53   15        0 rm
;   54 var sign byte    54    5        0 isDirect
;   55 var sign word    55   48        0 disp
;   56 var unsg word    56   13        0 imme
;   57 def unsg byte    58    -        0 OPMAXLEN=5
;   58 arr sign byte    59    2    30518 OpPos[5]
;   59 var sign word    60    6        0 OpPrintIndex
;   60 ptr sign byte    61   19        0 OpCodePtr
;   61 var sign byte    62    4        0 PrintRA
;   62 def unsg byte    64    -        0 LABELNAMESMAX=3969
;   63 arr sign byte    65    3    30523 LabelNames[4000]
;   64 ptr sign byte    66    5        0 LabelNamePtr
;   65 def unsg byte    67    -        0 LABELADRMAX=600
;   66 arr unsg word    68    7    34523 LabelAddr[600]
;   67 var sign word    69    7        0 LabelMaxIx
;   68 var sign word    70   10        0 LabelIx
;   69 def unsg byte    72    -        0 JMPCALLNAMESMAX=1969
;   70 arr sign byte    73    3    35723 JmpCallNames[2000]
;   71 ptr sign byte    74    5        0 JmpCallNamePtr
;   72 def unsg byte    75    -        0 JMPCALLMAX=500
;   73 arr unsg word    76    2    37723 JmpCallAddr[500]
;   74 var sign word    77    6        0 JmpCallMaxIx
;   75 def unsg byte    79    -        0 FILEBINMAX=20000
;   76 arr sign byte    80    4    38723 FileBin[20000]
;   77 var unsg word    81    6        0 BinLen
;   78 ptr sign byte    83    1        0 arglen
;   79 ptr sign byte    84    4        0 argv
;   80 var sign byte     1    1        0 I_START
;   81 arr sign byte     4 NULL        0 I_PUSHA[9]
;   82 arr sign byte     5 NULL        0 I_POPA[8]
;   83 arr sign byte     6 NULL        0 I_NOP[7]
;   84 arr sign byte     7 NULL        0 I_CBW[7]
;   85 arr sign byte     8 NULL        0 I_CWDE[8]
;   86 arr sign byte     9 NULL        0 I_CWD[7]
;   87 arr sign byte    10 NULL        0 I_CDQ[7]
;   88 arr sign byte    11 NULL        0 I_WAIT[8]
;   89 arr sign byte    12 NULL        0 I_PUSHF[9]
;   90 arr sign byte    13 NULL        0 I_POPF[8]
;   91 arr sign byte    14 NULL        0 I_SAHF[8]
;   92 arr sign byte    15 NULL        0 I_LAHF[8]
;   93 arr sign byte    16 NULL        0 I_MOVSB[9]
;   94 arr sign byte    17 NULL        0 I_MOVSW[9]
;   95 arr sign byte    18 NULL        0 I_CMPSB[9]
;   96 arr sign byte    19 NULL        0 I_CMPSW[9]
;   97 arr sign byte    20 NULL        0 I_STOSB[9]
;   98 arr sign byte    21 NULL        0 I_STOSW[9]
;   99 arr sign byte    22 NULL        0 I_LODSB[9]
;  100 arr sign byte    23 NULL        0 I_LODSW[9]
;  101 arr sign byte    24 NULL        0 I_SCASB[9]
;  102 arr sign byte    25 NULL        0 I_SCASW[9]
;  103 arr sign byte    26 NULL        0 I_LEAVE[9]
;  104 arr sign byte    27 NULL        0 I_INT3[8]
;  105 arr sign byte    28 NULL        0 I_INTO[8]
;  106 arr sign byte    29 NULL        0 I_IRET[8]
;  107 arr sign byte    30 NULL        0 I_XLAT[8]
;  108 arr sign byte    31 NULL        0 I_LOCK[8]
;  109 arr sign byte    32 NULL        0 I_REPNE[9]
;  110 arr sign byte    33 NULL        0 I_REPNZ[9]
;  111 arr sign byte    34 NULL        0 I_REPE[8]
;  112 arr sign byte    35 NULL        0 I_REPZ[8]
;  113 arr sign byte    36 NULL        0 I_HLT[7]
;  114 arr sign byte    37 NULL        0 I_CLC[7]
;  115 arr sign byte    38 NULL        0 I_STC[7]
;  116 arr sign byte    39 NULL        0 I_CLI[7]
;  117 arr sign byte    40 NULL        0 I_STI[7]
;  118 arr sign byte    41 NULL        0 I_CLD[7]
;  119 arr sign byte    42 NULL        0 I_STD[7]
;  120 arr sign byte    44 NULL        0 I_INC[9]
;  121 arr sign byte    45 NULL        0 I_DEC[9]
;  122 arr sign byte    46 NULL        0 I_NOT[8]
;  123 arr sign byte    47 NULL        0 I_NEG[8]
;  124 arr sign byte    48 NULL        0 I_MUL[8]
;  125 arr sign byte    49 NULL        0 I_IMUL[9]
;  126 arr sign byte    50 NULL        0 I_DIV[8]
;  127 arr sign byte    51 NULL        0 I_IDIV[9]
;  128 arr sign byte    53 NULL        0 I_LES[7]
;  129 arr sign byte    54 NULL        0 I_LDS[7]
;  130 arr sign byte    55 NULL        0 I_LEA[7]
;  131 arr sign byte    56 NULL        0 I_LSS[8]
;  132 arr sign byte    57 NULL        0 I_LFS[8]
;  133 arr sign byte    58 NULL        0 I_LGS[8]
;  134 arr sign byte    60 NULL        0 I_ADD[7]
;  135 arr sign byte    61 NULL        0 I_OR[6]
;  136 arr sign byte    62 NULL        0 I_ADC[7]
;  137 arr sign byte    63 NULL        0 I_SBB[7]
;  138 arr sign byte    64 NULL        0 I_AND[7]
;  139 arr sign byte    65 NULL        0 I_SUB[7]
;  140 arr sign byte    66 NULL        0 I_XOR[7]
;  141 arr sign byte    67 NULL        0 I_CMP[7]
;  142 arr sign byte    68 NULL        0 I_TEST[11]
;  143 arr sign byte    70 NULL        0 I_MOV[6]
;  144 arr sign byte    71 NULL        0 I_MOVSX[9]
;  145 arr sign byte    72 NULL        0 I_MOVZX[9]
;  146 arr sign byte    74 NULL        0 I_JO[6]
;  147 arr sign byte    75 NULL        0 I_JNO[7]
;  148 arr sign byte    76 NULL        0 I_JB[6]
;  149 arr sign byte    77 NULL        0 I_JC[6]
;  150 arr sign byte    78 NULL        0 I_JNB[7]
;  151 arr sign byte    79 NULL        0 I_JAE[7]
;  152 arr sign byte    80 NULL        0 I_JNC[7]
;  153 arr sign byte    81 NULL        0 I_JE[6]
;  154 arr sign byte    82 NULL        0 I_JZ[6]
;  155 arr sign byte    83 NULL        0 I_JNE[7]
;  156 arr sign byte    84 NULL        0 I_JNZ[7]
;  157 arr sign byte    85 NULL        0 I_JBE[7]
;  158 arr sign byte    86 NULL        0 I_JNA[7]
;  159 arr sign byte    87 NULL        0 I_JA[6]
;  160 arr sign byte    88 NULL        0 I_JS[6]
;  161 arr sign byte    89 NULL        0 I_JNS[7]
;  162 arr sign byte    90 NULL        0 I_JP[6]
;  163 arr sign byte    91 NULL        0 I_JPE[7]
;  164 arr sign byte    92 NULL        0 I_JNP[7]
;  165 arr sign byte    93 NULL        0 I_JPO[7]
;  166 arr sign byte    94 NULL        0 I_JL[6]
;  167 arr sign byte    95 NULL        0 I_JNL[7]
;  168 arr sign byte    96 NULL        0 I_JGE[7]
;  169 arr sign byte    97 NULL        0 I_JLE[7]
;  170 arr sign byte    98 NULL        0 I_JNG[7]
;  171 arr sign byte    99 NULL        0 I_JG[6]
;  172 arr sign byte   101 NULL        0 I_JMP[8]
;  173 arr sign byte   102 NULL        0 I_CALL[9]
;  174 arr sign byte   104 NULL        0 I_RET[8]
;  175 arr sign byte   105 NULL        0 I_RETF[9]
;  176 arr sign byte   107 NULL        0 I_PUSH[11]
;  177 arr sign byte   108 NULL        0 I_POP[10]
;  178 arr sign byte   110 NULL        0 I_ROL[7]
;  179 arr sign byte   111 NULL        0 I_ROR[7]
;  180 arr sign byte   112 NULL        0 I_RCL[7]
;  181 arr sign byte   113 NULL        0 I_RCR[7]
;  182 arr sign byte   114 NULL        0 I_SHL[7]
;  183 arr sign byte   115 NULL        0 I_SAL[7]
;  184 arr sign byte   116 NULL        0 I_SHR[7]
;  185 arr sign byte   117 NULL        0 I_SAR[7]
;  186 arr sign byte   119 NULL        0 I_INT[8]
;  187 arr sign byte   121 NULL        0 I_IN[7]
;  188 arr sign byte   122 NULL        0 I_INSB[8]
;  189 arr sign byte   123 NULL        0 I_INSW[8]
;  190 arr sign byte   124 NULL        0 I_INSD[8]
;  191 arr sign byte   125 NULL        0 I_OUT[8]
;  192 arr sign byte   126 NULL        0 I_OUTSB[8]
;  193 arr sign byte   127 NULL        0 I_OUTSW[8]
;  194 arr sign byte   128 NULL        0 I_OUTSD[8]
;  195 arr sign byte   130 NULL        0 I_XCHG[9]
;  196 arr sign byte   132 NULL        0 I_LOOPNZ[10]
;  197 arr sign byte   133 NULL        0 I_LOOPNE[10]
;  198 arr sign byte   134 NULL        0 I_LOOPZ[9]
;  199 arr sign byte   135 NULL        0 I_LOOPE[9]
;  200 arr sign byte   136 NULL        0 I_LOOP[8]
;  201 arr sign byte   137 NULL        0 I_JCXZ[8]
;  202 arr sign byte   138 NULL        0 I_JECXZ[9]
;  203 arr sign byte   140 NULL        0 I_ENTER[8]
;  204 arr sign byte   142 NULL        0 I_ORG[6]
;  205 arr sign byte   144 NULL        0 I_SECTION[10]
;  206 arr sign byte   145 NULL        0 I_SEGMENT[10]
;  207 arr sign byte   146 NULL        0 I_ABSOLUTE[11]
;  208 arr sign byte   147 NULL        0 I_DB[5]
;  209 arr sign byte   148 NULL        0 I_DW[5]
;  210 arr sign byte   149 NULL        0 I_DD[5]
;  211 arr sign byte   150 NULL        0 I_RESB[7]
;  212 arr sign byte   151 NULL        0 I_RESW[7]
;  213 arr sign byte   152 NULL        0 I_RESD[7]
;  214 var sign byte   153 NULL        0 I_END


;   # Calls Line Width  Name   list of functions

;    0    2    1 word   ChangeDirection
;    1    2    9 word   checkOpL
;    2    4   18 word   check2Ops
;    3    1   27 word   get2Ops
;    4    3   33 word   getOpL
;    5    2   41 word   getOpR
;    6    4   51 word   getOp1
;    7    1   67 word   getMEM
;    8    1   90 word   getIndReg1
;    9    1   98 word   getIndReg2
;   10    2  108 word   setwflag
;   11    2  119 word   setsflag
;   12    2  129 word   checkConstSize
;   13    1    1 word   parse
;   14   16   35 word   getTokeType
;   15    2   46 word   storeJmpCall
;   16    2   57 word   storeLabel
;   17    5   69 word   searchLabel
;   18    1   82 word   getVariable
;   19    2  135 word   lookCode
;   20    1  151 word   getCodeSize
;   21    9  159 word   isToken
;   22    2  167 word   need
;   23    1  176 word   skipRest
;   24    1    1 word   getLine
;   25    1   17 word   ifEOL
;   26    3   24 word   skipBlank
;   27    2   29 word   letterE
;   28    1   39 word   alnumE
;   29    1   44 word   getDigit
;   30    1   56 word   getName
;   31    1   75 word   testReg
;   32    1    1 word   printLine
;   33    7   23 word   prc
;   34    1   35 word   prscomment
;   35   28   43 word   prs
;   36    3   65 word   printhex8a
;   37    2   70 word   printhex4
;   38    1   75 word   printhex16
;   39    5   80 word   printIntU
;   40   26   91 word   error1
;   41   12   99 word   errorexit
;   42 NULL  103 word   allowederror
;   43    3  104 word   addrerror
;   44    1  105 word   immeerror
;   45    2  106 word   implerror
;   46    4  107 word   indexerror
;   47    3  108 word   invaloperror
;   48    6  109 word   numbererror
;   49    1  110 word   regmemerror
;   50    3  111 word   reg16error
;   51    1  112 word   segregerror
;   52    5  113 word   syntaxerror
;   53 NULL  115 word   addrexit
;   54    3  116 word   dataexit
;   55 NULL  117 word   internexit
;   56 NULL    1 word   main
;   57    1    9 word   getarg
;   58    1   43 word   fixJmpCall
;   59    1   74 word   epilog
;   60    2  117 word   end1
;   61    1    2 word   getCodes
;   62    1    7 word   gen66h
;   63    8    9 word   genCode2
;   64   13   13 word   genCodeW
;   65   33   17 word   genCode8
;   66   17   28 word   genCode16
;   67    1   32 word   genCode32
;   68   13   36 word   writeEA
;   69    4   78 word   genImmediate
;   70    1   11 word   process
;   71    4  349 word   writetty
;   72    8  350 word   cputs
;   73    2  351 word   toupper
;   74    4  353 word   strlen
;   75    8  354 word   strcpy
;   76    3  356 word   digit
;   77   35  357 word   eqstr
;   78    3  360 word   strcat1
;   79    1  361 word   openR
;   80    2  362 word   creatR
;   81    2  363 word   readRL
;   82    2  364 word   fputcR
;   83    3  366 word   fcloseR
;   84    5  367 word   exitR
;   85    1  369 word   putch
;   86    4  370 word   DosInt
;   87 NULL  371 word   LastFunctionByt

;    #  addr name   list of CALLs

;    0  1565 implerror
;    1  1575 segregerror
;    2  1587 setwflag
;    3  1596 error1
;    4  1603 error1
;    5  1620 get2Ops
;    6  1628 addrerror
;    7  1638 invaloperror
;    8  1651 immeerror
;    9  1661 addrerror
;   10  1671 invaloperror
;   11  1684 setwflag
;   12  1701 getOpL
;   13  1708 need
;   14  1713 getOpR
;   15  1727 getOpR
;   16  1741 getOp1
;   17  1748 isToken
;   18  1756 getMEM
;   19  1763 invaloperror
;   20  1776 error1
;   21  1790 testReg
;   22  1798 searchLabel
;   23  1810 error1
;   24  1826 getTokeType
;   25  1838 getOp1
;   26  1845 syntaxerror
;   27  1857 getIndReg2
;   28  1868 getIndReg1
;   29  1879 isToken
;   30  1887 getTokeType
;   31  1899 numbererror
;   32  1911 isToken
;   33  1919 isToken
;   34  1927 errorexit
;   35  1948 indexerror
;   36  1959 indexerror
;   37  1983 indexerror
;   38  1994 indexerror
;   39  2014 gen66h
;   40  2033 error1
;   41  2064 getLine
;   42  2072 getTokeType
;   43  2084 storeLabel
;   44  2095 getTokeType
;   45  2107 lookCode
;   46  2116 process
;   47  2124 getVariable
;   48  2136 skipRest
;   49  2145 error1
;   50  2152 error1
;   51  2159 printLine
;   52  2183 skipBlank
;   53  2193 digit
;   54  2199 getDigit
;   55  2208 letterE
;   56  2216 getName
;   57  2239 errorexit
;   58  2249 strcpy
;   59  2256 errorexit
;   60  2279 errorexit
;   61  2289 searchLabel
;   62  2301 error1
;   63  2308 strcpy
;   64  2315 errorexit
;   65  2343 eqstr
;   66  2349 strlen
;   67  2370 storeLabel
;   68  2381 getTokeType
;   69  2393 lookCode
;   70  2402 dataexit
;   71  2411 dataexit
;   72  2420 getTokeType
;   73  2432 genCode8
;   74  2441 skipBlank
;   75  2451 isToken
;   76  2459 genCode8
;   77  2468 isToken
;   78  2476 getTokeType
;   79  2488 genCode16
;   80  2498 isToken
;   81  2506 getTokeType
;   82  2518 genCode16
;   83  2528 genCode16
;   84  2538 isToken
;   85  2546 getTokeType
;   86  2558 syntaxerror
;   87  2570 error1
;   88  2577 numbererror
;   89  2589 dataexit
;   90  2607 eqstr
;   91  2625 eqstr
;   92  2631 getTokeType
;   93  2643 eqstr
;   94  2649 getTokeType
;   95  2661 eqstr
;   96  2667 getTokeType
;   97  2689 skipBlank
;   98  2706 isToken
;   99  2714 getTokeType
;  100  2726 error1
;  101  2733 prs
;  102  2737 prc
;  103  2750 getTokeType
;  104  2762 error1
;  105  2779 readRL
;  106  2786 errorexit
;  107  2796 errorexit
;  108  2806 ifEOL
;  109  2820 readRL
;  110  2856 digit
;  111  2862 letterE
;  112  2889 digit
;  113  2909 alnumE
;  114  2916 errorexit
;  115  2926 strcpy
;  116  2933 toupper
;  117  2949 strlen
;  118  2956 strlen
;  119  2963 eqstr
;  120  2969 eqstr
;  121  2975 eqstr
;  122  2981 eqstr
;  123  2987 eqstr
;  124  2993 eqstr
;  125  2999 eqstr
;  126  3005 eqstr
;  127  3011 eqstr
;  128  3017 eqstr
;  129  3023 eqstr
;  130  3029 eqstr
;  131  3035 eqstr
;  132  3041 eqstr
;  133  3047 eqstr
;  134  3053 eqstr
;  135  3059 eqstr
;  136  3065 eqstr
;  137  3071 eqstr
;  138  3077 eqstr
;  139  3083 eqstr
;  140  3089 eqstr
;  141  3095 eqstr
;  142  3101 eqstr
;  143  3107 eqstr
;  144  3113 eqstr
;  145  3119 eqstr
;  146  3125 eqstr
;  147  3131 eqstr
;  148  3137 eqstr
;  149  3157 prs
;  150  3161 printhex16
;  151  3172 prs
;  152  3176 prc
;  153  3180 printhex8a
;  154  3191 prs
;  155  3195 prc
;  156  3199 prscomment
;  157  3216 writetty
;  158  3225 writetty
;  159  3234 fputcR
;  160  3256 prc
;  161  3272 prc
;  162  3293 printhex4
;  163  3303 printhex4
;  164  3325 prc
;  165  3347 printhex8a
;  166  3358 printhex8a
;  167  3383 printIntU
;  168  3393 prc
;  169  3406 prs
;  170  3410 prs
;  171  3414 prs
;  172  3418 prs
;  173  3434 error1
;  174  3441 end1
;  175  3459 error1
;  176  3476 error1
;  177  3493 error1
;  178  3510 error1
;  179  3528 error1
;  180  3548 error1
;  181  3567 error1
;  182  3586 error1
;  183  3604 error1
;  184  3623 error1
;  185  3642 error1
;  186  3658 errorexit
;  187  3677 errorexit
;  188  3698 errorexit
;  189  3713 getarg
;  190  3720 parse
;  191  3726 fixJmpCall
;  192  3737 epilog
;  193  3744 end1
;  194  3768 cputs
;  195  3774 cputs
;  196  3780 exitR
;  197  3786 toupper
;  198  3794 strcpy
;  199  3801 strcat1
;  200  3809 strcpy
;  201  3816 strcat1
;  202  3824 strcpy
;  203  3831 strcat1
;  204  3839 openR
;  205  3845 cputs
;  206  3851 cputs
;  207  3857 exitR
;  208  3863 creatR
;  209  3870 cputs
;  210  3876 cputs
;  211  3882 exitR
;  212  3888 creatR
;  213  3895 cputs
;  214  3901 cputs
;  215  3907 exitR
;  216  3913 prs
;  217  3917 prs
;  218  3921 prs
;  219  3925 prs
;  220  3929 prs
;  221  3933 prs
;  222  3937 prs
;  223  3941 prs
;  224  3945 prs
;  225  3973 prs
;  226  3977 printIntU
;  227  3987 strcpy
;  228  3994 strlen
;  229  4001 searchLabel
;  230  4013 error1
;  231  4033 prs
;  232  4037 printIntU
;  233  4047 prs
;  234  4051 prs
;  235  4055 prs
;  236  4059 prs
;  237  4063 prs
;  238  4067 prs
;  239  4071 printIntU
;  240  4081 prs
;  241  4085 fputcR
;  242  4092 prs
;  243  4096 printIntU
;  244  4106 prs
;  245  4117 fcloseR
;  246  4125 fcloseR
;  247  4133 fcloseR
;  248  4141 exitR
;  249  4163 genCode8
;  250  4185 genCode8
;  251  4205 genCode8
;  252  4225 errorexit
;  253  4247 genCode8
;  254  4256 genCode8
;  255  4277 genCode16
;  256  4287 genCode16
;  257  4313 genCode8
;  258  4322 genCode8
;  259  4331 genCode16
;  260  4354 genCode32
;  261  4364 genCode16
;  262  4374 genCode8
;  263  4393 getTokeType
;  264  4405 getCodeSize
;  265  4417 getCodes
;  266  4426 genCode8
;  267  4435 getOpL
;  268  4442 checkOpL
;  269  4451 genCode2
;  270  4460 getTokeType
;  271  4472 implerror
;  272  4482 genCodeW
;  273  4491 writeEA
;  274  4499 check2Ops
;  275  4509 reg16error
;  276  4520 addrerror
;  277  4530 genCode8
;  278  4539 genCode8
;  279  4548 writeEA
;  280  4556 check2Ops
;  281  4566 setsflag
;  282  4575 genCodeW
;  283  4584 genImmediate
;  284  4597 genCodeW
;  285  4606 writeEA
;  286  4614 genCode8
;  287  4623 genImmediate
;  288  4636 genCodeW
;  289  4645 writeEA
;  290  4653 genCodeW
;  291  4662 writeEA
;  292  4670 syntaxerror
;  293  4682 check2Ops
;  294  4692 genCode2
;  295  4701 genImmediate
;  296  4714 genCodeW
;  297  4723 writeEA
;  298  4731 genImmediate
;  299  4744 regmemerror
;  300  4756 ChangeDirection
;  301  4772 reg16error
;  302  4783 genCode2
;  303  4792 writeEA
;  304  4800 genCodeW
;  305  4809 genCode16
;  306  4819 genCodeW
;  307  4828 genCode16
;  308  4838 genCodeW
;  309  4847 writeEA
;  310  4855 ChangeDirection
;  311  4871 genCodeW
;  312  4880 writeEA
;  313  4888 syntaxerror
;  314  4900 searchLabel
;  315  4912 checkConstSize
;  316  4927 genCode2
;  317  4936 genCode8
;  318  4945 genCode8
;  319  4954 genCode2
;  320  4963 genCode16
;  321  4973 genCode8
;  322  4982 genCode2
;  323  4991 genCode16
;  324  5001 storeJmpCall
;  325  5014 searchLabel
;  326  5026 checkConstSize
;  327  5041 genCode8
;  328  5050 genCode8
;  329  5059 genCode8
;  330  5068 genCode16
;  331  5078 genCode8
;  332  5087 genCode16
;  333  5097 genCode8
;  334  5106 genCode16
;  335  5116 storeJmpCall
;  336  5129 genCode8
;  337  5138 genCode16
;  338  5148 genCode8
;  339  5157 getOpL
;  340  5164 setsflag
;  341  5173 genCode2
;  342  5182 genCode8
;  343  5191 genCode16
;  344  5201 error1
;  345  5208 genCode8
;  346  5217 genCode8
;  347  5226 checkOpL
;  348  5235 reg16error
;  349  5246 genCode2
;  350  5255 genCode8
;  351  5264 writeEA
;  352  5272 syntaxerror
;  353  5284 check2Ops
;  354  5294 genCodeW
;  355  5303 writeEA
;  356  5311 genCodeW
;  357  5320 writeEA
;  358  5328 genCode8
;  359  5337 genCodeW
;  360  5346 writeEA
;  361  5354 genCode8
;  362  5363 genCode8
;  363  5372 genCode8
;  364  5381 getOp1
;  365  5388 genCode16
;  366  5398 numbererror
;  367  5410 need
;  368  5415 getOp1
;  369  5422 genCode8
;  370  5431 numbererror
;  371  5443 numbererror
;  372  5455 numbererror
;  373  5467 error1
;  374  5493 putch
;  375  5561 strcpy
;  376  5576 DosInt
;  377  5592 DosInt
;  378  5615 DosInt
;  379  5634 DosInt
;  380  5668 writetty
;  381  5677 writetty
;Input: AS.C, List: AS.S,  Lines:  372
;Glob. variables:  214 max.:  250
;Local variables:    5 max.:   50, in 'fixJmpCall'
;Functions      :   88 max.:  300
;Calls          :  382 max.: 2000, NameField: 5709 max.:    65535
;Code until     :24528 max.: 30000, free: 5472
;Data (HeapEnd) :58723, resting stacksize:  6812
;Max. Const in 'testReg' :  658 max. 3000, free: 2342