int main() {getarg(); parse(); epilog(); end1();}//BAS.BAT,   AS TE
char Version1[]="AS.C V0.07 16.1.2016";
#include "DECL.C"
#include "OPTABL.C"

int process() { int i; char c;
  getTokeType();
  OpSize=getCodeSize();////

  if (CodeType ==  1) {//1 byte opcode
    genInstruction(0, 1);
    return;
  }
  if (CodeType ==  2) {//inc, dec
    checkLeftOp(1);
    	if (Op1 == REG) {
        if (RegType == WORD) {genInstruction(RegNo, 3); return; }//short
        if (RegType ==DWORD) {genInstruction(RegNo, 3); return; }
      }
      genInstruction(wflag, 1);
      genCodeInREG();
      return;
  }

  if (CodeType ==  52) {//not,neg,mul,div,idiv, no ext. imul
    checkLeftOp(2);
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

int Check2Op(char left, char rigth) {
}
int checkLeftOp(char mode) {
  getOp();
  if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  setwflag();
  if (OpSize == 0) error1("no op size declared");
  if (OpSize == RegType) return;
  if (OpSize){if (Op1 == MEM) return;
    error1("Conflict OpSize and RegSize"); }
  if (RegType==0) error1("no register defined");
}

int saveLeftOp(){
}
int checkRightOp(char mode){
}

/*        Op      = 0, IMM, REG, ADR, MEM
IMM       imme    = 0, SymbolInt    
REG     R RegNo   = 0 - 7
REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
MEM,ADR   disp    = 0,LabelAddr[LabelIx]
MEM       regindexbase = 0 - 7

          OpSize  = 0, BYTE, WORD, DWORD (set wflag)
*/
int getOp() {
//set: op1=0,IMM,REG,ADR,MEM
  disp=0; imme=0; regindexbase=0;

  Op1=getOp1();
  if (isToken('[')) {Op1 = MEM; getMEM();  return;}
  if (Op1 == 0) error1("Name of operand expected");
  if (Op1 == IMM) {imme=SymbolInt;         return;}
  if (Op1 == REG)                          return;
  if (Op1 == ADR) {disp=LabelAddr[LabelIx];return;}
  error1("Name of operand expected #1");
}

int getOp1() {//scan for a single operand
//return:0, IMM, REG, ADR (not MEM)
//set   :RegType, RegNo by testReg
//set   :LabelIx by searchLabel
  if (TokeType == 0)      return 0;
  if (TokeType == DIGIT)  return IMM;
  if (TokeType == ALNUME) {
    RegNo=testReg();
    if (RegType)          return REG;
    LabelIx=searchLabel();
    if (LabelIx)          return ADR;
    else error1("variable not found"); 
  }
  return 0;
}

int getMEM() {// e.g. [array+bp+si-4]
//set: disp, regindexbase, RegType
  char op2;
  disp=0; regindexbase=0; RegType=0;
  do {
    getTokeType();
    op2=getOp1();
    if (op2 ==   0) syntaxerror();
    if (op2 == REG) if (regindexbase) regindexbase=getIndReg2();
                    else getIndReg1();
    if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
    if (op2 == IMM) disp=disp+SymbolInt;
    if (isToken('-')) {
      getTokeType();
      if (TokeType != DIGIT) numbererror();
      disp = disp - SymbolInt;
    }
  } while (isToken('+'));
  if (isToken(']') == 0) errorexit("] expected");
}
int getIndReg1() {
  if (RegType !=WORD) indexerror();
  if (RegNo==3) regindexbase=7;//BX
  if (RegNo==5) regindexbase=6;//BP, change to BP+0
  if (RegNo==7) regindexbase=5;//DI
  if (RegNo==6) regindexbase=4;//SI
  if (regindexbase==0) indexerror();
}
int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  if (RegType !=WORD) indexerror();
  if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
           else if (regindexbase==7) m=1;//BX+DI
  if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
           else if (regindexbase==7) m=0;//BX+SI
  if (m > 3) indexerror();
  return m;
}

// generate code ...........................................................
int genInstruction(char No, int loc) {
  char c;//add OpCodePtr with loc, emits contents  + No
  if(loc) OpCodePtr=OpCodePtr+loc;
  c= *OpCodePtr + No;
  genCode8(c);
}
int gen66h() {genCode8(0x66);
}
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
int genCodeInREG() {char x; //get Code for second byte
  OpCodePtr++;
  x= *OpCodePtr;
  writeEA(x);
}
int genModRegRM(){ writeEA(regindexbase);//todo
}
int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  char len;
  len=0;
  xxx = xxx << 3;//in regindexbase field of mod r/m
  if (Op1 ==   0) addrexit();
  if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} //2
  if (Op1 == ADR) {xxx |= 6; len=2; }               //3
  if (Op1 == MEM) { xxx = xxx + regindexbase;       //4
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
}  
}
#include "PARSE.C"
#include "HELPER.C"
#include "OUTPUT.C"
#include "MAIN.C"
