     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E91523                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.07 31.1.2016";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E30-     Version1 db "AS.C V0.07 31.1.2016",0
    10 0000000C 372033312E312E3230-
    11 00000015 313600             
    12                                  
    13                                  ;-2 #include "DECL.C"
    14                                  
    15                                  ;Use include file: DECL.C
    16                                  
    17                                  ;-1 char LIST;              // listing on/off
    18                                  
    19 00000018 00                      LIST db 0
    20                                  
    21                                  ;-2 #define SYMBOLMAX    31
    22                                  
    23                                  
    24                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    25                                  
    26 00000019 <res 0000001F>          Symbol resb 31
    27                                  
    28                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    29                                  
    30 00000038 <res 0000001F>          SymbolUpper resb 31
    31                                  
    32                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    33                                  
    34 00000057 0000                    SymbolInt dw 0
    35                                  
    36                                  ;-6 #define INPUTBUFMAX 127
    37                                  
    38                                  
    39                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    40                                  
    41 00000059 <res 0000007F>          InputBuf resb 127
    42                                  
    43                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    44                                  
    45 000000D8 0000                    InputPtr dw 0
    46                                  
    47                                  ;-9 char namein [67];       //input file name  .S
    48                                  
    49 000000DA <res 00000043>          namein resb 67
    50                                  
    51                                  ;-10 char namelst[67];       //list file name   .LST
    52                                  
    53 0000011D <res 00000043>          namelst resb 67
    54                                  
    55                                  ;-11 char namebin[67];       //output file name .COM
    56                                  
    57 00000160 <res 00000043>          namebin resb 67
    58                                  
    59                                  ;-12 int  asm_fd;            //input file descriptor
    60                                  
    61 000001A3 0000                    asm_fd dw 0
    62                                  
    63                                  ;-13 int lst_fd;             //list file descriptor
    64                                  
    65 000001A5 0000                    lst_fd dw 0
    66                                  
    67                                  ;-14 int bin_fd;             //output file descriptor
    68                                  
    69 000001A7 0000                    bin_fd dw 0
    70                                  
    71                                  ;-15 int DOS_ERR;            //global var
    72                                  
    73 000001A9 0000                    DOS_ERR dw 0
    74                                  
    75                                  ;-16 int ErrorCount;         //number of errors
    76                                  
    77 000001AB 0000                    ErrorCount dw 0
    78                                  
    79                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
    80                                  
    81 000001AD 0000                    DOS_NoBytes dw 0
    82                                  
    83                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
    84                                  
    85 000001AF 00                      DOS_ByteRead db 0
    86                                  
    87                                  ;-19 
    88                                  
    89                                  
    90                                  ;-20 unsigned int PC;        //program counter, ORG nn
    91                                  
    92 000001B0 0000                    PC dw 0
    93                                  
    94                                  ;-21 unsigned int PCStart;   //PC at start of line by PrintLine()
    95                                  
    96 000001B2 0000                    PCStart dw 0
    97                                  
    98                                  ;-22 char isLabel;           //by getName()
    99                                  
   100 000001B4 00                      isLabel db 0
   101                                  
   102                                  ;-23 #define DIGIT    1      //0-9
   103                                  
   104                                  
   105                                  ;-24 #define LETTERE  2      //a-z A-Z @ . _
   106                                  
   107                                  
   108                                  ;-25 #define ALNUME   3      //a-z A-Z @ . _  0-9
   109                                  
   110                                  
   111                                  ;-26 #define NOALNUME 4      //other char
   112                                  
   113                                  
   114                                  ;-27 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   115                                  
   116 000001B5 00                      TokeType db 0
   117                                  
   118                                  ;-28 #define BYTE     1
   119                                  
   120                                  
   121                                  ;-29 #define WORD     2
   122                                  
   123                                  
   124                                  ;-30 #define DWORD    3
   125                                  
   126                                  
   127                                  ;-31 #define SEGREG   4
   128                                  
   129                                  
   130                                  ;-32 #define IMM      1      //const  ,123
   131                                  
   132                                  
   133                                  ;-33 #define REG      2      //       ,BX    mode=11
   134                                  
   135                                  
   136                                  ;-34 #define ADR      3      //VALUE  ,var1  mod=00, r/m=110
   137                                  
   138                                  
   139                                  ;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   140                                  
   141                                  
   142                                  ;-36 char Op1;               //0, IMM, REG, ADR, MEM  
   143                                  
   144 000001B6 00                      Op1 db 0
   145                                  
   146                                  ;-37 char Optemp;            //temp for 1. operand
   147                                  
   148 000001B7 00                      Optemp db 0
   149                                  
   150                                  ;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size
   151                                  
   152 000001B8 00                      CodeType db 0
   153                                  
   154                                  ;-39 char Code1;             // first  Opcode
   155                                  
   156 000001B9 00                      Code1 db 0
   157                                  
   158                                  ;-40 char Code2;             // second Opcode
   159                                  
   160 000001BA 00                      Code2 db 0
   161                                  
   162                                  ;-41 char Code3;             // third  Opcode
   163                                  
   164 000001BB 00                      Code3 db 0
   165                                  
   166                                  ;-42 char RegNo;             //0 - 7 AL, CL, ...  set in testReg()  
   167                                  
   168 000001BC 00                      RegNo db 0
   169                                  
   170                                  ;-43 char R1No;              //temp for 1. register
   171                                  
   172 000001BD 00                      R1No db 0
   173                                  
   174                                  ;-44 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   175                                  
   176 000001BE 00                      RegType db 0
   177                                  
   178                                  ;-45 char R1Type;            //temp for 1. register 
   179                                  
   180 000001BF 00                      R1Type db 0
   181                                  
   182                                  ;-46 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   183                                  
   184 000001C0 00                      OpSize db 0
   185                                  
   186                                  ;-47 char wflag;             //wordflag: 0=byte, 1=word/dword
   187                                  
   188 000001C1 00                      wflag db 0
   189                                  
   190                                  ;-48 //char AddrSize;          //67h:
   191                                  
   192                                  
   193                                  ;-49 //char NumOprns;          //0-2
   194                                  
   195                                  
   196                                  ;-50 char dflag;             //directionflag: 0=source is reg,  1=to reg    
   197                                  
   198 000001C2 00                      dflag db 0
   199                                  
   200                                  ;-51 char sflag;             //sign extended, same as dflag
   201                                  
   202 000001C3 00                      sflag db 0
   203                                  
   204                                  ;-52 //char modrm;           //mod, r/m
   205                                  
   206                                  
   207                                  ;-53 char regindexbase;      //combination of index and base reg
   208                                  
   209 000001C4 00                      regindexbase db 0
   210                                  
   211                                  ;-54 char isDirect;          //set in getOp and getMeM, need in WriteEA
   212                                  
   213 000001C5 00                      isDirect db 0
   214                                  
   215                                  ;-55 int disp;               //displacement      0-8 bytes
   216                                  
   217 000001C6 0000                    disp dw 0
   218                                  
   219                                  ;-56 int imme;               //immediate         0-8 bytes
   220                                  
   221 000001C8 0000                    imme dw 0
   222                                  
   223                                  ;-57 
   224                                  
   225                                  
   226                                  ;-58 #define OPMAXLEN 5
   227                                  
   228                                  
   229                                  ;-59 char OpPos[OPMAXLEN];   //array for one opcode to list
   230                                  
   231 000001CA <res 00000005>          OpPos resb 5
   232                                  
   233                                  ;-60 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   234                                  
   235 000001CF 0000                    OpPrintIndex dw 0
   236                                  
   237                                  ;-61 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   238                                  
   239 000001D1 0000                    OpCodePtr dw 0
   240                                  
   241                                  ;-62 char PrintR;           //print 'R' if relocative
   242                                  
   243 000001D3 00                      PrintR db 0
   244                                  
   245                                  ;-63 
   246                                  
   247                                  
   248                                  ;-64 #define LABELNAMESMAX 969//next number - 31
   249                                  
   250                                  
   251                                  ;-65 char LabelNames[1000];  //space for names of all labels
   252                                  
   253 000001D4 <res 000003E8>          LabelNames resb 1000
   254                                  
   255                                  ;-66 char *LabelNamePtr;     // first free position
   256                                  
   257 000005BC 0000                    LabelNamePtr dw 0
   258                                  
   259                                  ;-67 #define LABELADRMAX 100
   260                                  
   261                                  
   262                                  ;-68 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   263                                  
   264 000005BE <res 000000C8>          LabelAddr resw 100
   265                                  
   266                                  ;-69 int LabelMaxIx=0;       //actual number of stored labels
   267                                  
   268 00000686 0000                    LabelMaxIx dw 0
   269                                  
   270                                  ;-70 int LabelIx;            //actual number of just searched label
   271                                  
   272 00000688 0000                    LabelIx dw 0
   273                                  
   274                                  ;-71 
   275                                  
   276                                  
   277                                  ;-72 #define FILEBINMAX 2000 //next number - max. oplength
   278                                  
   279                                  
   280                                  ;-73 char FileBin  [FILEBINMAX];//output binary file
   281                                  
   282 0000068A <res 000007D0>          FileBin resb 2000
   283                                  
   284                                  ;-74 unsigned int BinLen=0;  //length of binary file
   285                                  
   286 00000E5A 0000                    BinLen dw 0
   287                                  
   288                                  ;-75 
   289                                  
   290                                  
   291                                  ;-76 char *arglen=0x80;      // for main only
   292                                  
   293 00000E5C 8000                    arglen dw 128
   294                                  
   295                                  ;-77 char *argv=0x82;        // for main only
   296                                  
   297 00000E5E 8200                    argv dw 130
   298                                  ;Back to main program: AS.C
   299                                  
   300                                  ;-3 #include "OPTABL.C"
   301                                  
   302                                  ;Use include file: OPTABL.C
   303                                  
   304                                  ;-1 char I_START=0xF1;
   305                                  
   306 00000E60 F1                      I_START db 241
   307                                  
   308                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   309                                  
   310                                  
   311                                  ;-3 //  1:   1 byte opcode
   312                                  
   313                                  
   314                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   315                                  
   316 00000E61 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   317                                  
   318                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   319                                  
   320 00000E6A 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   321                                  
   322                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   323                                  
   324 00000E72 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   325                                  
   326                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   327                                  
   328 00000E79 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   329                                  
   330                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   331                                  
   332 00000E80 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   333                                  
   334                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   335                                  
   336 00000E88 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   337                                  
   338                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   339                                  
   340 00000E8F 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   341                                  
   342                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   343                                  
   344 00000E96 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   345                                  
   346                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   347                                  
   348 00000E9E 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   349                                  
   350                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   351                                  
   352 00000EA7 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   353                                  
   354                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   355                                  
   356 00000EAF 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   357                                  
   358                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   359                                  
   360 00000EB7 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   361                                  
   362                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   363                                  
   364 00000EBF 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   365                                  
   366                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   367                                  
   368 00000EC8 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   369                                  
   370                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   371                                  
   372 00000ED1 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   373                                  
   374                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   375                                  
   376 00000EDA 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   377                                  
   378                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   379                                  
   380 00000EE3 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   381                                  
   382                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   383                                  
   384 00000EEC 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   385                                  
   386                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   387                                  
   388 00000EF5 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   389                                  
   390                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   391                                  
   392 00000EFE 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   393                                  
   394                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   395                                  
   396 00000F07 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   397                                  
   398                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   399                                  
   400 00000F10 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   401                                  
   402                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   403                                  
   404 00000F19 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   405                                  
   406                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   407                                  
   408 00000F22 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   409                                  
   410                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   411                                  
   412 00000F2A 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   413                                  
   414                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   415                                  
   416 00000F32 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   417                                  
   418                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   419                                  
   420 00000F3A 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   421                                  
   422                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   423                                  
   424 00000F43 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   425                                  
   426                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   427                                  
   428 00000F4C 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   429                                  
   430                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   431                                  
   432 00000F54 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   433                                  
   434                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   435                                  
   436 00000F5C 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   437                                  
   438                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   439                                  
   440 00000F63 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   441                                  
   442                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   443                                  
   444 00000F6A 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   445                                  
   446                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   447                                  
   448 00000F71 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   449                                  
   450                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   451                                  
   452 00000F78 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   453                                  
   454                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   455                                  
   456 00000F7F 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   457                                  
   458                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   459                                  
   460 00000F86 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   461                                  
   462                                  ;-41 // 2: mem reg 16 bit
   463                                  
   464                                  
   465                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   466                                  
   467 00000F8D 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   468                                  
   469                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   470                                  
   471 00000F96 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   472                                  
   473                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   474                                  
   475 00000F9F 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   476                                  
   477                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   478                                  
   479 00000FA7 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   480                                  
   481                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   482                                  
   483 00000FAF 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   484                                  
   485                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   486                                  
   487 00000FB7 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   488                                  
   489                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   490                                  
   491 00000FC0 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   492                                  
   493                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   494                                  
   495 00000FC8 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   496                                  
   497                                  ;-50 //  3: les, lda, lea, lss, lfs, lgs
   498                                  
   499                                  
   500                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   501                                  
   502 00000FD1 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   503                                  
   504                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   505                                  
   506 00000FD8 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   507                                  
   508                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   509                                  
   510 00000FDF 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   511                                  
   512                                  ;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   513                                  
   514 00000FE6 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   515                                  
   516                                  ;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   517                                  
   518 00000FEE 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   519                                  
   520                                  ;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   521                                  
   522 00000FF6 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   523                                  
   524                                  ;-57 //  4: acc,imm  reg,imm  index,reg
   525                                  
   526                                  
   527                                  ;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   528                                  
   529 00000FFE 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   530                                  
   531                                  ;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   532                                  
   533 00001005 4F52000401F1            I_OR db 79,82,0,4,1,241
   534                                  
   535                                  ;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   536                                  
   537 0000100B 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   538                                  
   539                                  ;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   540                                  
   541 00001012 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   542                                  
   543                                  ;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   544                                  
   545 00001019 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   546                                  
   547                                  ;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   548                                  
   549 00001020 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   550                                  
   551                                  ;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   552                                  
   553 00001027 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   554                                  
   555                                  ;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   556                                  
   557 0000102E 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   558                                  
   559                                  ;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   560                                  
   561 00001035 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   562 0000103E 00F1               
   563                                  
   564                                  ;-67 //  5: mov
   565                                  
   566                                  
   567                                  ;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   568                                  
   569 00001040 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   570                                  
   571                                  ;-69 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   572                                  
   573 00001046 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   574                                  
   575                                  ;-70 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   576                                  
   577 0000104F 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   578                                  
   579                                  ;-71 //  6: single byte relative jump
   580                                  
   581                                  
   582                                  ;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   583                                  
   584 00001058 4A4F000600F1            I_JO db 74,79,0,6,0,241
   585                                  
   586                                  ;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   587                                  
   588 0000105E 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   589                                  
   590                                  ;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   591                                  
   592 00001065 4A42000602F1            I_JB db 74,66,0,6,2,241
   593                                  
   594                                  ;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   595                                  
   596 0000106B 4A43000602F1            I_JC db 74,67,0,6,2,241
   597                                  
   598                                  ;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   599                                  
   600 00001071 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   601                                  
   602                                  ;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   603                                  
   604 00001078 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   605                                  
   606                                  ;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   607                                  
   608 0000107F 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   609                                  
   610                                  ;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   611                                  
   612 00001086 4A45000604F1            I_JE db 74,69,0,6,4,241
   613                                  
   614                                  ;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   615                                  
   616 0000108C 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   617                                  
   618                                  ;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   619                                  
   620 00001092 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   621                                  
   622                                  ;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   623                                  
   624 00001099 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   625                                  
   626                                  ;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   627                                  
   628 000010A0 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   629                                  
   630                                  ;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   631                                  
   632 000010A7 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   633                                  
   634                                  ;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   635                                  
   636 000010AE 4A41000607F1            I_JA db 74,65,0,6,7,241
   637                                  
   638                                  ;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   639                                  
   640 000010B4 4A53000608F1            I_JS db 74,83,0,6,8,241
   641                                  
   642                                  ;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   643                                  
   644 000010BA 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   645                                  
   646                                  ;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   647                                  
   648 000010C1 4A5000060AF1            I_JP db 74,80,0,6,10,241
   649                                  
   650                                  ;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   651                                  
   652 000010C7 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   653                                  
   654                                  ;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   655                                  
   656 000010CE 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   657                                  
   658                                  ;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   659                                  
   660 000010D5 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   661                                  
   662                                  ;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   663                                  
   664 000010DC 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   665                                  
   666                                  ;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   667                                  
   668 000010E2 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   669                                  
   670                                  ;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   671                                  
   672 000010E9 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   673                                  
   674                                  ;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   675                                  
   676 000010F0 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   677                                  
   678                                  ;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   679                                  
   680 000010F7 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   681                                  
   682                                  ;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   683                                  
   684 000010FE 4A4700060FF1            I_JG db 74,71,0,6,15,241
   685                                  
   686                                  ;-98 //  7: jmp, call
   687                                  
   688                                  
   689                                  ;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   690                                  
   691 00001104 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   692                                  
   693                                  ;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   694                                  
   695 0000110C 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   696                                  
   697                                  ;-101 //  8: ret
   698                                  
   699                                  
   700                                  ;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   701                                  
   702 00001115 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   703                                  
   704                                  ;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   705                                  
   706 0000111D 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   707                                  
   708                                  ;-104 //  9: seg, r/m
   709                                  
   710                                  
   711                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   712                                  
   713 00001126 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   714                                  
   715                                  ;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   716                                  
   717 0000112E 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   718                                  
   719                                  ;-107 //  11: shift, rotates
   720                                  
   721                                  
   722                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   723                                  
   724 00001135 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   725                                  
   726                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   727                                  
   728 0000113C 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   729                                  
   730                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   731                                  
   732 00001143 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   733                                  
   734                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   735                                  
   736 0000114A 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   737                                  
   738                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   739                                  
   740 00001151 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   741                                  
   742                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   743                                  
   744 00001158 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   745                                  
   746                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   747                                  
   748 0000115F 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   749                                  
   750                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   751                                  
   752 00001166 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   753                                  
   754                                  ;-116 //  12: int
   755                                  
   756                                  
   757                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   758                                  
   759 0000116D 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   760                                  
   761                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   762                                  
   763 00001175 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   764                                  
   765                                  ;-119 //  14: in/out
   766                                  
   767                                  
   768                                  ;-120 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   769                                  
   770                                  
   771                                  ;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   772                                  
   773                                  
   774                                  ;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   775                                  
   776                                  
   777                                  ;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   778                                  
   779                                  
   780                                  ;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   781                                  
   782                                  
   783                                  ;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   784                                  
   785                                  
   786                                  ;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   787                                  
   788                                  
   789                                  ;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   790                                  
   791                                  
   792                                  ;-128 //  15: xchg
   793                                  
   794                                  
   795                                  ;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   796                                  
   797 0000117D 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   798                                  
   799                                  ;-130 //  16: loop, jcxz
   800                                  
   801                                  
   802                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   803                                  
   804 00001186 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   805 0000118F F1                 
   806                                  
   807                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   808                                  
   809 00001190 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   810 00001199 F1                 
   811                                  
   812                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   813                                  
   814 0000119A 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   815                                  
   816                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   817                                  
   818 000011A3 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   819                                  
   820                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   821                                  
   822 000011AC 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   823                                  
   824                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   825                                  
   826 000011B4 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   827                                  
   828                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   829                                  
   830 000011BC 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   831                                  
   832                                  ;-138 //  30: enter
   833                                  
   834                                  
   835                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   836                                  
   837 000011C5 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   838                                  
   839                                  ;-140 // 100: directives
   840                                  
   841                                  
   842                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   843                                  
   844 000011CE 4F52470065F1            I_ORG db 79,82,71,0,101,241
   845                                  
   846                                  ;-142 // section, segment .TEXT .DATA .BSS
   847                                  
   848                                  
   849                                  ;-143 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   850                                  
   851                                  
   852                                  ;-144 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   853                                  
   854                                  
   855                                  ;-145 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   856                                  
   857                                  
   858                                  ;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};
   859                                  
   860 000011D4 444200C8F1              I_DB db 68,66,0,200,241
   861                                  
   862                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   863                                  
   864 000011D9 445700C9F1              I_DW db 68,87,0,201,241
   865                                  
   866                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   867                                  
   868 000011DE 444400CAF1              I_DD db 68,68,0,202,241
   869                                  
   870                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   871                                  
   872 000011E3 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   873                                  
   874                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   875                                  
   876 000011EA 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   877                                  
   878                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   879                                  
   880 000011F1 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   881                                  
   882                                  ;-152 char I_END=0;// end of table char
   883                                  
   884 000011F8 00                      I_END db 0
   885                                  ;Back to main program: AS.C
   886                                  
   887                                  ;-4 
   888                                  
   889                                  
   890                                  ;-5 #include "PARSE.C"
   891                                  
   892                                  ;Use include file: PARSE.C
   893                                  
   894                                  ;-1 int parse() {
   895                                  
   896                                  
   897                                  parse:  ; *** PROC ***
   898                                  
   899                                  ;-2   LabelNamePtr= &LabelNames;
   900                                  
   901 000011F9 B8[D401]                 mov ax, LabelNames
   902 000011FC A3[BC05]                 mov word [LabelNamePtr], ax
   903                                  
   904                                  ;-3   do {
   905                                  
   906                                  @@parse1:
   907                                  
   908                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
   909                                  
   910 000011FF A1[B001]                 mov ax, [PC]
   911 00001202 A3[B201]                 mov word [PCStart], ax
   912 00001205 66B800000000             mov eax, 0
   913 0000120B A2[C001]                 mov byte [OpSize], al
   914 0000120E 66B800000000             mov eax, 0
   915 00001214 A3[CF01]                 mov word [OpPrintIndex], ax
   916 00001217 66B820000000             mov eax, 32
   917 0000121D A2[D301]                 mov byte [PrintR], al
   918                                  
   919                                  ;-5     getLine();
   920                                  
   921 00001220 E82C05                   call getLine
   922                                  
   923                                  ;-6     InputPtr = &InputBuf;
   924                                  
   925 00001223 B8[5900]                 mov ax, InputBuf
   926 00001226 A3[D800]                 mov word [InputPtr], ax
   927                                  
   928                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
   929                                  
   930 00001229 E8B700                   call getTokeType
   931                                  
   932                                  ;-8     if (TokeType == ALNUME) {
   933                                  
   934 0000122C A0[B501]                 mov al, [TokeType]
   935 0000122F 3C03                     cmp al, 3
   936 00001231 0F851300                 jne @@parse2
   937                                  
   938                                  ;-9       if (isLabel) { //set in getName
   939                                  
   940 00001235 A0[B401]                 mov al, [isLabel]
   941 00001238 08C0                     or  al, al
   942 0000123A 0F840A00                 je @@parse3
   943                                  
   944                                  ;-10         storeLabel();
   945                                  
   946 0000123E E84001                   call storeLabel
   947                                  
   948                                  ;-11         InputPtr++;//remove :
   949                                  
   950 00001241 FF06[D800]               inc  word [InputPtr]
   951                                  
   952                                  ;-12         getTokeType();
   953                                  
   954 00001245 E89B00                   call getTokeType
   955                                  
   956                                  ;-13       }
   957                                  
   958                                  
   959                                  ;-14     }
   960                                  
   961                                  @@parse3:
   962                                  
   963                                  ;-15     if (TokeType == ALNUME) {
   964                                  
   965                                  @@parse2:
   966 00001248 A0[B501]                 mov al, [TokeType]
   967 0000124B 3C03                     cmp al, 3
   968 0000124D 0F851B00                 jne @@parse4
   969                                  
   970                                  ;-16       lookCode();// and OpCodePtr
   971                                  
   972 00001251 E86803                   call lookCode
   973                                  
   974                                  ;-17       if(CodeType) process();
   975                                  
   976 00001254 A0[B801]                 mov al, [CodeType]
   977 00001257 08C0                     or  al, al
   978 00001259 0F840600                 je @@parse5
   979 0000125D E80B16                   call process
   980                                  
   981                                  ;-18       else getVariable();
   982                                  
   983 00001260 E90300                   jmp @@parse6
   984                                  @@parse5:
   985 00001263 E81E02                   call getVariable
   986                                  
   987                                  ;-19       skipRest();
   988                                  
   989                                  @@parse6:
   990 00001266 E8BD04                   call skipRest
   991                                  
   992                                  ;-20     }
   993                                  
   994                                  
   995                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
   996                                  
   997 00001269 E92700                   jmp @@parse7
   998                                  @@parse4:
   999 0000126C A0[B501]                 mov al, [TokeType]
  1000 0000126F 3C03                     cmp al, 3
  1001 00001271 0F8E0C00                 jle @@parse8
  1002 00001275 68[A412]                 push parse_0
  1003 00001278 E8920E                   call error1
  1004 0000127B 83C402                   add  sp, 2
  1005                                  
  1006                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1007                                  
  1008 0000127E E91200                   jmp @@parse9
  1009                                  @@parse8:
  1010 00001281 A0[B501]                 mov al, [TokeType]
  1011 00001284 3C01                     cmp al, 1
  1012 00001286 0F850900                 jne @@parse10
  1013 0000128A 68[C212]                 push parse_1
  1014 0000128D E87D0E                   call error1
  1015 00001290 83C402                   add  sp, 2
  1016                                  
  1017                                  ;-23     printLine();
  1018                                  
  1019                                  @@parse10:
  1020                                  @@parse9:
  1021                                  @@parse7:
  1022 00001293 E80C0C                   call printLine
  1023                                  
  1024                                  ;-24   } while (DOS_NoBytes != 0 );
  1025                                  
  1026 00001296 A1[AD01]                 mov ax, [DOS_NoBytes]
  1027 00001299 83F800                   cmp ax, 0
  1028 0000129C 0F840300                 je  @@parse11
  1029 000012A0 E95CFF                   jmp @@parse1
  1030                                  @@parse11:
  1031                                  
  1032                                  ;-25 }
  1033                                  
  1034                                  
  1035                                  ;-26 // scan code .....................................
  1036                                  
  1037                                  
  1038                                  ;-27 int getTokeType() { char c;
  1039                                  
  1040 000012A3 C3                       ret
  1041                                  ; ENDP
  1042 000012A4 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1043 000012AD 696E73747275637469-
  1044 000012B6 6F6E20657870656374-
  1045 000012BF 656400             
  1046 000012C2 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1047 000012CB 616C6C6F7765642040-
  1048 000012D4 207374617274206F66-
  1049 000012DD 206C696E6500       
  1050                                  
  1051                                  getTokeType:  ; *** PROC ***
  1052                                  
  1053                                  ;-28   skipBlank();
  1054                                  
  1055                                  ;Function : getTokeType, Number of local variables: 1
  1056                                  ;   # type sign width line used address name   list of local variables
  1057                                  ;  200 var sign byte    27 NULL bp-2    c;
  1058 000012E3 C8020000                 ENTER  2,0
  1059 000012E7 E86705                   call skipBlank
  1060                                  
  1061                                  ;-29   c = *InputPtr;
  1062                                  
  1063 000012EA 8B1E[D800]               mov bx, [InputPtr]
  1064 000012EE 8A07                     mov al, [bx]
  1065 000012F0 B400                     mov ah, 0
  1066 000012F2 8846FE                   mov byte [bp-2], al
  1067                                  
  1068                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1069                                  
  1070 000012F5 8A46FE                   mov al, [bp-2]
  1071 000012F8 3C00                     cmp al, 0
  1072 000012FA 0F850C00                 jne @@getTokeType12
  1073 000012FE 66B800000000             mov eax, 0
  1074 00001304 A2[B501]                 mov byte [TokeType], al
  1075 00001307 E97500                   jmp @@retn
  1076                                  
  1077                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1078                                  
  1079                                  @@getTokeType12:
  1080 0000130A 8A46FE                   mov al, [bp-2]
  1081 0000130D 3C3B                     cmp al, 59
  1082 0000130F 0F850C00                 jne @@getTokeType13
  1083 00001313 66B800000000             mov eax, 0
  1084 00001319 A2[B501]                 mov byte [TokeType], al
  1085 0000131C E96000                   jmp @@retn
  1086                                  
  1087                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1088                                  
  1089                                  @@getTokeType13:
  1090 0000131F 8A46FE                   mov al, byte [bp-2]
  1091 00001322 B400                     mov ah, 0
  1092 00001324 50                       push ax
  1093 00001325 E8A81C                   call digit
  1094 00001328 83C402                   add  sp, 2
  1095 0000132B 08C0                     or  al, al
  1096 0000132D 0F841800                 je @@getTokeType14
  1097 00001331 8A46FE                   mov al, byte [bp-2]
  1098 00001334 B400                     mov ah, 0
  1099 00001336 50                       push ax
  1100 00001337 E81D06                   call getDigit
  1101 0000133A 83C402                   add  sp, 2
  1102 0000133D 66B801000000             mov eax, 1
  1103 00001343 A2[B501]                 mov byte [TokeType], al
  1104 00001346 E93600                   jmp @@retn
  1105                                  
  1106                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1107                                  
  1108                                  @@getTokeType14:
  1109 00001349 8A46FE                   mov al, byte [bp-2]
  1110 0000134C B400                     mov ah, 0
  1111 0000134E 50                       push ax
  1112 0000134F E82A05                   call letterE
  1113 00001352 83C402                   add  sp, 2
  1114 00001355 08C0                     or  al, al
  1115 00001357 0F841800                 je @@getTokeType15
  1116 0000135B 8A46FE                   mov al, byte [bp-2]
  1117 0000135E B400                     mov ah, 0
  1118 00001360 50                       push ax
  1119 00001361 E84A06                   call getName
  1120 00001364 83C402                   add  sp, 2
  1121 00001367 66B803000000             mov eax, 3
  1122 0000136D A2[B501]                 mov byte [TokeType], al
  1123 00001370 E90C00                   jmp @@retn
  1124                                  
  1125                                  ;-34   TokeType=NOALNUME; return;
  1126                                  
  1127                                  @@getTokeType15:
  1128 00001373 66B804000000             mov eax, 4
  1129 00001379 A2[B501]                 mov byte [TokeType], al
  1130 0000137C E90000                   jmp @@retn
  1131                                  
  1132                                  ;-35 }
  1133                                  
  1134                                  
  1135                                  ;-36 int storeLabel() {unsigned int i;
  1136                                  
  1137 0000137F C9                      @@retn: LEAVE
  1138 00001380 C3                       ret
  1139                                  ; ENDP
  1140                                  
  1141                                  storeLabel:  ; *** PROC ***
  1142                                  
  1143                                  ;-37   if(searchLabel()) error1("duplicate label");
  1144                                  
  1145                                  ;Function : storeLabel, Number of local variables: 1
  1146                                  ;   # type sign width line used address name   list of local variables
  1147                                  ;  200 var unsg word    36 NULL bp-2    i;
  1148 00001381 C8020000                 ENTER  2,0
  1149 00001385 E89C00                   call searchLabel
  1150 00001388 08C0                     or  al, al
  1151 0000138A 0F840900                 je @@storeLabel16
  1152 0000138E 68[EF13]                 push storeLabel_0
  1153 00001391 E8790D                   call error1
  1154 00001394 83C402                   add  sp, 2
  1155                                  
  1156                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1157                                  
  1158                                  @@storeLabel16:
  1159 00001397 8D06[1900]               lea  ax, [Symbol]
  1160 0000139B 50                       push ax
  1161 0000139C FF36[BC05]               push word [LabelNamePtr]
  1162 000013A0 E8F41B                   call strcpy
  1163 000013A3 83C404                   add  sp, 4
  1164 000013A6 A3[BC05]                 mov word [LabelNamePtr], ax
  1165                                  
  1166                                  ;-39   LabelNamePtr++;
  1167                                  
  1168 000013A9 FF06[BC05]               inc  word [LabelNamePtr]
  1169                                  
  1170                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  1171                                  
  1172 000013AD A1[BC05]                 mov ax, [LabelNamePtr]
  1173 000013B0 2D[D401]                 sub ax, LabelNames
  1174 000013B3 8946FE                   mov word [bp-2], ax
  1175                                  
  1176                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  1177                                  
  1178 000013B6 8B46FE                   mov ax, [bp-2]
  1179 000013B9 3DC903                   cmp ax, 969 ;unsigned : 0
  1180 000013BC 0F820900                 jb  @@storeLabel17
  1181 000013C0 68[FF13]                 push storeLabel_1
  1182 000013C3 E8010F                   call errorexit
  1183 000013C6 83C402                   add  sp, 2
  1184                                  
  1185                                  ;-42   LabelMaxIx++;
  1186                                  
  1187                                  @@storeLabel17:
  1188 000013C9 FF06[8606]               inc  word [LabelMaxIx]
  1189                                  
  1190                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  1191                                  
  1192 000013CD A1[8606]                 mov ax, [LabelMaxIx]
  1193 000013D0 83F864                   cmp ax, 100 ;unsigned : 1
  1194 000013D3 0F8C0900                 jl  @@storeLabel18
  1195 000013D7 68[1414]                 push storeLabel_2
  1196 000013DA E8EA0E                   call errorexit
  1197 000013DD 83C402                   add  sp, 2
  1198                                  
  1199                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  1200                                  
  1201                                  @@storeLabel18:
  1202 000013E0 A1[B001]                 mov ax, [PC]
  1203 000013E3 8B1E[8606]               mov bx, [LabelMaxIx]
  1204 000013E7 D1E3                     shl bx, 1
  1205 000013E9 8987[BE05]               mov [LabelAddr+bx], ax
  1206                                  
  1207                                  ;-45 }
  1208                                  
  1209                                  
  1210                                  ;-46 int searchLabel() {
  1211 000013ED C9                       LEAVE
  1212 000013EE C3                       ret
  1213                                  ; ENDP
  1214 000013EF 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  1215 000013F8 206C6162656C00     
  1216 000013FF 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  1217 00001408 6C6162656C206E616D-
  1218 00001411 657300             
  1219 00001414 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  1220 0000141D 6C6162656C7300     
  1221                                  
  1222                                  searchLabel:  ; *** PROC ***
  1223                                  
  1224                                  ;-47   int LIx; char *p; int j;
  1225                                  
  1226                                  
  1227                                  ;-48   p = &LabelNames;
  1228                                  
  1229                                  ;Function : searchLabel, Number of local variables: 3
  1230                                  ;   # type sign width line used address name   list of local variables
  1231                                  ;  200 var sign word    47 NULL bp-2    LIx
  1232                                  ;  201 ptr sign byte    47 NULL bp-4    p
  1233                                  ;  202 var sign word    47 NULL bp-6    j;
  1234 00001424 C8060000                 ENTER  6,0
  1235 00001428 B8[D401]                 mov ax, LabelNames
  1236 0000142B 8946FC                   mov word [bp-4], ax
  1237                                  
  1238                                  ;-49   LIx=1;
  1239                                  
  1240 0000142E 66B801000000             mov eax, 1
  1241 00001434 8946FE                   mov word [bp-2], ax
  1242                                  
  1243                                  ;-50   while (LIx <= LabelMaxIx) {
  1244                                  
  1245                                  @@searchLabel19:
  1246 00001437 8B46FE                   mov ax, [bp-2]
  1247 0000143A 3B06[8606]               cmp ax, [LabelMaxIx]
  1248 0000143E 0F8F3700                 jg  @@searchLabel20
  1249                                  
  1250                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  1251                                  
  1252 00001442 8D06[1900]               lea  ax, [Symbol]
  1253 00001446 50                       push ax
  1254 00001447 FF76FC                   push word [bp-4]
  1255 0000144A E8B61B                   call eqstr
  1256 0000144D 83C404                   add  sp, 4
  1257 00001450 08C0                     or  al, al
  1258 00001452 0F840600                 je @@searchLabel21
  1259 00001456 8B46FE                   mov ax, [bp-2]
  1260 00001459 E92600                   jmp @@retn
  1261                                  
  1262                                  ;-52     j=strlen(p);
  1263                                  
  1264                                  @@searchLabel21:
  1265 0000145C FF76FC                   push word [bp-4]
  1266 0000145F E80A1B                   call strlen
  1267 00001462 83C402                   add  sp, 2
  1268 00001465 8946FA                   mov word [bp-6], ax
  1269                                  
  1270                                  ;-53     p=p+j; p++; LIx++;
  1271                                  
  1272 00001468 8B46FC                   mov ax, [bp-4]
  1273 0000146B 0346FA                   add ax, [bp-6]
  1274 0000146E 8946FC                   mov word [bp-4], ax
  1275 00001471 FF46FC                   inc  word [bp-4]
  1276 00001474 FF46FE                   inc  word [bp-2]
  1277                                  
  1278                                  ;-54   }
  1279                                  
  1280                                  
  1281                                  ;-55   return 0;
  1282                                  
  1283 00001477 EBBE                     jmp @@searchLabel19
  1284                                  @@searchLabel20:
  1285 00001479 66B800000000             mov eax, 0
  1286 0000147F E90000                   jmp @@retn
  1287                                  
  1288                                  ;-56 }
  1289                                  
  1290                                  
  1291                                  ;-57 int getVariable() { char c;
  1292                                  
  1293 00001482 C9                      @@retn: LEAVE
  1294 00001483 C3                       ret
  1295                                  ; ENDP
  1296                                  
  1297                                  getVariable:  ; *** PROC ***
  1298                                  
  1299                                  ;-58   storeLabel();
  1300                                  
  1301                                  ;Function : getVariable, Number of local variables: 1
  1302                                  ;   # type sign width line used address name   list of local variables
  1303                                  ;  200 var sign byte    57 NULL bp-2    c;
  1304 00001484 C8020000                 ENTER  2,0
  1305 00001488 E8F6FE                   call storeLabel
  1306                                  
  1307                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  1308                                  
  1309 0000148B E855FE                   call getTokeType
  1310 0000148E A0[B501]                 mov al, [TokeType]
  1311 00001491 3C03                     cmp al, 3
  1312 00001493 0F85CC00                 jne @@getVariable22
  1313                                  
  1314                                  ;-60     lookCode();
  1315                                  
  1316 00001497 E82201                   call lookCode
  1317                                  
  1318                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  1319                                  
  1320 0000149A A0[B801]                 mov al, [CodeType]
  1321 0000149D 3CC8                     cmp al, 200
  1322 0000149F 0F8D0900                 jge @@getVariable23
  1323 000014A3 68[6E15]                 push getVariable_0
  1324 000014A6 E81E0E                   call errorexit
  1325 000014A9 83C402                   add  sp, 2
  1326                                  
  1327                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1328                                  
  1329                                  @@getVariable23:
  1330 000014AC A0[B801]                 mov al, [CodeType]
  1331 000014AF 3CCF                     cmp al, 207
  1332 000014B1 0F8E0900                 jle @@getVariable24
  1333 000014B5 68[8615]                 push getVariable_1
  1334 000014B8 E80C0E                   call errorexit
  1335 000014BB 83C402                   add  sp, 2
  1336                                  
  1337                                  ;-63     if (CodeType== 200) {// DB
  1338                                  
  1339                                  @@getVariable24:
  1340 000014BE A0[B801]                 mov al, [CodeType]
  1341 000014C1 3CC8                     cmp al, 200
  1342 000014C3 0F856A00                 jne @@getVariable25
  1343                                  
  1344                                  ;-64       do { getTokeType();
  1345                                  
  1346                                  @@getVariable26:
  1347 000014C7 E819FE                   call getTokeType
  1348                                  
  1349                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  1350                                  
  1351 000014CA A0[B501]                 mov al, [TokeType]
  1352 000014CD 3C01                     cmp al, 1
  1353 000014CF 0F850D00                 jne @@getVariable27
  1354 000014D3 FF36[5700]               push word [SymbolInt]
  1355 000014D7 E8EA11                   call genCode8
  1356 000014DA 83C402                   add  sp, 2
  1357                                  
  1358                                  ;-66         else {
  1359                                  
  1360 000014DD E94100                   jmp @@getVariable28
  1361                                  @@getVariable27:
  1362                                  
  1363                                  ;-67           skipBlank();
  1364                                  
  1365 000014E0 E86E03                   call skipBlank
  1366                                  
  1367                                  ;-68           if (isToken('"')) {
  1368                                  
  1369 000014E3 6A22                     push 34
  1370 000014E5 E8D101                   call isToken
  1371 000014E8 83C402                   add  sp, 2
  1372 000014EB 08C0                     or  al, al
  1373 000014ED 0F843000                 je @@getVariable29
  1374                                  
  1375                                  ;-69             do { c= *InputPtr;
  1376                                  
  1377                                  @@getVariable30:
  1378 000014F1 8B1E[D800]               mov bx, [InputPtr]
  1379 000014F5 8A07                     mov al, [bx]
  1380 000014F7 B400                     mov ah, 0
  1381 000014F9 8846FE                   mov byte [bp-2], al
  1382                                  
  1383                                  ;-70               genCode8(c);
  1384                                  
  1385 000014FC 8A46FE                   mov al, byte [bp-2]
  1386 000014FF B400                     mov ah, 0
  1387 00001501 50                       push ax
  1388 00001502 E8BF11                   call genCode8
  1389 00001505 83C402                   add  sp, 2
  1390                                  
  1391                                  ;-71               InputPtr++;
  1392                                  
  1393 00001508 FF06[D800]               inc  word [InputPtr]
  1394                                  
  1395                                  ;-72             } while (*InputPtr != '"' );
  1396                                  
  1397 0000150C 8B1E[D800]               mov bx, [InputPtr]
  1398 00001510 8A07                     mov al, [bx]
  1399 00001512 B400                     mov ah, 0
  1400 00001514 83F822                   cmp ax, 34
  1401 00001517 0F840200                 je  @@getVariable31
  1402 0000151B EBD4                     jmp @@getVariable30
  1403                                  @@getVariable31:
  1404                                  
  1405                                  ;-73             InputPtr++;
  1406                                  
  1407 0000151D FF06[D800]               inc  word [InputPtr]
  1408                                  
  1409                                  ;-74           }
  1410                                  
  1411                                  
  1412                                  ;-75         }
  1413                                  
  1414                                  @@getVariable29:
  1415                                  
  1416                                  ;-76       } while (isToken(','));
  1417                                  
  1418                                  @@getVariable28:
  1419 00001521 6A2C                     push 44
  1420 00001523 E89301                   call isToken
  1421 00001526 83C402                   add  sp, 2
  1422 00001529 08C0                     or  al, al
  1423 0000152B 0F840200                 je @@getVariable32
  1424 0000152F EB96                     jmp @@getVariable26
  1425                                  @@getVariable32:
  1426                                  
  1427                                  ;-77     }
  1428                                  
  1429                                  
  1430                                  ;-78     if (CodeType== 201) {// DW
  1431                                  
  1432                                  @@getVariable25:
  1433 00001531 A0[B801]                 mov al, [CodeType]
  1434 00001534 3CC9                     cmp al, 201
  1435 00001536 0F852600                 jne @@getVariable33
  1436                                  
  1437                                  ;-79       do { getTokeType();
  1438                                  
  1439                                  @@getVariable34:
  1440 0000153A E8A6FD                   call getTokeType
  1441                                  
  1442                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  1443                                  
  1444 0000153D A0[B501]                 mov al, [TokeType]
  1445 00001540 3C01                     cmp al, 1
  1446 00001542 0F850A00                 jne @@getVariable35
  1447 00001546 FF36[5700]               push word [SymbolInt]
  1448 0000154A E8CD11                   call genCode16
  1449 0000154D 83C402                   add  sp, 2
  1450                                  
  1451                                  ;-81       } while (isToken(','));
  1452                                  
  1453                                  @@getVariable35:
  1454 00001550 6A2C                     push 44
  1455 00001552 E86401                   call isToken
  1456 00001555 83C402                   add  sp, 2
  1457 00001558 08C0                     or  al, al
  1458 0000155A 0F840200                 je @@getVariable36
  1459 0000155E EBDA                     jmp @@getVariable34
  1460                                  @@getVariable36:
  1461                                  
  1462                                  ;-82     }
  1463                                  
  1464                                  
  1465                                  ;-83   }
  1466                                  
  1467                                  @@getVariable33:
  1468                                  
  1469                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  1470                                  
  1471 00001560 E90900                   jmp @@getVariable37
  1472                                  @@getVariable22:
  1473 00001563 68[9E15]                 push getVariable_2
  1474 00001566 E85E0D                   call errorexit
  1475 00001569 83C402                   add  sp, 2
  1476                                  
  1477                                  ;-85 }
  1478                                  
  1479                                  @@getVariable37:
  1480                                  
  1481                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  1482 0000156C C9                       LEAVE
  1483 0000156D C3                       ret
  1484                                  ; ENDP
  1485 0000156E 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  1486 00001577 422C572C4420657870-
  1487 00001580 656374656400       
  1488 00001586 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  1489 0000158F 422C572C4420657870-
  1490 00001598 656374656400       
  1491 0000159E 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  1492 000015A7 6F7220524553422C57-
  1493 000015B0 2C4420657870656374-
  1494 000015B9 656400             
  1495                                  
  1496                                  lookCode:  ; *** PROC ***
  1497                                  
  1498                                  ;-87   CodeType=0;
  1499                                  
  1500 000015BC 66B800000000             mov eax, 0
  1501 000015C2 A2[B801]                 mov byte [CodeType], al
  1502                                  
  1503                                  ;-88   OpCodePtr= &I_START;
  1504                                  
  1505 000015C5 B8[600E]                 mov ax, I_START
  1506 000015C8 A3[D101]                 mov word [OpCodePtr], ax
  1507                                  
  1508                                  ;-89   OpCodePtr++;
  1509                                  
  1510 000015CB FF06[D101]               inc  word [OpCodePtr]
  1511                                  
  1512                                  ;-90   do  {
  1513                                  
  1514                                  @@lookCode38:
  1515                                  
  1516                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  1517                                  
  1518 000015CF FF36[D101]               push word [OpCodePtr]
  1519 000015D3 8D06[3800]               lea  ax, [SymbolUpper]
  1520 000015D7 50                       push ax
  1521 000015D8 E8281A                   call eqstr
  1522 000015DB 83C404                   add  sp, 4
  1523 000015DE 08C0                     or  al, al
  1524 000015E0 0F842700                 je @@lookCode39
  1525                                  
  1526                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  1527                                  
  1528                                  @@lookCode40:
  1529 000015E4 8B1E[D101]               mov bx, [OpCodePtr]
  1530 000015E8 8A07                     mov al, [bx]
  1531 000015EA B400                     mov ah, 0
  1532 000015EC 83F800                   cmp ax, 0
  1533 000015EF 0F840600                 je  @@lookCode41
  1534 000015F3 FF06[D101]               inc  word [OpCodePtr]
  1535                                  
  1536                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  1537                                  
  1538 000015F7 EBEB                     jmp @@lookCode40
  1539                                  @@lookCode41:
  1540 000015F9 FF06[D101]               inc  word [OpCodePtr]
  1541 000015FD 8B1E[D101]               mov bx, [OpCodePtr]
  1542 00001601 8A07                     mov al, [bx]
  1543 00001603 B400                     mov ah, 0
  1544 00001605 A2[B801]                 mov byte [CodeType], al
  1545                                  
  1546                                  ;-94       return;
  1547                                  
  1548 00001608 E92A00                   jmp @@retn
  1549                                  
  1550                                  ;-95     }
  1551                                  
  1552                                  
  1553                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  1554                                  
  1555                                  @@lookCode39:
  1556                                  @@lookCode42:
  1557 0000160B 8B1E[D101]               mov bx, [OpCodePtr]
  1558 0000160F 8A07                     mov al, [bx]
  1559 00001611 B400                     mov ah, 0
  1560 00001613 3DF100                   cmp ax, 241
  1561 00001616 0F840600                 je  @@lookCode43
  1562 0000161A FF06[D101]               inc  word [OpCodePtr]
  1563                                  
  1564                                  ;-97   OpCodePtr++;
  1565                                  
  1566 0000161E EBEB                     jmp @@lookCode42
  1567                                  @@lookCode43:
  1568 00001620 FF06[D101]               inc  word [OpCodePtr]
  1569                                  
  1570                                  ;-98   } while(*OpCodePtr!=0);
  1571                                  
  1572 00001624 8B1E[D101]               mov bx, [OpCodePtr]
  1573 00001628 8A07                     mov al, [bx]
  1574 0000162A B400                     mov ah, 0
  1575 0000162C 83F800                   cmp ax, 0
  1576 0000162F 0F840200                 je  @@lookCode44
  1577 00001633 EB9A                     jmp @@lookCode38
  1578                                  @@lookCode44:
  1579                                  
  1580                                  ;-99 }
  1581                                  
  1582                                  
  1583                                  ;-100 
  1584                                  
  1585                                  
  1586                                  ;-101 int getCodeSize() {
  1587                                  
  1588                                  @@retn:
  1589 00001635 C3                       ret
  1590                                  ; ENDP
  1591                                  
  1592                                  getCodeSize:  ; *** PROC ***
  1593                                  
  1594                                  ;-102   if (TokeType ==ALNUME) {
  1595                                  
  1596 00001636 A0[B501]                 mov al, [TokeType]
  1597 00001639 3C03                     cmp al, 3
  1598 0000163B 0F856000                 jne @@getCodeSize45
  1599                                  
  1600                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1601                                  
  1602 0000163F 68[A916]                 push getCodeSize_0
  1603 00001642 8D06[3800]               lea  ax, [SymbolUpper]
  1604 00001646 50                       push ax
  1605 00001647 E8B919                   call eqstr
  1606 0000164A 83C404                   add  sp, 4
  1607 0000164D 08C0                     or  al, al
  1608 0000164F 0F840C00                 je @@getCodeSize46
  1609 00001653 E88DFC                   call getTokeType
  1610 00001656 66B801000000             mov eax, 1
  1611 0000165C E94900                   jmp @@retn
  1612                                  
  1613                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1614                                  
  1615                                  @@getCodeSize46:
  1616 0000165F 68[AE16]                 push getCodeSize_1
  1617 00001662 8D06[3800]               lea  ax, [SymbolUpper]
  1618 00001666 50                       push ax
  1619 00001667 E89919                   call eqstr
  1620 0000166A 83C404                   add  sp, 4
  1621 0000166D 08C0                     or  al, al
  1622 0000166F 0F840C00                 je @@getCodeSize47
  1623 00001673 E86DFC                   call getTokeType
  1624 00001676 66B802000000             mov eax, 2
  1625 0000167C E92900                   jmp @@retn
  1626                                  
  1627                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1628                                  
  1629                                  @@getCodeSize47:
  1630 0000167F 68[B316]                 push getCodeSize_2
  1631 00001682 8D06[3800]               lea  ax, [SymbolUpper]
  1632 00001686 50                       push ax
  1633 00001687 E87919                   call eqstr
  1634 0000168A 83C404                   add  sp, 4
  1635 0000168D 08C0                     or  al, al
  1636 0000168F 0F840C00                 je @@getCodeSize48
  1637 00001693 E84DFC                   call getTokeType
  1638 00001696 66B803000000             mov eax, 3
  1639 0000169C E90900                   jmp @@retn
  1640                                  
  1641                                  ;-106   } return 0;
  1642                                  
  1643                                  @@getCodeSize48:
  1644                                  @@getCodeSize45:
  1645 0000169F 66B800000000             mov eax, 0
  1646 000016A5 E90000                   jmp @@retn
  1647                                  
  1648                                  ;-107 }
  1649                                  
  1650                                  
  1651                                  ;-108 int isToken(char c) {
  1652                                  
  1653                                  @@retn:
  1654 000016A8 C3                       ret
  1655                                  ; ENDP
  1656 000016A9 4259544500              getCodeSize_0 db "BYTE",0
  1657 000016AE 574F524400              getCodeSize_1 db "WORD",0
  1658 000016B3 44574F524400            getCodeSize_2 db "DWORD",0
  1659                                  
  1660                                  isToken:  ; *** PROC ***
  1661                                  
  1662                                  ;-109   skipBlank();
  1663                                  
  1664                                  ;Function : isToken, Number of local variables: 1
  1665                                  ;   # type sign width line used address name   list of local variables
  1666                                  ;  200 var sign byte   108 NULL bp+4    c;
  1667 000016B9 C8000000                 ENTER  0,0
  1668 000016BD E89101                   call skipBlank
  1669                                  
  1670                                  ;-110   if (*InputPtr == c) {
  1671                                  
  1672 000016C0 8B1E[D800]               mov bx, [InputPtr]
  1673 000016C4 8A07                     mov al, [bx]
  1674 000016C6 B400                     mov ah, 0
  1675 000016C8 3A4604                   cmp al, [bp+4]
  1676 000016CB 0F850D00                 jne @@isToken49
  1677                                  
  1678                                  ;-111     InputPtr++; return 1;} return 0;
  1679                                  
  1680 000016CF FF06[D800]               inc  word [InputPtr]
  1681 000016D3 66B801000000             mov eax, 1
  1682 000016D9 E90900                   jmp @@retn
  1683                                  @@isToken49:
  1684 000016DC 66B800000000             mov eax, 0
  1685 000016E2 E90000                   jmp @@retn
  1686                                  
  1687                                  ;-112 }
  1688                                  
  1689                                  
  1690                                  ;-113 int need(char c) {
  1691                                  
  1692 000016E5 C9                      @@retn: LEAVE
  1693 000016E6 C3                       ret
  1694                                  ; ENDP
  1695                                  
  1696                                  need:  ; *** PROC ***
  1697                                  
  1698                                  ;-114   if (isToken(c)) {
  1699                                  
  1700                                  ;Function : need, Number of local variables: 1
  1701                                  ;   # type sign width line used address name   list of local variables
  1702                                  ;  200 var sign byte   113 NULL bp+4    c;
  1703 000016E7 C8000000                 ENTER  0,0
  1704 000016EB 8A4604                   mov al, byte [bp+4]
  1705 000016EE B400                     mov ah, 0
  1706 000016F0 50                       push ax
  1707 000016F1 E8C5FF                   call isToken
  1708 000016F4 83C402                   add  sp, 2
  1709 000016F7 08C0                     or  al, al
  1710 000016F9 0F840600                 je @@need50
  1711                                  
  1712                                  ;-115       getTokeType();
  1713                                  
  1714 000016FD E8E3FB                   call getTokeType
  1715                                  
  1716                                  ;-116       return;
  1717                                  
  1718 00001700 E91800                   jmp @@retn
  1719                                  
  1720                                  ;-117       }
  1721                                  
  1722                                  
  1723                                  ;-118   error1();
  1724                                  
  1725                                  @@need50:
  1726 00001703 E8070A                   call error1
  1727                                  
  1728                                  ;-119   prs(". need: ");
  1729                                  
  1730 00001706 68[1D17]                 push need_0
  1731 00001709 E8A408                   call prs
  1732 0000170C 83C402                   add  sp, 2
  1733                                  
  1734                                  ;-120   prc(c);
  1735                                  
  1736 0000170F 8A4604                   mov al, byte [bp+4]
  1737 00001712 B400                     mov ah, 0
  1738 00001714 50                       push ax
  1739 00001715 E83708                   call prc
  1740 00001718 83C402                   add  sp, 2
  1741                                  
  1742                                  ;-121 }
  1743                                  
  1744                                  
  1745                                  ;-122 
  1746                                  
  1747                                  
  1748                                  ;-123 int skipRest() {
  1749                                  
  1750 0000171B C9                      @@retn: LEAVE
  1751 0000171C C3                       ret
  1752                                  ; ENDP
  1753 0000171D 2E206E6565643A2000      need_0 db ". need: ",0
  1754                                  
  1755                                  skipRest:  ; *** PROC ***
  1756                                  
  1757                                  ;-124   getTokeType(); 
  1758                                  
  1759 00001726 E8BAFB                   call getTokeType
  1760                                  
  1761                                  ;-125   if(TokeType)error1("extra char ignored");
  1762                                  
  1763 00001729 A0[B501]                 mov al, [TokeType]
  1764 0000172C 08C0                     or  al, al
  1765 0000172E 0F840900                 je @@skipRest51
  1766 00001732 68[3C17]                 push skipRest_0
  1767 00001735 E8D509                   call error1
  1768 00001738 83C402                   add  sp, 2
  1769                                  
  1770                                  ;-126 }
  1771                                  
  1772                                  @@skipRest51:
  1773 0000173B C3                       ret
  1774                                  ; ENDP
  1775 0000173C 657874726120636861-     skipRest_0 db "extra char ignored",0
  1776 00001745 722069676E6F726564-
  1777 0000174E 00                 
  1778                                  ;Back to main program: AS.C
  1779                                  
  1780                                  ;-6 #include "HELPER.C"
  1781                                  
  1782                                  ;Use include file: HELPER.C
  1783                                  
  1784                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  1785                                  
  1786                                  
  1787                                  getLine:  ; *** PROC ***
  1788                                  
  1789                                  ;-2   unsigned int i;
  1790                                  
  1791                                  
  1792                                  ;-3   InputPtr= &InputBuf;
  1793                                  
  1794                                  ;Function : getLine, Number of local variables: 1
  1795                                  ;   # type sign width line used address name   list of local variables
  1796                                  ;  200 var unsg word     2 NULL bp-2    i;
  1797 0000174F C8020000                 ENTER  2,0
  1798 00001753 B8[5900]                 mov ax, InputBuf
  1799 00001756 A3[D800]                 mov word [InputPtr], ax
  1800                                  
  1801                                  ;-4   *InputPtr=0;//if last line is empty
  1802                                  
  1803 00001759 66B800000000             mov eax, 0
  1804 0000175F 8B1E[D800]               mov  bx, [InputPtr]
  1805 00001763 8807                     mov  [bx], al
  1806                                  
  1807                                  ;-5   do {
  1808                                  
  1809                                  @@getLine52:
  1810                                  
  1811                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1812                                  
  1813 00001765 6A01                     push 1
  1814 00001767 FF36[A301]               push word [asm_fd]
  1815 0000176B 8D06[AF01]               lea  ax, [DOS_ByteRead]
  1816 0000176F 50                       push ax
  1817 00001770 E82B19                   call readRL
  1818 00001773 83C406                   add  sp, 6
  1819 00001776 A3[AD01]                 mov word [DOS_NoBytes], ax
  1820                                  
  1821                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  1822                                  
  1823 00001779 A1[A901]                 mov ax, [DOS_ERR]
  1824 0000177C 08C0                     or  al, al
  1825 0000177E 0F840900                 je @@getLine53
  1826 00001782 68[E717]                 push getLine_0
  1827 00001785 E83F0B                   call errorexit
  1828 00001788 83C402                   add  sp, 2
  1829                                  
  1830                                  ;-8     if (DOS_NoBytes == 0) return;
  1831                                  
  1832                                  @@getLine53:
  1833 0000178B A1[AD01]                 mov ax, [DOS_NoBytes]
  1834 0000178E 83F800                   cmp ax, 0
  1835 00001791 0F850300                 jne @@getLine54
  1836 00001795 E94D00                   jmp @@retn
  1837                                  
  1838                                  ;-9     *InputPtr = DOS_ByteRead;
  1839                                  
  1840                                  @@getLine54:
  1841 00001798 A0[AF01]                 mov al, [DOS_ByteRead]
  1842 0000179B 8B1E[D800]               mov  bx, [InputPtr]
  1843 0000179F 8807                     mov  [bx], al
  1844                                  
  1845                                  ;-10     InputPtr++;
  1846                                  
  1847 000017A1 FF06[D800]               inc  word [InputPtr]
  1848                                  
  1849                                  ;-11     i = InputPtr - &InputBuf;
  1850                                  
  1851 000017A5 A1[D800]                 mov ax, [InputPtr]
  1852 000017A8 2D[5900]                 sub ax, InputBuf
  1853 000017AB 8946FE                   mov word [bp-2], ax
  1854                                  
  1855                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  1856                                  
  1857 000017AE 8B46FE                   mov ax, [bp-2]
  1858 000017B1 83F87F                   cmp ax, 127 ;unsigned : 0
  1859 000017B4 0F820900                 jb  @@getLine55
  1860 000017B8 68[F617]                 push getLine_1
  1861 000017BB E8090B                   call errorexit
  1862 000017BE 83C402                   add  sp, 2
  1863                                  
  1864                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  1865                                  
  1866                                  @@getLine55:
  1867 000017C1 A0[AF01]                 mov al, byte [DOS_ByteRead]
  1868 000017C4 B400                     mov ah, 0
  1869 000017C6 50                       push ax
  1870 000017C7 E84000                   call ifEOL
  1871 000017CA 83C402                   add  sp, 2
  1872 000017CD 3C00                     cmp al, 0
  1873 000017CF 0F850200                 jne @@getLine56
  1874 000017D3 EB90                     jmp @@getLine52
  1875                                  @@getLine56:
  1876                                  
  1877                                  ;-14   InputPtr--;
  1878                                  
  1879 000017D5 FF0E[D800]               dec  word [InputPtr]
  1880                                  
  1881                                  ;-15   *InputPtr=0;
  1882                                  
  1883 000017D9 66B800000000             mov eax, 0
  1884 000017DF 8B1E[D800]               mov  bx, [InputPtr]
  1885 000017E3 8807                     mov  [bx], al
  1886                                  
  1887                                  ;-16 }
  1888                                  
  1889                                  
  1890                                  ;-17 int ifEOL(char c) {
  1891                                  
  1892 000017E5 C9                      @@retn: LEAVE
  1893 000017E6 C3                       ret
  1894                                  ; ENDP
  1895 000017E7 52656164696E672053-     getLine_0 db "Reading Source",0
  1896 000017F0 6F7572636500       
  1897 000017F6 696E707574206C696E-     getLine_1 db "input line too long",0
  1898 000017FF 6520746F6F206C6F6E-
  1899 00001808 6700               
  1900                                  
  1901                                  ifEOL:  ; *** PROC ***
  1902                                  
  1903                                  ;-18   if (c == 10) return 1;
  1904                                  
  1905                                  ;Function : ifEOL, Number of local variables: 1
  1906                                  ;   # type sign width line used address name   list of local variables
  1907                                  ;  200 var sign byte    17 NULL bp+4    c;
  1908 0000180A C8000000                 ENTER  0,0
  1909 0000180E 8A4604                   mov al, [bp+4]
  1910 00001811 3C0A                     cmp al, 10
  1911 00001813 0F850900                 jne @@ifEOL57
  1912 00001817 66B801000000             mov eax, 1
  1913 0000181D E92F00                   jmp @@retn
  1914                                  
  1915                                  ;-19   if (c == 13) {
  1916                                  
  1917                                  @@ifEOL57:
  1918 00001820 8A4604                   mov al, [bp+4]
  1919 00001823 3C0D                     cmp al, 13
  1920 00001825 0F851D00                 jne @@ifEOL58
  1921                                  
  1922                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1923                                  
  1924 00001829 6A01                     push 1
  1925 0000182B FF36[A301]               push word [asm_fd]
  1926 0000182F 8D06[AF01]               lea  ax, [DOS_ByteRead]
  1927 00001833 50                       push ax
  1928 00001834 E86718                   call readRL
  1929 00001837 83C406                   add  sp, 6
  1930 0000183A A3[AD01]                 mov word [DOS_NoBytes], ax
  1931                                  
  1932                                  ;-21     return 1;}
  1933                                  
  1934 0000183D 66B801000000             mov eax, 1
  1935 00001843 E90900                   jmp @@retn
  1936                                  
  1937                                  ;-22   return 0;
  1938                                  
  1939                                  @@ifEOL58:
  1940 00001846 66B800000000             mov eax, 0
  1941 0000184C E90000                   jmp @@retn
  1942                                  
  1943                                  ;-23 }
  1944                                  
  1945                                  
  1946                                  ;-24 int skipBlank() {
  1947                                  
  1948 0000184F C9                      @@retn: LEAVE
  1949 00001850 C3                       ret
  1950                                  ; ENDP
  1951                                  
  1952                                  skipBlank:  ; *** PROC ***
  1953                                  
  1954                                  ;-25   skipblank1:
  1955                                  
  1956                                  @@skipblank1:
  1957                                  
  1958                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  1959                                  
  1960 00001851 8B1E[D800]               mov bx, [InputPtr]
  1961 00001855 8A07                     mov al, [bx]
  1962 00001857 B400                     mov ah, 0
  1963 00001859 83F820                   cmp ax, 32
  1964 0000185C 0F850600                 jne @@skipBlank59
  1965 00001860 FF06[D800]               inc  word [InputPtr]
  1966 00001864 EBEB                     jmp @@skipblank1
  1967                                  
  1968                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  1969                                  
  1970                                  @@skipBlank59:
  1971 00001866 8B1E[D800]               mov bx, [InputPtr]
  1972 0000186A 8A07                     mov al, [bx]
  1973 0000186C B400                     mov ah, 0
  1974 0000186E 83F809                   cmp ax, 9
  1975 00001871 0F850600                 jne @@skipBlank60
  1976 00001875 FF06[D800]               inc  word [InputPtr]
  1977 00001879 EBD6                     jmp @@skipblank1
  1978                                  
  1979                                  ;-28 }
  1980                                  
  1981                                  @@skipBlank60:
  1982                                  
  1983                                  ;-29 int letterE(char c) {
  1984                                  
  1985 0000187B C3                       ret
  1986                                  ; ENDP
  1987                                  
  1988                                  letterE:  ; *** PROC ***
  1989                                  
  1990                                  ;-30   if (c=='_') return 1;
  1991                                  
  1992                                  ;Function : letterE, Number of local variables: 1
  1993                                  ;   # type sign width line used address name   list of local variables
  1994                                  ;  200 var sign byte    29 NULL bp+4    c;
  1995 0000187C C8000000                 ENTER  0,0
  1996 00001880 8A4604                   mov al, [bp+4]
  1997 00001883 3C5F                     cmp al, 95
  1998 00001885 0F850900                 jne @@letterE61
  1999 00001889 66B801000000             mov eax, 1
  2000 0000188F E97E00                   jmp @@retn
  2001                                  
  2002                                  ;-31   if (c=='.') return 1;
  2003                                  
  2004                                  @@letterE61:
  2005 00001892 8A4604                   mov al, [bp+4]
  2006 00001895 3C2E                     cmp al, 46
  2007 00001897 0F850900                 jne @@letterE62
  2008 0000189B 66B801000000             mov eax, 1
  2009 000018A1 E96C00                   jmp @@retn
  2010                                  
  2011                                  ;-32   if (c=='?') return 1;
  2012                                  
  2013                                  @@letterE62:
  2014 000018A4 8A4604                   mov al, [bp+4]
  2015 000018A7 3C3F                     cmp al, 63
  2016 000018A9 0F850900                 jne @@letterE63
  2017 000018AD 66B801000000             mov eax, 1
  2018 000018B3 E95A00                   jmp @@retn
  2019                                  
  2020                                  ;-33   if (c=='$') return 1;
  2021                                  
  2022                                  @@letterE63:
  2023 000018B6 8A4604                   mov al, [bp+4]
  2024 000018B9 3C24                     cmp al, 36
  2025 000018BB 0F850900                 jne @@letterE64
  2026 000018BF 66B801000000             mov eax, 1
  2027 000018C5 E94800                   jmp @@retn
  2028                                  
  2029                                  ;-34   if (c> 'z') return 0;
  2030                                  
  2031                                  @@letterE64:
  2032 000018C8 8A4604                   mov al, [bp+4]
  2033 000018CB 3C7A                     cmp al, 122
  2034 000018CD 0F8E0900                 jle @@letterE65
  2035 000018D1 66B800000000             mov eax, 0
  2036 000018D7 E93600                   jmp @@retn
  2037                                  
  2038                                  ;-35   if (c< '@') return 0; // at included
  2039                                  
  2040                                  @@letterE65:
  2041 000018DA 8A4604                   mov al, [bp+4]
  2042 000018DD 3C40                     cmp al, 64
  2043 000018DF 0F8D0900                 jge @@letterE66
  2044 000018E3 66B800000000             mov eax, 0
  2045 000018E9 E92400                   jmp @@retn
  2046                                  
  2047                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2048                                  
  2049                                  @@letterE66:
  2050 000018EC 8A4604                   mov al, [bp+4]
  2051 000018EF 3C5A                     cmp al, 90
  2052 000018F1 0F8E1200                 jle @@letterE67
  2053 000018F5 8A4604                   mov al, [bp+4]
  2054 000018F8 3C61                     cmp al, 97
  2055 000018FA 0F8D0900                 jge @@letterE68
  2056 000018FE 66B800000000             mov eax, 0
  2057 00001904 E90900                   jmp @@retn
  2058                                  @@letterE68:
  2059                                  
  2060                                  ;-37   return 1;
  2061                                  
  2062                                  @@letterE67:
  2063 00001907 66B801000000             mov eax, 1
  2064 0000190D E90000                   jmp @@retn
  2065                                  
  2066                                  ;-38 }
  2067                                  
  2068                                  
  2069                                  ;-39 int alnumE(char c) {
  2070                                  
  2071 00001910 C9                      @@retn: LEAVE
  2072 00001911 C3                       ret
  2073                                  ; ENDP
  2074                                  
  2075                                  alnumE:  ; *** PROC ***
  2076                                  
  2077                                  ;-40   if (digit(c)) return 1;
  2078                                  
  2079                                  ;Function : alnumE, Number of local variables: 1
  2080                                  ;   # type sign width line used address name   list of local variables
  2081                                  ;  200 var sign byte    39 NULL bp+4    c;
  2082 00001912 C8000000                 ENTER  0,0
  2083 00001916 8A4604                   mov al, byte [bp+4]
  2084 00001919 B400                     mov ah, 0
  2085 0000191B 50                       push ax
  2086 0000191C E8B116                   call digit
  2087 0000191F 83C402                   add  sp, 2
  2088 00001922 08C0                     or  al, al
  2089 00001924 0F840900                 je @@alnumE69
  2090 00001928 66B801000000             mov eax, 1
  2091 0000192E E92400                   jmp @@retn
  2092                                  
  2093                                  ;-41   if (letterE(c)) return 1;
  2094                                  
  2095                                  @@alnumE69:
  2096 00001931 8A4604                   mov al, byte [bp+4]
  2097 00001934 B400                     mov ah, 0
  2098 00001936 50                       push ax
  2099 00001937 E842FF                   call letterE
  2100 0000193A 83C402                   add  sp, 2
  2101 0000193D 08C0                     or  al, al
  2102 0000193F 0F840900                 je @@alnumE70
  2103 00001943 66B801000000             mov eax, 1
  2104 00001949 E90900                   jmp @@retn
  2105                                  
  2106                                  ;-42   return 0;
  2107                                  
  2108                                  @@alnumE70:
  2109 0000194C 66B800000000             mov eax, 0
  2110 00001952 E90000                   jmp @@retn
  2111                                  
  2112                                  ;-43 }
  2113                                  
  2114                                  
  2115                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2116                                  
  2117 00001955 C9                      @@retn: LEAVE
  2118 00001956 C3                       ret
  2119                                  ; ENDP
  2120                                  
  2121                                  getDigit:  ; *** PROC ***
  2122                                  
  2123                                  ;-45   unsigned int CastInt;
  2124                                  
  2125                                  
  2126                                  ;-46   SymbolInt=0;
  2127                                  
  2128                                  ;Function : getDigit, Number of local variables: 2
  2129                                  ;   # type sign width line used address name   list of local variables
  2130                                  ;  200 var unsg byte    44 NULL bp+4    c
  2131                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  2132 00001957 C8020000                 ENTER  2,0
  2133 0000195B 66B800000000             mov eax, 0
  2134 00001961 A3[5700]                 mov word [SymbolInt], ax
  2135                                  
  2136                                  ;-47   do {
  2137                                  
  2138                                  @@getDigit71:
  2139                                  
  2140                                  ;-48     c-='0';
  2141                                  
  2142 00001964 806E0430                 sub  byte [bp+4], 48
  2143                                  
  2144                                  ;-49     SymbolInt=SymbolInt*10;
  2145                                  
  2146 00001968 A1[5700]                 mov ax, [SymbolInt]
  2147 0000196B 66BB0A000000             mov ebx, 10
  2148 00001971 66F7E3                   mul ebx
  2149 00001974 A3[5700]                 mov word [SymbolInt], ax
  2150                                  
  2151                                  ;-50     ax=0; CastInt=c; //cast b2w
  2152                                  
  2153 00001977 B80000                   mov  ax, 0
  2154 0000197A 8A4604                   mov al, [bp+4]
  2155 0000197D 8946FE                   mov word [bp-2], ax
  2156                                  
  2157                                  ;-51     SymbolInt=SymbolInt+CastInt;
  2158                                  
  2159 00001980 A1[5700]                 mov ax, [SymbolInt]
  2160 00001983 0346FE                   add ax, [bp-2]
  2161 00001986 A3[5700]                 mov word [SymbolInt], ax
  2162                                  
  2163                                  ;-52     InputPtr++;
  2164                                  
  2165 00001989 FF06[D800]               inc  word [InputPtr]
  2166                                  
  2167                                  ;-53     c = *InputPtr;
  2168                                  
  2169 0000198D 8B1E[D800]               mov bx, [InputPtr]
  2170 00001991 8A07                     mov al, [bx]
  2171 00001993 B400                     mov ah, 0
  2172 00001995 884604                   mov byte [bp+4], al
  2173                                  
  2174                                  ;-54   } while(digit(c));
  2175                                  
  2176 00001998 8A4604                   mov al, byte [bp+4]
  2177 0000199B B400                     mov ah, 0
  2178 0000199D 50                       push ax
  2179 0000199E E82F16                   call digit
  2180 000019A1 83C402                   add  sp, 2
  2181 000019A4 08C0                     or  al, al
  2182 000019A6 0F840200                 je @@getDigit72
  2183 000019AA EBB8                     jmp @@getDigit71
  2184                                  @@getDigit72:
  2185                                  
  2186                                  ;-55 }
  2187                                  
  2188                                  
  2189                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2190 000019AC C9                       LEAVE
  2191 000019AD C3                       ret
  2192                                  ; ENDP
  2193                                  
  2194                                  getName:  ; *** PROC ***
  2195                                  
  2196                                  ;-57   char *p; unsigned int i;
  2197                                  
  2198                                  
  2199                                  ;-58   p = &Symbol;
  2200                                  
  2201                                  ;Function : getName, Number of local variables: 3
  2202                                  ;   # type sign width line used address name   list of local variables
  2203                                  ;  200 var unsg byte    56 NULL bp+4    c
  2204                                  ;  201 ptr sign byte    57 NULL bp-2    p
  2205                                  ;  202 var unsg word    57 NULL bp-4    i;
  2206 000019AE C8040000                 ENTER  4,0
  2207 000019B2 B8[1900]                 mov ax, Symbol
  2208 000019B5 8946FE                   mov word [bp-2], ax
  2209                                  
  2210                                  ;-59   *p = c;
  2211                                  
  2212 000019B8 8A4604                   mov al, [bp+4]
  2213 000019BB 8B5EFE                   mov  bx, [bp-2]
  2214 000019BE 8807                     mov  [bx], al
  2215                                  
  2216                                  ;-60   p++;
  2217                                  
  2218 000019C0 FF46FE                   inc  word [bp-2]
  2219                                  
  2220                                  ;-61   while (alnumE(c)) {
  2221                                  
  2222                                  @@getName73:
  2223 000019C3 8A4604                   mov al, byte [bp+4]
  2224 000019C6 B400                     mov ah, 0
  2225 000019C8 50                       push ax
  2226 000019C9 E846FF                   call alnumE
  2227 000019CC 83C402                   add  sp, 2
  2228 000019CF 08C0                     or  al, al
  2229 000019D1 0F843800                 je @@getName74
  2230                                  
  2231                                  ;-62     InputPtr++;
  2232                                  
  2233 000019D5 FF06[D800]               inc  word [InputPtr]
  2234                                  
  2235                                  ;-63     c = *InputPtr;
  2236                                  
  2237 000019D9 8B1E[D800]               mov bx, [InputPtr]
  2238 000019DD 8A07                     mov al, [bx]
  2239 000019DF B400                     mov ah, 0
  2240 000019E1 884604                   mov byte [bp+4], al
  2241                                  
  2242                                  ;-64     *p = c;
  2243                                  
  2244 000019E4 8A4604                   mov al, [bp+4]
  2245 000019E7 8B5EFE                   mov  bx, [bp-2]
  2246 000019EA 8807                     mov  [bx], al
  2247                                  
  2248                                  ;-65     p++;
  2249                                  
  2250 000019EC FF46FE                   inc  word [bp-2]
  2251                                  
  2252                                  ;-66     i = p - &Symbol;
  2253                                  
  2254 000019EF 8B46FE                   mov ax, [bp-2]
  2255 000019F2 2D[1900]                 sub ax, Symbol
  2256 000019F5 8946FC                   mov word [bp-4], ax
  2257                                  
  2258                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  2259                                  
  2260 000019F8 8B46FC                   mov ax, [bp-4]
  2261 000019FB 83F81F                   cmp ax, 31 ;unsigned : 0
  2262 000019FE 0F820900                 jb  @@getName75
  2263 00001A02 68[561A]                 push getName_0
  2264 00001A05 E8BF08                   call errorexit
  2265 00001A08 83C402                   add  sp, 2
  2266                                  
  2267                                  ;-68   }
  2268                                  
  2269                                  @@getName75:
  2270                                  
  2271                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  2272                                  
  2273 00001A0B EBB6                     jmp @@getName73
  2274                                  @@getName74:
  2275 00001A0D 8A4604                   mov al, [bp+4]
  2276 00001A10 3C3A                     cmp al, 58
  2277 00001A12 0F850C00                 jne @@getName76
  2278 00001A16 66B801000000             mov eax, 1
  2279 00001A1C A2[B401]                 mov byte [isLabel], al
  2280 00001A1F E90900                   jmp @@getName77
  2281                                  @@getName76:
  2282 00001A22 66B800000000             mov eax, 0
  2283 00001A28 A2[B401]                 mov byte [isLabel], al
  2284                                  
  2285                                  ;-70   p--;
  2286                                  
  2287                                  @@getName77:
  2288 00001A2B FF4EFE                   dec  word [bp-2]
  2289                                  
  2290                                  ;-71   *p = 0;
  2291                                  
  2292 00001A2E 66B800000000             mov eax, 0
  2293 00001A34 8B5EFE                   mov  bx, [bp-2]
  2294 00001A37 8807                     mov  [bx], al
  2295                                  
  2296                                  ;-72   strcpy(SymbolUpper, Symbol);
  2297                                  
  2298 00001A39 8D06[1900]               lea  ax, [Symbol]
  2299 00001A3D 50                       push ax
  2300 00001A3E 8D06[3800]               lea  ax, [SymbolUpper]
  2301 00001A42 50                       push ax
  2302 00001A43 E85115                   call strcpy
  2303 00001A46 83C404                   add  sp, 4
  2304                                  
  2305                                  ;-73   toupper(SymbolUpper);
  2306                                  
  2307 00001A49 8D06[3800]               lea  ax, [SymbolUpper]
  2308 00001A4D 50                       push ax
  2309 00001A4E E8D814                   call toupper
  2310 00001A51 83C402                   add  sp, 2
  2311                                  
  2312                                  ;-74 }
  2313                                  
  2314                                  
  2315                                  ;-75 int testReg() {
  2316 00001A54 C9                       LEAVE
  2317 00001A55 C3                       ret
  2318                                  ; ENDP
  2319 00001A56 73796D626F6C20746F-     getName_0 db "symbol too long",0
  2320 00001A5F 6F206C6F6E6700     
  2321                                  
  2322                                  testReg:  ; *** PROC ***
  2323                                  
  2324                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2325                                  
  2326                                  
  2327                                  ;-77   RegType=0;
  2328                                  
  2329 00001A66 66B800000000             mov eax, 0
  2330 00001A6C A2[BE01]                 mov byte [RegType], al
  2331                                  
  2332                                  ;-78   if (strlen(Symbol) < 2) return 0;
  2333                                  
  2334 00001A6F 8D06[1900]               lea  ax, [Symbol]
  2335 00001A73 50                       push ax
  2336 00001A74 E8F514                   call strlen
  2337 00001A77 83C402                   add  sp, 2
  2338 00001A7A 3C02                     cmp al, 2
  2339 00001A7C 0F8D0900                 jge @@testReg78
  2340 00001A80 66B800000000             mov eax, 0
  2341 00001A86 E9B603                   jmp @@retn
  2342                                  
  2343                                  ;-79   if (strlen(Symbol) > 3) return 0;
  2344                                  
  2345                                  @@testReg78:
  2346 00001A89 8D06[1900]               lea  ax, [Symbol]
  2347 00001A8D 50                       push ax
  2348 00001A8E E8DB14                   call strlen
  2349 00001A91 83C402                   add  sp, 2
  2350 00001A94 3C03                     cmp al, 3
  2351 00001A96 0F8E0900                 jle @@testReg79
  2352 00001A9A 66B800000000             mov eax, 0
  2353 00001AA0 E99C03                   jmp @@retn
  2354                                  
  2355                                  ;-80   RegType=BYTE;
  2356                                  
  2357                                  @@testReg79:
  2358 00001AA3 66B801000000             mov eax, 1
  2359 00001AA9 A2[BE01]                 mov byte [RegType], al
  2360                                  
  2361                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  2362                                  
  2363 00001AAC 68[401E]                 push testReg_0
  2364 00001AAF 8D06[3800]               lea  ax, [SymbolUpper]
  2365 00001AB3 50                       push ax
  2366 00001AB4 E84C15                   call eqstr
  2367 00001AB7 83C404                   add  sp, 4
  2368 00001ABA 08C0                     or  al, al
  2369 00001ABC 0F840900                 je @@testReg80
  2370 00001AC0 66B800000000             mov eax, 0
  2371 00001AC6 E97603                   jmp @@retn
  2372                                  
  2373                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  2374                                  
  2375                                  @@testReg80:
  2376 00001AC9 68[431E]                 push testReg_1
  2377 00001ACC 8D06[3800]               lea  ax, [SymbolUpper]
  2378 00001AD0 50                       push ax
  2379 00001AD1 E82F15                   call eqstr
  2380 00001AD4 83C404                   add  sp, 4
  2381 00001AD7 08C0                     or  al, al
  2382 00001AD9 0F840900                 je @@testReg81
  2383 00001ADD 66B801000000             mov eax, 1
  2384 00001AE3 E95903                   jmp @@retn
  2385                                  
  2386                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  2387                                  
  2388                                  @@testReg81:
  2389 00001AE6 68[461E]                 push testReg_2
  2390 00001AE9 8D06[3800]               lea  ax, [SymbolUpper]
  2391 00001AED 50                       push ax
  2392 00001AEE E81215                   call eqstr
  2393 00001AF1 83C404                   add  sp, 4
  2394 00001AF4 08C0                     or  al, al
  2395 00001AF6 0F840900                 je @@testReg82
  2396 00001AFA 66B802000000             mov eax, 2
  2397 00001B00 E93C03                   jmp @@retn
  2398                                  
  2399                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  2400                                  
  2401                                  @@testReg82:
  2402 00001B03 68[491E]                 push testReg_3
  2403 00001B06 8D06[3800]               lea  ax, [SymbolUpper]
  2404 00001B0A 50                       push ax
  2405 00001B0B E8F514                   call eqstr
  2406 00001B0E 83C404                   add  sp, 4
  2407 00001B11 08C0                     or  al, al
  2408 00001B13 0F840900                 je @@testReg83
  2409 00001B17 66B803000000             mov eax, 3
  2410 00001B1D E91F03                   jmp @@retn
  2411                                  
  2412                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  2413                                  
  2414                                  @@testReg83:
  2415 00001B20 68[4C1E]                 push testReg_4
  2416 00001B23 8D06[3800]               lea  ax, [SymbolUpper]
  2417 00001B27 50                       push ax
  2418 00001B28 E8D814                   call eqstr
  2419 00001B2B 83C404                   add  sp, 4
  2420 00001B2E 08C0                     or  al, al
  2421 00001B30 0F840900                 je @@testReg84
  2422 00001B34 66B804000000             mov eax, 4
  2423 00001B3A E90203                   jmp @@retn
  2424                                  
  2425                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  2426                                  
  2427                                  @@testReg84:
  2428 00001B3D 68[4F1E]                 push testReg_5
  2429 00001B40 8D06[3800]               lea  ax, [SymbolUpper]
  2430 00001B44 50                       push ax
  2431 00001B45 E8BB14                   call eqstr
  2432 00001B48 83C404                   add  sp, 4
  2433 00001B4B 08C0                     or  al, al
  2434 00001B4D 0F840900                 je @@testReg85
  2435 00001B51 66B805000000             mov eax, 5
  2436 00001B57 E9E502                   jmp @@retn
  2437                                  
  2438                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  2439                                  
  2440                                  @@testReg85:
  2441 00001B5A 68[521E]                 push testReg_6
  2442 00001B5D 8D06[3800]               lea  ax, [SymbolUpper]
  2443 00001B61 50                       push ax
  2444 00001B62 E89E14                   call eqstr
  2445 00001B65 83C404                   add  sp, 4
  2446 00001B68 08C0                     or  al, al
  2447 00001B6A 0F840900                 je @@testReg86
  2448 00001B6E 66B806000000             mov eax, 6
  2449 00001B74 E9C802                   jmp @@retn
  2450                                  
  2451                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  2452                                  
  2453                                  @@testReg86:
  2454 00001B77 68[551E]                 push testReg_7
  2455 00001B7A 8D06[3800]               lea  ax, [SymbolUpper]
  2456 00001B7E 50                       push ax
  2457 00001B7F E88114                   call eqstr
  2458 00001B82 83C404                   add  sp, 4
  2459 00001B85 08C0                     or  al, al
  2460 00001B87 0F840900                 je @@testReg87
  2461 00001B8B 66B807000000             mov eax, 7
  2462 00001B91 E9AB02                   jmp @@retn
  2463                                  
  2464                                  ;-89   RegType=WORD;
  2465                                  
  2466                                  @@testReg87:
  2467 00001B94 66B802000000             mov eax, 2
  2468 00001B9A A2[BE01]                 mov byte [RegType], al
  2469                                  
  2470                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  2471                                  
  2472 00001B9D 68[581E]                 push testReg_8
  2473 00001BA0 8D06[3800]               lea  ax, [SymbolUpper]
  2474 00001BA4 50                       push ax
  2475 00001BA5 E85B14                   call eqstr
  2476 00001BA8 83C404                   add  sp, 4
  2477 00001BAB 08C0                     or  al, al
  2478 00001BAD 0F840900                 je @@testReg88
  2479 00001BB1 66B800000000             mov eax, 0
  2480 00001BB7 E98502                   jmp @@retn
  2481                                  
  2482                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  2483                                  
  2484                                  @@testReg88:
  2485 00001BBA 68[5B1E]                 push testReg_9
  2486 00001BBD 8D06[3800]               lea  ax, [SymbolUpper]
  2487 00001BC1 50                       push ax
  2488 00001BC2 E83E14                   call eqstr
  2489 00001BC5 83C404                   add  sp, 4
  2490 00001BC8 08C0                     or  al, al
  2491 00001BCA 0F840900                 je @@testReg89
  2492 00001BCE 66B801000000             mov eax, 1
  2493 00001BD4 E96802                   jmp @@retn
  2494                                  
  2495                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  2496                                  
  2497                                  @@testReg89:
  2498 00001BD7 68[5E1E]                 push testReg_10
  2499 00001BDA 8D06[3800]               lea  ax, [SymbolUpper]
  2500 00001BDE 50                       push ax
  2501 00001BDF E82114                   call eqstr
  2502 00001BE2 83C404                   add  sp, 4
  2503 00001BE5 08C0                     or  al, al
  2504 00001BE7 0F840900                 je @@testReg90
  2505 00001BEB 66B802000000             mov eax, 2
  2506 00001BF1 E94B02                   jmp @@retn
  2507                                  
  2508                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  2509                                  
  2510                                  @@testReg90:
  2511 00001BF4 68[611E]                 push testReg_11
  2512 00001BF7 8D06[3800]               lea  ax, [SymbolUpper]
  2513 00001BFB 50                       push ax
  2514 00001BFC E80414                   call eqstr
  2515 00001BFF 83C404                   add  sp, 4
  2516 00001C02 08C0                     or  al, al
  2517 00001C04 0F840900                 je @@testReg91
  2518 00001C08 66B803000000             mov eax, 3
  2519 00001C0E E92E02                   jmp @@retn
  2520                                  
  2521                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  2522                                  
  2523                                  @@testReg91:
  2524 00001C11 68[641E]                 push testReg_12
  2525 00001C14 8D06[3800]               lea  ax, [SymbolUpper]
  2526 00001C18 50                       push ax
  2527 00001C19 E8E713                   call eqstr
  2528 00001C1C 83C404                   add  sp, 4
  2529 00001C1F 08C0                     or  al, al
  2530 00001C21 0F840900                 je @@testReg92
  2531 00001C25 66B804000000             mov eax, 4
  2532 00001C2B E91102                   jmp @@retn
  2533                                  
  2534                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  2535                                  
  2536                                  @@testReg92:
  2537 00001C2E 68[671E]                 push testReg_13
  2538 00001C31 8D06[3800]               lea  ax, [SymbolUpper]
  2539 00001C35 50                       push ax
  2540 00001C36 E8CA13                   call eqstr
  2541 00001C39 83C404                   add  sp, 4
  2542 00001C3C 08C0                     or  al, al
  2543 00001C3E 0F840900                 je @@testReg93
  2544 00001C42 66B805000000             mov eax, 5
  2545 00001C48 E9F401                   jmp @@retn
  2546                                  
  2547                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  2548                                  
  2549                                  @@testReg93:
  2550 00001C4B 68[6A1E]                 push testReg_14
  2551 00001C4E 8D06[3800]               lea  ax, [SymbolUpper]
  2552 00001C52 50                       push ax
  2553 00001C53 E8AD13                   call eqstr
  2554 00001C56 83C404                   add  sp, 4
  2555 00001C59 08C0                     or  al, al
  2556 00001C5B 0F840900                 je @@testReg94
  2557 00001C5F 66B806000000             mov eax, 6
  2558 00001C65 E9D701                   jmp @@retn
  2559                                  
  2560                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  2561                                  
  2562                                  @@testReg94:
  2563 00001C68 68[6D1E]                 push testReg_15
  2564 00001C6B 8D06[3800]               lea  ax, [SymbolUpper]
  2565 00001C6F 50                       push ax
  2566 00001C70 E89013                   call eqstr
  2567 00001C73 83C404                   add  sp, 4
  2568 00001C76 08C0                     or  al, al
  2569 00001C78 0F840900                 je @@testReg95
  2570 00001C7C 66B807000000             mov eax, 7
  2571 00001C82 E9BA01                   jmp @@retn
  2572                                  
  2573                                  ;-98   RegType=SEGREG;
  2574                                  
  2575                                  @@testReg95:
  2576 00001C85 66B804000000             mov eax, 4
  2577 00001C8B A2[BE01]                 mov byte [RegType], al
  2578                                  
  2579                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  2580                                  
  2581 00001C8E 68[701E]                 push testReg_16
  2582 00001C91 8D06[3800]               lea  ax, [SymbolUpper]
  2583 00001C95 50                       push ax
  2584 00001C96 E86A13                   call eqstr
  2585 00001C99 83C404                   add  sp, 4
  2586 00001C9C 08C0                     or  al, al
  2587 00001C9E 0F840900                 je @@testReg96
  2588 00001CA2 66B800000000             mov eax, 0
  2589 00001CA8 E99401                   jmp @@retn
  2590                                  
  2591                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  2592                                  
  2593                                  @@testReg96:
  2594 00001CAB 68[731E]                 push testReg_17
  2595 00001CAE 8D06[3800]               lea  ax, [SymbolUpper]
  2596 00001CB2 50                       push ax
  2597 00001CB3 E84D13                   call eqstr
  2598 00001CB6 83C404                   add  sp, 4
  2599 00001CB9 08C0                     or  al, al
  2600 00001CBB 0F840900                 je @@testReg97
  2601 00001CBF 66B801000000             mov eax, 1
  2602 00001CC5 E97701                   jmp @@retn
  2603                                  
  2604                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  2605                                  
  2606                                  @@testReg97:
  2607 00001CC8 68[761E]                 push testReg_18
  2608 00001CCB 8D06[3800]               lea  ax, [SymbolUpper]
  2609 00001CCF 50                       push ax
  2610 00001CD0 E83013                   call eqstr
  2611 00001CD3 83C404                   add  sp, 4
  2612 00001CD6 08C0                     or  al, al
  2613 00001CD8 0F840900                 je @@testReg98
  2614 00001CDC 66B802000000             mov eax, 2
  2615 00001CE2 E95A01                   jmp @@retn
  2616                                  
  2617                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  2618                                  
  2619                                  @@testReg98:
  2620 00001CE5 68[791E]                 push testReg_19
  2621 00001CE8 8D06[3800]               lea  ax, [SymbolUpper]
  2622 00001CEC 50                       push ax
  2623 00001CED E81313                   call eqstr
  2624 00001CF0 83C404                   add  sp, 4
  2625 00001CF3 08C0                     or  al, al
  2626 00001CF5 0F840900                 je @@testReg99
  2627 00001CF9 66B803000000             mov eax, 3
  2628 00001CFF E93D01                   jmp @@retn
  2629                                  
  2630                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  2631                                  
  2632                                  @@testReg99:
  2633 00001D02 68[7C1E]                 push testReg_20
  2634 00001D05 8D06[3800]               lea  ax, [SymbolUpper]
  2635 00001D09 50                       push ax
  2636 00001D0A E8F612                   call eqstr
  2637 00001D0D 83C404                   add  sp, 4
  2638 00001D10 08C0                     or  al, al
  2639 00001D12 0F840900                 je @@testReg100
  2640 00001D16 66B804000000             mov eax, 4
  2641 00001D1C E92001                   jmp @@retn
  2642                                  
  2643                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  2644                                  
  2645                                  @@testReg100:
  2646 00001D1F 68[7F1E]                 push testReg_21
  2647 00001D22 8D06[3800]               lea  ax, [SymbolUpper]
  2648 00001D26 50                       push ax
  2649 00001D27 E8D912                   call eqstr
  2650 00001D2A 83C404                   add  sp, 4
  2651 00001D2D 08C0                     or  al, al
  2652 00001D2F 0F840900                 je @@testReg101
  2653 00001D33 66B805000000             mov eax, 5
  2654 00001D39 E90301                   jmp @@retn
  2655                                  
  2656                                  ;-105   RegType=DWORD;
  2657                                  
  2658                                  @@testReg101:
  2659 00001D3C 66B803000000             mov eax, 3
  2660 00001D42 A2[BE01]                 mov byte [RegType], al
  2661                                  
  2662                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  2663                                  
  2664 00001D45 68[821E]                 push testReg_22
  2665 00001D48 8D06[3800]               lea  ax, [SymbolUpper]
  2666 00001D4C 50                       push ax
  2667 00001D4D E8B312                   call eqstr
  2668 00001D50 83C404                   add  sp, 4
  2669 00001D53 08C0                     or  al, al
  2670 00001D55 0F840900                 je @@testReg102
  2671 00001D59 66B800000000             mov eax, 0
  2672 00001D5F E9DD00                   jmp @@retn
  2673                                  
  2674                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  2675                                  
  2676                                  @@testReg102:
  2677 00001D62 68[861E]                 push testReg_23
  2678 00001D65 8D06[3800]               lea  ax, [SymbolUpper]
  2679 00001D69 50                       push ax
  2680 00001D6A E89612                   call eqstr
  2681 00001D6D 83C404                   add  sp, 4
  2682 00001D70 08C0                     or  al, al
  2683 00001D72 0F840900                 je @@testReg103
  2684 00001D76 66B801000000             mov eax, 1
  2685 00001D7C E9C000                   jmp @@retn
  2686                                  
  2687                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  2688                                  
  2689                                  @@testReg103:
  2690 00001D7F 68[8A1E]                 push testReg_24
  2691 00001D82 8D06[3800]               lea  ax, [SymbolUpper]
  2692 00001D86 50                       push ax
  2693 00001D87 E87912                   call eqstr
  2694 00001D8A 83C404                   add  sp, 4
  2695 00001D8D 08C0                     or  al, al
  2696 00001D8F 0F840900                 je @@testReg104
  2697 00001D93 66B802000000             mov eax, 2
  2698 00001D99 E9A300                   jmp @@retn
  2699                                  
  2700                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  2701                                  
  2702                                  @@testReg104:
  2703 00001D9C 68[8E1E]                 push testReg_25
  2704 00001D9F 8D06[3800]               lea  ax, [SymbolUpper]
  2705 00001DA3 50                       push ax
  2706 00001DA4 E85C12                   call eqstr
  2707 00001DA7 83C404                   add  sp, 4
  2708 00001DAA 08C0                     or  al, al
  2709 00001DAC 0F840900                 je @@testReg105
  2710 00001DB0 66B803000000             mov eax, 3
  2711 00001DB6 E98600                   jmp @@retn
  2712                                  
  2713                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  2714                                  
  2715                                  @@testReg105:
  2716 00001DB9 68[921E]                 push testReg_26
  2717 00001DBC 8D06[3800]               lea  ax, [SymbolUpper]
  2718 00001DC0 50                       push ax
  2719 00001DC1 E83F12                   call eqstr
  2720 00001DC4 83C404                   add  sp, 4
  2721 00001DC7 08C0                     or  al, al
  2722 00001DC9 0F840900                 je @@testReg106
  2723 00001DCD 66B804000000             mov eax, 4
  2724 00001DD3 E96900                   jmp @@retn
  2725                                  
  2726                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  2727                                  
  2728                                  @@testReg106:
  2729 00001DD6 68[961E]                 push testReg_27
  2730 00001DD9 8D06[3800]               lea  ax, [SymbolUpper]
  2731 00001DDD 50                       push ax
  2732 00001DDE E82212                   call eqstr
  2733 00001DE1 83C404                   add  sp, 4
  2734 00001DE4 08C0                     or  al, al
  2735 00001DE6 0F840900                 je @@testReg107
  2736 00001DEA 66B805000000             mov eax, 5
  2737 00001DF0 E94C00                   jmp @@retn
  2738                                  
  2739                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  2740                                  
  2741                                  @@testReg107:
  2742 00001DF3 68[9A1E]                 push testReg_28
  2743 00001DF6 8D06[3800]               lea  ax, [SymbolUpper]
  2744 00001DFA 50                       push ax
  2745 00001DFB E80512                   call eqstr
  2746 00001DFE 83C404                   add  sp, 4
  2747 00001E01 08C0                     or  al, al
  2748 00001E03 0F840900                 je @@testReg108
  2749 00001E07 66B806000000             mov eax, 6
  2750 00001E0D E92F00                   jmp @@retn
  2751                                  
  2752                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  2753                                  
  2754                                  @@testReg108:
  2755 00001E10 68[9E1E]                 push testReg_29
  2756 00001E13 8D06[3800]               lea  ax, [SymbolUpper]
  2757 00001E17 50                       push ax
  2758 00001E18 E8E811                   call eqstr
  2759 00001E1B 83C404                   add  sp, 4
  2760 00001E1E 08C0                     or  al, al
  2761 00001E20 0F840900                 je @@testReg109
  2762 00001E24 66B807000000             mov eax, 7
  2763 00001E2A E91200                   jmp @@retn
  2764                                  
  2765                                  ;-114   RegType=0; return 0;
  2766                                  
  2767                                  @@testReg109:
  2768 00001E2D 66B800000000             mov eax, 0
  2769 00001E33 A2[BE01]                 mov byte [RegType], al
  2770 00001E36 66B800000000             mov eax, 0
  2771 00001E3C E90000                   jmp @@retn
  2772                                  
  2773                                  ;-115 }
  2774                                  
  2775                                  @@retn:
  2776 00001E3F C3                       ret
  2777                                  ; ENDP
  2778 00001E40 414C00                  testReg_0 db "AL",0
  2779 00001E43 434C00                  testReg_1 db "CL",0
  2780 00001E46 444C00                  testReg_2 db "DL",0
  2781 00001E49 424C00                  testReg_3 db "BL",0
  2782 00001E4C 414800                  testReg_4 db "AH",0
  2783 00001E4F 434800                  testReg_5 db "CH",0
  2784 00001E52 444800                  testReg_6 db "DH",0
  2785 00001E55 424800                  testReg_7 db "BH",0
  2786 00001E58 415800                  testReg_8 db "AX",0
  2787 00001E5B 435800                  testReg_9 db "CX",0
  2788 00001E5E 445800                  testReg_10 db "DX",0
  2789 00001E61 425800                  testReg_11 db "BX",0
  2790 00001E64 535000                  testReg_12 db "SP",0
  2791 00001E67 425000                  testReg_13 db "BP",0
  2792 00001E6A 534900                  testReg_14 db "SI",0
  2793 00001E6D 444900                  testReg_15 db "DI",0
  2794 00001E70 455300                  testReg_16 db "ES",0
  2795 00001E73 435300                  testReg_17 db "CS",0
  2796 00001E76 535300                  testReg_18 db "SS",0
  2797 00001E79 445300                  testReg_19 db "DS",0
  2798 00001E7C 465300                  testReg_20 db "FS",0
  2799 00001E7F 475300                  testReg_21 db "GS",0
  2800 00001E82 45415800                testReg_22 db "EAX",0
  2801 00001E86 45435800                testReg_23 db "ECX",0
  2802 00001E8A 45445800                testReg_24 db "EDX",0
  2803 00001E8E 45425800                testReg_25 db "EBX",0
  2804 00001E92 45535000                testReg_26 db "ESP",0
  2805 00001E96 45425000                testReg_27 db "EBP",0
  2806 00001E9A 45534900                testReg_28 db "ESI",0
  2807 00001E9E 45444900                testReg_29 db "EDI",0
  2808                                  ;Back to main program: AS.C
  2809                                  
  2810                                  ;-7 #include "OUTPUT.C"
  2811                                  
  2812                                  ;Use include file: OUTPUT.C
  2813                                  
  2814                                  ;-1 int printLine() { int i; char c;
  2815                                  
  2816                                  
  2817                                  printLine:  ; *** PROC ***
  2818                                  
  2819                                  ;-2   prs("\n"); printhex16(PCStart);
  2820                                  
  2821                                  ;Function : printLine, Number of local variables: 2
  2822                                  ;   # type sign width line used address name   list of local variables
  2823                                  ;  200 var sign word     1 NULL bp-2    i
  2824                                  ;  201 var sign byte     1 NULL bp-4    c;
  2825 00001EA2 C8040000                 ENTER  4,0
  2826 00001EA6 68[371F]                 push printLine_0
  2827 00001EA9 E80401                   call prs
  2828 00001EAC 83C402                   add  sp, 2
  2829 00001EAF FF36[B201]               push word [PCStart]
  2830 00001EB3 E8EB01                   call printhex16
  2831 00001EB6 83C402                   add  sp, 2
  2832                                  
  2833                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  2834                                  
  2835 00001EB9 A1[CF01]                 mov ax, [OpPrintIndex]
  2836 00001EBC 83F800                   cmp ax, 0
  2837 00001EBF 0F850C00                 jne @@printLine110
  2838 00001EC3 68[3A1F]                 push printLine_1
  2839 00001EC6 E8E700                   call prs
  2840 00001EC9 83C402                   add  sp, 2
  2841                                  
  2842                                  ;-4   else {
  2843                                  
  2844 00001ECC E95B00                   jmp @@printLine111
  2845                                  @@printLine110:
  2846                                  
  2847                                  ;-5     prc(PrintR);
  2848                                  
  2849 00001ECF A0[D301]                 mov al, byte [PrintR]
  2850 00001ED2 B400                     mov ah, 0
  2851 00001ED4 50                       push ax
  2852 00001ED5 E87700                   call prc
  2853 00001ED8 83C402                   add  sp, 2
  2854                                  
  2855                                  ;-6     i=0;
  2856                                  
  2857 00001EDB 66B800000000             mov eax, 0
  2858 00001EE1 8946FE                   mov word [bp-2], ax
  2859                                  
  2860                                  ;-7     do {
  2861                                  
  2862                                  @@printLine112:
  2863                                  
  2864                                  ;-8       c=OpPos[i];
  2865                                  
  2866 00001EE4 8B5EFE                   mov bx, [bp-2]
  2867 00001EE7 8A87[CA01]               mov al, [OpPos + bx]
  2868 00001EEB 8846FC                   mov byte [bp-4], al
  2869                                  
  2870                                  ;-9       printhex8a(c); prc(' ');
  2871                                  
  2872 00001EEE 8A46FC                   mov al, byte [bp-4]
  2873 00001EF1 B400                     mov ah, 0
  2874 00001EF3 50                       push ax
  2875 00001EF4 E85C01                   call printhex8a
  2876 00001EF7 83C402                   add  sp, 2
  2877 00001EFA 6A20                     push 32
  2878 00001EFC E85000                   call prc
  2879 00001EFF 83C402                   add  sp, 2
  2880                                  
  2881                                  ;-10       i++;
  2882                                  
  2883 00001F02 FF46FE                   inc  word [bp-2]
  2884                                  
  2885                                  ;-11     } while(i < OpPrintIndex);
  2886                                  
  2887 00001F05 8B46FE                   mov ax, [bp-2]
  2888 00001F08 3B06[CF01]               cmp ax, [OpPrintIndex]
  2889 00001F0C 0F8D0200                 jge @@printLine113
  2890 00001F10 EBD2                     jmp @@printLine112
  2891                                  @@printLine113:
  2892                                  
  2893                                  ;-12     do {// fill rest with blank
  2894                                  
  2895                                  @@printLine114:
  2896                                  
  2897                                  ;-13       prs("   ");
  2898                                  
  2899 00001F12 68[4B1F]                 push printLine_2
  2900 00001F15 E89800                   call prs
  2901 00001F18 83C402                   add  sp, 2
  2902                                  
  2903                                  ;-14       i++;
  2904                                  
  2905 00001F1B FF46FE                   inc  word [bp-2]
  2906                                  
  2907                                  ;-15     } while(i < OPMAXLEN);
  2908                                  
  2909 00001F1E 8B46FE                   mov ax, [bp-2]
  2910 00001F21 83F805                   cmp ax, 5
  2911 00001F24 0F8D0200                 jge @@printLine115
  2912 00001F28 EBE8                     jmp @@printLine114
  2913                                  @@printLine115:
  2914                                  
  2915                                  ;-16   }
  2916                                  
  2917                                  
  2918                                  ;-17   prscomment(InputBuf);
  2919                                  
  2920                                  @@printLine111:
  2921 00001F2A 8D06[5900]               lea  ax, [InputBuf]
  2922 00001F2E 50                       push ax
  2923 00001F2F E85000                   call prscomment
  2924 00001F32 83C402                   add  sp, 2
  2925                                  
  2926                                  ;-18 }
  2927                                  
  2928                                  
  2929                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  2930 00001F35 C9                       LEAVE
  2931 00001F36 C3                       ret
  2932                                  ; ENDP
  2933 00001F37 5C6E00                  printLine_0 db "\n",0
  2934 00001F3A 202020202020202020-     printLine_1 db "                ",0
  2935 00001F43 2020202020202000   
  2936 00001F4B 20202000                printLine_2 db "   ",0
  2937                                  
  2938                                  prc:  ; *** PROC ***
  2939                                  ;Function : prc, Number of local variables: 1
  2940                                  ;   # type sign width line used address name   list of local variables
  2941                                  ;  200 var unsg byte    19 NULL bp+4    c;
  2942 00001F4F C8000000                 ENTER  0,0
  2943 00001F53 A0[1800]                 mov al, [LIST]
  2944 00001F56 08C0                     or  al, al
  2945 00001F58 0F841400                 je @@prc116
  2946 00001F5C 807E040A                cmp byte [bp+4], 10
  2947 00001F60 0F850600                 jne @@prc117
  2948 00001F64 B80D00                   mov  ax, 13
  2949 00001F67 E8890F                   call writetty
  2950                                  
  2951                                  ;-20      al=c; writetty(); }
  2952                                  
  2953                                  @@prc117:
  2954 00001F6A 8A4604                   mov  al, [bp+4]
  2955 00001F6D E8830F                   call writetty
  2956                                  
  2957                                  ;-21    fputcR(c,lst_fd); }
  2958                                  
  2959                                  @@prc116:
  2960 00001F70 FF36[A501]               push word [lst_fd]
  2961 00001F74 8A4604                   mov al, byte [bp+4]
  2962 00001F77 B400                     mov ah, 0
  2963 00001F79 50                       push ax
  2964 00001F7A E83611                   call fputcR
  2965 00001F7D 83C404                   add  sp, 4
  2966                                  
  2967                                  ;-22 
  2968                                  
  2969                                  
  2970                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  2971 00001F80 C9                       LEAVE
  2972 00001F81 C3                       ret
  2973                                  ; ENDP
  2974                                  
  2975                                  prscomment:  ; *** PROC ***
  2976                                  
  2977                                  ;-24   while(*s){c=*s;prc(c);s++;}
  2978                                  
  2979                                  ;Function : prscomment, Number of local variables: 2
  2980                                  ;   # type sign width line used address name   list of local variables
  2981                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  2982                                  ;  201 var unsg byte    23 NULL bp-2    c;
  2983 00001F82 C8020000                 ENTER  2,0
  2984                                  @@prscomment118:
  2985 00001F86 8B5E04                   mov bx, [bp+4]
  2986 00001F89 8A07                     mov al, [bx]
  2987 00001F8B B400                     mov ah, 0
  2988 00001F8D 08C0                     or  al, al
  2989 00001F8F 0F841B00                 je @@prscomment119
  2990 00001F93 8B5E04                   mov bx, [bp+4]
  2991 00001F96 8A07                     mov al, [bx]
  2992 00001F98 B400                     mov ah, 0
  2993 00001F9A 8846FE                   mov byte [bp-2], al
  2994 00001F9D 8A46FE                   mov al, byte [bp-2]
  2995 00001FA0 B400                     mov ah, 0
  2996 00001FA2 50                       push ax
  2997 00001FA3 E8A9FF                   call prc
  2998 00001FA6 83C402                   add  sp, 2
  2999 00001FA9 FF4604                   inc  word [bp+4]
  3000                                  
  3001                                  ;-25 }
  3002                                  
  3003 00001FAC EBD8                     jmp @@prscomment118
  3004                                  @@prscomment119:
  3005                                  
  3006                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3007 00001FAE C9                       LEAVE
  3008 00001FAF C3                       ret
  3009                                  ; ENDP
  3010                                  
  3011                                  prs:  ; *** PROC ***
  3012                                  ;Function : prs, Number of local variables: 3
  3013                                  ;   # type sign width line used address name   list of local variables
  3014                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3015                                  ;  201 var unsg byte    26 NULL bp-2    c
  3016                                  ;  202 var sign word    26 NULL bp-4    com;
  3017 00001FB0 C8040000                 ENTER  4,0
  3018 00001FB4 66B800000000             mov eax, 0
  3019 00001FBA 8946FC                   mov word [bp-4], ax
  3020                                  
  3021                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3022                                  
  3023                                  @@prs120:
  3024 00001FBD 8B5E04                   mov bx, [bp+4]
  3025 00001FC0 8A07                     mov al, [bx]
  3026 00001FC2 B400                     mov ah, 0
  3027 00001FC4 08C0                     or  al, al
  3028 00001FC6 0F848700                 je @@prs121
  3029 00001FCA 8B5E04                   mov bx, [bp+4]
  3030 00001FCD 8A07                     mov al, [bx]
  3031 00001FCF B400                     mov ah, 0
  3032 00001FD1 8846FE                   mov byte [bp-2], al
  3033 00001FD4 8A46FE                   mov al, [bp-2]
  3034 00001FD7 3C22                     cmp al, 34
  3035 00001FD9 0F851E00                 jne @@prs122
  3036 00001FDD 8B46FC                   mov ax, [bp-4]
  3037 00001FE0 08C0                     or  al, al
  3038 00001FE2 0F840C00                 je @@prs123
  3039 00001FE6 66B800000000             mov eax, 0
  3040 00001FEC 8946FC                   mov word [bp-4], ax
  3041 00001FEF E90900                   jmp @@prs124
  3042                                  @@prs123:
  3043 00001FF2 66B801000000             mov eax, 1
  3044 00001FF8 8946FC                   mov word [bp-4], ax
  3045                                  
  3046                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3047                                  
  3048                                  @@prs124:
  3049                                  @@prs122:
  3050 00001FFB 8A46FE                   mov al, [bp-2]
  3051 00001FFE 3C5C                     cmp al, 92
  3052 00002000 0F853B00                 jne @@prs125
  3053 00002004 8B46FC                   mov ax, [bp-4]
  3054 00002007 83F800                   cmp ax, 0
  3055 0000200A 0F853100                 jne @@prs126
  3056 0000200E FF4604                   inc  word [bp+4]
  3057 00002011 8B5E04                   mov bx, [bp+4]
  3058 00002014 8A07                     mov al, [bx]
  3059 00002016 B400                     mov ah, 0
  3060 00002018 8846FE                   mov byte [bp-2], al
  3061                                  
  3062                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3063                                  
  3064 0000201B 8A46FE                   mov al, [bp-2]
  3065 0000201E 3C6E                     cmp al, 110
  3066 00002020 0F850900                 jne @@prs127
  3067 00002024 66B80A000000             mov eax, 10
  3068 0000202A 8846FE                   mov byte [bp-2], al
  3069                                  @@prs127:
  3070 0000202D 8A46FE                   mov al, [bp-2]
  3071 00002030 3C74                     cmp al, 116
  3072 00002032 0F850900                 jne @@prs128
  3073 00002036 66B809000000             mov eax, 9
  3074 0000203C 8846FE                   mov byte [bp-2], al
  3075                                  @@prs128:
  3076                                  @@prs126:
  3077                                  @@prs125:
  3078 0000203F 8A46FE                   mov al, byte [bp-2]
  3079 00002042 B400                     mov ah, 0
  3080 00002044 50                       push ax
  3081 00002045 E807FF                   call prc
  3082 00002048 83C402                   add  sp, 2
  3083 0000204B FF4604                   inc  word [bp+4]
  3084                                  
  3085                                  ;-30 }
  3086                                  
  3087 0000204E E96CFF                   jmp @@prs120
  3088                                  @@prs121:
  3089                                  
  3090                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  3091 00002051 C9                       LEAVE
  3092 00002052 C3                       ret
  3093                                  ; ENDP
  3094                                  
  3095                                  printhex8a:  ; *** PROC ***
  3096                                  
  3097                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3098                                  
  3099                                  ;Function : printhex8a, Number of local variables: 2
  3100                                  ;   # type sign width line used address name   list of local variables
  3101                                  ;  200 var unsg word    31 NULL bp+4    c
  3102                                  ;  201 var unsg word    31 NULL bp-2    nib;
  3103 00002053 C8020000                 ENTER  2,0
  3104 00002057 8B4604                   mov ax, [bp+4]
  3105 0000205A C1E804                   shr ax, 4
  3106 0000205D 8946FE                   mov word [bp-2], ax
  3107 00002060 8346FE30                 add  word [bp-2], 48
  3108 00002064 8B46FE                   mov ax, [bp-2]
  3109 00002067 83F839                   cmp ax, 57
  3110 0000206A 0F8E0400                 jle @@printhex8a129
  3111 0000206E 8346FE07                 add  word [bp-2], 7
  3112                                  @@printhex8a129:
  3113 00002072 FF76FE                   push word [bp-2]
  3114 00002075 E8D7FE                   call prc
  3115 00002078 83C402                   add  sp, 2
  3116                                  
  3117                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3118                                  
  3119 0000207B 8B4604                   mov ax, [bp+4]
  3120 0000207E 83E00F                   and ax, 15
  3121 00002081 8946FE                   mov word [bp-2], ax
  3122 00002084 8346FE30                 add  word [bp-2], 48
  3123 00002088 8B46FE                   mov ax, [bp-2]
  3124 0000208B 83F839                   cmp ax, 57
  3125 0000208E 0F8E0400                 jle @@printhex8a130
  3126 00002092 8346FE07                 add  word [bp-2], 7
  3127                                  @@printhex8a130:
  3128 00002096 FF76FE                   push word [bp-2]
  3129 00002099 E8B3FE                   call prc
  3130 0000209C 83C402                   add  sp, 2
  3131                                  
  3132                                  ;-34 }
  3133                                  
  3134                                  
  3135                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  3136 0000209F C9                       LEAVE
  3137 000020A0 C3                       ret
  3138                                  ; ENDP
  3139                                  
  3140                                  printhex16:  ; *** PROC ***
  3141                                  
  3142                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3143                                  
  3144                                  ;Function : printhex16, Number of local variables: 2
  3145                                  ;   # type sign width line used address name   list of local variables
  3146                                  ;  200 var unsg word    35 NULL bp+4    i
  3147                                  ;  201 var unsg word    35 NULL bp-2    half;
  3148 000020A1 C8020000                 ENTER  2,0
  3149 000020A5 8B4604                   mov ax, [bp+4]
  3150 000020A8 C1E808                   shr ax, 8
  3151 000020AB 8946FE                   mov word [bp-2], ax
  3152 000020AE FF76FE                   push word [bp-2]
  3153 000020B1 E89FFF                   call printhex8a
  3154 000020B4 83C402                   add  sp, 2
  3155 000020B7 8B4604                   mov ax, [bp+4]
  3156 000020BA 25FF00                   and ax, 255
  3157 000020BD 8946FE                   mov word [bp-2], ax
  3158 000020C0 FF76FE                   push word [bp-2]
  3159 000020C3 E88DFF                   call printhex8a
  3160 000020C6 83C402                   add  sp, 2
  3161                                  
  3162                                  ;-37 }
  3163                                  
  3164                                  
  3165                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  3166 000020C9 C9                       LEAVE
  3167 000020CA C3                       ret
  3168                                  ; ENDP
  3169                                  
  3170                                  printIntU:  ; *** PROC ***
  3171                                  
  3172                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  3173                                  
  3174                                  ;Function : printIntU, Number of local variables: 2
  3175                                  ;   # type sign width line used address name   list of local variables
  3176                                  ;  200 var unsg word    38 NULL bp+4    n
  3177                                  ;  201 var unsg word    38 NULL bp-2    e;
  3178 000020CB C8020000                 ENTER  2,0
  3179 000020CF 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3180 000020D3 0F821700                 jb  @@printIntU131
  3181 000020D7 8B4604                   mov ax, [bp+4]
  3182 000020DA BB0A00                   mov bx, 10
  3183 000020DD BA0000                   mov dx, 0
  3184 000020E0 F7F3                     div bx
  3185 000020E2 8946FE                   mov word [bp-2], ax
  3186                                  
  3187                                  ;-40     printIntU(e); }
  3188                                  
  3189 000020E5 FF76FE                   push word [bp-2]
  3190 000020E8 E8E0FF                   call printIntU
  3191 000020EB 83C402                   add  sp, 2
  3192                                  
  3193                                  ;-41     n = n % 10; //unsigned mod
  3194                                  
  3195                                  @@printIntU131:
  3196 000020EE 8B4604                   mov ax, [bp+4]
  3197 000020F1 BB0A00                   mov bx, 10
  3198 000020F4 BA0000                   mov dx, 0
  3199 000020F7 F7F3                     div bx
  3200 000020F9 89D0                     mov ax, dx
  3201 000020FB 894604                   mov word [bp+4], ax
  3202                                  
  3203                                  ;-42     n += '0'; prc(n);
  3204                                  
  3205 000020FE 83460430                 add  word [bp+4], 48
  3206 00002102 FF7604                   push word [bp+4]
  3207 00002105 E847FE                   call prc
  3208 00002108 83C402                   add  sp, 2
  3209                                  
  3210                                  ;-43 }
  3211                                  
  3212                                  
  3213                                  ;-44 
  3214                                  
  3215                                  
  3216                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  3217 0000210B C9                       LEAVE
  3218 0000210C C3                       ret
  3219                                  ; ENDP
  3220                                  
  3221                                  error1:  ; *** PROC ***
  3222                                  ;Function : error1, Number of local variables: 1
  3223                                  ;   # type sign width line used address name   list of local variables
  3224                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  3225 0000210D C8000000                 ENTER  0,0
  3226 00002111 66B801000000             mov eax, 1
  3227 00002117 A2[1800]                 mov byte [LIST], al
  3228 0000211A FF06[AB01]               inc  word [ErrorCount]
  3229                                  
  3230                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  3231                                  
  3232 0000211E 68[4621]                 push error1_0
  3233 00002121 E88CFE                   call prs
  3234 00002124 83C402                   add  sp, 2
  3235 00002127 FF7604                   push word [bp+4]
  3236 0000212A E883FE                   call prs
  3237 0000212D 83C402                   add  sp, 2
  3238                                  
  3239                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  3240                                  
  3241 00002130 68[6121]                 push error1_1
  3242 00002133 E87AFE                   call prs
  3243 00002136 83C402                   add  sp, 2
  3244 00002139 8D06[1900]               lea  ax, [Symbol]
  3245 0000213D 50                       push ax
  3246 0000213E E86FFE                   call prs
  3247 00002141 83C402                   add  sp, 2
  3248                                  
  3249                                  ;-48 int allowederror(){error1("not allowed here"); }
  3250 00002144 C9                       LEAVE
  3251 00002145 C3                       ret
  3252                                  ; ENDP
  3253 00002146 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3254 0000214F 6E657874206C696E65-
  3255 00002158 204552524F523A2000 
  3256 00002161 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3257 0000216A 2000               
  3258                                  
  3259                                  allowederror:  ; *** PROC ***
  3260 0000216C 68[7621]                 push allowederror_0
  3261 0000216F E89BFF                   call error1
  3262 00002172 83C402                   add  sp, 2
  3263                                  
  3264                                  ;-49 int addrerror()   {error1("address expected");} 
  3265                                  
  3266 00002175 C3                       ret
  3267                                  ; ENDP
  3268 00002176 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3269 0000217F 6564206865726500   
  3270                                  
  3271                                  addrerror:  ; *** PROC ***
  3272 00002187 68[9121]                 push addrerror_0
  3273 0000218A E880FF                   call error1
  3274 0000218D 83C402                   add  sp, 2
  3275                                  
  3276                                  ;-50 int immeerror()   {error1("immediate not allowed here");}
  3277                                  
  3278 00002190 C3                       ret
  3279                                  ; ENDP
  3280 00002191 616464726573732065-     addrerror_0 db "address expected",0
  3281 0000219A 7870656374656400   
  3282                                  
  3283                                  immeerror:  ; *** PROC ***
  3284 000021A2 68[AC21]                 push immeerror_0
  3285 000021A5 E865FF                   call error1
  3286 000021A8 83C402                   add  sp, 2
  3287                                  
  3288                                  ;-51 int implerror()   {error1("not implemented");}
  3289                                  
  3290 000021AB C3                       ret
  3291                                  ; ENDP
  3292 000021AC 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  3293 000021B5 206E6F7420616C6C6F-
  3294 000021BE 776564206865726500 
  3295                                  
  3296                                  implerror:  ; *** PROC ***
  3297 000021C7 68[D121]                 push implerror_0
  3298 000021CA E840FF                   call error1
  3299 000021CD 83C402                   add  sp, 2
  3300                                  
  3301                                  ;-52 int indexerror()  {error1("invalid index register");}
  3302                                  
  3303 000021D0 C3                       ret
  3304                                  ; ENDP
  3305 000021D1 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3306 000021DA 6D656E74656400     
  3307                                  
  3308                                  indexerror:  ; *** PROC ***
  3309 000021E1 68[EB21]                 push indexerror_0
  3310 000021E4 E826FF                   call error1
  3311 000021E7 83C402                   add  sp, 2
  3312                                  
  3313                                  ;-53 int invaloperror(){error1("invalid or no operands");}
  3314                                  
  3315 000021EA C3                       ret
  3316                                  ; ENDP
  3317 000021EB 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3318 000021F4 6E6465782072656769-
  3319 000021FD 7374657200         
  3320                                  
  3321                                  invaloperror:  ; *** PROC ***
  3322 00002202 68[0C22]                 push invaloperror_0
  3323 00002205 E805FF                   call error1
  3324 00002208 83C402                   add  sp, 2
  3325                                  
  3326                                  ;-54 int numbererror() {error1("number expected");}
  3327                                  
  3328 0000220B C3                       ret
  3329                                  ; ENDP
  3330 0000220C 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3331 00002215 72206E6F206F706572-
  3332 0000221E 616E647300         
  3333                                  
  3334                                  numbererror:  ; *** PROC ***
  3335 00002223 68[2D22]                 push numbererror_0
  3336 00002226 E8E4FE                   call error1
  3337 00002229 83C402                   add  sp, 2
  3338                                  
  3339                                  ;-55 int regmemerror() {error1("only register or memory allowed");}
  3340                                  
  3341 0000222C C3                       ret
  3342                                  ; ENDP
  3343 0000222D 6E756D626572206578-     numbererror_0 db "number expected",0
  3344 00002236 70656374656400     
  3345                                  
  3346                                  regmemerror:  ; *** PROC ***
  3347 0000223D 68[4722]                 push regmemerror_0
  3348 00002240 E8CAFE                   call error1
  3349 00002243 83C402                   add  sp, 2
  3350                                  
  3351                                  ;-56 int reg16error()  {error1("only reg16, no segreg allowed");}
  3352                                  
  3353 00002246 C3                       ret
  3354                                  ; ENDP
  3355 00002247 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3356 00002250 73746572206F72206D-
  3357 00002259 656D6F727920616C6C-
  3358 00002262 6F77656400         
  3359                                  
  3360                                  reg16error:  ; *** PROC ***
  3361 00002267 68[7122]                 push reg16error_0
  3362 0000226A E8A0FE                   call error1
  3363 0000226D 83C402                   add  sp, 2
  3364                                  
  3365                                  ;-57 int segregerror() {error1("segment register not allowed");}
  3366                                  
  3367 00002270 C3                       ret
  3368                                  ; ENDP
  3369 00002271 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3370 0000227A 362C206E6F20736567-
  3371 00002283 72656720616C6C6F77-
  3372 0000228C 656400             
  3373                                  
  3374                                  segregerror:  ; *** PROC ***
  3375 0000228F 68[9922]                 push segregerror_0
  3376 00002292 E878FE                   call error1
  3377 00002295 83C402                   add  sp, 2
  3378                                  
  3379                                  ;-58 int syntaxerror() {error1("syntax");}
  3380                                  
  3381 00002298 C3                       ret
  3382                                  ; ENDP
  3383 00002299 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3384 000022A2 65676973746572206E-
  3385 000022AB 6F7420616C6C6F7765-
  3386 000022B4 6400               
  3387                                  
  3388                                  syntaxerror:  ; *** PROC ***
  3389 000022B6 68[C022]                 push syntaxerror_0
  3390 000022B9 E851FE                   call error1
  3391 000022BC 83C402                   add  sp, 2
  3392                                  
  3393                                  ;-59 
  3394                                  
  3395                                  
  3396                                  ;-60 int errorexit(char *s) { error1(s); end1(1);}
  3397                                  
  3398 000022BF C3                       ret
  3399                                  ; ENDP
  3400 000022C0 73796E74617800          syntaxerror_0 db "syntax",0
  3401                                  
  3402                                  errorexit:  ; *** PROC ***
  3403                                  ;Function : errorexit, Number of local variables: 1
  3404                                  ;   # type sign width line used address name   list of local variables
  3405                                  ;  200 ptr sign byte    60 NULL bp+4    s;
  3406 000022C7 C8000000                 ENTER  0,0
  3407 000022CB FF7604                   push word [bp+4]
  3408 000022CE E83CFE                   call error1
  3409 000022D1 83C402                   add  sp, 2
  3410 000022D4 6A01                     push 1
  3411 000022D6 E85003                   call end1
  3412 000022D9 83C402                   add  sp, 2
  3413                                  
  3414                                  ;-61 int addrexit(){errorexit("illegal address");}
  3415 000022DC C9                       LEAVE
  3416 000022DD C3                       ret
  3417                                  ; ENDP
  3418                                  
  3419                                  addrexit:  ; *** PROC ***
  3420 000022DE 68[E822]                 push addrexit_0
  3421 000022E1 E8E3FF                   call errorexit
  3422 000022E4 83C402                   add  sp, 2
  3423                                  
  3424                                  ;-62 int internexit(){errorexit("intern compiler error");}
  3425                                  
  3426 000022E7 C3                       ret
  3427                                  ; ENDP
  3428 000022E8 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3429 000022F1 64647265737300     
  3430                                  
  3431                                  internexit:  ; *** PROC ***
  3432 000022F8 68[0223]                 push internexit_0
  3433 000022FB E8C9FF                   call errorexit
  3434 000022FE 83C402                   add  sp, 2
  3435 00002301 C3                       ret
  3436                                  ; ENDP
  3437 00002302 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3438 0000230B 6D70696C6572206572-
  3439 00002314 726F7200           
  3440                                  ;Back to main program: AS.C
  3441                                  
  3442                                  ;-8 #include "MAIN.C"
  3443                                  
  3444                                  ;Use include file: MAIN.C
  3445                                  
  3446                                  ;-1 int main() {
  3447                                  
  3448                                  
  3449                                  main:  ; *** PROC ***
  3450                                  
  3451                                  ;-2   getarg(); 
  3452                                  
  3453 00002318 E80A00                   call getarg
  3454                                  
  3455                                  ;-3   parse(); 
  3456                                  
  3457 0000231B E8DBEE                   call parse
  3458                                  
  3459                                  ;-4   epilog(); 
  3460                                  
  3461 0000231E E85C02                   call epilog
  3462                                  
  3463                                  ;-5   end1();
  3464                                  
  3465 00002321 E80503                   call end1
  3466                                  
  3467                                  ;-6 }
  3468                                  
  3469                                  
  3470                                  ;-7 
  3471                                  
  3472                                  
  3473                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3474                                  
  3475 00002324 C3                       ret
  3476                                  ; ENDP
  3477                                  
  3478                                  getarg:  ; *** PROC ***
  3479                                  
  3480                                  ;-9   arglen1=*arglen;
  3481                                  
  3482                                  ;Function : getarg, Number of local variables: 3
  3483                                  ;   # type sign width line used address name   list of local variables
  3484                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3485                                  ;  201 var sign word     8 NULL bp-4    i
  3486                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3487 00002325 C8060000                 ENTER  6,0
  3488 00002329 8B1E[5C0E]               mov bx, [arglen]
  3489 0000232D 8A07                     mov al, [bx]
  3490 0000232F B400                     mov ah, 0
  3491 00002331 8946FE                   mov word [bp-2], ax
  3492                                  
  3493                                  ;-10   if (arglen1==0) {
  3494                                  
  3495 00002334 8B46FE                   mov ax, [bp-2]
  3496 00002337 83F800                   cmp ax, 0
  3497 0000233A 0F851C00                 jne @@getarg132
  3498                                  
  3499                                  ;-11     cputs(Version1);
  3500                                  
  3501 0000233E 8D06[0300]               lea  ax, [Version1]
  3502 00002342 50                       push ax
  3503 00002343 E8B50B                   call cputs
  3504 00002346 83C402                   add  sp, 2
  3505                                  
  3506                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3507                                  
  3508 00002349 68[EA24]                 push getarg_0
  3509 0000234C E8AC0B                   call cputs
  3510 0000234F 83C402                   add  sp, 2
  3511                                  
  3512                                  ;-13     exitR(3);
  3513                                  
  3514 00002352 6A03                     push 3
  3515 00002354 E87F0D                   call exitR
  3516 00002357 83C402                   add  sp, 2
  3517                                  
  3518                                  ;-14   }
  3519                                  
  3520                                  
  3521                                  ;-15   i=arglen1+129; 
  3522                                  
  3523                                  @@getarg132:
  3524 0000235A 8B46FE                   mov ax, [bp-2]
  3525 0000235D 058100                   add ax, 129
  3526 00002360 8946FC                   mov word [bp-4], ax
  3527                                  
  3528                                  ;-16   *i=0;  
  3529                                  
  3530 00002363 66B800000000             mov eax, 0
  3531 00002369 8B5EFC                   mov  bx, [bp-4]
  3532 0000236C 8907                     mov  [bx], ax
  3533                                  
  3534                                  ;-17   arglen1--;
  3535                                  
  3536 0000236E FF4EFE                   dec  word [bp-2]
  3537                                  
  3538                                  ;-18   toupper(argv);
  3539                                  
  3540 00002371 FF36[5E0E]               push word [argv]
  3541 00002375 E8B10B                   call toupper
  3542 00002378 83C402                   add  sp, 2
  3543                                  
  3544                                  ;-19   
  3545                                  
  3546                                  
  3547                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3548                                  
  3549 0000237B FF36[5E0E]               push word [argv]
  3550 0000237F 8D06[DA00]               lea  ax, [namein]
  3551 00002383 50                       push ax
  3552 00002384 E8100C                   call strcpy
  3553 00002387 83C404                   add  sp, 4
  3554 0000238A 68[0F25]                 push getarg_1
  3555 0000238D 8D06[DA00]               lea  ax, [namein]
  3556 00002391 50                       push ax
  3557 00002392 E8C30C                   call strcat1
  3558 00002395 83C404                   add  sp, 4
  3559                                  
  3560                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3561                                  
  3562 00002398 FF36[5E0E]               push word [argv]
  3563 0000239C 8D06[1D01]               lea  ax, [namelst]
  3564 000023A0 50                       push ax
  3565 000023A1 E8F30B                   call strcpy
  3566 000023A4 83C404                   add  sp, 4
  3567 000023A7 68[1225]                 push getarg_2
  3568 000023AA 8D06[1D01]               lea  ax, [namelst]
  3569 000023AE 50                       push ax
  3570 000023AF E8A60C                   call strcat1
  3571 000023B2 83C404                   add  sp, 4
  3572                                  
  3573                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3574                                  
  3575 000023B5 FF36[5E0E]               push word [argv]
  3576 000023B9 8D06[6001]               lea  ax, [namebin]
  3577 000023BD 50                       push ax
  3578 000023BE E8D60B                   call strcpy
  3579 000023C1 83C404                   add  sp, 4
  3580 000023C4 68[1725]                 push getarg_3
  3581 000023C7 8D06[6001]               lea  ax, [namebin]
  3582 000023CB 50                       push ax
  3583 000023CC E8890C                   call strcat1
  3584 000023CF 83C404                   add  sp, 4
  3585                                  
  3586                                  ;-23 
  3587                                  
  3588                                  
  3589                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3590                                  
  3591 000023D2 66B801000000             mov eax, 1
  3592 000023D8 A2[1800]                 mov byte [LIST], al
  3593 000023DB 66B800000000             mov eax, 0
  3594 000023E1 A3[A901]                 mov word [DOS_ERR], ax
  3595 000023E4 66B800000000             mov eax, 0
  3596 000023EA A3[B001]                 mov word [PC], ax
  3597 000023ED 66B800000000             mov eax, 0
  3598 000023F3 A3[AB01]                 mov word [ErrorCount], ax
  3599                                  
  3600                                  ;-25   
  3601                                  
  3602                                  
  3603                                  ;-26   asm_fd=openR (namein);
  3604                                  
  3605 000023F6 8D06[DA00]               lea  ax, [namein]
  3606 000023FA 50                       push ax
  3607 000023FB E87F0C                   call openR
  3608 000023FE 83C402                   add  sp, 2
  3609 00002401 A3[A301]                 mov word [asm_fd], ax
  3610                                  
  3611                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3612                                  
  3613 00002404 A1[A901]                 mov ax, [DOS_ERR]
  3614 00002407 08C0                     or  al, al
  3615 00002409 0F841C00                 je @@getarg133
  3616 0000240D 68[1C25]                 push getarg_4
  3617 00002410 E8E80A                   call cputs
  3618 00002413 83C402                   add  sp, 2
  3619 00002416 8D06[DA00]               lea  ax, [namein]
  3620 0000241A 50                       push ax
  3621 0000241B E8DD0A                   call cputs
  3622 0000241E 83C402                   add  sp, 2
  3623 00002421 6A01                     push 1
  3624 00002423 E8B00C                   call exitR
  3625 00002426 83C402                   add  sp, 2
  3626                                  
  3627                                  ;-28   lst_fd=creatR(namelst);
  3628                                  
  3629                                  @@getarg133:
  3630 00002429 8D06[1D01]               lea  ax, [namelst]
  3631 0000242D 50                       push ax
  3632 0000242E E85B0C                   call creatR
  3633 00002431 83C402                   add  sp, 2
  3634 00002434 A3[A501]                 mov word [lst_fd], ax
  3635                                  
  3636                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3637                                  
  3638 00002437 A1[A901]                 mov ax, [DOS_ERR]
  3639 0000243A 08C0                     or  al, al
  3640 0000243C 0F841C00                 je @@getarg134
  3641 00002440 68[3225]                 push getarg_5
  3642 00002443 E8B50A                   call cputs
  3643 00002446 83C402                   add  sp, 2
  3644 00002449 8D06[1D01]               lea  ax, [namelst]
  3645 0000244D 50                       push ax
  3646 0000244E E8AA0A                   call cputs
  3647 00002451 83C402                   add  sp, 2
  3648 00002454 6A02                     push 2
  3649 00002456 E87D0C                   call exitR
  3650 00002459 83C402                   add  sp, 2
  3651                                  
  3652                                  ;-30   bin_fd=creatR(namebin);
  3653                                  
  3654                                  @@getarg134:
  3655 0000245C 8D06[6001]               lea  ax, [namebin]
  3656 00002460 50                       push ax
  3657 00002461 E8280C                   call creatR
  3658 00002464 83C402                   add  sp, 2
  3659 00002467 A3[A701]                 mov word [bin_fd], ax
  3660                                  
  3661                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3662                                  
  3663 0000246A A1[A901]                 mov ax, [DOS_ERR]
  3664 0000246D 08C0                     or  al, al
  3665 0000246F 0F841C00                 je @@getarg135
  3666 00002473 68[4925]                 push getarg_6
  3667 00002476 E8820A                   call cputs
  3668 00002479 83C402                   add  sp, 2
  3669 0000247C 8D06[6001]               lea  ax, [namebin]
  3670 00002480 50                       push ax
  3671 00002481 E8770A                   call cputs
  3672 00002484 83C402                   add  sp, 2
  3673 00002487 6A02                     push 2
  3674 00002489 E84A0C                   call exitR
  3675 0000248C 83C402                   add  sp, 2
  3676                                  
  3677                                  ;-32   
  3678                                  
  3679                                  
  3680                                  ;-33   prs(";");prs(Version1);
  3681                                  
  3682                                  @@getarg135:
  3683 0000248F 68[5F25]                 push getarg_7
  3684 00002492 E81BFB                   call prs
  3685 00002495 83C402                   add  sp, 2
  3686 00002498 8D06[0300]               lea  ax, [Version1]
  3687 0000249C 50                       push ax
  3688 0000249D E810FB                   call prs
  3689 000024A0 83C402                   add  sp, 2
  3690                                  
  3691                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3692                                  
  3693 000024A3 68[6125]                 push getarg_8
  3694 000024A6 E807FB                   call prs
  3695 000024A9 83C402                   add  sp, 2
  3696 000024AC 8D06[DA00]               lea  ax, [namein]
  3697 000024B0 50                       push ax
  3698 000024B1 E8FCFA                   call prs
  3699 000024B4 83C402                   add  sp, 2
  3700 000024B7 68[6C25]                 push getarg_9
  3701 000024BA E8F3FA                   call prs
  3702 000024BD 83C402                   add  sp, 2
  3703 000024C0 8D06[1D01]               lea  ax, [namelst]
  3704 000024C4 50                       push ax
  3705 000024C5 E8E8FA                   call prs
  3706 000024C8 83C402                   add  sp, 2
  3707                                  
  3708                                  ;-35   prs(", "); prs(namebin);
  3709                                  
  3710 000024CB 68[7725]                 push getarg_10
  3711 000024CE E8DFFA                   call prs
  3712 000024D1 83C402                   add  sp, 2
  3713 000024D4 8D06[6001]               lea  ax, [namebin]
  3714 000024D8 50                       push ax
  3715 000024D9 E8D4FA                   call prs
  3716 000024DC 83C402                   add  sp, 2
  3717                                  
  3718                                  ;-36   prs("\n");
  3719                                  
  3720 000024DF 68[7A25]                 push getarg_11
  3721 000024E2 E8CBFA                   call prs
  3722 000024E5 83C402                   add  sp, 2
  3723                                  
  3724                                  ;-37 }
  3725                                  
  3726                                  
  3727                                  ;-38 int epilog() { int i; int j; char c;
  3728 000024E8 C9                       LEAVE
  3729 000024E9 C3                       ret
  3730                                  ; ENDP
  3731 000024EA 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3732 000024F3 41532E434F4D206669-
  3733 000024FC 6C656E616D65205B77-
  3734 00002505 2F6F202E535D203A20-
  3735 0000250E 00                 
  3736 0000250F 2E5300                  getarg_1 db ".S",0
  3737 00002512 2E4C535400              getarg_2 db ".LST",0
  3738 00002517 2E434F4D00              getarg_3 db ".COM",0
  3739 0000251C 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3740 00002525 6C65206D697373696E-
  3741 0000252E 673A2000           
  3742 00002532 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3743 0000253B 206E6F742063726561-
  3744 00002544 74653A2000         
  3745 00002549 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3746 00002552 6E6F74206372656174-
  3747 0000255B 653A2000           
  3748 0000255F 3B00                    getarg_7 db ";",0
  3749 00002561 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3750 0000256A 2000               
  3751 0000256C 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3752 00002575 2000               
  3753 00002577 2C2000                  getarg_10 db ", ",0
  3754 0000257A 5C6E00                  getarg_11 db "\n",0
  3755                                  
  3756                                  epilog:  ; *** PROC ***
  3757                                  
  3758                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3759                                  
  3760                                  ;Function : epilog, Number of local variables: 3
  3761                                  ;   # type sign width line used address name   list of local variables
  3762                                  ;  200 var sign word    38 NULL bp-2    i
  3763                                  ;  201 var sign word    38 NULL bp-4    j
  3764                                  ;  202 var sign byte    38 NULL bp-6    c;
  3765 0000257D C8060000                 ENTER  6,0
  3766 00002581 68[F725]                 push epilog_0
  3767 00002584 E829FA                   call prs
  3768 00002587 83C402                   add  sp, 2
  3769 0000258A FF36[AB01]               push word [ErrorCount]
  3770 0000258E E83AFB                   call printIntU
  3771 00002591 83C402                   add  sp, 2
  3772                                  
  3773                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3774                                  
  3775 00002594 A1[AB01]                 mov ax, [ErrorCount]
  3776 00002597 08C0                     or  al, al
  3777 00002599 0F840900                 je @@epilog136
  3778 0000259D 68[0726]                 push epilog_1
  3779 000025A0 E80DFA                   call prs
  3780 000025A3 83C402                   add  sp, 2
  3781                                  
  3782                                  ;-41 /*    
  3783                                  
  3784                                  
  3785                                  ;-42   prs(", Label & Var: ");
  3786                                  
  3787                                  
  3788                                  ;-43   if (LabelMaxIx) {
  3789                                  
  3790                                  
  3791                                  ;-44     i = 1;
  3792                                  
  3793                                  
  3794                                  ;-45     LabelNamePtr= &LabelNames;
  3795                                  
  3796                                  
  3797                                  ;-46     do {
  3798                                  
  3799                                  
  3800                                  ;-47       prs(LabelNamePtr); prc(' ');
  3801                                  
  3802                                  
  3803                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3804                                  
  3805                                  
  3806                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3807                                  
  3808                                  
  3809                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3810                                  
  3811                                  
  3812                                  ;-51       LabelNamePtr++;
  3813                                  
  3814                                  
  3815                                  ;-52       i++;
  3816                                  
  3817                                  
  3818                                  ;-53     } while (i <= LabelMaxIx);
  3819                                  
  3820                                  
  3821                                  ;-54   }
  3822                                  
  3823                                  
  3824                                  ;-55 */  
  3825                                  
  3826                                  
  3827                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3828                                  
  3829                                  @@epilog136:
  3830 000025A6 68[1526]                 push epilog_2
  3831 000025A9 E804FA                   call prs
  3832 000025AC 83C402                   add  sp, 2
  3833 000025AF FF36[5A0E]               push word [BinLen]
  3834 000025B3 E815FB                   call printIntU
  3835 000025B6 83C402                   add  sp, 2
  3836 000025B9 68[2126]                 push epilog_3
  3837 000025BC E8F1F9                   call prs
  3838 000025BF 83C402                   add  sp, 2
  3839                                  
  3840                                  ;-57 //  i=0;
  3841                                  
  3842                                  
  3843                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  3844                                  
  3845                                  
  3846                                  ;-59 //  } while (i < BinLen);
  3847                                  
  3848                                  
  3849                                  ;-60   i=0;
  3850                                  
  3851 000025C2 66B800000000             mov eax, 0
  3852 000025C8 8946FE                   mov word [bp-2], ax
  3853                                  
  3854                                  ;-61   do {
  3855                                  
  3856                                  @@epilog137:
  3857                                  
  3858                                  ;-62     c = FileBin[i];
  3859                                  
  3860 000025CB 8B5EFE                   mov bx, [bp-2]
  3861 000025CE 8A87[8A06]               mov al, [FileBin + bx]
  3862 000025D2 8846FA                   mov byte [bp-6], al
  3863                                  
  3864                                  ;-63     fputcR(c, bin_fd);
  3865                                  
  3866 000025D5 FF36[A701]               push word [bin_fd]
  3867 000025D9 8A46FA                   mov al, byte [bp-6]
  3868 000025DC B400                     mov ah, 0
  3869 000025DE 50                       push ax
  3870 000025DF E8D10A                   call fputcR
  3871 000025E2 83C404                   add  sp, 4
  3872                                  
  3873                                  ;-64     i++;
  3874                                  
  3875 000025E5 FF46FE                   inc  word [bp-2]
  3876                                  
  3877                                  ;-65   } while (i < BinLen);
  3878                                  
  3879 000025E8 8B46FE                   mov ax, [bp-2]
  3880 000025EB 3B06[5A0E]               cmp ax, [BinLen]
  3881 000025EF 0F8D0200                 jge @@epilog138
  3882 000025F3 EBD6                     jmp @@epilog137
  3883                                  @@epilog138:
  3884                                  
  3885                                  ;-66 }
  3886                                  
  3887                                  
  3888                                  ;-67 int end1(int n) {
  3889 000025F5 C9                       LEAVE
  3890 000025F6 C3                       ret
  3891                                  ; ENDP
  3892 000025F7 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  3893 00002600 726F72733A2000     
  3894 00002607 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  3895 00002610 2A2A2A2000         
  3896 00002615 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  3897 0000261E 652000             
  3898 00002621 2062797465732E00        epilog_3 db " bytes.",0
  3899                                  
  3900                                  end1:  ; *** PROC ***
  3901                                  
  3902                                  ;-68   fcloseR(asm_fd);
  3903                                  
  3904                                  ;Function : end1, Number of local variables: 1
  3905                                  ;   # type sign width line used address name   list of local variables
  3906                                  ;  200 var sign word    67 NULL bp+4    n;
  3907 00002629 C8000000                 ENTER  0,0
  3908 0000262D FF36[A301]               push word [asm_fd]
  3909 00002631 E8940A                   call fcloseR
  3910 00002634 83C402                   add  sp, 2
  3911                                  
  3912                                  ;-69   fcloseR(lst_fd);
  3913                                  
  3914 00002637 FF36[A501]               push word [lst_fd]
  3915 0000263B E88A0A                   call fcloseR
  3916 0000263E 83C402                   add  sp, 2
  3917                                  
  3918                                  ;-70   fcloseR(bin_fd);
  3919                                  
  3920 00002641 FF36[A701]               push word [bin_fd]
  3921 00002645 E8800A                   call fcloseR
  3922 00002648 83C402                   add  sp, 2
  3923                                  
  3924                                  ;-71   exitR(n);
  3925                                  
  3926 0000264B FF7604                   push word [bp+4]
  3927 0000264E E8850A                   call exitR
  3928 00002651 83C402                   add  sp, 2
  3929                                  
  3930                                  ;-72 }
  3931 00002654 C9                       LEAVE
  3932 00002655 C3                       ret
  3933                                  ; ENDP
  3934                                  ;Back to main program: AS.C
  3935                                  
  3936                                  ;-9 #include "GENCODE.C"
  3937                                  
  3938                                  ;Use include file: GENCODE.C
  3939                                  
  3940                                  ;-1 // generate code
  3941                                  
  3942                                  
  3943                                  ;-2 int getCodes() {
  3944                                  
  3945                                  
  3946                                  getCodes:  ; *** PROC ***
  3947                                  
  3948                                  ;-3   OpCodePtr ++; Code1 = *OpCodePtr;
  3949                                  
  3950 00002656 FF06[D101]               inc  word [OpCodePtr]
  3951 0000265A 8B1E[D101]               mov bx, [OpCodePtr]
  3952 0000265E 8A07                     mov al, [bx]
  3953 00002660 B400                     mov ah, 0
  3954 00002662 A2[B901]                 mov byte [Code1], al
  3955                                  
  3956                                  ;-4   OpCodePtr ++; Code2 = *OpCodePtr;
  3957                                  
  3958 00002665 FF06[D101]               inc  word [OpCodePtr]
  3959 00002669 8B1E[D101]               mov bx, [OpCodePtr]
  3960 0000266D 8A07                     mov al, [bx]
  3961 0000266F B400                     mov ah, 0
  3962 00002671 A2[BA01]                 mov byte [Code2], al
  3963                                  
  3964                                  ;-5   OpCodePtr ++; Code3 = *OpCodePtr;
  3965                                  
  3966 00002674 FF06[D101]               inc  word [OpCodePtr]
  3967 00002678 8B1E[D101]               mov bx, [OpCodePtr]
  3968 0000267C 8A07                     mov al, [bx]
  3969 0000267E B400                     mov ah, 0
  3970 00002680 A2[BB01]                 mov byte [Code3], al
  3971                                  
  3972                                  ;-6 }
  3973                                  
  3974                                  
  3975                                  ;-7 int gen66h() {genCode8(0x66);
  3976                                  
  3977 00002683 C3                       ret
  3978                                  ; ENDP
  3979                                  
  3980                                  gen66h:  ; *** PROC ***
  3981 00002684 6A66                     push 102
  3982 00002686 E83B00                   call genCode8
  3983 00002689 83C402                   add  sp, 2
  3984                                  
  3985                                  ;-8 }
  3986                                  
  3987                                  
  3988                                  ;-9 int genCode(char c, char d) {
  3989                                  
  3990 0000268C C3                       ret
  3991                                  ; ENDP
  3992                                  
  3993                                  genCode:  ; *** PROC ***
  3994                                  
  3995                                  ;-10     c = c + d;
  3996                                  
  3997                                  ;Function : genCode, Number of local variables: 2
  3998                                  ;   # type sign width line used address name   list of local variables
  3999                                  ;  200 var sign byte     9 NULL bp+4    c
  4000                                  ;  201 var sign byte     9 NULL bp+6    d;
  4001 0000268D C8000000                 ENTER  0,0
  4002 00002691 8A4604                   mov al, [bp+4]
  4003 00002694 024606                   add al, [bp+6]
  4004 00002697 884604                   mov byte [bp+4], al
  4005                                  
  4006                                  ;-11     genCode8(c);
  4007                                  
  4008 0000269A 8A4604                   mov al, byte [bp+4]
  4009 0000269D B400                     mov ah, 0
  4010 0000269F 50                       push ax
  4011 000026A0 E82100                   call genCode8
  4012 000026A3 83C402                   add  sp, 2
  4013                                  
  4014                                  ;-12 }    
  4015                                  
  4016                                  
  4017                                  ;-13 int genCodeW(char c) {
  4018 000026A6 C9                       LEAVE
  4019 000026A7 C3                       ret
  4020                                  ; ENDP
  4021                                  
  4022                                  genCodeW:  ; *** PROC ***
  4023                                  
  4024                                  ;-14     c = c + wflag;  
  4025                                  
  4026                                  ;Function : genCodeW, Number of local variables: 1
  4027                                  ;   # type sign width line used address name   list of local variables
  4028                                  ;  200 var sign byte    13 NULL bp+4    c;
  4029 000026A8 C8000000                 ENTER  0,0
  4030 000026AC 8A4604                   mov al, [bp+4]
  4031 000026AF 0206[C101]               add al, [wflag]
  4032 000026B3 884604                   mov byte [bp+4], al
  4033                                  
  4034                                  ;-15     genCode8(c);
  4035                                  
  4036 000026B6 8A4604                   mov al, byte [bp+4]
  4037 000026B9 B400                     mov ah, 0
  4038 000026BB 50                       push ax
  4039 000026BC E80500                   call genCode8
  4040 000026BF 83C402                   add  sp, 2
  4041                                  
  4042                                  ;-16 }
  4043                                  
  4044                                  
  4045                                  ;-17 int genCode8(char c) {
  4046 000026C2 C9                       LEAVE
  4047 000026C3 C3                       ret
  4048                                  ; ENDP
  4049                                  
  4050                                  genCode8:  ; *** PROC ***
  4051                                  
  4052                                  ;-18 //set: BinLen++, OpPrintIndex++
  4053                                  
  4054                                  
  4055                                  ;-19   FileBin[BinLen]=c;
  4056                                  
  4057                                  ;Function : genCode8, Number of local variables: 1
  4058                                  ;   # type sign width line used address name   list of local variables
  4059                                  ;  200 var sign byte    17 NULL bp+4    c;
  4060 000026C4 C8000000                 ENTER  0,0
  4061 000026C8 8A4604                   mov al, [bp+4]
  4062 000026CB 8B1E[5A0E]               mov bx, [BinLen]
  4063 000026CF 8887[8A06]               mov [FileBin+bx], al
  4064                                  
  4065                                  ;-20   BinLen++;
  4066                                  
  4067 000026D3 FF06[5A0E]               inc  word [BinLen]
  4068                                  
  4069                                  ;-21   PC++;
  4070                                  
  4071 000026D7 FF06[B001]               inc  word [PC]
  4072                                  
  4073                                  ;-22   if (BinLen >= FILEBINMAX) errorexit("COM file to long");
  4074                                  
  4075 000026DB A1[5A0E]                 mov ax, [BinLen]
  4076 000026DE 3DD007                   cmp ax, 2000 ;unsigned : 0
  4077 000026E1 0F820900                 jb  @@genCode8139
  4078 000026E5 68[0927]                 push genCode8_0
  4079 000026E8 E8DCFB                   call errorexit
  4080 000026EB 83C402                   add  sp, 2
  4081                                  
  4082                                  ;-23   if (OpPrintIndex < OPMAXLEN) {
  4083                                  
  4084                                  @@genCode8139:
  4085 000026EE A1[CF01]                 mov ax, [OpPrintIndex]
  4086 000026F1 83F805                   cmp ax, 5
  4087 000026F4 0F8D0F00                 jge @@genCode8140
  4088                                  
  4089                                  ;-24     OpPos[OpPrintIndex]=c;
  4090                                  
  4091 000026F8 8A4604                   mov al, [bp+4]
  4092 000026FB 8B1E[CF01]               mov bx, [OpPrintIndex]
  4093 000026FF 8887[CA01]               mov [OpPos+bx], al
  4094                                  
  4095                                  ;-25     OpPrintIndex++;
  4096                                  
  4097 00002703 FF06[CF01]               inc  word [OpPrintIndex]
  4098                                  
  4099                                  ;-26   }
  4100                                  
  4101                                  
  4102                                  ;-27 }
  4103                                  
  4104                                  @@genCode8140:
  4105                                  
  4106                                  ;-28 int genCode16(unsigned int i) {
  4107 00002707 C9                       LEAVE
  4108 00002708 C3                       ret
  4109                                  ; ENDP
  4110 00002709 434F4D2066696C6520-     genCode8_0 db "COM file to long",0
  4111 00002712 746F206C6F6E6700   
  4112                                  
  4113                                  genCode16:  ; *** PROC ***
  4114                                  
  4115                                  ;-29   genCode8(i); i=i >> 8;
  4116                                  
  4117                                  ;Function : genCode16, Number of local variables: 1
  4118                                  ;   # type sign width line used address name   list of local variables
  4119                                  ;  200 var unsg word    28 NULL bp+4    i;
  4120 0000271A C8000000                 ENTER  0,0
  4121 0000271E FF7604                   push word [bp+4]
  4122 00002721 E8A0FF                   call genCode8
  4123 00002724 83C402                   add  sp, 2
  4124 00002727 8B4604                   mov ax, [bp+4]
  4125 0000272A C1E808                   shr ax, 8
  4126 0000272D 894604                   mov word [bp+4], ax
  4127                                  
  4128                                  ;-30   genCode8(i);
  4129                                  
  4130 00002730 FF7604                   push word [bp+4]
  4131 00002733 E88EFF                   call genCode8
  4132 00002736 83C402                   add  sp, 2
  4133                                  
  4134                                  ;-31 }
  4135                                  
  4136                                  
  4137                                  ;-32 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase, isDirect
  4138 00002739 C9                       LEAVE
  4139 0000273A C3                       ret
  4140                                  ; ENDP
  4141                                  
  4142                                  writeEA:  ; *** PROC ***
  4143                                  
  4144                                  ;-33 //mod-byte: mode76, reg/opcode543, r/m210    
  4145                                  
  4146                                  
  4147                                  ;-34   char len;
  4148                                  
  4149                                  
  4150                                  ;-35   len=0;
  4151                                  
  4152                                  ;Function : writeEA, Number of local variables: 2
  4153                                  ;   # type sign width line used address name   list of local variables
  4154                                  ;  200 var sign byte    32 NULL bp+4    xxx
  4155                                  ;  201 var sign byte    34 NULL bp-2    len;
  4156 0000273B C8020000                 ENTER  2,0
  4157 0000273F 66B800000000             mov eax, 0
  4158 00002745 8846FE                   mov byte [bp-2], al
  4159                                  
  4160                                  ;-36   xxx = xxx << 3;//in reg/opcode field
  4161                                  
  4162 00002748 8A4604                   mov al, [bp+4]
  4163 0000274B C0E003                   shl al, 3
  4164 0000274E 884604                   mov byte [bp+4], al
  4165                                  
  4166                                  ;-37 //  prs("\nxxx:"); printhex8a(xxx);
  4167                                  
  4168                                  
  4169                                  ;-38   if (Op1 ==   0) addrexit();
  4170                                  
  4171 00002751 A0[B601]                 mov al, [Op1]
  4172 00002754 3C00                     cmp al, 0
  4173 00002756 0F850300                 jne @@writeEA141
  4174 0000275A E881FB                   call addrexit
  4175                                  
  4176                                  ;-39   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  4177                                  
  4178                                  @@writeEA141:
  4179 0000275D A0[B601]                 mov al, [Op1]
  4180 00002760 3C02                     cmp al, 2
  4181 00002762 0F850E00                 jne @@writeEA142
  4182 00002766 804E04C0                 or  byte [bp+4], 192
  4183 0000276A 8A4604                   mov al, [bp+4]
  4184 0000276D 0206[BC01]               add al, [RegNo]
  4185 00002771 884604                   mov byte [bp+4], al
  4186                                  
  4187                                  ;-40   if (Op1 == ADR) error1("writeEA");           
  4188                                  
  4189                                  @@writeEA142:
  4190 00002774 A0[B601]                 mov al, [Op1]
  4191 00002777 3C03                     cmp al, 3
  4192 00002779 0F850900                 jne @@writeEA143
  4193 0000277D 68[4228]                 push writeEA_0
  4194 00002780 E88AF9                   call error1
  4195 00002783 83C402                   add  sp, 2
  4196                                  
  4197                                  ;-41   if (Op1 == MEM) {
  4198                                  
  4199                                  @@writeEA143:
  4200 00002786 A0[B601]                 mov al, [Op1]
  4201 00002789 3C04                     cmp al, 4
  4202 0000278B 0F857F00                 jne @@writeEA144
  4203                                  
  4204                                  ;-42     if (isDirect) {
  4205                                  
  4206 0000278F A0[C501]                 mov al, [isDirect]
  4207 00002792 08C0                     or  al, al
  4208 00002794 0F841000                 je @@writeEA145
  4209                                  
  4210                                  ;-43         xxx |= 6;
  4211                                  
  4212 00002798 804E0406                 or  byte [bp+4], 6
  4213                                  
  4214                                  ;-44         len = 2;
  4215                                  
  4216 0000279C 66B802000000             mov eax, 2
  4217 000027A2 8846FE                   mov byte [bp-2], al
  4218                                  
  4219                                  ;-45     }
  4220                                  
  4221                                  
  4222                                  ;-46     else { 
  4223                                  
  4224 000027A5 E96600                   jmp @@writeEA146
  4225                                  @@writeEA145:
  4226                                  
  4227                                  ;-47       xxx = xxx + regindexbase;   
  4228                                  
  4229 000027A8 8A4604                   mov al, [bp+4]
  4230 000027AB 0206[C401]               add al, [regindexbase]
  4231 000027AF 884604                   mov byte [bp+4], al
  4232                                  
  4233                                  ;-48       if (regindexbase == 6) {//make [BP+00]
  4234                                  
  4235 000027B2 A0[C401]                 mov al, [regindexbase]
  4236 000027B5 3C06                     cmp al, 6
  4237 000027B7 0F851700                 jne @@writeEA147
  4238                                  
  4239                                  ;-49         len=1;
  4240                                  
  4241 000027BB 66B801000000             mov eax, 1
  4242 000027C1 8846FE                   mov byte [bp-2], al
  4243                                  
  4244                                  ;-50         if (disp == 0) xxx |= 0x40;
  4245                                  
  4246 000027C4 A1[C601]                 mov ax, [disp]
  4247 000027C7 83F800                   cmp ax, 0
  4248 000027CA 0F850400                 jne @@writeEA148
  4249 000027CE 804E0440                 or  byte [bp+4], 64
  4250                                  
  4251                                  ;-51       }
  4252                                  
  4253                                  @@writeEA148:
  4254                                  
  4255                                  ;-52 
  4256                                  
  4257                                  
  4258                                  ;-53       if (disp) {
  4259                                  
  4260                                  @@writeEA147:
  4261 000027D2 A1[C601]                 mov ax, [disp]
  4262 000027D5 08C0                     or  al, al
  4263 000027D7 0F843300                 je @@writeEA149
  4264                                  
  4265                                  ;-54         ax = disp;
  4266                                  
  4267 000027DB A1[C601]                 mov  ax, [disp]
  4268                                  
  4269                                  ;-55         if(ax > 127) len=2;
  4270                                  
  4271 000027DE 83F87F                   cmp  ax, 127
  4272 000027E1 0F8E0C00                 jle @@writeEA150
  4273 000027E5 66B802000000             mov eax, 2
  4274 000027EB 8846FE                   mov byte [bp-2], al
  4275                                  
  4276                                  ;-56         else len=1;
  4277                                  
  4278 000027EE E90900                   jmp @@writeEA151
  4279                                  @@writeEA150:
  4280 000027F1 66B801000000             mov eax, 1
  4281 000027F7 8846FE                   mov byte [bp-2], al
  4282                                  
  4283                                  ;-57         if (len == 1) xxx |= 0x40;
  4284                                  
  4285                                  @@writeEA151:
  4286 000027FA 8A46FE                   mov al, [bp-2]
  4287 000027FD 3C01                     cmp al, 1
  4288 000027FF 0F850700                 jne @@writeEA152
  4289 00002803 804E0440                 or  byte [bp+4], 64
  4290                                  
  4291                                  ;-58         else xxx |= 0x80;
  4292                                  
  4293 00002807 E90400                   jmp @@writeEA153
  4294                                  @@writeEA152:
  4295 0000280A 804E0480                 or  byte [bp+4], 128
  4296                                  
  4297                                  ;-59       }
  4298                                  
  4299                                  @@writeEA153:
  4300                                  
  4301                                  ;-60     }
  4302                                  
  4303                                  @@writeEA149:
  4304                                  
  4305                                  ;-61   }
  4306                                  
  4307                                  @@writeEA146:
  4308                                  
  4309                                  ;-62   genCode8(xxx);// gen second byte
  4310                                  
  4311                                  @@writeEA144:
  4312 0000280E 8A4604                   mov al, byte [bp+4]
  4313 00002811 B400                     mov ah, 0
  4314 00002813 50                       push ax
  4315 00002814 E8ADFE                   call genCode8
  4316 00002817 83C402                   add  sp, 2
  4317                                  
  4318                                  ;-63   if (len == 1) genCode8 (disp);
  4319                                  
  4320 0000281A 8A46FE                   mov al, [bp-2]
  4321 0000281D 3C01                     cmp al, 1
  4322 0000281F 0F850A00                 jne @@writeEA154
  4323 00002823 FF36[C601]               push word [disp]
  4324 00002827 E89AFE                   call genCode8
  4325 0000282A 83C402                   add  sp, 2
  4326                                  
  4327                                  ;-64   if (len == 2) genCode16(disp);
  4328                                  
  4329                                  @@writeEA154:
  4330 0000282D 8A46FE                   mov al, [bp-2]
  4331 00002830 3C02                     cmp al, 2
  4332 00002832 0F850A00                 jne @@writeEA155
  4333 00002836 FF36[C601]               push word [disp]
  4334 0000283A E8DDFE                   call genCode16
  4335 0000283D 83C402                   add  sp, 2
  4336                                  
  4337                                  ;-65 }
  4338                                  
  4339                                  @@writeEA155:
  4340                                  
  4341                                  ;-66 
  4342                                  
  4343                                  
  4344                                  ;-67 int genImmediate() {
  4345 00002840 C9                       LEAVE
  4346 00002841 C3                       ret
  4347                                  ; ENDP
  4348 00002842 7772697465454100        writeEA_0 db "writeEA",0
  4349                                  
  4350                                  genImmediate:  ; *** PROC ***
  4351                                  
  4352                                  ;-68     if (wflag) genCode16(imme);
  4353                                  
  4354 0000284A A0[C101]                 mov al, [wflag]
  4355 0000284D 08C0                     or  al, al
  4356 0000284F 0F840D00                 je @@genImmediate156
  4357 00002853 FF36[C801]               push word [imme]
  4358 00002857 E8C0FE                   call genCode16
  4359 0000285A 83C402                   add  sp, 2
  4360                                  
  4361                                  ;-69     else       genCode8 (imme);
  4362                                  
  4363 0000285D E90A00                   jmp @@genImmediate157
  4364                                  @@genImmediate156:
  4365 00002860 FF36[C801]               push word [imme]
  4366 00002864 E85DFE                   call genCode8
  4367 00002867 83C402                   add  sp, 2
  4368                                  
  4369                                  ;-70 }    
  4370                                  
  4371                                  @@genImmediate157:
  4372 0000286A C3                       ret
  4373                                  ; ENDP
  4374                                  ;Back to main program: AS.C
  4375                                  
  4376                                  ;-10 
  4377                                  
  4378                                  
  4379                                  ;-11 int process() { 
  4380                                  
  4381                                  
  4382                                  process:  ; *** PROC ***
  4383                                  
  4384                                  ;-12     char c;
  4385                                  
  4386                                  
  4387                                  ;-13   getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4388                                  
  4389                                  ;Function : process, Number of local variables: 1
  4390                                  ;   # type sign width line used address name   list of local variables
  4391                                  ;  200 var sign byte    12 NULL bp-2    c;
  4392 0000286B C8020000                 ENTER  2,0
  4393 0000286F E871EA                   call getTokeType
  4394                                  
  4395                                  ;-14   OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4396                                  
  4397 00002872 E8C1ED                   call getCodeSize
  4398 00002875 A2[C001]                 mov byte [OpSize], al
  4399                                  
  4400                                  ;-15   getCodes();//set: Code1, Code2, Code3
  4401                                  
  4402 00002878 E8DBFD                   call getCodes
  4403                                  
  4404                                  ;-16 
  4405                                  
  4406                                  
  4407                                  ;-17   if (CodeType ==  1) {//1 byte opcode
  4408                                  
  4409 0000287B A0[B801]                 mov al, [CodeType]
  4410 0000287E 3C01                     cmp al, 1
  4411 00002880 0F850F00                 jne @@process158
  4412                                  
  4413                                  ;-18     genCode8(Code1);
  4414                                  
  4415 00002884 A0[B901]                 mov al, byte [Code1]
  4416 00002887 B400                     mov ah, 0
  4417 00002889 50                       push ax
  4418 0000288A E837FE                   call genCode8
  4419 0000288D 83C402                   add  sp, 2
  4420                                  
  4421                                  ;-19     return;
  4422                                  
  4423 00002890 E9FC01                   jmp @@retn
  4424                                  
  4425                                  ;-20   }
  4426                                  
  4427                                  
  4428                                  ;-21   
  4429                                  
  4430                                  
  4431                                  ;-22   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4432                                  
  4433                                  @@process158:
  4434 00002893 A0[B801]                 mov al, [CodeType]
  4435 00002896 3C02                     cmp al, 2
  4436 00002898 0F858400                 jne @@process159
  4437                                  
  4438                                  ;-23     checkOp();
  4439                                  
  4440 0000289C E81602                   call checkOp
  4441                                  
  4442                                  ;-24     if (Code2 <= 1) {//inc,dec
  4443                                  
  4444 0000289F A0[BA01]                 mov al, [Code2]
  4445 000028A2 3C01                     cmp al, 1
  4446 000028A4 0F8F4500                 jg  @@process160
  4447                                  
  4448                                  ;-25   	if (Op1 == REG) {
  4449                                  
  4450 000028A8 A0[B601]                 mov al, [Op1]
  4451 000028AB 3C02                     cmp al, 2
  4452 000028AD 0F853C00                 jne @@process161
  4453                                  
  4454                                  ;-26       if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
  4455                                  
  4456 000028B1 A0[BE01]                 mov al, [RegType]
  4457 000028B4 3C02                     cmp al, 2
  4458 000028B6 0F851500                 jne @@process162
  4459 000028BA A0[BC01]                 mov al, byte [RegNo]
  4460 000028BD B400                     mov ah, 0
  4461 000028BF 50                       push ax
  4462 000028C0 A0[BB01]                 mov al, byte [Code3]
  4463 000028C3 B400                     mov ah, 0
  4464 000028C5 50                       push ax
  4465 000028C6 E8C4FD                   call genCode
  4466 000028C9 83C404                   add  sp, 4
  4467 000028CC E9C001                   jmp @@retn
  4468                                  
  4469                                  ;-27       if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
  4470                                  
  4471                                  @@process162:
  4472 000028CF A0[BE01]                 mov al, [RegType]
  4473 000028D2 3C03                     cmp al, 3
  4474 000028D4 0F851500                 jne @@process163
  4475 000028D8 A0[BC01]                 mov al, byte [RegNo]
  4476 000028DB B400                     mov ah, 0
  4477 000028DD 50                       push ax
  4478 000028DE A0[BB01]                 mov al, byte [Code3]
  4479 000028E1 B400                     mov ah, 0
  4480 000028E3 50                       push ax
  4481 000028E4 E8A6FD                   call genCode
  4482 000028E7 83C404                   add  sp, 4
  4483 000028EA E9A201                   jmp @@retn
  4484                                  
  4485                                  ;-28       }
  4486                                  
  4487                                  @@process163:
  4488                                  
  4489                                  ;-29     }
  4490                                  
  4491                                  @@process161:
  4492                                  
  4493                                  ;-30     if (Code2 == 5) {//imul extension?
  4494                                  
  4495                                  @@process160:
  4496 000028ED A0[BA01]                 mov al, [Code2]
  4497 000028F0 3C05                     cmp al, 5
  4498 000028F2 0F850F00                 jne @@process164
  4499                                  
  4500                                  ;-31       getTokeType();
  4501                                  
  4502 000028F6 E8EAE9                   call getTokeType
  4503                                  
  4504                                  ;-32       if (TokeType) implerror();
  4505                                  
  4506 000028F9 A0[B501]                 mov al, [TokeType]
  4507 000028FC 08C0                     or  al, al
  4508 000028FE 0F840300                 je @@process165
  4509 00002902 E8C2F8                   call implerror
  4510                                  
  4511                                  ;-33     }
  4512                                  
  4513                                  @@process165:
  4514                                  
  4515                                  ;-34     genCodeW(Code1);
  4516                                  
  4517                                  @@process164:
  4518 00002905 A0[B901]                 mov al, byte [Code1]
  4519 00002908 B400                     mov ah, 0
  4520 0000290A 50                       push ax
  4521 0000290B E89AFD                   call genCodeW
  4522 0000290E 83C402                   add  sp, 2
  4523                                  
  4524                                  ;-35     writeEA(Code2);
  4525                                  
  4526 00002911 A0[BA01]                 mov al, byte [Code2]
  4527 00002914 B400                     mov ah, 0
  4528 00002916 50                       push ax
  4529 00002917 E821FE                   call writeEA
  4530 0000291A 83C402                   add  sp, 2
  4531                                  
  4532                                  ;-36     return;
  4533                                  
  4534 0000291D E96F01                   jmp @@retn
  4535                                  
  4536                                  ;-37   }
  4537                                  
  4538                                  
  4539                                  ;-38   
  4540                                  
  4541                                  
  4542                                  ;-39   if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4543                                  
  4544                                  @@process159:
  4545 00002920 A0[B801]                 mov al, [CodeType]
  4546 00002923 3C03                     cmp al, 3
  4547 00002925 0F856800                 jne @@process166
  4548                                  
  4549                                  ;-40     checkOp();      
  4550                                  
  4551 00002929 E88901                   call checkOp
  4552                                  
  4553                                  ;-41     if (RegType != WORD) reg16error();
  4554                                  
  4555 0000292C A0[BE01]                 mov al, [RegType]
  4556 0000292F 3C02                     cmp al, 2
  4557 00002931 0F840300                 je  @@process167
  4558 00002935 E82FF9                   call reg16error
  4559                                  
  4560                                  ;-42     if (Op1 == IMM) immeerror();
  4561                                  
  4562                                  @@process167:
  4563 00002938 A0[B601]                 mov al, [Op1]
  4564 0000293B 3C01                     cmp al, 1
  4565 0000293D 0F850300                 jne @@process168
  4566 00002941 E85EF8                   call immeerror
  4567                                  
  4568                                  ;-43     R1No=RegNo;
  4569                                  
  4570                                  @@process168:
  4571 00002944 A0[BC01]                 mov al, [RegNo]
  4572 00002947 A2[BD01]                 mov byte [R1No], al
  4573                                  
  4574                                  ;-44     need(',');    
  4575                                  
  4576 0000294A 6A2C                     push 44
  4577 0000294C E898ED                   call need
  4578 0000294F 83C402                   add  sp, 2
  4579                                  
  4580                                  ;-45     getOp();
  4581                                  
  4582 00002952 E81602                   call getOp
  4583                                  
  4584                                  ;-46     if (Op1 < ADR) addrerror(); 
  4585                                  
  4586 00002955 A0[B601]                 mov al, [Op1]
  4587 00002958 3C03                     cmp al, 3
  4588 0000295A 0F8D0300                 jge @@process169
  4589 0000295E E826F8                   call addrerror
  4590                                  
  4591                                  ;-47         
  4592                                  
  4593                                  
  4594                                  ;-48     genCode8(Code1);//les,lds,lea
  4595                                  
  4596                                  @@process169:
  4597 00002961 A0[B901]                 mov al, byte [Code1]
  4598 00002964 B400                     mov ah, 0
  4599 00002966 50                       push ax
  4600 00002967 E85AFD                   call genCode8
  4601 0000296A 83C402                   add  sp, 2
  4602                                  
  4603                                  ;-49     if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  4604                                  
  4605 0000296D A0[B901]                 mov al, [Code1]
  4606 00002970 3C0F                     cmp al, 15
  4607 00002972 0F850C00                 jne @@process170
  4608 00002976 A0[BA01]                 mov al, byte [Code2]
  4609 00002979 B400                     mov ah, 0
  4610 0000297B 50                       push ax
  4611 0000297C E845FD                   call genCode8
  4612 0000297F 83C402                   add  sp, 2
  4613                                  
  4614                                  ;-50     writeEA(R1No);           
  4615                                  
  4616                                  @@process170:
  4617 00002982 A0[BD01]                 mov al, byte [R1No]
  4618 00002985 B400                     mov ah, 0
  4619 00002987 50                       push ax
  4620 00002988 E8B0FD                   call writeEA
  4621 0000298B 83C402                   add  sp, 2
  4622                                  
  4623                                  ;-51     return;
  4624                                  
  4625 0000298E E9FE00                   jmp @@retn
  4626                                  
  4627                                  ;-52   }
  4628                                  
  4629                                  
  4630                                  ;-53 
  4631                                  
  4632                                  
  4633                                  ;-54   if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  4634                                  
  4635                                  @@process166:
  4636 00002991 A0[B801]                 mov al, [CodeType]
  4637 00002994 3C04                     cmp al, 4
  4638 00002996 0F858E00                 jne @@process171
  4639                                  
  4640                                  ;-55     checkOp();
  4641                                  
  4642 0000299A E81801                   call checkOp
  4643                                  
  4644                                  ;-56     if (Op1 == IMM) immeerror();  
  4645                                  
  4646 0000299D A0[B601]                 mov al, [Op1]
  4647 000029A0 3C01                     cmp al, 1
  4648 000029A2 0F850300                 jne @@process172
  4649 000029A6 E8F9F7                   call immeerror
  4650                                  
  4651                                  ;-57     Optemp = Op1;    
  4652                                  
  4653                                  @@process172:
  4654 000029A9 A0[B601]                 mov al, [Op1]
  4655 000029AC A2[B701]                 mov byte [Optemp], al
  4656                                  
  4657                                  ;-58     R1No=RegNo;   
  4658                                  
  4659 000029AF A0[BC01]                 mov al, [RegNo]
  4660 000029B2 A2[BD01]                 mov byte [R1No], al
  4661                                  
  4662                                  ;-59     R1Type = RegType;
  4663                                  
  4664 000029B5 A0[BE01]                 mov al, [RegType]
  4665 000029B8 A2[BF01]                 mov byte [R1Type], al
  4666                                  
  4667                                  ;-60     need(',');    
  4668                                  
  4669 000029BB 6A2C                     push 44
  4670 000029BD E827ED                   call need
  4671 000029C0 83C402                   add  sp, 2
  4672                                  
  4673                                  ;-61     getOp();  
  4674                                  
  4675 000029C3 E8A501                   call getOp
  4676                                  
  4677                                  ;-62 //prs("\nOp1:"); printIntU(Op1); prs(", imme:"); printIntU(imme);       
  4678                                  
  4679                                  
  4680                                  ;-63     if (Op1 == IMM) {//second operand is imm  
  4681                                  
  4682 000029C6 A0[B601]                 mov al, [Op1]
  4683 000029C9 3C01                     cmp al, 1
  4684 000029CB 0F855600                 jne @@process173
  4685                                  
  4686                                  ;-64         if (R1No == 0) {//acc, imm: 04,imm
  4687                                  
  4688 000029CF A0[BD01]                 mov al, [R1No]
  4689 000029D2 3C00                     cmp al, 0
  4690 000029D4 0F852000                 jne @@process174
  4691                                  
  4692                                  ;-65             Code1 = Code1 << 3;
  4693                                  
  4694 000029D8 A0[B901]                 mov al, [Code1]
  4695 000029DB C0E003                   shl al, 3
  4696 000029DE A2[B901]                 mov byte [Code1], al
  4697                                  
  4698                                  ;-66             Code1 += 4;//code for acc,imm     
  4699                                  
  4700 000029E1 8006[B901]04             add  byte [Code1], 4
  4701                                  
  4702                                  ;-67             genCodeW(Code1);
  4703                                  
  4704 000029E6 A0[B901]                 mov al, byte [Code1]
  4705 000029E9 B400                     mov ah, 0
  4706 000029EB 50                       push ax
  4707 000029EC E8B9FC                   call genCodeW
  4708 000029EF 83C402                   add  sp, 2
  4709                                  
  4710                                  ;-68             genImmediate();
  4711                                  
  4712 000029F2 E855FE                   call genImmediate
  4713                                  
  4714                                  ;-69             return;
  4715                                  
  4716 000029F5 E99700                   jmp @@retn
  4717                                  
  4718                                  ;-70         }
  4719                                  
  4720                                  
  4721                                  ;-71         //r/m, imm: 80 sign-extended,TTT,imm
  4722                                  
  4723                                  
  4724                                  ;-72         getSignExtended(imme);    
  4725                                  
  4726                                  @@process174:
  4727 000029F8 FF36[C801]               push word [imme]
  4728 000029FC E8D204                   call getSignExtended
  4729 000029FF 83C402                   add  sp, 2
  4730                                  
  4731                                  ;-73         c = sflag + 0x80;       
  4732                                  
  4733 00002A02 A0[C301]                 mov al, [sflag]
  4734 00002A05 0480                     add al, 128
  4735 00002A07 8846FE                   mov byte [bp-2], al
  4736                                  
  4737                                  ;-74         genCodeW(c); 
  4738                                  
  4739 00002A0A 8A46FE                   mov al, byte [bp-2]
  4740 00002A0D B400                     mov ah, 0
  4741 00002A0F 50                       push ax
  4742 00002A10 E895FC                   call genCodeW
  4743 00002A13 83C402                   add  sp, 2
  4744                                  
  4745                                  ;-75         writeEA(Code1);//todo not Op1??
  4746                                  
  4747 00002A16 A0[B901]                 mov al, byte [Code1]
  4748 00002A19 B400                     mov ah, 0
  4749 00002A1B 50                       push ax
  4750 00002A1C E81CFD                   call writeEA
  4751 00002A1F 83C402                   add  sp, 2
  4752                                  
  4753                                  ;-76         return;     
  4754                                  
  4755 00002A22 E96A00                   jmp @@retn
  4756                                  
  4757                                  ;-77        
  4758                                  
  4759                                  
  4760                                  ;-78     } 
  4761                                  
  4762                                  
  4763                                  ;-79     return;
  4764                                  
  4765                                  @@process173:
  4766 00002A25 E96700                   jmp @@retn
  4767                                  
  4768                                  ;-80   }
  4769                                  
  4770                                  
  4771                                  ;-81    
  4772                                  
  4773                                  
  4774                                  ;-82   if (CodeType ==  8) {//ret,retf
  4775                                  
  4776                                  @@process171:
  4777 00002A28 A0[B801]                 mov al, [CodeType]
  4778 00002A2B 3C08                     cmp al, 8
  4779 00002A2D 0F853100                 jne @@process175
  4780                                  
  4781                                  ;-83     if (TokeType == DIGIT) {
  4782                                  
  4783 00002A31 A0[B501]                 mov al, [TokeType]
  4784 00002A34 3C01                     cmp al, 1
  4785 00002A36 0F851900                 jne @@process176
  4786                                  
  4787                                  ;-84       genCode8(Code2);
  4788                                  
  4789 00002A3A A0[BA01]                 mov al, byte [Code2]
  4790 00002A3D B400                     mov ah, 0
  4791 00002A3F 50                       push ax
  4792 00002A40 E881FC                   call genCode8
  4793 00002A43 83C402                   add  sp, 2
  4794                                  
  4795                                  ;-85       genCode16(SymbolInt);
  4796                                  
  4797 00002A46 FF36[5700]               push word [SymbolInt]
  4798 00002A4A E8CDFC                   call genCode16
  4799 00002A4D 83C402                   add  sp, 2
  4800                                  
  4801                                  ;-86       return;
  4802                                  
  4803 00002A50 E93C00                   jmp @@retn
  4804                                  
  4805                                  ;-87     }
  4806                                  
  4807                                  
  4808                                  ;-88     genCode8(Code1); 
  4809                                  
  4810                                  @@process176:
  4811 00002A53 A0[B901]                 mov al, byte [Code1]
  4812 00002A56 B400                     mov ah, 0
  4813 00002A58 50                       push ax
  4814 00002A59 E868FC                   call genCode8
  4815 00002A5C 83C402                   add  sp, 2
  4816                                  
  4817                                  ;-89     return;
  4818                                  
  4819 00002A5F E92D00                   jmp @@retn
  4820                                  
  4821                                  ;-90   }
  4822                                  
  4823                                  
  4824                                  ;-91 
  4825                                  
  4826                                  
  4827                                  ;-92   if (CodeType==101) {// ORG nn
  4828                                  
  4829                                  @@process175:
  4830 00002A62 A0[B801]                 mov al, [CodeType]
  4831 00002A65 3C65                     cmp al, 101
  4832 00002A67 0F851B00                 jne @@process177
  4833                                  
  4834                                  ;-93     if (TokeType != DIGIT) error1("only digit allowed");
  4835                                  
  4836 00002A6B A0[B501]                 mov al, [TokeType]
  4837 00002A6E 3C01                     cmp al, 1
  4838 00002A70 0F840900                 je  @@process178
  4839 00002A74 68[912A]                 push process_0
  4840 00002A77 E893F6                   call error1
  4841 00002A7A 83C402                   add  sp, 2
  4842                                  
  4843                                  ;-94     PC=SymbolInt;
  4844                                  
  4845                                  @@process178:
  4846 00002A7D A1[5700]                 mov ax, [SymbolInt]
  4847 00002A80 A3[B001]                 mov word [PC], ax
  4848                                  
  4849                                  ;-95     return;
  4850                                  
  4851 00002A83 E90900                   jmp @@retn
  4852                                  
  4853                                  ;-96   }
  4854                                  
  4855                                  
  4856                                  ;-97   error1("unknown CodeType");
  4857                                  
  4858                                  @@process177:
  4859 00002A86 68[A42A]                 push process_1
  4860 00002A89 E881F6                   call error1
  4861 00002A8C 83C402                   add  sp, 2
  4862                                  
  4863                                  ;-98 }    
  4864                                  
  4865                                  
  4866                                  ;-99 
  4867                                  
  4868                                  
  4869                                  ;-100 int checkOp() {
  4870                                  
  4871 00002A8F C9                      @@retn: LEAVE
  4872 00002A90 C3                       ret
  4873                                  ; ENDP
  4874 00002A91 6F6E6C792064696769-     process_0 db "only digit allowed",0
  4875 00002A9A 7420616C6C6F776564-
  4876 00002AA3 00                 
  4877 00002AA4 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  4878 00002AAD 6F64655479706500   
  4879                                  
  4880                                  checkOp:  ; *** PROC ***
  4881                                  
  4882                                  ;-101   getOp();
  4883                                  
  4884 00002AB5 E8B300                   call getOp
  4885                                  
  4886                                  ;-102   if (Op1 == ADR) implerror();
  4887                                  
  4888 00002AB8 A0[B601]                 mov al, [Op1]
  4889 00002ABB 3C03                     cmp al, 3
  4890 00002ABD 0F850300                 jne @@checkOp179
  4891 00002AC1 E803F7                   call implerror
  4892                                  
  4893                                  ;-103   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  4894                                  
  4895                                  @@checkOp179:
  4896 00002AC4 A0[BE01]                 mov al, [RegType]
  4897 00002AC7 3C04                     cmp al, 4
  4898 00002AC9 0F850600                 jne @@checkOp180
  4899 00002ACD E8BFF7                   call segregerror
  4900 00002AD0 E95300                   jmp @@retn
  4901                                  
  4902                                  ;-104   setwflag();
  4903                                  
  4904                                  @@checkOp180:
  4905 00002AD3 E8A003                   call setwflag
  4906                                  
  4907                                  ;-105   if (OpSize == 0) error1("no op size declared");
  4908                                  
  4909 00002AD6 A0[C001]                 mov al, [OpSize]
  4910 00002AD9 3C00                     cmp al, 0
  4911 00002ADB 0F850900                 jne @@checkOp181
  4912 00002ADF 68[272B]                 push checkOp_0
  4913 00002AE2 E828F6                   call error1
  4914 00002AE5 83C402                   add  sp, 2
  4915                                  
  4916                                  ;-106   if (OpSize == RegType) return;
  4917                                  
  4918                                  @@checkOp181:
  4919 00002AE8 A0[C001]                 mov al, [OpSize]
  4920 00002AEB 3A06[BE01]               cmp al, [RegType]
  4921 00002AEF 0F850300                 jne @@checkOp182
  4922 00002AF3 E93000                   jmp @@retn
  4923                                  
  4924                                  ;-107   if (OpSize){if (Op1 == MEM) return;
  4925                                  
  4926                                  @@checkOp182:
  4927 00002AF6 A0[C001]                 mov al, [OpSize]
  4928 00002AF9 08C0                     or  al, al
  4929 00002AFB 0F841500                 je @@checkOp183
  4930 00002AFF A0[B601]                 mov al, [Op1]
  4931 00002B02 3C04                     cmp al, 4
  4932 00002B04 0F850300                 jne @@checkOp184
  4933 00002B08 E91B00                   jmp @@retn
  4934                                  
  4935                                  ;-108     error1("Conflict OpSize and RegSize"); }
  4936                                  
  4937                                  @@checkOp184:
  4938 00002B0B 68[3B2B]                 push checkOp_1
  4939 00002B0E E8FCF5                   call error1
  4940 00002B11 83C402                   add  sp, 2
  4941                                  
  4942                                  ;-109   if (RegType==0) error1("no register defined");
  4943                                  
  4944                                  @@checkOp183:
  4945 00002B14 A0[BE01]                 mov al, [RegType]
  4946 00002B17 3C00                     cmp al, 0
  4947 00002B19 0F850900                 jne @@checkOp185
  4948 00002B1D 68[572B]                 push checkOp_2
  4949 00002B20 E8EAF5                   call error1
  4950 00002B23 83C402                   add  sp, 2
  4951                                  
  4952                                  ;-110 }
  4953                                  
  4954                                  @@checkOp185:
  4955                                  
  4956                                  ;-111 /*    Op1, Optemp =0, 1=IMM, 2=REG, 3=ADR, 4=MEM 
  4957                                  
  4958                                  
  4959                                  ;-112 IMM      imme           = 0, SymbolInt
  4960                                  
  4961                                  
  4962                                  ;-113 REG      R1No,RegNo     = 0 - 7
  4963                                  
  4964                                  
  4965                                  ;-114 REG      R1Type,RegType = 0, BYTE, WORD, DWORD, SEGREG 
  4966                                  
  4967                                  
  4968                                  ;-115 MEM,ADR  disp           = 0, LabelAddr[LabelIx]
  4969                                  
  4970                                  
  4971                                  ;-116 MEM      regindexbase   = 0 - 7
  4972                                  
  4973                                  
  4974                                  ;-117          OpSize         = 0, BYTE, WORD, DWORD
  4975                                  
  4976                                  
  4977                                  ;-118          wflag
  4978                                  
  4979                                  
  4980                                  ;-119 */ 
  4981                                  
  4982                                  
  4983                                  ;-120  
  4984                                  
  4985                                  
  4986                                  ;-121 int getOp() {
  4987                                  
  4988                                  @@retn:
  4989 00002B26 C3                       ret
  4990                                  ; ENDP
  4991 00002B27 6E6F206F702073697A-     checkOp_0 db "no op size declared",0
  4992 00002B30 65206465636C617265-
  4993 00002B39 6400               
  4994 00002B3B 436F6E666C69637420-     checkOp_1 db "Conflict OpSize and RegSize",0
  4995 00002B44 4F7053697A6520616E-
  4996 00002B4D 642052656753697A65-
  4997 00002B56 00                 
  4998 00002B57 6E6F20726567697374-     checkOp_2 db "no register defined",0
  4999 00002B60 657220646566696E65-
  5000 00002B69 6400               
  5001                                  
  5002                                  getOp:  ; *** PROC ***
  5003                                  
  5004                                  ;-122 //set: op1=0,IMM,REG,ADR,MEM
  5005                                  
  5006                                  
  5007                                  ;-123   disp=0; imme=0; regindexbase=0; isDirect=1;
  5008                                  
  5009 00002B6B 66B800000000             mov eax, 0
  5010 00002B71 A3[C601]                 mov word [disp], ax
  5011 00002B74 66B800000000             mov eax, 0
  5012 00002B7A A3[C801]                 mov word [imme], ax
  5013 00002B7D 66B800000000             mov eax, 0
  5014 00002B83 A2[C401]                 mov byte [regindexbase], al
  5015 00002B86 66B801000000             mov eax, 1
  5016 00002B8C A2[C501]                 mov byte [isDirect], al
  5017                                  
  5018                                  ;-124 
  5019                                  
  5020                                  
  5021                                  ;-125   Op1=getOp1();
  5022                                  
  5023 00002B8F E88C00                   call getOp1
  5024 00002B92 A2[B601]                 mov byte [Op1], al
  5025                                  
  5026                                  ;-126   if (isToken('[')) {Op1 = MEM; getMEM();    return;}
  5027                                  
  5028 00002B95 6A5B                     push 91
  5029 00002B97 E81FEB                   call isToken
  5030 00002B9A 83C402                   add  sp, 2
  5031 00002B9D 08C0                     or  al, al
  5032 00002B9F 0F840F00                 je @@getOp186
  5033 00002BA3 66B804000000             mov eax, 4
  5034 00002BA9 A2[B601]                 mov byte [Op1], al
  5035 00002BAC E8F500                   call getMEM
  5036 00002BAF E94F00                   jmp @@retn
  5037                                  
  5038                                  ;-127   if (Op1 == 0)     {invaloperror();         return;}
  5039                                  
  5040                                  @@getOp186:
  5041 00002BB2 A0[B601]                 mov al, [Op1]
  5042 00002BB5 3C00                     cmp al, 0
  5043 00002BB7 0F850600                 jne @@getOp187
  5044 00002BBB E844F6                   call invaloperror
  5045 00002BBE E94000                   jmp @@retn
  5046                                  
  5047                                  ;-128   if (Op1 == IMM)   {imme=SymbolInt;         return;}
  5048                                  
  5049                                  @@getOp187:
  5050 00002BC1 A0[B601]                 mov al, [Op1]
  5051 00002BC4 3C01                     cmp al, 1
  5052 00002BC6 0F850900                 jne @@getOp188
  5053 00002BCA A1[5700]                 mov ax, [SymbolInt]
  5054 00002BCD A3[C801]                 mov word [imme], ax
  5055 00002BD0 E92E00                   jmp @@retn
  5056                                  
  5057                                  ;-129   if (Op1 == REG)                            return;
  5058                                  
  5059                                  @@getOp188:
  5060 00002BD3 A0[B601]                 mov al, [Op1]
  5061 00002BD6 3C02                     cmp al, 2
  5062 00002BD8 0F850300                 jne @@getOp189
  5063 00002BDC E92200                   jmp @@retn
  5064                                  
  5065                                  ;-130   if (Op1 == ADR)   {disp=LabelAddr[LabelIx];return;}
  5066                                  
  5067                                  @@getOp189:
  5068 00002BDF A0[B601]                 mov al, [Op1]
  5069 00002BE2 3C03                     cmp al, 3
  5070 00002BE4 0F851000                 jne @@getOp190
  5071 00002BE8 8B1E[8806]               mov bx, [LabelIx]
  5072 00002BEC D1E3                     shl bx, 1
  5073 00002BEE 8B87[BE05]               mov ax, [LabelAddr + bx]
  5074 00002BF2 A3[C601]                 mov word [disp], ax
  5075 00002BF5 E90900                   jmp @@retn
  5076                                  
  5077                                  ;-131   error1("Name of operand expected #1");
  5078                                  
  5079                                  @@getOp190:
  5080 00002BF8 68[022C]                 push getOp_0
  5081 00002BFB E80FF5                   call error1
  5082 00002BFE 83C402                   add  sp, 2
  5083                                  
  5084                                  ;-132 }
  5085                                  
  5086                                  
  5087                                  ;-133 
  5088                                  
  5089                                  
  5090                                  ;-134 int getOp1() {//scan for a single operand
  5091                                  
  5092                                  @@retn:
  5093 00002C01 C3                       ret
  5094                                  ; ENDP
  5095 00002C02 4E616D65206F66206F-     getOp_0 db "Name of operand expected #1",0
  5096 00002C0B 706572616E64206578-
  5097 00002C14 706563746564202331-
  5098 00002C1D 00                 
  5099                                  
  5100                                  getOp1:  ; *** PROC ***
  5101                                  
  5102                                  ;-135 //return:0, IMM, REG, ADR (not MEM)
  5103                                  
  5104                                  
  5105                                  ;-136 //set   :RegType, RegNo by testReg
  5106                                  
  5107                                  
  5108                                  ;-137 //set   :LabelIx by searchLabel
  5109                                  
  5110                                  
  5111                                  ;-138   if (TokeType == 0)      return 0;
  5112                                  
  5113 00002C1E A0[B501]                 mov al, [TokeType]
  5114 00002C21 3C00                     cmp al, 0
  5115 00002C23 0F850900                 jne @@getOp1191
  5116 00002C27 66B800000000             mov eax, 0
  5117 00002C2D E96000                   jmp @@retn
  5118                                  
  5119                                  ;-139   if (TokeType == DIGIT)  return IMM;
  5120                                  
  5121                                  @@getOp1191:
  5122 00002C30 A0[B501]                 mov al, [TokeType]
  5123 00002C33 3C01                     cmp al, 1
  5124 00002C35 0F850900                 jne @@getOp1192
  5125 00002C39 66B801000000             mov eax, 1
  5126 00002C3F E94E00                   jmp @@retn
  5127                                  
  5128                                  ;-140   if (TokeType == ALNUME) {
  5129                                  
  5130                                  @@getOp1192:
  5131 00002C42 A0[B501]                 mov al, [TokeType]
  5132 00002C45 3C03                     cmp al, 3
  5133 00002C47 0F853C00                 jne @@getOp1193
  5134                                  
  5135                                  ;-141     RegNo=testReg();
  5136                                  
  5137 00002C4B E818EE                   call testReg
  5138 00002C4E A2[BC01]                 mov byte [RegNo], al
  5139                                  
  5140                                  ;-142     if (RegType)          return REG;
  5141                                  
  5142 00002C51 A0[BE01]                 mov al, [RegType]
  5143 00002C54 08C0                     or  al, al
  5144 00002C56 0F840900                 je @@getOp1194
  5145 00002C5A 66B802000000             mov eax, 2
  5146 00002C60 E92D00                   jmp @@retn
  5147                                  
  5148                                  ;-143     LabelIx=searchLabel();
  5149                                  
  5150                                  @@getOp1194:
  5151 00002C63 E8BEE7                   call searchLabel
  5152 00002C66 A3[8806]                 mov word [LabelIx], ax
  5153                                  
  5154                                  ;-144     if (LabelIx)          return ADR;
  5155                                  
  5156 00002C69 A1[8806]                 mov ax, [LabelIx]
  5157 00002C6C 08C0                     or  al, al
  5158 00002C6E 0F840C00                 je @@getOp1195
  5159 00002C72 66B803000000             mov eax, 3
  5160 00002C78 E91500                   jmp @@retn
  5161                                  
  5162                                  ;-145     else error1("variable not found"); 
  5163                                  
  5164 00002C7B E90900                   jmp @@getOp1196
  5165                                  @@getOp1195:
  5166 00002C7E 68[912C]                 push getOp1_0
  5167 00002C81 E889F4                   call error1
  5168 00002C84 83C402                   add  sp, 2
  5169                                  
  5170                                  ;-146   }
  5171                                  
  5172                                  @@getOp1196:
  5173                                  
  5174                                  ;-147   return 0;
  5175                                  
  5176                                  @@getOp1193:
  5177 00002C87 66B800000000             mov eax, 0
  5178 00002C8D E90000                   jmp @@retn
  5179                                  
  5180                                  ;-148 }
  5181                                  
  5182                                  
  5183                                  ;-149 
  5184                                  
  5185                                  
  5186                                  ;-150 int getMEM() {// e.g. [array+bp+si-4]
  5187                                  
  5188                                  @@retn:
  5189 00002C90 C3                       ret
  5190                                  ; ENDP
  5191 00002C91 7661726961626C6520-     getOp1_0 db "variable not found",0
  5192 00002C9A 6E6F7420666F756E64-
  5193 00002CA3 00                 
  5194                                  
  5195                                  getMEM:  ; *** PROC ***
  5196                                  
  5197                                  ;-151 //set: disp, regindexbase, RegType
  5198                                  
  5199                                  
  5200                                  ;-152   char op2;
  5201                                  
  5202                                  
  5203                                  ;-153   disp=0; regindexbase=0; RegType=0;
  5204                                  
  5205                                  ;Function : getMEM, Number of local variables: 1
  5206                                  ;   # type sign width line used address name   list of local variables
  5207                                  ;  200 var sign byte   152 NULL bp-2    op2;
  5208 00002CA4 C8020000                 ENTER  2,0
  5209 00002CA8 66B800000000             mov eax, 0
  5210 00002CAE A3[C601]                 mov word [disp], ax
  5211 00002CB1 66B800000000             mov eax, 0
  5212 00002CB7 A2[C401]                 mov byte [regindexbase], al
  5213 00002CBA 66B800000000             mov eax, 0
  5214 00002CC0 A2[BE01]                 mov byte [RegType], al
  5215                                  
  5216                                  ;-154   do {
  5217                                  
  5218                                  @@getMEM197:
  5219                                  
  5220                                  ;-155     getTokeType();
  5221                                  
  5222 00002CC3 E81DE6                   call getTokeType
  5223                                  
  5224                                  ;-156     op2=getOp1();
  5225                                  
  5226 00002CC6 E855FF                   call getOp1
  5227 00002CC9 8846FE                   mov byte [bp-2], al
  5228                                  
  5229                                  ;-157     if (op2 ==   0) syntaxerror();
  5230                                  
  5231 00002CCC 8A46FE                   mov al, [bp-2]
  5232 00002CCF 3C00                     cmp al, 0
  5233 00002CD1 0F850300                 jne @@getMEM198
  5234 00002CD5 E8DEF5                   call syntaxerror
  5235                                  
  5236                                  ;-158     if (op2 == REG) {isDirect=0;
  5237                                  
  5238                                  @@getMEM198:
  5239 00002CD8 8A46FE                   mov al, [bp-2]
  5240 00002CDB 3C02                     cmp al, 2
  5241 00002CDD 0F851E00                 jne @@getMEM199
  5242 00002CE1 66B800000000             mov eax, 0
  5243 00002CE7 A2[C501]                 mov byte [isDirect], al
  5244                                  
  5245                                  ;-159                       if (regindexbase) regindexbase=getIndReg2();
  5246                                  
  5247 00002CEA A0[C401]                 mov al, [regindexbase]
  5248 00002CED 08C0                     or  al, al
  5249 00002CEF 0F840900                 je @@getMEM200
  5250 00002CF3 E8F300                   call getIndReg2
  5251 00002CF6 A2[C401]                 mov byte [regindexbase], al
  5252                                  
  5253                                  ;-160                       else getIndReg1();
  5254                                  
  5255 00002CF9 E90300                   jmp @@getMEM201
  5256                                  @@getMEM200:
  5257 00002CFC E88900                   call getIndReg1
  5258                                  
  5259                                  ;-161                     }
  5260                                  
  5261                                  @@getMEM201:
  5262                                  
  5263                                  ;-162     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  5264                                  
  5265                                  @@getMEM199:
  5266 00002CFF 8A46FE                   mov al, [bp-2]
  5267 00002D02 3C03                     cmp al, 3
  5268 00002D04 0F851000                 jne @@getMEM202
  5269 00002D08 A1[C601]                 mov ax, [disp]
  5270 00002D0B 8B1E[8806]               mov bx, [LabelIx]
  5271 00002D0F D1E3                     shl bx, 1
  5272 00002D11 0387[BE05]               add ax, [LabelAddr + bx]
  5273 00002D15 A3[C601]                 mov word [disp], ax
  5274                                  
  5275                                  ;-163     if (op2 == IMM) disp=disp+SymbolInt;
  5276                                  
  5277                                  @@getMEM202:
  5278 00002D18 8A46FE                   mov al, [bp-2]
  5279 00002D1B 3C01                     cmp al, 1
  5280 00002D1D 0F850A00                 jne @@getMEM203
  5281 00002D21 A1[C601]                 mov ax, [disp]
  5282 00002D24 0306[5700]               add ax, [SymbolInt]
  5283 00002D28 A3[C601]                 mov word [disp], ax
  5284                                  
  5285                                  ;-164     if (isToken('-')) {
  5286                                  
  5287                                  @@getMEM203:
  5288 00002D2B 6A2D                     push 45
  5289 00002D2D E889E9                   call isToken
  5290 00002D30 83C402                   add  sp, 2
  5291 00002D33 08C0                     or  al, al
  5292 00002D35 0F841900                 je @@getMEM204
  5293                                  
  5294                                  ;-165       getTokeType();
  5295                                  
  5296 00002D39 E8A7E5                   call getTokeType
  5297                                  
  5298                                  ;-166       if (TokeType != DIGIT) numbererror();
  5299                                  
  5300 00002D3C A0[B501]                 mov al, [TokeType]
  5301 00002D3F 3C01                     cmp al, 1
  5302 00002D41 0F840300                 je  @@getMEM205
  5303 00002D45 E8DBF4                   call numbererror
  5304                                  
  5305                                  ;-167       disp = disp - SymbolInt;
  5306                                  
  5307                                  @@getMEM205:
  5308 00002D48 A1[C601]                 mov ax, [disp]
  5309 00002D4B 2B06[5700]               sub ax, [SymbolInt]
  5310 00002D4F A3[C601]                 mov word [disp], ax
  5311                                  
  5312                                  ;-168     }
  5313                                  
  5314                                  
  5315                                  ;-169   } while (isToken('+'));
  5316                                  
  5317                                  @@getMEM204:
  5318 00002D52 6A2B                     push 43
  5319 00002D54 E862E9                   call isToken
  5320 00002D57 83C402                   add  sp, 2
  5321 00002D5A 08C0                     or  al, al
  5322 00002D5C 0F840300                 je @@getMEM206
  5323 00002D60 E960FF                   jmp @@getMEM197
  5324                                  @@getMEM206:
  5325                                  
  5326                                  ;-170   if (isToken(']') == 0) errorexit("] expected");
  5327                                  
  5328 00002D63 6A5D                     push 93
  5329 00002D65 E851E9                   call isToken
  5330 00002D68 83C402                   add  sp, 2
  5331 00002D6B 83F800                   cmp ax, 0
  5332 00002D6E 0F850900                 jne @@getMEM207
  5333 00002D72 68[7D2D]                 push getMEM_0
  5334 00002D75 E84FF5                   call errorexit
  5335 00002D78 83C402                   add  sp, 2
  5336                                  
  5337                                  ;-171 }
  5338                                  
  5339                                  @@getMEM207:
  5340                                  
  5341                                  ;-172 int getIndReg1() {
  5342 00002D7B C9                       LEAVE
  5343 00002D7C C3                       ret
  5344                                  ; ENDP
  5345 00002D7D 5D2065787065637465-     getMEM_0 db "] expected",0
  5346 00002D86 6400               
  5347                                  
  5348                                  getIndReg1:  ; *** PROC ***
  5349                                  
  5350                                  ;-173   if (RegType !=WORD) indexerror();
  5351                                  
  5352 00002D88 A0[BE01]                 mov al, [RegType]
  5353 00002D8B 3C02                     cmp al, 2
  5354 00002D8D 0F840300                 je  @@getIndReg1208
  5355 00002D91 E84DF4                   call indexerror
  5356                                  
  5357                                  ;-174   if (RegNo==3) regindexbase=7;//BX
  5358                                  
  5359                                  @@getIndReg1208:
  5360 00002D94 A0[BC01]                 mov al, [RegNo]
  5361 00002D97 3C03                     cmp al, 3
  5362 00002D99 0F850900                 jne @@getIndReg1209
  5363 00002D9D 66B807000000             mov eax, 7
  5364 00002DA3 A2[C401]                 mov byte [regindexbase], al
  5365                                  
  5366                                  ;-175   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5367                                  
  5368                                  @@getIndReg1209:
  5369 00002DA6 A0[BC01]                 mov al, [RegNo]
  5370 00002DA9 3C05                     cmp al, 5
  5371 00002DAB 0F850900                 jne @@getIndReg1210
  5372 00002DAF 66B806000000             mov eax, 6
  5373 00002DB5 A2[C401]                 mov byte [regindexbase], al
  5374                                  
  5375                                  ;-176   if (RegNo==7) regindexbase=5;//DI
  5376                                  
  5377                                  @@getIndReg1210:
  5378 00002DB8 A0[BC01]                 mov al, [RegNo]
  5379 00002DBB 3C07                     cmp al, 7
  5380 00002DBD 0F850900                 jne @@getIndReg1211
  5381 00002DC1 66B805000000             mov eax, 5
  5382 00002DC7 A2[C401]                 mov byte [regindexbase], al
  5383                                  
  5384                                  ;-177   if (RegNo==6) regindexbase=4;//SI
  5385                                  
  5386                                  @@getIndReg1211:
  5387 00002DCA A0[BC01]                 mov al, [RegNo]
  5388 00002DCD 3C06                     cmp al, 6
  5389 00002DCF 0F850900                 jne @@getIndReg1212
  5390 00002DD3 66B804000000             mov eax, 4
  5391 00002DD9 A2[C401]                 mov byte [regindexbase], al
  5392                                  
  5393                                  ;-178   if (regindexbase==0) indexerror();
  5394                                  
  5395                                  @@getIndReg1212:
  5396 00002DDC A0[C401]                 mov al, [regindexbase]
  5397 00002DDF 3C00                     cmp al, 0
  5398 00002DE1 0F850300                 jne @@getIndReg1213
  5399 00002DE5 E8F9F3                   call indexerror
  5400                                  
  5401                                  ;-179 }
  5402                                  
  5403                                  @@getIndReg1213:
  5404                                  
  5405                                  ;-180 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5406                                  
  5407 00002DE8 C3                       ret
  5408                                  ; ENDP
  5409                                  
  5410                                  getIndReg2:  ; *** PROC ***
  5411                                  ;Function : getIndReg2, Number of local variables: 1
  5412                                  ;   # type sign width line used address name   list of local variables
  5413                                  ;  200 var sign byte   180 NULL bp-2    m;
  5414 00002DE9 C8020000                 ENTER  2,0
  5415 00002DED 66B804000000             mov eax, 4
  5416 00002DF3 8846FE                   mov byte [bp-2], al
  5417                                  
  5418                                  ;-181   if (RegType !=WORD) indexerror();
  5419                                  
  5420 00002DF6 A0[BE01]                 mov al, [RegType]
  5421 00002DF9 3C02                     cmp al, 2
  5422 00002DFB 0F840300                 je  @@getIndReg2214
  5423 00002DFF E8DFF3                   call indexerror
  5424                                  
  5425                                  ;-182   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5426                                  
  5427                                  @@getIndReg2214:
  5428 00002E02 A0[BC01]                 mov al, [RegNo]
  5429 00002E05 3C07                     cmp al, 7
  5430 00002E07 0F852700                 jne @@getIndReg2215
  5431 00002E0B A0[C401]                 mov al, [regindexbase]
  5432 00002E0E 3C06                     cmp al, 6
  5433 00002E10 0F850C00                 jne @@getIndReg2216
  5434 00002E14 66B803000000             mov eax, 3
  5435 00002E1A 8846FE                   mov byte [bp-2], al
  5436                                  
  5437                                  ;-183            else if (regindexbase==7) m=1;//BX+DI
  5438                                  
  5439 00002E1D E91200                   jmp @@getIndReg2217
  5440                                  @@getIndReg2216:
  5441 00002E20 A0[C401]                 mov al, [regindexbase]
  5442 00002E23 3C07                     cmp al, 7
  5443 00002E25 0F850900                 jne @@getIndReg2218
  5444 00002E29 66B801000000             mov eax, 1
  5445 00002E2F 8846FE                   mov byte [bp-2], al
  5446                                  
  5447                                  ;-184   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5448                                  
  5449                                  @@getIndReg2218:
  5450                                  @@getIndReg2217:
  5451                                  @@getIndReg2215:
  5452 00002E32 A0[BC01]                 mov al, [RegNo]
  5453 00002E35 3C06                     cmp al, 6
  5454 00002E37 0F852700                 jne @@getIndReg2219
  5455 00002E3B A0[C401]                 mov al, [regindexbase]
  5456 00002E3E 3C06                     cmp al, 6
  5457 00002E40 0F850C00                 jne @@getIndReg2220
  5458 00002E44 66B802000000             mov eax, 2
  5459 00002E4A 8846FE                   mov byte [bp-2], al
  5460                                  
  5461                                  ;-185            else if (regindexbase==7) m=0;//BX+SI
  5462                                  
  5463 00002E4D E91200                   jmp @@getIndReg2221
  5464                                  @@getIndReg2220:
  5465 00002E50 A0[C401]                 mov al, [regindexbase]
  5466 00002E53 3C07                     cmp al, 7
  5467 00002E55 0F850900                 jne @@getIndReg2222
  5468 00002E59 66B800000000             mov eax, 0
  5469 00002E5F 8846FE                   mov byte [bp-2], al
  5470                                  
  5471                                  ;-186   if (m > 3) indexerror();
  5472                                  
  5473                                  @@getIndReg2222:
  5474                                  @@getIndReg2221:
  5475                                  @@getIndReg2219:
  5476 00002E62 8A46FE                   mov al, [bp-2]
  5477 00002E65 3C03                     cmp al, 3
  5478 00002E67 0F8E0300                 jle @@getIndReg2223
  5479 00002E6B E873F3                   call indexerror
  5480                                  
  5481                                  ;-187   return m;
  5482                                  
  5483                                  @@getIndReg2223:
  5484 00002E6E 8A46FE                   mov al, [bp-2]
  5485 00002E71 E90000                   jmp @@retn
  5486                                  
  5487                                  ;-188 }
  5488                                  
  5489                                  
  5490                                  ;-189          
  5491                                  
  5492                                  
  5493                                  ;-190          
  5494                                  
  5495                                  
  5496                                  ;-191 int setwflag() {
  5497                                  
  5498 00002E74 C9                      @@retn: LEAVE
  5499 00002E75 C3                       ret
  5500                                  ; ENDP
  5501                                  
  5502                                  setwflag:  ; *** PROC ***
  5503                                  
  5504                                  ;-192   wflag=0;
  5505                                  
  5506 00002E76 66B800000000             mov eax, 0
  5507 00002E7C A2[C101]                 mov byte [wflag], al
  5508                                  
  5509                                  ;-193   if (OpSize == 0) {//do not override OpSize
  5510                                  
  5511 00002E7F A0[C001]                 mov al, [OpSize]
  5512 00002E82 3C00                     cmp al, 0
  5513 00002E84 0F852100                 jne @@setwflag224
  5514                                  
  5515                                  ;-194     if (Op1 == REG) {
  5516                                  
  5517 00002E88 A0[B601]                 mov al, [Op1]
  5518 00002E8B 3C02                     cmp al, 2
  5519 00002E8D 0F851800                 jne @@setwflag225
  5520                                  
  5521                                  ;-195       OpSize=RegType;
  5522                                  
  5523 00002E91 A0[BE01]                 mov al, [RegType]
  5524 00002E94 A2[C001]                 mov byte [OpSize], al
  5525                                  
  5526                                  ;-196       if (RegType == SEGREG) OpSize=WORD;
  5527                                  
  5528 00002E97 A0[BE01]                 mov al, [RegType]
  5529 00002E9A 3C04                     cmp al, 4
  5530 00002E9C 0F850900                 jne @@setwflag226
  5531 00002EA0 66B802000000             mov eax, 2
  5532 00002EA6 A2[C001]                 mov byte [OpSize], al
  5533                                  
  5534                                  ;-197     }
  5535                                  
  5536                                  @@setwflag226:
  5537                                  
  5538                                  ;-198   }
  5539                                  
  5540                                  @@setwflag225:
  5541                                  
  5542                                  ;-199   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  5543                                  
  5544                                  @@setwflag224:
  5545 00002EA9 A0[C001]                 mov al, [OpSize]
  5546 00002EAC 3C03                     cmp al, 3
  5547 00002EAE 0F850C00                 jne @@setwflag227
  5548 00002EB2 E8CFF7                   call gen66h
  5549 00002EB5 66B801000000             mov eax, 1
  5550 00002EBB A2[C101]                 mov byte [wflag], al
  5551                                  
  5552                                  ;-200   if (OpSize  ==  WORD) wflag=1;
  5553                                  
  5554                                  @@setwflag227:
  5555 00002EBE A0[C001]                 mov al, [OpSize]
  5556 00002EC1 3C02                     cmp al, 2
  5557 00002EC3 0F850900                 jne @@setwflag228
  5558 00002EC7 66B801000000             mov eax, 1
  5559 00002ECD A2[C101]                 mov byte [wflag], al
  5560                                  
  5561                                  ;-201 }
  5562                                  
  5563                                  @@setwflag228:
  5564                                  
  5565                                  ;-202 
  5566                                  
  5567                                  
  5568                                  ;-203 int getSignExtended(unsigned int i) {  
  5569                                  
  5570 00002ED0 C3                       ret
  5571                                  ; ENDP
  5572                                  
  5573                                  getSignExtended:  ; *** PROC ***
  5574                                  
  5575                                  ;-204     sflag=2;
  5576                                  
  5577                                  ;Function : getSignExtended, Number of local variables: 1
  5578                                  ;   # type sign width line used address name   list of local variables
  5579                                  ;  200 var unsg word   203 NULL bp+4    i;
  5580 00002ED1 C8000000                 ENTER  0,0
  5581 00002ED5 66B802000000             mov eax, 2
  5582 00002EDB A2[C301]                 mov byte [sflag], al
  5583                                  
  5584                                  ;-205     if(i > 127) sflag = 0;
  5585                                  
  5586 00002EDE 8B4604                   mov ax, [bp+4]
  5587 00002EE1 83F87F                   cmp ax, 127
  5588 00002EE4 0F8E0900                 jle @@getSignExtended229
  5589 00002EE8 66B800000000             mov eax, 0
  5590 00002EEE A2[C301]                 mov byte [sflag], al
  5591                                  
  5592                                  ;-206 }
  5593                                  
  5594 00002EF1 C9                      @@getSignExtended229: LEAVE
  5595 00002EF2 C3                       ret
  5596                                  ; ENDP
  5597                                   
  5598                                  ; missing functions: 
  5599                                  ; digit
  5600                                  ; strcpy
  5601                                  ; eqstr
  5602                                  ; strlen
  5603                                  ; eqstr
  5604                                  ; eqstr
  5605                                  ; eqstr
  5606                                  ; eqstr
  5607                                  ; readRL
  5608                                  ; readRL
  5609                                  ; digit
  5610                                  ; digit
  5611                                  ; strcpy
  5612                                  ; toupper
  5613                                  ; strlen
  5614                                  ; strlen
  5615                                  ; eqstr
  5616                                  ; eqstr
  5617                                  ; eqstr
  5618                                  ; eqstr
  5619                                  ; eqstr
  5620                                  ; eqstr
  5621                                  ; eqstr
  5622                                  ; eqstr
  5623                                  ; eqstr
  5624                                  ; eqstr
  5625                                  ; eqstr
  5626                                  ; eqstr
  5627                                  ; eqstr
  5628                                  ; eqstr
  5629                                  ; eqstr
  5630                                  ; eqstr
  5631                                  ; eqstr
  5632                                  ; eqstr
  5633                                  ; eqstr
  5634                                  ; eqstr
  5635                                  ; eqstr
  5636                                  ; eqstr
  5637                                  ; eqstr
  5638                                  ; eqstr
  5639                                  ; eqstr
  5640                                  ; eqstr
  5641                                  ; eqstr
  5642                                  ; eqstr
  5643                                  ; eqstr
  5644                                  ; eqstr
  5645                                  ; writetty
  5646                                  ; writetty
  5647                                  ; fputcR
  5648                                  ; cputs
  5649                                  ; cputs
  5650                                  ; exitR
  5651                                  ; toupper
  5652                                  ; strcpy
  5653                                  ; strcat1
  5654                                  ; strcpy
  5655                                  ; strcat1
  5656                                  ; strcpy
  5657                                  ; strcat1
  5658                                  ; openR
  5659                                  ; cputs
  5660                                  ; cputs
  5661                                  ; exitR
  5662                                  ; creatR
  5663                                  ; cputs
  5664                                  ; cputs
  5665                                  ; exitR
  5666                                  ; creatR
  5667                                  ; cputs
  5668                                  ; cputs
  5669                                  ; exitR
  5670                                  ; fputcR
  5671                                  ; fcloseR
  5672                                  ; fcloseR
  5673                                  ; fcloseR
  5674                                  ; exitR
  5675                                  ; Number of unresolved CALLs :   76
  5676                                  ;use archive file: AR.C
  5677                                  
  5678                                  ;-207 // AR.C Archive
  5679                                  
  5680                                  ;Number of CALLs:    2 : writetty
  5681                                  
  5682                                  writetty:  ; *** PROC ***
  5683 00002EF3 B40E                     mov  ah, 14
  5684 00002EF5 BB0000                   mov  bx, 0
  5685 00002EF8 CD10                     int  16
  5686                                  
  5687                                  ;-208 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5688                                  
  5689 00002EFA C3                       ret
  5690                                  ; ENDP
  5691                                  ;Number of CALLs:    8 : cputs
  5692                                  
  5693                                  cputs:  ; *** PROC ***
  5694                                  ;Function : cputs, Number of local variables: 2
  5695                                  ;   # type sign width line used address name   list of local variables
  5696                                  ;  200 ptr sign byte   208 NULL bp+4    s
  5697                                  ;  201 var sign byte   208 NULL bp-2    c;
  5698 00002EFB C8020000                 ENTER  2,0
  5699                                  @@cputs230:
  5700 00002EFF 8B5E04                   mov bx, [bp+4]
  5701 00002F02 8A07                     mov al, [bx]
  5702 00002F04 B400                     mov ah, 0
  5703 00002F06 08C0                     or  al, al
  5704 00002F08 0F841B00                 je @@cputs231
  5705 00002F0C 8B5E04                   mov bx, [bp+4]
  5706 00002F0F 8A07                     mov al, [bx]
  5707 00002F11 B400                     mov ah, 0
  5708 00002F13 8846FE                   mov byte [bp-2], al
  5709 00002F16 8A46FE                   mov al, byte [bp-2]
  5710 00002F19 B400                     mov ah, 0
  5711 00002F1B 50                       push ax
  5712 00002F1C E8C401                   call putch
  5713 00002F1F 83C402                   add  sp, 2
  5714 00002F22 FF4604                   inc  word [bp+4]
  5715 00002F25 EBD8                     jmp @@cputs230
  5716                                  @@cputs231:
  5717                                  
  5718                                  ;-209 int mkneg(int n) { n; __asm {neg ax} }
  5719 00002F27 C9                       LEAVE
  5720 00002F28 C3                       ret
  5721                                  ; ENDP
  5722                                  ;Number of CALLs:    2 : toupper
  5723                                  
  5724                                  toupper:  ; *** PROC ***
  5725                                  ;Function : toupper, Number of local variables: 1
  5726                                  ;   # type sign width line used address name   list of local variables
  5727                                  ;  200 ptr sign byte   209 NULL bp+4    s;
  5728 00002F29 C8000000                 ENTER  0,0
  5729                                  @@toupper232:
  5730 00002F2D 8B5E04                   mov bx, [bp+4]
  5731 00002F30 8A07                     mov al, [bx]
  5732 00002F32 B400                     mov ah, 0
  5733 00002F34 08C0                     or  al, al
  5734 00002F36 0F843000                 je @@toupper233
  5735 00002F3A 8B5E04                   mov bx, [bp+4]
  5736 00002F3D 8A07                     mov al, [bx]
  5737 00002F3F B400                     mov ah, 0
  5738 00002F41 83F861                   cmp ax, 97 ;unsigned : 1
  5739 00002F44 0F8C1D00                 jl  @@toupper234
  5740 00002F48 8B5E04                   mov bx, [bp+4]
  5741 00002F4B 8A07                     mov al, [bx]
  5742 00002F4D B400                     mov ah, 0
  5743 00002F4F 83F87A                   cmp ax, 122
  5744 00002F52 0F8F0F00                 jg  @@toupper235
  5745 00002F56 8B5E04                   mov bx, [bp+4]
  5746 00002F59 8A07                     mov al, [bx]
  5747 00002F5B B400                     mov ah, 0
  5748 00002F5D 83E820                   sub ax, 32
  5749 00002F60 8B5E04                   mov  bx, [bp+4]
  5750 00002F63 8807                     mov  [bx], al
  5751                                  @@toupper235:
  5752                                  @@toupper234:
  5753 00002F65 FF4604                   inc  word [bp+4]
  5754 00002F68 EBC3                     jmp @@toupper232
  5755                                  @@toupper233:
  5756                                  
  5757                                  ;-210 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5758                                  
  5759                                  
  5760                                  ;-211 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5761 00002F6A C9                       LEAVE
  5762 00002F6B C3                       ret
  5763                                  ; ENDP
  5764                                  ;Number of CALLs:    3 : strlen
  5765                                  
  5766                                  strlen:  ; *** PROC ***
  5767                                  ;Function : strlen, Number of local variables: 2
  5768                                  ;   # type sign width line used address name   list of local variables
  5769                                  ;  200 ptr sign byte   211 NULL bp+4    s
  5770                                  ;  201 var sign word   211 NULL bp-2    c;
  5771 00002F6C C8020000                 ENTER  2,0
  5772 00002F70 66B800000000             mov eax, 0
  5773 00002F76 8946FE                   mov word [bp-2], ax
  5774                                  @@strlen236:
  5775 00002F79 8B5E04                   mov bx, [bp+4]
  5776 00002F7C 8A07                     mov al, [bx]
  5777 00002F7E B400                     mov ah, 0
  5778 00002F80 83F800                   cmp ax, 0
  5779 00002F83 0F840800                 je  @@strlen237
  5780 00002F87 FF4604                   inc  word [bp+4]
  5781 00002F8A FF46FE                   inc  word [bp-2]
  5782 00002F8D EBEA                     jmp @@strlen236
  5783                                  @@strlen237:
  5784 00002F8F 8B46FE                   mov ax, [bp-2]
  5785 00002F92 E90000                   jmp @@retn
  5786                                  
  5787                                  ;-212 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5788                                  
  5789 00002F95 C9                      @@retn: LEAVE
  5790 00002F96 C3                       ret
  5791                                  ; ENDP
  5792                                  ;Number of CALLs:    5 : strcpy
  5793                                  
  5794                                  strcpy:  ; *** PROC ***
  5795                                  ;Function : strcpy, Number of local variables: 2
  5796                                  ;   # type sign width line used address name   list of local variables
  5797                                  ;  200 ptr sign byte   212 NULL bp+4    s
  5798                                  ;  201 ptr sign byte   212 NULL bp+6    t;
  5799 00002F97 C8000000                 ENTER  0,0
  5800                                  @@strcpy238:
  5801 00002F9B 8B5E06                   mov bx, [bp+6]
  5802 00002F9E 8A07                     mov al, [bx]
  5803 00002FA0 B400                     mov ah, 0
  5804 00002FA2 8B5E04                   mov  bx, [bp+4]
  5805 00002FA5 8807                     mov  [bx], al
  5806 00002FA7 FF4604                   inc  word [bp+4]
  5807 00002FAA FF4606                   inc  word [bp+6]
  5808                                  
  5809                                  ;-213   while (*t!=0); *s=0; return s; }
  5810                                  
  5811 00002FAD 8B5E06                   mov bx, [bp+6]
  5812 00002FB0 8A07                     mov al, [bx]
  5813 00002FB2 B400                     mov ah, 0
  5814 00002FB4 83F800                   cmp ax, 0
  5815 00002FB7 0F840200                 je  @@strcpy239
  5816 00002FBB EBDE                     jmp @@strcpy238
  5817                                  @@strcpy239:
  5818 00002FBD 66B800000000             mov eax, 0
  5819 00002FC3 8B5E04                   mov  bx, [bp+4]
  5820 00002FC6 8807                     mov  [bx], al
  5821 00002FC8 8B4604                   mov ax, [bp+4]
  5822 00002FCB E90000                   jmp @@retn
  5823                                  
  5824                                  ;-214 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5825                                  
  5826 00002FCE C9                      @@retn: LEAVE
  5827 00002FCF C3                       ret
  5828                                  ; ENDP
  5829                                  ;Number of CALLs:    3 : digit
  5830                                  
  5831                                  digit:  ; *** PROC ***
  5832                                  ;Function : digit, Number of local variables: 1
  5833                                  ;   # type sign width line used address name   list of local variables
  5834                                  ;  200 var sign byte   214 NULL bp+4    c;
  5835 00002FD0 C8000000                 ENTER  0,0
  5836 00002FD4 8A4604                   mov al, [bp+4]
  5837 00002FD7 3C30                     cmp al, 48
  5838 00002FD9 0F8D0900                 jge @@digit240
  5839 00002FDD 66B800000000             mov eax, 0
  5840 00002FE3 E91B00                   jmp @@retn
  5841                                  @@digit240:
  5842 00002FE6 8A4604                   mov al, [bp+4]
  5843 00002FE9 3C39                     cmp al, 57
  5844 00002FEB 0F8E0900                 jle @@digit241
  5845 00002FEF 66B800000000             mov eax, 0
  5846 00002FF5 E90900                   jmp @@retn
  5847                                  @@digit241:
  5848 00002FF8 66B801000000             mov eax, 1
  5849 00002FFE E90000                   jmp @@retn
  5850                                  
  5851                                  ;-215 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5852                                  
  5853 00003001 C9                      @@retn: LEAVE
  5854 00003002 C3                       ret
  5855                                  ; ENDP
  5856                                  ;Number of CALLs:   35 : eqstr
  5857                                  
  5858                                  eqstr:  ; *** PROC ***
  5859                                  ;Function : eqstr, Number of local variables: 2
  5860                                  ;   # type sign width line used address name   list of local variables
  5861                                  ;  200 ptr sign byte   215 NULL bp+4    p
  5862                                  ;  201 ptr sign byte   215 NULL bp+6    q;
  5863 00003003 C8000000                 ENTER  0,0
  5864                                  @@eqstr242:
  5865 00003007 8B5E04                   mov bx, [bp+4]
  5866 0000300A 8A07                     mov al, [bx]
  5867 0000300C B400                     mov ah, 0
  5868 0000300E 08C0                     or  al, al
  5869 00003010 0F842300                 je @@eqstr243
  5870                                  
  5871                                  ;-216     if (*p != *q) return 0; p++; q++; }
  5872                                  
  5873 00003014 8B5E04                   mov bx, [bp+4]
  5874 00003017 8A07                     mov al, [bx]
  5875 00003019 B400                     mov ah, 0
  5876 0000301B 8B5E06                   mov bx, [bp+6]
  5877 0000301E 3A07                     cmp al, [bx]
  5878 00003020 B400                     mov ah, 0
  5879 00003022 0F840900                 je  @@eqstr244
  5880 00003026 66B800000000             mov eax, 0
  5881 0000302C E92700                   jmp @@retn
  5882                                  @@eqstr244:
  5883 0000302F FF4604                   inc  word [bp+4]
  5884 00003032 FF4606                   inc  word [bp+6]
  5885                                  
  5886                                  ;-217     if(*q) return 0; return 1; }
  5887                                  
  5888 00003035 EBD0                     jmp @@eqstr242
  5889                                  @@eqstr243:
  5890 00003037 8B5E06                   mov bx, [bp+6]
  5891 0000303A 8A07                     mov al, [bx]
  5892 0000303C B400                     mov ah, 0
  5893 0000303E 08C0                     or  al, al
  5894 00003040 0F840900                 je @@eqstr245
  5895 00003044 66B800000000             mov eax, 0
  5896 0000304A E90900                   jmp @@retn
  5897                                  @@eqstr245:
  5898 0000304D 66B801000000             mov eax, 1
  5899 00003053 E90000                   jmp @@retn
  5900                                  
  5901                                  ;-218 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5902                                  
  5903 00003056 C9                      @@retn: LEAVE
  5904 00003057 C3                       ret
  5905                                  ; ENDP
  5906                                  ;Number of CALLs:    3 : strcat1
  5907                                  
  5908                                  strcat1:  ; *** PROC ***
  5909                                  ;Function : strcat1, Number of local variables: 2
  5910                                  ;   # type sign width line used address name   list of local variables
  5911                                  ;  200 ptr sign byte   218 NULL bp+4    s
  5912                                  ;  201 ptr sign byte   218 NULL bp+6    t;
  5913 00003058 C8000000                 ENTER  0,0
  5914                                  @@strcat1246:
  5915 0000305C 8B5E04                   mov bx, [bp+4]
  5916 0000305F 8A07                     mov al, [bx]
  5917 00003061 B400                     mov ah, 0
  5918 00003063 83F800                   cmp ax, 0
  5919 00003066 0F840500                 je  @@strcat1247
  5920 0000306A FF4604                   inc  word [bp+4]
  5921 0000306D EBED                     jmp @@strcat1246
  5922                                  @@strcat1247:
  5923 0000306F FF7606                   push word [bp+6]
  5924 00003072 FF7604                   push word [bp+4]
  5925 00003075 E81FFF                   call strcpy
  5926 00003078 83C404                   add  sp, 4
  5927                                  
  5928                                  ;-219 int basename(char *s) { char *p; p=0;
  5929 0000307B C9                       LEAVE
  5930 0000307C C3                       ret
  5931                                  ; ENDP
  5932                                  ;Number of CALLs:    1 : openR
  5933                                  
  5934                                  openR:  ; *** PROC ***
  5935                                  ;Function : openR, Number of local variables: 1
  5936                                  ;   # type sign width line used address name   list of local variables
  5937                                  ;  200 ptr sign byte   219 NULL bp+4    s;
  5938 0000307D C8000000                 ENTER  0,0
  5939 00003081 8B5604                   mov  dx, [bp+4]
  5940 00003084 B8023D                   mov  ax, 15618
  5941 00003087 E87200                   call DosInt
  5942                                  
  5943                                  ;-220 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5944 0000308A C9                       LEAVE
  5945 0000308B C3                       ret
  5946                                  ; ENDP
  5947                                  ;Number of CALLs:    2 : creatR
  5948                                  
  5949                                  creatR:  ; *** PROC ***
  5950                                  ;Function : creatR, Number of local variables: 1
  5951                                  ;   # type sign width line used address name   list of local variables
  5952                                  ;  200 ptr sign byte   220 NULL bp+4    s;
  5953 0000308C C8000000                 ENTER  0,0
  5954 00003090 8B5604                   mov  dx, [bp+4]
  5955 00003093 B90000                   mov  cx, 0
  5956 00003096 B8003C                   mov  ax, 15360
  5957 00003099 E86000                   call DosInt
  5958                                  
  5959                                  ;-221 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5960 0000309C C9                       LEAVE
  5961 0000309D C3                       ret
  5962                                  ; ENDP
  5963                                  ;Number of CALLs:    2 : readRL
  5964                                  
  5965                                  readRL:  ; *** PROC ***
  5966                                  ;Function : readRL, Number of local variables: 3
  5967                                  ;   # type sign width line used address name   list of local variables
  5968                                  ;  200 ptr sign byte   221 NULL bp+4    s
  5969                                  ;  201 var sign word   221 NULL bp+6    fd
  5970                                  ;  202 var sign word   221 NULL bp+8    len;
  5971 0000309E C8000000                 ENTER  0,0
  5972 000030A2 8B5604                   mov  dx, [bp+4]
  5973 000030A5 8B4E08                   mov  cx, [bp+8]
  5974 000030A8 8B5E06                   mov  bx, [bp+6]
  5975 000030AB B8003F                   mov  ax, 16128
  5976 000030AE E84B00                   call DosInt
  5977                                  
  5978                                  ;-222 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5979 000030B1 C9                       LEAVE
  5980 000030B2 C3                       ret
  5981                                  ; ENDP
  5982                                  ;Number of CALLs:    2 : fputcR
  5983                                  
  5984                                  fputcR:  ; *** PROC ***
  5985                                  ;Function : fputcR, Number of local variables: 2
  5986                                  ;   # type sign width line used address name   list of local variables
  5987                                  ;  200 ptr sign byte   222 NULL bp+4    n
  5988                                  ;  201 var sign word   222 NULL bp+6    fd;
  5989 000030B3 C8000000                 ENTER  0,0
  5990 000030B7 8D5604                  lea dx, [bp+4]
  5991                                  
  5992                                  ;-223   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5993                                  
  5994 000030BA B90100                   mov  cx, 1
  5995 000030BD 8B5E06                   mov  bx, [bp+6]
  5996 000030C0 B80040                   mov  ax, 16384
  5997 000030C3 E83600                   call DosInt
  5998                                  
  5999                                  ;-224 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  6000 000030C6 C9                       LEAVE
  6001 000030C7 C3                       ret
  6002                                  ; ENDP
  6003                                  ;Number of CALLs:    3 : fcloseR
  6004                                  
  6005                                  fcloseR:  ; *** PROC ***
  6006                                  ;Function : fcloseR, Number of local variables: 1
  6007                                  ;   # type sign width line used address name   list of local variables
  6008                                  ;  200 var sign word   224 NULL bp+4    fd;
  6009 000030C8 C8000000                 ENTER  0,0
  6010 000030CC 8B5E04                   mov  bx, [bp+4]
  6011 000030CF B8003E                   mov  ax, 15872
  6012 000030D2 CD21                     int  33
  6013                                  
  6014                                  ;-225 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  6015 000030D4 C9                       LEAVE
  6016 000030D5 C3                       ret
  6017                                  ; ENDP
  6018                                  ;Number of CALLs:    5 : exitR
  6019                                  
  6020                                  exitR:  ; *** PROC ***
  6021                                  ;Function : exitR, Number of local variables: 1
  6022                                  ;   # type sign width line used address name   list of local variables
  6023                                  ;  200 var sign byte   225 NULL bp+4    c;
  6024 000030D6 C8000000                 ENTER  0,0
  6025 000030DA B44C                     mov  ah, 76
  6026 000030DC 8A4604                   mov  al, [bp+4]
  6027 000030DF CD21                     int  33
  6028                                  
  6029                                  ;-226 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  6030 000030E1 C9                       LEAVE
  6031 000030E2 C3                       ret
  6032                                  ; ENDP
  6033                                  ;End of archive file. 
  6034                                   
  6035                                  ; missing functions: 
  6036                                  ; putch
  6037                                  ; DosInt
  6038                                  ; DosInt
  6039                                  ; DosInt
  6040                                  ; DosInt
  6041                                  ; Number of unresolved CALLs :    5
  6042                                  ;use archive file: AR.C
  6043                                  
  6044                                  ;-227 // AR.C Archive
  6045                                  
  6046                                  ;Number of CALLs:    1 : putch
  6047                                  
  6048                                  putch:  ; *** PROC ***
  6049                                  ;Function : putch, Number of local variables: 1
  6050                                  ;   # type sign width line used address name   list of local variables
  6051                                  ;  200 var sign byte   227 NULL bp+4    c;
  6052 000030E3 C8000000                 ENTER  0,0
  6053 000030E7 807E040A                cmp byte [bp+4], 10
  6054 000030EB 0F850500                 jne @@putch248
  6055 000030EF B00D                     mov  al, 13
  6056 000030F1 E8FFFD                   call writetty
  6057                                  @@putch248:
  6058 000030F4 8A4604                   mov  al, [bp+4]
  6059 000030F7 E8F9FD                   call writetty
  6060                                  
  6061                                  ;-228 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  6062 000030FA C9                       LEAVE
  6063 000030FB C3                       ret
  6064                                  ; ENDP
  6065                                  ;Number of CALLs:    4 : DosInt
  6066                                  
  6067                                  DosInt:  ; *** PROC ***
  6068 000030FC CD21                     int  33
  6069 000030FE 7304                     jae short @@DosInt249
  6070 00003100 FF06[A901]               inc  word [DOS_ERR]
  6071                                  @@DosInt249:
  6072                                  
  6073                                  ;-229 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  6074                                  
  6075 00003104 C3                       ret
  6076                                  ; ENDP
  6077                                  ;End of archive file. 
  6078                                   
  6079                                  ; missing functions:  All FUNCTIONs in place
  6080 00003105 E80000                  LastFunctionByt:db 0E8h, 0, 0
  6081 00003108 58                      pop ax
  6082 00003109 C3                      ret
  6083                                   
  6084                                  ;   # type sign width line used  address name   list of global variables
  6085                                  
  6086                                  ;    1 arr sign byte     1    2        0 Version1[20]
  6087                                  ;    2 var sign byte     1    3        0 LIST
  6088                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  6089                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  6090                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  6091                                  ;    6 var unsg word     5   12        0 SymbolInt
  6092                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  6093                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  6094                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  6095                                  ;   10 arr sign byte     9    5        0 namein[67]
  6096                                  ;   11 arr sign byte    10    5        0 namelst[67]
  6097                                  ;   12 arr sign byte    11    5        0 namebin[67]
  6098                                  ;   13 var sign word    12    4        0 asm_fd
  6099                                  ;   14 var sign word    13    3        0 lst_fd
  6100                                  ;   15 var sign word    14    3        0 bin_fd
  6101                                  ;   16 var sign word    15    6        0 DOS_ERR
  6102                                  ;   17 var sign word    16    4        0 ErrorCount
  6103                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  6104                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  6105                                  ;   20 var unsg word    20    5        0 PC
  6106                                  ;   21 var unsg word    21    2        0 PCStart
  6107                                  ;   22 var sign byte    22    3        0 isLabel
  6108                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  6109                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  6110                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  6111                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  6112                                  ;   27 var sign byte    27   21        0 TokeType
  6113                                  ;   28 def unsg byte    28    -        0 BYTE=1
  6114                                  ;   29 def unsg byte    29    -        0 WORD=2
  6115                                  ;   30 def unsg byte    30    -        0 DWORD=3
  6116                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  6117                                  ;   32 def unsg byte    32    -        0 IMM=1
  6118                                  ;   33 def unsg byte    33    -        0 REG=2
  6119                                  ;   34 def unsg byte    34    -        0 ADR=3
  6120                                  ;   35 def unsg byte    35    -        0 MEM=4
  6121                                  ;   36 var sign byte    36   19        0 Op1
  6122                                  ;   37 var sign byte    37    1        0 Optemp
  6123                                  ;   38 var sign byte    38   13        0 CodeType
  6124                                  ;   39 var sign byte    39   11        0 Code1
  6125                                  ;   40 var sign byte    40    6        0 Code2
  6126                                  ;   41 var sign byte    41    3        0 Code3
  6127                                  ;   42 var sign byte    42   12        0 RegNo
  6128                                  ;   43 var sign byte    43    4        0 R1No
  6129                                  ;   44 var sign byte    44   19        0 RegType
  6130                                  ;   45 var sign byte    45    1        0 R1Type
  6131                                  ;   46 var sign byte    46   10        0 OpSize
  6132                                  ;   47 var sign byte    47    5        0 wflag
  6133                                  ;   48 var sign byte    50 NULL        0 dflag
  6134                                  ;   49 var sign byte    51    3        0 sflag
  6135                                  ;   50 var sign byte    53   15        0 regindexbase
  6136                                  ;   51 var sign byte    54    3        0 isDirect
  6137                                  ;   52 var sign word    55   14        0 disp
  6138                                  ;   53 var sign word    56    5        0 imme
  6139                                  ;   54 def unsg byte    58    -        0 OPMAXLEN=5
  6140                                  ;   55 arr sign byte    59    2        0 OpPos[5]
  6141                                  ;   56 var sign word    60    6        0 OpPrintIndex
  6142                                  ;   57 ptr sign byte    61   17        0 OpCodePtr
  6143                                  ;   58 var sign byte    62    2        0 PrintR
  6144                                  ;   59 def unsg byte    64    -        0 LABELNAMESMAX=969
  6145                                  ;   60 arr sign byte    65    3        0 LabelNames[1000]
  6146                                  ;   61 ptr sign byte    66    5        0 LabelNamePtr
  6147                                  ;   62 def unsg byte    67    -        0 LABELADRMAX=100
  6148                                  ;   63 arr unsg word    68    3        0 LabelAddr[100]
  6149                                  ;   64 var sign word    69    4        0 LabelMaxIx
  6150                                  ;   65 var sign word    70    4        0 LabelIx
  6151                                  ;   66 def unsg byte    72    -        0 FILEBINMAX=2000
  6152                                  ;   67 arr sign byte    73    2        0 FileBin[2000]
  6153                                  ;   68 var unsg word    74    5        0 BinLen
  6154                                  ;   69 ptr sign byte    76    1        0 arglen
  6155                                  ;   70 ptr sign byte    77    4        0 argv
  6156                                  ;   71 var sign byte     1    1        0 I_START
  6157                                  ;   72 arr sign byte     4 NULL        0 I_PUSHA[9]
  6158                                  ;   73 arr sign byte     5 NULL        0 I_POPA[8]
  6159                                  ;   74 arr sign byte     6 NULL        0 I_NOP[7]
  6160                                  ;   75 arr sign byte     7 NULL        0 I_CBW[7]
  6161                                  ;   76 arr sign byte     8 NULL        0 I_CWDE[8]
  6162                                  ;   77 arr sign byte     9 NULL        0 I_CWD[7]
  6163                                  ;   78 arr sign byte    10 NULL        0 I_CDQ[7]
  6164                                  ;   79 arr sign byte    11 NULL        0 I_WAIT[8]
  6165                                  ;   80 arr sign byte    12 NULL        0 I_PUSHF[9]
  6166                                  ;   81 arr sign byte    13 NULL        0 I_POPF[8]
  6167                                  ;   82 arr sign byte    14 NULL        0 I_SAHF[8]
  6168                                  ;   83 arr sign byte    15 NULL        0 I_LAHF[8]
  6169                                  ;   84 arr sign byte    16 NULL        0 I_MOVSB[9]
  6170                                  ;   85 arr sign byte    17 NULL        0 I_MOVSW[9]
  6171                                  ;   86 arr sign byte    18 NULL        0 I_CMPSB[9]
  6172                                  ;   87 arr sign byte    19 NULL        0 I_CMPSW[9]
  6173                                  ;   88 arr sign byte    20 NULL        0 I_STOSB[9]
  6174                                  ;   89 arr sign byte    21 NULL        0 I_STOSW[9]
  6175                                  ;   90 arr sign byte    22 NULL        0 I_LODSB[9]
  6176                                  ;   91 arr sign byte    23 NULL        0 I_LODSW[9]
  6177                                  ;   92 arr sign byte    24 NULL        0 I_SCASB[9]
  6178                                  ;   93 arr sign byte    25 NULL        0 I_SCASW[9]
  6179                                  ;   94 arr sign byte    26 NULL        0 I_LEAVE[9]
  6180                                  ;   95 arr sign byte    27 NULL        0 I_IRET[8]
  6181                                  ;   96 arr sign byte    28 NULL        0 I_XLAT[8]
  6182                                  ;   97 arr sign byte    29 NULL        0 I_LOCK[8]
  6183                                  ;   98 arr sign byte    30 NULL        0 I_REPNE[9]
  6184                                  ;   99 arr sign byte    31 NULL        0 I_REPNZ[9]
  6185                                  ;  100 arr sign byte    32 NULL        0 I_REPE[8]
  6186                                  ;  101 arr sign byte    33 NULL        0 I_REPZ[8]
  6187                                  ;  102 arr sign byte    34 NULL        0 I_HLT[7]
  6188                                  ;  103 arr sign byte    35 NULL        0 I_CLC[7]
  6189                                  ;  104 arr sign byte    36 NULL        0 I_STC[7]
  6190                                  ;  105 arr sign byte    37 NULL        0 I_CLI[7]
  6191                                  ;  106 arr sign byte    38 NULL        0 I_STI[7]
  6192                                  ;  107 arr sign byte    39 NULL        0 I_CLD[7]
  6193                                  ;  108 arr sign byte    40 NULL        0 I_STD[7]
  6194                                  ;  109 arr sign byte    42 NULL        0 I_INC[9]
  6195                                  ;  110 arr sign byte    43 NULL        0 I_DEC[9]
  6196                                  ;  111 arr sign byte    44 NULL        0 I_NOT[8]
  6197                                  ;  112 arr sign byte    45 NULL        0 I_NEG[8]
  6198                                  ;  113 arr sign byte    46 NULL        0 I_MUL[8]
  6199                                  ;  114 arr sign byte    47 NULL        0 I_IMUL[9]
  6200                                  ;  115 arr sign byte    48 NULL        0 I_DIV[8]
  6201                                  ;  116 arr sign byte    49 NULL        0 I_IDIV[9]
  6202                                  ;  117 arr sign byte    51 NULL        0 I_LES[7]
  6203                                  ;  118 arr sign byte    52 NULL        0 I_LDS[7]
  6204                                  ;  119 arr sign byte    53 NULL        0 I_LEA[7]
  6205                                  ;  120 arr sign byte    54 NULL        0 I_LSS[8]
  6206                                  ;  121 arr sign byte    55 NULL        0 I_LFS[8]
  6207                                  ;  122 arr sign byte    56 NULL        0 I_LGS[8]
  6208                                  ;  123 arr sign byte    58 NULL        0 I_ADD[7]
  6209                                  ;  124 arr sign byte    59 NULL        0 I_OR[6]
  6210                                  ;  125 arr sign byte    60 NULL        0 I_ADC[7]
  6211                                  ;  126 arr sign byte    61 NULL        0 I_SBB[7]
  6212                                  ;  127 arr sign byte    62 NULL        0 I_AND[7]
  6213                                  ;  128 arr sign byte    63 NULL        0 I_SUB[7]
  6214                                  ;  129 arr sign byte    64 NULL        0 I_XOR[7]
  6215                                  ;  130 arr sign byte    65 NULL        0 I_CMP[7]
  6216                                  ;  131 arr sign byte    66 NULL        0 I_TEST[11]
  6217                                  ;  132 arr sign byte    68 NULL        0 I_MOV[6]
  6218                                  ;  133 arr sign byte    69 NULL        0 I_MOVSX[9]
  6219                                  ;  134 arr sign byte    70 NULL        0 I_MOVZX[9]
  6220                                  ;  135 arr sign byte    72 NULL        0 I_JO[6]
  6221                                  ;  136 arr sign byte    73 NULL        0 I_JNO[7]
  6222                                  ;  137 arr sign byte    74 NULL        0 I_JB[6]
  6223                                  ;  138 arr sign byte    75 NULL        0 I_JC[6]
  6224                                  ;  139 arr sign byte    76 NULL        0 I_JNB[7]
  6225                                  ;  140 arr sign byte    77 NULL        0 I_JAE[7]
  6226                                  ;  141 arr sign byte    78 NULL        0 I_JNC[7]
  6227                                  ;  142 arr sign byte    79 NULL        0 I_JE[6]
  6228                                  ;  143 arr sign byte    80 NULL        0 I_JZ[6]
  6229                                  ;  144 arr sign byte    81 NULL        0 I_JNE[7]
  6230                                  ;  145 arr sign byte    82 NULL        0 I_JNZ[7]
  6231                                  ;  146 arr sign byte    83 NULL        0 I_JBE[7]
  6232                                  ;  147 arr sign byte    84 NULL        0 I_JNA[7]
  6233                                  ;  148 arr sign byte    85 NULL        0 I_JA[6]
  6234                                  ;  149 arr sign byte    86 NULL        0 I_JS[6]
  6235                                  ;  150 arr sign byte    87 NULL        0 I_JNS[7]
  6236                                  ;  151 arr sign byte    88 NULL        0 I_JP[6]
  6237                                  ;  152 arr sign byte    89 NULL        0 I_JPE[7]
  6238                                  ;  153 arr sign byte    90 NULL        0 I_JNP[7]
  6239                                  ;  154 arr sign byte    91 NULL        0 I_JPO[7]
  6240                                  ;  155 arr sign byte    92 NULL        0 I_JL[6]
  6241                                  ;  156 arr sign byte    93 NULL        0 I_JNL[7]
  6242                                  ;  157 arr sign byte    94 NULL        0 I_JGE[7]
  6243                                  ;  158 arr sign byte    95 NULL        0 I_JLE[7]
  6244                                  ;  159 arr sign byte    96 NULL        0 I_JNG[7]
  6245                                  ;  160 arr sign byte    97 NULL        0 I_JG[6]
  6246                                  ;  161 arr sign byte    99 NULL        0 I_JMP[8]
  6247                                  ;  162 arr sign byte   100 NULL        0 I_CALL[9]
  6248                                  ;  163 arr sign byte   102 NULL        0 I_RET[8]
  6249                                  ;  164 arr sign byte   103 NULL        0 I_RETF[9]
  6250                                  ;  165 arr sign byte   105 NULL        0 I_PUSH[8]
  6251                                  ;  166 arr sign byte   106 NULL        0 I_POP[7]
  6252                                  ;  167 arr sign byte   108 NULL        0 I_ROL[7]
  6253                                  ;  168 arr sign byte   109 NULL        0 I_ROR[7]
  6254                                  ;  169 arr sign byte   110 NULL        0 I_RCL[7]
  6255                                  ;  170 arr sign byte   111 NULL        0 I_RCR[7]
  6256                                  ;  171 arr sign byte   112 NULL        0 I_SHL[7]
  6257                                  ;  172 arr sign byte   113 NULL        0 I_SAL[7]
  6258                                  ;  173 arr sign byte   114 NULL        0 I_SHR[7]
  6259                                  ;  174 arr sign byte   115 NULL        0 I_SAR[7]
  6260                                  ;  175 arr sign byte   117 NULL        0 I_INT[8]
  6261                                  ;  176 arr sign byte   118 NULL        0 I_INTO[8]
  6262                                  ;  177 arr sign byte   129 NULL        0 I_XCHG[9]
  6263                                  ;  178 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6264                                  ;  179 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6265                                  ;  180 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6266                                  ;  181 arr sign byte   134 NULL        0 I_LOOPE[9]
  6267                                  ;  182 arr sign byte   135 NULL        0 I_LOOP[8]
  6268                                  ;  183 arr sign byte   136 NULL        0 I_JCXZ[8]
  6269                                  ;  184 arr sign byte   137 NULL        0 I_JECXZ[9]
  6270                                  ;  185 arr sign byte   139 NULL        0 I_ENTER[9]
  6271                                  ;  186 arr sign byte   141 NULL        0 I_ORG[6]
  6272                                  ;  187 arr sign byte   146 NULL        0 I_DB[5]
  6273                                  ;  188 arr sign byte   147 NULL        0 I_DW[5]
  6274                                  ;  189 arr sign byte   148 NULL        0 I_DD[5]
  6275                                  ;  190 arr sign byte   149 NULL        0 I_RESB[7]
  6276                                  ;  191 arr sign byte   150 NULL        0 I_RESW[7]
  6277                                  ;  192 arr sign byte   151 NULL        0 I_RESD[7]
  6278                                  ;  193 var sign byte   152 NULL        0 I_END
  6279                                  
  6280                                  
  6281                                  ;   # Calls Line Width  Name   list of functions
  6282                                  
  6283                                  ;    0    1    1 word   parse
  6284                                  ;    1   14   27 word   getTokeType
  6285                                  ;    2    2   36 word   storeLabel
  6286                                  ;    3    2   46 word   searchLabel
  6287                                  ;    4    1   57 word   getVariable
  6288                                  ;    5    2   86 word   lookCode
  6289                                  ;    6    1  101 word   getCodeSize
  6290                                  ;    7    8  108 word   isToken
  6291                                  ;    8    2  113 word   need
  6292                                  ;    9    1  123 word   skipRest
  6293                                  ;   10    1    1 word   getLine
  6294                                  ;   11    1   17 word   ifEOL
  6295                                  ;   12    3   24 word   skipBlank
  6296                                  ;   13    2   29 word   letterE
  6297                                  ;   14    1   39 word   alnumE
  6298                                  ;   15    1   44 word   getDigit
  6299                                  ;   16    1   56 word   getName
  6300                                  ;   17    1   75 word   testReg
  6301                                  ;   18    1    1 word   printLine
  6302                                  ;   19    8   19 word   prc
  6303                                  ;   20    1   23 word   prscomment
  6304                                  ;   21   21   26 word   prs
  6305                                  ;   22    3   31 word   printhex8a
  6306                                  ;   23    1   35 word   printhex16
  6307                                  ;   24    3   38 word   printIntU
  6308                                  ;   25   25   45 word   error1
  6309                                  ;   26 NULL   48 word   allowederror
  6310                                  ;   27    1   49 word   addrerror
  6311                                  ;   28    2   50 word   immeerror
  6312                                  ;   29    2   51 word   implerror
  6313                                  ;   30    4   52 word   indexerror
  6314                                  ;   31    1   53 word   invaloperror
  6315                                  ;   32    1   54 word   numbererror
  6316                                  ;   33 NULL   55 word   regmemerror
  6317                                  ;   34    1   56 word   reg16error
  6318                                  ;   35    1   57 word   segregerror
  6319                                  ;   36    1   58 word   syntaxerror
  6320                                  ;   37   12   60 word   errorexit
  6321                                  ;   38    1   61 word   addrexit
  6322                                  ;   39 NULL   62 word   internexit
  6323                                  ;   40 NULL    1 word   main
  6324                                  ;   41    1    8 word   getarg
  6325                                  ;   42    1   38 word   epilog
  6326                                  ;   43    2   67 word   end1
  6327                                  ;   44    1    2 word   getCodes
  6328                                  ;   45    1    7 word   gen66h
  6329                                  ;   46    2    9 word   genCode
  6330                                  ;   47    3   13 word   genCodeW
  6331                                  ;   48   15   17 word   genCode8
  6332                                  ;   49    4   28 word   genCode16
  6333                                  ;   50    3   32 word   writeEA
  6334                                  ;   51    1   67 word   genImmediate
  6335                                  ;   52    1   11 word   process
  6336                                  ;   53    3  100 word   checkOp
  6337                                  ;   54    3  121 word   getOp
  6338                                  ;   55    2  134 word   getOp1
  6339                                  ;   56    1  150 word   getMEM
  6340                                  ;   57    1  172 word   getIndReg1
  6341                                  ;   58    1  180 word   getIndReg2
  6342                                  ;   59    1  191 word   setwflag
  6343                                  ;   60    1  203 word   getSignExtended
  6344                                  ;   61    4  207 word   writetty
  6345                                  ;   62    8  208 word   cputs
  6346                                  ;   63    2  209 word   toupper
  6347                                  ;   64    3  211 word   strlen
  6348                                  ;   65    6  212 word   strcpy
  6349                                  ;   66    3  214 word   digit
  6350                                  ;   67   35  215 word   eqstr
  6351                                  ;   68    3  218 word   strcat1
  6352                                  ;   69    1  219 word   openR
  6353                                  ;   70    2  220 word   creatR
  6354                                  ;   71    2  221 word   readRL
  6355                                  ;   72    2  222 word   fputcR
  6356                                  ;   73    3  224 word   fcloseR
  6357                                  ;   74    5  225 word   exitR
  6358                                  ;   75    1  227 word   putch
  6359                                  ;   76    4  228 word   DosInt
  6360                                  ;   77 NULL  229 word   LastFunctionByt
  6361                                  
  6362                                  ;    #  addr name   list of CALLs
  6363                                  
  6364                                  ;    0  1355 getLine
  6365                                  ;    1  1363 getTokeType
  6366                                  ;    2  1375 storeLabel
  6367                                  ;    3  1386 getTokeType
  6368                                  ;    4  1398 lookCode
  6369                                  ;    5  1407 process
  6370                                  ;    6  1415 getVariable
  6371                                  ;    7  1427 skipRest
  6372                                  ;    8  1436 error1
  6373                                  ;    9  1443 error1
  6374                                  ;   10  1450 printLine
  6375                                  ;   11  1474 skipBlank
  6376                                  ;   12  1484 digit
  6377                                  ;   13  1490 getDigit
  6378                                  ;   14  1499 letterE
  6379                                  ;   15  1507 getName
  6380                                  ;   16  1528 searchLabel
  6381                                  ;   17  1540 error1
  6382                                  ;   18  1547 strcpy
  6383                                  ;   19  1554 errorexit
  6384                                  ;   20  1564 errorexit
  6385                                  ;   21  1594 eqstr
  6386                                  ;   22  1600 strlen
  6387                                  ;   23  1621 storeLabel
  6388                                  ;   24  1632 getTokeType
  6389                                  ;   25  1644 lookCode
  6390                                  ;   26  1653 errorexit
  6391                                  ;   27  1663 errorexit
  6392                                  ;   28  1673 getTokeType
  6393                                  ;   29  1685 genCode8
  6394                                  ;   30  1694 skipBlank
  6395                                  ;   31  1704 isToken
  6396                                  ;   32  1712 genCode8
  6397                                  ;   33  1721 isToken
  6398                                  ;   34  1729 getTokeType
  6399                                  ;   35  1741 genCode16
  6400                                  ;   36  1751 isToken
  6401                                  ;   37  1759 errorexit
  6402                                  ;   38  1778 eqstr
  6403                                  ;   39  1796 eqstr
  6404                                  ;   40  1802 getTokeType
  6405                                  ;   41  1814 eqstr
  6406                                  ;   42  1820 getTokeType
  6407                                  ;   43  1832 eqstr
  6408                                  ;   44  1838 getTokeType
  6409                                  ;   45  1860 skipBlank
  6410                                  ;   46  1877 isToken
  6411                                  ;   47  1885 getTokeType
  6412                                  ;   48  1897 error1
  6413                                  ;   49  1904 prs
  6414                                  ;   50  1908 prc
  6415                                  ;   51  1921 getTokeType
  6416                                  ;   52  1933 error1
  6417                                  ;   53  1950 readRL
  6418                                  ;   54  1957 errorexit
  6419                                  ;   55  1967 errorexit
  6420                                  ;   56  1977 ifEOL
  6421                                  ;   57  1991 readRL
  6422                                  ;   58  2027 digit
  6423                                  ;   59  2033 letterE
  6424                                  ;   60  2060 digit
  6425                                  ;   61  2080 alnumE
  6426                                  ;   62  2087 errorexit
  6427                                  ;   63  2097 strcpy
  6428                                  ;   64  2104 toupper
  6429                                  ;   65  2120 strlen
  6430                                  ;   66  2127 strlen
  6431                                  ;   67  2134 eqstr
  6432                                  ;   68  2140 eqstr
  6433                                  ;   69  2146 eqstr
  6434                                  ;   70  2152 eqstr
  6435                                  ;   71  2158 eqstr
  6436                                  ;   72  2164 eqstr
  6437                                  ;   73  2170 eqstr
  6438                                  ;   74  2176 eqstr
  6439                                  ;   75  2182 eqstr
  6440                                  ;   76  2188 eqstr
  6441                                  ;   77  2194 eqstr
  6442                                  ;   78  2200 eqstr
  6443                                  ;   79  2206 eqstr
  6444                                  ;   80  2212 eqstr
  6445                                  ;   81  2218 eqstr
  6446                                  ;   82  2224 eqstr
  6447                                  ;   83  2230 eqstr
  6448                                  ;   84  2236 eqstr
  6449                                  ;   85  2242 eqstr
  6450                                  ;   86  2248 eqstr
  6451                                  ;   87  2254 eqstr
  6452                                  ;   88  2260 eqstr
  6453                                  ;   89  2266 eqstr
  6454                                  ;   90  2272 eqstr
  6455                                  ;   91  2278 eqstr
  6456                                  ;   92  2284 eqstr
  6457                                  ;   93  2290 eqstr
  6458                                  ;   94  2296 eqstr
  6459                                  ;   95  2302 eqstr
  6460                                  ;   96  2308 eqstr
  6461                                  ;   97  2328 prs
  6462                                  ;   98  2332 printhex16
  6463                                  ;   99  2343 prs
  6464                                  ;  100  2347 prc
  6465                                  ;  101  2351 printhex8a
  6466                                  ;  102  2362 prc
  6467                                  ;  103  2366 prs
  6468                                  ;  104  2370 prscomment
  6469                                  ;  105  2387 writetty
  6470                                  ;  106  2396 writetty
  6471                                  ;  107  2405 fputcR
  6472                                  ;  108  2427 prc
  6473                                  ;  109  2443 prc
  6474                                  ;  110  2464 prc
  6475                                  ;  111  2468 prc
  6476                                  ;  112  2490 printhex8a
  6477                                  ;  113  2501 printhex8a
  6478                                  ;  114  2526 printIntU
  6479                                  ;  115  2536 prc
  6480                                  ;  116  2549 prs
  6481                                  ;  117  2553 prs
  6482                                  ;  118  2557 prs
  6483                                  ;  119  2561 prs
  6484                                  ;  120  2578 error1
  6485                                  ;  121  2595 error1
  6486                                  ;  122  2612 error1
  6487                                  ;  123  2629 error1
  6488                                  ;  124  2647 error1
  6489                                  ;  125  2667 error1
  6490                                  ;  126  2686 error1
  6491                                  ;  127  2705 error1
  6492                                  ;  128  2723 error1
  6493                                  ;  129  2742 error1
  6494                                  ;  130  2761 error1
  6495                                  ;  131  2780 error1
  6496                                  ;  132  2787 end1
  6497                                  ;  133  2801 errorexit
  6498                                  ;  134  2822 errorexit
  6499                                  ;  135  2837 getarg
  6500                                  ;  136  2844 parse
  6501                                  ;  137  2850 epilog
  6502                                  ;  138  2857 end1
  6503                                  ;  139  2881 cputs
  6504                                  ;  140  2887 cputs
  6505                                  ;  141  2893 exitR
  6506                                  ;  142  2899 toupper
  6507                                  ;  143  2907 strcpy
  6508                                  ;  144  2914 strcat1
  6509                                  ;  145  2922 strcpy
  6510                                  ;  146  2929 strcat1
  6511                                  ;  147  2937 strcpy
  6512                                  ;  148  2944 strcat1
  6513                                  ;  149  2952 openR
  6514                                  ;  150  2958 cputs
  6515                                  ;  151  2964 cputs
  6516                                  ;  152  2970 exitR
  6517                                  ;  153  2976 creatR
  6518                                  ;  154  2983 cputs
  6519                                  ;  155  2989 cputs
  6520                                  ;  156  2995 exitR
  6521                                  ;  157  3001 creatR
  6522                                  ;  158  3008 cputs
  6523                                  ;  159  3014 cputs
  6524                                  ;  160  3020 exitR
  6525                                  ;  161  3026 prs
  6526                                  ;  162  3030 prs
  6527                                  ;  163  3034 prs
  6528                                  ;  164  3038 prs
  6529                                  ;  165  3042 prs
  6530                                  ;  166  3046 prs
  6531                                  ;  167  3050 prs
  6532                                  ;  168  3054 prs
  6533                                  ;  169  3058 prs
  6534                                  ;  170  3075 prs
  6535                                  ;  171  3079 printIntU
  6536                                  ;  172  3089 prs
  6537                                  ;  173  3093 prs
  6538                                  ;  174  3097 printIntU
  6539                                  ;  175  3107 prs
  6540                                  ;  176  3111 fputcR
  6541                                  ;  177  3125 fcloseR
  6542                                  ;  178  3133 fcloseR
  6543                                  ;  179  3141 fcloseR
  6544                                  ;  180  3149 exitR
  6545                                  ;  181  3171 genCode8
  6546                                  ;  182  3192 genCode8
  6547                                  ;  183  3212 genCode8
  6548                                  ;  184  3232 errorexit
  6549                                  ;  185  3254 genCode8
  6550                                  ;  186  3263 genCode8
  6551                                  ;  187  3288 addrexit
  6552                                  ;  188  3297 error1
  6553                                  ;  189  3304 genCode8
  6554                                  ;  190  3313 genCode8
  6555                                  ;  191  3322 genCode16
  6556                                  ;  192  3345 genCode16
  6557                                  ;  193  3355 genCode8
  6558                                  ;  194  3374 getTokeType
  6559                                  ;  195  3386 getCodeSize
  6560                                  ;  196  3398 getCodes
  6561                                  ;  197  3407 genCode8
  6562                                  ;  198  3416 checkOp
  6563                                  ;  199  3424 genCode
  6564                                  ;  200  3432 genCode
  6565                                  ;  201  3440 getTokeType
  6566                                  ;  202  3452 implerror
  6567                                  ;  203  3462 genCodeW
  6568                                  ;  204  3471 writeEA
  6569                                  ;  205  3479 checkOp
  6570                                  ;  206  3487 reg16error
  6571                                  ;  207  3498 immeerror
  6572                                  ;  208  3508 need
  6573                                  ;  209  3513 getOp
  6574                                  ;  210  3519 addrerror
  6575                                  ;  211  3529 genCode8
  6576                                  ;  212  3538 genCode8
  6577                                  ;  213  3547 writeEA
  6578                                  ;  214  3555 checkOp
  6579                                  ;  215  3563 immeerror
  6580                                  ;  216  3573 need
  6581                                  ;  217  3578 getOp
  6582                                  ;  218  3584 genCodeW
  6583                                  ;  219  3593 genImmediate
  6584                                  ;  220  3606 getSignExtended
  6585                                  ;  221  3622 genCodeW
  6586                                  ;  222  3631 writeEA
  6587                                  ;  223  3639 genCode8
  6588                                  ;  224  3648 genCode16
  6589                                  ;  225  3658 genCode8
  6590                                  ;  226  3667 error1
  6591                                  ;  227  3674 error1
  6592                                  ;  228  3689 getOp
  6593                                  ;  229  3695 implerror
  6594                                  ;  230  3705 segregerror
  6595                                  ;  231  3717 setwflag
  6596                                  ;  232  3726 error1
  6597                                  ;  233  3733 error1
  6598                                  ;  234  3740 error1
  6599                                  ;  235  3753 getOp1
  6600                                  ;  236  3760 isToken
  6601                                  ;  237  3768 getMEM
  6602                                  ;  238  3775 invaloperror
  6603                                  ;  239  3788 error1
  6604                                  ;  240  3802 testReg
  6605                                  ;  241  3810 searchLabel
  6606                                  ;  242  3822 error1
  6607                                  ;  243  3840 getTokeType
  6608                                  ;  244  3852 getOp1
  6609                                  ;  245  3859 syntaxerror
  6610                                  ;  246  3871 getIndReg2
  6611                                  ;  247  3882 getIndReg1
  6612                                  ;  248  3893 isToken
  6613                                  ;  249  3901 getTokeType
  6614                                  ;  250  3913 numbererror
  6615                                  ;  251  3925 isToken
  6616                                  ;  252  3933 isToken
  6617                                  ;  253  3941 errorexit
  6618                                  ;  254  3962 indexerror
  6619                                  ;  255  3973 indexerror
  6620                                  ;  256  3997 indexerror
  6621                                  ;  257  4008 indexerror
  6622                                  ;  258  4028 gen66h
  6623                                  ;  259  4072 putch
  6624                                  ;  260  4140 strcpy
  6625                                  ;  261  4155 DosInt
  6626                                  ;  262  4171 DosInt
  6627                                  ;  263  4194 DosInt
  6628                                  ;  264  4213 DosInt
  6629                                  ;  265  4247 writetty
  6630                                  ;  266  4256 writetty
  6631                                  ;Input: AS.C, List: AS.S,  Lines:  230
  6632                                  ;Glob. variables:  193 max.:  200
  6633                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6634                                  ;Functions      :   78 max.:  300
  6635                                  ;Calls          :  267 max.: 2000, NameField: 4288 max.:    65535
  6636                                  ;Code until     :25998 max.: 30000, free: 4002
  6637                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6638                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
