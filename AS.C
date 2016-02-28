char Version1[]="AS.C V0.07";//BAS.BAT, AS TE, NAS.BAT
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
        getOpL();
        checkOpL();        
        if (Code2 <= 1) {//inc,dec
  	        if (Op == REG) {//short
                if (R1Type == WORD) {genCode(Code3, RegNo); return; }
                if (R1Type ==DWORD) {genCode(Code3, RegNo); return; }
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
        getOpL();       //setwflag not applicable
        if (R1Type != WORD) reg16error();//only r16
        need(',');   
        getOpR();
        if (Op2 != MEM) addrerror();//only m16 
        
        genCode8(Code1);//les,lds,lea
        if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
        Op=Op2;//set MEM for writeEA
        writeEA(R1No);           
        return;
    }

    if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
        get2Ops();    
        setwflag();     
        if (Op2 == IMM) {//second operand is imm     
            setsflag();   
            if (Op == REG) {                
                if (R1No == 0) {  
                    if (sflag == 0) {                        
                        c = Code1 << 3;
                        c += 4;//code for acc,imm     
                        genCodeW(c);
                        genImmediate();
                        return;
                    }
                }
            }
            //r/m, imm: 80 sign-extended,TTT,imm
            c = sflag + 0x80;       
            genCodeW(c); 
            writeEA(Code1);  
            genImmediate();
            return;     
        }  
       
        c = Code1 << 3;//r/m, r/m  
        if (Op == REG) {
            if (Op2 == MEM) {//reg, mem      
                c += 2;//add direction flag
                genCodeW(c);
                Op=Op2;//set MEM for writeEA                
                writeEA(R1No);
                return;    
            }
        }
        if (Op2 == REG) {//mem,reg    reg,reg
            genCodeW(c);
            writeEA(RegNo);//2. Op in reg-field
            return;            
        }          
        
        syntaxerror();        
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

int checkOpL() {
    if (Op == ADR) implerror();
    if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
    setwflag();
    if (OpSize == 0) error1("no op size declared");
    if (OpSize == R1Type) return;
    if (OpSize){
        if (Op == MEM) return;
        error1("Conflict OpSize and RegSize"); 
        }
    if (R1Type==0) error1("no register defined");
}
/*    Op, Op2 =0, 1=IMM, 2=REG, 3=ADR, 4=MEM 
IMM      imme           = 0, SymbolInt
REG      R1No,RegNo     = 0 - 7
REG      R1Type,RegType = 0, BYTE, WORD, DWORD, SEGREG 
MEM,ADR  disp           = 0, LabelAddr[LabelIx]
MEM      regindexbase   = 0 - 7
         OpSize         = 0, BYTE, WORD, DWORD
         wflag          */         
int get2Ops() {
    getOpL();
    need(',');    
    getOpR();         
}         
int getOpL() {
//set: op=0,IMM,REG,ADR,MEM
    disp=0; imme=0; isDirect=1; 
    getOpR();
    Op=Op2;         Op2=0;
    R1No=RegNo;     RegNo=0;
    R1Type=RegType; RegType=0; 
}  

int getOpR() {
    Op2=getOp1();
    if (isToken('[')) {Op2 = MEM; getMEM();    return;}
    if (Op2 == 0)     {invaloperror();         return;}
    if (Op2 == IMM)   {imme=SymbolInt;         return;}
    if (Op2 == REG)                            return;
    if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
    error1("Name of operand expected");
}

int getOp1() {//scan for a single operand
//return:0, IMM, REG, ADR (not MEM)
//set   :RegType, RegNo by testReg
//set   :LabelIx by searchLabel
    if (TokeType == 0)      return 0;
    if (TokeType == DIGIT)  return IMM;
    if (TokeType == ALNUME) {
        RegNo=testReg();
        if (RegType)        return REG;
        LabelIx=searchLabel();
        if (LabelIx)        return ADR;
        else error1("variable not found"); 
    }
    return 0;
}

int getMEM() {// e.g. [array+bp+si-4]
//set: disp, regindexbase, RegType
    char c;
    disp=0; regindexbase=0;
    do {
        getTokeType();
        c=getOp1();
        if (c ==   0) syntaxerror();
        if (c == REG) {isDirect=0;
            if (regindexbase) regindexbase=getIndReg2();
            else getIndReg1();
        }
        if (c == ADR) disp=disp+LabelAddr[LabelIx];
        if (c == IMM) disp=disp+SymbolInt;
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
        if (Op == REG) OpSize=R1Type;
        if (Op2== REG) OpSize=RegType;        
        if (RegType== SEGREG) OpSize=WORD;
        if (R1Type == SEGREG) OpSize=WORD;        
    }
    if (OpSize  == DWORD) {gen66h(); wflag=1;}
    if (OpSize  ==  WORD) wflag=1;
}

int setsflag() {  
    sflag=2;
    if(imme > 127) sflag = 0;    
    if (OpSize == BYTE) {
        if (sflag == 0) error1("too big for byte r/m");
        sflag=0;//byte reg does not need sign extended   
    }
}
