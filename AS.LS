     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E90923                  jmp main
     6                                  
     7                                  ;-1 char Version1[]="AS.C V0.07";//BAS.BAT, AS TE, NAS.BAT
     8                                  
     9 00000003 41532E432056302E30-     Version1 db "AS.C V0.07",0
    10 0000000C 3700               
    11                                  
    12                                  ;-2 #include "DECL.C"
    13                                  
    14                                  ;Use include file: DECL.C
    15                                  
    16                                  ;-1 char LIST;              // listing on/off
    17                                  
    18 0000000E 00                      LIST db 0
    19                                  
    20                                  ;-2 #define SYMBOLMAX    31
    21                                  
    22                                  
    23                                  ;-3 char Symbol[SYMBOLMAX]; //next symbol to decode
    24                                  
    25 0000000F <res 0000001F>          Symbol resb 31
    26                                  
    27                                  ;-4 char SymbolUpper[SYMBOLMAX];//set toupper in getName
    28                                  
    29 0000002E <res 0000001F>          SymbolUpper resb 31
    30                                  
    31                                  ;-5 unsigned int SymbolInt; //integer value set in getDigit
    32                                  
    33 0000004D 0000                    SymbolInt dw 0
    34                                  
    35                                  ;-6 #define INPUTBUFMAX 127
    36                                  
    37                                  
    38                                  ;-7 char InputBuf[INPUTBUFMAX];//filled in getLine, no overflow test
    39                                  
    40 0000004F <res 0000007F>          InputBuf resb 127
    41                                  
    42                                  ;-8 unsigned char *InputPtr;//position in InputBuf
    43                                  
    44 000000CE 0000                    InputPtr dw 0
    45                                  
    46                                  ;-9 char namein [67];       //input file name  .S
    47                                  
    48 000000D0 <res 00000043>          namein resb 67
    49                                  
    50                                  ;-10 char namelst[67];       //list file name   .LST
    51                                  
    52 00000113 <res 00000043>          namelst resb 67
    53                                  
    54                                  ;-11 char namebin[67];       //output file name .COM
    55                                  
    56 00000156 <res 00000043>          namebin resb 67
    57                                  
    58                                  ;-12 int  asm_fd;            //input file descriptor
    59                                  
    60 00000199 0000                    asm_fd dw 0
    61                                  
    62                                  ;-13 int lst_fd;             //list file descriptor
    63                                  
    64 0000019B 0000                    lst_fd dw 0
    65                                  
    66                                  ;-14 int bin_fd;             //output file descriptor
    67                                  
    68 0000019D 0000                    bin_fd dw 0
    69                                  
    70                                  ;-15 int DOS_ERR;            //global var
    71                                  
    72 0000019F 0000                    DOS_ERR dw 0
    73                                  
    74                                  ;-16 int ErrorCount;         //number of errors
    75                                  
    76 000001A1 0000                    ErrorCount dw 0
    77                                  
    78                                  ;-17 int DOS_NoBytes;        //number of bytes read (0 or 1)
    79                                  
    80 000001A3 0000                    DOS_NoBytes dw 0
    81                                  
    82                                  ;-18 char DOS_ByteRead;      //the byte just read by DOS
    83                                  
    84 000001A5 00                      DOS_ByteRead db 0
    85                                  
    86                                  ;-19 
    87                                  
    88                                  
    89                                  ;-20 unsigned int PC;        //program counter, ORG nn
    90                                  
    91 000001A6 0000                    PC dw 0
    92                                  
    93                                  ;-21 unsigned int PCStart;   //PC at start of line by PrintLine()
    94                                  
    95 000001A8 0000                    PCStart dw 0
    96                                  
    97                                  ;-22 char isLabel;           //by getName()
    98                                  
    99 000001AA 00                      isLabel db 0
   100                                  
   101                                  ;-23 #define DIGIT    1      //0-9
   102                                  
   103                                  
   104                                  ;-24 #define LETTERE  2      //a-z A-Z @ . _
   105                                  
   106                                  
   107                                  ;-25 #define ALNUME   3      //a-z A-Z @ . _  0-9
   108                                  
   109                                  
   110                                  ;-26 #define NOALNUME 4      //other char
   111                                  
   112                                  
   113                                  ;-27 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   114                                  
   115 000001AB 00                      TokeType db 0
   116                                  
   117                                  ;-28 #define BYTE     1
   118                                  
   119                                  
   120                                  ;-29 #define WORD     2
   121                                  
   122                                  
   123                                  ;-30 #define DWORD    3
   124                                  
   125                                  
   126                                  ;-31 #define SEGREG   4
   127                                  
   128                                  
   129                                  ;-32 #define IMM      1      //const  ,123
   130                                  
   131                                  
   132                                  ;-33 #define REG      2      //       ,BX    mode=11
   133                                  
   134                                  
   135                                  ;-34 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   136                                  
   137                                  
   138                                  ;-35 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   139                                  
   140                                  
   141                                  ;-36 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  
   142                                  
   143 000001AC 00                      Op db 0
   144                                  
   145                                  ;-37 char Op2;               //2. operand
   146                                  
   147 000001AD 00                      Op2 db 0
   148                                  
   149                                  ;-38 char CodeType;          //1-207 by searchSymbol(), must be byte size
   150                                  
   151 000001AE 00                      CodeType db 0
   152                                  
   153                                  ;-39 char Code1;             //1. Opcode
   154                                  
   155 000001AF 00                      Code1 db 0
   156                                  
   157                                  ;-40 char Code2;             //2. Opcode
   158                                  
   159 000001B0 00                      Code2 db 0
   160                                  
   161                                  ;-41 char Code3;             //3. Opcode
   162                                  
   163 000001B1 00                      Code3 db 0
   164                                  
   165                                  ;-42 char RegNo;             //0 - 7 AL, CL, ...  set in testReg()  
   166                                  
   167 000001B2 00                      RegNo db 0
   168                                  
   169                                  ;-43 char R1No;              //temp for 1. register
   170                                  
   171 000001B3 00                      R1No db 0
   172                                  
   173                                  ;-44 char RegType;           //0=no reg, BYTE, WORD, DWORD, SEGREG
   174                                  
   175 000001B4 00                      RegType db 0
   176                                  
   177                                  ;-45 char R1Type;            //temp for 1. register 
   178                                  
   179 000001B5 00                      R1Type db 0
   180                                  
   181                                  ;-46 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   182                                  
   183 000001B6 00                      OpSize db 0
   184                                  
   185                                  ;-47 char wflag;             //wordflag: 0=byte, 1=word/dword
   186                                  
   187 000001B7 00                      wflag db 0
   188                                  
   189                                  ;-48 //char dflag;             //directionflag: 1=to reg MOV,ALU    
   190                                  
   191                                  
   192                                  ;-49 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   193                                  
   194 000001B8 00                      sflag db 0
   195                                  
   196                                  ;-50 char regindexbase;      //combination of index and base reg
   197                                  
   198 000001B9 00                      regindexbase db 0
   199                                  
   200                                  ;-51 char isDirect;          //set in getOpL and getMeM, need in WriteEA
   201                                  
   202 000001BA 00                      isDirect db 0
   203                                  
   204                                  ;-52 int disp;               //displacement      0-8 bytes
   205                                  
   206 000001BB 0000                    disp dw 0
   207                                  
   208                                  ;-53 int imme;               //immediate         0-8 bytes
   209                                  
   210 000001BD 0000                    imme dw 0
   211                                  
   212                                  ;-54 
   213                                  
   214                                  
   215                                  ;-55 #define OPMAXLEN 5
   216                                  
   217                                  
   218                                  ;-56 char OpPos[OPMAXLEN];   //array for one opcode to list
   219                                  
   220 000001BF <res 00000005>          OpPos resb 5
   221                                  
   222                                  ;-57 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   223                                  
   224 000001C4 0000                    OpPrintIndex dw 0
   225                                  
   226                                  ;-58 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   227                                  
   228 000001C6 0000                    OpCodePtr dw 0
   229                                  
   230                                  ;-59 char PrintR;           //print 'R' if relocative
   231                                  
   232 000001C8 00                      PrintR db 0
   233                                  
   234                                  ;-60 
   235                                  
   236                                  
   237                                  ;-61 #define LABELNAMESMAX 969//next number - 31
   238                                  
   239                                  
   240                                  ;-62 char LabelNames[1000];  //space for names of all labels
   241                                  
   242 000001C9 <res 000003E8>          LabelNames resb 1000
   243                                  
   244                                  ;-63 char *LabelNamePtr;     // first free position
   245                                  
   246 000005B1 0000                    LabelNamePtr dw 0
   247                                  
   248                                  ;-64 #define LABELADRMAX 100
   249                                  
   250                                  
   251                                  ;-65 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   252                                  
   253 000005B3 <res 000000C8>          LabelAddr resw 100
   254                                  
   255                                  ;-66 int LabelMaxIx=0;       //actual number of stored labels
   256                                  
   257 0000067B 0000                    LabelMaxIx dw 0
   258                                  
   259                                  ;-67 int LabelIx;            //actual number of just searched label
   260                                  
   261 0000067D 0000                    LabelIx dw 0
   262                                  
   263                                  ;-68 
   264                                  
   265                                  
   266                                  ;-69 #define FILEBINMAX 2000 //next number - max. oplength
   267                                  
   268                                  
   269                                  ;-70 char FileBin  [FILEBINMAX];//output binary file
   270                                  
   271 0000067F <res 000007D0>          FileBin resb 2000
   272                                  
   273                                  ;-71 unsigned int BinLen=0;  //length of binary file
   274                                  
   275 00000E4F 0000                    BinLen dw 0
   276                                  
   277                                  ;-72 
   278                                  
   279                                  
   280                                  ;-73 char *arglen=0x80;      // for main only
   281                                  
   282 00000E51 8000                    arglen dw 128
   283                                  
   284                                  ;-74 char *argv=0x82;        // for main only
   285                                  
   286 00000E53 8200                    argv dw 130
   287                                  ;Back to main program: AS.C
   288                                  
   289                                  ;-3 #include "OPTABL.C"
   290                                  
   291                                  ;Use include file: OPTABL.C
   292                                  
   293                                  ;-1 char I_START=0xF1;
   294                                  
   295 00000E55 F1                      I_START db 241
   296                                  
   297                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   298                                  
   299                                  
   300                                  ;-3 //  1:   1 byte opcode
   301                                  
   302                                  
   303                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   304                                  
   305 00000E56 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   306                                  
   307                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   308                                  
   309 00000E5F 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   310                                  
   311                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   312                                  
   313 00000E67 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   314                                  
   315                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   316                                  
   317 00000E6E 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   318                                  
   319                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   320                                  
   321 00000E75 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   322                                  
   323                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   324                                  
   325 00000E7D 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   326                                  
   327                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   328                                  
   329 00000E84 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   330                                  
   331                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   332                                  
   333 00000E8B 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   334                                  
   335                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   336                                  
   337 00000E93 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   338                                  
   339                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   340                                  
   341 00000E9C 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   342                                  
   343                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   344                                  
   345 00000EA4 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   346                                  
   347                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   348                                  
   349 00000EAC 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   350                                  
   351                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   352                                  
   353 00000EB4 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   354                                  
   355                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   356                                  
   357 00000EBD 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   358                                  
   359                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   360                                  
   361 00000EC6 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   362                                  
   363                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   364                                  
   365 00000ECF 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   366                                  
   367                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   368                                  
   369 00000ED8 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   370                                  
   371                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   372                                  
   373 00000EE1 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   374                                  
   375                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   376                                  
   377 00000EEA 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   378                                  
   379                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   380                                  
   381 00000EF3 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   382                                  
   383                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   384                                  
   385 00000EFC 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   386                                  
   387                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   388                                  
   389 00000F05 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   390                                  
   391                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   392                                  
   393 00000F0E 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   394                                  
   395                                  ;-27 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   396                                  
   397 00000F17 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   398                                  
   399                                  ;-28 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   400                                  
   401 00000F1F 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   402                                  
   403                                  ;-29 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   404                                  
   405 00000F27 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   406                                  
   407                                  ;-30 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   408                                  
   409 00000F2F 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   410                                  
   411                                  ;-31 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   412                                  
   413 00000F38 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   414                                  
   415                                  ;-32 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   416                                  
   417 00000F41 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   418                                  
   419                                  ;-33 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   420                                  
   421 00000F49 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   422                                  
   423                                  ;-34 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   424                                  
   425 00000F51 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   426                                  
   427                                  ;-35 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   428                                  
   429 00000F58 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   430                                  
   431                                  ;-36 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   432                                  
   433 00000F5F 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   434                                  
   435                                  ;-37 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   436                                  
   437 00000F66 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   438                                  
   439                                  ;-38 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   440                                  
   441 00000F6D 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   442                                  
   443                                  ;-39 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   444                                  
   445 00000F74 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   446                                  
   447                                  ;-40 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   448                                  
   449 00000F7B 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   450                                  
   451                                  ;-41 // 2: mem reg 16 bit
   452                                  
   453                                  
   454                                  ;-42 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   455                                  
   456 00000F82 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   457                                  
   458                                  ;-43 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   459                                  
   460 00000F8B 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   461                                  
   462                                  ;-44 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   463                                  
   464 00000F94 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   465                                  
   466                                  ;-45 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   467                                  
   468 00000F9C 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   469                                  
   470                                  ;-46 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   471                                  
   472 00000FA4 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   473                                  
   474                                  ;-47 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   475                                  
   476 00000FAC 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   477                                  
   478                                  ;-48 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   479                                  
   480 00000FB5 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   481                                  
   482                                  ;-49 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   483                                  
   484 00000FBD 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   485                                  
   486                                  ;-50 //  3: les, lda, lea, lss, lfs, lgs
   487                                  
   488                                  
   489                                  ;-51 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   490                                  
   491 00000FC6 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   492                                  
   493                                  ;-52 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   494                                  
   495 00000FCD 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   496                                  
   497                                  ;-53 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   498                                  
   499 00000FD4 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   500                                  
   501                                  ;-54 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   502                                  
   503 00000FDB 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   504                                  
   505                                  ;-55 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   506                                  
   507 00000FE3 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   508                                  
   509                                  ;-56 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   510                                  
   511 00000FEB 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   512                                  
   513                                  ;-57 //  4: acc,imm  reg,imm  index,reg
   514                                  
   515                                  
   516                                  ;-58 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   517                                  
   518 00000FF3 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   519                                  
   520                                  ;-59 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   521                                  
   522 00000FFA 4F52000401F1            I_OR db 79,82,0,4,1,241
   523                                  
   524                                  ;-60 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   525                                  
   526 00001000 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   527                                  
   528                                  ;-61 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   529                                  
   530 00001007 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   531                                  
   532                                  ;-62 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   533                                  
   534 0000100E 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   535                                  
   536                                  ;-63 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   537                                  
   538 00001015 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   539                                  
   540                                  ;-64 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   541                                  
   542 0000101C 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   543                                  
   544                                  ;-65 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   545                                  
   546 00001023 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   547                                  
   548                                  ;-66 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   549                                  
   550 0000102A 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   551 00001033 00F1               
   552                                  
   553                                  ;-67 //  5: mov
   554                                  
   555                                  
   556                                  ;-68 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   557                                  
   558 00001035 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   559                                  
   560                                  ;-69 char I_MOVSX[]={'M','O','V','S','X',0,  5,0xBE,   0xF1};
   561                                  
   562 0000103B 4D4F5653580005BEF1      I_MOVSX db 77,79,86,83,88,0,5,190,241
   563                                  
   564                                  ;-70 char I_MOVZX[]={'M','O','V','Z','X',0,  5,0xB6,   0xF1};
   565                                  
   566 00001044 4D4F565A580005B6F1      I_MOVZX db 77,79,86,90,88,0,5,182,241
   567                                  
   568                                  ;-71 //  6: single byte relative jump
   569                                  
   570                                  
   571                                  ;-72 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   572                                  
   573 0000104D 4A4F000600F1            I_JO db 74,79,0,6,0,241
   574                                  
   575                                  ;-73 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   576                                  
   577 00001053 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   578                                  
   579                                  ;-74 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   580                                  
   581 0000105A 4A42000602F1            I_JB db 74,66,0,6,2,241
   582                                  
   583                                  ;-75 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   584                                  
   585 00001060 4A43000602F1            I_JC db 74,67,0,6,2,241
   586                                  
   587                                  ;-76 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   588                                  
   589 00001066 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   590                                  
   591                                  ;-77 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   592                                  
   593 0000106D 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   594                                  
   595                                  ;-78 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   596                                  
   597 00001074 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   598                                  
   599                                  ;-79 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   600                                  
   601 0000107B 4A45000604F1            I_JE db 74,69,0,6,4,241
   602                                  
   603                                  ;-80 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   604                                  
   605 00001081 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   606                                  
   607                                  ;-81 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   608                                  
   609 00001087 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   610                                  
   611                                  ;-82 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   612                                  
   613 0000108E 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   614                                  
   615                                  ;-83 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   616                                  
   617 00001095 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   618                                  
   619                                  ;-84 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   620                                  
   621 0000109C 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   622                                  
   623                                  ;-85 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   624                                  
   625 000010A3 4A41000607F1            I_JA db 74,65,0,6,7,241
   626                                  
   627                                  ;-86 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   628                                  
   629 000010A9 4A53000608F1            I_JS db 74,83,0,6,8,241
   630                                  
   631                                  ;-87 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   632                                  
   633 000010AF 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   634                                  
   635                                  ;-88 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   636                                  
   637 000010B6 4A5000060AF1            I_JP db 74,80,0,6,10,241
   638                                  
   639                                  ;-89 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   640                                  
   641 000010BC 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   642                                  
   643                                  ;-90 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   644                                  
   645 000010C3 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   646                                  
   647                                  ;-91 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   648                                  
   649 000010CA 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   650                                  
   651                                  ;-92 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   652                                  
   653 000010D1 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   654                                  
   655                                  ;-93 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   656                                  
   657 000010D7 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   658                                  
   659                                  ;-94 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   660                                  
   661 000010DE 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   662                                  
   663                                  ;-95 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   664                                  
   665 000010E5 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   666                                  
   667                                  ;-96 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   668                                  
   669 000010EC 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   670                                  
   671                                  ;-97 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   672                                  
   673 000010F3 4A4700060FF1            I_JG db 74,71,0,6,15,241
   674                                  
   675                                  ;-98 //  7: jmp, call
   676                                  
   677                                  
   678                                  ;-99 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   679                                  
   680 000010F9 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   681                                  
   682                                  ;-100 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   683                                  
   684 00001101 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   685                                  
   686                                  ;-101 //  8: ret
   687                                  
   688                                  
   689                                  ;-102 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   690                                  
   691 0000110A 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   692                                  
   693                                  ;-103 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   694                                  
   695 00001112 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   696                                  
   697                                  ;-104 //  9: seg, r/m
   698                                  
   699                                  
   700                                  ;-105 char I_PUSH[]= {'P','U','S','H',0,       9,0x50,  0xF1};//r16
   701                                  
   702 0000111B 50555348000950F1        I_PUSH db 80,85,83,72,0,9,80,241
   703                                  
   704                                  ;-106 char I_POP[]=  {'P','O','P',0,           9,0x58,  0xF1};//r16
   705                                  
   706 00001123 504F50000958F1          I_POP db 80,79,80,0,9,88,241
   707                                  
   708                                  ;-107 //  11: shift, rotates
   709                                  
   710                                  
   711                                  ;-108 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   712                                  
   713 0000112A 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   714                                  
   715                                  ;-109 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   716                                  
   717 00001131 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   718                                  
   719                                  ;-110 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   720                                  
   721 00001138 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   722                                  
   723                                  ;-111 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   724                                  
   725 0000113F 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   726                                  
   727                                  ;-112 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   728                                  
   729 00001146 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   730                                  
   731                                  ;-113 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   732                                  
   733 0000114D 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   734                                  
   735                                  ;-114 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   736                                  
   737 00001154 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   738                                  
   739                                  ;-115 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   740                                  
   741 0000115B 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   742                                  
   743                                  ;-116 //  12: int
   744                                  
   745                                  
   746                                  ;-117 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   747                                  
   748 00001162 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   749                                  
   750                                  ;-118 char I_INTO[]= {'I','N','T','O',0,      12,0xCE,   0xF1};
   751                                  
   752 0000116A 494E544F000CCEF1        I_INTO db 73,78,84,79,0,12,206,241
   753                                  
   754                                  ;-119 //  14: in/out
   755                                  
   756                                  
   757                                  ;-120 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   758                                  
   759                                  
   760                                  ;-121 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   761                                  
   762                                  
   763                                  ;-122 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   764                                  
   765                                  
   766                                  ;-123 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   767                                  
   768                                  
   769                                  ;-124 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   770                                  
   771                                  
   772                                  ;-125 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   773                                  
   774                                  
   775                                  ;-126 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   776                                  
   777                                  
   778                                  ;-127 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   779                                  
   780                                  
   781                                  ;-128 //  15: xchg
   782                                  
   783                                  
   784                                  ;-129 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   785                                  
   786 00001172 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   787                                  
   788                                  ;-130 //  16: loop, jcxz
   789                                  
   790                                  
   791                                  ;-131 char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   792                                  
   793 0000117B 4C4F4F504E5A0010E0-     I_LOOPNZ db 76,79,79,80,78,90,0,16,224,241
   794 00001184 F1                 
   795                                  
   796                                  ;-132 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   797                                  
   798 00001185 4C4F4F504E450010E0-     I_LOOPNE db 76,79,79,80,78,69,0,16,224,241
   799 0000118E F1                 
   800                                  
   801                                  ;-133 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   802                                  
   803 0000118F 4C4F4F505A0010E1F1      I_LOOPZ db 76,79,79,80,90,0,16,225,241
   804                                  
   805                                  ;-134 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   806                                  
   807 00001198 4C4F4F50450010E1F1      I_LOOPE db 76,79,79,80,69,0,16,225,241
   808                                  
   809                                  ;-135 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   810                                  
   811 000011A1 4C4F4F500010E2F1        I_LOOP db 76,79,79,80,0,16,226,241
   812                                  
   813                                  ;-136 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   814                                  
   815 000011A9 4A43585A0010E3F1        I_JCXZ db 74,67,88,90,0,16,227,241
   816                                  
   817                                  ;-137 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};
   818                                  
   819 000011B1 4A4543585A0010E3F1      I_JECXZ db 74,69,67,88,90,0,16,227,241
   820                                  
   821                                  ;-138 //  30: enter
   822                                  
   823                                  
   824                                  ;-139 char I_ENTER[]={'E','N','T','E','R',0, 30, 0xC8,  0xF1};
   825                                  
   826 000011BA 454E544552001EC8F1      I_ENTER db 69,78,84,69,82,0,30,200,241
   827                                  
   828                                  ;-140 // 100: directives
   829                                  
   830                                  
   831                                  ;-141 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   832                                  
   833 000011C3 4F52470065F1            I_ORG db 79,82,71,0,101,241
   834                                  
   835                                  ;-142 // section, segment .TEXT .DATA .BSS
   836                                  
   837                                  
   838                                  ;-143 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   839                                  
   840                                  
   841                                  ;-144 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   842                                  
   843                                  
   844                                  ;-145 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   845                                  
   846                                  
   847                                  ;-146 char I_DB[]=   {'D','B',0,            200,        0xF1};
   848                                  
   849 000011C9 444200C8F1              I_DB db 68,66,0,200,241
   850                                  
   851                                  ;-147 char I_DW[]=   {'D','W',0,            201,        0xF1};
   852                                  
   853 000011CE 445700C9F1              I_DW db 68,87,0,201,241
   854                                  
   855                                  ;-148 char I_DD[]=   {'D','D',0,            202,        0xF1};
   856                                  
   857 000011D3 444400CAF1              I_DD db 68,68,0,202,241
   858                                  
   859                                  ;-149 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   860                                  
   861 000011D8 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   862                                  
   863                                  ;-150 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   864                                  
   865 000011DF 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   866                                  
   867                                  ;-151 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   868                                  
   869 000011E6 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   870                                  
   871                                  ;-152 char I_END=0;// end of table char
   872                                  
   873 000011ED 00                      I_END db 0
   874                                  ;Back to main program: AS.C
   875                                  
   876                                  ;-4 
   877                                  
   878                                  
   879                                  ;-5 #include "PARSE.C"
   880                                  
   881                                  ;Use include file: PARSE.C
   882                                  
   883                                  ;-1 int parse() {
   884                                  
   885                                  
   886                                  parse:  ; *** PROC ***
   887                                  
   888                                  ;-2   LabelNamePtr= &LabelNames;
   889                                  
   890 000011EE B8[C901]                 mov ax, LabelNames
   891 000011F1 A3[B105]                 mov word [LabelNamePtr], ax
   892                                  
   893                                  ;-3   do {
   894                                  
   895                                  @@parse1:
   896                                  
   897                                  ;-4     PCStart=PC; OpSize=0; OpPrintIndex=0; PrintR=' ';
   898                                  
   899 000011F4 A1[A601]                 mov ax, [PC]
   900 000011F7 A3[A801]                 mov word [PCStart], ax
   901 000011FA 66B800000000             mov eax, 0
   902 00001200 A2[B601]                 mov byte [OpSize], al
   903 00001203 66B800000000             mov eax, 0
   904 00001209 A3[C401]                 mov word [OpPrintIndex], ax
   905 0000120C 66B820000000             mov eax, 32
   906 00001212 A2[C801]                 mov byte [PrintR], al
   907                                  
   908                                  ;-5     getLine();
   909                                  
   910 00001215 E82C05                   call getLine
   911                                  
   912                                  ;-6     InputPtr = &InputBuf;
   913                                  
   914 00001218 B8[4F00]                 mov ax, InputBuf
   915 0000121B A3[CE00]                 mov word [InputPtr], ax
   916                                  
   917                                  ;-7     getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
   918                                  
   919 0000121E E8B700                   call getTokeType
   920                                  
   921                                  ;-8     if (TokeType == ALNUME) {
   922                                  
   923 00001221 A0[AB01]                 mov al, [TokeType]
   924 00001224 3C03                     cmp al, 3
   925 00001226 0F851300                 jne @@parse2
   926                                  
   927                                  ;-9       if (isLabel) { //set in getName
   928                                  
   929 0000122A A0[AA01]                 mov al, [isLabel]
   930 0000122D 08C0                     or  al, al
   931 0000122F 0F840A00                 je @@parse3
   932                                  
   933                                  ;-10         storeLabel();
   934                                  
   935 00001233 E84001                   call storeLabel
   936                                  
   937                                  ;-11         InputPtr++;//remove :
   938                                  
   939 00001236 FF06[CE00]               inc  word [InputPtr]
   940                                  
   941                                  ;-12         getTokeType();
   942                                  
   943 0000123A E89B00                   call getTokeType
   944                                  
   945                                  ;-13       }
   946                                  
   947                                  
   948                                  ;-14     }
   949                                  
   950                                  @@parse3:
   951                                  
   952                                  ;-15     if (TokeType == ALNUME) {
   953                                  
   954                                  @@parse2:
   955 0000123D A0[AB01]                 mov al, [TokeType]
   956 00001240 3C03                     cmp al, 3
   957 00001242 0F851B00                 jne @@parse4
   958                                  
   959                                  ;-16       lookCode();// and OpCodePtr
   960                                  
   961 00001246 E86803                   call lookCode
   962                                  
   963                                  ;-17       if(CodeType) process();
   964                                  
   965 00001249 A0[AE01]                 mov al, [CodeType]
   966 0000124C 08C0                     or  al, al
   967 0000124E 0F840600                 je @@parse5
   968 00001252 E84B16                   call process
   969                                  
   970                                  ;-18       else getVariable();
   971                                  
   972 00001255 E90300                   jmp @@parse6
   973                                  @@parse5:
   974 00001258 E81E02                   call getVariable
   975                                  
   976                                  ;-19       skipRest();
   977                                  
   978                                  @@parse6:
   979 0000125B E8BD04                   call skipRest
   980                                  
   981                                  ;-20     }
   982                                  
   983                                  
   984                                  ;-21     else if (TokeType >ALNUME) error1("Label or instruction expected");
   985                                  
   986 0000125E E92700                   jmp @@parse7
   987                                  @@parse4:
   988 00001261 A0[AB01]                 mov al, [TokeType]
   989 00001264 3C03                     cmp al, 3
   990 00001266 0F8E0C00                 jle @@parse8
   991 0000126A 68[9912]                 push parse_0
   992 0000126D E8920E                   call error1
   993 00001270 83C402                   add  sp, 2
   994                                  
   995                                  ;-22     else if (TokeType==DIGIT) error1("No digit allowed @ start of line");
   996                                  
   997 00001273 E91200                   jmp @@parse9
   998                                  @@parse8:
   999 00001276 A0[AB01]                 mov al, [TokeType]
  1000 00001279 3C01                     cmp al, 1
  1001 0000127B 0F850900                 jne @@parse10
  1002 0000127F 68[B712]                 push parse_1
  1003 00001282 E87D0E                   call error1
  1004 00001285 83C402                   add  sp, 2
  1005                                  
  1006                                  ;-23     printLine();
  1007                                  
  1008                                  @@parse10:
  1009                                  @@parse9:
  1010                                  @@parse7:
  1011 00001288 E80C0C                   call printLine
  1012                                  
  1013                                  ;-24   } while (DOS_NoBytes != 0 );
  1014                                  
  1015 0000128B A1[A301]                 mov ax, [DOS_NoBytes]
  1016 0000128E 83F800                   cmp ax, 0
  1017 00001291 0F840300                 je  @@parse11
  1018 00001295 E95CFF                   jmp @@parse1
  1019                                  @@parse11:
  1020                                  
  1021                                  ;-25 }
  1022                                  
  1023                                  
  1024                                  ;-26 // scan code .....................................
  1025                                  
  1026                                  
  1027                                  ;-27 int getTokeType() { char c;
  1028                                  
  1029 00001298 C3                       ret
  1030                                  ; ENDP
  1031 00001299 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  1032 000012A2 696E73747275637469-
  1033 000012AB 6F6E20657870656374-
  1034 000012B4 656400             
  1035 000012B7 4E6F20646967697420-     parse_1 db "No digit allowed @ start of line",0
  1036 000012C0 616C6C6F7765642040-
  1037 000012C9 207374617274206F66-
  1038 000012D2 206C696E6500       
  1039                                  
  1040                                  getTokeType:  ; *** PROC ***
  1041                                  
  1042                                  ;-28   skipBlank();
  1043                                  
  1044                                  ;Function : getTokeType, Number of local variables: 1
  1045                                  ;   # type sign width line used address name   list of local variables
  1046                                  ;  200 var sign byte    27 NULL bp-2    c;
  1047 000012D8 C8020000                 ENTER  2,0
  1048 000012DC E86705                   call skipBlank
  1049                                  
  1050                                  ;-29   c = *InputPtr;
  1051                                  
  1052 000012DF 8B1E[CE00]               mov bx, [InputPtr]
  1053 000012E3 8A07                     mov al, [bx]
  1054 000012E5 B400                     mov ah, 0
  1055 000012E7 8846FE                   mov byte [bp-2], al
  1056                                  
  1057                                  ;-30   if (c == 0)   {TokeType=0; return; }//last line or empty line
  1058                                  
  1059 000012EA 8A46FE                   mov al, [bp-2]
  1060 000012ED 3C00                     cmp al, 0
  1061 000012EF 0F850C00                 jne @@getTokeType12
  1062 000012F3 66B800000000             mov eax, 0
  1063 000012F9 A2[AB01]                 mov byte [TokeType], al
  1064 000012FC E97500                   jmp @@retn
  1065                                  
  1066                                  ;-31   if (c == ';') {TokeType=0; return; }//comment
  1067                                  
  1068                                  @@getTokeType12:
  1069 000012FF 8A46FE                   mov al, [bp-2]
  1070 00001302 3C3B                     cmp al, 59
  1071 00001304 0F850C00                 jne @@getTokeType13
  1072 00001308 66B800000000             mov eax, 0
  1073 0000130E A2[AB01]                 mov byte [TokeType], al
  1074 00001311 E96000                   jmp @@retn
  1075                                  
  1076                                  ;-32   if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  1077                                  
  1078                                  @@getTokeType13:
  1079 00001314 8A46FE                   mov al, byte [bp-2]
  1080 00001317 B400                     mov ah, 0
  1081 00001319 50                       push ax
  1082 0000131A E8AA1D                   call digit
  1083 0000131D 83C402                   add  sp, 2
  1084 00001320 08C0                     or  al, al
  1085 00001322 0F841800                 je @@getTokeType14
  1086 00001326 8A46FE                   mov al, byte [bp-2]
  1087 00001329 B400                     mov ah, 0
  1088 0000132B 50                       push ax
  1089 0000132C E81D06                   call getDigit
  1090 0000132F 83C402                   add  sp, 2
  1091 00001332 66B801000000             mov eax, 1
  1092 00001338 A2[AB01]                 mov byte [TokeType], al
  1093 0000133B E93600                   jmp @@retn
  1094                                  
  1095                                  ;-33   if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  1096                                  
  1097                                  @@getTokeType14:
  1098 0000133E 8A46FE                   mov al, byte [bp-2]
  1099 00001341 B400                     mov ah, 0
  1100 00001343 50                       push ax
  1101 00001344 E82A05                   call letterE
  1102 00001347 83C402                   add  sp, 2
  1103 0000134A 08C0                     or  al, al
  1104 0000134C 0F841800                 je @@getTokeType15
  1105 00001350 8A46FE                   mov al, byte [bp-2]
  1106 00001353 B400                     mov ah, 0
  1107 00001355 50                       push ax
  1108 00001356 E84A06                   call getName
  1109 00001359 83C402                   add  sp, 2
  1110 0000135C 66B803000000             mov eax, 3
  1111 00001362 A2[AB01]                 mov byte [TokeType], al
  1112 00001365 E90C00                   jmp @@retn
  1113                                  
  1114                                  ;-34   TokeType=NOALNUME; return;
  1115                                  
  1116                                  @@getTokeType15:
  1117 00001368 66B804000000             mov eax, 4
  1118 0000136E A2[AB01]                 mov byte [TokeType], al
  1119 00001371 E90000                   jmp @@retn
  1120                                  
  1121                                  ;-35 }
  1122                                  
  1123                                  
  1124                                  ;-36 int storeLabel() {unsigned int i;
  1125                                  
  1126 00001374 C9                      @@retn: LEAVE
  1127 00001375 C3                       ret
  1128                                  ; ENDP
  1129                                  
  1130                                  storeLabel:  ; *** PROC ***
  1131                                  
  1132                                  ;-37   if(searchLabel()) error1("duplicate label");
  1133                                  
  1134                                  ;Function : storeLabel, Number of local variables: 1
  1135                                  ;   # type sign width line used address name   list of local variables
  1136                                  ;  200 var unsg word    36 NULL bp-2    i;
  1137 00001376 C8020000                 ENTER  2,0
  1138 0000137A E89C00                   call searchLabel
  1139 0000137D 08C0                     or  al, al
  1140 0000137F 0F840900                 je @@storeLabel16
  1141 00001383 68[E413]                 push storeLabel_0
  1142 00001386 E8790D                   call error1
  1143 00001389 83C402                   add  sp, 2
  1144                                  
  1145                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1146                                  
  1147                                  @@storeLabel16:
  1148 0000138C 8D06[0F00]               lea  ax, [Symbol]
  1149 00001390 50                       push ax
  1150 00001391 FF36[B105]               push word [LabelNamePtr]
  1151 00001395 E8F61C                   call strcpy
  1152 00001398 83C404                   add  sp, 4
  1153 0000139B A3[B105]                 mov word [LabelNamePtr], ax
  1154                                  
  1155                                  ;-39   LabelNamePtr++;
  1156                                  
  1157 0000139E FF06[B105]               inc  word [LabelNamePtr]
  1158                                  
  1159                                  ;-40   i = LabelNamePtr - &LabelNames;//todo
  1160                                  
  1161 000013A2 A1[B105]                 mov ax, [LabelNamePtr]
  1162 000013A5 2D[C901]                 sub ax, LabelNames
  1163 000013A8 8946FE                   mov word [bp-2], ax
  1164                                  
  1165                                  ;-41   if (i >= LABELNAMESMAX) errorexit("too long label names");
  1166                                  
  1167 000013AB 8B46FE                   mov ax, [bp-2]
  1168 000013AE 3DC903                   cmp ax, 969 ;unsigned : 0
  1169 000013B1 0F820900                 jb  @@storeLabel17
  1170 000013B5 68[F413]                 push storeLabel_1
  1171 000013B8 E8000F                   call errorexit
  1172 000013BB 83C402                   add  sp, 2
  1173                                  
  1174                                  ;-42   LabelMaxIx++;
  1175                                  
  1176                                  @@storeLabel17:
  1177 000013BE FF06[7B06]               inc  word [LabelMaxIx]
  1178                                  
  1179                                  ;-43   if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  1180                                  
  1181 000013C2 A1[7B06]                 mov ax, [LabelMaxIx]
  1182 000013C5 83F864                   cmp ax, 100 ;unsigned : 1
  1183 000013C8 0F8C0900                 jl  @@storeLabel18
  1184 000013CC 68[0914]                 push storeLabel_2
  1185 000013CF E8E90E                   call errorexit
  1186 000013D2 83C402                   add  sp, 2
  1187                                  
  1188                                  ;-44   LabelAddr[LabelMaxIx] = PC;
  1189                                  
  1190                                  @@storeLabel18:
  1191 000013D5 A1[A601]                 mov ax, [PC]
  1192 000013D8 8B1E[7B06]               mov bx, [LabelMaxIx]
  1193 000013DC D1E3                     shl bx, 1
  1194 000013DE 8987[B305]               mov [LabelAddr+bx], ax
  1195                                  
  1196                                  ;-45 }
  1197                                  
  1198                                  
  1199                                  ;-46 int searchLabel() {
  1200 000013E2 C9                       LEAVE
  1201 000013E3 C3                       ret
  1202                                  ; ENDP
  1203 000013E4 6475706C6963617465-     storeLabel_0 db "duplicate label",0
  1204 000013ED 206C6162656C00     
  1205 000013F4 746F6F206C6F6E6720-     storeLabel_1 db "too long label names",0
  1206 000013FD 6C6162656C206E616D-
  1207 00001406 657300             
  1208 00001409 746F6F206D616E7920-     storeLabel_2 db "too many labels",0
  1209 00001412 6C6162656C7300     
  1210                                  
  1211                                  searchLabel:  ; *** PROC ***
  1212                                  
  1213                                  ;-47   int LIx; char *p; int j;
  1214                                  
  1215                                  
  1216                                  ;-48   p = &LabelNames;
  1217                                  
  1218                                  ;Function : searchLabel, Number of local variables: 3
  1219                                  ;   # type sign width line used address name   list of local variables
  1220                                  ;  200 var sign word    47 NULL bp-2    LIx
  1221                                  ;  201 ptr sign byte    47 NULL bp-4    p
  1222                                  ;  202 var sign word    47 NULL bp-6    j;
  1223 00001419 C8060000                 ENTER  6,0
  1224 0000141D B8[C901]                 mov ax, LabelNames
  1225 00001420 8946FC                   mov word [bp-4], ax
  1226                                  
  1227                                  ;-49   LIx=1;
  1228                                  
  1229 00001423 66B801000000             mov eax, 1
  1230 00001429 8946FE                   mov word [bp-2], ax
  1231                                  
  1232                                  ;-50   while (LIx <= LabelMaxIx) {
  1233                                  
  1234                                  @@searchLabel19:
  1235 0000142C 8B46FE                   mov ax, [bp-2]
  1236 0000142F 3B06[7B06]               cmp ax, [LabelMaxIx]
  1237 00001433 0F8F3700                 jg  @@searchLabel20
  1238                                  
  1239                                  ;-51     if (eqstr(p, Symbol)) return LIx;//pos of label
  1240                                  
  1241 00001437 8D06[0F00]               lea  ax, [Symbol]
  1242 0000143B 50                       push ax
  1243 0000143C FF76FC                   push word [bp-4]
  1244 0000143F E8B81C                   call eqstr
  1245 00001442 83C404                   add  sp, 4
  1246 00001445 08C0                     or  al, al
  1247 00001447 0F840600                 je @@searchLabel21
  1248 0000144B 8B46FE                   mov ax, [bp-2]
  1249 0000144E E92600                   jmp @@retn
  1250                                  
  1251                                  ;-52     j=strlen(p);
  1252                                  
  1253                                  @@searchLabel21:
  1254 00001451 FF76FC                   push word [bp-4]
  1255 00001454 E80C1C                   call strlen
  1256 00001457 83C402                   add  sp, 2
  1257 0000145A 8946FA                   mov word [bp-6], ax
  1258                                  
  1259                                  ;-53     p=p+j; p++; LIx++;
  1260                                  
  1261 0000145D 8B46FC                   mov ax, [bp-4]
  1262 00001460 0346FA                   add ax, [bp-6]
  1263 00001463 8946FC                   mov word [bp-4], ax
  1264 00001466 FF46FC                   inc  word [bp-4]
  1265 00001469 FF46FE                   inc  word [bp-2]
  1266                                  
  1267                                  ;-54   }
  1268                                  
  1269                                  
  1270                                  ;-55   return 0;
  1271                                  
  1272 0000146C EBBE                     jmp @@searchLabel19
  1273                                  @@searchLabel20:
  1274 0000146E 66B800000000             mov eax, 0
  1275 00001474 E90000                   jmp @@retn
  1276                                  
  1277                                  ;-56 }
  1278                                  
  1279                                  
  1280                                  ;-57 int getVariable() { char c;
  1281                                  
  1282 00001477 C9                      @@retn: LEAVE
  1283 00001478 C3                       ret
  1284                                  ; ENDP
  1285                                  
  1286                                  getVariable:  ; *** PROC ***
  1287                                  
  1288                                  ;-58   storeLabel();
  1289                                  
  1290                                  ;Function : getVariable, Number of local variables: 1
  1291                                  ;   # type sign width line used address name   list of local variables
  1292                                  ;  200 var sign byte    57 NULL bp-2    c;
  1293 00001479 C8020000                 ENTER  2,0
  1294 0000147D E8F6FE                   call storeLabel
  1295                                  
  1296                                  ;-59   getTokeType(); if(TokeType==ALNUME) {// getName
  1297                                  
  1298 00001480 E855FE                   call getTokeType
  1299 00001483 A0[AB01]                 mov al, [TokeType]
  1300 00001486 3C03                     cmp al, 3
  1301 00001488 0F85CC00                 jne @@getVariable22
  1302                                  
  1303                                  ;-60     lookCode();
  1304                                  
  1305 0000148C E82201                   call lookCode
  1306                                  
  1307                                  ;-61     if (CodeType < 200) errorexit("D or RES B,W,D expected");
  1308                                  
  1309 0000148F A0[AE01]                 mov al, [CodeType]
  1310 00001492 3CC8                     cmp al, 200
  1311 00001494 0F8D0900                 jge @@getVariable23
  1312 00001498 68[6315]                 push getVariable_0
  1313 0000149B E81D0E                   call errorexit
  1314 0000149E 83C402                   add  sp, 2
  1315                                  
  1316                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1317                                  
  1318                                  @@getVariable23:
  1319 000014A1 A0[AE01]                 mov al, [CodeType]
  1320 000014A4 3CCF                     cmp al, 207
  1321 000014A6 0F8E0900                 jle @@getVariable24
  1322 000014AA 68[7B15]                 push getVariable_1
  1323 000014AD E80B0E                   call errorexit
  1324 000014B0 83C402                   add  sp, 2
  1325                                  
  1326                                  ;-63     if (CodeType== 200) {// DB
  1327                                  
  1328                                  @@getVariable24:
  1329 000014B3 A0[AE01]                 mov al, [CodeType]
  1330 000014B6 3CC8                     cmp al, 200
  1331 000014B8 0F856A00                 jne @@getVariable25
  1332                                  
  1333                                  ;-64       do { getTokeType();
  1334                                  
  1335                                  @@getVariable26:
  1336 000014BC E819FE                   call getTokeType
  1337                                  
  1338                                  ;-65         if (TokeType ==DIGIT) genCode8(SymbolInt);
  1339                                  
  1340 000014BF A0[AB01]                 mov al, [TokeType]
  1341 000014C2 3C01                     cmp al, 1
  1342 000014C4 0F850D00                 jne @@getVariable27
  1343 000014C8 FF36[4D00]               push word [SymbolInt]
  1344 000014CC E8E911                   call genCode8
  1345 000014CF 83C402                   add  sp, 2
  1346                                  
  1347                                  ;-66         else {
  1348                                  
  1349 000014D2 E94100                   jmp @@getVariable28
  1350                                  @@getVariable27:
  1351                                  
  1352                                  ;-67           skipBlank();
  1353                                  
  1354 000014D5 E86E03                   call skipBlank
  1355                                  
  1356                                  ;-68           if (isToken('"')) {
  1357                                  
  1358 000014D8 6A22                     push 34
  1359 000014DA E8D101                   call isToken
  1360 000014DD 83C402                   add  sp, 2
  1361 000014E0 08C0                     or  al, al
  1362 000014E2 0F843000                 je @@getVariable29
  1363                                  
  1364                                  ;-69             do { c= *InputPtr;
  1365                                  
  1366                                  @@getVariable30:
  1367 000014E6 8B1E[CE00]               mov bx, [InputPtr]
  1368 000014EA 8A07                     mov al, [bx]
  1369 000014EC B400                     mov ah, 0
  1370 000014EE 8846FE                   mov byte [bp-2], al
  1371                                  
  1372                                  ;-70               genCode8(c);
  1373                                  
  1374 000014F1 8A46FE                   mov al, byte [bp-2]
  1375 000014F4 B400                     mov ah, 0
  1376 000014F6 50                       push ax
  1377 000014F7 E8BE11                   call genCode8
  1378 000014FA 83C402                   add  sp, 2
  1379                                  
  1380                                  ;-71               InputPtr++;
  1381                                  
  1382 000014FD FF06[CE00]               inc  word [InputPtr]
  1383                                  
  1384                                  ;-72             } while (*InputPtr != '"' );
  1385                                  
  1386 00001501 8B1E[CE00]               mov bx, [InputPtr]
  1387 00001505 8A07                     mov al, [bx]
  1388 00001507 B400                     mov ah, 0
  1389 00001509 83F822                   cmp ax, 34
  1390 0000150C 0F840200                 je  @@getVariable31
  1391 00001510 EBD4                     jmp @@getVariable30
  1392                                  @@getVariable31:
  1393                                  
  1394                                  ;-73             InputPtr++;
  1395                                  
  1396 00001512 FF06[CE00]               inc  word [InputPtr]
  1397                                  
  1398                                  ;-74           }
  1399                                  
  1400                                  
  1401                                  ;-75         }
  1402                                  
  1403                                  @@getVariable29:
  1404                                  
  1405                                  ;-76       } while (isToken(','));
  1406                                  
  1407                                  @@getVariable28:
  1408 00001516 6A2C                     push 44
  1409 00001518 E89301                   call isToken
  1410 0000151B 83C402                   add  sp, 2
  1411 0000151E 08C0                     or  al, al
  1412 00001520 0F840200                 je @@getVariable32
  1413 00001524 EB96                     jmp @@getVariable26
  1414                                  @@getVariable32:
  1415                                  
  1416                                  ;-77     }
  1417                                  
  1418                                  
  1419                                  ;-78     if (CodeType== 201) {// DW
  1420                                  
  1421                                  @@getVariable25:
  1422 00001526 A0[AE01]                 mov al, [CodeType]
  1423 00001529 3CC9                     cmp al, 201
  1424 0000152B 0F852600                 jne @@getVariable33
  1425                                  
  1426                                  ;-79       do { getTokeType();
  1427                                  
  1428                                  @@getVariable34:
  1429 0000152F E8A6FD                   call getTokeType
  1430                                  
  1431                                  ;-80         if (TokeType ==DIGIT) genCode16(SymbolInt);
  1432                                  
  1433 00001532 A0[AB01]                 mov al, [TokeType]
  1434 00001535 3C01                     cmp al, 1
  1435 00001537 0F850A00                 jne @@getVariable35
  1436 0000153B FF36[4D00]               push word [SymbolInt]
  1437 0000153F E8CD11                   call genCode16
  1438 00001542 83C402                   add  sp, 2
  1439                                  
  1440                                  ;-81       } while (isToken(','));
  1441                                  
  1442                                  @@getVariable35:
  1443 00001545 6A2C                     push 44
  1444 00001547 E86401                   call isToken
  1445 0000154A 83C402                   add  sp, 2
  1446 0000154D 08C0                     or  al, al
  1447 0000154F 0F840200                 je @@getVariable36
  1448 00001553 EBDA                     jmp @@getVariable34
  1449                                  @@getVariable36:
  1450                                  
  1451                                  ;-82     }
  1452                                  
  1453                                  
  1454                                  ;-83   }
  1455                                  
  1456                                  @@getVariable33:
  1457                                  
  1458                                  ;-84   else errorexit("DB,DW,DD or RESB,W,D expected");
  1459                                  
  1460 00001555 E90900                   jmp @@getVariable37
  1461                                  @@getVariable22:
  1462 00001558 68[9315]                 push getVariable_2
  1463 0000155B E85D0D                   call errorexit
  1464 0000155E 83C402                   add  sp, 2
  1465                                  
  1466                                  ;-85 }
  1467                                  
  1468                                  @@getVariable37:
  1469                                  
  1470                                  ;-86 int lookCode() { // ret: CodeType, *OpCodePtr
  1471 00001561 C9                       LEAVE
  1472 00001562 C3                       ret
  1473                                  ; ENDP
  1474 00001563 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  1475 0000156C 422C572C4420657870-
  1476 00001575 656374656400       
  1477 0000157B 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  1478 00001584 422C572C4420657870-
  1479 0000158D 656374656400       
  1480 00001593 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  1481 0000159C 6F7220524553422C57-
  1482 000015A5 2C4420657870656374-
  1483 000015AE 656400             
  1484                                  
  1485                                  lookCode:  ; *** PROC ***
  1486                                  
  1487                                  ;-87   CodeType=0;
  1488                                  
  1489 000015B1 66B800000000             mov eax, 0
  1490 000015B7 A2[AE01]                 mov byte [CodeType], al
  1491                                  
  1492                                  ;-88   OpCodePtr= &I_START;
  1493                                  
  1494 000015BA B8[550E]                 mov ax, I_START
  1495 000015BD A3[C601]                 mov word [OpCodePtr], ax
  1496                                  
  1497                                  ;-89   OpCodePtr++;
  1498                                  
  1499 000015C0 FF06[C601]               inc  word [OpCodePtr]
  1500                                  
  1501                                  ;-90   do  {
  1502                                  
  1503                                  @@lookCode38:
  1504                                  
  1505                                  ;-91     if (eqstr(SymbolUpper, OpCodePtr))  {
  1506                                  
  1507 000015C4 FF36[C601]               push word [OpCodePtr]
  1508 000015C8 8D06[2E00]               lea  ax, [SymbolUpper]
  1509 000015CC 50                       push ax
  1510 000015CD E82A1B                   call eqstr
  1511 000015D0 83C404                   add  sp, 4
  1512 000015D3 08C0                     or  al, al
  1513 000015D5 0F842700                 je @@lookCode39
  1514                                  
  1515                                  ;-92       while(*OpCodePtr!=0) OpCodePtr++;
  1516                                  
  1517                                  @@lookCode40:
  1518 000015D9 8B1E[C601]               mov bx, [OpCodePtr]
  1519 000015DD 8A07                     mov al, [bx]
  1520 000015DF B400                     mov ah, 0
  1521 000015E1 83F800                   cmp ax, 0
  1522 000015E4 0F840600                 je  @@lookCode41
  1523 000015E8 FF06[C601]               inc  word [OpCodePtr]
  1524                                  
  1525                                  ;-93       OpCodePtr++; CodeType =*OpCodePtr;
  1526                                  
  1527 000015EC EBEB                     jmp @@lookCode40
  1528                                  @@lookCode41:
  1529 000015EE FF06[C601]               inc  word [OpCodePtr]
  1530 000015F2 8B1E[C601]               mov bx, [OpCodePtr]
  1531 000015F6 8A07                     mov al, [bx]
  1532 000015F8 B400                     mov ah, 0
  1533 000015FA A2[AE01]                 mov byte [CodeType], al
  1534                                  
  1535                                  ;-94       return;
  1536                                  
  1537 000015FD E92A00                   jmp @@retn
  1538                                  
  1539                                  ;-95     }
  1540                                  
  1541                                  
  1542                                  ;-96   while(*OpCodePtr!=0xF1) OpCodePtr++;
  1543                                  
  1544                                  @@lookCode39:
  1545                                  @@lookCode42:
  1546 00001600 8B1E[C601]               mov bx, [OpCodePtr]
  1547 00001604 8A07                     mov al, [bx]
  1548 00001606 B400                     mov ah, 0
  1549 00001608 3DF100                   cmp ax, 241
  1550 0000160B 0F840600                 je  @@lookCode43
  1551 0000160F FF06[C601]               inc  word [OpCodePtr]
  1552                                  
  1553                                  ;-97   OpCodePtr++;
  1554                                  
  1555 00001613 EBEB                     jmp @@lookCode42
  1556                                  @@lookCode43:
  1557 00001615 FF06[C601]               inc  word [OpCodePtr]
  1558                                  
  1559                                  ;-98   } while(*OpCodePtr!=0);
  1560                                  
  1561 00001619 8B1E[C601]               mov bx, [OpCodePtr]
  1562 0000161D 8A07                     mov al, [bx]
  1563 0000161F B400                     mov ah, 0
  1564 00001621 83F800                   cmp ax, 0
  1565 00001624 0F840200                 je  @@lookCode44
  1566 00001628 EB9A                     jmp @@lookCode38
  1567                                  @@lookCode44:
  1568                                  
  1569                                  ;-99 }
  1570                                  
  1571                                  
  1572                                  ;-100 
  1573                                  
  1574                                  
  1575                                  ;-101 int getCodeSize() {
  1576                                  
  1577                                  @@retn:
  1578 0000162A C3                       ret
  1579                                  ; ENDP
  1580                                  
  1581                                  getCodeSize:  ; *** PROC ***
  1582                                  
  1583                                  ;-102   if (TokeType ==ALNUME) {
  1584                                  
  1585 0000162B A0[AB01]                 mov al, [TokeType]
  1586 0000162E 3C03                     cmp al, 3
  1587 00001630 0F856000                 jne @@getCodeSize45
  1588                                  
  1589                                  ;-103     if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  1590                                  
  1591 00001634 68[9E16]                 push getCodeSize_0
  1592 00001637 8D06[2E00]               lea  ax, [SymbolUpper]
  1593 0000163B 50                       push ax
  1594 0000163C E8BB1A                   call eqstr
  1595 0000163F 83C404                   add  sp, 4
  1596 00001642 08C0                     or  al, al
  1597 00001644 0F840C00                 je @@getCodeSize46
  1598 00001648 E88DFC                   call getTokeType
  1599 0000164B 66B801000000             mov eax, 1
  1600 00001651 E94900                   jmp @@retn
  1601                                  
  1602                                  ;-104     if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  1603                                  
  1604                                  @@getCodeSize46:
  1605 00001654 68[A316]                 push getCodeSize_1
  1606 00001657 8D06[2E00]               lea  ax, [SymbolUpper]
  1607 0000165B 50                       push ax
  1608 0000165C E89B1A                   call eqstr
  1609 0000165F 83C404                   add  sp, 4
  1610 00001662 08C0                     or  al, al
  1611 00001664 0F840C00                 je @@getCodeSize47
  1612 00001668 E86DFC                   call getTokeType
  1613 0000166B 66B802000000             mov eax, 2
  1614 00001671 E92900                   jmp @@retn
  1615                                  
  1616                                  ;-105     if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  1617                                  
  1618                                  @@getCodeSize47:
  1619 00001674 68[A816]                 push getCodeSize_2
  1620 00001677 8D06[2E00]               lea  ax, [SymbolUpper]
  1621 0000167B 50                       push ax
  1622 0000167C E87B1A                   call eqstr
  1623 0000167F 83C404                   add  sp, 4
  1624 00001682 08C0                     or  al, al
  1625 00001684 0F840C00                 je @@getCodeSize48
  1626 00001688 E84DFC                   call getTokeType
  1627 0000168B 66B803000000             mov eax, 3
  1628 00001691 E90900                   jmp @@retn
  1629                                  
  1630                                  ;-106   } return 0;
  1631                                  
  1632                                  @@getCodeSize48:
  1633                                  @@getCodeSize45:
  1634 00001694 66B800000000             mov eax, 0
  1635 0000169A E90000                   jmp @@retn
  1636                                  
  1637                                  ;-107 }
  1638                                  
  1639                                  
  1640                                  ;-108 int isToken(char c) {
  1641                                  
  1642                                  @@retn:
  1643 0000169D C3                       ret
  1644                                  ; ENDP
  1645 0000169E 4259544500              getCodeSize_0 db "BYTE",0
  1646 000016A3 574F524400              getCodeSize_1 db "WORD",0
  1647 000016A8 44574F524400            getCodeSize_2 db "DWORD",0
  1648                                  
  1649                                  isToken:  ; *** PROC ***
  1650                                  
  1651                                  ;-109   skipBlank();
  1652                                  
  1653                                  ;Function : isToken, Number of local variables: 1
  1654                                  ;   # type sign width line used address name   list of local variables
  1655                                  ;  200 var sign byte   108 NULL bp+4    c;
  1656 000016AE C8000000                 ENTER  0,0
  1657 000016B2 E89101                   call skipBlank
  1658                                  
  1659                                  ;-110   if (*InputPtr == c) {
  1660                                  
  1661 000016B5 8B1E[CE00]               mov bx, [InputPtr]
  1662 000016B9 8A07                     mov al, [bx]
  1663 000016BB B400                     mov ah, 0
  1664 000016BD 3A4604                   cmp al, [bp+4]
  1665 000016C0 0F850D00                 jne @@isToken49
  1666                                  
  1667                                  ;-111     InputPtr++; return 1;} return 0;
  1668                                  
  1669 000016C4 FF06[CE00]               inc  word [InputPtr]
  1670 000016C8 66B801000000             mov eax, 1
  1671 000016CE E90900                   jmp @@retn
  1672                                  @@isToken49:
  1673 000016D1 66B800000000             mov eax, 0
  1674 000016D7 E90000                   jmp @@retn
  1675                                  
  1676                                  ;-112 }
  1677                                  
  1678                                  
  1679                                  ;-113 int need(char c) {
  1680                                  
  1681 000016DA C9                      @@retn: LEAVE
  1682 000016DB C3                       ret
  1683                                  ; ENDP
  1684                                  
  1685                                  need:  ; *** PROC ***
  1686                                  
  1687                                  ;-114   if (isToken(c)) {
  1688                                  
  1689                                  ;Function : need, Number of local variables: 1
  1690                                  ;   # type sign width line used address name   list of local variables
  1691                                  ;  200 var sign byte   113 NULL bp+4    c;
  1692 000016DC C8000000                 ENTER  0,0
  1693 000016E0 8A4604                   mov al, byte [bp+4]
  1694 000016E3 B400                     mov ah, 0
  1695 000016E5 50                       push ax
  1696 000016E6 E8C5FF                   call isToken
  1697 000016E9 83C402                   add  sp, 2
  1698 000016EC 08C0                     or  al, al
  1699 000016EE 0F840600                 je @@need50
  1700                                  
  1701                                  ;-115       getTokeType();
  1702                                  
  1703 000016F2 E8E3FB                   call getTokeType
  1704                                  
  1705                                  ;-116       return;
  1706                                  
  1707 000016F5 E91800                   jmp @@retn
  1708                                  
  1709                                  ;-117       }
  1710                                  
  1711                                  
  1712                                  ;-118   error1();
  1713                                  
  1714                                  @@need50:
  1715 000016F8 E8070A                   call error1
  1716                                  
  1717                                  ;-119   prs(". need: ");
  1718                                  
  1719 000016FB 68[1217]                 push need_0
  1720 000016FE E8A408                   call prs
  1721 00001701 83C402                   add  sp, 2
  1722                                  
  1723                                  ;-120   prc(c);
  1724                                  
  1725 00001704 8A4604                   mov al, byte [bp+4]
  1726 00001707 B400                     mov ah, 0
  1727 00001709 50                       push ax
  1728 0000170A E83708                   call prc
  1729 0000170D 83C402                   add  sp, 2
  1730                                  
  1731                                  ;-121 }
  1732                                  
  1733                                  
  1734                                  ;-122 
  1735                                  
  1736                                  
  1737                                  ;-123 int skipRest() {
  1738                                  
  1739 00001710 C9                      @@retn: LEAVE
  1740 00001711 C3                       ret
  1741                                  ; ENDP
  1742 00001712 2E206E6565643A2000      need_0 db ". need: ",0
  1743                                  
  1744                                  skipRest:  ; *** PROC ***
  1745                                  
  1746                                  ;-124   getTokeType(); 
  1747                                  
  1748 0000171B E8BAFB                   call getTokeType
  1749                                  
  1750                                  ;-125   if(TokeType)error1("extra char ignored");
  1751                                  
  1752 0000171E A0[AB01]                 mov al, [TokeType]
  1753 00001721 08C0                     or  al, al
  1754 00001723 0F840900                 je @@skipRest51
  1755 00001727 68[3117]                 push skipRest_0
  1756 0000172A E8D509                   call error1
  1757 0000172D 83C402                   add  sp, 2
  1758                                  
  1759                                  ;-126 }
  1760                                  
  1761                                  @@skipRest51:
  1762 00001730 C3                       ret
  1763                                  ; ENDP
  1764 00001731 657874726120636861-     skipRest_0 db "extra char ignored",0
  1765 0000173A 722069676E6F726564-
  1766 00001743 00                 
  1767                                  ;Back to main program: AS.C
  1768                                  
  1769                                  ;-6 #include "HELPER.C"
  1770                                  
  1771                                  ;Use include file: HELPER.C
  1772                                  
  1773                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  1774                                  
  1775                                  
  1776                                  getLine:  ; *** PROC ***
  1777                                  
  1778                                  ;-2   unsigned int i;
  1779                                  
  1780                                  
  1781                                  ;-3   InputPtr= &InputBuf;
  1782                                  
  1783                                  ;Function : getLine, Number of local variables: 1
  1784                                  ;   # type sign width line used address name   list of local variables
  1785                                  ;  200 var unsg word     2 NULL bp-2    i;
  1786 00001744 C8020000                 ENTER  2,0
  1787 00001748 B8[4F00]                 mov ax, InputBuf
  1788 0000174B A3[CE00]                 mov word [InputPtr], ax
  1789                                  
  1790                                  ;-4   *InputPtr=0;//if last line is empty
  1791                                  
  1792 0000174E 66B800000000             mov eax, 0
  1793 00001754 8B1E[CE00]               mov  bx, [InputPtr]
  1794 00001758 8807                     mov  [bx], al
  1795                                  
  1796                                  ;-5   do {
  1797                                  
  1798                                  @@getLine52:
  1799                                  
  1800                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1801                                  
  1802 0000175A 6A01                     push 1
  1803 0000175C FF36[9901]               push word [asm_fd]
  1804 00001760 8D06[A501]               lea  ax, [DOS_ByteRead]
  1805 00001764 50                       push ax
  1806 00001765 E82D1A                   call readRL
  1807 00001768 83C406                   add  sp, 6
  1808 0000176B A3[A301]                 mov word [DOS_NoBytes], ax
  1809                                  
  1810                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  1811                                  
  1812 0000176E A1[9F01]                 mov ax, [DOS_ERR]
  1813 00001771 08C0                     or  al, al
  1814 00001773 0F840900                 je @@getLine53
  1815 00001777 68[DC17]                 push getLine_0
  1816 0000177A E83E0B                   call errorexit
  1817 0000177D 83C402                   add  sp, 2
  1818                                  
  1819                                  ;-8     if (DOS_NoBytes == 0) return;
  1820                                  
  1821                                  @@getLine53:
  1822 00001780 A1[A301]                 mov ax, [DOS_NoBytes]
  1823 00001783 83F800                   cmp ax, 0
  1824 00001786 0F850300                 jne @@getLine54
  1825 0000178A E94D00                   jmp @@retn
  1826                                  
  1827                                  ;-9     *InputPtr = DOS_ByteRead;
  1828                                  
  1829                                  @@getLine54:
  1830 0000178D A0[A501]                 mov al, [DOS_ByteRead]
  1831 00001790 8B1E[CE00]               mov  bx, [InputPtr]
  1832 00001794 8807                     mov  [bx], al
  1833                                  
  1834                                  ;-10     InputPtr++;
  1835                                  
  1836 00001796 FF06[CE00]               inc  word [InputPtr]
  1837                                  
  1838                                  ;-11     i = InputPtr - &InputBuf;
  1839                                  
  1840 0000179A A1[CE00]                 mov ax, [InputPtr]
  1841 0000179D 2D[4F00]                 sub ax, InputBuf
  1842 000017A0 8946FE                   mov word [bp-2], ax
  1843                                  
  1844                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  1845                                  
  1846 000017A3 8B46FE                   mov ax, [bp-2]
  1847 000017A6 83F87F                   cmp ax, 127 ;unsigned : 0
  1848 000017A9 0F820900                 jb  @@getLine55
  1849 000017AD 68[EB17]                 push getLine_1
  1850 000017B0 E8080B                   call errorexit
  1851 000017B3 83C402                   add  sp, 2
  1852                                  
  1853                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  1854                                  
  1855                                  @@getLine55:
  1856 000017B6 A0[A501]                 mov al, byte [DOS_ByteRead]
  1857 000017B9 B400                     mov ah, 0
  1858 000017BB 50                       push ax
  1859 000017BC E84000                   call ifEOL
  1860 000017BF 83C402                   add  sp, 2
  1861 000017C2 3C00                     cmp al, 0
  1862 000017C4 0F850200                 jne @@getLine56
  1863 000017C8 EB90                     jmp @@getLine52
  1864                                  @@getLine56:
  1865                                  
  1866                                  ;-14   InputPtr--;
  1867                                  
  1868 000017CA FF0E[CE00]               dec  word [InputPtr]
  1869                                  
  1870                                  ;-15   *InputPtr=0;
  1871                                  
  1872 000017CE 66B800000000             mov eax, 0
  1873 000017D4 8B1E[CE00]               mov  bx, [InputPtr]
  1874 000017D8 8807                     mov  [bx], al
  1875                                  
  1876                                  ;-16 }
  1877                                  
  1878                                  
  1879                                  ;-17 int ifEOL(char c) {
  1880                                  
  1881 000017DA C9                      @@retn: LEAVE
  1882 000017DB C3                       ret
  1883                                  ; ENDP
  1884 000017DC 52656164696E672053-     getLine_0 db "Reading Source",0
  1885 000017E5 6F7572636500       
  1886 000017EB 696E707574206C696E-     getLine_1 db "input line too long",0
  1887 000017F4 6520746F6F206C6F6E-
  1888 000017FD 6700               
  1889                                  
  1890                                  ifEOL:  ; *** PROC ***
  1891                                  
  1892                                  ;-18   if (c == 10) return 1;
  1893                                  
  1894                                  ;Function : ifEOL, Number of local variables: 1
  1895                                  ;   # type sign width line used address name   list of local variables
  1896                                  ;  200 var sign byte    17 NULL bp+4    c;
  1897 000017FF C8000000                 ENTER  0,0
  1898 00001803 8A4604                   mov al, [bp+4]
  1899 00001806 3C0A                     cmp al, 10
  1900 00001808 0F850900                 jne @@ifEOL57
  1901 0000180C 66B801000000             mov eax, 1
  1902 00001812 E92F00                   jmp @@retn
  1903                                  
  1904                                  ;-19   if (c == 13) {
  1905                                  
  1906                                  @@ifEOL57:
  1907 00001815 8A4604                   mov al, [bp+4]
  1908 00001818 3C0D                     cmp al, 13
  1909 0000181A 0F851D00                 jne @@ifEOL58
  1910                                  
  1911                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  1912                                  
  1913 0000181E 6A01                     push 1
  1914 00001820 FF36[9901]               push word [asm_fd]
  1915 00001824 8D06[A501]               lea  ax, [DOS_ByteRead]
  1916 00001828 50                       push ax
  1917 00001829 E86919                   call readRL
  1918 0000182C 83C406                   add  sp, 6
  1919 0000182F A3[A301]                 mov word [DOS_NoBytes], ax
  1920                                  
  1921                                  ;-21     return 1;}
  1922                                  
  1923 00001832 66B801000000             mov eax, 1
  1924 00001838 E90900                   jmp @@retn
  1925                                  
  1926                                  ;-22   return 0;
  1927                                  
  1928                                  @@ifEOL58:
  1929 0000183B 66B800000000             mov eax, 0
  1930 00001841 E90000                   jmp @@retn
  1931                                  
  1932                                  ;-23 }
  1933                                  
  1934                                  
  1935                                  ;-24 int skipBlank() {
  1936                                  
  1937 00001844 C9                      @@retn: LEAVE
  1938 00001845 C3                       ret
  1939                                  ; ENDP
  1940                                  
  1941                                  skipBlank:  ; *** PROC ***
  1942                                  
  1943                                  ;-25   skipblank1:
  1944                                  
  1945                                  @@skipblank1:
  1946                                  
  1947                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  1948                                  
  1949 00001846 8B1E[CE00]               mov bx, [InputPtr]
  1950 0000184A 8A07                     mov al, [bx]
  1951 0000184C B400                     mov ah, 0
  1952 0000184E 83F820                   cmp ax, 32
  1953 00001851 0F850600                 jne @@skipBlank59
  1954 00001855 FF06[CE00]               inc  word [InputPtr]
  1955 00001859 EBEB                     jmp @@skipblank1
  1956                                  
  1957                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  1958                                  
  1959                                  @@skipBlank59:
  1960 0000185B 8B1E[CE00]               mov bx, [InputPtr]
  1961 0000185F 8A07                     mov al, [bx]
  1962 00001861 B400                     mov ah, 0
  1963 00001863 83F809                   cmp ax, 9
  1964 00001866 0F850600                 jne @@skipBlank60
  1965 0000186A FF06[CE00]               inc  word [InputPtr]
  1966 0000186E EBD6                     jmp @@skipblank1
  1967                                  
  1968                                  ;-28 }
  1969                                  
  1970                                  @@skipBlank60:
  1971                                  
  1972                                  ;-29 int letterE(char c) {
  1973                                  
  1974 00001870 C3                       ret
  1975                                  ; ENDP
  1976                                  
  1977                                  letterE:  ; *** PROC ***
  1978                                  
  1979                                  ;-30   if (c=='_') return 1;
  1980                                  
  1981                                  ;Function : letterE, Number of local variables: 1
  1982                                  ;   # type sign width line used address name   list of local variables
  1983                                  ;  200 var sign byte    29 NULL bp+4    c;
  1984 00001871 C8000000                 ENTER  0,0
  1985 00001875 8A4604                   mov al, [bp+4]
  1986 00001878 3C5F                     cmp al, 95
  1987 0000187A 0F850900                 jne @@letterE61
  1988 0000187E 66B801000000             mov eax, 1
  1989 00001884 E97E00                   jmp @@retn
  1990                                  
  1991                                  ;-31   if (c=='.') return 1;
  1992                                  
  1993                                  @@letterE61:
  1994 00001887 8A4604                   mov al, [bp+4]
  1995 0000188A 3C2E                     cmp al, 46
  1996 0000188C 0F850900                 jne @@letterE62
  1997 00001890 66B801000000             mov eax, 1
  1998 00001896 E96C00                   jmp @@retn
  1999                                  
  2000                                  ;-32   if (c=='?') return 1;
  2001                                  
  2002                                  @@letterE62:
  2003 00001899 8A4604                   mov al, [bp+4]
  2004 0000189C 3C3F                     cmp al, 63
  2005 0000189E 0F850900                 jne @@letterE63
  2006 000018A2 66B801000000             mov eax, 1
  2007 000018A8 E95A00                   jmp @@retn
  2008                                  
  2009                                  ;-33   if (c=='$') return 1;
  2010                                  
  2011                                  @@letterE63:
  2012 000018AB 8A4604                   mov al, [bp+4]
  2013 000018AE 3C24                     cmp al, 36
  2014 000018B0 0F850900                 jne @@letterE64
  2015 000018B4 66B801000000             mov eax, 1
  2016 000018BA E94800                   jmp @@retn
  2017                                  
  2018                                  ;-34   if (c> 'z') return 0;
  2019                                  
  2020                                  @@letterE64:
  2021 000018BD 8A4604                   mov al, [bp+4]
  2022 000018C0 3C7A                     cmp al, 122
  2023 000018C2 0F8E0900                 jle @@letterE65
  2024 000018C6 66B800000000             mov eax, 0
  2025 000018CC E93600                   jmp @@retn
  2026                                  
  2027                                  ;-35   if (c< '@') return 0; // at included
  2028                                  
  2029                                  @@letterE65:
  2030 000018CF 8A4604                   mov al, [bp+4]
  2031 000018D2 3C40                     cmp al, 64
  2032 000018D4 0F8D0900                 jge @@letterE66
  2033 000018D8 66B800000000             mov eax, 0
  2034 000018DE E92400                   jmp @@retn
  2035                                  
  2036                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  2037                                  
  2038                                  @@letterE66:
  2039 000018E1 8A4604                   mov al, [bp+4]
  2040 000018E4 3C5A                     cmp al, 90
  2041 000018E6 0F8E1200                 jle @@letterE67
  2042 000018EA 8A4604                   mov al, [bp+4]
  2043 000018ED 3C61                     cmp al, 97
  2044 000018EF 0F8D0900                 jge @@letterE68
  2045 000018F3 66B800000000             mov eax, 0
  2046 000018F9 E90900                   jmp @@retn
  2047                                  @@letterE68:
  2048                                  
  2049                                  ;-37   return 1;
  2050                                  
  2051                                  @@letterE67:
  2052 000018FC 66B801000000             mov eax, 1
  2053 00001902 E90000                   jmp @@retn
  2054                                  
  2055                                  ;-38 }
  2056                                  
  2057                                  
  2058                                  ;-39 int alnumE(char c) {
  2059                                  
  2060 00001905 C9                      @@retn: LEAVE
  2061 00001906 C3                       ret
  2062                                  ; ENDP
  2063                                  
  2064                                  alnumE:  ; *** PROC ***
  2065                                  
  2066                                  ;-40   if (digit(c)) return 1;
  2067                                  
  2068                                  ;Function : alnumE, Number of local variables: 1
  2069                                  ;   # type sign width line used address name   list of local variables
  2070                                  ;  200 var sign byte    39 NULL bp+4    c;
  2071 00001907 C8000000                 ENTER  0,0
  2072 0000190B 8A4604                   mov al, byte [bp+4]
  2073 0000190E B400                     mov ah, 0
  2074 00001910 50                       push ax
  2075 00001911 E8B317                   call digit
  2076 00001914 83C402                   add  sp, 2
  2077 00001917 08C0                     or  al, al
  2078 00001919 0F840900                 je @@alnumE69
  2079 0000191D 66B801000000             mov eax, 1
  2080 00001923 E92400                   jmp @@retn
  2081                                  
  2082                                  ;-41   if (letterE(c)) return 1;
  2083                                  
  2084                                  @@alnumE69:
  2085 00001926 8A4604                   mov al, byte [bp+4]
  2086 00001929 B400                     mov ah, 0
  2087 0000192B 50                       push ax
  2088 0000192C E842FF                   call letterE
  2089 0000192F 83C402                   add  sp, 2
  2090 00001932 08C0                     or  al, al
  2091 00001934 0F840900                 je @@alnumE70
  2092 00001938 66B801000000             mov eax, 1
  2093 0000193E E90900                   jmp @@retn
  2094                                  
  2095                                  ;-42   return 0;
  2096                                  
  2097                                  @@alnumE70:
  2098 00001941 66B800000000             mov eax, 0
  2099 00001947 E90000                   jmp @@retn
  2100                                  
  2101                                  ;-43 }
  2102                                  
  2103                                  
  2104                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  2105                                  
  2106 0000194A C9                      @@retn: LEAVE
  2107 0000194B C3                       ret
  2108                                  ; ENDP
  2109                                  
  2110                                  getDigit:  ; *** PROC ***
  2111                                  
  2112                                  ;-45   unsigned int CastInt;
  2113                                  
  2114                                  
  2115                                  ;-46   SymbolInt=0;
  2116                                  
  2117                                  ;Function : getDigit, Number of local variables: 2
  2118                                  ;   # type sign width line used address name   list of local variables
  2119                                  ;  200 var unsg byte    44 NULL bp+4    c
  2120                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  2121 0000194C C8020000                 ENTER  2,0
  2122 00001950 66B800000000             mov eax, 0
  2123 00001956 A3[4D00]                 mov word [SymbolInt], ax
  2124                                  
  2125                                  ;-47   do {
  2126                                  
  2127                                  @@getDigit71:
  2128                                  
  2129                                  ;-48     c-='0';
  2130                                  
  2131 00001959 806E0430                 sub  byte [bp+4], 48
  2132                                  
  2133                                  ;-49     SymbolInt=SymbolInt*10;
  2134                                  
  2135 0000195D A1[4D00]                 mov ax, [SymbolInt]
  2136 00001960 66BB0A000000             mov ebx, 10
  2137 00001966 66F7E3                   mul ebx
  2138 00001969 A3[4D00]                 mov word [SymbolInt], ax
  2139                                  
  2140                                  ;-50     ax=0; CastInt=c; //cast b2w
  2141                                  
  2142 0000196C B80000                   mov  ax, 0
  2143 0000196F 8A4604                   mov al, [bp+4]
  2144 00001972 8946FE                   mov word [bp-2], ax
  2145                                  
  2146                                  ;-51     SymbolInt=SymbolInt+CastInt;
  2147                                  
  2148 00001975 A1[4D00]                 mov ax, [SymbolInt]
  2149 00001978 0346FE                   add ax, [bp-2]
  2150 0000197B A3[4D00]                 mov word [SymbolInt], ax
  2151                                  
  2152                                  ;-52     InputPtr++;
  2153                                  
  2154 0000197E FF06[CE00]               inc  word [InputPtr]
  2155                                  
  2156                                  ;-53     c = *InputPtr;
  2157                                  
  2158 00001982 8B1E[CE00]               mov bx, [InputPtr]
  2159 00001986 8A07                     mov al, [bx]
  2160 00001988 B400                     mov ah, 0
  2161 0000198A 884604                   mov byte [bp+4], al
  2162                                  
  2163                                  ;-54   } while(digit(c));
  2164                                  
  2165 0000198D 8A4604                   mov al, byte [bp+4]
  2166 00001990 B400                     mov ah, 0
  2167 00001992 50                       push ax
  2168 00001993 E83117                   call digit
  2169 00001996 83C402                   add  sp, 2
  2170 00001999 08C0                     or  al, al
  2171 0000199B 0F840200                 je @@getDigit72
  2172 0000199F EBB8                     jmp @@getDigit71
  2173                                  @@getDigit72:
  2174                                  
  2175                                  ;-55 }
  2176                                  
  2177                                  
  2178                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  2179 000019A1 C9                       LEAVE
  2180 000019A2 C3                       ret
  2181                                  ; ENDP
  2182                                  
  2183                                  getName:  ; *** PROC ***
  2184                                  
  2185                                  ;-57   char *p; unsigned int i;
  2186                                  
  2187                                  
  2188                                  ;-58   p = &Symbol;
  2189                                  
  2190                                  ;Function : getName, Number of local variables: 3
  2191                                  ;   # type sign width line used address name   list of local variables
  2192                                  ;  200 var unsg byte    56 NULL bp+4    c
  2193                                  ;  201 ptr sign byte    57 NULL bp-2    p
  2194                                  ;  202 var unsg word    57 NULL bp-4    i;
  2195 000019A3 C8040000                 ENTER  4,0
  2196 000019A7 B8[0F00]                 mov ax, Symbol
  2197 000019AA 8946FE                   mov word [bp-2], ax
  2198                                  
  2199                                  ;-59   *p = c;
  2200                                  
  2201 000019AD 8A4604                   mov al, [bp+4]
  2202 000019B0 8B5EFE                   mov  bx, [bp-2]
  2203 000019B3 8807                     mov  [bx], al
  2204                                  
  2205                                  ;-60   p++;
  2206                                  
  2207 000019B5 FF46FE                   inc  word [bp-2]
  2208                                  
  2209                                  ;-61   while (alnumE(c)) {
  2210                                  
  2211                                  @@getName73:
  2212 000019B8 8A4604                   mov al, byte [bp+4]
  2213 000019BB B400                     mov ah, 0
  2214 000019BD 50                       push ax
  2215 000019BE E846FF                   call alnumE
  2216 000019C1 83C402                   add  sp, 2
  2217 000019C4 08C0                     or  al, al
  2218 000019C6 0F843800                 je @@getName74
  2219                                  
  2220                                  ;-62     InputPtr++;
  2221                                  
  2222 000019CA FF06[CE00]               inc  word [InputPtr]
  2223                                  
  2224                                  ;-63     c = *InputPtr;
  2225                                  
  2226 000019CE 8B1E[CE00]               mov bx, [InputPtr]
  2227 000019D2 8A07                     mov al, [bx]
  2228 000019D4 B400                     mov ah, 0
  2229 000019D6 884604                   mov byte [bp+4], al
  2230                                  
  2231                                  ;-64     *p = c;
  2232                                  
  2233 000019D9 8A4604                   mov al, [bp+4]
  2234 000019DC 8B5EFE                   mov  bx, [bp-2]
  2235 000019DF 8807                     mov  [bx], al
  2236                                  
  2237                                  ;-65     p++;
  2238                                  
  2239 000019E1 FF46FE                   inc  word [bp-2]
  2240                                  
  2241                                  ;-66     i = p - &Symbol;
  2242                                  
  2243 000019E4 8B46FE                   mov ax, [bp-2]
  2244 000019E7 2D[0F00]                 sub ax, Symbol
  2245 000019EA 8946FC                   mov word [bp-4], ax
  2246                                  
  2247                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  2248                                  
  2249 000019ED 8B46FC                   mov ax, [bp-4]
  2250 000019F0 83F81F                   cmp ax, 31 ;unsigned : 0
  2251 000019F3 0F820900                 jb  @@getName75
  2252 000019F7 68[4B1A]                 push getName_0
  2253 000019FA E8BE08                   call errorexit
  2254 000019FD 83C402                   add  sp, 2
  2255                                  
  2256                                  ;-68   }
  2257                                  
  2258                                  @@getName75:
  2259                                  
  2260                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  2261                                  
  2262 00001A00 EBB6                     jmp @@getName73
  2263                                  @@getName74:
  2264 00001A02 8A4604                   mov al, [bp+4]
  2265 00001A05 3C3A                     cmp al, 58
  2266 00001A07 0F850C00                 jne @@getName76
  2267 00001A0B 66B801000000             mov eax, 1
  2268 00001A11 A2[AA01]                 mov byte [isLabel], al
  2269 00001A14 E90900                   jmp @@getName77
  2270                                  @@getName76:
  2271 00001A17 66B800000000             mov eax, 0
  2272 00001A1D A2[AA01]                 mov byte [isLabel], al
  2273                                  
  2274                                  ;-70   p--;
  2275                                  
  2276                                  @@getName77:
  2277 00001A20 FF4EFE                   dec  word [bp-2]
  2278                                  
  2279                                  ;-71   *p = 0;
  2280                                  
  2281 00001A23 66B800000000             mov eax, 0
  2282 00001A29 8B5EFE                   mov  bx, [bp-2]
  2283 00001A2C 8807                     mov  [bx], al
  2284                                  
  2285                                  ;-72   strcpy(SymbolUpper, Symbol);
  2286                                  
  2287 00001A2E 8D06[0F00]               lea  ax, [Symbol]
  2288 00001A32 50                       push ax
  2289 00001A33 8D06[2E00]               lea  ax, [SymbolUpper]
  2290 00001A37 50                       push ax
  2291 00001A38 E85316                   call strcpy
  2292 00001A3B 83C404                   add  sp, 4
  2293                                  
  2294                                  ;-73   toupper(SymbolUpper);
  2295                                  
  2296 00001A3E 8D06[2E00]               lea  ax, [SymbolUpper]
  2297 00001A42 50                       push ax
  2298 00001A43 E8DA15                   call toupper
  2299 00001A46 83C402                   add  sp, 2
  2300                                  
  2301                                  ;-74 }
  2302                                  
  2303                                  
  2304                                  ;-75 int testReg() {
  2305 00001A49 C9                       LEAVE
  2306 00001A4A C3                       ret
  2307                                  ; ENDP
  2308 00001A4B 73796D626F6C20746F-     getName_0 db "symbol too long",0
  2309 00001A54 6F206C6F6E6700     
  2310                                  
  2311                                  testReg:  ; *** PROC ***
  2312                                  
  2313                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:RegType: 0=no reg,BYTE,WORD,SEGREG,DWORD
  2314                                  
  2315                                  
  2316                                  ;-77   RegType=0;
  2317                                  
  2318 00001A5B 66B800000000             mov eax, 0
  2319 00001A61 A2[B401]                 mov byte [RegType], al
  2320                                  
  2321                                  ;-78   if (strlen(Symbol) < 2) return 0;
  2322                                  
  2323 00001A64 8D06[0F00]               lea  ax, [Symbol]
  2324 00001A68 50                       push ax
  2325 00001A69 E8F715                   call strlen
  2326 00001A6C 83C402                   add  sp, 2
  2327 00001A6F 3C02                     cmp al, 2
  2328 00001A71 0F8D0900                 jge @@testReg78
  2329 00001A75 66B800000000             mov eax, 0
  2330 00001A7B E9B603                   jmp @@retn
  2331                                  
  2332                                  ;-79   if (strlen(Symbol) > 3) return 0;
  2333                                  
  2334                                  @@testReg78:
  2335 00001A7E 8D06[0F00]               lea  ax, [Symbol]
  2336 00001A82 50                       push ax
  2337 00001A83 E8DD15                   call strlen
  2338 00001A86 83C402                   add  sp, 2
  2339 00001A89 3C03                     cmp al, 3
  2340 00001A8B 0F8E0900                 jle @@testReg79
  2341 00001A8F 66B800000000             mov eax, 0
  2342 00001A95 E99C03                   jmp @@retn
  2343                                  
  2344                                  ;-80   RegType=BYTE;
  2345                                  
  2346                                  @@testReg79:
  2347 00001A98 66B801000000             mov eax, 1
  2348 00001A9E A2[B401]                 mov byte [RegType], al
  2349                                  
  2350                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  2351                                  
  2352 00001AA1 68[351E]                 push testReg_0
  2353 00001AA4 8D06[2E00]               lea  ax, [SymbolUpper]
  2354 00001AA8 50                       push ax
  2355 00001AA9 E84E16                   call eqstr
  2356 00001AAC 83C404                   add  sp, 4
  2357 00001AAF 08C0                     or  al, al
  2358 00001AB1 0F840900                 je @@testReg80
  2359 00001AB5 66B800000000             mov eax, 0
  2360 00001ABB E97603                   jmp @@retn
  2361                                  
  2362                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  2363                                  
  2364                                  @@testReg80:
  2365 00001ABE 68[381E]                 push testReg_1
  2366 00001AC1 8D06[2E00]               lea  ax, [SymbolUpper]
  2367 00001AC5 50                       push ax
  2368 00001AC6 E83116                   call eqstr
  2369 00001AC9 83C404                   add  sp, 4
  2370 00001ACC 08C0                     or  al, al
  2371 00001ACE 0F840900                 je @@testReg81
  2372 00001AD2 66B801000000             mov eax, 1
  2373 00001AD8 E95903                   jmp @@retn
  2374                                  
  2375                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  2376                                  
  2377                                  @@testReg81:
  2378 00001ADB 68[3B1E]                 push testReg_2
  2379 00001ADE 8D06[2E00]               lea  ax, [SymbolUpper]
  2380 00001AE2 50                       push ax
  2381 00001AE3 E81416                   call eqstr
  2382 00001AE6 83C404                   add  sp, 4
  2383 00001AE9 08C0                     or  al, al
  2384 00001AEB 0F840900                 je @@testReg82
  2385 00001AEF 66B802000000             mov eax, 2
  2386 00001AF5 E93C03                   jmp @@retn
  2387                                  
  2388                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  2389                                  
  2390                                  @@testReg82:
  2391 00001AF8 68[3E1E]                 push testReg_3
  2392 00001AFB 8D06[2E00]               lea  ax, [SymbolUpper]
  2393 00001AFF 50                       push ax
  2394 00001B00 E8F715                   call eqstr
  2395 00001B03 83C404                   add  sp, 4
  2396 00001B06 08C0                     or  al, al
  2397 00001B08 0F840900                 je @@testReg83
  2398 00001B0C 66B803000000             mov eax, 3
  2399 00001B12 E91F03                   jmp @@retn
  2400                                  
  2401                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  2402                                  
  2403                                  @@testReg83:
  2404 00001B15 68[411E]                 push testReg_4
  2405 00001B18 8D06[2E00]               lea  ax, [SymbolUpper]
  2406 00001B1C 50                       push ax
  2407 00001B1D E8DA15                   call eqstr
  2408 00001B20 83C404                   add  sp, 4
  2409 00001B23 08C0                     or  al, al
  2410 00001B25 0F840900                 je @@testReg84
  2411 00001B29 66B804000000             mov eax, 4
  2412 00001B2F E90203                   jmp @@retn
  2413                                  
  2414                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  2415                                  
  2416                                  @@testReg84:
  2417 00001B32 68[441E]                 push testReg_5
  2418 00001B35 8D06[2E00]               lea  ax, [SymbolUpper]
  2419 00001B39 50                       push ax
  2420 00001B3A E8BD15                   call eqstr
  2421 00001B3D 83C404                   add  sp, 4
  2422 00001B40 08C0                     or  al, al
  2423 00001B42 0F840900                 je @@testReg85
  2424 00001B46 66B805000000             mov eax, 5
  2425 00001B4C E9E502                   jmp @@retn
  2426                                  
  2427                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  2428                                  
  2429                                  @@testReg85:
  2430 00001B4F 68[471E]                 push testReg_6
  2431 00001B52 8D06[2E00]               lea  ax, [SymbolUpper]
  2432 00001B56 50                       push ax
  2433 00001B57 E8A015                   call eqstr
  2434 00001B5A 83C404                   add  sp, 4
  2435 00001B5D 08C0                     or  al, al
  2436 00001B5F 0F840900                 je @@testReg86
  2437 00001B63 66B806000000             mov eax, 6
  2438 00001B69 E9C802                   jmp @@retn
  2439                                  
  2440                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  2441                                  
  2442                                  @@testReg86:
  2443 00001B6C 68[4A1E]                 push testReg_7
  2444 00001B6F 8D06[2E00]               lea  ax, [SymbolUpper]
  2445 00001B73 50                       push ax
  2446 00001B74 E88315                   call eqstr
  2447 00001B77 83C404                   add  sp, 4
  2448 00001B7A 08C0                     or  al, al
  2449 00001B7C 0F840900                 je @@testReg87
  2450 00001B80 66B807000000             mov eax, 7
  2451 00001B86 E9AB02                   jmp @@retn
  2452                                  
  2453                                  ;-89   RegType=WORD;
  2454                                  
  2455                                  @@testReg87:
  2456 00001B89 66B802000000             mov eax, 2
  2457 00001B8F A2[B401]                 mov byte [RegType], al
  2458                                  
  2459                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  2460                                  
  2461 00001B92 68[4D1E]                 push testReg_8
  2462 00001B95 8D06[2E00]               lea  ax, [SymbolUpper]
  2463 00001B99 50                       push ax
  2464 00001B9A E85D15                   call eqstr
  2465 00001B9D 83C404                   add  sp, 4
  2466 00001BA0 08C0                     or  al, al
  2467 00001BA2 0F840900                 je @@testReg88
  2468 00001BA6 66B800000000             mov eax, 0
  2469 00001BAC E98502                   jmp @@retn
  2470                                  
  2471                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  2472                                  
  2473                                  @@testReg88:
  2474 00001BAF 68[501E]                 push testReg_9
  2475 00001BB2 8D06[2E00]               lea  ax, [SymbolUpper]
  2476 00001BB6 50                       push ax
  2477 00001BB7 E84015                   call eqstr
  2478 00001BBA 83C404                   add  sp, 4
  2479 00001BBD 08C0                     or  al, al
  2480 00001BBF 0F840900                 je @@testReg89
  2481 00001BC3 66B801000000             mov eax, 1
  2482 00001BC9 E96802                   jmp @@retn
  2483                                  
  2484                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  2485                                  
  2486                                  @@testReg89:
  2487 00001BCC 68[531E]                 push testReg_10
  2488 00001BCF 8D06[2E00]               lea  ax, [SymbolUpper]
  2489 00001BD3 50                       push ax
  2490 00001BD4 E82315                   call eqstr
  2491 00001BD7 83C404                   add  sp, 4
  2492 00001BDA 08C0                     or  al, al
  2493 00001BDC 0F840900                 je @@testReg90
  2494 00001BE0 66B802000000             mov eax, 2
  2495 00001BE6 E94B02                   jmp @@retn
  2496                                  
  2497                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  2498                                  
  2499                                  @@testReg90:
  2500 00001BE9 68[561E]                 push testReg_11
  2501 00001BEC 8D06[2E00]               lea  ax, [SymbolUpper]
  2502 00001BF0 50                       push ax
  2503 00001BF1 E80615                   call eqstr
  2504 00001BF4 83C404                   add  sp, 4
  2505 00001BF7 08C0                     or  al, al
  2506 00001BF9 0F840900                 je @@testReg91
  2507 00001BFD 66B803000000             mov eax, 3
  2508 00001C03 E92E02                   jmp @@retn
  2509                                  
  2510                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  2511                                  
  2512                                  @@testReg91:
  2513 00001C06 68[591E]                 push testReg_12
  2514 00001C09 8D06[2E00]               lea  ax, [SymbolUpper]
  2515 00001C0D 50                       push ax
  2516 00001C0E E8E914                   call eqstr
  2517 00001C11 83C404                   add  sp, 4
  2518 00001C14 08C0                     or  al, al
  2519 00001C16 0F840900                 je @@testReg92
  2520 00001C1A 66B804000000             mov eax, 4
  2521 00001C20 E91102                   jmp @@retn
  2522                                  
  2523                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  2524                                  
  2525                                  @@testReg92:
  2526 00001C23 68[5C1E]                 push testReg_13
  2527 00001C26 8D06[2E00]               lea  ax, [SymbolUpper]
  2528 00001C2A 50                       push ax
  2529 00001C2B E8CC14                   call eqstr
  2530 00001C2E 83C404                   add  sp, 4
  2531 00001C31 08C0                     or  al, al
  2532 00001C33 0F840900                 je @@testReg93
  2533 00001C37 66B805000000             mov eax, 5
  2534 00001C3D E9F401                   jmp @@retn
  2535                                  
  2536                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  2537                                  
  2538                                  @@testReg93:
  2539 00001C40 68[5F1E]                 push testReg_14
  2540 00001C43 8D06[2E00]               lea  ax, [SymbolUpper]
  2541 00001C47 50                       push ax
  2542 00001C48 E8AF14                   call eqstr
  2543 00001C4B 83C404                   add  sp, 4
  2544 00001C4E 08C0                     or  al, al
  2545 00001C50 0F840900                 je @@testReg94
  2546 00001C54 66B806000000             mov eax, 6
  2547 00001C5A E9D701                   jmp @@retn
  2548                                  
  2549                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  2550                                  
  2551                                  @@testReg94:
  2552 00001C5D 68[621E]                 push testReg_15
  2553 00001C60 8D06[2E00]               lea  ax, [SymbolUpper]
  2554 00001C64 50                       push ax
  2555 00001C65 E89214                   call eqstr
  2556 00001C68 83C404                   add  sp, 4
  2557 00001C6B 08C0                     or  al, al
  2558 00001C6D 0F840900                 je @@testReg95
  2559 00001C71 66B807000000             mov eax, 7
  2560 00001C77 E9BA01                   jmp @@retn
  2561                                  
  2562                                  ;-98   RegType=SEGREG;
  2563                                  
  2564                                  @@testReg95:
  2565 00001C7A 66B804000000             mov eax, 4
  2566 00001C80 A2[B401]                 mov byte [RegType], al
  2567                                  
  2568                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  2569                                  
  2570 00001C83 68[651E]                 push testReg_16
  2571 00001C86 8D06[2E00]               lea  ax, [SymbolUpper]
  2572 00001C8A 50                       push ax
  2573 00001C8B E86C14                   call eqstr
  2574 00001C8E 83C404                   add  sp, 4
  2575 00001C91 08C0                     or  al, al
  2576 00001C93 0F840900                 je @@testReg96
  2577 00001C97 66B800000000             mov eax, 0
  2578 00001C9D E99401                   jmp @@retn
  2579                                  
  2580                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  2581                                  
  2582                                  @@testReg96:
  2583 00001CA0 68[681E]                 push testReg_17
  2584 00001CA3 8D06[2E00]               lea  ax, [SymbolUpper]
  2585 00001CA7 50                       push ax
  2586 00001CA8 E84F14                   call eqstr
  2587 00001CAB 83C404                   add  sp, 4
  2588 00001CAE 08C0                     or  al, al
  2589 00001CB0 0F840900                 je @@testReg97
  2590 00001CB4 66B801000000             mov eax, 1
  2591 00001CBA E97701                   jmp @@retn
  2592                                  
  2593                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  2594                                  
  2595                                  @@testReg97:
  2596 00001CBD 68[6B1E]                 push testReg_18
  2597 00001CC0 8D06[2E00]               lea  ax, [SymbolUpper]
  2598 00001CC4 50                       push ax
  2599 00001CC5 E83214                   call eqstr
  2600 00001CC8 83C404                   add  sp, 4
  2601 00001CCB 08C0                     or  al, al
  2602 00001CCD 0F840900                 je @@testReg98
  2603 00001CD1 66B802000000             mov eax, 2
  2604 00001CD7 E95A01                   jmp @@retn
  2605                                  
  2606                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  2607                                  
  2608                                  @@testReg98:
  2609 00001CDA 68[6E1E]                 push testReg_19
  2610 00001CDD 8D06[2E00]               lea  ax, [SymbolUpper]
  2611 00001CE1 50                       push ax
  2612 00001CE2 E81514                   call eqstr
  2613 00001CE5 83C404                   add  sp, 4
  2614 00001CE8 08C0                     or  al, al
  2615 00001CEA 0F840900                 je @@testReg99
  2616 00001CEE 66B803000000             mov eax, 3
  2617 00001CF4 E93D01                   jmp @@retn
  2618                                  
  2619                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  2620                                  
  2621                                  @@testReg99:
  2622 00001CF7 68[711E]                 push testReg_20
  2623 00001CFA 8D06[2E00]               lea  ax, [SymbolUpper]
  2624 00001CFE 50                       push ax
  2625 00001CFF E8F813                   call eqstr
  2626 00001D02 83C404                   add  sp, 4
  2627 00001D05 08C0                     or  al, al
  2628 00001D07 0F840900                 je @@testReg100
  2629 00001D0B 66B804000000             mov eax, 4
  2630 00001D11 E92001                   jmp @@retn
  2631                                  
  2632                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  2633                                  
  2634                                  @@testReg100:
  2635 00001D14 68[741E]                 push testReg_21
  2636 00001D17 8D06[2E00]               lea  ax, [SymbolUpper]
  2637 00001D1B 50                       push ax
  2638 00001D1C E8DB13                   call eqstr
  2639 00001D1F 83C404                   add  sp, 4
  2640 00001D22 08C0                     or  al, al
  2641 00001D24 0F840900                 je @@testReg101
  2642 00001D28 66B805000000             mov eax, 5
  2643 00001D2E E90301                   jmp @@retn
  2644                                  
  2645                                  ;-105   RegType=DWORD;
  2646                                  
  2647                                  @@testReg101:
  2648 00001D31 66B803000000             mov eax, 3
  2649 00001D37 A2[B401]                 mov byte [RegType], al
  2650                                  
  2651                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  2652                                  
  2653 00001D3A 68[771E]                 push testReg_22
  2654 00001D3D 8D06[2E00]               lea  ax, [SymbolUpper]
  2655 00001D41 50                       push ax
  2656 00001D42 E8B513                   call eqstr
  2657 00001D45 83C404                   add  sp, 4
  2658 00001D48 08C0                     or  al, al
  2659 00001D4A 0F840900                 je @@testReg102
  2660 00001D4E 66B800000000             mov eax, 0
  2661 00001D54 E9DD00                   jmp @@retn
  2662                                  
  2663                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  2664                                  
  2665                                  @@testReg102:
  2666 00001D57 68[7B1E]                 push testReg_23
  2667 00001D5A 8D06[2E00]               lea  ax, [SymbolUpper]
  2668 00001D5E 50                       push ax
  2669 00001D5F E89813                   call eqstr
  2670 00001D62 83C404                   add  sp, 4
  2671 00001D65 08C0                     or  al, al
  2672 00001D67 0F840900                 je @@testReg103
  2673 00001D6B 66B801000000             mov eax, 1
  2674 00001D71 E9C000                   jmp @@retn
  2675                                  
  2676                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  2677                                  
  2678                                  @@testReg103:
  2679 00001D74 68[7F1E]                 push testReg_24
  2680 00001D77 8D06[2E00]               lea  ax, [SymbolUpper]
  2681 00001D7B 50                       push ax
  2682 00001D7C E87B13                   call eqstr
  2683 00001D7F 83C404                   add  sp, 4
  2684 00001D82 08C0                     or  al, al
  2685 00001D84 0F840900                 je @@testReg104
  2686 00001D88 66B802000000             mov eax, 2
  2687 00001D8E E9A300                   jmp @@retn
  2688                                  
  2689                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  2690                                  
  2691                                  @@testReg104:
  2692 00001D91 68[831E]                 push testReg_25
  2693 00001D94 8D06[2E00]               lea  ax, [SymbolUpper]
  2694 00001D98 50                       push ax
  2695 00001D99 E85E13                   call eqstr
  2696 00001D9C 83C404                   add  sp, 4
  2697 00001D9F 08C0                     or  al, al
  2698 00001DA1 0F840900                 je @@testReg105
  2699 00001DA5 66B803000000             mov eax, 3
  2700 00001DAB E98600                   jmp @@retn
  2701                                  
  2702                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  2703                                  
  2704                                  @@testReg105:
  2705 00001DAE 68[871E]                 push testReg_26
  2706 00001DB1 8D06[2E00]               lea  ax, [SymbolUpper]
  2707 00001DB5 50                       push ax
  2708 00001DB6 E84113                   call eqstr
  2709 00001DB9 83C404                   add  sp, 4
  2710 00001DBC 08C0                     or  al, al
  2711 00001DBE 0F840900                 je @@testReg106
  2712 00001DC2 66B804000000             mov eax, 4
  2713 00001DC8 E96900                   jmp @@retn
  2714                                  
  2715                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  2716                                  
  2717                                  @@testReg106:
  2718 00001DCB 68[8B1E]                 push testReg_27
  2719 00001DCE 8D06[2E00]               lea  ax, [SymbolUpper]
  2720 00001DD2 50                       push ax
  2721 00001DD3 E82413                   call eqstr
  2722 00001DD6 83C404                   add  sp, 4
  2723 00001DD9 08C0                     or  al, al
  2724 00001DDB 0F840900                 je @@testReg107
  2725 00001DDF 66B805000000             mov eax, 5
  2726 00001DE5 E94C00                   jmp @@retn
  2727                                  
  2728                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  2729                                  
  2730                                  @@testReg107:
  2731 00001DE8 68[8F1E]                 push testReg_28
  2732 00001DEB 8D06[2E00]               lea  ax, [SymbolUpper]
  2733 00001DEF 50                       push ax
  2734 00001DF0 E80713                   call eqstr
  2735 00001DF3 83C404                   add  sp, 4
  2736 00001DF6 08C0                     or  al, al
  2737 00001DF8 0F840900                 je @@testReg108
  2738 00001DFC 66B806000000             mov eax, 6
  2739 00001E02 E92F00                   jmp @@retn
  2740                                  
  2741                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  2742                                  
  2743                                  @@testReg108:
  2744 00001E05 68[931E]                 push testReg_29
  2745 00001E08 8D06[2E00]               lea  ax, [SymbolUpper]
  2746 00001E0C 50                       push ax
  2747 00001E0D E8EA12                   call eqstr
  2748 00001E10 83C404                   add  sp, 4
  2749 00001E13 08C0                     or  al, al
  2750 00001E15 0F840900                 je @@testReg109
  2751 00001E19 66B807000000             mov eax, 7
  2752 00001E1F E91200                   jmp @@retn
  2753                                  
  2754                                  ;-114   RegType=0; return 0;
  2755                                  
  2756                                  @@testReg109:
  2757 00001E22 66B800000000             mov eax, 0
  2758 00001E28 A2[B401]                 mov byte [RegType], al
  2759 00001E2B 66B800000000             mov eax, 0
  2760 00001E31 E90000                   jmp @@retn
  2761                                  
  2762                                  ;-115 }
  2763                                  
  2764                                  @@retn:
  2765 00001E34 C3                       ret
  2766                                  ; ENDP
  2767 00001E35 414C00                  testReg_0 db "AL",0
  2768 00001E38 434C00                  testReg_1 db "CL",0
  2769 00001E3B 444C00                  testReg_2 db "DL",0
  2770 00001E3E 424C00                  testReg_3 db "BL",0
  2771 00001E41 414800                  testReg_4 db "AH",0
  2772 00001E44 434800                  testReg_5 db "CH",0
  2773 00001E47 444800                  testReg_6 db "DH",0
  2774 00001E4A 424800                  testReg_7 db "BH",0
  2775 00001E4D 415800                  testReg_8 db "AX",0
  2776 00001E50 435800                  testReg_9 db "CX",0
  2777 00001E53 445800                  testReg_10 db "DX",0
  2778 00001E56 425800                  testReg_11 db "BX",0
  2779 00001E59 535000                  testReg_12 db "SP",0
  2780 00001E5C 425000                  testReg_13 db "BP",0
  2781 00001E5F 534900                  testReg_14 db "SI",0
  2782 00001E62 444900                  testReg_15 db "DI",0
  2783 00001E65 455300                  testReg_16 db "ES",0
  2784 00001E68 435300                  testReg_17 db "CS",0
  2785 00001E6B 535300                  testReg_18 db "SS",0
  2786 00001E6E 445300                  testReg_19 db "DS",0
  2787 00001E71 465300                  testReg_20 db "FS",0
  2788 00001E74 475300                  testReg_21 db "GS",0
  2789 00001E77 45415800                testReg_22 db "EAX",0
  2790 00001E7B 45435800                testReg_23 db "ECX",0
  2791 00001E7F 45445800                testReg_24 db "EDX",0
  2792 00001E83 45425800                testReg_25 db "EBX",0
  2793 00001E87 45535000                testReg_26 db "ESP",0
  2794 00001E8B 45425000                testReg_27 db "EBP",0
  2795 00001E8F 45534900                testReg_28 db "ESI",0
  2796 00001E93 45444900                testReg_29 db "EDI",0
  2797                                  ;Back to main program: AS.C
  2798                                  
  2799                                  ;-7 #include "OUTPUT.C"
  2800                                  
  2801                                  ;Use include file: OUTPUT.C
  2802                                  
  2803                                  ;-1 int printLine() { int i; char c;
  2804                                  
  2805                                  
  2806                                  printLine:  ; *** PROC ***
  2807                                  
  2808                                  ;-2   prs("\n"); printhex16(PCStart);
  2809                                  
  2810                                  ;Function : printLine, Number of local variables: 2
  2811                                  ;   # type sign width line used address name   list of local variables
  2812                                  ;  200 var sign word     1 NULL bp-2    i
  2813                                  ;  201 var sign byte     1 NULL bp-4    c;
  2814 00001E97 C8040000                 ENTER  4,0
  2815 00001E9B 68[2C1F]                 push printLine_0
  2816 00001E9E E80401                   call prs
  2817 00001EA1 83C402                   add  sp, 2
  2818 00001EA4 FF36[A801]               push word [PCStart]
  2819 00001EA8 E8EB01                   call printhex16
  2820 00001EAB 83C402                   add  sp, 2
  2821                                  
  2822                                  ;-3   if (OpPrintIndex == 0) prs("                ");
  2823                                  
  2824 00001EAE A1[C401]                 mov ax, [OpPrintIndex]
  2825 00001EB1 83F800                   cmp ax, 0
  2826 00001EB4 0F850C00                 jne @@printLine110
  2827 00001EB8 68[2F1F]                 push printLine_1
  2828 00001EBB E8E700                   call prs
  2829 00001EBE 83C402                   add  sp, 2
  2830                                  
  2831                                  ;-4   else {
  2832                                  
  2833 00001EC1 E95B00                   jmp @@printLine111
  2834                                  @@printLine110:
  2835                                  
  2836                                  ;-5     prc(PrintR);
  2837                                  
  2838 00001EC4 A0[C801]                 mov al, byte [PrintR]
  2839 00001EC7 B400                     mov ah, 0
  2840 00001EC9 50                       push ax
  2841 00001ECA E87700                   call prc
  2842 00001ECD 83C402                   add  sp, 2
  2843                                  
  2844                                  ;-6     i=0;
  2845                                  
  2846 00001ED0 66B800000000             mov eax, 0
  2847 00001ED6 8946FE                   mov word [bp-2], ax
  2848                                  
  2849                                  ;-7     do {
  2850                                  
  2851                                  @@printLine112:
  2852                                  
  2853                                  ;-8       c=OpPos[i];
  2854                                  
  2855 00001ED9 8B5EFE                   mov bx, [bp-2]
  2856 00001EDC 8A87[BF01]               mov al, [OpPos + bx]
  2857 00001EE0 8846FC                   mov byte [bp-4], al
  2858                                  
  2859                                  ;-9       printhex8a(c); prc(' ');
  2860                                  
  2861 00001EE3 8A46FC                   mov al, byte [bp-4]
  2862 00001EE6 B400                     mov ah, 0
  2863 00001EE8 50                       push ax
  2864 00001EE9 E85C01                   call printhex8a
  2865 00001EEC 83C402                   add  sp, 2
  2866 00001EEF 6A20                     push 32
  2867 00001EF1 E85000                   call prc
  2868 00001EF4 83C402                   add  sp, 2
  2869                                  
  2870                                  ;-10       i++;
  2871                                  
  2872 00001EF7 FF46FE                   inc  word [bp-2]
  2873                                  
  2874                                  ;-11     } while(i < OpPrintIndex);
  2875                                  
  2876 00001EFA 8B46FE                   mov ax, [bp-2]
  2877 00001EFD 3B06[C401]               cmp ax, [OpPrintIndex]
  2878 00001F01 0F8D0200                 jge @@printLine113
  2879 00001F05 EBD2                     jmp @@printLine112
  2880                                  @@printLine113:
  2881                                  
  2882                                  ;-12     do {// fill rest with blank
  2883                                  
  2884                                  @@printLine114:
  2885                                  
  2886                                  ;-13       prs("   ");
  2887                                  
  2888 00001F07 68[401F]                 push printLine_2
  2889 00001F0A E89800                   call prs
  2890 00001F0D 83C402                   add  sp, 2
  2891                                  
  2892                                  ;-14       i++;
  2893                                  
  2894 00001F10 FF46FE                   inc  word [bp-2]
  2895                                  
  2896                                  ;-15     } while(i < OPMAXLEN);
  2897                                  
  2898 00001F13 8B46FE                   mov ax, [bp-2]
  2899 00001F16 83F805                   cmp ax, 5
  2900 00001F19 0F8D0200                 jge @@printLine115
  2901 00001F1D EBE8                     jmp @@printLine114
  2902                                  @@printLine115:
  2903                                  
  2904                                  ;-16   }
  2905                                  
  2906                                  
  2907                                  ;-17   prscomment(InputBuf);
  2908                                  
  2909                                  @@printLine111:
  2910 00001F1F 8D06[4F00]               lea  ax, [InputBuf]
  2911 00001F23 50                       push ax
  2912 00001F24 E85000                   call prscomment
  2913 00001F27 83C402                   add  sp, 2
  2914                                  
  2915                                  ;-18 }
  2916                                  
  2917                                  
  2918                                  ;-19 int prc(unsigned char c) { if (LIST) { if (_ c==10) {ax=13; writetty(); }
  2919 00001F2A C9                       LEAVE
  2920 00001F2B C3                       ret
  2921                                  ; ENDP
  2922 00001F2C 5C6E00                  printLine_0 db "\n",0
  2923 00001F2F 202020202020202020-     printLine_1 db "                ",0
  2924 00001F38 2020202020202000   
  2925 00001F40 20202000                printLine_2 db "   ",0
  2926                                  
  2927                                  prc:  ; *** PROC ***
  2928                                  ;Function : prc, Number of local variables: 1
  2929                                  ;   # type sign width line used address name   list of local variables
  2930                                  ;  200 var unsg byte    19 NULL bp+4    c;
  2931 00001F44 C8000000                 ENTER  0,0
  2932 00001F48 A0[0E00]                 mov al, [LIST]
  2933 00001F4B 08C0                     or  al, al
  2934 00001F4D 0F841400                 je @@prc116
  2935 00001F51 807E040A                cmp byte [bp+4], 10
  2936 00001F55 0F850600                 jne @@prc117
  2937 00001F59 B80D00                   mov  ax, 13
  2938 00001F5C E88B10                   call writetty
  2939                                  
  2940                                  ;-20      al=c; writetty(); }
  2941                                  
  2942                                  @@prc117:
  2943 00001F5F 8A4604                   mov  al, [bp+4]
  2944 00001F62 E88510                   call writetty
  2945                                  
  2946                                  ;-21    fputcR(c,lst_fd); }
  2947                                  
  2948                                  @@prc116:
  2949 00001F65 FF36[9B01]               push word [lst_fd]
  2950 00001F69 8A4604                   mov al, byte [bp+4]
  2951 00001F6C B400                     mov ah, 0
  2952 00001F6E 50                       push ax
  2953 00001F6F E83812                   call fputcR
  2954 00001F72 83C404                   add  sp, 4
  2955                                  
  2956                                  ;-22 
  2957                                  
  2958                                  
  2959                                  ;-23 int prscomment(unsigned char *s) {unsigned char c;
  2960 00001F75 C9                       LEAVE
  2961 00001F76 C3                       ret
  2962                                  ; ENDP
  2963                                  
  2964                                  prscomment:  ; *** PROC ***
  2965                                  
  2966                                  ;-24   while(*s){c=*s;prc(c);s++;}
  2967                                  
  2968                                  ;Function : prscomment, Number of local variables: 2
  2969                                  ;   # type sign width line used address name   list of local variables
  2970                                  ;  200 ptr unsg byte    23 NULL bp+4    s
  2971                                  ;  201 var unsg byte    23 NULL bp-2    c;
  2972 00001F77 C8020000                 ENTER  2,0
  2973                                  @@prscomment118:
  2974 00001F7B 8B5E04                   mov bx, [bp+4]
  2975 00001F7E 8A07                     mov al, [bx]
  2976 00001F80 B400                     mov ah, 0
  2977 00001F82 08C0                     or  al, al
  2978 00001F84 0F841B00                 je @@prscomment119
  2979 00001F88 8B5E04                   mov bx, [bp+4]
  2980 00001F8B 8A07                     mov al, [bx]
  2981 00001F8D B400                     mov ah, 0
  2982 00001F8F 8846FE                   mov byte [bp-2], al
  2983 00001F92 8A46FE                   mov al, byte [bp-2]
  2984 00001F95 B400                     mov ah, 0
  2985 00001F97 50                       push ax
  2986 00001F98 E8A9FF                   call prc
  2987 00001F9B 83C402                   add  sp, 2
  2988 00001F9E FF4604                   inc  word [bp+4]
  2989                                  
  2990                                  ;-25 }
  2991                                  
  2992 00001FA1 EBD8                     jmp @@prscomment118
  2993                                  @@prscomment119:
  2994                                  
  2995                                  ;-26 int prs(unsigned char *s) {unsigned char c; int com; com=0;
  2996 00001FA3 C9                       LEAVE
  2997 00001FA4 C3                       ret
  2998                                  ; ENDP
  2999                                  
  3000                                  prs:  ; *** PROC ***
  3001                                  ;Function : prs, Number of local variables: 3
  3002                                  ;   # type sign width line used address name   list of local variables
  3003                                  ;  200 ptr unsg byte    26 NULL bp+4    s
  3004                                  ;  201 var unsg byte    26 NULL bp-2    c
  3005                                  ;  202 var sign word    26 NULL bp-4    com;
  3006 00001FA5 C8040000                 ENTER  4,0
  3007 00001FA9 66B800000000             mov eax, 0
  3008 00001FAF 8946FC                   mov word [bp-4], ax
  3009                                  
  3010                                  ;-27   while(*s) { c=*s; if (c==34) if (com) com=0; else com=1;
  3011                                  
  3012                                  @@prs120:
  3013 00001FB2 8B5E04                   mov bx, [bp+4]
  3014 00001FB5 8A07                     mov al, [bx]
  3015 00001FB7 B400                     mov ah, 0
  3016 00001FB9 08C0                     or  al, al
  3017 00001FBB 0F848700                 je @@prs121
  3018 00001FBF 8B5E04                   mov bx, [bp+4]
  3019 00001FC2 8A07                     mov al, [bx]
  3020 00001FC4 B400                     mov ah, 0
  3021 00001FC6 8846FE                   mov byte [bp-2], al
  3022 00001FC9 8A46FE                   mov al, [bp-2]
  3023 00001FCC 3C22                     cmp al, 34
  3024 00001FCE 0F851E00                 jne @@prs122
  3025 00001FD2 8B46FC                   mov ax, [bp-4]
  3026 00001FD5 08C0                     or  al, al
  3027 00001FD7 0F840C00                 je @@prs123
  3028 00001FDB 66B800000000             mov eax, 0
  3029 00001FE1 8946FC                   mov word [bp-4], ax
  3030 00001FE4 E90900                   jmp @@prs124
  3031                                  @@prs123:
  3032 00001FE7 66B801000000             mov eax, 1
  3033 00001FED 8946FC                   mov word [bp-4], ax
  3034                                  
  3035                                  ;-28     if (c==92) { if (com==0) { s++; c=*s;
  3036                                  
  3037                                  @@prs124:
  3038                                  @@prs122:
  3039 00001FF0 8A46FE                   mov al, [bp-2]
  3040 00001FF3 3C5C                     cmp al, 92
  3041 00001FF5 0F853B00                 jne @@prs125
  3042 00001FF9 8B46FC                   mov ax, [bp-4]
  3043 00001FFC 83F800                   cmp ax, 0
  3044 00001FFF 0F853100                 jne @@prs126
  3045 00002003 FF4604                   inc  word [bp+4]
  3046 00002006 8B5E04                   mov bx, [bp+4]
  3047 00002009 8A07                     mov al, [bx]
  3048 0000200B B400                     mov ah, 0
  3049 0000200D 8846FE                   mov byte [bp-2], al
  3050                                  
  3051                                  ;-29           if (c=='n') c=10; if (c=='t') c= 9; } } prc(c); s++;  }
  3052                                  
  3053 00002010 8A46FE                   mov al, [bp-2]
  3054 00002013 3C6E                     cmp al, 110
  3055 00002015 0F850900                 jne @@prs127
  3056 00002019 66B80A000000             mov eax, 10
  3057 0000201F 8846FE                   mov byte [bp-2], al
  3058                                  @@prs127:
  3059 00002022 8A46FE                   mov al, [bp-2]
  3060 00002025 3C74                     cmp al, 116
  3061 00002027 0F850900                 jne @@prs128
  3062 0000202B 66B809000000             mov eax, 9
  3063 00002031 8846FE                   mov byte [bp-2], al
  3064                                  @@prs128:
  3065                                  @@prs126:
  3066                                  @@prs125:
  3067 00002034 8A46FE                   mov al, byte [bp-2]
  3068 00002037 B400                     mov ah, 0
  3069 00002039 50                       push ax
  3070 0000203A E807FF                   call prc
  3071 0000203D 83C402                   add  sp, 2
  3072 00002040 FF4604                   inc  word [bp+4]
  3073                                  
  3074                                  ;-30 }
  3075                                  
  3076 00002043 E96CFF                   jmp @@prs120
  3077                                  @@prs121:
  3078                                  
  3079                                  ;-31 int printhex8a(unsigned int c) { unsigned int nib;
  3080 00002046 C9                       LEAVE
  3081 00002047 C3                       ret
  3082                                  ; ENDP
  3083                                  
  3084                                  printhex8a:  ; *** PROC ***
  3085                                  
  3086                                  ;-32   nib = c >> 4; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3087                                  
  3088                                  ;Function : printhex8a, Number of local variables: 2
  3089                                  ;   # type sign width line used address name   list of local variables
  3090                                  ;  200 var unsg word    31 NULL bp+4    c
  3091                                  ;  201 var unsg word    31 NULL bp-2    nib;
  3092 00002048 C8020000                 ENTER  2,0
  3093 0000204C 8B4604                   mov ax, [bp+4]
  3094 0000204F C1E804                   shr ax, 4
  3095 00002052 8946FE                   mov word [bp-2], ax
  3096 00002055 8346FE30                 add  word [bp-2], 48
  3097 00002059 8B46FE                   mov ax, [bp-2]
  3098 0000205C 83F839                   cmp ax, 57
  3099 0000205F 0F8E0400                 jle @@printhex8a129
  3100 00002063 8346FE07                 add  word [bp-2], 7
  3101                                  @@printhex8a129:
  3102 00002067 FF76FE                   push word [bp-2]
  3103 0000206A E8D7FE                   call prc
  3104 0000206D 83C402                   add  sp, 2
  3105                                  
  3106                                  ;-33   nib = c & 15; nib += 48; if (nib > 57)nib += 7; prc(nib);
  3107                                  
  3108 00002070 8B4604                   mov ax, [bp+4]
  3109 00002073 83E00F                   and ax, 15
  3110 00002076 8946FE                   mov word [bp-2], ax
  3111 00002079 8346FE30                 add  word [bp-2], 48
  3112 0000207D 8B46FE                   mov ax, [bp-2]
  3113 00002080 83F839                   cmp ax, 57
  3114 00002083 0F8E0400                 jle @@printhex8a130
  3115 00002087 8346FE07                 add  word [bp-2], 7
  3116                                  @@printhex8a130:
  3117 0000208B FF76FE                   push word [bp-2]
  3118 0000208E E8B3FE                   call prc
  3119 00002091 83C402                   add  sp, 2
  3120                                  
  3121                                  ;-34 }
  3122                                  
  3123                                  
  3124                                  ;-35 int printhex16(unsigned int i) {unsigned int half;
  3125 00002094 C9                       LEAVE
  3126 00002095 C3                       ret
  3127                                  ; ENDP
  3128                                  
  3129                                  printhex16:  ; *** PROC ***
  3130                                  
  3131                                  ;-36   half = i >>  8; printhex8a(half); half = i & 255; printhex8a(half);
  3132                                  
  3133                                  ;Function : printhex16, Number of local variables: 2
  3134                                  ;   # type sign width line used address name   list of local variables
  3135                                  ;  200 var unsg word    35 NULL bp+4    i
  3136                                  ;  201 var unsg word    35 NULL bp-2    half;
  3137 00002096 C8020000                 ENTER  2,0
  3138 0000209A 8B4604                   mov ax, [bp+4]
  3139 0000209D C1E808                   shr ax, 8
  3140 000020A0 8946FE                   mov word [bp-2], ax
  3141 000020A3 FF76FE                   push word [bp-2]
  3142 000020A6 E89FFF                   call printhex8a
  3143 000020A9 83C402                   add  sp, 2
  3144 000020AC 8B4604                   mov ax, [bp+4]
  3145 000020AF 25FF00                   and ax, 255
  3146 000020B2 8946FE                   mov word [bp-2], ax
  3147 000020B5 FF76FE                   push word [bp-2]
  3148 000020B8 E88DFF                   call printhex8a
  3149 000020BB 83C402                   add  sp, 2
  3150                                  
  3151                                  ;-37 }
  3152                                  
  3153                                  
  3154                                  ;-38 int printIntU(unsigned int n) { unsigned int e;
  3155 000020BE C9                       LEAVE
  3156 000020BF C3                       ret
  3157                                  ; ENDP
  3158                                  
  3159                                  printIntU:  ; *** PROC ***
  3160                                  
  3161                                  ;-39   if ( _ n >= 10) {  e=n/10; //DIV
  3162                                  
  3163                                  ;Function : printIntU, Number of local variables: 2
  3164                                  ;   # type sign width line used address name   list of local variables
  3165                                  ;  200 var unsg word    38 NULL bp+4    n
  3166                                  ;  201 var unsg word    38 NULL bp-2    e;
  3167 000020C0 C8020000                 ENTER  2,0
  3168 000020C4 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3169 000020C8 0F821700                 jb  @@printIntU131
  3170 000020CC 8B4604                   mov ax, [bp+4]
  3171 000020CF BB0A00                   mov bx, 10
  3172 000020D2 BA0000                   mov dx, 0
  3173 000020D5 F7F3                     div bx
  3174 000020D7 8946FE                   mov word [bp-2], ax
  3175                                  
  3176                                  ;-40     printIntU(e); }
  3177                                  
  3178 000020DA FF76FE                   push word [bp-2]
  3179 000020DD E8E0FF                   call printIntU
  3180 000020E0 83C402                   add  sp, 2
  3181                                  
  3182                                  ;-41     n = n % 10; //unsigned mod
  3183                                  
  3184                                  @@printIntU131:
  3185 000020E3 8B4604                   mov ax, [bp+4]
  3186 000020E6 BB0A00                   mov bx, 10
  3187 000020E9 BA0000                   mov dx, 0
  3188 000020EC F7F3                     div bx
  3189 000020EE 89D0                     mov ax, dx
  3190 000020F0 894604                   mov word [bp+4], ax
  3191                                  
  3192                                  ;-42     n += '0'; prc(n);
  3193                                  
  3194 000020F3 83460430                 add  word [bp+4], 48
  3195 000020F7 FF7604                   push word [bp+4]
  3196 000020FA E847FE                   call prc
  3197 000020FD 83C402                   add  sp, 2
  3198                                  
  3199                                  ;-43 }
  3200                                  
  3201                                  
  3202                                  ;-44 
  3203                                  
  3204                                  
  3205                                  ;-45 int error1(char *s) { LIST=1; ErrorCount++;
  3206 00002100 C9                       LEAVE
  3207 00002101 C3                       ret
  3208                                  ; ENDP
  3209                                  
  3210                                  error1:  ; *** PROC ***
  3211                                  ;Function : error1, Number of local variables: 1
  3212                                  ;   # type sign width line used address name   list of local variables
  3213                                  ;  200 ptr sign byte    45 NULL bp+4    s;
  3214 00002102 C8000000                 ENTER  0,0
  3215 00002106 66B801000000             mov eax, 1
  3216 0000210C A2[0E00]                 mov byte [LIST], al
  3217 0000210F FF06[A101]               inc  word [ErrorCount]
  3218                                  
  3219                                  ;-46   prs("\n;***** next line ERROR: "); prs(s);
  3220                                  
  3221 00002113 68[3B21]                 push error1_0
  3222 00002116 E88CFE                   call prs
  3223 00002119 83C402                   add  sp, 2
  3224 0000211C FF7604                   push word [bp+4]
  3225 0000211F E883FE                   call prs
  3226 00002122 83C402                   add  sp, 2
  3227                                  
  3228                                  ;-47   prs(", Symbol: "); prs(Symbol);}
  3229                                  
  3230 00002125 68[5621]                 push error1_1
  3231 00002128 E87AFE                   call prs
  3232 0000212B 83C402                   add  sp, 2
  3233 0000212E 8D06[0F00]               lea  ax, [Symbol]
  3234 00002132 50                       push ax
  3235 00002133 E86FFE                   call prs
  3236 00002136 83C402                   add  sp, 2
  3237                                  
  3238                                  ;-48 int allowederror(){error1("not allowed here"); }
  3239 00002139 C9                       LEAVE
  3240 0000213A C3                       ret
  3241                                  ; ENDP
  3242 0000213B 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3243 00002144 6E657874206C696E65-
  3244 0000214D 204552524F523A2000 
  3245 00002156 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3246 0000215F 2000               
  3247                                  
  3248                                  allowederror:  ; *** PROC ***
  3249 00002161 68[6B21]                 push allowederror_0
  3250 00002164 E89BFF                   call error1
  3251 00002167 83C402                   add  sp, 2
  3252                                  
  3253                                  ;-49 int addrerror()   {error1("address missing");} 
  3254                                  
  3255 0000216A C3                       ret
  3256                                  ; ENDP
  3257 0000216B 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3258 00002174 6564206865726500   
  3259                                  
  3260                                  addrerror:  ; *** PROC ***
  3261 0000217C 68[8621]                 push addrerror_0
  3262 0000217F E880FF                   call error1
  3263 00002182 83C402                   add  sp, 2
  3264                                  
  3265                                  ;-50 int immeerror()   {error1("immediate not allowed here");}
  3266                                  
  3267 00002185 C3                       ret
  3268                                  ; ENDP
  3269 00002186 61646472657373206D-     addrerror_0 db "address missing",0
  3270 0000218F 697373696E6700     
  3271                                  
  3272                                  immeerror:  ; *** PROC ***
  3273 00002196 68[A021]                 push immeerror_0
  3274 00002199 E866FF                   call error1
  3275 0000219C 83C402                   add  sp, 2
  3276                                  
  3277                                  ;-51 int implerror()   {error1("not implemented");}
  3278                                  
  3279 0000219F C3                       ret
  3280                                  ; ENDP
  3281 000021A0 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  3282 000021A9 206E6F7420616C6C6F-
  3283 000021B2 776564206865726500 
  3284                                  
  3285                                  implerror:  ; *** PROC ***
  3286 000021BB 68[C521]                 push implerror_0
  3287 000021BE E841FF                   call error1
  3288 000021C1 83C402                   add  sp, 2
  3289                                  
  3290                                  ;-52 int indexerror()  {error1("invalid index register");}
  3291                                  
  3292 000021C4 C3                       ret
  3293                                  ; ENDP
  3294 000021C5 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3295 000021CE 6D656E74656400     
  3296                                  
  3297                                  indexerror:  ; *** PROC ***
  3298 000021D5 68[DF21]                 push indexerror_0
  3299 000021D8 E827FF                   call error1
  3300 000021DB 83C402                   add  sp, 2
  3301                                  
  3302                                  ;-53 int invaloperror(){error1("invalid or no operands");}
  3303                                  
  3304 000021DE C3                       ret
  3305                                  ; ENDP
  3306 000021DF 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3307 000021E8 6E6465782072656769-
  3308 000021F1 7374657200         
  3309                                  
  3310                                  invaloperror:  ; *** PROC ***
  3311 000021F6 68[0022]                 push invaloperror_0
  3312 000021F9 E806FF                   call error1
  3313 000021FC 83C402                   add  sp, 2
  3314                                  
  3315                                  ;-54 int numbererror() {error1("number expected");}
  3316                                  
  3317 000021FF C3                       ret
  3318                                  ; ENDP
  3319 00002200 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3320 00002209 72206E6F206F706572-
  3321 00002212 616E647300         
  3322                                  
  3323                                  numbererror:  ; *** PROC ***
  3324 00002217 68[2122]                 push numbererror_0
  3325 0000221A E8E5FE                   call error1
  3326 0000221D 83C402                   add  sp, 2
  3327                                  
  3328                                  ;-55 int regmemerror() {error1("only register or memory allowed");}
  3329                                  
  3330 00002220 C3                       ret
  3331                                  ; ENDP
  3332 00002221 6E756D626572206578-     numbererror_0 db "number expected",0
  3333 0000222A 70656374656400     
  3334                                  
  3335                                  regmemerror:  ; *** PROC ***
  3336 00002231 68[3B22]                 push regmemerror_0
  3337 00002234 E8CBFE                   call error1
  3338 00002237 83C402                   add  sp, 2
  3339                                  
  3340                                  ;-56 int reg16error()  {error1("only reg16, no segreg allowed");}
  3341                                  
  3342 0000223A C3                       ret
  3343                                  ; ENDP
  3344 0000223B 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3345 00002244 73746572206F72206D-
  3346 0000224D 656D6F727920616C6C-
  3347 00002256 6F77656400         
  3348                                  
  3349                                  reg16error:  ; *** PROC ***
  3350 0000225B 68[6522]                 push reg16error_0
  3351 0000225E E8A1FE                   call error1
  3352 00002261 83C402                   add  sp, 2
  3353                                  
  3354                                  ;-57 int segregerror() {error1("segment register not allowed");}
  3355                                  
  3356 00002264 C3                       ret
  3357                                  ; ENDP
  3358 00002265 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3359 0000226E 362C206E6F20736567-
  3360 00002277 72656720616C6C6F77-
  3361 00002280 656400             
  3362                                  
  3363                                  segregerror:  ; *** PROC ***
  3364 00002283 68[8D22]                 push segregerror_0
  3365 00002286 E879FE                   call error1
  3366 00002289 83C402                   add  sp, 2
  3367                                  
  3368                                  ;-58 int syntaxerror() {error1("syntax");}
  3369                                  
  3370 0000228C C3                       ret
  3371                                  ; ENDP
  3372 0000228D 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3373 00002296 65676973746572206E-
  3374 0000229F 6F7420616C6C6F7765-
  3375 000022A8 6400               
  3376                                  
  3377                                  syntaxerror:  ; *** PROC ***
  3378 000022AA 68[B422]                 push syntaxerror_0
  3379 000022AD E852FE                   call error1
  3380 000022B0 83C402                   add  sp, 2
  3381                                  
  3382                                  ;-59 
  3383                                  
  3384                                  
  3385                                  ;-60 int errorexit(char *s) { error1(s); end1(1);}
  3386                                  
  3387 000022B3 C3                       ret
  3388                                  ; ENDP
  3389 000022B4 73796E74617800          syntaxerror_0 db "syntax",0
  3390                                  
  3391                                  errorexit:  ; *** PROC ***
  3392                                  ;Function : errorexit, Number of local variables: 1
  3393                                  ;   # type sign width line used address name   list of local variables
  3394                                  ;  200 ptr sign byte    60 NULL bp+4    s;
  3395 000022BB C8000000                 ENTER  0,0
  3396 000022BF FF7604                   push word [bp+4]
  3397 000022C2 E83DFE                   call error1
  3398 000022C5 83C402                   add  sp, 2
  3399 000022C8 6A01                     push 1
  3400 000022CA E85003                   call end1
  3401 000022CD 83C402                   add  sp, 2
  3402                                  
  3403                                  ;-61 int addrexit(){errorexit("illegal address");}
  3404 000022D0 C9                       LEAVE
  3405 000022D1 C3                       ret
  3406                                  ; ENDP
  3407                                  
  3408                                  addrexit:  ; *** PROC ***
  3409 000022D2 68[DC22]                 push addrexit_0
  3410 000022D5 E8E3FF                   call errorexit
  3411 000022D8 83C402                   add  sp, 2
  3412                                  
  3413                                  ;-62 int internexit(){errorexit("intern compiler error");}
  3414                                  
  3415 000022DB C3                       ret
  3416                                  ; ENDP
  3417 000022DC 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3418 000022E5 64647265737300     
  3419                                  
  3420                                  internexit:  ; *** PROC ***
  3421 000022EC 68[F622]                 push internexit_0
  3422 000022EF E8C9FF                   call errorexit
  3423 000022F2 83C402                   add  sp, 2
  3424 000022F5 C3                       ret
  3425                                  ; ENDP
  3426 000022F6 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3427 000022FF 6D70696C6572206572-
  3428 00002308 726F7200           
  3429                                  ;Back to main program: AS.C
  3430                                  
  3431                                  ;-8 #include "MAIN.C"
  3432                                  
  3433                                  ;Use include file: MAIN.C
  3434                                  
  3435                                  ;-1 int main() {
  3436                                  
  3437                                  
  3438                                  main:  ; *** PROC ***
  3439                                  
  3440                                  ;-2   getarg(); 
  3441                                  
  3442 0000230C E80A00                   call getarg
  3443                                  
  3444                                  ;-3   parse(); 
  3445                                  
  3446 0000230F E8DCEE                   call parse
  3447                                  
  3448                                  ;-4   epilog(); 
  3449                                  
  3450 00002312 E85C02                   call epilog
  3451                                  
  3452                                  ;-5   end1();
  3453                                  
  3454 00002315 E80503                   call end1
  3455                                  
  3456                                  ;-6 }
  3457                                  
  3458                                  
  3459                                  ;-7 
  3460                                  
  3461                                  
  3462                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3463                                  
  3464 00002318 C3                       ret
  3465                                  ; ENDP
  3466                                  
  3467                                  getarg:  ; *** PROC ***
  3468                                  
  3469                                  ;-9   arglen1=*arglen;
  3470                                  
  3471                                  ;Function : getarg, Number of local variables: 3
  3472                                  ;   # type sign width line used address name   list of local variables
  3473                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3474                                  ;  201 var sign word     8 NULL bp-4    i
  3475                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3476 00002319 C8060000                 ENTER  6,0
  3477 0000231D 8B1E[510E]               mov bx, [arglen]
  3478 00002321 8A07                     mov al, [bx]
  3479 00002323 B400                     mov ah, 0
  3480 00002325 8946FE                   mov word [bp-2], ax
  3481                                  
  3482                                  ;-10   if (arglen1==0) {
  3483                                  
  3484 00002328 8B46FE                   mov ax, [bp-2]
  3485 0000232B 83F800                   cmp ax, 0
  3486 0000232E 0F851C00                 jne @@getarg132
  3487                                  
  3488                                  ;-11     cputs(Version1);
  3489                                  
  3490 00002332 8D06[0300]               lea  ax, [Version1]
  3491 00002336 50                       push ax
  3492 00002337 E8B80C                   call cputs
  3493 0000233A 83C402                   add  sp, 2
  3494                                  
  3495                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3496                                  
  3497 0000233D 68[DE24]                 push getarg_0
  3498 00002340 E8AF0C                   call cputs
  3499 00002343 83C402                   add  sp, 2
  3500                                  
  3501                                  ;-13     exitR(3);
  3502                                  
  3503 00002346 6A03                     push 3
  3504 00002348 E8820E                   call exitR
  3505 0000234B 83C402                   add  sp, 2
  3506                                  
  3507                                  ;-14   }
  3508                                  
  3509                                  
  3510                                  ;-15   i=arglen1+129; 
  3511                                  
  3512                                  @@getarg132:
  3513 0000234E 8B46FE                   mov ax, [bp-2]
  3514 00002351 058100                   add ax, 129
  3515 00002354 8946FC                   mov word [bp-4], ax
  3516                                  
  3517                                  ;-16   *i=0;  
  3518                                  
  3519 00002357 66B800000000             mov eax, 0
  3520 0000235D 8B5EFC                   mov  bx, [bp-4]
  3521 00002360 8907                     mov  [bx], ax
  3522                                  
  3523                                  ;-17   arglen1--;
  3524                                  
  3525 00002362 FF4EFE                   dec  word [bp-2]
  3526                                  
  3527                                  ;-18   toupper(argv);
  3528                                  
  3529 00002365 FF36[530E]               push word [argv]
  3530 00002369 E8B40C                   call toupper
  3531 0000236C 83C402                   add  sp, 2
  3532                                  
  3533                                  ;-19   
  3534                                  
  3535                                  
  3536                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3537                                  
  3538 0000236F FF36[530E]               push word [argv]
  3539 00002373 8D06[D000]               lea  ax, [namein]
  3540 00002377 50                       push ax
  3541 00002378 E8130D                   call strcpy
  3542 0000237B 83C404                   add  sp, 4
  3543 0000237E 68[0325]                 push getarg_1
  3544 00002381 8D06[D000]               lea  ax, [namein]
  3545 00002385 50                       push ax
  3546 00002386 E8C60D                   call strcat1
  3547 00002389 83C404                   add  sp, 4
  3548                                  
  3549                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3550                                  
  3551 0000238C FF36[530E]               push word [argv]
  3552 00002390 8D06[1301]               lea  ax, [namelst]
  3553 00002394 50                       push ax
  3554 00002395 E8F60C                   call strcpy
  3555 00002398 83C404                   add  sp, 4
  3556 0000239B 68[0625]                 push getarg_2
  3557 0000239E 8D06[1301]               lea  ax, [namelst]
  3558 000023A2 50                       push ax
  3559 000023A3 E8A90D                   call strcat1
  3560 000023A6 83C404                   add  sp, 4
  3561                                  
  3562                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3563                                  
  3564 000023A9 FF36[530E]               push word [argv]
  3565 000023AD 8D06[5601]               lea  ax, [namebin]
  3566 000023B1 50                       push ax
  3567 000023B2 E8D90C                   call strcpy
  3568 000023B5 83C404                   add  sp, 4
  3569 000023B8 68[0B25]                 push getarg_3
  3570 000023BB 8D06[5601]               lea  ax, [namebin]
  3571 000023BF 50                       push ax
  3572 000023C0 E88C0D                   call strcat1
  3573 000023C3 83C404                   add  sp, 4
  3574                                  
  3575                                  ;-23 
  3576                                  
  3577                                  
  3578                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3579                                  
  3580 000023C6 66B801000000             mov eax, 1
  3581 000023CC A2[0E00]                 mov byte [LIST], al
  3582 000023CF 66B800000000             mov eax, 0
  3583 000023D5 A3[9F01]                 mov word [DOS_ERR], ax
  3584 000023D8 66B800000000             mov eax, 0
  3585 000023DE A3[A601]                 mov word [PC], ax
  3586 000023E1 66B800000000             mov eax, 0
  3587 000023E7 A3[A101]                 mov word [ErrorCount], ax
  3588                                  
  3589                                  ;-25   
  3590                                  
  3591                                  
  3592                                  ;-26   asm_fd=openR (namein);
  3593                                  
  3594 000023EA 8D06[D000]               lea  ax, [namein]
  3595 000023EE 50                       push ax
  3596 000023EF E8820D                   call openR
  3597 000023F2 83C402                   add  sp, 2
  3598 000023F5 A3[9901]                 mov word [asm_fd], ax
  3599                                  
  3600                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3601                                  
  3602 000023F8 A1[9F01]                 mov ax, [DOS_ERR]
  3603 000023FB 08C0                     or  al, al
  3604 000023FD 0F841C00                 je @@getarg133
  3605 00002401 68[1025]                 push getarg_4
  3606 00002404 E8EB0B                   call cputs
  3607 00002407 83C402                   add  sp, 2
  3608 0000240A 8D06[D000]               lea  ax, [namein]
  3609 0000240E 50                       push ax
  3610 0000240F E8E00B                   call cputs
  3611 00002412 83C402                   add  sp, 2
  3612 00002415 6A01                     push 1
  3613 00002417 E8B30D                   call exitR
  3614 0000241A 83C402                   add  sp, 2
  3615                                  
  3616                                  ;-28   lst_fd=creatR(namelst);
  3617                                  
  3618                                  @@getarg133:
  3619 0000241D 8D06[1301]               lea  ax, [namelst]
  3620 00002421 50                       push ax
  3621 00002422 E85E0D                   call creatR
  3622 00002425 83C402                   add  sp, 2
  3623 00002428 A3[9B01]                 mov word [lst_fd], ax
  3624                                  
  3625                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3626                                  
  3627 0000242B A1[9F01]                 mov ax, [DOS_ERR]
  3628 0000242E 08C0                     or  al, al
  3629 00002430 0F841C00                 je @@getarg134
  3630 00002434 68[2625]                 push getarg_5
  3631 00002437 E8B80B                   call cputs
  3632 0000243A 83C402                   add  sp, 2
  3633 0000243D 8D06[1301]               lea  ax, [namelst]
  3634 00002441 50                       push ax
  3635 00002442 E8AD0B                   call cputs
  3636 00002445 83C402                   add  sp, 2
  3637 00002448 6A02                     push 2
  3638 0000244A E8800D                   call exitR
  3639 0000244D 83C402                   add  sp, 2
  3640                                  
  3641                                  ;-30   bin_fd=creatR(namebin);
  3642                                  
  3643                                  @@getarg134:
  3644 00002450 8D06[5601]               lea  ax, [namebin]
  3645 00002454 50                       push ax
  3646 00002455 E82B0D                   call creatR
  3647 00002458 83C402                   add  sp, 2
  3648 0000245B A3[9D01]                 mov word [bin_fd], ax
  3649                                  
  3650                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3651                                  
  3652 0000245E A1[9F01]                 mov ax, [DOS_ERR]
  3653 00002461 08C0                     or  al, al
  3654 00002463 0F841C00                 je @@getarg135
  3655 00002467 68[3D25]                 push getarg_6
  3656 0000246A E8850B                   call cputs
  3657 0000246D 83C402                   add  sp, 2
  3658 00002470 8D06[5601]               lea  ax, [namebin]
  3659 00002474 50                       push ax
  3660 00002475 E87A0B                   call cputs
  3661 00002478 83C402                   add  sp, 2
  3662 0000247B 6A02                     push 2
  3663 0000247D E84D0D                   call exitR
  3664 00002480 83C402                   add  sp, 2
  3665                                  
  3666                                  ;-32   
  3667                                  
  3668                                  
  3669                                  ;-33   prs(";");prs(Version1);
  3670                                  
  3671                                  @@getarg135:
  3672 00002483 68[5325]                 push getarg_7
  3673 00002486 E81CFB                   call prs
  3674 00002489 83C402                   add  sp, 2
  3675 0000248C 8D06[0300]               lea  ax, [Version1]
  3676 00002490 50                       push ax
  3677 00002491 E811FB                   call prs
  3678 00002494 83C402                   add  sp, 2
  3679                                  
  3680                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3681                                  
  3682 00002497 68[5525]                 push getarg_8
  3683 0000249A E808FB                   call prs
  3684 0000249D 83C402                   add  sp, 2
  3685 000024A0 8D06[D000]               lea  ax, [namein]
  3686 000024A4 50                       push ax
  3687 000024A5 E8FDFA                   call prs
  3688 000024A8 83C402                   add  sp, 2
  3689 000024AB 68[6025]                 push getarg_9
  3690 000024AE E8F4FA                   call prs
  3691 000024B1 83C402                   add  sp, 2
  3692 000024B4 8D06[1301]               lea  ax, [namelst]
  3693 000024B8 50                       push ax
  3694 000024B9 E8E9FA                   call prs
  3695 000024BC 83C402                   add  sp, 2
  3696                                  
  3697                                  ;-35   prs(", "); prs(namebin);
  3698                                  
  3699 000024BF 68[6B25]                 push getarg_10
  3700 000024C2 E8E0FA                   call prs
  3701 000024C5 83C402                   add  sp, 2
  3702 000024C8 8D06[5601]               lea  ax, [namebin]
  3703 000024CC 50                       push ax
  3704 000024CD E8D5FA                   call prs
  3705 000024D0 83C402                   add  sp, 2
  3706                                  
  3707                                  ;-36   prs("\n");
  3708                                  
  3709 000024D3 68[6E25]                 push getarg_11
  3710 000024D6 E8CCFA                   call prs
  3711 000024D9 83C402                   add  sp, 2
  3712                                  
  3713                                  ;-37 }
  3714                                  
  3715                                  
  3716                                  ;-38 int epilog() { int i; int j; char c;
  3717 000024DC C9                       LEAVE
  3718 000024DD C3                       ret
  3719                                  ; ENDP
  3720 000024DE 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3721 000024E7 41532E434F4D206669-
  3722 000024F0 6C656E616D65205B77-
  3723 000024F9 2F6F202E535D203A20-
  3724 00002502 00                 
  3725 00002503 2E5300                  getarg_1 db ".S",0
  3726 00002506 2E4C535400              getarg_2 db ".LST",0
  3727 0000250B 2E434F4D00              getarg_3 db ".COM",0
  3728 00002510 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3729 00002519 6C65206D697373696E-
  3730 00002522 673A2000           
  3731 00002526 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3732 0000252F 206E6F742063726561-
  3733 00002538 74653A2000         
  3734 0000253D 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3735 00002546 6E6F74206372656174-
  3736 0000254F 653A2000           
  3737 00002553 3B00                    getarg_7 db ";",0
  3738 00002555 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3739 0000255E 2000               
  3740 00002560 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3741 00002569 2000               
  3742 0000256B 2C2000                  getarg_10 db ", ",0
  3743 0000256E 5C6E00                  getarg_11 db "\n",0
  3744                                  
  3745                                  epilog:  ; *** PROC ***
  3746                                  
  3747                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3748                                  
  3749                                  ;Function : epilog, Number of local variables: 3
  3750                                  ;   # type sign width line used address name   list of local variables
  3751                                  ;  200 var sign word    38 NULL bp-2    i
  3752                                  ;  201 var sign word    38 NULL bp-4    j
  3753                                  ;  202 var sign byte    38 NULL bp-6    c;
  3754 00002571 C8060000                 ENTER  6,0
  3755 00002575 68[EB25]                 push epilog_0
  3756 00002578 E82AFA                   call prs
  3757 0000257B 83C402                   add  sp, 2
  3758 0000257E FF36[A101]               push word [ErrorCount]
  3759 00002582 E83BFB                   call printIntU
  3760 00002585 83C402                   add  sp, 2
  3761                                  
  3762                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3763                                  
  3764 00002588 A1[A101]                 mov ax, [ErrorCount]
  3765 0000258B 08C0                     or  al, al
  3766 0000258D 0F840900                 je @@epilog136
  3767 00002591 68[FB25]                 push epilog_1
  3768 00002594 E80EFA                   call prs
  3769 00002597 83C402                   add  sp, 2
  3770                                  
  3771                                  ;-41 /*    
  3772                                  
  3773                                  
  3774                                  ;-42   prs(", Label & Var: ");
  3775                                  
  3776                                  
  3777                                  ;-43   if (LabelMaxIx) {
  3778                                  
  3779                                  
  3780                                  ;-44     i = 1;
  3781                                  
  3782                                  
  3783                                  ;-45     LabelNamePtr= &LabelNames;
  3784                                  
  3785                                  
  3786                                  ;-46     do {
  3787                                  
  3788                                  
  3789                                  ;-47       prs(LabelNamePtr); prc(' ');
  3790                                  
  3791                                  
  3792                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3793                                  
  3794                                  
  3795                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3796                                  
  3797                                  
  3798                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3799                                  
  3800                                  
  3801                                  ;-51       LabelNamePtr++;
  3802                                  
  3803                                  
  3804                                  ;-52       i++;
  3805                                  
  3806                                  
  3807                                  ;-53     } while (i <= LabelMaxIx);
  3808                                  
  3809                                  
  3810                                  ;-54   }
  3811                                  
  3812                                  
  3813                                  ;-55 */  
  3814                                  
  3815                                  
  3816                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3817                                  
  3818                                  @@epilog136:
  3819 0000259A 68[0926]                 push epilog_2
  3820 0000259D E805FA                   call prs
  3821 000025A0 83C402                   add  sp, 2
  3822 000025A3 FF36[4F0E]               push word [BinLen]
  3823 000025A7 E816FB                   call printIntU
  3824 000025AA 83C402                   add  sp, 2
  3825 000025AD 68[1526]                 push epilog_3
  3826 000025B0 E8F2F9                   call prs
  3827 000025B3 83C402                   add  sp, 2
  3828                                  
  3829                                  ;-57 //  i=0;
  3830                                  
  3831                                  
  3832                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  3833                                  
  3834                                  
  3835                                  ;-59 //  } while (i < BinLen);
  3836                                  
  3837                                  
  3838                                  ;-60   i=0;
  3839                                  
  3840 000025B6 66B800000000             mov eax, 0
  3841 000025BC 8946FE                   mov word [bp-2], ax
  3842                                  
  3843                                  ;-61   do {
  3844                                  
  3845                                  @@epilog137:
  3846                                  
  3847                                  ;-62     c = FileBin[i];
  3848                                  
  3849 000025BF 8B5EFE                   mov bx, [bp-2]
  3850 000025C2 8A87[7F06]               mov al, [FileBin + bx]
  3851 000025C6 8846FA                   mov byte [bp-6], al
  3852                                  
  3853                                  ;-63     fputcR(c, bin_fd);
  3854                                  
  3855 000025C9 FF36[9D01]               push word [bin_fd]
  3856 000025CD 8A46FA                   mov al, byte [bp-6]
  3857 000025D0 B400                     mov ah, 0
  3858 000025D2 50                       push ax
  3859 000025D3 E8D40B                   call fputcR
  3860 000025D6 83C404                   add  sp, 4
  3861                                  
  3862                                  ;-64     i++;
  3863                                  
  3864 000025D9 FF46FE                   inc  word [bp-2]
  3865                                  
  3866                                  ;-65   } while (i < BinLen);
  3867                                  
  3868 000025DC 8B46FE                   mov ax, [bp-2]
  3869 000025DF 3B06[4F0E]               cmp ax, [BinLen]
  3870 000025E3 0F8D0200                 jge @@epilog138
  3871 000025E7 EBD6                     jmp @@epilog137
  3872                                  @@epilog138:
  3873                                  
  3874                                  ;-66 }
  3875                                  
  3876                                  
  3877                                  ;-67 int end1(int n) {
  3878 000025E9 C9                       LEAVE
  3879 000025EA C3                       ret
  3880                                  ; ENDP
  3881 000025EB 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  3882 000025F4 726F72733A2000     
  3883 000025FB 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  3884 00002604 2A2A2A2000         
  3885 00002609 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  3886 00002612 652000             
  3887 00002615 2062797465732E00        epilog_3 db " bytes.",0
  3888                                  
  3889                                  end1:  ; *** PROC ***
  3890                                  
  3891                                  ;-68   fcloseR(asm_fd);
  3892                                  
  3893                                  ;Function : end1, Number of local variables: 1
  3894                                  ;   # type sign width line used address name   list of local variables
  3895                                  ;  200 var sign word    67 NULL bp+4    n;
  3896 0000261D C8000000                 ENTER  0,0
  3897 00002621 FF36[9901]               push word [asm_fd]
  3898 00002625 E8970B                   call fcloseR
  3899 00002628 83C402                   add  sp, 2
  3900                                  
  3901                                  ;-69   fcloseR(lst_fd);
  3902                                  
  3903 0000262B FF36[9B01]               push word [lst_fd]
  3904 0000262F E88D0B                   call fcloseR
  3905 00002632 83C402                   add  sp, 2
  3906                                  
  3907                                  ;-70   fcloseR(bin_fd);
  3908                                  
  3909 00002635 FF36[9D01]               push word [bin_fd]
  3910 00002639 E8830B                   call fcloseR
  3911 0000263C 83C402                   add  sp, 2
  3912                                  
  3913                                  ;-71   exitR(n);
  3914                                  
  3915 0000263F FF7604                   push word [bp+4]
  3916 00002642 E8880B                   call exitR
  3917 00002645 83C402                   add  sp, 2
  3918                                  
  3919                                  ;-72 }
  3920 00002648 C9                       LEAVE
  3921 00002649 C3                       ret
  3922                                  ; ENDP
  3923                                  ;Back to main program: AS.C
  3924                                  
  3925                                  ;-9 #include "GENCODE.C"
  3926                                  
  3927                                  ;Use include file: GENCODE.C
  3928                                  
  3929                                  ;-1 // generate code
  3930                                  
  3931                                  
  3932                                  ;-2 int getCodes() {
  3933                                  
  3934                                  
  3935                                  getCodes:  ; *** PROC ***
  3936                                  
  3937                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  3938                                  
  3939 0000264A FF06[C601]               inc  word [OpCodePtr]
  3940 0000264E 8B1E[C601]               mov bx, [OpCodePtr]
  3941 00002652 8A07                     mov al, [bx]
  3942 00002654 B400                     mov ah, 0
  3943 00002656 A2[AF01]                 mov byte [Code1], al
  3944                                  
  3945                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  3946                                  
  3947 00002659 FF06[C601]               inc  word [OpCodePtr]
  3948 0000265D 8B1E[C601]               mov bx, [OpCodePtr]
  3949 00002661 8A07                     mov al, [bx]
  3950 00002663 B400                     mov ah, 0
  3951 00002665 A2[B001]                 mov byte [Code2], al
  3952                                  
  3953                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  3954                                  
  3955 00002668 FF06[C601]               inc  word [OpCodePtr]
  3956 0000266C 8B1E[C601]               mov bx, [OpCodePtr]
  3957 00002670 8A07                     mov al, [bx]
  3958 00002672 B400                     mov ah, 0
  3959 00002674 A2[B101]                 mov byte [Code3], al
  3960                                  
  3961                                  ;-6 }
  3962                                  
  3963                                  
  3964                                  ;-7 int gen66h() {genCode8(0x66);
  3965                                  
  3966 00002677 C3                       ret
  3967                                  ; ENDP
  3968                                  
  3969                                  gen66h:  ; *** PROC ***
  3970 00002678 6A66                     push 102
  3971 0000267A E83B00                   call genCode8
  3972 0000267D 83C402                   add  sp, 2
  3973                                  
  3974                                  ;-8 }
  3975                                  
  3976                                  
  3977                                  ;-9 int genCode(char c, char d) {
  3978                                  
  3979 00002680 C3                       ret
  3980                                  ; ENDP
  3981                                  
  3982                                  genCode:  ; *** PROC ***
  3983                                  
  3984                                  ;-10     c = c + d;
  3985                                  
  3986                                  ;Function : genCode, Number of local variables: 2
  3987                                  ;   # type sign width line used address name   list of local variables
  3988                                  ;  200 var sign byte     9 NULL bp+4    c
  3989                                  ;  201 var sign byte     9 NULL bp+6    d;
  3990 00002681 C8000000                 ENTER  0,0
  3991 00002685 8A4604                   mov al, [bp+4]
  3992 00002688 024606                   add al, [bp+6]
  3993 0000268B 884604                   mov byte [bp+4], al
  3994                                  
  3995                                  ;-11     genCode8(c);
  3996                                  
  3997 0000268E 8A4604                   mov al, byte [bp+4]
  3998 00002691 B400                     mov ah, 0
  3999 00002693 50                       push ax
  4000 00002694 E82100                   call genCode8
  4001 00002697 83C402                   add  sp, 2
  4002                                  
  4003                                  ;-12 }                             
  4004                                  
  4005                                  
  4006                                  ;-13 int genCodeW(char c) {
  4007 0000269A C9                       LEAVE
  4008 0000269B C3                       ret
  4009                                  ; ENDP
  4010                                  
  4011                                  genCodeW:  ; *** PROC ***
  4012                                  
  4013                                  ;-14     c = c + wflag;  
  4014                                  
  4015                                  ;Function : genCodeW, Number of local variables: 1
  4016                                  ;   # type sign width line used address name   list of local variables
  4017                                  ;  200 var sign byte    13 NULL bp+4    c;
  4018 0000269C C8000000                 ENTER  0,0
  4019 000026A0 8A4604                   mov al, [bp+4]
  4020 000026A3 0206[B701]               add al, [wflag]
  4021 000026A7 884604                   mov byte [bp+4], al
  4022                                  
  4023                                  ;-15     genCode8(c);
  4024                                  
  4025 000026AA 8A4604                   mov al, byte [bp+4]
  4026 000026AD B400                     mov ah, 0
  4027 000026AF 50                       push ax
  4028 000026B0 E80500                   call genCode8
  4029 000026B3 83C402                   add  sp, 2
  4030                                  
  4031                                  ;-16 }   
  4032                                  
  4033                                  
  4034                                  ;-17 int genCode8(char c) {
  4035 000026B6 C9                       LEAVE
  4036 000026B7 C3                       ret
  4037                                  ; ENDP
  4038                                  
  4039                                  genCode8:  ; *** PROC ***
  4040                                  
  4041                                  ;-18 //set: BinLen++, OpPrintIndex++
  4042                                  
  4043                                  
  4044                                  ;-19     FileBin[BinLen]=c;
  4045                                  
  4046                                  ;Function : genCode8, Number of local variables: 1
  4047                                  ;   # type sign width line used address name   list of local variables
  4048                                  ;  200 var sign byte    17 NULL bp+4    c;
  4049 000026B8 C8000000                 ENTER  0,0
  4050 000026BC 8A4604                   mov al, [bp+4]
  4051 000026BF 8B1E[4F0E]               mov bx, [BinLen]
  4052 000026C3 8887[7F06]               mov [FileBin+bx], al
  4053                                  
  4054                                  ;-20     BinLen++;
  4055                                  
  4056 000026C7 FF06[4F0E]               inc  word [BinLen]
  4057                                  
  4058                                  ;-21     PC++;
  4059                                  
  4060 000026CB FF06[A601]               inc  word [PC]
  4061                                  
  4062                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  4063                                  
  4064 000026CF A1[4F0E]                 mov ax, [BinLen]
  4065 000026D2 3DD007                   cmp ax, 2000 ;unsigned : 0
  4066 000026D5 0F820900                 jb  @@genCode8139
  4067 000026D9 68[FD26]                 push genCode8_0
  4068 000026DC E8DCFB                   call errorexit
  4069 000026DF 83C402                   add  sp, 2
  4070                                  
  4071                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  4072                                  
  4073                                  @@genCode8139:
  4074 000026E2 A1[C401]                 mov ax, [OpPrintIndex]
  4075 000026E5 83F805                   cmp ax, 5
  4076 000026E8 0F8D0F00                 jge @@genCode8140
  4077                                  
  4078                                  ;-24         OpPos[OpPrintIndex]=c;
  4079                                  
  4080 000026EC 8A4604                   mov al, [bp+4]
  4081 000026EF 8B1E[C401]               mov bx, [OpPrintIndex]
  4082 000026F3 8887[BF01]               mov [OpPos+bx], al
  4083                                  
  4084                                  ;-25         OpPrintIndex++;
  4085                                  
  4086 000026F7 FF06[C401]               inc  word [OpPrintIndex]
  4087                                  
  4088                                  ;-26     }
  4089                                  
  4090                                  
  4091                                  ;-27 }
  4092                                  
  4093                                  @@genCode8140:
  4094                                  
  4095                                  ;-28 int genCode16(unsigned int i) {
  4096 000026FB C9                       LEAVE
  4097 000026FC C3                       ret
  4098                                  ; ENDP
  4099 000026FD 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  4100 00002706 746F6F206C6F6E6700 
  4101                                  
  4102                                  genCode16:  ; *** PROC ***
  4103                                  
  4104                                  ;-29     genCode8(i); i=i >> 8;
  4105                                  
  4106                                  ;Function : genCode16, Number of local variables: 1
  4107                                  ;   # type sign width line used address name   list of local variables
  4108                                  ;  200 var unsg word    28 NULL bp+4    i;
  4109 0000270F C8000000                 ENTER  0,0
  4110 00002713 FF7604                   push word [bp+4]
  4111 00002716 E89FFF                   call genCode8
  4112 00002719 83C402                   add  sp, 2
  4113 0000271C 8B4604                   mov ax, [bp+4]
  4114 0000271F C1E808                   shr ax, 8
  4115 00002722 894604                   mov word [bp+4], ax
  4116                                  
  4117                                  ;-30     genCode8(i);
  4118                                  
  4119 00002725 FF7604                   push word [bp+4]
  4120 00002728 E88DFF                   call genCode8
  4121 0000272B 83C402                   add  sp, 2
  4122                                  
  4123                                  ;-31 }
  4124                                  
  4125                                  
  4126                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  4127 0000272E C9                       LEAVE
  4128 0000272F C3                       ret
  4129                                  ; ENDP
  4130                                  
  4131                                  writeEA:  ; *** PROC ***
  4132                                  
  4133                                  ;-33 //need: Op, Op2, disp, R1No, RegNo, regindexbase, isDirect
  4134                                  
  4135                                  
  4136                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  4137                                  
  4138                                  
  4139                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  4140                                  
  4141                                  
  4142                                  ;-36     char len;
  4143                                  
  4144                                  
  4145                                  ;-37     len=0;   
  4146                                  
  4147                                  ;Function : writeEA, Number of local variables: 2
  4148                                  ;   # type sign width line used address name   list of local variables
  4149                                  ;  200 var sign byte    32 NULL bp+4    xxx
  4150                                  ;  201 var sign byte    36 NULL bp-2    len;
  4151 00002730 C8020000                 ENTER  2,0
  4152 00002734 66B800000000             mov eax, 0
  4153 0000273A 8846FE                   mov byte [bp-2], al
  4154                                  
  4155                                  ;-38 /*    prs("\n  EA x:"); printhex8a(xxx);       
  4156                                  
  4157                                  
  4158                                  ;-39     prs(", Op:"); printhex8a(Op);
  4159                                  
  4160                                  
  4161                                  ;-40     prs(", Op2:"); printhex8a(Op2);
  4162                                  
  4163                                  
  4164                                  ;-41     prs(", R1No:"); printhex8a(R1No);
  4165                                  
  4166                                  
  4167                                  ;-42     prs(", RegNo:"); printhex8a(RegNo);     */
  4168                                  
  4169                                  
  4170                                  ;-43            
  4171                                  
  4172                                  
  4173                                  ;-44     xxx = xxx << 3;//in reg/opcode field      
  4174                                  
  4175 0000273D 8A4604                   mov al, [bp+4]
  4176 00002740 C0E003                   shl al, 3
  4177 00002743 884604                   mov byte [bp+4], al
  4178                                  
  4179                                  ;-45 
  4180                                  
  4181                                  
  4182                                  ;-46     if (Op ==   0) addrerror();
  4183                                  
  4184 00002746 A0[AC01]                 mov al, [Op]
  4185 00002749 3C00                     cmp al, 0
  4186 0000274B 0F850300                 jne @@writeEA141
  4187 0000274F E82AFA                   call addrerror
  4188                                  
  4189                                  ;-47     if (Op == IMM) immeerror();   
  4190                                  
  4191                                  @@writeEA141:
  4192 00002752 A0[AC01]                 mov al, [Op]
  4193 00002755 3C01                     cmp al, 1
  4194 00002757 0F850300                 jne @@writeEA142
  4195 0000275B E838FA                   call immeerror
  4196                                  
  4197                                  ;-48     if (Op == ADR) invaloperror();           
  4198                                  
  4199                                  @@writeEA142:
  4200 0000275E A0[AC01]                 mov al, [Op]
  4201 00002761 3C03                     cmp al, 3
  4202 00002763 0F850300                 jne @@writeEA143
  4203 00002767 E88CFA                   call invaloperror
  4204                                  
  4205                                  ;-49 
  4206                                  
  4207                                  
  4208                                  ;-50     if (Op == REG) {
  4209                                  
  4210                                  @@writeEA143:
  4211 0000276A A0[AC01]                 mov al, [Op]
  4212 0000276D 3C02                     cmp al, 2
  4213 0000276F 0F853A00                 jne @@writeEA144
  4214                                  
  4215                                  ;-51         xxx |= 0xC0;     
  4216                                  
  4217 00002773 804E04C0                 or  byte [bp+4], 192
  4218                                  
  4219                                  ;-52         if (Op2 == 0) xxx = xxx + R1No;
  4220                                  
  4221 00002777 A0[AD01]                 mov al, [Op2]
  4222 0000277A 3C00                     cmp al, 0
  4223 0000277C 0F850D00                 jne @@writeEA145
  4224 00002780 8A4604                   mov al, [bp+4]
  4225 00002783 0206[B301]               add al, [R1No]
  4226 00002787 884604                   mov byte [bp+4], al
  4227                                  
  4228                                  ;-53             else {
  4229                                  
  4230 0000278A E92000                   jmp @@writeEA146
  4231                                  @@writeEA145:
  4232                                  
  4233                                  ;-54                 if (Op2 == REG) xxx = xxx + R1No;
  4234                                  
  4235 0000278D A0[AD01]                 mov al, [Op2]
  4236 00002790 3C02                     cmp al, 2
  4237 00002792 0F850D00                 jne @@writeEA147
  4238 00002796 8A4604                   mov al, [bp+4]
  4239 00002799 0206[B301]               add al, [R1No]
  4240 0000279D 884604                   mov byte [bp+4], al
  4241                                  
  4242                                  ;-55                 else            xxx = xxx + RegNo;  
  4243                                  
  4244 000027A0 E90A00                   jmp @@writeEA148
  4245                                  @@writeEA147:
  4246 000027A3 8A4604                   mov al, [bp+4]
  4247 000027A6 0206[B201]               add al, [RegNo]
  4248 000027AA 884604                   mov byte [bp+4], al
  4249                                  
  4250                                  ;-56             }
  4251                                  
  4252                                  @@writeEA148:
  4253                                  
  4254                                  ;-57         } 
  4255                                  
  4256                                  @@writeEA146:
  4257                                  
  4258                                  ;-58     if (Op == MEM) {
  4259                                  
  4260                                  @@writeEA144:
  4261 000027AD A0[AC01]                 mov al, [Op]
  4262 000027B0 3C04                     cmp al, 4
  4263 000027B2 0F857F00                 jne @@writeEA149
  4264                                  
  4265                                  ;-59         if (isDirect) {
  4266                                  
  4267 000027B6 A0[BA01]                 mov al, [isDirect]
  4268 000027B9 08C0                     or  al, al
  4269 000027BB 0F841000                 je @@writeEA150
  4270                                  
  4271                                  ;-60             xxx |= 6;
  4272                                  
  4273 000027BF 804E0406                 or  byte [bp+4], 6
  4274                                  
  4275                                  ;-61             len = 2;
  4276                                  
  4277 000027C3 66B802000000             mov eax, 2
  4278 000027C9 8846FE                   mov byte [bp-2], al
  4279                                  
  4280                                  ;-62         }
  4281                                  
  4282                                  
  4283                                  ;-63         else { 
  4284                                  
  4285 000027CC E96600                   jmp @@writeEA151
  4286                                  @@writeEA150:
  4287                                  
  4288                                  ;-64             xxx = xxx + regindexbase;   
  4289                                  
  4290 000027CF 8A4604                   mov al, [bp+4]
  4291 000027D2 0206[B901]               add al, [regindexbase]
  4292 000027D6 884604                   mov byte [bp+4], al
  4293                                  
  4294                                  ;-65             if (regindexbase == 6) {//make [BP+00]
  4295                                  
  4296 000027D9 A0[B901]                 mov al, [regindexbase]
  4297 000027DC 3C06                     cmp al, 6
  4298 000027DE 0F851700                 jne @@writeEA152
  4299                                  
  4300                                  ;-66                 len=1;
  4301                                  
  4302 000027E2 66B801000000             mov eax, 1
  4303 000027E8 8846FE                   mov byte [bp-2], al
  4304                                  
  4305                                  ;-67                 if (disp == 0) xxx |= 0x40;
  4306                                  
  4307 000027EB A1[BB01]                 mov ax, [disp]
  4308 000027EE 83F800                   cmp ax, 0
  4309 000027F1 0F850400                 jne @@writeEA153
  4310 000027F5 804E0440                 or  byte [bp+4], 64
  4311                                  
  4312                                  ;-68             }
  4313                                  
  4314                                  @@writeEA153:
  4315                                  
  4316                                  ;-69 
  4317                                  
  4318                                  
  4319                                  ;-70             if (disp) {
  4320                                  
  4321                                  @@writeEA152:
  4322 000027F9 A1[BB01]                 mov ax, [disp]
  4323 000027FC 08C0                     or  al, al
  4324 000027FE 0F843300                 je @@writeEA154
  4325                                  
  4326                                  ;-71                 ax = disp;
  4327                                  
  4328 00002802 A1[BB01]                 mov  ax, [disp]
  4329                                  
  4330                                  ;-72                 if(ax > 127) len=2;
  4331                                  
  4332 00002805 83F87F                   cmp  ax, 127
  4333 00002808 0F8E0C00                 jle @@writeEA155
  4334 0000280C 66B802000000             mov eax, 2
  4335 00002812 8846FE                   mov byte [bp-2], al
  4336                                  
  4337                                  ;-73                 else len=1;
  4338                                  
  4339 00002815 E90900                   jmp @@writeEA156
  4340                                  @@writeEA155:
  4341 00002818 66B801000000             mov eax, 1
  4342 0000281E 8846FE                   mov byte [bp-2], al
  4343                                  
  4344                                  ;-74                 if (len == 1) xxx |= 0x40;
  4345                                  
  4346                                  @@writeEA156:
  4347 00002821 8A46FE                   mov al, [bp-2]
  4348 00002824 3C01                     cmp al, 1
  4349 00002826 0F850700                 jne @@writeEA157
  4350 0000282A 804E0440                 or  byte [bp+4], 64
  4351                                  
  4352                                  ;-75                 else xxx |= 0x80;
  4353                                  
  4354 0000282E E90400                   jmp @@writeEA158
  4355                                  @@writeEA157:
  4356 00002831 804E0480                 or  byte [bp+4], 128
  4357                                  
  4358                                  ;-76             }
  4359                                  
  4360                                  @@writeEA158:
  4361                                  
  4362                                  ;-77         }
  4363                                  
  4364                                  @@writeEA154:
  4365                                  
  4366                                  ;-78     }  
  4367                                  
  4368                                  @@writeEA151:
  4369                                  
  4370                                  ;-79     
  4371                                  
  4372                                  
  4373                                  ;-80     genCode8(xxx);// gen second byte
  4374                                  
  4375                                  @@writeEA149:
  4376 00002835 8A4604                   mov al, byte [bp+4]
  4377 00002838 B400                     mov ah, 0
  4378 0000283A 50                       push ax
  4379 0000283B E87AFE                   call genCode8
  4380 0000283E 83C402                   add  sp, 2
  4381                                  
  4382                                  ;-81     if (len == 1) genCode8 (disp);
  4383                                  
  4384 00002841 8A46FE                   mov al, [bp-2]
  4385 00002844 3C01                     cmp al, 1
  4386 00002846 0F850A00                 jne @@writeEA159
  4387 0000284A FF36[BB01]               push word [disp]
  4388 0000284E E867FE                   call genCode8
  4389 00002851 83C402                   add  sp, 2
  4390                                  
  4391                                  ;-82     if (len == 2) genCode16(disp);
  4392                                  
  4393                                  @@writeEA159:
  4394 00002854 8A46FE                   mov al, [bp-2]
  4395 00002857 3C02                     cmp al, 2
  4396 00002859 0F850A00                 jne @@writeEA160
  4397 0000285D FF36[BB01]               push word [disp]
  4398 00002861 E8ABFE                   call genCode16
  4399 00002864 83C402                   add  sp, 2
  4400                                  
  4401                                  ;-83 }
  4402                                  
  4403                                  @@writeEA160:
  4404                                  
  4405                                  ;-84 
  4406                                  
  4407                                  
  4408                                  ;-85 int genImmediate() {
  4409 00002867 C9                       LEAVE
  4410 00002868 C3                       ret
  4411                                  ; ENDP
  4412                                  
  4413                                  genImmediate:  ; *** PROC ***
  4414                                  
  4415                                  ;-86     if (sflag) {
  4416                                  
  4417 00002869 A0[B801]                 mov al, [sflag]
  4418 0000286C 08C0                     or  al, al
  4419 0000286E 0F840D00                 je @@genImmediate161
  4420                                  
  4421                                  ;-87         genCode8(imme);
  4422                                  
  4423 00002872 FF36[BD01]               push word [imme]
  4424 00002876 E83FFE                   call genCode8
  4425 00002879 83C402                   add  sp, 2
  4426                                  
  4427                                  ;-88         return;
  4428                                  
  4429 0000287C E92000                   jmp @@retn
  4430                                  
  4431                                  ;-89     }
  4432                                  
  4433                                  
  4434                                  ;-90     if (wflag) genCode16(imme);
  4435                                  
  4436                                  @@genImmediate161:
  4437 0000287F A0[B701]                 mov al, [wflag]
  4438 00002882 08C0                     or  al, al
  4439 00002884 0F840D00                 je @@genImmediate162
  4440 00002888 FF36[BD01]               push word [imme]
  4441 0000288C E880FE                   call genCode16
  4442 0000288F 83C402                   add  sp, 2
  4443                                  
  4444                                  ;-91     else       genCode8 (imme);  
  4445                                  
  4446 00002892 E90A00                   jmp @@genImmediate163
  4447                                  @@genImmediate162:
  4448 00002895 FF36[BD01]               push word [imme]
  4449 00002899 E81CFE                   call genCode8
  4450 0000289C 83C402                   add  sp, 2
  4451                                  
  4452                                  ;-92     }    
  4453                                  
  4454                                  @@genImmediate163:
  4455                                  @@retn:
  4456 0000289F C3                       ret
  4457                                  ; ENDP
  4458                                  ;Back to main program: AS.C
  4459                                  
  4460                                  ;-10 
  4461                                  
  4462                                  
  4463                                  ;-11 int process() { 
  4464                                  
  4465                                  
  4466                                  process:  ; *** PROC ***
  4467                                  
  4468                                  ;-12     char c;
  4469                                  
  4470                                  
  4471                                  ;-13     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4472                                  
  4473                                  ;Function : process, Number of local variables: 1
  4474                                  ;   # type sign width line used address name   list of local variables
  4475                                  ;  200 var sign byte    12 NULL bp-2    c;
  4476 000028A0 C8020000                 ENTER  2,0
  4477 000028A4 E831EA                   call getTokeType
  4478                                  
  4479                                  ;-14     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4480                                  
  4481 000028A7 E881ED                   call getCodeSize
  4482 000028AA A2[B601]                 mov byte [OpSize], al
  4483                                  
  4484                                  ;-15     getCodes();//set: Code1, Code2, Code3
  4485                                  
  4486 000028AD E89AFD                   call getCodes
  4487                                  
  4488                                  ;-16 
  4489                                  
  4490                                  
  4491                                  ;-17     if (CodeType ==  1) {//1 byte opcode
  4492                                  
  4493 000028B0 A0[AE01]                 mov al, [CodeType]
  4494 000028B3 3C01                     cmp al, 1
  4495 000028B5 0F850F00                 jne @@process164
  4496                                  
  4497                                  ;-18         genCode8(Code1);
  4498                                  
  4499 000028B9 A0[AF01]                 mov al, byte [Code1]
  4500 000028BC B400                     mov ah, 0
  4501 000028BE 50                       push ax
  4502 000028BF E8F6FD                   call genCode8
  4503 000028C2 83C402                   add  sp, 2
  4504                                  
  4505                                  ;-19         return;
  4506                                  
  4507 000028C5 E94102                   jmp @@retn
  4508                                  
  4509                                  ;-20     }
  4510                                  
  4511                                  
  4512                                  ;-21   
  4513                                  
  4514                                  
  4515                                  ;-22     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4516                                  
  4517                                  @@process164:
  4518 000028C8 A0[AE01]                 mov al, [CodeType]
  4519 000028CB 3C02                     cmp al, 2
  4520 000028CD 0F858700                 jne @@process165
  4521                                  
  4522                                  ;-23         getOpL();
  4523                                  
  4524 000028D1 E81D03                   call getOpL
  4525                                  
  4526                                  ;-24         checkOpL();        
  4527                                  
  4528 000028D4 E85802                   call checkOpL
  4529                                  
  4530                                  ;-25         if (Code2 <= 1) {//inc,dec
  4531                                  
  4532 000028D7 A0[B001]                 mov al, [Code2]
  4533 000028DA 3C01                     cmp al, 1
  4534 000028DC 0F8F4500                 jg  @@process166
  4535                                  
  4536                                  ;-26   	        if (Op == REG) {//short
  4537                                  
  4538 000028E0 A0[AC01]                 mov al, [Op]
  4539 000028E3 3C02                     cmp al, 2
  4540 000028E5 0F853C00                 jne @@process167
  4541                                  
  4542                                  ;-27                 if (R1Type == WORD) {genCode(Code3, RegNo); return; }
  4543                                  
  4544 000028E9 A0[B501]                 mov al, [R1Type]
  4545 000028EC 3C02                     cmp al, 2
  4546 000028EE 0F851500                 jne @@process168
  4547 000028F2 A0[B201]                 mov al, byte [RegNo]
  4548 000028F5 B400                     mov ah, 0
  4549 000028F7 50                       push ax
  4550 000028F8 A0[B101]                 mov al, byte [Code3]
  4551 000028FB B400                     mov ah, 0
  4552 000028FD 50                       push ax
  4553 000028FE E880FD                   call genCode
  4554 00002901 83C404                   add  sp, 4
  4555 00002904 E90202                   jmp @@retn
  4556                                  
  4557                                  ;-28                 if (R1Type ==DWORD) {genCode(Code3, RegNo); return; }
  4558                                  
  4559                                  @@process168:
  4560 00002907 A0[B501]                 mov al, [R1Type]
  4561 0000290A 3C03                     cmp al, 3
  4562 0000290C 0F851500                 jne @@process169
  4563 00002910 A0[B201]                 mov al, byte [RegNo]
  4564 00002913 B400                     mov ah, 0
  4565 00002915 50                       push ax
  4566 00002916 A0[B101]                 mov al, byte [Code3]
  4567 00002919 B400                     mov ah, 0
  4568 0000291B 50                       push ax
  4569 0000291C E862FD                   call genCode
  4570 0000291F 83C404                   add  sp, 4
  4571 00002922 E9E401                   jmp @@retn
  4572                                  
  4573                                  ;-29             }
  4574                                  
  4575                                  @@process169:
  4576                                  
  4577                                  ;-30         }
  4578                                  
  4579                                  @@process167:
  4580                                  
  4581                                  ;-31         if (Code2 == 5) {//imul extension?
  4582                                  
  4583                                  @@process166:
  4584 00002925 A0[B001]                 mov al, [Code2]
  4585 00002928 3C05                     cmp al, 5
  4586 0000292A 0F850F00                 jne @@process170
  4587                                  
  4588                                  ;-32             getTokeType();
  4589                                  
  4590 0000292E E8A7E9                   call getTokeType
  4591                                  
  4592                                  ;-33             if (TokeType) implerror();
  4593                                  
  4594 00002931 A0[AB01]                 mov al, [TokeType]
  4595 00002934 08C0                     or  al, al
  4596 00002936 0F840300                 je @@process171
  4597 0000293A E87EF8                   call implerror
  4598                                  
  4599                                  ;-34         }
  4600                                  
  4601                                  @@process171:
  4602                                  
  4603                                  ;-35         genCodeW(Code1);   
  4604                                  
  4605                                  @@process170:
  4606 0000293D A0[AF01]                 mov al, byte [Code1]
  4607 00002940 B400                     mov ah, 0
  4608 00002942 50                       push ax
  4609 00002943 E856FD                   call genCodeW
  4610 00002946 83C402                   add  sp, 2
  4611                                  
  4612                                  ;-36         
  4613                                  
  4614                                  
  4615                                  ;-37         writeEA(Code2);
  4616                                  
  4617 00002949 A0[B001]                 mov al, byte [Code2]
  4618 0000294C B400                     mov ah, 0
  4619 0000294E 50                       push ax
  4620 0000294F E8DEFD                   call writeEA
  4621 00002952 83C402                   add  sp, 2
  4622                                  
  4623                                  ;-38         return;
  4624                                  
  4625 00002955 E9B101                   jmp @@retn
  4626                                  
  4627                                  ;-39     }
  4628                                  
  4629                                  
  4630                                  ;-40   
  4631                                  
  4632                                  
  4633                                  ;-41     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4634                                  
  4635                                  @@process165:
  4636 00002958 A0[AE01]                 mov al, [CodeType]
  4637 0000295B 3C03                     cmp al, 3
  4638 0000295D 0F855C00                 jne @@process172
  4639                                  
  4640                                  ;-42         getOpL();       //setwflag not applicable
  4641                                  
  4642 00002961 E88D02                   call getOpL
  4643                                  
  4644                                  ;-43         if (R1Type != WORD) reg16error();//only r16
  4645                                  
  4646 00002964 A0[B501]                 mov al, [R1Type]
  4647 00002967 3C02                     cmp al, 2
  4648 00002969 0F840300                 je  @@process173
  4649 0000296D E8EBF8                   call reg16error
  4650                                  
  4651                                  ;-44         need(',');   
  4652                                  
  4653                                  @@process173:
  4654 00002970 6A2C                     push 44
  4655 00002972 E867ED                   call need
  4656 00002975 83C402                   add  sp, 2
  4657                                  
  4658                                  ;-45         getOpR();
  4659                                  
  4660 00002978 E8C202                   call getOpR
  4661                                  
  4662                                  ;-46         if (Op2 != MEM) addrerror();//only m16 
  4663                                  
  4664 0000297B A0[AD01]                 mov al, [Op2]
  4665 0000297E 3C04                     cmp al, 4
  4666 00002980 0F840300                 je  @@process174
  4667 00002984 E8F5F7                   call addrerror
  4668                                  
  4669                                  ;-47         
  4670                                  
  4671                                  
  4672                                  ;-48         genCode8(Code1);//les,lds,lea
  4673                                  
  4674                                  @@process174:
  4675 00002987 A0[AF01]                 mov al, byte [Code1]
  4676 0000298A B400                     mov ah, 0
  4677 0000298C 50                       push ax
  4678 0000298D E828FD                   call genCode8
  4679 00002990 83C402                   add  sp, 2
  4680                                  
  4681                                  ;-49         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  4682                                  
  4683 00002993 A0[AF01]                 mov al, [Code1]
  4684 00002996 3C0F                     cmp al, 15
  4685 00002998 0F850C00                 jne @@process175
  4686 0000299C A0[B001]                 mov al, byte [Code2]
  4687 0000299F B400                     mov ah, 0
  4688 000029A1 50                       push ax
  4689 000029A2 E813FD                   call genCode8
  4690 000029A5 83C402                   add  sp, 2
  4691                                  
  4692                                  ;-50         Op=Op2;//set MEM for writeEA
  4693                                  
  4694                                  @@process175:
  4695 000029A8 A0[AD01]                 mov al, [Op2]
  4696 000029AB A2[AC01]                 mov byte [Op], al
  4697                                  
  4698                                  ;-51         writeEA(R1No);           
  4699                                  
  4700 000029AE A0[B301]                 mov al, byte [R1No]
  4701 000029B1 B400                     mov ah, 0
  4702 000029B3 50                       push ax
  4703 000029B4 E879FD                   call writeEA
  4704 000029B7 83C402                   add  sp, 2
  4705                                  
  4706                                  ;-52         return;
  4707                                  
  4708 000029BA E94C01                   jmp @@retn
  4709                                  
  4710                                  ;-53     }
  4711                                  
  4712                                  
  4713                                  ;-54 
  4714                                  
  4715                                  
  4716                                  ;-55     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  4717                                  
  4718                                  @@process172:
  4719 000029BD A0[AE01]                 mov al, [CodeType]
  4720 000029C0 3C04                     cmp al, 4
  4721 000029C2 0F85DC00                 jne @@process176
  4722                                  
  4723                                  ;-56         get2Ops();    
  4724                                  
  4725 000029C6 E81902                   call get2Ops
  4726                                  
  4727                                  ;-57         setwflag();     
  4728                                  
  4729 000029C9 E84C05                   call setwflag
  4730                                  
  4731                                  ;-58         if (Op2 == IMM) {//second operand is imm     
  4732                                  
  4733 000029CC A0[AD01]                 mov al, [Op2]
  4734 000029CF 3C01                     cmp al, 1
  4735 000029D1 0F856300                 jne @@process177
  4736                                  
  4737                                  ;-59             setsflag();   
  4738                                  
  4739 000029D5 E8BC05                   call setsflag
  4740                                  
  4741                                  ;-60             if (Op == REG) {                
  4742                                  
  4743 000029D8 A0[AC01]                 mov al, [Op]
  4744 000029DB 3C02                     cmp al, 2
  4745 000029DD 0F853100                 jne @@process178
  4746                                  
  4747                                  ;-61                 if (R1No == 0) {  
  4748                                  
  4749 000029E1 A0[B301]                 mov al, [R1No]
  4750 000029E4 3C00                     cmp al, 0
  4751 000029E6 0F852800                 jne @@process179
  4752                                  
  4753                                  ;-62                     if (sflag == 0) {                        
  4754                                  
  4755 000029EA A0[B801]                 mov al, [sflag]
  4756 000029ED 3C00                     cmp al, 0
  4757 000029EF 0F851F00                 jne @@process180
  4758                                  
  4759                                  ;-63                         c = Code1 << 3;
  4760                                  
  4761 000029F3 A0[AF01]                 mov al, [Code1]
  4762 000029F6 C0E003                   shl al, 3
  4763 000029F9 8846FE                   mov byte [bp-2], al
  4764                                  
  4765                                  ;-64                         c += 4;//code for acc,imm     
  4766                                  
  4767 000029FC 8046FE04                 add  byte [bp-2], 4
  4768                                  
  4769                                  ;-65                         genCodeW(c);
  4770                                  
  4771 00002A00 8A46FE                   mov al, byte [bp-2]
  4772 00002A03 B400                     mov ah, 0
  4773 00002A05 50                       push ax
  4774 00002A06 E893FC                   call genCodeW
  4775 00002A09 83C402                   add  sp, 2
  4776                                  
  4777                                  ;-66                         genImmediate();
  4778                                  
  4779 00002A0C E85AFE                   call genImmediate
  4780                                  
  4781                                  ;-67                         return;
  4782                                  
  4783 00002A0F E9F700                   jmp @@retn
  4784                                  
  4785                                  ;-68                     }
  4786                                  
  4787                                  
  4788                                  ;-69                 }
  4789                                  
  4790                                  @@process180:
  4791                                  
  4792                                  ;-70             }
  4793                                  
  4794                                  @@process179:
  4795                                  
  4796                                  ;-71             //r/m, imm: 80 sign-extended,TTT,imm
  4797                                  
  4798                                  
  4799                                  ;-72             c = sflag + 0x80;       
  4800                                  
  4801                                  @@process178:
  4802 00002A12 A0[B801]                 mov al, [sflag]
  4803 00002A15 0480                     add al, 128
  4804 00002A17 8846FE                   mov byte [bp-2], al
  4805                                  
  4806                                  ;-73             genCodeW(c); 
  4807                                  
  4808 00002A1A 8A46FE                   mov al, byte [bp-2]
  4809 00002A1D B400                     mov ah, 0
  4810 00002A1F 50                       push ax
  4811 00002A20 E879FC                   call genCodeW
  4812 00002A23 83C402                   add  sp, 2
  4813                                  
  4814                                  ;-74             writeEA(Code1);  
  4815                                  
  4816 00002A26 A0[AF01]                 mov al, byte [Code1]
  4817 00002A29 B400                     mov ah, 0
  4818 00002A2B 50                       push ax
  4819 00002A2C E801FD                   call writeEA
  4820 00002A2F 83C402                   add  sp, 2
  4821                                  
  4822                                  ;-75             genImmediate();
  4823                                  
  4824 00002A32 E834FE                   call genImmediate
  4825                                  
  4826                                  ;-76             return;     
  4827                                  
  4828 00002A35 E9D100                   jmp @@retn
  4829                                  
  4830                                  ;-77         }  
  4831                                  
  4832                                  
  4833                                  ;-78        
  4834                                  
  4835                                  
  4836                                  ;-79         c = Code1 << 3;//r/m, r/m  
  4837                                  
  4838                                  @@process177:
  4839 00002A38 A0[AF01]                 mov al, [Code1]
  4840 00002A3B C0E003                   shl al, 3
  4841 00002A3E 8846FE                   mov byte [bp-2], al
  4842                                  
  4843                                  ;-80         if (Op == REG) {
  4844                                  
  4845 00002A41 A0[AC01]                 mov al, [Op]
  4846 00002A44 3C02                     cmp al, 2
  4847 00002A46 0F852E00                 jne @@process181
  4848                                  
  4849                                  ;-81             if (Op2 == MEM) {//reg, mem      
  4850                                  
  4851 00002A4A A0[AD01]                 mov al, [Op2]
  4852 00002A4D 3C04                     cmp al, 4
  4853 00002A4F 0F852500                 jne @@process182
  4854                                  
  4855                                  ;-82                 c += 2;//add direction flag
  4856                                  
  4857 00002A53 8046FE02                 add  byte [bp-2], 2
  4858                                  
  4859                                  ;-83                 genCodeW(c);
  4860                                  
  4861 00002A57 8A46FE                   mov al, byte [bp-2]
  4862 00002A5A B400                     mov ah, 0
  4863 00002A5C 50                       push ax
  4864 00002A5D E83CFC                   call genCodeW
  4865 00002A60 83C402                   add  sp, 2
  4866                                  
  4867                                  ;-84                 Op=Op2;//set MEM for writeEA                
  4868                                  
  4869 00002A63 A0[AD01]                 mov al, [Op2]
  4870 00002A66 A2[AC01]                 mov byte [Op], al
  4871                                  
  4872                                  ;-85                 writeEA(R1No);
  4873                                  
  4874 00002A69 A0[B301]                 mov al, byte [R1No]
  4875 00002A6C B400                     mov ah, 0
  4876 00002A6E 50                       push ax
  4877 00002A6F E8BEFC                   call writeEA
  4878 00002A72 83C402                   add  sp, 2
  4879                                  
  4880                                  ;-86                 return;    
  4881                                  
  4882 00002A75 E99100                   jmp @@retn
  4883                                  
  4884                                  ;-87             }
  4885                                  
  4886                                  
  4887                                  ;-88         }
  4888                                  
  4889                                  @@process182:
  4890                                  
  4891                                  ;-89         if (Op2 == REG) {//mem,reg    reg,reg
  4892                                  
  4893                                  @@process181:
  4894 00002A78 A0[AD01]                 mov al, [Op2]
  4895 00002A7B 3C02                     cmp al, 2
  4896 00002A7D 0F851B00                 jne @@process183
  4897                                  
  4898                                  ;-90             genCodeW(c);
  4899                                  
  4900 00002A81 8A46FE                   mov al, byte [bp-2]
  4901 00002A84 B400                     mov ah, 0
  4902 00002A86 50                       push ax
  4903 00002A87 E812FC                   call genCodeW
  4904 00002A8A 83C402                   add  sp, 2
  4905                                  
  4906                                  ;-91             writeEA(RegNo);//2. Op in reg-field
  4907                                  
  4908 00002A8D A0[B201]                 mov al, byte [RegNo]
  4909 00002A90 B400                     mov ah, 0
  4910 00002A92 50                       push ax
  4911 00002A93 E89AFC                   call writeEA
  4912 00002A96 83C402                   add  sp, 2
  4913                                  
  4914                                  ;-92             return;            
  4915                                  
  4916 00002A99 E96D00                   jmp @@retn
  4917                                  
  4918                                  ;-93         }          
  4919                                  
  4920                                  
  4921                                  ;-94         
  4922                                  
  4923                                  
  4924                                  ;-95         syntaxerror();        
  4925                                  
  4926                                  @@process183:
  4927 00002A9C E80BF8                   call syntaxerror
  4928                                  
  4929                                  ;-96         return;
  4930                                  
  4931 00002A9F E96700                   jmp @@retn
  4932                                  
  4933                                  ;-97     }
  4934                                  
  4935                                  
  4936                                  ;-98    
  4937                                  
  4938                                  
  4939                                  ;-99     if (CodeType ==  8) {//ret,retf
  4940                                  
  4941                                  @@process176:
  4942 00002AA2 A0[AE01]                 mov al, [CodeType]
  4943 00002AA5 3C08                     cmp al, 8
  4944 00002AA7 0F853100                 jne @@process184
  4945                                  
  4946                                  ;-100         if (TokeType == DIGIT) {
  4947                                  
  4948 00002AAB A0[AB01]                 mov al, [TokeType]
  4949 00002AAE 3C01                     cmp al, 1
  4950 00002AB0 0F851900                 jne @@process185
  4951                                  
  4952                                  ;-101             genCode8(Code2);
  4953                                  
  4954 00002AB4 A0[B001]                 mov al, byte [Code2]
  4955 00002AB7 B400                     mov ah, 0
  4956 00002AB9 50                       push ax
  4957 00002ABA E8FBFB                   call genCode8
  4958 00002ABD 83C402                   add  sp, 2
  4959                                  
  4960                                  ;-102             genCode16(SymbolInt);
  4961                                  
  4962 00002AC0 FF36[4D00]               push word [SymbolInt]
  4963 00002AC4 E848FC                   call genCode16
  4964 00002AC7 83C402                   add  sp, 2
  4965                                  
  4966                                  ;-103             return;
  4967                                  
  4968 00002ACA E93C00                   jmp @@retn
  4969                                  
  4970                                  ;-104         }
  4971                                  
  4972                                  
  4973                                  ;-105         genCode8(Code1); 
  4974                                  
  4975                                  @@process185:
  4976 00002ACD A0[AF01]                 mov al, byte [Code1]
  4977 00002AD0 B400                     mov ah, 0
  4978 00002AD2 50                       push ax
  4979 00002AD3 E8E2FB                   call genCode8
  4980 00002AD6 83C402                   add  sp, 2
  4981                                  
  4982                                  ;-106         return;
  4983                                  
  4984 00002AD9 E92D00                   jmp @@retn
  4985                                  
  4986                                  ;-107     }
  4987                                  
  4988                                  
  4989                                  ;-108 
  4990                                  
  4991                                  
  4992                                  ;-109     if (CodeType==101) {// ORG nn
  4993                                  
  4994                                  @@process184:
  4995 00002ADC A0[AE01]                 mov al, [CodeType]
  4996 00002ADF 3C65                     cmp al, 101
  4997 00002AE1 0F851B00                 jne @@process186
  4998                                  
  4999                                  ;-110         if (TokeType != DIGIT) error1("only digit allowed");
  5000                                  
  5001 00002AE5 A0[AB01]                 mov al, [TokeType]
  5002 00002AE8 3C01                     cmp al, 1
  5003 00002AEA 0F840900                 je  @@process187
  5004 00002AEE 68[0B2B]                 push process_0
  5005 00002AF1 E80EF6                   call error1
  5006 00002AF4 83C402                   add  sp, 2
  5007                                  
  5008                                  ;-111         PC=SymbolInt;
  5009                                  
  5010                                  @@process187:
  5011 00002AF7 A1[4D00]                 mov ax, [SymbolInt]
  5012 00002AFA A3[A601]                 mov word [PC], ax
  5013                                  
  5014                                  ;-112         return;
  5015                                  
  5016 00002AFD E90900                   jmp @@retn
  5017                                  
  5018                                  ;-113     }
  5019                                  
  5020                                  
  5021                                  ;-114     error1("unknown CodeType");
  5022                                  
  5023                                  @@process186:
  5024 00002B00 68[1E2B]                 push process_1
  5025 00002B03 E8FCF5                   call error1
  5026 00002B06 83C402                   add  sp, 2
  5027                                  
  5028                                  ;-115 }    
  5029                                  
  5030                                  
  5031                                  ;-116 
  5032                                  
  5033                                  
  5034                                  ;-117 int checkOpL() {
  5035                                  
  5036 00002B09 C9                      @@retn: LEAVE
  5037 00002B0A C3                       ret
  5038                                  ; ENDP
  5039 00002B0B 6F6E6C792064696769-     process_0 db "only digit allowed",0
  5040 00002B14 7420616C6C6F776564-
  5041 00002B1D 00                 
  5042 00002B1E 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  5043 00002B27 6F64655479706500   
  5044                                  
  5045                                  checkOpL:  ; *** PROC ***
  5046                                  
  5047                                  ;-118     if (Op == ADR) implerror();
  5048                                  
  5049 00002B2F A0[AC01]                 mov al, [Op]
  5050 00002B32 3C03                     cmp al, 3
  5051 00002B34 0F850300                 jne @@checkOpL188
  5052 00002B38 E880F6                   call implerror
  5053                                  
  5054                                  ;-119     if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  5055                                  
  5056                                  @@checkOpL188:
  5057 00002B3B A0[B401]                 mov al, [RegType]
  5058 00002B3E 3C04                     cmp al, 4
  5059 00002B40 0F850600                 jne @@checkOpL189
  5060 00002B44 E83CF7                   call segregerror
  5061 00002B47 E95300                   jmp @@retn
  5062                                  
  5063                                  ;-120     setwflag();
  5064                                  
  5065                                  @@checkOpL189:
  5066 00002B4A E8CB03                   call setwflag
  5067                                  
  5068                                  ;-121     if (OpSize == 0) error1("no op size declared");
  5069                                  
  5070 00002B4D A0[B601]                 mov al, [OpSize]
  5071 00002B50 3C00                     cmp al, 0
  5072 00002B52 0F850900                 jne @@checkOpL190
  5073 00002B56 68[9E2B]                 push checkOpL_0
  5074 00002B59 E8A6F5                   call error1
  5075 00002B5C 83C402                   add  sp, 2
  5076                                  
  5077                                  ;-122     if (OpSize == R1Type) return;
  5078                                  
  5079                                  @@checkOpL190:
  5080 00002B5F A0[B601]                 mov al, [OpSize]
  5081 00002B62 3A06[B501]               cmp al, [R1Type]
  5082 00002B66 0F850300                 jne @@checkOpL191
  5083 00002B6A E93000                   jmp @@retn
  5084                                  
  5085                                  ;-123     if (OpSize){
  5086                                  
  5087                                  @@checkOpL191:
  5088 00002B6D A0[B601]                 mov al, [OpSize]
  5089 00002B70 08C0                     or  al, al
  5090 00002B72 0F841500                 je @@checkOpL192
  5091                                  
  5092                                  ;-124         if (Op == MEM) return;
  5093                                  
  5094 00002B76 A0[AC01]                 mov al, [Op]
  5095 00002B79 3C04                     cmp al, 4
  5096 00002B7B 0F850300                 jne @@checkOpL193
  5097 00002B7F E91B00                   jmp @@retn
  5098                                  
  5099                                  ;-125         error1("Conflict OpSize and RegSize"); 
  5100                                  
  5101                                  @@checkOpL193:
  5102 00002B82 68[B22B]                 push checkOpL_1
  5103 00002B85 E87AF5                   call error1
  5104 00002B88 83C402                   add  sp, 2
  5105                                  
  5106                                  ;-126         }
  5107                                  
  5108                                  
  5109                                  ;-127     if (R1Type==0) error1("no register defined");
  5110                                  
  5111                                  @@checkOpL192:
  5112 00002B8B A0[B501]                 mov al, [R1Type]
  5113 00002B8E 3C00                     cmp al, 0
  5114 00002B90 0F850900                 jne @@checkOpL194
  5115 00002B94 68[CE2B]                 push checkOpL_2
  5116 00002B97 E868F5                   call error1
  5117 00002B9A 83C402                   add  sp, 2
  5118                                  
  5119                                  ;-128 }
  5120                                  
  5121                                  @@checkOpL194:
  5122                                  
  5123                                  ;-129 /*    Op, Op2 =0, 1=IMM, 2=REG, 3=ADR, 4=MEM 
  5124                                  
  5125                                  
  5126                                  ;-130 IMM      imme           = 0, SymbolInt
  5127                                  
  5128                                  
  5129                                  ;-131 REG      R1No,RegNo     = 0 - 7
  5130                                  
  5131                                  
  5132                                  ;-132 REG      R1Type,RegType = 0, BYTE, WORD, DWORD, SEGREG 
  5133                                  
  5134                                  
  5135                                  ;-133 MEM,ADR  disp           = 0, LabelAddr[LabelIx]
  5136                                  
  5137                                  
  5138                                  ;-134 MEM      regindexbase   = 0 - 7
  5139                                  
  5140                                  
  5141                                  ;-135          OpSize         = 0, BYTE, WORD, DWORD
  5142                                  
  5143                                  
  5144                                  ;-136          wflag          */         
  5145                                  
  5146                                  
  5147                                  ;-137 int get2Ops() {
  5148                                  
  5149                                  @@retn:
  5150 00002B9D C3                       ret
  5151                                  ; ENDP
  5152 00002B9E 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  5153 00002BA7 65206465636C617265-
  5154 00002BB0 6400               
  5155 00002BB2 436F6E666C69637420-     checkOpL_1 db "Conflict OpSize and RegSize",0
  5156 00002BBB 4F7053697A6520616E-
  5157 00002BC4 642052656753697A65-
  5158 00002BCD 00                 
  5159 00002BCE 6E6F20726567697374-     checkOpL_2 db "no register defined",0
  5160 00002BD7 657220646566696E65-
  5161 00002BE0 6400               
  5162                                  
  5163                                  get2Ops:  ; *** PROC ***
  5164                                  
  5165                                  ;-138     getOpL();
  5166                                  
  5167 00002BE2 E80C00                   call getOpL
  5168                                  
  5169                                  ;-139     need(',');    
  5170                                  
  5171 00002BE5 6A2C                     push 44
  5172 00002BE7 E8F2EA                   call need
  5173 00002BEA 83C402                   add  sp, 2
  5174                                  
  5175                                  ;-140     getOpR();         
  5176                                  
  5177 00002BED E84D00                   call getOpR
  5178                                  
  5179                                  ;-141 }         
  5180                                  
  5181                                  
  5182                                  ;-142 int getOpL() {
  5183                                  
  5184 00002BF0 C3                       ret
  5185                                  ; ENDP
  5186                                  
  5187                                  getOpL:  ; *** PROC ***
  5188                                  
  5189                                  ;-143 //set: op=0,IMM,REG,ADR,MEM
  5190                                  
  5191                                  
  5192                                  ;-144     disp=0; imme=0; isDirect=1; 
  5193                                  
  5194 00002BF1 66B800000000             mov eax, 0
  5195 00002BF7 A3[BB01]                 mov word [disp], ax
  5196 00002BFA 66B800000000             mov eax, 0
  5197 00002C00 A3[BD01]                 mov word [imme], ax
  5198 00002C03 66B801000000             mov eax, 1
  5199 00002C09 A2[BA01]                 mov byte [isDirect], al
  5200                                  
  5201                                  ;-145     getOpR();
  5202                                  
  5203 00002C0C E82E00                   call getOpR
  5204                                  
  5205                                  ;-146     Op=Op2;         Op2=0;
  5206                                  
  5207 00002C0F A0[AD01]                 mov al, [Op2]
  5208 00002C12 A2[AC01]                 mov byte [Op], al
  5209 00002C15 66B800000000             mov eax, 0
  5210 00002C1B A2[AD01]                 mov byte [Op2], al
  5211                                  
  5212                                  ;-147     R1No=RegNo;     RegNo=0;
  5213                                  
  5214 00002C1E A0[B201]                 mov al, [RegNo]
  5215 00002C21 A2[B301]                 mov byte [R1No], al
  5216 00002C24 66B800000000             mov eax, 0
  5217 00002C2A A2[B201]                 mov byte [RegNo], al
  5218                                  
  5219                                  ;-148     R1Type=RegType; RegType=0; 
  5220                                  
  5221 00002C2D A0[B401]                 mov al, [RegType]
  5222 00002C30 A2[B501]                 mov byte [R1Type], al
  5223 00002C33 66B800000000             mov eax, 0
  5224 00002C39 A2[B401]                 mov byte [RegType], al
  5225                                  
  5226                                  ;-149 }  
  5227                                  
  5228                                  
  5229                                  ;-150 
  5230                                  
  5231                                  
  5232                                  ;-151 int getOpR() {
  5233                                  
  5234 00002C3C C3                       ret
  5235                                  ; ENDP
  5236                                  
  5237                                  getOpR:  ; *** PROC ***
  5238                                  
  5239                                  ;-152     Op2=getOp1();
  5240                                  
  5241 00002C3D E88900                   call getOp1
  5242 00002C40 A2[AD01]                 mov byte [Op2], al
  5243                                  
  5244                                  ;-153     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  5245                                  
  5246 00002C43 6A5B                     push 91
  5247 00002C45 E866EA                   call isToken
  5248 00002C48 83C402                   add  sp, 2
  5249 00002C4B 08C0                     or  al, al
  5250 00002C4D 0F840F00                 je @@getOpR195
  5251 00002C51 66B804000000             mov eax, 4
  5252 00002C57 A2[AD01]                 mov byte [Op2], al
  5253 00002C5A E8F200                   call getMEM
  5254 00002C5D E94F00                   jmp @@retn
  5255                                  
  5256                                  ;-154     if (Op2 == 0)     {invaloperror();         return;}
  5257                                  
  5258                                  @@getOpR195:
  5259 00002C60 A0[AD01]                 mov al, [Op2]
  5260 00002C63 3C00                     cmp al, 0
  5261 00002C65 0F850600                 jne @@getOpR196
  5262 00002C69 E88AF5                   call invaloperror
  5263 00002C6C E94000                   jmp @@retn
  5264                                  
  5265                                  ;-155     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  5266                                  
  5267                                  @@getOpR196:
  5268 00002C6F A0[AD01]                 mov al, [Op2]
  5269 00002C72 3C01                     cmp al, 1
  5270 00002C74 0F850900                 jne @@getOpR197
  5271 00002C78 A1[4D00]                 mov ax, [SymbolInt]
  5272 00002C7B A3[BD01]                 mov word [imme], ax
  5273 00002C7E E92E00                   jmp @@retn
  5274                                  
  5275                                  ;-156     if (Op2 == REG)                            return;
  5276                                  
  5277                                  @@getOpR197:
  5278 00002C81 A0[AD01]                 mov al, [Op2]
  5279 00002C84 3C02                     cmp al, 2
  5280 00002C86 0F850300                 jne @@getOpR198
  5281 00002C8A E92200                   jmp @@retn
  5282                                  
  5283                                  ;-157     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  5284                                  
  5285                                  @@getOpR198:
  5286 00002C8D A0[AD01]                 mov al, [Op2]
  5287 00002C90 3C03                     cmp al, 3
  5288 00002C92 0F851000                 jne @@getOpR199
  5289 00002C96 8B1E[7D06]               mov bx, [LabelIx]
  5290 00002C9A D1E3                     shl bx, 1
  5291 00002C9C 8B87[B305]               mov ax, [LabelAddr + bx]
  5292 00002CA0 A3[BB01]                 mov word [disp], ax
  5293 00002CA3 E90900                   jmp @@retn
  5294                                  
  5295                                  ;-158     error1("Name of operand expected");
  5296                                  
  5297                                  @@getOpR199:
  5298 00002CA6 68[B02C]                 push getOpR_0
  5299 00002CA9 E856F4                   call error1
  5300 00002CAC 83C402                   add  sp, 2
  5301                                  
  5302                                  ;-159 }
  5303                                  
  5304                                  
  5305                                  ;-160 
  5306                                  
  5307                                  
  5308                                  ;-161 int getOp1() {//scan for a single operand
  5309                                  
  5310                                  @@retn:
  5311 00002CAF C3                       ret
  5312                                  ; ENDP
  5313 00002CB0 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  5314 00002CB9 706572616E64206578-
  5315 00002CC2 70656374656400     
  5316                                  
  5317                                  getOp1:  ; *** PROC ***
  5318                                  
  5319                                  ;-162 //return:0, IMM, REG, ADR (not MEM)
  5320                                  
  5321                                  
  5322                                  ;-163 //set   :RegType, RegNo by testReg
  5323                                  
  5324                                  
  5325                                  ;-164 //set   :LabelIx by searchLabel
  5326                                  
  5327                                  
  5328                                  ;-165     if (TokeType == 0)      return 0;
  5329                                  
  5330 00002CC9 A0[AB01]                 mov al, [TokeType]
  5331 00002CCC 3C00                     cmp al, 0
  5332 00002CCE 0F850900                 jne @@getOp1200
  5333 00002CD2 66B800000000             mov eax, 0
  5334 00002CD8 E96000                   jmp @@retn
  5335                                  
  5336                                  ;-166     if (TokeType == DIGIT)  return IMM;
  5337                                  
  5338                                  @@getOp1200:
  5339 00002CDB A0[AB01]                 mov al, [TokeType]
  5340 00002CDE 3C01                     cmp al, 1
  5341 00002CE0 0F850900                 jne @@getOp1201
  5342 00002CE4 66B801000000             mov eax, 1
  5343 00002CEA E94E00                   jmp @@retn
  5344                                  
  5345                                  ;-167     if (TokeType == ALNUME) {
  5346                                  
  5347                                  @@getOp1201:
  5348 00002CED A0[AB01]                 mov al, [TokeType]
  5349 00002CF0 3C03                     cmp al, 3
  5350 00002CF2 0F853C00                 jne @@getOp1202
  5351                                  
  5352                                  ;-168         RegNo=testReg();
  5353                                  
  5354 00002CF6 E862ED                   call testReg
  5355 00002CF9 A2[B201]                 mov byte [RegNo], al
  5356                                  
  5357                                  ;-169         if (RegType)        return REG;
  5358                                  
  5359 00002CFC A0[B401]                 mov al, [RegType]
  5360 00002CFF 08C0                     or  al, al
  5361 00002D01 0F840900                 je @@getOp1203
  5362 00002D05 66B802000000             mov eax, 2
  5363 00002D0B E92D00                   jmp @@retn
  5364                                  
  5365                                  ;-170         LabelIx=searchLabel();
  5366                                  
  5367                                  @@getOp1203:
  5368 00002D0E E808E7                   call searchLabel
  5369 00002D11 A3[7D06]                 mov word [LabelIx], ax
  5370                                  
  5371                                  ;-171         if (LabelIx)        return ADR;
  5372                                  
  5373 00002D14 A1[7D06]                 mov ax, [LabelIx]
  5374 00002D17 08C0                     or  al, al
  5375 00002D19 0F840C00                 je @@getOp1204
  5376 00002D1D 66B803000000             mov eax, 3
  5377 00002D23 E91500                   jmp @@retn
  5378                                  
  5379                                  ;-172         else error1("variable not found"); 
  5380                                  
  5381 00002D26 E90900                   jmp @@getOp1205
  5382                                  @@getOp1204:
  5383 00002D29 68[3C2D]                 push getOp1_0
  5384 00002D2C E8D3F3                   call error1
  5385 00002D2F 83C402                   add  sp, 2
  5386                                  
  5387                                  ;-173     }
  5388                                  
  5389                                  @@getOp1205:
  5390                                  
  5391                                  ;-174     return 0;
  5392                                  
  5393                                  @@getOp1202:
  5394 00002D32 66B800000000             mov eax, 0
  5395 00002D38 E90000                   jmp @@retn
  5396                                  
  5397                                  ;-175 }
  5398                                  
  5399                                  
  5400                                  ;-176 
  5401                                  
  5402                                  
  5403                                  ;-177 int getMEM() {// e.g. [array+bp+si-4]
  5404                                  
  5405                                  @@retn:
  5406 00002D3B C3                       ret
  5407                                  ; ENDP
  5408 00002D3C 7661726961626C6520-     getOp1_0 db "variable not found",0
  5409 00002D45 6E6F7420666F756E64-
  5410 00002D4E 00                 
  5411                                  
  5412                                  getMEM:  ; *** PROC ***
  5413                                  
  5414                                  ;-178 //set: disp, regindexbase, RegType
  5415                                  
  5416                                  
  5417                                  ;-179     char c;
  5418                                  
  5419                                  
  5420                                  ;-180     disp=0; regindexbase=0;
  5421                                  
  5422                                  ;Function : getMEM, Number of local variables: 1
  5423                                  ;   # type sign width line used address name   list of local variables
  5424                                  ;  200 var sign byte   179 NULL bp-2    c;
  5425 00002D4F C8020000                 ENTER  2,0
  5426 00002D53 66B800000000             mov eax, 0
  5427 00002D59 A3[BB01]                 mov word [disp], ax
  5428 00002D5C 66B800000000             mov eax, 0
  5429 00002D62 A2[B901]                 mov byte [regindexbase], al
  5430                                  
  5431                                  ;-181     do {
  5432                                  
  5433                                  @@getMEM206:
  5434                                  
  5435                                  ;-182         getTokeType();
  5436                                  
  5437 00002D65 E870E5                   call getTokeType
  5438                                  
  5439                                  ;-183         c=getOp1();
  5440                                  
  5441 00002D68 E85EFF                   call getOp1
  5442 00002D6B 8846FE                   mov byte [bp-2], al
  5443                                  
  5444                                  ;-184         if (c ==   0) syntaxerror();
  5445                                  
  5446 00002D6E 8A46FE                   mov al, [bp-2]
  5447 00002D71 3C00                     cmp al, 0
  5448 00002D73 0F850300                 jne @@getMEM207
  5449 00002D77 E830F5                   call syntaxerror
  5450                                  
  5451                                  ;-185         if (c == REG) {isDirect=0;
  5452                                  
  5453                                  @@getMEM207:
  5454 00002D7A 8A46FE                   mov al, [bp-2]
  5455 00002D7D 3C02                     cmp al, 2
  5456 00002D7F 0F851E00                 jne @@getMEM208
  5457 00002D83 66B800000000             mov eax, 0
  5458 00002D89 A2[BA01]                 mov byte [isDirect], al
  5459                                  
  5460                                  ;-186             if (regindexbase) regindexbase=getIndReg2();
  5461                                  
  5462 00002D8C A0[B901]                 mov al, [regindexbase]
  5463 00002D8F 08C0                     or  al, al
  5464 00002D91 0F840900                 je @@getMEM209
  5465 00002D95 E8F300                   call getIndReg2
  5466 00002D98 A2[B901]                 mov byte [regindexbase], al
  5467                                  
  5468                                  ;-187             else getIndReg1();
  5469                                  
  5470 00002D9B E90300                   jmp @@getMEM210
  5471                                  @@getMEM209:
  5472 00002D9E E88900                   call getIndReg1
  5473                                  
  5474                                  ;-188         }
  5475                                  
  5476                                  @@getMEM210:
  5477                                  
  5478                                  ;-189         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  5479                                  
  5480                                  @@getMEM208:
  5481 00002DA1 8A46FE                   mov al, [bp-2]
  5482 00002DA4 3C03                     cmp al, 3
  5483 00002DA6 0F851000                 jne @@getMEM211
  5484 00002DAA A1[BB01]                 mov ax, [disp]
  5485 00002DAD 8B1E[7D06]               mov bx, [LabelIx]
  5486 00002DB1 D1E3                     shl bx, 1
  5487 00002DB3 0387[B305]               add ax, [LabelAddr + bx]
  5488 00002DB7 A3[BB01]                 mov word [disp], ax
  5489                                  
  5490                                  ;-190         if (c == IMM) disp=disp+SymbolInt;
  5491                                  
  5492                                  @@getMEM211:
  5493 00002DBA 8A46FE                   mov al, [bp-2]
  5494 00002DBD 3C01                     cmp al, 1
  5495 00002DBF 0F850A00                 jne @@getMEM212
  5496 00002DC3 A1[BB01]                 mov ax, [disp]
  5497 00002DC6 0306[4D00]               add ax, [SymbolInt]
  5498 00002DCA A3[BB01]                 mov word [disp], ax
  5499                                  
  5500                                  ;-191         if (isToken('-')) {
  5501                                  
  5502                                  @@getMEM212:
  5503 00002DCD 6A2D                     push 45
  5504 00002DCF E8DCE8                   call isToken
  5505 00002DD2 83C402                   add  sp, 2
  5506 00002DD5 08C0                     or  al, al
  5507 00002DD7 0F841900                 je @@getMEM213
  5508                                  
  5509                                  ;-192             getTokeType();
  5510                                  
  5511 00002DDB E8FAE4                   call getTokeType
  5512                                  
  5513                                  ;-193             if (TokeType != DIGIT) numbererror();
  5514                                  
  5515 00002DDE A0[AB01]                 mov al, [TokeType]
  5516 00002DE1 3C01                     cmp al, 1
  5517 00002DE3 0F840300                 je  @@getMEM214
  5518 00002DE7 E82DF4                   call numbererror
  5519                                  
  5520                                  ;-194             disp = disp - SymbolInt;
  5521                                  
  5522                                  @@getMEM214:
  5523 00002DEA A1[BB01]                 mov ax, [disp]
  5524 00002DED 2B06[4D00]               sub ax, [SymbolInt]
  5525 00002DF1 A3[BB01]                 mov word [disp], ax
  5526                                  
  5527                                  ;-195         }
  5528                                  
  5529                                  
  5530                                  ;-196     } while (isToken('+'));
  5531                                  
  5532                                  @@getMEM213:
  5533 00002DF4 6A2B                     push 43
  5534 00002DF6 E8B5E8                   call isToken
  5535 00002DF9 83C402                   add  sp, 2
  5536 00002DFC 08C0                     or  al, al
  5537 00002DFE 0F840300                 je @@getMEM215
  5538 00002E02 E960FF                   jmp @@getMEM206
  5539                                  @@getMEM215:
  5540                                  
  5541                                  ;-197     if (isToken(']') == 0) errorexit("] expected");
  5542                                  
  5543 00002E05 6A5D                     push 93
  5544 00002E07 E8A4E8                   call isToken
  5545 00002E0A 83C402                   add  sp, 2
  5546 00002E0D 83F800                   cmp ax, 0
  5547 00002E10 0F850900                 jne @@getMEM216
  5548 00002E14 68[1F2E]                 push getMEM_0
  5549 00002E17 E8A1F4                   call errorexit
  5550 00002E1A 83C402                   add  sp, 2
  5551                                  
  5552                                  ;-198 }
  5553                                  
  5554                                  @@getMEM216:
  5555                                  
  5556                                  ;-199 int getIndReg1() {
  5557 00002E1D C9                       LEAVE
  5558 00002E1E C3                       ret
  5559                                  ; ENDP
  5560 00002E1F 5D2065787065637465-     getMEM_0 db "] expected",0
  5561 00002E28 6400               
  5562                                  
  5563                                  getIndReg1:  ; *** PROC ***
  5564                                  
  5565                                  ;-200     if (RegType !=WORD) indexerror();
  5566                                  
  5567 00002E2A A0[B401]                 mov al, [RegType]
  5568 00002E2D 3C02                     cmp al, 2
  5569 00002E2F 0F840300                 je  @@getIndReg1217
  5570 00002E33 E89FF3                   call indexerror
  5571                                  
  5572                                  ;-201     if (RegNo==3) regindexbase=7;//BX
  5573                                  
  5574                                  @@getIndReg1217:
  5575 00002E36 A0[B201]                 mov al, [RegNo]
  5576 00002E39 3C03                     cmp al, 3
  5577 00002E3B 0F850900                 jne @@getIndReg1218
  5578 00002E3F 66B807000000             mov eax, 7
  5579 00002E45 A2[B901]                 mov byte [regindexbase], al
  5580                                  
  5581                                  ;-202     if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5582                                  
  5583                                  @@getIndReg1218:
  5584 00002E48 A0[B201]                 mov al, [RegNo]
  5585 00002E4B 3C05                     cmp al, 5
  5586 00002E4D 0F850900                 jne @@getIndReg1219
  5587 00002E51 66B806000000             mov eax, 6
  5588 00002E57 A2[B901]                 mov byte [regindexbase], al
  5589                                  
  5590                                  ;-203     if (RegNo==7) regindexbase=5;//DI
  5591                                  
  5592                                  @@getIndReg1219:
  5593 00002E5A A0[B201]                 mov al, [RegNo]
  5594 00002E5D 3C07                     cmp al, 7
  5595 00002E5F 0F850900                 jne @@getIndReg1220
  5596 00002E63 66B805000000             mov eax, 5
  5597 00002E69 A2[B901]                 mov byte [regindexbase], al
  5598                                  
  5599                                  ;-204     if (RegNo==6) regindexbase=4;//SI
  5600                                  
  5601                                  @@getIndReg1220:
  5602 00002E6C A0[B201]                 mov al, [RegNo]
  5603 00002E6F 3C06                     cmp al, 6
  5604 00002E71 0F850900                 jne @@getIndReg1221
  5605 00002E75 66B804000000             mov eax, 4
  5606 00002E7B A2[B901]                 mov byte [regindexbase], al
  5607                                  
  5608                                  ;-205     if (regindexbase==0) indexerror();
  5609                                  
  5610                                  @@getIndReg1221:
  5611 00002E7E A0[B901]                 mov al, [regindexbase]
  5612 00002E81 3C00                     cmp al, 0
  5613 00002E83 0F850300                 jne @@getIndReg1222
  5614 00002E87 E84BF3                   call indexerror
  5615                                  
  5616                                  ;-206 }
  5617                                  
  5618                                  @@getIndReg1222:
  5619                                  
  5620                                  ;-207 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5621                                  
  5622 00002E8A C3                       ret
  5623                                  ; ENDP
  5624                                  
  5625                                  getIndReg2:  ; *** PROC ***
  5626                                  ;Function : getIndReg2, Number of local variables: 1
  5627                                  ;   # type sign width line used address name   list of local variables
  5628                                  ;  200 var sign byte   207 NULL bp-2    m;
  5629 00002E8B C8020000                 ENTER  2,0
  5630 00002E8F 66B804000000             mov eax, 4
  5631 00002E95 8846FE                   mov byte [bp-2], al
  5632                                  
  5633                                  ;-208     if (RegType !=WORD) indexerror();
  5634                                  
  5635 00002E98 A0[B401]                 mov al, [RegType]
  5636 00002E9B 3C02                     cmp al, 2
  5637 00002E9D 0F840300                 je  @@getIndReg2223
  5638 00002EA1 E831F3                   call indexerror
  5639                                  
  5640                                  ;-209     if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5641                                  
  5642                                  @@getIndReg2223:
  5643 00002EA4 A0[B201]                 mov al, [RegNo]
  5644 00002EA7 3C07                     cmp al, 7
  5645 00002EA9 0F852700                 jne @@getIndReg2224
  5646 00002EAD A0[B901]                 mov al, [regindexbase]
  5647 00002EB0 3C06                     cmp al, 6
  5648 00002EB2 0F850C00                 jne @@getIndReg2225
  5649 00002EB6 66B803000000             mov eax, 3
  5650 00002EBC 8846FE                   mov byte [bp-2], al
  5651                                  
  5652                                  ;-210              else if (regindexbase==7) m=1;//BX+DI
  5653                                  
  5654 00002EBF E91200                   jmp @@getIndReg2226
  5655                                  @@getIndReg2225:
  5656 00002EC2 A0[B901]                 mov al, [regindexbase]
  5657 00002EC5 3C07                     cmp al, 7
  5658 00002EC7 0F850900                 jne @@getIndReg2227
  5659 00002ECB 66B801000000             mov eax, 1
  5660 00002ED1 8846FE                   mov byte [bp-2], al
  5661                                  
  5662                                  ;-211     if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5663                                  
  5664                                  @@getIndReg2227:
  5665                                  @@getIndReg2226:
  5666                                  @@getIndReg2224:
  5667 00002ED4 A0[B201]                 mov al, [RegNo]
  5668 00002ED7 3C06                     cmp al, 6
  5669 00002ED9 0F852700                 jne @@getIndReg2228
  5670 00002EDD A0[B901]                 mov al, [regindexbase]
  5671 00002EE0 3C06                     cmp al, 6
  5672 00002EE2 0F850C00                 jne @@getIndReg2229
  5673 00002EE6 66B802000000             mov eax, 2
  5674 00002EEC 8846FE                   mov byte [bp-2], al
  5675                                  
  5676                                  ;-212              else if (regindexbase==7) m=0;//BX+SI
  5677                                  
  5678 00002EEF E91200                   jmp @@getIndReg2230
  5679                                  @@getIndReg2229:
  5680 00002EF2 A0[B901]                 mov al, [regindexbase]
  5681 00002EF5 3C07                     cmp al, 7
  5682 00002EF7 0F850900                 jne @@getIndReg2231
  5683 00002EFB 66B800000000             mov eax, 0
  5684 00002F01 8846FE                   mov byte [bp-2], al
  5685                                  
  5686                                  ;-213     if (m > 3) indexerror();
  5687                                  
  5688                                  @@getIndReg2231:
  5689                                  @@getIndReg2230:
  5690                                  @@getIndReg2228:
  5691 00002F04 8A46FE                   mov al, [bp-2]
  5692 00002F07 3C03                     cmp al, 3
  5693 00002F09 0F8E0300                 jle @@getIndReg2232
  5694 00002F0D E8C5F2                   call indexerror
  5695                                  
  5696                                  ;-214     return m;
  5697                                  
  5698                                  @@getIndReg2232:
  5699 00002F10 8A46FE                   mov al, [bp-2]
  5700 00002F13 E90000                   jmp @@retn
  5701                                  
  5702                                  ;-215 }
  5703                                  
  5704                                  
  5705                                  ;-216          
  5706                                  
  5707                                  
  5708                                  ;-217          
  5709                                  
  5710                                  
  5711                                  ;-218 int setwflag() {
  5712                                  
  5713 00002F16 C9                      @@retn: LEAVE
  5714 00002F17 C3                       ret
  5715                                  ; ENDP
  5716                                  
  5717                                  setwflag:  ; *** PROC ***
  5718                                  
  5719                                  ;-219     wflag=0;
  5720                                  
  5721 00002F18 66B800000000             mov eax, 0
  5722 00002F1E A2[B701]                 mov byte [wflag], al
  5723                                  
  5724                                  ;-220     if (OpSize == 0) {//do not override OpSize
  5725                                  
  5726 00002F21 A0[B601]                 mov al, [OpSize]
  5727 00002F24 3C00                     cmp al, 0
  5728 00002F26 0F854200                 jne @@setwflag233
  5729                                  
  5730                                  ;-221         if (Op == REG) OpSize=R1Type;
  5731                                  
  5732 00002F2A A0[AC01]                 mov al, [Op]
  5733 00002F2D 3C02                     cmp al, 2
  5734 00002F2F 0F850600                 jne @@setwflag234
  5735 00002F33 A0[B501]                 mov al, [R1Type]
  5736 00002F36 A2[B601]                 mov byte [OpSize], al
  5737                                  
  5738                                  ;-222         if (Op2== REG) OpSize=RegType;        
  5739                                  
  5740                                  @@setwflag234:
  5741 00002F39 A0[AD01]                 mov al, [Op2]
  5742 00002F3C 3C02                     cmp al, 2
  5743 00002F3E 0F850600                 jne @@setwflag235
  5744 00002F42 A0[B401]                 mov al, [RegType]
  5745 00002F45 A2[B601]                 mov byte [OpSize], al
  5746                                  
  5747                                  ;-223         if (RegType== SEGREG) OpSize=WORD;
  5748                                  
  5749                                  @@setwflag235:
  5750 00002F48 A0[B401]                 mov al, [RegType]
  5751 00002F4B 3C04                     cmp al, 4
  5752 00002F4D 0F850900                 jne @@setwflag236
  5753 00002F51 66B802000000             mov eax, 2
  5754 00002F57 A2[B601]                 mov byte [OpSize], al
  5755                                  
  5756                                  ;-224         if (R1Type == SEGREG) OpSize=WORD;        
  5757                                  
  5758                                  @@setwflag236:
  5759 00002F5A A0[B501]                 mov al, [R1Type]
  5760 00002F5D 3C04                     cmp al, 4
  5761 00002F5F 0F850900                 jne @@setwflag237
  5762 00002F63 66B802000000             mov eax, 2
  5763 00002F69 A2[B601]                 mov byte [OpSize], al
  5764                                  
  5765                                  ;-225     }
  5766                                  
  5767                                  @@setwflag237:
  5768                                  
  5769                                  ;-226     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  5770                                  
  5771                                  @@setwflag233:
  5772 00002F6C A0[B601]                 mov al, [OpSize]
  5773 00002F6F 3C03                     cmp al, 3
  5774 00002F71 0F850C00                 jne @@setwflag238
  5775 00002F75 E800F7                   call gen66h
  5776 00002F78 66B801000000             mov eax, 1
  5777 00002F7E A2[B701]                 mov byte [wflag], al
  5778                                  
  5779                                  ;-227     if (OpSize  ==  WORD) wflag=1;
  5780                                  
  5781                                  @@setwflag238:
  5782 00002F81 A0[B601]                 mov al, [OpSize]
  5783 00002F84 3C02                     cmp al, 2
  5784 00002F86 0F850900                 jne @@setwflag239
  5785 00002F8A 66B801000000             mov eax, 1
  5786 00002F90 A2[B701]                 mov byte [wflag], al
  5787                                  
  5788                                  ;-228 }
  5789                                  
  5790                                  @@setwflag239:
  5791                                  
  5792                                  ;-229 
  5793                                  
  5794                                  
  5795                                  ;-230 int setsflag() {  
  5796                                  
  5797 00002F93 C3                       ret
  5798                                  ; ENDP
  5799                                  
  5800                                  setsflag:  ; *** PROC ***
  5801                                  
  5802                                  ;-231     sflag=2;
  5803                                  
  5804 00002F94 66B802000000             mov eax, 2
  5805 00002F9A A2[B801]                 mov byte [sflag], al
  5806                                  
  5807                                  ;-232     if(imme > 127) sflag = 0;    
  5808                                  
  5809 00002F9D A1[BD01]                 mov ax, [imme]
  5810 00002FA0 83F87F                   cmp ax, 127
  5811 00002FA3 0F8E0900                 jle @@setsflag240
  5812 00002FA7 66B800000000             mov eax, 0
  5813 00002FAD A2[B801]                 mov byte [sflag], al
  5814                                  
  5815                                  ;-233     if (OpSize == BYTE) {
  5816                                  
  5817                                  @@setsflag240:
  5818 00002FB0 A0[B601]                 mov al, [OpSize]
  5819 00002FB3 3C01                     cmp al, 1
  5820 00002FB5 0F851B00                 jne @@setsflag241
  5821                                  
  5822                                  ;-234         if (sflag == 0) error1("too big for byte r/m");
  5823                                  
  5824 00002FB9 A0[B801]                 mov al, [sflag]
  5825 00002FBC 3C00                     cmp al, 0
  5826 00002FBE 0F850900                 jne @@setsflag242
  5827 00002FC2 68[D52F]                 push setsflag_0
  5828 00002FC5 E83AF1                   call error1
  5829 00002FC8 83C402                   add  sp, 2
  5830                                  
  5831                                  ;-235         sflag=0;//byte reg does not need sign extended   
  5832                                  
  5833                                  @@setsflag242:
  5834 00002FCB 66B800000000             mov eax, 0
  5835 00002FD1 A2[B801]                 mov byte [sflag], al
  5836                                  
  5837                                  ;-236     }
  5838                                  
  5839                                  
  5840                                  ;-237 }
  5841                                  
  5842                                  @@setsflag241:
  5843 00002FD4 C3                       ret
  5844                                  ; ENDP
  5845 00002FD5 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  5846 00002FDE 6F7220627974652072-
  5847 00002FE7 2F6D00             
  5848                                   
  5849                                  ; missing functions: 
  5850                                  ; digit
  5851                                  ; strcpy
  5852                                  ; eqstr
  5853                                  ; strlen
  5854                                  ; eqstr
  5855                                  ; eqstr
  5856                                  ; eqstr
  5857                                  ; eqstr
  5858                                  ; readRL
  5859                                  ; readRL
  5860                                  ; digit
  5861                                  ; digit
  5862                                  ; strcpy
  5863                                  ; toupper
  5864                                  ; strlen
  5865                                  ; strlen
  5866                                  ; eqstr
  5867                                  ; eqstr
  5868                                  ; eqstr
  5869                                  ; eqstr
  5870                                  ; eqstr
  5871                                  ; eqstr
  5872                                  ; eqstr
  5873                                  ; eqstr
  5874                                  ; eqstr
  5875                                  ; eqstr
  5876                                  ; eqstr
  5877                                  ; eqstr
  5878                                  ; eqstr
  5879                                  ; eqstr
  5880                                  ; eqstr
  5881                                  ; eqstr
  5882                                  ; eqstr
  5883                                  ; eqstr
  5884                                  ; eqstr
  5885                                  ; eqstr
  5886                                  ; eqstr
  5887                                  ; eqstr
  5888                                  ; eqstr
  5889                                  ; eqstr
  5890                                  ; eqstr
  5891                                  ; eqstr
  5892                                  ; eqstr
  5893                                  ; eqstr
  5894                                  ; eqstr
  5895                                  ; eqstr
  5896                                  ; writetty
  5897                                  ; writetty
  5898                                  ; fputcR
  5899                                  ; cputs
  5900                                  ; cputs
  5901                                  ; exitR
  5902                                  ; toupper
  5903                                  ; strcpy
  5904                                  ; strcat1
  5905                                  ; strcpy
  5906                                  ; strcat1
  5907                                  ; strcpy
  5908                                  ; strcat1
  5909                                  ; openR
  5910                                  ; cputs
  5911                                  ; cputs
  5912                                  ; exitR
  5913                                  ; creatR
  5914                                  ; cputs
  5915                                  ; cputs
  5916                                  ; exitR
  5917                                  ; creatR
  5918                                  ; cputs
  5919                                  ; cputs
  5920                                  ; exitR
  5921                                  ; fputcR
  5922                                  ; fcloseR
  5923                                  ; fcloseR
  5924                                  ; fcloseR
  5925                                  ; exitR
  5926                                  ; Number of unresolved CALLs :   76
  5927                                  ;use archive file: AR.C
  5928                                  
  5929                                  ;-238 // AR.C Archive
  5930                                  
  5931                                  ;Number of CALLs:    2 : writetty
  5932                                  
  5933                                  writetty:  ; *** PROC ***
  5934 00002FEA B40E                     mov  ah, 14
  5935 00002FEC BB0000                   mov  bx, 0
  5936 00002FEF CD10                     int  16
  5937                                  
  5938                                  ;-239 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  5939                                  
  5940 00002FF1 C3                       ret
  5941                                  ; ENDP
  5942                                  ;Number of CALLs:    8 : cputs
  5943                                  
  5944                                  cputs:  ; *** PROC ***
  5945                                  ;Function : cputs, Number of local variables: 2
  5946                                  ;   # type sign width line used address name   list of local variables
  5947                                  ;  200 ptr sign byte   239 NULL bp+4    s
  5948                                  ;  201 var sign byte   239 NULL bp-2    c;
  5949 00002FF2 C8020000                 ENTER  2,0
  5950                                  @@cputs243:
  5951 00002FF6 8B5E04                   mov bx, [bp+4]
  5952 00002FF9 8A07                     mov al, [bx]
  5953 00002FFB B400                     mov ah, 0
  5954 00002FFD 08C0                     or  al, al
  5955 00002FFF 0F841B00                 je @@cputs244
  5956 00003003 8B5E04                   mov bx, [bp+4]
  5957 00003006 8A07                     mov al, [bx]
  5958 00003008 B400                     mov ah, 0
  5959 0000300A 8846FE                   mov byte [bp-2], al
  5960 0000300D 8A46FE                   mov al, byte [bp-2]
  5961 00003010 B400                     mov ah, 0
  5962 00003012 50                       push ax
  5963 00003013 E8C401                   call putch
  5964 00003016 83C402                   add  sp, 2
  5965 00003019 FF4604                   inc  word [bp+4]
  5966 0000301C EBD8                     jmp @@cputs243
  5967                                  @@cputs244:
  5968                                  
  5969                                  ;-240 int mkneg(int n) { n; __asm {neg ax} }
  5970 0000301E C9                       LEAVE
  5971 0000301F C3                       ret
  5972                                  ; ENDP
  5973                                  ;Number of CALLs:    2 : toupper
  5974                                  
  5975                                  toupper:  ; *** PROC ***
  5976                                  ;Function : toupper, Number of local variables: 1
  5977                                  ;   # type sign width line used address name   list of local variables
  5978                                  ;  200 ptr sign byte   240 NULL bp+4    s;
  5979 00003020 C8000000                 ENTER  0,0
  5980                                  @@toupper245:
  5981 00003024 8B5E04                   mov bx, [bp+4]
  5982 00003027 8A07                     mov al, [bx]
  5983 00003029 B400                     mov ah, 0
  5984 0000302B 08C0                     or  al, al
  5985 0000302D 0F843000                 je @@toupper246
  5986 00003031 8B5E04                   mov bx, [bp+4]
  5987 00003034 8A07                     mov al, [bx]
  5988 00003036 B400                     mov ah, 0
  5989 00003038 83F861                   cmp ax, 97 ;unsigned : 1
  5990 0000303B 0F8C1D00                 jl  @@toupper247
  5991 0000303F 8B5E04                   mov bx, [bp+4]
  5992 00003042 8A07                     mov al, [bx]
  5993 00003044 B400                     mov ah, 0
  5994 00003046 83F87A                   cmp ax, 122
  5995 00003049 0F8F0F00                 jg  @@toupper248
  5996 0000304D 8B5E04                   mov bx, [bp+4]
  5997 00003050 8A07                     mov al, [bx]
  5998 00003052 B400                     mov ah, 0
  5999 00003054 83E820                   sub ax, 32
  6000 00003057 8B5E04                   mov  bx, [bp+4]
  6001 0000305A 8807                     mov  [bx], al
  6002                                  @@toupper248:
  6003                                  @@toupper247:
  6004 0000305C FF4604                   inc  word [bp+4]
  6005 0000305F EBC3                     jmp @@toupper245
  6006                                  @@toupper246:
  6007                                  
  6008                                  ;-241 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6009                                  
  6010                                  
  6011                                  ;-242 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6012 00003061 C9                       LEAVE
  6013 00003062 C3                       ret
  6014                                  ; ENDP
  6015                                  ;Number of CALLs:    3 : strlen
  6016                                  
  6017                                  strlen:  ; *** PROC ***
  6018                                  ;Function : strlen, Number of local variables: 2
  6019                                  ;   # type sign width line used address name   list of local variables
  6020                                  ;  200 ptr sign byte   242 NULL bp+4    s
  6021                                  ;  201 var sign word   242 NULL bp-2    c;
  6022 00003063 C8020000                 ENTER  2,0
  6023 00003067 66B800000000             mov eax, 0
  6024 0000306D 8946FE                   mov word [bp-2], ax
  6025                                  @@strlen249:
  6026 00003070 8B5E04                   mov bx, [bp+4]
  6027 00003073 8A07                     mov al, [bx]
  6028 00003075 B400                     mov ah, 0
  6029 00003077 83F800                   cmp ax, 0
  6030 0000307A 0F840800                 je  @@strlen250
  6031 0000307E FF4604                   inc  word [bp+4]
  6032 00003081 FF46FE                   inc  word [bp-2]
  6033 00003084 EBEA                     jmp @@strlen249
  6034                                  @@strlen250:
  6035 00003086 8B46FE                   mov ax, [bp-2]
  6036 00003089 E90000                   jmp @@retn
  6037                                  
  6038                                  ;-243 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6039                                  
  6040 0000308C C9                      @@retn: LEAVE
  6041 0000308D C3                       ret
  6042                                  ; ENDP
  6043                                  ;Number of CALLs:    5 : strcpy
  6044                                  
  6045                                  strcpy:  ; *** PROC ***
  6046                                  ;Function : strcpy, Number of local variables: 2
  6047                                  ;   # type sign width line used address name   list of local variables
  6048                                  ;  200 ptr sign byte   243 NULL bp+4    s
  6049                                  ;  201 ptr sign byte   243 NULL bp+6    t;
  6050 0000308E C8000000                 ENTER  0,0
  6051                                  @@strcpy251:
  6052 00003092 8B5E06                   mov bx, [bp+6]
  6053 00003095 8A07                     mov al, [bx]
  6054 00003097 B400                     mov ah, 0
  6055 00003099 8B5E04                   mov  bx, [bp+4]
  6056 0000309C 8807                     mov  [bx], al
  6057 0000309E FF4604                   inc  word [bp+4]
  6058 000030A1 FF4606                   inc  word [bp+6]
  6059                                  
  6060                                  ;-244   while (*t!=0); *s=0; return s; }
  6061                                  
  6062 000030A4 8B5E06                   mov bx, [bp+6]
  6063 000030A7 8A07                     mov al, [bx]
  6064 000030A9 B400                     mov ah, 0
  6065 000030AB 83F800                   cmp ax, 0
  6066 000030AE 0F840200                 je  @@strcpy252
  6067 000030B2 EBDE                     jmp @@strcpy251
  6068                                  @@strcpy252:
  6069 000030B4 66B800000000             mov eax, 0
  6070 000030BA 8B5E04                   mov  bx, [bp+4]
  6071 000030BD 8807                     mov  [bx], al
  6072 000030BF 8B4604                   mov ax, [bp+4]
  6073 000030C2 E90000                   jmp @@retn
  6074                                  
  6075                                  ;-245 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6076                                  
  6077 000030C5 C9                      @@retn: LEAVE
  6078 000030C6 C3                       ret
  6079                                  ; ENDP
  6080                                  ;Number of CALLs:    3 : digit
  6081                                  
  6082                                  digit:  ; *** PROC ***
  6083                                  ;Function : digit, Number of local variables: 1
  6084                                  ;   # type sign width line used address name   list of local variables
  6085                                  ;  200 var sign byte   245 NULL bp+4    c;
  6086 000030C7 C8000000                 ENTER  0,0
  6087 000030CB 8A4604                   mov al, [bp+4]
  6088 000030CE 3C30                     cmp al, 48
  6089 000030D0 0F8D0900                 jge @@digit253
  6090 000030D4 66B800000000             mov eax, 0
  6091 000030DA E91B00                   jmp @@retn
  6092                                  @@digit253:
  6093 000030DD 8A4604                   mov al, [bp+4]
  6094 000030E0 3C39                     cmp al, 57
  6095 000030E2 0F8E0900                 jle @@digit254
  6096 000030E6 66B800000000             mov eax, 0
  6097 000030EC E90900                   jmp @@retn
  6098                                  @@digit254:
  6099 000030EF 66B801000000             mov eax, 1
  6100 000030F5 E90000                   jmp @@retn
  6101                                  
  6102                                  ;-246 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6103                                  
  6104 000030F8 C9                      @@retn: LEAVE
  6105 000030F9 C3                       ret
  6106                                  ; ENDP
  6107                                  ;Number of CALLs:   35 : eqstr
  6108                                  
  6109                                  eqstr:  ; *** PROC ***
  6110                                  ;Function : eqstr, Number of local variables: 2
  6111                                  ;   # type sign width line used address name   list of local variables
  6112                                  ;  200 ptr sign byte   246 NULL bp+4    p
  6113                                  ;  201 ptr sign byte   246 NULL bp+6    q;
  6114 000030FA C8000000                 ENTER  0,0
  6115                                  @@eqstr255:
  6116 000030FE 8B5E04                   mov bx, [bp+4]
  6117 00003101 8A07                     mov al, [bx]
  6118 00003103 B400                     mov ah, 0
  6119 00003105 08C0                     or  al, al
  6120 00003107 0F842300                 je @@eqstr256
  6121                                  
  6122                                  ;-247     if (*p != *q) return 0; p++; q++; }
  6123                                  
  6124 0000310B 8B5E04                   mov bx, [bp+4]
  6125 0000310E 8A07                     mov al, [bx]
  6126 00003110 B400                     mov ah, 0
  6127 00003112 8B5E06                   mov bx, [bp+6]
  6128 00003115 3A07                     cmp al, [bx]
  6129 00003117 B400                     mov ah, 0
  6130 00003119 0F840900                 je  @@eqstr257
  6131 0000311D 66B800000000             mov eax, 0
  6132 00003123 E92700                   jmp @@retn
  6133                                  @@eqstr257:
  6134 00003126 FF4604                   inc  word [bp+4]
  6135 00003129 FF4606                   inc  word [bp+6]
  6136                                  
  6137                                  ;-248     if(*q) return 0; return 1; }
  6138                                  
  6139 0000312C EBD0                     jmp @@eqstr255
  6140                                  @@eqstr256:
  6141 0000312E 8B5E06                   mov bx, [bp+6]
  6142 00003131 8A07                     mov al, [bx]
  6143 00003133 B400                     mov ah, 0
  6144 00003135 08C0                     or  al, al
  6145 00003137 0F840900                 je @@eqstr258
  6146 0000313B 66B800000000             mov eax, 0
  6147 00003141 E90900                   jmp @@retn
  6148                                  @@eqstr258:
  6149 00003144 66B801000000             mov eax, 1
  6150 0000314A E90000                   jmp @@retn
  6151                                  
  6152                                  ;-249 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  6153                                  
  6154 0000314D C9                      @@retn: LEAVE
  6155 0000314E C3                       ret
  6156                                  ; ENDP
  6157                                  ;Number of CALLs:    3 : strcat1
  6158                                  
  6159                                  strcat1:  ; *** PROC ***
  6160                                  ;Function : strcat1, Number of local variables: 2
  6161                                  ;   # type sign width line used address name   list of local variables
  6162                                  ;  200 ptr sign byte   249 NULL bp+4    s
  6163                                  ;  201 ptr sign byte   249 NULL bp+6    t;
  6164 0000314F C8000000                 ENTER  0,0
  6165                                  @@strcat1259:
  6166 00003153 8B5E04                   mov bx, [bp+4]
  6167 00003156 8A07                     mov al, [bx]
  6168 00003158 B400                     mov ah, 0
  6169 0000315A 83F800                   cmp ax, 0
  6170 0000315D 0F840500                 je  @@strcat1260
  6171 00003161 FF4604                   inc  word [bp+4]
  6172 00003164 EBED                     jmp @@strcat1259
  6173                                  @@strcat1260:
  6174 00003166 FF7606                   push word [bp+6]
  6175 00003169 FF7604                   push word [bp+4]
  6176 0000316C E81FFF                   call strcpy
  6177 0000316F 83C404                   add  sp, 4
  6178                                  
  6179                                  ;-250 int basename(char *s) { char *p; p=0;
  6180 00003172 C9                       LEAVE
  6181 00003173 C3                       ret
  6182                                  ; ENDP
  6183                                  ;Number of CALLs:    1 : openR
  6184                                  
  6185                                  openR:  ; *** PROC ***
  6186                                  ;Function : openR, Number of local variables: 1
  6187                                  ;   # type sign width line used address name   list of local variables
  6188                                  ;  200 ptr sign byte   250 NULL bp+4    s;
  6189 00003174 C8000000                 ENTER  0,0
  6190 00003178 8B5604                   mov  dx, [bp+4]
  6191 0000317B B8023D                   mov  ax, 15618
  6192 0000317E E87200                   call DosInt
  6193                                  
  6194                                  ;-251 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  6195 00003181 C9                       LEAVE
  6196 00003182 C3                       ret
  6197                                  ; ENDP
  6198                                  ;Number of CALLs:    2 : creatR
  6199                                  
  6200                                  creatR:  ; *** PROC ***
  6201                                  ;Function : creatR, Number of local variables: 1
  6202                                  ;   # type sign width line used address name   list of local variables
  6203                                  ;  200 ptr sign byte   251 NULL bp+4    s;
  6204 00003183 C8000000                 ENTER  0,0
  6205 00003187 8B5604                   mov  dx, [bp+4]
  6206 0000318A B90000                   mov  cx, 0
  6207 0000318D B8003C                   mov  ax, 15360
  6208 00003190 E86000                   call DosInt
  6209                                  
  6210                                  ;-252 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  6211 00003193 C9                       LEAVE
  6212 00003194 C3                       ret
  6213                                  ; ENDP
  6214                                  ;Number of CALLs:    2 : readRL
  6215                                  
  6216                                  readRL:  ; *** PROC ***
  6217                                  ;Function : readRL, Number of local variables: 3
  6218                                  ;   # type sign width line used address name   list of local variables
  6219                                  ;  200 ptr sign byte   252 NULL bp+4    s
  6220                                  ;  201 var sign word   252 NULL bp+6    fd
  6221                                  ;  202 var sign word   252 NULL bp+8    len;
  6222 00003195 C8000000                 ENTER  0,0
  6223 00003199 8B5604                   mov  dx, [bp+4]
  6224 0000319C 8B4E08                   mov  cx, [bp+8]
  6225 0000319F 8B5E06                   mov  bx, [bp+6]
  6226 000031A2 B8003F                   mov  ax, 16128
  6227 000031A5 E84B00                   call DosInt
  6228                                  
  6229                                  ;-253 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  6230 000031A8 C9                       LEAVE
  6231 000031A9 C3                       ret
  6232                                  ; ENDP
  6233                                  ;Number of CALLs:    2 : fputcR
  6234                                  
  6235                                  fputcR:  ; *** PROC ***
  6236                                  ;Function : fputcR, Number of local variables: 2
  6237                                  ;   # type sign width line used address name   list of local variables
  6238                                  ;  200 ptr sign byte   253 NULL bp+4    n
  6239                                  ;  201 var sign word   253 NULL bp+6    fd;
  6240 000031AA C8000000                 ENTER  0,0
  6241 000031AE 8D5604                  lea dx, [bp+4]
  6242                                  
  6243                                  ;-254   cx=1; bx=fd; ax=0x4000; DosInt(); }
  6244                                  
  6245 000031B1 B90100                   mov  cx, 1
  6246 000031B4 8B5E06                   mov  bx, [bp+6]
  6247 000031B7 B80040                   mov  ax, 16384
  6248 000031BA E83600                   call DosInt
  6249                                  
  6250                                  ;-255 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  6251 000031BD C9                       LEAVE
  6252 000031BE C3                       ret
  6253                                  ; ENDP
  6254                                  ;Number of CALLs:    3 : fcloseR
  6255                                  
  6256                                  fcloseR:  ; *** PROC ***
  6257                                  ;Function : fcloseR, Number of local variables: 1
  6258                                  ;   # type sign width line used address name   list of local variables
  6259                                  ;  200 var sign word   255 NULL bp+4    fd;
  6260 000031BF C8000000                 ENTER  0,0
  6261 000031C3 8B5E04                   mov  bx, [bp+4]
  6262 000031C6 B8003E                   mov  ax, 15872
  6263 000031C9 CD21                     int  33
  6264                                  
  6265                                  ;-256 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  6266 000031CB C9                       LEAVE
  6267 000031CC C3                       ret
  6268                                  ; ENDP
  6269                                  ;Number of CALLs:    5 : exitR
  6270                                  
  6271                                  exitR:  ; *** PROC ***
  6272                                  ;Function : exitR, Number of local variables: 1
  6273                                  ;   # type sign width line used address name   list of local variables
  6274                                  ;  200 var sign byte   256 NULL bp+4    c;
  6275 000031CD C8000000                 ENTER  0,0
  6276 000031D1 B44C                     mov  ah, 76
  6277 000031D3 8A4604                   mov  al, [bp+4]
  6278 000031D6 CD21                     int  33
  6279                                  
  6280                                  ;-257 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  6281 000031D8 C9                       LEAVE
  6282 000031D9 C3                       ret
  6283                                  ; ENDP
  6284                                  ;End of archive file. 
  6285                                   
  6286                                  ; missing functions: 
  6287                                  ; putch
  6288                                  ; DosInt
  6289                                  ; DosInt
  6290                                  ; DosInt
  6291                                  ; DosInt
  6292                                  ; Number of unresolved CALLs :    5
  6293                                  ;use archive file: AR.C
  6294                                  
  6295                                  ;-258 // AR.C Archive
  6296                                  
  6297                                  ;Number of CALLs:    1 : putch
  6298                                  
  6299                                  putch:  ; *** PROC ***
  6300                                  ;Function : putch, Number of local variables: 1
  6301                                  ;   # type sign width line used address name   list of local variables
  6302                                  ;  200 var sign byte   258 NULL bp+4    c;
  6303 000031DA C8000000                 ENTER  0,0
  6304 000031DE 807E040A                cmp byte [bp+4], 10
  6305 000031E2 0F850500                 jne @@putch261
  6306 000031E6 B00D                     mov  al, 13
  6307 000031E8 E8FFFD                   call writetty
  6308                                  @@putch261:
  6309 000031EB 8A4604                   mov  al, [bp+4]
  6310 000031EE E8F9FD                   call writetty
  6311                                  
  6312                                  ;-259 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  6313 000031F1 C9                       LEAVE
  6314 000031F2 C3                       ret
  6315                                  ; ENDP
  6316                                  ;Number of CALLs:    4 : DosInt
  6317                                  
  6318                                  DosInt:  ; *** PROC ***
  6319 000031F3 CD21                     int  33
  6320 000031F5 7304                     jae short @@DosInt262
  6321 000031F7 FF06[9F01]               inc  word [DOS_ERR]
  6322                                  @@DosInt262:
  6323                                  
  6324                                  ;-260 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  6325                                  
  6326 000031FB C3                       ret
  6327                                  ; ENDP
  6328                                  ;End of archive file. 
  6329                                   
  6330                                  ; missing functions:  All FUNCTIONs in place
  6331 000031FC E80000                  LastFunctionByt:db 0E8h, 0, 0
  6332 000031FF 58                      pop ax
  6333 00003200 C3                      ret
  6334                                   
  6335                                  ;   # type sign width line used  address name   list of global variables
  6336                                  
  6337                                  ;    1 arr sign byte     1    2        0 Version1[10]
  6338                                  ;    2 var sign byte     1    3        0 LIST
  6339                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  6340                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  6341                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  6342                                  ;    6 var unsg word     5   12        0 SymbolInt
  6343                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  6344                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  6345                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  6346                                  ;   10 arr sign byte     9    5        0 namein[67]
  6347                                  ;   11 arr sign byte    10    5        0 namelst[67]
  6348                                  ;   12 arr sign byte    11    5        0 namebin[67]
  6349                                  ;   13 var sign word    12    4        0 asm_fd
  6350                                  ;   14 var sign word    13    3        0 lst_fd
  6351                                  ;   15 var sign word    14    3        0 bin_fd
  6352                                  ;   16 var sign word    15    6        0 DOS_ERR
  6353                                  ;   17 var sign word    16    4        0 ErrorCount
  6354                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  6355                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  6356                                  ;   20 var unsg word    20    5        0 PC
  6357                                  ;   21 var unsg word    21    2        0 PCStart
  6358                                  ;   22 var sign byte    22    3        0 isLabel
  6359                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  6360                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  6361                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  6362                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  6363                                  ;   27 var sign byte    27   21        0 TokeType
  6364                                  ;   28 def unsg byte    28    -        0 BYTE=1
  6365                                  ;   29 def unsg byte    29    -        0 WORD=2
  6366                                  ;   30 def unsg byte    30    -        0 DWORD=3
  6367                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  6368                                  ;   32 def unsg byte    32    -        0 IMM=1
  6369                                  ;   33 def unsg byte    33    -        0 REG=2
  6370                                  ;   34 def unsg byte    34    -        0 ADR=3
  6371                                  ;   35 def unsg byte    35    -        0 MEM=4
  6372                                  ;   36 var sign byte    36   14        0 Op
  6373                                  ;   37 var sign byte    37   17        0 Op2
  6374                                  ;   38 var sign byte    38   13        0 CodeType
  6375                                  ;   39 var sign byte    39    9        0 Code1
  6376                                  ;   40 var sign byte    40    6        0 Code2
  6377                                  ;   41 var sign byte    41    3        0 Code3
  6378                                  ;   42 var sign byte    42   13        0 RegNo
  6379                                  ;   43 var sign byte    43    6        0 R1No
  6380                                  ;   44 var sign byte    44   14        0 RegType
  6381                                  ;   45 var sign byte    45    8        0 R1Type
  6382                                  ;   46 var sign byte    46   13        0 OpSize
  6383                                  ;   47 var sign byte    47    5        0 wflag
  6384                                  ;   48 var sign byte    49    7        0 sflag
  6385                                  ;   49 var sign byte    50   14        0 regindexbase
  6386                                  ;   50 var sign byte    51    3        0 isDirect
  6387                                  ;   51 var sign word    52   14        0 disp
  6388                                  ;   52 var sign word    53    6        0 imme
  6389                                  ;   53 def unsg byte    55    -        0 OPMAXLEN=5
  6390                                  ;   54 arr sign byte    56    2        0 OpPos[5]
  6391                                  ;   55 var sign word    57    6        0 OpPrintIndex
  6392                                  ;   56 ptr sign byte    58   17        0 OpCodePtr
  6393                                  ;   57 var sign byte    59    2        0 PrintR
  6394                                  ;   58 def unsg byte    61    -        0 LABELNAMESMAX=969
  6395                                  ;   59 arr sign byte    62    3        0 LabelNames[1000]
  6396                                  ;   60 ptr sign byte    63    5        0 LabelNamePtr
  6397                                  ;   61 def unsg byte    64    -        0 LABELADRMAX=100
  6398                                  ;   62 arr unsg word    65    3        0 LabelAddr[100]
  6399                                  ;   63 var sign word    66    4        0 LabelMaxIx
  6400                                  ;   64 var sign word    67    4        0 LabelIx
  6401                                  ;   65 def unsg byte    69    -        0 FILEBINMAX=2000
  6402                                  ;   66 arr sign byte    70    2        0 FileBin[2000]
  6403                                  ;   67 var unsg word    71    5        0 BinLen
  6404                                  ;   68 ptr sign byte    73    1        0 arglen
  6405                                  ;   69 ptr sign byte    74    4        0 argv
  6406                                  ;   70 var sign byte     1    1        0 I_START
  6407                                  ;   71 arr sign byte     4 NULL        0 I_PUSHA[9]
  6408                                  ;   72 arr sign byte     5 NULL        0 I_POPA[8]
  6409                                  ;   73 arr sign byte     6 NULL        0 I_NOP[7]
  6410                                  ;   74 arr sign byte     7 NULL        0 I_CBW[7]
  6411                                  ;   75 arr sign byte     8 NULL        0 I_CWDE[8]
  6412                                  ;   76 arr sign byte     9 NULL        0 I_CWD[7]
  6413                                  ;   77 arr sign byte    10 NULL        0 I_CDQ[7]
  6414                                  ;   78 arr sign byte    11 NULL        0 I_WAIT[8]
  6415                                  ;   79 arr sign byte    12 NULL        0 I_PUSHF[9]
  6416                                  ;   80 arr sign byte    13 NULL        0 I_POPF[8]
  6417                                  ;   81 arr sign byte    14 NULL        0 I_SAHF[8]
  6418                                  ;   82 arr sign byte    15 NULL        0 I_LAHF[8]
  6419                                  ;   83 arr sign byte    16 NULL        0 I_MOVSB[9]
  6420                                  ;   84 arr sign byte    17 NULL        0 I_MOVSW[9]
  6421                                  ;   85 arr sign byte    18 NULL        0 I_CMPSB[9]
  6422                                  ;   86 arr sign byte    19 NULL        0 I_CMPSW[9]
  6423                                  ;   87 arr sign byte    20 NULL        0 I_STOSB[9]
  6424                                  ;   88 arr sign byte    21 NULL        0 I_STOSW[9]
  6425                                  ;   89 arr sign byte    22 NULL        0 I_LODSB[9]
  6426                                  ;   90 arr sign byte    23 NULL        0 I_LODSW[9]
  6427                                  ;   91 arr sign byte    24 NULL        0 I_SCASB[9]
  6428                                  ;   92 arr sign byte    25 NULL        0 I_SCASW[9]
  6429                                  ;   93 arr sign byte    26 NULL        0 I_LEAVE[9]
  6430                                  ;   94 arr sign byte    27 NULL        0 I_IRET[8]
  6431                                  ;   95 arr sign byte    28 NULL        0 I_XLAT[8]
  6432                                  ;   96 arr sign byte    29 NULL        0 I_LOCK[8]
  6433                                  ;   97 arr sign byte    30 NULL        0 I_REPNE[9]
  6434                                  ;   98 arr sign byte    31 NULL        0 I_REPNZ[9]
  6435                                  ;   99 arr sign byte    32 NULL        0 I_REPE[8]
  6436                                  ;  100 arr sign byte    33 NULL        0 I_REPZ[8]
  6437                                  ;  101 arr sign byte    34 NULL        0 I_HLT[7]
  6438                                  ;  102 arr sign byte    35 NULL        0 I_CLC[7]
  6439                                  ;  103 arr sign byte    36 NULL        0 I_STC[7]
  6440                                  ;  104 arr sign byte    37 NULL        0 I_CLI[7]
  6441                                  ;  105 arr sign byte    38 NULL        0 I_STI[7]
  6442                                  ;  106 arr sign byte    39 NULL        0 I_CLD[7]
  6443                                  ;  107 arr sign byte    40 NULL        0 I_STD[7]
  6444                                  ;  108 arr sign byte    42 NULL        0 I_INC[9]
  6445                                  ;  109 arr sign byte    43 NULL        0 I_DEC[9]
  6446                                  ;  110 arr sign byte    44 NULL        0 I_NOT[8]
  6447                                  ;  111 arr sign byte    45 NULL        0 I_NEG[8]
  6448                                  ;  112 arr sign byte    46 NULL        0 I_MUL[8]
  6449                                  ;  113 arr sign byte    47 NULL        0 I_IMUL[9]
  6450                                  ;  114 arr sign byte    48 NULL        0 I_DIV[8]
  6451                                  ;  115 arr sign byte    49 NULL        0 I_IDIV[9]
  6452                                  ;  116 arr sign byte    51 NULL        0 I_LES[7]
  6453                                  ;  117 arr sign byte    52 NULL        0 I_LDS[7]
  6454                                  ;  118 arr sign byte    53 NULL        0 I_LEA[7]
  6455                                  ;  119 arr sign byte    54 NULL        0 I_LSS[8]
  6456                                  ;  120 arr sign byte    55 NULL        0 I_LFS[8]
  6457                                  ;  121 arr sign byte    56 NULL        0 I_LGS[8]
  6458                                  ;  122 arr sign byte    58 NULL        0 I_ADD[7]
  6459                                  ;  123 arr sign byte    59 NULL        0 I_OR[6]
  6460                                  ;  124 arr sign byte    60 NULL        0 I_ADC[7]
  6461                                  ;  125 arr sign byte    61 NULL        0 I_SBB[7]
  6462                                  ;  126 arr sign byte    62 NULL        0 I_AND[7]
  6463                                  ;  127 arr sign byte    63 NULL        0 I_SUB[7]
  6464                                  ;  128 arr sign byte    64 NULL        0 I_XOR[7]
  6465                                  ;  129 arr sign byte    65 NULL        0 I_CMP[7]
  6466                                  ;  130 arr sign byte    66 NULL        0 I_TEST[11]
  6467                                  ;  131 arr sign byte    68 NULL        0 I_MOV[6]
  6468                                  ;  132 arr sign byte    69 NULL        0 I_MOVSX[9]
  6469                                  ;  133 arr sign byte    70 NULL        0 I_MOVZX[9]
  6470                                  ;  134 arr sign byte    72 NULL        0 I_JO[6]
  6471                                  ;  135 arr sign byte    73 NULL        0 I_JNO[7]
  6472                                  ;  136 arr sign byte    74 NULL        0 I_JB[6]
  6473                                  ;  137 arr sign byte    75 NULL        0 I_JC[6]
  6474                                  ;  138 arr sign byte    76 NULL        0 I_JNB[7]
  6475                                  ;  139 arr sign byte    77 NULL        0 I_JAE[7]
  6476                                  ;  140 arr sign byte    78 NULL        0 I_JNC[7]
  6477                                  ;  141 arr sign byte    79 NULL        0 I_JE[6]
  6478                                  ;  142 arr sign byte    80 NULL        0 I_JZ[6]
  6479                                  ;  143 arr sign byte    81 NULL        0 I_JNE[7]
  6480                                  ;  144 arr sign byte    82 NULL        0 I_JNZ[7]
  6481                                  ;  145 arr sign byte    83 NULL        0 I_JBE[7]
  6482                                  ;  146 arr sign byte    84 NULL        0 I_JNA[7]
  6483                                  ;  147 arr sign byte    85 NULL        0 I_JA[6]
  6484                                  ;  148 arr sign byte    86 NULL        0 I_JS[6]
  6485                                  ;  149 arr sign byte    87 NULL        0 I_JNS[7]
  6486                                  ;  150 arr sign byte    88 NULL        0 I_JP[6]
  6487                                  ;  151 arr sign byte    89 NULL        0 I_JPE[7]
  6488                                  ;  152 arr sign byte    90 NULL        0 I_JNP[7]
  6489                                  ;  153 arr sign byte    91 NULL        0 I_JPO[7]
  6490                                  ;  154 arr sign byte    92 NULL        0 I_JL[6]
  6491                                  ;  155 arr sign byte    93 NULL        0 I_JNL[7]
  6492                                  ;  156 arr sign byte    94 NULL        0 I_JGE[7]
  6493                                  ;  157 arr sign byte    95 NULL        0 I_JLE[7]
  6494                                  ;  158 arr sign byte    96 NULL        0 I_JNG[7]
  6495                                  ;  159 arr sign byte    97 NULL        0 I_JG[6]
  6496                                  ;  160 arr sign byte    99 NULL        0 I_JMP[8]
  6497                                  ;  161 arr sign byte   100 NULL        0 I_CALL[9]
  6498                                  ;  162 arr sign byte   102 NULL        0 I_RET[8]
  6499                                  ;  163 arr sign byte   103 NULL        0 I_RETF[9]
  6500                                  ;  164 arr sign byte   105 NULL        0 I_PUSH[8]
  6501                                  ;  165 arr sign byte   106 NULL        0 I_POP[7]
  6502                                  ;  166 arr sign byte   108 NULL        0 I_ROL[7]
  6503                                  ;  167 arr sign byte   109 NULL        0 I_ROR[7]
  6504                                  ;  168 arr sign byte   110 NULL        0 I_RCL[7]
  6505                                  ;  169 arr sign byte   111 NULL        0 I_RCR[7]
  6506                                  ;  170 arr sign byte   112 NULL        0 I_SHL[7]
  6507                                  ;  171 arr sign byte   113 NULL        0 I_SAL[7]
  6508                                  ;  172 arr sign byte   114 NULL        0 I_SHR[7]
  6509                                  ;  173 arr sign byte   115 NULL        0 I_SAR[7]
  6510                                  ;  174 arr sign byte   117 NULL        0 I_INT[8]
  6511                                  ;  175 arr sign byte   118 NULL        0 I_INTO[8]
  6512                                  ;  176 arr sign byte   129 NULL        0 I_XCHG[9]
  6513                                  ;  177 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6514                                  ;  178 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6515                                  ;  179 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6516                                  ;  180 arr sign byte   134 NULL        0 I_LOOPE[9]
  6517                                  ;  181 arr sign byte   135 NULL        0 I_LOOP[8]
  6518                                  ;  182 arr sign byte   136 NULL        0 I_JCXZ[8]
  6519                                  ;  183 arr sign byte   137 NULL        0 I_JECXZ[9]
  6520                                  ;  184 arr sign byte   139 NULL        0 I_ENTER[9]
  6521                                  ;  185 arr sign byte   141 NULL        0 I_ORG[6]
  6522                                  ;  186 arr sign byte   146 NULL        0 I_DB[5]
  6523                                  ;  187 arr sign byte   147 NULL        0 I_DW[5]
  6524                                  ;  188 arr sign byte   148 NULL        0 I_DD[5]
  6525                                  ;  189 arr sign byte   149 NULL        0 I_RESB[7]
  6526                                  ;  190 arr sign byte   150 NULL        0 I_RESW[7]
  6527                                  ;  191 arr sign byte   151 NULL        0 I_RESD[7]
  6528                                  ;  192 var sign byte   152 NULL        0 I_END
  6529                                  
  6530                                  
  6531                                  ;   # Calls Line Width  Name   list of functions
  6532                                  
  6533                                  ;    0    1    1 word   parse
  6534                                  ;    1   14   27 word   getTokeType
  6535                                  ;    2    2   36 word   storeLabel
  6536                                  ;    3    2   46 word   searchLabel
  6537                                  ;    4    1   57 word   getVariable
  6538                                  ;    5    2   86 word   lookCode
  6539                                  ;    6    1  101 word   getCodeSize
  6540                                  ;    7    8  108 word   isToken
  6541                                  ;    8    2  113 word   need
  6542                                  ;    9    1  123 word   skipRest
  6543                                  ;   10    1    1 word   getLine
  6544                                  ;   11    1   17 word   ifEOL
  6545                                  ;   12    3   24 word   skipBlank
  6546                                  ;   13    2   29 word   letterE
  6547                                  ;   14    1   39 word   alnumE
  6548                                  ;   15    1   44 word   getDigit
  6549                                  ;   16    1   56 word   getName
  6550                                  ;   17    1   75 word   testReg
  6551                                  ;   18    1    1 word   printLine
  6552                                  ;   19    8   19 word   prc
  6553                                  ;   20    1   23 word   prscomment
  6554                                  ;   21   21   26 word   prs
  6555                                  ;   22    3   31 word   printhex8a
  6556                                  ;   23    1   35 word   printhex16
  6557                                  ;   24    3   38 word   printIntU
  6558                                  ;   25   25   45 word   error1
  6559                                  ;   26 NULL   48 word   allowederror
  6560                                  ;   27    2   49 word   addrerror
  6561                                  ;   28    1   50 word   immeerror
  6562                                  ;   29    2   51 word   implerror
  6563                                  ;   30    4   52 word   indexerror
  6564                                  ;   31    2   53 word   invaloperror
  6565                                  ;   32    1   54 word   numbererror
  6566                                  ;   33 NULL   55 word   regmemerror
  6567                                  ;   34    1   56 word   reg16error
  6568                                  ;   35    1   57 word   segregerror
  6569                                  ;   36    2   58 word   syntaxerror
  6570                                  ;   37   12   60 word   errorexit
  6571                                  ;   38 NULL   61 word   addrexit
  6572                                  ;   39 NULL   62 word   internexit
  6573                                  ;   40 NULL    1 word   main
  6574                                  ;   41    1    8 word   getarg
  6575                                  ;   42    1   38 word   epilog
  6576                                  ;   43    2   67 word   end1
  6577                                  ;   44    1    2 word   getCodes
  6578                                  ;   45    1    7 word   gen66h
  6579                                  ;   46    2    9 word   genCode
  6580                                  ;   47    5   13 word   genCodeW
  6581                                  ;   48   16   17 word   genCode8
  6582                                  ;   49    4   28 word   genCode16
  6583                                  ;   50    5   32 word   writeEA
  6584                                  ;   51    2   85 word   genImmediate
  6585                                  ;   52    1   11 word   process
  6586                                  ;   53    1  117 word   checkOpL
  6587                                  ;   54    1  137 word   get2Ops
  6588                                  ;   55    3  142 word   getOpL
  6589                                  ;   56    3  151 word   getOpR
  6590                                  ;   57    2  161 word   getOp1
  6591                                  ;   58    1  177 word   getMEM
  6592                                  ;   59    1  199 word   getIndReg1
  6593                                  ;   60    1  207 word   getIndReg2
  6594                                  ;   61    2  218 word   setwflag
  6595                                  ;   62    1  230 word   setsflag
  6596                                  ;   63    4  238 word   writetty
  6597                                  ;   64    8  239 word   cputs
  6598                                  ;   65    2  240 word   toupper
  6599                                  ;   66    3  242 word   strlen
  6600                                  ;   67    6  243 word   strcpy
  6601                                  ;   68    3  245 word   digit
  6602                                  ;   69   35  246 word   eqstr
  6603                                  ;   70    3  249 word   strcat1
  6604                                  ;   71    1  250 word   openR
  6605                                  ;   72    2  251 word   creatR
  6606                                  ;   73    2  252 word   readRL
  6607                                  ;   74    2  253 word   fputcR
  6608                                  ;   75    3  255 word   fcloseR
  6609                                  ;   76    5  256 word   exitR
  6610                                  ;   77    1  258 word   putch
  6611                                  ;   78    4  259 word   DosInt
  6612                                  ;   79 NULL  260 word   LastFunctionByt
  6613                                  
  6614                                  ;    #  addr name   list of CALLs
  6615                                  
  6616                                  ;    0  1345 getLine
  6617                                  ;    1  1353 getTokeType
  6618                                  ;    2  1365 storeLabel
  6619                                  ;    3  1376 getTokeType
  6620                                  ;    4  1388 lookCode
  6621                                  ;    5  1397 process
  6622                                  ;    6  1405 getVariable
  6623                                  ;    7  1417 skipRest
  6624                                  ;    8  1426 error1
  6625                                  ;    9  1433 error1
  6626                                  ;   10  1440 printLine
  6627                                  ;   11  1464 skipBlank
  6628                                  ;   12  1474 digit
  6629                                  ;   13  1480 getDigit
  6630                                  ;   14  1489 letterE
  6631                                  ;   15  1497 getName
  6632                                  ;   16  1518 searchLabel
  6633                                  ;   17  1530 error1
  6634                                  ;   18  1537 strcpy
  6635                                  ;   19  1544 errorexit
  6636                                  ;   20  1554 errorexit
  6637                                  ;   21  1584 eqstr
  6638                                  ;   22  1590 strlen
  6639                                  ;   23  1611 storeLabel
  6640                                  ;   24  1622 getTokeType
  6641                                  ;   25  1634 lookCode
  6642                                  ;   26  1643 errorexit
  6643                                  ;   27  1653 errorexit
  6644                                  ;   28  1663 getTokeType
  6645                                  ;   29  1675 genCode8
  6646                                  ;   30  1684 skipBlank
  6647                                  ;   31  1694 isToken
  6648                                  ;   32  1702 genCode8
  6649                                  ;   33  1711 isToken
  6650                                  ;   34  1719 getTokeType
  6651                                  ;   35  1731 genCode16
  6652                                  ;   36  1741 isToken
  6653                                  ;   37  1749 errorexit
  6654                                  ;   38  1768 eqstr
  6655                                  ;   39  1786 eqstr
  6656                                  ;   40  1792 getTokeType
  6657                                  ;   41  1804 eqstr
  6658                                  ;   42  1810 getTokeType
  6659                                  ;   43  1822 eqstr
  6660                                  ;   44  1828 getTokeType
  6661                                  ;   45  1850 skipBlank
  6662                                  ;   46  1867 isToken
  6663                                  ;   47  1875 getTokeType
  6664                                  ;   48  1887 error1
  6665                                  ;   49  1894 prs
  6666                                  ;   50  1898 prc
  6667                                  ;   51  1911 getTokeType
  6668                                  ;   52  1923 error1
  6669                                  ;   53  1940 readRL
  6670                                  ;   54  1947 errorexit
  6671                                  ;   55  1957 errorexit
  6672                                  ;   56  1967 ifEOL
  6673                                  ;   57  1981 readRL
  6674                                  ;   58  2017 digit
  6675                                  ;   59  2023 letterE
  6676                                  ;   60  2050 digit
  6677                                  ;   61  2070 alnumE
  6678                                  ;   62  2077 errorexit
  6679                                  ;   63  2087 strcpy
  6680                                  ;   64  2094 toupper
  6681                                  ;   65  2110 strlen
  6682                                  ;   66  2117 strlen
  6683                                  ;   67  2124 eqstr
  6684                                  ;   68  2130 eqstr
  6685                                  ;   69  2136 eqstr
  6686                                  ;   70  2142 eqstr
  6687                                  ;   71  2148 eqstr
  6688                                  ;   72  2154 eqstr
  6689                                  ;   73  2160 eqstr
  6690                                  ;   74  2166 eqstr
  6691                                  ;   75  2172 eqstr
  6692                                  ;   76  2178 eqstr
  6693                                  ;   77  2184 eqstr
  6694                                  ;   78  2190 eqstr
  6695                                  ;   79  2196 eqstr
  6696                                  ;   80  2202 eqstr
  6697                                  ;   81  2208 eqstr
  6698                                  ;   82  2214 eqstr
  6699                                  ;   83  2220 eqstr
  6700                                  ;   84  2226 eqstr
  6701                                  ;   85  2232 eqstr
  6702                                  ;   86  2238 eqstr
  6703                                  ;   87  2244 eqstr
  6704                                  ;   88  2250 eqstr
  6705                                  ;   89  2256 eqstr
  6706                                  ;   90  2262 eqstr
  6707                                  ;   91  2268 eqstr
  6708                                  ;   92  2274 eqstr
  6709                                  ;   93  2280 eqstr
  6710                                  ;   94  2286 eqstr
  6711                                  ;   95  2292 eqstr
  6712                                  ;   96  2298 eqstr
  6713                                  ;   97  2318 prs
  6714                                  ;   98  2322 printhex16
  6715                                  ;   99  2333 prs
  6716                                  ;  100  2337 prc
  6717                                  ;  101  2341 printhex8a
  6718                                  ;  102  2352 prc
  6719                                  ;  103  2356 prs
  6720                                  ;  104  2360 prscomment
  6721                                  ;  105  2377 writetty
  6722                                  ;  106  2386 writetty
  6723                                  ;  107  2395 fputcR
  6724                                  ;  108  2417 prc
  6725                                  ;  109  2433 prc
  6726                                  ;  110  2454 prc
  6727                                  ;  111  2458 prc
  6728                                  ;  112  2480 printhex8a
  6729                                  ;  113  2491 printhex8a
  6730                                  ;  114  2516 printIntU
  6731                                  ;  115  2526 prc
  6732                                  ;  116  2539 prs
  6733                                  ;  117  2543 prs
  6734                                  ;  118  2547 prs
  6735                                  ;  119  2551 prs
  6736                                  ;  120  2568 error1
  6737                                  ;  121  2585 error1
  6738                                  ;  122  2602 error1
  6739                                  ;  123  2619 error1
  6740                                  ;  124  2637 error1
  6741                                  ;  125  2657 error1
  6742                                  ;  126  2676 error1
  6743                                  ;  127  2695 error1
  6744                                  ;  128  2713 error1
  6745                                  ;  129  2732 error1
  6746                                  ;  130  2751 error1
  6747                                  ;  131  2770 error1
  6748                                  ;  132  2777 end1
  6749                                  ;  133  2791 errorexit
  6750                                  ;  134  2812 errorexit
  6751                                  ;  135  2827 getarg
  6752                                  ;  136  2834 parse
  6753                                  ;  137  2840 epilog
  6754                                  ;  138  2847 end1
  6755                                  ;  139  2871 cputs
  6756                                  ;  140  2877 cputs
  6757                                  ;  141  2883 exitR
  6758                                  ;  142  2889 toupper
  6759                                  ;  143  2897 strcpy
  6760                                  ;  144  2904 strcat1
  6761                                  ;  145  2912 strcpy
  6762                                  ;  146  2919 strcat1
  6763                                  ;  147  2927 strcpy
  6764                                  ;  148  2934 strcat1
  6765                                  ;  149  2942 openR
  6766                                  ;  150  2948 cputs
  6767                                  ;  151  2954 cputs
  6768                                  ;  152  2960 exitR
  6769                                  ;  153  2966 creatR
  6770                                  ;  154  2973 cputs
  6771                                  ;  155  2979 cputs
  6772                                  ;  156  2985 exitR
  6773                                  ;  157  2991 creatR
  6774                                  ;  158  2998 cputs
  6775                                  ;  159  3004 cputs
  6776                                  ;  160  3010 exitR
  6777                                  ;  161  3016 prs
  6778                                  ;  162  3020 prs
  6779                                  ;  163  3024 prs
  6780                                  ;  164  3028 prs
  6781                                  ;  165  3032 prs
  6782                                  ;  166  3036 prs
  6783                                  ;  167  3040 prs
  6784                                  ;  168  3044 prs
  6785                                  ;  169  3048 prs
  6786                                  ;  170  3065 prs
  6787                                  ;  171  3069 printIntU
  6788                                  ;  172  3079 prs
  6789                                  ;  173  3083 prs
  6790                                  ;  174  3087 printIntU
  6791                                  ;  175  3097 prs
  6792                                  ;  176  3101 fputcR
  6793                                  ;  177  3115 fcloseR
  6794                                  ;  178  3123 fcloseR
  6795                                  ;  179  3131 fcloseR
  6796                                  ;  180  3139 exitR
  6797                                  ;  181  3161 genCode8
  6798                                  ;  182  3182 genCode8
  6799                                  ;  183  3202 genCode8
  6800                                  ;  184  3222 errorexit
  6801                                  ;  185  3244 genCode8
  6802                                  ;  186  3253 genCode8
  6803                                  ;  187  3278 addrerror
  6804                                  ;  188  3288 immeerror
  6805                                  ;  189  3298 invaloperror
  6806                                  ;  190  3311 genCode8
  6807                                  ;  191  3320 genCode8
  6808                                  ;  192  3329 genCode16
  6809                                  ;  193  3352 genCode8
  6810                                  ;  194  3361 genCode16
  6811                                  ;  195  3371 genCode8
  6812                                  ;  196  3390 getTokeType
  6813                                  ;  197  3402 getCodeSize
  6814                                  ;  198  3414 getCodes
  6815                                  ;  199  3423 genCode8
  6816                                  ;  200  3432 getOpL
  6817                                  ;  201  3439 checkOpL
  6818                                  ;  202  3448 genCode
  6819                                  ;  203  3456 genCode
  6820                                  ;  204  3464 getTokeType
  6821                                  ;  205  3476 implerror
  6822                                  ;  206  3486 genCodeW
  6823                                  ;  207  3495 writeEA
  6824                                  ;  208  3503 getOpL
  6825                                  ;  209  3510 reg16error
  6826                                  ;  210  3521 need
  6827                                  ;  211  3526 getOpR
  6828                                  ;  212  3533 addrerror
  6829                                  ;  213  3543 genCode8
  6830                                  ;  214  3552 genCode8
  6831                                  ;  215  3561 writeEA
  6832                                  ;  216  3569 get2Ops
  6833                                  ;  217  3577 setwflag
  6834                                  ;  218  3586 setsflag
  6835                                  ;  219  3595 genCodeW
  6836                                  ;  220  3604 genImmediate
  6837                                  ;  221  3617 genCodeW
  6838                                  ;  222  3626 writeEA
  6839                                  ;  223  3634 genImmediate
  6840                                  ;  224  3647 genCodeW
  6841                                  ;  225  3656 writeEA
  6842                                  ;  226  3664 genCodeW
  6843                                  ;  227  3673 writeEA
  6844                                  ;  228  3681 syntaxerror
  6845                                  ;  229  3693 genCode8
  6846                                  ;  230  3702 genCode16
  6847                                  ;  231  3712 genCode8
  6848                                  ;  232  3721 error1
  6849                                  ;  233  3728 error1
  6850                                  ;  234  3744 implerror
  6851                                  ;  235  3754 segregerror
  6852                                  ;  236  3766 setwflag
  6853                                  ;  237  3775 error1
  6854                                  ;  238  3782 error1
  6855                                  ;  239  3789 error1
  6856                                  ;  240  3804 getOpL
  6857                                  ;  241  3811 need
  6858                                  ;  242  3816 getOpR
  6859                                  ;  243  3830 getOpR
  6860                                  ;  244  3844 getOp1
  6861                                  ;  245  3851 isToken
  6862                                  ;  246  3859 getMEM
  6863                                  ;  247  3866 invaloperror
  6864                                  ;  248  3879 error1
  6865                                  ;  249  3893 testReg
  6866                                  ;  250  3901 searchLabel
  6867                                  ;  251  3913 error1
  6868                                  ;  252  3929 getTokeType
  6869                                  ;  253  3941 getOp1
  6870                                  ;  254  3948 syntaxerror
  6871                                  ;  255  3960 getIndReg2
  6872                                  ;  256  3971 getIndReg1
  6873                                  ;  257  3982 isToken
  6874                                  ;  258  3990 getTokeType
  6875                                  ;  259  4002 numbererror
  6876                                  ;  260  4014 isToken
  6877                                  ;  261  4022 isToken
  6878                                  ;  262  4030 errorexit
  6879                                  ;  263  4051 indexerror
  6880                                  ;  264  4062 indexerror
  6881                                  ;  265  4086 indexerror
  6882                                  ;  266  4097 indexerror
  6883                                  ;  267  4117 gen66h
  6884                                  ;  268  4133 error1
  6885                                  ;  269  4159 putch
  6886                                  ;  270  4227 strcpy
  6887                                  ;  271  4242 DosInt
  6888                                  ;  272  4258 DosInt
  6889                                  ;  273  4281 DosInt
  6890                                  ;  274  4300 DosInt
  6891                                  ;  275  4334 writetty
  6892                                  ;  276  4343 writetty
  6893                                  ;Input: AS.C, List: AS.S,  Lines:  261
  6894                                  ;Glob. variables:  192 max.:  200
  6895                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  6896                                  ;Functions      :   80 max.:  300
  6897                                  ;Calls          :  277 max.: 2000, NameField: 4375 max.:    65535
  6898                                  ;Code until     :25998 max.: 30000, free: 4002
  6899                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  6900                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
