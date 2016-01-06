char I_START=0xF1;
//todo change CodeType and Opcode (2 bytes only)
//OpName,0,CodeType,OpCode1,OpCodeN,F1h
//  1:   1 byte opcode
char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
//  2: inc,dec
char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};
char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};
// 52: mem reg 16 bit
char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};
char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};
char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};
char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc
char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};
char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};
//  3: les, lda, lea
char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16
char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16
char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16
//  4: acc,imm  reg,imm  index,reg
char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};
char I_OR []={'O','R',0,                4, 1,     0xF1};
char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};
char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};
char I_AND[]={'A','N','D',0,            4, 4,     0xF1};
char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};
char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};
char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};
//  5: mov
char I_MOV[]={'M','O','V',0,            5,        0xF1};
//  6: single byte relative jump
char I_JO []={'J','O',0,                6, 0,     0xF1};
char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};
char I_JB []={'J','B',0,                6, 2,     0xF1};
char I_JC []={'J','C',0,                6, 2,     0xF1};
char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};
char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};
char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};
char I_JE []={'J','E',0,                6, 4,     0xF1};//    74 je i8rel
char I_JZ []={'J','Z',0,                6, 4,     0xF1};//  0F84 je i16r
char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//660F84 je i32r
char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};
char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};
char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};
char I_JA []={'J','A',0,                6, 7,     0xF1};
char I_JS []={'J','S',0,                6, 8,     0xF1};
char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};
char I_JP[]={'J','P',0,                 6,10,     0xF1};
char I_JPE[]={'J','P','E',0,            6,10,     0xF1};
char I_JNP[]={'J','N','P',0,            6,11,     0xF1};
char I_JPO[]={'J','P','O',0,            6,11,     0xF1};
char I_JL[]={'J','L',0,                 6,12,     0xF1};
char I_JNL[]={'J','N','L',0,            6,13,     0xF1};
char I_JGE[]={'J','G','E',0,            6,13,     0xF1};
char I_JLE[]={'J','L','E',0,            6,14,     0xF1};
char I_JNG[]={'J','N','G',0,            6,14,     0xF1};
char I_JG []={'J','G',0,                6,15,     0xF1};
//  8: ret
char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
//  9: seg, r/m
char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16
char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16
//  100 directives
char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
char I_DB[]=   {'D','B',0,            200,        0xF1};
char I_DW[]=   {'D','W',0,            201,        0xF1};
char I_DD[]=   {'D','D',0,            202,        0xF1};
char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
char I_END=0;// end of table char
