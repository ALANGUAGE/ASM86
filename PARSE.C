int parse() {
  LabelNamePtr= &LabelNames;
  do {
    PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
    getLine();
    InputPtr = &InputBuf;
    getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
    if (TokeType == ALNUME) {
      if (isLabel) { //set in getName
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
    else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
    printLine();
  } while (DOS_NoBytes != 0 );
}
// scan code .....................................
int getTokeType() { char c;
  skipBlank();
  c = *InputPtr;
  if (c == 0)   {TokeType=0; return; }//last line or empty line
  if (c == ';') {TokeType=0; return; }//comment
  if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  TokeType=NOALNUME; return;
}
int storeLabel() {
  if(searchLabel()) error1("duplicate label");
  LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  LabelNamePtr++;
  LabelMaxIx++;
  LabelAddr[LabelMaxIx] = PC;
}
int searchLabel() {
  int LIx; char *p; int j;
  p = &LabelNames;
  LIx=1;
  while (LIx <= LabelMaxIx) {
    if (eqstr(p, Symbol)) return LIx;//pos of label
    j=strlen(p);
    p=p+j; p++; LIx++;
  }
  return 0;
}
int getVariable() { char c;
  storeLabel();
  getTokeType(); if(TokeType==ALNUME) {// getName
    lookCode();
    if (CodeType < 200) errorexit("D or RES B,W,D expected");
    if (CodeType > 207) errorexit("D or RES B,W,D expected");
    if (CodeType== 200) {// DB
      do { getTokeType();
        if (TokeType ==DIGIT) genCode8(SymbolInt);
        else {
          skipBlank();
          if (isToken('"')) {
            do { c= *InputPtr;
              genCode8(c);
              InputPtr++;
            } while (*InputPtr != '"' );
            InputPtr++;
          }
        }
      } while (isToken(','));
    }
    if (CodeType== 201) {// DW
      do { getTokeType();
        if (TokeType ==DIGIT) genCode16(SymbolInt);
      } while (isToken(','));
    }
  }
  else errorexit("DB,DW,DD or RESB,W,D expected");
}
int lookCode() { // ret: CodeType, *OpCodePtr
  CodeType=0;
  OpCodePtr= &I_START;
  OpCodePtr++;
  do  {
    if (eqstr(SymbolUpper, OpCodePtr))  {
      while(*OpCodePtr!=0) OpCodePtr++;
      OpCodePtr++; CodeType =*OpCodePtr;
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
  } return 0;
}
int isToken(char c) {
  skipBlank();
  if (*InputPtr == c) {
    InputPtr++; return 1;} return 0;
}
int skipRest() {
  getTokeType(); if(TokeType!=0)error1("extra char ignored");
}
