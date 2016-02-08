char Version1[]="AS.C V0.07 31.1.2016";//BAS.BAT, AS TE, NAS.BAT
#include "DECL.C"
#include "OPTABL.C"

#include "PARSE.C"
#include "HELPER.C"
#include "OUTPUT.C"
#include "MAIN.C"
#include "GENCODE.C"

int process() { 
    char c;
  getTokeType();//0, DIGIT, ALNUME, NOALNUME
  OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  getCodes();//set: Code1, Code2, Code3

  if (CodeType ==  1) {//1 byte opcode
    genCode8(Code1);
    return;
  }
  
  if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
    checkOp();
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
    genCodeW(Code1);
    writeEA(Code2);
    return;
  }
  
  if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
    checkOp();      
    if (RegType != WORD) reg16error();
    if (Op1 == IMM) immeerror();
    R1No=RegNo;
    need(',');    
    getOp();
    if (Op1 < ADR) addrerror(); 
        
    genCode8(Code1);//les,lds,lea
    if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
    writeEA(R1No);           
    return;
  }

  if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
    checkOp();
    if (Op1 == IMM) immeerror();  
    Optemp = Op1;    
    R1No=RegNo;   
    R1Type = RegType;
    need(',');    
    getOp();  
//prs("\nOp1:"); printIntU(Op1); prs(", imme:"); printIntU(imme);       
    if (Op1 == IMM) {//second operand is imm  
        if (R1No == 0) {//acc, imm: 04,imm
            Code1 = Code1 << 3;
            Code1 += 4;//code for acc,imm     
            genCodeW(Code1);
            genImmediate();
            return;
        }
        //r/m, imm: 80 sign-extended,TTT,imm
        getSignExtended(imme);    
        c = sflag + 0x80;       
        genCodeW(c); 
        writeEA(Code1);//todo not Op1??
        return;     
       
    } 
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
    PC=SymbolInt;
    return;
  }
  error1("unknown CodeType");
}    

int checkOp() {
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
/*    Op1, Optemp =0, 1=IMM, 2=REG, 3=ADR, 4=MEM 
IMM      imme           = 0, SymbolInt
REG      R1No,RegNo     = 0 - 7
REG      R1Type,RegType = 0, BYTE, WORD, DWORD, SEGREG 
MEM,ADR  disp           = 0, LabelAddr[LabelIx]
MEM      regindexbase   = 0 - 7
         OpSize         = 0, BYTE, WORD, DWORD
         wflag
*/ 
 
int getOp() {
//set: op1=0,IMM,REG,ADR,MEM
  disp=0; imme=0; regindexbase=0; isDirect=1;

  Op1=getOp1();
  if (isToken('[')) {Op1 = MEM; getMEM();    return;}
  if (Op1 == 0)     {invaloperror();         return;}
  if (Op1 == IMM)   {imme=SymbolInt;         return;}
  if (Op1 == REG)                            return;
  if (Op1 == ADR)   {disp=LabelAddr[LabelIx];return;}
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
         
         
int setwflag() {
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

int getSignExtended(unsigned int i) {  
    sflag=2;
    if(i > 127) sflag = 0;
}
