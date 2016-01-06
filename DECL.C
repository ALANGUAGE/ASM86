char LIST;              // listing on/off
char Symbol[31];        //next symbol to decode
char SymbolUpper[31];   //set toupper in getName
unsigned int SymbolInt; //integer value set in getDigit
char InputBuf[128];     //filled in getLine, no overflow test
unsigned char *InputPtr;//position in InputBuf
char namein [67];       //input file name  .S
char namelst[67];       //list file name   .LST
char namebin[67];       //output file name .COM
int  asm_fd;            //input file descriptor
int lst_fd;             //list file descriptor
int bin_fd;             //output file descriptor
int DOS_ERR;            //global var
int ErrorCount;         //number of errors
int DOS_NoBytes;        //number of bytes read (0 or 1)
char DOS_ByteRead;      //the byte just read by DOS

unsigned int PC;        //program counter, ORG nn
unsigned int PCStart;   //PC at start of line by PrintLine()
char isLabel;           //by getName()
#define DIGIT    1      //0-9
#define LETTERE  2      //a-z A-Z @ . _
#define ALNUME   3      //a-z A-Z @ . _  0-9
#define NOALNUME 4      //other char
char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
#define BYTE     1
#define WORD     2
#define DWORD    3
#define SEGREG   4
//char CodeSize;          //0, BYTE, WORD, DWORD
#define IMM      1      //const  ,123
#define REG      2      //       ,BX    mode=11
#define DIR      3      //VALUE  ,var1  mod=00, r/m=110
#define IND      4      //indirec,[var1],[BX+SI],[table+BX],[bp-4] disp 0,8,16
char Op1;               //0, IMM, REG, DIR, IND
char CodeType;          //1-207 by searchSymbol(), must be byte size

char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
char RegNo;             //0 - 7 AL, CL, ...  by testReg()
char OpSize;            //0, BYTE, WORD, DWORD
//char AddrSize;          //67h:
char NumOprns;          //0-2
char wflag;             //0=byte, 1=word/dword
char dflag;             //0=source is reg,  1=dest is reg
//char modrm;           //mod, r/m
char reg;               //combination of index and base reg
int disp;               //displacement      0-8 bytes
int imme;               //immediate         0-8 bytes

#define OPMAXLEN  5
char OpPos[OPMAXLEN];   //array for one opcode to list
int OpPrintIndex;       //0-OPMAXLEN, Position to print opcode, by genCode8()
char *OpCodePtr;        //position in OpCodeTable by searchSymbol(), div.
char PrReloc;           //print 'R' if relocative

char LabelNames[1000];  //space for names of all labels
char *LabelNamePtr;     // first free position
unsigned int LabelAddr[100];//addr of each label
int LabelMaxIx=0;       //actual number of stored labels
int LabelIx;            //actual number of just searched label

char FileBin  [2000];   //output binary file
unsigned int BinLen=0;  //length of binary file

char *arglen=0x80;      // for main only
char *argv=0x82;        // for main only
