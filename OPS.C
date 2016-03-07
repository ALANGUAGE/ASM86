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
