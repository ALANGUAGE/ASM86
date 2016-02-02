     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E94F23                  jmp main
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
   186                                  ;-47 char wflag;             //0=byte, 1=word/dword
   187                                  
   188 000001C1 00                      wflag db 0
   189                                  
   190                                  ;-48 //char AddrSize;          //67h:
   191                                  
   192                                  
   193                                  ;-49 //char NumOprns;          //0-2
   194                                  
   195                                  
   196                                  ;-50 //char dflag;             //0=source is reg,  1=dest is reg
   197                                  
   198                                  
   199                                  ;-51 //char modrm;           //mod, r/m
   200                                  
   201                                  
   202                                  ;-52 char regindexbase;      //combination of index and base reg
   203                                  
   204 000001C2 00                      regindexbase db 0
   205                                  
   206                                  ;-53 char isDirect;          //set in getOp and getMeM, need in WriteEA
   207                                  
   208 000001C3 00                      isDirect db 0
   209                                  
   210                                  ;-54 int disp;               //displacement      0-8 bytes
   211                                  
   212 000001C4 0000                    disp dw 0
   213                                  
   214                                  ;-55 int imme;               //immediate         0-8 bytes
   215                                  
   216 000001C6 0000                    imme dw 0
   217                                  
   218                                  ;-56 
   219                                  
   220                                  
   221                                  ;-57 #define OPMAXLEN 5
   222                                  
   223                                  
   224                                  ;-58 char OpPos[OPMAXLEN];   //array for one opcode to list
   225                                  
   226 000001C8 <res 00000005>          OpPos resb 5
   227                                  
   228                                  ;-59 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   229                                  
   230 000001CD 0000                    OpPrintIndex dw 0
   231                                  
   232                                  ;-60 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   233                                  
   234 000001CF 0000                    OpCodePtr dw 0
   235                                  
   236                                  ;-61 char PrintR;           //print 'R' if relocative
   237                                  
   238 000001D1 00                      PrintR db 0
   239                                  
   240                                  ;-62 
   241                                  
   242                                  
   243                                  ;-63 #define LABELNAMESMAX 969//next number - 31
   244                                  
   245                                  
   246                                  ;-64 char LabelNames[1000];  //space for names of all labels
   247                                  
   248 000001D2 <res 000003E8>          LabelNames resb 1000
   249                                  
   250                                  ;-65 char *LabelNamePtr;     // first free position
   251                                  
   252 000005BA 0000                    LabelNamePtr dw 0
   253                                  
   254                                  ;-66 #define LABELADRMAX 100
   255                                  
   256                                  
   257                                  ;-67 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   258                                  
   259 000005BC <res 000000C8>          LabelAddr resw 100
   260                                  
   261                                  ;-68 int LabelMaxIx=0;       //actual number of stored labels
   262                                  
   263 00000684 0000                    LabelMaxIx dw 0
   264                                  
   265                                  ;-69 int LabelIx;            //actual number of just searched label
   266                                  
   267 00000686 0000                    LabelIx dw 0
   268                                  
   269                                  ;-70 
   270                                  
   271                                  
   272                                  ;-71 #define FILEBINMAX 2000 //next number - max. oplength
   273                                  
   274                                  
   275                                  ;-72 char FileBin  [FILEBINMAX];//output binary file
   276                                  
   277 00000688 <res 000007D0>          FileBin resb 2000
   278                                  
   279                                  ;-73 unsigned int BinLen=0;  //length of binary file
   280                                  
   281 00000E58 0000                    BinLen dw 0
   282                                  
   283                                  ;-74 
   284                                  
   285                                  
   286                                  ;-75 char *arglen=0x80;      // for main only
   287                                  
   288 00000E5A 8000                    arglen dw 128
   289                                  
   290                                  ;-76 char *argv=0x82;        // for main only
   291                                  
   292 00000E5C 8200                    argv dw 130
   293                                  ;Back to main program: AS.C
   294                                  
   295                                  ;-3 #include "OPTABL.C"
   296                                  
   297                                  ;Use include file: OPTABL.C
   298                                  
   299                                  ;-1 char I_START=0xF1;
   300                                  
   301 00000E5E F1                      I_START db 241
   302                                  
   303                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   304                                  
   305                                  
   306                                  ;-3 //  1:   1 byte opcode
   307                                  
   308                                  
   309                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   310                                  
   311 00000E5F 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   312                                  
   313                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   314                                  
   315 00000E68 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   316                                  
   317                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   318                                  
   319 00000E70 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   320                                  
   321                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   322                                  
   323 00000E77 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   324                                  
   325                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   326                                  
   327 00000E7E 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   328                                  
   329                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   330                                  
   331 00000E86 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   332                                  
   333                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   334                                  
   335 00000E8D 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   336                                  
   337                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   338                                  
   339 00000E94 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   340                                  
   341                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   342                                  
   343 00000E9C 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   344                                  
   345                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   346                                  
   347 00000EA5 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   348                                  
   349                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   350                                  
   351 00000EAD 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   352                                  
   353                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   354                                  
   355 00000EB5 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   356                                  
   357                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   358                                  
   359 00000EBD 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   360                                  
   361                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   362                                  
   363 00000EC6 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   364                                  
   365                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   366                                  
   367 00000ECF 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   368                                  
   369                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   370                                  
   371 00000ED8 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   372                                  
   373                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   374                                  
   375 00000EE1 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   376                                  
   377                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   378                                  
   379 00000EEA 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   380                                  
   381                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   382                                  
   383 00000EF3 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   384                                  
   385                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   386                                  
   387 00000EFC 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   388                                  
   389                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   390                                  
   391 00000F05 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   392                                  
   393                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   394                                  
   395 00000F0E 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   396                                  
   397                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   398                                  
   399 00000F17 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   400                                  
   401                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   402                                  
   403 00000F20 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   404                                  
   405                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   406                                  
   407 00000F28 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   408                                  
   409                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   410                                  
   411 00000F30 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   412                                  
   413                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   414                                  
   415 00000F38 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   416                                  
   417                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   418                                  
   419 00000F41 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   420                                  
   421                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   422                                  
   423 00000F4A 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   424                                  
   425                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   426                                  
   427 00000F52 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   428                                  
   429                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   430                                  
   431 00000F5A 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   432                                  
   433                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   434                                  
   435 00000F61 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   436                                  
   437                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   438                                  
   439 00000F68 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   440                                  
   441                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   442                                  
   443 00000F6F 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   444                                  
   445                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   446                                  
   447 00000F76 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   448                                  
   449                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   450                                  
   451 00000F7D 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   452                                  
   453                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   454                                  
   455 00000F84 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   456                                  
   457                                  ;-41 // 2: mem reg 16 bit
   458                                  
   459                                  
   460                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   461                                  
   462 00000F8B 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   463                                  
   464                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   465                                  
   466 00000F94 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   467                                  
   468                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   469                                  
   470 00000F9D 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   471                                  
   472                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   473                                  
   474 00000FA5 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   475                                  
   476                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   477                                  
   478 00000FAD 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   479                                  
   480                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   481                                  
   482 00000FB5 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   483                                  
   484                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   485                                  
   486 00000FBE 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   487                                  
   488                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   489                                  
   490 00000FC6 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   491                                  
   492                                  ;-50 //  3: les, lda, lea, lss, lfs, lgs
   493                                  
   494                                  
   495                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   496                                  
   497 00000FCF 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   498                                  
   499                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   500                                  
   501 00000FD6 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   502                                  
   503                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   504                                  
   505 00000FDD 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   506                                  
   507                                  ;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   508                                  
   509 00000FE4 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   510                                  
   511                                  ;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   512                                  
   513 00000FEC 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   514                                  
   515                                  ;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   516                                  
   517 00000FF4 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   518                                  
   519                                  ;-57 //  4: acc,imm  reg,imm  index,reg
   520                                  
   521                                  
   522                                  ;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   523                                  
   524 00000FFC 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   525                                  
   526                                  ;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   527                                  
   528 00001003 4F52000401F1            I_OR db 79,82,0,4,1,241
   529                                  
   530                                  ;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   531                                  
   532 00001009 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   533                                  
   534                                  ;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   535                                  
   536 00001010 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   537                                  
   538                                  ;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   539                                  
   540 00001017 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   541                                  
   542                                  ;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   543                                  
   544 0000101E 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   545                                  
   546                                  ;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   547                                  
   548 00001025 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   549                                  
   550                                  ;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   551                                  
   552 0000102C 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   553                                  
   554                                  ;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   555                                  
   556 00001033 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   557 0000103C 00F1               
   558                                  
   559                                  ;-67 //  5: mov
   560                                  
   561                                  
   562                                  ;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   563                                  
   564 0000103E 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   565                                  
   566                                  ;-69 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   567                                  
   568 00001044 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   569                                  
   570                                  ;-70 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   571                                  
   572 0000104D 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   573                                  
   574                                  ;-71 //  6: single byte relative jump
   575                                  
   576                                  
   577                                  ;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   578                                  
   579 00001056 4A4F000600F1            I_JO db 74,79,0,6,0,241
   580                                  
   581                                  ;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   582                                  
   583 0000105C 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   584                                  
   585                                  ;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   586                                  
   587 00001063 4A42000602F1            I_JB db 74,66,0,6,2,241
   588                                  
   589                                  ;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   590                                  
   591 00001069 4A43000602F1            I_JC db 74,67,0,6,2,241
   592                                  
   593                                  ;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   594                                  
   595 0000106F 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   596                                  
   597                                  ;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   598                                  
   599 00001076 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   600                                  
   601                                  ;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   602                                  
   603 0000107D 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   604                                  
   605                                  ;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   606                                  
   607 00001084 4A45000604F1            I_JE db 74,69,0,6,4,241
   608                                  
   609                                  ;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   610                                  
   611 0000108A 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   612                                  
   613                                  ;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   614                                  
   615 00001090 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   616                                  
   617                                  ;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   618                                  
   619 00001097 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   620                                  
   621                                  ;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   622                                  
   623 0000109E 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   624                                  
   625                                  ;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   626                                  
   627 000010A5 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   628                                  
   629                                  ;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   630                                  
   631 000010AC 4A41000607F1            I_JA db 74,65,0,6,7,241
   632                                  
   633                                  ;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   634                                  
   635 000010B2 4A53000608F1            I_JS db 74,83,0,6,8,241
   636                                  
   637                                  ;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   638                                  
   639 000010B8 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   640                                  
   641                                  ;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   642                                  
   643 000010BF 4A5000060AF1            I_JP db 74,80,0,6,10,241
   644                                  
   645                                  ;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   646                                  
   647 000010C5 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   648                                  
   649                                  ;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   650                                  
   651 000010CC 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   652                                  
   653                                  ;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   654                                  
   655 000010D3 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   656                                  
   657                                  ;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   658                                  
   659 000010DA 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   660                                  
   661                                  ;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   662                                  
   663 000010E0 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   664                                  
   665                                  ;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   666                                  
   667 000010E7 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   668                                  
   669                                  ;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   670                                  
   671 000010EE 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   672                                  
   673                                  ;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   674                                  
   675 000010F5 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   676                                  
   677                                  ;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   678                                  
   679 000010FC 4A4700060FF1            I_JG db 74,71,0,6,15,241
   680                                  
   681                                  ;-98 //  7: jmp, call
   682                                  
   683                                  
   684                                  ;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   685                                  
   686 00001102 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   687                                  
   688                                  ;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   689                                  
   690 0000110A 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   691                                  
   692                                  ;-101 //  8: ret
   693                                  
   694                                  
   695                                  ;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   696                                  
   697 00001113 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   698                                  
   699                                  ;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   700                                  
   701 0000111B 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   702                                  
   703                                  ;-104 //  9: seg, r/m
   704                                  
   705                                  
   706                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   707                                  
   708 00001124 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   709                                  
   710                                  ;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   711                                  
   712 0000112C 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   713                                  
   714                                  ;-107 //  11: shift, rotates
   715                                  
   716                                  
   717                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   718                                  
   719 00001133 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   720                                  
   721                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   722                                  
   723 0000113A 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   724                                  
   725                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   726                                  
   727 00001141 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   728                                  
   729                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   730                                  
   731 00001148 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   732                                  
   733                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   734                                  
   735 0000114F 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   736                                  
   737                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   738                                  
   739 00001156 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   740                                  
   741                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   742                                  
   743 0000115D 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   744                                  
   745                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   746                                  
   747 00001164 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   748                                  
   749                                  ;-116 //  12: int
   750                                  
   751                                  
   752                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   753                                  
   754 0000116B 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   755                                  
   756                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   757                                  
   758 00001173 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   759                                  
   760                                  ;-119 //  14: in/out
   761                                  
   762                                  
   763                                  ;-120 char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   764                                  
   765 0000117B 494E000EE4ECF1          I_IN db 73,78,0,14,228,236,241
   766                                  
   767                                  ;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   768                                  
   769 00001182 494E5342000E6CF1        I_INSB db 73,78,83,66,0,14,108,241
   770                                  
   771                                  ;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   772                                  
   773 0000118A 494E5357000E6DF1        I_INSW db 73,78,83,87,0,14,109,241
   774                                  
   775                                  ;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   776                                  
   777 00001192 494E5344000E6DF1        I_INSD db 73,78,83,68,0,14,109,241
   778                                  
   779                                  ;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   780                                  
   781 0000119A 4F5554000EE6EEF1        I_OUT db 79,85,84,0,14,230,238,241
   782                                  
   783                                  ;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   784                                  
   785 000011A2 4F555442000E6EF1        I_OUTSB db 79,85,84,66,0,14,110,241
   786                                  
   787                                  ;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   788                                  
   789 000011AA 4F555457000E6FF1        I_OUTSW db 79,85,84,87,0,14,111,241
   790                                  
   791                                  ;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};
   792                                  
   793 000011B2 4F555444000E6FF1        I_OUTSD db 79,85,84,68,0,14,111,241
   794                                  
   795                                  ;-128 //  15: xchg
   796                                  
   797                                  
   798                                  ;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   799                                  
   800 000011BA 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   801                                  
   802                                  ;-130 //  16: loop, jcxz
   803                                  
   804                                  
   805                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   806                                  
   807 000011C3 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   808 000011CC F1                 
   809                                  
   810                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   811                                  
   812 000011CD 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   813 000011D6 F1                 
   814                                  
   815                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   816                                  
   817 000011D7 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   818                                  
   819                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   820                                  
   821 000011E0 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   822                                  
   823                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   824                                  
   825 000011E9 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   826                                  
   827                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   828                                  
   829 000011F1 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   830                                  
   831                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   832                                  
   833 000011F9 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   834                                  
   835                                  ;-138 //  30: enter
   836                                  
   837                                  
   838                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   839                                  
   840 00001202 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   841                                  
   842                                  ;-140 // 100: directives
   843                                  
   844                                  
   845                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   846                                  
   847 0000120B 4F52470065F1            I_ORG db 79,82,71,0,101,241
   848                                  
   849                                  ;-142 // section, segment .TEXT .DATA .BSS
   850                                  
   851                                  
   852                                  ;-143 //char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   853                                  
   854                                  
   855                                  ;-144 //char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   856                                  
   857                                  
   858                                  ;-145 //char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};
   859                                  
   860                                  
   861                                  ;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};
   862                                  
   863 00001211 444200C8F1              I_DB db 68,66,0,200,241
   864                                  
   865                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   866                                  
   867 00001216 445700C9F1              I_DW db 68,87,0,201,241
   868                                  
   869                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   870                                  
   871 0000121B 444400CAF1              I_DD db 68,68,0,202,241
   872                                  
   873                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   874                                  
   875 00001220 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   876                                  
   877                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   878                                  
   879 00001227 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   880                                  
   881                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   882                                  
   883 0000122E 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   884                                  
   885                                  ;-152 char I_END=0;// end of table char
   886                                  
   887 00001235 00                      I_END db 0
   888                                  ;Back to main program: AS.C
   889                                  
   890                                  ;-4 
   891                                  
   892                                  
   893                                  ;-5 #include "PARSE.C"
   894                                  
   895                                  ;Use include file: PARSE.C
   896                                  
   897                                  ;-1 int parse() {
   898                                  
   899                                  
   900                                  parse:  ; *** PROC ***
   901                                  
   902                                  ;-2   LabelNamePtr= &LabelNames;
   903                                  
   904 00001236 B8[D201]                 mov ax, LabelNames
   905 00001239 A3[BA05]                 mov word [LabelNamePtr], ax
   906                                  
   907                                  ;-3   do {
   908                                  
   909                                  @@parse1:
   910                                  
   911                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
   912                                  
   913 0000123C A1[B001]                 mov ax, [PC]
   914 0000123F A3[B201]                 mov word [PCStart], ax
   915 00001242 66B800000000             mov eax, 0
   916 00001248 A2[C001]                 mov byte [OpSize], al
   917 0000124B 66B800000000             mov eax, 0
   918 00001251 A3[CD01]                 mov word [OpPrintIndex], ax
   919 00001254 66B820000000             mov eax, 32
   920 0000125A A2[D101]                 mov byte [PrintR], al
   921                                  
   922                                  ;-5     getLine();
   923                                  
   924 0000125D E82905                   call getLine
   925                                  
   926                                  ;-6     InputPtr = &InputBuf;
   927                                  
   928 00001260 B8[5900]                 mov ax, InputBuf
   929 00001263 A3[D800]                 mov word [InputPtr], ax
   930                                  
   931                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
   932                                  
   933 00001266 E8B700                   call getTokeType
   934                                  
   935                                  ;-8     if (TokeType == ALNUME) {
   936                                  
   937 00001269 A0[B501]                 mov al, [TokeType]
   938 0000126C 3C03                     cmp al, 3
   939 0000126E 0F851300                 jne @@parse2
   940                                  
   941                                  ;-9       if (isLabel) { //set in getName
   942                                  
   943 00001272 A0[B401]                 mov al, [isLabel]
   944 00001275 08C0                     or  al, al
   945 00001277 0F840A00                 je @@parse3
   946                                  
   947                                  ;-10         storeLabel();
   948                                  
   949 0000127B E84001                   call storeLabel
   950                                  
   951                                  ;-11         InputPtr++;//remove :
   952                                  
   953 0000127E FF06[D800]               inc  word [InputPtr]
   954                                  
   955                                  ;-12         getTokeType();
   956                                  
   957 00001282 E89B00                   call getTokeType
   958                                  
   959                                  ;-13       }
   960                                  
   961                                  
   962                                  ;-14     }
   963                                  
   964                                  @@parse3:
   965                                  
   966                                  ;-15     if (TokeType == ALNUME) {
   967                                  
   968                                  @@parse2:
   969 00001285 A0[B501]                 mov al, [TokeType]
   970 00001288 3C03                     cmp al, 3
   971 0000128A 0F851B00                 jne @@parse4
   972                                  
   973                                  ;-16       lookCode();// and OpCodePtr
   974                                  
   975 0000128E E86803                   call lookCode
   976                                  
   977                                  ;-17       if(CodeType) process();
   978                                  
   979 00001291 A0[B801]                 mov al, [CodeType]
   980 00001294 08C0                     or  al, al
   981 00001296 0F840600                 je @@parse5
   982 0000129A E8CB15                   call process
   983                                  
   984                                  ;-18       else getVariable();
   985                                  
   986 0000129D E90300                   jmp @@parse6
   987                                  @@parse5:
   988 000012A0 E81E02                   call getVariable
   989                                  
   990                                  ;-19       skipRest();
   991                                  
   992                                  @@parse6:
   993 000012A3 E8BA04                   call skipRest
   994                                  
   995                                  ;-20     }
   996                                  
   997                                  
   998                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
   999                                  
  1000 000012A6 E92700                   jmp @@parse7
  1001                                  @@parse4:
  1002 000012A9 A0[B501]                 mov al, [TokeType]
  1003 000012AC 3C03                     cmp al, 3
  1004 000012AE 0F8E0C00                 jle @@parse8
  1005 000012B2 68[E112]                 push parse_0
  1006 000012B5 E88F0E                   call error1
  1007 000012B8 83C402                   add  sp, 2
  1008                                  
  1009                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
  1010                                  
  1011 000012BB E91200                   jmp @@parse9
  1012                                  @@parse8:
  1013 000012BE A0[B501]                 mov al, [TokeType]
  1014 000012C1 3C01                     cmp al, 1
  1015 000012C3 0F850900                 jne @@parse10
  1016 000012C7 68[FF12]                 push parse_1
  1017 000012CA E87A0E                   call error1
  1018 000012CD 83C402                   add  sp, 2
  1019                                  
  1020                                  ;-23     printLine();
  1021                                  
  1022                                  @@parse10:
  1023                                  @@parse9:
  1024                                  @@parse7:
  1025 000012D0 E8090C                   call printLine
  1026                                  
  1027                                  ;-24   } while (DOS_NoBytes != 0 );
  1028                                  
  1029 000012D3 A1[AD01]                 mov ax, [DOS_NoBytes]
  1030 000012D6 83F800                   cmp ax, 0
  1031 000012D9 0F840300                 je  @@parse11
  1032 000012DD E95CFF                   jmp @@parse1
  1033                                  @@parse11:
  1034                                  
  1035                                  ;-25 }
  1036                                  
  1037                                  
  1038                                  ;-26 // scan code .....................................
  1039                                  
  1040                                  
  1041                                  ;-27 int getTokeType() { char c;
  1042                                  
  1043 000012E0 C3                       ret
  1044                                  ; ENDP
  1045 000012E1 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1046 000012EA 696E73747275637469-
  1047 000012F3 6F6E20657870656374-
  1048 000012FC 656400             
  1049 000012FF 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1050 00001308 616C6C6F7765642040-
  1051 00001311 207374617274206F66-
  1052 0000131A 206C696E6500       
  1053                                  
  1054                                  getTokeType:  ; *** PROC ***
  1055                                  
  1056                                  ;-28   skipBlank();
  1057                                  
  1058                                  ;Function : getTokeType, Number of local variables: 1
  1059                                  ;   # type sign width line used address name   list of local variables
  1060                                  ;  200 var sign byte    27 NULL bp-2    c;
  1061 00001320 C8020000                 ENTER  2,0
  1062 00001324 E86405                   call skipBlank
  1063                                  
  1064                                  ;-29   c = *InputPtr;
  1065                                  
  1066 00001327 8B1E[D800]               mov bx, [InputPtr]
  1067 0000132B 8A07                     mov al, [bx]
  1068 0000132D B400                     mov ah, 0
  1069 0000132F 8846FE                   mov byte [bp-2], al
  1070                                  
  1071                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1072                                  
  1073 00001332 8A46FE                   mov al, [bp-2]
  1074 00001335 3C00                     cmp al, 0
  1075 00001337 0F850C00                 jne @@getTokeType12
  1076 0000133B 66B800000000             mov eax, 0
  1077 00001341 A2[B501]                 mov byte [TokeType], al
  1078 00001344 E97500                   jmp @@retn
  1079                                  
  1080                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1081                                  
  1082                                  @@getTokeType12:
  1083 00001347 8A46FE                   mov al, [bp-2]
  1084 0000134A 3C3B                     cmp al, 59
  1085 0000134C 0F850C00                 jne @@getTokeType13
  1086 00001350 66B800000000             mov eax, 0
  1087 00001356 A2[B501]                 mov byte [TokeType], al
  1088 00001359 E96000                   jmp @@retn
  1089                                  
  1090                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1091                                  
  1092                                  @@getTokeType13:
  1093 0000135C 8A46FE                   mov al, byte [bp-2]
  1094 0000135F B400                     mov ah, 0
  1095 00001361 50                       push ax
  1096 00001362 E8FD1B                   call digit
  1097 00001365 83C402                   add  sp, 2
  1098 00001368 08C0                     or  al, al
  1099 0000136A 0F841800                 je @@getTokeType14
  1100 0000136E 8A46FE                   mov al, byte [bp-2]
  1101 00001371 B400                     mov ah, 0
  1102 00001373 50                       push ax
  1103 00001374 E81A06                   call getDigit
  1104 00001377 83C402                   add  sp, 2
  1105 0000137A 66B801000000             mov eax, 1
  1106 00001380 A2[B501]                 mov byte [TokeType], al
  1107 00001383 E93600                   jmp @@retn
  1108                                  
  1109                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1110                                  
  1111                                  @@getTokeType14:
  1112 00001386 8A46FE                   mov al, byte [bp-2]
  1113 00001389 B400                     mov ah, 0
  1114 0000138B 50                       push ax
  1115 0000138C E82705                   call letterE
  1116 0000138F 83C402                   add  sp, 2
  1117 00001392 08C0                     or  al, al
  1118 00001394 0F841800                 je @@getTokeType15
  1119 00001398 8A46FE                   mov al, byte [bp-2]
  1120 0000139B B400                     mov ah, 0
  1121 0000139D 50                       push ax
  1122 0000139E E84706                   call getName
  1123 000013A1 83C402                   add  sp, 2
  1124 000013A4 66B803000000             mov eax, 3
  1125 000013AA A2[B501]                 mov byte [TokeType], al
  1126 000013AD E90C00                   jmp @@retn
  1127                                  
  1128                                  ;-34   TokeType=NOALNUME; return;
  1129                                  
  1130                                  @@getTokeType15:
  1131 000013B0 66B804000000             mov eax, 4
  1132 000013B6 A2[B501]                 mov byte [TokeType], al
  1133 000013B9 E90000                   jmp @@retn
  1134                                  
  1135                                  ;-35 }
  1136                                  
  1137                                  
  1138                                  ;-36 int storeLabel() {unsigned int i;
  1139                                  
  1140 000013BC C9                      @@retn: LEAVE
  1141 000013BD C3                       ret
  1142                                  ; ENDP
  1143                                  
  1144                                  storeLabel:  ; *** PROC ***
  1145                                  
  1146                                  ;-37   if(searchLabel()) error1("duplicate label");
  1147                                  
  1148                                  ;Function : storeLabel, Number of local variables: 1
  1149                                  ;   # type sign width line used address name   list of local variables
  1150                                  ;  200 var unsg word    36 NULL bp-2    i;
  1151 000013BE C8020000                 ENTER  2,0
  1152 000013C2 E89C00                   call searchLabel
  1153 000013C5 08C0                     or  al, al
  1154 000013C7 0F840900                 je @@storeLabel16
  1155 000013CB 68[2C14]                 push storeLabel_0
  1156 000013CE E8760D                   call error1
  1157 000013D1 83C402                   add  sp, 2
  1158                                  
  1159                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1160                                  
  1161                                  @@storeLabel16:
  1162 000013D4 8D06[1900]               lea  ax, [Symbol]
  1163 000013D8 50                       push ax
  1164 000013D9 FF36[BA05]               push word [LabelNamePtr]
  1165 000013DD E8491B                   call strcpy
  1166 000013E0 83C404                   add  sp, 4
  1167 000013E3 A3[BA05]                 mov word [LabelNamePtr], ax
  1168                                  
  1169                                  ;-39   LabelNamePtr++;
  1170                                  
  1171 000013E6 FF06[BA05]               inc  word [LabelNamePtr]
  1172                                  
  1173                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  1174                                  
  1175 000013EA A1[BA05]                 mov ax, [LabelNamePtr]
  1176 000013ED 2D[D201]                 sub ax, LabelNames
  1177 000013F0 8946FE                   mov word [bp-2], ax
  1178                                  
  1179                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  1180                                  
  1181 000013F3 8B46FE                   mov ax, [bp-2]
  1182 000013F6 3DC903                   cmp ax, 969 ;unsigned : 0
  1183 000013F9 0F820900                 jb  @@storeLabel17
  1184 000013FD 68[3C14]                 push storeLabel_1
  1185 00001400 E8FE0E                   call errorexit
  1186 00001403 83C402                   add  sp, 2
  1187                                  
  1188                                  ;-42   LabelMaxIx++;
  1189                                  
  1190                                  @@storeLabel17:
  1191 00001406 FF06[8406]               inc  word [LabelMaxIx]
  1192                                  
  1193                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  1194                                  
  1195 0000140A A1[8406]                 mov ax, [LabelMaxIx]
  1196 0000140D 83F864                   cmp ax, 100 ;unsigned : 1
  1197 00001410 0F8C0900                 jl  @@storeLabel18
  1198 00001414 68[5114]                 push storeLabel_2
  1199 00001417 E8E70E                   call errorexit
  1200 0000141A 83C402                   add  sp, 2
  1201                                  
  1202                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  1203                                  
  1204                                  @@storeLabel18:
  1205 0000141D A1[B001]                 mov ax, [PC]
  1206 00001420 8B1E[8406]               mov bx, [LabelMaxIx]
  1207 00001424 D1E3                     shl bx, 1
  1208 00001426 8987[BC05]               mov [LabelAddr+bx], ax
  1209                                  
  1210                                  ;-45 }
  1211                                  
  1212                                  
  1213                                  ;-46 int searchLabel() {
  1214 0000142A C9                       LEAVE
  1215 0000142B C3                       ret
  1216                                  ; ENDP
  1217 0000142C 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  1218 00001435 206C6162656C00     
  1219 0000143C 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  1220 00001445 6C6162656C206E616D-
  1221 0000144E 657300             
  1222 00001451 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  1223 0000145A 6C6162656C7300     
  1224                                  
  1225                                  searchLabel:  ; *** PROC ***
  1226                                  
  1227                                  ;-47   int LIx; char *p; int j;
  1228                                  
  1229                                  
  1230                                  ;-48   p = &LabelNames;
  1231                                  
  1232                                  ;Function : searchLabel, Number of local variables: 3
  1233                                  ;   # type sign width line used address name   list of local variables
  1234                                  ;  200 var sign word    47 NULL bp-2    LIx
  1235                                  ;  201 ptr sign byte    47 NULL bp-4    p
  1236                                  ;  202 var sign word    47 NULL bp-6    j;
  1237 00001461 C8060000                 ENTER  6,0
  1238 00001465 B8[D201]                 mov ax, LabelNames
  1239 00001468 8946FC                   mov word [bp-4], ax
  1240                                  
  1241                                  ;-49   LIx=1;
  1242                                  
  1243 0000146B 66B801000000             mov eax, 1
  1244 00001471 8946FE                   mov word [bp-2], ax
  1245                                  
  1246                                  ;-50   while (LIx <= LabelMaxIx) {
  1247                                  
  1248                                  @@searchLabel19:
  1249 00001474 8B46FE                   mov ax, [bp-2]
  1250 00001477 3B06[8406]               cmp ax, [LabelMaxIx]
  1251 0000147B 0F8F3700                 jg  @@searchLabel20
  1252                                  
  1253                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  1254                                  
  1255 0000147F 8D06[1900]               lea  ax, [Symbol]
  1256 00001483 50                       push ax
  1257 00001484 FF76FC                   push word [bp-4]
  1258 00001487 E80B1B                   call eqstr
  1259 0000148A 83C404                   add  sp, 4
  1260 0000148D 08C0                     or  al, al
  1261 0000148F 0F840600                 je @@searchLabel21
  1262 00001493 8B46FE                   mov ax, [bp-2]
  1263 00001496 E92600                   jmp @@retn
  1264                                  
  1265                                  ;-52     j=strlen(p);
  1266                                  
  1267                                  @@searchLabel21:
  1268 00001499 FF76FC                   push word [bp-4]
  1269 0000149C E85F1A                   call strlen
  1270 0000149F 83C402                   add  sp, 2
  1271 000014A2 8946FA                   mov word [bp-6], ax
  1272                                  
  1273                                  ;-53     p=p+j; p++; LIx++;
  1274                                  
  1275 000014A5 8B46FC                   mov ax, [bp-4]
  1276 000014A8 0346FA                   add ax, [bp-6]
  1277 000014AB 8946FC                   mov word [bp-4], ax
  1278 000014AE FF46FC                   inc  word [bp-4]
  1279 000014B1 FF46FE                   inc  word [bp-2]
  1280                                  
  1281                                  ;-54   }
  1282                                  
  1283                                  
  1284                                  ;-55   return 0;
  1285                                  
  1286 000014B4 EBBE                     jmp @@searchLabel19
  1287                                  @@searchLabel20:
  1288 000014B6 66B800000000             mov eax, 0
  1289 000014BC E90000                   jmp @@retn
  1290                                  
  1291                                  ;-56 }
  1292                                  
  1293                                  
  1294                                  ;-57 int getVariable() { char c;
  1295                                  
  1296 000014BF C9                      @@retn: LEAVE
  1297 000014C0 C3                       ret
  1298                                  ; ENDP
  1299                                  
  1300                                  getVariable:  ; *** PROC ***
  1301                                  
  1302                                  ;-58   storeLabel();
  1303                                  
  1304                                  ;Function : getVariable, Number of local variables: 1
  1305                                  ;   # type sign width line used address name   list of local variables
  1306                                  ;  200 var sign byte    57 NULL bp-2    c;
  1307 000014C1 C8020000                 ENTER  2,0
  1308 000014C5 E8F6FE                   call storeLabel
  1309                                  
  1310                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  1311                                  
  1312 000014C8 E855FE                   call getTokeType
  1313 000014CB A0[B501]                 mov al, [TokeType]
  1314 000014CE 3C03                     cmp al, 3
  1315 000014D0 0F85CC00                 jne @@getVariable22
  1316                                  
  1317                                  ;-60     lookCode();
  1318                                  
  1319 000014D4 E82201                   call lookCode
  1320                                  
  1321                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  1322                                  
  1323 000014D7 A0[B801]                 mov al, [CodeType]
  1324 000014DA 3CC8                     cmp al, 200
  1325 000014DC 0F8D0900                 jge @@getVariable23
  1326 000014E0 68[AB15]                 push getVariable_0
  1327 000014E3 E81B0E                   call errorexit
  1328 000014E6 83C402                   add  sp, 2
  1329                                  
  1330                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1331                                  
  1332                                  @@getVariable23:
  1333 000014E9 A0[B801]                 mov al, [CodeType]
  1334 000014EC 3CCF                     cmp al, 207
  1335 000014EE 0F8E0900                 jle @@getVariable24
  1336 000014F2 68[C315]                 push getVariable_1
  1337 000014F5 E8090E                   call errorexit
  1338 000014F8 83C402                   add  sp, 2
  1339                                  
  1340                                  ;-63     if (CodeType== 200) {// DB
  1341                                  
  1342                                  @@getVariable24:
  1343 000014FB A0[B801]                 mov al, [CodeType]
  1344 000014FE 3CC8                     cmp al, 200
  1345 00001500 0F856A00                 jne @@getVariable25
  1346                                  
  1347                                  ;-64       do { getTokeType();
  1348                                  
  1349                                  @@getVariable26:
  1350 00001504 E819FE                   call getTokeType
  1351                                  
  1352                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  1353                                  
  1354 00001507 A0[B501]                 mov al, [TokeType]
  1355 0000150A 3C01                     cmp al, 1
  1356 0000150C 0F850D00                 jne @@getVariable27
  1357 00001510 FF36[5700]               push word [SymbolInt]
  1358 00001514 E8CB11                   call genCode8
  1359 00001517 83C402                   add  sp, 2
  1360                                  
  1361                                  ;-66         else {
  1362                                  
  1363 0000151A E94100                   jmp @@getVariable28
  1364                                  @@getVariable27:
  1365                                  
  1366                                  ;-67           skipBlank();
  1367                                  
  1368 0000151D E86B03                   call skipBlank
  1369                                  
  1370                                  ;-68           if (isToken('"')) {
  1371                                  
  1372 00001520 6A22                     push 34
  1373 00001522 E8D101                   call isToken
  1374 00001525 83C402                   add  sp, 2
  1375 00001528 08C0                     or  al, al
  1376 0000152A 0F843000                 je @@getVariable29
  1377                                  
  1378                                  ;-69             do { c= *InputPtr;
  1379                                  
  1380                                  @@getVariable30:
  1381 0000152E 8B1E[D800]               mov bx, [InputPtr]
  1382 00001532 8A07                     mov al, [bx]
  1383 00001534 B400                     mov ah, 0
  1384 00001536 8846FE                   mov byte [bp-2], al
  1385                                  
  1386                                  ;-70               genCode8(c);
  1387                                  
  1388 00001539 8A46FE                   mov al, byte [bp-2]
  1389 0000153C B400                     mov ah, 0
  1390 0000153E 50                       push ax
  1391 0000153F E8A011                   call genCode8
  1392 00001542 83C402                   add  sp, 2
  1393                                  
  1394                                  ;-71               InputPtr++;
  1395                                  
  1396 00001545 FF06[D800]               inc  word [InputPtr]
  1397                                  
  1398                                  ;-72             } while (*InputPtr != '"' );
  1399                                  
  1400 00001549 8B1E[D800]               mov bx, [InputPtr]
  1401 0000154D 8A07                     mov al, [bx]
  1402 0000154F B400                     mov ah, 0
  1403 00001551 83F822                   cmp ax, 34
  1404 00001554 0F840200                 je  @@getVariable31
  1405 00001558 EBD4                     jmp @@getVariable30
  1406                                  @@getVariable31:
  1407                                  
  1408                                  ;-73             InputPtr++;
  1409                                  
  1410 0000155A FF06[D800]               inc  word [InputPtr]
  1411                                  
  1412                                  ;-74           }
  1413                                  
  1414                                  
  1415                                  ;-75         }
  1416                                  
  1417                                  @@getVariable29:
  1418                                  
  1419                                  ;-76       } while (isToken(','));
  1420                                  
  1421                                  @@getVariable28:
  1422 0000155E 6A2C                     push 44
  1423 00001560 E89301                   call isToken
  1424 00001563 83C402                   add  sp, 2
  1425 00001566 08C0                     or  al, al
  1426 00001568 0F840200                 je @@getVariable32
  1427 0000156C EB96                     jmp @@getVariable26
  1428                                  @@getVariable32:
  1429                                  
  1430                                  ;-77     }
  1431                                  
  1432                                  
  1433                                  ;-78     if (CodeType== 201) {// DW
  1434                                  
  1435                                  @@getVariable25:
  1436 0000156E A0[B801]                 mov al, [CodeType]
  1437 00001571 3CC9                     cmp al, 201
  1438 00001573 0F852600                 jne @@getVariable33
  1439                                  
  1440                                  ;-79       do { getTokeType();
  1441                                  
  1442                                  @@getVariable34:
  1443 00001577 E8A6FD                   call getTokeType
  1444                                  
  1445                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  1446                                  
  1447 0000157A A0[B501]                 mov al, [TokeType]
  1448 0000157D 3C01                     cmp al, 1
  1449 0000157F 0F850A00                 jne @@getVariable35
  1450 00001583 FF36[5700]               push word [SymbolInt]
  1451 00001587 E8AE11                   call genCode16
  1452 0000158A 83C402                   add  sp, 2
  1453                                  
  1454                                  ;-81       } while (isToken(','));
  1455                                  
  1456                                  @@getVariable35:
  1457 0000158D 6A2C                     push 44
  1458 0000158F E86401                   call isToken
  1459 00001592 83C402                   add  sp, 2
  1460 00001595 08C0                     or  al, al
  1461 00001597 0F840200                 je @@getVariable36
  1462 0000159B EBDA                     jmp @@getVariable34
  1463                                  @@getVariable36:
  1464                                  
  1465                                  ;-82     }
  1466                                  
  1467                                  
  1468                                  ;-83   }
  1469                                  
  1470                                  @@getVariable33:
  1471                                  
  1472                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  1473                                  
  1474 0000159D E90900                   jmp @@getVariable37
  1475                                  @@getVariable22:
  1476 000015A0 68[DB15]                 push getVariable_2
  1477 000015A3 E85B0D                   call errorexit
  1478 000015A6 83C402                   add  sp, 2
  1479                                  
  1480                                  ;-85 }
  1481                                  
  1482                                  @@getVariable37:
  1483                                  
  1484                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  1485 000015A9 C9                       LEAVE
  1486 000015AA C3                       ret
  1487                                  ; ENDP
  1488 000015AB 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  1489 000015B4 422C572C4420657870-
  1490 000015BD 656374656400       
  1491 000015C3 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  1492 000015CC 422C572C4420657870-
  1493 000015D5 656374656400       
  1494 000015DB 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  1495 000015E4 6F7220524553422C57-
  1496 000015ED 2C4420657870656374-
  1497 000015F6 656400             
  1498                                  
  1499                                  lookCode:  ; *** PROC ***
  1500                                  
  1501                                  ;-87   CodeType=0;
  1502                                  
  1503 000015F9 66B800000000             mov eax, 0
  1504 000015FF A2[B801]                 mov byte [CodeType], al
  1505                                  
  1506                                  ;-88   OpCodePtr= &I_START;
  1507                                  
  1508 00001602 B8[5E0E]                 mov ax, I_START
  1509 00001605 A3[CF01]                 mov word [OpCodePtr], ax
  1510                                  
  1511                                  ;-89   OpCodePtr++;
  1512                                  
  1513 00001608 FF06[CF01]               inc  word [OpCodePtr]
  1514                                  
  1515                                  ;-90   do  {
  1516                                  
  1517                                  @@lookCode38:
  1518                                  
  1519                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  1520                                  
  1521 0000160C FF36[CF01]               push word [OpCodePtr]
  1522 00001610 8D06[3800]               lea  ax, [SymbolUpper]
  1523 00001614 50                       push ax
  1524 00001615 E87D19                   call eqstr
  1525 00001618 83C404                   add  sp, 4
  1526 0000161B 08C0                     or  al, al
  1527 0000161D 0F842700                 je @@lookCode39
  1528                                  
  1529                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  1530                                  
  1531                                  @@lookCode40:
  1532 00001621 8B1E[CF01]               mov bx, [OpCodePtr]
  1533 00001625 8A07                     mov al, [bx]
  1534 00001627 B400                     mov ah, 0
  1535 00001629 83F800                   cmp ax, 0
  1536 0000162C 0F840600                 je  @@lookCode41
  1537 00001630 FF06[CF01]               inc  word [OpCodePtr]
  1538                                  
  1539                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  1540                                  
  1541 00001634 EBEB                     jmp @@lookCode40
  1542                                  @@lookCode41:
  1543 00001636 FF06[CF01]               inc  word [OpCodePtr]
  1544 0000163A 8B1E[CF01]               mov bx, [OpCodePtr]
  1545 0000163E 8A07                     mov al, [bx]
  1546 00001640 B400                     mov ah, 0
  1547 00001642 A2[B801]                 mov byte [CodeType], al
  1548                                  
  1549                                  ;-94       return;
  1550                                  
  1551 00001645 E92A00                   jmp @@retn
  1552                                  
  1553                                  ;-95     }
  1554                                  
  1555                                  
  1556                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  1557                                  
  1558                                  @@lookCode39:
  1559                                  @@lookCode42:
  1560 00001648 8B1E[CF01]               mov bx, [OpCodePtr]
  1561 0000164C 8A07                     mov al, [bx]
  1562 0000164E B400                     mov ah, 0
  1563 00001650 3DF100                   cmp ax, 241
  1564 00001653 0F840600                 je  @@lookCode43
  1565 00001657 FF06[CF01]               inc  word [OpCodePtr]
  1566                                  
  1567                                  ;-97   OpCodePtr++;
  1568                                  
  1569 0000165B EBEB                     jmp @@lookCode42
  1570                                  @@lookCode43:
  1571 0000165D FF06[CF01]               inc  word [OpCodePtr]
  1572                                  
  1573                                  ;-98   } while(*OpCodePtr!=0);
  1574                                  
  1575 00001661 8B1E[CF01]               mov bx, [OpCodePtr]
  1576 00001665 8A07                     mov al, [bx]
  1577 00001667 B400                     mov ah, 0
  1578 00001669 83F800                   cmp ax, 0
  1579 0000166C 0F840200                 je  @@lookCode44
  1580 00001670 EB9A                     jmp @@lookCode38
  1581                                  @@lookCode44:
  1582                                  
  1583                                  ;-99 }
  1584                                  
  1585                                  
  1586                                  ;-100 
  1587                                  
  1588                                  
  1589                                  ;-101 int getCodeSize() {
  1590                                  
  1591                                  @@retn:
  1592 00001672 C3                       ret
  1593                                  ; ENDP
  1594                                  
  1595                                  getCodeSize:  ; *** PROC ***
  1596                                  
  1597                                  ;-102   if (TokeType ==ALNUME) {
  1598                                  
  1599 00001673 A0[B501]                 mov al, [TokeType]
  1600 00001676 3C03                     cmp al, 3
  1601 00001678 0F856000                 jne @@getCodeSize45
  1602                                  
  1603                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1604                                  
  1605 0000167C 68[E616]                 push getCodeSize_0
  1606 0000167F 8D06[3800]               lea  ax, [SymbolUpper]
  1607 00001683 50                       push ax
  1608 00001684 E80E19                   call eqstr
  1609 00001687 83C404                   add  sp, 4
  1610 0000168A 08C0                     or  al, al
  1611 0000168C 0F840C00                 je @@getCodeSize46
  1612 00001690 E88DFC                   call getTokeType
  1613 00001693 66B801000000             mov eax, 1
  1614 00001699 E94900                   jmp @@retn
  1615                                  
  1616                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1617                                  
  1618                                  @@getCodeSize46:
  1619 0000169C 68[EB16]                 push getCodeSize_1
  1620 0000169F 8D06[3800]               lea  ax, [SymbolUpper]
  1621 000016A3 50                       push ax
  1622 000016A4 E8EE18                   call eqstr
  1623 000016A7 83C404                   add  sp, 4
  1624 000016AA 08C0                     or  al, al
  1625 000016AC 0F840C00                 je @@getCodeSize47
  1626 000016B0 E86DFC                   call getTokeType
  1627 000016B3 66B802000000             mov eax, 2
  1628 000016B9 E92900                   jmp @@retn
  1629                                  
  1630                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1631                                  
  1632                                  @@getCodeSize47:
  1633 000016BC 68[F016]                 push getCodeSize_2
  1634 000016BF 8D06[3800]               lea  ax, [SymbolUpper]
  1635 000016C3 50                       push ax
  1636 000016C4 E8CE18                   call eqstr
  1637 000016C7 83C404                   add  sp, 4
  1638 000016CA 08C0                     or  al, al
  1639 000016CC 0F840C00                 je @@getCodeSize48
  1640 000016D0 E84DFC                   call getTokeType
  1641 000016D3 66B803000000             mov eax, 3
  1642 000016D9 E90900                   jmp @@retn
  1643                                  
  1644                                  ;-106   } return 0;
  1645                                  
  1646                                  @@getCodeSize48:
  1647                                  @@getCodeSize45:
  1648 000016DC 66B800000000             mov eax, 0
  1649 000016E2 E90000                   jmp @@retn
  1650                                  
  1651                                  ;-107 }
  1652                                  
  1653                                  
  1654                                  ;-108 int isToken(char c) {
  1655                                  
  1656                                  @@retn:
  1657 000016E5 C3                       ret
  1658                                  ; ENDP
  1659 000016E6 4259544500              getCodeSize_0 db "BYTE",0
  1660 000016EB 574F524400              getCodeSize_1 db "WORD",0
  1661 000016F0 44574F524400            getCodeSize_2 db "DWORD",0
  1662                                  
  1663                                  isToken:  ; *** PROC ***
  1664                                  
  1665                                  ;-109   skipBlank();
  1666                                  
  1667                                  ;Function : isToken, Number of local variables: 1
  1668                                  ;   # type sign width line used address name   list of local variables
  1669                                  ;  200 var sign byte   108 NULL bp+4    c;
  1670 000016F6 C8000000                 ENTER  0,0
  1671 000016FA E88E01                   call skipBlank
  1672                                  
  1673                                  ;-110   if (*InputPtr == c) {
  1674                                  
  1675 000016FD 8B1E[D800]               mov bx, [InputPtr]
  1676 00001701 8A07                     mov al, [bx]
  1677 00001703 B400                     mov ah, 0
  1678 00001705 3A4604                   cmp al, [bp+4]
  1679 00001708 0F850D00                 jne @@isToken49
  1680                                  
  1681                                  ;-111     InputPtr++; return 1;} return 0;
  1682                                  
  1683 0000170C FF06[D800]               inc  word [InputPtr]
  1684 00001710 66B801000000             mov eax, 1
  1685 00001716 E90900                   jmp @@retn
  1686                                  @@isToken49:
  1687 00001719 66B800000000             mov eax, 0
  1688 0000171F E90000                   jmp @@retn
  1689                                  
  1690                                  ;-112 }
  1691                                  
  1692                                  
  1693                                  ;-113 int need(char c) {
  1694                                  
  1695 00001722 C9                      @@retn: LEAVE
  1696 00001723 C3                       ret
  1697                                  ; ENDP
  1698                                  
  1699                                  need:  ; *** PROC ***
  1700                                  
  1701                                  ;-114   if (isToken(c)) return;
  1702                                  
  1703                                  ;Function : need, Number of local variables: 1
  1704                                  ;   # type sign width line used address name   list of local variables
  1705                                  ;  200 var sign byte   113 NULL bp+4    c;
  1706 00001724 C8000000                 ENTER  0,0
  1707 00001728 8A4604                   mov al, byte [bp+4]
  1708 0000172B B400                     mov ah, 0
  1709 0000172D 50                       push ax
  1710 0000172E E8C5FF                   call isToken
  1711 00001731 83C402                   add  sp, 2
  1712 00001734 08C0                     or  al, al
  1713 00001736 0F840300                 je @@need50
  1714 0000173A E91800                   jmp @@retn
  1715                                  
  1716                                  ;-115   error1();
  1717                                  
  1718                                  @@need50:
  1719 0000173D E8070A                   call error1
  1720                                  
  1721                                  ;-116   prs(". need: ");
  1722                                  
  1723 00001740 68[5717]                 push need_0
  1724 00001743 E8A408                   call prs
  1725 00001746 83C402                   add  sp, 2
  1726                                  
  1727                                  ;-117   prc(c);
  1728                                  
  1729 00001749 8A4604                   mov al, byte [bp+4]
  1730 0000174C B400                     mov ah, 0
  1731 0000174E 50                       push ax
  1732 0000174F E83708                   call prc
  1733 00001752 83C402                   add  sp, 2
  1734                                  
  1735                                  ;-118 }
  1736                                  
  1737                                  
  1738                                  ;-119 
  1739                                  
  1740                                  
  1741                                  ;-120 int skipRest() {
  1742                                  
  1743 00001755 C9                      @@retn: LEAVE
  1744 00001756 C3                       ret
  1745                                  ; ENDP
  1746 00001757 2E206E6565643A2000      need_0 db ". need: ",0
  1747                                  
  1748                                  skipRest:  ; *** PROC ***
  1749                                  
  1750                                  ;-121   getTokeType(); 
  1751                                  
  1752 00001760 E8BDFB                   call getTokeType
  1753                                  
  1754                                  ;-122   if(TokeType)error1("extra char ignored");
  1755                                  
  1756 00001763 A0[B501]                 mov al, [TokeType]
  1757 00001766 08C0                     or  al, al
  1758 00001768 0F840900                 je @@skipRest51
  1759 0000176C 68[7617]                 push skipRest_0
  1760 0000176F E8D509                   call error1
  1761 00001772 83C402                   add  sp, 2
  1762                                  
  1763                                  ;-123 }
  1764                                  
  1765                                  @@skipRest51:
  1766 00001775 C3                       ret
  1767                                  ; ENDP
  1768 00001776 657874726120636861-     skipRest_0 db "extra char ignored",0
  1769 0000177F 722069676E6F726564-
  1770 00001788 00                 
  1771                                  ;Back to main program: AS.C
  1772                                  
  1773                                  ;-6 #include "HELPER.C"
  1774                                  
  1775                                  ;Use include file: HELPER.C
  1776                                  
  1777                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  1778                                  
  1779                                  
  1780                                  getLine:  ; *** PROC ***
  1781                                  
  1782                                  ;-2   unsigned int i;
  1783                                  
  1784                                  
  1785                                  ;-3   InputPtr= &InputBuf;
  1786                                  
  1787                                  ;Function : getLine, Number of local variables: 1
  1788                                  ;   # type sign width line used address name   list of local variables
  1789                                  ;  200 var unsg word     2 NULL bp-2    i;
  1790 00001789 C8020000                 ENTER  2,0
  1791 0000178D B8[5900]                 mov ax, InputBuf
  1792 00001790 A3[D800]                 mov word [InputPtr], ax
  1793                                  
  1794                                  ;-4   *InputPtr=0;//if last line is empty
  1795                                  
  1796 00001793 66B800000000             mov eax, 0
  1797 00001799 8B1E[D800]               mov  bx, [InputPtr]
  1798 0000179D 8807                     mov  [bx], al
  1799                                  
  1800                                  ;-5   do {
  1801                                  
  1802                                  @@getLine52:
  1803                                  
  1804                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1805                                  
  1806 0000179F 6A01                     push 1
  1807 000017A1 FF36[A301]               push word [asm_fd]
  1808 000017A5 8D06[AF01]               lea  ax, [DOS_ByteRead]
  1809 000017A9 50                       push ax
  1810 000017AA E88318                   call readRL
  1811 000017AD 83C406                   add  sp, 6
  1812 000017B0 A3[AD01]                 mov word [DOS_NoBytes], ax
  1813                                  
  1814                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  1815                                  
  1816 000017B3 A1[A901]                 mov ax, [DOS_ERR]
  1817 000017B6 08C0                     or  al, al
  1818 000017B8 0F840900                 je @@getLine53
  1819 000017BC 68[2118]                 push getLine_0
  1820 000017BF E83F0B                   call errorexit
  1821 000017C2 83C402                   add  sp, 2
  1822                                  
  1823                                  ;-8     if (DOS_NoBytes == 0) return;
  1824                                  
  1825                                  @@getLine53:
  1826 000017C5 A1[AD01]                 mov ax, [DOS_NoBytes]
  1827 000017C8 83F800                   cmp ax, 0
  1828 000017CB 0F850300                 jne @@getLine54
  1829 000017CF E94D00                   jmp @@retn
  1830                                  
  1831                                  ;-9     *InputPtr = DOS_ByteRead;
  1832                                  
  1833                                  @@getLine54:
  1834 000017D2 A0[AF01]                 mov al, [DOS_ByteRead]
  1835 000017D5 8B1E[D800]               mov  bx, [InputPtr]
  1836 000017D9 8807                     mov  [bx], al
  1837                                  
  1838                                  ;-10     InputPtr++;
  1839                                  
  1840 000017DB FF06[D800]               inc  word [InputPtr]
  1841                                  
  1842                                  ;-11     i = InputPtr - &InputBuf;
  1843                                  
  1844 000017DF A1[D800]                 mov ax, [InputPtr]
  1845 000017E2 2D[5900]                 sub ax, InputBuf
  1846 000017E5 8946FE                   mov word [bp-2], ax
  1847                                  
  1848                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  1849                                  
  1850 000017E8 8B46FE                   mov ax, [bp-2]
  1851 000017EB 83F87F                   cmp ax, 127 ;unsigned : 0
  1852 000017EE 0F820900                 jb  @@getLine55
  1853 000017F2 68[3018]                 push getLine_1
  1854 000017F5 E8090B                   call errorexit
  1855 000017F8 83C402                   add  sp, 2
  1856                                  
  1857                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  1858                                  
  1859                                  @@getLine55:
  1860 000017FB A0[AF01]                 mov al, byte [DOS_ByteRead]
  1861 000017FE B400                     mov ah, 0
  1862 00001800 50                       push ax
  1863 00001801 E84000                   call ifEOL
  1864 00001804 83C402                   add  sp, 2
  1865 00001807 3C00                     cmp al, 0
  1866 00001809 0F850200                 jne @@getLine56
  1867 0000180D EB90                     jmp @@getLine52
  1868                                  @@getLine56:
  1869                                  
  1870                                  ;-14   InputPtr--;
  1871                                  
  1872 0000180F FF0E[D800]               dec  word [InputPtr]
  1873                                  
  1874                                  ;-15   *InputPtr=0;
  1875                                  
  1876 00001813 66B800000000             mov eax, 0
  1877 00001819 8B1E[D800]               mov  bx, [InputPtr]
  1878 0000181D 8807                     mov  [bx], al
  1879                                  
  1880                                  ;-16 }
  1881                                  
  1882                                  
  1883                                  ;-17 int ifEOL(char c) {
  1884                                  
  1885 0000181F C9                      @@retn: LEAVE
  1886 00001820 C3                       ret
  1887                                  ; ENDP
  1888 00001821 52656164696E672053-     getLine_0 db "Reading Source",0
  1889 0000182A 6F7572636500       
  1890 00001830 696E707574206C696E-     getLine_1 db "input line too long",0
  1891 00001839 6520746F6F206C6F6E-
  1892 00001842 6700               
  1893                                  
  1894                                  ifEOL:  ; *** PROC ***
  1895                                  
  1896                                  ;-18   if (c == 10) return 1;
  1897                                  
  1898                                  ;Function : ifEOL, Number of local variables: 1
  1899                                  ;   # type sign width line used address name   list of local variables
  1900                                  ;  200 var sign byte    17 NULL bp+4    c;
  1901 00001844 C8000000                 ENTER  0,0
  1902 00001848 8A4604                   mov al, [bp+4]
  1903 0000184B 3C0A                     cmp al, 10
  1904 0000184D 0F850900                 jne @@ifEOL57
  1905 00001851 66B801000000             mov eax, 1
  1906 00001857 E92F00                   jmp @@retn
  1907                                  
  1908                                  ;-19   if (c == 13) {
  1909                                  
  1910                                  @@ifEOL57:
  1911 0000185A 8A4604                   mov al, [bp+4]
  1912 0000185D 3C0D                     cmp al, 13
  1913 0000185F 0F851D00                 jne @@ifEOL58
  1914                                  
  1915                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1916                                  
  1917 00001863 6A01                     push 1
  1918 00001865 FF36[A301]               push word [asm_fd]
  1919 00001869 8D06[AF01]               lea  ax, [DOS_ByteRead]
  1920 0000186D 50                       push ax
  1921 0000186E E8BF17                   call readRL
  1922 00001871 83C406                   add  sp, 6
  1923 00001874 A3[AD01]                 mov word [DOS_NoBytes], ax
  1924                                  
  1925                                  ;-21     return 1;}
  1926                                  
  1927 00001877 66B801000000             mov eax, 1
  1928 0000187D E90900                   jmp @@retn
  1929                                  
  1930                                  ;-22   return 0;
  1931                                  
  1932                                  @@ifEOL58:
  1933 00001880 66B800000000             mov eax, 0
  1934 00001886 E90000                   jmp @@retn
  1935                                  
  1936                                  ;-23 }
  1937                                  
  1938                                  
  1939                                  ;-24 int skipBlank() {
  1940                                  
  1941 00001889 C9                      @@retn: LEAVE
  1942 0000188A C3                       ret
  1943                                  ; ENDP
  1944                                  
  1945                                  skipBlank:  ; *** PROC ***
  1946                                  
  1947                                  ;-25   skipblank1:
  1948                                  
  1949                                  @@skipblank1:
  1950                                  
  1951                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  1952                                  
  1953 0000188B 8B1E[D800]               mov bx, [InputPtr]
  1954 0000188F 8A07                     mov al, [bx]
  1955 00001891 B400                     mov ah, 0
  1956 00001893 83F820                   cmp ax, 32
  1957 00001896 0F850600                 jne @@skipBlank59
  1958 0000189A FF06[D800]               inc  word [InputPtr]
  1959 0000189E EBEB                     jmp @@skipblank1
  1960                                  
  1961                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  1962                                  
  1963                                  @@skipBlank59:
  1964 000018A0 8B1E[D800]               mov bx, [InputPtr]
  1965 000018A4 8A07                     mov al, [bx]
  1966 000018A6 B400                     mov ah, 0
  1967 000018A8 83F809                   cmp ax, 9
  1968 000018AB 0F850600                 jne @@skipBlank60
  1969 000018AF FF06[D800]               inc  word [InputPtr]
  1970 000018B3 EBD6                     jmp @@skipblank1
  1971                                  
  1972                                  ;-28 }
  1973                                  
  1974                                  @@skipBlank60:
  1975                                  
  1976                                  ;-29 int letterE(char c) {
  1977                                  
  1978 000018B5 C3                       ret
  1979                                  ; ENDP
  1980                                  
  1981                                  letterE:  ; *** PROC ***
  1982                                  
  1983                                  ;-30   if (c=='_') return 1;
  1984                                  
  1985                                  ;Function : letterE, Number of local variables: 1
  1986                                  ;   # type sign width line used address name   list of local variables
  1987                                  ;  200 var sign byte    29 NULL bp+4    c;
  1988 000018B6 C8000000                 ENTER  0,0
  1989 000018BA 8A4604                   mov al, [bp+4]
  1990 000018BD 3C5F                     cmp al, 95
  1991 000018BF 0F850900                 jne @@letterE61
  1992 000018C3 66B801000000             mov eax, 1
  1993 000018C9 E97E00                   jmp @@retn
  1994                                  
  1995                                  ;-31   if (c=='.') return 1;
  1996                                  
  1997                                  @@letterE61:
  1998 000018CC 8A4604                   mov al, [bp+4]
  1999 000018CF 3C2E                     cmp al, 46
  2000 000018D1 0F850900                 jne @@letterE62
  2001 000018D5 66B801000000             mov eax, 1
  2002 000018DB E96C00                   jmp @@retn
  2003                                  
  2004                                  ;-32   if (c=='?') return 1;
  2005                                  
  2006                                  @@letterE62:
  2007 000018DE 8A4604                   mov al, [bp+4]
  2008 000018E1 3C3F                     cmp al, 63
  2009 000018E3 0F850900                 jne @@letterE63
  2010 000018E7 66B801000000             mov eax, 1
  2011 000018ED E95A00                   jmp @@retn
  2012                                  
  2013                                  ;-33   if (c=='$') return 1;
  2014                                  
  2015                                  @@letterE63:
  2016 000018F0 8A4604                   mov al, [bp+4]
  2017 000018F3 3C24                     cmp al, 36
  2018 000018F5 0F850900                 jne @@letterE64
  2019 000018F9 66B801000000             mov eax, 1
  2020 000018FF E94800                   jmp @@retn
  2021                                  
  2022                                  ;-34   if (c> 'z') return 0;
  2023                                  
  2024                                  @@letterE64:
  2025 00001902 8A4604                   mov al, [bp+4]
  2026 00001905 3C7A                     cmp al, 122
  2027 00001907 0F8E0900                 jle @@letterE65
  2028 0000190B 66B800000000             mov eax, 0
  2029 00001911 E93600                   jmp @@retn
  2030                                  
  2031                                  ;-35   if (c< '@') return 0; // at included
  2032                                  
  2033                                  @@letterE65:
  2034 00001914 8A4604                   mov al, [bp+4]
  2035 00001917 3C40                     cmp al, 64
  2036 00001919 0F8D0900                 jge @@letterE66
  2037 0000191D 66B800000000             mov eax, 0
  2038 00001923 E92400                   jmp @@retn
  2039                                  
  2040                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2041                                  
  2042                                  @@letterE66:
  2043 00001926 8A4604                   mov al, [bp+4]
  2044 00001929 3C5A                     cmp al, 90
  2045 0000192B 0F8E1200                 jle @@letterE67
  2046 0000192F 8A4604                   mov al, [bp+4]
  2047 00001932 3C61                     cmp al, 97
  2048 00001934 0F8D0900                 jge @@letterE68
  2049 00001938 66B800000000             mov eax, 0
  2050 0000193E E90900                   jmp @@retn
  2051                                  @@letterE68:
  2052                                  
  2053                                  ;-37   return 1;
  2054                                  
  2055                                  @@letterE67:
  2056 00001941 66B801000000             mov eax, 1
  2057 00001947 E90000                   jmp @@retn
  2058                                  
  2059                                  ;-38 }
  2060                                  
  2061                                  
  2062                                  ;-39 int alnumE(char c) {
  2063                                  
  2064 0000194A C9                      @@retn: LEAVE
  2065 0000194B C3                       ret
  2066                                  ; ENDP
  2067                                  
  2068                                  alnumE:  ; *** PROC ***
  2069                                  
  2070                                  ;-40   if (digit(c)) return 1;
  2071                                  
  2072                                  ;Function : alnumE, Number of local variables: 1
  2073                                  ;   # type sign width line used address name   list of local variables
  2074                                  ;  200 var sign byte    39 NULL bp+4    c;
  2075 0000194C C8000000                 ENTER  0,0
  2076 00001950 8A4604                   mov al, byte [bp+4]
  2077 00001953 B400                     mov ah, 0
  2078 00001955 50                       push ax
  2079 00001956 E80916                   call digit
  2080 00001959 83C402                   add  sp, 2
  2081 0000195C 08C0                     or  al, al
  2082 0000195E 0F840900                 je @@alnumE69
  2083 00001962 66B801000000             mov eax, 1
  2084 00001968 E92400                   jmp @@retn
  2085                                  
  2086                                  ;-41   if (letterE(c)) return 1;
  2087                                  
  2088                                  @@alnumE69:
  2089 0000196B 8A4604                   mov al, byte [bp+4]
  2090 0000196E B400                     mov ah, 0
  2091 00001970 50                       push ax
  2092 00001971 E842FF                   call letterE
  2093 00001974 83C402                   add  sp, 2
  2094 00001977 08C0                     or  al, al
  2095 00001979 0F840900                 je @@alnumE70
  2096 0000197D 66B801000000             mov eax, 1
  2097 00001983 E90900                   jmp @@retn
  2098                                  
  2099                                  ;-42   return 0;
  2100                                  
  2101                                  @@alnumE70:
  2102 00001986 66B800000000             mov eax, 0
  2103 0000198C E90000                   jmp @@retn
  2104                                  
  2105                                  ;-43 }
  2106                                  
  2107                                  
  2108                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2109                                  
  2110 0000198F C9                      @@retn: LEAVE
  2111 00001990 C3                       ret
  2112                                  ; ENDP
  2113                                  
  2114                                  getDigit:  ; *** PROC ***
  2115                                  
  2116                                  ;-45   unsigned int CastInt;
  2117                                  
  2118                                  
  2119                                  ;-46   SymbolInt=0;
  2120                                  
  2121                                  ;Function : getDigit, Number of local variables: 2
  2122                                  ;   # type sign width line used address name   list of local variables
  2123                                  ;  200 var unsg byte    44 NULL bp+4    c
  2124                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  2125 00001991 C8020000                 ENTER  2,0
  2126 00001995 66B800000000             mov eax, 0
  2127 0000199B A3[5700]                 mov word [SymbolInt], ax
  2128                                  
  2129                                  ;-47   do {
  2130                                  
  2131                                  @@getDigit71:
  2132                                  
  2133                                  ;-48     c-='0';
  2134                                  
  2135 0000199E 806E0430                 sub  byte [bp+4], 48
  2136                                  
  2137                                  ;-49     SymbolInt=SymbolInt*10;
  2138                                  
  2139 000019A2 A1[5700]                 mov ax, [SymbolInt]
  2140 000019A5 66BB0A000000             mov ebx, 10
  2141 000019AB 66F7E3                   mul ebx
  2142 000019AE A3[5700]                 mov word [SymbolInt], ax
  2143                                  
  2144                                  ;-50     ax=0; CastInt=c; //cast b2w
  2145                                  
  2146 000019B1 B80000                   mov  ax, 0
  2147 000019B4 8A4604                   mov al, [bp+4]
  2148 000019B7 8946FE                   mov word [bp-2], ax
  2149                                  
  2150                                  ;-51     SymbolInt=SymbolInt+CastInt;
  2151                                  
  2152 000019BA A1[5700]                 mov ax, [SymbolInt]
  2153 000019BD 0346FE                   add ax, [bp-2]
  2154 000019C0 A3[5700]                 mov word [SymbolInt], ax
  2155                                  
  2156                                  ;-52     InputPtr++;
  2157                                  
  2158 000019C3 FF06[D800]               inc  word [InputPtr]
  2159                                  
  2160                                  ;-53     c = *InputPtr;
  2161                                  
  2162 000019C7 8B1E[D800]               mov bx, [InputPtr]
  2163 000019CB 8A07                     mov al, [bx]
  2164 000019CD B400                     mov ah, 0
  2165 000019CF 884604                   mov byte [bp+4], al
  2166                                  
  2167                                  ;-54   } while(digit(c));
  2168                                  
  2169 000019D2 8A4604                   mov al, byte [bp+4]
  2170 000019D5 B400                     mov ah, 0
  2171 000019D7 50                       push ax
  2172 000019D8 E88715                   call digit
  2173 000019DB 83C402                   add  sp, 2
  2174 000019DE 08C0                     or  al, al
  2175 000019E0 0F840200                 je @@getDigit72
  2176 000019E4 EBB8                     jmp @@getDigit71
  2177                                  @@getDigit72:
  2178                                  
  2179                                  ;-55 }
  2180                                  
  2181                                  
  2182                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2183 000019E6 C9                       LEAVE
  2184 000019E7 C3                       ret
  2185                                  ; ENDP
  2186                                  
  2187                                  getName:  ; *** PROC ***
  2188                                  
  2189                                  ;-57   char *p; unsigned int i;
  2190                                  
  2191                                  
  2192                                  ;-58   p = &Symbol;
  2193                                  
  2194                                  ;Function : getName, Number of local variables: 3
  2195                                  ;   # type sign width line used address name   list of local variables
  2196                                  ;  200 var unsg byte    56 NULL bp+4    c
  2197                                  ;  201 ptr sign byte    57 NULL bp-2    p
  2198                                  ;  202 var unsg word    57 NULL bp-4    i;
  2199 000019E8 C8040000                 ENTER  4,0
  2200 000019EC B8[1900]                 mov ax, Symbol
  2201 000019EF 8946FE                   mov word [bp-2], ax
  2202                                  
  2203                                  ;-59   *p = c;
  2204                                  
  2205 000019F2 8A4604                   mov al, [bp+4]
  2206 000019F5 8B5EFE                   mov  bx, [bp-2]
  2207 000019F8 8807                     mov  [bx], al
  2208                                  
  2209                                  ;-60   p++;
  2210                                  
  2211 000019FA FF46FE                   inc  word [bp-2]
  2212                                  
  2213                                  ;-61   while (alnumE(c)) {
  2214                                  
  2215                                  @@getName73:
  2216 000019FD 8A4604                   mov al, byte [bp+4]
  2217 00001A00 B400                     mov ah, 0
  2218 00001A02 50                       push ax
  2219 00001A03 E846FF                   call alnumE
  2220 00001A06 83C402                   add  sp, 2
  2221 00001A09 08C0                     or  al, al
  2222 00001A0B 0F843800                 je @@getName74
  2223                                  
  2224                                  ;-62     InputPtr++;
  2225                                  
  2226 00001A0F FF06[D800]               inc  word [InputPtr]
  2227                                  
  2228                                  ;-63     c = *InputPtr;
  2229                                  
  2230 00001A13 8B1E[D800]               mov bx, [InputPtr]
  2231 00001A17 8A07                     mov al, [bx]
  2232 00001A19 B400                     mov ah, 0
  2233 00001A1B 884604                   mov byte [bp+4], al
  2234                                  
  2235                                  ;-64     *p = c;
  2236                                  
  2237 00001A1E 8A4604                   mov al, [bp+4]
  2238 00001A21 8B5EFE                   mov  bx, [bp-2]
  2239 00001A24 8807                     mov  [bx], al
  2240                                  
  2241                                  ;-65     p++;
  2242                                  
  2243 00001A26 FF46FE                   inc  word [bp-2]
  2244                                  
  2245                                  ;-66     i = p - &Symbol;
  2246                                  
  2247 00001A29 8B46FE                   mov ax, [bp-2]
  2248 00001A2C 2D[1900]                 sub ax, Symbol
  2249 00001A2F 8946FC                   mov word [bp-4], ax
  2250                                  
  2251                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  2252                                  
  2253 00001A32 8B46FC                   mov ax, [bp-4]
  2254 00001A35 83F81F                   cmp ax, 31 ;unsigned : 0
  2255 00001A38 0F820900                 jb  @@getName75
  2256 00001A3C 68[901A]                 push getName_0
  2257 00001A3F E8BF08                   call errorexit
  2258 00001A42 83C402                   add  sp, 2
  2259                                  
  2260                                  ;-68   }
  2261                                  
  2262                                  @@getName75:
  2263                                  
  2264                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  2265                                  
  2266 00001A45 EBB6                     jmp @@getName73
  2267                                  @@getName74:
  2268 00001A47 8A4604                   mov al, [bp+4]
  2269 00001A4A 3C3A                     cmp al, 58
  2270 00001A4C 0F850C00                 jne @@getName76
  2271 00001A50 66B801000000             mov eax, 1
  2272 00001A56 A2[B401]                 mov byte [isLabel], al
  2273 00001A59 E90900                   jmp @@getName77
  2274                                  @@getName76:
  2275 00001A5C 66B800000000             mov eax, 0
  2276 00001A62 A2[B401]                 mov byte [isLabel], al
  2277                                  
  2278                                  ;-70   p--;
  2279                                  
  2280                                  @@getName77:
  2281 00001A65 FF4EFE                   dec  word [bp-2]
  2282                                  
  2283                                  ;-71   *p = 0;
  2284                                  
  2285 00001A68 66B800000000             mov eax, 0
  2286 00001A6E 8B5EFE                   mov  bx, [bp-2]
  2287 00001A71 8807                     mov  [bx], al
  2288                                  
  2289                                  ;-72   strcpy(SymbolUpper, Symbol);
  2290                                  
  2291 00001A73 8D06[1900]               lea  ax, [Symbol]
  2292 00001A77 50                       push ax
  2293 00001A78 8D06[3800]               lea  ax, [SymbolUpper]
  2294 00001A7C 50                       push ax
  2295 00001A7D E8A914                   call strcpy
  2296 00001A80 83C404                   add  sp, 4
  2297                                  
  2298                                  ;-73   toupper(SymbolUpper);
  2299                                  
  2300 00001A83 8D06[3800]               lea  ax, [SymbolUpper]
  2301 00001A87 50                       push ax
  2302 00001A88 E83014                   call toupper
  2303 00001A8B 83C402                   add  sp, 2
  2304                                  
  2305                                  ;-74 }
  2306                                  
  2307                                  
  2308                                  ;-75 int testReg() {
  2309 00001A8E C9                       LEAVE
  2310 00001A8F C3                       ret
  2311                                  ; ENDP
  2312 00001A90 73796D626F6C20746F-     getName_0 db "symbol too long",0
  2313 00001A99 6F206C6F6E6700     
  2314                                  
  2315                                  testReg:  ; *** PROC ***
  2316                                  
  2317                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2318                                  
  2319                                  
  2320                                  ;-77   RegType=0;
  2321                                  
  2322 00001AA0 66B800000000             mov eax, 0
  2323 00001AA6 A2[BE01]                 mov byte [RegType], al
  2324                                  
  2325                                  ;-78   if (strlen(Symbol) < 2) return 0;
  2326                                  
  2327 00001AA9 8D06[1900]               lea  ax, [Symbol]
  2328 00001AAD 50                       push ax
  2329 00001AAE E84D14                   call strlen
  2330 00001AB1 83C402                   add  sp, 2
  2331 00001AB4 3C02                     cmp al, 2
  2332 00001AB6 0F8D0900                 jge @@testReg78
  2333 00001ABA 66B800000000             mov eax, 0
  2334 00001AC0 E9B603                   jmp @@retn
  2335                                  
  2336                                  ;-79   if (strlen(Symbol) > 3) return 0;
  2337                                  
  2338                                  @@testReg78:
  2339 00001AC3 8D06[1900]               lea  ax, [Symbol]
  2340 00001AC7 50                       push ax
  2341 00001AC8 E83314                   call strlen
  2342 00001ACB 83C402                   add  sp, 2
  2343 00001ACE 3C03                     cmp al, 3
  2344 00001AD0 0F8E0900                 jle @@testReg79
  2345 00001AD4 66B800000000             mov eax, 0
  2346 00001ADA E99C03                   jmp @@retn
  2347                                  
  2348                                  ;-80   RegType=BYTE;
  2349                                  
  2350                                  @@testReg79:
  2351 00001ADD 66B801000000             mov eax, 1
  2352 00001AE3 A2[BE01]                 mov byte [RegType], al
  2353                                  
  2354                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  2355                                  
  2356 00001AE6 68[7A1E]                 push testReg_0
  2357 00001AE9 8D06[3800]               lea  ax, [SymbolUpper]
  2358 00001AED 50                       push ax
  2359 00001AEE E8A414                   call eqstr
  2360 00001AF1 83C404                   add  sp, 4
  2361 00001AF4 08C0                     or  al, al
  2362 00001AF6 0F840900                 je @@testReg80
  2363 00001AFA 66B800000000             mov eax, 0
  2364 00001B00 E97603                   jmp @@retn
  2365                                  
  2366                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  2367                                  
  2368                                  @@testReg80:
  2369 00001B03 68[7D1E]                 push testReg_1
  2370 00001B06 8D06[3800]               lea  ax, [SymbolUpper]
  2371 00001B0A 50                       push ax
  2372 00001B0B E88714                   call eqstr
  2373 00001B0E 83C404                   add  sp, 4
  2374 00001B11 08C0                     or  al, al
  2375 00001B13 0F840900                 je @@testReg81
  2376 00001B17 66B801000000             mov eax, 1
  2377 00001B1D E95903                   jmp @@retn
  2378                                  
  2379                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  2380                                  
  2381                                  @@testReg81:
  2382 00001B20 68[801E]                 push testReg_2
  2383 00001B23 8D06[3800]               lea  ax, [SymbolUpper]
  2384 00001B27 50                       push ax
  2385 00001B28 E86A14                   call eqstr
  2386 00001B2B 83C404                   add  sp, 4
  2387 00001B2E 08C0                     or  al, al
  2388 00001B30 0F840900                 je @@testReg82
  2389 00001B34 66B802000000             mov eax, 2
  2390 00001B3A E93C03                   jmp @@retn
  2391                                  
  2392                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  2393                                  
  2394                                  @@testReg82:
  2395 00001B3D 68[831E]                 push testReg_3
  2396 00001B40 8D06[3800]               lea  ax, [SymbolUpper]
  2397 00001B44 50                       push ax
  2398 00001B45 E84D14                   call eqstr
  2399 00001B48 83C404                   add  sp, 4
  2400 00001B4B 08C0                     or  al, al
  2401 00001B4D 0F840900                 je @@testReg83
  2402 00001B51 66B803000000             mov eax, 3
  2403 00001B57 E91F03                   jmp @@retn
  2404                                  
  2405                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  2406                                  
  2407                                  @@testReg83:
  2408 00001B5A 68[861E]                 push testReg_4
  2409 00001B5D 8D06[3800]               lea  ax, [SymbolUpper]
  2410 00001B61 50                       push ax
  2411 00001B62 E83014                   call eqstr
  2412 00001B65 83C404                   add  sp, 4
  2413 00001B68 08C0                     or  al, al
  2414 00001B6A 0F840900                 je @@testReg84
  2415 00001B6E 66B804000000             mov eax, 4
  2416 00001B74 E90203                   jmp @@retn
  2417                                  
  2418                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  2419                                  
  2420                                  @@testReg84:
  2421 00001B77 68[891E]                 push testReg_5
  2422 00001B7A 8D06[3800]               lea  ax, [SymbolUpper]
  2423 00001B7E 50                       push ax
  2424 00001B7F E81314                   call eqstr
  2425 00001B82 83C404                   add  sp, 4
  2426 00001B85 08C0                     or  al, al
  2427 00001B87 0F840900                 je @@testReg85
  2428 00001B8B 66B805000000             mov eax, 5
  2429 00001B91 E9E502                   jmp @@retn
  2430                                  
  2431                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  2432                                  
  2433                                  @@testReg85:
  2434 00001B94 68[8C1E]                 push testReg_6
  2435 00001B97 8D06[3800]               lea  ax, [SymbolUpper]
  2436 00001B9B 50                       push ax
  2437 00001B9C E8F613                   call eqstr
  2438 00001B9F 83C404                   add  sp, 4
  2439 00001BA2 08C0                     or  al, al
  2440 00001BA4 0F840900                 je @@testReg86
  2441 00001BA8 66B806000000             mov eax, 6
  2442 00001BAE E9C802                   jmp @@retn
  2443                                  
  2444                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  2445                                  
  2446                                  @@testReg86:
  2447 00001BB1 68[8F1E]                 push testReg_7
  2448 00001BB4 8D06[3800]               lea  ax, [SymbolUpper]
  2449 00001BB8 50                       push ax
  2450 00001BB9 E8D913                   call eqstr
  2451 00001BBC 83C404                   add  sp, 4
  2452 00001BBF 08C0                     or  al, al
  2453 00001BC1 0F840900                 je @@testReg87
  2454 00001BC5 66B807000000             mov eax, 7
  2455 00001BCB E9AB02                   jmp @@retn
  2456                                  
  2457                                  ;-89   RegType=WORD;
  2458                                  
  2459                                  @@testReg87:
  2460 00001BCE 66B802000000             mov eax, 2
  2461 00001BD4 A2[BE01]                 mov byte [RegType], al
  2462                                  
  2463                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  2464                                  
  2465 00001BD7 68[921E]                 push testReg_8
  2466 00001BDA 8D06[3800]               lea  ax, [SymbolUpper]
  2467 00001BDE 50                       push ax
  2468 00001BDF E8B313                   call eqstr
  2469 00001BE2 83C404                   add  sp, 4
  2470 00001BE5 08C0                     or  al, al
  2471 00001BE7 0F840900                 je @@testReg88
  2472 00001BEB 66B800000000             mov eax, 0
  2473 00001BF1 E98502                   jmp @@retn
  2474                                  
  2475                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  2476                                  
  2477                                  @@testReg88:
  2478 00001BF4 68[951E]                 push testReg_9
  2479 00001BF7 8D06[3800]               lea  ax, [SymbolUpper]
  2480 00001BFB 50                       push ax
  2481 00001BFC E89613                   call eqstr
  2482 00001BFF 83C404                   add  sp, 4
  2483 00001C02 08C0                     or  al, al
  2484 00001C04 0F840900                 je @@testReg89
  2485 00001C08 66B801000000             mov eax, 1
  2486 00001C0E E96802                   jmp @@retn
  2487                                  
  2488                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  2489                                  
  2490                                  @@testReg89:
  2491 00001C11 68[981E]                 push testReg_10
  2492 00001C14 8D06[3800]               lea  ax, [SymbolUpper]
  2493 00001C18 50                       push ax
  2494 00001C19 E87913                   call eqstr
  2495 00001C1C 83C404                   add  sp, 4
  2496 00001C1F 08C0                     or  al, al
  2497 00001C21 0F840900                 je @@testReg90
  2498 00001C25 66B802000000             mov eax, 2
  2499 00001C2B E94B02                   jmp @@retn
  2500                                  
  2501                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  2502                                  
  2503                                  @@testReg90:
  2504 00001C2E 68[9B1E]                 push testReg_11
  2505 00001C31 8D06[3800]               lea  ax, [SymbolUpper]
  2506 00001C35 50                       push ax
  2507 00001C36 E85C13                   call eqstr
  2508 00001C39 83C404                   add  sp, 4
  2509 00001C3C 08C0                     or  al, al
  2510 00001C3E 0F840900                 je @@testReg91
  2511 00001C42 66B803000000             mov eax, 3
  2512 00001C48 E92E02                   jmp @@retn
  2513                                  
  2514                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  2515                                  
  2516                                  @@testReg91:
  2517 00001C4B 68[9E1E]                 push testReg_12
  2518 00001C4E 8D06[3800]               lea  ax, [SymbolUpper]
  2519 00001C52 50                       push ax
  2520 00001C53 E83F13                   call eqstr
  2521 00001C56 83C404                   add  sp, 4
  2522 00001C59 08C0                     or  al, al
  2523 00001C5B 0F840900                 je @@testReg92
  2524 00001C5F 66B804000000             mov eax, 4
  2525 00001C65 E91102                   jmp @@retn
  2526                                  
  2527                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  2528                                  
  2529                                  @@testReg92:
  2530 00001C68 68[A11E]                 push testReg_13
  2531 00001C6B 8D06[3800]               lea  ax, [SymbolUpper]
  2532 00001C6F 50                       push ax
  2533 00001C70 E82213                   call eqstr
  2534 00001C73 83C404                   add  sp, 4
  2535 00001C76 08C0                     or  al, al
  2536 00001C78 0F840900                 je @@testReg93
  2537 00001C7C 66B805000000             mov eax, 5
  2538 00001C82 E9F401                   jmp @@retn
  2539                                  
  2540                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  2541                                  
  2542                                  @@testReg93:
  2543 00001C85 68[A41E]                 push testReg_14
  2544 00001C88 8D06[3800]               lea  ax, [SymbolUpper]
  2545 00001C8C 50                       push ax
  2546 00001C8D E80513                   call eqstr
  2547 00001C90 83C404                   add  sp, 4
  2548 00001C93 08C0                     or  al, al
  2549 00001C95 0F840900                 je @@testReg94
  2550 00001C99 66B806000000             mov eax, 6
  2551 00001C9F E9D701                   jmp @@retn
  2552                                  
  2553                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  2554                                  
  2555                                  @@testReg94:
  2556 00001CA2 68[A71E]                 push testReg_15
  2557 00001CA5 8D06[3800]               lea  ax, [SymbolUpper]
  2558 00001CA9 50                       push ax
  2559 00001CAA E8E812                   call eqstr
  2560 00001CAD 83C404                   add  sp, 4
  2561 00001CB0 08C0                     or  al, al
  2562 00001CB2 0F840900                 je @@testReg95
  2563 00001CB6 66B807000000             mov eax, 7
  2564 00001CBC E9BA01                   jmp @@retn
  2565                                  
  2566                                  ;-98   RegType=SEGREG;
  2567                                  
  2568                                  @@testReg95:
  2569 00001CBF 66B804000000             mov eax, 4
  2570 00001CC5 A2[BE01]                 mov byte [RegType], al
  2571                                  
  2572                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  2573                                  
  2574 00001CC8 68[AA1E]                 push testReg_16
  2575 00001CCB 8D06[3800]               lea  ax, [SymbolUpper]
  2576 00001CCF 50                       push ax
  2577 00001CD0 E8C212                   call eqstr
  2578 00001CD3 83C404                   add  sp, 4
  2579 00001CD6 08C0                     or  al, al
  2580 00001CD8 0F840900                 je @@testReg96
  2581 00001CDC 66B800000000             mov eax, 0
  2582 00001CE2 E99401                   jmp @@retn
  2583                                  
  2584                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  2585                                  
  2586                                  @@testReg96:
  2587 00001CE5 68[AD1E]                 push testReg_17
  2588 00001CE8 8D06[3800]               lea  ax, [SymbolUpper]
  2589 00001CEC 50                       push ax
  2590 00001CED E8A512                   call eqstr
  2591 00001CF0 83C404                   add  sp, 4
  2592 00001CF3 08C0                     or  al, al
  2593 00001CF5 0F840900                 je @@testReg97
  2594 00001CF9 66B801000000             mov eax, 1
  2595 00001CFF E97701                   jmp @@retn
  2596                                  
  2597                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  2598                                  
  2599                                  @@testReg97:
  2600 00001D02 68[B01E]                 push testReg_18
  2601 00001D05 8D06[3800]               lea  ax, [SymbolUpper]
  2602 00001D09 50                       push ax
  2603 00001D0A E88812                   call eqstr
  2604 00001D0D 83C404                   add  sp, 4
  2605 00001D10 08C0                     or  al, al
  2606 00001D12 0F840900                 je @@testReg98
  2607 00001D16 66B802000000             mov eax, 2
  2608 00001D1C E95A01                   jmp @@retn
  2609                                  
  2610                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  2611                                  
  2612                                  @@testReg98:
  2613 00001D1F 68[B31E]                 push testReg_19
  2614 00001D22 8D06[3800]               lea  ax, [SymbolUpper]
  2615 00001D26 50                       push ax
  2616 00001D27 E86B12                   call eqstr
  2617 00001D2A 83C404                   add  sp, 4
  2618 00001D2D 08C0                     or  al, al
  2619 00001D2F 0F840900                 je @@testReg99
  2620 00001D33 66B803000000             mov eax, 3
  2621 00001D39 E93D01                   jmp @@retn
  2622                                  
  2623                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  2624                                  
  2625                                  @@testReg99:
  2626 00001D3C 68[B61E]                 push testReg_20
  2627 00001D3F 8D06[3800]               lea  ax, [SymbolUpper]
  2628 00001D43 50                       push ax
  2629 00001D44 E84E12                   call eqstr
  2630 00001D47 83C404                   add  sp, 4
  2631 00001D4A 08C0                     or  al, al
  2632 00001D4C 0F840900                 je @@testReg100
  2633 00001D50 66B804000000             mov eax, 4
  2634 00001D56 E92001                   jmp @@retn
  2635                                  
  2636                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  2637                                  
  2638                                  @@testReg100:
  2639 00001D59 68[B91E]                 push testReg_21
  2640 00001D5C 8D06[3800]               lea  ax, [SymbolUpper]
  2641 00001D60 50                       push ax
  2642 00001D61 E83112                   call eqstr
  2643 00001D64 83C404                   add  sp, 4
  2644 00001D67 08C0                     or  al, al
  2645 00001D69 0F840900                 je @@testReg101
  2646 00001D6D 66B805000000             mov eax, 5
  2647 00001D73 E90301                   jmp @@retn
  2648                                  
  2649                                  ;-105   RegType=DWORD;
  2650                                  
  2651                                  @@testReg101:
  2652 00001D76 66B803000000             mov eax, 3
  2653 00001D7C A2[BE01]                 mov byte [RegType], al
  2654                                  
  2655                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  2656                                  
  2657 00001D7F 68[BC1E]                 push testReg_22
  2658 00001D82 8D06[3800]               lea  ax, [SymbolUpper]
  2659 00001D86 50                       push ax
  2660 00001D87 E80B12                   call eqstr
  2661 00001D8A 83C404                   add  sp, 4
  2662 00001D8D 08C0                     or  al, al
  2663 00001D8F 0F840900                 je @@testReg102
  2664 00001D93 66B800000000             mov eax, 0
  2665 00001D99 E9DD00                   jmp @@retn
  2666                                  
  2667                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  2668                                  
  2669                                  @@testReg102:
  2670 00001D9C 68[C01E]                 push testReg_23
  2671 00001D9F 8D06[3800]               lea  ax, [SymbolUpper]
  2672 00001DA3 50                       push ax
  2673 00001DA4 E8EE11                   call eqstr
  2674 00001DA7 83C404                   add  sp, 4
  2675 00001DAA 08C0                     or  al, al
  2676 00001DAC 0F840900                 je @@testReg103
  2677 00001DB0 66B801000000             mov eax, 1
  2678 00001DB6 E9C000                   jmp @@retn
  2679                                  
  2680                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  2681                                  
  2682                                  @@testReg103:
  2683 00001DB9 68[C41E]                 push testReg_24
  2684 00001DBC 8D06[3800]               lea  ax, [SymbolUpper]
  2685 00001DC0 50                       push ax
  2686 00001DC1 E8D111                   call eqstr
  2687 00001DC4 83C404                   add  sp, 4
  2688 00001DC7 08C0                     or  al, al
  2689 00001DC9 0F840900                 je @@testReg104
  2690 00001DCD 66B802000000             mov eax, 2
  2691 00001DD3 E9A300                   jmp @@retn
  2692                                  
  2693                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  2694                                  
  2695                                  @@testReg104:
  2696 00001DD6 68[C81E]                 push testReg_25
  2697 00001DD9 8D06[3800]               lea  ax, [SymbolUpper]
  2698 00001DDD 50                       push ax
  2699 00001DDE E8B411                   call eqstr
  2700 00001DE1 83C404                   add  sp, 4
  2701 00001DE4 08C0                     or  al, al
  2702 00001DE6 0F840900                 je @@testReg105
  2703 00001DEA 66B803000000             mov eax, 3
  2704 00001DF0 E98600                   jmp @@retn
  2705                                  
  2706                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  2707                                  
  2708                                  @@testReg105:
  2709 00001DF3 68[CC1E]                 push testReg_26
  2710 00001DF6 8D06[3800]               lea  ax, [SymbolUpper]
  2711 00001DFA 50                       push ax
  2712 00001DFB E89711                   call eqstr
  2713 00001DFE 83C404                   add  sp, 4
  2714 00001E01 08C0                     or  al, al
  2715 00001E03 0F840900                 je @@testReg106
  2716 00001E07 66B804000000             mov eax, 4
  2717 00001E0D E96900                   jmp @@retn
  2718                                  
  2719                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  2720                                  
  2721                                  @@testReg106:
  2722 00001E10 68[D01E]                 push testReg_27
  2723 00001E13 8D06[3800]               lea  ax, [SymbolUpper]
  2724 00001E17 50                       push ax
  2725 00001E18 E87A11                   call eqstr
  2726 00001E1B 83C404                   add  sp, 4
  2727 00001E1E 08C0                     or  al, al
  2728 00001E20 0F840900                 je @@testReg107
  2729 00001E24 66B805000000             mov eax, 5
  2730 00001E2A E94C00                   jmp @@retn
  2731                                  
  2732                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  2733                                  
  2734                                  @@testReg107:
  2735 00001E2D 68[D41E]                 push testReg_28
  2736 00001E30 8D06[3800]               lea  ax, [SymbolUpper]
  2737 00001E34 50                       push ax
  2738 00001E35 E85D11                   call eqstr
  2739 00001E38 83C404                   add  sp, 4
  2740 00001E3B 08C0                     or  al, al
  2741 00001E3D 0F840900                 je @@testReg108
  2742 00001E41 66B806000000             mov eax, 6
  2743 00001E47 E92F00                   jmp @@retn
  2744                                  
  2745                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  2746                                  
  2747                                  @@testReg108:
  2748 00001E4A 68[D81E]                 push testReg_29
  2749 00001E4D 8D06[3800]               lea  ax, [SymbolUpper]
  2750 00001E51 50                       push ax
  2751 00001E52 E84011                   call eqstr
  2752 00001E55 83C404                   add  sp, 4
  2753 00001E58 08C0                     or  al, al
  2754 00001E5A 0F840900                 je @@testReg109
  2755 00001E5E 66B807000000             mov eax, 7
  2756 00001E64 E91200                   jmp @@retn
  2757                                  
  2758                                  ;-114   RegType=0; return 0;
  2759                                  
  2760                                  @@testReg109:
  2761 00001E67 66B800000000             mov eax, 0
  2762 00001E6D A2[BE01]                 mov byte [RegType], al
  2763 00001E70 66B800000000             mov eax, 0
  2764 00001E76 E90000                   jmp @@retn
  2765                                  
  2766                                  ;-115 }
  2767                                  
  2768                                  @@retn:
  2769 00001E79 C3                       ret
  2770                                  ; ENDP
  2771 00001E7A 414C00                  testReg_0 db "AL",0
  2772 00001E7D 434C00                  testReg_1 db "CL",0
  2773 00001E80 444C00                  testReg_2 db "DL",0
  2774 00001E83 424C00                  testReg_3 db "BL",0
  2775 00001E86 414800                  testReg_4 db "AH",0
  2776 00001E89 434800                  testReg_5 db "CH",0
  2777 00001E8C 444800                  testReg_6 db "DH",0
  2778 00001E8F 424800                  testReg_7 db "BH",0
  2779 00001E92 415800                  testReg_8 db "AX",0
  2780 00001E95 435800                  testReg_9 db "CX",0
  2781 00001E98 445800                  testReg_10 db "DX",0
  2782 00001E9B 425800                  testReg_11 db "BX",0
  2783 00001E9E 535000                  testReg_12 db "SP",0
  2784 00001EA1 425000                  testReg_13 db "BP",0
  2785 00001EA4 534900                  testReg_14 db "SI",0
  2786 00001EA7 444900                  testReg_15 db "DI",0
  2787 00001EAA 455300                  testReg_16 db "ES",0
  2788 00001EAD 435300                  testReg_17 db "CS",0
  2789 00001EB0 535300                  testReg_18 db "SS",0
  2790 00001EB3 445300                  testReg_19 db "DS",0
  2791 00001EB6 465300                  testReg_20 db "FS",0
  2792 00001EB9 475300                  testReg_21 db "GS",0
  2793 00001EBC 45415800                testReg_22 db "EAX",0
  2794 00001EC0 45435800                testReg_23 db "ECX",0
  2795 00001EC4 45445800                testReg_24 db "EDX",0
  2796 00001EC8 45425800                testReg_25 db "EBX",0
  2797 00001ECC 45535000                testReg_26 db "ESP",0
  2798 00001ED0 45425000                testReg_27 db "EBP",0
  2799 00001ED4 45534900                testReg_28 db "ESI",0
  2800 00001ED8 45444900                testReg_29 db "EDI",0
  2801                                  ;Back to main program: AS.C
  2802                                  
  2803                                  ;-7 #include "OUTPUT.C"
  2804                                  
  2805                                  ;Use include file: OUTPUT.C
  2806                                  
  2807                                  ;-1 int printLine() { int i; char c;
  2808                                  
  2809                                  
  2810                                  printLine:  ; *** PROC ***
  2811                                  
  2812                                  ;-2   prs("\n"); printhex16(PCStart);
  2813                                  
  2814                                  ;Function : printLine, Number of local variables: 2
  2815                                  ;   # type sign width line used address name   list of local variables
  2816                                  ;  200 var sign word     1 NULL bp-2    i
  2817                                  ;  201 var sign byte     1 NULL bp-4    c;
  2818 00001EDC C8040000                 ENTER  4,0
  2819 00001EE0 68[711F]                 push printLine_0
  2820 00001EE3 E80401                   call prs
  2821 00001EE6 83C402                   add  sp, 2
  2822 00001EE9 FF36[B201]               push word [PCStart]
  2823 00001EED E8EB01                   call printhex16
  2824 00001EF0 83C402                   add  sp, 2
  2825                                  
  2826                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  2827                                  
  2828 00001EF3 A1[CD01]                 mov ax, [OpPrintIndex]
  2829 00001EF6 83F800                   cmp ax, 0
  2830 00001EF9 0F850C00                 jne @@printLine110
  2831 00001EFD 68[741F]                 push printLine_1
  2832 00001F00 E8E700                   call prs
  2833 00001F03 83C402                   add  sp, 2
  2834                                  
  2835                                  ;-4   else {
  2836                                  
  2837 00001F06 E95B00                   jmp @@printLine111
  2838                                  @@printLine110:
  2839                                  
  2840                                  ;-5     prc(PrintR);
  2841                                  
  2842 00001F09 A0[D101]                 mov al, byte [PrintR]
  2843 00001F0C B400                     mov ah, 0
  2844 00001F0E 50                       push ax
  2845 00001F0F E87700                   call prc
  2846 00001F12 83C402                   add  sp, 2
  2847                                  
  2848                                  ;-6     i=0;
  2849                                  
  2850 00001F15 66B800000000             mov eax, 0
  2851 00001F1B 8946FE                   mov word [bp-2], ax
  2852                                  
  2853                                  ;-7     do {
  2854                                  
  2855                                  @@printLine112:
  2856                                  
  2857                                  ;-8       c=OpPos[i];
  2858                                  
  2859 00001F1E 8B5EFE                   mov bx, [bp-2]
  2860 00001F21 8A87[C801]               mov al, [OpPos + bx]
  2861 00001F25 8846FC                   mov byte [bp-4], al
  2862                                  
  2863                                  ;-9       printhex8a(c); prc(' ');
  2864                                  
  2865 00001F28 8A46FC                   mov al, byte [bp-4]
  2866 00001F2B B400                     mov ah, 0
  2867 00001F2D 50                       push ax
  2868 00001F2E E85C01                   call printhex8a
  2869 00001F31 83C402                   add  sp, 2
  2870 00001F34 6A20                     push 32
  2871 00001F36 E85000                   call prc
  2872 00001F39 83C402                   add  sp, 2
  2873                                  
  2874                                  ;-10       i++;
  2875                                  
  2876 00001F3C FF46FE                   inc  word [bp-2]
  2877                                  
  2878                                  ;-11     } while(i < OpPrintIndex);
  2879                                  
  2880 00001F3F 8B46FE                   mov ax, [bp-2]
  2881 00001F42 3B06[CD01]               cmp ax, [OpPrintIndex]
  2882 00001F46 0F8D0200                 jge @@printLine113
  2883 00001F4A EBD2                     jmp @@printLine112
  2884                                  @@printLine113:
  2885                                  
  2886                                  ;-12     do {// fill rest with blank
  2887                                  
  2888                                  @@printLine114:
  2889                                  
  2890                                  ;-13       prs("   ");
  2891                                  
  2892 00001F4C 68[851F]                 push printLine_2
  2893 00001F4F E89800                   call prs
  2894 00001F52 83C402                   add  sp, 2
  2895                                  
  2896                                  ;-14       i++;
  2897                                  
  2898 00001F55 FF46FE                   inc  word [bp-2]
  2899                                  
  2900                                  ;-15     } while(i < OPMAXLEN);
  2901                                  
  2902 00001F58 8B46FE                   mov ax, [bp-2]
  2903 00001F5B 83F805                   cmp ax, 5
  2904 00001F5E 0F8D0200                 jge @@printLine115
  2905 00001F62 EBE8                     jmp @@printLine114
  2906                                  @@printLine115:
  2907                                  
  2908                                  ;-16   }
  2909                                  
  2910                                  
  2911                                  ;-17   prscomment(InputBuf);
  2912                                  
  2913                                  @@printLine111:
  2914 00001F64 8D06[5900]               lea  ax, [InputBuf]
  2915 00001F68 50                       push ax
  2916 00001F69 E85000                   call prscomment
  2917 00001F6C 83C402                   add  sp, 2
  2918                                  
  2919                                  ;-18 }
  2920                                  
  2921                                  
  2922                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  2923 00001F6F C9                       LEAVE
  2924 00001F70 C3                       ret
  2925                                  ; ENDP
  2926 00001F71 5C6E00                  printLine_0 db "\n",0
  2927 00001F74 202020202020202020-     printLine_1 db "                ",0
  2928 00001F7D 2020202020202000   
  2929 00001F85 20202000                printLine_2 db "   ",0
  2930                                  
  2931                                  prc:  ; *** PROC ***
  2932                                  ;Function : prc, Number of local variables: 1
  2933                                  ;   # type sign width line used address name   list of local variables
  2934                                  ;  200 var unsg byte    19 NULL bp+4    c;
  2935 00001F89 C8000000                 ENTER  0,0
  2936 00001F8D A0[1800]                 mov al, [LIST]
  2937 00001F90 08C0                     or  al, al
  2938 00001F92 0F841400                 je @@prc116
  2939 00001F96 807E040A                cmp byte [bp+4], 10
  2940 00001F9A 0F850600                 jne @@prc117
  2941 00001F9E B80D00                   mov  ax, 13
  2942 00001FA1 E8E10E                   call writetty
  2943                                  
  2944                                  ;-20      al=c; writetty(); }
  2945                                  
  2946                                  @@prc117:
  2947 00001FA4 8A4604                   mov  al, [bp+4]
  2948 00001FA7 E8DB0E                   call writetty
  2949                                  
  2950                                  ;-21    fputcR(c,lst_fd); }
  2951                                  
  2952                                  @@prc116:
  2953 00001FAA FF36[A501]               push word [lst_fd]
  2954 00001FAE 8A4604                   mov al, byte [bp+4]
  2955 00001FB1 B400                     mov ah, 0
  2956 00001FB3 50                       push ax
  2957 00001FB4 E88E10                   call fputcR
  2958 00001FB7 83C404                   add  sp, 4
  2959                                  
  2960                                  ;-22 
  2961                                  
  2962                                  
  2963                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  2964 00001FBA C9                       LEAVE
  2965 00001FBB C3                       ret
  2966                                  ; ENDP
  2967                                  
  2968                                  prscomment:  ; *** PROC ***
  2969                                  
  2970                                  ;-24   while(*s){c=*s;prc(c);s++;}
  2971                                  
  2972                                  ;Function : prscomment, Number of local variables: 2
  2973                                  ;   # type sign width line used address name   list of local variables
  2974                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  2975                                  ;  201 var unsg byte    23 NULL bp-2    c;
  2976 00001FBC C8020000                 ENTER  2,0
  2977                                  @@prscomment118:
  2978 00001FC0 8B5E04                   mov bx, [bp+4]
  2979 00001FC3 8A07                     mov al, [bx]
  2980 00001FC5 B400                     mov ah, 0
  2981 00001FC7 08C0                     or  al, al
  2982 00001FC9 0F841B00                 je @@prscomment119
  2983 00001FCD 8B5E04                   mov bx, [bp+4]
  2984 00001FD0 8A07                     mov al, [bx]
  2985 00001FD2 B400                     mov ah, 0
  2986 00001FD4 8846FE                   mov byte [bp-2], al
  2987 00001FD7 8A46FE                   mov al, byte [bp-2]
  2988 00001FDA B400                     mov ah, 0
  2989 00001FDC 50                       push ax
  2990 00001FDD E8A9FF                   call prc
  2991 00001FE0 83C402                   add  sp, 2
  2992 00001FE3 FF4604                   inc  word [bp+4]
  2993                                  
  2994                                  ;-25 }
  2995                                  
  2996 00001FE6 EBD8                     jmp @@prscomment118
  2997                                  @@prscomment119:
  2998                                  
  2999                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  3000 00001FE8 C9                       LEAVE
  3001 00001FE9 C3                       ret
  3002                                  ; ENDP
  3003                                  
  3004                                  prs:  ; *** PROC ***
  3005                                  ;Function : prs, Number of local variables: 3
  3006                                  ;   # type sign width line used address name   list of local variables
  3007                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3008                                  ;  201 var unsg byte    26 NULL bp-2    c
  3009                                  ;  202 var sign word    26 NULL bp-4    com;
  3010 00001FEA C8040000                 ENTER  4,0
  3011 00001FEE 66B800000000             mov eax, 0
  3012 00001FF4 8946FC                   mov word [bp-4], ax
  3013                                  
  3014                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3015                                  
  3016                                  @@prs120:
  3017 00001FF7 8B5E04                   mov bx, [bp+4]
  3018 00001FFA 8A07                     mov al, [bx]
  3019 00001FFC B400                     mov ah, 0
  3020 00001FFE 08C0                     or  al, al
  3021 00002000 0F848700                 je @@prs121
  3022 00002004 8B5E04                   mov bx, [bp+4]
  3023 00002007 8A07                     mov al, [bx]
  3024 00002009 B400                     mov ah, 0
  3025 0000200B 8846FE                   mov byte [bp-2], al
  3026 0000200E 8A46FE                   mov al, [bp-2]
  3027 00002011 3C22                     cmp al, 34
  3028 00002013 0F851E00                 jne @@prs122
  3029 00002017 8B46FC                   mov ax, [bp-4]
  3030 0000201A 08C0                     or  al, al
  3031 0000201C 0F840C00                 je @@prs123
  3032 00002020 66B800000000             mov eax, 0
  3033 00002026 8946FC                   mov word [bp-4], ax
  3034 00002029 E90900                   jmp @@prs124
  3035                                  @@prs123:
  3036 0000202C 66B801000000             mov eax, 1
  3037 00002032 8946FC                   mov word [bp-4], ax
  3038                                  
  3039                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3040                                  
  3041                                  @@prs124:
  3042                                  @@prs122:
  3043 00002035 8A46FE                   mov al, [bp-2]
  3044 00002038 3C5C                     cmp al, 92
  3045 0000203A 0F853B00                 jne @@prs125
  3046 0000203E 8B46FC                   mov ax, [bp-4]
  3047 00002041 83F800                   cmp ax, 0
  3048 00002044 0F853100                 jne @@prs126
  3049 00002048 FF4604                   inc  word [bp+4]
  3050 0000204B 8B5E04                   mov bx, [bp+4]
  3051 0000204E 8A07                     mov al, [bx]
  3052 00002050 B400                     mov ah, 0
  3053 00002052 8846FE                   mov byte [bp-2], al
  3054                                  
  3055                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3056                                  
  3057 00002055 8A46FE                   mov al, [bp-2]
  3058 00002058 3C6E                     cmp al, 110
  3059 0000205A 0F850900                 jne @@prs127
  3060 0000205E 66B80A000000             mov eax, 10
  3061 00002064 8846FE                   mov byte [bp-2], al
  3062                                  @@prs127:
  3063 00002067 8A46FE                   mov al, [bp-2]
  3064 0000206A 3C74                     cmp al, 116
  3065 0000206C 0F850900                 jne @@prs128
  3066 00002070 66B809000000             mov eax, 9
  3067 00002076 8846FE                   mov byte [bp-2], al
  3068                                  @@prs128:
  3069                                  @@prs126:
  3070                                  @@prs125:
  3071 00002079 8A46FE                   mov al, byte [bp-2]
  3072 0000207C B400                     mov ah, 0
  3073 0000207E 50                       push ax
  3074 0000207F E807FF                   call prc
  3075 00002082 83C402                   add  sp, 2
  3076 00002085 FF4604                   inc  word [bp+4]
  3077                                  
  3078                                  ;-30 }
  3079                                  
  3080 00002088 E96CFF                   jmp @@prs120
  3081                                  @@prs121:
  3082                                  
  3083                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  3084 0000208B C9                       LEAVE
  3085 0000208C C3                       ret
  3086                                  ; ENDP
  3087                                  
  3088                                  printhex8a:  ; *** PROC ***
  3089                                  
  3090                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3091                                  
  3092                                  ;Function : printhex8a, Number of local variables: 2
  3093                                  ;   # type sign width line used address name   list of local variables
  3094                                  ;  200 var unsg word    31 NULL bp+4    c
  3095                                  ;  201 var unsg word    31 NULL bp-2    nib;
  3096 0000208D C8020000                 ENTER  2,0
  3097 00002091 8B4604                   mov ax, [bp+4]
  3098 00002094 C1E804                   shr ax, 4
  3099 00002097 8946FE                   mov word [bp-2], ax
  3100 0000209A 8346FE30                 add  word [bp-2], 48
  3101 0000209E 8B46FE                   mov ax, [bp-2]
  3102 000020A1 83F839                   cmp ax, 57
  3103 000020A4 0F8E0400                 jle @@printhex8a129
  3104 000020A8 8346FE07                 add  word [bp-2], 7
  3105                                  @@printhex8a129:
  3106 000020AC FF76FE                   push word [bp-2]
  3107 000020AF E8D7FE                   call prc
  3108 000020B2 83C402                   add  sp, 2
  3109                                  
  3110                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3111                                  
  3112 000020B5 8B4604                   mov ax, [bp+4]
  3113 000020B8 83E00F                   and ax, 15
  3114 000020BB 8946FE                   mov word [bp-2], ax
  3115 000020BE 8346FE30                 add  word [bp-2], 48
  3116 000020C2 8B46FE                   mov ax, [bp-2]
  3117 000020C5 83F839                   cmp ax, 57
  3118 000020C8 0F8E0400                 jle @@printhex8a130
  3119 000020CC 8346FE07                 add  word [bp-2], 7
  3120                                  @@printhex8a130:
  3121 000020D0 FF76FE                   push word [bp-2]
  3122 000020D3 E8B3FE                   call prc
  3123 000020D6 83C402                   add  sp, 2
  3124                                  
  3125                                  ;-34 }
  3126                                  
  3127                                  
  3128                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  3129 000020D9 C9                       LEAVE
  3130 000020DA C3                       ret
  3131                                  ; ENDP
  3132                                  
  3133                                  printhex16:  ; *** PROC ***
  3134                                  
  3135                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3136                                  
  3137                                  ;Function : printhex16, Number of local variables: 2
  3138                                  ;   # type sign width line used address name   list of local variables
  3139                                  ;  200 var unsg word    35 NULL bp+4    i
  3140                                  ;  201 var unsg word    35 NULL bp-2    half;
  3141 000020DB C8020000                 ENTER  2,0
  3142 000020DF 8B4604                   mov ax, [bp+4]
  3143 000020E2 C1E808                   shr ax, 8
  3144 000020E5 8946FE                   mov word [bp-2], ax
  3145 000020E8 FF76FE                   push word [bp-2]
  3146 000020EB E89FFF                   call printhex8a
  3147 000020EE 83C402                   add  sp, 2
  3148 000020F1 8B4604                   mov ax, [bp+4]
  3149 000020F4 25FF00                   and ax, 255
  3150 000020F7 8946FE                   mov word [bp-2], ax
  3151 000020FA FF76FE                   push word [bp-2]
  3152 000020FD E88DFF                   call printhex8a
  3153 00002100 83C402                   add  sp, 2
  3154                                  
  3155                                  ;-37 }
  3156                                  
  3157                                  
  3158                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  3159 00002103 C9                       LEAVE
  3160 00002104 C3                       ret
  3161                                  ; ENDP
  3162                                  
  3163                                  printIntU:  ; *** PROC ***
  3164                                  
  3165                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  3166                                  
  3167                                  ;Function : printIntU, Number of local variables: 2
  3168                                  ;   # type sign width line used address name   list of local variables
  3169                                  ;  200 var unsg word    38 NULL bp+4    n
  3170                                  ;  201 var unsg word    38 NULL bp-2    e;
  3171 00002105 C8020000                 ENTER  2,0
  3172 00002109 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3173 0000210D 0F821700                 jb  @@printIntU131
  3174 00002111 8B4604                   mov ax, [bp+4]
  3175 00002114 BB0A00                   mov bx, 10
  3176 00002117 BA0000                   mov dx, 0
  3177 0000211A F7F3                     div bx
  3178 0000211C 8946FE                   mov word [bp-2], ax
  3179                                  
  3180                                  ;-40     printIntU(e); }
  3181                                  
  3182 0000211F FF76FE                   push word [bp-2]
  3183 00002122 E8E0FF                   call printIntU
  3184 00002125 83C402                   add  sp, 2
  3185                                  
  3186                                  ;-41     n = n % 10; //unsigned mod
  3187                                  
  3188                                  @@printIntU131:
  3189 00002128 8B4604                   mov ax, [bp+4]
  3190 0000212B BB0A00                   mov bx, 10
  3191 0000212E BA0000                   mov dx, 0
  3192 00002131 F7F3                     div bx
  3193 00002133 89D0                     mov ax, dx
  3194 00002135 894604                   mov word [bp+4], ax
  3195                                  
  3196                                  ;-42     n += '0'; prc(n);
  3197                                  
  3198 00002138 83460430                 add  word [bp+4], 48
  3199 0000213C FF7604                   push word [bp+4]
  3200 0000213F E847FE                   call prc
  3201 00002142 83C402                   add  sp, 2
  3202                                  
  3203                                  ;-43 }
  3204                                  
  3205                                  
  3206                                  ;-44 
  3207                                  
  3208                                  
  3209                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  3210 00002145 C9                       LEAVE
  3211 00002146 C3                       ret
  3212                                  ; ENDP
  3213                                  
  3214                                  error1:  ; *** PROC ***
  3215                                  ;Function : error1, Number of local variables: 1
  3216                                  ;   # type sign width line used address name   list of local variables
  3217                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  3218 00002147 C8000000                 ENTER  0,0
  3219 0000214B 66B801000000             mov eax, 1
  3220 00002151 A2[1800]                 mov byte [LIST], al
  3221 00002154 FF06[AB01]               inc  word [ErrorCount]
  3222                                  
  3223                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  3224                                  
  3225 00002158 68[8021]                 push error1_0
  3226 0000215B E88CFE                   call prs
  3227 0000215E 83C402                   add  sp, 2
  3228 00002161 FF7604                   push word [bp+4]
  3229 00002164 E883FE                   call prs
  3230 00002167 83C402                   add  sp, 2
  3231                                  
  3232                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  3233                                  
  3234 0000216A 68[9B21]                 push error1_1
  3235 0000216D E87AFE                   call prs
  3236 00002170 83C402                   add  sp, 2
  3237 00002173 8D06[1900]               lea  ax, [Symbol]
  3238 00002177 50                       push ax
  3239 00002178 E86FFE                   call prs
  3240 0000217B 83C402                   add  sp, 2
  3241                                  
  3242                                  ;-48 int allowederror(){error1("not allowed here"); }
  3243 0000217E C9                       LEAVE
  3244 0000217F C3                       ret
  3245                                  ; ENDP
  3246 00002180 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3247 00002189 6E657874206C696E65-
  3248 00002192 204552524F523A2000 
  3249 0000219B 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3250 000021A4 2000               
  3251                                  
  3252                                  allowederror:  ; *** PROC ***
  3253 000021A6 68[B021]                 push allowederror_0
  3254 000021A9 E89BFF                   call error1
  3255 000021AC 83C402                   add  sp, 2
  3256                                  
  3257                                  ;-49 int addrerror()   {error1("address expected");} 
  3258                                  
  3259 000021AF C3                       ret
  3260                                  ; ENDP
  3261 000021B0 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3262 000021B9 6564206865726500   
  3263                                  
  3264                                  addrerror:  ; *** PROC ***
  3265 000021C1 68[CB21]                 push addrerror_0
  3266 000021C4 E880FF                   call error1
  3267 000021C7 83C402                   add  sp, 2
  3268                                  
  3269                                  ;-50 int immeerror()   {error1("immediate not allowed here");}
  3270                                  
  3271 000021CA C3                       ret
  3272                                  ; ENDP
  3273 000021CB 616464726573732065-     addrerror_0 db "address expected",0
  3274 000021D4 7870656374656400   
  3275                                  
  3276                                  immeerror:  ; *** PROC ***
  3277 000021DC 68[E621]                 push immeerror_0
  3278 000021DF E865FF                   call error1
  3279 000021E2 83C402                   add  sp, 2
  3280                                  
  3281                                  ;-51 int implerror()   {error1("not implemented");}
  3282                                  
  3283 000021E5 C3                       ret
  3284                                  ; ENDP
  3285 000021E6 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  3286 000021EF 206E6F7420616C6C6F-
  3287 000021F8 776564206865726500 
  3288                                  
  3289                                  implerror:  ; *** PROC ***
  3290 00002201 68[0B22]                 push implerror_0
  3291 00002204 E840FF                   call error1
  3292 00002207 83C402                   add  sp, 2
  3293                                  
  3294                                  ;-52 int indexerror()  {error1("invalid index register");}
  3295                                  
  3296 0000220A C3                       ret
  3297                                  ; ENDP
  3298 0000220B 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3299 00002214 6D656E74656400     
  3300                                  
  3301                                  indexerror:  ; *** PROC ***
  3302 0000221B 68[2522]                 push indexerror_0
  3303 0000221E E826FF                   call error1
  3304 00002221 83C402                   add  sp, 2
  3305                                  
  3306                                  ;-53 int invaloperror(){error1("invalid or no operands");}
  3307                                  
  3308 00002224 C3                       ret
  3309                                  ; ENDP
  3310 00002225 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3311 0000222E 6E6465782072656769-
  3312 00002237 7374657200         
  3313                                  
  3314                                  invaloperror:  ; *** PROC ***
  3315 0000223C 68[4622]                 push invaloperror_0
  3316 0000223F E805FF                   call error1
  3317 00002242 83C402                   add  sp, 2
  3318                                  
  3319                                  ;-54 int numbererror() {error1("number expected");}
  3320                                  
  3321 00002245 C3                       ret
  3322                                  ; ENDP
  3323 00002246 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3324 0000224F 72206E6F206F706572-
  3325 00002258 616E647300         
  3326                                  
  3327                                  numbererror:  ; *** PROC ***
  3328 0000225D 68[6722]                 push numbererror_0
  3329 00002260 E8E4FE                   call error1
  3330 00002263 83C402                   add  sp, 2
  3331                                  
  3332                                  ;-55 int regmemerror() {error1("only register or memory allowed");}
  3333                                  
  3334 00002266 C3                       ret
  3335                                  ; ENDP
  3336 00002267 6E756D626572206578-     numbererror_0 db "number expected",0
  3337 00002270 70656374656400     
  3338                                  
  3339                                  regmemerror:  ; *** PROC ***
  3340 00002277 68[8122]                 push regmemerror_0
  3341 0000227A E8CAFE                   call error1
  3342 0000227D 83C402                   add  sp, 2
  3343                                  
  3344                                  ;-56 int reg16error()  {error1("only reg16, no segreg allowed");}
  3345                                  
  3346 00002280 C3                       ret
  3347                                  ; ENDP
  3348 00002281 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3349 0000228A 73746572206F72206D-
  3350 00002293 656D6F727920616C6C-
  3351 0000229C 6F77656400         
  3352                                  
  3353                                  reg16error:  ; *** PROC ***
  3354 000022A1 68[AB22]                 push reg16error_0
  3355 000022A4 E8A0FE                   call error1
  3356 000022A7 83C402                   add  sp, 2
  3357                                  
  3358                                  ;-57 int segregerror() {error1("segment register not allowed");}
  3359                                  
  3360 000022AA C3                       ret
  3361                                  ; ENDP
  3362 000022AB 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3363 000022B4 362C206E6F20736567-
  3364 000022BD 72656720616C6C6F77-
  3365 000022C6 656400             
  3366                                  
  3367                                  segregerror:  ; *** PROC ***
  3368 000022C9 68[D322]                 push segregerror_0
  3369 000022CC E878FE                   call error1
  3370 000022CF 83C402                   add  sp, 2
  3371                                  
  3372                                  ;-58 int syntaxerror() {error1("syntax");}
  3373                                  
  3374 000022D2 C3                       ret
  3375                                  ; ENDP
  3376 000022D3 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3377 000022DC 65676973746572206E-
  3378 000022E5 6F7420616C6C6F7765-
  3379 000022EE 6400               
  3380                                  
  3381                                  syntaxerror:  ; *** PROC ***
  3382 000022F0 68[FA22]                 push syntaxerror_0
  3383 000022F3 E851FE                   call error1
  3384 000022F6 83C402                   add  sp, 2
  3385                                  
  3386                                  ;-59 
  3387                                  
  3388                                  
  3389                                  ;-60 int errorexit(char *s) { error1(s); end1(1);}
  3390                                  
  3391 000022F9 C3                       ret
  3392                                  ; ENDP
  3393 000022FA 73796E74617800          syntaxerror_0 db "syntax",0
  3394                                  
  3395                                  errorexit:  ; *** PROC ***
  3396                                  ;Function : errorexit, Number of local variables: 1
  3397                                  ;   # type sign width line used address name   list of local variables
  3398                                  ;  200 ptr sign byte    60 NULL bp+4    s;
  3399 00002301 C8000000                 ENTER  0,0
  3400 00002305 FF7604                   push word [bp+4]
  3401 00002308 E83CFE                   call error1
  3402 0000230B 83C402                   add  sp, 2
  3403 0000230E 6A01                     push 1
  3404 00002310 E85003                   call end1
  3405 00002313 83C402                   add  sp, 2
  3406                                  
  3407                                  ;-61 int addrexit(){errorexit("illegal address");}
  3408 00002316 C9                       LEAVE
  3409 00002317 C3                       ret
  3410                                  ; ENDP
  3411                                  
  3412                                  addrexit:  ; *** PROC ***
  3413 00002318 68[2223]                 push addrexit_0
  3414 0000231B E8E3FF                   call errorexit
  3415 0000231E 83C402                   add  sp, 2
  3416                                  
  3417                                  ;-62 int internexit(){errorexit("intern compiler error");}
  3418                                  
  3419 00002321 C3                       ret
  3420                                  ; ENDP
  3421 00002322 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3422 0000232B 64647265737300     
  3423                                  
  3424                                  internexit:  ; *** PROC ***
  3425 00002332 68[3C23]                 push internexit_0
  3426 00002335 E8C9FF                   call errorexit
  3427 00002338 83C402                   add  sp, 2
  3428 0000233B C3                       ret
  3429                                  ; ENDP
  3430 0000233C 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3431 00002345 6D70696C6572206572-
  3432 0000234E 726F7200           
  3433                                  ;Back to main program: AS.C
  3434                                  
  3435                                  ;-8 #include "MAIN.C"
  3436                                  
  3437                                  ;Use include file: MAIN.C
  3438                                  
  3439                                  ;-1 int main() {
  3440                                  
  3441                                  
  3442                                  main:  ; *** PROC ***
  3443                                  
  3444                                  ;-2   getarg(); 
  3445                                  
  3446 00002352 E80A00                   call getarg
  3447                                  
  3448                                  ;-3   parse(); 
  3449                                  
  3450 00002355 E8DEEE                   call parse
  3451                                  
  3452                                  ;-4   epilog(); 
  3453                                  
  3454 00002358 E85C02                   call epilog
  3455                                  
  3456                                  ;-5   end1();
  3457                                  
  3458 0000235B E80503                   call end1
  3459                                  
  3460                                  ;-6 }
  3461                                  
  3462                                  
  3463                                  ;-7 
  3464                                  
  3465                                  
  3466                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3467                                  
  3468 0000235E C3                       ret
  3469                                  ; ENDP
  3470                                  
  3471                                  getarg:  ; *** PROC ***
  3472                                  
  3473                                  ;-9   arglen1=*arglen;
  3474                                  
  3475                                  ;Function : getarg, Number of local variables: 3
  3476                                  ;   # type sign width line used address name   list of local variables
  3477                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3478                                  ;  201 var sign word     8 NULL bp-4    i
  3479                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3480 0000235F C8060000                 ENTER  6,0
  3481 00002363 8B1E[5A0E]               mov bx, [arglen]
  3482 00002367 8A07                     mov al, [bx]
  3483 00002369 B400                     mov ah, 0
  3484 0000236B 8946FE                   mov word [bp-2], ax
  3485                                  
  3486                                  ;-10   if (arglen1==0) {
  3487                                  
  3488 0000236E 8B46FE                   mov ax, [bp-2]
  3489 00002371 83F800                   cmp ax, 0
  3490 00002374 0F851C00                 jne @@getarg132
  3491                                  
  3492                                  ;-11     cputs(Version1);
  3493                                  
  3494 00002378 8D06[0300]               lea  ax, [Version1]
  3495 0000237C 50                       push ax
  3496 0000237D E80D0B                   call cputs
  3497 00002380 83C402                   add  sp, 2
  3498                                  
  3499                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3500                                  
  3501 00002383 68[2425]                 push getarg_0
  3502 00002386 E8040B                   call cputs
  3503 00002389 83C402                   add  sp, 2
  3504                                  
  3505                                  ;-13     exitR(3);
  3506                                  
  3507 0000238C 6A03                     push 3
  3508 0000238E E8D70C                   call exitR
  3509 00002391 83C402                   add  sp, 2
  3510                                  
  3511                                  ;-14   }
  3512                                  
  3513                                  
  3514                                  ;-15   i=arglen1+129; 
  3515                                  
  3516                                  @@getarg132:
  3517 00002394 8B46FE                   mov ax, [bp-2]
  3518 00002397 058100                   add ax, 129
  3519 0000239A 8946FC                   mov word [bp-4], ax
  3520                                  
  3521                                  ;-16   *i=0;  
  3522                                  
  3523 0000239D 66B800000000             mov eax, 0
  3524 000023A3 8B5EFC                   mov  bx, [bp-4]
  3525 000023A6 8907                     mov  [bx], ax
  3526                                  
  3527                                  ;-17   arglen1--;
  3528                                  
  3529 000023A8 FF4EFE                   dec  word [bp-2]
  3530                                  
  3531                                  ;-18   toupper(argv);
  3532                                  
  3533 000023AB FF36[5C0E]               push word [argv]
  3534 000023AF E8090B                   call toupper
  3535 000023B2 83C402                   add  sp, 2
  3536                                  
  3537                                  ;-19   
  3538                                  
  3539                                  
  3540                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3541                                  
  3542 000023B5 FF36[5C0E]               push word [argv]
  3543 000023B9 8D06[DA00]               lea  ax, [namein]
  3544 000023BD 50                       push ax
  3545 000023BE E8680B                   call strcpy
  3546 000023C1 83C404                   add  sp, 4
  3547 000023C4 68[4925]                 push getarg_1
  3548 000023C7 8D06[DA00]               lea  ax, [namein]
  3549 000023CB 50                       push ax
  3550 000023CC E81B0C                   call strcat1
  3551 000023CF 83C404                   add  sp, 4
  3552                                  
  3553                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3554                                  
  3555 000023D2 FF36[5C0E]               push word [argv]
  3556 000023D6 8D06[1D01]               lea  ax, [namelst]
  3557 000023DA 50                       push ax
  3558 000023DB E84B0B                   call strcpy
  3559 000023DE 83C404                   add  sp, 4
  3560 000023E1 68[4C25]                 push getarg_2
  3561 000023E4 8D06[1D01]               lea  ax, [namelst]
  3562 000023E8 50                       push ax
  3563 000023E9 E8FE0B                   call strcat1
  3564 000023EC 83C404                   add  sp, 4
  3565                                  
  3566                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3567                                  
  3568 000023EF FF36[5C0E]               push word [argv]
  3569 000023F3 8D06[6001]               lea  ax, [namebin]
  3570 000023F7 50                       push ax
  3571 000023F8 E82E0B                   call strcpy
  3572 000023FB 83C404                   add  sp, 4
  3573 000023FE 68[5125]                 push getarg_3
  3574 00002401 8D06[6001]               lea  ax, [namebin]
  3575 00002405 50                       push ax
  3576 00002406 E8E10B                   call strcat1
  3577 00002409 83C404                   add  sp, 4
  3578                                  
  3579                                  ;-23 
  3580                                  
  3581                                  
  3582                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3583                                  
  3584 0000240C 66B801000000             mov eax, 1
  3585 00002412 A2[1800]                 mov byte [LIST], al
  3586 00002415 66B800000000             mov eax, 0
  3587 0000241B A3[A901]                 mov word [DOS_ERR], ax
  3588 0000241E 66B800000000             mov eax, 0
  3589 00002424 A3[B001]                 mov word [PC], ax
  3590 00002427 66B800000000             mov eax, 0
  3591 0000242D A3[AB01]                 mov word [ErrorCount], ax
  3592                                  
  3593                                  ;-25   
  3594                                  
  3595                                  
  3596                                  ;-26   asm_fd=openR (namein);
  3597                                  
  3598 00002430 8D06[DA00]               lea  ax, [namein]
  3599 00002434 50                       push ax
  3600 00002435 E8D70B                   call openR
  3601 00002438 83C402                   add  sp, 2
  3602 0000243B A3[A301]                 mov word [asm_fd], ax
  3603                                  
  3604                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3605                                  
  3606 0000243E A1[A901]                 mov ax, [DOS_ERR]
  3607 00002441 08C0                     or  al, al
  3608 00002443 0F841C00                 je @@getarg133
  3609 00002447 68[5625]                 push getarg_4
  3610 0000244A E8400A                   call cputs
  3611 0000244D 83C402                   add  sp, 2
  3612 00002450 8D06[DA00]               lea  ax, [namein]
  3613 00002454 50                       push ax
  3614 00002455 E8350A                   call cputs
  3615 00002458 83C402                   add  sp, 2
  3616 0000245B 6A01                     push 1
  3617 0000245D E8080C                   call exitR
  3618 00002460 83C402                   add  sp, 2
  3619                                  
  3620                                  ;-28   lst_fd=creatR(namelst);
  3621                                  
  3622                                  @@getarg133:
  3623 00002463 8D06[1D01]               lea  ax, [namelst]
  3624 00002467 50                       push ax
  3625 00002468 E8B30B                   call creatR
  3626 0000246B 83C402                   add  sp, 2
  3627 0000246E A3[A501]                 mov word [lst_fd], ax
  3628                                  
  3629                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3630                                  
  3631 00002471 A1[A901]                 mov ax, [DOS_ERR]
  3632 00002474 08C0                     or  al, al
  3633 00002476 0F841C00                 je @@getarg134
  3634 0000247A 68[6C25]                 push getarg_5
  3635 0000247D E80D0A                   call cputs
  3636 00002480 83C402                   add  sp, 2
  3637 00002483 8D06[1D01]               lea  ax, [namelst]
  3638 00002487 50                       push ax
  3639 00002488 E8020A                   call cputs
  3640 0000248B 83C402                   add  sp, 2
  3641 0000248E 6A02                     push 2
  3642 00002490 E8D50B                   call exitR
  3643 00002493 83C402                   add  sp, 2
  3644                                  
  3645                                  ;-30   bin_fd=creatR(namebin);
  3646                                  
  3647                                  @@getarg134:
  3648 00002496 8D06[6001]               lea  ax, [namebin]
  3649 0000249A 50                       push ax
  3650 0000249B E8800B                   call creatR
  3651 0000249E 83C402                   add  sp, 2
  3652 000024A1 A3[A701]                 mov word [bin_fd], ax
  3653                                  
  3654                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3655                                  
  3656 000024A4 A1[A901]                 mov ax, [DOS_ERR]
  3657 000024A7 08C0                     or  al, al
  3658 000024A9 0F841C00                 je @@getarg135
  3659 000024AD 68[8325]                 push getarg_6
  3660 000024B0 E8DA09                   call cputs
  3661 000024B3 83C402                   add  sp, 2
  3662 000024B6 8D06[6001]               lea  ax, [namebin]
  3663 000024BA 50                       push ax
  3664 000024BB E8CF09                   call cputs
  3665 000024BE 83C402                   add  sp, 2
  3666 000024C1 6A02                     push 2
  3667 000024C3 E8A20B                   call exitR
  3668 000024C6 83C402                   add  sp, 2
  3669                                  
  3670                                  ;-32   
  3671                                  
  3672                                  
  3673                                  ;-33   prs(";");prs(Version1);
  3674                                  
  3675                                  @@getarg135:
  3676 000024C9 68[9925]                 push getarg_7
  3677 000024CC E81BFB                   call prs
  3678 000024CF 83C402                   add  sp, 2
  3679 000024D2 8D06[0300]               lea  ax, [Version1]
  3680 000024D6 50                       push ax
  3681 000024D7 E810FB                   call prs
  3682 000024DA 83C402                   add  sp, 2
  3683                                  
  3684                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3685                                  
  3686 000024DD 68[9B25]                 push getarg_8
  3687 000024E0 E807FB                   call prs
  3688 000024E3 83C402                   add  sp, 2
  3689 000024E6 8D06[DA00]               lea  ax, [namein]
  3690 000024EA 50                       push ax
  3691 000024EB E8FCFA                   call prs
  3692 000024EE 83C402                   add  sp, 2
  3693 000024F1 68[A625]                 push getarg_9
  3694 000024F4 E8F3FA                   call prs
  3695 000024F7 83C402                   add  sp, 2
  3696 000024FA 8D06[1D01]               lea  ax, [namelst]
  3697 000024FE 50                       push ax
  3698 000024FF E8E8FA                   call prs
  3699 00002502 83C402                   add  sp, 2
  3700                                  
  3701                                  ;-35   prs(", "); prs(namebin);
  3702                                  
  3703 00002505 68[B125]                 push getarg_10
  3704 00002508 E8DFFA                   call prs
  3705 0000250B 83C402                   add  sp, 2
  3706 0000250E 8D06[6001]               lea  ax, [namebin]
  3707 00002512 50                       push ax
  3708 00002513 E8D4FA                   call prs
  3709 00002516 83C402                   add  sp, 2
  3710                                  
  3711                                  ;-36   prs("\n");
  3712                                  
  3713 00002519 68[B425]                 push getarg_11
  3714 0000251C E8CBFA                   call prs
  3715 0000251F 83C402                   add  sp, 2
  3716                                  
  3717                                  ;-37 }
  3718                                  
  3719                                  
  3720                                  ;-38 int epilog() { int i; int j; char c;
  3721 00002522 C9                       LEAVE
  3722 00002523 C3                       ret
  3723                                  ; ENDP
  3724 00002524 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3725 0000252D 41532E434F4D206669-
  3726 00002536 6C656E616D65205B77-
  3727 0000253F 2F6F202E535D203A20-
  3728 00002548 00                 
  3729 00002549 2E5300                  getarg_1 db ".S",0
  3730 0000254C 2E4C535400              getarg_2 db ".LST",0
  3731 00002551 2E434F4D00              getarg_3 db ".COM",0
  3732 00002556 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3733 0000255F 6C65206D697373696E-
  3734 00002568 673A2000           
  3735 0000256C 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3736 00002575 206E6F742063726561-
  3737 0000257E 74653A2000         
  3738 00002583 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3739 0000258C 6E6F74206372656174-
  3740 00002595 653A2000           
  3741 00002599 3B00                    getarg_7 db ";",0
  3742 0000259B 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3743 000025A4 2000               
  3744 000025A6 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3745 000025AF 2000               
  3746 000025B1 2C2000                  getarg_10 db ", ",0
  3747 000025B4 5C6E00                  getarg_11 db "\n",0
  3748                                  
  3749                                  epilog:  ; *** PROC ***
  3750                                  
  3751                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3752                                  
  3753                                  ;Function : epilog, Number of local variables: 3
  3754                                  ;   # type sign width line used address name   list of local variables
  3755                                  ;  200 var sign word    38 NULL bp-2    i
  3756                                  ;  201 var sign word    38 NULL bp-4    j
  3757                                  ;  202 var sign byte    38 NULL bp-6    c;
  3758 000025B7 C8060000                 ENTER  6,0
  3759 000025BB 68[3126]                 push epilog_0
  3760 000025BE E829FA                   call prs
  3761 000025C1 83C402                   add  sp, 2
  3762 000025C4 FF36[AB01]               push word [ErrorCount]
  3763 000025C8 E83AFB                   call printIntU
  3764 000025CB 83C402                   add  sp, 2
  3765                                  
  3766                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3767                                  
  3768 000025CE A1[AB01]                 mov ax, [ErrorCount]
  3769 000025D1 08C0                     or  al, al
  3770 000025D3 0F840900                 je @@epilog136
  3771 000025D7 68[4126]                 push epilog_1
  3772 000025DA E80DFA                   call prs
  3773 000025DD 83C402                   add  sp, 2
  3774                                  
  3775                                  ;-41 /*    
  3776                                  
  3777                                  
  3778                                  ;-42   prs(", Label & Var: ");
  3779                                  
  3780                                  
  3781                                  ;-43   if (LabelMaxIx) {
  3782                                  
  3783                                  
  3784                                  ;-44     i = 1;
  3785                                  
  3786                                  
  3787                                  ;-45     LabelNamePtr= &LabelNames;
  3788                                  
  3789                                  
  3790                                  ;-46     do {
  3791                                  
  3792                                  
  3793                                  ;-47       prs(LabelNamePtr); prc(' ');
  3794                                  
  3795                                  
  3796                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3797                                  
  3798                                  
  3799                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3800                                  
  3801                                  
  3802                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3803                                  
  3804                                  
  3805                                  ;-51       LabelNamePtr++;
  3806                                  
  3807                                  
  3808                                  ;-52       i++;
  3809                                  
  3810                                  
  3811                                  ;-53     } while (i <= LabelMaxIx);
  3812                                  
  3813                                  
  3814                                  ;-54   }
  3815                                  
  3816                                  
  3817                                  ;-55 */  
  3818                                  
  3819                                  
  3820                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3821                                  
  3822                                  @@epilog136:
  3823 000025E0 68[4F26]                 push epilog_2
  3824 000025E3 E804FA                   call prs
  3825 000025E6 83C402                   add  sp, 2
  3826 000025E9 FF36[580E]               push word [BinLen]
  3827 000025ED E815FB                   call printIntU
  3828 000025F0 83C402                   add  sp, 2
  3829 000025F3 68[5B26]                 push epilog_3
  3830 000025F6 E8F1F9                   call prs
  3831 000025F9 83C402                   add  sp, 2
  3832                                  
  3833                                  ;-57 //  i=0;
  3834                                  
  3835                                  
  3836                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  3837                                  
  3838                                  
  3839                                  ;-59 //  } while (i < BinLen);
  3840                                  
  3841                                  
  3842                                  ;-60   i=0;
  3843                                  
  3844 000025FC 66B800000000             mov eax, 0
  3845 00002602 8946FE                   mov word [bp-2], ax
  3846                                  
  3847                                  ;-61   do {
  3848                                  
  3849                                  @@epilog137:
  3850                                  
  3851                                  ;-62     c = FileBin[i];
  3852                                  
  3853 00002605 8B5EFE                   mov bx, [bp-2]
  3854 00002608 8A87[8806]               mov al, [FileBin + bx]
  3855 0000260C 8846FA                   mov byte [bp-6], al
  3856                                  
  3857                                  ;-63     fputcR(c, bin_fd);
  3858                                  
  3859 0000260F FF36[A701]               push word [bin_fd]
  3860 00002613 8A46FA                   mov al, byte [bp-6]
  3861 00002616 B400                     mov ah, 0
  3862 00002618 50                       push ax
  3863 00002619 E8290A                   call fputcR
  3864 0000261C 83C404                   add  sp, 4
  3865                                  
  3866                                  ;-64     i++;
  3867                                  
  3868 0000261F FF46FE                   inc  word [bp-2]
  3869                                  
  3870                                  ;-65   } while (i < BinLen);
  3871                                  
  3872 00002622 8B46FE                   mov ax, [bp-2]
  3873 00002625 3B06[580E]               cmp ax, [BinLen]
  3874 00002629 0F8D0200                 jge @@epilog138
  3875 0000262D EBD6                     jmp @@epilog137
  3876                                  @@epilog138:
  3877                                  
  3878                                  ;-66 }
  3879                                  
  3880                                  
  3881                                  ;-67 int end1(int n) {
  3882 0000262F C9                       LEAVE
  3883 00002630 C3                       ret
  3884                                  ; ENDP
  3885 00002631 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  3886 0000263A 726F72733A2000     
  3887 00002641 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  3888 0000264A 2A2A2A2000         
  3889 0000264F 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  3890 00002658 652000             
  3891 0000265B 2062797465732E00        epilog_3 db " bytes.",0
  3892                                  
  3893                                  end1:  ; *** PROC ***
  3894                                  
  3895                                  ;-68   fcloseR(asm_fd);
  3896                                  
  3897                                  ;Function : end1, Number of local variables: 1
  3898                                  ;   # type sign width line used address name   list of local variables
  3899                                  ;  200 var sign word    67 NULL bp+4    n;
  3900 00002663 C8000000                 ENTER  0,0
  3901 00002667 FF36[A301]               push word [asm_fd]
  3902 0000266B E8EC09                   call fcloseR
  3903 0000266E 83C402                   add  sp, 2
  3904                                  
  3905                                  ;-69   fcloseR(lst_fd);
  3906                                  
  3907 00002671 FF36[A501]               push word [lst_fd]
  3908 00002675 E8E209                   call fcloseR
  3909 00002678 83C402                   add  sp, 2
  3910                                  
  3911                                  ;-70   fcloseR(bin_fd);
  3912                                  
  3913 0000267B FF36[A701]               push word [bin_fd]
  3914 0000267F E8D809                   call fcloseR
  3915 00002682 83C402                   add  sp, 2
  3916                                  
  3917                                  ;-71   exitR(n);
  3918                                  
  3919 00002685 FF7604                   push word [bp+4]
  3920 00002688 E8DD09                   call exitR
  3921 0000268B 83C402                   add  sp, 2
  3922                                  
  3923                                  ;-72 }
  3924 0000268E C9                       LEAVE
  3925 0000268F C3                       ret
  3926                                  ; ENDP
  3927                                  ;Back to main program: AS.C
  3928                                  
  3929                                  ;-9 #include "GENCODE.C"
  3930                                  
  3931                                  ;Use include file: GENCODE.C
  3932                                  
  3933                                  ;-1 // generate code
  3934                                  
  3935                                  
  3936                                  ;-2 int getCodes() {
  3937                                  
  3938                                  
  3939                                  getCodes:  ; *** PROC ***
  3940                                  
  3941                                  ;-3   OpCodePtr ++; Code1 = *OpCodePtr;
  3942                                  
  3943 00002690 FF06[CF01]               inc  word [OpCodePtr]
  3944 00002694 8B1E[CF01]               mov bx, [OpCodePtr]
  3945 00002698 8A07                     mov al, [bx]
  3946 0000269A B400                     mov ah, 0
  3947 0000269C A2[B901]                 mov byte [Code1], al
  3948                                  
  3949                                  ;-4   OpCodePtr ++; Code2 = *OpCodePtr;
  3950                                  
  3951 0000269F FF06[CF01]               inc  word [OpCodePtr]
  3952 000026A3 8B1E[CF01]               mov bx, [OpCodePtr]
  3953 000026A7 8A07                     mov al, [bx]
  3954 000026A9 B400                     mov ah, 0
  3955 000026AB A2[BA01]                 mov byte [Code2], al
  3956                                  
  3957                                  ;-5   OpCodePtr ++; Code3 = *OpCodePtr;
  3958                                  
  3959 000026AE FF06[CF01]               inc  word [OpCodePtr]
  3960 000026B2 8B1E[CF01]               mov bx, [OpCodePtr]
  3961 000026B6 8A07                     mov al, [bx]
  3962 000026B8 B400                     mov ah, 0
  3963 000026BA A2[BB01]                 mov byte [Code3], al
  3964                                  
  3965                                  ;-6 }
  3966                                  
  3967                                  
  3968                                  ;-7 int gen66h() {genCode8(0x66);
  3969                                  
  3970 000026BD C3                       ret
  3971                                  ; ENDP
  3972                                  
  3973                                  gen66h:  ; *** PROC ***
  3974 000026BE 6A66                     push 102
  3975 000026C0 E81F00                   call genCode8
  3976 000026C3 83C402                   add  sp, 2
  3977                                  
  3978                                  ;-8 }
  3979                                  
  3980                                  
  3981                                  ;-9 int genCode(char c, char d) {
  3982                                  
  3983 000026C6 C3                       ret
  3984                                  ; ENDP
  3985                                  
  3986                                  genCode:  ; *** PROC ***
  3987                                  
  3988                                  ;-10     c = c + d;
  3989                                  
  3990                                  ;Function : genCode, Number of local variables: 2
  3991                                  ;   # type sign width line used address name   list of local variables
  3992                                  ;  200 var sign byte     9 NULL bp+4    c
  3993                                  ;  201 var sign byte     9 NULL bp+6    d;
  3994 000026C7 C8000000                 ENTER  0,0
  3995 000026CB 8A4604                   mov al, [bp+4]
  3996 000026CE 024606                   add al, [bp+6]
  3997 000026D1 884604                   mov byte [bp+4], al
  3998                                  
  3999                                  ;-11     genCode8(c);
  4000                                  
  4001 000026D4 8A4604                   mov al, byte [bp+4]
  4002 000026D7 B400                     mov ah, 0
  4003 000026D9 50                       push ax
  4004 000026DA E80500                   call genCode8
  4005 000026DD 83C402                   add  sp, 2
  4006                                  
  4007                                  ;-12 }
  4008                                  
  4009                                  
  4010                                  ;-13 int genCode8(char c) {
  4011 000026E0 C9                       LEAVE
  4012 000026E1 C3                       ret
  4013                                  ; ENDP
  4014                                  
  4015                                  genCode8:  ; *** PROC ***
  4016                                  
  4017                                  ;-14 //set: BinLen++, OpPrintIndex++
  4018                                  
  4019                                  
  4020                                  ;-15   FileBin[BinLen]=c;
  4021                                  
  4022                                  ;Function : genCode8, Number of local variables: 1
  4023                                  ;   # type sign width line used address name   list of local variables
  4024                                  ;  200 var sign byte    13 NULL bp+4    c;
  4025 000026E2 C8000000                 ENTER  0,0
  4026 000026E6 8A4604                   mov al, [bp+4]
  4027 000026E9 8B1E[580E]               mov bx, [BinLen]
  4028 000026ED 8887[8806]               mov [FileBin+bx], al
  4029                                  
  4030                                  ;-16   BinLen++;
  4031                                  
  4032 000026F1 FF06[580E]               inc  word [BinLen]
  4033                                  
  4034                                  ;-17   PC++;
  4035                                  
  4036 000026F5 FF06[B001]               inc  word [PC]
  4037                                  
  4038                                  ;-18   if (BinLen >= FILEBINMAX) errorexit("COM file to long");
  4039                                  
  4040 000026F9 A1[580E]                 mov ax, [BinLen]
  4041 000026FC 3DD007                   cmp ax, 2000 ;unsigned : 0
  4042 000026FF 0F820900                 jb  @@genCode8139
  4043 00002703 68[2727]                 push genCode8_0
  4044 00002706 E8F8FB                   call errorexit
  4045 00002709 83C402                   add  sp, 2
  4046                                  
  4047                                  ;-19   if (OpPrintIndex < OPMAXLEN) {
  4048                                  
  4049                                  @@genCode8139:
  4050 0000270C A1[CD01]                 mov ax, [OpPrintIndex]
  4051 0000270F 83F805                   cmp ax, 5
  4052 00002712 0F8D0F00                 jge @@genCode8140
  4053                                  
  4054                                  ;-20     OpPos[OpPrintIndex]=c;
  4055                                  
  4056 00002716 8A4604                   mov al, [bp+4]
  4057 00002719 8B1E[CD01]               mov bx, [OpPrintIndex]
  4058 0000271D 8887[C801]               mov [OpPos+bx], al
  4059                                  
  4060                                  ;-21     OpPrintIndex++;
  4061                                  
  4062 00002721 FF06[CD01]               inc  word [OpPrintIndex]
  4063                                  
  4064                                  ;-22   }
  4065                                  
  4066                                  
  4067                                  ;-23 }
  4068                                  
  4069                                  @@genCode8140:
  4070                                  
  4071                                  ;-24 int genCode16(unsigned int i) {
  4072 00002725 C9                       LEAVE
  4073 00002726 C3                       ret
  4074                                  ; ENDP
  4075 00002727 434F4D2066696C6520-     genCode8_0 db "COM file to long",0
  4076 00002730 746F206C6F6E6700   
  4077                                  
  4078                                  genCode16:  ; *** PROC ***
  4079                                  
  4080                                  ;-25   genCode8(i); i=i >> 8;
  4081                                  
  4082                                  ;Function : genCode16, Number of local variables: 1
  4083                                  ;   # type sign width line used address name   list of local variables
  4084                                  ;  200 var unsg word    24 NULL bp+4    i;
  4085 00002738 C8000000                 ENTER  0,0
  4086 0000273C FF7604                   push word [bp+4]
  4087 0000273F E8A0FF                   call genCode8
  4088 00002742 83C402                   add  sp, 2
  4089 00002745 8B4604                   mov ax, [bp+4]
  4090 00002748 C1E808                   shr ax, 8
  4091 0000274B 894604                   mov word [bp+4], ax
  4092                                  
  4093                                  ;-26   genCode8(i);
  4094                                  
  4095 0000274E FF7604                   push word [bp+4]
  4096 00002751 E88EFF                   call genCode8
  4097 00002754 83C402                   add  sp, 2
  4098                                  
  4099                                  ;-27 }
  4100                                  
  4101                                  
  4102                                  ;-28 int writeEA(char xxx) {//need: Op1, disp, RegNo, regindexbase
  4103 00002757 C9                       LEAVE
  4104 00002758 C3                       ret
  4105                                  ; ENDP
  4106                                  
  4107                                  writeEA:  ; *** PROC ***
  4108                                  
  4109                                  ;-29 //mod-byte: mode76, reg/opcode543, r/m210    
  4110                                  
  4111                                  
  4112                                  ;-30   char len;
  4113                                  
  4114                                  
  4115                                  ;-31   len=0;
  4116                                  
  4117                                  ;Function : writeEA, Number of local variables: 2
  4118                                  ;   # type sign width line used address name   list of local variables
  4119                                  ;  200 var sign byte    28 NULL bp+4    xxx
  4120                                  ;  201 var sign byte    30 NULL bp-2    len;
  4121 00002759 C8020000                 ENTER  2,0
  4122 0000275D 66B800000000             mov eax, 0
  4123 00002763 8846FE                   mov byte [bp-2], al
  4124                                  
  4125                                  ;-32   xxx = xxx << 3;//in reg/opcode field
  4126                                  
  4127 00002766 8A4604                   mov al, [bp+4]
  4128 00002769 C0E003                   shl al, 3
  4129 0000276C 884604                   mov byte [bp+4], al
  4130                                  
  4131                                  ;-33 //  prs("\nxxx:"); printhex8a(xxx);
  4132                                  
  4133                                  
  4134                                  ;-34   if (Op1 ==   0) addrexit();
  4135                                  
  4136 0000276F A0[B601]                 mov al, [Op1]
  4137 00002772 3C00                     cmp al, 0
  4138 00002774 0F850300                 jne @@writeEA141
  4139 00002778 E89DFB                   call addrexit
  4140                                  
  4141                                  ;-35   if (Op1 == REG) {xxx |= 0xC0; xxx = xxx + RegNo;} 
  4142                                  
  4143                                  @@writeEA141:
  4144 0000277B A0[B601]                 mov al, [Op1]
  4145 0000277E 3C02                     cmp al, 2
  4146 00002780 0F850E00                 jne @@writeEA142
  4147 00002784 804E04C0                 or  byte [bp+4], 192
  4148 00002788 8A4604                   mov al, [bp+4]
  4149 0000278B 0206[BC01]               add al, [RegNo]
  4150 0000278F 884604                   mov byte [bp+4], al
  4151                                  
  4152                                  ;-36   if (Op1 == ADR) error1("writeEA");           
  4153                                  
  4154                                  @@writeEA142:
  4155 00002792 A0[B601]                 mov al, [Op1]
  4156 00002795 3C03                     cmp al, 3
  4157 00002797 0F850900                 jne @@writeEA143
  4158 0000279B 68[6028]                 push writeEA_0
  4159 0000279E E8A6F9                   call error1
  4160 000027A1 83C402                   add  sp, 2
  4161                                  
  4162                                  ;-37   if (Op1 == MEM) {
  4163                                  
  4164                                  @@writeEA143:
  4165 000027A4 A0[B601]                 mov al, [Op1]
  4166 000027A7 3C04                     cmp al, 4
  4167 000027A9 0F857F00                 jne @@writeEA144
  4168                                  
  4169                                  ;-38     if (isDirect) {
  4170                                  
  4171 000027AD A0[C301]                 mov al, [isDirect]
  4172 000027B0 08C0                     or  al, al
  4173 000027B2 0F841000                 je @@writeEA145
  4174                                  
  4175                                  ;-39         xxx |= 6;
  4176                                  
  4177 000027B6 804E0406                 or  byte [bp+4], 6
  4178                                  
  4179                                  ;-40         len = 2;
  4180                                  
  4181 000027BA 66B802000000             mov eax, 2
  4182 000027C0 8846FE                   mov byte [bp-2], al
  4183                                  
  4184                                  ;-41     }
  4185                                  
  4186                                  
  4187                                  ;-42     else { 
  4188                                  
  4189 000027C3 E96600                   jmp @@writeEA146
  4190                                  @@writeEA145:
  4191                                  
  4192                                  ;-43       xxx = xxx + regindexbase;   
  4193                                  
  4194 000027C6 8A4604                   mov al, [bp+4]
  4195 000027C9 0206[C201]               add al, [regindexbase]
  4196 000027CD 884604                   mov byte [bp+4], al
  4197                                  
  4198                                  ;-44       if (regindexbase == 6) {//make [BP+00]
  4199                                  
  4200 000027D0 A0[C201]                 mov al, [regindexbase]
  4201 000027D3 3C06                     cmp al, 6
  4202 000027D5 0F851700                 jne @@writeEA147
  4203                                  
  4204                                  ;-45         len=1;
  4205                                  
  4206 000027D9 66B801000000             mov eax, 1
  4207 000027DF 8846FE                   mov byte [bp-2], al
  4208                                  
  4209                                  ;-46         if (disp == 0) xxx |= 0x40;
  4210                                  
  4211 000027E2 A1[C401]                 mov ax, [disp]
  4212 000027E5 83F800                   cmp ax, 0
  4213 000027E8 0F850400                 jne @@writeEA148
  4214 000027EC 804E0440                 or  byte [bp+4], 64
  4215                                  
  4216                                  ;-47       }
  4217                                  
  4218                                  @@writeEA148:
  4219                                  
  4220                                  ;-48 
  4221                                  
  4222                                  
  4223                                  ;-49       if (disp) {
  4224                                  
  4225                                  @@writeEA147:
  4226 000027F0 A1[C401]                 mov ax, [disp]
  4227 000027F3 08C0                     or  al, al
  4228 000027F5 0F843300                 je @@writeEA149
  4229                                  
  4230                                  ;-50         ax = disp;
  4231                                  
  4232 000027F9 A1[C401]                 mov  ax, [disp]
  4233                                  
  4234                                  ;-51         if(ax > 127) len=2;
  4235                                  
  4236 000027FC 83F87F                   cmp  ax, 127
  4237 000027FF 0F8E0C00                 jle @@writeEA150
  4238 00002803 66B802000000             mov eax, 2
  4239 00002809 8846FE                   mov byte [bp-2], al
  4240                                  
  4241                                  ;-52         else len=1;
  4242                                  
  4243 0000280C E90900                   jmp @@writeEA151
  4244                                  @@writeEA150:
  4245 0000280F 66B801000000             mov eax, 1
  4246 00002815 8846FE                   mov byte [bp-2], al
  4247                                  
  4248                                  ;-53         if (len == 1) xxx |= 0x40;
  4249                                  
  4250                                  @@writeEA151:
  4251 00002818 8A46FE                   mov al, [bp-2]
  4252 0000281B 3C01                     cmp al, 1
  4253 0000281D 0F850700                 jne @@writeEA152
  4254 00002821 804E0440                 or  byte [bp+4], 64
  4255                                  
  4256                                  ;-54         else xxx |= 0x80;
  4257                                  
  4258 00002825 E90400                   jmp @@writeEA153
  4259                                  @@writeEA152:
  4260 00002828 804E0480                 or  byte [bp+4], 128
  4261                                  
  4262                                  ;-55       }
  4263                                  
  4264                                  @@writeEA153:
  4265                                  
  4266                                  ;-56     }
  4267                                  
  4268                                  @@writeEA149:
  4269                                  
  4270                                  ;-57   }
  4271                                  
  4272                                  @@writeEA146:
  4273                                  
  4274                                  ;-58   genCode8(xxx);// gen second byte
  4275                                  
  4276                                  @@writeEA144:
  4277 0000282C 8A4604                   mov al, byte [bp+4]
  4278 0000282F B400                     mov ah, 0
  4279 00002831 50                       push ax
  4280 00002832 E8ADFE                   call genCode8
  4281 00002835 83C402                   add  sp, 2
  4282                                  
  4283                                  ;-59   if (len == 1) genCode8 (disp);
  4284                                  
  4285 00002838 8A46FE                   mov al, [bp-2]
  4286 0000283B 3C01                     cmp al, 1
  4287 0000283D 0F850A00                 jne @@writeEA154
  4288 00002841 FF36[C401]               push word [disp]
  4289 00002845 E89AFE                   call genCode8
  4290 00002848 83C402                   add  sp, 2
  4291                                  
  4292                                  ;-60   if (len == 2) genCode16(disp);
  4293                                  
  4294                                  @@writeEA154:
  4295 0000284B 8A46FE                   mov al, [bp-2]
  4296 0000284E 3C02                     cmp al, 2
  4297 00002850 0F850A00                 jne @@writeEA155
  4298 00002854 FF36[C401]               push word [disp]
  4299 00002858 E8DDFE                   call genCode16
  4300 0000285B 83C402                   add  sp, 2
  4301                                  
  4302                                  ;-61 }
  4303                                  
  4304 0000285E C9                      @@writeEA155: LEAVE
  4305 0000285F C3                       ret
  4306                                  ; ENDP
  4307 00002860 7772697465454100        writeEA_0 db "writeEA",0
  4308                                  ;Back to main program: AS.C
  4309                                  
  4310                                  ;-10 
  4311                                  
  4312                                  
  4313                                  ;-11 int process() {
  4314                                  
  4315                                  
  4316                                  process:  ; *** PROC ***
  4317                                  
  4318                                  ;-12   getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4319                                  
  4320 00002868 E8B5EA                   call getTokeType
  4321                                  
  4322                                  ;-13   OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4323                                  
  4324 0000286B E805EE                   call getCodeSize
  4325 0000286E A2[C001]                 mov byte [OpSize], al
  4326                                  
  4327                                  ;-14   getCodes();//set: Code1, Code2, Code3
  4328                                  
  4329 00002871 E81CFE                   call getCodes
  4330                                  
  4331                                  ;-15 
  4332                                  
  4333                                  
  4334                                  ;-16   if (CodeType ==  1) {//1 byte opcode
  4335                                  
  4336 00002874 A0[B801]                 mov al, [CodeType]
  4337 00002877 3C01                     cmp al, 1
  4338 00002879 0F850F00                 jne @@process156
  4339                                  
  4340                                  ;-17     genCode8(Code1);
  4341                                  
  4342 0000287D A0[B901]                 mov al, byte [Code1]
  4343 00002880 B400                     mov ah, 0
  4344 00002882 50                       push ax
  4345 00002883 E85CFE                   call genCode8
  4346 00002886 83C402                   add  sp, 2
  4347                                  
  4348                                  ;-18     return;
  4349                                  
  4350 00002889 E9B801                   jmp @@retn
  4351                                  
  4352                                  ;-19   }
  4353                                  
  4354                                  
  4355                                  ;-20   
  4356                                  
  4357                                  
  4358                                  ;-21   if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4359                                  
  4360                                  @@process156:
  4361 0000288C A0[B801]                 mov al, [CodeType]
  4362 0000288F 3C02                     cmp al, 2
  4363 00002891 0F858A00                 jne @@process157
  4364                                  
  4365                                  ;-22     checkOp();
  4366                                  
  4367 00002895 E8D101                   call checkOp
  4368                                  
  4369                                  ;-23     if (Code2 <= 1) {//inc,dec
  4370                                  
  4371 00002898 A0[BA01]                 mov al, [Code2]
  4372 0000289B 3C01                     cmp al, 1
  4373 0000289D 0F8F4500                 jg  @@process158
  4374                                  
  4375                                  ;-24   	if (Op1 == REG) {
  4376                                  
  4377 000028A1 A0[B601]                 mov al, [Op1]
  4378 000028A4 3C02                     cmp al, 2
  4379 000028A6 0F853C00                 jne @@process159
  4380                                  
  4381                                  ;-25       if (RegType == WORD) {genCode(Code3, RegNo); return; }//short
  4382                                  
  4383 000028AA A0[BE01]                 mov al, [RegType]
  4384 000028AD 3C02                     cmp al, 2
  4385 000028AF 0F851500                 jne @@process160
  4386 000028B3 A0[BC01]                 mov al, byte [RegNo]
  4387 000028B6 B400                     mov ah, 0
  4388 000028B8 50                       push ax
  4389 000028B9 A0[BB01]                 mov al, byte [Code3]
  4390 000028BC B400                     mov ah, 0
  4391 000028BE 50                       push ax
  4392 000028BF E805FE                   call genCode
  4393 000028C2 83C404                   add  sp, 4
  4394 000028C5 E97C01                   jmp @@retn
  4395                                  
  4396                                  ;-26       if (RegType ==DWORD) {genCode(Code3, RegNo); return; }
  4397                                  
  4398                                  @@process160:
  4399 000028C8 A0[BE01]                 mov al, [RegType]
  4400 000028CB 3C03                     cmp al, 3
  4401 000028CD 0F851500                 jne @@process161
  4402 000028D1 A0[BC01]                 mov al, byte [RegNo]
  4403 000028D4 B400                     mov ah, 0
  4404 000028D6 50                       push ax
  4405 000028D7 A0[BB01]                 mov al, byte [Code3]
  4406 000028DA B400                     mov ah, 0
  4407 000028DC 50                       push ax
  4408 000028DD E8E7FD                   call genCode
  4409 000028E0 83C404                   add  sp, 4
  4410 000028E3 E95E01                   jmp @@retn
  4411                                  
  4412                                  ;-27       }
  4413                                  
  4414                                  @@process161:
  4415                                  
  4416                                  ;-28     }
  4417                                  
  4418                                  @@process159:
  4419                                  
  4420                                  ;-29     if (Code2 == 5) {//imul extension?
  4421                                  
  4422                                  @@process158:
  4423 000028E6 A0[BA01]                 mov al, [Code2]
  4424 000028E9 3C05                     cmp al, 5
  4425 000028EB 0F850F00                 jne @@process162
  4426                                  
  4427                                  ;-30       getTokeType();
  4428                                  
  4429 000028EF E82EEA                   call getTokeType
  4430                                  
  4431                                  ;-31       if (TokeType) implerror();
  4432                                  
  4433 000028F2 A0[B501]                 mov al, [TokeType]
  4434 000028F5 08C0                     or  al, al
  4435 000028F7 0F840300                 je @@process163
  4436 000028FB E803F9                   call implerror
  4437                                  
  4438                                  ;-32     }
  4439                                  
  4440                                  @@process163:
  4441                                  
  4442                                  ;-33     genCode(Code1, wflag);
  4443                                  
  4444                                  @@process162:
  4445 000028FE A0[C101]                 mov al, byte [wflag]
  4446 00002901 B400                     mov ah, 0
  4447 00002903 50                       push ax
  4448 00002904 A0[B901]                 mov al, byte [Code1]
  4449 00002907 B400                     mov ah, 0
  4450 00002909 50                       push ax
  4451 0000290A E8BAFD                   call genCode
  4452 0000290D 83C404                   add  sp, 4
  4453                                  
  4454                                  ;-34     writeEA(Code2);
  4455                                  
  4456 00002910 A0[BA01]                 mov al, byte [Code2]
  4457 00002913 B400                     mov ah, 0
  4458 00002915 50                       push ax
  4459 00002916 E840FE                   call writeEA
  4460 00002919 83C402                   add  sp, 2
  4461                                  
  4462                                  ;-35     return;
  4463                                  
  4464 0000291C E92501                   jmp @@retn
  4465                                  
  4466                                  ;-36   }
  4467                                  
  4468                                  
  4469                                  ;-37   
  4470                                  
  4471                                  
  4472                                  ;-38   if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4473                                  
  4474                                  @@process157:
  4475 0000291F A0[B801]                 mov al, [CodeType]
  4476 00002922 3C03                     cmp al, 3
  4477 00002924 0F856800                 jne @@process164
  4478                                  
  4479                                  ;-39     checkOp();      
  4480                                  
  4481 00002928 E83E01                   call checkOp
  4482                                  
  4483                                  ;-40     if (RegType != WORD) reg16error();
  4484                                  
  4485 0000292B A0[BE01]                 mov al, [RegType]
  4486 0000292E 3C02                     cmp al, 2
  4487 00002930 0F840300                 je  @@process165
  4488 00002934 E86AF9                   call reg16error
  4489                                  
  4490                                  ;-41     if (Op1 == IMM) immeerror();
  4491                                  
  4492                                  @@process165:
  4493 00002937 A0[B601]                 mov al, [Op1]
  4494 0000293A 3C01                     cmp al, 1
  4495 0000293C 0F850300                 jne @@process166
  4496 00002940 E899F8                   call immeerror
  4497                                  
  4498                                  ;-42     R1No=RegNo;
  4499                                  
  4500                                  @@process166:
  4501 00002943 A0[BC01]                 mov al, [RegNo]
  4502 00002946 A2[BD01]                 mov byte [R1No], al
  4503                                  
  4504                                  ;-43     need(',');    
  4505                                  
  4506 00002949 6A2C                     push 44
  4507 0000294B E8D6ED                   call need
  4508 0000294E 83C402                   add  sp, 2
  4509                                  
  4510                                  ;-44     getOp();
  4511                                  
  4512 00002951 E8CB01                   call getOp
  4513                                  
  4514                                  ;-45     if (Op1 < ADR) addrerror(); 
  4515                                  
  4516 00002954 A0[B601]                 mov al, [Op1]
  4517 00002957 3C03                     cmp al, 3
  4518 00002959 0F8D0300                 jge @@process167
  4519 0000295D E861F8                   call addrerror
  4520                                  
  4521                                  ;-46         
  4522                                  
  4523                                  
  4524                                  ;-47     genCode8(Code1);//les,lds,lea
  4525                                  
  4526                                  @@process167:
  4527 00002960 A0[B901]                 mov al, byte [Code1]
  4528 00002963 B400                     mov ah, 0
  4529 00002965 50                       push ax
  4530 00002966 E879FD                   call genCode8
  4531 00002969 83C402                   add  sp, 2
  4532                                  
  4533                                  ;-48     if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs
  4534                                  
  4535 0000296C A0[B901]                 mov al, [Code1]
  4536 0000296F 3C0F                     cmp al, 15
  4537 00002971 0F850C00                 jne @@process168
  4538 00002975 A0[BA01]                 mov al, byte [Code2]
  4539 00002978 B400                     mov ah, 0
  4540 0000297A 50                       push ax
  4541 0000297B E864FD                   call genCode8
  4542 0000297E 83C402                   add  sp, 2
  4543                                  
  4544                                  ;-49     writeEA(R1No);           
  4545                                  
  4546                                  @@process168:
  4547 00002981 A0[BD01]                 mov al, byte [R1No]
  4548 00002984 B400                     mov ah, 0
  4549 00002986 50                       push ax
  4550 00002987 E8CFFD                   call writeEA
  4551 0000298A 83C402                   add  sp, 2
  4552                                  
  4553                                  ;-50     return;
  4554                                  
  4555 0000298D E9B400                   jmp @@retn
  4556                                  
  4557                                  ;-51   }
  4558                                  
  4559                                  
  4560                                  ;-52 
  4561                                  
  4562                                  
  4563                                  ;-53   if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  4564                                  
  4565                                  @@process164:
  4566 00002990 A0[B801]                 mov al, [CodeType]
  4567 00002993 3C04                     cmp al, 4
  4568 00002995 0F854400                 jne @@process169
  4569                                  
  4570                                  ;-54     checkOp();
  4571                                  
  4572 00002999 E8CD00                   call checkOp
  4573                                  
  4574                                  ;-55     if (Op1 == IMM) immeerror();  
  4575                                  
  4576 0000299C A0[B601]                 mov al, [Op1]
  4577 0000299F 3C01                     cmp al, 1
  4578 000029A1 0F850300                 jne @@process170
  4579 000029A5 E834F8                   call immeerror
  4580                                  
  4581                                  ;-56     Optemp = Op1;    
  4582                                  
  4583                                  @@process170:
  4584 000029A8 A0[B601]                 mov al, [Op1]
  4585 000029AB A2[B701]                 mov byte [Optemp], al
  4586                                  
  4587                                  ;-57     R1No=RegNo;   
  4588                                  
  4589 000029AE A0[BC01]                 mov al, [RegNo]
  4590 000029B1 A2[BD01]                 mov byte [R1No], al
  4591                                  
  4592                                  ;-58     R1Type = RegType;
  4593                                  
  4594 000029B4 A0[BE01]                 mov al, [RegType]
  4595 000029B7 A2[BF01]                 mov byte [R1Type], al
  4596                                  
  4597                                  ;-59     need(',');    
  4598                                  
  4599 000029BA 6A2C                     push 44
  4600 000029BC E865ED                   call need
  4601 000029BF 83C402                   add  sp, 2
  4602                                  
  4603                                  ;-60     getOp();  
  4604                                  
  4605 000029C2 E85A01                   call getOp
  4606                                  
  4607                                  ;-61     if (Op1 == IMM) {
  4608                                  
  4609 000029C5 A0[B601]                 mov al, [Op1]
  4610 000029C8 3C01                     cmp al, 1
  4611 000029CA 0F850000                 jne @@process171
  4612                                  
  4613                                  ;-62              
  4614                                  
  4615                                  
  4616                                  ;-63     }
  4617                                  
  4618                                  
  4619                                  ;-64 
  4620                                  
  4621                                  
  4622                                  ;-65     writeEA(R1No);           
  4623                                  
  4624                                  @@process171:
  4625 000029CE A0[BD01]                 mov al, byte [R1No]
  4626 000029D1 B400                     mov ah, 0
  4627 000029D3 50                       push ax
  4628 000029D4 E882FD                   call writeEA
  4629 000029D7 83C402                   add  sp, 2
  4630                                  
  4631                                  ;-66     return;
  4632                                  
  4633 000029DA E96700                   jmp @@retn
  4634                                  
  4635                                  ;-67   }
  4636                                  
  4637                                  
  4638                                  ;-68    
  4639                                  
  4640                                  
  4641                                  ;-69   if (CodeType ==  8) {//ret,retf
  4642                                  
  4643                                  @@process169:
  4644 000029DD A0[B801]                 mov al, [CodeType]
  4645 000029E0 3C08                     cmp al, 8
  4646 000029E2 0F853100                 jne @@process172
  4647                                  
  4648                                  ;-70     if (TokeType == DIGIT) {
  4649                                  
  4650 000029E6 A0[B501]                 mov al, [TokeType]
  4651 000029E9 3C01                     cmp al, 1
  4652 000029EB 0F851900                 jne @@process173
  4653                                  
  4654                                  ;-71       genCode8(Code2);
  4655                                  
  4656 000029EF A0[BA01]                 mov al, byte [Code2]
  4657 000029F2 B400                     mov ah, 0
  4658 000029F4 50                       push ax
  4659 000029F5 E8EAFC                   call genCode8
  4660 000029F8 83C402                   add  sp, 2
  4661                                  
  4662                                  ;-72       genCode16(SymbolInt);
  4663                                  
  4664 000029FB FF36[5700]               push word [SymbolInt]
  4665 000029FF E836FD                   call genCode16
  4666 00002A02 83C402                   add  sp, 2
  4667                                  
  4668                                  ;-73       return;
  4669                                  
  4670 00002A05 E93C00                   jmp @@retn
  4671                                  
  4672                                  ;-74     }
  4673                                  
  4674                                  
  4675                                  ;-75     genCode8(Code1); 
  4676                                  
  4677                                  @@process173:
  4678 00002A08 A0[B901]                 mov al, byte [Code1]
  4679 00002A0B B400                     mov ah, 0
  4680 00002A0D 50                       push ax
  4681 00002A0E E8D1FC                   call genCode8
  4682 00002A11 83C402                   add  sp, 2
  4683                                  
  4684                                  ;-76     return;
  4685                                  
  4686 00002A14 E92D00                   jmp @@retn
  4687                                  
  4688                                  ;-77   }
  4689                                  
  4690                                  
  4691                                  ;-78 
  4692                                  
  4693                                  
  4694                                  ;-79   if (CodeType==101) {// ORG nn
  4695                                  
  4696                                  @@process172:
  4697 00002A17 A0[B801]                 mov al, [CodeType]
  4698 00002A1A 3C65                     cmp al, 101
  4699 00002A1C 0F851B00                 jne @@process174
  4700                                  
  4701                                  ;-80     if (TokeType != DIGIT) error1("only digit allowed");
  4702                                  
  4703 00002A20 A0[B501]                 mov al, [TokeType]
  4704 00002A23 3C01                     cmp al, 1
  4705 00002A25 0F840900                 je  @@process175
  4706 00002A29 68[452A]                 push process_0
  4707 00002A2C E818F7                   call error1
  4708 00002A2F 83C402                   add  sp, 2
  4709                                  
  4710                                  ;-81     PC=SymbolInt;return;
  4711                                  
  4712                                  @@process175:
  4713 00002A32 A1[5700]                 mov ax, [SymbolInt]
  4714 00002A35 A3[B001]                 mov word [PC], ax
  4715 00002A38 E90900                   jmp @@retn
  4716                                  
  4717                                  ;-82   }
  4718                                  
  4719                                  
  4720                                  ;-83   error1("unknown CodeType");
  4721                                  
  4722                                  @@process174:
  4723 00002A3B 68[582A]                 push process_1
  4724 00002A3E E806F7                   call error1
  4725 00002A41 83C402                   add  sp, 2
  4726                                  
  4727                                  ;-84 }    
  4728                                  
  4729                                  
  4730                                  ;-85 /*        Op      = 0, IMM, REG, ADR, MEM
  4731                                  
  4732                                  
  4733                                  ;-86 IMM       imme    = 0, SymbolInt    
  4734                                  
  4735                                  
  4736                                  ;-87 REG     R RegNo   = 0 - 7
  4737                                  
  4738                                  
  4739                                  ;-88 REG     R RegType = 0, BYTE, WORD, DWORD, SEGREG 
  4740                                  
  4741                                  
  4742                                  ;-89 MEM,ADR   disp    = 0,LabelAddr[LabelIx]
  4743                                  
  4744                                  
  4745                                  ;-90 MEM       regindexbase = 0 - 7
  4746                                  
  4747                                  
  4748                                  ;-91           OpSize  = 0, BYTE, WORD, DWORD (set wflag) */
  4749                                  
  4750                                  
  4751                                  ;-92 
  4752                                  
  4753                                  
  4754                                  ;-93 int checkOp() {
  4755                                  
  4756                                  @@retn:
  4757 00002A44 C3                       ret
  4758                                  ; ENDP
  4759 00002A45 6F6E6C792064696769-     process_0 db "only digit allowed",0
  4760 00002A4E 7420616C6C6F776564-
  4761 00002A57 00                 
  4762 00002A58 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  4763 00002A61 6F64655479706500   
  4764                                  
  4765                                  checkOp:  ; *** PROC ***
  4766                                  
  4767                                  ;-94   getOp();
  4768                                  
  4769 00002A69 E8B300                   call getOp
  4770                                  
  4771                                  ;-95   if (Op1 == ADR) implerror();
  4772                                  
  4773 00002A6C A0[B601]                 mov al, [Op1]
  4774 00002A6F 3C03                     cmp al, 3
  4775 00002A71 0F850300                 jne @@checkOp176
  4776 00002A75 E889F7                   call implerror
  4777                                  
  4778                                  ;-96   if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  4779                                  
  4780                                  @@checkOp176:
  4781 00002A78 A0[BE01]                 mov al, [RegType]
  4782 00002A7B 3C04                     cmp al, 4
  4783 00002A7D 0F850600                 jne @@checkOp177
  4784 00002A81 E845F8                   call segregerror
  4785 00002A84 E95300                   jmp @@retn
  4786                                  
  4787                                  ;-97   setwflag();
  4788                                  
  4789                                  @@checkOp177:
  4790 00002A87 E84801                   call setwflag
  4791                                  
  4792                                  ;-98   if (OpSize == 0) error1("no op size declared");
  4793                                  
  4794 00002A8A A0[C001]                 mov al, [OpSize]
  4795 00002A8D 3C00                     cmp al, 0
  4796 00002A8F 0F850900                 jne @@checkOp178
  4797 00002A93 68[DB2A]                 push checkOp_0
  4798 00002A96 E8AEF6                   call error1
  4799 00002A99 83C402                   add  sp, 2
  4800                                  
  4801                                  ;-99   if (OpSize == RegType) return;
  4802                                  
  4803                                  @@checkOp178:
  4804 00002A9C A0[C001]                 mov al, [OpSize]
  4805 00002A9F 3A06[BE01]               cmp al, [RegType]
  4806 00002AA3 0F850300                 jne @@checkOp179
  4807 00002AA7 E93000                   jmp @@retn
  4808                                  
  4809                                  ;-100   if (OpSize){if (Op1 == MEM) return;
  4810                                  
  4811                                  @@checkOp179:
  4812 00002AAA A0[C001]                 mov al, [OpSize]
  4813 00002AAD 08C0                     or  al, al
  4814 00002AAF 0F841500                 je @@checkOp180
  4815 00002AB3 A0[B601]                 mov al, [Op1]
  4816 00002AB6 3C04                     cmp al, 4
  4817 00002AB8 0F850300                 jne @@checkOp181
  4818 00002ABC E91B00                   jmp @@retn
  4819                                  
  4820                                  ;-101     error1("Conflict OpSize and RegSize"); }
  4821                                  
  4822                                  @@checkOp181:
  4823 00002ABF 68[EF2A]                 push checkOp_1
  4824 00002AC2 E882F6                   call error1
  4825 00002AC5 83C402                   add  sp, 2
  4826                                  
  4827                                  ;-102   if (RegType==0) error1("no register defined");
  4828                                  
  4829                                  @@checkOp180:
  4830 00002AC8 A0[BE01]                 mov al, [RegType]
  4831 00002ACB 3C00                     cmp al, 0
  4832 00002ACD 0F850900                 jne @@checkOp182
  4833 00002AD1 68[0B2B]                 push checkOp_2
  4834 00002AD4 E870F6                   call error1
  4835 00002AD7 83C402                   add  sp, 2
  4836                                  
  4837                                  ;-103 }
  4838                                  
  4839                                  @@checkOp182:
  4840                                  
  4841                                  ;-104 
  4842                                  
  4843                                  
  4844                                  ;-105 int getOp() {
  4845                                  
  4846                                  @@retn:
  4847 00002ADA C3                       ret
  4848                                  ; ENDP
  4849 00002ADB 6E6F206F702073697A-     checkOp_0 db "no op size declared",0
  4850 00002AE4 65206465636C617265-
  4851 00002AED 6400               
  4852 00002AEF 436F6E666C69637420-     checkOp_1 db "Conflict OpSize and RegSize",0
  4853 00002AF8 4F7053697A6520616E-
  4854 00002B01 642052656753697A65-
  4855 00002B0A 00                 
  4856 00002B0B 6E6F20726567697374-     checkOp_2 db "no register defined",0
  4857 00002B14 657220646566696E65-
  4858 00002B1D 6400               
  4859                                  
  4860                                  getOp:  ; *** PROC ***
  4861                                  
  4862                                  ;-106 //set: op1=0,IMM,REG,ADR,MEM
  4863                                  
  4864                                  
  4865                                  ;-107   disp=0; imme=0; regindexbase=0; isDirect=1;
  4866                                  
  4867 00002B1F 66B800000000             mov eax, 0
  4868 00002B25 A3[C401]                 mov word [disp], ax
  4869 00002B28 66B800000000             mov eax, 0
  4870 00002B2E A3[C601]                 mov word [imme], ax
  4871 00002B31 66B800000000             mov eax, 0
  4872 00002B37 A2[C201]                 mov byte [regindexbase], al
  4873 00002B3A 66B801000000             mov eax, 1
  4874 00002B40 A2[C301]                 mov byte [isDirect], al
  4875                                  
  4876                                  ;-108 
  4877                                  
  4878                                  
  4879                                  ;-109   Op1=getOp1();
  4880                                  
  4881 00002B43 E8E700                   call getOp1
  4882 00002B46 A2[B601]                 mov byte [Op1], al
  4883                                  
  4884                                  ;-110   if (isToken('[')) {Op1 = MEM; getMEM();    return;}
  4885                                  
  4886 00002B49 6A5B                     push 91
  4887 00002B4B E8A8EB                   call isToken
  4888 00002B4E 83C402                   add  sp, 2
  4889 00002B51 08C0                     or  al, al
  4890 00002B53 0F840F00                 je @@getOp183
  4891 00002B57 66B804000000             mov eax, 4
  4892 00002B5D A2[B601]                 mov byte [Op1], al
  4893 00002B60 E85001                   call getMEM
  4894 00002B63 E94F00                   jmp @@retn
  4895                                  
  4896                                  ;-111   if (Op1 == 0)     {invaloperror();         return;}
  4897                                  
  4898                                  @@getOp183:
  4899 00002B66 A0[B601]                 mov al, [Op1]
  4900 00002B69 3C00                     cmp al, 0
  4901 00002B6B 0F850600                 jne @@getOp184
  4902 00002B6F E8CAF6                   call invaloperror
  4903 00002B72 E94000                   jmp @@retn
  4904                                  
  4905                                  ;-112   if (Op1 == IMM)   {imme=SymbolInt;         return;}
  4906                                  
  4907                                  @@getOp184:
  4908 00002B75 A0[B601]                 mov al, [Op1]
  4909 00002B78 3C01                     cmp al, 1
  4910 00002B7A 0F850900                 jne @@getOp185
  4911 00002B7E A1[5700]                 mov ax, [SymbolInt]
  4912 00002B81 A3[C601]                 mov word [imme], ax
  4913 00002B84 E92E00                   jmp @@retn
  4914                                  
  4915                                  ;-113   if (Op1 == REG)                            return;
  4916                                  
  4917                                  @@getOp185:
  4918 00002B87 A0[B601]                 mov al, [Op1]
  4919 00002B8A 3C02                     cmp al, 2
  4920 00002B8C 0F850300                 jne @@getOp186
  4921 00002B90 E92200                   jmp @@retn
  4922                                  
  4923                                  ;-114   if (Op1 == ADR)   {disp=LabelAddr[LabelIx];return;}
  4924                                  
  4925                                  @@getOp186:
  4926 00002B93 A0[B601]                 mov al, [Op1]
  4927 00002B96 3C03                     cmp al, 3
  4928 00002B98 0F851000                 jne @@getOp187
  4929 00002B9C 8B1E[8606]               mov bx, [LabelIx]
  4930 00002BA0 D1E3                     shl bx, 1
  4931 00002BA2 8B87[BC05]               mov ax, [LabelAddr + bx]
  4932 00002BA6 A3[C401]                 mov word [disp], ax
  4933 00002BA9 E90900                   jmp @@retn
  4934                                  
  4935                                  ;-115   error1("Name of operand expected #1");
  4936                                  
  4937                                  @@getOp187:
  4938 00002BAC 68[B62B]                 push getOp_0
  4939 00002BAF E895F5                   call error1
  4940 00002BB2 83C402                   add  sp, 2
  4941                                  
  4942                                  ;-116 }
  4943                                  
  4944                                  
  4945                                  ;-117 
  4946                                  
  4947                                  
  4948                                  ;-118 int setwflag() {
  4949                                  
  4950                                  @@retn:
  4951 00002BB5 C3                       ret
  4952                                  ; ENDP
  4953 00002BB6 4E616D65206F66206F-     getOp_0 db "Name of operand expected #1",0
  4954 00002BBF 706572616E64206578-
  4955 00002BC8 706563746564202331-
  4956 00002BD1 00                 
  4957                                  
  4958                                  setwflag:  ; *** PROC ***
  4959                                  
  4960                                  ;-119   wflag=0;
  4961                                  
  4962 00002BD2 66B800000000             mov eax, 0
  4963 00002BD8 A2[C101]                 mov byte [wflag], al
  4964                                  
  4965                                  ;-120   if (OpSize == 0) {//do not override OpSize
  4966                                  
  4967 00002BDB A0[C001]                 mov al, [OpSize]
  4968 00002BDE 3C00                     cmp al, 0
  4969 00002BE0 0F852100                 jne @@setwflag188
  4970                                  
  4971                                  ;-121     if (Op1 == REG) {
  4972                                  
  4973 00002BE4 A0[B601]                 mov al, [Op1]
  4974 00002BE7 3C02                     cmp al, 2
  4975 00002BE9 0F851800                 jne @@setwflag189
  4976                                  
  4977                                  ;-122       OpSize=RegType;
  4978                                  
  4979 00002BED A0[BE01]                 mov al, [RegType]
  4980 00002BF0 A2[C001]                 mov byte [OpSize], al
  4981                                  
  4982                                  ;-123       if (RegType == SEGREG) OpSize=WORD;
  4983                                  
  4984 00002BF3 A0[BE01]                 mov al, [RegType]
  4985 00002BF6 3C04                     cmp al, 4
  4986 00002BF8 0F850900                 jne @@setwflag190
  4987 00002BFC 66B802000000             mov eax, 2
  4988 00002C02 A2[C001]                 mov byte [OpSize], al
  4989                                  
  4990                                  ;-124     }
  4991                                  
  4992                                  @@setwflag190:
  4993                                  
  4994                                  ;-125   }
  4995                                  
  4996                                  @@setwflag189:
  4997                                  
  4998                                  ;-126   if (OpSize  == DWORD) {gen66h(); wflag=1;}
  4999                                  
  5000                                  @@setwflag188:
  5001 00002C05 A0[C001]                 mov al, [OpSize]
  5002 00002C08 3C03                     cmp al, 3
  5003 00002C0A 0F850C00                 jne @@setwflag191
  5004 00002C0E E8ADFA                   call gen66h
  5005 00002C11 66B801000000             mov eax, 1
  5006 00002C17 A2[C101]                 mov byte [wflag], al
  5007                                  
  5008                                  ;-127   if (OpSize  ==  WORD) wflag=1;
  5009                                  
  5010                                  @@setwflag191:
  5011 00002C1A A0[C001]                 mov al, [OpSize]
  5012 00002C1D 3C02                     cmp al, 2
  5013 00002C1F 0F850900                 jne @@setwflag192
  5014 00002C23 66B801000000             mov eax, 1
  5015 00002C29 A2[C101]                 mov byte [wflag], al
  5016                                  
  5017                                  ;-128 }
  5018                                  
  5019                                  @@setwflag192:
  5020                                  
  5021                                  ;-129 
  5022                                  
  5023                                  
  5024                                  ;-130 int getOp1() {//scan for a single operand
  5025                                  
  5026 00002C2C C3                       ret
  5027                                  ; ENDP
  5028                                  
  5029                                  getOp1:  ; *** PROC ***
  5030                                  
  5031                                  ;-131 //return:0, IMM, REG, ADR (not MEM)
  5032                                  
  5033                                  
  5034                                  ;-132 //set   :RegType, RegNo by testReg
  5035                                  
  5036                                  
  5037                                  ;-133 //set   :LabelIx by searchLabel
  5038                                  
  5039                                  
  5040                                  ;-134   if (TokeType == 0)      return 0;
  5041                                  
  5042 00002C2D A0[B501]                 mov al, [TokeType]
  5043 00002C30 3C00                     cmp al, 0
  5044 00002C32 0F850900                 jne @@getOp1193
  5045 00002C36 66B800000000             mov eax, 0
  5046 00002C3C E96000                   jmp @@retn
  5047                                  
  5048                                  ;-135   if (TokeType == DIGIT)  return IMM;
  5049                                  
  5050                                  @@getOp1193:
  5051 00002C3F A0[B501]                 mov al, [TokeType]
  5052 00002C42 3C01                     cmp al, 1
  5053 00002C44 0F850900                 jne @@getOp1194
  5054 00002C48 66B801000000             mov eax, 1
  5055 00002C4E E94E00                   jmp @@retn
  5056                                  
  5057                                  ;-136   if (TokeType == ALNUME) {
  5058                                  
  5059                                  @@getOp1194:
  5060 00002C51 A0[B501]                 mov al, [TokeType]
  5061 00002C54 3C03                     cmp al, 3
  5062 00002C56 0F853C00                 jne @@getOp1195
  5063                                  
  5064                                  ;-137     RegNo=testReg();
  5065                                  
  5066 00002C5A E843EE                   call testReg
  5067 00002C5D A2[BC01]                 mov byte [RegNo], al
  5068                                  
  5069                                  ;-138     if (RegType)          return REG;
  5070                                  
  5071 00002C60 A0[BE01]                 mov al, [RegType]
  5072 00002C63 08C0                     or  al, al
  5073 00002C65 0F840900                 je @@getOp1196
  5074 00002C69 66B802000000             mov eax, 2
  5075 00002C6F E92D00                   jmp @@retn
  5076                                  
  5077                                  ;-139     LabelIx=searchLabel();
  5078                                  
  5079                                  @@getOp1196:
  5080 00002C72 E8ECE7                   call searchLabel
  5081 00002C75 A3[8606]                 mov word [LabelIx], ax
  5082                                  
  5083                                  ;-140     if (LabelIx)          return ADR;
  5084                                  
  5085 00002C78 A1[8606]                 mov ax, [LabelIx]
  5086 00002C7B 08C0                     or  al, al
  5087 00002C7D 0F840C00                 je @@getOp1197
  5088 00002C81 66B803000000             mov eax, 3
  5089 00002C87 E91500                   jmp @@retn
  5090                                  
  5091                                  ;-141     else error1("variable not found"); 
  5092                                  
  5093 00002C8A E90900                   jmp @@getOp1198
  5094                                  @@getOp1197:
  5095 00002C8D 68[A02C]                 push getOp1_0
  5096 00002C90 E8B4F4                   call error1
  5097 00002C93 83C402                   add  sp, 2
  5098                                  
  5099                                  ;-142   }
  5100                                  
  5101                                  @@getOp1198:
  5102                                  
  5103                                  ;-143   return 0;
  5104                                  
  5105                                  @@getOp1195:
  5106 00002C96 66B800000000             mov eax, 0
  5107 00002C9C E90000                   jmp @@retn
  5108                                  
  5109                                  ;-144 }
  5110                                  
  5111                                  
  5112                                  ;-145 
  5113                                  
  5114                                  
  5115                                  ;-146 int getMEM() {// e.g. [array+bp+si-4]
  5116                                  
  5117                                  @@retn:
  5118 00002C9F C3                       ret
  5119                                  ; ENDP
  5120 00002CA0 7661726961626C6520-     getOp1_0 db "variable not found",0
  5121 00002CA9 6E6F7420666F756E64-
  5122 00002CB2 00                 
  5123                                  
  5124                                  getMEM:  ; *** PROC ***
  5125                                  
  5126                                  ;-147 //set: disp, regindexbase, RegType
  5127                                  
  5128                                  
  5129                                  ;-148   char op2;
  5130                                  
  5131                                  
  5132                                  ;-149   disp=0; regindexbase=0; RegType=0;
  5133                                  
  5134                                  ;Function : getMEM, Number of local variables: 1
  5135                                  ;   # type sign width line used address name   list of local variables
  5136                                  ;  200 var sign byte   148 NULL bp-2    op2;
  5137 00002CB3 C8020000                 ENTER  2,0
  5138 00002CB7 66B800000000             mov eax, 0
  5139 00002CBD A3[C401]                 mov word [disp], ax
  5140 00002CC0 66B800000000             mov eax, 0
  5141 00002CC6 A2[C201]                 mov byte [regindexbase], al
  5142 00002CC9 66B800000000             mov eax, 0
  5143 00002CCF A2[BE01]                 mov byte [RegType], al
  5144                                  
  5145                                  ;-150   do {
  5146                                  
  5147                                  @@getMEM199:
  5148                                  
  5149                                  ;-151     getTokeType();
  5150                                  
  5151 00002CD2 E84BE6                   call getTokeType
  5152                                  
  5153                                  ;-152     op2=getOp1();
  5154                                  
  5155 00002CD5 E855FF                   call getOp1
  5156 00002CD8 8846FE                   mov byte [bp-2], al
  5157                                  
  5158                                  ;-153     if (op2 ==   0) syntaxerror();
  5159                                  
  5160 00002CDB 8A46FE                   mov al, [bp-2]
  5161 00002CDE 3C00                     cmp al, 0
  5162 00002CE0 0F850300                 jne @@getMEM200
  5163 00002CE4 E809F6                   call syntaxerror
  5164                                  
  5165                                  ;-154     if (op2 == REG) {isDirect=0;
  5166                                  
  5167                                  @@getMEM200:
  5168 00002CE7 8A46FE                   mov al, [bp-2]
  5169 00002CEA 3C02                     cmp al, 2
  5170 00002CEC 0F851E00                 jne @@getMEM201
  5171 00002CF0 66B800000000             mov eax, 0
  5172 00002CF6 A2[C301]                 mov byte [isDirect], al
  5173                                  
  5174                                  ;-155                       if (regindexbase) regindexbase=getIndReg2();
  5175                                  
  5176 00002CF9 A0[C201]                 mov al, [regindexbase]
  5177 00002CFC 08C0                     or  al, al
  5178 00002CFE 0F840900                 je @@getMEM202
  5179 00002D02 E8F300                   call getIndReg2
  5180 00002D05 A2[C201]                 mov byte [regindexbase], al
  5181                                  
  5182                                  ;-156                       else getIndReg1();
  5183                                  
  5184 00002D08 E90300                   jmp @@getMEM203
  5185                                  @@getMEM202:
  5186 00002D0B E88900                   call getIndReg1
  5187                                  
  5188                                  ;-157                     }
  5189                                  
  5190                                  @@getMEM203:
  5191                                  
  5192                                  ;-158     if (op2 == ADR) disp=disp+LabelAddr[LabelIx];
  5193                                  
  5194                                  @@getMEM201:
  5195 00002D0E 8A46FE                   mov al, [bp-2]
  5196 00002D11 3C03                     cmp al, 3
  5197 00002D13 0F851000                 jne @@getMEM204
  5198 00002D17 A1[C401]                 mov ax, [disp]
  5199 00002D1A 8B1E[8606]               mov bx, [LabelIx]
  5200 00002D1E D1E3                     shl bx, 1
  5201 00002D20 0387[BC05]               add ax, [LabelAddr + bx]
  5202 00002D24 A3[C401]                 mov word [disp], ax
  5203                                  
  5204                                  ;-159     if (op2 == IMM) disp=disp+SymbolInt;
  5205                                  
  5206                                  @@getMEM204:
  5207 00002D27 8A46FE                   mov al, [bp-2]
  5208 00002D2A 3C01                     cmp al, 1
  5209 00002D2C 0F850A00                 jne @@getMEM205
  5210 00002D30 A1[C401]                 mov ax, [disp]
  5211 00002D33 0306[5700]               add ax, [SymbolInt]
  5212 00002D37 A3[C401]                 mov word [disp], ax
  5213                                  
  5214                                  ;-160     if (isToken('-')) {
  5215                                  
  5216                                  @@getMEM205:
  5217 00002D3A 6A2D                     push 45
  5218 00002D3C E8B7E9                   call isToken
  5219 00002D3F 83C402                   add  sp, 2
  5220 00002D42 08C0                     or  al, al
  5221 00002D44 0F841900                 je @@getMEM206
  5222                                  
  5223                                  ;-161       getTokeType();
  5224                                  
  5225 00002D48 E8D5E5                   call getTokeType
  5226                                  
  5227                                  ;-162       if (TokeType != DIGIT) numbererror();
  5228                                  
  5229 00002D4B A0[B501]                 mov al, [TokeType]
  5230 00002D4E 3C01                     cmp al, 1
  5231 00002D50 0F840300                 je  @@getMEM207
  5232 00002D54 E806F5                   call numbererror
  5233                                  
  5234                                  ;-163       disp = disp - SymbolInt;
  5235                                  
  5236                                  @@getMEM207:
  5237 00002D57 A1[C401]                 mov ax, [disp]
  5238 00002D5A 2B06[5700]               sub ax, [SymbolInt]
  5239 00002D5E A3[C401]                 mov word [disp], ax
  5240                                  
  5241                                  ;-164     }
  5242                                  
  5243                                  
  5244                                  ;-165   } while (isToken('+'));
  5245                                  
  5246                                  @@getMEM206:
  5247 00002D61 6A2B                     push 43
  5248 00002D63 E890E9                   call isToken
  5249 00002D66 83C402                   add  sp, 2
  5250 00002D69 08C0                     or  al, al
  5251 00002D6B 0F840300                 je @@getMEM208
  5252 00002D6F E960FF                   jmp @@getMEM199
  5253                                  @@getMEM208:
  5254                                  
  5255                                  ;-166   if (isToken(']') == 0) errorexit("] expected");
  5256                                  
  5257 00002D72 6A5D                     push 93
  5258 00002D74 E87FE9                   call isToken
  5259 00002D77 83C402                   add  sp, 2
  5260 00002D7A 83F800                   cmp ax, 0
  5261 00002D7D 0F850900                 jne @@getMEM209
  5262 00002D81 68[8C2D]                 push getMEM_0
  5263 00002D84 E87AF5                   call errorexit
  5264 00002D87 83C402                   add  sp, 2
  5265                                  
  5266                                  ;-167 }
  5267                                  
  5268                                  @@getMEM209:
  5269                                  
  5270                                  ;-168 int getIndReg1() {
  5271 00002D8A C9                       LEAVE
  5272 00002D8B C3                       ret
  5273                                  ; ENDP
  5274 00002D8C 5D2065787065637465-     getMEM_0 db "] expected",0
  5275 00002D95 6400               
  5276                                  
  5277                                  getIndReg1:  ; *** PROC ***
  5278                                  
  5279                                  ;-169   if (RegType !=WORD) indexerror();
  5280                                  
  5281 00002D97 A0[BE01]                 mov al, [RegType]
  5282 00002D9A 3C02                     cmp al, 2
  5283 00002D9C 0F840300                 je  @@getIndReg1210
  5284 00002DA0 E878F4                   call indexerror
  5285                                  
  5286                                  ;-170   if (RegNo==3) regindexbase=7;//BX
  5287                                  
  5288                                  @@getIndReg1210:
  5289 00002DA3 A0[BC01]                 mov al, [RegNo]
  5290 00002DA6 3C03                     cmp al, 3
  5291 00002DA8 0F850900                 jne @@getIndReg1211
  5292 00002DAC 66B807000000             mov eax, 7
  5293 00002DB2 A2[C201]                 mov byte [regindexbase], al
  5294                                  
  5295                                  ;-171   if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5296                                  
  5297                                  @@getIndReg1211:
  5298 00002DB5 A0[BC01]                 mov al, [RegNo]
  5299 00002DB8 3C05                     cmp al, 5
  5300 00002DBA 0F850900                 jne @@getIndReg1212
  5301 00002DBE 66B806000000             mov eax, 6
  5302 00002DC4 A2[C201]                 mov byte [regindexbase], al
  5303                                  
  5304                                  ;-172   if (RegNo==7) regindexbase=5;//DI
  5305                                  
  5306                                  @@getIndReg1212:
  5307 00002DC7 A0[BC01]                 mov al, [RegNo]
  5308 00002DCA 3C07                     cmp al, 7
  5309 00002DCC 0F850900                 jne @@getIndReg1213
  5310 00002DD0 66B805000000             mov eax, 5
  5311 00002DD6 A2[C201]                 mov byte [regindexbase], al
  5312                                  
  5313                                  ;-173   if (RegNo==6) regindexbase=4;//SI
  5314                                  
  5315                                  @@getIndReg1213:
  5316 00002DD9 A0[BC01]                 mov al, [RegNo]
  5317 00002DDC 3C06                     cmp al, 6
  5318 00002DDE 0F850900                 jne @@getIndReg1214
  5319 00002DE2 66B804000000             mov eax, 4
  5320 00002DE8 A2[C201]                 mov byte [regindexbase], al
  5321                                  
  5322                                  ;-174   if (regindexbase==0) indexerror();
  5323                                  
  5324                                  @@getIndReg1214:
  5325 00002DEB A0[C201]                 mov al, [regindexbase]
  5326 00002DEE 3C00                     cmp al, 0
  5327 00002DF0 0F850300                 jne @@getIndReg1215
  5328 00002DF4 E824F4                   call indexerror
  5329                                  
  5330                                  ;-175 }
  5331                                  
  5332                                  @@getIndReg1215:
  5333                                  
  5334                                  ;-176 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5335                                  
  5336 00002DF7 C3                       ret
  5337                                  ; ENDP
  5338                                  
  5339                                  getIndReg2:  ; *** PROC ***
  5340                                  ;Function : getIndReg2, Number of local variables: 1
  5341                                  ;   # type sign width line used address name   list of local variables
  5342                                  ;  200 var sign byte   176 NULL bp-2    m;
  5343 00002DF8 C8020000                 ENTER  2,0
  5344 00002DFC 66B804000000             mov eax, 4
  5345 00002E02 8846FE                   mov byte [bp-2], al
  5346                                  
  5347                                  ;-177   if (RegType !=WORD) indexerror();
  5348                                  
  5349 00002E05 A0[BE01]                 mov al, [RegType]
  5350 00002E08 3C02                     cmp al, 2
  5351 00002E0A 0F840300                 je  @@getIndReg2216
  5352 00002E0E E80AF4                   call indexerror
  5353                                  
  5354                                  ;-178   if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5355                                  
  5356                                  @@getIndReg2216:
  5357 00002E11 A0[BC01]                 mov al, [RegNo]
  5358 00002E14 3C07                     cmp al, 7
  5359 00002E16 0F852700                 jne @@getIndReg2217
  5360 00002E1A A0[C201]                 mov al, [regindexbase]
  5361 00002E1D 3C06                     cmp al, 6
  5362 00002E1F 0F850C00                 jne @@getIndReg2218
  5363 00002E23 66B803000000             mov eax, 3
  5364 00002E29 8846FE                   mov byte [bp-2], al
  5365                                  
  5366                                  ;-179            else if (regindexbase==7) m=1;//BX+DI
  5367                                  
  5368 00002E2C E91200                   jmp @@getIndReg2219
  5369                                  @@getIndReg2218:
  5370 00002E2F A0[C201]                 mov al, [regindexbase]
  5371 00002E32 3C07                     cmp al, 7
  5372 00002E34 0F850900                 jne @@getIndReg2220
  5373 00002E38 66B801000000             mov eax, 1
  5374 00002E3E 8846FE                   mov byte [bp-2], al
  5375                                  
  5376                                  ;-180   if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5377                                  
  5378                                  @@getIndReg2220:
  5379                                  @@getIndReg2219:
  5380                                  @@getIndReg2217:
  5381 00002E41 A0[BC01]                 mov al, [RegNo]
  5382 00002E44 3C06                     cmp al, 6
  5383 00002E46 0F852700                 jne @@getIndReg2221
  5384 00002E4A A0[C201]                 mov al, [regindexbase]
  5385 00002E4D 3C06                     cmp al, 6
  5386 00002E4F 0F850C00                 jne @@getIndReg2222
  5387 00002E53 66B802000000             mov eax, 2
  5388 00002E59 8846FE                   mov byte [bp-2], al
  5389                                  
  5390                                  ;-181            else if (regindexbase==7) m=0;//BX+SI
  5391                                  
  5392 00002E5C E91200                   jmp @@getIndReg2223
  5393                                  @@getIndReg2222:
  5394 00002E5F A0[C201]                 mov al, [regindexbase]
  5395 00002E62 3C07                     cmp al, 7
  5396 00002E64 0F850900                 jne @@getIndReg2224
  5397 00002E68 66B800000000             mov eax, 0
  5398 00002E6E 8846FE                   mov byte [bp-2], al
  5399                                  
  5400                                  ;-182   if (m > 3) indexerror();
  5401                                  
  5402                                  @@getIndReg2224:
  5403                                  @@getIndReg2223:
  5404                                  @@getIndReg2221:
  5405 00002E71 8A46FE                   mov al, [bp-2]
  5406 00002E74 3C03                     cmp al, 3
  5407 00002E76 0F8E0300                 jle @@getIndReg2225
  5408 00002E7A E89EF3                   call indexerror
  5409                                  
  5410                                  ;-183   return m;
  5411                                  
  5412                                  @@getIndReg2225:
  5413 00002E7D 8A46FE                   mov al, [bp-2]
  5414 00002E80 E90000                   jmp @@retn
  5415                                  
  5416                                  ;-184 }
  5417                                  
  5418 00002E83 C9                      @@retn: LEAVE
  5419 00002E84 C3                       ret
  5420                                  ; ENDP
  5421                                   
  5422                                  ; missing functions: 
  5423                                  ; digit
  5424                                  ; strcpy
  5425                                  ; eqstr
  5426                                  ; strlen
  5427                                  ; eqstr
  5428                                  ; eqstr
  5429                                  ; eqstr
  5430                                  ; eqstr
  5431                                  ; readRL
  5432                                  ; readRL
  5433                                  ; digit
  5434                                  ; digit
  5435                                  ; strcpy
  5436                                  ; toupper
  5437                                  ; strlen
  5438                                  ; strlen
  5439                                  ; eqstr
  5440                                  ; eqstr
  5441                                  ; eqstr
  5442                                  ; eqstr
  5443                                  ; eqstr
  5444                                  ; eqstr
  5445                                  ; eqstr
  5446                                  ; eqstr
  5447                                  ; eqstr
  5448                                  ; eqstr
  5449                                  ; eqstr
  5450                                  ; eqstr
  5451                                  ; eqstr
  5452                                  ; eqstr
  5453                                  ; eqstr
  5454                                  ; eqstr
  5455                                  ; eqstr
  5456                                  ; eqstr
  5457                                  ; eqstr
  5458                                  ; eqstr
  5459                                  ; eqstr
  5460                                  ; eqstr
  5461                                  ; eqstr
  5462                                  ; eqstr
  5463                                  ; eqstr
  5464                                  ; eqstr
  5465                                  ; eqstr
  5466                                  ; eqstr
  5467                                  ; eqstr
  5468                                  ; eqstr
  5469                                  ; writetty
  5470                                  ; writetty
  5471                                  ; fputcR
  5472                                  ; cputs
  5473                                  ; cputs
  5474                                  ; exitR
  5475                                  ; toupper
  5476                                  ; strcpy
  5477                                  ; strcat1
  5478                                  ; strcpy
  5479                                  ; strcat1
  5480                                  ; strcpy
  5481                                  ; strcat1
  5482                                  ; openR
  5483                                  ; cputs
  5484                                  ; cputs
  5485                                  ; exitR
  5486                                  ; creatR
  5487                                  ; cputs
  5488                                  ; cputs
  5489                                  ; exitR
  5490                                  ; creatR
  5491                                  ; cputs
  5492                                  ; cputs
  5493                                  ; exitR
  5494                                  ; fputcR
  5495                                  ; fcloseR
  5496                                  ; fcloseR
  5497                                  ; fcloseR
  5498                                  ; exitR
  5499                                  ; Number of unresolved CALLs :   76
  5500                                  ;use archive file: AR.C
  5501                                  
  5502                                  ;-185 // AR.C Archive
  5503                                  
  5504                                  ;Number of CALLs:    2 : writetty
  5505                                  
  5506                                  writetty:  ; *** PROC ***
  5507 00002E85 B40E                     mov  ah, 14
  5508 00002E87 BB0000                   mov  bx, 0
  5509 00002E8A CD10                     int  16
  5510                                  
  5511                                  ;-186 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5512                                  
  5513 00002E8C C3                       ret
  5514                                  ; ENDP
  5515                                  ;Number of CALLs:    8 : cputs
  5516                                  
  5517                                  cputs:  ; *** PROC ***
  5518                                  ;Function : cputs, Number of local variables: 2
  5519                                  ;   # type sign width line used address name   list of local variables
  5520                                  ;  200 ptr sign byte   186 NULL bp+4    s
  5521                                  ;  201 var sign byte   186 NULL bp-2    c;
  5522 00002E8D C8020000                 ENTER  2,0
  5523                                  @@cputs226:
  5524 00002E91 8B5E04                   mov bx, [bp+4]
  5525 00002E94 8A07                     mov al, [bx]
  5526 00002E96 B400                     mov ah, 0
  5527 00002E98 08C0                     or  al, al
  5528 00002E9A 0F841B00                 je @@cputs227
  5529 00002E9E 8B5E04                   mov bx, [bp+4]
  5530 00002EA1 8A07                     mov al, [bx]
  5531 00002EA3 B400                     mov ah, 0
  5532 00002EA5 8846FE                   mov byte [bp-2], al
  5533 00002EA8 8A46FE                   mov al, byte [bp-2]
  5534 00002EAB B400                     mov ah, 0
  5535 00002EAD 50                       push ax
  5536 00002EAE E8C401                   call putch
  5537 00002EB1 83C402                   add  sp, 2
  5538 00002EB4 FF4604                   inc  word [bp+4]
  5539 00002EB7 EBD8                     jmp @@cputs226
  5540                                  @@cputs227:
  5541                                  
  5542                                  ;-187 int mkneg(int n) { n; __asm {neg ax} }
  5543 00002EB9 C9                       LEAVE
  5544 00002EBA C3                       ret
  5545                                  ; ENDP
  5546                                  ;Number of CALLs:    2 : toupper
  5547                                  
  5548                                  toupper:  ; *** PROC ***
  5549                                  ;Function : toupper, Number of local variables: 1
  5550                                  ;   # type sign width line used address name   list of local variables
  5551                                  ;  200 ptr sign byte   187 NULL bp+4    s;
  5552 00002EBB C8000000                 ENTER  0,0
  5553                                  @@toupper228:
  5554 00002EBF 8B5E04                   mov bx, [bp+4]
  5555 00002EC2 8A07                     mov al, [bx]
  5556 00002EC4 B400                     mov ah, 0
  5557 00002EC6 08C0                     or  al, al
  5558 00002EC8 0F843000                 je @@toupper229
  5559 00002ECC 8B5E04                   mov bx, [bp+4]
  5560 00002ECF 8A07                     mov al, [bx]
  5561 00002ED1 B400                     mov ah, 0
  5562 00002ED3 83F861                   cmp ax, 97 ;unsigned : 1
  5563 00002ED6 0F8C1D00                 jl  @@toupper230
  5564 00002EDA 8B5E04                   mov bx, [bp+4]
  5565 00002EDD 8A07                     mov al, [bx]
  5566 00002EDF B400                     mov ah, 0
  5567 00002EE1 83F87A                   cmp ax, 122
  5568 00002EE4 0F8F0F00                 jg  @@toupper231
  5569 00002EE8 8B5E04                   mov bx, [bp+4]
  5570 00002EEB 8A07                     mov al, [bx]
  5571 00002EED B400                     mov ah, 0
  5572 00002EEF 83E820                   sub ax, 32
  5573 00002EF2 8B5E04                   mov  bx, [bp+4]
  5574 00002EF5 8807                     mov  [bx], al
  5575                                  @@toupper231:
  5576                                  @@toupper230:
  5577 00002EF7 FF4604                   inc  word [bp+4]
  5578 00002EFA EBC3                     jmp @@toupper228
  5579                                  @@toupper229:
  5580                                  
  5581                                  ;-188 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  5582                                  
  5583                                  
  5584                                  ;-189 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  5585 00002EFC C9                       LEAVE
  5586 00002EFD C3                       ret
  5587                                  ; ENDP
  5588                                  ;Number of CALLs:    3 : strlen
  5589                                  
  5590                                  strlen:  ; *** PROC ***
  5591                                  ;Function : strlen, Number of local variables: 2
  5592                                  ;   # type sign width line used address name   list of local variables
  5593                                  ;  200 ptr sign byte   189 NULL bp+4    s
  5594                                  ;  201 var sign word   189 NULL bp-2    c;
  5595 00002EFE C8020000                 ENTER  2,0
  5596 00002F02 66B800000000             mov eax, 0
  5597 00002F08 8946FE                   mov word [bp-2], ax
  5598                                  @@strlen232:
  5599 00002F0B 8B5E04                   mov bx, [bp+4]
  5600 00002F0E 8A07                     mov al, [bx]
  5601 00002F10 B400                     mov ah, 0
  5602 00002F12 83F800                   cmp ax, 0
  5603 00002F15 0F840800                 je  @@strlen233
  5604 00002F19 FF4604                   inc  word [bp+4]
  5605 00002F1C FF46FE                   inc  word [bp-2]
  5606 00002F1F EBEA                     jmp @@strlen232
  5607                                  @@strlen233:
  5608 00002F21 8B46FE                   mov ax, [bp-2]
  5609 00002F24 E90000                   jmp @@retn
  5610                                  
  5611                                  ;-190 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  5612                                  
  5613 00002F27 C9                      @@retn: LEAVE
  5614 00002F28 C3                       ret
  5615                                  ; ENDP
  5616                                  ;Number of CALLs:    5 : strcpy
  5617                                  
  5618                                  strcpy:  ; *** PROC ***
  5619                                  ;Function : strcpy, Number of local variables: 2
  5620                                  ;   # type sign width line used address name   list of local variables
  5621                                  ;  200 ptr sign byte   190 NULL bp+4    s
  5622                                  ;  201 ptr sign byte   190 NULL bp+6    t;
  5623 00002F29 C8000000                 ENTER  0,0
  5624                                  @@strcpy234:
  5625 00002F2D 8B5E06                   mov bx, [bp+6]
  5626 00002F30 8A07                     mov al, [bx]
  5627 00002F32 B400                     mov ah, 0
  5628 00002F34 8B5E04                   mov  bx, [bp+4]
  5629 00002F37 8807                     mov  [bx], al
  5630 00002F39 FF4604                   inc  word [bp+4]
  5631 00002F3C FF4606                   inc  word [bp+6]
  5632                                  
  5633                                  ;-191   while (*t!=0); *s=0; return s; }
  5634                                  
  5635 00002F3F 8B5E06                   mov bx, [bp+6]
  5636 00002F42 8A07                     mov al, [bx]
  5637 00002F44 B400                     mov ah, 0
  5638 00002F46 83F800                   cmp ax, 0
  5639 00002F49 0F840200                 je  @@strcpy235
  5640 00002F4D EBDE                     jmp @@strcpy234
  5641                                  @@strcpy235:
  5642 00002F4F 66B800000000             mov eax, 0
  5643 00002F55 8B5E04                   mov  bx, [bp+4]
  5644 00002F58 8807                     mov  [bx], al
  5645 00002F5A 8B4604                   mov ax, [bp+4]
  5646 00002F5D E90000                   jmp @@retn
  5647                                  
  5648                                  ;-192 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  5649                                  
  5650 00002F60 C9                      @@retn: LEAVE
  5651 00002F61 C3                       ret
  5652                                  ; ENDP
  5653                                  ;Number of CALLs:    3 : digit
  5654                                  
  5655                                  digit:  ; *** PROC ***
  5656                                  ;Function : digit, Number of local variables: 1
  5657                                  ;   # type sign width line used address name   list of local variables
  5658                                  ;  200 var sign byte   192 NULL bp+4    c;
  5659 00002F62 C8000000                 ENTER  0,0
  5660 00002F66 8A4604                   mov al, [bp+4]
  5661 00002F69 3C30                     cmp al, 48
  5662 00002F6B 0F8D0900                 jge @@digit236
  5663 00002F6F 66B800000000             mov eax, 0
  5664 00002F75 E91B00                   jmp @@retn
  5665                                  @@digit236:
  5666 00002F78 8A4604                   mov al, [bp+4]
  5667 00002F7B 3C39                     cmp al, 57
  5668 00002F7D 0F8E0900                 jle @@digit237
  5669 00002F81 66B800000000             mov eax, 0
  5670 00002F87 E90900                   jmp @@retn
  5671                                  @@digit237:
  5672 00002F8A 66B801000000             mov eax, 1
  5673 00002F90 E90000                   jmp @@retn
  5674                                  
  5675                                  ;-193 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  5676                                  
  5677 00002F93 C9                      @@retn: LEAVE
  5678 00002F94 C3                       ret
  5679                                  ; ENDP
  5680                                  ;Number of CALLs:   35 : eqstr
  5681                                  
  5682                                  eqstr:  ; *** PROC ***
  5683                                  ;Function : eqstr, Number of local variables: 2
  5684                                  ;   # type sign width line used address name   list of local variables
  5685                                  ;  200 ptr sign byte   193 NULL bp+4    p
  5686                                  ;  201 ptr sign byte   193 NULL bp+6    q;
  5687 00002F95 C8000000                 ENTER  0,0
  5688                                  @@eqstr238:
  5689 00002F99 8B5E04                   mov bx, [bp+4]
  5690 00002F9C 8A07                     mov al, [bx]
  5691 00002F9E B400                     mov ah, 0
  5692 00002FA0 08C0                     or  al, al
  5693 00002FA2 0F842300                 je @@eqstr239
  5694                                  
  5695                                  ;-194     if (*p != *q) return 0; p++; q++; }
  5696                                  
  5697 00002FA6 8B5E04                   mov bx, [bp+4]
  5698 00002FA9 8A07                     mov al, [bx]
  5699 00002FAB B400                     mov ah, 0
  5700 00002FAD 8B5E06                   mov bx, [bp+6]
  5701 00002FB0 3A07                     cmp al, [bx]
  5702 00002FB2 B400                     mov ah, 0
  5703 00002FB4 0F840900                 je  @@eqstr240
  5704 00002FB8 66B800000000             mov eax, 0
  5705 00002FBE E92700                   jmp @@retn
  5706                                  @@eqstr240:
  5707 00002FC1 FF4604                   inc  word [bp+4]
  5708 00002FC4 FF4606                   inc  word [bp+6]
  5709                                  
  5710                                  ;-195     if(*q) return 0; return 1; }
  5711                                  
  5712 00002FC7 EBD0                     jmp @@eqstr238
  5713                                  @@eqstr239:
  5714 00002FC9 8B5E06                   mov bx, [bp+6]
  5715 00002FCC 8A07                     mov al, [bx]
  5716 00002FCE B400                     mov ah, 0
  5717 00002FD0 08C0                     or  al, al
  5718 00002FD2 0F840900                 je @@eqstr241
  5719 00002FD6 66B800000000             mov eax, 0
  5720 00002FDC E90900                   jmp @@retn
  5721                                  @@eqstr241:
  5722 00002FDF 66B801000000             mov eax, 1
  5723 00002FE5 E90000                   jmp @@retn
  5724                                  
  5725                                  ;-196 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  5726                                  
  5727 00002FE8 C9                      @@retn: LEAVE
  5728 00002FE9 C3                       ret
  5729                                  ; ENDP
  5730                                  ;Number of CALLs:    3 : strcat1
  5731                                  
  5732                                  strcat1:  ; *** PROC ***
  5733                                  ;Function : strcat1, Number of local variables: 2
  5734                                  ;   # type sign width line used address name   list of local variables
  5735                                  ;  200 ptr sign byte   196 NULL bp+4    s
  5736                                  ;  201 ptr sign byte   196 NULL bp+6    t;
  5737 00002FEA C8000000                 ENTER  0,0
  5738                                  @@strcat1242:
  5739 00002FEE 8B5E04                   mov bx, [bp+4]
  5740 00002FF1 8A07                     mov al, [bx]
  5741 00002FF3 B400                     mov ah, 0
  5742 00002FF5 83F800                   cmp ax, 0
  5743 00002FF8 0F840500                 je  @@strcat1243
  5744 00002FFC FF4604                   inc  word [bp+4]
  5745 00002FFF EBED                     jmp @@strcat1242
  5746                                  @@strcat1243:
  5747 00003001 FF7606                   push word [bp+6]
  5748 00003004 FF7604                   push word [bp+4]
  5749 00003007 E81FFF                   call strcpy
  5750 0000300A 83C404                   add  sp, 4
  5751                                  
  5752                                  ;-197 int basename(char *s) { char *p; p=0;
  5753 0000300D C9                       LEAVE
  5754 0000300E C3                       ret
  5755                                  ; ENDP
  5756                                  ;Number of CALLs:    1 : openR
  5757                                  
  5758                                  openR:  ; *** PROC ***
  5759                                  ;Function : openR, Number of local variables: 1
  5760                                  ;   # type sign width line used address name   list of local variables
  5761                                  ;  200 ptr sign byte   197 NULL bp+4    s;
  5762 0000300F C8000000                 ENTER  0,0
  5763 00003013 8B5604                   mov  dx, [bp+4]
  5764 00003016 B8023D                   mov  ax, 15618
  5765 00003019 E87200                   call DosInt
  5766                                  
  5767                                  ;-198 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  5768 0000301C C9                       LEAVE
  5769 0000301D C3                       ret
  5770                                  ; ENDP
  5771                                  ;Number of CALLs:    2 : creatR
  5772                                  
  5773                                  creatR:  ; *** PROC ***
  5774                                  ;Function : creatR, Number of local variables: 1
  5775                                  ;   # type sign width line used address name   list of local variables
  5776                                  ;  200 ptr sign byte   198 NULL bp+4    s;
  5777 0000301E C8000000                 ENTER  0,0
  5778 00003022 8B5604                   mov  dx, [bp+4]
  5779 00003025 B90000                   mov  cx, 0
  5780 00003028 B8003C                   mov  ax, 15360
  5781 0000302B E86000                   call DosInt
  5782                                  
  5783                                  ;-199 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  5784 0000302E C9                       LEAVE
  5785 0000302F C3                       ret
  5786                                  ; ENDP
  5787                                  ;Number of CALLs:    2 : readRL
  5788                                  
  5789                                  readRL:  ; *** PROC ***
  5790                                  ;Function : readRL, Number of local variables: 3
  5791                                  ;   # type sign width line used address name   list of local variables
  5792                                  ;  200 ptr sign byte   199 NULL bp+4    s
  5793                                  ;  201 var sign word   199 NULL bp+6    fd
  5794                                  ;  202 var sign word   199 NULL bp+8    len;
  5795 00003030 C8000000                 ENTER  0,0
  5796 00003034 8B5604                   mov  dx, [bp+4]
  5797 00003037 8B4E08                   mov  cx, [bp+8]
  5798 0000303A 8B5E06                   mov  bx, [bp+6]
  5799 0000303D B8003F                   mov  ax, 16128
  5800 00003040 E84B00                   call DosInt
  5801                                  
  5802                                  ;-200 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  5803 00003043 C9                       LEAVE
  5804 00003044 C3                       ret
  5805                                  ; ENDP
  5806                                  ;Number of CALLs:    2 : fputcR
  5807                                  
  5808                                  fputcR:  ; *** PROC ***
  5809                                  ;Function : fputcR, Number of local variables: 2
  5810                                  ;   # type sign width line used address name   list of local variables
  5811                                  ;  200 ptr sign byte   200 NULL bp+4    n
  5812                                  ;  201 var sign word   200 NULL bp+6    fd;
  5813 00003045 C8000000                 ENTER  0,0
  5814 00003049 8D5604                  lea dx, [bp+4]
  5815                                  
  5816                                  ;-201   cx=1; bx=fd; ax=0x4000; DosInt(); }
  5817                                  
  5818 0000304C B90100                   mov  cx, 1
  5819 0000304F 8B5E06                   mov  bx, [bp+6]
  5820 00003052 B80040                   mov  ax, 16384
  5821 00003055 E83600                   call DosInt
  5822                                  
  5823                                  ;-202 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  5824 00003058 C9                       LEAVE
  5825 00003059 C3                       ret
  5826                                  ; ENDP
  5827                                  ;Number of CALLs:    3 : fcloseR
  5828                                  
  5829                                  fcloseR:  ; *** PROC ***
  5830                                  ;Function : fcloseR, Number of local variables: 1
  5831                                  ;   # type sign width line used address name   list of local variables
  5832                                  ;  200 var sign word   202 NULL bp+4    fd;
  5833 0000305A C8000000                 ENTER  0,0
  5834 0000305E 8B5E04                   mov  bx, [bp+4]
  5835 00003061 B8003E                   mov  ax, 15872
  5836 00003064 CD21                     int  33
  5837                                  
  5838                                  ;-203 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  5839 00003066 C9                       LEAVE
  5840 00003067 C3                       ret
  5841                                  ; ENDP
  5842                                  ;Number of CALLs:    5 : exitR
  5843                                  
  5844                                  exitR:  ; *** PROC ***
  5845                                  ;Function : exitR, Number of local variables: 1
  5846                                  ;   # type sign width line used address name   list of local variables
  5847                                  ;  200 var sign byte   203 NULL bp+4    c;
  5848 00003068 C8000000                 ENTER  0,0
  5849 0000306C B44C                     mov  ah, 76
  5850 0000306E 8A4604                   mov  al, [bp+4]
  5851 00003071 CD21                     int  33
  5852                                  
  5853                                  ;-204 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  5854 00003073 C9                       LEAVE
  5855 00003074 C3                       ret
  5856                                  ; ENDP
  5857                                  ;End of archive file. 
  5858                                   
  5859                                  ; missing functions: 
  5860                                  ; putch
  5861                                  ; DosInt
  5862                                  ; DosInt
  5863                                  ; DosInt
  5864                                  ; DosInt
  5865                                  ; Number of unresolved CALLs :    5
  5866                                  ;use archive file: AR.C
  5867                                  
  5868                                  ;-205 // AR.C Archive
  5869                                  
  5870                                  ;Number of CALLs:    1 : putch
  5871                                  
  5872                                  putch:  ; *** PROC ***
  5873                                  ;Function : putch, Number of local variables: 1
  5874                                  ;   # type sign width line used address name   list of local variables
  5875                                  ;  200 var sign byte   205 NULL bp+4    c;
  5876 00003075 C8000000                 ENTER  0,0
  5877 00003079 807E040A                cmp byte [bp+4], 10
  5878 0000307D 0F850500                 jne @@putch244
  5879 00003081 B00D                     mov  al, 13
  5880 00003083 E8FFFD                   call writetty
  5881                                  @@putch244:
  5882 00003086 8A4604                   mov  al, [bp+4]
  5883 00003089 E8F9FD                   call writetty
  5884                                  
  5885                                  ;-206 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  5886 0000308C C9                       LEAVE
  5887 0000308D C3                       ret
  5888                                  ; ENDP
  5889                                  ;Number of CALLs:    4 : DosInt
  5890                                  
  5891                                  DosInt:  ; *** PROC ***
  5892 0000308E CD21                     int  33
  5893 00003090 7304                     jae short @@DosInt245
  5894 00003092 FF06[A901]               inc  word [DOS_ERR]
  5895                                  @@DosInt245:
  5896                                  
  5897                                  ;-207 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  5898                                  
  5899 00003096 C3                       ret
  5900                                  ; ENDP
  5901                                  ;End of archive file. 
  5902                                   
  5903                                  ; missing functions:  All FUNCTIONs in place
  5904 00003097 E80000                  LastFunctionByt:db 0E8h, 0, 0
  5905 0000309A 58                      pop ax
  5906 0000309B C3                      ret
  5907                                   
  5908                                  ;   # type sign width line used  address name   list of global variables
  5909                                  
  5910                                  ;    1 arr sign byte     1    2        0 Version1[20]
  5911                                  ;    2 var sign byte     1    3        0 LIST
  5912                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  5913                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  5914                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  5915                                  ;    6 var unsg word     5   12        0 SymbolInt
  5916                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  5917                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  5918                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  5919                                  ;   10 arr sign byte     9    5        0 namein[67]
  5920                                  ;   11 arr sign byte    10    5        0 namelst[67]
  5921                                  ;   12 arr sign byte    11    5        0 namebin[67]
  5922                                  ;   13 var sign word    12    4        0 asm_fd
  5923                                  ;   14 var sign word    13    3        0 lst_fd
  5924                                  ;   15 var sign word    14    3        0 bin_fd
  5925                                  ;   16 var sign word    15    6        0 DOS_ERR
  5926                                  ;   17 var sign word    16    4        0 ErrorCount
  5927                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  5928                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  5929                                  ;   20 var unsg word    20    5        0 PC
  5930                                  ;   21 var unsg word    21    2        0 PCStart
  5931                                  ;   22 var sign byte    22    3        0 isLabel
  5932                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  5933                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  5934                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  5935                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  5936                                  ;   27 var sign byte    27   21        0 TokeType
  5937                                  ;   28 def unsg byte    28    -        0 BYTE=1
  5938                                  ;   29 def unsg byte    29    -        0 WORD=2
  5939                                  ;   30 def unsg byte    30    -        0 DWORD=3
  5940                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  5941                                  ;   32 def unsg byte    32    -        0 IMM=1
  5942                                  ;   33 def unsg byte    33    -        0 REG=2
  5943                                  ;   34 def unsg byte    34    -        0 ADR=3
  5944                                  ;   35 def unsg byte    35    -        0 MEM=4
  5945                                  ;   36 var sign byte    36   19        0 Op1
  5946                                  ;   37 var sign byte    37    1        0 Optemp
  5947                                  ;   38 var sign byte    38   13        0 CodeType
  5948                                  ;   39 var sign byte    39    6        0 Code1
  5949                                  ;   40 var sign byte    40    6        0 Code2
  5950                                  ;   41 var sign byte    41    3        0 Code3
  5951                                  ;   42 var sign byte    42   12        0 RegNo
  5952                                  ;   43 var sign byte    43    4        0 R1No
  5953                                  ;   44 var sign byte    44   19        0 RegType
  5954                                  ;   45 var sign byte    45    1        0 R1Type
  5955                                  ;   46 var sign byte    46   10        0 OpSize
  5956                                  ;   47 var sign byte    47    4        0 wflag
  5957                                  ;   48 var sign byte    52   15        0 regindexbase
  5958                                  ;   49 var sign byte    53    3        0 isDirect
  5959                                  ;   50 var sign word    54   14        0 disp
  5960                                  ;   51 var sign word    55    2        0 imme
  5961                                  ;   52 def unsg byte    57    -        0 OPMAXLEN=5
  5962                                  ;   53 arr sign byte    58    2        0 OpPos[5]
  5963                                  ;   54 var sign word    59    6        0 OpPrintIndex
  5964                                  ;   55 ptr sign byte    60   17        0 OpCodePtr
  5965                                  ;   56 var sign byte    61    2        0 PrintR
  5966                                  ;   57 def unsg byte    63    -        0 LABELNAMESMAX=969
  5967                                  ;   58 arr sign byte    64    3        0 LabelNames[1000]
  5968                                  ;   59 ptr sign byte    65    5        0 LabelNamePtr
  5969                                  ;   60 def unsg byte    66    -        0 LABELADRMAX=100
  5970                                  ;   61 arr unsg word    67    3        0 LabelAddr[100]
  5971                                  ;   62 var sign word    68    4        0 LabelMaxIx
  5972                                  ;   63 var sign word    69    4        0 LabelIx
  5973                                  ;   64 def unsg byte    71    -        0 FILEBINMAX=2000
  5974                                  ;   65 arr sign byte    72    2        0 FileBin[2000]
  5975                                  ;   66 var unsg word    73    5        0 BinLen
  5976                                  ;   67 ptr sign byte    75    1        0 arglen
  5977                                  ;   68 ptr sign byte    76    4        0 argv
  5978                                  ;   69 var sign byte     1    1        0 I_START
  5979                                  ;   70 arr sign byte     4 NULL        0 I_PUSHA[9]
  5980                                  ;   71 arr sign byte     5 NULL        0 I_POPA[8]
  5981                                  ;   72 arr sign byte     6 NULL        0 I_NOP[7]
  5982                                  ;   73 arr sign byte     7 NULL        0 I_CBW[7]
  5983                                  ;   74 arr sign byte     8 NULL        0 I_CWDE[8]
  5984                                  ;   75 arr sign byte     9 NULL        0 I_CWD[7]
  5985                                  ;   76 arr sign byte    10 NULL        0 I_CDQ[7]
  5986                                  ;   77 arr sign byte    11 NULL        0 I_WAIT[8]
  5987                                  ;   78 arr sign byte    12 NULL        0 I_PUSHF[9]
  5988                                  ;   79 arr sign byte    13 NULL        0 I_POPF[8]
  5989                                  ;   80 arr sign byte    14 NULL        0 I_SAHF[8]
  5990                                  ;   81 arr sign byte    15 NULL        0 I_LAHF[8]
  5991                                  ;   82 arr sign byte    16 NULL        0 I_MOVSB[9]
  5992                                  ;   83 arr sign byte    17 NULL        0 I_MOVSW[9]
  5993                                  ;   84 arr sign byte    18 NULL        0 I_CMPSB[9]
  5994                                  ;   85 arr sign byte    19 NULL        0 I_CMPSW[9]
  5995                                  ;   86 arr sign byte    20 NULL        0 I_STOSB[9]
  5996                                  ;   87 arr sign byte    21 NULL        0 I_STOSW[9]
  5997                                  ;   88 arr sign byte    22 NULL        0 I_LODSB[9]
  5998                                  ;   89 arr sign byte    23 NULL        0 I_LODSW[9]
  5999                                  ;   90 arr sign byte    24 NULL        0 I_SCASB[9]
  6000                                  ;   91 arr sign byte    25 NULL        0 I_SCASW[9]
  6001                                  ;   92 arr sign byte    26 NULL        0 I_LEAVE[9]
  6002                                  ;   93 arr sign byte    27 NULL        0 I_IRET[8]
  6003                                  ;   94 arr sign byte    28 NULL        0 I_XLAT[8]
  6004                                  ;   95 arr sign byte    29 NULL        0 I_LOCK[8]
  6005                                  ;   96 arr sign byte    30 NULL        0 I_REPNE[9]
  6006                                  ;   97 arr sign byte    31 NULL        0 I_REPNZ[9]
  6007                                  ;   98 arr sign byte    32 NULL        0 I_REPE[8]
  6008                                  ;   99 arr sign byte    33 NULL        0 I_REPZ[8]
  6009                                  ;  100 arr sign byte    34 NULL        0 I_HLT[7]
  6010                                  ;  101 arr sign byte    35 NULL        0 I_CLC[7]
  6011                                  ;  102 arr sign byte    36 NULL        0 I_STC[7]
  6012                                  ;  103 arr sign byte    37 NULL        0 I_CLI[7]
  6013                                  ;  104 arr sign byte    38 NULL        0 I_STI[7]
  6014                                  ;  105 arr sign byte    39 NULL        0 I_CLD[7]
  6015                                  ;  106 arr sign byte    40 NULL        0 I_STD[7]
  6016                                  ;  107 arr sign byte    42 NULL        0 I_INC[9]
  6017                                  ;  108 arr sign byte    43 NULL        0 I_DEC[9]
  6018                                  ;  109 arr sign byte    44 NULL        0 I_NOT[8]
  6019                                  ;  110 arr sign byte    45 NULL        0 I_NEG[8]
  6020                                  ;  111 arr sign byte    46 NULL        0 I_MUL[8]
  6021                                  ;  112 arr sign byte    47 NULL        0 I_IMUL[9]
  6022                                  ;  113 arr sign byte    48 NULL        0 I_DIV[8]
  6023                                  ;  114 arr sign byte    49 NULL        0 I_IDIV[9]
  6024                                  ;  115 arr sign byte    51 NULL        0 I_LES[7]
  6025                                  ;  116 arr sign byte    52 NULL        0 I_LDS[7]
  6026                                  ;  117 arr sign byte    53 NULL        0 I_LEA[7]
  6027                                  ;  118 arr sign byte    54 NULL        0 I_LSS[8]
  6028                                  ;  119 arr sign byte    55 NULL        0 I_LFS[8]
  6029                                  ;  120 arr sign byte    56 NULL        0 I_LGS[8]
  6030                                  ;  121 arr sign byte    58 NULL        0 I_ADD[7]
  6031                                  ;  122 arr sign byte    59 NULL        0 I_OR[6]
  6032                                  ;  123 arr sign byte    60 NULL        0 I_ADC[7]
  6033                                  ;  124 arr sign byte    61 NULL        0 I_SBB[7]
  6034                                  ;  125 arr sign byte    62 NULL        0 I_AND[7]
  6035                                  ;  126 arr sign byte    63 NULL        0 I_SUB[7]
  6036                                  ;  127 arr sign byte    64 NULL        0 I_XOR[7]
  6037                                  ;  128 arr sign byte    65 NULL        0 I_CMP[7]
  6038                                  ;  129 arr sign byte    66 NULL        0 I_TEST[11]
  6039                                  ;  130 arr sign byte    68 NULL        0 I_MOV[6]
  6040                                  ;  131 arr sign byte    69 NULL        0 I_MOVSX[9]
  6041                                  ;  132 arr sign byte    70 NULL        0 I_MOVZX[9]
  6042                                  ;  133 arr sign byte    72 NULL        0 I_JO[6]
  6043                                  ;  134 arr sign byte    73 NULL        0 I_JNO[7]
  6044                                  ;  135 arr sign byte    74 NULL        0 I_JB[6]
  6045                                  ;  136 arr sign byte    75 NULL        0 I_JC[6]
  6046                                  ;  137 arr sign byte    76 NULL        0 I_JNB[7]
  6047                                  ;  138 arr sign byte    77 NULL        0 I_JAE[7]
  6048                                  ;  139 arr sign byte    78 NULL        0 I_JNC[7]
  6049                                  ;  140 arr sign byte    79 NULL        0 I_JE[6]
  6050                                  ;  141 arr sign byte    80 NULL        0 I_JZ[6]
  6051                                  ;  142 arr sign byte    81 NULL        0 I_JNE[7]
  6052                                  ;  143 arr sign byte    82 NULL        0 I_JNZ[7]
  6053                                  ;  144 arr sign byte    83 NULL        0 I_JBE[7]
  6054                                  ;  145 arr sign byte    84 NULL        0 I_JNA[7]
  6055                                  ;  146 arr sign byte    85 NULL        0 I_JA[6]
  6056                                  ;  147 arr sign byte    86 NULL        0 I_JS[6]
  6057                                  ;  148 arr sign byte    87 NULL        0 I_JNS[7]
  6058                                  ;  149 arr sign byte    88 NULL        0 I_JP[6]
  6059                                  ;  150 arr sign byte    89 NULL        0 I_JPE[7]
  6060                                  ;  151 arr sign byte    90 NULL        0 I_JNP[7]
  6061                                  ;  152 arr sign byte    91 NULL        0 I_JPO[7]
  6062                                  ;  153 arr sign byte    92 NULL        0 I_JL[6]
  6063                                  ;  154 arr sign byte    93 NULL        0 I_JNL[7]
  6064                                  ;  155 arr sign byte    94 NULL        0 I_JGE[7]
  6065                                  ;  156 arr sign byte    95 NULL        0 I_JLE[7]
  6066                                  ;  157 arr sign byte    96 NULL        0 I_JNG[7]
  6067                                  ;  158 arr sign byte    97 NULL        0 I_JG[6]
  6068                                  ;  159 arr sign byte    99 NULL        0 I_JMP[8]
  6069                                  ;  160 arr sign byte   100 NULL        0 I_CALL[9]
  6070                                  ;  161 arr sign byte   102 NULL        0 I_RET[8]
  6071                                  ;  162 arr sign byte   103 NULL        0 I_RETF[9]
  6072                                  ;  163 arr sign byte   105 NULL        0 I_PUSH[8]
  6073                                  ;  164 arr sign byte   106 NULL        0 I_POP[7]
  6074                                  ;  165 arr sign byte   108 NULL        0 I_ROL[7]
  6075                                  ;  166 arr sign byte   109 NULL        0 I_ROR[7]
  6076                                  ;  167 arr sign byte   110 NULL        0 I_RCL[7]
  6077                                  ;  168 arr sign byte   111 NULL        0 I_RCR[7]
  6078                                  ;  169 arr sign byte   112 NULL        0 I_SHL[7]
  6079                                  ;  170 arr sign byte   113 NULL        0 I_SAL[7]
  6080                                  ;  171 arr sign byte   114 NULL        0 I_SHR[7]
  6081                                  ;  172 arr sign byte   115 NULL        0 I_SAR[7]
  6082                                  ;  173 arr sign byte   117 NULL        0 I_INT[8]
  6083                                  ;  174 arr sign byte   118 NULL        0 I_INTO[8]
  6084                                  ;  175 arr sign byte   120 NULL        0 I_IN[7]
  6085                                  ;  176 arr sign byte   121 NULL        0 I_INSB[8]
  6086                                  ;  177 arr sign byte   122 NULL        0 I_INSW[8]
  6087                                  ;  178 arr sign byte   123 NULL        0 I_INSD[8]
  6088                                  ;  179 arr sign byte   124 NULL        0 I_OUT[8]
  6089                                  ;  180 arr sign byte   125 NULL        0 I_OUTSB[8]
  6090                                  ;  181 arr sign byte   126 NULL        0 I_OUTSW[8]
  6091                                  ;  182 arr sign byte   127 NULL        0 I_OUTSD[8]
  6092                                  ;  183 arr sign byte   129 NULL        0 I_XCHG[9]
  6093                                  ;  184 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6094                                  ;  185 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6095                                  ;  186 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6096                                  ;  187 arr sign byte   134 NULL        0 I_LOOPE[9]
  6097                                  ;  188 arr sign byte   135 NULL        0 I_LOOP[8]
  6098                                  ;  189 arr sign byte   136 NULL        0 I_JCXZ[8]
  6099                                  ;  190 arr sign byte   137 NULL        0 I_JECXZ[9]
  6100                                  ;  191 arr sign byte   139 NULL        0 I_ENTER[9]
  6101                                  ;  192 arr sign byte   141 NULL        0 I_ORG[6]
  6102                                  ;  193 arr sign byte   146 NULL        0 I_DB[5]
  6103                                  ;  194 arr sign byte   147 NULL        0 I_DW[5]
  6104                                  ;  195 arr sign byte   148 NULL        0 I_DD[5]
  6105                                  ;  196 arr sign byte   149 NULL        0 I_RESB[7]
  6106                                  ;  197 arr sign byte   150 NULL        0 I_RESW[7]
  6107                                  ;  198 arr sign byte   151 NULL        0 I_RESD[7]
  6108                                  ;  199 var sign byte   152 NULL        0 I_END
  6109                                  
  6110                                  
  6111                                  ;   # Calls Line Width  Name   list of functions
  6112                                  
  6113                                  ;    0    1    1 word   parse
  6114                                  ;    1   13   27 word   getTokeType
  6115                                  ;    2    2   36 word   storeLabel
  6116                                  ;    3    2   46 word   searchLabel
  6117                                  ;    4    1   57 word   getVariable
  6118                                  ;    5    2   86 word   lookCode
  6119                                  ;    6    1  101 word   getCodeSize
  6120                                  ;    7    8  108 word   isToken
  6121                                  ;    8    2  113 word   need
  6122                                  ;    9    1  120 word   skipRest
  6123                                  ;   10    1    1 word   getLine
  6124                                  ;   11    1   17 word   ifEOL
  6125                                  ;   12    3   24 word   skipBlank
  6126                                  ;   13    2   29 word   letterE
  6127                                  ;   14    1   39 word   alnumE
  6128                                  ;   15    1   44 word   getDigit
  6129                                  ;   16    1   56 word   getName
  6130                                  ;   17    1   75 word   testReg
  6131                                  ;   18    1    1 word   printLine
  6132                                  ;   19    8   19 word   prc
  6133                                  ;   20    1   23 word   prscomment
  6134                                  ;   21   21   26 word   prs
  6135                                  ;   22    3   31 word   printhex8a
  6136                                  ;   23    1   35 word   printhex16
  6137                                  ;   24    3   38 word   printIntU
  6138                                  ;   25   25   45 word   error1
  6139                                  ;   26 NULL   48 word   allowederror
  6140                                  ;   27    1   49 word   addrerror
  6141                                  ;   28    2   50 word   immeerror
  6142                                  ;   29    2   51 word   implerror
  6143                                  ;   30    4   52 word   indexerror
  6144                                  ;   31    1   53 word   invaloperror
  6145                                  ;   32    1   54 word   numbererror
  6146                                  ;   33 NULL   55 word   regmemerror
  6147                                  ;   34    1   56 word   reg16error
  6148                                  ;   35    1   57 word   segregerror
  6149                                  ;   36    1   58 word   syntaxerror
  6150                                  ;   37   12   60 word   errorexit
  6151                                  ;   38    1   61 word   addrexit
  6152                                  ;   39 NULL   62 word   internexit
  6153                                  ;   40 NULL    1 word   main
  6154                                  ;   41    1    8 word   getarg
  6155                                  ;   42    1   38 word   epilog
  6156                                  ;   43    2   67 word   end1
  6157                                  ;   44    1    2 word   getCodes
  6158                                  ;   45    1    7 word   gen66h
  6159                                  ;   46    3    9 word   genCode
  6160                                  ;   47   13   13 word   genCode8
  6161                                  ;   48    3   24 word   genCode16
  6162                                  ;   49    3   28 word   writeEA
  6163                                  ;   50    1   11 word   process
  6164                                  ;   51    3   93 word   checkOp
  6165                                  ;   52    3  105 word   getOp
  6166                                  ;   53    1  118 word   setwflag
  6167                                  ;   54    2  130 word   getOp1
  6168                                  ;   55    1  146 word   getMEM
  6169                                  ;   56    1  168 word   getIndReg1
  6170                                  ;   57    1  176 word   getIndReg2
  6171                                  ;   58    4  185 word   writetty
  6172                                  ;   59    8  186 word   cputs
  6173                                  ;   60    2  187 word   toupper
  6174                                  ;   61    3  189 word   strlen
  6175                                  ;   62    6  190 word   strcpy
  6176                                  ;   63    3  192 word   digit
  6177                                  ;   64   35  193 word   eqstr
  6178                                  ;   65    3  196 word   strcat1
  6179                                  ;   66    1  197 word   openR
  6180                                  ;   67    2  198 word   creatR
  6181                                  ;   68    2  199 word   readRL
  6182                                  ;   69    2  200 word   fputcR
  6183                                  ;   70    3  202 word   fcloseR
  6184                                  ;   71    5  203 word   exitR
  6185                                  ;   72    1  205 word   putch
  6186                                  ;   73    4  206 word   DosInt
  6187                                  ;   74 NULL  207 word   LastFunctionByt
  6188                                  
  6189                                  ;    #  addr name   list of CALLs
  6190                                  
  6191                                  ;    0  1399 getLine
  6192                                  ;    1  1407 getTokeType
  6193                                  ;    2  1419 storeLabel
  6194                                  ;    3  1430 getTokeType
  6195                                  ;    4  1442 lookCode
  6196                                  ;    5  1451 process
  6197                                  ;    6  1459 getVariable
  6198                                  ;    7  1471 skipRest
  6199                                  ;    8  1480 error1
  6200                                  ;    9  1487 error1
  6201                                  ;   10  1494 printLine
  6202                                  ;   11  1518 skipBlank
  6203                                  ;   12  1528 digit
  6204                                  ;   13  1534 getDigit
  6205                                  ;   14  1543 letterE
  6206                                  ;   15  1551 getName
  6207                                  ;   16  1572 searchLabel
  6208                                  ;   17  1584 error1
  6209                                  ;   18  1591 strcpy
  6210                                  ;   19  1598 errorexit
  6211                                  ;   20  1608 errorexit
  6212                                  ;   21  1638 eqstr
  6213                                  ;   22  1644 strlen
  6214                                  ;   23  1665 storeLabel
  6215                                  ;   24  1676 getTokeType
  6216                                  ;   25  1688 lookCode
  6217                                  ;   26  1697 errorexit
  6218                                  ;   27  1707 errorexit
  6219                                  ;   28  1717 getTokeType
  6220                                  ;   29  1729 genCode8
  6221                                  ;   30  1738 skipBlank
  6222                                  ;   31  1748 isToken
  6223                                  ;   32  1756 genCode8
  6224                                  ;   33  1765 isToken
  6225                                  ;   34  1773 getTokeType
  6226                                  ;   35  1785 genCode16
  6227                                  ;   36  1795 isToken
  6228                                  ;   37  1803 errorexit
  6229                                  ;   38  1822 eqstr
  6230                                  ;   39  1840 eqstr
  6231                                  ;   40  1846 getTokeType
  6232                                  ;   41  1858 eqstr
  6233                                  ;   42  1864 getTokeType
  6234                                  ;   43  1876 eqstr
  6235                                  ;   44  1882 getTokeType
  6236                                  ;   45  1904 skipBlank
  6237                                  ;   46  1921 isToken
  6238                                  ;   47  1929 error1
  6239                                  ;   48  1936 prs
  6240                                  ;   49  1940 prc
  6241                                  ;   50  1953 getTokeType
  6242                                  ;   51  1965 error1
  6243                                  ;   52  1982 readRL
  6244                                  ;   53  1989 errorexit
  6245                                  ;   54  1999 errorexit
  6246                                  ;   55  2009 ifEOL
  6247                                  ;   56  2023 readRL
  6248                                  ;   57  2059 digit
  6249                                  ;   58  2065 letterE
  6250                                  ;   59  2092 digit
  6251                                  ;   60  2112 alnumE
  6252                                  ;   61  2119 errorexit
  6253                                  ;   62  2129 strcpy
  6254                                  ;   63  2136 toupper
  6255                                  ;   64  2152 strlen
  6256                                  ;   65  2159 strlen
  6257                                  ;   66  2166 eqstr
  6258                                  ;   67  2172 eqstr
  6259                                  ;   68  2178 eqstr
  6260                                  ;   69  2184 eqstr
  6261                                  ;   70  2190 eqstr
  6262                                  ;   71  2196 eqstr
  6263                                  ;   72  2202 eqstr
  6264                                  ;   73  2208 eqstr
  6265                                  ;   74  2214 eqstr
  6266                                  ;   75  2220 eqstr
  6267                                  ;   76  2226 eqstr
  6268                                  ;   77  2232 eqstr
  6269                                  ;   78  2238 eqstr
  6270                                  ;   79  2244 eqstr
  6271                                  ;   80  2250 eqstr
  6272                                  ;   81  2256 eqstr
  6273                                  ;   82  2262 eqstr
  6274                                  ;   83  2268 eqstr
  6275                                  ;   84  2274 eqstr
  6276                                  ;   85  2280 eqstr
  6277                                  ;   86  2286 eqstr
  6278                                  ;   87  2292 eqstr
  6279                                  ;   88  2298 eqstr
  6280                                  ;   89  2304 eqstr
  6281                                  ;   90  2310 eqstr
  6282                                  ;   91  2316 eqstr
  6283                                  ;   92  2322 eqstr
  6284                                  ;   93  2328 eqstr
  6285                                  ;   94  2334 eqstr
  6286                                  ;   95  2340 eqstr
  6287                                  ;   96  2360 prs
  6288                                  ;   97  2364 printhex16
  6289                                  ;   98  2375 prs
  6290                                  ;   99  2379 prc
  6291                                  ;  100  2383 printhex8a
  6292                                  ;  101  2394 prc
  6293                                  ;  102  2398 prs
  6294                                  ;  103  2402 prscomment
  6295                                  ;  104  2419 writetty
  6296                                  ;  105  2428 writetty
  6297                                  ;  106  2437 fputcR
  6298                                  ;  107  2459 prc
  6299                                  ;  108  2475 prc
  6300                                  ;  109  2496 prc
  6301                                  ;  110  2500 prc
  6302                                  ;  111  2522 printhex8a
  6303                                  ;  112  2533 printhex8a
  6304                                  ;  113  2558 printIntU
  6305                                  ;  114  2568 prc
  6306                                  ;  115  2581 prs
  6307                                  ;  116  2585 prs
  6308                                  ;  117  2589 prs
  6309                                  ;  118  2593 prs
  6310                                  ;  119  2610 error1
  6311                                  ;  120  2627 error1
  6312                                  ;  121  2644 error1
  6313                                  ;  122  2661 error1
  6314                                  ;  123  2679 error1
  6315                                  ;  124  2699 error1
  6316                                  ;  125  2718 error1
  6317                                  ;  126  2737 error1
  6318                                  ;  127  2755 error1
  6319                                  ;  128  2774 error1
  6320                                  ;  129  2793 error1
  6321                                  ;  130  2812 error1
  6322                                  ;  131  2819 end1
  6323                                  ;  132  2833 errorexit
  6324                                  ;  133  2854 errorexit
  6325                                  ;  134  2869 getarg
  6326                                  ;  135  2876 parse
  6327                                  ;  136  2882 epilog
  6328                                  ;  137  2889 end1
  6329                                  ;  138  2913 cputs
  6330                                  ;  139  2919 cputs
  6331                                  ;  140  2925 exitR
  6332                                  ;  141  2931 toupper
  6333                                  ;  142  2939 strcpy
  6334                                  ;  143  2946 strcat1
  6335                                  ;  144  2954 strcpy
  6336                                  ;  145  2961 strcat1
  6337                                  ;  146  2969 strcpy
  6338                                  ;  147  2976 strcat1
  6339                                  ;  148  2984 openR
  6340                                  ;  149  2990 cputs
  6341                                  ;  150  2996 cputs
  6342                                  ;  151  3002 exitR
  6343                                  ;  152  3008 creatR
  6344                                  ;  153  3015 cputs
  6345                                  ;  154  3021 cputs
  6346                                  ;  155  3027 exitR
  6347                                  ;  156  3033 creatR
  6348                                  ;  157  3040 cputs
  6349                                  ;  158  3046 cputs
  6350                                  ;  159  3052 exitR
  6351                                  ;  160  3058 prs
  6352                                  ;  161  3062 prs
  6353                                  ;  162  3066 prs
  6354                                  ;  163  3070 prs
  6355                                  ;  164  3074 prs
  6356                                  ;  165  3078 prs
  6357                                  ;  166  3082 prs
  6358                                  ;  167  3086 prs
  6359                                  ;  168  3090 prs
  6360                                  ;  169  3107 prs
  6361                                  ;  170  3111 printIntU
  6362                                  ;  171  3121 prs
  6363                                  ;  172  3125 prs
  6364                                  ;  173  3129 printIntU
  6365                                  ;  174  3139 prs
  6366                                  ;  175  3143 fputcR
  6367                                  ;  176  3157 fcloseR
  6368                                  ;  177  3165 fcloseR
  6369                                  ;  178  3173 fcloseR
  6370                                  ;  179  3181 exitR
  6371                                  ;  180  3203 genCode8
  6372                                  ;  181  3224 genCode8
  6373                                  ;  182  3244 errorexit
  6374                                  ;  183  3266 genCode8
  6375                                  ;  184  3275 genCode8
  6376                                  ;  185  3300 addrexit
  6377                                  ;  186  3309 error1
  6378                                  ;  187  3316 genCode8
  6379                                  ;  188  3325 genCode8
  6380                                  ;  189  3334 genCode16
  6381                                  ;  190  3352 getTokeType
  6382                                  ;  191  3364 getCodeSize
  6383                                  ;  192  3376 getCodes
  6384                                  ;  193  3385 genCode8
  6385                                  ;  194  3394 checkOp
  6386                                  ;  195  3402 genCode
  6387                                  ;  196  3410 genCode
  6388                                  ;  197  3418 getTokeType
  6389                                  ;  198  3430 implerror
  6390                                  ;  199  3440 genCode
  6391                                  ;  200  3448 writeEA
  6392                                  ;  201  3456 checkOp
  6393                                  ;  202  3464 reg16error
  6394                                  ;  203  3475 immeerror
  6395                                  ;  204  3485 need
  6396                                  ;  205  3490 getOp
  6397                                  ;  206  3496 addrerror
  6398                                  ;  207  3506 genCode8
  6399                                  ;  208  3515 genCode8
  6400                                  ;  209  3524 writeEA
  6401                                  ;  210  3532 checkOp
  6402                                  ;  211  3540 immeerror
  6403                                  ;  212  3550 need
  6404                                  ;  213  3555 getOp
  6405                                  ;  214  3561 writeEA
  6406                                  ;  215  3569 genCode8
  6407                                  ;  216  3578 genCode16
  6408                                  ;  217  3588 genCode8
  6409                                  ;  218  3597 error1
  6410                                  ;  219  3604 error1
  6411                                  ;  220  3619 getOp
  6412                                  ;  221  3625 implerror
  6413                                  ;  222  3635 segregerror
  6414                                  ;  223  3647 setwflag
  6415                                  ;  224  3656 error1
  6416                                  ;  225  3663 error1
  6417                                  ;  226  3670 error1
  6418                                  ;  227  3683 getOp1
  6419                                  ;  228  3690 isToken
  6420                                  ;  229  3698 getMEM
  6421                                  ;  230  3705 invaloperror
  6422                                  ;  231  3718 error1
  6423                                  ;  232  3734 gen66h
  6424                                  ;  233  3748 testReg
  6425                                  ;  234  3756 searchLabel
  6426                                  ;  235  3768 error1
  6427                                  ;  236  3786 getTokeType
  6428                                  ;  237  3798 getOp1
  6429                                  ;  238  3805 syntaxerror
  6430                                  ;  239  3817 getIndReg2
  6431                                  ;  240  3828 getIndReg1
  6432                                  ;  241  3839 isToken
  6433                                  ;  242  3847 getTokeType
  6434                                  ;  243  3859 numbererror
  6435                                  ;  244  3871 isToken
  6436                                  ;  245  3879 isToken
  6437                                  ;  246  3887 errorexit
  6438                                  ;  247  3908 indexerror
  6439                                  ;  248  3919 indexerror
  6440                                  ;  249  3943 indexerror
  6441                                  ;  250  3954 indexerror
  6442                                  ;  251  3984 putch
  6443                                  ;  252  4052 strcpy
  6444                                  ;  253  4067 DosInt
  6445                                  ;  254  4083 DosInt
  6446                                  ;  255  4106 DosInt
  6447                                  ;  256  4125 DosInt
  6448                                  ;  257  4159 writetty
  6449                                  ;  258  4168 writetty
  6450                                  ;Input: AS.C, List: AS.S,  Lines:  208
  6451                                  ;Glob. variables:  199 max.:  200
  6452                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6453                                  ;Functions      :   75 max.:  300
  6454                                  ;Calls          :  259 max.: 2000, NameField: 4200 max.:    65535
  6455                                  ;Code until     :25998 max.: 30000, free: 4002
  6456                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6457                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
