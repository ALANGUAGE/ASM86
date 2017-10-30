     1                                  
     2                                  ; A.COM V0.9, Source: AS.C, Output asm: AS.S
     3                                  org  256 
     4 00000000 E92F2F                  jmp main
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
  3146                                  ;-475 char I_INC[]=  {'I','N','C',0,          2, 0,0xF1};
  3147                                  
  3148 00001046 494E43000200F1          I_INC db 73,78,67,0,2,0,241
  3149                                  
  3150                                  ;-476 char I_DEC[]=  {'D','E','C',0,          2, 1,0xF1};
  3151                                  
  3152 0000104D 444543000201F1          I_DEC db 68,69,67,0,2,1,241
  3153                                  
  3154                                  ;-477 char I_NOT[]=  {'N','O','T',0,          2, 2,     0xF1};
  3155                                  
  3156 00001054 4E4F54000202F1          I_NOT db 78,79,84,0,2,2,241
  3157                                  
  3158                                  ;-478 char I_NEG[]=  {'N','E','G',0,          2, 3,     0xF1};
  3159                                  
  3160 0000105B 4E4547000203F1          I_NEG db 78,69,71,0,2,3,241
  3161                                  
  3162                                  ;-479 char I_MUL[]=  {'M','U','L',0,          2, 4,     0xF1};
  3163                                  
  3164 00001062 4D554C000204F1          I_MUL db 77,85,76,0,2,4,241
  3165                                  
  3166                                  ;-480 char I_IMUL[]= {'I','M','U','L',0,      2, 5,     0xF1};//only acc
  3167                                  
  3168 00001069 494D554C000205F1        I_IMUL db 73,77,85,76,0,2,5,241
  3169                                  
  3170                                  ;-481 char I_DIV[]=  {'D','I','V',0,          2, 6,     0xF1};
  3171                                  
  3172 00001071 444956000206F1          I_DIV db 68,73,86,0,2,6,241
  3173                                  
  3174                                  ;-482 char I_IDIV[]= {'I','D','I','V',0,      2, 7,     0xF1};
  3175                                  
  3176 00001078 49444956000207F1        I_IDIV db 73,68,73,86,0,2,7,241
  3177                                  
  3178                                  ;-483 //  3: les, lda, lea, lss, lfs, lgs
  3179                                  
  3180                                  
  3181                                  ;-484 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
  3182                                  
  3183 00001080 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
  3184                                  
  3185                                  ;-485 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
  3186                                  
  3187 00001087 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
  3188                                  
  3189                                  ;-486 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
  3190                                  
  3191 0000108E 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
  3192                                  
  3193                                  ;-487 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
  3194                                  
  3195 00001095 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
  3196                                  
  3197                                  ;-488 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
  3198                                  
  3199 0000109D 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
  3200                                  
  3201                                  ;-489 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
  3202                                  
  3203 000010A5 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
  3204                                  
  3205                                  ;-490 //  4: acc,imm  reg,imm  index,reg
  3206                                  
  3207                                  
  3208                                  ;-491 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
  3209                                  
  3210 000010AD 414444000400F1          I_ADD db 65,68,68,0,4,0,241
  3211                                  
  3212                                  ;-492 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
  3213                                  
  3214 000010B4 4F52000401F1            I_OR db 79,82,0,4,1,241
  3215                                  
  3216                                  ;-493 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
  3217                                  
  3218 000010BA 414443000402F1          I_ADC db 65,68,67,0,4,2,241
  3219                                  
  3220                                  ;-494 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
  3221                                  
  3222 000010C1 534242000403F1          I_SBB db 83,66,66,0,4,3,241
  3223                                  
  3224                                  ;-495 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
  3225                                  
  3226 000010C8 414E44000404F1          I_AND db 65,78,68,0,4,4,241
  3227                                  
  3228                                  ;-496 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
  3229                                  
  3230 000010CF 535542000405F1          I_SUB db 83,85,66,0,4,5,241
  3231                                  
  3232                                  ;-497 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
  3233                                  
  3234 000010D6 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
  3235                                  
  3236                                  ;-498 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
  3237                                  
  3238 000010DD 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
  3239                                  
  3240                                  ;-499 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
  3241                                  
  3242 000010E4 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
  3243 000010ED 00F1               
  3244                                  
  3245                                  ;-500 //  5: mov
  3246                                  
  3247                                  
  3248                                  ;-501 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
  3249                                  
  3250 000010EF 4D4F560005F1            I_MOV db 77,79,86,0,5,241
  3251                                  
  3252                                  ;-502 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
  3253                                  
  3254 000010F5 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
  3255                                  
  3256                                  ;-503 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
  3257                                  
  3258 000010FE 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
  3259                                  
  3260                                  ;-504 //  6: single byte relative jump
  3261                                  
  3262                                  
  3263                                  ;-505 char I_JO []=  {'J','O',0,     6, 0,0xF1};
  3264                                  
  3265 00001107 4A4F000600F1            I_JO db 74,79,0,6,0,241
  3266                                  
  3267                                  ;-506 char I_JNO[]=  {'J','N','O',0, 6, 1,0xF1};
  3268                                  
  3269 0000110D 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
  3270                                  
  3271                                  ;-507 char I_JB []=  {'J','B',0,     6, 2,0xF1, 'J','C',0,     6, 2,0xF1};
  3272                                  
  3273 00001114 4A42000602F14A4300-     I_JB db 74,66,0,6,2,241,74,67,0,6,2,241
  3274 0000111D 0602F1             
  3275                                  
  3276                                  ;-508 char I_JNB[]=  {'J','N','B',0, 6, 3,0xF1};
  3277                                  
  3278 00001120 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
  3279                                  
  3280                                  ;-509 char I_JAE[]=  {'J','A','E',0, 6, 3,0xF1, 'J','N','C',0, 6, 3,0xF1};
  3281                                  
  3282 00001127 4A4145000603F14A4E-     I_JAE db 74,65,69,0,6,3,241,74,78,67,0,6,3,241
  3283 00001130 43000603F1         
  3284                                  
  3285                                  ;-510 char I_JE []=  {'J','E',0,     6, 4,0xF1, 'J','Z',0,     6, 4,0xF1};
  3286                                  
  3287 00001135 4A45000604F14A5A00-     I_JE db 74,69,0,6,4,241,74,90,0,6,4,241
  3288 0000113E 0604F1             
  3289                                  
  3290                                  ;-511 char I_JNE[]=  {'J','N','E',0, 6, 5,0xF1, 'J','N','Z',0, 6, 5,0xF1};
  3291                                  
  3292 00001141 4A4E45000605F14A4E-     I_JNE db 74,78,69,0,6,5,241,74,78,90,0,6,5,241
  3293 0000114A 5A000605F1         
  3294                                  
  3295                                  ;-512 char I_JBE[]=  {'J','B','E',0, 6, 6,0xF1, 'J','N','A',0, 6, 6,0xF1};
  3296                                  
  3297 0000114F 4A4245000606F14A4E-     I_JBE db 74,66,69,0,6,6,241,74,78,65,0,6,6,241
  3298 00001158 41000606F1         
  3299                                  
  3300                                  ;-513 char I_JA []=  {'J','A',0,     6, 7,0xF1};
  3301                                  
  3302 0000115D 4A41000607F1            I_JA db 74,65,0,6,7,241
  3303                                  
  3304                                  ;-514 char I_JS []=  {'J','S',0,     6, 8,0xF1};
  3305                                  
  3306 00001163 4A53000608F1            I_JS db 74,83,0,6,8,241
  3307                                  
  3308                                  ;-515 char I_JNS[]=  {'J','N','S',0, 6, 9,0xF1};
  3309                                  
  3310 00001169 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
  3311                                  
  3312                                  ;-516 char I_JP []=  {'J','P',0,     6,10,0xF1, 'J','P','E',0, 6,10,0xF1};
  3313                                  
  3314 00001170 4A5000060AF14A5045-     I_JP db 74,80,0,6,10,241,74,80,69,0,6,10,241
  3315 00001179 00060AF1           
  3316                                  
  3317                                  ;-517 char I_JNP[]=  {'J','N','P',0, 6,11,0xF1, 'J','P','O',0, 6,11,0xF1};
  3318                                  
  3319 0000117D 4A4E5000060BF14A50-     I_JNP db 74,78,80,0,6,11,241,74,80,79,0,6,11,241
  3320 00001186 4F00060BF1         
  3321                                  
  3322                                  ;-518 char I_JL []=  {'J','L',0,     6,12,0xF1};
  3323                                  
  3324 0000118B 4A4C00060CF1            I_JL db 74,76,0,6,12,241
  3325                                  
  3326                                  ;-519 char I_JNL[]=  {'J','N','L',0, 6,13,0xF1, 'J','G','E',0, 6,13,0xF1};
  3327                                  
  3328 00001191 4A4E4C00060DF14A47-     I_JNL db 74,78,76,0,6,13,241,74,71,69,0,6,13,241
  3329 0000119A 4500060DF1         
  3330                                  
  3331                                  ;-520 char I_JLE[]=  {'J','L','E',0, 6,14,0xF1, 'J','N','G',0, 6,14,0xF1};
  3332                                  
  3333 0000119F 4A4C4500060EF14A4E-     I_JLE db 74,76,69,0,6,14,241,74,78,71,0,6,14,241
  3334 000011A8 4700060EF1         
  3335                                  
  3336                                  ;-521 char I_JG []=  {'J','G',0,     6,15,0xF1};
  3337                                  
  3338 000011AD 4A4700060FF1            I_JG db 74,71,0,6,15,241
  3339                                  
  3340                                  ;-522 //  7: jmp, call
  3341                                  
  3342                                  
  3343                                  ;-523 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
  3344                                  
  3345 000011B3 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
  3346                                  
  3347                                  ;-524 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
  3348                                  
  3349 000011BB 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
  3350                                  
  3351                                  ;-525 //  8: ret
  3352                                  
  3353                                  
  3354                                  ;-526 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
  3355                                  
  3356 000011C4 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
  3357                                  
  3358                                  ;-527 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
  3359                                  
  3360 000011CC 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
  3361                                  
  3362                                  ;-528 //  9: seg, r/m
  3363                                  
  3364                                  
  3365                                  ;-529 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xF1};
  3366                                  
  3367 000011D5 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
  3368                                  
  3369                                  ;-530 char I_POP[]=  {'P','O','P',0,          9,0x58,0xF1};
  3370                                  
  3371 000011DD 504F50000958F1          I_POP db 80,79,80,0,9,88,241
  3372                                  
  3373                                  ;-531 //  11: shift, rotates
  3374                                  
  3375                                  
  3376                                  ;-532 char I_ROL[]=  {'R','O','L',0, 11, 0,0xF1, 'R','O','R',0, 11, 1,0xF1};
  3377                                  
  3378 000011E4 524F4C000B00F1524F-     I_ROL db 82,79,76,0,11,0,241,82,79,82,0,11,1,241
  3379 000011ED 52000B01F1         
  3380                                  
  3381                                  ;-533 char I_RCL[]=  {'R','C','L',0, 11, 2,0xF1, 'R','C','R',0, 11, 3,0xF1};
  3382                                  
  3383 000011F2 52434C000B02F15243-     I_RCL db 82,67,76,0,11,2,241,82,67,82,0,11,3,241
  3384 000011FB 52000B03F1         
  3385                                  
  3386                                  ;-534 char I_SHL[]=  {'S','H','L',0, 11, 4,0xF1, 'S','A','L',0, 11, 4,0xF1};
  3387                                  
  3388 00001200 53484C000B04F15341-     I_SHL db 83,72,76,0,11,4,241,83,65,76,0,11,4,241
  3389 00001209 4C000B04F1         
  3390                                  
  3391                                  ;-535 char I_SHR[]=  {'S','H','R',0, 11, 5,0xF1, 'S','A','R',0, 11, 7,0xF1};
  3392                                  
  3393 0000120E 534852000B05F15341-     I_SHR db 83,72,82,0,11,5,241,83,65,82,0,11,7,241
  3394 00001217 52000B07F1         
  3395                                  
  3396                                  ;-536 //  12: int
  3397                                  
  3398                                  
  3399                                  ;-537 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
  3400                                  
  3401 0000121C 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
  3402                                  
  3403                                  ;-538 //  14: in/out
  3404                                  
  3405                                  
  3406                                  ;-539 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
  3407                                  
  3408 00001224 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
  3409                                  
  3410                                  ;-540 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
  3411                                  
  3412 0000122B 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
  3413                                  
  3414                                  ;-541 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
  3415                                  
  3416 00001233 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
  3417                                  
  3418                                  ;-542 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
  3419                                  
  3420 0000123B 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
  3421                                  
  3422                                  ;-543 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
  3423                                  
  3424 00001243 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
  3425                                  
  3426                                  ;-544 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
  3427                                  
  3428 0000124B 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
  3429                                  
  3430                                  ;-545 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
  3431                                  
  3432 00001253 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
  3433                                  
  3434                                  ;-546 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
  3435                                  
  3436 0000125B 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
  3437                                  
  3438                                  ;-547 //  15: xchg
  3439                                  
  3440                                  
  3441                                  ;-548 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
  3442                                  
  3443 00001263 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
  3444                                  
  3445                                  ;-549 //  16: loop, jcxz
  3446                                  
  3447                                  
  3448                                  ;-550 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
  3449                                  
  3450 0000126C 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
  3451 00001275 F1                 
  3452                                  
  3453                                  ;-551 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
  3454                                  
  3455 00001276 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
  3456 0000127F F1                 
  3457                                  
  3458                                  ;-552 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
  3459                                  
  3460 00001280 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
  3461                                  
  3462                                  ;-553 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
  3463                                  
  3464 00001289 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
  3465                                  
  3466                                  ;-554 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
  3467                                  
  3468 00001292 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
  3469                                  
  3470                                  ;-555 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
  3471                                  
  3472 0000129A 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
  3473                                  
  3474                                  ;-556 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
  3475                                  
  3476 000012A2 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
  3477                                  
  3478                                  ;-557 //  30: enter
  3479                                  
  3480                                  
  3481                                  ;-558 char I_ENTER[]={'E','N','T','E','R',0, 30,        0xF1};
  3482                                  
  3483 000012AB 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
  3484                                  
  3485                                  ;-559 // 100: directives
  3486                                  
  3487                                  
  3488                                  ;-560 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
  3489                                  
  3490 000012B3 4F52470065F1            I_ORG db 79,82,71,0,101,241
  3491                                  
  3492                                  ;-561 // section, segment .TEXT .DATA .BSS
  3493                                  
  3494                                  
  3495                                  ;-562 char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
  3496                                  
  3497 000012B9 53454354494F4E0066-     I_SECTION db 83,69,67,84,73,79,78,0,102,241
  3498 000012C2 F1                 
  3499                                  
  3500                                  ;-563 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
  3501                                  
  3502 000012C3 5345474D454E540066-     I_SEGMENT db 83,69,71,77,69,78,84,0,102,241
  3503 000012CC F1                 
  3504                                  
  3505                                  ;-564 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
  3506                                  
  3507 000012CD 4142534F4C55544500-     I_ABSOLUTE db 65,66,83,79,76,85,84,69,0,110,241
  3508 000012D6 6EF1               
  3509                                  
  3510                                  ;-565 char I_PROC[]= {'P','R','O','C',0,    111,        0xF1};
  3511                                  
  3512 000012D8 50524F43006FF1          I_PROC db 80,82,79,67,0,111,241
  3513                                  
  3514                                  ;-566 char I_ENDP[]= {'E','N','D','P',0,    112,        0xF1};
  3515                                  
  3516 000012DF 454E44500070F1          I_ENDP db 69,78,68,80,0,112,241
  3517                                  
  3518                                  ;-567 char I_DB[]=   {'D','B',0,            200,        0xF1};
  3519                                  
  3520 000012E6 444200C8F1              I_DB db 68,66,0,200,241
  3521                                  
  3522                                  ;-568 char I_DW[]=   {'D','W',0,            201,        0xF1};
  3523                                  
  3524 000012EB 445700C9F1              I_DW db 68,87,0,201,241
  3525                                  
  3526                                  ;-569 char I_DD[]=   {'D','D',0,            202,        0xF1};
  3527                                  
  3528 000012F0 444400CAF1              I_DD db 68,68,0,202,241
  3529                                  
  3530                                  ;-570 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
  3531                                  
  3532 000012F5 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
  3533                                  
  3534                                  ;-571 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
  3535                                  
  3536 000012FC 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
  3537                                  
  3538                                  ;-572 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
  3539                                  
  3540 00001303 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
  3541                                  
  3542                                  ;-573 char I_END=0;// end of table char
  3543                                  
  3544 0000130A 00                      I_END db 0
  3545                                  
  3546                                  ;-574 
  3547                                  
  3548                                  
  3549                                  ;-575 int lookCode() {//ret: CodeType, *OpCodePtr
  3550                                  
  3551                                  
  3552                                  lookCode: PROC
  3553                                  
  3554                                  ;-576     CodeType=0;
  3555                                  
  3556 0000130B B80000                   mov ax, 0
  3557 0000130E A2[2F00]                 mov byte [CodeType], al
  3558                                  
  3559                                  ;-577     OpCodePtr= &I_START;
  3560                                  
  3561 00001311 B8[090F]                 mov ax, I_START
  3562 00001314 A3[4300]                 mov word [OpCodePtr], ax
  3563                                  
  3564                                  ;-578     OpCodePtr++;
  3565                                  
  3566 00001317 FF06[4300]               inc  word[OpCodePtr]
  3567                                  
  3568                                  ;-579     do  {
  3569                                  
  3570                                  .lookCode102:
  3571                                  
  3572                                  ;-580         if (eqstr(SymbolUpper, OpCodePtr))  {
  3573                                  
  3574 0000131B FF36[4300]               push word [OpCodePtr]
  3575 0000131F 8D064F75                 lea  ax, [SymbolUpper]
  3576 00001323 50                       push ax
  3577 00001324 E839EF                   call eqstr
  3578 00001327 83C404                   add  sp, 4
  3579 0000132A 08C0                     or  al, al
  3580 0000132C 0F842700                 je .lookCode103
  3581                                  
  3582                                  ;-581             while(*OpCodePtr!=0) OpCodePtr++;
  3583                                  
  3584                                  .lookCode104:
  3585 00001330 8B1E[4300]               mov bx, [OpCodePtr]
  3586 00001334 8A07                     mov al, [bx]
  3587 00001336 B400                     mov ah, 0
  3588 00001338 83F800                   cmp ax, 0
  3589 0000133B 0F840600                 je  .lookCode105
  3590 0000133F FF06[4300]               inc  word[OpCodePtr]
  3591                                  
  3592                                  ;-582             OpCodePtr++;
  3593                                  
  3594 00001343 EBEB                     jmp .lookCode104
  3595                                  .lookCode105:
  3596 00001345 FF06[4300]               inc  word[OpCodePtr]
  3597                                  
  3598                                  ;-583             CodeType =*OpCodePtr;
  3599                                  
  3600 00001349 8B1E[4300]               mov bx, [OpCodePtr]
  3601 0000134D 8A07                     mov al, [bx]
  3602 0000134F B400                     mov ah, 0
  3603 00001351 A2[2F00]                 mov byte [CodeType], al
  3604                                  
  3605                                  ;-584             return;
  3606                                  
  3607 00001354 E92A00                   jmp .retnlookCode
  3608                                  
  3609                                  ;-585         }
  3610                                  
  3611                                  
  3612                                  ;-586     while(*OpCodePtr!=0xF1) OpCodePtr++;
  3613                                  
  3614                                  .lookCode103:
  3615                                  .lookCode106:
  3616 00001357 8B1E[4300]               mov bx, [OpCodePtr]
  3617 0000135B 8A07                     mov al, [bx]
  3618 0000135D B400                     mov ah, 0
  3619 0000135F 3DF100                   cmp ax, 241
  3620 00001362 0F840600                 je  .lookCode107
  3621 00001366 FF06[4300]               inc  word[OpCodePtr]
  3622                                  
  3623                                  ;-587     OpCodePtr++;
  3624                                  
  3625 0000136A EBEB                     jmp .lookCode106
  3626                                  .lookCode107:
  3627 0000136C FF06[4300]               inc  word[OpCodePtr]
  3628                                  
  3629                                  ;-588     } while(*OpCodePtr!=0);
  3630                                  
  3631 00001370 8B1E[4300]               mov bx, [OpCodePtr]
  3632 00001374 8A07                     mov al, [bx]
  3633 00001376 B400                     mov ah, 0
  3634 00001378 83F800                   cmp ax, 0
  3635 0000137B 0F840200                 je  .lookCode108
  3636 0000137F EB9A                     jmp .lookCode102
  3637                                  .lookCode108:
  3638                                  
  3639                                  ;-589 }
  3640                                  
  3641                                  
  3642                                  ;-590 
  3643                                  
  3644                                  
  3645                                  ;-591 int genCode8(char c) {
  3646                                  
  3647                                   .retnlookCode:
  3648 00001381 C3                       ret
  3649                                  ENDP
  3650                                  
  3651                                  genCode8: PROC
  3652                                  
  3653                                  ;-592 //set: BinLen++, OpPrintIndex++
  3654                                  
  3655                                  
  3656                                  ;-593     FileBin[BinLen]=c;
  3657                                  
  3658                                  ;Function : genCode8, Number of local variables: 1
  3659                                  ;   # type sign width addr used name   list of local variables
  3660                                  ;  200 var sign byte   591 NULL c = bp+4;
  3661 00001382 C8000000                 ENTER  0,0
  3662 00001386 8A4604                   mov al, [bp+4]
  3663 00001389 8B1E[5800]               mov bx, [BinLen]
  3664 0000138D 8887AAA4                 mov [FileBin+bx], al
  3665                                  
  3666                                  ;-594     BinLen++;
  3667                                  
  3668 00001391 FF06[5800]               inc  word[BinLen]
  3669                                  
  3670                                  ;-595     PC++;
  3671                                  
  3672 00001395 FF06[2300]               inc  word[PC]
  3673                                  
  3674                                  ;-596     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  3675                                  
  3676 00001399 A1[5800]                 mov ax, [BinLen]
  3677 0000139C 3D6842                   cmp ax, 17000 ;unsigned : 0
  3678 0000139F 0F820900                 jb  .genCode8109
  3679 000013A3 68[C713]                 push genCode8_0
  3680 000013A6 E8F8F6                   call errorexit
  3681 000013A9 83C402                   add  sp, 2
  3682                                  
  3683                                  ;-597     if (OpPrintIndex < OPMAXLEN) {
  3684                                  
  3685                                  .genCode8109:
  3686 000013AC A1[4100]                 mov ax, [OpPrintIndex]
  3687 000013AF 83F805                   cmp ax, 5
  3688 000013B2 0F8D0F00                 jge .genCode8110
  3689                                  
  3690                                  ;-598         OpPos[OpPrintIndex]=c;
  3691                                  
  3692 000013B6 8A4604                   mov al, [bp+4]
  3693 000013B9 8B1E[4100]               mov bx, [OpPrintIndex]
  3694 000013BD 88875577                 mov [OpPos+bx], al
  3695                                  
  3696                                  ;-599         OpPrintIndex++;
  3697                                  
  3698 000013C1 FF06[4100]               inc  word[OpPrintIndex]
  3699                                  
  3700                                  ;-600     }
  3701                                  
  3702                                  
  3703                                  ;-601 }
  3704                                  
  3705                                  .genCode8110:
  3706                                  
  3707                                  ;-602 int gen66h() {genCode8(0x66);
  3708 000013C5 C9                       LEAVE
  3709 000013C6 C3                       ret
  3710 000013C7 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  3711 000013D0 746F6F206C6F6E6700 
  3712                                  ENDP
  3713                                  
  3714                                  gen66h: PROC
  3715 000013D9 6A66                     push 102
  3716 000013DB E8A4FF                   call genCode8
  3717 000013DE 83C402                   add  sp, 2
  3718                                  
  3719                                  ;-603 }
  3720                                  
  3721                                  
  3722                                  ;-604 int genCode2(char c, char d) {
  3723                                  
  3724 000013E1 C3                       ret
  3725                                  ENDP
  3726                                  
  3727                                  genCode2: PROC
  3728                                  
  3729                                  ;-605     c = c + d;
  3730                                  
  3731                                  ;Function : genCode2, Number of local variables: 2
  3732                                  ;   # type sign width addr used name   list of local variables
  3733                                  ;  200 var sign byte   604 NULL c = bp+4
  3734                                  ;  201 var sign byte   604 NULL d = bp+6;
  3735 000013E2 C8000000                 ENTER  0,0
  3736 000013E6 8A4604                   mov al, [bp+4]
  3737 000013E9 024606                   add al, [bp+6]
  3738 000013EC 884604                   mov [bp+4], al
  3739                                  
  3740                                  ;-606     genCode8(c);
  3741                                  
  3742 000013EF 8A4604                   mov al, byte [bp+4]
  3743 000013F2 B400                     mov ah, 0
  3744 000013F4 50                       push ax
  3745 000013F5 E88AFF                   call genCode8
  3746 000013F8 83C402                   add  sp, 2
  3747                                  
  3748                                  ;-607 }
  3749                                  
  3750                                  
  3751                                  ;-608 int genCodeW(char c) {
  3752 000013FB C9                       LEAVE
  3753 000013FC C3                       ret
  3754                                  ENDP
  3755                                  
  3756                                  genCodeW: PROC
  3757                                  
  3758                                  ;-609     c = c + wflag;
  3759                                  
  3760                                  ;Function : genCodeW, Number of local variables: 1
  3761                                  ;   # type sign width addr used name   list of local variables
  3762                                  ;  200 var sign byte   608 NULL c = bp+4;
  3763 000013FD C8000000                 ENTER  0,0
  3764 00001401 8A4604                   mov al, [bp+4]
  3765 00001404 0206[3800]               add al, [wflag]
  3766 00001408 884604                   mov [bp+4], al
  3767                                  
  3768                                  ;-610     genCode8(c);
  3769                                  
  3770 0000140B 8A4604                   mov al, byte [bp+4]
  3771 0000140E B400                     mov ah, 0
  3772 00001410 50                       push ax
  3773 00001411 E86EFF                   call genCode8
  3774 00001414 83C402                   add  sp, 2
  3775                                  
  3776                                  ;-611 }
  3777                                  
  3778                                  
  3779                                  ;-612 int genCode16(unsigned int i) {
  3780 00001417 C9                       LEAVE
  3781 00001418 C3                       ret
  3782                                  ENDP
  3783                                  
  3784                                  genCode16: PROC
  3785                                  
  3786                                  ;-613     genCode8(i); i=i >> 8;
  3787                                  
  3788                                  ;Function : genCode16, Number of local variables: 1
  3789                                  ;   # type sign width addr used name   list of local variables
  3790                                  ;  200 var unsg word   612 NULL i = bp+4;
  3791 00001419 C8000000                 ENTER  0,0
  3792 0000141D FF7604                   push word [bp+4]
  3793 00001420 E85FFF                   call genCode8
  3794 00001423 83C402                   add  sp, 2
  3795 00001426 8B4604                   mov ax, [bp+4]
  3796 00001429 C1E808                   shr ax, 8
  3797 0000142C 894604                   mov [bp+4], ax
  3798                                  
  3799                                  ;-614     genCode8(i);
  3800                                  
  3801 0000142F FF7604                   push word [bp+4]
  3802 00001432 E84DFF                   call genCode8
  3803 00001435 83C402                   add  sp, 2
  3804                                  
  3805                                  ;-615 }
  3806                                  
  3807                                  
  3808                                  ;-616 int genCode32(unsigned long L) {
  3809 00001438 C9                       LEAVE
  3810 00001439 C3                       ret
  3811                                  ENDP
  3812                                  
  3813                                  genCode32: PROC
  3814                                  
  3815                                  ;-617     genCode16(L); L=L >>16;
  3816                                  
  3817                                  ;Function : genCode32, Number of local variables: 1
  3818                                  ;   # type sign width addr used name   list of local variables
  3819                                  ;  200 var unsg dwrd   616 NULL L = bp+4;
  3820 0000143A C8000000                 ENTER  0,0
  3821 0000143E 8A4604                   mov al, byte [bp+4]
  3822 00001441 B400                     mov ah, 0
  3823 00001443 50                       push ax
  3824 00001444 E8D2FF                   call genCode16
  3825 00001447 83C402                   add  sp, 2
  3826 0000144A 668B4604                 mov eax, [bp+4]
  3827 0000144E 66C1E810                 shr eax, 16
  3828 00001452 66894604                 mov [bp+4], eax
  3829                                  
  3830                                  ;-618     genCode16(L);
  3831                                  
  3832 00001456 8A4604                   mov al, byte [bp+4]
  3833 00001459 B400                     mov ah, 0
  3834 0000145B 50                       push ax
  3835 0000145C E8BAFF                   call genCode16
  3836 0000145F 83C402                   add  sp, 2
  3837                                  
  3838                                  ;-619 } 
  3839                                  
  3840                                  
  3841                                  ;-620 /*
  3842                                  
  3843                                  
  3844                                  ;-621 int getLen(unsigned int i) {
  3845                                  
  3846                                  
  3847                                  ;-622     if (i >  127) return 2;
  3848                                  
  3849                                  
  3850                                  ;-623     if (i < 0x80) return 2;//-128
  3851                                  
  3852                                  
  3853                                  ;-624     return 1;
  3854                                  
  3855                                  
  3856                                  ;-625 }
  3857                                  
  3858                                  
  3859                                  ;-626 */        
  3860                                  
  3861                                  
  3862                                  ;-627 int writeEA(char xxx) {//value for reg/operand
  3863 00001462 C9                       LEAVE
  3864 00001463 C3                       ret
  3865                                  ENDP
  3866                                  
  3867                                  writeEA: PROC
  3868                                  
  3869                                  ;-628 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  3870                                  
  3871                                  
  3872                                  ;-629 //mod-bits: mode76, reg/opcode543, r/m210
  3873                                  
  3874                                  
  3875                                  ;-630 //Op: 0, IMM, REG, ADR, MEM
  3876                                  
  3877                                  
  3878                                  ;-631     char len;
  3879                                  
  3880                                  
  3881                                  ;-632     len=0;
  3882                                  
  3883                                  ;Function : writeEA, Number of local variables: 2
  3884                                  ;   # type sign width addr used name   list of local variables
  3885                                  ;  200 var sign byte   627 NULL xxx = bp+4
  3886                                  ;  201 var sign byte   631 NULL len = bp-2;
  3887 00001464 C8020000                 ENTER  2,0
  3888 00001468 B80000                   mov ax, 0
  3889 0000146B 8846FE                   mov [bp-2], al
  3890                                  
  3891                                  ;-633     xxx = xxx << 3;//in reg/opcode field
  3892                                  
  3893 0000146E 8A4604                   mov al, [bp+4]
  3894 00001471 C0E003                   shl al, 3
  3895 00001474 884604                   mov [bp+4], al
  3896                                  
  3897                                  ;-634     if (Op == REG) {
  3898                                  
  3899 00001477 A0[2D00]                 mov al, [Op]
  3900 0000147A 3C02                     cmp al, 2
  3901 0000147C 0F853A00                 jne .writeEA111
  3902                                  
  3903                                  ;-635         xxx |= 0xC0;
  3904                                  
  3905 00001480 804E04C0                 or  byte[bp+4], 192
  3906                                  
  3907                                  ;-636         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM
  3908                                  
  3909 00001484 A0[2E00]                 mov al, [Op2]
  3910 00001487 3C01                     cmp al, 1
  3911 00001489 0F8F0D00                 jg  .writeEA112
  3912 0000148D 8A4604                   mov al, [bp+4]
  3913 00001490 0206[3400]               add al, [R1No]
  3914 00001494 884604                   mov [bp+4], al
  3915                                  
  3916                                  ;-637             else {
  3917                                  
  3918 00001497 E92000                   jmp .writeEA113
  3919                                  .writeEA112:
  3920                                  
  3921                                  ;-638                 if (Op2 == REG) xxx = xxx + R1No;
  3922                                  
  3923 0000149A A0[2E00]                 mov al, [Op2]
  3924 0000149D 3C02                     cmp al, 2
  3925 0000149F 0F850D00                 jne .writeEA114
  3926 000014A3 8A4604                   mov al, [bp+4]
  3927 000014A6 0206[3400]               add al, [R1No]
  3928 000014AA 884604                   mov [bp+4], al
  3929                                  
  3930                                  ;-639                 else            xxx = xxx + R2No;
  3931                                  
  3932 000014AD E90A00                   jmp .writeEA115
  3933                                  .writeEA114:
  3934 000014B0 8A4604                   mov al, [bp+4]
  3935 000014B3 0206[3300]               add al, [R2No]
  3936 000014B7 884604                   mov [bp+4], al
  3937                                  
  3938                                  ;-640             }
  3939                                  
  3940                                  .writeEA115:
  3941                                  
  3942                                  ;-641         }
  3943                                  
  3944                                  .writeEA113:
  3945                                  
  3946                                  ;-642     if (Op == MEM) {
  3947                                  
  3948                                  .writeEA111:
  3949 000014BA A0[2D00]                 mov al, [Op]
  3950 000014BD 3C04                     cmp al, 4
  3951 000014BF 0F857C00                 jne .writeEA116
  3952                                  
  3953                                  ;-643         if (isDirect) {
  3954                                  
  3955 000014C3 A0[3C00]                 mov al, [isDirect]
  3956 000014C6 08C0                     or  al, al
  3957 000014C8 0F840D00                 je .writeEA117
  3958                                  
  3959                                  ;-644             xxx |= 6;
  3960                                  
  3961 000014CC 804E0406                 or  byte[bp+4], 6
  3962                                  
  3963                                  ;-645             len = 2;
  3964                                  
  3965 000014D0 B80200                   mov ax, 2
  3966 000014D3 8846FE                   mov [bp-2], al
  3967                                  
  3968                                  ;-646         }
  3969                                  
  3970                                  
  3971                                  ;-647         else {
  3972                                  
  3973 000014D6 E96600                   jmp .writeEA118
  3974                                  .writeEA117:
  3975                                  
  3976                                  ;-648             xxx = xxx + rm;
  3977                                  
  3978 000014D9 8A4604                   mov al, [bp+4]
  3979 000014DC 0206[3B00]               add al, [rm]
  3980 000014E0 884604                   mov [bp+4], al
  3981                                  
  3982                                  ;-649             if (rm == 6) {//make [BP+00]
  3983                                  
  3984 000014E3 A0[3B00]                 mov al, [rm]
  3985 000014E6 3C06                     cmp al, 6
  3986 000014E8 0F851400                 jne .writeEA119
  3987                                  
  3988                                  ;-650                 len=1;
  3989                                  
  3990 000014EC B80100                   mov ax, 1
  3991 000014EF 8846FE                   mov [bp-2], al
  3992                                  
  3993                                  ;-651                 if (disp == 0) xxx |= 0x40;
  3994                                  
  3995 000014F2 A1[3D00]                 mov ax, [disp]
  3996 000014F5 83F800                   cmp ax, 0
  3997 000014F8 0F850400                 jne .writeEA120
  3998 000014FC 804E0440                 or  byte[bp+4], 64
  3999                                  
  4000                                  ;-652             }
  4001                                  
  4002                                  .writeEA120:
  4003                                  
  4004                                  ;-653 
  4005                                  
  4006                                  
  4007                                  ;-654             if (disp) {  
  4008                                  
  4009                                  .writeEA119:
  4010 00001500 A1[3D00]                 mov ax, [disp]
  4011 00001503 08C0                     or  al, al
  4012 00001505 0F843600                 je .writeEA121
  4013                                  
  4014                                  ;-655                 ax = disp;
  4015                                  
  4016 00001509 A1[3D00]                 mov  ax, [disp]
  4017                                  
  4018                                  ;-656                 if (ax < 0) __asm{ neg ax }
  4019                                  
  4020 0000150C 83F800                   cmp  ax, 0
  4021 0000150F 0F8D0200                 jge .writeEA122
  4022 00001513 F7D8                     neg ax 
  4023                                  
  4024                                  ;-657                 if (ax > 127) len=2;
  4025                                  
  4026                                  .writeEA122:
  4027 00001515 83F87F                   cmp  ax, 127
  4028 00001518 0F8E0900                 jle .writeEA123
  4029 0000151C B80200                   mov ax, 2
  4030 0000151F 8846FE                   mov [bp-2], al
  4031                                  
  4032                                  ;-658                 else len=1;
  4033                                  
  4034 00001522 E90600                   jmp .writeEA124
  4035                                  .writeEA123:
  4036 00001525 B80100                   mov ax, 1
  4037 00001528 8846FE                   mov [bp-2], al
  4038                                  
  4039                                  ;-659                 if (len == 1) xxx |= 0x40;
  4040                                  
  4041                                  .writeEA124:
  4042 0000152B 8A46FE                   mov al, [bp-2]
  4043 0000152E 3C01                     cmp al, 1
  4044 00001530 0F850700                 jne .writeEA125
  4045 00001534 804E0440                 or  byte[bp+4], 64
  4046                                  
  4047                                  ;-660                 else xxx |= 0x80;
  4048                                  
  4049 00001538 E90400                   jmp .writeEA126
  4050                                  .writeEA125:
  4051 0000153B 804E0480                 or  byte[bp+4], 128
  4052                                  
  4053                                  ;-661             }
  4054                                  
  4055                                  .writeEA126:
  4056                                  
  4057                                  ;-662         }
  4058                                  
  4059                                  .writeEA121:
  4060                                  
  4061                                  ;-663     }
  4062                                  
  4063                                  .writeEA118:
  4064                                  
  4065                                  ;-664 
  4066                                  
  4067                                  
  4068                                  ;-665     genCode8(xxx);// gen second byte
  4069                                  
  4070                                  .writeEA116:
  4071 0000153F 8A4604                   mov al, byte [bp+4]
  4072 00001542 B400                     mov ah, 0
  4073 00001544 50                       push ax
  4074 00001545 E83AFE                   call genCode8
  4075 00001548 83C402                   add  sp, 2
  4076                                  
  4077                                  ;-666     if (len == 1) genCode8 (disp);
  4078                                  
  4079 0000154B 8A46FE                   mov al, [bp-2]
  4080 0000154E 3C01                     cmp al, 1
  4081 00001550 0F850A00                 jne .writeEA127
  4082 00001554 FF36[3D00]               push word [disp]
  4083 00001558 E827FE                   call genCode8
  4084 0000155B 83C402                   add  sp, 2
  4085                                  
  4086                                  ;-667     if (len == 2) genCode16(disp);
  4087                                  
  4088                                  .writeEA127:
  4089 0000155E 8A46FE                   mov al, [bp-2]
  4090 00001561 3C02                     cmp al, 2
  4091 00001563 0F850A00                 jne .writeEA128
  4092 00001567 FF36[3D00]               push word [disp]
  4093 0000156B E8ABFE                   call genCode16
  4094 0000156E 83C402                   add  sp, 2
  4095                                  
  4096                                  ;-668 }
  4097                                  
  4098                                  .writeEA128:
  4099                                  
  4100                                  ;-669 
  4101                                  
  4102                                  
  4103                                  ;-670 int genImmediate() {
  4104 00001571 C9                       LEAVE
  4105 00001572 C3                       ret
  4106                                  ENDP
  4107                                  
  4108                                  genImmediate: PROC
  4109                                  
  4110                                  ;-671     if (wflag) if (OpSize == DWORD) genCode32(imme);
  4111                                  
  4112 00001573 A0[3800]                 mov al, [wflag]
  4113 00001576 08C0                     or  al, al
  4114 00001578 0F842300                 je .genImmediate129
  4115 0000157C A0[3700]                 mov al, [OpSize]
  4116 0000157F 3C03                     cmp al, 3
  4117 00001581 0F850D00                 jne .genImmediate130
  4118 00001585 FF36[3F00]               push word [imme]
  4119 00001589 E8AEFE                   call genCode32
  4120 0000158C 83C402                   add  sp, 2
  4121                                  
  4122                                  ;-672         //todo imme long
  4123                                  
  4124                                  
  4125                                  ;-673         else genCode16(imme);
  4126                                  
  4127 0000158F E90A00                   jmp .genImmediate131
  4128                                  .genImmediate130:
  4129 00001592 FF36[3F00]               push word [imme]
  4130 00001596 E880FE                   call genCode16
  4131 00001599 83C402                   add  sp, 2
  4132                                  
  4133                                  ;-674     else       genCode8 (imme);
  4134                                  
  4135                                  .genImmediate131:
  4136 0000159C E90A00                   jmp .genImmediate132
  4137                                  .genImmediate129:
  4138 0000159F FF36[3F00]               push word [imme]
  4139 000015A3 E8DCFD                   call genCode8
  4140 000015A6 83C402                   add  sp, 2
  4141                                  
  4142                                  ;-675 }
  4143                                  
  4144                                  .genImmediate132:
  4145                                  
  4146                                  ;-676 
  4147                                  
  4148                                  
  4149                                  ;-677 int setwflag() {//word size, bit 0
  4150                                  
  4151 000015A9 C3                       ret
  4152                                  ENDP
  4153                                  
  4154                                  setwflag: PROC
  4155                                  
  4156                                  ;-678     wflag=0;
  4157                                  
  4158 000015AA B80000                   mov ax, 0
  4159 000015AD A2[3800]                 mov byte [wflag], al
  4160                                  
  4161                                  ;-679     if (OpSize == 0) {//do not override OpSize
  4162                                  
  4163 000015B0 A0[3700]                 mov al, [OpSize]
  4164 000015B3 3C00                     cmp al, 0
  4165 000015B5 0F853C00                 jne .setwflag133
  4166                                  
  4167                                  ;-680         if (Op == REG) OpSize=R1Type;
  4168                                  
  4169 000015B9 A0[2D00]                 mov al, [Op]
  4170 000015BC 3C02                     cmp al, 2
  4171 000015BE 0F850600                 jne .setwflag134
  4172 000015C2 A0[3600]                 mov al, [R1Type]
  4173 000015C5 A2[3700]                 mov byte [OpSize], al
  4174                                  
  4175                                  ;-681         if (Op2== REG) OpSize=R2Type;
  4176                                  
  4177                                  .setwflag134:
  4178 000015C8 A0[2E00]                 mov al, [Op2]
  4179 000015CB 3C02                     cmp al, 2
  4180 000015CD 0F850600                 jne .setwflag135
  4181 000015D1 A0[3500]                 mov al, [R2Type]
  4182 000015D4 A2[3700]                 mov byte [OpSize], al
  4183                                  
  4184                                  ;-682         if (R2Type== SEGREG) OpSize=WORD;
  4185                                  
  4186                                  .setwflag135:
  4187 000015D7 A0[3500]                 mov al, [R2Type]
  4188 000015DA 3C04                     cmp al, 4
  4189 000015DC 0F850600                 jne .setwflag136
  4190 000015E0 B80200                   mov ax, 2
  4191 000015E3 A2[3700]                 mov byte [OpSize], al
  4192                                  
  4193                                  ;-683         if (R1Type == SEGREG) OpSize=WORD;
  4194                                  
  4195                                  .setwflag136:
  4196 000015E6 A0[3600]                 mov al, [R1Type]
  4197 000015E9 3C04                     cmp al, 4
  4198 000015EB 0F850600                 jne .setwflag137
  4199 000015EF B80200                   mov ax, 2
  4200 000015F2 A2[3700]                 mov byte [OpSize], al
  4201                                  
  4202                                  ;-684     }
  4203                                  
  4204                                  .setwflag137:
  4205                                  
  4206                                  ;-685     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  4207                                  
  4208                                  .setwflag133:
  4209 000015F5 A0[3700]                 mov al, [OpSize]
  4210 000015F8 3C03                     cmp al, 3
  4211 000015FA 0F850900                 jne .setwflag138
  4212 000015FE E8D8FD                   call gen66h
  4213 00001601 B80100                   mov ax, 1
  4214 00001604 A2[3800]                 mov byte [wflag], al
  4215                                  
  4216                                  ;-686     if (OpSize  ==  WORD) wflag=1;
  4217                                  
  4218                                  .setwflag138:
  4219 00001607 A0[3700]                 mov al, [OpSize]
  4220 0000160A 3C02                     cmp al, 2
  4221 0000160C 0F850600                 jne .setwflag139
  4222 00001610 B80100                   mov ax, 1
  4223 00001613 A2[3800]                 mov byte [wflag], al
  4224                                  
  4225                                  ;-687 }
  4226                                  
  4227                                  .setwflag139:
  4228                                  
  4229                                  ;-688 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3
  4230                                  
  4231 00001616 C3                       ret
  4232                                  ENDP
  4233                                  
  4234                                  setsflag: PROC
  4235                                  
  4236                                  ;-689     unsigned int ui;
  4237                                  
  4238                                  
  4239                                  ;-690     sflag=2;
  4240                                  
  4241                                  ;Function : setsflag, Number of local variables: 1
  4242                                  ;   # type sign width addr used name   list of local variables
  4243                                  ;  200 var unsg word   689 NULL ui = bp-2;
  4244 00001617 C8020000                 ENTER  2,0
  4245 0000161B B80200                   mov ax, 2
  4246 0000161E A2[3A00]                 mov byte [sflag], al
  4247                                  
  4248                                  ;-691     ui = imme & 0xFF80;//is greater than signed 127?
  4249                                  
  4250 00001621 A1[3F00]                 mov ax, [imme]
  4251 00001624 2580FF                   and ax, 65408
  4252 00001627 8946FE                   mov [bp-2], ax
  4253                                  
  4254                                  ;-692     if(ui != 0) sflag = 0;
  4255                                  
  4256 0000162A 8B46FE                   mov ax, [bp-2]
  4257 0000162D 83F800                   cmp ax, 0
  4258 00001630 0F840600                 je  .setsflag140
  4259 00001634 B80000                   mov ax, 0
  4260 00001637 A2[3A00]                 mov byte [sflag], al
  4261                                  
  4262                                  ;-693     if (OpSize == BYTE) {
  4263                                  
  4264                                  .setsflag140:
  4265 0000163A A0[3700]                 mov al, [OpSize]
  4266 0000163D 3C01                     cmp al, 1
  4267 0000163F 0F851900                 jne .setsflag141
  4268                                  
  4269                                  ;-694         if (imme > 255) error1("too big for byte r/m");
  4270                                  
  4271 00001643 A1[3F00]                 mov ax, [imme]
  4272 00001646 3DFF00                   cmp ax, 255
  4273 00001649 0F8E0900                 jle .setsflag142
  4274 0000164D 68[5E16]                 push setsflag_0
  4275 00001650 E8F7F3                   call error1
  4276 00001653 83C402                   add  sp, 2
  4277                                  
  4278                                  ;-695         sflag=0;//byte reg does not need sign extended
  4279                                  
  4280                                  .setsflag142:
  4281 00001656 B80000                   mov ax, 0
  4282 00001659 A2[3A00]                 mov byte [sflag], al
  4283                                  
  4284                                  ;-696     }
  4285                                  
  4286                                  
  4287                                  ;-697 }
  4288                                  
  4289                                  .setsflag141:
  4290                                  
  4291                                  ;-698 int checkConstSize(unsigned int ui) {
  4292 0000165C C9                       LEAVE
  4293 0000165D C3                       ret
  4294 0000165E 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  4295 00001667 6F7220627974652072-
  4296 00001670 2F6D00             
  4297                                  ENDP
  4298                                  
  4299                                  checkConstSize: PROC
  4300                                  
  4301                                  ;-699     if (ui > 127   ) return 0;//is near; return sflag
  4302                                  
  4303                                  ;Function : checkConstSize, Number of local variables: 1
  4304                                  ;   # type sign width addr used name   list of local variables
  4305                                  ;  200 var unsg word   698 NULL ui = bp+4;
  4306 00001673 C8000000                 ENTER  0,0
  4307 00001677 8B4604                   mov ax, [bp+4]
  4308 0000167A 83F87F                   cmp ax, 127
  4309 0000167D 0F8E0600                 jle .checkConstSize143
  4310 00001681 B80000                   mov ax, 0
  4311 00001684 E91600                   jmp .retncheckConstSize
  4312                                  
  4313                                  ;-700     if (ui < 0xFF80) return 0;//-128dez
  4314                                  
  4315                                  .checkConstSize143:
  4316 00001687 8B4604                   mov ax, [bp+4]
  4317 0000168A 3D80FF                   cmp ax, 65408
  4318 0000168D 0F8D0600                 jge .checkConstSize144
  4319 00001691 B80000                   mov ax, 0
  4320 00001694 E90600                   jmp .retncheckConstSize
  4321                                  
  4322                                  ;-701     return 2;// is short
  4323                                  
  4324                                  .checkConstSize144:
  4325 00001697 B80200                   mov ax, 2
  4326 0000169A E90000                   jmp .retncheckConstSize
  4327                                  
  4328                                  ;-702 }
  4329                                  
  4330                                  
  4331                                  ;-703 
  4332                                  
  4333                                  
  4334                                  ;-704 
  4335                                  
  4336                                  
  4337                                  ;-705 int ChangeDirection() {
  4338                                  
  4339 0000169D C9                       .retncheckConstSize: LEAVE
  4340 0000169E C3                       ret
  4341                                  ENDP
  4342                                  
  4343                                  ChangeDirection: PROC
  4344                                  
  4345                                  ;-706     char c;
  4346                                  
  4347                                  
  4348                                  ;-707     c=Op;     Op    =Op2;    Op2   =c;
  4349                                  
  4350                                  ;Function : ChangeDirection, Number of local variables: 1
  4351                                  ;   # type sign width addr used name   list of local variables
  4352                                  ;  200 var sign byte   706 NULL c = bp-2;
  4353 0000169F C8020000                 ENTER  2,0
  4354 000016A3 A0[2D00]                 mov al, [Op]
  4355 000016A6 8846FE                   mov [bp-2], al
  4356 000016A9 A0[2E00]                 mov al, [Op2]
  4357 000016AC A2[2D00]                 mov byte [Op], al
  4358 000016AF 8A46FE                   mov al, [bp-2]
  4359 000016B2 A2[2E00]                 mov byte [Op2], al
  4360                                  
  4361                                  ;-708     c=R1Type; R1Type=R2Type; R2Type=c;
  4362                                  
  4363 000016B5 A0[3600]                 mov al, [R1Type]
  4364 000016B8 8846FE                   mov [bp-2], al
  4365 000016BB A0[3500]                 mov al, [R2Type]
  4366 000016BE A2[3600]                 mov byte [R1Type], al
  4367 000016C1 8A46FE                   mov al, [bp-2]
  4368 000016C4 A2[3500]                 mov byte [R2Type], al
  4369                                  
  4370                                  ;-709     c=R1No;   R1No  =R2No;   R2No  =c;
  4371                                  
  4372 000016C7 A0[3400]                 mov al, [R1No]
  4373 000016CA 8846FE                   mov [bp-2], al
  4374 000016CD A0[3300]                 mov al, [R2No]
  4375 000016D0 A2[3400]                 mov byte [R1No], al
  4376 000016D3 8A46FE                   mov al, [bp-2]
  4377 000016D6 A2[3300]                 mov byte [R2No], al
  4378                                  
  4379                                  ;-710     dflag=2;
  4380                                  
  4381 000016D9 B80200                   mov ax, 2
  4382 000016DC A2[3900]                 mov byte [dflag], al
  4383                                  
  4384                                  ;-711 }
  4385                                  
  4386                                  
  4387                                  ;-712 
  4388                                  
  4389                                  
  4390                                  ;-713 int getTokeType() {
  4391 000016DF C9                       LEAVE
  4392 000016E0 C3                       ret
  4393                                  ENDP
  4394                                  
  4395                                  getTokeType: PROC
  4396                                  
  4397                                  ;-714     char c;
  4398                                  
  4399                                  
  4400                                  ;-715     skipBlank();
  4401                                  
  4402                                  ;Function : getTokeType, Number of local variables: 1
  4403                                  ;   # type sign width addr used name   list of local variables
  4404                                  ;  200 var sign byte   714 NULL c = bp-2;
  4405 000016E1 C8020000                 ENTER  2,0
  4406 000016E5 E8F7F6                   call skipBlank
  4407                                  
  4408                                  ;-716     c = *InputPtr;
  4409                                  
  4410 000016E8 8B1E[1400]               mov bx, [InputPtr]
  4411 000016EC 8A07                     mov al, [bx]
  4412 000016EE B400                     mov ah, 0
  4413 000016F0 8846FE                   mov [bp-2], al
  4414                                  
  4415                                  ;-717     if (c == 0)   {TokeType=0; return; }//last line or empty line
  4416                                  
  4417 000016F3 8A46FE                   mov al, [bp-2]
  4418 000016F6 3C00                     cmp al, 0
  4419 000016F8 0F850900                 jne .getTokeType145
  4420 000016FC B80000                   mov ax, 0
  4421 000016FF A2[2C00]                 mov byte [TokeType], al
  4422 00001702 E96600                   jmp .retngetTokeType
  4423                                  
  4424                                  ;-718     if (c == ';') {TokeType=0; return; }//comment
  4425                                  
  4426                                  .getTokeType145:
  4427 00001705 8A46FE                   mov al, [bp-2]
  4428 00001708 3C3B                     cmp al, 59
  4429 0000170A 0F850900                 jne .getTokeType146
  4430 0000170E B80000                   mov ax, 0
  4431 00001711 A2[2C00]                 mov byte [TokeType], al
  4432 00001714 E95400                   jmp .retngetTokeType
  4433                                  
  4434                                  ;-719     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  4435                                  
  4436                                  .getTokeType146:
  4437 00001717 8A46FE                   mov al, byte [bp-2]
  4438 0000171A B400                     mov ah, 0
  4439 0000171C 50                       push ax
  4440 0000171D E87CEA                   call digit
  4441 00001720 83C402                   add  sp, 2
  4442 00001723 08C0                     or  al, al
  4443 00001725 0F841500                 je .getTokeType147
  4444 00001729 8A46FE                   mov al, byte [bp-2]
  4445 0000172C B400                     mov ah, 0
  4446 0000172E 50                       push ax
  4447 0000172F E8D8F6                   call getDigit
  4448 00001732 83C402                   add  sp, 2
  4449 00001735 B80100                   mov ax, 1
  4450 00001738 A2[2C00]                 mov byte [TokeType], al
  4451 0000173B E92D00                   jmp .retngetTokeType
  4452                                  
  4453                                  ;-720     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  4454                                  
  4455                                  .getTokeType147:
  4456 0000173E 8A46FE                   mov al, byte [bp-2]
  4457 00001741 B400                     mov ah, 0
  4458 00001743 50                       push ax
  4459 00001744 E8D7E9                   call letterE
  4460 00001747 83C402                   add  sp, 2
  4461 0000174A 08C0                     or  al, al
  4462 0000174C 0F841500                 je .getTokeType148
  4463 00001750 8A46FE                   mov al, byte [bp-2]
  4464 00001753 B400                     mov ah, 0
  4465 00001755 50                       push ax
  4466 00001756 E801F7                   call getName
  4467 00001759 83C402                   add  sp, 2
  4468 0000175C B80300                   mov ax, 3
  4469 0000175F A2[2C00]                 mov byte [TokeType], al
  4470 00001762 E90600                   jmp .retngetTokeType
  4471                                  
  4472                                  ;-721     TokeType=NOALNUME;
  4473                                  
  4474                                  .getTokeType148:
  4475 00001765 B80400                   mov ax, 4
  4476 00001768 A2[2C00]                 mov byte [TokeType], al
  4477                                  
  4478                                  ;-722 }
  4479                                  
  4480                                  
  4481                                  ;-723 
  4482                                  
  4483                                  
  4484                                  ;-724 int isToken(char c) {
  4485                                  
  4486 0000176B C9                       .retngetTokeType: LEAVE
  4487 0000176C C3                       ret
  4488                                  ENDP
  4489                                  
  4490                                  isToken: PROC
  4491                                  
  4492                                  ;-725     skipBlank();
  4493                                  
  4494                                  ;Function : isToken, Number of local variables: 1
  4495                                  ;   # type sign width addr used name   list of local variables
  4496                                  ;  200 var sign byte   724 NULL c = bp+4;
  4497 0000176D C8000000                 ENTER  0,0
  4498 00001771 E86BF6                   call skipBlank
  4499                                  
  4500                                  ;-726     if (*InputPtr == c) {
  4501                                  
  4502 00001774 8B1E[1400]               mov bx, [InputPtr]
  4503 00001778 8A07                     mov al, [bx]
  4504 0000177A B400                     mov ah, 0
  4505 0000177C 3A4604                   cmp al, [bp+4]
  4506 0000177F 0F850A00                 jne .isToken149
  4507                                  
  4508                                  ;-727         InputPtr++;
  4509                                  
  4510 00001783 FF06[1400]               inc  word[InputPtr]
  4511                                  
  4512                                  ;-728         return 1;
  4513                                  
  4514 00001787 B80100                   mov ax, 1
  4515 0000178A E90600                   jmp .retnisToken
  4516                                  
  4517                                  ;-729         }
  4518                                  
  4519                                  
  4520                                  ;-730     return 0;
  4521                                  
  4522                                  .isToken149:
  4523 0000178D B80000                   mov ax, 0
  4524 00001790 E90000                   jmp .retnisToken
  4525                                  
  4526                                  ;-731 }
  4527                                  
  4528                                  
  4529                                  ;-732 
  4530                                  
  4531                                  
  4532                                  ;-733 
  4533                                  
  4534                                  
  4535                                  ;-734 int need(char c) {
  4536                                  
  4537 00001793 C9                       .retnisToken: LEAVE
  4538 00001794 C3                       ret
  4539                                  ENDP
  4540                                  
  4541                                  need: PROC
  4542                                  
  4543                                  ;-735     if (isToken(c)) {
  4544                                  
  4545                                  ;Function : need, Number of local variables: 1
  4546                                  ;   # type sign width addr used name   list of local variables
  4547                                  ;  200 var sign byte   734 NULL c = bp+4;
  4548 00001795 C8000000                 ENTER  0,0
  4549 00001799 8A4604                   mov al, byte [bp+4]
  4550 0000179C B400                     mov ah, 0
  4551 0000179E 50                       push ax
  4552 0000179F E8CBFF                   call isToken
  4553 000017A2 83C402                   add  sp, 2
  4554 000017A5 08C0                     or  al, al
  4555 000017A7 0F840600                 je .need150
  4556                                  
  4557                                  ;-736         getTokeType();
  4558                                  
  4559 000017AB E833FF                   call getTokeType
  4560                                  
  4561                                  ;-737         return;
  4562                                  
  4563 000017AE E91800                   jmp .retnneed
  4564                                  
  4565                                  ;-738         }
  4566                                  
  4567                                  
  4568                                  ;-739     error1();
  4569                                  
  4570                                  .need150:
  4571 000017B1 E896F2                   call error1
  4572                                  
  4573                                  ;-740     prs(". need: ");
  4574                                  
  4575 000017B4 68[CB17]                 push need_0
  4576 000017B7 E879EF                   call prs
  4577 000017BA 83C402                   add  sp, 2
  4578                                  
  4579                                  ;-741     prc(c);
  4580                                  
  4581 000017BD 8A4604                   mov al, byte [bp+4]
  4582 000017C0 B400                     mov ah, 0
  4583 000017C2 50                       push ax
  4584 000017C3 E815EF                   call prc
  4585 000017C6 83C402                   add  sp, 2
  4586                                  
  4587                                  ;-742 }
  4588                                  
  4589                                  
  4590                                  ;-743 int skipRest() {
  4591                                  
  4592 000017C9 C9                       .retnneed: LEAVE
  4593 000017CA C3                       ret
  4594 000017CB 2E206E6565643A2000      need_0 db ". need: ",0
  4595                                  ENDP
  4596                                  
  4597                                  skipRest: PROC
  4598                                  
  4599                                  ;-744     getTokeType();
  4600                                  
  4601 000017D4 E80AFF                   call getTokeType
  4602                                  
  4603                                  ;-745     if(TokeType)error1("extra char ignored");
  4604                                  
  4605 000017D7 A0[2C00]                 mov al, [TokeType]
  4606 000017DA 08C0                     or  al, al
  4607 000017DC 0F840900                 je .skipRest151
  4608 000017E0 68[EA17]                 push skipRest_0
  4609 000017E3 E864F2                   call error1
  4610 000017E6 83C402                   add  sp, 2
  4611                                  
  4612                                  ;-746 }
  4613                                  
  4614                                  .skipRest151:
  4615                                  
  4616                                  ;-747 
  4617                                  
  4618                                  
  4619                                  ;-748 
  4620                                  
  4621                                  
  4622                                  ;-749 int checkOpL() {
  4623                                  
  4624 000017E9 C3                       ret
  4625 000017EA 657874726120636861-     skipRest_0 db "extra char ignored",0
  4626 000017F3 722069676E6F726564-
  4627 000017FC 00                 
  4628                                  ENDP
  4629                                  
  4630                                  checkOpL: PROC
  4631                                  
  4632                                  ;-750     if (Op == ADR) implerror();
  4633                                  
  4634 000017FD A0[2D00]                 mov al, [Op]
  4635 00001800 3C03                     cmp al, 3
  4636 00001802 0F850300                 jne .checkOpL152
  4637 00001806 E853F3                   call implerror
  4638                                  
  4639                                  ;-751     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
  4640                                  
  4641                                  .checkOpL152:
  4642 00001809 A0[3600]                 mov al, [R1Type]
  4643 0000180C 3C04                     cmp al, 4
  4644 0000180E 0F850600                 jne .checkOpL153
  4645 00001812 E80FF4                   call segregerror
  4646 00001815 E93E00                   jmp .retncheckOpL
  4647                                  
  4648                                  ;-752     setwflag();
  4649                                  
  4650                                  .checkOpL153:
  4651 00001818 E88FFD                   call setwflag
  4652                                  
  4653                                  ;-753     if (OpSize == 0) error1("no op size declared");
  4654                                  
  4655 0000181B A0[3700]                 mov al, [OpSize]
  4656 0000181E 3C00                     cmp al, 0
  4657 00001820 0F850900                 jne .checkOpL154
  4658 00001824 68[5718]                 push checkOpL_0
  4659 00001827 E820F2                   call error1
  4660 0000182A 83C402                   add  sp, 2
  4661                                  
  4662                                  ;-754     if (OpSize == R1Type) return;
  4663                                  
  4664                                  .checkOpL154:
  4665 0000182D A0[3700]                 mov al, [OpSize]
  4666 00001830 3A06[3600]               cmp al, [R1Type]
  4667 00001834 0F850300                 jne .checkOpL155
  4668 00001838 E91B00                   jmp .retncheckOpL
  4669                                  
  4670                                  ;-755     if (Op == REG) if (R1Type==0) error1("no register defined");
  4671                                  
  4672                                  .checkOpL155:
  4673 0000183B A0[2D00]                 mov al, [Op]
  4674 0000183E 3C02                     cmp al, 2
  4675 00001840 0F851200                 jne .checkOpL156
  4676 00001844 A0[3600]                 mov al, [R1Type]
  4677 00001847 3C00                     cmp al, 0
  4678 00001849 0F850900                 jne .checkOpL157
  4679 0000184D 68[6B18]                 push checkOpL_1
  4680 00001850 E8F7F1                   call error1
  4681 00001853 83C402                   add  sp, 2
  4682                                  
  4683                                  ;-756 }
  4684                                  
  4685                                  .checkOpL157:
  4686                                  .checkOpL156:
  4687                                  
  4688                                  ;-757 
  4689                                  
  4690                                  
  4691                                  ;-758 int searchLabel() {
  4692                                  
  4693                                   .retncheckOpL:
  4694 00001856 C3                       ret
  4695 00001857 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  4696 00001860 65206465636C617265-
  4697 00001869 6400               
  4698 0000186B 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  4699 00001874 657220646566696E65-
  4700 0000187D 6400               
  4701                                  ENDP
  4702                                  
  4703                                  searchLabel: PROC
  4704                                  
  4705                                  ;-759     int LIx; char *p;
  4706                                  
  4707                                  
  4708                                  ;-760     p = &LabelNames;
  4709                                  
  4710                                  ;Function : searchLabel, Number of local variables: 2
  4711                                  ;   # type sign width addr used name   list of local variables
  4712                                  ;  200 var sign word   759 NULL LIx = bp-2
  4713                                  ;  201 ptr sign byte   759 NULL p = bp-4;
  4714 0000187F C8040000                 ENTER  4,0
  4715 00001883 B85A77                   mov ax, LabelNames
  4716 00001886 8946FC                   mov [bp-4], ax
  4717                                  
  4718                                  ;-761     LIx = 1;
  4719                                  
  4720 00001889 B80100                   mov ax, 1
  4721 0000188C 8946FE                   mov [bp-2], ax
  4722                                  
  4723                                  ;-762     while (LIx <= LabelMaxIx) {
  4724                                  
  4725                                  .searchLabel158:
  4726 0000188F 8B46FE                   mov ax, [bp-2]
  4727 00001892 3B06[4A00]               cmp ax, [LabelMaxIx]
  4728 00001896 0F8F3100                 jg  .searchLabel159
  4729                                  
  4730                                  ;-763         if (eqstr(p, Symbol)) return LIx;//pos of label
  4731                                  
  4732 0000189A 8D063075                 lea  ax, [Symbol]
  4733 0000189E 50                       push ax
  4734 0000189F FF76FC                   push word [bp-4]
  4735 000018A2 E8BBE9                   call eqstr
  4736 000018A5 83C404                   add  sp, 4
  4737 000018A8 08C0                     or  al, al
  4738 000018AA 0F840600                 je .searchLabel160
  4739 000018AE 8B46FE                   mov ax, [bp-2]
  4740 000018B1 E91D00                   jmp .retnsearchLabel
  4741                                  
  4742                                  ;-764         p=strlen(p) + p;
  4743                                  
  4744                                  .searchLabel160:
  4745 000018B4 FF76FC                   push word [bp-4]
  4746 000018B7 E848E9                   call strlen
  4747 000018BA 83C402                   add  sp, 2
  4748 000018BD 0346FC                   add ax, [bp-4]
  4749 000018C0 8946FC                   mov [bp-4], ax
  4750                                  
  4751                                  ;-765         p++;
  4752                                  
  4753 000018C3 FF46FC                   inc  word[bp-4]
  4754                                  
  4755                                  ;-766         LIx++;
  4756                                  
  4757 000018C6 FF46FE                   inc  word[bp-2]
  4758                                  
  4759                                  ;-767     }
  4760                                  
  4761                                  
  4762                                  ;-768     return 0;
  4763                                  
  4764 000018C9 EBC4                     jmp .searchLabel158
  4765                                  .searchLabel159:
  4766 000018CB B80000                   mov ax, 0
  4767 000018CE E90000                   jmp .retnsearchLabel
  4768                                  
  4769                                  ;-769 }
  4770                                  
  4771                                  
  4772                                  ;-770 
  4773                                  
  4774                                  
  4775                                  ;-771 int getOp1() {//scan for a single operand
  4776                                  
  4777 000018D1 C9                       .retnsearchLabel: LEAVE
  4778 000018D2 C3                       ret
  4779                                  ENDP
  4780                                  
  4781                                  getOp1: PROC
  4782                                  
  4783                                  ;-772 //return:0, IMM, REG, ADR (not MEM)
  4784                                  
  4785                                  
  4786                                  ;-773 //set   :R2Type, R2No by testReg
  4787                                  
  4788                                  
  4789                                  ;-774 //set   :LabelIx by searchLabel
  4790                                  
  4791                                  
  4792                                  ;-775     if (TokeType == 0)      return 0;
  4793                                  
  4794 000018D3 A0[2C00]                 mov al, [TokeType]
  4795 000018D6 3C00                     cmp al, 0
  4796 000018D8 0F850600                 jne .getOp1161
  4797 000018DC B80000                   mov ax, 0
  4798 000018DF E93F00                   jmp .retngetOp1
  4799                                  
  4800                                  ;-776     if (TokeType == DIGIT)  return IMM;
  4801                                  
  4802                                  .getOp1161:
  4803 000018E2 A0[2C00]                 mov al, [TokeType]
  4804 000018E5 3C01                     cmp al, 1
  4805 000018E7 0F850600                 jne .getOp1162
  4806 000018EB B80100                   mov ax, 1
  4807 000018EE E93000                   jmp .retngetOp1
  4808                                  
  4809                                  ;-777     if (TokeType == ALNUME) {
  4810                                  
  4811                                  .getOp1162:
  4812 000018F1 A0[2C00]                 mov al, [TokeType]
  4813 000018F4 3C03                     cmp al, 3
  4814 000018F6 0F852100                 jne .getOp1163
  4815                                  
  4816                                  ;-778         R2No=testReg();
  4817                                  
  4818 000018FA E817EA                   call testReg
  4819 000018FD A2[3300]                 mov byte [R2No], al
  4820                                  
  4821                                  ;-779         if (R2Type)        return REG;
  4822                                  
  4823 00001900 A0[3500]                 mov al, [R2Type]
  4824 00001903 08C0                     or  al, al
  4825 00001905 0F840600                 je .getOp1164
  4826 00001909 B80200                   mov ax, 2
  4827 0000190C E91200                   jmp .retngetOp1
  4828                                  
  4829                                  ;-780         LabelIx=searchLabel();
  4830                                  
  4831                                  .getOp1164:
  4832 0000190F E86DFF                   call searchLabel
  4833 00001912 A3[4E00]                 mov word [LabelIx], ax
  4834                                  
  4835                                  ;-781         return ADR;
  4836                                  
  4837 00001915 B80300                   mov ax, 3
  4838 00001918 E90600                   jmp .retngetOp1
  4839                                  
  4840                                  ;-782     }
  4841                                  
  4842                                  
  4843                                  ;-783     return 0;
  4844                                  
  4845                                  .getOp1163:
  4846 0000191B B80000                   mov ax, 0
  4847 0000191E E90000                   jmp .retngetOp1
  4848                                  
  4849                                  ;-784 }
  4850                                  
  4851                                  
  4852                                  ;-785 
  4853                                  
  4854                                  
  4855                                  ;-786 int getIndReg1() {
  4856                                  
  4857                                   .retngetOp1:
  4858 00001921 C3                       ret
  4859                                  ENDP
  4860                                  
  4861                                  getIndReg1: PROC
  4862                                  
  4863                                  ;-787     if (R2Type !=WORD) indexerror();
  4864                                  
  4865 00001922 A0[3500]                 mov al, [R2Type]
  4866 00001925 3C02                     cmp al, 2
  4867 00001927 0F840300                 je  .getIndReg1165
  4868 0000192B E848F2                   call indexerror
  4869                                  
  4870                                  ;-788     if (R2No==3) rm=7;//BX
  4871                                  
  4872                                  .getIndReg1165:
  4873 0000192E A0[3300]                 mov al, [R2No]
  4874 00001931 3C03                     cmp al, 3
  4875 00001933 0F850600                 jne .getIndReg1166
  4876 00001937 B80700                   mov ax, 7
  4877 0000193A A2[3B00]                 mov byte [rm], al
  4878                                  
  4879                                  ;-789     if (R2No==5) rm=6;//BP, change to BP+0
  4880                                  
  4881                                  .getIndReg1166:
  4882 0000193D A0[3300]                 mov al, [R2No]
  4883 00001940 3C05                     cmp al, 5
  4884 00001942 0F850600                 jne .getIndReg1167
  4885 00001946 B80600                   mov ax, 6
  4886 00001949 A2[3B00]                 mov byte [rm], al
  4887                                  
  4888                                  ;-790     if (R2No==7) rm=5;//DI
  4889                                  
  4890                                  .getIndReg1167:
  4891 0000194C A0[3300]                 mov al, [R2No]
  4892 0000194F 3C07                     cmp al, 7
  4893 00001951 0F850600                 jne .getIndReg1168
  4894 00001955 B80500                   mov ax, 5
  4895 00001958 A2[3B00]                 mov byte [rm], al
  4896                                  
  4897                                  ;-791     if (R2No==6) rm=4;//SI
  4898                                  
  4899                                  .getIndReg1168:
  4900 0000195B A0[3300]                 mov al, [R2No]
  4901 0000195E 3C06                     cmp al, 6
  4902 00001960 0F850600                 jne .getIndReg1169
  4903 00001964 B80400                   mov ax, 4
  4904 00001967 A2[3B00]                 mov byte [rm], al
  4905                                  
  4906                                  ;-792     if (rm==0) indexerror();
  4907                                  
  4908                                  .getIndReg1169:
  4909 0000196A A0[3B00]                 mov al, [rm]
  4910 0000196D 3C00                     cmp al, 0
  4911 0000196F 0F850300                 jne .getIndReg1170
  4912 00001973 E800F2                   call indexerror
  4913                                  
  4914                                  ;-793 }
  4915                                  
  4916                                  .getIndReg1170:
  4917                                  
  4918                                  ;-794 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  4919                                  
  4920 00001976 C3                       ret
  4921                                  ENDP
  4922                                  
  4923                                  getIndReg2: PROC
  4924                                  ;Function : getIndReg2, Number of local variables: 1
  4925                                  ;   # type sign width addr used name   list of local variables
  4926                                  ;  200 var sign byte   794 NULL m = bp-2;
  4927 00001977 C8020000                 ENTER  2,0
  4928 0000197B B80400                   mov ax, 4
  4929 0000197E 8846FE                   mov [bp-2], al
  4930                                  
  4931                                  ;-795     if (R2Type !=WORD) indexerror();
  4932                                  
  4933 00001981 A0[3500]                 mov al, [R2Type]
  4934 00001984 3C02                     cmp al, 2
  4935 00001986 0F840300                 je  .getIndReg2171
  4936 0000198A E8E9F1                   call indexerror
  4937                                  
  4938                                  ;-796     if (R2No==7) if (rm==6) m=3;//BP+DI
  4939                                  
  4940                                  .getIndReg2171:
  4941 0000198D A0[3300]                 mov al, [R2No]
  4942 00001990 3C07                     cmp al, 7
  4943 00001992 0F852100                 jne .getIndReg2172
  4944 00001996 A0[3B00]                 mov al, [rm]
  4945 00001999 3C06                     cmp al, 6
  4946 0000199B 0F850900                 jne .getIndReg2173
  4947 0000199F B80300                   mov ax, 3
  4948 000019A2 8846FE                   mov [bp-2], al
  4949                                  
  4950                                  ;-797              else if (rm==7) m=1;//BX+DI
  4951                                  
  4952 000019A5 E90F00                   jmp .getIndReg2174
  4953                                  .getIndReg2173:
  4954 000019A8 A0[3B00]                 mov al, [rm]
  4955 000019AB 3C07                     cmp al, 7
  4956 000019AD 0F850600                 jne .getIndReg2175
  4957 000019B1 B80100                   mov ax, 1
  4958 000019B4 8846FE                   mov [bp-2], al
  4959                                  
  4960                                  ;-798     if (R2No==6) if (rm==6) m=2;//BP+SI
  4961                                  
  4962                                  .getIndReg2175:
  4963                                  .getIndReg2174:
  4964                                  .getIndReg2172:
  4965 000019B7 A0[3300]                 mov al, [R2No]
  4966 000019BA 3C06                     cmp al, 6
  4967 000019BC 0F852100                 jne .getIndReg2176
  4968 000019C0 A0[3B00]                 mov al, [rm]
  4969 000019C3 3C06                     cmp al, 6
  4970 000019C5 0F850900                 jne .getIndReg2177
  4971 000019C9 B80200                   mov ax, 2
  4972 000019CC 8846FE                   mov [bp-2], al
  4973                                  
  4974                                  ;-799              else if (rm==7) m=0;//BX+SI
  4975                                  
  4976 000019CF E90F00                   jmp .getIndReg2178
  4977                                  .getIndReg2177:
  4978 000019D2 A0[3B00]                 mov al, [rm]
  4979 000019D5 3C07                     cmp al, 7
  4980 000019D7 0F850600                 jne .getIndReg2179
  4981 000019DB B80000                   mov ax, 0
  4982 000019DE 8846FE                   mov [bp-2], al
  4983                                  
  4984                                  ;-800     if (m > 3) indexerror();
  4985                                  
  4986                                  .getIndReg2179:
  4987                                  .getIndReg2178:
  4988                                  .getIndReg2176:
  4989 000019E1 8A46FE                   mov al, [bp-2]
  4990 000019E4 3C03                     cmp al, 3
  4991 000019E6 0F8E0300                 jle .getIndReg2180
  4992 000019EA E889F1                   call indexerror
  4993                                  
  4994                                  ;-801     return m;
  4995                                  
  4996                                  .getIndReg2180:
  4997 000019ED 8A46FE                   mov al, [bp-2]
  4998 000019F0 E90000                   jmp .retngetIndReg2
  4999                                  
  5000                                  ;-802 }
  5001                                  
  5002                                  
  5003                                  ;-803 int getMEM() {// e.g. [array+bp+si-4]
  5004                                  
  5005 000019F3 C9                       .retngetIndReg2: LEAVE
  5006 000019F4 C3                       ret
  5007                                  ENDP
  5008                                  
  5009                                  getMEM: PROC
  5010                                  
  5011                                  ;-804 //set: disp, rm, R2Type
  5012                                  
  5013                                  
  5014                                  ;-805     char c;
  5015                                  
  5016                                  
  5017                                  ;-806     disp=0; rm=0;
  5018                                  
  5019                                  ;Function : getMEM, Number of local variables: 1
  5020                                  ;   # type sign width addr used name   list of local variables
  5021                                  ;  200 var sign byte   805 NULL c = bp-2;
  5022 000019F5 C8020000                 ENTER  2,0
  5023 000019F9 B80000                   mov ax, 0
  5024 000019FC A3[3D00]                 mov word [disp], ax
  5025 000019FF B80000                   mov ax, 0
  5026 00001A02 A2[3B00]                 mov byte [rm], al
  5027                                  
  5028                                  ;-807     do {
  5029                                  
  5030                                  .getMEM181:
  5031                                  
  5032                                  ;-808         getTokeType();
  5033                                  
  5034 00001A05 E8D9FC                   call getTokeType
  5035                                  
  5036                                  ;-809         c=getOp1();
  5037                                  
  5038 00001A08 E8C8FE                   call getOp1
  5039 00001A0B 8846FE                   mov [bp-2], al
  5040                                  
  5041                                  ;-810         if (c ==   0) syntaxerror();
  5042                                  
  5043 00001A0E 8A46FE                   mov al, [bp-2]
  5044 00001A11 3C00                     cmp al, 0
  5045 00001A13 0F850300                 jne .getMEM182
  5046 00001A17 E831F2                   call syntaxerror
  5047                                  
  5048                                  ;-811         if (c == REG) {
  5049                                  
  5050                                  .getMEM182:
  5051 00001A1A 8A46FE                   mov al, [bp-2]
  5052 00001A1D 3C02                     cmp al, 2
  5053 00001A1F 0F851B00                 jne .getMEM183
  5054                                  
  5055                                  ;-812             isDirect=0;
  5056                                  
  5057 00001A23 B80000                   mov ax, 0
  5058 00001A26 A2[3C00]                 mov byte [isDirect], al
  5059                                  
  5060                                  ;-813             if (rm) rm=getIndReg2();
  5061                                  
  5062 00001A29 A0[3B00]                 mov al, [rm]
  5063 00001A2C 08C0                     or  al, al
  5064 00001A2E 0F840900                 je .getMEM184
  5065 00001A32 E842FF                   call getIndReg2
  5066 00001A35 A2[3B00]                 mov byte [rm], al
  5067                                  
  5068                                  ;-814             else getIndReg1();
  5069                                  
  5070 00001A38 E90300                   jmp .getMEM185
  5071                                  .getMEM184:
  5072 00001A3B E8E4FE                   call getIndReg1
  5073                                  
  5074                                  ;-815         }
  5075                                  
  5076                                  .getMEM185:
  5077                                  
  5078                                  ;-816         if (c == ADR) {
  5079                                  
  5080                                  .getMEM183:
  5081 00001A3E 8A46FE                   mov al, [bp-2]
  5082 00001A41 3C03                     cmp al, 3
  5083 00001A43 0F851F00                 jne .getMEM186
  5084                                  
  5085                                  ;-817             if (LabelIx)    disp=disp+LabelAddr[LabelIx];
  5086                                  
  5087 00001A47 A1[4E00]                 mov ax, [LabelIx]
  5088 00001A4A 08C0                     or  al, al
  5089 00001A4C 0F841300                 je .getMEM187
  5090 00001A50 A1[3D00]                 mov ax, [disp]
  5091 00001A53 8B1E[4E00]               mov bx, [LabelIx]
  5092 00001A57 D1E3                     shl bx, 1
  5093 00001A59 0387CA8E                 add ax, [LabelAddr + bx]
  5094 00001A5D A3[3D00]                 mov word [disp], ax
  5095                                  
  5096                                  ;-818             else notfounderror();
  5097                                  
  5098 00001A60 E90300                   jmp .getMEM188
  5099                                  .getMEM187:
  5100 00001A63 E855F0                   call notfounderror
  5101                                  
  5102                                  ;-819         }
  5103                                  
  5104                                  .getMEM188:
  5105                                  
  5106                                  ;-820         if (c == IMM) disp=disp+SymbolInt;
  5107                                  
  5108                                  .getMEM186:
  5109 00001A66 8A46FE                   mov al, [bp-2]
  5110 00001A69 3C01                     cmp al, 1
  5111 00001A6B 0F850A00                 jne .getMEM189
  5112 00001A6F A1[3D00]                 mov ax, [disp]
  5113 00001A72 0306[0E00]               add ax, [SymbolInt]
  5114 00001A76 A3[3D00]                 mov word [disp], ax
  5115                                  
  5116                                  ;-821         if (isToken('-')) {
  5117                                  
  5118                                  .getMEM189:
  5119 00001A79 6A2D                     push 45
  5120 00001A7B E8EFFC                   call isToken
  5121 00001A7E 83C402                   add  sp, 2
  5122 00001A81 08C0                     or  al, al
  5123 00001A83 0F841900                 je .getMEM190
  5124                                  
  5125                                  ;-822             getTokeType();
  5126                                  
  5127 00001A87 E857FC                   call getTokeType
  5128                                  
  5129                                  ;-823             if (TokeType != DIGIT) numbererror();
  5130                                  
  5131 00001A8A A0[2C00]                 mov al, [TokeType]
  5132 00001A8D 3C01                     cmp al, 1
  5133 00001A8F 0F840300                 je  .getMEM191
  5134 00001A93 E822F1                   call numbererror
  5135                                  
  5136                                  ;-824             disp = disp - SymbolInt;
  5137                                  
  5138                                  .getMEM191:
  5139 00001A96 A1[3D00]                 mov ax, [disp]
  5140 00001A99 2B06[0E00]               sub ax, [SymbolInt]
  5141 00001A9D A3[3D00]                 mov word [disp], ax
  5142                                  
  5143                                  ;-825         }
  5144                                  
  5145                                  
  5146                                  ;-826     } while (isToken('+'));
  5147                                  
  5148                                  .getMEM190:
  5149 00001AA0 6A2B                     push 43
  5150 00001AA2 E8C8FC                   call isToken
  5151 00001AA5 83C402                   add  sp, 2
  5152 00001AA8 08C0                     or  al, al
  5153 00001AAA 0F840300                 je .getMEM192
  5154 00001AAE E954FF                   jmp .getMEM181
  5155                                  .getMEM192:
  5156                                  
  5157                                  ;-827     if (isToken(']') == 0) errorexit("] expected");
  5158                                  
  5159 00001AB1 6A5D                     push 93
  5160 00001AB3 E8B7FC                   call isToken
  5161 00001AB6 83C402                   add  sp, 2
  5162 00001AB9 83F800                   cmp ax, 0
  5163 00001ABC 0F850900                 jne .getMEM193
  5164 00001AC0 68[CB1A]                 push getMEM_0
  5165 00001AC3 E8DBEF                   call errorexit
  5166 00001AC6 83C402                   add  sp, 2
  5167                                  
  5168                                  ;-828 }
  5169                                  
  5170                                  .getMEM193:
  5171                                  
  5172                                  ;-829 
  5173                                  
  5174                                  
  5175                                  ;-830 int getOpR() {
  5176 00001AC9 C9                       LEAVE
  5177 00001ACA C3                       ret
  5178 00001ACB 5D2065787065637465-     getMEM_0 db "] expected",0
  5179 00001AD4 6400               
  5180                                  ENDP
  5181                                  
  5182                                  getOpR: PROC
  5183                                  
  5184                                  ;-831     Op2=getOp1();
  5185                                  
  5186 00001AD6 E8FAFD                   call getOp1
  5187 00001AD9 A2[2E00]                 mov byte [Op2], al
  5188                                  
  5189                                  ;-832     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  5190                                  
  5191 00001ADC 6A5B                     push 91
  5192 00001ADE E88CFC                   call isToken
  5193 00001AE1 83C402                   add  sp, 2
  5194 00001AE4 08C0                     or  al, al
  5195 00001AE6 0F840C00                 je .getOpR194
  5196 00001AEA B80400                   mov ax, 4
  5197 00001AED A2[2E00]                 mov byte [Op2], al
  5198 00001AF0 E802FF                   call getMEM
  5199 00001AF3 E96200                   jmp .retngetOpR
  5200                                  
  5201                                  ;-833     if (Op2 == 0)     {invaloperror();         return;}
  5202                                  
  5203                                  .getOpR194:
  5204 00001AF6 A0[2E00]                 mov al, [Op2]
  5205 00001AF9 3C00                     cmp al, 0
  5206 00001AFB 0F850600                 jne .getOpR195
  5207 00001AFF E895F0                   call invaloperror
  5208 00001B02 E95300                   jmp .retngetOpR
  5209                                  
  5210                                  ;-834     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  5211                                  
  5212                                  .getOpR195:
  5213 00001B05 A0[2E00]                 mov al, [Op2]
  5214 00001B08 3C01                     cmp al, 1
  5215 00001B0A 0F850900                 jne .getOpR196
  5216 00001B0E A1[0E00]                 mov ax, [SymbolInt]
  5217 00001B11 A3[3F00]                 mov word [imme], ax
  5218 00001B14 E94100                   jmp .retngetOpR
  5219                                  
  5220                                  ;-835     if (Op2 == REG)                            return;
  5221                                  
  5222                                  .getOpR196:
  5223 00001B17 A0[2E00]                 mov al, [Op2]
  5224 00001B1A 3C02                     cmp al, 2
  5225 00001B1C 0F850300                 jne .getOpR197
  5226 00001B20 E93500                   jmp .retngetOpR
  5227                                  
  5228                                  ;-836     if (Op2 == ADR)   {
  5229                                  
  5230                                  .getOpR197:
  5231 00001B23 A0[2E00]                 mov al, [Op2]
  5232 00001B26 3C03                     cmp al, 3
  5233 00001B28 0F852300                 jne .getOpR198
  5234                                  
  5235                                  ;-837         if (LabelIx == 0) disp=0;
  5236                                  
  5237 00001B2C A1[4E00]                 mov ax, [LabelIx]
  5238 00001B2F 83F800                   cmp ax, 0
  5239 00001B32 0F850900                 jne .getOpR199
  5240 00001B36 B80000                   mov ax, 0
  5241 00001B39 A3[3D00]                 mov word [disp], ax
  5242                                  
  5243                                  ;-838         else disp=LabelAddr[LabelIx];
  5244                                  
  5245 00001B3C E90D00                   jmp .getOpR200
  5246                                  .getOpR199:
  5247 00001B3F 8B1E[4E00]               mov bx, [LabelIx]
  5248 00001B43 D1E3                     shl bx, 1
  5249 00001B45 8B87CA8E                 mov ax, [LabelAddr + bx]
  5250 00001B49 A3[3D00]                 mov word [disp], ax
  5251                                  
  5252                                  ;-839         return;}
  5253                                  
  5254                                  .getOpR200:
  5255 00001B4C E90900                   jmp .retngetOpR
  5256                                  
  5257                                  ;-840     error1("Name of operand expected");
  5258                                  
  5259                                  .getOpR198:
  5260 00001B4F 68[591B]                 push getOpR_0
  5261 00001B52 E8F5EE                   call error1
  5262 00001B55 83C402                   add  sp, 2
  5263                                  
  5264                                  ;-841 }
  5265                                  
  5266                                  
  5267                                  ;-842 
  5268                                  
  5269                                  
  5270                                  ;-843 int getOpL() {//set: op=0,IMM,REG,ADR,MEM
  5271                                  
  5272                                   .retngetOpR:
  5273 00001B58 C3                       ret
  5274 00001B59 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  5275 00001B62 706572616E64206578-
  5276 00001B6B 70656374656400     
  5277                                  ENDP
  5278                                  
  5279                                  getOpL: PROC
  5280                                  
  5281                                  ;-844     getOpR();
  5282                                  
  5283 00001B72 E861FF                   call getOpR
  5284                                  
  5285                                  ;-845     Op=Op2;         Op2=0;
  5286                                  
  5287 00001B75 A0[2E00]                 mov al, [Op2]
  5288 00001B78 A2[2D00]                 mov byte [Op], al
  5289 00001B7B B80000                   mov ax, 0
  5290 00001B7E A2[2E00]                 mov byte [Op2], al
  5291                                  
  5292                                  ;-846     R1No=R2No;      R2No=0;
  5293                                  
  5294 00001B81 A0[3300]                 mov al, [R2No]
  5295 00001B84 A2[3400]                 mov byte [R1No], al
  5296 00001B87 B80000                   mov ax, 0
  5297 00001B8A A2[3300]                 mov byte [R2No], al
  5298                                  
  5299                                  ;-847     R1Type=R2Type;  R2Type=0;
  5300                                  
  5301 00001B8D A0[3500]                 mov al, [R2Type]
  5302 00001B90 A2[3600]                 mov byte [R1Type], al
  5303 00001B93 B80000                   mov ax, 0
  5304 00001B96 A2[3500]                 mov byte [R2Type], al
  5305                                  
  5306                                  ;-848 }
  5307                                  
  5308                                  
  5309                                  ;-849 
  5310                                  
  5311                                  
  5312                                  ;-850 int get2Ops() {
  5313                                  
  5314 00001B99 C3                       ret
  5315                                  ENDP
  5316                                  
  5317                                  get2Ops: PROC
  5318                                  
  5319                                  ;-851     getOpL();
  5320                                  
  5321 00001B9A E8D5FF                   call getOpL
  5322                                  
  5323                                  ;-852     need(',');
  5324                                  
  5325 00001B9D 6A2C                     push 44
  5326 00001B9F E8F3FB                   call need
  5327 00001BA2 83C402                   add  sp, 2
  5328                                  
  5329                                  ;-853     getOpR();
  5330                                  
  5331 00001BA5 E82EFF                   call getOpR
  5332                                  
  5333                                  ;-854 }
  5334                                  
  5335                                  
  5336                                  ;-855 int check2Ops() {
  5337                                  
  5338 00001BA8 C3                       ret
  5339                                  ENDP
  5340                                  
  5341                                  check2Ops: PROC
  5342                                  
  5343                                  ;-856     get2Ops();
  5344                                  
  5345 00001BA9 E8EEFF                   call get2Ops
  5346                                  
  5347                                  ;-857     if (Op ==   0) addrerror();
  5348                                  
  5349 00001BAC A0[2D00]                 mov al, [Op]
  5350 00001BAF 3C00                     cmp al, 0
  5351 00001BB1 0F850300                 jne .check2Ops201
  5352 00001BB5 E865EF                   call addrerror
  5353                                  
  5354                                  ;-858     if (Op == ADR) invaloperror();
  5355                                  
  5356                                  .check2Ops201:
  5357 00001BB8 A0[2D00]                 mov al, [Op]
  5358 00001BBB 3C03                     cmp al, 3
  5359 00001BBD 0F850300                 jne .check2Ops202
  5360 00001BC1 E8D3EF                   call invaloperror
  5361                                  
  5362                                  ;-859     if (Op == IMM) immeerror();
  5363                                  
  5364                                  .check2Ops202:
  5365 00001BC4 A0[2D00]                 mov al, [Op]
  5366 00001BC7 3C01                     cmp al, 1
  5367 00001BC9 0F850300                 jne .check2Ops203
  5368 00001BCD E867EF                   call immeerror
  5369                                  
  5370                                  ;-860     if (Op2==   0) addrerror();
  5371                                  
  5372                                  .check2Ops203:
  5373 00001BD0 A0[2E00]                 mov al, [Op2]
  5374 00001BD3 3C00                     cmp al, 0
  5375 00001BD5 0F850300                 jne .check2Ops204
  5376 00001BD9 E841EF                   call addrerror
  5377                                  
  5378                                  ;-861 //if (CodeType != 5) if (Op2==ADR) invaloperror();//only mov,add
  5379                                  
  5380                                  
  5381                                  ;-862     setwflag();
  5382                                  
  5383                                  .check2Ops204:
  5384 00001BDC E8CBF9                   call setwflag
  5385                                  
  5386                                  ;-863 }
  5387                                  
  5388                                  
  5389                                  ;-864 
  5390                                  
  5391                                  
  5392                                  ;-865 int storeJmp() {
  5393                                  
  5394 00001BDF C3                       ret
  5395                                  ENDP
  5396                                  
  5397                                  storeJmp: PROC
  5398                                  
  5399                                  ;-866     unsigned int i;
  5400                                  
  5401                                  
  5402                                  ;-867     JmpMaxIx++;
  5403                                  
  5404                                  ;Function : storeJmp, Number of local variables: 1
  5405                                  ;   # type sign width addr used name   list of local variables
  5406                                  ;  200 var unsg word   866 NULL i = bp-2;
  5407 00001BE0 C8020000                 ENTER  2,0
  5408 00001BE4 FF06[5400]               inc  word[JmpMaxIx]
  5409                                  
  5410                                  ;-868     if (JmpMaxIx >= JMPMAX) errorexit("too many Jmp");
  5411                                  
  5412 00001BE8 A1[5400]                 mov ax, [JmpMaxIx]
  5413 00001BEB 3DC800                   cmp ax, 200 ;unsigned : 1
  5414 00001BEE 0F8C0900                 jl  .storeJmp205
  5415 00001BF2 68[3C1C]                 push storeJmp_0
  5416 00001BF5 E8A9EE                   call errorexit
  5417 00001BF8 83C402                   add  sp, 2
  5418                                  
  5419                                  ;-869     JmpNamePtr=strcpy(JmpNamePtr, Symbol);
  5420                                  
  5421                                  .storeJmp205:
  5422 00001BFB 8D063075                 lea  ax, [Symbol]
  5423 00001BFF 50                       push ax
  5424 00001C00 FF36[5000]               push word [JmpNamePtr]
  5425 00001C04 E823E6                   call strcpy
  5426 00001C07 83C404                   add  sp, 4
  5427 00001C0A A3[5000]                 mov word [JmpNamePtr], ax
  5428                                  
  5429                                  ;-870     JmpNamePtr++;
  5430                                  
  5431 00001C0D FF06[5000]               inc  word[JmpNamePtr]
  5432                                  
  5433                                  ;-871     i = JmpNamePtr - &JmpNames;
  5434                                  
  5435 00001C11 A1[5000]                 mov ax, [JmpNamePtr]
  5436 00001C14 2D7A93                   sub ax, JmpNames
  5437 00001C17 8946FE                   mov [bp-2], ax
  5438                                  
  5439                                  ;-872     if ( i >= JMPNAMESMAX) errorexit("too many Jmp names");
  5440                                  
  5441 00001C1A 8B46FE                   mov ax, [bp-2]
  5442 00001C1D 3D810F                   cmp ax, 3969 ;unsigned : 0
  5443 00001C20 0F820900                 jb  .storeJmp206
  5444 00001C24 68[491C]                 push storeJmp_1
  5445 00001C27 E877EE                   call errorexit
  5446 00001C2A 83C402                   add  sp, 2
  5447                                  
  5448                                  ;-873     JmpAddr[JmpMaxIx] = PC;
  5449                                  
  5450                                  .storeJmp206:
  5451 00001C2D A1[2300]                 mov ax, [PC]
  5452 00001C30 8B1E[5400]               mov bx, [JmpMaxIx]
  5453 00001C34 D1E3                     shl bx, 1
  5454 00001C36 89871AA3                 mov [JmpAddr+bx], ax
  5455                                  
  5456                                  ;-874 }
  5457                                  
  5458                                  
  5459                                  ;-875 
  5460                                  
  5461                                  
  5462                                  ;-876 int storeLabel() {
  5463 00001C3A C9                       LEAVE
  5464 00001C3B C3                       ret
  5465 00001C3C 746F6F206D616E7920-     storeJmp_0 db "too many Jmp",0
  5466 00001C45 4A6D7000           
  5467 00001C49 746F6F206D616E7920-     storeJmp_1 db "too many Jmp names",0
  5468 00001C52 4A6D70206E616D6573-
  5469 00001C5B 00                 
  5470                                  ENDP
  5471                                  
  5472                                  storeLabel: PROC
  5473                                  
  5474                                  ;-877     unsigned int i;
  5475                                  
  5476                                  
  5477                                  ;-878     if(searchLabel()) error1("duplicate label");
  5478                                  
  5479                                  ;Function : storeLabel, Number of local variables: 1
  5480                                  ;   # type sign width addr used name   list of local variables
  5481                                  ;  200 var unsg word   877 NULL i = bp-2;
  5482 00001C5C C8020000                 ENTER  2,0
  5483 00001C60 E81CFC                   call searchLabel
  5484 00001C63 08C0                     or  al, al
  5485 00001C65 0F840900                 je .storeLabel207
  5486 00001C69 68[CE1C]                 push storeLabel_0
  5487 00001C6C E8DBED                   call error1
  5488 00001C6F 83C402                   add  sp, 2
  5489                                  
  5490                                  ;-879     LabelMaxIx++;
  5491                                  
  5492                                  .storeLabel207:
  5493 00001C72 FF06[4A00]               inc  word[LabelMaxIx]
  5494                                  
  5495                                  ;-880     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  5496                                  
  5497 00001C76 A1[4A00]                 mov ax, [LabelMaxIx]
  5498 00001C79 3D5802                   cmp ax, 600 ;unsigned : 1
  5499 00001C7C 0F8C0900                 jl  .storeLabel208
  5500 00001C80 68[DE1C]                 push storeLabel_1
  5501 00001C83 E81BEE                   call errorexit
  5502 00001C86 83C402                   add  sp, 2
  5503                                  
  5504                                  ;-881     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  5505                                  
  5506                                  .storeLabel208:
  5507 00001C89 8D063075                 lea  ax, [Symbol]
  5508 00001C8D 50                       push ax
  5509 00001C8E FF36[4600]               push word [LabelNamePtr]
  5510 00001C92 E895E5                   call strcpy
  5511 00001C95 83C404                   add  sp, 4
  5512 00001C98 A3[4600]                 mov word [LabelNamePtr], ax
  5513                                  
  5514                                  ;-882     LabelNamePtr++;
  5515                                  
  5516 00001C9B FF06[4600]               inc  word[LabelNamePtr]
  5517                                  
  5518                                  ;-883     i = LabelNamePtr - &LabelNames;
  5519                                  
  5520 00001C9F A1[4600]                 mov ax, [LabelNamePtr]
  5521 00001CA2 2D5A77                   sub ax, LabelNames
  5522 00001CA5 8946FE                   mov [bp-2], ax
  5523                                  
  5524                                  ;-884     if (i >= LABELNAMESMAX) errorexit("too many label names");
  5525                                  
  5526 00001CA8 8B46FE                   mov ax, [bp-2]
  5527 00001CAB 3D5117                   cmp ax, 5969 ;unsigned : 0
  5528 00001CAE 0F820900                 jb  .storeLabel209
  5529 00001CB2 68[EE1C]                 push storeLabel_2
  5530 00001CB5 E8E9ED                   call errorexit
  5531 00001CB8 83C402                   add  sp, 2
  5532                                  
  5533                                  ;-885     LabelAddr[LabelMaxIx] = PC + Origin;
  5534                                  
  5535                                  .storeLabel209:
  5536 00001CBB A1[2300]                 mov ax, [PC]
  5537 00001CBE 0306[2500]               add ax, [Origin]
  5538 00001CC2 8B1E[4A00]               mov bx, [LabelMaxIx]
  5539 00001CC6 D1E3                     shl bx, 1
  5540 00001CC8 8987CA8E                 mov [LabelAddr+bx], ax
  5541                                  
  5542                                  ;-886 }
  5543                                  
  5544                                  
  5545                                  ;-887 
  5546                                  
  5547                                  
  5548                                  ;-888 
  5549                                  
  5550                                  
  5551                                  ;-889 int genDB() {
  5552 00001CCC C9                       LEAVE
  5553 00001CCD C3                       ret
  5554 00001CCE 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  5555 00001CD7 206C6162656C00     
  5556 00001CDE 746F6F206D616E7920-     storeLabel_1 db "too many labels",0
  5557 00001CE7 6C6162656C7300     
  5558 00001CEE 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  5559 00001CF7 6C6162656C206E616D-
  5560 00001D00 657300             
  5561                                  ENDP
  5562                                  
  5563                                  genDB: PROC
  5564                                  
  5565                                  ;-890     char c;  char isloop;
  5566                                  
  5567                                  
  5568                                  ;-891         isloop = 0;
  5569                                  
  5570                                  ;Function : genDB, Number of local variables: 2
  5571                                  ;   # type sign width addr used name   list of local variables
  5572                                  ;  200 var sign byte   890 NULL c = bp-2
  5573                                  ;  201 var sign byte   890 NULL isloop = bp-4;
  5574 00001D03 C8040000                 ENTER  4,0
  5575 00001D07 B80000                   mov ax, 0
  5576 00001D0A 8846FC                   mov [bp-4], al
  5577                                  
  5578                                  ;-892             do {
  5579                                  
  5580                                  .genDB210:
  5581                                  
  5582                                  ;-893                 if (isloop) getTokeType();//omit ,  
  5583                                  
  5584 00001D0D 8A46FC                   mov al, [bp-4]
  5585 00001D10 08C0                     or  al, al
  5586 00001D12 0F840300                 je .genDB211
  5587 00001D16 E8C8F9                   call getTokeType
  5588                                  
  5589                                  ;-894                 if (TokeType == DIGIT) genCode8(SymbolInt);
  5590                                  
  5591                                  .genDB211:
  5592 00001D19 A0[2C00]                 mov al, [TokeType]
  5593 00001D1C 3C01                     cmp al, 1
  5594 00001D1E 0F850D00                 jne .genDB212
  5595 00001D22 FF36[0E00]               push word [SymbolInt]
  5596 00001D26 E859F6                   call genCode8
  5597 00001D29 83C402                   add  sp, 2
  5598                                  
  5599                                  ;-895                 else {
  5600                                  
  5601 00001D2C E94100                   jmp .genDB213
  5602                                  .genDB212:
  5603                                  
  5604                                  ;-896                     skipBlank();
  5605                                  
  5606 00001D2F E8ADF0                   call skipBlank
  5607                                  
  5608                                  ;-897                     if (isToken('"')) {
  5609                                  
  5610 00001D32 6A22                     push 34
  5611 00001D34 E836FA                   call isToken
  5612 00001D37 83C402                   add  sp, 2
  5613 00001D3A 08C0                     or  al, al
  5614 00001D3C 0F843000                 je .genDB214
  5615                                  
  5616                                  ;-898                         do {
  5617                                  
  5618                                  .genDB215:
  5619                                  
  5620                                  ;-899                             c= *InputPtr;
  5621                                  
  5622 00001D40 8B1E[1400]               mov bx, [InputPtr]
  5623 00001D44 8A07                     mov al, [bx]
  5624 00001D46 B400                     mov ah, 0
  5625 00001D48 8846FE                   mov [bp-2], al
  5626                                  
  5627                                  ;-900                             genCode8(c);
  5628                                  
  5629 00001D4B 8A46FE                   mov al, byte [bp-2]
  5630 00001D4E B400                     mov ah, 0
  5631 00001D50 50                       push ax
  5632 00001D51 E82EF6                   call genCode8
  5633 00001D54 83C402                   add  sp, 2
  5634                                  
  5635                                  ;-901                             InputPtr++;
  5636                                  
  5637 00001D57 FF06[1400]               inc  word[InputPtr]
  5638                                  
  5639                                  ;-902                         } while (*InputPtr != '"' );
  5640                                  
  5641 00001D5B 8B1E[1400]               mov bx, [InputPtr]
  5642 00001D5F 8A07                     mov al, [bx]
  5643 00001D61 B400                     mov ah, 0
  5644 00001D63 83F822                   cmp ax, 34
  5645 00001D66 0F840200                 je  .genDB216
  5646 00001D6A EBD4                     jmp .genDB215
  5647                                  .genDB216:
  5648                                  
  5649                                  ;-903                         InputPtr++;
  5650                                  
  5651 00001D6C FF06[1400]               inc  word[InputPtr]
  5652                                  
  5653                                  ;-904                     }
  5654                                  
  5655                                  
  5656                                  ;-905                 } 
  5657                                  
  5658                                  .genDB214:
  5659                                  
  5660                                  ;-906                 isloop = 1;
  5661                                  
  5662                                  .genDB213:
  5663 00001D70 B80100                   mov ax, 1
  5664 00001D73 8846FC                   mov [bp-4], al
  5665                                  
  5666                                  ;-907             } while (isToken(','));
  5667                                  
  5668 00001D76 6A2C                     push 44
  5669 00001D78 E8F2F9                   call isToken
  5670 00001D7B 83C402                   add  sp, 2
  5671 00001D7E 08C0                     or  al, al
  5672 00001D80 0F840200                 je .genDB217
  5673 00001D84 EB87                     jmp .genDB210
  5674                                  .genDB217:
  5675                                  
  5676                                  ;-908 }
  5677                                  
  5678                                  
  5679                                  ;-909 
  5680                                  
  5681                                  
  5682                                  ;-910 int getVariable() {
  5683 00001D86 C9                       LEAVE
  5684 00001D87 C3                       ret
  5685                                  ENDP
  5686                                  
  5687                                  getVariable: PROC
  5688                                  
  5689                                  ;-911     char c;
  5690                                  
  5691                                  
  5692                                  ;-912     storeLabel();
  5693                                  
  5694                                  ;Function : getVariable, Number of local variables: 1
  5695                                  ;   # type sign width addr used name   list of local variables
  5696                                  ;  200 var sign byte   911 NULL c = bp-2;
  5697 00001D88 C8020000                 ENTER  2,0
  5698 00001D8C E8CDFE                   call storeLabel
  5699                                  
  5700                                  ;-913     getTokeType();
  5701                                  
  5702 00001D8F E84FF9                   call getTokeType
  5703                                  
  5704                                  ;-914     if(TokeType==ALNUME) {//getName
  5705                                  
  5706 00001D92 A0[2C00]                 mov al, [TokeType]
  5707 00001D95 3C03                     cmp al, 3
  5708 00001D97 0F857001                 jne .getVariable218
  5709                                  
  5710                                  ;-915         lookCode();
  5711                                  
  5712 00001D9B E86DF5                   call lookCode
  5713                                  
  5714                                  ;-916         if (CodeType < 200) dataexit();
  5715                                  
  5716 00001D9E A0[2F00]                 mov al, [CodeType]
  5717 00001DA1 3CC8                     cmp al, 200
  5718 00001DA3 0F8D0300                 jge .getVariable219
  5719 00001DA7 E8CCEE                   call dataexit
  5720                                  
  5721                                  ;-917         if (CodeType > 205) dataexit();
  5722                                  
  5723                                  .getVariable219:
  5724 00001DAA A0[2F00]                 mov al, [CodeType]
  5725 00001DAD 3CCD                     cmp al, 205
  5726 00001DAF 0F8E0300                 jle .getVariable220
  5727 00001DB3 E8C0EE                   call dataexit
  5728                                  
  5729                                  ;-918         if (CodeType== 200) {//DB
  5730                                  
  5731                                  .getVariable220:
  5732 00001DB6 A0[2F00]                 mov al, [CodeType]
  5733 00001DB9 3CC8                     cmp al, 200
  5734 00001DBB 0F856A00                 jne .getVariable221
  5735                                  
  5736                                  ;-919             do {
  5737                                  
  5738                                  .getVariable222:
  5739                                  
  5740                                  ;-920                 getTokeType();
  5741                                  
  5742 00001DBF E81FF9                   call getTokeType
  5743                                  
  5744                                  ;-921                 if (TokeType == DIGIT) genCode8(SymbolInt);
  5745                                  
  5746 00001DC2 A0[2C00]                 mov al, [TokeType]
  5747 00001DC5 3C01                     cmp al, 1
  5748 00001DC7 0F850D00                 jne .getVariable223
  5749 00001DCB FF36[0E00]               push word [SymbolInt]
  5750 00001DCF E8B0F5                   call genCode8
  5751 00001DD2 83C402                   add  sp, 2
  5752                                  
  5753                                  ;-922                 else {
  5754                                  
  5755 00001DD5 E94100                   jmp .getVariable224
  5756                                  .getVariable223:
  5757                                  
  5758                                  ;-923                     skipBlank();
  5759                                  
  5760 00001DD8 E804F0                   call skipBlank
  5761                                  
  5762                                  ;-924                     if (isToken('"')) {
  5763                                  
  5764 00001DDB 6A22                     push 34
  5765 00001DDD E88DF9                   call isToken
  5766 00001DE0 83C402                   add  sp, 2
  5767 00001DE3 08C0                     or  al, al
  5768 00001DE5 0F843000                 je .getVariable225
  5769                                  
  5770                                  ;-925                         do {
  5771                                  
  5772                                  .getVariable226:
  5773                                  
  5774                                  ;-926                             c= *InputPtr;
  5775                                  
  5776 00001DE9 8B1E[1400]               mov bx, [InputPtr]
  5777 00001DED 8A07                     mov al, [bx]
  5778 00001DEF B400                     mov ah, 0
  5779 00001DF1 8846FE                   mov [bp-2], al
  5780                                  
  5781                                  ;-927                             genCode8(c);
  5782                                  
  5783 00001DF4 8A46FE                   mov al, byte [bp-2]
  5784 00001DF7 B400                     mov ah, 0
  5785 00001DF9 50                       push ax
  5786 00001DFA E885F5                   call genCode8
  5787 00001DFD 83C402                   add  sp, 2
  5788                                  
  5789                                  ;-928                             InputPtr++;
  5790                                  
  5791 00001E00 FF06[1400]               inc  word[InputPtr]
  5792                                  
  5793                                  ;-929                         } while (*InputPtr != '"' );
  5794                                  
  5795 00001E04 8B1E[1400]               mov bx, [InputPtr]
  5796 00001E08 8A07                     mov al, [bx]
  5797 00001E0A B400                     mov ah, 0
  5798 00001E0C 83F822                   cmp ax, 34
  5799 00001E0F 0F840200                 je  .getVariable227
  5800 00001E13 EBD4                     jmp .getVariable226
  5801                                  .getVariable227:
  5802                                  
  5803                                  ;-930                         InputPtr++;
  5804                                  
  5805 00001E15 FF06[1400]               inc  word[InputPtr]
  5806                                  
  5807                                  ;-931                     }
  5808                                  
  5809                                  
  5810                                  ;-932                 }
  5811                                  
  5812                                  .getVariable225:
  5813                                  
  5814                                  ;-933             } while (isToken(','));
  5815                                  
  5816                                  .getVariable224:
  5817 00001E19 6A2C                     push 44
  5818 00001E1B E84FF9                   call isToken
  5819 00001E1E 83C402                   add  sp, 2
  5820 00001E21 08C0                     or  al, al
  5821 00001E23 0F840200                 je .getVariable228
  5822 00001E27 EB96                     jmp .getVariable222
  5823                                  .getVariable228:
  5824                                  
  5825                                  ;-934         }
  5826                                  
  5827                                  
  5828                                  ;-935         if (CodeType == 201) {//DW
  5829                                  
  5830                                  .getVariable221:
  5831 00001E29 A0[2F00]                 mov al, [CodeType]
  5832 00001E2C 3CC9                     cmp al, 201
  5833 00001E2E 0F852600                 jne .getVariable229
  5834                                  
  5835                                  ;-936             do {
  5836                                  
  5837                                  .getVariable230:
  5838                                  
  5839                                  ;-937                 getTokeType();
  5840                                  
  5841 00001E32 E8ACF8                   call getTokeType
  5842                                  
  5843                                  ;-938                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  5844                                  
  5845 00001E35 A0[2C00]                 mov al, [TokeType]
  5846 00001E38 3C01                     cmp al, 1
  5847 00001E3A 0F850A00                 jne .getVariable231
  5848 00001E3E FF36[0E00]               push word [SymbolInt]
  5849 00001E42 E8D4F5                   call genCode16
  5850 00001E45 83C402                   add  sp, 2
  5851                                  
  5852                                  ;-939             } while (isToken(','));
  5853                                  
  5854                                  .getVariable231:
  5855 00001E48 6A2C                     push 44
  5856 00001E4A E820F9                   call isToken
  5857 00001E4D 83C402                   add  sp, 2
  5858 00001E50 08C0                     or  al, al
  5859 00001E52 0F840200                 je .getVariable232
  5860 00001E56 EBDA                     jmp .getVariable230
  5861                                  .getVariable232:
  5862                                  
  5863                                  ;-940         }
  5864                                  
  5865                                  
  5866                                  ;-941         if (CodeType == 202) {//DD
  5867                                  
  5868                                  .getVariable229:
  5869 00001E58 A0[2F00]                 mov al, [CodeType]
  5870 00001E5B 3CCA                     cmp al, 202
  5871 00001E5D 0F852E00                 jne .getVariable233
  5872                                  
  5873                                  ;-942             do {
  5874                                  
  5875                                  .getVariable234:
  5876                                  
  5877                                  ;-943                 getTokeType();
  5878                                  
  5879 00001E61 E87DF8                   call getTokeType
  5880                                  
  5881                                  ;-944                 if (TokeType ==DIGIT) { genCode16(SymbolInt);
  5882                                  
  5883 00001E64 A0[2C00]                 mov al, [TokeType]
  5884 00001E67 3C01                     cmp al, 1
  5885 00001E69 0F851200                 jne .getVariable235
  5886 00001E6D FF36[0E00]               push word [SymbolInt]
  5887 00001E71 E8A5F5                   call genCode16
  5888 00001E74 83C402                   add  sp, 2
  5889                                  
  5890                                  ;-945                                     genCode16(0);}//todo genCode32(SymbolLong);
  5891                                  
  5892 00001E77 6A00                     push 0
  5893 00001E79 E89DF5                   call genCode16
  5894 00001E7C 83C402                   add  sp, 2
  5895                                  
  5896                                  ;-946             } while (isToken(','));
  5897                                  
  5898                                  .getVariable235:
  5899 00001E7F 6A2C                     push 44
  5900 00001E81 E8E9F8                   call isToken
  5901 00001E84 83C402                   add  sp, 2
  5902 00001E87 08C0                     or  al, al
  5903 00001E89 0F840200                 je .getVariable236
  5904 00001E8D EBD2                     jmp .getVariable234
  5905                                  .getVariable236:
  5906                                  
  5907                                  ;-947         }
  5908                                  
  5909                                  
  5910                                  ;-948         if (CodeType >= 203) {//resb, resw, resd
  5911                                  
  5912                                  .getVariable233:
  5913 00001E8F A0[2F00]                 mov al, [CodeType]
  5914 00001E92 3CCB                     cmp al, 203 ;unsigned : 1
  5915 00001E94 0F8C7000                 jl  .getVariable237
  5916                                  
  5917                                  ;-949             getTokeType();
  5918                                  
  5919 00001E98 E846F8                   call getTokeType
  5920                                  
  5921                                  ;-950             if (TokeType == DIGIT) {
  5922                                  
  5923 00001E9B A0[2C00]                 mov al, [TokeType]
  5924 00001E9E 3C01                     cmp al, 1
  5925 00001EA0 0F856100                 jne .getVariable238
  5926                                  
  5927                                  ;-951                 if (SymbolInt <= 0) syntaxerror();
  5928                                  
  5929 00001EA4 A1[0E00]                 mov ax, [SymbolInt]
  5930 00001EA7 83F800                   cmp ax, 0
  5931 00001EAA 0F870300                 ja  .getVariable239
  5932 00001EAE E89AED                   call syntaxerror
  5933                                  
  5934                                  ;-952                 if (AbsoluteLab == 0) error1("Absolute is null");
  5935                                  
  5936                                  .getVariable239:
  5937 00001EB1 A1[2700]                 mov ax, [AbsoluteLab]
  5938 00001EB4 83F800                   cmp ax, 0
  5939 00001EB7 0F850900                 jne .getVariable240
  5940 00001EBB 68[101F]                 push getVariable_0
  5941 00001EBE E889EB                   call error1
  5942 00001EC1 83C402                   add  sp, 2
  5943                                  
  5944                                  ;-953                 LabelAddr[LabelMaxIx] = AbsoluteLab;
  5945                                  
  5946                                  .getVariable240:
  5947 00001EC4 A1[2700]                 mov ax, [AbsoluteLab]
  5948 00001EC7 8B1E[4A00]               mov bx, [LabelMaxIx]
  5949 00001ECB D1E3                     shl bx, 1
  5950 00001ECD 8987CA8E                 mov [LabelAddr+bx], ax
  5951                                  
  5952                                  ;-954                 if (CodeType == 204) SymbolInt=SymbolInt+SymbolInt;//resw
  5953                                  
  5954 00001ED1 A0[2F00]                 mov al, [CodeType]
  5955 00001ED4 3CCC                     cmp al, 204
  5956 00001ED6 0F850A00                 jne .getVariable241
  5957 00001EDA A1[0E00]                 mov ax, [SymbolInt]
  5958 00001EDD 0306[0E00]               add ax, [SymbolInt]
  5959 00001EE1 A3[0E00]                 mov word [SymbolInt], ax
  5960                                  
  5961                                  ;-955                 if (CodeType == 205) SymbolInt=SymbolInt * 4;//resd
  5962                                  
  5963                                  .getVariable241:
  5964 00001EE4 A0[2F00]                 mov al, [CodeType]
  5965 00001EE7 3CCD                     cmp al, 205
  5966 00001EE9 0F850B00                 jne .getVariable242
  5967 00001EED A1[0E00]                 mov ax, [SymbolInt]
  5968 00001EF0 BB0400                   mov bx, 4
  5969 00001EF3 F7E3                     mul bx
  5970 00001EF5 A3[0E00]                 mov word [SymbolInt], ax
  5971                                  
  5972                                  ;-956                 AbsoluteLab = AbsoluteLab + SymbolInt;
  5973                                  
  5974                                  .getVariable242:
  5975 00001EF8 A1[2700]                 mov ax, [AbsoluteLab]
  5976 00001EFB 0306[0E00]               add ax, [SymbolInt]
  5977 00001EFF A3[2700]                 mov word [AbsoluteLab], ax
  5978                                  
  5979                                  ;-957             } else numbererror();
  5980                                  
  5981 00001F02 E90300                   jmp .getVariable243
  5982                                  .getVariable238:
  5983 00001F05 E8B0EC                   call numbererror
  5984                                  
  5985                                  ;-958         }
  5986                                  
  5987                                  .getVariable243:
  5988                                  
  5989                                  ;-959     }
  5990                                  
  5991                                  .getVariable237:
  5992                                  
  5993                                  ;-960     else dataexit();
  5994                                  
  5995 00001F08 E90300                   jmp .getVariable244
  5996                                  .getVariable218:
  5997 00001F0B E868ED                   call dataexit
  5998                                  
  5999                                  ;-961 }
  6000                                  
  6001                                  .getVariable244:
  6002                                  
  6003                                  ;-962 
  6004                                  
  6005                                  
  6006                                  ;-963 int getCodeSize() {
  6007 00001F0E C9                       LEAVE
  6008 00001F0F C3                       ret
  6009 00001F10 4162736F6C75746520-     getVariable_0 db "Absolute is null",0
  6010 00001F19 6973206E756C6C00   
  6011                                  ENDP
  6012                                  
  6013                                  getCodeSize: PROC
  6014                                  
  6015                                  ;-964     if (TokeType ==ALNUME) {
  6016                                  
  6017 00001F21 A0[2C00]                 mov al, [TokeType]
  6018 00001F24 3C03                     cmp al, 3
  6019 00001F26 0F855700                 jne .getCodeSize245
  6020                                  
  6021                                  ;-965         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  6022                                  
  6023 00001F2A 68[881F]                 push getCodeSize_0
  6024 00001F2D 8D064F75                 lea  ax, [SymbolUpper]
  6025 00001F31 50                       push ax
  6026 00001F32 E82BE3                   call eqstr
  6027 00001F35 83C404                   add  sp, 4
  6028 00001F38 08C0                     or  al, al
  6029 00001F3A 0F840900                 je .getCodeSize246
  6030 00001F3E E8A0F7                   call getTokeType
  6031 00001F41 B80100                   mov ax, 1
  6032 00001F44 E94000                   jmp .retngetCodeSize
  6033                                  
  6034                                  ;-966         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  6035                                  
  6036                                  .getCodeSize246:
  6037 00001F47 68[8D1F]                 push getCodeSize_1
  6038 00001F4A 8D064F75                 lea  ax, [SymbolUpper]
  6039 00001F4E 50                       push ax
  6040 00001F4F E80EE3                   call eqstr
  6041 00001F52 83C404                   add  sp, 4
  6042 00001F55 08C0                     or  al, al
  6043 00001F57 0F840900                 je .getCodeSize247
  6044 00001F5B E883F7                   call getTokeType
  6045 00001F5E B80200                   mov ax, 2
  6046 00001F61 E92300                   jmp .retngetCodeSize
  6047                                  
  6048                                  ;-967         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  6049                                  
  6050                                  .getCodeSize247:
  6051 00001F64 68[921F]                 push getCodeSize_2
  6052 00001F67 8D064F75                 lea  ax, [SymbolUpper]
  6053 00001F6B 50                       push ax
  6054 00001F6C E8F1E2                   call eqstr
  6055 00001F6F 83C404                   add  sp, 4
  6056 00001F72 08C0                     or  al, al
  6057 00001F74 0F840900                 je .getCodeSize248
  6058 00001F78 E866F7                   call getTokeType
  6059 00001F7B B80300                   mov ax, 3
  6060 00001F7E E90600                   jmp .retngetCodeSize
  6061                                  
  6062                                  ;-968     }
  6063                                  
  6064                                  .getCodeSize248:
  6065                                  
  6066                                  ;-969     return 0;
  6067                                  
  6068                                  .getCodeSize245:
  6069 00001F81 B80000                   mov ax, 0
  6070 00001F84 E90000                   jmp .retngetCodeSize
  6071                                  
  6072                                  ;-970 }
  6073                                  
  6074                                  
  6075                                  ;-971 
  6076                                  
  6077                                  
  6078                                  ;-972 
  6079                                  
  6080                                  
  6081                                  ;-973 int getarg() {
  6082                                  
  6083                                   .retngetCodeSize:
  6084 00001F87 C3                       ret
  6085 00001F88 4259544500              getCodeSize_0 db "BYTE",0
  6086 00001F8D 574F524400              getCodeSize_1 db "WORD",0
  6087 00001F92 44574F524400            getCodeSize_2 db "DWORD",0
  6088                                  ENDP
  6089                                  
  6090                                  getarg: PROC
  6091                                  
  6092                                  ;-974     int arglen1; int i; char *c;
  6093                                  
  6094                                  
  6095                                  ;-975     arglen1=*arglen;
  6096                                  
  6097                                  ;Function : getarg, Number of local variables: 3
  6098                                  ;   # type sign width addr used name   list of local variables
  6099                                  ;  200 var sign word   974 NULL arglen1 = bp-2
  6100                                  ;  201 var sign word   974 NULL i = bp-4
  6101                                  ;  202 ptr sign byte   974 NULL c = bp-6;
  6102 00001F98 C8060000                 ENTER  6,0
  6103 00001F9C 8B1E[5A00]               mov bx, [arglen]
  6104 00001FA0 8A07                     mov al, [bx]
  6105 00001FA2 B400                     mov ah, 0
  6106 00001FA4 8946FE                   mov [bp-2], ax
  6107                                  
  6108                                  ;-976     if (arglen1==0) {
  6109                                  
  6110 00001FA7 8B46FE                   mov ax, [bp-2]
  6111 00001FAA 83F800                   cmp ax, 0
  6112 00001FAD 0F851C00                 jne .getarg249
  6113                                  
  6114                                  ;-977         cputs(Version1);
  6115                                  
  6116 00001FB1 8D06[0300]               lea  ax, [Version1]
  6117 00001FB5 50                       push ax
  6118 00001FB6 E8C6E0                   call cputs
  6119 00001FB9 83C402                   add  sp, 2
  6120                                  
  6121                                  ;-978         cputs(", Usage: AS.COM filename [w/o .S] : ");
  6122                                  
  6123 00001FBC 68[4821]                 push getarg_0
  6124 00001FBF E8BDE0                   call cputs
  6125 00001FC2 83C402                   add  sp, 2
  6126                                  
  6127                                  ;-979         exitR(3);
  6128                                  
  6129 00001FC5 6A03                     push 3
  6130 00001FC7 E81CE1                   call exitR
  6131 00001FCA 83C402                   add  sp, 2
  6132                                  
  6133                                  ;-980     }
  6134                                  
  6135                                  
  6136                                  ;-981     i=arglen1+129;
  6137                                  
  6138                                  .getarg249:
  6139 00001FCD 8B46FE                   mov ax, [bp-2]
  6140 00001FD0 058100                   add ax, 129
  6141 00001FD3 8946FC                   mov [bp-4], ax
  6142                                  
  6143                                  ;-982     *i=0;
  6144                                  
  6145 00001FD6 B80000                   mov ax, 0
  6146 00001FD9 8B5EFC                   mov  bx, [bp-4]
  6147 00001FDC 8907                     mov  [bx], ax
  6148                                  
  6149                                  ;-983     arglen1--;
  6150                                  
  6151 00001FDE FF4EFE                   dec  word[bp-2]
  6152                                  
  6153                                  ;-984     toupper(argv);
  6154                                  
  6155 00001FE1 FF36[5C00]               push word [argv]
  6156 00001FE5 E8E9E2                   call toupper
  6157 00001FE8 83C402                   add  sp, 2
  6158                                  
  6159                                  ;-985 
  6160                                  
  6161                                  
  6162                                  ;-986     strcpy(namein, argv); strcat1(namein, ".S");
  6163                                  
  6164 00001FEB FF36[5C00]               push word [argv]
  6165 00001FEF 8D068C76                 lea  ax, [namein]
  6166 00001FF3 50                       push ax
  6167 00001FF4 E833E2                   call strcpy
  6168 00001FF7 83C404                   add  sp, 4
  6169 00001FFA 68[6D21]                 push getarg_1
  6170 00001FFD 8D068C76                 lea  ax, [namein]
  6171 00002001 50                       push ax
  6172 00002002 E8A7E2                   call strcat1
  6173 00002005 83C404                   add  sp, 4
  6174                                  
  6175                                  ;-987     strcpy(namelst,argv); strcat1(namelst,".LST");
  6176                                  
  6177 00002008 FF36[5C00]               push word [argv]
  6178 0000200C 8D06CF76                 lea  ax, [namelst]
  6179 00002010 50                       push ax
  6180 00002011 E816E2                   call strcpy
  6181 00002014 83C404                   add  sp, 4
  6182 00002017 68[7021]                 push getarg_2
  6183 0000201A 8D06CF76                 lea  ax, [namelst]
  6184 0000201E 50                       push ax
  6185 0000201F E88AE2                   call strcat1
  6186 00002022 83C404                   add  sp, 4
  6187                                  
  6188                                  ;-988     strcpy(namebin,argv); strcat1(namebin,".COM");
  6189                                  
  6190 00002025 FF36[5C00]               push word [argv]
  6191 00002029 8D061277                 lea  ax, [namebin]
  6192 0000202D 50                       push ax
  6193 0000202E E8F9E1                   call strcpy
  6194 00002031 83C404                   add  sp, 4
  6195 00002034 68[7521]                 push getarg_3
  6196 00002037 8D061277                 lea  ax, [namebin]
  6197 0000203B 50                       push ax
  6198 0000203C E86DE2                   call strcat1
  6199 0000203F 83C404                   add  sp, 4
  6200                                  
  6201                                  ;-989 
  6202                                  
  6203                                  
  6204                                  ;-990   DOS_ERR=0; PC=0; ErrorCount=0;
  6205                                  
  6206 00002042 B80000                   mov ax, 0
  6207 00002045 A3[1C00]                 mov word [DOS_ERR], ax
  6208 00002048 B80000                   mov ax, 0
  6209 0000204B A3[2300]                 mov word [PC], ax
  6210 0000204E B80000                   mov ax, 0
  6211 00002051 A3[1E00]                 mov word [ErrorCount], ax
  6212                                  
  6213                                  ;-991 
  6214                                  
  6215                                  
  6216                                  ;-992     asm_fd=openR (namein);
  6217                                  
  6218 00002054 8D068C76                 lea  ax, [namein]
  6219 00002058 50                       push ax
  6220 00002059 E85AE0                   call openR
  6221 0000205C 83C402                   add  sp, 2
  6222 0000205F A3[1600]                 mov word [asm_fd], ax
  6223                                  
  6224                                  ;-993     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  6225                                  
  6226 00002062 A1[1C00]                 mov ax, [DOS_ERR]
  6227 00002065 08C0                     or  al, al
  6228 00002067 0F841C00                 je .getarg250
  6229 0000206B 68[7A21]                 push getarg_4
  6230 0000206E E80EE0                   call cputs
  6231 00002071 83C402                   add  sp, 2
  6232 00002074 8D068C76                 lea  ax, [namein]
  6233 00002078 50                       push ax
  6234 00002079 E803E0                   call cputs
  6235 0000207C 83C402                   add  sp, 2
  6236 0000207F 6A01                     push 1
  6237 00002081 E862E0                   call exitR
  6238 00002084 83C402                   add  sp, 2
  6239                                  
  6240                                  ;-994     lst_fd=creatR(namelst);
  6241                                  
  6242                                  .getarg250:
  6243 00002087 8D06CF76                 lea  ax, [namelst]
  6244 0000208B 50                       push ax
  6245 0000208C E836E0                   call creatR
  6246 0000208F 83C402                   add  sp, 2
  6247 00002092 A3[1800]                 mov word [lst_fd], ax
  6248                                  
  6249                                  ;-995     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  6250                                  
  6251 00002095 A1[1C00]                 mov ax, [DOS_ERR]
  6252 00002098 08C0                     or  al, al
  6253 0000209A 0F841C00                 je .getarg251
  6254 0000209E 68[9021]                 push getarg_5
  6255 000020A1 E8DBDF                   call cputs
  6256 000020A4 83C402                   add  sp, 2
  6257 000020A7 8D06CF76                 lea  ax, [namelst]
  6258 000020AB 50                       push ax
  6259 000020AC E8D0DF                   call cputs
  6260 000020AF 83C402                   add  sp, 2
  6261 000020B2 6A02                     push 2
  6262 000020B4 E82FE0                   call exitR
  6263 000020B7 83C402                   add  sp, 2
  6264                                  
  6265                                  ;-996     bin_fd=creatR(namebin);
  6266                                  
  6267                                  .getarg251:
  6268 000020BA 8D061277                 lea  ax, [namebin]
  6269 000020BE 50                       push ax
  6270 000020BF E803E0                   call creatR
  6271 000020C2 83C402                   add  sp, 2
  6272 000020C5 A3[1A00]                 mov word [bin_fd], ax
  6273                                  
  6274                                  ;-997     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  6275                                  
  6276 000020C8 A1[1C00]                 mov ax, [DOS_ERR]
  6277 000020CB 08C0                     or  al, al
  6278 000020CD 0F841C00                 je .getarg252
  6279 000020D1 68[A721]                 push getarg_6
  6280 000020D4 E8A8DF                   call cputs
  6281 000020D7 83C402                   add  sp, 2
  6282 000020DA 8D061277                 lea  ax, [namebin]
  6283 000020DE 50                       push ax
  6284 000020DF E89DDF                   call cputs
  6285 000020E2 83C402                   add  sp, 2
  6286 000020E5 6A02                     push 2
  6287 000020E7 E8FCDF                   call exitR
  6288 000020EA 83C402                   add  sp, 2
  6289                                  
  6290                                  ;-998 
  6291                                  
  6292                                  
  6293                                  ;-999     prs(";");
  6294                                  
  6295                                  .getarg252:
  6296 000020ED 68[BD21]                 push getarg_7
  6297 000020F0 E840E6                   call prs
  6298 000020F3 83C402                   add  sp, 2
  6299                                  
  6300                                  ;-1000     prs(Version1);
  6301                                  
  6302 000020F6 8D06[0300]               lea  ax, [Version1]
  6303 000020FA 50                       push ax
  6304 000020FB E835E6                   call prs
  6305 000020FE 83C402                   add  sp, 2
  6306                                  
  6307                                  ;-1001     prs(", Source: "); prs(namein);
  6308                                  
  6309 00002101 68[BF21]                 push getarg_8
  6310 00002104 E82CE6                   call prs
  6311 00002107 83C402                   add  sp, 2
  6312 0000210A 8D068C76                 lea  ax, [namein]
  6313 0000210E 50                       push ax
  6314 0000210F E821E6                   call prs
  6315 00002112 83C402                   add  sp, 2
  6316                                  
  6317                                  ;-1002     prs(", Output: "); prs(namelst);
  6318                                  
  6319 00002115 68[CA21]                 push getarg_9
  6320 00002118 E818E6                   call prs
  6321 0000211B 83C402                   add  sp, 2
  6322 0000211E 8D06CF76                 lea  ax, [namelst]
  6323 00002122 50                       push ax
  6324 00002123 E80DE6                   call prs
  6325 00002126 83C402                   add  sp, 2
  6326                                  
  6327                                  ;-1003     prs(", "); prs(namebin);
  6328                                  
  6329 00002129 68[D521]                 push getarg_10
  6330 0000212C E804E6                   call prs
  6331 0000212F 83C402                   add  sp, 2
  6332 00002132 8D061277                 lea  ax, [namebin]
  6333 00002136 50                       push ax
  6334 00002137 E8F9E5                   call prs
  6335 0000213A 83C402                   add  sp, 2
  6336                                  
  6337                                  ;-1004     prs("\n");
  6338                                  
  6339 0000213D 68[D821]                 push getarg_11
  6340 00002140 E8F0E5                   call prs
  6341 00002143 83C402                   add  sp, 2
  6342                                  
  6343                                  ;-1005 }
  6344                                  
  6345                                  
  6346                                  ;-1006 
  6347                                  
  6348                                  
  6349                                  ;-1007 int FixOneJmp(unsigned int hex) {
  6350 00002146 C9                       LEAVE
  6351 00002147 C3                       ret
  6352 00002148 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  6353 00002151 41532E434F4D206669-
  6354 0000215A 6C656E616D65205B77-
  6355 00002163 2F6F202E535D203A20-
  6356 0000216C 00                 
  6357 0000216D 2E5300                  getarg_1 db ".S",0
  6358 00002170 2E4C535400              getarg_2 db ".LST",0
  6359 00002175 2E434F4D00              getarg_3 db ".COM",0
  6360 0000217A 536F75726365206669-     getarg_4 db "Source file missing: ",0
  6361 00002183 6C65206D697373696E-
  6362 0000218C 673A2000           
  6363 00002190 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  6364 00002199 206E6F742063726561-
  6365 000021A2 74653A2000         
  6366 000021A7 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  6367 000021B0 6E6F74206372656174-
  6368 000021B9 653A2000           
  6369 000021BD 3B00                    getarg_7 db ";",0
  6370 000021BF 2C20536F757263653A-     getarg_8 db ", Source: ",0
  6371 000021C8 2000               
  6372 000021CA 2C204F75747075743A-     getarg_9 db ", Output: ",0
  6373 000021D3 2000               
  6374 000021D5 2C2000                  getarg_10 db ", ",0
  6375 000021D8 5C6E00                  getarg_11 db "\n",0
  6376                                  ENDP
  6377                                  
  6378                                  FixOneJmp: PROC
  6379                                  
  6380                                  ;-1008     int Ix; char c;
  6381                                  
  6382                                  
  6383                                  ;-1009     Ix=searchLabel();
  6384                                  
  6385                                  ;Function : FixOneJmp, Number of local variables: 3
  6386                                  ;   # type sign width addr used name   list of local variables
  6387                                  ;  200 var unsg word  1007 NULL hex = bp+4
  6388                                  ;  201 var sign word  1008 NULL Ix = bp-2
  6389                                  ;  202 var sign byte  1008 NULL c = bp-4;
  6390 000021DB C8040000                 ENTER  4,0
  6391 000021DF E89DF6                   call searchLabel
  6392 000021E2 8946FE                   mov [bp-2], ax
  6393                                  
  6394                                  ;-1010     if (Ix == 0) notfounderror();
  6395                                  
  6396 000021E5 8B46FE                   mov ax, [bp-2]
  6397 000021E8 83F800                   cmp ax, 0
  6398 000021EB 0F850300                 jne .FixOneJmp253
  6399 000021EF E8C9E8                   call notfounderror
  6400                                  
  6401                                  ;-1011     disp = LabelAddr[Ix];   
  6402                                  
  6403                                  .FixOneJmp253:
  6404 000021F2 8B5EFE                   mov bx, [bp-2]
  6405 000021F5 D1E3                     shl bx, 1
  6406 000021F7 8B87CA8E                 mov ax, [LabelAddr + bx]
  6407 000021FB A3[3D00]                 mov word [disp], ax
  6408                                  
  6409                                  ;-1012     c = FileBin[hex];//look for 'A' push Absolute 
  6410                                  
  6411 000021FE 8B5E04                   mov bx, [bp+4]
  6412 00002201 8A87AAA4                 mov al, [FileBin + bx]
  6413 00002205 8846FC                   mov [bp-4], al
  6414                                  
  6415                                  ;-1013     if (c != 0xAA) {
  6416                                  
  6417 00002208 8A46FC                   mov al, [bp-4]
  6418 0000220B 3CAA                     cmp al, 170
  6419 0000220D 0F842F00                 je  .FixOneJmp254
  6420                                  
  6421                                  ;-1014         disp = disp - hex;
  6422                                  
  6423 00002211 A1[3D00]                 mov ax, [disp]
  6424 00002214 2B4604                   sub ax, [bp+4]
  6425 00002217 A3[3D00]                 mov word [disp], ax
  6426                                  
  6427                                  ;-1015         disp = disp -2;//PC points to next instruction
  6428                                  
  6429 0000221A A1[3D00]                 mov ax, [disp]
  6430 0000221D 83E802                   sub ax, 2
  6431 00002220 A3[3D00]                 mov word [disp], ax
  6432                                  
  6433                                  ;-1016         disp = disp - Origin; 
  6434                                  
  6435 00002223 A1[3D00]                 mov ax, [disp]
  6436 00002226 2B06[2500]               sub ax, [Origin]
  6437 0000222A A3[3D00]                 mov word [disp], ax
  6438                                  
  6439                                  ;-1017         prs(",rel:"); printhex16(disp);
  6440                                  
  6441 0000222D 68[6222]                 push FixOneJmp_0
  6442 00002230 E800E5                   call prs
  6443 00002233 83C402                   add  sp, 2
  6444 00002236 FF36[3D00]               push word [disp]
  6445 0000223A E8DCE5                   call printhex16
  6446 0000223D 83C402                   add  sp, 2
  6447                                  
  6448                                  ;-1018     }
  6449                                  
  6450                                  
  6451                                  ;-1019     FileBin[hex] = disp;//fix low byte
  6452                                  
  6453                                  .FixOneJmp254:
  6454 00002240 A1[3D00]                 mov ax, [disp]
  6455 00002243 8B5E04                   mov bx, [bp+4]
  6456 00002246 8887AAA4                 mov [FileBin+bx], al
  6457                                  
  6458                                  ;-1020     hex++;
  6459                                  
  6460 0000224A FF4604                   inc  word[bp+4]
  6461                                  
  6462                                  ;-1021     disp = disp >> 8;
  6463                                  
  6464 0000224D A1[3D00]                 mov ax, [disp]
  6465 00002250 C1E808                   shr ax, 8
  6466 00002253 A3[3D00]                 mov word [disp], ax
  6467                                  
  6468                                  ;-1022     FileBin[hex] = disp;     
  6469                                  
  6470 00002256 A1[3D00]                 mov ax, [disp]
  6471 00002259 8B5E04                   mov bx, [bp+4]
  6472 0000225C 8887AAA4                 mov [FileBin+bx], al
  6473                                  
  6474                                  ;-1023 }
  6475                                  
  6476                                  
  6477                                  ;-1024 int fixJmp() {   
  6478 00002260 C9                       LEAVE
  6479 00002261 C3                       ret
  6480 00002262 2C72656C3A00            FixOneJmp_0 db ",rel:",0
  6481                                  ENDP
  6482                                  
  6483                                  fixJmp: PROC
  6484                                  
  6485                                  ;-1025     unsigned int hex; int i;
  6486                                  
  6487                                  
  6488                                  ;-1026     char *p; 
  6489                                  
  6490                                  
  6491                                  ;-1027 //    prs("\, jmp to fix:"); printIntU(JmpMaxIx);
  6492                                  
  6493                                  
  6494                                  ;-1028     p = &JmpNames;
  6495                                  
  6496                                  ;Function : fixJmp, Number of local variables: 3
  6497                                  ;   # type sign width addr used name   list of local variables
  6498                                  ;  200 var unsg word  1025 NULL hex = bp-2
  6499                                  ;  201 var sign word  1025 NULL i = bp-4
  6500                                  ;  202 ptr sign byte  1026 NULL p = bp-6;
  6501 00002268 C8060000                 ENTER  6,0
  6502 0000226C B87A93                   mov ax, JmpNames
  6503 0000226F 8946FA                   mov [bp-6], ax
  6504                                  
  6505                                  ;-1029     i = 1;
  6506                                  
  6507 00002272 B80100                   mov ax, 1
  6508 00002275 8946FC                   mov [bp-4], ax
  6509                                  
  6510                                  ;-1030     while (i <= JmpMaxIx) {
  6511                                  
  6512                                  .fixJmp255:
  6513 00002278 8B46FC                   mov ax, [bp-4]
  6514 0000227B 3B06[5400]               cmp ax, [JmpMaxIx]
  6515 0000227F 0F8F3C00                 jg  .fixJmp256
  6516                                  
  6517                                  ;-1031         strcpy(Symbol, p);
  6518                                  
  6519 00002283 FF76FA                   push word [bp-6]
  6520 00002286 8D063075                 lea  ax, [Symbol]
  6521 0000228A 50                       push ax
  6522 0000228B E89CDF                   call strcpy
  6523 0000228E 83C404                   add  sp, 4
  6524                                  
  6525                                  ;-1032         p = strlen(Symbol) + p;
  6526                                  
  6527 00002291 8D063075                 lea  ax, [Symbol]
  6528 00002295 50                       push ax
  6529 00002296 E869DF                   call strlen
  6530 00002299 83C402                   add  sp, 2
  6531 0000229C 0346FA                   add ax, [bp-6]
  6532 0000229F 8946FA                   mov [bp-6], ax
  6533                                  
  6534                                  ;-1033         p++;
  6535                                  
  6536 000022A2 FF46FA                   inc  word[bp-6]
  6537                                  
  6538                                  ;-1034         hex = JmpAddr[i];  
  6539                                  
  6540 000022A5 8B5EFC                   mov bx, [bp-4]
  6541 000022A8 D1E3                     shl bx, 1
  6542 000022AA 8B871AA3                 mov ax, [JmpAddr + bx]
  6543 000022AE 8946FE                   mov [bp-2], ax
  6544                                  
  6545                                  ;-1035         FixOneJmp(hex);
  6546                                  
  6547 000022B1 FF76FE                   push word [bp-2]
  6548 000022B4 E824FF                   call FixOneJmp
  6549 000022B7 83C402                   add  sp, 2
  6550                                  
  6551                                  ;-1036         i++;  
  6552                                  
  6553 000022BA FF46FC                   inc  word[bp-4]
  6554                                  
  6555                                  ;-1037     }
  6556                                  
  6557                                  
  6558                                  ;-1038 }
  6559                                  
  6560 000022BD EBB9                     jmp .fixJmp255
  6561                                  .fixJmp256:
  6562                                  
  6563                                  ;-1039 int fixJmpMain() {   
  6564 000022BF C9                       LEAVE
  6565 000022C0 C3                       ret
  6566                                  ENDP
  6567                                  
  6568                                  fixJmpMain: PROC
  6569                                  
  6570                                  ;-1040     prs("\nfix jmp to main. resting global jmp: ");
  6571                                  
  6572 000022C1 68[1023]                 push fixJmpMain_0
  6573 000022C4 E86CE4                   call prs
  6574 000022C7 83C402                   add  sp, 2
  6575                                  
  6576                                  ;-1041     printIntU(JmpMaxIx);  
  6577                                  
  6578 000022CA FF36[5400]               push word [JmpMaxIx]
  6579 000022CE E872E5                   call printIntU
  6580 000022D1 83C402                   add  sp, 2
  6581                                  
  6582                                  ;-1042     if (JmpMaxIx ) error1("resting global jmp");
  6583                                  
  6584 000022D4 A1[5400]                 mov ax, [JmpMaxIx]
  6585 000022D7 08C0                     or  al, al
  6586 000022D9 0F840900                 je .fixJmpMain257
  6587 000022DD 68[3823]                 push fixJmpMain_1
  6588 000022E0 E867E7                   call error1
  6589 000022E3 83C402                   add  sp, 2
  6590                                  
  6591                                  ;-1043     strcpy(Symbol, "main");
  6592                                  
  6593                                  .fixJmpMain257:
  6594 000022E6 68[4B23]                 push fixJmpMain_2
  6595 000022E9 8D063075                 lea  ax, [Symbol]
  6596 000022ED 50                       push ax
  6597 000022EE E839DF                   call strcpy
  6598 000022F1 83C404                   add  sp, 4
  6599                                  
  6600                                  ;-1044     FixOneJmp(1);//first instruction, PC=1 
  6601                                  
  6602 000022F4 6A01                     push 1
  6603 000022F6 E8E2FE                   call FixOneJmp
  6604 000022F9 83C402                   add  sp, 2
  6605                                  
  6606                                  ;-1045     prs("\nmain ,Label+ORG:"); printhex16(disp);
  6607                                  
  6608 000022FC 68[5023]                 push fixJmpMain_3
  6609 000022FF E831E4                   call prs
  6610 00002302 83C402                   add  sp, 2
  6611 00002305 FF36[3D00]               push word [disp]
  6612 00002309 E80DE5                   call printhex16
  6613 0000230C 83C402                   add  sp, 2
  6614                                  
  6615                                  ;-1046 }
  6616                                  
  6617                                  
  6618                                  ;-1047 
  6619                                  
  6620                                  
  6621                                  ;-1048 
  6622                                  
  6623                                  
  6624                                  ;-1049 int process() {
  6625                                  
  6626 0000230F C3                       ret
  6627 00002310 5C6E666978206A6D70-     fixJmpMain_0 db "\nfix jmp to main. resting global jmp: ",0
  6628 00002319 20746F206D61696E2E-
  6629 00002322 2072657374696E6720-
  6630 0000232B 676C6F62616C206A6D-
  6631 00002334 703A2000           
  6632 00002338 72657374696E672067-     fixJmpMain_1 db "resting global jmp",0
  6633 00002341 6C6F62616C206A6D70-
  6634 0000234A 00                 
  6635 0000234B 6D61696E00              fixJmpMain_2 db "main",0
  6636 00002350 5C6E6D61696E202C4C-     fixJmpMain_3 db "\nmain ,Label+ORG:",0
  6637 00002359 6162656C2B4F52473A-
  6638 00002362 00                 
  6639                                  ENDP
  6640                                  
  6641                                  process: PROC
  6642                                  
  6643                                  ;-1050     char c;
  6644                                  
  6645                                  
  6646                                  ;-1051     int i;
  6647                                  
  6648                                  
  6649                                  ;-1052     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6650                                  
  6651                                  ;Function : process, Number of local variables: 2
  6652                                  ;   # type sign width addr used name   list of local variables
  6653                                  ;  200 var sign byte  1050 NULL c = bp-2
  6654                                  ;  201 var sign word  1051 NULL i = bp-4;
  6655 00002363 C8040000                 ENTER  4,0
  6656 00002367 B80000                   mov ax, 0
  6657 0000236A A2[3B00]                 mov byte [rm], al
  6658 0000236D A2[3800]                 mov byte [wflag], al
  6659 00002370 A2[3900]                 mov byte [dflag], al
  6660 00002373 A2[3300]                 mov byte [R2No], al
  6661 00002376 A2[3400]                 mov byte [R1No], al
  6662 00002379 A2[3500]                 mov byte [R2Type], al
  6663 0000237C A2[3600]                 mov byte [R1Type], al
  6664 0000237F A2[2E00]                 mov byte [Op2], al
  6665 00002382 A2[2D00]                 mov byte [Op], al
  6666                                  
  6667                                  ;-1053     disp=imme=0;//int
  6668                                  
  6669 00002385 B80000                   mov ax, 0
  6670 00002388 A3[3F00]                 mov word [imme], ax
  6671 0000238B A3[3D00]                 mov word [disp], ax
  6672                                  
  6673                                  ;-1054     isDirect=1; //set in getMeM=0, need in WriteEA
  6674                                  
  6675 0000238E B80100                   mov ax, 1
  6676 00002391 A2[3C00]                 mov byte [isDirect], al
  6677                                  
  6678                                  ;-1055     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6679                                  
  6680 00002394 E84AF3                   call getTokeType
  6681                                  
  6682                                  ;-1056     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6683                                  
  6684 00002397 E887FB                   call getCodeSize
  6685 0000239A A2[3700]                 mov byte [OpSize], al
  6686                                  
  6687                                  ;-1057     OpCodePtr ++; Code1 = *OpCodePtr;
  6688                                  
  6689 0000239D FF06[4300]               inc  word[OpCodePtr]
  6690 000023A1 8B1E[4300]               mov bx, [OpCodePtr]
  6691 000023A5 8A07                     mov al, [bx]
  6692 000023A7 B400                     mov ah, 0
  6693 000023A9 A2[3000]                 mov byte [Code1], al
  6694                                  
  6695                                  ;-1058     OpCodePtr ++; Code2 = *OpCodePtr;
  6696                                  
  6697 000023AC FF06[4300]               inc  word[OpCodePtr]
  6698 000023B0 8B1E[4300]               mov bx, [OpCodePtr]
  6699 000023B4 8A07                     mov al, [bx]
  6700 000023B6 B400                     mov ah, 0
  6701 000023B8 A2[3100]                 mov byte [Code2], al
  6702                                  
  6703                                  ;-1059     OpCodePtr ++; Code3 = *OpCodePtr;
  6704                                  
  6705 000023BB FF06[4300]               inc  word[OpCodePtr]
  6706 000023BF 8B1E[4300]               mov bx, [OpCodePtr]
  6707 000023C3 8A07                     mov al, [bx]
  6708 000023C5 B400                     mov ah, 0
  6709 000023C7 A2[3200]                 mov byte [Code3], al
  6710                                  
  6711                                  ;-1060 
  6712                                  
  6713                                  
  6714                                  ;-1061     if (CodeType ==  1) {//1 byte opcode
  6715                                  
  6716 000023CA A0[2F00]                 mov al, [CodeType]
  6717 000023CD 3C01                     cmp al, 1
  6718 000023CF 0F850F00                 jne .process258
  6719                                  
  6720                                  ;-1062         genCode8(Code1);
  6721                                  
  6722 000023D3 A0[3000]                 mov al, byte [Code1]
  6723 000023D6 B400                     mov ah, 0
  6724 000023D8 50                       push ax
  6725 000023D9 E8A6EF                   call genCode8
  6726 000023DC 83C402                   add  sp, 2
  6727                                  
  6728                                  ;-1063         return;
  6729                                  
  6730 000023DF E9A209                   jmp .retnprocess
  6731                                  
  6732                                  ;-1064     }
  6733                                  
  6734                                  
  6735                                  ;-1065 
  6736                                  
  6737                                  
  6738                                  ;-1066     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  6739                                  
  6740                                  .process258:
  6741 000023E2 A0[2F00]                 mov al, [CodeType]
  6742 000023E5 3C02                     cmp al, 2
  6743 000023E7 0F859100                 jne .process259
  6744                                  
  6745                                  ;-1067         getOpL();
  6746                                  
  6747 000023EB E884F7                   call getOpL
  6748                                  
  6749                                  ;-1068         checkOpL();
  6750                                  
  6751 000023EE E80CF4                   call checkOpL
  6752                                  
  6753                                  ;-1069         if (Code1 < 2) {//inc,dec
  6754                                  
  6755 000023F1 A0[3000]                 mov al, [Code1]
  6756 000023F4 3C02                     cmp al, 2
  6757 000023F6 0F8D3D00                 jge .process260
  6758                                  
  6759                                  ;-1070   	        if (Op == REG) {//short
  6760                                  
  6761 000023FA A0[2D00]                 mov al, [Op]
  6762 000023FD 3C02                     cmp al, 2
  6763 000023FF 0F853400                 jne .process261
  6764                                  
  6765                                  ;-1071                 if (wflag) {
  6766                                  
  6767 00002403 A0[3800]                 mov al, [wflag]
  6768 00002406 08C0                     or  al, al
  6769 00002408 0F842B00                 je .process262
  6770                                  
  6771                                  ;-1072                     if (Code1) genCode2(0x48, R1No);//DEC
  6772                                  
  6773 0000240C A0[3000]                 mov al, [Code1]
  6774 0000240F 08C0                     or  al, al
  6775 00002411 0F841100                 je .process263
  6776 00002415 A0[3400]                 mov al, byte [R1No]
  6777 00002418 B400                     mov ah, 0
  6778 0000241A 50                       push ax
  6779 0000241B 6A48                     push 72
  6780 0000241D E8C2EF                   call genCode2
  6781 00002420 83C404                   add  sp, 4
  6782                                  
  6783                                  ;-1073                         else genCode2(0x40, R1No);//INC 
  6784                                  
  6785 00002423 E90E00                   jmp .process264
  6786                                  .process263:
  6787 00002426 A0[3400]                 mov al, byte [R1No]
  6788 00002429 B400                     mov ah, 0
  6789 0000242B 50                       push ax
  6790 0000242C 6A40                     push 64
  6791 0000242E E8B1EF                   call genCode2
  6792 00002431 83C404                   add  sp, 4
  6793                                  
  6794                                  ;-1074                     return; 
  6795                                  
  6796                                  .process264:
  6797 00002434 E94D09                   jmp .retnprocess
  6798                                  
  6799                                  ;-1075                     }
  6800                                  
  6801                                  
  6802                                  ;-1076             }
  6803                                  
  6804                                  .process262:
  6805                                  
  6806                                  ;-1077         }
  6807                                  
  6808                                  .process261:
  6809                                  
  6810                                  ;-1078         if (Code1 == 5) {//imul extension?
  6811                                  
  6812                                  .process260:
  6813 00002437 A0[3000]                 mov al, [Code1]
  6814 0000243A 3C05                     cmp al, 5
  6815 0000243C 0F850F00                 jne .process265
  6816                                  
  6817                                  ;-1079             getTokeType();
  6818                                  
  6819 00002440 E89EF2                   call getTokeType
  6820                                  
  6821                                  ;-1080             if (TokeType) implerror();
  6822                                  
  6823 00002443 A0[2C00]                 mov al, [TokeType]
  6824 00002446 08C0                     or  al, al
  6825 00002448 0F840300                 je .process266
  6826 0000244C E80DE7                   call implerror
  6827                                  
  6828                                  ;-1081         }
  6829                                  
  6830                                  .process266:
  6831                                  
  6832                                  ;-1082         if (Code1 < 2) genCodeW(0xFE);
  6833                                  
  6834                                  .process265:
  6835 0000244F A0[3000]                 mov al, [Code1]
  6836 00002452 3C02                     cmp al, 2
  6837 00002454 0F8D0C00                 jge .process267
  6838 00002458 68FE00                   push 254
  6839 0000245B E89FEF                   call genCodeW
  6840 0000245E 83C402                   add  sp, 2
  6841                                  
  6842                                  ;-1083             else genCodeW(0xF6);
  6843                                  
  6844 00002461 E90900                   jmp .process268
  6845                                  .process267:
  6846 00002464 68F600                   push 246
  6847 00002467 E893EF                   call genCodeW
  6848 0000246A 83C402                   add  sp, 2
  6849                                  
  6850                                  ;-1084         writeEA(Code1);
  6851                                  
  6852                                  .process268:
  6853 0000246D A0[3000]                 mov al, byte [Code1]
  6854 00002470 B400                     mov ah, 0
  6855 00002472 50                       push ax
  6856 00002473 E8EEEF                   call writeEA
  6857 00002476 83C402                   add  sp, 2
  6858                                  
  6859                                  ;-1085         return;
  6860                                  
  6861 00002479 E90809                   jmp .retnprocess
  6862                                  
  6863                                  ;-1086     }
  6864                                  
  6865                                  
  6866                                  ;-1087 
  6867                                  
  6868                                  
  6869                                  ;-1088     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6870                                  
  6871                                  .process259:
  6872 0000247C A0[2F00]                 mov al, [CodeType]
  6873 0000247F 3C03                     cmp al, 3
  6874 00002481 0F855100                 jne .process269
  6875                                  
  6876                                  ;-1089         check2Ops();    //setwflag not applicable
  6877                                  
  6878 00002485 E821F7                   call check2Ops
  6879                                  
  6880                                  ;-1090         if (R1Type != WORD) reg16error();//only r16
  6881                                  
  6882 00002488 A0[3600]                 mov al, [R1Type]
  6883 0000248B 3C02                     cmp al, 2
  6884 0000248D 0F840300                 je  .process270
  6885 00002491 E868E7                   call reg16error
  6886                                  
  6887                                  ;-1091         if (Op2 != MEM) addrerror();//only m16
  6888                                  
  6889                                  .process270:
  6890 00002494 A0[2E00]                 mov al, [Op2]
  6891 00002497 3C04                     cmp al, 4
  6892 00002499 0F840300                 je  .process271
  6893 0000249D E87DE6                   call addrerror
  6894                                  
  6895                                  ;-1092 
  6896                                  
  6897                                  
  6898                                  ;-1093         genCode8(Code1);//les,lds,lea
  6899                                  
  6900                                  .process271:
  6901 000024A0 A0[3000]                 mov al, byte [Code1]
  6902 000024A3 B400                     mov ah, 0
  6903 000024A5 50                       push ax
  6904 000024A6 E8D9EE                   call genCode8
  6905 000024A9 83C402                   add  sp, 2
  6906                                  
  6907                                  ;-1094         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  6908                                  
  6909 000024AC A0[3000]                 mov al, [Code1]
  6910 000024AF 3C0F                     cmp al, 15
  6911 000024B1 0F850C00                 jne .process272
  6912 000024B5 A0[3100]                 mov al, byte [Code2]
  6913 000024B8 B400                     mov ah, 0
  6914 000024BA 50                       push ax
  6915 000024BB E8C4EE                   call genCode8
  6916 000024BE 83C402                   add  sp, 2
  6917                                  
  6918                                  ;-1095         Op=Op2;//set MEM for writeEA
  6919                                  
  6920                                  .process272:
  6921 000024C1 A0[2E00]                 mov al, [Op2]
  6922 000024C4 A2[2D00]                 mov byte [Op], al
  6923                                  
  6924                                  ;-1096         writeEA(R1No);
  6925                                  
  6926 000024C7 A0[3400]                 mov al, byte [R1No]
  6927 000024CA B400                     mov ah, 0
  6928 000024CC 50                       push ax
  6929 000024CD E894EF                   call writeEA
  6930 000024D0 83C402                   add  sp, 2
  6931                                  
  6932                                  ;-1097         return;
  6933                                  
  6934 000024D3 E9AE08                   jmp .retnprocess
  6935                                  
  6936                                  ;-1098     }
  6937                                  
  6938                                  
  6939                                  ;-1099 
  6940                                  
  6941                                  
  6942                                  ;-1100     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6943                                  
  6944                                  .process269:
  6945 000024D6 A0[2F00]                 mov al, [CodeType]
  6946 000024D9 3C04                     cmp al, 4
  6947 000024DB 0F851801                 jne .process273
  6948                                  
  6949                                  ;-1101         check2Ops();  
  6950                                  
  6951 000024DF E8C7F6                   call check2Ops
  6952                                  
  6953                                  ;-1102         if (Op2 == ADR) {  
  6954                                  
  6955 000024E2 A0[2E00]                 mov al, [Op2]
  6956 000024E5 3C03                     cmp al, 3
  6957 000024E7 0F852000                 jne .process274
  6958                                  
  6959                                  ;-1103             if (LabelIx == 0) notfounderror();
  6960                                  
  6961 000024EB A1[4E00]                 mov ax, [LabelIx]
  6962 000024EE 83F800                   cmp ax, 0
  6963 000024F1 0F850300                 jne .process275
  6964 000024F5 E8C3E5                   call notfounderror
  6965                                  
  6966                                  ;-1104             imme=LabelAddr[LabelIx];
  6967                                  
  6968                                  .process275:
  6969 000024F8 8B1E[4E00]               mov bx, [LabelIx]
  6970 000024FC D1E3                     shl bx, 1
  6971 000024FE 8B87CA8E                 mov ax, [LabelAddr + bx]
  6972 00002502 A3[3F00]                 mov word [imme], ax
  6973                                  
  6974                                  ;-1105             Op2=IMM;//got the addr and fall through
  6975                                  
  6976 00002505 B80100                   mov ax, 1
  6977 00002508 A2[2E00]                 mov byte [Op2], al
  6978                                  
  6979                                  ;-1106         }
  6980                                  
  6981                                  
  6982                                  ;-1107         if (Op2 == IMM) {//second operand is imm
  6983                                  
  6984                                  .process274:
  6985 0000250B A0[2E00]                 mov al, [Op2]
  6986 0000250E 3C01                     cmp al, 1
  6987 00002510 0F857900                 jne .process276
  6988                                  
  6989                                  ;-1108             setsflag();
  6990                                  
  6991 00002514 E800F1                   call setsflag
  6992                                  
  6993                                  ;-1109             if (Op == REG) {
  6994                                  
  6995 00002517 A0[2D00]                 mov al, [Op]
  6996 0000251A 3C02                     cmp al, 2
  6997 0000251C 0F853100                 jne .process277
  6998                                  
  6999                                  ;-1110                 if (R1No == 0) {// acc,imm
  7000                                  
  7001 00002520 A0[3400]                 mov al, [R1No]
  7002 00002523 3C00                     cmp al, 0
  7003 00002525 0F852800                 jne .process278
  7004                                  
  7005                                  ;-1111                     if (sflag == 0) {
  7006                                  
  7007 00002529 A0[3A00]                 mov al, [sflag]
  7008 0000252C 3C00                     cmp al, 0
  7009 0000252E 0F851F00                 jne .process279
  7010                                  
  7011                                  ;-1112                         c = Code1 << 3;
  7012                                  
  7013 00002532 A0[3000]                 mov al, [Code1]
  7014 00002535 C0E003                   shl al, 3
  7015 00002538 8846FE                   mov [bp-2], al
  7016                                  
  7017                                  ;-1113                         c += 4;
  7018                                  
  7019 0000253B 8046FE04                 add  byte[bp-2], 4
  7020                                  
  7021                                  ;-1114                         genCodeW(c);
  7022                                  
  7023 0000253F 8A46FE                   mov al, byte [bp-2]
  7024 00002542 B400                     mov ah, 0
  7025 00002544 50                       push ax
  7026 00002545 E8B5EE                   call genCodeW
  7027 00002548 83C402                   add  sp, 2
  7028                                  
  7029                                  ;-1115                         genImmediate();
  7030                                  
  7031 0000254B E825F0                   call genImmediate
  7032                                  
  7033                                  ;-1116                         return;
  7034                                  
  7035 0000254E E93308                   jmp .retnprocess
  7036                                  
  7037                                  ;-1117                     }
  7038                                  
  7039                                  
  7040                                  ;-1118                 }
  7041                                  
  7042                                  .process279:
  7043                                  
  7044                                  ;-1119             }
  7045                                  
  7046                                  .process278:
  7047                                  
  7048                                  ;-1120             //r/m, imm: 80 sign-extended,TTT,imm
  7049                                  
  7050                                  
  7051                                  ;-1121             c = sflag + 0x80;
  7052                                  
  7053                                  .process277:
  7054 00002551 A0[3A00]                 mov al, [sflag]
  7055 00002554 0480                     add al, 128
  7056 00002556 8846FE                   mov [bp-2], al
  7057                                  
  7058                                  ;-1122             genCodeW(c);
  7059                                  
  7060 00002559 8A46FE                   mov al, byte [bp-2]
  7061 0000255C B400                     mov ah, 0
  7062 0000255E 50                       push ax
  7063 0000255F E89BEE                   call genCodeW
  7064 00002562 83C402                   add  sp, 2
  7065                                  
  7066                                  ;-1123             writeEA(Code1);
  7067                                  
  7068 00002565 A0[3000]                 mov al, byte [Code1]
  7069 00002568 B400                     mov ah, 0
  7070 0000256A 50                       push ax
  7071 0000256B E8F6EE                   call writeEA
  7072 0000256E 83C402                   add  sp, 2
  7073                                  
  7074                                  ;-1124             if (sflag) genCode8(imme);
  7075                                  
  7076 00002571 A0[3A00]                 mov al, [sflag]
  7077 00002574 08C0                     or  al, al
  7078 00002576 0F840D00                 je .process280
  7079 0000257A FF36[3F00]               push word [imme]
  7080 0000257E E801EE                   call genCode8
  7081 00002581 83C402                   add  sp, 2
  7082                                  
  7083                                  ;-1125             else genImmediate();
  7084                                  
  7085 00002584 E90300                   jmp .process281
  7086                                  .process280:
  7087 00002587 E8E9EF                   call genImmediate
  7088                                  
  7089                                  ;-1126             return;
  7090                                  
  7091                                  .process281:
  7092 0000258A E9F707                   jmp .retnprocess
  7093                                  
  7094                                  ;-1127         }
  7095                                  
  7096                                  
  7097                                  ;-1128         c = Code1 << 3;//r/m, r/r
  7098                                  
  7099                                  .process276:
  7100 0000258D A0[3000]                 mov al, [Code1]
  7101 00002590 C0E003                   shl al, 3
  7102 00002593 8846FE                   mov [bp-2], al
  7103                                  
  7104                                  ;-1129         if (Op == REG) {
  7105                                  
  7106 00002596 A0[2D00]                 mov al, [Op]
  7107 00002599 3C02                     cmp al, 2
  7108 0000259B 0F852E00                 jne .process282
  7109                                  
  7110                                  ;-1130             if (Op2 == MEM) {//reg, mem
  7111                                  
  7112 0000259F A0[2E00]                 mov al, [Op2]
  7113 000025A2 3C04                     cmp al, 4
  7114 000025A4 0F852500                 jne .process283
  7115                                  
  7116                                  ;-1131                 c += 2;//add direction flag
  7117                                  
  7118 000025A8 8046FE02                 add  byte[bp-2], 2
  7119                                  
  7120                                  ;-1132                 genCodeW(c);
  7121                                  
  7122 000025AC 8A46FE                   mov al, byte [bp-2]
  7123 000025AF B400                     mov ah, 0
  7124 000025B1 50                       push ax
  7125 000025B2 E848EE                   call genCodeW
  7126 000025B5 83C402                   add  sp, 2
  7127                                  
  7128                                  ;-1133                 Op=Op2;//set MEM for writeEA
  7129                                  
  7130 000025B8 A0[2E00]                 mov al, [Op2]
  7131 000025BB A2[2D00]                 mov byte [Op], al
  7132                                  
  7133                                  ;-1134                 writeEA(R1No);
  7134                                  
  7135 000025BE A0[3400]                 mov al, byte [R1No]
  7136 000025C1 B400                     mov ah, 0
  7137 000025C3 50                       push ax
  7138 000025C4 E89DEE                   call writeEA
  7139 000025C7 83C402                   add  sp, 2
  7140                                  
  7141                                  ;-1135                 return;
  7142                                  
  7143 000025CA E9B707                   jmp .retnprocess
  7144                                  
  7145                                  ;-1136             }
  7146                                  
  7147                                  
  7148                                  ;-1137         }
  7149                                  
  7150                                  .process283:
  7151                                  
  7152                                  ;-1138         if (Op2 == REG) {//mem,reg    reg,reg
  7153                                  
  7154                                  .process282:
  7155 000025CD A0[2E00]                 mov al, [Op2]
  7156 000025D0 3C02                     cmp al, 2
  7157 000025D2 0F851B00                 jne .process284
  7158                                  
  7159                                  ;-1139             genCodeW(c);
  7160                                  
  7161 000025D6 8A46FE                   mov al, byte [bp-2]
  7162 000025D9 B400                     mov ah, 0
  7163 000025DB 50                       push ax
  7164 000025DC E81EEE                   call genCodeW
  7165 000025DF 83C402                   add  sp, 2
  7166                                  
  7167                                  ;-1140             writeEA(R2No);//2. Op in reg-field
  7168                                  
  7169 000025E2 A0[3300]                 mov al, byte [R2No]
  7170 000025E5 B400                     mov ah, 0
  7171 000025E7 50                       push ax
  7172 000025E8 E879EE                   call writeEA
  7173 000025EB 83C402                   add  sp, 2
  7174                                  
  7175                                  ;-1141             return;
  7176                                  
  7177 000025EE E99307                   jmp .retnprocess
  7178                                  
  7179                                  ;-1142         }
  7180                                  
  7181                                  
  7182                                  ;-1143         syntaxerror();
  7183                                  
  7184                                  .process284:
  7185 000025F1 E857E6                   call syntaxerror
  7186                                  
  7187                                  ;-1144         return;
  7188                                  
  7189 000025F4 E98D07                   jmp .retnprocess
  7190                                  
  7191                                  ;-1145     }
  7192                                  
  7193                                  
  7194                                  ;-1146 
  7195                                  
  7196                                  
  7197                                  ;-1147     if (CodeType == 5) {//mov (movsx, movzx=51)
  7198                                  
  7199                                  .process273:
  7200 000025F7 A0[2F00]                 mov al, [CodeType]
  7201 000025FA 3C05                     cmp al, 5
  7202 000025FC 0F858B01                 jne .process285
  7203                                  
  7204                                  ;-1148         check2Ops();
  7205                                  
  7206 00002600 E8A6F5                   call check2Ops
  7207                                  
  7208                                  ;-1149         if (Op2 == ADR) {
  7209                                  
  7210 00002603 A0[2E00]                 mov al, [Op2]
  7211 00002606 3C03                     cmp al, 3
  7212 00002608 0F851B00                 jne .process286
  7213                                  
  7214                                  ;-1150             if (disp) imme=disp;
  7215                                  
  7216 0000260C A1[3D00]                 mov ax, [disp]
  7217 0000260F 08C0                     or  al, al
  7218 00002611 0F840900                 je .process287
  7219 00002615 A1[3D00]                 mov ax, [disp]
  7220 00002618 A3[3F00]                 mov word [imme], ax
  7221                                  
  7222                                  ;-1151             else notfounderror();
  7223                                  
  7224 0000261B E90300                   jmp .process288
  7225                                  .process287:
  7226 0000261E E89AE4                   call notfounderror
  7227                                  
  7228                                  ;-1152             Op2=IMM;//continue with IMM
  7229                                  
  7230                                  .process288:
  7231 00002621 B80100                   mov ax, 1
  7232 00002624 A2[2E00]                 mov byte [Op2], al
  7233                                  
  7234                                  ;-1153         }
  7235                                  
  7236                                  
  7237                                  ;-1154         if (Op2 == IMM) {// r,i
  7238                                  
  7239                                  .process286:
  7240 00002627 A0[2E00]                 mov al, [Op2]
  7241 0000262A 3C01                     cmp al, 1
  7242 0000262C 0F855400                 jne .process289
  7243                                  
  7244                                  ;-1155             if (Op == REG) {
  7245                                  
  7246 00002630 A0[2D00]                 mov al, [Op]
  7247 00002633 3C02                     cmp al, 2
  7248 00002635 0F852500                 jne .process290
  7249                                  
  7250                                  ;-1156                 c = wflag << 3;
  7251                                  
  7252 00002639 A0[3800]                 mov al, [wflag]
  7253 0000263C C0E003                   shl al, 3
  7254 0000263F 8846FE                   mov [bp-2], al
  7255                                  
  7256                                  ;-1157                 c += 0xB0;
  7257                                  
  7258 00002642 8046FEB0                 add  byte[bp-2], 176
  7259                                  
  7260                                  ;-1158                 genCode2(c, R1No);
  7261                                  
  7262 00002646 A0[3400]                 mov al, byte [R1No]
  7263 00002649 B400                     mov ah, 0
  7264 0000264B 50                       push ax
  7265 0000264C 8A46FE                   mov al, byte [bp-2]
  7266 0000264F B400                     mov ah, 0
  7267 00002651 50                       push ax
  7268 00002652 E88DED                   call genCode2
  7269 00002655 83C404                   add  sp, 4
  7270                                  
  7271                                  ;-1159                 genImmediate();
  7272                                  
  7273 00002658 E818EF                   call genImmediate
  7274                                  
  7275                                  ;-1160                 return;
  7276                                  
  7277 0000265B E92607                   jmp .retnprocess
  7278                                  
  7279                                  ;-1161             }
  7280                                  
  7281                                  
  7282                                  ;-1162             if (Op == MEM) {// m,i
  7283                                  
  7284                                  .process290:
  7285 0000265E A0[2D00]                 mov al, [Op]
  7286 00002661 3C04                     cmp al, 4
  7287 00002663 0F851700                 jne .process291
  7288                                  
  7289                                  ;-1163                 genCodeW(0xC6);
  7290                                  
  7291 00002667 68C600                   push 198
  7292 0000266A E890ED                   call genCodeW
  7293 0000266D 83C402                   add  sp, 2
  7294                                  
  7295                                  ;-1164                 writeEA( 0 );
  7296                                  
  7297 00002670 6A00                     push 0
  7298 00002672 E8EFED                   call writeEA
  7299 00002675 83C402                   add  sp, 2
  7300                                  
  7301                                  ;-1165                 genImmediate();
  7302                                  
  7303 00002678 E8F8EE                   call genImmediate
  7304                                  
  7305                                  ;-1166                 return;
  7306                                  
  7307 0000267B E90607                   jmp .retnprocess
  7308                                  
  7309                                  ;-1167             }
  7310                                  
  7311                                  
  7312                                  ;-1168             regmemerror();
  7313                                  
  7314                                  .process291:
  7315 0000267E E851E5                   call regmemerror
  7316                                  
  7317                                  ;-1169             return;
  7318                                  
  7319 00002681 E90007                   jmp .retnprocess
  7320                                  
  7321                                  ;-1170         }
  7322                                  
  7323                                  
  7324                                  ;-1171         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  7325                                  
  7326                                  .process289:
  7327 00002684 A0[3600]                 mov al, [R1Type]
  7328 00002687 3C04                     cmp al, 4
  7329 00002689 0F850300                 jne .process292
  7330 0000268D E80FF0                   call ChangeDirection
  7331                                  
  7332                                  ;-1172         if (R2Type == SEGREG) {//rm,sreg
  7333                                  
  7334                                  .process292:
  7335 00002690 A0[3500]                 mov al, [R2Type]
  7336 00002693 3C04                     cmp al, 4
  7337 00002695 0F852A00                 jne .process293
  7338                                  
  7339                                  ;-1173             if (OpSize != WORD) reg16error();
  7340                                  
  7341 00002699 A0[3700]                 mov al, [OpSize]
  7342 0000269C 3C02                     cmp al, 2
  7343 0000269E 0F840300                 je  .process294
  7344 000026A2 E857E5                   call reg16error
  7345                                  
  7346                                  ;-1174                 genCode2(0x8C, dflag);
  7347                                  
  7348                                  .process294:
  7349 000026A5 A0[3900]                 mov al, byte [dflag]
  7350 000026A8 B400                     mov ah, 0
  7351 000026AA 50                       push ax
  7352 000026AB 688C00                   push 140
  7353 000026AE E831ED                   call genCode2
  7354 000026B1 83C404                   add  sp, 4
  7355                                  
  7356                                  ;-1175                 writeEA(R2No);
  7357                                  
  7358 000026B4 A0[3300]                 mov al, byte [R2No]
  7359 000026B7 B400                     mov ah, 0
  7360 000026B9 50                       push ax
  7361 000026BA E8A7ED                   call writeEA
  7362 000026BD 83C402                   add  sp, 2
  7363                                  
  7364                                  ;-1176                 return;
  7365                                  
  7366 000026C0 E9C106                   jmp .retnprocess
  7367                                  
  7368                                  ;-1177         }
  7369                                  
  7370                                  
  7371                                  ;-1178         if (Op2 == MEM) {//acc, moffs16
  7372                                  
  7373                                  .process293:
  7374 000026C3 A0[2E00]                 mov al, [Op2]
  7375 000026C6 3C04                     cmp al, 4
  7376 000026C8 0F853100                 jne .process295
  7377                                  
  7378                                  ;-1179             if (Op == REG) {
  7379                                  
  7380 000026CC A0[2D00]                 mov al, [Op]
  7381 000026CF 3C02                     cmp al, 2
  7382 000026D1 0F852800                 jne .process296
  7383                                  
  7384                                  ;-1180                 if (R1No == 0) {
  7385                                  
  7386 000026D5 A0[3400]                 mov al, [R1No]
  7387 000026D8 3C00                     cmp al, 0
  7388 000026DA 0F851F00                 jne .process297
  7389                                  
  7390                                  ;-1181                     if (isDirect) {
  7391                                  
  7392 000026DE A0[3C00]                 mov al, [isDirect]
  7393 000026E1 08C0                     or  al, al
  7394 000026E3 0F841600                 je .process298
  7395                                  
  7396                                  ;-1182                         genCodeW(0xA0);
  7397                                  
  7398 000026E7 68A000                   push 160
  7399 000026EA E810ED                   call genCodeW
  7400 000026ED 83C402                   add  sp, 2
  7401                                  
  7402                                  ;-1183                         genCode16(disp);
  7403                                  
  7404 000026F0 FF36[3D00]               push word [disp]
  7405 000026F4 E822ED                   call genCode16
  7406 000026F7 83C402                   add  sp, 2
  7407                                  
  7408                                  ;-1184                         return;
  7409                                  
  7410 000026FA E98706                   jmp .retnprocess
  7411                                  
  7412                                  ;-1185                     }
  7413                                  
  7414                                  
  7415                                  ;-1186                 }
  7416                                  
  7417                                  .process298:
  7418                                  
  7419                                  ;-1187             }
  7420                                  
  7421                                  .process297:
  7422                                  
  7423                                  ;-1188         }
  7424                                  
  7425                                  .process296:
  7426                                  
  7427                                  ;-1189         if (Op == MEM) {//moffs16, acc
  7428                                  
  7429                                  .process295:
  7430 000026FD A0[2D00]                 mov al, [Op]
  7431 00002700 3C04                     cmp al, 4
  7432 00002702 0F853100                 jne .process299
  7433                                  
  7434                                  ;-1190             if (Op2 == REG) {
  7435                                  
  7436 00002706 A0[2E00]                 mov al, [Op2]
  7437 00002709 3C02                     cmp al, 2
  7438 0000270B 0F852800                 jne .process300
  7439                                  
  7440                                  ;-1191                 if (R2No == 0) {
  7441                                  
  7442 0000270F A0[3300]                 mov al, [R2No]
  7443 00002712 3C00                     cmp al, 0
  7444 00002714 0F851F00                 jne .process301
  7445                                  
  7446                                  ;-1192                     if (isDirect) {
  7447                                  
  7448 00002718 A0[3C00]                 mov al, [isDirect]
  7449 0000271B 08C0                     or  al, al
  7450 0000271D 0F841600                 je .process302
  7451                                  
  7452                                  ;-1193                         genCodeW(0xA2);
  7453                                  
  7454 00002721 68A200                   push 162
  7455 00002724 E8D6EC                   call genCodeW
  7456 00002727 83C402                   add  sp, 2
  7457                                  
  7458                                  ;-1194                         genCode16(disp);
  7459                                  
  7460 0000272A FF36[3D00]               push word [disp]
  7461 0000272E E8E8EC                   call genCode16
  7462 00002731 83C402                   add  sp, 2
  7463                                  
  7464                                  ;-1195                         return;
  7465                                  
  7466 00002734 E94D06                   jmp .retnprocess
  7467                                  
  7468                                  ;-1196                     }
  7469                                  
  7470                                  
  7471                                  ;-1197                 }
  7472                                  
  7473                                  .process302:
  7474                                  
  7475                                  ;-1198             }
  7476                                  
  7477                                  .process301:
  7478                                  
  7479                                  ;-1199 
  7480                                  
  7481                                  
  7482                                  ;-1200         }
  7483                                  
  7484                                  .process300:
  7485                                  
  7486                                  ;-1201         if (Op2 == REG) {//rm, r
  7487                                  
  7488                                  .process299:
  7489 00002737 A0[2E00]                 mov al, [Op2]
  7490 0000273A 3C02                     cmp al, 2
  7491 0000273C 0F851800                 jne .process303
  7492                                  
  7493                                  ;-1202             genCodeW(0x88);
  7494                                  
  7495 00002740 688800                   push 136
  7496 00002743 E8B7EC                   call genCodeW
  7497 00002746 83C402                   add  sp, 2
  7498                                  
  7499                                  ;-1203             writeEA(R2No);
  7500                                  
  7501 00002749 A0[3300]                 mov al, byte [R2No]
  7502 0000274C B400                     mov ah, 0
  7503 0000274E 50                       push ax
  7504 0000274F E812ED                   call writeEA
  7505 00002752 83C402                   add  sp, 2
  7506                                  
  7507                                  ;-1204             return;
  7508                                  
  7509 00002755 E92C06                   jmp .retnprocess
  7510                                  
  7511                                  ;-1205         }
  7512                                  
  7513                                  
  7514                                  ;-1206         if (Op2 == MEM) {//r, m
  7515                                  
  7516                                  .process303:
  7517 00002758 A0[2E00]                 mov al, [Op2]
  7518 0000275B 3C04                     cmp al, 4
  7519 0000275D 0F852400                 jne .process304
  7520                                  
  7521                                  ;-1207             if (Op == REG) {
  7522                                  
  7523 00002761 A0[2D00]                 mov al, [Op]
  7524 00002764 3C02                     cmp al, 2
  7525 00002766 0F851B00                 jne .process305
  7526                                  
  7527                                  ;-1208                 ChangeDirection();
  7528                                  
  7529 0000276A E832EF                   call ChangeDirection
  7530                                  
  7531                                  ;-1209                 genCodeW(0x8A);
  7532                                  
  7533 0000276D 688A00                   push 138
  7534 00002770 E88AEC                   call genCodeW
  7535 00002773 83C402                   add  sp, 2
  7536                                  
  7537                                  ;-1210                 writeEA(R2No);
  7538                                  
  7539 00002776 A0[3300]                 mov al, byte [R2No]
  7540 00002779 B400                     mov ah, 0
  7541 0000277B 50                       push ax
  7542 0000277C E8E5EC                   call writeEA
  7543 0000277F 83C402                   add  sp, 2
  7544                                  
  7545                                  ;-1211                 return;
  7546                                  
  7547 00002782 E9FF05                   jmp .retnprocess
  7548                                  
  7549                                  ;-1212             }
  7550                                  
  7551                                  
  7552                                  ;-1213         }
  7553                                  
  7554                                  .process305:
  7555                                  
  7556                                  ;-1214         syntaxerror();
  7557                                  
  7558                                  .process304:
  7559 00002785 E8C3E4                   call syntaxerror
  7560                                  
  7561                                  ;-1215         return;
  7562                                  
  7563 00002788 E9F905                   jmp .retnprocess
  7564                                  
  7565                                  ;-1216     }
  7566                                  
  7567                                  
  7568                                  ;-1217 
  7569                                  
  7570                                  
  7571                                  ;-1218     if (CodeType == 6) {//Jcc
  7572                                  
  7573                                  .process285:
  7574 0000278B A0[2F00]                 mov al, [CodeType]
  7575 0000278E 3C06                     cmp al, 6
  7576 00002790 0F85BE00                 jne .process306
  7577                                  
  7578                                  ;-1219         if (TokeType == ALNUME) {
  7579                                  
  7580 00002794 A0[2C00]                 mov al, [TokeType]
  7581 00002797 3C03                     cmp al, 3
  7582 00002799 0F85B500                 jne .process307
  7583                                  
  7584                                  ;-1220             LabelIx=searchLabel();
  7585                                  
  7586 0000279D E8DFF0                   call searchLabel
  7587 000027A0 A3[4E00]                 mov word [LabelIx], ax
  7588                                  
  7589                                  ;-1221             if (LabelIx > 0) {
  7590                                  
  7591 000027A3 A1[4E00]                 mov ax, [LabelIx]
  7592 000027A6 83F800                   cmp ax, 0
  7593 000027A9 0F8E7A00                 jle .process308
  7594                                  
  7595                                  ;-1222                 disp=LabelAddr[LabelIx];
  7596                                  
  7597 000027AD 8B1E[4E00]               mov bx, [LabelIx]
  7598 000027B1 D1E3                     shl bx, 1
  7599 000027B3 8B87CA8E                 mov ax, [LabelAddr + bx]
  7600 000027B7 A3[3D00]                 mov word [disp], ax
  7601                                  
  7602                                  ;-1223                 disp = disp - PC;
  7603                                  
  7604 000027BA A1[3D00]                 mov ax, [disp]
  7605 000027BD 2B06[2300]               sub ax, [PC]
  7606 000027C1 A3[3D00]                 mov word [disp], ax
  7607                                  
  7608                                  ;-1224                 disp = disp - Origin;
  7609                                  
  7610 000027C4 A1[3D00]                 mov ax, [disp]
  7611 000027C7 2B06[2500]               sub ax, [Origin]
  7612 000027CB A3[3D00]                 mov word [disp], ax
  7613                                  
  7614                                  ;-1225                 if (checkConstSize(disp) ) {
  7615                                  
  7616 000027CE FF36[3D00]               push word [disp]
  7617 000027D2 E89EEE                   call checkConstSize
  7618 000027D5 83C402                   add  sp, 2
  7619 000027D8 08C0                     or  al, al
  7620 000027DA 0F842000                 je .process309
  7621                                  
  7622                                  ;-1226                     genCode2(Code1, 0x70);//short
  7623                                  
  7624 000027DE 6A70                     push 112
  7625 000027E0 A0[3000]                 mov al, byte [Code1]
  7626 000027E3 B400                     mov ah, 0
  7627 000027E5 50                       push ax
  7628 000027E6 E8F9EB                   call genCode2
  7629 000027E9 83C404                   add  sp, 4
  7630                                  
  7631                                  ;-1227                     disp -= 2;
  7632                                  
  7633 000027EC 832E[3D00]02             sub  word[disp], 2
  7634                                  
  7635                                  ;-1228                     genCode8(disp);
  7636                                  
  7637 000027F1 FF36[3D00]               push word [disp]
  7638 000027F5 E88AEB                   call genCode8
  7639 000027F8 83C402                   add  sp, 2
  7640                                  
  7641                                  ;-1229                 } else {
  7642                                  
  7643 000027FB E92600                   jmp .process310
  7644                                  .process309:
  7645                                  
  7646                                  ;-1230                     genCode8(0x0F);
  7647                                  
  7648 000027FE 6A0F                     push 15
  7649 00002800 E87FEB                   call genCode8
  7650 00002803 83C402                   add  sp, 2
  7651                                  
  7652                                  ;-1231                     genCode2(Code1, 0x80);//near
  7653                                  
  7654 00002806 688000                   push 128
  7655 00002809 A0[3000]                 mov al, byte [Code1]
  7656 0000280C B400                     mov ah, 0
  7657 0000280E 50                       push ax
  7658 0000280F E8D0EB                   call genCode2
  7659 00002812 83C404                   add  sp, 4
  7660                                  
  7661                                  ;-1232                     disp -= 4;
  7662                                  
  7663 00002815 832E[3D00]04             sub  word[disp], 4
  7664                                  
  7665                                  ;-1233                     genCode16(disp);
  7666                                  
  7667 0000281A FF36[3D00]               push word [disp]
  7668 0000281E E8F8EB                   call genCode16
  7669 00002821 83C402                   add  sp, 2
  7670                                  
  7671                                  ;-1234                 }
  7672                                  
  7673                                  
  7674                                  ;-1235             }
  7675                                  
  7676                                  .process310:
  7677                                  
  7678                                  ;-1236             else {//jump forward, near only
  7679                                  
  7680 00002824 E92800                   jmp .process311
  7681                                  .process308:
  7682                                  
  7683                                  ;-1237                 genCode8(0x0F);
  7684                                  
  7685 00002827 6A0F                     push 15
  7686 00002829 E856EB                   call genCode8
  7687 0000282C 83C402                   add  sp, 2
  7688                                  
  7689                                  ;-1238                 genCode2(Code1, 0x80);
  7690                                  
  7691 0000282F 688000                   push 128
  7692 00002832 A0[3000]                 mov al, byte [Code1]
  7693 00002835 B400                     mov ah, 0
  7694 00002837 50                       push ax
  7695 00002838 E8A7EB                   call genCode2
  7696 0000283B 83C404                   add  sp, 4
  7697                                  
  7698                                  ;-1239                 storeJmp();
  7699                                  
  7700 0000283E E89FF3                   call storeJmp
  7701                                  
  7702                                  ;-1240                 genCode16(0);
  7703                                  
  7704 00002841 6A00                     push 0
  7705 00002843 E8D3EB                   call genCode16
  7706 00002846 83C402                   add  sp, 2
  7707                                  
  7708                                  ;-1241                 PrintRA='r';
  7709                                  
  7710 00002849 B87200                   mov ax, 114
  7711 0000284C A2[4500]                 mov byte [PrintRA], al
  7712                                  
  7713                                  ;-1242             }
  7714                                  
  7715                                  
  7716                                  ;-1243         return;
  7717                                  
  7718                                  .process311:
  7719 0000284F E93205                   jmp .retnprocess
  7720                                  
  7721                                  ;-1244         }
  7722                                  
  7723                                  
  7724                                  ;-1245     }
  7725                                  
  7726                                  .process307:
  7727                                  
  7728                                  ;-1246 
  7729                                  
  7730                                  
  7731                                  ;-1247     if (CodeType == 7) {//jmp, call
  7732                                  
  7733                                  .process306:
  7734 00002852 A0[2F00]                 mov al, [CodeType]
  7735 00002855 3C07                     cmp al, 7
  7736 00002857 0F85D400                 jne .process312
  7737                                  
  7738                                  ;-1248         if (TokeType == ALNUME) {
  7739                                  
  7740 0000285B A0[2C00]                 mov al, [TokeType]
  7741 0000285E 3C03                     cmp al, 3
  7742 00002860 0F85CB00                 jne .process313
  7743                                  
  7744                                  ;-1249             LabelIx=searchLabel();
  7745                                  
  7746 00002864 E818F0                   call searchLabel
  7747 00002867 A3[4E00]                 mov word [LabelIx], ax
  7748                                  
  7749                                  ;-1250             if (LabelIx > 0) {
  7750                                  
  7751 0000286A A1[4E00]                 mov ax, [LabelIx]
  7752 0000286D 83F800                   cmp ax, 0
  7753 00002870 0F8E9100                 jle .process314
  7754                                  
  7755                                  ;-1251                 disp=LabelAddr[LabelIx];
  7756                                  
  7757 00002874 8B1E[4E00]               mov bx, [LabelIx]
  7758 00002878 D1E3                     shl bx, 1
  7759 0000287A 8B87CA8E                 mov ax, [LabelAddr + bx]
  7760 0000287E A3[3D00]                 mov word [disp], ax
  7761                                  
  7762                                  ;-1252                 disp = disp - PC;
  7763                                  
  7764 00002881 A1[3D00]                 mov ax, [disp]
  7765 00002884 2B06[2300]               sub ax, [PC]
  7766 00002888 A3[3D00]                 mov word [disp], ax
  7767                                  
  7768                                  ;-1253                 disp = disp - Origin;
  7769                                  
  7770 0000288B A1[3D00]                 mov ax, [disp]
  7771 0000288E 2B06[2500]               sub ax, [Origin]
  7772 00002892 A3[3D00]                 mov word [disp], ax
  7773                                  
  7774                                  ;-1254                 if (checkConstSize(disp) ) {
  7775                                  
  7776 00002895 FF36[3D00]               push word [disp]
  7777 00002899 E8D7ED                   call checkConstSize
  7778 0000289C 83C402                   add  sp, 2
  7779 0000289F 08C0                     or  al, al
  7780 000028A1 0F844200                 je .process315
  7781                                  
  7782                                  ;-1255                     if (Code1 == 0xE9) {//jmp only
  7783                                  
  7784 000028A5 A0[3000]                 mov al, [Code1]
  7785 000028A8 3CE9                     cmp al, 233
  7786 000028AA 0F851B00                 jne .process316
  7787                                  
  7788                                  ;-1256                         genCode8(0xEB);//short
  7789                                  
  7790 000028AE 68EB00                   push 235
  7791 000028B1 E8CEEA                   call genCode8
  7792 000028B4 83C402                   add  sp, 2
  7793                                  
  7794                                  ;-1257                         disp -= 2;
  7795                                  
  7796 000028B7 832E[3D00]02             sub  word[disp], 2
  7797                                  
  7798                                  ;-1258                         genCode8(disp);
  7799                                  
  7800 000028BC FF36[3D00]               push word [disp]
  7801 000028C0 E8BFEA                   call genCode8
  7802 000028C3 83C402                   add  sp, 2
  7803                                  
  7804                                  ;-1259                     }
  7805                                  
  7806                                  
  7807                                  ;-1260                     else {
  7808                                  
  7809 000028C6 E91B00                   jmp .process317
  7810                                  .process316:
  7811                                  
  7812                                  ;-1261                         genCode8(Code1);//near
  7813                                  
  7814 000028C9 A0[3000]                 mov al, byte [Code1]
  7815 000028CC B400                     mov ah, 0
  7816 000028CE 50                       push ax
  7817 000028CF E8B0EA                   call genCode8
  7818 000028D2 83C402                   add  sp, 2
  7819                                  
  7820                                  ;-1262                         disp -= 3;
  7821                                  
  7822 000028D5 832E[3D00]03             sub  word[disp], 3
  7823                                  
  7824                                  ;-1263                         genCode16(disp);
  7825                                  
  7826 000028DA FF36[3D00]               push word [disp]
  7827 000028DE E838EB                   call genCode16
  7828 000028E1 83C402                   add  sp, 2
  7829                                  
  7830                                  ;-1264                     }
  7831                                  
  7832                                  
  7833                                  ;-1265                 }
  7834                                  
  7835                                  .process317:
  7836                                  
  7837                                  ;-1266                 else {
  7838                                  
  7839 000028E4 E91B00                   jmp .process318
  7840                                  .process315:
  7841                                  
  7842                                  ;-1267                     genCode8(Code1);//near
  7843                                  
  7844 000028E7 A0[3000]                 mov al, byte [Code1]
  7845 000028EA B400                     mov ah, 0
  7846 000028EC 50                       push ax
  7847 000028ED E892EA                   call genCode8
  7848 000028F0 83C402                   add  sp, 2
  7849                                  
  7850                                  ;-1268                     disp -= 3;
  7851                                  
  7852 000028F3 832E[3D00]03             sub  word[disp], 3
  7853                                  
  7854                                  ;-1269                     genCode16(disp);
  7855                                  
  7856 000028F8 FF36[3D00]               push word [disp]
  7857 000028FC E81AEB                   call genCode16
  7858 000028FF 83C402                   add  sp, 2
  7859                                  
  7860                                  ;-1270                 }
  7861                                  
  7862                                  
  7863                                  ;-1271             }
  7864                                  
  7865                                  .process318:
  7866                                  
  7867                                  ;-1272             else {//jump forward, near only
  7868                                  
  7869 00002902 E92700                   jmp .process319
  7870                                  .process314:
  7871                                  
  7872                                  ;-1273                 genCode8(Code1);  
  7873                                  
  7874 00002905 A0[3000]                 mov al, byte [Code1]
  7875 00002908 B400                     mov ah, 0
  7876 0000290A 50                       push ax
  7877 0000290B E874EA                   call genCode8
  7878 0000290E 83C402                   add  sp, 2
  7879                                  
  7880                                  ;-1274                 if (PC != 1) storeJmp();//omit jmp main
  7881                                  
  7882 00002911 A1[2300]                 mov ax, [PC]
  7883 00002914 83F801                   cmp ax, 1
  7884 00002917 0F840300                 je  .process320
  7885 0000291B E8C2F2                   call storeJmp
  7886                                  
  7887                                  ;-1275                 genCode16(0);
  7888                                  
  7889                                  .process320:
  7890 0000291E 6A00                     push 0
  7891 00002920 E8F6EA                   call genCode16
  7892 00002923 83C402                   add  sp, 2
  7893                                  
  7894                                  ;-1276                 PrintRA='R';
  7895                                  
  7896 00002926 B85200                   mov ax, 82
  7897 00002929 A2[4500]                 mov byte [PrintRA], al
  7898                                  
  7899                                  ;-1277             }
  7900                                  
  7901                                  
  7902                                  ;-1278         return;
  7903                                  
  7904                                  .process319:
  7905 0000292C E95504                   jmp .retnprocess
  7906                                  
  7907                                  ;-1279         }
  7908                                  
  7909                                  
  7910                                  ;-1280     }
  7911                                  
  7912                                  .process313:
  7913                                  
  7914                                  ;-1281 
  7915                                  
  7916                                  
  7917                                  ;-1282     if (CodeType ==  8) {//ret,retf
  7918                                  
  7919                                  .process312:
  7920 0000292F A0[2F00]                 mov al, [CodeType]
  7921 00002932 3C08                     cmp al, 8
  7922 00002934 0F853100                 jne .process321
  7923                                  
  7924                                  ;-1283         if (TokeType == DIGIT) {
  7925                                  
  7926 00002938 A0[2C00]                 mov al, [TokeType]
  7927 0000293B 3C01                     cmp al, 1
  7928 0000293D 0F851900                 jne .process322
  7929                                  
  7930                                  ;-1284             genCode8(Code2);
  7931                                  
  7932 00002941 A0[3100]                 mov al, byte [Code2]
  7933 00002944 B400                     mov ah, 0
  7934 00002946 50                       push ax
  7935 00002947 E838EA                   call genCode8
  7936 0000294A 83C402                   add  sp, 2
  7937                                  
  7938                                  ;-1285             genCode16(SymbolInt);
  7939                                  
  7940 0000294D FF36[0E00]               push word [SymbolInt]
  7941 00002951 E8C5EA                   call genCode16
  7942 00002954 83C402                   add  sp, 2
  7943                                  
  7944                                  ;-1286             return;
  7945                                  
  7946 00002957 E92A04                   jmp .retnprocess
  7947                                  
  7948                                  ;-1287         }
  7949                                  
  7950                                  
  7951                                  ;-1288         genCode8(Code1);
  7952                                  
  7953                                  .process322:
  7954 0000295A A0[3000]                 mov al, byte [Code1]
  7955 0000295D B400                     mov ah, 0
  7956 0000295F 50                       push ax
  7957 00002960 E81FEA                   call genCode8
  7958 00002963 83C402                   add  sp, 2
  7959                                  
  7960                                  ;-1289         return;
  7961                                  
  7962 00002966 E91B04                   jmp .retnprocess
  7963                                  
  7964                                  ;-1290     }
  7965                                  
  7966                                  
  7967                                  ;-1291 
  7968                                  
  7969                                  
  7970                                  ;-1292     if (CodeType == 9) {//push, pop
  7971                                  
  7972                                  .process321:
  7973 00002969 A0[2F00]                 mov al, [CodeType]
  7974 0000296C 3C09                     cmp al, 9
  7975 0000296E 0F856201                 jne .process323
  7976                                  
  7977                                  ;-1293         getOpL();
  7978                                  
  7979 00002972 E8FDF1                   call getOpL
  7980                                  
  7981                                  ;-1294         if (Code1 == 0x50) {//push only
  7982                                  
  7983 00002975 A0[3000]                 mov al, [Code1]
  7984 00002978 3C50                     cmp al, 80
  7985 0000297A 0F858400                 jne .process324
  7986                                  
  7987                                  ;-1295             if (Op == IMM) {//push imm8,16
  7988                                  
  7989 0000297E A0[2D00]                 mov al, [Op]
  7990 00002981 3C01                     cmp al, 1
  7991 00002983 0F853400                 jne .process325
  7992                                  
  7993                                  ;-1296                 setsflag();
  7994                                  
  7995 00002987 E88DEC                   call setsflag
  7996                                  
  7997                                  ;-1297                 genCode2(0x68, sflag);
  7998                                  
  7999 0000298A A0[3A00]                 mov al, byte [sflag]
  8000 0000298D B400                     mov ah, 0
  8001 0000298F 50                       push ax
  8002 00002990 6A68                     push 104
  8003 00002992 E84DEA                   call genCode2
  8004 00002995 83C404                   add  sp, 4
  8005                                  
  8006                                  ;-1298                 if (sflag) genCode8 (imme);
  8007                                  
  8008 00002998 A0[3A00]                 mov al, [sflag]
  8009 0000299B 08C0                     or  al, al
  8010 0000299D 0F840D00                 je .process326
  8011 000029A1 FF36[3F00]               push word [imme]
  8012 000029A5 E8DAE9                   call genCode8
  8013 000029A8 83C402                   add  sp, 2
  8014                                  
  8015                                  ;-1299                 else       genCode16(imme);
  8016                                  
  8017 000029AB E90A00                   jmp .process327
  8018                                  .process326:
  8019 000029AE FF36[3F00]               push word [imme]
  8020 000029B2 E864EA                   call genCode16
  8021 000029B5 83C402                   add  sp, 2
  8022                                  
  8023                                  ;-1300                 return;
  8024                                  
  8025                                  .process327:
  8026 000029B8 E9C903                   jmp .retnprocess
  8027                                  
  8028                                  ;-1301             }
  8029                                  
  8030                                  
  8031                                  ;-1302             if (Op == ADR) {//push string ABSOLUTE i16 
  8032                                  
  8033                                  .process325:
  8034 000029BB A0[2D00]                 mov al, [Op]
  8035 000029BE 3C03                     cmp al, 3
  8036 000029C0 0F853E00                 jne .process328
  8037                                  
  8038                                  ;-1303                 if (disp) {
  8039                                  
  8040 000029C4 A1[3D00]                 mov ax, [disp]
  8041 000029C7 08C0                     or  al, al
  8042 000029C9 0F841800                 je .process329
  8043                                  
  8044                                  ;-1304                     genCode8(0x68);
  8045                                  
  8046 000029CD 6A68                     push 104
  8047 000029CF E8B0E9                   call genCode8
  8048 000029D2 83C402                   add  sp, 2
  8049                                  
  8050                                  ;-1305                     genCode16(disp);
  8051                                  
  8052 000029D5 FF36[3D00]               push word [disp]
  8053 000029D9 E83DEA                   call genCode16
  8054 000029DC 83C402                   add  sp, 2
  8055                                  
  8056                                  ;-1306                     return;
  8057                                  
  8058 000029DF E9A203                   jmp .retnprocess
  8059                                  
  8060                                  ;-1307                 }
  8061                                  
  8062                                  
  8063                                  ;-1308                 else {
  8064                                  
  8065 000029E2 E91D00                   jmp .process330
  8066                                  .process329:
  8067                                  
  8068                                  ;-1309                     genCode8(0x68);
  8069                                  
  8070 000029E5 6A68                     push 104
  8071 000029E7 E898E9                   call genCode8
  8072 000029EA 83C402                   add  sp, 2
  8073                                  
  8074                                  ;-1310                     storeJmp();
  8075                                  
  8076 000029ED E8F0F1                   call storeJmp
  8077                                  
  8078                                  ;-1311                     genCode16(0xAAAA);//magic for abs ADR
  8079                                  
  8080 000029F0 68AAAA                   push 43690
  8081 000029F3 E823EA                   call genCode16
  8082 000029F6 83C402                   add  sp, 2
  8083                                  
  8084                                  ;-1312                     PrintRA='A';
  8085                                  
  8086 000029F9 B84100                   mov ax, 65
  8087 000029FC A2[4500]                 mov byte [PrintRA], al
  8088                                  
  8089                                  ;-1313                     return;
  8090                                  
  8091 000029FF E98203                   jmp .retnprocess
  8092                                  
  8093                                  ;-1314                 }
  8094                                  
  8095                                  
  8096                                  ;-1315             }
  8097                                  
  8098                                  .process330:
  8099                                  
  8100                                  ;-1316         }
  8101                                  
  8102                                  .process328:
  8103                                  
  8104                                  ;-1317         if (R1Type == SEGREG) {
  8105                                  
  8106                                  .process324:
  8107 00002A02 A0[3600]                 mov al, [R1Type]
  8108 00002A05 3C04                     cmp al, 4
  8109 00002A07 0F855C00                 jne .process331
  8110                                  
  8111                                  ;-1318             if (Code1 == 0x58) {//pop only
  8112                                  
  8113 00002A0B A0[3000]                 mov al, [Code1]
  8114 00002A0E 3C58                     cmp al, 88
  8115 00002A10 0F851200                 jne .process332
  8116                                  
  8117                                  ;-1319                 if (R1No == 1) error1("pop cs not allowed");
  8118                                  
  8119 00002A14 A0[3400]                 mov al, [R1No]
  8120 00002A17 3C01                     cmp al, 1
  8121 00002A19 0F850900                 jne .process333
  8122 00002A1D 68[862D]                 push process_0
  8123 00002A20 E827E0                   call error1
  8124 00002A23 83C402                   add  sp, 2
  8125                                  
  8126                                  ;-1320             }
  8127                                  
  8128                                  .process333:
  8129                                  
  8130                                  ;-1321             c = R1No <<3;
  8131                                  
  8132                                  .process332:
  8133 00002A26 A0[3400]                 mov al, [R1No]
  8134 00002A29 C0E003                   shl al, 3
  8135 00002A2C 8846FE                   mov [bp-2], al
  8136                                  
  8137                                  ;-1322             if (R1No > 3) {//FS, GS
  8138                                  
  8139 00002A2F A0[3400]                 mov al, [R1No]
  8140 00002A32 3C03                     cmp al, 3
  8141 00002A34 0F8E0C00                 jle .process334
  8142                                  
  8143                                  ;-1323                 c += 122;  //0x7A
  8144                                  
  8145 00002A38 8046FE7A                 add  byte[bp-2], 122
  8146                                  
  8147                                  ;-1324                 genCode8(0x0F);
  8148                                  
  8149 00002A3C 6A0F                     push 15
  8150 00002A3E E841E9                   call genCode8
  8151 00002A41 83C402                   add  sp, 2
  8152                                  
  8153                                  ;-1325             }
  8154                                  
  8155                                  
  8156                                  ;-1326             if (Code1 == 0x50) c +=6;//push
  8157                                  
  8158                                  .process334:
  8159 00002A44 A0[3000]                 mov al, [Code1]
  8160 00002A47 3C50                     cmp al, 80
  8161 00002A49 0F850700                 jne .process335
  8162 00002A4D 8046FE06                 add  byte[bp-2], 6
  8163                                  
  8164                                  ;-1327                 else c += 7;//pop
  8165                                  
  8166 00002A51 E90400                   jmp .process336
  8167                                  .process335:
  8168 00002A54 8046FE07                 add  byte[bp-2], 7
  8169                                  
  8170                                  ;-1328             genCode8(c);
  8171                                  
  8172                                  .process336:
  8173 00002A58 8A46FE                   mov al, byte [bp-2]
  8174 00002A5B B400                     mov ah, 0
  8175 00002A5D 50                       push ax
  8176 00002A5E E821E9                   call genCode8
  8177 00002A61 83C402                   add  sp, 2
  8178                                  
  8179                                  ;-1329             return;
  8180                                  
  8181 00002A64 E91D03                   jmp .retnprocess
  8182                                  
  8183                                  ;-1330         } 
  8184                                  
  8185                                  
  8186                                  ;-1331         
  8187                                  
  8188                                  
  8189                                  ;-1332         checkOpL();//sorts out:ADR,SEGREG  resting: REG, MEM    
  8190                                  
  8191                                  .process331:
  8192 00002A67 E893ED                   call checkOpL
  8193                                  
  8194                                  ;-1333 //prs("\nOp: "); printIntU(Op); prs(", R1Type: "); printIntU(R1Type);
  8195                                  
  8196                                  
  8197                                  ;-1334 
  8198                                  
  8199                                  
  8200                                  ;-1335         if (Op == MEM) {
  8201                                  
  8202 00002A6A A0[2D00]                 mov al, [Op]
  8203 00002A6D 3C04                     cmp al, 4
  8204 00002A6F 0F853100                 jne .process337
  8205                                  
  8206                                  ;-1336             if (Code1 == 0x50) {//push word [bp+6]
  8207                                  
  8208 00002A73 A0[3000]                 mov al, [Code1]
  8209 00002A76 3C50                     cmp al, 80
  8210 00002A78 0F851400                 jne .process338
  8211                                  
  8212                                  ;-1337                 genCode8(0xFF);
  8213                                  
  8214 00002A7C 68FF00                   push 255
  8215 00002A7F E800E9                   call genCode8
  8216 00002A82 83C402                   add  sp, 2
  8217                                  
  8218                                  ;-1338                 writeEA(6);
  8219                                  
  8220 00002A85 6A06                     push 6
  8221 00002A87 E8DAE9                   call writeEA
  8222 00002A8A 83C402                   add  sp, 2
  8223                                  
  8224                                  ;-1339             }else {
  8225                                  
  8226 00002A8D E91100                   jmp .process339
  8227                                  .process338:
  8228                                  
  8229                                  ;-1340                 genCode8(0x8F);
  8230                                  
  8231 00002A90 688F00                   push 143
  8232 00002A93 E8ECE8                   call genCode8
  8233 00002A96 83C402                   add  sp, 2
  8234                                  
  8235                                  ;-1341                 writeEA(0);
  8236                                  
  8237 00002A99 6A00                     push 0
  8238 00002A9B E8C6E9                   call writeEA
  8239 00002A9E 83C402                   add  sp, 2
  8240                                  
  8241                                  ;-1342             }
  8242                                  
  8243                                  
  8244                                  ;-1343             return;
  8245                                  
  8246                                  .process339:
  8247 00002AA1 E9E002                   jmp .retnprocess
  8248                                  
  8249                                  ;-1344         }
  8250                                  
  8251                                  
  8252                                  ;-1345         
  8253                                  
  8254                                  
  8255                                  ;-1346         if (R1Type == BYTE) reg16error();
  8256                                  
  8257                                  .process337:
  8258 00002AA4 A0[3600]                 mov al, [R1Type]
  8259 00002AA7 3C01                     cmp al, 1
  8260 00002AA9 0F850300                 jne .process340
  8261 00002AAD E84CE1                   call reg16error
  8262                                  
  8263                                  ;-1347         if (R1Type == WORD) {//is REG, w/o SEGREG
  8264                                  
  8265                                  .process340:
  8266 00002AB0 A0[3600]                 mov al, [R1Type]
  8267 00002AB3 3C02                     cmp al, 2
  8268 00002AB5 0F851500                 jne .process341
  8269                                  
  8270                                  ;-1348             genCode2(Code1, R1No);
  8271                                  
  8272 00002AB9 A0[3400]                 mov al, byte [R1No]
  8273 00002ABC B400                     mov ah, 0
  8274 00002ABE 50                       push ax
  8275 00002ABF A0[3000]                 mov al, byte [Code1]
  8276 00002AC2 B400                     mov ah, 0
  8277 00002AC4 50                       push ax
  8278 00002AC5 E81AE9                   call genCode2
  8279 00002AC8 83C404                   add  sp, 4
  8280                                  
  8281                                  ;-1349             return;
  8282                                  
  8283 00002ACB E9B602                   jmp .retnprocess
  8284                                  
  8285                                  ;-1350         }  
  8286                                  
  8287                                  
  8288                                  ;-1351         
  8289                                  
  8290                                  
  8291                                  ;-1352         syntaxerror();
  8292                                  
  8293                                  .process341:
  8294 00002ACE E87AE1                   call syntaxerror
  8295                                  
  8296                                  ;-1353         return;
  8297                                  
  8298 00002AD1 E9B002                   jmp .retnprocess
  8299                                  
  8300                                  ;-1354     }
  8301                                  
  8302                                  
  8303                                  ;-1355 
  8304                                  
  8305                                  
  8306                                  ;-1356     if (CodeType == 11) {//shift, rotate
  8307                                  
  8308                                  .process323:
  8309 00002AD4 A0[2F00]                 mov al, [CodeType]
  8310 00002AD7 3C0B                     cmp al, 11
  8311 00002AD9 0F859200                 jne .process342
  8312                                  
  8313                                  ;-1357         check2Ops();
  8314                                  
  8315 00002ADD E8C9F0                   call check2Ops
  8316                                  
  8317                                  ;-1358         if (Op2 == IMM) {
  8318                                  
  8319 00002AE0 A0[2E00]                 mov al, [Op2]
  8320 00002AE3 3C01                     cmp al, 1
  8321 00002AE5 0F854400                 jne .process343
  8322                                  
  8323                                  ;-1359             if (imme == 1) {
  8324                                  
  8325 00002AE9 A1[3F00]                 mov ax, [imme]
  8326 00002AEC 83F801                   cmp ax, 1
  8327 00002AEF 0F851800                 jne .process344
  8328                                  
  8329                                  ;-1360                 genCodeW(0xD0);
  8330                                  
  8331 00002AF3 68D000                   push 208
  8332 00002AF6 E804E9                   call genCodeW
  8333 00002AF9 83C402                   add  sp, 2
  8334                                  
  8335                                  ;-1361                 writeEA(Code1);
  8336                                  
  8337 00002AFC A0[3000]                 mov al, byte [Code1]
  8338 00002AFF B400                     mov ah, 0
  8339 00002B01 50                       push ax
  8340 00002B02 E85FE9                   call writeEA
  8341 00002B05 83C402                   add  sp, 2
  8342                                  
  8343                                  ;-1362                 return;
  8344                                  
  8345 00002B08 E97902                   jmp .retnprocess
  8346                                  
  8347                                  ;-1363             }
  8348                                  
  8349                                  
  8350                                  ;-1364             genCodeW(0xC0);//80186
  8351                                  
  8352                                  .process344:
  8353 00002B0B 68C000                   push 192
  8354 00002B0E E8ECE8                   call genCodeW
  8355 00002B11 83C402                   add  sp, 2
  8356                                  
  8357                                  ;-1365             writeEA(Code1);
  8358                                  
  8359 00002B14 A0[3000]                 mov al, byte [Code1]
  8360 00002B17 B400                     mov ah, 0
  8361 00002B19 50                       push ax
  8362 00002B1A E847E9                   call writeEA
  8363 00002B1D 83C402                   add  sp, 2
  8364                                  
  8365                                  ;-1366             genCode8(imme);
  8366                                  
  8367 00002B20 FF36[3F00]               push word [imme]
  8368 00002B24 E85BE8                   call genCode8
  8369 00002B27 83C402                   add  sp, 2
  8370                                  
  8371                                  ;-1367             return;
  8372                                  
  8373 00002B2A E95702                   jmp .retnprocess
  8374                                  
  8375                                  ;-1368         }
  8376                                  
  8377                                  
  8378                                  ;-1369         if (Op2 == REG) {
  8379                                  
  8380                                  .process343:
  8381 00002B2D A0[2E00]                 mov al, [Op2]
  8382 00002B30 3C02                     cmp al, 2
  8383 00002B32 0F853900                 jne .process345
  8384                                  
  8385                                  ;-1370             if (R2Type == BYTE) {
  8386                                  
  8387 00002B36 A0[3500]                 mov al, [R2Type]
  8388 00002B39 3C01                     cmp al, 1
  8389 00002B3B 0F853000                 jne .process346
  8390                                  
  8391                                  ;-1371                 if (R2No == 1) {//CL-REG
  8392                                  
  8393 00002B3F A0[3300]                 mov al, [R2No]
  8394 00002B42 3C01                     cmp al, 1
  8395 00002B44 0F852700                 jne .process347
  8396                                  
  8397                                  ;-1372                     if (R1Type == WORD) wflag=1;//hack
  8398                                  
  8399 00002B48 A0[3600]                 mov al, [R1Type]
  8400 00002B4B 3C02                     cmp al, 2
  8401 00002B4D 0F850600                 jne .process348
  8402 00002B51 B80100                   mov ax, 1
  8403 00002B54 A2[3800]                 mov byte [wflag], al
  8404                                  
  8405                                  ;-1373                     genCodeW(0xD2);
  8406                                  
  8407                                  .process348:
  8408 00002B57 68D200                   push 210
  8409 00002B5A E8A0E8                   call genCodeW
  8410 00002B5D 83C402                   add  sp, 2
  8411                                  
  8412                                  ;-1374                     writeEA(Code1);
  8413                                  
  8414 00002B60 A0[3000]                 mov al, byte [Code1]
  8415 00002B63 B400                     mov ah, 0
  8416 00002B65 50                       push ax
  8417 00002B66 E8FBE8                   call writeEA
  8418 00002B69 83C402                   add  sp, 2
  8419                                  
  8420                                  ;-1375                     return;
  8421                                  
  8422 00002B6C E91502                   jmp .retnprocess
  8423                                  
  8424                                  ;-1376                 }
  8425                                  
  8426                                  
  8427                                  ;-1377             }
  8428                                  
  8429                                  .process347:
  8430                                  
  8431                                  ;-1378         }
  8432                                  
  8433                                  .process346:
  8434                                  
  8435                                  ;-1379     }
  8436                                  
  8437                                  .process345:
  8438                                  
  8439                                  ;-1380 
  8440                                  
  8441                                  
  8442                                  ;-1381     if (CodeType == 12) {//int
  8443                                  
  8444                                  .process342:
  8445 00002B6F A0[2F00]                 mov al, [CodeType]
  8446 00002B72 3C0C                     cmp al, 12
  8447 00002B74 0F852200                 jne .process349
  8448                                  
  8449                                  ;-1382         if (TokeType == DIGIT) {
  8450                                  
  8451 00002B78 A0[2C00]                 mov al, [TokeType]
  8452 00002B7B 3C01                     cmp al, 1
  8453 00002B7D 0F851900                 jne .process350
  8454                                  
  8455                                  ;-1383             genCode8(Code1);
  8456                                  
  8457 00002B81 A0[3000]                 mov al, byte [Code1]
  8458 00002B84 B400                     mov ah, 0
  8459 00002B86 50                       push ax
  8460 00002B87 E8F8E7                   call genCode8
  8461 00002B8A 83C402                   add  sp, 2
  8462                                  
  8463                                  ;-1384             genCode8(SymbolInt);
  8464                                  
  8465 00002B8D FF36[0E00]               push word [SymbolInt]
  8466 00002B91 E8EEE7                   call genCode8
  8467 00002B94 83C402                   add  sp, 2
  8468                                  
  8469                                  ;-1385             return;
  8470                                  
  8471 00002B97 E9EA01                   jmp .retnprocess
  8472                                  
  8473                                  ;-1386         }
  8474                                  
  8475                                  
  8476                                  ;-1387     }
  8477                                  
  8478                                  .process350:
  8479                                  
  8480                                  ;-1388 
  8481                                  
  8482                                  
  8483                                  ;-1389     if (CodeType == 14) {//in, out
  8484                                  
  8485                                  .process349:
  8486 00002B9A A0[2F00]                 mov al, [CodeType]
  8487 00002B9D 3C0E                     cmp al, 14
  8488 00002B9F 0F850600                 jne .process351
  8489                                  
  8490                                  ;-1390         implerror();
  8491                                  
  8492 00002BA3 E8B6DF                   call implerror
  8493                                  
  8494                                  ;-1391         return;   
  8495                                  
  8496 00002BA6 E9DB01                   jmp .retnprocess
  8497                                  
  8498                                  ;-1392     }
  8499                                  
  8500                                  
  8501                                  ;-1393     if (CodeType == 15) {//xchg
  8502                                  
  8503                                  .process351:
  8504 00002BA9 A0[2F00]                 mov al, [CodeType]
  8505 00002BAC 3C0F                     cmp al, 15
  8506 00002BAE 0F850600                 jne .process352
  8507                                  
  8508                                  ;-1394         implerror();
  8509                                  
  8510 00002BB2 E8A7DF                   call implerror
  8511                                  
  8512                                  ;-1395         return;   
  8513                                  
  8514 00002BB5 E9CC01                   jmp .retnprocess
  8515                                  
  8516                                  ;-1396     }
  8517                                  
  8518                                  
  8519                                  ;-1397     if (CodeType == 16) {//loop
  8520                                  
  8521                                  .process352:
  8522 00002BB8 A0[2F00]                 mov al, [CodeType]
  8523 00002BBB 3C10                     cmp al, 16
  8524 00002BBD 0F850600                 jne .process353
  8525                                  
  8526                                  ;-1398         implerror();
  8527                                  
  8528 00002BC1 E898DF                   call implerror
  8529                                  
  8530                                  ;-1399         return;   
  8531                                  
  8532 00002BC4 E9BD01                   jmp .retnprocess
  8533                                  
  8534                                  ;-1400     }
  8535                                  
  8536                                  
  8537                                  ;-1401 
  8538                                  
  8539                                  
  8540                                  ;-1402     if (CodeType == 30) {//enter i18,i8
  8541                                  
  8542                                  .process353:
  8543 00002BC7 A0[2F00]                 mov al, [CodeType]
  8544 00002BCA 3C1E                     cmp al, 30
  8545 00002BCC 0F855200                 jne .process354
  8546                                  
  8547                                  ;-1403         genCode8(0xC8);
  8548                                  
  8549 00002BD0 68C800                   push 200
  8550 00002BD3 E8ACE7                   call genCode8
  8551 00002BD6 83C402                   add  sp, 2
  8552                                  
  8553                                  ;-1404         Op=getOp1();
  8554                                  
  8555 00002BD9 E8F7EC                   call getOp1
  8556 00002BDC A2[2D00]                 mov byte [Op], al
  8557                                  
  8558                                  ;-1405         if (Op == IMM) genCode16(SymbolInt);
  8559                                  
  8560 00002BDF A0[2D00]                 mov al, [Op]
  8561 00002BE2 3C01                     cmp al, 1
  8562 00002BE4 0F850D00                 jne .process355
  8563 00002BE8 FF36[0E00]               push word [SymbolInt]
  8564 00002BEC E82AE8                   call genCode16
  8565 00002BEF 83C402                   add  sp, 2
  8566                                  
  8567                                  ;-1406         else numbererror();
  8568                                  
  8569 00002BF2 E90300                   jmp .process356
  8570                                  .process355:
  8571 00002BF5 E8C0DF                   call numbererror
  8572                                  
  8573                                  ;-1407         need(',');
  8574                                  
  8575                                  .process356:
  8576 00002BF8 6A2C                     push 44
  8577 00002BFA E898EB                   call need
  8578 00002BFD 83C402                   add  sp, 2
  8579                                  
  8580                                  ;-1408         Op=getOp1();
  8581                                  
  8582 00002C00 E8D0EC                   call getOp1
  8583 00002C03 A2[2D00]                 mov byte [Op], al
  8584                                  
  8585                                  ;-1409         if (Op == IMM) genCode8 (SymbolInt);
  8586                                  
  8587 00002C06 A0[2D00]                 mov al, [Op]
  8588 00002C09 3C01                     cmp al, 1
  8589 00002C0B 0F850D00                 jne .process357
  8590 00002C0F FF36[0E00]               push word [SymbolInt]
  8591 00002C13 E86CE7                   call genCode8
  8592 00002C16 83C402                   add  sp, 2
  8593                                  
  8594                                  ;-1410         else numbererror();
  8595                                  
  8596 00002C19 E90300                   jmp .process358
  8597                                  .process357:
  8598 00002C1C E899DF                   call numbererror
  8599                                  
  8600                                  ;-1411         return;
  8601                                  
  8602                                  .process358:
  8603 00002C1F E96201                   jmp .retnprocess
  8604                                  
  8605                                  ;-1412     }
  8606                                  
  8607                                  
  8608                                  ;-1413 
  8609                                  
  8610                                  
  8611                                  ;-1414     if (CodeType == 41) {//test
  8612                                  
  8613                                  .process354:
  8614 00002C22 A0[2F00]                 mov al, [CodeType]
  8615 00002C25 3C29                     cmp al, 41
  8616 00002C27 0F850600                 jne .process359
  8617                                  
  8618                                  ;-1415         implerror();
  8619                                  
  8620 00002C2B E82EDF                   call implerror
  8621                                  
  8622                                  ;-1416         return;   
  8623                                  
  8624 00002C2E E95301                   jmp .retnprocess
  8625                                  
  8626                                  ;-1417     }
  8627                                  
  8628                                  
  8629                                  ;-1418 
  8630                                  
  8631                                  
  8632                                  ;-1419     if (CodeType == 51) {//movsx, movzx=51
  8633                                  
  8634                                  .process359:
  8635 00002C31 A0[2F00]                 mov al, [CodeType]
  8636 00002C34 3C33                     cmp al, 51
  8637 00002C36 0F850600                 jne .process360
  8638                                  
  8639                                  ;-1420         implerror();
  8640                                  
  8641 00002C3A E81FDF                   call implerror
  8642                                  
  8643                                  ;-1421         return;   
  8644                                  
  8645 00002C3D E94401                   jmp .retnprocess
  8646                                  
  8647                                  ;-1422     }
  8648                                  
  8649                                  
  8650                                  ;-1423 
  8651                                  
  8652                                  
  8653                                  ;-1424     if (CodeType==101) {//ORG nn
  8654                                  
  8655                                  .process360:
  8656 00002C40 A0[2F00]                 mov al, [CodeType]
  8657 00002C43 3C65                     cmp al, 101
  8658 00002C45 0F851500                 jne .process361
  8659                                  
  8660                                  ;-1425         if (TokeType != DIGIT) numbererror();
  8661                                  
  8662 00002C49 A0[2C00]                 mov al, [TokeType]
  8663 00002C4C 3C01                     cmp al, 1
  8664 00002C4E 0F840300                 je  .process362
  8665 00002C52 E863DF                   call numbererror
  8666                                  
  8667                                  ;-1426         Origin=SymbolInt;
  8668                                  
  8669                                  .process362:
  8670 00002C55 A1[0E00]                 mov ax, [SymbolInt]
  8671 00002C58 A3[2500]                 mov word [Origin], ax
  8672                                  
  8673                                  ;-1427         return;
  8674                                  
  8675 00002C5B E92601                   jmp .retnprocess
  8676                                  
  8677                                  ;-1428     }
  8678                                  
  8679                                  
  8680                                  ;-1429 
  8681                                  
  8682                                  
  8683                                  ;-1430     if (CodeType == 102) {//section, segment
  8684                                  
  8685                                  .process361:
  8686 00002C5E A0[2F00]                 mov al, [CodeType]
  8687 00002C61 3C66                     cmp al, 102
  8688 00002C63 0F850900                 jne .process363
  8689                                  
  8690                                  ;-1431         //getTokeType();//ignore .bss .text .data
  8691                                  
  8692                                  
  8693                                  ;-1432         AbsoluteLab=0;//nasm resets erevy time
  8694                                  
  8695 00002C67 B80000                   mov ax, 0
  8696 00002C6A A3[2700]                 mov word [AbsoluteLab], ax
  8697                                  
  8698                                  ;-1433         return;
  8699                                  
  8700 00002C6D E91401                   jmp .retnprocess
  8701                                  
  8702                                  ;-1434     }
  8703                                  
  8704                                  
  8705                                  ;-1435 
  8706                                  
  8707                                  
  8708                                  ;-1436     if (CodeType == 110) {//absolute
  8709                                  
  8710                                  .process363:
  8711 00002C70 A0[2F00]                 mov al, [CodeType]
  8712 00002C73 3C6E                     cmp al, 110
  8713 00002C75 0F851500                 jne .process364
  8714                                  
  8715                                  ;-1437         if (TokeType != DIGIT) numbererror();
  8716                                  
  8717 00002C79 A0[2C00]                 mov al, [TokeType]
  8718 00002C7C 3C01                     cmp al, 1
  8719 00002C7E 0F840300                 je  .process365
  8720 00002C82 E833DF                   call numbererror
  8721                                  
  8722                                  ;-1438         AbsoluteLab=SymbolInt;
  8723                                  
  8724                                  .process365:
  8725 00002C85 A1[0E00]                 mov ax, [SymbolInt]
  8726 00002C88 A3[2700]                 mov word [AbsoluteLab], ax
  8727                                  
  8728                                  ;-1439         return;
  8729                                  
  8730 00002C8B E9F600                   jmp .retnprocess
  8731                                  
  8732                                  ;-1440     }
  8733                                  
  8734                                  
  8735                                  ;-1441     if (CodeType == 111) {//name: PROC
  8736                                  
  8737                                  .process364:
  8738 00002C8E A0[2F00]                 mov al, [CodeType]
  8739 00002C91 3C6F                     cmp al, 111
  8740 00002C93 0F854A00                 jne .process366
  8741                                  
  8742                                  ;-1442         if (isInProc == 0)  {
  8743                                  
  8744 00002C97 A0[0D00]                 mov al, [isInProc]
  8745 00002C9A 3C00                     cmp al, 0
  8746 00002C9C 0F853500                 jne .process367
  8747                                  
  8748                                  ;-1443             prs("\nentering: ");
  8749                                  
  8750 00002CA0 68[992D]                 push process_1
  8751 00002CA3 E88DDA                   call prs
  8752 00002CA6 83C402                   add  sp, 2
  8753                                  
  8754                                  ;-1444             prs(ProcName);
  8755                                  
  8756 00002CA9 8D066E75                 lea  ax, [ProcName]
  8757 00002CAD 50                       push ax
  8758 00002CAE E882DA                   call prs
  8759 00002CB1 83C402                   add  sp, 2
  8760                                  
  8761                                  ;-1445             isInProc=1;
  8762                                  
  8763 00002CB4 B80100                   mov ax, 1
  8764 00002CB7 A2[0D00]                 mov byte [isInProc], al
  8765                                  
  8766                                  ;-1446             tmpLabelNamePtr = LabelNamePtr;
  8767                                  
  8768 00002CBA A1[4600]                 mov ax, [LabelNamePtr]
  8769 00002CBD A3[4800]                 mov word [tmpLabelNamePtr], ax
  8770                                  
  8771                                  ;-1447             tmpLabelMaxIx   = LabelMaxIx;
  8772                                  
  8773 00002CC0 A1[4A00]                 mov ax, [LabelMaxIx]
  8774 00002CC3 A3[4C00]                 mov word [tmpLabelMaxIx], ax
  8775                                  
  8776                                  ;-1448             tmpJmpNamePtr   = JmpNamePtr;
  8777                                  
  8778 00002CC6 A1[5000]                 mov ax, [JmpNamePtr]
  8779 00002CC9 A3[5200]                 mov word [tmpJmpNamePtr], ax
  8780                                  
  8781                                  ;-1449             tmpJmpMaxIx     = JmpMaxIx;
  8782                                  
  8783 00002CCC A1[5400]                 mov ax, [JmpMaxIx]
  8784 00002CCF A3[5600]                 mov word [tmpJmpMaxIx], ax
  8785                                  
  8786                                  ;-1450         } else error1("already in PROC");
  8787                                  
  8788 00002CD2 E90900                   jmp .process368
  8789                                  .process367:
  8790 00002CD5 68[A62D]                 push process_2
  8791 00002CD8 E86FDD                   call error1
  8792 00002CDB 83C402                   add  sp, 2
  8793                                  
  8794                                  ;-1451         return;
  8795                                  
  8796                                  .process368:
  8797 00002CDE E9A300                   jmp .retnprocess
  8798                                  
  8799                                  ;-1452     }
  8800                                  
  8801                                  
  8802                                  ;-1453     if (CodeType == 112) {//ENDP 
  8803                                  
  8804                                  .process366:
  8805 00002CE1 A0[2F00]                 mov al, [CodeType]
  8806 00002CE4 3C70                     cmp al, 112
  8807 00002CE6 0F858200                 jne .process369
  8808                                  
  8809                                  ;-1454         if (isInProc == 0) error1("not in PROC");
  8810                                  
  8811 00002CEA A0[0D00]                 mov al, [isInProc]
  8812 00002CED 3C00                     cmp al, 0
  8813 00002CEF 0F850900                 jne .process370
  8814 00002CF3 68[B62D]                 push process_3
  8815 00002CF6 E851DD                   call error1
  8816 00002CF9 83C402                   add  sp, 2
  8817                                  
  8818                                  ;-1455         prs("\nleaving: ");
  8819                                  
  8820                                  .process370:
  8821 00002CFC 68[C22D]                 push process_4
  8822 00002CFF E831DA                   call prs
  8823 00002D02 83C402                   add  sp, 2
  8824                                  
  8825                                  ;-1456         prs(ProcName);
  8826                                  
  8827 00002D05 8D066E75                 lea  ax, [ProcName]
  8828 00002D09 50                       push ax
  8829 00002D0A E826DA                   call prs
  8830 00002D0D 83C402                   add  sp, 2
  8831                                  
  8832                                  ;-1457         prs(", loc labels: ");
  8833                                  
  8834 00002D10 68[CE2D]                 push process_5
  8835 00002D13 E81DDA                   call prs
  8836 00002D16 83C402                   add  sp, 2
  8837                                  
  8838                                  ;-1458         i = LabelMaxIx - tmpLabelMaxIx;
  8839                                  
  8840 00002D19 A1[4A00]                 mov ax, [LabelMaxIx]
  8841 00002D1C 2B06[4C00]               sub ax, [tmpLabelMaxIx]
  8842 00002D20 8946FC                   mov [bp-4], ax
  8843                                  
  8844                                  ;-1459         printIntU(i);
  8845                                  
  8846 00002D23 FF76FC                   push word [bp-4]
  8847 00002D26 E81ADB                   call printIntU
  8848 00002D29 83C402                   add  sp, 2
  8849                                  
  8850                                  ;-1460         prs(", loc jmp forward: ");
  8851                                  
  8852 00002D2C 68[DD2D]                 push process_6
  8853 00002D2F E801DA                   call prs
  8854 00002D32 83C402                   add  sp, 2
  8855                                  
  8856                                  ;-1461         i = JmpMaxIx - tmpJmpMaxIx;
  8857                                  
  8858 00002D35 A1[5400]                 mov ax, [JmpMaxIx]
  8859 00002D38 2B06[5600]               sub ax, [tmpJmpMaxIx]
  8860 00002D3C 8946FC                   mov [bp-4], ax
  8861                                  
  8862                                  ;-1462         printIntU(i);        
  8863                                  
  8864 00002D3F FF76FC                   push word [bp-4]
  8865 00002D42 E8FEDA                   call printIntU
  8866 00002D45 83C402                   add  sp, 2
  8867                                  
  8868                                  ;-1463         fixJmp();
  8869                                  
  8870 00002D48 E81DF5                   call fixJmp
  8871                                  
  8872                                  ;-1464         isInProc=0;
  8873                                  
  8874 00002D4B B80000                   mov ax, 0
  8875 00002D4E A2[0D00]                 mov byte [isInProc], al
  8876                                  
  8877                                  ;-1465         LabelNamePtr = tmpLabelNamePtr;//delete local Labels
  8878                                  
  8879 00002D51 A1[4800]                 mov ax, [tmpLabelNamePtr]
  8880 00002D54 A3[4600]                 mov word [LabelNamePtr], ax
  8881                                  
  8882                                  ;-1466         LabelMaxIx   = tmpLabelMaxIx;                       
  8883                                  
  8884 00002D57 A1[4C00]                 mov ax, [tmpLabelMaxIx]
  8885 00002D5A A3[4A00]                 mov word [LabelMaxIx], ax
  8886                                  
  8887                                  ;-1467         JmpNamePtr   = tmpJmpNamePtr;//delete local Jmp
  8888                                  
  8889 00002D5D A1[5200]                 mov ax, [tmpJmpNamePtr]
  8890 00002D60 A3[5000]                 mov word [JmpNamePtr], ax
  8891                                  
  8892                                  ;-1468         JmpMaxIx     = tmpJmpMaxIx;
  8893                                  
  8894 00002D63 A1[5600]                 mov ax, [tmpJmpMaxIx]
  8895 00002D66 A3[5400]                 mov word [JmpMaxIx], ax
  8896                                  
  8897                                  ;-1469         return;
  8898                                  
  8899 00002D69 E91800                   jmp .retnprocess
  8900                                  
  8901                                  ;-1470     } 
  8902                                  
  8903                                  
  8904                                  ;-1471     if (CodeType == 200) {//db  
  8905                                  
  8906                                  .process369:
  8907 00002D6C A0[2F00]                 mov al, [CodeType]
  8908 00002D6F 3CC8                     cmp al, 200
  8909 00002D71 0F850600                 jne .process371
  8910                                  
  8911                                  ;-1472         genDB();
  8912                                  
  8913 00002D75 E88BEF                   call genDB
  8914                                  
  8915                                  ;-1473         return;
  8916                                  
  8917 00002D78 E90900                   jmp .retnprocess
  8918                                  
  8919                                  ;-1474     }
  8920                                  
  8921                                  
  8922                                  ;-1475     
  8923                                  
  8924                                  
  8925                                  ;-1476     error1("Command not implemented or syntax error");
  8926                                  
  8927                                  .process371:
  8928 00002D7B 68[F12D]                 push process_7
  8929 00002D7E E8C9DC                   call error1
  8930 00002D81 83C402                   add  sp, 2
  8931                                  
  8932                                  ;-1477 }
  8933                                  
  8934                                  
  8935                                  ;-1478 
  8936                                  
  8937                                  
  8938                                  ;-1479 int parse() {
  8939                                  
  8940 00002D84 C9                       .retnprocess: LEAVE
  8941 00002D85 C3                       ret
  8942 00002D86 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  8943 00002D8F 7420616C6C6F776564-
  8944 00002D98 00                 
  8945 00002D99 5C6E656E746572696E-     process_1 db "\nentering: ",0
  8946 00002DA2 673A2000           
  8947 00002DA6 616C72656164792069-     process_2 db "already in PROC",0
  8948 00002DAF 6E2050524F4300     
  8949 00002DB6 6E6F7420696E205052-     process_3 db "not in PROC",0
  8950 00002DBF 4F4300             
  8951 00002DC2 5C6E6C656176696E67-     process_4 db "\nleaving: ",0
  8952 00002DCB 3A2000             
  8953 00002DCE 2C206C6F63206C6162-     process_5 db ", loc labels: ",0
  8954 00002DD7 656C733A2000       
  8955 00002DDD 2C206C6F63206A6D70-     process_6 db ", loc jmp forward: ",0
  8956 00002DE6 20666F72776172643A-
  8957 00002DEF 2000               
  8958 00002DF1 436F6D6D616E64206E-     process_7 db "Command not implemented or syntax error",0
  8959 00002DFA 6F7420696D706C656D-
  8960 00002E03 656E746564206F7220-
  8961 00002E0C 73796E746178206572-
  8962 00002E15 726F7200           
  8963                                  ENDP
  8964                                  
  8965                                  parse: PROC
  8966                                  
  8967                                  ;-1480     LabelNamePtr  = &LabelNames;
  8968                                  
  8969 00002E19 B85A77                   mov ax, LabelNames
  8970 00002E1C A3[4600]                 mov word [LabelNamePtr], ax
  8971                                  
  8972                                  ;-1481     JmpNamePtr= &JmpNames;
  8973                                  
  8974 00002E1F B87A93                   mov ax, JmpNames
  8975 00002E22 A3[5000]                 mov word [JmpNamePtr], ax
  8976                                  
  8977                                  ;-1482     LabelMaxIx=0;
  8978                                  
  8979 00002E25 B80000                   mov ax, 0
  8980 00002E28 A3[4A00]                 mov word [LabelMaxIx], ax
  8981                                  
  8982                                  ;-1483     JmpMaxIx=0;
  8983                                  
  8984 00002E2B B80000                   mov ax, 0
  8985 00002E2E A3[5400]                 mov word [JmpMaxIx], ax
  8986                                  
  8987                                  ;-1484     BinLen=0;
  8988                                  
  8989 00002E31 B80000                   mov ax, 0
  8990 00002E34 A3[5800]                 mov word [BinLen], ax
  8991                                  
  8992                                  ;-1485     isInProc=0;
  8993                                  
  8994 00002E37 B80000                   mov ax, 0
  8995 00002E3A A2[0D00]                 mov byte [isInProc], al
  8996                                  
  8997                                  ;-1486 
  8998                                  
  8999                                  
  9000                                  ;-1487     do {//process a new line
  9001                                  
  9002                                  .parse372:
  9003                                  
  9004                                  ;-1488         PCStart=PC;
  9005                                  
  9006 00002E3D A1[2300]                 mov ax, [PC]
  9007 00002E40 A3[2900]                 mov word [PCStart], ax
  9008                                  
  9009                                  ;-1489         OpSize=0;
  9010                                  
  9011 00002E43 B80000                   mov ax, 0
  9012 00002E46 A2[3700]                 mov byte [OpSize], al
  9013                                  
  9014                                  ;-1490         OpPrintIndex=0;
  9015                                  
  9016 00002E49 B80000                   mov ax, 0
  9017 00002E4C A3[4100]                 mov word [OpPrintIndex], ax
  9018                                  
  9019                                  ;-1491         PrintRA=' ';
  9020                                  
  9021 00002E4F B82000                   mov ax, 32
  9022 00002E52 A2[4500]                 mov byte [PrintRA], al
  9023                                  
  9024                                  ;-1492         getLine();
  9025                                  
  9026 00002E55 E8D2DE                   call getLine
  9027                                  
  9028                                  ;-1493         InputPtr = &InputBuf;
  9029                                  
  9030 00002E58 B88D75                   mov ax, InputBuf
  9031 00002E5B A3[1400]                 mov word [InputPtr], ax
  9032                                  
  9033                                  ;-1494         getTokeType();//getCode in SymbolUpper,
  9034                                  
  9035 00002E5E E880E8                   call getTokeType
  9036                                  
  9037                                  ;-1495                       //set TokeType,isLabel by getName
  9038                                  
  9039                                  
  9040                                  ;-1496         if (TokeType == ALNUME) {
  9041                                  
  9042 00002E61 A0[2C00]                 mov al, [TokeType]
  9043 00002E64 3C03                     cmp al, 3
  9044 00002E66 0F852C00                 jne .parse373
  9045                                  
  9046                                  ;-1497             if (isLabel) {//set in getName
  9047                                  
  9048 00002E6A A0[2B00]                 mov al, [isLabel]
  9049 00002E6D 08C0                     or  al, al
  9050 00002E6F 0F842300                 je .parse374
  9051                                  
  9052                                  ;-1498               if (isInProc == 0)  strcpy(ProcName, Symbol);
  9053                                  
  9054 00002E73 A0[0D00]                 mov al, [isInProc]
  9055 00002E76 3C00                     cmp al, 0
  9056 00002E78 0F851000                 jne .parse375
  9057 00002E7C 8D063075                 lea  ax, [Symbol]
  9058 00002E80 50                       push ax
  9059 00002E81 8D066E75                 lea  ax, [ProcName]
  9060 00002E85 50                       push ax
  9061 00002E86 E8A1D3                   call strcpy
  9062 00002E89 83C404                   add  sp, 4
  9063                                  
  9064                                  ;-1499                 storeLabel();
  9065                                  
  9066                                  .parse375:
  9067 00002E8C E8CDED                   call storeLabel
  9068                                  
  9069                                  ;-1500                 InputPtr++;//remove :
  9070                                  
  9071 00002E8F FF06[1400]               inc  word[InputPtr]
  9072                                  
  9073                                  ;-1501                 getTokeType();
  9074                                  
  9075 00002E93 E84BE8                   call getTokeType
  9076                                  
  9077                                  ;-1502             }
  9078                                  
  9079                                  
  9080                                  ;-1503         }
  9081                                  
  9082                                  .parse374:
  9083                                  
  9084                                  ;-1504         if (TokeType == ALNUME) {
  9085                                  
  9086                                  .parse373:
  9087 00002E96 A0[2C00]                 mov al, [TokeType]
  9088 00002E99 3C03                     cmp al, 3
  9089 00002E9B 0F851B00                 jne .parse376
  9090                                  
  9091                                  ;-1505             lookCode();// and OpCodePtr
  9092                                  
  9093 00002E9F E869E4                   call lookCode
  9094                                  
  9095                                  ;-1506             if(CodeType) process();
  9096                                  
  9097 00002EA2 A0[2F00]                 mov al, [CodeType]
  9098 00002EA5 08C0                     or  al, al
  9099 00002EA7 0F840600                 je .parse377
  9100 00002EAB E8B5F4                   call process
  9101                                  
  9102                                  ;-1507             else getVariable();
  9103                                  
  9104 00002EAE E90300                   jmp .parse378
  9105                                  .parse377:
  9106 00002EB1 E8D4EE                   call getVariable
  9107                                  
  9108                                  ;-1508             skipRest();
  9109                                  
  9110                                  .parse378:
  9111 00002EB4 E81DE9                   call skipRest
  9112                                  
  9113                                  ;-1509         }
  9114                                  
  9115                                  
  9116                                  ;-1510         else if (TokeType >ALNUME) error1("Label or instruction expected");
  9117                                  
  9118 00002EB7 E92700                   jmp .parse379
  9119                                  .parse376:
  9120 00002EBA A0[2C00]                 mov al, [TokeType]
  9121 00002EBD 3C03                     cmp al, 3
  9122 00002EBF 0F8E0C00                 jle .parse380
  9123 00002EC3 68[F22E]                 push parse_0
  9124 00002EC6 E881DB                   call error1
  9125 00002EC9 83C402                   add  sp, 2
  9126                                  
  9127                                  ;-1511         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  9128                                  
  9129 00002ECC E91200                   jmp .parse381
  9130                                  .parse380:
  9131 00002ECF A0[2C00]                 mov al, [TokeType]
  9132 00002ED2 3C01                     cmp al, 1
  9133 00002ED4 0F850900                 jne .parse382
  9134 00002ED8 68[102F]                 push parse_1
  9135 00002EDB E86CDB                   call error1
  9136 00002EDE 83C402                   add  sp, 2
  9137                                  
  9138                                  ;-1512         printLine();
  9139                                  
  9140                                  .parse382:
  9141                                  .parse381:
  9142                                  .parse379:
  9143 00002EE1 E8A1D9                   call printLine
  9144                                  
  9145                                  ;-1513     } while (DOS_NoBytes != 0 );
  9146                                  
  9147 00002EE4 A1[2000]                 mov ax, [DOS_NoBytes]
  9148 00002EE7 83F800                   cmp ax, 0
  9149 00002EEA 0F840300                 je  .parse383
  9150 00002EEE E94CFF                   jmp .parse372
  9151                                  .parse383:
  9152                                  
  9153                                  ;-1514 }
  9154                                  
  9155                                  
  9156                                  ;-1515 
  9157                                  
  9158                                  
  9159                                  ;-1516 int main() {
  9160                                  
  9161 00002EF1 C3                       ret
  9162 00002EF2 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  9163 00002EFB 696E73747275637469-
  9164 00002F04 6F6E20657870656374-
  9165 00002F0D 656400             
  9166 00002F10 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  9167 00002F19 616C6C6F7765642061-
  9168 00002F22 74207374617274206F-
  9169 00002F2B 66206C696E6500     
  9170                                  ENDP
  9171                                  
  9172                                  main: PROC
  9173                                  
  9174                                  ;-1517     getarg();
  9175                                  
  9176 00002F32 E863F0                   call getarg
  9177                                  
  9178                                  ;-1518     parse();
  9179                                  
  9180 00002F35 E8E1FE                   call parse
  9181                                  
  9182                                  ;-1519     fixJmpMain();
  9183                                  
  9184 00002F38 E886F3                   call fixJmpMain
  9185                                  
  9186                                  ;-1520     epilog();
  9187                                  
  9188 00002F3B E8F0D9                   call epilog
  9189                                  
  9190                                  ;-1521     end1();
  9191                                  
  9192 00002F3E E8DCDA                   call end1
  9193                                  
  9194                                  ;-1522 }
  9195                                  
  9196 00002F41 C3                       ret
  9197                                  ENDP
  9198                                   
  9199                                  ; missing functions: 
  9200                                  ; Number of unresolved CALLs :    0 All FUNCTIONs in place
  9201                                   
  9202                                  ;   # type sign width  adr used name   list of global variables
  9203                                  
  9204                                  ;    1 arr sign byte     1    2 Version1[9]
  9205                                  ;    2 def unsg byte     3    - SYMBOLMAX=31
  9206                                  ;    3 arr sign byte     4   14 Symbol[31]
  9207                                  ;    4 arr sign byte     5   36 SymbolUpper[31]
  9208                                  ;    5 arr sign byte     6    3 ProcName[31]
  9209                                  ;    6 var sign byte     7    6 isInProc
  9210                                  ;    7 var unsg word     8   25 SymbolInt
  9211                                  ;    8 var unsg dwrd     9 NULL SymbolLong
  9212                                  ;    9 def unsg byte    10    - INPUTBUFMAX=255
  9213                                  ;   10 arr sign byte    11    4 InputBuf[255]
  9214                                  ;   11 ptr unsg byte    12   28 InputPtr
  9215                                  ;   12 arr sign byte    13    5 namein[67]
  9216                                  ;   13 arr sign byte    14    6 namelst[67]
  9217                                  ;   14 arr sign byte    15    6 namebin[67]
  9218                                  ;   15 var sign word    16    4 asm_fd
  9219                                  ;   16 var sign word    17    3 lst_fd
  9220                                  ;   17 var sign word    18    3 bin_fd
  9221                                  ;   18 var sign word    19    6 DOS_ERR
  9222                                  ;   19 var sign word    20    5 ErrorCount
  9223                                  ;   20 var sign word    21    4 DOS_NoBytes
  9224                                  ;   21 var sign byte    22    5 DOS_ByteRead
  9225                                  ;   22 var unsg word    24    8 PC
  9226                                  ;   23 var unsg word    25    5 Origin
  9227                                  ;   24 var unsg word    26    6 AbsoluteLab
  9228                                  ;   25 var unsg word    27    2 PCStart
  9229                                  ;   26 var sign byte    28    3 isLabel
  9230                                  ;   27 def unsg byte    29    - DIGIT=1
  9231                                  ;   28 def unsg byte    30    - LETTERE=2
  9232                                  ;   29 def unsg byte    31    - ALNUME=3
  9233                                  ;   30 def unsg byte    32    - NOALNUME=4
  9234                                  ;   31 var sign byte    33   28 TokeType
  9235                                  ;   32 def unsg byte    34    - BYTE=1
  9236                                  ;   33 def unsg byte    35    - WORD=2
  9237                                  ;   34 def unsg byte    36    - DWORD=3
  9238                                  ;   35 def unsg byte    37    - SEGREG=4
  9239                                  ;   36 def unsg byte    38    - IMM=1
  9240                                  ;   37 def unsg byte    39    - REG=2
  9241                                  ;   38 def unsg byte    40    - ADR=3
  9242                                  ;   39 def unsg byte    41    - MEM=4
  9243                                  ;   40 var sign byte    42   29 Op
  9244                                  ;   41 var sign byte    43   32 Op2
  9245                                  ;   42 var sign byte    44   34 CodeType
  9246                                  ;   43 var sign byte    45   29 Code1
  9247                                  ;   44 var sign byte    46    3 Code2
  9248                                  ;   45 var sign byte    47    1 Code3
  9249                                  ;   46 var sign byte    48   19 R2No
  9250                                  ;   47 var sign byte    49   17 R1No
  9251                                  ;   48 var sign byte    50   18 R2Type
  9252                                  ;   49 var sign byte    51   15 R1Type
  9253                                  ;   50 var sign byte    52   14 OpSize
  9254                                  ;   51 var sign byte    53    9 wflag
  9255                                  ;   52 var sign byte    54    3 dflag
  9256                                  ;   53 var sign byte    55    8 sflag
  9257                                  ;   54 var sign byte    56   15 rm
  9258                                  ;   55 var sign byte    57    5 isDirect
  9259                                  ;   56 var sign word    58   56 disp
  9260                                  ;   57 var unsg word    59   14 imme
  9261                                  ;   58 def unsg byte    61    - OPMAXLEN=5
  9262                                  ;   59 arr sign byte    62    2 OpPos[5]
  9263                                  ;   60 var sign word    63    6 OpPrintIndex
  9264                                  ;   61 ptr sign byte    64   17 OpCodePtr
  9265                                  ;   62 var sign byte    65    5 PrintRA
  9266                                  ;   63 def unsg byte    67    - LABELNAMESMAX=5969
  9267                                  ;   64 arr sign byte    68    3 LabelNames[6000]
  9268                                  ;   65 ptr sign byte    69    7 LabelNamePtr
  9269                                  ;   66 ptr sign byte    70    2 tmpLabelNamePtr
  9270                                  ;   67 def unsg byte    72    - LABELADRMAX=600
  9271                                  ;   68 arr unsg word    73    8 LabelAddr[600]
  9272                                  ;   69 var sign word    74   10 LabelMaxIx
  9273                                  ;   70 var sign word    75    3 tmpLabelMaxIx
  9274                                  ;   71 var sign word    76   13 LabelIx
  9275                                  ;   72 def unsg byte    78    - JMPNAMESMAX=3969
  9276                                  ;   73 arr sign byte    79    3 JmpNames[4000]
  9277                                  ;   74 ptr sign byte    80    7 JmpNamePtr
  9278                                  ;   75 ptr sign byte    81    2 tmpJmpNamePtr
  9279                                  ;   76 def unsg byte    83    - JMPMAX=200
  9280                                  ;   77 arr unsg word    84    2 JmpAddr[200]
  9281                                  ;   78 var sign word    85   10 JmpMaxIx
  9282                                  ;   79 var sign word    86    3 tmpJmpMaxIx
  9283                                  ;   80 def unsg byte    88    - FILEBINMAX=17000
  9284                                  ;   81 arr sign byte    89    5 FileBin[17000]
  9285                                  ;   82 var unsg word    90    6 BinLen
  9286                                  ;   83 ptr sign byte    92    1 arglen
  9287                                  ;   84 ptr sign byte    93    4 argv
  9288                                  ;   85 var sign byte   451    1 I_START
  9289                                  ;   86 arr sign byte   454 NULL I_PUSHA[8125]
  9290                                  ;   87 arr sign byte   455 NULL I_NOP[24260]
  9291                                  ;   88 arr sign byte   456 NULL I_CWDE[9734]
  9292                                  ;   89 arr sign byte   457 NULL I_CDQ[1931]
  9293                                  ;   90 arr sign byte   458 NULL I_PUSHF[35622]
  9294                                  ;   91 arr sign byte   459 NULL I_SAHF[599]
  9295                                  ;   92 arr sign byte   460 NULL I_MOVSB[53495]
  9296                                  ;   93 arr sign byte   461 NULL I_CMPSB[54007]
  9297                                  ;   94 arr sign byte   462 NULL I_STOSB[37]
  9298                                  ;   95 arr sign byte   463 NULL I_LODSB[33600]
  9299                                  ;   96 arr sign byte   464 NULL I_SCASB[8418]
  9300                                  ;   97 arr sign byte   465 NULL I_LEAVE[53259]
  9301                                  ;   98 arr sign byte   466 NULL I_INTO[12917]
  9302                                  ;   99 arr sign byte   467 NULL I_XLAT[35622]
  9303                                  ;  100 arr sign byte   468 NULL I_REPNE[2119]
  9304                                  ;  101 arr sign byte   469 NULL I_REPE[18057]
  9305                                  ;  102 arr sign byte   470 NULL I_HLT[9982]
  9306                                  ;  103 arr sign byte   471 NULL I_STC[18315]
  9307                                  ;  104 arr sign byte   472 NULL I_STI[9734]
  9308                                  ;  105 arr sign byte   473 NULL I_STD[32643]
  9309                                  ;  106 arr sign byte   475 NULL I_INC[10]
  9310                                  ;  107 arr sign byte   476 NULL I_DEC[1397]
  9311                                  ;  108 arr sign byte   477 NULL I_NOT[18119]
  9312                                  ;  109 arr sign byte   478 NULL I_NEG[65534]
  9313                                  ;  110 arr sign byte   479 NULL I_MUL[33791]
  9314                                  ;  111 arr sign byte   480 NULL I_IMUL[65150]
  9315                                  ;  112 arr sign byte   481 NULL I_DIV[30207]
  9316                                  ;  113 arr sign byte   482 NULL I_IDIV[15642]
  9317                                  ;  114 arr sign byte   484 NULL I_LES[65535]
  9318                                  ;  115 arr sign byte   485 NULL I_LDS[5493]
  9319                                  ;  116 arr sign byte   486 NULL I_LEA[33574]
  9320                                  ;  117 arr sign byte   487 NULL I_LSS[1151]
  9321                                  ;  118 arr sign byte   488 NULL I_LFS[29696]
  9322                                  ;  119 arr sign byte   489 NULL I_LGS[35593]
  9323                                  ;  120 arr sign byte   491 NULL I_ADD[2630]
  9324                                  ;  121 arr sign byte   492 NULL I_OR[14630]
  9325                                  ;  122 arr sign byte   493 NULL I_ADC[1095]
  9326                                  ;  123 arr sign byte   494 NULL I_SBB[26997]
  9327                                  ;  124 arr sign byte   495 NULL I_AND[49203]
  9328                                  ;  125 arr sign byte   496 NULL I_SUB[52169]
  9329                                  ;  126 arr sign byte   497 NULL I_XOR[33680]
  9330                                  ;  127 arr sign byte   498 NULL I_CMP[65150]
  9331                                  ;  128 arr sign byte   499 NULL I_TEST[29729]
  9332                                  ;  129 arr sign byte   501 NULL I_MOV[33618]
  9333                                  ;  130 arr sign byte   502 NULL I_MOVSX[65150]
  9334                                  ;  131 arr sign byte   503 NULL I_MOVZX[29731]
  9335                                  ;  132 arr sign byte   505 NULL I_JO[33612]
  9336                                  ;  133 arr sign byte   506 NULL I_JNO[65150]
  9337                                  ;  134 arr sign byte   507 NULL I_JB[29732]
  9338                                  ;  135 arr sign byte   508 NULL I_JNB[33606]
  9339                                  ;  136 arr sign byte   509 NULL I_JAE[65150]
  9340                                  ;  137 arr sign byte   510 NULL I_JE[29734]
  9341                                  ;  138 arr sign byte   511 NULL I_JNE[33600]
  9342                                  ;  139 arr sign byte   512 NULL I_JBE[65150]
  9343                                  ;  140 arr sign byte   513 NULL I_JA[29730]
  9344                                  ;  141 arr sign byte   514 NULL I_JS[33594]
  9345                                  ;  142 arr sign byte   515 NULL I_JNS[65150]
  9346                                  ;  143 arr sign byte   516 NULL I_JP[29737]
  9347                                  ;  144 arr sign byte   517 NULL I_JNP[33588]
  9348                                  ;  145 arr sign byte   518 NULL I_JL[65150]
  9349                                  ;  146 arr sign byte   519 NULL I_JNL[29736]
  9350                                  ;  147 arr sign byte   520 NULL I_JLE[33582]
  9351                                  ;  148 arr sign byte   521 NULL I_JG[65150]
  9352                                  ;  149 arr sign byte   523 NULL I_JMP[29733]
  9353                                  ;  150 arr sign byte   524 NULL I_CALL[15656]
  9354                                  ;  151 arr sign byte   526 NULL I_RET[33]
  9355                                  ;  152 arr sign byte   527 NULL I_RETF[9076]
  9356                                  ;  153 arr sign byte   529 NULL I_PUSH[9021]
  9357                                  ;  154 arr sign byte   530 NULL I_POP[29696]
  9358                                  ;  155 arr sign byte   532 NULL I_ROL[15646]
  9359                                  ;  156 arr sign byte   533 NULL I_RCL[36]
  9360                                  ;  157 arr sign byte   534 NULL I_SHL[6516]
  9361                                  ;  158 arr sign byte   535 NULL I_SHR[9789]
  9362                                  ;  159 arr sign byte   537 NULL I_INT[29696]
  9363                                  ;  160 arr sign byte   539 NULL I_IN[15636]
  9364                                  ;  161 arr sign byte   540 NULL I_INSB[34]
  9365                                  ;  162 arr sign byte   541 NULL I_INSW[3956]
  9366                                  ;  163 arr sign byte   542 NULL I_INSD[10557]
  9367                                  ;  164 arr sign byte   543 NULL I_OUT[29696]
  9368                                  ;  165 arr sign byte   544 NULL I_OUTSB[15626]
  9369                                  ;  166 arr sign byte   545 NULL I_OUTSW[40]
  9370                                  ;  167 arr sign byte   546 NULL I_OUTSD[1396]
  9371                                  ;  168 arr sign byte   548 NULL I_XCHG[9533]
  9372                                  ;  169 arr sign byte   550 NULL I_LOOPNZ[29952]
  9373                                  ;  170 arr sign byte   551 NULL I_LOOPNE[33542]
  9374                                  ;  171 arr sign byte   552 NULL I_LOOPZ[2686]
  9375                                  ;  172 arr sign byte   553 NULL I_LOOPE[60176]
  9376                                  ;  173 arr sign byte   554 NULL I_LOOP[33540]
  9377                                  ;  174 arr sign byte   555 NULL I_JCXZ[2686]
  9378                                  ;  175 arr sign byte   556 NULL I_JECXZ[29984]
  9379                                  ;  176 arr sign byte   558 NULL I_ENTER[47255]
  9380                                  ;  177 arr sign byte   560 NULL I_ORG[1]
  9381                                  ;  178 arr sign byte   562 NULL I_SECTION[52169]
  9382                                  ;  179 arr sign byte   563 NULL I_SEGMENT[21904]
  9383                                  ;  180 arr sign byte   564 NULL I_ABSOLUTE[60555]
  9384                                  ;  181 arr sign byte   565 NULL I_PROC[5816]
  9385                                  ;  182 arr sign byte   566 NULL I_ENDP[39424]
  9386                                  ;  183 arr sign byte   567 NULL I_DB[674]
  9387                                  ;  184 arr sign byte   568 NULL I_DW[8125]
  9388                                  ;  185 arr sign byte   569 NULL I_DD[51030]
  9389                                  ;  186 arr sign byte   570 NULL I_RESB[65094]
  9390                                  ;  187 arr sign byte   571 NULL I_RESW[0]
  9391                                  ;  188 arr sign byte   572 NULL I_RESD[1678]
  9392                                  ;  189 var sign byte   573 NULL I_END
  9393                                  
  9394                                  
  9395                                  ;   # Calls Line Width  Name   list of functions
  9396                                  
  9397                                  ;    0    4   97   writetty
  9398                                  ;    1    1   98   putch
  9399                                  ;    2    8   99   cputs
  9400                                  ;    3    6  101   DosInt
  9401                                  ;    4    1  106   openR
  9402                                  ;    5    2  107   creatR
  9403                                  ;    6    3  108   fcloseR
  9404                                  ;    7    5  109   exitR
  9405                                  ;    8    2  110   readRL
  9406                                  ;    9    2  112   fputcR
  9407                                  ;   10    2  115   letterE
  9408                                  ;   11    3  125   digit
  9409                                  ;   12    1  130   alnumE
  9410                                  ;   13    4  135   strlen
  9411                                  ;   14   10  140   strcpy
  9412                                  ;   15   35  146   eqstr
  9413                                  ;   16    3  155   strcat1
  9414                                  ;   17    2  159   toupper
  9415                                  ;   18    1  166   testReg
  9416                                  ;   19    7  209   prc
  9417                                  ;   20    1  219   prscomment
  9418                                  ;   21   38  227   prs
  9419                                  ;   22    2  249   printhex4
  9420                                  ;   23    3  254   printhex8a
  9421                                  ;   24    3  259   printhex16
  9422                                  ;   25    7  264   printIntU
  9423                                  ;   26    1  274   printLine
  9424                                  ;   27    2  297   epilog
  9425                                  ;   28    2  345   end1
  9426                                  ;   29   27  353   error1
  9427                                  ;   30   13  360   errorexit
  9428                                  ;   31    4  365   notfounderror
  9429                                  ;   32 NULL  371   allowederror
  9430                                  ;   33    3  372   addrerror
  9431                                  ;   34    1  373   immeerror
  9432                                  ;   35    7  374   implerror
  9433                                  ;   36    4  375   indexerror
  9434                                  ;   37    2  376   invaloperror
  9435                                  ;   38    6  377   numbererror
  9436                                  ;   39    1  378   regmemerror
  9437                                  ;   40    3  379   reg16error
  9438                                  ;   41    1  380   segregerror
  9439                                  ;   42    5  381   syntaxerror
  9440                                  ;   43 NULL  383   addrexit
  9441                                  ;   44    3  384   dataexit
  9442                                  ;   45 NULL  385   internexit
  9443                                  ;   46    1  387   ifEOL
  9444                                  ;   47    1  396   getLine
  9445                                  ;   48    4  412   skipBlank
  9446                                  ;   49    1  418   getDigit
  9447                                  ;   50    1  430   getName
  9448                                  ;   51    2  575   lookCode
  9449                                  ;   52   38  591   genCode8
  9450                                  ;   53    1  602   gen66h
  9451                                  ;   54    9  604   genCode2
  9452                                  ;   55   14  608   genCodeW
  9453                                  ;   56   19  612   genCode16
  9454                                  ;   57    1  616   genCode32
  9455                                  ;   58   14  627   writeEA
  9456                                  ;   59    4  670   genImmediate
  9457                                  ;   60    2  677   setwflag
  9458                                  ;   61    2  688   setsflag
  9459                                  ;   62    2  698   checkConstSize
  9460                                  ;   63    2  705   ChangeDirection
  9461                                  ;   64   17  713   getTokeType
  9462                                  ;   65   11  724   isToken
  9463                                  ;   66    2  734   need
  9464                                  ;   67    1  743   skipRest
  9465                                  ;   68    2  749   checkOpL
  9466                                  ;   69    5  758   searchLabel
  9467                                  ;   70    4  771   getOp1
  9468                                  ;   71    1  786   getIndReg1
  9469                                  ;   72    1  794   getIndReg2
  9470                                  ;   73    1  803   getMEM
  9471                                  ;   74    2  830   getOpR
  9472                                  ;   75    3  843   getOpL
  9473                                  ;   76    1  850   get2Ops
  9474                                  ;   77    4  855   check2Ops
  9475                                  ;   78    3  865   storeJmp
  9476                                  ;   79    2  876   storeLabel
  9477                                  ;   80    1  889   genDB
  9478                                  ;   81    1  910   getVariable
  9479                                  ;   82    1  963   getCodeSize
  9480                                  ;   83    1  973   getarg
  9481                                  ;   84    2 1007   FixOneJmp
  9482                                  ;   85    1 1024   fixJmp
  9483                                  ;   86    1 1039   fixJmpMain
  9484                                  ;   87    1 1049   process
  9485                                  ;   88    1 1479   parse
  9486                                  ;   89 NULL 1516   main
  9487                                  
  9488                                  ;    #  addr name   list of CALLs
  9489                                  
  9490                                  ;    0     0 writetty
  9491                                  ;    1     9 writetty
  9492                                  ;    2    18 putch
  9493                                  ;    3    24 DosInt
  9494                                  ;    4    31 DosInt
  9495                                  ;    5    38 DosInt
  9496                                  ;    6    45 DosInt
  9497                                  ;    7    52 DosInt
  9498                                  ;    8    59 DosInt
  9499                                  ;    9    66 digit
  9500                                  ;   10    72 letterE
  9501                                  ;   11    80 strcpy
  9502                                  ;   12    87 strlen
  9503                                  ;   13    94 strlen
  9504                                  ;   14   101 eqstr
  9505                                  ;   15   107 eqstr
  9506                                  ;   16   113 eqstr
  9507                                  ;   17   119 eqstr
  9508                                  ;   18   125 eqstr
  9509                                  ;   19   131 eqstr
  9510                                  ;   20   137 eqstr
  9511                                  ;   21   143 eqstr
  9512                                  ;   22   149 eqstr
  9513                                  ;   23   155 eqstr
  9514                                  ;   24   161 eqstr
  9515                                  ;   25   167 eqstr
  9516                                  ;   26   173 eqstr
  9517                                  ;   27   179 eqstr
  9518                                  ;   28   185 eqstr
  9519                                  ;   29   191 eqstr
  9520                                  ;   30   197 eqstr
  9521                                  ;   31   203 eqstr
  9522                                  ;   32   209 eqstr
  9523                                  ;   33   215 eqstr
  9524                                  ;   34   221 eqstr
  9525                                  ;   35   227 eqstr
  9526                                  ;   36   233 eqstr
  9527                                  ;   37   239 eqstr
  9528                                  ;   38   245 eqstr
  9529                                  ;   39   251 eqstr
  9530                                  ;   40   257 eqstr
  9531                                  ;   41   263 eqstr
  9532                                  ;   42   269 eqstr
  9533                                  ;   43   275 eqstr
  9534                                  ;   44   281 writetty
  9535                                  ;   45   290 writetty
  9536                                  ;   46   299 fputcR
  9537                                  ;   47   306 prc
  9538                                  ;   48   310 prc
  9539                                  ;   49   314 prc
  9540                                  ;   50   318 printhex4
  9541                                  ;   51   328 printhex4
  9542                                  ;   52   338 printhex8a
  9543                                  ;   53   349 printhex8a
  9544                                  ;   54   360 printIntU
  9545                                  ;   55   370 prc
  9546                                  ;   56   374 prs
  9547                                  ;   57   378 printhex16
  9548                                  ;   58   389 prs
  9549                                  ;   59   393 prc
  9550                                  ;   60   397 printhex8a
  9551                                  ;   61   408 prs
  9552                                  ;   62   412 prc
  9553                                  ;   63   416 prscomment
  9554                                  ;   64   427 prs
  9555                                  ;   65   431 printIntU
  9556                                  ;   66   441 prs
  9557                                  ;   67   445 prs
  9558                                  ;   68   449 prs
  9559                                  ;   69   453 prs
  9560                                  ;   70   457 prs
  9561                                  ;   71   461 prs
  9562                                  ;   72   465 printIntU
  9563                                  ;   73   475 prs
  9564                                  ;   74   479 prs
  9565                                  ;   75   483 printIntU
  9566                                  ;   76   493 fputcR
  9567                                  ;   77   500 fcloseR
  9568                                  ;   78   508 fcloseR
  9569                                  ;   79   516 fcloseR
  9570                                  ;   80   524 exitR
  9571                                  ;   81   530 prs
  9572                                  ;   82   534 prs
  9573                                  ;   83   538 prs
  9574                                  ;   84   542 prs
  9575                                  ;   85   546 error1
  9576                                  ;   86   553 epilog
  9577                                  ;   87   560 end1
  9578                                  ;   88   565 prs
  9579                                  ;   89   569 prs
  9580                                  ;   90   573 prs
  9581                                  ;   91   577 error1
  9582                                  ;   92   584 error1
  9583                                  ;   93   591 error1
  9584                                  ;   94   598 error1
  9585                                  ;   95   605 error1
  9586                                  ;   96   612 error1
  9587                                  ;   97   619 error1
  9588                                  ;   98   626 error1
  9589                                  ;   99   633 error1
  9590                                  ;  100   640 error1
  9591                                  ;  101   647 error1
  9592                                  ;  102   654 errorexit
  9593                                  ;  103   664 errorexit
  9594                                  ;  104   674 errorexit
  9595                                  ;  105   684 readRL
  9596                                  ;  106   691 errorexit
  9597                                  ;  107   701 readRL
  9598                                  ;  108   708 errorexit
  9599                                  ;  109   718 errorexit
  9600                                  ;  110   728 ifEOL
  9601                                  ;  111   734 digit
  9602                                  ;  112   740 alnumE
  9603                                  ;  113   747 errorexit
  9604                                  ;  114   757 strcpy
  9605                                  ;  115   764 toupper
  9606                                  ;  116   772 eqstr
  9607                                  ;  117   778 errorexit
  9608                                  ;  118   788 genCode8
  9609                                  ;  119   797 genCode8
  9610                                  ;  120   806 genCode8
  9611                                  ;  121   815 genCode8
  9612                                  ;  122   824 genCode8
  9613                                  ;  123   833 genCode16
  9614                                  ;  124   843 genCode16
  9615                                  ;  125   853 genCode8
  9616                                  ;  126   862 genCode8
  9617                                  ;  127   871 genCode16
  9618                                  ;  128   881 genCode32
  9619                                  ;  129   891 genCode16
  9620                                  ;  130   901 genCode8
  9621                                  ;  131   910 gen66h
  9622                                  ;  132   917 error1
  9623                                  ;  133   924 skipBlank
  9624                                  ;  134   934 digit
  9625                                  ;  135   940 getDigit
  9626                                  ;  136   949 letterE
  9627                                  ;  137   957 getName
  9628                                  ;  138   965 skipBlank
  9629                                  ;  139   975 isToken
  9630                                  ;  140   983 getTokeType
  9631                                  ;  141   995 error1
  9632                                  ;  142  1002 prs
  9633                                  ;  143  1006 prc
  9634                                  ;  144  1010 getTokeType
  9635                                  ;  145  1022 error1
  9636                                  ;  146  1029 implerror
  9637                                  ;  147  1039 segregerror
  9638                                  ;  148  1051 setwflag
  9639                                  ;  149  1060 error1
  9640                                  ;  150  1067 error1
  9641                                  ;  151  1074 eqstr
  9642                                  ;  152  1080 strlen
  9643                                  ;  153  1087 testReg
  9644                                  ;  154  1095 searchLabel
  9645                                  ;  155  1107 indexerror
  9646                                  ;  156  1118 indexerror
  9647                                  ;  157  1129 indexerror
  9648                                  ;  158  1140 indexerror
  9649                                  ;  159  1151 getTokeType
  9650                                  ;  160  1163 getOp1
  9651                                  ;  161  1170 syntaxerror
  9652                                  ;  162  1182 getIndReg2
  9653                                  ;  163  1193 getIndReg1
  9654                                  ;  164  1204 notfounderror
  9655                                  ;  165  1218 isToken
  9656                                  ;  166  1226 getTokeType
  9657                                  ;  167  1238 numbererror
  9658                                  ;  168  1250 isToken
  9659                                  ;  169  1258 isToken
  9660                                  ;  170  1266 errorexit
  9661                                  ;  171  1276 getOp1
  9662                                  ;  172  1283 isToken
  9663                                  ;  173  1291 getMEM
  9664                                  ;  174  1298 invaloperror
  9665                                  ;  175  1311 error1
  9666                                  ;  176  1318 getOpR
  9667                                  ;  177  1325 getOpL
  9668                                  ;  178  1332 need
  9669                                  ;  179  1337 getOpR
  9670                                  ;  180  1344 get2Ops
  9671                                  ;  181  1352 addrerror
  9672                                  ;  182  1362 invaloperror
  9673                                  ;  183  1375 immeerror
  9674                                  ;  184  1385 addrerror
  9675                                  ;  185  1395 setwflag
  9676                                  ;  186  1404 errorexit
  9677                                  ;  187  1414 strcpy
  9678                                  ;  188  1421 errorexit
  9679                                  ;  189  1431 searchLabel
  9680                                  ;  190  1443 error1
  9681                                  ;  191  1450 errorexit
  9682                                  ;  192  1460 strcpy
  9683                                  ;  193  1467 errorexit
  9684                                  ;  194  1477 getTokeType
  9685                                  ;  195  1489 genCode8
  9686                                  ;  196  1498 skipBlank
  9687                                  ;  197  1508 isToken
  9688                                  ;  198  1516 genCode8
  9689                                  ;  199  1525 isToken
  9690                                  ;  200  1533 storeLabel
  9691                                  ;  201  1544 getTokeType
  9692                                  ;  202  1556 lookCode
  9693                                  ;  203  1565 dataexit
  9694                                  ;  204  1574 dataexit
  9695                                  ;  205  1583 getTokeType
  9696                                  ;  206  1595 genCode8
  9697                                  ;  207  1604 skipBlank
  9698                                  ;  208  1614 isToken
  9699                                  ;  209  1622 genCode8
  9700                                  ;  210  1631 isToken
  9701                                  ;  211  1639 getTokeType
  9702                                  ;  212  1651 genCode16
  9703                                  ;  213  1661 isToken
  9704                                  ;  214  1669 getTokeType
  9705                                  ;  215  1681 genCode16
  9706                                  ;  216  1691 genCode16
  9707                                  ;  217  1701 isToken
  9708                                  ;  218  1709 getTokeType
  9709                                  ;  219  1721 syntaxerror
  9710                                  ;  220  1733 error1
  9711                                  ;  221  1740 numbererror
  9712                                  ;  222  1752 dataexit
  9713                                  ;  223  1761 eqstr
  9714                                  ;  224  1767 getTokeType
  9715                                  ;  225  1779 eqstr
  9716                                  ;  226  1785 getTokeType
  9717                                  ;  227  1797 eqstr
  9718                                  ;  228  1803 getTokeType
  9719                                  ;  229  1815 cputs
  9720                                  ;  230  1821 cputs
  9721                                  ;  231  1827 exitR
  9722                                  ;  232  1833 toupper
  9723                                  ;  233  1841 strcpy
  9724                                  ;  234  1848 strcat1
  9725                                  ;  235  1856 strcpy
  9726                                  ;  236  1863 strcat1
  9727                                  ;  237  1871 strcpy
  9728                                  ;  238  1878 strcat1
  9729                                  ;  239  1886 openR
  9730                                  ;  240  1892 cputs
  9731                                  ;  241  1898 cputs
  9732                                  ;  242  1904 exitR
  9733                                  ;  243  1910 creatR
  9734                                  ;  244  1917 cputs
  9735                                  ;  245  1923 cputs
  9736                                  ;  246  1929 exitR
  9737                                  ;  247  1935 creatR
  9738                                  ;  248  1942 cputs
  9739                                  ;  249  1948 cputs
  9740                                  ;  250  1954 exitR
  9741                                  ;  251  1960 prs
  9742                                  ;  252  1964 prs
  9743                                  ;  253  1968 prs
  9744                                  ;  254  1972 prs
  9745                                  ;  255  1976 prs
  9746                                  ;  256  1980 prs
  9747                                  ;  257  1984 prs
  9748                                  ;  258  1988 prs
  9749                                  ;  259  1992 prs
  9750                                  ;  260  1996 searchLabel
  9751                                  ;  261  2008 notfounderror
  9752                                  ;  262  2022 prs
  9753                                  ;  263  2026 printhex16
  9754                                  ;  264  2037 strcpy
  9755                                  ;  265  2044 strlen
  9756                                  ;  266  2051 FixOneJmp
  9757                                  ;  267  2061 prs
  9758                                  ;  268  2065 printIntU
  9759                                  ;  269  2075 error1
  9760                                  ;  270  2082 strcpy
  9761                                  ;  271  2089 FixOneJmp
  9762                                  ;  272  2099 prs
  9763                                  ;  273  2103 printhex16
  9764                                  ;  274  2114 getTokeType
  9765                                  ;  275  2126 getCodeSize
  9766                                  ;  276  2138 genCode8
  9767                                  ;  277  2147 getOpL
  9768                                  ;  278  2154 checkOpL
  9769                                  ;  279  2163 genCode2
  9770                                  ;  280  2172 genCode2
  9771                                  ;  281  2181 getTokeType
  9772                                  ;  282  2193 implerror
  9773                                  ;  283  2203 genCodeW
  9774                                  ;  284  2212 genCodeW
  9775                                  ;  285  2221 writeEA
  9776                                  ;  286  2229 check2Ops
  9777                                  ;  287  2239 reg16error
  9778                                  ;  288  2250 addrerror
  9779                                  ;  289  2260 genCode8
  9780                                  ;  290  2269 genCode8
  9781                                  ;  291  2278 writeEA
  9782                                  ;  292  2286 check2Ops
  9783                                  ;  293  2296 notfounderror
  9784                                  ;  294  2310 setsflag
  9785                                  ;  295  2319 genCodeW
  9786                                  ;  296  2328 genImmediate
  9787                                  ;  297  2341 genCodeW
  9788                                  ;  298  2350 writeEA
  9789                                  ;  299  2358 genCode8
  9790                                  ;  300  2367 genImmediate
  9791                                  ;  301  2380 genCodeW
  9792                                  ;  302  2389 writeEA
  9793                                  ;  303  2397 genCodeW
  9794                                  ;  304  2406 writeEA
  9795                                  ;  305  2414 syntaxerror
  9796                                  ;  306  2426 check2Ops
  9797                                  ;  307  2436 notfounderror
  9798                                  ;  308  2450 genCode2
  9799                                  ;  309  2459 genImmediate
  9800                                  ;  310  2472 genCodeW
  9801                                  ;  311  2481 writeEA
  9802                                  ;  312  2489 genImmediate
  9803                                  ;  313  2502 regmemerror
  9804                                  ;  314  2514 ChangeDirection
  9805                                  ;  315  2530 reg16error
  9806                                  ;  316  2541 genCode2
  9807                                  ;  317  2550 writeEA
  9808                                  ;  318  2558 genCodeW
  9809                                  ;  319  2567 genCode16
  9810                                  ;  320  2577 genCodeW
  9811                                  ;  321  2586 genCode16
  9812                                  ;  322  2596 genCodeW
  9813                                  ;  323  2605 writeEA
  9814                                  ;  324  2613 ChangeDirection
  9815                                  ;  325  2629 genCodeW
  9816                                  ;  326  2638 writeEA
  9817                                  ;  327  2646 syntaxerror
  9818                                  ;  328  2658 searchLabel
  9819                                  ;  329  2670 checkConstSize
  9820                                  ;  330  2685 genCode2
  9821                                  ;  331  2694 genCode8
  9822                                  ;  332  2703 genCode8
  9823                                  ;  333  2712 genCode2
  9824                                  ;  334  2721 genCode16
  9825                                  ;  335  2731 genCode8
  9826                                  ;  336  2740 genCode2
  9827                                  ;  337  2749 storeJmp
  9828                                  ;  338  2758 genCode16
  9829                                  ;  339  2768 searchLabel
  9830                                  ;  340  2780 checkConstSize
  9831                                  ;  341  2795 genCode8
  9832                                  ;  342  2804 genCode8
  9833                                  ;  343  2813 genCode8
  9834                                  ;  344  2822 genCode16
  9835                                  ;  345  2832 genCode8
  9836                                  ;  346  2841 genCode16
  9837                                  ;  347  2851 genCode8
  9838                                  ;  348  2860 storeJmp
  9839                                  ;  349  2869 genCode16
  9840                                  ;  350  2879 genCode8
  9841                                  ;  351  2888 genCode16
  9842                                  ;  352  2898 genCode8
  9843                                  ;  353  2907 getOpL
  9844                                  ;  354  2914 setsflag
  9845                                  ;  355  2923 genCode2
  9846                                  ;  356  2932 genCode8
  9847                                  ;  357  2941 genCode16
  9848                                  ;  358  2951 genCode8
  9849                                  ;  359  2960 genCode16
  9850                                  ;  360  2970 genCode8
  9851                                  ;  361  2979 storeJmp
  9852                                  ;  362  2988 genCode16
  9853                                  ;  363  2998 error1
  9854                                  ;  364  3005 genCode8
  9855                                  ;  365  3014 genCode8
  9856                                  ;  366  3023 checkOpL
  9857                                  ;  367  3032 genCode8
  9858                                  ;  368  3041 writeEA
  9859                                  ;  369  3049 genCode8
  9860                                  ;  370  3058 writeEA
  9861                                  ;  371  3066 reg16error
  9862                                  ;  372  3077 genCode2
  9863                                  ;  373  3086 syntaxerror
  9864                                  ;  374  3098 check2Ops
  9865                                  ;  375  3108 genCodeW
  9866                                  ;  376  3117 writeEA
  9867                                  ;  377  3125 genCodeW
  9868                                  ;  378  3134 writeEA
  9869                                  ;  379  3142 genCode8
  9870                                  ;  380  3151 genCodeW
  9871                                  ;  381  3160 writeEA
  9872                                  ;  382  3168 genCode8
  9873                                  ;  383  3177 genCode8
  9874                                  ;  384  3186 implerror
  9875                                  ;  385  3196 implerror
  9876                                  ;  386  3206 implerror
  9877                                  ;  387  3216 genCode8
  9878                                  ;  388  3225 getOp1
  9879                                  ;  389  3232 genCode16
  9880                                  ;  390  3242 numbererror
  9881                                  ;  391  3254 need
  9882                                  ;  392  3259 getOp1
  9883                                  ;  393  3266 genCode8
  9884                                  ;  394  3275 numbererror
  9885                                  ;  395  3287 implerror
  9886                                  ;  396  3297 implerror
  9887                                  ;  397  3307 numbererror
  9888                                  ;  398  3319 numbererror
  9889                                  ;  399  3331 prs
  9890                                  ;  400  3335 prs
  9891                                  ;  401  3339 error1
  9892                                  ;  402  3346 error1
  9893                                  ;  403  3353 prs
  9894                                  ;  404  3357 prs
  9895                                  ;  405  3361 prs
  9896                                  ;  406  3365 printIntU
  9897                                  ;  407  3375 prs
  9898                                  ;  408  3379 printIntU
  9899                                  ;  409  3389 fixJmp
  9900                                  ;  410  3396 genDB
  9901                                  ;  411  3402 error1
  9902                                  ;  412  3409 getLine
  9903                                  ;  413  3417 getTokeType
  9904                                  ;  414  3429 strcpy
  9905                                  ;  415  3436 storeLabel
  9906                                  ;  416  3447 getTokeType
  9907                                  ;  417  3459 lookCode
  9908                                  ;  418  3468 process
  9909                                  ;  419  3476 getVariable
  9910                                  ;  420  3488 skipRest
  9911                                  ;  421  3497 error1
  9912                                  ;  422  3504 error1
  9913                                  ;  423  3511 printLine
  9914                                  ;  424  3521 getarg
  9915                                  ;  425  3528 parse
  9916                                  ;  426  3534 fixJmpMain
  9917                                  ;  427  3545 epilog
  9918                                  ;  428  3552 end1
  9919                                  ;Input: AS.C, List: AS.S,  Lines: 1523
  9920                                  ;Glob. variables:  189 max.:  200
  9921                                  ;Functions      :   90 max.:  300
  9922                                  ;Calls          :  429 max.: 2000, NameField: 3557 max.:    65535
  9923                                  ;Data (HeapEnd) :59154, resting stacksize:  6381
  9924                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
