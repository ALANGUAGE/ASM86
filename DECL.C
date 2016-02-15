char LIST;              // listing on/off
#define SYMBOLMAX    31
char Symbol[SYMBOLMAX]; //next symbol to decode
char SymbolUpper[SYMBOLMAX];//set toupper in getName
unsigned int SymbolInt; //integer value set in getDigit
#define INPUTBUFMAX 127
char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
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
#define IMM      1      //const  ,123
#define REG      2      //       ,BX    mode=11
#define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
#define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
char Op;                //1. operand: 0, IMM, REG, ADR, MEM  
char Op2;               //2. operand
char CodeType;          //1-207 by searchSymbol(), must be byte size
char Code1;             //1. Opcode
char Code2;             //2. Opcode
char Code3;             //3. Opcode
char RegNo;             //0 - 7 AL, CL, ...  set in testReg()  
char R1No;              //temp for 1. register
char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
char R1Type;            //temp for 1. register 
char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
char wflag;             //wordflag: 0=byte, 1=word/dword
//char dflag;             //directionflag: 1=to reg MOV,ALU    
char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
char regindexbase;      //combination of index and base reg
char isDirect;          //set in getOpL and getMeM, need in WriteEA
int disp;               //displacement      0-8 bytes
int imme;               //immediate         0-8 bytes

#define OPMAXLEN 5
char OpPos[OPMAXLEN];   //array for one opcode to list
int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
char *OpCodePtr;        //position in OpCodeTable by searchSymbol
char PrintR;           //print 'R' if relocative

#define LABELNAMESMAX 969//next number - 31
char LabelNames[1000];  //space for names of all labels
char *LabelNamePtr;     // first free position
#define LABELADRMAX 100
unsigned int LabelAddr[LABELADRMAX];//addr of each label
int LabelMaxIx=0;       //actual number of stored labels
int LabelIx;            //actual number of just searched label

#define FILEBINMAX 2000 //next number - max. oplength
char FileBin  [FILEBINMAX];//output binary file
unsigned int BinLen=0;  //length of binary file

char *arglen=0x80;      // for main only
char *argv=0x82;        // for main only
