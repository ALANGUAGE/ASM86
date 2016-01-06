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
int letterE(char c) {
  if (c=='_') return 1;
  if (c=='.') return 1;
  if (c=='?') return 1;
  if (c=='$') return 1;
  if (c> 'z') return 0;
  if (c< '@') return 0; // at included
  if (c> 'Z') { if (c< 'a') return 0; }
  return 1;
}
int alnumE(char c) {
  if (digit(c)) return 1;
  if (letterE(c)) return 1;
  return 0;
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
  while (alnumE(c)) {
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
