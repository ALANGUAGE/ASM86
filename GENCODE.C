// generate code
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
  if (BinLen >= FILEBINMAX) errorexit("COM file to long");
  if (OpPrintIndex < OPMAXLEN) {
    OpPos[OpPrintIndex]=c;
    OpPrintIndex++;
  }
}
int genCode16(unsigned int i) {
  genCode8(i); i=i >> 8;
  genCode8(i);
}
int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
//mod-byte: mode76, reg/opcode543, r/m210    
  char len;
  len=0;
  xxx = xxx << 3;//in reg/opcode field
//  prs("\nxxx:"); printhex8a(xxx);
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
