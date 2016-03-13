int printLine() { 
    int i; char c;
    prs("\n"); 
    printhex16(PCStart);
    if (OpPrintIndex == 0) prs("                ");
    else {
//        prc(' ');
        i=0;
        do {
            c=OpPos[i];
            prc(' ');
            printhex8a(c); 
            i++;
        } while (i < OpPrintIndex);
        while (i < OPMAXLEN) {// fill rest with blank
            prs("   ");
            i++;
        }
    }
    prc(PrintRA);
    prscomment(InputBuf);
}
int prc(unsigned char c) {//print char 
    if (LIST) { 
        if ( _ c==10) {
            ax=13; 
            writetty(); 
            }
        al=c; 
        writetty(); 
        }
    fputcR(c,lst_fd); 
}

int prscomment(unsigned char *s) {
    unsigned char c;
    while (*s){
        c=*s;
        prc(c);
        s++;
    }
}
int prs(unsigned char *s) {
    unsigned char c; 
    int com; 
    com=0;
    while (*s) { 
        c=*s; 
        if (c==34) {
            if (com) com=0; 
                else com=1;  
        }
        if (c==92) { 
            if (com==0) { 
                s++; 
                c=*s;
                if (c=='n') c=10; 
                if (c=='t') c= 9; 
            } 
        } 
        prc(c); 
        s++;  
    }
}
int printhex8a(unsigned char c) { 
    unsigned char nib;
    nib = c >> 4; printhex4(nib);                    
    nib = c & 15; printhex4(nib);                    
} 
int printhex4(unsigned char c) {
    c += 48; 
    if (c > 57) c += 7; 
    prc(c);      
}
int printhex16(unsigned int i) {
    unsigned int half;
    half = i >>  8; printhex8a(half); 
    half = i & 255; printhex8a(half);
}
int printIntU(unsigned int n) { 
    unsigned int e;
    if ( _ n >= 10) {  
        e=n/10; //DIV
        printIntU(e); 
    }
    n = n % 10; //unsigned mod
    n += '0'; 
    prc(n);
}

int error1(char *s) { 
    LIST=1; 
    ErrorCount++;
    prs("\n;***** next line ERROR: "); 
    prs(s);
    prs(", Symbol: "); 
    prs(Symbol);
}
int errorexit(char *s) { 
    error1(s); 
    end1(1);
}
int allowederror() {error1("not allowed here"); }
int addrerror()    {error1("address missing");} 
int immeerror()    {error1("immediate not allowed here");}
int implerror()    {error1("not implemented");}
int indexerror()   {error1("invalid index register");}
int invaloperror() {error1("invalid or no operands");}
int numbererror()  {error1("number expected");}
int regmemerror()  {error1("only register or memory allowed");}
int reg16error()   {error1("only reg16, no segreg allowed");}
int segregerror()  {error1("segment register not allowed");}
int syntaxerror()  {error1("syntax");}
         
int addrexit()     {errorexit("illegal address");}
int internexit()   {errorexit("intern compiler error");}
