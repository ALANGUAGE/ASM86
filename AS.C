int main() {getarg(); parse(); epilog(); end1();}//BAS   AS TE
char Version1[]="AS.C V0.06 4.1.2015";//alt-re 5[  7|  8{  N~  7Caps \
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

int process() { int i; char c;
  setTokeType();
  OpSize=getCodeSize();

  if (CodeType ==  1) {//1 byte opcode
    genInstruction(0, 1); return;
  }
  if (CodeType ==  2) {//inc, dec
    LeftOpwCheck();
    	if (Op1 == REG) {
        if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short form
        if (RegType ==DWORD) {genInstruction(RegNo, 3); return; } }
      genInstruction(wflag, 1); genCodeInREG(); return; 
  }

  if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
    LeftOpwCheck();
    genInstruction(wflag, 1); genCodeInREG(); return; 
  }

  if (CodeType==  8) {// ret
    if (TokeType == DIGIT) {genInstruction(0, 2); genCode16(SymbolInt);return;}
    genInstruction(0, 1); return; 
  }

  if (CodeType==101) {// ORG nn
    if (TokeType != DIGIT) error1("only digit allowed");
    PC=SymbolInt;return;
  }
  error1("unknown CodeType");
}

// scan code .....................................
int setTokeType() { char c; //set: TokeType
  skipBlank();
  c = *InputPtr;
  if (c == 0)   {TokeType=0; return; }//last line or empty line
  if (c == ';') {TokeType=0; return; }//comment
  if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  if (alnum (c)) {getName(c); TokeType=ALNUM; return;}//ret:2=Symbol
  TokeType=3; return;               //no alnum
}
int Ops() {
//O2=rr,rm,ri,mr,mi
//NumOprns==2, seg reg not allowed only mov and push
//size: 1.declaration CodeSize, 2.reg size, 3.error1
//1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
//2. rm , imm 80  
//2a sign ext 83
//3. reg, rm  02  if (dest==reg) set direction bit; else default;
//4. rm , reg 00
//5. error1(mem2mem)
}
int LeftOpwCheck() {
  getLeftOp();
  if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  setwflag();
  if (OpSize == 0) error1("no op size declared");
  if (OpSize == RegType) return;
  if (OpSize){if (Op1 == IND) return; 
    error1("Conflict OpSize and RegSize"); }
  if (RegType==0) error1("no register defined");
}
int getLeftOp() {//0,IMM,REG,DIR,IND(disp,reg,RegType)
//set: op1, disp->imm, reg, regt->size  
  disp=0; imme=0; reg=0; 

  Op1=getOp1();
  if (isToken('[')) {Op1 = IND; getIND(); return; }          //4
  if (Op1 == 0) error1("Name of operand expected");
  if (Op1 == IMM) {imme=SymbolInt; return;}//need OpSize     //1
  if (Op1 == REG) return;                                    //2
  if (Op1 == DIR) {disp=LabelAddr[LabelIx]; return;}         //3
  error1("Name of operand expected #1");
}
int setwflag() {//only Op1 (first operand)
  wflag=0;
  if (OpSize == 0) {//do not override OpSize
    if (Op1 == REG) {OpSize=RegType; if (RegType == SEGREG) OpSize=WORD;}
  }
  if (OpSize  == DWORD) {gen66h(); wflag=1;}
  if (OpSize  ==  WORD) wflag=1;
}
int getOp1() {//scan for a single operand 
  //set:Op1, imme, disp, RegType, TegNo, reg
  if (TokeType == 0)      return 0;
  if (TokeType == DIGIT)  return IMM;// 1
  if (TokeType == ALNUM) {
    RegNo=testReg();//set global RegType
    if (RegType)          return REG;// 2
    LabelIx=searchLabel(VARIABLE);//disp=LabelAddr[LabelIx];
    if (LabelIx)          return DIR;// 3
    else error1("variable not found"); }
  return 0;
}
int getIND() {//set: disp, reg, RegType          e.g.  [array+bp+si-4]
  char op2; char r1;  disp=0; r1=0; RegType=0;//because reg=0 is BX+DI
  do {
    setTokeType();// 0, DIGIT, ALNUM, no alnum
    op2=getOp1();
    if (op2 ==   0) syntaxerror();
    if (op2 == IMM) disp=disp+SymbolInt;
    if (op2 == REG) if (r1) r1=getIndReg2(r1); else r1=getIndReg1();
    if (op2 == DIR) disp=disp+LabelAddr[LabelIx];//is IND variable
    if (isToken('-')) {setTokeType(); 
      if (TokeType != DIGIT) numbererror(); disp=disp-SymbolInt;}
  } while (isToken('+'));
  if (isToken(']') == 0) errorexit("] expected"); 
  reg=r1;
}
int getIndReg1() {char m; m=0;
  if (RegType !=WORD) indexerror();
  if (RegNo==3) m=7;//BX
  if (RegNo==5) m=6;//BP change to BP+0
  if (RegNo==7) m=5;//DI
  if (RegNo==6) m=4;//SI
  if (m    ==0) indexerror();
  return m;
}
int getIndReg2(char r1) {char m; m=4;//because m=0 is BX+DI
  if (RegType !=WORD) indexerror();
  if (RegNo==7) if (r1==6) m=3;//BP+DI
           else if (r1==7) m=1;//BX+DI
  if (RegNo==6) if (r1==6) m=2;//BP+SI
           else if (r1==7) m=0;//BX+DI
  if (m > 3) indexerror();
  return m;
}

