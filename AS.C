int main() {getarg(); parse(); epilog(); end1();}//BAS.BAT,   AS TE
char Version1[]="AS.C V0.07 10.1.2016";
#include "DECL.C"
#include "OPTABL.C"

int process() { int i; char c;
  getTokeType();
  OpSize=getCodeSize();

  if (CodeType ==  1) {//1 byte opcode
    genInstruction(0, 1);
    return;
  }
  if (CodeType ==  2) {//inc, dec
    LeftOpwCheck();
    	if (Op1 == REG) {
        if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short
        if (RegType ==DWORD) {genInstruction(RegNo, 3); return; }
      }
      genInstruction(wflag, 1);
      genCodeInREG();
      return;
  }

  if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
    LeftOpwCheck();
    genInstruction(wflag, 1);
    genCodeInREG();
    return;
  }

  if (CodeType==  8) {// ret
    if (TokeType == DIGIT) {
      genInstruction(0, 2);
      genCode16(SymbolInt);
      return;
    }
    genInstruction(0, 1); return;
  }

  if (CodeType==101) {// ORG nn
    if (TokeType != DIGIT) error1("only digit allowed");
    PC=SymbolInt;return;
  }
  error1("unknown CodeType");
}
int setwflag() {//only Op1 (first operand)
  wflag=0;
  if (OpSize == 0) {//do not override OpSize
    if (Op1 == REG) {
      OpSize=RegType;
      if (RegType == SEGREG) OpSize=WORD;
    }
  }
  if (OpSize  == DWORD) {gen66h(); wflag=1;}
  if (OpSize  ==  WORD) wflag=1;
}
//NumOprns==2, seg reg not allowed only mov and push
//size: reg size or declaration CodeSize
//1. acc, imm 04  if (imm) acc,imm; else rm,imm(sign extended);
//2. rm , imm 80
//2a sign ext 83
//3. reg, rm  02  if (dest==reg) set direction bit; else default;
//4. rm , reg 00
//5. error1(mem2mem)

int LeftOpwCheck() {
  getLeftOp();
  if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  setwflag();
  if (OpSize == 0) error1("no op size declared");
  if (OpSize == RegType) return;
  if (OpSize){if (Op1 == MEM) return;
    error1("Conflict OpSize and RegSize"); }
  if (RegType==0) error1("no register defined");
}

int getLeftOp() {//0,IMM,REG,ADR,MEM(disp,reg,RegType)
//set: op1, disp->imm, reg, regt->size
  disp=0; imme=0; reg=0;

  Op1=getOp1();
  if (isToken('[')) {Op1 = MEM; getMEM();  return;} //4
  if (Op1 == 0) error1("Name of operand expected");
  if (Op1 == IMM) {imme=SymbolInt;         return;} //1
  if (Op1 == REG)                          return;  //2
  if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;} //3
  error1("Name of operand expected #1");
}
int getOp1() {//scan for a single operand
//return:0, IMM, REG, ADR (not MEM)
//set   :RegType, RegNo by testReg
//set   :LabelIx by searchLabel
  if (TokeType == 0)      return 0;
  if (TokeType == DIGIT)  return IMM; //1
  if (TokeType == ALNUME) {
    RegNo=testReg();
    if (RegType)          return REG; //2
    LabelIx=searchLabel();
    if (LabelIx)          return ADR; //3
    else error1("variable not found"); }
  return 0;
}
int getMEM() {//   e.g. [array+bp+si-4]
//set: disp, reg, RegType
  char op2; char r1;
  disp=0; r1=0; RegType=0;
  do {
    getTokeType();
    op2=getOp1();
    if (op2 ==   0) syntaxerror();
    if (op2 == IMM) disp=disp+SymbolInt;
    if (op2 == REG) if (r1) r1=getIndReg2(r1);
                    else    r1=getIndReg1(  );
    if (op2 == ADR) disp=disp+LabelAddr[LabelIx];//is MEM variable
    if (isToken('-')) {
      getTokeType();
      if (TokeType != DIGIT) numbererror();
      disp = disp - SymbolInt;
    }
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

// generate code ...........................................................
int gen66h() {genCode8(0x66);}
int genCode8(char c) {
//set: BinLen++, OpPrintIndex++
  FileBin[BinLen]=c;
  BinLen++;
  PC++;
  if (OpPrintIndex < OPMAXLEN) {
    OpPos[OpPrintIndex]=c;
    OpPrintIndex++;
  }
}
int genCode16(int i) {
  genCode8(i); i=i >> 8;
  genCode8(i);
}
int genInstruction(char No, int loc) {
  char c;//set: OpCodePtr++
  if(loc) OpCodePtr=OpCodePtr+loc;
  c= *OpCodePtr + No;
  genCode8(c);
}
int genCodeInREG() {char x; //get Code for second byte
  OpCodePtr++;
  x= *OpCodePtr;
  writeEA(x);
}
int genModRegRM(){ writeEA(reg);//todo
}
int writeEA(char xxx) {//need: Op1, disp, RegNo, reg
  char len;
  len=0;
  xxx = xxx << 3;//in reg field of mod r/m
  if (Op1 ==   0) addrexit();
  if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;}  //2
  if (Op1 == ADR) {xxx |= 6; len=2; }                //3
  if (Op1 == MEM) { xxx = xxx + reg;                 //4
    if (disp) {
      disp;
      if(ax > 127) len=2;
      else len=1;
      if (len == 1) xxx |= 0x40;
      else xxx |= 0x80;
    }
  }
  genCode8(xxx);// gen second byte
  if (len == 1) genCode8 (disp);
  if (len == 2) genCode16(disp);
}

int testx() { __asm {
inc byte [Version1]   ;FE 06 [1000]
add bx, ax    ;01 C3
add ax, bx    ;01 D8
add word ax, [bx] ;03 07
VA dw 8
mov byte [bp- 4], al ;88 46 FC
mov      [VA+bx], al ;88 87 [300F]
}  }
//#include "AS1.C"
#include "PARSE.C"
#include "HELPER.C"
#include "OUTPUT.C"
#include "MAIN.C"
