int main() {getarg(); parse(); epilog(); end1();}//BAS.BAT, AS TE, NAS.BAT
char Version1[]="AS.C V0.07 29.1.2016";
#include "DECL.C"
#include "OPTABL.C"

int process() {
  getTokeType();//0, DIGIT, ALNUME, NOALNUME
  OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  getCodes();//set: Code1, Code2, Code3

  if (CodeType ==  1) {//1 byte opcode
    genCode8(Code1);
    return;
  }
  if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
    checkLeftOp();
      if (Code2 <= 1) {//inc,dec
    	if (Op1 == REG) {
        if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
        if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
        }
      }
      if (Code2 == 5) {//imul extension?
        getTokeType();
        if (TokeType) implerror();
      }
      genCode(Code1, wflag);
      writeEA(Code2);
      return;
  }
 
  if (CodeType ==  8) {//ret,retf
    if (TokeType == DIGIT) {
      genCode8(Code2);
      genCode16(SymbolInt);
      return;
    }
    genCode8(Code1); 
    return;
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
int checkLeftOp() {
  getOp();
  if (Op1 == ADR) implerror();
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
  disp=0; imme=0; regindexbase=0; isDirect=1;

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
    if (op2 == REG) {isDirect=0;
                      if (regindexbase) regindexbase=getIndReg2();
                      else getIndReg1();
                    }
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

// generate code ........................................
int getCodes() {
  OpCodePtr ++; Code1 = *OpCodePtr;
  OpCodePtr ++; Code2 = *OpCodePtr;
  OpCodePtr ++; Code3 = *OpCodePtr;
}
int gen66h() {genCode8(0x66);
}
int genCode(char c, char d) {
    c = c + d;
    genCode8(c);
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
int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
//mod-byte: mode76, reg/opcode543, r/m210    
  char len;
  len=0;
//  prs("\nxxx:"); printhex8a(xxx);
  xxx = xxx << 3;//in reg/opcode field
  if (Op1 ==   0) addrexit();
  if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  if (Op1 == ADR) error1("writeEA");           
  if (Op1 == MEM) {
    if (isDirect) {
        xxx |= 6;
        len = 2;
    }
    else { 
      xxx = xxx + regindexbase;   
      if (regindexbase == 6) {//make [BP+00]
        len=1;
        if (disp == 0) xxx |= 0x40;
      }

      if (disp) {
        ax = disp;
        if(ax > 127) len=2;
        else len=1;
        if (len == 1) xxx |= 0x40;
        else xxx |= 0x80;
      }
    }
  }
  genCode8(xxx);// gen second byte
  if (len == 1) genCode8 (disp);
  if (len == 2) genCode16(disp);
}

#include "PARSE.C"
#include "HELPER.C"
#include "OUTPUT.C"
#include "MAIN.C"
