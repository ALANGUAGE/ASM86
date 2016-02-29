     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E90D23                  jmp main
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
   208                                  ;-53 unsigned int imme;      //immediate         0-8 bytes
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
   230                                  ;-59 char PrintR;            //print 'R' if relocative
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
   968 00001252 E85B16                   call process
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
   992 0000126D E8960E                   call error1
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
  1003 00001282 E8810E                   call error1
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
  1082 0000131A E8BB1D                   call digit
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
  1142 00001386 E87D0D                   call error1
  1143 00001389 83C402                   add  sp, 2
  1144                                  
  1145                                  ;-38   LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  1146                                  
  1147                                  @@storeLabel16:
  1148 0000138C 8D06[0F00]               lea  ax, [Symbol]
  1149 00001390 50                       push ax
  1150 00001391 FF36[B105]               push word [LabelNamePtr]
  1151 00001395 E8071D                   call strcpy
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
  1171 000013B8 E8AA0D                   call errorexit
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
  1185 000013CF E8930D                   call errorexit
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
  1244 0000143F E8C91C                   call eqstr
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
  1255 00001454 E81D1C                   call strlen
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
  1313 0000149B E8C70C                   call errorexit
  1314 0000149E 83C402                   add  sp, 2
  1315                                  
  1316                                  ;-62     if (CodeType > 207) errorexit("D or RES B,W,D expected");
  1317                                  
  1318                                  @@getVariable23:
  1319 000014A1 A0[AE01]                 mov al, [CodeType]
  1320 000014A4 3CCF                     cmp al, 207
  1321 000014A6 0F8E0900                 jle @@getVariable24
  1322 000014AA 68[7B15]                 push getVariable_1
  1323 000014AD E8B50C                   call errorexit
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
  1344 000014CC E8ED11                   call genCode8
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
  1377 000014F7 E8C211                   call genCode8
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
  1437 0000153F E8D111                   call genCode16
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
  1463 0000155B E8070C                   call errorexit
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
  1510 000015CD E83B1B                   call eqstr
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
  1594 0000163C E8CC1A                   call eqstr
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
  1608 0000165C E8AC1A                   call eqstr
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
  1622 0000167C E88C1A                   call eqstr
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
  1715 000016F8 E80B0A                   call error1
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
  1756 0000172A E8D909                   call error1
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
  1806 00001765 E83E1A                   call readRL
  1807 00001768 83C406                   add  sp, 6
  1808 0000176B A3[A301]                 mov word [DOS_NoBytes], ax
  1809                                  
  1810                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  1811                                  
  1812 0000176E A1[9F01]                 mov ax, [DOS_ERR]
  1813 00001771 08C0                     or  al, al
  1814 00001773 0F840900                 je @@getLine53
  1815 00001777 68[DC17]                 push getLine_0
  1816 0000177A E8E809                   call errorexit
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
  1850 000017B0 E8B209                   call errorexit
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
  1917 00001829 E87A19                   call readRL
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
  2075 00001911 E8C417                   call digit
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
  2168 00001993 E84217                   call digit
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
  2253 000019FA E86807                   call errorexit
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
  2291 00001A38 E86416                   call strcpy
  2292 00001A3B 83C404                   add  sp, 4
  2293                                  
  2294                                  ;-73   toupper(SymbolUpper);
  2295                                  
  2296 00001A3E 8D06[2E00]               lea  ax, [SymbolUpper]
  2297 00001A42 50                       push ax
  2298 00001A43 E8EB15                   call toupper
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
  2325 00001A69 E80816                   call strlen
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
  2337 00001A83 E8EE15                   call strlen
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
  2355 00001AA9 E85F16                   call eqstr
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
  2368 00001AC6 E84216                   call eqstr
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
  2381 00001AE3 E82516                   call eqstr
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
  2394 00001B00 E80816                   call eqstr
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
  2407 00001B1D E8EB15                   call eqstr
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
  2420 00001B3A E8CE15                   call eqstr
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
  2433 00001B57 E8B115                   call eqstr
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
  2446 00001B74 E89415                   call eqstr
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
  2464 00001B9A E86E15                   call eqstr
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
  2477 00001BB7 E85115                   call eqstr
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
  2490 00001BD4 E83415                   call eqstr
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
  2503 00001BF1 E81715                   call eqstr
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
  2516 00001C0E E8FA14                   call eqstr
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
  2529 00001C2B E8DD14                   call eqstr
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
  2542 00001C48 E8C014                   call eqstr
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
  2555 00001C65 E8A314                   call eqstr
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
  2573 00001C8B E87D14                   call eqstr
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
  2586 00001CA8 E86014                   call eqstr
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
  2599 00001CC5 E84314                   call eqstr
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
  2612 00001CE2 E82614                   call eqstr
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
  2625 00001CFF E80914                   call eqstr
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
  2638 00001D1C E8EC13                   call eqstr
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
  2656 00001D42 E8C613                   call eqstr
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
  2669 00001D5F E8A913                   call eqstr
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
  2682 00001D7C E88C13                   call eqstr
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
  2695 00001D99 E86F13                   call eqstr
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
  2708 00001DB6 E85213                   call eqstr
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
  2721 00001DD3 E83513                   call eqstr
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
  2734 00001DF0 E81813                   call eqstr
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
  2747 00001E0D E8FB12                   call eqstr
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
  2803                                  ;-1 int printLine() { 
  2804                                  
  2805                                  
  2806                                  printLine:  ; *** PROC ***
  2807                                  
  2808                                  ;-2     int i; char c;
  2809                                  
  2810                                  
  2811                                  ;-3     prs("\n"); 
  2812                                  
  2813                                  ;Function : printLine, Number of local variables: 2
  2814                                  ;   # type sign width line used address name   list of local variables
  2815                                  ;  200 var sign word     2 NULL bp-2    i
  2816                                  ;  201 var sign byte     2 NULL bp-4    c;
  2817 00001E97 C8040000                 ENTER  4,0
  2818 00001E9B 68[2C1F]                 push printLine_0
  2819 00001E9E E80401                   call prs
  2820 00001EA1 83C402                   add  sp, 2
  2821                                  
  2822                                  ;-4     printhex16(PCStart);
  2823                                  
  2824 00001EA4 FF36[A801]               push word [PCStart]
  2825 00001EA8 E8EF01                   call printhex16
  2826 00001EAB 83C402                   add  sp, 2
  2827                                  
  2828                                  ;-5     if (OpPrintIndex == 0) prs("                ");
  2829                                  
  2830 00001EAE A1[C401]                 mov ax, [OpPrintIndex]
  2831 00001EB1 83F800                   cmp ax, 0
  2832 00001EB4 0F850C00                 jne @@printLine110
  2833 00001EB8 68[2F1F]                 push printLine_1
  2834 00001EBB E8E700                   call prs
  2835 00001EBE 83C402                   add  sp, 2
  2836                                  
  2837                                  ;-6     else {
  2838                                  
  2839 00001EC1 E95B00                   jmp @@printLine111
  2840                                  @@printLine110:
  2841                                  
  2842                                  ;-7         prc(PrintR);
  2843                                  
  2844 00001EC4 A0[C801]                 mov al, byte [PrintR]
  2845 00001EC7 B400                     mov ah, 0
  2846 00001EC9 50                       push ax
  2847 00001ECA E87700                   call prc
  2848 00001ECD 83C402                   add  sp, 2
  2849                                  
  2850                                  ;-8         i=0;
  2851                                  
  2852 00001ED0 66B800000000             mov eax, 0
  2853 00001ED6 8946FE                   mov word [bp-2], ax
  2854                                  
  2855                                  ;-9         do {
  2856                                  
  2857                                  @@printLine112:
  2858                                  
  2859                                  ;-10             c=OpPos[i];
  2860                                  
  2861 00001ED9 8B5EFE                   mov bx, [bp-2]
  2862 00001EDC 8A87[BF01]               mov al, [OpPos + bx]
  2863 00001EE0 8846FC                   mov byte [bp-4], al
  2864                                  
  2865                                  ;-11             printhex8a(c); 
  2866                                  
  2867 00001EE3 8A46FC                   mov al, byte [bp-4]
  2868 00001EE6 B400                     mov ah, 0
  2869 00001EE8 50                       push ax
  2870 00001EE9 E85C01                   call printhex8a
  2871 00001EEC 83C402                   add  sp, 2
  2872                                  
  2873                                  ;-12             prc(' ');
  2874                                  
  2875 00001EEF 6A20                     push 32
  2876 00001EF1 E85000                   call prc
  2877 00001EF4 83C402                   add  sp, 2
  2878                                  
  2879                                  ;-13             i++;
  2880                                  
  2881 00001EF7 FF46FE                   inc  word [bp-2]
  2882                                  
  2883                                  ;-14         } while (i < OpPrintIndex);
  2884                                  
  2885 00001EFA 8B46FE                   mov ax, [bp-2]
  2886 00001EFD 3B06[C401]               cmp ax, [OpPrintIndex]
  2887 00001F01 0F8D0200                 jge @@printLine113
  2888 00001F05 EBD2                     jmp @@printLine112
  2889                                  @@printLine113:
  2890                                  
  2891                                  ;-15         do {// fill rest with blank
  2892                                  
  2893                                  @@printLine114:
  2894                                  
  2895                                  ;-16             prs("   ");
  2896                                  
  2897 00001F07 68[401F]                 push printLine_2
  2898 00001F0A E89800                   call prs
  2899 00001F0D 83C402                   add  sp, 2
  2900                                  
  2901                                  ;-17             i++;
  2902                                  
  2903 00001F10 FF46FE                   inc  word [bp-2]
  2904                                  
  2905                                  ;-18         } while (i < OPMAXLEN);
  2906                                  
  2907 00001F13 8B46FE                   mov ax, [bp-2]
  2908 00001F16 83F805                   cmp ax, 5
  2909 00001F19 0F8D0200                 jge @@printLine115
  2910 00001F1D EBE8                     jmp @@printLine114
  2911                                  @@printLine115:
  2912                                  
  2913                                  ;-19     }
  2914                                  
  2915                                  
  2916                                  ;-20     prscomment(InputBuf);
  2917                                  
  2918                                  @@printLine111:
  2919 00001F1F 8D06[4F00]               lea  ax, [InputBuf]
  2920 00001F23 50                       push ax
  2921 00001F24 E85000                   call prscomment
  2922 00001F27 83C402                   add  sp, 2
  2923                                  
  2924                                  ;-21 }
  2925                                  
  2926                                  
  2927                                  ;-22 int prc(unsigned char c) {//print char 
  2928 00001F2A C9                       LEAVE
  2929 00001F2B C3                       ret
  2930                                  ; ENDP
  2931 00001F2C 5C6E00                  printLine_0 db "\n",0
  2932 00001F2F 202020202020202020-     printLine_1 db "                ",0
  2933 00001F38 2020202020202000   
  2934 00001F40 20202000                printLine_2 db "   ",0
  2935                                  
  2936                                  prc:  ; *** PROC ***
  2937                                  
  2938                                  ;-23     if (LIST) { 
  2939                                  
  2940                                  ;Function : prc, Number of local variables: 1
  2941                                  ;   # type sign width line used address name   list of local variables
  2942                                  ;  200 var unsg byte    22 NULL bp+4    c;
  2943 00001F44 C8000000                 ENTER  0,0
  2944 00001F48 A0[0E00]                 mov al, [LIST]
  2945 00001F4B 08C0                     or  al, al
  2946 00001F4D 0F841400                 je @@prc116
  2947                                  
  2948                                  ;-24         if ( _ c==10) {
  2949                                  
  2950 00001F51 807E040A                cmp byte [bp+4], 10
  2951 00001F55 0F850600                 jne @@prc117
  2952                                  
  2953                                  ;-25             ax=13; 
  2954                                  
  2955 00001F59 B80D00                   mov  ax, 13
  2956                                  
  2957                                  ;-26             writetty(); 
  2958                                  
  2959 00001F5C E89C10                   call writetty
  2960                                  
  2961                                  ;-27             }
  2962                                  
  2963                                  
  2964                                  ;-28         al=c; 
  2965                                  
  2966                                  @@prc117:
  2967 00001F5F 8A4604                   mov  al, [bp+4]
  2968                                  
  2969                                  ;-29         writetty(); 
  2970                                  
  2971 00001F62 E89610                   call writetty
  2972                                  
  2973                                  ;-30         }
  2974                                  
  2975                                  
  2976                                  ;-31     fputcR(c,lst_fd); 
  2977                                  
  2978                                  @@prc116:
  2979 00001F65 FF36[9B01]               push word [lst_fd]
  2980 00001F69 8A4604                   mov al, byte [bp+4]
  2981 00001F6C B400                     mov ah, 0
  2982 00001F6E 50                       push ax
  2983 00001F6F E84912                   call fputcR
  2984 00001F72 83C404                   add  sp, 4
  2985                                  
  2986                                  ;-32 }
  2987                                  
  2988                                  
  2989                                  ;-33 
  2990                                  
  2991                                  
  2992                                  ;-34 int prscomment(unsigned char *s) {
  2993 00001F75 C9                       LEAVE
  2994 00001F76 C3                       ret
  2995                                  ; ENDP
  2996                                  
  2997                                  prscomment:  ; *** PROC ***
  2998                                  
  2999                                  ;-35     unsigned char c;
  3000                                  
  3001                                  
  3002                                  ;-36     while (*s){
  3003                                  
  3004                                  ;Function : prscomment, Number of local variables: 2
  3005                                  ;   # type sign width line used address name   list of local variables
  3006                                  ;  200 ptr unsg byte    34 NULL bp+4    s
  3007                                  ;  201 var unsg byte    35 NULL bp-2    c;
  3008 00001F77 C8020000                 ENTER  2,0
  3009                                  @@prscomment118:
  3010 00001F7B 8B5E04                   mov bx, [bp+4]
  3011 00001F7E 8A07                     mov al, [bx]
  3012 00001F80 B400                     mov ah, 0
  3013 00001F82 08C0                     or  al, al
  3014 00001F84 0F841B00                 je @@prscomment119
  3015                                  
  3016                                  ;-37         c=*s;
  3017                                  
  3018 00001F88 8B5E04                   mov bx, [bp+4]
  3019 00001F8B 8A07                     mov al, [bx]
  3020 00001F8D B400                     mov ah, 0
  3021 00001F8F 8846FE                   mov byte [bp-2], al
  3022                                  
  3023                                  ;-38         prc(c);
  3024                                  
  3025 00001F92 8A46FE                   mov al, byte [bp-2]
  3026 00001F95 B400                     mov ah, 0
  3027 00001F97 50                       push ax
  3028 00001F98 E8A9FF                   call prc
  3029 00001F9B 83C402                   add  sp, 2
  3030                                  
  3031                                  ;-39         s++;
  3032                                  
  3033 00001F9E FF4604                   inc  word [bp+4]
  3034                                  
  3035                                  ;-40     }
  3036                                  
  3037                                  
  3038                                  ;-41 }
  3039                                  
  3040 00001FA1 EBD8                     jmp @@prscomment118
  3041                                  @@prscomment119:
  3042                                  
  3043                                  ;-42 int prs(unsigned char *s) {
  3044 00001FA3 C9                       LEAVE
  3045 00001FA4 C3                       ret
  3046                                  ; ENDP
  3047                                  
  3048                                  prs:  ; *** PROC ***
  3049                                  
  3050                                  ;-43     unsigned char c; 
  3051                                  
  3052                                  
  3053                                  ;-44     int com; 
  3054                                  
  3055                                  
  3056                                  ;-45     com=0;
  3057                                  
  3058                                  ;Function : prs, Number of local variables: 3
  3059                                  ;   # type sign width line used address name   list of local variables
  3060                                  ;  200 ptr unsg byte    42 NULL bp+4    s
  3061                                  ;  201 var unsg byte    43 NULL bp-2    c
  3062                                  ;  202 var sign word    44 NULL bp-4    com;
  3063 00001FA5 C8040000                 ENTER  4,0
  3064 00001FA9 66B800000000             mov eax, 0
  3065 00001FAF 8946FC                   mov word [bp-4], ax
  3066                                  
  3067                                  ;-46     while (*s) { 
  3068                                  
  3069                                  @@prs120:
  3070 00001FB2 8B5E04                   mov bx, [bp+4]
  3071 00001FB5 8A07                     mov al, [bx]
  3072 00001FB7 B400                     mov ah, 0
  3073 00001FB9 08C0                     or  al, al
  3074 00001FBB 0F848700                 je @@prs121
  3075                                  
  3076                                  ;-47         c=*s; 
  3077                                  
  3078 00001FBF 8B5E04                   mov bx, [bp+4]
  3079 00001FC2 8A07                     mov al, [bx]
  3080 00001FC4 B400                     mov ah, 0
  3081 00001FC6 8846FE                   mov byte [bp-2], al
  3082                                  
  3083                                  ;-48         if (c==34) {
  3084                                  
  3085 00001FC9 8A46FE                   mov al, [bp-2]
  3086 00001FCC 3C22                     cmp al, 34
  3087 00001FCE 0F851E00                 jne @@prs122
  3088                                  
  3089                                  ;-49             if (com) com=0; 
  3090                                  
  3091 00001FD2 8B46FC                   mov ax, [bp-4]
  3092 00001FD5 08C0                     or  al, al
  3093 00001FD7 0F840C00                 je @@prs123
  3094 00001FDB 66B800000000             mov eax, 0
  3095 00001FE1 8946FC                   mov word [bp-4], ax
  3096                                  
  3097                                  ;-50                 else com=1;  
  3098                                  
  3099 00001FE4 E90900                   jmp @@prs124
  3100                                  @@prs123:
  3101 00001FE7 66B801000000             mov eax, 1
  3102 00001FED 8946FC                   mov word [bp-4], ax
  3103                                  
  3104                                  ;-51         }
  3105                                  
  3106                                  @@prs124:
  3107                                  
  3108                                  ;-52         if (c==92) { 
  3109                                  
  3110                                  @@prs122:
  3111 00001FF0 8A46FE                   mov al, [bp-2]
  3112 00001FF3 3C5C                     cmp al, 92
  3113 00001FF5 0F853B00                 jne @@prs125
  3114                                  
  3115                                  ;-53             if (com==0) { 
  3116                                  
  3117 00001FF9 8B46FC                   mov ax, [bp-4]
  3118 00001FFC 83F800                   cmp ax, 0
  3119 00001FFF 0F853100                 jne @@prs126
  3120                                  
  3121                                  ;-54                 s++; 
  3122                                  
  3123 00002003 FF4604                   inc  word [bp+4]
  3124                                  
  3125                                  ;-55                 c=*s;
  3126                                  
  3127 00002006 8B5E04                   mov bx, [bp+4]
  3128 00002009 8A07                     mov al, [bx]
  3129 0000200B B400                     mov ah, 0
  3130 0000200D 8846FE                   mov byte [bp-2], al
  3131                                  
  3132                                  ;-56                 if (c=='n') c=10; 
  3133                                  
  3134 00002010 8A46FE                   mov al, [bp-2]
  3135 00002013 3C6E                     cmp al, 110
  3136 00002015 0F850900                 jne @@prs127
  3137 00002019 66B80A000000             mov eax, 10
  3138 0000201F 8846FE                   mov byte [bp-2], al
  3139                                  
  3140                                  ;-57                 if (c=='t') c= 9; 
  3141                                  
  3142                                  @@prs127:
  3143 00002022 8A46FE                   mov al, [bp-2]
  3144 00002025 3C74                     cmp al, 116
  3145 00002027 0F850900                 jne @@prs128
  3146 0000202B 66B809000000             mov eax, 9
  3147 00002031 8846FE                   mov byte [bp-2], al
  3148                                  
  3149                                  ;-58             } 
  3150                                  
  3151                                  @@prs128:
  3152                                  
  3153                                  ;-59         } 
  3154                                  
  3155                                  @@prs126:
  3156                                  
  3157                                  ;-60         prc(c); 
  3158                                  
  3159                                  @@prs125:
  3160 00002034 8A46FE                   mov al, byte [bp-2]
  3161 00002037 B400                     mov ah, 0
  3162 00002039 50                       push ax
  3163 0000203A E807FF                   call prc
  3164 0000203D 83C402                   add  sp, 2
  3165                                  
  3166                                  ;-61         s++;  
  3167                                  
  3168 00002040 FF4604                   inc  word [bp+4]
  3169                                  
  3170                                  ;-62     }
  3171                                  
  3172                                  
  3173                                  ;-63 }
  3174                                  
  3175 00002043 E96CFF                   jmp @@prs120
  3176                                  @@prs121:
  3177                                  
  3178                                  ;-64 int printhex8a(unsigned char c) { 
  3179 00002046 C9                       LEAVE
  3180 00002047 C3                       ret
  3181                                  ; ENDP
  3182                                  
  3183                                  printhex8a:  ; *** PROC ***
  3184                                  
  3185                                  ;-65     unsigned char nib;
  3186                                  
  3187                                  
  3188                                  ;-66     nib = c >> 4; printhex4(nib);                    
  3189                                  
  3190                                  ;Function : printhex8a, Number of local variables: 2
  3191                                  ;   # type sign width line used address name   list of local variables
  3192                                  ;  200 var unsg byte    64 NULL bp+4    c
  3193                                  ;  201 var unsg byte    65 NULL bp-2    nib;
  3194 00002048 C8020000                 ENTER  2,0
  3195 0000204C 8A4604                   mov al, [bp+4]
  3196 0000204F C0E804                   shr al, 4
  3197 00002052 8846FE                   mov byte [bp-2], al
  3198 00002055 8A46FE                   mov al, byte [bp-2]
  3199 00002058 B400                     mov ah, 0
  3200 0000205A 50                       push ax
  3201 0000205B E81900                   call printhex4
  3202 0000205E 83C402                   add  sp, 2
  3203                                  
  3204                                  ;-67     nib = c & 15; printhex4(nib);                    
  3205                                  
  3206 00002061 8A4604                   mov al, [bp+4]
  3207 00002064 240F                     and al, 15
  3208 00002066 8846FE                   mov byte [bp-2], al
  3209 00002069 8A46FE                   mov al, byte [bp-2]
  3210 0000206C B400                     mov ah, 0
  3211 0000206E 50                       push ax
  3212 0000206F E80500                   call printhex4
  3213 00002072 83C402                   add  sp, 2
  3214                                  
  3215                                  ;-68 } 
  3216                                  
  3217                                  
  3218                                  ;-69 int printhex4(unsigned char c) {
  3219 00002075 C9                       LEAVE
  3220 00002076 C3                       ret
  3221                                  ; ENDP
  3222                                  
  3223                                  printhex4:  ; *** PROC ***
  3224                                  
  3225                                  ;-70     c += 48; 
  3226                                  
  3227                                  ;Function : printhex4, Number of local variables: 1
  3228                                  ;   # type sign width line used address name   list of local variables
  3229                                  ;  200 var unsg byte    69 NULL bp+4    c;
  3230 00002077 C8000000                 ENTER  0,0
  3231 0000207B 80460430                 add  byte [bp+4], 48
  3232                                  
  3233                                  ;-71     if (c > 57) c += 7; 
  3234                                  
  3235 0000207F 8A4604                   mov al, [bp+4]
  3236 00002082 3C39                     cmp al, 57
  3237 00002084 0F8E0400                 jle @@printhex4129
  3238 00002088 80460407                 add  byte [bp+4], 7
  3239                                  
  3240                                  ;-72     prc(c);      
  3241                                  
  3242                                  @@printhex4129:
  3243 0000208C 8A4604                   mov al, byte [bp+4]
  3244 0000208F B400                     mov ah, 0
  3245 00002091 50                       push ax
  3246 00002092 E8AFFE                   call prc
  3247 00002095 83C402                   add  sp, 2
  3248                                  
  3249                                  ;-73 }
  3250                                  
  3251                                  
  3252                                  ;-74 int printhex16(unsigned int i) {
  3253 00002098 C9                       LEAVE
  3254 00002099 C3                       ret
  3255                                  ; ENDP
  3256                                  
  3257                                  printhex16:  ; *** PROC ***
  3258                                  
  3259                                  ;-75     unsigned int half;
  3260                                  
  3261                                  
  3262                                  ;-76     half = i >>  8; printhex8a(half); 
  3263                                  
  3264                                  ;Function : printhex16, Number of local variables: 2
  3265                                  ;   # type sign width line used address name   list of local variables
  3266                                  ;  200 var unsg word    74 NULL bp+4    i
  3267                                  ;  201 var unsg word    75 NULL bp-2    half;
  3268 0000209A C8020000                 ENTER  2,0
  3269 0000209E 8B4604                   mov ax, [bp+4]
  3270 000020A1 C1E808                   shr ax, 8
  3271 000020A4 8946FE                   mov word [bp-2], ax
  3272 000020A7 FF76FE                   push word [bp-2]
  3273 000020AA E89BFF                   call printhex8a
  3274 000020AD 83C402                   add  sp, 2
  3275                                  
  3276                                  ;-77     half = i & 255; printhex8a(half);
  3277                                  
  3278 000020B0 8B4604                   mov ax, [bp+4]
  3279 000020B3 25FF00                   and ax, 255
  3280 000020B6 8946FE                   mov word [bp-2], ax
  3281 000020B9 FF76FE                   push word [bp-2]
  3282 000020BC E889FF                   call printhex8a
  3283 000020BF 83C402                   add  sp, 2
  3284                                  
  3285                                  ;-78 }
  3286                                  
  3287                                  
  3288                                  ;-79 int printIntU(unsigned int n) { 
  3289 000020C2 C9                       LEAVE
  3290 000020C3 C3                       ret
  3291                                  ; ENDP
  3292                                  
  3293                                  printIntU:  ; *** PROC ***
  3294                                  
  3295                                  ;-80     unsigned int e;
  3296                                  
  3297                                  
  3298                                  ;-81     if ( _ n >= 10) {  
  3299                                  
  3300                                  ;Function : printIntU, Number of local variables: 2
  3301                                  ;   # type sign width line used address name   list of local variables
  3302                                  ;  200 var unsg word    79 NULL bp+4    n
  3303                                  ;  201 var unsg word    80 NULL bp-2    e;
  3304 000020C4 C8020000                 ENTER  2,0
  3305 000020C8 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  3306 000020CC 0F821700                 jb  @@printIntU130
  3307                                  
  3308                                  ;-82         e=n/10; //DIV
  3309                                  
  3310 000020D0 8B4604                   mov ax, [bp+4]
  3311 000020D3 BB0A00                   mov bx, 10
  3312 000020D6 BA0000                   mov dx, 0
  3313 000020D9 F7F3                     div bx
  3314 000020DB 8946FE                   mov word [bp-2], ax
  3315                                  
  3316                                  ;-83         printIntU(e); 
  3317                                  
  3318 000020DE FF76FE                   push word [bp-2]
  3319 000020E1 E8E0FF                   call printIntU
  3320 000020E4 83C402                   add  sp, 2
  3321                                  
  3322                                  ;-84     }
  3323                                  
  3324                                  
  3325                                  ;-85     n = n % 10; //unsigned mod
  3326                                  
  3327                                  @@printIntU130:
  3328 000020E7 8B4604                   mov ax, [bp+4]
  3329 000020EA BB0A00                   mov bx, 10
  3330 000020ED BA0000                   mov dx, 0
  3331 000020F0 F7F3                     div bx
  3332 000020F2 89D0                     mov ax, dx
  3333 000020F4 894604                   mov word [bp+4], ax
  3334                                  
  3335                                  ;-86     n += '0'; 
  3336                                  
  3337 000020F7 83460430                 add  word [bp+4], 48
  3338                                  
  3339                                  ;-87     prc(n);
  3340                                  
  3341 000020FB FF7604                   push word [bp+4]
  3342 000020FE E843FE                   call prc
  3343 00002101 83C402                   add  sp, 2
  3344                                  
  3345                                  ;-88 }
  3346                                  
  3347                                  
  3348                                  ;-89 
  3349                                  
  3350                                  
  3351                                  ;-90 int error1(char *s) { 
  3352 00002104 C9                       LEAVE
  3353 00002105 C3                       ret
  3354                                  ; ENDP
  3355                                  
  3356                                  error1:  ; *** PROC ***
  3357                                  
  3358                                  ;-91     LIST=1; 
  3359                                  
  3360                                  ;Function : error1, Number of local variables: 1
  3361                                  ;   # type sign width line used address name   list of local variables
  3362                                  ;  200 ptr sign byte    90 NULL bp+4    s;
  3363 00002106 C8000000                 ENTER  0,0
  3364 0000210A 66B801000000             mov eax, 1
  3365 00002110 A2[0E00]                 mov byte [LIST], al
  3366                                  
  3367                                  ;-92     ErrorCount++;
  3368                                  
  3369 00002113 FF06[A101]               inc  word [ErrorCount]
  3370                                  
  3371                                  ;-93     prs("\n;***** next line ERROR: "); 
  3372                                  
  3373 00002117 68[3F21]                 push error1_0
  3374 0000211A E888FE                   call prs
  3375 0000211D 83C402                   add  sp, 2
  3376                                  
  3377                                  ;-94     prs(s);
  3378                                  
  3379 00002120 FF7604                   push word [bp+4]
  3380 00002123 E87FFE                   call prs
  3381 00002126 83C402                   add  sp, 2
  3382                                  
  3383                                  ;-95     prs(", Symbol: "); 
  3384                                  
  3385 00002129 68[5A21]                 push error1_1
  3386 0000212C E876FE                   call prs
  3387 0000212F 83C402                   add  sp, 2
  3388                                  
  3389                                  ;-96     prs(Symbol);
  3390                                  
  3391 00002132 8D06[0F00]               lea  ax, [Symbol]
  3392 00002136 50                       push ax
  3393 00002137 E86BFE                   call prs
  3394 0000213A 83C402                   add  sp, 2
  3395                                  
  3396                                  ;-97 }
  3397                                  
  3398                                  
  3399                                  ;-98 int errorexit(char *s) { 
  3400 0000213D C9                       LEAVE
  3401 0000213E C3                       ret
  3402                                  ; ENDP
  3403 0000213F 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  3404 00002148 6E657874206C696E65-
  3405 00002151 204552524F523A2000 
  3406 0000215A 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  3407 00002163 2000               
  3408                                  
  3409                                  errorexit:  ; *** PROC ***
  3410                                  
  3411                                  ;-99     error1(s); 
  3412                                  
  3413                                  ;Function : errorexit, Number of local variables: 1
  3414                                  ;   # type sign width line used address name   list of local variables
  3415                                  ;  200 ptr sign byte    98 NULL bp+4    s;
  3416 00002165 C8000000                 ENTER  0,0
  3417 00002169 FF7604                   push word [bp+4]
  3418 0000216C E897FF                   call error1
  3419 0000216F 83C402                   add  sp, 2
  3420                                  
  3421                                  ;-100     end1(1);
  3422                                  
  3423 00002172 6A01                     push 1
  3424 00002174 E8AA04                   call end1
  3425 00002177 83C402                   add  sp, 2
  3426                                  
  3427                                  ;-101 }
  3428                                  
  3429                                  
  3430                                  ;-102 int allowederror() {error1("not allowed here"); }
  3431 0000217A C9                       LEAVE
  3432 0000217B C3                       ret
  3433                                  ; ENDP
  3434                                  
  3435                                  allowederror:  ; *** PROC ***
  3436 0000217C 68[8621]                 push allowederror_0
  3437 0000217F E884FF                   call error1
  3438 00002182 83C402                   add  sp, 2
  3439                                  
  3440                                  ;-103 int addrerror()    {error1("address missing");} 
  3441                                  
  3442 00002185 C3                       ret
  3443                                  ; ENDP
  3444 00002186 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  3445 0000218F 6564206865726500   
  3446                                  
  3447                                  addrerror:  ; *** PROC ***
  3448 00002197 68[A121]                 push addrerror_0
  3449 0000219A E869FF                   call error1
  3450 0000219D 83C402                   add  sp, 2
  3451                                  
  3452                                  ;-104 int immeerror()    {error1("immediate not allowed here");}
  3453                                  
  3454 000021A0 C3                       ret
  3455                                  ; ENDP
  3456 000021A1 61646472657373206D-     addrerror_0 db "address missing",0
  3457 000021AA 697373696E6700     
  3458                                  
  3459                                  immeerror:  ; *** PROC ***
  3460 000021B1 68[BB21]                 push immeerror_0
  3461 000021B4 E84FFF                   call error1
  3462 000021B7 83C402                   add  sp, 2
  3463                                  
  3464                                  ;-105 int implerror()    {error1("not implemented");}
  3465                                  
  3466 000021BA C3                       ret
  3467                                  ; ENDP
  3468 000021BB 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  3469 000021C4 206E6F7420616C6C6F-
  3470 000021CD 776564206865726500 
  3471                                  
  3472                                  implerror:  ; *** PROC ***
  3473 000021D6 68[E021]                 push implerror_0
  3474 000021D9 E82AFF                   call error1
  3475 000021DC 83C402                   add  sp, 2
  3476                                  
  3477                                  ;-106 int indexerror()   {error1("invalid index register");}
  3478                                  
  3479 000021DF C3                       ret
  3480                                  ; ENDP
  3481 000021E0 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  3482 000021E9 6D656E74656400     
  3483                                  
  3484                                  indexerror:  ; *** PROC ***
  3485 000021F0 68[FA21]                 push indexerror_0
  3486 000021F3 E810FF                   call error1
  3487 000021F6 83C402                   add  sp, 2
  3488                                  
  3489                                  ;-107 int invaloperror() {error1("invalid or no operands");}
  3490                                  
  3491 000021F9 C3                       ret
  3492                                  ; ENDP
  3493 000021FA 696E76616C69642069-     indexerror_0 db "invalid index register",0
  3494 00002203 6E6465782072656769-
  3495 0000220C 7374657200         
  3496                                  
  3497                                  invaloperror:  ; *** PROC ***
  3498 00002211 68[1B22]                 push invaloperror_0
  3499 00002214 E8EFFE                   call error1
  3500 00002217 83C402                   add  sp, 2
  3501                                  
  3502                                  ;-108 int numbererror()  {error1("number expected");}
  3503                                  
  3504 0000221A C3                       ret
  3505                                  ; ENDP
  3506 0000221B 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  3507 00002224 72206E6F206F706572-
  3508 0000222D 616E647300         
  3509                                  
  3510                                  numbererror:  ; *** PROC ***
  3511 00002232 68[3C22]                 push numbererror_0
  3512 00002235 E8CEFE                   call error1
  3513 00002238 83C402                   add  sp, 2
  3514                                  
  3515                                  ;-109 int regmemerror()  {error1("only register or memory allowed");}
  3516                                  
  3517 0000223B C3                       ret
  3518                                  ; ENDP
  3519 0000223C 6E756D626572206578-     numbererror_0 db "number expected",0
  3520 00002245 70656374656400     
  3521                                  
  3522                                  regmemerror:  ; *** PROC ***
  3523 0000224C 68[5622]                 push regmemerror_0
  3524 0000224F E8B4FE                   call error1
  3525 00002252 83C402                   add  sp, 2
  3526                                  
  3527                                  ;-110 int reg16error()   {error1("only reg16, no segreg allowed");}
  3528                                  
  3529 00002255 C3                       ret
  3530                                  ; ENDP
  3531 00002256 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  3532 0000225F 73746572206F72206D-
  3533 00002268 656D6F727920616C6C-
  3534 00002271 6F77656400         
  3535                                  
  3536                                  reg16error:  ; *** PROC ***
  3537 00002276 68[8022]                 push reg16error_0
  3538 00002279 E88AFE                   call error1
  3539 0000227C 83C402                   add  sp, 2
  3540                                  
  3541                                  ;-111 int segregerror()  {error1("segment register not allowed");}
  3542                                  
  3543 0000227F C3                       ret
  3544                                  ; ENDP
  3545 00002280 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  3546 00002289 362C206E6F20736567-
  3547 00002292 72656720616C6C6F77-
  3548 0000229B 656400             
  3549                                  
  3550                                  segregerror:  ; *** PROC ***
  3551 0000229E 68[A822]                 push segregerror_0
  3552 000022A1 E862FE                   call error1
  3553 000022A4 83C402                   add  sp, 2
  3554                                  
  3555                                  ;-112 int syntaxerror()  {error1("syntax");}
  3556                                  
  3557 000022A7 C3                       ret
  3558                                  ; ENDP
  3559 000022A8 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  3560 000022B1 65676973746572206E-
  3561 000022BA 6F7420616C6C6F7765-
  3562 000022C3 6400               
  3563                                  
  3564                                  syntaxerror:  ; *** PROC ***
  3565 000022C5 68[CF22]                 push syntaxerror_0
  3566 000022C8 E83BFE                   call error1
  3567 000022CB 83C402                   add  sp, 2
  3568                                  
  3569                                  ;-113          
  3570                                  
  3571                                  
  3572                                  ;-114 int addrexit()     {errorexit("illegal address");}
  3573                                  
  3574 000022CE C3                       ret
  3575                                  ; ENDP
  3576 000022CF 73796E74617800          syntaxerror_0 db "syntax",0
  3577                                  
  3578                                  addrexit:  ; *** PROC ***
  3579 000022D6 68[E022]                 push addrexit_0
  3580 000022D9 E889FE                   call errorexit
  3581 000022DC 83C402                   add  sp, 2
  3582                                  
  3583                                  ;-115 int internexit()   {errorexit("intern compiler error");}
  3584                                  
  3585 000022DF C3                       ret
  3586                                  ; ENDP
  3587 000022E0 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  3588 000022E9 64647265737300     
  3589                                  
  3590                                  internexit:  ; *** PROC ***
  3591 000022F0 68[FA22]                 push internexit_0
  3592 000022F3 E86FFE                   call errorexit
  3593 000022F6 83C402                   add  sp, 2
  3594 000022F9 C3                       ret
  3595                                  ; ENDP
  3596 000022FA 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  3597 00002303 6D70696C6572206572-
  3598 0000230C 726F7200           
  3599                                  ;Back to main program: AS.C
  3600                                  
  3601                                  ;-8 #include "MAIN.C"
  3602                                  
  3603                                  ;Use include file: MAIN.C
  3604                                  
  3605                                  ;-1 int main() {
  3606                                  
  3607                                  
  3608                                  main:  ; *** PROC ***
  3609                                  
  3610                                  ;-2   getarg(); 
  3611                                  
  3612 00002310 E80A00                   call getarg
  3613                                  
  3614                                  ;-3   parse(); 
  3615                                  
  3616 00002313 E8D8EE                   call parse
  3617                                  
  3618                                  ;-4   epilog(); 
  3619                                  
  3620 00002316 E85C02                   call epilog
  3621                                  
  3622                                  ;-5   end1();
  3623                                  
  3624 00002319 E80503                   call end1
  3625                                  
  3626                                  ;-6 }
  3627                                  
  3628                                  
  3629                                  ;-7 
  3630                                  
  3631                                  
  3632                                  ;-8 int getarg() { int arglen1; int i; char *c;
  3633                                  
  3634 0000231C C3                       ret
  3635                                  ; ENDP
  3636                                  
  3637                                  getarg:  ; *** PROC ***
  3638                                  
  3639                                  ;-9   arglen1=*arglen;
  3640                                  
  3641                                  ;Function : getarg, Number of local variables: 3
  3642                                  ;   # type sign width line used address name   list of local variables
  3643                                  ;  200 var sign word     8 NULL bp-2    arglen1
  3644                                  ;  201 var sign word     8 NULL bp-4    i
  3645                                  ;  202 ptr sign byte     8 NULL bp-6    c;
  3646 0000231D C8060000                 ENTER  6,0
  3647 00002321 8B1E[510E]               mov bx, [arglen]
  3648 00002325 8A07                     mov al, [bx]
  3649 00002327 B400                     mov ah, 0
  3650 00002329 8946FE                   mov word [bp-2], ax
  3651                                  
  3652                                  ;-10   if (arglen1==0) {
  3653                                  
  3654 0000232C 8B46FE                   mov ax, [bp-2]
  3655 0000232F 83F800                   cmp ax, 0
  3656 00002332 0F851C00                 jne @@getarg131
  3657                                  
  3658                                  ;-11     cputs(Version1);
  3659                                  
  3660 00002336 8D06[0300]               lea  ax, [Version1]
  3661 0000233A 50                       push ax
  3662 0000233B E8C50C                   call cputs
  3663 0000233E 83C402                   add  sp, 2
  3664                                  
  3665                                  ;-12     cputs(", Usage: AS.COM filename [w/o .S] : ");
  3666                                  
  3667 00002341 68[E224]                 push getarg_0
  3668 00002344 E8BC0C                   call cputs
  3669 00002347 83C402                   add  sp, 2
  3670                                  
  3671                                  ;-13     exitR(3);
  3672                                  
  3673 0000234A 6A03                     push 3
  3674 0000234C E88F0E                   call exitR
  3675 0000234F 83C402                   add  sp, 2
  3676                                  
  3677                                  ;-14   }
  3678                                  
  3679                                  
  3680                                  ;-15   i=arglen1+129; 
  3681                                  
  3682                                  @@getarg131:
  3683 00002352 8B46FE                   mov ax, [bp-2]
  3684 00002355 058100                   add ax, 129
  3685 00002358 8946FC                   mov word [bp-4], ax
  3686                                  
  3687                                  ;-16   *i=0;  
  3688                                  
  3689 0000235B 66B800000000             mov eax, 0
  3690 00002361 8B5EFC                   mov  bx, [bp-4]
  3691 00002364 8907                     mov  [bx], ax
  3692                                  
  3693                                  ;-17   arglen1--;
  3694                                  
  3695 00002366 FF4EFE                   dec  word [bp-2]
  3696                                  
  3697                                  ;-18   toupper(argv);
  3698                                  
  3699 00002369 FF36[530E]               push word [argv]
  3700 0000236D E8C10C                   call toupper
  3701 00002370 83C402                   add  sp, 2
  3702                                  
  3703                                  ;-19   
  3704                                  
  3705                                  
  3706                                  ;-20   strcpy(namein, argv); strcat1(namein, ".S");
  3707                                  
  3708 00002373 FF36[530E]               push word [argv]
  3709 00002377 8D06[D000]               lea  ax, [namein]
  3710 0000237B 50                       push ax
  3711 0000237C E8200D                   call strcpy
  3712 0000237F 83C404                   add  sp, 4
  3713 00002382 68[0725]                 push getarg_1
  3714 00002385 8D06[D000]               lea  ax, [namein]
  3715 00002389 50                       push ax
  3716 0000238A E8D30D                   call strcat1
  3717 0000238D 83C404                   add  sp, 4
  3718                                  
  3719                                  ;-21   strcpy(namelst,argv); strcat1(namelst,".LST");
  3720                                  
  3721 00002390 FF36[530E]               push word [argv]
  3722 00002394 8D06[1301]               lea  ax, [namelst]
  3723 00002398 50                       push ax
  3724 00002399 E8030D                   call strcpy
  3725 0000239C 83C404                   add  sp, 4
  3726 0000239F 68[0A25]                 push getarg_2
  3727 000023A2 8D06[1301]               lea  ax, [namelst]
  3728 000023A6 50                       push ax
  3729 000023A7 E8B60D                   call strcat1
  3730 000023AA 83C404                   add  sp, 4
  3731                                  
  3732                                  ;-22   strcpy(namebin,argv); strcat1(namebin,".COM");
  3733                                  
  3734 000023AD FF36[530E]               push word [argv]
  3735 000023B1 8D06[5601]               lea  ax, [namebin]
  3736 000023B5 50                       push ax
  3737 000023B6 E8E60C                   call strcpy
  3738 000023B9 83C404                   add  sp, 4
  3739 000023BC 68[0F25]                 push getarg_3
  3740 000023BF 8D06[5601]               lea  ax, [namebin]
  3741 000023C3 50                       push ax
  3742 000023C4 E8990D                   call strcat1
  3743 000023C7 83C404                   add  sp, 4
  3744                                  
  3745                                  ;-23 
  3746                                  
  3747                                  
  3748                                  ;-24   LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  3749                                  
  3750 000023CA 66B801000000             mov eax, 1
  3751 000023D0 A2[0E00]                 mov byte [LIST], al
  3752 000023D3 66B800000000             mov eax, 0
  3753 000023D9 A3[9F01]                 mov word [DOS_ERR], ax
  3754 000023DC 66B800000000             mov eax, 0
  3755 000023E2 A3[A601]                 mov word [PC], ax
  3756 000023E5 66B800000000             mov eax, 0
  3757 000023EB A3[A101]                 mov word [ErrorCount], ax
  3758                                  
  3759                                  ;-25   
  3760                                  
  3761                                  
  3762                                  ;-26   asm_fd=openR (namein);
  3763                                  
  3764 000023EE 8D06[D000]               lea  ax, [namein]
  3765 000023F2 50                       push ax
  3766 000023F3 E88F0D                   call openR
  3767 000023F6 83C402                   add  sp, 2
  3768 000023F9 A3[9901]                 mov word [asm_fd], ax
  3769                                  
  3770                                  ;-27   if(DOS_ERR){cputs("Source file missing: ");cputs(namein); exitR(1); }
  3771                                  
  3772 000023FC A1[9F01]                 mov ax, [DOS_ERR]
  3773 000023FF 08C0                     or  al, al
  3774 00002401 0F841C00                 je @@getarg132
  3775 00002405 68[1425]                 push getarg_4
  3776 00002408 E8F80B                   call cputs
  3777 0000240B 83C402                   add  sp, 2
  3778 0000240E 8D06[D000]               lea  ax, [namein]
  3779 00002412 50                       push ax
  3780 00002413 E8ED0B                   call cputs
  3781 00002416 83C402                   add  sp, 2
  3782 00002419 6A01                     push 1
  3783 0000241B E8C00D                   call exitR
  3784 0000241E 83C402                   add  sp, 2
  3785                                  
  3786                                  ;-28   lst_fd=creatR(namelst);
  3787                                  
  3788                                  @@getarg132:
  3789 00002421 8D06[1301]               lea  ax, [namelst]
  3790 00002425 50                       push ax
  3791 00002426 E86B0D                   call creatR
  3792 00002429 83C402                   add  sp, 2
  3793 0000242C A3[9B01]                 mov word [lst_fd], ax
  3794                                  
  3795                                  ;-29   if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  3796                                  
  3797 0000242F A1[9F01]                 mov ax, [DOS_ERR]
  3798 00002432 08C0                     or  al, al
  3799 00002434 0F841C00                 je @@getarg133
  3800 00002438 68[2A25]                 push getarg_5
  3801 0000243B E8C50B                   call cputs
  3802 0000243E 83C402                   add  sp, 2
  3803 00002441 8D06[1301]               lea  ax, [namelst]
  3804 00002445 50                       push ax
  3805 00002446 E8BA0B                   call cputs
  3806 00002449 83C402                   add  sp, 2
  3807 0000244C 6A02                     push 2
  3808 0000244E E88D0D                   call exitR
  3809 00002451 83C402                   add  sp, 2
  3810                                  
  3811                                  ;-30   bin_fd=creatR(namebin);
  3812                                  
  3813                                  @@getarg133:
  3814 00002454 8D06[5601]               lea  ax, [namebin]
  3815 00002458 50                       push ax
  3816 00002459 E8380D                   call creatR
  3817 0000245C 83C402                   add  sp, 2
  3818 0000245F A3[9D01]                 mov word [bin_fd], ax
  3819                                  
  3820                                  ;-31   if(DOS_ERR){cputs("COM file not create: ");cputs(namebin);exitR(2);}
  3821                                  
  3822 00002462 A1[9F01]                 mov ax, [DOS_ERR]
  3823 00002465 08C0                     or  al, al
  3824 00002467 0F841C00                 je @@getarg134
  3825 0000246B 68[4125]                 push getarg_6
  3826 0000246E E8920B                   call cputs
  3827 00002471 83C402                   add  sp, 2
  3828 00002474 8D06[5601]               lea  ax, [namebin]
  3829 00002478 50                       push ax
  3830 00002479 E8870B                   call cputs
  3831 0000247C 83C402                   add  sp, 2
  3832 0000247F 6A02                     push 2
  3833 00002481 E85A0D                   call exitR
  3834 00002484 83C402                   add  sp, 2
  3835                                  
  3836                                  ;-32   
  3837                                  
  3838                                  
  3839                                  ;-33   prs(";");prs(Version1);
  3840                                  
  3841                                  @@getarg134:
  3842 00002487 68[5725]                 push getarg_7
  3843 0000248A E818FB                   call prs
  3844 0000248D 83C402                   add  sp, 2
  3845 00002490 8D06[0300]               lea  ax, [Version1]
  3846 00002494 50                       push ax
  3847 00002495 E80DFB                   call prs
  3848 00002498 83C402                   add  sp, 2
  3849                                  
  3850                                  ;-34   prs(", Source: "); prs(namein);  prs(", Output: "); prs(namelst);
  3851                                  
  3852 0000249B 68[5925]                 push getarg_8
  3853 0000249E E804FB                   call prs
  3854 000024A1 83C402                   add  sp, 2
  3855 000024A4 8D06[D000]               lea  ax, [namein]
  3856 000024A8 50                       push ax
  3857 000024A9 E8F9FA                   call prs
  3858 000024AC 83C402                   add  sp, 2
  3859 000024AF 68[6425]                 push getarg_9
  3860 000024B2 E8F0FA                   call prs
  3861 000024B5 83C402                   add  sp, 2
  3862 000024B8 8D06[1301]               lea  ax, [namelst]
  3863 000024BC 50                       push ax
  3864 000024BD E8E5FA                   call prs
  3865 000024C0 83C402                   add  sp, 2
  3866                                  
  3867                                  ;-35   prs(", "); prs(namebin);
  3868                                  
  3869 000024C3 68[6F25]                 push getarg_10
  3870 000024C6 E8DCFA                   call prs
  3871 000024C9 83C402                   add  sp, 2
  3872 000024CC 8D06[5601]               lea  ax, [namebin]
  3873 000024D0 50                       push ax
  3874 000024D1 E8D1FA                   call prs
  3875 000024D4 83C402                   add  sp, 2
  3876                                  
  3877                                  ;-36   prs("\n");
  3878                                  
  3879 000024D7 68[7225]                 push getarg_11
  3880 000024DA E8C8FA                   call prs
  3881 000024DD 83C402                   add  sp, 2
  3882                                  
  3883                                  ;-37 }
  3884                                  
  3885                                  
  3886                                  ;-38 int epilog() { int i; int j; char c;
  3887 000024E0 C9                       LEAVE
  3888 000024E1 C3                       ret
  3889                                  ; ENDP
  3890 000024E2 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  3891 000024EB 41532E434F4D206669-
  3892 000024F4 6C656E616D65205B77-
  3893 000024FD 2F6F202E535D203A20-
  3894 00002506 00                 
  3895 00002507 2E5300                  getarg_1 db ".S",0
  3896 0000250A 2E4C535400              getarg_2 db ".LST",0
  3897 0000250F 2E434F4D00              getarg_3 db ".COM",0
  3898 00002514 536F75726365206669-     getarg_4 db "Source file missing: ",0
  3899 0000251D 6C65206D697373696E-
  3900 00002526 673A2000           
  3901 0000252A 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  3902 00002533 206E6F742063726561-
  3903 0000253C 74653A2000         
  3904 00002541 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  3905 0000254A 6E6F74206372656174-
  3906 00002553 653A2000           
  3907 00002557 3B00                    getarg_7 db ";",0
  3908 00002559 2C20536F757263653A-     getarg_8 db ", Source: ",0
  3909 00002562 2000               
  3910 00002564 2C204F75747075743A-     getarg_9 db ", Output: ",0
  3911 0000256D 2000               
  3912 0000256F 2C2000                  getarg_10 db ", ",0
  3913 00002572 5C6E00                  getarg_11 db "\n",0
  3914                                  
  3915                                  epilog:  ; *** PROC ***
  3916                                  
  3917                                  ;-39   prs("\n;END Errors: "); printIntU(ErrorCount);
  3918                                  
  3919                                  ;Function : epilog, Number of local variables: 3
  3920                                  ;   # type sign width line used address name   list of local variables
  3921                                  ;  200 var sign word    38 NULL bp-2    i
  3922                                  ;  201 var sign word    38 NULL bp-4    j
  3923                                  ;  202 var sign byte    38 NULL bp-6    c;
  3924 00002575 C8060000                 ENTER  6,0
  3925 00002579 68[EF25]                 push epilog_0
  3926 0000257C E826FA                   call prs
  3927 0000257F 83C402                   add  sp, 2
  3928 00002582 FF36[A101]               push word [ErrorCount]
  3929 00002586 E83BFB                   call printIntU
  3930 00002589 83C402                   add  sp, 2
  3931                                  
  3932                                  ;-40   if (ErrorCount) prs(" ***ERROR*** ");
  3933                                  
  3934 0000258C A1[A101]                 mov ax, [ErrorCount]
  3935 0000258F 08C0                     or  al, al
  3936 00002591 0F840900                 je @@epilog135
  3937 00002595 68[FF25]                 push epilog_1
  3938 00002598 E80AFA                   call prs
  3939 0000259B 83C402                   add  sp, 2
  3940                                  
  3941                                  ;-41 /*    
  3942                                  
  3943                                  
  3944                                  ;-42   prs(", Label & Var: ");
  3945                                  
  3946                                  
  3947                                  ;-43   if (LabelMaxIx) {
  3948                                  
  3949                                  
  3950                                  ;-44     i = 1;
  3951                                  
  3952                                  
  3953                                  ;-45     LabelNamePtr= &LabelNames;
  3954                                  
  3955                                  
  3956                                  ;-46     do {
  3957                                  
  3958                                  
  3959                                  ;-47       prs(LabelNamePtr); prc(' ');
  3960                                  
  3961                                  
  3962                                  ;-48       j=LabelAddr[i]; printhex16(j); prs(",  ");
  3963                                  
  3964                                  
  3965                                  ;-49       j=strlen(LabelNamePtr);//get end of actual name
  3966                                  
  3967                                  
  3968                                  ;-50       LabelNamePtr=LabelNamePtr+j;
  3969                                  
  3970                                  
  3971                                  ;-51       LabelNamePtr++;
  3972                                  
  3973                                  
  3974                                  ;-52       i++;
  3975                                  
  3976                                  
  3977                                  ;-53     } while (i <= LabelMaxIx);
  3978                                  
  3979                                  
  3980                                  ;-54   }
  3981                                  
  3982                                  
  3983                                  ;-55 */  
  3984                                  
  3985                                  
  3986                                  ;-56   prs(", COM file "); printIntU(BinLen); prs(" bytes.");
  3987                                  
  3988                                  @@epilog135:
  3989 0000259E 68[0D26]                 push epilog_2
  3990 000025A1 E801FA                   call prs
  3991 000025A4 83C402                   add  sp, 2
  3992 000025A7 FF36[4F0E]               push word [BinLen]
  3993 000025AB E816FB                   call printIntU
  3994 000025AE 83C402                   add  sp, 2
  3995 000025B1 68[1926]                 push epilog_3
  3996 000025B4 E8EEF9                   call prs
  3997 000025B7 83C402                   add  sp, 2
  3998                                  
  3999                                  ;-57 //  i=0;
  4000                                  
  4001                                  
  4002                                  ;-58 //  do { prc(' '); j = FileBin[i]; printhex8a(j); i++;
  4003                                  
  4004                                  
  4005                                  ;-59 //  } while (i < BinLen);
  4006                                  
  4007                                  
  4008                                  ;-60   i=0;
  4009                                  
  4010 000025BA 66B800000000             mov eax, 0
  4011 000025C0 8946FE                   mov word [bp-2], ax
  4012                                  
  4013                                  ;-61   do {
  4014                                  
  4015                                  @@epilog136:
  4016                                  
  4017                                  ;-62     c = FileBin[i];
  4018                                  
  4019 000025C3 8B5EFE                   mov bx, [bp-2]
  4020 000025C6 8A87[7F06]               mov al, [FileBin + bx]
  4021 000025CA 8846FA                   mov byte [bp-6], al
  4022                                  
  4023                                  ;-63     fputcR(c, bin_fd);
  4024                                  
  4025 000025CD FF36[9D01]               push word [bin_fd]
  4026 000025D1 8A46FA                   mov al, byte [bp-6]
  4027 000025D4 B400                     mov ah, 0
  4028 000025D6 50                       push ax
  4029 000025D7 E8E10B                   call fputcR
  4030 000025DA 83C404                   add  sp, 4
  4031                                  
  4032                                  ;-64     i++;
  4033                                  
  4034 000025DD FF46FE                   inc  word [bp-2]
  4035                                  
  4036                                  ;-65   } while (i < BinLen);
  4037                                  
  4038 000025E0 8B46FE                   mov ax, [bp-2]
  4039 000025E3 3B06[4F0E]               cmp ax, [BinLen]
  4040 000025E7 0F8D0200                 jge @@epilog137
  4041 000025EB EBD6                     jmp @@epilog136
  4042                                  @@epilog137:
  4043                                  
  4044                                  ;-66 }
  4045                                  
  4046                                  
  4047                                  ;-67 int end1(int n) {
  4048 000025ED C9                       LEAVE
  4049 000025EE C3                       ret
  4050                                  ; ENDP
  4051 000025EF 5C6E3B454E44204572-     epilog_0 db "\n;END Errors: ",0
  4052 000025F8 726F72733A2000     
  4053 000025FF 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  4054 00002608 2A2A2A2000         
  4055 0000260D 2C20434F4D2066696C-     epilog_2 db ", COM file ",0
  4056 00002616 652000             
  4057 00002619 2062797465732E00        epilog_3 db " bytes.",0
  4058                                  
  4059                                  end1:  ; *** PROC ***
  4060                                  
  4061                                  ;-68   fcloseR(asm_fd);
  4062                                  
  4063                                  ;Function : end1, Number of local variables: 1
  4064                                  ;   # type sign width line used address name   list of local variables
  4065                                  ;  200 var sign word    67 NULL bp+4    n;
  4066 00002621 C8000000                 ENTER  0,0
  4067 00002625 FF36[9901]               push word [asm_fd]
  4068 00002629 E8A40B                   call fcloseR
  4069 0000262C 83C402                   add  sp, 2
  4070                                  
  4071                                  ;-69   fcloseR(lst_fd);
  4072                                  
  4073 0000262F FF36[9B01]               push word [lst_fd]
  4074 00002633 E89A0B                   call fcloseR
  4075 00002636 83C402                   add  sp, 2
  4076                                  
  4077                                  ;-70   fcloseR(bin_fd);
  4078                                  
  4079 00002639 FF36[9D01]               push word [bin_fd]
  4080 0000263D E8900B                   call fcloseR
  4081 00002640 83C402                   add  sp, 2
  4082                                  
  4083                                  ;-71   exitR(n);
  4084                                  
  4085 00002643 FF7604                   push word [bp+4]
  4086 00002646 E8950B                   call exitR
  4087 00002649 83C402                   add  sp, 2
  4088                                  
  4089                                  ;-72 }
  4090 0000264C C9                       LEAVE
  4091 0000264D C3                       ret
  4092                                  ; ENDP
  4093                                  ;Back to main program: AS.C
  4094                                  
  4095                                  ;-9 #include "GENCODE.C"
  4096                                  
  4097                                  ;Use include file: GENCODE.C
  4098                                  
  4099                                  ;-1 // generate code
  4100                                  
  4101                                  
  4102                                  ;-2 int getCodes() {
  4103                                  
  4104                                  
  4105                                  getCodes:  ; *** PROC ***
  4106                                  
  4107                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  4108                                  
  4109 0000264E FF06[C601]               inc  word [OpCodePtr]
  4110 00002652 8B1E[C601]               mov bx, [OpCodePtr]
  4111 00002656 8A07                     mov al, [bx]
  4112 00002658 B400                     mov ah, 0
  4113 0000265A A2[AF01]                 mov byte [Code1], al
  4114                                  
  4115                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  4116                                  
  4117 0000265D FF06[C601]               inc  word [OpCodePtr]
  4118 00002661 8B1E[C601]               mov bx, [OpCodePtr]
  4119 00002665 8A07                     mov al, [bx]
  4120 00002667 B400                     mov ah, 0
  4121 00002669 A2[B001]                 mov byte [Code2], al
  4122                                  
  4123                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  4124                                  
  4125 0000266C FF06[C601]               inc  word [OpCodePtr]
  4126 00002670 8B1E[C601]               mov bx, [OpCodePtr]
  4127 00002674 8A07                     mov al, [bx]
  4128 00002676 B400                     mov ah, 0
  4129 00002678 A2[B101]                 mov byte [Code3], al
  4130                                  
  4131                                  ;-6 }
  4132                                  
  4133                                  
  4134                                  ;-7 int gen66h() {genCode8(0x66);
  4135                                  
  4136 0000267B C3                       ret
  4137                                  ; ENDP
  4138                                  
  4139                                  gen66h:  ; *** PROC ***
  4140 0000267C 6A66                     push 102
  4141 0000267E E83B00                   call genCode8
  4142 00002681 83C402                   add  sp, 2
  4143                                  
  4144                                  ;-8 }
  4145                                  
  4146                                  
  4147                                  ;-9 int genCode(char c, char d) {
  4148                                  
  4149 00002684 C3                       ret
  4150                                  ; ENDP
  4151                                  
  4152                                  genCode:  ; *** PROC ***
  4153                                  
  4154                                  ;-10     c = c + d;
  4155                                  
  4156                                  ;Function : genCode, Number of local variables: 2
  4157                                  ;   # type sign width line used address name   list of local variables
  4158                                  ;  200 var sign byte     9 NULL bp+4    c
  4159                                  ;  201 var sign byte     9 NULL bp+6    d;
  4160 00002685 C8000000                 ENTER  0,0
  4161 00002689 8A4604                   mov al, [bp+4]
  4162 0000268C 024606                   add al, [bp+6]
  4163 0000268F 884604                   mov byte [bp+4], al
  4164                                  
  4165                                  ;-11     genCode8(c);
  4166                                  
  4167 00002692 8A4604                   mov al, byte [bp+4]
  4168 00002695 B400                     mov ah, 0
  4169 00002697 50                       push ax
  4170 00002698 E82100                   call genCode8
  4171 0000269B 83C402                   add  sp, 2
  4172                                  
  4173                                  ;-12 }                             
  4174                                  
  4175                                  
  4176                                  ;-13 int genCodeW(char c) {
  4177 0000269E C9                       LEAVE
  4178 0000269F C3                       ret
  4179                                  ; ENDP
  4180                                  
  4181                                  genCodeW:  ; *** PROC ***
  4182                                  
  4183                                  ;-14     c = c + wflag;  
  4184                                  
  4185                                  ;Function : genCodeW, Number of local variables: 1
  4186                                  ;   # type sign width line used address name   list of local variables
  4187                                  ;  200 var sign byte    13 NULL bp+4    c;
  4188 000026A0 C8000000                 ENTER  0,0
  4189 000026A4 8A4604                   mov al, [bp+4]
  4190 000026A7 0206[B701]               add al, [wflag]
  4191 000026AB 884604                   mov byte [bp+4], al
  4192                                  
  4193                                  ;-15     genCode8(c);
  4194                                  
  4195 000026AE 8A4604                   mov al, byte [bp+4]
  4196 000026B1 B400                     mov ah, 0
  4197 000026B3 50                       push ax
  4198 000026B4 E80500                   call genCode8
  4199 000026B7 83C402                   add  sp, 2
  4200                                  
  4201                                  ;-16 }   
  4202                                  
  4203                                  
  4204                                  ;-17 int genCode8(char c) {
  4205 000026BA C9                       LEAVE
  4206 000026BB C3                       ret
  4207                                  ; ENDP
  4208                                  
  4209                                  genCode8:  ; *** PROC ***
  4210                                  
  4211                                  ;-18 //set: BinLen++, OpPrintIndex++
  4212                                  
  4213                                  
  4214                                  ;-19     FileBin[BinLen]=c;
  4215                                  
  4216                                  ;Function : genCode8, Number of local variables: 1
  4217                                  ;   # type sign width line used address name   list of local variables
  4218                                  ;  200 var sign byte    17 NULL bp+4    c;
  4219 000026BC C8000000                 ENTER  0,0
  4220 000026C0 8A4604                   mov al, [bp+4]
  4221 000026C3 8B1E[4F0E]               mov bx, [BinLen]
  4222 000026C7 8887[7F06]               mov [FileBin+bx], al
  4223                                  
  4224                                  ;-20     BinLen++;
  4225                                  
  4226 000026CB FF06[4F0E]               inc  word [BinLen]
  4227                                  
  4228                                  ;-21     PC++;
  4229                                  
  4230 000026CF FF06[A601]               inc  word [PC]
  4231                                  
  4232                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  4233                                  
  4234 000026D3 A1[4F0E]                 mov ax, [BinLen]
  4235 000026D6 3DD007                   cmp ax, 2000 ;unsigned : 0
  4236 000026D9 0F820900                 jb  @@genCode8138
  4237 000026DD 68[0127]                 push genCode8_0
  4238 000026E0 E882FA                   call errorexit
  4239 000026E3 83C402                   add  sp, 2
  4240                                  
  4241                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  4242                                  
  4243                                  @@genCode8138:
  4244 000026E6 A1[C401]                 mov ax, [OpPrintIndex]
  4245 000026E9 83F805                   cmp ax, 5
  4246 000026EC 0F8D0F00                 jge @@genCode8139
  4247                                  
  4248                                  ;-24         OpPos[OpPrintIndex]=c;
  4249                                  
  4250 000026F0 8A4604                   mov al, [bp+4]
  4251 000026F3 8B1E[C401]               mov bx, [OpPrintIndex]
  4252 000026F7 8887[BF01]               mov [OpPos+bx], al
  4253                                  
  4254                                  ;-25         OpPrintIndex++;
  4255                                  
  4256 000026FB FF06[C401]               inc  word [OpPrintIndex]
  4257                                  
  4258                                  ;-26     }
  4259                                  
  4260                                  
  4261                                  ;-27 }
  4262                                  
  4263                                  @@genCode8139:
  4264                                  
  4265                                  ;-28 int genCode16(unsigned int i) {
  4266 000026FF C9                       LEAVE
  4267 00002700 C3                       ret
  4268                                  ; ENDP
  4269 00002701 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  4270 0000270A 746F6F206C6F6E6700 
  4271                                  
  4272                                  genCode16:  ; *** PROC ***
  4273                                  
  4274                                  ;-29     genCode8(i); i=i >> 8;
  4275                                  
  4276                                  ;Function : genCode16, Number of local variables: 1
  4277                                  ;   # type sign width line used address name   list of local variables
  4278                                  ;  200 var unsg word    28 NULL bp+4    i;
  4279 00002713 C8000000                 ENTER  0,0
  4280 00002717 FF7604                   push word [bp+4]
  4281 0000271A E89FFF                   call genCode8
  4282 0000271D 83C402                   add  sp, 2
  4283 00002720 8B4604                   mov ax, [bp+4]
  4284 00002723 C1E808                   shr ax, 8
  4285 00002726 894604                   mov word [bp+4], ax
  4286                                  
  4287                                  ;-30     genCode8(i);
  4288                                  
  4289 00002729 FF7604                   push word [bp+4]
  4290 0000272C E88DFF                   call genCode8
  4291 0000272F 83C402                   add  sp, 2
  4292                                  
  4293                                  ;-31 }
  4294                                  
  4295                                  
  4296                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  4297 00002732 C9                       LEAVE
  4298 00002733 C3                       ret
  4299                                  ; ENDP
  4300                                  
  4301                                  writeEA:  ; *** PROC ***
  4302                                  
  4303                                  ;-33 //need: Op, Op2, disp, R1No, RegNo, regindexbase, isDirect
  4304                                  
  4305                                  
  4306                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  4307                                  
  4308                                  
  4309                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  4310                                  
  4311                                  
  4312                                  ;-36     char len;
  4313                                  
  4314                                  
  4315                                  ;-37     len=0;   
  4316                                  
  4317                                  ;Function : writeEA, Number of local variables: 2
  4318                                  ;   # type sign width line used address name   list of local variables
  4319                                  ;  200 var sign byte    32 NULL bp+4    xxx
  4320                                  ;  201 var sign byte    36 NULL bp-2    len;
  4321 00002734 C8020000                 ENTER  2,0
  4322 00002738 66B800000000             mov eax, 0
  4323 0000273E 8846FE                   mov byte [bp-2], al
  4324                                  
  4325                                  ;-38 /*    prs("\n  EA x:"); printhex8a(xxx);       
  4326                                  
  4327                                  
  4328                                  ;-39     prs(", Op:"); printhex8a(Op);
  4329                                  
  4330                                  
  4331                                  ;-40     prs(", Op2:"); printhex8a(Op2);
  4332                                  
  4333                                  
  4334                                  ;-41     prs(", R1No:"); printhex8a(R1No);
  4335                                  
  4336                                  
  4337                                  ;-42     prs(", RegNo:"); printhex8a(RegNo);     */
  4338                                  
  4339                                  
  4340                                  ;-43            
  4341                                  
  4342                                  
  4343                                  ;-44     xxx = xxx << 3;//in reg/opcode field      
  4344                                  
  4345 00002741 8A4604                   mov al, [bp+4]
  4346 00002744 C0E003                   shl al, 3
  4347 00002747 884604                   mov byte [bp+4], al
  4348                                  
  4349                                  ;-45 
  4350                                  
  4351                                  
  4352                                  ;-46     if (Op ==   0) addrerror();
  4353                                  
  4354 0000274A A0[AC01]                 mov al, [Op]
  4355 0000274D 3C00                     cmp al, 0
  4356 0000274F 0F850300                 jne @@writeEA140
  4357 00002753 E841FA                   call addrerror
  4358                                  
  4359                                  ;-47     if (Op == IMM) immeerror();   
  4360                                  
  4361                                  @@writeEA140:
  4362 00002756 A0[AC01]                 mov al, [Op]
  4363 00002759 3C01                     cmp al, 1
  4364 0000275B 0F850300                 jne @@writeEA141
  4365 0000275F E84FFA                   call immeerror
  4366                                  
  4367                                  ;-48     if (Op == ADR) invaloperror(); 
  4368                                  
  4369                                  @@writeEA141:
  4370 00002762 A0[AC01]                 mov al, [Op]
  4371 00002765 3C03                     cmp al, 3
  4372 00002767 0F850300                 jne @@writeEA142
  4373 0000276B E8A3FA                   call invaloperror
  4374                                  
  4375                                  ;-49     if (Op2== ADR) invaloperror();          
  4376                                  
  4377                                  @@writeEA142:
  4378 0000276E A0[AD01]                 mov al, [Op2]
  4379 00002771 3C03                     cmp al, 3
  4380 00002773 0F850300                 jne @@writeEA143
  4381 00002777 E897FA                   call invaloperror
  4382                                  
  4383                                  ;-50 
  4384                                  
  4385                                  
  4386                                  ;-51     if (Op == REG) {
  4387                                  
  4388                                  @@writeEA143:
  4389 0000277A A0[AC01]                 mov al, [Op]
  4390 0000277D 3C02                     cmp al, 2
  4391 0000277F 0F853A00                 jne @@writeEA144
  4392                                  
  4393                                  ;-52         xxx |= 0xC0;     
  4394                                  
  4395 00002783 804E04C0                 or  byte [bp+4], 192
  4396                                  
  4397                                  ;-53         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  4398                                  
  4399 00002787 A0[AD01]                 mov al, [Op2]
  4400 0000278A 3C01                     cmp al, 1
  4401 0000278C 0F8F0D00                 jg  @@writeEA145
  4402 00002790 8A4604                   mov al, [bp+4]
  4403 00002793 0206[B301]               add al, [R1No]
  4404 00002797 884604                   mov byte [bp+4], al
  4405                                  
  4406                                  ;-54             else {
  4407                                  
  4408 0000279A E92000                   jmp @@writeEA146
  4409                                  @@writeEA145:
  4410                                  
  4411                                  ;-55                 if (Op2 == REG) xxx = xxx + R1No;
  4412                                  
  4413 0000279D A0[AD01]                 mov al, [Op2]
  4414 000027A0 3C02                     cmp al, 2
  4415 000027A2 0F850D00                 jne @@writeEA147
  4416 000027A6 8A4604                   mov al, [bp+4]
  4417 000027A9 0206[B301]               add al, [R1No]
  4418 000027AD 884604                   mov byte [bp+4], al
  4419                                  
  4420                                  ;-56                 else            xxx = xxx + RegNo;  
  4421                                  
  4422 000027B0 E90A00                   jmp @@writeEA148
  4423                                  @@writeEA147:
  4424 000027B3 8A4604                   mov al, [bp+4]
  4425 000027B6 0206[B201]               add al, [RegNo]
  4426 000027BA 884604                   mov byte [bp+4], al
  4427                                  
  4428                                  ;-57             }
  4429                                  
  4430                                  @@writeEA148:
  4431                                  
  4432                                  ;-58         } 
  4433                                  
  4434                                  @@writeEA146:
  4435                                  
  4436                                  ;-59     if (Op == MEM) {
  4437                                  
  4438                                  @@writeEA144:
  4439 000027BD A0[AC01]                 mov al, [Op]
  4440 000027C0 3C04                     cmp al, 4
  4441 000027C2 0F857F00                 jne @@writeEA149
  4442                                  
  4443                                  ;-60         if (isDirect) {
  4444                                  
  4445 000027C6 A0[BA01]                 mov al, [isDirect]
  4446 000027C9 08C0                     or  al, al
  4447 000027CB 0F841000                 je @@writeEA150
  4448                                  
  4449                                  ;-61             xxx |= 6;
  4450                                  
  4451 000027CF 804E0406                 or  byte [bp+4], 6
  4452                                  
  4453                                  ;-62             len = 2;
  4454                                  
  4455 000027D3 66B802000000             mov eax, 2
  4456 000027D9 8846FE                   mov byte [bp-2], al
  4457                                  
  4458                                  ;-63         }
  4459                                  
  4460                                  
  4461                                  ;-64         else { 
  4462                                  
  4463 000027DC E96600                   jmp @@writeEA151
  4464                                  @@writeEA150:
  4465                                  
  4466                                  ;-65             xxx = xxx + regindexbase;   
  4467                                  
  4468 000027DF 8A4604                   mov al, [bp+4]
  4469 000027E2 0206[B901]               add al, [regindexbase]
  4470 000027E6 884604                   mov byte [bp+4], al
  4471                                  
  4472                                  ;-66             if (regindexbase == 6) {//make [BP+00]
  4473                                  
  4474 000027E9 A0[B901]                 mov al, [regindexbase]
  4475 000027EC 3C06                     cmp al, 6
  4476 000027EE 0F851700                 jne @@writeEA152
  4477                                  
  4478                                  ;-67                 len=1;
  4479                                  
  4480 000027F2 66B801000000             mov eax, 1
  4481 000027F8 8846FE                   mov byte [bp-2], al
  4482                                  
  4483                                  ;-68                 if (disp == 0) xxx |= 0x40;
  4484                                  
  4485 000027FB A1[BB01]                 mov ax, [disp]
  4486 000027FE 83F800                   cmp ax, 0
  4487 00002801 0F850400                 jne @@writeEA153
  4488 00002805 804E0440                 or  byte [bp+4], 64
  4489                                  
  4490                                  ;-69             }
  4491                                  
  4492                                  @@writeEA153:
  4493                                  
  4494                                  ;-70 
  4495                                  
  4496                                  
  4497                                  ;-71             if (disp) {
  4498                                  
  4499                                  @@writeEA152:
  4500 00002809 A1[BB01]                 mov ax, [disp]
  4501 0000280C 08C0                     or  al, al
  4502 0000280E 0F843300                 je @@writeEA154
  4503                                  
  4504                                  ;-72                 ax = disp;
  4505                                  
  4506 00002812 A1[BB01]                 mov  ax, [disp]
  4507                                  
  4508                                  ;-73                 if(ax > 127) len=2;
  4509                                  
  4510 00002815 83F87F                   cmp  ax, 127
  4511 00002818 0F8E0C00                 jle @@writeEA155
  4512 0000281C 66B802000000             mov eax, 2
  4513 00002822 8846FE                   mov byte [bp-2], al
  4514                                  
  4515                                  ;-74                 else len=1;
  4516                                  
  4517 00002825 E90900                   jmp @@writeEA156
  4518                                  @@writeEA155:
  4519 00002828 66B801000000             mov eax, 1
  4520 0000282E 8846FE                   mov byte [bp-2], al
  4521                                  
  4522                                  ;-75                 if (len == 1) xxx |= 0x40;
  4523                                  
  4524                                  @@writeEA156:
  4525 00002831 8A46FE                   mov al, [bp-2]
  4526 00002834 3C01                     cmp al, 1
  4527 00002836 0F850700                 jne @@writeEA157
  4528 0000283A 804E0440                 or  byte [bp+4], 64
  4529                                  
  4530                                  ;-76                 else xxx |= 0x80;
  4531                                  
  4532 0000283E E90400                   jmp @@writeEA158
  4533                                  @@writeEA157:
  4534 00002841 804E0480                 or  byte [bp+4], 128
  4535                                  
  4536                                  ;-77             }
  4537                                  
  4538                                  @@writeEA158:
  4539                                  
  4540                                  ;-78         }
  4541                                  
  4542                                  @@writeEA154:
  4543                                  
  4544                                  ;-79     }  
  4545                                  
  4546                                  @@writeEA151:
  4547                                  
  4548                                  ;-80     
  4549                                  
  4550                                  
  4551                                  ;-81     genCode8(xxx);// gen second byte
  4552                                  
  4553                                  @@writeEA149:
  4554 00002845 8A4604                   mov al, byte [bp+4]
  4555 00002848 B400                     mov ah, 0
  4556 0000284A 50                       push ax
  4557 0000284B E86EFE                   call genCode8
  4558 0000284E 83C402                   add  sp, 2
  4559                                  
  4560                                  ;-82     if (len == 1) genCode8 (disp);
  4561                                  
  4562 00002851 8A46FE                   mov al, [bp-2]
  4563 00002854 3C01                     cmp al, 1
  4564 00002856 0F850A00                 jne @@writeEA159
  4565 0000285A FF36[BB01]               push word [disp]
  4566 0000285E E85BFE                   call genCode8
  4567 00002861 83C402                   add  sp, 2
  4568                                  
  4569                                  ;-83     if (len == 2) genCode16(disp);
  4570                                  
  4571                                  @@writeEA159:
  4572 00002864 8A46FE                   mov al, [bp-2]
  4573 00002867 3C02                     cmp al, 2
  4574 00002869 0F850A00                 jne @@writeEA160
  4575 0000286D FF36[BB01]               push word [disp]
  4576 00002871 E89FFE                   call genCode16
  4577 00002874 83C402                   add  sp, 2
  4578                                  
  4579                                  ;-84 }
  4580                                  
  4581                                  @@writeEA160:
  4582                                  
  4583                                  ;-85 
  4584                                  
  4585                                  
  4586                                  ;-86 int genImmediate() {
  4587 00002877 C9                       LEAVE
  4588 00002878 C3                       ret
  4589                                  ; ENDP
  4590                                  
  4591                                  genImmediate:  ; *** PROC ***
  4592                                  
  4593                                  ;-87     if (sflag) {
  4594                                  
  4595 00002879 A0[B801]                 mov al, [sflag]
  4596 0000287C 08C0                     or  al, al
  4597 0000287E 0F840D00                 je @@genImmediate161
  4598                                  
  4599                                  ;-88         genCode8(imme);
  4600                                  
  4601 00002882 FF36[BD01]               push word [imme]
  4602 00002886 E833FE                   call genCode8
  4603 00002889 83C402                   add  sp, 2
  4604                                  
  4605                                  ;-89         return;
  4606                                  
  4607 0000288C E92000                   jmp @@retn
  4608                                  
  4609                                  ;-90     }
  4610                                  
  4611                                  
  4612                                  ;-91     if (wflag) genCode16(imme);
  4613                                  
  4614                                  @@genImmediate161:
  4615 0000288F A0[B701]                 mov al, [wflag]
  4616 00002892 08C0                     or  al, al
  4617 00002894 0F840D00                 je @@genImmediate162
  4618 00002898 FF36[BD01]               push word [imme]
  4619 0000289C E874FE                   call genCode16
  4620 0000289F 83C402                   add  sp, 2
  4621                                  
  4622                                  ;-92     else       genCode8 (imme);  
  4623                                  
  4624 000028A2 E90A00                   jmp @@genImmediate163
  4625                                  @@genImmediate162:
  4626 000028A5 FF36[BD01]               push word [imme]
  4627 000028A9 E810FE                   call genCode8
  4628 000028AC 83C402                   add  sp, 2
  4629                                  
  4630                                  ;-93     }    
  4631                                  
  4632                                  @@genImmediate163:
  4633                                  @@retn:
  4634 000028AF C3                       ret
  4635                                  ; ENDP
  4636                                  ;Back to main program: AS.C
  4637                                  
  4638                                  ;-10 
  4639                                  
  4640                                  
  4641                                  ;-11 int process() { 
  4642                                  
  4643                                  
  4644                                  process:  ; *** PROC ***
  4645                                  
  4646                                  ;-12     char c;
  4647                                  
  4648                                  
  4649                                  ;-13     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  4650                                  
  4651                                  ;Function : process, Number of local variables: 1
  4652                                  ;   # type sign width line used address name   list of local variables
  4653                                  ;  200 var sign byte    12 NULL bp-2    c;
  4654 000028B0 C8020000                 ENTER  2,0
  4655 000028B4 E821EA                   call getTokeType
  4656                                  
  4657                                  ;-14     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  4658                                  
  4659 000028B7 E871ED                   call getCodeSize
  4660 000028BA A2[B601]                 mov byte [OpSize], al
  4661                                  
  4662                                  ;-15     getCodes();//set: Code1, Code2, Code3
  4663                                  
  4664 000028BD E88EFD                   call getCodes
  4665                                  
  4666                                  ;-16 
  4667                                  
  4668                                  
  4669                                  ;-17     if (CodeType ==  1) {//1 byte opcode
  4670                                  
  4671 000028C0 A0[AE01]                 mov al, [CodeType]
  4672 000028C3 3C01                     cmp al, 1
  4673 000028C5 0F850F00                 jne @@process164
  4674                                  
  4675                                  ;-18         genCode8(Code1);
  4676                                  
  4677 000028C9 A0[AF01]                 mov al, byte [Code1]
  4678 000028CC B400                     mov ah, 0
  4679 000028CE 50                       push ax
  4680 000028CF E8EAFD                   call genCode8
  4681 000028D2 83C402                   add  sp, 2
  4682                                  
  4683                                  ;-19         return;
  4684                                  
  4685 000028D5 E94102                   jmp @@retn
  4686                                  
  4687                                  ;-20     }
  4688                                  
  4689                                  
  4690                                  ;-21   
  4691                                  
  4692                                  
  4693                                  ;-22     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv
  4694                                  
  4695                                  @@process164:
  4696 000028D8 A0[AE01]                 mov al, [CodeType]
  4697 000028DB 3C02                     cmp al, 2
  4698 000028DD 0F858700                 jne @@process165
  4699                                  
  4700                                  ;-23         getOpL();
  4701                                  
  4702 000028E1 E81D03                   call getOpL
  4703                                  
  4704                                  ;-24         checkOpL();        
  4705                                  
  4706 000028E4 E85802                   call checkOpL
  4707                                  
  4708                                  ;-25         if (Code2 <= 1) {//inc,dec
  4709                                  
  4710 000028E7 A0[B001]                 mov al, [Code2]
  4711 000028EA 3C01                     cmp al, 1
  4712 000028EC 0F8F4500                 jg  @@process166
  4713                                  
  4714                                  ;-26   	        if (Op == REG) {//short
  4715                                  
  4716 000028F0 A0[AC01]                 mov al, [Op]
  4717 000028F3 3C02                     cmp al, 2
  4718 000028F5 0F853C00                 jne @@process167
  4719                                  
  4720                                  ;-27                 if (R1Type == WORD) {genCode(Code3, RegNo); return; }
  4721                                  
  4722 000028F9 A0[B501]                 mov al, [R1Type]
  4723 000028FC 3C02                     cmp al, 2
  4724 000028FE 0F851500                 jne @@process168
  4725 00002902 A0[B201]                 mov al, byte [RegNo]
  4726 00002905 B400                     mov ah, 0
  4727 00002907 50                       push ax
  4728 00002908 A0[B101]                 mov al, byte [Code3]
  4729 0000290B B400                     mov ah, 0
  4730 0000290D 50                       push ax
  4731 0000290E E874FD                   call genCode
  4732 00002911 83C404                   add  sp, 4
  4733 00002914 E90202                   jmp @@retn
  4734                                  
  4735                                  ;-28                 if (R1Type ==DWORD) {genCode(Code3, RegNo); return; }
  4736                                  
  4737                                  @@process168:
  4738 00002917 A0[B501]                 mov al, [R1Type]
  4739 0000291A 3C03                     cmp al, 3
  4740 0000291C 0F851500                 jne @@process169
  4741 00002920 A0[B201]                 mov al, byte [RegNo]
  4742 00002923 B400                     mov ah, 0
  4743 00002925 50                       push ax
  4744 00002926 A0[B101]                 mov al, byte [Code3]
  4745 00002929 B400                     mov ah, 0
  4746 0000292B 50                       push ax
  4747 0000292C E856FD                   call genCode
  4748 0000292F 83C404                   add  sp, 4
  4749 00002932 E9E401                   jmp @@retn
  4750                                  
  4751                                  ;-29             }
  4752                                  
  4753                                  @@process169:
  4754                                  
  4755                                  ;-30         }
  4756                                  
  4757                                  @@process167:
  4758                                  
  4759                                  ;-31         if (Code2 == 5) {//imul extension?
  4760                                  
  4761                                  @@process166:
  4762 00002935 A0[B001]                 mov al, [Code2]
  4763 00002938 3C05                     cmp al, 5
  4764 0000293A 0F850F00                 jne @@process170
  4765                                  
  4766                                  ;-32             getTokeType();
  4767                                  
  4768 0000293E E897E9                   call getTokeType
  4769                                  
  4770                                  ;-33             if (TokeType) implerror();
  4771                                  
  4772 00002941 A0[AB01]                 mov al, [TokeType]
  4773 00002944 08C0                     or  al, al
  4774 00002946 0F840300                 je @@process171
  4775 0000294A E889F8                   call implerror
  4776                                  
  4777                                  ;-34         }
  4778                                  
  4779                                  @@process171:
  4780                                  
  4781                                  ;-35         genCodeW(Code1);   
  4782                                  
  4783                                  @@process170:
  4784 0000294D A0[AF01]                 mov al, byte [Code1]
  4785 00002950 B400                     mov ah, 0
  4786 00002952 50                       push ax
  4787 00002953 E84AFD                   call genCodeW
  4788 00002956 83C402                   add  sp, 2
  4789                                  
  4790                                  ;-36         
  4791                                  
  4792                                  
  4793                                  ;-37         writeEA(Code2);
  4794                                  
  4795 00002959 A0[B001]                 mov al, byte [Code2]
  4796 0000295C B400                     mov ah, 0
  4797 0000295E 50                       push ax
  4798 0000295F E8D2FD                   call writeEA
  4799 00002962 83C402                   add  sp, 2
  4800                                  
  4801                                  ;-38         return;
  4802                                  
  4803 00002965 E9B101                   jmp @@retn
  4804                                  
  4805                                  ;-39     }
  4806                                  
  4807                                  
  4808                                  ;-40   
  4809                                  
  4810                                  
  4811                                  ;-41     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  4812                                  
  4813                                  @@process165:
  4814 00002968 A0[AE01]                 mov al, [CodeType]
  4815 0000296B 3C03                     cmp al, 3
  4816 0000296D 0F855C00                 jne @@process172
  4817                                  
  4818                                  ;-42         getOpL();       //setwflag not applicable
  4819                                  
  4820 00002971 E88D02                   call getOpL
  4821                                  
  4822                                  ;-43         if (R1Type != WORD) reg16error();//only r16
  4823                                  
  4824 00002974 A0[B501]                 mov al, [R1Type]
  4825 00002977 3C02                     cmp al, 2
  4826 00002979 0F840300                 je  @@process173
  4827 0000297D E8F6F8                   call reg16error
  4828                                  
  4829                                  ;-44         need(',');   
  4830                                  
  4831                                  @@process173:
  4832 00002980 6A2C                     push 44
  4833 00002982 E857ED                   call need
  4834 00002985 83C402                   add  sp, 2
  4835                                  
  4836                                  ;-45         getOpR();
  4837                                  
  4838 00002988 E8C202                   call getOpR
  4839                                  
  4840                                  ;-46         if (Op2 != MEM) addrerror();//only m16 
  4841                                  
  4842 0000298B A0[AD01]                 mov al, [Op2]
  4843 0000298E 3C04                     cmp al, 4
  4844 00002990 0F840300                 je  @@process174
  4845 00002994 E800F8                   call addrerror
  4846                                  
  4847                                  ;-47         
  4848                                  
  4849                                  
  4850                                  ;-48         genCode8(Code1);//les,lds,lea
  4851                                  
  4852                                  @@process174:
  4853 00002997 A0[AF01]                 mov al, byte [Code1]
  4854 0000299A B400                     mov ah, 0
  4855 0000299C 50                       push ax
  4856 0000299D E81CFD                   call genCode8
  4857 000029A0 83C402                   add  sp, 2
  4858                                  
  4859                                  ;-49         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  4860                                  
  4861 000029A3 A0[AF01]                 mov al, [Code1]
  4862 000029A6 3C0F                     cmp al, 15
  4863 000029A8 0F850C00                 jne @@process175
  4864 000029AC A0[B001]                 mov al, byte [Code2]
  4865 000029AF B400                     mov ah, 0
  4866 000029B1 50                       push ax
  4867 000029B2 E807FD                   call genCode8
  4868 000029B5 83C402                   add  sp, 2
  4869                                  
  4870                                  ;-50         Op=Op2;//set MEM for writeEA
  4871                                  
  4872                                  @@process175:
  4873 000029B8 A0[AD01]                 mov al, [Op2]
  4874 000029BB A2[AC01]                 mov byte [Op], al
  4875                                  
  4876                                  ;-51         writeEA(R1No);           
  4877                                  
  4878 000029BE A0[B301]                 mov al, byte [R1No]
  4879 000029C1 B400                     mov ah, 0
  4880 000029C3 50                       push ax
  4881 000029C4 E86DFD                   call writeEA
  4882 000029C7 83C402                   add  sp, 2
  4883                                  
  4884                                  ;-52         return;
  4885                                  
  4886 000029CA E94C01                   jmp @@retn
  4887                                  
  4888                                  ;-53     }
  4889                                  
  4890                                  
  4891                                  ;-54 
  4892                                  
  4893                                  
  4894                                  ;-55     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  4895                                  
  4896                                  @@process172:
  4897 000029CD A0[AE01]                 mov al, [CodeType]
  4898 000029D0 3C04                     cmp al, 4
  4899 000029D2 0F85DC00                 jne @@process176
  4900                                  
  4901                                  ;-56         get2Ops();    
  4902                                  
  4903 000029D6 E81902                   call get2Ops
  4904                                  
  4905                                  ;-57         setwflag();     
  4906                                  
  4907 000029D9 E84C05                   call setwflag
  4908                                  
  4909                                  ;-58         if (Op2 == IMM) {//second operand is imm     
  4910                                  
  4911 000029DC A0[AD01]                 mov al, [Op2]
  4912 000029DF 3C01                     cmp al, 1
  4913 000029E1 0F856300                 jne @@process177
  4914                                  
  4915                                  ;-59             setsflag();   
  4916                                  
  4917 000029E5 E8BC05                   call setsflag
  4918                                  
  4919                                  ;-60             if (Op == REG) {                
  4920                                  
  4921 000029E8 A0[AC01]                 mov al, [Op]
  4922 000029EB 3C02                     cmp al, 2
  4923 000029ED 0F853100                 jne @@process178
  4924                                  
  4925                                  ;-61                 if (R1No == 0) {// acc,imm   
  4926                                  
  4927 000029F1 A0[B301]                 mov al, [R1No]
  4928 000029F4 3C00                     cmp al, 0
  4929 000029F6 0F852800                 jne @@process179
  4930                                  
  4931                                  ;-62                     if (sflag == 0) {                        
  4932                                  
  4933 000029FA A0[B801]                 mov al, [sflag]
  4934 000029FD 3C00                     cmp al, 0
  4935 000029FF 0F851F00                 jne @@process180
  4936                                  
  4937                                  ;-63                         c = Code1 << 3;
  4938                                  
  4939 00002A03 A0[AF01]                 mov al, [Code1]
  4940 00002A06 C0E003                   shl al, 3
  4941 00002A09 8846FE                   mov byte [bp-2], al
  4942                                  
  4943                                  ;-64                         c += 4;    
  4944                                  
  4945 00002A0C 8046FE04                 add  byte [bp-2], 4
  4946                                  
  4947                                  ;-65                         genCodeW(c);
  4948                                  
  4949 00002A10 8A46FE                   mov al, byte [bp-2]
  4950 00002A13 B400                     mov ah, 0
  4951 00002A15 50                       push ax
  4952 00002A16 E887FC                   call genCodeW
  4953 00002A19 83C402                   add  sp, 2
  4954                                  
  4955                                  ;-66                         genImmediate();
  4956                                  
  4957 00002A1C E85AFE                   call genImmediate
  4958                                  
  4959                                  ;-67                         return;
  4960                                  
  4961 00002A1F E9F700                   jmp @@retn
  4962                                  
  4963                                  ;-68                     }
  4964                                  
  4965                                  
  4966                                  ;-69                 }
  4967                                  
  4968                                  @@process180:
  4969                                  
  4970                                  ;-70             }
  4971                                  
  4972                                  @@process179:
  4973                                  
  4974                                  ;-71             //r/m, imm: 80 sign-extended,TTT,imm
  4975                                  
  4976                                  
  4977                                  ;-72             c = sflag + 0x80;       
  4978                                  
  4979                                  @@process178:
  4980 00002A22 A0[B801]                 mov al, [sflag]
  4981 00002A25 0480                     add al, 128
  4982 00002A27 8846FE                   mov byte [bp-2], al
  4983                                  
  4984                                  ;-73             genCodeW(c); 
  4985                                  
  4986 00002A2A 8A46FE                   mov al, byte [bp-2]
  4987 00002A2D B400                     mov ah, 0
  4988 00002A2F 50                       push ax
  4989 00002A30 E86DFC                   call genCodeW
  4990 00002A33 83C402                   add  sp, 2
  4991                                  
  4992                                  ;-74             writeEA(Code1);  
  4993                                  
  4994 00002A36 A0[AF01]                 mov al, byte [Code1]
  4995 00002A39 B400                     mov ah, 0
  4996 00002A3B 50                       push ax
  4997 00002A3C E8F5FC                   call writeEA
  4998 00002A3F 83C402                   add  sp, 2
  4999                                  
  5000                                  ;-75             genImmediate();
  5001                                  
  5002 00002A42 E834FE                   call genImmediate
  5003                                  
  5004                                  ;-76             return;     
  5005                                  
  5006 00002A45 E9D100                   jmp @@retn
  5007                                  
  5008                                  ;-77         }  
  5009                                  
  5010                                  
  5011                                  ;-78        
  5012                                  
  5013                                  
  5014                                  ;-79         c = Code1 << 3;//r/m, r/m  
  5015                                  
  5016                                  @@process177:
  5017 00002A48 A0[AF01]                 mov al, [Code1]
  5018 00002A4B C0E003                   shl al, 3
  5019 00002A4E 8846FE                   mov byte [bp-2], al
  5020                                  
  5021                                  ;-80         if (Op == REG) {
  5022                                  
  5023 00002A51 A0[AC01]                 mov al, [Op]
  5024 00002A54 3C02                     cmp al, 2
  5025 00002A56 0F852E00                 jne @@process181
  5026                                  
  5027                                  ;-81             if (Op2 == MEM) {//reg, mem      
  5028                                  
  5029 00002A5A A0[AD01]                 mov al, [Op2]
  5030 00002A5D 3C04                     cmp al, 4
  5031 00002A5F 0F852500                 jne @@process182
  5032                                  
  5033                                  ;-82                 c += 2;//add direction flag
  5034                                  
  5035 00002A63 8046FE02                 add  byte [bp-2], 2
  5036                                  
  5037                                  ;-83                 genCodeW(c);
  5038                                  
  5039 00002A67 8A46FE                   mov al, byte [bp-2]
  5040 00002A6A B400                     mov ah, 0
  5041 00002A6C 50                       push ax
  5042 00002A6D E830FC                   call genCodeW
  5043 00002A70 83C402                   add  sp, 2
  5044                                  
  5045                                  ;-84                 Op=Op2;//set MEM for writeEA                
  5046                                  
  5047 00002A73 A0[AD01]                 mov al, [Op2]
  5048 00002A76 A2[AC01]                 mov byte [Op], al
  5049                                  
  5050                                  ;-85                 writeEA(R1No);
  5051                                  
  5052 00002A79 A0[B301]                 mov al, byte [R1No]
  5053 00002A7C B400                     mov ah, 0
  5054 00002A7E 50                       push ax
  5055 00002A7F E8B2FC                   call writeEA
  5056 00002A82 83C402                   add  sp, 2
  5057                                  
  5058                                  ;-86                 return;    
  5059                                  
  5060 00002A85 E99100                   jmp @@retn
  5061                                  
  5062                                  ;-87             }
  5063                                  
  5064                                  
  5065                                  ;-88         }
  5066                                  
  5067                                  @@process182:
  5068                                  
  5069                                  ;-89         if (Op2 == REG) {//mem,reg    reg,reg
  5070                                  
  5071                                  @@process181:
  5072 00002A88 A0[AD01]                 mov al, [Op2]
  5073 00002A8B 3C02                     cmp al, 2
  5074 00002A8D 0F851B00                 jne @@process183
  5075                                  
  5076                                  ;-90             genCodeW(c);
  5077                                  
  5078 00002A91 8A46FE                   mov al, byte [bp-2]
  5079 00002A94 B400                     mov ah, 0
  5080 00002A96 50                       push ax
  5081 00002A97 E806FC                   call genCodeW
  5082 00002A9A 83C402                   add  sp, 2
  5083                                  
  5084                                  ;-91             writeEA(RegNo);//2. Op in reg-field
  5085                                  
  5086 00002A9D A0[B201]                 mov al, byte [RegNo]
  5087 00002AA0 B400                     mov ah, 0
  5088 00002AA2 50                       push ax
  5089 00002AA3 E88EFC                   call writeEA
  5090 00002AA6 83C402                   add  sp, 2
  5091                                  
  5092                                  ;-92             return;            
  5093                                  
  5094 00002AA9 E96D00                   jmp @@retn
  5095                                  
  5096                                  ;-93         }          
  5097                                  
  5098                                  
  5099                                  ;-94         
  5100                                  
  5101                                  
  5102                                  ;-95         syntaxerror();        
  5103                                  
  5104                                  @@process183:
  5105 00002AAC E816F8                   call syntaxerror
  5106                                  
  5107                                  ;-96         return;
  5108                                  
  5109 00002AAF E96700                   jmp @@retn
  5110                                  
  5111                                  ;-97     }
  5112                                  
  5113                                  
  5114                                  ;-98    
  5115                                  
  5116                                  
  5117                                  ;-99     if (CodeType ==  8) {//ret,retf
  5118                                  
  5119                                  @@process176:
  5120 00002AB2 A0[AE01]                 mov al, [CodeType]
  5121 00002AB5 3C08                     cmp al, 8
  5122 00002AB7 0F853100                 jne @@process184
  5123                                  
  5124                                  ;-100         if (TokeType == DIGIT) {
  5125                                  
  5126 00002ABB A0[AB01]                 mov al, [TokeType]
  5127 00002ABE 3C01                     cmp al, 1
  5128 00002AC0 0F851900                 jne @@process185
  5129                                  
  5130                                  ;-101             genCode8(Code2);
  5131                                  
  5132 00002AC4 A0[B001]                 mov al, byte [Code2]
  5133 00002AC7 B400                     mov ah, 0
  5134 00002AC9 50                       push ax
  5135 00002ACA E8EFFB                   call genCode8
  5136 00002ACD 83C402                   add  sp, 2
  5137                                  
  5138                                  ;-102             genCode16(SymbolInt);
  5139                                  
  5140 00002AD0 FF36[4D00]               push word [SymbolInt]
  5141 00002AD4 E83CFC                   call genCode16
  5142 00002AD7 83C402                   add  sp, 2
  5143                                  
  5144                                  ;-103             return;
  5145                                  
  5146 00002ADA E93C00                   jmp @@retn
  5147                                  
  5148                                  ;-104         }
  5149                                  
  5150                                  
  5151                                  ;-105         genCode8(Code1); 
  5152                                  
  5153                                  @@process185:
  5154 00002ADD A0[AF01]                 mov al, byte [Code1]
  5155 00002AE0 B400                     mov ah, 0
  5156 00002AE2 50                       push ax
  5157 00002AE3 E8D6FB                   call genCode8
  5158 00002AE6 83C402                   add  sp, 2
  5159                                  
  5160                                  ;-106         return;
  5161                                  
  5162 00002AE9 E92D00                   jmp @@retn
  5163                                  
  5164                                  ;-107     }
  5165                                  
  5166                                  
  5167                                  ;-108 
  5168                                  
  5169                                  
  5170                                  ;-109     if (CodeType==101) {// ORG nn
  5171                                  
  5172                                  @@process184:
  5173 00002AEC A0[AE01]                 mov al, [CodeType]
  5174 00002AEF 3C65                     cmp al, 101
  5175 00002AF1 0F851B00                 jne @@process186
  5176                                  
  5177                                  ;-110         if (TokeType != DIGIT) error1("only digit allowed");
  5178                                  
  5179 00002AF5 A0[AB01]                 mov al, [TokeType]
  5180 00002AF8 3C01                     cmp al, 1
  5181 00002AFA 0F840900                 je  @@process187
  5182 00002AFE 68[1B2B]                 push process_0
  5183 00002B01 E802F6                   call error1
  5184 00002B04 83C402                   add  sp, 2
  5185                                  
  5186                                  ;-111         PC=SymbolInt;
  5187                                  
  5188                                  @@process187:
  5189 00002B07 A1[4D00]                 mov ax, [SymbolInt]
  5190 00002B0A A3[A601]                 mov word [PC], ax
  5191                                  
  5192                                  ;-112         return;
  5193                                  
  5194 00002B0D E90900                   jmp @@retn
  5195                                  
  5196                                  ;-113     }
  5197                                  
  5198                                  
  5199                                  ;-114     error1("unknown CodeType");
  5200                                  
  5201                                  @@process186:
  5202 00002B10 68[2E2B]                 push process_1
  5203 00002B13 E8F0F5                   call error1
  5204 00002B16 83C402                   add  sp, 2
  5205                                  
  5206                                  ;-115 }    
  5207                                  
  5208                                  
  5209                                  ;-116 
  5210                                  
  5211                                  
  5212                                  ;-117 int checkOpL() {
  5213                                  
  5214 00002B19 C9                      @@retn: LEAVE
  5215 00002B1A C3                       ret
  5216                                  ; ENDP
  5217 00002B1B 6F6E6C792064696769-     process_0 db "only digit allowed",0
  5218 00002B24 7420616C6C6F776564-
  5219 00002B2D 00                 
  5220 00002B2E 756E6B6E6F776E2043-     process_1 db "unknown CodeType",0
  5221 00002B37 6F64655479706500   
  5222                                  
  5223                                  checkOpL:  ; *** PROC ***
  5224                                  
  5225                                  ;-118     if (Op == ADR) implerror();
  5226                                  
  5227 00002B3F A0[AC01]                 mov al, [Op]
  5228 00002B42 3C03                     cmp al, 3
  5229 00002B44 0F850300                 jne @@checkOpL188
  5230 00002B48 E88BF6                   call implerror
  5231                                  
  5232                                  ;-119     if (RegType == SEGREG) {segregerror(); return;}//only move,push,pop
  5233                                  
  5234                                  @@checkOpL188:
  5235 00002B4B A0[B401]                 mov al, [RegType]
  5236 00002B4E 3C04                     cmp al, 4
  5237 00002B50 0F850600                 jne @@checkOpL189
  5238 00002B54 E847F7                   call segregerror
  5239 00002B57 E95300                   jmp @@retn
  5240                                  
  5241                                  ;-120     setwflag();
  5242                                  
  5243                                  @@checkOpL189:
  5244 00002B5A E8CB03                   call setwflag
  5245                                  
  5246                                  ;-121     if (OpSize == 0) error1("no op size declared");
  5247                                  
  5248 00002B5D A0[B601]                 mov al, [OpSize]
  5249 00002B60 3C00                     cmp al, 0
  5250 00002B62 0F850900                 jne @@checkOpL190
  5251 00002B66 68[AE2B]                 push checkOpL_0
  5252 00002B69 E89AF5                   call error1
  5253 00002B6C 83C402                   add  sp, 2
  5254                                  
  5255                                  ;-122     if (OpSize == R1Type) return;
  5256                                  
  5257                                  @@checkOpL190:
  5258 00002B6F A0[B601]                 mov al, [OpSize]
  5259 00002B72 3A06[B501]               cmp al, [R1Type]
  5260 00002B76 0F850300                 jne @@checkOpL191
  5261 00002B7A E93000                   jmp @@retn
  5262                                  
  5263                                  ;-123     if (OpSize){
  5264                                  
  5265                                  @@checkOpL191:
  5266 00002B7D A0[B601]                 mov al, [OpSize]
  5267 00002B80 08C0                     or  al, al
  5268 00002B82 0F841500                 je @@checkOpL192
  5269                                  
  5270                                  ;-124         if (Op == MEM) return;
  5271                                  
  5272 00002B86 A0[AC01]                 mov al, [Op]
  5273 00002B89 3C04                     cmp al, 4
  5274 00002B8B 0F850300                 jne @@checkOpL193
  5275 00002B8F E91B00                   jmp @@retn
  5276                                  
  5277                                  ;-125         error1("Conflict OpSize and RegSize"); 
  5278                                  
  5279                                  @@checkOpL193:
  5280 00002B92 68[C22B]                 push checkOpL_1
  5281 00002B95 E86EF5                   call error1
  5282 00002B98 83C402                   add  sp, 2
  5283                                  
  5284                                  ;-126         }
  5285                                  
  5286                                  
  5287                                  ;-127     if (R1Type==0) error1("no register defined");
  5288                                  
  5289                                  @@checkOpL192:
  5290 00002B9B A0[B501]                 mov al, [R1Type]
  5291 00002B9E 3C00                     cmp al, 0
  5292 00002BA0 0F850900                 jne @@checkOpL194
  5293 00002BA4 68[DE2B]                 push checkOpL_2
  5294 00002BA7 E85CF5                   call error1
  5295 00002BAA 83C402                   add  sp, 2
  5296                                  
  5297                                  ;-128 }
  5298                                  
  5299                                  @@checkOpL194:
  5300                                  
  5301                                  ;-129 /*    Op, Op2 =0, 1=IMM, 2=REG, 3=ADR, 4=MEM 
  5302                                  
  5303                                  
  5304                                  ;-130 IMM      imme           = 0, SymbolInt
  5305                                  
  5306                                  
  5307                                  ;-131 REG      R1No,RegNo     = 0 - 7
  5308                                  
  5309                                  
  5310                                  ;-132 REG      R1Type,RegType = 0, BYTE, WORD, DWORD, SEGREG 
  5311                                  
  5312                                  
  5313                                  ;-133 MEM,ADR  disp           = 0, LabelAddr[LabelIx]
  5314                                  
  5315                                  
  5316                                  ;-134 MEM      regindexbase   = 0 - 7
  5317                                  
  5318                                  
  5319                                  ;-135          OpSize         = 0, BYTE, WORD, DWORD
  5320                                  
  5321                                  
  5322                                  ;-136          wflag          */         
  5323                                  
  5324                                  
  5325                                  ;-137 int get2Ops() {
  5326                                  
  5327                                  @@retn:
  5328 00002BAD C3                       ret
  5329                                  ; ENDP
  5330 00002BAE 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  5331 00002BB7 65206465636C617265-
  5332 00002BC0 6400               
  5333 00002BC2 436F6E666C69637420-     checkOpL_1 db "Conflict OpSize and RegSize",0
  5334 00002BCB 4F7053697A6520616E-
  5335 00002BD4 642052656753697A65-
  5336 00002BDD 00                 
  5337 00002BDE 6E6F20726567697374-     checkOpL_2 db "no register defined",0
  5338 00002BE7 657220646566696E65-
  5339 00002BF0 6400               
  5340                                  
  5341                                  get2Ops:  ; *** PROC ***
  5342                                  
  5343                                  ;-138     getOpL();
  5344                                  
  5345 00002BF2 E80C00                   call getOpL
  5346                                  
  5347                                  ;-139     need(',');    
  5348                                  
  5349 00002BF5 6A2C                     push 44
  5350 00002BF7 E8E2EA                   call need
  5351 00002BFA 83C402                   add  sp, 2
  5352                                  
  5353                                  ;-140     getOpR();         
  5354                                  
  5355 00002BFD E84D00                   call getOpR
  5356                                  
  5357                                  ;-141 }         
  5358                                  
  5359                                  
  5360                                  ;-142 int getOpL() {
  5361                                  
  5362 00002C00 C3                       ret
  5363                                  ; ENDP
  5364                                  
  5365                                  getOpL:  ; *** PROC ***
  5366                                  
  5367                                  ;-143 //set: op=0,IMM,REG,ADR,MEM
  5368                                  
  5369                                  
  5370                                  ;-144     disp=0; imme=0; isDirect=1; 
  5371                                  
  5372 00002C01 66B800000000             mov eax, 0
  5373 00002C07 A3[BB01]                 mov word [disp], ax
  5374 00002C0A 66B800000000             mov eax, 0
  5375 00002C10 A3[BD01]                 mov word [imme], ax
  5376 00002C13 66B801000000             mov eax, 1
  5377 00002C19 A2[BA01]                 mov byte [isDirect], al
  5378                                  
  5379                                  ;-145     getOpR();
  5380                                  
  5381 00002C1C E82E00                   call getOpR
  5382                                  
  5383                                  ;-146     Op=Op2;         Op2=0;
  5384                                  
  5385 00002C1F A0[AD01]                 mov al, [Op2]
  5386 00002C22 A2[AC01]                 mov byte [Op], al
  5387 00002C25 66B800000000             mov eax, 0
  5388 00002C2B A2[AD01]                 mov byte [Op2], al
  5389                                  
  5390                                  ;-147     R1No=RegNo;     RegNo=0;
  5391                                  
  5392 00002C2E A0[B201]                 mov al, [RegNo]
  5393 00002C31 A2[B301]                 mov byte [R1No], al
  5394 00002C34 66B800000000             mov eax, 0
  5395 00002C3A A2[B201]                 mov byte [RegNo], al
  5396                                  
  5397                                  ;-148     R1Type=RegType; RegType=0; 
  5398                                  
  5399 00002C3D A0[B401]                 mov al, [RegType]
  5400 00002C40 A2[B501]                 mov byte [R1Type], al
  5401 00002C43 66B800000000             mov eax, 0
  5402 00002C49 A2[B401]                 mov byte [RegType], al
  5403                                  
  5404                                  ;-149 }  
  5405                                  
  5406                                  
  5407                                  ;-150 
  5408                                  
  5409                                  
  5410                                  ;-151 int getOpR() {
  5411                                  
  5412 00002C4C C3                       ret
  5413                                  ; ENDP
  5414                                  
  5415                                  getOpR:  ; *** PROC ***
  5416                                  
  5417                                  ;-152     Op2=getOp1();
  5418                                  
  5419 00002C4D E88900                   call getOp1
  5420 00002C50 A2[AD01]                 mov byte [Op2], al
  5421                                  
  5422                                  ;-153     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  5423                                  
  5424 00002C53 6A5B                     push 91
  5425 00002C55 E856EA                   call isToken
  5426 00002C58 83C402                   add  sp, 2
  5427 00002C5B 08C0                     or  al, al
  5428 00002C5D 0F840F00                 je @@getOpR195
  5429 00002C61 66B804000000             mov eax, 4
  5430 00002C67 A2[AD01]                 mov byte [Op2], al
  5431 00002C6A E8F200                   call getMEM
  5432 00002C6D E94F00                   jmp @@retn
  5433                                  
  5434                                  ;-154     if (Op2 == 0)     {invaloperror();         return;}
  5435                                  
  5436                                  @@getOpR195:
  5437 00002C70 A0[AD01]                 mov al, [Op2]
  5438 00002C73 3C00                     cmp al, 0
  5439 00002C75 0F850600                 jne @@getOpR196
  5440 00002C79 E895F5                   call invaloperror
  5441 00002C7C E94000                   jmp @@retn
  5442                                  
  5443                                  ;-155     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  5444                                  
  5445                                  @@getOpR196:
  5446 00002C7F A0[AD01]                 mov al, [Op2]
  5447 00002C82 3C01                     cmp al, 1
  5448 00002C84 0F850900                 jne @@getOpR197
  5449 00002C88 A1[4D00]                 mov ax, [SymbolInt]
  5450 00002C8B A3[BD01]                 mov word [imme], ax
  5451 00002C8E E92E00                   jmp @@retn
  5452                                  
  5453                                  ;-156     if (Op2 == REG)                            return;
  5454                                  
  5455                                  @@getOpR197:
  5456 00002C91 A0[AD01]                 mov al, [Op2]
  5457 00002C94 3C02                     cmp al, 2
  5458 00002C96 0F850300                 jne @@getOpR198
  5459 00002C9A E92200                   jmp @@retn
  5460                                  
  5461                                  ;-157     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  5462                                  
  5463                                  @@getOpR198:
  5464 00002C9D A0[AD01]                 mov al, [Op2]
  5465 00002CA0 3C03                     cmp al, 3
  5466 00002CA2 0F851000                 jne @@getOpR199
  5467 00002CA6 8B1E[7D06]               mov bx, [LabelIx]
  5468 00002CAA D1E3                     shl bx, 1
  5469 00002CAC 8B87[B305]               mov ax, [LabelAddr + bx]
  5470 00002CB0 A3[BB01]                 mov word [disp], ax
  5471 00002CB3 E90900                   jmp @@retn
  5472                                  
  5473                                  ;-158     error1("Name of operand expected");
  5474                                  
  5475                                  @@getOpR199:
  5476 00002CB6 68[C02C]                 push getOpR_0
  5477 00002CB9 E84AF4                   call error1
  5478 00002CBC 83C402                   add  sp, 2
  5479                                  
  5480                                  ;-159 }
  5481                                  
  5482                                  
  5483                                  ;-160 
  5484                                  
  5485                                  
  5486                                  ;-161 int getOp1() {//scan for a single operand
  5487                                  
  5488                                  @@retn:
  5489 00002CBF C3                       ret
  5490                                  ; ENDP
  5491 00002CC0 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  5492 00002CC9 706572616E64206578-
  5493 00002CD2 70656374656400     
  5494                                  
  5495                                  getOp1:  ; *** PROC ***
  5496                                  
  5497                                  ;-162 //return:0, IMM, REG, ADR (not MEM)
  5498                                  
  5499                                  
  5500                                  ;-163 //set   :RegType, RegNo by testReg
  5501                                  
  5502                                  
  5503                                  ;-164 //set   :LabelIx by searchLabel
  5504                                  
  5505                                  
  5506                                  ;-165     if (TokeType == 0)      return 0;
  5507                                  
  5508 00002CD9 A0[AB01]                 mov al, [TokeType]
  5509 00002CDC 3C00                     cmp al, 0
  5510 00002CDE 0F850900                 jne @@getOp1200
  5511 00002CE2 66B800000000             mov eax, 0
  5512 00002CE8 E96000                   jmp @@retn
  5513                                  
  5514                                  ;-166     if (TokeType == DIGIT)  return IMM;
  5515                                  
  5516                                  @@getOp1200:
  5517 00002CEB A0[AB01]                 mov al, [TokeType]
  5518 00002CEE 3C01                     cmp al, 1
  5519 00002CF0 0F850900                 jne @@getOp1201
  5520 00002CF4 66B801000000             mov eax, 1
  5521 00002CFA E94E00                   jmp @@retn
  5522                                  
  5523                                  ;-167     if (TokeType == ALNUME) {
  5524                                  
  5525                                  @@getOp1201:
  5526 00002CFD A0[AB01]                 mov al, [TokeType]
  5527 00002D00 3C03                     cmp al, 3
  5528 00002D02 0F853C00                 jne @@getOp1202
  5529                                  
  5530                                  ;-168         RegNo=testReg();
  5531                                  
  5532 00002D06 E852ED                   call testReg
  5533 00002D09 A2[B201]                 mov byte [RegNo], al
  5534                                  
  5535                                  ;-169         if (RegType)        return REG;
  5536                                  
  5537 00002D0C A0[B401]                 mov al, [RegType]
  5538 00002D0F 08C0                     or  al, al
  5539 00002D11 0F840900                 je @@getOp1203
  5540 00002D15 66B802000000             mov eax, 2
  5541 00002D1B E92D00                   jmp @@retn
  5542                                  
  5543                                  ;-170         LabelIx=searchLabel();
  5544                                  
  5545                                  @@getOp1203:
  5546 00002D1E E8F8E6                   call searchLabel
  5547 00002D21 A3[7D06]                 mov word [LabelIx], ax
  5548                                  
  5549                                  ;-171         if (LabelIx)        return ADR;
  5550                                  
  5551 00002D24 A1[7D06]                 mov ax, [LabelIx]
  5552 00002D27 08C0                     or  al, al
  5553 00002D29 0F840C00                 je @@getOp1204
  5554 00002D2D 66B803000000             mov eax, 3
  5555 00002D33 E91500                   jmp @@retn
  5556                                  
  5557                                  ;-172         else error1("variable not found"); 
  5558                                  
  5559 00002D36 E90900                   jmp @@getOp1205
  5560                                  @@getOp1204:
  5561 00002D39 68[4C2D]                 push getOp1_0
  5562 00002D3C E8C7F3                   call error1
  5563 00002D3F 83C402                   add  sp, 2
  5564                                  
  5565                                  ;-173     }
  5566                                  
  5567                                  @@getOp1205:
  5568                                  
  5569                                  ;-174     return 0;
  5570                                  
  5571                                  @@getOp1202:
  5572 00002D42 66B800000000             mov eax, 0
  5573 00002D48 E90000                   jmp @@retn
  5574                                  
  5575                                  ;-175 }
  5576                                  
  5577                                  
  5578                                  ;-176 
  5579                                  
  5580                                  
  5581                                  ;-177 int getMEM() {// e.g. [array+bp+si-4]
  5582                                  
  5583                                  @@retn:
  5584 00002D4B C3                       ret
  5585                                  ; ENDP
  5586 00002D4C 7661726961626C6520-     getOp1_0 db "variable not found",0
  5587 00002D55 6E6F7420666F756E64-
  5588 00002D5E 00                 
  5589                                  
  5590                                  getMEM:  ; *** PROC ***
  5591                                  
  5592                                  ;-178 //set: disp, regindexbase, RegType
  5593                                  
  5594                                  
  5595                                  ;-179     char c;
  5596                                  
  5597                                  
  5598                                  ;-180     disp=0; regindexbase=0;
  5599                                  
  5600                                  ;Function : getMEM, Number of local variables: 1
  5601                                  ;   # type sign width line used address name   list of local variables
  5602                                  ;  200 var sign byte   179 NULL bp-2    c;
  5603 00002D5F C8020000                 ENTER  2,0
  5604 00002D63 66B800000000             mov eax, 0
  5605 00002D69 A3[BB01]                 mov word [disp], ax
  5606 00002D6C 66B800000000             mov eax, 0
  5607 00002D72 A2[B901]                 mov byte [regindexbase], al
  5608                                  
  5609                                  ;-181     do {
  5610                                  
  5611                                  @@getMEM206:
  5612                                  
  5613                                  ;-182         getTokeType();
  5614                                  
  5615 00002D75 E860E5                   call getTokeType
  5616                                  
  5617                                  ;-183         c=getOp1();
  5618                                  
  5619 00002D78 E85EFF                   call getOp1
  5620 00002D7B 8846FE                   mov byte [bp-2], al
  5621                                  
  5622                                  ;-184         if (c ==   0) syntaxerror();
  5623                                  
  5624 00002D7E 8A46FE                   mov al, [bp-2]
  5625 00002D81 3C00                     cmp al, 0
  5626 00002D83 0F850300                 jne @@getMEM207
  5627 00002D87 E83BF5                   call syntaxerror
  5628                                  
  5629                                  ;-185         if (c == REG) {isDirect=0;
  5630                                  
  5631                                  @@getMEM207:
  5632 00002D8A 8A46FE                   mov al, [bp-2]
  5633 00002D8D 3C02                     cmp al, 2
  5634 00002D8F 0F851E00                 jne @@getMEM208
  5635 00002D93 66B800000000             mov eax, 0
  5636 00002D99 A2[BA01]                 mov byte [isDirect], al
  5637                                  
  5638                                  ;-186             if (regindexbase) regindexbase=getIndReg2();
  5639                                  
  5640 00002D9C A0[B901]                 mov al, [regindexbase]
  5641 00002D9F 08C0                     or  al, al
  5642 00002DA1 0F840900                 je @@getMEM209
  5643 00002DA5 E8F300                   call getIndReg2
  5644 00002DA8 A2[B901]                 mov byte [regindexbase], al
  5645                                  
  5646                                  ;-187             else getIndReg1();
  5647                                  
  5648 00002DAB E90300                   jmp @@getMEM210
  5649                                  @@getMEM209:
  5650 00002DAE E88900                   call getIndReg1
  5651                                  
  5652                                  ;-188         }
  5653                                  
  5654                                  @@getMEM210:
  5655                                  
  5656                                  ;-189         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  5657                                  
  5658                                  @@getMEM208:
  5659 00002DB1 8A46FE                   mov al, [bp-2]
  5660 00002DB4 3C03                     cmp al, 3
  5661 00002DB6 0F851000                 jne @@getMEM211
  5662 00002DBA A1[BB01]                 mov ax, [disp]
  5663 00002DBD 8B1E[7D06]               mov bx, [LabelIx]
  5664 00002DC1 D1E3                     shl bx, 1
  5665 00002DC3 0387[B305]               add ax, [LabelAddr + bx]
  5666 00002DC7 A3[BB01]                 mov word [disp], ax
  5667                                  
  5668                                  ;-190         if (c == IMM) disp=disp+SymbolInt;
  5669                                  
  5670                                  @@getMEM211:
  5671 00002DCA 8A46FE                   mov al, [bp-2]
  5672 00002DCD 3C01                     cmp al, 1
  5673 00002DCF 0F850A00                 jne @@getMEM212
  5674 00002DD3 A1[BB01]                 mov ax, [disp]
  5675 00002DD6 0306[4D00]               add ax, [SymbolInt]
  5676 00002DDA A3[BB01]                 mov word [disp], ax
  5677                                  
  5678                                  ;-191         if (isToken('-')) {
  5679                                  
  5680                                  @@getMEM212:
  5681 00002DDD 6A2D                     push 45
  5682 00002DDF E8CCE8                   call isToken
  5683 00002DE2 83C402                   add  sp, 2
  5684 00002DE5 08C0                     or  al, al
  5685 00002DE7 0F841900                 je @@getMEM213
  5686                                  
  5687                                  ;-192             getTokeType();
  5688                                  
  5689 00002DEB E8EAE4                   call getTokeType
  5690                                  
  5691                                  ;-193             if (TokeType != DIGIT) numbererror();
  5692                                  
  5693 00002DEE A0[AB01]                 mov al, [TokeType]
  5694 00002DF1 3C01                     cmp al, 1
  5695 00002DF3 0F840300                 je  @@getMEM214
  5696 00002DF7 E838F4                   call numbererror
  5697                                  
  5698                                  ;-194             disp = disp - SymbolInt;
  5699                                  
  5700                                  @@getMEM214:
  5701 00002DFA A1[BB01]                 mov ax, [disp]
  5702 00002DFD 2B06[4D00]               sub ax, [SymbolInt]
  5703 00002E01 A3[BB01]                 mov word [disp], ax
  5704                                  
  5705                                  ;-195         }
  5706                                  
  5707                                  
  5708                                  ;-196     } while (isToken('+'));
  5709                                  
  5710                                  @@getMEM213:
  5711 00002E04 6A2B                     push 43
  5712 00002E06 E8A5E8                   call isToken
  5713 00002E09 83C402                   add  sp, 2
  5714 00002E0C 08C0                     or  al, al
  5715 00002E0E 0F840300                 je @@getMEM215
  5716 00002E12 E960FF                   jmp @@getMEM206
  5717                                  @@getMEM215:
  5718                                  
  5719                                  ;-197     if (isToken(']') == 0) errorexit("] expected");
  5720                                  
  5721 00002E15 6A5D                     push 93
  5722 00002E17 E894E8                   call isToken
  5723 00002E1A 83C402                   add  sp, 2
  5724 00002E1D 83F800                   cmp ax, 0
  5725 00002E20 0F850900                 jne @@getMEM216
  5726 00002E24 68[2F2E]                 push getMEM_0
  5727 00002E27 E83BF3                   call errorexit
  5728 00002E2A 83C402                   add  sp, 2
  5729                                  
  5730                                  ;-198 }
  5731                                  
  5732                                  @@getMEM216:
  5733                                  
  5734                                  ;-199 int getIndReg1() {
  5735 00002E2D C9                       LEAVE
  5736 00002E2E C3                       ret
  5737                                  ; ENDP
  5738 00002E2F 5D2065787065637465-     getMEM_0 db "] expected",0
  5739 00002E38 6400               
  5740                                  
  5741                                  getIndReg1:  ; *** PROC ***
  5742                                  
  5743                                  ;-200     if (RegType !=WORD) indexerror();
  5744                                  
  5745 00002E3A A0[B401]                 mov al, [RegType]
  5746 00002E3D 3C02                     cmp al, 2
  5747 00002E3F 0F840300                 je  @@getIndReg1217
  5748 00002E43 E8AAF3                   call indexerror
  5749                                  
  5750                                  ;-201     if (RegNo==3) regindexbase=7;//BX
  5751                                  
  5752                                  @@getIndReg1217:
  5753 00002E46 A0[B201]                 mov al, [RegNo]
  5754 00002E49 3C03                     cmp al, 3
  5755 00002E4B 0F850900                 jne @@getIndReg1218
  5756 00002E4F 66B807000000             mov eax, 7
  5757 00002E55 A2[B901]                 mov byte [regindexbase], al
  5758                                  
  5759                                  ;-202     if (RegNo==5) regindexbase=6;//BP, change to BP+0
  5760                                  
  5761                                  @@getIndReg1218:
  5762 00002E58 A0[B201]                 mov al, [RegNo]
  5763 00002E5B 3C05                     cmp al, 5
  5764 00002E5D 0F850900                 jne @@getIndReg1219
  5765 00002E61 66B806000000             mov eax, 6
  5766 00002E67 A2[B901]                 mov byte [regindexbase], al
  5767                                  
  5768                                  ;-203     if (RegNo==7) regindexbase=5;//DI
  5769                                  
  5770                                  @@getIndReg1219:
  5771 00002E6A A0[B201]                 mov al, [RegNo]
  5772 00002E6D 3C07                     cmp al, 7
  5773 00002E6F 0F850900                 jne @@getIndReg1220
  5774 00002E73 66B805000000             mov eax, 5
  5775 00002E79 A2[B901]                 mov byte [regindexbase], al
  5776                                  
  5777                                  ;-204     if (RegNo==6) regindexbase=4;//SI
  5778                                  
  5779                                  @@getIndReg1220:
  5780 00002E7C A0[B201]                 mov al, [RegNo]
  5781 00002E7F 3C06                     cmp al, 6
  5782 00002E81 0F850900                 jne @@getIndReg1221
  5783 00002E85 66B804000000             mov eax, 4
  5784 00002E8B A2[B901]                 mov byte [regindexbase], al
  5785                                  
  5786                                  ;-205     if (regindexbase==0) indexerror();
  5787                                  
  5788                                  @@getIndReg1221:
  5789 00002E8E A0[B901]                 mov al, [regindexbase]
  5790 00002E91 3C00                     cmp al, 0
  5791 00002E93 0F850300                 jne @@getIndReg1222
  5792 00002E97 E856F3                   call indexerror
  5793                                  
  5794                                  ;-206 }
  5795                                  
  5796                                  @@getIndReg1222:
  5797                                  
  5798                                  ;-207 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  5799                                  
  5800 00002E9A C3                       ret
  5801                                  ; ENDP
  5802                                  
  5803                                  getIndReg2:  ; *** PROC ***
  5804                                  ;Function : getIndReg2, Number of local variables: 1
  5805                                  ;   # type sign width line used address name   list of local variables
  5806                                  ;  200 var sign byte   207 NULL bp-2    m;
  5807 00002E9B C8020000                 ENTER  2,0
  5808 00002E9F 66B804000000             mov eax, 4
  5809 00002EA5 8846FE                   mov byte [bp-2], al
  5810                                  
  5811                                  ;-208     if (RegType !=WORD) indexerror();
  5812                                  
  5813 00002EA8 A0[B401]                 mov al, [RegType]
  5814 00002EAB 3C02                     cmp al, 2
  5815 00002EAD 0F840300                 je  @@getIndReg2223
  5816 00002EB1 E83CF3                   call indexerror
  5817                                  
  5818                                  ;-209     if (RegNo==7) if (regindexbase==6) m=3;//BP+DI
  5819                                  
  5820                                  @@getIndReg2223:
  5821 00002EB4 A0[B201]                 mov al, [RegNo]
  5822 00002EB7 3C07                     cmp al, 7
  5823 00002EB9 0F852700                 jne @@getIndReg2224
  5824 00002EBD A0[B901]                 mov al, [regindexbase]
  5825 00002EC0 3C06                     cmp al, 6
  5826 00002EC2 0F850C00                 jne @@getIndReg2225
  5827 00002EC6 66B803000000             mov eax, 3
  5828 00002ECC 8846FE                   mov byte [bp-2], al
  5829                                  
  5830                                  ;-210              else if (regindexbase==7) m=1;//BX+DI
  5831                                  
  5832 00002ECF E91200                   jmp @@getIndReg2226
  5833                                  @@getIndReg2225:
  5834 00002ED2 A0[B901]                 mov al, [regindexbase]
  5835 00002ED5 3C07                     cmp al, 7
  5836 00002ED7 0F850900                 jne @@getIndReg2227
  5837 00002EDB 66B801000000             mov eax, 1
  5838 00002EE1 8846FE                   mov byte [bp-2], al
  5839                                  
  5840                                  ;-211     if (RegNo==6) if (regindexbase==6) m=2;//BP+SI
  5841                                  
  5842                                  @@getIndReg2227:
  5843                                  @@getIndReg2226:
  5844                                  @@getIndReg2224:
  5845 00002EE4 A0[B201]                 mov al, [RegNo]
  5846 00002EE7 3C06                     cmp al, 6
  5847 00002EE9 0F852700                 jne @@getIndReg2228
  5848 00002EED A0[B901]                 mov al, [regindexbase]
  5849 00002EF0 3C06                     cmp al, 6
  5850 00002EF2 0F850C00                 jne @@getIndReg2229
  5851 00002EF6 66B802000000             mov eax, 2
  5852 00002EFC 8846FE                   mov byte [bp-2], al
  5853                                  
  5854                                  ;-212              else if (regindexbase==7) m=0;//BX+SI
  5855                                  
  5856 00002EFF E91200                   jmp @@getIndReg2230
  5857                                  @@getIndReg2229:
  5858 00002F02 A0[B901]                 mov al, [regindexbase]
  5859 00002F05 3C07                     cmp al, 7
  5860 00002F07 0F850900                 jne @@getIndReg2231
  5861 00002F0B 66B800000000             mov eax, 0
  5862 00002F11 8846FE                   mov byte [bp-2], al
  5863                                  
  5864                                  ;-213     if (m > 3) indexerror();
  5865                                  
  5866                                  @@getIndReg2231:
  5867                                  @@getIndReg2230:
  5868                                  @@getIndReg2228:
  5869 00002F14 8A46FE                   mov al, [bp-2]
  5870 00002F17 3C03                     cmp al, 3
  5871 00002F19 0F8E0300                 jle @@getIndReg2232
  5872 00002F1D E8D0F2                   call indexerror
  5873                                  
  5874                                  ;-214     return m;
  5875                                  
  5876                                  @@getIndReg2232:
  5877 00002F20 8A46FE                   mov al, [bp-2]
  5878 00002F23 E90000                   jmp @@retn
  5879                                  
  5880                                  ;-215 }
  5881                                  
  5882                                  
  5883                                  ;-216          
  5884                                  
  5885                                  
  5886                                  ;-217          
  5887                                  
  5888                                  
  5889                                  ;-218 int setwflag() {//word size, bit 0
  5890                                  
  5891 00002F26 C9                      @@retn: LEAVE
  5892 00002F27 C3                       ret
  5893                                  ; ENDP
  5894                                  
  5895                                  setwflag:  ; *** PROC ***
  5896                                  
  5897                                  ;-219     wflag=0;
  5898                                  
  5899 00002F28 66B800000000             mov eax, 0
  5900 00002F2E A2[B701]                 mov byte [wflag], al
  5901                                  
  5902                                  ;-220     if (OpSize == 0) {//do not override OpSize
  5903                                  
  5904 00002F31 A0[B601]                 mov al, [OpSize]
  5905 00002F34 3C00                     cmp al, 0
  5906 00002F36 0F854200                 jne @@setwflag233
  5907                                  
  5908                                  ;-221         if (Op == REG) OpSize=R1Type;
  5909                                  
  5910 00002F3A A0[AC01]                 mov al, [Op]
  5911 00002F3D 3C02                     cmp al, 2
  5912 00002F3F 0F850600                 jne @@setwflag234
  5913 00002F43 A0[B501]                 mov al, [R1Type]
  5914 00002F46 A2[B601]                 mov byte [OpSize], al
  5915                                  
  5916                                  ;-222         if (Op2== REG) OpSize=RegType;        
  5917                                  
  5918                                  @@setwflag234:
  5919 00002F49 A0[AD01]                 mov al, [Op2]
  5920 00002F4C 3C02                     cmp al, 2
  5921 00002F4E 0F850600                 jne @@setwflag235
  5922 00002F52 A0[B401]                 mov al, [RegType]
  5923 00002F55 A2[B601]                 mov byte [OpSize], al
  5924                                  
  5925                                  ;-223         if (RegType== SEGREG) OpSize=WORD;
  5926                                  
  5927                                  @@setwflag235:
  5928 00002F58 A0[B401]                 mov al, [RegType]
  5929 00002F5B 3C04                     cmp al, 4
  5930 00002F5D 0F850900                 jne @@setwflag236
  5931 00002F61 66B802000000             mov eax, 2
  5932 00002F67 A2[B601]                 mov byte [OpSize], al
  5933                                  
  5934                                  ;-224         if (R1Type == SEGREG) OpSize=WORD;        
  5935                                  
  5936                                  @@setwflag236:
  5937 00002F6A A0[B501]                 mov al, [R1Type]
  5938 00002F6D 3C04                     cmp al, 4
  5939 00002F6F 0F850900                 jne @@setwflag237
  5940 00002F73 66B802000000             mov eax, 2
  5941 00002F79 A2[B601]                 mov byte [OpSize], al
  5942                                  
  5943                                  ;-225     }
  5944                                  
  5945                                  @@setwflag237:
  5946                                  
  5947                                  ;-226     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  5948                                  
  5949                                  @@setwflag233:
  5950 00002F7C A0[B601]                 mov al, [OpSize]
  5951 00002F7F 3C03                     cmp al, 3
  5952 00002F81 0F850C00                 jne @@setwflag238
  5953 00002F85 E8F4F6                   call gen66h
  5954 00002F88 66B801000000             mov eax, 1
  5955 00002F8E A2[B701]                 mov byte [wflag], al
  5956                                  
  5957                                  ;-227     if (OpSize  ==  WORD) wflag=1;
  5958                                  
  5959                                  @@setwflag238:
  5960 00002F91 A0[B601]                 mov al, [OpSize]
  5961 00002F94 3C02                     cmp al, 2
  5962 00002F96 0F850900                 jne @@setwflag239
  5963 00002F9A 66B801000000             mov eax, 1
  5964 00002FA0 A2[B701]                 mov byte [wflag], al
  5965                                  
  5966                                  ;-228 }
  5967                                  
  5968                                  @@setwflag239:
  5969                                  
  5970                                  ;-229 
  5971                                  
  5972                                  
  5973                                  ;-230 int setsflag() {//sign-extend, bit 1  
  5974                                  
  5975 00002FA3 C3                       ret
  5976                                  ; ENDP
  5977                                  
  5978                                  setsflag:  ; *** PROC ***
  5979                                  
  5980                                  ;-231     sflag=2;  
  5981                                  
  5982 00002FA4 66B802000000             mov eax, 2
  5983 00002FAA A2[B801]                 mov byte [sflag], al
  5984                                  
  5985                                  ;-232     if(imme > 127) sflag = 0;//qirks in NASM, 255 is better    
  5986                                  
  5987 00002FAD A1[BD01]                 mov ax, [imme]
  5988 00002FB0 83F87F                   cmp ax, 127
  5989 00002FB3 0F8E0900                 jle @@setsflag240
  5990 00002FB7 66B800000000             mov eax, 0
  5991 00002FBD A2[B801]                 mov byte [sflag], al
  5992                                  
  5993                                  ;-233     if (OpSize == BYTE) {
  5994                                  
  5995                                  @@setsflag240:
  5996 00002FC0 A0[B601]                 mov al, [OpSize]
  5997 00002FC3 3C01                     cmp al, 1
  5998 00002FC5 0F851C00                 jne @@setsflag241
  5999                                  
  6000                                  ;-234         if (imme > 255) error1("too big for byte r/m");
  6001                                  
  6002 00002FC9 A1[BD01]                 mov ax, [imme]
  6003 00002FCC 3DFF00                   cmp ax, 255
  6004 00002FCF 0F8E0900                 jle @@setsflag242
  6005 00002FD3 68[E62F]                 push setsflag_0
  6006 00002FD6 E82DF1                   call error1
  6007 00002FD9 83C402                   add  sp, 2
  6008                                  
  6009                                  ;-235         sflag=0;//byte reg does not need sign extended   
  6010                                  
  6011                                  @@setsflag242:
  6012 00002FDC 66B800000000             mov eax, 0
  6013 00002FE2 A2[B801]                 mov byte [sflag], al
  6014                                  
  6015                                  ;-236     }
  6016                                  
  6017                                  
  6018                                  ;-237 }
  6019                                  
  6020                                  @@setsflag241:
  6021 00002FE5 C3                       ret
  6022                                  ; ENDP
  6023 00002FE6 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  6024 00002FEF 6F7220627974652072-
  6025 00002FF8 2F6D00             
  6026                                   
  6027                                  ; missing functions: 
  6028                                  ; digit
  6029                                  ; strcpy
  6030                                  ; eqstr
  6031                                  ; strlen
  6032                                  ; eqstr
  6033                                  ; eqstr
  6034                                  ; eqstr
  6035                                  ; eqstr
  6036                                  ; readRL
  6037                                  ; readRL
  6038                                  ; digit
  6039                                  ; digit
  6040                                  ; strcpy
  6041                                  ; toupper
  6042                                  ; strlen
  6043                                  ; strlen
  6044                                  ; eqstr
  6045                                  ; eqstr
  6046                                  ; eqstr
  6047                                  ; eqstr
  6048                                  ; eqstr
  6049                                  ; eqstr
  6050                                  ; eqstr
  6051                                  ; eqstr
  6052                                  ; eqstr
  6053                                  ; eqstr
  6054                                  ; eqstr
  6055                                  ; eqstr
  6056                                  ; eqstr
  6057                                  ; eqstr
  6058                                  ; eqstr
  6059                                  ; eqstr
  6060                                  ; eqstr
  6061                                  ; eqstr
  6062                                  ; eqstr
  6063                                  ; eqstr
  6064                                  ; eqstr
  6065                                  ; eqstr
  6066                                  ; eqstr
  6067                                  ; eqstr
  6068                                  ; eqstr
  6069                                  ; eqstr
  6070                                  ; eqstr
  6071                                  ; eqstr
  6072                                  ; eqstr
  6073                                  ; eqstr
  6074                                  ; writetty
  6075                                  ; writetty
  6076                                  ; fputcR
  6077                                  ; cputs
  6078                                  ; cputs
  6079                                  ; exitR
  6080                                  ; toupper
  6081                                  ; strcpy
  6082                                  ; strcat1
  6083                                  ; strcpy
  6084                                  ; strcat1
  6085                                  ; strcpy
  6086                                  ; strcat1
  6087                                  ; openR
  6088                                  ; cputs
  6089                                  ; cputs
  6090                                  ; exitR
  6091                                  ; creatR
  6092                                  ; cputs
  6093                                  ; cputs
  6094                                  ; exitR
  6095                                  ; creatR
  6096                                  ; cputs
  6097                                  ; cputs
  6098                                  ; exitR
  6099                                  ; fputcR
  6100                                  ; fcloseR
  6101                                  ; fcloseR
  6102                                  ; fcloseR
  6103                                  ; exitR
  6104                                  ; Number of unresolved CALLs :   76
  6105                                  ;use archive file: AR.C
  6106                                  
  6107                                  ;-238 // AR.C Archive
  6108                                  
  6109                                  ;Number of CALLs:    2 : writetty
  6110                                  
  6111                                  writetty:  ; *** PROC ***
  6112 00002FFB B40E                     mov  ah, 14
  6113 00002FFD BB0000                   mov  bx, 0
  6114 00003000 CD10                     int  16
  6115                                  
  6116                                  ;-239 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  6117                                  
  6118 00003002 C3                       ret
  6119                                  ; ENDP
  6120                                  ;Number of CALLs:    8 : cputs
  6121                                  
  6122                                  cputs:  ; *** PROC ***
  6123                                  ;Function : cputs, Number of local variables: 2
  6124                                  ;   # type sign width line used address name   list of local variables
  6125                                  ;  200 ptr sign byte   239 NULL bp+4    s
  6126                                  ;  201 var sign byte   239 NULL bp-2    c;
  6127 00003003 C8020000                 ENTER  2,0
  6128                                  @@cputs243:
  6129 00003007 8B5E04                   mov bx, [bp+4]
  6130 0000300A 8A07                     mov al, [bx]
  6131 0000300C B400                     mov ah, 0
  6132 0000300E 08C0                     or  al, al
  6133 00003010 0F841B00                 je @@cputs244
  6134 00003014 8B5E04                   mov bx, [bp+4]
  6135 00003017 8A07                     mov al, [bx]
  6136 00003019 B400                     mov ah, 0
  6137 0000301B 8846FE                   mov byte [bp-2], al
  6138 0000301E 8A46FE                   mov al, byte [bp-2]
  6139 00003021 B400                     mov ah, 0
  6140 00003023 50                       push ax
  6141 00003024 E8C401                   call putch
  6142 00003027 83C402                   add  sp, 2
  6143 0000302A FF4604                   inc  word [bp+4]
  6144 0000302D EBD8                     jmp @@cputs243
  6145                                  @@cputs244:
  6146                                  
  6147                                  ;-240 int mkneg(int n) { n; __asm {neg ax} }
  6148 0000302F C9                       LEAVE
  6149 00003030 C3                       ret
  6150                                  ; ENDP
  6151                                  ;Number of CALLs:    2 : toupper
  6152                                  
  6153                                  toupper:  ; *** PROC ***
  6154                                  ;Function : toupper, Number of local variables: 1
  6155                                  ;   # type sign width line used address name   list of local variables
  6156                                  ;  200 ptr sign byte   240 NULL bp+4    s;
  6157 00003031 C8000000                 ENTER  0,0
  6158                                  @@toupper245:
  6159 00003035 8B5E04                   mov bx, [bp+4]
  6160 00003038 8A07                     mov al, [bx]
  6161 0000303A B400                     mov ah, 0
  6162 0000303C 08C0                     or  al, al
  6163 0000303E 0F843000                 je @@toupper246
  6164 00003042 8B5E04                   mov bx, [bp+4]
  6165 00003045 8A07                     mov al, [bx]
  6166 00003047 B400                     mov ah, 0
  6167 00003049 83F861                   cmp ax, 97 ;unsigned : 1
  6168 0000304C 0F8C1D00                 jl  @@toupper247
  6169 00003050 8B5E04                   mov bx, [bp+4]
  6170 00003053 8A07                     mov al, [bx]
  6171 00003055 B400                     mov ah, 0
  6172 00003057 83F87A                   cmp ax, 122
  6173 0000305A 0F8F0F00                 jg  @@toupper248
  6174 0000305E 8B5E04                   mov bx, [bp+4]
  6175 00003061 8A07                     mov al, [bx]
  6176 00003063 B400                     mov ah, 0
  6177 00003065 83E820                   sub ax, 32
  6178 00003068 8B5E04                   mov  bx, [bp+4]
  6179 0000306B 8807                     mov  [bx], al
  6180                                  @@toupper248:
  6181                                  @@toupper247:
  6182 0000306D FF4604                   inc  word [bp+4]
  6183 00003070 EBC3                     jmp @@toupper245
  6184                                  @@toupper246:
  6185                                  
  6186                                  ;-241 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  6187                                  
  6188                                  
  6189                                  ;-242 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  6190 00003072 C9                       LEAVE
  6191 00003073 C3                       ret
  6192                                  ; ENDP
  6193                                  ;Number of CALLs:    3 : strlen
  6194                                  
  6195                                  strlen:  ; *** PROC ***
  6196                                  ;Function : strlen, Number of local variables: 2
  6197                                  ;   # type sign width line used address name   list of local variables
  6198                                  ;  200 ptr sign byte   242 NULL bp+4    s
  6199                                  ;  201 var sign word   242 NULL bp-2    c;
  6200 00003074 C8020000                 ENTER  2,0
  6201 00003078 66B800000000             mov eax, 0
  6202 0000307E 8946FE                   mov word [bp-2], ax
  6203                                  @@strlen249:
  6204 00003081 8B5E04                   mov bx, [bp+4]
  6205 00003084 8A07                     mov al, [bx]
  6206 00003086 B400                     mov ah, 0
  6207 00003088 83F800                   cmp ax, 0
  6208 0000308B 0F840800                 je  @@strlen250
  6209 0000308F FF4604                   inc  word [bp+4]
  6210 00003092 FF46FE                   inc  word [bp-2]
  6211 00003095 EBEA                     jmp @@strlen249
  6212                                  @@strlen250:
  6213 00003097 8B46FE                   mov ax, [bp-2]
  6214 0000309A E90000                   jmp @@retn
  6215                                  
  6216                                  ;-243 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  6217                                  
  6218 0000309D C9                      @@retn: LEAVE
  6219 0000309E C3                       ret
  6220                                  ; ENDP
  6221                                  ;Number of CALLs:    5 : strcpy
  6222                                  
  6223                                  strcpy:  ; *** PROC ***
  6224                                  ;Function : strcpy, Number of local variables: 2
  6225                                  ;   # type sign width line used address name   list of local variables
  6226                                  ;  200 ptr sign byte   243 NULL bp+4    s
  6227                                  ;  201 ptr sign byte   243 NULL bp+6    t;
  6228 0000309F C8000000                 ENTER  0,0
  6229                                  @@strcpy251:
  6230 000030A3 8B5E06                   mov bx, [bp+6]
  6231 000030A6 8A07                     mov al, [bx]
  6232 000030A8 B400                     mov ah, 0
  6233 000030AA 8B5E04                   mov  bx, [bp+4]
  6234 000030AD 8807                     mov  [bx], al
  6235 000030AF FF4604                   inc  word [bp+4]
  6236 000030B2 FF4606                   inc  word [bp+6]
  6237                                  
  6238                                  ;-244   while (*t!=0); *s=0; return s; }
  6239                                  
  6240 000030B5 8B5E06                   mov bx, [bp+6]
  6241 000030B8 8A07                     mov al, [bx]
  6242 000030BA B400                     mov ah, 0
  6243 000030BC 83F800                   cmp ax, 0
  6244 000030BF 0F840200                 je  @@strcpy252
  6245 000030C3 EBDE                     jmp @@strcpy251
  6246                                  @@strcpy252:
  6247 000030C5 66B800000000             mov eax, 0
  6248 000030CB 8B5E04                   mov  bx, [bp+4]
  6249 000030CE 8807                     mov  [bx], al
  6250 000030D0 8B4604                   mov ax, [bp+4]
  6251 000030D3 E90000                   jmp @@retn
  6252                                  
  6253                                  ;-245 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  6254                                  
  6255 000030D6 C9                      @@retn: LEAVE
  6256 000030D7 C3                       ret
  6257                                  ; ENDP
  6258                                  ;Number of CALLs:    3 : digit
  6259                                  
  6260                                  digit:  ; *** PROC ***
  6261                                  ;Function : digit, Number of local variables: 1
  6262                                  ;   # type sign width line used address name   list of local variables
  6263                                  ;  200 var sign byte   245 NULL bp+4    c;
  6264 000030D8 C8000000                 ENTER  0,0
  6265 000030DC 8A4604                   mov al, [bp+4]
  6266 000030DF 3C30                     cmp al, 48
  6267 000030E1 0F8D0900                 jge @@digit253
  6268 000030E5 66B800000000             mov eax, 0
  6269 000030EB E91B00                   jmp @@retn
  6270                                  @@digit253:
  6271 000030EE 8A4604                   mov al, [bp+4]
  6272 000030F1 3C39                     cmp al, 57
  6273 000030F3 0F8E0900                 jle @@digit254
  6274 000030F7 66B800000000             mov eax, 0
  6275 000030FD E90900                   jmp @@retn
  6276                                  @@digit254:
  6277 00003100 66B801000000             mov eax, 1
  6278 00003106 E90000                   jmp @@retn
  6279                                  
  6280                                  ;-246 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  6281                                  
  6282 00003109 C9                      @@retn: LEAVE
  6283 0000310A C3                       ret
  6284                                  ; ENDP
  6285                                  ;Number of CALLs:   35 : eqstr
  6286                                  
  6287                                  eqstr:  ; *** PROC ***
  6288                                  ;Function : eqstr, Number of local variables: 2
  6289                                  ;   # type sign width line used address name   list of local variables
  6290                                  ;  200 ptr sign byte   246 NULL bp+4    p
  6291                                  ;  201 ptr sign byte   246 NULL bp+6    q;
  6292 0000310B C8000000                 ENTER  0,0
  6293                                  @@eqstr255:
  6294 0000310F 8B5E04                   mov bx, [bp+4]
  6295 00003112 8A07                     mov al, [bx]
  6296 00003114 B400                     mov ah, 0
  6297 00003116 08C0                     or  al, al
  6298 00003118 0F842300                 je @@eqstr256
  6299                                  
  6300                                  ;-247     if (*p != *q) return 0; p++; q++; }
  6301                                  
  6302 0000311C 8B5E04                   mov bx, [bp+4]
  6303 0000311F 8A07                     mov al, [bx]
  6304 00003121 B400                     mov ah, 0
  6305 00003123 8B5E06                   mov bx, [bp+6]
  6306 00003126 3A07                     cmp al, [bx]
  6307 00003128 B400                     mov ah, 0
  6308 0000312A 0F840900                 je  @@eqstr257
  6309 0000312E 66B800000000             mov eax, 0
  6310 00003134 E92700                   jmp @@retn
  6311                                  @@eqstr257:
  6312 00003137 FF4604                   inc  word [bp+4]
  6313 0000313A FF4606                   inc  word [bp+6]
  6314                                  
  6315                                  ;-248     if(*q) return 0; return 1; }
  6316                                  
  6317 0000313D EBD0                     jmp @@eqstr255
  6318                                  @@eqstr256:
  6319 0000313F 8B5E06                   mov bx, [bp+6]
  6320 00003142 8A07                     mov al, [bx]
  6321 00003144 B400                     mov ah, 0
  6322 00003146 08C0                     or  al, al
  6323 00003148 0F840900                 je @@eqstr258
  6324 0000314C 66B800000000             mov eax, 0
  6325 00003152 E90900                   jmp @@retn
  6326                                  @@eqstr258:
  6327 00003155 66B801000000             mov eax, 1
  6328 0000315B E90000                   jmp @@retn
  6329                                  
  6330                                  ;-249 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  6331                                  
  6332 0000315E C9                      @@retn: LEAVE
  6333 0000315F C3                       ret
  6334                                  ; ENDP
  6335                                  ;Number of CALLs:    3 : strcat1
  6336                                  
  6337                                  strcat1:  ; *** PROC ***
  6338                                  ;Function : strcat1, Number of local variables: 2
  6339                                  ;   # type sign width line used address name   list of local variables
  6340                                  ;  200 ptr sign byte   249 NULL bp+4    s
  6341                                  ;  201 ptr sign byte   249 NULL bp+6    t;
  6342 00003160 C8000000                 ENTER  0,0
  6343                                  @@strcat1259:
  6344 00003164 8B5E04                   mov bx, [bp+4]
  6345 00003167 8A07                     mov al, [bx]
  6346 00003169 B400                     mov ah, 0
  6347 0000316B 83F800                   cmp ax, 0
  6348 0000316E 0F840500                 je  @@strcat1260
  6349 00003172 FF4604                   inc  word [bp+4]
  6350 00003175 EBED                     jmp @@strcat1259
  6351                                  @@strcat1260:
  6352 00003177 FF7606                   push word [bp+6]
  6353 0000317A FF7604                   push word [bp+4]
  6354 0000317D E81FFF                   call strcpy
  6355 00003180 83C404                   add  sp, 4
  6356                                  
  6357                                  ;-250 int basename(char *s) { char *p; p=0;
  6358 00003183 C9                       LEAVE
  6359 00003184 C3                       ret
  6360                                  ; ENDP
  6361                                  ;Number of CALLs:    1 : openR
  6362                                  
  6363                                  openR:  ; *** PROC ***
  6364                                  ;Function : openR, Number of local variables: 1
  6365                                  ;   # type sign width line used address name   list of local variables
  6366                                  ;  200 ptr sign byte   250 NULL bp+4    s;
  6367 00003185 C8000000                 ENTER  0,0
  6368 00003189 8B5604                   mov  dx, [bp+4]
  6369 0000318C B8023D                   mov  ax, 15618
  6370 0000318F E87200                   call DosInt
  6371                                  
  6372                                  ;-251 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  6373 00003192 C9                       LEAVE
  6374 00003193 C3                       ret
  6375                                  ; ENDP
  6376                                  ;Number of CALLs:    2 : creatR
  6377                                  
  6378                                  creatR:  ; *** PROC ***
  6379                                  ;Function : creatR, Number of local variables: 1
  6380                                  ;   # type sign width line used address name   list of local variables
  6381                                  ;  200 ptr sign byte   251 NULL bp+4    s;
  6382 00003194 C8000000                 ENTER  0,0
  6383 00003198 8B5604                   mov  dx, [bp+4]
  6384 0000319B B90000                   mov  cx, 0
  6385 0000319E B8003C                   mov  ax, 15360
  6386 000031A1 E86000                   call DosInt
  6387                                  
  6388                                  ;-252 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  6389 000031A4 C9                       LEAVE
  6390 000031A5 C3                       ret
  6391                                  ; ENDP
  6392                                  ;Number of CALLs:    2 : readRL
  6393                                  
  6394                                  readRL:  ; *** PROC ***
  6395                                  ;Function : readRL, Number of local variables: 3
  6396                                  ;   # type sign width line used address name   list of local variables
  6397                                  ;  200 ptr sign byte   252 NULL bp+4    s
  6398                                  ;  201 var sign word   252 NULL bp+6    fd
  6399                                  ;  202 var sign word   252 NULL bp+8    len;
  6400 000031A6 C8000000                 ENTER  0,0
  6401 000031AA 8B5604                   mov  dx, [bp+4]
  6402 000031AD 8B4E08                   mov  cx, [bp+8]
  6403 000031B0 8B5E06                   mov  bx, [bp+6]
  6404 000031B3 B8003F                   mov  ax, 16128
  6405 000031B6 E84B00                   call DosInt
  6406                                  
  6407                                  ;-253 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  6408 000031B9 C9                       LEAVE
  6409 000031BA C3                       ret
  6410                                  ; ENDP
  6411                                  ;Number of CALLs:    2 : fputcR
  6412                                  
  6413                                  fputcR:  ; *** PROC ***
  6414                                  ;Function : fputcR, Number of local variables: 2
  6415                                  ;   # type sign width line used address name   list of local variables
  6416                                  ;  200 ptr sign byte   253 NULL bp+4    n
  6417                                  ;  201 var sign word   253 NULL bp+6    fd;
  6418 000031BB C8000000                 ENTER  0,0
  6419 000031BF 8D5604                  lea dx, [bp+4]
  6420                                  
  6421                                  ;-254   cx=1; bx=fd; ax=0x4000; DosInt(); }
  6422                                  
  6423 000031C2 B90100                   mov  cx, 1
  6424 000031C5 8B5E06                   mov  bx, [bp+6]
  6425 000031C8 B80040                   mov  ax, 16384
  6426 000031CB E83600                   call DosInt
  6427                                  
  6428                                  ;-255 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  6429 000031CE C9                       LEAVE
  6430 000031CF C3                       ret
  6431                                  ; ENDP
  6432                                  ;Number of CALLs:    3 : fcloseR
  6433                                  
  6434                                  fcloseR:  ; *** PROC ***
  6435                                  ;Function : fcloseR, Number of local variables: 1
  6436                                  ;   # type sign width line used address name   list of local variables
  6437                                  ;  200 var sign word   255 NULL bp+4    fd;
  6438 000031D0 C8000000                 ENTER  0,0
  6439 000031D4 8B5E04                   mov  bx, [bp+4]
  6440 000031D7 B8003E                   mov  ax, 15872
  6441 000031DA CD21                     int  33
  6442                                  
  6443                                  ;-256 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  6444 000031DC C9                       LEAVE
  6445 000031DD C3                       ret
  6446                                  ; ENDP
  6447                                  ;Number of CALLs:    5 : exitR
  6448                                  
  6449                                  exitR:  ; *** PROC ***
  6450                                  ;Function : exitR, Number of local variables: 1
  6451                                  ;   # type sign width line used address name   list of local variables
  6452                                  ;  200 var sign byte   256 NULL bp+4    c;
  6453 000031DE C8000000                 ENTER  0,0
  6454 000031E2 B44C                     mov  ah, 76
  6455 000031E4 8A4604                   mov  al, [bp+4]
  6456 000031E7 CD21                     int  33
  6457                                  
  6458                                  ;-257 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  6459 000031E9 C9                       LEAVE
  6460 000031EA C3                       ret
  6461                                  ; ENDP
  6462                                  ;End of archive file. 
  6463                                   
  6464                                  ; missing functions: 
  6465                                  ; putch
  6466                                  ; DosInt
  6467                                  ; DosInt
  6468                                  ; DosInt
  6469                                  ; DosInt
  6470                                  ; Number of unresolved CALLs :    5
  6471                                  ;use archive file: AR.C
  6472                                  
  6473                                  ;-258 // AR.C Archive
  6474                                  
  6475                                  ;Number of CALLs:    1 : putch
  6476                                  
  6477                                  putch:  ; *** PROC ***
  6478                                  ;Function : putch, Number of local variables: 1
  6479                                  ;   # type sign width line used address name   list of local variables
  6480                                  ;  200 var sign byte   258 NULL bp+4    c;
  6481 000031EB C8000000                 ENTER  0,0
  6482 000031EF 807E040A                cmp byte [bp+4], 10
  6483 000031F3 0F850500                 jne @@putch261
  6484 000031F7 B00D                     mov  al, 13
  6485 000031F9 E8FFFD                   call writetty
  6486                                  @@putch261:
  6487 000031FC 8A4604                   mov  al, [bp+4]
  6488 000031FF E8F9FD                   call writetty
  6489                                  
  6490                                  ;-259 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  6491 00003202 C9                       LEAVE
  6492 00003203 C3                       ret
  6493                                  ; ENDP
  6494                                  ;Number of CALLs:    4 : DosInt
  6495                                  
  6496                                  DosInt:  ; *** PROC ***
  6497 00003204 CD21                     int  33
  6498 00003206 7304                     jae short @@DosInt262
  6499 00003208 FF06[9F01]               inc  word [DOS_ERR]
  6500                                  @@DosInt262:
  6501                                  
  6502                                  ;-260 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  6503                                  
  6504 0000320C C3                       ret
  6505                                  ; ENDP
  6506                                  ;End of archive file. 
  6507                                   
  6508                                  ; missing functions:  All FUNCTIONs in place
  6509 0000320D E80000                  LastFunctionByt:db 0E8h, 0, 0
  6510 00003210 58                      pop ax
  6511 00003211 C3                      ret
  6512                                   
  6513                                  ;   # type sign width line used  address name   list of global variables
  6514                                  
  6515                                  ;    1 arr sign byte     1    2        0 Version1[10]
  6516                                  ;    2 var sign byte     1    3        0 LIST
  6517                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  6518                                  ;    4 arr sign byte     3    8        0 Symbol[31]
  6519                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  6520                                  ;    6 var unsg word     5   12        0 SymbolInt
  6521                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  6522                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  6523                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  6524                                  ;   10 arr sign byte     9    5        0 namein[67]
  6525                                  ;   11 arr sign byte    10    5        0 namelst[67]
  6526                                  ;   12 arr sign byte    11    5        0 namebin[67]
  6527                                  ;   13 var sign word    12    4        0 asm_fd
  6528                                  ;   14 var sign word    13    3        0 lst_fd
  6529                                  ;   15 var sign word    14    3        0 bin_fd
  6530                                  ;   16 var sign word    15    6        0 DOS_ERR
  6531                                  ;   17 var sign word    16    4        0 ErrorCount
  6532                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  6533                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  6534                                  ;   20 var unsg word    20    5        0 PC
  6535                                  ;   21 var unsg word    21    2        0 PCStart
  6536                                  ;   22 var sign byte    22    3        0 isLabel
  6537                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  6538                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  6539                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  6540                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  6541                                  ;   27 var sign byte    27   21        0 TokeType
  6542                                  ;   28 def unsg byte    28    -        0 BYTE=1
  6543                                  ;   29 def unsg byte    29    -        0 WORD=2
  6544                                  ;   30 def unsg byte    30    -        0 DWORD=3
  6545                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  6546                                  ;   32 def unsg byte    32    -        0 IMM=1
  6547                                  ;   33 def unsg byte    33    -        0 REG=2
  6548                                  ;   34 def unsg byte    34    -        0 ADR=3
  6549                                  ;   35 def unsg byte    35    -        0 MEM=4
  6550                                  ;   36 var sign byte    36   14        0 Op
  6551                                  ;   37 var sign byte    37   18        0 Op2
  6552                                  ;   38 var sign byte    38   13        0 CodeType
  6553                                  ;   39 var sign byte    39    9        0 Code1
  6554                                  ;   40 var sign byte    40    6        0 Code2
  6555                                  ;   41 var sign byte    41    3        0 Code3
  6556                                  ;   42 var sign byte    42   13        0 RegNo
  6557                                  ;   43 var sign byte    43    6        0 R1No
  6558                                  ;   44 var sign byte    44   14        0 RegType
  6559                                  ;   45 var sign byte    45    8        0 R1Type
  6560                                  ;   46 var sign byte    46   13        0 OpSize
  6561                                  ;   47 var sign byte    47    5        0 wflag
  6562                                  ;   48 var sign byte    49    6        0 sflag
  6563                                  ;   49 var sign byte    50   14        0 regindexbase
  6564                                  ;   50 var sign byte    51    3        0 isDirect
  6565                                  ;   51 var sign word    52   14        0 disp
  6566                                  ;   52 var unsg word    53    7        0 imme
  6567                                  ;   53 def unsg byte    55    -        0 OPMAXLEN=5
  6568                                  ;   54 arr sign byte    56    2        0 OpPos[5]
  6569                                  ;   55 var sign word    57    6        0 OpPrintIndex
  6570                                  ;   56 ptr sign byte    58   17        0 OpCodePtr
  6571                                  ;   57 var sign byte    59    2        0 PrintR
  6572                                  ;   58 def unsg byte    61    -        0 LABELNAMESMAX=969
  6573                                  ;   59 arr sign byte    62    3        0 LabelNames[1000]
  6574                                  ;   60 ptr sign byte    63    5        0 LabelNamePtr
  6575                                  ;   61 def unsg byte    64    -        0 LABELADRMAX=100
  6576                                  ;   62 arr unsg word    65    3        0 LabelAddr[100]
  6577                                  ;   63 var sign word    66    4        0 LabelMaxIx
  6578                                  ;   64 var sign word    67    4        0 LabelIx
  6579                                  ;   65 def unsg byte    69    -        0 FILEBINMAX=2000
  6580                                  ;   66 arr sign byte    70    2        0 FileBin[2000]
  6581                                  ;   67 var unsg word    71    5        0 BinLen
  6582                                  ;   68 ptr sign byte    73    1        0 arglen
  6583                                  ;   69 ptr sign byte    74    4        0 argv
  6584                                  ;   70 var sign byte     1    1        0 I_START
  6585                                  ;   71 arr sign byte     4 NULL        0 I_PUSHA[9]
  6586                                  ;   72 arr sign byte     5 NULL        0 I_POPA[8]
  6587                                  ;   73 arr sign byte     6 NULL        0 I_NOP[7]
  6588                                  ;   74 arr sign byte     7 NULL        0 I_CBW[7]
  6589                                  ;   75 arr sign byte     8 NULL        0 I_CWDE[8]
  6590                                  ;   76 arr sign byte     9 NULL        0 I_CWD[7]
  6591                                  ;   77 arr sign byte    10 NULL        0 I_CDQ[7]
  6592                                  ;   78 arr sign byte    11 NULL        0 I_WAIT[8]
  6593                                  ;   79 arr sign byte    12 NULL        0 I_PUSHF[9]
  6594                                  ;   80 arr sign byte    13 NULL        0 I_POPF[8]
  6595                                  ;   81 arr sign byte    14 NULL        0 I_SAHF[8]
  6596                                  ;   82 arr sign byte    15 NULL        0 I_LAHF[8]
  6597                                  ;   83 arr sign byte    16 NULL        0 I_MOVSB[9]
  6598                                  ;   84 arr sign byte    17 NULL        0 I_MOVSW[9]
  6599                                  ;   85 arr sign byte    18 NULL        0 I_CMPSB[9]
  6600                                  ;   86 arr sign byte    19 NULL        0 I_CMPSW[9]
  6601                                  ;   87 arr sign byte    20 NULL        0 I_STOSB[9]
  6602                                  ;   88 arr sign byte    21 NULL        0 I_STOSW[9]
  6603                                  ;   89 arr sign byte    22 NULL        0 I_LODSB[9]
  6604                                  ;   90 arr sign byte    23 NULL        0 I_LODSW[9]
  6605                                  ;   91 arr sign byte    24 NULL        0 I_SCASB[9]
  6606                                  ;   92 arr sign byte    25 NULL        0 I_SCASW[9]
  6607                                  ;   93 arr sign byte    26 NULL        0 I_LEAVE[9]
  6608                                  ;   94 arr sign byte    27 NULL        0 I_IRET[8]
  6609                                  ;   95 arr sign byte    28 NULL        0 I_XLAT[8]
  6610                                  ;   96 arr sign byte    29 NULL        0 I_LOCK[8]
  6611                                  ;   97 arr sign byte    30 NULL        0 I_REPNE[9]
  6612                                  ;   98 arr sign byte    31 NULL        0 I_REPNZ[9]
  6613                                  ;   99 arr sign byte    32 NULL        0 I_REPE[8]
  6614                                  ;  100 arr sign byte    33 NULL        0 I_REPZ[8]
  6615                                  ;  101 arr sign byte    34 NULL        0 I_HLT[7]
  6616                                  ;  102 arr sign byte    35 NULL        0 I_CLC[7]
  6617                                  ;  103 arr sign byte    36 NULL        0 I_STC[7]
  6618                                  ;  104 arr sign byte    37 NULL        0 I_CLI[7]
  6619                                  ;  105 arr sign byte    38 NULL        0 I_STI[7]
  6620                                  ;  106 arr sign byte    39 NULL        0 I_CLD[7]
  6621                                  ;  107 arr sign byte    40 NULL        0 I_STD[7]
  6622                                  ;  108 arr sign byte    42 NULL        0 I_INC[9]
  6623                                  ;  109 arr sign byte    43 NULL        0 I_DEC[9]
  6624                                  ;  110 arr sign byte    44 NULL        0 I_NOT[8]
  6625                                  ;  111 arr sign byte    45 NULL        0 I_NEG[8]
  6626                                  ;  112 arr sign byte    46 NULL        0 I_MUL[8]
  6627                                  ;  113 arr sign byte    47 NULL        0 I_IMUL[9]
  6628                                  ;  114 arr sign byte    48 NULL        0 I_DIV[8]
  6629                                  ;  115 arr sign byte    49 NULL        0 I_IDIV[9]
  6630                                  ;  116 arr sign byte    51 NULL        0 I_LES[7]
  6631                                  ;  117 arr sign byte    52 NULL        0 I_LDS[7]
  6632                                  ;  118 arr sign byte    53 NULL        0 I_LEA[7]
  6633                                  ;  119 arr sign byte    54 NULL        0 I_LSS[8]
  6634                                  ;  120 arr sign byte    55 NULL        0 I_LFS[8]
  6635                                  ;  121 arr sign byte    56 NULL        0 I_LGS[8]
  6636                                  ;  122 arr sign byte    58 NULL        0 I_ADD[7]
  6637                                  ;  123 arr sign byte    59 NULL        0 I_OR[6]
  6638                                  ;  124 arr sign byte    60 NULL        0 I_ADC[7]
  6639                                  ;  125 arr sign byte    61 NULL        0 I_SBB[7]
  6640                                  ;  126 arr sign byte    62 NULL        0 I_AND[7]
  6641                                  ;  127 arr sign byte    63 NULL        0 I_SUB[7]
  6642                                  ;  128 arr sign byte    64 NULL        0 I_XOR[7]
  6643                                  ;  129 arr sign byte    65 NULL        0 I_CMP[7]
  6644                                  ;  130 arr sign byte    66 NULL        0 I_TEST[11]
  6645                                  ;  131 arr sign byte    68 NULL        0 I_MOV[6]
  6646                                  ;  132 arr sign byte    69 NULL        0 I_MOVSX[9]
  6647                                  ;  133 arr sign byte    70 NULL        0 I_MOVZX[9]
  6648                                  ;  134 arr sign byte    72 NULL        0 I_JO[6]
  6649                                  ;  135 arr sign byte    73 NULL        0 I_JNO[7]
  6650                                  ;  136 arr sign byte    74 NULL        0 I_JB[6]
  6651                                  ;  137 arr sign byte    75 NULL        0 I_JC[6]
  6652                                  ;  138 arr sign byte    76 NULL        0 I_JNB[7]
  6653                                  ;  139 arr sign byte    77 NULL        0 I_JAE[7]
  6654                                  ;  140 arr sign byte    78 NULL        0 I_JNC[7]
  6655                                  ;  141 arr sign byte    79 NULL        0 I_JE[6]
  6656                                  ;  142 arr sign byte    80 NULL        0 I_JZ[6]
  6657                                  ;  143 arr sign byte    81 NULL        0 I_JNE[7]
  6658                                  ;  144 arr sign byte    82 NULL        0 I_JNZ[7]
  6659                                  ;  145 arr sign byte    83 NULL        0 I_JBE[7]
  6660                                  ;  146 arr sign byte    84 NULL        0 I_JNA[7]
  6661                                  ;  147 arr sign byte    85 NULL        0 I_JA[6]
  6662                                  ;  148 arr sign byte    86 NULL        0 I_JS[6]
  6663                                  ;  149 arr sign byte    87 NULL        0 I_JNS[7]
  6664                                  ;  150 arr sign byte    88 NULL        0 I_JP[6]
  6665                                  ;  151 arr sign byte    89 NULL        0 I_JPE[7]
  6666                                  ;  152 arr sign byte    90 NULL        0 I_JNP[7]
  6667                                  ;  153 arr sign byte    91 NULL        0 I_JPO[7]
  6668                                  ;  154 arr sign byte    92 NULL        0 I_JL[6]
  6669                                  ;  155 arr sign byte    93 NULL        0 I_JNL[7]
  6670                                  ;  156 arr sign byte    94 NULL        0 I_JGE[7]
  6671                                  ;  157 arr sign byte    95 NULL        0 I_JLE[7]
  6672                                  ;  158 arr sign byte    96 NULL        0 I_JNG[7]
  6673                                  ;  159 arr sign byte    97 NULL        0 I_JG[6]
  6674                                  ;  160 arr sign byte    99 NULL        0 I_JMP[8]
  6675                                  ;  161 arr sign byte   100 NULL        0 I_CALL[9]
  6676                                  ;  162 arr sign byte   102 NULL        0 I_RET[8]
  6677                                  ;  163 arr sign byte   103 NULL        0 I_RETF[9]
  6678                                  ;  164 arr sign byte   105 NULL        0 I_PUSH[8]
  6679                                  ;  165 arr sign byte   106 NULL        0 I_POP[7]
  6680                                  ;  166 arr sign byte   108 NULL        0 I_ROL[7]
  6681                                  ;  167 arr sign byte   109 NULL        0 I_ROR[7]
  6682                                  ;  168 arr sign byte   110 NULL        0 I_RCL[7]
  6683                                  ;  169 arr sign byte   111 NULL        0 I_RCR[7]
  6684                                  ;  170 arr sign byte   112 NULL        0 I_SHL[7]
  6685                                  ;  171 arr sign byte   113 NULL        0 I_SAL[7]
  6686                                  ;  172 arr sign byte   114 NULL        0 I_SHR[7]
  6687                                  ;  173 arr sign byte   115 NULL        0 I_SAR[7]
  6688                                  ;  174 arr sign byte   117 NULL        0 I_INT[8]
  6689                                  ;  175 arr sign byte   118 NULL        0 I_INTO[8]
  6690                                  ;  176 arr sign byte   129 NULL        0 I_XCHG[9]
  6691                                  ;  177 arr sign byte   131 NULL        0 I_LOOPNZ[10]
  6692                                  ;  178 arr sign byte   132 NULL        0 I_LOOPNE[10]
  6693                                  ;  179 arr sign byte   133 NULL        0 I_LOOPZ[9]
  6694                                  ;  180 arr sign byte   134 NULL        0 I_LOOPE[9]
  6695                                  ;  181 arr sign byte   135 NULL        0 I_LOOP[8]
  6696                                  ;  182 arr sign byte   136 NULL        0 I_JCXZ[8]
  6697                                  ;  183 arr sign byte   137 NULL        0 I_JECXZ[9]
  6698                                  ;  184 arr sign byte   139 NULL        0 I_ENTER[9]
  6699                                  ;  185 arr sign byte   141 NULL        0 I_ORG[6]
  6700                                  ;  186 arr sign byte   146 NULL        0 I_DB[5]
  6701                                  ;  187 arr sign byte   147 NULL        0 I_DW[5]
  6702                                  ;  188 arr sign byte   148 NULL        0 I_DD[5]
  6703                                  ;  189 arr sign byte   149 NULL        0 I_RESB[7]
  6704                                  ;  190 arr sign byte   150 NULL        0 I_RESW[7]
  6705                                  ;  191 arr sign byte   151 NULL        0 I_RESD[7]
  6706                                  ;  192 var sign byte   152 NULL        0 I_END
  6707                                  
  6708                                  
  6709                                  ;   # Calls Line Width  Name   list of functions
  6710                                  
  6711                                  ;    0    1    1 word   parse
  6712                                  ;    1   14   27 word   getTokeType
  6713                                  ;    2    2   36 word   storeLabel
  6714                                  ;    3    2   46 word   searchLabel
  6715                                  ;    4    1   57 word   getVariable
  6716                                  ;    5    2   86 word   lookCode
  6717                                  ;    6    1  101 word   getCodeSize
  6718                                  ;    7    8  108 word   isToken
  6719                                  ;    8    2  113 word   need
  6720                                  ;    9    1  123 word   skipRest
  6721                                  ;   10    1    1 word   getLine
  6722                                  ;   11    1   17 word   ifEOL
  6723                                  ;   12    3   24 word   skipBlank
  6724                                  ;   13    2   29 word   letterE
  6725                                  ;   14    1   39 word   alnumE
  6726                                  ;   15    1   44 word   getDigit
  6727                                  ;   16    1   56 word   getName
  6728                                  ;   17    1   75 word   testReg
  6729                                  ;   18    1    1 word   printLine
  6730                                  ;   19    7   22 word   prc
  6731                                  ;   20    1   34 word   prscomment
  6732                                  ;   21   21   42 word   prs
  6733                                  ;   22    3   64 word   printhex8a
  6734                                  ;   23    2   69 word   printhex4
  6735                                  ;   24    1   74 word   printhex16
  6736                                  ;   25    3   79 word   printIntU
  6737                                  ;   26   25   90 word   error1
  6738                                  ;   27   12   98 word   errorexit
  6739                                  ;   28 NULL  102 word   allowederror
  6740                                  ;   29    2  103 word   addrerror
  6741                                  ;   30    1  104 word   immeerror
  6742                                  ;   31    2  105 word   implerror
  6743                                  ;   32    4  106 word   indexerror
  6744                                  ;   33    3  107 word   invaloperror
  6745                                  ;   34    1  108 word   numbererror
  6746                                  ;   35 NULL  109 word   regmemerror
  6747                                  ;   36    1  110 word   reg16error
  6748                                  ;   37    1  111 word   segregerror
  6749                                  ;   38    2  112 word   syntaxerror
  6750                                  ;   39 NULL  114 word   addrexit
  6751                                  ;   40 NULL  115 word   internexit
  6752                                  ;   41 NULL    1 word   main
  6753                                  ;   42    1    8 word   getarg
  6754                                  ;   43    1   38 word   epilog
  6755                                  ;   44    2   67 word   end1
  6756                                  ;   45    1    2 word   getCodes
  6757                                  ;   46    1    7 word   gen66h
  6758                                  ;   47    2    9 word   genCode
  6759                                  ;   48    5   13 word   genCodeW
  6760                                  ;   49   16   17 word   genCode8
  6761                                  ;   50    4   28 word   genCode16
  6762                                  ;   51    5   32 word   writeEA
  6763                                  ;   52    2   86 word   genImmediate
  6764                                  ;   53    1   11 word   process
  6765                                  ;   54    1  117 word   checkOpL
  6766                                  ;   55    1  137 word   get2Ops
  6767                                  ;   56    3  142 word   getOpL
  6768                                  ;   57    3  151 word   getOpR
  6769                                  ;   58    2  161 word   getOp1
  6770                                  ;   59    1  177 word   getMEM
  6771                                  ;   60    1  199 word   getIndReg1
  6772                                  ;   61    1  207 word   getIndReg2
  6773                                  ;   62    2  218 word   setwflag
  6774                                  ;   63    1  230 word   setsflag
  6775                                  ;   64    4  238 word   writetty
  6776                                  ;   65    8  239 word   cputs
  6777                                  ;   66    2  240 word   toupper
  6778                                  ;   67    3  242 word   strlen
  6779                                  ;   68    6  243 word   strcpy
  6780                                  ;   69    3  245 word   digit
  6781                                  ;   70   35  246 word   eqstr
  6782                                  ;   71    3  249 word   strcat1
  6783                                  ;   72    1  250 word   openR
  6784                                  ;   73    2  251 word   creatR
  6785                                  ;   74    2  252 word   readRL
  6786                                  ;   75    2  253 word   fputcR
  6787                                  ;   76    3  255 word   fcloseR
  6788                                  ;   77    5  256 word   exitR
  6789                                  ;   78    1  258 word   putch
  6790                                  ;   79    4  259 word   DosInt
  6791                                  ;   80 NULL  260 word   LastFunctionByt
  6792                                  
  6793                                  ;    #  addr name   list of CALLs
  6794                                  
  6795                                  ;    0  1345 getLine
  6796                                  ;    1  1353 getTokeType
  6797                                  ;    2  1365 storeLabel
  6798                                  ;    3  1376 getTokeType
  6799                                  ;    4  1388 lookCode
  6800                                  ;    5  1397 process
  6801                                  ;    6  1405 getVariable
  6802                                  ;    7  1417 skipRest
  6803                                  ;    8  1426 error1
  6804                                  ;    9  1433 error1
  6805                                  ;   10  1440 printLine
  6806                                  ;   11  1464 skipBlank
  6807                                  ;   12  1474 digit
  6808                                  ;   13  1480 getDigit
  6809                                  ;   14  1489 letterE
  6810                                  ;   15  1497 getName
  6811                                  ;   16  1518 searchLabel
  6812                                  ;   17  1530 error1
  6813                                  ;   18  1537 strcpy
  6814                                  ;   19  1544 errorexit
  6815                                  ;   20  1554 errorexit
  6816                                  ;   21  1584 eqstr
  6817                                  ;   22  1590 strlen
  6818                                  ;   23  1611 storeLabel
  6819                                  ;   24  1622 getTokeType
  6820                                  ;   25  1634 lookCode
  6821                                  ;   26  1643 errorexit
  6822                                  ;   27  1653 errorexit
  6823                                  ;   28  1663 getTokeType
  6824                                  ;   29  1675 genCode8
  6825                                  ;   30  1684 skipBlank
  6826                                  ;   31  1694 isToken
  6827                                  ;   32  1702 genCode8
  6828                                  ;   33  1711 isToken
  6829                                  ;   34  1719 getTokeType
  6830                                  ;   35  1731 genCode16
  6831                                  ;   36  1741 isToken
  6832                                  ;   37  1749 errorexit
  6833                                  ;   38  1768 eqstr
  6834                                  ;   39  1786 eqstr
  6835                                  ;   40  1792 getTokeType
  6836                                  ;   41  1804 eqstr
  6837                                  ;   42  1810 getTokeType
  6838                                  ;   43  1822 eqstr
  6839                                  ;   44  1828 getTokeType
  6840                                  ;   45  1850 skipBlank
  6841                                  ;   46  1867 isToken
  6842                                  ;   47  1875 getTokeType
  6843                                  ;   48  1887 error1
  6844                                  ;   49  1894 prs
  6845                                  ;   50  1898 prc
  6846                                  ;   51  1911 getTokeType
  6847                                  ;   52  1923 error1
  6848                                  ;   53  1940 readRL
  6849                                  ;   54  1947 errorexit
  6850                                  ;   55  1957 errorexit
  6851                                  ;   56  1967 ifEOL
  6852                                  ;   57  1981 readRL
  6853                                  ;   58  2017 digit
  6854                                  ;   59  2023 letterE
  6855                                  ;   60  2050 digit
  6856                                  ;   61  2070 alnumE
  6857                                  ;   62  2077 errorexit
  6858                                  ;   63  2087 strcpy
  6859                                  ;   64  2094 toupper
  6860                                  ;   65  2110 strlen
  6861                                  ;   66  2117 strlen
  6862                                  ;   67  2124 eqstr
  6863                                  ;   68  2130 eqstr
  6864                                  ;   69  2136 eqstr
  6865                                  ;   70  2142 eqstr
  6866                                  ;   71  2148 eqstr
  6867                                  ;   72  2154 eqstr
  6868                                  ;   73  2160 eqstr
  6869                                  ;   74  2166 eqstr
  6870                                  ;   75  2172 eqstr
  6871                                  ;   76  2178 eqstr
  6872                                  ;   77  2184 eqstr
  6873                                  ;   78  2190 eqstr
  6874                                  ;   79  2196 eqstr
  6875                                  ;   80  2202 eqstr
  6876                                  ;   81  2208 eqstr
  6877                                  ;   82  2214 eqstr
  6878                                  ;   83  2220 eqstr
  6879                                  ;   84  2226 eqstr
  6880                                  ;   85  2232 eqstr
  6881                                  ;   86  2238 eqstr
  6882                                  ;   87  2244 eqstr
  6883                                  ;   88  2250 eqstr
  6884                                  ;   89  2256 eqstr
  6885                                  ;   90  2262 eqstr
  6886                                  ;   91  2268 eqstr
  6887                                  ;   92  2274 eqstr
  6888                                  ;   93  2280 eqstr
  6889                                  ;   94  2286 eqstr
  6890                                  ;   95  2292 eqstr
  6891                                  ;   96  2298 eqstr
  6892                                  ;   97  2318 prs
  6893                                  ;   98  2322 printhex16
  6894                                  ;   99  2333 prs
  6895                                  ;  100  2337 prc
  6896                                  ;  101  2341 printhex8a
  6897                                  ;  102  2352 prc
  6898                                  ;  103  2356 prs
  6899                                  ;  104  2360 prscomment
  6900                                  ;  105  2377 writetty
  6901                                  ;  106  2386 writetty
  6902                                  ;  107  2395 fputcR
  6903                                  ;  108  2417 prc
  6904                                  ;  109  2433 prc
  6905                                  ;  110  2454 printhex4
  6906                                  ;  111  2464 printhex4
  6907                                  ;  112  2486 prc
  6908                                  ;  113  2508 printhex8a
  6909                                  ;  114  2519 printhex8a
  6910                                  ;  115  2544 printIntU
  6911                                  ;  116  2554 prc
  6912                                  ;  117  2567 prs
  6913                                  ;  118  2571 prs
  6914                                  ;  119  2575 prs
  6915                                  ;  120  2579 prs
  6916                                  ;  121  2595 error1
  6917                                  ;  122  2602 end1
  6918                                  ;  123  2620 error1
  6919                                  ;  124  2637 error1
  6920                                  ;  125  2654 error1
  6921                                  ;  126  2671 error1
  6922                                  ;  127  2689 error1
  6923                                  ;  128  2709 error1
  6924                                  ;  129  2728 error1
  6925                                  ;  130  2747 error1
  6926                                  ;  131  2765 error1
  6927                                  ;  132  2784 error1
  6928                                  ;  133  2803 error1
  6929                                  ;  134  2819 errorexit
  6930                                  ;  135  2840 errorexit
  6931                                  ;  136  2855 getarg
  6932                                  ;  137  2862 parse
  6933                                  ;  138  2868 epilog
  6934                                  ;  139  2875 end1
  6935                                  ;  140  2899 cputs
  6936                                  ;  141  2905 cputs
  6937                                  ;  142  2911 exitR
  6938                                  ;  143  2917 toupper
  6939                                  ;  144  2925 strcpy
  6940                                  ;  145  2932 strcat1
  6941                                  ;  146  2940 strcpy
  6942                                  ;  147  2947 strcat1
  6943                                  ;  148  2955 strcpy
  6944                                  ;  149  2962 strcat1
  6945                                  ;  150  2970 openR
  6946                                  ;  151  2976 cputs
  6947                                  ;  152  2982 cputs
  6948                                  ;  153  2988 exitR
  6949                                  ;  154  2994 creatR
  6950                                  ;  155  3001 cputs
  6951                                  ;  156  3007 cputs
  6952                                  ;  157  3013 exitR
  6953                                  ;  158  3019 creatR
  6954                                  ;  159  3026 cputs
  6955                                  ;  160  3032 cputs
  6956                                  ;  161  3038 exitR
  6957                                  ;  162  3044 prs
  6958                                  ;  163  3048 prs
  6959                                  ;  164  3052 prs
  6960                                  ;  165  3056 prs
  6961                                  ;  166  3060 prs
  6962                                  ;  167  3064 prs
  6963                                  ;  168  3068 prs
  6964                                  ;  169  3072 prs
  6965                                  ;  170  3076 prs
  6966                                  ;  171  3093 prs
  6967                                  ;  172  3097 printIntU
  6968                                  ;  173  3107 prs
  6969                                  ;  174  3111 prs
  6970                                  ;  175  3115 printIntU
  6971                                  ;  176  3125 prs
  6972                                  ;  177  3129 fputcR
  6973                                  ;  178  3143 fcloseR
  6974                                  ;  179  3151 fcloseR
  6975                                  ;  180  3159 fcloseR
  6976                                  ;  181  3167 exitR
  6977                                  ;  182  3189 genCode8
  6978                                  ;  183  3210 genCode8
  6979                                  ;  184  3230 genCode8
  6980                                  ;  185  3250 errorexit
  6981                                  ;  186  3272 genCode8
  6982                                  ;  187  3281 genCode8
  6983                                  ;  188  3306 addrerror
  6984                                  ;  189  3316 immeerror
  6985                                  ;  190  3326 invaloperror
  6986                                  ;  191  3339 invaloperror
  6987                                  ;  192  3352 genCode8
  6988                                  ;  193  3361 genCode8
  6989                                  ;  194  3370 genCode16
  6990                                  ;  195  3393 genCode8
  6991                                  ;  196  3402 genCode16
  6992                                  ;  197  3412 genCode8
  6993                                  ;  198  3431 getTokeType
  6994                                  ;  199  3443 getCodeSize
  6995                                  ;  200  3455 getCodes
  6996                                  ;  201  3464 genCode8
  6997                                  ;  202  3473 getOpL
  6998                                  ;  203  3480 checkOpL
  6999                                  ;  204  3489 genCode
  7000                                  ;  205  3497 genCode
  7001                                  ;  206  3505 getTokeType
  7002                                  ;  207  3517 implerror
  7003                                  ;  208  3527 genCodeW
  7004                                  ;  209  3536 writeEA
  7005                                  ;  210  3544 getOpL
  7006                                  ;  211  3551 reg16error
  7007                                  ;  212  3562 need
  7008                                  ;  213  3567 getOpR
  7009                                  ;  214  3574 addrerror
  7010                                  ;  215  3584 genCode8
  7011                                  ;  216  3593 genCode8
  7012                                  ;  217  3602 writeEA
  7013                                  ;  218  3610 get2Ops
  7014                                  ;  219  3618 setwflag
  7015                                  ;  220  3627 setsflag
  7016                                  ;  221  3636 genCodeW
  7017                                  ;  222  3645 genImmediate
  7018                                  ;  223  3658 genCodeW
  7019                                  ;  224  3667 writeEA
  7020                                  ;  225  3675 genImmediate
  7021                                  ;  226  3688 genCodeW
  7022                                  ;  227  3697 writeEA
  7023                                  ;  228  3705 genCodeW
  7024                                  ;  229  3714 writeEA
  7025                                  ;  230  3722 syntaxerror
  7026                                  ;  231  3734 genCode8
  7027                                  ;  232  3743 genCode16
  7028                                  ;  233  3753 genCode8
  7029                                  ;  234  3762 error1
  7030                                  ;  235  3769 error1
  7031                                  ;  236  3785 implerror
  7032                                  ;  237  3795 segregerror
  7033                                  ;  238  3807 setwflag
  7034                                  ;  239  3816 error1
  7035                                  ;  240  3823 error1
  7036                                  ;  241  3830 error1
  7037                                  ;  242  3845 getOpL
  7038                                  ;  243  3852 need
  7039                                  ;  244  3857 getOpR
  7040                                  ;  245  3871 getOpR
  7041                                  ;  246  3885 getOp1
  7042                                  ;  247  3892 isToken
  7043                                  ;  248  3900 getMEM
  7044                                  ;  249  3907 invaloperror
  7045                                  ;  250  3920 error1
  7046                                  ;  251  3934 testReg
  7047                                  ;  252  3942 searchLabel
  7048                                  ;  253  3954 error1
  7049                                  ;  254  3970 getTokeType
  7050                                  ;  255  3982 getOp1
  7051                                  ;  256  3989 syntaxerror
  7052                                  ;  257  4001 getIndReg2
  7053                                  ;  258  4012 getIndReg1
  7054                                  ;  259  4023 isToken
  7055                                  ;  260  4031 getTokeType
  7056                                  ;  261  4043 numbererror
  7057                                  ;  262  4055 isToken
  7058                                  ;  263  4063 isToken
  7059                                  ;  264  4071 errorexit
  7060                                  ;  265  4092 indexerror
  7061                                  ;  266  4103 indexerror
  7062                                  ;  267  4127 indexerror
  7063                                  ;  268  4138 indexerror
  7064                                  ;  269  4158 gen66h
  7065                                  ;  270  4174 error1
  7066                                  ;  271  4200 putch
  7067                                  ;  272  4268 strcpy
  7068                                  ;  273  4283 DosInt
  7069                                  ;  274  4299 DosInt
  7070                                  ;  275  4322 DosInt
  7071                                  ;  276  4341 DosInt
  7072                                  ;  277  4375 writetty
  7073                                  ;  278  4384 writetty
  7074                                  ;Input: AS.C, List: AS.S,  Lines:  261
  7075                                  ;Glob. variables:  192 max.:  200
  7076                                  ;Local variables:    3 max.:  100, in 'searchLabel'
  7077                                  ;Functions      :   81 max.:  300
  7078                                  ;Calls          :  279 max.: 2000, NameField: 4416 max.:    65535
  7079                                  ;Code until     :25998 max.: 30000, free: 4002
  7080                                  ;Data (HeapEnd) :33595, resting stacksize: 31940
  7081                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
