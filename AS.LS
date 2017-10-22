     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9512F                  jmp main
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
   536                                  ;-110 int readRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x3F00; DosInt();}
   537 000000F2 C9                       LEAVE
   538 000000F3 C3                       ret
   539                                  ENDP
   540                                  
   541                                  readRL: PROC
   542                                  ;Function : readRL, Number of local variables: 3
   543                                  ;   # type sign width addr used name   list of local variables
   544                                  ;  200 ptr sign byte   110 NULL s = bp+4
   545                                  ;  201 var sign word   110 NULL fd = bp+6
   546                                  ;  202 var sign word   110 NULL len = bp+8;
   547 000000F4 C8000000                 ENTER  0,0
   548 000000F8 8B5604                   mov  dx, [bp+4]
   549 000000FB 8B4E08                   mov  cx, [bp+8]
   550 000000FE 8B5E06                   mov  bx, [bp+6]
   551 00000101 B8003F                   mov  ax, 16128
   552 00000104 E8A6FF                   call DosInt
   553                                  
   554                                  ;-111 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
   555 00000107 C9                       LEAVE
   556 00000108 C3                       ret
   557                                  ENDP
   558                                  
   559                                  fputcR: PROC
   560                                  ;Function : fputcR, Number of local variables: 2
   561                                  ;   # type sign width addr used name   list of local variables
   562                                  ;  200 ptr sign byte   111 NULL n = bp+4
   563                                  ;  201 var sign word   111 NULL fd = bp+6;
   564 00000109 C8000000                 ENTER  0,0
   565 0000010D 8D5604                  lea dx, [bp+4]
   566                                  
   567                                  ;-112   cx=1; bx=fd; ax=0x4000; DosInt(); }
   568                                  
   569 00000110 B90100                   mov  cx, 1
   570 00000113 8B5E06                   mov  bx, [bp+6]
   571 00000116 B80040                   mov  ax, 16384
   572 00000119 E891FF                   call DosInt
   573                                  
   574                                  ;-113 
   575                                  
   576                                  
   577                                  ;-114 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
   578 0000011C C9                       LEAVE
   579 0000011D C3                       ret
   580                                  ENDP
   581                                  
   582                                  getLine: PROC
   583                                  
   584                                  ;-115   unsigned int i;
   585                                  
   586                                  
   587                                  ;-116   InputPtr= &InputBuf;
   588                                  
   589                                  ;Function : getLine, Number of local variables: 1
   590                                  ;   # type sign width addr used name   list of local variables
   591                                  ;  200 var unsg word   115 NULL i = bp-2;
   592 0000011E C8020000                 ENTER  2,0
   593 00000122 B88D75                   mov ax, InputBuf
   594 00000125 A3[1400]                 mov word [InputPtr], ax
   595                                  
   596                                  ;-117   *InputPtr=0;//if last line is empty
   597                                  
   598 00000128 B80000                   mov ax, 0
   599 0000012B 8B1E[1400]               mov  bx, [InputPtr]
   600 0000012F 8807                     mov  [bx], al
   601                                  
   602                                  ;-118   do {
   603                                  
   604                                  .getLine4:
   605                                  
   606                                  ;-119     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
   607                                  
   608 00000131 6A01                     push 1
   609 00000133 FF36[1600]               push word [asm_fd]
   610 00000137 8D06[2200]               lea  ax, [DOS_ByteRead]
   611 0000013B 50                       push ax
   612 0000013C E8B5FF                   call readRL
   613 0000013F 83C406                   add  sp, 6
   614 00000142 A3[2000]                 mov word [DOS_NoBytes], ax
   615                                  
   616                                  ;-120     if (DOS_ERR) errorexit("Reading Source");
   617                                  
   618 00000145 A1[1C00]                 mov ax, [DOS_ERR]
   619 00000148 08C0                     or  al, al
   620 0000014A 0F840900                 je .getLine5
   621 0000014E 68[B001]                 push getLine_0
   622 00000151 E87B0A                   call errorexit
   623 00000154 83C402                   add  sp, 2
   624                                  
   625                                  ;-121     if (DOS_NoBytes == 0) return;
   626                                  
   627                                  .getLine5:
   628 00000157 A1[2000]                 mov ax, [DOS_NoBytes]
   629 0000015A 83F800                   cmp ax, 0
   630 0000015D 0F850300                 jne .getLine6
   631 00000161 E94A00                   jmp .retngetLine
   632                                  
   633                                  ;-122     *InputPtr = DOS_ByteRead;
   634                                  
   635                                  .getLine6:
   636 00000164 A0[2200]                 mov al, [DOS_ByteRead]
   637 00000167 8B1E[1400]               mov  bx, [InputPtr]
   638 0000016B 8807                     mov  [bx], al
   639                                  
   640                                  ;-123     InputPtr++;
   641                                  
   642 0000016D FF06[1400]               inc  word[InputPtr]
   643                                  
   644                                  ;-124     i = InputPtr - &InputBuf;
   645                                  
   646 00000171 A1[1400]                 mov ax, [InputPtr]
   647 00000174 2D8D75                   sub ax, InputBuf
   648 00000177 8946FE                   mov [bp-2], ax
   649                                  
   650                                  ;-125     if (i >= INPUTBUFMAX) errorexit("input line too long");
   651                                  
   652 0000017A 8B46FE                   mov ax, [bp-2]
   653 0000017D 3DFF00                   cmp ax, 255 ;unsigned : 0
   654 00000180 0F820900                 jb  .getLine7
   655 00000184 68[BF01]                 push getLine_1
   656 00000187 E8450A                   call errorexit
   657 0000018A 83C402                   add  sp, 2
   658                                  
   659                                  ;-126   } while (ifEOL(DOS_ByteRead) == 0);
   660                                  
   661                                  .getLine7:
   662 0000018D A0[2200]                 mov al, byte [DOS_ByteRead]
   663 00000190 B400                     mov ah, 0
   664 00000192 50                       push ax
   665 00000193 E83D00                   call ifEOL
   666 00000196 83C402                   add  sp, 2
   667 00000199 3C00                     cmp al, 0
   668 0000019B 0F850200                 jne .getLine8
   669 0000019F EB90                     jmp .getLine4
   670                                  .getLine8:
   671                                  
   672                                  ;-127   InputPtr--;
   673                                  
   674 000001A1 FF0E[1400]               dec  word[InputPtr]
   675                                  
   676                                  ;-128   *InputPtr=0;
   677                                  
   678 000001A5 B80000                   mov ax, 0
   679 000001A8 8B1E[1400]               mov  bx, [InputPtr]
   680 000001AC 8807                     mov  [bx], al
   681                                  
   682                                  ;-129 }
   683                                  
   684                                  
   685                                  ;-130 int ifEOL(char c) {//unix LF, win CRLF= 13/10, mac CR
   686                                  
   687 000001AE C9                       .retngetLine: LEAVE
   688 000001AF C3                       ret
   689 000001B0 52656164696E672053-     getLine_0 db "Reading Source",0
   690 000001B9 6F7572636500       
   691 000001BF 696E707574206C696E-     getLine_1 db "input line too long",0
   692 000001C8 6520746F6F206C6F6E-
   693 000001D1 6700               
   694                                  ENDP
   695                                  
   696                                  ifEOL: PROC
   697                                  
   698                                  ;-131   if (c == 10) return 1;//LF
   699                                  
   700                                  ;Function : ifEOL, Number of local variables: 1
   701                                  ;   # type sign width addr used name   list of local variables
   702                                  ;  200 var sign byte   130 NULL c = bp+4;
   703 000001D3 C8000000                 ENTER  0,0
   704 000001D7 8A4604                   mov al, [bp+4]
   705 000001DA 3C0A                     cmp al, 10
   706 000001DC 0F850600                 jne .ifEOL9
   707 000001E0 B80100                   mov ax, 1
   708 000001E3 E93B00                   jmp .retnifEOL
   709                                  
   710                                  ;-132   if (c == 13) {//CR
   711                                  
   712                                  .ifEOL9:
   713 000001E6 8A4604                   mov al, [bp+4]
   714 000001E9 3C0D                     cmp al, 13
   715 000001EB 0F852C00                 jne .ifEOL10
   716                                  
   717                                  ;-133     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
   718                                  
   719 000001EF 6A01                     push 1
   720 000001F1 FF36[1600]               push word [asm_fd]
   721 000001F5 8D06[2200]               lea  ax, [DOS_ByteRead]
   722 000001F9 50                       push ax
   723 000001FA E8F7FE                   call readRL
   724 000001FD 83C406                   add  sp, 6
   725 00000200 A3[2000]                 mov word [DOS_NoBytes], ax
   726                                  
   727                                  ;-134     if (DOS_ByteRead != 10) errorexit("missing LF(10) after CR(13)");
   728                                  
   729 00000203 A0[2200]                 mov al, [DOS_ByteRead]
   730 00000206 3C0A                     cmp al, 10
   731 00000208 0F840900                 je  .ifEOL11
   732 0000020C 68[2302]                 push ifEOL_0
   733 0000020F E8BD09                   call errorexit
   734 00000212 83C402                   add  sp, 2
   735                                  
   736                                  ;-135     return 1;
   737                                  
   738                                  .ifEOL11:
   739 00000215 B80100                   mov ax, 1
   740 00000218 E90600                   jmp .retnifEOL
   741                                  
   742                                  ;-136   }
   743                                  
   744                                  
   745                                  ;-137   return 0;
   746                                  
   747                                  .ifEOL10:
   748 0000021B B80000                   mov ax, 0
   749 0000021E E90000                   jmp .retnifEOL
   750                                  
   751                                  ;-138 }
   752                                  
   753                                  
   754                                  ;-139 int skipBlank() {
   755                                  
   756 00000221 C9                       .retnifEOL: LEAVE
   757 00000222 C3                       ret
   758 00000223 6D697373696E67204C-     ifEOL_0 db "missing LF(10) after CR(13)",0
   759 0000022C 462831302920616674-
   760 00000235 657220435228313329-
   761 0000023E 00                 
   762                                  ENDP
   763                                  
   764                                  skipBlank: PROC
   765                                  
   766                                  ;-140   skipblank1:
   767                                  
   768                                  .skipblank1:
   769                                  
   770                                  ;-141     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
   771                                  
   772 0000023F 8B1E[1400]               mov bx, [InputPtr]
   773 00000243 8A07                     mov al, [bx]
   774 00000245 B400                     mov ah, 0
   775 00000247 83F820                   cmp ax, 32
   776 0000024A 0F850600                 jne .skipBlank12
   777 0000024E FF06[1400]               inc  word[InputPtr]
   778 00000252 EBEB                     jmp .skipblank1
   779                                  
   780                                  ;-142     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
   781                                  
   782                                  .skipBlank12:
   783 00000254 8B1E[1400]               mov bx, [InputPtr]
   784 00000258 8A07                     mov al, [bx]
   785 0000025A B400                     mov ah, 0
   786 0000025C 83F809                   cmp ax, 9
   787 0000025F 0F850600                 jne .skipBlank13
   788 00000263 FF06[1400]               inc  word[InputPtr]
   789 00000267 EBD6                     jmp .skipblank1
   790                                  
   791                                  ;-143 }
   792                                  
   793                                  .skipBlank13:
   794                                  
   795                                  ;-144 int letterE(char c) {
   796                                  
   797 00000269 C3                       ret
   798                                  ENDP
   799                                  
   800                                  letterE: PROC
   801                                  
   802                                  ;-145   if (c=='_') return 1;
   803                                  
   804                                  ;Function : letterE, Number of local variables: 1
   805                                  ;   # type sign width addr used name   list of local variables
   806                                  ;  200 var sign byte   144 NULL c = bp+4;
   807 0000026A C8000000                 ENTER  0,0
   808 0000026E 8A4604                   mov al, [bp+4]
   809 00000271 3C5F                     cmp al, 95
   810 00000273 0F850600                 jne .letterE14
   811 00000277 B80100                   mov ax, 1
   812 0000027A E96900                   jmp .retnletterE
   813                                  
   814                                  ;-146   if (c=='.') return 1;
   815                                  
   816                                  .letterE14:
   817 0000027D 8A4604                   mov al, [bp+4]
   818 00000280 3C2E                     cmp al, 46
   819 00000282 0F850600                 jne .letterE15
   820 00000286 B80100                   mov ax, 1
   821 00000289 E95A00                   jmp .retnletterE
   822                                  
   823                                  ;-147   if (c=='?') return 1;
   824                                  
   825                                  .letterE15:
   826 0000028C 8A4604                   mov al, [bp+4]
   827 0000028F 3C3F                     cmp al, 63
   828 00000291 0F850600                 jne .letterE16
   829 00000295 B80100                   mov ax, 1
   830 00000298 E94B00                   jmp .retnletterE
   831                                  
   832                                  ;-148   if (c=='$') return 1;
   833                                  
   834                                  .letterE16:
   835 0000029B 8A4604                   mov al, [bp+4]
   836 0000029E 3C24                     cmp al, 36
   837 000002A0 0F850600                 jne .letterE17
   838 000002A4 B80100                   mov ax, 1
   839 000002A7 E93C00                   jmp .retnletterE
   840                                  
   841                                  ;-149   if (c> 'z') return 0;
   842                                  
   843                                  .letterE17:
   844 000002AA 8A4604                   mov al, [bp+4]
   845 000002AD 3C7A                     cmp al, 122
   846 000002AF 0F8E0600                 jle .letterE18
   847 000002B3 B80000                   mov ax, 0
   848 000002B6 E92D00                   jmp .retnletterE
   849                                  
   850                                  ;-150   if (c< '@') return 0; // at included
   851                                  
   852                                  .letterE18:
   853 000002B9 8A4604                   mov al, [bp+4]
   854 000002BC 3C40                     cmp al, 64
   855 000002BE 0F8D0600                 jge .letterE19
   856 000002C2 B80000                   mov ax, 0
   857 000002C5 E91E00                   jmp .retnletterE
   858                                  
   859                                  ;-151   if (c> 'Z') { if (c< 'a') return 0; }
   860                                  
   861                                  .letterE19:
   862 000002C8 8A4604                   mov al, [bp+4]
   863 000002CB 3C5A                     cmp al, 90
   864 000002CD 0F8E0F00                 jle .letterE20
   865 000002D1 8A4604                   mov al, [bp+4]
   866 000002D4 3C61                     cmp al, 97
   867 000002D6 0F8D0600                 jge .letterE21
   868 000002DA B80000                   mov ax, 0
   869 000002DD E90600                   jmp .retnletterE
   870                                  .letterE21:
   871                                  
   872                                  ;-152   return 1;
   873                                  
   874                                  .letterE20:
   875 000002E0 B80100                   mov ax, 1
   876 000002E3 E90000                   jmp .retnletterE
   877                                  
   878                                  ;-153 }
   879                                  
   880                                  
   881                                  ;-154 int alnumE(char c) {
   882                                  
   883 000002E6 C9                       .retnletterE: LEAVE
   884 000002E7 C3                       ret
   885                                  ENDP
   886                                  
   887                                  alnumE: PROC
   888                                  
   889                                  ;-155   if (digit(c)) return 1;
   890                                  
   891                                  ;Function : alnumE, Number of local variables: 1
   892                                  ;   # type sign width addr used name   list of local variables
   893                                  ;  200 var sign byte   154 NULL c = bp+4;
   894 000002E8 C8000000                 ENTER  0,0
   895 000002EC 8A4604                   mov al, byte [bp+4]
   896 000002EF B400                     mov ah, 0
   897 000002F1 50                       push ax
   898 000002F2 E82F00                   call digit
   899 000002F5 83C402                   add  sp, 2
   900 000002F8 08C0                     or  al, al
   901 000002FA 0F840600                 je .alnumE22
   902 000002FE B80100                   mov ax, 1
   903 00000301 E91E00                   jmp .retnalnumE
   904                                  
   905                                  ;-156   if (letterE(c)) return 1;
   906                                  
   907                                  .alnumE22:
   908 00000304 8A4604                   mov al, byte [bp+4]
   909 00000307 B400                     mov ah, 0
   910 00000309 50                       push ax
   911 0000030A E85DFF                   call letterE
   912 0000030D 83C402                   add  sp, 2
   913 00000310 08C0                     or  al, al
   914 00000312 0F840600                 je .alnumE23
   915 00000316 B80100                   mov ax, 1
   916 00000319 E90600                   jmp .retnalnumE
   917                                  
   918                                  ;-157   return 0;
   919                                  
   920                                  .alnumE23:
   921 0000031C B80000                   mov ax, 0
   922 0000031F E90000                   jmp .retnalnumE
   923                                  
   924                                  ;-158 }
   925                                  
   926                                  
   927                                  ;-159 int digit(char c){
   928                                  
   929 00000322 C9                       .retnalnumE: LEAVE
   930 00000323 C3                       ret
   931                                  ENDP
   932                                  
   933                                  digit: PROC
   934                                  
   935                                  ;-160     if(c<'0') return 0;
   936                                  
   937                                  ;Function : digit, Number of local variables: 1
   938                                  ;   # type sign width addr used name   list of local variables
   939                                  ;  200 var sign byte   159 NULL c = bp+4;
   940 00000324 C8000000                 ENTER  0,0
   941 00000328 8A4604                   mov al, [bp+4]
   942 0000032B 3C30                     cmp al, 48
   943 0000032D 0F8D0600                 jge .digit24
   944 00000331 B80000                   mov ax, 0
   945 00000334 E91500                   jmp .retndigit
   946                                  
   947                                  ;-161     if(c>'9') return 0;
   948                                  
   949                                  .digit24:
   950 00000337 8A4604                   mov al, [bp+4]
   951 0000033A 3C39                     cmp al, 57
   952 0000033C 0F8E0600                 jle .digit25
   953 00000340 B80000                   mov ax, 0
   954 00000343 E90600                   jmp .retndigit
   955                                  
   956                                  ;-162     return 1;
   957                                  
   958                                  .digit25:
   959 00000346 B80100                   mov ax, 1
   960 00000349 E90000                   jmp .retndigit
   961                                  
   962                                  ;-163 }
   963                                  
   964                                  
   965                                  ;-164 int strlen(char *s) { int c;
   966                                  
   967 0000034C C9                       .retndigit: LEAVE
   968 0000034D C3                       ret
   969                                  ENDP
   970                                  
   971                                  strlen: PROC
   972                                  
   973                                  ;-165     c=0;
   974                                  
   975                                  ;Function : strlen, Number of local variables: 2
   976                                  ;   # type sign width addr used name   list of local variables
   977                                  ;  200 ptr sign byte   164 NULL s = bp+4
   978                                  ;  201 var sign word   164 NULL c = bp-2;
   979 0000034E C8020000                 ENTER  2,0
   980 00000352 B80000                   mov ax, 0
   981 00000355 8946FE                   mov [bp-2], ax
   982                                  
   983                                  ;-166     while (*s!=0) {s++; c++;}
   984                                  
   985                                  .strlen26:
   986 00000358 8B5E04                   mov bx, [bp+4]
   987 0000035B 8A07                     mov al, [bx]
   988 0000035D B400                     mov ah, 0
   989 0000035F 83F800                   cmp ax, 0
   990 00000362 0F840800                 je  .strlen27
   991 00000366 FF4604                   inc  word[bp+4]
   992 00000369 FF46FE                   inc  word[bp-2]
   993                                  
   994                                  ;-167     return c;
   995                                  
   996 0000036C EBEA                     jmp .strlen26
   997                                  .strlen27:
   998 0000036E 8B46FE                   mov ax, [bp-2]
   999 00000371 E90000                   jmp .retnstrlen
  1000                                  
  1001                                  ;-168     }
  1002                                  
  1003                                  
  1004                                  ;-169 int strcpy(char *s, char *t) {
  1005                                  
  1006 00000374 C9                       .retnstrlen: LEAVE
  1007 00000375 C3                       ret
  1008                                  ENDP
  1009                                  
  1010                                  strcpy: PROC
  1011                                  
  1012                                  ;-170     do { *s=*t; s++; t++; }
  1013                                  
  1014                                  ;Function : strcpy, Number of local variables: 2
  1015                                  ;   # type sign width addr used name   list of local variables
  1016                                  ;  200 ptr sign byte   169 NULL s = bp+4
  1017                                  ;  201 ptr sign byte   169 NULL t = bp+6;
  1018 00000376 C8000000                 ENTER  0,0
  1019                                  .strcpy28:
  1020 0000037A 8B5E06                   mov bx, [bp+6]
  1021 0000037D 8A07                     mov al, [bx]
  1022 0000037F B400                     mov ah, 0
  1023 00000381 8B5E04                   mov  bx, [bp+4]
  1024 00000384 8807                     mov  [bx], al
  1025 00000386 FF4604                   inc  word[bp+4]
  1026 00000389 FF4606                   inc  word[bp+6]
  1027                                  
  1028                                  ;-171     while (*t!=0);
  1029                                  
  1030 0000038C 8B5E06                   mov bx, [bp+6]
  1031 0000038F 8A07                     mov al, [bx]
  1032 00000391 B400                     mov ah, 0
  1033 00000393 83F800                   cmp ax, 0
  1034 00000396 0F840200                 je  .strcpy29
  1035 0000039A EBDE                     jmp .strcpy28
  1036                                  .strcpy29:
  1037                                  
  1038                                  ;-172     *s=0;
  1039                                  
  1040 0000039C B80000                   mov ax, 0
  1041 0000039F 8B5E04                   mov  bx, [bp+4]
  1042 000003A2 8807                     mov  [bx], al
  1043                                  
  1044                                  ;-173     return s;
  1045                                  
  1046 000003A4 8B4604                   mov ax, [bp+4]
  1047 000003A7 E90000                   jmp .retnstrcpy
  1048                                  
  1049                                  ;-174     }
  1050                                  
  1051                                  
  1052                                  ;-175 int eqstr(char *p, char *q) {
  1053                                  
  1054 000003AA C9                       .retnstrcpy: LEAVE
  1055 000003AB C3                       ret
  1056                                  ENDP
  1057                                  
  1058                                  eqstr: PROC
  1059                                  
  1060                                  ;-176     while(*p) {
  1061                                  
  1062                                  ;Function : eqstr, Number of local variables: 2
  1063                                  ;   # type sign width addr used name   list of local variables
  1064                                  ;  200 ptr sign byte   175 NULL p = bp+4
  1065                                  ;  201 ptr sign byte   175 NULL q = bp+6;
  1066 000003AC C8000000                 ENTER  0,0
  1067                                  .eqstr30:
  1068 000003B0 8B5E04                   mov bx, [bp+4]
  1069 000003B3 8A07                     mov al, [bx]
  1070 000003B5 B400                     mov ah, 0
  1071 000003B7 08C0                     or  al, al
  1072 000003B9 0F842000                 je .eqstr31
  1073                                  
  1074                                  ;-177         if (*p != *q) return 0;
  1075                                  
  1076 000003BD 8B5E04                   mov bx, [bp+4]
  1077 000003C0 8A07                     mov al, [bx]
  1078 000003C2 B400                     mov ah, 0
  1079 000003C4 8B5E06                   mov bx, [bp+6]
  1080 000003C7 3A07                     cmp al, [bx]
  1081 000003C9 B400                     mov ah, 0
  1082 000003CB 0F840600                 je  .eqstr32
  1083 000003CF B80000                   mov ax, 0
  1084 000003D2 E92100                   jmp .retneqstr
  1085                                  
  1086                                  ;-178             p++;
  1087                                  
  1088                                  .eqstr32:
  1089 000003D5 FF4604                   inc  word[bp+4]
  1090                                  
  1091                                  ;-179             q++;
  1092                                  
  1093 000003D8 FF4606                   inc  word[bp+6]
  1094                                  
  1095                                  ;-180             }
  1096                                  
  1097                                  
  1098                                  ;-181     if(*q) return 0;
  1099                                  
  1100 000003DB EBD3                     jmp .eqstr30
  1101                                  .eqstr31:
  1102 000003DD 8B5E06                   mov bx, [bp+6]
  1103 000003E0 8A07                     mov al, [bx]
  1104 000003E2 B400                     mov ah, 0
  1105 000003E4 08C0                     or  al, al
  1106 000003E6 0F840600                 je .eqstr33
  1107 000003EA B80000                   mov ax, 0
  1108 000003ED E90600                   jmp .retneqstr
  1109                                  
  1110                                  ;-182     return 1;
  1111                                  
  1112                                  .eqstr33:
  1113 000003F0 B80100                   mov ax, 1
  1114 000003F3 E90000                   jmp .retneqstr
  1115                                  
  1116                                  ;-183     }
  1117                                  
  1118                                  
  1119                                  ;-184 int strcat1(char *s, char *t) {
  1120                                  
  1121 000003F6 C9                       .retneqstr: LEAVE
  1122 000003F7 C3                       ret
  1123                                  ENDP
  1124                                  
  1125                                  strcat1: PROC
  1126                                  
  1127                                  ;-185     while (*s != 0) s++;
  1128                                  
  1129                                  ;Function : strcat1, Number of local variables: 2
  1130                                  ;   # type sign width addr used name   list of local variables
  1131                                  ;  200 ptr sign byte   184 NULL s = bp+4
  1132                                  ;  201 ptr sign byte   184 NULL t = bp+6;
  1133 000003F8 C8000000                 ENTER  0,0
  1134                                  .strcat134:
  1135 000003FC 8B5E04                   mov bx, [bp+4]
  1136 000003FF 8A07                     mov al, [bx]
  1137 00000401 B400                     mov ah, 0
  1138 00000403 83F800                   cmp ax, 0
  1139 00000406 0F840500                 je  .strcat135
  1140 0000040A FF4604                   inc  word[bp+4]
  1141                                  
  1142                                  ;-186     strcpy(s, t);
  1143                                  
  1144 0000040D EBED                     jmp .strcat134
  1145                                  .strcat135:
  1146 0000040F FF7606                   push word [bp+6]
  1147 00000412 FF7604                   push word [bp+4]
  1148 00000415 E85EFF                   call strcpy
  1149 00000418 83C404                   add  sp, 4
  1150                                  
  1151                                  ;-187     }
  1152                                  
  1153                                  
  1154                                  ;-188 int toupper(char *s) {
  1155 0000041B C9                       LEAVE
  1156 0000041C C3                       ret
  1157                                  ENDP
  1158                                  
  1159                                  toupper: PROC
  1160                                  
  1161                                  ;-189     while(*s) {
  1162                                  
  1163                                  ;Function : toupper, Number of local variables: 1
  1164                                  ;   # type sign width addr used name   list of local variables
  1165                                  ;  200 ptr sign byte   188 NULL s = bp+4;
  1166 0000041D C8000000                 ENTER  0,0
  1167                                  .toupper36:
  1168 00000421 8B5E04                   mov bx, [bp+4]
  1169 00000424 8A07                     mov al, [bx]
  1170 00000426 B400                     mov ah, 0
  1171 00000428 08C0                     or  al, al
  1172 0000042A 0F843000                 je .toupper37
  1173                                  
  1174                                  ;-190         if (*s >= 'a') if (*s <= 'z') *s=*s-32;
  1175                                  
  1176 0000042E 8B5E04                   mov bx, [bp+4]
  1177 00000431 8A07                     mov al, [bx]
  1178 00000433 B400                     mov ah, 0
  1179 00000435 83F861                   cmp ax, 97 ;unsigned : 1
  1180 00000438 0F8C1D00                 jl  .toupper38
  1181 0000043C 8B5E04                   mov bx, [bp+4]
  1182 0000043F 8A07                     mov al, [bx]
  1183 00000441 B400                     mov ah, 0
  1184 00000443 83F87A                   cmp ax, 122
  1185 00000446 0F8F0F00                 jg  .toupper39
  1186 0000044A 8B5E04                   mov bx, [bp+4]
  1187 0000044D 8A07                     mov al, [bx]
  1188 0000044F B400                     mov ah, 0
  1189 00000451 83E820                   sub ax, 32
  1190 00000454 8B5E04                   mov  bx, [bp+4]
  1191 00000457 8807                     mov  [bx], al
  1192                                  
  1193                                  ;-191             s++;
  1194                                  
  1195                                  .toupper39:
  1196                                  .toupper38:
  1197 00000459 FF4604                   inc  word[bp+4]
  1198                                  
  1199                                  ;-192               }
  1200                                  
  1201                                  
  1202                                  ;-193     }
  1203                                  
  1204 0000045C EBC3                     jmp .toupper36
  1205                                  .toupper37:
  1206                                  
  1207                                  ;-194 
  1208                                  
  1209                                  
  1210                                  ;-195 int getDigit(unsigned char c) {//ret: SymbolInt
  1211 0000045E C9                       LEAVE
  1212 0000045F C3                       ret
  1213                                  ENDP
  1214                                  
  1215                                  getDigit: PROC
  1216                                  
  1217                                  ;-196   unsigned int CastInt;
  1218                                  
  1219                                  
  1220                                  ;-197   SymbolInt=0;
  1221                                  
  1222                                  ;Function : getDigit, Number of local variables: 2
  1223                                  ;   # type sign width addr used name   list of local variables
  1224                                  ;  200 var unsg byte   195 NULL c = bp+4
  1225                                  ;  201 var unsg word   196 NULL CastInt = bp-2;
  1226 00000460 C8020000                 ENTER  2,0
  1227 00000464 B80000                   mov ax, 0
  1228 00000467 A3[0E00]                 mov word [SymbolInt], ax
  1229                                  
  1230                                  ;-198   do {
  1231                                  
  1232                                  .getDigit40:
  1233                                  
  1234                                  ;-199     c-='0';
  1235                                  
  1236 0000046A 806E0430                 sub  byte[bp+4], 48
  1237                                  
  1238                                  ;-200     SymbolInt=SymbolInt*10;
  1239                                  
  1240 0000046E A1[0E00]                 mov ax, [SymbolInt]
  1241 00000471 BB0A00                   mov bx, 10
  1242 00000474 F7E3                     mul bx
  1243 00000476 A3[0E00]                 mov word [SymbolInt], ax
  1244                                  
  1245                                  ;-201     ax=0; CastInt=c; //cast b2w
  1246                                  
  1247 00000479 B80000                   mov  ax, 0
  1248 0000047C 8A4604                   mov al, [bp+4]
  1249 0000047F 8946FE                   mov [bp-2], ax
  1250                                  
  1251                                  ;-202     SymbolInt=SymbolInt+CastInt;
  1252                                  
  1253 00000482 A1[0E00]                 mov ax, [SymbolInt]
  1254 00000485 0346FE                   add ax, [bp-2]
  1255 00000488 A3[0E00]                 mov word [SymbolInt], ax
  1256                                  
  1257                                  ;-203     InputPtr++;
  1258                                  
  1259 0000048B FF06[1400]               inc  word[InputPtr]
  1260                                  
  1261                                  ;-204     c = *InputPtr;
  1262                                  
  1263 0000048F 8B1E[1400]               mov bx, [InputPtr]
  1264 00000493 8A07                     mov al, [bx]
  1265 00000495 B400                     mov ah, 0
  1266 00000497 884604                   mov [bp+4], al
  1267                                  
  1268                                  ;-205   } while(digit(c));
  1269                                  
  1270 0000049A 8A4604                   mov al, byte [bp+4]
  1271 0000049D B400                     mov ah, 0
  1272 0000049F 50                       push ax
  1273 000004A0 E881FE                   call digit
  1274 000004A3 83C402                   add  sp, 2
  1275 000004A6 08C0                     or  al, al
  1276 000004A8 0F840200                 je .getDigit41
  1277 000004AC EBBC                     jmp .getDigit40
  1278                                  .getDigit41:
  1279                                  
  1280                                  ;-206 }
  1281                                  
  1282                                  
  1283                                  ;-207 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  1284 000004AE C9                       LEAVE
  1285 000004AF C3                       ret
  1286                                  ENDP
  1287                                  
  1288                                  getName: PROC
  1289                                  
  1290                                  ;-208   char *p; unsigned int i;
  1291                                  
  1292                                  
  1293                                  ;-209   p = &Symbol;
  1294                                  
  1295                                  ;Function : getName, Number of local variables: 3
  1296                                  ;   # type sign width addr used name   list of local variables
  1297                                  ;  200 var unsg byte   207 NULL c = bp+4
  1298                                  ;  201 ptr sign byte   208 NULL p = bp-2
  1299                                  ;  202 var unsg word   208 NULL i = bp-4;
  1300 000004B0 C8040000                 ENTER  4,0
  1301 000004B4 B83075                   mov ax, Symbol
  1302 000004B7 8946FE                   mov [bp-2], ax
  1303                                  
  1304                                  ;-210   *p = c;
  1305                                  
  1306 000004BA 8A4604                   mov al, [bp+4]
  1307 000004BD 8B5EFE                   mov  bx, [bp-2]
  1308 000004C0 8807                     mov  [bx], al
  1309                                  
  1310                                  ;-211   p++;
  1311                                  
  1312 000004C2 FF46FE                   inc  word[bp-2]
  1313                                  
  1314                                  ;-212   while (alnumE(c)) {
  1315                                  
  1316                                  .getName42:
  1317 000004C5 8A4604                   mov al, byte [bp+4]
  1318 000004C8 B400                     mov ah, 0
  1319 000004CA 50                       push ax
  1320 000004CB E81AFE                   call alnumE
  1321 000004CE 83C402                   add  sp, 2
  1322 000004D1 08C0                     or  al, al
  1323 000004D3 0F843800                 je .getName43
  1324                                  
  1325                                  ;-213     InputPtr++;
  1326                                  
  1327 000004D7 FF06[1400]               inc  word[InputPtr]
  1328                                  
  1329                                  ;-214     c = *InputPtr;
  1330                                  
  1331 000004DB 8B1E[1400]               mov bx, [InputPtr]
  1332 000004DF 8A07                     mov al, [bx]
  1333 000004E1 B400                     mov ah, 0
  1334 000004E3 884604                   mov [bp+4], al
  1335                                  
  1336                                  ;-215     *p = c;
  1337                                  
  1338 000004E6 8A4604                   mov al, [bp+4]
  1339 000004E9 8B5EFE                   mov  bx, [bp-2]
  1340 000004EC 8807                     mov  [bx], al
  1341                                  
  1342                                  ;-216     p++;
  1343                                  
  1344 000004EE FF46FE                   inc  word[bp-2]
  1345                                  
  1346                                  ;-217     i = p - &Symbol;
  1347                                  
  1348 000004F1 8B46FE                   mov ax, [bp-2]
  1349 000004F4 2D3075                   sub ax, Symbol
  1350 000004F7 8946FC                   mov [bp-4], ax
  1351                                  
  1352                                  ;-218     if (i >= SYMBOLMAX) errorexit("symbol too long");
  1353                                  
  1354 000004FA 8B46FC                   mov ax, [bp-4]
  1355 000004FD 83F81F                   cmp ax, 31 ;unsigned : 0
  1356 00000500 0F820900                 jb  .getName44
  1357 00000504 68[4F05]                 push getName_0
  1358 00000507 E8C506                   call errorexit
  1359 0000050A 83C402                   add  sp, 2
  1360                                  
  1361                                  ;-219   }
  1362                                  
  1363                                  .getName44:
  1364                                  
  1365                                  ;-220   if (c == ':') isLabel=1; else isLabel=0;
  1366                                  
  1367 0000050D EBB6                     jmp .getName42
  1368                                  .getName43:
  1369 0000050F 8A4604                   mov al, [bp+4]
  1370 00000512 3C3A                     cmp al, 58
  1371 00000514 0F850900                 jne .getName45
  1372 00000518 B80100                   mov ax, 1
  1373 0000051B A2[2B00]                 mov byte [isLabel], al
  1374 0000051E E90600                   jmp .getName46
  1375                                  .getName45:
  1376 00000521 B80000                   mov ax, 0
  1377 00000524 A2[2B00]                 mov byte [isLabel], al
  1378                                  
  1379                                  ;-221   p--;
  1380                                  
  1381                                  .getName46:
  1382 00000527 FF4EFE                   dec  word[bp-2]
  1383                                  
  1384                                  ;-222   *p = 0;
  1385                                  
  1386 0000052A B80000                   mov ax, 0
  1387 0000052D 8B5EFE                   mov  bx, [bp-2]
  1388 00000530 8807                     mov  [bx], al
  1389                                  
  1390                                  ;-223   strcpy(SymbolUpper, Symbol);
  1391                                  
  1392 00000532 8D063075                 lea  ax, [Symbol]
  1393 00000536 50                       push ax
  1394 00000537 8D064F75                 lea  ax, [SymbolUpper]
  1395 0000053B 50                       push ax
  1396 0000053C E837FE                   call strcpy
  1397 0000053F 83C404                   add  sp, 4
  1398                                  
  1399                                  ;-224   toupper(SymbolUpper);
  1400                                  
  1401 00000542 8D064F75                 lea  ax, [SymbolUpper]
  1402 00000546 50                       push ax
  1403 00000547 E8D3FE                   call toupper
  1404 0000054A 83C402                   add  sp, 2
  1405                                  
  1406                                  ;-225 }
  1407                                  
  1408                                  
  1409                                  ;-226 int testReg() {
  1410 0000054D C9                       LEAVE
  1411 0000054E C3                       ret
  1412 0000054F 73796D626F6C20746F-     getName_0 db "symbol too long",0
  1413 00000558 6F206C6F6E6700     
  1414                                  ENDP
  1415                                  
  1416                                  testReg: PROC
  1417                                  
  1418                                  ;-227 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  1419                                  
  1420                                  
  1421                                  ;-228   R2Type=0;
  1422                                  
  1423 0000055F B80000                   mov ax, 0
  1424 00000562 A2[3500]                 mov byte [R2Type], al
  1425                                  
  1426                                  ;-229   if (strlen(Symbol) < 2) return 0;
  1427                                  
  1428 00000565 8D063075                 lea  ax, [Symbol]
  1429 00000569 50                       push ax
  1430 0000056A E8E1FD                   call strlen
  1431 0000056D 83C402                   add  sp, 2
  1432 00000570 3C02                     cmp al, 2
  1433 00000572 0F8D0600                 jge .testReg47
  1434 00000576 B80000                   mov ax, 0
  1435 00000579 E94703                   jmp .retntestReg
  1436                                  
  1437                                  ;-230   if (strlen(Symbol) > 3) return 0;
  1438                                  
  1439                                  .testReg47:
  1440 0000057C 8D063075                 lea  ax, [Symbol]
  1441 00000580 50                       push ax
  1442 00000581 E8CAFD                   call strlen
  1443 00000584 83C402                   add  sp, 2
  1444 00000587 3C03                     cmp al, 3
  1445 00000589 0F8E0600                 jle .testReg48
  1446 0000058D B80000                   mov ax, 0
  1447 00000590 E93003                   jmp .retntestReg
  1448                                  
  1449                                  ;-231   R2Type=BYTE;
  1450                                  
  1451                                  .testReg48:
  1452 00000593 B80100                   mov ax, 1
  1453 00000596 A2[3500]                 mov byte [R2Type], al
  1454                                  
  1455                                  ;-232   if (eqstr(SymbolUpper, "AL")) return 0;
  1456                                  
  1457 00000599 68[C408]                 push testReg_0
  1458 0000059C 8D064F75                 lea  ax, [SymbolUpper]
  1459 000005A0 50                       push ax
  1460 000005A1 E808FE                   call eqstr
  1461 000005A4 83C404                   add  sp, 4
  1462 000005A7 08C0                     or  al, al
  1463 000005A9 0F840600                 je .testReg49
  1464 000005AD B80000                   mov ax, 0
  1465 000005B0 E91003                   jmp .retntestReg
  1466                                  
  1467                                  ;-233   if (eqstr(SymbolUpper, "CL")) return 1;
  1468                                  
  1469                                  .testReg49:
  1470 000005B3 68[C708]                 push testReg_1
  1471 000005B6 8D064F75                 lea  ax, [SymbolUpper]
  1472 000005BA 50                       push ax
  1473 000005BB E8EEFD                   call eqstr
  1474 000005BE 83C404                   add  sp, 4
  1475 000005C1 08C0                     or  al, al
  1476 000005C3 0F840600                 je .testReg50
  1477 000005C7 B80100                   mov ax, 1
  1478 000005CA E9F602                   jmp .retntestReg
  1479                                  
  1480                                  ;-234   if (eqstr(SymbolUpper, "DL")) return 2;
  1481                                  
  1482                                  .testReg50:
  1483 000005CD 68[CA08]                 push testReg_2
  1484 000005D0 8D064F75                 lea  ax, [SymbolUpper]
  1485 000005D4 50                       push ax
  1486 000005D5 E8D4FD                   call eqstr
  1487 000005D8 83C404                   add  sp, 4
  1488 000005DB 08C0                     or  al, al
  1489 000005DD 0F840600                 je .testReg51
  1490 000005E1 B80200                   mov ax, 2
  1491 000005E4 E9DC02                   jmp .retntestReg
  1492                                  
  1493                                  ;-235   if (eqstr(SymbolUpper, "BL")) return 3;
  1494                                  
  1495                                  .testReg51:
  1496 000005E7 68[CD08]                 push testReg_3
  1497 000005EA 8D064F75                 lea  ax, [SymbolUpper]
  1498 000005EE 50                       push ax
  1499 000005EF E8BAFD                   call eqstr
  1500 000005F2 83C404                   add  sp, 4
  1501 000005F5 08C0                     or  al, al
  1502 000005F7 0F840600                 je .testReg52
  1503 000005FB B80300                   mov ax, 3
  1504 000005FE E9C202                   jmp .retntestReg
  1505                                  
  1506                                  ;-236   if (eqstr(SymbolUpper, "AH")) return 4;
  1507                                  
  1508                                  .testReg52:
  1509 00000601 68[D008]                 push testReg_4
  1510 00000604 8D064F75                 lea  ax, [SymbolUpper]
  1511 00000608 50                       push ax
  1512 00000609 E8A0FD                   call eqstr
  1513 0000060C 83C404                   add  sp, 4
  1514 0000060F 08C0                     or  al, al
  1515 00000611 0F840600                 je .testReg53
  1516 00000615 B80400                   mov ax, 4
  1517 00000618 E9A802                   jmp .retntestReg
  1518                                  
  1519                                  ;-237   if (eqstr(SymbolUpper, "CH")) return 5;
  1520                                  
  1521                                  .testReg53:
  1522 0000061B 68[D308]                 push testReg_5
  1523 0000061E 8D064F75                 lea  ax, [SymbolUpper]
  1524 00000622 50                       push ax
  1525 00000623 E886FD                   call eqstr
  1526 00000626 83C404                   add  sp, 4
  1527 00000629 08C0                     or  al, al
  1528 0000062B 0F840600                 je .testReg54
  1529 0000062F B80500                   mov ax, 5
  1530 00000632 E98E02                   jmp .retntestReg
  1531                                  
  1532                                  ;-238   if (eqstr(SymbolUpper, "DH")) return 6;
  1533                                  
  1534                                  .testReg54:
  1535 00000635 68[D608]                 push testReg_6
  1536 00000638 8D064F75                 lea  ax, [SymbolUpper]
  1537 0000063C 50                       push ax
  1538 0000063D E86CFD                   call eqstr
  1539 00000640 83C404                   add  sp, 4
  1540 00000643 08C0                     or  al, al
  1541 00000645 0F840600                 je .testReg55
  1542 00000649 B80600                   mov ax, 6
  1543 0000064C E97402                   jmp .retntestReg
  1544                                  
  1545                                  ;-239   if (eqstr(SymbolUpper, "BH")) return 7;
  1546                                  
  1547                                  .testReg55:
  1548 0000064F 68[D908]                 push testReg_7
  1549 00000652 8D064F75                 lea  ax, [SymbolUpper]
  1550 00000656 50                       push ax
  1551 00000657 E852FD                   call eqstr
  1552 0000065A 83C404                   add  sp, 4
  1553 0000065D 08C0                     or  al, al
  1554 0000065F 0F840600                 je .testReg56
  1555 00000663 B80700                   mov ax, 7
  1556 00000666 E95A02                   jmp .retntestReg
  1557                                  
  1558                                  ;-240   R2Type=WORD;
  1559                                  
  1560                                  .testReg56:
  1561 00000669 B80200                   mov ax, 2
  1562 0000066C A2[3500]                 mov byte [R2Type], al
  1563                                  
  1564                                  ;-241   if (eqstr(SymbolUpper, "AX")) return 0;
  1565                                  
  1566 0000066F 68[DC08]                 push testReg_8
  1567 00000672 8D064F75                 lea  ax, [SymbolUpper]
  1568 00000676 50                       push ax
  1569 00000677 E832FD                   call eqstr
  1570 0000067A 83C404                   add  sp, 4
  1571 0000067D 08C0                     or  al, al
  1572 0000067F 0F840600                 je .testReg57
  1573 00000683 B80000                   mov ax, 0
  1574 00000686 E93A02                   jmp .retntestReg
  1575                                  
  1576                                  ;-242   if (eqstr(SymbolUpper, "CX")) return 1;
  1577                                  
  1578                                  .testReg57:
  1579 00000689 68[DF08]                 push testReg_9
  1580 0000068C 8D064F75                 lea  ax, [SymbolUpper]
  1581 00000690 50                       push ax
  1582 00000691 E818FD                   call eqstr
  1583 00000694 83C404                   add  sp, 4
  1584 00000697 08C0                     or  al, al
  1585 00000699 0F840600                 je .testReg58
  1586 0000069D B80100                   mov ax, 1
  1587 000006A0 E92002                   jmp .retntestReg
  1588                                  
  1589                                  ;-243   if (eqstr(SymbolUpper, "DX")) return 2;
  1590                                  
  1591                                  .testReg58:
  1592 000006A3 68[E208]                 push testReg_10
  1593 000006A6 8D064F75                 lea  ax, [SymbolUpper]
  1594 000006AA 50                       push ax
  1595 000006AB E8FEFC                   call eqstr
  1596 000006AE 83C404                   add  sp, 4
  1597 000006B1 08C0                     or  al, al
  1598 000006B3 0F840600                 je .testReg59
  1599 000006B7 B80200                   mov ax, 2
  1600 000006BA E90602                   jmp .retntestReg
  1601                                  
  1602                                  ;-244   if (eqstr(SymbolUpper, "BX")) return 3;
  1603                                  
  1604                                  .testReg59:
  1605 000006BD 68[E508]                 push testReg_11
  1606 000006C0 8D064F75                 lea  ax, [SymbolUpper]
  1607 000006C4 50                       push ax
  1608 000006C5 E8E4FC                   call eqstr
  1609 000006C8 83C404                   add  sp, 4
  1610 000006CB 08C0                     or  al, al
  1611 000006CD 0F840600                 je .testReg60
  1612 000006D1 B80300                   mov ax, 3
  1613 000006D4 E9EC01                   jmp .retntestReg
  1614                                  
  1615                                  ;-245   if (eqstr(SymbolUpper, "SP")) return 4;
  1616                                  
  1617                                  .testReg60:
  1618 000006D7 68[E808]                 push testReg_12
  1619 000006DA 8D064F75                 lea  ax, [SymbolUpper]
  1620 000006DE 50                       push ax
  1621 000006DF E8CAFC                   call eqstr
  1622 000006E2 83C404                   add  sp, 4
  1623 000006E5 08C0                     or  al, al
  1624 000006E7 0F840600                 je .testReg61
  1625 000006EB B80400                   mov ax, 4
  1626 000006EE E9D201                   jmp .retntestReg
  1627                                  
  1628                                  ;-246   if (eqstr(SymbolUpper, "BP")) return 5;
  1629                                  
  1630                                  .testReg61:
  1631 000006F1 68[EB08]                 push testReg_13
  1632 000006F4 8D064F75                 lea  ax, [SymbolUpper]
  1633 000006F8 50                       push ax
  1634 000006F9 E8B0FC                   call eqstr
  1635 000006FC 83C404                   add  sp, 4
  1636 000006FF 08C0                     or  al, al
  1637 00000701 0F840600                 je .testReg62
  1638 00000705 B80500                   mov ax, 5
  1639 00000708 E9B801                   jmp .retntestReg
  1640                                  
  1641                                  ;-247   if (eqstr(SymbolUpper, "SI")) return 6;
  1642                                  
  1643                                  .testReg62:
  1644 0000070B 68[EE08]                 push testReg_14
  1645 0000070E 8D064F75                 lea  ax, [SymbolUpper]
  1646 00000712 50                       push ax
  1647 00000713 E896FC                   call eqstr
  1648 00000716 83C404                   add  sp, 4
  1649 00000719 08C0                     or  al, al
  1650 0000071B 0F840600                 je .testReg63
  1651 0000071F B80600                   mov ax, 6
  1652 00000722 E99E01                   jmp .retntestReg
  1653                                  
  1654                                  ;-248   if (eqstr(SymbolUpper, "DI")) return 7;
  1655                                  
  1656                                  .testReg63:
  1657 00000725 68[F108]                 push testReg_15
  1658 00000728 8D064F75                 lea  ax, [SymbolUpper]
  1659 0000072C 50                       push ax
  1660 0000072D E87CFC                   call eqstr
  1661 00000730 83C404                   add  sp, 4
  1662 00000733 08C0                     or  al, al
  1663 00000735 0F840600                 je .testReg64
  1664 00000739 B80700                   mov ax, 7
  1665 0000073C E98401                   jmp .retntestReg
  1666                                  
  1667                                  ;-249   R2Type=SEGREG;
  1668                                  
  1669                                  .testReg64:
  1670 0000073F B80400                   mov ax, 4
  1671 00000742 A2[3500]                 mov byte [R2Type], al
  1672                                  
  1673                                  ;-250   if (eqstr(SymbolUpper, "ES")) return 0;
  1674                                  
  1675 00000745 68[F408]                 push testReg_16
  1676 00000748 8D064F75                 lea  ax, [SymbolUpper]
  1677 0000074C 50                       push ax
  1678 0000074D E85CFC                   call eqstr
  1679 00000750 83C404                   add  sp, 4
  1680 00000753 08C0                     or  al, al
  1681 00000755 0F840600                 je .testReg65
  1682 00000759 B80000                   mov ax, 0
  1683 0000075C E96401                   jmp .retntestReg
  1684                                  
  1685                                  ;-251   if (eqstr(SymbolUpper, "CS")) return 1;
  1686                                  
  1687                                  .testReg65:
  1688 0000075F 68[F708]                 push testReg_17
  1689 00000762 8D064F75                 lea  ax, [SymbolUpper]
  1690 00000766 50                       push ax
  1691 00000767 E842FC                   call eqstr
  1692 0000076A 83C404                   add  sp, 4
  1693 0000076D 08C0                     or  al, al
  1694 0000076F 0F840600                 je .testReg66
  1695 00000773 B80100                   mov ax, 1
  1696 00000776 E94A01                   jmp .retntestReg
  1697                                  
  1698                                  ;-252   if (eqstr(SymbolUpper, "SS")) return 2;
  1699                                  
  1700                                  .testReg66:
  1701 00000779 68[FA08]                 push testReg_18
  1702 0000077C 8D064F75                 lea  ax, [SymbolUpper]
  1703 00000780 50                       push ax
  1704 00000781 E828FC                   call eqstr
  1705 00000784 83C404                   add  sp, 4
  1706 00000787 08C0                     or  al, al
  1707 00000789 0F840600                 je .testReg67
  1708 0000078D B80200                   mov ax, 2
  1709 00000790 E93001                   jmp .retntestReg
  1710                                  
  1711                                  ;-253   if (eqstr(SymbolUpper, "DS")) return 3;
  1712                                  
  1713                                  .testReg67:
  1714 00000793 68[FD08]                 push testReg_19
  1715 00000796 8D064F75                 lea  ax, [SymbolUpper]
  1716 0000079A 50                       push ax
  1717 0000079B E80EFC                   call eqstr
  1718 0000079E 83C404                   add  sp, 4
  1719 000007A1 08C0                     or  al, al
  1720 000007A3 0F840600                 je .testReg68
  1721 000007A7 B80300                   mov ax, 3
  1722 000007AA E91601                   jmp .retntestReg
  1723                                  
  1724                                  ;-254   if (eqstr(SymbolUpper, "FS")) return 4;
  1725                                  
  1726                                  .testReg68:
  1727 000007AD 68[0009]                 push testReg_20
  1728 000007B0 8D064F75                 lea  ax, [SymbolUpper]
  1729 000007B4 50                       push ax
  1730 000007B5 E8F4FB                   call eqstr
  1731 000007B8 83C404                   add  sp, 4
  1732 000007BB 08C0                     or  al, al
  1733 000007BD 0F840600                 je .testReg69
  1734 000007C1 B80400                   mov ax, 4
  1735 000007C4 E9FC00                   jmp .retntestReg
  1736                                  
  1737                                  ;-255   if (eqstr(SymbolUpper, "GS")) return 5;
  1738                                  
  1739                                  .testReg69:
  1740 000007C7 68[0309]                 push testReg_21
  1741 000007CA 8D064F75                 lea  ax, [SymbolUpper]
  1742 000007CE 50                       push ax
  1743 000007CF E8DAFB                   call eqstr
  1744 000007D2 83C404                   add  sp, 4
  1745 000007D5 08C0                     or  al, al
  1746 000007D7 0F840600                 je .testReg70
  1747 000007DB B80500                   mov ax, 5
  1748 000007DE E9E200                   jmp .retntestReg
  1749                                  
  1750                                  ;-256   R2Type=DWORD;
  1751                                  
  1752                                  .testReg70:
  1753 000007E1 B80300                   mov ax, 3
  1754 000007E4 A2[3500]                 mov byte [R2Type], al
  1755                                  
  1756                                  ;-257   if (eqstr(SymbolUpper, "EAX"))return 0;
  1757                                  
  1758 000007E7 68[0609]                 push testReg_22
  1759 000007EA 8D064F75                 lea  ax, [SymbolUpper]
  1760 000007EE 50                       push ax
  1761 000007EF E8BAFB                   call eqstr
  1762 000007F2 83C404                   add  sp, 4
  1763 000007F5 08C0                     or  al, al
  1764 000007F7 0F840600                 je .testReg71
  1765 000007FB B80000                   mov ax, 0
  1766 000007FE E9C200                   jmp .retntestReg
  1767                                  
  1768                                  ;-258   if (eqstr(SymbolUpper, "ECX"))return 1;
  1769                                  
  1770                                  .testReg71:
  1771 00000801 68[0A09]                 push testReg_23
  1772 00000804 8D064F75                 lea  ax, [SymbolUpper]
  1773 00000808 50                       push ax
  1774 00000809 E8A0FB                   call eqstr
  1775 0000080C 83C404                   add  sp, 4
  1776 0000080F 08C0                     or  al, al
  1777 00000811 0F840600                 je .testReg72
  1778 00000815 B80100                   mov ax, 1
  1779 00000818 E9A800                   jmp .retntestReg
  1780                                  
  1781                                  ;-259   if (eqstr(SymbolUpper, "EDX"))return 2;
  1782                                  
  1783                                  .testReg72:
  1784 0000081B 68[0E09]                 push testReg_24
  1785 0000081E 8D064F75                 lea  ax, [SymbolUpper]
  1786 00000822 50                       push ax
  1787 00000823 E886FB                   call eqstr
  1788 00000826 83C404                   add  sp, 4
  1789 00000829 08C0                     or  al, al
  1790 0000082B 0F840600                 je .testReg73
  1791 0000082F B80200                   mov ax, 2
  1792 00000832 E98E00                   jmp .retntestReg
  1793                                  
  1794                                  ;-260   if (eqstr(SymbolUpper, "EBX"))return 3;
  1795                                  
  1796                                  .testReg73:
  1797 00000835 68[1209]                 push testReg_25
  1798 00000838 8D064F75                 lea  ax, [SymbolUpper]
  1799 0000083C 50                       push ax
  1800 0000083D E86CFB                   call eqstr
  1801 00000840 83C404                   add  sp, 4
  1802 00000843 08C0                     or  al, al
  1803 00000845 0F840600                 je .testReg74
  1804 00000849 B80300                   mov ax, 3
  1805 0000084C E97400                   jmp .retntestReg
  1806                                  
  1807                                  ;-261   if (eqstr(SymbolUpper, "ESP"))return 4;
  1808                                  
  1809                                  .testReg74:
  1810 0000084F 68[1609]                 push testReg_26
  1811 00000852 8D064F75                 lea  ax, [SymbolUpper]
  1812 00000856 50                       push ax
  1813 00000857 E852FB                   call eqstr
  1814 0000085A 83C404                   add  sp, 4
  1815 0000085D 08C0                     or  al, al
  1816 0000085F 0F840600                 je .testReg75
  1817 00000863 B80400                   mov ax, 4
  1818 00000866 E95A00                   jmp .retntestReg
  1819                                  
  1820                                  ;-262   if (eqstr(SymbolUpper, "EBP"))return 5;
  1821                                  
  1822                                  .testReg75:
  1823 00000869 68[1A09]                 push testReg_27
  1824 0000086C 8D064F75                 lea  ax, [SymbolUpper]
  1825 00000870 50                       push ax
  1826 00000871 E838FB                   call eqstr
  1827 00000874 83C404                   add  sp, 4
  1828 00000877 08C0                     or  al, al
  1829 00000879 0F840600                 je .testReg76
  1830 0000087D B80500                   mov ax, 5
  1831 00000880 E94000                   jmp .retntestReg
  1832                                  
  1833                                  ;-263   if (eqstr(SymbolUpper, "ESI"))return 6;
  1834                                  
  1835                                  .testReg76:
  1836 00000883 68[1E09]                 push testReg_28
  1837 00000886 8D064F75                 lea  ax, [SymbolUpper]
  1838 0000088A 50                       push ax
  1839 0000088B E81EFB                   call eqstr
  1840 0000088E 83C404                   add  sp, 4
  1841 00000891 08C0                     or  al, al
  1842 00000893 0F840600                 je .testReg77
  1843 00000897 B80600                   mov ax, 6
  1844 0000089A E92600                   jmp .retntestReg
  1845                                  
  1846                                  ;-264   if (eqstr(SymbolUpper, "EDI"))return 7;
  1847                                  
  1848                                  .testReg77:
  1849 0000089D 68[2209]                 push testReg_29
  1850 000008A0 8D064F75                 lea  ax, [SymbolUpper]
  1851 000008A4 50                       push ax
  1852 000008A5 E804FB                   call eqstr
  1853 000008A8 83C404                   add  sp, 4
  1854 000008AB 08C0                     or  al, al
  1855 000008AD 0F840600                 je .testReg78
  1856 000008B1 B80700                   mov ax, 7
  1857 000008B4 E90C00                   jmp .retntestReg
  1858                                  
  1859                                  ;-265   R2Type=0; return 0;
  1860                                  
  1861                                  .testReg78:
  1862 000008B7 B80000                   mov ax, 0
  1863 000008BA A2[3500]                 mov byte [R2Type], al
  1864 000008BD B80000                   mov ax, 0
  1865 000008C0 E90000                   jmp .retntestReg
  1866                                  
  1867                                  ;-266 }
  1868                                  
  1869                                  
  1870                                  ;-267 
  1871                                  
  1872                                  
  1873                                  ;-268 
  1874                                  
  1875                                  
  1876                                  ;-269 //#include "OUTPUT.C"
  1877                                  
  1878                                  
  1879                                  ;-270 int printLine() {
  1880                                  
  1881                                   .retntestReg:
  1882 000008C3 C3                       ret
  1883 000008C4 414C00                  testReg_0 db "AL",0
  1884 000008C7 434C00                  testReg_1 db "CL",0
  1885 000008CA 444C00                  testReg_2 db "DL",0
  1886 000008CD 424C00                  testReg_3 db "BL",0
  1887 000008D0 414800                  testReg_4 db "AH",0
  1888 000008D3 434800                  testReg_5 db "CH",0
  1889 000008D6 444800                  testReg_6 db "DH",0
  1890 000008D9 424800                  testReg_7 db "BH",0
  1891 000008DC 415800                  testReg_8 db "AX",0
  1892 000008DF 435800                  testReg_9 db "CX",0
  1893 000008E2 445800                  testReg_10 db "DX",0
  1894 000008E5 425800                  testReg_11 db "BX",0
  1895 000008E8 535000                  testReg_12 db "SP",0
  1896 000008EB 425000                  testReg_13 db "BP",0
  1897 000008EE 534900                  testReg_14 db "SI",0
  1898 000008F1 444900                  testReg_15 db "DI",0
  1899 000008F4 455300                  testReg_16 db "ES",0
  1900 000008F7 435300                  testReg_17 db "CS",0
  1901 000008FA 535300                  testReg_18 db "SS",0
  1902 000008FD 445300                  testReg_19 db "DS",0
  1903 00000900 465300                  testReg_20 db "FS",0
  1904 00000903 475300                  testReg_21 db "GS",0
  1905 00000906 45415800                testReg_22 db "EAX",0
  1906 0000090A 45435800                testReg_23 db "ECX",0
  1907 0000090E 45445800                testReg_24 db "EDX",0
  1908 00000912 45425800                testReg_25 db "EBX",0
  1909 00000916 45535000                testReg_26 db "ESP",0
  1910 0000091A 45425000                testReg_27 db "EBP",0
  1911 0000091E 45534900                testReg_28 db "ESI",0
  1912 00000922 45444900                testReg_29 db "EDI",0
  1913                                  ENDP
  1914                                  
  1915                                  printLine: PROC
  1916                                  
  1917                                  ;-271     int i; char c;
  1918                                  
  1919                                  
  1920                                  ;-272     prs("\n");
  1921                                  
  1922                                  ;Function : printLine, Number of local variables: 2
  1923                                  ;   # type sign width addr used name   list of local variables
  1924                                  ;  200 var sign word   271 NULL i = bp-2
  1925                                  ;  201 var sign byte   271 NULL c = bp-4;
  1926 00000926 C8040000                 ENTER  4,0
  1927 0000092A 68[B809]                 push printLine_0
  1928 0000092D E8F700                   call prs
  1929 00000930 83C402                   add  sp, 2
  1930                                  
  1931                                  ;-273     printhex16(PCStart);
  1932                                  
  1933 00000933 FF36[2900]               push word [PCStart]
  1934 00000937 E8D301                   call printhex16
  1935 0000093A 83C402                   add  sp, 2
  1936                                  
  1937                                  ;-274     if (OpPrintIndex == 0) prs("               ");
  1938                                  
  1939 0000093D A1[4100]                 mov ax, [OpPrintIndex]
  1940 00000940 83F800                   cmp ax, 0
  1941 00000943 0F850C00                 jne .printLine79
  1942 00000947 68[BB09]                 push printLine_1
  1943 0000094A E8DA00                   call prs
  1944 0000094D 83C402                   add  sp, 2
  1945                                  
  1946                                  ;-275     else {
  1947                                  
  1948 00000950 E94C00                   jmp .printLine80
  1949                                  .printLine79:
  1950                                  
  1951                                  ;-276 //        prc(' ');
  1952                                  
  1953                                  
  1954                                  ;-277         i=0;
  1955                                  
  1956 00000953 B80000                   mov ax, 0
  1957 00000956 8946FE                   mov [bp-2], ax
  1958                                  
  1959                                  ;-278         do {
  1960                                  
  1961                                  .printLine81:
  1962                                  
  1963                                  ;-279             c=OpPos[i];
  1964                                  
  1965 00000959 8B5EFE                   mov bx, [bp-2]
  1966 0000095C 8A875577                 mov al, [OpPos + bx]
  1967 00000960 8846FC                   mov [bp-4], al
  1968                                  
  1969                                  ;-280             prc(' ');
  1970                                  
  1971 00000963 6A20                     push 32
  1972 00000965 E86700                   call prc
  1973 00000968 83C402                   add  sp, 2
  1974                                  
  1975                                  ;-281             printhex8a(c);
  1976                                  
  1977 0000096B 8A46FC                   mov al, byte [bp-4]
  1978 0000096E B400                     mov ah, 0
  1979 00000970 50                       push ax
  1980 00000971 E84701                   call printhex8a
  1981 00000974 83C402                   add  sp, 2
  1982                                  
  1983                                  ;-282             i++;
  1984                                  
  1985 00000977 FF46FE                   inc  word[bp-2]
  1986                                  
  1987                                  ;-283         } while (i < OpPrintIndex);
  1988                                  
  1989 0000097A 8B46FE                   mov ax, [bp-2]
  1990 0000097D 3B06[4100]               cmp ax, [OpPrintIndex]
  1991 00000981 0F8D0200                 jge .printLine82
  1992 00000985 EBD2                     jmp .printLine81
  1993                                  .printLine82:
  1994                                  
  1995                                  ;-284         while (i < OPMAXLEN) {// fill rest with blank
  1996                                  
  1997                                  .printLine83:
  1998 00000987 8B46FE                   mov ax, [bp-2]
  1999 0000098A 83F805                   cmp ax, 5
  2000 0000098D 0F8D0E00                 jge .printLine84
  2001                                  
  2002                                  ;-285             prs("   ");
  2003                                  
  2004 00000991 68[CB09]                 push printLine_2
  2005 00000994 E89000                   call prs
  2006 00000997 83C402                   add  sp, 2
  2007                                  
  2008                                  ;-286             i++;
  2009                                  
  2010 0000099A FF46FE                   inc  word[bp-2]
  2011                                  
  2012                                  ;-287         }
  2013                                  
  2014                                  
  2015                                  ;-288     }
  2016                                  
  2017 0000099D EBE8                     jmp .printLine83
  2018                                  .printLine84:
  2019                                  
  2020                                  ;-289     prc(PrintRA);
  2021                                  
  2022                                  .printLine80:
  2023 0000099F A0[4500]                 mov al, byte [PrintRA]
  2024 000009A2 B400                     mov ah, 0
  2025 000009A4 50                       push ax
  2026 000009A5 E82700                   call prc
  2027 000009A8 83C402                   add  sp, 2
  2028                                  
  2029                                  ;-290     prscomment(InputBuf);
  2030                                  
  2031 000009AB 8D068D75                 lea  ax, [InputBuf]
  2032 000009AF 50                       push ax
  2033 000009B0 E84600                   call prscomment
  2034 000009B3 83C402                   add  sp, 2
  2035                                  
  2036                                  ;-291 }
  2037                                  
  2038                                  
  2039                                  ;-292 int prc(unsigned char c) {//print char
  2040 000009B6 C9                       LEAVE
  2041 000009B7 C3                       ret
  2042 000009B8 5C6E00                  printLine_0 db "\n",0
  2043 000009BB 202020202020202020-     printLine_1 db "               ",0
  2044 000009C4 20202020202000     
  2045 000009CB 20202000                printLine_2 db "   ",0
  2046                                  ENDP
  2047                                  
  2048                                  prc: PROC
  2049                                  
  2050                                  ;-293         if ( _ c==10) {
  2051                                  
  2052                                  ;Function : prc, Number of local variables: 1
  2053                                  ;   # type sign width addr used name   list of local variables
  2054                                  ;  200 var unsg byte   292 NULL c = bp+4;
  2055 000009CF C8000000                 ENTER  0,0 ; constant expression
  2056 000009D3 807E040A                cmp byte[bp+4], 10
  2057 000009D7 0F850600                 jne .prc85
  2058                                  
  2059                                  ;-294             ax=13;
  2060                                  
  2061 000009DB B80D00                   mov  ax, 13
  2062                                  
  2063                                  ;-295             writetty();
  2064                                  
  2065 000009DE E87DF6                   call writetty
  2066                                  
  2067                                  ;-296             }
  2068                                  
  2069                                  
  2070                                  ;-297         al=c;
  2071                                  
  2072                                  .prc85:
  2073 000009E1 8A4604                   mov  al, [bp+4]
  2074                                  
  2075                                  ;-298         writetty();
  2076                                  
  2077 000009E4 E877F6                   call writetty
  2078                                  
  2079                                  ;-299     fputcR(c,lst_fd);
  2080                                  
  2081 000009E7 FF36[1800]               push word [lst_fd]
  2082 000009EB 8A4604                   mov al, byte [bp+4]
  2083 000009EE B400                     mov ah, 0
  2084 000009F0 50                       push ax
  2085 000009F1 E815F7                   call fputcR
  2086 000009F4 83C404                   add  sp, 4
  2087                                  
  2088                                  ;-300 }
  2089                                  
  2090                                  
  2091                                  ;-301 
  2092                                  
  2093                                  
  2094                                  ;-302 int prscomment(unsigned char *s) {
  2095 000009F7 C9                       LEAVE
  2096 000009F8 C3                       ret
  2097                                  ENDP
  2098                                  
  2099                                  prscomment: PROC
  2100                                  
  2101                                  ;-303     unsigned char c;
  2102                                  
  2103                                  
  2104                                  ;-304     while (*s){
  2105                                  
  2106                                  ;Function : prscomment, Number of local variables: 2
  2107                                  ;   # type sign width addr used name   list of local variables
  2108                                  ;  200 ptr unsg byte   302 NULL s = bp+4
  2109                                  ;  201 var unsg byte   303 NULL c = bp-2;
  2110 000009F9 C8020000                 ENTER  2,0
  2111                                  .prscomment86:
  2112 000009FD 8B5E04                   mov bx, [bp+4]
  2113 00000A00 8A07                     mov al, [bx]
  2114 00000A02 B400                     mov ah, 0
  2115 00000A04 08C0                     or  al, al
  2116 00000A06 0F841B00                 je .prscomment87
  2117                                  
  2118                                  ;-305         c=*s;
  2119                                  
  2120 00000A0A 8B5E04                   mov bx, [bp+4]
  2121 00000A0D 8A07                     mov al, [bx]
  2122 00000A0F B400                     mov ah, 0
  2123 00000A11 8846FE                   mov [bp-2], al
  2124                                  
  2125                                  ;-306         prc(c);
  2126                                  
  2127 00000A14 8A46FE                   mov al, byte [bp-2]
  2128 00000A17 B400                     mov ah, 0
  2129 00000A19 50                       push ax
  2130 00000A1A E8B2FF                   call prc
  2131 00000A1D 83C402                   add  sp, 2
  2132                                  
  2133                                  ;-307         s++;
  2134                                  
  2135 00000A20 FF4604                   inc  word[bp+4]
  2136                                  
  2137                                  ;-308     }
  2138                                  
  2139                                  
  2140                                  ;-309 }
  2141                                  
  2142 00000A23 EBD8                     jmp .prscomment86
  2143                                  .prscomment87:
  2144                                  
  2145                                  ;-310 int prs(unsigned char *s) {
  2146 00000A25 C9                       LEAVE
  2147 00000A26 C3                       ret
  2148                                  ENDP
  2149                                  
  2150                                  prs: PROC
  2151                                  
  2152                                  ;-311     unsigned char c;
  2153                                  
  2154                                  
  2155                                  ;-312     int com;
  2156                                  
  2157                                  
  2158                                  ;-313     com=0;
  2159                                  
  2160                                  ;Function : prs, Number of local variables: 3
  2161                                  ;   # type sign width addr used name   list of local variables
  2162                                  ;  200 ptr unsg byte   310 NULL s = bp+4
  2163                                  ;  201 var unsg byte   311 NULL c = bp-2
  2164                                  ;  202 var sign word   312 NULL com = bp-4;
  2165 00000A27 C8040000                 ENTER  4,0
  2166 00000A2B B80000                   mov ax, 0
  2167 00000A2E 8946FC                   mov [bp-4], ax
  2168                                  
  2169                                  ;-314     while (*s) {
  2170                                  
  2171                                  .prs88:
  2172 00000A31 8B5E04                   mov bx, [bp+4]
  2173 00000A34 8A07                     mov al, [bx]
  2174 00000A36 B400                     mov ah, 0
  2175 00000A38 08C0                     or  al, al
  2176 00000A3A 0F847B00                 je .prs89
  2177                                  
  2178                                  ;-315         c=*s;
  2179                                  
  2180 00000A3E 8B5E04                   mov bx, [bp+4]
  2181 00000A41 8A07                     mov al, [bx]
  2182 00000A43 B400                     mov ah, 0
  2183 00000A45 8846FE                   mov [bp-2], al
  2184                                  
  2185                                  ;-316         if (c==34) {
  2186                                  
  2187 00000A48 8A46FE                   mov al, [bp-2]
  2188 00000A4B 3C22                     cmp al, 34
  2189 00000A4D 0F851800                 jne .prs90
  2190                                  
  2191                                  ;-317             if (com) com=0;
  2192                                  
  2193 00000A51 8B46FC                   mov ax, [bp-4]
  2194 00000A54 08C0                     or  al, al
  2195 00000A56 0F840900                 je .prs91
  2196 00000A5A B80000                   mov ax, 0
  2197 00000A5D 8946FC                   mov [bp-4], ax
  2198                                  
  2199                                  ;-318                 else com=1;
  2200                                  
  2201 00000A60 E90600                   jmp .prs92
  2202                                  .prs91:
  2203 00000A63 B80100                   mov ax, 1
  2204 00000A66 8946FC                   mov [bp-4], ax
  2205                                  
  2206                                  ;-319         }
  2207                                  
  2208                                  .prs92:
  2209                                  
  2210                                  ;-320         if (c==92) {
  2211                                  
  2212                                  .prs90:
  2213 00000A69 8A46FE                   mov al, [bp-2]
  2214 00000A6C 3C5C                     cmp al, 92
  2215 00000A6E 0F853500                 jne .prs93
  2216                                  
  2217                                  ;-321             if (com==0) {
  2218                                  
  2219 00000A72 8B46FC                   mov ax, [bp-4]
  2220 00000A75 83F800                   cmp ax, 0
  2221 00000A78 0F852B00                 jne .prs94
  2222                                  
  2223                                  ;-322                 s++;
  2224                                  
  2225 00000A7C FF4604                   inc  word[bp+4]
  2226                                  
  2227                                  ;-323                 c=*s;
  2228                                  
  2229 00000A7F 8B5E04                   mov bx, [bp+4]
  2230 00000A82 8A07                     mov al, [bx]
  2231 00000A84 B400                     mov ah, 0
  2232 00000A86 8846FE                   mov [bp-2], al
  2233                                  
  2234                                  ;-324                 if (c=='n') c=10;
  2235                                  
  2236 00000A89 8A46FE                   mov al, [bp-2]
  2237 00000A8C 3C6E                     cmp al, 110
  2238 00000A8E 0F850600                 jne .prs95
  2239 00000A92 B80A00                   mov ax, 10
  2240 00000A95 8846FE                   mov [bp-2], al
  2241                                  
  2242                                  ;-325                 if (c=='t') c= 9;
  2243                                  
  2244                                  .prs95:
  2245 00000A98 8A46FE                   mov al, [bp-2]
  2246 00000A9B 3C74                     cmp al, 116
  2247 00000A9D 0F850600                 jne .prs96
  2248 00000AA1 B80900                   mov ax, 9
  2249 00000AA4 8846FE                   mov [bp-2], al
  2250                                  
  2251                                  ;-326             }
  2252                                  
  2253                                  .prs96:
  2254                                  
  2255                                  ;-327         }
  2256                                  
  2257                                  .prs94:
  2258                                  
  2259                                  ;-328         prc(c);
  2260                                  
  2261                                  .prs93:
  2262 00000AA7 8A46FE                   mov al, byte [bp-2]
  2263 00000AAA B400                     mov ah, 0
  2264 00000AAC 50                       push ax
  2265 00000AAD E81FFF                   call prc
  2266 00000AB0 83C402                   add  sp, 2
  2267                                  
  2268                                  ;-329         s++;
  2269                                  
  2270 00000AB3 FF4604                   inc  word[bp+4]
  2271                                  
  2272                                  ;-330     }
  2273                                  
  2274                                  
  2275                                  ;-331 }
  2276                                  
  2277 00000AB6 E978FF                   jmp .prs88
  2278                                  .prs89:
  2279                                  
  2280                                  ;-332 int printhex8a(unsigned char c) {
  2281 00000AB9 C9                       LEAVE
  2282 00000ABA C3                       ret
  2283                                  ENDP
  2284                                  
  2285                                  printhex8a: PROC
  2286                                  
  2287                                  ;-333     unsigned char nib;
  2288                                  
  2289                                  
  2290                                  ;-334     nib = c >> 4; printhex4(nib);
  2291                                  
  2292                                  ;Function : printhex8a, Number of local variables: 2
  2293                                  ;   # type sign width addr used name   list of local variables
  2294                                  ;  200 var unsg byte   332 NULL c = bp+4
  2295                                  ;  201 var unsg byte   333 NULL nib = bp-2;
  2296 00000ABB C8020000                 ENTER  2,0
  2297 00000ABF 8A4604                   mov al, [bp+4]
  2298 00000AC2 C0E804                   shr al, 4
  2299 00000AC5 8846FE                   mov [bp-2], al
  2300 00000AC8 8A46FE                   mov al, byte [bp-2]
  2301 00000ACB B400                     mov ah, 0
  2302 00000ACD 50                       push ax
  2303 00000ACE E81900                   call printhex4
  2304 00000AD1 83C402                   add  sp, 2
  2305                                  
  2306                                  ;-335     nib = c & 15; printhex4(nib);
  2307                                  
  2308 00000AD4 8A4604                   mov al, [bp+4]
  2309 00000AD7 240F                     and al, 15
  2310 00000AD9 8846FE                   mov [bp-2], al
  2311 00000ADC 8A46FE                   mov al, byte [bp-2]
  2312 00000ADF B400                     mov ah, 0
  2313 00000AE1 50                       push ax
  2314 00000AE2 E80500                   call printhex4
  2315 00000AE5 83C402                   add  sp, 2
  2316                                  
  2317                                  ;-336 }
  2318                                  
  2319                                  
  2320                                  ;-337 int printhex4(unsigned char c) {
  2321 00000AE8 C9                       LEAVE
  2322 00000AE9 C3                       ret
  2323                                  ENDP
  2324                                  
  2325                                  printhex4: PROC
  2326                                  
  2327                                  ;-338     c += 48;
  2328                                  
  2329                                  ;Function : printhex4, Number of local variables: 1
  2330                                  ;   # type sign width addr used name   list of local variables
  2331                                  ;  200 var unsg byte   337 NULL c = bp+4;
  2332 00000AEA C8000000                 ENTER  0,0
  2333 00000AEE 80460430                 add  byte[bp+4], 48
  2334                                  
  2335                                  ;-339     if (c > 57) c += 7;
  2336                                  
  2337 00000AF2 8A4604                   mov al, [bp+4]
  2338 00000AF5 3C39                     cmp al, 57
  2339 00000AF7 0F8E0400                 jle .printhex497
  2340 00000AFB 80460407                 add  byte[bp+4], 7
  2341                                  
  2342                                  ;-340     prc(c);
  2343                                  
  2344                                  .printhex497:
  2345 00000AFF 8A4604                   mov al, byte [bp+4]
  2346 00000B02 B400                     mov ah, 0
  2347 00000B04 50                       push ax
  2348 00000B05 E8C7FE                   call prc
  2349 00000B08 83C402                   add  sp, 2
  2350                                  
  2351                                  ;-341 }
  2352                                  
  2353                                  
  2354                                  ;-342 int printhex16(unsigned int i) {
  2355 00000B0B C9                       LEAVE
  2356 00000B0C C3                       ret
  2357                                  ENDP
  2358                                  
  2359                                  printhex16: PROC
  2360                                  
  2361                                  ;-343     unsigned int half;
  2362                                  
  2363                                  
  2364                                  ;-344     half = i >>  8; printhex8a(half);
  2365                                  
  2366                                  ;Function : printhex16, Number of local variables: 2
  2367                                  ;   # type sign width addr used name   list of local variables
  2368                                  ;  200 var unsg word   342 NULL i = bp+4
  2369                                  ;  201 var unsg word   343 NULL half = bp-2;
  2370 00000B0D C8020000                 ENTER  2,0
  2371 00000B11 8B4604                   mov ax, [bp+4]
  2372 00000B14 C1E808                   shr ax, 8
  2373 00000B17 8946FE                   mov [bp-2], ax
  2374 00000B1A FF76FE                   push word [bp-2]
  2375 00000B1D E89BFF                   call printhex8a
  2376 00000B20 83C402                   add  sp, 2
  2377                                  
  2378                                  ;-345     half = i & 255; printhex8a(half);
  2379                                  
  2380 00000B23 8B4604                   mov ax, [bp+4]
  2381 00000B26 25FF00                   and ax, 255
  2382 00000B29 8946FE                   mov [bp-2], ax
  2383 00000B2C FF76FE                   push word [bp-2]
  2384 00000B2F E889FF                   call printhex8a
  2385 00000B32 83C402                   add  sp, 2
  2386                                  
  2387                                  ;-346 }
  2388                                  
  2389                                  
  2390                                  ;-347 int printIntU(unsigned int n) {
  2391 00000B35 C9                       LEAVE
  2392 00000B36 C3                       ret
  2393                                  ENDP
  2394                                  
  2395                                  printIntU: PROC
  2396                                  
  2397                                  ;-348     unsigned int e;
  2398                                  
  2399                                  
  2400                                  ;-349     if ( _ n >= 10) {
  2401                                  
  2402                                  ;Function : printIntU, Number of local variables: 2
  2403                                  ;   # type sign width addr used name   list of local variables
  2404                                  ;  200 var unsg word   347 NULL n = bp+4
  2405                                  ;  201 var unsg word   348 NULL e = bp-2;
  2406 00000B37 C8020000                 ENTER  2,0 ; constant expression
  2407 00000B3B 837E040A                cmp word[bp+4], 10 ;unsigned : 0
  2408 00000B3F 0F821700                 jb  .printIntU98
  2409                                  
  2410                                  ;-350         e=n/10; //DIV
  2411                                  
  2412 00000B43 8B4604                   mov ax, [bp+4]
  2413 00000B46 BB0A00                   mov bx, 10
  2414 00000B49 BA0000                   mov dx, 0
  2415 00000B4C F7F3                     div bx
  2416 00000B4E 8946FE                   mov [bp-2], ax
  2417                                  
  2418                                  ;-351         printIntU(e);
  2419                                  
  2420 00000B51 FF76FE                   push word [bp-2]
  2421 00000B54 E8E0FF                   call printIntU
  2422 00000B57 83C402                   add  sp, 2
  2423                                  
  2424                                  ;-352     }
  2425                                  
  2426                                  
  2427                                  ;-353     n = n % 10; //unsigned mod
  2428                                  
  2429                                  .printIntU98:
  2430 00000B5A 8B4604                   mov ax, [bp+4]
  2431 00000B5D BB0A00                   mov bx, 10
  2432 00000B60 BA0000                   mov dx, 0
  2433 00000B63 F7F3                     div bx
  2434 00000B65 89D0                     mov ax, dx
  2435 00000B67 894604                   mov [bp+4], ax
  2436                                  
  2437                                  ;-354     n += '0';
  2438                                  
  2439 00000B6A 83460430                 add  word[bp+4], 48
  2440                                  
  2441                                  ;-355     prc(n);
  2442                                  
  2443 00000B6E FF7604                   push word [bp+4]
  2444 00000B71 E85BFE                   call prc
  2445 00000B74 83C402                   add  sp, 2
  2446                                  
  2447                                  ;-356 }
  2448                                  
  2449                                  
  2450                                  ;-357 
  2451                                  
  2452                                  
  2453                                  ;-358 int error1(char *s) {
  2454 00000B77 C9                       LEAVE
  2455 00000B78 C3                       ret
  2456                                  ENDP
  2457                                  
  2458                                  error1: PROC
  2459                                  
  2460                                  ;-359     ErrorCount++;
  2461                                  
  2462                                  ;Function : error1, Number of local variables: 1
  2463                                  ;   # type sign width addr used name   list of local variables
  2464                                  ;  200 ptr sign byte   358 NULL s = bp+4;
  2465 00000B79 C8000000                 ENTER  0,0
  2466 00000B7D FF06[1E00]               inc  word[ErrorCount]
  2467                                  
  2468                                  ;-360     prs("\n;***** next line ERROR: ");
  2469                                  
  2470 00000B81 68[A90B]                 push error1_0
  2471 00000B84 E8A0FE                   call prs
  2472 00000B87 83C402                   add  sp, 2
  2473                                  
  2474                                  ;-361     prs(s);
  2475                                  
  2476 00000B8A FF7604                   push word [bp+4]
  2477 00000B8D E897FE                   call prs
  2478 00000B90 83C402                   add  sp, 2
  2479                                  
  2480                                  ;-362     prs(", Symbol: ");
  2481                                  
  2482 00000B93 68[C40B]                 push error1_1
  2483 00000B96 E88EFE                   call prs
  2484 00000B99 83C402                   add  sp, 2
  2485                                  
  2486                                  ;-363     prs(Symbol);
  2487                                  
  2488 00000B9C 8D063075                 lea  ax, [Symbol]
  2489 00000BA0 50                       push ax
  2490 00000BA1 E883FE                   call prs
  2491 00000BA4 83C402                   add  sp, 2
  2492                                  
  2493                                  ;-364 }
  2494                                  
  2495                                  
  2496                                  ;-365 int errorexit(char *s) {
  2497 00000BA7 C9                       LEAVE
  2498 00000BA8 C3                       ret
  2499 00000BA9 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  2500 00000BB2 6E657874206C696E65-
  2501 00000BBB 204552524F523A2000 
  2502 00000BC4 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  2503 00000BCD 2000               
  2504                                  ENDP
  2505                                  
  2506                                  errorexit: PROC
  2507                                  
  2508                                  ;-366     error1(s);
  2509                                  
  2510                                  ;Function : errorexit, Number of local variables: 1
  2511                                  ;   # type sign width addr used name   list of local variables
  2512                                  ;  200 ptr sign byte   365 NULL s = bp+4;
  2513 00000BCF C8000000                 ENTER  0,0
  2514 00000BD3 FF7604                   push word [bp+4]
  2515 00000BD6 E8A0FF                   call error1
  2516 00000BD9 83C402                   add  sp, 2
  2517                                  
  2518                                  ;-367     epilog();
  2519                                  
  2520 00000BDC E84716                   call epilog
  2521                                  
  2522                                  ;-368     end1(1);
  2523                                  
  2524 00000BDF 6A01                     push 1
  2525 00000BE1 E82E17                   call end1
  2526 00000BE4 83C402                   add  sp, 2
  2527                                  
  2528                                  ;-369 }
  2529                                  
  2530                                  
  2531                                  ;-370 int notfounderror(){
  2532 00000BE7 C9                       LEAVE
  2533 00000BE8 C3                       ret
  2534                                  ENDP
  2535                                  
  2536                                  notfounderror: PROC
  2537                                  
  2538                                  ;-371     ErrorCount++;
  2539                                  
  2540 00000BE9 FF06[1E00]               inc  word[ErrorCount]
  2541                                  
  2542                                  ;-372     prs("\n;***** ERROR: label not found: ");
  2543                                  
  2544 00000BED 68[0B0C]                 push notfounderror_0
  2545 00000BF0 E834FE                   call prs
  2546 00000BF3 83C402                   add  sp, 2
  2547                                  
  2548                                  ;-373     prs(Symbol);
  2549                                  
  2550 00000BF6 8D063075                 lea  ax, [Symbol]
  2551 00000BFA 50                       push ax
  2552 00000BFB E829FE                   call prs
  2553 00000BFE 83C402                   add  sp, 2
  2554                                  
  2555                                  ;-374     prs(" ");
  2556                                  
  2557 00000C01 68[2D0C]                 push notfounderror_1
  2558 00000C04 E820FE                   call prs
  2559 00000C07 83C402                   add  sp, 2
  2560                                  
  2561                                  ;-375 }
  2562                                  
  2563                                  
  2564                                  ;-376 int allowederror() {error1("not allowed here"); }
  2565                                  
  2566 00000C0A C3                       ret
  2567 00000C0B 5C6E3B2A2A2A2A2A20-     notfounderror_0 db "\n;***** ERROR: label not found: ",0
  2568 00000C14 4552524F523A206C61-
  2569 00000C1D 62656C206E6F742066-
  2570 00000C26 6F756E643A2000     
  2571 00000C2D 2000                    notfounderror_1 db " ",0
  2572                                  ENDP
  2573                                  
  2574                                  allowederror: PROC
  2575 00000C2F 68[390C]                 push allowederror_0
  2576 00000C32 E844FF                   call error1
  2577 00000C35 83C402                   add  sp, 2
  2578                                  
  2579                                  ;-377 int addrerror()    {error1("address missing");}
  2580                                  
  2581 00000C38 C3                       ret
  2582 00000C39 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  2583 00000C42 6564206865726500   
  2584                                  ENDP
  2585                                  
  2586                                  addrerror: PROC
  2587 00000C4A 68[540C]                 push addrerror_0
  2588 00000C4D E829FF                   call error1
  2589 00000C50 83C402                   add  sp, 2
  2590                                  
  2591                                  ;-378 int immeerror()    {error1("immediate not allowed here");}
  2592                                  
  2593 00000C53 C3                       ret
  2594 00000C54 61646472657373206D-     addrerror_0 db "address missing",0
  2595 00000C5D 697373696E6700     
  2596                                  ENDP
  2597                                  
  2598                                  immeerror: PROC
  2599 00000C64 68[6E0C]                 push immeerror_0
  2600 00000C67 E80FFF                   call error1
  2601 00000C6A 83C402                   add  sp, 2
  2602                                  
  2603                                  ;-379 int implerror()    {error1("not implemented");}
  2604                                  
  2605 00000C6D C3                       ret
  2606 00000C6E 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  2607 00000C77 206E6F7420616C6C6F-
  2608 00000C80 776564206865726500 
  2609                                  ENDP
  2610                                  
  2611                                  implerror: PROC
  2612 00000C89 68[930C]                 push implerror_0
  2613 00000C8C E8EAFE                   call error1
  2614 00000C8F 83C402                   add  sp, 2
  2615                                  
  2616                                  ;-380 int indexerror()   {error1("invalid index register");}
  2617                                  
  2618 00000C92 C3                       ret
  2619 00000C93 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  2620 00000C9C 6D656E74656400     
  2621                                  ENDP
  2622                                  
  2623                                  indexerror: PROC
  2624 00000CA3 68[AD0C]                 push indexerror_0
  2625 00000CA6 E8D0FE                   call error1
  2626 00000CA9 83C402                   add  sp, 2
  2627                                  
  2628                                  ;-381 int invaloperror() {error1("invalid or no operands");}
  2629                                  
  2630 00000CAC C3                       ret
  2631 00000CAD 696E76616C69642069-     indexerror_0 db "invalid index register",0
  2632 00000CB6 6E6465782072656769-
  2633 00000CBF 7374657200         
  2634                                  ENDP
  2635                                  
  2636                                  invaloperror: PROC
  2637 00000CC4 68[CE0C]                 push invaloperror_0
  2638 00000CC7 E8AFFE                   call error1
  2639 00000CCA 83C402                   add  sp, 2
  2640                                  
  2641                                  ;-382 int numbererror()  {error1("number expected");}
  2642                                  
  2643 00000CCD C3                       ret
  2644 00000CCE 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  2645 00000CD7 72206E6F206F706572-
  2646 00000CE0 616E647300         
  2647                                  ENDP
  2648                                  
  2649                                  numbererror: PROC
  2650 00000CE5 68[EF0C]                 push numbererror_0
  2651 00000CE8 E88EFE                   call error1
  2652 00000CEB 83C402                   add  sp, 2
  2653                                  
  2654                                  ;-383 int regmemerror()  {error1("only register or memory allowed");}
  2655                                  
  2656 00000CEE C3                       ret
  2657 00000CEF 6E756D626572206578-     numbererror_0 db "number expected",0
  2658 00000CF8 70656374656400     
  2659                                  ENDP
  2660                                  
  2661                                  regmemerror: PROC
  2662 00000CFF 68[090D]                 push regmemerror_0
  2663 00000D02 E874FE                   call error1
  2664 00000D05 83C402                   add  sp, 2
  2665                                  
  2666                                  ;-384 int reg16error()   {error1("only reg16, no segreg allowed");}
  2667                                  
  2668 00000D08 C3                       ret
  2669 00000D09 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  2670 00000D12 73746572206F72206D-
  2671 00000D1B 656D6F727920616C6C-
  2672 00000D24 6F77656400         
  2673                                  ENDP
  2674                                  
  2675                                  reg16error: PROC
  2676 00000D29 68[330D]                 push reg16error_0
  2677 00000D2C E84AFE                   call error1
  2678 00000D2F 83C402                   add  sp, 2
  2679                                  
  2680                                  ;-385 int segregerror()  {error1("segment register not allowed");}
  2681                                  
  2682 00000D32 C3                       ret
  2683 00000D33 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  2684 00000D3C 362C206E6F20736567-
  2685 00000D45 72656720616C6C6F77-
  2686 00000D4E 656400             
  2687                                  ENDP
  2688                                  
  2689                                  segregerror: PROC
  2690 00000D51 68[5B0D]                 push segregerror_0
  2691 00000D54 E822FE                   call error1
  2692 00000D57 83C402                   add  sp, 2
  2693                                  
  2694                                  ;-386 int syntaxerror()  {error1("syntax");}
  2695                                  
  2696 00000D5A C3                       ret
  2697 00000D5B 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  2698 00000D64 65676973746572206E-
  2699 00000D6D 6F7420616C6C6F7765-
  2700 00000D76 6400               
  2701                                  ENDP
  2702                                  
  2703                                  syntaxerror: PROC
  2704 00000D78 68[820D]                 push syntaxerror_0
  2705 00000D7B E8FBFD                   call error1
  2706 00000D7E 83C402                   add  sp, 2
  2707                                  
  2708                                  ;-387 
  2709                                  
  2710                                  
  2711                                  ;-388 int addrexit()     {errorexit("illegal address");}
  2712                                  
  2713 00000D81 C3                       ret
  2714 00000D82 73796E74617800          syntaxerror_0 db "syntax",0
  2715                                  ENDP
  2716                                  
  2717                                  addrexit: PROC
  2718 00000D89 68[930D]                 push addrexit_0
  2719 00000D8C E840FE                   call errorexit
  2720 00000D8F 83C402                   add  sp, 2
  2721                                  
  2722                                  ;-389 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  2723                                  
  2724 00000D92 C3                       ret
  2725 00000D93 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  2726 00000D9C 64647265737300     
  2727                                  ENDP
  2728                                  
  2729                                  dataexit: PROC
  2730 00000DA3 68[AD0D]                 push dataexit_0
  2731 00000DA6 E826FE                   call errorexit
  2732 00000DA9 83C402                   add  sp, 2
  2733                                  
  2734                                  ;-390 int internexit()   {errorexit("intern compiler error");}
  2735                                  
  2736 00000DAC C3                       ret
  2737 00000DAD 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  2738 00000DB6 6F7220524553422C57-
  2739 00000DBF 2C4420657870656374-
  2740 00000DC8 656400             
  2741                                  ENDP
  2742                                  
  2743                                  internexit: PROC
  2744 00000DCB 68[D50D]                 push internexit_0
  2745 00000DCE E8FEFD                   call errorexit
  2746 00000DD1 83C402                   add  sp, 2
  2747                                  
  2748                                  ;-391 
  2749                                  
  2750                                  
  2751                                  ;-392 
  2752                                  
  2753                                  
  2754                                  ;-393 //#include "OPTABL.C"
  2755                                  
  2756                                  
  2757                                  ;-394 char I_START=0xF1;
  2758                                  
  2759 00000DD4 C3                       ret
  2760 00000DD5 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  2761 00000DDE 6D70696C6572206572-
  2762 00000DE7 726F7200           
  2763                                  ENDP
  2764 00000DEB F1                      I_START db 241
  2765                                  
  2766                                  ;-395 //OpName, 0, CodeType, OpCode1-n, F1h
  2767                                  
  2768                                  
  2769                                  ;-396 //  1:   1 byte opcode
  2770                                  
  2771                                  
  2772                                  ;-397 char I_PUSHA[]={'P','U','S','H','A',0,1,0x60,0xF1, 'P','O','P','A',0,    1,0x61,0xF1};
  2773                                  
  2774 00000DEC 5055534841000160F1-     I_PUSHA db 80,85,83,72,65,0,1,96,241,80,79,80,65,0,1,97,241
  2775 00000DF5 504F5041000161F1   
  2776                                  
  2777                                  ;-398 char I_NOP[]=  {'N','O','P',0,        1,0x90,0xF1, 'C','B','W',0,        1,0x98,0xF1};
  2778                                  
  2779 00000DFD 4E4F50000190F14342-     I_NOP db 78,79,80,0,1,144,241,67,66,87,0,1,152,241
  2780 00000E06 57000198F1         
  2781                                  
  2782                                  ;-399 char I_CWDE[]= {'C','W','D','E',0,    1,0x98,0xF1, 'C','W','D',0,        1,0x99,0xF1};
  2783                                  
  2784 00000E0B 43574445000198F143-     I_CWDE db 67,87,68,69,0,1,152,241,67,87,68,0,1,153,241
  2785 00000E14 5744000199F1       
  2786                                  
  2787                                  ;-400 char I_CDQ[]=  {'C','D','Q',0,        1,0x99,0xF1, 'W','A','I','T',0,    1,0x9B,0xF1};
  2788                                  
  2789 00000E1A 434451000199F15741-     I_CDQ db 67,68,81,0,1,153,241,87,65,73,84,0,1,155,241
  2790 00000E23 495400019BF1       
  2791                                  
  2792                                  ;-401 char I_PUSHF[]={'P','U','S','H','F',0,1,0x9C,0xF1, 'P','O','P','F',0,    1,0x9D,0xF1};
  2793                                  
  2794 00000E29 505553484600019CF1-     I_PUSHF db 80,85,83,72,70,0,1,156,241,80,79,80,70,0,1,157,241
  2795 00000E32 504F504600019DF1   
  2796                                  
  2797                                  ;-402 char I_SAHF[]= {'S','A','H','F',0,    1,0x9E,0xF1, 'L','A','H','F',0,    1,0x9F,0xF1};
  2798                                  
  2799 00000E3A 5341484600019EF14C-     I_SAHF db 83,65,72,70,0,1,158,241,76,65,72,70,0,1,159,241
  2800 00000E43 41484600019FF1     
  2801                                  
  2802                                  ;-403 char I_MOVSB[]={'M','O','V','S','B',0,1,0xA4,0xF1, 'M','O','V','S','W',0,1,0xA5,0xF1};
  2803                                  
  2804 00000E4A 4D4F5653420001A4F1-     I_MOVSB db 77,79,86,83,66,0,1,164,241,77,79,86,83,87,0,1,165,241
  2805 00000E53 4D4F5653570001A5F1 
  2806                                  
  2807                                  ;-404 char I_CMPSB[]={'C','M','P','S','B',0,1,0xA6,0xF1, 'C','M','P','S','W',0,1,0xA7,0xF1};
  2808                                  
  2809 00000E5C 434D5053420001A6F1-     I_CMPSB db 67,77,80,83,66,0,1,166,241,67,77,80,83,87,0,1,167,241
  2810 00000E65 434D5053570001A7F1 
  2811                                  
  2812                                  ;-405 char I_STOSB[]={'S','T','O','S','B',0,1,0xAA,0xF1, 'S','T','O','S','W',0,1,0xAB,0xF1};
  2813                                  
  2814 00000E6E 53544F53420001AAF1-     I_STOSB db 83,84,79,83,66,0,1,170,241,83,84,79,83,87,0,1,171,241
  2815 00000E77 53544F53570001ABF1 
  2816                                  
  2817                                  ;-406 char I_LODSB[]={'L','O','D','S','B',0,1,0xAC,0xF1, 'L','O','D','S','W',0,1,0xAD,0xF1};
  2818                                  
  2819 00000E80 4C4F4453420001ACF1-     I_LODSB db 76,79,68,83,66,0,1,172,241,76,79,68,83,87,0,1,173,241
  2820 00000E89 4C4F4453570001ADF1 
  2821                                  
  2822                                  ;-407 char I_SCASB[]={'S','C','A','S','B',0,1,0xAE,0xF1, 'S','C','A','S','W',0,1,0xAF,0xF1};
  2823                                  
  2824 00000E92 53434153420001AEF1-     I_SCASB db 83,67,65,83,66,0,1,174,241,83,67,65,83,87,0,1,175,241
  2825 00000E9B 53434153570001AFF1 
  2826                                  
  2827                                  ;-408 char I_LEAVE[]={'L','E','A','V','E',0,1,0xC9,0xF1, 'I','N','T','3',0,    1,0xCC,0xF1};
  2828                                  
  2829 00000EA4 4C454156450001C9F1-     I_LEAVE db 76,69,65,86,69,0,1,201,241,73,78,84,51,0,1,204,241
  2830 00000EAD 494E54330001CCF1   
  2831                                  
  2832                                  ;-409 char I_INTO[]= {'I','N','T','O',0,    1,0xCE,0xF1, 'I','R','E','T',0,    1,0xCF,0xF1};
  2833                                  
  2834 00000EB5 494E544F0001CEF149-     I_INTO db 73,78,84,79,0,1,206,241,73,82,69,84,0,1,207,241
  2835 00000EBE 5245540001CFF1     
  2836                                  
  2837                                  ;-410 char I_XLAT[]= {'X','L','A','T',0,    1,0xD7,0xF1, 'L','O','C','K',0,    1,0xF0,0xF1};
  2838                                  
  2839 00000EC5 584C41540001D7F14C-     I_XLAT db 88,76,65,84,0,1,215,241,76,79,67,75,0,1,240,241
  2840 00000ECE 4F434B0001F0F1     
  2841                                  
  2842                                  ;-411 char I_REPNE[]={'R','E','P','N','E',0,1,0xF2,0xF1, 'R','E','P','N','Z',0,1,0xF2,0xF1};
  2843                                  
  2844 00000ED5 5245504E450001F2F1-     I_REPNE db 82,69,80,78,69,0,1,242,241,82,69,80,78,90,0,1,242,241
  2845 00000EDE 5245504E5A0001F2F1 
  2846                                  
  2847                                  ;-412 char I_REPE[]= {'R','E','P','E',0,    1,0xF3,0xF1, 'R','E','P','Z',0,    1,0xF3,0xF1};
  2848                                  
  2849 00000EE7 524550450001F3F152-     I_REPE db 82,69,80,69,0,1,243,241,82,69,80,90,0,1,243,241
  2850 00000EF0 45505A0001F3F1     
  2851                                  
  2852                                  ;-413 char I_HLT[]=  {'H','L','T',0,        1,0xF4,0xF1, 'C','L','C',0,        1,0xF8,0xF1};
  2853                                  
  2854 00000EF7 484C540001F4F1434C-     I_HLT db 72,76,84,0,1,244,241,67,76,67,0,1,248,241
  2855 00000F00 430001F8F1         
  2856                                  
  2857                                  ;-414 char I_STC[]=  {'S','T','C',0,        1,0xF9,0xF1, 'C','L','I',0,        1,0xFA,0xF1};
  2858                                  
  2859 00000F05 5354430001F9F1434C-     I_STC db 83,84,67,0,1,249,241,67,76,73,0,1,250,241
  2860 00000F0E 490001FAF1         
  2861                                  
  2862                                  ;-415 char I_STI[]=  {'S','T','I',0,        1,0xFB,0xF1, 'C','L','D',0,        1,0xFC,0xF1};
  2863                                  
  2864 00000F13 5354490001FBF1434C-     I_STI db 83,84,73,0,1,251,241,67,76,68,0,1,252,241
  2865 00000F1C 440001FCF1         
  2866                                  
  2867                                  ;-416 char I_STD[]=  {'S','T','D',0,        1,0xFD,0xF1};
  2868                                  
  2869 00000F21 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
  2870                                  
  2871                                  ;-417 // 2: mem reg 16 bit
  2872                                  
  2873                                  
  2874                                  ;-418 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
  2875                                  
  2876 00000F28 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
  2877                                  
  2878                                  ;-419 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
  2879                                  
  2880 00000F31 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
  2881                                  
  2882                                  ;-420 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
  2883                                  
  2884 00000F3A 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
  2885                                  
  2886                                  ;-421 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
  2887                                  
  2888 00000F42 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
  2889                                  
  2890                                  ;-422 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
  2891                                  
  2892 00000F4A 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
  2893                                  
  2894                                  ;-423 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
  2895                                  
  2896 00000F52 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
  2897                                  
  2898                                  ;-424 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
  2899                                  
  2900 00000F5B 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
  2901                                  
  2902                                  ;-425 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
  2903                                  
  2904 00000F63 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
  2905                                  
  2906                                  ;-426 //  3: les, lda, lea, lss, lfs, lgs
  2907                                  
  2908                                  
  2909                                  ;-427 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
  2910                                  
  2911 00000F6C 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
  2912                                  
  2913                                  ;-428 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
  2914                                  
  2915 00000F73 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
  2916                                  
  2917                                  ;-429 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
  2918                                  
  2919 00000F7A 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
  2920                                  
  2921                                  ;-430 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
  2922                                  
  2923 00000F81 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
  2924                                  
  2925                                  ;-431 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
  2926                                  
  2927 00000F89 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
  2928                                  
  2929                                  ;-432 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
  2930                                  
  2931 00000F91 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
  2932                                  
  2933                                  ;-433 //  4: acc,imm  reg,imm  index,reg
  2934                                  
  2935                                  
  2936                                  ;-434 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
  2937                                  
  2938 00000F99 414444000400F1          I_ADD db 65,68,68,0,4,0,241
  2939                                  
  2940                                  ;-435 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
  2941                                  
  2942 00000FA0 4F52000401F1            I_OR db 79,82,0,4,1,241
  2943                                  
  2944                                  ;-436 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
  2945                                  
  2946 00000FA6 414443000402F1          I_ADC db 65,68,67,0,4,2,241
  2947                                  
  2948                                  ;-437 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
  2949                                  
  2950 00000FAD 534242000403F1          I_SBB db 83,66,66,0,4,3,241
  2951                                  
  2952                                  ;-438 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
  2953                                  
  2954 00000FB4 414E44000404F1          I_AND db 65,78,68,0,4,4,241
  2955                                  
  2956                                  ;-439 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
  2957                                  
  2958 00000FBB 535542000405F1          I_SUB db 83,85,66,0,4,5,241
  2959                                  
  2960                                  ;-440 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
  2961                                  
  2962 00000FC2 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
  2963                                  
  2964                                  ;-441 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
  2965                                  
  2966 00000FC9 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
  2967                                  
  2968                                  ;-442 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
  2969                                  
  2970 00000FD0 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
  2971 00000FD9 00F1               
  2972                                  
  2973                                  ;-443 //  5: mov
  2974                                  
  2975                                  
  2976                                  ;-444 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
  2977                                  
  2978 00000FDB 4D4F560005F1            I_MOV db 77,79,86,0,5,241
  2979                                  
  2980                                  ;-445 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
  2981                                  
  2982 00000FE1 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
  2983                                  
  2984                                  ;-446 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
  2985                                  
  2986 00000FEA 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
  2987                                  
  2988                                  ;-447 //  6: single byte relative jump
  2989                                  
  2990                                  
  2991                                  ;-448 char I_JO []=  {'J','O',0,     6, 0,0xF1};
  2992                                  
  2993 00000FF3 4A4F000600F1            I_JO db 74,79,0,6,0,241
  2994                                  
  2995                                  ;-449 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};
  2996                                  
  2997 00000FF9 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
  2998                                  
  2999                                  ;-450 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};
  3000                                  
  3001 00001000 4A42000602F14A4300-     I_JB db 74,66,0,6,2,241,74,67,0,6,2,241
  3002 00001009 0602F1             
  3003                                  
  3004                                  ;-451 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};
  3005                                  
  3006 0000100C 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
  3007                                  
  3008                                  ;-452 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};
  3009                                  
  3010 00001013 4A4145000603F14A4E-     I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241
  3011 0000101C 43000603F1         
  3012                                  
  3013                                  ;-453 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};
  3014                                  
  3015 00001021 4A45000604F14A5A00-     I_JE db 74,69,0,6,4,241,74,90,0,6,4,241
  3016 0000102A 0604F1             
  3017                                  
  3018                                  ;-454 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};
  3019                                  
  3020 0000102D 4A4E45000605F14A4E-     I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241
  3021 00001036 5A000605F1         
  3022                                  
  3023                                  ;-455 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};
  3024                                  
  3025 0000103B 4A4245000606F14A4E-     I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241
  3026 00001044 41000606F1         
  3027                                  
  3028                                  ;-456 char I_JA []=  {'J','A',0,     6, 7,0xF1};
  3029                                  
  3030 00001049 4A41000607F1            I_JA db 74,65,0,6,7,241
  3031                                  
  3032                                  ;-457 char I_JS []=  {'J','S',0,     6, 8,0xF1};
  3033                                  
  3034 0000104F 4A53000608F1            I_JS db 74,83,0,6,8,241
  3035                                  
  3036                                  ;-458 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};
  3037                                  
  3038 00001055 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
  3039                                  
  3040                                  ;-459 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};
  3041                                  
  3042 0000105C 4A5000060AF14A5045-     I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241
  3043 00001065 00060AF1           
  3044                                  
  3045                                  ;-460 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};
  3046                                  
  3047 00001069 4A4E5000060BF14A50-     I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241
  3048 00001072 4F00060BF1         
  3049                                  
  3050                                  ;-461 char I_JL []=  {'J','L',0,     6,12,0xF1};
  3051                                  
  3052 00001077 4A4C00060CF1            I_JL db 74,76,0,6,12,241
  3053                                  
  3054                                  ;-462 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};
  3055                                  
  3056 0000107D 4A4E4C00060DF14A47-     I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241
  3057 00001086 4500060DF1         
  3058                                  
  3059                                  ;-463 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};
  3060                                  
  3061 0000108B 4A4C4500060EF14A4E-     I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241
  3062 00001094 4700060EF1         
  3063                                  
  3064                                  ;-464 char I_JG []=  {'J','G',0,     6,15,0xF1};
  3065                                  
  3066 00001099 4A4700060FF1            I_JG db 74,71,0,6,15,241
  3067                                  
  3068                                  ;-465 //  7: jmp, call
  3069                                  
  3070                                  
  3071                                  ;-466 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
  3072                                  
  3073 0000109F 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
  3074                                  
  3075                                  ;-467 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
  3076                                  
  3077 000010A7 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
  3078                                  
  3079                                  ;-468 //  8: ret
  3080                                  
  3081                                  
  3082                                  ;-469 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
  3083                                  
  3084 000010B0 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
  3085                                  
  3086                                  ;-470 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
  3087                                  
  3088 000010B8 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
  3089                                  
  3090                                  ;-471 //  9: seg, r/m
  3091                                  
  3092                                  
  3093                                  ;-472 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
  3094                                  
  3095 000010C1 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
  3096 000010CA 06F1               
  3097                                  
  3098                                  ;-473 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
  3099                                  
  3100 000010CC 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
  3101 000010D5 F1                 
  3102                                  
  3103                                  ;-474 //  11: shift, rotates
  3104                                  
  3105                                  
  3106                                  ;-475 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};
  3107                                  
  3108 000010D6 524F4C000B00F1524F-     I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241
  3109 000010DF 52000B01F1         
  3110                                  
  3111                                  ;-476 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};
  3112                                  
  3113 000010E4 52434C000B02F15243-     I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241
  3114 000010ED 52000B03F1         
  3115                                  
  3116                                  ;-477 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};
  3117                                  
  3118 000010F2 53484C000B04F15341-     I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241
  3119 000010FB 4C000B04F1         
  3120                                  
  3121                                  ;-478 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};
  3122                                  
  3123 00001100 534852000B05F15341-     I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241
  3124 00001109 52000B07F1         
  3125                                  
  3126                                  ;-479 //  12: int
  3127                                  
  3128                                  
  3129                                  ;-480 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
  3130                                  
  3131 0000110E 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
  3132                                  
  3133                                  ;-481 //  14: in/out
  3134                                  
  3135                                  
  3136                                  ;-482 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
  3137                                  
  3138 00001116 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
  3139                                  
  3140                                  ;-483 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
  3141                                  
  3142 0000111D 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
  3143                                  
  3144                                  ;-484 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
  3145                                  
  3146 00001125 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
  3147                                  
  3148                                  ;-485 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
  3149                                  
  3150 0000112D 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
  3151                                  
  3152                                  ;-486 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
  3153                                  
  3154 00001135 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
  3155                                  
  3156                                  ;-487 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
  3157                                  
  3158 0000113D 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
  3159                                  
  3160                                  ;-488 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
  3161                                  
  3162 00001145 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
  3163                                  
  3164                                  ;-489 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
  3165                                  
  3166 0000114D 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
  3167                                  
  3168                                  ;-490 //  15: xchg
  3169                                  
  3170                                  
  3171                                  ;-491 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
  3172                                  
  3173 00001155 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
  3174                                  
  3175                                  ;-492 //  16: loop, jcxz
  3176                                  
  3177                                  
  3178                                  ;-493 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
  3179                                  
  3180 0000115E 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
  3181 00001167 F1                 
  3182                                  
  3183                                  ;-494 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
  3184                                  
  3185 00001168 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
  3186 00001171 F1                 
  3187                                  
  3188                                  ;-495 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
  3189                                  
  3190 00001172 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
  3191                                  
  3192                                  ;-496 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
  3193                                  
  3194 0000117B 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
  3195                                  
  3196                                  ;-497 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
  3197                                  
  3198 00001184 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
  3199                                  
  3200                                  ;-498 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
  3201                                  
  3202 0000118C 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
  3203                                  
  3204                                  ;-499 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
  3205                                  
  3206 00001194 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
  3207                                  
  3208                                  ;-500 //  30: enter
  3209                                  
  3210                                  
  3211                                  ;-501 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
  3212                                  
  3213 0000119D 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
  3214                                  
  3215                                  ;-502 // 100: directives
  3216                                  
  3217                                  
  3218                                  ;-503 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
  3219                                  
  3220 000011A5 4F52470065F1            I_ORG db 79,82,71,0,101,241
  3221                                  
  3222                                  ;-504 // section, segment .TEXT .DATA .BSS
  3223                                  
  3224                                  
  3225                                  ;-505 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
  3226                                  
  3227 000011AB 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
  3228 000011B4 F1                 
  3229                                  
  3230                                  ;-506 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
  3231                                  
  3232 000011B5 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
  3233 000011BE F1                 
  3234                                  
  3235                                  ;-507 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
  3236                                  
  3237 000011BF 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
  3238 000011C8 6EF1               
  3239                                  
  3240                                  ;-508 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
  3241                                  
  3242 000011CA 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
  3243                                  
  3244                                  ;-509 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
  3245                                  
  3246 000011D1 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
  3247                                  
  3248                                  ;-510 char I_DB[]=   {'D','B',0,            200,        0xF1};
  3249                                  
  3250 000011D8 444200C8F1              I_DB db 68,66,0,200,241
  3251                                  
  3252                                  ;-511 char I_DW[]=   {'D','W',0,            201,        0xF1};
  3253                                  
  3254 000011DD 445700C9F1              I_DW db 68,87,0,201,241
  3255                                  
  3256                                  ;-512 char I_DD[]=   {'D','D',0,            202,        0xF1};
  3257                                  
  3258 000011E2 444400CAF1              I_DD db 68,68,0,202,241
  3259                                  
  3260                                  ;-513 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
  3261                                  
  3262 000011E7 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
  3263                                  
  3264                                  ;-514 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
  3265                                  
  3266 000011EE 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
  3267                                  
  3268                                  ;-515 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
  3269                                  
  3270 000011F5 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
  3271                                  
  3272                                  ;-516 char I_END=0;// end of table char
  3273                                  
  3274 000011FC 00                      I_END db 0
  3275                                  
  3276                                  ;-517 
  3277                                  
  3278                                  
  3279                                  ;-518 int lookCode() {//ret: CodeType, *OpCodePtr
  3280                                  
  3281                                  
  3282                                  lookCode: PROC
  3283                                  
  3284                                  ;-519     CodeType=0;
  3285                                  
  3286 000011FD B80000                   mov ax, 0
  3287 00001200 A2[2F00]                 mov byte [CodeType], al
  3288                                  
  3289                                  ;-520     OpCodePtr= &I_START;
  3290                                  
  3291 00001203 B8[EB0D]                 mov ax, I_START
  3292 00001206 A3[4300]                 mov word [OpCodePtr], ax
  3293                                  
  3294                                  ;-521     OpCodePtr++;
  3295                                  
  3296 00001209 FF06[4300]               inc  word[OpCodePtr]
  3297                                  
  3298                                  ;-522     do  {
  3299                                  
  3300                                  .lookCode99:
  3301                                  
  3302                                  ;-523         if (eqstr(SymbolUpper, OpCodePtr))  {
  3303                                  
  3304 0000120D FF36[4300]               push word [OpCodePtr]
  3305 00001211 8D064F75                 lea  ax, [SymbolUpper]
  3306 00001215 50                       push ax
  3307 00001216 E893F1                   call eqstr
  3308 00001219 83C404                   add  sp, 4
  3309 0000121C 08C0                     or  al, al
  3310 0000121E 0F842700                 je .lookCode100
  3311                                  
  3312                                  ;-524             while(*OpCodePtr!=0) OpCodePtr++;
  3313                                  
  3314                                  .lookCode101:
  3315 00001222 8B1E[4300]               mov bx, [OpCodePtr]
  3316 00001226 8A07                     mov al, [bx]
  3317 00001228 B400                     mov ah, 0
  3318 0000122A 83F800                   cmp ax, 0
  3319 0000122D 0F840600                 je  .lookCode102
  3320 00001231 FF06[4300]               inc  word[OpCodePtr]
  3321                                  
  3322                                  ;-525             OpCodePtr++;
  3323                                  
  3324 00001235 EBEB                     jmp .lookCode101
  3325                                  .lookCode102:
  3326 00001237 FF06[4300]               inc  word[OpCodePtr]
  3327                                  
  3328                                  ;-526             CodeType =*OpCodePtr;
  3329                                  
  3330 0000123B 8B1E[4300]               mov bx, [OpCodePtr]
  3331 0000123F 8A07                     mov al, [bx]
  3332 00001241 B400                     mov ah, 0
  3333 00001243 A2[2F00]                 mov byte [CodeType], al
  3334                                  
  3335                                  ;-527             return;
  3336                                  
  3337 00001246 E92A00                   jmp .retnlookCode
  3338                                  
  3339                                  ;-528         }
  3340                                  
  3341                                  
  3342                                  ;-529     while(*OpCodePtr!=0xF1) OpCodePtr++;
  3343                                  
  3344                                  .lookCode100:
  3345                                  .lookCode103:
  3346 00001249 8B1E[4300]               mov bx, [OpCodePtr]
  3347 0000124D 8A07                     mov al, [bx]
  3348 0000124F B400                     mov ah, 0
  3349 00001251 3DF100                   cmp ax, 241
  3350 00001254 0F840600                 je  .lookCode104
  3351 00001258 FF06[4300]               inc  word[OpCodePtr]
  3352                                  
  3353                                  ;-530     OpCodePtr++;
  3354                                  
  3355 0000125C EBEB                     jmp .lookCode103
  3356                                  .lookCode104:
  3357 0000125E FF06[4300]               inc  word[OpCodePtr]
  3358                                  
  3359                                  ;-531     } while(*OpCodePtr!=0);
  3360                                  
  3361 00001262 8B1E[4300]               mov bx, [OpCodePtr]
  3362 00001266 8A07                     mov al, [bx]
  3363 00001268 B400                     mov ah, 0
  3364 0000126A 83F800                   cmp ax, 0
  3365 0000126D 0F840200                 je  .lookCode105
  3366 00001271 EB9A                     jmp .lookCode99
  3367                                  .lookCode105:
  3368                                  
  3369                                  ;-532 }
  3370                                  
  3371                                  
  3372                                  ;-533 
  3373                                  
  3374                                  
  3375                                  ;-534 //#include "OPS.C"
  3376                                  
  3377                                  
  3378                                  ;-535 int ChangeDirection() {
  3379                                  
  3380                                   .retnlookCode:
  3381 00001273 C3                       ret
  3382                                  ENDP
  3383                                  
  3384                                  ChangeDirection: PROC
  3385                                  
  3386                                  ;-536     char c;
  3387                                  
  3388                                  
  3389                                  ;-537     c=Op;     Op    =Op2;    Op2   =c;
  3390                                  
  3391                                  ;Function : ChangeDirection, Number of local variables: 1
  3392                                  ;   # type sign width addr used name   list of local variables
  3393                                  ;  200 var sign byte   536 NULL c = bp-2;
  3394 00001274 C8020000                 ENTER  2,0
  3395 00001278 A0[2D00]                 mov al, [Op]
  3396 0000127B 8846FE                   mov [bp-2], al
  3397 0000127E A0[2E00]                 mov al, [Op2]
  3398 00001281 A2[2D00]                 mov byte [Op], al
  3399 00001284 8A46FE                   mov al, [bp-2]
  3400 00001287 A2[2E00]                 mov byte [Op2], al
  3401                                  
  3402                                  ;-538     c=R1Type; R1Type=R2Type; R2Type=c;
  3403                                  
  3404 0000128A A0[3600]                 mov al, [R1Type]
  3405 0000128D 8846FE                   mov [bp-2], al
  3406 00001290 A0[3500]                 mov al, [R2Type]
  3407 00001293 A2[3600]                 mov byte [R1Type], al
  3408 00001296 8A46FE                   mov al, [bp-2]
  3409 00001299 A2[3500]                 mov byte [R2Type], al
  3410                                  
  3411                                  ;-539     c=R1No;   R1No  =R2No;   R2No  =c;
  3412                                  
  3413 0000129C A0[3400]                 mov al, [R1No]
  3414 0000129F 8846FE                   mov [bp-2], al
  3415 000012A2 A0[3300]                 mov al, [R2No]
  3416 000012A5 A2[3400]                 mov byte [R1No], al
  3417 000012A8 8A46FE                   mov al, [bp-2]
  3418 000012AB A2[3300]                 mov byte [R2No], al
  3419                                  
  3420                                  ;-540     dflag=2;
  3421                                  
  3422 000012AE B80200                   mov ax, 2
  3423 000012B1 A2[3900]                 mov byte [dflag], al
  3424                                  
  3425                                  ;-541 }
  3426                                  
  3427                                  
  3428                                  ;-542 
  3429                                  
  3430                                  
  3431                                  ;-543 int checkOpL() {
  3432 000012B4 C9                       LEAVE
  3433 000012B5 C3                       ret
  3434                                  ENDP
  3435                                  
  3436                                  checkOpL: PROC
  3437                                  
  3438                                  ;-544     if (Op == ADR) implerror();
  3439                                  
  3440 000012B6 A0[2D00]                 mov al, [Op]
  3441 000012B9 3C03                     cmp al, 3
  3442 000012BB 0F850300                 jne .checkOpL106
  3443 000012BF E8C7F9                   call implerror
  3444                                  
  3445                                  ;-545     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  3446                                  
  3447                                  .checkOpL106:
  3448 000012C2 A0[3600]                 mov al, [R1Type]
  3449 000012C5 3C04                     cmp al, 4
  3450 000012C7 0F850600                 jne .checkOpL107
  3451 000012CB E883FA                   call segregerror
  3452 000012CE E93E00                   jmp .retncheckOpL
  3453                                  
  3454                                  ;-546     setwflag();
  3455                                  
  3456                                  .checkOpL107:
  3457 000012D1 E88603                   call setwflag
  3458                                  
  3459                                  ;-547     if (OpSize == 0) error1("no op size declared");
  3460                                  
  3461 000012D4 A0[3700]                 mov al, [OpSize]
  3462 000012D7 3C00                     cmp al, 0
  3463 000012D9 0F850900                 jne .checkOpL108
  3464 000012DD 68[1013]                 push checkOpL_0
  3465 000012E0 E896F8                   call error1
  3466 000012E3 83C402                   add  sp, 2
  3467                                  
  3468                                  ;-548     if (OpSize == R1Type) return;
  3469                                  
  3470                                  .checkOpL108:
  3471 000012E6 A0[3700]                 mov al, [OpSize]
  3472 000012E9 3A06[3600]               cmp al, [R1Type]
  3473 000012ED 0F850300                 jne .checkOpL109
  3474 000012F1 E91B00                   jmp .retncheckOpL
  3475                                  
  3476                                  ;-549     if (Op == REG) if (R1Type==0) error1("no register defined");
  3477                                  
  3478                                  .checkOpL109:
  3479 000012F4 A0[2D00]                 mov al, [Op]
  3480 000012F7 3C02                     cmp al, 2
  3481 000012F9 0F851200                 jne .checkOpL110
  3482 000012FD A0[3600]                 mov al, [R1Type]
  3483 00001300 3C00                     cmp al, 0
  3484 00001302 0F850900                 jne .checkOpL111
  3485 00001306 68[2413]                 push checkOpL_1
  3486 00001309 E86DF8                   call error1
  3487 0000130C 83C402                   add  sp, 2
  3488                                  
  3489                                  ;-550 }
  3490                                  
  3491                                  .checkOpL111:
  3492                                  .checkOpL110:
  3493                                  
  3494                                  ;-551 
  3495                                  
  3496                                  
  3497                                  ;-552 int check2Ops() {
  3498                                  
  3499                                   .retncheckOpL:
  3500 0000130F C3                       ret
  3501 00001310 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  3502 00001319 65206465636C617265-
  3503 00001322 6400               
  3504 00001324 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  3505 0000132D 657220646566696E65-
  3506 00001336 6400               
  3507                                  ENDP
  3508                                  
  3509                                  check2Ops: PROC
  3510                                  
  3511                                  ;-553     get2Ops();
  3512                                  
  3513 00001338 E84900                   call get2Ops
  3514                                  
  3515                                  ;-554     if (Op ==   0) addrerror();
  3516                                  
  3517 0000133B A0[2D00]                 mov al, [Op]
  3518 0000133E 3C00                     cmp al, 0
  3519 00001340 0F850300                 jne .check2Ops112
  3520 00001344 E803F9                   call addrerror
  3521                                  
  3522                                  ;-555     if (Op == ADR) invaloperror();
  3523                                  
  3524                                  .check2Ops112:
  3525 00001347 A0[2D00]                 mov al, [Op]
  3526 0000134A 3C03                     cmp al, 3
  3527 0000134C 0F850300                 jne .check2Ops113
  3528 00001350 E871F9                   call invaloperror
  3529                                  
  3530                                  ;-556     if (Op == IMM) immeerror();
  3531                                  
  3532                                  .check2Ops113:
  3533 00001353 A0[2D00]                 mov al, [Op]
  3534 00001356 3C01                     cmp al, 1
  3535 00001358 0F850300                 jne .check2Ops114
  3536 0000135C E805F9                   call immeerror
  3537                                  
  3538                                  ;-557     if (Op2==   0) addrerror();
  3539                                  
  3540                                  .check2Ops114:
  3541 0000135F A0[2E00]                 mov al, [Op2]
  3542 00001362 3C00                     cmp al, 0
  3543 00001364 0F850300                 jne .check2Ops115
  3544 00001368 E8DFF8                   call addrerror
  3545                                  
  3546                                  ;-558     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov
  3547                                  
  3548                                  .check2Ops115:
  3549 0000136B A0[2F00]                 mov al, [CodeType]
  3550 0000136E 3C05                     cmp al, 5
  3551 00001370 0F840C00                 je  .check2Ops116
  3552 00001374 A0[2E00]                 mov al, [Op2]
  3553 00001377 3C03                     cmp al, 3
  3554 00001379 0F850300                 jne .check2Ops117
  3555 0000137D E844F9                   call invaloperror
  3556                                  
  3557                                  ;-559     setwflag();
  3558                                  
  3559                                  .check2Ops117:
  3560                                  .check2Ops116:
  3561 00001380 E8D702                   call setwflag
  3562                                  
  3563                                  ;-560 }
  3564                                  
  3565                                  
  3566                                  ;-561 int get2Ops() {
  3567                                  
  3568 00001383 C3                       ret
  3569                                  ENDP
  3570                                  
  3571                                  get2Ops: PROC
  3572                                  
  3573                                  ;-562     getOpL();
  3574                                  
  3575 00001384 E80C00                   call getOpL
  3576                                  
  3577                                  ;-563     need(',');
  3578                                  
  3579 00001387 6A2C                     push 44
  3580 00001389 E81709                   call need
  3581 0000138C 83C402                   add  sp, 2
  3582                                  
  3583                                  ;-564     getOpR();
  3584                                  
  3585 0000138F E82900                   call getOpR
  3586                                  
  3587                                  ;-565 }
  3588                                  
  3589                                  
  3590                                  ;-566 
  3591                                  
  3592                                  
  3593                                  ;-567 int getOpL() {
  3594                                  
  3595 00001392 C3                       ret
  3596                                  ENDP
  3597                                  
  3598                                  getOpL: PROC
  3599                                  
  3600                                  ;-568 //set: op=0,IMM,REG,ADR,MEM
  3601                                  
  3602                                  
  3603                                  ;-569     getOpR();
  3604                                  
  3605 00001393 E82500                   call getOpR
  3606                                  
  3607                                  ;-570     Op=Op2;         Op2=0;
  3608                                  
  3609 00001396 A0[2E00]                 mov al, [Op2]
  3610 00001399 A2[2D00]                 mov byte [Op], al
  3611 0000139C B80000                   mov ax, 0
  3612 0000139F A2[2E00]                 mov byte [Op2], al
  3613                                  
  3614                                  ;-571     R1No=R2No;      R2No=0;
  3615                                  
  3616 000013A2 A0[3300]                 mov al, [R2No]
  3617 000013A5 A2[3400]                 mov byte [R1No], al
  3618 000013A8 B80000                   mov ax, 0
  3619 000013AB A2[3300]                 mov byte [R2No], al
  3620                                  
  3621                                  ;-572     R1Type=R2Type; R2Type=0;
  3622                                  
  3623 000013AE A0[3500]                 mov al, [R2Type]
  3624 000013B1 A2[3600]                 mov byte [R1Type], al
  3625 000013B4 B80000                   mov ax, 0
  3626 000013B7 A2[3500]                 mov byte [R2Type], al
  3627                                  
  3628                                  ;-573 }
  3629                                  
  3630                                  
  3631                                  ;-574 
  3632                                  
  3633                                  
  3634                                  ;-575 int getOpR() {
  3635                                  
  3636 000013BA C3                       ret
  3637                                  ENDP
  3638                                  
  3639                                  getOpR: PROC
  3640                                  
  3641                                  ;-576     Op2=getOp1();
  3642                                  
  3643 000013BB E89900                   call getOp1
  3644 000013BE A2[2E00]                 mov byte [Op2], al
  3645                                  
  3646                                  ;-577     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  3647                                  
  3648 000013C1 6A5B                     push 91
  3649 000013C3 E8B508                   call isToken
  3650 000013C6 83C402                   add  sp, 2
  3651 000013C9 08C0                     or  al, al
  3652 000013CB 0F840C00                 je .getOpR118
  3653 000013CF B80400                   mov ax, 4
  3654 000013D2 A2[2E00]                 mov byte [Op2], al
  3655 000013D5 E8CE00                   call getMEM
  3656 000013D8 E96200                   jmp .retngetOpR
  3657                                  
  3658                                  ;-578     if (Op2 == 0)     {invaloperror();         return;}
  3659                                  
  3660                                  .getOpR118:
  3661 000013DB A0[2E00]                 mov al, [Op2]
  3662 000013DE 3C00                     cmp al, 0
  3663 000013E0 0F850600                 jne .getOpR119
  3664 000013E4 E8DDF8                   call invaloperror
  3665 000013E7 E95300                   jmp .retngetOpR
  3666                                  
  3667                                  ;-579     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  3668                                  
  3669                                  .getOpR119:
  3670 000013EA A0[2E00]                 mov al, [Op2]
  3671 000013ED 3C01                     cmp al, 1
  3672 000013EF 0F850900                 jne .getOpR120
  3673 000013F3 A1[0E00]                 mov ax, [SymbolInt]
  3674 000013F6 A3[3F00]                 mov word [imme], ax
  3675 000013F9 E94100                   jmp .retngetOpR
  3676                                  
  3677                                  ;-580     if (Op2 == REG)                            return;
  3678                                  
  3679                                  .getOpR120:
  3680 000013FC A0[2E00]                 mov al, [Op2]
  3681 000013FF 3C02                     cmp al, 2
  3682 00001401 0F850300                 jne .getOpR121
  3683 00001405 E93500                   jmp .retngetOpR
  3684                                  
  3685                                  ;-581     if (Op2 == ADR)   {
  3686                                  
  3687                                  .getOpR121:
  3688 00001408 A0[2E00]                 mov al, [Op2]
  3689 0000140B 3C03                     cmp al, 3
  3690 0000140D 0F852300                 jne .getOpR122
  3691                                  
  3692                                  ;-582         if (LabelIx == 0) disp=0;
  3693                                  
  3694 00001411 A1[4E00]                 mov ax, [LabelIx]
  3695 00001414 83F800                   cmp ax, 0
  3696 00001417 0F850900                 jne .getOpR123
  3697 0000141B B80000                   mov ax, 0
  3698 0000141E A3[3D00]                 mov word [disp], ax
  3699                                  
  3700                                  ;-583         else disp=LabelAddr[LabelIx];
  3701                                  
  3702 00001421 E90D00                   jmp .getOpR124
  3703                                  .getOpR123:
  3704 00001424 8B1E[4E00]               mov bx, [LabelIx]
  3705 00001428 D1E3                     shl bx, 1
  3706 0000142A 8B87CA8E                 mov ax, [LabelAddr + bx]
  3707 0000142E A3[3D00]                 mov word [disp], ax
  3708                                  
  3709                                  ;-584         return;}
  3710                                  
  3711                                  .getOpR124:
  3712 00001431 E90900                   jmp .retngetOpR
  3713                                  
  3714                                  ;-585     error1("Name of operand expected");
  3715                                  
  3716                                  .getOpR122:
  3717 00001434 68[3E14]                 push getOpR_0
  3718 00001437 E83FF7                   call error1
  3719 0000143A 83C402                   add  sp, 2
  3720                                  
  3721                                  ;-586 }
  3722                                  
  3723                                  
  3724                                  ;-587 
  3725                                  
  3726                                  
  3727                                  ;-588 int getOp1() {//scan for a single operand
  3728                                  
  3729                                   .retngetOpR:
  3730 0000143D C3                       ret
  3731 0000143E 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  3732 00001447 706572616E64206578-
  3733 00001450 70656374656400     
  3734                                  ENDP
  3735                                  
  3736                                  getOp1: PROC
  3737                                  
  3738                                  ;-589 //return:0, IMM, REG, ADR (not MEM)
  3739                                  
  3740                                  
  3741                                  ;-590 //set   :R2Type, R2No by testReg
  3742                                  
  3743                                  
  3744                                  ;-591 //set   :LabelIx by searchLabel
  3745                                  
  3746                                  
  3747                                  ;-592     if (TokeType == 0)      return 0;
  3748                                  
  3749 00001457 A0[2C00]                 mov al, [TokeType]
  3750 0000145A 3C00                     cmp al, 0
  3751 0000145C 0F850600                 jne .getOp1125
  3752 00001460 B80000                   mov ax, 0
  3753 00001463 E93F00                   jmp .retngetOp1
  3754                                  
  3755                                  ;-593     if (TokeType == DIGIT)  return IMM;
  3756                                  
  3757                                  .getOp1125:
  3758 00001466 A0[2C00]                 mov al, [TokeType]
  3759 00001469 3C01                     cmp al, 1
  3760 0000146B 0F850600                 jne .getOp1126
  3761 0000146F B80100                   mov ax, 1
  3762 00001472 E93000                   jmp .retngetOp1
  3763                                  
  3764                                  ;-594     if (TokeType == ALNUME) {
  3765                                  
  3766                                  .getOp1126:
  3767 00001475 A0[2C00]                 mov al, [TokeType]
  3768 00001478 3C03                     cmp al, 3
  3769 0000147A 0F852100                 jne .getOp1127
  3770                                  
  3771                                  ;-595         R2No=testReg();
  3772                                  
  3773 0000147E E8DEF0                   call testReg
  3774 00001481 A2[3300]                 mov byte [R2No], al
  3775                                  
  3776                                  ;-596         if (R2Type)        return REG;
  3777                                  
  3778 00001484 A0[3500]                 mov al, [R2Type]
  3779 00001487 08C0                     or  al, al
  3780 00001489 0F840600                 je .getOp1128
  3781 0000148D B80200                   mov ax, 2
  3782 00001490 E91200                   jmp .retngetOp1
  3783                                  
  3784                                  ;-597         LabelIx=searchLabel();
  3785                                  
  3786                                  .getOp1128:
  3787 00001493 E88105                   call searchLabel
  3788 00001496 A3[4E00]                 mov word [LabelIx], ax
  3789                                  
  3790                                  ;-598         return ADR;
  3791                                  
  3792 00001499 B80300                   mov ax, 3
  3793 0000149C E90600                   jmp .retngetOp1
  3794                                  
  3795                                  ;-599 //        if (LabelIx)        return ADR;
  3796                                  
  3797                                  
  3798                                  ;-600 //        else error1("variable not found");
  3799                                  
  3800                                  
  3801                                  ;-601     }
  3802                                  
  3803                                  
  3804                                  ;-602     return 0;
  3805                                  
  3806                                  .getOp1127:
  3807 0000149F B80000                   mov ax, 0
  3808 000014A2 E90000                   jmp .retngetOp1
  3809                                  
  3810                                  ;-603 }
  3811                                  
  3812                                  
  3813                                  ;-604 
  3814                                  
  3815                                  
  3816                                  ;-605 int getMEM() {// e.g. [array+bp+si-4]
  3817                                  
  3818                                   .retngetOp1:
  3819 000014A5 C3                       ret
  3820                                  ENDP
  3821                                  
  3822                                  getMEM: PROC
  3823                                  
  3824                                  ;-606 //set: disp, rm, R2Type
  3825                                  
  3826                                  
  3827                                  ;-607     char c;
  3828                                  
  3829                                  
  3830                                  ;-608     disp=0; rm=0;
  3831                                  
  3832                                  ;Function : getMEM, Number of local variables: 1
  3833                                  ;   # type sign width addr used name   list of local variables
  3834                                  ;  200 var sign byte   607 NULL c = bp-2;
  3835 000014A6 C8020000                 ENTER  2,0
  3836 000014AA B80000                   mov ax, 0
  3837 000014AD A3[3D00]                 mov word [disp], ax
  3838 000014B0 B80000                   mov ax, 0
  3839 000014B3 A2[3B00]                 mov byte [rm], al
  3840                                  
  3841                                  ;-609     do {
  3842                                  
  3843                                  .getMEM129:
  3844                                  
  3845                                  ;-610         getTokeType();
  3846                                  
  3847 000014B6 E8AF03                   call getTokeType
  3848                                  
  3849                                  ;-611         c=getOp1();
  3850                                  
  3851 000014B9 E89BFF                   call getOp1
  3852 000014BC 8846FE                   mov [bp-2], al
  3853                                  
  3854                                  ;-612         if (c ==   0) syntaxerror();
  3855                                  
  3856 000014BF 8A46FE                   mov al, [bp-2]
  3857 000014C2 3C00                     cmp al, 0
  3858 000014C4 0F850300                 jne .getMEM130
  3859 000014C8 E8ADF8                   call syntaxerror
  3860                                  
  3861                                  ;-613         if (c == REG) {
  3862                                  
  3863                                  .getMEM130:
  3864 000014CB 8A46FE                   mov al, [bp-2]
  3865 000014CE 3C02                     cmp al, 2
  3866 000014D0 0F851B00                 jne .getMEM131
  3867                                  
  3868                                  ;-614             isDirect=0;
  3869                                  
  3870 000014D4 B80000                   mov ax, 0
  3871 000014D7 A2[3C00]                 mov byte [isDirect], al
  3872                                  
  3873                                  ;-615             if (rm) rm=getIndReg2();
  3874                                  
  3875 000014DA A0[3B00]                 mov al, [rm]
  3876 000014DD 08C0                     or  al, al
  3877 000014DF 0F840900                 je .getMEM132
  3878 000014E3 E8F600                   call getIndReg2
  3879 000014E6 A2[3B00]                 mov byte [rm], al
  3880                                  
  3881                                  ;-616             else getIndReg1();
  3882                                  
  3883 000014E9 E90300                   jmp .getMEM133
  3884                                  .getMEM132:
  3885 000014EC E89800                   call getIndReg1
  3886                                  
  3887                                  ;-617         }
  3888                                  
  3889                                  .getMEM133:
  3890                                  
  3891                                  ;-618         if (c == ADR) {
  3892                                  
  3893                                  .getMEM131:
  3894 000014EF 8A46FE                   mov al, [bp-2]
  3895 000014F2 3C03                     cmp al, 3
  3896 000014F4 0F851F00                 jne .getMEM134
  3897                                  
  3898                                  ;-619             if (LabelIx)    disp=disp+LabelAddr[LabelIx];
  3899                                  
  3900 000014F8 A1[4E00]                 mov ax, [LabelIx]
  3901 000014FB 08C0                     or  al, al
  3902 000014FD 0F841300                 je .getMEM135
  3903 00001501 A1[3D00]                 mov ax, [disp]
  3904 00001504 8B1E[4E00]               mov bx, [LabelIx]
  3905 00001508 D1E3                     shl bx, 1
  3906 0000150A 0387CA8E                 add ax, [LabelAddr + bx]
  3907 0000150E A3[3D00]                 mov word [disp], ax
  3908                                  
  3909                                  ;-620             else notfounderror();
  3910                                  
  3911 00001511 E90300                   jmp .getMEM136
  3912                                  .getMEM135:
  3913 00001514 E8D2F6                   call notfounderror
  3914                                  
  3915                                  ;-621         }
  3916                                  
  3917                                  .getMEM136:
  3918                                  
  3919                                  ;-622         if (c == IMM) disp=disp+SymbolInt;
  3920                                  
  3921                                  .getMEM134:
  3922 00001517 8A46FE                   mov al, [bp-2]
  3923 0000151A 3C01                     cmp al, 1
  3924 0000151C 0F850A00                 jne .getMEM137
  3925 00001520 A1[3D00]                 mov ax, [disp]
  3926 00001523 0306[0E00]               add ax, [SymbolInt]
  3927 00001527 A3[3D00]                 mov word [disp], ax
  3928                                  
  3929                                  ;-623         if (isToken('-')) {
  3930                                  
  3931                                  .getMEM137:
  3932 0000152A 6A2D                     push 45
  3933 0000152C E84C07                   call isToken
  3934 0000152F 83C402                   add  sp, 2
  3935 00001532 08C0                     or  al, al
  3936 00001534 0F841900                 je .getMEM138
  3937                                  
  3938                                  ;-624             getTokeType();
  3939                                  
  3940 00001538 E82D03                   call getTokeType
  3941                                  
  3942                                  ;-625             if (TokeType != DIGIT) numbererror();
  3943                                  
  3944 0000153B A0[2C00]                 mov al, [TokeType]
  3945 0000153E 3C01                     cmp al, 1
  3946 00001540 0F840300                 je  .getMEM139
  3947 00001544 E89EF7                   call numbererror
  3948                                  
  3949                                  ;-626             disp = disp - SymbolInt;
  3950                                  
  3951                                  .getMEM139:
  3952 00001547 A1[3D00]                 mov ax, [disp]
  3953 0000154A 2B06[0E00]               sub ax, [SymbolInt]
  3954 0000154E A3[3D00]                 mov word [disp], ax
  3955                                  
  3956                                  ;-627         }
  3957                                  
  3958                                  
  3959                                  ;-628     } while (isToken('+'));
  3960                                  
  3961                                  .getMEM138:
  3962 00001551 6A2B                     push 43
  3963 00001553 E82507                   call isToken
  3964 00001556 83C402                   add  sp, 2
  3965 00001559 08C0                     or  al, al
  3966 0000155B 0F840300                 je .getMEM140
  3967 0000155F E954FF                   jmp .getMEM129
  3968                                  .getMEM140:
  3969                                  
  3970                                  ;-629     if (isToken(']') == 0) errorexit("] expected");
  3971                                  
  3972 00001562 6A5D                     push 93
  3973 00001564 E81407                   call isToken
  3974 00001567 83C402                   add  sp, 2
  3975 0000156A 83F800                   cmp ax, 0
  3976 0000156D 0F850900                 jne .getMEM141
  3977 00001571 68[7C15]                 push getMEM_0
  3978 00001574 E858F6                   call errorexit
  3979 00001577 83C402                   add  sp, 2
  3980                                  
  3981                                  ;-630 }
  3982                                  
  3983                                  .getMEM141:
  3984                                  
  3985                                  ;-631 int getIndReg1() {
  3986 0000157A C9                       LEAVE
  3987 0000157B C3                       ret
  3988 0000157C 5D2065787065637465-     getMEM_0 db "] expected",0
  3989 00001585 6400               
  3990                                  ENDP
  3991                                  
  3992                                  getIndReg1: PROC
  3993                                  
  3994                                  ;-632     if (R2Type !=WORD) indexerror();
  3995                                  
  3996 00001587 A0[3500]                 mov al, [R2Type]
  3997 0000158A 3C02                     cmp al, 2
  3998 0000158C 0F840300                 je  .getIndReg1142
  3999 00001590 E810F7                   call indexerror
  4000                                  
  4001                                  ;-633     if (R2No==3) rm=7;//BX
  4002                                  
  4003                                  .getIndReg1142:
  4004 00001593 A0[3300]                 mov al, [R2No]
  4005 00001596 3C03                     cmp al, 3
  4006 00001598 0F850600                 jne .getIndReg1143
  4007 0000159C B80700                   mov ax, 7
  4008 0000159F A2[3B00]                 mov byte [rm], al
  4009                                  
  4010                                  ;-634     if (R2No==5) rm=6;//BP, change to BP+0
  4011                                  
  4012                                  .getIndReg1143:
  4013 000015A2 A0[3300]                 mov al, [R2No]
  4014 000015A5 3C05                     cmp al, 5
  4015 000015A7 0F850600                 jne .getIndReg1144
  4016 000015AB B80600                   mov ax, 6
  4017 000015AE A2[3B00]                 mov byte [rm], al
  4018                                  
  4019                                  ;-635     if (R2No==7) rm=5;//DI
  4020                                  
  4021                                  .getIndReg1144:
  4022 000015B1 A0[3300]                 mov al, [R2No]
  4023 000015B4 3C07                     cmp al, 7
  4024 000015B6 0F850600                 jne .getIndReg1145
  4025 000015BA B80500                   mov ax, 5
  4026 000015BD A2[3B00]                 mov byte [rm], al
  4027                                  
  4028                                  ;-636     if (R2No==6) rm=4;//SI
  4029                                  
  4030                                  .getIndReg1145:
  4031 000015C0 A0[3300]                 mov al, [R2No]
  4032 000015C3 3C06                     cmp al, 6
  4033 000015C5 0F850600                 jne .getIndReg1146
  4034 000015C9 B80400                   mov ax, 4
  4035 000015CC A2[3B00]                 mov byte [rm], al
  4036                                  
  4037                                  ;-637     if (rm==0) indexerror();
  4038                                  
  4039                                  .getIndReg1146:
  4040 000015CF A0[3B00]                 mov al, [rm]
  4041 000015D2 3C00                     cmp al, 0
  4042 000015D4 0F850300                 jne .getIndReg1147
  4043 000015D8 E8C8F6                   call indexerror
  4044                                  
  4045                                  ;-638 }
  4046                                  
  4047                                  .getIndReg1147:
  4048                                  
  4049                                  ;-639 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  4050                                  
  4051 000015DB C3                       ret
  4052                                  ENDP
  4053                                  
  4054                                  getIndReg2: PROC
  4055                                  ;Function : getIndReg2, Number of local variables: 1
  4056                                  ;   # type sign width addr used name   list of local variables
  4057                                  ;  200 var sign byte   639 NULL m = bp-2;
  4058 000015DC C8020000                 ENTER  2,0
  4059 000015E0 B80400                   mov ax, 4
  4060 000015E3 8846FE                   mov [bp-2], al
  4061                                  
  4062                                  ;-640     if (R2Type !=WORD) indexerror();
  4063                                  
  4064 000015E6 A0[3500]                 mov al, [R2Type]
  4065 000015E9 3C02                     cmp al, 2
  4066 000015EB 0F840300                 je  .getIndReg2148
  4067 000015EF E8B1F6                   call indexerror
  4068                                  
  4069                                  ;-641     if (R2No==7) if (rm==6) m=3;//BP+DI
  4070                                  
  4071                                  .getIndReg2148:
  4072 000015F2 A0[3300]                 mov al, [R2No]
  4073 000015F5 3C07                     cmp al, 7
  4074 000015F7 0F852100                 jne .getIndReg2149
  4075 000015FB A0[3B00]                 mov al, [rm]
  4076 000015FE 3C06                     cmp al, 6
  4077 00001600 0F850900                 jne .getIndReg2150
  4078 00001604 B80300                   mov ax, 3
  4079 00001607 8846FE                   mov [bp-2], al
  4080                                  
  4081                                  ;-642              else if (rm==7) m=1;//BX+DI
  4082                                  
  4083 0000160A E90F00                   jmp .getIndReg2151
  4084                                  .getIndReg2150:
  4085 0000160D A0[3B00]                 mov al, [rm]
  4086 00001610 3C07                     cmp al, 7
  4087 00001612 0F850600                 jne .getIndReg2152
  4088 00001616 B80100                   mov ax, 1
  4089 00001619 8846FE                   mov [bp-2], al
  4090                                  
  4091                                  ;-643     if (R2No==6) if (rm==6) m=2;//BP+SI
  4092                                  
  4093                                  .getIndReg2152:
  4094                                  .getIndReg2151:
  4095                                  .getIndReg2149:
  4096 0000161C A0[3300]                 mov al, [R2No]
  4097 0000161F 3C06                     cmp al, 6
  4098 00001621 0F852100                 jne .getIndReg2153
  4099 00001625 A0[3B00]                 mov al, [rm]
  4100 00001628 3C06                     cmp al, 6
  4101 0000162A 0F850900                 jne .getIndReg2154
  4102 0000162E B80200                   mov ax, 2
  4103 00001631 8846FE                   mov [bp-2], al
  4104                                  
  4105                                  ;-644              else if (rm==7) m=0;//BX+SI
  4106                                  
  4107 00001634 E90F00                   jmp .getIndReg2155
  4108                                  .getIndReg2154:
  4109 00001637 A0[3B00]                 mov al, [rm]
  4110 0000163A 3C07                     cmp al, 7
  4111 0000163C 0F850600                 jne .getIndReg2156
  4112 00001640 B80000                   mov ax, 0
  4113 00001643 8846FE                   mov [bp-2], al
  4114                                  
  4115                                  ;-645     if (m > 3) indexerror();
  4116                                  
  4117                                  .getIndReg2156:
  4118                                  .getIndReg2155:
  4119                                  .getIndReg2153:
  4120 00001646 8A46FE                   mov al, [bp-2]
  4121 00001649 3C03                     cmp al, 3
  4122 0000164B 0F8E0300                 jle .getIndReg2157
  4123 0000164F E851F6                   call indexerror
  4124                                  
  4125                                  ;-646     return m;
  4126                                  
  4127                                  .getIndReg2157:
  4128 00001652 8A46FE                   mov al, [bp-2]
  4129 00001655 E90000                   jmp .retngetIndReg2
  4130                                  
  4131                                  ;-647 }
  4132                                  
  4133                                  
  4134                                  ;-648 
  4135                                  
  4136                                  
  4137                                  ;-649 int setwflag() {//word size, bit 0
  4138                                  
  4139 00001658 C9                       .retngetIndReg2: LEAVE
  4140 00001659 C3                       ret
  4141                                  ENDP
  4142                                  
  4143                                  setwflag: PROC
  4144                                  
  4145                                  ;-650     wflag=0;
  4146                                  
  4147 0000165A B80000                   mov ax, 0
  4148 0000165D A2[3800]                 mov byte [wflag], al
  4149                                  
  4150                                  ;-651     if (OpSize == 0) {//do not override OpSize
  4151                                  
  4152 00001660 A0[3700]                 mov al, [OpSize]
  4153 00001663 3C00                     cmp al, 0
  4154 00001665 0F853C00                 jne .setwflag158
  4155                                  
  4156                                  ;-652         if (Op == REG) OpSize=R1Type;
  4157                                  
  4158 00001669 A0[2D00]                 mov al, [Op]
  4159 0000166C 3C02                     cmp al, 2
  4160 0000166E 0F850600                 jne .setwflag159
  4161 00001672 A0[3600]                 mov al, [R1Type]
  4162 00001675 A2[3700]                 mov byte [OpSize], al
  4163                                  
  4164                                  ;-653         if (Op2== REG) OpSize=R2Type;
  4165                                  
  4166                                  .setwflag159:
  4167 00001678 A0[2E00]                 mov al, [Op2]
  4168 0000167B 3C02                     cmp al, 2
  4169 0000167D 0F850600                 jne .setwflag160
  4170 00001681 A0[3500]                 mov al, [R2Type]
  4171 00001684 A2[3700]                 mov byte [OpSize], al
  4172                                  
  4173                                  ;-654         if (R2Type== SEGREG) OpSize=WORD;
  4174                                  
  4175                                  .setwflag160:
  4176 00001687 A0[3500]                 mov al, [R2Type]
  4177 0000168A 3C04                     cmp al, 4
  4178 0000168C 0F850600                 jne .setwflag161
  4179 00001690 B80200                   mov ax, 2
  4180 00001693 A2[3700]                 mov byte [OpSize], al
  4181                                  
  4182                                  ;-655         if (R1Type == SEGREG) OpSize=WORD;
  4183                                  
  4184                                  .setwflag161:
  4185 00001696 A0[3600]                 mov al, [R1Type]
  4186 00001699 3C04                     cmp al, 4
  4187 0000169B 0F850600                 jne .setwflag162
  4188 0000169F B80200                   mov ax, 2
  4189 000016A2 A2[3700]                 mov byte [OpSize], al
  4190                                  
  4191                                  ;-656     }
  4192                                  
  4193                                  .setwflag162:
  4194                                  
  4195                                  ;-657     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  4196                                  
  4197                                  .setwflag158:
  4198 000016A5 A0[3700]                 mov al, [OpSize]
  4199 000016A8 3C03                     cmp al, 3
  4200 000016AA 0F850900                 jne .setwflag163
  4201 000016AE E8130D                   call gen66h
  4202 000016B1 B80100                   mov ax, 1
  4203 000016B4 A2[3800]                 mov byte [wflag], al
  4204                                  
  4205                                  ;-658     if (OpSize  ==  WORD) wflag=1;
  4206                                  
  4207                                  .setwflag163:
  4208 000016B7 A0[3700]                 mov al, [OpSize]
  4209 000016BA 3C02                     cmp al, 2
  4210 000016BC 0F850600                 jne .setwflag164
  4211 000016C0 B80100                   mov ax, 1
  4212 000016C3 A2[3800]                 mov byte [wflag], al
  4213                                  
  4214                                  ;-659 }
  4215                                  
  4216                                  .setwflag164:
  4217                                  
  4218                                  ;-660 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
  4219                                  
  4220 000016C6 C3                       ret
  4221                                  ENDP
  4222                                  
  4223                                  setsflag: PROC
  4224                                  
  4225                                  ;-661     unsigned int ui;
  4226                                  
  4227                                  
  4228                                  ;-662     sflag=2;
  4229                                  
  4230                                  ;Function : setsflag, Number of local variables: 1
  4231                                  ;   # type sign width addr used name   list of local variables
  4232                                  ;  200 var unsg word   661 NULL ui = bp-2;
  4233 000016C7 C8020000                 ENTER  2,0
  4234 000016CB B80200                   mov ax, 2
  4235 000016CE A2[3A00]                 mov byte [sflag], al
  4236                                  
  4237                                  ;-663     ui = imme & 0xFF80;//is greater than signed 127?
  4238                                  
  4239 000016D1 A1[3F00]                 mov ax, [imme]
  4240 000016D4 2580FF                   and ax, 65408
  4241 000016D7 8946FE                   mov [bp-2], ax
  4242                                  
  4243                                  ;-664     if(ui != 0) sflag = 0;
  4244                                  
  4245 000016DA 8B46FE                   mov ax, [bp-2]
  4246 000016DD 83F800                   cmp ax, 0
  4247 000016E0 0F840600                 je  .setsflag165
  4248 000016E4 B80000                   mov ax, 0
  4249 000016E7 A2[3A00]                 mov byte [sflag], al
  4250                                  
  4251                                  ;-665     if (OpSize == BYTE) {
  4252                                  
  4253                                  .setsflag165:
  4254 000016EA A0[3700]                 mov al, [OpSize]
  4255 000016ED 3C01                     cmp al, 1
  4256 000016EF 0F851900                 jne .setsflag166
  4257                                  
  4258                                  ;-666         if (imme > 255) error1("too big for byte r/m");
  4259                                  
  4260 000016F3 A1[3F00]                 mov ax, [imme]
  4261 000016F6 3DFF00                   cmp ax, 255
  4262 000016F9 0F8E0900                 jle .setsflag167
  4263 000016FD 68[0E17]                 push setsflag_0
  4264 00001700 E876F4                   call error1
  4265 00001703 83C402                   add  sp, 2
  4266                                  
  4267                                  ;-667         sflag=0;//byte reg does not need sign extended
  4268                                  
  4269                                  .setsflag167:
  4270 00001706 B80000                   mov ax, 0
  4271 00001709 A2[3A00]                 mov byte [sflag], al
  4272                                  
  4273                                  ;-668     }
  4274                                  
  4275                                  
  4276                                  ;-669 }
  4277                                  
  4278                                  .setsflag166:
  4279                                  
  4280                                  ;-670 int checkConstSize(unsigned int ui) {
  4281 0000170C C9                       LEAVE
  4282 0000170D C3                       ret
  4283 0000170E 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  4284 00001717 6F7220627974652072-
  4285 00001720 2F6D00             
  4286                                  ENDP
  4287                                  
  4288                                  checkConstSize: PROC
  4289                                  
  4290                                  ;-671     if (ui > 127   ) return 0;//is near; return sflag
  4291                                  
  4292                                  ;Function : checkConstSize, Number of local variables: 1
  4293                                  ;   # type sign width addr used name   list of local variables
  4294                                  ;  200 var unsg word   670 NULL ui = bp+4;
  4295 00001723 C8000000                 ENTER  0,0
  4296 00001727 8B4604                   mov ax, [bp+4]
  4297 0000172A 83F87F                   cmp ax, 127
  4298 0000172D 0F8E0600                 jle .checkConstSize168
  4299 00001731 B80000                   mov ax, 0
  4300 00001734 E91600                   jmp .retncheckConstSize
  4301                                  
  4302                                  ;-672     if (ui < 0xFF80) return 0;//-128dez
  4303                                  
  4304                                  .checkConstSize168:
  4305 00001737 8B4604                   mov ax, [bp+4]
  4306 0000173A 3D80FF                   cmp ax, 65408
  4307 0000173D 0F8D0600                 jge .checkConstSize169
  4308 00001741 B80000                   mov ax, 0
  4309 00001744 E90600                   jmp .retncheckConstSize
  4310                                  
  4311                                  ;-673     return 2;// is short
  4312                                  
  4313                                  .checkConstSize169:
  4314 00001747 B80200                   mov ax, 2
  4315 0000174A E90000                   jmp .retncheckConstSize
  4316                                  
  4317                                  ;-674 }
  4318                                  
  4319                                  
  4320                                  ;-675 
  4321                                  
  4322                                  
  4323                                  ;-676 
  4324                                  
  4325                                  
  4326                                  ;-677 //#include "PARSE.C"
  4327                                  
  4328                                  
  4329                                  ;-678 int parse() {
  4330                                  
  4331 0000174D C9                       .retncheckConstSize: LEAVE
  4332 0000174E C3                       ret
  4333                                  ENDP
  4334                                  
  4335                                  parse: PROC
  4336                                  
  4337                                  ;-679     LabelNamePtr  = &LabelNames;
  4338                                  
  4339 0000174F B85A77                   mov ax, LabelNames
  4340 00001752 A3[4600]                 mov word [LabelNamePtr], ax
  4341                                  
  4342                                  ;-680     JmpNamePtr= &JmpNames;
  4343                                  
  4344 00001755 B87A93                   mov ax, JmpNames
  4345 00001758 A3[5000]                 mov word [JmpNamePtr], ax
  4346                                  
  4347                                  ;-681     LabelMaxIx=0;
  4348                                  
  4349 0000175B B80000                   mov ax, 0
  4350 0000175E A3[4A00]                 mov word [LabelMaxIx], ax
  4351                                  
  4352                                  ;-682     JmpMaxIx=0;
  4353                                  
  4354 00001761 B80000                   mov ax, 0
  4355 00001764 A3[5400]                 mov word [JmpMaxIx], ax
  4356                                  
  4357                                  ;-683     BinLen=0;
  4358                                  
  4359 00001767 B80000                   mov ax, 0
  4360 0000176A A3[5800]                 mov word [BinLen], ax
  4361                                  
  4362                                  ;-684     isInProc=0;
  4363                                  
  4364 0000176D B80000                   mov ax, 0
  4365 00001770 A2[0D00]                 mov byte [isInProc], al
  4366                                  
  4367                                  ;-685 
  4368                                  
  4369                                  
  4370                                  ;-686     do {//process a new line
  4371                                  
  4372                                  .parse170:
  4373                                  
  4374                                  ;-687         PCStart=PC;
  4375                                  
  4376 00001773 A1[2300]                 mov ax, [PC]
  4377 00001776 A3[2900]                 mov word [PCStart], ax
  4378                                  
  4379                                  ;-688         OpSize=0;
  4380                                  
  4381 00001779 B80000                   mov ax, 0
  4382 0000177C A2[3700]                 mov byte [OpSize], al
  4383                                  
  4384                                  ;-689         OpPrintIndex=0;
  4385                                  
  4386 0000177F B80000                   mov ax, 0
  4387 00001782 A3[4100]                 mov word [OpPrintIndex], ax
  4388                                  
  4389                                  ;-690         PrintRA=' ';
  4390                                  
  4391 00001785 B82000                   mov ax, 32
  4392 00001788 A2[4500]                 mov byte [PrintRA], al
  4393                                  
  4394                                  ;-691         getLine();
  4395                                  
  4396 0000178B E890E9                   call getLine
  4397                                  
  4398                                  ;-692         InputPtr = &InputBuf;
  4399                                  
  4400 0000178E B88D75                   mov ax, InputBuf
  4401 00001791 A3[1400]                 mov word [InputPtr], ax
  4402                                  
  4403                                  ;-693         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  4404                                  
  4405 00001794 E8D100                   call getTokeType
  4406                                  
  4407                                  ;-694         if (TokeType == ALNUME) {
  4408                                  
  4409 00001797 A0[2C00]                 mov al, [TokeType]
  4410 0000179A 3C03                     cmp al, 3
  4411 0000179C 0F852C00                 jne .parse171
  4412                                  
  4413                                  ;-695             if (isLabel) {//set in getName
  4414                                  
  4415 000017A0 A0[2B00]                 mov al, [isLabel]
  4416 000017A3 08C0                     or  al, al
  4417 000017A5 0F842300                 je .parse172
  4418                                  
  4419                                  ;-696               if (isInProc == 0)  strcpy(ProcName, Symbol);
  4420                                  
  4421 000017A9 A0[0D00]                 mov al, [isInProc]
  4422 000017AC 3C00                     cmp al, 0
  4423 000017AE 0F851000                 jne .parse173
  4424 000017B2 8D063075                 lea  ax, [Symbol]
  4425 000017B6 50                       push ax
  4426 000017B7 8D066E75                 lea  ax, [ProcName]
  4427 000017BB 50                       push ax
  4428 000017BC E8B7EB                   call strcpy
  4429 000017BF 83C404                   add  sp, 4
  4430                                  
  4431                                  ;-697                 storeLabel();
  4432                                  
  4433                                  .parse173:
  4434 000017C2 E8AB01                   call storeLabel
  4435                                  
  4436                                  ;-698                 InputPtr++;//remove :
  4437                                  
  4438 000017C5 FF06[1400]               inc  word[InputPtr]
  4439                                  
  4440                                  ;-699                 getTokeType();
  4441                                  
  4442 000017C9 E89C00                   call getTokeType
  4443                                  
  4444                                  ;-700             }
  4445                                  
  4446                                  
  4447                                  ;-701         }
  4448                                  
  4449                                  .parse172:
  4450                                  
  4451                                  ;-702         if (TokeType == ALNUME) {
  4452                                  
  4453                                  .parse171:
  4454 000017CC A0[2C00]                 mov al, [TokeType]
  4455 000017CF 3C03                     cmp al, 3
  4456 000017D1 0F851B00                 jne .parse174
  4457                                  
  4458                                  ;-703             lookCode();// and OpCodePtr
  4459                                  
  4460 000017D5 E825FA                   call lookCode
  4461                                  
  4462                                  ;-704             if(CodeType) process();
  4463                                  
  4464 000017D8 A0[2F00]                 mov al, [CodeType]
  4465 000017DB 08C0                     or  al, al
  4466 000017DD 0F840600                 je .parse175
  4467 000017E1 E8A80D                   call process
  4468                                  
  4469                                  ;-705             else getVariable();
  4470                                  
  4471 000017E4 E90300                   jmp .parse176
  4472                                  .parse175:
  4473 000017E7 E88102                   call getVariable
  4474                                  
  4475                                  ;-706             skipRest();
  4476                                  
  4477                                  .parse176:
  4478 000017EA E8F504                   call skipRest
  4479                                  
  4480                                  ;-707         }
  4481                                  
  4482                                  
  4483                                  ;-708         else if (TokeType >ALNUME) error1("Label or instruction expected");
  4484                                  
  4485 000017ED E92700                   jmp .parse177
  4486                                  .parse174:
  4487 000017F0 A0[2C00]                 mov al, [TokeType]
  4488 000017F3 3C03                     cmp al, 3
  4489 000017F5 0F8E0C00                 jle .parse178
  4490 000017F9 68[2818]                 push parse_0
  4491 000017FC E87AF3                   call error1
  4492 000017FF 83C402                   add  sp, 2
  4493                                  
  4494                                  ;-709         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  4495                                  
  4496 00001802 E91200                   jmp .parse179
  4497                                  .parse178:
  4498 00001805 A0[2C00]                 mov al, [TokeType]
  4499 00001808 3C01                     cmp al, 1
  4500 0000180A 0F850900                 jne .parse180
  4501 0000180E 68[4618]                 push parse_1
  4502 00001811 E865F3                   call error1
  4503 00001814 83C402                   add  sp, 2
  4504                                  
  4505                                  ;-710         printLine();
  4506                                  
  4507                                  .parse180:
  4508                                  .parse179:
  4509                                  .parse177:
  4510 00001817 E80CF1                   call printLine
  4511                                  
  4512                                  ;-711     } while (DOS_NoBytes != 0 );
  4513                                  
  4514 0000181A A1[2000]                 mov ax, [DOS_NoBytes]
  4515 0000181D 83F800                   cmp ax, 0
  4516 00001820 0F840300                 je  .parse181
  4517 00001824 E94CFF                   jmp .parse170
  4518                                  .parse181:
  4519                                  
  4520                                  ;-712 }
  4521                                  
  4522                                  
  4523                                  ;-713 
  4524                                  
  4525                                  
  4526                                  ;-714 int getTokeType() {
  4527                                  
  4528 00001827 C3                       ret
  4529 00001828 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  4530 00001831 696E73747275637469-
  4531 0000183A 6F6E20657870656374-
  4532 00001843 656400             
  4533 00001846 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  4534 0000184F 616C6C6F7765642061-
  4535 00001858 74207374617274206F-
  4536 00001861 66206C696E6500     
  4537                                  ENDP
  4538                                  
  4539                                  getTokeType: PROC
  4540                                  
  4541                                  ;-715     char c;
  4542                                  
  4543                                  
  4544                                  ;-716     skipBlank();
  4545                                  
  4546                                  ;Function : getTokeType, Number of local variables: 1
  4547                                  ;   # type sign width addr used name   list of local variables
  4548                                  ;  200 var sign byte   715 NULL c = bp-2;
  4549 00001868 C8020000                 ENTER  2,0
  4550 0000186C E8D0E9                   call skipBlank
  4551                                  
  4552                                  ;-717     c = *InputPtr;
  4553                                  
  4554 0000186F 8B1E[1400]               mov bx, [InputPtr]
  4555 00001873 8A07                     mov al, [bx]
  4556 00001875 B400                     mov ah, 0
  4557 00001877 8846FE                   mov [bp-2], al
  4558                                  
  4559                                  ;-718     if (c == 0)   {TokeType=0; return; }//last line or empty line
  4560                                  
  4561 0000187A 8A46FE                   mov al, [bp-2]
  4562 0000187D 3C00                     cmp al, 0
  4563 0000187F 0F850900                 jne .getTokeType182
  4564 00001883 B80000                   mov ax, 0
  4565 00001886 A2[2C00]                 mov byte [TokeType], al
  4566 00001889 E96600                   jmp .retngetTokeType
  4567                                  
  4568                                  ;-719     if (c == ';') {TokeType=0; return; }//comment
  4569                                  
  4570                                  .getTokeType182:
  4571 0000188C 8A46FE                   mov al, [bp-2]
  4572 0000188F 3C3B                     cmp al, 59
  4573 00001891 0F850900                 jne .getTokeType183
  4574 00001895 B80000                   mov ax, 0
  4575 00001898 A2[2C00]                 mov byte [TokeType], al
  4576 0000189B E95400                   jmp .retngetTokeType
  4577                                  
  4578                                  ;-720     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  4579                                  
  4580                                  .getTokeType183:
  4581 0000189E 8A46FE                   mov al, byte [bp-2]
  4582 000018A1 B400                     mov ah, 0
  4583 000018A3 50                       push ax
  4584 000018A4 E87DEA                   call digit
  4585 000018A7 83C402                   add  sp, 2
  4586 000018AA 08C0                     or  al, al
  4587 000018AC 0F841500                 je .getTokeType184
  4588 000018B0 8A46FE                   mov al, byte [bp-2]
  4589 000018B3 B400                     mov ah, 0
  4590 000018B5 50                       push ax
  4591 000018B6 E8A7EB                   call getDigit
  4592 000018B9 83C402                   add  sp, 2
  4593 000018BC B80100                   mov ax, 1
  4594 000018BF A2[2C00]                 mov byte [TokeType], al
  4595 000018C2 E92D00                   jmp .retngetTokeType
  4596                                  
  4597                                  ;-721     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  4598                                  
  4599                                  .getTokeType184:
  4600 000018C5 8A46FE                   mov al, byte [bp-2]
  4601 000018C8 B400                     mov ah, 0
  4602 000018CA 50                       push ax
  4603 000018CB E89CE9                   call letterE
  4604 000018CE 83C402                   add  sp, 2
  4605 000018D1 08C0                     or  al, al
  4606 000018D3 0F841500                 je .getTokeType185
  4607 000018D7 8A46FE                   mov al, byte [bp-2]
  4608 000018DA B400                     mov ah, 0
  4609 000018DC 50                       push ax
  4610 000018DD E8D0EB                   call getName
  4611 000018E0 83C402                   add  sp, 2
  4612 000018E3 B80300                   mov ax, 3
  4613 000018E6 A2[2C00]                 mov byte [TokeType], al
  4614 000018E9 E90600                   jmp .retngetTokeType
  4615                                  
  4616                                  ;-722     TokeType=NOALNUME;
  4617                                  
  4618                                  .getTokeType185:
  4619 000018EC B80400                   mov ax, 4
  4620 000018EF A2[2C00]                 mov byte [TokeType], al
  4621                                  
  4622                                  ;-723 }
  4623                                  
  4624                                  
  4625                                  ;-724 
  4626                                  
  4627                                  
  4628                                  ;-725 int storeJmp() {
  4629                                  
  4630 000018F2 C9                       .retngetTokeType: LEAVE
  4631 000018F3 C3                       ret
  4632                                  ENDP
  4633                                  
  4634                                  storeJmp: PROC
  4635                                  
  4636                                  ;-726     unsigned int i;
  4637                                  
  4638                                  
  4639                                  ;-727     JmpMaxIx++;
  4640                                  
  4641                                  ;Function : storeJmp, Number of local variables: 1
  4642                                  ;   # type sign width addr used name   list of local variables
  4643                                  ;  200 var unsg word   726 NULL i = bp-2;
  4644 000018F4 C8020000                 ENTER  2,0
  4645 000018F8 FF06[5400]               inc  word[JmpMaxIx]
  4646                                  
  4647                                  ;-728     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");
  4648                                  
  4649 000018FC A1[5400]                 mov ax, [JmpMaxIx]
  4650 000018FF 3DC800                   cmp ax, 200 ;unsigned : 1
  4651 00001902 0F8C0900                 jl  .storeJmp186
  4652 00001906 68[5019]                 push storeJmp_0
  4653 00001909 E8C3F2                   call errorexit
  4654 0000190C 83C402                   add  sp, 2
  4655                                  
  4656                                  ;-729     JmpNamePtr=strcpy(JmpNamePtr, Symbol);
  4657                                  
  4658                                  .storeJmp186:
  4659 0000190F 8D063075                 lea  ax, [Symbol]
  4660 00001913 50                       push ax
  4661 00001914 FF36[5000]               push word [JmpNamePtr]
  4662 00001918 E85BEA                   call strcpy
  4663 0000191B 83C404                   add  sp, 4
  4664 0000191E A3[5000]                 mov word [JmpNamePtr], ax
  4665                                  
  4666                                  ;-730     JmpNamePtr++;
  4667                                  
  4668 00001921 FF06[5000]               inc  word[JmpNamePtr]
  4669                                  
  4670                                  ;-731     i = JmpNamePtr - &JmpNames;
  4671                                  
  4672 00001925 A1[5000]                 mov ax, [JmpNamePtr]
  4673 00001928 2D7A93                   sub ax, JmpNames
  4674 0000192B 8946FE                   mov [bp-2], ax
  4675                                  
  4676                                  ;-732     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");
  4677                                  
  4678 0000192E 8B46FE                   mov ax, [bp-2]
  4679 00001931 3D810F                   cmp ax, 3969 ;unsigned : 0
  4680 00001934 0F820900                 jb  .storeJmp187
  4681 00001938 68[5D19]                 push storeJmp_1
  4682 0000193B E891F2                   call errorexit
  4683 0000193E 83C402                   add  sp, 2
  4684                                  
  4685                                  ;-733     JmpAddr[JmpMaxIx] = PC;
  4686                                  
  4687                                  .storeJmp187:
  4688 00001941 A1[2300]                 mov ax, [PC]
  4689 00001944 8B1E[5400]               mov bx, [JmpMaxIx]
  4690 00001948 D1E3                     shl bx, 1
  4691 0000194A 89871AA3                 mov [JmpAddr+bx], ax
  4692                                  
  4693                                  ;-734 }
  4694                                  
  4695                                  
  4696                                  ;-735 
  4697                                  
  4698                                  
  4699                                  ;-736 int storeLabel() {
  4700 0000194E C9                       LEAVE
  4701 0000194F C3                       ret
  4702 00001950 746F6F206D616E7920-     storeJmp_0 db "too many Jmp",0
  4703 00001959 4A6D7000           
  4704 0000195D 746F6F206D616E7920-     storeJmp_1 db "too many Jmp names",0
  4705 00001966 4A6D70206E616D6573-
  4706 0000196F 00                 
  4707                                  ENDP
  4708                                  
  4709                                  storeLabel: PROC
  4710                                  
  4711                                  ;-737     unsigned int i;
  4712                                  
  4713                                  
  4714                                  ;-738     if(searchLabel()) error1("duplicate label");
  4715                                  
  4716                                  ;Function : storeLabel, Number of local variables: 1
  4717                                  ;   # type sign width addr used name   list of local variables
  4718                                  ;  200 var unsg word   737 NULL i = bp-2;
  4719 00001970 C8020000                 ENTER  2,0
  4720 00001974 E8A000                   call searchLabel
  4721 00001977 08C0                     or  al, al
  4722 00001979 0F840900                 je .storeLabel188
  4723 0000197D 68[E219]                 push storeLabel_0
  4724 00001980 E8F6F1                   call error1
  4725 00001983 83C402                   add  sp, 2
  4726                                  
  4727                                  ;-739     LabelMaxIx++;
  4728                                  
  4729                                  .storeLabel188:
  4730 00001986 FF06[4A00]               inc  word[LabelMaxIx]
  4731                                  
  4732                                  ;-740     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  4733                                  
  4734 0000198A A1[4A00]                 mov ax, [LabelMaxIx]
  4735 0000198D 3D5802                   cmp ax, 600 ;unsigned : 1
  4736 00001990 0F8C0900                 jl  .storeLabel189
  4737 00001994 68[F219]                 push storeLabel_1
  4738 00001997 E835F2                   call errorexit
  4739 0000199A 83C402                   add  sp, 2
  4740                                  
  4741                                  ;-741     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  4742                                  
  4743                                  .storeLabel189:
  4744 0000199D 8D063075                 lea  ax, [Symbol]
  4745 000019A1 50                       push ax
  4746 000019A2 FF36[4600]               push word [LabelNamePtr]
  4747 000019A6 E8CDE9                   call strcpy
  4748 000019A9 83C404                   add  sp, 4
  4749 000019AC A3[4600]                 mov word [LabelNamePtr], ax
  4750                                  
  4751                                  ;-742     LabelNamePtr++;
  4752                                  
  4753 000019AF FF06[4600]               inc  word[LabelNamePtr]
  4754                                  
  4755                                  ;-743     i = LabelNamePtr - &LabelNames;
  4756                                  
  4757 000019B3 A1[4600]                 mov ax, [LabelNamePtr]
  4758 000019B6 2D5A77                   sub ax, LabelNames
  4759 000019B9 8946FE                   mov [bp-2], ax
  4760                                  
  4761                                  ;-744     if (i >= LABELNAMESMAX) errorexit("too many label names");
  4762                                  
  4763 000019BC 8B46FE                   mov ax, [bp-2]
  4764 000019BF 3D5117                   cmp ax, 5969 ;unsigned : 0
  4765 000019C2 0F820900                 jb  .storeLabel190
  4766 000019C6 68[021A]                 push storeLabel_2
  4767 000019C9 E803F2                   call errorexit
  4768 000019CC 83C402                   add  sp, 2
  4769                                  
  4770                                  ;-745     LabelAddr[LabelMaxIx] = PC + Origin;
  4771                                  
  4772                                  .storeLabel190:
  4773 000019CF A1[2300]                 mov ax, [PC]
  4774 000019D2 0306[2500]               add ax, [Origin]
  4775 000019D6 8B1E[4A00]               mov bx, [LabelMaxIx]
  4776 000019DA D1E3                     shl bx, 1
  4777 000019DC 8987CA8E                 mov [LabelAddr+bx], ax
  4778                                  
  4779                                  ;-746 }
  4780                                  
  4781                                  
  4782                                  ;-747 
  4783                                  
  4784                                  
  4785                                  ;-748 int searchLabel() {
  4786 000019E0 C9                       LEAVE
  4787 000019E1 C3                       ret
  4788 000019E2 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  4789 000019EB 206C6162656C00     
  4790 000019F2 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  4791 000019FB 6C6162656C7300     
  4792 00001A02 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  4793 00001A0B 6C6162656C206E616D-
  4794 00001A14 657300             
  4795                                  ENDP
  4796                                  
  4797                                  searchLabel: PROC
  4798                                  
  4799                                  ;-749     int LIx; char *p;
  4800                                  
  4801                                  
  4802                                  ;-750     p = &LabelNames;
  4803                                  
  4804                                  ;Function : searchLabel, Number of local variables: 2
  4805                                  ;   # type sign width addr used name   list of local variables
  4806                                  ;  200 var sign word   749 NULL LIx = bp-2
  4807                                  ;  201 ptr sign byte   749 NULL p = bp-4;
  4808 00001A17 C8040000                 ENTER  4,0
  4809 00001A1B B85A77                   mov ax, LabelNames
  4810 00001A1E 8946FC                   mov [bp-4], ax
  4811                                  
  4812                                  ;-751     LIx = 1;
  4813                                  
  4814 00001A21 B80100                   mov ax, 1
  4815 00001A24 8946FE                   mov [bp-2], ax
  4816                                  
  4817                                  ;-752     while (LIx <= LabelMaxIx) {
  4818                                  
  4819                                  .searchLabel191:
  4820 00001A27 8B46FE                   mov ax, [bp-2]
  4821 00001A2A 3B06[4A00]               cmp ax, [LabelMaxIx]
  4822 00001A2E 0F8F3100                 jg  .searchLabel192
  4823                                  
  4824                                  ;-753         if (eqstr(p, Symbol)) return LIx;//pos of label
  4825                                  
  4826 00001A32 8D063075                 lea  ax, [Symbol]
  4827 00001A36 50                       push ax
  4828 00001A37 FF76FC                   push word [bp-4]
  4829 00001A3A E86FE9                   call eqstr
  4830 00001A3D 83C404                   add  sp, 4
  4831 00001A40 08C0                     or  al, al
  4832 00001A42 0F840600                 je .searchLabel193
  4833 00001A46 8B46FE                   mov ax, [bp-2]
  4834 00001A49 E91D00                   jmp .retnsearchLabel
  4835                                  
  4836                                  ;-754         p=strlen(p) + p;
  4837                                  
  4838                                  .searchLabel193:
  4839 00001A4C FF76FC                   push word [bp-4]
  4840 00001A4F E8FCE8                   call strlen
  4841 00001A52 83C402                   add  sp, 2
  4842 00001A55 0346FC                   add ax, [bp-4]
  4843 00001A58 8946FC                   mov [bp-4], ax
  4844                                  
  4845                                  ;-755         p++;
  4846                                  
  4847 00001A5B FF46FC                   inc  word[bp-4]
  4848                                  
  4849                                  ;-756         LIx++;
  4850                                  
  4851 00001A5E FF46FE                   inc  word[bp-2]
  4852                                  
  4853                                  ;-757     }
  4854                                  
  4855                                  
  4856                                  ;-758     return 0;
  4857                                  
  4858 00001A61 EBC4                     jmp .searchLabel191
  4859                                  .searchLabel192:
  4860 00001A63 B80000                   mov ax, 0
  4861 00001A66 E90000                   jmp .retnsearchLabel
  4862                                  
  4863                                  ;-759 }
  4864                                  
  4865                                  
  4866                                  ;-760 
  4867                                  
  4868                                  
  4869                                  ;-761 int getVariable() {
  4870                                  
  4871 00001A69 C9                       .retnsearchLabel: LEAVE
  4872 00001A6A C3                       ret
  4873                                  ENDP
  4874                                  
  4875                                  getVariable: PROC
  4876                                  
  4877                                  ;-762     char c;
  4878                                  
  4879                                  
  4880                                  ;-763     storeLabel();
  4881                                  
  4882                                  ;Function : getVariable, Number of local variables: 1
  4883                                  ;   # type sign width addr used name   list of local variables
  4884                                  ;  200 var sign byte   762 NULL c = bp-2;
  4885 00001A6B C8020000                 ENTER  2,0
  4886 00001A6F E8FEFE                   call storeLabel
  4887                                  
  4888                                  ;-764     getTokeType();
  4889                                  
  4890 00001A72 E8F3FD                   call getTokeType
  4891                                  
  4892                                  ;-765     if(TokeType==ALNUME) {//getName
  4893                                  
  4894 00001A75 A0[2C00]                 mov al, [TokeType]
  4895 00001A78 3C03                     cmp al, 3
  4896 00001A7A 0F857001                 jne .getVariable194
  4897                                  
  4898                                  ;-766         lookCode();
  4899                                  
  4900 00001A7E E87CF7                   call lookCode
  4901                                  
  4902                                  ;-767         if (CodeType < 200) dataexit();
  4903                                  
  4904 00001A81 A0[2F00]                 mov al, [CodeType]
  4905 00001A84 3CC8                     cmp al, 200
  4906 00001A86 0F8D0300                 jge .getVariable195
  4907 00001A8A E816F3                   call dataexit
  4908                                  
  4909                                  ;-768         if (CodeType > 205) dataexit();
  4910                                  
  4911                                  .getVariable195:
  4912 00001A8D A0[2F00]                 mov al, [CodeType]
  4913 00001A90 3CCD                     cmp al, 205
  4914 00001A92 0F8E0300                 jle .getVariable196
  4915 00001A96 E80AF3                   call dataexit
  4916                                  
  4917                                  ;-769         if (CodeType== 200) {//DB
  4918                                  
  4919                                  .getVariable196:
  4920 00001A99 A0[2F00]                 mov al, [CodeType]
  4921 00001A9C 3CC8                     cmp al, 200
  4922 00001A9E 0F856A00                 jne .getVariable197
  4923                                  
  4924                                  ;-770             do {
  4925                                  
  4926                                  .getVariable198:
  4927                                  
  4928                                  ;-771                 getTokeType();
  4929                                  
  4930 00001AA2 E8C3FD                   call getTokeType
  4931                                  
  4932                                  ;-772                 if (TokeType == DIGIT) genCode8(SymbolInt);
  4933                                  
  4934 00001AA5 A0[2C00]                 mov al, [TokeType]
  4935 00001AA8 3C01                     cmp al, 1
  4936 00001AAA 0F850D00                 jne .getVariable199
  4937 00001AAE FF36[0E00]               push word [SymbolInt]
  4938 00001AB2 E8B808                   call genCode8
  4939 00001AB5 83C402                   add  sp, 2
  4940                                  
  4941                                  ;-773                 else {
  4942                                  
  4943 00001AB8 E94100                   jmp .getVariable200
  4944                                  .getVariable199:
  4945                                  
  4946                                  ;-774                     skipBlank();
  4947                                  
  4948 00001ABB E881E7                   call skipBlank
  4949                                  
  4950                                  ;-775                     if (isToken('"')) {
  4951                                  
  4952 00001ABE 6A22                     push 34
  4953 00001AC0 E8B801                   call isToken
  4954 00001AC3 83C402                   add  sp, 2
  4955 00001AC6 08C0                     or  al, al
  4956 00001AC8 0F843000                 je .getVariable201
  4957                                  
  4958                                  ;-776                         do {
  4959                                  
  4960                                  .getVariable202:
  4961                                  
  4962                                  ;-777                             c= *InputPtr;
  4963                                  
  4964 00001ACC 8B1E[1400]               mov bx, [InputPtr]
  4965 00001AD0 8A07                     mov al, [bx]
  4966 00001AD2 B400                     mov ah, 0
  4967 00001AD4 8846FE                   mov [bp-2], al
  4968                                  
  4969                                  ;-778                             genCode8(c);
  4970                                  
  4971 00001AD7 8A46FE                   mov al, byte [bp-2]
  4972 00001ADA B400                     mov ah, 0
  4973 00001ADC 50                       push ax
  4974 00001ADD E88D08                   call genCode8
  4975 00001AE0 83C402                   add  sp, 2
  4976                                  
  4977                                  ;-779                             InputPtr++;
  4978                                  
  4979 00001AE3 FF06[1400]               inc  word[InputPtr]
  4980                                  
  4981                                  ;-780                         } while (*InputPtr != '"' );
  4982                                  
  4983 00001AE7 8B1E[1400]               mov bx, [InputPtr]
  4984 00001AEB 8A07                     mov al, [bx]
  4985 00001AED B400                     mov ah, 0
  4986 00001AEF 83F822                   cmp ax, 34
  4987 00001AF2 0F840200                 je  .getVariable203
  4988 00001AF6 EBD4                     jmp .getVariable202
  4989                                  .getVariable203:
  4990                                  
  4991                                  ;-781                         InputPtr++;
  4992                                  
  4993 00001AF8 FF06[1400]               inc  word[InputPtr]
  4994                                  
  4995                                  ;-782                     }
  4996                                  
  4997                                  
  4998                                  ;-783                 }
  4999                                  
  5000                                  .getVariable201:
  5001                                  
  5002                                  ;-784             } while (isToken(','));
  5003                                  
  5004                                  .getVariable200:
  5005 00001AFC 6A2C                     push 44
  5006 00001AFE E87A01                   call isToken
  5007 00001B01 83C402                   add  sp, 2
  5008 00001B04 08C0                     or  al, al
  5009 00001B06 0F840200                 je .getVariable204
  5010 00001B0A EB96                     jmp .getVariable198
  5011                                  .getVariable204:
  5012                                  
  5013                                  ;-785         }
  5014                                  
  5015                                  
  5016                                  ;-786         if (CodeType == 201) {//DW
  5017                                  
  5018                                  .getVariable197:
  5019 00001B0C A0[2F00]                 mov al, [CodeType]
  5020 00001B0F 3CC9                     cmp al, 201
  5021 00001B11 0F852600                 jne .getVariable205
  5022                                  
  5023                                  ;-787             do {
  5024                                  
  5025                                  .getVariable206:
  5026                                  
  5027                                  ;-788                 getTokeType();
  5028                                  
  5029 00001B15 E850FD                   call getTokeType
  5030                                  
  5031                                  ;-789                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  5032                                  
  5033 00001B18 A0[2C00]                 mov al, [TokeType]
  5034 00001B1B 3C01                     cmp al, 1
  5035 00001B1D 0F850A00                 jne .getVariable207
  5036 00001B21 FF36[0E00]               push word [SymbolInt]
  5037 00001B25 E8DC08                   call genCode16
  5038 00001B28 83C402                   add  sp, 2
  5039                                  
  5040                                  ;-790             } while (isToken(','));
  5041                                  
  5042                                  .getVariable207:
  5043 00001B2B 6A2C                     push 44
  5044 00001B2D E84B01                   call isToken
  5045 00001B30 83C402                   add  sp, 2
  5046 00001B33 08C0                     or  al, al
  5047 00001B35 0F840200                 je .getVariable208
  5048 00001B39 EBDA                     jmp .getVariable206
  5049                                  .getVariable208:
  5050                                  
  5051                                  ;-791         }
  5052                                  
  5053                                  
  5054                                  ;-792         if (CodeType == 202) {//DD
  5055                                  
  5056                                  .getVariable205:
  5057 00001B3B A0[2F00]                 mov al, [CodeType]
  5058 00001B3E 3CCA                     cmp al, 202
  5059 00001B40 0F852E00                 jne .getVariable209
  5060                                  
  5061                                  ;-793             do {
  5062                                  
  5063                                  .getVariable210:
  5064                                  
  5065                                  ;-794                 getTokeType();
  5066                                  
  5067 00001B44 E821FD                   call getTokeType
  5068                                  
  5069                                  ;-795                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  5070                                  
  5071 00001B47 A0[2C00]                 mov al, [TokeType]
  5072 00001B4A 3C01                     cmp al, 1
  5073 00001B4C 0F851200                 jne .getVariable211
  5074 00001B50 FF36[0E00]               push word [SymbolInt]
  5075 00001B54 E8AD08                   call genCode16
  5076 00001B57 83C402                   add  sp, 2
  5077                                  
  5078                                  ;-796                                     genCode16(0);}//todo genCode32(SymbolLong);
  5079                                  
  5080 00001B5A 6A00                     push 0
  5081 00001B5C E8A508                   call genCode16
  5082 00001B5F 83C402                   add  sp, 2
  5083                                  
  5084                                  ;-797             } while (isToken(','));
  5085                                  
  5086                                  .getVariable211:
  5087 00001B62 6A2C                     push 44
  5088 00001B64 E81401                   call isToken
  5089 00001B67 83C402                   add  sp, 2
  5090 00001B6A 08C0                     or  al, al
  5091 00001B6C 0F840200                 je .getVariable212
  5092 00001B70 EBD2                     jmp .getVariable210
  5093                                  .getVariable212:
  5094                                  
  5095                                  ;-798         }
  5096                                  
  5097                                  
  5098                                  ;-799         if (CodeType >= 203) {//resb, resw, resd
  5099                                  
  5100                                  .getVariable209:
  5101 00001B72 A0[2F00]                 mov al, [CodeType]
  5102 00001B75 3CCB                     cmp al, 203 ;unsigned : 1
  5103 00001B77 0F8C7000                 jl  .getVariable213
  5104                                  
  5105                                  ;-800             getTokeType();
  5106                                  
  5107 00001B7B E8EAFC                   call getTokeType
  5108                                  
  5109                                  ;-801             if (TokeType == DIGIT) {
  5110                                  
  5111 00001B7E A0[2C00]                 mov al, [TokeType]
  5112 00001B81 3C01                     cmp al, 1
  5113 00001B83 0F856100                 jne .getVariable214
  5114                                  
  5115                                  ;-802                 if (SymbolInt <= 0) syntaxerror();
  5116                                  
  5117 00001B87 A1[0E00]                 mov ax, [SymbolInt]
  5118 00001B8A 83F800                   cmp ax, 0
  5119 00001B8D 0F870300                 ja  .getVariable215
  5120 00001B91 E8E4F1                   call syntaxerror
  5121                                  
  5122                                  ;-803                 if (AbsoluteLab == 0) error1("Absolute is null");
  5123                                  
  5124                                  .getVariable215:
  5125 00001B94 A1[2700]                 mov ax, [AbsoluteLab]
  5126 00001B97 83F800                   cmp ax, 0
  5127 00001B9A 0F850900                 jne .getVariable216
  5128 00001B9E 68[F31B]                 push getVariable_0
  5129 00001BA1 E8D5EF                   call error1
  5130 00001BA4 83C402                   add  sp, 2
  5131                                  
  5132                                  ;-804                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  5133                                  
  5134                                  .getVariable216:
  5135 00001BA7 A1[2700]                 mov ax, [AbsoluteLab]
  5136 00001BAA 8B1E[4A00]               mov bx, [LabelMaxIx]
  5137 00001BAE D1E3                     shl bx, 1
  5138 00001BB0 8987CA8E                 mov [LabelAddr+bx], ax
  5139                                  
  5140                                  ;-805                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  5141                                  
  5142 00001BB4 A0[2F00]                 mov al, [CodeType]
  5143 00001BB7 3CCC                     cmp al, 204
  5144 00001BB9 0F850A00                 jne .getVariable217
  5145 00001BBD A1[0E00]                 mov ax, [SymbolInt]
  5146 00001BC0 0306[0E00]               add ax, [SymbolInt]
  5147 00001BC4 A3[0E00]                 mov word [SymbolInt], ax
  5148                                  
  5149                                  ;-806                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  5150                                  
  5151                                  .getVariable217:
  5152 00001BC7 A0[2F00]                 mov al, [CodeType]
  5153 00001BCA 3CCD                     cmp al, 205
  5154 00001BCC 0F850B00                 jne .getVariable218
  5155 00001BD0 A1[0E00]                 mov ax, [SymbolInt]
  5156 00001BD3 BB0400                   mov bx, 4
  5157 00001BD6 F7E3                     mul bx
  5158 00001BD8 A3[0E00]                 mov word [SymbolInt], ax
  5159                                  
  5160                                  ;-807                 AbsoluteLab = AbsoluteLab + SymbolInt;
  5161                                  
  5162                                  .getVariable218:
  5163 00001BDB A1[2700]                 mov ax, [AbsoluteLab]
  5164 00001BDE 0306[0E00]               add ax, [SymbolInt]
  5165 00001BE2 A3[2700]                 mov word [AbsoluteLab], ax
  5166                                  
  5167                                  ;-808             } else numbererror();
  5168                                  
  5169 00001BE5 E90300                   jmp .getVariable219
  5170                                  .getVariable214:
  5171 00001BE8 E8FAF0                   call numbererror
  5172                                  
  5173                                  ;-809         }
  5174                                  
  5175                                  .getVariable219:
  5176                                  
  5177                                  ;-810     }
  5178                                  
  5179                                  .getVariable213:
  5180                                  
  5181                                  ;-811     else dataexit();
  5182                                  
  5183 00001BEB E90300                   jmp .getVariable220
  5184                                  .getVariable194:
  5185 00001BEE E8B2F1                   call dataexit
  5186                                  
  5187                                  ;-812 }
  5188                                  
  5189                                  .getVariable220:
  5190                                  
  5191                                  ;-813 
  5192                                  
  5193                                  
  5194                                  ;-814 int getCodeSize() {
  5195 00001BF1 C9                       LEAVE
  5196 00001BF2 C3                       ret
  5197 00001BF3 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  5198 00001BFC 6973206E756C6C00   
  5199                                  ENDP
  5200                                  
  5201                                  getCodeSize: PROC
  5202                                  
  5203                                  ;-815     if (TokeType ==ALNUME) {
  5204                                  
  5205 00001C04 A0[2C00]                 mov al, [TokeType]
  5206 00001C07 3C03                     cmp al, 3
  5207 00001C09 0F855700                 jne .getCodeSize221
  5208                                  
  5209                                  ;-816         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  5210                                  
  5211 00001C0D 68[6B1C]                 push getCodeSize_0
  5212 00001C10 8D064F75                 lea  ax, [SymbolUpper]
  5213 00001C14 50                       push ax
  5214 00001C15 E894E7                   call eqstr
  5215 00001C18 83C404                   add  sp, 4
  5216 00001C1B 08C0                     or  al, al
  5217 00001C1D 0F840900                 je .getCodeSize222
  5218 00001C21 E844FC                   call getTokeType
  5219 00001C24 B80100                   mov ax, 1
  5220 00001C27 E94000                   jmp .retngetCodeSize
  5221                                  
  5222                                  ;-817         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  5223                                  
  5224                                  .getCodeSize222:
  5225 00001C2A 68[701C]                 push getCodeSize_1
  5226 00001C2D 8D064F75                 lea  ax, [SymbolUpper]
  5227 00001C31 50                       push ax
  5228 00001C32 E877E7                   call eqstr
  5229 00001C35 83C404                   add  sp, 4
  5230 00001C38 08C0                     or  al, al
  5231 00001C3A 0F840900                 je .getCodeSize223
  5232 00001C3E E827FC                   call getTokeType
  5233 00001C41 B80200                   mov ax, 2
  5234 00001C44 E92300                   jmp .retngetCodeSize
  5235                                  
  5236                                  ;-818         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  5237                                  
  5238                                  .getCodeSize223:
  5239 00001C47 68[751C]                 push getCodeSize_2
  5240 00001C4A 8D064F75                 lea  ax, [SymbolUpper]
  5241 00001C4E 50                       push ax
  5242 00001C4F E85AE7                   call eqstr
  5243 00001C52 83C404                   add  sp, 4
  5244 00001C55 08C0                     or  al, al
  5245 00001C57 0F840900                 je .getCodeSize224
  5246 00001C5B E80AFC                   call getTokeType
  5247 00001C5E B80300                   mov ax, 3
  5248 00001C61 E90600                   jmp .retngetCodeSize
  5249                                  
  5250                                  ;-819     }
  5251                                  
  5252                                  .getCodeSize224:
  5253                                  
  5254                                  ;-820     return 0;
  5255                                  
  5256                                  .getCodeSize221:
  5257 00001C64 B80000                   mov ax, 0
  5258 00001C67 E90000                   jmp .retngetCodeSize
  5259                                  
  5260                                  ;-821 }
  5261                                  
  5262                                  
  5263                                  ;-822 int isToken(char c) {
  5264                                  
  5265                                   .retngetCodeSize:
  5266 00001C6A C3                       ret
  5267 00001C6B 4259544500              getCodeSize_0 db "BYTE",0
  5268 00001C70 574F524400              getCodeSize_1 db "WORD",0
  5269 00001C75 44574F524400            getCodeSize_2 db "DWORD",0
  5270                                  ENDP
  5271                                  
  5272                                  isToken: PROC
  5273                                  
  5274                                  ;-823     skipBlank();
  5275                                  
  5276                                  ;Function : isToken, Number of local variables: 1
  5277                                  ;   # type sign width addr used name   list of local variables
  5278                                  ;  200 var sign byte   822 NULL c = bp+4;
  5279 00001C7B C8000000                 ENTER  0,0
  5280 00001C7F E8BDE5                   call skipBlank
  5281                                  
  5282                                  ;-824     if (*InputPtr == c) {
  5283                                  
  5284 00001C82 8B1E[1400]               mov bx, [InputPtr]
  5285 00001C86 8A07                     mov al, [bx]
  5286 00001C88 B400                     mov ah, 0
  5287 00001C8A 3A4604                   cmp al, [bp+4]
  5288 00001C8D 0F850A00                 jne .isToken225
  5289                                  
  5290                                  ;-825         InputPtr++;
  5291                                  
  5292 00001C91 FF06[1400]               inc  word[InputPtr]
  5293                                  
  5294                                  ;-826         return 1;
  5295                                  
  5296 00001C95 B80100                   mov ax, 1
  5297 00001C98 E90600                   jmp .retnisToken
  5298                                  
  5299                                  ;-827         }
  5300                                  
  5301                                  
  5302                                  ;-828     return 0;
  5303                                  
  5304                                  .isToken225:
  5305 00001C9B B80000                   mov ax, 0
  5306 00001C9E E90000                   jmp .retnisToken
  5307                                  
  5308                                  ;-829 }
  5309                                  
  5310                                  
  5311                                  ;-830 int need(char c) {
  5312                                  
  5313 00001CA1 C9                       .retnisToken: LEAVE
  5314 00001CA2 C3                       ret
  5315                                  ENDP
  5316                                  
  5317                                  need: PROC
  5318                                  
  5319                                  ;-831     if (isToken(c)) {
  5320                                  
  5321                                  ;Function : need, Number of local variables: 1
  5322                                  ;   # type sign width addr used name   list of local variables
  5323                                  ;  200 var sign byte   830 NULL c = bp+4;
  5324 00001CA3 C8000000                 ENTER  0,0
  5325 00001CA7 8A4604                   mov al, byte [bp+4]
  5326 00001CAA B400                     mov ah, 0
  5327 00001CAC 50                       push ax
  5328 00001CAD E8CBFF                   call isToken
  5329 00001CB0 83C402                   add  sp, 2
  5330 00001CB3 08C0                     or  al, al
  5331 00001CB5 0F840600                 je .need226
  5332                                  
  5333                                  ;-832         getTokeType();
  5334                                  
  5335 00001CB9 E8ACFB                   call getTokeType
  5336                                  
  5337                                  ;-833         return;
  5338                                  
  5339 00001CBC E91800                   jmp .retnneed
  5340                                  
  5341                                  ;-834         }
  5342                                  
  5343                                  
  5344                                  ;-835     error1();
  5345                                  
  5346                                  .need226:
  5347 00001CBF E8B7EE                   call error1
  5348                                  
  5349                                  ;-836     prs(". need: ");
  5350                                  
  5351 00001CC2 68[D91C]                 push need_0
  5352 00001CC5 E85FED                   call prs
  5353 00001CC8 83C402                   add  sp, 2
  5354                                  
  5355                                  ;-837     prc(c);
  5356                                  
  5357 00001CCB 8A4604                   mov al, byte [bp+4]
  5358 00001CCE B400                     mov ah, 0
  5359 00001CD0 50                       push ax
  5360 00001CD1 E8FBEC                   call prc
  5361 00001CD4 83C402                   add  sp, 2
  5362                                  
  5363                                  ;-838 }
  5364                                  
  5365                                  
  5366                                  ;-839 int skipRest() {
  5367                                  
  5368 00001CD7 C9                       .retnneed: LEAVE
  5369 00001CD8 C3                       ret
  5370 00001CD9 2E206E6565643A2000      need_0 db ". need: ",0
  5371                                  ENDP
  5372                                  
  5373                                  skipRest: PROC
  5374                                  
  5375                                  ;-840     getTokeType();
  5376                                  
  5377 00001CE2 E883FB                   call getTokeType
  5378                                  
  5379                                  ;-841     if(TokeType)error1("extra char ignored");
  5380                                  
  5381 00001CE5 A0[2C00]                 mov al, [TokeType]
  5382 00001CE8 08C0                     or  al, al
  5383 00001CEA 0F840900                 je .skipRest227
  5384 00001CEE 68[F81C]                 push skipRest_0
  5385 00001CF1 E885EE                   call error1
  5386 00001CF4 83C402                   add  sp, 2
  5387                                  
  5388                                  ;-842 }
  5389                                  
  5390                                  .skipRest227:
  5391                                  
  5392                                  ;-843 
  5393                                  
  5394                                  
  5395                                  ;-844 
  5396                                  
  5397                                  
  5398                                  ;-845 
  5399                                  
  5400                                  
  5401                                  ;-846 int getarg() {
  5402                                  
  5403 00001CF7 C3                       ret
  5404 00001CF8 657874726120636861-     skipRest_0 db "extra char ignored",0
  5405 00001D01 722069676E6F726564-
  5406 00001D0A 00                 
  5407                                  ENDP
  5408                                  
  5409                                  getarg: PROC
  5410                                  
  5411                                  ;-847     int arglen1; int i; char *c;
  5412                                  
  5413                                  
  5414                                  ;-848     arglen1=*arglen;
  5415                                  
  5416                                  ;Function : getarg, Number of local variables: 3
  5417                                  ;   # type sign width addr used name   list of local variables
  5418                                  ;  200 var sign word   847 NULL arglen1 = bp-2
  5419                                  ;  201 var sign word   847 NULL i = bp-4
  5420                                  ;  202 ptr sign byte   847 NULL c = bp-6;
  5421 00001D0B C8060000                 ENTER  6,0
  5422 00001D0F 8B1E[5A00]               mov bx, [arglen]
  5423 00001D13 8A07                     mov al, [bx]
  5424 00001D15 B400                     mov ah, 0
  5425 00001D17 8946FE                   mov [bp-2], ax
  5426                                  
  5427                                  ;-849     if (arglen1==0) {
  5428                                  
  5429 00001D1A 8B46FE                   mov ax, [bp-2]
  5430 00001D1D 83F800                   cmp ax, 0
  5431 00001D20 0F851C00                 jne .getarg228
  5432                                  
  5433                                  ;-850         cputs(Version1);
  5434                                  
  5435 00001D24 8D06[0300]               lea  ax, [Version1]
  5436 00001D28 50                       push ax
  5437 00001D29 E853E3                   call cputs
  5438 00001D2C 83C402                   add  sp, 2
  5439                                  
  5440                                  ;-851         cputs(", Usage: AS.COM filename [w/o .S] : ");
  5441                                  
  5442 00001D2F 68[BB1E]                 push getarg_0
  5443 00001D32 E84AE3                   call cputs
  5444 00001D35 83C402                   add  sp, 2
  5445                                  
  5446                                  ;-852         exitR(3);
  5447                                  
  5448 00001D38 6A03                     push 3
  5449 00001D3A E8A9E3                   call exitR
  5450 00001D3D 83C402                   add  sp, 2
  5451                                  
  5452                                  ;-853     }
  5453                                  
  5454                                  
  5455                                  ;-854     i=arglen1+129;
  5456                                  
  5457                                  .getarg228:
  5458 00001D40 8B46FE                   mov ax, [bp-2]
  5459 00001D43 058100                   add ax, 129
  5460 00001D46 8946FC                   mov [bp-4], ax
  5461                                  
  5462                                  ;-855     *i=0;
  5463                                  
  5464 00001D49 B80000                   mov ax, 0
  5465 00001D4C 8B5EFC                   mov  bx, [bp-4]
  5466 00001D4F 8907                     mov  [bx], ax
  5467                                  
  5468                                  ;-856     arglen1--;
  5469                                  
  5470 00001D51 FF4EFE                   dec  word[bp-2]
  5471                                  
  5472                                  ;-857     toupper(argv);
  5473                                  
  5474 00001D54 FF36[5C00]               push word [argv]
  5475 00001D58 E8C2E6                   call toupper
  5476 00001D5B 83C402                   add  sp, 2
  5477                                  
  5478                                  ;-858 
  5479                                  
  5480                                  
  5481                                  ;-859     strcpy(namein, argv); strcat1(namein, ".S");
  5482                                  
  5483 00001D5E FF36[5C00]               push word [argv]
  5484 00001D62 8D068C76                 lea  ax, [namein]
  5485 00001D66 50                       push ax
  5486 00001D67 E80CE6                   call strcpy
  5487 00001D6A 83C404                   add  sp, 4
  5488 00001D6D 68[E01E]                 push getarg_1
  5489 00001D70 8D068C76                 lea  ax, [namein]
  5490 00001D74 50                       push ax
  5491 00001D75 E880E6                   call strcat1
  5492 00001D78 83C404                   add  sp, 4
  5493                                  
  5494                                  ;-860     strcpy(namelst,argv); strcat1(namelst,".LST");
  5495                                  
  5496 00001D7B FF36[5C00]               push word [argv]
  5497 00001D7F 8D06CF76                 lea  ax, [namelst]
  5498 00001D83 50                       push ax
  5499 00001D84 E8EFE5                   call strcpy
  5500 00001D87 83C404                   add  sp, 4
  5501 00001D8A 68[E31E]                 push getarg_2
  5502 00001D8D 8D06CF76                 lea  ax, [namelst]
  5503 00001D91 50                       push ax
  5504 00001D92 E863E6                   call strcat1
  5505 00001D95 83C404                   add  sp, 4
  5506                                  
  5507                                  ;-861     strcpy(namebin,argv); strcat1(namebin,".COM");
  5508                                  
  5509 00001D98 FF36[5C00]               push word [argv]
  5510 00001D9C 8D061277                 lea  ax, [namebin]
  5511 00001DA0 50                       push ax
  5512 00001DA1 E8D2E5                   call strcpy
  5513 00001DA4 83C404                   add  sp, 4
  5514 00001DA7 68[E81E]                 push getarg_3
  5515 00001DAA 8D061277                 lea  ax, [namebin]
  5516 00001DAE 50                       push ax
  5517 00001DAF E846E6                   call strcat1
  5518 00001DB2 83C404                   add  sp, 4
  5519                                  
  5520                                  ;-862 
  5521                                  
  5522                                  
  5523                                  ;-863   DOS_ERR=0; PC=0; ErrorCount=0;
  5524                                  
  5525 00001DB5 B80000                   mov ax, 0
  5526 00001DB8 A3[1C00]                 mov word [DOS_ERR], ax
  5527 00001DBB B80000                   mov ax, 0
  5528 00001DBE A3[2300]                 mov word [PC], ax
  5529 00001DC1 B80000                   mov ax, 0
  5530 00001DC4 A3[1E00]                 mov word [ErrorCount], ax
  5531                                  
  5532                                  ;-864 
  5533                                  
  5534                                  
  5535                                  ;-865     asm_fd=openR (namein);
  5536                                  
  5537 00001DC7 8D068C76                 lea  ax, [namein]
  5538 00001DCB 50                       push ax
  5539 00001DCC E8E7E2                   call openR
  5540 00001DCF 83C402                   add  sp, 2
  5541 00001DD2 A3[1600]                 mov word [asm_fd], ax
  5542                                  
  5543                                  ;-866     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  5544                                  
  5545 00001DD5 A1[1C00]                 mov ax, [DOS_ERR]
  5546 00001DD8 08C0                     or  al, al
  5547 00001DDA 0F841C00                 je .getarg229
  5548 00001DDE 68[ED1E]                 push getarg_4
  5549 00001DE1 E89BE2                   call cputs
  5550 00001DE4 83C402                   add  sp, 2
  5551 00001DE7 8D068C76                 lea  ax, [namein]
  5552 00001DEB 50                       push ax
  5553 00001DEC E890E2                   call cputs
  5554 00001DEF 83C402                   add  sp, 2
  5555 00001DF2 6A01                     push 1
  5556 00001DF4 E8EFE2                   call exitR
  5557 00001DF7 83C402                   add  sp, 2
  5558                                  
  5559                                  ;-867     lst_fd=creatR(namelst);
  5560                                  
  5561                                  .getarg229:
  5562 00001DFA 8D06CF76                 lea  ax, [namelst]
  5563 00001DFE 50                       push ax
  5564 00001DFF E8C3E2                   call creatR
  5565 00001E02 83C402                   add  sp, 2
  5566 00001E05 A3[1800]                 mov word [lst_fd], ax
  5567                                  
  5568                                  ;-868     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5569                                  
  5570 00001E08 A1[1C00]                 mov ax, [DOS_ERR]
  5571 00001E0B 08C0                     or  al, al
  5572 00001E0D 0F841C00                 je .getarg230
  5573 00001E11 68[031F]                 push getarg_5
  5574 00001E14 E868E2                   call cputs
  5575 00001E17 83C402                   add  sp, 2
  5576 00001E1A 8D06CF76                 lea  ax, [namelst]
  5577 00001E1E 50                       push ax
  5578 00001E1F E85DE2                   call cputs
  5579 00001E22 83C402                   add  sp, 2
  5580 00001E25 6A02                     push 2
  5581 00001E27 E8BCE2                   call exitR
  5582 00001E2A 83C402                   add  sp, 2
  5583                                  
  5584                                  ;-869     bin_fd=creatR(namebin);
  5585                                  
  5586                                  .getarg230:
  5587 00001E2D 8D061277                 lea  ax, [namebin]
  5588 00001E31 50                       push ax
  5589 00001E32 E890E2                   call creatR
  5590 00001E35 83C402                   add  sp, 2
  5591 00001E38 A3[1A00]                 mov word [bin_fd], ax
  5592                                  
  5593                                  ;-870     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5594                                  
  5595 00001E3B A1[1C00]                 mov ax, [DOS_ERR]
  5596 00001E3E 08C0                     or  al, al
  5597 00001E40 0F841C00                 je .getarg231
  5598 00001E44 68[1A1F]                 push getarg_6
  5599 00001E47 E835E2                   call cputs
  5600 00001E4A 83C402                   add  sp, 2
  5601 00001E4D 8D061277                 lea  ax, [namebin]
  5602 00001E51 50                       push ax
  5603 00001E52 E82AE2                   call cputs
  5604 00001E55 83C402                   add  sp, 2
  5605 00001E58 6A02                     push 2
  5606 00001E5A E889E2                   call exitR
  5607 00001E5D 83C402                   add  sp, 2
  5608                                  
  5609                                  ;-871 
  5610                                  
  5611                                  
  5612                                  ;-872     prs(";");
  5613                                  
  5614                                  .getarg231:
  5615 00001E60 68[301F]                 push getarg_7
  5616 00001E63 E8C1EB                   call prs
  5617 00001E66 83C402                   add  sp, 2
  5618                                  
  5619                                  ;-873     prs(Version1);
  5620                                  
  5621 00001E69 8D06[0300]               lea  ax, [Version1]
  5622 00001E6D 50                       push ax
  5623 00001E6E E8B6EB                   call prs
  5624 00001E71 83C402                   add  sp, 2
  5625                                  
  5626                                  ;-874     prs(", Source: "); prs(namein);
  5627                                  
  5628 00001E74 68[321F]                 push getarg_8
  5629 00001E77 E8ADEB                   call prs
  5630 00001E7A 83C402                   add  sp, 2
  5631 00001E7D 8D068C76                 lea  ax, [namein]
  5632 00001E81 50                       push ax
  5633 00001E82 E8A2EB                   call prs
  5634 00001E85 83C402                   add  sp, 2
  5635                                  
  5636                                  ;-875     prs(", Output: "); prs(namelst);
  5637                                  
  5638 00001E88 68[3D1F]                 push getarg_9
  5639 00001E8B E899EB                   call prs
  5640 00001E8E 83C402                   add  sp, 2
  5641 00001E91 8D06CF76                 lea  ax, [namelst]
  5642 00001E95 50                       push ax
  5643 00001E96 E88EEB                   call prs
  5644 00001E99 83C402                   add  sp, 2
  5645                                  
  5646                                  ;-876     prs(", "); prs(namebin);
  5647                                  
  5648 00001E9C 68[481F]                 push getarg_10
  5649 00001E9F E885EB                   call prs
  5650 00001EA2 83C402                   add  sp, 2
  5651 00001EA5 8D061277                 lea  ax, [namebin]
  5652 00001EA9 50                       push ax
  5653 00001EAA E87AEB                   call prs
  5654 00001EAD 83C402                   add  sp, 2
  5655                                  
  5656                                  ;-877     prs("\n");
  5657                                  
  5658 00001EB0 68[4B1F]                 push getarg_11
  5659 00001EB3 E871EB                   call prs
  5660 00001EB6 83C402                   add  sp, 2
  5661                                  
  5662                                  ;-878 }
  5663                                  
  5664                                  
  5665                                  ;-879 
  5666                                  
  5667                                  
  5668                                  ;-880 int fixJmp() {   
  5669 00001EB9 C9                       LEAVE
  5670 00001EBA C3                       ret
  5671 00001EBB 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5672 00001EC4 41532E434F4D206669-
  5673 00001ECD 6C656E616D65205B77-
  5674 00001ED6 2F6F202E535D203A20-
  5675 00001EDF 00                 
  5676 00001EE0 2E5300                  getarg_1 db ".S",0
  5677 00001EE3 2E4C535400              getarg_2 db ".LST",0
  5678 00001EE8 2E434F4D00              getarg_3 db ".COM",0
  5679 00001EED 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5680 00001EF6 6C65206D697373696E-
  5681 00001EFF 673A2000           
  5682 00001F03 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5683 00001F0C 206E6F742063726561-
  5684 00001F15 74653A2000         
  5685 00001F1A 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5686 00001F23 6E6F74206372656174-
  5687 00001F2C 653A2000           
  5688 00001F30 3B00                    getarg_7 db ";",0
  5689 00001F32 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5690 00001F3B 2000               
  5691 00001F3D 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5692 00001F46 2000               
  5693 00001F48 2C2000                  getarg_10 db ", ",0
  5694 00001F4B 5C6E00                  getarg_11 db "\n",0
  5695                                  ENDP
  5696                                  
  5697                                  fixJmp: PROC
  5698                                  
  5699                                  ;-881     unsigned int hex; int i;
  5700                                  
  5701                                  
  5702                                  ;-882     char *p; int Ix; char c;
  5703                                  
  5704                                  
  5705                                  ;-883     prs("\n;jmp to fix:");
  5706                                  
  5707                                  ;Function : fixJmp, Number of local variables: 5
  5708                                  ;   # type sign width addr used name   list of local variables
  5709                                  ;  200 var unsg word   881 NULL hex = bp-2
  5710                                  ;  201 var sign word   881 NULL i = bp-4
  5711                                  ;  202 ptr sign byte   882 NULL p = bp-6
  5712                                  ;  203 var sign word   882 NULL Ix = bp-8
  5713                                  ;  204 var sign byte   882 NULL c = bp-10;
  5714 00001F4E C80A0000                 ENTER  10,0
  5715 00001F52 68[7E20]                 push fixJmp_0
  5716 00001F55 E8CFEA                   call prs
  5717 00001F58 83C402                   add  sp, 2
  5718                                  
  5719                                  ;-884     printIntU(JmpMaxIx);
  5720                                  
  5721 00001F5B FF36[5400]               push word [JmpMaxIx]
  5722 00001F5F E8D5EB                   call printIntU
  5723 00001F62 83C402                   add  sp, 2
  5724                                  
  5725                                  ;-885     p = &JmpNames;
  5726                                  
  5727 00001F65 B87A93                   mov ax, JmpNames
  5728 00001F68 8946FA                   mov [bp-6], ax
  5729                                  
  5730                                  ;-886     i = 1;
  5731                                  
  5732 00001F6B B80100                   mov ax, 1
  5733 00001F6E 8946FC                   mov [bp-4], ax
  5734                                  
  5735                                  ;-887     while (i <= JmpMaxIx) {
  5736                                  
  5737                                  .fixJmp232:
  5738 00001F71 8B46FC                   mov ax, [bp-4]
  5739 00001F74 3B06[5400]               cmp ax, [JmpMaxIx]
  5740 00001F78 0F8F0001                 jg  .fixJmp233
  5741                                  
  5742                                  ;-888         strcpy(Symbol, p);
  5743                                  
  5744 00001F7C FF76FA                   push word [bp-6]
  5745 00001F7F 8D063075                 lea  ax, [Symbol]
  5746 00001F83 50                       push ax
  5747 00001F84 E8EFE3                   call strcpy
  5748 00001F87 83C404                   add  sp, 4
  5749                                  
  5750                                  ;-889         p = strlen(Symbol) + p;
  5751                                  
  5752 00001F8A 8D063075                 lea  ax, [Symbol]
  5753 00001F8E 50                       push ax
  5754 00001F8F E8BCE3                   call strlen
  5755 00001F92 83C402                   add  sp, 2
  5756 00001F95 0346FA                   add ax, [bp-6]
  5757 00001F98 8946FA                   mov [bp-6], ax
  5758                                  
  5759                                  ;-890         p++;
  5760                                  
  5761 00001F9B FF46FA                   inc  word[bp-6]
  5762                                  
  5763                                  ;-891         hex = JmpAddr[i];
  5764                                  
  5765 00001F9E 8B5EFC                   mov bx, [bp-4]
  5766 00001FA1 D1E3                     shl bx, 1
  5767 00001FA3 8B871AA3                 mov ax, [JmpAddr + bx]
  5768 00001FA7 8946FE                   mov [bp-2], ax
  5769                                  
  5770                                  ;-892         prs("\n"); printIntU(i);
  5771                                  
  5772 00001FAA 68[8D20]                 push fixJmp_1
  5773 00001FAD E877EA                   call prs
  5774 00001FB0 83C402                   add  sp, 2
  5775 00001FB3 FF76FC                   push word [bp-4]
  5776 00001FB6 E87EEB                   call printIntU
  5777 00001FB9 83C402                   add  sp, 2
  5778                                  
  5779                                  ;-893         prs(". "); prs(Symbol); prs(",from:");
  5780                                  
  5781 00001FBC 68[9020]                 push fixJmp_2
  5782 00001FBF E865EA                   call prs
  5783 00001FC2 83C402                   add  sp, 2
  5784 00001FC5 8D063075                 lea  ax, [Symbol]
  5785 00001FC9 50                       push ax
  5786 00001FCA E85AEA                   call prs
  5787 00001FCD 83C402                   add  sp, 2
  5788 00001FD0 68[9320]                 push fixJmp_3
  5789 00001FD3 E851EA                   call prs
  5790 00001FD6 83C402                   add  sp, 2
  5791                                  
  5792                                  ;-894         printhex16(hex);
  5793                                  
  5794 00001FD9 FF76FE                   push word [bp-2]
  5795 00001FDC E82EEB                   call printhex16
  5796 00001FDF 83C402                   add  sp, 2
  5797                                  
  5798                                  ;-895         
  5799                                  
  5800                                  
  5801                                  ;-896         Ix=searchLabel();
  5802                                  
  5803 00001FE2 E832FA                   call searchLabel
  5804 00001FE5 8946F8                   mov [bp-8], ax
  5805                                  
  5806                                  ;-897         if (Ix == 0) notfounderror();
  5807                                  
  5808 00001FE8 8B46F8                   mov ax, [bp-8]
  5809 00001FEB 83F800                   cmp ax, 0
  5810 00001FEE 0F850300                 jne .fixJmp234
  5811 00001FF2 E8F4EB                   call notfounderror
  5812                                  
  5813                                  ;-898         disp = LabelAddr[Ix];   
  5814                                  
  5815                                  .fixJmp234:
  5816 00001FF5 8B5EF8                   mov bx, [bp-8]
  5817 00001FF8 D1E3                     shl bx, 1
  5818 00001FFA 8B87CA8E                 mov ax, [LabelAddr + bx]
  5819 00001FFE A3[3D00]                 mov word [disp], ax
  5820                                  
  5821                                  ;-899         c = FileBin[hex];//look for 'A' push Absolute 
  5822                                  
  5823 00002001 8B5EFE                   mov bx, [bp-2]
  5824 00002004 8A87AAA4                 mov al, [FileBin + bx]
  5825 00002008 8846F6                   mov [bp-10], al
  5826                                  
  5827                                  ;-900         prs(",Label+ORG:"); printhex16(disp);
  5828                                  
  5829 0000200B 68[9A20]                 push fixJmp_4
  5830 0000200E E816EA                   call prs
  5831 00002011 83C402                   add  sp, 2
  5832 00002014 FF36[3D00]               push word [disp]
  5833 00002018 E8F2EA                   call printhex16
  5834 0000201B 83C402                   add  sp, 2
  5835                                  
  5836                                  ;-901         if (c != 0xAA) {
  5837                                  
  5838 0000201E 8A46F6                   mov al, [bp-10]
  5839 00002021 3CAA                     cmp al, 170
  5840 00002023 0F842F00                 je  .fixJmp235
  5841                                  
  5842                                  ;-902             disp = disp - hex;
  5843                                  
  5844 00002027 A1[3D00]                 mov ax, [disp]
  5845 0000202A 2B46FE                   sub ax, [bp-2]
  5846 0000202D A3[3D00]                 mov word [disp], ax
  5847                                  
  5848                                  ;-903             disp = disp -2;//PC points to next instruction
  5849                                  
  5850 00002030 A1[3D00]                 mov ax, [disp]
  5851 00002033 83E802                   sub ax, 2
  5852 00002036 A3[3D00]                 mov word [disp], ax
  5853                                  
  5854                                  ;-904             disp = disp - Origin; 
  5855                                  
  5856 00002039 A1[3D00]                 mov ax, [disp]
  5857 0000203C 2B06[2500]               sub ax, [Origin]
  5858 00002040 A3[3D00]                 mov word [disp], ax
  5859                                  
  5860                                  ;-905             prs(",rel:"); printhex16(disp);
  5861                                  
  5862 00002043 68[A620]                 push fixJmp_5
  5863 00002046 E8DEE9                   call prs
  5864 00002049 83C402                   add  sp, 2
  5865 0000204C FF36[3D00]               push word [disp]
  5866 00002050 E8BAEA                   call printhex16
  5867 00002053 83C402                   add  sp, 2
  5868                                  
  5869                                  ;-906         }
  5870                                  
  5871                                  
  5872                                  ;-907             FileBin[hex] = disp;//fix low byte
  5873                                  
  5874                                  .fixJmp235:
  5875 00002056 A1[3D00]                 mov ax, [disp]
  5876 00002059 8B5EFE                   mov bx, [bp-2]
  5877 0000205C 8887AAA4                 mov [FileBin+bx], al
  5878                                  
  5879                                  ;-908             hex++;
  5880                                  
  5881 00002060 FF46FE                   inc  word[bp-2]
  5882                                  
  5883                                  ;-909             disp = disp >> 8;
  5884                                  
  5885 00002063 A1[3D00]                 mov ax, [disp]
  5886 00002066 C1E808                   shr ax, 8
  5887 00002069 A3[3D00]                 mov word [disp], ax
  5888                                  
  5889                                  ;-910             FileBin[hex] = disp; 
  5890                                  
  5891 0000206C A1[3D00]                 mov ax, [disp]
  5892 0000206F 8B5EFE                   mov bx, [bp-2]
  5893 00002072 8887AAA4                 mov [FileBin+bx], al
  5894                                  
  5895                                  ;-911         i++;  
  5896                                  
  5897 00002076 FF46FC                   inc  word[bp-4]
  5898                                  
  5899                                  ;-912     }
  5900                                  
  5901                                  
  5902                                  ;-913 }
  5903                                  
  5904 00002079 E9F5FE                   jmp .fixJmp232
  5905                                  .fixJmp233:
  5906                                  
  5907                                  ;-914 int fixJmpMain() {   
  5908 0000207C C9                       LEAVE
  5909 0000207D C3                       ret
  5910 0000207E 5C6E3B6A6D7020746F-     fixJmp_0 db "\n;jmp to fix:",0
  5911 00002087 206669783A00       
  5912 0000208D 5C6E00                  fixJmp_1 db "\n",0
  5913 00002090 2E2000                  fixJmp_2 db ". ",0
  5914 00002093 2C66726F6D3A00          fixJmp_3 db ",from:",0
  5915 0000209A 2C4C6162656C2B4F52-     fixJmp_4 db ",Label+ORG:",0
  5916 000020A3 473A00             
  5917 000020A6 2C72656C3A00            fixJmp_5 db ",rel:",0
  5918                                  ENDP
  5919                                  
  5920                                  fixJmpMain: PROC
  5921                                  
  5922                                  ;-915     unsigned int hex; 
  5923                                  
  5924                                  
  5925                                  ;-916     int Ix; char c;
  5926                                  
  5927                                  
  5928                                  ;-917     prs("\n;fix jmp to main. resting global jmp:");
  5929                                  
  5930                                  ;Function : fixJmpMain, Number of local variables: 3
  5931                                  ;   # type sign width addr used name   list of local variables
  5932                                  ;  200 var unsg word   915 NULL hex = bp-2
  5933                                  ;  201 var sign word   916 NULL Ix = bp-4
  5934                                  ;  202 var sign byte   916 NULL c = bp-6;
  5935 000020AC C8060000                 ENTER  6,0
  5936 000020B0 68[A621]                 push fixJmpMain_0
  5937 000020B3 E871E9                   call prs
  5938 000020B6 83C402                   add  sp, 2
  5939                                  
  5940                                  ;-918     printIntU(JmpMaxIx);  
  5941                                  
  5942 000020B9 FF36[5400]               push word [JmpMaxIx]
  5943 000020BD E877EA                   call printIntU
  5944 000020C0 83C402                   add  sp, 2
  5945                                  
  5946                                  ;-919     if (JmpMaxIx != 1) error1(" too many resting global jmp");
  5947                                  
  5948 000020C3 A1[5400]                 mov ax, [JmpMaxIx]
  5949 000020C6 83F801                   cmp ax, 1
  5950 000020C9 0F840900                 je  .fixJmpMain236
  5951 000020CD 68[CE21]                 push fixJmpMain_1
  5952 000020D0 E8A6EA                   call error1
  5953 000020D3 83C402                   add  sp, 2
  5954                                  
  5955                                  ;-920         strcpy(Symbol, "main");
  5956                                  
  5957                                  .fixJmpMain236:
  5958 000020D6 68[EB21]                 push fixJmpMain_2
  5959 000020D9 8D063075                 lea  ax, [Symbol]
  5960 000020DD 50                       push ax
  5961 000020DE E895E2                   call strcpy
  5962 000020E1 83C404                   add  sp, 4
  5963                                  
  5964                                  ;-921         hex = 1;//first instruction, PC=1
  5965                                  
  5966 000020E4 B80100                   mov ax, 1
  5967 000020E7 8946FE                   mov [bp-2], ax
  5968                                  
  5969                                  ;-922         prs("\nonly one global variable: "); 
  5970                                  
  5971 000020EA 68[F021]                 push fixJmpMain_3
  5972 000020ED E837E9                   call prs
  5973 000020F0 83C402                   add  sp, 2
  5974                                  
  5975                                  ;-923         prs(Symbol); prs(",from:");
  5976                                  
  5977 000020F3 8D063075                 lea  ax, [Symbol]
  5978 000020F7 50                       push ax
  5979 000020F8 E82CE9                   call prs
  5980 000020FB 83C402                   add  sp, 2
  5981 000020FE 68[0D22]                 push fixJmpMain_4
  5982 00002101 E823E9                   call prs
  5983 00002104 83C402                   add  sp, 2
  5984                                  
  5985                                  ;-924         printhex16(hex);
  5986                                  
  5987 00002107 FF76FE                   push word [bp-2]
  5988 0000210A E800EA                   call printhex16
  5989 0000210D 83C402                   add  sp, 2
  5990                                  
  5991                                  ;-925         
  5992                                  
  5993                                  
  5994                                  ;-926         Ix=searchLabel();
  5995                                  
  5996 00002110 E804F9                   call searchLabel
  5997 00002113 8946FC                   mov [bp-4], ax
  5998                                  
  5999                                  ;-927         if (Ix == 0) notfounderror();
  6000                                  
  6001 00002116 8B46FC                   mov ax, [bp-4]
  6002 00002119 83F800                   cmp ax, 0
  6003 0000211C 0F850300                 jne .fixJmpMain237
  6004 00002120 E8C6EA                   call notfounderror
  6005                                  
  6006                                  ;-928         disp = LabelAddr[Ix];   
  6007                                  
  6008                                  .fixJmpMain237:
  6009 00002123 8B5EFC                   mov bx, [bp-4]
  6010 00002126 D1E3                     shl bx, 1
  6011 00002128 8B87CA8E                 mov ax, [LabelAddr + bx]
  6012 0000212C A3[3D00]                 mov word [disp], ax
  6013                                  
  6014                                  ;-929         c = FileBin[hex];//look for 'A' push Absolute 
  6015                                  
  6016 0000212F 8B5EFE                   mov bx, [bp-2]
  6017 00002132 8A87AAA4                 mov al, [FileBin + bx]
  6018 00002136 8846FA                   mov [bp-6], al
  6019                                  
  6020                                  ;-930         prs(",Label+ORG:"); printhex16(disp);
  6021                                  
  6022 00002139 68[1422]                 push fixJmpMain_5
  6023 0000213C E8E8E8                   call prs
  6024 0000213F 83C402                   add  sp, 2
  6025 00002142 FF36[3D00]               push word [disp]
  6026 00002146 E8C4E9                   call printhex16
  6027 00002149 83C402                   add  sp, 2
  6028                                  
  6029                                  ;-931         if (c != 0xAA) {
  6030                                  
  6031 0000214C 8A46FA                   mov al, [bp-6]
  6032 0000214F 3CAA                     cmp al, 170
  6033 00002151 0F842F00                 je  .fixJmpMain238
  6034                                  
  6035                                  ;-932             disp = disp - hex;
  6036                                  
  6037 00002155 A1[3D00]                 mov ax, [disp]
  6038 00002158 2B46FE                   sub ax, [bp-2]
  6039 0000215B A3[3D00]                 mov word [disp], ax
  6040                                  
  6041                                  ;-933             disp = disp -2;//PC points to next instruction
  6042                                  
  6043 0000215E A1[3D00]                 mov ax, [disp]
  6044 00002161 83E802                   sub ax, 2
  6045 00002164 A3[3D00]                 mov word [disp], ax
  6046                                  
  6047                                  ;-934             disp = disp - Origin; 
  6048                                  
  6049 00002167 A1[3D00]                 mov ax, [disp]
  6050 0000216A 2B06[2500]               sub ax, [Origin]
  6051 0000216E A3[3D00]                 mov word [disp], ax
  6052                                  
  6053                                  ;-935             prs(",rel:"); printhex16(disp);
  6054                                  
  6055 00002171 68[2022]                 push fixJmpMain_6
  6056 00002174 E8B0E8                   call prs
  6057 00002177 83C402                   add  sp, 2
  6058 0000217A FF36[3D00]               push word [disp]
  6059 0000217E E88CE9                   call printhex16
  6060 00002181 83C402                   add  sp, 2
  6061                                  
  6062                                  ;-936         }
  6063                                  
  6064                                  
  6065                                  ;-937             FileBin[hex] = disp;//fix low byte
  6066                                  
  6067                                  .fixJmpMain238:
  6068 00002184 A1[3D00]                 mov ax, [disp]
  6069 00002187 8B5EFE                   mov bx, [bp-2]
  6070 0000218A 8887AAA4                 mov [FileBin+bx], al
  6071                                  
  6072                                  ;-938             hex++;
  6073                                  
  6074 0000218E FF46FE                   inc  word[bp-2]
  6075                                  
  6076                                  ;-939             disp = disp >> 8;
  6077                                  
  6078 00002191 A1[3D00]                 mov ax, [disp]
  6079 00002194 C1E808                   shr ax, 8
  6080 00002197 A3[3D00]                 mov word [disp], ax
  6081                                  
  6082                                  ;-940             FileBin[hex] = disp; 
  6083                                  
  6084 0000219A A1[3D00]                 mov ax, [disp]
  6085 0000219D 8B5EFE                   mov bx, [bp-2]
  6086 000021A0 8887AAA4                 mov [FileBin+bx], al
  6087                                  
  6088                                  ;-941 }
  6089                                  
  6090                                  
  6091                                  ;-942 
  6092                                  
  6093                                  
  6094                                  ;-943 int epilog() {
  6095 000021A4 C9                       LEAVE
  6096 000021A5 C3                       ret
  6097 000021A6 5C6E3B666978206A6D-     fixJmpMain_0 db "\n;fix jmp to main. resting global jmp:",0
  6098 000021AF 7020746F206D61696E-
  6099 000021B8 2E2072657374696E67-
  6100 000021C1 20676C6F62616C206A-
  6101 000021CA 6D703A00           
  6102 000021CE 20746F6F206D616E79-     fixJmpMain_1 db " too many resting global jmp",0
  6103 000021D7 2072657374696E6720-
  6104 000021E0 676C6F62616C206A6D-
  6105 000021E9 7000               
  6106 000021EB 6D61696E00              fixJmpMain_2 db "main",0
  6107 000021F0 5C6E6F6E6C79206F6E-     fixJmpMain_3 db "\nonly one global variable: ",0
  6108 000021F9 6520676C6F62616C20-
  6109 00002202 7661726961626C653A-
  6110 0000220B 2000               
  6111 0000220D 2C66726F6D3A00          fixJmpMain_4 db ",from:",0
  6112 00002214 2C4C6162656C2B4F52-     fixJmpMain_5 db ",Label+ORG:",0
  6113 0000221D 473A00             
  6114 00002220 2C72656C3A00            fixJmpMain_6 db ",rel:",0
  6115                                  ENDP
  6116                                  
  6117                                  epilog: PROC
  6118                                  
  6119                                  ;-944     unsigned int i; char c;     int j;
  6120                                  
  6121                                  
  6122                                  ;-945     prs("\n Errors: ");
  6123                                  
  6124                                  ;Function : epilog, Number of local variables: 3
  6125                                  ;   # type sign width addr used name   list of local variables
  6126                                  ;  200 var unsg word   944 NULL i = bp-2
  6127                                  ;  201 var sign byte   944 NULL c = bp-4
  6128                                  ;  202 var sign word   944 NULL j = bp-6;
  6129 00002226 C8060000                 ENTER  6,0
  6130 0000222A 68[D822]                 push epilog_0
  6131 0000222D E8F7E7                   call prs
  6132 00002230 83C402                   add  sp, 2
  6133                                  
  6134                                  ;-946     printIntU(ErrorCount);
  6135                                  
  6136 00002233 FF36[1E00]               push word [ErrorCount]
  6137 00002237 E8FDE8                   call printIntU
  6138 0000223A 83C402                   add  sp, 2
  6139                                  
  6140                                  ;-947     if (ErrorCount) prs(" ***ERROR*** ");
  6141                                  
  6142 0000223D A1[1E00]                 mov ax, [ErrorCount]
  6143 00002240 08C0                     or  al, al
  6144 00002242 0F840900                 je .epilog239
  6145 00002246 68[E422]                 push epilog_1
  6146 00002249 E8DBE7                   call prs
  6147 0000224C 83C402                   add  sp, 2
  6148                                  
  6149                                  ;-948     prs(", Out: ");
  6150                                  
  6151                                  .epilog239:
  6152 0000224F 68[F222]                 push epilog_2
  6153 00002252 E8D2E7                   call prs
  6154 00002255 83C402                   add  sp, 2
  6155                                  
  6156                                  ;-949     prs(namelst);
  6157                                  
  6158 00002258 8D06CF76                 lea  ax, [namelst]
  6159 0000225C 50                       push ax
  6160 0000225D E8C7E7                   call prs
  6161 00002260 83C402                   add  sp, 2
  6162                                  
  6163                                  ;-950     prs(", ");
  6164                                  
  6165 00002263 68[FA22]                 push epilog_3
  6166 00002266 E8BEE7                   call prs
  6167 00002269 83C402                   add  sp, 2
  6168                                  
  6169                                  ;-951     prs(namebin);
  6170                                  
  6171 0000226C 8D061277                 lea  ax, [namebin]
  6172 00002270 50                       push ax
  6173 00002271 E8B3E7                   call prs
  6174 00002274 83C402                   add  sp, 2
  6175                                  
  6176                                  ;-952     prs("= ");
  6177                                  
  6178 00002277 68[FD22]                 push epilog_4
  6179 0000227A E8AAE7                   call prs
  6180 0000227D 83C402                   add  sp, 2
  6181                                  
  6182                                  ;-953     printIntU(BinLen);
  6183                                  
  6184 00002280 FF36[5800]               push word [BinLen]
  6185 00002284 E8B0E8                   call printIntU
  6186 00002287 83C402                   add  sp, 2
  6187                                  
  6188                                  ;-954     prs(" bytes.");
  6189                                  
  6190 0000228A 68[0023]                 push epilog_5
  6191 0000228D E897E7                   call prs
  6192 00002290 83C402                   add  sp, 2
  6193                                  
  6194                                  ;-955     prs(" Labels: ");
  6195                                  
  6196 00002293 68[0823]                 push epilog_6
  6197 00002296 E88EE7                   call prs
  6198 00002299 83C402                   add  sp, 2
  6199                                  
  6200                                  ;-956     printIntU(LabelMaxIx);
  6201                                  
  6202 0000229C FF36[4A00]               push word [LabelMaxIx]
  6203 000022A0 E894E8                   call printIntU
  6204 000022A3 83C402                   add  sp, 2
  6205                                  
  6206                                  ;-957 // prs(", code:\n ");//debug
  6207                                  
  6208                                  
  6209                                  ;-958 
  6210                                  
  6211                                  
  6212                                  ;-959     i=0;
  6213                                  
  6214 000022A6 B80000                   mov ax, 0
  6215 000022A9 8946FE                   mov [bp-2], ax
  6216                                  
  6217                                  ;-960     do {
  6218                                  
  6219                                  .epilog240:
  6220                                  
  6221                                  ;-961         c = FileBin[i];
  6222                                  
  6223 000022AC 8B5EFE                   mov bx, [bp-2]
  6224 000022AF 8A87AAA4                 mov al, [FileBin + bx]
  6225 000022B3 8846FC                   mov [bp-4], al
  6226                                  
  6227                                  ;-962         fputcR(c, bin_fd);
  6228                                  
  6229 000022B6 FF36[1A00]               push word [bin_fd]
  6230 000022BA 8A46FC                   mov al, byte [bp-4]
  6231 000022BD B400                     mov ah, 0
  6232 000022BF 50                       push ax
  6233 000022C0 E846DE                   call fputcR
  6234 000022C3 83C404                   add  sp, 4
  6235                                  
  6236                                  ;-963 // printhex8a(c); prc(' ');//debug
  6237                                  
  6238                                  
  6239                                  ;-964         i++;
  6240                                  
  6241 000022C6 FF46FE                   inc  word[bp-2]
  6242                                  
  6243                                  ;-965     } while (i < BinLen);
  6244                                  
  6245 000022C9 8B46FE                   mov ax, [bp-2]
  6246 000022CC 3B06[5800]               cmp ax, [BinLen]
  6247 000022D0 0F8D0200                 jge .epilog241
  6248 000022D4 EBD6                     jmp .epilog240
  6249                                  .epilog241:
  6250                                  
  6251                                  ;-966 
  6252                                  
  6253                                  
  6254                                  ;-967 /* 
  6255                                  
  6256                                  
  6257                                  ;-968   prs("\n\n LabelNamePtr:"); printIntU(LabelNamePtr);
  6258                                  
  6259                                  
  6260                                  ;-969   i= &LabelNames;
  6261                                  
  6262                                  
  6263                                  ;-970   prs(" &LabelNames:"); printIntU(i);
  6264                                  
  6265                                  
  6266                                  ;-971   i=LabelNamePtr-i;
  6267                                  
  6268                                  
  6269                                  ;-972   prs(", size: ");
  6270                                  
  6271                                  
  6272                                  ;-973   printIntU(i);
  6273                                  
  6274                                  
  6275                                  ;-974   prs(".\n >>");
  6276                                  
  6277                                  
  6278                                  ;-975   i= &LabelNames;
  6279                                  
  6280                                  
  6281                                  ;-976   do { c=*i; if (c==0) c=' '; prc(c); i++;
  6282                                  
  6283                                  
  6284                                  ;-977   } while (i < LabelNamePtr); prs("<< \n");
  6285                                  
  6286                                  
  6287                                  ;-978    i = 1;
  6288                                  
  6289                                  
  6290                                  ;-979     LabelNamePtr= &LabelNames;
  6291                                  
  6292                                  
  6293                                  ;-980     do {
  6294                                  
  6295                                  
  6296                                  ;-981       prs(LabelNamePtr); prc(' ');
  6297                                  
  6298                                  
  6299                                  ;-982       j=LabelAddr[i]; printhex16(j); prs(", ");
  6300                                  
  6301                                  
  6302                                  ;-983       j=strlen(LabelNamePtr);//get end of actual name
  6303                                  
  6304                                  
  6305                                  ;-984       LabelNamePtr=LabelNamePtr+j;
  6306                                  
  6307                                  
  6308                                  ;-985       LabelNamePtr++;
  6309                                  
  6310                                  
  6311                                  ;-986       i++;
  6312                                  
  6313                                  
  6314                                  ;-987     } while (i <= LabelMaxIx);
  6315                                  
  6316                                  
  6317                                  ;-988 */
  6318                                  
  6319                                  
  6320                                  ;-989 }
  6321                                  
  6322                                  
  6323                                  ;-990 
  6324                                  
  6325                                  
  6326                                  ;-991 int end1(int n) {
  6327 000022D6 C9                       LEAVE
  6328 000022D7 C3                       ret
  6329 000022D8 5C6E204572726F7273-     epilog_0 db "\n Errors: ",0
  6330 000022E1 3A2000             
  6331 000022E4 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  6332 000022ED 2A2A2A2000         
  6333 000022F2 2C204F75743A2000        epilog_2 db ", Out: ",0
  6334 000022FA 2C2000                  epilog_3 db ", ",0
  6335 000022FD 3D2000                  epilog_4 db "= ",0
  6336 00002300 2062797465732E00        epilog_5 db " bytes.",0
  6337 00002308 204C6162656C733A20-     epilog_6 db " Labels: ",0
  6338 00002311 00                 
  6339                                  ENDP
  6340                                  
  6341                                  end1: PROC
  6342                                  
  6343                                  ;-992     fcloseR(asm_fd);
  6344                                  
  6345                                  ;Function : end1, Number of local variables: 1
  6346                                  ;   # type sign width addr used name   list of local variables
  6347                                  ;  200 var sign word   991 NULL n = bp+4;
  6348 00002312 C8000000                 ENTER  0,0
  6349 00002316 FF36[1600]               push word [asm_fd]
  6350 0000231A E8BADD                   call fcloseR
  6351 0000231D 83C402                   add  sp, 2
  6352                                  
  6353                                  ;-993     fcloseR(lst_fd);
  6354                                  
  6355 00002320 FF36[1800]               push word [lst_fd]
  6356 00002324 E8B0DD                   call fcloseR
  6357 00002327 83C402                   add  sp, 2
  6358                                  
  6359                                  ;-994     fcloseR(bin_fd);
  6360                                  
  6361 0000232A FF36[1A00]               push word [bin_fd]
  6362 0000232E E8A6DD                   call fcloseR
  6363 00002331 83C402                   add  sp, 2
  6364                                  
  6365                                  ;-995     exitR(n);
  6366                                  
  6367 00002334 FF7604                   push word [bp+4]
  6368 00002337 E8ACDD                   call exitR
  6369 0000233A 83C402                   add  sp, 2
  6370                                  
  6371                                  ;-996 }
  6372                                  
  6373                                  
  6374                                  ;-997 
  6375                                  
  6376                                  
  6377                                  ;-998 
  6378                                  
  6379                                  
  6380                                  ;-999 //#include "GENCODE.C"
  6381                                  
  6382                                  
  6383                                  ;-1000 // generate code
  6384                                  
  6385                                  
  6386                                  ;-1001 int getCodes() {
  6387 0000233D C9                       LEAVE
  6388 0000233E C3                       ret
  6389                                  ENDP
  6390                                  
  6391                                  getCodes: PROC
  6392                                  
  6393                                  ;-1002     OpCodePtr ++; Code1 = *OpCodePtr;
  6394                                  
  6395 0000233F FF06[4300]               inc  word[OpCodePtr]
  6396 00002343 8B1E[4300]               mov bx, [OpCodePtr]
  6397 00002347 8A07                     mov al, [bx]
  6398 00002349 B400                     mov ah, 0
  6399 0000234B A2[3000]                 mov byte [Code1], al
  6400                                  
  6401                                  ;-1003     OpCodePtr ++; Code2 = *OpCodePtr;
  6402                                  
  6403 0000234E FF06[4300]               inc  word[OpCodePtr]
  6404 00002352 8B1E[4300]               mov bx, [OpCodePtr]
  6405 00002356 8A07                     mov al, [bx]
  6406 00002358 B400                     mov ah, 0
  6407 0000235A A2[3100]                 mov byte [Code2], al
  6408                                  
  6409                                  ;-1004     OpCodePtr ++; Code3 = *OpCodePtr;
  6410                                  
  6411 0000235D FF06[4300]               inc  word[OpCodePtr]
  6412 00002361 8B1E[4300]               mov bx, [OpCodePtr]
  6413 00002365 8A07                     mov al, [bx]
  6414 00002367 B400                     mov ah, 0
  6415 00002369 A2[3200]                 mov byte [Code3], al
  6416                                  
  6417                                  ;-1005 }
  6418                                  
  6419                                  
  6420                                  ;-1006 int genCode8(char c) {
  6421                                  
  6422 0000236C C3                       ret
  6423                                  ENDP
  6424                                  
  6425                                  genCode8: PROC
  6426                                  
  6427                                  ;-1007 //set: BinLen++, OpPrintIndex++
  6428                                  
  6429                                  
  6430                                  ;-1008     FileBin[BinLen]=c;
  6431                                  
  6432                                  ;Function : genCode8, Number of local variables: 1
  6433                                  ;   # type sign width addr used name   list of local variables
  6434                                  ;  200 var sign byte  1006 NULL c = bp+4;
  6435 0000236D C8000000                 ENTER  0,0
  6436 00002371 8A4604                   mov al, [bp+4]
  6437 00002374 8B1E[5800]               mov bx, [BinLen]
  6438 00002378 8887AAA4                 mov [FileBin+bx], al
  6439                                  
  6440                                  ;-1009     BinLen++;
  6441                                  
  6442 0000237C FF06[5800]               inc  word[BinLen]
  6443                                  
  6444                                  ;-1010     PC++;
  6445                                  
  6446 00002380 FF06[2300]               inc  word[PC]
  6447                                  
  6448                                  ;-1011     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  6449                                  
  6450 00002384 A1[5800]                 mov ax, [BinLen]
  6451 00002387 3D6842                   cmp ax, 17000 ;unsigned : 0
  6452 0000238A 0F820900                 jb  .genCode8242
  6453 0000238E 68[B223]                 push genCode8_0
  6454 00002391 E83BE8                   call errorexit
  6455 00002394 83C402                   add  sp, 2
  6456                                  
  6457                                  ;-1012     if (OpPrintIndex < OPMAXLEN) {
  6458                                  
  6459                                  .genCode8242:
  6460 00002397 A1[4100]                 mov ax, [OpPrintIndex]
  6461 0000239A 83F805                   cmp ax, 5
  6462 0000239D 0F8D0F00                 jge .genCode8243
  6463                                  
  6464                                  ;-1013         OpPos[OpPrintIndex]=c;
  6465                                  
  6466 000023A1 8A4604                   mov al, [bp+4]
  6467 000023A4 8B1E[4100]               mov bx, [OpPrintIndex]
  6468 000023A8 88875577                 mov [OpPos+bx], al
  6469                                  
  6470                                  ;-1014         OpPrintIndex++;
  6471                                  
  6472 000023AC FF06[4100]               inc  word[OpPrintIndex]
  6473                                  
  6474                                  ;-1015     }
  6475                                  
  6476                                  
  6477                                  ;-1016 }
  6478                                  
  6479                                  .genCode8243:
  6480                                  
  6481                                  ;-1017 int gen66h() {genCode8(0x66);
  6482 000023B0 C9                       LEAVE
  6483 000023B1 C3                       ret
  6484 000023B2 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  6485 000023BB 746F6F206C6F6E6700 
  6486                                  ENDP
  6487                                  
  6488                                  gen66h: PROC
  6489 000023C4 6A66                     push 102
  6490 000023C6 E8A4FF                   call genCode8
  6491 000023C9 83C402                   add  sp, 2
  6492                                  
  6493                                  ;-1018 }
  6494                                  
  6495                                  
  6496                                  ;-1019 int genCode2(char c, char d) {
  6497                                  
  6498 000023CC C3                       ret
  6499                                  ENDP
  6500                                  
  6501                                  genCode2: PROC
  6502                                  
  6503                                  ;-1020     c = c + d;
  6504                                  
  6505                                  ;Function : genCode2, Number of local variables: 2
  6506                                  ;   # type sign width addr used name   list of local variables
  6507                                  ;  200 var sign byte  1019 NULL c = bp+4
  6508                                  ;  201 var sign byte  1019 NULL d = bp+6;
  6509 000023CD C8000000                 ENTER  0,0
  6510 000023D1 8A4604                   mov al, [bp+4]
  6511 000023D4 024606                   add al, [bp+6]
  6512 000023D7 884604                   mov [bp+4], al
  6513                                  
  6514                                  ;-1021     genCode8(c);
  6515                                  
  6516 000023DA 8A4604                   mov al, byte [bp+4]
  6517 000023DD B400                     mov ah, 0
  6518 000023DF 50                       push ax
  6519 000023E0 E88AFF                   call genCode8
  6520 000023E3 83C402                   add  sp, 2
  6521                                  
  6522                                  ;-1022 }
  6523                                  
  6524                                  
  6525                                  ;-1023 int genCodeW(char c) {
  6526 000023E6 C9                       LEAVE
  6527 000023E7 C3                       ret
  6528                                  ENDP
  6529                                  
  6530                                  genCodeW: PROC
  6531                                  
  6532                                  ;-1024     c = c + wflag;
  6533                                  
  6534                                  ;Function : genCodeW, Number of local variables: 1
  6535                                  ;   # type sign width addr used name   list of local variables
  6536                                  ;  200 var sign byte  1023 NULL c = bp+4;
  6537 000023E8 C8000000                 ENTER  0,0
  6538 000023EC 8A4604                   mov al, [bp+4]
  6539 000023EF 0206[3800]               add al, [wflag]
  6540 000023F3 884604                   mov [bp+4], al
  6541                                  
  6542                                  ;-1025     genCode8(c);
  6543                                  
  6544 000023F6 8A4604                   mov al, byte [bp+4]
  6545 000023F9 B400                     mov ah, 0
  6546 000023FB 50                       push ax
  6547 000023FC E86EFF                   call genCode8
  6548 000023FF 83C402                   add  sp, 2
  6549                                  
  6550                                  ;-1026 }
  6551                                  
  6552                                  
  6553                                  ;-1027 int genCode16(unsigned int i) {
  6554 00002402 C9                       LEAVE
  6555 00002403 C3                       ret
  6556                                  ENDP
  6557                                  
  6558                                  genCode16: PROC
  6559                                  
  6560                                  ;-1028     genCode8(i); i=i >> 8;
  6561                                  
  6562                                  ;Function : genCode16, Number of local variables: 1
  6563                                  ;   # type sign width addr used name   list of local variables
  6564                                  ;  200 var unsg word  1027 NULL i = bp+4;
  6565 00002404 C8000000                 ENTER  0,0
  6566 00002408 FF7604                   push word [bp+4]
  6567 0000240B E85FFF                   call genCode8
  6568 0000240E 83C402                   add  sp, 2
  6569 00002411 8B4604                   mov ax, [bp+4]
  6570 00002414 C1E808                   shr ax, 8
  6571 00002417 894604                   mov [bp+4], ax
  6572                                  
  6573                                  ;-1029     genCode8(i);
  6574                                  
  6575 0000241A FF7604                   push word [bp+4]
  6576 0000241D E84DFF                   call genCode8
  6577 00002420 83C402                   add  sp, 2
  6578                                  
  6579                                  ;-1030 }
  6580                                  
  6581                                  
  6582                                  ;-1031 int genCode32(unsigned long L) {
  6583 00002423 C9                       LEAVE
  6584 00002424 C3                       ret
  6585                                  ENDP
  6586                                  
  6587                                  genCode32: PROC
  6588                                  
  6589                                  ;-1032     genCode16(L); L=L >>16;
  6590                                  
  6591                                  ;Function : genCode32, Number of local variables: 1
  6592                                  ;   # type sign width addr used name   list of local variables
  6593                                  ;  200 var unsg dwrd  1031 NULL L = bp+4;
  6594 00002425 C8000000                 ENTER  0,0
  6595 00002429 8A4604                   mov al, byte [bp+4]
  6596 0000242C B400                     mov ah, 0
  6597 0000242E 50                       push ax
  6598 0000242F E8D2FF                   call genCode16
  6599 00002432 83C402                   add  sp, 2
  6600 00002435 668B4604                 mov eax, [bp+4]
  6601 00002439 66C1E810                 shr eax, 16
  6602 0000243D 66894604                 mov [bp+4], eax
  6603                                  
  6604                                  ;-1033     genCode16(L);
  6605                                  
  6606 00002441 8A4604                   mov al, byte [bp+4]
  6607 00002444 B400                     mov ah, 0
  6608 00002446 50                       push ax
  6609 00002447 E8BAFF                   call genCode16
  6610 0000244A 83C402                   add  sp, 2
  6611                                  
  6612                                  ;-1034 }
  6613                                  
  6614                                  
  6615                                  ;-1035 int writeEA(char xxx) {//value for reg/operand
  6616 0000244D C9                       LEAVE
  6617 0000244E C3                       ret
  6618                                  ENDP
  6619                                  
  6620                                  writeEA: PROC
  6621                                  
  6622                                  ;-1036 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  6623                                  
  6624                                  
  6625                                  ;-1037 //mod-bits: mode76, reg/opcode543, r/m210
  6626                                  
  6627                                  
  6628                                  ;-1038 //Op: 0, IMM, REG, ADR, MEM
  6629                                  
  6630                                  
  6631                                  ;-1039     char len;
  6632                                  
  6633                                  
  6634                                  ;-1040     len=0;
  6635                                  
  6636                                  ;Function : writeEA, Number of local variables: 2
  6637                                  ;   # type sign width addr used name   list of local variables
  6638                                  ;  200 var sign byte  1035 NULL xxx = bp+4
  6639                                  ;  201 var sign byte  1039 NULL len = bp-2;
  6640 0000244F C8020000                 ENTER  2,0
  6641 00002453 B80000                   mov ax, 0
  6642 00002456 8846FE                   mov [bp-2], al
  6643                                  
  6644                                  ;-1041     xxx = xxx << 3;//in reg/opcode field
  6645                                  
  6646 00002459 8A4604                   mov al, [bp+4]
  6647 0000245C C0E003                   shl al, 3
  6648 0000245F 884604                   mov [bp+4], al
  6649                                  
  6650                                  ;-1042     if (Op == REG) {
  6651                                  
  6652 00002462 A0[2D00]                 mov al, [Op]
  6653 00002465 3C02                     cmp al, 2
  6654 00002467 0F853A00                 jne .writeEA244
  6655                                  
  6656                                  ;-1043         xxx |= 0xC0;
  6657                                  
  6658 0000246B 804E04C0                 or  byte[bp+4], 192
  6659                                  
  6660                                  ;-1044         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  6661                                  
  6662 0000246F A0[2E00]                 mov al, [Op2]
  6663 00002472 3C01                     cmp al, 1
  6664 00002474 0F8F0D00                 jg  .writeEA245
  6665 00002478 8A4604                   mov al, [bp+4]
  6666 0000247B 0206[3400]               add al, [R1No]
  6667 0000247F 884604                   mov [bp+4], al
  6668                                  
  6669                                  ;-1045             else {
  6670                                  
  6671 00002482 E92000                   jmp .writeEA246
  6672                                  .writeEA245:
  6673                                  
  6674                                  ;-1046                 if (Op2 == REG) xxx = xxx + R1No;
  6675                                  
  6676 00002485 A0[2E00]                 mov al, [Op2]
  6677 00002488 3C02                     cmp al, 2
  6678 0000248A 0F850D00                 jne .writeEA247
  6679 0000248E 8A4604                   mov al, [bp+4]
  6680 00002491 0206[3400]               add al, [R1No]
  6681 00002495 884604                   mov [bp+4], al
  6682                                  
  6683                                  ;-1047                 else            xxx = xxx + R2No;
  6684                                  
  6685 00002498 E90A00                   jmp .writeEA248
  6686                                  .writeEA247:
  6687 0000249B 8A4604                   mov al, [bp+4]
  6688 0000249E 0206[3300]               add al, [R2No]
  6689 000024A2 884604                   mov [bp+4], al
  6690                                  
  6691                                  ;-1048             }
  6692                                  
  6693                                  .writeEA248:
  6694                                  
  6695                                  ;-1049         }
  6696                                  
  6697                                  .writeEA246:
  6698                                  
  6699                                  ;-1050     if (Op == MEM) {
  6700                                  
  6701                                  .writeEA244:
  6702 000024A5 A0[2D00]                 mov al, [Op]
  6703 000024A8 3C04                     cmp al, 4
  6704 000024AA 0F857300                 jne .writeEA249
  6705                                  
  6706                                  ;-1051         if (isDirect) {
  6707                                  
  6708 000024AE A0[3C00]                 mov al, [isDirect]
  6709 000024B1 08C0                     or  al, al
  6710 000024B3 0F840D00                 je .writeEA250
  6711                                  
  6712                                  ;-1052             xxx |= 6;
  6713                                  
  6714 000024B7 804E0406                 or  byte[bp+4], 6
  6715                                  
  6716                                  ;-1053             len = 2;
  6717                                  
  6718 000024BB B80200                   mov ax, 2
  6719 000024BE 8846FE                   mov [bp-2], al
  6720                                  
  6721                                  ;-1054         }
  6722                                  
  6723                                  
  6724                                  ;-1055         else {
  6725                                  
  6726 000024C1 E95D00                   jmp .writeEA251
  6727                                  .writeEA250:
  6728                                  
  6729                                  ;-1056             xxx = xxx + rm;
  6730                                  
  6731 000024C4 8A4604                   mov al, [bp+4]
  6732 000024C7 0206[3B00]               add al, [rm]
  6733 000024CB 884604                   mov [bp+4], al
  6734                                  
  6735                                  ;-1057             if (rm == 6) {//make [BP+00]
  6736                                  
  6737 000024CE A0[3B00]                 mov al, [rm]
  6738 000024D1 3C06                     cmp al, 6
  6739 000024D3 0F851400                 jne .writeEA252
  6740                                  
  6741                                  ;-1058                 len=1;
  6742                                  
  6743 000024D7 B80100                   mov ax, 1
  6744 000024DA 8846FE                   mov [bp-2], al
  6745                                  
  6746                                  ;-1059                 if (disp == 0) xxx |= 0x40;
  6747                                  
  6748 000024DD A1[3D00]                 mov ax, [disp]
  6749 000024E0 83F800                   cmp ax, 0
  6750 000024E3 0F850400                 jne .writeEA253
  6751 000024E7 804E0440                 or  byte[bp+4], 64
  6752                                  
  6753                                  ;-1060             }
  6754                                  
  6755                                  .writeEA253:
  6756                                  
  6757                                  ;-1061 
  6758                                  
  6759                                  
  6760                                  ;-1062             if (disp) {
  6761                                  
  6762                                  .writeEA252:
  6763 000024EB A1[3D00]                 mov ax, [disp]
  6764 000024EE 08C0                     or  al, al
  6765 000024F0 0F842D00                 je .writeEA254
  6766                                  
  6767                                  ;-1063                 ax = disp;
  6768                                  
  6769 000024F4 A1[3D00]                 mov  ax, [disp]
  6770                                  
  6771                                  ;-1064                 if(ax > 127) len=2;
  6772                                  
  6773 000024F7 83F87F                   cmp  ax, 127
  6774 000024FA 0F8E0900                 jle .writeEA255
  6775 000024FE B80200                   mov ax, 2
  6776 00002501 8846FE                   mov [bp-2], al
  6777                                  
  6778                                  ;-1065                 else len=1;
  6779                                  
  6780 00002504 E90600                   jmp .writeEA256
  6781                                  .writeEA255:
  6782 00002507 B80100                   mov ax, 1
  6783 0000250A 8846FE                   mov [bp-2], al
  6784                                  
  6785                                  ;-1066                 if (len == 1) xxx |= 0x40;
  6786                                  
  6787                                  .writeEA256:
  6788 0000250D 8A46FE                   mov al, [bp-2]
  6789 00002510 3C01                     cmp al, 1
  6790 00002512 0F850700                 jne .writeEA257
  6791 00002516 804E0440                 or  byte[bp+4], 64
  6792                                  
  6793                                  ;-1067                 else xxx |= 0x80;
  6794                                  
  6795 0000251A E90400                   jmp .writeEA258
  6796                                  .writeEA257:
  6797 0000251D 804E0480                 or  byte[bp+4], 128
  6798                                  
  6799                                  ;-1068             }
  6800                                  
  6801                                  .writeEA258:
  6802                                  
  6803                                  ;-1069         }
  6804                                  
  6805                                  .writeEA254:
  6806                                  
  6807                                  ;-1070     }
  6808                                  
  6809                                  .writeEA251:
  6810                                  
  6811                                  ;-1071 
  6812                                  
  6813                                  
  6814                                  ;-1072     genCode8(xxx);// gen second byte
  6815                                  
  6816                                  .writeEA249:
  6817 00002521 8A4604                   mov al, byte [bp+4]
  6818 00002524 B400                     mov ah, 0
  6819 00002526 50                       push ax
  6820 00002527 E843FE                   call genCode8
  6821 0000252A 83C402                   add  sp, 2
  6822                                  
  6823                                  ;-1073     if (len == 1) genCode8 (disp);
  6824                                  
  6825 0000252D 8A46FE                   mov al, [bp-2]
  6826 00002530 3C01                     cmp al, 1
  6827 00002532 0F850A00                 jne .writeEA259
  6828 00002536 FF36[3D00]               push word [disp]
  6829 0000253A E830FE                   call genCode8
  6830 0000253D 83C402                   add  sp, 2
  6831                                  
  6832                                  ;-1074     if (len == 2) genCode16(disp);
  6833                                  
  6834                                  .writeEA259:
  6835 00002540 8A46FE                   mov al, [bp-2]
  6836 00002543 3C02                     cmp al, 2
  6837 00002545 0F850A00                 jne .writeEA260
  6838 00002549 FF36[3D00]               push word [disp]
  6839 0000254D E8B4FE                   call genCode16
  6840 00002550 83C402                   add  sp, 2
  6841                                  
  6842                                  ;-1075 }
  6843                                  
  6844                                  .writeEA260:
  6845                                  
  6846                                  ;-1076 
  6847                                  
  6848                                  
  6849                                  ;-1077 int genImmediate() {
  6850 00002553 C9                       LEAVE
  6851 00002554 C3                       ret
  6852                                  ENDP
  6853                                  
  6854                                  genImmediate: PROC
  6855                                  
  6856                                  ;-1078     if (wflag) if (OpSize == DWORD) genCode32(imme);//todo imme long
  6857                                  
  6858 00002555 A0[3800]                 mov al, [wflag]
  6859 00002558 08C0                     or  al, al
  6860 0000255A 0F842300                 je .genImmediate261
  6861 0000255E A0[3700]                 mov al, [OpSize]
  6862 00002561 3C03                     cmp al, 3
  6863 00002563 0F850D00                 jne .genImmediate262
  6864 00002567 FF36[3F00]               push word [imme]
  6865 0000256B E8B7FE                   call genCode32
  6866 0000256E 83C402                   add  sp, 2
  6867                                  
  6868                                  ;-1079         else genCode16(imme);
  6869                                  
  6870 00002571 E90A00                   jmp .genImmediate263
  6871                                  .genImmediate262:
  6872 00002574 FF36[3F00]               push word [imme]
  6873 00002578 E889FE                   call genCode16
  6874 0000257B 83C402                   add  sp, 2
  6875                                  
  6876                                  ;-1080     else       genCode8 (imme);
  6877                                  
  6878                                  .genImmediate263:
  6879 0000257E E90A00                   jmp .genImmediate264
  6880                                  .genImmediate261:
  6881 00002581 FF36[3F00]               push word [imme]
  6882 00002585 E8E5FD                   call genCode8
  6883 00002588 83C402                   add  sp, 2
  6884                                  
  6885                                  ;-1081 }
  6886                                  
  6887                                  .genImmediate264:
  6888                                  
  6889                                  ;-1082 
  6890                                  
  6891                                  
  6892                                  ;-1083 //AS.C
  6893                                  
  6894                                  
  6895                                  ;-1084 int process() {
  6896                                  
  6897 0000258B C3                       ret
  6898                                  ENDP
  6899                                  
  6900                                  process: PROC
  6901                                  
  6902                                  ;-1085     char c;
  6903                                  
  6904                                  
  6905                                  ;-1086     int i;
  6906                                  
  6907                                  
  6908                                  ;-1087     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6909                                  
  6910                                  ;Function : process, Number of local variables: 2
  6911                                  ;   # type sign width addr used name   list of local variables
  6912                                  ;  200 var sign byte  1085 NULL c = bp-2
  6913                                  ;  201 var sign word  1086 NULL i = bp-4;
  6914 0000258C C8040000                 ENTER  4,0
  6915 00002590 B80000                   mov ax, 0
  6916 00002593 A2[3B00]                 mov byte [rm], al
  6917 00002596 A2[3800]                 mov byte [wflag], al
  6918 00002599 A2[3900]                 mov byte [dflag], al
  6919 0000259C A2[3300]                 mov byte [R2No], al
  6920 0000259F A2[3400]                 mov byte [R1No], al
  6921 000025A2 A2[3500]                 mov byte [R2Type], al
  6922 000025A5 A2[3600]                 mov byte [R1Type], al
  6923 000025A8 A2[2E00]                 mov byte [Op2], al
  6924 000025AB A2[2D00]                 mov byte [Op], al
  6925                                  
  6926                                  ;-1088     disp=imme=0;//int
  6927                                  
  6928 000025AE B80000                   mov ax, 0
  6929 000025B1 A3[3F00]                 mov word [imme], ax
  6930 000025B4 A3[3D00]                 mov word [disp], ax
  6931                                  
  6932                                  ;-1089     isDirect=1; //set in getMeM=0, need in WriteEA
  6933                                  
  6934 000025B7 B80100                   mov ax, 1
  6935 000025BA A2[3C00]                 mov byte [isDirect], al
  6936                                  
  6937                                  ;-1090     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6938                                  
  6939 000025BD E8A8F2                   call getTokeType
  6940                                  
  6941                                  ;-1091     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6942                                  
  6943 000025C0 E841F6                   call getCodeSize
  6944 000025C3 A2[3700]                 mov byte [OpSize], al
  6945                                  
  6946                                  ;-1092     getCodes();//set: Code1, Code2, Code3
  6947                                  
  6948 000025C6 E876FD                   call getCodes
  6949                                  
  6950                                  ;-1093 
  6951                                  
  6952                                  
  6953                                  ;-1094     if (CodeType ==  1) {//1 byte opcode
  6954                                  
  6955 000025C9 A0[2F00]                 mov al, [CodeType]
  6956 000025CC 3C01                     cmp al, 1
  6957 000025CE 0F850F00                 jne .process265
  6958                                  
  6959                                  ;-1095         genCode8(Code1);
  6960                                  
  6961 000025D2 A0[3000]                 mov al, byte [Code1]
  6962 000025D5 B400                     mov ah, 0
  6963 000025D7 50                       push ax
  6964 000025D8 E892FD                   call genCode8
  6965 000025DB 83C402                   add  sp, 2
  6966                                  
  6967                                  ;-1096         return;
  6968                                  
  6969 000025DE E9DF08                   jmp .retnprocess
  6970                                  
  6971                                  ;-1097     }
  6972                                  
  6973                                  
  6974                                  ;-1098 
  6975                                  
  6976                                  
  6977                                  ;-1099     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6978                                  
  6979                                  .process265:
  6980 000025E1 A0[2F00]                 mov al, [CodeType]
  6981 000025E4 3C02                     cmp al, 2
  6982 000025E6 0F856900                 jne .process266
  6983                                  
  6984                                  ;-1100         getOpL();
  6985                                  
  6986 000025EA E8A6ED                   call getOpL
  6987                                  
  6988                                  ;-1101         checkOpL();
  6989                                  
  6990 000025ED E8C6EC                   call checkOpL
  6991                                  
  6992                                  ;-1102         if (Code2 <= 1) {//inc,dec
  6993                                  
  6994 000025F0 A0[3100]                 mov al, [Code2]
  6995 000025F3 3C01                     cmp al, 1
  6996 000025F5 0F8F2700                 jg  .process267
  6997                                  
  6998                                  ;-1103   	        if (Op == REG) {//short
  6999                                  
  7000 000025F9 A0[2D00]                 mov al, [Op]
  7001 000025FC 3C02                     cmp al, 2
  7002 000025FE 0F851E00                 jne .process268
  7003                                  
  7004                                  ;-1104                 if (wflag) {genCode2(Code3, R1No); return; }
  7005                                  
  7006 00002602 A0[3800]                 mov al, [wflag]
  7007 00002605 08C0                     or  al, al
  7008 00002607 0F841500                 je .process269
  7009 0000260B A0[3400]                 mov al, byte [R1No]
  7010 0000260E B400                     mov ah, 0
  7011 00002610 50                       push ax
  7012 00002611 A0[3200]                 mov al, byte [Code3]
  7013 00002614 B400                     mov ah, 0
  7014 00002616 50                       push ax
  7015 00002617 E8B3FD                   call genCode2
  7016 0000261A 83C404                   add  sp, 4
  7017 0000261D E9A008                   jmp .retnprocess
  7018                                  
  7019                                  ;-1105             }
  7020                                  
  7021                                  .process269:
  7022                                  
  7023                                  ;-1106         }
  7024                                  
  7025                                  .process268:
  7026                                  
  7027                                  ;-1107         if (Code2 == 5) {//imul extension?
  7028                                  
  7029                                  .process267:
  7030 00002620 A0[3100]                 mov al, [Code2]
  7031 00002623 3C05                     cmp al, 5
  7032 00002625 0F850F00                 jne .process270
  7033                                  
  7034                                  ;-1108             getTokeType();
  7035                                  
  7036 00002629 E83CF2                   call getTokeType
  7037                                  
  7038                                  ;-1109             if (TokeType) implerror();
  7039                                  
  7040 0000262C A0[2C00]                 mov al, [TokeType]
  7041 0000262F 08C0                     or  al, al
  7042 00002631 0F840300                 je .process271
  7043 00002635 E851E6                   call implerror
  7044                                  
  7045                                  ;-1110         }
  7046                                  
  7047                                  .process271:
  7048                                  
  7049                                  ;-1111         genCodeW(Code1);
  7050                                  
  7051                                  .process270:
  7052 00002638 A0[3000]                 mov al, byte [Code1]
  7053 0000263B B400                     mov ah, 0
  7054 0000263D 50                       push ax
  7055 0000263E E8A7FD                   call genCodeW
  7056 00002641 83C402                   add  sp, 2
  7057                                  
  7058                                  ;-1112         writeEA(Code2);
  7059                                  
  7060 00002644 A0[3100]                 mov al, byte [Code2]
  7061 00002647 B400                     mov ah, 0
  7062 00002649 50                       push ax
  7063 0000264A E802FE                   call writeEA
  7064 0000264D 83C402                   add  sp, 2
  7065                                  
  7066                                  ;-1113         return;
  7067                                  
  7068 00002650 E96D08                   jmp .retnprocess
  7069                                  
  7070                                  ;-1114     }
  7071                                  
  7072                                  
  7073                                  ;-1115 
  7074                                  
  7075                                  
  7076                                  ;-1116     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  7077                                  
  7078                                  .process266:
  7079 00002653 A0[2F00]                 mov al, [CodeType]
  7080 00002656 3C03                     cmp al, 3
  7081 00002658 0F855100                 jne .process272
  7082                                  
  7083                                  ;-1117         check2Ops();    //setwflag not applicable
  7084                                  
  7085 0000265C E8D9EC                   call check2Ops
  7086                                  
  7087                                  ;-1118         if (R1Type != WORD) reg16error();//only r16
  7088                                  
  7089 0000265F A0[3600]                 mov al, [R1Type]
  7090 00002662 3C02                     cmp al, 2
  7091 00002664 0F840300                 je  .process273
  7092 00002668 E8BEE6                   call reg16error
  7093                                  
  7094                                  ;-1119         if (Op2 != MEM) addrerror();//only m16
  7095                                  
  7096                                  .process273:
  7097 0000266B A0[2E00]                 mov al, [Op2]
  7098 0000266E 3C04                     cmp al, 4
  7099 00002670 0F840300                 je  .process274
  7100 00002674 E8D3E5                   call addrerror
  7101                                  
  7102                                  ;-1120 
  7103                                  
  7104                                  
  7105                                  ;-1121         genCode8(Code1);//les,lds,lea
  7106                                  
  7107                                  .process274:
  7108 00002677 A0[3000]                 mov al, byte [Code1]
  7109 0000267A B400                     mov ah, 0
  7110 0000267C 50                       push ax
  7111 0000267D E8EDFC                   call genCode8
  7112 00002680 83C402                   add  sp, 2
  7113                                  
  7114                                  ;-1122         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  7115                                  
  7116 00002683 A0[3000]                 mov al, [Code1]
  7117 00002686 3C0F                     cmp al, 15
  7118 00002688 0F850C00                 jne .process275
  7119 0000268C A0[3100]                 mov al, byte [Code2]
  7120 0000268F B400                     mov ah, 0
  7121 00002691 50                       push ax
  7122 00002692 E8D8FC                   call genCode8
  7123 00002695 83C402                   add  sp, 2
  7124                                  
  7125                                  ;-1123         Op=Op2;//set MEM for writeEA
  7126                                  
  7127                                  .process275:
  7128 00002698 A0[2E00]                 mov al, [Op2]
  7129 0000269B A2[2D00]                 mov byte [Op], al
  7130                                  
  7131                                  ;-1124         writeEA(R1No);
  7132                                  
  7133 0000269E A0[3400]                 mov al, byte [R1No]
  7134 000026A1 B400                     mov ah, 0
  7135 000026A3 50                       push ax
  7136 000026A4 E8A8FD                   call writeEA
  7137 000026A7 83C402                   add  sp, 2
  7138                                  
  7139                                  ;-1125         return;
  7140                                  
  7141 000026AA E91308                   jmp .retnprocess
  7142                                  
  7143                                  ;-1126     }
  7144                                  
  7145                                  
  7146                                  ;-1127 
  7147                                  
  7148                                  
  7149                                  ;-1128     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  7150                                  
  7151                                  .process272:
  7152 000026AD A0[2F00]                 mov al, [CodeType]
  7153 000026B0 3C04                     cmp al, 4
  7154 000026B2 0F85EF00                 jne .process276
  7155                                  
  7156                                  ;-1129         check2Ops();
  7157                                  
  7158 000026B6 E87FEC                   call check2Ops
  7159                                  
  7160                                  ;-1130         if (Op2 == IMM) {//second operand is imm
  7161                                  
  7162 000026B9 A0[2E00]                 mov al, [Op2]
  7163 000026BC 3C01                     cmp al, 1
  7164 000026BE 0F857900                 jne .process277
  7165                                  
  7166                                  ;-1131             setsflag();
  7167                                  
  7168 000026C2 E802F0                   call setsflag
  7169                                  
  7170                                  ;-1132             if (Op == REG) {
  7171                                  
  7172 000026C5 A0[2D00]                 mov al, [Op]
  7173 000026C8 3C02                     cmp al, 2
  7174 000026CA 0F853100                 jne .process278
  7175                                  
  7176                                  ;-1133                 if (R1No == 0) {// acc,imm
  7177                                  
  7178 000026CE A0[3400]                 mov al, [R1No]
  7179 000026D1 3C00                     cmp al, 0
  7180 000026D3 0F852800                 jne .process279
  7181                                  
  7182                                  ;-1134                     if (sflag == 0) {
  7183                                  
  7184 000026D7 A0[3A00]                 mov al, [sflag]
  7185 000026DA 3C00                     cmp al, 0
  7186 000026DC 0F851F00                 jne .process280
  7187                                  
  7188                                  ;-1135                         c = Code1 << 3;
  7189                                  
  7190 000026E0 A0[3000]                 mov al, [Code1]
  7191 000026E3 C0E003                   shl al, 3
  7192 000026E6 8846FE                   mov [bp-2], al
  7193                                  
  7194                                  ;-1136                         c += 4;
  7195                                  
  7196 000026E9 8046FE04                 add  byte[bp-2], 4
  7197                                  
  7198                                  ;-1137                         genCodeW(c);
  7199                                  
  7200 000026ED 8A46FE                   mov al, byte [bp-2]
  7201 000026F0 B400                     mov ah, 0
  7202 000026F2 50                       push ax
  7203 000026F3 E8F2FC                   call genCodeW
  7204 000026F6 83C402                   add  sp, 2
  7205                                  
  7206                                  ;-1138                         genImmediate();
  7207                                  
  7208 000026F9 E859FE                   call genImmediate
  7209                                  
  7210                                  ;-1139                         return;
  7211                                  
  7212 000026FC E9C107                   jmp .retnprocess
  7213                                  
  7214                                  ;-1140                     }
  7215                                  
  7216                                  
  7217                                  ;-1141                 }
  7218                                  
  7219                                  .process280:
  7220                                  
  7221                                  ;-1142             }
  7222                                  
  7223                                  .process279:
  7224                                  
  7225                                  ;-1143             //r/m, imm: 80 sign-extended,TTT,imm
  7226                                  
  7227                                  
  7228                                  ;-1144             c = sflag + 0x80;
  7229                                  
  7230                                  .process278:
  7231 000026FF A0[3A00]                 mov al, [sflag]
  7232 00002702 0480                     add al, 128
  7233 00002704 8846FE                   mov [bp-2], al
  7234                                  
  7235                                  ;-1145             genCodeW(c);
  7236                                  
  7237 00002707 8A46FE                   mov al, byte [bp-2]
  7238 0000270A B400                     mov ah, 0
  7239 0000270C 50                       push ax
  7240 0000270D E8D8FC                   call genCodeW
  7241 00002710 83C402                   add  sp, 2
  7242                                  
  7243                                  ;-1146             writeEA(Code1);
  7244                                  
  7245 00002713 A0[3000]                 mov al, byte [Code1]
  7246 00002716 B400                     mov ah, 0
  7247 00002718 50                       push ax
  7248 00002719 E833FD                   call writeEA
  7249 0000271C 83C402                   add  sp, 2
  7250                                  
  7251                                  ;-1147             if (sflag) genCode8(imme);
  7252                                  
  7253 0000271F A0[3A00]                 mov al, [sflag]
  7254 00002722 08C0                     or  al, al
  7255 00002724 0F840D00                 je .process281
  7256 00002728 FF36[3F00]               push word [imme]
  7257 0000272C E83EFC                   call genCode8
  7258 0000272F 83C402                   add  sp, 2
  7259                                  
  7260                                  ;-1148             else genImmediate();
  7261                                  
  7262 00002732 E90300                   jmp .process282
  7263                                  .process281:
  7264 00002735 E81DFE                   call genImmediate
  7265                                  
  7266                                  ;-1149             return;
  7267                                  
  7268                                  .process282:
  7269 00002738 E98507                   jmp .retnprocess
  7270                                  
  7271                                  ;-1150         }
  7272                                  
  7273                                  
  7274                                  ;-1151         c = Code1 << 3;//r/m, r/r
  7275                                  
  7276                                  .process277:
  7277 0000273B A0[3000]                 mov al, [Code1]
  7278 0000273E C0E003                   shl al, 3
  7279 00002741 8846FE                   mov [bp-2], al
  7280                                  
  7281                                  ;-1152         if (Op == REG) {
  7282                                  
  7283 00002744 A0[2D00]                 mov al, [Op]
  7284 00002747 3C02                     cmp al, 2
  7285 00002749 0F852E00                 jne .process283
  7286                                  
  7287                                  ;-1153             if (Op2 == MEM) {//reg, mem
  7288                                  
  7289 0000274D A0[2E00]                 mov al, [Op2]
  7290 00002750 3C04                     cmp al, 4
  7291 00002752 0F852500                 jne .process284
  7292                                  
  7293                                  ;-1154                 c += 2;//add direction flag
  7294                                  
  7295 00002756 8046FE02                 add  byte[bp-2], 2
  7296                                  
  7297                                  ;-1155                 genCodeW(c);
  7298                                  
  7299 0000275A 8A46FE                   mov al, byte [bp-2]
  7300 0000275D B400                     mov ah, 0
  7301 0000275F 50                       push ax
  7302 00002760 E885FC                   call genCodeW
  7303 00002763 83C402                   add  sp, 2
  7304                                  
  7305                                  ;-1156                 Op=Op2;//set MEM for writeEA
  7306                                  
  7307 00002766 A0[2E00]                 mov al, [Op2]
  7308 00002769 A2[2D00]                 mov byte [Op], al
  7309                                  
  7310                                  ;-1157                 writeEA(R1No);
  7311                                  
  7312 0000276C A0[3400]                 mov al, byte [R1No]
  7313 0000276F B400                     mov ah, 0
  7314 00002771 50                       push ax
  7315 00002772 E8DAFC                   call writeEA
  7316 00002775 83C402                   add  sp, 2
  7317                                  
  7318                                  ;-1158                 return;
  7319                                  
  7320 00002778 E94507                   jmp .retnprocess
  7321                                  
  7322                                  ;-1159             }
  7323                                  
  7324                                  
  7325                                  ;-1160         }
  7326                                  
  7327                                  .process284:
  7328                                  
  7329                                  ;-1161         if (Op2 == REG) {//mem,reg    reg,reg
  7330                                  
  7331                                  .process283:
  7332 0000277B A0[2E00]                 mov al, [Op2]
  7333 0000277E 3C02                     cmp al, 2
  7334 00002780 0F851B00                 jne .process285
  7335                                  
  7336                                  ;-1162             genCodeW(c);
  7337                                  
  7338 00002784 8A46FE                   mov al, byte [bp-2]
  7339 00002787 B400                     mov ah, 0
  7340 00002789 50                       push ax
  7341 0000278A E85BFC                   call genCodeW
  7342 0000278D 83C402                   add  sp, 2
  7343                                  
  7344                                  ;-1163             writeEA(R2No);//2. Op in reg-field
  7345                                  
  7346 00002790 A0[3300]                 mov al, byte [R2No]
  7347 00002793 B400                     mov ah, 0
  7348 00002795 50                       push ax
  7349 00002796 E8B6FC                   call writeEA
  7350 00002799 83C402                   add  sp, 2
  7351                                  
  7352                                  ;-1164             return;
  7353                                  
  7354 0000279C E92107                   jmp .retnprocess
  7355                                  
  7356                                  ;-1165         }
  7357                                  
  7358                                  
  7359                                  ;-1166         syntaxerror();
  7360                                  
  7361                                  .process285:
  7362 0000279F E8D6E5                   call syntaxerror
  7363                                  
  7364                                  ;-1167         return;
  7365                                  
  7366 000027A2 E91B07                   jmp .retnprocess
  7367                                  
  7368                                  ;-1168     }
  7369                                  
  7370                                  
  7371                                  ;-1169 
  7372                                  
  7373                                  
  7374                                  ;-1170     if (CodeType == 5) {//mov (movsx, movzx=51)
  7375                                  
  7376                                  .process276:
  7377 000027A5 A0[2F00]                 mov al, [CodeType]
  7378 000027A8 3C05                     cmp al, 5
  7379 000027AA 0F858B01                 jne .process286
  7380                                  
  7381                                  ;-1171         check2Ops();
  7382                                  
  7383 000027AE E887EB                   call check2Ops
  7384                                  
  7385                                  ;-1172 /*    prs("\n Op:"); printhex8a(Op);
  7386                                  
  7387                                  
  7388                                  ;-1173     prs(", Op2:"); printhex8a(Op2);
  7389                                  
  7390                                  
  7391                                  ;-1174     prs(", R1No:"); printhex8a(R1No);
  7392                                  
  7393                                  
  7394                                  ;-1175     prs(", R2No:"); printhex8a(R2No);   */
  7395                                  
  7396                                  
  7397                                  ;-1176         if (Op2 == ADR) {
  7398                                  
  7399 000027B1 A0[2E00]                 mov al, [Op2]
  7400 000027B4 3C03                     cmp al, 3
  7401 000027B6 0F851B00                 jne .process287
  7402                                  
  7403                                  ;-1177             if (disp) imme=disp;
  7404                                  
  7405 000027BA A1[3D00]                 mov ax, [disp]
  7406 000027BD 08C0                     or  al, al
  7407 000027BF 0F840900                 je .process288
  7408 000027C3 A1[3D00]                 mov ax, [disp]
  7409 000027C6 A3[3F00]                 mov word [imme], ax
  7410                                  
  7411                                  ;-1178             else notfounderror();
  7412                                  
  7413 000027C9 E90300                   jmp .process289
  7414                                  .process288:
  7415 000027CC E81AE4                   call notfounderror
  7416                                  
  7417                                  ;-1179             Op2=IMM;//continue with IMM
  7418                                  
  7419                                  .process289:
  7420 000027CF B80100                   mov ax, 1
  7421 000027D2 A2[2E00]                 mov byte [Op2], al
  7422                                  
  7423                                  ;-1180         }
  7424                                  
  7425                                  
  7426                                  ;-1181         if (Op2 == IMM) {// r,i
  7427                                  
  7428                                  .process287:
  7429 000027D5 A0[2E00]                 mov al, [Op2]
  7430 000027D8 3C01                     cmp al, 1
  7431 000027DA 0F855400                 jne .process290
  7432                                  
  7433                                  ;-1182             if (Op == REG) {
  7434                                  
  7435 000027DE A0[2D00]                 mov al, [Op]
  7436 000027E1 3C02                     cmp al, 2
  7437 000027E3 0F852500                 jne .process291
  7438                                  
  7439                                  ;-1183                 c = wflag << 3;
  7440                                  
  7441 000027E7 A0[3800]                 mov al, [wflag]
  7442 000027EA C0E003                   shl al, 3
  7443 000027ED 8846FE                   mov [bp-2], al
  7444                                  
  7445                                  ;-1184                 c += 0xB0;
  7446                                  
  7447 000027F0 8046FEB0                 add  byte[bp-2], 176
  7448                                  
  7449                                  ;-1185                 genCode2(c, R1No);
  7450                                  
  7451 000027F4 A0[3400]                 mov al, byte [R1No]
  7452 000027F7 B400                     mov ah, 0
  7453 000027F9 50                       push ax
  7454 000027FA 8A46FE                   mov al, byte [bp-2]
  7455 000027FD B400                     mov ah, 0
  7456 000027FF 50                       push ax
  7457 00002800 E8CAFB                   call genCode2
  7458 00002803 83C404                   add  sp, 4
  7459                                  
  7460                                  ;-1186                 genImmediate();
  7461                                  
  7462 00002806 E84CFD                   call genImmediate
  7463                                  
  7464                                  ;-1187                 return;
  7465                                  
  7466 00002809 E9B406                   jmp .retnprocess
  7467                                  
  7468                                  ;-1188             }
  7469                                  
  7470                                  
  7471                                  ;-1189             if (Op == MEM) {// m,i
  7472                                  
  7473                                  .process291:
  7474 0000280C A0[2D00]                 mov al, [Op]
  7475 0000280F 3C04                     cmp al, 4
  7476 00002811 0F851700                 jne .process292
  7477                                  
  7478                                  ;-1190                 genCodeW(0xC6);
  7479                                  
  7480 00002815 68C600                   push 198
  7481 00002818 E8CDFB                   call genCodeW
  7482 0000281B 83C402                   add  sp, 2
  7483                                  
  7484                                  ;-1191                 writeEA( 0 );
  7485                                  
  7486 0000281E 6A00                     push 0
  7487 00002820 E82CFC                   call writeEA
  7488 00002823 83C402                   add  sp, 2
  7489                                  
  7490                                  ;-1192                 genImmediate();
  7491                                  
  7492 00002826 E82CFD                   call genImmediate
  7493                                  
  7494                                  ;-1193                 return;
  7495                                  
  7496 00002829 E99406                   jmp .retnprocess
  7497                                  
  7498                                  ;-1194             }
  7499                                  
  7500                                  
  7501                                  ;-1195             regmemerror();
  7502                                  
  7503                                  .process292:
  7504 0000282C E8D0E4                   call regmemerror
  7505                                  
  7506                                  ;-1196             return;
  7507                                  
  7508 0000282F E98E06                   jmp .retnprocess
  7509                                  
  7510                                  ;-1197         }
  7511                                  
  7512                                  
  7513                                  ;-1198         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7514                                  
  7515                                  .process290:
  7516 00002832 A0[3600]                 mov al, [R1Type]
  7517 00002835 3C04                     cmp al, 4
  7518 00002837 0F850300                 jne .process293
  7519 0000283B E836EA                   call ChangeDirection
  7520                                  
  7521                                  ;-1199         if (R2Type == SEGREG) {//rm,sreg
  7522                                  
  7523                                  .process293:
  7524 0000283E A0[3500]                 mov al, [R2Type]
  7525 00002841 3C04                     cmp al, 4
  7526 00002843 0F852A00                 jne .process294
  7527                                  
  7528                                  ;-1200             if (OpSize != WORD) reg16error();
  7529                                  
  7530 00002847 A0[3700]                 mov al, [OpSize]
  7531 0000284A 3C02                     cmp al, 2
  7532 0000284C 0F840300                 je  .process295
  7533 00002850 E8D6E4                   call reg16error
  7534                                  
  7535                                  ;-1201                 genCode2(0x8C, dflag);
  7536                                  
  7537                                  .process295:
  7538 00002853 A0[3900]                 mov al, byte [dflag]
  7539 00002856 B400                     mov ah, 0
  7540 00002858 50                       push ax
  7541 00002859 688C00                   push 140
  7542 0000285C E86EFB                   call genCode2
  7543 0000285F 83C404                   add  sp, 4
  7544                                  
  7545                                  ;-1202                 writeEA(R2No);
  7546                                  
  7547 00002862 A0[3300]                 mov al, byte [R2No]
  7548 00002865 B400                     mov ah, 0
  7549 00002867 50                       push ax
  7550 00002868 E8E4FB                   call writeEA
  7551 0000286B 83C402                   add  sp, 2
  7552                                  
  7553                                  ;-1203                 return;
  7554                                  
  7555 0000286E E94F06                   jmp .retnprocess
  7556                                  
  7557                                  ;-1204         }
  7558                                  
  7559                                  
  7560                                  ;-1205         if (Op2 == MEM) {//acc, moffs16
  7561                                  
  7562                                  .process294:
  7563 00002871 A0[2E00]                 mov al, [Op2]
  7564 00002874 3C04                     cmp al, 4
  7565 00002876 0F853100                 jne .process296
  7566                                  
  7567                                  ;-1206             if (Op == REG) {
  7568                                  
  7569 0000287A A0[2D00]                 mov al, [Op]
  7570 0000287D 3C02                     cmp al, 2
  7571 0000287F 0F852800                 jne .process297
  7572                                  
  7573                                  ;-1207                 if (R1No == 0) {
  7574                                  
  7575 00002883 A0[3400]                 mov al, [R1No]
  7576 00002886 3C00                     cmp al, 0
  7577 00002888 0F851F00                 jne .process298
  7578                                  
  7579                                  ;-1208                     if (isDirect) {
  7580                                  
  7581 0000288C A0[3C00]                 mov al, [isDirect]
  7582 0000288F 08C0                     or  al, al
  7583 00002891 0F841600                 je .process299
  7584                                  
  7585                                  ;-1209                         genCodeW(0xA0);
  7586                                  
  7587 00002895 68A000                   push 160
  7588 00002898 E84DFB                   call genCodeW
  7589 0000289B 83C402                   add  sp, 2
  7590                                  
  7591                                  ;-1210                         genCode16(disp);
  7592                                  
  7593 0000289E FF36[3D00]               push word [disp]
  7594 000028A2 E85FFB                   call genCode16
  7595 000028A5 83C402                   add  sp, 2
  7596                                  
  7597                                  ;-1211                         return;
  7598                                  
  7599 000028A8 E91506                   jmp .retnprocess
  7600                                  
  7601                                  ;-1212                     }
  7602                                  
  7603                                  
  7604                                  ;-1213                 }
  7605                                  
  7606                                  .process299:
  7607                                  
  7608                                  ;-1214             }
  7609                                  
  7610                                  .process298:
  7611                                  
  7612                                  ;-1215         }
  7613                                  
  7614                                  .process297:
  7615                                  
  7616                                  ;-1216         if (Op == MEM) {//moffs16, acc
  7617                                  
  7618                                  .process296:
  7619 000028AB A0[2D00]                 mov al, [Op]
  7620 000028AE 3C04                     cmp al, 4
  7621 000028B0 0F853100                 jne .process300
  7622                                  
  7623                                  ;-1217             if (Op2 == REG) {
  7624                                  
  7625 000028B4 A0[2E00]                 mov al, [Op2]
  7626 000028B7 3C02                     cmp al, 2
  7627 000028B9 0F852800                 jne .process301
  7628                                  
  7629                                  ;-1218                 if (R2No == 0) {
  7630                                  
  7631 000028BD A0[3300]                 mov al, [R2No]
  7632 000028C0 3C00                     cmp al, 0
  7633 000028C2 0F851F00                 jne .process302
  7634                                  
  7635                                  ;-1219                     if (isDirect) {
  7636                                  
  7637 000028C6 A0[3C00]                 mov al, [isDirect]
  7638 000028C9 08C0                     or  al, al
  7639 000028CB 0F841600                 je .process303
  7640                                  
  7641                                  ;-1220                         genCodeW(0xA2);
  7642                                  
  7643 000028CF 68A200                   push 162
  7644 000028D2 E813FB                   call genCodeW
  7645 000028D5 83C402                   add  sp, 2
  7646                                  
  7647                                  ;-1221                         genCode16(disp);
  7648                                  
  7649 000028D8 FF36[3D00]               push word [disp]
  7650 000028DC E825FB                   call genCode16
  7651 000028DF 83C402                   add  sp, 2
  7652                                  
  7653                                  ;-1222                         return;
  7654                                  
  7655 000028E2 E9DB05                   jmp .retnprocess
  7656                                  
  7657                                  ;-1223                     }
  7658                                  
  7659                                  
  7660                                  ;-1224                 }
  7661                                  
  7662                                  .process303:
  7663                                  
  7664                                  ;-1225             }
  7665                                  
  7666                                  .process302:
  7667                                  
  7668                                  ;-1226 
  7669                                  
  7670                                  
  7671                                  ;-1227         }
  7672                                  
  7673                                  .process301:
  7674                                  
  7675                                  ;-1228         if (Op2 == REG) {//rm, r
  7676                                  
  7677                                  .process300:
  7678 000028E5 A0[2E00]                 mov al, [Op2]
  7679 000028E8 3C02                     cmp al, 2
  7680 000028EA 0F851800                 jne .process304
  7681                                  
  7682                                  ;-1229             genCodeW(0x88);
  7683                                  
  7684 000028EE 688800                   push 136
  7685 000028F1 E8F4FA                   call genCodeW
  7686 000028F4 83C402                   add  sp, 2
  7687                                  
  7688                                  ;-1230             writeEA(R2No);
  7689                                  
  7690 000028F7 A0[3300]                 mov al, byte [R2No]
  7691 000028FA B400                     mov ah, 0
  7692 000028FC 50                       push ax
  7693 000028FD E84FFB                   call writeEA
  7694 00002900 83C402                   add  sp, 2
  7695                                  
  7696                                  ;-1231             return;
  7697                                  
  7698 00002903 E9BA05                   jmp .retnprocess
  7699                                  
  7700                                  ;-1232         }
  7701                                  
  7702                                  
  7703                                  ;-1233         if (Op2 == MEM) {//r, m
  7704                                  
  7705                                  .process304:
  7706 00002906 A0[2E00]                 mov al, [Op2]
  7707 00002909 3C04                     cmp al, 4
  7708 0000290B 0F852400                 jne .process305
  7709                                  
  7710                                  ;-1234             if (Op == REG) {
  7711                                  
  7712 0000290F A0[2D00]                 mov al, [Op]
  7713 00002912 3C02                     cmp al, 2
  7714 00002914 0F851B00                 jne .process306
  7715                                  
  7716                                  ;-1235                 ChangeDirection();
  7717                                  
  7718 00002918 E859E9                   call ChangeDirection
  7719                                  
  7720                                  ;-1236                 genCodeW(0x8A);
  7721                                  
  7722 0000291B 688A00                   push 138
  7723 0000291E E8C7FA                   call genCodeW
  7724 00002921 83C402                   add  sp, 2
  7725                                  
  7726                                  ;-1237                 writeEA(R2No);
  7727                                  
  7728 00002924 A0[3300]                 mov al, byte [R2No]
  7729 00002927 B400                     mov ah, 0
  7730 00002929 50                       push ax
  7731 0000292A E822FB                   call writeEA
  7732 0000292D 83C402                   add  sp, 2
  7733                                  
  7734                                  ;-1238                 return;
  7735                                  
  7736 00002930 E98D05                   jmp .retnprocess
  7737                                  
  7738                                  ;-1239             }
  7739                                  
  7740                                  
  7741                                  ;-1240         }
  7742                                  
  7743                                  .process306:
  7744                                  
  7745                                  ;-1241         syntaxerror();
  7746                                  
  7747                                  .process305:
  7748 00002933 E842E4                   call syntaxerror
  7749                                  
  7750                                  ;-1242         return;
  7751                                  
  7752 00002936 E98705                   jmp .retnprocess
  7753                                  
  7754                                  ;-1243     }
  7755                                  
  7756                                  
  7757                                  ;-1244 
  7758                                  
  7759                                  
  7760                                  ;-1245     if (CodeType == 6) {//Jcc
  7761                                  
  7762                                  .process286:
  7763 00002939 A0[2F00]                 mov al, [CodeType]
  7764 0000293C 3C06                     cmp al, 6
  7765 0000293E 0F85BE00                 jne .process307
  7766                                  
  7767                                  ;-1246         if (TokeType == ALNUME) {
  7768                                  
  7769 00002942 A0[2C00]                 mov al, [TokeType]
  7770 00002945 3C03                     cmp al, 3
  7771 00002947 0F85B500                 jne .process308
  7772                                  
  7773                                  ;-1247             LabelIx=searchLabel();
  7774                                  
  7775 0000294B E8C9F0                   call searchLabel
  7776 0000294E A3[4E00]                 mov word [LabelIx], ax
  7777                                  
  7778                                  ;-1248             if (LabelIx > 0) {
  7779                                  
  7780 00002951 A1[4E00]                 mov ax, [LabelIx]
  7781 00002954 83F800                   cmp ax, 0
  7782 00002957 0F8E7A00                 jle .process309
  7783                                  
  7784                                  ;-1249                 disp=LabelAddr[LabelIx];
  7785                                  
  7786 0000295B 8B1E[4E00]               mov bx, [LabelIx]
  7787 0000295F D1E3                     shl bx, 1
  7788 00002961 8B87CA8E                 mov ax, [LabelAddr + bx]
  7789 00002965 A3[3D00]                 mov word [disp], ax
  7790                                  
  7791                                  ;-1250                 disp = disp - PC;
  7792                                  
  7793 00002968 A1[3D00]                 mov ax, [disp]
  7794 0000296B 2B06[2300]               sub ax, [PC]
  7795 0000296F A3[3D00]                 mov word [disp], ax
  7796                                  
  7797                                  ;-1251                 disp = disp - Origin;
  7798                                  
  7799 00002972 A1[3D00]                 mov ax, [disp]
  7800 00002975 2B06[2500]               sub ax, [Origin]
  7801 00002979 A3[3D00]                 mov word [disp], ax
  7802                                  
  7803                                  ;-1252                 if (checkConstSize(disp) ) {
  7804                                  
  7805 0000297C FF36[3D00]               push word [disp]
  7806 00002980 E8A0ED                   call checkConstSize
  7807 00002983 83C402                   add  sp, 2
  7808 00002986 08C0                     or  al, al
  7809 00002988 0F842000                 je .process310
  7810                                  
  7811                                  ;-1253                     genCode2(Code1, 0x70);//short
  7812                                  
  7813 0000298C 6A70                     push 112
  7814 0000298E A0[3000]                 mov al, byte [Code1]
  7815 00002991 B400                     mov ah, 0
  7816 00002993 50                       push ax
  7817 00002994 E836FA                   call genCode2
  7818 00002997 83C404                   add  sp, 4
  7819                                  
  7820                                  ;-1254                     disp -= 2;
  7821                                  
  7822 0000299A 832E[3D00]02             sub  word[disp], 2
  7823                                  
  7824                                  ;-1255                     genCode8(disp);
  7825                                  
  7826 0000299F FF36[3D00]               push word [disp]
  7827 000029A3 E8C7F9                   call genCode8
  7828 000029A6 83C402                   add  sp, 2
  7829                                  
  7830                                  ;-1256                 } else {
  7831                                  
  7832 000029A9 E92600                   jmp .process311
  7833                                  .process310:
  7834                                  
  7835                                  ;-1257                     genCode8(0x0F);
  7836                                  
  7837 000029AC 6A0F                     push 15
  7838 000029AE E8BCF9                   call genCode8
  7839 000029B1 83C402                   add  sp, 2
  7840                                  
  7841                                  ;-1258                     genCode2(Code1, 0x80);//near
  7842                                  
  7843 000029B4 688000                   push 128
  7844 000029B7 A0[3000]                 mov al, byte [Code1]
  7845 000029BA B400                     mov ah, 0
  7846 000029BC 50                       push ax
  7847 000029BD E80DFA                   call genCode2
  7848 000029C0 83C404                   add  sp, 4
  7849                                  
  7850                                  ;-1259                     disp -= 4;
  7851                                  
  7852 000029C3 832E[3D00]04             sub  word[disp], 4
  7853                                  
  7854                                  ;-1260                     genCode16(disp);
  7855                                  
  7856 000029C8 FF36[3D00]               push word [disp]
  7857 000029CC E835FA                   call genCode16
  7858 000029CF 83C402                   add  sp, 2
  7859                                  
  7860                                  ;-1261                 }
  7861                                  
  7862                                  
  7863                                  ;-1262             }
  7864                                  
  7865                                  .process311:
  7866                                  
  7867                                  ;-1263             else {//jump forward, near only
  7868                                  
  7869 000029D2 E92800                   jmp .process312
  7870                                  .process309:
  7871                                  
  7872                                  ;-1264                 genCode8(0x0F);
  7873                                  
  7874 000029D5 6A0F                     push 15
  7875 000029D7 E893F9                   call genCode8
  7876 000029DA 83C402                   add  sp, 2
  7877                                  
  7878                                  ;-1265                 genCode2(Code1, 0x80);
  7879                                  
  7880 000029DD 688000                   push 128
  7881 000029E0 A0[3000]                 mov al, byte [Code1]
  7882 000029E3 B400                     mov ah, 0
  7883 000029E5 50                       push ax
  7884 000029E6 E8E4F9                   call genCode2
  7885 000029E9 83C404                   add  sp, 4
  7886                                  
  7887                                  ;-1266                 storeJmp();
  7888                                  
  7889 000029EC E805EF                   call storeJmp
  7890                                  
  7891                                  ;-1267                 genCode16(0);
  7892                                  
  7893 000029EF 6A00                     push 0
  7894 000029F1 E810FA                   call genCode16
  7895 000029F4 83C402                   add  sp, 2
  7896                                  
  7897                                  ;-1268                 PrintRA='r';
  7898                                  
  7899 000029F7 B87200                   mov ax, 114
  7900 000029FA A2[4500]                 mov byte [PrintRA], al
  7901                                  
  7902                                  ;-1269             }
  7903                                  
  7904                                  
  7905                                  ;-1270         return;
  7906                                  
  7907                                  .process312:
  7908 000029FD E9C004                   jmp .retnprocess
  7909                                  
  7910                                  ;-1271         }
  7911                                  
  7912                                  
  7913                                  ;-1272     }
  7914                                  
  7915                                  .process308:
  7916                                  
  7917                                  ;-1273 
  7918                                  
  7919                                  
  7920                                  ;-1274     if (CodeType == 7) {//jmp, call
  7921                                  
  7922                                  .process307:
  7923 00002A00 A0[2F00]                 mov al, [CodeType]
  7924 00002A03 3C07                     cmp al, 7
  7925 00002A05 0F85D400                 jne .process313
  7926                                  
  7927                                  ;-1275         if (TokeType == ALNUME) {
  7928                                  
  7929 00002A09 A0[2C00]                 mov al, [TokeType]
  7930 00002A0C 3C03                     cmp al, 3
  7931 00002A0E 0F85CB00                 jne .process314
  7932                                  
  7933                                  ;-1276             LabelIx=searchLabel();
  7934                                  
  7935 00002A12 E802F0                   call searchLabel
  7936 00002A15 A3[4E00]                 mov word [LabelIx], ax
  7937                                  
  7938                                  ;-1277             if (LabelIx > 0) {
  7939                                  
  7940 00002A18 A1[4E00]                 mov ax, [LabelIx]
  7941 00002A1B 83F800                   cmp ax, 0
  7942 00002A1E 0F8E9100                 jle .process315
  7943                                  
  7944                                  ;-1278                 disp=LabelAddr[LabelIx];
  7945                                  
  7946 00002A22 8B1E[4E00]               mov bx, [LabelIx]
  7947 00002A26 D1E3                     shl bx, 1
  7948 00002A28 8B87CA8E                 mov ax, [LabelAddr + bx]
  7949 00002A2C A3[3D00]                 mov word [disp], ax
  7950                                  
  7951                                  ;-1279                 disp = disp - PC;
  7952                                  
  7953 00002A2F A1[3D00]                 mov ax, [disp]
  7954 00002A32 2B06[2300]               sub ax, [PC]
  7955 00002A36 A3[3D00]                 mov word [disp], ax
  7956                                  
  7957                                  ;-1280                 disp = disp - Origin;
  7958                                  
  7959 00002A39 A1[3D00]                 mov ax, [disp]
  7960 00002A3C 2B06[2500]               sub ax, [Origin]
  7961 00002A40 A3[3D00]                 mov word [disp], ax
  7962                                  
  7963                                  ;-1281                 if (checkConstSize(disp) ) {
  7964                                  
  7965 00002A43 FF36[3D00]               push word [disp]
  7966 00002A47 E8D9EC                   call checkConstSize
  7967 00002A4A 83C402                   add  sp, 2
  7968 00002A4D 08C0                     or  al, al
  7969 00002A4F 0F844200                 je .process316
  7970                                  
  7971                                  ;-1282                     if (Code1 == 0xE9) {//jmp only
  7972                                  
  7973 00002A53 A0[3000]                 mov al, [Code1]
  7974 00002A56 3CE9                     cmp al, 233
  7975 00002A58 0F851B00                 jne .process317
  7976                                  
  7977                                  ;-1283                         genCode8(0xEB);//short
  7978                                  
  7979 00002A5C 68EB00                   push 235
  7980 00002A5F E80BF9                   call genCode8
  7981 00002A62 83C402                   add  sp, 2
  7982                                  
  7983                                  ;-1284                         disp -= 2;
  7984                                  
  7985 00002A65 832E[3D00]02             sub  word[disp], 2
  7986                                  
  7987                                  ;-1285                         genCode8(disp);
  7988                                  
  7989 00002A6A FF36[3D00]               push word [disp]
  7990 00002A6E E8FCF8                   call genCode8
  7991 00002A71 83C402                   add  sp, 2
  7992                                  
  7993                                  ;-1286                     }
  7994                                  
  7995                                  
  7996                                  ;-1287                     else {
  7997                                  
  7998 00002A74 E91B00                   jmp .process318
  7999                                  .process317:
  8000                                  
  8001                                  ;-1288                         genCode8(Code1);//near
  8002                                  
  8003 00002A77 A0[3000]                 mov al, byte [Code1]
  8004 00002A7A B400                     mov ah, 0
  8005 00002A7C 50                       push ax
  8006 00002A7D E8EDF8                   call genCode8
  8007 00002A80 83C402                   add  sp, 2
  8008                                  
  8009                                  ;-1289                         disp -= 3;
  8010                                  
  8011 00002A83 832E[3D00]03             sub  word[disp], 3
  8012                                  
  8013                                  ;-1290                         genCode16(disp);
  8014                                  
  8015 00002A88 FF36[3D00]               push word [disp]
  8016 00002A8C E875F9                   call genCode16
  8017 00002A8F 83C402                   add  sp, 2
  8018                                  
  8019                                  ;-1291                     }
  8020                                  
  8021                                  
  8022                                  ;-1292                 }
  8023                                  
  8024                                  .process318:
  8025                                  
  8026                                  ;-1293                 else {
  8027                                  
  8028 00002A92 E91B00                   jmp .process319
  8029                                  .process316:
  8030                                  
  8031                                  ;-1294                     genCode8(Code1);//near
  8032                                  
  8033 00002A95 A0[3000]                 mov al, byte [Code1]
  8034 00002A98 B400                     mov ah, 0
  8035 00002A9A 50                       push ax
  8036 00002A9B E8CFF8                   call genCode8
  8037 00002A9E 83C402                   add  sp, 2
  8038                                  
  8039                                  ;-1295                     disp -= 3;
  8040                                  
  8041 00002AA1 832E[3D00]03             sub  word[disp], 3
  8042                                  
  8043                                  ;-1296                     genCode16(disp);
  8044                                  
  8045 00002AA6 FF36[3D00]               push word [disp]
  8046 00002AAA E857F9                   call genCode16
  8047 00002AAD 83C402                   add  sp, 2
  8048                                  
  8049                                  ;-1297                 }
  8050                                  
  8051                                  
  8052                                  ;-1298             }
  8053                                  
  8054                                  .process319:
  8055                                  
  8056                                  ;-1299             else {//jump forward, near only
  8057                                  
  8058 00002AB0 E92700                   jmp .process320
  8059                                  .process315:
  8060                                  
  8061                                  ;-1300                 genCode8(Code1);  
  8062                                  
  8063 00002AB3 A0[3000]                 mov al, byte [Code1]
  8064 00002AB6 B400                     mov ah, 0
  8065 00002AB8 50                       push ax
  8066 00002AB9 E8B1F8                   call genCode8
  8067 00002ABC 83C402                   add  sp, 2
  8068                                  
  8069                                  ;-1301                 if (PC != 1) storeJmp();//omit jmp main
  8070                                  
  8071 00002ABF A1[2300]                 mov ax, [PC]
  8072 00002AC2 83F801                   cmp ax, 1
  8073 00002AC5 0F840300                 je  .process321
  8074 00002AC9 E828EE                   call storeJmp
  8075                                  
  8076                                  ;-1302                 genCode16(0);
  8077                                  
  8078                                  .process321:
  8079 00002ACC 6A00                     push 0
  8080 00002ACE E833F9                   call genCode16
  8081 00002AD1 83C402                   add  sp, 2
  8082                                  
  8083                                  ;-1303                 PrintRA='R';
  8084                                  
  8085 00002AD4 B85200                   mov ax, 82
  8086 00002AD7 A2[4500]                 mov byte [PrintRA], al
  8087                                  
  8088                                  ;-1304             }
  8089                                  
  8090                                  
  8091                                  ;-1305         return;
  8092                                  
  8093                                  .process320:
  8094 00002ADA E9E303                   jmp .retnprocess
  8095                                  
  8096                                  ;-1306         }
  8097                                  
  8098                                  
  8099                                  ;-1307     }
  8100                                  
  8101                                  .process314:
  8102                                  
  8103                                  ;-1308 
  8104                                  
  8105                                  
  8106                                  ;-1309     if (CodeType ==  8) {//ret,retf
  8107                                  
  8108                                  .process313:
  8109 00002ADD A0[2F00]                 mov al, [CodeType]
  8110 00002AE0 3C08                     cmp al, 8
  8111 00002AE2 0F853100                 jne .process322
  8112                                  
  8113                                  ;-1310         if (TokeType == DIGIT) {
  8114                                  
  8115 00002AE6 A0[2C00]                 mov al, [TokeType]
  8116 00002AE9 3C01                     cmp al, 1
  8117 00002AEB 0F851900                 jne .process323
  8118                                  
  8119                                  ;-1311             genCode8(Code2);
  8120                                  
  8121 00002AEF A0[3100]                 mov al, byte [Code2]
  8122 00002AF2 B400                     mov ah, 0
  8123 00002AF4 50                       push ax
  8124 00002AF5 E875F8                   call genCode8
  8125 00002AF8 83C402                   add  sp, 2
  8126                                  
  8127                                  ;-1312             genCode16(SymbolInt);
  8128                                  
  8129 00002AFB FF36[0E00]               push word [SymbolInt]
  8130 00002AFF E802F9                   call genCode16
  8131 00002B02 83C402                   add  sp, 2
  8132                                  
  8133                                  ;-1313             return;
  8134                                  
  8135 00002B05 E9B803                   jmp .retnprocess
  8136                                  
  8137                                  ;-1314         }
  8138                                  
  8139                                  
  8140                                  ;-1315         genCode8(Code1);
  8141                                  
  8142                                  .process323:
  8143 00002B08 A0[3000]                 mov al, byte [Code1]
  8144 00002B0B B400                     mov ah, 0
  8145 00002B0D 50                       push ax
  8146 00002B0E E85CF8                   call genCode8
  8147 00002B11 83C402                   add  sp, 2
  8148                                  
  8149                                  ;-1316         return;
  8150                                  
  8151 00002B14 E9A903                   jmp .retnprocess
  8152                                  
  8153                                  ;-1317     }
  8154                                  
  8155                                  
  8156                                  ;-1318 
  8157                                  
  8158                                  
  8159                                  ;-1319     if (CodeType == 9) {//push, pop
  8160                                  
  8161                                  .process322:
  8162 00002B17 A0[2F00]                 mov al, [CodeType]
  8163 00002B1A 3C09                     cmp al, 9
  8164 00002B1C 0F854A01                 jne .process324
  8165                                  
  8166                                  ;-1320         getOpL();
  8167                                  
  8168 00002B20 E870E8                   call getOpL
  8169                                  
  8170                                  ;-1321         if (Code1 == 0x50) {//push only
  8171                                  
  8172 00002B23 A0[3000]                 mov al, [Code1]
  8173 00002B26 3C50                     cmp al, 80
  8174 00002B28 0F858400                 jne .process325
  8175                                  
  8176                                  ;-1322             if (Op == IMM) {//push imm8,16
  8177                                  
  8178 00002B2C A0[2D00]                 mov al, [Op]
  8179 00002B2F 3C01                     cmp al, 1
  8180 00002B31 0F853400                 jne .process326
  8181                                  
  8182                                  ;-1323                 setsflag();
  8183                                  
  8184 00002B35 E88FEB                   call setsflag
  8185                                  
  8186                                  ;-1324                 genCode2(0x68, sflag);
  8187                                  
  8188 00002B38 A0[3A00]                 mov al, byte [sflag]
  8189 00002B3B B400                     mov ah, 0
  8190 00002B3D 50                       push ax
  8191 00002B3E 6A68                     push 104
  8192 00002B40 E88AF8                   call genCode2
  8193 00002B43 83C404                   add  sp, 4
  8194                                  
  8195                                  ;-1325                 if (sflag) genCode8 (imme);
  8196                                  
  8197 00002B46 A0[3A00]                 mov al, [sflag]
  8198 00002B49 08C0                     or  al, al
  8199 00002B4B 0F840D00                 je .process327
  8200 00002B4F FF36[3F00]               push word [imme]
  8201 00002B53 E817F8                   call genCode8
  8202 00002B56 83C402                   add  sp, 2
  8203                                  
  8204                                  ;-1326                 else       genCode16(imme);
  8205                                  
  8206 00002B59 E90A00                   jmp .process328
  8207                                  .process327:
  8208 00002B5C FF36[3F00]               push word [imme]
  8209 00002B60 E8A1F8                   call genCode16
  8210 00002B63 83C402                   add  sp, 2
  8211                                  
  8212                                  ;-1327                 return;
  8213                                  
  8214                                  .process328:
  8215 00002B66 E95703                   jmp .retnprocess
  8216                                  
  8217                                  ;-1328             }
  8218                                  
  8219                                  
  8220                                  ;-1329             if (Op == ADR) {//push string ABSOLUTE i16 
  8221                                  
  8222                                  .process326:
  8223 00002B69 A0[2D00]                 mov al, [Op]
  8224 00002B6C 3C03                     cmp al, 3
  8225 00002B6E 0F853E00                 jne .process329
  8226                                  
  8227                                  ;-1330 //prscomment("\n push disp: "); printhex16 (disp);
  8228                                  
  8229                                  
  8230                                  ;-1331                 if (disp) {
  8231                                  
  8232 00002B72 A1[3D00]                 mov ax, [disp]
  8233 00002B75 08C0                     or  al, al
  8234 00002B77 0F841800                 je .process330
  8235                                  
  8236                                  ;-1332                     genCode8(0x68);
  8237                                  
  8238 00002B7B 6A68                     push 104
  8239 00002B7D E8EDF7                   call genCode8
  8240 00002B80 83C402                   add  sp, 2
  8241                                  
  8242                                  ;-1333                     genCode16(disp);
  8243                                  
  8244 00002B83 FF36[3D00]               push word [disp]
  8245 00002B87 E87AF8                   call genCode16
  8246 00002B8A 83C402                   add  sp, 2
  8247                                  
  8248                                  ;-1334                     return;
  8249                                  
  8250 00002B8D E93003                   jmp .retnprocess
  8251                                  
  8252                                  ;-1335                 }
  8253                                  
  8254                                  
  8255                                  ;-1336                 else {
  8256                                  
  8257 00002B90 E91D00                   jmp .process331
  8258                                  .process330:
  8259                                  
  8260                                  ;-1337                     genCode8(0x68);
  8261                                  
  8262 00002B93 6A68                     push 104
  8263 00002B95 E8D5F7                   call genCode8
  8264 00002B98 83C402                   add  sp, 2
  8265                                  
  8266                                  ;-1338                     storeJmp();
  8267                                  
  8268 00002B9B E856ED                   call storeJmp
  8269                                  
  8270                                  ;-1339                     genCode16(0xAAAA);//magic for abs ADR
  8271                                  
  8272 00002B9E 68AAAA                   push 43690
  8273 00002BA1 E860F8                   call genCode16
  8274 00002BA4 83C402                   add  sp, 2
  8275                                  
  8276                                  ;-1340                     PrintRA='A';
  8277                                  
  8278 00002BA7 B84100                   mov ax, 65
  8279 00002BAA A2[4500]                 mov byte [PrintRA], al
  8280                                  
  8281                                  ;-1341                     return;
  8282                                  
  8283 00002BAD E91003                   jmp .retnprocess
  8284                                  
  8285                                  ;-1342                 }
  8286                                  
  8287                                  
  8288                                  ;-1343             }
  8289                                  
  8290                                  .process331:
  8291                                  
  8292                                  ;-1344         }
  8293                                  
  8294                                  .process329:
  8295                                  
  8296                                  ;-1345         if (R1Type == SEGREG) {
  8297                                  
  8298                                  .process325:
  8299 00002BB0 A0[3600]                 mov al, [R1Type]
  8300 00002BB3 3C04                     cmp al, 4
  8301 00002BB5 0F855A00                 jne .process332
  8302                                  
  8303                                  ;-1346             if (Code1 == 0x58) {//pop only
  8304                                  
  8305 00002BB9 A0[3000]                 mov al, [Code1]
  8306 00002BBC 3C58                     cmp al, 88
  8307 00002BBE 0F851200                 jne .process333
  8308                                  
  8309                                  ;-1347                 if (R1No == 1) error1("pop cs not allowed");
  8310                                  
  8311 00002BC2 A0[3400]                 mov al, [R1No]
  8312 00002BC5 3C01                     cmp al, 1
  8313 00002BC7 0F850900                 jne .process334
  8314 00002BCB 68[C22E]                 push process_0
  8315 00002BCE E8A8DF                   call error1
  8316 00002BD1 83C402                   add  sp, 2
  8317                                  
  8318                                  ;-1348             }
  8319                                  
  8320                                  .process334:
  8321                                  
  8322                                  ;-1349             c = R1No <<3;
  8323                                  
  8324                                  .process333:
  8325 00002BD4 A0[3400]                 mov al, [R1No]
  8326 00002BD7 C0E003                   shl al, 3
  8327 00002BDA 8846FE                   mov [bp-2], al
  8328                                  
  8329                                  ;-1350             if (R1No > 3) {//FS, GS
  8330                                  
  8331 00002BDD A0[3400]                 mov al, [R1No]
  8332 00002BE0 3C03                     cmp al, 3
  8333 00002BE2 0F8E0C00                 jle .process335
  8334                                  
  8335                                  ;-1351                 c += 122;
  8336                                  
  8337 00002BE6 8046FE7A                 add  byte[bp-2], 122
  8338                                  
  8339                                  ;-1352                 genCode8(0x0F);
  8340                                  
  8341 00002BEA 6A0F                     push 15
  8342 00002BEC E87EF7                   call genCode8
  8343 00002BEF 83C402                   add  sp, 2
  8344                                  
  8345                                  ;-1353             }
  8346                                  
  8347                                  
  8348                                  ;-1354             OpCodePtr++;
  8349                                  
  8350                                  .process335:
  8351 00002BF2 FF06[4300]               inc  word[OpCodePtr]
  8352                                  
  8353                                  ;-1355             c = c + *OpCodePtr;////////////////is Code4
  8354                                  
  8355 00002BF6 8A46FE                   mov al, [bp-2]
  8356 00002BF9 8B1E[4300]               mov bx, [OpCodePtr]
  8357 00002BFD 0207                     add al, [bx]
  8358 00002BFF B400                     mov ah, 0
  8359 00002C01 8846FE                   mov [bp-2], al
  8360                                  
  8361                                  ;-1356             genCode8(c);
  8362                                  
  8363 00002C04 8A46FE                   mov al, byte [bp-2]
  8364 00002C07 B400                     mov ah, 0
  8365 00002C09 50                       push ax
  8366 00002C0A E860F7                   call genCode8
  8367 00002C0D 83C402                   add  sp, 2
  8368                                  
  8369                                  ;-1357             return;
  8370                                  
  8371 00002C10 E9AD02                   jmp .retnprocess
  8372                                  
  8373                                  ;-1358         }
  8374                                  
  8375                                  
  8376                                  ;-1359         checkOpL();//no ADR, SEGREG
  8377                                  
  8378                                  .process332:
  8379 00002C13 E8A0E6                   call checkOpL
  8380                                  
  8381                                  ;-1360         if (R1Type == BYTE) reg16error();
  8382                                  
  8383 00002C16 A0[3600]                 mov al, [R1Type]
  8384 00002C19 3C01                     cmp al, 1
  8385 00002C1B 0F850300                 jne .process336
  8386 00002C1F E807E1                   call reg16error
  8387                                  
  8388                                  ;-1361         if (R1Type == WORD) {
  8389                                  
  8390                                  .process336:
  8391 00002C22 A0[3600]                 mov al, [R1Type]
  8392 00002C25 3C02                     cmp al, 2
  8393 00002C27 0F851500                 jne .process337
  8394                                  
  8395                                  ;-1362             genCode2(Code1, R1No);
  8396                                  
  8397 00002C2B A0[3400]                 mov al, byte [R1No]
  8398 00002C2E B400                     mov ah, 0
  8399 00002C30 50                       push ax
  8400 00002C31 A0[3000]                 mov al, byte [Code1]
  8401 00002C34 B400                     mov ah, 0
  8402 00002C36 50                       push ax
  8403 00002C37 E893F7                   call genCode2
  8404 00002C3A 83C404                   add  sp, 4
  8405                                  
  8406                                  ;-1363             return;
  8407                                  
  8408 00002C3D E98002                   jmp .retnprocess
  8409                                  
  8410                                  ;-1364         }
  8411                                  
  8412                                  
  8413                                  ;-1365         if (Op == MEM) {
  8414                                  
  8415                                  .process337:
  8416 00002C40 A0[2D00]                 mov al, [Op]
  8417 00002C43 3C04                     cmp al, 4
  8418 00002C45 0F851B00                 jne .process338
  8419                                  
  8420                                  ;-1366             genCode8(Code2);
  8421                                  
  8422 00002C49 A0[3100]                 mov al, byte [Code2]
  8423 00002C4C B400                     mov ah, 0
  8424 00002C4E 50                       push ax
  8425 00002C4F E81BF7                   call genCode8
  8426 00002C52 83C402                   add  sp, 2
  8427                                  
  8428                                  ;-1367             writeEA(Code3);//////////////////Code3
  8429                                  
  8430 00002C55 A0[3200]                 mov al, byte [Code3]
  8431 00002C58 B400                     mov ah, 0
  8432 00002C5A 50                       push ax
  8433 00002C5B E8F1F7                   call writeEA
  8434 00002C5E 83C402                   add  sp, 2
  8435                                  
  8436                                  ;-1368             return;
  8437                                  
  8438 00002C61 E95C02                   jmp .retnprocess
  8439                                  
  8440                                  ;-1369         }
  8441                                  
  8442                                  
  8443                                  ;-1370         syntaxerror();
  8444                                  
  8445                                  .process338:
  8446 00002C64 E811E1                   call syntaxerror
  8447                                  
  8448                                  ;-1371         return;
  8449                                  
  8450 00002C67 E95602                   jmp .retnprocess
  8451                                  
  8452                                  ;-1372     }
  8453                                  
  8454                                  
  8455                                  ;-1373 
  8456                                  
  8457                                  
  8458                                  ;-1374     if (CodeType == 11) {//shift, rotate
  8459                                  
  8460                                  .process324:
  8461 00002C6A A0[2F00]                 mov al, [CodeType]
  8462 00002C6D 3C0B                     cmp al, 11
  8463 00002C6F 0F859200                 jne .process339
  8464                                  
  8465                                  ;-1375         check2Ops();
  8466                                  
  8467 00002C73 E8C2E6                   call check2Ops
  8468                                  
  8469                                  ;-1376         if (Op2 == IMM) {
  8470                                  
  8471 00002C76 A0[2E00]                 mov al, [Op2]
  8472 00002C79 3C01                     cmp al, 1
  8473 00002C7B 0F854400                 jne .process340
  8474                                  
  8475                                  ;-1377             if (imme == 1) {
  8476                                  
  8477 00002C7F A1[3F00]                 mov ax, [imme]
  8478 00002C82 83F801                   cmp ax, 1
  8479 00002C85 0F851800                 jne .process341
  8480                                  
  8481                                  ;-1378                 genCodeW(0xD0);
  8482                                  
  8483 00002C89 68D000                   push 208
  8484 00002C8C E859F7                   call genCodeW
  8485 00002C8F 83C402                   add  sp, 2
  8486                                  
  8487                                  ;-1379                 writeEA(Code1);
  8488                                  
  8489 00002C92 A0[3000]                 mov al, byte [Code1]
  8490 00002C95 B400                     mov ah, 0
  8491 00002C97 50                       push ax
  8492 00002C98 E8B4F7                   call writeEA
  8493 00002C9B 83C402                   add  sp, 2
  8494                                  
  8495                                  ;-1380                 return;
  8496                                  
  8497 00002C9E E91F02                   jmp .retnprocess
  8498                                  
  8499                                  ;-1381             }
  8500                                  
  8501                                  
  8502                                  ;-1382             genCodeW(0xC0);//80186
  8503                                  
  8504                                  .process341:
  8505 00002CA1 68C000                   push 192
  8506 00002CA4 E841F7                   call genCodeW
  8507 00002CA7 83C402                   add  sp, 2
  8508                                  
  8509                                  ;-1383             writeEA(Code1);
  8510                                  
  8511 00002CAA A0[3000]                 mov al, byte [Code1]
  8512 00002CAD B400                     mov ah, 0
  8513 00002CAF 50                       push ax
  8514 00002CB0 E89CF7                   call writeEA
  8515 00002CB3 83C402                   add  sp, 2
  8516                                  
  8517                                  ;-1384             genCode8(imme);
  8518                                  
  8519 00002CB6 FF36[3F00]               push word [imme]
  8520 00002CBA E8B0F6                   call genCode8
  8521 00002CBD 83C402                   add  sp, 2
  8522                                  
  8523                                  ;-1385             return;
  8524                                  
  8525 00002CC0 E9FD01                   jmp .retnprocess
  8526                                  
  8527                                  ;-1386         }
  8528                                  
  8529                                  
  8530                                  ;-1387         if (Op2 == REG) {
  8531                                  
  8532                                  .process340:
  8533 00002CC3 A0[2E00]                 mov al, [Op2]
  8534 00002CC6 3C02                     cmp al, 2
  8535 00002CC8 0F853900                 jne .process342
  8536                                  
  8537                                  ;-1388             if (R2Type == BYTE) {
  8538                                  
  8539 00002CCC A0[3500]                 mov al, [R2Type]
  8540 00002CCF 3C01                     cmp al, 1
  8541 00002CD1 0F853000                 jne .process343
  8542                                  
  8543                                  ;-1389                 if (R2No == 1) {//CL-REG
  8544                                  
  8545 00002CD5 A0[3300]                 mov al, [R2No]
  8546 00002CD8 3C01                     cmp al, 1
  8547 00002CDA 0F852700                 jne .process344
  8548                                  
  8549                                  ;-1390                     if (R1Type == WORD) wflag=1;//hack
  8550                                  
  8551 00002CDE A0[3600]                 mov al, [R1Type]
  8552 00002CE1 3C02                     cmp al, 2
  8553 00002CE3 0F850600                 jne .process345
  8554 00002CE7 B80100                   mov ax, 1
  8555 00002CEA A2[3800]                 mov byte [wflag], al
  8556                                  
  8557                                  ;-1391                     genCodeW(0xD2);
  8558                                  
  8559                                  .process345:
  8560 00002CED 68D200                   push 210
  8561 00002CF0 E8F5F6                   call genCodeW
  8562 00002CF3 83C402                   add  sp, 2
  8563                                  
  8564                                  ;-1392                     writeEA(Code1);
  8565                                  
  8566 00002CF6 A0[3000]                 mov al, byte [Code1]
  8567 00002CF9 B400                     mov ah, 0
  8568 00002CFB 50                       push ax
  8569 00002CFC E850F7                   call writeEA
  8570 00002CFF 83C402                   add  sp, 2
  8571                                  
  8572                                  ;-1393                     return;
  8573                                  
  8574 00002D02 E9BB01                   jmp .retnprocess
  8575                                  
  8576                                  ;-1394                 }
  8577                                  
  8578                                  
  8579                                  ;-1395             }
  8580                                  
  8581                                  .process344:
  8582                                  
  8583                                  ;-1396         }
  8584                                  
  8585                                  .process343:
  8586                                  
  8587                                  ;-1397     }
  8588                                  
  8589                                  .process342:
  8590                                  
  8591                                  ;-1398 
  8592                                  
  8593                                  
  8594                                  ;-1399     if (CodeType == 12) {//int
  8595                                  
  8596                                  .process339:
  8597 00002D05 A0[2F00]                 mov al, [CodeType]
  8598 00002D08 3C0C                     cmp al, 12
  8599 00002D0A 0F852200                 jne .process346
  8600                                  
  8601                                  ;-1400         if (TokeType == DIGIT) {
  8602                                  
  8603 00002D0E A0[2C00]                 mov al, [TokeType]
  8604 00002D11 3C01                     cmp al, 1
  8605 00002D13 0F851900                 jne .process347
  8606                                  
  8607                                  ;-1401             genCode8(Code1);
  8608                                  
  8609 00002D17 A0[3000]                 mov al, byte [Code1]
  8610 00002D1A B400                     mov ah, 0
  8611 00002D1C 50                       push ax
  8612 00002D1D E84DF6                   call genCode8
  8613 00002D20 83C402                   add  sp, 2
  8614                                  
  8615                                  ;-1402             genCode8(SymbolInt);
  8616                                  
  8617 00002D23 FF36[0E00]               push word [SymbolInt]
  8618 00002D27 E843F6                   call genCode8
  8619 00002D2A 83C402                   add  sp, 2
  8620                                  
  8621                                  ;-1403             return;
  8622                                  
  8623 00002D2D E99001                   jmp .retnprocess
  8624                                  
  8625                                  ;-1404         }
  8626                                  
  8627                                  
  8628                                  ;-1405     }
  8629                                  
  8630                                  .process347:
  8631                                  
  8632                                  ;-1406 
  8633                                  
  8634                                  
  8635                                  ;-1407     if (CodeType == 30) {//enter i18,i8
  8636                                  
  8637                                  .process346:
  8638 00002D30 A0[2F00]                 mov al, [CodeType]
  8639 00002D33 3C1E                     cmp al, 30
  8640 00002D35 0F855200                 jne .process348
  8641                                  
  8642                                  ;-1408         genCode8(0xC8);
  8643                                  
  8644 00002D39 68C800                   push 200
  8645 00002D3C E82EF6                   call genCode8
  8646 00002D3F 83C402                   add  sp, 2
  8647                                  
  8648                                  ;-1409         Op=getOp1();
  8649                                  
  8650 00002D42 E812E7                   call getOp1
  8651 00002D45 A2[2D00]                 mov byte [Op], al
  8652                                  
  8653                                  ;-1410         if (Op == IMM) genCode16(SymbolInt);
  8654                                  
  8655 00002D48 A0[2D00]                 mov al, [Op]
  8656 00002D4B 3C01                     cmp al, 1
  8657 00002D4D 0F850D00                 jne .process349
  8658 00002D51 FF36[0E00]               push word [SymbolInt]
  8659 00002D55 E8ACF6                   call genCode16
  8660 00002D58 83C402                   add  sp, 2
  8661                                  
  8662                                  ;-1411         else numbererror();
  8663                                  
  8664 00002D5B E90300                   jmp .process350
  8665                                  .process349:
  8666 00002D5E E884DF                   call numbererror
  8667                                  
  8668                                  ;-1412         need(',');
  8669                                  
  8670                                  .process350:
  8671 00002D61 6A2C                     push 44
  8672 00002D63 E83DEF                   call need
  8673 00002D66 83C402                   add  sp, 2
  8674                                  
  8675                                  ;-1413         Op=getOp1();
  8676                                  
  8677 00002D69 E8EBE6                   call getOp1
  8678 00002D6C A2[2D00]                 mov byte [Op], al
  8679                                  
  8680                                  ;-1414         if (Op == IMM) genCode8 (SymbolInt);
  8681                                  
  8682 00002D6F A0[2D00]                 mov al, [Op]
  8683 00002D72 3C01                     cmp al, 1
  8684 00002D74 0F850D00                 jne .process351
  8685 00002D78 FF36[0E00]               push word [SymbolInt]
  8686 00002D7C E8EEF5                   call genCode8
  8687 00002D7F 83C402                   add  sp, 2
  8688                                  
  8689                                  ;-1415         else numbererror();
  8690                                  
  8691 00002D82 E90300                   jmp .process352
  8692                                  .process351:
  8693 00002D85 E85DDF                   call numbererror
  8694                                  
  8695                                  ;-1416         return;
  8696                                  
  8697                                  .process352:
  8698 00002D88 E93501                   jmp .retnprocess
  8699                                  
  8700                                  ;-1417     }
  8701                                  
  8702                                  
  8703                                  ;-1418 
  8704                                  
  8705                                  
  8706                                  ;-1419     if (CodeType==101) {//ORG nn
  8707                                  
  8708                                  .process348:
  8709 00002D8B A0[2F00]                 mov al, [CodeType]
  8710 00002D8E 3C65                     cmp al, 101
  8711 00002D90 0F851500                 jne .process353
  8712                                  
  8713                                  ;-1420         if (TokeType != DIGIT) numbererror();
  8714                                  
  8715 00002D94 A0[2C00]                 mov al, [TokeType]
  8716 00002D97 3C01                     cmp al, 1
  8717 00002D99 0F840300                 je  .process354
  8718 00002D9D E845DF                   call numbererror
  8719                                  
  8720                                  ;-1421         Origin=SymbolInt;
  8721                                  
  8722                                  .process354:
  8723 00002DA0 A1[0E00]                 mov ax, [SymbolInt]
  8724 00002DA3 A3[2500]                 mov word [Origin], ax
  8725                                  
  8726                                  ;-1422         return;
  8727                                  
  8728 00002DA6 E91701                   jmp .retnprocess
  8729                                  
  8730                                  ;-1423     }
  8731                                  
  8732                                  
  8733                                  ;-1424 
  8734                                  
  8735                                  
  8736                                  ;-1425     if (CodeType == 102) {//section, segment
  8737                                  
  8738                                  .process353:
  8739 00002DA9 A0[2F00]                 mov al, [CodeType]
  8740 00002DAC 3C66                     cmp al, 102
  8741 00002DAE 0F850900                 jne .process355
  8742                                  
  8743                                  ;-1426         //getTokeType();//ignore .bss .text .data
  8744                                  
  8745                                  
  8746                                  ;-1427         AbsoluteLab=0;//nasm resets erevy time
  8747                                  
  8748 00002DB2 B80000                   mov ax, 0
  8749 00002DB5 A3[2700]                 mov word [AbsoluteLab], ax
  8750                                  
  8751                                  ;-1428         return;
  8752                                  
  8753 00002DB8 E90501                   jmp .retnprocess
  8754                                  
  8755                                  ;-1429     }
  8756                                  
  8757                                  
  8758                                  ;-1430 
  8759                                  
  8760                                  
  8761                                  ;-1431     if (CodeType == 110) {//absolute
  8762                                  
  8763                                  .process355:
  8764 00002DBB A0[2F00]                 mov al, [CodeType]
  8765 00002DBE 3C6E                     cmp al, 110
  8766 00002DC0 0F851500                 jne .process356
  8767                                  
  8768                                  ;-1432         if (TokeType != DIGIT) numbererror();
  8769                                  
  8770 00002DC4 A0[2C00]                 mov al, [TokeType]
  8771 00002DC7 3C01                     cmp al, 1
  8772 00002DC9 0F840300                 je  .process357
  8773 00002DCD E815DF                   call numbererror
  8774                                  
  8775                                  ;-1433         AbsoluteLab=SymbolInt;
  8776                                  
  8777                                  .process357:
  8778 00002DD0 A1[0E00]                 mov ax, [SymbolInt]
  8779 00002DD3 A3[2700]                 mov word [AbsoluteLab], ax
  8780                                  
  8781                                  ;-1434         return;
  8782                                  
  8783 00002DD6 E9E700                   jmp .retnprocess
  8784                                  
  8785                                  ;-1435     }
  8786                                  
  8787                                  
  8788                                  ;-1436     if (CodeType == 111) {//name: PROC
  8789                                  
  8790                                  .process356:
  8791 00002DD9 A0[2F00]                 mov al, [CodeType]
  8792 00002DDC 3C6F                     cmp al, 111
  8793 00002DDE 0F854A00                 jne .process358
  8794                                  
  8795                                  ;-1437         if (isInProc == 0)  {
  8796                                  
  8797 00002DE2 A0[0D00]                 mov al, [isInProc]
  8798 00002DE5 3C00                     cmp al, 0
  8799 00002DE7 0F853500                 jne .process359
  8800                                  
  8801                                  ;-1438             prs("\n;entering: ");
  8802                                  
  8803 00002DEB 68[D52E]                 push process_1
  8804 00002DEE E836DC                   call prs
  8805 00002DF1 83C402                   add  sp, 2
  8806                                  
  8807                                  ;-1439             prs(ProcName);
  8808                                  
  8809 00002DF4 8D066E75                 lea  ax, [ProcName]
  8810 00002DF8 50                       push ax
  8811 00002DF9 E82BDC                   call prs
  8812 00002DFC 83C402                   add  sp, 2
  8813                                  
  8814                                  ;-1440             isInProc=1;
  8815                                  
  8816 00002DFF B80100                   mov ax, 1
  8817 00002E02 A2[0D00]                 mov byte [isInProc], al
  8818                                  
  8819                                  ;-1441             tmpLabelNamePtr = LabelNamePtr;
  8820                                  
  8821 00002E05 A1[4600]                 mov ax, [LabelNamePtr]
  8822 00002E08 A3[4800]                 mov word [tmpLabelNamePtr], ax
  8823                                  
  8824                                  ;-1442             tmpLabelMaxIx   = LabelMaxIx;
  8825                                  
  8826 00002E0B A1[4A00]                 mov ax, [LabelMaxIx]
  8827 00002E0E A3[4C00]                 mov word [tmpLabelMaxIx], ax
  8828                                  
  8829                                  ;-1443             tmpJmpNamePtr   = JmpNamePtr;
  8830                                  
  8831 00002E11 A1[5000]                 mov ax, [JmpNamePtr]
  8832 00002E14 A3[5200]                 mov word [tmpJmpNamePtr], ax
  8833                                  
  8834                                  ;-1444             tmpJmpMaxIx     = JmpMaxIx;
  8835                                  
  8836 00002E17 A1[5400]                 mov ax, [JmpMaxIx]
  8837 00002E1A A3[5600]                 mov word [tmpJmpMaxIx], ax
  8838                                  
  8839                                  ;-1445         } else error1("already in PROC");
  8840                                  
  8841 00002E1D E90900                   jmp .process360
  8842                                  .process359:
  8843 00002E20 68[E32E]                 push process_2
  8844 00002E23 E853DD                   call error1
  8845 00002E26 83C402                   add  sp, 2
  8846                                  
  8847                                  ;-1446         return;
  8848                                  
  8849                                  .process360:
  8850 00002E29 E99400                   jmp .retnprocess
  8851                                  
  8852                                  ;-1447     }
  8853                                  
  8854                                  
  8855                                  ;-1448     if (CodeType == 112) {//ENDP 
  8856                                  
  8857                                  .process358:
  8858 00002E2C A0[2F00]                 mov al, [CodeType]
  8859 00002E2F 3C70                     cmp al, 112
  8860 00002E31 0F858200                 jne .process361
  8861                                  
  8862                                  ;-1449         if (isInProc == 0) error1("not in PROC");
  8863                                  
  8864 00002E35 A0[0D00]                 mov al, [isInProc]
  8865 00002E38 3C00                     cmp al, 0
  8866 00002E3A 0F850900                 jne .process362
  8867 00002E3E 68[F32E]                 push process_3
  8868 00002E41 E835DD                   call error1
  8869 00002E44 83C402                   add  sp, 2
  8870                                  
  8871                                  ;-1450         prs("\n;leaving: ");
  8872                                  
  8873                                  .process362:
  8874 00002E47 68[FF2E]                 push process_4
  8875 00002E4A E8DADB                   call prs
  8876 00002E4D 83C402                   add  sp, 2
  8877                                  
  8878                                  ;-1451         prs(ProcName);
  8879                                  
  8880 00002E50 8D066E75                 lea  ax, [ProcName]
  8881 00002E54 50                       push ax
  8882 00002E55 E8CFDB                   call prs
  8883 00002E58 83C402                   add  sp, 2
  8884                                  
  8885                                  ;-1452         prs(". loc labels:");
  8886                                  
  8887 00002E5B 68[0C2F]                 push process_5
  8888 00002E5E E8C6DB                   call prs
  8889 00002E61 83C402                   add  sp, 2
  8890                                  
  8891                                  ;-1453         i = LabelMaxIx - tmpLabelMaxIx;
  8892                                  
  8893 00002E64 A1[4A00]                 mov ax, [LabelMaxIx]
  8894 00002E67 2B06[4C00]               sub ax, [tmpLabelMaxIx]
  8895 00002E6B 8946FC                   mov [bp-4], ax
  8896                                  
  8897                                  ;-1454         printIntU(i);
  8898                                  
  8899 00002E6E FF76FC                   push word [bp-4]
  8900 00002E71 E8C3DC                   call printIntU
  8901 00002E74 83C402                   add  sp, 2
  8902                                  
  8903                                  ;-1455         prs(",loc jmp forward:");
  8904                                  
  8905 00002E77 68[1A2F]                 push process_6
  8906 00002E7A E8AADB                   call prs
  8907 00002E7D 83C402                   add  sp, 2
  8908                                  
  8909                                  ;-1456         i = JmpMaxIx - tmpJmpMaxIx;
  8910                                  
  8911 00002E80 A1[5400]                 mov ax, [JmpMaxIx]
  8912 00002E83 2B06[5600]               sub ax, [tmpJmpMaxIx]
  8913 00002E87 8946FC                   mov [bp-4], ax
  8914                                  
  8915                                  ;-1457         printIntU(i);        
  8916                                  
  8917 00002E8A FF76FC                   push word [bp-4]
  8918 00002E8D E8A7DC                   call printIntU
  8919 00002E90 83C402                   add  sp, 2
  8920                                  
  8921                                  ;-1458         fixJmp();
  8922                                  
  8923 00002E93 E8B8F0                   call fixJmp
  8924                                  
  8925                                  ;-1459         isInProc=0;
  8926                                  
  8927 00002E96 B80000                   mov ax, 0
  8928 00002E99 A2[0D00]                 mov byte [isInProc], al
  8929                                  
  8930                                  ;-1460         LabelNamePtr = tmpLabelNamePtr;//delete local Labels
  8931                                  
  8932 00002E9C A1[4800]                 mov ax, [tmpLabelNamePtr]
  8933 00002E9F A3[4600]                 mov word [LabelNamePtr], ax
  8934                                  
  8935                                  ;-1461         LabelMaxIx   = tmpLabelMaxIx;                       
  8936                                  
  8937 00002EA2 A1[4C00]                 mov ax, [tmpLabelMaxIx]
  8938 00002EA5 A3[4A00]                 mov word [LabelMaxIx], ax
  8939                                  
  8940                                  ;-1462         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp
  8941                                  
  8942 00002EA8 A1[5200]                 mov ax, [tmpJmpNamePtr]
  8943 00002EAB A3[5000]                 mov word [JmpNamePtr], ax
  8944                                  
  8945                                  ;-1463         JmpMaxIx     = tmpJmpMaxIx;
  8946                                  
  8947 00002EAE A1[5600]                 mov ax, [tmpJmpMaxIx]
  8948 00002EB1 A3[5400]                 mov word [JmpMaxIx], ax
  8949                                  
  8950                                  ;-1464         return;
  8951                                  
  8952 00002EB4 E90900                   jmp .retnprocess
  8953                                  
  8954                                  ;-1465     }
  8955                                  
  8956                                  
  8957                                  ;-1466     error1("Command not implemented or syntax error");
  8958                                  
  8959                                  .process361:
  8960 00002EB7 68[2C2F]                 push process_7
  8961 00002EBA E8BCDC                   call error1
  8962 00002EBD 83C402                   add  sp, 2
  8963                                  
  8964                                  ;-1467 }
  8965                                  
  8966                                  
  8967                                  ;-1468 
  8968                                  
  8969                                  
  8970                                  ;-1469 int main() {
  8971                                  
  8972 00002EC0 C9                       .retnprocess: LEAVE
  8973 00002EC1 C3                       ret
  8974 00002EC2 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8975 00002ECB 7420616C6C6F776564-
  8976 00002ED4 00                 
  8977 00002ED5 5C6E3B656E74657269-     process_1 db "\n;entering: ",0
  8978 00002EDE 6E673A2000         
  8979 00002EE3 616C72656164792069-     process_2 db "already in PROC",0
  8980 00002EEC 6E2050524F4300     
  8981 00002EF3 6E6F7420696E205052-     process_3 db "not in PROC",0
  8982 00002EFC 4F4300             
  8983 00002EFF 5C6E3B6C656176696E-     process_4 db "\n;leaving: ",0
  8984 00002F08 673A2000           
  8985 00002F0C 2E206C6F63206C6162-     process_5 db ". loc labels:",0
  8986 00002F15 656C733A00         
  8987 00002F1A 2C6C6F63206A6D7020-     process_6 db ",loc jmp forward:",0
  8988 00002F23 666F72776172643A00 
  8989 00002F2C 436F6D6D616E64206E-     process_7 db "Command not implemented or syntax error",0
  8990 00002F35 6F7420696D706C656D-
  8991 00002F3E 656E746564206F7220-
  8992 00002F47 73796E746178206572-
  8993 00002F50 726F7200           
  8994                                  ENDP
  8995                                  
  8996                                  main: PROC
  8997                                  
  8998                                  ;-1470     getarg();
  8999                                  
  9000 00002F54 E8B4ED                   call getarg
  9001                                  
  9002                                  ;-1471     parse();
  9003                                  
  9004 00002F57 E8F5E7                   call parse
  9005                                  
  9006                                  ;-1472     fixJmpMain();
  9007                                  
  9008 00002F5A E84FF1                   call fixJmpMain
  9009                                  
  9010                                  ;-1473     epilog();
  9011                                  
  9012 00002F5D E8C6F2                   call epilog
  9013                                  
  9014                                  ;-1474     end1();
  9015                                  
  9016 00002F60 E8AFF3                   call end1
  9017                                  
  9018                                  ;-1475 }
  9019                                  
  9020 00002F63 C3                       ret
  9021                                  ENDP
  9022                                   
  9023                                  ; missing functions: 
  9024                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  9025 00002F64 E80000                  LastFunctionByt:db 0E8h, 0, 0
  9026 00002F67 58                      pop ax
  9027 00002F68 C3                      ret
  9028                                   
  9029                                  ;   # type sign width  adr used name   list of global variables
  9030                                  
  9031                                  ;    1 arr sign byte     1    2 Version1[9]
  9032                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  9033                                  ;    3 arr sign byte     4   16 Symbol[31]
  9034                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  9035                                  ;    5 arr sign byte     6    3 ProcName[31]
  9036                                  ;    6 var sign byte     7    6 isInProc
  9037                                  ;    7 var unsg word     8   24 SymbolInt
  9038                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  9039                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  9040                                  ;   10 arr sign byte    11    4 InputBuf[255]
  9041                                  ;   11 ptr unsg byte    12   24 InputPtr
  9042                                  ;   12 arr sign byte    13    5 namein[67]
  9043                                  ;   13 arr sign byte    14    6 namelst[67]
  9044                                  ;   14 arr sign byte    15    6 namebin[67]
  9045                                  ;   15 var sign word    16    4 asm_fd
  9046                                  ;   16 var sign word    17    3 lst_fd
  9047                                  ;   17 var sign word    18    3 bin_fd
  9048                                  ;   18 var sign word    19    6 DOS_ERR
  9049                                  ;   19 var sign word    20    5 ErrorCount
  9050                                  ;   20 var sign word    21    4 DOS_NoBytes
  9051                                  ;   21 var sign byte    22    5 DOS_ByteRead
  9052                                  ;   22 var unsg word    24    8 PC
  9053                                  ;   23 var unsg word    25    6 Origin
  9054                                  ;   24 var unsg word    26    6 AbsoluteLab
  9055                                  ;   25 var unsg word    27    2 PCStart
  9056                                  ;   26 var sign byte    28    3 isLabel
  9057                                  ;   27 def unsg byte    29    - DIGIT=1
  9058                                  ;   28 def unsg byte    30    - LETTERE=2
  9059                                  ;   29 def unsg byte    31    - ALNUME=3
  9060                                  ;   30 def unsg byte    32    - NOALNUME=4
  9061                                  ;   31 var sign byte    33   27 TokeType
  9062                                  ;   32 def unsg byte    34    - BYTE=1
  9063                                  ;   33 def unsg byte    35    - WORD=2
  9064                                  ;   34 def unsg byte    36    - DWORD=3
  9065                                  ;   35 def unsg byte    37    - SEGREG=4
  9066                                  ;   36 def unsg byte    38    - IMM=1
  9067                                  ;   37 def unsg byte    39    - REG=2
  9068                                  ;   38 def unsg byte    40    - ADR=3
  9069                                  ;   39 def unsg byte    41    - MEM=4
  9070                                  ;   40 var sign byte    42   29 Op
  9071                                  ;   41 var sign byte    43   31 Op2
  9072                                  ;   42 var sign byte    44   29 CodeType
  9073                                  ;   43 var sign byte    45   23 Code1
  9074                                  ;   44 var sign byte    46    7 Code2
  9075                                  ;   45 var sign byte    47    3 Code3
  9076                                  ;   46 var sign byte    48   19 R2No
  9077                                  ;   47 var sign byte    49   16 R1No
  9078                                  ;   48 var sign byte    50   18 R2Type
  9079                                  ;   49 var sign byte    51   15 R1Type
  9080                                  ;   50 var sign byte    52   14 OpSize
  9081                                  ;   51 var sign byte    53    9 wflag
  9082                                  ;   52 var sign byte    54    3 dflag
  9083                                  ;   53 var sign byte    55    8 sflag
  9084                                  ;   54 var sign byte    56   15 rm
  9085                                  ;   55 var sign byte    57    5 isDirect
  9086                                  ;   56 var sign word    58   69 disp
  9087                                  ;   57 var unsg word    59   13 imme
  9088                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  9089                                  ;   59 arr sign byte    62    2 OpPos[5]
  9090                                  ;   60 var sign word    63    6 OpPrintIndex
  9091                                  ;   61 ptr sign byte    64   19 OpCodePtr
  9092                                  ;   62 var sign byte    65    5 PrintRA
  9093                                  ;   63 def unsg byte    67    - LABELNAMESMAX=5969
  9094                                  ;   64 arr sign byte    68    3 LabelNames[6000]
  9095                                  ;   65 ptr sign byte    69    7 LabelNamePtr
  9096                                  ;   66 ptr sign byte    70    2 tmpLabelNamePtr
  9097                                  ;   67 def unsg byte    72    - LABELADRMAX=600
  9098                                  ;   68 arr unsg word    73    8 LabelAddr[600]
  9099                                  ;   69 var sign word    74   10 LabelMaxIx
  9100                                  ;   70 var sign word    75    3 tmpLabelMaxIx
  9101                                  ;   71 var sign word    76   11 LabelIx
  9102                                  ;   72 def unsg byte    78    - JMPNAMESMAX=3969
  9103                                  ;   73 arr sign byte    79    3 JmpNames[4000]
  9104                                  ;   74 ptr sign byte    80    7 JmpNamePtr
  9105                                  ;   75 ptr sign byte    81    2 tmpJmpNamePtr
  9106                                  ;   76 def unsg byte    83    - JMPMAX=200
  9107                                  ;   77 arr unsg word    84    2 JmpAddr[200]
  9108                                  ;   78 var sign word    85   11 JmpMaxIx
  9109                                  ;   79 var sign word    86    3 tmpJmpMaxIx
  9110                                  ;   80 def unsg byte    88    - FILEBINMAX=17000
  9111                                  ;   81 arr sign byte    89    8 FileBin[17000]
  9112                                  ;   82 var unsg word    90    6 BinLen
  9113                                  ;   83 ptr sign byte    92    1 arglen
  9114                                  ;   84 ptr sign byte    93    4 argv
  9115                                  ;   85 var sign byte   394    1 I_START
  9116                                  ;   86 arr sign byte   397 NULL I_PUSHA[8125]
  9117                                  ;   87 arr sign byte   398 NULL I_NOP[24260]
  9118                                  ;   88 arr sign byte   399 NULL I_CWDE[9734]
  9119                                  ;   89 arr sign byte   400 NULL I_CDQ[1931]
  9120                                  ;   90 arr sign byte   401 NULL I_PUSHF[35622]
  9121                                  ;   91 arr sign byte   402 NULL I_SAHF[599]
  9122                                  ;   92 arr sign byte   403 NULL I_MOVSB[53495]
  9123                                  ;   93 arr sign byte   404 NULL I_CMPSB[54007]
  9124                                  ;   94 arr sign byte   405 NULL I_STOSB[37]
  9125                                  ;   95 arr sign byte   406 NULL I_LODSB[33600]
  9126                                  ;   96 arr sign byte   407 NULL I_SCASB[8418]
  9127                                  ;   97 arr sign byte   408 NULL I_LEAVE[53259]
  9128                                  ;   98 arr sign byte   409 NULL I_INTO[12917]
  9129                                  ;   99 arr sign byte   410 NULL I_XLAT[35622]
  9130                                  ;  100 arr sign byte   411 NULL I_REPNE[2119]
  9131                                  ;  101 arr sign byte   412 NULL I_REPE[18057]
  9132                                  ;  102 arr sign byte   413 NULL I_HLT[9982]
  9133                                  ;  103 arr sign byte   414 NULL I_STC[18315]
  9134                                  ;  104 arr sign byte   415 NULL I_STI[9734]
  9135                                  ;  105 arr sign byte   416 NULL I_STD[32643]
  9136                                  ;  106 arr sign byte   418 NULL I_INC[10]
  9137                                  ;  107 arr sign byte   419 NULL I_DEC[1397]
  9138                                  ;  108 arr sign byte   420 NULL I_NOT[18119]
  9139                                  ;  109 arr sign byte   421 NULL I_NEG[65534]
  9140                                  ;  110 arr sign byte   422 NULL I_MUL[33791]
  9141                                  ;  111 arr sign byte   423 NULL I_IMUL[65150]
  9142                                  ;  112 arr sign byte   424 NULL I_DIV[30207]
  9143                                  ;  113 arr sign byte   425 NULL I_IDIV[15642]
  9144                                  ;  114 arr sign byte   427 NULL I_LES[65535]
  9145                                  ;  115 arr sign byte   428 NULL I_LDS[5493]
  9146                                  ;  116 arr sign byte   429 NULL I_LEA[33574]
  9147                                  ;  117 arr sign byte   430 NULL I_LSS[1151]
  9148                                  ;  118 arr sign byte   431 NULL I_LFS[29696]
  9149                                  ;  119 arr sign byte   432 NULL I_LGS[35593]
  9150                                  ;  120 arr sign byte   434 NULL I_ADD[2630]
  9151                                  ;  121 arr sign byte   435 NULL I_OR[14630]
  9152                                  ;  122 arr sign byte   436 NULL I_ADC[1095]
  9153                                  ;  123 arr sign byte   437 NULL I_SBB[26997]
  9154                                  ;  124 arr sign byte   438 NULL I_AND[49203]
  9155                                  ;  125 arr sign byte   439 NULL I_SUB[52169]
  9156                                  ;  126 arr sign byte   440 NULL I_XOR[33680]
  9157                                  ;  127 arr sign byte   441 NULL I_CMP[65150]
  9158                                  ;  128 arr sign byte   442 NULL I_TEST[29729]
  9159                                  ;  129 arr sign byte   444 NULL I_MOV[33618]
  9160                                  ;  130 arr sign byte   445 NULL I_MOVSX[65150]
  9161                                  ;  131 arr sign byte   446 NULL I_MOVZX[29731]
  9162                                  ;  132 arr sign byte   448 NULL I_JO[33612]
  9163                                  ;  133 arr sign byte   449 NULL I_JNO[65150]
  9164                                  ;  134 arr sign byte   450 NULL I_JB[29732]
  9165                                  ;  135 arr sign byte   451 NULL I_JNB[33606]
  9166                                  ;  136 arr sign byte   452 NULL I_JAE[65150]
  9167                                  ;  137 arr sign byte   453 NULL I_JE[29734]
  9168                                  ;  138 arr sign byte   454 NULL I_JNE[33600]
  9169                                  ;  139 arr sign byte   455 NULL I_JBE[65150]
  9170                                  ;  140 arr sign byte   456 NULL I_JA[29730]
  9171                                  ;  141 arr sign byte   457 NULL I_JS[33594]
  9172                                  ;  142 arr sign byte   458 NULL I_JNS[65150]
  9173                                  ;  143 arr sign byte   459 NULL I_JP[29737]
  9174                                  ;  144 arr sign byte   460 NULL I_JNP[33588]
  9175                                  ;  145 arr sign byte   461 NULL I_JL[65150]
  9176                                  ;  146 arr sign byte   462 NULL I_JNL[29736]
  9177                                  ;  147 arr sign byte   463 NULL I_JLE[33582]
  9178                                  ;  148 arr sign byte   464 NULL I_JG[65150]
  9179                                  ;  149 arr sign byte   466 NULL I_JMP[29733]
  9180                                  ;  150 arr sign byte   467 NULL I_CALL[15656]
  9181                                  ;  151 arr sign byte   469 NULL I_RET[33]
  9182                                  ;  152 arr sign byte   470 NULL I_RETF[9076]
  9183                                  ;  153 arr sign byte   472 NULL I_PUSH[9021]
  9184                                  ;  154 arr sign byte   473 NULL I_POP[29696]
  9185                                  ;  155 arr sign byte   475 NULL I_ROL[15646]
  9186                                  ;  156 arr sign byte   476 NULL I_RCL[36]
  9187                                  ;  157 arr sign byte   477 NULL I_SHL[6516]
  9188                                  ;  158 arr sign byte   478 NULL I_SHR[9789]
  9189                                  ;  159 arr sign byte   480 NULL I_INT[29696]
  9190                                  ;  160 arr sign byte   482 NULL I_IN[15636]
  9191                                  ;  161 arr sign byte   483 NULL I_INSB[34]
  9192                                  ;  162 arr sign byte   484 NULL I_INSW[3956]
  9193                                  ;  163 arr sign byte   485 NULL I_INSD[10557]
  9194                                  ;  164 arr sign byte   486 NULL I_OUT[29696]
  9195                                  ;  165 arr sign byte   487 NULL I_OUTSB[15626]
  9196                                  ;  166 arr sign byte   488 NULL I_OUTSW[40]
  9197                                  ;  167 arr sign byte   489 NULL I_OUTSD[1396]
  9198                                  ;  168 arr sign byte   491 NULL I_XCHG[9533]
  9199                                  ;  169 arr sign byte   493 NULL I_LOOPNZ[29952]
  9200                                  ;  170 arr sign byte   494 NULL I_LOOPNE[33542]
  9201                                  ;  171 arr sign byte   495 NULL I_LOOPZ[2686]
  9202                                  ;  172 arr sign byte   496 NULL I_LOOPE[60176]
  9203                                  ;  173 arr sign byte   497 NULL I_LOOP[33540]
  9204                                  ;  174 arr sign byte   498 NULL I_JCXZ[2686]
  9205                                  ;  175 arr sign byte   499 NULL I_JECXZ[29984]
  9206                                  ;  176 arr sign byte   501 NULL I_ENTER[47255]
  9207                                  ;  177 arr sign byte   503 NULL I_ORG[1]
  9208                                  ;  178 arr sign byte   505 NULL I_SECTION[52169]
  9209                                  ;  179 arr sign byte   506 NULL I_SEGMENT[21904]
  9210                                  ;  180 arr sign byte   507 NULL I_ABSOLUTE[60555]
  9211                                  ;  181 arr sign byte   508 NULL I_PROC[5816]
  9212                                  ;  182 arr sign byte   509 NULL I_ENDP[39424]
  9213                                  ;  183 arr sign byte   510 NULL I_DB[674]
  9214                                  ;  184 arr sign byte   511 NULL I_DW[8125]
  9215                                  ;  185 arr sign byte   512 NULL I_DD[51030]
  9216                                  ;  186 arr sign byte   513 NULL I_RESB[65094]
  9217                                  ;  187 arr sign byte   514 NULL I_RESW[0]
  9218                                  ;  188 arr sign byte   515 NULL I_RESD[1678]
  9219                                  ;  189 var sign byte   516 NULL I_END
  9220                                  
  9221                                  
  9222                                  ;   # Calls Line Width  Name   list of functions
  9223                                  
  9224                                  ;    0    4   97   writetty
  9225                                  ;    1    1   98   putch
  9226                                  ;    2    8   99   cputs
  9227                                  ;    3    6  101   DosInt
  9228                                  ;    4    1  106   openR
  9229                                  ;    5    2  107   creatR
  9230                                  ;    6    3  108   fcloseR
  9231                                  ;    7    5  109   exitR
  9232                                  ;    8    2  110   readRL
  9233                                  ;    9    2  111   fputcR
  9234                                  ;   10    1  114   getLine
  9235                                  ;   11    1  130   ifEOL
  9236                                  ;   12    3  139   skipBlank
  9237                                  ;   13    2  144   letterE
  9238                                  ;   14    1  154   alnumE
  9239                                  ;   15    3  159   digit
  9240                                  ;   16    4  164   strlen
  9241                                  ;   17   10  169   strcpy
  9242                                  ;   18   35  175   eqstr
  9243                                  ;   19    3  184   strcat1
  9244                                  ;   20    2  188   toupper
  9245                                  ;   21    1  195   getDigit
  9246                                  ;   22    1  207   getName
  9247                                  ;   23    1  226   testReg
  9248                                  ;   24    1  270   printLine
  9249                                  ;   25    7  292   prc
  9250                                  ;   26    1  302   prscomment
  9251                                  ;   27   48  310   prs
  9252                                  ;   28    3  332   printhex8a
  9253                                  ;   29    2  337   printhex4
  9254                                  ;   30    7  342   printhex16
  9255                                  ;   31    9  347   printIntU
  9256                                  ;   32   27  358   error1
  9257                                  ;   33   13  365   errorexit
  9258                                  ;   34    4  370   notfounderror
  9259                                  ;   35 NULL  376   allowederror
  9260                                  ;   36    3  377   addrerror
  9261                                  ;   37    1  378   immeerror
  9262                                  ;   38    2  379   implerror
  9263                                  ;   39    4  380   indexerror
  9264                                  ;   40    3  381   invaloperror
  9265                                  ;   41    6  382   numbererror
  9266                                  ;   42    1  383   regmemerror
  9267                                  ;   43    3  384   reg16error
  9268                                  ;   44    1  385   segregerror
  9269                                  ;   45    5  386   syntaxerror
  9270                                  ;   46 NULL  388   addrexit
  9271                                  ;   47    3  389   dataexit
  9272                                  ;   48 NULL  390   internexit
  9273                                  ;   49    2  518   lookCode
  9274                                  ;   50    2  535   ChangeDirection
  9275                                  ;   51    2  543   checkOpL
  9276                                  ;   52    4  552   check2Ops
  9277                                  ;   53    1  561   get2Ops
  9278                                  ;   54    3  567   getOpL
  9279                                  ;   55    2  575   getOpR
  9280                                  ;   56    4  588   getOp1
  9281                                  ;   57    1  605   getMEM
  9282                                  ;   58    1  631   getIndReg1
  9283                                  ;   59    1  639   getIndReg2
  9284                                  ;   60    2  649   setwflag
  9285                                  ;   61    2  660   setsflag
  9286                                  ;   62    2  670   checkConstSize
  9287                                  ;   63    1  678   parse
  9288                                  ;   64   16  714   getTokeType
  9289                                  ;   65    3  725   storeJmp
  9290                                  ;   66    2  736   storeLabel
  9291                                  ;   67    6  748   searchLabel
  9292                                  ;   68    1  761   getVariable
  9293                                  ;   69    1  814   getCodeSize
  9294                                  ;   70    9  822   isToken
  9295                                  ;   71    2  830   need
  9296                                  ;   72    1  839   skipRest
  9297                                  ;   73    1  846   getarg
  9298                                  ;   74    1  880   fixJmp
  9299                                  ;   75    1  914   fixJmpMain
  9300                                  ;   76    2  943   epilog
  9301                                  ;   77    2  991   end1
  9302                                  ;   78    1 1001   getCodes
  9303                                  ;   79   35 1006   genCode8
  9304                                  ;   80    1 1017   gen66h
  9305                                  ;   81    8 1019   genCode2
  9306                                  ;   82   13 1023   genCodeW
  9307                                  ;   83   19 1027   genCode16
  9308                                  ;   84    1 1031   genCode32
  9309                                  ;   85   13 1035   writeEA
  9310                                  ;   86    4 1077   genImmediate
  9311                                  ;   87    1 1084   process
  9312                                  ;   88 NULL 1469   main
  9313                                  ;   89 NULL 1475   LastFunctionByt
  9314                                  
  9315                                  ;    #  addr name   list of CALLs
  9316                                  
  9317                                  ;    0     0 writetty
  9318                                  ;    1     9 writetty
  9319                                  ;    2    18 putch
  9320                                  ;    3    24 DosInt
  9321                                  ;    4    31 DosInt
  9322                                  ;    5    38 DosInt
  9323                                  ;    6    45 DosInt
  9324                                  ;    7    52 DosInt
  9325                                  ;    8    59 DosInt
  9326                                  ;    9    66 readRL
  9327                                  ;   10    73 errorexit
  9328                                  ;   11    83 errorexit
  9329                                  ;   12    93 ifEOL
  9330                                  ;   13    99 readRL
  9331                                  ;   14   106 errorexit
  9332                                  ;   15   116 digit
  9333                                  ;   16   122 letterE
  9334                                  ;   17   130 strcpy
  9335                                  ;   18   137 digit
  9336                                  ;   19   143 alnumE
  9337                                  ;   20   150 errorexit
  9338                                  ;   21   160 strcpy
  9339                                  ;   22   167 toupper
  9340                                  ;   23   175 strlen
  9341                                  ;   24   182 strlen
  9342                                  ;   25   189 eqstr
  9343                                  ;   26   195 eqstr
  9344                                  ;   27   201 eqstr
  9345                                  ;   28   207 eqstr
  9346                                  ;   29   213 eqstr
  9347                                  ;   30   219 eqstr
  9348                                  ;   31   225 eqstr
  9349                                  ;   32   231 eqstr
  9350                                  ;   33   237 eqstr
  9351                                  ;   34   243 eqstr
  9352                                  ;   35   249 eqstr
  9353                                  ;   36   255 eqstr
  9354                                  ;   37   261 eqstr
  9355                                  ;   38   267 eqstr
  9356                                  ;   39   273 eqstr
  9357                                  ;   40   279 eqstr
  9358                                  ;   41   285 eqstr
  9359                                  ;   42   291 eqstr
  9360                                  ;   43   297 eqstr
  9361                                  ;   44   303 eqstr
  9362                                  ;   45   309 eqstr
  9363                                  ;   46   315 eqstr
  9364                                  ;   47   321 eqstr
  9365                                  ;   48   327 eqstr
  9366                                  ;   49   333 eqstr
  9367                                  ;   50   339 eqstr
  9368                                  ;   51   345 eqstr
  9369                                  ;   52   351 eqstr
  9370                                  ;   53   357 eqstr
  9371                                  ;   54   363 eqstr
  9372                                  ;   55   369 prs
  9373                                  ;   56   373 printhex16
  9374                                  ;   57   384 prs
  9375                                  ;   58   388 prc
  9376                                  ;   59   392 printhex8a
  9377                                  ;   60   403 prs
  9378                                  ;   61   407 prc
  9379                                  ;   62   411 prscomment
  9380                                  ;   63   422 writetty
  9381                                  ;   64   431 writetty
  9382                                  ;   65   440 fputcR
  9383                                  ;   66   447 prc
  9384                                  ;   67   451 prc
  9385                                  ;   68   455 printhex4
  9386                                  ;   69   465 printhex4
  9387                                  ;   70   475 prc
  9388                                  ;   71   479 printhex8a
  9389                                  ;   72   490 printhex8a
  9390                                  ;   73   501 printIntU
  9391                                  ;   74   511 prc
  9392                                  ;   75   515 prs
  9393                                  ;   76   519 prs
  9394                                  ;   77   523 prs
  9395                                  ;   78   527 prs
  9396                                  ;   79   531 error1
  9397                                  ;   80   538 epilog
  9398                                  ;   81   545 end1
  9399                                  ;   82   550 prs
  9400                                  ;   83   554 prs
  9401                                  ;   84   558 prs
  9402                                  ;   85   562 error1
  9403                                  ;   86   569 error1
  9404                                  ;   87   576 error1
  9405                                  ;   88   583 error1
  9406                                  ;   89   590 error1
  9407                                  ;   90   597 error1
  9408                                  ;   91   604 error1
  9409                                  ;   92   611 error1
  9410                                  ;   93   618 error1
  9411                                  ;   94   625 error1
  9412                                  ;   95   632 error1
  9413                                  ;   96   639 errorexit
  9414                                  ;   97   649 errorexit
  9415                                  ;   98   659 errorexit
  9416                                  ;   99   669 eqstr
  9417                                  ;  100   675 implerror
  9418                                  ;  101   685 segregerror
  9419                                  ;  102   697 setwflag
  9420                                  ;  103   706 error1
  9421                                  ;  104   713 error1
  9422                                  ;  105   720 get2Ops
  9423                                  ;  106   728 addrerror
  9424                                  ;  107   738 invaloperror
  9425                                  ;  108   751 immeerror
  9426                                  ;  109   761 addrerror
  9427                                  ;  110   771 invaloperror
  9428                                  ;  111   784 setwflag
  9429                                  ;  112   793 getOpL
  9430                                  ;  113   800 need
  9431                                  ;  114   805 getOpR
  9432                                  ;  115   812 getOpR
  9433                                  ;  116   819 getOp1
  9434                                  ;  117   826 isToken
  9435                                  ;  118   834 getMEM
  9436                                  ;  119   841 invaloperror
  9437                                  ;  120   854 error1
  9438                                  ;  121   861 testReg
  9439                                  ;  122   869 searchLabel
  9440                                  ;  123   881 getTokeType
  9441                                  ;  124   893 getOp1
  9442                                  ;  125   900 syntaxerror
  9443                                  ;  126   912 getIndReg2
  9444                                  ;  127   923 getIndReg1
  9445                                  ;  128   934 notfounderror
  9446                                  ;  129   948 isToken
  9447                                  ;  130   956 getTokeType
  9448                                  ;  131   968 numbererror
  9449                                  ;  132   980 isToken
  9450                                  ;  133   988 isToken
  9451                                  ;  134   996 errorexit
  9452                                  ;  135  1006 indexerror
  9453                                  ;  136  1017 indexerror
  9454                                  ;  137  1028 indexerror
  9455                                  ;  138  1039 indexerror
  9456                                  ;  139  1050 gen66h
  9457                                  ;  140  1057 error1
  9458                                  ;  141  1064 getLine
  9459                                  ;  142  1072 getTokeType
  9460                                  ;  143  1084 strcpy
  9461                                  ;  144  1091 storeLabel
  9462                                  ;  145  1102 getTokeType
  9463                                  ;  146  1114 lookCode
  9464                                  ;  147  1123 process
  9465                                  ;  148  1131 getVariable
  9466                                  ;  149  1143 skipRest
  9467                                  ;  150  1152 error1
  9468                                  ;  151  1159 error1
  9469                                  ;  152  1166 printLine
  9470                                  ;  153  1176 skipBlank
  9471                                  ;  154  1186 digit
  9472                                  ;  155  1192 getDigit
  9473                                  ;  156  1201 letterE
  9474                                  ;  157  1209 getName
  9475                                  ;  158  1217 errorexit
  9476                                  ;  159  1227 strcpy
  9477                                  ;  160  1234 errorexit
  9478                                  ;  161  1244 searchLabel
  9479                                  ;  162  1256 error1
  9480                                  ;  163  1263 errorexit
  9481                                  ;  164  1273 strcpy
  9482                                  ;  165  1280 errorexit
  9483                                  ;  166  1290 eqstr
  9484                                  ;  167  1296 strlen
  9485                                  ;  168  1303 storeLabel
  9486                                  ;  169  1314 getTokeType
  9487                                  ;  170  1326 lookCode
  9488                                  ;  171  1335 dataexit
  9489                                  ;  172  1344 dataexit
  9490                                  ;  173  1353 getTokeType
  9491                                  ;  174  1365 genCode8
  9492                                  ;  175  1374 skipBlank
  9493                                  ;  176  1384 isToken
  9494                                  ;  177  1392 genCode8
  9495                                  ;  178  1401 isToken
  9496                                  ;  179  1409 getTokeType
  9497                                  ;  180  1421 genCode16
  9498                                  ;  181  1431 isToken
  9499                                  ;  182  1439 getTokeType
  9500                                  ;  183  1451 genCode16
  9501                                  ;  184  1461 genCode16
  9502                                  ;  185  1471 isToken
  9503                                  ;  186  1479 getTokeType
  9504                                  ;  187  1491 syntaxerror
  9505                                  ;  188  1503 error1
  9506                                  ;  189  1510 numbererror
  9507                                  ;  190  1522 dataexit
  9508                                  ;  191  1531 eqstr
  9509                                  ;  192  1537 getTokeType
  9510                                  ;  193  1549 eqstr
  9511                                  ;  194  1555 getTokeType
  9512                                  ;  195  1567 eqstr
  9513                                  ;  196  1573 getTokeType
  9514                                  ;  197  1585 skipBlank
  9515                                  ;  198  1595 isToken
  9516                                  ;  199  1603 getTokeType
  9517                                  ;  200  1615 error1
  9518                                  ;  201  1622 prs
  9519                                  ;  202  1626 prc
  9520                                  ;  203  1630 getTokeType
  9521                                  ;  204  1642 error1
  9522                                  ;  205  1649 cputs
  9523                                  ;  206  1655 cputs
  9524                                  ;  207  1661 exitR
  9525                                  ;  208  1667 toupper
  9526                                  ;  209  1675 strcpy
  9527                                  ;  210  1682 strcat1
  9528                                  ;  211  1690 strcpy
  9529                                  ;  212  1697 strcat1
  9530                                  ;  213  1705 strcpy
  9531                                  ;  214  1712 strcat1
  9532                                  ;  215  1720 openR
  9533                                  ;  216  1726 cputs
  9534                                  ;  217  1732 cputs
  9535                                  ;  218  1738 exitR
  9536                                  ;  219  1744 creatR
  9537                                  ;  220  1751 cputs
  9538                                  ;  221  1757 cputs
  9539                                  ;  222  1763 exitR
  9540                                  ;  223  1769 creatR
  9541                                  ;  224  1776 cputs
  9542                                  ;  225  1782 cputs
  9543                                  ;  226  1788 exitR
  9544                                  ;  227  1794 prs
  9545                                  ;  228  1798 prs
  9546                                  ;  229  1802 prs
  9547                                  ;  230  1806 prs
  9548                                  ;  231  1810 prs
  9549                                  ;  232  1814 prs
  9550                                  ;  233  1818 prs
  9551                                  ;  234  1822 prs
  9552                                  ;  235  1826 prs
  9553                                  ;  236  1830 prs
  9554                                  ;  237  1834 printIntU
  9555                                  ;  238  1844 strcpy
  9556                                  ;  239  1851 strlen
  9557                                  ;  240  1858 prs
  9558                                  ;  241  1862 printIntU
  9559                                  ;  242  1872 prs
  9560                                  ;  243  1876 prs
  9561                                  ;  244  1880 prs
  9562                                  ;  245  1884 printhex16
  9563                                  ;  246  1895 searchLabel
  9564                                  ;  247  1907 notfounderror
  9565                                  ;  248  1921 prs
  9566                                  ;  249  1925 printhex16
  9567                                  ;  250  1936 prs
  9568                                  ;  251  1940 printhex16
  9569                                  ;  252  1951 prs
  9570                                  ;  253  1955 printIntU
  9571                                  ;  254  1965 error1
  9572                                  ;  255  1972 strcpy
  9573                                  ;  256  1979 prs
  9574                                  ;  257  1983 prs
  9575                                  ;  258  1987 prs
  9576                                  ;  259  1991 printhex16
  9577                                  ;  260  2002 searchLabel
  9578                                  ;  261  2014 notfounderror
  9579                                  ;  262  2028 prs
  9580                                  ;  263  2032 printhex16
  9581                                  ;  264  2043 prs
  9582                                  ;  265  2047 printhex16
  9583                                  ;  266  2058 prs
  9584                                  ;  267  2062 printIntU
  9585                                  ;  268  2072 prs
  9586                                  ;  269  2076 prs
  9587                                  ;  270  2080 prs
  9588                                  ;  271  2084 prs
  9589                                  ;  272  2088 prs
  9590                                  ;  273  2092 prs
  9591                                  ;  274  2096 printIntU
  9592                                  ;  275  2106 prs
  9593                                  ;  276  2110 prs
  9594                                  ;  277  2114 printIntU
  9595                                  ;  278  2124 fputcR
  9596                                  ;  279  2131 fcloseR
  9597                                  ;  280  2139 fcloseR
  9598                                  ;  281  2147 fcloseR
  9599                                  ;  282  2155 exitR
  9600                                  ;  283  2161 errorexit
  9601                                  ;  284  2171 genCode8
  9602                                  ;  285  2180 genCode8
  9603                                  ;  286  2189 genCode8
  9604                                  ;  287  2198 genCode8
  9605                                  ;  288  2207 genCode8
  9606                                  ;  289  2216 genCode16
  9607                                  ;  290  2226 genCode16
  9608                                  ;  291  2236 genCode8
  9609                                  ;  292  2245 genCode8
  9610                                  ;  293  2254 genCode16
  9611                                  ;  294  2264 genCode32
  9612                                  ;  295  2274 genCode16
  9613                                  ;  296  2284 genCode8
  9614                                  ;  297  2293 getTokeType
  9615                                  ;  298  2305 getCodeSize
  9616                                  ;  299  2317 getCodes
  9617                                  ;  300  2326 genCode8
  9618                                  ;  301  2335 getOpL
  9619                                  ;  302  2342 checkOpL
  9620                                  ;  303  2351 genCode2
  9621                                  ;  304  2360 getTokeType
  9622                                  ;  305  2372 implerror
  9623                                  ;  306  2382 genCodeW
  9624                                  ;  307  2391 writeEA
  9625                                  ;  308  2399 check2Ops
  9626                                  ;  309  2409 reg16error
  9627                                  ;  310  2420 addrerror
  9628                                  ;  311  2430 genCode8
  9629                                  ;  312  2439 genCode8
  9630                                  ;  313  2448 writeEA
  9631                                  ;  314  2456 check2Ops
  9632                                  ;  315  2466 setsflag
  9633                                  ;  316  2475 genCodeW
  9634                                  ;  317  2484 genImmediate
  9635                                  ;  318  2497 genCodeW
  9636                                  ;  319  2506 writeEA
  9637                                  ;  320  2514 genCode8
  9638                                  ;  321  2523 genImmediate
  9639                                  ;  322  2536 genCodeW
  9640                                  ;  323  2545 writeEA
  9641                                  ;  324  2553 genCodeW
  9642                                  ;  325  2562 writeEA
  9643                                  ;  326  2570 syntaxerror
  9644                                  ;  327  2582 check2Ops
  9645                                  ;  328  2592 notfounderror
  9646                                  ;  329  2606 genCode2
  9647                                  ;  330  2615 genImmediate
  9648                                  ;  331  2628 genCodeW
  9649                                  ;  332  2637 writeEA
  9650                                  ;  333  2645 genImmediate
  9651                                  ;  334  2658 regmemerror
  9652                                  ;  335  2670 ChangeDirection
  9653                                  ;  336  2686 reg16error
  9654                                  ;  337  2697 genCode2
  9655                                  ;  338  2706 writeEA
  9656                                  ;  339  2714 genCodeW
  9657                                  ;  340  2723 genCode16
  9658                                  ;  341  2733 genCodeW
  9659                                  ;  342  2742 genCode16
  9660                                  ;  343  2752 genCodeW
  9661                                  ;  344  2761 writeEA
  9662                                  ;  345  2769 ChangeDirection
  9663                                  ;  346  2785 genCodeW
  9664                                  ;  347  2794 writeEA
  9665                                  ;  348  2802 syntaxerror
  9666                                  ;  349  2814 searchLabel
  9667                                  ;  350  2826 checkConstSize
  9668                                  ;  351  2841 genCode2
  9669                                  ;  352  2850 genCode8
  9670                                  ;  353  2859 genCode8
  9671                                  ;  354  2868 genCode2
  9672                                  ;  355  2877 genCode16
  9673                                  ;  356  2887 genCode8
  9674                                  ;  357  2896 genCode2
  9675                                  ;  358  2905 storeJmp
  9676                                  ;  359  2914 genCode16
  9677                                  ;  360  2924 searchLabel
  9678                                  ;  361  2936 checkConstSize
  9679                                  ;  362  2951 genCode8
  9680                                  ;  363  2960 genCode8
  9681                                  ;  364  2969 genCode8
  9682                                  ;  365  2978 genCode16
  9683                                  ;  366  2988 genCode8
  9684                                  ;  367  2997 genCode16
  9685                                  ;  368  3007 genCode8
  9686                                  ;  369  3016 storeJmp
  9687                                  ;  370  3025 genCode16
  9688                                  ;  371  3035 genCode8
  9689                                  ;  372  3044 genCode16
  9690                                  ;  373  3054 genCode8
  9691                                  ;  374  3063 getOpL
  9692                                  ;  375  3070 setsflag
  9693                                  ;  376  3079 genCode2
  9694                                  ;  377  3088 genCode8
  9695                                  ;  378  3097 genCode16
  9696                                  ;  379  3107 genCode8
  9697                                  ;  380  3116 genCode16
  9698                                  ;  381  3126 genCode8
  9699                                  ;  382  3135 storeJmp
  9700                                  ;  383  3144 genCode16
  9701                                  ;  384  3154 error1
  9702                                  ;  385  3161 genCode8
  9703                                  ;  386  3170 genCode8
  9704                                  ;  387  3179 checkOpL
  9705                                  ;  388  3188 reg16error
  9706                                  ;  389  3199 genCode2
  9707                                  ;  390  3208 genCode8
  9708                                  ;  391  3217 writeEA
  9709                                  ;  392  3225 syntaxerror
  9710                                  ;  393  3237 check2Ops
  9711                                  ;  394  3247 genCodeW
  9712                                  ;  395  3256 writeEA
  9713                                  ;  396  3264 genCodeW
  9714                                  ;  397  3273 writeEA
  9715                                  ;  398  3281 genCode8
  9716                                  ;  399  3290 genCodeW
  9717                                  ;  400  3299 writeEA
  9718                                  ;  401  3307 genCode8
  9719                                  ;  402  3316 genCode8
  9720                                  ;  403  3325 genCode8
  9721                                  ;  404  3334 getOp1
  9722                                  ;  405  3341 genCode16
  9723                                  ;  406  3351 numbererror
  9724                                  ;  407  3363 need
  9725                                  ;  408  3368 getOp1
  9726                                  ;  409  3375 genCode8
  9727                                  ;  410  3384 numbererror
  9728                                  ;  411  3396 numbererror
  9729                                  ;  412  3408 numbererror
  9730                                  ;  413  3420 prs
  9731                                  ;  414  3424 prs
  9732                                  ;  415  3428 error1
  9733                                  ;  416  3435 error1
  9734                                  ;  417  3442 prs
  9735                                  ;  418  3446 prs
  9736                                  ;  419  3450 prs
  9737                                  ;  420  3454 printIntU
  9738                                  ;  421  3464 prs
  9739                                  ;  422  3468 printIntU
  9740                                  ;  423  3478 fixJmp
  9741                                  ;  424  3485 error1
  9742                                  ;  425  3492 getarg
  9743                                  ;  426  3499 parse
  9744                                  ;  427  3505 fixJmpMain
  9745                                  ;  428  3516 epilog
  9746                                  ;  429  3523 end1
  9747                                  ;Input: AS.C, List: AS.S,  Lines: 1476
  9748                                  ;Glob. variables:  189 max.:  200
  9749                                  ;Functions      :   90 max.:  300
  9750                                  ;Calls          :  430 max.: 2000, NameField: 3528 max.:    65535
  9751                                  ;Code until     :21667 max.: 30000, free: 8333
  9752                                  ;Data (HeapEnd) :59154, resting stacksize:  6381
  9753                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
