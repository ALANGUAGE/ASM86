int parse() {
    LabelNamePtr  = &LabelNames;    
    JmpCallNamePtr= &JmpCallNames;
    LabelMaxIx=0;    
    JmpCallMaxIx=0;  
    BinLen=0;
    
    do {//process a new line
        PCStart=PC; 
        OpSize=0;
        OpPrintIndex=0; 
        PrintRA=' ';
        getLine();
        InputPtr = &InputBuf;
        getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
        if (TokeType == ALNUME) {
            if (isLabel) {//set in getName
                storeLabel();
                InputPtr++;//remove :
                getTokeType();
            }
        }
        if (TokeType == ALNUME) {
            lookCode();// and OpCodePtr
            if(CodeType) process();
            else getVariable();
            skipRest();
        }
        else if (TokeType >ALNUME) error1("Label or instruction expected");
        else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
        printLine();
    } while (DOS_NoBytes != 0 );
}

int getTokeType() { 
    char c;
    skipBlank();
    c = *InputPtr;
    if (c == 0)   {TokeType=0; return; }//last line or empty line
    if (c == ';') {TokeType=0; return; }//comment
    if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
    if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
    TokeType=NOALNUME;
}                     

int storeJmpCall() {
    unsigned int i;
    JmpCallMaxIx++;
    if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
    JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
    JmpCallNamePtr++;
    i = JmpCallNamePtr - &JmpCallNames;    
    if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
    JmpCallAddr[JmpCallMaxIx] = PC;   
}

int storeLabel() {
    unsigned int i;
    LabelMaxIx++;
    if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
    if(searchLabel()) error1("duplicate label");
    LabelNamePtr=strcpy(LabelNamePtr, Symbol);
    LabelNamePtr++;
    i = LabelNamePtr - &LabelNames;
    if (i >= LABELNAMESMAX) errorexit("too many label names");
    LabelAddr[LabelMaxIx] = PC + Origin;
}   

int searchLabel() {
    int LIx; char *p;
    p = &LabelNames;
    LIx = 1;
    while (LIx <= LabelMaxIx) {
        if (eqstr(p, Symbol)) return LIx;//pos of label                    
        p=strlen(p) + p;                  
        p++; 
        LIx++;
    }
    return 0;
}   

int getVariable() { 
    char c; 
    storeLabel();
    getTokeType(); 
    if(TokeType==ALNUME) {//getName
        lookCode();
        if (CodeType < 200) dataexit();
        if (CodeType > 205) dataexit();
        if (CodeType== 200) {//DB
            do { 
                getTokeType();
                if (TokeType == DIGIT) genCode8(SymbolInt);
                else {
                    skipBlank();
                    if (isToken('"')) {
                        do { 
                            c= *InputPtr;
                            genCode8(c);
                            InputPtr++;
                        } while (*InputPtr != '"' );
                        InputPtr++;
                    }
                }
            } while (isToken(','));
        }
        if (CodeType == 201) {//DW
            do { 
                getTokeType();
                if (TokeType ==DIGIT) genCode16(SymbolInt);
            } while (isToken(','));
        } 
        if (CodeType == 202) {//DD
            do { 
                getTokeType();
                if (TokeType ==DIGIT) { genCode16(SymbolInt);
                                    genCode16(0);}//todo genCode32(SymbolLong);
            } while (isToken(','));
        } 
        if (CodeType >= 203) {//resb, resw, resd
            getTokeType();
            if (TokeType == DIGIT) {
                if (SymbolInt <= 0) syntaxerror();   
                if (AbsoluteLab == 0) error1("Absolute is null");
                LabelAddr[LabelMaxIx] = AbsoluteLab; 
                if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
                if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd                  
                AbsoluteLab = AbsoluteLab + SymbolInt;
            } else numbererror();  
        }    
    }
    else dataexit();
}

int lookCode() {//ret: CodeType, *OpCodePtr
    CodeType=0;
    OpCodePtr= &I_START;
    OpCodePtr++;
    do  {
        if (eqstr(SymbolUpper, OpCodePtr))  {
            while(*OpCodePtr!=0) OpCodePtr++;
            OpCodePtr++; 
            CodeType =*OpCodePtr;
            return;
        }
    while(*OpCodePtr!=0xF1) OpCodePtr++;
    OpCodePtr++;
    } while(*OpCodePtr!=0);
}

int getCodeSize() {
    if (TokeType ==ALNUME) {
        if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
        if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
        if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
    } 
    return 0;
}
int isToken(char c) {
    skipBlank();
    if (*InputPtr == c) {
        InputPtr++; 
        return 1;
        } 
    return 0;
}
int need(char c) {
    if (isToken(c)) {
        getTokeType();
        return;
        }
    error1();
    prs(". need: ");
    prc(c);
}
int skipRest() {
    getTokeType(); 
    if(TokeType)error1("extra char ignored");
}
