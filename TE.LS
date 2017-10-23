     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E9FE2E                  jmp main
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
  5273                                  ;-839     R1Type=R2Type; R2Type=0;
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
  5352                                  ;-853     if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov
  5353                                  
  5354                                  .check2Ops203:
  5355 00001BE3 A0[2F00]                 mov al, [CodeType]
  5356 00001BE6 3C05                     cmp al, 5
  5357 00001BE8 0F840C00                 je  .check2Ops204
  5358 00001BEC A0[2E00]                 mov al, [Op2]
  5359 00001BEF 3C03                     cmp al, 3
  5360 00001BF1 0F850300                 jne .check2Ops205
  5361 00001BF5 E89FEF                   call invaloperror
  5362                                  
  5363                                  ;-854     setwflag();
  5364                                  
  5365                                  .check2Ops205:
  5366                                  .check2Ops204:
  5367 00001BF8 E8B6F9                   call setwflag
  5368                                  
  5369                                  ;-855 }
  5370                                  
  5371                                  
  5372                                  ;-856 
  5373                                  
  5374                                  
  5375                                  ;-857 int storeJmp() {
  5376                                  
  5377 00001BFB C3                       ret
  5378                                  ENDP
  5379                                  
  5380                                  storeJmp: PROC
  5381                                  
  5382                                  ;-858     unsigned int i;
  5383                                  
  5384                                  
  5385                                  ;-859     JmpMaxIx++;
  5386                                  
  5387                                  ;Function : storeJmp, Number of local variables: 1
  5388                                  ;   # type sign width addr used name   list of local variables
  5389                                  ;  200 var unsg word   858 NULL i = bp-2;
  5390 00001BFC C8020000                 ENTER  2,0
  5391 00001C00 FF06[5400]               inc  word[JmpMaxIx]
  5392                                  
  5393                                  ;-860     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");
  5394                                  
  5395 00001C04 A1[5400]                 mov ax, [JmpMaxIx]
  5396 00001C07 3DC800                   cmp ax, 200 ;unsigned : 1
  5397 00001C0A 0F8C0900                 jl  .storeJmp206
  5398 00001C0E 68[581C]                 push storeJmp_0
  5399 00001C11 E88DEE                   call errorexit
  5400 00001C14 83C402                   add  sp, 2
  5401                                  
  5402                                  ;-861     JmpNamePtr=strcpy(JmpNamePtr, Symbol);
  5403                                  
  5404                                  .storeJmp206:
  5405 00001C17 8D063075                 lea  ax, [Symbol]
  5406 00001C1B 50                       push ax
  5407 00001C1C FF36[5000]               push word [JmpNamePtr]
  5408 00001C20 E807E6                   call strcpy
  5409 00001C23 83C404                   add  sp, 4
  5410 00001C26 A3[5000]                 mov word [JmpNamePtr], ax
  5411                                  
  5412                                  ;-862     JmpNamePtr++;
  5413                                  
  5414 00001C29 FF06[5000]               inc  word[JmpNamePtr]
  5415                                  
  5416                                  ;-863     i = JmpNamePtr - &JmpNames;
  5417                                  
  5418 00001C2D A1[5000]                 mov ax, [JmpNamePtr]
  5419 00001C30 2D7A93                   sub ax, JmpNames
  5420 00001C33 8946FE                   mov [bp-2], ax
  5421                                  
  5422                                  ;-864     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");
  5423                                  
  5424 00001C36 8B46FE                   mov ax, [bp-2]
  5425 00001C39 3D810F                   cmp ax, 3969 ;unsigned : 0
  5426 00001C3C 0F820900                 jb  .storeJmp207
  5427 00001C40 68[651C]                 push storeJmp_1
  5428 00001C43 E85BEE                   call errorexit
  5429 00001C46 83C402                   add  sp, 2
  5430                                  
  5431                                  ;-865     JmpAddr[JmpMaxIx] = PC;
  5432                                  
  5433                                  .storeJmp207:
  5434 00001C49 A1[2300]                 mov ax, [PC]
  5435 00001C4C 8B1E[5400]               mov bx, [JmpMaxIx]
  5436 00001C50 D1E3                     shl bx, 1
  5437 00001C52 89871AA3                 mov [JmpAddr+bx], ax
  5438                                  
  5439                                  ;-866 }
  5440                                  
  5441                                  
  5442                                  ;-867 
  5443                                  
  5444                                  
  5445                                  ;-868 int storeLabel() {
  5446 00001C56 C9                       LEAVE
  5447 00001C57 C3                       ret
  5448 00001C58 746F6F206D616E7920-     storeJmp_0 db "too many Jmp",0
  5449 00001C61 4A6D7000           
  5450 00001C65 746F6F206D616E7920-     storeJmp_1 db "too many Jmp names",0
  5451 00001C6E 4A6D70206E616D6573-
  5452 00001C77 00                 
  5453                                  ENDP
  5454                                  
  5455                                  storeLabel: PROC
  5456                                  
  5457                                  ;-869     unsigned int i;
  5458                                  
  5459                                  
  5460                                  ;-870     if(searchLabel()) error1("duplicate label");
  5461                                  
  5462                                  ;Function : storeLabel, Number of local variables: 1
  5463                                  ;   # type sign width addr used name   list of local variables
  5464                                  ;  200 var unsg word   869 NULL i = bp-2;
  5465 00001C78 C8020000                 ENTER  2,0
  5466 00001C7C E807FC                   call searchLabel
  5467 00001C7F 08C0                     or  al, al
  5468 00001C81 0F840900                 je .storeLabel208
  5469 00001C85 68[EA1C]                 push storeLabel_0
  5470 00001C88 E8BFED                   call error1
  5471 00001C8B 83C402                   add  sp, 2
  5472                                  
  5473                                  ;-871     LabelMaxIx++;
  5474                                  
  5475                                  .storeLabel208:
  5476 00001C8E FF06[4A00]               inc  word[LabelMaxIx]
  5477                                  
  5478                                  ;-872     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  5479                                  
  5480 00001C92 A1[4A00]                 mov ax, [LabelMaxIx]
  5481 00001C95 3D5802                   cmp ax, 600 ;unsigned : 1
  5482 00001C98 0F8C0900                 jl  .storeLabel209
  5483 00001C9C 68[FA1C]                 push storeLabel_1
  5484 00001C9F E8FFED                   call errorexit
  5485 00001CA2 83C402                   add  sp, 2
  5486                                  
  5487                                  ;-873     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  5488                                  
  5489                                  .storeLabel209:
  5490 00001CA5 8D063075                 lea  ax, [Symbol]
  5491 00001CA9 50                       push ax
  5492 00001CAA FF36[4600]               push word [LabelNamePtr]
  5493 00001CAE E879E5                   call strcpy
  5494 00001CB1 83C404                   add  sp, 4
  5495 00001CB4 A3[4600]                 mov word [LabelNamePtr], ax
  5496                                  
  5497                                  ;-874     LabelNamePtr++;
  5498                                  
  5499 00001CB7 FF06[4600]               inc  word[LabelNamePtr]
  5500                                  
  5501                                  ;-875     i = LabelNamePtr - &LabelNames;
  5502                                  
  5503 00001CBB A1[4600]                 mov ax, [LabelNamePtr]
  5504 00001CBE 2D5A77                   sub ax, LabelNames
  5505 00001CC1 8946FE                   mov [bp-2], ax
  5506                                  
  5507                                  ;-876     if (i >= LABELNAMESMAX) errorexit("too many label names");
  5508                                  
  5509 00001CC4 8B46FE                   mov ax, [bp-2]
  5510 00001CC7 3D5117                   cmp ax, 5969 ;unsigned : 0
  5511 00001CCA 0F820900                 jb  .storeLabel210
  5512 00001CCE 68[0A1D]                 push storeLabel_2
  5513 00001CD1 E8CDED                   call errorexit
  5514 00001CD4 83C402                   add  sp, 2
  5515                                  
  5516                                  ;-877     LabelAddr[LabelMaxIx] = PC + Origin;
  5517                                  
  5518                                  .storeLabel210:
  5519 00001CD7 A1[2300]                 mov ax, [PC]
  5520 00001CDA 0306[2500]               add ax, [Origin]
  5521 00001CDE 8B1E[4A00]               mov bx, [LabelMaxIx]
  5522 00001CE2 D1E3                     shl bx, 1
  5523 00001CE4 8987CA8E                 mov [LabelAddr+bx], ax
  5524                                  
  5525                                  ;-878 }
  5526                                  
  5527                                  
  5528                                  ;-879 
  5529                                  
  5530                                  
  5531                                  ;-880 
  5532                                  
  5533                                  
  5534                                  ;-881 int genDB() {
  5535 00001CE8 C9                       LEAVE
  5536 00001CE9 C3                       ret
  5537 00001CEA 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  5538 00001CF3 206C6162656C00     
  5539 00001CFA 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  5540 00001D03 6C6162656C7300     
  5541 00001D0A 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  5542 00001D13 6C6162656C206E616D-
  5543 00001D1C 657300             
  5544                                  ENDP
  5545                                  
  5546                                  genDB: PROC
  5547                                  
  5548                                  ;-882     char c;  char isloop;
  5549                                  
  5550                                  
  5551                                  ;-883         isloop = 0;
  5552                                  
  5553                                  ;Function : genDB, Number of local variables: 2
  5554                                  ;   # type sign width addr used name   list of local variables
  5555                                  ;  200 var sign byte   882 NULL c = bp-2
  5556                                  ;  201 var sign byte   882 NULL isloop = bp-4;
  5557 00001D1F C8040000                 ENTER  4,0
  5558 00001D23 B80000                   mov ax, 0
  5559 00001D26 8846FC                   mov [bp-4], al
  5560                                  
  5561                                  ;-884             do {
  5562                                  
  5563                                  .genDB211:
  5564                                  
  5565                                  ;-885                 if (isloop) getTokeType();//omit ,  
  5566                                  
  5567 00001D29 8A46FC                   mov al, [bp-4]
  5568 00001D2C 08C0                     or  al, al
  5569 00001D2E 0F840300                 je .genDB212
  5570 00001D32 E8B3F9                   call getTokeType
  5571                                  
  5572                                  ;-886                 if (TokeType == DIGIT) genCode8(SymbolInt);
  5573                                  
  5574                                  .genDB212:
  5575 00001D35 A0[2C00]                 mov al, [TokeType]
  5576 00001D38 3C01                     cmp al, 1
  5577 00001D3A 0F850D00                 jne .genDB213
  5578 00001D3E FF36[0E00]               push word [SymbolInt]
  5579 00001D42 E84DF6                   call genCode8
  5580 00001D45 83C402                   add  sp, 2
  5581                                  
  5582                                  ;-887                 else {
  5583                                  
  5584 00001D48 E94100                   jmp .genDB214
  5585                                  .genDB213:
  5586                                  
  5587                                  ;-888                     skipBlank();
  5588                                  
  5589 00001D4B E891F0                   call skipBlank
  5590                                  
  5591                                  ;-889                     if (isToken('"')) {
  5592                                  
  5593 00001D4E 6A22                     push 34
  5594 00001D50 E821FA                   call isToken
  5595 00001D53 83C402                   add  sp, 2
  5596 00001D56 08C0                     or  al, al
  5597 00001D58 0F843000                 je .genDB215
  5598                                  
  5599                                  ;-890                         do {
  5600                                  
  5601                                  .genDB216:
  5602                                  
  5603                                  ;-891                             c= *InputPtr;
  5604                                  
  5605 00001D5C 8B1E[1400]               mov bx, [InputPtr]
  5606 00001D60 8A07                     mov al, [bx]
  5607 00001D62 B400                     mov ah, 0
  5608 00001D64 8846FE                   mov [bp-2], al
  5609                                  
  5610                                  ;-892                             genCode8(c);
  5611                                  
  5612 00001D67 8A46FE                   mov al, byte [bp-2]
  5613 00001D6A B400                     mov ah, 0
  5614 00001D6C 50                       push ax
  5615 00001D6D E822F6                   call genCode8
  5616 00001D70 83C402                   add  sp, 2
  5617                                  
  5618                                  ;-893                             InputPtr++;
  5619                                  
  5620 00001D73 FF06[1400]               inc  word[InputPtr]
  5621                                  
  5622                                  ;-894                         } while (*InputPtr != '"' );
  5623                                  
  5624 00001D77 8B1E[1400]               mov bx, [InputPtr]
  5625 00001D7B 8A07                     mov al, [bx]
  5626 00001D7D B400                     mov ah, 0
  5627 00001D7F 83F822                   cmp ax, 34
  5628 00001D82 0F840200                 je  .genDB217
  5629 00001D86 EBD4                     jmp .genDB216
  5630                                  .genDB217:
  5631                                  
  5632                                  ;-895                         InputPtr++;
  5633                                  
  5634 00001D88 FF06[1400]               inc  word[InputPtr]
  5635                                  
  5636                                  ;-896                     }
  5637                                  
  5638                                  
  5639                                  ;-897                 } 
  5640                                  
  5641                                  .genDB215:
  5642                                  
  5643                                  ;-898                 isloop = 1;
  5644                                  
  5645                                  .genDB214:
  5646 00001D8C B80100                   mov ax, 1
  5647 00001D8F 8846FC                   mov [bp-4], al
  5648                                  
  5649                                  ;-899             } while (isToken(','));
  5650                                  
  5651 00001D92 6A2C                     push 44
  5652 00001D94 E8DDF9                   call isToken
  5653 00001D97 83C402                   add  sp, 2
  5654 00001D9A 08C0                     or  al, al
  5655 00001D9C 0F840200                 je .genDB218
  5656 00001DA0 EB87                     jmp .genDB211
  5657                                  .genDB218:
  5658                                  
  5659                                  ;-900 }
  5660                                  
  5661                                  
  5662                                  ;-901 
  5663                                  
  5664                                  
  5665                                  ;-902 int getVariable() {
  5666 00001DA2 C9                       LEAVE
  5667 00001DA3 C3                       ret
  5668                                  ENDP
  5669                                  
  5670                                  getVariable: PROC
  5671                                  
  5672                                  ;-903     char c;
  5673                                  
  5674                                  
  5675                                  ;-904     storeLabel();
  5676                                  
  5677                                  ;Function : getVariable, Number of local variables: 1
  5678                                  ;   # type sign width addr used name   list of local variables
  5679                                  ;  200 var sign byte   903 NULL c = bp-2;
  5680 00001DA4 C8020000                 ENTER  2,0
  5681 00001DA8 E8CDFE                   call storeLabel
  5682                                  
  5683                                  ;-905     getTokeType();
  5684                                  
  5685 00001DAB E83AF9                   call getTokeType
  5686                                  
  5687                                  ;-906     if(TokeType==ALNUME) {//getName
  5688                                  
  5689 00001DAE A0[2C00]                 mov al, [TokeType]
  5690 00001DB1 3C03                     cmp al, 3
  5691 00001DB3 0F857001                 jne .getVariable219
  5692                                  
  5693                                  ;-907         lookCode();
  5694                                  
  5695 00001DB7 E861F5                   call lookCode
  5696                                  
  5697                                  ;-908         if (CodeType < 200) dataexit();
  5698                                  
  5699 00001DBA A0[2F00]                 mov al, [CodeType]
  5700 00001DBD 3CC8                     cmp al, 200
  5701 00001DBF 0F8D0300                 jge .getVariable220
  5702 00001DC3 E8B0EE                   call dataexit
  5703                                  
  5704                                  ;-909         if (CodeType > 205) dataexit();
  5705                                  
  5706                                  .getVariable220:
  5707 00001DC6 A0[2F00]                 mov al, [CodeType]
  5708 00001DC9 3CCD                     cmp al, 205
  5709 00001DCB 0F8E0300                 jle .getVariable221
  5710 00001DCF E8A4EE                   call dataexit
  5711                                  
  5712                                  ;-910         if (CodeType== 200) {//DB
  5713                                  
  5714                                  .getVariable221:
  5715 00001DD2 A0[2F00]                 mov al, [CodeType]
  5716 00001DD5 3CC8                     cmp al, 200
  5717 00001DD7 0F856A00                 jne .getVariable222
  5718                                  
  5719                                  ;-911             do {
  5720                                  
  5721                                  .getVariable223:
  5722                                  
  5723                                  ;-912                 getTokeType();
  5724                                  
  5725 00001DDB E80AF9                   call getTokeType
  5726                                  
  5727                                  ;-913                 if (TokeType == DIGIT) genCode8(SymbolInt);
  5728                                  
  5729 00001DDE A0[2C00]                 mov al, [TokeType]
  5730 00001DE1 3C01                     cmp al, 1
  5731 00001DE3 0F850D00                 jne .getVariable224
  5732 00001DE7 FF36[0E00]               push word [SymbolInt]
  5733 00001DEB E8A4F5                   call genCode8
  5734 00001DEE 83C402                   add  sp, 2
  5735                                  
  5736                                  ;-914                 else {
  5737                                  
  5738 00001DF1 E94100                   jmp .getVariable225
  5739                                  .getVariable224:
  5740                                  
  5741                                  ;-915                     skipBlank();
  5742                                  
  5743 00001DF4 E8E8EF                   call skipBlank
  5744                                  
  5745                                  ;-916                     if (isToken('"')) {
  5746                                  
  5747 00001DF7 6A22                     push 34
  5748 00001DF9 E878F9                   call isToken
  5749 00001DFC 83C402                   add  sp, 2
  5750 00001DFF 08C0                     or  al, al
  5751 00001E01 0F843000                 je .getVariable226
  5752                                  
  5753                                  ;-917                         do {
  5754                                  
  5755                                  .getVariable227:
  5756                                  
  5757                                  ;-918                             c= *InputPtr;
  5758                                  
  5759 00001E05 8B1E[1400]               mov bx, [InputPtr]
  5760 00001E09 8A07                     mov al, [bx]
  5761 00001E0B B400                     mov ah, 0
  5762 00001E0D 8846FE                   mov [bp-2], al
  5763                                  
  5764                                  ;-919                             genCode8(c);
  5765                                  
  5766 00001E10 8A46FE                   mov al, byte [bp-2]
  5767 00001E13 B400                     mov ah, 0
  5768 00001E15 50                       push ax
  5769 00001E16 E879F5                   call genCode8
  5770 00001E19 83C402                   add  sp, 2
  5771                                  
  5772                                  ;-920                             InputPtr++;
  5773                                  
  5774 00001E1C FF06[1400]               inc  word[InputPtr]
  5775                                  
  5776                                  ;-921                         } while (*InputPtr != '"' );
  5777                                  
  5778 00001E20 8B1E[1400]               mov bx, [InputPtr]
  5779 00001E24 8A07                     mov al, [bx]
  5780 00001E26 B400                     mov ah, 0
  5781 00001E28 83F822                   cmp ax, 34
  5782 00001E2B 0F840200                 je  .getVariable228
  5783 00001E2F EBD4                     jmp .getVariable227
  5784                                  .getVariable228:
  5785                                  
  5786                                  ;-922                         InputPtr++;
  5787                                  
  5788 00001E31 FF06[1400]               inc  word[InputPtr]
  5789                                  
  5790                                  ;-923                     }
  5791                                  
  5792                                  
  5793                                  ;-924                 }
  5794                                  
  5795                                  .getVariable226:
  5796                                  
  5797                                  ;-925             } while (isToken(','));
  5798                                  
  5799                                  .getVariable225:
  5800 00001E35 6A2C                     push 44
  5801 00001E37 E83AF9                   call isToken
  5802 00001E3A 83C402                   add  sp, 2
  5803 00001E3D 08C0                     or  al, al
  5804 00001E3F 0F840200                 je .getVariable229
  5805 00001E43 EB96                     jmp .getVariable223
  5806                                  .getVariable229:
  5807                                  
  5808                                  ;-926         }
  5809                                  
  5810                                  
  5811                                  ;-927         if (CodeType == 201) {//DW
  5812                                  
  5813                                  .getVariable222:
  5814 00001E45 A0[2F00]                 mov al, [CodeType]
  5815 00001E48 3CC9                     cmp al, 201
  5816 00001E4A 0F852600                 jne .getVariable230
  5817                                  
  5818                                  ;-928             do {
  5819                                  
  5820                                  .getVariable231:
  5821                                  
  5822                                  ;-929                 getTokeType();
  5823                                  
  5824 00001E4E E897F8                   call getTokeType
  5825                                  
  5826                                  ;-930                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  5827                                  
  5828 00001E51 A0[2C00]                 mov al, [TokeType]
  5829 00001E54 3C01                     cmp al, 1
  5830 00001E56 0F850A00                 jne .getVariable232
  5831 00001E5A FF36[0E00]               push word [SymbolInt]
  5832 00001E5E E8C8F5                   call genCode16
  5833 00001E61 83C402                   add  sp, 2
  5834                                  
  5835                                  ;-931             } while (isToken(','));
  5836                                  
  5837                                  .getVariable232:
  5838 00001E64 6A2C                     push 44
  5839 00001E66 E80BF9                   call isToken
  5840 00001E69 83C402                   add  sp, 2
  5841 00001E6C 08C0                     or  al, al
  5842 00001E6E 0F840200                 je .getVariable233
  5843 00001E72 EBDA                     jmp .getVariable231
  5844                                  .getVariable233:
  5845                                  
  5846                                  ;-932         }
  5847                                  
  5848                                  
  5849                                  ;-933         if (CodeType == 202) {//DD
  5850                                  
  5851                                  .getVariable230:
  5852 00001E74 A0[2F00]                 mov al, [CodeType]
  5853 00001E77 3CCA                     cmp al, 202
  5854 00001E79 0F852E00                 jne .getVariable234
  5855                                  
  5856                                  ;-934             do {
  5857                                  
  5858                                  .getVariable235:
  5859                                  
  5860                                  ;-935                 getTokeType();
  5861                                  
  5862 00001E7D E868F8                   call getTokeType
  5863                                  
  5864                                  ;-936                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  5865                                  
  5866 00001E80 A0[2C00]                 mov al, [TokeType]
  5867 00001E83 3C01                     cmp al, 1
  5868 00001E85 0F851200                 jne .getVariable236
  5869 00001E89 FF36[0E00]               push word [SymbolInt]
  5870 00001E8D E899F5                   call genCode16
  5871 00001E90 83C402                   add  sp, 2
  5872                                  
  5873                                  ;-937                                     genCode16(0);}//todo genCode32(SymbolLong);
  5874                                  
  5875 00001E93 6A00                     push 0
  5876 00001E95 E891F5                   call genCode16
  5877 00001E98 83C402                   add  sp, 2
  5878                                  
  5879                                  ;-938             } while (isToken(','));
  5880                                  
  5881                                  .getVariable236:
  5882 00001E9B 6A2C                     push 44
  5883 00001E9D E8D4F8                   call isToken
  5884 00001EA0 83C402                   add  sp, 2
  5885 00001EA3 08C0                     or  al, al
  5886 00001EA5 0F840200                 je .getVariable237
  5887 00001EA9 EBD2                     jmp .getVariable235
  5888                                  .getVariable237:
  5889                                  
  5890                                  ;-939         }
  5891                                  
  5892                                  
  5893                                  ;-940         if (CodeType >= 203) {//resb, resw, resd
  5894                                  
  5895                                  .getVariable234:
  5896 00001EAB A0[2F00]                 mov al, [CodeType]
  5897 00001EAE 3CCB                     cmp al, 203 ;unsigned : 1
  5898 00001EB0 0F8C7000                 jl  .getVariable238
  5899                                  
  5900                                  ;-941             getTokeType();
  5901                                  
  5902 00001EB4 E831F8                   call getTokeType
  5903                                  
  5904                                  ;-942             if (TokeType == DIGIT) {
  5905                                  
  5906 00001EB7 A0[2C00]                 mov al, [TokeType]
  5907 00001EBA 3C01                     cmp al, 1
  5908 00001EBC 0F856100                 jne .getVariable239
  5909                                  
  5910                                  ;-943                 if (SymbolInt <= 0) syntaxerror();
  5911                                  
  5912 00001EC0 A1[0E00]                 mov ax, [SymbolInt]
  5913 00001EC3 83F800                   cmp ax, 0
  5914 00001EC6 0F870300                 ja  .getVariable240
  5915 00001ECA E87EED                   call syntaxerror
  5916                                  
  5917                                  ;-944                 if (AbsoluteLab == 0) error1("Absolute is null");
  5918                                  
  5919                                  .getVariable240:
  5920 00001ECD A1[2700]                 mov ax, [AbsoluteLab]
  5921 00001ED0 83F800                   cmp ax, 0
  5922 00001ED3 0F850900                 jne .getVariable241
  5923 00001ED7 68[2C1F]                 push getVariable_0
  5924 00001EDA E86DEB                   call error1
  5925 00001EDD 83C402                   add  sp, 2
  5926                                  
  5927                                  ;-945                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  5928                                  
  5929                                  .getVariable241:
  5930 00001EE0 A1[2700]                 mov ax, [AbsoluteLab]
  5931 00001EE3 8B1E[4A00]               mov bx, [LabelMaxIx]
  5932 00001EE7 D1E3                     shl bx, 1
  5933 00001EE9 8987CA8E                 mov [LabelAddr+bx], ax
  5934                                  
  5935                                  ;-946                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  5936                                  
  5937 00001EED A0[2F00]                 mov al, [CodeType]
  5938 00001EF0 3CCC                     cmp al, 204
  5939 00001EF2 0F850A00                 jne .getVariable242
  5940 00001EF6 A1[0E00]                 mov ax, [SymbolInt]
  5941 00001EF9 0306[0E00]               add ax, [SymbolInt]
  5942 00001EFD A3[0E00]                 mov word [SymbolInt], ax
  5943                                  
  5944                                  ;-947                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  5945                                  
  5946                                  .getVariable242:
  5947 00001F00 A0[2F00]                 mov al, [CodeType]
  5948 00001F03 3CCD                     cmp al, 205
  5949 00001F05 0F850B00                 jne .getVariable243
  5950 00001F09 A1[0E00]                 mov ax, [SymbolInt]
  5951 00001F0C BB0400                   mov bx, 4
  5952 00001F0F F7E3                     mul bx
  5953 00001F11 A3[0E00]                 mov word [SymbolInt], ax
  5954                                  
  5955                                  ;-948                 AbsoluteLab = AbsoluteLab + SymbolInt;
  5956                                  
  5957                                  .getVariable243:
  5958 00001F14 A1[2700]                 mov ax, [AbsoluteLab]
  5959 00001F17 0306[0E00]               add ax, [SymbolInt]
  5960 00001F1B A3[2700]                 mov word [AbsoluteLab], ax
  5961                                  
  5962                                  ;-949             } else numbererror();
  5963                                  
  5964 00001F1E E90300                   jmp .getVariable244
  5965                                  .getVariable239:
  5966 00001F21 E894EC                   call numbererror
  5967                                  
  5968                                  ;-950         }
  5969                                  
  5970                                  .getVariable244:
  5971                                  
  5972                                  ;-951     }
  5973                                  
  5974                                  .getVariable238:
  5975                                  
  5976                                  ;-952     else dataexit();
  5977                                  
  5978 00001F24 E90300                   jmp .getVariable245
  5979                                  .getVariable219:
  5980 00001F27 E84CED                   call dataexit
  5981                                  
  5982                                  ;-953 }
  5983                                  
  5984                                  .getVariable245:
  5985                                  
  5986                                  ;-954 
  5987                                  
  5988                                  
  5989                                  ;-955 int getCodeSize() {
  5990 00001F2A C9                       LEAVE
  5991 00001F2B C3                       ret
  5992 00001F2C 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  5993 00001F35 6973206E756C6C00   
  5994                                  ENDP
  5995                                  
  5996                                  getCodeSize: PROC
  5997                                  
  5998                                  ;-956     if (TokeType ==ALNUME) {
  5999                                  
  6000 00001F3D A0[2C00]                 mov al, [TokeType]
  6001 00001F40 3C03                     cmp al, 3
  6002 00001F42 0F855700                 jne .getCodeSize246
  6003                                  
  6004                                  ;-957         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  6005                                  
  6006 00001F46 68[A41F]                 push getCodeSize_0
  6007 00001F49 8D064F75                 lea  ax, [SymbolUpper]
  6008 00001F4D 50                       push ax
  6009 00001F4E E80FE3                   call eqstr
  6010 00001F51 83C404                   add  sp, 4
  6011 00001F54 08C0                     or  al, al
  6012 00001F56 0F840900                 je .getCodeSize247
  6013 00001F5A E88BF7                   call getTokeType
  6014 00001F5D B80100                   mov ax, 1
  6015 00001F60 E94000                   jmp .retngetCodeSize
  6016                                  
  6017                                  ;-958         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  6018                                  
  6019                                  .getCodeSize247:
  6020 00001F63 68[A91F]                 push getCodeSize_1
  6021 00001F66 8D064F75                 lea  ax, [SymbolUpper]
  6022 00001F6A 50                       push ax
  6023 00001F6B E8F2E2                   call eqstr
  6024 00001F6E 83C404                   add  sp, 4
  6025 00001F71 08C0                     or  al, al
  6026 00001F73 0F840900                 je .getCodeSize248
  6027 00001F77 E86EF7                   call getTokeType
  6028 00001F7A B80200                   mov ax, 2
  6029 00001F7D E92300                   jmp .retngetCodeSize
  6030                                  
  6031                                  ;-959         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  6032                                  
  6033                                  .getCodeSize248:
  6034 00001F80 68[AE1F]                 push getCodeSize_2
  6035 00001F83 8D064F75                 lea  ax, [SymbolUpper]
  6036 00001F87 50                       push ax
  6037 00001F88 E8D5E2                   call eqstr
  6038 00001F8B 83C404                   add  sp, 4
  6039 00001F8E 08C0                     or  al, al
  6040 00001F90 0F840900                 je .getCodeSize249
  6041 00001F94 E851F7                   call getTokeType
  6042 00001F97 B80300                   mov ax, 3
  6043 00001F9A E90600                   jmp .retngetCodeSize
  6044                                  
  6045                                  ;-960     }
  6046                                  
  6047                                  .getCodeSize249:
  6048                                  
  6049                                  ;-961     return 0;
  6050                                  
  6051                                  .getCodeSize246:
  6052 00001F9D B80000                   mov ax, 0
  6053 00001FA0 E90000                   jmp .retngetCodeSize
  6054                                  
  6055                                  ;-962 }
  6056                                  
  6057                                  
  6058                                  ;-963 
  6059                                  
  6060                                  
  6061                                  ;-964 
  6062                                  
  6063                                  
  6064                                  ;-965 int getarg() {
  6065                                  
  6066                                   .retngetCodeSize:
  6067 00001FA3 C3                       ret
  6068 00001FA4 4259544500              getCodeSize_0 db "BYTE",0
  6069 00001FA9 574F524400              getCodeSize_1 db "WORD",0
  6070 00001FAE 44574F524400            getCodeSize_2 db "DWORD",0
  6071                                  ENDP
  6072                                  
  6073                                  getarg: PROC
  6074                                  
  6075                                  ;-966     int arglen1; int i; char *c;
  6076                                  
  6077                                  
  6078                                  ;-967     arglen1=*arglen;
  6079                                  
  6080                                  ;Function : getarg, Number of local variables: 3
  6081                                  ;   # type sign width addr used name   list of local variables
  6082                                  ;  200 var sign word   966 NULL arglen1 = bp-2
  6083                                  ;  201 var sign word   966 NULL i = bp-4
  6084                                  ;  202 ptr sign byte   966 NULL c = bp-6;
  6085 00001FB4 C8060000                 ENTER  6,0
  6086 00001FB8 8B1E[5A00]               mov bx, [arglen]
  6087 00001FBC 8A07                     mov al, [bx]
  6088 00001FBE B400                     mov ah, 0
  6089 00001FC0 8946FE                   mov [bp-2], ax
  6090                                  
  6091                                  ;-968     if (arglen1==0) {
  6092                                  
  6093 00001FC3 8B46FE                   mov ax, [bp-2]
  6094 00001FC6 83F800                   cmp ax, 0
  6095 00001FC9 0F851C00                 jne .getarg250
  6096                                  
  6097                                  ;-969         cputs(Version1);
  6098                                  
  6099 00001FCD 8D06[0300]               lea  ax, [Version1]
  6100 00001FD1 50                       push ax
  6101 00001FD2 E8AAE0                   call cputs
  6102 00001FD5 83C402                   add  sp, 2
  6103                                  
  6104                                  ;-970         cputs(", Usage: AS.COM filename [w/o .S] : ");
  6105                                  
  6106 00001FD8 68[6421]                 push getarg_0
  6107 00001FDB E8A1E0                   call cputs
  6108 00001FDE 83C402                   add  sp, 2
  6109                                  
  6110                                  ;-971         exitR(3);
  6111                                  
  6112 00001FE1 6A03                     push 3
  6113 00001FE3 E800E1                   call exitR
  6114 00001FE6 83C402                   add  sp, 2
  6115                                  
  6116                                  ;-972     }
  6117                                  
  6118                                  
  6119                                  ;-973     i=arglen1+129;
  6120                                  
  6121                                  .getarg250:
  6122 00001FE9 8B46FE                   mov ax, [bp-2]
  6123 00001FEC 058100                   add ax, 129
  6124 00001FEF 8946FC                   mov [bp-4], ax
  6125                                  
  6126                                  ;-974     *i=0;
  6127                                  
  6128 00001FF2 B80000                   mov ax, 0
  6129 00001FF5 8B5EFC                   mov  bx, [bp-4]
  6130 00001FF8 8907                     mov  [bx], ax
  6131                                  
  6132                                  ;-975     arglen1--;
  6133                                  
  6134 00001FFA FF4EFE                   dec  word[bp-2]
  6135                                  
  6136                                  ;-976     toupper(argv);
  6137                                  
  6138 00001FFD FF36[5C00]               push word [argv]
  6139 00002001 E8CDE2                   call toupper
  6140 00002004 83C402                   add  sp, 2
  6141                                  
  6142                                  ;-977 
  6143                                  
  6144                                  
  6145                                  ;-978     strcpy(namein, argv); strcat1(namein, ".S");
  6146                                  
  6147 00002007 FF36[5C00]               push word [argv]
  6148 0000200B 8D068C76                 lea  ax, [namein]
  6149 0000200F 50                       push ax
  6150 00002010 E817E2                   call strcpy
  6151 00002013 83C404                   add  sp, 4
  6152 00002016 68[8921]                 push getarg_1
  6153 00002019 8D068C76                 lea  ax, [namein]
  6154 0000201D 50                       push ax
  6155 0000201E E88BE2                   call strcat1
  6156 00002021 83C404                   add  sp, 4
  6157                                  
  6158                                  ;-979     strcpy(namelst,argv); strcat1(namelst,".LST");
  6159                                  
  6160 00002024 FF36[5C00]               push word [argv]
  6161 00002028 8D06CF76                 lea  ax, [namelst]
  6162 0000202C 50                       push ax
  6163 0000202D E8FAE1                   call strcpy
  6164 00002030 83C404                   add  sp, 4
  6165 00002033 68[8C21]                 push getarg_2
  6166 00002036 8D06CF76                 lea  ax, [namelst]
  6167 0000203A 50                       push ax
  6168 0000203B E86EE2                   call strcat1
  6169 0000203E 83C404                   add  sp, 4
  6170                                  
  6171                                  ;-980     strcpy(namebin,argv); strcat1(namebin,".COM");
  6172                                  
  6173 00002041 FF36[5C00]               push word [argv]
  6174 00002045 8D061277                 lea  ax, [namebin]
  6175 00002049 50                       push ax
  6176 0000204A E8DDE1                   call strcpy
  6177 0000204D 83C404                   add  sp, 4
  6178 00002050 68[9121]                 push getarg_3
  6179 00002053 8D061277                 lea  ax, [namebin]
  6180 00002057 50                       push ax
  6181 00002058 E851E2                   call strcat1
  6182 0000205B 83C404                   add  sp, 4
  6183                                  
  6184                                  ;-981 
  6185                                  
  6186                                  
  6187                                  ;-982   DOS_ERR=0; PC=0; ErrorCount=0;
  6188                                  
  6189 0000205E B80000                   mov ax, 0
  6190 00002061 A3[1C00]                 mov word [DOS_ERR], ax
  6191 00002064 B80000                   mov ax, 0
  6192 00002067 A3[2300]                 mov word [PC], ax
  6193 0000206A B80000                   mov ax, 0
  6194 0000206D A3[1E00]                 mov word [ErrorCount], ax
  6195                                  
  6196                                  ;-983 
  6197                                  
  6198                                  
  6199                                  ;-984     asm_fd=openR (namein);
  6200                                  
  6201 00002070 8D068C76                 lea  ax, [namein]
  6202 00002074 50                       push ax
  6203 00002075 E83EE0                   call openR
  6204 00002078 83C402                   add  sp, 2
  6205 0000207B A3[1600]                 mov word [asm_fd], ax
  6206                                  
  6207                                  ;-985     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  6208                                  
  6209 0000207E A1[1C00]                 mov ax, [DOS_ERR]
  6210 00002081 08C0                     or  al, al
  6211 00002083 0F841C00                 je .getarg251
  6212 00002087 68[9621]                 push getarg_4
  6213 0000208A E8F2DF                   call cputs
  6214 0000208D 83C402                   add  sp, 2
  6215 00002090 8D068C76                 lea  ax, [namein]
  6216 00002094 50                       push ax
  6217 00002095 E8E7DF                   call cputs
  6218 00002098 83C402                   add  sp, 2
  6219 0000209B 6A01                     push 1
  6220 0000209D E846E0                   call exitR
  6221 000020A0 83C402                   add  sp, 2
  6222                                  
  6223                                  ;-986     lst_fd=creatR(namelst);
  6224                                  
  6225                                  .getarg251:
  6226 000020A3 8D06CF76                 lea  ax, [namelst]
  6227 000020A7 50                       push ax
  6228 000020A8 E81AE0                   call creatR
  6229 000020AB 83C402                   add  sp, 2
  6230 000020AE A3[1800]                 mov word [lst_fd], ax
  6231                                  
  6232                                  ;-987     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  6233                                  
  6234 000020B1 A1[1C00]                 mov ax, [DOS_ERR]
  6235 000020B4 08C0                     or  al, al
  6236 000020B6 0F841C00                 je .getarg252
  6237 000020BA 68[AC21]                 push getarg_5
  6238 000020BD E8BFDF                   call cputs
  6239 000020C0 83C402                   add  sp, 2
  6240 000020C3 8D06CF76                 lea  ax, [namelst]
  6241 000020C7 50                       push ax
  6242 000020C8 E8B4DF                   call cputs
  6243 000020CB 83C402                   add  sp, 2
  6244 000020CE 6A02                     push 2
  6245 000020D0 E813E0                   call exitR
  6246 000020D3 83C402                   add  sp, 2
  6247                                  
  6248                                  ;-988     bin_fd=creatR(namebin);
  6249                                  
  6250                                  .getarg252:
  6251 000020D6 8D061277                 lea  ax, [namebin]
  6252 000020DA 50                       push ax
  6253 000020DB E8E7DF                   call creatR
  6254 000020DE 83C402                   add  sp, 2
  6255 000020E1 A3[1A00]                 mov word [bin_fd], ax
  6256                                  
  6257                                  ;-989     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  6258                                  
  6259 000020E4 A1[1C00]                 mov ax, [DOS_ERR]
  6260 000020E7 08C0                     or  al, al
  6261 000020E9 0F841C00                 je .getarg253
  6262 000020ED 68[C321]                 push getarg_6
  6263 000020F0 E88CDF                   call cputs
  6264 000020F3 83C402                   add  sp, 2
  6265 000020F6 8D061277                 lea  ax, [namebin]
  6266 000020FA 50                       push ax
  6267 000020FB E881DF                   call cputs
  6268 000020FE 83C402                   add  sp, 2
  6269 00002101 6A02                     push 2
  6270 00002103 E8E0DF                   call exitR
  6271 00002106 83C402                   add  sp, 2
  6272                                  
  6273                                  ;-990 
  6274                                  
  6275                                  
  6276                                  ;-991     prs(";");
  6277                                  
  6278                                  .getarg253:
  6279 00002109 68[D921]                 push getarg_7
  6280 0000210C E824E6                   call prs
  6281 0000210F 83C402                   add  sp, 2
  6282                                  
  6283                                  ;-992     prs(Version1);
  6284                                  
  6285 00002112 8D06[0300]               lea  ax, [Version1]
  6286 00002116 50                       push ax
  6287 00002117 E819E6                   call prs
  6288 0000211A 83C402                   add  sp, 2
  6289                                  
  6290                                  ;-993     prs(", Source: "); prs(namein);
  6291                                  
  6292 0000211D 68[DB21]                 push getarg_8
  6293 00002120 E810E6                   call prs
  6294 00002123 83C402                   add  sp, 2
  6295 00002126 8D068C76                 lea  ax, [namein]
  6296 0000212A 50                       push ax
  6297 0000212B E805E6                   call prs
  6298 0000212E 83C402                   add  sp, 2
  6299                                  
  6300                                  ;-994     prs(", Output: "); prs(namelst);
  6301                                  
  6302 00002131 68[E621]                 push getarg_9
  6303 00002134 E8FCE5                   call prs
  6304 00002137 83C402                   add  sp, 2
  6305 0000213A 8D06CF76                 lea  ax, [namelst]
  6306 0000213E 50                       push ax
  6307 0000213F E8F1E5                   call prs
  6308 00002142 83C402                   add  sp, 2
  6309                                  
  6310                                  ;-995     prs(", "); prs(namebin);
  6311                                  
  6312 00002145 68[F121]                 push getarg_10
  6313 00002148 E8E8E5                   call prs
  6314 0000214B 83C402                   add  sp, 2
  6315 0000214E 8D061277                 lea  ax, [namebin]
  6316 00002152 50                       push ax
  6317 00002153 E8DDE5                   call prs
  6318 00002156 83C402                   add  sp, 2
  6319                                  
  6320                                  ;-996     prs("\n");
  6321                                  
  6322 00002159 68[F421]                 push getarg_11
  6323 0000215C E8D4E5                   call prs
  6324 0000215F 83C402                   add  sp, 2
  6325                                  
  6326                                  ;-997 }
  6327                                  
  6328                                  
  6329                                  ;-998 
  6330                                  
  6331                                  
  6332                                  ;-999 int fixJmp() {   
  6333 00002162 C9                       LEAVE
  6334 00002163 C3                       ret
  6335 00002164 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  6336 0000216D 41532E434F4D206669-
  6337 00002176 6C656E616D65205B77-
  6338 0000217F 2F6F202E535D203A20-
  6339 00002188 00                 
  6340 00002189 2E5300                  getarg_1 db ".S",0
  6341 0000218C 2E4C535400              getarg_2 db ".LST",0
  6342 00002191 2E434F4D00              getarg_3 db ".COM",0
  6343 00002196 536F75726365206669-     getarg_4 db "Source file missing: ",0
  6344 0000219F 6C65206D697373696E-
  6345 000021A8 673A2000           
  6346 000021AC 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  6347 000021B5 206E6F742063726561-
  6348 000021BE 74653A2000         
  6349 000021C3 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  6350 000021CC 6E6F74206372656174-
  6351 000021D5 653A2000           
  6352 000021D9 3B00                    getarg_7 db ";",0
  6353 000021DB 2C20536F757263653A-     getarg_8 db ", Source: ",0
  6354 000021E4 2000               
  6355 000021E6 2C204F75747075743A-     getarg_9 db ", Output: ",0
  6356 000021EF 2000               
  6357 000021F1 2C2000                  getarg_10 db ", ",0
  6358 000021F4 5C6E00                  getarg_11 db "\n",0
  6359                                  ENDP
  6360                                  
  6361                                  fixJmp: PROC
  6362                                  
  6363                                  ;-1000     unsigned int hex; int i;
  6364                                  
  6365                                  
  6366                                  ;-1001     char *p; int Ix; char c;
  6367                                  
  6368                                  
  6369                                  ;-1002 //    prs("\, jmp to fix:"); printIntU(JmpMaxIx);
  6370                                  
  6371                                  
  6372                                  ;-1003     p = &JmpNames;
  6373                                  
  6374                                  ;Function : fixJmp, Number of local variables: 5
  6375                                  ;   # type sign width addr used name   list of local variables
  6376                                  ;  200 var unsg word  1000 NULL hex = bp-2
  6377                                  ;  201 var sign word  1000 NULL i = bp-4
  6378                                  ;  202 ptr sign byte  1001 NULL p = bp-6
  6379                                  ;  203 var sign word  1001 NULL Ix = bp-8
  6380                                  ;  204 var sign byte  1001 NULL c = bp-10;
  6381 000021F7 C80A0000                 ENTER  10,0
  6382 000021FB B87A93                   mov ax, JmpNames
  6383 000021FE 8946FA                   mov [bp-6], ax
  6384                                  
  6385                                  ;-1004     i = 1;
  6386                                  
  6387 00002201 B80100                   mov ax, 1
  6388 00002204 8946FC                   mov [bp-4], ax
  6389                                  
  6390                                  ;-1005     while (i <= JmpMaxIx) {
  6391                                  
  6392                                  .fixJmp254:
  6393 00002207 8B46FC                   mov ax, [bp-4]
  6394 0000220A 3B06[5400]               cmp ax, [JmpMaxIx]
  6395 0000220E 0F8FA200                 jg  .fixJmp255
  6396                                  
  6397                                  ;-1006         strcpy(Symbol, p);
  6398                                  
  6399 00002212 FF76FA                   push word [bp-6]
  6400 00002215 8D063075                 lea  ax, [Symbol]
  6401 00002219 50                       push ax
  6402 0000221A E80DE0                   call strcpy
  6403 0000221D 83C404                   add  sp, 4
  6404                                  
  6405                                  ;-1007         p = strlen(Symbol) + p;
  6406                                  
  6407 00002220 8D063075                 lea  ax, [Symbol]
  6408 00002224 50                       push ax
  6409 00002225 E8DADF                   call strlen
  6410 00002228 83C402                   add  sp, 2
  6411 0000222B 0346FA                   add ax, [bp-6]
  6412 0000222E 8946FA                   mov [bp-6], ax
  6413                                  
  6414                                  ;-1008         p++;
  6415                                  
  6416 00002231 FF46FA                   inc  word[bp-6]
  6417                                  
  6418                                  ;-1009         hex = JmpAddr[i];
  6419                                  
  6420 00002234 8B5EFC                   mov bx, [bp-4]
  6421 00002237 D1E3                     shl bx, 1
  6422 00002239 8B871AA3                 mov ax, [JmpAddr + bx]
  6423 0000223D 8946FE                   mov [bp-2], ax
  6424                                  
  6425                                  ;-1010 //        prs("\n"); printIntU(i);
  6426                                  
  6427                                  
  6428                                  ;-1011 //        prs("  "); prs(Symbol); prs(", from:");
  6429                                  
  6430                                  
  6431                                  ;-1012 //        printhex16(hex);
  6432                                  
  6433                                  
  6434                                  ;-1013         
  6435                                  
  6436                                  
  6437                                  ;-1014         Ix=searchLabel();
  6438                                  
  6439 00002240 E843F6                   call searchLabel
  6440 00002243 8946F8                   mov [bp-8], ax
  6441                                  
  6442                                  ;-1015         if (Ix == 0) notfounderror();
  6443                                  
  6444 00002246 8B46F8                   mov ax, [bp-8]
  6445 00002249 83F800                   cmp ax, 0
  6446 0000224C 0F850300                 jne .fixJmp256
  6447 00002250 E868E8                   call notfounderror
  6448                                  
  6449                                  ;-1016         disp = LabelAddr[Ix];   
  6450                                  
  6451                                  .fixJmp256:
  6452 00002253 8B5EF8                   mov bx, [bp-8]
  6453 00002256 D1E3                     shl bx, 1
  6454 00002258 8B87CA8E                 mov ax, [LabelAddr + bx]
  6455 0000225C A3[3D00]                 mov word [disp], ax
  6456                                  
  6457                                  ;-1017         c = FileBin[hex];//look for 'A' push Absolute 
  6458                                  
  6459 0000225F 8B5EFE                   mov bx, [bp-2]
  6460 00002262 8A87AAA4                 mov al, [FileBin + bx]
  6461 00002266 8846F6                   mov [bp-10], al
  6462                                  
  6463                                  ;-1018 //        prs(", Label+ORG:"); printhex16(disp);
  6464                                  
  6465                                  
  6466                                  ;-1019         if (c != 0xAA) {
  6467                                  
  6468 00002269 8A46F6                   mov al, [bp-10]
  6469 0000226C 3CAA                     cmp al, 170
  6470 0000226E 0F841C00                 je  .fixJmp257
  6471                                  
  6472                                  ;-1020             disp = disp - hex;
  6473                                  
  6474 00002272 A1[3D00]                 mov ax, [disp]
  6475 00002275 2B46FE                   sub ax, [bp-2]
  6476 00002278 A3[3D00]                 mov word [disp], ax
  6477                                  
  6478                                  ;-1021             disp = disp -2;//PC points to next instruction
  6479                                  
  6480 0000227B A1[3D00]                 mov ax, [disp]
  6481 0000227E 83E802                   sub ax, 2
  6482 00002281 A3[3D00]                 mov word [disp], ax
  6483                                  
  6484                                  ;-1022             disp = disp - Origin; 
  6485                                  
  6486 00002284 A1[3D00]                 mov ax, [disp]
  6487 00002287 2B06[2500]               sub ax, [Origin]
  6488 0000228B A3[3D00]                 mov word [disp], ax
  6489                                  
  6490                                  ;-1023 //            prs(", rel:"); printhex16(disp);
  6491                                  
  6492                                  
  6493                                  ;-1024         }
  6494                                  
  6495                                  
  6496                                  ;-1025             FileBin[hex] = disp;//fix low byte
  6497                                  
  6498                                  .fixJmp257:
  6499 0000228E A1[3D00]                 mov ax, [disp]
  6500 00002291 8B5EFE                   mov bx, [bp-2]
  6501 00002294 8887AAA4                 mov [FileBin+bx], al
  6502                                  
  6503                                  ;-1026             hex++;
  6504                                  
  6505 00002298 FF46FE                   inc  word[bp-2]
  6506                                  
  6507                                  ;-1027             disp = disp >> 8;
  6508                                  
  6509 0000229B A1[3D00]                 mov ax, [disp]
  6510 0000229E C1E808                   shr ax, 8
  6511 000022A1 A3[3D00]                 mov word [disp], ax
  6512                                  
  6513                                  ;-1028             FileBin[hex] = disp; 
  6514                                  
  6515 000022A4 A1[3D00]                 mov ax, [disp]
  6516 000022A7 8B5EFE                   mov bx, [bp-2]
  6517 000022AA 8887AAA4                 mov [FileBin+bx], al
  6518                                  
  6519                                  ;-1029         i++;  
  6520                                  
  6521 000022AE FF46FC                   inc  word[bp-4]
  6522                                  
  6523                                  ;-1030     }
  6524                                  
  6525                                  
  6526                                  ;-1031 }
  6527                                  
  6528 000022B1 E953FF                   jmp .fixJmp254
  6529                                  .fixJmp255:
  6530                                  
  6531                                  ;-1032 int fixJmpMain() {   
  6532 000022B4 C9                       LEAVE
  6533 000022B5 C3                       ret
  6534                                  ENDP
  6535                                  
  6536                                  fixJmpMain: PROC
  6537                                  
  6538                                  ;-1033     unsigned int hex; 
  6539                                  
  6540                                  
  6541                                  ;-1034     int Ix; char c;
  6542                                  
  6543                                  
  6544                                  ;-1035     prs("\nfix jmp to main. resting global jmp: ");
  6545                                  
  6546                                  ;Function : fixJmpMain, Number of local variables: 3
  6547                                  ;   # type sign width addr used name   list of local variables
  6548                                  ;  200 var unsg word  1033 NULL hex = bp-2
  6549                                  ;  201 var sign word  1034 NULL Ix = bp-4
  6550                                  ;  202 var sign byte  1034 NULL c = bp-6;
  6551 000022B6 C8060000                 ENTER  6,0
  6552 000022BA 68[8923]                 push fixJmpMain_0
  6553 000022BD E873E4                   call prs
  6554 000022C0 83C402                   add  sp, 2
  6555                                  
  6556                                  ;-1036     printIntU(JmpMaxIx);  
  6557                                  
  6558 000022C3 FF36[5400]               push word [JmpMaxIx]
  6559 000022C7 E879E5                   call printIntU
  6560 000022CA 83C402                   add  sp, 2
  6561                                  
  6562                                  ;-1037     if (JmpMaxIx ) error1("resting global jmp");
  6563                                  
  6564 000022CD A1[5400]                 mov ax, [JmpMaxIx]
  6565 000022D0 08C0                     or  al, al
  6566 000022D2 0F840900                 je .fixJmpMain258
  6567 000022D6 68[B123]                 push fixJmpMain_1
  6568 000022D9 E86EE7                   call error1
  6569 000022DC 83C402                   add  sp, 2
  6570                                  
  6571                                  ;-1038         strcpy(Symbol, "main");
  6572                                  
  6573                                  .fixJmpMain258:
  6574 000022DF 68[C423]                 push fixJmpMain_2
  6575 000022E2 8D063075                 lea  ax, [Symbol]
  6576 000022E6 50                       push ax
  6577 000022E7 E840DF                   call strcpy
  6578 000022EA 83C404                   add  sp, 4
  6579                                  
  6580                                  ;-1039         hex = 1;//first instruction, PC=1
  6581                                  
  6582 000022ED B80100                   mov ax, 1
  6583 000022F0 8946FE                   mov [bp-2], ax
  6584                                  
  6585                                  ;-1040         Ix=searchLabel();
  6586                                  
  6587 000022F3 E890F5                   call searchLabel
  6588 000022F6 8946FC                   mov [bp-4], ax
  6589                                  
  6590                                  ;-1041         if (Ix == 0) notfounderror();
  6591                                  
  6592 000022F9 8B46FC                   mov ax, [bp-4]
  6593 000022FC 83F800                   cmp ax, 0
  6594 000022FF 0F850300                 jne .fixJmpMain259
  6595 00002303 E8B5E7                   call notfounderror
  6596                                  
  6597                                  ;-1042         disp = LabelAddr[Ix];   
  6598                                  
  6599                                  .fixJmpMain259:
  6600 00002306 8B5EFC                   mov bx, [bp-4]
  6601 00002309 D1E3                     shl bx, 1
  6602 0000230B 8B87CA8E                 mov ax, [LabelAddr + bx]
  6603 0000230F A3[3D00]                 mov word [disp], ax
  6604                                  
  6605                                  ;-1043         c = FileBin[hex];//look for 'A' push Absolute 
  6606                                  
  6607 00002312 8B5EFE                   mov bx, [bp-2]
  6608 00002315 8A87AAA4                 mov al, [FileBin + bx]
  6609 00002319 8846FA                   mov [bp-6], al
  6610                                  
  6611                                  ;-1044         prs("\nmain ,Label+ORG:"); printhex16(disp);
  6612                                  
  6613 0000231C 68[C923]                 push fixJmpMain_3
  6614 0000231F E811E4                   call prs
  6615 00002322 83C402                   add  sp, 2
  6616 00002325 FF36[3D00]               push word [disp]
  6617 00002329 E8EDE4                   call printhex16
  6618 0000232C 83C402                   add  sp, 2
  6619                                  
  6620                                  ;-1045         if (c != 0xAA) {
  6621                                  
  6622 0000232F 8A46FA                   mov al, [bp-6]
  6623 00002332 3CAA                     cmp al, 170
  6624 00002334 0F842F00                 je  .fixJmpMain260
  6625                                  
  6626                                  ;-1046             disp = disp - hex;
  6627                                  
  6628 00002338 A1[3D00]                 mov ax, [disp]
  6629 0000233B 2B46FE                   sub ax, [bp-2]
  6630 0000233E A3[3D00]                 mov word [disp], ax
  6631                                  
  6632                                  ;-1047             disp = disp -2;//PC points to next instruction
  6633                                  
  6634 00002341 A1[3D00]                 mov ax, [disp]
  6635 00002344 83E802                   sub ax, 2
  6636 00002347 A3[3D00]                 mov word [disp], ax
  6637                                  
  6638                                  ;-1048             disp = disp - Origin; 
  6639                                  
  6640 0000234A A1[3D00]                 mov ax, [disp]
  6641 0000234D 2B06[2500]               sub ax, [Origin]
  6642 00002351 A3[3D00]                 mov word [disp], ax
  6643                                  
  6644                                  ;-1049             prs(",rel:"); printhex16(disp);
  6645                                  
  6646 00002354 68[DC23]                 push fixJmpMain_4
  6647 00002357 E8D9E3                   call prs
  6648 0000235A 83C402                   add  sp, 2
  6649 0000235D FF36[3D00]               push word [disp]
  6650 00002361 E8B5E4                   call printhex16
  6651 00002364 83C402                   add  sp, 2
  6652                                  
  6653                                  ;-1050         }
  6654                                  
  6655                                  
  6656                                  ;-1051             FileBin[hex] = disp;//fix low byte
  6657                                  
  6658                                  .fixJmpMain260:
  6659 00002367 A1[3D00]                 mov ax, [disp]
  6660 0000236A 8B5EFE                   mov bx, [bp-2]
  6661 0000236D 8887AAA4                 mov [FileBin+bx], al
  6662                                  
  6663                                  ;-1052             hex++;
  6664                                  
  6665 00002371 FF46FE                   inc  word[bp-2]
  6666                                  
  6667                                  ;-1053             disp = disp >> 8;
  6668                                  
  6669 00002374 A1[3D00]                 mov ax, [disp]
  6670 00002377 C1E808                   shr ax, 8
  6671 0000237A A3[3D00]                 mov word [disp], ax
  6672                                  
  6673                                  ;-1054             FileBin[hex] = disp; 
  6674                                  
  6675 0000237D A1[3D00]                 mov ax, [disp]
  6676 00002380 8B5EFE                   mov bx, [bp-2]
  6677 00002383 8887AAA4                 mov [FileBin+bx], al
  6678                                  
  6679                                  ;-1055 }
  6680                                  
  6681                                  
  6682                                  ;-1056 
  6683                                  
  6684                                  
  6685                                  ;-1057 
  6686                                  
  6687                                  
  6688                                  ;-1058 int getCodes() {
  6689 00002387 C9                       LEAVE
  6690 00002388 C3                       ret
  6691 00002389 5C6E666978206A6D70-     fixJmpMain_0 db "\nfix jmp to main. resting global jmp: ",0
  6692 00002392 20746F206D61696E2E-
  6693 0000239B 2072657374696E6720-
  6694 000023A4 676C6F62616C206A6D-
  6695 000023AD 703A2000           
  6696 000023B1 72657374696E672067-     fixJmpMain_1 db "resting global jmp",0
  6697 000023BA 6C6F62616C206A6D70-
  6698 000023C3 00                 
  6699 000023C4 6D61696E00              fixJmpMain_2 db "main",0
  6700 000023C9 5C6E6D61696E202C4C-     fixJmpMain_3 db "\nmain ,Label+ORG:",0
  6701 000023D2 6162656C2B4F52473A-
  6702 000023DB 00                 
  6703 000023DC 2C72656C3A00            fixJmpMain_4 db ",rel:",0
  6704                                  ENDP
  6705                                  
  6706                                  getCodes: PROC
  6707                                  
  6708                                  ;-1059     OpCodePtr ++; Code1 = *OpCodePtr;
  6709                                  
  6710 000023E2 FF06[4300]               inc  word[OpCodePtr]
  6711 000023E6 8B1E[4300]               mov bx, [OpCodePtr]
  6712 000023EA 8A07                     mov al, [bx]
  6713 000023EC B400                     mov ah, 0
  6714 000023EE A2[3000]                 mov byte [Code1], al
  6715                                  
  6716                                  ;-1060     OpCodePtr ++; Code2 = *OpCodePtr;
  6717                                  
  6718 000023F1 FF06[4300]               inc  word[OpCodePtr]
  6719 000023F5 8B1E[4300]               mov bx, [OpCodePtr]
  6720 000023F9 8A07                     mov al, [bx]
  6721 000023FB B400                     mov ah, 0
  6722 000023FD A2[3100]                 mov byte [Code2], al
  6723                                  
  6724                                  ;-1061     OpCodePtr ++; Code3 = *OpCodePtr;
  6725                                  
  6726 00002400 FF06[4300]               inc  word[OpCodePtr]
  6727 00002404 8B1E[4300]               mov bx, [OpCodePtr]
  6728 00002408 8A07                     mov al, [bx]
  6729 0000240A B400                     mov ah, 0
  6730 0000240C A2[3200]                 mov byte [Code3], al
  6731                                  
  6732                                  ;-1062 }
  6733                                  
  6734                                  
  6735                                  ;-1063 
  6736                                  
  6737                                  
  6738                                  ;-1064 int process() {
  6739                                  
  6740 0000240F C3                       ret
  6741                                  ENDP
  6742                                  
  6743                                  process: PROC
  6744                                  
  6745                                  ;-1065     char c;
  6746                                  
  6747                                  
  6748                                  ;-1066     int i;
  6749                                  
  6750                                  
  6751                                  ;-1067     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6752                                  
  6753                                  ;Function : process, Number of local variables: 2
  6754                                  ;   # type sign width addr used name   list of local variables
  6755                                  ;  200 var sign byte  1065 NULL c = bp-2
  6756                                  ;  201 var sign word  1066 NULL i = bp-4;
  6757 00002410 C8040000                 ENTER  4,0
  6758 00002414 B80000                   mov ax, 0
  6759 00002417 A2[3B00]                 mov byte [rm], al
  6760 0000241A A2[3800]                 mov byte [wflag], al
  6761 0000241D A2[3900]                 mov byte [dflag], al
  6762 00002420 A2[3300]                 mov byte [R2No], al
  6763 00002423 A2[3400]                 mov byte [R1No], al
  6764 00002426 A2[3500]                 mov byte [R2Type], al
  6765 00002429 A2[3600]                 mov byte [R1Type], al
  6766 0000242C A2[2E00]                 mov byte [Op2], al
  6767 0000242F A2[2D00]                 mov byte [Op], al
  6768                                  
  6769                                  ;-1068     disp=imme=0;//int
  6770                                  
  6771 00002432 B80000                   mov ax, 0
  6772 00002435 A3[3F00]                 mov word [imme], ax
  6773 00002438 A3[3D00]                 mov word [disp], ax
  6774                                  
  6775                                  ;-1069     isDirect=1; //set in getMeM=0, need in WriteEA
  6776                                  
  6777 0000243B B80100                   mov ax, 1
  6778 0000243E A2[3C00]                 mov byte [isDirect], al
  6779                                  
  6780                                  ;-1070     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6781                                  
  6782 00002441 E8A4F2                   call getTokeType
  6783                                  
  6784                                  ;-1071     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6785                                  
  6786 00002444 E8F6FA                   call getCodeSize
  6787 00002447 A2[3700]                 mov byte [OpSize], al
  6788                                  
  6789                                  ;-1072     getCodes();//set: Code1, Code2, Code3
  6790                                  
  6791 0000244A E895FF                   call getCodes
  6792                                  
  6793                                  ;-1073 
  6794                                  
  6795                                  
  6796                                  ;-1074     if (CodeType ==  1) {//1 byte opcode
  6797                                  
  6798 0000244D A0[2F00]                 mov al, [CodeType]
  6799 00002450 3C01                     cmp al, 1
  6800 00002452 0F850F00                 jne .process261
  6801                                  
  6802                                  ;-1075         genCode8(Code1);
  6803                                  
  6804 00002456 A0[3000]                 mov al, byte [Code1]
  6805 00002459 B400                     mov ah, 0
  6806 0000245B 50                       push ax
  6807 0000245C E833EF                   call genCode8
  6808 0000245F 83C402                   add  sp, 2
  6809                                  
  6810                                  ;-1076         return;
  6811                                  
  6812 00002462 E9EE08                   jmp .retnprocess
  6813                                  
  6814                                  ;-1077     }
  6815                                  
  6816                                  
  6817                                  ;-1078 
  6818                                  
  6819                                  
  6820                                  ;-1079     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6821                                  
  6822                                  .process261:
  6823 00002465 A0[2F00]                 mov al, [CodeType]
  6824 00002468 3C02                     cmp al, 2
  6825 0000246A 0F856900                 jne .process262
  6826                                  
  6827                                  ;-1080         getOpL();
  6828                                  
  6829 0000246E E808F7                   call getOpL
  6830                                  
  6831                                  ;-1081         checkOpL();
  6832                                  
  6833 00002471 E890F3                   call checkOpL
  6834                                  
  6835                                  ;-1082         if (Code2 <= 1) {//inc,dec
  6836                                  
  6837 00002474 A0[3100]                 mov al, [Code2]
  6838 00002477 3C01                     cmp al, 1
  6839 00002479 0F8F2700                 jg  .process263
  6840                                  
  6841                                  ;-1083   	        if (Op == REG) {//short
  6842                                  
  6843 0000247D A0[2D00]                 mov al, [Op]
  6844 00002480 3C02                     cmp al, 2
  6845 00002482 0F851E00                 jne .process264
  6846                                  
  6847                                  ;-1084                 if (wflag) {genCode2(Code3, R1No); return; }
  6848                                  
  6849 00002486 A0[3800]                 mov al, [wflag]
  6850 00002489 08C0                     or  al, al
  6851 0000248B 0F841500                 je .process265
  6852 0000248F A0[3400]                 mov al, byte [R1No]
  6853 00002492 B400                     mov ah, 0
  6854 00002494 50                       push ax
  6855 00002495 A0[3200]                 mov al, byte [Code3]
  6856 00002498 B400                     mov ah, 0
  6857 0000249A 50                       push ax
  6858 0000249B E854EF                   call genCode2
  6859 0000249E 83C404                   add  sp, 4
  6860 000024A1 E9AF08                   jmp .retnprocess
  6861                                  
  6862                                  ;-1085             }
  6863                                  
  6864                                  .process265:
  6865                                  
  6866                                  ;-1086         }
  6867                                  
  6868                                  .process264:
  6869                                  
  6870                                  ;-1087         if (Code2 == 5) {//imul extension?
  6871                                  
  6872                                  .process263:
  6873 000024A4 A0[3100]                 mov al, [Code2]
  6874 000024A7 3C05                     cmp al, 5
  6875 000024A9 0F850F00                 jne .process266
  6876                                  
  6877                                  ;-1088             getTokeType();
  6878                                  
  6879 000024AD E838F2                   call getTokeType
  6880                                  
  6881                                  ;-1089             if (TokeType) implerror();
  6882                                  
  6883 000024B0 A0[2C00]                 mov al, [TokeType]
  6884 000024B3 08C0                     or  al, al
  6885 000024B5 0F840300                 je .process267
  6886 000024B9 E8A0E6                   call implerror
  6887                                  
  6888                                  ;-1090         }
  6889                                  
  6890                                  .process267:
  6891                                  
  6892                                  ;-1091         genCodeW(Code1);
  6893                                  
  6894                                  .process266:
  6895 000024BC A0[3000]                 mov al, byte [Code1]
  6896 000024BF B400                     mov ah, 0
  6897 000024C1 50                       push ax
  6898 000024C2 E848EF                   call genCodeW
  6899 000024C5 83C402                   add  sp, 2
  6900                                  
  6901                                  ;-1092         writeEA(Code2);
  6902                                  
  6903 000024C8 A0[3100]                 mov al, byte [Code2]
  6904 000024CB B400                     mov ah, 0
  6905 000024CD 50                       push ax
  6906 000024CE E8A3EF                   call writeEA
  6907 000024D1 83C402                   add  sp, 2
  6908                                  
  6909                                  ;-1093         return;
  6910                                  
  6911 000024D4 E97C08                   jmp .retnprocess
  6912                                  
  6913                                  ;-1094     }
  6914                                  
  6915                                  
  6916                                  ;-1095 
  6917                                  
  6918                                  
  6919                                  ;-1096     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6920                                  
  6921                                  .process262:
  6922 000024D7 A0[2F00]                 mov al, [CodeType]
  6923 000024DA 3C03                     cmp al, 3
  6924 000024DC 0F855100                 jne .process268
  6925                                  
  6926                                  ;-1097         check2Ops();    //setwflag not applicable
  6927                                  
  6928 000024E0 E8CDF6                   call check2Ops
  6929                                  
  6930                                  ;-1098         if (R1Type != WORD) reg16error();//only r16
  6931                                  
  6932 000024E3 A0[3600]                 mov al, [R1Type]
  6933 000024E6 3C02                     cmp al, 2
  6934 000024E8 0F840300                 je  .process269
  6935 000024EC E80DE7                   call reg16error
  6936                                  
  6937                                  ;-1099         if (Op2 != MEM) addrerror();//only m16
  6938                                  
  6939                                  .process269:
  6940 000024EF A0[2E00]                 mov al, [Op2]
  6941 000024F2 3C04                     cmp al, 4
  6942 000024F4 0F840300                 je  .process270
  6943 000024F8 E822E6                   call addrerror
  6944                                  
  6945                                  ;-1100 
  6946                                  
  6947                                  
  6948                                  ;-1101         genCode8(Code1);//les,lds,lea
  6949                                  
  6950                                  .process270:
  6951 000024FB A0[3000]                 mov al, byte [Code1]
  6952 000024FE B400                     mov ah, 0
  6953 00002500 50                       push ax
  6954 00002501 E88EEE                   call genCode8
  6955 00002504 83C402                   add  sp, 2
  6956                                  
  6957                                  ;-1102         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6958                                  
  6959 00002507 A0[3000]                 mov al, [Code1]
  6960 0000250A 3C0F                     cmp al, 15
  6961 0000250C 0F850C00                 jne .process271
  6962 00002510 A0[3100]                 mov al, byte [Code2]
  6963 00002513 B400                     mov ah, 0
  6964 00002515 50                       push ax
  6965 00002516 E879EE                   call genCode8
  6966 00002519 83C402                   add  sp, 2
  6967                                  
  6968                                  ;-1103         Op=Op2;//set MEM for writeEA
  6969                                  
  6970                                  .process271:
  6971 0000251C A0[2E00]                 mov al, [Op2]
  6972 0000251F A2[2D00]                 mov byte [Op], al
  6973                                  
  6974                                  ;-1104         writeEA(R1No);
  6975                                  
  6976 00002522 A0[3400]                 mov al, byte [R1No]
  6977 00002525 B400                     mov ah, 0
  6978 00002527 50                       push ax
  6979 00002528 E849EF                   call writeEA
  6980 0000252B 83C402                   add  sp, 2
  6981                                  
  6982                                  ;-1105         return;
  6983                                  
  6984 0000252E E92208                   jmp .retnprocess
  6985                                  
  6986                                  ;-1106     }
  6987                                  
  6988                                  
  6989                                  ;-1107 
  6990                                  
  6991                                  
  6992                                  ;-1108     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6993                                  
  6994                                  .process268:
  6995 00002531 A0[2F00]                 mov al, [CodeType]
  6996 00002534 3C04                     cmp al, 4
  6997 00002536 0F85EF00                 jne .process272
  6998                                  
  6999                                  ;-1109         check2Ops();
  7000                                  
  7001 0000253A E873F6                   call check2Ops
  7002                                  
  7003                                  ;-1110         if (Op2 == IMM) {//second operand is imm
  7004                                  
  7005 0000253D A0[2E00]                 mov al, [Op2]
  7006 00002540 3C01                     cmp al, 1
  7007 00002542 0F857900                 jne .process273
  7008                                  
  7009                                  ;-1111             setsflag();
  7010                                  
  7011 00002546 E8D5F0                   call setsflag
  7012                                  
  7013                                  ;-1112             if (Op == REG) {
  7014                                  
  7015 00002549 A0[2D00]                 mov al, [Op]
  7016 0000254C 3C02                     cmp al, 2
  7017 0000254E 0F853100                 jne .process274
  7018                                  
  7019                                  ;-1113                 if (R1No == 0) {// acc,imm
  7020                                  
  7021 00002552 A0[3400]                 mov al, [R1No]
  7022 00002555 3C00                     cmp al, 0
  7023 00002557 0F852800                 jne .process275
  7024                                  
  7025                                  ;-1114                     if (sflag == 0) {
  7026                                  
  7027 0000255B A0[3A00]                 mov al, [sflag]
  7028 0000255E 3C00                     cmp al, 0
  7029 00002560 0F851F00                 jne .process276
  7030                                  
  7031                                  ;-1115                         c = Code1 << 3;
  7032                                  
  7033 00002564 A0[3000]                 mov al, [Code1]
  7034 00002567 C0E003                   shl al, 3
  7035 0000256A 8846FE                   mov [bp-2], al
  7036                                  
  7037                                  ;-1116                         c += 4;
  7038                                  
  7039 0000256D 8046FE04                 add  byte[bp-2], 4
  7040                                  
  7041                                  ;-1117                         genCodeW(c);
  7042                                  
  7043 00002571 8A46FE                   mov al, byte [bp-2]
  7044 00002574 B400                     mov ah, 0
  7045 00002576 50                       push ax
  7046 00002577 E893EE                   call genCodeW
  7047 0000257A 83C402                   add  sp, 2
  7048                                  
  7049                                  ;-1118                         genImmediate();
  7050                                  
  7051 0000257D E8FAEF                   call genImmediate
  7052                                  
  7053                                  ;-1119                         return;
  7054                                  
  7055 00002580 E9D007                   jmp .retnprocess
  7056                                  
  7057                                  ;-1120                     }
  7058                                  
  7059                                  
  7060                                  ;-1121                 }
  7061                                  
  7062                                  .process276:
  7063                                  
  7064                                  ;-1122             }
  7065                                  
  7066                                  .process275:
  7067                                  
  7068                                  ;-1123             //r/m, imm: 80 sign-extended,TTT,imm
  7069                                  
  7070                                  
  7071                                  ;-1124             c = sflag + 0x80;
  7072                                  
  7073                                  .process274:
  7074 00002583 A0[3A00]                 mov al, [sflag]
  7075 00002586 0480                     add al, 128
  7076 00002588 8846FE                   mov [bp-2], al
  7077                                  
  7078                                  ;-1125             genCodeW(c);
  7079                                  
  7080 0000258B 8A46FE                   mov al, byte [bp-2]
  7081 0000258E B400                     mov ah, 0
  7082 00002590 50                       push ax
  7083 00002591 E879EE                   call genCodeW
  7084 00002594 83C402                   add  sp, 2
  7085                                  
  7086                                  ;-1126             writeEA(Code1);
  7087                                  
  7088 00002597 A0[3000]                 mov al, byte [Code1]
  7089 0000259A B400                     mov ah, 0
  7090 0000259C 50                       push ax
  7091 0000259D E8D4EE                   call writeEA
  7092 000025A0 83C402                   add  sp, 2
  7093                                  
  7094                                  ;-1127             if (sflag) genCode8(imme);
  7095                                  
  7096 000025A3 A0[3A00]                 mov al, [sflag]
  7097 000025A6 08C0                     or  al, al
  7098 000025A8 0F840D00                 je .process277
  7099 000025AC FF36[3F00]               push word [imme]
  7100 000025B0 E8DFED                   call genCode8
  7101 000025B3 83C402                   add  sp, 2
  7102                                  
  7103                                  ;-1128             else genImmediate();
  7104                                  
  7105 000025B6 E90300                   jmp .process278
  7106                                  .process277:
  7107 000025B9 E8BEEF                   call genImmediate
  7108                                  
  7109                                  ;-1129             return;
  7110                                  
  7111                                  .process278:
  7112 000025BC E99407                   jmp .retnprocess
  7113                                  
  7114                                  ;-1130         }
  7115                                  
  7116                                  
  7117                                  ;-1131         c = Code1 << 3;//r/m, r/r
  7118                                  
  7119                                  .process273:
  7120 000025BF A0[3000]                 mov al, [Code1]
  7121 000025C2 C0E003                   shl al, 3
  7122 000025C5 8846FE                   mov [bp-2], al
  7123                                  
  7124                                  ;-1132         if (Op == REG) {
  7125                                  
  7126 000025C8 A0[2D00]                 mov al, [Op]
  7127 000025CB 3C02                     cmp al, 2
  7128 000025CD 0F852E00                 jne .process279
  7129                                  
  7130                                  ;-1133             if (Op2 == MEM) {//reg, mem
  7131                                  
  7132 000025D1 A0[2E00]                 mov al, [Op2]
  7133 000025D4 3C04                     cmp al, 4
  7134 000025D6 0F852500                 jne .process280
  7135                                  
  7136                                  ;-1134                 c += 2;//add direction flag
  7137                                  
  7138 000025DA 8046FE02                 add  byte[bp-2], 2
  7139                                  
  7140                                  ;-1135                 genCodeW(c);
  7141                                  
  7142 000025DE 8A46FE                   mov al, byte [bp-2]
  7143 000025E1 B400                     mov ah, 0
  7144 000025E3 50                       push ax
  7145 000025E4 E826EE                   call genCodeW
  7146 000025E7 83C402                   add  sp, 2
  7147                                  
  7148                                  ;-1136                 Op=Op2;//set MEM for writeEA
  7149                                  
  7150 000025EA A0[2E00]                 mov al, [Op2]
  7151 000025ED A2[2D00]                 mov byte [Op], al
  7152                                  
  7153                                  ;-1137                 writeEA(R1No);
  7154                                  
  7155 000025F0 A0[3400]                 mov al, byte [R1No]
  7156 000025F3 B400                     mov ah, 0
  7157 000025F5 50                       push ax
  7158 000025F6 E87BEE                   call writeEA
  7159 000025F9 83C402                   add  sp, 2
  7160                                  
  7161                                  ;-1138                 return;
  7162                                  
  7163 000025FC E95407                   jmp .retnprocess
  7164                                  
  7165                                  ;-1139             }
  7166                                  
  7167                                  
  7168                                  ;-1140         }
  7169                                  
  7170                                  .process280:
  7171                                  
  7172                                  ;-1141         if (Op2 == REG) {//mem,reg    reg,reg
  7173                                  
  7174                                  .process279:
  7175 000025FF A0[2E00]                 mov al, [Op2]
  7176 00002602 3C02                     cmp al, 2
  7177 00002604 0F851B00                 jne .process281
  7178                                  
  7179                                  ;-1142             genCodeW(c);
  7180                                  
  7181 00002608 8A46FE                   mov al, byte [bp-2]
  7182 0000260B B400                     mov ah, 0
  7183 0000260D 50                       push ax
  7184 0000260E E8FCED                   call genCodeW
  7185 00002611 83C402                   add  sp, 2
  7186                                  
  7187                                  ;-1143             writeEA(R2No);//2. Op in reg-field
  7188                                  
  7189 00002614 A0[3300]                 mov al, byte [R2No]
  7190 00002617 B400                     mov ah, 0
  7191 00002619 50                       push ax
  7192 0000261A E857EE                   call writeEA
  7193 0000261D 83C402                   add  sp, 2
  7194                                  
  7195                                  ;-1144             return;
  7196                                  
  7197 00002620 E93007                   jmp .retnprocess
  7198                                  
  7199                                  ;-1145         }
  7200                                  
  7201                                  
  7202                                  ;-1146         syntaxerror();
  7203                                  
  7204                                  .process281:
  7205 00002623 E825E6                   call syntaxerror
  7206                                  
  7207                                  ;-1147         return;
  7208                                  
  7209 00002626 E92A07                   jmp .retnprocess
  7210                                  
  7211                                  ;-1148     }
  7212                                  
  7213                                  
  7214                                  ;-1149 
  7215                                  
  7216                                  
  7217                                  ;-1150     if (CodeType == 5) {//mov (movsx, movzx=51)
  7218                                  
  7219                                  .process272:
  7220 00002629 A0[2F00]                 mov al, [CodeType]
  7221 0000262C 3C05                     cmp al, 5
  7222 0000262E 0F858B01                 jne .process282
  7223                                  
  7224                                  ;-1151         check2Ops();
  7225                                  
  7226 00002632 E87BF5                   call check2Ops
  7227                                  
  7228                                  ;-1152 /*    prs("\n Op:"); printhex8a(Op);
  7229                                  
  7230                                  
  7231                                  ;-1153     prs(", Op2:"); printhex8a(Op2);
  7232                                  
  7233                                  
  7234                                  ;-1154     prs(", R1No:"); printhex8a(R1No);
  7235                                  
  7236                                  
  7237                                  ;-1155     prs(", R2No:"); printhex8a(R2No);   */
  7238                                  
  7239                                  
  7240                                  ;-1156         if (Op2 == ADR) {
  7241                                  
  7242 00002635 A0[2E00]                 mov al, [Op2]
  7243 00002638 3C03                     cmp al, 3
  7244 0000263A 0F851B00                 jne .process283
  7245                                  
  7246                                  ;-1157             if (disp) imme=disp;
  7247                                  
  7248 0000263E A1[3D00]                 mov ax, [disp]
  7249 00002641 08C0                     or  al, al
  7250 00002643 0F840900                 je .process284
  7251 00002647 A1[3D00]                 mov ax, [disp]
  7252 0000264A A3[3F00]                 mov word [imme], ax
  7253                                  
  7254                                  ;-1158             else notfounderror();
  7255                                  
  7256 0000264D E90300                   jmp .process285
  7257                                  .process284:
  7258 00002650 E868E4                   call notfounderror
  7259                                  
  7260                                  ;-1159             Op2=IMM;//continue with IMM
  7261                                  
  7262                                  .process285:
  7263 00002653 B80100                   mov ax, 1
  7264 00002656 A2[2E00]                 mov byte [Op2], al
  7265                                  
  7266                                  ;-1160         }
  7267                                  
  7268                                  
  7269                                  ;-1161         if (Op2 == IMM) {// r,i
  7270                                  
  7271                                  .process283:
  7272 00002659 A0[2E00]                 mov al, [Op2]
  7273 0000265C 3C01                     cmp al, 1
  7274 0000265E 0F855400                 jne .process286
  7275                                  
  7276                                  ;-1162             if (Op == REG) {
  7277                                  
  7278 00002662 A0[2D00]                 mov al, [Op]
  7279 00002665 3C02                     cmp al, 2
  7280 00002667 0F852500                 jne .process287
  7281                                  
  7282                                  ;-1163                 c = wflag << 3;
  7283                                  
  7284 0000266B A0[3800]                 mov al, [wflag]
  7285 0000266E C0E003                   shl al, 3
  7286 00002671 8846FE                   mov [bp-2], al
  7287                                  
  7288                                  ;-1164                 c += 0xB0;
  7289                                  
  7290 00002674 8046FEB0                 add  byte[bp-2], 176
  7291                                  
  7292                                  ;-1165                 genCode2(c, R1No);
  7293                                  
  7294 00002678 A0[3400]                 mov al, byte [R1No]
  7295 0000267B B400                     mov ah, 0
  7296 0000267D 50                       push ax
  7297 0000267E 8A46FE                   mov al, byte [bp-2]
  7298 00002681 B400                     mov ah, 0
  7299 00002683 50                       push ax
  7300 00002684 E86BED                   call genCode2
  7301 00002687 83C404                   add  sp, 4
  7302                                  
  7303                                  ;-1166                 genImmediate();
  7304                                  
  7305 0000268A E8EDEE                   call genImmediate
  7306                                  
  7307                                  ;-1167                 return;
  7308                                  
  7309 0000268D E9C306                   jmp .retnprocess
  7310                                  
  7311                                  ;-1168             }
  7312                                  
  7313                                  
  7314                                  ;-1169             if (Op == MEM) {// m,i
  7315                                  
  7316                                  .process287:
  7317 00002690 A0[2D00]                 mov al, [Op]
  7318 00002693 3C04                     cmp al, 4
  7319 00002695 0F851700                 jne .process288
  7320                                  
  7321                                  ;-1170                 genCodeW(0xC6);
  7322                                  
  7323 00002699 68C600                   push 198
  7324 0000269C E86EED                   call genCodeW
  7325 0000269F 83C402                   add  sp, 2
  7326                                  
  7327                                  ;-1171                 writeEA( 0 );
  7328                                  
  7329 000026A2 6A00                     push 0
  7330 000026A4 E8CDED                   call writeEA
  7331 000026A7 83C402                   add  sp, 2
  7332                                  
  7333                                  ;-1172                 genImmediate();
  7334                                  
  7335 000026AA E8CDEE                   call genImmediate
  7336                                  
  7337                                  ;-1173                 return;
  7338                                  
  7339 000026AD E9A306                   jmp .retnprocess
  7340                                  
  7341                                  ;-1174             }
  7342                                  
  7343                                  
  7344                                  ;-1175             regmemerror();
  7345                                  
  7346                                  .process288:
  7347 000026B0 E81FE5                   call regmemerror
  7348                                  
  7349                                  ;-1176             return;
  7350                                  
  7351 000026B3 E99D06                   jmp .retnprocess
  7352                                  
  7353                                  ;-1177         }
  7354                                  
  7355                                  
  7356                                  ;-1178         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7357                                  
  7358                                  .process286:
  7359 000026B6 A0[3600]                 mov al, [R1Type]
  7360 000026B9 3C04                     cmp al, 4
  7361 000026BB 0F850300                 jne .process289
  7362 000026BF E8E4EF                   call ChangeDirection
  7363                                  
  7364                                  ;-1179         if (R2Type == SEGREG) {//rm,sreg
  7365                                  
  7366                                  .process289:
  7367 000026C2 A0[3500]                 mov al, [R2Type]
  7368 000026C5 3C04                     cmp al, 4
  7369 000026C7 0F852A00                 jne .process290
  7370                                  
  7371                                  ;-1180             if (OpSize != WORD) reg16error();
  7372                                  
  7373 000026CB A0[3700]                 mov al, [OpSize]
  7374 000026CE 3C02                     cmp al, 2
  7375 000026D0 0F840300                 je  .process291
  7376 000026D4 E825E5                   call reg16error
  7377                                  
  7378                                  ;-1181                 genCode2(0x8C, dflag);
  7379                                  
  7380                                  .process291:
  7381 000026D7 A0[3900]                 mov al, byte [dflag]
  7382 000026DA B400                     mov ah, 0
  7383 000026DC 50                       push ax
  7384 000026DD 688C00                   push 140
  7385 000026E0 E80FED                   call genCode2
  7386 000026E3 83C404                   add  sp, 4
  7387                                  
  7388                                  ;-1182                 writeEA(R2No);
  7389                                  
  7390 000026E6 A0[3300]                 mov al, byte [R2No]
  7391 000026E9 B400                     mov ah, 0
  7392 000026EB 50                       push ax
  7393 000026EC E885ED                   call writeEA
  7394 000026EF 83C402                   add  sp, 2
  7395                                  
  7396                                  ;-1183                 return;
  7397                                  
  7398 000026F2 E95E06                   jmp .retnprocess
  7399                                  
  7400                                  ;-1184         }
  7401                                  
  7402                                  
  7403                                  ;-1185         if (Op2 == MEM) {//acc, moffs16
  7404                                  
  7405                                  .process290:
  7406 000026F5 A0[2E00]                 mov al, [Op2]
  7407 000026F8 3C04                     cmp al, 4
  7408 000026FA 0F853100                 jne .process292
  7409                                  
  7410                                  ;-1186             if (Op == REG) {
  7411                                  
  7412 000026FE A0[2D00]                 mov al, [Op]
  7413 00002701 3C02                     cmp al, 2
  7414 00002703 0F852800                 jne .process293
  7415                                  
  7416                                  ;-1187                 if (R1No == 0) {
  7417                                  
  7418 00002707 A0[3400]                 mov al, [R1No]
  7419 0000270A 3C00                     cmp al, 0
  7420 0000270C 0F851F00                 jne .process294
  7421                                  
  7422                                  ;-1188                     if (isDirect) {
  7423                                  
  7424 00002710 A0[3C00]                 mov al, [isDirect]
  7425 00002713 08C0                     or  al, al
  7426 00002715 0F841600                 je .process295
  7427                                  
  7428                                  ;-1189                         genCodeW(0xA0);
  7429                                  
  7430 00002719 68A000                   push 160
  7431 0000271C E8EEEC                   call genCodeW
  7432 0000271F 83C402                   add  sp, 2
  7433                                  
  7434                                  ;-1190                         genCode16(disp);
  7435                                  
  7436 00002722 FF36[3D00]               push word [disp]
  7437 00002726 E800ED                   call genCode16
  7438 00002729 83C402                   add  sp, 2
  7439                                  
  7440                                  ;-1191                         return;
  7441                                  
  7442 0000272C E92406                   jmp .retnprocess
  7443                                  
  7444                                  ;-1192                     }
  7445                                  
  7446                                  
  7447                                  ;-1193                 }
  7448                                  
  7449                                  .process295:
  7450                                  
  7451                                  ;-1194             }
  7452                                  
  7453                                  .process294:
  7454                                  
  7455                                  ;-1195         }
  7456                                  
  7457                                  .process293:
  7458                                  
  7459                                  ;-1196         if (Op == MEM) {//moffs16, acc
  7460                                  
  7461                                  .process292:
  7462 0000272F A0[2D00]                 mov al, [Op]
  7463 00002732 3C04                     cmp al, 4
  7464 00002734 0F853100                 jne .process296
  7465                                  
  7466                                  ;-1197             if (Op2 == REG) {
  7467                                  
  7468 00002738 A0[2E00]                 mov al, [Op2]
  7469 0000273B 3C02                     cmp al, 2
  7470 0000273D 0F852800                 jne .process297
  7471                                  
  7472                                  ;-1198                 if (R2No == 0) {
  7473                                  
  7474 00002741 A0[3300]                 mov al, [R2No]
  7475 00002744 3C00                     cmp al, 0
  7476 00002746 0F851F00                 jne .process298
  7477                                  
  7478                                  ;-1199                     if (isDirect) {
  7479                                  
  7480 0000274A A0[3C00]                 mov al, [isDirect]
  7481 0000274D 08C0                     or  al, al
  7482 0000274F 0F841600                 je .process299
  7483                                  
  7484                                  ;-1200                         genCodeW(0xA2);
  7485                                  
  7486 00002753 68A200                   push 162
  7487 00002756 E8B4EC                   call genCodeW
  7488 00002759 83C402                   add  sp, 2
  7489                                  
  7490                                  ;-1201                         genCode16(disp);
  7491                                  
  7492 0000275C FF36[3D00]               push word [disp]
  7493 00002760 E8C6EC                   call genCode16
  7494 00002763 83C402                   add  sp, 2
  7495                                  
  7496                                  ;-1202                         return;
  7497                                  
  7498 00002766 E9EA05                   jmp .retnprocess
  7499                                  
  7500                                  ;-1203                     }
  7501                                  
  7502                                  
  7503                                  ;-1204                 }
  7504                                  
  7505                                  .process299:
  7506                                  
  7507                                  ;-1205             }
  7508                                  
  7509                                  .process298:
  7510                                  
  7511                                  ;-1206 
  7512                                  
  7513                                  
  7514                                  ;-1207         }
  7515                                  
  7516                                  .process297:
  7517                                  
  7518                                  ;-1208         if (Op2 == REG) {//rm, r
  7519                                  
  7520                                  .process296:
  7521 00002769 A0[2E00]                 mov al, [Op2]
  7522 0000276C 3C02                     cmp al, 2
  7523 0000276E 0F851800                 jne .process300
  7524                                  
  7525                                  ;-1209             genCodeW(0x88);
  7526                                  
  7527 00002772 688800                   push 136
  7528 00002775 E895EC                   call genCodeW
  7529 00002778 83C402                   add  sp, 2
  7530                                  
  7531                                  ;-1210             writeEA(R2No);
  7532                                  
  7533 0000277B A0[3300]                 mov al, byte [R2No]
  7534 0000277E B400                     mov ah, 0
  7535 00002780 50                       push ax
  7536 00002781 E8F0EC                   call writeEA
  7537 00002784 83C402                   add  sp, 2
  7538                                  
  7539                                  ;-1211             return;
  7540                                  
  7541 00002787 E9C905                   jmp .retnprocess
  7542                                  
  7543                                  ;-1212         }
  7544                                  
  7545                                  
  7546                                  ;-1213         if (Op2 == MEM) {//r, m
  7547                                  
  7548                                  .process300:
  7549 0000278A A0[2E00]                 mov al, [Op2]
  7550 0000278D 3C04                     cmp al, 4
  7551 0000278F 0F852400                 jne .process301
  7552                                  
  7553                                  ;-1214             if (Op == REG) {
  7554                                  
  7555 00002793 A0[2D00]                 mov al, [Op]
  7556 00002796 3C02                     cmp al, 2
  7557 00002798 0F851B00                 jne .process302
  7558                                  
  7559                                  ;-1215                 ChangeDirection();
  7560                                  
  7561 0000279C E807EF                   call ChangeDirection
  7562                                  
  7563                                  ;-1216                 genCodeW(0x8A);
  7564                                  
  7565 0000279F 688A00                   push 138
  7566 000027A2 E868EC                   call genCodeW
  7567 000027A5 83C402                   add  sp, 2
  7568                                  
  7569                                  ;-1217                 writeEA(R2No);
  7570                                  
  7571 000027A8 A0[3300]                 mov al, byte [R2No]
  7572 000027AB B400                     mov ah, 0
  7573 000027AD 50                       push ax
  7574 000027AE E8C3EC                   call writeEA
  7575 000027B1 83C402                   add  sp, 2
  7576                                  
  7577                                  ;-1218                 return;
  7578                                  
  7579 000027B4 E99C05                   jmp .retnprocess
  7580                                  
  7581                                  ;-1219             }
  7582                                  
  7583                                  
  7584                                  ;-1220         }
  7585                                  
  7586                                  .process302:
  7587                                  
  7588                                  ;-1221         syntaxerror();
  7589                                  
  7590                                  .process301:
  7591 000027B7 E891E4                   call syntaxerror
  7592                                  
  7593                                  ;-1222         return;
  7594                                  
  7595 000027BA E99605                   jmp .retnprocess
  7596                                  
  7597                                  ;-1223     }
  7598                                  
  7599                                  
  7600                                  ;-1224 
  7601                                  
  7602                                  
  7603                                  ;-1225     if (CodeType == 6) {//Jcc
  7604                                  
  7605                                  .process282:
  7606 000027BD A0[2F00]                 mov al, [CodeType]
  7607 000027C0 3C06                     cmp al, 6
  7608 000027C2 0F85BE00                 jne .process303
  7609                                  
  7610                                  ;-1226         if (TokeType == ALNUME) {
  7611                                  
  7612 000027C6 A0[2C00]                 mov al, [TokeType]
  7613 000027C9 3C03                     cmp al, 3
  7614 000027CB 0F85B500                 jne .process304
  7615                                  
  7616                                  ;-1227             LabelIx=searchLabel();
  7617                                  
  7618 000027CF E8B4F0                   call searchLabel
  7619 000027D2 A3[4E00]                 mov word [LabelIx], ax
  7620                                  
  7621                                  ;-1228             if (LabelIx > 0) {
  7622                                  
  7623 000027D5 A1[4E00]                 mov ax, [LabelIx]
  7624 000027D8 83F800                   cmp ax, 0
  7625 000027DB 0F8E7A00                 jle .process305
  7626                                  
  7627                                  ;-1229                 disp=LabelAddr[LabelIx];
  7628                                  
  7629 000027DF 8B1E[4E00]               mov bx, [LabelIx]
  7630 000027E3 D1E3                     shl bx, 1
  7631 000027E5 8B87CA8E                 mov ax, [LabelAddr + bx]
  7632 000027E9 A3[3D00]                 mov word [disp], ax
  7633                                  
  7634                                  ;-1230                 disp = disp - PC;
  7635                                  
  7636 000027EC A1[3D00]                 mov ax, [disp]
  7637 000027EF 2B06[2300]               sub ax, [PC]
  7638 000027F3 A3[3D00]                 mov word [disp], ax
  7639                                  
  7640                                  ;-1231                 disp = disp - Origin;
  7641                                  
  7642 000027F6 A1[3D00]                 mov ax, [disp]
  7643 000027F9 2B06[2500]               sub ax, [Origin]
  7644 000027FD A3[3D00]                 mov word [disp], ax
  7645                                  
  7646                                  ;-1232                 if (checkConstSize(disp) ) {
  7647                                  
  7648 00002800 FF36[3D00]               push word [disp]
  7649 00002804 E873EE                   call checkConstSize
  7650 00002807 83C402                   add  sp, 2
  7651 0000280A 08C0                     or  al, al
  7652 0000280C 0F842000                 je .process306
  7653                                  
  7654                                  ;-1233                     genCode2(Code1, 0x70);//short
  7655                                  
  7656 00002810 6A70                     push 112
  7657 00002812 A0[3000]                 mov al, byte [Code1]
  7658 00002815 B400                     mov ah, 0
  7659 00002817 50                       push ax
  7660 00002818 E8D7EB                   call genCode2
  7661 0000281B 83C404                   add  sp, 4
  7662                                  
  7663                                  ;-1234                     disp -= 2;
  7664                                  
  7665 0000281E 832E[3D00]02             sub  word[disp], 2
  7666                                  
  7667                                  ;-1235                     genCode8(disp);
  7668                                  
  7669 00002823 FF36[3D00]               push word [disp]
  7670 00002827 E868EB                   call genCode8
  7671 0000282A 83C402                   add  sp, 2
  7672                                  
  7673                                  ;-1236                 } else {
  7674                                  
  7675 0000282D E92600                   jmp .process307
  7676                                  .process306:
  7677                                  
  7678                                  ;-1237                     genCode8(0x0F);
  7679                                  
  7680 00002830 6A0F                     push 15
  7681 00002832 E85DEB                   call genCode8
  7682 00002835 83C402                   add  sp, 2
  7683                                  
  7684                                  ;-1238                     genCode2(Code1, 0x80);//near
  7685                                  
  7686 00002838 688000                   push 128
  7687 0000283B A0[3000]                 mov al, byte [Code1]
  7688 0000283E B400                     mov ah, 0
  7689 00002840 50                       push ax
  7690 00002841 E8AEEB                   call genCode2
  7691 00002844 83C404                   add  sp, 4
  7692                                  
  7693                                  ;-1239                     disp -= 4;
  7694                                  
  7695 00002847 832E[3D00]04             sub  word[disp], 4
  7696                                  
  7697                                  ;-1240                     genCode16(disp);
  7698                                  
  7699 0000284C FF36[3D00]               push word [disp]
  7700 00002850 E8D6EB                   call genCode16
  7701 00002853 83C402                   add  sp, 2
  7702                                  
  7703                                  ;-1241                 }
  7704                                  
  7705                                  
  7706                                  ;-1242             }
  7707                                  
  7708                                  .process307:
  7709                                  
  7710                                  ;-1243             else {//jump forward, near only
  7711                                  
  7712 00002856 E92800                   jmp .process308
  7713                                  .process305:
  7714                                  
  7715                                  ;-1244                 genCode8(0x0F);
  7716                                  
  7717 00002859 6A0F                     push 15
  7718 0000285B E834EB                   call genCode8
  7719 0000285E 83C402                   add  sp, 2
  7720                                  
  7721                                  ;-1245                 genCode2(Code1, 0x80);
  7722                                  
  7723 00002861 688000                   push 128
  7724 00002864 A0[3000]                 mov al, byte [Code1]
  7725 00002867 B400                     mov ah, 0
  7726 00002869 50                       push ax
  7727 0000286A E885EB                   call genCode2
  7728 0000286D 83C404                   add  sp, 4
  7729                                  
  7730                                  ;-1246                 storeJmp();
  7731                                  
  7732 00002870 E889F3                   call storeJmp
  7733                                  
  7734                                  ;-1247                 genCode16(0);
  7735                                  
  7736 00002873 6A00                     push 0
  7737 00002875 E8B1EB                   call genCode16
  7738 00002878 83C402                   add  sp, 2
  7739                                  
  7740                                  ;-1248                 PrintRA='r';
  7741                                  
  7742 0000287B B87200                   mov ax, 114
  7743 0000287E A2[4500]                 mov byte [PrintRA], al
  7744                                  
  7745                                  ;-1249             }
  7746                                  
  7747                                  
  7748                                  ;-1250         return;
  7749                                  
  7750                                  .process308:
  7751 00002881 E9CF04                   jmp .retnprocess
  7752                                  
  7753                                  ;-1251         }
  7754                                  
  7755                                  
  7756                                  ;-1252     }
  7757                                  
  7758                                  .process304:
  7759                                  
  7760                                  ;-1253 
  7761                                  
  7762                                  
  7763                                  ;-1254     if (CodeType == 7) {//jmp, call
  7764                                  
  7765                                  .process303:
  7766 00002884 A0[2F00]                 mov al, [CodeType]
  7767 00002887 3C07                     cmp al, 7
  7768 00002889 0F85D400                 jne .process309
  7769                                  
  7770                                  ;-1255         if (TokeType == ALNUME) {
  7771                                  
  7772 0000288D A0[2C00]                 mov al, [TokeType]
  7773 00002890 3C03                     cmp al, 3
  7774 00002892 0F85CB00                 jne .process310
  7775                                  
  7776                                  ;-1256             LabelIx=searchLabel();
  7777                                  
  7778 00002896 E8EDEF                   call searchLabel
  7779 00002899 A3[4E00]                 mov word [LabelIx], ax
  7780                                  
  7781                                  ;-1257             if (LabelIx > 0) {
  7782                                  
  7783 0000289C A1[4E00]                 mov ax, [LabelIx]
  7784 0000289F 83F800                   cmp ax, 0
  7785 000028A2 0F8E9100                 jle .process311
  7786                                  
  7787                                  ;-1258                 disp=LabelAddr[LabelIx];
  7788                                  
  7789 000028A6 8B1E[4E00]               mov bx, [LabelIx]
  7790 000028AA D1E3                     shl bx, 1
  7791 000028AC 8B87CA8E                 mov ax, [LabelAddr + bx]
  7792 000028B0 A3[3D00]                 mov word [disp], ax
  7793                                  
  7794                                  ;-1259                 disp = disp - PC;
  7795                                  
  7796 000028B3 A1[3D00]                 mov ax, [disp]
  7797 000028B6 2B06[2300]               sub ax, [PC]
  7798 000028BA A3[3D00]                 mov word [disp], ax
  7799                                  
  7800                                  ;-1260                 disp = disp - Origin;
  7801                                  
  7802 000028BD A1[3D00]                 mov ax, [disp]
  7803 000028C0 2B06[2500]               sub ax, [Origin]
  7804 000028C4 A3[3D00]                 mov word [disp], ax
  7805                                  
  7806                                  ;-1261                 if (checkConstSize(disp) ) {
  7807                                  
  7808 000028C7 FF36[3D00]               push word [disp]
  7809 000028CB E8ACED                   call checkConstSize
  7810 000028CE 83C402                   add  sp, 2
  7811 000028D1 08C0                     or  al, al
  7812 000028D3 0F844200                 je .process312
  7813                                  
  7814                                  ;-1262                     if (Code1 == 0xE9) {//jmp only
  7815                                  
  7816 000028D7 A0[3000]                 mov al, [Code1]
  7817 000028DA 3CE9                     cmp al, 233
  7818 000028DC 0F851B00                 jne .process313
  7819                                  
  7820                                  ;-1263                         genCode8(0xEB);//short
  7821                                  
  7822 000028E0 68EB00                   push 235
  7823 000028E3 E8ACEA                   call genCode8
  7824 000028E6 83C402                   add  sp, 2
  7825                                  
  7826                                  ;-1264                         disp -= 2;
  7827                                  
  7828 000028E9 832E[3D00]02             sub  word[disp], 2
  7829                                  
  7830                                  ;-1265                         genCode8(disp);
  7831                                  
  7832 000028EE FF36[3D00]               push word [disp]
  7833 000028F2 E89DEA                   call genCode8
  7834 000028F5 83C402                   add  sp, 2
  7835                                  
  7836                                  ;-1266                     }
  7837                                  
  7838                                  
  7839                                  ;-1267                     else {
  7840                                  
  7841 000028F8 E91B00                   jmp .process314
  7842                                  .process313:
  7843                                  
  7844                                  ;-1268                         genCode8(Code1);//near
  7845                                  
  7846 000028FB A0[3000]                 mov al, byte [Code1]
  7847 000028FE B400                     mov ah, 0
  7848 00002900 50                       push ax
  7849 00002901 E88EEA                   call genCode8
  7850 00002904 83C402                   add  sp, 2
  7851                                  
  7852                                  ;-1269                         disp -= 3;
  7853                                  
  7854 00002907 832E[3D00]03             sub  word[disp], 3
  7855                                  
  7856                                  ;-1270                         genCode16(disp);
  7857                                  
  7858 0000290C FF36[3D00]               push word [disp]
  7859 00002910 E816EB                   call genCode16
  7860 00002913 83C402                   add  sp, 2
  7861                                  
  7862                                  ;-1271                     }
  7863                                  
  7864                                  
  7865                                  ;-1272                 }
  7866                                  
  7867                                  .process314:
  7868                                  
  7869                                  ;-1273                 else {
  7870                                  
  7871 00002916 E91B00                   jmp .process315
  7872                                  .process312:
  7873                                  
  7874                                  ;-1274                     genCode8(Code1);//near
  7875                                  
  7876 00002919 A0[3000]                 mov al, byte [Code1]
  7877 0000291C B400                     mov ah, 0
  7878 0000291E 50                       push ax
  7879 0000291F E870EA                   call genCode8
  7880 00002922 83C402                   add  sp, 2
  7881                                  
  7882                                  ;-1275                     disp -= 3;
  7883                                  
  7884 00002925 832E[3D00]03             sub  word[disp], 3
  7885                                  
  7886                                  ;-1276                     genCode16(disp);
  7887                                  
  7888 0000292A FF36[3D00]               push word [disp]
  7889 0000292E E8F8EA                   call genCode16
  7890 00002931 83C402                   add  sp, 2
  7891                                  
  7892                                  ;-1277                 }
  7893                                  
  7894                                  
  7895                                  ;-1278             }
  7896                                  
  7897                                  .process315:
  7898                                  
  7899                                  ;-1279             else {//jump forward, near only
  7900                                  
  7901 00002934 E92700                   jmp .process316
  7902                                  .process311:
  7903                                  
  7904                                  ;-1280                 genCode8(Code1);  
  7905                                  
  7906 00002937 A0[3000]                 mov al, byte [Code1]
  7907 0000293A B400                     mov ah, 0
  7908 0000293C 50                       push ax
  7909 0000293D E852EA                   call genCode8
  7910 00002940 83C402                   add  sp, 2
  7911                                  
  7912                                  ;-1281                 if (PC != 1) storeJmp();//omit jmp main
  7913                                  
  7914 00002943 A1[2300]                 mov ax, [PC]
  7915 00002946 83F801                   cmp ax, 1
  7916 00002949 0F840300                 je  .process317
  7917 0000294D E8ACF2                   call storeJmp
  7918                                  
  7919                                  ;-1282                 genCode16(0);
  7920                                  
  7921                                  .process317:
  7922 00002950 6A00                     push 0
  7923 00002952 E8D4EA                   call genCode16
  7924 00002955 83C402                   add  sp, 2
  7925                                  
  7926                                  ;-1283                 PrintRA='R';
  7927                                  
  7928 00002958 B85200                   mov ax, 82
  7929 0000295B A2[4500]                 mov byte [PrintRA], al
  7930                                  
  7931                                  ;-1284             }
  7932                                  
  7933                                  
  7934                                  ;-1285         return;
  7935                                  
  7936                                  .process316:
  7937 0000295E E9F203                   jmp .retnprocess
  7938                                  
  7939                                  ;-1286         }
  7940                                  
  7941                                  
  7942                                  ;-1287     }
  7943                                  
  7944                                  .process310:
  7945                                  
  7946                                  ;-1288 
  7947                                  
  7948                                  
  7949                                  ;-1289     if (CodeType ==  8) {//ret,retf
  7950                                  
  7951                                  .process309:
  7952 00002961 A0[2F00]                 mov al, [CodeType]
  7953 00002964 3C08                     cmp al, 8
  7954 00002966 0F853100                 jne .process318
  7955                                  
  7956                                  ;-1290         if (TokeType == DIGIT) {
  7957                                  
  7958 0000296A A0[2C00]                 mov al, [TokeType]
  7959 0000296D 3C01                     cmp al, 1
  7960 0000296F 0F851900                 jne .process319
  7961                                  
  7962                                  ;-1291             genCode8(Code2);
  7963                                  
  7964 00002973 A0[3100]                 mov al, byte [Code2]
  7965 00002976 B400                     mov ah, 0
  7966 00002978 50                       push ax
  7967 00002979 E816EA                   call genCode8
  7968 0000297C 83C402                   add  sp, 2
  7969                                  
  7970                                  ;-1292             genCode16(SymbolInt);
  7971                                  
  7972 0000297F FF36[0E00]               push word [SymbolInt]
  7973 00002983 E8A3EA                   call genCode16
  7974 00002986 83C402                   add  sp, 2
  7975                                  
  7976                                  ;-1293             return;
  7977                                  
  7978 00002989 E9C703                   jmp .retnprocess
  7979                                  
  7980                                  ;-1294         }
  7981                                  
  7982                                  
  7983                                  ;-1295         genCode8(Code1);
  7984                                  
  7985                                  .process319:
  7986 0000298C A0[3000]                 mov al, byte [Code1]
  7987 0000298F B400                     mov ah, 0
  7988 00002991 50                       push ax
  7989 00002992 E8FDE9                   call genCode8
  7990 00002995 83C402                   add  sp, 2
  7991                                  
  7992                                  ;-1296         return;
  7993                                  
  7994 00002998 E9B803                   jmp .retnprocess
  7995                                  
  7996                                  ;-1297     }
  7997                                  
  7998                                  
  7999                                  ;-1298 
  8000                                  
  8001                                  
  8002                                  ;-1299     if (CodeType == 9) {//push, pop
  8003                                  
  8004                                  .process318:
  8005 0000299B A0[2F00]                 mov al, [CodeType]
  8006 0000299E 3C09                     cmp al, 9
  8007 000029A0 0F854A01                 jne .process320
  8008                                  
  8009                                  ;-1300         getOpL();
  8010                                  
  8011 000029A4 E8D2F1                   call getOpL
  8012                                  
  8013                                  ;-1301         if (Code1 == 0x50) {//push only
  8014                                  
  8015 000029A7 A0[3000]                 mov al, [Code1]
  8016 000029AA 3C50                     cmp al, 80
  8017 000029AC 0F858400                 jne .process321
  8018                                  
  8019                                  ;-1302             if (Op == IMM) {//push imm8,16
  8020                                  
  8021 000029B0 A0[2D00]                 mov al, [Op]
  8022 000029B3 3C01                     cmp al, 1
  8023 000029B5 0F853400                 jne .process322
  8024                                  
  8025                                  ;-1303                 setsflag();
  8026                                  
  8027 000029B9 E862EC                   call setsflag
  8028                                  
  8029                                  ;-1304                 genCode2(0x68, sflag);
  8030                                  
  8031 000029BC A0[3A00]                 mov al, byte [sflag]
  8032 000029BF B400                     mov ah, 0
  8033 000029C1 50                       push ax
  8034 000029C2 6A68                     push 104
  8035 000029C4 E82BEA                   call genCode2
  8036 000029C7 83C404                   add  sp, 4
  8037                                  
  8038                                  ;-1305                 if (sflag) genCode8 (imme);
  8039                                  
  8040 000029CA A0[3A00]                 mov al, [sflag]
  8041 000029CD 08C0                     or  al, al
  8042 000029CF 0F840D00                 je .process323
  8043 000029D3 FF36[3F00]               push word [imme]
  8044 000029D7 E8B8E9                   call genCode8
  8045 000029DA 83C402                   add  sp, 2
  8046                                  
  8047                                  ;-1306                 else       genCode16(imme);
  8048                                  
  8049 000029DD E90A00                   jmp .process324
  8050                                  .process323:
  8051 000029E0 FF36[3F00]               push word [imme]
  8052 000029E4 E842EA                   call genCode16
  8053 000029E7 83C402                   add  sp, 2
  8054                                  
  8055                                  ;-1307                 return;
  8056                                  
  8057                                  .process324:
  8058 000029EA E96603                   jmp .retnprocess
  8059                                  
  8060                                  ;-1308             }
  8061                                  
  8062                                  
  8063                                  ;-1309             if (Op == ADR) {//push string ABSOLUTE i16 
  8064                                  
  8065                                  .process322:
  8066 000029ED A0[2D00]                 mov al, [Op]
  8067 000029F0 3C03                     cmp al, 3
  8068 000029F2 0F853E00                 jne .process325
  8069                                  
  8070                                  ;-1310 //prscomment("\n push disp: "); printhex16 (disp);
  8071                                  
  8072                                  
  8073                                  ;-1311                 if (disp) {
  8074                                  
  8075 000029F6 A1[3D00]                 mov ax, [disp]
  8076 000029F9 08C0                     or  al, al
  8077 000029FB 0F841800                 je .process326
  8078                                  
  8079                                  ;-1312                     genCode8(0x68);
  8080                                  
  8081 000029FF 6A68                     push 104
  8082 00002A01 E88EE9                   call genCode8
  8083 00002A04 83C402                   add  sp, 2
  8084                                  
  8085                                  ;-1313                     genCode16(disp);
  8086                                  
  8087 00002A07 FF36[3D00]               push word [disp]
  8088 00002A0B E81BEA                   call genCode16
  8089 00002A0E 83C402                   add  sp, 2
  8090                                  
  8091                                  ;-1314                     return;
  8092                                  
  8093 00002A11 E93F03                   jmp .retnprocess
  8094                                  
  8095                                  ;-1315                 }
  8096                                  
  8097                                  
  8098                                  ;-1316                 else {
  8099                                  
  8100 00002A14 E91D00                   jmp .process327
  8101                                  .process326:
  8102                                  
  8103                                  ;-1317                     genCode8(0x68);
  8104                                  
  8105 00002A17 6A68                     push 104
  8106 00002A19 E876E9                   call genCode8
  8107 00002A1C 83C402                   add  sp, 2
  8108                                  
  8109                                  ;-1318                     storeJmp();
  8110                                  
  8111 00002A1F E8DAF1                   call storeJmp
  8112                                  
  8113                                  ;-1319                     genCode16(0xAAAA);//magic for abs ADR
  8114                                  
  8115 00002A22 68AAAA                   push 43690
  8116 00002A25 E801EA                   call genCode16
  8117 00002A28 83C402                   add  sp, 2
  8118                                  
  8119                                  ;-1320                     PrintRA='A';
  8120                                  
  8121 00002A2B B84100                   mov ax, 65
  8122 00002A2E A2[4500]                 mov byte [PrintRA], al
  8123                                  
  8124                                  ;-1321                     return;
  8125                                  
  8126 00002A31 E91F03                   jmp .retnprocess
  8127                                  
  8128                                  ;-1322                 }
  8129                                  
  8130                                  
  8131                                  ;-1323             }
  8132                                  
  8133                                  .process327:
  8134                                  
  8135                                  ;-1324         }
  8136                                  
  8137                                  .process325:
  8138                                  
  8139                                  ;-1325         if (R1Type == SEGREG) {
  8140                                  
  8141                                  .process321:
  8142 00002A34 A0[3600]                 mov al, [R1Type]
  8143 00002A37 3C04                     cmp al, 4
  8144 00002A39 0F855A00                 jne .process328
  8145                                  
  8146                                  ;-1326             if (Code1 == 0x58) {//pop only
  8147                                  
  8148 00002A3D A0[3000]                 mov al, [Code1]
  8149 00002A40 3C58                     cmp al, 88
  8150 00002A42 0F851200                 jne .process329
  8151                                  
  8152                                  ;-1327                 if (R1No == 1) error1("pop cs not allowed");
  8153                                  
  8154 00002A46 A0[3400]                 mov al, [R1No]
  8155 00002A49 3C01                     cmp al, 1
  8156 00002A4B 0F850900                 jne .process330
  8157 00002A4F 68[552D]                 push process_0
  8158 00002A52 E8F5DF                   call error1
  8159 00002A55 83C402                   add  sp, 2
  8160                                  
  8161                                  ;-1328             }
  8162                                  
  8163                                  .process330:
  8164                                  
  8165                                  ;-1329             c = R1No <<3;
  8166                                  
  8167                                  .process329:
  8168 00002A58 A0[3400]                 mov al, [R1No]
  8169 00002A5B C0E003                   shl al, 3
  8170 00002A5E 8846FE                   mov [bp-2], al
  8171                                  
  8172                                  ;-1330             if (R1No > 3) {//FS, GS
  8173                                  
  8174 00002A61 A0[3400]                 mov al, [R1No]
  8175 00002A64 3C03                     cmp al, 3
  8176 00002A66 0F8E0C00                 jle .process331
  8177                                  
  8178                                  ;-1331                 c += 122;
  8179                                  
  8180 00002A6A 8046FE7A                 add  byte[bp-2], 122
  8181                                  
  8182                                  ;-1332                 genCode8(0x0F);
  8183                                  
  8184 00002A6E 6A0F                     push 15
  8185 00002A70 E81FE9                   call genCode8
  8186 00002A73 83C402                   add  sp, 2
  8187                                  
  8188                                  ;-1333             }
  8189                                  
  8190                                  
  8191                                  ;-1334             OpCodePtr++;
  8192                                  
  8193                                  .process331:
  8194 00002A76 FF06[4300]               inc  word[OpCodePtr]
  8195                                  
  8196                                  ;-1335             c = c + *OpCodePtr;////////////////is Code4
  8197                                  
  8198 00002A7A 8A46FE                   mov al, [bp-2]
  8199 00002A7D 8B1E[4300]               mov bx, [OpCodePtr]
  8200 00002A81 0207                     add al, [bx]
  8201 00002A83 B400                     mov ah, 0
  8202 00002A85 8846FE                   mov [bp-2], al
  8203                                  
  8204                                  ;-1336             genCode8(c);
  8205                                  
  8206 00002A88 8A46FE                   mov al, byte [bp-2]
  8207 00002A8B B400                     mov ah, 0
  8208 00002A8D 50                       push ax
  8209 00002A8E E801E9                   call genCode8
  8210 00002A91 83C402                   add  sp, 2
  8211                                  
  8212                                  ;-1337             return;
  8213                                  
  8214 00002A94 E9BC02                   jmp .retnprocess
  8215                                  
  8216                                  ;-1338         }
  8217                                  
  8218                                  
  8219                                  ;-1339         checkOpL();//no ADR, SEGREG
  8220                                  
  8221                                  .process328:
  8222 00002A97 E86AED                   call checkOpL
  8223                                  
  8224                                  ;-1340         if (R1Type == BYTE) reg16error();
  8225                                  
  8226 00002A9A A0[3600]                 mov al, [R1Type]
  8227 00002A9D 3C01                     cmp al, 1
  8228 00002A9F 0F850300                 jne .process332
  8229 00002AA3 E856E1                   call reg16error
  8230                                  
  8231                                  ;-1341         if (R1Type == WORD) {
  8232                                  
  8233                                  .process332:
  8234 00002AA6 A0[3600]                 mov al, [R1Type]
  8235 00002AA9 3C02                     cmp al, 2
  8236 00002AAB 0F851500                 jne .process333
  8237                                  
  8238                                  ;-1342             genCode2(Code1, R1No);
  8239                                  
  8240 00002AAF A0[3400]                 mov al, byte [R1No]
  8241 00002AB2 B400                     mov ah, 0
  8242 00002AB4 50                       push ax
  8243 00002AB5 A0[3000]                 mov al, byte [Code1]
  8244 00002AB8 B400                     mov ah, 0
  8245 00002ABA 50                       push ax
  8246 00002ABB E834E9                   call genCode2
  8247 00002ABE 83C404                   add  sp, 4
  8248                                  
  8249                                  ;-1343             return;
  8250                                  
  8251 00002AC1 E98F02                   jmp .retnprocess
  8252                                  
  8253                                  ;-1344         }
  8254                                  
  8255                                  
  8256                                  ;-1345         if (Op == MEM) {
  8257                                  
  8258                                  .process333:
  8259 00002AC4 A0[2D00]                 mov al, [Op]
  8260 00002AC7 3C04                     cmp al, 4
  8261 00002AC9 0F851B00                 jne .process334
  8262                                  
  8263                                  ;-1346             genCode8(Code2);
  8264                                  
  8265 00002ACD A0[3100]                 mov al, byte [Code2]
  8266 00002AD0 B400                     mov ah, 0
  8267 00002AD2 50                       push ax
  8268 00002AD3 E8BCE8                   call genCode8
  8269 00002AD6 83C402                   add  sp, 2
  8270                                  
  8271                                  ;-1347             writeEA(Code3);//////////////////Code3
  8272                                  
  8273 00002AD9 A0[3200]                 mov al, byte [Code3]
  8274 00002ADC B400                     mov ah, 0
  8275 00002ADE 50                       push ax
  8276 00002ADF E892E9                   call writeEA
  8277 00002AE2 83C402                   add  sp, 2
  8278                                  
  8279                                  ;-1348             return;
  8280                                  
  8281 00002AE5 E96B02                   jmp .retnprocess
  8282                                  
  8283                                  ;-1349         }
  8284                                  
  8285                                  
  8286                                  ;-1350         syntaxerror();
  8287                                  
  8288                                  .process334:
  8289 00002AE8 E860E1                   call syntaxerror
  8290                                  
  8291                                  ;-1351         return;
  8292                                  
  8293 00002AEB E96502                   jmp .retnprocess
  8294                                  
  8295                                  ;-1352     }
  8296                                  
  8297                                  
  8298                                  ;-1353 
  8299                                  
  8300                                  
  8301                                  ;-1354     if (CodeType == 11) {//shift, rotate
  8302                                  
  8303                                  .process320:
  8304 00002AEE A0[2F00]                 mov al, [CodeType]
  8305 00002AF1 3C0B                     cmp al, 11
  8306 00002AF3 0F859200                 jne .process335
  8307                                  
  8308                                  ;-1355         check2Ops();
  8309                                  
  8310 00002AF7 E8B6F0                   call check2Ops
  8311                                  
  8312                                  ;-1356         if (Op2 == IMM) {
  8313                                  
  8314 00002AFA A0[2E00]                 mov al, [Op2]
  8315 00002AFD 3C01                     cmp al, 1
  8316 00002AFF 0F854400                 jne .process336
  8317                                  
  8318                                  ;-1357             if (imme == 1) {
  8319                                  
  8320 00002B03 A1[3F00]                 mov ax, [imme]
  8321 00002B06 83F801                   cmp ax, 1
  8322 00002B09 0F851800                 jne .process337
  8323                                  
  8324                                  ;-1358                 genCodeW(0xD0);
  8325                                  
  8326 00002B0D 68D000                   push 208
  8327 00002B10 E8FAE8                   call genCodeW
  8328 00002B13 83C402                   add  sp, 2
  8329                                  
  8330                                  ;-1359                 writeEA(Code1);
  8331                                  
  8332 00002B16 A0[3000]                 mov al, byte [Code1]
  8333 00002B19 B400                     mov ah, 0
  8334 00002B1B 50                       push ax
  8335 00002B1C E855E9                   call writeEA
  8336 00002B1F 83C402                   add  sp, 2
  8337                                  
  8338                                  ;-1360                 return;
  8339                                  
  8340 00002B22 E92E02                   jmp .retnprocess
  8341                                  
  8342                                  ;-1361             }
  8343                                  
  8344                                  
  8345                                  ;-1362             genCodeW(0xC0);//80186
  8346                                  
  8347                                  .process337:
  8348 00002B25 68C000                   push 192
  8349 00002B28 E8E2E8                   call genCodeW
  8350 00002B2B 83C402                   add  sp, 2
  8351                                  
  8352                                  ;-1363             writeEA(Code1);
  8353                                  
  8354 00002B2E A0[3000]                 mov al, byte [Code1]
  8355 00002B31 B400                     mov ah, 0
  8356 00002B33 50                       push ax
  8357 00002B34 E83DE9                   call writeEA
  8358 00002B37 83C402                   add  sp, 2
  8359                                  
  8360                                  ;-1364             genCode8(imme);
  8361                                  
  8362 00002B3A FF36[3F00]               push word [imme]
  8363 00002B3E E851E8                   call genCode8
  8364 00002B41 83C402                   add  sp, 2
  8365                                  
  8366                                  ;-1365             return;
  8367                                  
  8368 00002B44 E90C02                   jmp .retnprocess
  8369                                  
  8370                                  ;-1366         }
  8371                                  
  8372                                  
  8373                                  ;-1367         if (Op2 == REG) {
  8374                                  
  8375                                  .process336:
  8376 00002B47 A0[2E00]                 mov al, [Op2]
  8377 00002B4A 3C02                     cmp al, 2
  8378 00002B4C 0F853900                 jne .process338
  8379                                  
  8380                                  ;-1368             if (R2Type == BYTE) {
  8381                                  
  8382 00002B50 A0[3500]                 mov al, [R2Type]
  8383 00002B53 3C01                     cmp al, 1
  8384 00002B55 0F853000                 jne .process339
  8385                                  
  8386                                  ;-1369                 if (R2No == 1) {//CL-REG
  8387                                  
  8388 00002B59 A0[3300]                 mov al, [R2No]
  8389 00002B5C 3C01                     cmp al, 1
  8390 00002B5E 0F852700                 jne .process340
  8391                                  
  8392                                  ;-1370                     if (R1Type == WORD) wflag=1;//hack
  8393                                  
  8394 00002B62 A0[3600]                 mov al, [R1Type]
  8395 00002B65 3C02                     cmp al, 2
  8396 00002B67 0F850600                 jne .process341
  8397 00002B6B B80100                   mov ax, 1
  8398 00002B6E A2[3800]                 mov byte [wflag], al
  8399                                  
  8400                                  ;-1371                     genCodeW(0xD2);
  8401                                  
  8402                                  .process341:
  8403 00002B71 68D200                   push 210
  8404 00002B74 E896E8                   call genCodeW
  8405 00002B77 83C402                   add  sp, 2
  8406                                  
  8407                                  ;-1372                     writeEA(Code1);
  8408                                  
  8409 00002B7A A0[3000]                 mov al, byte [Code1]
  8410 00002B7D B400                     mov ah, 0
  8411 00002B7F 50                       push ax
  8412 00002B80 E8F1E8                   call writeEA
  8413 00002B83 83C402                   add  sp, 2
  8414                                  
  8415                                  ;-1373                     return;
  8416                                  
  8417 00002B86 E9CA01                   jmp .retnprocess
  8418                                  
  8419                                  ;-1374                 }
  8420                                  
  8421                                  
  8422                                  ;-1375             }
  8423                                  
  8424                                  .process340:
  8425                                  
  8426                                  ;-1376         }
  8427                                  
  8428                                  .process339:
  8429                                  
  8430                                  ;-1377     }
  8431                                  
  8432                                  .process338:
  8433                                  
  8434                                  ;-1378 
  8435                                  
  8436                                  
  8437                                  ;-1379     if (CodeType == 12) {//int
  8438                                  
  8439                                  .process335:
  8440 00002B89 A0[2F00]                 mov al, [CodeType]
  8441 00002B8C 3C0C                     cmp al, 12
  8442 00002B8E 0F852200                 jne .process342
  8443                                  
  8444                                  ;-1380         if (TokeType == DIGIT) {
  8445                                  
  8446 00002B92 A0[2C00]                 mov al, [TokeType]
  8447 00002B95 3C01                     cmp al, 1
  8448 00002B97 0F851900                 jne .process343
  8449                                  
  8450                                  ;-1381             genCode8(Code1);
  8451                                  
  8452 00002B9B A0[3000]                 mov al, byte [Code1]
  8453 00002B9E B400                     mov ah, 0
  8454 00002BA0 50                       push ax
  8455 00002BA1 E8EEE7                   call genCode8
  8456 00002BA4 83C402                   add  sp, 2
  8457                                  
  8458                                  ;-1382             genCode8(SymbolInt);
  8459                                  
  8460 00002BA7 FF36[0E00]               push word [SymbolInt]
  8461 00002BAB E8E4E7                   call genCode8
  8462 00002BAE 83C402                   add  sp, 2
  8463                                  
  8464                                  ;-1383             return;
  8465                                  
  8466 00002BB1 E99F01                   jmp .retnprocess
  8467                                  
  8468                                  ;-1384         }
  8469                                  
  8470                                  
  8471                                  ;-1385     }
  8472                                  
  8473                                  .process343:
  8474                                  
  8475                                  ;-1386 
  8476                                  
  8477                                  
  8478                                  ;-1387     if (CodeType == 30) {//enter i18,i8
  8479                                  
  8480                                  .process342:
  8481 00002BB4 A0[2F00]                 mov al, [CodeType]
  8482 00002BB7 3C1E                     cmp al, 30
  8483 00002BB9 0F855200                 jne .process344
  8484                                  
  8485                                  ;-1388         genCode8(0xC8);
  8486                                  
  8487 00002BBD 68C800                   push 200
  8488 00002BC0 E8CFE7                   call genCode8
  8489 00002BC3 83C402                   add  sp, 2
  8490                                  
  8491                                  ;-1389         Op=getOp1();
  8492                                  
  8493 00002BC6 E811ED                   call getOp1
  8494 00002BC9 A2[2D00]                 mov byte [Op], al
  8495                                  
  8496                                  ;-1390         if (Op == IMM) genCode16(SymbolInt);
  8497                                  
  8498 00002BCC A0[2D00]                 mov al, [Op]
  8499 00002BCF 3C01                     cmp al, 1
  8500 00002BD1 0F850D00                 jne .process345
  8501 00002BD5 FF36[0E00]               push word [SymbolInt]
  8502 00002BD9 E84DE8                   call genCode16
  8503 00002BDC 83C402                   add  sp, 2
  8504                                  
  8505                                  ;-1391         else numbererror();
  8506                                  
  8507 00002BDF E90300                   jmp .process346
  8508                                  .process345:
  8509 00002BE2 E8D3DF                   call numbererror
  8510                                  
  8511                                  ;-1392         need(',');
  8512                                  
  8513                                  .process346:
  8514 00002BE5 6A2C                     push 44
  8515 00002BE7 E8B2EB                   call need
  8516 00002BEA 83C402                   add  sp, 2
  8517                                  
  8518                                  ;-1393         Op=getOp1();
  8519                                  
  8520 00002BED E8EAEC                   call getOp1
  8521 00002BF0 A2[2D00]                 mov byte [Op], al
  8522                                  
  8523                                  ;-1394         if (Op == IMM) genCode8 (SymbolInt);
  8524                                  
  8525 00002BF3 A0[2D00]                 mov al, [Op]
  8526 00002BF6 3C01                     cmp al, 1
  8527 00002BF8 0F850D00                 jne .process347
  8528 00002BFC FF36[0E00]               push word [SymbolInt]
  8529 00002C00 E88FE7                   call genCode8
  8530 00002C03 83C402                   add  sp, 2
  8531                                  
  8532                                  ;-1395         else numbererror();
  8533                                  
  8534 00002C06 E90300                   jmp .process348
  8535                                  .process347:
  8536 00002C09 E8ACDF                   call numbererror
  8537                                  
  8538                                  ;-1396         return;
  8539                                  
  8540                                  .process348:
  8541 00002C0C E94401                   jmp .retnprocess
  8542                                  
  8543                                  ;-1397     }
  8544                                  
  8545                                  
  8546                                  ;-1398 
  8547                                  
  8548                                  
  8549                                  ;-1399     if (CodeType==101) {//ORG nn
  8550                                  
  8551                                  .process344:
  8552 00002C0F A0[2F00]                 mov al, [CodeType]
  8553 00002C12 3C65                     cmp al, 101
  8554 00002C14 0F851500                 jne .process349
  8555                                  
  8556                                  ;-1400         if (TokeType != DIGIT) numbererror();
  8557                                  
  8558 00002C18 A0[2C00]                 mov al, [TokeType]
  8559 00002C1B 3C01                     cmp al, 1
  8560 00002C1D 0F840300                 je  .process350
  8561 00002C21 E894DF                   call numbererror
  8562                                  
  8563                                  ;-1401         Origin=SymbolInt;
  8564                                  
  8565                                  .process350:
  8566 00002C24 A1[0E00]                 mov ax, [SymbolInt]
  8567 00002C27 A3[2500]                 mov word [Origin], ax
  8568                                  
  8569                                  ;-1402         return;
  8570                                  
  8571 00002C2A E92601                   jmp .retnprocess
  8572                                  
  8573                                  ;-1403     }
  8574                                  
  8575                                  
  8576                                  ;-1404 
  8577                                  
  8578                                  
  8579                                  ;-1405     if (CodeType == 102) {//section, segment
  8580                                  
  8581                                  .process349:
  8582 00002C2D A0[2F00]                 mov al, [CodeType]
  8583 00002C30 3C66                     cmp al, 102
  8584 00002C32 0F850900                 jne .process351
  8585                                  
  8586                                  ;-1406         //getTokeType();//ignore .bss .text .data
  8587                                  
  8588                                  
  8589                                  ;-1407         AbsoluteLab=0;//nasm resets erevy time
  8590                                  
  8591 00002C36 B80000                   mov ax, 0
  8592 00002C39 A3[2700]                 mov word [AbsoluteLab], ax
  8593                                  
  8594                                  ;-1408         return;
  8595                                  
  8596 00002C3C E91401                   jmp .retnprocess
  8597                                  
  8598                                  ;-1409     }
  8599                                  
  8600                                  
  8601                                  ;-1410 
  8602                                  
  8603                                  
  8604                                  ;-1411     if (CodeType == 110) {//absolute
  8605                                  
  8606                                  .process351:
  8607 00002C3F A0[2F00]                 mov al, [CodeType]
  8608 00002C42 3C6E                     cmp al, 110
  8609 00002C44 0F851500                 jne .process352
  8610                                  
  8611                                  ;-1412         if (TokeType != DIGIT) numbererror();
  8612                                  
  8613 00002C48 A0[2C00]                 mov al, [TokeType]
  8614 00002C4B 3C01                     cmp al, 1
  8615 00002C4D 0F840300                 je  .process353
  8616 00002C51 E864DF                   call numbererror
  8617                                  
  8618                                  ;-1413         AbsoluteLab=SymbolInt;
  8619                                  
  8620                                  .process353:
  8621 00002C54 A1[0E00]                 mov ax, [SymbolInt]
  8622 00002C57 A3[2700]                 mov word [AbsoluteLab], ax
  8623                                  
  8624                                  ;-1414         return;
  8625                                  
  8626 00002C5A E9F600                   jmp .retnprocess
  8627                                  
  8628                                  ;-1415     }
  8629                                  
  8630                                  
  8631                                  ;-1416     if (CodeType == 111) {//name: PROC
  8632                                  
  8633                                  .process352:
  8634 00002C5D A0[2F00]                 mov al, [CodeType]
  8635 00002C60 3C6F                     cmp al, 111
  8636 00002C62 0F854A00                 jne .process354
  8637                                  
  8638                                  ;-1417         if (isInProc == 0)  {
  8639                                  
  8640 00002C66 A0[0D00]                 mov al, [isInProc]
  8641 00002C69 3C00                     cmp al, 0
  8642 00002C6B 0F853500                 jne .process355
  8643                                  
  8644                                  ;-1418             prs("\nentering: ");
  8645                                  
  8646 00002C6F 68[682D]                 push process_1
  8647 00002C72 E8BEDA                   call prs
  8648 00002C75 83C402                   add  sp, 2
  8649                                  
  8650                                  ;-1419             prs(ProcName);
  8651                                  
  8652 00002C78 8D066E75                 lea  ax, [ProcName]
  8653 00002C7C 50                       push ax
  8654 00002C7D E8B3DA                   call prs
  8655 00002C80 83C402                   add  sp, 2
  8656                                  
  8657                                  ;-1420             isInProc=1;
  8658                                  
  8659 00002C83 B80100                   mov ax, 1
  8660 00002C86 A2[0D00]                 mov byte [isInProc], al
  8661                                  
  8662                                  ;-1421             tmpLabelNamePtr = LabelNamePtr;
  8663                                  
  8664 00002C89 A1[4600]                 mov ax, [LabelNamePtr]
  8665 00002C8C A3[4800]                 mov word [tmpLabelNamePtr], ax
  8666                                  
  8667                                  ;-1422             tmpLabelMaxIx   = LabelMaxIx;
  8668                                  
  8669 00002C8F A1[4A00]                 mov ax, [LabelMaxIx]
  8670 00002C92 A3[4C00]                 mov word [tmpLabelMaxIx], ax
  8671                                  
  8672                                  ;-1423             tmpJmpNamePtr   = JmpNamePtr;
  8673                                  
  8674 00002C95 A1[5000]                 mov ax, [JmpNamePtr]
  8675 00002C98 A3[5200]                 mov word [tmpJmpNamePtr], ax
  8676                                  
  8677                                  ;-1424             tmpJmpMaxIx     = JmpMaxIx;
  8678                                  
  8679 00002C9B A1[5400]                 mov ax, [JmpMaxIx]
  8680 00002C9E A3[5600]                 mov word [tmpJmpMaxIx], ax
  8681                                  
  8682                                  ;-1425         } else error1("already in PROC");
  8683                                  
  8684 00002CA1 E90900                   jmp .process356
  8685                                  .process355:
  8686 00002CA4 68[752D]                 push process_2
  8687 00002CA7 E8A0DD                   call error1
  8688 00002CAA 83C402                   add  sp, 2
  8689                                  
  8690                                  ;-1426         return;
  8691                                  
  8692                                  .process356:
  8693 00002CAD E9A300                   jmp .retnprocess
  8694                                  
  8695                                  ;-1427     }
  8696                                  
  8697                                  
  8698                                  ;-1428     if (CodeType == 112) {//ENDP 
  8699                                  
  8700                                  .process354:
  8701 00002CB0 A0[2F00]                 mov al, [CodeType]
  8702 00002CB3 3C70                     cmp al, 112
  8703 00002CB5 0F858200                 jne .process357
  8704                                  
  8705                                  ;-1429         if (isInProc == 0) error1("not in PROC");
  8706                                  
  8707 00002CB9 A0[0D00]                 mov al, [isInProc]
  8708 00002CBC 3C00                     cmp al, 0
  8709 00002CBE 0F850900                 jne .process358
  8710 00002CC2 68[852D]                 push process_3
  8711 00002CC5 E882DD                   call error1
  8712 00002CC8 83C402                   add  sp, 2
  8713                                  
  8714                                  ;-1430         prs("\nleaving: ");
  8715                                  
  8716                                  .process358:
  8717 00002CCB 68[912D]                 push process_4
  8718 00002CCE E862DA                   call prs
  8719 00002CD1 83C402                   add  sp, 2
  8720                                  
  8721                                  ;-1431         prs(ProcName);
  8722                                  
  8723 00002CD4 8D066E75                 lea  ax, [ProcName]
  8724 00002CD8 50                       push ax
  8725 00002CD9 E857DA                   call prs
  8726 00002CDC 83C402                   add  sp, 2
  8727                                  
  8728                                  ;-1432         prs(", loc labels: ");
  8729                                  
  8730 00002CDF 68[9D2D]                 push process_5
  8731 00002CE2 E84EDA                   call prs
  8732 00002CE5 83C402                   add  sp, 2
  8733                                  
  8734                                  ;-1433         i = LabelMaxIx - tmpLabelMaxIx;
  8735                                  
  8736 00002CE8 A1[4A00]                 mov ax, [LabelMaxIx]
  8737 00002CEB 2B06[4C00]               sub ax, [tmpLabelMaxIx]
  8738 00002CEF 8946FC                   mov [bp-4], ax
  8739                                  
  8740                                  ;-1434         printIntU(i);
  8741                                  
  8742 00002CF2 FF76FC                   push word [bp-4]
  8743 00002CF5 E84BDB                   call printIntU
  8744 00002CF8 83C402                   add  sp, 2
  8745                                  
  8746                                  ;-1435         prs(", loc jmp forward: ");
  8747                                  
  8748 00002CFB 68[AC2D]                 push process_6
  8749 00002CFE E832DA                   call prs
  8750 00002D01 83C402                   add  sp, 2
  8751                                  
  8752                                  ;-1436         i = JmpMaxIx - tmpJmpMaxIx;
  8753                                  
  8754 00002D04 A1[5400]                 mov ax, [JmpMaxIx]
  8755 00002D07 2B06[5600]               sub ax, [tmpJmpMaxIx]
  8756 00002D0B 8946FC                   mov [bp-4], ax
  8757                                  
  8758                                  ;-1437         printIntU(i);        
  8759                                  
  8760 00002D0E FF76FC                   push word [bp-4]
  8761 00002D11 E82FDB                   call printIntU
  8762 00002D14 83C402                   add  sp, 2
  8763                                  
  8764                                  ;-1438         fixJmp();
  8765                                  
  8766 00002D17 E8DDF4                   call fixJmp
  8767                                  
  8768                                  ;-1439         isInProc=0;
  8769                                  
  8770 00002D1A B80000                   mov ax, 0
  8771 00002D1D A2[0D00]                 mov byte [isInProc], al
  8772                                  
  8773                                  ;-1440         LabelNamePtr = tmpLabelNamePtr;//delete local Labels
  8774                                  
  8775 00002D20 A1[4800]                 mov ax, [tmpLabelNamePtr]
  8776 00002D23 A3[4600]                 mov word [LabelNamePtr], ax
  8777                                  
  8778                                  ;-1441         LabelMaxIx   = tmpLabelMaxIx;                       
  8779                                  
  8780 00002D26 A1[4C00]                 mov ax, [tmpLabelMaxIx]
  8781 00002D29 A3[4A00]                 mov word [LabelMaxIx], ax
  8782                                  
  8783                                  ;-1442         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp
  8784                                  
  8785 00002D2C A1[5200]                 mov ax, [tmpJmpNamePtr]
  8786 00002D2F A3[5000]                 mov word [JmpNamePtr], ax
  8787                                  
  8788                                  ;-1443         JmpMaxIx     = tmpJmpMaxIx;
  8789                                  
  8790 00002D32 A1[5600]                 mov ax, [tmpJmpMaxIx]
  8791 00002D35 A3[5400]                 mov word [JmpMaxIx], ax
  8792                                  
  8793                                  ;-1444         return;
  8794                                  
  8795 00002D38 E91800                   jmp .retnprocess
  8796                                  
  8797                                  ;-1445     } 
  8798                                  
  8799                                  
  8800                                  ;-1446     if (CodeType == 200) {//db  
  8801                                  
  8802                                  .process357:
  8803 00002D3B A0[2F00]                 mov al, [CodeType]
  8804 00002D3E 3CC8                     cmp al, 200
  8805 00002D40 0F850600                 jne .process359
  8806                                  
  8807                                  ;-1447         genDB();
  8808                                  
  8809 00002D44 E8D8EF                   call genDB
  8810                                  
  8811                                  ;-1448         return;
  8812                                  
  8813 00002D47 E90900                   jmp .retnprocess
  8814                                  
  8815                                  ;-1449     }
  8816                                  
  8817                                  
  8818                                  ;-1450     
  8819                                  
  8820                                  
  8821                                  ;-1451     error1("Command not implemented or syntax error");
  8822                                  
  8823                                  .process359:
  8824 00002D4A 68[C02D]                 push process_7
  8825 00002D4D E8FADC                   call error1
  8826 00002D50 83C402                   add  sp, 2
  8827                                  
  8828                                  ;-1452 }
  8829                                  
  8830                                  
  8831                                  ;-1453 
  8832                                  
  8833                                  
  8834                                  ;-1454 int parse() {
  8835                                  
  8836 00002D53 C9                       .retnprocess: LEAVE
  8837 00002D54 C3                       ret
  8838 00002D55 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8839 00002D5E 7420616C6C6F776564-
  8840 00002D67 00                 
  8841 00002D68 5C6E656E746572696E-     process_1 db "\nentering: ",0
  8842 00002D71 673A2000           
  8843 00002D75 616C72656164792069-     process_2 db "already in PROC",0
  8844 00002D7E 6E2050524F4300     
  8845 00002D85 6E6F7420696E205052-     process_3 db "not in PROC",0
  8846 00002D8E 4F4300             
  8847 00002D91 5C6E6C656176696E67-     process_4 db "\nleaving: ",0
  8848 00002D9A 3A2000             
  8849 00002D9D 2C206C6F63206C6162-     process_5 db ", loc labels: ",0
  8850 00002DA6 656C733A2000       
  8851 00002DAC 2C206C6F63206A6D70-     process_6 db ", loc jmp forward: ",0
  8852 00002DB5 20666F72776172643A-
  8853 00002DBE 2000               
  8854 00002DC0 436F6D6D616E64206E-     process_7 db "Command not implemented or syntax error",0
  8855 00002DC9 6F7420696D706C656D-
  8856 00002DD2 656E746564206F7220-
  8857 00002DDB 73796E746178206572-
  8858 00002DE4 726F7200           
  8859                                  ENDP
  8860                                  
  8861                                  parse: PROC
  8862                                  
  8863                                  ;-1455     LabelNamePtr  = &LabelNames;
  8864                                  
  8865 00002DE8 B85A77                   mov ax, LabelNames
  8866 00002DEB A3[4600]                 mov word [LabelNamePtr], ax
  8867                                  
  8868                                  ;-1456     JmpNamePtr= &JmpNames;
  8869                                  
  8870 00002DEE B87A93                   mov ax, JmpNames
  8871 00002DF1 A3[5000]                 mov word [JmpNamePtr], ax
  8872                                  
  8873                                  ;-1457     LabelMaxIx=0;
  8874                                  
  8875 00002DF4 B80000                   mov ax, 0
  8876 00002DF7 A3[4A00]                 mov word [LabelMaxIx], ax
  8877                                  
  8878                                  ;-1458     JmpMaxIx=0;
  8879                                  
  8880 00002DFA B80000                   mov ax, 0
  8881 00002DFD A3[5400]                 mov word [JmpMaxIx], ax
  8882                                  
  8883                                  ;-1459     BinLen=0;
  8884                                  
  8885 00002E00 B80000                   mov ax, 0
  8886 00002E03 A3[5800]                 mov word [BinLen], ax
  8887                                  
  8888                                  ;-1460     isInProc=0;
  8889                                  
  8890 00002E06 B80000                   mov ax, 0
  8891 00002E09 A2[0D00]                 mov byte [isInProc], al
  8892                                  
  8893                                  ;-1461 
  8894                                  
  8895                                  
  8896                                  ;-1462     do {//process a new line
  8897                                  
  8898                                  .parse360:
  8899                                  
  8900                                  ;-1463         PCStart=PC;
  8901                                  
  8902 00002E0C A1[2300]                 mov ax, [PC]
  8903 00002E0F A3[2900]                 mov word [PCStart], ax
  8904                                  
  8905                                  ;-1464         OpSize=0;
  8906                                  
  8907 00002E12 B80000                   mov ax, 0
  8908 00002E15 A2[3700]                 mov byte [OpSize], al
  8909                                  
  8910                                  ;-1465         OpPrintIndex=0;
  8911                                  
  8912 00002E18 B80000                   mov ax, 0
  8913 00002E1B A3[4100]                 mov word [OpPrintIndex], ax
  8914                                  
  8915                                  ;-1466         PrintRA=' ';
  8916                                  
  8917 00002E1E B82000                   mov ax, 32
  8918 00002E21 A2[4500]                 mov byte [PrintRA], al
  8919                                  
  8920                                  ;-1467         getLine();
  8921                                  
  8922 00002E24 E803DF                   call getLine
  8923                                  
  8924                                  ;-1468         InputPtr = &InputBuf;
  8925                                  
  8926 00002E27 B88D75                   mov ax, InputBuf
  8927 00002E2A A3[1400]                 mov word [InputPtr], ax
  8928                                  
  8929                                  ;-1469         getTokeType();//getCode in SymbolUpper,
  8930                                  
  8931 00002E2D E8B8E8                   call getTokeType
  8932                                  
  8933                                  ;-1470                       //set TokeType,isLabel by getName
  8934                                  
  8935                                  
  8936                                  ;-1471         if (TokeType == ALNUME) {
  8937                                  
  8938 00002E30 A0[2C00]                 mov al, [TokeType]
  8939 00002E33 3C03                     cmp al, 3
  8940 00002E35 0F852C00                 jne .parse361
  8941                                  
  8942                                  ;-1472             if (isLabel) {//set in getName
  8943                                  
  8944 00002E39 A0[2B00]                 mov al, [isLabel]
  8945 00002E3C 08C0                     or  al, al
  8946 00002E3E 0F842300                 je .parse362
  8947                                  
  8948                                  ;-1473               if (isInProc == 0)  strcpy(ProcName, Symbol);
  8949                                  
  8950 00002E42 A0[0D00]                 mov al, [isInProc]
  8951 00002E45 3C00                     cmp al, 0
  8952 00002E47 0F851000                 jne .parse363
  8953 00002E4B 8D063075                 lea  ax, [Symbol]
  8954 00002E4F 50                       push ax
  8955 00002E50 8D066E75                 lea  ax, [ProcName]
  8956 00002E54 50                       push ax
  8957 00002E55 E8D2D3                   call strcpy
  8958 00002E58 83C404                   add  sp, 4
  8959                                  
  8960                                  ;-1474                 storeLabel();
  8961                                  
  8962                                  .parse363:
  8963 00002E5B E81AEE                   call storeLabel
  8964                                  
  8965                                  ;-1475                 InputPtr++;//remove :
  8966                                  
  8967 00002E5E FF06[1400]               inc  word[InputPtr]
  8968                                  
  8969                                  ;-1476                 getTokeType();
  8970                                  
  8971 00002E62 E883E8                   call getTokeType
  8972                                  
  8973                                  ;-1477             }
  8974                                  
  8975                                  
  8976                                  ;-1478         }
  8977                                  
  8978                                  .parse362:
  8979                                  
  8980                                  ;-1479         if (TokeType == ALNUME) {
  8981                                  
  8982                                  .parse361:
  8983 00002E65 A0[2C00]                 mov al, [TokeType]
  8984 00002E68 3C03                     cmp al, 3
  8985 00002E6A 0F851B00                 jne .parse364
  8986                                  
  8987                                  ;-1480             lookCode();// and OpCodePtr
  8988                                  
  8989 00002E6E E8AAE4                   call lookCode
  8990                                  
  8991                                  ;-1481             if(CodeType) process();
  8992                                  
  8993 00002E71 A0[2F00]                 mov al, [CodeType]
  8994 00002E74 08C0                     or  al, al
  8995 00002E76 0F840600                 je .parse365
  8996 00002E7A E893F5                   call process
  8997                                  
  8998                                  ;-1482             else getVariable();
  8999                                  
  9000 00002E7D E90300                   jmp .parse366
  9001                                  .parse365:
  9002 00002E80 E821EF                   call getVariable
  9003                                  
  9004                                  ;-1483             skipRest();
  9005                                  
  9006                                  .parse366:
  9007 00002E83 E855E9                   call skipRest
  9008                                  
  9009                                  ;-1484         }
  9010                                  
  9011                                  
  9012                                  ;-1485         else if (TokeType >ALNUME) error1("Label or instruction expected");
  9013                                  
  9014 00002E86 E92700                   jmp .parse367
  9015                                  .parse364:
  9016 00002E89 A0[2C00]                 mov al, [TokeType]
  9017 00002E8C 3C03                     cmp al, 3
  9018 00002E8E 0F8E0C00                 jle .parse368
  9019 00002E92 68[C12E]                 push parse_0
  9020 00002E95 E8B2DB                   call error1
  9021 00002E98 83C402                   add  sp, 2
  9022                                  
  9023                                  ;-1486         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  9024                                  
  9025 00002E9B E91200                   jmp .parse369
  9026                                  .parse368:
  9027 00002E9E A0[2C00]                 mov al, [TokeType]
  9028 00002EA1 3C01                     cmp al, 1
  9029 00002EA3 0F850900                 jne .parse370
  9030 00002EA7 68[DF2E]                 push parse_1
  9031 00002EAA E89DDB                   call error1
  9032 00002EAD 83C402                   add  sp, 2
  9033                                  
  9034                                  ;-1487         printLine();
  9035                                  
  9036                                  .parse370:
  9037                                  .parse369:
  9038                                  .parse367:
  9039 00002EB0 E8D2D9                   call printLine
  9040                                  
  9041                                  ;-1488     } while (DOS_NoBytes != 0 );
  9042                                  
  9043 00002EB3 A1[2000]                 mov ax, [DOS_NoBytes]
  9044 00002EB6 83F800                   cmp ax, 0
  9045 00002EB9 0F840300                 je  .parse371
  9046 00002EBD E94CFF                   jmp .parse360
  9047                                  .parse371:
  9048                                  
  9049                                  ;-1489 }
  9050                                  
  9051                                  
  9052                                  ;-1490 
  9053                                  
  9054                                  
  9055                                  ;-1491 int main() {
  9056                                  
  9057 00002EC0 C3                       ret
  9058 00002EC1 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  9059 00002ECA 696E73747275637469-
  9060 00002ED3 6F6E20657870656374-
  9061 00002EDC 656400             
  9062 00002EDF 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  9063 00002EE8 616C6C6F7765642061-
  9064 00002EF1 74207374617274206F-
  9065 00002EFA 66206C696E6500     
  9066                                  ENDP
  9067                                  
  9068                                  main: PROC
  9069                                  
  9070                                  ;-1492     getarg();
  9071                                  
  9072 00002F01 E8B0F0                   call getarg
  9073                                  
  9074                                  ;-1493     parse();
  9075                                  
  9076 00002F04 E8E1FE                   call parse
  9077                                  
  9078                                  ;-1494     fixJmpMain();
  9079                                  
  9080 00002F07 E8ACF3                   call fixJmpMain
  9081                                  
  9082                                  ;-1495     epilog();
  9083                                  
  9084 00002F0A E821DA                   call epilog
  9085                                  
  9086                                  ;-1496     end1();
  9087                                  
  9088 00002F0D E80DDB                   call end1
  9089                                  
  9090                                  ;-1497 }
  9091                                  
  9092 00002F10 C3                       ret
  9093                                  ENDP
  9094                                   
  9095                                  ; missing functions: 
  9096                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  9097 00002F11 E80000                  LastFunctionByt:db 0E8h, 0, 0
  9098 00002F14 58                      pop ax
  9099 00002F15 C3                      ret
  9100                                   
  9101                                  ;   # type sign width  adr used name   list of global variables
  9102                                  
  9103                                  ;    1 arr sign byte     1    2 Version1[9]
  9104                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  9105                                  ;    3 arr sign byte     4   14 Symbol[31]
  9106                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  9107                                  ;    5 arr sign byte     6    3 ProcName[31]
  9108                                  ;    6 var sign byte     7    6 isInProc
  9109                                  ;    7 var unsg word     8   25 SymbolInt
  9110                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  9111                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  9112                                  ;   10 arr sign byte    11    4 InputBuf[255]
  9113                                  ;   11 ptr unsg byte    12   28 InputPtr
  9114                                  ;   12 arr sign byte    13    5 namein[67]
  9115                                  ;   13 arr sign byte    14    6 namelst[67]
  9116                                  ;   14 arr sign byte    15    6 namebin[67]
  9117                                  ;   15 var sign word    16    4 asm_fd
  9118                                  ;   16 var sign word    17    3 lst_fd
  9119                                  ;   17 var sign word    18    3 bin_fd
  9120                                  ;   18 var sign word    19    6 DOS_ERR
  9121                                  ;   19 var sign word    20    5 ErrorCount
  9122                                  ;   20 var sign word    21    4 DOS_NoBytes
  9123                                  ;   21 var sign byte    22    5 DOS_ByteRead
  9124                                  ;   22 var unsg word    24    8 PC
  9125                                  ;   23 var unsg word    25    6 Origin
  9126                                  ;   24 var unsg word    26    6 AbsoluteLab
  9127                                  ;   25 var unsg word    27    2 PCStart
  9128                                  ;   26 var sign byte    28    3 isLabel
  9129                                  ;   27 def unsg byte    29    - DIGIT=1
  9130                                  ;   28 def unsg byte    30    - LETTERE=2
  9131                                  ;   29 def unsg byte    31    - ALNUME=3
  9132                                  ;   30 def unsg byte    32    - NOALNUME=4
  9133                                  ;   31 var sign byte    33   28 TokeType
  9134                                  ;   32 def unsg byte    34    - BYTE=1
  9135                                  ;   33 def unsg byte    35    - WORD=2
  9136                                  ;   34 def unsg byte    36    - DWORD=3
  9137                                  ;   35 def unsg byte    37    - SEGREG=4
  9138                                  ;   36 def unsg byte    38    - IMM=1
  9139                                  ;   37 def unsg byte    39    - REG=2
  9140                                  ;   38 def unsg byte    40    - ADR=3
  9141                                  ;   39 def unsg byte    41    - MEM=4
  9142                                  ;   40 var sign byte    42   29 Op
  9143                                  ;   41 var sign byte    43   31 Op2
  9144                                  ;   42 var sign byte    44   30 CodeType
  9145                                  ;   43 var sign byte    45   23 Code1
  9146                                  ;   44 var sign byte    46    7 Code2
  9147                                  ;   45 var sign byte    47    3 Code3
  9148                                  ;   46 var sign byte    48   19 R2No
  9149                                  ;   47 var sign byte    49   16 R1No
  9150                                  ;   48 var sign byte    50   18 R2Type
  9151                                  ;   49 var sign byte    51   15 R1Type
  9152                                  ;   50 var sign byte    52   14 OpSize
  9153                                  ;   51 var sign byte    53    9 wflag
  9154                                  ;   52 var sign byte    54    3 dflag
  9155                                  ;   53 var sign byte    55    8 sflag
  9156                                  ;   54 var sign byte    56   15 rm
  9157                                  ;   55 var sign byte    57    5 isDirect
  9158                                  ;   56 var sign word    58   67 disp
  9159                                  ;   57 var unsg word    59   13 imme
  9160                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  9161                                  ;   59 arr sign byte    62    2 OpPos[5]
  9162                                  ;   60 var sign word    63    6 OpPrintIndex
  9163                                  ;   61 ptr sign byte    64   19 OpCodePtr
  9164                                  ;   62 var sign byte    65    5 PrintRA
  9165                                  ;   63 def unsg byte    67    - LABELNAMESMAX=5969
  9166                                  ;   64 arr sign byte    68    3 LabelNames[6000]
  9167                                  ;   65 ptr sign byte    69    7 LabelNamePtr
  9168                                  ;   66 ptr sign byte    70    2 tmpLabelNamePtr
  9169                                  ;   67 def unsg byte    72    - LABELADRMAX=600
  9170                                  ;   68 arr unsg word    73    8 LabelAddr[600]
  9171                                  ;   69 var sign word    74   10 LabelMaxIx
  9172                                  ;   70 var sign word    75    3 tmpLabelMaxIx
  9173                                  ;   71 var sign word    76   11 LabelIx
  9174                                  ;   72 def unsg byte    78    - JMPNAMESMAX=3969
  9175                                  ;   73 arr sign byte    79    3 JmpNames[4000]
  9176                                  ;   74 ptr sign byte    80    7 JmpNamePtr
  9177                                  ;   75 ptr sign byte    81    2 tmpJmpNamePtr
  9178                                  ;   76 def unsg byte    83    - JMPMAX=200
  9179                                  ;   77 arr unsg word    84    2 JmpAddr[200]
  9180                                  ;   78 var sign word    85   10 JmpMaxIx
  9181                                  ;   79 var sign word    86    3 tmpJmpMaxIx
  9182                                  ;   80 def unsg byte    88    - FILEBINMAX=17000
  9183                                  ;   81 arr sign byte    89    8 FileBin[17000]
  9184                                  ;   82 var unsg word    90    6 BinLen
  9185                                  ;   83 ptr sign byte    92    1 arglen
  9186                                  ;   84 ptr sign byte    93    4 argv
  9187                                  ;   85 var sign byte   451    1 I_START
  9188                                  ;   86 arr sign byte   454 NULL I_PUSHA[8125]
  9189                                  ;   87 arr sign byte   455 NULL I_NOP[24260]
  9190                                  ;   88 arr sign byte   456 NULL I_CWDE[9734]
  9191                                  ;   89 arr sign byte   457 NULL I_CDQ[1931]
  9192                                  ;   90 arr sign byte   458 NULL I_PUSHF[35622]
  9193                                  ;   91 arr sign byte   459 NULL I_SAHF[599]
  9194                                  ;   92 arr sign byte   460 NULL I_MOVSB[53495]
  9195                                  ;   93 arr sign byte   461 NULL I_CMPSB[54007]
  9196                                  ;   94 arr sign byte   462 NULL I_STOSB[37]
  9197                                  ;   95 arr sign byte   463 NULL I_LODSB[33600]
  9198                                  ;   96 arr sign byte   464 NULL I_SCASB[8418]
  9199                                  ;   97 arr sign byte   465 NULL I_LEAVE[53259]
  9200                                  ;   98 arr sign byte   466 NULL I_INTO[12917]
  9201                                  ;   99 arr sign byte   467 NULL I_XLAT[35622]
  9202                                  ;  100 arr sign byte   468 NULL I_REPNE[2119]
  9203                                  ;  101 arr sign byte   469 NULL I_REPE[18057]
  9204                                  ;  102 arr sign byte   470 NULL I_HLT[9982]
  9205                                  ;  103 arr sign byte   471 NULL I_STC[18315]
  9206                                  ;  104 arr sign byte   472 NULL I_STI[9734]
  9207                                  ;  105 arr sign byte   473 NULL I_STD[32643]
  9208                                  ;  106 arr sign byte   475 NULL I_INC[10]
  9209                                  ;  107 arr sign byte   476 NULL I_DEC[1397]
  9210                                  ;  108 arr sign byte   477 NULL I_NOT[18119]
  9211                                  ;  109 arr sign byte   478 NULL I_NEG[65534]
  9212                                  ;  110 arr sign byte   479 NULL I_MUL[33791]
  9213                                  ;  111 arr sign byte   480 NULL I_IMUL[65150]
  9214                                  ;  112 arr sign byte   481 NULL I_DIV[30207]
  9215                                  ;  113 arr sign byte   482 NULL I_IDIV[15642]
  9216                                  ;  114 arr sign byte   484 NULL I_LES[65535]
  9217                                  ;  115 arr sign byte   485 NULL I_LDS[5493]
  9218                                  ;  116 arr sign byte   486 NULL I_LEA[33574]
  9219                                  ;  117 arr sign byte   487 NULL I_LSS[1151]
  9220                                  ;  118 arr sign byte   488 NULL I_LFS[29696]
  9221                                  ;  119 arr sign byte   489 NULL I_LGS[35593]
  9222                                  ;  120 arr sign byte   491 NULL I_ADD[2630]
  9223                                  ;  121 arr sign byte   492 NULL I_OR[14630]
  9224                                  ;  122 arr sign byte   493 NULL I_ADC[1095]
  9225                                  ;  123 arr sign byte   494 NULL I_SBB[26997]
  9226                                  ;  124 arr sign byte   495 NULL I_AND[49203]
  9227                                  ;  125 arr sign byte   496 NULL I_SUB[52169]
  9228                                  ;  126 arr sign byte   497 NULL I_XOR[33680]
  9229                                  ;  127 arr sign byte   498 NULL I_CMP[65150]
  9230                                  ;  128 arr sign byte   499 NULL I_TEST[29729]
  9231                                  ;  129 arr sign byte   501 NULL I_MOV[33618]
  9232                                  ;  130 arr sign byte   502 NULL I_MOVSX[65150]
  9233                                  ;  131 arr sign byte   503 NULL I_MOVZX[29731]
  9234                                  ;  132 arr sign byte   505 NULL I_JO[33612]
  9235                                  ;  133 arr sign byte   506 NULL I_JNO[65150]
  9236                                  ;  134 arr sign byte   507 NULL I_JB[29732]
  9237                                  ;  135 arr sign byte   508 NULL I_JNB[33606]
  9238                                  ;  136 arr sign byte   509 NULL I_JAE[65150]
  9239                                  ;  137 arr sign byte   510 NULL I_JE[29734]
  9240                                  ;  138 arr sign byte   511 NULL I_JNE[33600]
  9241                                  ;  139 arr sign byte   512 NULL I_JBE[65150]
  9242                                  ;  140 arr sign byte   513 NULL I_JA[29730]
  9243                                  ;  141 arr sign byte   514 NULL I_JS[33594]
  9244                                  ;  142 arr sign byte   515 NULL I_JNS[65150]
  9245                                  ;  143 arr sign byte   516 NULL I_JP[29737]
  9246                                  ;  144 arr sign byte   517 NULL I_JNP[33588]
  9247                                  ;  145 arr sign byte   518 NULL I_JL[65150]
  9248                                  ;  146 arr sign byte   519 NULL I_JNL[29736]
  9249                                  ;  147 arr sign byte   520 NULL I_JLE[33582]
  9250                                  ;  148 arr sign byte   521 NULL I_JG[65150]
  9251                                  ;  149 arr sign byte   523 NULL I_JMP[29733]
  9252                                  ;  150 arr sign byte   524 NULL I_CALL[15656]
  9253                                  ;  151 arr sign byte   526 NULL I_RET[33]
  9254                                  ;  152 arr sign byte   527 NULL I_RETF[9076]
  9255                                  ;  153 arr sign byte   529 NULL I_PUSH[9021]
  9256                                  ;  154 arr sign byte   530 NULL I_POP[29696]
  9257                                  ;  155 arr sign byte   532 NULL I_ROL[15646]
  9258                                  ;  156 arr sign byte   533 NULL I_RCL[36]
  9259                                  ;  157 arr sign byte   534 NULL I_SHL[6516]
  9260                                  ;  158 arr sign byte   535 NULL I_SHR[9789]
  9261                                  ;  159 arr sign byte   537 NULL I_INT[29696]
  9262                                  ;  160 arr sign byte   539 NULL I_IN[15636]
  9263                                  ;  161 arr sign byte   540 NULL I_INSB[34]
  9264                                  ;  162 arr sign byte   541 NULL I_INSW[3956]
  9265                                  ;  163 arr sign byte   542 NULL I_INSD[10557]
  9266                                  ;  164 arr sign byte   543 NULL I_OUT[29696]
  9267                                  ;  165 arr sign byte   544 NULL I_OUTSB[15626]
  9268                                  ;  166 arr sign byte   545 NULL I_OUTSW[40]
  9269                                  ;  167 arr sign byte   546 NULL I_OUTSD[1396]
  9270                                  ;  168 arr sign byte   548 NULL I_XCHG[9533]
  9271                                  ;  169 arr sign byte   550 NULL I_LOOPNZ[29952]
  9272                                  ;  170 arr sign byte   551 NULL I_LOOPNE[33542]
  9273                                  ;  171 arr sign byte   552 NULL I_LOOPZ[2686]
  9274                                  ;  172 arr sign byte   553 NULL I_LOOPE[60176]
  9275                                  ;  173 arr sign byte   554 NULL I_LOOP[33540]
  9276                                  ;  174 arr sign byte   555 NULL I_JCXZ[2686]
  9277                                  ;  175 arr sign byte   556 NULL I_JECXZ[29984]
  9278                                  ;  176 arr sign byte   558 NULL I_ENTER[47255]
  9279                                  ;  177 arr sign byte   560 NULL I_ORG[1]
  9280                                  ;  178 arr sign byte   562 NULL I_SECTION[52169]
  9281                                  ;  179 arr sign byte   563 NULL I_SEGMENT[21904]
  9282                                  ;  180 arr sign byte   564 NULL I_ABSOLUTE[60555]
  9283                                  ;  181 arr sign byte   565 NULL I_PROC[5816]
  9284                                  ;  182 arr sign byte   566 NULL I_ENDP[39424]
  9285                                  ;  183 arr sign byte   567 NULL I_DB[674]
  9286                                  ;  184 arr sign byte   568 NULL I_DW[8125]
  9287                                  ;  185 arr sign byte   569 NULL I_DD[51030]
  9288                                  ;  186 arr sign byte   570 NULL I_RESB[65094]
  9289                                  ;  187 arr sign byte   571 NULL I_RESW[0]
  9290                                  ;  188 arr sign byte   572 NULL I_RESD[1678]
  9291                                  ;  189 var sign byte   573 NULL I_END
  9292                                  
  9293                                  
  9294                                  ;   # Calls Line Width  Name   list of functions
  9295                                  
  9296                                  ;    0    4   97   writetty
  9297                                  ;    1    1   98   putch
  9298                                  ;    2    8   99   cputs
  9299                                  ;    3    6  101   DosInt
  9300                                  ;    4    1  106   openR
  9301                                  ;    5    2  107   creatR
  9302                                  ;    6    3  108   fcloseR
  9303                                  ;    7    5  109   exitR
  9304                                  ;    8    2  110   readRL
  9305                                  ;    9    2  112   fputcR
  9306                                  ;   10    2  115   letterE
  9307                                  ;   11    3  125   digit
  9308                                  ;   12    1  130   alnumE
  9309                                  ;   13    4  135   strlen
  9310                                  ;   14   10  140   strcpy
  9311                                  ;   15   35  146   eqstr
  9312                                  ;   16    3  155   strcat1
  9313                                  ;   17    2  159   toupper
  9314                                  ;   18    1  166   testReg
  9315                                  ;   19    7  209   prc
  9316                                  ;   20    1  219   prscomment
  9317                                  ;   21   38  227   prs
  9318                                  ;   22    2  249   printhex4
  9319                                  ;   23    3  254   printhex8a
  9320                                  ;   24    3  259   printhex16
  9321                                  ;   25    7  264   printIntU
  9322                                  ;   26    1  274   printLine
  9323                                  ;   27    2  297   epilog
  9324                                  ;   28    2  345   end1
  9325                                  ;   29   27  353   error1
  9326                                  ;   30   13  360   errorexit
  9327                                  ;   31    4  365   notfounderror
  9328                                  ;   32 NULL  371   allowederror
  9329                                  ;   33    3  372   addrerror
  9330                                  ;   34    1  373   immeerror
  9331                                  ;   35    2  374   implerror
  9332                                  ;   36    4  375   indexerror
  9333                                  ;   37    3  376   invaloperror
  9334                                  ;   38    6  377   numbererror
  9335                                  ;   39    1  378   regmemerror
  9336                                  ;   40    3  379   reg16error
  9337                                  ;   41    1  380   segregerror
  9338                                  ;   42    5  381   syntaxerror
  9339                                  ;   43 NULL  383   addrexit
  9340                                  ;   44    3  384   dataexit
  9341                                  ;   45 NULL  385   internexit
  9342                                  ;   46    1  387   ifEOL
  9343                                  ;   47    1  396   getLine
  9344                                  ;   48    4  412   skipBlank
  9345                                  ;   49    1  418   getDigit
  9346                                  ;   50    1  430   getName
  9347                                  ;   51    2  575   lookCode
  9348                                  ;   52   37  591   genCode8
  9349                                  ;   53    1  602   gen66h
  9350                                  ;   54    8  604   genCode2
  9351                                  ;   55   13  608   genCodeW
  9352                                  ;   56   19  612   genCode16
  9353                                  ;   57    1  616   genCode32
  9354                                  ;   58   13  620   writeEA
  9355                                  ;   59    4  662   genImmediate
  9356                                  ;   60    2  669   setwflag
  9357                                  ;   61    2  680   setsflag
  9358                                  ;   62    2  690   checkConstSize
  9359                                  ;   63    2  697   ChangeDirection
  9360                                  ;   64   17  705   getTokeType
  9361                                  ;   65   11  716   isToken
  9362                                  ;   66    2  726   need
  9363                                  ;   67    1  735   skipRest
  9364                                  ;   68    2  741   checkOpL
  9365                                  ;   69    6  750   searchLabel
  9366                                  ;   70    4  763   getOp1
  9367                                  ;   71    1  778   getIndReg1
  9368                                  ;   72    1  786   getIndReg2
  9369                                  ;   73    1  795   getMEM
  9370                                  ;   74    2  822   getOpR
  9371                                  ;   75    3  835   getOpL
  9372                                  ;   76    1  842   get2Ops
  9373                                  ;   77    4  847   check2Ops
  9374                                  ;   78    3  857   storeJmp
  9375                                  ;   79    2  868   storeLabel
  9376                                  ;   80    1  881   genDB
  9377                                  ;   81    1  902   getVariable
  9378                                  ;   82    1  955   getCodeSize
  9379                                  ;   83    1  965   getarg
  9380                                  ;   84    1  999   fixJmp
  9381                                  ;   85    1 1032   fixJmpMain
  9382                                  ;   86    1 1058   getCodes
  9383                                  ;   87    1 1064   process
  9384                                  ;   88    1 1454   parse
  9385                                  ;   89 NULL 1491   main
  9386                                  ;   90 NULL 1497   LastFunctionByt
  9387                                  
  9388                                  ;    #  addr name   list of CALLs
  9389                                  
  9390                                  ;    0     0 writetty
  9391                                  ;    1     9 writetty
  9392                                  ;    2    18 putch
  9393                                  ;    3    24 DosInt
  9394                                  ;    4    31 DosInt
  9395                                  ;    5    38 DosInt
  9396                                  ;    6    45 DosInt
  9397                                  ;    7    52 DosInt
  9398                                  ;    8    59 DosInt
  9399                                  ;    9    66 digit
  9400                                  ;   10    72 letterE
  9401                                  ;   11    80 strcpy
  9402                                  ;   12    87 strlen
  9403                                  ;   13    94 strlen
  9404                                  ;   14   101 eqstr
  9405                                  ;   15   107 eqstr
  9406                                  ;   16   113 eqstr
  9407                                  ;   17   119 eqstr
  9408                                  ;   18   125 eqstr
  9409                                  ;   19   131 eqstr
  9410                                  ;   20   137 eqstr
  9411                                  ;   21   143 eqstr
  9412                                  ;   22   149 eqstr
  9413                                  ;   23   155 eqstr
  9414                                  ;   24   161 eqstr
  9415                                  ;   25   167 eqstr
  9416                                  ;   26   173 eqstr
  9417                                  ;   27   179 eqstr
  9418                                  ;   28   185 eqstr
  9419                                  ;   29   191 eqstr
  9420                                  ;   30   197 eqstr
  9421                                  ;   31   203 eqstr
  9422                                  ;   32   209 eqstr
  9423                                  ;   33   215 eqstr
  9424                                  ;   34   221 eqstr
  9425                                  ;   35   227 eqstr
  9426                                  ;   36   233 eqstr
  9427                                  ;   37   239 eqstr
  9428                                  ;   38   245 eqstr
  9429                                  ;   39   251 eqstr
  9430                                  ;   40   257 eqstr
  9431                                  ;   41   263 eqstr
  9432                                  ;   42   269 eqstr
  9433                                  ;   43   275 eqstr
  9434                                  ;   44   281 writetty
  9435                                  ;   45   290 writetty
  9436                                  ;   46   299 fputcR
  9437                                  ;   47   306 prc
  9438                                  ;   48   310 prc
  9439                                  ;   49   314 prc
  9440                                  ;   50   318 printhex4
  9441                                  ;   51   328 printhex4
  9442                                  ;   52   338 printhex8a
  9443                                  ;   53   349 printhex8a
  9444                                  ;   54   360 printIntU
  9445                                  ;   55   370 prc
  9446                                  ;   56   374 prs
  9447                                  ;   57   378 printhex16
  9448                                  ;   58   389 prs
  9449                                  ;   59   393 prc
  9450                                  ;   60   397 printhex8a
  9451                                  ;   61   408 prs
  9452                                  ;   62   412 prc
  9453                                  ;   63   416 prscomment
  9454                                  ;   64   427 prs
  9455                                  ;   65   431 printIntU
  9456                                  ;   66   441 prs
  9457                                  ;   67   445 prs
  9458                                  ;   68   449 prs
  9459                                  ;   69   453 prs
  9460                                  ;   70   457 prs
  9461                                  ;   71   461 prs
  9462                                  ;   72   465 printIntU
  9463                                  ;   73   475 prs
  9464                                  ;   74   479 prs
  9465                                  ;   75   483 printIntU
  9466                                  ;   76   493 fputcR
  9467                                  ;   77   500 fcloseR
  9468                                  ;   78   508 fcloseR
  9469                                  ;   79   516 fcloseR
  9470                                  ;   80   524 exitR
  9471                                  ;   81   530 prs
  9472                                  ;   82   534 prs
  9473                                  ;   83   538 prs
  9474                                  ;   84   542 prs
  9475                                  ;   85   546 error1
  9476                                  ;   86   553 epilog
  9477                                  ;   87   560 end1
  9478                                  ;   88   565 prs
  9479                                  ;   89   569 prs
  9480                                  ;   90   573 prs
  9481                                  ;   91   577 error1
  9482                                  ;   92   584 error1
  9483                                  ;   93   591 error1
  9484                                  ;   94   598 error1
  9485                                  ;   95   605 error1
  9486                                  ;   96   612 error1
  9487                                  ;   97   619 error1
  9488                                  ;   98   626 error1
  9489                                  ;   99   633 error1
  9490                                  ;  100   640 error1
  9491                                  ;  101   647 error1
  9492                                  ;  102   654 errorexit
  9493                                  ;  103   664 errorexit
  9494                                  ;  104   674 errorexit
  9495                                  ;  105   684 readRL
  9496                                  ;  106   691 errorexit
  9497                                  ;  107   701 readRL
  9498                                  ;  108   708 errorexit
  9499                                  ;  109   718 errorexit
  9500                                  ;  110   728 ifEOL
  9501                                  ;  111   734 digit
  9502                                  ;  112   740 alnumE
  9503                                  ;  113   747 errorexit
  9504                                  ;  114   757 strcpy
  9505                                  ;  115   764 toupper
  9506                                  ;  116   772 eqstr
  9507                                  ;  117   778 errorexit
  9508                                  ;  118   788 genCode8
  9509                                  ;  119   797 genCode8
  9510                                  ;  120   806 genCode8
  9511                                  ;  121   815 genCode8
  9512                                  ;  122   824 genCode8
  9513                                  ;  123   833 genCode16
  9514                                  ;  124   843 genCode16
  9515                                  ;  125   853 genCode8
  9516                                  ;  126   862 genCode8
  9517                                  ;  127   871 genCode16
  9518                                  ;  128   881 genCode32
  9519                                  ;  129   891 genCode16
  9520                                  ;  130   901 genCode8
  9521                                  ;  131   910 gen66h
  9522                                  ;  132   917 error1
  9523                                  ;  133   924 skipBlank
  9524                                  ;  134   934 digit
  9525                                  ;  135   940 getDigit
  9526                                  ;  136   949 letterE
  9527                                  ;  137   957 getName
  9528                                  ;  138   965 skipBlank
  9529                                  ;  139   975 isToken
  9530                                  ;  140   983 getTokeType
  9531                                  ;  141   995 error1
  9532                                  ;  142  1002 prs
  9533                                  ;  143  1006 prc
  9534                                  ;  144  1010 getTokeType
  9535                                  ;  145  1022 error1
  9536                                  ;  146  1029 implerror
  9537                                  ;  147  1039 segregerror
  9538                                  ;  148  1051 setwflag
  9539                                  ;  149  1060 error1
  9540                                  ;  150  1067 error1
  9541                                  ;  151  1074 eqstr
  9542                                  ;  152  1080 strlen
  9543                                  ;  153  1087 testReg
  9544                                  ;  154  1095 searchLabel
  9545                                  ;  155  1107 indexerror
  9546                                  ;  156  1118 indexerror
  9547                                  ;  157  1129 indexerror
  9548                                  ;  158  1140 indexerror
  9549                                  ;  159  1151 getTokeType
  9550                                  ;  160  1163 getOp1
  9551                                  ;  161  1170 syntaxerror
  9552                                  ;  162  1182 getIndReg2
  9553                                  ;  163  1193 getIndReg1
  9554                                  ;  164  1204 notfounderror
  9555                                  ;  165  1218 isToken
  9556                                  ;  166  1226 getTokeType
  9557                                  ;  167  1238 numbererror
  9558                                  ;  168  1250 isToken
  9559                                  ;  169  1258 isToken
  9560                                  ;  170  1266 errorexit
  9561                                  ;  171  1276 getOp1
  9562                                  ;  172  1283 isToken
  9563                                  ;  173  1291 getMEM
  9564                                  ;  174  1298 invaloperror
  9565                                  ;  175  1311 error1
  9566                                  ;  176  1318 getOpR
  9567                                  ;  177  1325 getOpL
  9568                                  ;  178  1332 need
  9569                                  ;  179  1337 getOpR
  9570                                  ;  180  1344 get2Ops
  9571                                  ;  181  1352 addrerror
  9572                                  ;  182  1362 invaloperror
  9573                                  ;  183  1375 immeerror
  9574                                  ;  184  1385 addrerror
  9575                                  ;  185  1395 invaloperror
  9576                                  ;  186  1408 setwflag
  9577                                  ;  187  1417 errorexit
  9578                                  ;  188  1427 strcpy
  9579                                  ;  189  1434 errorexit
  9580                                  ;  190  1444 searchLabel
  9581                                  ;  191  1456 error1
  9582                                  ;  192  1463 errorexit
  9583                                  ;  193  1473 strcpy
  9584                                  ;  194  1480 errorexit
  9585                                  ;  195  1490 getTokeType
  9586                                  ;  196  1502 genCode8
  9587                                  ;  197  1511 skipBlank
  9588                                  ;  198  1521 isToken
  9589                                  ;  199  1529 genCode8
  9590                                  ;  200  1538 isToken
  9591                                  ;  201  1546 storeLabel
  9592                                  ;  202  1557 getTokeType
  9593                                  ;  203  1569 lookCode
  9594                                  ;  204  1578 dataexit
  9595                                  ;  205  1587 dataexit
  9596                                  ;  206  1596 getTokeType
  9597                                  ;  207  1608 genCode8
  9598                                  ;  208  1617 skipBlank
  9599                                  ;  209  1627 isToken
  9600                                  ;  210  1635 genCode8
  9601                                  ;  211  1644 isToken
  9602                                  ;  212  1652 getTokeType
  9603                                  ;  213  1664 genCode16
  9604                                  ;  214  1674 isToken
  9605                                  ;  215  1682 getTokeType
  9606                                  ;  216  1694 genCode16
  9607                                  ;  217  1704 genCode16
  9608                                  ;  218  1714 isToken
  9609                                  ;  219  1722 getTokeType
  9610                                  ;  220  1734 syntaxerror
  9611                                  ;  221  1746 error1
  9612                                  ;  222  1753 numbererror
  9613                                  ;  223  1765 dataexit
  9614                                  ;  224  1774 eqstr
  9615                                  ;  225  1780 getTokeType
  9616                                  ;  226  1792 eqstr
  9617                                  ;  227  1798 getTokeType
  9618                                  ;  228  1810 eqstr
  9619                                  ;  229  1816 getTokeType
  9620                                  ;  230  1828 cputs
  9621                                  ;  231  1834 cputs
  9622                                  ;  232  1840 exitR
  9623                                  ;  233  1846 toupper
  9624                                  ;  234  1854 strcpy
  9625                                  ;  235  1861 strcat1
  9626                                  ;  236  1869 strcpy
  9627                                  ;  237  1876 strcat1
  9628                                  ;  238  1884 strcpy
  9629                                  ;  239  1891 strcat1
  9630                                  ;  240  1899 openR
  9631                                  ;  241  1905 cputs
  9632                                  ;  242  1911 cputs
  9633                                  ;  243  1917 exitR
  9634                                  ;  244  1923 creatR
  9635                                  ;  245  1930 cputs
  9636                                  ;  246  1936 cputs
  9637                                  ;  247  1942 exitR
  9638                                  ;  248  1948 creatR
  9639                                  ;  249  1955 cputs
  9640                                  ;  250  1961 cputs
  9641                                  ;  251  1967 exitR
  9642                                  ;  252  1973 prs
  9643                                  ;  253  1977 prs
  9644                                  ;  254  1981 prs
  9645                                  ;  255  1985 prs
  9646                                  ;  256  1989 prs
  9647                                  ;  257  1993 prs
  9648                                  ;  258  1997 prs
  9649                                  ;  259  2001 prs
  9650                                  ;  260  2005 prs
  9651                                  ;  261  2009 strcpy
  9652                                  ;  262  2016 strlen
  9653                                  ;  263  2023 searchLabel
  9654                                  ;  264  2035 notfounderror
  9655                                  ;  265  2049 prs
  9656                                  ;  266  2053 printIntU
  9657                                  ;  267  2063 error1
  9658                                  ;  268  2070 strcpy
  9659                                  ;  269  2077 searchLabel
  9660                                  ;  270  2089 notfounderror
  9661                                  ;  271  2103 prs
  9662                                  ;  272  2107 printhex16
  9663                                  ;  273  2118 prs
  9664                                  ;  274  2122 printhex16
  9665                                  ;  275  2133 getTokeType
  9666                                  ;  276  2145 getCodeSize
  9667                                  ;  277  2157 getCodes
  9668                                  ;  278  2166 genCode8
  9669                                  ;  279  2175 getOpL
  9670                                  ;  280  2182 checkOpL
  9671                                  ;  281  2191 genCode2
  9672                                  ;  282  2200 getTokeType
  9673                                  ;  283  2212 implerror
  9674                                  ;  284  2222 genCodeW
  9675                                  ;  285  2231 writeEA
  9676                                  ;  286  2239 check2Ops
  9677                                  ;  287  2249 reg16error
  9678                                  ;  288  2260 addrerror
  9679                                  ;  289  2270 genCode8
  9680                                  ;  290  2279 genCode8
  9681                                  ;  291  2288 writeEA
  9682                                  ;  292  2296 check2Ops
  9683                                  ;  293  2306 setsflag
  9684                                  ;  294  2315 genCodeW
  9685                                  ;  295  2324 genImmediate
  9686                                  ;  296  2337 genCodeW
  9687                                  ;  297  2346 writeEA
  9688                                  ;  298  2354 genCode8
  9689                                  ;  299  2363 genImmediate
  9690                                  ;  300  2376 genCodeW
  9691                                  ;  301  2385 writeEA
  9692                                  ;  302  2393 genCodeW
  9693                                  ;  303  2402 writeEA
  9694                                  ;  304  2410 syntaxerror
  9695                                  ;  305  2422 check2Ops
  9696                                  ;  306  2432 notfounderror
  9697                                  ;  307  2446 genCode2
  9698                                  ;  308  2455 genImmediate
  9699                                  ;  309  2468 genCodeW
  9700                                  ;  310  2477 writeEA
  9701                                  ;  311  2485 genImmediate
  9702                                  ;  312  2498 regmemerror
  9703                                  ;  313  2510 ChangeDirection
  9704                                  ;  314  2526 reg16error
  9705                                  ;  315  2537 genCode2
  9706                                  ;  316  2546 writeEA
  9707                                  ;  317  2554 genCodeW
  9708                                  ;  318  2563 genCode16
  9709                                  ;  319  2573 genCodeW
  9710                                  ;  320  2582 genCode16
  9711                                  ;  321  2592 genCodeW
  9712                                  ;  322  2601 writeEA
  9713                                  ;  323  2609 ChangeDirection
  9714                                  ;  324  2625 genCodeW
  9715                                  ;  325  2634 writeEA
  9716                                  ;  326  2642 syntaxerror
  9717                                  ;  327  2654 searchLabel
  9718                                  ;  328  2666 checkConstSize
  9719                                  ;  329  2681 genCode2
  9720                                  ;  330  2690 genCode8
  9721                                  ;  331  2699 genCode8
  9722                                  ;  332  2708 genCode2
  9723                                  ;  333  2717 genCode16
  9724                                  ;  334  2727 genCode8
  9725                                  ;  335  2736 genCode2
  9726                                  ;  336  2745 storeJmp
  9727                                  ;  337  2754 genCode16
  9728                                  ;  338  2764 searchLabel
  9729                                  ;  339  2776 checkConstSize
  9730                                  ;  340  2791 genCode8
  9731                                  ;  341  2800 genCode8
  9732                                  ;  342  2809 genCode8
  9733                                  ;  343  2818 genCode16
  9734                                  ;  344  2828 genCode8
  9735                                  ;  345  2837 genCode16
  9736                                  ;  346  2847 genCode8
  9737                                  ;  347  2856 storeJmp
  9738                                  ;  348  2865 genCode16
  9739                                  ;  349  2875 genCode8
  9740                                  ;  350  2884 genCode16
  9741                                  ;  351  2894 genCode8
  9742                                  ;  352  2903 getOpL
  9743                                  ;  353  2910 setsflag
  9744                                  ;  354  2919 genCode2
  9745                                  ;  355  2928 genCode8
  9746                                  ;  356  2937 genCode16
  9747                                  ;  357  2947 genCode8
  9748                                  ;  358  2956 genCode16
  9749                                  ;  359  2966 genCode8
  9750                                  ;  360  2975 storeJmp
  9751                                  ;  361  2984 genCode16
  9752                                  ;  362  2994 error1
  9753                                  ;  363  3001 genCode8
  9754                                  ;  364  3010 genCode8
  9755                                  ;  365  3019 checkOpL
  9756                                  ;  366  3028 reg16error
  9757                                  ;  367  3039 genCode2
  9758                                  ;  368  3048 genCode8
  9759                                  ;  369  3057 writeEA
  9760                                  ;  370  3065 syntaxerror
  9761                                  ;  371  3077 check2Ops
  9762                                  ;  372  3087 genCodeW
  9763                                  ;  373  3096 writeEA
  9764                                  ;  374  3104 genCodeW
  9765                                  ;  375  3113 writeEA
  9766                                  ;  376  3121 genCode8
  9767                                  ;  377  3130 genCodeW
  9768                                  ;  378  3139 writeEA
  9769                                  ;  379  3147 genCode8
  9770                                  ;  380  3156 genCode8
  9771                                  ;  381  3165 genCode8
  9772                                  ;  382  3174 getOp1
  9773                                  ;  383  3181 genCode16
  9774                                  ;  384  3191 numbererror
  9775                                  ;  385  3203 need
  9776                                  ;  386  3208 getOp1
  9777                                  ;  387  3215 genCode8
  9778                                  ;  388  3224 numbererror
  9779                                  ;  389  3236 numbererror
  9780                                  ;  390  3248 numbererror
  9781                                  ;  391  3260 prs
  9782                                  ;  392  3264 prs
  9783                                  ;  393  3268 error1
  9784                                  ;  394  3275 error1
  9785                                  ;  395  3282 prs
  9786                                  ;  396  3286 prs
  9787                                  ;  397  3290 prs
  9788                                  ;  398  3294 printIntU
  9789                                  ;  399  3304 prs
  9790                                  ;  400  3308 printIntU
  9791                                  ;  401  3318 fixJmp
  9792                                  ;  402  3325 genDB
  9793                                  ;  403  3331 error1
  9794                                  ;  404  3338 getLine
  9795                                  ;  405  3346 getTokeType
  9796                                  ;  406  3358 strcpy
  9797                                  ;  407  3365 storeLabel
  9798                                  ;  408  3376 getTokeType
  9799                                  ;  409  3388 lookCode
  9800                                  ;  410  3397 process
  9801                                  ;  411  3405 getVariable
  9802                                  ;  412  3417 skipRest
  9803                                  ;  413  3426 error1
  9804                                  ;  414  3433 error1
  9805                                  ;  415  3440 printLine
  9806                                  ;  416  3450 getarg
  9807                                  ;  417  3457 parse
  9808                                  ;  418  3463 fixJmpMain
  9809                                  ;  419  3474 epilog
  9810                                  ;  420  3481 end1
  9811                                  ;Input: AS.C, List: AS.S,  Lines: 1498
  9812                                  ;Glob. variables:  189 max.:  200
  9813                                  ;Functions      :   91 max.:  300
  9814                                  ;Calls          :  421 max.: 2000, NameField: 3486 max.:    65535
  9815                                  ;Code until     :21667 max.: 30000, free: 8333
  9816                                  ;Data (HeapEnd) :59154, resting stacksize:  6381
  9817                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
