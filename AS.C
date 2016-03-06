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
                if (wflag) {genCode2(Code3, R1No); return; }
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
        check2Ops();    //setwflag not applicable
        if (R1Type != WORD) reg16error();//only r16
        if (Op2 != MEM) addrerror();//only m16 
        
        genCode8(Code1);//les,lds,lea
        if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
        Op=Op2;//set MEM for writeEA
        writeEA(R1No);           
        return;
    }

    if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
        check2Ops();    
        if (Op2 == IMM) {//second operand is imm     
            setsflag();   
            if (Op == REG) {                
                if (R1No == 0) {// acc,imm   
                    if (sflag == 0) {                        
                        c = Code1 << 3;
                        c += 4;    
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
            genImmediateSE();
            return;     
        }  
        c = Code1 << 3;//r/m, r/r  
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
            writeEA(R2No);//2. Op in reg-field
            return;            
        }          
        syntaxerror();        
        return;
    }
 
    if (CodeType == 5) {//mov (movsx, movzx=51)
        dflag=0;
        check2Ops();    
/*    prs("\n Op:"); printhex8a(Op);
    prs(", Op2:"); printhex8a(Op2);
    prs(", R1No:"); printhex8a(R1No);
    prs(", R2No:"); printhex8a(R2No);   */  
        if (Op2 == ADR) {
            imme=disp;
            Op2=IMM;//continue with IMM    
        }  
        if (Op2 == IMM) {// r,i     
            if (Op == REG) {               
                c = wflag << 3;   
                c += 0xB0;                                     
                genCode2(c, R1No);   
                genImmediate();
                return; 
            }
            if (Op == MEM) {// m,i  
                genCodeW(0xC6);
                writeEA( 0 );
                genImmediate();
                return;  
            }
            regmemerror();
            return;
        }      
        if (R1Type == SEGREG) ChangeDirection();//sreg,rm
        if (R2Type == SEGREG) {//rm,sreg
            if (OpSize != WORD) reg16error();
                genCode2(0x8C, dflag);
                writeEA(R2No);
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
    error1("Command not implemented");
}    
     
int ChangeDirection() {
    char c;
    c=Op;     Op    =Op2;    Op2   =c;
    c=R1Type; R1Type=R2Type; R2Type=c;
    c=R1No;   R1No  =R2No;   R2No  =c;
    dflag=2;     
}
     
int checkOpL() {
    if (Op == ADR) implerror();
    if (R2Type == SEGREG) {segregerror(); return;}//only move,push,pop
    setwflag();
    if (OpSize == 0) error1("no op size declared");
    if (OpSize == R1Type) return;
    if (OpSize){
        if (Op == MEM) return;
        error1("Conflict OpSize and RegSize"); 
        }
    if (R1Type==0) error1("no register defined");
}
    
int check2Ops() {
    get2Ops();
    if (Op ==   0) addrerror();
    if (Op == ADR) invaloperror(); 
    if (Op == IMM) immeerror();   
    if (Op2==   0) addrerror();
//    if (Op2== ADR) invaloperror();//allowed in mov           
    setwflag();       
}    
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
    R1No=R2No;      R2No=0;
    R1Type=R2Type; R2Type=0; 
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
//set   :R2Type, R2No by testReg
//set   :LabelIx by searchLabel
    if (TokeType == 0)      return 0;
    if (TokeType == DIGIT)  return IMM;
    if (TokeType == ALNUME) {
        R2No=testReg();
        if (R2Type)        return REG;
        LabelIx=searchLabel();
        if (LabelIx)        return ADR;
        else error1("variable not found"); 
    }
    return 0;
}

int getMEM() {// e.g. [array+bp+si-4]
//set: disp, rm, R2Type
    char c;
    disp=0; rm=0;
    do {
        getTokeType();
        c=getOp1();
        if (c ==   0) syntaxerror();
        if (c == REG) {isDirect=0;
            if (rm) rm=getIndReg2();
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
    if (R2Type !=WORD) indexerror();
    if (R2No==3) rm=7;//BX
    if (R2No==5) rm=6;//BP, change to BP+0
    if (R2No==7) rm=5;//DI
    if (R2No==6) rm=4;//SI
    if (rm==0) indexerror();
}
int getIndReg2() {char m; m=4;//because m=0 is BX+DI
    if (R2Type !=WORD) indexerror();
    if (R2No==7) if (rm==6) m=3;//BP+DI
             else if (rm==7) m=1;//BX+DI
    if (R2No==6) if (rm==6) m=2;//BP+SI
             else if (rm==7) m=0;//BX+SI
    if (m > 3) indexerror();
    return m;
}
                  
int setwflag() {//word size, bit 0
    wflag=0;
    if (OpSize == 0) {//do not override OpSize
        if (Op == REG) OpSize=R1Type;
        if (Op2== REG) OpSize=R2Type;        
        if (R2Type== SEGREG) OpSize=WORD;
        if (R1Type == SEGREG) OpSize=WORD;        
    }
    if (OpSize  == DWORD) {gen66h(); wflag=1;}
    if (OpSize  ==  WORD) wflag=1;
}
int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3     
    sflag=2;  
    if(imme > 127) sflag = 0;
    if (OpSize == BYTE) {
        if (imme > 255) error1("too big for byte r/m");
        sflag=0;//byte reg does not need sign extended   
    }
}
