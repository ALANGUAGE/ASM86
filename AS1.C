//AS1.C  5.12.2014  BAS,  AS TE
int parse() {
  LabelNamePtr= &LabelNames;
  do {
    PCStart=PC; OpSize=0; OpPrintIndex=0; PrReloc=' ';
    getLine();
    InputPtr = &InputBuf;
    setTokeType();// getCode in SymbolUpper, set TokeType, set isLabel by getName
    if (TokeType == ALNUM) {
      if (isLabel) {
        storeLabel(LABEL); 
        InputPtr++;//remove :
        setTokeType();
      }
    }
    if (TokeType == ALNUM) {
      lookCode();// and OpCodePtr
      if(CodeType) process();
      else getVariable();
      skipRest();
    }
    else if (TokeType >  ALNUM) error1("Label or instruction expected");
    else if (TokeType == DIGIT) error1("No digit allowed at start of line");
    printLine();
  } while (DOS_NoBytes != 0 );
}
int storeLabel(char LabType) {
  if(searchLabel(LabType)) error1("duplicate symbol");
  LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  LabelNamePtr++;
  LabelMaxIx++;
  LabelType[LabelMaxIx] = LabType;// 1=LABEL, 2=VARIABLE
  LabelAddr[LabelMaxIx] = PC;
}
int searchLabel(char searchType) {
  int LIx; char *p; int j;
  p = &LabelNames;
  LIx=1;
  while (LIx <= LabelMaxIx) {
    if (eqstr(p, Symbol)) return LIx;//and searchType
    j=strlen(p);
    p=p+j; p++; LIx++;
  }
  return 0;
}
int getVariable() { char c;
  storeLabel(VARIABLE);
  setTokeType(); if(TokeType==ALNUM) {// getName
    lookCode();
    if (CodeType < 200) errorexit("D or RES B,W,D expected");
    if (CodeType > 207) errorexit("D or RES B,W,D expected");
    if (CodeType== 200) {// DB
      do { setTokeType();
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
      do { setTokeType();
        if (TokeType ==DIGIT) genCode16(SymbolInt);
      } while (isToken(','));
    }
  }
  else errorexit("DB,DW,DD or RESB,W,D expected");
}
// helper functions XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  InputPtr= &InputBuf;
  *InputPtr=0;//if last line is empty
  do {
    DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
    if (DOS_ERR) errorexit("Reading Source");
    if (DOS_NoBytes == 0) return;
    *InputPtr = DOS_ByteRead; 
    InputPtr++;
  } while (ifEOL(DOS_ByteRead) == 0);
  InputPtr--;
  *InputPtr=0;
}
int ifEOL(char c) {
  if (c == 10) return 1;
  if (c == 13) { 
    DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1); 
    return 1;}
  return 0;
}
int skipBlank() {
  skipblank1:
    if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
    if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
}
int getDigit(unsigned char c) {//ret: SymbolInt
  unsigned int CastInt;
  SymbolInt=0;
  do {
    c-='0';
    SymbolInt=SymbolInt*10;
    ax=0; CastInt=c; //cast b2w
    SymbolInt=SymbolInt+CastInt;
    InputPtr++;
    c = *InputPtr;
  } while(digit(c));
}
int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  char *p;
  p = &Symbol;
  *p = c;
  p++;
  while (alnum(c)) {
    InputPtr++;
    c = *InputPtr;
    *p = c;
    p++;
  }
  if (c == ':') isLabel=1; else isLabel=0;
  p--;
  *p = 0;
  strcpy(SymbolUpper, Symbol);
  toupper(SymbolUpper);
}
int testReg() {
//ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  RegType=0;
  if (strlen(Symbol) < 2) return 0;
  if (strlen(Symbol) > 3) return 0;
  RegType=BYTE;
  if (eqstr(SymbolUpper, "AL")) return 0;
  if (eqstr(SymbolUpper, "CL")) return 1;
  if (eqstr(SymbolUpper, "DL")) return 2;
  if (eqstr(SymbolUpper, "BL")) return 3;
  if (eqstr(SymbolUpper, "AH")) return 4;
  if (eqstr(SymbolUpper, "CH")) return 5;
  if (eqstr(SymbolUpper, "DH")) return 6;
  if (eqstr(SymbolUpper, "BH")) return 7;
  RegType=WORD;
  if (eqstr(SymbolUpper, "AX")) return 0;
  if (eqstr(SymbolUpper, "CX")) return 1;
  if (eqstr(SymbolUpper, "DX")) return 2;
  if (eqstr(SymbolUpper, "BX")) return 3;
  if (eqstr(SymbolUpper, "SP")) return 4;
  if (eqstr(SymbolUpper, "BP")) return 5;
  if (eqstr(SymbolUpper, "SI")) return 6;
  if (eqstr(SymbolUpper, "DI")) return 7;
  RegType=SEGREG;
  if (eqstr(SymbolUpper, "ES")) return 0;
  if (eqstr(SymbolUpper, "CS")) return 1;
  if (eqstr(SymbolUpper, "SS")) return 2;
  if (eqstr(SymbolUpper, "DS")) return 3;
  if (eqstr(SymbolUpper, "FS")) return 4;
  if (eqstr(SymbolUpper, "GS")) return 5;
  RegType=DWORD;
  if (eqstr(SymbolUpper, "EAX"))return 0;
  if (eqstr(SymbolUpper, "ECX"))return 1;
  if (eqstr(SymbolUpper, "EDX"))return 2;
  if (eqstr(SymbolUpper, "EBX"))return 3;
  if (eqstr(SymbolUpper, "ESP"))return 4;
  if (eqstr(SymbolUpper, "EBP"))return 5;
  if (eqstr(SymbolUpper, "ESI"))return 6;
  if (eqstr(SymbolUpper, "EDI"))return 7;
  RegType=0; return 0;
}
// opcodes XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
char I_START=0xF1;//OpName,0,CodeType,OpCode1,OpCodeN,F1h
//  1:   1 byte opcode
char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
//  2: inc,dec
char I_INC[]={'I','N','C',0,            2,0xFE, 0,0x40,0xF1};
char I_DEC[]={'D','E','C',0,            2,0xFE, 1,0x48,0xF1};
// 52: mem reg 16 bit
char I_NOT[]={'N','O','T',0,           52,0xF6, 2,0xF1};
char I_NEG[]={'N','E','G',0,           52,0xF6, 3,0xF1};
char I_MUL[]={'M','U','L',0,           52,0xF6, 4,0xF1};
char I_IMUL[]={'I','M','U','L',0,      52,0xF6, 5,0xF1};//only acc
char I_DIV[]={'D','I','V',0,           52,0xF6, 6,0xF1};
char I_IDIV[]={'I','D','I','V',0,      52,0xF6, 7,0xF1};
//  3: les, lda, lea
char I_LES[]={'L','E','S',0,            3,0xC4,   0xF1};// /r, a16
char I_LDS[]={'L','D','S',0,            3,0xC5,   0xF1};// /r, a16
char I_LEA[]={'L','E','A',0,            3,0x8D,   0xF1};// /r, a16
//  4: acc,imm  reg,imm  index,reg
char I_ADD[]={'A','D','D',0,            4, 0,     0xF1};
char I_OR []={'O','R',0,                4, 1,     0xF1};
char I_ADC[]={'A','D','C',0,            4, 2,     0xF1};
char I_SBB[]={'S','B','B',0,            4, 3,     0xF1};
char I_AND[]={'A','N','D',0,            4, 4,     0xF1};
char I_SUB[]={'S','U','B',0,            4, 5,     0xF1};
char I_XOR[]={'X','O','R',0,            4, 6,     0xF1};
char I_CMP[]={'C','M','P',0,            4, 7,     0xF1};
//  5: mov
char I_MOV[]={'M','O','V',0,            5,        0xF1};
//  6: single byte relative jump
char I_JO []={'J','O',0,                6, 0,     0xF1};
char I_JNO[]={'J','N','O',0,            6, 1,     0xF1};
char I_JB []={'J','B',0,                6, 2,     0xF1};
char I_JC []={'J','C',0,                6, 2,     0xF1};
char I_JNB[]={'J','N','B',0,            6, 3,     0xF1};
char I_JAE[]={'J','A','E',0,            6, 3,     0xF1};
char I_JNC[]={'J','N','C',0,            6, 3,     0xF1};
char I_JE []={'J','E',0,                6, 4,     0xF1};//      74 je i8 rel
char I_JZ []={'J','Z',0,                6, 4,     0xF1};//   0F 84 je i16 rel
char I_JNE[]={'J','N','E',0,            6, 5,     0xF1};//66 0F 84 je i32 rel
char I_JNZ[]={'J','N','Z',0,            6, 5,     0xF1};
char I_JBE[]={'J','B','E',0,            6, 6,     0xF1};
char I_JNA[]={'J','N','A',0,            6, 6,     0xF1};
char I_JA []={'J','A',0,                6, 7,     0xF1};
char I_JS []={'J','S',0,                6, 8,     0xF1};
char I_JNS[]={'J','N','S',0,            6, 9,     0xF1};
char I_JP[]={'J','P',0,                 6,10,     0xF1};
char I_JPE[]={'J','P','E',0,            6,10,     0xF1};
char I_JNP[]={'J','N','P',0,            6,11,     0xF1};
char I_JPO[]={'J','P','O',0,            6,11,     0xF1};
char I_JL[]={'J','L',0,                 6,12,     0xF1};
char I_JNL[]={'J','N','L',0,            6,13,     0xF1};
char I_JGE[]={'J','G','E',0,            6,13,     0xF1};
char I_JLE[]={'J','L','E',0,            6,14,     0xF1};
char I_JNG[]={'J','N','G',0,            6,14,     0xF1};
char I_JG []={'J','G',0,                6,15,     0xF1};
//  8: ret
char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
//  9: seg, r/m
char I_PUSH[]={'P','U','S','H',0,       9,0x50,   0xF1};//r16
char I_POP[]={'P','O','P',0,            9,0x58,   0xF1};//r16
//  100 directives
char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
char I_DB[]=   {'D','B',0,            200,        0xF1};
char I_DW[]=   {'D','W',0,            201,        0xF1};
char I_DD[]=   {'D','D',0,            202,        0xF1};
char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
char I_END=0;// end of table char

