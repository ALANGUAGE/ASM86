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
