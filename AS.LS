     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9122F                  jmp main
     5                                  
     6                                  ;-1 char Version1[]="AS.C V0.2";//BAS.BAT, AS TE, NAS.BAT
     7                                  
     8 00000003 41532E432056302E32-     Version1 db "AS.C V0.2",0
     9 0000000C 00                 
    10                                  
    11                                  ;-2 //#include "DECL.C"
    12                                  
    13                                  
    14                                  ;-3 #define SYMBOLMAX    31
    15                                  
    16                                  
    17                                  ;-4 char Symbol[SYMBOLMAX]; //next symbol to decode
    18                                  
    19                                  section .bss
    20                                  absolute 30000
    21 00007530 <res 0000001F>          Symbol resb 31
    22                                  section .text
    23                                  
    24                                  ;-5 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    25                                  
    26                                  section .bss
    27                                  absolute 30031
    28 0000754F <res 0000001F>          SymbolUpper resb 31
    29                                  section .text
    30                                  
    31                                  ;-6 char ProcName[SYMBOLMAX];//name of actual proc
    32                                  
    33                                  section .bss
    34                                  absolute 30062
    35 0000756E <res 0000001F>          ProcName resb 31
    36                                  section .text
    37                                  
    38                                  ;-7 char isInProc=0;        //is inside a procedure
    39                                  
    40 0000000D 00                      isInProc db 0
    41                                  
    42                                  ;-8 unsigned int SymbolInt; //integer value set in getDigit
    43                                  
    44 0000000E 0000                    SymbolInt dw 0
    45                                  
    46                                  ;-9 unsigned long SymbolLong;//integer value set in getDigit
    47                                  
    48 00000010 00000000                SymbolLong dd 0
    49                                  
    50                                  ;-10 #define INPUTBUFMAX 255
    51                                  
    52                                  
    53                                  ;-11 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    54                                  
    55                                  section .bss
    56                                  absolute 30093
    57 0000758D <res 000000FF>          InputBuf resb 255
    58                                  section .text
    59                                  
    60                                  ;-12 unsigned char *InputPtr;//position in InputBuf
    61                                  
    62 00000014 0000                    InputPtr dw 0
    63                                  
    64                                  ;-13 char namein [67];       //input file name  .S
    65                                  
    66                                  section .bss
    67                                  absolute 30348
    68 0000768C <res 00000043>          namein resb 67
    69                                  section .text
    70                                  
    71                                  ;-14 char namelst[67];       //list file name   .LST
    72                                  
    73                                  section .bss
    74                                  absolute 30415
    75 000076CF <res 00000043>          namelst resb 67
    76                                  section .text
    77                                  
    78                                  ;-15 char namebin[67];       //output file name .COM
    79                                  
    80                                  section .bss
    81                                  absolute 30482
    82 00007712 <res 00000043>          namebin resb 67
    83                                  section .text
    84                                  
    85                                  ;-16 int  asm_fd;            //input file descriptor
    86                                  
    87 00000016 0000                    asm_fd dw 0
    88                                  
    89                                  ;-17 int lst_fd;             //list file descriptor
    90                                  
    91 00000018 0000                    lst_fd dw 0
    92                                  
    93                                  ;-18 int bin_fd;             //output file descriptor
    94                                  
    95 0000001A 0000                    bin_fd dw 0
    96                                  
    97                                  ;-19 int DOS_ERR=0;          //global var
    98                                  
    99 0000001C 0000                    DOS_ERR dw 0
   100                                  
   101                                  ;-20 int ErrorCount=0;       //number of errors
   102                                  
   103 0000001E 0000                    ErrorCount dw 0
   104                                  
   105                                  ;-21 int DOS_NoBytes;        //number of bytes read (0 or 1)
   106                                  
   107 00000020 0000                    DOS_NoBytes dw 0
   108                                  
   109                                  ;-22 char DOS_ByteRead;      //the byte just read by DOS
   110                                  
   111 00000022 00                      DOS_ByteRead db 0
   112                                  
   113                                  ;-23 
   114                                  
   115                                  
   116                                  ;-24 unsigned int PC=0;      //program counter
   117                                  
   118 00000023 0000                    PC dw 0
   119                                  
   120                                  ;-25 unsigned int Origin=0;  //ORG nn
   121                                  
   122 00000025 0000                    Origin dw 0
   123                                  
   124                                  ;-26 unsigned int AbsoluteLab=0;//uninitialised data
   125                                  
   126 00000027 0000                    AbsoluteLab dw 0
   127                                  
   128                                  ;-27 unsigned int PCStart;   //PC at start of line by PrintLine()
   129                                  
   130 00000029 0000                    PCStart dw 0
   131                                  
   132                                  ;-28 char isLabel;           //by getName()
   133                                  
   134 0000002B 00                      isLabel db 0
   135                                  
   136                                  ;-29 #define DIGIT    1      //0-9
   137                                  
   138                                  
   139                                  ;-30 #define LETTERE  2      //a-z A-Z @ . _
   140                                  
   141                                  
   142                                  ;-31 #define ALNUME   3      //a-z A-Z @ . _  0-9
   143                                  
   144                                  
   145                                  ;-32 #define NOALNUME 4      //other char
   146                                  
   147                                  
   148                                  ;-33 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   149                                  
   150 0000002C 00                      TokeType db 0
   151                                  
   152                                  ;-34 #define BYTE     1
   153                                  
   154                                  
   155                                  ;-35 #define WORD     2
   156                                  
   157                                  
   158                                  ;-36 #define DWORD    3
   159                                  
   160                                  
   161                                  ;-37 #define SEGREG   4
   162                                  
   163                                  
   164                                  ;-38 #define IMM      1      //const  ,123
   165                                  
   166                                  
   167                                  ;-39 #define REG      2      //       ,BX    mode=11
   168                                  
   169                                  
   170                                  ;-40 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   171                                  
   172                                  
   173                                  ;-41 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   174                                  
   175                                  
   176                                  ;-42 char Op;                //1. operand: 0, IMM, REG, ADR, MEM
   177                                  
   178 0000002D 00                      Op db 0
   179                                  
   180                                  ;-43 char Op2;               //2. operand
   181                                  
   182 0000002E 00                      Op2 db 0
   183                                  
   184                                  ;-44 char CodeType;          //1-207 by searchSymbol(), must be byte size
   185                                  
   186 0000002F 00                      CodeType db 0
   187                                  
   188                                  ;-45 char Code1;             //1. Opcode
   189                                  
   190 00000030 00                      Code1 db 0
   191                                  
   192                                  ;-46 char Code2;             //2. Opcode
   193                                  
   194 00000031 00                      Code2 db 0
   195                                  
   196                                  ;-47 char Code3;             //3. Opcode
   197                                  
   198 00000032 00                      Code3 db 0
   199                                  
   200                                  ;-48 char R2No;              //0 - 7 AL, CL, ...  set in testReg()
   201                                  
   202 00000033 00                      R2No db 0
   203                                  
   204                                  ;-49 char R1No;              //temp for 1. register
   205                                  
   206 00000034 00                      R1No db 0
   207                                  
   208                                  ;-50 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   209                                  
   210 00000035 00                      R2Type db 0
   211                                  
   212                                  ;-51 char R1Type;            //temp for 1. register
   213                                  
   214 00000036 00                      R1Type db 0
   215                                  
   216                                  ;-52 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   217                                  
   218 00000037 00                      OpSize db 0
   219                                  
   220                                  ;-53 char wflag;             //wordflag: 0=byte, 1=word/dword
   221                                  
   222 00000038 00                      wflag db 0
   223                                  
   224                                  ;-54 char dflag;             //directionflag: 1=to reg MOV,ALU
   225                                  
   226 00000039 00                      dflag db 0
   227                                  
   228                                  ;-55 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3
   229                                  
   230 0000003A 00                      sflag db 0
   231                                  
   232                                  ;-56 char rm;                //combination of index and base reg
   233                                  
   234 0000003B 00                      rm db 0
   235                                  
   236                                  ;-57 char isDirect;          //set in process and getMeM, need in WriteEA
   237                                  
   238 0000003C 00                      isDirect db 0
   239                                  
   240                                  ;-58 int disp;               //displacement      0-8 bytes
   241                                  
   242 0000003D 0000                    disp dw 0
   243                                  
   244                                  ;-59 unsigned int imme;      //immediate         0-8 bytes
   245                                  
   246 0000003F 0000                    imme dw 0
   247                                  
   248                                  ;-60 
   249                                  
   250                                  
   251                                  ;-61 #define OPMAXLEN 5
   252                                  
   253                                  
   254                                  ;-62 char OpPos[OPMAXLEN];   //array for one opcode to list
   255                                  
   256                                  section .bss
   257                                  absolute 30549
   258 00007755 <res 00000005>          OpPos resb 5
   259                                  section .text
   260                                  
   261                                  ;-63 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   262                                  
   263 00000041 0000                    OpPrintIndex dw 0
   264                                  
   265                                  ;-64 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   266                                  
   267 00000043 0000                    OpCodePtr dw 0
   268                                  
   269                                  ;-65 char PrintRA;           //print * for forward relocative jmp
   270                                  
   271 00000045 00                      PrintRA db 0
   272                                  
   273                                  ;-66 
   274                                  
   275                                  
   276                                  ;-67 #define LABELNAMESMAX 5969//next number - SYMBOLMAX
   277                                  
   278                                  
   279                                  ;-68 char LabelNames[6000];  //space for names of all labels
   280                                  
   281                                  section .bss
   282                                  absolute 30554
   283 0000775A <res 00001770>          LabelNames resb 6000
   284                                  section .text
   285                                  
   286                                  ;-69 char *LabelNamePtr;     //first free position
   287                                  
   288 00000046 0000                    LabelNamePtr dw 0
   289                                  
   290                                  ;-70 char *tmpLabelNamePtr;  //set after PROC to LabelNamePtr
   291                                  
   292 00000048 0000                    tmpLabelNamePtr dw 0
   293                                  
   294                                  ;-71 
   295                                  
   296                                  
   297                                  ;-72 #define LABELADRMAX 600
   298                                  
   299                                  
   300                                  ;-73 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   301                                  
   302                                  section .bss
   303                                  absolute 36554
   304 00008ECA <res 000004B0>          LabelAddr resw 600
   305                                  section .text
   306                                  
   307                                  ;-74 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   308                                  
   309 0000004A 0000                    LabelMaxIx dw 0
   310                                  
   311                                  ;-75 int tmpLabelMaxIx;      //set after PROC to LabelMaxIx
   312                                  
   313 0000004C 0000                    tmpLabelMaxIx dw 0
   314                                  
   315                                  ;-76 int LabelIx;            //actual # of just searched label
   316                                  
   317 0000004E 0000                    LabelIx dw 0
   318                                  
   319                                  ;-77 
   320                                  
   321                                  
   322                                  ;-78 #define JMPNAMESMAX 3969//next number - SYMBOLMAX
   323                                  
   324                                  
   325                                  ;-79 char JmpNames[4000];    //space for names of jmp, call
   326                                  
   327                                  section .bss
   328                                  absolute 37754
   329 0000937A <res 00000FA0>          JmpNames resb 4000
   330                                  section .text
   331                                  
   332                                  ;-80 char *JmpNamePtr;       //first free position
   333                                  
   334 00000050 0000                    JmpNamePtr dw 0
   335                                  
   336                                  ;-81 char *tmpJmpNamePtr;    //set after PROC to JmpNamePtr
   337                                  
   338 00000052 0000                    tmpJmpNamePtr dw 0
   339                                  
   340                                  ;-82 
   341                                  
   342                                  
   343                                  ;-83 #define JMPMAX 200      //max. jmp and call
   344                                  
   345                                  
   346                                  ;-84 unsigned int JmpAddr[JMPMAX];//addr to be fixed
   347                                  
   348                                  section .bss
   349                                  absolute 41754
   350 0000A31A <res 00000190>          JmpAddr resw 200
   351                                  section .text
   352                                  
   353                                  ;-85 int JmpMaxIx=0;         //actual # of jmp, call. 1 to JMPMAX-1
   354                                  
   355 00000054 0000                    JmpMaxIx dw 0
   356                                  
   357                                  ;-86 int tmpJmpMaxIx=0;      //set after PROC to JmpMaxIx
   358                                  
   359 00000056 0000                    tmpJmpMaxIx dw 0
   360                                  
   361                                  ;-87 
   362                                  
   363                                  
   364                                  ;-88 #define FILEBINMAX 17000
   365                                  
   366                                  
   367                                  ;-89 char FileBin  [FILEBINMAX];//output binary file
   368                                  
   369                                  section .bss
   370                                  absolute 42154
   371 0000A4AA <res 00004268>          FileBin resb 17000
   372                                  section .text
   373                                  
   374                                  ;-90 unsigned int BinLen=0;  //length of binary file
   375                                  
   376 00000058 0000                    BinLen dw 0
   377                                  
   378                                  ;-91 
   379                                  
   380                                  
   381                                  ;-92 char *arglen=0x80;      // for main only
   382                                  
   383 0000005A 8000                    arglen dw 128
   384                                  
   385                                  ;-93 char *argv=0x82;        // for main only
   386                                  
   387 0000005C 8200                    argv dw 130
   388                                  
   389                                  ;-94 
   390                                  
   391                                  
   392                                  ;-95 
   393                                  
   394                                  
   395                                  ;-96 //#include "HELPER.C"
   396                                  
   397                                  
   398                                  ;-97 int writetty()     { ah=0x0E; bx=0; __emit__(0xCD,0x10); }
   399                                  
   400                                  
   401                                  writetty: PROC
   402 0000005E B40E                     mov  ah, 14
   403 00000060 BB0000                   mov  bx, 0
   404 00000063 CD10                     db 205,16
   405                                  
   406                                  ;-98 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
   407                                  
   408 00000065 C3                       ret
   409                                  ENDP
   410                                  
   411                                  putch: PROC
   412                                  ;Function : putch, Number of local variables: 1
   413                                  ;   # type sign width addr used name   list of local variables
   414                                  ;  200 var sign byte    98 NULL c = bp+4;
   415 00000066 C8000000                 ENTER  0,0 ; constant expression
   416 0000006A 807E040A                cmp byte[bp+4], 10
   417 0000006E 0F850500                 jne .putch1
   418 00000072 B00D                     mov  al, 13
   419 00000074 E8E7FF                   call writetty
   420                                  .putch1:
   421 00000077 8A4604                   mov  al, [bp+4]
   422 0000007A E8E1FF                   call writetty
   423                                  
   424                                  ;-99 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
   425 0000007D C9                       LEAVE
   426 0000007E C3                       ret
   427                                  ENDP
   428                                  
   429                                  cputs: PROC
   430                                  ;Function : cputs, Number of local variables: 2
   431                                  ;   # type sign width addr used name   list of local variables
   432                                  ;  200 ptr sign byte    99 NULL s = bp+4
   433                                  ;  201 var sign byte    99 NULL c = bp-2;
   434 0000007F C8020000                 ENTER  2,0
   435                                  .cputs2:
   436 00000083 8B5E04                   mov bx, [bp+4]
   437 00000086 8A07                     mov al, [bx]
   438 00000088 B400                     mov ah, 0
   439 0000008A 08C0                     or  al, al
   440 0000008C 0F841B00                 je .cputs3
   441 00000090 8B5E04                   mov bx, [bp+4]
   442 00000093 8A07                     mov al, [bx]
   443 00000095 B400                     mov ah, 0
   444 00000097 8846FE                   mov [bp-2], al
   445 0000009A 8A46FE                   mov al, byte [bp-2]
   446 0000009D B400                     mov ah, 0
   447 0000009F 50                       push ax
   448 000000A0 E8C3FF                   call putch
   449 000000A3 83C402                   add  sp, 2
   450 000000A6 FF4604                   inc  word[bp+4]
   451 000000A9 EBD8                     jmp .cputs2
   452                                  .cputs3:
   453                                  
   454                                  ;-100 
   455                                  
   456                                  
   457                                  ;-101 int DosInt() {
   458 000000AB C9                       LEAVE
   459 000000AC C3                       ret
   460                                  ENDP
   461                                  
   462                                  DosInt: PROC
   463                                  
   464                                  ;-102     __emit__(0xCD,0x21);//inth 0x21;
   465                                  
   466 000000AD CD21                     db 205,33
   467                                  
   468                                  ;-103     __emit__(0x73, 04); //ifcarry DOS_ERR++;
   469                                  
   470 000000AF 7304                     db 115,4
   471                                  
   472                                  ;-104     DOS_ERR++;
   473                                  
   474 000000B1 FF06[1C00]               inc  word[DOS_ERR]
   475                                  
   476                                  ;-105 }
   477                                  
   478                                  
   479                                  ;-106 int openR (char *s) { dx=s;       ax=0x3D02; DosInt(); }
   480                                  
   481 000000B5 C3                       ret
   482                                  ENDP
   483                                  
   484                                  openR: PROC
   485                                  ;Function : openR, Number of local variables: 1
   486                                  ;   # type sign width addr used name   list of local variables
   487                                  ;  200 ptr sign byte   106 NULL s = bp+4;
   488 000000B6 C8000000                 ENTER  0,0
   489 000000BA 8B5604                   mov  dx, [bp+4]
   490 000000BD B8023D                   mov  ax, 15618
   491 000000C0 E8EAFF                   call DosInt
   492                                  
   493                                  ;-107 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
   494 000000C3 C9                       LEAVE
   495 000000C4 C3                       ret
   496                                  ENDP
   497                                  
   498                                  creatR: PROC
   499                                  ;Function : creatR, Number of local variables: 1
   500                                  ;   # type sign width addr used name   list of local variables
   501                                  ;  200 ptr sign byte   107 NULL s = bp+4;
   502 000000C5 C8000000                 ENTER  0,0
   503 000000C9 8B5604                   mov  dx, [bp+4]
   504 000000CC B90000                   mov  cx, 0
   505 000000CF B8003C                   mov  ax, 15360
   506 000000D2 E8D8FF                   call DosInt
   507                                  
   508                                  ;-108 int fcloseR(int fd) {bx=fd;       ax=0x3E00; DosInt(); }
   509 000000D5 C9                       LEAVE
   510 000000D6 C3                       ret
   511                                  ENDP
   512                                  
   513                                  fcloseR: PROC
   514                                  ;Function : fcloseR, Number of local variables: 1
   515                                  ;   # type sign width addr used name   list of local variables
   516                                  ;  200 var sign word   108 NULL fd = bp+4;
   517 000000D7 C8000000                 ENTER  0,0
   518 000000DB 8B5E04                   mov  bx, [bp+4]
   519 000000DE B8003E                   mov  ax, 15872
   520 000000E1 E8C9FF                   call DosInt
   521                                  
   522                                  ;-109 int exitR  (char c) {ah=0x4C; al=c;          DosInt(); }
   523 000000E4 C9                       LEAVE
   524 000000E5 C3                       ret
   525                                  ENDP
   526                                  
   527                                  exitR: PROC
   528                                  ;Function : exitR, Number of local variables: 1
   529                                  ;   # type sign width addr used name   list of local variables
   530                                  ;  200 var sign byte   109 NULL c = bp+4;
   531 000000E6 C8000000                 ENTER  0,0
   532 000000EA B44C                     mov  ah, 76
   533 000000EC 8A4604                   mov  al, [bp+4]
   534 000000EF E8BBFF                   call DosInt
   535                                  
   536                                  ;-110 int readRL(char *s, int fd, int len){
   537 000000F2 C9                       LEAVE
   538 000000F3 C3                       ret
   539                                  ENDP
   540                                  
   541                                  readRL: PROC
   542                                  
   543                                  ;-111     dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
   544                                  
   545                                  ;Function : readRL, Number of local variables: 3
   546                                  ;   # type sign width addr used name   list of local variables
   547                                  ;  200 ptr sign byte   110 NULL s = bp+4
   548                                  ;  201 var sign word   110 NULL fd = bp+6
   549                                  ;  202 var sign word   110 NULL len = bp+8;
   550 000000F4 C8000000                 ENTER  0,0
   551 000000F8 8B5604                   mov  dx, [bp+4]
   552 000000FB 8B4E08                   mov  cx, [bp+8]
   553 000000FE 8B5E06                   mov  bx, [bp+6]
   554 00000101 B8003F                   mov  ax, 16128
   555 00000104 E8A6FF                   call DosInt
   556                                  
   557                                  ;-112 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
   558 00000107 C9                       LEAVE
   559 00000108 C3                       ret
   560                                  ENDP
   561                                  
   562                                  fputcR: PROC
   563                                  ;Function : fputcR, Number of local variables: 2
   564                                  ;   # type sign width addr used name   list of local variables
   565                                  ;  200 ptr sign byte   112 NULL n = bp+4
   566                                  ;  201 var sign word   112 NULL fd = bp+6;
   567 00000109 C8000000                 ENTER  0,0
   568 0000010D 8D5604                  lea dx, [bp+4]
   569                                  
   570                                  ;-113   cx=1; bx=fd; ax=0x4000; DosInt(); }
   571                                  
   572 00000110 B90100                   mov  cx, 1
   573 00000113 8B5E06                   mov  bx, [bp+6]
   574 00000116 B80040                   mov  ax, 16384
   575 00000119 E891FF                   call DosInt
   576                                  
   577                                  ;-114 
   578                                  
   579                                  
   580                                  ;-115 int letterE(char c) {
   581 0000011C C9                       LEAVE
   582 0000011D C3                       ret
   583                                  ENDP
   584                                  
   585                                  letterE: PROC
   586                                  
   587                                  ;-116   if (c=='_') return 1;
   588                                  
   589                                  ;Function : letterE, Number of local variables: 1
   590                                  ;   # type sign width addr used name   list of local variables
   591                                  ;  200 var sign byte   115 NULL c = bp+4;
   592 0000011E C8000000                 ENTER  0,0
   593 00000122 8A4604                   mov al, [bp+4]
   594 00000125 3C5F                     cmp al, 95
   595 00000127 0F850600                 jne .letterE4
   596 0000012B B80100                   mov ax, 1
   597 0000012E E96900                   jmp .retnletterE
   598                                  
   599                                  ;-117   if (c=='.') return 1;
   600                                  
   601                                  .letterE4:
   602 00000131 8A4604                   mov al, [bp+4]
   603 00000134 3C2E                     cmp al, 46
   604 00000136 0F850600                 jne .letterE5
   605 0000013A B80100                   mov ax, 1
   606 0000013D E95A00                   jmp .retnletterE
   607                                  
   608                                  ;-118   if (c=='?') return 1;
   609                                  
   610                                  .letterE5:
   611 00000140 8A4604                   mov al, [bp+4]
   612 00000143 3C3F                     cmp al, 63
   613 00000145 0F850600                 jne .letterE6
   614 00000149 B80100                   mov ax, 1
   615 0000014C E94B00                   jmp .retnletterE
   616                                  
   617                                  ;-119   if (c=='$') return 1;
   618                                  
   619                                  .letterE6:
   620 0000014F 8A4604                   mov al, [bp+4]
   621 00000152 3C24                     cmp al, 36
   622 00000154 0F850600                 jne .letterE7
   623 00000158 B80100                   mov ax, 1
   624 0000015B E93C00                   jmp .retnletterE
   625                                  
   626                                  ;-120   if (c> 'z') return 0;
   627                                  
   628                                  .letterE7:
   629 0000015E 8A4604                   mov al, [bp+4]
   630 00000161 3C7A                     cmp al, 122
   631 00000163 0F8E0600                 jle .letterE8
   632 00000167 B80000                   mov ax, 0
   633 0000016A E92D00                   jmp .retnletterE
   634                                  
   635                                  ;-121   if (c< '@') return 0; // at included
   636                                  
   637                                  .letterE8:
   638 0000016D 8A4604                   mov al, [bp+4]
   639 00000170 3C40                     cmp al, 64
   640 00000172 0F8D0600                 jge .letterE9
   641 00000176 B80000                   mov ax, 0
   642 00000179 E91E00                   jmp .retnletterE
   643                                  
   644                                  ;-122   if (c> 'Z') { if (c< 'a') return 0; }
   645                                  
   646                                  .letterE9:
   647 0000017C 8A4604                   mov al, [bp+4]
   648 0000017F 3C5A                     cmp al, 90
   649 00000181 0F8E0F00                 jle .letterE10
   650 00000185 8A4604                   mov al, [bp+4]
   651 00000188 3C61                     cmp al, 97
   652 0000018A 0F8D0600                 jge .letterE11
   653 0000018E B80000                   mov ax, 0
   654 00000191 E90600                   jmp .retnletterE
   655                                  .letterE11:
   656                                  
   657                                  ;-123   return 1;
   658                                  
   659                                  .letterE10:
   660 00000194 B80100                   mov ax, 1
   661 00000197 E90000                   jmp .retnletterE
   662                                  
   663                                  ;-124 }
   664                                  
   665                                  
   666                                  ;-125 int digit(char c){
   667                                  
   668 0000019A C9                       .retnletterE: LEAVE
   669 0000019B C3                       ret
   670                                  ENDP
   671                                  
   672                                  digit: PROC
   673                                  
   674                                  ;-126     if(c<'0') return 0;
   675                                  
   676                                  ;Function : digit, Number of local variables: 1
   677                                  ;   # type sign width addr used name   list of local variables
   678                                  ;  200 var sign byte   125 NULL c = bp+4;
   679 0000019C C8000000                 ENTER  0,0
   680 000001A0 8A4604                   mov al, [bp+4]
   681 000001A3 3C30                     cmp al, 48
   682 000001A5 0F8D0600                 jge .digit12
   683 000001A9 B80000                   mov ax, 0
   684 000001AC E91500                   jmp .retndigit
   685                                  
   686                                  ;-127     if(c>'9') return 0;
   687                                  
   688                                  .digit12:
   689 000001AF 8A4604                   mov al, [bp+4]
   690 000001B2 3C39                     cmp al, 57
   691 000001B4 0F8E0600                 jle .digit13
   692 000001B8 B80000                   mov ax, 0
   693 000001BB E90600                   jmp .retndigit
   694                                  
   695                                  ;-128     return 1;
   696                                  
   697                                  .digit13:
   698 000001BE B80100                   mov ax, 1
   699 000001C1 E90000                   jmp .retndigit
   700                                  
   701                                  ;-129 }
   702                                  
   703                                  
   704                                  ;-130 int alnumE(char c) {
   705                                  
   706 000001C4 C9                       .retndigit: LEAVE
   707 000001C5 C3                       ret
   708                                  ENDP
   709                                  
   710                                  alnumE: PROC
   711                                  
   712                                  ;-131   if (digit(c)) return 1;
   713                                  
   714                                  ;Function : alnumE, Number of local variables: 1
   715                                  ;   # type sign width addr used name   list of local variables
   716                                  ;  200 var sign byte   130 NULL c = bp+4;
   717 000001C6 C8000000                 ENTER  0,0
   718 000001CA 8A4604                   mov al, byte [bp+4]
   719 000001CD B400                     mov ah, 0
   720 000001CF 50                       push ax
   721 000001D0 E8C9FF                   call digit
   722 000001D3 83C402                   add  sp, 2
   723 000001D6 08C0                     or  al, al
   724 000001D8 0F840600                 je .alnumE14
   725 000001DC B80100                   mov ax, 1
   726 000001DF E91E00                   jmp .retnalnumE
   727                                  
   728                                  ;-132   if (letterE(c)) return 1;
   729                                  
   730                                  .alnumE14:
   731 000001E2 8A4604                   mov al, byte [bp+4]
   732 000001E5 B400                     mov ah, 0
   733 000001E7 50                       push ax
   734 000001E8 E833FF                   call letterE
   735 000001EB 83C402                   add  sp, 2
   736 000001EE 08C0                     or  al, al
   737 000001F0 0F840600                 je .alnumE15
   738 000001F4 B80100                   mov ax, 1
   739 000001F7 E90600                   jmp .retnalnumE
   740                                  
   741                                  ;-133   return 0;
   742                                  
   743                                  .alnumE15:
   744 000001FA B80000                   mov ax, 0
   745 000001FD E90000                   jmp .retnalnumE
   746                                  
   747                                  ;-134 }
   748                                  
   749                                  
   750                                  ;-135 int strlen(char *s) { int c;
   751                                  
   752 00000200 C9                       .retnalnumE: LEAVE
   753 00000201 C3                       ret
   754                                  ENDP
   755                                  
   756                                  strlen: PROC
   757                                  
   758                                  ;-136     c=0;
   759                                  
   760                                  ;Function : strlen, Number of local variables: 2
   761                                  ;   # type sign width addr used name   list of local variables
   762                                  ;  200 ptr sign byte   135 NULL s = bp+4
   763                                  ;  201 var sign word   135 NULL c = bp-2;
   764 00000202 C8020000                 ENTER  2,0
   765 00000206 B80000                   mov ax, 0
   766 00000209 8946FE                   mov [bp-2], ax
   767                                  
   768                                  ;-137     while (*s!=0) {s++; c++;}
   769                                  
   770                                  .strlen16:
   771 0000020C 8B5E04                   mov bx, [bp+4]
   772 0000020F 8A07                     mov al, [bx]
   773 00000211 B400                     mov ah, 0
   774 00000213 83F800                   cmp ax, 0
   775 00000216 0F840800                 je  .strlen17
   776 0000021A FF4604                   inc  word[bp+4]
   777 0000021D FF46FE                   inc  word[bp-2]
   778                                  
   779                                  ;-138     return c;
   780                                  
   781 00000220 EBEA                     jmp .strlen16
   782                                  .strlen17:
   783 00000222 8B46FE                   mov ax, [bp-2]
   784 00000225 E90000                   jmp .retnstrlen
   785                                  
   786                                  ;-139     }
   787                                  
   788                                  
   789                                  ;-140 int strcpy(char *s, char *t) {
   790                                  
   791 00000228 C9                       .retnstrlen: LEAVE
   792 00000229 C3                       ret
   793                                  ENDP
   794                                  
   795                                  strcpy: PROC
   796                                  
   797                                  ;-141     do { *s=*t; s++; t++; }
   798                                  
   799                                  ;Function : strcpy, Number of local variables: 2
   800                                  ;   # type sign width addr used name   list of local variables
   801                                  ;  200 ptr sign byte   140 NULL s = bp+4
   802                                  ;  201 ptr sign byte   140 NULL t = bp+6;
   803 0000022A C8000000                 ENTER  0,0
   804                                  .strcpy18:
   805 0000022E 8B5E06                   mov bx, [bp+6]
   806 00000231 8A07                     mov al, [bx]
   807 00000233 B400                     mov ah, 0
   808 00000235 8B5E04                   mov  bx, [bp+4]
   809 00000238 8807                     mov  [bx], al
   810 0000023A FF4604                   inc  word[bp+4]
   811 0000023D FF4606                   inc  word[bp+6]
   812                                  
   813                                  ;-142     while (*t!=0);
   814                                  
   815 00000240 8B5E06                   mov bx, [bp+6]
   816 00000243 8A07                     mov al, [bx]
   817 00000245 B400                     mov ah, 0
   818 00000247 83F800                   cmp ax, 0
   819 0000024A 0F840200                 je  .strcpy19
   820 0000024E EBDE                     jmp .strcpy18
   821                                  .strcpy19:
   822                                  
   823                                  ;-143     *s=0;
   824                                  
   825 00000250 B80000                   mov ax, 0
   826 00000253 8B5E04                   mov  bx, [bp+4]
   827 00000256 8807                     mov  [bx], al
   828                                  
   829                                  ;-144     return s;
   830                                  
   831 00000258 8B4604                   mov ax, [bp+4]
   832 0000025B E90000                   jmp .retnstrcpy
   833                                  
   834                                  ;-145     }
   835                                  
   836                                  
   837                                  ;-146 int eqstr(char *p, char *q) {
   838                                  
   839 0000025E C9                       .retnstrcpy: LEAVE
   840 0000025F C3                       ret
   841                                  ENDP
   842                                  
   843                                  eqstr: PROC
   844                                  
   845                                  ;-147     while(*p) {
   846                                  
   847                                  ;Function : eqstr, Number of local variables: 2
   848                                  ;   # type sign width addr used name   list of local variables
   849                                  ;  200 ptr sign byte   146 NULL p = bp+4
   850                                  ;  201 ptr sign byte   146 NULL q = bp+6;
   851 00000260 C8000000                 ENTER  0,0
   852                                  .eqstr20:
   853 00000264 8B5E04                   mov bx, [bp+4]
   854 00000267 8A07                     mov al, [bx]
   855 00000269 B400                     mov ah, 0
   856 0000026B 08C0                     or  al, al
   857 0000026D 0F842000                 je .eqstr21
   858                                  
   859                                  ;-148         if (*p != *q) return 0;
   860                                  
   861 00000271 8B5E04                   mov bx, [bp+4]
   862 00000274 8A07                     mov al, [bx]
   863 00000276 B400                     mov ah, 0
   864 00000278 8B5E06                   mov bx, [bp+6]
   865 0000027B 3A07                     cmp al, [bx]
   866 0000027D B400                     mov ah, 0
   867 0000027F 0F840600                 je  .eqstr22
   868 00000283 B80000                   mov ax, 0
   869 00000286 E92100                   jmp .retneqstr
   870                                  
   871                                  ;-149             p++;
   872                                  
   873                                  .eqstr22:
   874 00000289 FF4604                   inc  word[bp+4]
   875                                  
   876                                  ;-150             q++;
   877                                  
   878 0000028C FF4606                   inc  word[bp+6]
   879                                  
   880                                  ;-151             }
   881                                  
   882                                  
   883                                  ;-152     if(*q) return 0;
   884                                  
   885 0000028F EBD3                     jmp .eqstr20
   886                                  .eqstr21:
   887 00000291 8B5E06                   mov bx, [bp+6]
   888 00000294 8A07                     mov al, [bx]
   889 00000296 B400                     mov ah, 0
   890 00000298 08C0                     or  al, al
   891 0000029A 0F840600                 je .eqstr23
   892 0000029E B80000                   mov ax, 0
   893 000002A1 E90600                   jmp .retneqstr
   894                                  
   895                                  ;-153     return 1;
   896                                  
   897                                  .eqstr23:
   898 000002A4 B80100                   mov ax, 1
   899 000002A7 E90000                   jmp .retneqstr
   900                                  
   901                                  ;-154     }
   902                                  
   903                                  
   904                                  ;-155 int strcat1(char *s, char *t) {
   905                                  
   906 000002AA C9                       .retneqstr: LEAVE
   907 000002AB C3                       ret
   908                                  ENDP
   909                                  
   910                                  strcat1: PROC
   911                                  
   912                                  ;-156     while (*s != 0) s++;
   913                                  
   914                                  ;Function : strcat1, Number of local variables: 2
   915                                  ;   # type sign width addr used name   list of local variables
   916                                  ;  200 ptr sign byte   155 NULL s = bp+4
   917                                  ;  201 ptr sign byte   155 NULL t = bp+6;
   918 000002AC C8000000                 ENTER  0,0
   919                                  .strcat124:
   920 000002B0 8B5E04                   mov bx, [bp+4]
   921 000002B3 8A07                     mov al, [bx]
   922 000002B5 B400                     mov ah, 0
   923 000002B7 83F800                   cmp ax, 0
   924 000002BA 0F840500                 je  .strcat125
   925 000002BE FF4604                   inc  word[bp+4]
   926                                  
   927                                  ;-157     strcpy(s, t);
   928                                  
   929 000002C1 EBED                     jmp .strcat124
   930                                  .strcat125:
   931 000002C3 FF7606                   push word [bp+6]
   932 000002C6 FF7604                   push word [bp+4]
   933 000002C9 E85EFF                   call strcpy
   934 000002CC 83C404                   add  sp, 4
   935                                  
   936                                  ;-158     }
   937                                  
   938                                  
   939                                  ;-159 int toupper(char *s) {
   940 000002CF C9                       LEAVE
   941 000002D0 C3                       ret
   942                                  ENDP
   943                                  
   944                                  toupper: PROC
   945                                  
   946                                  ;-160     while(*s) {
   947                                  
   948                                  ;Function : toupper, Number of local variables: 1
   949                                  ;   # type sign width addr used name   list of local variables
   950                                  ;  200 ptr sign byte   159 NULL s = bp+4;
   951 000002D1 C8000000                 ENTER  0,0
   952                                  .toupper26:
   953 000002D5 8B5E04                   mov bx, [bp+4]
   954 000002D8 8A07                     mov al, [bx]
   955 000002DA B400                     mov ah, 0
   956 000002DC 08C0                     or  al, al
   957 000002DE 0F843000                 je .toupper27
   958                                  
   959                                  ;-161         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
   960                                  
   961 000002E2 8B5E04                   mov bx, [bp+4]
   962 000002E5 8A07                     mov al, [bx]
   963 000002E7 B400                     mov ah, 0
   964 000002E9 83F861                   cmp ax, 97 ;unsigned : 1
   965 000002EC 0F8C1D00                 jl  .toupper28
   966 000002F0 8B5E04                   mov bx, [bp+4]
   967 000002F3 8A07                     mov al, [bx]
   968 000002F5 B400                     mov ah, 0
   969 000002F7 83F87A                   cmp ax, 122
   970 000002FA 0F8F0F00                 jg  .toupper29
   971 000002FE 8B5E04                   mov bx, [bp+4]
   972 00000301 8A07                     mov al, [bx]
   973 00000303 B400                     mov ah, 0
   974 00000305 83E820                   sub ax, 32
   975 00000308 8B5E04                   mov  bx, [bp+4]
   976 0000030B 8807                     mov  [bx], al
   977                                  
   978                                  ;-162             s++;
   979                                  
   980                                  .toupper29:
   981                                  .toupper28:
   982 0000030D FF4604                   inc  word[bp+4]
   983                                  
   984                                  ;-163               }
   985                                  
   986                                  
   987                                  ;-164     }
   988                                  
   989 00000310 EBC3                     jmp .toupper26
   990                                  .toupper27:
   991                                  
   992                                  ;-165 
   993                                  
   994                                  
   995                                  ;-166 int testReg() {
   996 00000312 C9                       LEAVE
   997 00000313 C3                       ret
   998                                  ENDP
   999                                  
  1000                                  testReg: PROC
  1001                                  
  1002                                  ;-167 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  1003                                  
  1004                                  
  1005                                  ;-168   R2Type=0;
  1006                                  
  1007 00000314 B80000                   mov ax, 0
  1008 00000317 A2[3500]                 mov byte [R2Type], al
  1009                                  
  1010                                  ;-169   if (strlen(Symbol) < 2) return 0;
  1011                                  
  1012 0000031A 8D063075                 lea  ax, [Symbol]
  1013 0000031E 50                       push ax
  1014 0000031F E8E0FE                   call strlen
  1015 00000322 83C402                   add  sp, 2
  1016 00000325 3C02                     cmp al, 2
  1017 00000327 0F8D0600                 jge .testReg30
  1018 0000032B B80000                   mov ax, 0
  1019 0000032E E94703                   jmp .retntestReg
  1020                                  
  1021                                  ;-170   if (strlen(Symbol) > 3) return 0;
  1022                                  
  1023                                  .testReg30:
  1024 00000331 8D063075                 lea  ax, [Symbol]
  1025 00000335 50                       push ax
  1026 00000336 E8C9FE                   call strlen
  1027 00000339 83C402                   add  sp, 2
  1028 0000033C 3C03                     cmp al, 3
  1029 0000033E 0F8E0600                 jle .testReg31
  1030 00000342 B80000                   mov ax, 0
  1031 00000345 E93003                   jmp .retntestReg
  1032                                  
  1033                                  ;-171   R2Type=BYTE;
  1034                                  
  1035                                  .testReg31:
  1036 00000348 B80100                   mov ax, 1
  1037 0000034B A2[3500]                 mov byte [R2Type], al
  1038                                  
  1039                                  ;-172   if (eqstr(SymbolUpper, "AL")) return 0;
  1040                                  
  1041 0000034E 68[7906]                 push testReg_0
  1042 00000351 8D064F75                 lea  ax, [SymbolUpper]
  1043 00000355 50                       push ax
  1044 00000356 E807FF                   call eqstr
  1045 00000359 83C404                   add  sp, 4
  1046 0000035C 08C0                     or  al, al
  1047 0000035E 0F840600                 je .testReg32
  1048 00000362 B80000                   mov ax, 0
  1049 00000365 E91003                   jmp .retntestReg
  1050                                  
  1051                                  ;-173   if (eqstr(SymbolUpper, "CL")) return 1;
  1052                                  
  1053                                  .testReg32:
  1054 00000368 68[7C06]                 push testReg_1
  1055 0000036B 8D064F75                 lea  ax, [SymbolUpper]
  1056 0000036F 50                       push ax
  1057 00000370 E8EDFE                   call eqstr
  1058 00000373 83C404                   add  sp, 4
  1059 00000376 08C0                     or  al, al
  1060 00000378 0F840600                 je .testReg33
  1061 0000037C B80100                   mov ax, 1
  1062 0000037F E9F602                   jmp .retntestReg
  1063                                  
  1064                                  ;-174   if (eqstr(SymbolUpper, "DL")) return 2;
  1065                                  
  1066                                  .testReg33:
  1067 00000382 68[7F06]                 push testReg_2
  1068 00000385 8D064F75                 lea  ax, [SymbolUpper]
  1069 00000389 50                       push ax
  1070 0000038A E8D3FE                   call eqstr
  1071 0000038D 83C404                   add  sp, 4
  1072 00000390 08C0                     or  al, al
  1073 00000392 0F840600                 je .testReg34
  1074 00000396 B80200                   mov ax, 2
  1075 00000399 E9DC02                   jmp .retntestReg
  1076                                  
  1077                                  ;-175   if (eqstr(SymbolUpper, "BL")) return 3;
  1078                                  
  1079                                  .testReg34:
  1080 0000039C 68[8206]                 push testReg_3
  1081 0000039F 8D064F75                 lea  ax, [SymbolUpper]
  1082 000003A3 50                       push ax
  1083 000003A4 E8B9FE                   call eqstr
  1084 000003A7 83C404                   add  sp, 4
  1085 000003AA 08C0                     or  al, al
  1086 000003AC 0F840600                 je .testReg35
  1087 000003B0 B80300                   mov ax, 3
  1088 000003B3 E9C202                   jmp .retntestReg
  1089                                  
  1090                                  ;-176   if (eqstr(SymbolUpper, "AH")) return 4;
  1091                                  
  1092                                  .testReg35:
  1093 000003B6 68[8506]                 push testReg_4
  1094 000003B9 8D064F75                 lea  ax, [SymbolUpper]
  1095 000003BD 50                       push ax
  1096 000003BE E89FFE                   call eqstr
  1097 000003C1 83C404                   add  sp, 4
  1098 000003C4 08C0                     or  al, al
  1099 000003C6 0F840600                 je .testReg36
  1100 000003CA B80400                   mov ax, 4
  1101 000003CD E9A802                   jmp .retntestReg
  1102                                  
  1103                                  ;-177   if (eqstr(SymbolUpper, "CH")) return 5;
  1104                                  
  1105                                  .testReg36:
  1106 000003D0 68[8806]                 push testReg_5
  1107 000003D3 8D064F75                 lea  ax, [SymbolUpper]
  1108 000003D7 50                       push ax
  1109 000003D8 E885FE                   call eqstr
  1110 000003DB 83C404                   add  sp, 4
  1111 000003DE 08C0                     or  al, al
  1112 000003E0 0F840600                 je .testReg37
  1113 000003E4 B80500                   mov ax, 5
  1114 000003E7 E98E02                   jmp .retntestReg
  1115                                  
  1116                                  ;-178   if (eqstr(SymbolUpper, "DH")) return 6;
  1117                                  
  1118                                  .testReg37:
  1119 000003EA 68[8B06]                 push testReg_6
  1120 000003ED 8D064F75                 lea  ax, [SymbolUpper]
  1121 000003F1 50                       push ax
  1122 000003F2 E86BFE                   call eqstr
  1123 000003F5 83C404                   add  sp, 4
  1124 000003F8 08C0                     or  al, al
  1125 000003FA 0F840600                 je .testReg38
  1126 000003FE B80600                   mov ax, 6
  1127 00000401 E97402                   jmp .retntestReg
  1128                                  
  1129                                  ;-179   if (eqstr(SymbolUpper, "BH")) return 7;
  1130                                  
  1131                                  .testReg38:
  1132 00000404 68[8E06]                 push testReg_7
  1133 00000407 8D064F75                 lea  ax, [SymbolUpper]
  1134 0000040B 50                       push ax
  1135 0000040C E851FE                   call eqstr
  1136 0000040F 83C404                   add  sp, 4
  1137 00000412 08C0                     or  al, al
  1138 00000414 0F840600                 je .testReg39
  1139 00000418 B80700                   mov ax, 7
  1140 0000041B E95A02                   jmp .retntestReg
  1141                                  
  1142                                  ;-180   R2Type=WORD;
  1143                                  
  1144                                  .testReg39:
  1145 0000041E B80200                   mov ax, 2
  1146 00000421 A2[3500]                 mov byte [R2Type], al
  1147                                  
  1148                                  ;-181   if (eqstr(SymbolUpper, "AX")) return 0;
  1149                                  
  1150 00000424 68[9106]                 push testReg_8
  1151 00000427 8D064F75                 lea  ax, [SymbolUpper]
  1152 0000042B 50                       push ax
  1153 0000042C E831FE                   call eqstr
  1154 0000042F 83C404                   add  sp, 4
  1155 00000432 08C0                     or  al, al
  1156 00000434 0F840600                 je .testReg40
  1157 00000438 B80000                   mov ax, 0
  1158 0000043B E93A02                   jmp .retntestReg
  1159                                  
  1160                                  ;-182   if (eqstr(SymbolUpper, "CX")) return 1;
  1161                                  
  1162                                  .testReg40:
  1163 0000043E 68[9406]                 push testReg_9
  1164 00000441 8D064F75                 lea  ax, [SymbolUpper]
  1165 00000445 50                       push ax
  1166 00000446 E817FE                   call eqstr
  1167 00000449 83C404                   add  sp, 4
  1168 0000044C 08C0                     or  al, al
  1169 0000044E 0F840600                 je .testReg41
  1170 00000452 B80100                   mov ax, 1
  1171 00000455 E92002                   jmp .retntestReg
  1172                                  
  1173                                  ;-183   if (eqstr(SymbolUpper, "DX")) return 2;
  1174                                  
  1175                                  .testReg41:
  1176 00000458 68[9706]                 push testReg_10
  1177 0000045B 8D064F75                 lea  ax, [SymbolUpper]
  1178 0000045F 50                       push ax
  1179 00000460 E8FDFD                   call eqstr
  1180 00000463 83C404                   add  sp, 4
  1181 00000466 08C0                     or  al, al
  1182 00000468 0F840600                 je .testReg42
  1183 0000046C B80200                   mov ax, 2
  1184 0000046F E90602                   jmp .retntestReg
  1185                                  
  1186                                  ;-184   if (eqstr(SymbolUpper, "BX")) return 3;
  1187                                  
  1188                                  .testReg42:
  1189 00000472 68[9A06]                 push testReg_11
  1190 00000475 8D064F75                 lea  ax, [SymbolUpper]
  1191 00000479 50                       push ax
  1192 0000047A E8E3FD                   call eqstr
  1193 0000047D 83C404                   add  sp, 4
  1194 00000480 08C0                     or  al, al
  1195 00000482 0F840600                 je .testReg43
  1196 00000486 B80300                   mov ax, 3
  1197 00000489 E9EC01                   jmp .retntestReg
  1198                                  
  1199                                  ;-185   if (eqstr(SymbolUpper, "SP")) return 4;
  1200                                  
  1201                                  .testReg43:
  1202 0000048C 68[9D06]                 push testReg_12
  1203 0000048F 8D064F75                 lea  ax, [SymbolUpper]
  1204 00000493 50                       push ax
  1205 00000494 E8C9FD                   call eqstr
  1206 00000497 83C404                   add  sp, 4
  1207 0000049A 08C0                     or  al, al
  1208 0000049C 0F840600                 je .testReg44
  1209 000004A0 B80400                   mov ax, 4
  1210 000004A3 E9D201                   jmp .retntestReg
  1211                                  
  1212                                  ;-186   if (eqstr(SymbolUpper, "BP")) return 5;
  1213                                  
  1214                                  .testReg44:
  1215 000004A6 68[A006]                 push testReg_13
  1216 000004A9 8D064F75                 lea  ax, [SymbolUpper]
  1217 000004AD 50                       push ax
  1218 000004AE E8AFFD                   call eqstr
  1219 000004B1 83C404                   add  sp, 4
  1220 000004B4 08C0                     or  al, al
  1221 000004B6 0F840600                 je .testReg45
  1222 000004BA B80500                   mov ax, 5
  1223 000004BD E9B801                   jmp .retntestReg
  1224                                  
  1225                                  ;-187   if (eqstr(SymbolUpper, "SI")) return 6;
  1226                                  
  1227                                  .testReg45:
  1228 000004C0 68[A306]                 push testReg_14
  1229 000004C3 8D064F75                 lea  ax, [SymbolUpper]
  1230 000004C7 50                       push ax
  1231 000004C8 E895FD                   call eqstr
  1232 000004CB 83C404                   add  sp, 4
  1233 000004CE 08C0                     or  al, al
  1234 000004D0 0F840600                 je .testReg46
  1235 000004D4 B80600                   mov ax, 6
  1236 000004D7 E99E01                   jmp .retntestReg
  1237                                  
  1238                                  ;-188   if (eqstr(SymbolUpper, "DI")) return 7;
  1239                                  
  1240                                  .testReg46:
  1241 000004DA 68[A606]                 push testReg_15
  1242 000004DD 8D064F75                 lea  ax, [SymbolUpper]
  1243 000004E1 50                       push ax
  1244 000004E2 E87BFD                   call eqstr
  1245 000004E5 83C404                   add  sp, 4
  1246 000004E8 08C0                     or  al, al
  1247 000004EA 0F840600                 je .testReg47
  1248 000004EE B80700                   mov ax, 7
  1249 000004F1 E98401                   jmp .retntestReg
  1250                                  
  1251                                  ;-189   R2Type=SEGREG;
  1252                                  
  1253                                  .testReg47:
  1254 000004F4 B80400                   mov ax, 4
  1255 000004F7 A2[3500]                 mov byte [R2Type], al
  1256                                  
  1257                                  ;-190   if (eqstr(SymbolUpper, "ES")) return 0;
  1258                                  
  1259 000004FA 68[A906]                 push testReg_16
  1260 000004FD 8D064F75                 lea  ax, [SymbolUpper]
  1261 00000501 50                       push ax
  1262 00000502 E85BFD                   call eqstr
  1263 00000505 83C404                   add  sp, 4
  1264 00000508 08C0                     or  al, al
  1265 0000050A 0F840600                 je .testReg48
  1266 0000050E B80000                   mov ax, 0
  1267 00000511 E96401                   jmp .retntestReg
  1268                                  
  1269                                  ;-191   if (eqstr(SymbolUpper, "CS")) return 1;
  1270                                  
  1271                                  .testReg48:
  1272 00000514 68[AC06]                 push testReg_17
  1273 00000517 8D064F75                 lea  ax, [SymbolUpper]
  1274 0000051B 50                       push ax
  1275 0000051C E841FD                   call eqstr
  1276 0000051F 83C404                   add  sp, 4
  1277 00000522 08C0                     or  al, al
  1278 00000524 0F840600                 je .testReg49
  1279 00000528 B80100                   mov ax, 1
  1280 0000052B E94A01                   jmp .retntestReg
  1281                                  
  1282                                  ;-192   if (eqstr(SymbolUpper, "SS")) return 2;
  1283                                  
  1284                                  .testReg49:
  1285 0000052E 68[AF06]                 push testReg_18
  1286 00000531 8D064F75                 lea  ax, [SymbolUpper]
  1287 00000535 50                       push ax
  1288 00000536 E827FD                   call eqstr
  1289 00000539 83C404                   add  sp, 4
  1290 0000053C 08C0                     or  al, al
  1291 0000053E 0F840600                 je .testReg50
  1292 00000542 B80200                   mov ax, 2
  1293 00000545 E93001                   jmp .retntestReg
  1294                                  
  1295                                  ;-193   if (eqstr(SymbolUpper, "DS")) return 3;
  1296                                  
  1297                                  .testReg50:
  1298 00000548 68[B206]                 push testReg_19
  1299 0000054B 8D064F75                 lea  ax, [SymbolUpper]
  1300 0000054F 50                       push ax
  1301 00000550 E80DFD                   call eqstr
  1302 00000553 83C404                   add  sp, 4
  1303 00000556 08C0                     or  al, al
  1304 00000558 0F840600                 je .testReg51
  1305 0000055C B80300                   mov ax, 3
  1306 0000055F E91601                   jmp .retntestReg
  1307                                  
  1308                                  ;-194   if (eqstr(SymbolUpper, "FS")) return 4;
  1309                                  
  1310                                  .testReg51:
  1311 00000562 68[B506]                 push testReg_20
  1312 00000565 8D064F75                 lea  ax, [SymbolUpper]
  1313 00000569 50                       push ax
  1314 0000056A E8F3FC                   call eqstr
  1315 0000056D 83C404                   add  sp, 4
  1316 00000570 08C0                     or  al, al
  1317 00000572 0F840600                 je .testReg52
  1318 00000576 B80400                   mov ax, 4
  1319 00000579 E9FC00                   jmp .retntestReg
  1320                                  
  1321                                  ;-195   if (eqstr(SymbolUpper, "GS")) return 5;
  1322                                  
  1323                                  .testReg52:
  1324 0000057C 68[B806]                 push testReg_21
  1325 0000057F 8D064F75                 lea  ax, [SymbolUpper]
  1326 00000583 50                       push ax
  1327 00000584 E8D9FC                   call eqstr
  1328 00000587 83C404                   add  sp, 4
  1329 0000058A 08C0                     or  al, al
  1330 0000058C 0F840600                 je .testReg53
  1331 00000590 B80500                   mov ax, 5
  1332 00000593 E9E200                   jmp .retntestReg
  1333                                  
  1334                                  ;-196   R2Type=DWORD;
  1335                                  
  1336                                  .testReg53:
  1337 00000596 B80300                   mov ax, 3
  1338 00000599 A2[3500]                 mov byte [R2Type], al
  1339                                  
  1340                                  ;-197   if (eqstr(SymbolUpper, "EAX"))return 0;
  1341                                  
  1342 0000059C 68[BB06]                 push testReg_22
  1343 0000059F 8D064F75                 lea  ax, [SymbolUpper]
  1344 000005A3 50                       push ax
  1345 000005A4 E8B9FC                   call eqstr
  1346 000005A7 83C404                   add  sp, 4
  1347 000005AA 08C0                     or  al, al
  1348 000005AC 0F840600                 je .testReg54
  1349 000005B0 B80000                   mov ax, 0
  1350 000005B3 E9C200                   jmp .retntestReg
  1351                                  
  1352                                  ;-198   if (eqstr(SymbolUpper, "ECX"))return 1;
  1353                                  
  1354                                  .testReg54:
  1355 000005B6 68[BF06]                 push testReg_23
  1356 000005B9 8D064F75                 lea  ax, [SymbolUpper]
  1357 000005BD 50                       push ax
  1358 000005BE E89FFC                   call eqstr
  1359 000005C1 83C404                   add  sp, 4
  1360 000005C4 08C0                     or  al, al
  1361 000005C6 0F840600                 je .testReg55
  1362 000005CA B80100                   mov ax, 1
  1363 000005CD E9A800                   jmp .retntestReg
  1364                                  
  1365                                  ;-199   if (eqstr(SymbolUpper, "EDX"))return 2;
  1366                                  
  1367                                  .testReg55:
  1368 000005D0 68[C306]                 push testReg_24
  1369 000005D3 8D064F75                 lea  ax, [SymbolUpper]
  1370 000005D7 50                       push ax
  1371 000005D8 E885FC                   call eqstr
  1372 000005DB 83C404                   add  sp, 4
  1373 000005DE 08C0                     or  al, al
  1374 000005E0 0F840600                 je .testReg56
  1375 000005E4 B80200                   mov ax, 2
  1376 000005E7 E98E00                   jmp .retntestReg
  1377                                  
  1378                                  ;-200   if (eqstr(SymbolUpper, "EBX"))return 3;
  1379                                  
  1380                                  .testReg56:
  1381 000005EA 68[C706]                 push testReg_25
  1382 000005ED 8D064F75                 lea  ax, [SymbolUpper]
  1383 000005F1 50                       push ax
  1384 000005F2 E86BFC                   call eqstr
  1385 000005F5 83C404                   add  sp, 4
  1386 000005F8 08C0                     or  al, al
  1387 000005FA 0F840600                 je .testReg57
  1388 000005FE B80300                   mov ax, 3
  1389 00000601 E97400                   jmp .retntestReg
  1390                                  
  1391                                  ;-201   if (eqstr(SymbolUpper, "ESP"))return 4;
  1392                                  
  1393                                  .testReg57:
  1394 00000604 68[CB06]                 push testReg_26
  1395 00000607 8D064F75                 lea  ax, [SymbolUpper]
  1396 0000060B 50                       push ax
  1397 0000060C E851FC                   call eqstr
  1398 0000060F 83C404                   add  sp, 4
  1399 00000612 08C0                     or  al, al
  1400 00000614 0F840600                 je .testReg58
  1401 00000618 B80400                   mov ax, 4
  1402 0000061B E95A00                   jmp .retntestReg
  1403                                  
  1404                                  ;-202   if (eqstr(SymbolUpper, "EBP"))return 5;
  1405                                  
  1406                                  .testReg58:
  1407 0000061E 68[CF06]                 push testReg_27
  1408 00000621 8D064F75                 lea  ax, [SymbolUpper]
  1409 00000625 50                       push ax
  1410 00000626 E837FC                   call eqstr
  1411 00000629 83C404                   add  sp, 4
  1412 0000062C 08C0                     or  al, al
  1413 0000062E 0F840600                 je .testReg59
  1414 00000632 B80500                   mov ax, 5
  1415 00000635 E94000                   jmp .retntestReg
  1416                                  
  1417                                  ;-203   if (eqstr(SymbolUpper, "ESI"))return 6;
  1418                                  
  1419                                  .testReg59:
  1420 00000638 68[D306]                 push testReg_28
  1421 0000063B 8D064F75                 lea  ax, [SymbolUpper]
  1422 0000063F 50                       push ax
  1423 00000640 E81DFC                   call eqstr
  1424 00000643 83C404                   add  sp, 4
  1425 00000646 08C0                     or  al, al
  1426 00000648 0F840600                 je .testReg60
  1427 0000064C B80600                   mov ax, 6
  1428 0000064F E92600                   jmp .retntestReg
  1429                                  
  1430                                  ;-204   if (eqstr(SymbolUpper, "EDI"))return 7;
  1431                                  
  1432                                  .testReg60:
  1433 00000652 68[D706]                 push testReg_29
  1434 00000655 8D064F75                 lea  ax, [SymbolUpper]
  1435 00000659 50                       push ax
  1436 0000065A E803FC                   call eqstr
  1437 0000065D 83C404                   add  sp, 4
  1438 00000660 08C0                     or  al, al
  1439 00000662 0F840600                 je .testReg61
  1440 00000666 B80700                   mov ax, 7
  1441 00000669 E90C00                   jmp .retntestReg
  1442                                  
  1443                                  ;-205   R2Type=0; return 0;
  1444                                  
  1445                                  .testReg61:
  1446 0000066C B80000                   mov ax, 0
  1447 0000066F A2[3500]                 mov byte [R2Type], al
  1448 00000672 B80000                   mov ax, 0
  1449 00000675 E90000                   jmp .retntestReg
  1450                                  
  1451                                  ;-206 }
  1452                                  
  1453                                  
  1454                                  ;-207 
  1455                                  
  1456                                  
  1457                                  ;-208 
  1458                                  
  1459                                  
  1460                                  ;-209 int prc(unsigned char c) {//print char
  1461                                  
  1462                                   .retntestReg:
  1463 00000678 C3                       ret
  1464 00000679 414C00                  testReg_0 db "AL",0
  1465 0000067C 434C00                  testReg_1 db "CL",0
  1466 0000067F 444C00                  testReg_2 db "DL",0
  1467 00000682 424C00                  testReg_3 db "BL",0
  1468 00000685 414800                  testReg_4 db "AH",0
  1469 00000688 434800                  testReg_5 db "CH",0
  1470 0000068B 444800                  testReg_6 db "DH",0
  1471 0000068E 424800                  testReg_7 db "BH",0
  1472 00000691 415800                  testReg_8 db "AX",0
  1473 00000694 435800                  testReg_9 db "CX",0
  1474 00000697 445800                  testReg_10 db "DX",0
  1475 0000069A 425800                  testReg_11 db "BX",0
  1476 0000069D 535000                  testReg_12 db "SP",0
  1477 000006A0 425000                  testReg_13 db "BP",0
  1478 000006A3 534900                  testReg_14 db "SI",0
  1479 000006A6 444900                  testReg_15 db "DI",0
  1480 000006A9 455300                  testReg_16 db "ES",0
  1481 000006AC 435300                  testReg_17 db "CS",0
  1482 000006AF 535300                  testReg_18 db "SS",0
  1483 000006B2 445300                  testReg_19 db "DS",0
  1484 000006B5 465300                  testReg_20 db "FS",0
  1485 000006B8 475300                  testReg_21 db "GS",0
  1486 000006BB 45415800                testReg_22 db "EAX",0
  1487 000006BF 45435800                testReg_23 db "ECX",0
  1488 000006C3 45445800                testReg_24 db "EDX",0
  1489 000006C7 45425800                testReg_25 db "EBX",0
  1490 000006CB 45535000                testReg_26 db "ESP",0
  1491 000006CF 45425000                testReg_27 db "EBP",0
  1492 000006D3 45534900                testReg_28 db "ESI",0
  1493 000006D7 45444900                testReg_29 db "EDI",0
  1494                                  ENDP
  1495                                  
  1496                                  prc: PROC
  1497                                  
  1498                                  ;-210         if ( _ c==10) {
  1499                                  
  1500                                  ;Function : prc, Number of local variables: 1
  1501                                  ;   # type sign width addr used name   list of local variables
  1502                                  ;  200 var unsg byte   209 NULL c = bp+4;
  1503 000006DB C8000000                 ENTER  0,0 ; constant expression
  1504 000006DF 807E040A                cmp byte[bp+4], 10
  1505 000006E3 0F850600                 jne .prc62
  1506                                  
  1507                                  ;-211             ax=13;
  1508                                  
  1509 000006E7 B80D00                   mov  ax, 13
  1510                                  
  1511                                  ;-212             writetty();
  1512                                  
  1513 000006EA E871F9                   call writetty
  1514                                  
  1515                                  ;-213             }
  1516                                  
  1517                                  
  1518                                  ;-214         al=c;
  1519                                  
  1520                                  .prc62:
  1521 000006ED 8A4604                   mov  al, [bp+4]
  1522                                  
  1523                                  ;-215         writetty();
  1524                                  
  1525 000006F0 E86BF9                   call writetty
  1526                                  
  1527                                  ;-216     fputcR(c,lst_fd);
  1528                                  
  1529 000006F3 FF36[1800]               push word [lst_fd]
  1530 000006F7 8A4604                   mov al, byte [bp+4]
  1531 000006FA B400                     mov ah, 0
  1532 000006FC 50                       push ax
  1533 000006FD E809FA                   call fputcR
  1534 00000700 83C404                   add  sp, 4
  1535                                  
  1536                                  ;-217 }
  1537                                  
  1538                                  
  1539                                  ;-218 
  1540                                  
  1541                                  
  1542                                  ;-219 int prscomment(unsigned char *s) {
  1543 00000703 C9                       LEAVE
  1544 00000704 C3                       ret
  1545                                  ENDP
  1546                                  
  1547                                  prscomment: PROC
  1548                                  
  1549                                  ;-220     unsigned char c;
  1550                                  
  1551                                  
  1552                                  ;-221     while (*s){
  1553                                  
  1554                                  ;Function : prscomment, Number of local variables: 2
  1555                                  ;   # type sign width addr used name   list of local variables
  1556                                  ;  200 ptr unsg byte   219 NULL s = bp+4
  1557                                  ;  201 var unsg byte   220 NULL c = bp-2;
  1558 00000705 C8020000                 ENTER  2,0
  1559                                  .prscomment63:
  1560 00000709 8B5E04                   mov bx, [bp+4]
  1561 0000070C 8A07                     mov al, [bx]
  1562 0000070E B400                     mov ah, 0
  1563 00000710 08C0                     or  al, al
  1564 00000712 0F841B00                 je .prscomment64
  1565                                  
  1566                                  ;-222         c=*s;
  1567                                  
  1568 00000716 8B5E04                   mov bx, [bp+4]
  1569 00000719 8A07                     mov al, [bx]
  1570 0000071B B400                     mov ah, 0
  1571 0000071D 8846FE                   mov [bp-2], al
  1572                                  
  1573                                  ;-223         prc(c);
  1574                                  
  1575 00000720 8A46FE                   mov al, byte [bp-2]
  1576 00000723 B400                     mov ah, 0
  1577 00000725 50                       push ax
  1578 00000726 E8B2FF                   call prc
  1579 00000729 83C402                   add  sp, 2
  1580                                  
  1581                                  ;-224         s++;
  1582                                  
  1583 0000072C FF4604                   inc  word[bp+4]
  1584                                  
  1585                                  ;-225     }
  1586                                  
  1587                                  
  1588                                  ;-226 }
  1589                                  
  1590 0000072F EBD8                     jmp .prscomment63
  1591                                  .prscomment64:
  1592                                  
  1593                                  ;-227 int prs(unsigned char *s) {
  1594 00000731 C9                       LEAVE
  1595 00000732 C3                       ret
  1596                                  ENDP
  1597                                  
  1598                                  prs: PROC
  1599                                  
  1600                                  ;-228     unsigned char c;
  1601                                  
  1602                                  
  1603                                  ;-229     int com;
  1604                                  
  1605                                  
  1606                                  ;-230     com=0;
  1607                                  
  1608                                  ;Function : prs, Number of local variables: 3
  1609                                  ;   # type sign width addr used name   list of local variables
  1610                                  ;  200 ptr unsg byte   227 NULL s = bp+4
  1611                                  ;  201 var unsg byte   228 NULL c = bp-2
  1612                                  ;  202 var sign word   229 NULL com = bp-4;
  1613 00000733 C8040000                 ENTER  4,0
  1614 00000737 B80000                   mov ax, 0
  1615 0000073A 8946FC                   mov [bp-4], ax
  1616                                  
  1617                                  ;-231     while (*s) {
  1618                                  
  1619                                  .prs65:
  1620 0000073D 8B5E04                   mov bx, [bp+4]
  1621 00000740 8A07                     mov al, [bx]
  1622 00000742 B400                     mov ah, 0
  1623 00000744 08C0                     or  al, al
  1624 00000746 0F847B00                 je .prs66
  1625                                  
  1626                                  ;-232         c=*s;
  1627                                  
  1628 0000074A 8B5E04                   mov bx, [bp+4]
  1629 0000074D 8A07                     mov al, [bx]
  1630 0000074F B400                     mov ah, 0
  1631 00000751 8846FE                   mov [bp-2], al
  1632                                  
  1633                                  ;-233         if (c==34) {
  1634                                  
  1635 00000754 8A46FE                   mov al, [bp-2]
  1636 00000757 3C22                     cmp al, 34
  1637 00000759 0F851800                 jne .prs67
  1638                                  
  1639                                  ;-234             if (com) com=0;
  1640                                  
  1641 0000075D 8B46FC                   mov ax, [bp-4]
  1642 00000760 08C0                     or  al, al
  1643 00000762 0F840900                 je .prs68
  1644 00000766 B80000                   mov ax, 0
  1645 00000769 8946FC                   mov [bp-4], ax
  1646                                  
  1647                                  ;-235                 else com=1;
  1648                                  
  1649 0000076C E90600                   jmp .prs69
  1650                                  .prs68:
  1651 0000076F B80100                   mov ax, 1
  1652 00000772 8946FC                   mov [bp-4], ax
  1653                                  
  1654                                  ;-236         }
  1655                                  
  1656                                  .prs69:
  1657                                  
  1658                                  ;-237         if (c==92) {
  1659                                  
  1660                                  .prs67:
  1661 00000775 8A46FE                   mov al, [bp-2]
  1662 00000778 3C5C                     cmp al, 92
  1663 0000077A 0F853500                 jne .prs70
  1664                                  
  1665                                  ;-238             if (com==0) {
  1666                                  
  1667 0000077E 8B46FC                   mov ax, [bp-4]
  1668 00000781 83F800                   cmp ax, 0
  1669 00000784 0F852B00                 jne .prs71
  1670                                  
  1671                                  ;-239                 s++;
  1672                                  
  1673 00000788 FF4604                   inc  word[bp+4]
  1674                                  
  1675                                  ;-240                 c=*s;
  1676                                  
  1677 0000078B 8B5E04                   mov bx, [bp+4]
  1678 0000078E 8A07                     mov al, [bx]
  1679 00000790 B400                     mov ah, 0
  1680 00000792 8846FE                   mov [bp-2], al
  1681                                  
  1682                                  ;-241                 if (c=='n') c=10;
  1683                                  
  1684 00000795 8A46FE                   mov al, [bp-2]
  1685 00000798 3C6E                     cmp al, 110
  1686 0000079A 0F850600                 jne .prs72
  1687 0000079E B80A00                   mov ax, 10
  1688 000007A1 8846FE                   mov [bp-2], al
  1689                                  
  1690                                  ;-242                 if (c=='t') c= 9;
  1691                                  
  1692                                  .prs72:
  1693 000007A4 8A46FE                   mov al, [bp-2]
  1694 000007A7 3C74                     cmp al, 116
  1695 000007A9 0F850600                 jne .prs73
  1696 000007AD B80900                   mov ax, 9
  1697 000007B0 8846FE                   mov [bp-2], al
  1698                                  
  1699                                  ;-243             }
  1700                                  
  1701                                  .prs73:
  1702                                  
  1703                                  ;-244         }
  1704                                  
  1705                                  .prs71:
  1706                                  
  1707                                  ;-245         prc(c);
  1708                                  
  1709                                  .prs70:
  1710 000007B3 8A46FE                   mov al, byte [bp-2]
  1711 000007B6 B400                     mov ah, 0
  1712 000007B8 50                       push ax
  1713 000007B9 E81FFF                   call prc
  1714 000007BC 83C402                   add  sp, 2
  1715                                  
  1716                                  ;-246         s++;
  1717                                  
  1718 000007BF FF4604                   inc  word[bp+4]
  1719                                  
  1720                                  ;-247     }
  1721                                  
  1722                                  
  1723                                  ;-248 }
  1724                                  
  1725 000007C2 E978FF                   jmp .prs65
  1726                                  .prs66:
  1727                                  
  1728                                  ;-249 int printhex4(unsigned char c) {
  1729 000007C5 C9                       LEAVE
  1730 000007C6 C3                       ret
  1731                                  ENDP
  1732                                  
  1733                                  printhex4: PROC
  1734                                  
  1735                                  ;-250     c += 48;
  1736                                  
  1737                                  ;Function : printhex4, Number of local variables: 1
  1738                                  ;   # type sign width addr used name   list of local variables
  1739                                  ;  200 var unsg byte   249 NULL c = bp+4;
  1740 000007C7 C8000000                 ENTER  0,0
  1741 000007CB 80460430                 add  byte[bp+4], 48
  1742                                  
  1743                                  ;-251     if (c > 57) c += 7;
  1744                                  
  1745 000007CF 8A4604                   mov al, [bp+4]
  1746 000007D2 3C39                     cmp al, 57
  1747 000007D4 0F8E0400                 jle .printhex474
  1748 000007D8 80460407                 add  byte[bp+4], 7
  1749                                  
  1750                                  ;-252     prc(c);
  1751                                  
  1752                                  .printhex474:
  1753 000007DC 8A4604                   mov al, byte [bp+4]
  1754 000007DF B400                     mov ah, 0
  1755 000007E1 50                       push ax
  1756 000007E2 E8F6FE                   call prc
  1757 000007E5 83C402                   add  sp, 2
  1758                                  
  1759                                  ;-253 }
  1760                                  
  1761                                  
  1762                                  ;-254 int printhex8a(unsigned char c) {
  1763 000007E8 C9                       LEAVE
  1764 000007E9 C3                       ret
  1765                                  ENDP
  1766                                  
  1767                                  printhex8a: PROC
  1768                                  
  1769                                  ;-255     unsigned char nib;
  1770                                  
  1771                                  
  1772                                  ;-256     nib = c >> 4; printhex4(nib);
  1773                                  
  1774                                  ;Function : printhex8a, Number of local variables: 2
  1775                                  ;   # type sign width addr used name   list of local variables
  1776                                  ;  200 var unsg byte   254 NULL c = bp+4
  1777                                  ;  201 var unsg byte   255 NULL nib = bp-2;
  1778 000007EA C8020000                 ENTER  2,0
  1779 000007EE 8A4604                   mov al, [bp+4]
  1780 000007F1 C0E804                   shr al, 4
  1781 000007F4 8846FE                   mov [bp-2], al
  1782 000007F7 8A46FE                   mov al, byte [bp-2]
  1783 000007FA B400                     mov ah, 0
  1784 000007FC 50                       push ax
  1785 000007FD E8C7FF                   call printhex4
  1786 00000800 83C402                   add  sp, 2
  1787                                  
  1788                                  ;-257     nib = c & 15; printhex4(nib);
  1789                                  
  1790 00000803 8A4604                   mov al, [bp+4]
  1791 00000806 240F                     and al, 15
  1792 00000808 8846FE                   mov [bp-2], al
  1793 0000080B 8A46FE                   mov al, byte [bp-2]
  1794 0000080E B400                     mov ah, 0
  1795 00000810 50                       push ax
  1796 00000811 E8B3FF                   call printhex4
  1797 00000814 83C402                   add  sp, 2
  1798                                  
  1799                                  ;-258 }
  1800                                  
  1801                                  
  1802                                  ;-259 int printhex16(unsigned int i) {
  1803 00000817 C9                       LEAVE
  1804 00000818 C3                       ret
  1805                                  ENDP
  1806                                  
  1807                                  printhex16: PROC
  1808                                  
  1809                                  ;-260     unsigned int half;
  1810                                  
  1811                                  
  1812                                  ;-261     half = i >>  8; printhex8a(half);
  1813                                  
  1814                                  ;Function : printhex16, Number of local variables: 2
  1815                                  ;   # type sign width addr used name   list of local variables
  1816                                  ;  200 var unsg word   259 NULL i = bp+4
  1817                                  ;  201 var unsg word   260 NULL half = bp-2;
  1818 00000819 C8020000                 ENTER  2,0
  1819 0000081D 8B4604                   mov ax, [bp+4]
  1820 00000820 C1E808                   shr ax, 8
  1821 00000823 8946FE                   mov [bp-2], ax
  1822 00000826 FF76FE                   push word [bp-2]
  1823 00000829 E8BEFF                   call printhex8a
  1824 0000082C 83C402                   add  sp, 2
  1825                                  
  1826                                  ;-262     half = i & 255; printhex8a(half);
  1827                                  
  1828 0000082F 8B4604                   mov ax, [bp+4]
  1829 00000832 25FF00                   and ax, 255
  1830 00000835 8946FE                   mov [bp-2], ax
  1831 00000838 FF76FE                   push word [bp-2]
  1832 0000083B E8ACFF                   call printhex8a
  1833 0000083E 83C402                   add  sp, 2
  1834                                  
  1835                                  ;-263 }
  1836                                  
  1837                                  
  1838                                  ;-264 int printIntU(unsigned int n) {
  1839 00000841 C9                       LEAVE
  1840 00000842 C3                       ret
  1841                                  ENDP
  1842                                  
  1843                                  printIntU: PROC
  1844                                  
  1845                                  ;-265     unsigned int e;
  1846                                  
  1847                                  
  1848                                  ;-266     if ( _ n >= 10) {
  1849                                  
  1850                                  ;Function : printIntU, Number of local variables: 2
  1851                                  ;   # type sign width addr used name   list of local variables
  1852                                  ;  200 var unsg word   264 NULL n = bp+4
  1853                                  ;  201 var unsg word   265 NULL e = bp-2;
  1854 00000843 C8020000                 ENTER  2,0 ; constant expression
  1855 00000847 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  1856 0000084B 0F821700                 jb  .printIntU75
  1857                                  
  1858                                  ;-267         e=n/10; //DIV
  1859                                  
  1860 0000084F 8B4604                   mov ax, [bp+4]
  1861 00000852 BB0A00                   mov bx, 10
  1862 00000855 BA0000                   mov dx, 0
  1863 00000858 F7F3                     div bx
  1864 0000085A 8946FE                   mov [bp-2], ax
  1865                                  
  1866                                  ;-268         printIntU(e);
  1867                                  
  1868 0000085D FF76FE                   push word [bp-2]
  1869 00000860 E8E0FF                   call printIntU
  1870 00000863 83C402                   add  sp, 2
  1871                                  
  1872                                  ;-269     }
  1873                                  
  1874                                  
  1875                                  ;-270     n = n % 10; //unsigned mod
  1876                                  
  1877                                  .printIntU75:
  1878 00000866 8B4604                   mov ax, [bp+4]
  1879 00000869 BB0A00                   mov bx, 10
  1880 0000086C BA0000                   mov dx, 0
  1881 0000086F F7F3                     div bx
  1882 00000871 89D0                     mov ax, dx
  1883 00000873 894604                   mov [bp+4], ax
  1884                                  
  1885                                  ;-271     n += '0';
  1886                                  
  1887 00000876 83460430                 add  word[bp+4], 48
  1888                                  
  1889                                  ;-272     prc(n);
  1890                                  
  1891 0000087A FF7604                   push word [bp+4]
  1892 0000087D E85BFE                   call prc
  1893 00000880 83C402                   add  sp, 2
  1894                                  
  1895                                  ;-273 }
  1896                                  
  1897                                  
  1898                                  ;-274 int printLine() {
  1899 00000883 C9                       LEAVE
  1900 00000884 C3                       ret
  1901                                  ENDP
  1902                                  
  1903                                  printLine: PROC
  1904                                  
  1905                                  ;-275     int i; char c;
  1906                                  
  1907                                  
  1908                                  ;-276     prs("\n");
  1909                                  
  1910                                  ;Function : printLine, Number of local variables: 2
  1911                                  ;   # type sign width addr used name   list of local variables
  1912                                  ;  200 var sign word   275 NULL i = bp-2
  1913                                  ;  201 var sign byte   275 NULL c = bp-4;
  1914 00000885 C8040000                 ENTER  4,0
  1915 00000889 68[1709]                 push printLine_0
  1916 0000088C E8A4FE                   call prs
  1917 0000088F 83C402                   add  sp, 2
  1918                                  
  1919                                  ;-277     printhex16(PCStart);
  1920                                  
  1921 00000892 FF36[2900]               push word [PCStart]
  1922 00000896 E880FF                   call printhex16
  1923 00000899 83C402                   add  sp, 2
  1924                                  
  1925                                  ;-278     if (OpPrintIndex == 0) prs("               ");
  1926                                  
  1927 0000089C A1[4100]                 mov ax, [OpPrintIndex]
  1928 0000089F 83F800                   cmp ax, 0
  1929 000008A2 0F850C00                 jne .printLine76
  1930 000008A6 68[1A09]                 push printLine_1
  1931 000008A9 E887FE                   call prs
  1932 000008AC 83C402                   add  sp, 2
  1933                                  
  1934                                  ;-279     else {
  1935                                  
  1936 000008AF E94C00                   jmp .printLine77
  1937                                  .printLine76:
  1938                                  
  1939                                  ;-280 //        prc(' ');
  1940                                  
  1941                                  
  1942                                  ;-281         i=0;
  1943                                  
  1944 000008B2 B80000                   mov ax, 0
  1945 000008B5 8946FE                   mov [bp-2], ax
  1946                                  
  1947                                  ;-282         do {
  1948                                  
  1949                                  .printLine78:
  1950                                  
  1951                                  ;-283             c=OpPos[i];
  1952                                  
  1953 000008B8 8B5EFE                   mov bx, [bp-2]
  1954 000008BB 8A875577                 mov al, [OpPos + bx]
  1955 000008BF 8846FC                   mov [bp-4], al
  1956                                  
  1957                                  ;-284             prc(' ');
  1958                                  
  1959 000008C2 6A20                     push 32
  1960 000008C4 E814FE                   call prc
  1961 000008C7 83C402                   add  sp, 2
  1962                                  
  1963                                  ;-285             printhex8a(c);
  1964                                  
  1965 000008CA 8A46FC                   mov al, byte [bp-4]
  1966 000008CD B400                     mov ah, 0
  1967 000008CF 50                       push ax
  1968 000008D0 E817FF                   call printhex8a
  1969 000008D3 83C402                   add  sp, 2
  1970                                  
  1971                                  ;-286             i++;
  1972                                  
  1973 000008D6 FF46FE                   inc  word[bp-2]
  1974                                  
  1975                                  ;-287         } while (i < OpPrintIndex);
  1976                                  
  1977 000008D9 8B46FE                   mov ax, [bp-2]
  1978 000008DC 3B06[4100]               cmp ax, [OpPrintIndex]
  1979 000008E0 0F8D0200                 jge .printLine79
  1980 000008E4 EBD2                     jmp .printLine78
  1981                                  .printLine79:
  1982                                  
  1983                                  ;-288         while (i < OPMAXLEN) {// fill rest with blank
  1984                                  
  1985                                  .printLine80:
  1986 000008E6 8B46FE                   mov ax, [bp-2]
  1987 000008E9 83F805                   cmp ax, 5
  1988 000008EC 0F8D0E00                 jge .printLine81
  1989                                  
  1990                                  ;-289             prs("   ");
  1991                                  
  1992 000008F0 68[2A09]                 push printLine_2
  1993 000008F3 E83DFE                   call prs
  1994 000008F6 83C402                   add  sp, 2
  1995                                  
  1996                                  ;-290             i++;
  1997                                  
  1998 000008F9 FF46FE                   inc  word[bp-2]
  1999                                  
  2000                                  ;-291         }
  2001                                  
  2002                                  
  2003                                  ;-292     }
  2004                                  
  2005 000008FC EBE8                     jmp .printLine80
  2006                                  .printLine81:
  2007                                  
  2008                                  ;-293     prc(PrintRA);
  2009                                  
  2010                                  .printLine77:
  2011 000008FE A0[4500]                 mov al, byte [PrintRA]
  2012 00000901 B400                     mov ah, 0
  2013 00000903 50                       push ax
  2014 00000904 E8D4FD                   call prc
  2015 00000907 83C402                   add  sp, 2
  2016                                  
  2017                                  ;-294     prscomment(InputBuf);
  2018                                  
  2019 0000090A 8D068D75                 lea  ax, [InputBuf]
  2020 0000090E 50                       push ax
  2021 0000090F E8F3FD                   call prscomment
  2022 00000912 83C402                   add  sp, 2
  2023                                  
  2024                                  ;-295 }
  2025                                  
  2026                                  
  2027                                  ;-296 
  2028                                  
  2029                                  
  2030                                  ;-297 int epilog() {
  2031 00000915 C9                       LEAVE
  2032 00000916 C3                       ret
  2033 00000917 5C6E00                  printLine_0 db "\n",0
  2034 0000091A 202020202020202020-     printLine_1 db "               ",0
  2035 00000923 20202020202000     
  2036 0000092A 20202000                printLine_2 db "   ",0
  2037                                  ENDP
  2038                                  
  2039                                  epilog: PROC
  2040                                  
  2041                                  ;-298     unsigned int i; char c;     int j;
  2042                                  
  2043                                  
  2044                                  ;-299     prs("\n Errors: ");
  2045                                  
  2046                                  ;Function : epilog, Number of local variables: 3
  2047                                  ;   # type sign width addr used name   list of local variables
  2048                                  ;  200 var unsg word   298 NULL i = bp-2
  2049                                  ;  201 var sign byte   298 NULL c = bp-4
  2050                                  ;  202 var sign word   298 NULL j = bp-6;
  2051 0000092E C8060000                 ENTER  6,0
  2052 00000932 68[E009]                 push epilog_0
  2053 00000935 E8FBFD                   call prs
  2054 00000938 83C402                   add  sp, 2
  2055                                  
  2056                                  ;-300     printIntU(ErrorCount);
  2057                                  
  2058 0000093B FF36[1E00]               push word [ErrorCount]
  2059 0000093F E801FF                   call printIntU
  2060 00000942 83C402                   add  sp, 2
  2061                                  
  2062                                  ;-301     if (ErrorCount) prs(" *** ERRORS *** ");
  2063                                  
  2064 00000945 A1[1E00]                 mov ax, [ErrorCount]
  2065 00000948 08C0                     or  al, al
  2066 0000094A 0F840900                 je .epilog82
  2067 0000094E 68[EC09]                 push epilog_1
  2068 00000951 E8DFFD                   call prs
  2069 00000954 83C402                   add  sp, 2
  2070                                  
  2071                                  ;-302     prs(", Out: ");
  2072                                  
  2073                                  .epilog82:
  2074 00000957 68[FD09]                 push epilog_2
  2075 0000095A E8D6FD                   call prs
  2076 0000095D 83C402                   add  sp, 2
  2077                                  
  2078                                  ;-303     prs(namelst);
  2079                                  
  2080 00000960 8D06CF76                 lea  ax, [namelst]
  2081 00000964 50                       push ax
  2082 00000965 E8CBFD                   call prs
  2083 00000968 83C402                   add  sp, 2
  2084                                  
  2085                                  ;-304     prs(", ");
  2086                                  
  2087 0000096B 68[050A]                 push epilog_3
  2088 0000096E E8C2FD                   call prs
  2089 00000971 83C402                   add  sp, 2
  2090                                  
  2091                                  ;-305     prs(namebin);
  2092                                  
  2093 00000974 8D061277                 lea  ax, [namebin]
  2094 00000978 50                       push ax
  2095 00000979 E8B7FD                   call prs
  2096 0000097C 83C402                   add  sp, 2
  2097                                  
  2098                                  ;-306     prs("= ");
  2099                                  
  2100 0000097F 68[080A]                 push epilog_4
  2101 00000982 E8AEFD                   call prs
  2102 00000985 83C402                   add  sp, 2
  2103                                  
  2104                                  ;-307     printIntU(BinLen);
  2105                                  
  2106 00000988 FF36[5800]               push word [BinLen]
  2107 0000098C E8B4FE                   call printIntU
  2108 0000098F 83C402                   add  sp, 2
  2109                                  
  2110                                  ;-308     prs(" bytes.");
  2111                                  
  2112 00000992 68[0B0A]                 push epilog_5
  2113 00000995 E89BFD                   call prs
  2114 00000998 83C402                   add  sp, 2
  2115                                  
  2116                                  ;-309     prs(" Labels: ");
  2117                                  
  2118 0000099B 68[130A]                 push epilog_6
  2119 0000099E E892FD                   call prs
  2120 000009A1 83C402                   add  sp, 2
  2121                                  
  2122                                  ;-310     printIntU(LabelMaxIx);
  2123                                  
  2124 000009A4 FF36[4A00]               push word [LabelMaxIx]
  2125 000009A8 E898FE                   call printIntU
  2126 000009AB 83C402                   add  sp, 2
  2127                                  
  2128                                  ;-311 // prs(", code:\n ");//debug
  2129                                  
  2130                                  
  2131                                  ;-312 
  2132                                  
  2133                                  
  2134                                  ;-313     i=0;
  2135                                  
  2136 000009AE B80000                   mov ax, 0
  2137 000009B1 8946FE                   mov [bp-2], ax
  2138                                  
  2139                                  ;-314     do {
  2140                                  
  2141                                  .epilog83:
  2142                                  
  2143                                  ;-315         c = FileBin[i];
  2144                                  
  2145 000009B4 8B5EFE                   mov bx, [bp-2]
  2146 000009B7 8A87AAA4                 mov al, [FileBin + bx]
  2147 000009BB 8846FC                   mov [bp-4], al
  2148                                  
  2149                                  ;-316         fputcR(c, bin_fd);
  2150                                  
  2151 000009BE FF36[1A00]               push word [bin_fd]
  2152 000009C2 8A46FC                   mov al, byte [bp-4]
  2153 000009C5 B400                     mov ah, 0
  2154 000009C7 50                       push ax
  2155 000009C8 E83EF7                   call fputcR
  2156 000009CB 83C404                   add  sp, 4
  2157                                  
  2158                                  ;-317 // printhex8a(c); prc(' ');//debug
  2159                                  
  2160                                  
  2161                                  ;-318         i++;
  2162                                  
  2163 000009CE FF46FE                   inc  word[bp-2]
  2164                                  
  2165                                  ;-319     } while (i < BinLen);
  2166                                  
  2167 000009D1 8B46FE                   mov ax, [bp-2]
  2168 000009D4 3B06[5800]               cmp ax, [BinLen]
  2169 000009D8 0F8D0200                 jge .epilog84
  2170 000009DC EBD6                     jmp .epilog83
  2171                                  .epilog84:
  2172                                  
  2173                                  ;-320 
  2174                                  
  2175                                  
  2176                                  ;-321 /* 
  2177                                  
  2178                                  
  2179                                  ;-322   prs("\n\n LabelNamePtr:"); printIntU(LabelNamePtr);
  2180                                  
  2181                                  
  2182                                  ;-323   i= &LabelNames;
  2183                                  
  2184                                  
  2185                                  ;-324   prs(" &LabelNames:"); printIntU(i);
  2186                                  
  2187                                  
  2188                                  ;-325   i=LabelNamePtr-i;
  2189                                  
  2190                                  
  2191                                  ;-326   prs(", size: ");
  2192                                  
  2193                                  
  2194                                  ;-327   printIntU(i);
  2195                                  
  2196                                  
  2197                                  ;-328   prs(".\n >>");
  2198                                  
  2199                                  
  2200                                  ;-329   i= &LabelNames;
  2201                                  
  2202                                  
  2203                                  ;-330   do { c=*i; if (c==0) c=' '; prc(c); i++;
  2204                                  
  2205                                  
  2206                                  ;-331   } while (i < LabelNamePtr); prs("<< \n");
  2207                                  
  2208                                  
  2209                                  ;-332    i = 1;
  2210                                  
  2211                                  
  2212                                  ;-333     LabelNamePtr= &LabelNames;
  2213                                  
  2214                                  
  2215                                  ;-334     do {
  2216                                  
  2217                                  
  2218                                  ;-335       prs(LabelNamePtr); prc(' ');
  2219                                  
  2220                                  
  2221                                  ;-336       j=LabelAddr[i]; printhex16(j); prs(", ");
  2222                                  
  2223                                  
  2224                                  ;-337       j=strlen(LabelNamePtr);//get end of actual name
  2225                                  
  2226                                  
  2227                                  ;-338       LabelNamePtr=LabelNamePtr+j;
  2228                                  
  2229                                  
  2230                                  ;-339       LabelNamePtr++;
  2231                                  
  2232                                  
  2233                                  ;-340       i++;
  2234                                  
  2235                                  
  2236                                  ;-341     } while (i <= LabelMaxIx);
  2237                                  
  2238                                  
  2239                                  ;-342 */
  2240                                  
  2241                                  
  2242                                  ;-343 }
  2243                                  
  2244                                  
  2245                                  ;-344 
  2246                                  
  2247                                  
  2248                                  ;-345 int end1(int n) {
  2249 000009DE C9                       LEAVE
  2250 000009DF C3                       ret
  2251 000009E0 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  2252 000009E9 3A2000             
  2253 000009EC 202A2A2A204552524F-     epilog_1 db " *** ERRORS *** ",0
  2254 000009F5 5253202A2A2A2000   
  2255 000009FD 2C204F75743A2000        epilog_2 db ", Out: ",0
  2256 00000A05 2C2000                  epilog_3 db ", ",0
  2257 00000A08 3D2000                  epilog_4 db "= ",0
  2258 00000A0B 2062797465732E00        epilog_5 db " bytes.",0
  2259 00000A13 204C6162656C733A20-     epilog_6 db " Labels: ",0
  2260 00000A1C 00                 
  2261                                  ENDP
  2262                                  
  2263                                  end1: PROC
  2264                                  
  2265                                  ;-346     fcloseR(asm_fd);
  2266                                  
  2267                                  ;Function : end1, Number of local variables: 1
  2268                                  ;   # type sign width addr used name   list of local variables
  2269                                  ;  200 var sign word   345 NULL n = bp+4;
  2270 00000A1D C8000000                 ENTER  0,0
  2271 00000A21 FF36[1600]               push word [asm_fd]
  2272 00000A25 E8AFF6                   call fcloseR
  2273 00000A28 83C402                   add  sp, 2
  2274                                  
  2275                                  ;-347     fcloseR(lst_fd);
  2276                                  
  2277 00000A2B FF36[1800]               push word [lst_fd]
  2278 00000A2F E8A5F6                   call fcloseR
  2279 00000A32 83C402                   add  sp, 2
  2280                                  
  2281                                  ;-348     fcloseR(bin_fd);
  2282                                  
  2283 00000A35 FF36[1A00]               push word [bin_fd]
  2284 00000A39 E89BF6                   call fcloseR
  2285 00000A3C 83C402                   add  sp, 2
  2286                                  
  2287                                  ;-349     exitR(n);
  2288                                  
  2289 00000A3F FF7604                   push word [bp+4]
  2290 00000A42 E8A1F6                   call exitR
  2291 00000A45 83C402                   add  sp, 2
  2292                                  
  2293                                  ;-350 }
  2294                                  
  2295                                  
  2296                                  ;-351 
  2297                                  
  2298                                  
  2299                                  ;-352 
  2300                                  
  2301                                  
  2302                                  ;-353 int error1(char *s) {
  2303 00000A48 C9                       LEAVE
  2304 00000A49 C3                       ret
  2305                                  ENDP
  2306                                  
  2307                                  error1: PROC
  2308                                  
  2309                                  ;-354     ErrorCount++;
  2310                                  
  2311                                  ;Function : error1, Number of local variables: 1
  2312                                  ;   # type sign width addr used name   list of local variables
  2313                                  ;  200 ptr sign byte   353 NULL s = bp+4;
  2314 00000A4A C8000000                 ENTER  0,0
  2315 00000A4E FF06[1E00]               inc  word[ErrorCount]
  2316                                  
  2317                                  ;-355     prs("\n******* next line ERROR: ");
  2318                                  
  2319 00000A52 68[7A0A]                 push error1_0
  2320 00000A55 E8DBFC                   call prs
  2321 00000A58 83C402                   add  sp, 2
  2322                                  
  2323                                  ;-356     prs(s);
  2324                                  
  2325 00000A5B FF7604                   push word [bp+4]
  2326 00000A5E E8D2FC                   call prs
  2327 00000A61 83C402                   add  sp, 2
  2328                                  
  2329                                  ;-357     prs(", Symbol: ");
  2330                                  
  2331 00000A64 68[960A]                 push error1_1
  2332 00000A67 E8C9FC                   call prs
  2333 00000A6A 83C402                   add  sp, 2
  2334                                  
  2335                                  ;-358     prs(Symbol);
  2336                                  
  2337 00000A6D 8D063075                 lea  ax, [Symbol]
  2338 00000A71 50                       push ax
  2339 00000A72 E8BEFC                   call prs
  2340 00000A75 83C402                   add  sp, 2
  2341                                  
  2342                                  ;-359 }
  2343                                  
  2344                                  
  2345                                  ;-360 int errorexit(char *s) {
  2346 00000A78 C9                       LEAVE
  2347 00000A79 C3                       ret
  2348 00000A7A 5C6E2A2A2A2A2A2A2A-     error1_0 db "\n******* next line ERROR: ",0
  2349 00000A83 206E657874206C696E-
  2350 00000A8C 65204552524F523A20-
  2351 00000A95 00                 
  2352 00000A96 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  2353 00000A9F 2000               
  2354                                  ENDP
  2355                                  
  2356                                  errorexit: PROC
  2357                                  
  2358                                  ;-361     error1(s);
  2359                                  
  2360                                  ;Function : errorexit, Number of local variables: 1
  2361                                  ;   # type sign width addr used name   list of local variables
  2362                                  ;  200 ptr sign byte   360 NULL s = bp+4;
  2363 00000AA1 C8000000                 ENTER  0,0
  2364 00000AA5 FF7604                   push word [bp+4]
  2365 00000AA8 E89FFF                   call error1
  2366 00000AAB 83C402                   add  sp, 2
  2367                                  
  2368                                  ;-362     epilog();
  2369                                  
  2370 00000AAE E87DFE                   call epilog
  2371                                  
  2372                                  ;-363     end1(1);
  2373                                  
  2374 00000AB1 6A01                     push 1
  2375 00000AB3 E867FF                   call end1
  2376 00000AB6 83C402                   add  sp, 2
  2377                                  
  2378                                  ;-364 }
  2379                                  
  2380                                  
  2381                                  ;-365 int notfounderror(){
  2382 00000AB9 C9                       LEAVE
  2383 00000ABA C3                       ret
  2384                                  ENDP
  2385                                  
  2386                                  notfounderror: PROC
  2387                                  
  2388                                  ;-366     ErrorCount++;
  2389                                  
  2390 00000ABB FF06[1E00]               inc  word[ErrorCount]
  2391                                  
  2392                                  ;-367     prs("\n******* ERROR: label not found: ");
  2393                                  
  2394 00000ABF 68[DD0A]                 push notfounderror_0
  2395 00000AC2 E86EFC                   call prs
  2396 00000AC5 83C402                   add  sp, 2
  2397                                  
  2398                                  ;-368     prs(Symbol);
  2399                                  
  2400 00000AC8 8D063075                 lea  ax, [Symbol]
  2401 00000ACC 50                       push ax
  2402 00000ACD E863FC                   call prs
  2403 00000AD0 83C402                   add  sp, 2
  2404                                  
  2405                                  ;-369     prs(" ");
  2406                                  
  2407 00000AD3 68[000B]                 push notfounderror_1
  2408 00000AD6 E85AFC                   call prs
  2409 00000AD9 83C402                   add  sp, 2
  2410                                  
  2411                                  ;-370 }
  2412                                  
  2413                                  
  2414                                  ;-371 int allowederror() {error1("not allowed here"); }
  2415                                  
  2416 00000ADC C3                       ret
  2417 00000ADD 5C6E2A2A2A2A2A2A2A-     notfounderror_0 db "\n******* ERROR: label not found: ",0
  2418 00000AE6 204552524F523A206C-
  2419 00000AEF 6162656C206E6F7420-
  2420 00000AF8 666F756E643A2000   
  2421 00000B00 2000                    notfounderror_1 db " ",0
  2422                                  ENDP
  2423                                  
  2424                                  allowederror: PROC
  2425 00000B02 68[0C0B]                 push allowederror_0
  2426 00000B05 E842FF                   call error1
  2427 00000B08 83C402                   add  sp, 2
  2428                                  
  2429                                  ;-372 int addrerror()    {error1("address missing");}
  2430                                  
  2431 00000B0B C3                       ret
  2432 00000B0C 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  2433 00000B15 6564206865726500   
  2434                                  ENDP
  2435                                  
  2436                                  addrerror: PROC
  2437 00000B1D 68[270B]                 push addrerror_0
  2438 00000B20 E827FF                   call error1
  2439 00000B23 83C402                   add  sp, 2
  2440                                  
  2441                                  ;-373 int immeerror()    {error1("immediate not allowed here");}
  2442                                  
  2443 00000B26 C3                       ret
  2444 00000B27 61646472657373206D-     addrerror_0 db "address missing",0
  2445 00000B30 697373696E6700     
  2446                                  ENDP
  2447                                  
  2448                                  immeerror: PROC
  2449 00000B37 68[410B]                 push immeerror_0
  2450 00000B3A E80DFF                   call error1
  2451 00000B3D 83C402                   add  sp, 2
  2452                                  
  2453                                  ;-374 int implerror()    {error1("not implemented");}
  2454                                  
  2455 00000B40 C3                       ret
  2456 00000B41 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  2457 00000B4A 206E6F7420616C6C6F-
  2458 00000B53 776564206865726500 
  2459                                  ENDP
  2460                                  
  2461                                  implerror: PROC
  2462 00000B5C 68[660B]                 push implerror_0
  2463 00000B5F E8E8FE                   call error1
  2464 00000B62 83C402                   add  sp, 2
  2465                                  
  2466                                  ;-375 int indexerror()   {error1("invalid index register");}
  2467                                  
  2468 00000B65 C3                       ret
  2469 00000B66 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  2470 00000B6F 6D656E74656400     
  2471                                  ENDP
  2472                                  
  2473                                  indexerror: PROC
  2474 00000B76 68[800B]                 push indexerror_0
  2475 00000B79 E8CEFE                   call error1
  2476 00000B7C 83C402                   add  sp, 2
  2477                                  
  2478                                  ;-376 int invaloperror() {error1("invalid or no operands");}
  2479                                  
  2480 00000B7F C3                       ret
  2481 00000B80 696E76616C69642069-     indexerror_0 db "invalid index register",0
  2482 00000B89 6E6465782072656769-
  2483 00000B92 7374657200         
  2484                                  ENDP
  2485                                  
  2486                                  invaloperror: PROC
  2487 00000B97 68[A10B]                 push invaloperror_0
  2488 00000B9A E8ADFE                   call error1
  2489 00000B9D 83C402                   add  sp, 2
  2490                                  
  2491                                  ;-377 int numbererror()  {error1("number expected");}
  2492                                  
  2493 00000BA0 C3                       ret
  2494 00000BA1 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  2495 00000BAA 72206E6F206F706572-
  2496 00000BB3 616E647300         
  2497                                  ENDP
  2498                                  
  2499                                  numbererror: PROC
  2500 00000BB8 68[C20B]                 push numbererror_0
  2501 00000BBB E88CFE                   call error1
  2502 00000BBE 83C402                   add  sp, 2
  2503                                  
  2504                                  ;-378 int regmemerror()  {error1("only register or memory allowed");}
  2505                                  
  2506 00000BC1 C3                       ret
  2507 00000BC2 6E756D626572206578-     numbererror_0 db "number expected",0
  2508 00000BCB 70656374656400     
  2509                                  ENDP
  2510                                  
  2511                                  regmemerror: PROC
  2512 00000BD2 68[DC0B]                 push regmemerror_0
  2513 00000BD5 E872FE                   call error1
  2514 00000BD8 83C402                   add  sp, 2
  2515                                  
  2516                                  ;-379 int reg16error()   {error1("only reg16, no segreg allowed");}
  2517                                  
  2518 00000BDB C3                       ret
  2519 00000BDC 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  2520 00000BE5 73746572206F72206D-
  2521 00000BEE 656D6F727920616C6C-
  2522 00000BF7 6F77656400         
  2523                                  ENDP
  2524                                  
  2525                                  reg16error: PROC
  2526 00000BFC 68[060C]                 push reg16error_0
  2527 00000BFF E848FE                   call error1
  2528 00000C02 83C402                   add  sp, 2
  2529                                  
  2530                                  ;-380 int segregerror()  {error1("segment register not allowed");}
  2531                                  
  2532 00000C05 C3                       ret
  2533 00000C06 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  2534 00000C0F 362C206E6F20736567-
  2535 00000C18 72656720616C6C6F77-
  2536 00000C21 656400             
  2537                                  ENDP
  2538                                  
  2539                                  segregerror: PROC
  2540 00000C24 68[2E0C]                 push segregerror_0
  2541 00000C27 E820FE                   call error1
  2542 00000C2A 83C402                   add  sp, 2
  2543                                  
  2544                                  ;-381 int syntaxerror()  {error1("syntax");}
  2545                                  
  2546 00000C2D C3                       ret
  2547 00000C2E 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  2548 00000C37 65676973746572206E-
  2549 00000C40 6F7420616C6C6F7765-
  2550 00000C49 6400               
  2551                                  ENDP
  2552                                  
  2553                                  syntaxerror: PROC
  2554 00000C4B 68[550C]                 push syntaxerror_0
  2555 00000C4E E8F9FD                   call error1
  2556 00000C51 83C402                   add  sp, 2
  2557                                  
  2558                                  ;-382 
  2559                                  
  2560                                  
  2561                                  ;-383 int addrexit()     {errorexit("illegal address");}
  2562                                  
  2563 00000C54 C3                       ret
  2564 00000C55 73796E74617800          syntaxerror_0 db "syntax",0
  2565                                  ENDP
  2566                                  
  2567                                  addrexit: PROC
  2568 00000C5C 68[660C]                 push addrexit_0
  2569 00000C5F E83FFE                   call errorexit
  2570 00000C62 83C402                   add  sp, 2
  2571                                  
  2572                                  ;-384 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  2573                                  
  2574 00000C65 C3                       ret
  2575 00000C66 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  2576 00000C6F 64647265737300     
  2577                                  ENDP
  2578                                  
  2579                                  dataexit: PROC
  2580 00000C76 68[800C]                 push dataexit_0
  2581 00000C79 E825FE                   call errorexit
  2582 00000C7C 83C402                   add  sp, 2
  2583                                  
  2584                                  ;-385 int internexit()   {errorexit("intern compiler error");}
  2585                                  
  2586 00000C7F C3                       ret
  2587 00000C80 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  2588 00000C89 6F7220524553422C57-
  2589 00000C92 2C4420657870656374-
  2590 00000C9B 656400             
  2591                                  ENDP
  2592                                  
  2593                                  internexit: PROC
  2594 00000C9E 68[A80C]                 push internexit_0
  2595 00000CA1 E8FDFD                   call errorexit
  2596 00000CA4 83C402                   add  sp, 2
  2597                                  
  2598                                  ;-386 
  2599                                  
  2600                                  
  2601                                  ;-387 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
  2602                                  
  2603 00000CA7 C3                       ret
  2604 00000CA8 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  2605 00000CB1 6D70696C6572206572-
  2606 00000CBA 726F7200           
  2607                                  ENDP
  2608                                  
  2609                                  ifEOL: PROC
  2610                                  
  2611                                  ;-388   if (c == 10) return 1;//LF
  2612                                  
  2613                                  ;Function : ifEOL, Number of local variables: 1
  2614                                  ;   # type sign width addr used name   list of local variables
  2615                                  ;  200 var sign byte   387 NULL c = bp+4;
  2616 00000CBE C8000000                 ENTER  0,0
  2617 00000CC2 8A4604                   mov al, [bp+4]
  2618 00000CC5 3C0A                     cmp al, 10
  2619 00000CC7 0F850600                 jne .ifEOL85
  2620 00000CCB B80100                   mov ax, 1
  2621 00000CCE E93B00                   jmp .retnifEOL
  2622                                  
  2623                                  ;-389   if (c == 13) {//CR
  2624                                  
  2625                                  .ifEOL85:
  2626 00000CD1 8A4604                   mov al, [bp+4]
  2627 00000CD4 3C0D                     cmp al, 13
  2628 00000CD6 0F852C00                 jne .ifEOL86
  2629                                  
  2630                                  ;-390     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2631                                  
  2632 00000CDA 6A01                     push 1
  2633 00000CDC FF36[1600]               push word [asm_fd]
  2634 00000CE0 8D06[2200]               lea  ax, [DOS_ByteRead]
  2635 00000CE4 50                       push ax
  2636 00000CE5 E80CF4                   call readRL
  2637 00000CE8 83C406                   add  sp, 6
  2638 00000CEB A3[2000]                 mov word [DOS_NoBytes], ax
  2639                                  
  2640                                  ;-391     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
  2641                                  
  2642 00000CEE A0[2200]                 mov al, [DOS_ByteRead]
  2643 00000CF1 3C0A                     cmp al, 10
  2644 00000CF3 0F840900                 je  .ifEOL87
  2645 00000CF7 68[0E0D]                 push ifEOL_0
  2646 00000CFA E8A4FD                   call errorexit
  2647 00000CFD 83C402                   add  sp, 2
  2648                                  
  2649                                  ;-392     return 1;
  2650                                  
  2651                                  .ifEOL87:
  2652 00000D00 B80100                   mov ax, 1
  2653 00000D03 E90600                   jmp .retnifEOL
  2654                                  
  2655                                  ;-393   }
  2656                                  
  2657                                  
  2658                                  ;-394   return 0;
  2659                                  
  2660                                  .ifEOL86:
  2661 00000D06 B80000                   mov ax, 0
  2662 00000D09 E90000                   jmp .retnifEOL
  2663                                  
  2664                                  ;-395 }
  2665                                  
  2666                                  
  2667                                  ;-396 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2668                                  
  2669 00000D0C C9                       .retnifEOL: LEAVE
  2670 00000D0D C3                       ret
  2671 00000D0E 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
  2672 00000D17 462831302920616674-
  2673 00000D20 657220435228313329-
  2674 00000D29 00                 
  2675                                  ENDP
  2676                                  
  2677                                  getLine: PROC
  2678                                  
  2679                                  ;-397   unsigned int i;
  2680                                  
  2681                                  
  2682                                  ;-398   InputPtr= &InputBuf;
  2683                                  
  2684                                  ;Function : getLine, Number of local variables: 1
  2685                                  ;   # type sign width addr used name   list of local variables
  2686                                  ;  200 var unsg word   397 NULL i = bp-2;
  2687 00000D2A C8020000                 ENTER  2,0
  2688 00000D2E B88D75                   mov ax, InputBuf
  2689 00000D31 A3[1400]                 mov word [InputPtr], ax
  2690                                  
  2691                                  ;-399   *InputPtr=0;//if last line is empty
  2692                                  
  2693 00000D34 B80000                   mov ax, 0
  2694 00000D37 8B1E[1400]               mov  bx, [InputPtr]
  2695 00000D3B 8807                     mov  [bx], al
  2696                                  
  2697                                  ;-400   do {
  2698                                  
  2699                                  .getLine88:
  2700                                  
  2701                                  ;-401     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2702                                  
  2703 00000D3D 6A01                     push 1
  2704 00000D3F FF36[1600]               push word [asm_fd]
  2705 00000D43 8D06[2200]               lea  ax, [DOS_ByteRead]
  2706 00000D47 50                       push ax
  2707 00000D48 E8A9F3                   call readRL
  2708 00000D4B 83C406                   add  sp, 6
  2709 00000D4E A3[2000]                 mov word [DOS_NoBytes], ax
  2710                                  
  2711                                  ;-402     if (DOS_ERR) errorexit("Reading Source");
  2712                                  
  2713 00000D51 A1[1C00]                 mov ax, [DOS_ERR]
  2714 00000D54 08C0                     or  al, al
  2715 00000D56 0F840900                 je .getLine89
  2716 00000D5A 68[BC0D]                 push getLine_0
  2717 00000D5D E841FD                   call errorexit
  2718 00000D60 83C402                   add  sp, 2
  2719                                  
  2720                                  ;-403     if (DOS_NoBytes == 0) return;
  2721                                  
  2722                                  .getLine89:
  2723 00000D63 A1[2000]                 mov ax, [DOS_NoBytes]
  2724 00000D66 83F800                   cmp ax, 0
  2725 00000D69 0F850300                 jne .getLine90
  2726 00000D6D E94A00                   jmp .retngetLine
  2727                                  
  2728                                  ;-404     *InputPtr = DOS_ByteRead;
  2729                                  
  2730                                  .getLine90:
  2731 00000D70 A0[2200]                 mov al, [DOS_ByteRead]
  2732 00000D73 8B1E[1400]               mov  bx, [InputPtr]
  2733 00000D77 8807                     mov  [bx], al
  2734                                  
  2735                                  ;-405     InputPtr++;
  2736                                  
  2737 00000D79 FF06[1400]               inc  word[InputPtr]
  2738                                  
  2739                                  ;-406     i = InputPtr - &InputBuf;
  2740                                  
  2741 00000D7D A1[1400]                 mov ax, [InputPtr]
  2742 00000D80 2D8D75                   sub ax, InputBuf
  2743 00000D83 8946FE                   mov [bp-2], ax
  2744                                  
  2745                                  ;-407     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2746                                  
  2747 00000D86 8B46FE                   mov ax, [bp-2]
  2748 00000D89 3DFF00                   cmp ax, 255 ;unsigned : 0
  2749 00000D8C 0F820900                 jb  .getLine91
  2750 00000D90 68[CB0D]                 push getLine_1
  2751 00000D93 E80BFD                   call errorexit
  2752 00000D96 83C402                   add  sp, 2
  2753                                  
  2754                                  ;-408   } while (ifEOL(DOS_ByteRead) == 0);
  2755                                  
  2756                                  .getLine91:
  2757 00000D99 A0[2200]                 mov al, byte [DOS_ByteRead]
  2758 00000D9C B400                     mov ah, 0
  2759 00000D9E 50                       push ax
  2760 00000D9F E81CFF                   call ifEOL
  2761 00000DA2 83C402                   add  sp, 2
  2762 00000DA5 3C00                     cmp al, 0
  2763 00000DA7 0F850200                 jne .getLine92
  2764 00000DAB EB90                     jmp .getLine88
  2765                                  .getLine92:
  2766                                  
  2767                                  ;-409   InputPtr--;
  2768                                  
  2769 00000DAD FF0E[1400]               dec  word[InputPtr]
  2770                                  
  2771                                  ;-410   *InputPtr=0;
  2772                                  
  2773 00000DB1 B80000                   mov ax, 0
  2774 00000DB4 8B1E[1400]               mov  bx, [InputPtr]
  2775 00000DB8 8807                     mov  [bx], al
  2776                                  
  2777                                  ;-411 }
  2778                                  
  2779                                  
  2780                                  ;-412 int skipBlank() {
  2781                                  
  2782 00000DBA C9                       .retngetLine: LEAVE
  2783 00000DBB C3                       ret
  2784 00000DBC 52656164696E672053-     getLine_0 db "Reading Source",0
  2785 00000DC5 6F7572636500       
  2786 00000DCB 696E707574206C696E-     getLine_1 db "input line too long",0
  2787 00000DD4 6520746F6F206C6F6E-
  2788 00000DDD 6700               
  2789                                  ENDP
  2790                                  
  2791                                  skipBlank: PROC
  2792                                  
  2793                                  ;-413   skipblank1:
  2794                                  
  2795                                  .skipblank1:
  2796                                  
  2797                                  ;-414     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  2798                                  
  2799 00000DDF 8B1E[1400]               mov bx, [InputPtr]
  2800 00000DE3 8A07                     mov al, [bx]
  2801 00000DE5 B400                     mov ah, 0
  2802 00000DE7 83F820                   cmp ax, 32
  2803 00000DEA 0F850600                 jne .skipBlank93
  2804 00000DEE FF06[1400]               inc  word[InputPtr]
  2805 00000DF2 EBEB                     jmp .skipblank1
  2806                                  
  2807                                  ;-415     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  2808                                  
  2809                                  .skipBlank93:
  2810 00000DF4 8B1E[1400]               mov bx, [InputPtr]
  2811 00000DF8 8A07                     mov al, [bx]
  2812 00000DFA B400                     mov ah, 0
  2813 00000DFC 83F809                   cmp ax, 9
  2814 00000DFF 0F850600                 jne .skipBlank94
  2815 00000E03 FF06[1400]               inc  word[InputPtr]
  2816 00000E07 EBD6                     jmp .skipblank1
  2817                                  
  2818                                  ;-416 }
  2819                                  
  2820                                  .skipBlank94:
  2821                                  
  2822                                  ;-417 
  2823                                  
  2824                                  
  2825                                  ;-418 int getDigit(unsigned char c) {//ret: SymbolInt
  2826                                  
  2827 00000E09 C3                       ret
  2828                                  ENDP
  2829                                  
  2830                                  getDigit: PROC
  2831                                  
  2832                                  ;-419   unsigned int CastInt;
  2833                                  
  2834                                  
  2835                                  ;-420   SymbolInt=0;
  2836                                  
  2837                                  ;Function : getDigit, Number of local variables: 2
  2838                                  ;   # type sign width addr used name   list of local variables
  2839                                  ;  200 var unsg byte   418 NULL c = bp+4
  2840                                  ;  201 var unsg word   419 NULL CastInt = bp-2;
  2841 00000E0A C8020000                 ENTER  2,0
  2842 00000E0E B80000                   mov ax, 0
  2843 00000E11 A3[0E00]                 mov word [SymbolInt], ax
  2844                                  
  2845                                  ;-421   do {
  2846                                  
  2847                                  .getDigit95:
  2848                                  
  2849                                  ;-422     c-='0';
  2850                                  
  2851 00000E14 806E0430                 sub  byte[bp+4], 48
  2852                                  
  2853                                  ;-423     SymbolInt=SymbolInt*10;
  2854                                  
  2855 00000E18 A1[0E00]                 mov ax, [SymbolInt]
  2856 00000E1B BB0A00                   mov bx, 10
  2857 00000E1E F7E3                     mul bx
  2858 00000E20 A3[0E00]                 mov word [SymbolInt], ax
  2859                                  
  2860                                  ;-424     ax=0; CastInt=c; //cast b2w
  2861                                  
  2862 00000E23 B80000                   mov  ax, 0
  2863 00000E26 8A4604                   mov al, [bp+4]
  2864 00000E29 8946FE                   mov [bp-2], ax
  2865                                  
  2866                                  ;-425     SymbolInt=SymbolInt+CastInt;
  2867                                  
  2868 00000E2C A1[0E00]                 mov ax, [SymbolInt]
  2869 00000E2F 0346FE                   add ax, [bp-2]
  2870 00000E32 A3[0E00]                 mov word [SymbolInt], ax
  2871                                  
  2872                                  ;-426     InputPtr++;
  2873                                  
  2874 00000E35 FF06[1400]               inc  word[InputPtr]
  2875                                  
  2876                                  ;-427     c = *InputPtr;
  2877                                  
  2878 00000E39 8B1E[1400]               mov bx, [InputPtr]
  2879 00000E3D 8A07                     mov al, [bx]
  2880 00000E3F B400                     mov ah, 0
  2881 00000E41 884604                   mov [bp+4], al
  2882                                  
  2883                                  ;-428   } while(digit(c));
  2884                                  
  2885 00000E44 8A4604                   mov al, byte [bp+4]
  2886 00000E47 B400                     mov ah, 0
  2887 00000E49 50                       push ax
  2888 00000E4A E84FF3                   call digit
  2889 00000E4D 83C402                   add  sp, 2
  2890 00000E50 08C0                     or  al, al
  2891 00000E52 0F840200                 je .getDigit96
  2892 00000E56 EBBC                     jmp .getDigit95
  2893                                  .getDigit96:
  2894                                  
  2895                                  ;-429 }
  2896                                  
  2897                                  
  2898                                  ;-430 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2899 00000E58 C9                       LEAVE
  2900 00000E59 C3                       ret
  2901                                  ENDP
  2902                                  
  2903                                  getName: PROC
  2904                                  
  2905                                  ;-431   char *p; unsigned int i;
  2906                                  
  2907                                  
  2908                                  ;-432   p = &Symbol;
  2909                                  
  2910                                  ;Function : getName, Number of local variables: 3
  2911                                  ;   # type sign width addr used name   list of local variables
  2912                                  ;  200 var unsg byte   430 NULL c = bp+4
  2913                                  ;  201 ptr sign byte   431 NULL p = bp-2
  2914                                  ;  202 var unsg word   431 NULL i = bp-4;
  2915 00000E5A C8040000                 ENTER  4,0
  2916 00000E5E B83075                   mov ax, Symbol
  2917 00000E61 8946FE                   mov [bp-2], ax
  2918                                  
  2919                                  ;-433   *p = c;
  2920                                  
  2921 00000E64 8A4604                   mov al, [bp+4]
  2922 00000E67 8B5EFE                   mov  bx, [bp-2]
  2923 00000E6A 8807                     mov  [bx], al
  2924                                  
  2925                                  ;-434   p++;
  2926                                  
  2927 00000E6C FF46FE                   inc  word[bp-2]
  2928                                  
  2929                                  ;-435   while (alnumE(c)) {
  2930                                  
  2931                                  .getName97:
  2932 00000E6F 8A4604                   mov al, byte [bp+4]
  2933 00000E72 B400                     mov ah, 0
  2934 00000E74 50                       push ax
  2935 00000E75 E84EF3                   call alnumE
  2936 00000E78 83C402                   add  sp, 2
  2937 00000E7B 08C0                     or  al, al
  2938 00000E7D 0F843800                 je .getName98
  2939                                  
  2940                                  ;-436     InputPtr++;
  2941                                  
  2942 00000E81 FF06[1400]               inc  word[InputPtr]
  2943                                  
  2944                                  ;-437     c = *InputPtr;
  2945                                  
  2946 00000E85 8B1E[1400]               mov bx, [InputPtr]
  2947 00000E89 8A07                     mov al, [bx]
  2948 00000E8B B400                     mov ah, 0
  2949 00000E8D 884604                   mov [bp+4], al
  2950                                  
  2951                                  ;-438     *p = c;
  2952                                  
  2953 00000E90 8A4604                   mov al, [bp+4]
  2954 00000E93 8B5EFE                   mov  bx, [bp-2]
  2955 00000E96 8807                     mov  [bx], al
  2956                                  
  2957                                  ;-439     p++;
  2958                                  
  2959 00000E98 FF46FE                   inc  word[bp-2]
  2960                                  
  2961                                  ;-440     i = p - &Symbol;
  2962                                  
  2963 00000E9B 8B46FE                   mov ax, [bp-2]
  2964 00000E9E 2D3075                   sub ax, Symbol
  2965 00000EA1 8946FC                   mov [bp-4], ax
  2966                                  
  2967                                  ;-441     if (i >= SYMBOLMAX) errorexit("symbol too long");
  2968                                  
  2969 00000EA4 8B46FC                   mov ax, [bp-4]
  2970 00000EA7 83F81F                   cmp ax, 31 ;unsigned : 0
  2971 00000EAA 0F820900                 jb  .getName99
  2972 00000EAE 68[F90E]                 push getName_0
  2973 00000EB1 E8EDFB                   call errorexit
  2974 00000EB4 83C402                   add  sp, 2
  2975                                  
  2976                                  ;-442   }
  2977                                  
  2978                                  .getName99:
  2979                                  
  2980                                  ;-443   if (c == ':') isLabel=1; else isLabel=0;
  2981                                  
  2982 00000EB7 EBB6                     jmp .getName97
  2983                                  .getName98:
  2984 00000EB9 8A4604                   mov al, [bp+4]
  2985 00000EBC 3C3A                     cmp al, 58
  2986 00000EBE 0F850900                 jne .getName100
  2987 00000EC2 B80100                   mov ax, 1
  2988 00000EC5 A2[2B00]                 mov byte [isLabel], al
  2989 00000EC8 E90600                   jmp .getName101
  2990                                  .getName100:
  2991 00000ECB B80000                   mov ax, 0
  2992 00000ECE A2[2B00]                 mov byte [isLabel], al
  2993                                  
  2994                                  ;-444   p--;
  2995                                  
  2996                                  .getName101:
  2997 00000ED1 FF4EFE                   dec  word[bp-2]
  2998                                  
  2999                                  ;-445   *p = 0;
  3000                                  
  3001 00000ED4 B80000                   mov ax, 0
  3002 00000ED7 8B5EFE                   mov  bx, [bp-2]
  3003 00000EDA 8807                     mov  [bx], al
  3004                                  
  3005                                  ;-446   strcpy(SymbolUpper, Symbol);
  3006                                  
  3007 00000EDC 8D063075                 lea  ax, [Symbol]
  3008 00000EE0 50                       push ax
  3009 00000EE1 8D064F75                 lea  ax, [SymbolUpper]
  3010 00000EE5 50                       push ax
  3011 00000EE6 E841F3                   call strcpy
  3012 00000EE9 83C404                   add  sp, 4
  3013                                  
  3014                                  ;-447   toupper(SymbolUpper);
  3015                                  
  3016 00000EEC 8D064F75                 lea  ax, [SymbolUpper]
  3017 00000EF0 50                       push ax
  3018 00000EF1 E8DDF3                   call toupper
  3019 00000EF4 83C402                   add  sp, 2
  3020                                  
  3021                                  ;-448 }
  3022                                  
  3023                                  
  3024                                  ;-449 
  3025                                  
  3026                                  
  3027                                  ;-450 //#include "OPTABL.C"
  3028                                  
  3029                                  
  3030                                  ;-451 char I_START=0xF1;
  3031 00000EF7 C9                       LEAVE
  3032 00000EF8 C3                       ret
  3033 00000EF9 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3034 00000F02 6F206C6F6E6700     
  3035                                  ENDP
  3036 00000F09 F1                      I_START db 241
  3037                                  
  3038                                  ;-452 //OpName, 0, CodeType, OpCode1-n, F1h
  3039                                  
  3040                                  
  3041                                  ;-453 //  1:   1 byte opcode
  3042                                  
  3043                                  
  3044                                  ;-454 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};
  3045                                  
  3046 00000F0A 5055534841000160F1-     I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241
  3047 00000F13 504F5041000161F1   
  3048                                  
  3049                                  ;-455 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};
  3050                                  
  3051 00000F1B 4E4F50000190F14342-     I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241
  3052 00000F24 57000198F1         
  3053                                  
  3054                                  ;-456 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};
  3055                                  
  3056 00000F29 43574445000198F143-     I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241
  3057 00000F32 5744000199F1       
  3058                                  
  3059                                  ;-457 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};
  3060                                  
  3061 00000F38 434451000199F15741-     I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241
  3062 00000F41 495400019BF1       
  3063                                  
  3064                                  ;-458 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};
  3065                                  
  3066 00000F47 505553484600019CF1-     I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241
  3067 00000F50 504F504600019DF1   
  3068                                  
  3069                                  ;-459 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};
  3070                                  
  3071 00000F58 5341484600019EF14C-     I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241
  3072 00000F61 41484600019FF1     
  3073                                  
  3074                                  ;-460 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};
  3075                                  
  3076 00000F68 4D4F5653420001A4F1-     I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241
  3077 00000F71 4D4F5653570001A5F1 
  3078                                  
  3079                                  ;-461 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};
  3080                                  
  3081 00000F7A 434D5053420001A6F1-     I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241
  3082 00000F83 434D5053570001A7F1 
  3083                                  
  3084                                  ;-462 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};
  3085                                  
  3086 00000F8C 53544F53420001AAF1-     I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241
  3087 00000F95 53544F53570001ABF1 
  3088                                  
  3089                                  ;-463 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};
  3090                                  
  3091 00000F9E 4C4F4453420001ACF1-     I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241
  3092 00000FA7 4C4F4453570001ADF1 
  3093                                  
  3094                                  ;-464 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};
  3095                                  
  3096 00000FB0 53434153420001AEF1-     I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241
  3097 00000FB9 53434153570001AFF1 
  3098                                  
  3099                                  ;-465 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};
  3100                                  
  3101 00000FC2 4C454156450001C9F1-     I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241
  3102 00000FCB 494E54330001CCF1   
  3103                                  
  3104                                  ;-466 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};
  3105                                  
  3106 00000FD3 494E544F0001CEF149-     I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241
  3107 00000FDC 5245540001CFF1     
  3108                                  
  3109                                  ;-467 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};
  3110                                  
  3111 00000FE3 584C41540001D7F14C-     I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241
  3112 00000FEC 4F434B0001F0F1     
  3113                                  
  3114                                  ;-468 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};
  3115                                  
  3116 00000FF3 5245504E450001F2F1-     I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241
  3117 00000FFC 5245504E5A0001F2F1 
  3118                                  
  3119                                  ;-469 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};
  3120                                  
  3121 00001005 524550450001F3F152-     I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241
  3122 0000100E 45505A0001F3F1     
  3123                                  
  3124                                  ;-470 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};
  3125                                  
  3126 00001015 484C540001F4F1434C-     I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241
  3127 0000101E 430001F8F1         
  3128                                  
  3129                                  ;-471 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};
  3130                                  
  3131 00001023 5354430001F9F1434C-     I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241
  3132 0000102C 490001FAF1         
  3133                                  
  3134                                  ;-472 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};
  3135                                  
  3136 00001031 5354490001FBF1434C-     I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241
  3137 0000103A 440001FCF1         
  3138                                  
  3139                                  ;-473 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};
  3140                                  
  3141 0000103F 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
  3142                                  
  3143                                  ;-474 // 2: mem reg 16 bit
  3144                                  
  3145                                  
  3146                                  ;-475 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
  3147                                  
  3148 00001046 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
  3149                                  
  3150                                  ;-476 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
  3151                                  
  3152 0000104F 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
  3153                                  
  3154                                  ;-477 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
  3155                                  
  3156 00001058 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
  3157                                  
  3158                                  ;-478 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
  3159                                  
  3160 00001060 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
  3161                                  
  3162                                  ;-479 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
  3163                                  
  3164 00001068 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
  3165                                  
  3166                                  ;-480 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
  3167                                  
  3168 00001070 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
  3169                                  
  3170                                  ;-481 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
  3171                                  
  3172 00001079 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
  3173                                  
  3174                                  ;-482 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
  3175                                  
  3176 00001081 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
  3177                                  
  3178                                  ;-483 //  3: les, lda, lea, lss, lfs, lgs
  3179                                  
  3180                                  
  3181                                  ;-484 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
  3182                                  
  3183 0000108A 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
  3184                                  
  3185                                  ;-485 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
  3186                                  
  3187 00001091 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
  3188                                  
  3189                                  ;-486 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
  3190                                  
  3191 00001098 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
  3192                                  
  3193                                  ;-487 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
  3194                                  
  3195 0000109F 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
  3196                                  
  3197                                  ;-488 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
  3198                                  
  3199 000010A7 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
  3200                                  
  3201                                  ;-489 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
  3202                                  
  3203 000010AF 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
  3204                                  
  3205                                  ;-490 //  4: acc,imm  reg,imm  index,reg
  3206                                  
  3207                                  
  3208                                  ;-491 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
  3209                                  
  3210 000010B7 414444000400F1          I_ADD db 65,68,68,0,4,0,241
  3211                                  
  3212                                  ;-492 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
  3213                                  
  3214 000010BE 4F52000401F1            I_OR db 79,82,0,4,1,241
  3215                                  
  3216                                  ;-493 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
  3217                                  
  3218 000010C4 414443000402F1          I_ADC db 65,68,67,0,4,2,241
  3219                                  
  3220                                  ;-494 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
  3221                                  
  3222 000010CB 534242000403F1          I_SBB db 83,66,66,0,4,3,241
  3223                                  
  3224                                  ;-495 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
  3225                                  
  3226 000010D2 414E44000404F1          I_AND db 65,78,68,0,4,4,241
  3227                                  
  3228                                  ;-496 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
  3229                                  
  3230 000010D9 535542000405F1          I_SUB db 83,85,66,0,4,5,241
  3231                                  
  3232                                  ;-497 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
  3233                                  
  3234 000010E0 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
  3235                                  
  3236                                  ;-498 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
  3237                                  
  3238 000010E7 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
  3239                                  
  3240                                  ;-499 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
  3241                                  
  3242 000010EE 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
  3243 000010F7 00F1               
  3244                                  
  3245                                  ;-500 //  5: mov
  3246                                  
  3247                                  
  3248                                  ;-501 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
  3249                                  
  3250 000010F9 4D4F560005F1            I_MOV db 77,79,86,0,5,241
  3251                                  
  3252                                  ;-502 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
  3253                                  
  3254 000010FF 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
  3255                                  
  3256                                  ;-503 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
  3257                                  
  3258 00001108 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
  3259                                  
  3260                                  ;-504 //  6: single byte relative jump
  3261                                  
  3262                                  
  3263                                  ;-505 char I_JO []=  {'J','O',0,     6, 0,0xF1};
  3264                                  
  3265 00001111 4A4F000600F1            I_JO db 74,79,0,6,0,241
  3266                                  
  3267                                  ;-506 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};
  3268                                  
  3269 00001117 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
  3270                                  
  3271                                  ;-507 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};
  3272                                  
  3273 0000111E 4A42000602F14A4300-     I_JB db 74,66,0,6,2,241,74,67,0,6,2,241
  3274 00001127 0602F1             
  3275                                  
  3276                                  ;-508 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};
  3277                                  
  3278 0000112A 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
  3279                                  
  3280                                  ;-509 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};
  3281                                  
  3282 00001131 4A4145000603F14A4E-     I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241
  3283 0000113A 43000603F1         
  3284                                  
  3285                                  ;-510 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};
  3286                                  
  3287 0000113F 4A45000604F14A5A00-     I_JE db 74,69,0,6,4,241,74,90,0,6,4,241
  3288 00001148 0604F1             
  3289                                  
  3290                                  ;-511 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};
  3291                                  
  3292 0000114B 4A4E45000605F14A4E-     I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241
  3293 00001154 5A000605F1         
  3294                                  
  3295                                  ;-512 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};
  3296                                  
  3297 00001159 4A4245000606F14A4E-     I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241
  3298 00001162 41000606F1         
  3299                                  
  3300                                  ;-513 char I_JA []=  {'J','A',0,     6, 7,0xF1};
  3301                                  
  3302 00001167 4A41000607F1            I_JA db 74,65,0,6,7,241
  3303                                  
  3304                                  ;-514 char I_JS []=  {'J','S',0,     6, 8,0xF1};
  3305                                  
  3306 0000116D 4A53000608F1            I_JS db 74,83,0,6,8,241
  3307                                  
  3308                                  ;-515 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};
  3309                                  
  3310 00001173 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
  3311                                  
  3312                                  ;-516 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};
  3313                                  
  3314 0000117A 4A5000060AF14A5045-     I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241
  3315 00001183 00060AF1           
  3316                                  
  3317                                  ;-517 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};
  3318                                  
  3319 00001187 4A4E5000060BF14A50-     I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241
  3320 00001190 4F00060BF1         
  3321                                  
  3322                                  ;-518 char I_JL []=  {'J','L',0,     6,12,0xF1};
  3323                                  
  3324 00001195 4A4C00060CF1            I_JL db 74,76,0,6,12,241
  3325                                  
  3326                                  ;-519 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};
  3327                                  
  3328 0000119B 4A4E4C00060DF14A47-     I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241
  3329 000011A4 4500060DF1         
  3330                                  
  3331                                  ;-520 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};
  3332                                  
  3333 000011A9 4A4C4500060EF14A4E-     I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241
  3334 000011B2 4700060EF1         
  3335                                  
  3336                                  ;-521 char I_JG []=  {'J','G',0,     6,15,0xF1};
  3337                                  
  3338 000011B7 4A4700060FF1            I_JG db 74,71,0,6,15,241
  3339                                  
  3340                                  ;-522 //  7: jmp, call
  3341                                  
  3342                                  
  3343                                  ;-523 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
  3344                                  
  3345 000011BD 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
  3346                                  
  3347                                  ;-524 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
  3348                                  
  3349 000011C5 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
  3350                                  
  3351                                  ;-525 //  8: ret
  3352                                  
  3353                                  
  3354                                  ;-526 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
  3355                                  
  3356 000011CE 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
  3357                                  
  3358                                  ;-527 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
  3359                                  
  3360 000011D6 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
  3361                                  
  3362                                  ;-528 //  9: seg, r/m
  3363                                  
  3364                                  
  3365                                  ;-529 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
  3366                                  
  3367 000011DF 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
  3368 000011E8 06F1               
  3369                                  
  3370                                  ;-530 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
  3371                                  
  3372 000011EA 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
  3373 000011F3 F1                 
  3374                                  
  3375                                  ;-531 //  11: shift, rotates
  3376                                  
  3377                                  
  3378                                  ;-532 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};
  3379                                  
  3380 000011F4 524F4C000B00F1524F-     I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241
  3381 000011FD 52000B01F1         
  3382                                  
  3383                                  ;-533 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};
  3384                                  
  3385 00001202 52434C000B02F15243-     I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241
  3386 0000120B 52000B03F1         
  3387                                  
  3388                                  ;-534 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};
  3389                                  
  3390 00001210 53484C000B04F15341-     I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241
  3391 00001219 4C000B04F1         
  3392                                  
  3393                                  ;-535 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};
  3394                                  
  3395 0000121E 534852000B05F15341-     I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241
  3396 00001227 52000B07F1         
  3397                                  
  3398                                  ;-536 //  12: int
  3399                                  
  3400                                  
  3401                                  ;-537 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
  3402                                  
  3403 0000122C 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
  3404                                  
  3405                                  ;-538 //  14: in/out
  3406                                  
  3407                                  
  3408                                  ;-539 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
  3409                                  
  3410 00001234 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
  3411                                  
  3412                                  ;-540 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
  3413                                  
  3414 0000123B 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
  3415                                  
  3416                                  ;-541 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
  3417                                  
  3418 00001243 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
  3419                                  
  3420                                  ;-542 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
  3421                                  
  3422 0000124B 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
  3423                                  
  3424                                  ;-543 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
  3425                                  
  3426 00001253 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
  3427                                  
  3428                                  ;-544 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
  3429                                  
  3430 0000125B 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
  3431                                  
  3432                                  ;-545 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
  3433                                  
  3434 00001263 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
  3435                                  
  3436                                  ;-546 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
  3437                                  
  3438 0000126B 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
  3439                                  
  3440                                  ;-547 //  15: xchg
  3441                                  
  3442                                  
  3443                                  ;-548 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
  3444                                  
  3445 00001273 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
  3446                                  
  3447                                  ;-549 //  16: loop, jcxz
  3448                                  
  3449                                  
  3450                                  ;-550 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
  3451                                  
  3452 0000127C 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
  3453 00001285 F1                 
  3454                                  
  3455                                  ;-551 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
  3456                                  
  3457 00001286 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
  3458 0000128F F1                 
  3459                                  
  3460                                  ;-552 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
  3461                                  
  3462 00001290 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
  3463                                  
  3464                                  ;-553 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
  3465                                  
  3466 00001299 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
  3467                                  
  3468                                  ;-554 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
  3469                                  
  3470 000012A2 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
  3471                                  
  3472                                  ;-555 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
  3473                                  
  3474 000012AA 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
  3475                                  
  3476                                  ;-556 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
  3477                                  
  3478 000012B2 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
  3479                                  
  3480                                  ;-557 //  30: enter
  3481                                  
  3482                                  
  3483                                  ;-558 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
  3484                                  
  3485 000012BB 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
  3486                                  
  3487                                  ;-559 // 100: directives
  3488                                  
  3489                                  
  3490                                  ;-560 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
  3491                                  
  3492 000012C3 4F52470065F1            I_ORG db 79,82,71,0,101,241
  3493                                  
  3494                                  ;-561 // section, segment .TEXT .DATA .BSS
  3495                                  
  3496                                  
  3497                                  ;-562 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
  3498                                  
  3499 000012C9 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
  3500 000012D2 F1                 
  3501                                  
  3502                                  ;-563 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
  3503                                  
  3504 000012D3 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
  3505 000012DC F1                 
  3506                                  
  3507                                  ;-564 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
  3508                                  
  3509 000012DD 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
  3510 000012E6 6EF1               
  3511                                  
  3512                                  ;-565 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
  3513                                  
  3514 000012E8 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
  3515                                  
  3516                                  ;-566 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
  3517                                  
  3518 000012EF 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
  3519                                  
  3520                                  ;-567 char I_DB[]=   {'D','B',0,            200,        0xF1};
  3521                                  
  3522 000012F6 444200C8F1              I_DB db 68,66,0,200,241
  3523                                  
  3524                                  ;-568 char I_DW[]=   {'D','W',0,            201,        0xF1};
  3525                                  
  3526 000012FB 445700C9F1              I_DW db 68,87,0,201,241
  3527                                  
  3528                                  ;-569 char I_DD[]=   {'D','D',0,            202,        0xF1};
  3529                                  
  3530 00001300 444400CAF1              I_DD db 68,68,0,202,241
  3531                                  
  3532                                  ;-570 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
  3533                                  
  3534 00001305 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
  3535                                  
  3536                                  ;-571 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
  3537                                  
  3538 0000130C 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
  3539                                  
  3540                                  ;-572 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
  3541                                  
  3542 00001313 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
  3543                                  
  3544                                  ;-573 char I_END=0;// end of table char
  3545                                  
  3546 0000131A 00                      I_END db 0
  3547                                  
  3548                                  ;-574 
  3549                                  
  3550                                  
  3551                                  ;-575 int lookCode() {//ret: CodeType, *OpCodePtr
  3552                                  
  3553                                  
  3554                                  lookCode: PROC
  3555                                  
  3556                                  ;-576     CodeType=0;
  3557                                  
  3558 0000131B B80000                   mov ax, 0
  3559 0000131E A2[2F00]                 mov byte [CodeType], al
  3560                                  
  3561                                  ;-577     OpCodePtr= &I_START;
  3562                                  
  3563 00001321 B8[090F]                 mov ax, I_START
  3564 00001324 A3[4300]                 mov word [OpCodePtr], ax
  3565                                  
  3566                                  ;-578     OpCodePtr++;
  3567                                  
  3568 00001327 FF06[4300]               inc  word[OpCodePtr]
  3569                                  
  3570                                  ;-579     do  {
  3571                                  
  3572                                  .lookCode102:
  3573                                  
  3574                                  ;-580         if (eqstr(SymbolUpper, OpCodePtr))  {
  3575                                  
  3576 0000132B FF36[4300]               push word [OpCodePtr]
  3577 0000132F 8D064F75                 lea  ax, [SymbolUpper]
  3578 00001333 50                       push ax
  3579 00001334 E829EF                   call eqstr
  3580 00001337 83C404                   add  sp, 4
  3581 0000133A 08C0                     or  al, al
  3582 0000133C 0F842700                 je .lookCode103
  3583                                  
  3584                                  ;-581             while(*OpCodePtr!=0) OpCodePtr++;
  3585                                  
  3586                                  .lookCode104:
  3587 00001340 8B1E[4300]               mov bx, [OpCodePtr]
  3588 00001344 8A07                     mov al, [bx]
  3589 00001346 B400                     mov ah, 0
  3590 00001348 83F800                   cmp ax, 0
  3591 0000134B 0F840600                 je  .lookCode105
  3592 0000134F FF06[4300]               inc  word[OpCodePtr]
  3593                                  
  3594                                  ;-582             OpCodePtr++;
  3595                                  
  3596 00001353 EBEB                     jmp .lookCode104
  3597                                  .lookCode105:
  3598 00001355 FF06[4300]               inc  word[OpCodePtr]
  3599                                  
  3600                                  ;-583             CodeType =*OpCodePtr;
  3601                                  
  3602 00001359 8B1E[4300]               mov bx, [OpCodePtr]
  3603 0000135D 8A07                     mov al, [bx]
  3604 0000135F B400                     mov ah, 0
  3605 00001361 A2[2F00]                 mov byte [CodeType], al
  3606                                  
  3607                                  ;-584             return;
  3608                                  
  3609 00001364 E92A00                   jmp .retnlookCode
  3610                                  
  3611                                  ;-585         }
  3612                                  
  3613                                  
  3614                                  ;-586     while(*OpCodePtr!=0xF1) OpCodePtr++;
  3615                                  
  3616                                  .lookCode103:
  3617                                  .lookCode106:
  3618 00001367 8B1E[4300]               mov bx, [OpCodePtr]
  3619 0000136B 8A07                     mov al, [bx]
  3620 0000136D B400                     mov ah, 0
  3621 0000136F 3DF100                   cmp ax, 241
  3622 00001372 0F840600                 je  .lookCode107
  3623 00001376 FF06[4300]               inc  word[OpCodePtr]
  3624                                  
  3625                                  ;-587     OpCodePtr++;
  3626                                  
  3627 0000137A EBEB                     jmp .lookCode106
  3628                                  .lookCode107:
  3629 0000137C FF06[4300]               inc  word[OpCodePtr]
  3630                                  
  3631                                  ;-588     } while(*OpCodePtr!=0);
  3632                                  
  3633 00001380 8B1E[4300]               mov bx, [OpCodePtr]
  3634 00001384 8A07                     mov al, [bx]
  3635 00001386 B400                     mov ah, 0
  3636 00001388 83F800                   cmp ax, 0
  3637 0000138B 0F840200                 je  .lookCode108
  3638 0000138F EB9A                     jmp .lookCode102
  3639                                  .lookCode108:
  3640                                  
  3641                                  ;-589 }
  3642                                  
  3643                                  
  3644                                  ;-590 
  3645                                  
  3646                                  
  3647                                  ;-591 int genCode8(char c) {
  3648                                  
  3649                                   .retnlookCode:
  3650 00001391 C3                       ret
  3651                                  ENDP
  3652                                  
  3653                                  genCode8: PROC
  3654                                  
  3655                                  ;-592 //set: BinLen++, OpPrintIndex++
  3656                                  
  3657                                  
  3658                                  ;-593     FileBin[BinLen]=c;
  3659                                  
  3660                                  ;Function : genCode8, Number of local variables: 1
  3661                                  ;   # type sign width addr used name   list of local variables
  3662                                  ;  200 var sign byte   591 NULL c = bp+4;
  3663 00001392 C8000000                 ENTER  0,0
  3664 00001396 8A4604                   mov al, [bp+4]
  3665 00001399 8B1E[5800]               mov bx, [BinLen]
  3666 0000139D 8887AAA4                 mov [FileBin+bx], al
  3667                                  
  3668                                  ;-594     BinLen++;
  3669                                  
  3670 000013A1 FF06[5800]               inc  word[BinLen]
  3671                                  
  3672                                  ;-595     PC++;
  3673                                  
  3674 000013A5 FF06[2300]               inc  word[PC]
  3675                                  
  3676                                  ;-596     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  3677                                  
  3678 000013A9 A1[5800]                 mov ax, [BinLen]
  3679 000013AC 3D6842                   cmp ax, 17000 ;unsigned : 0
  3680 000013AF 0F820900                 jb  .genCode8109
  3681 000013B3 68[D713]                 push genCode8_0
  3682 000013B6 E8E8F6                   call errorexit
  3683 000013B9 83C402                   add  sp, 2
  3684                                  
  3685                                  ;-597     if (OpPrintIndex < OPMAXLEN) {
  3686                                  
  3687                                  .genCode8109:
  3688 000013BC A1[4100]                 mov ax, [OpPrintIndex]
  3689 000013BF 83F805                   cmp ax, 5
  3690 000013C2 0F8D0F00                 jge .genCode8110
  3691                                  
  3692                                  ;-598         OpPos[OpPrintIndex]=c;
  3693                                  
  3694 000013C6 8A4604                   mov al, [bp+4]
  3695 000013C9 8B1E[4100]               mov bx, [OpPrintIndex]
  3696 000013CD 88875577                 mov [OpPos+bx], al
  3697                                  
  3698                                  ;-599         OpPrintIndex++;
  3699                                  
  3700 000013D1 FF06[4100]               inc  word[OpPrintIndex]
  3701                                  
  3702                                  ;-600     }
  3703                                  
  3704                                  
  3705                                  ;-601 }
  3706                                  
  3707                                  .genCode8110:
  3708                                  
  3709                                  ;-602 int gen66h() {genCode8(0x66);
  3710 000013D5 C9                       LEAVE
  3711 000013D6 C3                       ret
  3712 000013D7 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  3713 000013E0 746F6F206C6F6E6700 
  3714                                  ENDP
  3715                                  
  3716                                  gen66h: PROC
  3717 000013E9 6A66                     push 102
  3718 000013EB E8A4FF                   call genCode8
  3719 000013EE 83C402                   add  sp, 2
  3720                                  
  3721                                  ;-603 }
  3722                                  
  3723                                  
  3724                                  ;-604 int genCode2(char c, char d) {
  3725                                  
  3726 000013F1 C3                       ret
  3727                                  ENDP
  3728                                  
  3729                                  genCode2: PROC
  3730                                  
  3731                                  ;-605     c = c + d;
  3732                                  
  3733                                  ;Function : genCode2, Number of local variables: 2
  3734                                  ;   # type sign width addr used name   list of local variables
  3735                                  ;  200 var sign byte   604 NULL c = bp+4
  3736                                  ;  201 var sign byte   604 NULL d = bp+6;
  3737 000013F2 C8000000                 ENTER  0,0
  3738 000013F6 8A4604                   mov al, [bp+4]
  3739 000013F9 024606                   add al, [bp+6]
  3740 000013FC 884604                   mov [bp+4], al
  3741                                  
  3742                                  ;-606     genCode8(c);
  3743                                  
  3744 000013FF 8A4604                   mov al, byte [bp+4]
  3745 00001402 B400                     mov ah, 0
  3746 00001404 50                       push ax
  3747 00001405 E88AFF                   call genCode8
  3748 00001408 83C402                   add  sp, 2
  3749                                  
  3750                                  ;-607 }
  3751                                  
  3752                                  
  3753                                  ;-608 int genCodeW(char c) {
  3754 0000140B C9                       LEAVE
  3755 0000140C C3                       ret
  3756                                  ENDP
  3757                                  
  3758                                  genCodeW: PROC
  3759                                  
  3760                                  ;-609     c = c + wflag;
  3761                                  
  3762                                  ;Function : genCodeW, Number of local variables: 1
  3763                                  ;   # type sign width addr used name   list of local variables
  3764                                  ;  200 var sign byte   608 NULL c = bp+4;
  3765 0000140D C8000000                 ENTER  0,0
  3766 00001411 8A4604                   mov al, [bp+4]
  3767 00001414 0206[3800]               add al, [wflag]
  3768 00001418 884604                   mov [bp+4], al
  3769                                  
  3770                                  ;-610     genCode8(c);
  3771                                  
  3772 0000141B 8A4604                   mov al, byte [bp+4]
  3773 0000141E B400                     mov ah, 0
  3774 00001420 50                       push ax
  3775 00001421 E86EFF                   call genCode8
  3776 00001424 83C402                   add  sp, 2
  3777                                  
  3778                                  ;-611 }
  3779                                  
  3780                                  
  3781                                  ;-612 int genCode16(unsigned int i) {
  3782 00001427 C9                       LEAVE
  3783 00001428 C3                       ret
  3784                                  ENDP
  3785                                  
  3786                                  genCode16: PROC
  3787                                  
  3788                                  ;-613     genCode8(i); i=i >> 8;
  3789                                  
  3790                                  ;Function : genCode16, Number of local variables: 1
  3791                                  ;   # type sign width addr used name   list of local variables
  3792                                  ;  200 var unsg word   612 NULL i = bp+4;
  3793 00001429 C8000000                 ENTER  0,0
  3794 0000142D FF7604                   push word [bp+4]
  3795 00001430 E85FFF                   call genCode8
  3796 00001433 83C402                   add  sp, 2
  3797 00001436 8B4604                   mov ax, [bp+4]
  3798 00001439 C1E808                   shr ax, 8
  3799 0000143C 894604                   mov [bp+4], ax
  3800                                  
  3801                                  ;-614     genCode8(i);
  3802                                  
  3803 0000143F FF7604                   push word [bp+4]
  3804 00001442 E84DFF                   call genCode8
  3805 00001445 83C402                   add  sp, 2
  3806                                  
  3807                                  ;-615 }
  3808                                  
  3809                                  
  3810                                  ;-616 int genCode32(unsigned long L) {
  3811 00001448 C9                       LEAVE
  3812 00001449 C3                       ret
  3813                                  ENDP
  3814                                  
  3815                                  genCode32: PROC
  3816                                  
  3817                                  ;-617     genCode16(L); L=L >>16;
  3818                                  
  3819                                  ;Function : genCode32, Number of local variables: 1
  3820                                  ;   # type sign width addr used name   list of local variables
  3821                                  ;  200 var unsg dwrd   616 NULL L = bp+4;
  3822 0000144A C8000000                 ENTER  0,0
  3823 0000144E 8A4604                   mov al, byte [bp+4]
  3824 00001451 B400                     mov ah, 0
  3825 00001453 50                       push ax
  3826 00001454 E8D2FF                   call genCode16
  3827 00001457 83C402                   add  sp, 2
  3828 0000145A 668B4604                 mov eax, [bp+4]
  3829 0000145E 66C1E810                 shr eax, 16
  3830 00001462 66894604                 mov [bp+4], eax
  3831                                  
  3832                                  ;-618     genCode16(L);
  3833                                  
  3834 00001466 8A4604                   mov al, byte [bp+4]
  3835 00001469 B400                     mov ah, 0
  3836 0000146B 50                       push ax
  3837 0000146C E8BAFF                   call genCode16
  3838 0000146F 83C402                   add  sp, 2
  3839                                  
  3840                                  ;-619 }
  3841                                  
  3842                                  
  3843                                  ;-620 int writeEA(char xxx) {//value for reg/operand
  3844 00001472 C9                       LEAVE
  3845 00001473 C3                       ret
  3846                                  ENDP
  3847                                  
  3848                                  writeEA: PROC
  3849                                  
  3850                                  ;-621 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  3851                                  
  3852                                  
  3853                                  ;-622 //mod-bits: mode76, reg/opcode543, r/m210
  3854                                  
  3855                                  
  3856                                  ;-623 //Op: 0, IMM, REG, ADR, MEM
  3857                                  
  3858                                  
  3859                                  ;-624     char len;
  3860                                  
  3861                                  
  3862                                  ;-625     len=0;
  3863                                  
  3864                                  ;Function : writeEA, Number of local variables: 2
  3865                                  ;   # type sign width addr used name   list of local variables
  3866                                  ;  200 var sign byte   620 NULL xxx = bp+4
  3867                                  ;  201 var sign byte   624 NULL len = bp-2;
  3868 00001474 C8020000                 ENTER  2,0
  3869 00001478 B80000                   mov ax, 0
  3870 0000147B 8846FE                   mov [bp-2], al
  3871                                  
  3872                                  ;-626     xxx = xxx << 3;//in reg/opcode field
  3873                                  
  3874 0000147E 8A4604                   mov al, [bp+4]
  3875 00001481 C0E003                   shl al, 3
  3876 00001484 884604                   mov [bp+4], al
  3877                                  
  3878                                  ;-627     if (Op == REG) {
  3879                                  
  3880 00001487 A0[2D00]                 mov al, [Op]
  3881 0000148A 3C02                     cmp al, 2
  3882 0000148C 0F853A00                 jne .writeEA111
  3883                                  
  3884                                  ;-628         xxx |= 0xC0;
  3885                                  
  3886 00001490 804E04C0                 or  byte[bp+4], 192
  3887                                  
  3888                                  ;-629         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  3889                                  
  3890 00001494 A0[2E00]                 mov al, [Op2]
  3891 00001497 3C01                     cmp al, 1
  3892 00001499 0F8F0D00                 jg  .writeEA112
  3893 0000149D 8A4604                   mov al, [bp+4]
  3894 000014A0 0206[3400]               add al, [R1No]
  3895 000014A4 884604                   mov [bp+4], al
  3896                                  
  3897                                  ;-630             else {
  3898                                  
  3899 000014A7 E92000                   jmp .writeEA113
  3900                                  .writeEA112:
  3901                                  
  3902                                  ;-631                 if (Op2 == REG) xxx = xxx + R1No;
  3903                                  
  3904 000014AA A0[2E00]                 mov al, [Op2]
  3905 000014AD 3C02                     cmp al, 2
  3906 000014AF 0F850D00                 jne .writeEA114
  3907 000014B3 8A4604                   mov al, [bp+4]
  3908 000014B6 0206[3400]               add al, [R1No]
  3909 000014BA 884604                   mov [bp+4], al
  3910                                  
  3911                                  ;-632                 else            xxx = xxx + R2No;
  3912                                  
  3913 000014BD E90A00                   jmp .writeEA115
  3914                                  .writeEA114:
  3915 000014C0 8A4604                   mov al, [bp+4]
  3916 000014C3 0206[3300]               add al, [R2No]
  3917 000014C7 884604                   mov [bp+4], al
  3918                                  
  3919                                  ;-633             }
  3920                                  
  3921                                  .writeEA115:
  3922                                  
  3923                                  ;-634         }
  3924                                  
  3925                                  .writeEA113:
  3926                                  
  3927                                  ;-635     if (Op == MEM) {
  3928                                  
  3929                                  .writeEA111:
  3930 000014CA A0[2D00]                 mov al, [Op]
  3931 000014CD 3C04                     cmp al, 4
  3932 000014CF 0F857300                 jne .writeEA116
  3933                                  
  3934                                  ;-636         if (isDirect) {
  3935                                  
  3936 000014D3 A0[3C00]                 mov al, [isDirect]
  3937 000014D6 08C0                     or  al, al
  3938 000014D8 0F840D00                 je .writeEA117
  3939                                  
  3940                                  ;-637             xxx |= 6;
  3941                                  
  3942 000014DC 804E0406                 or  byte[bp+4], 6
  3943                                  
  3944                                  ;-638             len = 2;
  3945                                  
  3946 000014E0 B80200                   mov ax, 2
  3947 000014E3 8846FE                   mov [bp-2], al
  3948                                  
  3949                                  ;-639         }
  3950                                  
  3951                                  
  3952                                  ;-640         else {
  3953                                  
  3954 000014E6 E95D00                   jmp .writeEA118
  3955                                  .writeEA117:
  3956                                  
  3957                                  ;-641             xxx = xxx + rm;
  3958                                  
  3959 000014E9 8A4604                   mov al, [bp+4]
  3960 000014EC 0206[3B00]               add al, [rm]
  3961 000014F0 884604                   mov [bp+4], al
  3962                                  
  3963                                  ;-642             if (rm == 6) {//make [BP+00]
  3964                                  
  3965 000014F3 A0[3B00]                 mov al, [rm]
  3966 000014F6 3C06                     cmp al, 6
  3967 000014F8 0F851400                 jne .writeEA119
  3968                                  
  3969                                  ;-643                 len=1;
  3970                                  
  3971 000014FC B80100                   mov ax, 1
  3972 000014FF 8846FE                   mov [bp-2], al
  3973                                  
  3974                                  ;-644                 if (disp == 0) xxx |= 0x40;
  3975                                  
  3976 00001502 A1[3D00]                 mov ax, [disp]
  3977 00001505 83F800                   cmp ax, 0
  3978 00001508 0F850400                 jne .writeEA120
  3979 0000150C 804E0440                 or  byte[bp+4], 64
  3980                                  
  3981                                  ;-645             }
  3982                                  
  3983                                  .writeEA120:
  3984                                  
  3985                                  ;-646 
  3986                                  
  3987                                  
  3988                                  ;-647             if (disp) {
  3989                                  
  3990                                  .writeEA119:
  3991 00001510 A1[3D00]                 mov ax, [disp]
  3992 00001513 08C0                     or  al, al
  3993 00001515 0F842D00                 je .writeEA121
  3994                                  
  3995                                  ;-648                 ax = disp;
  3996                                  
  3997 00001519 A1[3D00]                 mov  ax, [disp]
  3998                                  
  3999                                  ;-649                 if(ax > 127) len=2;
  4000                                  
  4001 0000151C 83F87F                   cmp  ax, 127
  4002 0000151F 0F8E0900                 jle .writeEA122
  4003 00001523 B80200                   mov ax, 2
  4004 00001526 8846FE                   mov [bp-2], al
  4005                                  
  4006                                  ;-650                 else len=1;
  4007                                  
  4008 00001529 E90600                   jmp .writeEA123
  4009                                  .writeEA122:
  4010 0000152C B80100                   mov ax, 1
  4011 0000152F 8846FE                   mov [bp-2], al
  4012                                  
  4013                                  ;-651                 if (len == 1) xxx |= 0x40;
  4014                                  
  4015                                  .writeEA123:
  4016 00001532 8A46FE                   mov al, [bp-2]
  4017 00001535 3C01                     cmp al, 1
  4018 00001537 0F850700                 jne .writeEA124
  4019 0000153B 804E0440                 or  byte[bp+4], 64
  4020                                  
  4021                                  ;-652                 else xxx |= 0x80;
  4022                                  
  4023 0000153F E90400                   jmp .writeEA125
  4024                                  .writeEA124:
  4025 00001542 804E0480                 or  byte[bp+4], 128
  4026                                  
  4027                                  ;-653             }
  4028                                  
  4029                                  .writeEA125:
  4030                                  
  4031                                  ;-654         }
  4032                                  
  4033                                  .writeEA121:
  4034                                  
  4035                                  ;-655     }
  4036                                  
  4037                                  .writeEA118:
  4038                                  
  4039                                  ;-656 
  4040                                  
  4041                                  
  4042                                  ;-657     genCode8(xxx);// gen second byte
  4043                                  
  4044                                  .writeEA116:
  4045 00001546 8A4604                   mov al, byte [bp+4]
  4046 00001549 B400                     mov ah, 0
  4047 0000154B 50                       push ax
  4048 0000154C E843FE                   call genCode8
  4049 0000154F 83C402                   add  sp, 2
  4050                                  
  4051                                  ;-658     if (len == 1) genCode8 (disp);
  4052                                  
  4053 00001552 8A46FE                   mov al, [bp-2]
  4054 00001555 3C01                     cmp al, 1
  4055 00001557 0F850A00                 jne .writeEA126
  4056 0000155B FF36[3D00]               push word [disp]
  4057 0000155F E830FE                   call genCode8
  4058 00001562 83C402                   add  sp, 2
  4059                                  
  4060                                  ;-659     if (len == 2) genCode16(disp);
  4061                                  
  4062                                  .writeEA126:
  4063 00001565 8A46FE                   mov al, [bp-2]
  4064 00001568 3C02                     cmp al, 2
  4065 0000156A 0F850A00                 jne .writeEA127
  4066 0000156E FF36[3D00]               push word [disp]
  4067 00001572 E8B4FE                   call genCode16
  4068 00001575 83C402                   add  sp, 2
  4069                                  
  4070                                  ;-660 }
  4071                                  
  4072                                  .writeEA127:
  4073                                  
  4074                                  ;-661 
  4075                                  
  4076                                  
  4077                                  ;-662 int genImmediate() {
  4078 00001578 C9                       LEAVE
  4079 00001579 C3                       ret
  4080                                  ENDP
  4081                                  
  4082                                  genImmediate: PROC
  4083                                  
  4084                                  ;-663     if (wflag) if (OpSize == DWORD) genCode32(imme);
  4085                                  
  4086 0000157A A0[3800]                 mov al, [wflag]
  4087 0000157D 08C0                     or  al, al
  4088 0000157F 0F842300                 je .genImmediate128
  4089 00001583 A0[3700]                 mov al, [OpSize]
  4090 00001586 3C03                     cmp al, 3
  4091 00001588 0F850D00                 jne .genImmediate129
  4092 0000158C FF36[3F00]               push word [imme]
  4093 00001590 E8B7FE                   call genCode32
  4094 00001593 83C402                   add  sp, 2
  4095                                  
  4096                                  ;-664         //todo imme long
  4097                                  
  4098                                  
  4099                                  ;-665         else genCode16(imme);
  4100                                  
  4101 00001596 E90A00                   jmp .genImmediate130
  4102                                  .genImmediate129:
  4103 00001599 FF36[3F00]               push word [imme]
  4104 0000159D E889FE                   call genCode16
  4105 000015A0 83C402                   add  sp, 2
  4106                                  
  4107                                  ;-666     else       genCode8 (imme);
  4108                                  
  4109                                  .genImmediate130:
  4110 000015A3 E90A00                   jmp .genImmediate131
  4111                                  .genImmediate128:
  4112 000015A6 FF36[3F00]               push word [imme]
  4113 000015AA E8E5FD                   call genCode8
  4114 000015AD 83C402                   add  sp, 2
  4115                                  
  4116                                  ;-667 }
  4117                                  
  4118                                  .genImmediate131:
  4119                                  
  4120                                  ;-668 
  4121                                  
  4122                                  
  4123                                  ;-669 int setwflag() {//word size, bit 0
  4124                                  
  4125 000015B0 C3                       ret
  4126                                  ENDP
  4127                                  
  4128                                  setwflag: PROC
  4129                                  
  4130                                  ;-670     wflag=0;
  4131                                  
  4132 000015B1 B80000                   mov ax, 0
  4133 000015B4 A2[3800]                 mov byte [wflag], al
  4134                                  
  4135                                  ;-671     if (OpSize == 0) {//do not override OpSize
  4136                                  
  4137 000015B7 A0[3700]                 mov al, [OpSize]
  4138 000015BA 3C00                     cmp al, 0
  4139 000015BC 0F853C00                 jne .setwflag132
  4140                                  
  4141                                  ;-672         if (Op == REG) OpSize=R1Type;
  4142                                  
  4143 000015C0 A0[2D00]                 mov al, [Op]
  4144 000015C3 3C02                     cmp al, 2
  4145 000015C5 0F850600                 jne .setwflag133
  4146 000015C9 A0[3600]                 mov al, [R1Type]
  4147 000015CC A2[3700]                 mov byte [OpSize], al
  4148                                  
  4149                                  ;-673         if (Op2== REG) OpSize=R2Type;
  4150                                  
  4151                                  .setwflag133:
  4152 000015CF A0[2E00]                 mov al, [Op2]
  4153 000015D2 3C02                     cmp al, 2
  4154 000015D4 0F850600                 jne .setwflag134
  4155 000015D8 A0[3500]                 mov al, [R2Type]
  4156 000015DB A2[3700]                 mov byte [OpSize], al
  4157                                  
  4158                                  ;-674         if (R2Type== SEGREG) OpSize=WORD;
  4159                                  
  4160                                  .setwflag134:
  4161 000015DE A0[3500]                 mov al, [R2Type]
  4162 000015E1 3C04                     cmp al, 4
  4163 000015E3 0F850600                 jne .setwflag135
  4164 000015E7 B80200                   mov ax, 2
  4165 000015EA A2[3700]                 mov byte [OpSize], al
  4166                                  
  4167                                  ;-675         if (R1Type == SEGREG) OpSize=WORD;
  4168                                  
  4169                                  .setwflag135:
  4170 000015ED A0[3600]                 mov al, [R1Type]
  4171 000015F0 3C04                     cmp al, 4
  4172 000015F2 0F850600                 jne .setwflag136
  4173 000015F6 B80200                   mov ax, 2
  4174 000015F9 A2[3700]                 mov byte [OpSize], al
  4175                                  
  4176                                  ;-676     }
  4177                                  
  4178                                  .setwflag136:
  4179                                  
  4180                                  ;-677     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  4181                                  
  4182                                  .setwflag132:
  4183 000015FC A0[3700]                 mov al, [OpSize]
  4184 000015FF 3C03                     cmp al, 3
  4185 00001601 0F850900                 jne .setwflag137
  4186 00001605 E8E1FD                   call gen66h
  4187 00001608 B80100                   mov ax, 1
  4188 0000160B A2[3800]                 mov byte [wflag], al
  4189                                  
  4190                                  ;-678     if (OpSize  ==  WORD) wflag=1;
  4191                                  
  4192                                  .setwflag137:
  4193 0000160E A0[3700]                 mov al, [OpSize]
  4194 00001611 3C02                     cmp al, 2
  4195 00001613 0F850600                 jne .setwflag138
  4196 00001617 B80100                   mov ax, 1
  4197 0000161A A2[3800]                 mov byte [wflag], al
  4198                                  
  4199                                  ;-679 }
  4200                                  
  4201                                  .setwflag138:
  4202                                  
  4203                                  ;-680 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
  4204                                  
  4205 0000161D C3                       ret
  4206                                  ENDP
  4207                                  
  4208                                  setsflag: PROC
  4209                                  
  4210                                  ;-681     unsigned int ui;
  4211                                  
  4212                                  
  4213                                  ;-682     sflag=2;
  4214                                  
  4215                                  ;Function : setsflag, Number of local variables: 1
  4216                                  ;   # type sign width addr used name   list of local variables
  4217                                  ;  200 var unsg word   681 NULL ui = bp-2;
  4218 0000161E C8020000                 ENTER  2,0
  4219 00001622 B80200                   mov ax, 2
  4220 00001625 A2[3A00]                 mov byte [sflag], al
  4221                                  
  4222                                  ;-683     ui = imme & 0xFF80;//is greater than signed 127?
  4223                                  
  4224 00001628 A1[3F00]                 mov ax, [imme]
  4225 0000162B 2580FF                   and ax, 65408
  4226 0000162E 8946FE                   mov [bp-2], ax
  4227                                  
  4228                                  ;-684     if(ui != 0) sflag = 0;
  4229                                  
  4230 00001631 8B46FE                   mov ax, [bp-2]
  4231 00001634 83F800                   cmp ax, 0
  4232 00001637 0F840600                 je  .setsflag139
  4233 0000163B B80000                   mov ax, 0
  4234 0000163E A2[3A00]                 mov byte [sflag], al
  4235                                  
  4236                                  ;-685     if (OpSize == BYTE) {
  4237                                  
  4238                                  .setsflag139:
  4239 00001641 A0[3700]                 mov al, [OpSize]
  4240 00001644 3C01                     cmp al, 1
  4241 00001646 0F851900                 jne .setsflag140
  4242                                  
  4243                                  ;-686         if (imme > 255) error1("too big for byte r/m");
  4244                                  
  4245 0000164A A1[3F00]                 mov ax, [imme]
  4246 0000164D 3DFF00                   cmp ax, 255
  4247 00001650 0F8E0900                 jle .setsflag141
  4248 00001654 68[6516]                 push setsflag_0
  4249 00001657 E8F0F3                   call error1
  4250 0000165A 83C402                   add  sp, 2
  4251                                  
  4252                                  ;-687         sflag=0;//byte reg does not need sign extended
  4253                                  
  4254                                  .setsflag141:
  4255 0000165D B80000                   mov ax, 0
  4256 00001660 A2[3A00]                 mov byte [sflag], al
  4257                                  
  4258                                  ;-688     }
  4259                                  
  4260                                  
  4261                                  ;-689 }
  4262                                  
  4263                                  .setsflag140:
  4264                                  
  4265                                  ;-690 int checkConstSize(unsigned int ui) {
  4266 00001663 C9                       LEAVE
  4267 00001664 C3                       ret
  4268 00001665 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  4269 0000166E 6F7220627974652072-
  4270 00001677 2F6D00             
  4271                                  ENDP
  4272                                  
  4273                                  checkConstSize: PROC
  4274                                  
  4275                                  ;-691     if (ui > 127   ) return 0;//is near; return sflag
  4276                                  
  4277                                  ;Function : checkConstSize, Number of local variables: 1
  4278                                  ;   # type sign width addr used name   list of local variables
  4279                                  ;  200 var unsg word   690 NULL ui = bp+4;
  4280 0000167A C8000000                 ENTER  0,0
  4281 0000167E 8B4604                   mov ax, [bp+4]
  4282 00001681 83F87F                   cmp ax, 127
  4283 00001684 0F8E0600                 jle .checkConstSize142
  4284 00001688 B80000                   mov ax, 0
  4285 0000168B E91600                   jmp .retncheckConstSize
  4286                                  
  4287                                  ;-692     if (ui < 0xFF80) return 0;//-128dez
  4288                                  
  4289                                  .checkConstSize142:
  4290 0000168E 8B4604                   mov ax, [bp+4]
  4291 00001691 3D80FF                   cmp ax, 65408
  4292 00001694 0F8D0600                 jge .checkConstSize143
  4293 00001698 B80000                   mov ax, 0
  4294 0000169B E90600                   jmp .retncheckConstSize
  4295                                  
  4296                                  ;-693     return 2;// is short
  4297                                  
  4298                                  .checkConstSize143:
  4299 0000169E B80200                   mov ax, 2
  4300 000016A1 E90000                   jmp .retncheckConstSize
  4301                                  
  4302                                  ;-694 }
  4303                                  
  4304                                  
  4305                                  ;-695 
  4306                                  
  4307                                  
  4308                                  ;-696 
  4309                                  
  4310                                  
  4311                                  ;-697 int ChangeDirection() {
  4312                                  
  4313 000016A4 C9                       .retncheckConstSize: LEAVE
  4314 000016A5 C3                       ret
  4315                                  ENDP
  4316                                  
  4317                                  ChangeDirection: PROC
  4318                                  
  4319                                  ;-698     char c;
  4320                                  
  4321                                  
  4322                                  ;-699     c=Op;     Op    =Op2;    Op2   =c;
  4323                                  
  4324                                  ;Function : ChangeDirection, Number of local variables: 1
  4325                                  ;   # type sign width addr used name   list of local variables
  4326                                  ;  200 var sign byte   698 NULL c = bp-2;
  4327 000016A6 C8020000                 ENTER  2,0
  4328 000016AA A0[2D00]                 mov al, [Op]
  4329 000016AD 8846FE                   mov [bp-2], al
  4330 000016B0 A0[2E00]                 mov al, [Op2]
  4331 000016B3 A2[2D00]                 mov byte [Op], al
  4332 000016B6 8A46FE                   mov al, [bp-2]
  4333 000016B9 A2[2E00]                 mov byte [Op2], al
  4334                                  
  4335                                  ;-700     c=R1Type; R1Type=R2Type; R2Type=c;
  4336                                  
  4337 000016BC A0[3600]                 mov al, [R1Type]
  4338 000016BF 8846FE                   mov [bp-2], al
  4339 000016C2 A0[3500]                 mov al, [R2Type]
  4340 000016C5 A2[3600]                 mov byte [R1Type], al
  4341 000016C8 8A46FE                   mov al, [bp-2]
  4342 000016CB A2[3500]                 mov byte [R2Type], al
  4343                                  
  4344                                  ;-701     c=R1No;   R1No  =R2No;   R2No  =c;
  4345                                  
  4346 000016CE A0[3400]                 mov al, [R1No]
  4347 000016D1 8846FE                   mov [bp-2], al
  4348 000016D4 A0[3300]                 mov al, [R2No]
  4349 000016D7 A2[3400]                 mov byte [R1No], al
  4350 000016DA 8A46FE                   mov al, [bp-2]
  4351 000016DD A2[3300]                 mov byte [R2No], al
  4352                                  
  4353                                  ;-702     dflag=2;
  4354                                  
  4355 000016E0 B80200                   mov ax, 2
  4356 000016E3 A2[3900]                 mov byte [dflag], al
  4357                                  
  4358                                  ;-703 }
  4359                                  
  4360                                  
  4361                                  ;-704 
  4362                                  
  4363                                  
  4364                                  ;-705 int getTokeType() {
  4365 000016E6 C9                       LEAVE
  4366 000016E7 C3                       ret
  4367                                  ENDP
  4368                                  
  4369                                  getTokeType: PROC
  4370                                  
  4371                                  ;-706     char c;
  4372                                  
  4373                                  
  4374                                  ;-707     skipBlank();
  4375                                  
  4376                                  ;Function : getTokeType, Number of local variables: 1
  4377                                  ;   # type sign width addr used name   list of local variables
  4378                                  ;  200 var sign byte   706 NULL c = bp-2;
  4379 000016E8 C8020000                 ENTER  2,0
  4380 000016EC E8F0F6                   call skipBlank
  4381                                  
  4382                                  ;-708     c = *InputPtr;
  4383                                  
  4384 000016EF 8B1E[1400]               mov bx, [InputPtr]
  4385 000016F3 8A07                     mov al, [bx]
  4386 000016F5 B400                     mov ah, 0
  4387 000016F7 8846FE                   mov [bp-2], al
  4388                                  
  4389                                  ;-709     if (c == 0)   {TokeType=0; return; }//last line or empty line
  4390                                  
  4391 000016FA 8A46FE                   mov al, [bp-2]
  4392 000016FD 3C00                     cmp al, 0
  4393 000016FF 0F850900                 jne .getTokeType144
  4394 00001703 B80000                   mov ax, 0
  4395 00001706 A2[2C00]                 mov byte [TokeType], al
  4396 00001709 E96600                   jmp .retngetTokeType
  4397                                  
  4398                                  ;-710     if (c == ';') {TokeType=0; return; }//comment
  4399                                  
  4400                                  .getTokeType144:
  4401 0000170C 8A46FE                   mov al, [bp-2]
  4402 0000170F 3C3B                     cmp al, 59
  4403 00001711 0F850900                 jne .getTokeType145
  4404 00001715 B80000                   mov ax, 0
  4405 00001718 A2[2C00]                 mov byte [TokeType], al
  4406 0000171B E95400                   jmp .retngetTokeType
  4407                                  
  4408                                  ;-711     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  4409                                  
  4410                                  .getTokeType145:
  4411 0000171E 8A46FE                   mov al, byte [bp-2]
  4412 00001721 B400                     mov ah, 0
  4413 00001723 50                       push ax
  4414 00001724 E875EA                   call digit
  4415 00001727 83C402                   add  sp, 2
  4416 0000172A 08C0                     or  al, al
  4417 0000172C 0F841500                 je .getTokeType146
  4418 00001730 8A46FE                   mov al, byte [bp-2]
  4419 00001733 B400                     mov ah, 0
  4420 00001735 50                       push ax
  4421 00001736 E8D1F6                   call getDigit
  4422 00001739 83C402                   add  sp, 2
  4423 0000173C B80100                   mov ax, 1
  4424 0000173F A2[2C00]                 mov byte [TokeType], al
  4425 00001742 E92D00                   jmp .retngetTokeType
  4426                                  
  4427                                  ;-712     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  4428                                  
  4429                                  .getTokeType146:
  4430 00001745 8A46FE                   mov al, byte [bp-2]
  4431 00001748 B400                     mov ah, 0
  4432 0000174A 50                       push ax
  4433 0000174B E8D0E9                   call letterE
  4434 0000174E 83C402                   add  sp, 2
  4435 00001751 08C0                     or  al, al
  4436 00001753 0F841500                 je .getTokeType147
  4437 00001757 8A46FE                   mov al, byte [bp-2]
  4438 0000175A B400                     mov ah, 0
  4439 0000175C 50                       push ax
  4440 0000175D E8FAF6                   call getName
  4441 00001760 83C402                   add  sp, 2
  4442 00001763 B80300                   mov ax, 3
  4443 00001766 A2[2C00]                 mov byte [TokeType], al
  4444 00001769 E90600                   jmp .retngetTokeType
  4445                                  
  4446                                  ;-713     TokeType=NOALNUME;
  4447                                  
  4448                                  .getTokeType147:
  4449 0000176C B80400                   mov ax, 4
  4450 0000176F A2[2C00]                 mov byte [TokeType], al
  4451                                  
  4452                                  ;-714 }
  4453                                  
  4454                                  
  4455                                  ;-715 
  4456                                  
  4457                                  
  4458                                  ;-716 int isToken(char c) {
  4459                                  
  4460 00001772 C9                       .retngetTokeType: LEAVE
  4461 00001773 C3                       ret
  4462                                  ENDP
  4463                                  
  4464                                  isToken: PROC
  4465                                  
  4466                                  ;-717     skipBlank();
  4467                                  
  4468                                  ;Function : isToken, Number of local variables: 1
  4469                                  ;   # type sign width addr used name   list of local variables
  4470                                  ;  200 var sign byte   716 NULL c = bp+4;
  4471 00001774 C8000000                 ENTER  0,0
  4472 00001778 E864F6                   call skipBlank
  4473                                  
  4474                                  ;-718     if (*InputPtr == c) {
  4475                                  
  4476 0000177B 8B1E[1400]               mov bx, [InputPtr]
  4477 0000177F 8A07                     mov al, [bx]
  4478 00001781 B400                     mov ah, 0
  4479 00001783 3A4604                   cmp al, [bp+4]
  4480 00001786 0F850A00                 jne .isToken148
  4481                                  
  4482                                  ;-719         InputPtr++;
  4483                                  
  4484 0000178A FF06[1400]               inc  word[InputPtr]
  4485                                  
  4486                                  ;-720         return 1;
  4487                                  
  4488 0000178E B80100                   mov ax, 1
  4489 00001791 E90600                   jmp .retnisToken
  4490                                  
  4491                                  ;-721         }
  4492                                  
  4493                                  
  4494                                  ;-722     return 0;
  4495                                  
  4496                                  .isToken148:
  4497 00001794 B80000                   mov ax, 0
  4498 00001797 E90000                   jmp .retnisToken
  4499                                  
  4500                                  ;-723 }
  4501                                  
  4502                                  
  4503                                  ;-724 
  4504                                  
  4505                                  
  4506                                  ;-725 
  4507                                  
  4508                                  
  4509                                  ;-726 int need(char c) {
  4510                                  
  4511 0000179A C9                       .retnisToken: LEAVE
  4512 0000179B C3                       ret
  4513                                  ENDP
  4514                                  
  4515                                  need: PROC
  4516                                  
  4517                                  ;-727     if (isToken(c)) {
  4518                                  
  4519                                  ;Function : need, Number of local variables: 1
  4520                                  ;   # type sign width addr used name   list of local variables
  4521                                  ;  200 var sign byte   726 NULL c = bp+4;
  4522 0000179C C8000000                 ENTER  0,0
  4523 000017A0 8A4604                   mov al, byte [bp+4]
  4524 000017A3 B400                     mov ah, 0
  4525 000017A5 50                       push ax
  4526 000017A6 E8CBFF                   call isToken
  4527 000017A9 83C402                   add  sp, 2
  4528 000017AC 08C0                     or  al, al
  4529 000017AE 0F840600                 je .need149
  4530                                  
  4531                                  ;-728         getTokeType();
  4532                                  
  4533 000017B2 E833FF                   call getTokeType
  4534                                  
  4535                                  ;-729         return;
  4536                                  
  4537 000017B5 E91800                   jmp .retnneed
  4538                                  
  4539                                  ;-730         }
  4540                                  
  4541                                  
  4542                                  ;-731     error1();
  4543                                  
  4544                                  .need149:
  4545 000017B8 E88FF2                   call error1
  4546                                  
  4547                                  ;-732     prs(". need: ");
  4548                                  
  4549 000017BB 68[D217]                 push need_0
  4550 000017BE E872EF                   call prs
  4551 000017C1 83C402                   add  sp, 2
  4552                                  
  4553                                  ;-733     prc(c);
  4554                                  
  4555 000017C4 8A4604                   mov al, byte [bp+4]
  4556 000017C7 B400                     mov ah, 0
  4557 000017C9 50                       push ax
  4558 000017CA E80EEF                   call prc
  4559 000017CD 83C402                   add  sp, 2
  4560                                  
  4561                                  ;-734 }
  4562                                  
  4563                                  
  4564                                  ;-735 int skipRest() {
  4565                                  
  4566 000017D0 C9                       .retnneed: LEAVE
  4567 000017D1 C3                       ret
  4568 000017D2 2E206E6565643A2000      need_0 db ". need: ",0
  4569                                  ENDP
  4570                                  
  4571                                  skipRest: PROC
  4572                                  
  4573                                  ;-736     getTokeType();
  4574                                  
  4575 000017DB E80AFF                   call getTokeType
  4576                                  
  4577                                  ;-737     if(TokeType)error1("extra char ignored");
  4578                                  
  4579 000017DE A0[2C00]                 mov al, [TokeType]
  4580 000017E1 08C0                     or  al, al
  4581 000017E3 0F840900                 je .skipRest150
  4582 000017E7 68[F117]                 push skipRest_0
  4583 000017EA E85DF2                   call error1
  4584 000017ED 83C402                   add  sp, 2
  4585                                  
  4586                                  ;-738 }
  4587                                  
  4588                                  .skipRest150:
  4589                                  
  4590                                  ;-739 
  4591                                  
  4592                                  
  4593                                  ;-740 
  4594                                  
  4595                                  
  4596                                  ;-741 int checkOpL() {
  4597                                  
  4598 000017F0 C3                       ret
  4599 000017F1 657874726120636861-     skipRest_0 db "extra char ignored",0
  4600 000017FA 722069676E6F726564-
  4601 00001803 00                 
  4602                                  ENDP
  4603                                  
  4604                                  checkOpL: PROC
  4605                                  
  4606                                  ;-742     if (Op == ADR) implerror();
  4607                                  
  4608 00001804 A0[2D00]                 mov al, [Op]
  4609 00001807 3C03                     cmp al, 3
  4610 00001809 0F850300                 jne .checkOpL151
  4611 0000180D E84CF3                   call implerror
  4612                                  
  4613                                  ;-743     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  4614                                  
  4615                                  .checkOpL151:
  4616 00001810 A0[3600]                 mov al, [R1Type]
  4617 00001813 3C04                     cmp al, 4
  4618 00001815 0F850600                 jne .checkOpL152
  4619 00001819 E808F4                   call segregerror
  4620 0000181C E93E00                   jmp .retncheckOpL
  4621                                  
  4622                                  ;-744     setwflag();
  4623                                  
  4624                                  .checkOpL152:
  4625 0000181F E88FFD                   call setwflag
  4626                                  
  4627                                  ;-745     if (OpSize == 0) error1("no op size declared");
  4628                                  
  4629 00001822 A0[3700]                 mov al, [OpSize]
  4630 00001825 3C00                     cmp al, 0
  4631 00001827 0F850900                 jne .checkOpL153
  4632 0000182B 68[5E18]                 push checkOpL_0
  4633 0000182E E819F2                   call error1
  4634 00001831 83C402                   add  sp, 2
  4635                                  
  4636                                  ;-746     if (OpSize == R1Type) return;
  4637                                  
  4638                                  .checkOpL153:
  4639 00001834 A0[3700]                 mov al, [OpSize]
  4640 00001837 3A06[3600]               cmp al, [R1Type]
  4641 0000183B 0F850300                 jne .checkOpL154
  4642 0000183F E91B00                   jmp .retncheckOpL
  4643                                  
  4644                                  ;-747     if (Op == REG) if (R1Type==0) error1("no register defined");
  4645                                  
  4646                                  .checkOpL154:
  4647 00001842 A0[2D00]                 mov al, [Op]
  4648 00001845 3C02                     cmp al, 2
  4649 00001847 0F851200                 jne .checkOpL155
  4650 0000184B A0[3600]                 mov al, [R1Type]
  4651 0000184E 3C00                     cmp al, 0
  4652 00001850 0F850900                 jne .checkOpL156
  4653 00001854 68[7218]                 push checkOpL_1
  4654 00001857 E8F0F1                   call error1
  4655 0000185A 83C402                   add  sp, 2
  4656                                  
  4657                                  ;-748 }
  4658                                  
  4659                                  .checkOpL156:
  4660                                  .checkOpL155:
  4661                                  
  4662                                  ;-749 
  4663                                  
  4664                                  
  4665                                  ;-750 int searchLabel() {
  4666                                  
  4667                                   .retncheckOpL:
  4668 0000185D C3                       ret
  4669 0000185E 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  4670 00001867 65206465636C617265-
  4671 00001870 6400               
  4672 00001872 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  4673 0000187B 657220646566696E65-
  4674 00001884 6400               
  4675                                  ENDP
  4676                                  
  4677                                  searchLabel: PROC
  4678                                  
  4679                                  ;-751     int LIx; char *p;
  4680                                  
  4681                                  
  4682                                  ;-752     p = &LabelNames;
  4683                                  
  4684                                  ;Function : searchLabel, Number of local variables: 2
  4685                                  ;   # type sign width addr used name   list of local variables
  4686                                  ;  200 var sign word   751 NULL LIx = bp-2
  4687                                  ;  201 ptr sign byte   751 NULL p = bp-4;
  4688 00001886 C8040000                 ENTER  4,0
  4689 0000188A B85A77                   mov ax, LabelNames
  4690 0000188D 8946FC                   mov [bp-4], ax
  4691                                  
  4692                                  ;-753     LIx = 1;
  4693                                  
  4694 00001890 B80100                   mov ax, 1
  4695 00001893 8946FE                   mov [bp-2], ax
  4696                                  
  4697                                  ;-754     while (LIx <= LabelMaxIx) {
  4698                                  
  4699                                  .searchLabel157:
  4700 00001896 8B46FE                   mov ax, [bp-2]
  4701 00001899 3B06[4A00]               cmp ax, [LabelMaxIx]
  4702 0000189D 0F8F3100                 jg  .searchLabel158
  4703                                  
  4704                                  ;-755         if (eqstr(p, Symbol)) return LIx;//pos of label
  4705                                  
  4706 000018A1 8D063075                 lea  ax, [Symbol]
  4707 000018A5 50                       push ax
  4708 000018A6 FF76FC                   push word [bp-4]
  4709 000018A9 E8B4E9                   call eqstr
  4710 000018AC 83C404                   add  sp, 4
  4711 000018AF 08C0                     or  al, al
  4712 000018B1 0F840600                 je .searchLabel159
  4713 000018B5 8B46FE                   mov ax, [bp-2]
  4714 000018B8 E91D00                   jmp .retnsearchLabel
  4715                                  
  4716                                  ;-756         p=strlen(p) + p;
  4717                                  
  4718                                  .searchLabel159:
  4719 000018BB FF76FC                   push word [bp-4]
  4720 000018BE E841E9                   call strlen
  4721 000018C1 83C402                   add  sp, 2
  4722 000018C4 0346FC                   add ax, [bp-4]
  4723 000018C7 8946FC                   mov [bp-4], ax
  4724                                  
  4725                                  ;-757         p++;
  4726                                  
  4727 000018CA FF46FC                   inc  word[bp-4]
  4728                                  
  4729                                  ;-758         LIx++;
  4730                                  
  4731 000018CD FF46FE                   inc  word[bp-2]
  4732                                  
  4733                                  ;-759     }
  4734                                  
  4735                                  
  4736                                  ;-760     return 0;
  4737                                  
  4738 000018D0 EBC4                     jmp .searchLabel157
  4739                                  .searchLabel158:
  4740 000018D2 B80000                   mov ax, 0
  4741 000018D5 E90000                   jmp .retnsearchLabel
  4742                                  
  4743                                  ;-761 }
  4744                                  
  4745                                  
  4746                                  ;-762 
  4747                                  
  4748                                  
  4749                                  ;-763 int getOp1() {//scan for a single operand
  4750                                  
  4751 000018D8 C9                       .retnsearchLabel: LEAVE
  4752 000018D9 C3                       ret
  4753                                  ENDP
  4754                                  
  4755                                  getOp1: PROC
  4756                                  
  4757                                  ;-764 //return:0, IMM, REG, ADR (not MEM)
  4758                                  
  4759                                  
  4760                                  ;-765 //set   :R2Type, R2No by testReg
  4761                                  
  4762                                  
  4763                                  ;-766 //set   :LabelIx by searchLabel
  4764                                  
  4765                                  
  4766                                  ;-767     if (TokeType == 0)      return 0;
  4767                                  
  4768 000018DA A0[2C00]                 mov al, [TokeType]
  4769 000018DD 3C00                     cmp al, 0
  4770 000018DF 0F850600                 jne .getOp1160
  4771 000018E3 B80000                   mov ax, 0
  4772 000018E6 E93F00                   jmp .retngetOp1
  4773                                  
  4774                                  ;-768     if (TokeType == DIGIT)  return IMM;
  4775                                  
  4776                                  .getOp1160:
  4777 000018E9 A0[2C00]                 mov al, [TokeType]
  4778 000018EC 3C01                     cmp al, 1
  4779 000018EE 0F850600                 jne .getOp1161
  4780 000018F2 B80100                   mov ax, 1
  4781 000018F5 E93000                   jmp .retngetOp1
  4782                                  
  4783                                  ;-769     if (TokeType == ALNUME) {
  4784                                  
  4785                                  .getOp1161:
  4786 000018F8 A0[2C00]                 mov al, [TokeType]
  4787 000018FB 3C03                     cmp al, 3
  4788 000018FD 0F852100                 jne .getOp1162
  4789                                  
  4790                                  ;-770         R2No=testReg();
  4791                                  
  4792 00001901 E810EA                   call testReg
  4793 00001904 A2[3300]                 mov byte [R2No], al
  4794                                  
  4795                                  ;-771         if (R2Type)        return REG;
  4796                                  
  4797 00001907 A0[3500]                 mov al, [R2Type]
  4798 0000190A 08C0                     or  al, al
  4799 0000190C 0F840600                 je .getOp1163
  4800 00001910 B80200                   mov ax, 2
  4801 00001913 E91200                   jmp .retngetOp1
  4802                                  
  4803                                  ;-772         LabelIx=searchLabel();
  4804                                  
  4805                                  .getOp1163:
  4806 00001916 E86DFF                   call searchLabel
  4807 00001919 A3[4E00]                 mov word [LabelIx], ax
  4808                                  
  4809                                  ;-773         return ADR;
  4810                                  
  4811 0000191C B80300                   mov ax, 3
  4812 0000191F E90600                   jmp .retngetOp1
  4813                                  
  4814                                  ;-774     }
  4815                                  
  4816                                  
  4817                                  ;-775     return 0;
  4818                                  
  4819                                  .getOp1162:
  4820 00001922 B80000                   mov ax, 0
  4821 00001925 E90000                   jmp .retngetOp1
  4822                                  
  4823                                  ;-776 }
  4824                                  
  4825                                  
  4826                                  ;-777 
  4827                                  
  4828                                  
  4829                                  ;-778 int getIndReg1() {
  4830                                  
  4831                                   .retngetOp1:
  4832 00001928 C3                       ret
  4833                                  ENDP
  4834                                  
  4835                                  getIndReg1: PROC
  4836                                  
  4837                                  ;-779     if (R2Type !=WORD) indexerror();
  4838                                  
  4839 00001929 A0[3500]                 mov al, [R2Type]
  4840 0000192C 3C02                     cmp al, 2
  4841 0000192E 0F840300                 je  .getIndReg1164
  4842 00001932 E841F2                   call indexerror
  4843                                  
  4844                                  ;-780     if (R2No==3) rm=7;//BX
  4845                                  
  4846                                  .getIndReg1164:
  4847 00001935 A0[3300]                 mov al, [R2No]
  4848 00001938 3C03                     cmp al, 3
  4849 0000193A 0F850600                 jne .getIndReg1165
  4850 0000193E B80700                   mov ax, 7
  4851 00001941 A2[3B00]                 mov byte [rm], al
  4852                                  
  4853                                  ;-781     if (R2No==5) rm=6;//BP, change to BP+0
  4854                                  
  4855                                  .getIndReg1165:
  4856 00001944 A0[3300]                 mov al, [R2No]
  4857 00001947 3C05                     cmp al, 5
  4858 00001949 0F850600                 jne .getIndReg1166
  4859 0000194D B80600                   mov ax, 6
  4860 00001950 A2[3B00]                 mov byte [rm], al
  4861                                  
  4862                                  ;-782     if (R2No==7) rm=5;//DI
  4863                                  
  4864                                  .getIndReg1166:
  4865 00001953 A0[3300]                 mov al, [R2No]
  4866 00001956 3C07                     cmp al, 7
  4867 00001958 0F850600                 jne .getIndReg1167
  4868 0000195C B80500                   mov ax, 5
  4869 0000195F A2[3B00]                 mov byte [rm], al
  4870                                  
  4871                                  ;-783     if (R2No==6) rm=4;//SI
  4872                                  
  4873                                  .getIndReg1167:
  4874 00001962 A0[3300]                 mov al, [R2No]
  4875 00001965 3C06                     cmp al, 6
  4876 00001967 0F850600                 jne .getIndReg1168
  4877 0000196B B80400                   mov ax, 4
  4878 0000196E A2[3B00]                 mov byte [rm], al
  4879                                  
  4880                                  ;-784     if (rm==0) indexerror();
  4881                                  
  4882                                  .getIndReg1168:
  4883 00001971 A0[3B00]                 mov al, [rm]
  4884 00001974 3C00                     cmp al, 0
  4885 00001976 0F850300                 jne .getIndReg1169
  4886 0000197A E8F9F1                   call indexerror
  4887                                  
  4888                                  ;-785 }
  4889                                  
  4890                                  .getIndReg1169:
  4891                                  
  4892                                  ;-786 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  4893                                  
  4894 0000197D C3                       ret
  4895                                  ENDP
  4896                                  
  4897                                  getIndReg2: PROC
  4898                                  ;Function : getIndReg2, Number of local variables: 1
  4899                                  ;   # type sign width addr used name   list of local variables
  4900                                  ;  200 var sign byte   786 NULL m = bp-2;
  4901 0000197E C8020000                 ENTER  2,0
  4902 00001982 B80400                   mov ax, 4
  4903 00001985 8846FE                   mov [bp-2], al
  4904                                  
  4905                                  ;-787     if (R2Type !=WORD) indexerror();
  4906                                  
  4907 00001988 A0[3500]                 mov al, [R2Type]
  4908 0000198B 3C02                     cmp al, 2
  4909 0000198D 0F840300                 je  .getIndReg2170
  4910 00001991 E8E2F1                   call indexerror
  4911                                  
  4912                                  ;-788     if (R2No==7) if (rm==6) m=3;//BP+DI
  4913                                  
  4914                                  .getIndReg2170:
  4915 00001994 A0[3300]                 mov al, [R2No]
  4916 00001997 3C07                     cmp al, 7
  4917 00001999 0F852100                 jne .getIndReg2171
  4918 0000199D A0[3B00]                 mov al, [rm]
  4919 000019A0 3C06                     cmp al, 6
  4920 000019A2 0F850900                 jne .getIndReg2172
  4921 000019A6 B80300                   mov ax, 3
  4922 000019A9 8846FE                   mov [bp-2], al
  4923                                  
  4924                                  ;-789              else if (rm==7) m=1;//BX+DI
  4925                                  
  4926 000019AC E90F00                   jmp .getIndReg2173
  4927                                  .getIndReg2172:
  4928 000019AF A0[3B00]                 mov al, [rm]
  4929 000019B2 3C07                     cmp al, 7
  4930 000019B4 0F850600                 jne .getIndReg2174
  4931 000019B8 B80100                   mov ax, 1
  4932 000019BB 8846FE                   mov [bp-2], al
  4933                                  
  4934                                  ;-790     if (R2No==6) if (rm==6) m=2;//BP+SI
  4935                                  
  4936                                  .getIndReg2174:
  4937                                  .getIndReg2173:
  4938                                  .getIndReg2171:
  4939 000019BE A0[3300]                 mov al, [R2No]
  4940 000019C1 3C06                     cmp al, 6
  4941 000019C3 0F852100                 jne .getIndReg2175
  4942 000019C7 A0[3B00]                 mov al, [rm]
  4943 000019CA 3C06                     cmp al, 6
  4944 000019CC 0F850900                 jne .getIndReg2176
  4945 000019D0 B80200                   mov ax, 2
  4946 000019D3 8846FE                   mov [bp-2], al
  4947                                  
  4948                                  ;-791              else if (rm==7) m=0;//BX+SI
  4949                                  
  4950 000019D6 E90F00                   jmp .getIndReg2177
  4951                                  .getIndReg2176:
  4952 000019D9 A0[3B00]                 mov al, [rm]
  4953 000019DC 3C07                     cmp al, 7
  4954 000019DE 0F850600                 jne .getIndReg2178
  4955 000019E2 B80000                   mov ax, 0
  4956 000019E5 8846FE                   mov [bp-2], al
  4957                                  
  4958                                  ;-792     if (m > 3) indexerror();
  4959                                  
  4960                                  .getIndReg2178:
  4961                                  .getIndReg2177:
  4962                                  .getIndReg2175:
  4963 000019E8 8A46FE                   mov al, [bp-2]
  4964 000019EB 3C03                     cmp al, 3
  4965 000019ED 0F8E0300                 jle .getIndReg2179
  4966 000019F1 E882F1                   call indexerror
  4967                                  
  4968                                  ;-793     return m;
  4969                                  
  4970                                  .getIndReg2179:
  4971 000019F4 8A46FE                   mov al, [bp-2]
  4972 000019F7 E90000                   jmp .retngetIndReg2
  4973                                  
  4974                                  ;-794 }
  4975                                  
  4976                                  
  4977                                  ;-795 int getMEM() {// e.g. [array+bp+si-4]
  4978                                  
  4979 000019FA C9                       .retngetIndReg2: LEAVE
  4980 000019FB C3                       ret
  4981                                  ENDP
  4982                                  
  4983                                  getMEM: PROC
  4984                                  
  4985                                  ;-796 //set: disp, rm, R2Type
  4986                                  
  4987                                  
  4988                                  ;-797     char c;
  4989                                  
  4990                                  
  4991                                  ;-798     disp=0; rm=0;
  4992                                  
  4993                                  ;Function : getMEM, Number of local variables: 1
  4994                                  ;   # type sign width addr used name   list of local variables
  4995                                  ;  200 var sign byte   797 NULL c = bp-2;
  4996 000019FC C8020000                 ENTER  2,0
  4997 00001A00 B80000                   mov ax, 0
  4998 00001A03 A3[3D00]                 mov word [disp], ax
  4999 00001A06 B80000                   mov ax, 0
  5000 00001A09 A2[3B00]                 mov byte [rm], al
  5001                                  
  5002                                  ;-799     do {
  5003                                  
  5004                                  .getMEM180:
  5005                                  
  5006                                  ;-800         getTokeType();
  5007                                  
  5008 00001A0C E8D9FC                   call getTokeType
  5009                                  
  5010                                  ;-801         c=getOp1();
  5011                                  
  5012 00001A0F E8C8FE                   call getOp1
  5013 00001A12 8846FE                   mov [bp-2], al
  5014                                  
  5015                                  ;-802         if (c ==   0) syntaxerror();
  5016                                  
  5017 00001A15 8A46FE                   mov al, [bp-2]
  5018 00001A18 3C00                     cmp al, 0
  5019 00001A1A 0F850300                 jne .getMEM181
  5020 00001A1E E82AF2                   call syntaxerror
  5021                                  
  5022                                  ;-803         if (c == REG) {
  5023                                  
  5024                                  .getMEM181:
  5025 00001A21 8A46FE                   mov al, [bp-2]
  5026 00001A24 3C02                     cmp al, 2
  5027 00001A26 0F851B00                 jne .getMEM182
  5028                                  
  5029                                  ;-804             isDirect=0;
  5030                                  
  5031 00001A2A B80000                   mov ax, 0
  5032 00001A2D A2[3C00]                 mov byte [isDirect], al
  5033                                  
  5034                                  ;-805             if (rm) rm=getIndReg2();
  5035                                  
  5036 00001A30 A0[3B00]                 mov al, [rm]
  5037 00001A33 08C0                     or  al, al
  5038 00001A35 0F840900                 je .getMEM183
  5039 00001A39 E842FF                   call getIndReg2
  5040 00001A3C A2[3B00]                 mov byte [rm], al
  5041                                  
  5042                                  ;-806             else getIndReg1();
  5043                                  
  5044 00001A3F E90300                   jmp .getMEM184
  5045                                  .getMEM183:
  5046 00001A42 E8E4FE                   call getIndReg1
  5047                                  
  5048                                  ;-807         }
  5049                                  
  5050                                  .getMEM184:
  5051                                  
  5052                                  ;-808         if (c == ADR) {
  5053                                  
  5054                                  .getMEM182:
  5055 00001A45 8A46FE                   mov al, [bp-2]
  5056 00001A48 3C03                     cmp al, 3
  5057 00001A4A 0F851F00                 jne .getMEM185
  5058                                  
  5059                                  ;-809             if (LabelIx)    disp=disp+LabelAddr[LabelIx];
  5060                                  
  5061 00001A4E A1[4E00]                 mov ax, [LabelIx]
  5062 00001A51 08C0                     or  al, al
  5063 00001A53 0F841300                 je .getMEM186
  5064 00001A57 A1[3D00]                 mov ax, [disp]
  5065 00001A5A 8B1E[4E00]               mov bx, [LabelIx]
  5066 00001A5E D1E3                     shl bx, 1
  5067 00001A60 0387CA8E                 add ax, [LabelAddr + bx]
  5068 00001A64 A3[3D00]                 mov word [disp], ax
  5069                                  
  5070                                  ;-810             else notfounderror();
  5071                                  
  5072 00001A67 E90300                   jmp .getMEM187
  5073                                  .getMEM186:
  5074 00001A6A E84EF0                   call notfounderror
  5075                                  
  5076                                  ;-811         }
  5077                                  
  5078                                  .getMEM187:
  5079                                  
  5080                                  ;-812         if (c == IMM) disp=disp+SymbolInt;
  5081                                  
  5082                                  .getMEM185:
  5083 00001A6D 8A46FE                   mov al, [bp-2]
  5084 00001A70 3C01                     cmp al, 1
  5085 00001A72 0F850A00                 jne .getMEM188
  5086 00001A76 A1[3D00]                 mov ax, [disp]
  5087 00001A79 0306[0E00]               add ax, [SymbolInt]
  5088 00001A7D A3[3D00]                 mov word [disp], ax
  5089                                  
  5090                                  ;-813         if (isToken('-')) {
  5091                                  
  5092                                  .getMEM188:
  5093 00001A80 6A2D                     push 45
  5094 00001A82 E8EFFC                   call isToken
  5095 00001A85 83C402                   add  sp, 2
  5096 00001A88 08C0                     or  al, al
  5097 00001A8A 0F841900                 je .getMEM189
  5098                                  
  5099                                  ;-814             getTokeType();
  5100                                  
  5101 00001A8E E857FC                   call getTokeType
  5102                                  
  5103                                  ;-815             if (TokeType != DIGIT) numbererror();
  5104                                  
  5105 00001A91 A0[2C00]                 mov al, [TokeType]
  5106 00001A94 3C01                     cmp al, 1
  5107 00001A96 0F840300                 je  .getMEM190
  5108 00001A9A E81BF1                   call numbererror
  5109                                  
  5110                                  ;-816             disp = disp - SymbolInt;
  5111                                  
  5112                                  .getMEM190:
  5113 00001A9D A1[3D00]                 mov ax, [disp]
  5114 00001AA0 2B06[0E00]               sub ax, [SymbolInt]
  5115 00001AA4 A3[3D00]                 mov word [disp], ax
  5116                                  
  5117                                  ;-817         }
  5118                                  
  5119                                  
  5120                                  ;-818     } while (isToken('+'));
  5121                                  
  5122                                  .getMEM189:
  5123 00001AA7 6A2B                     push 43
  5124 00001AA9 E8C8FC                   call isToken
  5125 00001AAC 83C402                   add  sp, 2
  5126 00001AAF 08C0                     or  al, al
  5127 00001AB1 0F840300                 je .getMEM191
  5128 00001AB5 E954FF                   jmp .getMEM180
  5129                                  .getMEM191:
  5130                                  
  5131                                  ;-819     if (isToken(']') == 0) errorexit("] expected");
  5132                                  
  5133 00001AB8 6A5D                     push 93
  5134 00001ABA E8B7FC                   call isToken
  5135 00001ABD 83C402                   add  sp, 2
  5136 00001AC0 83F800                   cmp ax, 0
  5137 00001AC3 0F850900                 jne .getMEM192
  5138 00001AC7 68[D21A]                 push getMEM_0
  5139 00001ACA E8D4EF                   call errorexit
  5140 00001ACD 83C402                   add  sp, 2
  5141                                  
  5142                                  ;-820 }
  5143                                  
  5144                                  .getMEM192:
  5145                                  
  5146                                  ;-821 
  5147                                  
  5148                                  
  5149                                  ;-822 int getOpR() {
  5150 00001AD0 C9                       LEAVE
  5151 00001AD1 C3                       ret
  5152 00001AD2 5D2065787065637465-     getMEM_0 db "] expected",0
  5153 00001ADB 6400               
  5154                                  ENDP
  5155                                  
  5156                                  getOpR: PROC
  5157                                  
  5158                                  ;-823     Op2=getOp1();
  5159                                  
  5160 00001ADD E8FAFD                   call getOp1
  5161 00001AE0 A2[2E00]                 mov byte [Op2], al
  5162                                  
  5163                                  ;-824     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  5164                                  
  5165 00001AE3 6A5B                     push 91
  5166 00001AE5 E88CFC                   call isToken
  5167 00001AE8 83C402                   add  sp, 2
  5168 00001AEB 08C0                     or  al, al
  5169 00001AED 0F840C00                 je .getOpR193
  5170 00001AF1 B80400                   mov ax, 4
  5171 00001AF4 A2[2E00]                 mov byte [Op2], al
  5172 00001AF7 E802FF                   call getMEM
  5173 00001AFA E96200                   jmp .retngetOpR
  5174                                  
  5175                                  ;-825     if (Op2 == 0)     {invaloperror();         return;}
  5176                                  
  5177                                  .getOpR193:
  5178 00001AFD A0[2E00]                 mov al, [Op2]
  5179 00001B00 3C00                     cmp al, 0
  5180 00001B02 0F850600                 jne .getOpR194
  5181 00001B06 E88EF0                   call invaloperror
  5182 00001B09 E95300                   jmp .retngetOpR
  5183                                  
  5184                                  ;-826     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  5185                                  
  5186                                  .getOpR194:
  5187 00001B0C A0[2E00]                 mov al, [Op2]
  5188 00001B0F 3C01                     cmp al, 1
  5189 00001B11 0F850900                 jne .getOpR195
  5190 00001B15 A1[0E00]                 mov ax, [SymbolInt]
  5191 00001B18 A3[3F00]                 mov word [imme], ax
  5192 00001B1B E94100                   jmp .retngetOpR
  5193                                  
  5194                                  ;-827     if (Op2 == REG)                            return;
  5195                                  
  5196                                  .getOpR195:
  5197 00001B1E A0[2E00]                 mov al, [Op2]
  5198 00001B21 3C02                     cmp al, 2
  5199 00001B23 0F850300                 jne .getOpR196
  5200 00001B27 E93500                   jmp .retngetOpR
  5201                                  
  5202                                  ;-828     if (Op2 == ADR)   {
  5203                                  
  5204                                  .getOpR196:
  5205 00001B2A A0[2E00]                 mov al, [Op2]
  5206 00001B2D 3C03                     cmp al, 3
  5207 00001B2F 0F852300                 jne .getOpR197
  5208                                  
  5209                                  ;-829         if (LabelIx == 0) disp=0;
  5210                                  
  5211 00001B33 A1[4E00]                 mov ax, [LabelIx]
  5212 00001B36 83F800                   cmp ax, 0
  5213 00001B39 0F850900                 jne .getOpR198
  5214 00001B3D B80000                   mov ax, 0
  5215 00001B40 A3[3D00]                 mov word [disp], ax
  5216                                  
  5217                                  ;-830         else disp=LabelAddr[LabelIx];
  5218                                  
  5219 00001B43 E90D00                   jmp .getOpR199
  5220                                  .getOpR198:
  5221 00001B46 8B1E[4E00]               mov bx, [LabelIx]
  5222 00001B4A D1E3                     shl bx, 1
  5223 00001B4C 8B87CA8E                 mov ax, [LabelAddr + bx]
  5224 00001B50 A3[3D00]                 mov word [disp], ax
  5225                                  
  5226                                  ;-831         return;}
  5227                                  
  5228                                  .getOpR199:
  5229 00001B53 E90900                   jmp .retngetOpR
  5230                                  
  5231                                  ;-832     error1("Name of operand expected");
  5232                                  
  5233                                  .getOpR197:
  5234 00001B56 68[601B]                 push getOpR_0
  5235 00001B59 E8EEEE                   call error1
  5236 00001B5C 83C402                   add  sp, 2
  5237                                  
  5238                                  ;-833 }
  5239                                  
  5240                                  
  5241                                  ;-834 
  5242                                  
  5243                                  
  5244                                  ;-835 int getOpL() {//set: op=0,IMM,REG,ADR,MEM
  5245                                  
  5246                                   .retngetOpR:
  5247 00001B5F C3                       ret
  5248 00001B60 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  5249 00001B69 706572616E64206578-
  5250 00001B72 70656374656400     
  5251                                  ENDP
  5252                                  
  5253                                  getOpL: PROC
  5254                                  
  5255                                  ;-836     getOpR();
  5256                                  
  5257 00001B79 E861FF                   call getOpR
  5258                                  
  5259                                  ;-837     Op=Op2;         Op2=0;
  5260                                  
  5261 00001B7C A0[2E00]                 mov al, [Op2]
  5262 00001B7F A2[2D00]                 mov byte [Op], al
  5263 00001B82 B80000                   mov ax, 0
  5264 00001B85 A2[2E00]                 mov byte [Op2], al
  5265                                  
  5266                                  ;-838     R1No=R2No;      R2No=0;
  5267                                  
  5268 00001B88 A0[3300]                 mov al, [R2No]
  5269 00001B8B A2[3400]                 mov byte [R1No], al
  5270 00001B8E B80000                   mov ax, 0
  5271 00001B91 A2[3300]                 mov byte [R2No], al
  5272                                  
  5273                                  ;-839     R1Type=R2Type;  R2Type=0;
  5274                                  
  5275 00001B94 A0[3500]                 mov al, [R2Type]
  5276 00001B97 A2[3600]                 mov byte [R1Type], al
  5277 00001B9A B80000                   mov ax, 0
  5278 00001B9D A2[3500]                 mov byte [R2Type], al
  5279                                  
  5280                                  ;-840 }
  5281                                  
  5282                                  
  5283                                  ;-841 
  5284                                  
  5285                                  
  5286                                  ;-842 int get2Ops() {
  5287                                  
  5288 00001BA0 C3                       ret
  5289                                  ENDP
  5290                                  
  5291                                  get2Ops: PROC
  5292                                  
  5293                                  ;-843     getOpL();
  5294                                  
  5295 00001BA1 E8D5FF                   call getOpL
  5296                                  
  5297                                  ;-844     need(',');
  5298                                  
  5299 00001BA4 6A2C                     push 44
  5300 00001BA6 E8F3FB                   call need
  5301 00001BA9 83C402                   add  sp, 2
  5302                                  
  5303                                  ;-845     getOpR();
  5304                                  
  5305 00001BAC E82EFF                   call getOpR
  5306                                  
  5307                                  ;-846 }
  5308                                  
  5309                                  
  5310                                  ;-847 int check2Ops() {
  5311                                  
  5312 00001BAF C3                       ret
  5313                                  ENDP
  5314                                  
  5315                                  check2Ops: PROC
  5316                                  
  5317                                  ;-848     get2Ops();
  5318                                  
  5319 00001BB0 E8EEFF                   call get2Ops
  5320                                  
  5321                                  ;-849     if (Op ==   0) addrerror();
  5322                                  
  5323 00001BB3 A0[2D00]                 mov al, [Op]
  5324 00001BB6 3C00                     cmp al, 0
  5325 00001BB8 0F850300                 jne .check2Ops200
  5326 00001BBC E85EEF                   call addrerror
  5327                                  
  5328                                  ;-850     if (Op == ADR) invaloperror();
  5329                                  
  5330                                  .check2Ops200:
  5331 00001BBF A0[2D00]                 mov al, [Op]
  5332 00001BC2 3C03                     cmp al, 3
  5333 00001BC4 0F850300                 jne .check2Ops201
  5334 00001BC8 E8CCEF                   call invaloperror
  5335                                  
  5336                                  ;-851     if (Op == IMM) immeerror();
  5337                                  
  5338                                  .check2Ops201:
  5339 00001BCB A0[2D00]                 mov al, [Op]
  5340 00001BCE 3C01                     cmp al, 1
  5341 00001BD0 0F850300                 jne .check2Ops202
  5342 00001BD4 E860EF                   call immeerror
  5343                                  
  5344                                  ;-852     if (Op2==   0) addrerror();
  5345                                  
  5346                                  .check2Ops202:
  5347 00001BD7 A0[2E00]                 mov al, [Op2]
  5348 00001BDA 3C00                     cmp al, 0
  5349 00001BDC 0F850300                 jne .check2Ops203
  5350 00001BE0 E83AEF                   call addrerror
  5351                                  
  5352                                  ;-853 //if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov,add
  5353                                  
  5354                                  
  5355                                  ;-854     setwflag();
  5356                                  
  5357                                  .check2Ops203:
  5358 00001BE3 E8CBF9                   call setwflag
  5359                                  
  5360                                  ;-855 }
  5361                                  
  5362                                  
  5363                                  ;-856 
  5364                                  
  5365                                  
  5366                                  ;-857 int storeJmp() {
  5367                                  
  5368 00001BE6 C3                       ret
  5369                                  ENDP
  5370                                  
  5371                                  storeJmp: PROC
  5372                                  
  5373                                  ;-858     unsigned int i;
  5374                                  
  5375                                  
  5376                                  ;-859     JmpMaxIx++;
  5377                                  
  5378                                  ;Function : storeJmp, Number of local variables: 1
  5379                                  ;   # type sign width addr used name   list of local variables
  5380                                  ;  200 var unsg word   858 NULL i = bp-2;
  5381 00001BE7 C8020000                 ENTER  2,0
  5382 00001BEB FF06[5400]               inc  word[JmpMaxIx]
  5383                                  
  5384                                  ;-860     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");
  5385                                  
  5386 00001BEF A1[5400]                 mov ax, [JmpMaxIx]
  5387 00001BF2 3DC800                   cmp ax, 200 ;unsigned : 1
  5388 00001BF5 0F8C0900                 jl  .storeJmp204
  5389 00001BF9 68[431C]                 push storeJmp_0
  5390 00001BFC E8A2EE                   call errorexit
  5391 00001BFF 83C402                   add  sp, 2
  5392                                  
  5393                                  ;-861     JmpNamePtr=strcpy(JmpNamePtr, Symbol);
  5394                                  
  5395                                  .storeJmp204:
  5396 00001C02 8D063075                 lea  ax, [Symbol]
  5397 00001C06 50                       push ax
  5398 00001C07 FF36[5000]               push word [JmpNamePtr]
  5399 00001C0B E81CE6                   call strcpy
  5400 00001C0E 83C404                   add  sp, 4
  5401 00001C11 A3[5000]                 mov word [JmpNamePtr], ax
  5402                                  
  5403                                  ;-862     JmpNamePtr++;
  5404                                  
  5405 00001C14 FF06[5000]               inc  word[JmpNamePtr]
  5406                                  
  5407                                  ;-863     i = JmpNamePtr - &JmpNames;
  5408                                  
  5409 00001C18 A1[5000]                 mov ax, [JmpNamePtr]
  5410 00001C1B 2D7A93                   sub ax, JmpNames
  5411 00001C1E 8946FE                   mov [bp-2], ax
  5412                                  
  5413                                  ;-864     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");
  5414                                  
  5415 00001C21 8B46FE                   mov ax, [bp-2]
  5416 00001C24 3D810F                   cmp ax, 3969 ;unsigned : 0
  5417 00001C27 0F820900                 jb  .storeJmp205
  5418 00001C2B 68[501C]                 push storeJmp_1
  5419 00001C2E E870EE                   call errorexit
  5420 00001C31 83C402                   add  sp, 2
  5421                                  
  5422                                  ;-865     JmpAddr[JmpMaxIx] = PC;
  5423                                  
  5424                                  .storeJmp205:
  5425 00001C34 A1[2300]                 mov ax, [PC]
  5426 00001C37 8B1E[5400]               mov bx, [JmpMaxIx]
  5427 00001C3B D1E3                     shl bx, 1
  5428 00001C3D 89871AA3                 mov [JmpAddr+bx], ax
  5429                                  
  5430                                  ;-866 }
  5431                                  
  5432                                  
  5433                                  ;-867 
  5434                                  
  5435                                  
  5436                                  ;-868 int storeLabel() {
  5437 00001C41 C9                       LEAVE
  5438 00001C42 C3                       ret
  5439 00001C43 746F6F206D616E7920-     storeJmp_0 db "too many Jmp",0
  5440 00001C4C 4A6D7000           
  5441 00001C50 746F6F206D616E7920-     storeJmp_1 db "too many Jmp names",0
  5442 00001C59 4A6D70206E616D6573-
  5443 00001C62 00                 
  5444                                  ENDP
  5445                                  
  5446                                  storeLabel: PROC
  5447                                  
  5448                                  ;-869     unsigned int i;
  5449                                  
  5450                                  
  5451                                  ;-870     if(searchLabel()) error1("duplicate label");
  5452                                  
  5453                                  ;Function : storeLabel, Number of local variables: 1
  5454                                  ;   # type sign width addr used name   list of local variables
  5455                                  ;  200 var unsg word   869 NULL i = bp-2;
  5456 00001C63 C8020000                 ENTER  2,0
  5457 00001C67 E81CFC                   call searchLabel
  5458 00001C6A 08C0                     or  al, al
  5459 00001C6C 0F840900                 je .storeLabel206
  5460 00001C70 68[D51C]                 push storeLabel_0
  5461 00001C73 E8D4ED                   call error1
  5462 00001C76 83C402                   add  sp, 2
  5463                                  
  5464                                  ;-871     LabelMaxIx++;
  5465                                  
  5466                                  .storeLabel206:
  5467 00001C79 FF06[4A00]               inc  word[LabelMaxIx]
  5468                                  
  5469                                  ;-872     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  5470                                  
  5471 00001C7D A1[4A00]                 mov ax, [LabelMaxIx]
  5472 00001C80 3D5802                   cmp ax, 600 ;unsigned : 1
  5473 00001C83 0F8C0900                 jl  .storeLabel207
  5474 00001C87 68[E51C]                 push storeLabel_1
  5475 00001C8A E814EE                   call errorexit
  5476 00001C8D 83C402                   add  sp, 2
  5477                                  
  5478                                  ;-873     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  5479                                  
  5480                                  .storeLabel207:
  5481 00001C90 8D063075                 lea  ax, [Symbol]
  5482 00001C94 50                       push ax
  5483 00001C95 FF36[4600]               push word [LabelNamePtr]
  5484 00001C99 E88EE5                   call strcpy
  5485 00001C9C 83C404                   add  sp, 4
  5486 00001C9F A3[4600]                 mov word [LabelNamePtr], ax
  5487                                  
  5488                                  ;-874     LabelNamePtr++;
  5489                                  
  5490 00001CA2 FF06[4600]               inc  word[LabelNamePtr]
  5491                                  
  5492                                  ;-875     i = LabelNamePtr - &LabelNames;
  5493                                  
  5494 00001CA6 A1[4600]                 mov ax, [LabelNamePtr]
  5495 00001CA9 2D5A77                   sub ax, LabelNames
  5496 00001CAC 8946FE                   mov [bp-2], ax
  5497                                  
  5498                                  ;-876     if (i >= LABELNAMESMAX) errorexit("too many label names");
  5499                                  
  5500 00001CAF 8B46FE                   mov ax, [bp-2]
  5501 00001CB2 3D5117                   cmp ax, 5969 ;unsigned : 0
  5502 00001CB5 0F820900                 jb  .storeLabel208
  5503 00001CB9 68[F51C]                 push storeLabel_2
  5504 00001CBC E8E2ED                   call errorexit
  5505 00001CBF 83C402                   add  sp, 2
  5506                                  
  5507                                  ;-877     LabelAddr[LabelMaxIx] = PC + Origin;
  5508                                  
  5509                                  .storeLabel208:
  5510 00001CC2 A1[2300]                 mov ax, [PC]
  5511 00001CC5 0306[2500]               add ax, [Origin]
  5512 00001CC9 8B1E[4A00]               mov bx, [LabelMaxIx]
  5513 00001CCD D1E3                     shl bx, 1
  5514 00001CCF 8987CA8E                 mov [LabelAddr+bx], ax
  5515                                  
  5516                                  ;-878 }
  5517                                  
  5518                                  
  5519                                  ;-879 
  5520                                  
  5521                                  
  5522                                  ;-880 
  5523                                  
  5524                                  
  5525                                  ;-881 int genDB() {
  5526 00001CD3 C9                       LEAVE
  5527 00001CD4 C3                       ret
  5528 00001CD5 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  5529 00001CDE 206C6162656C00     
  5530 00001CE5 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  5531 00001CEE 6C6162656C7300     
  5532 00001CF5 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  5533 00001CFE 6C6162656C206E616D-
  5534 00001D07 657300             
  5535                                  ENDP
  5536                                  
  5537                                  genDB: PROC
  5538                                  
  5539                                  ;-882     char c;  char isloop;
  5540                                  
  5541                                  
  5542                                  ;-883         isloop = 0;
  5543                                  
  5544                                  ;Function : genDB, Number of local variables: 2
  5545                                  ;   # type sign width addr used name   list of local variables
  5546                                  ;  200 var sign byte   882 NULL c = bp-2
  5547                                  ;  201 var sign byte   882 NULL isloop = bp-4;
  5548 00001D0A C8040000                 ENTER  4,0
  5549 00001D0E B80000                   mov ax, 0
  5550 00001D11 8846FC                   mov [bp-4], al
  5551                                  
  5552                                  ;-884             do {
  5553                                  
  5554                                  .genDB209:
  5555                                  
  5556                                  ;-885                 if (isloop) getTokeType();//omit ,  
  5557                                  
  5558 00001D14 8A46FC                   mov al, [bp-4]
  5559 00001D17 08C0                     or  al, al
  5560 00001D19 0F840300                 je .genDB210
  5561 00001D1D E8C8F9                   call getTokeType
  5562                                  
  5563                                  ;-886                 if (TokeType == DIGIT) genCode8(SymbolInt);
  5564                                  
  5565                                  .genDB210:
  5566 00001D20 A0[2C00]                 mov al, [TokeType]
  5567 00001D23 3C01                     cmp al, 1
  5568 00001D25 0F850D00                 jne .genDB211
  5569 00001D29 FF36[0E00]               push word [SymbolInt]
  5570 00001D2D E862F6                   call genCode8
  5571 00001D30 83C402                   add  sp, 2
  5572                                  
  5573                                  ;-887                 else {
  5574                                  
  5575 00001D33 E94100                   jmp .genDB212
  5576                                  .genDB211:
  5577                                  
  5578                                  ;-888                     skipBlank();
  5579                                  
  5580 00001D36 E8A6F0                   call skipBlank
  5581                                  
  5582                                  ;-889                     if (isToken('"')) {
  5583                                  
  5584 00001D39 6A22                     push 34
  5585 00001D3B E836FA                   call isToken
  5586 00001D3E 83C402                   add  sp, 2
  5587 00001D41 08C0                     or  al, al
  5588 00001D43 0F843000                 je .genDB213
  5589                                  
  5590                                  ;-890                         do {
  5591                                  
  5592                                  .genDB214:
  5593                                  
  5594                                  ;-891                             c= *InputPtr;
  5595                                  
  5596 00001D47 8B1E[1400]               mov bx, [InputPtr]
  5597 00001D4B 8A07                     mov al, [bx]
  5598 00001D4D B400                     mov ah, 0
  5599 00001D4F 8846FE                   mov [bp-2], al
  5600                                  
  5601                                  ;-892                             genCode8(c);
  5602                                  
  5603 00001D52 8A46FE                   mov al, byte [bp-2]
  5604 00001D55 B400                     mov ah, 0
  5605 00001D57 50                       push ax
  5606 00001D58 E837F6                   call genCode8
  5607 00001D5B 83C402                   add  sp, 2
  5608                                  
  5609                                  ;-893                             InputPtr++;
  5610                                  
  5611 00001D5E FF06[1400]               inc  word[InputPtr]
  5612                                  
  5613                                  ;-894                         } while (*InputPtr != '"' );
  5614                                  
  5615 00001D62 8B1E[1400]               mov bx, [InputPtr]
  5616 00001D66 8A07                     mov al, [bx]
  5617 00001D68 B400                     mov ah, 0
  5618 00001D6A 83F822                   cmp ax, 34
  5619 00001D6D 0F840200                 je  .genDB215
  5620 00001D71 EBD4                     jmp .genDB214
  5621                                  .genDB215:
  5622                                  
  5623                                  ;-895                         InputPtr++;
  5624                                  
  5625 00001D73 FF06[1400]               inc  word[InputPtr]
  5626                                  
  5627                                  ;-896                     }
  5628                                  
  5629                                  
  5630                                  ;-897                 } 
  5631                                  
  5632                                  .genDB213:
  5633                                  
  5634                                  ;-898                 isloop = 1;
  5635                                  
  5636                                  .genDB212:
  5637 00001D77 B80100                   mov ax, 1
  5638 00001D7A 8846FC                   mov [bp-4], al
  5639                                  
  5640                                  ;-899             } while (isToken(','));
  5641                                  
  5642 00001D7D 6A2C                     push 44
  5643 00001D7F E8F2F9                   call isToken
  5644 00001D82 83C402                   add  sp, 2
  5645 00001D85 08C0                     or  al, al
  5646 00001D87 0F840200                 je .genDB216
  5647 00001D8B EB87                     jmp .genDB209
  5648                                  .genDB216:
  5649                                  
  5650                                  ;-900 }
  5651                                  
  5652                                  
  5653                                  ;-901 
  5654                                  
  5655                                  
  5656                                  ;-902 int getVariable() {
  5657 00001D8D C9                       LEAVE
  5658 00001D8E C3                       ret
  5659                                  ENDP
  5660                                  
  5661                                  getVariable: PROC
  5662                                  
  5663                                  ;-903     char c;
  5664                                  
  5665                                  
  5666                                  ;-904     storeLabel();
  5667                                  
  5668                                  ;Function : getVariable, Number of local variables: 1
  5669                                  ;   # type sign width addr used name   list of local variables
  5670                                  ;  200 var sign byte   903 NULL c = bp-2;
  5671 00001D8F C8020000                 ENTER  2,0
  5672 00001D93 E8CDFE                   call storeLabel
  5673                                  
  5674                                  ;-905     getTokeType();
  5675                                  
  5676 00001D96 E84FF9                   call getTokeType
  5677                                  
  5678                                  ;-906     if(TokeType==ALNUME) {//getName
  5679                                  
  5680 00001D99 A0[2C00]                 mov al, [TokeType]
  5681 00001D9C 3C03                     cmp al, 3
  5682 00001D9E 0F857001                 jne .getVariable217
  5683                                  
  5684                                  ;-907         lookCode();
  5685                                  
  5686 00001DA2 E876F5                   call lookCode
  5687                                  
  5688                                  ;-908         if (CodeType < 200) dataexit();
  5689                                  
  5690 00001DA5 A0[2F00]                 mov al, [CodeType]
  5691 00001DA8 3CC8                     cmp al, 200
  5692 00001DAA 0F8D0300                 jge .getVariable218
  5693 00001DAE E8C5EE                   call dataexit
  5694                                  
  5695                                  ;-909         if (CodeType > 205) dataexit();
  5696                                  
  5697                                  .getVariable218:
  5698 00001DB1 A0[2F00]                 mov al, [CodeType]
  5699 00001DB4 3CCD                     cmp al, 205
  5700 00001DB6 0F8E0300                 jle .getVariable219
  5701 00001DBA E8B9EE                   call dataexit
  5702                                  
  5703                                  ;-910         if (CodeType== 200) {//DB
  5704                                  
  5705                                  .getVariable219:
  5706 00001DBD A0[2F00]                 mov al, [CodeType]
  5707 00001DC0 3CC8                     cmp al, 200
  5708 00001DC2 0F856A00                 jne .getVariable220
  5709                                  
  5710                                  ;-911             do {
  5711                                  
  5712                                  .getVariable221:
  5713                                  
  5714                                  ;-912                 getTokeType();
  5715                                  
  5716 00001DC6 E81FF9                   call getTokeType
  5717                                  
  5718                                  ;-913                 if (TokeType == DIGIT) genCode8(SymbolInt);
  5719                                  
  5720 00001DC9 A0[2C00]                 mov al, [TokeType]
  5721 00001DCC 3C01                     cmp al, 1
  5722 00001DCE 0F850D00                 jne .getVariable222
  5723 00001DD2 FF36[0E00]               push word [SymbolInt]
  5724 00001DD6 E8B9F5                   call genCode8
  5725 00001DD9 83C402                   add  sp, 2
  5726                                  
  5727                                  ;-914                 else {
  5728                                  
  5729 00001DDC E94100                   jmp .getVariable223
  5730                                  .getVariable222:
  5731                                  
  5732                                  ;-915                     skipBlank();
  5733                                  
  5734 00001DDF E8FDEF                   call skipBlank
  5735                                  
  5736                                  ;-916                     if (isToken('"')) {
  5737                                  
  5738 00001DE2 6A22                     push 34
  5739 00001DE4 E88DF9                   call isToken
  5740 00001DE7 83C402                   add  sp, 2
  5741 00001DEA 08C0                     or  al, al
  5742 00001DEC 0F843000                 je .getVariable224
  5743                                  
  5744                                  ;-917                         do {
  5745                                  
  5746                                  .getVariable225:
  5747                                  
  5748                                  ;-918                             c= *InputPtr;
  5749                                  
  5750 00001DF0 8B1E[1400]               mov bx, [InputPtr]
  5751 00001DF4 8A07                     mov al, [bx]
  5752 00001DF6 B400                     mov ah, 0
  5753 00001DF8 8846FE                   mov [bp-2], al
  5754                                  
  5755                                  ;-919                             genCode8(c);
  5756                                  
  5757 00001DFB 8A46FE                   mov al, byte [bp-2]
  5758 00001DFE B400                     mov ah, 0
  5759 00001E00 50                       push ax
  5760 00001E01 E88EF5                   call genCode8
  5761 00001E04 83C402                   add  sp, 2
  5762                                  
  5763                                  ;-920                             InputPtr++;
  5764                                  
  5765 00001E07 FF06[1400]               inc  word[InputPtr]
  5766                                  
  5767                                  ;-921                         } while (*InputPtr != '"' );
  5768                                  
  5769 00001E0B 8B1E[1400]               mov bx, [InputPtr]
  5770 00001E0F 8A07                     mov al, [bx]
  5771 00001E11 B400                     mov ah, 0
  5772 00001E13 83F822                   cmp ax, 34
  5773 00001E16 0F840200                 je  .getVariable226
  5774 00001E1A EBD4                     jmp .getVariable225
  5775                                  .getVariable226:
  5776                                  
  5777                                  ;-922                         InputPtr++;
  5778                                  
  5779 00001E1C FF06[1400]               inc  word[InputPtr]
  5780                                  
  5781                                  ;-923                     }
  5782                                  
  5783                                  
  5784                                  ;-924                 }
  5785                                  
  5786                                  .getVariable224:
  5787                                  
  5788                                  ;-925             } while (isToken(','));
  5789                                  
  5790                                  .getVariable223:
  5791 00001E20 6A2C                     push 44
  5792 00001E22 E84FF9                   call isToken
  5793 00001E25 83C402                   add  sp, 2
  5794 00001E28 08C0                     or  al, al
  5795 00001E2A 0F840200                 je .getVariable227
  5796 00001E2E EB96                     jmp .getVariable221
  5797                                  .getVariable227:
  5798                                  
  5799                                  ;-926         }
  5800                                  
  5801                                  
  5802                                  ;-927         if (CodeType == 201) {//DW
  5803                                  
  5804                                  .getVariable220:
  5805 00001E30 A0[2F00]                 mov al, [CodeType]
  5806 00001E33 3CC9                     cmp al, 201
  5807 00001E35 0F852600                 jne .getVariable228
  5808                                  
  5809                                  ;-928             do {
  5810                                  
  5811                                  .getVariable229:
  5812                                  
  5813                                  ;-929                 getTokeType();
  5814                                  
  5815 00001E39 E8ACF8                   call getTokeType
  5816                                  
  5817                                  ;-930                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  5818                                  
  5819 00001E3C A0[2C00]                 mov al, [TokeType]
  5820 00001E3F 3C01                     cmp al, 1
  5821 00001E41 0F850A00                 jne .getVariable230
  5822 00001E45 FF36[0E00]               push word [SymbolInt]
  5823 00001E49 E8DDF5                   call genCode16
  5824 00001E4C 83C402                   add  sp, 2
  5825                                  
  5826                                  ;-931             } while (isToken(','));
  5827                                  
  5828                                  .getVariable230:
  5829 00001E4F 6A2C                     push 44
  5830 00001E51 E820F9                   call isToken
  5831 00001E54 83C402                   add  sp, 2
  5832 00001E57 08C0                     or  al, al
  5833 00001E59 0F840200                 je .getVariable231
  5834 00001E5D EBDA                     jmp .getVariable229
  5835                                  .getVariable231:
  5836                                  
  5837                                  ;-932         }
  5838                                  
  5839                                  
  5840                                  ;-933         if (CodeType == 202) {//DD
  5841                                  
  5842                                  .getVariable228:
  5843 00001E5F A0[2F00]                 mov al, [CodeType]
  5844 00001E62 3CCA                     cmp al, 202
  5845 00001E64 0F852E00                 jne .getVariable232
  5846                                  
  5847                                  ;-934             do {
  5848                                  
  5849                                  .getVariable233:
  5850                                  
  5851                                  ;-935                 getTokeType();
  5852                                  
  5853 00001E68 E87DF8                   call getTokeType
  5854                                  
  5855                                  ;-936                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  5856                                  
  5857 00001E6B A0[2C00]                 mov al, [TokeType]
  5858 00001E6E 3C01                     cmp al, 1
  5859 00001E70 0F851200                 jne .getVariable234
  5860 00001E74 FF36[0E00]               push word [SymbolInt]
  5861 00001E78 E8AEF5                   call genCode16
  5862 00001E7B 83C402                   add  sp, 2
  5863                                  
  5864                                  ;-937                                     genCode16(0);}//todo genCode32(SymbolLong);
  5865                                  
  5866 00001E7E 6A00                     push 0
  5867 00001E80 E8A6F5                   call genCode16
  5868 00001E83 83C402                   add  sp, 2
  5869                                  
  5870                                  ;-938             } while (isToken(','));
  5871                                  
  5872                                  .getVariable234:
  5873 00001E86 6A2C                     push 44
  5874 00001E88 E8E9F8                   call isToken
  5875 00001E8B 83C402                   add  sp, 2
  5876 00001E8E 08C0                     or  al, al
  5877 00001E90 0F840200                 je .getVariable235
  5878 00001E94 EBD2                     jmp .getVariable233
  5879                                  .getVariable235:
  5880                                  
  5881                                  ;-939         }
  5882                                  
  5883                                  
  5884                                  ;-940         if (CodeType >= 203) {//resb, resw, resd
  5885                                  
  5886                                  .getVariable232:
  5887 00001E96 A0[2F00]                 mov al, [CodeType]
  5888 00001E99 3CCB                     cmp al, 203 ;unsigned : 1
  5889 00001E9B 0F8C7000                 jl  .getVariable236
  5890                                  
  5891                                  ;-941             getTokeType();
  5892                                  
  5893 00001E9F E846F8                   call getTokeType
  5894                                  
  5895                                  ;-942             if (TokeType == DIGIT) {
  5896                                  
  5897 00001EA2 A0[2C00]                 mov al, [TokeType]
  5898 00001EA5 3C01                     cmp al, 1
  5899 00001EA7 0F856100                 jne .getVariable237
  5900                                  
  5901                                  ;-943                 if (SymbolInt <= 0) syntaxerror();
  5902                                  
  5903 00001EAB A1[0E00]                 mov ax, [SymbolInt]
  5904 00001EAE 83F800                   cmp ax, 0
  5905 00001EB1 0F870300                 ja  .getVariable238
  5906 00001EB5 E893ED                   call syntaxerror
  5907                                  
  5908                                  ;-944                 if (AbsoluteLab == 0) error1("Absolute is null");
  5909                                  
  5910                                  .getVariable238:
  5911 00001EB8 A1[2700]                 mov ax, [AbsoluteLab]
  5912 00001EBB 83F800                   cmp ax, 0
  5913 00001EBE 0F850900                 jne .getVariable239
  5914 00001EC2 68[171F]                 push getVariable_0
  5915 00001EC5 E882EB                   call error1
  5916 00001EC8 83C402                   add  sp, 2
  5917                                  
  5918                                  ;-945                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  5919                                  
  5920                                  .getVariable239:
  5921 00001ECB A1[2700]                 mov ax, [AbsoluteLab]
  5922 00001ECE 8B1E[4A00]               mov bx, [LabelMaxIx]
  5923 00001ED2 D1E3                     shl bx, 1
  5924 00001ED4 8987CA8E                 mov [LabelAddr+bx], ax
  5925                                  
  5926                                  ;-946                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  5927                                  
  5928 00001ED8 A0[2F00]                 mov al, [CodeType]
  5929 00001EDB 3CCC                     cmp al, 204
  5930 00001EDD 0F850A00                 jne .getVariable240
  5931 00001EE1 A1[0E00]                 mov ax, [SymbolInt]
  5932 00001EE4 0306[0E00]               add ax, [SymbolInt]
  5933 00001EE8 A3[0E00]                 mov word [SymbolInt], ax
  5934                                  
  5935                                  ;-947                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  5936                                  
  5937                                  .getVariable240:
  5938 00001EEB A0[2F00]                 mov al, [CodeType]
  5939 00001EEE 3CCD                     cmp al, 205
  5940 00001EF0 0F850B00                 jne .getVariable241
  5941 00001EF4 A1[0E00]                 mov ax, [SymbolInt]
  5942 00001EF7 BB0400                   mov bx, 4
  5943 00001EFA F7E3                     mul bx
  5944 00001EFC A3[0E00]                 mov word [SymbolInt], ax
  5945                                  
  5946                                  ;-948                 AbsoluteLab = AbsoluteLab + SymbolInt;
  5947                                  
  5948                                  .getVariable241:
  5949 00001EFF A1[2700]                 mov ax, [AbsoluteLab]
  5950 00001F02 0306[0E00]               add ax, [SymbolInt]
  5951 00001F06 A3[2700]                 mov word [AbsoluteLab], ax
  5952                                  
  5953                                  ;-949             } else numbererror();
  5954                                  
  5955 00001F09 E90300                   jmp .getVariable242
  5956                                  .getVariable237:
  5957 00001F0C E8A9EC                   call numbererror
  5958                                  
  5959                                  ;-950         }
  5960                                  
  5961                                  .getVariable242:
  5962                                  
  5963                                  ;-951     }
  5964                                  
  5965                                  .getVariable236:
  5966                                  
  5967                                  ;-952     else dataexit();
  5968                                  
  5969 00001F0F E90300                   jmp .getVariable243
  5970                                  .getVariable217:
  5971 00001F12 E861ED                   call dataexit
  5972                                  
  5973                                  ;-953 }
  5974                                  
  5975                                  .getVariable243:
  5976                                  
  5977                                  ;-954 
  5978                                  
  5979                                  
  5980                                  ;-955 int getCodeSize() {
  5981 00001F15 C9                       LEAVE
  5982 00001F16 C3                       ret
  5983 00001F17 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  5984 00001F20 6973206E756C6C00   
  5985                                  ENDP
  5986                                  
  5987                                  getCodeSize: PROC
  5988                                  
  5989                                  ;-956     if (TokeType ==ALNUME) {
  5990                                  
  5991 00001F28 A0[2C00]                 mov al, [TokeType]
  5992 00001F2B 3C03                     cmp al, 3
  5993 00001F2D 0F855700                 jne .getCodeSize244
  5994                                  
  5995                                  ;-957         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  5996                                  
  5997 00001F31 68[8F1F]                 push getCodeSize_0
  5998 00001F34 8D064F75                 lea  ax, [SymbolUpper]
  5999 00001F38 50                       push ax
  6000 00001F39 E824E3                   call eqstr
  6001 00001F3C 83C404                   add  sp, 4
  6002 00001F3F 08C0                     or  al, al
  6003 00001F41 0F840900                 je .getCodeSize245
  6004 00001F45 E8A0F7                   call getTokeType
  6005 00001F48 B80100                   mov ax, 1
  6006 00001F4B E94000                   jmp .retngetCodeSize
  6007                                  
  6008                                  ;-958         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  6009                                  
  6010                                  .getCodeSize245:
  6011 00001F4E 68[941F]                 push getCodeSize_1
  6012 00001F51 8D064F75                 lea  ax, [SymbolUpper]
  6013 00001F55 50                       push ax
  6014 00001F56 E807E3                   call eqstr
  6015 00001F59 83C404                   add  sp, 4
  6016 00001F5C 08C0                     or  al, al
  6017 00001F5E 0F840900                 je .getCodeSize246
  6018 00001F62 E883F7                   call getTokeType
  6019 00001F65 B80200                   mov ax, 2
  6020 00001F68 E92300                   jmp .retngetCodeSize
  6021                                  
  6022                                  ;-959         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  6023                                  
  6024                                  .getCodeSize246:
  6025 00001F6B 68[991F]                 push getCodeSize_2
  6026 00001F6E 8D064F75                 lea  ax, [SymbolUpper]
  6027 00001F72 50                       push ax
  6028 00001F73 E8EAE2                   call eqstr
  6029 00001F76 83C404                   add  sp, 4
  6030 00001F79 08C0                     or  al, al
  6031 00001F7B 0F840900                 je .getCodeSize247
  6032 00001F7F E866F7                   call getTokeType
  6033 00001F82 B80300                   mov ax, 3
  6034 00001F85 E90600                   jmp .retngetCodeSize
  6035                                  
  6036                                  ;-960     }
  6037                                  
  6038                                  .getCodeSize247:
  6039                                  
  6040                                  ;-961     return 0;
  6041                                  
  6042                                  .getCodeSize244:
  6043 00001F88 B80000                   mov ax, 0
  6044 00001F8B E90000                   jmp .retngetCodeSize
  6045                                  
  6046                                  ;-962 }
  6047                                  
  6048                                  
  6049                                  ;-963 
  6050                                  
  6051                                  
  6052                                  ;-964 
  6053                                  
  6054                                  
  6055                                  ;-965 int getarg() {
  6056                                  
  6057                                   .retngetCodeSize:
  6058 00001F8E C3                       ret
  6059 00001F8F 4259544500              getCodeSize_0 db "BYTE",0
  6060 00001F94 574F524400              getCodeSize_1 db "WORD",0
  6061 00001F99 44574F524400            getCodeSize_2 db "DWORD",0
  6062                                  ENDP
  6063                                  
  6064                                  getarg: PROC
  6065                                  
  6066                                  ;-966     int arglen1; int i; char *c;
  6067                                  
  6068                                  
  6069                                  ;-967     arglen1=*arglen;
  6070                                  
  6071                                  ;Function : getarg, Number of local variables: 3
  6072                                  ;   # type sign width addr used name   list of local variables
  6073                                  ;  200 var sign word   966 NULL arglen1 = bp-2
  6074                                  ;  201 var sign word   966 NULL i = bp-4
  6075                                  ;  202 ptr sign byte   966 NULL c = bp-6;
  6076 00001F9F C8060000                 ENTER  6,0
  6077 00001FA3 8B1E[5A00]               mov bx, [arglen]
  6078 00001FA7 8A07                     mov al, [bx]
  6079 00001FA9 B400                     mov ah, 0
  6080 00001FAB 8946FE                   mov [bp-2], ax
  6081                                  
  6082                                  ;-968     if (arglen1==0) {
  6083                                  
  6084 00001FAE 8B46FE                   mov ax, [bp-2]
  6085 00001FB1 83F800                   cmp ax, 0
  6086 00001FB4 0F851C00                 jne .getarg248
  6087                                  
  6088                                  ;-969         cputs(Version1);
  6089                                  
  6090 00001FB8 8D06[0300]               lea  ax, [Version1]
  6091 00001FBC 50                       push ax
  6092 00001FBD E8BFE0                   call cputs
  6093 00001FC0 83C402                   add  sp, 2
  6094                                  
  6095                                  ;-970         cputs(", Usage: AS.COM filename [w/o .S] : ");
  6096                                  
  6097 00001FC3 68[4F21]                 push getarg_0
  6098 00001FC6 E8B6E0                   call cputs
  6099 00001FC9 83C402                   add  sp, 2
  6100                                  
  6101                                  ;-971         exitR(3);
  6102                                  
  6103 00001FCC 6A03                     push 3
  6104 00001FCE E815E1                   call exitR
  6105 00001FD1 83C402                   add  sp, 2
  6106                                  
  6107                                  ;-972     }
  6108                                  
  6109                                  
  6110                                  ;-973     i=arglen1+129;
  6111                                  
  6112                                  .getarg248:
  6113 00001FD4 8B46FE                   mov ax, [bp-2]
  6114 00001FD7 058100                   add ax, 129
  6115 00001FDA 8946FC                   mov [bp-4], ax
  6116                                  
  6117                                  ;-974     *i=0;
  6118                                  
  6119 00001FDD B80000                   mov ax, 0
  6120 00001FE0 8B5EFC                   mov  bx, [bp-4]
  6121 00001FE3 8907                     mov  [bx], ax
  6122                                  
  6123                                  ;-975     arglen1--;
  6124                                  
  6125 00001FE5 FF4EFE                   dec  word[bp-2]
  6126                                  
  6127                                  ;-976     toupper(argv);
  6128                                  
  6129 00001FE8 FF36[5C00]               push word [argv]
  6130 00001FEC E8E2E2                   call toupper
  6131 00001FEF 83C402                   add  sp, 2
  6132                                  
  6133                                  ;-977 
  6134                                  
  6135                                  
  6136                                  ;-978     strcpy(namein, argv); strcat1(namein, ".S");
  6137                                  
  6138 00001FF2 FF36[5C00]               push word [argv]
  6139 00001FF6 8D068C76                 lea  ax, [namein]
  6140 00001FFA 50                       push ax
  6141 00001FFB E82CE2                   call strcpy
  6142 00001FFE 83C404                   add  sp, 4
  6143 00002001 68[7421]                 push getarg_1
  6144 00002004 8D068C76                 lea  ax, [namein]
  6145 00002008 50                       push ax
  6146 00002009 E8A0E2                   call strcat1
  6147 0000200C 83C404                   add  sp, 4
  6148                                  
  6149                                  ;-979     strcpy(namelst,argv); strcat1(namelst,".LST");
  6150                                  
  6151 0000200F FF36[5C00]               push word [argv]
  6152 00002013 8D06CF76                 lea  ax, [namelst]
  6153 00002017 50                       push ax
  6154 00002018 E80FE2                   call strcpy
  6155 0000201B 83C404                   add  sp, 4
  6156 0000201E 68[7721]                 push getarg_2
  6157 00002021 8D06CF76                 lea  ax, [namelst]
  6158 00002025 50                       push ax
  6159 00002026 E883E2                   call strcat1
  6160 00002029 83C404                   add  sp, 4
  6161                                  
  6162                                  ;-980     strcpy(namebin,argv); strcat1(namebin,".COM");
  6163                                  
  6164 0000202C FF36[5C00]               push word [argv]
  6165 00002030 8D061277                 lea  ax, [namebin]
  6166 00002034 50                       push ax
  6167 00002035 E8F2E1                   call strcpy
  6168 00002038 83C404                   add  sp, 4
  6169 0000203B 68[7C21]                 push getarg_3
  6170 0000203E 8D061277                 lea  ax, [namebin]
  6171 00002042 50                       push ax
  6172 00002043 E866E2                   call strcat1
  6173 00002046 83C404                   add  sp, 4
  6174                                  
  6175                                  ;-981 
  6176                                  
  6177                                  
  6178                                  ;-982   DOS_ERR=0; PC=0; ErrorCount=0;
  6179                                  
  6180 00002049 B80000                   mov ax, 0
  6181 0000204C A3[1C00]                 mov word [DOS_ERR], ax
  6182 0000204F B80000                   mov ax, 0
  6183 00002052 A3[2300]                 mov word [PC], ax
  6184 00002055 B80000                   mov ax, 0
  6185 00002058 A3[1E00]                 mov word [ErrorCount], ax
  6186                                  
  6187                                  ;-983 
  6188                                  
  6189                                  
  6190                                  ;-984     asm_fd=openR (namein);
  6191                                  
  6192 0000205B 8D068C76                 lea  ax, [namein]
  6193 0000205F 50                       push ax
  6194 00002060 E853E0                   call openR
  6195 00002063 83C402                   add  sp, 2
  6196 00002066 A3[1600]                 mov word [asm_fd], ax
  6197                                  
  6198                                  ;-985     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  6199                                  
  6200 00002069 A1[1C00]                 mov ax, [DOS_ERR]
  6201 0000206C 08C0                     or  al, al
  6202 0000206E 0F841C00                 je .getarg249
  6203 00002072 68[8121]                 push getarg_4
  6204 00002075 E807E0                   call cputs
  6205 00002078 83C402                   add  sp, 2
  6206 0000207B 8D068C76                 lea  ax, [namein]
  6207 0000207F 50                       push ax
  6208 00002080 E8FCDF                   call cputs
  6209 00002083 83C402                   add  sp, 2
  6210 00002086 6A01                     push 1
  6211 00002088 E85BE0                   call exitR
  6212 0000208B 83C402                   add  sp, 2
  6213                                  
  6214                                  ;-986     lst_fd=creatR(namelst);
  6215                                  
  6216                                  .getarg249:
  6217 0000208E 8D06CF76                 lea  ax, [namelst]
  6218 00002092 50                       push ax
  6219 00002093 E82FE0                   call creatR
  6220 00002096 83C402                   add  sp, 2
  6221 00002099 A3[1800]                 mov word [lst_fd], ax
  6222                                  
  6223                                  ;-987     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  6224                                  
  6225 0000209C A1[1C00]                 mov ax, [DOS_ERR]
  6226 0000209F 08C0                     or  al, al
  6227 000020A1 0F841C00                 je .getarg250
  6228 000020A5 68[9721]                 push getarg_5
  6229 000020A8 E8D4DF                   call cputs
  6230 000020AB 83C402                   add  sp, 2
  6231 000020AE 8D06CF76                 lea  ax, [namelst]
  6232 000020B2 50                       push ax
  6233 000020B3 E8C9DF                   call cputs
  6234 000020B6 83C402                   add  sp, 2
  6235 000020B9 6A02                     push 2
  6236 000020BB E828E0                   call exitR
  6237 000020BE 83C402                   add  sp, 2
  6238                                  
  6239                                  ;-988     bin_fd=creatR(namebin);
  6240                                  
  6241                                  .getarg250:
  6242 000020C1 8D061277                 lea  ax, [namebin]
  6243 000020C5 50                       push ax
  6244 000020C6 E8FCDF                   call creatR
  6245 000020C9 83C402                   add  sp, 2
  6246 000020CC A3[1A00]                 mov word [bin_fd], ax
  6247                                  
  6248                                  ;-989     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  6249                                  
  6250 000020CF A1[1C00]                 mov ax, [DOS_ERR]
  6251 000020D2 08C0                     or  al, al
  6252 000020D4 0F841C00                 je .getarg251
  6253 000020D8 68[AE21]                 push getarg_6
  6254 000020DB E8A1DF                   call cputs
  6255 000020DE 83C402                   add  sp, 2
  6256 000020E1 8D061277                 lea  ax, [namebin]
  6257 000020E5 50                       push ax
  6258 000020E6 E896DF                   call cputs
  6259 000020E9 83C402                   add  sp, 2
  6260 000020EC 6A02                     push 2
  6261 000020EE E8F5DF                   call exitR
  6262 000020F1 83C402                   add  sp, 2
  6263                                  
  6264                                  ;-990 
  6265                                  
  6266                                  
  6267                                  ;-991     prs(";");
  6268                                  
  6269                                  .getarg251:
  6270 000020F4 68[C421]                 push getarg_7
  6271 000020F7 E839E6                   call prs
  6272 000020FA 83C402                   add  sp, 2
  6273                                  
  6274                                  ;-992     prs(Version1);
  6275                                  
  6276 000020FD 8D06[0300]               lea  ax, [Version1]
  6277 00002101 50                       push ax
  6278 00002102 E82EE6                   call prs
  6279 00002105 83C402                   add  sp, 2
  6280                                  
  6281                                  ;-993     prs(", Source: "); prs(namein);
  6282                                  
  6283 00002108 68[C621]                 push getarg_8
  6284 0000210B E825E6                   call prs
  6285 0000210E 83C402                   add  sp, 2
  6286 00002111 8D068C76                 lea  ax, [namein]
  6287 00002115 50                       push ax
  6288 00002116 E81AE6                   call prs
  6289 00002119 83C402                   add  sp, 2
  6290                                  
  6291                                  ;-994     prs(", Output: "); prs(namelst);
  6292                                  
  6293 0000211C 68[D121]                 push getarg_9
  6294 0000211F E811E6                   call prs
  6295 00002122 83C402                   add  sp, 2
  6296 00002125 8D06CF76                 lea  ax, [namelst]
  6297 00002129 50                       push ax
  6298 0000212A E806E6                   call prs
  6299 0000212D 83C402                   add  sp, 2
  6300                                  
  6301                                  ;-995     prs(", "); prs(namebin);
  6302                                  
  6303 00002130 68[DC21]                 push getarg_10
  6304 00002133 E8FDE5                   call prs
  6305 00002136 83C402                   add  sp, 2
  6306 00002139 8D061277                 lea  ax, [namebin]
  6307 0000213D 50                       push ax
  6308 0000213E E8F2E5                   call prs
  6309 00002141 83C402                   add  sp, 2
  6310                                  
  6311                                  ;-996     prs("\n");
  6312                                  
  6313 00002144 68[DF21]                 push getarg_11
  6314 00002147 E8E9E5                   call prs
  6315 0000214A 83C402                   add  sp, 2
  6316                                  
  6317                                  ;-997 }
  6318                                  
  6319                                  
  6320                                  ;-998 
  6321                                  
  6322                                  
  6323                                  ;-999 int fixJmp() {   
  6324 0000214D C9                       LEAVE
  6325 0000214E C3                       ret
  6326 0000214F 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  6327 00002158 41532E434F4D206669-
  6328 00002161 6C656E616D65205B77-
  6329 0000216A 2F6F202E535D203A20-
  6330 00002173 00                 
  6331 00002174 2E5300                  getarg_1 db ".S",0
  6332 00002177 2E4C535400              getarg_2 db ".LST",0
  6333 0000217C 2E434F4D00              getarg_3 db ".COM",0
  6334 00002181 536F75726365206669-     getarg_4 db "Source file missing: ",0
  6335 0000218A 6C65206D697373696E-
  6336 00002193 673A2000           
  6337 00002197 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  6338 000021A0 206E6F742063726561-
  6339 000021A9 74653A2000         
  6340 000021AE 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  6341 000021B7 6E6F74206372656174-
  6342 000021C0 653A2000           
  6343 000021C4 3B00                    getarg_7 db ";",0
  6344 000021C6 2C20536F757263653A-     getarg_8 db ", Source: ",0
  6345 000021CF 2000               
  6346 000021D1 2C204F75747075743A-     getarg_9 db ", Output: ",0
  6347 000021DA 2000               
  6348 000021DC 2C2000                  getarg_10 db ", ",0
  6349 000021DF 5C6E00                  getarg_11 db "\n",0
  6350                                  ENDP
  6351                                  
  6352                                  fixJmp: PROC
  6353                                  
  6354                                  ;-1000     unsigned int hex; int i;
  6355                                  
  6356                                  
  6357                                  ;-1001     char *p; int Ix; char c;
  6358                                  
  6359                                  
  6360                                  ;-1002 //    prs("\, jmp to fix:"); printIntU(JmpMaxIx);
  6361                                  
  6362                                  
  6363                                  ;-1003     p = &JmpNames;
  6364                                  
  6365                                  ;Function : fixJmp, Number of local variables: 5
  6366                                  ;   # type sign width addr used name   list of local variables
  6367                                  ;  200 var unsg word  1000 NULL hex = bp-2
  6368                                  ;  201 var sign word  1000 NULL i = bp-4
  6369                                  ;  202 ptr sign byte  1001 NULL p = bp-6
  6370                                  ;  203 var sign word  1001 NULL Ix = bp-8
  6371                                  ;  204 var sign byte  1001 NULL c = bp-10;
  6372 000021E2 C80A0000                 ENTER  10,0
  6373 000021E6 B87A93                   mov ax, JmpNames
  6374 000021E9 8946FA                   mov [bp-6], ax
  6375                                  
  6376                                  ;-1004     i = 1;
  6377                                  
  6378 000021EC B80100                   mov ax, 1
  6379 000021EF 8946FC                   mov [bp-4], ax
  6380                                  
  6381                                  ;-1005     while (i <= JmpMaxIx) {
  6382                                  
  6383                                  .fixJmp252:
  6384 000021F2 8B46FC                   mov ax, [bp-4]
  6385 000021F5 3B06[5400]               cmp ax, [JmpMaxIx]
  6386 000021F9 0F8FA200                 jg  .fixJmp253
  6387                                  
  6388                                  ;-1006         strcpy(Symbol, p);
  6389                                  
  6390 000021FD FF76FA                   push word [bp-6]
  6391 00002200 8D063075                 lea  ax, [Symbol]
  6392 00002204 50                       push ax
  6393 00002205 E822E0                   call strcpy
  6394 00002208 83C404                   add  sp, 4
  6395                                  
  6396                                  ;-1007         p = strlen(Symbol) + p;
  6397                                  
  6398 0000220B 8D063075                 lea  ax, [Symbol]
  6399 0000220F 50                       push ax
  6400 00002210 E8EFDF                   call strlen
  6401 00002213 83C402                   add  sp, 2
  6402 00002216 0346FA                   add ax, [bp-6]
  6403 00002219 8946FA                   mov [bp-6], ax
  6404                                  
  6405                                  ;-1008         p++;
  6406                                  
  6407 0000221C FF46FA                   inc  word[bp-6]
  6408                                  
  6409                                  ;-1009         hex = JmpAddr[i];
  6410                                  
  6411 0000221F 8B5EFC                   mov bx, [bp-4]
  6412 00002222 D1E3                     shl bx, 1
  6413 00002224 8B871AA3                 mov ax, [JmpAddr + bx]
  6414 00002228 8946FE                   mov [bp-2], ax
  6415                                  
  6416                                  ;-1010 //        prs("\n"); printIntU(i);
  6417                                  
  6418                                  
  6419                                  ;-1011 //        prs("  "); prs(Symbol); prs(", from:");
  6420                                  
  6421                                  
  6422                                  ;-1012 //        printhex16(hex);
  6423                                  
  6424                                  
  6425                                  ;-1013         
  6426                                  
  6427                                  
  6428                                  ;-1014         Ix=searchLabel();
  6429                                  
  6430 0000222B E858F6                   call searchLabel
  6431 0000222E 8946F8                   mov [bp-8], ax
  6432                                  
  6433                                  ;-1015         if (Ix == 0) notfounderror();
  6434                                  
  6435 00002231 8B46F8                   mov ax, [bp-8]
  6436 00002234 83F800                   cmp ax, 0
  6437 00002237 0F850300                 jne .fixJmp254
  6438 0000223B E87DE8                   call notfounderror
  6439                                  
  6440                                  ;-1016         disp = LabelAddr[Ix];   
  6441                                  
  6442                                  .fixJmp254:
  6443 0000223E 8B5EF8                   mov bx, [bp-8]
  6444 00002241 D1E3                     shl bx, 1
  6445 00002243 8B87CA8E                 mov ax, [LabelAddr + bx]
  6446 00002247 A3[3D00]                 mov word [disp], ax
  6447                                  
  6448                                  ;-1017         c = FileBin[hex];//look for 'A' push Absolute 
  6449                                  
  6450 0000224A 8B5EFE                   mov bx, [bp-2]
  6451 0000224D 8A87AAA4                 mov al, [FileBin + bx]
  6452 00002251 8846F6                   mov [bp-10], al
  6453                                  
  6454                                  ;-1018 //        prs(", Label+ORG:"); printhex16(disp);
  6455                                  
  6456                                  
  6457                                  ;-1019         if (c != 0xAA) {
  6458                                  
  6459 00002254 8A46F6                   mov al, [bp-10]
  6460 00002257 3CAA                     cmp al, 170
  6461 00002259 0F841C00                 je  .fixJmp255
  6462                                  
  6463                                  ;-1020             disp = disp - hex;
  6464                                  
  6465 0000225D A1[3D00]                 mov ax, [disp]
  6466 00002260 2B46FE                   sub ax, [bp-2]
  6467 00002263 A3[3D00]                 mov word [disp], ax
  6468                                  
  6469                                  ;-1021             disp = disp -2;//PC points to next instruction
  6470                                  
  6471 00002266 A1[3D00]                 mov ax, [disp]
  6472 00002269 83E802                   sub ax, 2
  6473 0000226C A3[3D00]                 mov word [disp], ax
  6474                                  
  6475                                  ;-1022             disp = disp - Origin; 
  6476                                  
  6477 0000226F A1[3D00]                 mov ax, [disp]
  6478 00002272 2B06[2500]               sub ax, [Origin]
  6479 00002276 A3[3D00]                 mov word [disp], ax
  6480                                  
  6481                                  ;-1023 //            prs(", rel:"); printhex16(disp);
  6482                                  
  6483                                  
  6484                                  ;-1024         }
  6485                                  
  6486                                  
  6487                                  ;-1025             FileBin[hex] = disp;//fix low byte
  6488                                  
  6489                                  .fixJmp255:
  6490 00002279 A1[3D00]                 mov ax, [disp]
  6491 0000227C 8B5EFE                   mov bx, [bp-2]
  6492 0000227F 8887AAA4                 mov [FileBin+bx], al
  6493                                  
  6494                                  ;-1026             hex++;
  6495                                  
  6496 00002283 FF46FE                   inc  word[bp-2]
  6497                                  
  6498                                  ;-1027             disp = disp >> 8;
  6499                                  
  6500 00002286 A1[3D00]                 mov ax, [disp]
  6501 00002289 C1E808                   shr ax, 8
  6502 0000228C A3[3D00]                 mov word [disp], ax
  6503                                  
  6504                                  ;-1028             FileBin[hex] = disp; 
  6505                                  
  6506 0000228F A1[3D00]                 mov ax, [disp]
  6507 00002292 8B5EFE                   mov bx, [bp-2]
  6508 00002295 8887AAA4                 mov [FileBin+bx], al
  6509                                  
  6510                                  ;-1029         i++;  
  6511                                  
  6512 00002299 FF46FC                   inc  word[bp-4]
  6513                                  
  6514                                  ;-1030     }
  6515                                  
  6516                                  
  6517                                  ;-1031 }
  6518                                  
  6519 0000229C E953FF                   jmp .fixJmp252
  6520                                  .fixJmp253:
  6521                                  
  6522                                  ;-1032 int fixJmpMain() {   
  6523 0000229F C9                       LEAVE
  6524 000022A0 C3                       ret
  6525                                  ENDP
  6526                                  
  6527                                  fixJmpMain: PROC
  6528                                  
  6529                                  ;-1033     unsigned int hex; 
  6530                                  
  6531                                  
  6532                                  ;-1034     int Ix; char c;
  6533                                  
  6534                                  
  6535                                  ;-1035     prs("\nfix jmp to main. resting global jmp: ");
  6536                                  
  6537                                  ;Function : fixJmpMain, Number of local variables: 3
  6538                                  ;   # type sign width addr used name   list of local variables
  6539                                  ;  200 var unsg word  1033 NULL hex = bp-2
  6540                                  ;  201 var sign word  1034 NULL Ix = bp-4
  6541                                  ;  202 var sign byte  1034 NULL c = bp-6;
  6542 000022A1 C8060000                 ENTER  6,0
  6543 000022A5 68[7423]                 push fixJmpMain_0
  6544 000022A8 E888E4                   call prs
  6545 000022AB 83C402                   add  sp, 2
  6546                                  
  6547                                  ;-1036     printIntU(JmpMaxIx);  
  6548                                  
  6549 000022AE FF36[5400]               push word [JmpMaxIx]
  6550 000022B2 E88EE5                   call printIntU
  6551 000022B5 83C402                   add  sp, 2
  6552                                  
  6553                                  ;-1037     if (JmpMaxIx ) error1("resting global jmp");
  6554                                  
  6555 000022B8 A1[5400]                 mov ax, [JmpMaxIx]
  6556 000022BB 08C0                     or  al, al
  6557 000022BD 0F840900                 je .fixJmpMain256
  6558 000022C1 68[9C23]                 push fixJmpMain_1
  6559 000022C4 E883E7                   call error1
  6560 000022C7 83C402                   add  sp, 2
  6561                                  
  6562                                  ;-1038         strcpy(Symbol, "main");
  6563                                  
  6564                                  .fixJmpMain256:
  6565 000022CA 68[AF23]                 push fixJmpMain_2
  6566 000022CD 8D063075                 lea  ax, [Symbol]
  6567 000022D1 50                       push ax
  6568 000022D2 E855DF                   call strcpy
  6569 000022D5 83C404                   add  sp, 4
  6570                                  
  6571                                  ;-1039         hex = 1;//first instruction, PC=1
  6572                                  
  6573 000022D8 B80100                   mov ax, 1
  6574 000022DB 8946FE                   mov [bp-2], ax
  6575                                  
  6576                                  ;-1040         Ix=searchLabel();
  6577                                  
  6578 000022DE E8A5F5                   call searchLabel
  6579 000022E1 8946FC                   mov [bp-4], ax
  6580                                  
  6581                                  ;-1041         if (Ix == 0) notfounderror();
  6582                                  
  6583 000022E4 8B46FC                   mov ax, [bp-4]
  6584 000022E7 83F800                   cmp ax, 0
  6585 000022EA 0F850300                 jne .fixJmpMain257
  6586 000022EE E8CAE7                   call notfounderror
  6587                                  
  6588                                  ;-1042         disp = LabelAddr[Ix];   
  6589                                  
  6590                                  .fixJmpMain257:
  6591 000022F1 8B5EFC                   mov bx, [bp-4]
  6592 000022F4 D1E3                     shl bx, 1
  6593 000022F6 8B87CA8E                 mov ax, [LabelAddr + bx]
  6594 000022FA A3[3D00]                 mov word [disp], ax
  6595                                  
  6596                                  ;-1043         c = FileBin[hex];//look for 'A' push Absolute 
  6597                                  
  6598 000022FD 8B5EFE                   mov bx, [bp-2]
  6599 00002300 8A87AAA4                 mov al, [FileBin + bx]
  6600 00002304 8846FA                   mov [bp-6], al
  6601                                  
  6602                                  ;-1044         prs("\nmain ,Label+ORG:"); printhex16(disp);
  6603                                  
  6604 00002307 68[B423]                 push fixJmpMain_3
  6605 0000230A E826E4                   call prs
  6606 0000230D 83C402                   add  sp, 2
  6607 00002310 FF36[3D00]               push word [disp]
  6608 00002314 E802E5                   call printhex16
  6609 00002317 83C402                   add  sp, 2
  6610                                  
  6611                                  ;-1045         if (c != 0xAA) {
  6612                                  
  6613 0000231A 8A46FA                   mov al, [bp-6]
  6614 0000231D 3CAA                     cmp al, 170
  6615 0000231F 0F842F00                 je  .fixJmpMain258
  6616                                  
  6617                                  ;-1046             disp = disp - hex;
  6618                                  
  6619 00002323 A1[3D00]                 mov ax, [disp]
  6620 00002326 2B46FE                   sub ax, [bp-2]
  6621 00002329 A3[3D00]                 mov word [disp], ax
  6622                                  
  6623                                  ;-1047             disp = disp -2;//PC points to next instruction
  6624                                  
  6625 0000232C A1[3D00]                 mov ax, [disp]
  6626 0000232F 83E802                   sub ax, 2
  6627 00002332 A3[3D00]                 mov word [disp], ax
  6628                                  
  6629                                  ;-1048             disp = disp - Origin; 
  6630                                  
  6631 00002335 A1[3D00]                 mov ax, [disp]
  6632 00002338 2B06[2500]               sub ax, [Origin]
  6633 0000233C A3[3D00]                 mov word [disp], ax
  6634                                  
  6635                                  ;-1049             prs(",rel:"); printhex16(disp);
  6636                                  
  6637 0000233F 68[C723]                 push fixJmpMain_4
  6638 00002342 E8EEE3                   call prs
  6639 00002345 83C402                   add  sp, 2
  6640 00002348 FF36[3D00]               push word [disp]
  6641 0000234C E8CAE4                   call printhex16
  6642 0000234F 83C402                   add  sp, 2
  6643                                  
  6644                                  ;-1050         }
  6645                                  
  6646                                  
  6647                                  ;-1051             FileBin[hex] = disp;//fix low byte
  6648                                  
  6649                                  .fixJmpMain258:
  6650 00002352 A1[3D00]                 mov ax, [disp]
  6651 00002355 8B5EFE                   mov bx, [bp-2]
  6652 00002358 8887AAA4                 mov [FileBin+bx], al
  6653                                  
  6654                                  ;-1052             hex++;
  6655                                  
  6656 0000235C FF46FE                   inc  word[bp-2]
  6657                                  
  6658                                  ;-1053             disp = disp >> 8;
  6659                                  
  6660 0000235F A1[3D00]                 mov ax, [disp]
  6661 00002362 C1E808                   shr ax, 8
  6662 00002365 A3[3D00]                 mov word [disp], ax
  6663                                  
  6664                                  ;-1054             FileBin[hex] = disp; 
  6665                                  
  6666 00002368 A1[3D00]                 mov ax, [disp]
  6667 0000236B 8B5EFE                   mov bx, [bp-2]
  6668 0000236E 8887AAA4                 mov [FileBin+bx], al
  6669                                  
  6670                                  ;-1055 }
  6671                                  
  6672                                  
  6673                                  ;-1056 
  6674                                  
  6675                                  
  6676                                  ;-1057 
  6677                                  
  6678                                  
  6679                                  ;-1058 int getCodes() {
  6680 00002372 C9                       LEAVE
  6681 00002373 C3                       ret
  6682 00002374 5C6E666978206A6D70-     fixJmpMain_0 db "\nfix jmp to main. resting global jmp: ",0
  6683 0000237D 20746F206D61696E2E-
  6684 00002386 2072657374696E6720-
  6685 0000238F 676C6F62616C206A6D-
  6686 00002398 703A2000           
  6687 0000239C 72657374696E672067-     fixJmpMain_1 db "resting global jmp",0
  6688 000023A5 6C6F62616C206A6D70-
  6689 000023AE 00                 
  6690 000023AF 6D61696E00              fixJmpMain_2 db "main",0
  6691 000023B4 5C6E6D61696E202C4C-     fixJmpMain_3 db "\nmain ,Label+ORG:",0
  6692 000023BD 6162656C2B4F52473A-
  6693 000023C6 00                 
  6694 000023C7 2C72656C3A00            fixJmpMain_4 db ",rel:",0
  6695                                  ENDP
  6696                                  
  6697                                  getCodes: PROC
  6698                                  
  6699                                  ;-1059     OpCodePtr ++; Code1 = *OpCodePtr;
  6700                                  
  6701 000023CD FF06[4300]               inc  word[OpCodePtr]
  6702 000023D1 8B1E[4300]               mov bx, [OpCodePtr]
  6703 000023D5 8A07                     mov al, [bx]
  6704 000023D7 B400                     mov ah, 0
  6705 000023D9 A2[3000]                 mov byte [Code1], al
  6706                                  
  6707                                  ;-1060     OpCodePtr ++; Code2 = *OpCodePtr;
  6708                                  
  6709 000023DC FF06[4300]               inc  word[OpCodePtr]
  6710 000023E0 8B1E[4300]               mov bx, [OpCodePtr]
  6711 000023E4 8A07                     mov al, [bx]
  6712 000023E6 B400                     mov ah, 0
  6713 000023E8 A2[3100]                 mov byte [Code2], al
  6714                                  
  6715                                  ;-1061     OpCodePtr ++; Code3 = *OpCodePtr;
  6716                                  
  6717 000023EB FF06[4300]               inc  word[OpCodePtr]
  6718 000023EF 8B1E[4300]               mov bx, [OpCodePtr]
  6719 000023F3 8A07                     mov al, [bx]
  6720 000023F5 B400                     mov ah, 0
  6721 000023F7 A2[3200]                 mov byte [Code3], al
  6722                                  
  6723                                  ;-1062 }
  6724                                  
  6725                                  
  6726                                  ;-1063 
  6727                                  
  6728                                  
  6729                                  ;-1064 int process() {
  6730                                  
  6731 000023FA C3                       ret
  6732                                  ENDP
  6733                                  
  6734                                  process: PROC
  6735                                  
  6736                                  ;-1065     char c;
  6737                                  
  6738                                  
  6739                                  ;-1066     int i;
  6740                                  
  6741                                  
  6742                                  ;-1067     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6743                                  
  6744                                  ;Function : process, Number of local variables: 2
  6745                                  ;   # type sign width addr used name   list of local variables
  6746                                  ;  200 var sign byte  1065 NULL c = bp-2
  6747                                  ;  201 var sign word  1066 NULL i = bp-4;
  6748 000023FB C8040000                 ENTER  4,0
  6749 000023FF B80000                   mov ax, 0
  6750 00002402 A2[3B00]                 mov byte [rm], al
  6751 00002405 A2[3800]                 mov byte [wflag], al
  6752 00002408 A2[3900]                 mov byte [dflag], al
  6753 0000240B A2[3300]                 mov byte [R2No], al
  6754 0000240E A2[3400]                 mov byte [R1No], al
  6755 00002411 A2[3500]                 mov byte [R2Type], al
  6756 00002414 A2[3600]                 mov byte [R1Type], al
  6757 00002417 A2[2E00]                 mov byte [Op2], al
  6758 0000241A A2[2D00]                 mov byte [Op], al
  6759                                  
  6760                                  ;-1068     disp=imme=0;//int
  6761                                  
  6762 0000241D B80000                   mov ax, 0
  6763 00002420 A3[3F00]                 mov word [imme], ax
  6764 00002423 A3[3D00]                 mov word [disp], ax
  6765                                  
  6766                                  ;-1069     isDirect=1; //set in getMeM=0, need in WriteEA
  6767                                  
  6768 00002426 B80100                   mov ax, 1
  6769 00002429 A2[3C00]                 mov byte [isDirect], al
  6770                                  
  6771                                  ;-1070     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6772                                  
  6773 0000242C E8B9F2                   call getTokeType
  6774                                  
  6775                                  ;-1071     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6776                                  
  6777 0000242F E8F6FA                   call getCodeSize
  6778 00002432 A2[3700]                 mov byte [OpSize], al
  6779                                  
  6780                                  ;-1072     getCodes();//set: Code1, Code2, Code3
  6781                                  
  6782 00002435 E895FF                   call getCodes
  6783                                  
  6784                                  ;-1073 
  6785                                  
  6786                                  
  6787                                  ;-1074     if (CodeType ==  1) {//1 byte opcode
  6788                                  
  6789 00002438 A0[2F00]                 mov al, [CodeType]
  6790 0000243B 3C01                     cmp al, 1
  6791 0000243D 0F850F00                 jne .process259
  6792                                  
  6793                                  ;-1075         genCode8(Code1);
  6794                                  
  6795 00002441 A0[3000]                 mov al, byte [Code1]
  6796 00002444 B400                     mov ah, 0
  6797 00002446 50                       push ax
  6798 00002447 E848EF                   call genCode8
  6799 0000244A 83C402                   add  sp, 2
  6800                                  
  6801                                  ;-1076         return;
  6802                                  
  6803 0000244D E91709                   jmp .retnprocess
  6804                                  
  6805                                  ;-1077     }
  6806                                  
  6807                                  
  6808                                  ;-1078 
  6809                                  
  6810                                  
  6811                                  ;-1079     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6812                                  
  6813                                  .process259:
  6814 00002450 A0[2F00]                 mov al, [CodeType]
  6815 00002453 3C02                     cmp al, 2
  6816 00002455 0F856900                 jne .process260
  6817                                  
  6818                                  ;-1080         getOpL();
  6819                                  
  6820 00002459 E81DF7                   call getOpL
  6821                                  
  6822                                  ;-1081         checkOpL();
  6823                                  
  6824 0000245C E8A5F3                   call checkOpL
  6825                                  
  6826                                  ;-1082         if (Code2 <= 1) {//inc,dec
  6827                                  
  6828 0000245F A0[3100]                 mov al, [Code2]
  6829 00002462 3C01                     cmp al, 1
  6830 00002464 0F8F2700                 jg  .process261
  6831                                  
  6832                                  ;-1083   	        if (Op == REG) {//short
  6833                                  
  6834 00002468 A0[2D00]                 mov al, [Op]
  6835 0000246B 3C02                     cmp al, 2
  6836 0000246D 0F851E00                 jne .process262
  6837                                  
  6838                                  ;-1084                 if (wflag) {genCode2(Code3, R1No); return; }
  6839                                  
  6840 00002471 A0[3800]                 mov al, [wflag]
  6841 00002474 08C0                     or  al, al
  6842 00002476 0F841500                 je .process263
  6843 0000247A A0[3400]                 mov al, byte [R1No]
  6844 0000247D B400                     mov ah, 0
  6845 0000247F 50                       push ax
  6846 00002480 A0[3200]                 mov al, byte [Code3]
  6847 00002483 B400                     mov ah, 0
  6848 00002485 50                       push ax
  6849 00002486 E869EF                   call genCode2
  6850 00002489 83C404                   add  sp, 4
  6851 0000248C E9D808                   jmp .retnprocess
  6852                                  
  6853                                  ;-1085             }
  6854                                  
  6855                                  .process263:
  6856                                  
  6857                                  ;-1086         }
  6858                                  
  6859                                  .process262:
  6860                                  
  6861                                  ;-1087         if (Code2 == 5) {//imul extension?
  6862                                  
  6863                                  .process261:
  6864 0000248F A0[3100]                 mov al, [Code2]
  6865 00002492 3C05                     cmp al, 5
  6866 00002494 0F850F00                 jne .process264
  6867                                  
  6868                                  ;-1088             getTokeType();
  6869                                  
  6870 00002498 E84DF2                   call getTokeType
  6871                                  
  6872                                  ;-1089             if (TokeType) implerror();
  6873                                  
  6874 0000249B A0[2C00]                 mov al, [TokeType]
  6875 0000249E 08C0                     or  al, al
  6876 000024A0 0F840300                 je .process265
  6877 000024A4 E8B5E6                   call implerror
  6878                                  
  6879                                  ;-1090         }
  6880                                  
  6881                                  .process265:
  6882                                  
  6883                                  ;-1091         genCodeW(Code1);
  6884                                  
  6885                                  .process264:
  6886 000024A7 A0[3000]                 mov al, byte [Code1]
  6887 000024AA B400                     mov ah, 0
  6888 000024AC 50                       push ax
  6889 000024AD E85DEF                   call genCodeW
  6890 000024B0 83C402                   add  sp, 2
  6891                                  
  6892                                  ;-1092         writeEA(Code2);
  6893                                  
  6894 000024B3 A0[3100]                 mov al, byte [Code2]
  6895 000024B6 B400                     mov ah, 0
  6896 000024B8 50                       push ax
  6897 000024B9 E8B8EF                   call writeEA
  6898 000024BC 83C402                   add  sp, 2
  6899                                  
  6900                                  ;-1093         return;
  6901                                  
  6902 000024BF E9A508                   jmp .retnprocess
  6903                                  
  6904                                  ;-1094     }
  6905                                  
  6906                                  
  6907                                  ;-1095 
  6908                                  
  6909                                  
  6910                                  ;-1096     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6911                                  
  6912                                  .process260:
  6913 000024C2 A0[2F00]                 mov al, [CodeType]
  6914 000024C5 3C03                     cmp al, 3
  6915 000024C7 0F855100                 jne .process266
  6916                                  
  6917                                  ;-1097         check2Ops();    //setwflag not applicable
  6918                                  
  6919 000024CB E8E2F6                   call check2Ops
  6920                                  
  6921                                  ;-1098         if (R1Type != WORD) reg16error();//only r16
  6922                                  
  6923 000024CE A0[3600]                 mov al, [R1Type]
  6924 000024D1 3C02                     cmp al, 2
  6925 000024D3 0F840300                 je  .process267
  6926 000024D7 E822E7                   call reg16error
  6927                                  
  6928                                  ;-1099         if (Op2 != MEM) addrerror();//only m16
  6929                                  
  6930                                  .process267:
  6931 000024DA A0[2E00]                 mov al, [Op2]
  6932 000024DD 3C04                     cmp al, 4
  6933 000024DF 0F840300                 je  .process268
  6934 000024E3 E837E6                   call addrerror
  6935                                  
  6936                                  ;-1100 
  6937                                  
  6938                                  
  6939                                  ;-1101         genCode8(Code1);//les,lds,lea
  6940                                  
  6941                                  .process268:
  6942 000024E6 A0[3000]                 mov al, byte [Code1]
  6943 000024E9 B400                     mov ah, 0
  6944 000024EB 50                       push ax
  6945 000024EC E8A3EE                   call genCode8
  6946 000024EF 83C402                   add  sp, 2
  6947                                  
  6948                                  ;-1102         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6949                                  
  6950 000024F2 A0[3000]                 mov al, [Code1]
  6951 000024F5 3C0F                     cmp al, 15
  6952 000024F7 0F850C00                 jne .process269
  6953 000024FB A0[3100]                 mov al, byte [Code2]
  6954 000024FE B400                     mov ah, 0
  6955 00002500 50                       push ax
  6956 00002501 E88EEE                   call genCode8
  6957 00002504 83C402                   add  sp, 2
  6958                                  
  6959                                  ;-1103         Op=Op2;//set MEM for writeEA
  6960                                  
  6961                                  .process269:
  6962 00002507 A0[2E00]                 mov al, [Op2]
  6963 0000250A A2[2D00]                 mov byte [Op], al
  6964                                  
  6965                                  ;-1104         writeEA(R1No);
  6966                                  
  6967 0000250D A0[3400]                 mov al, byte [R1No]
  6968 00002510 B400                     mov ah, 0
  6969 00002512 50                       push ax
  6970 00002513 E85EEF                   call writeEA
  6971 00002516 83C402                   add  sp, 2
  6972                                  
  6973                                  ;-1105         return;
  6974                                  
  6975 00002519 E94B08                   jmp .retnprocess
  6976                                  
  6977                                  ;-1106     }
  6978                                  
  6979                                  
  6980                                  ;-1107 
  6981                                  
  6982                                  
  6983                                  ;-1108     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6984                                  
  6985                                  .process266:
  6986 0000251C A0[2F00]                 mov al, [CodeType]
  6987 0000251F 3C04                     cmp al, 4
  6988 00002521 0F851801                 jne .process270
  6989                                  
  6990                                  ;-1109         check2Ops();  
  6991                                  
  6992 00002525 E888F6                   call check2Ops
  6993                                  
  6994                                  ;-1110         if (Op2 == ADR) {  
  6995                                  
  6996 00002528 A0[2E00]                 mov al, [Op2]
  6997 0000252B 3C03                     cmp al, 3
  6998 0000252D 0F852000                 jne .process271
  6999                                  
  7000                                  ;-1111             if (LabelIx == 0) notfounderror();
  7001                                  
  7002 00002531 A1[4E00]                 mov ax, [LabelIx]
  7003 00002534 83F800                   cmp ax, 0
  7004 00002537 0F850300                 jne .process272
  7005 0000253B E87DE5                   call notfounderror
  7006                                  
  7007                                  ;-1112             imme=LabelAddr[LabelIx];
  7008                                  
  7009                                  .process272:
  7010 0000253E 8B1E[4E00]               mov bx, [LabelIx]
  7011 00002542 D1E3                     shl bx, 1
  7012 00002544 8B87CA8E                 mov ax, [LabelAddr + bx]
  7013 00002548 A3[3F00]                 mov word [imme], ax
  7014                                  
  7015                                  ;-1113             Op2=IMM;//got the addr and fall through
  7016                                  
  7017 0000254B B80100                   mov ax, 1
  7018 0000254E A2[2E00]                 mov byte [Op2], al
  7019                                  
  7020                                  ;-1114         }
  7021                                  
  7022                                  
  7023                                  ;-1115         if (Op2 == IMM) {//second operand is imm
  7024                                  
  7025                                  .process271:
  7026 00002551 A0[2E00]                 mov al, [Op2]
  7027 00002554 3C01                     cmp al, 1
  7028 00002556 0F857900                 jne .process273
  7029                                  
  7030                                  ;-1116             setsflag();
  7031                                  
  7032 0000255A E8C1F0                   call setsflag
  7033                                  
  7034                                  ;-1117             if (Op == REG) {
  7035                                  
  7036 0000255D A0[2D00]                 mov al, [Op]
  7037 00002560 3C02                     cmp al, 2
  7038 00002562 0F853100                 jne .process274
  7039                                  
  7040                                  ;-1118                 if (R1No == 0) {// acc,imm
  7041                                  
  7042 00002566 A0[3400]                 mov al, [R1No]
  7043 00002569 3C00                     cmp al, 0
  7044 0000256B 0F852800                 jne .process275
  7045                                  
  7046                                  ;-1119                     if (sflag == 0) {
  7047                                  
  7048 0000256F A0[3A00]                 mov al, [sflag]
  7049 00002572 3C00                     cmp al, 0
  7050 00002574 0F851F00                 jne .process276
  7051                                  
  7052                                  ;-1120                         c = Code1 << 3;
  7053                                  
  7054 00002578 A0[3000]                 mov al, [Code1]
  7055 0000257B C0E003                   shl al, 3
  7056 0000257E 8846FE                   mov [bp-2], al
  7057                                  
  7058                                  ;-1121                         c += 4;
  7059                                  
  7060 00002581 8046FE04                 add  byte[bp-2], 4
  7061                                  
  7062                                  ;-1122                         genCodeW(c);
  7063                                  
  7064 00002585 8A46FE                   mov al, byte [bp-2]
  7065 00002588 B400                     mov ah, 0
  7066 0000258A 50                       push ax
  7067 0000258B E87FEE                   call genCodeW
  7068 0000258E 83C402                   add  sp, 2
  7069                                  
  7070                                  ;-1123                         genImmediate();
  7071                                  
  7072 00002591 E8E6EF                   call genImmediate
  7073                                  
  7074                                  ;-1124                         return;
  7075                                  
  7076 00002594 E9D007                   jmp .retnprocess
  7077                                  
  7078                                  ;-1125                     }
  7079                                  
  7080                                  
  7081                                  ;-1126                 }
  7082                                  
  7083                                  .process276:
  7084                                  
  7085                                  ;-1127             }
  7086                                  
  7087                                  .process275:
  7088                                  
  7089                                  ;-1128             //r/m, imm: 80 sign-extended,TTT,imm
  7090                                  
  7091                                  
  7092                                  ;-1129             c = sflag + 0x80;
  7093                                  
  7094                                  .process274:
  7095 00002597 A0[3A00]                 mov al, [sflag]
  7096 0000259A 0480                     add al, 128
  7097 0000259C 8846FE                   mov [bp-2], al
  7098                                  
  7099                                  ;-1130             genCodeW(c);
  7100                                  
  7101 0000259F 8A46FE                   mov al, byte [bp-2]
  7102 000025A2 B400                     mov ah, 0
  7103 000025A4 50                       push ax
  7104 000025A5 E865EE                   call genCodeW
  7105 000025A8 83C402                   add  sp, 2
  7106                                  
  7107                                  ;-1131             writeEA(Code1);
  7108                                  
  7109 000025AB A0[3000]                 mov al, byte [Code1]
  7110 000025AE B400                     mov ah, 0
  7111 000025B0 50                       push ax
  7112 000025B1 E8C0EE                   call writeEA
  7113 000025B4 83C402                   add  sp, 2
  7114                                  
  7115                                  ;-1132             if (sflag) genCode8(imme);
  7116                                  
  7117 000025B7 A0[3A00]                 mov al, [sflag]
  7118 000025BA 08C0                     or  al, al
  7119 000025BC 0F840D00                 je .process277
  7120 000025C0 FF36[3F00]               push word [imme]
  7121 000025C4 E8CBED                   call genCode8
  7122 000025C7 83C402                   add  sp, 2
  7123                                  
  7124                                  ;-1133             else genImmediate();
  7125                                  
  7126 000025CA E90300                   jmp .process278
  7127                                  .process277:
  7128 000025CD E8AAEF                   call genImmediate
  7129                                  
  7130                                  ;-1134             return;
  7131                                  
  7132                                  .process278:
  7133 000025D0 E99407                   jmp .retnprocess
  7134                                  
  7135                                  ;-1135         }
  7136                                  
  7137                                  
  7138                                  ;-1136         c = Code1 << 3;//r/m, r/r
  7139                                  
  7140                                  .process273:
  7141 000025D3 A0[3000]                 mov al, [Code1]
  7142 000025D6 C0E003                   shl al, 3
  7143 000025D9 8846FE                   mov [bp-2], al
  7144                                  
  7145                                  ;-1137         if (Op == REG) {
  7146                                  
  7147 000025DC A0[2D00]                 mov al, [Op]
  7148 000025DF 3C02                     cmp al, 2
  7149 000025E1 0F852E00                 jne .process279
  7150                                  
  7151                                  ;-1138             if (Op2 == MEM) {//reg, mem
  7152                                  
  7153 000025E5 A0[2E00]                 mov al, [Op2]
  7154 000025E8 3C04                     cmp al, 4
  7155 000025EA 0F852500                 jne .process280
  7156                                  
  7157                                  ;-1139                 c += 2;//add direction flag
  7158                                  
  7159 000025EE 8046FE02                 add  byte[bp-2], 2
  7160                                  
  7161                                  ;-1140                 genCodeW(c);
  7162                                  
  7163 000025F2 8A46FE                   mov al, byte [bp-2]
  7164 000025F5 B400                     mov ah, 0
  7165 000025F7 50                       push ax
  7166 000025F8 E812EE                   call genCodeW
  7167 000025FB 83C402                   add  sp, 2
  7168                                  
  7169                                  ;-1141                 Op=Op2;//set MEM for writeEA
  7170                                  
  7171 000025FE A0[2E00]                 mov al, [Op2]
  7172 00002601 A2[2D00]                 mov byte [Op], al
  7173                                  
  7174                                  ;-1142                 writeEA(R1No);
  7175                                  
  7176 00002604 A0[3400]                 mov al, byte [R1No]
  7177 00002607 B400                     mov ah, 0
  7178 00002609 50                       push ax
  7179 0000260A E867EE                   call writeEA
  7180 0000260D 83C402                   add  sp, 2
  7181                                  
  7182                                  ;-1143                 return;
  7183                                  
  7184 00002610 E95407                   jmp .retnprocess
  7185                                  
  7186                                  ;-1144             }
  7187                                  
  7188                                  
  7189                                  ;-1145         }
  7190                                  
  7191                                  .process280:
  7192                                  
  7193                                  ;-1146         if (Op2 == REG) {//mem,reg    reg,reg
  7194                                  
  7195                                  .process279:
  7196 00002613 A0[2E00]                 mov al, [Op2]
  7197 00002616 3C02                     cmp al, 2
  7198 00002618 0F851B00                 jne .process281
  7199                                  
  7200                                  ;-1147             genCodeW(c);
  7201                                  
  7202 0000261C 8A46FE                   mov al, byte [bp-2]
  7203 0000261F B400                     mov ah, 0
  7204 00002621 50                       push ax
  7205 00002622 E8E8ED                   call genCodeW
  7206 00002625 83C402                   add  sp, 2
  7207                                  
  7208                                  ;-1148             writeEA(R2No);//2. Op in reg-field
  7209                                  
  7210 00002628 A0[3300]                 mov al, byte [R2No]
  7211 0000262B B400                     mov ah, 0
  7212 0000262D 50                       push ax
  7213 0000262E E843EE                   call writeEA
  7214 00002631 83C402                   add  sp, 2
  7215                                  
  7216                                  ;-1149             return;
  7217                                  
  7218 00002634 E93007                   jmp .retnprocess
  7219                                  
  7220                                  ;-1150         }
  7221                                  
  7222                                  
  7223                                  ;-1151         syntaxerror();
  7224                                  
  7225                                  .process281:
  7226 00002637 E811E6                   call syntaxerror
  7227                                  
  7228                                  ;-1152         return;
  7229                                  
  7230 0000263A E92A07                   jmp .retnprocess
  7231                                  
  7232                                  ;-1153     }
  7233                                  
  7234                                  
  7235                                  ;-1154 
  7236                                  
  7237                                  
  7238                                  ;-1155     if (CodeType == 5) {//mov (movsx, movzx=51)
  7239                                  
  7240                                  .process270:
  7241 0000263D A0[2F00]                 mov al, [CodeType]
  7242 00002640 3C05                     cmp al, 5
  7243 00002642 0F858B01                 jne .process282
  7244                                  
  7245                                  ;-1156         check2Ops();
  7246                                  
  7247 00002646 E867F5                   call check2Ops
  7248                                  
  7249                                  ;-1157         if (Op2 == ADR) {
  7250                                  
  7251 00002649 A0[2E00]                 mov al, [Op2]
  7252 0000264C 3C03                     cmp al, 3
  7253 0000264E 0F851B00                 jne .process283
  7254                                  
  7255                                  ;-1158             if (disp) imme=disp;
  7256                                  
  7257 00002652 A1[3D00]                 mov ax, [disp]
  7258 00002655 08C0                     or  al, al
  7259 00002657 0F840900                 je .process284
  7260 0000265B A1[3D00]                 mov ax, [disp]
  7261 0000265E A3[3F00]                 mov word [imme], ax
  7262                                  
  7263                                  ;-1159             else notfounderror();
  7264                                  
  7265 00002661 E90300                   jmp .process285
  7266                                  .process284:
  7267 00002664 E854E4                   call notfounderror
  7268                                  
  7269                                  ;-1160             Op2=IMM;//continue with IMM
  7270                                  
  7271                                  .process285:
  7272 00002667 B80100                   mov ax, 1
  7273 0000266A A2[2E00]                 mov byte [Op2], al
  7274                                  
  7275                                  ;-1161         }
  7276                                  
  7277                                  
  7278                                  ;-1162         if (Op2 == IMM) {// r,i
  7279                                  
  7280                                  .process283:
  7281 0000266D A0[2E00]                 mov al, [Op2]
  7282 00002670 3C01                     cmp al, 1
  7283 00002672 0F855400                 jne .process286
  7284                                  
  7285                                  ;-1163             if (Op == REG) {
  7286                                  
  7287 00002676 A0[2D00]                 mov al, [Op]
  7288 00002679 3C02                     cmp al, 2
  7289 0000267B 0F852500                 jne .process287
  7290                                  
  7291                                  ;-1164                 c = wflag << 3;
  7292                                  
  7293 0000267F A0[3800]                 mov al, [wflag]
  7294 00002682 C0E003                   shl al, 3
  7295 00002685 8846FE                   mov [bp-2], al
  7296                                  
  7297                                  ;-1165                 c += 0xB0;
  7298                                  
  7299 00002688 8046FEB0                 add  byte[bp-2], 176
  7300                                  
  7301                                  ;-1166                 genCode2(c, R1No);
  7302                                  
  7303 0000268C A0[3400]                 mov al, byte [R1No]
  7304 0000268F B400                     mov ah, 0
  7305 00002691 50                       push ax
  7306 00002692 8A46FE                   mov al, byte [bp-2]
  7307 00002695 B400                     mov ah, 0
  7308 00002697 50                       push ax
  7309 00002698 E857ED                   call genCode2
  7310 0000269B 83C404                   add  sp, 4
  7311                                  
  7312                                  ;-1167                 genImmediate();
  7313                                  
  7314 0000269E E8D9EE                   call genImmediate
  7315                                  
  7316                                  ;-1168                 return;
  7317                                  
  7318 000026A1 E9C306                   jmp .retnprocess
  7319                                  
  7320                                  ;-1169             }
  7321                                  
  7322                                  
  7323                                  ;-1170             if (Op == MEM) {// m,i
  7324                                  
  7325                                  .process287:
  7326 000026A4 A0[2D00]                 mov al, [Op]
  7327 000026A7 3C04                     cmp al, 4
  7328 000026A9 0F851700                 jne .process288
  7329                                  
  7330                                  ;-1171                 genCodeW(0xC6);
  7331                                  
  7332 000026AD 68C600                   push 198
  7333 000026B0 E85AED                   call genCodeW
  7334 000026B3 83C402                   add  sp, 2
  7335                                  
  7336                                  ;-1172                 writeEA( 0 );
  7337                                  
  7338 000026B6 6A00                     push 0
  7339 000026B8 E8B9ED                   call writeEA
  7340 000026BB 83C402                   add  sp, 2
  7341                                  
  7342                                  ;-1173                 genImmediate();
  7343                                  
  7344 000026BE E8B9EE                   call genImmediate
  7345                                  
  7346                                  ;-1174                 return;
  7347                                  
  7348 000026C1 E9A306                   jmp .retnprocess
  7349                                  
  7350                                  ;-1175             }
  7351                                  
  7352                                  
  7353                                  ;-1176             regmemerror();
  7354                                  
  7355                                  .process288:
  7356 000026C4 E80BE5                   call regmemerror
  7357                                  
  7358                                  ;-1177             return;
  7359                                  
  7360 000026C7 E99D06                   jmp .retnprocess
  7361                                  
  7362                                  ;-1178         }
  7363                                  
  7364                                  
  7365                                  ;-1179         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7366                                  
  7367                                  .process286:
  7368 000026CA A0[3600]                 mov al, [R1Type]
  7369 000026CD 3C04                     cmp al, 4
  7370 000026CF 0F850300                 jne .process289
  7371 000026D3 E8D0EF                   call ChangeDirection
  7372                                  
  7373                                  ;-1180         if (R2Type == SEGREG) {//rm,sreg
  7374                                  
  7375                                  .process289:
  7376 000026D6 A0[3500]                 mov al, [R2Type]
  7377 000026D9 3C04                     cmp al, 4
  7378 000026DB 0F852A00                 jne .process290
  7379                                  
  7380                                  ;-1181             if (OpSize != WORD) reg16error();
  7381                                  
  7382 000026DF A0[3700]                 mov al, [OpSize]
  7383 000026E2 3C02                     cmp al, 2
  7384 000026E4 0F840300                 je  .process291
  7385 000026E8 E811E5                   call reg16error
  7386                                  
  7387                                  ;-1182                 genCode2(0x8C, dflag);
  7388                                  
  7389                                  .process291:
  7390 000026EB A0[3900]                 mov al, byte [dflag]
  7391 000026EE B400                     mov ah, 0
  7392 000026F0 50                       push ax
  7393 000026F1 688C00                   push 140
  7394 000026F4 E8FBEC                   call genCode2
  7395 000026F7 83C404                   add  sp, 4
  7396                                  
  7397                                  ;-1183                 writeEA(R2No);
  7398                                  
  7399 000026FA A0[3300]                 mov al, byte [R2No]
  7400 000026FD B400                     mov ah, 0
  7401 000026FF 50                       push ax
  7402 00002700 E871ED                   call writeEA
  7403 00002703 83C402                   add  sp, 2
  7404                                  
  7405                                  ;-1184                 return;
  7406                                  
  7407 00002706 E95E06                   jmp .retnprocess
  7408                                  
  7409                                  ;-1185         }
  7410                                  
  7411                                  
  7412                                  ;-1186         if (Op2 == MEM) {//acc, moffs16
  7413                                  
  7414                                  .process290:
  7415 00002709 A0[2E00]                 mov al, [Op2]
  7416 0000270C 3C04                     cmp al, 4
  7417 0000270E 0F853100                 jne .process292
  7418                                  
  7419                                  ;-1187             if (Op == REG) {
  7420                                  
  7421 00002712 A0[2D00]                 mov al, [Op]
  7422 00002715 3C02                     cmp al, 2
  7423 00002717 0F852800                 jne .process293
  7424                                  
  7425                                  ;-1188                 if (R1No == 0) {
  7426                                  
  7427 0000271B A0[3400]                 mov al, [R1No]
  7428 0000271E 3C00                     cmp al, 0
  7429 00002720 0F851F00                 jne .process294
  7430                                  
  7431                                  ;-1189                     if (isDirect) {
  7432                                  
  7433 00002724 A0[3C00]                 mov al, [isDirect]
  7434 00002727 08C0                     or  al, al
  7435 00002729 0F841600                 je .process295
  7436                                  
  7437                                  ;-1190                         genCodeW(0xA0);
  7438                                  
  7439 0000272D 68A000                   push 160
  7440 00002730 E8DAEC                   call genCodeW
  7441 00002733 83C402                   add  sp, 2
  7442                                  
  7443                                  ;-1191                         genCode16(disp);
  7444                                  
  7445 00002736 FF36[3D00]               push word [disp]
  7446 0000273A E8ECEC                   call genCode16
  7447 0000273D 83C402                   add  sp, 2
  7448                                  
  7449                                  ;-1192                         return;
  7450                                  
  7451 00002740 E92406                   jmp .retnprocess
  7452                                  
  7453                                  ;-1193                     }
  7454                                  
  7455                                  
  7456                                  ;-1194                 }
  7457                                  
  7458                                  .process295:
  7459                                  
  7460                                  ;-1195             }
  7461                                  
  7462                                  .process294:
  7463                                  
  7464                                  ;-1196         }
  7465                                  
  7466                                  .process293:
  7467                                  
  7468                                  ;-1197         if (Op == MEM) {//moffs16, acc
  7469                                  
  7470                                  .process292:
  7471 00002743 A0[2D00]                 mov al, [Op]
  7472 00002746 3C04                     cmp al, 4
  7473 00002748 0F853100                 jne .process296
  7474                                  
  7475                                  ;-1198             if (Op2 == REG) {
  7476                                  
  7477 0000274C A0[2E00]                 mov al, [Op2]
  7478 0000274F 3C02                     cmp al, 2
  7479 00002751 0F852800                 jne .process297
  7480                                  
  7481                                  ;-1199                 if (R2No == 0) {
  7482                                  
  7483 00002755 A0[3300]                 mov al, [R2No]
  7484 00002758 3C00                     cmp al, 0
  7485 0000275A 0F851F00                 jne .process298
  7486                                  
  7487                                  ;-1200                     if (isDirect) {
  7488                                  
  7489 0000275E A0[3C00]                 mov al, [isDirect]
  7490 00002761 08C0                     or  al, al
  7491 00002763 0F841600                 je .process299
  7492                                  
  7493                                  ;-1201                         genCodeW(0xA2);
  7494                                  
  7495 00002767 68A200                   push 162
  7496 0000276A E8A0EC                   call genCodeW
  7497 0000276D 83C402                   add  sp, 2
  7498                                  
  7499                                  ;-1202                         genCode16(disp);
  7500                                  
  7501 00002770 FF36[3D00]               push word [disp]
  7502 00002774 E8B2EC                   call genCode16
  7503 00002777 83C402                   add  sp, 2
  7504                                  
  7505                                  ;-1203                         return;
  7506                                  
  7507 0000277A E9EA05                   jmp .retnprocess
  7508                                  
  7509                                  ;-1204                     }
  7510                                  
  7511                                  
  7512                                  ;-1205                 }
  7513                                  
  7514                                  .process299:
  7515                                  
  7516                                  ;-1206             }
  7517                                  
  7518                                  .process298:
  7519                                  
  7520                                  ;-1207 
  7521                                  
  7522                                  
  7523                                  ;-1208         }
  7524                                  
  7525                                  .process297:
  7526                                  
  7527                                  ;-1209         if (Op2 == REG) {//rm, r
  7528                                  
  7529                                  .process296:
  7530 0000277D A0[2E00]                 mov al, [Op2]
  7531 00002780 3C02                     cmp al, 2
  7532 00002782 0F851800                 jne .process300
  7533                                  
  7534                                  ;-1210             genCodeW(0x88);
  7535                                  
  7536 00002786 688800                   push 136
  7537 00002789 E881EC                   call genCodeW
  7538 0000278C 83C402                   add  sp, 2
  7539                                  
  7540                                  ;-1211             writeEA(R2No);
  7541                                  
  7542 0000278F A0[3300]                 mov al, byte [R2No]
  7543 00002792 B400                     mov ah, 0
  7544 00002794 50                       push ax
  7545 00002795 E8DCEC                   call writeEA
  7546 00002798 83C402                   add  sp, 2
  7547                                  
  7548                                  ;-1212             return;
  7549                                  
  7550 0000279B E9C905                   jmp .retnprocess
  7551                                  
  7552                                  ;-1213         }
  7553                                  
  7554                                  
  7555                                  ;-1214         if (Op2 == MEM) {//r, m
  7556                                  
  7557                                  .process300:
  7558 0000279E A0[2E00]                 mov al, [Op2]
  7559 000027A1 3C04                     cmp al, 4
  7560 000027A3 0F852400                 jne .process301
  7561                                  
  7562                                  ;-1215             if (Op == REG) {
  7563                                  
  7564 000027A7 A0[2D00]                 mov al, [Op]
  7565 000027AA 3C02                     cmp al, 2
  7566 000027AC 0F851B00                 jne .process302
  7567                                  
  7568                                  ;-1216                 ChangeDirection();
  7569                                  
  7570 000027B0 E8F3EE                   call ChangeDirection
  7571                                  
  7572                                  ;-1217                 genCodeW(0x8A);
  7573                                  
  7574 000027B3 688A00                   push 138
  7575 000027B6 E854EC                   call genCodeW
  7576 000027B9 83C402                   add  sp, 2
  7577                                  
  7578                                  ;-1218                 writeEA(R2No);
  7579                                  
  7580 000027BC A0[3300]                 mov al, byte [R2No]
  7581 000027BF B400                     mov ah, 0
  7582 000027C1 50                       push ax
  7583 000027C2 E8AFEC                   call writeEA
  7584 000027C5 83C402                   add  sp, 2
  7585                                  
  7586                                  ;-1219                 return;
  7587                                  
  7588 000027C8 E99C05                   jmp .retnprocess
  7589                                  
  7590                                  ;-1220             }
  7591                                  
  7592                                  
  7593                                  ;-1221         }
  7594                                  
  7595                                  .process302:
  7596                                  
  7597                                  ;-1222         syntaxerror();
  7598                                  
  7599                                  .process301:
  7600 000027CB E87DE4                   call syntaxerror
  7601                                  
  7602                                  ;-1223         return;
  7603                                  
  7604 000027CE E99605                   jmp .retnprocess
  7605                                  
  7606                                  ;-1224     }
  7607                                  
  7608                                  
  7609                                  ;-1225 
  7610                                  
  7611                                  
  7612                                  ;-1226     if (CodeType == 6) {//Jcc
  7613                                  
  7614                                  .process282:
  7615 000027D1 A0[2F00]                 mov al, [CodeType]
  7616 000027D4 3C06                     cmp al, 6
  7617 000027D6 0F85BE00                 jne .process303
  7618                                  
  7619                                  ;-1227         if (TokeType == ALNUME) {
  7620                                  
  7621 000027DA A0[2C00]                 mov al, [TokeType]
  7622 000027DD 3C03                     cmp al, 3
  7623 000027DF 0F85B500                 jne .process304
  7624                                  
  7625                                  ;-1228             LabelIx=searchLabel();
  7626                                  
  7627 000027E3 E8A0F0                   call searchLabel
  7628 000027E6 A3[4E00]                 mov word [LabelIx], ax
  7629                                  
  7630                                  ;-1229             if (LabelIx > 0) {
  7631                                  
  7632 000027E9 A1[4E00]                 mov ax, [LabelIx]
  7633 000027EC 83F800                   cmp ax, 0
  7634 000027EF 0F8E7A00                 jle .process305
  7635                                  
  7636                                  ;-1230                 disp=LabelAddr[LabelIx];
  7637                                  
  7638 000027F3 8B1E[4E00]               mov bx, [LabelIx]
  7639 000027F7 D1E3                     shl bx, 1
  7640 000027F9 8B87CA8E                 mov ax, [LabelAddr + bx]
  7641 000027FD A3[3D00]                 mov word [disp], ax
  7642                                  
  7643                                  ;-1231                 disp = disp - PC;
  7644                                  
  7645 00002800 A1[3D00]                 mov ax, [disp]
  7646 00002803 2B06[2300]               sub ax, [PC]
  7647 00002807 A3[3D00]                 mov word [disp], ax
  7648                                  
  7649                                  ;-1232                 disp = disp - Origin;
  7650                                  
  7651 0000280A A1[3D00]                 mov ax, [disp]
  7652 0000280D 2B06[2500]               sub ax, [Origin]
  7653 00002811 A3[3D00]                 mov word [disp], ax
  7654                                  
  7655                                  ;-1233                 if (checkConstSize(disp) ) {
  7656                                  
  7657 00002814 FF36[3D00]               push word [disp]
  7658 00002818 E85FEE                   call checkConstSize
  7659 0000281B 83C402                   add  sp, 2
  7660 0000281E 08C0                     or  al, al
  7661 00002820 0F842000                 je .process306
  7662                                  
  7663                                  ;-1234                     genCode2(Code1, 0x70);//short
  7664                                  
  7665 00002824 6A70                     push 112
  7666 00002826 A0[3000]                 mov al, byte [Code1]
  7667 00002829 B400                     mov ah, 0
  7668 0000282B 50                       push ax
  7669 0000282C E8C3EB                   call genCode2
  7670 0000282F 83C404                   add  sp, 4
  7671                                  
  7672                                  ;-1235                     disp -= 2;
  7673                                  
  7674 00002832 832E[3D00]02             sub  word[disp], 2
  7675                                  
  7676                                  ;-1236                     genCode8(disp);
  7677                                  
  7678 00002837 FF36[3D00]               push word [disp]
  7679 0000283B E854EB                   call genCode8
  7680 0000283E 83C402                   add  sp, 2
  7681                                  
  7682                                  ;-1237                 } else {
  7683                                  
  7684 00002841 E92600                   jmp .process307
  7685                                  .process306:
  7686                                  
  7687                                  ;-1238                     genCode8(0x0F);
  7688                                  
  7689 00002844 6A0F                     push 15
  7690 00002846 E849EB                   call genCode8
  7691 00002849 83C402                   add  sp, 2
  7692                                  
  7693                                  ;-1239                     genCode2(Code1, 0x80);//near
  7694                                  
  7695 0000284C 688000                   push 128
  7696 0000284F A0[3000]                 mov al, byte [Code1]
  7697 00002852 B400                     mov ah, 0
  7698 00002854 50                       push ax
  7699 00002855 E89AEB                   call genCode2
  7700 00002858 83C404                   add  sp, 4
  7701                                  
  7702                                  ;-1240                     disp -= 4;
  7703                                  
  7704 0000285B 832E[3D00]04             sub  word[disp], 4
  7705                                  
  7706                                  ;-1241                     genCode16(disp);
  7707                                  
  7708 00002860 FF36[3D00]               push word [disp]
  7709 00002864 E8C2EB                   call genCode16
  7710 00002867 83C402                   add  sp, 2
  7711                                  
  7712                                  ;-1242                 }
  7713                                  
  7714                                  
  7715                                  ;-1243             }
  7716                                  
  7717                                  .process307:
  7718                                  
  7719                                  ;-1244             else {//jump forward, near only
  7720                                  
  7721 0000286A E92800                   jmp .process308
  7722                                  .process305:
  7723                                  
  7724                                  ;-1245                 genCode8(0x0F);
  7725                                  
  7726 0000286D 6A0F                     push 15
  7727 0000286F E820EB                   call genCode8
  7728 00002872 83C402                   add  sp, 2
  7729                                  
  7730                                  ;-1246                 genCode2(Code1, 0x80);
  7731                                  
  7732 00002875 688000                   push 128
  7733 00002878 A0[3000]                 mov al, byte [Code1]
  7734 0000287B B400                     mov ah, 0
  7735 0000287D 50                       push ax
  7736 0000287E E871EB                   call genCode2
  7737 00002881 83C404                   add  sp, 4
  7738                                  
  7739                                  ;-1247                 storeJmp();
  7740                                  
  7741 00002884 E860F3                   call storeJmp
  7742                                  
  7743                                  ;-1248                 genCode16(0);
  7744                                  
  7745 00002887 6A00                     push 0
  7746 00002889 E89DEB                   call genCode16
  7747 0000288C 83C402                   add  sp, 2
  7748                                  
  7749                                  ;-1249                 PrintRA='r';
  7750                                  
  7751 0000288F B87200                   mov ax, 114
  7752 00002892 A2[4500]                 mov byte [PrintRA], al
  7753                                  
  7754                                  ;-1250             }
  7755                                  
  7756                                  
  7757                                  ;-1251         return;
  7758                                  
  7759                                  .process308:
  7760 00002895 E9CF04                   jmp .retnprocess
  7761                                  
  7762                                  ;-1252         }
  7763                                  
  7764                                  
  7765                                  ;-1253     }
  7766                                  
  7767                                  .process304:
  7768                                  
  7769                                  ;-1254 
  7770                                  
  7771                                  
  7772                                  ;-1255     if (CodeType == 7) {//jmp, call
  7773                                  
  7774                                  .process303:
  7775 00002898 A0[2F00]                 mov al, [CodeType]
  7776 0000289B 3C07                     cmp al, 7
  7777 0000289D 0F85D400                 jne .process309
  7778                                  
  7779                                  ;-1256         if (TokeType == ALNUME) {
  7780                                  
  7781 000028A1 A0[2C00]                 mov al, [TokeType]
  7782 000028A4 3C03                     cmp al, 3
  7783 000028A6 0F85CB00                 jne .process310
  7784                                  
  7785                                  ;-1257             LabelIx=searchLabel();
  7786                                  
  7787 000028AA E8D9EF                   call searchLabel
  7788 000028AD A3[4E00]                 mov word [LabelIx], ax
  7789                                  
  7790                                  ;-1258             if (LabelIx > 0) {
  7791                                  
  7792 000028B0 A1[4E00]                 mov ax, [LabelIx]
  7793 000028B3 83F800                   cmp ax, 0
  7794 000028B6 0F8E9100                 jle .process311
  7795                                  
  7796                                  ;-1259                 disp=LabelAddr[LabelIx];
  7797                                  
  7798 000028BA 8B1E[4E00]               mov bx, [LabelIx]
  7799 000028BE D1E3                     shl bx, 1
  7800 000028C0 8B87CA8E                 mov ax, [LabelAddr + bx]
  7801 000028C4 A3[3D00]                 mov word [disp], ax
  7802                                  
  7803                                  ;-1260                 disp = disp - PC;
  7804                                  
  7805 000028C7 A1[3D00]                 mov ax, [disp]
  7806 000028CA 2B06[2300]               sub ax, [PC]
  7807 000028CE A3[3D00]                 mov word [disp], ax
  7808                                  
  7809                                  ;-1261                 disp = disp - Origin;
  7810                                  
  7811 000028D1 A1[3D00]                 mov ax, [disp]
  7812 000028D4 2B06[2500]               sub ax, [Origin]
  7813 000028D8 A3[3D00]                 mov word [disp], ax
  7814                                  
  7815                                  ;-1262                 if (checkConstSize(disp) ) {
  7816                                  
  7817 000028DB FF36[3D00]               push word [disp]
  7818 000028DF E898ED                   call checkConstSize
  7819 000028E2 83C402                   add  sp, 2
  7820 000028E5 08C0                     or  al, al
  7821 000028E7 0F844200                 je .process312
  7822                                  
  7823                                  ;-1263                     if (Code1 == 0xE9) {//jmp only
  7824                                  
  7825 000028EB A0[3000]                 mov al, [Code1]
  7826 000028EE 3CE9                     cmp al, 233
  7827 000028F0 0F851B00                 jne .process313
  7828                                  
  7829                                  ;-1264                         genCode8(0xEB);//short
  7830                                  
  7831 000028F4 68EB00                   push 235
  7832 000028F7 E898EA                   call genCode8
  7833 000028FA 83C402                   add  sp, 2
  7834                                  
  7835                                  ;-1265                         disp -= 2;
  7836                                  
  7837 000028FD 832E[3D00]02             sub  word[disp], 2
  7838                                  
  7839                                  ;-1266                         genCode8(disp);
  7840                                  
  7841 00002902 FF36[3D00]               push word [disp]
  7842 00002906 E889EA                   call genCode8
  7843 00002909 83C402                   add  sp, 2
  7844                                  
  7845                                  ;-1267                     }
  7846                                  
  7847                                  
  7848                                  ;-1268                     else {
  7849                                  
  7850 0000290C E91B00                   jmp .process314
  7851                                  .process313:
  7852                                  
  7853                                  ;-1269                         genCode8(Code1);//near
  7854                                  
  7855 0000290F A0[3000]                 mov al, byte [Code1]
  7856 00002912 B400                     mov ah, 0
  7857 00002914 50                       push ax
  7858 00002915 E87AEA                   call genCode8
  7859 00002918 83C402                   add  sp, 2
  7860                                  
  7861                                  ;-1270                         disp -= 3;
  7862                                  
  7863 0000291B 832E[3D00]03             sub  word[disp], 3
  7864                                  
  7865                                  ;-1271                         genCode16(disp);
  7866                                  
  7867 00002920 FF36[3D00]               push word [disp]
  7868 00002924 E802EB                   call genCode16
  7869 00002927 83C402                   add  sp, 2
  7870                                  
  7871                                  ;-1272                     }
  7872                                  
  7873                                  
  7874                                  ;-1273                 }
  7875                                  
  7876                                  .process314:
  7877                                  
  7878                                  ;-1274                 else {
  7879                                  
  7880 0000292A E91B00                   jmp .process315
  7881                                  .process312:
  7882                                  
  7883                                  ;-1275                     genCode8(Code1);//near
  7884                                  
  7885 0000292D A0[3000]                 mov al, byte [Code1]
  7886 00002930 B400                     mov ah, 0
  7887 00002932 50                       push ax
  7888 00002933 E85CEA                   call genCode8
  7889 00002936 83C402                   add  sp, 2
  7890                                  
  7891                                  ;-1276                     disp -= 3;
  7892                                  
  7893 00002939 832E[3D00]03             sub  word[disp], 3
  7894                                  
  7895                                  ;-1277                     genCode16(disp);
  7896                                  
  7897 0000293E FF36[3D00]               push word [disp]
  7898 00002942 E8E4EA                   call genCode16
  7899 00002945 83C402                   add  sp, 2
  7900                                  
  7901                                  ;-1278                 }
  7902                                  
  7903                                  
  7904                                  ;-1279             }
  7905                                  
  7906                                  .process315:
  7907                                  
  7908                                  ;-1280             else {//jump forward, near only
  7909                                  
  7910 00002948 E92700                   jmp .process316
  7911                                  .process311:
  7912                                  
  7913                                  ;-1281                 genCode8(Code1);  
  7914                                  
  7915 0000294B A0[3000]                 mov al, byte [Code1]
  7916 0000294E B400                     mov ah, 0
  7917 00002950 50                       push ax
  7918 00002951 E83EEA                   call genCode8
  7919 00002954 83C402                   add  sp, 2
  7920                                  
  7921                                  ;-1282                 if (PC != 1) storeJmp();//omit jmp main
  7922                                  
  7923 00002957 A1[2300]                 mov ax, [PC]
  7924 0000295A 83F801                   cmp ax, 1
  7925 0000295D 0F840300                 je  .process317
  7926 00002961 E883F2                   call storeJmp
  7927                                  
  7928                                  ;-1283                 genCode16(0);
  7929                                  
  7930                                  .process317:
  7931 00002964 6A00                     push 0
  7932 00002966 E8C0EA                   call genCode16
  7933 00002969 83C402                   add  sp, 2
  7934                                  
  7935                                  ;-1284                 PrintRA='R';
  7936                                  
  7937 0000296C B85200                   mov ax, 82
  7938 0000296F A2[4500]                 mov byte [PrintRA], al
  7939                                  
  7940                                  ;-1285             }
  7941                                  
  7942                                  
  7943                                  ;-1286         return;
  7944                                  
  7945                                  .process316:
  7946 00002972 E9F203                   jmp .retnprocess
  7947                                  
  7948                                  ;-1287         }
  7949                                  
  7950                                  
  7951                                  ;-1288     }
  7952                                  
  7953                                  .process310:
  7954                                  
  7955                                  ;-1289 
  7956                                  
  7957                                  
  7958                                  ;-1290     if (CodeType ==  8) {//ret,retf
  7959                                  
  7960                                  .process309:
  7961 00002975 A0[2F00]                 mov al, [CodeType]
  7962 00002978 3C08                     cmp al, 8
  7963 0000297A 0F853100                 jne .process318
  7964                                  
  7965                                  ;-1291         if (TokeType == DIGIT) {
  7966                                  
  7967 0000297E A0[2C00]                 mov al, [TokeType]
  7968 00002981 3C01                     cmp al, 1
  7969 00002983 0F851900                 jne .process319
  7970                                  
  7971                                  ;-1292             genCode8(Code2);
  7972                                  
  7973 00002987 A0[3100]                 mov al, byte [Code2]
  7974 0000298A B400                     mov ah, 0
  7975 0000298C 50                       push ax
  7976 0000298D E802EA                   call genCode8
  7977 00002990 83C402                   add  sp, 2
  7978                                  
  7979                                  ;-1293             genCode16(SymbolInt);
  7980                                  
  7981 00002993 FF36[0E00]               push word [SymbolInt]
  7982 00002997 E88FEA                   call genCode16
  7983 0000299A 83C402                   add  sp, 2
  7984                                  
  7985                                  ;-1294             return;
  7986                                  
  7987 0000299D E9C703                   jmp .retnprocess
  7988                                  
  7989                                  ;-1295         }
  7990                                  
  7991                                  
  7992                                  ;-1296         genCode8(Code1);
  7993                                  
  7994                                  .process319:
  7995 000029A0 A0[3000]                 mov al, byte [Code1]
  7996 000029A3 B400                     mov ah, 0
  7997 000029A5 50                       push ax
  7998 000029A6 E8E9E9                   call genCode8
  7999 000029A9 83C402                   add  sp, 2
  8000                                  
  8001                                  ;-1297         return;
  8002                                  
  8003 000029AC E9B803                   jmp .retnprocess
  8004                                  
  8005                                  ;-1298     }
  8006                                  
  8007                                  
  8008                                  ;-1299 
  8009                                  
  8010                                  
  8011                                  ;-1300     if (CodeType == 9) {//push, pop
  8012                                  
  8013                                  .process318:
  8014 000029AF A0[2F00]                 mov al, [CodeType]
  8015 000029B2 3C09                     cmp al, 9
  8016 000029B4 0F854A01                 jne .process320
  8017                                  
  8018                                  ;-1301         getOpL();
  8019                                  
  8020 000029B8 E8BEF1                   call getOpL
  8021                                  
  8022                                  ;-1302         if (Code1 == 0x50) {//push only
  8023                                  
  8024 000029BB A0[3000]                 mov al, [Code1]
  8025 000029BE 3C50                     cmp al, 80
  8026 000029C0 0F858400                 jne .process321
  8027                                  
  8028                                  ;-1303             if (Op == IMM) {//push imm8,16
  8029                                  
  8030 000029C4 A0[2D00]                 mov al, [Op]
  8031 000029C7 3C01                     cmp al, 1
  8032 000029C9 0F853400                 jne .process322
  8033                                  
  8034                                  ;-1304                 setsflag();
  8035                                  
  8036 000029CD E84EEC                   call setsflag
  8037                                  
  8038                                  ;-1305                 genCode2(0x68, sflag);
  8039                                  
  8040 000029D0 A0[3A00]                 mov al, byte [sflag]
  8041 000029D3 B400                     mov ah, 0
  8042 000029D5 50                       push ax
  8043 000029D6 6A68                     push 104
  8044 000029D8 E817EA                   call genCode2
  8045 000029DB 83C404                   add  sp, 4
  8046                                  
  8047                                  ;-1306                 if (sflag) genCode8 (imme);
  8048                                  
  8049 000029DE A0[3A00]                 mov al, [sflag]
  8050 000029E1 08C0                     or  al, al
  8051 000029E3 0F840D00                 je .process323
  8052 000029E7 FF36[3F00]               push word [imme]
  8053 000029EB E8A4E9                   call genCode8
  8054 000029EE 83C402                   add  sp, 2
  8055                                  
  8056                                  ;-1307                 else       genCode16(imme);
  8057                                  
  8058 000029F1 E90A00                   jmp .process324
  8059                                  .process323:
  8060 000029F4 FF36[3F00]               push word [imme]
  8061 000029F8 E82EEA                   call genCode16
  8062 000029FB 83C402                   add  sp, 2
  8063                                  
  8064                                  ;-1308                 return;
  8065                                  
  8066                                  .process324:
  8067 000029FE E96603                   jmp .retnprocess
  8068                                  
  8069                                  ;-1309             }
  8070                                  
  8071                                  
  8072                                  ;-1310             if (Op == ADR) {//push string ABSOLUTE i16 
  8073                                  
  8074                                  .process322:
  8075 00002A01 A0[2D00]                 mov al, [Op]
  8076 00002A04 3C03                     cmp al, 3
  8077 00002A06 0F853E00                 jne .process325
  8078                                  
  8079                                  ;-1311 //prscomment("\n push disp: "); printhex16 (disp);
  8080                                  
  8081                                  
  8082                                  ;-1312                 if (disp) {
  8083                                  
  8084 00002A0A A1[3D00]                 mov ax, [disp]
  8085 00002A0D 08C0                     or  al, al
  8086 00002A0F 0F841800                 je .process326
  8087                                  
  8088                                  ;-1313                     genCode8(0x68);
  8089                                  
  8090 00002A13 6A68                     push 104
  8091 00002A15 E87AE9                   call genCode8
  8092 00002A18 83C402                   add  sp, 2
  8093                                  
  8094                                  ;-1314                     genCode16(disp);
  8095                                  
  8096 00002A1B FF36[3D00]               push word [disp]
  8097 00002A1F E807EA                   call genCode16
  8098 00002A22 83C402                   add  sp, 2
  8099                                  
  8100                                  ;-1315                     return;
  8101                                  
  8102 00002A25 E93F03                   jmp .retnprocess
  8103                                  
  8104                                  ;-1316                 }
  8105                                  
  8106                                  
  8107                                  ;-1317                 else {
  8108                                  
  8109 00002A28 E91D00                   jmp .process327
  8110                                  .process326:
  8111                                  
  8112                                  ;-1318                     genCode8(0x68);
  8113                                  
  8114 00002A2B 6A68                     push 104
  8115 00002A2D E862E9                   call genCode8
  8116 00002A30 83C402                   add  sp, 2
  8117                                  
  8118                                  ;-1319                     storeJmp();
  8119                                  
  8120 00002A33 E8B1F1                   call storeJmp
  8121                                  
  8122                                  ;-1320                     genCode16(0xAAAA);//magic for abs ADR
  8123                                  
  8124 00002A36 68AAAA                   push 43690
  8125 00002A39 E8EDE9                   call genCode16
  8126 00002A3C 83C402                   add  sp, 2
  8127                                  
  8128                                  ;-1321                     PrintRA='A';
  8129                                  
  8130 00002A3F B84100                   mov ax, 65
  8131 00002A42 A2[4500]                 mov byte [PrintRA], al
  8132                                  
  8133                                  ;-1322                     return;
  8134                                  
  8135 00002A45 E91F03                   jmp .retnprocess
  8136                                  
  8137                                  ;-1323                 }
  8138                                  
  8139                                  
  8140                                  ;-1324             }
  8141                                  
  8142                                  .process327:
  8143                                  
  8144                                  ;-1325         }
  8145                                  
  8146                                  .process325:
  8147                                  
  8148                                  ;-1326         if (R1Type == SEGREG) {
  8149                                  
  8150                                  .process321:
  8151 00002A48 A0[3600]                 mov al, [R1Type]
  8152 00002A4B 3C04                     cmp al, 4
  8153 00002A4D 0F855A00                 jne .process328
  8154                                  
  8155                                  ;-1327             if (Code1 == 0x58) {//pop only
  8156                                  
  8157 00002A51 A0[3000]                 mov al, [Code1]
  8158 00002A54 3C58                     cmp al, 88
  8159 00002A56 0F851200                 jne .process329
  8160                                  
  8161                                  ;-1328                 if (R1No == 1) error1("pop cs not allowed");
  8162                                  
  8163 00002A5A A0[3400]                 mov al, [R1No]
  8164 00002A5D 3C01                     cmp al, 1
  8165 00002A5F 0F850900                 jne .process330
  8166 00002A63 68[692D]                 push process_0
  8167 00002A66 E8E1DF                   call error1
  8168 00002A69 83C402                   add  sp, 2
  8169                                  
  8170                                  ;-1329             }
  8171                                  
  8172                                  .process330:
  8173                                  
  8174                                  ;-1330             c = R1No <<3;
  8175                                  
  8176                                  .process329:
  8177 00002A6C A0[3400]                 mov al, [R1No]
  8178 00002A6F C0E003                   shl al, 3
  8179 00002A72 8846FE                   mov [bp-2], al
  8180                                  
  8181                                  ;-1331             if (R1No > 3) {//FS, GS
  8182                                  
  8183 00002A75 A0[3400]                 mov al, [R1No]
  8184 00002A78 3C03                     cmp al, 3
  8185 00002A7A 0F8E0C00                 jle .process331
  8186                                  
  8187                                  ;-1332                 c += 122;
  8188                                  
  8189 00002A7E 8046FE7A                 add  byte[bp-2], 122
  8190                                  
  8191                                  ;-1333                 genCode8(0x0F);
  8192                                  
  8193 00002A82 6A0F                     push 15
  8194 00002A84 E80BE9                   call genCode8
  8195 00002A87 83C402                   add  sp, 2
  8196                                  
  8197                                  ;-1334             }
  8198                                  
  8199                                  
  8200                                  ;-1335             OpCodePtr++;
  8201                                  
  8202                                  .process331:
  8203 00002A8A FF06[4300]               inc  word[OpCodePtr]
  8204                                  
  8205                                  ;-1336             c = c + *OpCodePtr;////////////////is Code4
  8206                                  
  8207 00002A8E 8A46FE                   mov al, [bp-2]
  8208 00002A91 8B1E[4300]               mov bx, [OpCodePtr]
  8209 00002A95 0207                     add al, [bx]
  8210 00002A97 B400                     mov ah, 0
  8211 00002A99 8846FE                   mov [bp-2], al
  8212                                  
  8213                                  ;-1337             genCode8(c);
  8214                                  
  8215 00002A9C 8A46FE                   mov al, byte [bp-2]
  8216 00002A9F B400                     mov ah, 0
  8217 00002AA1 50                       push ax
  8218 00002AA2 E8EDE8                   call genCode8
  8219 00002AA5 83C402                   add  sp, 2
  8220                                  
  8221                                  ;-1338             return;
  8222                                  
  8223 00002AA8 E9BC02                   jmp .retnprocess
  8224                                  
  8225                                  ;-1339         }
  8226                                  
  8227                                  
  8228                                  ;-1340         checkOpL();//no ADR, SEGREG
  8229                                  
  8230                                  .process328:
  8231 00002AAB E856ED                   call checkOpL
  8232                                  
  8233                                  ;-1341         if (R1Type == BYTE) reg16error();
  8234                                  
  8235 00002AAE A0[3600]                 mov al, [R1Type]
  8236 00002AB1 3C01                     cmp al, 1
  8237 00002AB3 0F850300                 jne .process332
  8238 00002AB7 E842E1                   call reg16error
  8239                                  
  8240                                  ;-1342         if (R1Type == WORD) {
  8241                                  
  8242                                  .process332:
  8243 00002ABA A0[3600]                 mov al, [R1Type]
  8244 00002ABD 3C02                     cmp al, 2
  8245 00002ABF 0F851500                 jne .process333
  8246                                  
  8247                                  ;-1343             genCode2(Code1, R1No);
  8248                                  
  8249 00002AC3 A0[3400]                 mov al, byte [R1No]
  8250 00002AC6 B400                     mov ah, 0
  8251 00002AC8 50                       push ax
  8252 00002AC9 A0[3000]                 mov al, byte [Code1]
  8253 00002ACC B400                     mov ah, 0
  8254 00002ACE 50                       push ax
  8255 00002ACF E820E9                   call genCode2
  8256 00002AD2 83C404                   add  sp, 4
  8257                                  
  8258                                  ;-1344             return;
  8259                                  
  8260 00002AD5 E98F02                   jmp .retnprocess
  8261                                  
  8262                                  ;-1345         }
  8263                                  
  8264                                  
  8265                                  ;-1346         if (Op == MEM) {
  8266                                  
  8267                                  .process333:
  8268 00002AD8 A0[2D00]                 mov al, [Op]
  8269 00002ADB 3C04                     cmp al, 4
  8270 00002ADD 0F851B00                 jne .process334
  8271                                  
  8272                                  ;-1347             genCode8(Code2);
  8273                                  
  8274 00002AE1 A0[3100]                 mov al, byte [Code2]
  8275 00002AE4 B400                     mov ah, 0
  8276 00002AE6 50                       push ax
  8277 00002AE7 E8A8E8                   call genCode8
  8278 00002AEA 83C402                   add  sp, 2
  8279                                  
  8280                                  ;-1348             writeEA(Code3);//////////////////Code3
  8281                                  
  8282 00002AED A0[3200]                 mov al, byte [Code3]
  8283 00002AF0 B400                     mov ah, 0
  8284 00002AF2 50                       push ax
  8285 00002AF3 E87EE9                   call writeEA
  8286 00002AF6 83C402                   add  sp, 2
  8287                                  
  8288                                  ;-1349             return;
  8289                                  
  8290 00002AF9 E96B02                   jmp .retnprocess
  8291                                  
  8292                                  ;-1350         }
  8293                                  
  8294                                  
  8295                                  ;-1351         syntaxerror();
  8296                                  
  8297                                  .process334:
  8298 00002AFC E84CE1                   call syntaxerror
  8299                                  
  8300                                  ;-1352         return;
  8301                                  
  8302 00002AFF E96502                   jmp .retnprocess
  8303                                  
  8304                                  ;-1353     }
  8305                                  
  8306                                  
  8307                                  ;-1354 
  8308                                  
  8309                                  
  8310                                  ;-1355     if (CodeType == 11) {//shift, rotate
  8311                                  
  8312                                  .process320:
  8313 00002B02 A0[2F00]                 mov al, [CodeType]
  8314 00002B05 3C0B                     cmp al, 11
  8315 00002B07 0F859200                 jne .process335
  8316                                  
  8317                                  ;-1356         check2Ops();
  8318                                  
  8319 00002B0B E8A2F0                   call check2Ops
  8320                                  
  8321                                  ;-1357         if (Op2 == IMM) {
  8322                                  
  8323 00002B0E A0[2E00]                 mov al, [Op2]
  8324 00002B11 3C01                     cmp al, 1
  8325 00002B13 0F854400                 jne .process336
  8326                                  
  8327                                  ;-1358             if (imme == 1) {
  8328                                  
  8329 00002B17 A1[3F00]                 mov ax, [imme]
  8330 00002B1A 83F801                   cmp ax, 1
  8331 00002B1D 0F851800                 jne .process337
  8332                                  
  8333                                  ;-1359                 genCodeW(0xD0);
  8334                                  
  8335 00002B21 68D000                   push 208
  8336 00002B24 E8E6E8                   call genCodeW
  8337 00002B27 83C402                   add  sp, 2
  8338                                  
  8339                                  ;-1360                 writeEA(Code1);
  8340                                  
  8341 00002B2A A0[3000]                 mov al, byte [Code1]
  8342 00002B2D B400                     mov ah, 0
  8343 00002B2F 50                       push ax
  8344 00002B30 E841E9                   call writeEA
  8345 00002B33 83C402                   add  sp, 2
  8346                                  
  8347                                  ;-1361                 return;
  8348                                  
  8349 00002B36 E92E02                   jmp .retnprocess
  8350                                  
  8351                                  ;-1362             }
  8352                                  
  8353                                  
  8354                                  ;-1363             genCodeW(0xC0);//80186
  8355                                  
  8356                                  .process337:
  8357 00002B39 68C000                   push 192
  8358 00002B3C E8CEE8                   call genCodeW
  8359 00002B3F 83C402                   add  sp, 2
  8360                                  
  8361                                  ;-1364             writeEA(Code1);
  8362                                  
  8363 00002B42 A0[3000]                 mov al, byte [Code1]
  8364 00002B45 B400                     mov ah, 0
  8365 00002B47 50                       push ax
  8366 00002B48 E829E9                   call writeEA
  8367 00002B4B 83C402                   add  sp, 2
  8368                                  
  8369                                  ;-1365             genCode8(imme);
  8370                                  
  8371 00002B4E FF36[3F00]               push word [imme]
  8372 00002B52 E83DE8                   call genCode8
  8373 00002B55 83C402                   add  sp, 2
  8374                                  
  8375                                  ;-1366             return;
  8376                                  
  8377 00002B58 E90C02                   jmp .retnprocess
  8378                                  
  8379                                  ;-1367         }
  8380                                  
  8381                                  
  8382                                  ;-1368         if (Op2 == REG) {
  8383                                  
  8384                                  .process336:
  8385 00002B5B A0[2E00]                 mov al, [Op2]
  8386 00002B5E 3C02                     cmp al, 2
  8387 00002B60 0F853900                 jne .process338
  8388                                  
  8389                                  ;-1369             if (R2Type == BYTE) {
  8390                                  
  8391 00002B64 A0[3500]                 mov al, [R2Type]
  8392 00002B67 3C01                     cmp al, 1
  8393 00002B69 0F853000                 jne .process339
  8394                                  
  8395                                  ;-1370                 if (R2No == 1) {//CL-REG
  8396                                  
  8397 00002B6D A0[3300]                 mov al, [R2No]
  8398 00002B70 3C01                     cmp al, 1
  8399 00002B72 0F852700                 jne .process340
  8400                                  
  8401                                  ;-1371                     if (R1Type == WORD) wflag=1;//hack
  8402                                  
  8403 00002B76 A0[3600]                 mov al, [R1Type]
  8404 00002B79 3C02                     cmp al, 2
  8405 00002B7B 0F850600                 jne .process341
  8406 00002B7F B80100                   mov ax, 1
  8407 00002B82 A2[3800]                 mov byte [wflag], al
  8408                                  
  8409                                  ;-1372                     genCodeW(0xD2);
  8410                                  
  8411                                  .process341:
  8412 00002B85 68D200                   push 210
  8413 00002B88 E882E8                   call genCodeW
  8414 00002B8B 83C402                   add  sp, 2
  8415                                  
  8416                                  ;-1373                     writeEA(Code1);
  8417                                  
  8418 00002B8E A0[3000]                 mov al, byte [Code1]
  8419 00002B91 B400                     mov ah, 0
  8420 00002B93 50                       push ax
  8421 00002B94 E8DDE8                   call writeEA
  8422 00002B97 83C402                   add  sp, 2
  8423                                  
  8424                                  ;-1374                     return;
  8425                                  
  8426 00002B9A E9CA01                   jmp .retnprocess
  8427                                  
  8428                                  ;-1375                 }
  8429                                  
  8430                                  
  8431                                  ;-1376             }
  8432                                  
  8433                                  .process340:
  8434                                  
  8435                                  ;-1377         }
  8436                                  
  8437                                  .process339:
  8438                                  
  8439                                  ;-1378     }
  8440                                  
  8441                                  .process338:
  8442                                  
  8443                                  ;-1379 
  8444                                  
  8445                                  
  8446                                  ;-1380     if (CodeType == 12) {//int
  8447                                  
  8448                                  .process335:
  8449 00002B9D A0[2F00]                 mov al, [CodeType]
  8450 00002BA0 3C0C                     cmp al, 12
  8451 00002BA2 0F852200                 jne .process342
  8452                                  
  8453                                  ;-1381         if (TokeType == DIGIT) {
  8454                                  
  8455 00002BA6 A0[2C00]                 mov al, [TokeType]
  8456 00002BA9 3C01                     cmp al, 1
  8457 00002BAB 0F851900                 jne .process343
  8458                                  
  8459                                  ;-1382             genCode8(Code1);
  8460                                  
  8461 00002BAF A0[3000]                 mov al, byte [Code1]
  8462 00002BB2 B400                     mov ah, 0
  8463 00002BB4 50                       push ax
  8464 00002BB5 E8DAE7                   call genCode8
  8465 00002BB8 83C402                   add  sp, 2
  8466                                  
  8467                                  ;-1383             genCode8(SymbolInt);
  8468                                  
  8469 00002BBB FF36[0E00]               push word [SymbolInt]
  8470 00002BBF E8D0E7                   call genCode8
  8471 00002BC2 83C402                   add  sp, 2
  8472                                  
  8473                                  ;-1384             return;
  8474                                  
  8475 00002BC5 E99F01                   jmp .retnprocess
  8476                                  
  8477                                  ;-1385         }
  8478                                  
  8479                                  
  8480                                  ;-1386     }
  8481                                  
  8482                                  .process343:
  8483                                  
  8484                                  ;-1387 
  8485                                  
  8486                                  
  8487                                  ;-1388     if (CodeType == 30) {//enter i18,i8
  8488                                  
  8489                                  .process342:
  8490 00002BC8 A0[2F00]                 mov al, [CodeType]
  8491 00002BCB 3C1E                     cmp al, 30
  8492 00002BCD 0F855200                 jne .process344
  8493                                  
  8494                                  ;-1389         genCode8(0xC8);
  8495                                  
  8496 00002BD1 68C800                   push 200
  8497 00002BD4 E8BBE7                   call genCode8
  8498 00002BD7 83C402                   add  sp, 2
  8499                                  
  8500                                  ;-1390         Op=getOp1();
  8501                                  
  8502 00002BDA E8FDEC                   call getOp1
  8503 00002BDD A2[2D00]                 mov byte [Op], al
  8504                                  
  8505                                  ;-1391         if (Op == IMM) genCode16(SymbolInt);
  8506                                  
  8507 00002BE0 A0[2D00]                 mov al, [Op]
  8508 00002BE3 3C01                     cmp al, 1
  8509 00002BE5 0F850D00                 jne .process345
  8510 00002BE9 FF36[0E00]               push word [SymbolInt]
  8511 00002BED E839E8                   call genCode16
  8512 00002BF0 83C402                   add  sp, 2
  8513                                  
  8514                                  ;-1392         else numbererror();
  8515                                  
  8516 00002BF3 E90300                   jmp .process346
  8517                                  .process345:
  8518 00002BF6 E8BFDF                   call numbererror
  8519                                  
  8520                                  ;-1393         need(',');
  8521                                  
  8522                                  .process346:
  8523 00002BF9 6A2C                     push 44
  8524 00002BFB E89EEB                   call need
  8525 00002BFE 83C402                   add  sp, 2
  8526                                  
  8527                                  ;-1394         Op=getOp1();
  8528                                  
  8529 00002C01 E8D6EC                   call getOp1
  8530 00002C04 A2[2D00]                 mov byte [Op], al
  8531                                  
  8532                                  ;-1395         if (Op == IMM) genCode8 (SymbolInt);
  8533                                  
  8534 00002C07 A0[2D00]                 mov al, [Op]
  8535 00002C0A 3C01                     cmp al, 1
  8536 00002C0C 0F850D00                 jne .process347
  8537 00002C10 FF36[0E00]               push word [SymbolInt]
  8538 00002C14 E87BE7                   call genCode8
  8539 00002C17 83C402                   add  sp, 2
  8540                                  
  8541                                  ;-1396         else numbererror();
  8542                                  
  8543 00002C1A E90300                   jmp .process348
  8544                                  .process347:
  8545 00002C1D E898DF                   call numbererror
  8546                                  
  8547                                  ;-1397         return;
  8548                                  
  8549                                  .process348:
  8550 00002C20 E94401                   jmp .retnprocess
  8551                                  
  8552                                  ;-1398     }
  8553                                  
  8554                                  
  8555                                  ;-1399 
  8556                                  
  8557                                  
  8558                                  ;-1400     if (CodeType==101) {//ORG nn
  8559                                  
  8560                                  .process344:
  8561 00002C23 A0[2F00]                 mov al, [CodeType]
  8562 00002C26 3C65                     cmp al, 101
  8563 00002C28 0F851500                 jne .process349
  8564                                  
  8565                                  ;-1401         if (TokeType != DIGIT) numbererror();
  8566                                  
  8567 00002C2C A0[2C00]                 mov al, [TokeType]
  8568 00002C2F 3C01                     cmp al, 1
  8569 00002C31 0F840300                 je  .process350
  8570 00002C35 E880DF                   call numbererror
  8571                                  
  8572                                  ;-1402         Origin=SymbolInt;
  8573                                  
  8574                                  .process350:
  8575 00002C38 A1[0E00]                 mov ax, [SymbolInt]
  8576 00002C3B A3[2500]                 mov word [Origin], ax
  8577                                  
  8578                                  ;-1403         return;
  8579                                  
  8580 00002C3E E92601                   jmp .retnprocess
  8581                                  
  8582                                  ;-1404     }
  8583                                  
  8584                                  
  8585                                  ;-1405 
  8586                                  
  8587                                  
  8588                                  ;-1406     if (CodeType == 102) {//section, segment
  8589                                  
  8590                                  .process349:
  8591 00002C41 A0[2F00]                 mov al, [CodeType]
  8592 00002C44 3C66                     cmp al, 102
  8593 00002C46 0F850900                 jne .process351
  8594                                  
  8595                                  ;-1407         //getTokeType();//ignore .bss .text .data
  8596                                  
  8597                                  
  8598                                  ;-1408         AbsoluteLab=0;//nasm resets erevy time
  8599                                  
  8600 00002C4A B80000                   mov ax, 0
  8601 00002C4D A3[2700]                 mov word [AbsoluteLab], ax
  8602                                  
  8603                                  ;-1409         return;
  8604                                  
  8605 00002C50 E91401                   jmp .retnprocess
  8606                                  
  8607                                  ;-1410     }
  8608                                  
  8609                                  
  8610                                  ;-1411 
  8611                                  
  8612                                  
  8613                                  ;-1412     if (CodeType == 110) {//absolute
  8614                                  
  8615                                  .process351:
  8616 00002C53 A0[2F00]                 mov al, [CodeType]
  8617 00002C56 3C6E                     cmp al, 110
  8618 00002C58 0F851500                 jne .process352
  8619                                  
  8620                                  ;-1413         if (TokeType != DIGIT) numbererror();
  8621                                  
  8622 00002C5C A0[2C00]                 mov al, [TokeType]
  8623 00002C5F 3C01                     cmp al, 1
  8624 00002C61 0F840300                 je  .process353
  8625 00002C65 E850DF                   call numbererror
  8626                                  
  8627                                  ;-1414         AbsoluteLab=SymbolInt;
  8628                                  
  8629                                  .process353:
  8630 00002C68 A1[0E00]                 mov ax, [SymbolInt]
  8631 00002C6B A3[2700]                 mov word [AbsoluteLab], ax
  8632                                  
  8633                                  ;-1415         return;
  8634                                  
  8635 00002C6E E9F600                   jmp .retnprocess
  8636                                  
  8637                                  ;-1416     }
  8638                                  
  8639                                  
  8640                                  ;-1417     if (CodeType == 111) {//name: PROC
  8641                                  
  8642                                  .process352:
  8643 00002C71 A0[2F00]                 mov al, [CodeType]
  8644 00002C74 3C6F                     cmp al, 111
  8645 00002C76 0F854A00                 jne .process354
  8646                                  
  8647                                  ;-1418         if (isInProc == 0)  {
  8648                                  
  8649 00002C7A A0[0D00]                 mov al, [isInProc]
  8650 00002C7D 3C00                     cmp al, 0
  8651 00002C7F 0F853500                 jne .process355
  8652                                  
  8653                                  ;-1419             prs("\nentering: ");
  8654                                  
  8655 00002C83 68[7C2D]                 push process_1
  8656 00002C86 E8AADA                   call prs
  8657 00002C89 83C402                   add  sp, 2
  8658                                  
  8659                                  ;-1420             prs(ProcName);
  8660                                  
  8661 00002C8C 8D066E75                 lea  ax, [ProcName]
  8662 00002C90 50                       push ax
  8663 00002C91 E89FDA                   call prs
  8664 00002C94 83C402                   add  sp, 2
  8665                                  
  8666                                  ;-1421             isInProc=1;
  8667                                  
  8668 00002C97 B80100                   mov ax, 1
  8669 00002C9A A2[0D00]                 mov byte [isInProc], al
  8670                                  
  8671                                  ;-1422             tmpLabelNamePtr = LabelNamePtr;
  8672                                  
  8673 00002C9D A1[4600]                 mov ax, [LabelNamePtr]
  8674 00002CA0 A3[4800]                 mov word [tmpLabelNamePtr], ax
  8675                                  
  8676                                  ;-1423             tmpLabelMaxIx   = LabelMaxIx;
  8677                                  
  8678 00002CA3 A1[4A00]                 mov ax, [LabelMaxIx]
  8679 00002CA6 A3[4C00]                 mov word [tmpLabelMaxIx], ax
  8680                                  
  8681                                  ;-1424             tmpJmpNamePtr   = JmpNamePtr;
  8682                                  
  8683 00002CA9 A1[5000]                 mov ax, [JmpNamePtr]
  8684 00002CAC A3[5200]                 mov word [tmpJmpNamePtr], ax
  8685                                  
  8686                                  ;-1425             tmpJmpMaxIx     = JmpMaxIx;
  8687                                  
  8688 00002CAF A1[5400]                 mov ax, [JmpMaxIx]
  8689 00002CB2 A3[5600]                 mov word [tmpJmpMaxIx], ax
  8690                                  
  8691                                  ;-1426         } else error1("already in PROC");
  8692                                  
  8693 00002CB5 E90900                   jmp .process356
  8694                                  .process355:
  8695 00002CB8 68[892D]                 push process_2
  8696 00002CBB E88CDD                   call error1
  8697 00002CBE 83C402                   add  sp, 2
  8698                                  
  8699                                  ;-1427         return;
  8700                                  
  8701                                  .process356:
  8702 00002CC1 E9A300                   jmp .retnprocess
  8703                                  
  8704                                  ;-1428     }
  8705                                  
  8706                                  
  8707                                  ;-1429     if (CodeType == 112) {//ENDP 
  8708                                  
  8709                                  .process354:
  8710 00002CC4 A0[2F00]                 mov al, [CodeType]
  8711 00002CC7 3C70                     cmp al, 112
  8712 00002CC9 0F858200                 jne .process357
  8713                                  
  8714                                  ;-1430         if (isInProc == 0) error1("not in PROC");
  8715                                  
  8716 00002CCD A0[0D00]                 mov al, [isInProc]
  8717 00002CD0 3C00                     cmp al, 0
  8718 00002CD2 0F850900                 jne .process358
  8719 00002CD6 68[992D]                 push process_3
  8720 00002CD9 E86EDD                   call error1
  8721 00002CDC 83C402                   add  sp, 2
  8722                                  
  8723                                  ;-1431         prs("\nleaving: ");
  8724                                  
  8725                                  .process358:
  8726 00002CDF 68[A52D]                 push process_4
  8727 00002CE2 E84EDA                   call prs
  8728 00002CE5 83C402                   add  sp, 2
  8729                                  
  8730                                  ;-1432         prs(ProcName);
  8731                                  
  8732 00002CE8 8D066E75                 lea  ax, [ProcName]
  8733 00002CEC 50                       push ax
  8734 00002CED E843DA                   call prs
  8735 00002CF0 83C402                   add  sp, 2
  8736                                  
  8737                                  ;-1433         prs(", loc labels: ");
  8738                                  
  8739 00002CF3 68[B12D]                 push process_5
  8740 00002CF6 E83ADA                   call prs
  8741 00002CF9 83C402                   add  sp, 2
  8742                                  
  8743                                  ;-1434         i = LabelMaxIx - tmpLabelMaxIx;
  8744                                  
  8745 00002CFC A1[4A00]                 mov ax, [LabelMaxIx]
  8746 00002CFF 2B06[4C00]               sub ax, [tmpLabelMaxIx]
  8747 00002D03 8946FC                   mov [bp-4], ax
  8748                                  
  8749                                  ;-1435         printIntU(i);
  8750                                  
  8751 00002D06 FF76FC                   push word [bp-4]
  8752 00002D09 E837DB                   call printIntU
  8753 00002D0C 83C402                   add  sp, 2
  8754                                  
  8755                                  ;-1436         prs(", loc jmp forward: ");
  8756                                  
  8757 00002D0F 68[C02D]                 push process_6
  8758 00002D12 E81EDA                   call prs
  8759 00002D15 83C402                   add  sp, 2
  8760                                  
  8761                                  ;-1437         i = JmpMaxIx - tmpJmpMaxIx;
  8762                                  
  8763 00002D18 A1[5400]                 mov ax, [JmpMaxIx]
  8764 00002D1B 2B06[5600]               sub ax, [tmpJmpMaxIx]
  8765 00002D1F 8946FC                   mov [bp-4], ax
  8766                                  
  8767                                  ;-1438         printIntU(i);        
  8768                                  
  8769 00002D22 FF76FC                   push word [bp-4]
  8770 00002D25 E81BDB                   call printIntU
  8771 00002D28 83C402                   add  sp, 2
  8772                                  
  8773                                  ;-1439         fixJmp();
  8774                                  
  8775 00002D2B E8B4F4                   call fixJmp
  8776                                  
  8777                                  ;-1440         isInProc=0;
  8778                                  
  8779 00002D2E B80000                   mov ax, 0
  8780 00002D31 A2[0D00]                 mov byte [isInProc], al
  8781                                  
  8782                                  ;-1441         LabelNamePtr = tmpLabelNamePtr;//delete local Labels
  8783                                  
  8784 00002D34 A1[4800]                 mov ax, [tmpLabelNamePtr]
  8785 00002D37 A3[4600]                 mov word [LabelNamePtr], ax
  8786                                  
  8787                                  ;-1442         LabelMaxIx   = tmpLabelMaxIx;                       
  8788                                  
  8789 00002D3A A1[4C00]                 mov ax, [tmpLabelMaxIx]
  8790 00002D3D A3[4A00]                 mov word [LabelMaxIx], ax
  8791                                  
  8792                                  ;-1443         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp
  8793                                  
  8794 00002D40 A1[5200]                 mov ax, [tmpJmpNamePtr]
  8795 00002D43 A3[5000]                 mov word [JmpNamePtr], ax
  8796                                  
  8797                                  ;-1444         JmpMaxIx     = tmpJmpMaxIx;
  8798                                  
  8799 00002D46 A1[5600]                 mov ax, [tmpJmpMaxIx]
  8800 00002D49 A3[5400]                 mov word [JmpMaxIx], ax
  8801                                  
  8802                                  ;-1445         return;
  8803                                  
  8804 00002D4C E91800                   jmp .retnprocess
  8805                                  
  8806                                  ;-1446     } 
  8807                                  
  8808                                  
  8809                                  ;-1447     if (CodeType == 200) {//db  
  8810                                  
  8811                                  .process357:
  8812 00002D4F A0[2F00]                 mov al, [CodeType]
  8813 00002D52 3CC8                     cmp al, 200
  8814 00002D54 0F850600                 jne .process359
  8815                                  
  8816                                  ;-1448         genDB();
  8817                                  
  8818 00002D58 E8AFEF                   call genDB
  8819                                  
  8820                                  ;-1449         return;
  8821                                  
  8822 00002D5B E90900                   jmp .retnprocess
  8823                                  
  8824                                  ;-1450     }
  8825                                  
  8826                                  
  8827                                  ;-1451     
  8828                                  
  8829                                  
  8830                                  ;-1452     error1("Command not implemented or syntax error");
  8831                                  
  8832                                  .process359:
  8833 00002D5E 68[D42D]                 push process_7
  8834 00002D61 E8E6DC                   call error1
  8835 00002D64 83C402                   add  sp, 2
  8836                                  
  8837                                  ;-1453 }
  8838                                  
  8839                                  
  8840                                  ;-1454 
  8841                                  
  8842                                  
  8843                                  ;-1455 int parse() {
  8844                                  
  8845 00002D67 C9                       .retnprocess: LEAVE
  8846 00002D68 C3                       ret
  8847 00002D69 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8848 00002D72 7420616C6C6F776564-
  8849 00002D7B 00                 
  8850 00002D7C 5C6E656E746572696E-     process_1 db "\nentering: ",0
  8851 00002D85 673A2000           
  8852 00002D89 616C72656164792069-     process_2 db "already in PROC",0
  8853 00002D92 6E2050524F4300     
  8854 00002D99 6E6F7420696E205052-     process_3 db "not in PROC",0
  8855 00002DA2 4F4300             
  8856 00002DA5 5C6E6C656176696E67-     process_4 db "\nleaving: ",0
  8857 00002DAE 3A2000             
  8858 00002DB1 2C206C6F63206C6162-     process_5 db ", loc labels: ",0
  8859 00002DBA 656C733A2000       
  8860 00002DC0 2C206C6F63206A6D70-     process_6 db ", loc jmp forward: ",0
  8861 00002DC9 20666F72776172643A-
  8862 00002DD2 2000               
  8863 00002DD4 436F6D6D616E64206E-     process_7 db "Command not implemented or syntax error",0
  8864 00002DDD 6F7420696D706C656D-
  8865 00002DE6 656E746564206F7220-
  8866 00002DEF 73796E746178206572-
  8867 00002DF8 726F7200           
  8868                                  ENDP
  8869                                  
  8870                                  parse: PROC
  8871                                  
  8872                                  ;-1456     LabelNamePtr  = &LabelNames;
  8873                                  
  8874 00002DFC B85A77                   mov ax, LabelNames
  8875 00002DFF A3[4600]                 mov word [LabelNamePtr], ax
  8876                                  
  8877                                  ;-1457     JmpNamePtr= &JmpNames;
  8878                                  
  8879 00002E02 B87A93                   mov ax, JmpNames
  8880 00002E05 A3[5000]                 mov word [JmpNamePtr], ax
  8881                                  
  8882                                  ;-1458     LabelMaxIx=0;
  8883                                  
  8884 00002E08 B80000                   mov ax, 0
  8885 00002E0B A3[4A00]                 mov word [LabelMaxIx], ax
  8886                                  
  8887                                  ;-1459     JmpMaxIx=0;
  8888                                  
  8889 00002E0E B80000                   mov ax, 0
  8890 00002E11 A3[5400]                 mov word [JmpMaxIx], ax
  8891                                  
  8892                                  ;-1460     BinLen=0;
  8893                                  
  8894 00002E14 B80000                   mov ax, 0
  8895 00002E17 A3[5800]                 mov word [BinLen], ax
  8896                                  
  8897                                  ;-1461     isInProc=0;
  8898                                  
  8899 00002E1A B80000                   mov ax, 0
  8900 00002E1D A2[0D00]                 mov byte [isInProc], al
  8901                                  
  8902                                  ;-1462 
  8903                                  
  8904                                  
  8905                                  ;-1463     do {//process a new line
  8906                                  
  8907                                  .parse360:
  8908                                  
  8909                                  ;-1464         PCStart=PC;
  8910                                  
  8911 00002E20 A1[2300]                 mov ax, [PC]
  8912 00002E23 A3[2900]                 mov word [PCStart], ax
  8913                                  
  8914                                  ;-1465         OpSize=0;
  8915                                  
  8916 00002E26 B80000                   mov ax, 0
  8917 00002E29 A2[3700]                 mov byte [OpSize], al
  8918                                  
  8919                                  ;-1466         OpPrintIndex=0;
  8920                                  
  8921 00002E2C B80000                   mov ax, 0
  8922 00002E2F A3[4100]                 mov word [OpPrintIndex], ax
  8923                                  
  8924                                  ;-1467         PrintRA=' ';
  8925                                  
  8926 00002E32 B82000                   mov ax, 32
  8927 00002E35 A2[4500]                 mov byte [PrintRA], al
  8928                                  
  8929                                  ;-1468         getLine();
  8930                                  
  8931 00002E38 E8EFDE                   call getLine
  8932                                  
  8933                                  ;-1469         InputPtr = &InputBuf;
  8934                                  
  8935 00002E3B B88D75                   mov ax, InputBuf
  8936 00002E3E A3[1400]                 mov word [InputPtr], ax
  8937                                  
  8938                                  ;-1470         getTokeType();//getCode in SymbolUpper,
  8939                                  
  8940 00002E41 E8A4E8                   call getTokeType
  8941                                  
  8942                                  ;-1471                       //set TokeType,isLabel by getName
  8943                                  
  8944                                  
  8945                                  ;-1472         if (TokeType == ALNUME) {
  8946                                  
  8947 00002E44 A0[2C00]                 mov al, [TokeType]
  8948 00002E47 3C03                     cmp al, 3
  8949 00002E49 0F852C00                 jne .parse361
  8950                                  
  8951                                  ;-1473             if (isLabel) {//set in getName
  8952                                  
  8953 00002E4D A0[2B00]                 mov al, [isLabel]
  8954 00002E50 08C0                     or  al, al
  8955 00002E52 0F842300                 je .parse362
  8956                                  
  8957                                  ;-1474               if (isInProc == 0)  strcpy(ProcName, Symbol);
  8958                                  
  8959 00002E56 A0[0D00]                 mov al, [isInProc]
  8960 00002E59 3C00                     cmp al, 0
  8961 00002E5B 0F851000                 jne .parse363
  8962 00002E5F 8D063075                 lea  ax, [Symbol]
  8963 00002E63 50                       push ax
  8964 00002E64 8D066E75                 lea  ax, [ProcName]
  8965 00002E68 50                       push ax
  8966 00002E69 E8BED3                   call strcpy
  8967 00002E6C 83C404                   add  sp, 4
  8968                                  
  8969                                  ;-1475                 storeLabel();
  8970                                  
  8971                                  .parse363:
  8972 00002E6F E8F1ED                   call storeLabel
  8973                                  
  8974                                  ;-1476                 InputPtr++;//remove :
  8975                                  
  8976 00002E72 FF06[1400]               inc  word[InputPtr]
  8977                                  
  8978                                  ;-1477                 getTokeType();
  8979                                  
  8980 00002E76 E86FE8                   call getTokeType
  8981                                  
  8982                                  ;-1478             }
  8983                                  
  8984                                  
  8985                                  ;-1479         }
  8986                                  
  8987                                  .parse362:
  8988                                  
  8989                                  ;-1480         if (TokeType == ALNUME) {
  8990                                  
  8991                                  .parse361:
  8992 00002E79 A0[2C00]                 mov al, [TokeType]
  8993 00002E7C 3C03                     cmp al, 3
  8994 00002E7E 0F851B00                 jne .parse364
  8995                                  
  8996                                  ;-1481             lookCode();// and OpCodePtr
  8997                                  
  8998 00002E82 E896E4                   call lookCode
  8999                                  
  9000                                  ;-1482             if(CodeType) process();
  9001                                  
  9002 00002E85 A0[2F00]                 mov al, [CodeType]
  9003 00002E88 08C0                     or  al, al
  9004 00002E8A 0F840600                 je .parse365
  9005 00002E8E E86AF5                   call process
  9006                                  
  9007                                  ;-1483             else getVariable();
  9008                                  
  9009 00002E91 E90300                   jmp .parse366
  9010                                  .parse365:
  9011 00002E94 E8F8EE                   call getVariable
  9012                                  
  9013                                  ;-1484             skipRest();
  9014                                  
  9015                                  .parse366:
  9016 00002E97 E841E9                   call skipRest
  9017                                  
  9018                                  ;-1485         }
  9019                                  
  9020                                  
  9021                                  ;-1486         else if (TokeType >ALNUME) error1("Label or instruction expected");
  9022                                  
  9023 00002E9A E92700                   jmp .parse367
  9024                                  .parse364:
  9025 00002E9D A0[2C00]                 mov al, [TokeType]
  9026 00002EA0 3C03                     cmp al, 3
  9027 00002EA2 0F8E0C00                 jle .parse368
  9028 00002EA6 68[D52E]                 push parse_0
  9029 00002EA9 E89EDB                   call error1
  9030 00002EAC 83C402                   add  sp, 2
  9031                                  
  9032                                  ;-1487         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  9033                                  
  9034 00002EAF E91200                   jmp .parse369
  9035                                  .parse368:
  9036 00002EB2 A0[2C00]                 mov al, [TokeType]
  9037 00002EB5 3C01                     cmp al, 1
  9038 00002EB7 0F850900                 jne .parse370
  9039 00002EBB 68[F32E]                 push parse_1
  9040 00002EBE E889DB                   call error1
  9041 00002EC1 83C402                   add  sp, 2
  9042                                  
  9043                                  ;-1488         printLine();
  9044                                  
  9045                                  .parse370:
  9046                                  .parse369:
  9047                                  .parse367:
  9048 00002EC4 E8BED9                   call printLine
  9049                                  
  9050                                  ;-1489     } while (DOS_NoBytes != 0 );
  9051                                  
  9052 00002EC7 A1[2000]                 mov ax, [DOS_NoBytes]
  9053 00002ECA 83F800                   cmp ax, 0
  9054 00002ECD 0F840300                 je  .parse371
  9055 00002ED1 E94CFF                   jmp .parse360
  9056                                  .parse371:
  9057                                  
  9058                                  ;-1490 }
  9059                                  
  9060                                  
  9061                                  ;-1491 
  9062                                  
  9063                                  
  9064                                  ;-1492 int main() {
  9065                                  
  9066 00002ED4 C3                       ret
  9067 00002ED5 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  9068 00002EDE 696E73747275637469-
  9069 00002EE7 6F6E20657870656374-
  9070 00002EF0 656400             
  9071 00002EF3 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  9072 00002EFC 616C6C6F7765642061-
  9073 00002F05 74207374617274206F-
  9074 00002F0E 66206C696E6500     
  9075                                  ENDP
  9076                                  
  9077                                  main: PROC
  9078                                  
  9079                                  ;-1493     getarg();
  9080                                  
  9081 00002F15 E887F0                   call getarg
  9082                                  
  9083                                  ;-1494     parse();
  9084                                  
  9085 00002F18 E8E1FE                   call parse
  9086                                  
  9087                                  ;-1495     fixJmpMain();
  9088                                  
  9089 00002F1B E883F3                   call fixJmpMain
  9090                                  
  9091                                  ;-1496     epilog();
  9092                                  
  9093 00002F1E E80DDA                   call epilog
  9094                                  
  9095                                  ;-1497     end1();
  9096                                  
  9097 00002F21 E8F9DA                   call end1
  9098                                  
  9099                                  ;-1498 }
  9100                                  
  9101 00002F24 C3                       ret
  9102                                  ENDP
  9103                                   
  9104                                  ; missing functions: 
  9105                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  9106 00002F25 E80000                  LastFunctionByt:db 0E8h, 0, 0
  9107 00002F28 58                      pop ax
  9108 00002F29 C3                      ret
  9109                                   
  9110                                  ;   # type sign width  adr used name   list of global variables
  9111                                  
  9112                                  ;    1 arr sign byte     1    2 Version1[9]
  9113                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  9114                                  ;    3 arr sign byte     4   14 Symbol[31]
  9115                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  9116                                  ;    5 arr sign byte     6    3 ProcName[31]
  9117                                  ;    6 var sign byte     7    6 isInProc
  9118                                  ;    7 var unsg word     8   25 SymbolInt
  9119                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  9120                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  9121                                  ;   10 arr sign byte    11    4 InputBuf[255]
  9122                                  ;   11 ptr unsg byte    12   28 InputPtr
  9123                                  ;   12 arr sign byte    13    5 namein[67]
  9124                                  ;   13 arr sign byte    14    6 namelst[67]
  9125                                  ;   14 arr sign byte    15    6 namebin[67]
  9126                                  ;   15 var sign word    16    4 asm_fd
  9127                                  ;   16 var sign word    17    3 lst_fd
  9128                                  ;   17 var sign word    18    3 bin_fd
  9129                                  ;   18 var sign word    19    6 DOS_ERR
  9130                                  ;   19 var sign word    20    5 ErrorCount
  9131                                  ;   20 var sign word    21    4 DOS_NoBytes
  9132                                  ;   21 var sign byte    22    5 DOS_ByteRead
  9133                                  ;   22 var unsg word    24    8 PC
  9134                                  ;   23 var unsg word    25    6 Origin
  9135                                  ;   24 var unsg word    26    6 AbsoluteLab
  9136                                  ;   25 var unsg word    27    2 PCStart
  9137                                  ;   26 var sign byte    28    3 isLabel
  9138                                  ;   27 def unsg byte    29    - DIGIT=1
  9139                                  ;   28 def unsg byte    30    - LETTERE=2
  9140                                  ;   29 def unsg byte    31    - ALNUME=3
  9141                                  ;   30 def unsg byte    32    - NOALNUME=4
  9142                                  ;   31 var sign byte    33   28 TokeType
  9143                                  ;   32 def unsg byte    34    - BYTE=1
  9144                                  ;   33 def unsg byte    35    - WORD=2
  9145                                  ;   34 def unsg byte    36    - DWORD=3
  9146                                  ;   35 def unsg byte    37    - SEGREG=4
  9147                                  ;   36 def unsg byte    38    - IMM=1
  9148                                  ;   37 def unsg byte    39    - REG=2
  9149                                  ;   38 def unsg byte    40    - ADR=3
  9150                                  ;   39 def unsg byte    41    - MEM=4
  9151                                  ;   40 var sign byte    42   29 Op
  9152                                  ;   41 var sign byte    43   32 Op2
  9153                                  ;   42 var sign byte    44   29 CodeType
  9154                                  ;   43 var sign byte    45   23 Code1
  9155                                  ;   44 var sign byte    46    7 Code2
  9156                                  ;   45 var sign byte    47    3 Code3
  9157                                  ;   46 var sign byte    48   19 R2No
  9158                                  ;   47 var sign byte    49   16 R1No
  9159                                  ;   48 var sign byte    50   18 R2Type
  9160                                  ;   49 var sign byte    51   15 R1Type
  9161                                  ;   50 var sign byte    52   14 OpSize
  9162                                  ;   51 var sign byte    53    9 wflag
  9163                                  ;   52 var sign byte    54    3 dflag
  9164                                  ;   53 var sign byte    55    8 sflag
  9165                                  ;   54 var sign byte    56   15 rm
  9166                                  ;   55 var sign byte    57    5 isDirect
  9167                                  ;   56 var sign word    58   67 disp
  9168                                  ;   57 var unsg word    59   14 imme
  9169                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  9170                                  ;   59 arr sign byte    62    2 OpPos[5]
  9171                                  ;   60 var sign word    63    6 OpPrintIndex
  9172                                  ;   61 ptr sign byte    64   19 OpCodePtr
  9173                                  ;   62 var sign byte    65    5 PrintRA
  9174                                  ;   63 def unsg byte    67    - LABELNAMESMAX=5969
  9175                                  ;   64 arr sign byte    68    3 LabelNames[6000]
  9176                                  ;   65 ptr sign byte    69    7 LabelNamePtr
  9177                                  ;   66 ptr sign byte    70    2 tmpLabelNamePtr
  9178                                  ;   67 def unsg byte    72    - LABELADRMAX=600
  9179                                  ;   68 arr unsg word    73    9 LabelAddr[600]
  9180                                  ;   69 var sign word    74   10 LabelMaxIx
  9181                                  ;   70 var sign word    75    3 tmpLabelMaxIx
  9182                                  ;   71 var sign word    76   13 LabelIx
  9183                                  ;   72 def unsg byte    78    - JMPNAMESMAX=3969
  9184                                  ;   73 arr sign byte    79    3 JmpNames[4000]
  9185                                  ;   74 ptr sign byte    80    7 JmpNamePtr
  9186                                  ;   75 ptr sign byte    81    2 tmpJmpNamePtr
  9187                                  ;   76 def unsg byte    83    - JMPMAX=200
  9188                                  ;   77 arr unsg word    84    2 JmpAddr[200]
  9189                                  ;   78 var sign word    85   10 JmpMaxIx
  9190                                  ;   79 var sign word    86    3 tmpJmpMaxIx
  9191                                  ;   80 def unsg byte    88    - FILEBINMAX=17000
  9192                                  ;   81 arr sign byte    89    8 FileBin[17000]
  9193                                  ;   82 var unsg word    90    6 BinLen
  9194                                  ;   83 ptr sign byte    92    1 arglen
  9195                                  ;   84 ptr sign byte    93    4 argv
  9196                                  ;   85 var sign byte   451    1 I_START
  9197                                  ;   86 arr sign byte   454 NULL I_PUSHA[8125]
  9198                                  ;   87 arr sign byte   455 NULL I_NOP[24260]
  9199                                  ;   88 arr sign byte   456 NULL I_CWDE[9734]
  9200                                  ;   89 arr sign byte   457 NULL I_CDQ[1931]
  9201                                  ;   90 arr sign byte   458 NULL I_PUSHF[35622]
  9202                                  ;   91 arr sign byte   459 NULL I_SAHF[599]
  9203                                  ;   92 arr sign byte   460 NULL I_MOVSB[53495]
  9204                                  ;   93 arr sign byte   461 NULL I_CMPSB[54007]
  9205                                  ;   94 arr sign byte   462 NULL I_STOSB[37]
  9206                                  ;   95 arr sign byte   463 NULL I_LODSB[33600]
  9207                                  ;   96 arr sign byte   464 NULL I_SCASB[8418]
  9208                                  ;   97 arr sign byte   465 NULL I_LEAVE[53259]
  9209                                  ;   98 arr sign byte   466 NULL I_INTO[12917]
  9210                                  ;   99 arr sign byte   467 NULL I_XLAT[35622]
  9211                                  ;  100 arr sign byte   468 NULL I_REPNE[2119]
  9212                                  ;  101 arr sign byte   469 NULL I_REPE[18057]
  9213                                  ;  102 arr sign byte   470 NULL I_HLT[9982]
  9214                                  ;  103 arr sign byte   471 NULL I_STC[18315]
  9215                                  ;  104 arr sign byte   472 NULL I_STI[9734]
  9216                                  ;  105 arr sign byte   473 NULL I_STD[32643]
  9217                                  ;  106 arr sign byte   475 NULL I_INC[10]
  9218                                  ;  107 arr sign byte   476 NULL I_DEC[1397]
  9219                                  ;  108 arr sign byte   477 NULL I_NOT[18119]
  9220                                  ;  109 arr sign byte   478 NULL I_NEG[65534]
  9221                                  ;  110 arr sign byte   479 NULL I_MUL[33791]
  9222                                  ;  111 arr sign byte   480 NULL I_IMUL[65150]
  9223                                  ;  112 arr sign byte   481 NULL I_DIV[30207]
  9224                                  ;  113 arr sign byte   482 NULL I_IDIV[15642]
  9225                                  ;  114 arr sign byte   484 NULL I_LES[65535]
  9226                                  ;  115 arr sign byte   485 NULL I_LDS[5493]
  9227                                  ;  116 arr sign byte   486 NULL I_LEA[33574]
  9228                                  ;  117 arr sign byte   487 NULL I_LSS[1151]
  9229                                  ;  118 arr sign byte   488 NULL I_LFS[29696]
  9230                                  ;  119 arr sign byte   489 NULL I_LGS[35593]
  9231                                  ;  120 arr sign byte   491 NULL I_ADD[2630]
  9232                                  ;  121 arr sign byte   492 NULL I_OR[14630]
  9233                                  ;  122 arr sign byte   493 NULL I_ADC[1095]
  9234                                  ;  123 arr sign byte   494 NULL I_SBB[26997]
  9235                                  ;  124 arr sign byte   495 NULL I_AND[49203]
  9236                                  ;  125 arr sign byte   496 NULL I_SUB[52169]
  9237                                  ;  126 arr sign byte   497 NULL I_XOR[33680]
  9238                                  ;  127 arr sign byte   498 NULL I_CMP[65150]
  9239                                  ;  128 arr sign byte   499 NULL I_TEST[29729]
  9240                                  ;  129 arr sign byte   501 NULL I_MOV[33618]
  9241                                  ;  130 arr sign byte   502 NULL I_MOVSX[65150]
  9242                                  ;  131 arr sign byte   503 NULL I_MOVZX[29731]
  9243                                  ;  132 arr sign byte   505 NULL I_JO[33612]
  9244                                  ;  133 arr sign byte   506 NULL I_JNO[65150]
  9245                                  ;  134 arr sign byte   507 NULL I_JB[29732]
  9246                                  ;  135 arr sign byte   508 NULL I_JNB[33606]
  9247                                  ;  136 arr sign byte   509 NULL I_JAE[65150]
  9248                                  ;  137 arr sign byte   510 NULL I_JE[29734]
  9249                                  ;  138 arr sign byte   511 NULL I_JNE[33600]
  9250                                  ;  139 arr sign byte   512 NULL I_JBE[65150]
  9251                                  ;  140 arr sign byte   513 NULL I_JA[29730]
  9252                                  ;  141 arr sign byte   514 NULL I_JS[33594]
  9253                                  ;  142 arr sign byte   515 NULL I_JNS[65150]
  9254                                  ;  143 arr sign byte   516 NULL I_JP[29737]
  9255                                  ;  144 arr sign byte   517 NULL I_JNP[33588]
  9256                                  ;  145 arr sign byte   518 NULL I_JL[65150]
  9257                                  ;  146 arr sign byte   519 NULL I_JNL[29736]
  9258                                  ;  147 arr sign byte   520 NULL I_JLE[33582]
  9259                                  ;  148 arr sign byte   521 NULL I_JG[65150]
  9260                                  ;  149 arr sign byte   523 NULL I_JMP[29733]
  9261                                  ;  150 arr sign byte   524 NULL I_CALL[15656]
  9262                                  ;  151 arr sign byte   526 NULL I_RET[33]
  9263                                  ;  152 arr sign byte   527 NULL I_RETF[9076]
  9264                                  ;  153 arr sign byte   529 NULL I_PUSH[9021]
  9265                                  ;  154 arr sign byte   530 NULL I_POP[29696]
  9266                                  ;  155 arr sign byte   532 NULL I_ROL[15646]
  9267                                  ;  156 arr sign byte   533 NULL I_RCL[36]
  9268                                  ;  157 arr sign byte   534 NULL I_SHL[6516]
  9269                                  ;  158 arr sign byte   535 NULL I_SHR[9789]
  9270                                  ;  159 arr sign byte   537 NULL I_INT[29696]
  9271                                  ;  160 arr sign byte   539 NULL I_IN[15636]
  9272                                  ;  161 arr sign byte   540 NULL I_INSB[34]
  9273                                  ;  162 arr sign byte   541 NULL I_INSW[3956]
  9274                                  ;  163 arr sign byte   542 NULL I_INSD[10557]
  9275                                  ;  164 arr sign byte   543 NULL I_OUT[29696]
  9276                                  ;  165 arr sign byte   544 NULL I_OUTSB[15626]
  9277                                  ;  166 arr sign byte   545 NULL I_OUTSW[40]
  9278                                  ;  167 arr sign byte   546 NULL I_OUTSD[1396]
  9279                                  ;  168 arr sign byte   548 NULL I_XCHG[9533]
  9280                                  ;  169 arr sign byte   550 NULL I_LOOPNZ[29952]
  9281                                  ;  170 arr sign byte   551 NULL I_LOOPNE[33542]
  9282                                  ;  171 arr sign byte   552 NULL I_LOOPZ[2686]
  9283                                  ;  172 arr sign byte   553 NULL I_LOOPE[60176]
  9284                                  ;  173 arr sign byte   554 NULL I_LOOP[33540]
  9285                                  ;  174 arr sign byte   555 NULL I_JCXZ[2686]
  9286                                  ;  175 arr sign byte   556 NULL I_JECXZ[29984]
  9287                                  ;  176 arr sign byte   558 NULL I_ENTER[47255]
  9288                                  ;  177 arr sign byte   560 NULL I_ORG[1]
  9289                                  ;  178 arr sign byte   562 NULL I_SECTION[52169]
  9290                                  ;  179 arr sign byte   563 NULL I_SEGMENT[21904]
  9291                                  ;  180 arr sign byte   564 NULL I_ABSOLUTE[60555]
  9292                                  ;  181 arr sign byte   565 NULL I_PROC[5816]
  9293                                  ;  182 arr sign byte   566 NULL I_ENDP[39424]
  9294                                  ;  183 arr sign byte   567 NULL I_DB[674]
  9295                                  ;  184 arr sign byte   568 NULL I_DW[8125]
  9296                                  ;  185 arr sign byte   569 NULL I_DD[51030]
  9297                                  ;  186 arr sign byte   570 NULL I_RESB[65094]
  9298                                  ;  187 arr sign byte   571 NULL I_RESW[0]
  9299                                  ;  188 arr sign byte   572 NULL I_RESD[1678]
  9300                                  ;  189 var sign byte   573 NULL I_END
  9301                                  
  9302                                  
  9303                                  ;   # Calls Line Width  Name   list of functions
  9304                                  
  9305                                  ;    0    4   97   writetty
  9306                                  ;    1    1   98   putch
  9307                                  ;    2    8   99   cputs
  9308                                  ;    3    6  101   DosInt
  9309                                  ;    4    1  106   openR
  9310                                  ;    5    2  107   creatR
  9311                                  ;    6    3  108   fcloseR
  9312                                  ;    7    5  109   exitR
  9313                                  ;    8    2  110   readRL
  9314                                  ;    9    2  112   fputcR
  9315                                  ;   10    2  115   letterE
  9316                                  ;   11    3  125   digit
  9317                                  ;   12    1  130   alnumE
  9318                                  ;   13    4  135   strlen
  9319                                  ;   14   10  140   strcpy
  9320                                  ;   15   35  146   eqstr
  9321                                  ;   16    3  155   strcat1
  9322                                  ;   17    2  159   toupper
  9323                                  ;   18    1  166   testReg
  9324                                  ;   19    7  209   prc
  9325                                  ;   20    1  219   prscomment
  9326                                  ;   21   38  227   prs
  9327                                  ;   22    2  249   printhex4
  9328                                  ;   23    3  254   printhex8a
  9329                                  ;   24    3  259   printhex16
  9330                                  ;   25    7  264   printIntU
  9331                                  ;   26    1  274   printLine
  9332                                  ;   27    2  297   epilog
  9333                                  ;   28    2  345   end1
  9334                                  ;   29   27  353   error1
  9335                                  ;   30   13  360   errorexit
  9336                                  ;   31    5  365   notfounderror
  9337                                  ;   32 NULL  371   allowederror
  9338                                  ;   33    3  372   addrerror
  9339                                  ;   34    1  373   immeerror
  9340                                  ;   35    2  374   implerror
  9341                                  ;   36    4  375   indexerror
  9342                                  ;   37    2  376   invaloperror
  9343                                  ;   38    6  377   numbererror
  9344                                  ;   39    1  378   regmemerror
  9345                                  ;   40    3  379   reg16error
  9346                                  ;   41    1  380   segregerror
  9347                                  ;   42    5  381   syntaxerror
  9348                                  ;   43 NULL  383   addrexit
  9349                                  ;   44    3  384   dataexit
  9350                                  ;   45 NULL  385   internexit
  9351                                  ;   46    1  387   ifEOL
  9352                                  ;   47    1  396   getLine
  9353                                  ;   48    4  412   skipBlank
  9354                                  ;   49    1  418   getDigit
  9355                                  ;   50    1  430   getName
  9356                                  ;   51    2  575   lookCode
  9357                                  ;   52   37  591   genCode8
  9358                                  ;   53    1  602   gen66h
  9359                                  ;   54    8  604   genCode2
  9360                                  ;   55   13  608   genCodeW
  9361                                  ;   56   19  612   genCode16
  9362                                  ;   57    1  616   genCode32
  9363                                  ;   58   13  620   writeEA
  9364                                  ;   59    4  662   genImmediate
  9365                                  ;   60    2  669   setwflag
  9366                                  ;   61    2  680   setsflag
  9367                                  ;   62    2  690   checkConstSize
  9368                                  ;   63    2  697   ChangeDirection
  9369                                  ;   64   17  705   getTokeType
  9370                                  ;   65   11  716   isToken
  9371                                  ;   66    2  726   need
  9372                                  ;   67    1  735   skipRest
  9373                                  ;   68    2  741   checkOpL
  9374                                  ;   69    6  750   searchLabel
  9375                                  ;   70    4  763   getOp1
  9376                                  ;   71    1  778   getIndReg1
  9377                                  ;   72    1  786   getIndReg2
  9378                                  ;   73    1  795   getMEM
  9379                                  ;   74    2  822   getOpR
  9380                                  ;   75    3  835   getOpL
  9381                                  ;   76    1  842   get2Ops
  9382                                  ;   77    4  847   check2Ops
  9383                                  ;   78    3  857   storeJmp
  9384                                  ;   79    2  868   storeLabel
  9385                                  ;   80    1  881   genDB
  9386                                  ;   81    1  902   getVariable
  9387                                  ;   82    1  955   getCodeSize
  9388                                  ;   83    1  965   getarg
  9389                                  ;   84    1  999   fixJmp
  9390                                  ;   85    1 1032   fixJmpMain
  9391                                  ;   86    1 1058   getCodes
  9392                                  ;   87    1 1064   process
  9393                                  ;   88    1 1455   parse
  9394                                  ;   89 NULL 1492   main
  9395                                  ;   90 NULL 1498   LastFunctionByt
  9396                                  
  9397                                  ;    #  addr name   list of CALLs
  9398                                  
  9399                                  ;    0     0 writetty
  9400                                  ;    1     9 writetty
  9401                                  ;    2    18 putch
  9402                                  ;    3    24 DosInt
  9403                                  ;    4    31 DosInt
  9404                                  ;    5    38 DosInt
  9405                                  ;    6    45 DosInt
  9406                                  ;    7    52 DosInt
  9407                                  ;    8    59 DosInt
  9408                                  ;    9    66 digit
  9409                                  ;   10    72 letterE
  9410                                  ;   11    80 strcpy
  9411                                  ;   12    87 strlen
  9412                                  ;   13    94 strlen
  9413                                  ;   14   101 eqstr
  9414                                  ;   15   107 eqstr
  9415                                  ;   16   113 eqstr
  9416                                  ;   17   119 eqstr
  9417                                  ;   18   125 eqstr
  9418                                  ;   19   131 eqstr
  9419                                  ;   20   137 eqstr
  9420                                  ;   21   143 eqstr
  9421                                  ;   22   149 eqstr
  9422                                  ;   23   155 eqstr
  9423                                  ;   24   161 eqstr
  9424                                  ;   25   167 eqstr
  9425                                  ;   26   173 eqstr
  9426                                  ;   27   179 eqstr
  9427                                  ;   28   185 eqstr
  9428                                  ;   29   191 eqstr
  9429                                  ;   30   197 eqstr
  9430                                  ;   31   203 eqstr
  9431                                  ;   32   209 eqstr
  9432                                  ;   33   215 eqstr
  9433                                  ;   34   221 eqstr
  9434                                  ;   35   227 eqstr
  9435                                  ;   36   233 eqstr
  9436                                  ;   37   239 eqstr
  9437                                  ;   38   245 eqstr
  9438                                  ;   39   251 eqstr
  9439                                  ;   40   257 eqstr
  9440                                  ;   41   263 eqstr
  9441                                  ;   42   269 eqstr
  9442                                  ;   43   275 eqstr
  9443                                  ;   44   281 writetty
  9444                                  ;   45   290 writetty
  9445                                  ;   46   299 fputcR
  9446                                  ;   47   306 prc
  9447                                  ;   48   310 prc
  9448                                  ;   49   314 prc
  9449                                  ;   50   318 printhex4
  9450                                  ;   51   328 printhex4
  9451                                  ;   52   338 printhex8a
  9452                                  ;   53   349 printhex8a
  9453                                  ;   54   360 printIntU
  9454                                  ;   55   370 prc
  9455                                  ;   56   374 prs
  9456                                  ;   57   378 printhex16
  9457                                  ;   58   389 prs
  9458                                  ;   59   393 prc
  9459                                  ;   60   397 printhex8a
  9460                                  ;   61   408 prs
  9461                                  ;   62   412 prc
  9462                                  ;   63   416 prscomment
  9463                                  ;   64   427 prs
  9464                                  ;   65   431 printIntU
  9465                                  ;   66   441 prs
  9466                                  ;   67   445 prs
  9467                                  ;   68   449 prs
  9468                                  ;   69   453 prs
  9469                                  ;   70   457 prs
  9470                                  ;   71   461 prs
  9471                                  ;   72   465 printIntU
  9472                                  ;   73   475 prs
  9473                                  ;   74   479 prs
  9474                                  ;   75   483 printIntU
  9475                                  ;   76   493 fputcR
  9476                                  ;   77   500 fcloseR
  9477                                  ;   78   508 fcloseR
  9478                                  ;   79   516 fcloseR
  9479                                  ;   80   524 exitR
  9480                                  ;   81   530 prs
  9481                                  ;   82   534 prs
  9482                                  ;   83   538 prs
  9483                                  ;   84   542 prs
  9484                                  ;   85   546 error1
  9485                                  ;   86   553 epilog
  9486                                  ;   87   560 end1
  9487                                  ;   88   565 prs
  9488                                  ;   89   569 prs
  9489                                  ;   90   573 prs
  9490                                  ;   91   577 error1
  9491                                  ;   92   584 error1
  9492                                  ;   93   591 error1
  9493                                  ;   94   598 error1
  9494                                  ;   95   605 error1
  9495                                  ;   96   612 error1
  9496                                  ;   97   619 error1
  9497                                  ;   98   626 error1
  9498                                  ;   99   633 error1
  9499                                  ;  100   640 error1
  9500                                  ;  101   647 error1
  9501                                  ;  102   654 errorexit
  9502                                  ;  103   664 errorexit
  9503                                  ;  104   674 errorexit
  9504                                  ;  105   684 readRL
  9505                                  ;  106   691 errorexit
  9506                                  ;  107   701 readRL
  9507                                  ;  108   708 errorexit
  9508                                  ;  109   718 errorexit
  9509                                  ;  110   728 ifEOL
  9510                                  ;  111   734 digit
  9511                                  ;  112   740 alnumE
  9512                                  ;  113   747 errorexit
  9513                                  ;  114   757 strcpy
  9514                                  ;  115   764 toupper
  9515                                  ;  116   772 eqstr
  9516                                  ;  117   778 errorexit
  9517                                  ;  118   788 genCode8
  9518                                  ;  119   797 genCode8
  9519                                  ;  120   806 genCode8
  9520                                  ;  121   815 genCode8
  9521                                  ;  122   824 genCode8
  9522                                  ;  123   833 genCode16
  9523                                  ;  124   843 genCode16
  9524                                  ;  125   853 genCode8
  9525                                  ;  126   862 genCode8
  9526                                  ;  127   871 genCode16
  9527                                  ;  128   881 genCode32
  9528                                  ;  129   891 genCode16
  9529                                  ;  130   901 genCode8
  9530                                  ;  131   910 gen66h
  9531                                  ;  132   917 error1
  9532                                  ;  133   924 skipBlank
  9533                                  ;  134   934 digit
  9534                                  ;  135   940 getDigit
  9535                                  ;  136   949 letterE
  9536                                  ;  137   957 getName
  9537                                  ;  138   965 skipBlank
  9538                                  ;  139   975 isToken
  9539                                  ;  140   983 getTokeType
  9540                                  ;  141   995 error1
  9541                                  ;  142  1002 prs
  9542                                  ;  143  1006 prc
  9543                                  ;  144  1010 getTokeType
  9544                                  ;  145  1022 error1
  9545                                  ;  146  1029 implerror
  9546                                  ;  147  1039 segregerror
  9547                                  ;  148  1051 setwflag
  9548                                  ;  149  1060 error1
  9549                                  ;  150  1067 error1
  9550                                  ;  151  1074 eqstr
  9551                                  ;  152  1080 strlen
  9552                                  ;  153  1087 testReg
  9553                                  ;  154  1095 searchLabel
  9554                                  ;  155  1107 indexerror
  9555                                  ;  156  1118 indexerror
  9556                                  ;  157  1129 indexerror
  9557                                  ;  158  1140 indexerror
  9558                                  ;  159  1151 getTokeType
  9559                                  ;  160  1163 getOp1
  9560                                  ;  161  1170 syntaxerror
  9561                                  ;  162  1182 getIndReg2
  9562                                  ;  163  1193 getIndReg1
  9563                                  ;  164  1204 notfounderror
  9564                                  ;  165  1218 isToken
  9565                                  ;  166  1226 getTokeType
  9566                                  ;  167  1238 numbererror
  9567                                  ;  168  1250 isToken
  9568                                  ;  169  1258 isToken
  9569                                  ;  170  1266 errorexit
  9570                                  ;  171  1276 getOp1
  9571                                  ;  172  1283 isToken
  9572                                  ;  173  1291 getMEM
  9573                                  ;  174  1298 invaloperror
  9574                                  ;  175  1311 error1
  9575                                  ;  176  1318 getOpR
  9576                                  ;  177  1325 getOpL
  9577                                  ;  178  1332 need
  9578                                  ;  179  1337 getOpR
  9579                                  ;  180  1344 get2Ops
  9580                                  ;  181  1352 addrerror
  9581                                  ;  182  1362 invaloperror
  9582                                  ;  183  1375 immeerror
  9583                                  ;  184  1385 addrerror
  9584                                  ;  185  1395 setwflag
  9585                                  ;  186  1404 errorexit
  9586                                  ;  187  1414 strcpy
  9587                                  ;  188  1421 errorexit
  9588                                  ;  189  1431 searchLabel
  9589                                  ;  190  1443 error1
  9590                                  ;  191  1450 errorexit
  9591                                  ;  192  1460 strcpy
  9592                                  ;  193  1467 errorexit
  9593                                  ;  194  1477 getTokeType
  9594                                  ;  195  1489 genCode8
  9595                                  ;  196  1498 skipBlank
  9596                                  ;  197  1508 isToken
  9597                                  ;  198  1516 genCode8
  9598                                  ;  199  1525 isToken
  9599                                  ;  200  1533 storeLabel
  9600                                  ;  201  1544 getTokeType
  9601                                  ;  202  1556 lookCode
  9602                                  ;  203  1565 dataexit
  9603                                  ;  204  1574 dataexit
  9604                                  ;  205  1583 getTokeType
  9605                                  ;  206  1595 genCode8
  9606                                  ;  207  1604 skipBlank
  9607                                  ;  208  1614 isToken
  9608                                  ;  209  1622 genCode8
  9609                                  ;  210  1631 isToken
  9610                                  ;  211  1639 getTokeType
  9611                                  ;  212  1651 genCode16
  9612                                  ;  213  1661 isToken
  9613                                  ;  214  1669 getTokeType
  9614                                  ;  215  1681 genCode16
  9615                                  ;  216  1691 genCode16
  9616                                  ;  217  1701 isToken
  9617                                  ;  218  1709 getTokeType
  9618                                  ;  219  1721 syntaxerror
  9619                                  ;  220  1733 error1
  9620                                  ;  221  1740 numbererror
  9621                                  ;  222  1752 dataexit
  9622                                  ;  223  1761 eqstr
  9623                                  ;  224  1767 getTokeType
  9624                                  ;  225  1779 eqstr
  9625                                  ;  226  1785 getTokeType
  9626                                  ;  227  1797 eqstr
  9627                                  ;  228  1803 getTokeType
  9628                                  ;  229  1815 cputs
  9629                                  ;  230  1821 cputs
  9630                                  ;  231  1827 exitR
  9631                                  ;  232  1833 toupper
  9632                                  ;  233  1841 strcpy
  9633                                  ;  234  1848 strcat1
  9634                                  ;  235  1856 strcpy
  9635                                  ;  236  1863 strcat1
  9636                                  ;  237  1871 strcpy
  9637                                  ;  238  1878 strcat1
  9638                                  ;  239  1886 openR
  9639                                  ;  240  1892 cputs
  9640                                  ;  241  1898 cputs
  9641                                  ;  242  1904 exitR
  9642                                  ;  243  1910 creatR
  9643                                  ;  244  1917 cputs
  9644                                  ;  245  1923 cputs
  9645                                  ;  246  1929 exitR
  9646                                  ;  247  1935 creatR
  9647                                  ;  248  1942 cputs
  9648                                  ;  249  1948 cputs
  9649                                  ;  250  1954 exitR
  9650                                  ;  251  1960 prs
  9651                                  ;  252  1964 prs
  9652                                  ;  253  1968 prs
  9653                                  ;  254  1972 prs
  9654                                  ;  255  1976 prs
  9655                                  ;  256  1980 prs
  9656                                  ;  257  1984 prs
  9657                                  ;  258  1988 prs
  9658                                  ;  259  1992 prs
  9659                                  ;  260  1996 strcpy
  9660                                  ;  261  2003 strlen
  9661                                  ;  262  2010 searchLabel
  9662                                  ;  263  2022 notfounderror
  9663                                  ;  264  2036 prs
  9664                                  ;  265  2040 printIntU
  9665                                  ;  266  2050 error1
  9666                                  ;  267  2057 strcpy
  9667                                  ;  268  2064 searchLabel
  9668                                  ;  269  2076 notfounderror
  9669                                  ;  270  2090 prs
  9670                                  ;  271  2094 printhex16
  9671                                  ;  272  2105 prs
  9672                                  ;  273  2109 printhex16
  9673                                  ;  274  2120 getTokeType
  9674                                  ;  275  2132 getCodeSize
  9675                                  ;  276  2144 getCodes
  9676                                  ;  277  2153 genCode8
  9677                                  ;  278  2162 getOpL
  9678                                  ;  279  2169 checkOpL
  9679                                  ;  280  2178 genCode2
  9680                                  ;  281  2187 getTokeType
  9681                                  ;  282  2199 implerror
  9682                                  ;  283  2209 genCodeW
  9683                                  ;  284  2218 writeEA
  9684                                  ;  285  2226 check2Ops
  9685                                  ;  286  2236 reg16error
  9686                                  ;  287  2247 addrerror
  9687                                  ;  288  2257 genCode8
  9688                                  ;  289  2266 genCode8
  9689                                  ;  290  2275 writeEA
  9690                                  ;  291  2283 check2Ops
  9691                                  ;  292  2293 notfounderror
  9692                                  ;  293  2307 setsflag
  9693                                  ;  294  2316 genCodeW
  9694                                  ;  295  2325 genImmediate
  9695                                  ;  296  2338 genCodeW
  9696                                  ;  297  2347 writeEA
  9697                                  ;  298  2355 genCode8
  9698                                  ;  299  2364 genImmediate
  9699                                  ;  300  2377 genCodeW
  9700                                  ;  301  2386 writeEA
  9701                                  ;  302  2394 genCodeW
  9702                                  ;  303  2403 writeEA
  9703                                  ;  304  2411 syntaxerror
  9704                                  ;  305  2423 check2Ops
  9705                                  ;  306  2433 notfounderror
  9706                                  ;  307  2447 genCode2
  9707                                  ;  308  2456 genImmediate
  9708                                  ;  309  2469 genCodeW
  9709                                  ;  310  2478 writeEA
  9710                                  ;  311  2486 genImmediate
  9711                                  ;  312  2499 regmemerror
  9712                                  ;  313  2511 ChangeDirection
  9713                                  ;  314  2527 reg16error
  9714                                  ;  315  2538 genCode2
  9715                                  ;  316  2547 writeEA
  9716                                  ;  317  2555 genCodeW
  9717                                  ;  318  2564 genCode16
  9718                                  ;  319  2574 genCodeW
  9719                                  ;  320  2583 genCode16
  9720                                  ;  321  2593 genCodeW
  9721                                  ;  322  2602 writeEA
  9722                                  ;  323  2610 ChangeDirection
  9723                                  ;  324  2626 genCodeW
  9724                                  ;  325  2635 writeEA
  9725                                  ;  326  2643 syntaxerror
  9726                                  ;  327  2655 searchLabel
  9727                                  ;  328  2667 checkConstSize
  9728                                  ;  329  2682 genCode2
  9729                                  ;  330  2691 genCode8
  9730                                  ;  331  2700 genCode8
  9731                                  ;  332  2709 genCode2
  9732                                  ;  333  2718 genCode16
  9733                                  ;  334  2728 genCode8
  9734                                  ;  335  2737 genCode2
  9735                                  ;  336  2746 storeJmp
  9736                                  ;  337  2755 genCode16
  9737                                  ;  338  2765 searchLabel
  9738                                  ;  339  2777 checkConstSize
  9739                                  ;  340  2792 genCode8
  9740                                  ;  341  2801 genCode8
  9741                                  ;  342  2810 genCode8
  9742                                  ;  343  2819 genCode16
  9743                                  ;  344  2829 genCode8
  9744                                  ;  345  2838 genCode16
  9745                                  ;  346  2848 genCode8
  9746                                  ;  347  2857 storeJmp
  9747                                  ;  348  2866 genCode16
  9748                                  ;  349  2876 genCode8
  9749                                  ;  350  2885 genCode16
  9750                                  ;  351  2895 genCode8
  9751                                  ;  352  2904 getOpL
  9752                                  ;  353  2911 setsflag
  9753                                  ;  354  2920 genCode2
  9754                                  ;  355  2929 genCode8
  9755                                  ;  356  2938 genCode16
  9756                                  ;  357  2948 genCode8
  9757                                  ;  358  2957 genCode16
  9758                                  ;  359  2967 genCode8
  9759                                  ;  360  2976 storeJmp
  9760                                  ;  361  2985 genCode16
  9761                                  ;  362  2995 error1
  9762                                  ;  363  3002 genCode8
  9763                                  ;  364  3011 genCode8
  9764                                  ;  365  3020 checkOpL
  9765                                  ;  366  3029 reg16error
  9766                                  ;  367  3040 genCode2
  9767                                  ;  368  3049 genCode8
  9768                                  ;  369  3058 writeEA
  9769                                  ;  370  3066 syntaxerror
  9770                                  ;  371  3078 check2Ops
  9771                                  ;  372  3088 genCodeW
  9772                                  ;  373  3097 writeEA
  9773                                  ;  374  3105 genCodeW
  9774                                  ;  375  3114 writeEA
  9775                                  ;  376  3122 genCode8
  9776                                  ;  377  3131 genCodeW
  9777                                  ;  378  3140 writeEA
  9778                                  ;  379  3148 genCode8
  9779                                  ;  380  3157 genCode8
  9780                                  ;  381  3166 genCode8
  9781                                  ;  382  3175 getOp1
  9782                                  ;  383  3182 genCode16
  9783                                  ;  384  3192 numbererror
  9784                                  ;  385  3204 need
  9785                                  ;  386  3209 getOp1
  9786                                  ;  387  3216 genCode8
  9787                                  ;  388  3225 numbererror
  9788                                  ;  389  3237 numbererror
  9789                                  ;  390  3249 numbererror
  9790                                  ;  391  3261 prs
  9791                                  ;  392  3265 prs
  9792                                  ;  393  3269 error1
  9793                                  ;  394  3276 error1
  9794                                  ;  395  3283 prs
  9795                                  ;  396  3287 prs
  9796                                  ;  397  3291 prs
  9797                                  ;  398  3295 printIntU
  9798                                  ;  399  3305 prs
  9799                                  ;  400  3309 printIntU
  9800                                  ;  401  3319 fixJmp
  9801                                  ;  402  3326 genDB
  9802                                  ;  403  3332 error1
  9803                                  ;  404  3339 getLine
  9804                                  ;  405  3347 getTokeType
  9805                                  ;  406  3359 strcpy
  9806                                  ;  407  3366 storeLabel
  9807                                  ;  408  3377 getTokeType
  9808                                  ;  409  3389 lookCode
  9809                                  ;  410  3398 process
  9810                                  ;  411  3406 getVariable
  9811                                  ;  412  3418 skipRest
  9812                                  ;  413  3427 error1
  9813                                  ;  414  3434 error1
  9814                                  ;  415  3441 printLine
  9815                                  ;  416  3451 getarg
  9816                                  ;  417  3458 parse
  9817                                  ;  418  3464 fixJmpMain
  9818                                  ;  419  3475 epilog
  9819                                  ;  420  3482 end1
  9820                                  ;Input: AS.C, List: AS.S,  Lines: 1499
  9821                                  ;Glob. variables:  189 max.:  200
  9822                                  ;Functions      :   91 max.:  300
  9823                                  ;Calls          :  421 max.: 2000, NameField: 3487 max.:    65535
  9824                                  ;Code until     :21667 max.: 30000, free: 8333
  9825                                  ;Data (HeapEnd) :59154, resting stacksize:  6381
  9826                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
