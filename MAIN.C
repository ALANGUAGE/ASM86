int main() {
    getarg(); 
    parse(); 
    fixJmpCall();
    epilog(); 
    end1();
}

int getarg() { 
    int arglen1; int i; char *c;
    arglen1=*arglen;
    if (arglen1==0) {
        cputs(Version1);
        cputs(", Usage: AS.COM filename [w/o .S] : ");
        exitR(3);
    }
    i=arglen1+129; 
    *i=0;  
    arglen1--;
    toupper(argv);
  
    strcpy(namein, argv); strcat1(namein, ".S");
    strcpy(namelst,argv); strcat1(namelst,".LST");
    strcpy(namebin,argv); strcat1(namebin,".COM");

    LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  
    asm_fd=openR (namein);
    if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
    lst_fd=creatR(namelst);
    if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
    bin_fd=creatR(namebin);
    if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  
    prs(";"); 
    prs(Version1);
    prs(", Source: "); prs(namein);  
    prs(", Output: "); prs(namelst);
    prs(", "); prs(namebin);
    prs("\n");
}

int fixJmpCall() {
    int i;  unsigned int hex;  char *p; int Ix; char c;
    i=1;     
    prs("\n;END open jmp/call: "); 
    printIntU(JmpCallMaxIx);      
    p = &JmpCallNames;   
    while (i <= JmpCallMaxIx) {
        strcpy(Symbol, p);
        p = strlen(Symbol) + p;
        p++;
//        prs(Symbol);
//        prc(' ');  
        hex = JmpCallAddr[i];
//        printhex16(hex);
            
        Ix=searchLabel();
        if (Ix == 0) error1("Label not found");
        disp = LabelAddr[Ix];
        disp = disp - hex;
        disp = disp - Origin;
//        prs(", ");    
        
            hex = hex - 2;//fix at start of word              
            FileBin[hex] = disp;//fix low byte    
            hex++;
            disp = disp >> 8;
            FileBin[hex] = disp;            
        i++;
    }
}

int epilog() { 
    unsigned int i; char c;     int j;
    prs("\n Errors: "); 
    printIntU(ErrorCount);
    if (ErrorCount) prs(" ***ERROR*** ");
    prs(", Out: "); 
    prs(namelst);
    prs(", ");
    prs(namebin); 
    prs("= ");
    printIntU(BinLen); 
    prs(" bytes.");

    i=0;
    do {
        c = FileBin[i];
        fputcR(c, bin_fd);  
//printhex8a(c); prc(' ');      
        i++;
    } while (i < BinLen);

  prs("\ Labels: "); 
  printIntU(LabelMaxIx); 
  prs(". ");     
/*  prs("size: ");
  i= &LabelNames; i=LabelNamePtr-i; printIntU(i); 
  prs(". >>");
  i= &LabelNames;
  do { c=*i; if (c==0) c=' '; prc(c); i++;
  } while (i < LabelNamePtr); prs("<< \n");  */
/*    i = 1;
    LabelNamePtr= &LabelNames;
    do {
      prs(LabelNamePtr); prc(' ');
      j=LabelAddr[i]; printhex16(j); prs(", ");
      j=strlen(LabelNamePtr);//get end of actual name
      LabelNamePtr=LabelNamePtr+j;
      LabelNamePtr++;
      i++;
    } while (i <= LabelMaxIx);
*/
}

int end1(int n) {
    fcloseR(asm_fd);
    fcloseR(lst_fd);
    fcloseR(bin_fd);
    exitR(n);
}
