char LIST;
char Symbol[80]; char SymbolUpper[80]; unsigned int SymbolInt;
char InputBuf[128];  unsigned char *InputPtr;
char namein [67]; char namelst[67]; char namebin[67];
int  asm_fd;       int lst_fd;       int bin_fd;
int DOS_ERR;     int ErrorCount;
int DOS_NoBytes; char DOS_ByteRead;

unsigned int PC;   //program counter, ORG nn
unsigned int PCStart;//PC at start of line by PrintLine()
char isLabel;      //by getName()
#define LABEL    1
#define VARIABLE 2
#define DIGIT    1 //0-9
#define ALNUM    2 //0-9 _ a-z A-Z
char TokeType;     //0, DIGIT, ALNUM, noalnum
#define BYTE     1
#define WORD     2
#define DWORD    3
#define SEGREG   4
//char CodeSize;     //0, BYTE, WORD, DWORD
#define IMM      1 //const  ,123
#define REG      2 //       ,BX    mode=11
#define DIR      3 //VALUE  ,var1  mod=00, r/m=110
#define IND      4 //indirec,[var1], [BX+SI], [table+BX], [bp-4]  disp 0,8,16
char Op1;          //0, IMM, REG, DIR, IND
int  CodeType;     //1-207 by searchSymbol()

char RegType;      //0=no reg, BYTE, WORD, DWORD, SEGREG
char RegNo;        //0 - 7 AL, CL, ...  by testReg()
char OpSize;       //0, BYTE, WORD, DWORD
//char AddrSize;   //67h:
char NumOprns;     //0-2
char wflag;        //0=byte, 1=word/dword
char dflag;        //0=source is reg,  1=dest is reg
//char modrm;        //mod, r/m
char reg;          //combination of index and base reg
int disp;          //displacement      0-8 bytes
int imme;          //immediate         0-8 bytes

#define OPMAXLEN  5
char OpPos[OPMAXLEN];
int OpPrintIndex;  //0-OPMAXLEN, Position to print opcode, by genCode8()
char *OpCodePtr;   //position in OpCodeTable by searchSymbol(), div.
char PrReloc;      //print 'R' if relocative
char LabelNames[1000]; char *LabelNamePtr;
char LabelType  [100]; unsigned int LabelAddr[100];
int LabelMaxIx=0;  int LabelIx;
char FileBin  [2000]; unsigned int BinLen=0;
char *arglen=0x80; char *argv=0x82;
