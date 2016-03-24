     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E9CF34                  jmp main
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
    16                                  ;-1 char LIST;              //listing on/off     
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
    70                                  ;-15 int DOS_ERR=0;          //global var
    71                                  
    72 0000019F 0000                    DOS_ERR dw 0
    73                                  
    74                                  ;-16 int ErrorCount=0;       //number of errors
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
    89                                  ;-20 unsigned int PC=0;      //program counter
    90                                  
    91 000001A6 0000                    PC dw 0
    92                                  
    93                                  ;-21 unsigned int Origin=0;  //ORG nn
    94                                  
    95 000001A8 0000                    Origin dw 0
    96                                  
    97                                  ;-22 unsigned int PCStart;   //PC at start of line by PrintLine()
    98                                  
    99 000001AA 0000                    PCStart dw 0
   100                                  
   101                                  ;-23 char isLabel;           //by getName()
   102                                  
   103 000001AC 00                      isLabel db 0
   104                                  
   105                                  ;-24 #define DIGIT    1      //0-9
   106                                  
   107                                  
   108                                  ;-25 #define LETTERE  2      //a-z A-Z @ . _
   109                                  
   110                                  
   111                                  ;-26 #define ALNUME   3      //a-z A-Z @ . _  0-9
   112                                  
   113                                  
   114                                  ;-27 #define NOALNUME 4      //other char
   115                                  
   116                                  
   117                                  ;-28 char TokeType;          //0, DIGIT, LETTERE, ALNUME, NOALNUME
   118                                  
   119 000001AD 00                      TokeType db 0
   120                                  
   121                                  ;-29 #define BYTE     1
   122                                  
   123                                  
   124                                  ;-30 #define WORD     2
   125                                  
   126                                  
   127                                  ;-31 #define DWORD    3
   128                                  
   129                                  
   130                                  ;-32 #define SEGREG   4
   131                                  
   132                                  
   133                                  ;-33 #define IMM      1      //const  ,123
   134                                  
   135                                  
   136                                  ;-34 #define REG      2      //       ,BX    mode=11
   137                                  
   138                                  
   139                                  ;-35 #define ADR      3      //DIRECT: VALUE  ,var1  mod=00, r/m=110
   140                                  
   141                                  
   142                                  ;-36 #define MEM      4      //[var1],[BX+SI],[table+BX],[bp-4] disp0,8,16
   143                                  
   144                                  
   145                                  ;-37 char Op;                //1. operand: 0, IMM, REG, ADR, MEM  
   146                                  
   147 000001AE 00                      Op db 0
   148                                  
   149                                  ;-38 char Op2;               //2. operand
   150                                  
   151 000001AF 00                      Op2 db 0
   152                                  
   153                                  ;-39 char CodeType;          //1-207 by searchSymbol(), must be byte size
   154                                  
   155 000001B0 00                      CodeType db 0
   156                                  
   157                                  ;-40 char Code1;             //1. Opcode
   158                                  
   159 000001B1 00                      Code1 db 0
   160                                  
   161                                  ;-41 char Code2;             //2. Opcode
   162                                  
   163 000001B2 00                      Code2 db 0
   164                                  
   165                                  ;-42 char Code3;             //3. Opcode
   166                                  
   167 000001B3 00                      Code3 db 0
   168                                  
   169                                  ;-43 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  
   170                                  
   171 000001B4 00                      R2No db 0
   172                                  
   173                                  ;-44 char R1No;              //temp for 1. register
   174                                  
   175 000001B5 00                      R1No db 0
   176                                  
   177                                  ;-45 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   178                                  
   179 000001B6 00                      R2Type db 0
   180                                  
   181                                  ;-46 char R1Type;            //temp for 1. register 
   182                                  
   183 000001B7 00                      R1Type db 0
   184                                  
   185                                  ;-47 char OpSize;            //0, BYTE, WORD, DWORD by getCodeSize()
   186                                  
   187 000001B8 00                      OpSize db 0
   188                                  
   189                                  ;-48 char wflag;             //wordflag: 0=byte, 1=word/dword
   190                                  
   191 000001B9 00                      wflag db 0
   192                                  
   193                                  ;-49 char dflag;             //directionflag: 1=to reg MOV,ALU    
   194                                  
   195 000001BA 00                      dflag db 0
   196                                  
   197                                  ;-50 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   198                                  
   199 000001BB 00                      sflag db 0
   200                                  
   201                                  ;-51 char rm;                //combination of index and base reg
   202                                  
   203 000001BC 00                      rm db 0
   204                                  
   205                                  ;-52 char isDirect;          //set in process and getMeM, need in WriteEA
   206                                  
   207 000001BD 00                      isDirect db 0
   208                                  
   209                                  ;-53 int disp;               //displacement      0-8 bytes
   210                                  
   211 000001BE 0000                    disp dw 0
   212                                  
   213                                  ;-54 unsigned int imme;      //immediate         0-8 bytes
   214                                  
   215 000001C0 0000                    imme dw 0
   216                                  
   217                                  ;-55 
   218                                  
   219                                  
   220                                  ;-56 #define OPMAXLEN 5
   221                                  
   222                                  
   223                                  ;-57 char OpPos[OPMAXLEN];   //array for one opcode to list
   224                                  
   225 000001C2 <res 00000005>          OpPos resb 5
   226                                  
   227                                  ;-58 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   228                                  
   229 000001C7 0000                    OpPrintIndex dw 0
   230                                  
   231                                  ;-59 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   232                                  
   233 000001C9 0000                    OpCodePtr dw 0
   234                                  
   235                                  ;-60 char PrintRA;           //print * for forward relocative jmp
   236                                  
   237 000001CB 00                      PrintRA db 0
   238                                  
   239                                  ;-61 
   240                                  
   241                                  
   242                                  ;-62 #define LABELNAMESMAX 969//next number - SYMBOLMAX
   243                                  
   244                                  
   245                                  ;-63 char LabelNames[1000];  //space for names of all labels
   246                                  
   247 000001CC <res 000003E8>          LabelNames resb 1000
   248                                  
   249                                  ;-64 char *LabelNamePtr;     //first free position
   250                                  
   251 000005B4 0000                    LabelNamePtr dw 0
   252                                  
   253                                  ;-65 #define LABELADRMAX 100
   254                                  
   255                                  
   256                                  ;-66 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   257                                  
   258 000005B6 <res 000000C8>          LabelAddr resw 100
   259                                  
   260                                  ;-67 int LabelMaxIx=0;       //actual # of stored labels. 1 to LABELADRMAX-1
   261                                  
   262 0000067E 0000                    LabelMaxIx dw 0
   263                                  
   264                                  ;-68 int LabelIx;            //actual # of just searched label
   265                                  
   266 00000680 0000                    LabelIx dw 0
   267                                  
   268                                  ;-69 
   269                                  
   270                                  
   271                                  ;-70 #define JMPCALLMAX 500  //max. jmp and call
   272                                  
   273                                  
   274                                  ;-71 #define JMPCALLNAMESMAX 1969//next number - SYMBOLMAX
   275                                  
   276                                  
   277                                  ;-72 char JmpCallNames[2000];//space for names of jmp, call
   278                                  
   279 00000682 <res 000007D0>          JmpCallNames resb 2000
   280                                  
   281                                  ;-73 char *JmpCallNamePtr;   //first free position 
   282                                  
   283 00000E52 0000                    JmpCallNamePtr dw 0
   284                                  
   285                                  ;-74 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   286                                  
   287 00000E54 <res 000003E8>          JmpCallAddr resw 500
   288                                  
   289                                  ;-75 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   290                                  
   291 0000123C 0000                    JmpCallMaxIx dw 0
   292                                  
   293                                  ;-76  
   294                                  
   295                                  
   296                                  ;-77 #define FILEBINMAX 2000 
   297                                  
   298                                  
   299                                  ;-78 char FileBin  [FILEBINMAX];//output binary file
   300                                  
   301 0000123E <res 000007D0>          FileBin resb 2000
   302                                  
   303                                  ;-79 unsigned int BinLen=0;  //length of binary file
   304                                  
   305 00001A0E 0000                    BinLen dw 0
   306                                  
   307                                  ;-80 
   308                                  
   309                                  
   310                                  ;-81 char *arglen=0x80;      // for main only
   311                                  
   312 00001A10 8000                    arglen dw 128
   313                                  
   314                                  ;-82 char *argv=0x82;        // for main only
   315                                  
   316 00001A12 8200                    argv dw 130
   317                                  ;Back to main program: AS.C
   318                                  
   319                                  ;-3 #include "OPTABL.C"   
   320                                  
   321                                  ;Use include file: OPTABL.C
   322                                  
   323                                  ;-1 char I_START=0xF1;
   324                                  
   325 00001A14 F1                      I_START db 241
   326                                  
   327                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   328                                  
   329                                  
   330                                  ;-3 //  1:   1 byte opcode
   331                                  
   332                                  
   333                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   334                                  
   335 00001A15 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   336                                  
   337                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   338                                  
   339 00001A1E 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   340                                  
   341                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   342                                  
   343 00001A26 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   344                                  
   345                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   346                                  
   347 00001A2D 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   348                                  
   349                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   350                                  
   351 00001A34 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   352                                  
   353                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   354                                  
   355 00001A3C 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   356                                  
   357                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   358                                  
   359 00001A43 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   360                                  
   361                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   362                                  
   363 00001A4A 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   364                                  
   365                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   366                                  
   367 00001A52 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   368                                  
   369                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   370                                  
   371 00001A5B 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   372                                  
   373                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   374                                  
   375 00001A63 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   376                                  
   377                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   378                                  
   379 00001A6B 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   380                                  
   381                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   382                                  
   383 00001A73 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   384                                  
   385                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   386                                  
   387 00001A7C 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   388                                  
   389                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   390                                  
   391 00001A85 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   392                                  
   393                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   394                                  
   395 00001A8E 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   396                                  
   397                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   398                                  
   399 00001A97 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   400                                  
   401                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   402                                  
   403 00001AA0 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   404                                  
   405                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   406                                  
   407 00001AA9 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   408                                  
   409                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   410                                  
   411 00001AB2 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   412                                  
   413                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   414                                  
   415 00001ABB 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   416                                  
   417                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   418                                  
   419 00001AC4 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   420                                  
   421                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   422                                  
   423 00001ACD 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   424                                  
   425                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   426                                  
   427 00001AD6 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   428                                  
   429                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   430                                  
   431 00001ADE 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   432                                  
   433                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   434                                  
   435 00001AE6 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   436                                  
   437                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   438                                  
   439 00001AEE 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   440                                  
   441                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   442                                  
   443 00001AF6 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   444                                  
   445                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   446                                  
   447 00001AFE 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   448                                  
   449                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   450                                  
   451 00001B07 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   452                                  
   453                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   454                                  
   455 00001B10 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   456                                  
   457                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   458                                  
   459 00001B18 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   460                                  
   461                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   462                                  
   463 00001B20 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   464                                  
   465                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   466                                  
   467 00001B27 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   468                                  
   469                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   470                                  
   471 00001B2E 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   472                                  
   473                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   474                                  
   475 00001B35 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   476                                  
   477                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   478                                  
   479 00001B3C 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   480                                  
   481                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   482                                  
   483 00001B43 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   484                                  
   485                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   486                                  
   487 00001B4A 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   488                                  
   489                                  ;-43 // 2: mem reg 16 bit
   490                                  
   491                                  
   492                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   493                                  
   494 00001B51 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   495                                  
   496                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   497                                  
   498 00001B5A 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   499                                  
   500                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   501                                  
   502 00001B63 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   503                                  
   504                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   505                                  
   506 00001B6B 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   507                                  
   508                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   509                                  
   510 00001B73 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   511                                  
   512                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   513                                  
   514 00001B7B 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   515                                  
   516                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   517                                  
   518 00001B84 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   519                                  
   520                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   521                                  
   522 00001B8C 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   523                                  
   524                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   525                                  
   526                                  
   527                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   528                                  
   529 00001B95 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   530                                  
   531                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   532                                  
   533 00001B9C 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   534                                  
   535                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   536                                  
   537 00001BA3 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   538                                  
   539                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   540                                  
   541 00001BAA 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   542                                  
   543                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   544                                  
   545 00001BB2 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   546                                  
   547                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   548                                  
   549 00001BBA 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   550                                  
   551                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   552                                  
   553                                  
   554                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   555                                  
   556 00001BC2 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   557                                  
   558                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   559                                  
   560 00001BC9 4F52000401F1            I_OR db 79,82,0,4,1,241
   561                                  
   562                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   563                                  
   564 00001BCF 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   565                                  
   566                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   567                                  
   568 00001BD6 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   569                                  
   570                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   571                                  
   572 00001BDD 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   573                                  
   574                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   575                                  
   576 00001BE4 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   577                                  
   578                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   579                                  
   580 00001BEB 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   581                                  
   582                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   583                                  
   584 00001BF2 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   585                                  
   586                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   587                                  
   588 00001BF9 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   589 00001C02 00F1               
   590                                  
   591                                  ;-69 //  5: mov
   592                                  
   593                                  
   594                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   595                                  
   596 00001C04 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   597                                  
   598                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   599                                  
   600 00001C0A 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   601                                  
   602                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   603                                  
   604 00001C13 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   605                                  
   606                                  ;-73 //  6: single byte relative jump
   607                                  
   608                                  
   609                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   610                                  
   611 00001C1C 4A4F000600F1            I_JO db 74,79,0,6,0,241
   612                                  
   613                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   614                                  
   615 00001C22 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   616                                  
   617                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   618                                  
   619 00001C29 4A42000602F1            I_JB db 74,66,0,6,2,241
   620                                  
   621                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   622                                  
   623 00001C2F 4A43000602F1            I_JC db 74,67,0,6,2,241
   624                                  
   625                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   626                                  
   627 00001C35 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   628                                  
   629                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   630                                  
   631 00001C3C 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   632                                  
   633                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   634                                  
   635 00001C43 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   636                                  
   637                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   638                                  
   639 00001C4A 4A45000604F1            I_JE db 74,69,0,6,4,241
   640                                  
   641                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   642                                  
   643 00001C50 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   644                                  
   645                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   646                                  
   647 00001C56 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   648                                  
   649                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   650                                  
   651 00001C5D 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   652                                  
   653                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   654                                  
   655 00001C64 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   656                                  
   657                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   658                                  
   659 00001C6B 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   660                                  
   661                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   662                                  
   663 00001C72 4A41000607F1            I_JA db 74,65,0,6,7,241
   664                                  
   665                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   666                                  
   667 00001C78 4A53000608F1            I_JS db 74,83,0,6,8,241
   668                                  
   669                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   670                                  
   671 00001C7E 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   672                                  
   673                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   674                                  
   675 00001C85 4A5000060AF1            I_JP db 74,80,0,6,10,241
   676                                  
   677                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   678                                  
   679 00001C8B 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   680                                  
   681                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   682                                  
   683 00001C92 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   684                                  
   685                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   686                                  
   687 00001C99 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   688                                  
   689                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   690                                  
   691 00001CA0 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   692                                  
   693                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   694                                  
   695 00001CA6 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   696                                  
   697                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   698                                  
   699 00001CAD 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   700                                  
   701                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   702                                  
   703 00001CB4 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   704                                  
   705                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   706                                  
   707 00001CBB 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   708                                  
   709                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   710                                  
   711 00001CC2 4A4700060FF1            I_JG db 74,71,0,6,15,241
   712                                  
   713                                  ;-100 //  7: jmp, call
   714                                  
   715                                  
   716                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   717                                  
   718 00001CC8 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   719                                  
   720                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   721                                  
   722 00001CD0 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   723                                  
   724                                  ;-103 //  8: ret
   725                                  
   726                                  
   727                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   728                                  
   729 00001CD9 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   730                                  
   731                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   732                                  
   733 00001CE1 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   734                                  
   735                                  ;-106 //  9: seg, r/m
   736                                  
   737                                  
   738                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   739                                  
   740 00001CEA 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   741 00001CF3 06F1               
   742                                  
   743                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   744                                  
   745 00001CF5 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   746 00001CFE F1                 
   747                                  
   748                                  ;-109 //  11: shift, rotates
   749                                  
   750                                  
   751                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   752                                  
   753 00001CFF 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   754                                  
   755                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   756                                  
   757 00001D06 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   758                                  
   759                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   760                                  
   761 00001D0D 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   762                                  
   763                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   764                                  
   765 00001D14 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   766                                  
   767                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   768                                  
   769 00001D1B 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   770                                  
   771                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   772                                  
   773 00001D22 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   774                                  
   775                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   776                                  
   777 00001D29 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   778                                  
   779                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   780                                  
   781 00001D30 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   782                                  
   783                                  ;-118 //  12: int
   784                                  
   785                                  
   786                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   787                                  
   788 00001D37 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   789                                  
   790                                  ;-120 //  14: in/out
   791                                  
   792                                  
   793                                  ;-121 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   794                                  
   795                                  
   796                                  ;-122 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   797                                  
   798                                  
   799                                  ;-123 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   800                                  
   801                                  
   802                                  ;-124 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   803                                  
   804                                  
   805                                  ;-125 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   806                                  
   807                                  
   808                                  ;-126 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   809                                  
   810                                  
   811                                  ;-127 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   812                                  
   813                                  
   814                                  ;-128 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   815                                  
   816                                  
   817                                  ;-129 //  15: xchg
   818                                  
   819                                  
   820                                  ;-130 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   821                                  
   822 00001D3F 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   823                                  
   824                                  ;-131 //  16: loop, jcxz
   825                                  
   826                                  
   827                                  ;-132 /*char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   828                                  
   829                                  
   830                                  ;-133 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   831                                  
   832                                  
   833                                  ;-134 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   834                                  
   835                                  
   836                                  ;-135 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   837                                  
   838                                  
   839                                  ;-136 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   840                                  
   841                                  
   842                                  ;-137 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   843                                  
   844                                  
   845                                  ;-138 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};*/
   846                                  
   847                                  
   848                                  ;-139 //  30: enter
   849                                  
   850                                  
   851                                  ;-140 char I_ENTER[]={'E','N','T','E','R',0,  30,       0xF1};
   852                                  
   853 00001D48 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   854                                  
   855                                  ;-141 // 100: directives
   856                                  
   857                                  
   858                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   859                                  
   860 00001D50 4F52470065F1            I_ORG db 79,82,71,0,101,241
   861                                  
   862                                  ;-143 // section, segment .TEXT .DATA .BSS
   863                                  
   864                                  
   865                                  ;-144 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   866                                  
   867                                  
   868                                  ;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   869                                  
   870                                  
   871                                  ;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   872                                  
   873                                  
   874                                  ;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};
   875                                  
   876 00001D56 444200C8F1              I_DB db 68,66,0,200,241
   877                                  
   878                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   879                                  
   880 00001D5B 445700C9F1              I_DW db 68,87,0,201,241
   881                                  
   882                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   883                                  
   884 00001D60 444400CAF1              I_DD db 68,68,0,202,241
   885                                  
   886                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    203,        0xF1};
   887                                  
   888 00001D65 5245534200CBF1          I_RESB db 82,69,83,66,0,203,241
   889                                  
   890                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    204,        0xF1};
   891                                  
   892 00001D6C 5245535700CCF1          I_RESW db 82,69,83,87,0,204,241
   893                                  
   894                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    205,        0xF1};
   895                                  
   896 00001D73 5245534400CDF1          I_RESD db 82,69,83,68,0,205,241
   897                                  
   898                                  ;-153 char I_END=0;// end of table char
   899                                  
   900 00001D7A 00                      I_END db 0
   901                                  ;Back to main program: AS.C
   902                                  
   903                                  ;-4 #include "OPS.C"
   904                                  
   905                                  ;Use include file: OPS.C
   906                                  
   907                                  ;-1 int ChangeDirection() {
   908                                  
   909                                  
   910                                  ChangeDirection:  ; *** PROC ***
   911                                  
   912                                  ;-2     char c;
   913                                  
   914                                  
   915                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   916                                  
   917                                  ;Function : ChangeDirection, Number of local variables: 1
   918                                  ;   # type sign width line used address name   list of local variables
   919                                  ;  200 var sign byte     2 NULL bp-2    c;
   920 00001D7B C8020000                 ENTER  2,0
   921 00001D7F A0[AE01]                 mov al, [Op]
   922 00001D82 8846FE                   mov byte [bp-2], al
   923 00001D85 A0[AF01]                 mov al, [Op2]
   924 00001D88 A2[AE01]                 mov byte [Op], al
   925 00001D8B 8A46FE                   mov al, [bp-2]
   926 00001D8E A2[AF01]                 mov byte [Op2], al
   927                                  
   928                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   929                                  
   930 00001D91 A0[B701]                 mov al, [R1Type]
   931 00001D94 8846FE                   mov byte [bp-2], al
   932 00001D97 A0[B601]                 mov al, [R2Type]
   933 00001D9A A2[B701]                 mov byte [R1Type], al
   934 00001D9D 8A46FE                   mov al, [bp-2]
   935 00001DA0 A2[B601]                 mov byte [R2Type], al
   936                                  
   937                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   938                                  
   939 00001DA3 A0[B501]                 mov al, [R1No]
   940 00001DA6 8846FE                   mov byte [bp-2], al
   941 00001DA9 A0[B401]                 mov al, [R2No]
   942 00001DAC A2[B501]                 mov byte [R1No], al
   943 00001DAF 8A46FE                   mov al, [bp-2]
   944 00001DB2 A2[B401]                 mov byte [R2No], al
   945                                  
   946                                  ;-6     dflag=2;     
   947                                  
   948 00001DB5 66B802000000             mov eax, 2
   949 00001DBB A2[BA01]                 mov byte [dflag], al
   950                                  
   951                                  ;-7 }
   952                                  
   953                                  
   954                                  ;-8      
   955                                  
   956                                  
   957                                  ;-9 int checkOpL() {
   958 00001DBE C9                       LEAVE
   959 00001DBF C3                       ret
   960                                  ; ENDP
   961                                  
   962                                  checkOpL:  ; *** PROC ***
   963                                  
   964                                  ;-10     if (Op == ADR) implerror();
   965                                  
   966 00001DC0 A0[AE01]                 mov al, [Op]
   967 00001DC3 3C03                     cmp al, 3
   968 00001DC5 0F850300                 jne @@checkOpL1
   969 00001DC9 E8A415                   call implerror
   970                                  
   971                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   972                                  
   973                                  @@checkOpL1:
   974 00001DCC A0[B701]                 mov al, [R1Type]
   975 00001DCF 3C04                     cmp al, 4
   976 00001DD1 0F850600                 jne @@checkOpL2
   977 00001DD5 E86016                   call segregerror
   978 00001DD8 E93E00                   jmp @@retn
   979                                  
   980                                  ;-12     setwflag();
   981                                  
   982                                  @@checkOpL2:
   983 00001DDB E8CB03                   call setwflag
   984                                  
   985                                  ;-13     if (OpSize == 0) error1("no op size declared");
   986                                  
   987 00001DDE A0[B801]                 mov al, [OpSize]
   988 00001DE1 3C00                     cmp al, 0
   989 00001DE3 0F850900                 jne @@checkOpL3
   990 00001DE7 68[1A1E]                 push checkOpL_0
   991 00001DEA E8B314                   call error1
   992 00001DED 83C402                   add  sp, 2
   993                                  
   994                                  ;-14     if (OpSize == R1Type) return;
   995                                  
   996                                  @@checkOpL3:
   997 00001DF0 A0[B801]                 mov al, [OpSize]
   998 00001DF3 3A06[B701]               cmp al, [R1Type]
   999 00001DF7 0F850300                 jne @@checkOpL4
  1000 00001DFB E91B00                   jmp @@retn
  1001                                  
  1002                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1003                                  
  1004                                  @@checkOpL4:
  1005 00001DFE A0[AE01]                 mov al, [Op]
  1006 00001E01 3C02                     cmp al, 2
  1007 00001E03 0F851200                 jne @@checkOpL5
  1008 00001E07 A0[B701]                 mov al, [R1Type]
  1009 00001E0A 3C00                     cmp al, 0
  1010 00001E0C 0F850900                 jne @@checkOpL6
  1011 00001E10 68[2E1E]                 push checkOpL_1
  1012 00001E13 E88A14                   call error1
  1013 00001E16 83C402                   add  sp, 2
  1014                                  
  1015                                  ;-16 }
  1016                                  
  1017                                  @@checkOpL6:
  1018                                  @@checkOpL5:
  1019                                  
  1020                                  ;-17     
  1021                                  
  1022                                  
  1023                                  ;-18 int check2Ops() {
  1024                                  
  1025                                  @@retn:
  1026 00001E19 C3                       ret
  1027                                  ; ENDP
  1028 00001E1A 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1029 00001E23 65206465636C617265-
  1030 00001E2C 6400               
  1031 00001E2E 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1032 00001E37 657220646566696E65-
  1033 00001E40 6400               
  1034                                  
  1035                                  check2Ops:  ; *** PROC ***
  1036                                  
  1037                                  ;-19     get2Ops();
  1038                                  
  1039 00001E42 E84900                   call get2Ops
  1040                                  
  1041                                  ;-20     if (Op ==   0) addrerror();
  1042                                  
  1043 00001E45 A0[AE01]                 mov al, [Op]
  1044 00001E48 3C00                     cmp al, 0
  1045 00001E4A 0F850300                 jne @@check2Ops7
  1046 00001E4E E8E014                   call addrerror
  1047                                  
  1048                                  ;-21     if (Op == ADR) invaloperror(); 
  1049                                  
  1050                                  @@check2Ops7:
  1051 00001E51 A0[AE01]                 mov al, [Op]
  1052 00001E54 3C03                     cmp al, 3
  1053 00001E56 0F850300                 jne @@check2Ops8
  1054 00001E5A E84E15                   call invaloperror
  1055                                  
  1056                                  ;-22     if (Op == IMM) immeerror();   
  1057                                  
  1058                                  @@check2Ops8:
  1059 00001E5D A0[AE01]                 mov al, [Op]
  1060 00001E60 3C01                     cmp al, 1
  1061 00001E62 0F850300                 jne @@check2Ops9
  1062 00001E66 E8E214                   call immeerror
  1063                                  
  1064                                  ;-23     if (Op2==   0) addrerror();
  1065                                  
  1066                                  @@check2Ops9:
  1067 00001E69 A0[AF01]                 mov al, [Op2]
  1068 00001E6C 3C00                     cmp al, 0
  1069 00001E6E 0F850300                 jne @@check2Ops10
  1070 00001E72 E8BC14                   call addrerror
  1071                                  
  1072                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           
  1073                                  
  1074                                  @@check2Ops10:
  1075 00001E75 A0[B001]                 mov al, [CodeType]
  1076 00001E78 3C05                     cmp al, 5
  1077 00001E7A 0F840C00                 je  @@check2Ops11
  1078 00001E7E A0[AF01]                 mov al, [Op2]
  1079 00001E81 3C03                     cmp al, 3
  1080 00001E83 0F850300                 jne @@check2Ops12
  1081 00001E87 E82115                   call invaloperror
  1082                                  
  1083                                  ;-25     setwflag();       
  1084                                  
  1085                                  @@check2Ops12:
  1086                                  @@check2Ops11:
  1087 00001E8A E81C03                   call setwflag
  1088                                  
  1089                                  ;-26 }    
  1090                                  
  1091                                  
  1092                                  ;-27 int get2Ops() {
  1093                                  
  1094 00001E8D C3                       ret
  1095                                  ; ENDP
  1096                                  
  1097                                  get2Ops:  ; *** PROC ***
  1098                                  
  1099                                  ;-28     getOpL();
  1100                                  
  1101 00001E8E E80C00                   call getOpL
  1102                                  
  1103                                  ;-29     need(',');    
  1104                                  
  1105 00001E91 6A2C                     push 44
  1106 00001E93 E8E109                   call need
  1107 00001E96 83C402                   add  sp, 2
  1108                                  
  1109                                  ;-30     getOpR();         
  1110                                  
  1111 00001E99 E83200                   call getOpR
  1112                                  
  1113                                  ;-31 } 
  1114                                  
  1115                                  
  1116                                  ;-32         
  1117                                  
  1118                                  
  1119                                  ;-33 int getOpL() {
  1120                                  
  1121 00001E9C C3                       ret
  1122                                  ; ENDP
  1123                                  
  1124                                  getOpL:  ; *** PROC ***
  1125                                  
  1126                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1127                                  
  1128                                  
  1129                                  ;-35     getOpR();
  1130                                  
  1131 00001E9D E82E00                   call getOpR
  1132                                  
  1133                                  ;-36     Op=Op2;         Op2=0;
  1134                                  
  1135 00001EA0 A0[AF01]                 mov al, [Op2]
  1136 00001EA3 A2[AE01]                 mov byte [Op], al
  1137 00001EA6 66B800000000             mov eax, 0
  1138 00001EAC A2[AF01]                 mov byte [Op2], al
  1139                                  
  1140                                  ;-37     R1No=R2No;      R2No=0;
  1141                                  
  1142 00001EAF A0[B401]                 mov al, [R2No]
  1143 00001EB2 A2[B501]                 mov byte [R1No], al
  1144 00001EB5 66B800000000             mov eax, 0
  1145 00001EBB A2[B401]                 mov byte [R2No], al
  1146                                  
  1147                                  ;-38     R1Type=R2Type; R2Type=0; 
  1148                                  
  1149 00001EBE A0[B601]                 mov al, [R2Type]
  1150 00001EC1 A2[B701]                 mov byte [R1Type], al
  1151 00001EC4 66B800000000             mov eax, 0
  1152 00001ECA A2[B601]                 mov byte [R2Type], al
  1153                                  
  1154                                  ;-39 }  
  1155                                  
  1156                                  
  1157                                  ;-40 
  1158                                  
  1159                                  
  1160                                  ;-41 int getOpR() {
  1161                                  
  1162 00001ECD C3                       ret
  1163                                  ; ENDP
  1164                                  
  1165                                  getOpR:  ; *** PROC ***
  1166                                  
  1167                                  ;-42     Op2=getOp1();
  1168                                  
  1169 00001ECE E88900                   call getOp1
  1170 00001ED1 A2[AF01]                 mov byte [Op2], al
  1171                                  
  1172                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1173                                  
  1174 00001ED4 6A5B                     push 91
  1175 00001ED6 E87009                   call isToken
  1176 00001ED9 83C402                   add  sp, 2
  1177 00001EDC 08C0                     or  al, al
  1178 00001EDE 0F840F00                 je @@getOpR13
  1179 00001EE2 66B804000000             mov eax, 4
  1180 00001EE8 A2[AF01]                 mov byte [Op2], al
  1181 00001EEB E8F200                   call getMEM
  1182 00001EEE E94F00                   jmp @@retn
  1183                                  
  1184                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1185                                  
  1186                                  @@getOpR13:
  1187 00001EF1 A0[AF01]                 mov al, [Op2]
  1188 00001EF4 3C00                     cmp al, 0
  1189 00001EF6 0F850600                 jne @@getOpR14
  1190 00001EFA E8AE14                   call invaloperror
  1191 00001EFD E94000                   jmp @@retn
  1192                                  
  1193                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1194                                  
  1195                                  @@getOpR14:
  1196 00001F00 A0[AF01]                 mov al, [Op2]
  1197 00001F03 3C01                     cmp al, 1
  1198 00001F05 0F850900                 jne @@getOpR15
  1199 00001F09 A1[4D00]                 mov ax, [SymbolInt]
  1200 00001F0C A3[C001]                 mov word [imme], ax
  1201 00001F0F E92E00                   jmp @@retn
  1202                                  
  1203                                  ;-46     if (Op2 == REG)                            return;
  1204                                  
  1205                                  @@getOpR15:
  1206 00001F12 A0[AF01]                 mov al, [Op2]
  1207 00001F15 3C02                     cmp al, 2
  1208 00001F17 0F850300                 jne @@getOpR16
  1209 00001F1B E92200                   jmp @@retn
  1210                                  
  1211                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1212                                  
  1213                                  @@getOpR16:
  1214 00001F1E A0[AF01]                 mov al, [Op2]
  1215 00001F21 3C03                     cmp al, 3
  1216 00001F23 0F851000                 jne @@getOpR17
  1217 00001F27 8B1E[8006]               mov bx, [LabelIx]
  1218 00001F2B D1E3                     shl bx, 1
  1219 00001F2D 8B87[B605]               mov ax, [LabelAddr + bx]
  1220 00001F31 A3[BE01]                 mov word [disp], ax
  1221 00001F34 E90900                   jmp @@retn
  1222                                  
  1223                                  ;-48     error1("Name of operand expected");
  1224                                  
  1225                                  @@getOpR17:
  1226 00001F37 68[411F]                 push getOpR_0
  1227 00001F3A E86313                   call error1
  1228 00001F3D 83C402                   add  sp, 2
  1229                                  
  1230                                  ;-49 }
  1231                                  
  1232                                  
  1233                                  ;-50 
  1234                                  
  1235                                  
  1236                                  ;-51 int getOp1() {//scan for a single operand
  1237                                  
  1238                                  @@retn:
  1239 00001F40 C3                       ret
  1240                                  ; ENDP
  1241 00001F41 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1242 00001F4A 706572616E64206578-
  1243 00001F53 70656374656400     
  1244                                  
  1245                                  getOp1:  ; *** PROC ***
  1246                                  
  1247                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1248                                  
  1249                                  
  1250                                  ;-53 //set   :R2Type, R2No by testReg
  1251                                  
  1252                                  
  1253                                  ;-54 //set   :LabelIx by searchLabel
  1254                                  
  1255                                  
  1256                                  ;-55     if (TokeType == 0)      return 0;
  1257                                  
  1258 00001F5A A0[AD01]                 mov al, [TokeType]
  1259 00001F5D 3C00                     cmp al, 0
  1260 00001F5F 0F850900                 jne @@getOp118
  1261 00001F63 66B800000000             mov eax, 0
  1262 00001F69 E96000                   jmp @@retn
  1263                                  
  1264                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1265                                  
  1266                                  @@getOp118:
  1267 00001F6C A0[AD01]                 mov al, [TokeType]
  1268 00001F6F 3C01                     cmp al, 1
  1269 00001F71 0F850900                 jne @@getOp119
  1270 00001F75 66B801000000             mov eax, 1
  1271 00001F7B E94E00                   jmp @@retn
  1272                                  
  1273                                  ;-57     if (TokeType == ALNUME) {
  1274                                  
  1275                                  @@getOp119:
  1276 00001F7E A0[AD01]                 mov al, [TokeType]
  1277 00001F81 3C03                     cmp al, 3
  1278 00001F83 0F853C00                 jne @@getOp120
  1279                                  
  1280                                  ;-58         R2No=testReg();
  1281                                  
  1282 00001F87 E86C0C                   call testReg
  1283 00001F8A A2[B401]                 mov byte [R2No], al
  1284                                  
  1285                                  ;-59         if (R2Type)        return REG;
  1286                                  
  1287 00001F8D A0[B601]                 mov al, [R2Type]
  1288 00001F90 08C0                     or  al, al
  1289 00001F92 0F840900                 je @@getOp121
  1290 00001F96 66B802000000             mov eax, 2
  1291 00001F9C E92D00                   jmp @@retn
  1292                                  
  1293                                  ;-60         LabelIx=searchLabel();
  1294                                  
  1295                                  @@getOp121:
  1296 00001F9F E8F005                   call searchLabel
  1297 00001FA2 A3[8006]                 mov word [LabelIx], ax
  1298                                  
  1299                                  ;-61         if (LabelIx)        return ADR;
  1300                                  
  1301 00001FA5 A1[8006]                 mov ax, [LabelIx]
  1302 00001FA8 08C0                     or  al, al
  1303 00001FAA 0F840C00                 je @@getOp122
  1304 00001FAE 66B803000000             mov eax, 3
  1305 00001FB4 E91500                   jmp @@retn
  1306                                  
  1307                                  ;-62         else error1("variable not found"); 
  1308                                  
  1309 00001FB7 E90900                   jmp @@getOp123
  1310                                  @@getOp122:
  1311 00001FBA 68[CD1F]                 push getOp1_0
  1312 00001FBD E8E012                   call error1
  1313 00001FC0 83C402                   add  sp, 2
  1314                                  
  1315                                  ;-63     }
  1316                                  
  1317                                  @@getOp123:
  1318                                  
  1319                                  ;-64     return 0;
  1320                                  
  1321                                  @@getOp120:
  1322 00001FC3 66B800000000             mov eax, 0
  1323 00001FC9 E90000                   jmp @@retn
  1324                                  
  1325                                  ;-65 }
  1326                                  
  1327                                  
  1328                                  ;-66 
  1329                                  
  1330                                  
  1331                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1332                                  
  1333                                  @@retn:
  1334 00001FCC C3                       ret
  1335                                  ; ENDP
  1336 00001FCD 7661726961626C6520-     getOp1_0 db "variable not found",0
  1337 00001FD6 6E6F7420666F756E64-
  1338 00001FDF 00                 
  1339                                  
  1340                                  getMEM:  ; *** PROC ***
  1341                                  
  1342                                  ;-68 //set: disp, rm, R2Type
  1343                                  
  1344                                  
  1345                                  ;-69     char c;
  1346                                  
  1347                                  
  1348                                  ;-70     disp=0; rm=0;
  1349                                  
  1350                                  ;Function : getMEM, Number of local variables: 1
  1351                                  ;   # type sign width line used address name   list of local variables
  1352                                  ;  200 var sign byte    69 NULL bp-2    c;
  1353 00001FE0 C8020000                 ENTER  2,0
  1354 00001FE4 66B800000000             mov eax, 0
  1355 00001FEA A3[BE01]                 mov word [disp], ax
  1356 00001FED 66B800000000             mov eax, 0
  1357 00001FF3 A2[BC01]                 mov byte [rm], al
  1358                                  
  1359                                  ;-71     do {
  1360                                  
  1361                                  @@getMEM24:
  1362                                  
  1363                                  ;-72         getTokeType();
  1364                                  
  1365 00001FF6 E8D203                   call getTokeType
  1366                                  
  1367                                  ;-73         c=getOp1();
  1368                                  
  1369 00001FF9 E85EFF                   call getOp1
  1370 00001FFC 8846FE                   mov byte [bp-2], al
  1371                                  
  1372                                  ;-74         if (c ==   0) syntaxerror();
  1373                                  
  1374 00001FFF 8A46FE                   mov al, [bp-2]
  1375 00002002 3C00                     cmp al, 0
  1376 00002004 0F850300                 jne @@getMEM25
  1377 00002008 E85414                   call syntaxerror
  1378                                  
  1379                                  ;-75         if (c == REG) {
  1380                                  
  1381                                  @@getMEM25:
  1382 0000200B 8A46FE                   mov al, [bp-2]
  1383 0000200E 3C02                     cmp al, 2
  1384 00002010 0F851E00                 jne @@getMEM26
  1385                                  
  1386                                  ;-76             isDirect=0;
  1387                                  
  1388 00002014 66B800000000             mov eax, 0
  1389 0000201A A2[BD01]                 mov byte [isDirect], al
  1390                                  
  1391                                  ;-77             if (rm) rm=getIndReg2();
  1392                                  
  1393 0000201D A0[BC01]                 mov al, [rm]
  1394 00002020 08C0                     or  al, al
  1395 00002022 0F840900                 je @@getMEM27
  1396 00002026 E8F300                   call getIndReg2
  1397 00002029 A2[BC01]                 mov byte [rm], al
  1398                                  
  1399                                  ;-78             else getIndReg1();
  1400                                  
  1401 0000202C E90300                   jmp @@getMEM28
  1402                                  @@getMEM27:
  1403 0000202F E88900                   call getIndReg1
  1404                                  
  1405                                  ;-79         }
  1406                                  
  1407                                  @@getMEM28:
  1408                                  
  1409                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1410                                  
  1411                                  @@getMEM26:
  1412 00002032 8A46FE                   mov al, [bp-2]
  1413 00002035 3C03                     cmp al, 3
  1414 00002037 0F851000                 jne @@getMEM29
  1415 0000203B A1[BE01]                 mov ax, [disp]
  1416 0000203E 8B1E[8006]               mov bx, [LabelIx]
  1417 00002042 D1E3                     shl bx, 1
  1418 00002044 0387[B605]               add ax, [LabelAddr + bx]
  1419 00002048 A3[BE01]                 mov word [disp], ax
  1420                                  
  1421                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1422                                  
  1423                                  @@getMEM29:
  1424 0000204B 8A46FE                   mov al, [bp-2]
  1425 0000204E 3C01                     cmp al, 1
  1426 00002050 0F850A00                 jne @@getMEM30
  1427 00002054 A1[BE01]                 mov ax, [disp]
  1428 00002057 0306[4D00]               add ax, [SymbolInt]
  1429 0000205B A3[BE01]                 mov word [disp], ax
  1430                                  
  1431                                  ;-82         if (isToken('-')) {
  1432                                  
  1433                                  @@getMEM30:
  1434 0000205E 6A2D                     push 45
  1435 00002060 E8E607                   call isToken
  1436 00002063 83C402                   add  sp, 2
  1437 00002066 08C0                     or  al, al
  1438 00002068 0F841900                 je @@getMEM31
  1439                                  
  1440                                  ;-83             getTokeType();
  1441                                  
  1442 0000206C E85C03                   call getTokeType
  1443                                  
  1444                                  ;-84             if (TokeType != DIGIT) numbererror();
  1445                                  
  1446 0000206F A0[AD01]                 mov al, [TokeType]
  1447 00002072 3C01                     cmp al, 1
  1448 00002074 0F840300                 je  @@getMEM32
  1449 00002078 E85113                   call numbererror
  1450                                  
  1451                                  ;-85             disp = disp - SymbolInt;
  1452                                  
  1453                                  @@getMEM32:
  1454 0000207B A1[BE01]                 mov ax, [disp]
  1455 0000207E 2B06[4D00]               sub ax, [SymbolInt]
  1456 00002082 A3[BE01]                 mov word [disp], ax
  1457                                  
  1458                                  ;-86         }
  1459                                  
  1460                                  
  1461                                  ;-87     } while (isToken('+'));
  1462                                  
  1463                                  @@getMEM31:
  1464 00002085 6A2B                     push 43
  1465 00002087 E8BF07                   call isToken
  1466 0000208A 83C402                   add  sp, 2
  1467 0000208D 08C0                     or  al, al
  1468 0000208F 0F840300                 je @@getMEM33
  1469 00002093 E960FF                   jmp @@getMEM24
  1470                                  @@getMEM33:
  1471                                  
  1472                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1473                                  
  1474 00002096 6A5D                     push 93
  1475 00002098 E8AE07                   call isToken
  1476 0000209B 83C402                   add  sp, 2
  1477 0000209E 83F800                   cmp ax, 0
  1478 000020A1 0F850900                 jne @@getMEM34
  1479 000020A5 68[B020]                 push getMEM_0
  1480 000020A8 E85412                   call errorexit
  1481 000020AB 83C402                   add  sp, 2
  1482                                  
  1483                                  ;-89 }
  1484                                  
  1485                                  @@getMEM34:
  1486                                  
  1487                                  ;-90 int getIndReg1() {
  1488 000020AE C9                       LEAVE
  1489 000020AF C3                       ret
  1490                                  ; ENDP
  1491 000020B0 5D2065787065637465-     getMEM_0 db "] expected",0
  1492 000020B9 6400               
  1493                                  
  1494                                  getIndReg1:  ; *** PROC ***
  1495                                  
  1496                                  ;-91     if (R2Type !=WORD) indexerror();
  1497                                  
  1498 000020BB A0[B601]                 mov al, [R2Type]
  1499 000020BE 3C02                     cmp al, 2
  1500 000020C0 0F840300                 je  @@getIndReg135
  1501 000020C4 E8C312                   call indexerror
  1502                                  
  1503                                  ;-92     if (R2No==3) rm=7;//BX
  1504                                  
  1505                                  @@getIndReg135:
  1506 000020C7 A0[B401]                 mov al, [R2No]
  1507 000020CA 3C03                     cmp al, 3
  1508 000020CC 0F850900                 jne @@getIndReg136
  1509 000020D0 66B807000000             mov eax, 7
  1510 000020D6 A2[BC01]                 mov byte [rm], al
  1511                                  
  1512                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1513                                  
  1514                                  @@getIndReg136:
  1515 000020D9 A0[B401]                 mov al, [R2No]
  1516 000020DC 3C05                     cmp al, 5
  1517 000020DE 0F850900                 jne @@getIndReg137
  1518 000020E2 66B806000000             mov eax, 6
  1519 000020E8 A2[BC01]                 mov byte [rm], al
  1520                                  
  1521                                  ;-94     if (R2No==7) rm=5;//DI
  1522                                  
  1523                                  @@getIndReg137:
  1524 000020EB A0[B401]                 mov al, [R2No]
  1525 000020EE 3C07                     cmp al, 7
  1526 000020F0 0F850900                 jne @@getIndReg138
  1527 000020F4 66B805000000             mov eax, 5
  1528 000020FA A2[BC01]                 mov byte [rm], al
  1529                                  
  1530                                  ;-95     if (R2No==6) rm=4;//SI
  1531                                  
  1532                                  @@getIndReg138:
  1533 000020FD A0[B401]                 mov al, [R2No]
  1534 00002100 3C06                     cmp al, 6
  1535 00002102 0F850900                 jne @@getIndReg139
  1536 00002106 66B804000000             mov eax, 4
  1537 0000210C A2[BC01]                 mov byte [rm], al
  1538                                  
  1539                                  ;-96     if (rm==0) indexerror();
  1540                                  
  1541                                  @@getIndReg139:
  1542 0000210F A0[BC01]                 mov al, [rm]
  1543 00002112 3C00                     cmp al, 0
  1544 00002114 0F850300                 jne @@getIndReg140
  1545 00002118 E86F12                   call indexerror
  1546                                  
  1547                                  ;-97 }
  1548                                  
  1549                                  @@getIndReg140:
  1550                                  
  1551                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1552                                  
  1553 0000211B C3                       ret
  1554                                  ; ENDP
  1555                                  
  1556                                  getIndReg2:  ; *** PROC ***
  1557                                  ;Function : getIndReg2, Number of local variables: 1
  1558                                  ;   # type sign width line used address name   list of local variables
  1559                                  ;  200 var sign byte    98 NULL bp-2    m;
  1560 0000211C C8020000                 ENTER  2,0
  1561 00002120 66B804000000             mov eax, 4
  1562 00002126 8846FE                   mov byte [bp-2], al
  1563                                  
  1564                                  ;-99     if (R2Type !=WORD) indexerror();
  1565                                  
  1566 00002129 A0[B601]                 mov al, [R2Type]
  1567 0000212C 3C02                     cmp al, 2
  1568 0000212E 0F840300                 je  @@getIndReg241
  1569 00002132 E85512                   call indexerror
  1570                                  
  1571                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1572                                  
  1573                                  @@getIndReg241:
  1574 00002135 A0[B401]                 mov al, [R2No]
  1575 00002138 3C07                     cmp al, 7
  1576 0000213A 0F852700                 jne @@getIndReg242
  1577 0000213E A0[BC01]                 mov al, [rm]
  1578 00002141 3C06                     cmp al, 6
  1579 00002143 0F850C00                 jne @@getIndReg243
  1580 00002147 66B803000000             mov eax, 3
  1581 0000214D 8846FE                   mov byte [bp-2], al
  1582                                  
  1583                                  ;-101              else if (rm==7) m=1;//BX+DI
  1584                                  
  1585 00002150 E91200                   jmp @@getIndReg244
  1586                                  @@getIndReg243:
  1587 00002153 A0[BC01]                 mov al, [rm]
  1588 00002156 3C07                     cmp al, 7
  1589 00002158 0F850900                 jne @@getIndReg245
  1590 0000215C 66B801000000             mov eax, 1
  1591 00002162 8846FE                   mov byte [bp-2], al
  1592                                  
  1593                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1594                                  
  1595                                  @@getIndReg245:
  1596                                  @@getIndReg244:
  1597                                  @@getIndReg242:
  1598 00002165 A0[B401]                 mov al, [R2No]
  1599 00002168 3C06                     cmp al, 6
  1600 0000216A 0F852700                 jne @@getIndReg246
  1601 0000216E A0[BC01]                 mov al, [rm]
  1602 00002171 3C06                     cmp al, 6
  1603 00002173 0F850C00                 jne @@getIndReg247
  1604 00002177 66B802000000             mov eax, 2
  1605 0000217D 8846FE                   mov byte [bp-2], al
  1606                                  
  1607                                  ;-103              else if (rm==7) m=0;//BX+SI
  1608                                  
  1609 00002180 E91200                   jmp @@getIndReg248
  1610                                  @@getIndReg247:
  1611 00002183 A0[BC01]                 mov al, [rm]
  1612 00002186 3C07                     cmp al, 7
  1613 00002188 0F850900                 jne @@getIndReg249
  1614 0000218C 66B800000000             mov eax, 0
  1615 00002192 8846FE                   mov byte [bp-2], al
  1616                                  
  1617                                  ;-104     if (m > 3) indexerror();
  1618                                  
  1619                                  @@getIndReg249:
  1620                                  @@getIndReg248:
  1621                                  @@getIndReg246:
  1622 00002195 8A46FE                   mov al, [bp-2]
  1623 00002198 3C03                     cmp al, 3
  1624 0000219A 0F8E0300                 jle @@getIndReg250
  1625 0000219E E8E911                   call indexerror
  1626                                  
  1627                                  ;-105     return m;
  1628                                  
  1629                                  @@getIndReg250:
  1630 000021A1 8A46FE                   mov al, [bp-2]
  1631 000021A4 E90000                   jmp @@retn
  1632                                  
  1633                                  ;-106 }
  1634                                  
  1635                                  
  1636                                  ;-107                   
  1637                                  
  1638                                  
  1639                                  ;-108 int setwflag() {//word size, bit 0
  1640                                  
  1641 000021A7 C9                      @@retn: LEAVE
  1642 000021A8 C3                       ret
  1643                                  ; ENDP
  1644                                  
  1645                                  setwflag:  ; *** PROC ***
  1646                                  
  1647                                  ;-109     wflag=0;
  1648                                  
  1649 000021A9 66B800000000             mov eax, 0
  1650 000021AF A2[B901]                 mov byte [wflag], al
  1651                                  
  1652                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1653                                  
  1654 000021B2 A0[B801]                 mov al, [OpSize]
  1655 000021B5 3C00                     cmp al, 0
  1656 000021B7 0F854200                 jne @@setwflag51
  1657                                  
  1658                                  ;-111         if (Op == REG) OpSize=R1Type;
  1659                                  
  1660 000021BB A0[AE01]                 mov al, [Op]
  1661 000021BE 3C02                     cmp al, 2
  1662 000021C0 0F850600                 jne @@setwflag52
  1663 000021C4 A0[B701]                 mov al, [R1Type]
  1664 000021C7 A2[B801]                 mov byte [OpSize], al
  1665                                  
  1666                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1667                                  
  1668                                  @@setwflag52:
  1669 000021CA A0[AF01]                 mov al, [Op2]
  1670 000021CD 3C02                     cmp al, 2
  1671 000021CF 0F850600                 jne @@setwflag53
  1672 000021D3 A0[B601]                 mov al, [R2Type]
  1673 000021D6 A2[B801]                 mov byte [OpSize], al
  1674                                  
  1675                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1676                                  
  1677                                  @@setwflag53:
  1678 000021D9 A0[B601]                 mov al, [R2Type]
  1679 000021DC 3C04                     cmp al, 4
  1680 000021DE 0F850900                 jne @@setwflag54
  1681 000021E2 66B802000000             mov eax, 2
  1682 000021E8 A2[B801]                 mov byte [OpSize], al
  1683                                  
  1684                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1685                                  
  1686                                  @@setwflag54:
  1687 000021EB A0[B701]                 mov al, [R1Type]
  1688 000021EE 3C04                     cmp al, 4
  1689 000021F0 0F850900                 jne @@setwflag55
  1690 000021F4 66B802000000             mov eax, 2
  1691 000021FA A2[B801]                 mov byte [OpSize], al
  1692                                  
  1693                                  ;-115     }
  1694                                  
  1695                                  @@setwflag55:
  1696                                  
  1697                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1698                                  
  1699                                  @@setwflag51:
  1700 000021FD A0[B801]                 mov al, [OpSize]
  1701 00002200 3C03                     cmp al, 3
  1702 00002202 0F850C00                 jne @@setwflag56
  1703 00002206 E87617                   call gen66h
  1704 00002209 66B801000000             mov eax, 1
  1705 0000220F A2[B901]                 mov byte [wflag], al
  1706                                  
  1707                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1708                                  
  1709                                  @@setwflag56:
  1710 00002212 A0[B801]                 mov al, [OpSize]
  1711 00002215 3C02                     cmp al, 2
  1712 00002217 0F850900                 jne @@setwflag57
  1713 0000221B 66B801000000             mov eax, 1
  1714 00002221 A2[B901]                 mov byte [wflag], al
  1715                                  
  1716                                  ;-118 }
  1717                                  
  1718                                  @@setwflag57:
  1719                                  
  1720                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1721                                  
  1722 00002224 C3                       ret
  1723                                  ; ENDP
  1724                                  
  1725                                  setsflag:  ; *** PROC ***
  1726                                  
  1727                                  ;-120     unsigned int ui;    
  1728                                  
  1729                                  
  1730                                  ;-121     sflag=2;   
  1731                                  
  1732                                  ;Function : setsflag, Number of local variables: 1
  1733                                  ;   # type sign width line used address name   list of local variables
  1734                                  ;  200 var unsg word   120 NULL bp-2    ui;
  1735 00002225 C8020000                 ENTER  2,0
  1736 00002229 66B802000000             mov eax, 2
  1737 0000222F A2[BB01]                 mov byte [sflag], al
  1738                                  
  1739                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1740                                  
  1741 00002232 A1[C001]                 mov ax, [imme]
  1742 00002235 2580FF                   and ax, 65408
  1743 00002238 8946FE                   mov word [bp-2], ax
  1744                                  
  1745                                  ;-123     if(ui != 0) sflag = 0;
  1746                                  
  1747 0000223B 8B46FE                   mov ax, [bp-2]
  1748 0000223E 83F800                   cmp ax, 0
  1749 00002241 0F840900                 je  @@setsflag58
  1750 00002245 66B800000000             mov eax, 0
  1751 0000224B A2[BB01]                 mov byte [sflag], al
  1752                                  
  1753                                  ;-124     if (OpSize == BYTE) {
  1754                                  
  1755                                  @@setsflag58:
  1756 0000224E A0[B801]                 mov al, [OpSize]
  1757 00002251 3C01                     cmp al, 1
  1758 00002253 0F851C00                 jne @@setsflag59
  1759                                  
  1760                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1761                                  
  1762 00002257 A1[C001]                 mov ax, [imme]
  1763 0000225A 3DFF00                   cmp ax, 255
  1764 0000225D 0F8E0900                 jle @@setsflag60
  1765 00002261 68[7522]                 push setsflag_0
  1766 00002264 E83910                   call error1
  1767 00002267 83C402                   add  sp, 2
  1768                                  
  1769                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1770                                  
  1771                                  @@setsflag60:
  1772 0000226A 66B800000000             mov eax, 0
  1773 00002270 A2[BB01]                 mov byte [sflag], al
  1774                                  
  1775                                  ;-127     }
  1776                                  
  1777                                  
  1778                                  ;-128 }
  1779                                  
  1780                                  @@setsflag59:
  1781                                  
  1782                                  ;-129 int checkConstSize(unsigned int ui) {    
  1783 00002273 C9                       LEAVE
  1784 00002274 C3                       ret
  1785                                  ; ENDP
  1786 00002275 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1787 0000227E 6F7220627974652072-
  1788 00002287 2F6D00             
  1789                                  
  1790                                  checkConstSize:  ; *** PROC ***
  1791                                  
  1792                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1793                                  
  1794                                  ;Function : checkConstSize, Number of local variables: 1
  1795                                  ;   # type sign width line used address name   list of local variables
  1796                                  ;  200 var unsg word   129 NULL bp+4    ui;
  1797 0000228A C8000000                 ENTER  0,0
  1798 0000228E 8B4604                   mov ax, [bp+4]
  1799 00002291 83F87F                   cmp ax, 127
  1800 00002294 0F8E0900                 jle @@checkConstSize61
  1801 00002298 66B800000000             mov eax, 0
  1802 0000229E E91C00                   jmp @@retn
  1803                                  
  1804                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1805                                  
  1806                                  @@checkConstSize61:
  1807 000022A1 8B4604                   mov ax, [bp+4]
  1808 000022A4 3D80FF                   cmp ax, 65408
  1809 000022A7 0F8D0900                 jge @@checkConstSize62
  1810 000022AB 66B800000000             mov eax, 0
  1811 000022B1 E90900                   jmp @@retn
  1812                                  
  1813                                  ;-132     return 2;// is short        
  1814                                  
  1815                                  @@checkConstSize62:
  1816 000022B4 66B802000000             mov eax, 2
  1817 000022BA E90000                   jmp @@retn
  1818                                  
  1819                                  ;-133 }
  1820                                  
  1821 000022BD C9                      @@retn: LEAVE
  1822 000022BE C3                       ret
  1823                                  ; ENDP
  1824                                  ;Back to main program: AS.C
  1825                                  
  1826                                  ;-5 #include "PARSE.C"
  1827                                  
  1828                                  ;Use include file: PARSE.C
  1829                                  
  1830                                  ;-1 int parse() {
  1831                                  
  1832                                  
  1833                                  parse:  ; *** PROC ***
  1834                                  
  1835                                  ;-2     LabelNamePtr  = &LabelNames;    
  1836                                  
  1837 000022BF B8[CC01]                 mov ax, LabelNames
  1838 000022C2 A3[B405]                 mov word [LabelNamePtr], ax
  1839                                  
  1840                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1841                                  
  1842 000022C5 B8[8206]                 mov ax, JmpCallNames
  1843 000022C8 A3[520E]                 mov word [JmpCallNamePtr], ax
  1844                                  
  1845                                  ;-4     LabelMaxIx=0;    
  1846                                  
  1847 000022CB 66B800000000             mov eax, 0
  1848 000022D1 A3[7E06]                 mov word [LabelMaxIx], ax
  1849                                  
  1850                                  ;-5     JmpCallMaxIx=0;  
  1851                                  
  1852 000022D4 66B800000000             mov eax, 0
  1853 000022DA A3[3C12]                 mov word [JmpCallMaxIx], ax
  1854                                  
  1855                                  ;-6     BinLen=0;
  1856                                  
  1857 000022DD 66B800000000             mov eax, 0
  1858 000022E3 A3[0E1A]                 mov word [BinLen], ax
  1859                                  
  1860                                  ;-7     
  1861                                  
  1862                                  
  1863                                  ;-8     do {//process a new line
  1864                                  
  1865                                  @@parse63:
  1866                                  
  1867                                  ;-9         PCStart=PC; 
  1868                                  
  1869 000022E6 A1[A601]                 mov ax, [PC]
  1870 000022E9 A3[AA01]                 mov word [PCStart], ax
  1871                                  
  1872                                  ;-10         OpSize=0;
  1873                                  
  1874 000022EC 66B800000000             mov eax, 0
  1875 000022F2 A2[B801]                 mov byte [OpSize], al
  1876                                  
  1877                                  ;-11         OpPrintIndex=0; 
  1878                                  
  1879 000022F5 66B800000000             mov eax, 0
  1880 000022FB A3[C701]                 mov word [OpPrintIndex], ax
  1881                                  
  1882                                  ;-12         PrintRA=' ';
  1883                                  
  1884 000022FE 66B820000000             mov eax, 32
  1885 00002304 A2[CB01]                 mov byte [PrintRA], al
  1886                                  
  1887                                  ;-13         getLine();
  1888                                  
  1889 00002307 E8D505                   call getLine
  1890                                  
  1891                                  ;-14         InputPtr = &InputBuf;
  1892                                  
  1893 0000230A B8[4F00]                 mov ax, InputBuf
  1894 0000230D A3[CE00]                 mov word [InputPtr], ax
  1895                                  
  1896                                  ;-15         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1897                                  
  1898 00002310 E8B800                   call getTokeType
  1899                                  
  1900                                  ;-16         if (TokeType == ALNUME) {
  1901                                  
  1902 00002313 A0[AD01]                 mov al, [TokeType]
  1903 00002316 3C03                     cmp al, 3
  1904 00002318 0F851300                 jne @@parse64
  1905                                  
  1906                                  ;-17             if (isLabel) {//set in getName
  1907                                  
  1908 0000231C A0[AC01]                 mov al, [isLabel]
  1909 0000231F 08C0                     or  al, al
  1910 00002321 0F840A00                 je @@parse65
  1911                                  
  1912                                  ;-18                 storeLabel();
  1913                                  
  1914 00002325 E8C301                   call storeLabel
  1915                                  
  1916                                  ;-19                 InputPtr++;//remove :
  1917                                  
  1918 00002328 FF06[CE00]               inc  word [InputPtr]
  1919                                  
  1920                                  ;-20                 getTokeType();
  1921                                  
  1922 0000232C E89C00                   call getTokeType
  1923                                  
  1924                                  ;-21             }
  1925                                  
  1926                                  
  1927                                  ;-22         }
  1928                                  
  1929                                  @@parse65:
  1930                                  
  1931                                  ;-23         if (TokeType == ALNUME) {
  1932                                  
  1933                                  @@parse64:
  1934 0000232F A0[AD01]                 mov al, [TokeType]
  1935 00002332 3C03                     cmp al, 3
  1936 00002334 0F851B00                 jne @@parse66
  1937                                  
  1938                                  ;-24             lookCode();// and OpCodePtr
  1939                                  
  1940 00002338 E81104                   call lookCode
  1941                                  
  1942                                  ;-25             if(CodeType) process();
  1943                                  
  1944 0000233B A0[B001]                 mov al, [CodeType]
  1945 0000233E 08C0                     or  al, al
  1946 00002340 0F840600                 je @@parse67
  1947 00002344 E82618                   call process
  1948                                  
  1949                                  ;-26             else getVariable();
  1950                                  
  1951 00002347 E90300                   jmp @@parse68
  1952                                  @@parse67:
  1953 0000234A E89F02                   call getVariable
  1954                                  
  1955                                  ;-27             skipRest();
  1956                                  
  1957                                  @@parse68:
  1958 0000234D E86605                   call skipRest
  1959                                  
  1960                                  ;-28         }
  1961                                  
  1962                                  
  1963                                  ;-29         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1964                                  
  1965 00002350 E92700                   jmp @@parse69
  1966                                  @@parse66:
  1967 00002353 A0[AD01]                 mov al, [TokeType]
  1968 00002356 3C03                     cmp al, 3
  1969 00002358 0F8E0C00                 jle @@parse70
  1970 0000235C 68[8B23]                 push parse_0
  1971 0000235F E83E0F                   call error1
  1972 00002362 83C402                   add  sp, 2
  1973                                  
  1974                                  ;-30         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1975                                  
  1976 00002365 E91200                   jmp @@parse71
  1977                                  @@parse70:
  1978 00002368 A0[AD01]                 mov al, [TokeType]
  1979 0000236B 3C01                     cmp al, 1
  1980 0000236D 0F850900                 jne @@parse72
  1981 00002371 68[A923]                 push parse_1
  1982 00002374 E8290F                   call error1
  1983 00002377 83C402                   add  sp, 2
  1984                                  
  1985                                  ;-31         printLine();
  1986                                  
  1987                                  @@parse72:
  1988                                  @@parse71:
  1989                                  @@parse69:
  1990 0000237A E8B50C                   call printLine
  1991                                  
  1992                                  ;-32     } while (DOS_NoBytes != 0 );
  1993                                  
  1994 0000237D A1[A301]                 mov ax, [DOS_NoBytes]
  1995 00002380 83F800                   cmp ax, 0
  1996 00002383 0F840300                 je  @@parse73
  1997 00002387 E95CFF                   jmp @@parse63
  1998                                  @@parse73:
  1999                                  
  2000                                  ;-33 }
  2001                                  
  2002                                  
  2003                                  ;-34 
  2004                                  
  2005                                  
  2006                                  ;-35 int getTokeType() { 
  2007                                  
  2008 0000238A C3                       ret
  2009                                  ; ENDP
  2010 0000238B 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2011 00002394 696E73747275637469-
  2012 0000239D 6F6E20657870656374-
  2013 000023A6 656400             
  2014 000023A9 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2015 000023B2 616C6C6F7765642061-
  2016 000023BB 74207374617274206F-
  2017 000023C4 66206C696E6500     
  2018                                  
  2019                                  getTokeType:  ; *** PROC ***
  2020                                  
  2021                                  ;-36     char c;
  2022                                  
  2023                                  
  2024                                  ;-37     skipBlank();
  2025                                  
  2026                                  ;Function : getTokeType, Number of local variables: 1
  2027                                  ;   # type sign width line used address name   list of local variables
  2028                                  ;  200 var sign byte    36 NULL bp-2    c;
  2029 000023CB C8020000                 ENTER  2,0
  2030 000023CF E80F06                   call skipBlank
  2031                                  
  2032                                  ;-38     c = *InputPtr;
  2033                                  
  2034 000023D2 8B1E[CE00]               mov bx, [InputPtr]
  2035 000023D6 8A07                     mov al, [bx]
  2036 000023D8 B400                     mov ah, 0
  2037 000023DA 8846FE                   mov byte [bp-2], al
  2038                                  
  2039                                  ;-39     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2040                                  
  2041 000023DD 8A46FE                   mov al, [bp-2]
  2042 000023E0 3C00                     cmp al, 0
  2043 000023E2 0F850C00                 jne @@getTokeType74
  2044 000023E6 66B800000000             mov eax, 0
  2045 000023EC A2[AD01]                 mov byte [TokeType], al
  2046 000023EF E97200                   jmp @@retn
  2047                                  
  2048                                  ;-40     if (c == ';') {TokeType=0; return; }//comment
  2049                                  
  2050                                  @@getTokeType74:
  2051 000023F2 8A46FE                   mov al, [bp-2]
  2052 000023F5 3C3B                     cmp al, 59
  2053 000023F7 0F850C00                 jne @@getTokeType75
  2054 000023FB 66B800000000             mov eax, 0
  2055 00002401 A2[AD01]                 mov byte [TokeType], al
  2056 00002404 E95D00                   jmp @@retn
  2057                                  
  2058                                  ;-41     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2059                                  
  2060                                  @@getTokeType75:
  2061 00002407 8A46FE                   mov al, byte [bp-2]
  2062 0000240A B400                     mov ah, 0
  2063 0000240C 50                       push ax
  2064 0000240D E8B41F                   call digit
  2065 00002410 83C402                   add  sp, 2
  2066 00002413 08C0                     or  al, al
  2067 00002415 0F841800                 je @@getTokeType76
  2068 00002419 8A46FE                   mov al, byte [bp-2]
  2069 0000241C B400                     mov ah, 0
  2070 0000241E 50                       push ax
  2071 0000241F E8C506                   call getDigit
  2072 00002422 83C402                   add  sp, 2
  2073 00002425 66B801000000             mov eax, 1
  2074 0000242B A2[AD01]                 mov byte [TokeType], al
  2075 0000242E E93300                   jmp @@retn
  2076                                  
  2077                                  ;-42     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2078                                  
  2079                                  @@getTokeType76:
  2080 00002431 8A46FE                   mov al, byte [bp-2]
  2081 00002434 B400                     mov ah, 0
  2082 00002436 50                       push ax
  2083 00002437 E8D205                   call letterE
  2084 0000243A 83C402                   add  sp, 2
  2085 0000243D 08C0                     or  al, al
  2086 0000243F 0F841800                 je @@getTokeType77
  2087 00002443 8A46FE                   mov al, byte [bp-2]
  2088 00002446 B400                     mov ah, 0
  2089 00002448 50                       push ax
  2090 00002449 E8F206                   call getName
  2091 0000244C 83C402                   add  sp, 2
  2092 0000244F 66B803000000             mov eax, 3
  2093 00002455 A2[AD01]                 mov byte [TokeType], al
  2094 00002458 E90900                   jmp @@retn
  2095                                  
  2096                                  ;-43     TokeType=NOALNUME;
  2097                                  
  2098                                  @@getTokeType77:
  2099 0000245B 66B804000000             mov eax, 4
  2100 00002461 A2[AD01]                 mov byte [TokeType], al
  2101                                  
  2102                                  ;-44 }                     
  2103                                  
  2104                                  
  2105                                  ;-45 
  2106                                  
  2107                                  
  2108                                  ;-46 int storeJmpCall() {
  2109                                  
  2110 00002464 C9                      @@retn: LEAVE
  2111 00002465 C3                       ret
  2112                                  ; ENDP
  2113                                  
  2114                                  storeJmpCall:  ; *** PROC ***
  2115                                  
  2116                                  ;-47     unsigned int i;
  2117                                  
  2118                                  
  2119                                  ;-48     JmpCallMaxIx++;
  2120                                  
  2121                                  ;Function : storeJmpCall, Number of local variables: 1
  2122                                  ;   # type sign width line used address name   list of local variables
  2123                                  ;  200 var unsg word    47 NULL bp-2    i;
  2124 00002466 C8020000                 ENTER  2,0
  2125 0000246A FF06[3C12]               inc  word [JmpCallMaxIx]
  2126                                  
  2127                                  ;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2128                                  
  2129 0000246E A1[3C12]                 mov ax, [JmpCallMaxIx]
  2130 00002471 3DF401                   cmp ax, 500 ;unsigned : 1
  2131 00002474 0F8C0900                 jl  @@storeJmpCall78
  2132 00002478 68[C224]                 push storeJmpCall_0
  2133 0000247B E8810E                   call errorexit
  2134 0000247E 83C402                   add  sp, 2
  2135                                  
  2136                                  ;-50     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2137                                  
  2138                                  @@storeJmpCall78:
  2139 00002481 8D06[0F00]               lea  ax, [Symbol]
  2140 00002485 50                       push ax
  2141 00002486 FF36[520E]               push word [JmpCallNamePtr]
  2142 0000248A E8FE1E                   call strcpy
  2143 0000248D 83C404                   add  sp, 4
  2144 00002490 A3[520E]                 mov word [JmpCallNamePtr], ax
  2145                                  
  2146                                  ;-51     JmpCallNamePtr++;
  2147                                  
  2148 00002493 FF06[520E]               inc  word [JmpCallNamePtr]
  2149                                  
  2150                                  ;-52     i = JmpCallNamePtr - &JmpCallNames;    
  2151                                  
  2152 00002497 A1[520E]                 mov ax, [JmpCallNamePtr]
  2153 0000249A 2D[8206]                 sub ax, JmpCallNames
  2154 0000249D 8946FE                   mov word [bp-2], ax
  2155                                  
  2156                                  ;-53     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2157                                  
  2158 000024A0 8B46FE                   mov ax, [bp-2]
  2159 000024A3 3DB107                   cmp ax, 1969 ;unsigned : 0
  2160 000024A6 0F820900                 jb  @@storeJmpCall79
  2161 000024AA 68[D424]                 push storeJmpCall_1
  2162 000024AD E84F0E                   call errorexit
  2163 000024B0 83C402                   add  sp, 2
  2164                                  
  2165                                  ;-54     JmpCallAddr[JmpCallMaxIx] = PC;   
  2166                                  
  2167                                  @@storeJmpCall79:
  2168 000024B3 A1[A601]                 mov ax, [PC]
  2169 000024B6 8B1E[3C12]               mov bx, [JmpCallMaxIx]
  2170 000024BA D1E3                     shl bx, 1
  2171 000024BC 8987[540E]               mov [JmpCallAddr+bx], ax
  2172                                  
  2173                                  ;-55 }
  2174                                  
  2175                                  
  2176                                  ;-56 
  2177                                  
  2178                                  
  2179                                  ;-57 int storeLabel() {
  2180 000024C0 C9                       LEAVE
  2181 000024C1 C3                       ret
  2182                                  ; ENDP
  2183 000024C2 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2184 000024CB 4A6D7043616C6C7300 
  2185 000024D4 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2186 000024DD 4A6D7043616C6C206E-
  2187 000024E6 616D657300         
  2188                                  
  2189                                  storeLabel:  ; *** PROC ***
  2190                                  
  2191                                  ;-58     unsigned int i;
  2192                                  
  2193                                  
  2194                                  ;-59     LabelMaxIx++;
  2195                                  
  2196                                  ;Function : storeLabel, Number of local variables: 1
  2197                                  ;   # type sign width line used address name   list of local variables
  2198                                  ;  200 var unsg word    58 NULL bp-2    i;
  2199 000024EB C8020000                 ENTER  2,0
  2200 000024EF FF06[7E06]               inc  word [LabelMaxIx]
  2201                                  
  2202                                  ;-60     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2203                                  
  2204 000024F3 A1[7E06]                 mov ax, [LabelMaxIx]
  2205 000024F6 83F864                   cmp ax, 100 ;unsigned : 1
  2206 000024F9 0F8C0900                 jl  @@storeLabel80
  2207 000024FD 68[5D25]                 push storeLabel_0
  2208 00002500 E8FC0D                   call errorexit
  2209 00002503 83C402                   add  sp, 2
  2210                                  
  2211                                  ;-61     if(searchLabel()) error1("duplicate label");
  2212                                  
  2213                                  @@storeLabel80:
  2214 00002506 E88900                   call searchLabel
  2215 00002509 08C0                     or  al, al
  2216 0000250B 0F840900                 je @@storeLabel81
  2217 0000250F 68[6D25]                 push storeLabel_1
  2218 00002512 E88B0D                   call error1
  2219 00002515 83C402                   add  sp, 2
  2220                                  
  2221                                  ;-62     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2222                                  
  2223                                  @@storeLabel81:
  2224 00002518 8D06[0F00]               lea  ax, [Symbol]
  2225 0000251C 50                       push ax
  2226 0000251D FF36[B405]               push word [LabelNamePtr]
  2227 00002521 E8671E                   call strcpy
  2228 00002524 83C404                   add  sp, 4
  2229 00002527 A3[B405]                 mov word [LabelNamePtr], ax
  2230                                  
  2231                                  ;-63     LabelNamePtr++;
  2232                                  
  2233 0000252A FF06[B405]               inc  word [LabelNamePtr]
  2234                                  
  2235                                  ;-64     i = LabelNamePtr - &LabelNames;
  2236                                  
  2237 0000252E A1[B405]                 mov ax, [LabelNamePtr]
  2238 00002531 2D[CC01]                 sub ax, LabelNames
  2239 00002534 8946FE                   mov word [bp-2], ax
  2240                                  
  2241                                  ;-65     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2242                                  
  2243 00002537 8B46FE                   mov ax, [bp-2]
  2244 0000253A 3DC903                   cmp ax, 969 ;unsigned : 0
  2245 0000253D 0F820900                 jb  @@storeLabel82
  2246 00002541 68[7D25]                 push storeLabel_2
  2247 00002544 E8B80D                   call errorexit
  2248 00002547 83C402                   add  sp, 2
  2249                                  
  2250                                  ;-66     LabelAddr[LabelMaxIx] = PC + Origin;
  2251                                  
  2252                                  @@storeLabel82:
  2253 0000254A A1[A601]                 mov ax, [PC]
  2254 0000254D 0306[A801]               add ax, [Origin]
  2255 00002551 8B1E[7E06]               mov bx, [LabelMaxIx]
  2256 00002555 D1E3                     shl bx, 1
  2257 00002557 8987[B605]               mov [LabelAddr+bx], ax
  2258                                  
  2259                                  ;-67 }   
  2260                                  
  2261                                  
  2262                                  ;-68 
  2263                                  
  2264                                  
  2265                                  ;-69 int searchLabel() {
  2266 0000255B C9                       LEAVE
  2267 0000255C C3                       ret
  2268                                  ; ENDP
  2269 0000255D 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2270 00002566 6C6162656C7300     
  2271 0000256D 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2272 00002576 206C6162656C00     
  2273 0000257D 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2274 00002586 6C6162656C206E616D-
  2275 0000258F 657300             
  2276                                  
  2277                                  searchLabel:  ; *** PROC ***
  2278                                  
  2279                                  ;-70     int LIx; char *p;
  2280                                  
  2281                                  
  2282                                  ;-71     p = &LabelNames;
  2283                                  
  2284                                  ;Function : searchLabel, Number of local variables: 2
  2285                                  ;   # type sign width line used address name   list of local variables
  2286                                  ;  200 var sign word    70 NULL bp-2    LIx
  2287                                  ;  201 ptr sign byte    70 NULL bp-4    p;
  2288 00002592 C8040000                 ENTER  4,0
  2289 00002596 B8[CC01]                 mov ax, LabelNames
  2290 00002599 8946FC                   mov word [bp-4], ax
  2291                                  
  2292                                  ;-72     LIx = 1;
  2293                                  
  2294 0000259C 66B801000000             mov eax, 1
  2295 000025A2 8946FE                   mov word [bp-2], ax
  2296                                  
  2297                                  ;-73     while (LIx <= LabelMaxIx) {
  2298                                  
  2299                                  @@searchLabel83:
  2300 000025A5 8B46FE                   mov ax, [bp-2]
  2301 000025A8 3B06[7E06]               cmp ax, [LabelMaxIx]
  2302 000025AC 0F8F3100                 jg  @@searchLabel84
  2303                                  
  2304                                  ;-74         if (eqstr(p, Symbol)) return LIx;//pos of label                    
  2305                                  
  2306 000025B0 8D06[0F00]               lea  ax, [Symbol]
  2307 000025B4 50                       push ax
  2308 000025B5 FF76FC                   push word [bp-4]
  2309 000025B8 E83C1E                   call eqstr
  2310 000025BB 83C404                   add  sp, 4
  2311 000025BE 08C0                     or  al, al
  2312 000025C0 0F840600                 je @@searchLabel85
  2313 000025C4 8B46FE                   mov ax, [bp-2]
  2314 000025C7 E92000                   jmp @@retn
  2315                                  
  2316                                  ;-75         p=strlen(p) + p;                  
  2317                                  
  2318                                  @@searchLabel85:
  2319 000025CA FF76FC                   push word [bp-4]
  2320 000025CD E8901D                   call strlen
  2321 000025D0 83C402                   add  sp, 2
  2322 000025D3 0346FC                   add ax, [bp-4]
  2323 000025D6 8946FC                   mov word [bp-4], ax
  2324                                  
  2325                                  ;-76         p++; 
  2326                                  
  2327 000025D9 FF46FC                   inc  word [bp-4]
  2328                                  
  2329                                  ;-77         LIx++;
  2330                                  
  2331 000025DC FF46FE                   inc  word [bp-2]
  2332                                  
  2333                                  ;-78     }
  2334                                  
  2335                                  
  2336                                  ;-79     return 0;
  2337                                  
  2338 000025DF EBC4                     jmp @@searchLabel83
  2339                                  @@searchLabel84:
  2340 000025E1 66B800000000             mov eax, 0
  2341 000025E7 E90000                   jmp @@retn
  2342                                  
  2343                                  ;-80 }   
  2344                                  
  2345                                  
  2346                                  ;-81 
  2347                                  
  2348                                  
  2349                                  ;-82 int getVariable() { 
  2350                                  
  2351 000025EA C9                      @@retn: LEAVE
  2352 000025EB C3                       ret
  2353                                  ; ENDP
  2354                                  
  2355                                  getVariable:  ; *** PROC ***
  2356                                  
  2357                                  ;-83     char c; unsigned int i;
  2358                                  
  2359                                  
  2360                                  ;-84     storeLabel();
  2361                                  
  2362                                  ;Function : getVariable, Number of local variables: 2
  2363                                  ;   # type sign width line used address name   list of local variables
  2364                                  ;  200 var sign byte    83 NULL bp-2    c
  2365                                  ;  201 var unsg word    83 NULL bp-4    i;
  2366 000025EC C8040000                 ENTER  4,0
  2367 000025F0 E8F8FE                   call storeLabel
  2368                                  
  2369                                  ;-85     getTokeType(); 
  2370                                  
  2371 000025F3 E8D5FD                   call getTokeType
  2372                                  
  2373                                  ;-86     if(TokeType==ALNUME) {//getName
  2374                                  
  2375 000025F6 A0[AD01]                 mov al, [TokeType]
  2376 000025F9 3C03                     cmp al, 3
  2377 000025FB 0F854801                 jne @@getVariable86
  2378                                  
  2379                                  ;-87         lookCode();
  2380                                  
  2381 000025FF E84A01                   call lookCode
  2382                                  
  2383                                  ;-88         if (CodeType < 200) dataexit();
  2384                                  
  2385 00002602 A0[B001]                 mov al, [CodeType]
  2386 00002605 3CC8                     cmp al, 200
  2387 00002607 0F8D0300                 jge @@getVariable87
  2388 0000260B E87C0E                   call dataexit
  2389                                  
  2390                                  ;-89         if (CodeType > 205) dataexit();
  2391                                  
  2392                                  @@getVariable87:
  2393 0000260E A0[B001]                 mov al, [CodeType]
  2394 00002611 3CCD                     cmp al, 205
  2395 00002613 0F8E0300                 jle @@getVariable88
  2396 00002617 E8700E                   call dataexit
  2397                                  
  2398                                  ;-90         if (CodeType== 200) {//DB
  2399                                  
  2400                                  @@getVariable88:
  2401 0000261A A0[B001]                 mov al, [CodeType]
  2402 0000261D 3CC8                     cmp al, 200
  2403 0000261F 0F856A00                 jne @@getVariable89
  2404                                  
  2405                                  ;-91             do { 
  2406                                  
  2407                                  @@getVariable90:
  2408                                  
  2409                                  ;-92                 getTokeType();
  2410                                  
  2411 00002623 E8A5FD                   call getTokeType
  2412                                  
  2413                                  ;-93                 if (TokeType == DIGIT) genCode8(SymbolInt);
  2414                                  
  2415 00002626 A0[AD01]                 mov al, [TokeType]
  2416 00002629 3C01                     cmp al, 1
  2417 0000262B 0F850D00                 jne @@getVariable91
  2418 0000262F FF36[4D00]               push word [SymbolInt]
  2419 00002633 E88913                   call genCode8
  2420 00002636 83C402                   add  sp, 2
  2421                                  
  2422                                  ;-94                 else {
  2423                                  
  2424 00002639 E94100                   jmp @@getVariable92
  2425                                  @@getVariable91:
  2426                                  
  2427                                  ;-95                     skipBlank();
  2428                                  
  2429 0000263C E8A203                   call skipBlank
  2430                                  
  2431                                  ;-96                     if (isToken('"')) {
  2432                                  
  2433 0000263F 6A22                     push 34
  2434 00002641 E80502                   call isToken
  2435 00002644 83C402                   add  sp, 2
  2436 00002647 08C0                     or  al, al
  2437 00002649 0F843000                 je @@getVariable93
  2438                                  
  2439                                  ;-97                         do { 
  2440                                  
  2441                                  @@getVariable94:
  2442                                  
  2443                                  ;-98                             c= *InputPtr;
  2444                                  
  2445 0000264D 8B1E[CE00]               mov bx, [InputPtr]
  2446 00002651 8A07                     mov al, [bx]
  2447 00002653 B400                     mov ah, 0
  2448 00002655 8846FE                   mov byte [bp-2], al
  2449                                  
  2450                                  ;-99                             genCode8(c);
  2451                                  
  2452 00002658 8A46FE                   mov al, byte [bp-2]
  2453 0000265B B400                     mov ah, 0
  2454 0000265D 50                       push ax
  2455 0000265E E85E13                   call genCode8
  2456 00002661 83C402                   add  sp, 2
  2457                                  
  2458                                  ;-100                             InputPtr++;
  2459                                  
  2460 00002664 FF06[CE00]               inc  word [InputPtr]
  2461                                  
  2462                                  ;-101                         } while (*InputPtr != '"' );
  2463                                  
  2464 00002668 8B1E[CE00]               mov bx, [InputPtr]
  2465 0000266C 8A07                     mov al, [bx]
  2466 0000266E B400                     mov ah, 0
  2467 00002670 83F822                   cmp ax, 34
  2468 00002673 0F840200                 je  @@getVariable95
  2469 00002677 EBD4                     jmp @@getVariable94
  2470                                  @@getVariable95:
  2471                                  
  2472                                  ;-102                         InputPtr++;
  2473                                  
  2474 00002679 FF06[CE00]               inc  word [InputPtr]
  2475                                  
  2476                                  ;-103                     }
  2477                                  
  2478                                  
  2479                                  ;-104                 }
  2480                                  
  2481                                  @@getVariable93:
  2482                                  
  2483                                  ;-105             } while (isToken(','));
  2484                                  
  2485                                  @@getVariable92:
  2486 0000267D 6A2C                     push 44
  2487 0000267F E8C701                   call isToken
  2488 00002682 83C402                   add  sp, 2
  2489 00002685 08C0                     or  al, al
  2490 00002687 0F840200                 je @@getVariable96
  2491 0000268B EB96                     jmp @@getVariable90
  2492                                  @@getVariable96:
  2493                                  
  2494                                  ;-106         }
  2495                                  
  2496                                  
  2497                                  ;-107         if (CodeType== 201) {//DW
  2498                                  
  2499                                  @@getVariable89:
  2500 0000268D A0[B001]                 mov al, [CodeType]
  2501 00002690 3CC9                     cmp al, 201
  2502 00002692 0F852600                 jne @@getVariable97
  2503                                  
  2504                                  ;-108             do { 
  2505                                  
  2506                                  @@getVariable98:
  2507                                  
  2508                                  ;-109                 getTokeType();
  2509                                  
  2510 00002696 E832FD                   call getTokeType
  2511                                  
  2512                                  ;-110                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2513                                  
  2514 00002699 A0[AD01]                 mov al, [TokeType]
  2515 0000269C 3C01                     cmp al, 1
  2516 0000269E 0F850A00                 jne @@getVariable99
  2517 000026A2 FF36[4D00]               push word [SymbolInt]
  2518 000026A6 E86D13                   call genCode16
  2519 000026A9 83C402                   add  sp, 2
  2520                                  
  2521                                  ;-111             } while (isToken(','));
  2522                                  
  2523                                  @@getVariable99:
  2524 000026AC 6A2C                     push 44
  2525 000026AE E89801                   call isToken
  2526 000026B1 83C402                   add  sp, 2
  2527 000026B4 08C0                     or  al, al
  2528 000026B6 0F840200                 je @@getVariable100
  2529 000026BA EBDA                     jmp @@getVariable98
  2530                                  @@getVariable100:
  2531                                  
  2532                                  ;-112         } 
  2533                                  
  2534                                  
  2535                                  ;-113         if (CodeType == 202) implerror();
  2536                                  
  2537                                  @@getVariable97:
  2538 000026BC A0[B001]                 mov al, [CodeType]
  2539 000026BF 3CCA                     cmp al, 202
  2540 000026C1 0F850300                 jne @@getVariable101
  2541 000026C5 E8A80C                   call implerror
  2542                                  
  2543                                  ;-114         if (CodeType >= 203) {//resb, resw, resd
  2544                                  
  2545                                  @@getVariable101:
  2546 000026C8 A0[B001]                 mov al, [CodeType]
  2547 000026CB 3CCB                     cmp al, 203 ;unsigned : 1
  2548 000026CD 0F8C7300                 jl  @@getVariable102
  2549                                  
  2550                                  ;-115             getTokeType();
  2551                                  
  2552 000026D1 E8F7FC                   call getTokeType
  2553                                  
  2554                                  ;-116             if (TokeType == DIGIT) {
  2555                                  
  2556 000026D4 A0[AD01]                 mov al, [TokeType]
  2557 000026D7 3C01                     cmp al, 1
  2558 000026D9 0F856400                 jne @@getVariable103
  2559                                  
  2560                                  ;-117                 i=0;  
  2561                                  
  2562 000026DD 66B800000000             mov eax, 0
  2563 000026E3 8946FC                   mov word [bp-4], ax
  2564                                  
  2565                                  ;-118                 if (SymbolInt <= 0) syntaxerror();
  2566                                  
  2567 000026E6 A1[4D00]                 mov ax, [SymbolInt]
  2568 000026E9 83F800                   cmp ax, 0
  2569 000026EC 0F870300                 ja  @@getVariable104
  2570 000026F0 E86C0D                   call syntaxerror
  2571                                  
  2572                                  ;-119                 do {
  2573                                  
  2574                                  @@getVariable104:
  2575                                  @@getVariable105:
  2576                                  
  2577                                  ;-120                     if (CodeType == 203) genCode8(0);
  2578                                  
  2579 000026F3 A0[B001]                 mov al, [CodeType]
  2580 000026F6 3CCB                     cmp al, 203
  2581 000026F8 0F850800                 jne @@getVariable106
  2582 000026FC 6A00                     push 0
  2583 000026FE E8BE12                   call genCode8
  2584 00002701 83C402                   add  sp, 2
  2585                                  
  2586                                  ;-121                     if (CodeType == 204) genCode16(0);
  2587                                  
  2588                                  @@getVariable106:
  2589 00002704 A0[B001]                 mov al, [CodeType]
  2590 00002707 3CCC                     cmp al, 204
  2591 00002709 0F850800                 jne @@getVariable107
  2592 0000270D 6A00                     push 0
  2593 0000270F E80413                   call genCode16
  2594 00002712 83C402                   add  sp, 2
  2595                                  
  2596                                  ;-122                     if (CodeType == 205) {genCode16(0);genCode16(0);}    
  2597                                  
  2598                                  @@getVariable107:
  2599 00002715 A0[B001]                 mov al, [CodeType]
  2600 00002718 3CCD                     cmp al, 205
  2601 0000271A 0F851000                 jne @@getVariable108
  2602 0000271E 6A00                     push 0
  2603 00002720 E8F312                   call genCode16
  2604 00002723 83C402                   add  sp, 2
  2605 00002726 6A00                     push 0
  2606 00002728 E8EB12                   call genCode16
  2607 0000272B 83C402                   add  sp, 2
  2608                                  
  2609                                  ;-123                     i++;
  2610                                  
  2611                                  @@getVariable108:
  2612 0000272E FF46FC                   inc  word [bp-4]
  2613                                  
  2614                                  ;-124                 } while (i < SymbolInt);   
  2615                                  
  2616 00002731 8B46FC                   mov ax, [bp-4]
  2617 00002734 3B06[4D00]               cmp ax, [SymbolInt]
  2618 00002738 0F8D0200                 jge @@getVariable109
  2619 0000273C EBB5                     jmp @@getVariable105
  2620                                  @@getVariable109:
  2621                                  
  2622                                  ;-125             } else numbererror();  
  2623                                  
  2624 0000273E E90300                   jmp @@getVariable110
  2625                                  @@getVariable103:
  2626 00002741 E8880C                   call numbererror
  2627                                  
  2628                                  ;-126         }    
  2629                                  
  2630                                  @@getVariable110:
  2631                                  
  2632                                  ;-127     }
  2633                                  
  2634                                  @@getVariable102:
  2635                                  
  2636                                  ;-128     else dataexit();
  2637                                  
  2638 00002744 E90300                   jmp @@getVariable111
  2639                                  @@getVariable86:
  2640 00002747 E8400D                   call dataexit
  2641                                  
  2642                                  ;-129 }
  2643                                  
  2644                                  @@getVariable111:
  2645                                  
  2646                                  ;-130 
  2647                                  
  2648                                  
  2649                                  ;-131 int lookCode() {//ret: CodeType, *OpCodePtr
  2650 0000274A C9                       LEAVE
  2651 0000274B C3                       ret
  2652                                  ; ENDP
  2653                                  
  2654                                  lookCode:  ; *** PROC ***
  2655                                  
  2656                                  ;-132     CodeType=0;
  2657                                  
  2658 0000274C 66B800000000             mov eax, 0
  2659 00002752 A2[B001]                 mov byte [CodeType], al
  2660                                  
  2661                                  ;-133     OpCodePtr= &I_START;
  2662                                  
  2663 00002755 B8[141A]                 mov ax, I_START
  2664 00002758 A3[C901]                 mov word [OpCodePtr], ax
  2665                                  
  2666                                  ;-134     OpCodePtr++;
  2667                                  
  2668 0000275B FF06[C901]               inc  word [OpCodePtr]
  2669                                  
  2670                                  ;-135     do  {
  2671                                  
  2672                                  @@lookCode112:
  2673                                  
  2674                                  ;-136         if (eqstr(SymbolUpper, OpCodePtr))  {
  2675                                  
  2676 0000275F FF36[C901]               push word [OpCodePtr]
  2677 00002763 8D06[2E00]               lea  ax, [SymbolUpper]
  2678 00002767 50                       push ax
  2679 00002768 E88C1C                   call eqstr
  2680 0000276B 83C404                   add  sp, 4
  2681 0000276E 08C0                     or  al, al
  2682 00002770 0F842700                 je @@lookCode113
  2683                                  
  2684                                  ;-137             while(*OpCodePtr!=0) OpCodePtr++;
  2685                                  
  2686                                  @@lookCode114:
  2687 00002774 8B1E[C901]               mov bx, [OpCodePtr]
  2688 00002778 8A07                     mov al, [bx]
  2689 0000277A B400                     mov ah, 0
  2690 0000277C 83F800                   cmp ax, 0
  2691 0000277F 0F840600                 je  @@lookCode115
  2692 00002783 FF06[C901]               inc  word [OpCodePtr]
  2693                                  
  2694                                  ;-138             OpCodePtr++; 
  2695                                  
  2696 00002787 EBEB                     jmp @@lookCode114
  2697                                  @@lookCode115:
  2698 00002789 FF06[C901]               inc  word [OpCodePtr]
  2699                                  
  2700                                  ;-139             CodeType =*OpCodePtr;
  2701                                  
  2702 0000278D 8B1E[C901]               mov bx, [OpCodePtr]
  2703 00002791 8A07                     mov al, [bx]
  2704 00002793 B400                     mov ah, 0
  2705 00002795 A2[B001]                 mov byte [CodeType], al
  2706                                  
  2707                                  ;-140             return;
  2708                                  
  2709 00002798 E92A00                   jmp @@retn
  2710                                  
  2711                                  ;-141         }
  2712                                  
  2713                                  
  2714                                  ;-142     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2715                                  
  2716                                  @@lookCode113:
  2717                                  @@lookCode116:
  2718 0000279B 8B1E[C901]               mov bx, [OpCodePtr]
  2719 0000279F 8A07                     mov al, [bx]
  2720 000027A1 B400                     mov ah, 0
  2721 000027A3 3DF100                   cmp ax, 241
  2722 000027A6 0F840600                 je  @@lookCode117
  2723 000027AA FF06[C901]               inc  word [OpCodePtr]
  2724                                  
  2725                                  ;-143     OpCodePtr++;
  2726                                  
  2727 000027AE EBEB                     jmp @@lookCode116
  2728                                  @@lookCode117:
  2729 000027B0 FF06[C901]               inc  word [OpCodePtr]
  2730                                  
  2731                                  ;-144     } while(*OpCodePtr!=0);
  2732                                  
  2733 000027B4 8B1E[C901]               mov bx, [OpCodePtr]
  2734 000027B8 8A07                     mov al, [bx]
  2735 000027BA B400                     mov ah, 0
  2736 000027BC 83F800                   cmp ax, 0
  2737 000027BF 0F840200                 je  @@lookCode118
  2738 000027C3 EB9A                     jmp @@lookCode112
  2739                                  @@lookCode118:
  2740                                  
  2741                                  ;-145 }
  2742                                  
  2743                                  
  2744                                  ;-146 
  2745                                  
  2746                                  
  2747                                  ;-147 int getCodeSize() {
  2748                                  
  2749                                  @@retn:
  2750 000027C5 C3                       ret
  2751                                  ; ENDP
  2752                                  
  2753                                  getCodeSize:  ; *** PROC ***
  2754                                  
  2755                                  ;-148     if (TokeType ==ALNUME) {
  2756                                  
  2757 000027C6 A0[AD01]                 mov al, [TokeType]
  2758 000027C9 3C03                     cmp al, 3
  2759 000027CB 0F856000                 jne @@getCodeSize119
  2760                                  
  2761                                  ;-149         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2762                                  
  2763 000027CF 68[3928]                 push getCodeSize_0
  2764 000027D2 8D06[2E00]               lea  ax, [SymbolUpper]
  2765 000027D6 50                       push ax
  2766 000027D7 E81D1C                   call eqstr
  2767 000027DA 83C404                   add  sp, 4
  2768 000027DD 08C0                     or  al, al
  2769 000027DF 0F840C00                 je @@getCodeSize120
  2770 000027E3 E8E5FB                   call getTokeType
  2771 000027E6 66B801000000             mov eax, 1
  2772 000027EC E94900                   jmp @@retn
  2773                                  
  2774                                  ;-150         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2775                                  
  2776                                  @@getCodeSize120:
  2777 000027EF 68[3E28]                 push getCodeSize_1
  2778 000027F2 8D06[2E00]               lea  ax, [SymbolUpper]
  2779 000027F6 50                       push ax
  2780 000027F7 E8FD1B                   call eqstr
  2781 000027FA 83C404                   add  sp, 4
  2782 000027FD 08C0                     or  al, al
  2783 000027FF 0F840C00                 je @@getCodeSize121
  2784 00002803 E8C5FB                   call getTokeType
  2785 00002806 66B802000000             mov eax, 2
  2786 0000280C E92900                   jmp @@retn
  2787                                  
  2788                                  ;-151         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2789                                  
  2790                                  @@getCodeSize121:
  2791 0000280F 68[4328]                 push getCodeSize_2
  2792 00002812 8D06[2E00]               lea  ax, [SymbolUpper]
  2793 00002816 50                       push ax
  2794 00002817 E8DD1B                   call eqstr
  2795 0000281A 83C404                   add  sp, 4
  2796 0000281D 08C0                     or  al, al
  2797 0000281F 0F840C00                 je @@getCodeSize122
  2798 00002823 E8A5FB                   call getTokeType
  2799 00002826 66B803000000             mov eax, 3
  2800 0000282C E90900                   jmp @@retn
  2801                                  
  2802                                  ;-152     } 
  2803                                  
  2804                                  @@getCodeSize122:
  2805                                  
  2806                                  ;-153     return 0;
  2807                                  
  2808                                  @@getCodeSize119:
  2809 0000282F 66B800000000             mov eax, 0
  2810 00002835 E90000                   jmp @@retn
  2811                                  
  2812                                  ;-154 }
  2813                                  
  2814                                  
  2815                                  ;-155 int isToken(char c) {
  2816                                  
  2817                                  @@retn:
  2818 00002838 C3                       ret
  2819                                  ; ENDP
  2820 00002839 4259544500              getCodeSize_0 db "BYTE",0
  2821 0000283E 574F524400              getCodeSize_1 db "WORD",0
  2822 00002843 44574F524400            getCodeSize_2 db "DWORD",0
  2823                                  
  2824                                  isToken:  ; *** PROC ***
  2825                                  
  2826                                  ;-156     skipBlank();
  2827                                  
  2828                                  ;Function : isToken, Number of local variables: 1
  2829                                  ;   # type sign width line used address name   list of local variables
  2830                                  ;  200 var sign byte   155 NULL bp+4    c;
  2831 00002849 C8000000                 ENTER  0,0
  2832 0000284D E89101                   call skipBlank
  2833                                  
  2834                                  ;-157     if (*InputPtr == c) {
  2835                                  
  2836 00002850 8B1E[CE00]               mov bx, [InputPtr]
  2837 00002854 8A07                     mov al, [bx]
  2838 00002856 B400                     mov ah, 0
  2839 00002858 3A4604                   cmp al, [bp+4]
  2840 0000285B 0F850D00                 jne @@isToken123
  2841                                  
  2842                                  ;-158         InputPtr++; 
  2843                                  
  2844 0000285F FF06[CE00]               inc  word [InputPtr]
  2845                                  
  2846                                  ;-159         return 1;
  2847                                  
  2848 00002863 66B801000000             mov eax, 1
  2849 00002869 E90900                   jmp @@retn
  2850                                  
  2851                                  ;-160         } 
  2852                                  
  2853                                  
  2854                                  ;-161     return 0;
  2855                                  
  2856                                  @@isToken123:
  2857 0000286C 66B800000000             mov eax, 0
  2858 00002872 E90000                   jmp @@retn
  2859                                  
  2860                                  ;-162 }
  2861                                  
  2862                                  
  2863                                  ;-163 int need(char c) {
  2864                                  
  2865 00002875 C9                      @@retn: LEAVE
  2866 00002876 C3                       ret
  2867                                  ; ENDP
  2868                                  
  2869                                  need:  ; *** PROC ***
  2870                                  
  2871                                  ;-164     if (isToken(c)) {
  2872                                  
  2873                                  ;Function : need, Number of local variables: 1
  2874                                  ;   # type sign width line used address name   list of local variables
  2875                                  ;  200 var sign byte   163 NULL bp+4    c;
  2876 00002877 C8000000                 ENTER  0,0
  2877 0000287B 8A4604                   mov al, byte [bp+4]
  2878 0000287E B400                     mov ah, 0
  2879 00002880 50                       push ax
  2880 00002881 E8C5FF                   call isToken
  2881 00002884 83C402                   add  sp, 2
  2882 00002887 08C0                     or  al, al
  2883 00002889 0F840600                 je @@need124
  2884                                  
  2885                                  ;-165         getTokeType();
  2886                                  
  2887 0000288D E83BFB                   call getTokeType
  2888                                  
  2889                                  ;-166         return;
  2890                                  
  2891 00002890 E91800                   jmp @@retn
  2892                                  
  2893                                  ;-167         }
  2894                                  
  2895                                  
  2896                                  ;-168     error1();
  2897                                  
  2898                                  @@need124:
  2899 00002893 E80A0A                   call error1
  2900                                  
  2901                                  ;-169     prs(". need: ");
  2902                                  
  2903 00002896 68[AD28]                 push need_0
  2904 00002899 E8A308                   call prs
  2905 0000289C 83C402                   add  sp, 2
  2906                                  
  2907                                  ;-170     prc(c);
  2908                                  
  2909 0000289F 8A4604                   mov al, byte [bp+4]
  2910 000028A2 B400                     mov ah, 0
  2911 000028A4 50                       push ax
  2912 000028A5 E83608                   call prc
  2913 000028A8 83C402                   add  sp, 2
  2914                                  
  2915                                  ;-171 }
  2916                                  
  2917                                  
  2918                                  ;-172 int skipRest() {
  2919                                  
  2920 000028AB C9                      @@retn: LEAVE
  2921 000028AC C3                       ret
  2922                                  ; ENDP
  2923 000028AD 2E206E6565643A2000      need_0 db ". need: ",0
  2924                                  
  2925                                  skipRest:  ; *** PROC ***
  2926                                  
  2927                                  ;-173     getTokeType(); 
  2928                                  
  2929 000028B6 E812FB                   call getTokeType
  2930                                  
  2931                                  ;-174     if(TokeType)error1("extra char ignored");
  2932                                  
  2933 000028B9 A0[AD01]                 mov al, [TokeType]
  2934 000028BC 08C0                     or  al, al
  2935 000028BE 0F840900                 je @@skipRest125
  2936 000028C2 68[CC28]                 push skipRest_0
  2937 000028C5 E8D809                   call error1
  2938 000028C8 83C402                   add  sp, 2
  2939                                  
  2940                                  ;-175 }
  2941                                  
  2942                                  @@skipRest125:
  2943 000028CB C3                       ret
  2944                                  ; ENDP
  2945 000028CC 657874726120636861-     skipRest_0 db "extra char ignored",0
  2946 000028D5 722069676E6F726564-
  2947 000028DE 00                 
  2948                                  ;Back to main program: AS.C
  2949                                  
  2950                                  ;-6 #include "HELPER.C"
  2951                                  
  2952                                  ;Use include file: HELPER.C
  2953                                  
  2954                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2955                                  
  2956                                  
  2957                                  getLine:  ; *** PROC ***
  2958                                  
  2959                                  ;-2   unsigned int i;
  2960                                  
  2961                                  
  2962                                  ;-3   InputPtr= &InputBuf;
  2963                                  
  2964                                  ;Function : getLine, Number of local variables: 1
  2965                                  ;   # type sign width line used address name   list of local variables
  2966                                  ;  200 var unsg word     2 NULL bp-2    i;
  2967 000028DF C8020000                 ENTER  2,0
  2968 000028E3 B8[4F00]                 mov ax, InputBuf
  2969 000028E6 A3[CE00]                 mov word [InputPtr], ax
  2970                                  
  2971                                  ;-4   *InputPtr=0;//if last line is empty
  2972                                  
  2973 000028E9 66B800000000             mov eax, 0
  2974 000028EF 8B1E[CE00]               mov  bx, [InputPtr]
  2975 000028F3 8807                     mov  [bx], al
  2976                                  
  2977                                  ;-5   do {
  2978                                  
  2979                                  @@getLine126:
  2980                                  
  2981                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2982                                  
  2983 000028F5 6A01                     push 1
  2984 000028F7 FF36[9901]               push word [asm_fd]
  2985 000028FB 8D06[A501]               lea  ax, [DOS_ByteRead]
  2986 000028FF 50                       push ax
  2987 00002900 E88F1B                   call readRL
  2988 00002903 83C406                   add  sp, 6
  2989 00002906 A3[A301]                 mov word [DOS_NoBytes], ax
  2990                                  
  2991                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2992                                  
  2993 00002909 A1[9F01]                 mov ax, [DOS_ERR]
  2994 0000290C 08C0                     or  al, al
  2995 0000290E 0F840900                 je @@getLine127
  2996 00002912 68[7729]                 push getLine_0
  2997 00002915 E8E709                   call errorexit
  2998 00002918 83C402                   add  sp, 2
  2999                                  
  3000                                  ;-8     if (DOS_NoBytes == 0) return;
  3001                                  
  3002                                  @@getLine127:
  3003 0000291B A1[A301]                 mov ax, [DOS_NoBytes]
  3004 0000291E 83F800                   cmp ax, 0
  3005 00002921 0F850300                 jne @@getLine128
  3006 00002925 E94D00                   jmp @@retn
  3007                                  
  3008                                  ;-9     *InputPtr = DOS_ByteRead;
  3009                                  
  3010                                  @@getLine128:
  3011 00002928 A0[A501]                 mov al, [DOS_ByteRead]
  3012 0000292B 8B1E[CE00]               mov  bx, [InputPtr]
  3013 0000292F 8807                     mov  [bx], al
  3014                                  
  3015                                  ;-10     InputPtr++;
  3016                                  
  3017 00002931 FF06[CE00]               inc  word [InputPtr]
  3018                                  
  3019                                  ;-11     i = InputPtr - &InputBuf;
  3020                                  
  3021 00002935 A1[CE00]                 mov ax, [InputPtr]
  3022 00002938 2D[4F00]                 sub ax, InputBuf
  3023 0000293B 8946FE                   mov word [bp-2], ax
  3024                                  
  3025                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  3026                                  
  3027 0000293E 8B46FE                   mov ax, [bp-2]
  3028 00002941 83F87F                   cmp ax, 127 ;unsigned : 0
  3029 00002944 0F820900                 jb  @@getLine129
  3030 00002948 68[8629]                 push getLine_1
  3031 0000294B E8B109                   call errorexit
  3032 0000294E 83C402                   add  sp, 2
  3033                                  
  3034                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  3035                                  
  3036                                  @@getLine129:
  3037 00002951 A0[A501]                 mov al, byte [DOS_ByteRead]
  3038 00002954 B400                     mov ah, 0
  3039 00002956 50                       push ax
  3040 00002957 E84000                   call ifEOL
  3041 0000295A 83C402                   add  sp, 2
  3042 0000295D 3C00                     cmp al, 0
  3043 0000295F 0F850200                 jne @@getLine130
  3044 00002963 EB90                     jmp @@getLine126
  3045                                  @@getLine130:
  3046                                  
  3047                                  ;-14   InputPtr--;
  3048                                  
  3049 00002965 FF0E[CE00]               dec  word [InputPtr]
  3050                                  
  3051                                  ;-15   *InputPtr=0;
  3052                                  
  3053 00002969 66B800000000             mov eax, 0
  3054 0000296F 8B1E[CE00]               mov  bx, [InputPtr]
  3055 00002973 8807                     mov  [bx], al
  3056                                  
  3057                                  ;-16 }
  3058                                  
  3059                                  
  3060                                  ;-17 int ifEOL(char c) {
  3061                                  
  3062 00002975 C9                      @@retn: LEAVE
  3063 00002976 C3                       ret
  3064                                  ; ENDP
  3065 00002977 52656164696E672053-     getLine_0 db "Reading Source",0
  3066 00002980 6F7572636500       
  3067 00002986 696E707574206C696E-     getLine_1 db "input line too long",0
  3068 0000298F 6520746F6F206C6F6E-
  3069 00002998 6700               
  3070                                  
  3071                                  ifEOL:  ; *** PROC ***
  3072                                  
  3073                                  ;-18   if (c == 10) return 1;
  3074                                  
  3075                                  ;Function : ifEOL, Number of local variables: 1
  3076                                  ;   # type sign width line used address name   list of local variables
  3077                                  ;  200 var sign byte    17 NULL bp+4    c;
  3078 0000299A C8000000                 ENTER  0,0
  3079 0000299E 8A4604                   mov al, [bp+4]
  3080 000029A1 3C0A                     cmp al, 10
  3081 000029A3 0F850900                 jne @@ifEOL131
  3082 000029A7 66B801000000             mov eax, 1
  3083 000029AD E92F00                   jmp @@retn
  3084                                  
  3085                                  ;-19   if (c == 13) {
  3086                                  
  3087                                  @@ifEOL131:
  3088 000029B0 8A4604                   mov al, [bp+4]
  3089 000029B3 3C0D                     cmp al, 13
  3090 000029B5 0F851D00                 jne @@ifEOL132
  3091                                  
  3092                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3093                                  
  3094 000029B9 6A01                     push 1
  3095 000029BB FF36[9901]               push word [asm_fd]
  3096 000029BF 8D06[A501]               lea  ax, [DOS_ByteRead]
  3097 000029C3 50                       push ax
  3098 000029C4 E8CB1A                   call readRL
  3099 000029C7 83C406                   add  sp, 6
  3100 000029CA A3[A301]                 mov word [DOS_NoBytes], ax
  3101                                  
  3102                                  ;-21     return 1;}
  3103                                  
  3104 000029CD 66B801000000             mov eax, 1
  3105 000029D3 E90900                   jmp @@retn
  3106                                  
  3107                                  ;-22   return 0;
  3108                                  
  3109                                  @@ifEOL132:
  3110 000029D6 66B800000000             mov eax, 0
  3111 000029DC E90000                   jmp @@retn
  3112                                  
  3113                                  ;-23 }
  3114                                  
  3115                                  
  3116                                  ;-24 int skipBlank() {
  3117                                  
  3118 000029DF C9                      @@retn: LEAVE
  3119 000029E0 C3                       ret
  3120                                  ; ENDP
  3121                                  
  3122                                  skipBlank:  ; *** PROC ***
  3123                                  
  3124                                  ;-25   skipblank1:
  3125                                  
  3126                                  @@skipblank1:
  3127                                  
  3128                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3129                                  
  3130 000029E1 8B1E[CE00]               mov bx, [InputPtr]
  3131 000029E5 8A07                     mov al, [bx]
  3132 000029E7 B400                     mov ah, 0
  3133 000029E9 83F820                   cmp ax, 32
  3134 000029EC 0F850600                 jne @@skipBlank133
  3135 000029F0 FF06[CE00]               inc  word [InputPtr]
  3136 000029F4 EBEB                     jmp @@skipblank1
  3137                                  
  3138                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3139                                  
  3140                                  @@skipBlank133:
  3141 000029F6 8B1E[CE00]               mov bx, [InputPtr]
  3142 000029FA 8A07                     mov al, [bx]
  3143 000029FC B400                     mov ah, 0
  3144 000029FE 83F809                   cmp ax, 9
  3145 00002A01 0F850600                 jne @@skipBlank134
  3146 00002A05 FF06[CE00]               inc  word [InputPtr]
  3147 00002A09 EBD6                     jmp @@skipblank1
  3148                                  
  3149                                  ;-28 }
  3150                                  
  3151                                  @@skipBlank134:
  3152                                  
  3153                                  ;-29 int letterE(char c) {
  3154                                  
  3155 00002A0B C3                       ret
  3156                                  ; ENDP
  3157                                  
  3158                                  letterE:  ; *** PROC ***
  3159                                  
  3160                                  ;-30   if (c=='_') return 1;
  3161                                  
  3162                                  ;Function : letterE, Number of local variables: 1
  3163                                  ;   # type sign width line used address name   list of local variables
  3164                                  ;  200 var sign byte    29 NULL bp+4    c;
  3165 00002A0C C8000000                 ENTER  0,0
  3166 00002A10 8A4604                   mov al, [bp+4]
  3167 00002A13 3C5F                     cmp al, 95
  3168 00002A15 0F850900                 jne @@letterE135
  3169 00002A19 66B801000000             mov eax, 1
  3170 00002A1F E97E00                   jmp @@retn
  3171                                  
  3172                                  ;-31   if (c=='.') return 1;
  3173                                  
  3174                                  @@letterE135:
  3175 00002A22 8A4604                   mov al, [bp+4]
  3176 00002A25 3C2E                     cmp al, 46
  3177 00002A27 0F850900                 jne @@letterE136
  3178 00002A2B 66B801000000             mov eax, 1
  3179 00002A31 E96C00                   jmp @@retn
  3180                                  
  3181                                  ;-32   if (c=='?') return 1;
  3182                                  
  3183                                  @@letterE136:
  3184 00002A34 8A4604                   mov al, [bp+4]
  3185 00002A37 3C3F                     cmp al, 63
  3186 00002A39 0F850900                 jne @@letterE137
  3187 00002A3D 66B801000000             mov eax, 1
  3188 00002A43 E95A00                   jmp @@retn
  3189                                  
  3190                                  ;-33   if (c=='$') return 1;
  3191                                  
  3192                                  @@letterE137:
  3193 00002A46 8A4604                   mov al, [bp+4]
  3194 00002A49 3C24                     cmp al, 36
  3195 00002A4B 0F850900                 jne @@letterE138
  3196 00002A4F 66B801000000             mov eax, 1
  3197 00002A55 E94800                   jmp @@retn
  3198                                  
  3199                                  ;-34   if (c> 'z') return 0;
  3200                                  
  3201                                  @@letterE138:
  3202 00002A58 8A4604                   mov al, [bp+4]
  3203 00002A5B 3C7A                     cmp al, 122
  3204 00002A5D 0F8E0900                 jle @@letterE139
  3205 00002A61 66B800000000             mov eax, 0
  3206 00002A67 E93600                   jmp @@retn
  3207                                  
  3208                                  ;-35   if (c< '@') return 0; // at included
  3209                                  
  3210                                  @@letterE139:
  3211 00002A6A 8A4604                   mov al, [bp+4]
  3212 00002A6D 3C40                     cmp al, 64
  3213 00002A6F 0F8D0900                 jge @@letterE140
  3214 00002A73 66B800000000             mov eax, 0
  3215 00002A79 E92400                   jmp @@retn
  3216                                  
  3217                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  3218                                  
  3219                                  @@letterE140:
  3220 00002A7C 8A4604                   mov al, [bp+4]
  3221 00002A7F 3C5A                     cmp al, 90
  3222 00002A81 0F8E1200                 jle @@letterE141
  3223 00002A85 8A4604                   mov al, [bp+4]
  3224 00002A88 3C61                     cmp al, 97
  3225 00002A8A 0F8D0900                 jge @@letterE142
  3226 00002A8E 66B800000000             mov eax, 0
  3227 00002A94 E90900                   jmp @@retn
  3228                                  @@letterE142:
  3229                                  
  3230                                  ;-37   return 1;
  3231                                  
  3232                                  @@letterE141:
  3233 00002A97 66B801000000             mov eax, 1
  3234 00002A9D E90000                   jmp @@retn
  3235                                  
  3236                                  ;-38 }
  3237                                  
  3238                                  
  3239                                  ;-39 int alnumE(char c) {
  3240                                  
  3241 00002AA0 C9                      @@retn: LEAVE
  3242 00002AA1 C3                       ret
  3243                                  ; ENDP
  3244                                  
  3245                                  alnumE:  ; *** PROC ***
  3246                                  
  3247                                  ;-40   if (digit(c)) return 1;
  3248                                  
  3249                                  ;Function : alnumE, Number of local variables: 1
  3250                                  ;   # type sign width line used address name   list of local variables
  3251                                  ;  200 var sign byte    39 NULL bp+4    c;
  3252 00002AA2 C8000000                 ENTER  0,0
  3253 00002AA6 8A4604                   mov al, byte [bp+4]
  3254 00002AA9 B400                     mov ah, 0
  3255 00002AAB 50                       push ax
  3256 00002AAC E81519                   call digit
  3257 00002AAF 83C402                   add  sp, 2
  3258 00002AB2 08C0                     or  al, al
  3259 00002AB4 0F840900                 je @@alnumE143
  3260 00002AB8 66B801000000             mov eax, 1
  3261 00002ABE E92400                   jmp @@retn
  3262                                  
  3263                                  ;-41   if (letterE(c)) return 1;
  3264                                  
  3265                                  @@alnumE143:
  3266 00002AC1 8A4604                   mov al, byte [bp+4]
  3267 00002AC4 B400                     mov ah, 0
  3268 00002AC6 50                       push ax
  3269 00002AC7 E842FF                   call letterE
  3270 00002ACA 83C402                   add  sp, 2
  3271 00002ACD 08C0                     or  al, al
  3272 00002ACF 0F840900                 je @@alnumE144
  3273 00002AD3 66B801000000             mov eax, 1
  3274 00002AD9 E90900                   jmp @@retn
  3275                                  
  3276                                  ;-42   return 0;
  3277                                  
  3278                                  @@alnumE144:
  3279 00002ADC 66B800000000             mov eax, 0
  3280 00002AE2 E90000                   jmp @@retn
  3281                                  
  3282                                  ;-43 }
  3283                                  
  3284                                  
  3285                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3286                                  
  3287 00002AE5 C9                      @@retn: LEAVE
  3288 00002AE6 C3                       ret
  3289                                  ; ENDP
  3290                                  
  3291                                  getDigit:  ; *** PROC ***
  3292                                  
  3293                                  ;-45   unsigned int CastInt;
  3294                                  
  3295                                  
  3296                                  ;-46   SymbolInt=0;
  3297                                  
  3298                                  ;Function : getDigit, Number of local variables: 2
  3299                                  ;   # type sign width line used address name   list of local variables
  3300                                  ;  200 var unsg byte    44 NULL bp+4    c
  3301                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3302 00002AE7 C8020000                 ENTER  2,0
  3303 00002AEB 66B800000000             mov eax, 0
  3304 00002AF1 A3[4D00]                 mov word [SymbolInt], ax
  3305                                  
  3306                                  ;-47   do {
  3307                                  
  3308                                  @@getDigit145:
  3309                                  
  3310                                  ;-48     c-='0';
  3311                                  
  3312 00002AF4 806E0430                 sub  byte [bp+4], 48
  3313                                  
  3314                                  ;-49     SymbolInt=SymbolInt*10;
  3315                                  
  3316 00002AF8 A1[4D00]                 mov ax, [SymbolInt]
  3317 00002AFB 66BB0A000000             mov ebx, 10
  3318 00002B01 66F7E3                   mul ebx
  3319 00002B04 A3[4D00]                 mov word [SymbolInt], ax
  3320                                  
  3321                                  ;-50     ax=0; CastInt=c; //cast b2w
  3322                                  
  3323 00002B07 B80000                   mov  ax, 0
  3324 00002B0A 8A4604                   mov al, [bp+4]
  3325 00002B0D 8946FE                   mov word [bp-2], ax
  3326                                  
  3327                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3328                                  
  3329 00002B10 A1[4D00]                 mov ax, [SymbolInt]
  3330 00002B13 0346FE                   add ax, [bp-2]
  3331 00002B16 A3[4D00]                 mov word [SymbolInt], ax
  3332                                  
  3333                                  ;-52     InputPtr++;
  3334                                  
  3335 00002B19 FF06[CE00]               inc  word [InputPtr]
  3336                                  
  3337                                  ;-53     c = *InputPtr;
  3338                                  
  3339 00002B1D 8B1E[CE00]               mov bx, [InputPtr]
  3340 00002B21 8A07                     mov al, [bx]
  3341 00002B23 B400                     mov ah, 0
  3342 00002B25 884604                   mov byte [bp+4], al
  3343                                  
  3344                                  ;-54   } while(digit(c));
  3345                                  
  3346 00002B28 8A4604                   mov al, byte [bp+4]
  3347 00002B2B B400                     mov ah, 0
  3348 00002B2D 50                       push ax
  3349 00002B2E E89318                   call digit
  3350 00002B31 83C402                   add  sp, 2
  3351 00002B34 08C0                     or  al, al
  3352 00002B36 0F840200                 je @@getDigit146
  3353 00002B3A EBB8                     jmp @@getDigit145
  3354                                  @@getDigit146:
  3355                                  
  3356                                  ;-55 }
  3357                                  
  3358                                  
  3359                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3360 00002B3C C9                       LEAVE
  3361 00002B3D C3                       ret
  3362                                  ; ENDP
  3363                                  
  3364                                  getName:  ; *** PROC ***
  3365                                  
  3366                                  ;-57   char *p; unsigned int i;
  3367                                  
  3368                                  
  3369                                  ;-58   p = &Symbol;
  3370                                  
  3371                                  ;Function : getName, Number of local variables: 3
  3372                                  ;   # type sign width line used address name   list of local variables
  3373                                  ;  200 var unsg byte    56 NULL bp+4    c
  3374                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3375                                  ;  202 var unsg word    57 NULL bp-4    i;
  3376 00002B3E C8040000                 ENTER  4,0
  3377 00002B42 B8[0F00]                 mov ax, Symbol
  3378 00002B45 8946FE                   mov word [bp-2], ax
  3379                                  
  3380                                  ;-59   *p = c;
  3381                                  
  3382 00002B48 8A4604                   mov al, [bp+4]
  3383 00002B4B 8B5EFE                   mov  bx, [bp-2]
  3384 00002B4E 8807                     mov  [bx], al
  3385                                  
  3386                                  ;-60   p++;
  3387                                  
  3388 00002B50 FF46FE                   inc  word [bp-2]
  3389                                  
  3390                                  ;-61   while (alnumE(c)) {
  3391                                  
  3392                                  @@getName147:
  3393 00002B53 8A4604                   mov al, byte [bp+4]
  3394 00002B56 B400                     mov ah, 0
  3395 00002B58 50                       push ax
  3396 00002B59 E846FF                   call alnumE
  3397 00002B5C 83C402                   add  sp, 2
  3398 00002B5F 08C0                     or  al, al
  3399 00002B61 0F843800                 je @@getName148
  3400                                  
  3401                                  ;-62     InputPtr++;
  3402                                  
  3403 00002B65 FF06[CE00]               inc  word [InputPtr]
  3404                                  
  3405                                  ;-63     c = *InputPtr;
  3406                                  
  3407 00002B69 8B1E[CE00]               mov bx, [InputPtr]
  3408 00002B6D 8A07                     mov al, [bx]
  3409 00002B6F B400                     mov ah, 0
  3410 00002B71 884604                   mov byte [bp+4], al
  3411                                  
  3412                                  ;-64     *p = c;
  3413                                  
  3414 00002B74 8A4604                   mov al, [bp+4]
  3415 00002B77 8B5EFE                   mov  bx, [bp-2]
  3416 00002B7A 8807                     mov  [bx], al
  3417                                  
  3418                                  ;-65     p++;
  3419                                  
  3420 00002B7C FF46FE                   inc  word [bp-2]
  3421                                  
  3422                                  ;-66     i = p - &Symbol;
  3423                                  
  3424 00002B7F 8B46FE                   mov ax, [bp-2]
  3425 00002B82 2D[0F00]                 sub ax, Symbol
  3426 00002B85 8946FC                   mov word [bp-4], ax
  3427                                  
  3428                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3429                                  
  3430 00002B88 8B46FC                   mov ax, [bp-4]
  3431 00002B8B 83F81F                   cmp ax, 31 ;unsigned : 0
  3432 00002B8E 0F820900                 jb  @@getName149
  3433 00002B92 68[E62B]                 push getName_0
  3434 00002B95 E86707                   call errorexit
  3435 00002B98 83C402                   add  sp, 2
  3436                                  
  3437                                  ;-68   }
  3438                                  
  3439                                  @@getName149:
  3440                                  
  3441                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3442                                  
  3443 00002B9B EBB6                     jmp @@getName147
  3444                                  @@getName148:
  3445 00002B9D 8A4604                   mov al, [bp+4]
  3446 00002BA0 3C3A                     cmp al, 58
  3447 00002BA2 0F850C00                 jne @@getName150
  3448 00002BA6 66B801000000             mov eax, 1
  3449 00002BAC A2[AC01]                 mov byte [isLabel], al
  3450 00002BAF E90900                   jmp @@getName151
  3451                                  @@getName150:
  3452 00002BB2 66B800000000             mov eax, 0
  3453 00002BB8 A2[AC01]                 mov byte [isLabel], al
  3454                                  
  3455                                  ;-70   p--;
  3456                                  
  3457                                  @@getName151:
  3458 00002BBB FF4EFE                   dec  word [bp-2]
  3459                                  
  3460                                  ;-71   *p = 0;
  3461                                  
  3462 00002BBE 66B800000000             mov eax, 0
  3463 00002BC4 8B5EFE                   mov  bx, [bp-2]
  3464 00002BC7 8807                     mov  [bx], al
  3465                                  
  3466                                  ;-72   strcpy(SymbolUpper, Symbol);
  3467                                  
  3468 00002BC9 8D06[0F00]               lea  ax, [Symbol]
  3469 00002BCD 50                       push ax
  3470 00002BCE 8D06[2E00]               lea  ax, [SymbolUpper]
  3471 00002BD2 50                       push ax
  3472 00002BD3 E8B517                   call strcpy
  3473 00002BD6 83C404                   add  sp, 4
  3474                                  
  3475                                  ;-73   toupper(SymbolUpper);
  3476                                  
  3477 00002BD9 8D06[2E00]               lea  ax, [SymbolUpper]
  3478 00002BDD 50                       push ax
  3479 00002BDE E83C17                   call toupper
  3480 00002BE1 83C402                   add  sp, 2
  3481                                  
  3482                                  ;-74 }
  3483                                  
  3484                                  
  3485                                  ;-75 int testReg() {
  3486 00002BE4 C9                       LEAVE
  3487 00002BE5 C3                       ret
  3488                                  ; ENDP
  3489 00002BE6 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3490 00002BEF 6F206C6F6E6700     
  3491                                  
  3492                                  testReg:  ; *** PROC ***
  3493                                  
  3494                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3495                                  
  3496                                  
  3497                                  ;-77   R2Type=0;
  3498                                  
  3499 00002BF6 66B800000000             mov eax, 0
  3500 00002BFC A2[B601]                 mov byte [R2Type], al
  3501                                  
  3502                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3503                                  
  3504 00002BFF 8D06[0F00]               lea  ax, [Symbol]
  3505 00002C03 50                       push ax
  3506 00002C04 E85917                   call strlen
  3507 00002C07 83C402                   add  sp, 2
  3508 00002C0A 3C02                     cmp al, 2
  3509 00002C0C 0F8D0900                 jge @@testReg152
  3510 00002C10 66B800000000             mov eax, 0
  3511 00002C16 E9B603                   jmp @@retn
  3512                                  
  3513                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3514                                  
  3515                                  @@testReg152:
  3516 00002C19 8D06[0F00]               lea  ax, [Symbol]
  3517 00002C1D 50                       push ax
  3518 00002C1E E83F17                   call strlen
  3519 00002C21 83C402                   add  sp, 2
  3520 00002C24 3C03                     cmp al, 3
  3521 00002C26 0F8E0900                 jle @@testReg153
  3522 00002C2A 66B800000000             mov eax, 0
  3523 00002C30 E99C03                   jmp @@retn
  3524                                  
  3525                                  ;-80   R2Type=BYTE;
  3526                                  
  3527                                  @@testReg153:
  3528 00002C33 66B801000000             mov eax, 1
  3529 00002C39 A2[B601]                 mov byte [R2Type], al
  3530                                  
  3531                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3532                                  
  3533 00002C3C 68[D02F]                 push testReg_0
  3534 00002C3F 8D06[2E00]               lea  ax, [SymbolUpper]
  3535 00002C43 50                       push ax
  3536 00002C44 E8B017                   call eqstr
  3537 00002C47 83C404                   add  sp, 4
  3538 00002C4A 08C0                     or  al, al
  3539 00002C4C 0F840900                 je @@testReg154
  3540 00002C50 66B800000000             mov eax, 0
  3541 00002C56 E97603                   jmp @@retn
  3542                                  
  3543                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3544                                  
  3545                                  @@testReg154:
  3546 00002C59 68[D32F]                 push testReg_1
  3547 00002C5C 8D06[2E00]               lea  ax, [SymbolUpper]
  3548 00002C60 50                       push ax
  3549 00002C61 E89317                   call eqstr
  3550 00002C64 83C404                   add  sp, 4
  3551 00002C67 08C0                     or  al, al
  3552 00002C69 0F840900                 je @@testReg155
  3553 00002C6D 66B801000000             mov eax, 1
  3554 00002C73 E95903                   jmp @@retn
  3555                                  
  3556                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3557                                  
  3558                                  @@testReg155:
  3559 00002C76 68[D62F]                 push testReg_2
  3560 00002C79 8D06[2E00]               lea  ax, [SymbolUpper]
  3561 00002C7D 50                       push ax
  3562 00002C7E E87617                   call eqstr
  3563 00002C81 83C404                   add  sp, 4
  3564 00002C84 08C0                     or  al, al
  3565 00002C86 0F840900                 je @@testReg156
  3566 00002C8A 66B802000000             mov eax, 2
  3567 00002C90 E93C03                   jmp @@retn
  3568                                  
  3569                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3570                                  
  3571                                  @@testReg156:
  3572 00002C93 68[D92F]                 push testReg_3
  3573 00002C96 8D06[2E00]               lea  ax, [SymbolUpper]
  3574 00002C9A 50                       push ax
  3575 00002C9B E85917                   call eqstr
  3576 00002C9E 83C404                   add  sp, 4
  3577 00002CA1 08C0                     or  al, al
  3578 00002CA3 0F840900                 je @@testReg157
  3579 00002CA7 66B803000000             mov eax, 3
  3580 00002CAD E91F03                   jmp @@retn
  3581                                  
  3582                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3583                                  
  3584                                  @@testReg157:
  3585 00002CB0 68[DC2F]                 push testReg_4
  3586 00002CB3 8D06[2E00]               lea  ax, [SymbolUpper]
  3587 00002CB7 50                       push ax
  3588 00002CB8 E83C17                   call eqstr
  3589 00002CBB 83C404                   add  sp, 4
  3590 00002CBE 08C0                     or  al, al
  3591 00002CC0 0F840900                 je @@testReg158
  3592 00002CC4 66B804000000             mov eax, 4
  3593 00002CCA E90203                   jmp @@retn
  3594                                  
  3595                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3596                                  
  3597                                  @@testReg158:
  3598 00002CCD 68[DF2F]                 push testReg_5
  3599 00002CD0 8D06[2E00]               lea  ax, [SymbolUpper]
  3600 00002CD4 50                       push ax
  3601 00002CD5 E81F17                   call eqstr
  3602 00002CD8 83C404                   add  sp, 4
  3603 00002CDB 08C0                     or  al, al
  3604 00002CDD 0F840900                 je @@testReg159
  3605 00002CE1 66B805000000             mov eax, 5
  3606 00002CE7 E9E502                   jmp @@retn
  3607                                  
  3608                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3609                                  
  3610                                  @@testReg159:
  3611 00002CEA 68[E22F]                 push testReg_6
  3612 00002CED 8D06[2E00]               lea  ax, [SymbolUpper]
  3613 00002CF1 50                       push ax
  3614 00002CF2 E80217                   call eqstr
  3615 00002CF5 83C404                   add  sp, 4
  3616 00002CF8 08C0                     or  al, al
  3617 00002CFA 0F840900                 je @@testReg160
  3618 00002CFE 66B806000000             mov eax, 6
  3619 00002D04 E9C802                   jmp @@retn
  3620                                  
  3621                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3622                                  
  3623                                  @@testReg160:
  3624 00002D07 68[E52F]                 push testReg_7
  3625 00002D0A 8D06[2E00]               lea  ax, [SymbolUpper]
  3626 00002D0E 50                       push ax
  3627 00002D0F E8E516                   call eqstr
  3628 00002D12 83C404                   add  sp, 4
  3629 00002D15 08C0                     or  al, al
  3630 00002D17 0F840900                 je @@testReg161
  3631 00002D1B 66B807000000             mov eax, 7
  3632 00002D21 E9AB02                   jmp @@retn
  3633                                  
  3634                                  ;-89   R2Type=WORD;
  3635                                  
  3636                                  @@testReg161:
  3637 00002D24 66B802000000             mov eax, 2
  3638 00002D2A A2[B601]                 mov byte [R2Type], al
  3639                                  
  3640                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3641                                  
  3642 00002D2D 68[E82F]                 push testReg_8
  3643 00002D30 8D06[2E00]               lea  ax, [SymbolUpper]
  3644 00002D34 50                       push ax
  3645 00002D35 E8BF16                   call eqstr
  3646 00002D38 83C404                   add  sp, 4
  3647 00002D3B 08C0                     or  al, al
  3648 00002D3D 0F840900                 je @@testReg162
  3649 00002D41 66B800000000             mov eax, 0
  3650 00002D47 E98502                   jmp @@retn
  3651                                  
  3652                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3653                                  
  3654                                  @@testReg162:
  3655 00002D4A 68[EB2F]                 push testReg_9
  3656 00002D4D 8D06[2E00]               lea  ax, [SymbolUpper]
  3657 00002D51 50                       push ax
  3658 00002D52 E8A216                   call eqstr
  3659 00002D55 83C404                   add  sp, 4
  3660 00002D58 08C0                     or  al, al
  3661 00002D5A 0F840900                 je @@testReg163
  3662 00002D5E 66B801000000             mov eax, 1
  3663 00002D64 E96802                   jmp @@retn
  3664                                  
  3665                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3666                                  
  3667                                  @@testReg163:
  3668 00002D67 68[EE2F]                 push testReg_10
  3669 00002D6A 8D06[2E00]               lea  ax, [SymbolUpper]
  3670 00002D6E 50                       push ax
  3671 00002D6F E88516                   call eqstr
  3672 00002D72 83C404                   add  sp, 4
  3673 00002D75 08C0                     or  al, al
  3674 00002D77 0F840900                 je @@testReg164
  3675 00002D7B 66B802000000             mov eax, 2
  3676 00002D81 E94B02                   jmp @@retn
  3677                                  
  3678                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3679                                  
  3680                                  @@testReg164:
  3681 00002D84 68[F12F]                 push testReg_11
  3682 00002D87 8D06[2E00]               lea  ax, [SymbolUpper]
  3683 00002D8B 50                       push ax
  3684 00002D8C E86816                   call eqstr
  3685 00002D8F 83C404                   add  sp, 4
  3686 00002D92 08C0                     or  al, al
  3687 00002D94 0F840900                 je @@testReg165
  3688 00002D98 66B803000000             mov eax, 3
  3689 00002D9E E92E02                   jmp @@retn
  3690                                  
  3691                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3692                                  
  3693                                  @@testReg165:
  3694 00002DA1 68[F42F]                 push testReg_12
  3695 00002DA4 8D06[2E00]               lea  ax, [SymbolUpper]
  3696 00002DA8 50                       push ax
  3697 00002DA9 E84B16                   call eqstr
  3698 00002DAC 83C404                   add  sp, 4
  3699 00002DAF 08C0                     or  al, al
  3700 00002DB1 0F840900                 je @@testReg166
  3701 00002DB5 66B804000000             mov eax, 4
  3702 00002DBB E91102                   jmp @@retn
  3703                                  
  3704                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3705                                  
  3706                                  @@testReg166:
  3707 00002DBE 68[F72F]                 push testReg_13
  3708 00002DC1 8D06[2E00]               lea  ax, [SymbolUpper]
  3709 00002DC5 50                       push ax
  3710 00002DC6 E82E16                   call eqstr
  3711 00002DC9 83C404                   add  sp, 4
  3712 00002DCC 08C0                     or  al, al
  3713 00002DCE 0F840900                 je @@testReg167
  3714 00002DD2 66B805000000             mov eax, 5
  3715 00002DD8 E9F401                   jmp @@retn
  3716                                  
  3717                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3718                                  
  3719                                  @@testReg167:
  3720 00002DDB 68[FA2F]                 push testReg_14
  3721 00002DDE 8D06[2E00]               lea  ax, [SymbolUpper]
  3722 00002DE2 50                       push ax
  3723 00002DE3 E81116                   call eqstr
  3724 00002DE6 83C404                   add  sp, 4
  3725 00002DE9 08C0                     or  al, al
  3726 00002DEB 0F840900                 je @@testReg168
  3727 00002DEF 66B806000000             mov eax, 6
  3728 00002DF5 E9D701                   jmp @@retn
  3729                                  
  3730                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3731                                  
  3732                                  @@testReg168:
  3733 00002DF8 68[FD2F]                 push testReg_15
  3734 00002DFB 8D06[2E00]               lea  ax, [SymbolUpper]
  3735 00002DFF 50                       push ax
  3736 00002E00 E8F415                   call eqstr
  3737 00002E03 83C404                   add  sp, 4
  3738 00002E06 08C0                     or  al, al
  3739 00002E08 0F840900                 je @@testReg169
  3740 00002E0C 66B807000000             mov eax, 7
  3741 00002E12 E9BA01                   jmp @@retn
  3742                                  
  3743                                  ;-98   R2Type=SEGREG;
  3744                                  
  3745                                  @@testReg169:
  3746 00002E15 66B804000000             mov eax, 4
  3747 00002E1B A2[B601]                 mov byte [R2Type], al
  3748                                  
  3749                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3750                                  
  3751 00002E1E 68[0030]                 push testReg_16
  3752 00002E21 8D06[2E00]               lea  ax, [SymbolUpper]
  3753 00002E25 50                       push ax
  3754 00002E26 E8CE15                   call eqstr
  3755 00002E29 83C404                   add  sp, 4
  3756 00002E2C 08C0                     or  al, al
  3757 00002E2E 0F840900                 je @@testReg170
  3758 00002E32 66B800000000             mov eax, 0
  3759 00002E38 E99401                   jmp @@retn
  3760                                  
  3761                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3762                                  
  3763                                  @@testReg170:
  3764 00002E3B 68[0330]                 push testReg_17
  3765 00002E3E 8D06[2E00]               lea  ax, [SymbolUpper]
  3766 00002E42 50                       push ax
  3767 00002E43 E8B115                   call eqstr
  3768 00002E46 83C404                   add  sp, 4
  3769 00002E49 08C0                     or  al, al
  3770 00002E4B 0F840900                 je @@testReg171
  3771 00002E4F 66B801000000             mov eax, 1
  3772 00002E55 E97701                   jmp @@retn
  3773                                  
  3774                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3775                                  
  3776                                  @@testReg171:
  3777 00002E58 68[0630]                 push testReg_18
  3778 00002E5B 8D06[2E00]               lea  ax, [SymbolUpper]
  3779 00002E5F 50                       push ax
  3780 00002E60 E89415                   call eqstr
  3781 00002E63 83C404                   add  sp, 4
  3782 00002E66 08C0                     or  al, al
  3783 00002E68 0F840900                 je @@testReg172
  3784 00002E6C 66B802000000             mov eax, 2
  3785 00002E72 E95A01                   jmp @@retn
  3786                                  
  3787                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3788                                  
  3789                                  @@testReg172:
  3790 00002E75 68[0930]                 push testReg_19
  3791 00002E78 8D06[2E00]               lea  ax, [SymbolUpper]
  3792 00002E7C 50                       push ax
  3793 00002E7D E87715                   call eqstr
  3794 00002E80 83C404                   add  sp, 4
  3795 00002E83 08C0                     or  al, al
  3796 00002E85 0F840900                 je @@testReg173
  3797 00002E89 66B803000000             mov eax, 3
  3798 00002E8F E93D01                   jmp @@retn
  3799                                  
  3800                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3801                                  
  3802                                  @@testReg173:
  3803 00002E92 68[0C30]                 push testReg_20
  3804 00002E95 8D06[2E00]               lea  ax, [SymbolUpper]
  3805 00002E99 50                       push ax
  3806 00002E9A E85A15                   call eqstr
  3807 00002E9D 83C404                   add  sp, 4
  3808 00002EA0 08C0                     or  al, al
  3809 00002EA2 0F840900                 je @@testReg174
  3810 00002EA6 66B804000000             mov eax, 4
  3811 00002EAC E92001                   jmp @@retn
  3812                                  
  3813                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3814                                  
  3815                                  @@testReg174:
  3816 00002EAF 68[0F30]                 push testReg_21
  3817 00002EB2 8D06[2E00]               lea  ax, [SymbolUpper]
  3818 00002EB6 50                       push ax
  3819 00002EB7 E83D15                   call eqstr
  3820 00002EBA 83C404                   add  sp, 4
  3821 00002EBD 08C0                     or  al, al
  3822 00002EBF 0F840900                 je @@testReg175
  3823 00002EC3 66B805000000             mov eax, 5
  3824 00002EC9 E90301                   jmp @@retn
  3825                                  
  3826                                  ;-105   R2Type=DWORD;                         
  3827                                  
  3828                                  @@testReg175:
  3829 00002ECC 66B803000000             mov eax, 3
  3830 00002ED2 A2[B601]                 mov byte [R2Type], al
  3831                                  
  3832                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3833                                  
  3834 00002ED5 68[1230]                 push testReg_22
  3835 00002ED8 8D06[2E00]               lea  ax, [SymbolUpper]
  3836 00002EDC 50                       push ax
  3837 00002EDD E81715                   call eqstr
  3838 00002EE0 83C404                   add  sp, 4
  3839 00002EE3 08C0                     or  al, al
  3840 00002EE5 0F840900                 je @@testReg176
  3841 00002EE9 66B800000000             mov eax, 0
  3842 00002EEF E9DD00                   jmp @@retn
  3843                                  
  3844                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3845                                  
  3846                                  @@testReg176:
  3847 00002EF2 68[1630]                 push testReg_23
  3848 00002EF5 8D06[2E00]               lea  ax, [SymbolUpper]
  3849 00002EF9 50                       push ax
  3850 00002EFA E8FA14                   call eqstr
  3851 00002EFD 83C404                   add  sp, 4
  3852 00002F00 08C0                     or  al, al
  3853 00002F02 0F840900                 je @@testReg177
  3854 00002F06 66B801000000             mov eax, 1
  3855 00002F0C E9C000                   jmp @@retn
  3856                                  
  3857                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3858                                  
  3859                                  @@testReg177:
  3860 00002F0F 68[1A30]                 push testReg_24
  3861 00002F12 8D06[2E00]               lea  ax, [SymbolUpper]
  3862 00002F16 50                       push ax
  3863 00002F17 E8DD14                   call eqstr
  3864 00002F1A 83C404                   add  sp, 4
  3865 00002F1D 08C0                     or  al, al
  3866 00002F1F 0F840900                 je @@testReg178
  3867 00002F23 66B802000000             mov eax, 2
  3868 00002F29 E9A300                   jmp @@retn
  3869                                  
  3870                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3871                                  
  3872                                  @@testReg178:
  3873 00002F2C 68[1E30]                 push testReg_25
  3874 00002F2F 8D06[2E00]               lea  ax, [SymbolUpper]
  3875 00002F33 50                       push ax
  3876 00002F34 E8C014                   call eqstr
  3877 00002F37 83C404                   add  sp, 4
  3878 00002F3A 08C0                     or  al, al
  3879 00002F3C 0F840900                 je @@testReg179
  3880 00002F40 66B803000000             mov eax, 3
  3881 00002F46 E98600                   jmp @@retn
  3882                                  
  3883                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3884                                  
  3885                                  @@testReg179:
  3886 00002F49 68[2230]                 push testReg_26
  3887 00002F4C 8D06[2E00]               lea  ax, [SymbolUpper]
  3888 00002F50 50                       push ax
  3889 00002F51 E8A314                   call eqstr
  3890 00002F54 83C404                   add  sp, 4
  3891 00002F57 08C0                     or  al, al
  3892 00002F59 0F840900                 je @@testReg180
  3893 00002F5D 66B804000000             mov eax, 4
  3894 00002F63 E96900                   jmp @@retn
  3895                                  
  3896                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3897                                  
  3898                                  @@testReg180:
  3899 00002F66 68[2630]                 push testReg_27
  3900 00002F69 8D06[2E00]               lea  ax, [SymbolUpper]
  3901 00002F6D 50                       push ax
  3902 00002F6E E88614                   call eqstr
  3903 00002F71 83C404                   add  sp, 4
  3904 00002F74 08C0                     or  al, al
  3905 00002F76 0F840900                 je @@testReg181
  3906 00002F7A 66B805000000             mov eax, 5
  3907 00002F80 E94C00                   jmp @@retn
  3908                                  
  3909                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3910                                  
  3911                                  @@testReg181:
  3912 00002F83 68[2A30]                 push testReg_28
  3913 00002F86 8D06[2E00]               lea  ax, [SymbolUpper]
  3914 00002F8A 50                       push ax
  3915 00002F8B E86914                   call eqstr
  3916 00002F8E 83C404                   add  sp, 4
  3917 00002F91 08C0                     or  al, al
  3918 00002F93 0F840900                 je @@testReg182
  3919 00002F97 66B806000000             mov eax, 6
  3920 00002F9D E92F00                   jmp @@retn
  3921                                  
  3922                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3923                                  
  3924                                  @@testReg182:
  3925 00002FA0 68[2E30]                 push testReg_29
  3926 00002FA3 8D06[2E00]               lea  ax, [SymbolUpper]
  3927 00002FA7 50                       push ax
  3928 00002FA8 E84C14                   call eqstr
  3929 00002FAB 83C404                   add  sp, 4
  3930 00002FAE 08C0                     or  al, al
  3931 00002FB0 0F840900                 je @@testReg183
  3932 00002FB4 66B807000000             mov eax, 7
  3933 00002FBA E91200                   jmp @@retn
  3934                                  
  3935                                  ;-114   R2Type=0; return 0;
  3936                                  
  3937                                  @@testReg183:
  3938 00002FBD 66B800000000             mov eax, 0
  3939 00002FC3 A2[B601]                 mov byte [R2Type], al
  3940 00002FC6 66B800000000             mov eax, 0
  3941 00002FCC E90000                   jmp @@retn
  3942                                  
  3943                                  ;-115 }
  3944                                  
  3945                                  @@retn:
  3946 00002FCF C3                       ret
  3947                                  ; ENDP
  3948 00002FD0 414C00                  testReg_0 db "AL",0
  3949 00002FD3 434C00                  testReg_1 db "CL",0
  3950 00002FD6 444C00                  testReg_2 db "DL",0
  3951 00002FD9 424C00                  testReg_3 db "BL",0
  3952 00002FDC 414800                  testReg_4 db "AH",0
  3953 00002FDF 434800                  testReg_5 db "CH",0
  3954 00002FE2 444800                  testReg_6 db "DH",0
  3955 00002FE5 424800                  testReg_7 db "BH",0
  3956 00002FE8 415800                  testReg_8 db "AX",0
  3957 00002FEB 435800                  testReg_9 db "CX",0
  3958 00002FEE 445800                  testReg_10 db "DX",0
  3959 00002FF1 425800                  testReg_11 db "BX",0
  3960 00002FF4 535000                  testReg_12 db "SP",0
  3961 00002FF7 425000                  testReg_13 db "BP",0
  3962 00002FFA 534900                  testReg_14 db "SI",0
  3963 00002FFD 444900                  testReg_15 db "DI",0
  3964 00003000 455300                  testReg_16 db "ES",0
  3965 00003003 435300                  testReg_17 db "CS",0
  3966 00003006 535300                  testReg_18 db "SS",0
  3967 00003009 445300                  testReg_19 db "DS",0
  3968 0000300C 465300                  testReg_20 db "FS",0
  3969 0000300F 475300                  testReg_21 db "GS",0
  3970 00003012 45415800                testReg_22 db "EAX",0
  3971 00003016 45435800                testReg_23 db "ECX",0
  3972 0000301A 45445800                testReg_24 db "EDX",0
  3973 0000301E 45425800                testReg_25 db "EBX",0
  3974 00003022 45535000                testReg_26 db "ESP",0
  3975 00003026 45425000                testReg_27 db "EBP",0
  3976 0000302A 45534900                testReg_28 db "ESI",0
  3977 0000302E 45444900                testReg_29 db "EDI",0
  3978                                  ;Back to main program: AS.C
  3979                                  
  3980                                  ;-7 #include "OUTPUT.C"
  3981                                  
  3982                                  ;Use include file: OUTPUT.C
  3983                                  
  3984                                  ;-1 int printLine() { 
  3985                                  
  3986                                  
  3987                                  printLine:  ; *** PROC ***
  3988                                  
  3989                                  ;-2     int i; char c;
  3990                                  
  3991                                  
  3992                                  ;-3     prs("\n"); 
  3993                                  
  3994                                  ;Function : printLine, Number of local variables: 2
  3995                                  ;   # type sign width line used address name   list of local variables
  3996                                  ;  200 var sign word     2 NULL bp-2    i
  3997                                  ;  201 var sign byte     2 NULL bp-4    c;
  3998 00003032 C8040000                 ENTER  4,0
  3999 00003036 68[C730]                 push printLine_0
  4000 00003039 E80301                   call prs
  4001 0000303C 83C402                   add  sp, 2
  4002                                  
  4003                                  ;-4     printhex16(PCStart);
  4004                                  
  4005 0000303F FF36[AA01]               push word [PCStart]
  4006 00003043 E8EE01                   call printhex16
  4007 00003046 83C402                   add  sp, 2
  4008                                  
  4009                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  4010                                  
  4011 00003049 A1[C701]                 mov ax, [OpPrintIndex]
  4012 0000304C 83F800                   cmp ax, 0
  4013 0000304F 0F850C00                 jne @@printLine184
  4014 00003053 68[CA30]                 push printLine_1
  4015 00003056 E8E600                   call prs
  4016 00003059 83C402                   add  sp, 2
  4017                                  
  4018                                  ;-6     else {
  4019                                  
  4020 0000305C E94F00                   jmp @@printLine185
  4021                                  @@printLine184:
  4022                                  
  4023                                  ;-7 //        prc(' ');
  4024                                  
  4025                                  
  4026                                  ;-8         i=0;
  4027                                  
  4028 0000305F 66B800000000             mov eax, 0
  4029 00003065 8946FE                   mov word [bp-2], ax
  4030                                  
  4031                                  ;-9         do {
  4032                                  
  4033                                  @@printLine186:
  4034                                  
  4035                                  ;-10             c=OpPos[i];
  4036                                  
  4037 00003068 8B5EFE                   mov bx, [bp-2]
  4038 0000306B 8A87[C201]               mov al, [OpPos + bx]
  4039 0000306F 8846FC                   mov byte [bp-4], al
  4040                                  
  4041                                  ;-11             prc(' ');
  4042                                  
  4043 00003072 6A20                     push 32
  4044 00003074 E86700                   call prc
  4045 00003077 83C402                   add  sp, 2
  4046                                  
  4047                                  ;-12             printhex8a(c); 
  4048                                  
  4049 0000307A 8A46FC                   mov al, byte [bp-4]
  4050 0000307D B400                     mov ah, 0
  4051 0000307F 50                       push ax
  4052 00003080 E85F01                   call printhex8a
  4053 00003083 83C402                   add  sp, 2
  4054                                  
  4055                                  ;-13             i++;
  4056                                  
  4057 00003086 FF46FE                   inc  word [bp-2]
  4058                                  
  4059                                  ;-14         } while (i < OpPrintIndex);
  4060                                  
  4061 00003089 8B46FE                   mov ax, [bp-2]
  4062 0000308C 3B06[C701]               cmp ax, [OpPrintIndex]
  4063 00003090 0F8D0200                 jge @@printLine187
  4064 00003094 EBD2                     jmp @@printLine186
  4065                                  @@printLine187:
  4066                                  
  4067                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  4068                                  
  4069                                  @@printLine188:
  4070 00003096 8B46FE                   mov ax, [bp-2]
  4071 00003099 83F805                   cmp ax, 5
  4072 0000309C 0F8D0E00                 jge @@printLine189
  4073                                  
  4074                                  ;-16             prs("   ");
  4075                                  
  4076 000030A0 68[DA30]                 push printLine_2
  4077 000030A3 E89900                   call prs
  4078 000030A6 83C402                   add  sp, 2
  4079                                  
  4080                                  ;-17             i++;
  4081                                  
  4082 000030A9 FF46FE                   inc  word [bp-2]
  4083                                  
  4084                                  ;-18         }
  4085                                  
  4086                                  
  4087                                  ;-19     }
  4088                                  
  4089 000030AC EBE8                     jmp @@printLine188
  4090                                  @@printLine189:
  4091                                  
  4092                                  ;-20     prc(PrintRA);
  4093                                  
  4094                                  @@printLine185:
  4095 000030AE A0[CB01]                 mov al, byte [PrintRA]
  4096 000030B1 B400                     mov ah, 0
  4097 000030B3 50                       push ax
  4098 000030B4 E82700                   call prc
  4099 000030B7 83C402                   add  sp, 2
  4100                                  
  4101                                  ;-21     prscomment(InputBuf);
  4102                                  
  4103 000030BA 8D06[4F00]               lea  ax, [InputBuf]
  4104 000030BE 50                       push ax
  4105 000030BF E84F00                   call prscomment
  4106 000030C2 83C402                   add  sp, 2
  4107                                  
  4108                                  ;-22 }
  4109                                  
  4110                                  
  4111                                  ;-23 int prc(unsigned char c) {//print char 
  4112 000030C5 C9                       LEAVE
  4113 000030C6 C3                       ret
  4114                                  ; ENDP
  4115 000030C7 5C6E00                  printLine_0 db "\n",0
  4116 000030CA 202020202020202020-     printLine_1 db "               ",0
  4117 000030D3 20202020202000     
  4118 000030DA 20202000                printLine_2 db "   ",0
  4119                                  
  4120                                  prc:  ; *** PROC ***
  4121                                  
  4122                                  ;-24     if (LIST) { 
  4123                                  
  4124                                  ;Function : prc, Number of local variables: 1
  4125                                  ;   # type sign width line used address name   list of local variables
  4126                                  ;  200 var unsg byte    23 NULL bp+4    c;
  4127 000030DE C8000000                 ENTER  0,0
  4128 000030E2 A0[0E00]                 mov al, [LIST]
  4129 000030E5 08C0                     or  al, al
  4130 000030E7 0F841400                 je @@prc190
  4131                                  
  4132                                  ;-25         if ( _ c==10) {
  4133                                  
  4134 000030EB 807E040A                cmp byte [bp+4], 10
  4135 000030EF 0F850600                 jne @@prc191
  4136                                  
  4137                                  ;-26             ax=13; 
  4138                                  
  4139 000030F3 B80D00                   mov  ax, 13
  4140                                  
  4141                                  ;-27             writetty(); 
  4142                                  
  4143 000030F6 E8EE11                   call writetty
  4144                                  
  4145                                  ;-28             }
  4146                                  
  4147                                  
  4148                                  ;-29         al=c; 
  4149                                  
  4150                                  @@prc191:
  4151 000030F9 8A4604                   mov  al, [bp+4]
  4152                                  
  4153                                  ;-30         writetty(); 
  4154                                  
  4155 000030FC E8E811                   call writetty
  4156                                  
  4157                                  ;-31         }
  4158                                  
  4159                                  
  4160                                  ;-32     fputcR(c,lst_fd); 
  4161                                  
  4162                                  @@prc190:
  4163 000030FF FF36[9B01]               push word [lst_fd]
  4164 00003103 8A4604                   mov al, byte [bp+4]
  4165 00003106 B400                     mov ah, 0
  4166 00003108 50                       push ax
  4167 00003109 E89B13                   call fputcR
  4168 0000310C 83C404                   add  sp, 4
  4169                                  
  4170                                  ;-33 }
  4171                                  
  4172                                  
  4173                                  ;-34 
  4174                                  
  4175                                  
  4176                                  ;-35 int prscomment(unsigned char *s) {
  4177 0000310F C9                       LEAVE
  4178 00003110 C3                       ret
  4179                                  ; ENDP
  4180                                  
  4181                                  prscomment:  ; *** PROC ***
  4182                                  
  4183                                  ;-36     unsigned char c;
  4184                                  
  4185                                  
  4186                                  ;-37     while (*s){
  4187                                  
  4188                                  ;Function : prscomment, Number of local variables: 2
  4189                                  ;   # type sign width line used address name   list of local variables
  4190                                  ;  200 ptr unsg byte    35 NULL bp+4    s
  4191                                  ;  201 var unsg byte    36 NULL bp-2    c;
  4192 00003111 C8020000                 ENTER  2,0
  4193                                  @@prscomment192:
  4194 00003115 8B5E04                   mov bx, [bp+4]
  4195 00003118 8A07                     mov al, [bx]
  4196 0000311A B400                     mov ah, 0
  4197 0000311C 08C0                     or  al, al
  4198 0000311E 0F841B00                 je @@prscomment193
  4199                                  
  4200                                  ;-38         c=*s;
  4201                                  
  4202 00003122 8B5E04                   mov bx, [bp+4]
  4203 00003125 8A07                     mov al, [bx]
  4204 00003127 B400                     mov ah, 0
  4205 00003129 8846FE                   mov byte [bp-2], al
  4206                                  
  4207                                  ;-39         prc(c);
  4208                                  
  4209 0000312C 8A46FE                   mov al, byte [bp-2]
  4210 0000312F B400                     mov ah, 0
  4211 00003131 50                       push ax
  4212 00003132 E8A9FF                   call prc
  4213 00003135 83C402                   add  sp, 2
  4214                                  
  4215                                  ;-40         s++;
  4216                                  
  4217 00003138 FF4604                   inc  word [bp+4]
  4218                                  
  4219                                  ;-41     }
  4220                                  
  4221                                  
  4222                                  ;-42 }
  4223                                  
  4224 0000313B EBD8                     jmp @@prscomment192
  4225                                  @@prscomment193:
  4226                                  
  4227                                  ;-43 int prs(unsigned char *s) {
  4228 0000313D C9                       LEAVE
  4229 0000313E C3                       ret
  4230                                  ; ENDP
  4231                                  
  4232                                  prs:  ; *** PROC ***
  4233                                  
  4234                                  ;-44     unsigned char c; 
  4235                                  
  4236                                  
  4237                                  ;-45     int com; 
  4238                                  
  4239                                  
  4240                                  ;-46     com=0;
  4241                                  
  4242                                  ;Function : prs, Number of local variables: 3
  4243                                  ;   # type sign width line used address name   list of local variables
  4244                                  ;  200 ptr unsg byte    43 NULL bp+4    s
  4245                                  ;  201 var unsg byte    44 NULL bp-2    c
  4246                                  ;  202 var sign word    45 NULL bp-4    com;
  4247 0000313F C8040000                 ENTER  4,0
  4248 00003143 66B800000000             mov eax, 0
  4249 00003149 8946FC                   mov word [bp-4], ax
  4250                                  
  4251                                  ;-47     while (*s) { 
  4252                                  
  4253                                  @@prs194:
  4254 0000314C 8B5E04                   mov bx, [bp+4]
  4255 0000314F 8A07                     mov al, [bx]
  4256 00003151 B400                     mov ah, 0
  4257 00003153 08C0                     or  al, al
  4258 00003155 0F848700                 je @@prs195
  4259                                  
  4260                                  ;-48         c=*s; 
  4261                                  
  4262 00003159 8B5E04                   mov bx, [bp+4]
  4263 0000315C 8A07                     mov al, [bx]
  4264 0000315E B400                     mov ah, 0
  4265 00003160 8846FE                   mov byte [bp-2], al
  4266                                  
  4267                                  ;-49         if (c==34) {
  4268                                  
  4269 00003163 8A46FE                   mov al, [bp-2]
  4270 00003166 3C22                     cmp al, 34
  4271 00003168 0F851E00                 jne @@prs196
  4272                                  
  4273                                  ;-50             if (com) com=0; 
  4274                                  
  4275 0000316C 8B46FC                   mov ax, [bp-4]
  4276 0000316F 08C0                     or  al, al
  4277 00003171 0F840C00                 je @@prs197
  4278 00003175 66B800000000             mov eax, 0
  4279 0000317B 8946FC                   mov word [bp-4], ax
  4280                                  
  4281                                  ;-51                 else com=1;  
  4282                                  
  4283 0000317E E90900                   jmp @@prs198
  4284                                  @@prs197:
  4285 00003181 66B801000000             mov eax, 1
  4286 00003187 8946FC                   mov word [bp-4], ax
  4287                                  
  4288                                  ;-52         }
  4289                                  
  4290                                  @@prs198:
  4291                                  
  4292                                  ;-53         if (c==92) { 
  4293                                  
  4294                                  @@prs196:
  4295 0000318A 8A46FE                   mov al, [bp-2]
  4296 0000318D 3C5C                     cmp al, 92
  4297 0000318F 0F853B00                 jne @@prs199
  4298                                  
  4299                                  ;-54             if (com==0) { 
  4300                                  
  4301 00003193 8B46FC                   mov ax, [bp-4]
  4302 00003196 83F800                   cmp ax, 0
  4303 00003199 0F853100                 jne @@prs200
  4304                                  
  4305                                  ;-55                 s++; 
  4306                                  
  4307 0000319D FF4604                   inc  word [bp+4]
  4308                                  
  4309                                  ;-56                 c=*s;
  4310                                  
  4311 000031A0 8B5E04                   mov bx, [bp+4]
  4312 000031A3 8A07                     mov al, [bx]
  4313 000031A5 B400                     mov ah, 0
  4314 000031A7 8846FE                   mov byte [bp-2], al
  4315                                  
  4316                                  ;-57                 if (c=='n') c=10; 
  4317                                  
  4318 000031AA 8A46FE                   mov al, [bp-2]
  4319 000031AD 3C6E                     cmp al, 110
  4320 000031AF 0F850900                 jne @@prs201
  4321 000031B3 66B80A000000             mov eax, 10
  4322 000031B9 8846FE                   mov byte [bp-2], al
  4323                                  
  4324                                  ;-58                 if (c=='t') c= 9; 
  4325                                  
  4326                                  @@prs201:
  4327 000031BC 8A46FE                   mov al, [bp-2]
  4328 000031BF 3C74                     cmp al, 116
  4329 000031C1 0F850900                 jne @@prs202
  4330 000031C5 66B809000000             mov eax, 9
  4331 000031CB 8846FE                   mov byte [bp-2], al
  4332                                  
  4333                                  ;-59             } 
  4334                                  
  4335                                  @@prs202:
  4336                                  
  4337                                  ;-60         } 
  4338                                  
  4339                                  @@prs200:
  4340                                  
  4341                                  ;-61         prc(c); 
  4342                                  
  4343                                  @@prs199:
  4344 000031CE 8A46FE                   mov al, byte [bp-2]
  4345 000031D1 B400                     mov ah, 0
  4346 000031D3 50                       push ax
  4347 000031D4 E807FF                   call prc
  4348 000031D7 83C402                   add  sp, 2
  4349                                  
  4350                                  ;-62         s++;  
  4351                                  
  4352 000031DA FF4604                   inc  word [bp+4]
  4353                                  
  4354                                  ;-63     }
  4355                                  
  4356                                  
  4357                                  ;-64 }
  4358                                  
  4359 000031DD E96CFF                   jmp @@prs194
  4360                                  @@prs195:
  4361                                  
  4362                                  ;-65 int printhex8a(unsigned char c) { 
  4363 000031E0 C9                       LEAVE
  4364 000031E1 C3                       ret
  4365                                  ; ENDP
  4366                                  
  4367                                  printhex8a:  ; *** PROC ***
  4368                                  
  4369                                  ;-66     unsigned char nib;
  4370                                  
  4371                                  
  4372                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4373                                  
  4374                                  ;Function : printhex8a, Number of local variables: 2
  4375                                  ;   # type sign width line used address name   list of local variables
  4376                                  ;  200 var unsg byte    65 NULL bp+4    c
  4377                                  ;  201 var unsg byte    66 NULL bp-2    nib;
  4378 000031E2 C8020000                 ENTER  2,0
  4379 000031E6 8A4604                   mov al, [bp+4]
  4380 000031E9 C0E804                   shr al, 4
  4381 000031EC 8846FE                   mov byte [bp-2], al
  4382 000031EF 8A46FE                   mov al, byte [bp-2]
  4383 000031F2 B400                     mov ah, 0
  4384 000031F4 50                       push ax
  4385 000031F5 E81900                   call printhex4
  4386 000031F8 83C402                   add  sp, 2
  4387                                  
  4388                                  ;-68     nib = c & 15; printhex4(nib);                    
  4389                                  
  4390 000031FB 8A4604                   mov al, [bp+4]
  4391 000031FE 240F                     and al, 15
  4392 00003200 8846FE                   mov byte [bp-2], al
  4393 00003203 8A46FE                   mov al, byte [bp-2]
  4394 00003206 B400                     mov ah, 0
  4395 00003208 50                       push ax
  4396 00003209 E80500                   call printhex4
  4397 0000320C 83C402                   add  sp, 2
  4398                                  
  4399                                  ;-69 } 
  4400                                  
  4401                                  
  4402                                  ;-70 int printhex4(unsigned char c) {
  4403 0000320F C9                       LEAVE
  4404 00003210 C3                       ret
  4405                                  ; ENDP
  4406                                  
  4407                                  printhex4:  ; *** PROC ***
  4408                                  
  4409                                  ;-71     c += 48; 
  4410                                  
  4411                                  ;Function : printhex4, Number of local variables: 1
  4412                                  ;   # type sign width line used address name   list of local variables
  4413                                  ;  200 var unsg byte    70 NULL bp+4    c;
  4414 00003211 C8000000                 ENTER  0,0
  4415 00003215 80460430                 add  byte [bp+4], 48
  4416                                  
  4417                                  ;-72     if (c > 57) c += 7; 
  4418                                  
  4419 00003219 8A4604                   mov al, [bp+4]
  4420 0000321C 3C39                     cmp al, 57
  4421 0000321E 0F8E0400                 jle @@printhex4203
  4422 00003222 80460407                 add  byte [bp+4], 7
  4423                                  
  4424                                  ;-73     prc(c);      
  4425                                  
  4426                                  @@printhex4203:
  4427 00003226 8A4604                   mov al, byte [bp+4]
  4428 00003229 B400                     mov ah, 0
  4429 0000322B 50                       push ax
  4430 0000322C E8AFFE                   call prc
  4431 0000322F 83C402                   add  sp, 2
  4432                                  
  4433                                  ;-74 }
  4434                                  
  4435                                  
  4436                                  ;-75 int printhex16(unsigned int i) {
  4437 00003232 C9                       LEAVE
  4438 00003233 C3                       ret
  4439                                  ; ENDP
  4440                                  
  4441                                  printhex16:  ; *** PROC ***
  4442                                  
  4443                                  ;-76     unsigned int half;
  4444                                  
  4445                                  
  4446                                  ;-77     half = i >>  8; printhex8a(half); 
  4447                                  
  4448                                  ;Function : printhex16, Number of local variables: 2
  4449                                  ;   # type sign width line used address name   list of local variables
  4450                                  ;  200 var unsg word    75 NULL bp+4    i
  4451                                  ;  201 var unsg word    76 NULL bp-2    half;
  4452 00003234 C8020000                 ENTER  2,0
  4453 00003238 8B4604                   mov ax, [bp+4]
  4454 0000323B C1E808                   shr ax, 8
  4455 0000323E 8946FE                   mov word [bp-2], ax
  4456 00003241 FF76FE                   push word [bp-2]
  4457 00003244 E89BFF                   call printhex8a
  4458 00003247 83C402                   add  sp, 2
  4459                                  
  4460                                  ;-78     half = i & 255; printhex8a(half);
  4461                                  
  4462 0000324A 8B4604                   mov ax, [bp+4]
  4463 0000324D 25FF00                   and ax, 255
  4464 00003250 8946FE                   mov word [bp-2], ax
  4465 00003253 FF76FE                   push word [bp-2]
  4466 00003256 E889FF                   call printhex8a
  4467 00003259 83C402                   add  sp, 2
  4468                                  
  4469                                  ;-79 }
  4470                                  
  4471                                  
  4472                                  ;-80 int printIntU(unsigned int n) { 
  4473 0000325C C9                       LEAVE
  4474 0000325D C3                       ret
  4475                                  ; ENDP
  4476                                  
  4477                                  printIntU:  ; *** PROC ***
  4478                                  
  4479                                  ;-81     unsigned int e;
  4480                                  
  4481                                  
  4482                                  ;-82     if ( _ n >= 10) {  
  4483                                  
  4484                                  ;Function : printIntU, Number of local variables: 2
  4485                                  ;   # type sign width line used address name   list of local variables
  4486                                  ;  200 var unsg word    80 NULL bp+4    n
  4487                                  ;  201 var unsg word    81 NULL bp-2    e;
  4488 0000325E C8020000                 ENTER  2,0
  4489 00003262 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4490 00003266 0F821700                 jb  @@printIntU204
  4491                                  
  4492                                  ;-83         e=n/10; //DIV
  4493                                  
  4494 0000326A 8B4604                   mov ax, [bp+4]
  4495 0000326D BB0A00                   mov bx, 10
  4496 00003270 BA0000                   mov dx, 0
  4497 00003273 F7F3                     div bx
  4498 00003275 8946FE                   mov word [bp-2], ax
  4499                                  
  4500                                  ;-84         printIntU(e); 
  4501                                  
  4502 00003278 FF76FE                   push word [bp-2]
  4503 0000327B E8E0FF                   call printIntU
  4504 0000327E 83C402                   add  sp, 2
  4505                                  
  4506                                  ;-85     }
  4507                                  
  4508                                  
  4509                                  ;-86     n = n % 10; //unsigned mod
  4510                                  
  4511                                  @@printIntU204:
  4512 00003281 8B4604                   mov ax, [bp+4]
  4513 00003284 BB0A00                   mov bx, 10
  4514 00003287 BA0000                   mov dx, 0
  4515 0000328A F7F3                     div bx
  4516 0000328C 89D0                     mov ax, dx
  4517 0000328E 894604                   mov word [bp+4], ax
  4518                                  
  4519                                  ;-87     n += '0'; 
  4520                                  
  4521 00003291 83460430                 add  word [bp+4], 48
  4522                                  
  4523                                  ;-88     prc(n);
  4524                                  
  4525 00003295 FF7604                   push word [bp+4]
  4526 00003298 E843FE                   call prc
  4527 0000329B 83C402                   add  sp, 2
  4528                                  
  4529                                  ;-89 }
  4530                                  
  4531                                  
  4532                                  ;-90 
  4533                                  
  4534                                  
  4535                                  ;-91 int error1(char *s) { 
  4536 0000329E C9                       LEAVE
  4537 0000329F C3                       ret
  4538                                  ; ENDP
  4539                                  
  4540                                  error1:  ; *** PROC ***
  4541                                  
  4542                                  ;-92     LIST=1; 
  4543                                  
  4544                                  ;Function : error1, Number of local variables: 1
  4545                                  ;   # type sign width line used address name   list of local variables
  4546                                  ;  200 ptr sign byte    91 NULL bp+4    s;
  4547 000032A0 C8000000                 ENTER  0,0
  4548 000032A4 66B801000000             mov eax, 1
  4549 000032AA A2[0E00]                 mov byte [LIST], al
  4550                                  
  4551                                  ;-93     ErrorCount++;
  4552                                  
  4553 000032AD FF06[A101]               inc  word [ErrorCount]
  4554                                  
  4555                                  ;-94     prs("\n;***** next line ERROR: "); 
  4556                                  
  4557 000032B1 68[D932]                 push error1_0
  4558 000032B4 E888FE                   call prs
  4559 000032B7 83C402                   add  sp, 2
  4560                                  
  4561                                  ;-95     prs(s);
  4562                                  
  4563 000032BA FF7604                   push word [bp+4]
  4564 000032BD E87FFE                   call prs
  4565 000032C0 83C402                   add  sp, 2
  4566                                  
  4567                                  ;-96     prs(", Symbol: "); 
  4568                                  
  4569 000032C3 68[F432]                 push error1_1
  4570 000032C6 E876FE                   call prs
  4571 000032C9 83C402                   add  sp, 2
  4572                                  
  4573                                  ;-97     prs(Symbol);
  4574                                  
  4575 000032CC 8D06[0F00]               lea  ax, [Symbol]
  4576 000032D0 50                       push ax
  4577 000032D1 E86BFE                   call prs
  4578 000032D4 83C402                   add  sp, 2
  4579                                  
  4580                                  ;-98 }
  4581                                  
  4582                                  
  4583                                  ;-99 int errorexit(char *s) { 
  4584 000032D7 C9                       LEAVE
  4585 000032D8 C3                       ret
  4586                                  ; ENDP
  4587 000032D9 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4588 000032E2 6E657874206C696E65-
  4589 000032EB 204552524F523A2000 
  4590 000032F4 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4591 000032FD 2000               
  4592                                  
  4593                                  errorexit:  ; *** PROC ***
  4594                                  
  4595                                  ;-100     error1(s); 
  4596                                  
  4597                                  ;Function : errorexit, Number of local variables: 1
  4598                                  ;   # type sign width line used address name   list of local variables
  4599                                  ;  200 ptr sign byte    99 NULL bp+4    s;
  4600 000032FF C8000000                 ENTER  0,0
  4601 00003303 FF7604                   push word [bp+4]
  4602 00003306 E897FF                   call error1
  4603 00003309 83C402                   add  sp, 2
  4604                                  
  4605                                  ;-101     end1(1);
  4606                                  
  4607 0000330C 6A01                     push 1
  4608 0000330E E81306                   call end1
  4609 00003311 83C402                   add  sp, 2
  4610                                  
  4611                                  ;-102 }
  4612                                  
  4613                                  
  4614                                  ;-103 int allowederror() {error1("not allowed here"); }
  4615 00003314 C9                       LEAVE
  4616 00003315 C3                       ret
  4617                                  ; ENDP
  4618                                  
  4619                                  allowederror:  ; *** PROC ***
  4620 00003316 68[2033]                 push allowederror_0
  4621 00003319 E884FF                   call error1
  4622 0000331C 83C402                   add  sp, 2
  4623                                  
  4624                                  ;-104 int addrerror()    {error1("address missing");} 
  4625                                  
  4626 0000331F C3                       ret
  4627                                  ; ENDP
  4628 00003320 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4629 00003329 6564206865726500   
  4630                                  
  4631                                  addrerror:  ; *** PROC ***
  4632 00003331 68[3B33]                 push addrerror_0
  4633 00003334 E869FF                   call error1
  4634 00003337 83C402                   add  sp, 2
  4635                                  
  4636                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4637                                  
  4638 0000333A C3                       ret
  4639                                  ; ENDP
  4640 0000333B 61646472657373206D-     addrerror_0 db "address missing",0
  4641 00003344 697373696E6700     
  4642                                  
  4643                                  immeerror:  ; *** PROC ***
  4644 0000334B 68[5533]                 push immeerror_0
  4645 0000334E E84FFF                   call error1
  4646 00003351 83C402                   add  sp, 2
  4647                                  
  4648                                  ;-106 int implerror()    {error1("not implemented");}
  4649                                  
  4650 00003354 C3                       ret
  4651                                  ; ENDP
  4652 00003355 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4653 0000335E 206E6F7420616C6C6F-
  4654 00003367 776564206865726500 
  4655                                  
  4656                                  implerror:  ; *** PROC ***
  4657 00003370 68[7A33]                 push implerror_0
  4658 00003373 E82AFF                   call error1
  4659 00003376 83C402                   add  sp, 2
  4660                                  
  4661                                  ;-107 int indexerror()   {error1("invalid index register");}
  4662                                  
  4663 00003379 C3                       ret
  4664                                  ; ENDP
  4665 0000337A 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4666 00003383 6D656E74656400     
  4667                                  
  4668                                  indexerror:  ; *** PROC ***
  4669 0000338A 68[9433]                 push indexerror_0
  4670 0000338D E810FF                   call error1
  4671 00003390 83C402                   add  sp, 2
  4672                                  
  4673                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4674                                  
  4675 00003393 C3                       ret
  4676                                  ; ENDP
  4677 00003394 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4678 0000339D 6E6465782072656769-
  4679 000033A6 7374657200         
  4680                                  
  4681                                  invaloperror:  ; *** PROC ***
  4682 000033AB 68[B533]                 push invaloperror_0
  4683 000033AE E8EFFE                   call error1
  4684 000033B1 83C402                   add  sp, 2
  4685                                  
  4686                                  ;-109 int numbererror()  {error1("number expected");}
  4687                                  
  4688 000033B4 C3                       ret
  4689                                  ; ENDP
  4690 000033B5 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4691 000033BE 72206E6F206F706572-
  4692 000033C7 616E647300         
  4693                                  
  4694                                  numbererror:  ; *** PROC ***
  4695 000033CC 68[D633]                 push numbererror_0
  4696 000033CF E8CEFE                   call error1
  4697 000033D2 83C402                   add  sp, 2
  4698                                  
  4699                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4700                                  
  4701 000033D5 C3                       ret
  4702                                  ; ENDP
  4703 000033D6 6E756D626572206578-     numbererror_0 db "number expected",0
  4704 000033DF 70656374656400     
  4705                                  
  4706                                  regmemerror:  ; *** PROC ***
  4707 000033E6 68[F033]                 push regmemerror_0
  4708 000033E9 E8B4FE                   call error1
  4709 000033EC 83C402                   add  sp, 2
  4710                                  
  4711                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4712                                  
  4713 000033EF C3                       ret
  4714                                  ; ENDP
  4715 000033F0 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4716 000033F9 73746572206F72206D-
  4717 00003402 656D6F727920616C6C-
  4718 0000340B 6F77656400         
  4719                                  
  4720                                  reg16error:  ; *** PROC ***
  4721 00003410 68[1A34]                 push reg16error_0
  4722 00003413 E88AFE                   call error1
  4723 00003416 83C402                   add  sp, 2
  4724                                  
  4725                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4726                                  
  4727 00003419 C3                       ret
  4728                                  ; ENDP
  4729 0000341A 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4730 00003423 362C206E6F20736567-
  4731 0000342C 72656720616C6C6F77-
  4732 00003435 656400             
  4733                                  
  4734                                  segregerror:  ; *** PROC ***
  4735 00003438 68[4234]                 push segregerror_0
  4736 0000343B E862FE                   call error1
  4737 0000343E 83C402                   add  sp, 2
  4738                                  
  4739                                  ;-113 int syntaxerror()  {error1("syntax");}
  4740                                  
  4741 00003441 C3                       ret
  4742                                  ; ENDP
  4743 00003442 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4744 0000344B 65676973746572206E-
  4745 00003454 6F7420616C6C6F7765-
  4746 0000345D 6400               
  4747                                  
  4748                                  syntaxerror:  ; *** PROC ***
  4749 0000345F 68[6934]                 push syntaxerror_0
  4750 00003462 E83BFE                   call error1
  4751 00003465 83C402                   add  sp, 2
  4752                                  
  4753                                  ;-114          
  4754                                  
  4755                                  
  4756                                  ;-115 int addrexit()     {errorexit("illegal address");}   
  4757                                  
  4758 00003468 C3                       ret
  4759                                  ; ENDP
  4760 00003469 73796E74617800          syntaxerror_0 db "syntax",0
  4761                                  
  4762                                  addrexit:  ; *** PROC ***
  4763 00003470 68[7A34]                 push addrexit_0
  4764 00003473 E889FE                   call errorexit
  4765 00003476 83C402                   add  sp, 2
  4766                                  
  4767                                  ;-116 int dataexit()     {errorexit("DB,DW,DD or RESB,W,D expected");}
  4768                                  
  4769 00003479 C3                       ret
  4770                                  ; ENDP
  4771 0000347A 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4772 00003483 64647265737300     
  4773                                  
  4774                                  dataexit:  ; *** PROC ***
  4775 0000348A 68[9434]                 push dataexit_0
  4776 0000348D E86FFE                   call errorexit
  4777 00003490 83C402                   add  sp, 2
  4778                                  
  4779                                  ;-117 int internexit()   {errorexit("intern compiler error");}
  4780                                  
  4781 00003493 C3                       ret
  4782                                  ; ENDP
  4783 00003494 44422C44572C444420-     dataexit_0 db "DB,DW,DD or RESB,W,D expected",0
  4784 0000349D 6F7220524553422C57-
  4785 000034A6 2C4420657870656374-
  4786 000034AF 656400             
  4787                                  
  4788                                  internexit:  ; *** PROC ***
  4789 000034B2 68[BC34]                 push internexit_0
  4790 000034B5 E847FE                   call errorexit
  4791 000034B8 83C402                   add  sp, 2
  4792 000034BB C3                       ret
  4793                                  ; ENDP
  4794 000034BC 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4795 000034C5 6D70696C6572206572-
  4796 000034CE 726F7200           
  4797                                  ;Back to main program: AS.C
  4798                                  
  4799                                  ;-8 #include "MAIN.C"
  4800                                  
  4801                                  ;Use include file: MAIN.C
  4802                                  
  4803                                  ;-1 int main() {
  4804                                  
  4805                                  
  4806                                  main:  ; *** PROC ***
  4807                                  
  4808                                  ;-2     getarg(); 
  4809                                  
  4810 000034D2 E80D00                   call getarg
  4811                                  
  4812                                  ;-3     parse(); 
  4813                                  
  4814 000034D5 E8E7ED                   call parse
  4815                                  
  4816                                  ;-4     fixJmpCall();
  4817                                  
  4818 000034D8 E85F02                   call fixJmpCall
  4819                                  
  4820                                  ;-5     epilog(); 
  4821                                  
  4822 000034DB E84B03                   call epilog
  4823                                  
  4824                                  ;-6     end1();
  4825                                  
  4826 000034DE E84304                   call end1
  4827                                  
  4828                                  ;-7 }
  4829                                  
  4830                                  
  4831                                  ;-8 
  4832                                  
  4833                                  
  4834                                  ;-9 int getarg() { 
  4835                                  
  4836 000034E1 C3                       ret
  4837                                  ; ENDP
  4838                                  
  4839                                  getarg:  ; *** PROC ***
  4840                                  
  4841                                  ;-10     int arglen1; int i; char *c;
  4842                                  
  4843                                  
  4844                                  ;-11     arglen1=*arglen;
  4845                                  
  4846                                  ;Function : getarg, Number of local variables: 3
  4847                                  ;   # type sign width line used address name   list of local variables
  4848                                  ;  200 var sign word    10 NULL bp-2    arglen1
  4849                                  ;  201 var sign word    10 NULL bp-4    i
  4850                                  ;  202 ptr sign byte    10 NULL bp-6    c;
  4851 000034E2 C8060000                 ENTER  6,0
  4852 000034E6 8B1E[101A]               mov bx, [arglen]
  4853 000034EA 8A07                     mov al, [bx]
  4854 000034EC B400                     mov ah, 0
  4855 000034EE 8946FE                   mov word [bp-2], ax
  4856                                  
  4857                                  ;-12     if (arglen1==0) {
  4858                                  
  4859 000034F1 8B46FE                   mov ax, [bp-2]
  4860 000034F4 83F800                   cmp ax, 0
  4861 000034F7 0F851C00                 jne @@getarg205
  4862                                  
  4863                                  ;-13         cputs(Version1);
  4864                                  
  4865 000034FB 8D06[0300]               lea  ax, [Version1]
  4866 000034FF 50                       push ax
  4867 00003500 E8EC0D                   call cputs
  4868 00003503 83C402                   add  sp, 2
  4869                                  
  4870                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4871                                  
  4872 00003506 68[A736]                 push getarg_0
  4873 00003509 E8E30D                   call cputs
  4874 0000350C 83C402                   add  sp, 2
  4875                                  
  4876                                  ;-15         exitR(3);
  4877                                  
  4878 0000350F 6A03                     push 3
  4879 00003511 E8B60F                   call exitR
  4880 00003514 83C402                   add  sp, 2
  4881                                  
  4882                                  ;-16     }
  4883                                  
  4884                                  
  4885                                  ;-17     i=arglen1+129; 
  4886                                  
  4887                                  @@getarg205:
  4888 00003517 8B46FE                   mov ax, [bp-2]
  4889 0000351A 058100                   add ax, 129
  4890 0000351D 8946FC                   mov word [bp-4], ax
  4891                                  
  4892                                  ;-18     *i=0;  
  4893                                  
  4894 00003520 66B800000000             mov eax, 0
  4895 00003526 8B5EFC                   mov  bx, [bp-4]
  4896 00003529 8907                     mov  [bx], ax
  4897                                  
  4898                                  ;-19     arglen1--;
  4899                                  
  4900 0000352B FF4EFE                   dec  word [bp-2]
  4901                                  
  4902                                  ;-20     toupper(argv);
  4903                                  
  4904 0000352E FF36[121A]               push word [argv]
  4905 00003532 E8E80D                   call toupper
  4906 00003535 83C402                   add  sp, 2
  4907                                  
  4908                                  ;-21   
  4909                                  
  4910                                  
  4911                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  4912                                  
  4913 00003538 FF36[121A]               push word [argv]
  4914 0000353C 8D06[D000]               lea  ax, [namein]
  4915 00003540 50                       push ax
  4916 00003541 E8470E                   call strcpy
  4917 00003544 83C404                   add  sp, 4
  4918 00003547 68[CC36]                 push getarg_1
  4919 0000354A 8D06[D000]               lea  ax, [namein]
  4920 0000354E 50                       push ax
  4921 0000354F E8FA0E                   call strcat1
  4922 00003552 83C404                   add  sp, 4
  4923                                  
  4924                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  4925                                  
  4926 00003555 FF36[121A]               push word [argv]
  4927 00003559 8D06[1301]               lea  ax, [namelst]
  4928 0000355D 50                       push ax
  4929 0000355E E82A0E                   call strcpy
  4930 00003561 83C404                   add  sp, 4
  4931 00003564 68[CF36]                 push getarg_2
  4932 00003567 8D06[1301]               lea  ax, [namelst]
  4933 0000356B 50                       push ax
  4934 0000356C E8DD0E                   call strcat1
  4935 0000356F 83C404                   add  sp, 4
  4936                                  
  4937                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  4938                                  
  4939 00003572 FF36[121A]               push word [argv]
  4940 00003576 8D06[5601]               lea  ax, [namebin]
  4941 0000357A 50                       push ax
  4942 0000357B E80D0E                   call strcpy
  4943 0000357E 83C404                   add  sp, 4
  4944 00003581 68[D436]                 push getarg_3
  4945 00003584 8D06[5601]               lea  ax, [namebin]
  4946 00003588 50                       push ax
  4947 00003589 E8C00E                   call strcat1
  4948 0000358C 83C404                   add  sp, 4
  4949                                  
  4950                                  ;-25 
  4951                                  
  4952                                  
  4953                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4954                                  
  4955 0000358F 66B801000000             mov eax, 1
  4956 00003595 A2[0E00]                 mov byte [LIST], al
  4957 00003598 66B800000000             mov eax, 0
  4958 0000359E A3[9F01]                 mov word [DOS_ERR], ax
  4959 000035A1 66B800000000             mov eax, 0
  4960 000035A7 A3[A601]                 mov word [PC], ax
  4961 000035AA 66B800000000             mov eax, 0
  4962 000035B0 A3[A101]                 mov word [ErrorCount], ax
  4963                                  
  4964                                  ;-27   
  4965                                  
  4966                                  
  4967                                  ;-28     asm_fd=openR (namein);
  4968                                  
  4969 000035B3 8D06[D000]               lea  ax, [namein]
  4970 000035B7 50                       push ax
  4971 000035B8 E8B60E                   call openR
  4972 000035BB 83C402                   add  sp, 2
  4973 000035BE A3[9901]                 mov word [asm_fd], ax
  4974                                  
  4975                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4976                                  
  4977 000035C1 A1[9F01]                 mov ax, [DOS_ERR]
  4978 000035C4 08C0                     or  al, al
  4979 000035C6 0F841C00                 je @@getarg206
  4980 000035CA 68[D936]                 push getarg_4
  4981 000035CD E81F0D                   call cputs
  4982 000035D0 83C402                   add  sp, 2
  4983 000035D3 8D06[D000]               lea  ax, [namein]
  4984 000035D7 50                       push ax
  4985 000035D8 E8140D                   call cputs
  4986 000035DB 83C402                   add  sp, 2
  4987 000035DE 6A01                     push 1
  4988 000035E0 E8E70E                   call exitR
  4989 000035E3 83C402                   add  sp, 2
  4990                                  
  4991                                  ;-30     lst_fd=creatR(namelst);
  4992                                  
  4993                                  @@getarg206:
  4994 000035E6 8D06[1301]               lea  ax, [namelst]
  4995 000035EA 50                       push ax
  4996 000035EB E8920E                   call creatR
  4997 000035EE 83C402                   add  sp, 2
  4998 000035F1 A3[9B01]                 mov word [lst_fd], ax
  4999                                  
  5000                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  5001                                  
  5002 000035F4 A1[9F01]                 mov ax, [DOS_ERR]
  5003 000035F7 08C0                     or  al, al
  5004 000035F9 0F841C00                 je @@getarg207
  5005 000035FD 68[EF36]                 push getarg_5
  5006 00003600 E8EC0C                   call cputs
  5007 00003603 83C402                   add  sp, 2
  5008 00003606 8D06[1301]               lea  ax, [namelst]
  5009 0000360A 50                       push ax
  5010 0000360B E8E10C                   call cputs
  5011 0000360E 83C402                   add  sp, 2
  5012 00003611 6A02                     push 2
  5013 00003613 E8B40E                   call exitR
  5014 00003616 83C402                   add  sp, 2
  5015                                  
  5016                                  ;-32     bin_fd=creatR(namebin);
  5017                                  
  5018                                  @@getarg207:
  5019 00003619 8D06[5601]               lea  ax, [namebin]
  5020 0000361D 50                       push ax
  5021 0000361E E85F0E                   call creatR
  5022 00003621 83C402                   add  sp, 2
  5023 00003624 A3[9D01]                 mov word [bin_fd], ax
  5024                                  
  5025                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  5026                                  
  5027 00003627 A1[9F01]                 mov ax, [DOS_ERR]
  5028 0000362A 08C0                     or  al, al
  5029 0000362C 0F841C00                 je @@getarg208
  5030 00003630 68[0637]                 push getarg_6
  5031 00003633 E8B90C                   call cputs
  5032 00003636 83C402                   add  sp, 2
  5033 00003639 8D06[5601]               lea  ax, [namebin]
  5034 0000363D 50                       push ax
  5035 0000363E E8AE0C                   call cputs
  5036 00003641 83C402                   add  sp, 2
  5037 00003644 6A02                     push 2
  5038 00003646 E8810E                   call exitR
  5039 00003649 83C402                   add  sp, 2
  5040                                  
  5041                                  ;-34   
  5042                                  
  5043                                  
  5044                                  ;-35     prs(";"); 
  5045                                  
  5046                                  @@getarg208:
  5047 0000364C 68[1C37]                 push getarg_7
  5048 0000364F E8EDFA                   call prs
  5049 00003652 83C402                   add  sp, 2
  5050                                  
  5051                                  ;-36     prs(Version1);
  5052                                  
  5053 00003655 8D06[0300]               lea  ax, [Version1]
  5054 00003659 50                       push ax
  5055 0000365A E8E2FA                   call prs
  5056 0000365D 83C402                   add  sp, 2
  5057                                  
  5058                                  ;-37     prs(", Source: "); prs(namein);  
  5059                                  
  5060 00003660 68[1E37]                 push getarg_8
  5061 00003663 E8D9FA                   call prs
  5062 00003666 83C402                   add  sp, 2
  5063 00003669 8D06[D000]               lea  ax, [namein]
  5064 0000366D 50                       push ax
  5065 0000366E E8CEFA                   call prs
  5066 00003671 83C402                   add  sp, 2
  5067                                  
  5068                                  ;-38     prs(", Output: "); prs(namelst);
  5069                                  
  5070 00003674 68[2937]                 push getarg_9
  5071 00003677 E8C5FA                   call prs
  5072 0000367A 83C402                   add  sp, 2
  5073 0000367D 8D06[1301]               lea  ax, [namelst]
  5074 00003681 50                       push ax
  5075 00003682 E8BAFA                   call prs
  5076 00003685 83C402                   add  sp, 2
  5077                                  
  5078                                  ;-39     prs(", "); prs(namebin);
  5079                                  
  5080 00003688 68[3437]                 push getarg_10
  5081 0000368B E8B1FA                   call prs
  5082 0000368E 83C402                   add  sp, 2
  5083 00003691 8D06[5601]               lea  ax, [namebin]
  5084 00003695 50                       push ax
  5085 00003696 E8A6FA                   call prs
  5086 00003699 83C402                   add  sp, 2
  5087                                  
  5088                                  ;-40     prs("\n");
  5089                                  
  5090 0000369C 68[3737]                 push getarg_11
  5091 0000369F E89DFA                   call prs
  5092 000036A2 83C402                   add  sp, 2
  5093                                  
  5094                                  ;-41 }
  5095                                  
  5096                                  
  5097                                  ;-42 
  5098                                  
  5099                                  
  5100                                  ;-43 int fixJmpCall() {
  5101 000036A5 C9                       LEAVE
  5102 000036A6 C3                       ret
  5103                                  ; ENDP
  5104 000036A7 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5105 000036B0 41532E434F4D206669-
  5106 000036B9 6C656E616D65205B77-
  5107 000036C2 2F6F202E535D203A20-
  5108 000036CB 00                 
  5109 000036CC 2E5300                  getarg_1 db ".S",0
  5110 000036CF 2E4C535400              getarg_2 db ".LST",0
  5111 000036D4 2E434F4D00              getarg_3 db ".COM",0
  5112 000036D9 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5113 000036E2 6C65206D697373696E-
  5114 000036EB 673A2000           
  5115 000036EF 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5116 000036F8 206E6F742063726561-
  5117 00003701 74653A2000         
  5118 00003706 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5119 0000370F 6E6F74206372656174-
  5120 00003718 653A2000           
  5121 0000371C 3B00                    getarg_7 db ";",0
  5122 0000371E 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5123 00003727 2000               
  5124 00003729 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5125 00003732 2000               
  5126 00003734 2C2000                  getarg_10 db ", ",0
  5127 00003737 5C6E00                  getarg_11 db "\n",0
  5128                                  
  5129                                  fixJmpCall:  ; *** PROC ***
  5130                                  
  5131                                  ;-44     int i;  unsigned int hex;  char *p; int Ix; char c;
  5132                                  
  5133                                  
  5134                                  ;-45     i=1;     
  5135                                  
  5136                                  ;Function : fixJmpCall, Number of local variables: 5
  5137                                  ;   # type sign width line used address name   list of local variables
  5138                                  ;  200 var sign word    44 NULL bp-2    i
  5139                                  ;  201 var unsg word    44 NULL bp-4    hex
  5140                                  ;  202 ptr sign byte    44 NULL bp-6    p
  5141                                  ;  203 var sign word    44 NULL bp-8    Ix
  5142                                  ;  204 var sign byte    44 NULL bp-10    c;
  5143 0000373A C80A0000                 ENTER  10,0
  5144 0000373E 66B801000000             mov eax, 1
  5145 00003744 8946FE                   mov word [bp-2], ax
  5146                                  
  5147                                  ;-46     prs("\n;END open jmp/call: "); 
  5148                                  
  5149 00003747 68[0238]                 push fixJmpCall_0
  5150 0000374A E8F2F9                   call prs
  5151 0000374D 83C402                   add  sp, 2
  5152                                  
  5153                                  ;-47     printIntU(JmpCallMaxIx);      
  5154                                  
  5155 00003750 FF36[3C12]               push word [JmpCallMaxIx]
  5156 00003754 E807FB                   call printIntU
  5157 00003757 83C402                   add  sp, 2
  5158                                  
  5159                                  ;-48     p = &JmpCallNames;   
  5160                                  
  5161 0000375A B8[8206]                 mov ax, JmpCallNames
  5162 0000375D 8946FA                   mov word [bp-6], ax
  5163                                  
  5164                                  ;-49     while (i <= JmpCallMaxIx) {
  5165                                  
  5166                                  @@fixJmpCall209:
  5167 00003760 8B46FE                   mov ax, [bp-2]
  5168 00003763 3B06[3C12]               cmp ax, [JmpCallMaxIx]
  5169 00003767 0F8F9500                 jg  @@fixJmpCall210
  5170                                  
  5171                                  ;-50         strcpy(Symbol, p);
  5172                                  
  5173 0000376B FF76FA                   push word [bp-6]
  5174 0000376E 8D06[0F00]               lea  ax, [Symbol]
  5175 00003772 50                       push ax
  5176 00003773 E8150C                   call strcpy
  5177 00003776 83C404                   add  sp, 4
  5178                                  
  5179                                  ;-51         p = strlen(Symbol) + p;
  5180                                  
  5181 00003779 8D06[0F00]               lea  ax, [Symbol]
  5182 0000377D 50                       push ax
  5183 0000377E E8DF0B                   call strlen
  5184 00003781 83C402                   add  sp, 2
  5185 00003784 0346FA                   add ax, [bp-6]
  5186 00003787 8946FA                   mov word [bp-6], ax
  5187                                  
  5188                                  ;-52         p++;
  5189                                  
  5190 0000378A FF46FA                   inc  word [bp-6]
  5191                                  
  5192                                  ;-53 //        prs(Symbol);
  5193                                  
  5194                                  
  5195                                  ;-54 //        prc(' ');  
  5196                                  
  5197                                  
  5198                                  ;-55         hex = JmpCallAddr[i];
  5199                                  
  5200 0000378D 8B5EFE                   mov bx, [bp-2]
  5201 00003790 D1E3                     shl bx, 1
  5202 00003792 8B87[540E]               mov ax, [JmpCallAddr + bx]
  5203 00003796 8946FC                   mov word [bp-4], ax
  5204                                  
  5205                                  ;-56 //        printhex16(hex);
  5206                                  
  5207                                  
  5208                                  ;-57             
  5209                                  
  5210                                  
  5211                                  ;-58         Ix=searchLabel();
  5212                                  
  5213 00003799 E8F6ED                   call searchLabel
  5214 0000379C 8946F8                   mov word [bp-8], ax
  5215                                  
  5216                                  ;-59         if (Ix == 0) error1("Label not found");
  5217                                  
  5218 0000379F 8B46F8                   mov ax, [bp-8]
  5219 000037A2 83F800                   cmp ax, 0
  5220 000037A5 0F850900                 jne @@fixJmpCall211
  5221 000037A9 68[1938]                 push fixJmpCall_1
  5222 000037AC E8F1FA                   call error1
  5223 000037AF 83C402                   add  sp, 2
  5224                                  
  5225                                  ;-60         disp = LabelAddr[Ix];
  5226                                  
  5227                                  @@fixJmpCall211:
  5228 000037B2 8B5EF8                   mov bx, [bp-8]
  5229 000037B5 D1E3                     shl bx, 1
  5230 000037B7 8B87[B605]               mov ax, [LabelAddr + bx]
  5231 000037BB A3[BE01]                 mov word [disp], ax
  5232                                  
  5233                                  ;-61         disp = disp - hex;
  5234                                  
  5235 000037BE A1[BE01]                 mov ax, [disp]
  5236 000037C1 2B46FC                   sub ax, [bp-4]
  5237 000037C4 A3[BE01]                 mov word [disp], ax
  5238                                  
  5239                                  ;-62         disp = disp - Origin;
  5240                                  
  5241 000037C7 A1[BE01]                 mov ax, [disp]
  5242 000037CA 2B06[A801]               sub ax, [Origin]
  5243 000037CE A3[BE01]                 mov word [disp], ax
  5244                                  
  5245                                  ;-63 //        prs(", ");    
  5246                                  
  5247                                  
  5248                                  ;-64         
  5249                                  
  5250                                  
  5251                                  ;-65             hex = hex - 2;//fix at start of word              
  5252                                  
  5253 000037D1 8B46FC                   mov ax, [bp-4]
  5254 000037D4 83E802                   sub ax, 2
  5255 000037D7 8946FC                   mov word [bp-4], ax
  5256                                  
  5257                                  ;-66             FileBin[hex] = disp;//fix low byte    
  5258                                  
  5259 000037DA A1[BE01]                 mov ax, [disp]
  5260 000037DD 8B5EFC                   mov bx, [bp-4]
  5261 000037E0 8887[3E12]               mov [FileBin+bx], al
  5262                                  
  5263                                  ;-67             hex++;
  5264                                  
  5265 000037E4 FF46FC                   inc  word [bp-4]
  5266                                  
  5267                                  ;-68             disp = disp >> 8;
  5268                                  
  5269 000037E7 A1[BE01]                 mov ax, [disp]
  5270 000037EA C1E808                   shr ax, 8
  5271 000037ED A3[BE01]                 mov word [disp], ax
  5272                                  
  5273                                  ;-69             FileBin[hex] = disp;            
  5274                                  
  5275 000037F0 A1[BE01]                 mov ax, [disp]
  5276 000037F3 8B5EFC                   mov bx, [bp-4]
  5277 000037F6 8887[3E12]               mov [FileBin+bx], al
  5278                                  
  5279                                  ;-70         i++;
  5280                                  
  5281 000037FA FF46FE                   inc  word [bp-2]
  5282                                  
  5283                                  ;-71     }
  5284                                  
  5285                                  
  5286                                  ;-72 }
  5287                                  
  5288 000037FD E960FF                   jmp @@fixJmpCall209
  5289                                  @@fixJmpCall210:
  5290                                  
  5291                                  ;-73 
  5292                                  
  5293                                  
  5294                                  ;-74 int epilog() { 
  5295 00003800 C9                       LEAVE
  5296 00003801 C3                       ret
  5297                                  ; ENDP
  5298 00003802 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5299 0000380B 656E206A6D702F6361-
  5300 00003814 6C6C3A2000         
  5301 00003819 4C6162656C206E6F74-     fixJmpCall_1 db "Label not found",0
  5302 00003822 20666F756E6400     
  5303                                  
  5304                                  epilog:  ; *** PROC ***
  5305                                  
  5306                                  ;-75     unsigned int i; char c;     int j;
  5307                                  
  5308                                  
  5309                                  ;-76     prs(". Errors: "); 
  5310                                  
  5311                                  ;Function : epilog, Number of local variables: 3
  5312                                  ;   # type sign width line used address name   list of local variables
  5313                                  ;  200 var unsg word    75 NULL bp-2    i
  5314                                  ;  201 var sign byte    75 NULL bp-4    c
  5315                                  ;  202 var sign word    75 NULL bp-6    j;
  5316 00003829 C8060000                 ENTER  6,0
  5317 0000382D 68[E738]                 push epilog_0
  5318 00003830 E80CF9                   call prs
  5319 00003833 83C402                   add  sp, 2
  5320                                  
  5321                                  ;-77     printIntU(ErrorCount);
  5322                                  
  5323 00003836 FF36[A101]               push word [ErrorCount]
  5324 0000383A E821FA                   call printIntU
  5325 0000383D 83C402                   add  sp, 2
  5326                                  
  5327                                  ;-78     if (ErrorCount) prs(" ***ERROR*** ");
  5328                                  
  5329 00003840 A1[A101]                 mov ax, [ErrorCount]
  5330 00003843 08C0                     or  al, al
  5331 00003845 0F840900                 je @@epilog212
  5332 00003849 68[F238]                 push epilog_1
  5333 0000384C E8F0F8                   call prs
  5334 0000384F 83C402                   add  sp, 2
  5335                                  
  5336                                  ;-79     prs(", Out: "); 
  5337                                  
  5338                                  @@epilog212:
  5339 00003852 68[0039]                 push epilog_2
  5340 00003855 E8E7F8                   call prs
  5341 00003858 83C402                   add  sp, 2
  5342                                  
  5343                                  ;-80     prs(namelst);
  5344                                  
  5345 0000385B 8D06[1301]               lea  ax, [namelst]
  5346 0000385F 50                       push ax
  5347 00003860 E8DCF8                   call prs
  5348 00003863 83C402                   add  sp, 2
  5349                                  
  5350                                  ;-81     prs(", ");
  5351                                  
  5352 00003866 68[0839]                 push epilog_3
  5353 00003869 E8D3F8                   call prs
  5354 0000386C 83C402                   add  sp, 2
  5355                                  
  5356                                  ;-82     prs(namebin); 
  5357                                  
  5358 0000386F 8D06[5601]               lea  ax, [namebin]
  5359 00003873 50                       push ax
  5360 00003874 E8C8F8                   call prs
  5361 00003877 83C402                   add  sp, 2
  5362                                  
  5363                                  ;-83     prs("= ");
  5364                                  
  5365 0000387A 68[0B39]                 push epilog_4
  5366 0000387D E8BFF8                   call prs
  5367 00003880 83C402                   add  sp, 2
  5368                                  
  5369                                  ;-84     printIntU(BinLen); 
  5370                                  
  5371 00003883 FF36[0E1A]               push word [BinLen]
  5372 00003887 E8D4F9                   call printIntU
  5373 0000388A 83C402                   add  sp, 2
  5374                                  
  5375                                  ;-85     prs(" bytes.");
  5376                                  
  5377 0000388D 68[0E39]                 push epilog_5
  5378 00003890 E8ACF8                   call prs
  5379 00003893 83C402                   add  sp, 2
  5380                                  
  5381                                  ;-86 
  5382                                  
  5383                                  
  5384                                  ;-87     i=0;
  5385                                  
  5386 00003896 66B800000000             mov eax, 0
  5387 0000389C 8946FE                   mov word [bp-2], ax
  5388                                  
  5389                                  ;-88     do {
  5390                                  
  5391                                  @@epilog213:
  5392                                  
  5393                                  ;-89         c = FileBin[i];
  5394                                  
  5395 0000389F 8B5EFE                   mov bx, [bp-2]
  5396 000038A2 8A87[3E12]               mov al, [FileBin + bx]
  5397 000038A6 8846FC                   mov byte [bp-4], al
  5398                                  
  5399                                  ;-90         fputcR(c, bin_fd);  
  5400                                  
  5401 000038A9 FF36[9D01]               push word [bin_fd]
  5402 000038AD 8A46FC                   mov al, byte [bp-4]
  5403 000038B0 B400                     mov ah, 0
  5404 000038B2 50                       push ax
  5405 000038B3 E8F10B                   call fputcR
  5406 000038B6 83C404                   add  sp, 4
  5407                                  
  5408                                  ;-91 //printhex8a(c); prc(' ');      
  5409                                  
  5410                                  
  5411                                  ;-92         i++;
  5412                                  
  5413 000038B9 FF46FE                   inc  word [bp-2]
  5414                                  
  5415                                  ;-93     } while (i < BinLen);
  5416                                  
  5417 000038BC 8B46FE                   mov ax, [bp-2]
  5418 000038BF 3B06[0E1A]               cmp ax, [BinLen]
  5419 000038C3 0F8D0200                 jge @@epilog214
  5420 000038C7 EBD6                     jmp @@epilog213
  5421                                  @@epilog214:
  5422                                  
  5423                                  ;-94 
  5424                                  
  5425                                  
  5426                                  ;-95   prs("\ Labels: "); 
  5427                                  
  5428 000038C9 68[1639]                 push epilog_6
  5429 000038CC E870F8                   call prs
  5430 000038CF 83C402                   add  sp, 2
  5431                                  
  5432                                  ;-96   printIntU(LabelMaxIx); 
  5433                                  
  5434 000038D2 FF36[7E06]               push word [LabelMaxIx]
  5435 000038D6 E885F9                   call printIntU
  5436 000038D9 83C402                   add  sp, 2
  5437                                  
  5438                                  ;-97   prs(". ");     
  5439                                  
  5440 000038DC 68[2139]                 push epilog_7
  5441 000038DF E85DF8                   call prs
  5442 000038E2 83C402                   add  sp, 2
  5443                                  
  5444                                  ;-98 /*  prs("size: ");
  5445                                  
  5446                                  
  5447                                  ;-99   i= &LabelNames; i=LabelNamePtr-i; printIntU(i); 
  5448                                  
  5449                                  
  5450                                  ;-100   prs(". >>");
  5451                                  
  5452                                  
  5453                                  ;-101   i= &LabelNames;
  5454                                  
  5455                                  
  5456                                  ;-102   do { c=*i; if (c==0) c=' '; prc(c); i++;
  5457                                  
  5458                                  
  5459                                  ;-103   } while (i < LabelNamePtr); prs("<< \n");  */
  5460                                  
  5461                                  
  5462                                  ;-104 /*    i = 1;
  5463                                  
  5464                                  
  5465                                  ;-105     LabelNamePtr= &LabelNames;
  5466                                  
  5467                                  
  5468                                  ;-106     do {
  5469                                  
  5470                                  
  5471                                  ;-107       prs(LabelNamePtr); prc(' ');
  5472                                  
  5473                                  
  5474                                  ;-108       j=LabelAddr[i]; printhex16(j); prs(", ");
  5475                                  
  5476                                  
  5477                                  ;-109       j=strlen(LabelNamePtr);//get end of actual name
  5478                                  
  5479                                  
  5480                                  ;-110       LabelNamePtr=LabelNamePtr+j;
  5481                                  
  5482                                  
  5483                                  ;-111       LabelNamePtr++;
  5484                                  
  5485                                  
  5486                                  ;-112       i++;
  5487                                  
  5488                                  
  5489                                  ;-113     } while (i <= LabelMaxIx);
  5490                                  
  5491                                  
  5492                                  ;-114 */
  5493                                  
  5494                                  
  5495                                  ;-115 }
  5496                                  
  5497                                  
  5498                                  ;-116 
  5499                                  
  5500                                  
  5501                                  ;-117 int end1(int n) {
  5502 000038E5 C9                       LEAVE
  5503 000038E6 C3                       ret
  5504                                  ; ENDP
  5505 000038E7 2E204572726F72733A-     epilog_0 db ". Errors: ",0
  5506 000038F0 2000               
  5507 000038F2 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5508 000038FB 2A2A2A2000         
  5509 00003900 2C204F75743A2000        epilog_2 db ", Out: ",0
  5510 00003908 2C2000                  epilog_3 db ", ",0
  5511 0000390B 3D2000                  epilog_4 db "= ",0
  5512 0000390E 2062797465732E00        epilog_5 db " bytes.",0
  5513 00003916 5C204C6162656C733A-     epilog_6 db "\ Labels: ",0
  5514 0000391F 2000               
  5515 00003921 2E2000                  epilog_7 db ". ",0
  5516                                  
  5517                                  end1:  ; *** PROC ***
  5518                                  
  5519                                  ;-118     fcloseR(asm_fd);
  5520                                  
  5521                                  ;Function : end1, Number of local variables: 1
  5522                                  ;   # type sign width line used address name   list of local variables
  5523                                  ;  200 var sign word   117 NULL bp+4    n;
  5524 00003924 C8000000                 ENTER  0,0
  5525 00003928 FF36[9901]               push word [asm_fd]
  5526 0000392C E88D0B                   call fcloseR
  5527 0000392F 83C402                   add  sp, 2
  5528                                  
  5529                                  ;-119     fcloseR(lst_fd);
  5530                                  
  5531 00003932 FF36[9B01]               push word [lst_fd]
  5532 00003936 E8830B                   call fcloseR
  5533 00003939 83C402                   add  sp, 2
  5534                                  
  5535                                  ;-120     fcloseR(bin_fd);
  5536                                  
  5537 0000393C FF36[9D01]               push word [bin_fd]
  5538 00003940 E8790B                   call fcloseR
  5539 00003943 83C402                   add  sp, 2
  5540                                  
  5541                                  ;-121     exitR(n);
  5542                                  
  5543 00003946 FF7604                   push word [bp+4]
  5544 00003949 E87E0B                   call exitR
  5545 0000394C 83C402                   add  sp, 2
  5546                                  
  5547                                  ;-122 }
  5548 0000394F C9                       LEAVE
  5549 00003950 C3                       ret
  5550                                  ; ENDP
  5551                                  ;Back to main program: AS.C
  5552                                  
  5553                                  ;-9 #include "GENCODE.C"
  5554                                  
  5555                                  ;Use include file: GENCODE.C
  5556                                  
  5557                                  ;-1 // generate code
  5558                                  
  5559                                  
  5560                                  ;-2 int getCodes() {
  5561                                  
  5562                                  
  5563                                  getCodes:  ; *** PROC ***
  5564                                  
  5565                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5566                                  
  5567 00003951 FF06[C901]               inc  word [OpCodePtr]
  5568 00003955 8B1E[C901]               mov bx, [OpCodePtr]
  5569 00003959 8A07                     mov al, [bx]
  5570 0000395B B400                     mov ah, 0
  5571 0000395D A2[B101]                 mov byte [Code1], al
  5572                                  
  5573                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5574                                  
  5575 00003960 FF06[C901]               inc  word [OpCodePtr]
  5576 00003964 8B1E[C901]               mov bx, [OpCodePtr]
  5577 00003968 8A07                     mov al, [bx]
  5578 0000396A B400                     mov ah, 0
  5579 0000396C A2[B201]                 mov byte [Code2], al
  5580                                  
  5581                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5582                                  
  5583 0000396F FF06[C901]               inc  word [OpCodePtr]
  5584 00003973 8B1E[C901]               mov bx, [OpCodePtr]
  5585 00003977 8A07                     mov al, [bx]
  5586 00003979 B400                     mov ah, 0
  5587 0000397B A2[B301]                 mov byte [Code3], al
  5588                                  
  5589                                  ;-6 }
  5590                                  
  5591                                  
  5592                                  ;-7 int gen66h() {genCode8(0x66);
  5593                                  
  5594 0000397E C3                       ret
  5595                                  ; ENDP
  5596                                  
  5597                                  gen66h:  ; *** PROC ***
  5598 0000397F 6A66                     push 102
  5599 00003981 E83B00                   call genCode8
  5600 00003984 83C402                   add  sp, 2
  5601                                  
  5602                                  ;-8 }
  5603                                  
  5604                                  
  5605                                  ;-9 int genCode2(char c, char d) {
  5606                                  
  5607 00003987 C3                       ret
  5608                                  ; ENDP
  5609                                  
  5610                                  genCode2:  ; *** PROC ***
  5611                                  
  5612                                  ;-10     c = c + d;
  5613                                  
  5614                                  ;Function : genCode2, Number of local variables: 2
  5615                                  ;   # type sign width line used address name   list of local variables
  5616                                  ;  200 var sign byte     9 NULL bp+4    c
  5617                                  ;  201 var sign byte     9 NULL bp+6    d;
  5618 00003988 C8000000                 ENTER  0,0
  5619 0000398C 8A4604                   mov al, [bp+4]
  5620 0000398F 024606                   add al, [bp+6]
  5621 00003992 884604                   mov byte [bp+4], al
  5622                                  
  5623                                  ;-11     genCode8(c);
  5624                                  
  5625 00003995 8A4604                   mov al, byte [bp+4]
  5626 00003998 B400                     mov ah, 0
  5627 0000399A 50                       push ax
  5628 0000399B E82100                   call genCode8
  5629 0000399E 83C402                   add  sp, 2
  5630                                  
  5631                                  ;-12 }                             
  5632                                  
  5633                                  
  5634                                  ;-13 int genCodeW(char c) {
  5635 000039A1 C9                       LEAVE
  5636 000039A2 C3                       ret
  5637                                  ; ENDP
  5638                                  
  5639                                  genCodeW:  ; *** PROC ***
  5640                                  
  5641                                  ;-14     c = c + wflag;  
  5642                                  
  5643                                  ;Function : genCodeW, Number of local variables: 1
  5644                                  ;   # type sign width line used address name   list of local variables
  5645                                  ;  200 var sign byte    13 NULL bp+4    c;
  5646 000039A3 C8000000                 ENTER  0,0
  5647 000039A7 8A4604                   mov al, [bp+4]
  5648 000039AA 0206[B901]               add al, [wflag]
  5649 000039AE 884604                   mov byte [bp+4], al
  5650                                  
  5651                                  ;-15     genCode8(c);
  5652                                  
  5653 000039B1 8A4604                   mov al, byte [bp+4]
  5654 000039B4 B400                     mov ah, 0
  5655 000039B6 50                       push ax
  5656 000039B7 E80500                   call genCode8
  5657 000039BA 83C402                   add  sp, 2
  5658                                  
  5659                                  ;-16 }   
  5660                                  
  5661                                  
  5662                                  ;-17 int genCode8(char c) {
  5663 000039BD C9                       LEAVE
  5664 000039BE C3                       ret
  5665                                  ; ENDP
  5666                                  
  5667                                  genCode8:  ; *** PROC ***
  5668                                  
  5669                                  ;-18 //set: BinLen++, OpPrintIndex++
  5670                                  
  5671                                  
  5672                                  ;-19     FileBin[BinLen]=c;
  5673                                  
  5674                                  ;Function : genCode8, Number of local variables: 1
  5675                                  ;   # type sign width line used address name   list of local variables
  5676                                  ;  200 var sign byte    17 NULL bp+4    c;
  5677 000039BF C8000000                 ENTER  0,0
  5678 000039C3 8A4604                   mov al, [bp+4]
  5679 000039C6 8B1E[0E1A]               mov bx, [BinLen]
  5680 000039CA 8887[3E12]               mov [FileBin+bx], al
  5681                                  
  5682                                  ;-20     BinLen++;
  5683                                  
  5684 000039CE FF06[0E1A]               inc  word [BinLen]
  5685                                  
  5686                                  ;-21     PC++;
  5687                                  
  5688 000039D2 FF06[A601]               inc  word [PC]
  5689                                  
  5690                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5691                                  
  5692 000039D6 A1[0E1A]                 mov ax, [BinLen]
  5693 000039D9 3DD007                   cmp ax, 2000 ;unsigned : 0
  5694 000039DC 0F820900                 jb  @@genCode8215
  5695 000039E0 68[043A]                 push genCode8_0
  5696 000039E3 E819F9                   call errorexit
  5697 000039E6 83C402                   add  sp, 2
  5698                                  
  5699                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5700                                  
  5701                                  @@genCode8215:
  5702 000039E9 A1[C701]                 mov ax, [OpPrintIndex]
  5703 000039EC 83F805                   cmp ax, 5
  5704 000039EF 0F8D0F00                 jge @@genCode8216
  5705                                  
  5706                                  ;-24         OpPos[OpPrintIndex]=c;
  5707                                  
  5708 000039F3 8A4604                   mov al, [bp+4]
  5709 000039F6 8B1E[C701]               mov bx, [OpPrintIndex]
  5710 000039FA 8887[C201]               mov [OpPos+bx], al
  5711                                  
  5712                                  ;-25         OpPrintIndex++;
  5713                                  
  5714 000039FE FF06[C701]               inc  word [OpPrintIndex]
  5715                                  
  5716                                  ;-26     }
  5717                                  
  5718                                  
  5719                                  ;-27 }
  5720                                  
  5721                                  @@genCode8216:
  5722                                  
  5723                                  ;-28 int genCode16(unsigned int i) {
  5724 00003A02 C9                       LEAVE
  5725 00003A03 C3                       ret
  5726                                  ; ENDP
  5727 00003A04 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5728 00003A0D 746F6F206C6F6E6700 
  5729                                  
  5730                                  genCode16:  ; *** PROC ***
  5731                                  
  5732                                  ;-29     genCode8(i); i=i >> 8;
  5733                                  
  5734                                  ;Function : genCode16, Number of local variables: 1
  5735                                  ;   # type sign width line used address name   list of local variables
  5736                                  ;  200 var unsg word    28 NULL bp+4    i;
  5737 00003A16 C8000000                 ENTER  0,0
  5738 00003A1A FF7604                   push word [bp+4]
  5739 00003A1D E89FFF                   call genCode8
  5740 00003A20 83C402                   add  sp, 2
  5741 00003A23 8B4604                   mov ax, [bp+4]
  5742 00003A26 C1E808                   shr ax, 8
  5743 00003A29 894604                   mov word [bp+4], ax
  5744                                  
  5745                                  ;-30     genCode8(i);
  5746                                  
  5747 00003A2C FF7604                   push word [bp+4]
  5748 00003A2F E88DFF                   call genCode8
  5749 00003A32 83C402                   add  sp, 2
  5750                                  
  5751                                  ;-31 }
  5752                                  
  5753                                  
  5754                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5755 00003A35 C9                       LEAVE
  5756 00003A36 C3                       ret
  5757                                  ; ENDP
  5758                                  
  5759                                  writeEA:  ; *** PROC ***
  5760                                  
  5761                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5762                                  
  5763                                  
  5764                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5765                                  
  5766                                  
  5767                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5768                                  
  5769                                  
  5770                                  ;-36     char len;
  5771                                  
  5772                                  
  5773                                  ;-37     len=0;   
  5774                                  
  5775                                  ;Function : writeEA, Number of local variables: 2
  5776                                  ;   # type sign width line used address name   list of local variables
  5777                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5778                                  ;  201 var sign byte    36 NULL bp-2    len;
  5779 00003A37 C8020000                 ENTER  2,0
  5780 00003A3B 66B800000000             mov eax, 0
  5781 00003A41 8846FE                   mov byte [bp-2], al
  5782                                  
  5783                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5784                                  
  5785 00003A44 8A4604                   mov al, [bp+4]
  5786 00003A47 C0E003                   shl al, 3
  5787 00003A4A 884604                   mov byte [bp+4], al
  5788                                  
  5789                                  ;-39     if (Op == REG) {
  5790                                  
  5791 00003A4D A0[AE01]                 mov al, [Op]
  5792 00003A50 3C02                     cmp al, 2
  5793 00003A52 0F853A00                 jne @@writeEA217
  5794                                  
  5795                                  ;-40         xxx |= 0xC0;     
  5796                                  
  5797 00003A56 804E04C0                 or  byte [bp+4], 192
  5798                                  
  5799                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5800                                  
  5801 00003A5A A0[AF01]                 mov al, [Op2]
  5802 00003A5D 3C01                     cmp al, 1
  5803 00003A5F 0F8F0D00                 jg  @@writeEA218
  5804 00003A63 8A4604                   mov al, [bp+4]
  5805 00003A66 0206[B501]               add al, [R1No]
  5806 00003A6A 884604                   mov byte [bp+4], al
  5807                                  
  5808                                  ;-42             else {
  5809                                  
  5810 00003A6D E92000                   jmp @@writeEA219
  5811                                  @@writeEA218:
  5812                                  
  5813                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5814                                  
  5815 00003A70 A0[AF01]                 mov al, [Op2]
  5816 00003A73 3C02                     cmp al, 2
  5817 00003A75 0F850D00                 jne @@writeEA220
  5818 00003A79 8A4604                   mov al, [bp+4]
  5819 00003A7C 0206[B501]               add al, [R1No]
  5820 00003A80 884604                   mov byte [bp+4], al
  5821                                  
  5822                                  ;-44                 else            xxx = xxx + R2No;  
  5823                                  
  5824 00003A83 E90A00                   jmp @@writeEA221
  5825                                  @@writeEA220:
  5826 00003A86 8A4604                   mov al, [bp+4]
  5827 00003A89 0206[B401]               add al, [R2No]
  5828 00003A8D 884604                   mov byte [bp+4], al
  5829                                  
  5830                                  ;-45             }
  5831                                  
  5832                                  @@writeEA221:
  5833                                  
  5834                                  ;-46         } 
  5835                                  
  5836                                  @@writeEA219:
  5837                                  
  5838                                  ;-47     if (Op == MEM) {
  5839                                  
  5840                                  @@writeEA217:
  5841 00003A90 A0[AE01]                 mov al, [Op]
  5842 00003A93 3C04                     cmp al, 4
  5843 00003A95 0F857F00                 jne @@writeEA222
  5844                                  
  5845                                  ;-48         if (isDirect) {
  5846                                  
  5847 00003A99 A0[BD01]                 mov al, [isDirect]
  5848 00003A9C 08C0                     or  al, al
  5849 00003A9E 0F841000                 je @@writeEA223
  5850                                  
  5851                                  ;-49             xxx |= 6;
  5852                                  
  5853 00003AA2 804E0406                 or  byte [bp+4], 6
  5854                                  
  5855                                  ;-50             len = 2;
  5856                                  
  5857 00003AA6 66B802000000             mov eax, 2
  5858 00003AAC 8846FE                   mov byte [bp-2], al
  5859                                  
  5860                                  ;-51         }
  5861                                  
  5862                                  
  5863                                  ;-52         else { 
  5864                                  
  5865 00003AAF E96600                   jmp @@writeEA224
  5866                                  @@writeEA223:
  5867                                  
  5868                                  ;-53             xxx = xxx + rm;   
  5869                                  
  5870 00003AB2 8A4604                   mov al, [bp+4]
  5871 00003AB5 0206[BC01]               add al, [rm]
  5872 00003AB9 884604                   mov byte [bp+4], al
  5873                                  
  5874                                  ;-54             if (rm == 6) {//make [BP+00]
  5875                                  
  5876 00003ABC A0[BC01]                 mov al, [rm]
  5877 00003ABF 3C06                     cmp al, 6
  5878 00003AC1 0F851700                 jne @@writeEA225
  5879                                  
  5880                                  ;-55                 len=1;
  5881                                  
  5882 00003AC5 66B801000000             mov eax, 1
  5883 00003ACB 8846FE                   mov byte [bp-2], al
  5884                                  
  5885                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5886                                  
  5887 00003ACE A1[BE01]                 mov ax, [disp]
  5888 00003AD1 83F800                   cmp ax, 0
  5889 00003AD4 0F850400                 jne @@writeEA226
  5890 00003AD8 804E0440                 or  byte [bp+4], 64
  5891                                  
  5892                                  ;-57             }
  5893                                  
  5894                                  @@writeEA226:
  5895                                  
  5896                                  ;-58 
  5897                                  
  5898                                  
  5899                                  ;-59             if (disp) {
  5900                                  
  5901                                  @@writeEA225:
  5902 00003ADC A1[BE01]                 mov ax, [disp]
  5903 00003ADF 08C0                     or  al, al
  5904 00003AE1 0F843300                 je @@writeEA227
  5905                                  
  5906                                  ;-60                 ax = disp;
  5907                                  
  5908 00003AE5 A1[BE01]                 mov  ax, [disp]
  5909                                  
  5910                                  ;-61                 if(ax > 127) len=2;
  5911                                  
  5912 00003AE8 83F87F                   cmp  ax, 127
  5913 00003AEB 0F8E0C00                 jle @@writeEA228
  5914 00003AEF 66B802000000             mov eax, 2
  5915 00003AF5 8846FE                   mov byte [bp-2], al
  5916                                  
  5917                                  ;-62                 else len=1;
  5918                                  
  5919 00003AF8 E90900                   jmp @@writeEA229
  5920                                  @@writeEA228:
  5921 00003AFB 66B801000000             mov eax, 1
  5922 00003B01 8846FE                   mov byte [bp-2], al
  5923                                  
  5924                                  ;-63                 if (len == 1) xxx |= 0x40;
  5925                                  
  5926                                  @@writeEA229:
  5927 00003B04 8A46FE                   mov al, [bp-2]
  5928 00003B07 3C01                     cmp al, 1
  5929 00003B09 0F850700                 jne @@writeEA230
  5930 00003B0D 804E0440                 or  byte [bp+4], 64
  5931                                  
  5932                                  ;-64                 else xxx |= 0x80;
  5933                                  
  5934 00003B11 E90400                   jmp @@writeEA231
  5935                                  @@writeEA230:
  5936 00003B14 804E0480                 or  byte [bp+4], 128
  5937                                  
  5938                                  ;-65             }
  5939                                  
  5940                                  @@writeEA231:
  5941                                  
  5942                                  ;-66         }
  5943                                  
  5944                                  @@writeEA227:
  5945                                  
  5946                                  ;-67     }  
  5947                                  
  5948                                  @@writeEA224:
  5949                                  
  5950                                  ;-68     
  5951                                  
  5952                                  
  5953                                  ;-69     genCode8(xxx);// gen second byte
  5954                                  
  5955                                  @@writeEA222:
  5956 00003B18 8A4604                   mov al, byte [bp+4]
  5957 00003B1B B400                     mov ah, 0
  5958 00003B1D 50                       push ax
  5959 00003B1E E89EFE                   call genCode8
  5960 00003B21 83C402                   add  sp, 2
  5961                                  
  5962                                  ;-70     if (len == 1) genCode8 (disp);
  5963                                  
  5964 00003B24 8A46FE                   mov al, [bp-2]
  5965 00003B27 3C01                     cmp al, 1
  5966 00003B29 0F850A00                 jne @@writeEA232
  5967 00003B2D FF36[BE01]               push word [disp]
  5968 00003B31 E88BFE                   call genCode8
  5969 00003B34 83C402                   add  sp, 2
  5970                                  
  5971                                  ;-71     if (len == 2) genCode16(disp);
  5972                                  
  5973                                  @@writeEA232:
  5974 00003B37 8A46FE                   mov al, [bp-2]
  5975 00003B3A 3C02                     cmp al, 2
  5976 00003B3C 0F850A00                 jne @@writeEA233
  5977 00003B40 FF36[BE01]               push word [disp]
  5978 00003B44 E8CFFE                   call genCode16
  5979 00003B47 83C402                   add  sp, 2
  5980                                  
  5981                                  ;-72 }
  5982                                  
  5983                                  @@writeEA233:
  5984                                  
  5985                                  ;-73 
  5986                                  
  5987                                  
  5988                                  ;-74 int genImmediate() { 
  5989 00003B4A C9                       LEAVE
  5990 00003B4B C3                       ret
  5991                                  ; ENDP
  5992                                  
  5993                                  genImmediate:  ; *** PROC ***
  5994                                  
  5995                                  ;-75     if (wflag) genCode16(imme);
  5996                                  
  5997 00003B4C A0[B901]                 mov al, [wflag]
  5998 00003B4F 08C0                     or  al, al
  5999 00003B51 0F840D00                 je @@genImmediate234
  6000 00003B55 FF36[C001]               push word [imme]
  6001 00003B59 E8BAFE                   call genCode16
  6002 00003B5C 83C402                   add  sp, 2
  6003                                  
  6004                                  ;-76     else       genCode8 (imme);  
  6005                                  
  6006 00003B5F E90A00                   jmp @@genImmediate235
  6007                                  @@genImmediate234:
  6008 00003B62 FF36[C001]               push word [imme]
  6009 00003B66 E856FE                   call genCode8
  6010 00003B69 83C402                   add  sp, 2
  6011                                  
  6012                                  ;-77 }    
  6013                                  
  6014                                  @@genImmediate235:
  6015 00003B6C C3                       ret
  6016                                  ; ENDP
  6017                                  ;Back to main program: AS.C
  6018                                  
  6019                                  ;-10 
  6020                                  
  6021                                  
  6022                                  ;-11 int process() { 
  6023                                  
  6024                                  
  6025                                  process:  ; *** PROC ***
  6026                                  
  6027                                  ;-12     char c;           
  6028                                  
  6029                                  
  6030                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6031                                  
  6032                                  ;Function : process, Number of local variables: 1
  6033                                  ;   # type sign width line used address name   list of local variables
  6034                                  ;  200 var sign byte    12 NULL bp-2    c;
  6035 00003B6D C8020000                 ENTER  2,0
  6036 00003B71 66B800000000             mov eax, 0
  6037 00003B77 A2[BC01]                 mov byte [rm], al
  6038 00003B7A A2[B901]                 mov byte [wflag], al
  6039 00003B7D A2[BA01]                 mov byte [dflag], al
  6040 00003B80 A2[B401]                 mov byte [R2No], al
  6041 00003B83 A2[B501]                 mov byte [R1No], al
  6042 00003B86 A2[B601]                 mov byte [R2Type], al
  6043 00003B89 A2[B701]                 mov byte [R1Type], al
  6044 00003B8C A2[AF01]                 mov byte [Op2], al
  6045 00003B8F A2[AE01]                 mov byte [Op], al
  6046                                  
  6047                                  ;-14     disp=imme=0;//int
  6048                                  
  6049 00003B92 66B800000000             mov eax, 0
  6050 00003B98 A3[C001]                 mov word [imme], ax
  6051 00003B9B A3[BE01]                 mov word [disp], ax
  6052                                  
  6053                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  6054                                  
  6055 00003B9E 66B801000000             mov eax, 1
  6056 00003BA4 A2[BD01]                 mov byte [isDirect], al
  6057                                  
  6058                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6059                                  
  6060 00003BA7 E821E8                   call getTokeType
  6061                                  
  6062                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6063                                  
  6064 00003BAA E819EC                   call getCodeSize
  6065 00003BAD A2[B801]                 mov byte [OpSize], al
  6066                                  
  6067                                  ;-18     getCodes();//set: Code1, Code2, Code3
  6068                                  
  6069 00003BB0 E89EFD                   call getCodes
  6070                                  
  6071                                  ;-19 
  6072                                  
  6073                                  
  6074                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  6075                                  
  6076 00003BB3 A0[B001]                 mov al, [CodeType]
  6077 00003BB6 3C01                     cmp al, 1
  6078 00003BB8 0F850F00                 jne @@process236
  6079                                  
  6080                                  ;-21         genCode8(Code1);
  6081                                  
  6082 00003BBC A0[B101]                 mov al, byte [Code1]
  6083 00003BBF B400                     mov ah, 0
  6084 00003BC1 50                       push ax
  6085 00003BC2 E8FAFD                   call genCode8
  6086 00003BC5 83C402                   add  sp, 2
  6087                                  
  6088                                  ;-22         return;
  6089                                  
  6090 00003BC8 E9DF06                   jmp @@retn
  6091                                  
  6092                                  ;-23     }
  6093                                  
  6094                                  
  6095                                  ;-24   
  6096                                  
  6097                                  
  6098                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  6099                                  
  6100                                  @@process236:
  6101 00003BCB A0[B001]                 mov al, [CodeType]
  6102 00003BCE 3C02                     cmp al, 2
  6103 00003BD0 0F856900                 jne @@process237
  6104                                  
  6105                                  ;-26         getOpL();    
  6106                                  
  6107 00003BD4 E8C6E2                   call getOpL
  6108                                  
  6109                                  ;-27         checkOpL();        
  6110                                  
  6111 00003BD7 E8E6E1                   call checkOpL
  6112                                  
  6113                                  ;-28         if (Code2 <= 1) {//inc,dec
  6114                                  
  6115 00003BDA A0[B201]                 mov al, [Code2]
  6116 00003BDD 3C01                     cmp al, 1
  6117 00003BDF 0F8F2700                 jg  @@process238
  6118                                  
  6119                                  ;-29   	        if (Op == REG) {//short
  6120                                  
  6121 00003BE3 A0[AE01]                 mov al, [Op]
  6122 00003BE6 3C02                     cmp al, 2
  6123 00003BE8 0F851E00                 jne @@process239
  6124                                  
  6125                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  6126                                  
  6127 00003BEC A0[B901]                 mov al, [wflag]
  6128 00003BEF 08C0                     or  al, al
  6129 00003BF1 0F841500                 je @@process240
  6130 00003BF5 A0[B501]                 mov al, byte [R1No]
  6131 00003BF8 B400                     mov ah, 0
  6132 00003BFA 50                       push ax
  6133 00003BFB A0[B301]                 mov al, byte [Code3]
  6134 00003BFE B400                     mov ah, 0
  6135 00003C00 50                       push ax
  6136 00003C01 E884FD                   call genCode2
  6137 00003C04 83C404                   add  sp, 4
  6138 00003C07 E9A006                   jmp @@retn
  6139                                  
  6140                                  ;-31             }
  6141                                  
  6142                                  @@process240:
  6143                                  
  6144                                  ;-32         }
  6145                                  
  6146                                  @@process239:
  6147                                  
  6148                                  ;-33         if (Code2 == 5) {//imul extension?
  6149                                  
  6150                                  @@process238:
  6151 00003C0A A0[B201]                 mov al, [Code2]
  6152 00003C0D 3C05                     cmp al, 5
  6153 00003C0F 0F850F00                 jne @@process241
  6154                                  
  6155                                  ;-34             getTokeType();
  6156                                  
  6157 00003C13 E8B5E7                   call getTokeType
  6158                                  
  6159                                  ;-35             if (TokeType) implerror();
  6160                                  
  6161 00003C16 A0[AD01]                 mov al, [TokeType]
  6162 00003C19 08C0                     or  al, al
  6163 00003C1B 0F840300                 je @@process242
  6164 00003C1F E84EF7                   call implerror
  6165                                  
  6166                                  ;-36         }
  6167                                  
  6168                                  @@process242:
  6169                                  
  6170                                  ;-37         genCodeW(Code1);           
  6171                                  
  6172                                  @@process241:
  6173 00003C22 A0[B101]                 mov al, byte [Code1]
  6174 00003C25 B400                     mov ah, 0
  6175 00003C27 50                       push ax
  6176 00003C28 E878FD                   call genCodeW
  6177 00003C2B 83C402                   add  sp, 2
  6178                                  
  6179                                  ;-38         writeEA(Code2);
  6180                                  
  6181 00003C2E A0[B201]                 mov al, byte [Code2]
  6182 00003C31 B400                     mov ah, 0
  6183 00003C33 50                       push ax
  6184 00003C34 E800FE                   call writeEA
  6185 00003C37 83C402                   add  sp, 2
  6186                                  
  6187                                  ;-39         return;
  6188                                  
  6189 00003C3A E96D06                   jmp @@retn
  6190                                  
  6191                                  ;-40     }
  6192                                  
  6193                                  
  6194                                  ;-41   
  6195                                  
  6196                                  
  6197                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6198                                  
  6199                                  @@process237:
  6200 00003C3D A0[B001]                 mov al, [CodeType]
  6201 00003C40 3C03                     cmp al, 3
  6202 00003C42 0F855100                 jne @@process243
  6203                                  
  6204                                  ;-43         check2Ops();    //setwflag not applicable
  6205                                  
  6206 00003C46 E8F9E1                   call check2Ops
  6207                                  
  6208                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  6209                                  
  6210 00003C49 A0[B701]                 mov al, [R1Type]
  6211 00003C4C 3C02                     cmp al, 2
  6212 00003C4E 0F840300                 je  @@process244
  6213 00003C52 E8BBF7                   call reg16error
  6214                                  
  6215                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  6216                                  
  6217                                  @@process244:
  6218 00003C55 A0[AF01]                 mov al, [Op2]
  6219 00003C58 3C04                     cmp al, 4
  6220 00003C5A 0F840300                 je  @@process245
  6221 00003C5E E8D0F6                   call addrerror
  6222                                  
  6223                                  ;-46         
  6224                                  
  6225                                  
  6226                                  ;-47         genCode8(Code1);//les,lds,lea
  6227                                  
  6228                                  @@process245:
  6229 00003C61 A0[B101]                 mov al, byte [Code1]
  6230 00003C64 B400                     mov ah, 0
  6231 00003C66 50                       push ax
  6232 00003C67 E855FD                   call genCode8
  6233 00003C6A 83C402                   add  sp, 2
  6234                                  
  6235                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  6236                                  
  6237 00003C6D A0[B101]                 mov al, [Code1]
  6238 00003C70 3C0F                     cmp al, 15
  6239 00003C72 0F850C00                 jne @@process246
  6240 00003C76 A0[B201]                 mov al, byte [Code2]
  6241 00003C79 B400                     mov ah, 0
  6242 00003C7B 50                       push ax
  6243 00003C7C E840FD                   call genCode8
  6244 00003C7F 83C402                   add  sp, 2
  6245                                  
  6246                                  ;-49         Op=Op2;//set MEM for writeEA
  6247                                  
  6248                                  @@process246:
  6249 00003C82 A0[AF01]                 mov al, [Op2]
  6250 00003C85 A2[AE01]                 mov byte [Op], al
  6251                                  
  6252                                  ;-50         writeEA(R1No);           
  6253                                  
  6254 00003C88 A0[B501]                 mov al, byte [R1No]
  6255 00003C8B B400                     mov ah, 0
  6256 00003C8D 50                       push ax
  6257 00003C8E E8A6FD                   call writeEA
  6258 00003C91 83C402                   add  sp, 2
  6259                                  
  6260                                  ;-51         return;
  6261                                  
  6262 00003C94 E91306                   jmp @@retn
  6263                                  
  6264                                  ;-52     }
  6265                                  
  6266                                  
  6267                                  ;-53 
  6268                                  
  6269                                  
  6270                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6271                                  
  6272                                  @@process243:
  6273 00003C97 A0[B001]                 mov al, [CodeType]
  6274 00003C9A 3C04                     cmp al, 4
  6275 00003C9C 0F85EF00                 jne @@process247
  6276                                  
  6277                                  ;-55         check2Ops();    
  6278                                  
  6279 00003CA0 E89FE1                   call check2Ops
  6280                                  
  6281                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  6282                                  
  6283 00003CA3 A0[AF01]                 mov al, [Op2]
  6284 00003CA6 3C01                     cmp al, 1
  6285 00003CA8 0F857900                 jne @@process248
  6286                                  
  6287                                  ;-57             setsflag();   
  6288                                  
  6289 00003CAC E876E5                   call setsflag
  6290                                  
  6291                                  ;-58             if (Op == REG) {                
  6292                                  
  6293 00003CAF A0[AE01]                 mov al, [Op]
  6294 00003CB2 3C02                     cmp al, 2
  6295 00003CB4 0F853100                 jne @@process249
  6296                                  
  6297                                  ;-59                 if (R1No == 0) {// acc,imm   
  6298                                  
  6299 00003CB8 A0[B501]                 mov al, [R1No]
  6300 00003CBB 3C00                     cmp al, 0
  6301 00003CBD 0F852800                 jne @@process250
  6302                                  
  6303                                  ;-60                     if (sflag == 0) {                        
  6304                                  
  6305 00003CC1 A0[BB01]                 mov al, [sflag]
  6306 00003CC4 3C00                     cmp al, 0
  6307 00003CC6 0F851F00                 jne @@process251
  6308                                  
  6309                                  ;-61                         c = Code1 << 3;
  6310                                  
  6311 00003CCA A0[B101]                 mov al, [Code1]
  6312 00003CCD C0E003                   shl al, 3
  6313 00003CD0 8846FE                   mov byte [bp-2], al
  6314                                  
  6315                                  ;-62                         c += 4;    
  6316                                  
  6317 00003CD3 8046FE04                 add  byte [bp-2], 4
  6318                                  
  6319                                  ;-63                         genCodeW(c);
  6320                                  
  6321 00003CD7 8A46FE                   mov al, byte [bp-2]
  6322 00003CDA B400                     mov ah, 0
  6323 00003CDC 50                       push ax
  6324 00003CDD E8C3FC                   call genCodeW
  6325 00003CE0 83C402                   add  sp, 2
  6326                                  
  6327                                  ;-64                         genImmediate();
  6328                                  
  6329 00003CE3 E866FE                   call genImmediate
  6330                                  
  6331                                  ;-65                         return;
  6332                                  
  6333 00003CE6 E9C105                   jmp @@retn
  6334                                  
  6335                                  ;-66                     }
  6336                                  
  6337                                  
  6338                                  ;-67                 }
  6339                                  
  6340                                  @@process251:
  6341                                  
  6342                                  ;-68             }
  6343                                  
  6344                                  @@process250:
  6345                                  
  6346                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6347                                  
  6348                                  
  6349                                  ;-70             c = sflag + 0x80;   
  6350                                  
  6351                                  @@process249:
  6352 00003CE9 A0[BB01]                 mov al, [sflag]
  6353 00003CEC 0480                     add al, 128
  6354 00003CEE 8846FE                   mov byte [bp-2], al
  6355                                  
  6356                                  ;-71             genCodeW(c); 
  6357                                  
  6358 00003CF1 8A46FE                   mov al, byte [bp-2]
  6359 00003CF4 B400                     mov ah, 0
  6360 00003CF6 50                       push ax
  6361 00003CF7 E8A9FC                   call genCodeW
  6362 00003CFA 83C402                   add  sp, 2
  6363                                  
  6364                                  ;-72             writeEA(Code1);  
  6365                                  
  6366 00003CFD A0[B101]                 mov al, byte [Code1]
  6367 00003D00 B400                     mov ah, 0
  6368 00003D02 50                       push ax
  6369 00003D03 E831FD                   call writeEA
  6370 00003D06 83C402                   add  sp, 2
  6371                                  
  6372                                  ;-73             if (sflag) genCode8(imme);
  6373                                  
  6374 00003D09 A0[BB01]                 mov al, [sflag]
  6375 00003D0C 08C0                     or  al, al
  6376 00003D0E 0F840D00                 je @@process252
  6377 00003D12 FF36[C001]               push word [imme]
  6378 00003D16 E8A6FC                   call genCode8
  6379 00003D19 83C402                   add  sp, 2
  6380                                  
  6381                                  ;-74             else genImmediate();    
  6382                                  
  6383 00003D1C E90300                   jmp @@process253
  6384                                  @@process252:
  6385 00003D1F E82AFE                   call genImmediate
  6386                                  
  6387                                  ;-75             return;     
  6388                                  
  6389                                  @@process253:
  6390 00003D22 E98505                   jmp @@retn
  6391                                  
  6392                                  ;-76         }  
  6393                                  
  6394                                  
  6395                                  ;-77         c = Code1 << 3;//r/m, r/r  
  6396                                  
  6397                                  @@process248:
  6398 00003D25 A0[B101]                 mov al, [Code1]
  6399 00003D28 C0E003                   shl al, 3
  6400 00003D2B 8846FE                   mov byte [bp-2], al
  6401                                  
  6402                                  ;-78         if (Op == REG) {
  6403                                  
  6404 00003D2E A0[AE01]                 mov al, [Op]
  6405 00003D31 3C02                     cmp al, 2
  6406 00003D33 0F852E00                 jne @@process254
  6407                                  
  6408                                  ;-79             if (Op2 == MEM) {//reg, mem      
  6409                                  
  6410 00003D37 A0[AF01]                 mov al, [Op2]
  6411 00003D3A 3C04                     cmp al, 4
  6412 00003D3C 0F852500                 jne @@process255
  6413                                  
  6414                                  ;-80                 c += 2;//add direction flag
  6415                                  
  6416 00003D40 8046FE02                 add  byte [bp-2], 2
  6417                                  
  6418                                  ;-81                 genCodeW(c);
  6419                                  
  6420 00003D44 8A46FE                   mov al, byte [bp-2]
  6421 00003D47 B400                     mov ah, 0
  6422 00003D49 50                       push ax
  6423 00003D4A E856FC                   call genCodeW
  6424 00003D4D 83C402                   add  sp, 2
  6425                                  
  6426                                  ;-82                 Op=Op2;//set MEM for writeEA                
  6427                                  
  6428 00003D50 A0[AF01]                 mov al, [Op2]
  6429 00003D53 A2[AE01]                 mov byte [Op], al
  6430                                  
  6431                                  ;-83                 writeEA(R1No);
  6432                                  
  6433 00003D56 A0[B501]                 mov al, byte [R1No]
  6434 00003D59 B400                     mov ah, 0
  6435 00003D5B 50                       push ax
  6436 00003D5C E8D8FC                   call writeEA
  6437 00003D5F 83C402                   add  sp, 2
  6438                                  
  6439                                  ;-84                 return;    
  6440                                  
  6441 00003D62 E94505                   jmp @@retn
  6442                                  
  6443                                  ;-85             }
  6444                                  
  6445                                  
  6446                                  ;-86         }
  6447                                  
  6448                                  @@process255:
  6449                                  
  6450                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  6451                                  
  6452                                  @@process254:
  6453 00003D65 A0[AF01]                 mov al, [Op2]
  6454 00003D68 3C02                     cmp al, 2
  6455 00003D6A 0F851B00                 jne @@process256
  6456                                  
  6457                                  ;-88             genCodeW(c);
  6458                                  
  6459 00003D6E 8A46FE                   mov al, byte [bp-2]
  6460 00003D71 B400                     mov ah, 0
  6461 00003D73 50                       push ax
  6462 00003D74 E82CFC                   call genCodeW
  6463 00003D77 83C402                   add  sp, 2
  6464                                  
  6465                                  ;-89             writeEA(R2No);//2. Op in reg-field
  6466                                  
  6467 00003D7A A0[B401]                 mov al, byte [R2No]
  6468 00003D7D B400                     mov ah, 0
  6469 00003D7F 50                       push ax
  6470 00003D80 E8B4FC                   call writeEA
  6471 00003D83 83C402                   add  sp, 2
  6472                                  
  6473                                  ;-90             return;            
  6474                                  
  6475 00003D86 E92105                   jmp @@retn
  6476                                  
  6477                                  ;-91         }          
  6478                                  
  6479                                  
  6480                                  ;-92         syntaxerror();        
  6481                                  
  6482                                  @@process256:
  6483 00003D89 E8D3F6                   call syntaxerror
  6484                                  
  6485                                  ;-93         return;
  6486                                  
  6487 00003D8C E91B05                   jmp @@retn
  6488                                  
  6489                                  ;-94     }
  6490                                  
  6491                                  
  6492                                  ;-95  
  6493                                  
  6494                                  
  6495                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  6496                                  
  6497                                  @@process247:
  6498 00003D8F A0[B001]                 mov al, [CodeType]
  6499 00003D92 3C05                     cmp al, 5
  6500 00003D94 0F857F01                 jne @@process257
  6501                                  
  6502                                  ;-97         check2Ops();    
  6503                                  
  6504 00003D98 E8A7E0                   call check2Ops
  6505                                  
  6506                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  6507                                  
  6508                                  
  6509                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6510                                  
  6511                                  
  6512                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6513                                  
  6514                                  
  6515                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6516                                  
  6517                                  
  6518                                  ;-102         if (Op2 == ADR) {
  6519                                  
  6520 00003D9B A0[AF01]                 mov al, [Op2]
  6521 00003D9E 3C03                     cmp al, 3
  6522 00003DA0 0F850F00                 jne @@process258
  6523                                  
  6524                                  ;-103             imme=disp;
  6525                                  
  6526 00003DA4 A1[BE01]                 mov ax, [disp]
  6527 00003DA7 A3[C001]                 mov word [imme], ax
  6528                                  
  6529                                  ;-104             Op2=IMM;//continue with IMM    
  6530                                  
  6531 00003DAA 66B801000000             mov eax, 1
  6532 00003DB0 A2[AF01]                 mov byte [Op2], al
  6533                                  
  6534                                  ;-105         }  
  6535                                  
  6536                                  
  6537                                  ;-106         if (Op2 == IMM) {// r,i     
  6538                                  
  6539                                  @@process258:
  6540 00003DB3 A0[AF01]                 mov al, [Op2]
  6541 00003DB6 3C01                     cmp al, 1
  6542 00003DB8 0F855400                 jne @@process259
  6543                                  
  6544                                  ;-107             if (Op == REG) {               
  6545                                  
  6546 00003DBC A0[AE01]                 mov al, [Op]
  6547 00003DBF 3C02                     cmp al, 2
  6548 00003DC1 0F852500                 jne @@process260
  6549                                  
  6550                                  ;-108                 c = wflag << 3;   
  6551                                  
  6552 00003DC5 A0[B901]                 mov al, [wflag]
  6553 00003DC8 C0E003                   shl al, 3
  6554 00003DCB 8846FE                   mov byte [bp-2], al
  6555                                  
  6556                                  ;-109                 c += 0xB0;                                     
  6557                                  
  6558 00003DCE 8046FEB0                 add  byte [bp-2], 176
  6559                                  
  6560                                  ;-110                 genCode2(c, R1No);   
  6561                                  
  6562 00003DD2 A0[B501]                 mov al, byte [R1No]
  6563 00003DD5 B400                     mov ah, 0
  6564 00003DD7 50                       push ax
  6565 00003DD8 8A46FE                   mov al, byte [bp-2]
  6566 00003DDB B400                     mov ah, 0
  6567 00003DDD 50                       push ax
  6568 00003DDE E8A7FB                   call genCode2
  6569 00003DE1 83C404                   add  sp, 4
  6570                                  
  6571                                  ;-111                 genImmediate();
  6572                                  
  6573 00003DE4 E865FD                   call genImmediate
  6574                                  
  6575                                  ;-112                 return; 
  6576                                  
  6577 00003DE7 E9C004                   jmp @@retn
  6578                                  
  6579                                  ;-113             }
  6580                                  
  6581                                  
  6582                                  ;-114             if (Op == MEM) {// m,i  
  6583                                  
  6584                                  @@process260:
  6585 00003DEA A0[AE01]                 mov al, [Op]
  6586 00003DED 3C04                     cmp al, 4
  6587 00003DEF 0F851700                 jne @@process261
  6588                                  
  6589                                  ;-115                 genCodeW(0xC6);
  6590                                  
  6591 00003DF3 68C600                   push 198
  6592 00003DF6 E8AAFB                   call genCodeW
  6593 00003DF9 83C402                   add  sp, 2
  6594                                  
  6595                                  ;-116                 writeEA( 0 );
  6596                                  
  6597 00003DFC 6A00                     push 0
  6598 00003DFE E836FC                   call writeEA
  6599 00003E01 83C402                   add  sp, 2
  6600                                  
  6601                                  ;-117                 genImmediate();
  6602                                  
  6603 00003E04 E845FD                   call genImmediate
  6604                                  
  6605                                  ;-118                 return;  
  6606                                  
  6607 00003E07 E9A004                   jmp @@retn
  6608                                  
  6609                                  ;-119             }
  6610                                  
  6611                                  
  6612                                  ;-120             regmemerror();
  6613                                  
  6614                                  @@process261:
  6615 00003E0A E8D9F5                   call regmemerror
  6616                                  
  6617                                  ;-121             return;
  6618                                  
  6619 00003E0D E99A04                   jmp @@retn
  6620                                  
  6621                                  ;-122         }      
  6622                                  
  6623                                  
  6624                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6625                                  
  6626                                  @@process259:
  6627 00003E10 A0[B701]                 mov al, [R1Type]
  6628 00003E13 3C04                     cmp al, 4
  6629 00003E15 0F850300                 jne @@process262
  6630 00003E19 E85FDF                   call ChangeDirection
  6631                                  
  6632                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6633                                  
  6634                                  @@process262:
  6635 00003E1C A0[B601]                 mov al, [R2Type]
  6636 00003E1F 3C04                     cmp al, 4
  6637 00003E21 0F852A00                 jne @@process263
  6638                                  
  6639                                  ;-125             if (OpSize != WORD) reg16error();
  6640                                  
  6641 00003E25 A0[B801]                 mov al, [OpSize]
  6642 00003E28 3C02                     cmp al, 2
  6643 00003E2A 0F840300                 je  @@process264
  6644 00003E2E E8DFF5                   call reg16error
  6645                                  
  6646                                  ;-126                 genCode2(0x8C, dflag);
  6647                                  
  6648                                  @@process264:
  6649 00003E31 A0[BA01]                 mov al, byte [dflag]
  6650 00003E34 B400                     mov ah, 0
  6651 00003E36 50                       push ax
  6652 00003E37 688C00                   push 140
  6653 00003E3A E84BFB                   call genCode2
  6654 00003E3D 83C404                   add  sp, 4
  6655                                  
  6656                                  ;-127                 writeEA(R2No);
  6657                                  
  6658 00003E40 A0[B401]                 mov al, byte [R2No]
  6659 00003E43 B400                     mov ah, 0
  6660 00003E45 50                       push ax
  6661 00003E46 E8EEFB                   call writeEA
  6662 00003E49 83C402                   add  sp, 2
  6663                                  
  6664                                  ;-128                 return;   
  6665                                  
  6666 00003E4C E95B04                   jmp @@retn
  6667                                  
  6668                                  ;-129         }          
  6669                                  
  6670                                  
  6671                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6672                                  
  6673                                  @@process263:
  6674 00003E4F A0[AF01]                 mov al, [Op2]
  6675 00003E52 3C04                     cmp al, 4
  6676 00003E54 0F853100                 jne @@process265
  6677                                  
  6678                                  ;-131             if (Op == REG) {
  6679                                  
  6680 00003E58 A0[AE01]                 mov al, [Op]
  6681 00003E5B 3C02                     cmp al, 2
  6682 00003E5D 0F852800                 jne @@process266
  6683                                  
  6684                                  ;-132                 if (R1No == 0) {
  6685                                  
  6686 00003E61 A0[B501]                 mov al, [R1No]
  6687 00003E64 3C00                     cmp al, 0
  6688 00003E66 0F851F00                 jne @@process267
  6689                                  
  6690                                  ;-133                     if (isDirect) {
  6691                                  
  6692 00003E6A A0[BD01]                 mov al, [isDirect]
  6693 00003E6D 08C0                     or  al, al
  6694 00003E6F 0F841600                 je @@process268
  6695                                  
  6696                                  ;-134                         genCodeW(0xA0);
  6697                                  
  6698 00003E73 68A000                   push 160
  6699 00003E76 E82AFB                   call genCodeW
  6700 00003E79 83C402                   add  sp, 2
  6701                                  
  6702                                  ;-135                         genCode16(disp);
  6703                                  
  6704 00003E7C FF36[BE01]               push word [disp]
  6705 00003E80 E893FB                   call genCode16
  6706 00003E83 83C402                   add  sp, 2
  6707                                  
  6708                                  ;-136                         return;   
  6709                                  
  6710 00003E86 E92104                   jmp @@retn
  6711                                  
  6712                                  ;-137                     }   
  6713                                  
  6714                                  
  6715                                  ;-138                 }   
  6716                                  
  6717                                  @@process268:
  6718                                  
  6719                                  ;-139             }   
  6720                                  
  6721                                  @@process267:
  6722                                  
  6723                                  ;-140         } 
  6724                                  
  6725                                  @@process266:
  6726                                  
  6727                                  ;-141         if (Op == MEM) {//moffs16, acc
  6728                                  
  6729                                  @@process265:
  6730 00003E89 A0[AE01]                 mov al, [Op]
  6731 00003E8C 3C04                     cmp al, 4
  6732 00003E8E 0F853100                 jne @@process269
  6733                                  
  6734                                  ;-142             if (Op2 == REG) {
  6735                                  
  6736 00003E92 A0[AF01]                 mov al, [Op2]
  6737 00003E95 3C02                     cmp al, 2
  6738 00003E97 0F852800                 jne @@process270
  6739                                  
  6740                                  ;-143                 if (R2No == 0) {
  6741                                  
  6742 00003E9B A0[B401]                 mov al, [R2No]
  6743 00003E9E 3C00                     cmp al, 0
  6744 00003EA0 0F851F00                 jne @@process271
  6745                                  
  6746                                  ;-144                     if (isDirect) {
  6747                                  
  6748 00003EA4 A0[BD01]                 mov al, [isDirect]
  6749 00003EA7 08C0                     or  al, al
  6750 00003EA9 0F841600                 je @@process272
  6751                                  
  6752                                  ;-145                         genCodeW(0xA2);
  6753                                  
  6754 00003EAD 68A200                   push 162
  6755 00003EB0 E8F0FA                   call genCodeW
  6756 00003EB3 83C402                   add  sp, 2
  6757                                  
  6758                                  ;-146                         genCode16(disp);
  6759                                  
  6760 00003EB6 FF36[BE01]               push word [disp]
  6761 00003EBA E859FB                   call genCode16
  6762 00003EBD 83C402                   add  sp, 2
  6763                                  
  6764                                  ;-147                         return;   
  6765                                  
  6766 00003EC0 E9E703                   jmp @@retn
  6767                                  
  6768                                  ;-148                     }   
  6769                                  
  6770                                  
  6771                                  ;-149                 }   
  6772                                  
  6773                                  @@process272:
  6774                                  
  6775                                  ;-150             }
  6776                                  
  6777                                  @@process271:
  6778                                  
  6779                                  ;-151         
  6780                                  
  6781                                  
  6782                                  ;-152         }
  6783                                  
  6784                                  @@process270:
  6785                                  
  6786                                  ;-153         if (Op2 == REG) {//rm, r
  6787                                  
  6788                                  @@process269:
  6789 00003EC3 A0[AF01]                 mov al, [Op2]
  6790 00003EC6 3C02                     cmp al, 2
  6791 00003EC8 0F851800                 jne @@process273
  6792                                  
  6793                                  ;-154             genCodeW(0x88);     
  6794                                  
  6795 00003ECC 688800                   push 136
  6796 00003ECF E8D1FA                   call genCodeW
  6797 00003ED2 83C402                   add  sp, 2
  6798                                  
  6799                                  ;-155             writeEA(R2No);
  6800                                  
  6801 00003ED5 A0[B401]                 mov al, byte [R2No]
  6802 00003ED8 B400                     mov ah, 0
  6803 00003EDA 50                       push ax
  6804 00003EDB E859FB                   call writeEA
  6805 00003EDE 83C402                   add  sp, 2
  6806                                  
  6807                                  ;-156             return;
  6808                                  
  6809 00003EE1 E9C603                   jmp @@retn
  6810                                  
  6811                                  ;-157         }
  6812                                  
  6813                                  
  6814                                  ;-158         if (Op2 == MEM) {//r, m
  6815                                  
  6816                                  @@process273:
  6817 00003EE4 A0[AF01]                 mov al, [Op2]
  6818 00003EE7 3C04                     cmp al, 4
  6819 00003EE9 0F852400                 jne @@process274
  6820                                  
  6821                                  ;-159             if (Op == REG) {
  6822                                  
  6823 00003EED A0[AE01]                 mov al, [Op]
  6824 00003EF0 3C02                     cmp al, 2
  6825 00003EF2 0F851B00                 jne @@process275
  6826                                  
  6827                                  ;-160                 ChangeDirection();
  6828                                  
  6829 00003EF6 E882DE                   call ChangeDirection
  6830                                  
  6831                                  ;-161                 genCodeW(0x8A);
  6832                                  
  6833 00003EF9 688A00                   push 138
  6834 00003EFC E8A4FA                   call genCodeW
  6835 00003EFF 83C402                   add  sp, 2
  6836                                  
  6837                                  ;-162                 writeEA(R2No);
  6838                                  
  6839 00003F02 A0[B401]                 mov al, byte [R2No]
  6840 00003F05 B400                     mov ah, 0
  6841 00003F07 50                       push ax
  6842 00003F08 E82CFB                   call writeEA
  6843 00003F0B 83C402                   add  sp, 2
  6844                                  
  6845                                  ;-163                 return;   
  6846                                  
  6847 00003F0E E99903                   jmp @@retn
  6848                                  
  6849                                  ;-164             }   
  6850                                  
  6851                                  
  6852                                  ;-165         }         
  6853                                  
  6854                                  @@process275:
  6855                                  
  6856                                  ;-166         syntaxerror();
  6857                                  
  6858                                  @@process274:
  6859 00003F11 E84BF5                   call syntaxerror
  6860                                  
  6861                                  ;-167         return;
  6862                                  
  6863 00003F14 E99303                   jmp @@retn
  6864                                  
  6865                                  ;-168     }    
  6866                                  
  6867                                  
  6868                                  ;-169     
  6869                                  
  6870                                  
  6871                                  ;-170     if (CodeType == 6) {//Jcc       
  6872                                  
  6873                                  @@process257:
  6874 00003F17 A0[B001]                 mov al, [CodeType]
  6875 00003F1A 3C06                     cmp al, 6
  6876 00003F1C 0F85C100                 jne @@process276
  6877                                  
  6878                                  ;-171         if (TokeType == ALNUME) {
  6879                                  
  6880 00003F20 A0[AD01]                 mov al, [TokeType]
  6881 00003F23 3C03                     cmp al, 3
  6882 00003F25 0F85B800                 jne @@process277
  6883                                  
  6884                                  ;-172             LabelIx=searchLabel();
  6885                                  
  6886 00003F29 E866E6                   call searchLabel
  6887 00003F2C A3[8006]                 mov word [LabelIx], ax
  6888                                  
  6889                                  ;-173             if (LabelIx > 0) {
  6890                                  
  6891 00003F2F A1[8006]                 mov ax, [LabelIx]
  6892 00003F32 83F800                   cmp ax, 0
  6893 00003F35 0F8E7A00                 jle @@process278
  6894                                  
  6895                                  ;-174                 disp=LabelAddr[LabelIx];
  6896                                  
  6897 00003F39 8B1E[8006]               mov bx, [LabelIx]
  6898 00003F3D D1E3                     shl bx, 1
  6899 00003F3F 8B87[B605]               mov ax, [LabelAddr + bx]
  6900 00003F43 A3[BE01]                 mov word [disp], ax
  6901                                  
  6902                                  ;-175                 disp = disp - PC;   
  6903                                  
  6904 00003F46 A1[BE01]                 mov ax, [disp]
  6905 00003F49 2B06[A601]               sub ax, [PC]
  6906 00003F4D A3[BE01]                 mov word [disp], ax
  6907                                  
  6908                                  ;-176                 disp = disp - Origin;
  6909                                  
  6910 00003F50 A1[BE01]                 mov ax, [disp]
  6911 00003F53 2B06[A801]               sub ax, [Origin]
  6912 00003F57 A3[BE01]                 mov word [disp], ax
  6913                                  
  6914                                  ;-177                 if (checkConstSize(disp) ) {
  6915                                  
  6916 00003F5A FF36[BE01]               push word [disp]
  6917 00003F5E E829E3                   call checkConstSize
  6918 00003F61 83C402                   add  sp, 2
  6919 00003F64 08C0                     or  al, al
  6920 00003F66 0F842000                 je @@process279
  6921                                  
  6922                                  ;-178                     genCode2(Code1, 0x70);//short       
  6923                                  
  6924 00003F6A 6A70                     push 112
  6925 00003F6C A0[B101]                 mov al, byte [Code1]
  6926 00003F6F B400                     mov ah, 0
  6927 00003F71 50                       push ax
  6928 00003F72 E813FA                   call genCode2
  6929 00003F75 83C404                   add  sp, 4
  6930                                  
  6931                                  ;-179                     disp -= 2; 
  6932                                  
  6933 00003F78 832E[BE01]02             sub  word [disp], 2
  6934                                  
  6935                                  ;-180                     genCode8(disp);   
  6936                                  
  6937 00003F7D FF36[BE01]               push word [disp]
  6938 00003F81 E83BFA                   call genCode8
  6939 00003F84 83C402                   add  sp, 2
  6940                                  
  6941                                  ;-181                 } else {     
  6942                                  
  6943 00003F87 E92600                   jmp @@process280
  6944                                  @@process279:
  6945                                  
  6946                                  ;-182                     genCode8(0x0F);
  6947                                  
  6948 00003F8A 6A0F                     push 15
  6949 00003F8C E830FA                   call genCode8
  6950 00003F8F 83C402                   add  sp, 2
  6951                                  
  6952                                  ;-183                     genCode2(Code1, 0x80);//near       
  6953                                  
  6954 00003F92 688000                   push 128
  6955 00003F95 A0[B101]                 mov al, byte [Code1]
  6956 00003F98 B400                     mov ah, 0
  6957 00003F9A 50                       push ax
  6958 00003F9B E8EAF9                   call genCode2
  6959 00003F9E 83C404                   add  sp, 4
  6960                                  
  6961                                  ;-184                     disp -= 4; 
  6962                                  
  6963 00003FA1 832E[BE01]04             sub  word [disp], 4
  6964                                  
  6965                                  ;-185                     genCode16(disp);                       
  6966                                  
  6967 00003FA6 FF36[BE01]               push word [disp]
  6968 00003FAA E869FA                   call genCode16
  6969 00003FAD 83C402                   add  sp, 2
  6970                                  
  6971                                  ;-186                 }    
  6972                                  
  6973                                  
  6974                                  ;-187             }
  6975                                  
  6976                                  @@process280:
  6977                                  
  6978                                  ;-188             else {//jump forward, near only
  6979                                  
  6980 00003FB0 E92B00                   jmp @@process281
  6981                                  @@process278:
  6982                                  
  6983                                  ;-189                 genCode8(0x0F);
  6984                                  
  6985 00003FB3 6A0F                     push 15
  6986 00003FB5 E807FA                   call genCode8
  6987 00003FB8 83C402                   add  sp, 2
  6988                                  
  6989                                  ;-190                 genCode2(Code1, 0x80);
  6990                                  
  6991 00003FBB 688000                   push 128
  6992 00003FBE A0[B101]                 mov al, byte [Code1]
  6993 00003FC1 B400                     mov ah, 0
  6994 00003FC3 50                       push ax
  6995 00003FC4 E8C1F9                   call genCode2
  6996 00003FC7 83C404                   add  sp, 4
  6997                                  
  6998                                  ;-191                 genCode16(0);
  6999                                  
  7000 00003FCA 6A00                     push 0
  7001 00003FCC E847FA                   call genCode16
  7002 00003FCF 83C402                   add  sp, 2
  7003                                  
  7004                                  ;-192                 PrintRA='*';
  7005                                  
  7006 00003FD2 66B82A000000             mov eax, 42
  7007 00003FD8 A2[CB01]                 mov byte [PrintRA], al
  7008                                  
  7009                                  ;-193                 storeJmpCall();
  7010                                  
  7011 00003FDB E888E4                   call storeJmpCall
  7012                                  
  7013                                  ;-194             }   
  7014                                  
  7015                                  
  7016                                  ;-195         return; 
  7017                                  
  7018                                  @@process281:
  7019 00003FDE E9C902                   jmp @@retn
  7020                                  
  7021                                  ;-196         }  
  7022                                  
  7023                                  
  7024                                  ;-197     }
  7025                                  
  7026                                  @@process277:
  7027                                  
  7028                                  ;-198 
  7029                                  
  7030                                  
  7031                                  ;-199     if (CodeType == 7) {//jmp, call
  7032                                  
  7033                                  @@process276:
  7034 00003FE1 A0[B001]                 mov al, [CodeType]
  7035 00003FE4 3C07                     cmp al, 7
  7036 00003FE6 0F85CD00                 jne @@process282
  7037                                  
  7038                                  ;-200         if (TokeType == ALNUME) {
  7039                                  
  7040 00003FEA A0[AD01]                 mov al, [TokeType]
  7041 00003FED 3C03                     cmp al, 3
  7042 00003FEF 0F85C400                 jne @@process283
  7043                                  
  7044                                  ;-201             LabelIx=searchLabel();
  7045                                  
  7046 00003FF3 E89CE5                   call searchLabel
  7047 00003FF6 A3[8006]                 mov word [LabelIx], ax
  7048                                  
  7049                                  ;-202             if (LabelIx > 0) {
  7050                                  
  7051 00003FF9 A1[8006]                 mov ax, [LabelIx]
  7052 00003FFC 83F800                   cmp ax, 0
  7053 00003FFF 0F8E9100                 jle @@process284
  7054                                  
  7055                                  ;-203                 disp=LabelAddr[LabelIx];
  7056                                  
  7057 00004003 8B1E[8006]               mov bx, [LabelIx]
  7058 00004007 D1E3                     shl bx, 1
  7059 00004009 8B87[B605]               mov ax, [LabelAddr + bx]
  7060 0000400D A3[BE01]                 mov word [disp], ax
  7061                                  
  7062                                  ;-204                 disp = disp - PC;   
  7063                                  
  7064 00004010 A1[BE01]                 mov ax, [disp]
  7065 00004013 2B06[A601]               sub ax, [PC]
  7066 00004017 A3[BE01]                 mov word [disp], ax
  7067                                  
  7068                                  ;-205                 disp = disp - Origin;
  7069                                  
  7070 0000401A A1[BE01]                 mov ax, [disp]
  7071 0000401D 2B06[A801]               sub ax, [Origin]
  7072 00004021 A3[BE01]                 mov word [disp], ax
  7073                                  
  7074                                  ;-206                 if (checkConstSize(disp) ) {
  7075                                  
  7076 00004024 FF36[BE01]               push word [disp]
  7077 00004028 E85FE2                   call checkConstSize
  7078 0000402B 83C402                   add  sp, 2
  7079 0000402E 08C0                     or  al, al
  7080 00004030 0F844200                 je @@process285
  7081                                  
  7082                                  ;-207                     if (Code1 == 0xE9) {//jmp only
  7083                                  
  7084 00004034 A0[B101]                 mov al, [Code1]
  7085 00004037 3CE9                     cmp al, 233
  7086 00004039 0F851B00                 jne @@process286
  7087                                  
  7088                                  ;-208                         genCode8(0xEB);//short       
  7089                                  
  7090 0000403D 68EB00                   push 235
  7091 00004040 E87CF9                   call genCode8
  7092 00004043 83C402                   add  sp, 2
  7093                                  
  7094                                  ;-209                         disp -= 2; 
  7095                                  
  7096 00004046 832E[BE01]02             sub  word [disp], 2
  7097                                  
  7098                                  ;-210                         genCode8(disp);
  7099                                  
  7100 0000404B FF36[BE01]               push word [disp]
  7101 0000404F E86DF9                   call genCode8
  7102 00004052 83C402                   add  sp, 2
  7103                                  
  7104                                  ;-211                     } 
  7105                                  
  7106                                  
  7107                                  ;-212                     else {     
  7108                                  
  7109 00004055 E91B00                   jmp @@process287
  7110                                  @@process286:
  7111                                  
  7112                                  ;-213                         genCode8(Code1);//near    
  7113                                  
  7114 00004058 A0[B101]                 mov al, byte [Code1]
  7115 0000405B B400                     mov ah, 0
  7116 0000405D 50                       push ax
  7117 0000405E E85EF9                   call genCode8
  7118 00004061 83C402                   add  sp, 2
  7119                                  
  7120                                  ;-214                         disp -= 3; 
  7121                                  
  7122 00004064 832E[BE01]03             sub  word [disp], 3
  7123                                  
  7124                                  ;-215                         genCode16(disp);                       
  7125                                  
  7126 00004069 FF36[BE01]               push word [disp]
  7127 0000406D E8A6F9                   call genCode16
  7128 00004070 83C402                   add  sp, 2
  7129                                  
  7130                                  ;-216                     }    
  7131                                  
  7132                                  
  7133                                  ;-217                 } 
  7134                                  
  7135                                  @@process287:
  7136                                  
  7137                                  ;-218                 else {     
  7138                                  
  7139 00004073 E91B00                   jmp @@process288
  7140                                  @@process285:
  7141                                  
  7142                                  ;-219                     genCode8(Code1);//near    
  7143                                  
  7144 00004076 A0[B101]                 mov al, byte [Code1]
  7145 00004079 B400                     mov ah, 0
  7146 0000407B 50                       push ax
  7147 0000407C E840F9                   call genCode8
  7148 0000407F 83C402                   add  sp, 2
  7149                                  
  7150                                  ;-220                     disp -= 3; 
  7151                                  
  7152 00004082 832E[BE01]03             sub  word [disp], 3
  7153                                  
  7154                                  ;-221                     genCode16(disp);                       
  7155                                  
  7156 00004087 FF36[BE01]               push word [disp]
  7157 0000408B E888F9                   call genCode16
  7158 0000408E 83C402                   add  sp, 2
  7159                                  
  7160                                  ;-222                 }    
  7161                                  
  7162                                  
  7163                                  ;-223             }
  7164                                  
  7165                                  @@process288:
  7166                                  
  7167                                  ;-224             else {//jump forward, near only
  7168                                  
  7169 00004091 E92000                   jmp @@process289
  7170                                  @@process284:
  7171                                  
  7172                                  ;-225                 genCode8(Code1);
  7173                                  
  7174 00004094 A0[B101]                 mov al, byte [Code1]
  7175 00004097 B400                     mov ah, 0
  7176 00004099 50                       push ax
  7177 0000409A E822F9                   call genCode8
  7178 0000409D 83C402                   add  sp, 2
  7179                                  
  7180                                  ;-226                 genCode16(0);
  7181                                  
  7182 000040A0 6A00                     push 0
  7183 000040A2 E871F9                   call genCode16
  7184 000040A5 83C402                   add  sp, 2
  7185                                  
  7186                                  ;-227                 PrintRA='*';
  7187                                  
  7188 000040A8 66B82A000000             mov eax, 42
  7189 000040AE A2[CB01]                 mov byte [PrintRA], al
  7190                                  
  7191                                  ;-228                 storeJmpCall();
  7192                                  
  7193 000040B1 E8B2E3                   call storeJmpCall
  7194                                  
  7195                                  ;-229             }   
  7196                                  
  7197                                  
  7198                                  ;-230         return; 
  7199                                  
  7200                                  @@process289:
  7201 000040B4 E9F301                   jmp @@retn
  7202                                  
  7203                                  ;-231         }
  7204                                  
  7205                                  
  7206                                  ;-232     }
  7207                                  
  7208                                  @@process283:
  7209                                  
  7210                                  ;-233     
  7211                                  
  7212                                  
  7213                                  ;-234     if (CodeType ==  8) {//ret,retf
  7214                                  
  7215                                  @@process282:
  7216 000040B7 A0[B001]                 mov al, [CodeType]
  7217 000040BA 3C08                     cmp al, 8
  7218 000040BC 0F853100                 jne @@process290
  7219                                  
  7220                                  ;-235         if (TokeType == DIGIT) {
  7221                                  
  7222 000040C0 A0[AD01]                 mov al, [TokeType]
  7223 000040C3 3C01                     cmp al, 1
  7224 000040C5 0F851900                 jne @@process291
  7225                                  
  7226                                  ;-236             genCode8(Code2);
  7227                                  
  7228 000040C9 A0[B201]                 mov al, byte [Code2]
  7229 000040CC B400                     mov ah, 0
  7230 000040CE 50                       push ax
  7231 000040CF E8EDF8                   call genCode8
  7232 000040D2 83C402                   add  sp, 2
  7233                                  
  7234                                  ;-237             genCode16(SymbolInt);
  7235                                  
  7236 000040D5 FF36[4D00]               push word [SymbolInt]
  7237 000040D9 E83AF9                   call genCode16
  7238 000040DC 83C402                   add  sp, 2
  7239                                  
  7240                                  ;-238             return;
  7241                                  
  7242 000040DF E9C801                   jmp @@retn
  7243                                  
  7244                                  ;-239         }
  7245                                  
  7246                                  
  7247                                  ;-240         genCode8(Code1); 
  7248                                  
  7249                                  @@process291:
  7250 000040E2 A0[B101]                 mov al, byte [Code1]
  7251 000040E5 B400                     mov ah, 0
  7252 000040E7 50                       push ax
  7253 000040E8 E8D4F8                   call genCode8
  7254 000040EB 83C402                   add  sp, 2
  7255                                  
  7256                                  ;-241         return;
  7257                                  
  7258 000040EE E9B901                   jmp @@retn
  7259                                  
  7260                                  ;-242     }
  7261                                  
  7262                                  
  7263                                  ;-243        
  7264                                  
  7265                                  
  7266                                  ;-244     if (CodeType == 9) {//push, pop  
  7267                                  
  7268                                  @@process290:
  7269 000040F1 A0[B001]                 mov al, [CodeType]
  7270 000040F4 3C09                     cmp al, 9
  7271 000040F6 0F850301                 jne @@process292
  7272                                  
  7273                                  ;-245         getOpL();
  7274                                  
  7275 000040FA E8A0DD                   call getOpL
  7276                                  
  7277                                  ;-246         if (Code1 == 0x50) {//push only
  7278                                  
  7279 000040FD A0[B101]                 mov al, [Code1]
  7280 00004100 3C50                     cmp al, 80
  7281 00004102 0F853D00                 jne @@process293
  7282                                  
  7283                                  ;-247             if (Op == IMM) {//push imm8,16
  7284                                  
  7285 00004106 A0[AE01]                 mov al, [Op]
  7286 00004109 3C01                     cmp al, 1
  7287 0000410B 0F853400                 jne @@process294
  7288                                  
  7289                                  ;-248                 setsflag();
  7290                                  
  7291 0000410F E813E1                   call setsflag
  7292                                  
  7293                                  ;-249                 genCode2(0x68, sflag);     
  7294                                  
  7295 00004112 A0[BB01]                 mov al, byte [sflag]
  7296 00004115 B400                     mov ah, 0
  7297 00004117 50                       push ax
  7298 00004118 6A68                     push 104
  7299 0000411A E86BF8                   call genCode2
  7300 0000411D 83C404                   add  sp, 4
  7301                                  
  7302                                  ;-250                 if (sflag) genCode8 (imme);
  7303                                  
  7304 00004120 A0[BB01]                 mov al, [sflag]
  7305 00004123 08C0                     or  al, al
  7306 00004125 0F840D00                 je @@process295
  7307 00004129 FF36[C001]               push word [imme]
  7308 0000412D E88FF8                   call genCode8
  7309 00004130 83C402                   add  sp, 2
  7310                                  
  7311                                  ;-251                 else       genCode16(imme);    
  7312                                  
  7313 00004133 E90A00                   jmp @@process296
  7314                                  @@process295:
  7315 00004136 FF36[C001]               push word [imme]
  7316 0000413A E8D9F8                   call genCode16
  7317 0000413D 83C402                   add  sp, 2
  7318                                  
  7319                                  ;-252                 return;   
  7320                                  
  7321                                  @@process296:
  7322 00004140 E96701                   jmp @@retn
  7323                                  
  7324                                  ;-253             }   
  7325                                  
  7326                                  
  7327                                  ;-254         }
  7328                                  
  7329                                  @@process294:
  7330                                  
  7331                                  ;-255         if (R1Type == SEGREG) {
  7332                                  
  7333                                  @@process293:
  7334 00004143 A0[B701]                 mov al, [R1Type]
  7335 00004146 3C04                     cmp al, 4
  7336 00004148 0F855A00                 jne @@process297
  7337                                  
  7338                                  ;-256             if (Code1 == 0x58) {
  7339                                  
  7340 0000414C A0[B101]                 mov al, [Code1]
  7341 0000414F 3C58                     cmp al, 88
  7342 00004151 0F851200                 jne @@process298
  7343                                  
  7344                                  ;-257                 if (R1No == 1) error1("pop cs not allowed");   
  7345                                  
  7346 00004155 A0[B501]                 mov al, [R1No]
  7347 00004158 3C01                     cmp al, 1
  7348 0000415A 0F850900                 jne @@process299
  7349 0000415E 68[AC42]                 push process_0
  7350 00004161 E83CF1                   call error1
  7351 00004164 83C402                   add  sp, 2
  7352                                  
  7353                                  ;-258             }
  7354                                  
  7355                                  @@process299:
  7356                                  
  7357                                  ;-259             c = R1No <<3;
  7358                                  
  7359                                  @@process298:
  7360 00004167 A0[B501]                 mov al, [R1No]
  7361 0000416A C0E003                   shl al, 3
  7362 0000416D 8846FE                   mov byte [bp-2], al
  7363                                  
  7364                                  ;-260             if (R1No > 3) {//FS, GS
  7365                                  
  7366 00004170 A0[B501]                 mov al, [R1No]
  7367 00004173 3C03                     cmp al, 3
  7368 00004175 0F8E0C00                 jle @@process300
  7369                                  
  7370                                  ;-261                 c += 122;
  7371                                  
  7372 00004179 8046FE7A                 add  byte [bp-2], 122
  7373                                  
  7374                                  ;-262                 genCode8(0x0F);
  7375                                  
  7376 0000417D 6A0F                     push 15
  7377 0000417F E83DF8                   call genCode8
  7378 00004182 83C402                   add  sp, 2
  7379                                  
  7380                                  ;-263             }
  7381                                  
  7382                                  
  7383                                  ;-264             OpCodePtr++;
  7384                                  
  7385                                  @@process300:
  7386 00004185 FF06[C901]               inc  word [OpCodePtr]
  7387                                  
  7388                                  ;-265             c = c + *OpCodePtr;//is Code4   
  7389                                  
  7390 00004189 8A46FE                   mov al, [bp-2]
  7391 0000418C 8B1E[C901]               mov bx, [OpCodePtr]
  7392 00004190 0207                     add al, [bx]
  7393 00004192 B400                     mov ah, 0
  7394 00004194 8846FE                   mov byte [bp-2], al
  7395                                  
  7396                                  ;-266             genCode8(c);  
  7397                                  
  7398 00004197 8A46FE                   mov al, byte [bp-2]
  7399 0000419A B400                     mov ah, 0
  7400 0000419C 50                       push ax
  7401 0000419D E81FF8                   call genCode8
  7402 000041A0 83C402                   add  sp, 2
  7403                                  
  7404                                  ;-267             return; 
  7405                                  
  7406 000041A3 E90401                   jmp @@retn
  7407                                  
  7408                                  ;-268         }  
  7409                                  
  7410                                  
  7411                                  ;-269         checkOpL();    
  7412                                  
  7413                                  @@process297:
  7414 000041A6 E817DC                   call checkOpL
  7415                                  
  7416                                  ;-270         if (R1Type == BYTE) reg16error();
  7417                                  
  7418 000041A9 A0[B701]                 mov al, [R1Type]
  7419 000041AC 3C01                     cmp al, 1
  7420 000041AE 0F850300                 jne @@process301
  7421 000041B2 E85BF2                   call reg16error
  7422                                  
  7423                                  ;-271         if (R1Type == WORD) {
  7424                                  
  7425                                  @@process301:
  7426 000041B5 A0[B701]                 mov al, [R1Type]
  7427 000041B8 3C02                     cmp al, 2
  7428 000041BA 0F851500                 jne @@process302
  7429                                  
  7430                                  ;-272             genCode2(Code1, R1No);
  7431                                  
  7432 000041BE A0[B501]                 mov al, byte [R1No]
  7433 000041C1 B400                     mov ah, 0
  7434 000041C3 50                       push ax
  7435 000041C4 A0[B101]                 mov al, byte [Code1]
  7436 000041C7 B400                     mov ah, 0
  7437 000041C9 50                       push ax
  7438 000041CA E8BBF7                   call genCode2
  7439 000041CD 83C404                   add  sp, 4
  7440                                  
  7441                                  ;-273             return;   
  7442                                  
  7443 000041D0 E9D700                   jmp @@retn
  7444                                  
  7445                                  ;-274         }                
  7446                                  
  7447                                  
  7448                                  ;-275         if (Op == MEM) {
  7449                                  
  7450                                  @@process302:
  7451 000041D3 A0[AE01]                 mov al, [Op]
  7452 000041D6 3C04                     cmp al, 4
  7453 000041D8 0F851B00                 jne @@process303
  7454                                  
  7455                                  ;-276             genCode8(Code2);
  7456                                  
  7457 000041DC A0[B201]                 mov al, byte [Code2]
  7458 000041DF B400                     mov ah, 0
  7459 000041E1 50                       push ax
  7460 000041E2 E8DAF7                   call genCode8
  7461 000041E5 83C402                   add  sp, 2
  7462                                  
  7463                                  ;-277             writeEA(Code3);
  7464                                  
  7465 000041E8 A0[B301]                 mov al, byte [Code3]
  7466 000041EB B400                     mov ah, 0
  7467 000041ED 50                       push ax
  7468 000041EE E846F8                   call writeEA
  7469 000041F1 83C402                   add  sp, 2
  7470                                  
  7471                                  ;-278             return;   
  7472                                  
  7473 000041F4 E9B300                   jmp @@retn
  7474                                  
  7475                                  ;-279         }
  7476                                  
  7477                                  
  7478                                  ;-280         syntaxerror();
  7479                                  
  7480                                  @@process303:
  7481 000041F7 E865F2                   call syntaxerror
  7482                                  
  7483                                  ;-281         return;        
  7484                                  
  7485 000041FA E9AD00                   jmp @@retn
  7486                                  
  7487                                  ;-282     }
  7488                                  
  7489                                  
  7490                                  ;-283     
  7491                                  
  7492                                  
  7493                                  ;-284     if (CodeType == 12) {//int
  7494                                  
  7495                                  @@process292:
  7496 000041FD A0[B001]                 mov al, [CodeType]
  7497 00004200 3C0C                     cmp al, 12
  7498 00004202 0F852200                 jne @@process304
  7499                                  
  7500                                  ;-285         if (TokeType == DIGIT) {            
  7501                                  
  7502 00004206 A0[AD01]                 mov al, [TokeType]
  7503 00004209 3C01                     cmp al, 1
  7504 0000420B 0F851900                 jne @@process305
  7505                                  
  7506                                  ;-286             genCode8(Code1);
  7507                                  
  7508 0000420F A0[B101]                 mov al, byte [Code1]
  7509 00004212 B400                     mov ah, 0
  7510 00004214 50                       push ax
  7511 00004215 E8A7F7                   call genCode8
  7512 00004218 83C402                   add  sp, 2
  7513                                  
  7514                                  ;-287             genCode8(SymbolInt);
  7515                                  
  7516 0000421B FF36[4D00]               push word [SymbolInt]
  7517 0000421F E89DF7                   call genCode8
  7518 00004222 83C402                   add  sp, 2
  7519                                  
  7520                                  ;-288             return;   
  7521                                  
  7522 00004225 E98200                   jmp @@retn
  7523                                  
  7524                                  ;-289         }
  7525                                  
  7526                                  
  7527                                  ;-290     }
  7528                                  
  7529                                  @@process305:
  7530                                  
  7531                                  ;-291     
  7532                                  
  7533                                  
  7534                                  ;-292     if (CodeType == 30) {//enter i18,i8
  7535                                  
  7536                                  @@process304:
  7537 00004228 A0[B001]                 mov al, [CodeType]
  7538 0000422B 3C1E                     cmp al, 30
  7539 0000422D 0F855200                 jne @@process306
  7540                                  
  7541                                  ;-293         genCode8(0xC8);
  7542                                  
  7543 00004231 68C800                   push 200
  7544 00004234 E888F7                   call genCode8
  7545 00004237 83C402                   add  sp, 2
  7546                                  
  7547                                  ;-294         Op=getOp1();
  7548                                  
  7549 0000423A E81DDD                   call getOp1
  7550 0000423D A2[AE01]                 mov byte [Op], al
  7551                                  
  7552                                  ;-295         if (Op == IMM) genCode16(SymbolInt);
  7553                                  
  7554 00004240 A0[AE01]                 mov al, [Op]
  7555 00004243 3C01                     cmp al, 1
  7556 00004245 0F850D00                 jne @@process307
  7557 00004249 FF36[4D00]               push word [SymbolInt]
  7558 0000424D E8C6F7                   call genCode16
  7559 00004250 83C402                   add  sp, 2
  7560                                  
  7561                                  ;-296         else numbererror();
  7562                                  
  7563 00004253 E90300                   jmp @@process308
  7564                                  @@process307:
  7565 00004256 E873F1                   call numbererror
  7566                                  
  7567                                  ;-297         need(',');
  7568                                  
  7569                                  @@process308:
  7570 00004259 6A2C                     push 44
  7571 0000425B E819E6                   call need
  7572 0000425E 83C402                   add  sp, 2
  7573                                  
  7574                                  ;-298         Op=getOp1();
  7575                                  
  7576 00004261 E8F6DC                   call getOp1
  7577 00004264 A2[AE01]                 mov byte [Op], al
  7578                                  
  7579                                  ;-299         if (Op == IMM) genCode8 (SymbolInt);
  7580                                  
  7581 00004267 A0[AE01]                 mov al, [Op]
  7582 0000426A 3C01                     cmp al, 1
  7583 0000426C 0F850D00                 jne @@process309
  7584 00004270 FF36[4D00]               push word [SymbolInt]
  7585 00004274 E848F7                   call genCode8
  7586 00004277 83C402                   add  sp, 2
  7587                                  
  7588                                  ;-300         else numbererror();           
  7589                                  
  7590 0000427A E90300                   jmp @@process310
  7591                                  @@process309:
  7592 0000427D E84CF1                   call numbererror
  7593                                  
  7594                                  ;-301         return;
  7595                                  
  7596                                  @@process310:
  7597 00004280 E92700                   jmp @@retn
  7598                                  
  7599                                  ;-302     }
  7600                                  
  7601                                  
  7602                                  ;-303        
  7603                                  
  7604                                  
  7605                                  ;-304     if (CodeType==101) {// ORG nn
  7606                                  
  7607                                  @@process306:
  7608 00004283 A0[B001]                 mov al, [CodeType]
  7609 00004286 3C65                     cmp al, 101
  7610 00004288 0F851500                 jne @@process311
  7611                                  
  7612                                  ;-305         if (TokeType != DIGIT) numbererror();
  7613                                  
  7614 0000428C A0[AD01]                 mov al, [TokeType]
  7615 0000428F 3C01                     cmp al, 1
  7616 00004291 0F840300                 je  @@process312
  7617 00004295 E834F1                   call numbererror
  7618                                  
  7619                                  ;-306         Origin=SymbolInt;
  7620                                  
  7621                                  @@process312:
  7622 00004298 A1[4D00]                 mov ax, [SymbolInt]
  7623 0000429B A3[A801]                 mov word [Origin], ax
  7624                                  
  7625                                  ;-307         return;
  7626                                  
  7627 0000429E E90900                   jmp @@retn
  7628                                  
  7629                                  ;-308     }
  7630                                  
  7631                                  
  7632                                  ;-309     error1("Command not implemented or syntax error");
  7633                                  
  7634                                  @@process311:
  7635 000042A1 68[BF42]                 push process_1
  7636 000042A4 E8F9EF                   call error1
  7637 000042A7 83C402                   add  sp, 2
  7638                                  
  7639                                  ;-310 }    
  7640                                  
  7641 000042AA C9                      @@retn: LEAVE
  7642 000042AB C3                       ret
  7643                                  ; ENDP
  7644 000042AC 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  7645 000042B5 7420616C6C6F776564-
  7646 000042BE 00                 
  7647 000042BF 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  7648 000042C8 6F7420696D706C656D-
  7649 000042D1 656E746564206F7220-
  7650 000042DA 73796E746178206572-
  7651 000042E3 726F7200           
  7652                                   
  7653                                  ; missing functions: 
  7654                                  ; digit
  7655                                  ; strcpy
  7656                                  ; strcpy
  7657                                  ; eqstr
  7658                                  ; strlen
  7659                                  ; eqstr
  7660                                  ; eqstr
  7661                                  ; eqstr
  7662                                  ; eqstr
  7663                                  ; readRL
  7664                                  ; readRL
  7665                                  ; digit
  7666                                  ; digit
  7667                                  ; strcpy
  7668                                  ; toupper
  7669                                  ; strlen
  7670                                  ; strlen
  7671                                  ; eqstr
  7672                                  ; eqstr
  7673                                  ; eqstr
  7674                                  ; eqstr
  7675                                  ; eqstr
  7676                                  ; eqstr
  7677                                  ; eqstr
  7678                                  ; eqstr
  7679                                  ; eqstr
  7680                                  ; eqstr
  7681                                  ; eqstr
  7682                                  ; eqstr
  7683                                  ; eqstr
  7684                                  ; eqstr
  7685                                  ; eqstr
  7686                                  ; eqstr
  7687                                  ; eqstr
  7688                                  ; eqstr
  7689                                  ; eqstr
  7690                                  ; eqstr
  7691                                  ; eqstr
  7692                                  ; eqstr
  7693                                  ; eqstr
  7694                                  ; eqstr
  7695                                  ; eqstr
  7696                                  ; eqstr
  7697                                  ; eqstr
  7698                                  ; eqstr
  7699                                  ; eqstr
  7700                                  ; eqstr
  7701                                  ; writetty
  7702                                  ; writetty
  7703                                  ; fputcR
  7704                                  ; cputs
  7705                                  ; cputs
  7706                                  ; exitR
  7707                                  ; toupper
  7708                                  ; strcpy
  7709                                  ; strcat1
  7710                                  ; strcpy
  7711                                  ; strcat1
  7712                                  ; strcpy
  7713                                  ; strcat1
  7714                                  ; openR
  7715                                  ; cputs
  7716                                  ; cputs
  7717                                  ; exitR
  7718                                  ; creatR
  7719                                  ; cputs
  7720                                  ; cputs
  7721                                  ; exitR
  7722                                  ; creatR
  7723                                  ; cputs
  7724                                  ; cputs
  7725                                  ; exitR
  7726                                  ; strcpy
  7727                                  ; strlen
  7728                                  ; fputcR
  7729                                  ; fcloseR
  7730                                  ; fcloseR
  7731                                  ; fcloseR
  7732                                  ; exitR
  7733                                  ; Number of unresolved CALLs :   79
  7734                                  ;use archive file: AR.C
  7735                                  
  7736                                  ;-311 // AR.C Archive
  7737                                  
  7738                                  ;Number of CALLs:    2 : writetty
  7739                                  
  7740                                  writetty:  ; *** PROC ***
  7741 000042E7 B40E                     mov  ah, 14
  7742 000042E9 BB0000                   mov  bx, 0
  7743 000042EC CD10                     int  16
  7744                                  
  7745                                  ;-312 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  7746                                  
  7747 000042EE C3                       ret
  7748                                  ; ENDP
  7749                                  ;Number of CALLs:    8 : cputs
  7750                                  
  7751                                  cputs:  ; *** PROC ***
  7752                                  ;Function : cputs, Number of local variables: 2
  7753                                  ;   # type sign width line used address name   list of local variables
  7754                                  ;  200 ptr sign byte   312 NULL bp+4    s
  7755                                  ;  201 var sign byte   312 NULL bp-2    c;
  7756 000042EF C8020000                 ENTER  2,0
  7757                                  @@cputs313:
  7758 000042F3 8B5E04                   mov bx, [bp+4]
  7759 000042F6 8A07                     mov al, [bx]
  7760 000042F8 B400                     mov ah, 0
  7761 000042FA 08C0                     or  al, al
  7762 000042FC 0F841B00                 je @@cputs314
  7763 00004300 8B5E04                   mov bx, [bp+4]
  7764 00004303 8A07                     mov al, [bx]
  7765 00004305 B400                     mov ah, 0
  7766 00004307 8846FE                   mov byte [bp-2], al
  7767 0000430A 8A46FE                   mov al, byte [bp-2]
  7768 0000430D B400                     mov ah, 0
  7769 0000430F 50                       push ax
  7770 00004310 E8C401                   call putch
  7771 00004313 83C402                   add  sp, 2
  7772 00004316 FF4604                   inc  word [bp+4]
  7773 00004319 EBD8                     jmp @@cputs313
  7774                                  @@cputs314:
  7775                                  
  7776                                  ;-313 int mkneg(int n) { n; __asm {neg ax} }
  7777 0000431B C9                       LEAVE
  7778 0000431C C3                       ret
  7779                                  ; ENDP
  7780                                  ;Number of CALLs:    2 : toupper
  7781                                  
  7782                                  toupper:  ; *** PROC ***
  7783                                  ;Function : toupper, Number of local variables: 1
  7784                                  ;   # type sign width line used address name   list of local variables
  7785                                  ;  200 ptr sign byte   313 NULL bp+4    s;
  7786 0000431D C8000000                 ENTER  0,0
  7787                                  @@toupper315:
  7788 00004321 8B5E04                   mov bx, [bp+4]
  7789 00004324 8A07                     mov al, [bx]
  7790 00004326 B400                     mov ah, 0
  7791 00004328 08C0                     or  al, al
  7792 0000432A 0F843000                 je @@toupper316
  7793 0000432E 8B5E04                   mov bx, [bp+4]
  7794 00004331 8A07                     mov al, [bx]
  7795 00004333 B400                     mov ah, 0
  7796 00004335 83F861                   cmp ax, 97 ;unsigned : 1
  7797 00004338 0F8C1D00                 jl  @@toupper317
  7798 0000433C 8B5E04                   mov bx, [bp+4]
  7799 0000433F 8A07                     mov al, [bx]
  7800 00004341 B400                     mov ah, 0
  7801 00004343 83F87A                   cmp ax, 122
  7802 00004346 0F8F0F00                 jg  @@toupper318
  7803 0000434A 8B5E04                   mov bx, [bp+4]
  7804 0000434D 8A07                     mov al, [bx]
  7805 0000434F B400                     mov ah, 0
  7806 00004351 83E820                   sub ax, 32
  7807 00004354 8B5E04                   mov  bx, [bp+4]
  7808 00004357 8807                     mov  [bx], al
  7809                                  @@toupper318:
  7810                                  @@toupper317:
  7811 00004359 FF4604                   inc  word [bp+4]
  7812 0000435C EBC3                     jmp @@toupper315
  7813                                  @@toupper316:
  7814                                  
  7815                                  ;-314 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  7816                                  
  7817                                  
  7818                                  ;-315 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  7819 0000435E C9                       LEAVE
  7820 0000435F C3                       ret
  7821                                  ; ENDP
  7822                                  ;Number of CALLs:    4 : strlen
  7823                                  
  7824                                  strlen:  ; *** PROC ***
  7825                                  ;Function : strlen, Number of local variables: 2
  7826                                  ;   # type sign width line used address name   list of local variables
  7827                                  ;  200 ptr sign byte   315 NULL bp+4    s
  7828                                  ;  201 var sign word   315 NULL bp-2    c;
  7829 00004360 C8020000                 ENTER  2,0
  7830 00004364 66B800000000             mov eax, 0
  7831 0000436A 8946FE                   mov word [bp-2], ax
  7832                                  @@strlen319:
  7833 0000436D 8B5E04                   mov bx, [bp+4]
  7834 00004370 8A07                     mov al, [bx]
  7835 00004372 B400                     mov ah, 0
  7836 00004374 83F800                   cmp ax, 0
  7837 00004377 0F840800                 je  @@strlen320
  7838 0000437B FF4604                   inc  word [bp+4]
  7839 0000437E FF46FE                   inc  word [bp-2]
  7840 00004381 EBEA                     jmp @@strlen319
  7841                                  @@strlen320:
  7842 00004383 8B46FE                   mov ax, [bp-2]
  7843 00004386 E90000                   jmp @@retn
  7844                                  
  7845                                  ;-316 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  7846                                  
  7847 00004389 C9                      @@retn: LEAVE
  7848 0000438A C3                       ret
  7849                                  ; ENDP
  7850                                  ;Number of CALLs:    7 : strcpy
  7851                                  
  7852                                  strcpy:  ; *** PROC ***
  7853                                  ;Function : strcpy, Number of local variables: 2
  7854                                  ;   # type sign width line used address name   list of local variables
  7855                                  ;  200 ptr sign byte   316 NULL bp+4    s
  7856                                  ;  201 ptr sign byte   316 NULL bp+6    t;
  7857 0000438B C8000000                 ENTER  0,0
  7858                                  @@strcpy321:
  7859 0000438F 8B5E06                   mov bx, [bp+6]
  7860 00004392 8A07                     mov al, [bx]
  7861 00004394 B400                     mov ah, 0
  7862 00004396 8B5E04                   mov  bx, [bp+4]
  7863 00004399 8807                     mov  [bx], al
  7864 0000439B FF4604                   inc  word [bp+4]
  7865 0000439E FF4606                   inc  word [bp+6]
  7866                                  
  7867                                  ;-317   while (*t!=0); *s=0; return s; }
  7868                                  
  7869 000043A1 8B5E06                   mov bx, [bp+6]
  7870 000043A4 8A07                     mov al, [bx]
  7871 000043A6 B400                     mov ah, 0
  7872 000043A8 83F800                   cmp ax, 0
  7873 000043AB 0F840200                 je  @@strcpy322
  7874 000043AF EBDE                     jmp @@strcpy321
  7875                                  @@strcpy322:
  7876 000043B1 66B800000000             mov eax, 0
  7877 000043B7 8B5E04                   mov  bx, [bp+4]
  7878 000043BA 8807                     mov  [bx], al
  7879 000043BC 8B4604                   mov ax, [bp+4]
  7880 000043BF E90000                   jmp @@retn
  7881                                  
  7882                                  ;-318 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  7883                                  
  7884 000043C2 C9                      @@retn: LEAVE
  7885 000043C3 C3                       ret
  7886                                  ; ENDP
  7887                                  ;Number of CALLs:    3 : digit
  7888                                  
  7889                                  digit:  ; *** PROC ***
  7890                                  ;Function : digit, Number of local variables: 1
  7891                                  ;   # type sign width line used address name   list of local variables
  7892                                  ;  200 var sign byte   318 NULL bp+4    c;
  7893 000043C4 C8000000                 ENTER  0,0
  7894 000043C8 8A4604                   mov al, [bp+4]
  7895 000043CB 3C30                     cmp al, 48
  7896 000043CD 0F8D0900                 jge @@digit323
  7897 000043D1 66B800000000             mov eax, 0
  7898 000043D7 E91B00                   jmp @@retn
  7899                                  @@digit323:
  7900 000043DA 8A4604                   mov al, [bp+4]
  7901 000043DD 3C39                     cmp al, 57
  7902 000043DF 0F8E0900                 jle @@digit324
  7903 000043E3 66B800000000             mov eax, 0
  7904 000043E9 E90900                   jmp @@retn
  7905                                  @@digit324:
  7906 000043EC 66B801000000             mov eax, 1
  7907 000043F2 E90000                   jmp @@retn
  7908                                  
  7909                                  ;-319 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  7910                                  
  7911 000043F5 C9                      @@retn: LEAVE
  7912 000043F6 C3                       ret
  7913                                  ; ENDP
  7914                                  ;Number of CALLs:   35 : eqstr
  7915                                  
  7916                                  eqstr:  ; *** PROC ***
  7917                                  ;Function : eqstr, Number of local variables: 2
  7918                                  ;   # type sign width line used address name   list of local variables
  7919                                  ;  200 ptr sign byte   319 NULL bp+4    p
  7920                                  ;  201 ptr sign byte   319 NULL bp+6    q;
  7921 000043F7 C8000000                 ENTER  0,0
  7922                                  @@eqstr325:
  7923 000043FB 8B5E04                   mov bx, [bp+4]
  7924 000043FE 8A07                     mov al, [bx]
  7925 00004400 B400                     mov ah, 0
  7926 00004402 08C0                     or  al, al
  7927 00004404 0F842300                 je @@eqstr326
  7928                                  
  7929                                  ;-320     if (*p != *q) return 0; p++; q++; }
  7930                                  
  7931 00004408 8B5E04                   mov bx, [bp+4]
  7932 0000440B 8A07                     mov al, [bx]
  7933 0000440D B400                     mov ah, 0
  7934 0000440F 8B5E06                   mov bx, [bp+6]
  7935 00004412 3A07                     cmp al, [bx]
  7936 00004414 B400                     mov ah, 0
  7937 00004416 0F840900                 je  @@eqstr327
  7938 0000441A 66B800000000             mov eax, 0
  7939 00004420 E92700                   jmp @@retn
  7940                                  @@eqstr327:
  7941 00004423 FF4604                   inc  word [bp+4]
  7942 00004426 FF4606                   inc  word [bp+6]
  7943                                  
  7944                                  ;-321     if(*q) return 0; return 1; }
  7945                                  
  7946 00004429 EBD0                     jmp @@eqstr325
  7947                                  @@eqstr326:
  7948 0000442B 8B5E06                   mov bx, [bp+6]
  7949 0000442E 8A07                     mov al, [bx]
  7950 00004430 B400                     mov ah, 0
  7951 00004432 08C0                     or  al, al
  7952 00004434 0F840900                 je @@eqstr328
  7953 00004438 66B800000000             mov eax, 0
  7954 0000443E E90900                   jmp @@retn
  7955                                  @@eqstr328:
  7956 00004441 66B801000000             mov eax, 1
  7957 00004447 E90000                   jmp @@retn
  7958                                  
  7959                                  ;-322 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  7960                                  
  7961 0000444A C9                      @@retn: LEAVE
  7962 0000444B C3                       ret
  7963                                  ; ENDP
  7964                                  ;Number of CALLs:    3 : strcat1
  7965                                  
  7966                                  strcat1:  ; *** PROC ***
  7967                                  ;Function : strcat1, Number of local variables: 2
  7968                                  ;   # type sign width line used address name   list of local variables
  7969                                  ;  200 ptr sign byte   322 NULL bp+4    s
  7970                                  ;  201 ptr sign byte   322 NULL bp+6    t;
  7971 0000444C C8000000                 ENTER  0,0
  7972                                  @@strcat1329:
  7973 00004450 8B5E04                   mov bx, [bp+4]
  7974 00004453 8A07                     mov al, [bx]
  7975 00004455 B400                     mov ah, 0
  7976 00004457 83F800                   cmp ax, 0
  7977 0000445A 0F840500                 je  @@strcat1330
  7978 0000445E FF4604                   inc  word [bp+4]
  7979 00004461 EBED                     jmp @@strcat1329
  7980                                  @@strcat1330:
  7981 00004463 FF7606                   push word [bp+6]
  7982 00004466 FF7604                   push word [bp+4]
  7983 00004469 E81FFF                   call strcpy
  7984 0000446C 83C404                   add  sp, 4
  7985                                  
  7986                                  ;-323 int basename(char *s) { char *p; p=0;
  7987 0000446F C9                       LEAVE
  7988 00004470 C3                       ret
  7989                                  ; ENDP
  7990                                  ;Number of CALLs:    1 : openR
  7991                                  
  7992                                  openR:  ; *** PROC ***
  7993                                  ;Function : openR, Number of local variables: 1
  7994                                  ;   # type sign width line used address name   list of local variables
  7995                                  ;  200 ptr sign byte   323 NULL bp+4    s;
  7996 00004471 C8000000                 ENTER  0,0
  7997 00004475 8B5604                   mov  dx, [bp+4]
  7998 00004478 B8023D                   mov  ax, 15618
  7999 0000447B E87200                   call DosInt
  8000                                  
  8001                                  ;-324 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  8002 0000447E C9                       LEAVE
  8003 0000447F C3                       ret
  8004                                  ; ENDP
  8005                                  ;Number of CALLs:    2 : creatR
  8006                                  
  8007                                  creatR:  ; *** PROC ***
  8008                                  ;Function : creatR, Number of local variables: 1
  8009                                  ;   # type sign width line used address name   list of local variables
  8010                                  ;  200 ptr sign byte   324 NULL bp+4    s;
  8011 00004480 C8000000                 ENTER  0,0
  8012 00004484 8B5604                   mov  dx, [bp+4]
  8013 00004487 B90000                   mov  cx, 0
  8014 0000448A B8003C                   mov  ax, 15360
  8015 0000448D E86000                   call DosInt
  8016                                  
  8017                                  ;-325 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  8018 00004490 C9                       LEAVE
  8019 00004491 C3                       ret
  8020                                  ; ENDP
  8021                                  ;Number of CALLs:    2 : readRL
  8022                                  
  8023                                  readRL:  ; *** PROC ***
  8024                                  ;Function : readRL, Number of local variables: 3
  8025                                  ;   # type sign width line used address name   list of local variables
  8026                                  ;  200 ptr sign byte   325 NULL bp+4    s
  8027                                  ;  201 var sign word   325 NULL bp+6    fd
  8028                                  ;  202 var sign word   325 NULL bp+8    len;
  8029 00004492 C8000000                 ENTER  0,0
  8030 00004496 8B5604                   mov  dx, [bp+4]
  8031 00004499 8B4E08                   mov  cx, [bp+8]
  8032 0000449C 8B5E06                   mov  bx, [bp+6]
  8033 0000449F B8003F                   mov  ax, 16128
  8034 000044A2 E84B00                   call DosInt
  8035                                  
  8036                                  ;-326 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  8037 000044A5 C9                       LEAVE
  8038 000044A6 C3                       ret
  8039                                  ; ENDP
  8040                                  ;Number of CALLs:    2 : fputcR
  8041                                  
  8042                                  fputcR:  ; *** PROC ***
  8043                                  ;Function : fputcR, Number of local variables: 2
  8044                                  ;   # type sign width line used address name   list of local variables
  8045                                  ;  200 ptr sign byte   326 NULL bp+4    n
  8046                                  ;  201 var sign word   326 NULL bp+6    fd;
  8047 000044A7 C8000000                 ENTER  0,0
  8048 000044AB 8D5604                  lea dx, [bp+4]
  8049                                  
  8050                                  ;-327   cx=1; bx=fd; ax=0x4000; DosInt(); }
  8051                                  
  8052 000044AE B90100                   mov  cx, 1
  8053 000044B1 8B5E06                   mov  bx, [bp+6]
  8054 000044B4 B80040                   mov  ax, 16384
  8055 000044B7 E83600                   call DosInt
  8056                                  
  8057                                  ;-328 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  8058 000044BA C9                       LEAVE
  8059 000044BB C3                       ret
  8060                                  ; ENDP
  8061                                  ;Number of CALLs:    3 : fcloseR
  8062                                  
  8063                                  fcloseR:  ; *** PROC ***
  8064                                  ;Function : fcloseR, Number of local variables: 1
  8065                                  ;   # type sign width line used address name   list of local variables
  8066                                  ;  200 var sign word   328 NULL bp+4    fd;
  8067 000044BC C8000000                 ENTER  0,0
  8068 000044C0 8B5E04                   mov  bx, [bp+4]
  8069 000044C3 B8003E                   mov  ax, 15872
  8070 000044C6 CD21                     int  33
  8071                                  
  8072                                  ;-329 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  8073 000044C8 C9                       LEAVE
  8074 000044C9 C3                       ret
  8075                                  ; ENDP
  8076                                  ;Number of CALLs:    5 : exitR
  8077                                  
  8078                                  exitR:  ; *** PROC ***
  8079                                  ;Function : exitR, Number of local variables: 1
  8080                                  ;   # type sign width line used address name   list of local variables
  8081                                  ;  200 var sign byte   329 NULL bp+4    c;
  8082 000044CA C8000000                 ENTER  0,0
  8083 000044CE B44C                     mov  ah, 76
  8084 000044D0 8A4604                   mov  al, [bp+4]
  8085 000044D3 CD21                     int  33
  8086                                  
  8087                                  ;-330 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  8088 000044D5 C9                       LEAVE
  8089 000044D6 C3                       ret
  8090                                  ; ENDP
  8091                                  ;End of archive file. 
  8092                                   
  8093                                  ; missing functions: 
  8094                                  ; putch
  8095                                  ; DosInt
  8096                                  ; DosInt
  8097                                  ; DosInt
  8098                                  ; DosInt
  8099                                  ; Number of unresolved CALLs :    5
  8100                                  ;use archive file: AR.C
  8101                                  
  8102                                  ;-331 // AR.C Archive
  8103                                  
  8104                                  ;Number of CALLs:    1 : putch
  8105                                  
  8106                                  putch:  ; *** PROC ***
  8107                                  ;Function : putch, Number of local variables: 1
  8108                                  ;   # type sign width line used address name   list of local variables
  8109                                  ;  200 var sign byte   331 NULL bp+4    c;
  8110 000044D7 C8000000                 ENTER  0,0
  8111 000044DB 807E040A                cmp byte [bp+4], 10
  8112 000044DF 0F850500                 jne @@putch331
  8113 000044E3 B00D                     mov  al, 13
  8114 000044E5 E8FFFD                   call writetty
  8115                                  @@putch331:
  8116 000044E8 8A4604                   mov  al, [bp+4]
  8117 000044EB E8F9FD                   call writetty
  8118                                  
  8119                                  ;-332 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  8120 000044EE C9                       LEAVE
  8121 000044EF C3                       ret
  8122                                  ; ENDP
  8123                                  ;Number of CALLs:    4 : DosInt
  8124                                  
  8125                                  DosInt:  ; *** PROC ***
  8126 000044F0 CD21                     int  33
  8127 000044F2 7304                     jae short @@DosInt332
  8128 000044F4 FF06[9F01]               inc  word [DOS_ERR]
  8129                                  @@DosInt332:
  8130                                  
  8131                                  ;-333 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  8132                                  
  8133 000044F8 C3                       ret
  8134                                  ; ENDP
  8135                                  ;End of archive file. 
  8136                                   
  8137                                  ; missing functions:  All FUNCTIONs in place
  8138 000044F9 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8139 000044FC 58                      pop ax
  8140 000044FD C3                      ret
  8141                                   
  8142                                  ;   # type sign width line used  address name   list of global variables
  8143                                  
  8144                                  ;    1 arr sign byte     1    2        0 Version1[10]
  8145                                  ;    2 var sign byte     1    3        0 LIST
  8146                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  8147                                  ;    4 arr sign byte     3   11        0 Symbol[31]
  8148                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  8149                                  ;    6 var unsg word     5   17        0 SymbolInt
  8150                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  8151                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  8152                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  8153                                  ;   10 arr sign byte     9    5        0 namein[67]
  8154                                  ;   11 arr sign byte    10    6        0 namelst[67]
  8155                                  ;   12 arr sign byte    11    6        0 namebin[67]
  8156                                  ;   13 var sign word    12    4        0 asm_fd
  8157                                  ;   14 var sign word    13    3        0 lst_fd
  8158                                  ;   15 var sign word    14    3        0 bin_fd
  8159                                  ;   16 var sign word    15    6        0 DOS_ERR
  8160                                  ;   17 var sign word    16    4        0 ErrorCount
  8161                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  8162                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  8163                                  ;   20 var unsg word    20    7        0 PC
  8164                                  ;   21 var unsg word    21    5        0 Origin
  8165                                  ;   22 var unsg word    22    2        0 PCStart
  8166                                  ;   23 var sign byte    23    3        0 isLabel
  8167                                  ;   24 def unsg byte    24    -        0 DIGIT=1
  8168                                  ;   25 def unsg byte    25    -        0 LETTERE=2
  8169                                  ;   26 def unsg byte    26    -        0 ALNUME=3
  8170                                  ;   27 def unsg byte    27    -        0 NOALNUME=4
  8171                                  ;   28 var sign byte    28   25        0 TokeType
  8172                                  ;   29 def unsg byte    29    -        0 BYTE=1
  8173                                  ;   30 def unsg byte    30    -        0 WORD=2
  8174                                  ;   31 def unsg byte    31    -        0 DWORD=3
  8175                                  ;   32 def unsg byte    32    -        0 SEGREG=4
  8176                                  ;   33 def unsg byte    33    -        0 IMM=1
  8177                                  ;   34 def unsg byte    34    -        0 REG=2
  8178                                  ;   35 def unsg byte    35    -        0 ADR=3
  8179                                  ;   36 def unsg byte    36    -        0 MEM=4
  8180                                  ;   37 var sign byte    37   28        0 Op
  8181                                  ;   38 var sign byte    38   29        0 Op2
  8182                                  ;   39 var sign byte    39   25        0 CodeType
  8183                                  ;   40 var sign byte    40   20        0 Code1
  8184                                  ;   41 var sign byte    41    7        0 Code2
  8185                                  ;   42 var sign byte    42    3        0 Code3
  8186                                  ;   43 var sign byte    43   18        0 R2No
  8187                                  ;   44 var sign byte    44   16        0 R1No
  8188                                  ;   45 var sign byte    45   17        0 R2Type
  8189                                  ;   46 var sign byte    46   14        0 R1Type
  8190                                  ;   47 var sign byte    47   13        0 OpSize
  8191                                  ;   48 var sign byte    48    8        0 wflag
  8192                                  ;   49 var sign byte    49    3        0 dflag
  8193                                  ;   50 var sign byte    50    8        0 sflag
  8194                                  ;   51 var sign byte    51   15        0 rm
  8195                                  ;   52 var sign byte    52    5        0 isDirect
  8196                                  ;   53 var sign word    53   48        0 disp
  8197                                  ;   54 var unsg word    54   10        0 imme
  8198                                  ;   55 def unsg byte    56    -        0 OPMAXLEN=5
  8199                                  ;   56 arr sign byte    57    2        0 OpPos[5]
  8200                                  ;   57 var sign word    58    6        0 OpPrintIndex
  8201                                  ;   58 ptr sign byte    59   19        0 OpCodePtr
  8202                                  ;   59 var sign byte    60    4        0 PrintRA
  8203                                  ;   60 def unsg byte    62    -        0 LABELNAMESMAX=969
  8204                                  ;   61 arr sign byte    63    3        0 LabelNames[1000]
  8205                                  ;   62 ptr sign byte    64    5        0 LabelNamePtr
  8206                                  ;   63 def unsg byte    65    -        0 LABELADRMAX=100
  8207                                  ;   64 arr unsg word    66    6        0 LabelAddr[100]
  8208                                  ;   65 var sign word    67    6        0 LabelMaxIx
  8209                                  ;   66 var sign word    68   10        0 LabelIx
  8210                                  ;   67 def unsg byte    70    -        0 JMPCALLMAX=500
  8211                                  ;   68 def unsg byte    71    -        0 JMPCALLNAMESMAX=1969
  8212                                  ;   69 arr sign byte    72    3        0 JmpCallNames[2000]
  8213                                  ;   70 ptr sign byte    73    5        0 JmpCallNamePtr
  8214                                  ;   71 arr unsg word    74    2        0 JmpCallAddr[500]
  8215                                  ;   72 var sign word    75    6        0 JmpCallMaxIx
  8216                                  ;   73 def unsg byte    77    -        0 FILEBINMAX=2000
  8217                                  ;   74 arr sign byte    78    4        0 FileBin[2000]
  8218                                  ;   75 var unsg word    79    6        0 BinLen
  8219                                  ;   76 ptr sign byte    81    1        0 arglen
  8220                                  ;   77 ptr sign byte    82    4        0 argv
  8221                                  ;   78 var sign byte     1    1        0 I_START
  8222                                  ;   79 arr sign byte     4 NULL        0 I_PUSHA[9]
  8223                                  ;   80 arr sign byte     5 NULL        0 I_POPA[8]
  8224                                  ;   81 arr sign byte     6 NULL        0 I_NOP[7]
  8225                                  ;   82 arr sign byte     7 NULL        0 I_CBW[7]
  8226                                  ;   83 arr sign byte     8 NULL        0 I_CWDE[8]
  8227                                  ;   84 arr sign byte     9 NULL        0 I_CWD[7]
  8228                                  ;   85 arr sign byte    10 NULL        0 I_CDQ[7]
  8229                                  ;   86 arr sign byte    11 NULL        0 I_WAIT[8]
  8230                                  ;   87 arr sign byte    12 NULL        0 I_PUSHF[9]
  8231                                  ;   88 arr sign byte    13 NULL        0 I_POPF[8]
  8232                                  ;   89 arr sign byte    14 NULL        0 I_SAHF[8]
  8233                                  ;   90 arr sign byte    15 NULL        0 I_LAHF[8]
  8234                                  ;   91 arr sign byte    16 NULL        0 I_MOVSB[9]
  8235                                  ;   92 arr sign byte    17 NULL        0 I_MOVSW[9]
  8236                                  ;   93 arr sign byte    18 NULL        0 I_CMPSB[9]
  8237                                  ;   94 arr sign byte    19 NULL        0 I_CMPSW[9]
  8238                                  ;   95 arr sign byte    20 NULL        0 I_STOSB[9]
  8239                                  ;   96 arr sign byte    21 NULL        0 I_STOSW[9]
  8240                                  ;   97 arr sign byte    22 NULL        0 I_LODSB[9]
  8241                                  ;   98 arr sign byte    23 NULL        0 I_LODSW[9]
  8242                                  ;   99 arr sign byte    24 NULL        0 I_SCASB[9]
  8243                                  ;  100 arr sign byte    25 NULL        0 I_SCASW[9]
  8244                                  ;  101 arr sign byte    26 NULL        0 I_LEAVE[9]
  8245                                  ;  102 arr sign byte    27 NULL        0 I_INT3[8]
  8246                                  ;  103 arr sign byte    28 NULL        0 I_INTO[8]
  8247                                  ;  104 arr sign byte    29 NULL        0 I_IRET[8]
  8248                                  ;  105 arr sign byte    30 NULL        0 I_XLAT[8]
  8249                                  ;  106 arr sign byte    31 NULL        0 I_LOCK[8]
  8250                                  ;  107 arr sign byte    32 NULL        0 I_REPNE[9]
  8251                                  ;  108 arr sign byte    33 NULL        0 I_REPNZ[9]
  8252                                  ;  109 arr sign byte    34 NULL        0 I_REPE[8]
  8253                                  ;  110 arr sign byte    35 NULL        0 I_REPZ[8]
  8254                                  ;  111 arr sign byte    36 NULL        0 I_HLT[7]
  8255                                  ;  112 arr sign byte    37 NULL        0 I_CLC[7]
  8256                                  ;  113 arr sign byte    38 NULL        0 I_STC[7]
  8257                                  ;  114 arr sign byte    39 NULL        0 I_CLI[7]
  8258                                  ;  115 arr sign byte    40 NULL        0 I_STI[7]
  8259                                  ;  116 arr sign byte    41 NULL        0 I_CLD[7]
  8260                                  ;  117 arr sign byte    42 NULL        0 I_STD[7]
  8261                                  ;  118 arr sign byte    44 NULL        0 I_INC[9]
  8262                                  ;  119 arr sign byte    45 NULL        0 I_DEC[9]
  8263                                  ;  120 arr sign byte    46 NULL        0 I_NOT[8]
  8264                                  ;  121 arr sign byte    47 NULL        0 I_NEG[8]
  8265                                  ;  122 arr sign byte    48 NULL        0 I_MUL[8]
  8266                                  ;  123 arr sign byte    49 NULL        0 I_IMUL[9]
  8267                                  ;  124 arr sign byte    50 NULL        0 I_DIV[8]
  8268                                  ;  125 arr sign byte    51 NULL        0 I_IDIV[9]
  8269                                  ;  126 arr sign byte    53 NULL        0 I_LES[7]
  8270                                  ;  127 arr sign byte    54 NULL        0 I_LDS[7]
  8271                                  ;  128 arr sign byte    55 NULL        0 I_LEA[7]
  8272                                  ;  129 arr sign byte    56 NULL        0 I_LSS[8]
  8273                                  ;  130 arr sign byte    57 NULL        0 I_LFS[8]
  8274                                  ;  131 arr sign byte    58 NULL        0 I_LGS[8]
  8275                                  ;  132 arr sign byte    60 NULL        0 I_ADD[7]
  8276                                  ;  133 arr sign byte    61 NULL        0 I_OR[6]
  8277                                  ;  134 arr sign byte    62 NULL        0 I_ADC[7]
  8278                                  ;  135 arr sign byte    63 NULL        0 I_SBB[7]
  8279                                  ;  136 arr sign byte    64 NULL        0 I_AND[7]
  8280                                  ;  137 arr sign byte    65 NULL        0 I_SUB[7]
  8281                                  ;  138 arr sign byte    66 NULL        0 I_XOR[7]
  8282                                  ;  139 arr sign byte    67 NULL        0 I_CMP[7]
  8283                                  ;  140 arr sign byte    68 NULL        0 I_TEST[11]
  8284                                  ;  141 arr sign byte    70 NULL        0 I_MOV[6]
  8285                                  ;  142 arr sign byte    71 NULL        0 I_MOVSX[9]
  8286                                  ;  143 arr sign byte    72 NULL        0 I_MOVZX[9]
  8287                                  ;  144 arr sign byte    74 NULL        0 I_JO[6]
  8288                                  ;  145 arr sign byte    75 NULL        0 I_JNO[7]
  8289                                  ;  146 arr sign byte    76 NULL        0 I_JB[6]
  8290                                  ;  147 arr sign byte    77 NULL        0 I_JC[6]
  8291                                  ;  148 arr sign byte    78 NULL        0 I_JNB[7]
  8292                                  ;  149 arr sign byte    79 NULL        0 I_JAE[7]
  8293                                  ;  150 arr sign byte    80 NULL        0 I_JNC[7]
  8294                                  ;  151 arr sign byte    81 NULL        0 I_JE[6]
  8295                                  ;  152 arr sign byte    82 NULL        0 I_JZ[6]
  8296                                  ;  153 arr sign byte    83 NULL        0 I_JNE[7]
  8297                                  ;  154 arr sign byte    84 NULL        0 I_JNZ[7]
  8298                                  ;  155 arr sign byte    85 NULL        0 I_JBE[7]
  8299                                  ;  156 arr sign byte    86 NULL        0 I_JNA[7]
  8300                                  ;  157 arr sign byte    87 NULL        0 I_JA[6]
  8301                                  ;  158 arr sign byte    88 NULL        0 I_JS[6]
  8302                                  ;  159 arr sign byte    89 NULL        0 I_JNS[7]
  8303                                  ;  160 arr sign byte    90 NULL        0 I_JP[6]
  8304                                  ;  161 arr sign byte    91 NULL        0 I_JPE[7]
  8305                                  ;  162 arr sign byte    92 NULL        0 I_JNP[7]
  8306                                  ;  163 arr sign byte    93 NULL        0 I_JPO[7]
  8307                                  ;  164 arr sign byte    94 NULL        0 I_JL[6]
  8308                                  ;  165 arr sign byte    95 NULL        0 I_JNL[7]
  8309                                  ;  166 arr sign byte    96 NULL        0 I_JGE[7]
  8310                                  ;  167 arr sign byte    97 NULL        0 I_JLE[7]
  8311                                  ;  168 arr sign byte    98 NULL        0 I_JNG[7]
  8312                                  ;  169 arr sign byte    99 NULL        0 I_JG[6]
  8313                                  ;  170 arr sign byte   101 NULL        0 I_JMP[8]
  8314                                  ;  171 arr sign byte   102 NULL        0 I_CALL[9]
  8315                                  ;  172 arr sign byte   104 NULL        0 I_RET[8]
  8316                                  ;  173 arr sign byte   105 NULL        0 I_RETF[9]
  8317                                  ;  174 arr sign byte   107 NULL        0 I_PUSH[11]
  8318                                  ;  175 arr sign byte   108 NULL        0 I_POP[10]
  8319                                  ;  176 arr sign byte   110 NULL        0 I_ROL[7]
  8320                                  ;  177 arr sign byte   111 NULL        0 I_ROR[7]
  8321                                  ;  178 arr sign byte   112 NULL        0 I_RCL[7]
  8322                                  ;  179 arr sign byte   113 NULL        0 I_RCR[7]
  8323                                  ;  180 arr sign byte   114 NULL        0 I_SHL[7]
  8324                                  ;  181 arr sign byte   115 NULL        0 I_SAL[7]
  8325                                  ;  182 arr sign byte   116 NULL        0 I_SHR[7]
  8326                                  ;  183 arr sign byte   117 NULL        0 I_SAR[7]
  8327                                  ;  184 arr sign byte   119 NULL        0 I_INT[8]
  8328                                  ;  185 arr sign byte   130 NULL        0 I_XCHG[9]
  8329                                  ;  186 arr sign byte   140 NULL        0 I_ENTER[8]
  8330                                  ;  187 arr sign byte   142 NULL        0 I_ORG[6]
  8331                                  ;  188 arr sign byte   147 NULL        0 I_DB[5]
  8332                                  ;  189 arr sign byte   148 NULL        0 I_DW[5]
  8333                                  ;  190 arr sign byte   149 NULL        0 I_DD[5]
  8334                                  ;  191 arr sign byte   150 NULL        0 I_RESB[7]
  8335                                  ;  192 arr sign byte   151 NULL        0 I_RESW[7]
  8336                                  ;  193 arr sign byte   152 NULL        0 I_RESD[7]
  8337                                  ;  194 var sign byte   153 NULL        0 I_END
  8338                                  
  8339                                  
  8340                                  ;   # Calls Line Width  Name   list of functions
  8341                                  
  8342                                  ;    0    2    1 word   ChangeDirection
  8343                                  ;    1    2    9 word   checkOpL
  8344                                  ;    2    3   18 word   check2Ops
  8345                                  ;    3    1   27 word   get2Ops
  8346                                  ;    4    3   33 word   getOpL
  8347                                  ;    5    2   41 word   getOpR
  8348                                  ;    6    4   51 word   getOp1
  8349                                  ;    7    1   67 word   getMEM
  8350                                  ;    8    1   90 word   getIndReg1
  8351                                  ;    9    1   98 word   getIndReg2
  8352                                  ;   10    2  108 word   setwflag
  8353                                  ;   11    2  119 word   setsflag
  8354                                  ;   12    2  129 word   checkConstSize
  8355                                  ;   13    1    1 word   parse
  8356                                  ;   14   15   35 word   getTokeType
  8357                                  ;   15    2   46 word   storeJmpCall
  8358                                  ;   16    2   57 word   storeLabel
  8359                                  ;   17    5   69 word   searchLabel
  8360                                  ;   18    1   82 word   getVariable
  8361                                  ;   19    2  131 word   lookCode
  8362                                  ;   20    1  147 word   getCodeSize
  8363                                  ;   21    8  155 word   isToken
  8364                                  ;   22    2  163 word   need
  8365                                  ;   23    1  172 word   skipRest
  8366                                  ;   24    1    1 word   getLine
  8367                                  ;   25    1   17 word   ifEOL
  8368                                  ;   26    3   24 word   skipBlank
  8369                                  ;   27    2   29 word   letterE
  8370                                  ;   28    1   39 word   alnumE
  8371                                  ;   29    1   44 word   getDigit
  8372                                  ;   30    1   56 word   getName
  8373                                  ;   31    1   75 word   testReg
  8374                                  ;   32    1    1 word   printLine
  8375                                  ;   33    7   23 word   prc
  8376                                  ;   34    1   35 word   prscomment
  8377                                  ;   35   28   43 word   prs
  8378                                  ;   36    3   65 word   printhex8a
  8379                                  ;   37    2   70 word   printhex4
  8380                                  ;   38    1   75 word   printhex16
  8381                                  ;   39    5   80 word   printIntU
  8382                                  ;   40   25   91 word   error1
  8383                                  ;   41   12   99 word   errorexit
  8384                                  ;   42 NULL  103 word   allowederror
  8385                                  ;   43    3  104 word   addrerror
  8386                                  ;   44    1  105 word   immeerror
  8387                                  ;   45    3  106 word   implerror
  8388                                  ;   46    4  107 word   indexerror
  8389                                  ;   47    3  108 word   invaloperror
  8390                                  ;   48    5  109 word   numbererror
  8391                                  ;   49    1  110 word   regmemerror
  8392                                  ;   50    3  111 word   reg16error
  8393                                  ;   51    1  112 word   segregerror
  8394                                  ;   52    5  113 word   syntaxerror
  8395                                  ;   53 NULL  115 word   addrexit
  8396                                  ;   54    3  116 word   dataexit
  8397                                  ;   55 NULL  117 word   internexit
  8398                                  ;   56 NULL    1 word   main
  8399                                  ;   57    1    9 word   getarg
  8400                                  ;   58    1   43 word   fixJmpCall
  8401                                  ;   59    1   74 word   epilog
  8402                                  ;   60    2  117 word   end1
  8403                                  ;   61    1    2 word   getCodes
  8404                                  ;   62    1    7 word   gen66h
  8405                                  ;   63    8    9 word   genCode2
  8406                                  ;   64   10   13 word   genCodeW
  8407                                  ;   65   33   17 word   genCode8
  8408                                  ;   66   16   28 word   genCode16
  8409                                  ;   67   10   32 word   writeEA
  8410                                  ;   68    4   74 word   genImmediate
  8411                                  ;   69    1   11 word   process
  8412                                  ;   70    4  311 word   writetty
  8413                                  ;   71    8  312 word   cputs
  8414                                  ;   72    2  313 word   toupper
  8415                                  ;   73    4  315 word   strlen
  8416                                  ;   74    8  316 word   strcpy
  8417                                  ;   75    3  318 word   digit
  8418                                  ;   76   35  319 word   eqstr
  8419                                  ;   77    3  322 word   strcat1
  8420                                  ;   78    1  323 word   openR
  8421                                  ;   79    2  324 word   creatR
  8422                                  ;   80    2  325 word   readRL
  8423                                  ;   81    2  326 word   fputcR
  8424                                  ;   82    3  328 word   fcloseR
  8425                                  ;   83    5  329 word   exitR
  8426                                  ;   84    1  331 word   putch
  8427                                  ;   85    4  332 word   DosInt
  8428                                  ;   86 NULL  333 word   LastFunctionByt
  8429                                  
  8430                                  ;    #  addr name   list of CALLs
  8431                                  
  8432                                  ;    0  1399 implerror
  8433                                  ;    1  1409 segregerror
  8434                                  ;    2  1421 setwflag
  8435                                  ;    3  1430 error1
  8436                                  ;    4  1437 error1
  8437                                  ;    5  1454 get2Ops
  8438                                  ;    6  1462 addrerror
  8439                                  ;    7  1472 invaloperror
  8440                                  ;    8  1485 immeerror
  8441                                  ;    9  1495 addrerror
  8442                                  ;   10  1505 invaloperror
  8443                                  ;   11  1518 setwflag
  8444                                  ;   12  1535 getOpL
  8445                                  ;   13  1542 need
  8446                                  ;   14  1547 getOpR
  8447                                  ;   15  1561 getOpR
  8448                                  ;   16  1575 getOp1
  8449                                  ;   17  1582 isToken
  8450                                  ;   18  1590 getMEM
  8451                                  ;   19  1597 invaloperror
  8452                                  ;   20  1610 error1
  8453                                  ;   21  1624 testReg
  8454                                  ;   22  1632 searchLabel
  8455                                  ;   23  1644 error1
  8456                                  ;   24  1660 getTokeType
  8457                                  ;   25  1672 getOp1
  8458                                  ;   26  1679 syntaxerror
  8459                                  ;   27  1691 getIndReg2
  8460                                  ;   28  1702 getIndReg1
  8461                                  ;   29  1713 isToken
  8462                                  ;   30  1721 getTokeType
  8463                                  ;   31  1733 numbererror
  8464                                  ;   32  1745 isToken
  8465                                  ;   33  1753 isToken
  8466                                  ;   34  1761 errorexit
  8467                                  ;   35  1782 indexerror
  8468                                  ;   36  1793 indexerror
  8469                                  ;   37  1817 indexerror
  8470                                  ;   38  1828 indexerror
  8471                                  ;   39  1848 gen66h
  8472                                  ;   40  1867 error1
  8473                                  ;   41  1898 getLine
  8474                                  ;   42  1906 getTokeType
  8475                                  ;   43  1918 storeLabel
  8476                                  ;   44  1929 getTokeType
  8477                                  ;   45  1941 lookCode
  8478                                  ;   46  1950 process
  8479                                  ;   47  1958 getVariable
  8480                                  ;   48  1970 skipRest
  8481                                  ;   49  1979 error1
  8482                                  ;   50  1986 error1
  8483                                  ;   51  1993 printLine
  8484                                  ;   52  2017 skipBlank
  8485                                  ;   53  2027 digit
  8486                                  ;   54  2033 getDigit
  8487                                  ;   55  2042 letterE
  8488                                  ;   56  2050 getName
  8489                                  ;   57  2073 errorexit
  8490                                  ;   58  2083 strcpy
  8491                                  ;   59  2090 errorexit
  8492                                  ;   60  2113 errorexit
  8493                                  ;   61  2123 searchLabel
  8494                                  ;   62  2135 error1
  8495                                  ;   63  2142 strcpy
  8496                                  ;   64  2149 errorexit
  8497                                  ;   65  2177 eqstr
  8498                                  ;   66  2183 strlen
  8499                                  ;   67  2206 storeLabel
  8500                                  ;   68  2217 getTokeType
  8501                                  ;   69  2229 lookCode
  8502                                  ;   70  2238 dataexit
  8503                                  ;   71  2247 dataexit
  8504                                  ;   72  2256 getTokeType
  8505                                  ;   73  2268 genCode8
  8506                                  ;   74  2277 skipBlank
  8507                                  ;   75  2287 isToken
  8508                                  ;   76  2295 genCode8
  8509                                  ;   77  2304 isToken
  8510                                  ;   78  2312 getTokeType
  8511                                  ;   79  2324 genCode16
  8512                                  ;   80  2334 isToken
  8513                                  ;   81  2342 implerror
  8514                                  ;   82  2352 getTokeType
  8515                                  ;   83  2364 syntaxerror
  8516                                  ;   84  2376 genCode8
  8517                                  ;   85  2385 genCode16
  8518                                  ;   86  2395 genCode16
  8519                                  ;   87  2405 genCode16
  8520                                  ;   88  2415 numbererror
  8521                                  ;   89  2427 dataexit
  8522                                  ;   90  2445 eqstr
  8523                                  ;   91  2463 eqstr
  8524                                  ;   92  2469 getTokeType
  8525                                  ;   93  2481 eqstr
  8526                                  ;   94  2487 getTokeType
  8527                                  ;   95  2499 eqstr
  8528                                  ;   96  2505 getTokeType
  8529                                  ;   97  2527 skipBlank
  8530                                  ;   98  2544 isToken
  8531                                  ;   99  2552 getTokeType
  8532                                  ;  100  2564 error1
  8533                                  ;  101  2571 prs
  8534                                  ;  102  2575 prc
  8535                                  ;  103  2588 getTokeType
  8536                                  ;  104  2600 error1
  8537                                  ;  105  2617 readRL
  8538                                  ;  106  2624 errorexit
  8539                                  ;  107  2634 errorexit
  8540                                  ;  108  2644 ifEOL
  8541                                  ;  109  2658 readRL
  8542                                  ;  110  2694 digit
  8543                                  ;  111  2700 letterE
  8544                                  ;  112  2727 digit
  8545                                  ;  113  2747 alnumE
  8546                                  ;  114  2754 errorexit
  8547                                  ;  115  2764 strcpy
  8548                                  ;  116  2771 toupper
  8549                                  ;  117  2787 strlen
  8550                                  ;  118  2794 strlen
  8551                                  ;  119  2801 eqstr
  8552                                  ;  120  2807 eqstr
  8553                                  ;  121  2813 eqstr
  8554                                  ;  122  2819 eqstr
  8555                                  ;  123  2825 eqstr
  8556                                  ;  124  2831 eqstr
  8557                                  ;  125  2837 eqstr
  8558                                  ;  126  2843 eqstr
  8559                                  ;  127  2849 eqstr
  8560                                  ;  128  2855 eqstr
  8561                                  ;  129  2861 eqstr
  8562                                  ;  130  2867 eqstr
  8563                                  ;  131  2873 eqstr
  8564                                  ;  132  2879 eqstr
  8565                                  ;  133  2885 eqstr
  8566                                  ;  134  2891 eqstr
  8567                                  ;  135  2897 eqstr
  8568                                  ;  136  2903 eqstr
  8569                                  ;  137  2909 eqstr
  8570                                  ;  138  2915 eqstr
  8571                                  ;  139  2921 eqstr
  8572                                  ;  140  2927 eqstr
  8573                                  ;  141  2933 eqstr
  8574                                  ;  142  2939 eqstr
  8575                                  ;  143  2945 eqstr
  8576                                  ;  144  2951 eqstr
  8577                                  ;  145  2957 eqstr
  8578                                  ;  146  2963 eqstr
  8579                                  ;  147  2969 eqstr
  8580                                  ;  148  2975 eqstr
  8581                                  ;  149  2995 prs
  8582                                  ;  150  2999 printhex16
  8583                                  ;  151  3010 prs
  8584                                  ;  152  3014 prc
  8585                                  ;  153  3018 printhex8a
  8586                                  ;  154  3029 prs
  8587                                  ;  155  3033 prc
  8588                                  ;  156  3037 prscomment
  8589                                  ;  157  3054 writetty
  8590                                  ;  158  3063 writetty
  8591                                  ;  159  3072 fputcR
  8592                                  ;  160  3094 prc
  8593                                  ;  161  3110 prc
  8594                                  ;  162  3131 printhex4
  8595                                  ;  163  3141 printhex4
  8596                                  ;  164  3163 prc
  8597                                  ;  165  3185 printhex8a
  8598                                  ;  166  3196 printhex8a
  8599                                  ;  167  3221 printIntU
  8600                                  ;  168  3231 prc
  8601                                  ;  169  3244 prs
  8602                                  ;  170  3248 prs
  8603                                  ;  171  3252 prs
  8604                                  ;  172  3256 prs
  8605                                  ;  173  3272 error1
  8606                                  ;  174  3279 end1
  8607                                  ;  175  3297 error1
  8608                                  ;  176  3314 error1
  8609                                  ;  177  3331 error1
  8610                                  ;  178  3348 error1
  8611                                  ;  179  3366 error1
  8612                                  ;  180  3386 error1
  8613                                  ;  181  3405 error1
  8614                                  ;  182  3424 error1
  8615                                  ;  183  3442 error1
  8616                                  ;  184  3461 error1
  8617                                  ;  185  3480 error1
  8618                                  ;  186  3496 errorexit
  8619                                  ;  187  3515 errorexit
  8620                                  ;  188  3536 errorexit
  8621                                  ;  189  3551 getarg
  8622                                  ;  190  3558 parse
  8623                                  ;  191  3564 fixJmpCall
  8624                                  ;  192  3575 epilog
  8625                                  ;  193  3582 end1
  8626                                  ;  194  3606 cputs
  8627                                  ;  195  3612 cputs
  8628                                  ;  196  3618 exitR
  8629                                  ;  197  3624 toupper
  8630                                  ;  198  3632 strcpy
  8631                                  ;  199  3639 strcat1
  8632                                  ;  200  3647 strcpy
  8633                                  ;  201  3654 strcat1
  8634                                  ;  202  3662 strcpy
  8635                                  ;  203  3669 strcat1
  8636                                  ;  204  3677 openR
  8637                                  ;  205  3683 cputs
  8638                                  ;  206  3689 cputs
  8639                                  ;  207  3695 exitR
  8640                                  ;  208  3701 creatR
  8641                                  ;  209  3708 cputs
  8642                                  ;  210  3714 cputs
  8643                                  ;  211  3720 exitR
  8644                                  ;  212  3726 creatR
  8645                                  ;  213  3733 cputs
  8646                                  ;  214  3739 cputs
  8647                                  ;  215  3745 exitR
  8648                                  ;  216  3751 prs
  8649                                  ;  217  3755 prs
  8650                                  ;  218  3759 prs
  8651                                  ;  219  3763 prs
  8652                                  ;  220  3767 prs
  8653                                  ;  221  3771 prs
  8654                                  ;  222  3775 prs
  8655                                  ;  223  3779 prs
  8656                                  ;  224  3783 prs
  8657                                  ;  225  3811 prs
  8658                                  ;  226  3815 printIntU
  8659                                  ;  227  3825 strcpy
  8660                                  ;  228  3832 strlen
  8661                                  ;  229  3839 searchLabel
  8662                                  ;  230  3851 error1
  8663                                  ;  231  3871 prs
  8664                                  ;  232  3875 printIntU
  8665                                  ;  233  3885 prs
  8666                                  ;  234  3889 prs
  8667                                  ;  235  3893 prs
  8668                                  ;  236  3897 prs
  8669                                  ;  237  3901 prs
  8670                                  ;  238  3905 prs
  8671                                  ;  239  3909 printIntU
  8672                                  ;  240  3919 prs
  8673                                  ;  241  3923 fputcR
  8674                                  ;  242  3930 prs
  8675                                  ;  243  3934 printIntU
  8676                                  ;  244  3944 prs
  8677                                  ;  245  3955 fcloseR
  8678                                  ;  246  3963 fcloseR
  8679                                  ;  247  3971 fcloseR
  8680                                  ;  248  3979 exitR
  8681                                  ;  249  4001 genCode8
  8682                                  ;  250  4023 genCode8
  8683                                  ;  251  4043 genCode8
  8684                                  ;  252  4063 errorexit
  8685                                  ;  253  4085 genCode8
  8686                                  ;  254  4094 genCode8
  8687                                  ;  255  4119 genCode8
  8688                                  ;  256  4128 genCode8
  8689                                  ;  257  4137 genCode16
  8690                                  ;  258  4160 genCode16
  8691                                  ;  259  4170 genCode8
  8692                                  ;  260  4189 getTokeType
  8693                                  ;  261  4201 getCodeSize
  8694                                  ;  262  4213 getCodes
  8695                                  ;  263  4222 genCode8
  8696                                  ;  264  4231 getOpL
  8697                                  ;  265  4238 checkOpL
  8698                                  ;  266  4247 genCode2
  8699                                  ;  267  4256 getTokeType
  8700                                  ;  268  4268 implerror
  8701                                  ;  269  4278 genCodeW
  8702                                  ;  270  4287 writeEA
  8703                                  ;  271  4295 check2Ops
  8704                                  ;  272  4305 reg16error
  8705                                  ;  273  4316 addrerror
  8706                                  ;  274  4326 genCode8
  8707                                  ;  275  4335 genCode8
  8708                                  ;  276  4344 writeEA
  8709                                  ;  277  4352 check2Ops
  8710                                  ;  278  4362 setsflag
  8711                                  ;  279  4371 genCodeW
  8712                                  ;  280  4380 genImmediate
  8713                                  ;  281  4393 genCodeW
  8714                                  ;  282  4402 writeEA
  8715                                  ;  283  4410 genCode8
  8716                                  ;  284  4419 genImmediate
  8717                                  ;  285  4432 genCodeW
  8718                                  ;  286  4441 writeEA
  8719                                  ;  287  4449 genCodeW
  8720                                  ;  288  4458 writeEA
  8721                                  ;  289  4466 syntaxerror
  8722                                  ;  290  4478 check2Ops
  8723                                  ;  291  4488 genCode2
  8724                                  ;  292  4497 genImmediate
  8725                                  ;  293  4510 genCodeW
  8726                                  ;  294  4519 writeEA
  8727                                  ;  295  4527 genImmediate
  8728                                  ;  296  4540 regmemerror
  8729                                  ;  297  4552 ChangeDirection
  8730                                  ;  298  4568 reg16error
  8731                                  ;  299  4579 genCode2
  8732                                  ;  300  4588 writeEA
  8733                                  ;  301  4596 genCodeW
  8734                                  ;  302  4605 genCode16
  8735                                  ;  303  4615 genCodeW
  8736                                  ;  304  4624 genCode16
  8737                                  ;  305  4634 genCodeW
  8738                                  ;  306  4643 writeEA
  8739                                  ;  307  4651 ChangeDirection
  8740                                  ;  308  4667 genCodeW
  8741                                  ;  309  4676 writeEA
  8742                                  ;  310  4684 syntaxerror
  8743                                  ;  311  4696 searchLabel
  8744                                  ;  312  4708 checkConstSize
  8745                                  ;  313  4723 genCode2
  8746                                  ;  314  4732 genCode8
  8747                                  ;  315  4741 genCode8
  8748                                  ;  316  4750 genCode2
  8749                                  ;  317  4759 genCode16
  8750                                  ;  318  4769 genCode8
  8751                                  ;  319  4778 genCode2
  8752                                  ;  320  4787 genCode16
  8753                                  ;  321  4797 storeJmpCall
  8754                                  ;  322  4810 searchLabel
  8755                                  ;  323  4822 checkConstSize
  8756                                  ;  324  4837 genCode8
  8757                                  ;  325  4846 genCode8
  8758                                  ;  326  4855 genCode8
  8759                                  ;  327  4864 genCode16
  8760                                  ;  328  4874 genCode8
  8761                                  ;  329  4883 genCode16
  8762                                  ;  330  4893 genCode8
  8763                                  ;  331  4902 genCode16
  8764                                  ;  332  4912 storeJmpCall
  8765                                  ;  333  4925 genCode8
  8766                                  ;  334  4934 genCode16
  8767                                  ;  335  4944 genCode8
  8768                                  ;  336  4953 getOpL
  8769                                  ;  337  4960 setsflag
  8770                                  ;  338  4969 genCode2
  8771                                  ;  339  4978 genCode8
  8772                                  ;  340  4987 genCode16
  8773                                  ;  341  4997 error1
  8774                                  ;  342  5004 genCode8
  8775                                  ;  343  5013 genCode8
  8776                                  ;  344  5022 checkOpL
  8777                                  ;  345  5031 reg16error
  8778                                  ;  346  5042 genCode2
  8779                                  ;  347  5051 genCode8
  8780                                  ;  348  5060 writeEA
  8781                                  ;  349  5068 syntaxerror
  8782                                  ;  350  5080 genCode8
  8783                                  ;  351  5089 genCode8
  8784                                  ;  352  5098 genCode8
  8785                                  ;  353  5107 getOp1
  8786                                  ;  354  5114 genCode16
  8787                                  ;  355  5124 numbererror
  8788                                  ;  356  5136 need
  8789                                  ;  357  5141 getOp1
  8790                                  ;  358  5148 genCode8
  8791                                  ;  359  5157 numbererror
  8792                                  ;  360  5169 numbererror
  8793                                  ;  361  5181 error1
  8794                                  ;  362  5207 putch
  8795                                  ;  363  5275 strcpy
  8796                                  ;  364  5290 DosInt
  8797                                  ;  365  5306 DosInt
  8798                                  ;  366  5329 DosInt
  8799                                  ;  367  5348 DosInt
  8800                                  ;  368  5382 writetty
  8801                                  ;  369  5391 writetty
  8802                                  ;Input: AS.C, List: AS.S,  Lines:  334
  8803                                  ;Glob. variables:  194 max.:  200
  8804                                  ;Local variables:    5 max.:  100, in 'fixJmpCall'
  8805                                  ;Functions      :   87 max.:  300
  8806                                  ;Calls          :  370 max.: 2000, NameField: 5423 max.:    65535
  8807                                  ;Code until     :25998 max.: 30000, free: 4002
  8808                                  ;Data (HeapEnd) :36595, resting stacksize: 28940
  8809                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