int getCodeSize() {
  if (TokeType ==ALNUM) {
    if (eqstr(SymbolUpper,"BYTE")) {setTokeType(); return BYTE;}
    if (eqstr(SymbolUpper,"WORD")) {setTokeType(); return WORD;}
    if (eqstr(SymbolUpper,"DWORD")){setTokeType(); return DWORD;}
  } return 0;
}
int isToken(char c) {
  skipBlank();
  if (*InputPtr == c) {
    InputPtr++; return 1;} return 0;
}
/*int need(char c) {
  if (isToken(c) == 0) {
    prs("\n; ************** expected >> "); prc(c);
    prs(" <<\\n"); errorexit("token expected"); }  }*/
int skipRest() {
  setTokeType(); if (TokeType != 0) prs("\n; ********** extra char ignored");
}
// generate code ...........................................................
int gen66h() {genCode8(0x66);}
int genCode8(char c) {//ret: BinLen++, OpPrintIndex++
  FileBin[BinLen]=c; BinLen++; PC++;
  if (OpPrintIndex < OPMAXLEN) {OpPos[OpPrintIndex]=c; OpPrintIndex++; }
}
int genCode16(int i) {
  genCode8(i); i=i >> 8; genCode8(i);
}
int genInstruction(char No, int loc) {char c;//set: OpCodePtr++
  if(loc) OpCodePtr=OpCodePtr+loc;
  c= *OpCodePtr + No; genCode8(c);
}
int genCodeInREG() {char x; //get Code for second byte
  OpCodePtr++; x= *OpCodePtr; writeEA(x);
}
int genModRegRM(){ writeEA(reg);//todo
}
int writeEA(char xxx) { char len; //need: Op1, disp, RegNo, reg
  len=0;
  xxx = xxx << 3;//in reg field of mod r/m
  if (Op1 ==   0) addrexit();  
  if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}        //2
  if (Op1 == DIR) {xxx |= 6; len=2; }                      //3
  if (Op1 == IND) { xxx = xxx + reg;                       //4
    if (disp) {disp; if(ax > 127) len=2; else len=1;
      if (len == 1) xxx |= 0x40; else xxx |= 0x80;}
    }
  genCode8(xxx);// gen second byte
  if (len == 1) genCode8 (disp);
  if (len == 2) genCode16(disp);
}
int test1() { __asm {
inc byte [Version1]   ;FE 06 [1000]
add bx, ax    ;01 C3
add ax, bx    ;01 D8
add word ax, [bx] ;03 07
VA dw 8
mov byte [bp- 4], al ;88 46 FC
mov      [VA+bx], al ;88 87 [300F]
}  }
#include "AS1.C"