int lookCode() { // ret: CodeType, OpCodePtr
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
// string functions error epilog XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
int printLine() { int i; char c;
  prs("\n"); printhex16(PCStart);
  if (OpPrintIndex == 0) prs("                ");
  else {
    prc(PrReloc);
    i=0;
    do {
      c=OpPos[i];
      printhex8a(c); prc(' ');
      i++;
    } while(i < OpPrintIndex);
    do {// fill rest with blank
      prs("   ");
      i++;
    } while(i < OPMAXLEN);
  }
  prscomment(InputBuf);
}
int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
     al=c; writetty(); }
   fputcR(c,lst_fd); }

int prscomment(unsigned char *s) {unsigned char c;
  while(*s){c=*s;prc(c);s++;}
}
int prs(unsigned char *s) {unsigned char c; int com; com=0;
  while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
    if (c==92) { if (com==0) { s++; c=*s;
          if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
}
int printhex8a(unsigned int c) { unsigned int nib;
  nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
}
int printhex16(unsigned int i) {unsigned int half;
  half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
}
int printIntU(unsigned int n) { unsigned int e;
  if ( _ n >= 10) {  e=n/10; //DIV
    printIntU(e); }
    n = n % 10; //unsigned mod
    n += '0'; prc(n);
}
/*int printLineHex(unsigned char *s) { int L; char c;
  L = strlen(s);
  prs(" L:");
  printIntU(L);  
  if (L <= 0) return;
  if (L > 80) errorexit("Line > 80 char");
  while ( *s ) {
    c = *s;
    prc(' ');
    printhex8a(c);
    s++;
  }
} */
int error1(char *s) { LIST=1; ErrorCount++;
  prs("\n;***** next line ERROR: "); prs(s);
  prs(", Symbol: "); prs(Symbol);}
int allowederror(){error1("not allowed here"); }
int implmerror(){error1("not implemented");}
int indexerror (){error1("invalid index register");}
int numbererror(){error1("number expected");}  
int regmemerror(){error1("only register or memory allowed");}
int segregerror(){error1("segment register not allowed");}
int syntaxerror(){error1("syntax");}

int errorexit(char *s) { error1(s); end1(1);}
int addrexit(){errorexit("illegal addres");}
int internexit(){errorexit("intern compiler error");}

//int main() {getarg(); parse(); epilog(); end1();}//NB AS, AS TE
char *arglen=0x80; char *argv=0x82;
int getarg() { int arglen1; int i; char *c;
  arglen1=*arglen;
  if (arglen1==0) {
    cputs(Version1);
    cputs(", Usage: AS.COM filename [w/o .S] : ");
    exitR(3);
  }
  i=arglen1+129; *i=0;  arglen1--;
  toupper(argv);
  strcpy(namein, argv); strcat1(namein, ".S");
  strcpy(namelst,argv); strcat1(namelst,".LST");
  strcpy(namebin,argv); strcat1(namebin,".COM");

  LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  asm_fd=openR (namein);
  if(DOS_ERR){cputs("Source file missing: "); cputs(namein); exitR(1); }
  lst_fd=creatR(namelst);
  if(DOS_ERR){cputs("List file not creatable: ");cputs(namelst);exitR(2);}
  bin_fd=creatR(namebin);
  if(DOS_ERR){cputs("COM file not creatable: ");cputs(namebin);exitR(2);}
  prs(";");prs(Version1);
  prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  prs(", "); prs(namebin);
  prs("\n");
}
int epilog() { int i; int j; char c;
  prs("\n;END Errors: "); printIntU(ErrorCount);
  if (ErrorCount) prs(" ***ERROR*** ");
  prs(", Label & Var: ");
/*  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); prs(". >>");
  i= &LabelNames;
  do { c=*i; if (c==0) c=' '; prc(c); i++;
  } while (i < LabelNamePtr); prs("<< \n"); */
  if (LabelMaxIx) {
    i = 1;
    LabelNamePtr= &LabelNames;
    do {
      prs(LabelNamePtr); prc(' ');
 /*     j=LabelType[i]; //printIntU(j);
      if (j == 1) prc('L');
      if (j == 2) prc('V');
      prc('.'); */
      j=LabelAddr[i]; printhex16(j); prs(",  ");
      j=strlen(LabelNamePtr);//get end of act. name
      LabelNamePtr=LabelNamePtr+j;
      LabelNamePtr++;
      i++;
    } while (i <= LabelMaxIx);
  }
  prs("\n;COM file "); printIntU(BinLen); prs(" bytes:");
  i=0;
  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  } while (i < BinLen);
  i=0;
  do {
    c = FileBin[i];
    fputcR(c, bin_fd);
    i++;
  } while (i < BinLen);
}
int end1(int n) {fcloseR(asm_fd); fcloseR(lst_fd); fcloseR(bin_fd);exitR(n);
}
/*
Hierarchical software diagram, except string & DOS functions,  .=end
main:  getarg. parse epilog. end1.
parse: getLine. getToken storeLabel. searchLabel. lookCode. process
       getVariable printLine.
getToken: skipBlank. getDigit. getName.
process: genInstruction getToken testReg. genAddr16.
genInstruction: genCode8.
getVariable: storeLabel. getToken lookCode. skipBlank. isToken. genAddr16.
*/
