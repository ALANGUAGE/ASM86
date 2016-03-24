     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E98136                  jmp main
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
   235                                  ;-60 char PrintRA;           //print r8, R16, A16 (relocative, absolute)
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
   289                                  ;-75 char JmpCallRelAbs      [JMPCALLMAX];//r8, R16, A16
   290                                  
   291 0000123C <res 000001F4>          JmpCallRelAbs resb 500
   292                                  
   293                                  ;-76 int JmpCallMaxIx=0;     //actual # of jmp, call. 1 to JMPCALLMAX-1
   294                                  
   295 00001430 0000                    JmpCallMaxIx dw 0
   296                                  
   297                                  ;-77  
   298                                  
   299                                  
   300                                  ;-78 #define FILEBINMAX 2000 
   301                                  
   302                                  
   303                                  ;-79 char FileBin  [FILEBINMAX];//output binary file
   304                                  
   305 00001432 <res 000007D0>          FileBin resb 2000
   306                                  
   307                                  ;-80 unsigned int BinLen=0;  //length of binary file
   308                                  
   309 00001C02 0000                    BinLen dw 0
   310                                  
   311                                  ;-81 
   312                                  
   313                                  
   314                                  ;-82 char *arglen=0x80;      // for main only
   315                                  
   316 00001C04 8000                    arglen dw 128
   317                                  
   318                                  ;-83 char *argv=0x82;        // for main only
   319                                  
   320 00001C06 8200                    argv dw 130
   321                                  ;Back to main program: AS.C
   322                                  
   323                                  ;-3 #include "OPTABL.C"   
   324                                  
   325                                  ;Use include file: OPTABL.C
   326                                  
   327                                  ;-1 char I_START=0xF1;
   328                                  
   329 00001C08 F1                      I_START db 241
   330                                  
   331                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   332                                  
   333                                  
   334                                  ;-3 //  1:   1 byte opcode
   335                                  
   336                                  
   337                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   338                                  
   339 00001C09 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   340                                  
   341                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   342                                  
   343 00001C12 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   344                                  
   345                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   346                                  
   347 00001C1A 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   348                                  
   349                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   350                                  
   351 00001C21 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   352                                  
   353                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   354                                  
   355 00001C28 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   356                                  
   357                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   358                                  
   359 00001C30 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   360                                  
   361                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   362                                  
   363 00001C37 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   364                                  
   365                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   366                                  
   367 00001C3E 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   368                                  
   369                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   370                                  
   371 00001C46 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   372                                  
   373                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   374                                  
   375 00001C4F 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   376                                  
   377                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   378                                  
   379 00001C57 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   380                                  
   381                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   382                                  
   383 00001C5F 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   384                                  
   385                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   386                                  
   387 00001C67 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   388                                  
   389                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   390                                  
   391 00001C70 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   392                                  
   393                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   394                                  
   395 00001C79 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   396                                  
   397                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   398                                  
   399 00001C82 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   400                                  
   401                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   402                                  
   403 00001C8B 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   404                                  
   405                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   406                                  
   407 00001C94 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   408                                  
   409                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   410                                  
   411 00001C9D 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   412                                  
   413                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   414                                  
   415 00001CA6 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   416                                  
   417                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   418                                  
   419 00001CAF 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   420                                  
   421                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   422                                  
   423 00001CB8 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   424                                  
   425                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   426                                  
   427 00001CC1 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   428                                  
   429                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   430                                  
   431 00001CCA 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   432                                  
   433                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   434                                  
   435 00001CD2 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   436                                  
   437                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   438                                  
   439 00001CDA 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   440                                  
   441                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   442                                  
   443 00001CE2 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   444                                  
   445                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   446                                  
   447 00001CEA 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   448                                  
   449                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   450                                  
   451 00001CF2 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   452                                  
   453                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   454                                  
   455 00001CFB 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   456                                  
   457                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   458                                  
   459 00001D04 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   460                                  
   461                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   462                                  
   463 00001D0C 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   464                                  
   465                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   466                                  
   467 00001D14 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   468                                  
   469                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   470                                  
   471 00001D1B 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   472                                  
   473                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   474                                  
   475 00001D22 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   476                                  
   477                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   478                                  
   479 00001D29 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   480                                  
   481                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   482                                  
   483 00001D30 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   484                                  
   485                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   486                                  
   487 00001D37 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   488                                  
   489                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   490                                  
   491 00001D3E 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   492                                  
   493                                  ;-43 // 2: mem reg 16 bit
   494                                  
   495                                  
   496                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   497                                  
   498 00001D45 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   499                                  
   500                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   501                                  
   502 00001D4E 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   503                                  
   504                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   505                                  
   506 00001D57 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   507                                  
   508                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   509                                  
   510 00001D5F 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   511                                  
   512                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   513                                  
   514 00001D67 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   515                                  
   516                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   517                                  
   518 00001D6F 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   519                                  
   520                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   521                                  
   522 00001D78 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   523                                  
   524                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   525                                  
   526 00001D80 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   527                                  
   528                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   529                                  
   530                                  
   531                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   532                                  
   533 00001D89 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   534                                  
   535                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   536                                  
   537 00001D90 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   538                                  
   539                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   540                                  
   541 00001D97 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   542                                  
   543                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   544                                  
   545 00001D9E 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   546                                  
   547                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   548                                  
   549 00001DA6 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   550                                  
   551                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   552                                  
   553 00001DAE 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   554                                  
   555                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   556                                  
   557                                  
   558                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   559                                  
   560 00001DB6 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   561                                  
   562                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   563                                  
   564 00001DBD 4F52000401F1            I_OR db 79,82,0,4,1,241
   565                                  
   566                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   567                                  
   568 00001DC3 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   569                                  
   570                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   571                                  
   572 00001DCA 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   573                                  
   574                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   575                                  
   576 00001DD1 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   577                                  
   578                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   579                                  
   580 00001DD8 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   581                                  
   582                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   583                                  
   584 00001DDF 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   585                                  
   586                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   587                                  
   588 00001DE6 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   589                                  
   590                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   591                                  
   592 00001DED 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   593 00001DF6 00F1               
   594                                  
   595                                  ;-69 //  5: mov
   596                                  
   597                                  
   598                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   599                                  
   600 00001DF8 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   601                                  
   602                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   603                                  
   604 00001DFE 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   605                                  
   606                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   607                                  
   608 00001E07 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   609                                  
   610                                  ;-73 //  6: single byte relative jump
   611                                  
   612                                  
   613                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   614                                  
   615 00001E10 4A4F000600F1            I_JO db 74,79,0,6,0,241
   616                                  
   617                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   618                                  
   619 00001E16 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   620                                  
   621                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   622                                  
   623 00001E1D 4A42000602F1            I_JB db 74,66,0,6,2,241
   624                                  
   625                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   626                                  
   627 00001E23 4A43000602F1            I_JC db 74,67,0,6,2,241
   628                                  
   629                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   630                                  
   631 00001E29 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   632                                  
   633                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   634                                  
   635 00001E30 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   636                                  
   637                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   638                                  
   639 00001E37 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   640                                  
   641                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   642                                  
   643 00001E3E 4A45000604F1            I_JE db 74,69,0,6,4,241
   644                                  
   645                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   646                                  
   647 00001E44 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   648                                  
   649                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   650                                  
   651 00001E4A 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   652                                  
   653                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   654                                  
   655 00001E51 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   656                                  
   657                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   658                                  
   659 00001E58 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   660                                  
   661                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   662                                  
   663 00001E5F 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   664                                  
   665                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   666                                  
   667 00001E66 4A41000607F1            I_JA db 74,65,0,6,7,241
   668                                  
   669                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   670                                  
   671 00001E6C 4A53000608F1            I_JS db 74,83,0,6,8,241
   672                                  
   673                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   674                                  
   675 00001E72 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   676                                  
   677                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   678                                  
   679 00001E79 4A5000060AF1            I_JP db 74,80,0,6,10,241
   680                                  
   681                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   682                                  
   683 00001E7F 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   684                                  
   685                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   686                                  
   687 00001E86 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   688                                  
   689                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   690                                  
   691 00001E8D 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   692                                  
   693                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   694                                  
   695 00001E94 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   696                                  
   697                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   698                                  
   699 00001E9A 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   700                                  
   701                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   702                                  
   703 00001EA1 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   704                                  
   705                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   706                                  
   707 00001EA8 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   708                                  
   709                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   710                                  
   711 00001EAF 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   712                                  
   713                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   714                                  
   715 00001EB6 4A4700060FF1            I_JG db 74,71,0,6,15,241
   716                                  
   717                                  ;-100 //  7: jmp, call
   718                                  
   719                                  
   720                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   721                                  
   722 00001EBC 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   723                                  
   724                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   725                                  
   726 00001EC4 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   727                                  
   728                                  ;-103 //  8: ret
   729                                  
   730                                  
   731                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   732                                  
   733 00001ECD 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   734                                  
   735                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   736                                  
   737 00001ED5 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   738                                  
   739                                  ;-106 //  9: seg, r/m
   740                                  
   741                                  
   742                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   743                                  
   744 00001EDE 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   745 00001EE7 06F1               
   746                                  
   747                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   748                                  
   749 00001EE9 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   750 00001EF2 F1                 
   751                                  
   752                                  ;-109 //  11: shift, rotates
   753                                  
   754                                  
   755                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   756                                  
   757 00001EF3 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   758                                  
   759                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   760                                  
   761 00001EFA 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   762                                  
   763                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   764                                  
   765 00001F01 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   766                                  
   767                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   768                                  
   769 00001F08 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   770                                  
   771                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   772                                  
   773 00001F0F 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   774                                  
   775                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   776                                  
   777 00001F16 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   778                                  
   779                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   780                                  
   781 00001F1D 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   782                                  
   783                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   784                                  
   785 00001F24 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   786                                  
   787                                  ;-118 //  12: int
   788                                  
   789                                  
   790                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   791                                  
   792 00001F2B 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
   793                                  
   794                                  ;-120 //  14: in/out
   795                                  
   796                                  
   797                                  ;-121 /*char I_IN[]=   {'I','N',0,              14,0xE4,0xEC,0xF1};
   798                                  
   799                                  
   800                                  ;-122 char I_INSB[]= {'I','N','S','B',0,      14,0x6C,   0xF1};
   801                                  
   802                                  
   803                                  ;-123 char I_INSW[]= {'I','N','S','W',0,      14,0x6D,   0xF1};
   804                                  
   805                                  
   806                                  ;-124 char I_INSD[]= {'I','N','S','D',0,      14,0x6D,   0xF1};
   807                                  
   808                                  
   809                                  ;-125 char I_OUT[]=  {'O','U','T',0,          14,0xE6,0xEE,0xF1};
   810                                  
   811                                  
   812                                  ;-126 char I_OUTSB[]={'O','U','T','B',0,      14,0x6E,   0xF1};
   813                                  
   814                                  
   815                                  ;-127 char I_OUTSW[]={'O','U','T','W',0,      14,0x6F,   0xF1};
   816                                  
   817                                  
   818                                  ;-128 char I_OUTSD[]={'O','U','T','D',0,      14,0x6F,   0xF1};*/
   819                                  
   820                                  
   821                                  ;-129 //  15: xchg
   822                                  
   823                                  
   824                                  ;-130 char I_XCHG[]= {'X','C','H','G',0,      15,0x86,0x90,0xF1};
   825                                  
   826 00001F33 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
   827                                  
   828                                  ;-131 //  16: loop, jcxz
   829                                  
   830                                  
   831                                  ;-132 /*char I_LOOPNZ[]={'L','O','O','P','N','Z',0, 16,0xE0,0xF1};
   832                                  
   833                                  
   834                                  ;-133 char I_LOOPNE[]={'L','O','O','P','N','E',0, 16,0xE0,0xF1};
   835                                  
   836                                  
   837                                  ;-134 char I_LOOPZ[]={'L','O','O','P','Z',0,      16,0xE1,0xF1};
   838                                  
   839                                  
   840                                  ;-135 char I_LOOPE[]={'L','O','O','P','E',0,      16,0xE1,0xF1};
   841                                  
   842                                  
   843                                  ;-136 char I_LOOP[]= {'L','O','O','P',0,          16,0xE2,0xF1};
   844                                  
   845                                  
   846                                  ;-137 char I_JCXZ[]= {'J','C','X','Z',0,          16,0xE3,0xF1};
   847                                  
   848                                  
   849                                  ;-138 char I_JECXZ[]= {'J','E','C','X','Z',0,     16,0xE3,0xF1};*/
   850                                  
   851                                  
   852                                  ;-139 //  30: enter
   853                                  
   854                                  
   855                                  ;-140 char I_ENTER[]={'E','N','T','E','R',0,  30,       0xF1};
   856                                  
   857 00001F3C 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   858                                  
   859                                  ;-141 // 100: directives
   860                                  
   861                                  
   862                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   863                                  
   864 00001F44 4F52470065F1            I_ORG db 79,82,71,0,101,241
   865                                  
   866                                  ;-143 // section, segment .TEXT .DATA .BSS
   867                                  
   868                                  
   869                                  ;-144 /*char I_SECTION[]={'S','E','C','T','I','O','N',0,      102, 0xF1};
   870                                  
   871                                  
   872                                  ;-145 char I_SEGMENT[]={'S','E','G','M','E','N','T',0,      102, 0xF1};
   873                                  
   874                                  
   875                                  ;-146 char I_ABSOLUTE[]={'A','B','S','O','L','U','T','E',0, 110, 0xF1};*/
   876                                  
   877                                  
   878                                  ;-147 char I_DB[]=   {'D','B',0,            200,        0xF1};
   879                                  
   880 00001F4A 444200C8F1              I_DB db 68,66,0,200,241
   881                                  
   882                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   883                                  
   884 00001F4F 445700C9F1              I_DW db 68,87,0,201,241
   885                                  
   886                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   887                                  
   888 00001F54 444400CAF1              I_DD db 68,68,0,202,241
   889                                  
   890                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   891                                  
   892 00001F59 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   893                                  
   894                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   895                                  
   896 00001F60 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   897                                  
   898                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   899                                  
   900 00001F67 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   901                                  
   902                                  ;-153 char I_END=0;// end of table char
   903                                  
   904 00001F6E 00                      I_END db 0
   905                                  ;Back to main program: AS.C
   906                                  
   907                                  ;-4 #include "OPS.C"
   908                                  
   909                                  ;Use include file: OPS.C
   910                                  
   911                                  ;-1 int ChangeDirection() {
   912                                  
   913                                  
   914                                  ChangeDirection:  ; *** PROC ***
   915                                  
   916                                  ;-2     char c;
   917                                  
   918                                  
   919                                  ;-3     c=Op;     Op    =Op2;    Op2   =c;
   920                                  
   921                                  ;Function : ChangeDirection, Number of local variables: 1
   922                                  ;   # type sign width line used address name   list of local variables
   923                                  ;  200 var sign byte     2 NULL bp-2    c;
   924 00001F6F C8020000                 ENTER  2,0
   925 00001F73 A0[AE01]                 mov al, [Op]
   926 00001F76 8846FE                   mov byte [bp-2], al
   927 00001F79 A0[AF01]                 mov al, [Op2]
   928 00001F7C A2[AE01]                 mov byte [Op], al
   929 00001F7F 8A46FE                   mov al, [bp-2]
   930 00001F82 A2[AF01]                 mov byte [Op2], al
   931                                  
   932                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   933                                  
   934 00001F85 A0[B701]                 mov al, [R1Type]
   935 00001F88 8846FE                   mov byte [bp-2], al
   936 00001F8B A0[B601]                 mov al, [R2Type]
   937 00001F8E A2[B701]                 mov byte [R1Type], al
   938 00001F91 8A46FE                   mov al, [bp-2]
   939 00001F94 A2[B601]                 mov byte [R2Type], al
   940                                  
   941                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   942                                  
   943 00001F97 A0[B501]                 mov al, [R1No]
   944 00001F9A 8846FE                   mov byte [bp-2], al
   945 00001F9D A0[B401]                 mov al, [R2No]
   946 00001FA0 A2[B501]                 mov byte [R1No], al
   947 00001FA3 8A46FE                   mov al, [bp-2]
   948 00001FA6 A2[B401]                 mov byte [R2No], al
   949                                  
   950                                  ;-6     dflag=2;     
   951                                  
   952 00001FA9 66B802000000             mov eax, 2
   953 00001FAF A2[BA01]                 mov byte [dflag], al
   954                                  
   955                                  ;-7 }
   956                                  
   957                                  
   958                                  ;-8      
   959                                  
   960                                  
   961                                  ;-9 int checkOpL() {
   962 00001FB2 C9                       LEAVE
   963 00001FB3 C3                       ret
   964                                  ; ENDP
   965                                  
   966                                  checkOpL:  ; *** PROC ***
   967                                  
   968                                  ;-10     if (Op == ADR) implerror();
   969                                  
   970 00001FB4 A0[AE01]                 mov al, [Op]
   971 00001FB7 3C03                     cmp al, 3
   972 00001FB9 0F850300                 jne @@checkOpL1
   973 00001FBD E88A15                   call implerror
   974                                  
   975                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   976                                  
   977                                  @@checkOpL1:
   978 00001FC0 A0[B701]                 mov al, [R1Type]
   979 00001FC3 3C04                     cmp al, 4
   980 00001FC5 0F850600                 jne @@checkOpL2
   981 00001FC9 E84616                   call segregerror
   982 00001FCC E93E00                   jmp @@retn
   983                                  
   984                                  ;-12     setwflag();
   985                                  
   986                                  @@checkOpL2:
   987 00001FCF E8CB03                   call setwflag
   988                                  
   989                                  ;-13     if (OpSize == 0) error1("no op size declared");
   990                                  
   991 00001FD2 A0[B801]                 mov al, [OpSize]
   992 00001FD5 3C00                     cmp al, 0
   993 00001FD7 0F850900                 jne @@checkOpL3
   994 00001FDB 68[0E20]                 push checkOpL_0
   995 00001FDE E89914                   call error1
   996 00001FE1 83C402                   add  sp, 2
   997                                  
   998                                  ;-14     if (OpSize == R1Type) return;
   999                                  
  1000                                  @@checkOpL3:
  1001 00001FE4 A0[B801]                 mov al, [OpSize]
  1002 00001FE7 3A06[B701]               cmp al, [R1Type]
  1003 00001FEB 0F850300                 jne @@checkOpL4
  1004 00001FEF E91B00                   jmp @@retn
  1005                                  
  1006                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1007                                  
  1008                                  @@checkOpL4:
  1009 00001FF2 A0[AE01]                 mov al, [Op]
  1010 00001FF5 3C02                     cmp al, 2
  1011 00001FF7 0F851200                 jne @@checkOpL5
  1012 00001FFB A0[B701]                 mov al, [R1Type]
  1013 00001FFE 3C00                     cmp al, 0
  1014 00002000 0F850900                 jne @@checkOpL6
  1015 00002004 68[2220]                 push checkOpL_1
  1016 00002007 E87014                   call error1
  1017 0000200A 83C402                   add  sp, 2
  1018                                  
  1019                                  ;-16 }
  1020                                  
  1021                                  @@checkOpL6:
  1022                                  @@checkOpL5:
  1023                                  
  1024                                  ;-17     
  1025                                  
  1026                                  
  1027                                  ;-18 int check2Ops() {
  1028                                  
  1029                                  @@retn:
  1030 0000200D C3                       ret
  1031                                  ; ENDP
  1032 0000200E 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1033 00002017 65206465636C617265-
  1034 00002020 6400               
  1035 00002022 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1036 0000202B 657220646566696E65-
  1037 00002034 6400               
  1038                                  
  1039                                  check2Ops:  ; *** PROC ***
  1040                                  
  1041                                  ;-19     get2Ops();
  1042                                  
  1043 00002036 E84900                   call get2Ops
  1044                                  
  1045                                  ;-20     if (Op ==   0) addrerror();
  1046                                  
  1047 00002039 A0[AE01]                 mov al, [Op]
  1048 0000203C 3C00                     cmp al, 0
  1049 0000203E 0F850300                 jne @@check2Ops7
  1050 00002042 E8C614                   call addrerror
  1051                                  
  1052                                  ;-21     if (Op == ADR) invaloperror(); 
  1053                                  
  1054                                  @@check2Ops7:
  1055 00002045 A0[AE01]                 mov al, [Op]
  1056 00002048 3C03                     cmp al, 3
  1057 0000204A 0F850300                 jne @@check2Ops8
  1058 0000204E E83415                   call invaloperror
  1059                                  
  1060                                  ;-22     if (Op == IMM) immeerror();   
  1061                                  
  1062                                  @@check2Ops8:
  1063 00002051 A0[AE01]                 mov al, [Op]
  1064 00002054 3C01                     cmp al, 1
  1065 00002056 0F850300                 jne @@check2Ops9
  1066 0000205A E8C814                   call immeerror
  1067                                  
  1068                                  ;-23     if (Op2==   0) addrerror();
  1069                                  
  1070                                  @@check2Ops9:
  1071 0000205D A0[AF01]                 mov al, [Op2]
  1072 00002060 3C00                     cmp al, 0
  1073 00002062 0F850300                 jne @@check2Ops10
  1074 00002066 E8A214                   call addrerror
  1075                                  
  1076                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           
  1077                                  
  1078                                  @@check2Ops10:
  1079 00002069 A0[B001]                 mov al, [CodeType]
  1080 0000206C 3C05                     cmp al, 5
  1081 0000206E 0F840C00                 je  @@check2Ops11
  1082 00002072 A0[AF01]                 mov al, [Op2]
  1083 00002075 3C03                     cmp al, 3
  1084 00002077 0F850300                 jne @@check2Ops12
  1085 0000207B E80715                   call invaloperror
  1086                                  
  1087                                  ;-25     setwflag();       
  1088                                  
  1089                                  @@check2Ops12:
  1090                                  @@check2Ops11:
  1091 0000207E E81C03                   call setwflag
  1092                                  
  1093                                  ;-26 }    
  1094                                  
  1095                                  
  1096                                  ;-27 int get2Ops() {
  1097                                  
  1098 00002081 C3                       ret
  1099                                  ; ENDP
  1100                                  
  1101                                  get2Ops:  ; *** PROC ***
  1102                                  
  1103                                  ;-28     getOpL();
  1104                                  
  1105 00002082 E80C00                   call getOpL
  1106                                  
  1107                                  ;-29     need(',');    
  1108                                  
  1109 00002085 6A2C                     push 44
  1110 00002087 E8C709                   call need
  1111 0000208A 83C402                   add  sp, 2
  1112                                  
  1113                                  ;-30     getOpR();         
  1114                                  
  1115 0000208D E83200                   call getOpR
  1116                                  
  1117                                  ;-31 } 
  1118                                  
  1119                                  
  1120                                  ;-32         
  1121                                  
  1122                                  
  1123                                  ;-33 int getOpL() {
  1124                                  
  1125 00002090 C3                       ret
  1126                                  ; ENDP
  1127                                  
  1128                                  getOpL:  ; *** PROC ***
  1129                                  
  1130                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1131                                  
  1132                                  
  1133                                  ;-35     getOpR();
  1134                                  
  1135 00002091 E82E00                   call getOpR
  1136                                  
  1137                                  ;-36     Op=Op2;         Op2=0;
  1138                                  
  1139 00002094 A0[AF01]                 mov al, [Op2]
  1140 00002097 A2[AE01]                 mov byte [Op], al
  1141 0000209A 66B800000000             mov eax, 0
  1142 000020A0 A2[AF01]                 mov byte [Op2], al
  1143                                  
  1144                                  ;-37     R1No=R2No;      R2No=0;
  1145                                  
  1146 000020A3 A0[B401]                 mov al, [R2No]
  1147 000020A6 A2[B501]                 mov byte [R1No], al
  1148 000020A9 66B800000000             mov eax, 0
  1149 000020AF A2[B401]                 mov byte [R2No], al
  1150                                  
  1151                                  ;-38     R1Type=R2Type; R2Type=0; 
  1152                                  
  1153 000020B2 A0[B601]                 mov al, [R2Type]
  1154 000020B5 A2[B701]                 mov byte [R1Type], al
  1155 000020B8 66B800000000             mov eax, 0
  1156 000020BE A2[B601]                 mov byte [R2Type], al
  1157                                  
  1158                                  ;-39 }  
  1159                                  
  1160                                  
  1161                                  ;-40 
  1162                                  
  1163                                  
  1164                                  ;-41 int getOpR() {
  1165                                  
  1166 000020C1 C3                       ret
  1167                                  ; ENDP
  1168                                  
  1169                                  getOpR:  ; *** PROC ***
  1170                                  
  1171                                  ;-42     Op2=getOp1();
  1172                                  
  1173 000020C2 E88900                   call getOp1
  1174 000020C5 A2[AF01]                 mov byte [Op2], al
  1175                                  
  1176                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1177                                  
  1178 000020C8 6A5B                     push 91
  1179 000020CA E85609                   call isToken
  1180 000020CD 83C402                   add  sp, 2
  1181 000020D0 08C0                     or  al, al
  1182 000020D2 0F840F00                 je @@getOpR13
  1183 000020D6 66B804000000             mov eax, 4
  1184 000020DC A2[AF01]                 mov byte [Op2], al
  1185 000020DF E8F200                   call getMEM
  1186 000020E2 E94F00                   jmp @@retn
  1187                                  
  1188                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1189                                  
  1190                                  @@getOpR13:
  1191 000020E5 A0[AF01]                 mov al, [Op2]
  1192 000020E8 3C00                     cmp al, 0
  1193 000020EA 0F850600                 jne @@getOpR14
  1194 000020EE E89414                   call invaloperror
  1195 000020F1 E94000                   jmp @@retn
  1196                                  
  1197                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1198                                  
  1199                                  @@getOpR14:
  1200 000020F4 A0[AF01]                 mov al, [Op2]
  1201 000020F7 3C01                     cmp al, 1
  1202 000020F9 0F850900                 jne @@getOpR15
  1203 000020FD A1[4D00]                 mov ax, [SymbolInt]
  1204 00002100 A3[C001]                 mov word [imme], ax
  1205 00002103 E92E00                   jmp @@retn
  1206                                  
  1207                                  ;-46     if (Op2 == REG)                            return;
  1208                                  
  1209                                  @@getOpR15:
  1210 00002106 A0[AF01]                 mov al, [Op2]
  1211 00002109 3C02                     cmp al, 2
  1212 0000210B 0F850300                 jne @@getOpR16
  1213 0000210F E92200                   jmp @@retn
  1214                                  
  1215                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1216                                  
  1217                                  @@getOpR16:
  1218 00002112 A0[AF01]                 mov al, [Op2]
  1219 00002115 3C03                     cmp al, 3
  1220 00002117 0F851000                 jne @@getOpR17
  1221 0000211B 8B1E[8006]               mov bx, [LabelIx]
  1222 0000211F D1E3                     shl bx, 1
  1223 00002121 8B87[B605]               mov ax, [LabelAddr + bx]
  1224 00002125 A3[BE01]                 mov word [disp], ax
  1225 00002128 E90900                   jmp @@retn
  1226                                  
  1227                                  ;-48     error1("Name of operand expected");
  1228                                  
  1229                                  @@getOpR17:
  1230 0000212B 68[3521]                 push getOpR_0
  1231 0000212E E84913                   call error1
  1232 00002131 83C402                   add  sp, 2
  1233                                  
  1234                                  ;-49 }
  1235                                  
  1236                                  
  1237                                  ;-50 
  1238                                  
  1239                                  
  1240                                  ;-51 int getOp1() {//scan for a single operand
  1241                                  
  1242                                  @@retn:
  1243 00002134 C3                       ret
  1244                                  ; ENDP
  1245 00002135 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1246 0000213E 706572616E64206578-
  1247 00002147 70656374656400     
  1248                                  
  1249                                  getOp1:  ; *** PROC ***
  1250                                  
  1251                                  ;-52 //return:0, IMM, REG, ADR (not MEM)
  1252                                  
  1253                                  
  1254                                  ;-53 //set   :R2Type, R2No by testReg
  1255                                  
  1256                                  
  1257                                  ;-54 //set   :LabelIx by searchLabel
  1258                                  
  1259                                  
  1260                                  ;-55     if (TokeType == 0)      return 0;
  1261                                  
  1262 0000214E A0[AD01]                 mov al, [TokeType]
  1263 00002151 3C00                     cmp al, 0
  1264 00002153 0F850900                 jne @@getOp118
  1265 00002157 66B800000000             mov eax, 0
  1266 0000215D E96000                   jmp @@retn
  1267                                  
  1268                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1269                                  
  1270                                  @@getOp118:
  1271 00002160 A0[AD01]                 mov al, [TokeType]
  1272 00002163 3C01                     cmp al, 1
  1273 00002165 0F850900                 jne @@getOp119
  1274 00002169 66B801000000             mov eax, 1
  1275 0000216F E94E00                   jmp @@retn
  1276                                  
  1277                                  ;-57     if (TokeType == ALNUME) {
  1278                                  
  1279                                  @@getOp119:
  1280 00002172 A0[AD01]                 mov al, [TokeType]
  1281 00002175 3C03                     cmp al, 3
  1282 00002177 0F853C00                 jne @@getOp120
  1283                                  
  1284                                  ;-58         R2No=testReg();
  1285                                  
  1286 0000217B E8520C                   call testReg
  1287 0000217E A2[B401]                 mov byte [R2No], al
  1288                                  
  1289                                  ;-59         if (R2Type)        return REG;
  1290                                  
  1291 00002181 A0[B601]                 mov al, [R2Type]
  1292 00002184 08C0                     or  al, al
  1293 00002186 0F840900                 je @@getOp121
  1294 0000218A 66B802000000             mov eax, 2
  1295 00002190 E92D00                   jmp @@retn
  1296                                  
  1297                                  ;-60         LabelIx=searchLabel();
  1298                                  
  1299                                  @@getOp121:
  1300 00002193 E8FE05                   call searchLabel
  1301 00002196 A3[8006]                 mov word [LabelIx], ax
  1302                                  
  1303                                  ;-61         if (LabelIx)        return ADR;
  1304                                  
  1305 00002199 A1[8006]                 mov ax, [LabelIx]
  1306 0000219C 08C0                     or  al, al
  1307 0000219E 0F840C00                 je @@getOp122
  1308 000021A2 66B803000000             mov eax, 3
  1309 000021A8 E91500                   jmp @@retn
  1310                                  
  1311                                  ;-62         else error1("variable not found"); 
  1312                                  
  1313 000021AB E90900                   jmp @@getOp123
  1314                                  @@getOp122:
  1315 000021AE 68[C121]                 push getOp1_0
  1316 000021B1 E8C612                   call error1
  1317 000021B4 83C402                   add  sp, 2
  1318                                  
  1319                                  ;-63     }
  1320                                  
  1321                                  @@getOp123:
  1322                                  
  1323                                  ;-64     return 0;
  1324                                  
  1325                                  @@getOp120:
  1326 000021B7 66B800000000             mov eax, 0
  1327 000021BD E90000                   jmp @@retn
  1328                                  
  1329                                  ;-65 }
  1330                                  
  1331                                  
  1332                                  ;-66 
  1333                                  
  1334                                  
  1335                                  ;-67 int getMEM() {// e.g. [array+bp+si-4]
  1336                                  
  1337                                  @@retn:
  1338 000021C0 C3                       ret
  1339                                  ; ENDP
  1340 000021C1 7661726961626C6520-     getOp1_0 db "variable not found",0
  1341 000021CA 6E6F7420666F756E64-
  1342 000021D3 00                 
  1343                                  
  1344                                  getMEM:  ; *** PROC ***
  1345                                  
  1346                                  ;-68 //set: disp, rm, R2Type
  1347                                  
  1348                                  
  1349                                  ;-69     char c;
  1350                                  
  1351                                  
  1352                                  ;-70     disp=0; rm=0;
  1353                                  
  1354                                  ;Function : getMEM, Number of local variables: 1
  1355                                  ;   # type sign width line used address name   list of local variables
  1356                                  ;  200 var sign byte    69 NULL bp-2    c;
  1357 000021D4 C8020000                 ENTER  2,0
  1358 000021D8 66B800000000             mov eax, 0
  1359 000021DE A3[BE01]                 mov word [disp], ax
  1360 000021E1 66B800000000             mov eax, 0
  1361 000021E7 A2[BC01]                 mov byte [rm], al
  1362                                  
  1363                                  ;-71     do {
  1364                                  
  1365                                  @@getMEM24:
  1366                                  
  1367                                  ;-72         getTokeType();
  1368                                  
  1369 000021EA E8D203                   call getTokeType
  1370                                  
  1371                                  ;-73         c=getOp1();
  1372                                  
  1373 000021ED E85EFF                   call getOp1
  1374 000021F0 8846FE                   mov byte [bp-2], al
  1375                                  
  1376                                  ;-74         if (c ==   0) syntaxerror();
  1377                                  
  1378 000021F3 8A46FE                   mov al, [bp-2]
  1379 000021F6 3C00                     cmp al, 0
  1380 000021F8 0F850300                 jne @@getMEM25
  1381 000021FC E83A14                   call syntaxerror
  1382                                  
  1383                                  ;-75         if (c == REG) {
  1384                                  
  1385                                  @@getMEM25:
  1386 000021FF 8A46FE                   mov al, [bp-2]
  1387 00002202 3C02                     cmp al, 2
  1388 00002204 0F851E00                 jne @@getMEM26
  1389                                  
  1390                                  ;-76             isDirect=0;
  1391                                  
  1392 00002208 66B800000000             mov eax, 0
  1393 0000220E A2[BD01]                 mov byte [isDirect], al
  1394                                  
  1395                                  ;-77             if (rm) rm=getIndReg2();
  1396                                  
  1397 00002211 A0[BC01]                 mov al, [rm]
  1398 00002214 08C0                     or  al, al
  1399 00002216 0F840900                 je @@getMEM27
  1400 0000221A E8F300                   call getIndReg2
  1401 0000221D A2[BC01]                 mov byte [rm], al
  1402                                  
  1403                                  ;-78             else getIndReg1();
  1404                                  
  1405 00002220 E90300                   jmp @@getMEM28
  1406                                  @@getMEM27:
  1407 00002223 E88900                   call getIndReg1
  1408                                  
  1409                                  ;-79         }
  1410                                  
  1411                                  @@getMEM28:
  1412                                  
  1413                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1414                                  
  1415                                  @@getMEM26:
  1416 00002226 8A46FE                   mov al, [bp-2]
  1417 00002229 3C03                     cmp al, 3
  1418 0000222B 0F851000                 jne @@getMEM29
  1419 0000222F A1[BE01]                 mov ax, [disp]
  1420 00002232 8B1E[8006]               mov bx, [LabelIx]
  1421 00002236 D1E3                     shl bx, 1
  1422 00002238 0387[B605]               add ax, [LabelAddr + bx]
  1423 0000223C A3[BE01]                 mov word [disp], ax
  1424                                  
  1425                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1426                                  
  1427                                  @@getMEM29:
  1428 0000223F 8A46FE                   mov al, [bp-2]
  1429 00002242 3C01                     cmp al, 1
  1430 00002244 0F850A00                 jne @@getMEM30
  1431 00002248 A1[BE01]                 mov ax, [disp]
  1432 0000224B 0306[4D00]               add ax, [SymbolInt]
  1433 0000224F A3[BE01]                 mov word [disp], ax
  1434                                  
  1435                                  ;-82         if (isToken('-')) {
  1436                                  
  1437                                  @@getMEM30:
  1438 00002252 6A2D                     push 45
  1439 00002254 E8CC07                   call isToken
  1440 00002257 83C402                   add  sp, 2
  1441 0000225A 08C0                     or  al, al
  1442 0000225C 0F841900                 je @@getMEM31
  1443                                  
  1444                                  ;-83             getTokeType();
  1445                                  
  1446 00002260 E85C03                   call getTokeType
  1447                                  
  1448                                  ;-84             if (TokeType != DIGIT) numbererror();
  1449                                  
  1450 00002263 A0[AD01]                 mov al, [TokeType]
  1451 00002266 3C01                     cmp al, 1
  1452 00002268 0F840300                 je  @@getMEM32
  1453 0000226C E83713                   call numbererror
  1454                                  
  1455                                  ;-85             disp = disp - SymbolInt;
  1456                                  
  1457                                  @@getMEM32:
  1458 0000226F A1[BE01]                 mov ax, [disp]
  1459 00002272 2B06[4D00]               sub ax, [SymbolInt]
  1460 00002276 A3[BE01]                 mov word [disp], ax
  1461                                  
  1462                                  ;-86         }
  1463                                  
  1464                                  
  1465                                  ;-87     } while (isToken('+'));
  1466                                  
  1467                                  @@getMEM31:
  1468 00002279 6A2B                     push 43
  1469 0000227B E8A507                   call isToken
  1470 0000227E 83C402                   add  sp, 2
  1471 00002281 08C0                     or  al, al
  1472 00002283 0F840300                 je @@getMEM33
  1473 00002287 E960FF                   jmp @@getMEM24
  1474                                  @@getMEM33:
  1475                                  
  1476                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1477                                  
  1478 0000228A 6A5D                     push 93
  1479 0000228C E89407                   call isToken
  1480 0000228F 83C402                   add  sp, 2
  1481 00002292 83F800                   cmp ax, 0
  1482 00002295 0F850900                 jne @@getMEM34
  1483 00002299 68[A422]                 push getMEM_0
  1484 0000229C E83A12                   call errorexit
  1485 0000229F 83C402                   add  sp, 2
  1486                                  
  1487                                  ;-89 }
  1488                                  
  1489                                  @@getMEM34:
  1490                                  
  1491                                  ;-90 int getIndReg1() {
  1492 000022A2 C9                       LEAVE
  1493 000022A3 C3                       ret
  1494                                  ; ENDP
  1495 000022A4 5D2065787065637465-     getMEM_0 db "] expected",0
  1496 000022AD 6400               
  1497                                  
  1498                                  getIndReg1:  ; *** PROC ***
  1499                                  
  1500                                  ;-91     if (R2Type !=WORD) indexerror();
  1501                                  
  1502 000022AF A0[B601]                 mov al, [R2Type]
  1503 000022B2 3C02                     cmp al, 2
  1504 000022B4 0F840300                 je  @@getIndReg135
  1505 000022B8 E8A912                   call indexerror
  1506                                  
  1507                                  ;-92     if (R2No==3) rm=7;//BX
  1508                                  
  1509                                  @@getIndReg135:
  1510 000022BB A0[B401]                 mov al, [R2No]
  1511 000022BE 3C03                     cmp al, 3
  1512 000022C0 0F850900                 jne @@getIndReg136
  1513 000022C4 66B807000000             mov eax, 7
  1514 000022CA A2[BC01]                 mov byte [rm], al
  1515                                  
  1516                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1517                                  
  1518                                  @@getIndReg136:
  1519 000022CD A0[B401]                 mov al, [R2No]
  1520 000022D0 3C05                     cmp al, 5
  1521 000022D2 0F850900                 jne @@getIndReg137
  1522 000022D6 66B806000000             mov eax, 6
  1523 000022DC A2[BC01]                 mov byte [rm], al
  1524                                  
  1525                                  ;-94     if (R2No==7) rm=5;//DI
  1526                                  
  1527                                  @@getIndReg137:
  1528 000022DF A0[B401]                 mov al, [R2No]
  1529 000022E2 3C07                     cmp al, 7
  1530 000022E4 0F850900                 jne @@getIndReg138
  1531 000022E8 66B805000000             mov eax, 5
  1532 000022EE A2[BC01]                 mov byte [rm], al
  1533                                  
  1534                                  ;-95     if (R2No==6) rm=4;//SI
  1535                                  
  1536                                  @@getIndReg138:
  1537 000022F1 A0[B401]                 mov al, [R2No]
  1538 000022F4 3C06                     cmp al, 6
  1539 000022F6 0F850900                 jne @@getIndReg139
  1540 000022FA 66B804000000             mov eax, 4
  1541 00002300 A2[BC01]                 mov byte [rm], al
  1542                                  
  1543                                  ;-96     if (rm==0) indexerror();
  1544                                  
  1545                                  @@getIndReg139:
  1546 00002303 A0[BC01]                 mov al, [rm]
  1547 00002306 3C00                     cmp al, 0
  1548 00002308 0F850300                 jne @@getIndReg140
  1549 0000230C E85512                   call indexerror
  1550                                  
  1551                                  ;-97 }
  1552                                  
  1553                                  @@getIndReg140:
  1554                                  
  1555                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1556                                  
  1557 0000230F C3                       ret
  1558                                  ; ENDP
  1559                                  
  1560                                  getIndReg2:  ; *** PROC ***
  1561                                  ;Function : getIndReg2, Number of local variables: 1
  1562                                  ;   # type sign width line used address name   list of local variables
  1563                                  ;  200 var sign byte    98 NULL bp-2    m;
  1564 00002310 C8020000                 ENTER  2,0
  1565 00002314 66B804000000             mov eax, 4
  1566 0000231A 8846FE                   mov byte [bp-2], al
  1567                                  
  1568                                  ;-99     if (R2Type !=WORD) indexerror();
  1569                                  
  1570 0000231D A0[B601]                 mov al, [R2Type]
  1571 00002320 3C02                     cmp al, 2
  1572 00002322 0F840300                 je  @@getIndReg241
  1573 00002326 E83B12                   call indexerror
  1574                                  
  1575                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1576                                  
  1577                                  @@getIndReg241:
  1578 00002329 A0[B401]                 mov al, [R2No]
  1579 0000232C 3C07                     cmp al, 7
  1580 0000232E 0F852700                 jne @@getIndReg242
  1581 00002332 A0[BC01]                 mov al, [rm]
  1582 00002335 3C06                     cmp al, 6
  1583 00002337 0F850C00                 jne @@getIndReg243
  1584 0000233B 66B803000000             mov eax, 3
  1585 00002341 8846FE                   mov byte [bp-2], al
  1586                                  
  1587                                  ;-101              else if (rm==7) m=1;//BX+DI
  1588                                  
  1589 00002344 E91200                   jmp @@getIndReg244
  1590                                  @@getIndReg243:
  1591 00002347 A0[BC01]                 mov al, [rm]
  1592 0000234A 3C07                     cmp al, 7
  1593 0000234C 0F850900                 jne @@getIndReg245
  1594 00002350 66B801000000             mov eax, 1
  1595 00002356 8846FE                   mov byte [bp-2], al
  1596                                  
  1597                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1598                                  
  1599                                  @@getIndReg245:
  1600                                  @@getIndReg244:
  1601                                  @@getIndReg242:
  1602 00002359 A0[B401]                 mov al, [R2No]
  1603 0000235C 3C06                     cmp al, 6
  1604 0000235E 0F852700                 jne @@getIndReg246
  1605 00002362 A0[BC01]                 mov al, [rm]
  1606 00002365 3C06                     cmp al, 6
  1607 00002367 0F850C00                 jne @@getIndReg247
  1608 0000236B 66B802000000             mov eax, 2
  1609 00002371 8846FE                   mov byte [bp-2], al
  1610                                  
  1611                                  ;-103              else if (rm==7) m=0;//BX+SI
  1612                                  
  1613 00002374 E91200                   jmp @@getIndReg248
  1614                                  @@getIndReg247:
  1615 00002377 A0[BC01]                 mov al, [rm]
  1616 0000237A 3C07                     cmp al, 7
  1617 0000237C 0F850900                 jne @@getIndReg249
  1618 00002380 66B800000000             mov eax, 0
  1619 00002386 8846FE                   mov byte [bp-2], al
  1620                                  
  1621                                  ;-104     if (m > 3) indexerror();
  1622                                  
  1623                                  @@getIndReg249:
  1624                                  @@getIndReg248:
  1625                                  @@getIndReg246:
  1626 00002389 8A46FE                   mov al, [bp-2]
  1627 0000238C 3C03                     cmp al, 3
  1628 0000238E 0F8E0300                 jle @@getIndReg250
  1629 00002392 E8CF11                   call indexerror
  1630                                  
  1631                                  ;-105     return m;
  1632                                  
  1633                                  @@getIndReg250:
  1634 00002395 8A46FE                   mov al, [bp-2]
  1635 00002398 E90000                   jmp @@retn
  1636                                  
  1637                                  ;-106 }
  1638                                  
  1639                                  
  1640                                  ;-107                   
  1641                                  
  1642                                  
  1643                                  ;-108 int setwflag() {//word size, bit 0
  1644                                  
  1645 0000239B C9                      @@retn: LEAVE
  1646 0000239C C3                       ret
  1647                                  ; ENDP
  1648                                  
  1649                                  setwflag:  ; *** PROC ***
  1650                                  
  1651                                  ;-109     wflag=0;
  1652                                  
  1653 0000239D 66B800000000             mov eax, 0
  1654 000023A3 A2[B901]                 mov byte [wflag], al
  1655                                  
  1656                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1657                                  
  1658 000023A6 A0[B801]                 mov al, [OpSize]
  1659 000023A9 3C00                     cmp al, 0
  1660 000023AB 0F854200                 jne @@setwflag51
  1661                                  
  1662                                  ;-111         if (Op == REG) OpSize=R1Type;
  1663                                  
  1664 000023AF A0[AE01]                 mov al, [Op]
  1665 000023B2 3C02                     cmp al, 2
  1666 000023B4 0F850600                 jne @@setwflag52
  1667 000023B8 A0[B701]                 mov al, [R1Type]
  1668 000023BB A2[B801]                 mov byte [OpSize], al
  1669                                  
  1670                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1671                                  
  1672                                  @@setwflag52:
  1673 000023BE A0[AF01]                 mov al, [Op2]
  1674 000023C1 3C02                     cmp al, 2
  1675 000023C3 0F850600                 jne @@setwflag53
  1676 000023C7 A0[B601]                 mov al, [R2Type]
  1677 000023CA A2[B801]                 mov byte [OpSize], al
  1678                                  
  1679                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1680                                  
  1681                                  @@setwflag53:
  1682 000023CD A0[B601]                 mov al, [R2Type]
  1683 000023D0 3C04                     cmp al, 4
  1684 000023D2 0F850900                 jne @@setwflag54
  1685 000023D6 66B802000000             mov eax, 2
  1686 000023DC A2[B801]                 mov byte [OpSize], al
  1687                                  
  1688                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1689                                  
  1690                                  @@setwflag54:
  1691 000023DF A0[B701]                 mov al, [R1Type]
  1692 000023E2 3C04                     cmp al, 4
  1693 000023E4 0F850900                 jne @@setwflag55
  1694 000023E8 66B802000000             mov eax, 2
  1695 000023EE A2[B801]                 mov byte [OpSize], al
  1696                                  
  1697                                  ;-115     }
  1698                                  
  1699                                  @@setwflag55:
  1700                                  
  1701                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1702                                  
  1703                                  @@setwflag51:
  1704 000023F1 A0[B801]                 mov al, [OpSize]
  1705 000023F4 3C03                     cmp al, 3
  1706 000023F6 0F850C00                 jne @@setwflag56
  1707 000023FA E81918                   call gen66h
  1708 000023FD 66B801000000             mov eax, 1
  1709 00002403 A2[B901]                 mov byte [wflag], al
  1710                                  
  1711                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1712                                  
  1713                                  @@setwflag56:
  1714 00002406 A0[B801]                 mov al, [OpSize]
  1715 00002409 3C02                     cmp al, 2
  1716 0000240B 0F850900                 jne @@setwflag57
  1717 0000240F 66B801000000             mov eax, 1
  1718 00002415 A2[B901]                 mov byte [wflag], al
  1719                                  
  1720                                  ;-118 }
  1721                                  
  1722                                  @@setwflag57:
  1723                                  
  1724                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1725                                  
  1726 00002418 C3                       ret
  1727                                  ; ENDP
  1728                                  
  1729                                  setsflag:  ; *** PROC ***
  1730                                  
  1731                                  ;-120     unsigned int ui;    
  1732                                  
  1733                                  
  1734                                  ;-121     sflag=2;   
  1735                                  
  1736                                  ;Function : setsflag, Number of local variables: 1
  1737                                  ;   # type sign width line used address name   list of local variables
  1738                                  ;  200 var unsg word   120 NULL bp-2    ui;
  1739 00002419 C8020000                 ENTER  2,0
  1740 0000241D 66B802000000             mov eax, 2
  1741 00002423 A2[BB01]                 mov byte [sflag], al
  1742                                  
  1743                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1744                                  
  1745 00002426 A1[C001]                 mov ax, [imme]
  1746 00002429 2580FF                   and ax, 65408
  1747 0000242C 8946FE                   mov word [bp-2], ax
  1748                                  
  1749                                  ;-123     if(ui != 0) sflag = 0;
  1750                                  
  1751 0000242F 8B46FE                   mov ax, [bp-2]
  1752 00002432 83F800                   cmp ax, 0
  1753 00002435 0F840900                 je  @@setsflag58
  1754 00002439 66B800000000             mov eax, 0
  1755 0000243F A2[BB01]                 mov byte [sflag], al
  1756                                  
  1757                                  ;-124     if (OpSize == BYTE) {
  1758                                  
  1759                                  @@setsflag58:
  1760 00002442 A0[B801]                 mov al, [OpSize]
  1761 00002445 3C01                     cmp al, 1
  1762 00002447 0F851C00                 jne @@setsflag59
  1763                                  
  1764                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1765                                  
  1766 0000244B A1[C001]                 mov ax, [imme]
  1767 0000244E 3DFF00                   cmp ax, 255
  1768 00002451 0F8E0900                 jle @@setsflag60
  1769 00002455 68[6924]                 push setsflag_0
  1770 00002458 E81F10                   call error1
  1771 0000245B 83C402                   add  sp, 2
  1772                                  
  1773                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1774                                  
  1775                                  @@setsflag60:
  1776 0000245E 66B800000000             mov eax, 0
  1777 00002464 A2[BB01]                 mov byte [sflag], al
  1778                                  
  1779                                  ;-127     }
  1780                                  
  1781                                  
  1782                                  ;-128 }
  1783                                  
  1784                                  @@setsflag59:
  1785                                  
  1786                                  ;-129 int checkConstSize(unsigned int ui) {    
  1787 00002467 C9                       LEAVE
  1788 00002468 C3                       ret
  1789                                  ; ENDP
  1790 00002469 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1791 00002472 6F7220627974652072-
  1792 0000247B 2F6D00             
  1793                                  
  1794                                  checkConstSize:  ; *** PROC ***
  1795                                  
  1796                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1797                                  
  1798                                  ;Function : checkConstSize, Number of local variables: 1
  1799                                  ;   # type sign width line used address name   list of local variables
  1800                                  ;  200 var unsg word   129 NULL bp+4    ui;
  1801 0000247E C8000000                 ENTER  0,0
  1802 00002482 8B4604                   mov ax, [bp+4]
  1803 00002485 83F87F                   cmp ax, 127
  1804 00002488 0F8E0900                 jle @@checkConstSize61
  1805 0000248C 66B800000000             mov eax, 0
  1806 00002492 E91C00                   jmp @@retn
  1807                                  
  1808                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1809                                  
  1810                                  @@checkConstSize61:
  1811 00002495 8B4604                   mov ax, [bp+4]
  1812 00002498 3D80FF                   cmp ax, 65408
  1813 0000249B 0F8D0900                 jge @@checkConstSize62
  1814 0000249F 66B800000000             mov eax, 0
  1815 000024A5 E90900                   jmp @@retn
  1816                                  
  1817                                  ;-132     return 2;// is short        
  1818                                  
  1819                                  @@checkConstSize62:
  1820 000024A8 66B802000000             mov eax, 2
  1821 000024AE E90000                   jmp @@retn
  1822                                  
  1823                                  ;-133 }
  1824                                  
  1825 000024B1 C9                      @@retn: LEAVE
  1826 000024B2 C3                       ret
  1827                                  ; ENDP
  1828                                  ;Back to main program: AS.C
  1829                                  
  1830                                  ;-5 #include "PARSE.C"
  1831                                  
  1832                                  ;Use include file: PARSE.C
  1833                                  
  1834                                  ;-1 int parse() {
  1835                                  
  1836                                  
  1837                                  parse:  ; *** PROC ***
  1838                                  
  1839                                  ;-2     LabelNamePtr  = &LabelNames;    
  1840                                  
  1841 000024B3 B8[CC01]                 mov ax, LabelNames
  1842 000024B6 A3[B405]                 mov word [LabelNamePtr], ax
  1843                                  
  1844                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1845                                  
  1846 000024B9 B8[8206]                 mov ax, JmpCallNames
  1847 000024BC A3[520E]                 mov word [JmpCallNamePtr], ax
  1848                                  
  1849                                  ;-4     LabelMaxIx=0;    
  1850                                  
  1851 000024BF 66B800000000             mov eax, 0
  1852 000024C5 A3[7E06]                 mov word [LabelMaxIx], ax
  1853                                  
  1854                                  ;-5     JmpCallMaxIx=0;  
  1855                                  
  1856 000024C8 66B800000000             mov eax, 0
  1857 000024CE A3[3014]                 mov word [JmpCallMaxIx], ax
  1858                                  
  1859                                  ;-6     BinLen=0;
  1860                                  
  1861 000024D1 66B800000000             mov eax, 0
  1862 000024D7 A3[021C]                 mov word [BinLen], ax
  1863                                  
  1864                                  ;-7     
  1865                                  
  1866                                  
  1867                                  ;-8     do {//process a new line
  1868                                  
  1869                                  @@parse63:
  1870                                  
  1871                                  ;-9         PCStart=PC; 
  1872                                  
  1873 000024DA A1[A601]                 mov ax, [PC]
  1874 000024DD A3[AA01]                 mov word [PCStart], ax
  1875                                  
  1876                                  ;-10         OpSize=0;
  1877                                  
  1878 000024E0 66B800000000             mov eax, 0
  1879 000024E6 A2[B801]                 mov byte [OpSize], al
  1880                                  
  1881                                  ;-11         OpPrintIndex=0; 
  1882                                  
  1883 000024E9 66B800000000             mov eax, 0
  1884 000024EF A3[C701]                 mov word [OpPrintIndex], ax
  1885                                  
  1886                                  ;-12         PrintRA=' ';
  1887                                  
  1888 000024F2 66B820000000             mov eax, 32
  1889 000024F8 A2[CB01]                 mov byte [PrintRA], al
  1890                                  
  1891                                  ;-13         getLine();
  1892                                  
  1893 000024FB E8BB05                   call getLine
  1894                                  
  1895                                  ;-14         InputPtr = &InputBuf;
  1896                                  
  1897 000024FE B8[4F00]                 mov ax, InputBuf
  1898 00002501 A3[CE00]                 mov word [InputPtr], ax
  1899                                  
  1900                                  ;-15         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1901                                  
  1902 00002504 E8B800                   call getTokeType
  1903                                  
  1904                                  ;-16         if (TokeType == ALNUME) {
  1905                                  
  1906 00002507 A0[AD01]                 mov al, [TokeType]
  1907 0000250A 3C03                     cmp al, 3
  1908 0000250C 0F851300                 jne @@parse64
  1909                                  
  1910                                  ;-17             if (isLabel) {//set in getName
  1911                                  
  1912 00002510 A0[AC01]                 mov al, [isLabel]
  1913 00002513 08C0                     or  al, al
  1914 00002515 0F840A00                 je @@parse65
  1915                                  
  1916                                  ;-18                 storeLabel();
  1917                                  
  1918 00002519 E8D101                   call storeLabel
  1919                                  
  1920                                  ;-19                 InputPtr++;//remove :
  1921                                  
  1922 0000251C FF06[CE00]               inc  word [InputPtr]
  1923                                  
  1924                                  ;-20                 getTokeType();
  1925                                  
  1926 00002520 E89C00                   call getTokeType
  1927                                  
  1928                                  ;-21             }
  1929                                  
  1930                                  
  1931                                  ;-22         }
  1932                                  
  1933                                  @@parse65:
  1934                                  
  1935                                  ;-23         if (TokeType == ALNUME) {
  1936                                  
  1937                                  @@parse64:
  1938 00002523 A0[AD01]                 mov al, [TokeType]
  1939 00002526 3C03                     cmp al, 3
  1940 00002528 0F851B00                 jne @@parse66
  1941                                  
  1942                                  ;-24             lookCode();// and OpCodePtr
  1943                                  
  1944 0000252C E8F703                   call lookCode
  1945                                  
  1946                                  ;-25             if(CodeType) process();
  1947                                  
  1948 0000252F A0[B001]                 mov al, [CodeType]
  1949 00002532 08C0                     or  al, al
  1950 00002534 0F840600                 je @@parse67
  1951 00002538 E8C918                   call process
  1952                                  
  1953                                  ;-26             else getVariable();
  1954                                  
  1955 0000253B E90300                   jmp @@parse68
  1956                                  @@parse67:
  1957 0000253E E8AD02                   call getVariable
  1958                                  
  1959                                  ;-27             skipRest();
  1960                                  
  1961                                  @@parse68:
  1962 00002541 E84C05                   call skipRest
  1963                                  
  1964                                  ;-28         }
  1965                                  
  1966                                  
  1967                                  ;-29         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1968                                  
  1969 00002544 E92700                   jmp @@parse69
  1970                                  @@parse66:
  1971 00002547 A0[AD01]                 mov al, [TokeType]
  1972 0000254A 3C03                     cmp al, 3
  1973 0000254C 0F8E0C00                 jle @@parse70
  1974 00002550 68[7F25]                 push parse_0
  1975 00002553 E8240F                   call error1
  1976 00002556 83C402                   add  sp, 2
  1977                                  
  1978                                  ;-30         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1979                                  
  1980 00002559 E91200                   jmp @@parse71
  1981                                  @@parse70:
  1982 0000255C A0[AD01]                 mov al, [TokeType]
  1983 0000255F 3C01                     cmp al, 1
  1984 00002561 0F850900                 jne @@parse72
  1985 00002565 68[9D25]                 push parse_1
  1986 00002568 E80F0F                   call error1
  1987 0000256B 83C402                   add  sp, 2
  1988                                  
  1989                                  ;-31         printLine();
  1990                                  
  1991                                  @@parse72:
  1992                                  @@parse71:
  1993                                  @@parse69:
  1994 0000256E E89B0C                   call printLine
  1995                                  
  1996                                  ;-32     } while (DOS_NoBytes != 0 );
  1997                                  
  1998 00002571 A1[A301]                 mov ax, [DOS_NoBytes]
  1999 00002574 83F800                   cmp ax, 0
  2000 00002577 0F840300                 je  @@parse73
  2001 0000257B E95CFF                   jmp @@parse63
  2002                                  @@parse73:
  2003                                  
  2004                                  ;-33 }
  2005                                  
  2006                                  
  2007                                  ;-34 
  2008                                  
  2009                                  
  2010                                  ;-35 int getTokeType() { 
  2011                                  
  2012 0000257E C3                       ret
  2013                                  ; ENDP
  2014 0000257F 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2015 00002588 696E73747275637469-
  2016 00002591 6F6E20657870656374-
  2017 0000259A 656400             
  2018 0000259D 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2019 000025A6 616C6C6F7765642061-
  2020 000025AF 74207374617274206F-
  2021 000025B8 66206C696E6500     
  2022                                  
  2023                                  getTokeType:  ; *** PROC ***
  2024                                  
  2025                                  ;-36     char c;
  2026                                  
  2027                                  
  2028                                  ;-37     skipBlank();
  2029                                  
  2030                                  ;Function : getTokeType, Number of local variables: 1
  2031                                  ;   # type sign width line used address name   list of local variables
  2032                                  ;  200 var sign byte    36 NULL bp-2    c;
  2033 000025BF C8020000                 ENTER  2,0
  2034 000025C3 E8F505                   call skipBlank
  2035                                  
  2036                                  ;-38     c = *InputPtr;
  2037                                  
  2038 000025C6 8B1E[CE00]               mov bx, [InputPtr]
  2039 000025CA 8A07                     mov al, [bx]
  2040 000025CC B400                     mov ah, 0
  2041 000025CE 8846FE                   mov byte [bp-2], al
  2042                                  
  2043                                  ;-39     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2044                                  
  2045 000025D1 8A46FE                   mov al, [bp-2]
  2046 000025D4 3C00                     cmp al, 0
  2047 000025D6 0F850C00                 jne @@getTokeType74
  2048 000025DA 66B800000000             mov eax, 0
  2049 000025E0 A2[AD01]                 mov byte [TokeType], al
  2050 000025E3 E97200                   jmp @@retn
  2051                                  
  2052                                  ;-40     if (c == ';') {TokeType=0; return; }//comment
  2053                                  
  2054                                  @@getTokeType74:
  2055 000025E6 8A46FE                   mov al, [bp-2]
  2056 000025E9 3C3B                     cmp al, 59
  2057 000025EB 0F850C00                 jne @@getTokeType75
  2058 000025EF 66B800000000             mov eax, 0
  2059 000025F5 A2[AD01]                 mov byte [TokeType], al
  2060 000025F8 E95D00                   jmp @@retn
  2061                                  
  2062                                  ;-41     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2063                                  
  2064                                  @@getTokeType75:
  2065 000025FB 8A46FE                   mov al, byte [bp-2]
  2066 000025FE B400                     mov ah, 0
  2067 00002600 50                       push ax
  2068 00002601 E88F1F                   call digit
  2069 00002604 83C402                   add  sp, 2
  2070 00002607 08C0                     or  al, al
  2071 00002609 0F841800                 je @@getTokeType76
  2072 0000260D 8A46FE                   mov al, byte [bp-2]
  2073 00002610 B400                     mov ah, 0
  2074 00002612 50                       push ax
  2075 00002613 E8AB06                   call getDigit
  2076 00002616 83C402                   add  sp, 2
  2077 00002619 66B801000000             mov eax, 1
  2078 0000261F A2[AD01]                 mov byte [TokeType], al
  2079 00002622 E93300                   jmp @@retn
  2080                                  
  2081                                  ;-42     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2082                                  
  2083                                  @@getTokeType76:
  2084 00002625 8A46FE                   mov al, byte [bp-2]
  2085 00002628 B400                     mov ah, 0
  2086 0000262A 50                       push ax
  2087 0000262B E8B805                   call letterE
  2088 0000262E 83C402                   add  sp, 2
  2089 00002631 08C0                     or  al, al
  2090 00002633 0F841800                 je @@getTokeType77
  2091 00002637 8A46FE                   mov al, byte [bp-2]
  2092 0000263A B400                     mov ah, 0
  2093 0000263C 50                       push ax
  2094 0000263D E8D806                   call getName
  2095 00002640 83C402                   add  sp, 2
  2096 00002643 66B803000000             mov eax, 3
  2097 00002649 A2[AD01]                 mov byte [TokeType], al
  2098 0000264C E90900                   jmp @@retn
  2099                                  
  2100                                  ;-43     TokeType=NOALNUME;
  2101                                  
  2102                                  @@getTokeType77:
  2103 0000264F 66B804000000             mov eax, 4
  2104 00002655 A2[AD01]                 mov byte [TokeType], al
  2105                                  
  2106                                  ;-44 }                     
  2107                                  
  2108                                  
  2109                                  ;-45 
  2110                                  
  2111                                  
  2112                                  ;-46 int storeJmpCall() {
  2113                                  
  2114 00002658 C9                      @@retn: LEAVE
  2115 00002659 C3                       ret
  2116                                  ; ENDP
  2117                                  
  2118                                  storeJmpCall:  ; *** PROC ***
  2119                                  
  2120                                  ;-47     unsigned int i;
  2121                                  
  2122                                  
  2123                                  ;-48     JmpCallMaxIx++;
  2124                                  
  2125                                  ;Function : storeJmpCall, Number of local variables: 1
  2126                                  ;   # type sign width line used address name   list of local variables
  2127                                  ;  200 var unsg word    47 NULL bp-2    i;
  2128 0000265A C8020000                 ENTER  2,0
  2129 0000265E FF06[3014]               inc  word [JmpCallMaxIx]
  2130                                  
  2131                                  ;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2132                                  
  2133 00002662 A1[3014]                 mov ax, [JmpCallMaxIx]
  2134 00002665 3DF401                   cmp ax, 500 ;unsigned : 1
  2135 00002668 0F8C0900                 jl  @@storeJmpCall78
  2136 0000266C 68[C426]                 push storeJmpCall_0
  2137 0000266F E8670E                   call errorexit
  2138 00002672 83C402                   add  sp, 2
  2139                                  
  2140                                  ;-50     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2141                                  
  2142                                  @@storeJmpCall78:
  2143 00002675 8D06[0F00]               lea  ax, [Symbol]
  2144 00002679 50                       push ax
  2145 0000267A FF36[520E]               push word [JmpCallNamePtr]
  2146 0000267E E8D91E                   call strcpy
  2147 00002681 83C404                   add  sp, 4
  2148 00002684 A3[520E]                 mov word [JmpCallNamePtr], ax
  2149                                  
  2150                                  ;-51     JmpCallNamePtr++;
  2151                                  
  2152 00002687 FF06[520E]               inc  word [JmpCallNamePtr]
  2153                                  
  2154                                  ;-52     i = JmpCallNamePtr - &JmpCallNames;    
  2155                                  
  2156 0000268B A1[520E]                 mov ax, [JmpCallNamePtr]
  2157 0000268E 2D[8206]                 sub ax, JmpCallNames
  2158 00002691 8946FE                   mov word [bp-2], ax
  2159                                  
  2160                                  ;-53     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2161                                  
  2162 00002694 8B46FE                   mov ax, [bp-2]
  2163 00002697 3DB107                   cmp ax, 1969 ;unsigned : 0
  2164 0000269A 0F820900                 jb  @@storeJmpCall79
  2165 0000269E 68[D626]                 push storeJmpCall_1
  2166 000026A1 E8350E                   call errorexit
  2167 000026A4 83C402                   add  sp, 2
  2168                                  
  2169                                  ;-54     JmpCallAddr[JmpCallMaxIx] = PC;   
  2170                                  
  2171                                  @@storeJmpCall79:
  2172 000026A7 A1[A601]                 mov ax, [PC]
  2173 000026AA 8B1E[3014]               mov bx, [JmpCallMaxIx]
  2174 000026AE D1E3                     shl bx, 1
  2175 000026B0 8987[540E]               mov [JmpCallAddr+bx], ax
  2176                                  
  2177                                  ;-55     JmpCallRelAbs[JmpCallMaxIx] = '*';
  2178                                  
  2179 000026B4 66B82A000000             mov eax, 42
  2180 000026BA 8B1E[3014]               mov bx, [JmpCallMaxIx]
  2181 000026BE 8887[3C12]               mov [JmpCallRelAbs+bx], al
  2182                                  
  2183                                  ;-56     //set correct value r,R,A in CodeType 6+7             
  2184                                  
  2185                                  
  2186                                  ;-57 }
  2187                                  
  2188                                  
  2189                                  ;-58 
  2190                                  
  2191                                  
  2192                                  ;-59 int storeLabel() {
  2193 000026C2 C9                       LEAVE
  2194 000026C3 C3                       ret
  2195                                  ; ENDP
  2196 000026C4 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2197 000026CD 4A6D7043616C6C7300 
  2198 000026D6 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2199 000026DF 4A6D7043616C6C206E-
  2200 000026E8 616D657300         
  2201                                  
  2202                                  storeLabel:  ; *** PROC ***
  2203                                  
  2204                                  ;-60     unsigned int i;
  2205                                  
  2206                                  
  2207                                  ;-61     LabelMaxIx++;
  2208                                  
  2209                                  ;Function : storeLabel, Number of local variables: 1
  2210                                  ;   # type sign width line used address name   list of local variables
  2211                                  ;  200 var unsg word    60 NULL bp-2    i;
  2212 000026ED C8020000                 ENTER  2,0
  2213 000026F1 FF06[7E06]               inc  word [LabelMaxIx]
  2214                                  
  2215                                  ;-62     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2216                                  
  2217 000026F5 A1[7E06]                 mov ax, [LabelMaxIx]
  2218 000026F8 83F864                   cmp ax, 100 ;unsigned : 1
  2219 000026FB 0F8C0900                 jl  @@storeLabel80
  2220 000026FF 68[5F27]                 push storeLabel_0
  2221 00002702 E8D40D                   call errorexit
  2222 00002705 83C402                   add  sp, 2
  2223                                  
  2224                                  ;-63     if(searchLabel()) error1("duplicate label");
  2225                                  
  2226                                  @@storeLabel80:
  2227 00002708 E88900                   call searchLabel
  2228 0000270B 08C0                     or  al, al
  2229 0000270D 0F840900                 je @@storeLabel81
  2230 00002711 68[6F27]                 push storeLabel_1
  2231 00002714 E8630D                   call error1
  2232 00002717 83C402                   add  sp, 2
  2233                                  
  2234                                  ;-64     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2235                                  
  2236                                  @@storeLabel81:
  2237 0000271A 8D06[0F00]               lea  ax, [Symbol]
  2238 0000271E 50                       push ax
  2239 0000271F FF36[B405]               push word [LabelNamePtr]
  2240 00002723 E8341E                   call strcpy
  2241 00002726 83C404                   add  sp, 4
  2242 00002729 A3[B405]                 mov word [LabelNamePtr], ax
  2243                                  
  2244                                  ;-65     LabelNamePtr++;
  2245                                  
  2246 0000272C FF06[B405]               inc  word [LabelNamePtr]
  2247                                  
  2248                                  ;-66     i = LabelNamePtr - &LabelNames;
  2249                                  
  2250 00002730 A1[B405]                 mov ax, [LabelNamePtr]
  2251 00002733 2D[CC01]                 sub ax, LabelNames
  2252 00002736 8946FE                   mov word [bp-2], ax
  2253                                  
  2254                                  ;-67     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2255                                  
  2256 00002739 8B46FE                   mov ax, [bp-2]
  2257 0000273C 3DC903                   cmp ax, 969 ;unsigned : 0
  2258 0000273F 0F820900                 jb  @@storeLabel82
  2259 00002743 68[7F27]                 push storeLabel_2
  2260 00002746 E8900D                   call errorexit
  2261 00002749 83C402                   add  sp, 2
  2262                                  
  2263                                  ;-68     LabelAddr[LabelMaxIx] = PC + Origin;
  2264                                  
  2265                                  @@storeLabel82:
  2266 0000274C A1[A601]                 mov ax, [PC]
  2267 0000274F 0306[A801]               add ax, [Origin]
  2268 00002753 8B1E[7E06]               mov bx, [LabelMaxIx]
  2269 00002757 D1E3                     shl bx, 1
  2270 00002759 8987[B605]               mov [LabelAddr+bx], ax
  2271                                  
  2272                                  ;-69 }   
  2273                                  
  2274                                  
  2275                                  ;-70 
  2276                                  
  2277                                  
  2278                                  ;-71 int searchLabel() {
  2279 0000275D C9                       LEAVE
  2280 0000275E C3                       ret
  2281                                  ; ENDP
  2282 0000275F 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2283 00002768 6C6162656C7300     
  2284 0000276F 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2285 00002778 206C6162656C00     
  2286 0000277F 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2287 00002788 6C6162656C206E616D-
  2288 00002791 657300             
  2289                                  
  2290                                  searchLabel:  ; *** PROC ***
  2291                                  
  2292                                  ;-72     int LIx; char *p;
  2293                                  
  2294                                  
  2295                                  ;-73     p = &LabelNames;
  2296                                  
  2297                                  ;Function : searchLabel, Number of local variables: 2
  2298                                  ;   # type sign width line used address name   list of local variables
  2299                                  ;  200 var sign word    72 NULL bp-2    LIx
  2300                                  ;  201 ptr sign byte    72 NULL bp-4    p;
  2301 00002794 C8040000                 ENTER  4,0
  2302 00002798 B8[CC01]                 mov ax, LabelNames
  2303 0000279B 8946FC                   mov word [bp-4], ax
  2304                                  
  2305                                  ;-74     LIx = 1;
  2306                                  
  2307 0000279E 66B801000000             mov eax, 1
  2308 000027A4 8946FE                   mov word [bp-2], ax
  2309                                  
  2310                                  ;-75     while (LIx <= LabelMaxIx) {
  2311                                  
  2312                                  @@searchLabel83:
  2313 000027A7 8B46FE                   mov ax, [bp-2]
  2314 000027AA 3B06[7E06]               cmp ax, [LabelMaxIx]
  2315 000027AE 0F8F3100                 jg  @@searchLabel84
  2316                                  
  2317                                  ;-76         if (eqstr(p, Symbol)) return LIx;//pos of label                    
  2318                                  
  2319 000027B2 8D06[0F00]               lea  ax, [Symbol]
  2320 000027B6 50                       push ax
  2321 000027B7 FF76FC                   push word [bp-4]
  2322 000027BA E8091E                   call eqstr
  2323 000027BD 83C404                   add  sp, 4
  2324 000027C0 08C0                     or  al, al
  2325 000027C2 0F840600                 je @@searchLabel85
  2326 000027C6 8B46FE                   mov ax, [bp-2]
  2327 000027C9 E92000                   jmp @@retn
  2328                                  
  2329                                  ;-77         p=strlen(p) + p;                  
  2330                                  
  2331                                  @@searchLabel85:
  2332 000027CC FF76FC                   push word [bp-4]
  2333 000027CF E85D1D                   call strlen
  2334 000027D2 83C402                   add  sp, 2
  2335 000027D5 0346FC                   add ax, [bp-4]
  2336 000027D8 8946FC                   mov word [bp-4], ax
  2337                                  
  2338                                  ;-78         p++; 
  2339                                  
  2340 000027DB FF46FC                   inc  word [bp-4]
  2341                                  
  2342                                  ;-79         LIx++;
  2343                                  
  2344 000027DE FF46FE                   inc  word [bp-2]
  2345                                  
  2346                                  ;-80     }
  2347                                  
  2348                                  
  2349                                  ;-81     return 0;
  2350                                  
  2351 000027E1 EBC4                     jmp @@searchLabel83
  2352                                  @@searchLabel84:
  2353 000027E3 66B800000000             mov eax, 0
  2354 000027E9 E90000                   jmp @@retn
  2355                                  
  2356                                  ;-82 }   
  2357                                  
  2358                                  
  2359                                  ;-83 
  2360                                  
  2361                                  
  2362                                  ;-84 int getVariable() { 
  2363                                  
  2364 000027EC C9                      @@retn: LEAVE
  2365 000027ED C3                       ret
  2366                                  ; ENDP
  2367                                  
  2368                                  getVariable:  ; *** PROC ***
  2369                                  
  2370                                  ;-85     char c;
  2371                                  
  2372                                  
  2373                                  ;-86     storeLabel();
  2374                                  
  2375                                  ;Function : getVariable, Number of local variables: 1
  2376                                  ;   # type sign width line used address name   list of local variables
  2377                                  ;  200 var sign byte    85 NULL bp-2    c;
  2378 000027EE C8020000                 ENTER  2,0
  2379 000027F2 E8F8FE                   call storeLabel
  2380                                  
  2381                                  ;-87     getTokeType(); 
  2382                                  
  2383 000027F5 E8C7FD                   call getTokeType
  2384                                  
  2385                                  ;-88     if(TokeType==ALNUME) {// getName
  2386                                  
  2387 000027F8 A0[AD01]                 mov al, [TokeType]
  2388 000027FB 3C03                     cmp al, 3
  2389 000027FD 0F85CC00                 jne @@getVariable86
  2390                                  
  2391                                  ;-89         lookCode();
  2392                                  
  2393 00002801 E82201                   call lookCode
  2394                                  
  2395                                  ;-90         if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2396                                  
  2397 00002804 A0[B001]                 mov al, [CodeType]
  2398 00002807 3CC8                     cmp al, 200
  2399 00002809 0F8D0900                 jge @@getVariable87
  2400 0000280D 68[D828]                 push getVariable_0
  2401 00002810 E8C60C                   call errorexit
  2402 00002813 83C402                   add  sp, 2
  2403                                  
  2404                                  ;-91         if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2405                                  
  2406                                  @@getVariable87:
  2407 00002816 A0[B001]                 mov al, [CodeType]
  2408 00002819 3CCF                     cmp al, 207
  2409 0000281B 0F8E0900                 jle @@getVariable88
  2410 0000281F 68[F028]                 push getVariable_1
  2411 00002822 E8B40C                   call errorexit
  2412 00002825 83C402                   add  sp, 2
  2413                                  
  2414                                  ;-92         if (CodeType== 200) {// DB
  2415                                  
  2416                                  @@getVariable88:
  2417 00002828 A0[B001]                 mov al, [CodeType]
  2418 0000282B 3CC8                     cmp al, 200
  2419 0000282D 0F856A00                 jne @@getVariable89
  2420                                  
  2421                                  ;-93             do { 
  2422                                  
  2423                                  @@getVariable90:
  2424                                  
  2425                                  ;-94                 getTokeType();
  2426                                  
  2427 00002831 E88BFD                   call getTokeType
  2428                                  
  2429                                  ;-95                 if (TokeType ==DIGIT) genCode8(SymbolInt);
  2430                                  
  2431 00002834 A0[AD01]                 mov al, [TokeType]
  2432 00002837 3C01                     cmp al, 1
  2433 00002839 0F850D00                 jne @@getVariable91
  2434 0000283D FF36[4D00]               push word [SymbolInt]
  2435 00002841 E81214                   call genCode8
  2436 00002844 83C402                   add  sp, 2
  2437                                  
  2438                                  ;-96                 else {
  2439                                  
  2440 00002847 E94100                   jmp @@getVariable92
  2441                                  @@getVariable91:
  2442                                  
  2443                                  ;-97                     skipBlank();
  2444                                  
  2445 0000284A E86E03                   call skipBlank
  2446                                  
  2447                                  ;-98                     if (isToken('"')) {
  2448                                  
  2449 0000284D 6A22                     push 34
  2450 0000284F E8D101                   call isToken
  2451 00002852 83C402                   add  sp, 2
  2452 00002855 08C0                     or  al, al
  2453 00002857 0F843000                 je @@getVariable93
  2454                                  
  2455                                  ;-99                         do { 
  2456                                  
  2457                                  @@getVariable94:
  2458                                  
  2459                                  ;-100                             c= *InputPtr;
  2460                                  
  2461 0000285B 8B1E[CE00]               mov bx, [InputPtr]
  2462 0000285F 8A07                     mov al, [bx]
  2463 00002861 B400                     mov ah, 0
  2464 00002863 8846FE                   mov byte [bp-2], al
  2465                                  
  2466                                  ;-101                             genCode8(c);
  2467                                  
  2468 00002866 8A46FE                   mov al, byte [bp-2]
  2469 00002869 B400                     mov ah, 0
  2470 0000286B 50                       push ax
  2471 0000286C E8E713                   call genCode8
  2472 0000286F 83C402                   add  sp, 2
  2473                                  
  2474                                  ;-102                             InputPtr++;
  2475                                  
  2476 00002872 FF06[CE00]               inc  word [InputPtr]
  2477                                  
  2478                                  ;-103                         } while (*InputPtr != '"' );
  2479                                  
  2480 00002876 8B1E[CE00]               mov bx, [InputPtr]
  2481 0000287A 8A07                     mov al, [bx]
  2482 0000287C B400                     mov ah, 0
  2483 0000287E 83F822                   cmp ax, 34
  2484 00002881 0F840200                 je  @@getVariable95
  2485 00002885 EBD4                     jmp @@getVariable94
  2486                                  @@getVariable95:
  2487                                  
  2488                                  ;-104                         InputPtr++;
  2489                                  
  2490 00002887 FF06[CE00]               inc  word [InputPtr]
  2491                                  
  2492                                  ;-105                     }
  2493                                  
  2494                                  
  2495                                  ;-106                 }
  2496                                  
  2497                                  @@getVariable93:
  2498                                  
  2499                                  ;-107             } while (isToken(','));
  2500                                  
  2501                                  @@getVariable92:
  2502 0000288B 6A2C                     push 44
  2503 0000288D E89301                   call isToken
  2504 00002890 83C402                   add  sp, 2
  2505 00002893 08C0                     or  al, al
  2506 00002895 0F840200                 je @@getVariable96
  2507 00002899 EB96                     jmp @@getVariable90
  2508                                  @@getVariable96:
  2509                                  
  2510                                  ;-108         }
  2511                                  
  2512                                  
  2513                                  ;-109         if (CodeType== 201) {// DW
  2514                                  
  2515                                  @@getVariable89:
  2516 0000289B A0[B001]                 mov al, [CodeType]
  2517 0000289E 3CC9                     cmp al, 201
  2518 000028A0 0F852600                 jne @@getVariable97
  2519                                  
  2520                                  ;-110             do { 
  2521                                  
  2522                                  @@getVariable98:
  2523                                  
  2524                                  ;-111                 getTokeType();
  2525                                  
  2526 000028A4 E818FD                   call getTokeType
  2527                                  
  2528                                  ;-112                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2529                                  
  2530 000028A7 A0[AD01]                 mov al, [TokeType]
  2531 000028AA 3C01                     cmp al, 1
  2532 000028AC 0F850A00                 jne @@getVariable99
  2533 000028B0 FF36[4D00]               push word [SymbolInt]
  2534 000028B4 E8F613                   call genCode16
  2535 000028B7 83C402                   add  sp, 2
  2536                                  
  2537                                  ;-113             } while (isToken(','));
  2538                                  
  2539                                  @@getVariable99:
  2540 000028BA 6A2C                     push 44
  2541 000028BC E86401                   call isToken
  2542 000028BF 83C402                   add  sp, 2
  2543 000028C2 08C0                     or  al, al
  2544 000028C4 0F840200                 je @@getVariable100
  2545 000028C8 EBDA                     jmp @@getVariable98
  2546                                  @@getVariable100:
  2547                                  
  2548                                  ;-114         }
  2549                                  
  2550                                  
  2551                                  ;-115     }
  2552                                  
  2553                                  @@getVariable97:
  2554                                  
  2555                                  ;-116     else errorexit("DB,DW,DD or RESB,W,D expected");
  2556                                  
  2557 000028CA E90900                   jmp @@getVariable101
  2558                                  @@getVariable86:
  2559 000028CD 68[0829]                 push getVariable_2
  2560 000028D0 E8060C                   call errorexit
  2561 000028D3 83C402                   add  sp, 2
  2562                                  
  2563                                  ;-117 }
  2564                                  
  2565                                  @@getVariable101:
  2566                                  
  2567                                  ;-118 
  2568                                  
  2569                                  
  2570                                  ;-119 int lookCode() {// ret: CodeType, *OpCodePtr
  2571 000028D6 C9                       LEAVE
  2572 000028D7 C3                       ret
  2573                                  ; ENDP
  2574 000028D8 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2575 000028E1 422C572C4420657870-
  2576 000028EA 656374656400       
  2577 000028F0 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2578 000028F9 422C572C4420657870-
  2579 00002902 656374656400       
  2580 00002908 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2581 00002911 6F7220524553422C57-
  2582 0000291A 2C4420657870656374-
  2583 00002923 656400             
  2584                                  
  2585                                  lookCode:  ; *** PROC ***
  2586                                  
  2587                                  ;-120     CodeType=0;
  2588                                  
  2589 00002926 66B800000000             mov eax, 0
  2590 0000292C A2[B001]                 mov byte [CodeType], al
  2591                                  
  2592                                  ;-121     OpCodePtr= &I_START;
  2593                                  
  2594 0000292F B8[081C]                 mov ax, I_START
  2595 00002932 A3[C901]                 mov word [OpCodePtr], ax
  2596                                  
  2597                                  ;-122     OpCodePtr++;
  2598                                  
  2599 00002935 FF06[C901]               inc  word [OpCodePtr]
  2600                                  
  2601                                  ;-123     do  {
  2602                                  
  2603                                  @@lookCode102:
  2604                                  
  2605                                  ;-124         if (eqstr(SymbolUpper, OpCodePtr))  {
  2606                                  
  2607 00002939 FF36[C901]               push word [OpCodePtr]
  2608 0000293D 8D06[2E00]               lea  ax, [SymbolUpper]
  2609 00002941 50                       push ax
  2610 00002942 E8811C                   call eqstr
  2611 00002945 83C404                   add  sp, 4
  2612 00002948 08C0                     or  al, al
  2613 0000294A 0F842700                 je @@lookCode103
  2614                                  
  2615                                  ;-125             while(*OpCodePtr!=0) OpCodePtr++;
  2616                                  
  2617                                  @@lookCode104:
  2618 0000294E 8B1E[C901]               mov bx, [OpCodePtr]
  2619 00002952 8A07                     mov al, [bx]
  2620 00002954 B400                     mov ah, 0
  2621 00002956 83F800                   cmp ax, 0
  2622 00002959 0F840600                 je  @@lookCode105
  2623 0000295D FF06[C901]               inc  word [OpCodePtr]
  2624                                  
  2625                                  ;-126             OpCodePtr++; 
  2626                                  
  2627 00002961 EBEB                     jmp @@lookCode104
  2628                                  @@lookCode105:
  2629 00002963 FF06[C901]               inc  word [OpCodePtr]
  2630                                  
  2631                                  ;-127             CodeType =*OpCodePtr;
  2632                                  
  2633 00002967 8B1E[C901]               mov bx, [OpCodePtr]
  2634 0000296B 8A07                     mov al, [bx]
  2635 0000296D B400                     mov ah, 0
  2636 0000296F A2[B001]                 mov byte [CodeType], al
  2637                                  
  2638                                  ;-128             return;
  2639                                  
  2640 00002972 E92A00                   jmp @@retn
  2641                                  
  2642                                  ;-129         }
  2643                                  
  2644                                  
  2645                                  ;-130     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2646                                  
  2647                                  @@lookCode103:
  2648                                  @@lookCode106:
  2649 00002975 8B1E[C901]               mov bx, [OpCodePtr]
  2650 00002979 8A07                     mov al, [bx]
  2651 0000297B B400                     mov ah, 0
  2652 0000297D 3DF100                   cmp ax, 241
  2653 00002980 0F840600                 je  @@lookCode107
  2654 00002984 FF06[C901]               inc  word [OpCodePtr]
  2655                                  
  2656                                  ;-131     OpCodePtr++;
  2657                                  
  2658 00002988 EBEB                     jmp @@lookCode106
  2659                                  @@lookCode107:
  2660 0000298A FF06[C901]               inc  word [OpCodePtr]
  2661                                  
  2662                                  ;-132     } while(*OpCodePtr!=0);
  2663                                  
  2664 0000298E 8B1E[C901]               mov bx, [OpCodePtr]
  2665 00002992 8A07                     mov al, [bx]
  2666 00002994 B400                     mov ah, 0
  2667 00002996 83F800                   cmp ax, 0
  2668 00002999 0F840200                 je  @@lookCode108
  2669 0000299D EB9A                     jmp @@lookCode102
  2670                                  @@lookCode108:
  2671                                  
  2672                                  ;-133 }
  2673                                  
  2674                                  
  2675                                  ;-134 
  2676                                  
  2677                                  
  2678                                  ;-135 int getCodeSize() {
  2679                                  
  2680                                  @@retn:
  2681 0000299F C3                       ret
  2682                                  ; ENDP
  2683                                  
  2684                                  getCodeSize:  ; *** PROC ***
  2685                                  
  2686                                  ;-136     if (TokeType ==ALNUME) {
  2687                                  
  2688 000029A0 A0[AD01]                 mov al, [TokeType]
  2689 000029A3 3C03                     cmp al, 3
  2690 000029A5 0F856000                 jne @@getCodeSize109
  2691                                  
  2692                                  ;-137         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2693                                  
  2694 000029A9 68[132A]                 push getCodeSize_0
  2695 000029AC 8D06[2E00]               lea  ax, [SymbolUpper]
  2696 000029B0 50                       push ax
  2697 000029B1 E8121C                   call eqstr
  2698 000029B4 83C404                   add  sp, 4
  2699 000029B7 08C0                     or  al, al
  2700 000029B9 0F840C00                 je @@getCodeSize110
  2701 000029BD E8FFFB                   call getTokeType
  2702 000029C0 66B801000000             mov eax, 1
  2703 000029C6 E94900                   jmp @@retn
  2704                                  
  2705                                  ;-138         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2706                                  
  2707                                  @@getCodeSize110:
  2708 000029C9 68[182A]                 push getCodeSize_1
  2709 000029CC 8D06[2E00]               lea  ax, [SymbolUpper]
  2710 000029D0 50                       push ax
  2711 000029D1 E8F21B                   call eqstr
  2712 000029D4 83C404                   add  sp, 4
  2713 000029D7 08C0                     or  al, al
  2714 000029D9 0F840C00                 je @@getCodeSize111
  2715 000029DD E8DFFB                   call getTokeType
  2716 000029E0 66B802000000             mov eax, 2
  2717 000029E6 E92900                   jmp @@retn
  2718                                  
  2719                                  ;-139         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2720                                  
  2721                                  @@getCodeSize111:
  2722 000029E9 68[1D2A]                 push getCodeSize_2
  2723 000029EC 8D06[2E00]               lea  ax, [SymbolUpper]
  2724 000029F0 50                       push ax
  2725 000029F1 E8D21B                   call eqstr
  2726 000029F4 83C404                   add  sp, 4
  2727 000029F7 08C0                     or  al, al
  2728 000029F9 0F840C00                 je @@getCodeSize112
  2729 000029FD E8BFFB                   call getTokeType
  2730 00002A00 66B803000000             mov eax, 3
  2731 00002A06 E90900                   jmp @@retn
  2732                                  
  2733                                  ;-140     } 
  2734                                  
  2735                                  @@getCodeSize112:
  2736                                  
  2737                                  ;-141     return 0;
  2738                                  
  2739                                  @@getCodeSize109:
  2740 00002A09 66B800000000             mov eax, 0
  2741 00002A0F E90000                   jmp @@retn
  2742                                  
  2743                                  ;-142 }
  2744                                  
  2745                                  
  2746                                  ;-143 int isToken(char c) {
  2747                                  
  2748                                  @@retn:
  2749 00002A12 C3                       ret
  2750                                  ; ENDP
  2751 00002A13 4259544500              getCodeSize_0 db "BYTE",0
  2752 00002A18 574F524400              getCodeSize_1 db "WORD",0
  2753 00002A1D 44574F524400            getCodeSize_2 db "DWORD",0
  2754                                  
  2755                                  isToken:  ; *** PROC ***
  2756                                  
  2757                                  ;-144     skipBlank();
  2758                                  
  2759                                  ;Function : isToken, Number of local variables: 1
  2760                                  ;   # type sign width line used address name   list of local variables
  2761                                  ;  200 var sign byte   143 NULL bp+4    c;
  2762 00002A23 C8000000                 ENTER  0,0
  2763 00002A27 E89101                   call skipBlank
  2764                                  
  2765                                  ;-145     if (*InputPtr == c) {
  2766                                  
  2767 00002A2A 8B1E[CE00]               mov bx, [InputPtr]
  2768 00002A2E 8A07                     mov al, [bx]
  2769 00002A30 B400                     mov ah, 0
  2770 00002A32 3A4604                   cmp al, [bp+4]
  2771 00002A35 0F850D00                 jne @@isToken113
  2772                                  
  2773                                  ;-146         InputPtr++; 
  2774                                  
  2775 00002A39 FF06[CE00]               inc  word [InputPtr]
  2776                                  
  2777                                  ;-147         return 1;
  2778                                  
  2779 00002A3D 66B801000000             mov eax, 1
  2780 00002A43 E90900                   jmp @@retn
  2781                                  
  2782                                  ;-148         } 
  2783                                  
  2784                                  
  2785                                  ;-149     return 0;
  2786                                  
  2787                                  @@isToken113:
  2788 00002A46 66B800000000             mov eax, 0
  2789 00002A4C E90000                   jmp @@retn
  2790                                  
  2791                                  ;-150 }
  2792                                  
  2793                                  
  2794                                  ;-151 int need(char c) {
  2795                                  
  2796 00002A4F C9                      @@retn: LEAVE
  2797 00002A50 C3                       ret
  2798                                  ; ENDP
  2799                                  
  2800                                  need:  ; *** PROC ***
  2801                                  
  2802                                  ;-152     if (isToken(c)) {
  2803                                  
  2804                                  ;Function : need, Number of local variables: 1
  2805                                  ;   # type sign width line used address name   list of local variables
  2806                                  ;  200 var sign byte   151 NULL bp+4    c;
  2807 00002A51 C8000000                 ENTER  0,0
  2808 00002A55 8A4604                   mov al, byte [bp+4]
  2809 00002A58 B400                     mov ah, 0
  2810 00002A5A 50                       push ax
  2811 00002A5B E8C5FF                   call isToken
  2812 00002A5E 83C402                   add  sp, 2
  2813 00002A61 08C0                     or  al, al
  2814 00002A63 0F840600                 je @@need114
  2815                                  
  2816                                  ;-153         getTokeType();
  2817                                  
  2818 00002A67 E855FB                   call getTokeType
  2819                                  
  2820                                  ;-154         return;
  2821                                  
  2822 00002A6A E91800                   jmp @@retn
  2823                                  
  2824                                  ;-155         }
  2825                                  
  2826                                  
  2827                                  ;-156     error1();
  2828                                  
  2829                                  @@need114:
  2830 00002A6D E80A0A                   call error1
  2831                                  
  2832                                  ;-157     prs(". need: ");
  2833                                  
  2834 00002A70 68[872A]                 push need_0
  2835 00002A73 E8A308                   call prs
  2836 00002A76 83C402                   add  sp, 2
  2837                                  
  2838                                  ;-158     prc(c);
  2839                                  
  2840 00002A79 8A4604                   mov al, byte [bp+4]
  2841 00002A7C B400                     mov ah, 0
  2842 00002A7E 50                       push ax
  2843 00002A7F E83608                   call prc
  2844 00002A82 83C402                   add  sp, 2
  2845                                  
  2846                                  ;-159 }
  2847                                  
  2848                                  
  2849                                  ;-160 int skipRest() {
  2850                                  
  2851 00002A85 C9                      @@retn: LEAVE
  2852 00002A86 C3                       ret
  2853                                  ; ENDP
  2854 00002A87 2E206E6565643A2000      need_0 db ". need: ",0
  2855                                  
  2856                                  skipRest:  ; *** PROC ***
  2857                                  
  2858                                  ;-161     getTokeType(); 
  2859                                  
  2860 00002A90 E82CFB                   call getTokeType
  2861                                  
  2862                                  ;-162     if(TokeType)error1("extra char ignored");
  2863                                  
  2864 00002A93 A0[AD01]                 mov al, [TokeType]
  2865 00002A96 08C0                     or  al, al
  2866 00002A98 0F840900                 je @@skipRest115
  2867 00002A9C 68[A62A]                 push skipRest_0
  2868 00002A9F E8D809                   call error1
  2869 00002AA2 83C402                   add  sp, 2
  2870                                  
  2871                                  ;-163 }
  2872                                  
  2873                                  @@skipRest115:
  2874 00002AA5 C3                       ret
  2875                                  ; ENDP
  2876 00002AA6 657874726120636861-     skipRest_0 db "extra char ignored",0
  2877 00002AAF 722069676E6F726564-
  2878 00002AB8 00                 
  2879                                  ;Back to main program: AS.C
  2880                                  
  2881                                  ;-6 #include "HELPER.C"
  2882                                  
  2883                                  ;Use include file: HELPER.C
  2884                                  
  2885                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2886                                  
  2887                                  
  2888                                  getLine:  ; *** PROC ***
  2889                                  
  2890                                  ;-2   unsigned int i;
  2891                                  
  2892                                  
  2893                                  ;-3   InputPtr= &InputBuf;
  2894                                  
  2895                                  ;Function : getLine, Number of local variables: 1
  2896                                  ;   # type sign width line used address name   list of local variables
  2897                                  ;  200 var unsg word     2 NULL bp-2    i;
  2898 00002AB9 C8020000                 ENTER  2,0
  2899 00002ABD B8[4F00]                 mov ax, InputBuf
  2900 00002AC0 A3[CE00]                 mov word [InputPtr], ax
  2901                                  
  2902                                  ;-4   *InputPtr=0;//if last line is empty
  2903                                  
  2904 00002AC3 66B800000000             mov eax, 0
  2905 00002AC9 8B1E[CE00]               mov  bx, [InputPtr]
  2906 00002ACD 8807                     mov  [bx], al
  2907                                  
  2908                                  ;-5   do {
  2909                                  
  2910                                  @@getLine116:
  2911                                  
  2912                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2913                                  
  2914 00002ACF 6A01                     push 1
  2915 00002AD1 FF36[9901]               push word [asm_fd]
  2916 00002AD5 8D06[A501]               lea  ax, [DOS_ByteRead]
  2917 00002AD9 50                       push ax
  2918 00002ADA E8841B                   call readRL
  2919 00002ADD 83C406                   add  sp, 6
  2920 00002AE0 A3[A301]                 mov word [DOS_NoBytes], ax
  2921                                  
  2922                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2923                                  
  2924 00002AE3 A1[9F01]                 mov ax, [DOS_ERR]
  2925 00002AE6 08C0                     or  al, al
  2926 00002AE8 0F840900                 je @@getLine117
  2927 00002AEC 68[512B]                 push getLine_0
  2928 00002AEF E8E709                   call errorexit
  2929 00002AF2 83C402                   add  sp, 2
  2930                                  
  2931                                  ;-8     if (DOS_NoBytes == 0) return;
  2932                                  
  2933                                  @@getLine117:
  2934 00002AF5 A1[A301]                 mov ax, [DOS_NoBytes]
  2935 00002AF8 83F800                   cmp ax, 0
  2936 00002AFB 0F850300                 jne @@getLine118
  2937 00002AFF E94D00                   jmp @@retn
  2938                                  
  2939                                  ;-9     *InputPtr = DOS_ByteRead;
  2940                                  
  2941                                  @@getLine118:
  2942 00002B02 A0[A501]                 mov al, [DOS_ByteRead]
  2943 00002B05 8B1E[CE00]               mov  bx, [InputPtr]
  2944 00002B09 8807                     mov  [bx], al
  2945                                  
  2946                                  ;-10     InputPtr++;
  2947                                  
  2948 00002B0B FF06[CE00]               inc  word [InputPtr]
  2949                                  
  2950                                  ;-11     i = InputPtr - &InputBuf;
  2951                                  
  2952 00002B0F A1[CE00]                 mov ax, [InputPtr]
  2953 00002B12 2D[4F00]                 sub ax, InputBuf
  2954 00002B15 8946FE                   mov word [bp-2], ax
  2955                                  
  2956                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2957                                  
  2958 00002B18 8B46FE                   mov ax, [bp-2]
  2959 00002B1B 83F87F                   cmp ax, 127 ;unsigned : 0
  2960 00002B1E 0F820900                 jb  @@getLine119
  2961 00002B22 68[602B]                 push getLine_1
  2962 00002B25 E8B109                   call errorexit
  2963 00002B28 83C402                   add  sp, 2
  2964                                  
  2965                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2966                                  
  2967                                  @@getLine119:
  2968 00002B2B A0[A501]                 mov al, byte [DOS_ByteRead]
  2969 00002B2E B400                     mov ah, 0
  2970 00002B30 50                       push ax
  2971 00002B31 E84000                   call ifEOL
  2972 00002B34 83C402                   add  sp, 2
  2973 00002B37 3C00                     cmp al, 0
  2974 00002B39 0F850200                 jne @@getLine120
  2975 00002B3D EB90                     jmp @@getLine116
  2976                                  @@getLine120:
  2977                                  
  2978                                  ;-14   InputPtr--;
  2979                                  
  2980 00002B3F FF0E[CE00]               dec  word [InputPtr]
  2981                                  
  2982                                  ;-15   *InputPtr=0;
  2983                                  
  2984 00002B43 66B800000000             mov eax, 0
  2985 00002B49 8B1E[CE00]               mov  bx, [InputPtr]
  2986 00002B4D 8807                     mov  [bx], al
  2987                                  
  2988                                  ;-16 }
  2989                                  
  2990                                  
  2991                                  ;-17 int ifEOL(char c) {
  2992                                  
  2993 00002B4F C9                      @@retn: LEAVE
  2994 00002B50 C3                       ret
  2995                                  ; ENDP
  2996 00002B51 52656164696E672053-     getLine_0 db "Reading Source",0
  2997 00002B5A 6F7572636500       
  2998 00002B60 696E707574206C696E-     getLine_1 db "input line too long",0
  2999 00002B69 6520746F6F206C6F6E-
  3000 00002B72 6700               
  3001                                  
  3002                                  ifEOL:  ; *** PROC ***
  3003                                  
  3004                                  ;-18   if (c == 10) return 1;
  3005                                  
  3006                                  ;Function : ifEOL, Number of local variables: 1
  3007                                  ;   # type sign width line used address name   list of local variables
  3008                                  ;  200 var sign byte    17 NULL bp+4    c;
  3009 00002B74 C8000000                 ENTER  0,0
  3010 00002B78 8A4604                   mov al, [bp+4]
  3011 00002B7B 3C0A                     cmp al, 10
  3012 00002B7D 0F850900                 jne @@ifEOL121
  3013 00002B81 66B801000000             mov eax, 1
  3014 00002B87 E92F00                   jmp @@retn
  3015                                  
  3016                                  ;-19   if (c == 13) {
  3017                                  
  3018                                  @@ifEOL121:
  3019 00002B8A 8A4604                   mov al, [bp+4]
  3020 00002B8D 3C0D                     cmp al, 13
  3021 00002B8F 0F851D00                 jne @@ifEOL122
  3022                                  
  3023                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3024                                  
  3025 00002B93 6A01                     push 1
  3026 00002B95 FF36[9901]               push word [asm_fd]
  3027 00002B99 8D06[A501]               lea  ax, [DOS_ByteRead]
  3028 00002B9D 50                       push ax
  3029 00002B9E E8C01A                   call readRL
  3030 00002BA1 83C406                   add  sp, 6
  3031 00002BA4 A3[A301]                 mov word [DOS_NoBytes], ax
  3032                                  
  3033                                  ;-21     return 1;}
  3034                                  
  3035 00002BA7 66B801000000             mov eax, 1
  3036 00002BAD E90900                   jmp @@retn
  3037                                  
  3038                                  ;-22   return 0;
  3039                                  
  3040                                  @@ifEOL122:
  3041 00002BB0 66B800000000             mov eax, 0
  3042 00002BB6 E90000                   jmp @@retn
  3043                                  
  3044                                  ;-23 }
  3045                                  
  3046                                  
  3047                                  ;-24 int skipBlank() {
  3048                                  
  3049 00002BB9 C9                      @@retn: LEAVE
  3050 00002BBA C3                       ret
  3051                                  ; ENDP
  3052                                  
  3053                                  skipBlank:  ; *** PROC ***
  3054                                  
  3055                                  ;-25   skipblank1:
  3056                                  
  3057                                  @@skipblank1:
  3058                                  
  3059                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3060                                  
  3061 00002BBB 8B1E[CE00]               mov bx, [InputPtr]
  3062 00002BBF 8A07                     mov al, [bx]
  3063 00002BC1 B400                     mov ah, 0
  3064 00002BC3 83F820                   cmp ax, 32
  3065 00002BC6 0F850600                 jne @@skipBlank123
  3066 00002BCA FF06[CE00]               inc  word [InputPtr]
  3067 00002BCE EBEB                     jmp @@skipblank1
  3068                                  
  3069                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3070                                  
  3071                                  @@skipBlank123:
  3072 00002BD0 8B1E[CE00]               mov bx, [InputPtr]
  3073 00002BD4 8A07                     mov al, [bx]
  3074 00002BD6 B400                     mov ah, 0
  3075 00002BD8 83F809                   cmp ax, 9
  3076 00002BDB 0F850600                 jne @@skipBlank124
  3077 00002BDF FF06[CE00]               inc  word [InputPtr]
  3078 00002BE3 EBD6                     jmp @@skipblank1
  3079                                  
  3080                                  ;-28 }
  3081                                  
  3082                                  @@skipBlank124:
  3083                                  
  3084                                  ;-29 int letterE(char c) {
  3085                                  
  3086 00002BE5 C3                       ret
  3087                                  ; ENDP
  3088                                  
  3089                                  letterE:  ; *** PROC ***
  3090                                  
  3091                                  ;-30   if (c=='_') return 1;
  3092                                  
  3093                                  ;Function : letterE, Number of local variables: 1
  3094                                  ;   # type sign width line used address name   list of local variables
  3095                                  ;  200 var sign byte    29 NULL bp+4    c;
  3096 00002BE6 C8000000                 ENTER  0,0
  3097 00002BEA 8A4604                   mov al, [bp+4]
  3098 00002BED 3C5F                     cmp al, 95
  3099 00002BEF 0F850900                 jne @@letterE125
  3100 00002BF3 66B801000000             mov eax, 1
  3101 00002BF9 E97E00                   jmp @@retn
  3102                                  
  3103                                  ;-31   if (c=='.') return 1;
  3104                                  
  3105                                  @@letterE125:
  3106 00002BFC 8A4604                   mov al, [bp+4]
  3107 00002BFF 3C2E                     cmp al, 46
  3108 00002C01 0F850900                 jne @@letterE126
  3109 00002C05 66B801000000             mov eax, 1
  3110 00002C0B E96C00                   jmp @@retn
  3111                                  
  3112                                  ;-32   if (c=='?') return 1;
  3113                                  
  3114                                  @@letterE126:
  3115 00002C0E 8A4604                   mov al, [bp+4]
  3116 00002C11 3C3F                     cmp al, 63
  3117 00002C13 0F850900                 jne @@letterE127
  3118 00002C17 66B801000000             mov eax, 1
  3119 00002C1D E95A00                   jmp @@retn
  3120                                  
  3121                                  ;-33   if (c=='$') return 1;
  3122                                  
  3123                                  @@letterE127:
  3124 00002C20 8A4604                   mov al, [bp+4]
  3125 00002C23 3C24                     cmp al, 36
  3126 00002C25 0F850900                 jne @@letterE128
  3127 00002C29 66B801000000             mov eax, 1
  3128 00002C2F E94800                   jmp @@retn
  3129                                  
  3130                                  ;-34   if (c> 'z') return 0;
  3131                                  
  3132                                  @@letterE128:
  3133 00002C32 8A4604                   mov al, [bp+4]
  3134 00002C35 3C7A                     cmp al, 122
  3135 00002C37 0F8E0900                 jle @@letterE129
  3136 00002C3B 66B800000000             mov eax, 0
  3137 00002C41 E93600                   jmp @@retn
  3138                                  
  3139                                  ;-35   if (c< '@') return 0; // at included
  3140                                  
  3141                                  @@letterE129:
  3142 00002C44 8A4604                   mov al, [bp+4]
  3143 00002C47 3C40                     cmp al, 64
  3144 00002C49 0F8D0900                 jge @@letterE130
  3145 00002C4D 66B800000000             mov eax, 0
  3146 00002C53 E92400                   jmp @@retn
  3147                                  
  3148                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  3149                                  
  3150                                  @@letterE130:
  3151 00002C56 8A4604                   mov al, [bp+4]
  3152 00002C59 3C5A                     cmp al, 90
  3153 00002C5B 0F8E1200                 jle @@letterE131
  3154 00002C5F 8A4604                   mov al, [bp+4]
  3155 00002C62 3C61                     cmp al, 97
  3156 00002C64 0F8D0900                 jge @@letterE132
  3157 00002C68 66B800000000             mov eax, 0
  3158 00002C6E E90900                   jmp @@retn
  3159                                  @@letterE132:
  3160                                  
  3161                                  ;-37   return 1;
  3162                                  
  3163                                  @@letterE131:
  3164 00002C71 66B801000000             mov eax, 1
  3165 00002C77 E90000                   jmp @@retn
  3166                                  
  3167                                  ;-38 }
  3168                                  
  3169                                  
  3170                                  ;-39 int alnumE(char c) {
  3171                                  
  3172 00002C7A C9                      @@retn: LEAVE
  3173 00002C7B C3                       ret
  3174                                  ; ENDP
  3175                                  
  3176                                  alnumE:  ; *** PROC ***
  3177                                  
  3178                                  ;-40   if (digit(c)) return 1;
  3179                                  
  3180                                  ;Function : alnumE, Number of local variables: 1
  3181                                  ;   # type sign width line used address name   list of local variables
  3182                                  ;  200 var sign byte    39 NULL bp+4    c;
  3183 00002C7C C8000000                 ENTER  0,0
  3184 00002C80 8A4604                   mov al, byte [bp+4]
  3185 00002C83 B400                     mov ah, 0
  3186 00002C85 50                       push ax
  3187 00002C86 E80A19                   call digit
  3188 00002C89 83C402                   add  sp, 2
  3189 00002C8C 08C0                     or  al, al
  3190 00002C8E 0F840900                 je @@alnumE133
  3191 00002C92 66B801000000             mov eax, 1
  3192 00002C98 E92400                   jmp @@retn
  3193                                  
  3194                                  ;-41   if (letterE(c)) return 1;
  3195                                  
  3196                                  @@alnumE133:
  3197 00002C9B 8A4604                   mov al, byte [bp+4]
  3198 00002C9E B400                     mov ah, 0
  3199 00002CA0 50                       push ax
  3200 00002CA1 E842FF                   call letterE
  3201 00002CA4 83C402                   add  sp, 2
  3202 00002CA7 08C0                     or  al, al
  3203 00002CA9 0F840900                 je @@alnumE134
  3204 00002CAD 66B801000000             mov eax, 1
  3205 00002CB3 E90900                   jmp @@retn
  3206                                  
  3207                                  ;-42   return 0;
  3208                                  
  3209                                  @@alnumE134:
  3210 00002CB6 66B800000000             mov eax, 0
  3211 00002CBC E90000                   jmp @@retn
  3212                                  
  3213                                  ;-43 }
  3214                                  
  3215                                  
  3216                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3217                                  
  3218 00002CBF C9                      @@retn: LEAVE
  3219 00002CC0 C3                       ret
  3220                                  ; ENDP
  3221                                  
  3222                                  getDigit:  ; *** PROC ***
  3223                                  
  3224                                  ;-45   unsigned int CastInt;
  3225                                  
  3226                                  
  3227                                  ;-46   SymbolInt=0;
  3228                                  
  3229                                  ;Function : getDigit, Number of local variables: 2
  3230                                  ;   # type sign width line used address name   list of local variables
  3231                                  ;  200 var unsg byte    44 NULL bp+4    c
  3232                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3233 00002CC1 C8020000                 ENTER  2,0
  3234 00002CC5 66B800000000             mov eax, 0
  3235 00002CCB A3[4D00]                 mov word [SymbolInt], ax
  3236                                  
  3237                                  ;-47   do {
  3238                                  
  3239                                  @@getDigit135:
  3240                                  
  3241                                  ;-48     c-='0';
  3242                                  
  3243 00002CCE 806E0430                 sub  byte [bp+4], 48
  3244                                  
  3245                                  ;-49     SymbolInt=SymbolInt*10;
  3246                                  
  3247 00002CD2 A1[4D00]                 mov ax, [SymbolInt]
  3248 00002CD5 66BB0A000000             mov ebx, 10
  3249 00002CDB 66F7E3                   mul ebx
  3250 00002CDE A3[4D00]                 mov word [SymbolInt], ax
  3251                                  
  3252                                  ;-50     ax=0; CastInt=c; //cast b2w
  3253                                  
  3254 00002CE1 B80000                   mov  ax, 0
  3255 00002CE4 8A4604                   mov al, [bp+4]
  3256 00002CE7 8946FE                   mov word [bp-2], ax
  3257                                  
  3258                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3259                                  
  3260 00002CEA A1[4D00]                 mov ax, [SymbolInt]
  3261 00002CED 0346FE                   add ax, [bp-2]
  3262 00002CF0 A3[4D00]                 mov word [SymbolInt], ax
  3263                                  
  3264                                  ;-52     InputPtr++;
  3265                                  
  3266 00002CF3 FF06[CE00]               inc  word [InputPtr]
  3267                                  
  3268                                  ;-53     c = *InputPtr;
  3269                                  
  3270 00002CF7 8B1E[CE00]               mov bx, [InputPtr]
  3271 00002CFB 8A07                     mov al, [bx]
  3272 00002CFD B400                     mov ah, 0
  3273 00002CFF 884604                   mov byte [bp+4], al
  3274                                  
  3275                                  ;-54   } while(digit(c));
  3276                                  
  3277 00002D02 8A4604                   mov al, byte [bp+4]
  3278 00002D05 B400                     mov ah, 0
  3279 00002D07 50                       push ax
  3280 00002D08 E88818                   call digit
  3281 00002D0B 83C402                   add  sp, 2
  3282 00002D0E 08C0                     or  al, al
  3283 00002D10 0F840200                 je @@getDigit136
  3284 00002D14 EBB8                     jmp @@getDigit135
  3285                                  @@getDigit136:
  3286                                  
  3287                                  ;-55 }
  3288                                  
  3289                                  
  3290                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3291 00002D16 C9                       LEAVE
  3292 00002D17 C3                       ret
  3293                                  ; ENDP
  3294                                  
  3295                                  getName:  ; *** PROC ***
  3296                                  
  3297                                  ;-57   char *p; unsigned int i;
  3298                                  
  3299                                  
  3300                                  ;-58   p = &Symbol;
  3301                                  
  3302                                  ;Function : getName, Number of local variables: 3
  3303                                  ;   # type sign width line used address name   list of local variables
  3304                                  ;  200 var unsg byte    56 NULL bp+4    c
  3305                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3306                                  ;  202 var unsg word    57 NULL bp-4    i;
  3307 00002D18 C8040000                 ENTER  4,0
  3308 00002D1C B8[0F00]                 mov ax, Symbol
  3309 00002D1F 8946FE                   mov word [bp-2], ax
  3310                                  
  3311                                  ;-59   *p = c;
  3312                                  
  3313 00002D22 8A4604                   mov al, [bp+4]
  3314 00002D25 8B5EFE                   mov  bx, [bp-2]
  3315 00002D28 8807                     mov  [bx], al
  3316                                  
  3317                                  ;-60   p++;
  3318                                  
  3319 00002D2A FF46FE                   inc  word [bp-2]
  3320                                  
  3321                                  ;-61   while (alnumE(c)) {
  3322                                  
  3323                                  @@getName137:
  3324 00002D2D 8A4604                   mov al, byte [bp+4]
  3325 00002D30 B400                     mov ah, 0
  3326 00002D32 50                       push ax
  3327 00002D33 E846FF                   call alnumE
  3328 00002D36 83C402                   add  sp, 2
  3329 00002D39 08C0                     or  al, al
  3330 00002D3B 0F843800                 je @@getName138
  3331                                  
  3332                                  ;-62     InputPtr++;
  3333                                  
  3334 00002D3F FF06[CE00]               inc  word [InputPtr]
  3335                                  
  3336                                  ;-63     c = *InputPtr;
  3337                                  
  3338 00002D43 8B1E[CE00]               mov bx, [InputPtr]
  3339 00002D47 8A07                     mov al, [bx]
  3340 00002D49 B400                     mov ah, 0
  3341 00002D4B 884604                   mov byte [bp+4], al
  3342                                  
  3343                                  ;-64     *p = c;
  3344                                  
  3345 00002D4E 8A4604                   mov al, [bp+4]
  3346 00002D51 8B5EFE                   mov  bx, [bp-2]
  3347 00002D54 8807                     mov  [bx], al
  3348                                  
  3349                                  ;-65     p++;
  3350                                  
  3351 00002D56 FF46FE                   inc  word [bp-2]
  3352                                  
  3353                                  ;-66     i = p - &Symbol;
  3354                                  
  3355 00002D59 8B46FE                   mov ax, [bp-2]
  3356 00002D5C 2D[0F00]                 sub ax, Symbol
  3357 00002D5F 8946FC                   mov word [bp-4], ax
  3358                                  
  3359                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3360                                  
  3361 00002D62 8B46FC                   mov ax, [bp-4]
  3362 00002D65 83F81F                   cmp ax, 31 ;unsigned : 0
  3363 00002D68 0F820900                 jb  @@getName139
  3364 00002D6C 68[C02D]                 push getName_0
  3365 00002D6F E86707                   call errorexit
  3366 00002D72 83C402                   add  sp, 2
  3367                                  
  3368                                  ;-68   }
  3369                                  
  3370                                  @@getName139:
  3371                                  
  3372                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3373                                  
  3374 00002D75 EBB6                     jmp @@getName137
  3375                                  @@getName138:
  3376 00002D77 8A4604                   mov al, [bp+4]
  3377 00002D7A 3C3A                     cmp al, 58
  3378 00002D7C 0F850C00                 jne @@getName140
  3379 00002D80 66B801000000             mov eax, 1
  3380 00002D86 A2[AC01]                 mov byte [isLabel], al
  3381 00002D89 E90900                   jmp @@getName141
  3382                                  @@getName140:
  3383 00002D8C 66B800000000             mov eax, 0
  3384 00002D92 A2[AC01]                 mov byte [isLabel], al
  3385                                  
  3386                                  ;-70   p--;
  3387                                  
  3388                                  @@getName141:
  3389 00002D95 FF4EFE                   dec  word [bp-2]
  3390                                  
  3391                                  ;-71   *p = 0;
  3392                                  
  3393 00002D98 66B800000000             mov eax, 0
  3394 00002D9E 8B5EFE                   mov  bx, [bp-2]
  3395 00002DA1 8807                     mov  [bx], al
  3396                                  
  3397                                  ;-72   strcpy(SymbolUpper, Symbol);
  3398                                  
  3399 00002DA3 8D06[0F00]               lea  ax, [Symbol]
  3400 00002DA7 50                       push ax
  3401 00002DA8 8D06[2E00]               lea  ax, [SymbolUpper]
  3402 00002DAC 50                       push ax
  3403 00002DAD E8AA17                   call strcpy
  3404 00002DB0 83C404                   add  sp, 4
  3405                                  
  3406                                  ;-73   toupper(SymbolUpper);
  3407                                  
  3408 00002DB3 8D06[2E00]               lea  ax, [SymbolUpper]
  3409 00002DB7 50                       push ax
  3410 00002DB8 E83117                   call toupper
  3411 00002DBB 83C402                   add  sp, 2
  3412                                  
  3413                                  ;-74 }
  3414                                  
  3415                                  
  3416                                  ;-75 int testReg() {
  3417 00002DBE C9                       LEAVE
  3418 00002DBF C3                       ret
  3419                                  ; ENDP
  3420 00002DC0 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3421 00002DC9 6F206C6F6E6700     
  3422                                  
  3423                                  testReg:  ; *** PROC ***
  3424                                  
  3425                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3426                                  
  3427                                  
  3428                                  ;-77   R2Type=0;
  3429                                  
  3430 00002DD0 66B800000000             mov eax, 0
  3431 00002DD6 A2[B601]                 mov byte [R2Type], al
  3432                                  
  3433                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3434                                  
  3435 00002DD9 8D06[0F00]               lea  ax, [Symbol]
  3436 00002DDD 50                       push ax
  3437 00002DDE E84E17                   call strlen
  3438 00002DE1 83C402                   add  sp, 2
  3439 00002DE4 3C02                     cmp al, 2
  3440 00002DE6 0F8D0900                 jge @@testReg142
  3441 00002DEA 66B800000000             mov eax, 0
  3442 00002DF0 E9B603                   jmp @@retn
  3443                                  
  3444                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3445                                  
  3446                                  @@testReg142:
  3447 00002DF3 8D06[0F00]               lea  ax, [Symbol]
  3448 00002DF7 50                       push ax
  3449 00002DF8 E83417                   call strlen
  3450 00002DFB 83C402                   add  sp, 2
  3451 00002DFE 3C03                     cmp al, 3
  3452 00002E00 0F8E0900                 jle @@testReg143
  3453 00002E04 66B800000000             mov eax, 0
  3454 00002E0A E99C03                   jmp @@retn
  3455                                  
  3456                                  ;-80   R2Type=BYTE;
  3457                                  
  3458                                  @@testReg143:
  3459 00002E0D 66B801000000             mov eax, 1
  3460 00002E13 A2[B601]                 mov byte [R2Type], al
  3461                                  
  3462                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3463                                  
  3464 00002E16 68[AA31]                 push testReg_0
  3465 00002E19 8D06[2E00]               lea  ax, [SymbolUpper]
  3466 00002E1D 50                       push ax
  3467 00002E1E E8A517                   call eqstr
  3468 00002E21 83C404                   add  sp, 4
  3469 00002E24 08C0                     or  al, al
  3470 00002E26 0F840900                 je @@testReg144
  3471 00002E2A 66B800000000             mov eax, 0
  3472 00002E30 E97603                   jmp @@retn
  3473                                  
  3474                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3475                                  
  3476                                  @@testReg144:
  3477 00002E33 68[AD31]                 push testReg_1
  3478 00002E36 8D06[2E00]               lea  ax, [SymbolUpper]
  3479 00002E3A 50                       push ax
  3480 00002E3B E88817                   call eqstr
  3481 00002E3E 83C404                   add  sp, 4
  3482 00002E41 08C0                     or  al, al
  3483 00002E43 0F840900                 je @@testReg145
  3484 00002E47 66B801000000             mov eax, 1
  3485 00002E4D E95903                   jmp @@retn
  3486                                  
  3487                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3488                                  
  3489                                  @@testReg145:
  3490 00002E50 68[B031]                 push testReg_2
  3491 00002E53 8D06[2E00]               lea  ax, [SymbolUpper]
  3492 00002E57 50                       push ax
  3493 00002E58 E86B17                   call eqstr
  3494 00002E5B 83C404                   add  sp, 4
  3495 00002E5E 08C0                     or  al, al
  3496 00002E60 0F840900                 je @@testReg146
  3497 00002E64 66B802000000             mov eax, 2
  3498 00002E6A E93C03                   jmp @@retn
  3499                                  
  3500                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3501                                  
  3502                                  @@testReg146:
  3503 00002E6D 68[B331]                 push testReg_3
  3504 00002E70 8D06[2E00]               lea  ax, [SymbolUpper]
  3505 00002E74 50                       push ax
  3506 00002E75 E84E17                   call eqstr
  3507 00002E78 83C404                   add  sp, 4
  3508 00002E7B 08C0                     or  al, al
  3509 00002E7D 0F840900                 je @@testReg147
  3510 00002E81 66B803000000             mov eax, 3
  3511 00002E87 E91F03                   jmp @@retn
  3512                                  
  3513                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3514                                  
  3515                                  @@testReg147:
  3516 00002E8A 68[B631]                 push testReg_4
  3517 00002E8D 8D06[2E00]               lea  ax, [SymbolUpper]
  3518 00002E91 50                       push ax
  3519 00002E92 E83117                   call eqstr
  3520 00002E95 83C404                   add  sp, 4
  3521 00002E98 08C0                     or  al, al
  3522 00002E9A 0F840900                 je @@testReg148
  3523 00002E9E 66B804000000             mov eax, 4
  3524 00002EA4 E90203                   jmp @@retn
  3525                                  
  3526                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3527                                  
  3528                                  @@testReg148:
  3529 00002EA7 68[B931]                 push testReg_5
  3530 00002EAA 8D06[2E00]               lea  ax, [SymbolUpper]
  3531 00002EAE 50                       push ax
  3532 00002EAF E81417                   call eqstr
  3533 00002EB2 83C404                   add  sp, 4
  3534 00002EB5 08C0                     or  al, al
  3535 00002EB7 0F840900                 je @@testReg149
  3536 00002EBB 66B805000000             mov eax, 5
  3537 00002EC1 E9E502                   jmp @@retn
  3538                                  
  3539                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3540                                  
  3541                                  @@testReg149:
  3542 00002EC4 68[BC31]                 push testReg_6
  3543 00002EC7 8D06[2E00]               lea  ax, [SymbolUpper]
  3544 00002ECB 50                       push ax
  3545 00002ECC E8F716                   call eqstr
  3546 00002ECF 83C404                   add  sp, 4
  3547 00002ED2 08C0                     or  al, al
  3548 00002ED4 0F840900                 je @@testReg150
  3549 00002ED8 66B806000000             mov eax, 6
  3550 00002EDE E9C802                   jmp @@retn
  3551                                  
  3552                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3553                                  
  3554                                  @@testReg150:
  3555 00002EE1 68[BF31]                 push testReg_7
  3556 00002EE4 8D06[2E00]               lea  ax, [SymbolUpper]
  3557 00002EE8 50                       push ax
  3558 00002EE9 E8DA16                   call eqstr
  3559 00002EEC 83C404                   add  sp, 4
  3560 00002EEF 08C0                     or  al, al
  3561 00002EF1 0F840900                 je @@testReg151
  3562 00002EF5 66B807000000             mov eax, 7
  3563 00002EFB E9AB02                   jmp @@retn
  3564                                  
  3565                                  ;-89   R2Type=WORD;
  3566                                  
  3567                                  @@testReg151:
  3568 00002EFE 66B802000000             mov eax, 2
  3569 00002F04 A2[B601]                 mov byte [R2Type], al
  3570                                  
  3571                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3572                                  
  3573 00002F07 68[C231]                 push testReg_8
  3574 00002F0A 8D06[2E00]               lea  ax, [SymbolUpper]
  3575 00002F0E 50                       push ax
  3576 00002F0F E8B416                   call eqstr
  3577 00002F12 83C404                   add  sp, 4
  3578 00002F15 08C0                     or  al, al
  3579 00002F17 0F840900                 je @@testReg152
  3580 00002F1B 66B800000000             mov eax, 0
  3581 00002F21 E98502                   jmp @@retn
  3582                                  
  3583                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3584                                  
  3585                                  @@testReg152:
  3586 00002F24 68[C531]                 push testReg_9
  3587 00002F27 8D06[2E00]               lea  ax, [SymbolUpper]
  3588 00002F2B 50                       push ax
  3589 00002F2C E89716                   call eqstr
  3590 00002F2F 83C404                   add  sp, 4
  3591 00002F32 08C0                     or  al, al
  3592 00002F34 0F840900                 je @@testReg153
  3593 00002F38 66B801000000             mov eax, 1
  3594 00002F3E E96802                   jmp @@retn
  3595                                  
  3596                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3597                                  
  3598                                  @@testReg153:
  3599 00002F41 68[C831]                 push testReg_10
  3600 00002F44 8D06[2E00]               lea  ax, [SymbolUpper]
  3601 00002F48 50                       push ax
  3602 00002F49 E87A16                   call eqstr
  3603 00002F4C 83C404                   add  sp, 4
  3604 00002F4F 08C0                     or  al, al
  3605 00002F51 0F840900                 je @@testReg154
  3606 00002F55 66B802000000             mov eax, 2
  3607 00002F5B E94B02                   jmp @@retn
  3608                                  
  3609                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3610                                  
  3611                                  @@testReg154:
  3612 00002F5E 68[CB31]                 push testReg_11
  3613 00002F61 8D06[2E00]               lea  ax, [SymbolUpper]
  3614 00002F65 50                       push ax
  3615 00002F66 E85D16                   call eqstr
  3616 00002F69 83C404                   add  sp, 4
  3617 00002F6C 08C0                     or  al, al
  3618 00002F6E 0F840900                 je @@testReg155
  3619 00002F72 66B803000000             mov eax, 3
  3620 00002F78 E92E02                   jmp @@retn
  3621                                  
  3622                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3623                                  
  3624                                  @@testReg155:
  3625 00002F7B 68[CE31]                 push testReg_12
  3626 00002F7E 8D06[2E00]               lea  ax, [SymbolUpper]
  3627 00002F82 50                       push ax
  3628 00002F83 E84016                   call eqstr
  3629 00002F86 83C404                   add  sp, 4
  3630 00002F89 08C0                     or  al, al
  3631 00002F8B 0F840900                 je @@testReg156
  3632 00002F8F 66B804000000             mov eax, 4
  3633 00002F95 E91102                   jmp @@retn
  3634                                  
  3635                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3636                                  
  3637                                  @@testReg156:
  3638 00002F98 68[D131]                 push testReg_13
  3639 00002F9B 8D06[2E00]               lea  ax, [SymbolUpper]
  3640 00002F9F 50                       push ax
  3641 00002FA0 E82316                   call eqstr
  3642 00002FA3 83C404                   add  sp, 4
  3643 00002FA6 08C0                     or  al, al
  3644 00002FA8 0F840900                 je @@testReg157
  3645 00002FAC 66B805000000             mov eax, 5
  3646 00002FB2 E9F401                   jmp @@retn
  3647                                  
  3648                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3649                                  
  3650                                  @@testReg157:
  3651 00002FB5 68[D431]                 push testReg_14
  3652 00002FB8 8D06[2E00]               lea  ax, [SymbolUpper]
  3653 00002FBC 50                       push ax
  3654 00002FBD E80616                   call eqstr
  3655 00002FC0 83C404                   add  sp, 4
  3656 00002FC3 08C0                     or  al, al
  3657 00002FC5 0F840900                 je @@testReg158
  3658 00002FC9 66B806000000             mov eax, 6
  3659 00002FCF E9D701                   jmp @@retn
  3660                                  
  3661                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3662                                  
  3663                                  @@testReg158:
  3664 00002FD2 68[D731]                 push testReg_15
  3665 00002FD5 8D06[2E00]               lea  ax, [SymbolUpper]
  3666 00002FD9 50                       push ax
  3667 00002FDA E8E915                   call eqstr
  3668 00002FDD 83C404                   add  sp, 4
  3669 00002FE0 08C0                     or  al, al
  3670 00002FE2 0F840900                 je @@testReg159
  3671 00002FE6 66B807000000             mov eax, 7
  3672 00002FEC E9BA01                   jmp @@retn
  3673                                  
  3674                                  ;-98   R2Type=SEGREG;
  3675                                  
  3676                                  @@testReg159:
  3677 00002FEF 66B804000000             mov eax, 4
  3678 00002FF5 A2[B601]                 mov byte [R2Type], al
  3679                                  
  3680                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3681                                  
  3682 00002FF8 68[DA31]                 push testReg_16
  3683 00002FFB 8D06[2E00]               lea  ax, [SymbolUpper]
  3684 00002FFF 50                       push ax
  3685 00003000 E8C315                   call eqstr
  3686 00003003 83C404                   add  sp, 4
  3687 00003006 08C0                     or  al, al
  3688 00003008 0F840900                 je @@testReg160
  3689 0000300C 66B800000000             mov eax, 0
  3690 00003012 E99401                   jmp @@retn
  3691                                  
  3692                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3693                                  
  3694                                  @@testReg160:
  3695 00003015 68[DD31]                 push testReg_17
  3696 00003018 8D06[2E00]               lea  ax, [SymbolUpper]
  3697 0000301C 50                       push ax
  3698 0000301D E8A615                   call eqstr
  3699 00003020 83C404                   add  sp, 4
  3700 00003023 08C0                     or  al, al
  3701 00003025 0F840900                 je @@testReg161
  3702 00003029 66B801000000             mov eax, 1
  3703 0000302F E97701                   jmp @@retn
  3704                                  
  3705                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3706                                  
  3707                                  @@testReg161:
  3708 00003032 68[E031]                 push testReg_18
  3709 00003035 8D06[2E00]               lea  ax, [SymbolUpper]
  3710 00003039 50                       push ax
  3711 0000303A E88915                   call eqstr
  3712 0000303D 83C404                   add  sp, 4
  3713 00003040 08C0                     or  al, al
  3714 00003042 0F840900                 je @@testReg162
  3715 00003046 66B802000000             mov eax, 2
  3716 0000304C E95A01                   jmp @@retn
  3717                                  
  3718                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3719                                  
  3720                                  @@testReg162:
  3721 0000304F 68[E331]                 push testReg_19
  3722 00003052 8D06[2E00]               lea  ax, [SymbolUpper]
  3723 00003056 50                       push ax
  3724 00003057 E86C15                   call eqstr
  3725 0000305A 83C404                   add  sp, 4
  3726 0000305D 08C0                     or  al, al
  3727 0000305F 0F840900                 je @@testReg163
  3728 00003063 66B803000000             mov eax, 3
  3729 00003069 E93D01                   jmp @@retn
  3730                                  
  3731                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3732                                  
  3733                                  @@testReg163:
  3734 0000306C 68[E631]                 push testReg_20
  3735 0000306F 8D06[2E00]               lea  ax, [SymbolUpper]
  3736 00003073 50                       push ax
  3737 00003074 E84F15                   call eqstr
  3738 00003077 83C404                   add  sp, 4
  3739 0000307A 08C0                     or  al, al
  3740 0000307C 0F840900                 je @@testReg164
  3741 00003080 66B804000000             mov eax, 4
  3742 00003086 E92001                   jmp @@retn
  3743                                  
  3744                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3745                                  
  3746                                  @@testReg164:
  3747 00003089 68[E931]                 push testReg_21
  3748 0000308C 8D06[2E00]               lea  ax, [SymbolUpper]
  3749 00003090 50                       push ax
  3750 00003091 E83215                   call eqstr
  3751 00003094 83C404                   add  sp, 4
  3752 00003097 08C0                     or  al, al
  3753 00003099 0F840900                 je @@testReg165
  3754 0000309D 66B805000000             mov eax, 5
  3755 000030A3 E90301                   jmp @@retn
  3756                                  
  3757                                  ;-105   R2Type=DWORD;                         
  3758                                  
  3759                                  @@testReg165:
  3760 000030A6 66B803000000             mov eax, 3
  3761 000030AC A2[B601]                 mov byte [R2Type], al
  3762                                  
  3763                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3764                                  
  3765 000030AF 68[EC31]                 push testReg_22
  3766 000030B2 8D06[2E00]               lea  ax, [SymbolUpper]
  3767 000030B6 50                       push ax
  3768 000030B7 E80C15                   call eqstr
  3769 000030BA 83C404                   add  sp, 4
  3770 000030BD 08C0                     or  al, al
  3771 000030BF 0F840900                 je @@testReg166
  3772 000030C3 66B800000000             mov eax, 0
  3773 000030C9 E9DD00                   jmp @@retn
  3774                                  
  3775                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3776                                  
  3777                                  @@testReg166:
  3778 000030CC 68[F031]                 push testReg_23
  3779 000030CF 8D06[2E00]               lea  ax, [SymbolUpper]
  3780 000030D3 50                       push ax
  3781 000030D4 E8EF14                   call eqstr
  3782 000030D7 83C404                   add  sp, 4
  3783 000030DA 08C0                     or  al, al
  3784 000030DC 0F840900                 je @@testReg167
  3785 000030E0 66B801000000             mov eax, 1
  3786 000030E6 E9C000                   jmp @@retn
  3787                                  
  3788                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3789                                  
  3790                                  @@testReg167:
  3791 000030E9 68[F431]                 push testReg_24
  3792 000030EC 8D06[2E00]               lea  ax, [SymbolUpper]
  3793 000030F0 50                       push ax
  3794 000030F1 E8D214                   call eqstr
  3795 000030F4 83C404                   add  sp, 4
  3796 000030F7 08C0                     or  al, al
  3797 000030F9 0F840900                 je @@testReg168
  3798 000030FD 66B802000000             mov eax, 2
  3799 00003103 E9A300                   jmp @@retn
  3800                                  
  3801                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3802                                  
  3803                                  @@testReg168:
  3804 00003106 68[F831]                 push testReg_25
  3805 00003109 8D06[2E00]               lea  ax, [SymbolUpper]
  3806 0000310D 50                       push ax
  3807 0000310E E8B514                   call eqstr
  3808 00003111 83C404                   add  sp, 4
  3809 00003114 08C0                     or  al, al
  3810 00003116 0F840900                 je @@testReg169
  3811 0000311A 66B803000000             mov eax, 3
  3812 00003120 E98600                   jmp @@retn
  3813                                  
  3814                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3815                                  
  3816                                  @@testReg169:
  3817 00003123 68[FC31]                 push testReg_26
  3818 00003126 8D06[2E00]               lea  ax, [SymbolUpper]
  3819 0000312A 50                       push ax
  3820 0000312B E89814                   call eqstr
  3821 0000312E 83C404                   add  sp, 4
  3822 00003131 08C0                     or  al, al
  3823 00003133 0F840900                 je @@testReg170
  3824 00003137 66B804000000             mov eax, 4
  3825 0000313D E96900                   jmp @@retn
  3826                                  
  3827                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3828                                  
  3829                                  @@testReg170:
  3830 00003140 68[0032]                 push testReg_27
  3831 00003143 8D06[2E00]               lea  ax, [SymbolUpper]
  3832 00003147 50                       push ax
  3833 00003148 E87B14                   call eqstr
  3834 0000314B 83C404                   add  sp, 4
  3835 0000314E 08C0                     or  al, al
  3836 00003150 0F840900                 je @@testReg171
  3837 00003154 66B805000000             mov eax, 5
  3838 0000315A E94C00                   jmp @@retn
  3839                                  
  3840                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3841                                  
  3842                                  @@testReg171:
  3843 0000315D 68[0432]                 push testReg_28
  3844 00003160 8D06[2E00]               lea  ax, [SymbolUpper]
  3845 00003164 50                       push ax
  3846 00003165 E85E14                   call eqstr
  3847 00003168 83C404                   add  sp, 4
  3848 0000316B 08C0                     or  al, al
  3849 0000316D 0F840900                 je @@testReg172
  3850 00003171 66B806000000             mov eax, 6
  3851 00003177 E92F00                   jmp @@retn
  3852                                  
  3853                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3854                                  
  3855                                  @@testReg172:
  3856 0000317A 68[0832]                 push testReg_29
  3857 0000317D 8D06[2E00]               lea  ax, [SymbolUpper]
  3858 00003181 50                       push ax
  3859 00003182 E84114                   call eqstr
  3860 00003185 83C404                   add  sp, 4
  3861 00003188 08C0                     or  al, al
  3862 0000318A 0F840900                 je @@testReg173
  3863 0000318E 66B807000000             mov eax, 7
  3864 00003194 E91200                   jmp @@retn
  3865                                  
  3866                                  ;-114   R2Type=0; return 0;
  3867                                  
  3868                                  @@testReg173:
  3869 00003197 66B800000000             mov eax, 0
  3870 0000319D A2[B601]                 mov byte [R2Type], al
  3871 000031A0 66B800000000             mov eax, 0
  3872 000031A6 E90000                   jmp @@retn
  3873                                  
  3874                                  ;-115 }
  3875                                  
  3876                                  @@retn:
  3877 000031A9 C3                       ret
  3878                                  ; ENDP
  3879 000031AA 414C00                  testReg_0 db "AL",0
  3880 000031AD 434C00                  testReg_1 db "CL",0
  3881 000031B0 444C00                  testReg_2 db "DL",0
  3882 000031B3 424C00                  testReg_3 db "BL",0
  3883 000031B6 414800                  testReg_4 db "AH",0
  3884 000031B9 434800                  testReg_5 db "CH",0
  3885 000031BC 444800                  testReg_6 db "DH",0
  3886 000031BF 424800                  testReg_7 db "BH",0
  3887 000031C2 415800                  testReg_8 db "AX",0
  3888 000031C5 435800                  testReg_9 db "CX",0
  3889 000031C8 445800                  testReg_10 db "DX",0
  3890 000031CB 425800                  testReg_11 db "BX",0
  3891 000031CE 535000                  testReg_12 db "SP",0
  3892 000031D1 425000                  testReg_13 db "BP",0
  3893 000031D4 534900                  testReg_14 db "SI",0
  3894 000031D7 444900                  testReg_15 db "DI",0
  3895 000031DA 455300                  testReg_16 db "ES",0
  3896 000031DD 435300                  testReg_17 db "CS",0
  3897 000031E0 535300                  testReg_18 db "SS",0
  3898 000031E3 445300                  testReg_19 db "DS",0
  3899 000031E6 465300                  testReg_20 db "FS",0
  3900 000031E9 475300                  testReg_21 db "GS",0
  3901 000031EC 45415800                testReg_22 db "EAX",0
  3902 000031F0 45435800                testReg_23 db "ECX",0
  3903 000031F4 45445800                testReg_24 db "EDX",0
  3904 000031F8 45425800                testReg_25 db "EBX",0
  3905 000031FC 45535000                testReg_26 db "ESP",0
  3906 00003200 45425000                testReg_27 db "EBP",0
  3907 00003204 45534900                testReg_28 db "ESI",0
  3908 00003208 45444900                testReg_29 db "EDI",0
  3909                                  ;Back to main program: AS.C
  3910                                  
  3911                                  ;-7 #include "OUTPUT.C"
  3912                                  
  3913                                  ;Use include file: OUTPUT.C
  3914                                  
  3915                                  ;-1 int printLine() { 
  3916                                  
  3917                                  
  3918                                  printLine:  ; *** PROC ***
  3919                                  
  3920                                  ;-2     int i; char c;
  3921                                  
  3922                                  
  3923                                  ;-3     prs("\n"); 
  3924                                  
  3925                                  ;Function : printLine, Number of local variables: 2
  3926                                  ;   # type sign width line used address name   list of local variables
  3927                                  ;  200 var sign word     2 NULL bp-2    i
  3928                                  ;  201 var sign byte     2 NULL bp-4    c;
  3929 0000320C C8040000                 ENTER  4,0
  3930 00003210 68[A132]                 push printLine_0
  3931 00003213 E80301                   call prs
  3932 00003216 83C402                   add  sp, 2
  3933                                  
  3934                                  ;-4     printhex16(PCStart);
  3935                                  
  3936 00003219 FF36[AA01]               push word [PCStart]
  3937 0000321D E8EE01                   call printhex16
  3938 00003220 83C402                   add  sp, 2
  3939                                  
  3940                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  3941                                  
  3942 00003223 A1[C701]                 mov ax, [OpPrintIndex]
  3943 00003226 83F800                   cmp ax, 0
  3944 00003229 0F850C00                 jne @@printLine174
  3945 0000322D 68[A432]                 push printLine_1
  3946 00003230 E8E600                   call prs
  3947 00003233 83C402                   add  sp, 2
  3948                                  
  3949                                  ;-6     else {
  3950                                  
  3951 00003236 E94F00                   jmp @@printLine175
  3952                                  @@printLine174:
  3953                                  
  3954                                  ;-7 //        prc(' ');
  3955                                  
  3956                                  
  3957                                  ;-8         i=0;
  3958                                  
  3959 00003239 66B800000000             mov eax, 0
  3960 0000323F 8946FE                   mov word [bp-2], ax
  3961                                  
  3962                                  ;-9         do {
  3963                                  
  3964                                  @@printLine176:
  3965                                  
  3966                                  ;-10             c=OpPos[i];
  3967                                  
  3968 00003242 8B5EFE                   mov bx, [bp-2]
  3969 00003245 8A87[C201]               mov al, [OpPos + bx]
  3970 00003249 8846FC                   mov byte [bp-4], al
  3971                                  
  3972                                  ;-11             prc(' ');
  3973                                  
  3974 0000324C 6A20                     push 32
  3975 0000324E E86700                   call prc
  3976 00003251 83C402                   add  sp, 2
  3977                                  
  3978                                  ;-12             printhex8a(c); 
  3979                                  
  3980 00003254 8A46FC                   mov al, byte [bp-4]
  3981 00003257 B400                     mov ah, 0
  3982 00003259 50                       push ax
  3983 0000325A E85F01                   call printhex8a
  3984 0000325D 83C402                   add  sp, 2
  3985                                  
  3986                                  ;-13             i++;
  3987                                  
  3988 00003260 FF46FE                   inc  word [bp-2]
  3989                                  
  3990                                  ;-14         } while (i < OpPrintIndex);
  3991                                  
  3992 00003263 8B46FE                   mov ax, [bp-2]
  3993 00003266 3B06[C701]               cmp ax, [OpPrintIndex]
  3994 0000326A 0F8D0200                 jge @@printLine177
  3995 0000326E EBD2                     jmp @@printLine176
  3996                                  @@printLine177:
  3997                                  
  3998                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  3999                                  
  4000                                  @@printLine178:
  4001 00003270 8B46FE                   mov ax, [bp-2]
  4002 00003273 83F805                   cmp ax, 5
  4003 00003276 0F8D0E00                 jge @@printLine179
  4004                                  
  4005                                  ;-16             prs("   ");
  4006                                  
  4007 0000327A 68[B432]                 push printLine_2
  4008 0000327D E89900                   call prs
  4009 00003280 83C402                   add  sp, 2
  4010                                  
  4011                                  ;-17             i++;
  4012                                  
  4013 00003283 FF46FE                   inc  word [bp-2]
  4014                                  
  4015                                  ;-18         }
  4016                                  
  4017                                  
  4018                                  ;-19     }
  4019                                  
  4020 00003286 EBE8                     jmp @@printLine178
  4021                                  @@printLine179:
  4022                                  
  4023                                  ;-20     prc(PrintRA);
  4024                                  
  4025                                  @@printLine175:
  4026 00003288 A0[CB01]                 mov al, byte [PrintRA]
  4027 0000328B B400                     mov ah, 0
  4028 0000328D 50                       push ax
  4029 0000328E E82700                   call prc
  4030 00003291 83C402                   add  sp, 2
  4031                                  
  4032                                  ;-21     prscomment(InputBuf);
  4033                                  
  4034 00003294 8D06[4F00]               lea  ax, [InputBuf]
  4035 00003298 50                       push ax
  4036 00003299 E84F00                   call prscomment
  4037 0000329C 83C402                   add  sp, 2
  4038                                  
  4039                                  ;-22 }
  4040                                  
  4041                                  
  4042                                  ;-23 int prc(unsigned char c) {//print char 
  4043 0000329F C9                       LEAVE
  4044 000032A0 C3                       ret
  4045                                  ; ENDP
  4046 000032A1 5C6E00                  printLine_0 db "\n",0
  4047 000032A4 202020202020202020-     printLine_1 db "               ",0
  4048 000032AD 20202020202000     
  4049 000032B4 20202000                printLine_2 db "   ",0
  4050                                  
  4051                                  prc:  ; *** PROC ***
  4052                                  
  4053                                  ;-24     if (LIST) { 
  4054                                  
  4055                                  ;Function : prc, Number of local variables: 1
  4056                                  ;   # type sign width line used address name   list of local variables
  4057                                  ;  200 var unsg byte    23 NULL bp+4    c;
  4058 000032B8 C8000000                 ENTER  0,0
  4059 000032BC A0[0E00]                 mov al, [LIST]
  4060 000032BF 08C0                     or  al, al
  4061 000032C1 0F841400                 je @@prc180
  4062                                  
  4063                                  ;-25         if ( _ c==10) {
  4064                                  
  4065 000032C5 807E040A                cmp byte [bp+4], 10
  4066 000032C9 0F850600                 jne @@prc181
  4067                                  
  4068                                  ;-26             ax=13; 
  4069                                  
  4070 000032CD B80D00                   mov  ax, 13
  4071                                  
  4072                                  ;-27             writetty(); 
  4073                                  
  4074 000032D0 E8E311                   call writetty
  4075                                  
  4076                                  ;-28             }
  4077                                  
  4078                                  
  4079                                  ;-29         al=c; 
  4080                                  
  4081                                  @@prc181:
  4082 000032D3 8A4604                   mov  al, [bp+4]
  4083                                  
  4084                                  ;-30         writetty(); 
  4085                                  
  4086 000032D6 E8DD11                   call writetty
  4087                                  
  4088                                  ;-31         }
  4089                                  
  4090                                  
  4091                                  ;-32     fputcR(c,lst_fd); 
  4092                                  
  4093                                  @@prc180:
  4094 000032D9 FF36[9B01]               push word [lst_fd]
  4095 000032DD 8A4604                   mov al, byte [bp+4]
  4096 000032E0 B400                     mov ah, 0
  4097 000032E2 50                       push ax
  4098 000032E3 E89013                   call fputcR
  4099 000032E6 83C404                   add  sp, 4
  4100                                  
  4101                                  ;-33 }
  4102                                  
  4103                                  
  4104                                  ;-34 
  4105                                  
  4106                                  
  4107                                  ;-35 int prscomment(unsigned char *s) {
  4108 000032E9 C9                       LEAVE
  4109 000032EA C3                       ret
  4110                                  ; ENDP
  4111                                  
  4112                                  prscomment:  ; *** PROC ***
  4113                                  
  4114                                  ;-36     unsigned char c;
  4115                                  
  4116                                  
  4117                                  ;-37     while (*s){
  4118                                  
  4119                                  ;Function : prscomment, Number of local variables: 2
  4120                                  ;   # type sign width line used address name   list of local variables
  4121                                  ;  200 ptr unsg byte    35 NULL bp+4    s
  4122                                  ;  201 var unsg byte    36 NULL bp-2    c;
  4123 000032EB C8020000                 ENTER  2,0
  4124                                  @@prscomment182:
  4125 000032EF 8B5E04                   mov bx, [bp+4]
  4126 000032F2 8A07                     mov al, [bx]
  4127 000032F4 B400                     mov ah, 0
  4128 000032F6 08C0                     or  al, al
  4129 000032F8 0F841B00                 je @@prscomment183
  4130                                  
  4131                                  ;-38         c=*s;
  4132                                  
  4133 000032FC 8B5E04                   mov bx, [bp+4]
  4134 000032FF 8A07                     mov al, [bx]
  4135 00003301 B400                     mov ah, 0
  4136 00003303 8846FE                   mov byte [bp-2], al
  4137                                  
  4138                                  ;-39         prc(c);
  4139                                  
  4140 00003306 8A46FE                   mov al, byte [bp-2]
  4141 00003309 B400                     mov ah, 0
  4142 0000330B 50                       push ax
  4143 0000330C E8A9FF                   call prc
  4144 0000330F 83C402                   add  sp, 2
  4145                                  
  4146                                  ;-40         s++;
  4147                                  
  4148 00003312 FF4604                   inc  word [bp+4]
  4149                                  
  4150                                  ;-41     }
  4151                                  
  4152                                  
  4153                                  ;-42 }
  4154                                  
  4155 00003315 EBD8                     jmp @@prscomment182
  4156                                  @@prscomment183:
  4157                                  
  4158                                  ;-43 int prs(unsigned char *s) {
  4159 00003317 C9                       LEAVE
  4160 00003318 C3                       ret
  4161                                  ; ENDP
  4162                                  
  4163                                  prs:  ; *** PROC ***
  4164                                  
  4165                                  ;-44     unsigned char c; 
  4166                                  
  4167                                  
  4168                                  ;-45     int com; 
  4169                                  
  4170                                  
  4171                                  ;-46     com=0;
  4172                                  
  4173                                  ;Function : prs, Number of local variables: 3
  4174                                  ;   # type sign width line used address name   list of local variables
  4175                                  ;  200 ptr unsg byte    43 NULL bp+4    s
  4176                                  ;  201 var unsg byte    44 NULL bp-2    c
  4177                                  ;  202 var sign word    45 NULL bp-4    com;
  4178 00003319 C8040000                 ENTER  4,0
  4179 0000331D 66B800000000             mov eax, 0
  4180 00003323 8946FC                   mov word [bp-4], ax
  4181                                  
  4182                                  ;-47     while (*s) { 
  4183                                  
  4184                                  @@prs184:
  4185 00003326 8B5E04                   mov bx, [bp+4]
  4186 00003329 8A07                     mov al, [bx]
  4187 0000332B B400                     mov ah, 0
  4188 0000332D 08C0                     or  al, al
  4189 0000332F 0F848700                 je @@prs185
  4190                                  
  4191                                  ;-48         c=*s; 
  4192                                  
  4193 00003333 8B5E04                   mov bx, [bp+4]
  4194 00003336 8A07                     mov al, [bx]
  4195 00003338 B400                     mov ah, 0
  4196 0000333A 8846FE                   mov byte [bp-2], al
  4197                                  
  4198                                  ;-49         if (c==34) {
  4199                                  
  4200 0000333D 8A46FE                   mov al, [bp-2]
  4201 00003340 3C22                     cmp al, 34
  4202 00003342 0F851E00                 jne @@prs186
  4203                                  
  4204                                  ;-50             if (com) com=0; 
  4205                                  
  4206 00003346 8B46FC                   mov ax, [bp-4]
  4207 00003349 08C0                     or  al, al
  4208 0000334B 0F840C00                 je @@prs187
  4209 0000334F 66B800000000             mov eax, 0
  4210 00003355 8946FC                   mov word [bp-4], ax
  4211                                  
  4212                                  ;-51                 else com=1;  
  4213                                  
  4214 00003358 E90900                   jmp @@prs188
  4215                                  @@prs187:
  4216 0000335B 66B801000000             mov eax, 1
  4217 00003361 8946FC                   mov word [bp-4], ax
  4218                                  
  4219                                  ;-52         }
  4220                                  
  4221                                  @@prs188:
  4222                                  
  4223                                  ;-53         if (c==92) { 
  4224                                  
  4225                                  @@prs186:
  4226 00003364 8A46FE                   mov al, [bp-2]
  4227 00003367 3C5C                     cmp al, 92
  4228 00003369 0F853B00                 jne @@prs189
  4229                                  
  4230                                  ;-54             if (com==0) { 
  4231                                  
  4232 0000336D 8B46FC                   mov ax, [bp-4]
  4233 00003370 83F800                   cmp ax, 0
  4234 00003373 0F853100                 jne @@prs190
  4235                                  
  4236                                  ;-55                 s++; 
  4237                                  
  4238 00003377 FF4604                   inc  word [bp+4]
  4239                                  
  4240                                  ;-56                 c=*s;
  4241                                  
  4242 0000337A 8B5E04                   mov bx, [bp+4]
  4243 0000337D 8A07                     mov al, [bx]
  4244 0000337F B400                     mov ah, 0
  4245 00003381 8846FE                   mov byte [bp-2], al
  4246                                  
  4247                                  ;-57                 if (c=='n') c=10; 
  4248                                  
  4249 00003384 8A46FE                   mov al, [bp-2]
  4250 00003387 3C6E                     cmp al, 110
  4251 00003389 0F850900                 jne @@prs191
  4252 0000338D 66B80A000000             mov eax, 10
  4253 00003393 8846FE                   mov byte [bp-2], al
  4254                                  
  4255                                  ;-58                 if (c=='t') c= 9; 
  4256                                  
  4257                                  @@prs191:
  4258 00003396 8A46FE                   mov al, [bp-2]
  4259 00003399 3C74                     cmp al, 116
  4260 0000339B 0F850900                 jne @@prs192
  4261 0000339F 66B809000000             mov eax, 9
  4262 000033A5 8846FE                   mov byte [bp-2], al
  4263                                  
  4264                                  ;-59             } 
  4265                                  
  4266                                  @@prs192:
  4267                                  
  4268                                  ;-60         } 
  4269                                  
  4270                                  @@prs190:
  4271                                  
  4272                                  ;-61         prc(c); 
  4273                                  
  4274                                  @@prs189:
  4275 000033A8 8A46FE                   mov al, byte [bp-2]
  4276 000033AB B400                     mov ah, 0
  4277 000033AD 50                       push ax
  4278 000033AE E807FF                   call prc
  4279 000033B1 83C402                   add  sp, 2
  4280                                  
  4281                                  ;-62         s++;  
  4282                                  
  4283 000033B4 FF4604                   inc  word [bp+4]
  4284                                  
  4285                                  ;-63     }
  4286                                  
  4287                                  
  4288                                  ;-64 }
  4289                                  
  4290 000033B7 E96CFF                   jmp @@prs184
  4291                                  @@prs185:
  4292                                  
  4293                                  ;-65 int printhex8a(unsigned char c) { 
  4294 000033BA C9                       LEAVE
  4295 000033BB C3                       ret
  4296                                  ; ENDP
  4297                                  
  4298                                  printhex8a:  ; *** PROC ***
  4299                                  
  4300                                  ;-66     unsigned char nib;
  4301                                  
  4302                                  
  4303                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4304                                  
  4305                                  ;Function : printhex8a, Number of local variables: 2
  4306                                  ;   # type sign width line used address name   list of local variables
  4307                                  ;  200 var unsg byte    65 NULL bp+4    c
  4308                                  ;  201 var unsg byte    66 NULL bp-2    nib;
  4309 000033BC C8020000                 ENTER  2,0
  4310 000033C0 8A4604                   mov al, [bp+4]
  4311 000033C3 C0E804                   shr al, 4
  4312 000033C6 8846FE                   mov byte [bp-2], al
  4313 000033C9 8A46FE                   mov al, byte [bp-2]
  4314 000033CC B400                     mov ah, 0
  4315 000033CE 50                       push ax
  4316 000033CF E81900                   call printhex4
  4317 000033D2 83C402                   add  sp, 2
  4318                                  
  4319                                  ;-68     nib = c & 15; printhex4(nib);                    
  4320                                  
  4321 000033D5 8A4604                   mov al, [bp+4]
  4322 000033D8 240F                     and al, 15
  4323 000033DA 8846FE                   mov byte [bp-2], al
  4324 000033DD 8A46FE                   mov al, byte [bp-2]
  4325 000033E0 B400                     mov ah, 0
  4326 000033E2 50                       push ax
  4327 000033E3 E80500                   call printhex4
  4328 000033E6 83C402                   add  sp, 2
  4329                                  
  4330                                  ;-69 } 
  4331                                  
  4332                                  
  4333                                  ;-70 int printhex4(unsigned char c) {
  4334 000033E9 C9                       LEAVE
  4335 000033EA C3                       ret
  4336                                  ; ENDP
  4337                                  
  4338                                  printhex4:  ; *** PROC ***
  4339                                  
  4340                                  ;-71     c += 48; 
  4341                                  
  4342                                  ;Function : printhex4, Number of local variables: 1
  4343                                  ;   # type sign width line used address name   list of local variables
  4344                                  ;  200 var unsg byte    70 NULL bp+4    c;
  4345 000033EB C8000000                 ENTER  0,0
  4346 000033EF 80460430                 add  byte [bp+4], 48
  4347                                  
  4348                                  ;-72     if (c > 57) c += 7; 
  4349                                  
  4350 000033F3 8A4604                   mov al, [bp+4]
  4351 000033F6 3C39                     cmp al, 57
  4352 000033F8 0F8E0400                 jle @@printhex4193
  4353 000033FC 80460407                 add  byte [bp+4], 7
  4354                                  
  4355                                  ;-73     prc(c);      
  4356                                  
  4357                                  @@printhex4193:
  4358 00003400 8A4604                   mov al, byte [bp+4]
  4359 00003403 B400                     mov ah, 0
  4360 00003405 50                       push ax
  4361 00003406 E8AFFE                   call prc
  4362 00003409 83C402                   add  sp, 2
  4363                                  
  4364                                  ;-74 }
  4365                                  
  4366                                  
  4367                                  ;-75 int printhex16(unsigned int i) {
  4368 0000340C C9                       LEAVE
  4369 0000340D C3                       ret
  4370                                  ; ENDP
  4371                                  
  4372                                  printhex16:  ; *** PROC ***
  4373                                  
  4374                                  ;-76     unsigned int half;
  4375                                  
  4376                                  
  4377                                  ;-77     half = i >>  8; printhex8a(half); 
  4378                                  
  4379                                  ;Function : printhex16, Number of local variables: 2
  4380                                  ;   # type sign width line used address name   list of local variables
  4381                                  ;  200 var unsg word    75 NULL bp+4    i
  4382                                  ;  201 var unsg word    76 NULL bp-2    half;
  4383 0000340E C8020000                 ENTER  2,0
  4384 00003412 8B4604                   mov ax, [bp+4]
  4385 00003415 C1E808                   shr ax, 8
  4386 00003418 8946FE                   mov word [bp-2], ax
  4387 0000341B FF76FE                   push word [bp-2]
  4388 0000341E E89BFF                   call printhex8a
  4389 00003421 83C402                   add  sp, 2
  4390                                  
  4391                                  ;-78     half = i & 255; printhex8a(half);
  4392                                  
  4393 00003424 8B4604                   mov ax, [bp+4]
  4394 00003427 25FF00                   and ax, 255
  4395 0000342A 8946FE                   mov word [bp-2], ax
  4396 0000342D FF76FE                   push word [bp-2]
  4397 00003430 E889FF                   call printhex8a
  4398 00003433 83C402                   add  sp, 2
  4399                                  
  4400                                  ;-79 }
  4401                                  
  4402                                  
  4403                                  ;-80 int printIntU(unsigned int n) { 
  4404 00003436 C9                       LEAVE
  4405 00003437 C3                       ret
  4406                                  ; ENDP
  4407                                  
  4408                                  printIntU:  ; *** PROC ***
  4409                                  
  4410                                  ;-81     unsigned int e;
  4411                                  
  4412                                  
  4413                                  ;-82     if ( _ n >= 10) {  
  4414                                  
  4415                                  ;Function : printIntU, Number of local variables: 2
  4416                                  ;   # type sign width line used address name   list of local variables
  4417                                  ;  200 var unsg word    80 NULL bp+4    n
  4418                                  ;  201 var unsg word    81 NULL bp-2    e;
  4419 00003438 C8020000                 ENTER  2,0
  4420 0000343C 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4421 00003440 0F821700                 jb  @@printIntU194
  4422                                  
  4423                                  ;-83         e=n/10; //DIV
  4424                                  
  4425 00003444 8B4604                   mov ax, [bp+4]
  4426 00003447 BB0A00                   mov bx, 10
  4427 0000344A BA0000                   mov dx, 0
  4428 0000344D F7F3                     div bx
  4429 0000344F 8946FE                   mov word [bp-2], ax
  4430                                  
  4431                                  ;-84         printIntU(e); 
  4432                                  
  4433 00003452 FF76FE                   push word [bp-2]
  4434 00003455 E8E0FF                   call printIntU
  4435 00003458 83C402                   add  sp, 2
  4436                                  
  4437                                  ;-85     }
  4438                                  
  4439                                  
  4440                                  ;-86     n = n % 10; //unsigned mod
  4441                                  
  4442                                  @@printIntU194:
  4443 0000345B 8B4604                   mov ax, [bp+4]
  4444 0000345E BB0A00                   mov bx, 10
  4445 00003461 BA0000                   mov dx, 0
  4446 00003464 F7F3                     div bx
  4447 00003466 89D0                     mov ax, dx
  4448 00003468 894604                   mov word [bp+4], ax
  4449                                  
  4450                                  ;-87     n += '0'; 
  4451                                  
  4452 0000346B 83460430                 add  word [bp+4], 48
  4453                                  
  4454                                  ;-88     prc(n);
  4455                                  
  4456 0000346F FF7604                   push word [bp+4]
  4457 00003472 E843FE                   call prc
  4458 00003475 83C402                   add  sp, 2
  4459                                  
  4460                                  ;-89 }
  4461                                  
  4462                                  
  4463                                  ;-90 
  4464                                  
  4465                                  
  4466                                  ;-91 int error1(char *s) { 
  4467 00003478 C9                       LEAVE
  4468 00003479 C3                       ret
  4469                                  ; ENDP
  4470                                  
  4471                                  error1:  ; *** PROC ***
  4472                                  
  4473                                  ;-92     LIST=1; 
  4474                                  
  4475                                  ;Function : error1, Number of local variables: 1
  4476                                  ;   # type sign width line used address name   list of local variables
  4477                                  ;  200 ptr sign byte    91 NULL bp+4    s;
  4478 0000347A C8000000                 ENTER  0,0
  4479 0000347E 66B801000000             mov eax, 1
  4480 00003484 A2[0E00]                 mov byte [LIST], al
  4481                                  
  4482                                  ;-93     ErrorCount++;
  4483                                  
  4484 00003487 FF06[A101]               inc  word [ErrorCount]
  4485                                  
  4486                                  ;-94     prs("\n;***** next line ERROR: "); 
  4487                                  
  4488 0000348B 68[B334]                 push error1_0
  4489 0000348E E888FE                   call prs
  4490 00003491 83C402                   add  sp, 2
  4491                                  
  4492                                  ;-95     prs(s);
  4493                                  
  4494 00003494 FF7604                   push word [bp+4]
  4495 00003497 E87FFE                   call prs
  4496 0000349A 83C402                   add  sp, 2
  4497                                  
  4498                                  ;-96     prs(", Symbol: "); 
  4499                                  
  4500 0000349D 68[CE34]                 push error1_1
  4501 000034A0 E876FE                   call prs
  4502 000034A3 83C402                   add  sp, 2
  4503                                  
  4504                                  ;-97     prs(Symbol);
  4505                                  
  4506 000034A6 8D06[0F00]               lea  ax, [Symbol]
  4507 000034AA 50                       push ax
  4508 000034AB E86BFE                   call prs
  4509 000034AE 83C402                   add  sp, 2
  4510                                  
  4511                                  ;-98 }
  4512                                  
  4513                                  
  4514                                  ;-99 int errorexit(char *s) { 
  4515 000034B1 C9                       LEAVE
  4516 000034B2 C3                       ret
  4517                                  ; ENDP
  4518 000034B3 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4519 000034BC 6E657874206C696E65-
  4520 000034C5 204552524F523A2000 
  4521 000034CE 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4522 000034D7 2000               
  4523                                  
  4524                                  errorexit:  ; *** PROC ***
  4525                                  
  4526                                  ;-100     error1(s); 
  4527                                  
  4528                                  ;Function : errorexit, Number of local variables: 1
  4529                                  ;   # type sign width line used address name   list of local variables
  4530                                  ;  200 ptr sign byte    99 NULL bp+4    s;
  4531 000034D9 C8000000                 ENTER  0,0
  4532 000034DD FF7604                   push word [bp+4]
  4533 000034E0 E897FF                   call error1
  4534 000034E3 83C402                   add  sp, 2
  4535                                  
  4536                                  ;-101     end1(1);
  4537                                  
  4538 000034E6 6A01                     push 1
  4539 000034E8 E8D006                   call end1
  4540 000034EB 83C402                   add  sp, 2
  4541                                  
  4542                                  ;-102 }
  4543                                  
  4544                                  
  4545                                  ;-103 int allowederror() {error1("not allowed here"); }
  4546 000034EE C9                       LEAVE
  4547 000034EF C3                       ret
  4548                                  ; ENDP
  4549                                  
  4550                                  allowederror:  ; *** PROC ***
  4551 000034F0 68[FA34]                 push allowederror_0
  4552 000034F3 E884FF                   call error1
  4553 000034F6 83C402                   add  sp, 2
  4554                                  
  4555                                  ;-104 int addrerror()    {error1("address missing");} 
  4556                                  
  4557 000034F9 C3                       ret
  4558                                  ; ENDP
  4559 000034FA 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4560 00003503 6564206865726500   
  4561                                  
  4562                                  addrerror:  ; *** PROC ***
  4563 0000350B 68[1535]                 push addrerror_0
  4564 0000350E E869FF                   call error1
  4565 00003511 83C402                   add  sp, 2
  4566                                  
  4567                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4568                                  
  4569 00003514 C3                       ret
  4570                                  ; ENDP
  4571 00003515 61646472657373206D-     addrerror_0 db "address missing",0
  4572 0000351E 697373696E6700     
  4573                                  
  4574                                  immeerror:  ; *** PROC ***
  4575 00003525 68[2F35]                 push immeerror_0
  4576 00003528 E84FFF                   call error1
  4577 0000352B 83C402                   add  sp, 2
  4578                                  
  4579                                  ;-106 int implerror()    {error1("not implemented");}
  4580                                  
  4581 0000352E C3                       ret
  4582                                  ; ENDP
  4583 0000352F 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4584 00003538 206E6F7420616C6C6F-
  4585 00003541 776564206865726500 
  4586                                  
  4587                                  implerror:  ; *** PROC ***
  4588 0000354A 68[5435]                 push implerror_0
  4589 0000354D E82AFF                   call error1
  4590 00003550 83C402                   add  sp, 2
  4591                                  
  4592                                  ;-107 int indexerror()   {error1("invalid index register");}
  4593                                  
  4594 00003553 C3                       ret
  4595                                  ; ENDP
  4596 00003554 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4597 0000355D 6D656E74656400     
  4598                                  
  4599                                  indexerror:  ; *** PROC ***
  4600 00003564 68[6E35]                 push indexerror_0
  4601 00003567 E810FF                   call error1
  4602 0000356A 83C402                   add  sp, 2
  4603                                  
  4604                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4605                                  
  4606 0000356D C3                       ret
  4607                                  ; ENDP
  4608 0000356E 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4609 00003577 6E6465782072656769-
  4610 00003580 7374657200         
  4611                                  
  4612                                  invaloperror:  ; *** PROC ***
  4613 00003585 68[8F35]                 push invaloperror_0
  4614 00003588 E8EFFE                   call error1
  4615 0000358B 83C402                   add  sp, 2
  4616                                  
  4617                                  ;-109 int numbererror()  {error1("number expected");}
  4618                                  
  4619 0000358E C3                       ret
  4620                                  ; ENDP
  4621 0000358F 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4622 00003598 72206E6F206F706572-
  4623 000035A1 616E647300         
  4624                                  
  4625                                  numbererror:  ; *** PROC ***
  4626 000035A6 68[B035]                 push numbererror_0
  4627 000035A9 E8CEFE                   call error1
  4628 000035AC 83C402                   add  sp, 2
  4629                                  
  4630                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4631                                  
  4632 000035AF C3                       ret
  4633                                  ; ENDP
  4634 000035B0 6E756D626572206578-     numbererror_0 db "number expected",0
  4635 000035B9 70656374656400     
  4636                                  
  4637                                  regmemerror:  ; *** PROC ***
  4638 000035C0 68[CA35]                 push regmemerror_0
  4639 000035C3 E8B4FE                   call error1
  4640 000035C6 83C402                   add  sp, 2
  4641                                  
  4642                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4643                                  
  4644 000035C9 C3                       ret
  4645                                  ; ENDP
  4646 000035CA 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4647 000035D3 73746572206F72206D-
  4648 000035DC 656D6F727920616C6C-
  4649 000035E5 6F77656400         
  4650                                  
  4651                                  reg16error:  ; *** PROC ***
  4652 000035EA 68[F435]                 push reg16error_0
  4653 000035ED E88AFE                   call error1
  4654 000035F0 83C402                   add  sp, 2
  4655                                  
  4656                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4657                                  
  4658 000035F3 C3                       ret
  4659                                  ; ENDP
  4660 000035F4 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4661 000035FD 362C206E6F20736567-
  4662 00003606 72656720616C6C6F77-
  4663 0000360F 656400             
  4664                                  
  4665                                  segregerror:  ; *** PROC ***
  4666 00003612 68[1C36]                 push segregerror_0
  4667 00003615 E862FE                   call error1
  4668 00003618 83C402                   add  sp, 2
  4669                                  
  4670                                  ;-113 int syntaxerror()  {error1("syntax");}
  4671                                  
  4672 0000361B C3                       ret
  4673                                  ; ENDP
  4674 0000361C 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4675 00003625 65676973746572206E-
  4676 0000362E 6F7420616C6C6F7765-
  4677 00003637 6400               
  4678                                  
  4679                                  syntaxerror:  ; *** PROC ***
  4680 00003639 68[4336]                 push syntaxerror_0
  4681 0000363C E83BFE                   call error1
  4682 0000363F 83C402                   add  sp, 2
  4683                                  
  4684                                  ;-114          
  4685                                  
  4686                                  
  4687                                  ;-115 int addrexit()     {errorexit("illegal address");}
  4688                                  
  4689 00003642 C3                       ret
  4690                                  ; ENDP
  4691 00003643 73796E74617800          syntaxerror_0 db "syntax",0
  4692                                  
  4693                                  addrexit:  ; *** PROC ***
  4694 0000364A 68[5436]                 push addrexit_0
  4695 0000364D E889FE                   call errorexit
  4696 00003650 83C402                   add  sp, 2
  4697                                  
  4698                                  ;-116 int internexit()   {errorexit("intern compiler error");}
  4699                                  
  4700 00003653 C3                       ret
  4701                                  ; ENDP
  4702 00003654 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4703 0000365D 64647265737300     
  4704                                  
  4705                                  internexit:  ; *** PROC ***
  4706 00003664 68[6E36]                 push internexit_0
  4707 00003667 E86FFE                   call errorexit
  4708 0000366A 83C402                   add  sp, 2
  4709 0000366D C3                       ret
  4710                                  ; ENDP
  4711 0000366E 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4712 00003677 6D70696C6572206572-
  4713 00003680 726F7200           
  4714                                  ;Back to main program: AS.C
  4715                                  
  4716                                  ;-8 #include "MAIN.C"
  4717                                  
  4718                                  ;Use include file: MAIN.C
  4719                                  
  4720                                  ;-1 int main() {
  4721                                  
  4722                                  
  4723                                  main:  ; *** PROC ***
  4724                                  
  4725                                  ;-2     getarg(); 
  4726                                  
  4727 00003684 E80D00                   call getarg
  4728                                  
  4729                                  ;-3     parse(); 
  4730                                  
  4731 00003687 E829EE                   call parse
  4732                                  
  4733                                  ;-4     fixJmpCall();
  4734                                  
  4735 0000368A E85F02                   call fixJmpCall
  4736                                  
  4737                                  ;-5     epilog(); 
  4738                                  
  4739 0000368D E8C103                   call epilog
  4740                                  
  4741                                  ;-6     end1();
  4742                                  
  4743 00003690 E82805                   call end1
  4744                                  
  4745                                  ;-7 }
  4746                                  
  4747                                  
  4748                                  ;-8 
  4749                                  
  4750                                  
  4751                                  ;-9 int getarg() { 
  4752                                  
  4753 00003693 C3                       ret
  4754                                  ; ENDP
  4755                                  
  4756                                  getarg:  ; *** PROC ***
  4757                                  
  4758                                  ;-10     int arglen1; int i; char *c;
  4759                                  
  4760                                  
  4761                                  ;-11     arglen1=*arglen;
  4762                                  
  4763                                  ;Function : getarg, Number of local variables: 3
  4764                                  ;   # type sign width line used address name   list of local variables
  4765                                  ;  200 var sign word    10 NULL bp-2    arglen1
  4766                                  ;  201 var sign word    10 NULL bp-4    i
  4767                                  ;  202 ptr sign byte    10 NULL bp-6    c;
  4768 00003694 C8060000                 ENTER  6,0
  4769 00003698 8B1E[041C]               mov bx, [arglen]
  4770 0000369C 8A07                     mov al, [bx]
  4771 0000369E B400                     mov ah, 0
  4772 000036A0 8946FE                   mov word [bp-2], ax
  4773                                  
  4774                                  ;-12     if (arglen1==0) {
  4775                                  
  4776 000036A3 8B46FE                   mov ax, [bp-2]
  4777 000036A6 83F800                   cmp ax, 0
  4778 000036A9 0F851C00                 jne @@getarg195
  4779                                  
  4780                                  ;-13         cputs(Version1);
  4781                                  
  4782 000036AD 8D06[0300]               lea  ax, [Version1]
  4783 000036B1 50                       push ax
  4784 000036B2 E8090E                   call cputs
  4785 000036B5 83C402                   add  sp, 2
  4786                                  
  4787                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4788                                  
  4789 000036B8 68[5938]                 push getarg_0
  4790 000036BB E8000E                   call cputs
  4791 000036BE 83C402                   add  sp, 2
  4792                                  
  4793                                  ;-15         exitR(3);
  4794                                  
  4795 000036C1 6A03                     push 3
  4796 000036C3 E8D30F                   call exitR
  4797 000036C6 83C402                   add  sp, 2
  4798                                  
  4799                                  ;-16     }
  4800                                  
  4801                                  
  4802                                  ;-17     i=arglen1+129; 
  4803                                  
  4804                                  @@getarg195:
  4805 000036C9 8B46FE                   mov ax, [bp-2]
  4806 000036CC 058100                   add ax, 129
  4807 000036CF 8946FC                   mov word [bp-4], ax
  4808                                  
  4809                                  ;-18     *i=0;  
  4810                                  
  4811 000036D2 66B800000000             mov eax, 0
  4812 000036D8 8B5EFC                   mov  bx, [bp-4]
  4813 000036DB 8907                     mov  [bx], ax
  4814                                  
  4815                                  ;-19     arglen1--;
  4816                                  
  4817 000036DD FF4EFE                   dec  word [bp-2]
  4818                                  
  4819                                  ;-20     toupper(argv);
  4820                                  
  4821 000036E0 FF36[061C]               push word [argv]
  4822 000036E4 E8050E                   call toupper
  4823 000036E7 83C402                   add  sp, 2
  4824                                  
  4825                                  ;-21   
  4826                                  
  4827                                  
  4828                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  4829                                  
  4830 000036EA FF36[061C]               push word [argv]
  4831 000036EE 8D06[D000]               lea  ax, [namein]
  4832 000036F2 50                       push ax
  4833 000036F3 E8640E                   call strcpy
  4834 000036F6 83C404                   add  sp, 4
  4835 000036F9 68[7E38]                 push getarg_1
  4836 000036FC 8D06[D000]               lea  ax, [namein]
  4837 00003700 50                       push ax
  4838 00003701 E8170F                   call strcat1
  4839 00003704 83C404                   add  sp, 4
  4840                                  
  4841                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  4842                                  
  4843 00003707 FF36[061C]               push word [argv]
  4844 0000370B 8D06[1301]               lea  ax, [namelst]
  4845 0000370F 50                       push ax
  4846 00003710 E8470E                   call strcpy
  4847 00003713 83C404                   add  sp, 4
  4848 00003716 68[8138]                 push getarg_2
  4849 00003719 8D06[1301]               lea  ax, [namelst]
  4850 0000371D 50                       push ax
  4851 0000371E E8FA0E                   call strcat1
  4852 00003721 83C404                   add  sp, 4
  4853                                  
  4854                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  4855                                  
  4856 00003724 FF36[061C]               push word [argv]
  4857 00003728 8D06[5601]               lea  ax, [namebin]
  4858 0000372C 50                       push ax
  4859 0000372D E82A0E                   call strcpy
  4860 00003730 83C404                   add  sp, 4
  4861 00003733 68[8638]                 push getarg_3
  4862 00003736 8D06[5601]               lea  ax, [namebin]
  4863 0000373A 50                       push ax
  4864 0000373B E8DD0E                   call strcat1
  4865 0000373E 83C404                   add  sp, 4
  4866                                  
  4867                                  ;-25 
  4868                                  
  4869                                  
  4870                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4871                                  
  4872 00003741 66B801000000             mov eax, 1
  4873 00003747 A2[0E00]                 mov byte [LIST], al
  4874 0000374A 66B800000000             mov eax, 0
  4875 00003750 A3[9F01]                 mov word [DOS_ERR], ax
  4876 00003753 66B800000000             mov eax, 0
  4877 00003759 A3[A601]                 mov word [PC], ax
  4878 0000375C 66B800000000             mov eax, 0
  4879 00003762 A3[A101]                 mov word [ErrorCount], ax
  4880                                  
  4881                                  ;-27   
  4882                                  
  4883                                  
  4884                                  ;-28     asm_fd=openR (namein);
  4885                                  
  4886 00003765 8D06[D000]               lea  ax, [namein]
  4887 00003769 50                       push ax
  4888 0000376A E8D30E                   call openR
  4889 0000376D 83C402                   add  sp, 2
  4890 00003770 A3[9901]                 mov word [asm_fd], ax
  4891                                  
  4892                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4893                                  
  4894 00003773 A1[9F01]                 mov ax, [DOS_ERR]
  4895 00003776 08C0                     or  al, al
  4896 00003778 0F841C00                 je @@getarg196
  4897 0000377C 68[8B38]                 push getarg_4
  4898 0000377F E83C0D                   call cputs
  4899 00003782 83C402                   add  sp, 2
  4900 00003785 8D06[D000]               lea  ax, [namein]
  4901 00003789 50                       push ax
  4902 0000378A E8310D                   call cputs
  4903 0000378D 83C402                   add  sp, 2
  4904 00003790 6A01                     push 1
  4905 00003792 E8040F                   call exitR
  4906 00003795 83C402                   add  sp, 2
  4907                                  
  4908                                  ;-30     lst_fd=creatR(namelst);
  4909                                  
  4910                                  @@getarg196:
  4911 00003798 8D06[1301]               lea  ax, [namelst]
  4912 0000379C 50                       push ax
  4913 0000379D E8AF0E                   call creatR
  4914 000037A0 83C402                   add  sp, 2
  4915 000037A3 A3[9B01]                 mov word [lst_fd], ax
  4916                                  
  4917                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4918                                  
  4919 000037A6 A1[9F01]                 mov ax, [DOS_ERR]
  4920 000037A9 08C0                     or  al, al
  4921 000037AB 0F841C00                 je @@getarg197
  4922 000037AF 68[A138]                 push getarg_5
  4923 000037B2 E8090D                   call cputs
  4924 000037B5 83C402                   add  sp, 2
  4925 000037B8 8D06[1301]               lea  ax, [namelst]
  4926 000037BC 50                       push ax
  4927 000037BD E8FE0C                   call cputs
  4928 000037C0 83C402                   add  sp, 2
  4929 000037C3 6A02                     push 2
  4930 000037C5 E8D10E                   call exitR
  4931 000037C8 83C402                   add  sp, 2
  4932                                  
  4933                                  ;-32     bin_fd=creatR(namebin);
  4934                                  
  4935                                  @@getarg197:
  4936 000037CB 8D06[5601]               lea  ax, [namebin]
  4937 000037CF 50                       push ax
  4938 000037D0 E87C0E                   call creatR
  4939 000037D3 83C402                   add  sp, 2
  4940 000037D6 A3[9D01]                 mov word [bin_fd], ax
  4941                                  
  4942                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4943                                  
  4944 000037D9 A1[9F01]                 mov ax, [DOS_ERR]
  4945 000037DC 08C0                     or  al, al
  4946 000037DE 0F841C00                 je @@getarg198
  4947 000037E2 68[B838]                 push getarg_6
  4948 000037E5 E8D60C                   call cputs
  4949 000037E8 83C402                   add  sp, 2
  4950 000037EB 8D06[5601]               lea  ax, [namebin]
  4951 000037EF 50                       push ax
  4952 000037F0 E8CB0C                   call cputs
  4953 000037F3 83C402                   add  sp, 2
  4954 000037F6 6A02                     push 2
  4955 000037F8 E89E0E                   call exitR
  4956 000037FB 83C402                   add  sp, 2
  4957                                  
  4958                                  ;-34   
  4959                                  
  4960                                  
  4961                                  ;-35     prs(";"); 
  4962                                  
  4963                                  @@getarg198:
  4964 000037FE 68[CE38]                 push getarg_7
  4965 00003801 E815FB                   call prs
  4966 00003804 83C402                   add  sp, 2
  4967                                  
  4968                                  ;-36     prs(Version1);
  4969                                  
  4970 00003807 8D06[0300]               lea  ax, [Version1]
  4971 0000380B 50                       push ax
  4972 0000380C E80AFB                   call prs
  4973 0000380F 83C402                   add  sp, 2
  4974                                  
  4975                                  ;-37     prs(", Source: "); prs(namein);  
  4976                                  
  4977 00003812 68[D038]                 push getarg_8
  4978 00003815 E801FB                   call prs
  4979 00003818 83C402                   add  sp, 2
  4980 0000381B 8D06[D000]               lea  ax, [namein]
  4981 0000381F 50                       push ax
  4982 00003820 E8F6FA                   call prs
  4983 00003823 83C402                   add  sp, 2
  4984                                  
  4985                                  ;-38     prs(", Output: "); prs(namelst);
  4986                                  
  4987 00003826 68[DB38]                 push getarg_9
  4988 00003829 E8EDFA                   call prs
  4989 0000382C 83C402                   add  sp, 2
  4990 0000382F 8D06[1301]               lea  ax, [namelst]
  4991 00003833 50                       push ax
  4992 00003834 E8E2FA                   call prs
  4993 00003837 83C402                   add  sp, 2
  4994                                  
  4995                                  ;-39     prs(", "); prs(namebin);
  4996                                  
  4997 0000383A 68[E638]                 push getarg_10
  4998 0000383D E8D9FA                   call prs
  4999 00003840 83C402                   add  sp, 2
  5000 00003843 8D06[5601]               lea  ax, [namebin]
  5001 00003847 50                       push ax
  5002 00003848 E8CEFA                   call prs
  5003 0000384B 83C402                   add  sp, 2
  5004                                  
  5005                                  ;-40     prs("\n");
  5006                                  
  5007 0000384E 68[E938]                 push getarg_11
  5008 00003851 E8C5FA                   call prs
  5009 00003854 83C402                   add  sp, 2
  5010                                  
  5011                                  ;-41 }
  5012                                  
  5013                                  
  5014                                  ;-42 
  5015                                  
  5016                                  
  5017                                  ;-43 int fixJmpCall() {
  5018 00003857 C9                       LEAVE
  5019 00003858 C3                       ret
  5020                                  ; ENDP
  5021 00003859 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5022 00003862 41532E434F4D206669-
  5023 0000386B 6C656E616D65205B77-
  5024 00003874 2F6F202E535D203A20-
  5025 0000387D 00                 
  5026 0000387E 2E5300                  getarg_1 db ".S",0
  5027 00003881 2E4C535400              getarg_2 db ".LST",0
  5028 00003886 2E434F4D00              getarg_3 db ".COM",0
  5029 0000388B 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5030 00003894 6C65206D697373696E-
  5031 0000389D 673A2000           
  5032 000038A1 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5033 000038AA 206E6F742063726561-
  5034 000038B3 74653A2000         
  5035 000038B8 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5036 000038C1 6E6F74206372656174-
  5037 000038CA 653A2000           
  5038 000038CE 3B00                    getarg_7 db ";",0
  5039 000038D0 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5040 000038D9 2000               
  5041 000038DB 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5042 000038E4 2000               
  5043 000038E6 2C2000                  getarg_10 db ", ",0
  5044 000038E9 5C6E00                  getarg_11 db "\n",0
  5045                                  
  5046                                  fixJmpCall:  ; *** PROC ***
  5047                                  
  5048                                  ;-44     int i;  unsigned int hex;  char *p; int Ix; char c;
  5049                                  
  5050                                  
  5051                                  ;-45     i=1;     
  5052                                  
  5053                                  ;Function : fixJmpCall, Number of local variables: 5
  5054                                  ;   # type sign width line used address name   list of local variables
  5055                                  ;  200 var sign word    44 NULL bp-2    i
  5056                                  ;  201 var unsg word    44 NULL bp-4    hex
  5057                                  ;  202 ptr sign byte    44 NULL bp-6    p
  5058                                  ;  203 var sign word    44 NULL bp-8    Ix
  5059                                  ;  204 var sign byte    44 NULL bp-10    c;
  5060 000038EC C80A0000                 ENTER  10,0
  5061 000038F0 66B801000000             mov eax, 1
  5062 000038F6 8946FE                   mov word [bp-2], ax
  5063                                  
  5064                                  ;-46     prs("\n;END open jmp/call: "); 
  5065                                  
  5066 000038F9 68[013A]                 push fixJmpCall_0
  5067 000038FC E81AFA                   call prs
  5068 000038FF 83C402                   add  sp, 2
  5069                                  
  5070                                  ;-47     printIntU(JmpCallMaxIx);      
  5071                                  
  5072 00003902 FF36[3014]               push word [JmpCallMaxIx]
  5073 00003906 E82FFB                   call printIntU
  5074 00003909 83C402                   add  sp, 2
  5075                                  
  5076                                  ;-48     prs(". "); 
  5077                                  
  5078 0000390C 68[183A]                 push fixJmpCall_1
  5079 0000390F E807FA                   call prs
  5080 00003912 83C402                   add  sp, 2
  5081                                  
  5082                                  ;-49     p = &JmpCallNames;   
  5083                                  
  5084 00003915 B8[8206]                 mov ax, JmpCallNames
  5085 00003918 8946FA                   mov word [bp-6], ax
  5086                                  
  5087                                  ;-50     while (i <= JmpCallMaxIx) {
  5088                                  
  5089                                  @@fixJmpCall199:
  5090 0000391B 8B46FE                   mov ax, [bp-2]
  5091 0000391E 3B06[3014]               cmp ax, [JmpCallMaxIx]
  5092 00003922 0F8FD900                 jg  @@fixJmpCall200
  5093                                  
  5094                                  ;-51         strcpy(Symbol, p);
  5095                                  
  5096 00003926 FF76FA                   push word [bp-6]
  5097 00003929 8D06[0F00]               lea  ax, [Symbol]
  5098 0000392D 50                       push ax
  5099 0000392E E8290C                   call strcpy
  5100 00003931 83C404                   add  sp, 4
  5101                                  
  5102                                  ;-52         p = strlen(Symbol) + p;
  5103                                  
  5104 00003934 8D06[0F00]               lea  ax, [Symbol]
  5105 00003938 50                       push ax
  5106 00003939 E8F30B                   call strlen
  5107 0000393C 83C402                   add  sp, 2
  5108 0000393F 0346FA                   add ax, [bp-6]
  5109 00003942 8946FA                   mov word [bp-6], ax
  5110                                  
  5111                                  ;-53         p++;
  5112                                  
  5113 00003945 FF46FA                   inc  word [bp-6]
  5114                                  
  5115                                  ;-54         prs(Symbol);
  5116                                  
  5117 00003948 8D06[0F00]               lea  ax, [Symbol]
  5118 0000394C 50                       push ax
  5119 0000394D E8C9F9                   call prs
  5120 00003950 83C402                   add  sp, 2
  5121                                  
  5122                                  ;-55         prc(' ');  
  5123                                  
  5124 00003953 6A20                     push 32
  5125 00003955 E860F9                   call prc
  5126 00003958 83C402                   add  sp, 2
  5127                                  
  5128                                  ;-56         hex = JmpCallAddr[i];
  5129                                  
  5130 0000395B 8B5EFE                   mov bx, [bp-2]
  5131 0000395E D1E3                     shl bx, 1
  5132 00003960 8B87[540E]               mov ax, [JmpCallAddr + bx]
  5133 00003964 8946FC                   mov word [bp-4], ax
  5134                                  
  5135                                  ;-57         printhex16(hex);
  5136                                  
  5137 00003967 FF76FC                   push word [bp-4]
  5138 0000396A E8A1FA                   call printhex16
  5139 0000396D 83C402                   add  sp, 2
  5140                                  
  5141                                  ;-58 //        prs(" -> ");
  5142                                  
  5143                                  
  5144                                  ;-59             
  5145                                  
  5146                                  
  5147                                  ;-60         Ix=searchLabel();
  5148                                  
  5149 00003970 E821EE                   call searchLabel
  5150 00003973 8946F8                   mov word [bp-8], ax
  5151                                  
  5152                                  ;-61         if (Ix == 0) error1("Label not found");
  5153                                  
  5154 00003976 8B46F8                   mov ax, [bp-8]
  5155 00003979 83F800                   cmp ax, 0
  5156 0000397C 0F850900                 jne @@fixJmpCall201
  5157 00003980 68[1B3A]                 push fixJmpCall_2
  5158 00003983 E8F4FA                   call error1
  5159 00003986 83C402                   add  sp, 2
  5160                                  
  5161                                  ;-62         disp = LabelAddr[Ix];
  5162                                  
  5163                                  @@fixJmpCall201:
  5164 00003989 8B5EF8                   mov bx, [bp-8]
  5165 0000398C D1E3                     shl bx, 1
  5166 0000398E 8B87[B605]               mov ax, [LabelAddr + bx]
  5167 00003992 A3[BE01]                 mov word [disp], ax
  5168                                  
  5169                                  ;-63 //        printhex16(disp);
  5170                                  
  5171                                  
  5172                                  ;-64 //        prs("=");
  5173                                  
  5174                                  
  5175                                  ;-65         disp = disp - hex;
  5176                                  
  5177 00003995 A1[BE01]                 mov ax, [disp]
  5178 00003998 2B46FC                   sub ax, [bp-4]
  5179 0000399B A3[BE01]                 mov word [disp], ax
  5180                                  
  5181                                  ;-66         disp = disp - Origin;
  5182                                  
  5183 0000399E A1[BE01]                 mov ax, [disp]
  5184 000039A1 2B06[A801]               sub ax, [Origin]
  5185 000039A5 A3[BE01]                 mov word [disp], ax
  5186                                  
  5187                                  ;-67 //        printhex16(disp);
  5188                                  
  5189                                  
  5190                                  ;-68         prs(", ");    
  5191                                  
  5192 000039A8 68[2B3A]                 push fixJmpCall_3
  5193 000039AB E86BF9                   call prs
  5194 000039AE 83C402                   add  sp, 2
  5195                                  
  5196                                  ;-69         
  5197                                  
  5198                                  
  5199                                  ;-70         c = JmpCallRelAbs[i];
  5200                                  
  5201 000039B1 8B5EFE                   mov bx, [bp-2]
  5202 000039B4 8A87[3C12]               mov al, [JmpCallRelAbs + bx]
  5203 000039B8 8846F6                   mov byte [bp-10], al
  5204                                  
  5205                                  ;-71         if (c == 'R') {
  5206                                  
  5207 000039BB 8A46F6                   mov al, [bp-10]
  5208 000039BE 3C52                     cmp al, 82
  5209 000039C0 0F852C00                 jne @@fixJmpCall202
  5210                                  
  5211                                  ;-72             hex = hex - 2;//fix at start of word              
  5212                                  
  5213 000039C4 8B46FC                   mov ax, [bp-4]
  5214 000039C7 83E802                   sub ax, 2
  5215 000039CA 8946FC                   mov word [bp-4], ax
  5216                                  
  5217                                  ;-73 /*            prs(", hex:");
  5218                                  
  5219                                  
  5220                                  ;-74             printhex16(hex);
  5221                                  
  5222                                  
  5223                                  ;-75             prs(", disp:");
  5224                                  
  5225                                  
  5226                                  ;-76             printhex16(disp);
  5227                                  
  5228                                  
  5229                                  ;-77             prs(". ");           */            
  5230                                  
  5231                                  
  5232                                  ;-78             FileBin[hex] = disp;//fix low byte    
  5233                                  
  5234 000039CD A1[BE01]                 mov ax, [disp]
  5235 000039D0 8B5EFC                   mov bx, [bp-4]
  5236 000039D3 8887[3214]               mov [FileBin+bx], al
  5237                                  
  5238                                  ;-79             hex++;
  5239                                  
  5240 000039D7 FF46FC                   inc  word [bp-4]
  5241                                  
  5242                                  ;-80             disp = disp >> 8;
  5243                                  
  5244 000039DA A1[BE01]                 mov ax, [disp]
  5245 000039DD C1E808                   shr ax, 8
  5246 000039E0 A3[BE01]                 mov word [disp], ax
  5247                                  
  5248                                  ;-81             FileBin[hex] = disp;
  5249                                  
  5250 000039E3 A1[BE01]                 mov ax, [disp]
  5251 000039E6 8B5EFC                   mov bx, [bp-4]
  5252 000039E9 8887[3214]               mov [FileBin+bx], al
  5253                                  
  5254                                  ;-82         } else errorexit("Intern. JmpCallRelAbs[Ix] is not R");
  5255                                  
  5256 000039ED E90900                   jmp @@fixJmpCall203
  5257                                  @@fixJmpCall202:
  5258 000039F0 68[2E3A]                 push fixJmpCall_4
  5259 000039F3 E8E3FA                   call errorexit
  5260 000039F6 83C402                   add  sp, 2
  5261                                  
  5262                                  ;-83             
  5263                                  
  5264                                  
  5265                                  ;-84         i++;
  5266                                  
  5267                                  @@fixJmpCall203:
  5268 000039F9 FF46FE                   inc  word [bp-2]
  5269                                  
  5270                                  ;-85     }
  5271                                  
  5272                                  
  5273                                  ;-86 }
  5274                                  
  5275 000039FC E91CFF                   jmp @@fixJmpCall199
  5276                                  @@fixJmpCall200:
  5277                                  
  5278                                  ;-87 
  5279                                  
  5280                                  
  5281                                  ;-88 int epilog() { 
  5282 000039FF C9                       LEAVE
  5283 00003A00 C3                       ret
  5284                                  ; ENDP
  5285 00003A01 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5286 00003A0A 656E206A6D702F6361-
  5287 00003A13 6C6C3A2000         
  5288 00003A18 2E2000                  fixJmpCall_1 db ". ",0
  5289 00003A1B 4C6162656C206E6F74-     fixJmpCall_2 db "Label not found",0
  5290 00003A24 20666F756E6400     
  5291 00003A2B 2C2000                  fixJmpCall_3 db ", ",0
  5292 00003A2E 496E7465726E2E204A-     fixJmpCall_4 db "Intern. JmpCallRelAbs[Ix] is not R",0
  5293 00003A37 6D7043616C6C52656C-
  5294 00003A40 4162735B49785D2069-
  5295 00003A49 73206E6F74205200   
  5296                                  
  5297                                  epilog:  ; *** PROC ***
  5298                                  
  5299                                  ;-89     unsigned int i; char c;     int j;
  5300                                  
  5301                                  
  5302                                  ;-90     prs("\nErrors: "); 
  5303                                  
  5304                                  ;Function : epilog, Number of local variables: 3
  5305                                  ;   # type sign width line used address name   list of local variables
  5306                                  ;  200 var unsg word    89 NULL bp-2    i
  5307                                  ;  201 var sign byte    89 NULL bp-4    c
  5308                                  ;  202 var sign word    89 NULL bp-6    j;
  5309 00003A51 C8060000                 ENTER  6,0
  5310 00003A55 68[783B]                 push epilog_0
  5311 00003A58 E8BEF8                   call prs
  5312 00003A5B 83C402                   add  sp, 2
  5313                                  
  5314                                  ;-91     printIntU(ErrorCount);
  5315                                  
  5316 00003A5E FF36[A101]               push word [ErrorCount]
  5317 00003A62 E8D3F9                   call printIntU
  5318 00003A65 83C402                   add  sp, 2
  5319                                  
  5320                                  ;-92     if (ErrorCount) prs(" ***ERROR*** ");
  5321                                  
  5322 00003A68 A1[A101]                 mov ax, [ErrorCount]
  5323 00003A6B 08C0                     or  al, al
  5324 00003A6D 0F840900                 je @@epilog204
  5325 00003A71 68[833B]                 push epilog_1
  5326 00003A74 E8A2F8                   call prs
  5327 00003A77 83C402                   add  sp, 2
  5328                                  
  5329                                  ;-93     prs(", Output: "); 
  5330                                  
  5331                                  @@epilog204:
  5332 00003A7A 68[913B]                 push epilog_2
  5333 00003A7D E899F8                   call prs
  5334 00003A80 83C402                   add  sp, 2
  5335                                  
  5336                                  ;-94     prs(namelst);
  5337                                  
  5338 00003A83 8D06[1301]               lea  ax, [namelst]
  5339 00003A87 50                       push ax
  5340 00003A88 E88EF8                   call prs
  5341 00003A8B 83C402                   add  sp, 2
  5342                                  
  5343                                  ;-95     prs(", ");
  5344                                  
  5345 00003A8E 68[9C3B]                 push epilog_3
  5346 00003A91 E885F8                   call prs
  5347 00003A94 83C402                   add  sp, 2
  5348                                  
  5349                                  ;-96     prs(namebin); 
  5350                                  
  5351 00003A97 8D06[5601]               lea  ax, [namebin]
  5352 00003A9B 50                       push ax
  5353 00003A9C E87AF8                   call prs
  5354 00003A9F 83C402                   add  sp, 2
  5355                                  
  5356                                  ;-97     prs("= ");
  5357                                  
  5358 00003AA2 68[9F3B]                 push epilog_4
  5359 00003AA5 E871F8                   call prs
  5360 00003AA8 83C402                   add  sp, 2
  5361                                  
  5362                                  ;-98     printIntU(BinLen); 
  5363                                  
  5364 00003AAB FF36[021C]               push word [BinLen]
  5365 00003AAF E886F9                   call printIntU
  5366 00003AB2 83C402                   add  sp, 2
  5367                                  
  5368                                  ;-99     prs(" bytes.");
  5369                                  
  5370 00003AB5 68[A23B]                 push epilog_5
  5371 00003AB8 E85EF8                   call prs
  5372 00003ABB 83C402                   add  sp, 2
  5373                                  
  5374                                  ;-100 
  5375                                  
  5376                                  
  5377                                  ;-101     i=0;
  5378                                  
  5379 00003ABE 66B800000000             mov eax, 0
  5380 00003AC4 8946FE                   mov word [bp-2], ax
  5381                                  
  5382                                  ;-102     do {
  5383                                  
  5384                                  @@epilog205:
  5385                                  
  5386                                  ;-103         c = FileBin[i];
  5387                                  
  5388 00003AC7 8B5EFE                   mov bx, [bp-2]
  5389 00003ACA 8A87[3214]               mov al, [FileBin + bx]
  5390 00003ACE 8846FC                   mov byte [bp-4], al
  5391                                  
  5392                                  ;-104         fputcR(c, bin_fd);  
  5393                                  
  5394 00003AD1 FF36[9D01]               push word [bin_fd]
  5395 00003AD5 8A46FC                   mov al, byte [bp-4]
  5396 00003AD8 B400                     mov ah, 0
  5397 00003ADA 50                       push ax
  5398 00003ADB E8980B                   call fputcR
  5399 00003ADE 83C404                   add  sp, 4
  5400                                  
  5401                                  ;-105 //printhex8a(c); prc(' ');      
  5402                                  
  5403                                  
  5404                                  ;-106         i++;
  5405                                  
  5406 00003AE1 FF46FE                   inc  word [bp-2]
  5407                                  
  5408                                  ;-107     } while (i < BinLen);
  5409                                  
  5410 00003AE4 8B46FE                   mov ax, [bp-2]
  5411 00003AE7 3B06[021C]               cmp ax, [BinLen]
  5412 00003AEB 0F8D0200                 jge @@epilog206
  5413 00003AEF EBD6                     jmp @@epilog205
  5414                                  @@epilog206:
  5415                                  
  5416                                  ;-108 
  5417                                  
  5418                                  
  5419                                  ;-109   prs("\nLabels: "); 
  5420                                  
  5421 00003AF1 68[AA3B]                 push epilog_6
  5422 00003AF4 E822F8                   call prs
  5423 00003AF7 83C402                   add  sp, 2
  5424                                  
  5425                                  ;-110   printIntU(LabelMaxIx); 
  5426                                  
  5427 00003AFA FF36[7E06]               push word [LabelMaxIx]
  5428 00003AFE E837F9                   call printIntU
  5429 00003B01 83C402                   add  sp, 2
  5430                                  
  5431                                  ;-111   prs(". ");     
  5432                                  
  5433 00003B04 68[B53B]                 push epilog_7
  5434 00003B07 E80FF8                   call prs
  5435 00003B0A 83C402                   add  sp, 2
  5436                                  
  5437                                  ;-112 /*  prs("size: ");
  5438                                  
  5439                                  
  5440                                  ;-113   i= &LabelNames; i=LabelNamePtr-i; printIntU(i); 
  5441                                  
  5442                                  
  5443                                  ;-114   prs(". >>");
  5444                                  
  5445                                  
  5446                                  ;-115   i= &LabelNames;
  5447                                  
  5448                                  
  5449                                  ;-116   do { c=*i; if (c==0) c=' '; prc(c); i++;
  5450                                  
  5451                                  
  5452                                  ;-117   } while (i < LabelNamePtr); prs("<< \n");  */
  5453                                  
  5454                                  
  5455                                  ;-118 
  5456                                  
  5457                                  
  5458                                  ;-119     i = 1;
  5459                                  
  5460 00003B0D 66B801000000             mov eax, 1
  5461 00003B13 8946FE                   mov word [bp-2], ax
  5462                                  
  5463                                  ;-120     LabelNamePtr= &LabelNames;
  5464                                  
  5465 00003B16 B8[CC01]                 mov ax, LabelNames
  5466 00003B19 A3[B405]                 mov word [LabelNamePtr], ax
  5467                                  
  5468                                  ;-121     do {
  5469                                  
  5470                                  @@epilog207:
  5471                                  
  5472                                  ;-122       prs(LabelNamePtr); prc(' ');
  5473                                  
  5474 00003B1C FF36[B405]               push word [LabelNamePtr]
  5475 00003B20 E8F6F7                   call prs
  5476 00003B23 83C402                   add  sp, 2
  5477 00003B26 6A20                     push 32
  5478 00003B28 E88DF7                   call prc
  5479 00003B2B 83C402                   add  sp, 2
  5480                                  
  5481                                  ;-123       j=LabelAddr[i]; printhex16(j); prs(", ");
  5482                                  
  5483 00003B2E 8B5EFE                   mov bx, [bp-2]
  5484 00003B31 D1E3                     shl bx, 1
  5485 00003B33 8B87[B605]               mov ax, [LabelAddr + bx]
  5486 00003B37 8946FA                   mov word [bp-6], ax
  5487 00003B3A FF76FA                   push word [bp-6]
  5488 00003B3D E8CEF8                   call printhex16
  5489 00003B40 83C402                   add  sp, 2
  5490 00003B43 68[B83B]                 push epilog_8
  5491 00003B46 E8D0F7                   call prs
  5492 00003B49 83C402                   add  sp, 2
  5493                                  
  5494                                  ;-124       j=strlen(LabelNamePtr);//get end of actual name
  5495                                  
  5496 00003B4C FF36[B405]               push word [LabelNamePtr]
  5497 00003B50 E8DC09                   call strlen
  5498 00003B53 83C402                   add  sp, 2
  5499 00003B56 8946FA                   mov word [bp-6], ax
  5500                                  
  5501                                  ;-125       LabelNamePtr=LabelNamePtr+j;
  5502                                  
  5503 00003B59 A1[B405]                 mov ax, [LabelNamePtr]
  5504 00003B5C 0346FA                   add ax, [bp-6]
  5505 00003B5F A3[B405]                 mov word [LabelNamePtr], ax
  5506                                  
  5507                                  ;-126       LabelNamePtr++;
  5508                                  
  5509 00003B62 FF06[B405]               inc  word [LabelNamePtr]
  5510                                  
  5511                                  ;-127       i++;
  5512                                  
  5513 00003B66 FF46FE                   inc  word [bp-2]
  5514                                  
  5515                                  ;-128     } while (i <= LabelMaxIx);
  5516                                  
  5517 00003B69 8B46FE                   mov ax, [bp-2]
  5518 00003B6C 3B06[7E06]               cmp ax, [LabelMaxIx]
  5519 00003B70 0F870200                 ja  @@epilog208
  5520 00003B74 EBA6                     jmp @@epilog207
  5521                                  @@epilog208:
  5522                                  
  5523                                  ;-129 
  5524                                  
  5525                                  
  5526                                  ;-130 }
  5527                                  
  5528                                  
  5529                                  ;-131 
  5530                                  
  5531                                  
  5532                                  ;-132 int end1(int n) {
  5533 00003B76 C9                       LEAVE
  5534 00003B77 C3                       ret
  5535                                  ; ENDP
  5536 00003B78 5C6E4572726F72733A-     epilog_0 db "\nErrors: ",0
  5537 00003B81 2000               
  5538 00003B83 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5539 00003B8C 2A2A2A2000         
  5540 00003B91 2C204F75747075743A-     epilog_2 db ", Output: ",0
  5541 00003B9A 2000               
  5542 00003B9C 2C2000                  epilog_3 db ", ",0
  5543 00003B9F 3D2000                  epilog_4 db "= ",0
  5544 00003BA2 2062797465732E00        epilog_5 db " bytes.",0
  5545 00003BAA 5C6E4C6162656C733A-     epilog_6 db "\nLabels: ",0
  5546 00003BB3 2000               
  5547 00003BB5 2E2000                  epilog_7 db ". ",0
  5548 00003BB8 2C2000                  epilog_8 db ", ",0
  5549                                  
  5550                                  end1:  ; *** PROC ***
  5551                                  
  5552                                  ;-133     fcloseR(asm_fd);
  5553                                  
  5554                                  ;Function : end1, Number of local variables: 1
  5555                                  ;   # type sign width line used address name   list of local variables
  5556                                  ;  200 var sign word   132 NULL bp+4    n;
  5557 00003BBB C8000000                 ENTER  0,0
  5558 00003BBF FF36[9901]               push word [asm_fd]
  5559 00003BC3 E8C50A                   call fcloseR
  5560 00003BC6 83C402                   add  sp, 2
  5561                                  
  5562                                  ;-134     fcloseR(lst_fd);
  5563                                  
  5564 00003BC9 FF36[9B01]               push word [lst_fd]
  5565 00003BCD E8BB0A                   call fcloseR
  5566 00003BD0 83C402                   add  sp, 2
  5567                                  
  5568                                  ;-135     fcloseR(bin_fd);
  5569                                  
  5570 00003BD3 FF36[9D01]               push word [bin_fd]
  5571 00003BD7 E8B10A                   call fcloseR
  5572 00003BDA 83C402                   add  sp, 2
  5573                                  
  5574                                  ;-136     exitR(n);
  5575                                  
  5576 00003BDD FF7604                   push word [bp+4]
  5577 00003BE0 E8B60A                   call exitR
  5578 00003BE3 83C402                   add  sp, 2
  5579                                  
  5580                                  ;-137 }
  5581 00003BE6 C9                       LEAVE
  5582 00003BE7 C3                       ret
  5583                                  ; ENDP
  5584                                  ;Back to main program: AS.C
  5585                                  
  5586                                  ;-9 #include "GENCODE.C"
  5587                                  
  5588                                  ;Use include file: GENCODE.C
  5589                                  
  5590                                  ;-1 // generate code
  5591                                  
  5592                                  
  5593                                  ;-2 int getCodes() {
  5594                                  
  5595                                  
  5596                                  getCodes:  ; *** PROC ***
  5597                                  
  5598                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5599                                  
  5600 00003BE8 FF06[C901]               inc  word [OpCodePtr]
  5601 00003BEC 8B1E[C901]               mov bx, [OpCodePtr]
  5602 00003BF0 8A07                     mov al, [bx]
  5603 00003BF2 B400                     mov ah, 0
  5604 00003BF4 A2[B101]                 mov byte [Code1], al
  5605                                  
  5606                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5607                                  
  5608 00003BF7 FF06[C901]               inc  word [OpCodePtr]
  5609 00003BFB 8B1E[C901]               mov bx, [OpCodePtr]
  5610 00003BFF 8A07                     mov al, [bx]
  5611 00003C01 B400                     mov ah, 0
  5612 00003C03 A2[B201]                 mov byte [Code2], al
  5613                                  
  5614                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5615                                  
  5616 00003C06 FF06[C901]               inc  word [OpCodePtr]
  5617 00003C0A 8B1E[C901]               mov bx, [OpCodePtr]
  5618 00003C0E 8A07                     mov al, [bx]
  5619 00003C10 B400                     mov ah, 0
  5620 00003C12 A2[B301]                 mov byte [Code3], al
  5621                                  
  5622                                  ;-6 }
  5623                                  
  5624                                  
  5625                                  ;-7 int gen66h() {genCode8(0x66);
  5626                                  
  5627 00003C15 C3                       ret
  5628                                  ; ENDP
  5629                                  
  5630                                  gen66h:  ; *** PROC ***
  5631 00003C16 6A66                     push 102
  5632 00003C18 E83B00                   call genCode8
  5633 00003C1B 83C402                   add  sp, 2
  5634                                  
  5635                                  ;-8 }
  5636                                  
  5637                                  
  5638                                  ;-9 int genCode2(char c, char d) {
  5639                                  
  5640 00003C1E C3                       ret
  5641                                  ; ENDP
  5642                                  
  5643                                  genCode2:  ; *** PROC ***
  5644                                  
  5645                                  ;-10     c = c + d;
  5646                                  
  5647                                  ;Function : genCode2, Number of local variables: 2
  5648                                  ;   # type sign width line used address name   list of local variables
  5649                                  ;  200 var sign byte     9 NULL bp+4    c
  5650                                  ;  201 var sign byte     9 NULL bp+6    d;
  5651 00003C1F C8000000                 ENTER  0,0
  5652 00003C23 8A4604                   mov al, [bp+4]
  5653 00003C26 024606                   add al, [bp+6]
  5654 00003C29 884604                   mov byte [bp+4], al
  5655                                  
  5656                                  ;-11     genCode8(c);
  5657                                  
  5658 00003C2C 8A4604                   mov al, byte [bp+4]
  5659 00003C2F B400                     mov ah, 0
  5660 00003C31 50                       push ax
  5661 00003C32 E82100                   call genCode8
  5662 00003C35 83C402                   add  sp, 2
  5663                                  
  5664                                  ;-12 }                             
  5665                                  
  5666                                  
  5667                                  ;-13 int genCodeW(char c) {
  5668 00003C38 C9                       LEAVE
  5669 00003C39 C3                       ret
  5670                                  ; ENDP
  5671                                  
  5672                                  genCodeW:  ; *** PROC ***
  5673                                  
  5674                                  ;-14     c = c + wflag;  
  5675                                  
  5676                                  ;Function : genCodeW, Number of local variables: 1
  5677                                  ;   # type sign width line used address name   list of local variables
  5678                                  ;  200 var sign byte    13 NULL bp+4    c;
  5679 00003C3A C8000000                 ENTER  0,0
  5680 00003C3E 8A4604                   mov al, [bp+4]
  5681 00003C41 0206[B901]               add al, [wflag]
  5682 00003C45 884604                   mov byte [bp+4], al
  5683                                  
  5684                                  ;-15     genCode8(c);
  5685                                  
  5686 00003C48 8A4604                   mov al, byte [bp+4]
  5687 00003C4B B400                     mov ah, 0
  5688 00003C4D 50                       push ax
  5689 00003C4E E80500                   call genCode8
  5690 00003C51 83C402                   add  sp, 2
  5691                                  
  5692                                  ;-16 }   
  5693                                  
  5694                                  
  5695                                  ;-17 int genCode8(char c) {
  5696 00003C54 C9                       LEAVE
  5697 00003C55 C3                       ret
  5698                                  ; ENDP
  5699                                  
  5700                                  genCode8:  ; *** PROC ***
  5701                                  
  5702                                  ;-18 //set: BinLen++, OpPrintIndex++
  5703                                  
  5704                                  
  5705                                  ;-19     FileBin[BinLen]=c;
  5706                                  
  5707                                  ;Function : genCode8, Number of local variables: 1
  5708                                  ;   # type sign width line used address name   list of local variables
  5709                                  ;  200 var sign byte    17 NULL bp+4    c;
  5710 00003C56 C8000000                 ENTER  0,0
  5711 00003C5A 8A4604                   mov al, [bp+4]
  5712 00003C5D 8B1E[021C]               mov bx, [BinLen]
  5713 00003C61 8887[3214]               mov [FileBin+bx], al
  5714                                  
  5715                                  ;-20     BinLen++;
  5716                                  
  5717 00003C65 FF06[021C]               inc  word [BinLen]
  5718                                  
  5719                                  ;-21     PC++;
  5720                                  
  5721 00003C69 FF06[A601]               inc  word [PC]
  5722                                  
  5723                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5724                                  
  5725 00003C6D A1[021C]                 mov ax, [BinLen]
  5726 00003C70 3DD007                   cmp ax, 2000 ;unsigned : 0
  5727 00003C73 0F820900                 jb  @@genCode8209
  5728 00003C77 68[9B3C]                 push genCode8_0
  5729 00003C7A E85CF8                   call errorexit
  5730 00003C7D 83C402                   add  sp, 2
  5731                                  
  5732                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5733                                  
  5734                                  @@genCode8209:
  5735 00003C80 A1[C701]                 mov ax, [OpPrintIndex]
  5736 00003C83 83F805                   cmp ax, 5
  5737 00003C86 0F8D0F00                 jge @@genCode8210
  5738                                  
  5739                                  ;-24         OpPos[OpPrintIndex]=c;
  5740                                  
  5741 00003C8A 8A4604                   mov al, [bp+4]
  5742 00003C8D 8B1E[C701]               mov bx, [OpPrintIndex]
  5743 00003C91 8887[C201]               mov [OpPos+bx], al
  5744                                  
  5745                                  ;-25         OpPrintIndex++;
  5746                                  
  5747 00003C95 FF06[C701]               inc  word [OpPrintIndex]
  5748                                  
  5749                                  ;-26     }
  5750                                  
  5751                                  
  5752                                  ;-27 }
  5753                                  
  5754                                  @@genCode8210:
  5755                                  
  5756                                  ;-28 int genCode16(unsigned int i) {
  5757 00003C99 C9                       LEAVE
  5758 00003C9A C3                       ret
  5759                                  ; ENDP
  5760 00003C9B 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5761 00003CA4 746F6F206C6F6E6700 
  5762                                  
  5763                                  genCode16:  ; *** PROC ***
  5764                                  
  5765                                  ;-29     genCode8(i); i=i >> 8;
  5766                                  
  5767                                  ;Function : genCode16, Number of local variables: 1
  5768                                  ;   # type sign width line used address name   list of local variables
  5769                                  ;  200 var unsg word    28 NULL bp+4    i;
  5770 00003CAD C8000000                 ENTER  0,0
  5771 00003CB1 FF7604                   push word [bp+4]
  5772 00003CB4 E89FFF                   call genCode8
  5773 00003CB7 83C402                   add  sp, 2
  5774 00003CBA 8B4604                   mov ax, [bp+4]
  5775 00003CBD C1E808                   shr ax, 8
  5776 00003CC0 894604                   mov word [bp+4], ax
  5777                                  
  5778                                  ;-30     genCode8(i);
  5779                                  
  5780 00003CC3 FF7604                   push word [bp+4]
  5781 00003CC6 E88DFF                   call genCode8
  5782 00003CC9 83C402                   add  sp, 2
  5783                                  
  5784                                  ;-31 }
  5785                                  
  5786                                  
  5787                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5788 00003CCC C9                       LEAVE
  5789 00003CCD C3                       ret
  5790                                  ; ENDP
  5791                                  
  5792                                  writeEA:  ; *** PROC ***
  5793                                  
  5794                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5795                                  
  5796                                  
  5797                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5798                                  
  5799                                  
  5800                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5801                                  
  5802                                  
  5803                                  ;-36     char len;
  5804                                  
  5805                                  
  5806                                  ;-37     len=0;   
  5807                                  
  5808                                  ;Function : writeEA, Number of local variables: 2
  5809                                  ;   # type sign width line used address name   list of local variables
  5810                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5811                                  ;  201 var sign byte    36 NULL bp-2    len;
  5812 00003CCE C8020000                 ENTER  2,0
  5813 00003CD2 66B800000000             mov eax, 0
  5814 00003CD8 8846FE                   mov byte [bp-2], al
  5815                                  
  5816                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5817                                  
  5818 00003CDB 8A4604                   mov al, [bp+4]
  5819 00003CDE C0E003                   shl al, 3
  5820 00003CE1 884604                   mov byte [bp+4], al
  5821                                  
  5822                                  ;-39     if (Op == REG) {
  5823                                  
  5824 00003CE4 A0[AE01]                 mov al, [Op]
  5825 00003CE7 3C02                     cmp al, 2
  5826 00003CE9 0F853A00                 jne @@writeEA211
  5827                                  
  5828                                  ;-40         xxx |= 0xC0;     
  5829                                  
  5830 00003CED 804E04C0                 or  byte [bp+4], 192
  5831                                  
  5832                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5833                                  
  5834 00003CF1 A0[AF01]                 mov al, [Op2]
  5835 00003CF4 3C01                     cmp al, 1
  5836 00003CF6 0F8F0D00                 jg  @@writeEA212
  5837 00003CFA 8A4604                   mov al, [bp+4]
  5838 00003CFD 0206[B501]               add al, [R1No]
  5839 00003D01 884604                   mov byte [bp+4], al
  5840                                  
  5841                                  ;-42             else {
  5842                                  
  5843 00003D04 E92000                   jmp @@writeEA213
  5844                                  @@writeEA212:
  5845                                  
  5846                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5847                                  
  5848 00003D07 A0[AF01]                 mov al, [Op2]
  5849 00003D0A 3C02                     cmp al, 2
  5850 00003D0C 0F850D00                 jne @@writeEA214
  5851 00003D10 8A4604                   mov al, [bp+4]
  5852 00003D13 0206[B501]               add al, [R1No]
  5853 00003D17 884604                   mov byte [bp+4], al
  5854                                  
  5855                                  ;-44                 else            xxx = xxx + R2No;  
  5856                                  
  5857 00003D1A E90A00                   jmp @@writeEA215
  5858                                  @@writeEA214:
  5859 00003D1D 8A4604                   mov al, [bp+4]
  5860 00003D20 0206[B401]               add al, [R2No]
  5861 00003D24 884604                   mov byte [bp+4], al
  5862                                  
  5863                                  ;-45             }
  5864                                  
  5865                                  @@writeEA215:
  5866                                  
  5867                                  ;-46         } 
  5868                                  
  5869                                  @@writeEA213:
  5870                                  
  5871                                  ;-47     if (Op == MEM) {
  5872                                  
  5873                                  @@writeEA211:
  5874 00003D27 A0[AE01]                 mov al, [Op]
  5875 00003D2A 3C04                     cmp al, 4
  5876 00003D2C 0F857F00                 jne @@writeEA216
  5877                                  
  5878                                  ;-48         if (isDirect) {
  5879                                  
  5880 00003D30 A0[BD01]                 mov al, [isDirect]
  5881 00003D33 08C0                     or  al, al
  5882 00003D35 0F841000                 je @@writeEA217
  5883                                  
  5884                                  ;-49             xxx |= 6;
  5885                                  
  5886 00003D39 804E0406                 or  byte [bp+4], 6
  5887                                  
  5888                                  ;-50             len = 2;
  5889                                  
  5890 00003D3D 66B802000000             mov eax, 2
  5891 00003D43 8846FE                   mov byte [bp-2], al
  5892                                  
  5893                                  ;-51         }
  5894                                  
  5895                                  
  5896                                  ;-52         else { 
  5897                                  
  5898 00003D46 E96600                   jmp @@writeEA218
  5899                                  @@writeEA217:
  5900                                  
  5901                                  ;-53             xxx = xxx + rm;   
  5902                                  
  5903 00003D49 8A4604                   mov al, [bp+4]
  5904 00003D4C 0206[BC01]               add al, [rm]
  5905 00003D50 884604                   mov byte [bp+4], al
  5906                                  
  5907                                  ;-54             if (rm == 6) {//make [BP+00]
  5908                                  
  5909 00003D53 A0[BC01]                 mov al, [rm]
  5910 00003D56 3C06                     cmp al, 6
  5911 00003D58 0F851700                 jne @@writeEA219
  5912                                  
  5913                                  ;-55                 len=1;
  5914                                  
  5915 00003D5C 66B801000000             mov eax, 1
  5916 00003D62 8846FE                   mov byte [bp-2], al
  5917                                  
  5918                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5919                                  
  5920 00003D65 A1[BE01]                 mov ax, [disp]
  5921 00003D68 83F800                   cmp ax, 0
  5922 00003D6B 0F850400                 jne @@writeEA220
  5923 00003D6F 804E0440                 or  byte [bp+4], 64
  5924                                  
  5925                                  ;-57             }
  5926                                  
  5927                                  @@writeEA220:
  5928                                  
  5929                                  ;-58 
  5930                                  
  5931                                  
  5932                                  ;-59             if (disp) {
  5933                                  
  5934                                  @@writeEA219:
  5935 00003D73 A1[BE01]                 mov ax, [disp]
  5936 00003D76 08C0                     or  al, al
  5937 00003D78 0F843300                 je @@writeEA221
  5938                                  
  5939                                  ;-60                 ax = disp;
  5940                                  
  5941 00003D7C A1[BE01]                 mov  ax, [disp]
  5942                                  
  5943                                  ;-61                 if(ax > 127) len=2;
  5944                                  
  5945 00003D7F 83F87F                   cmp  ax, 127
  5946 00003D82 0F8E0C00                 jle @@writeEA222
  5947 00003D86 66B802000000             mov eax, 2
  5948 00003D8C 8846FE                   mov byte [bp-2], al
  5949                                  
  5950                                  ;-62                 else len=1;
  5951                                  
  5952 00003D8F E90900                   jmp @@writeEA223
  5953                                  @@writeEA222:
  5954 00003D92 66B801000000             mov eax, 1
  5955 00003D98 8846FE                   mov byte [bp-2], al
  5956                                  
  5957                                  ;-63                 if (len == 1) xxx |= 0x40;
  5958                                  
  5959                                  @@writeEA223:
  5960 00003D9B 8A46FE                   mov al, [bp-2]
  5961 00003D9E 3C01                     cmp al, 1
  5962 00003DA0 0F850700                 jne @@writeEA224
  5963 00003DA4 804E0440                 or  byte [bp+4], 64
  5964                                  
  5965                                  ;-64                 else xxx |= 0x80;
  5966                                  
  5967 00003DA8 E90400                   jmp @@writeEA225
  5968                                  @@writeEA224:
  5969 00003DAB 804E0480                 or  byte [bp+4], 128
  5970                                  
  5971                                  ;-65             }
  5972                                  
  5973                                  @@writeEA225:
  5974                                  
  5975                                  ;-66         }
  5976                                  
  5977                                  @@writeEA221:
  5978                                  
  5979                                  ;-67     }  
  5980                                  
  5981                                  @@writeEA218:
  5982                                  
  5983                                  ;-68     
  5984                                  
  5985                                  
  5986                                  ;-69     genCode8(xxx);// gen second byte
  5987                                  
  5988                                  @@writeEA216:
  5989 00003DAF 8A4604                   mov al, byte [bp+4]
  5990 00003DB2 B400                     mov ah, 0
  5991 00003DB4 50                       push ax
  5992 00003DB5 E89EFE                   call genCode8
  5993 00003DB8 83C402                   add  sp, 2
  5994                                  
  5995                                  ;-70     if (len == 1) genCode8 (disp);
  5996                                  
  5997 00003DBB 8A46FE                   mov al, [bp-2]
  5998 00003DBE 3C01                     cmp al, 1
  5999 00003DC0 0F850A00                 jne @@writeEA226
  6000 00003DC4 FF36[BE01]               push word [disp]
  6001 00003DC8 E88BFE                   call genCode8
  6002 00003DCB 83C402                   add  sp, 2
  6003                                  
  6004                                  ;-71     if (len == 2) genCode16(disp);
  6005                                  
  6006                                  @@writeEA226:
  6007 00003DCE 8A46FE                   mov al, [bp-2]
  6008 00003DD1 3C02                     cmp al, 2
  6009 00003DD3 0F850A00                 jne @@writeEA227
  6010 00003DD7 FF36[BE01]               push word [disp]
  6011 00003DDB E8CFFE                   call genCode16
  6012 00003DDE 83C402                   add  sp, 2
  6013                                  
  6014                                  ;-72 }
  6015                                  
  6016                                  @@writeEA227:
  6017                                  
  6018                                  ;-73 
  6019                                  
  6020                                  
  6021                                  ;-74 int genImmediate() { 
  6022 00003DE1 C9                       LEAVE
  6023 00003DE2 C3                       ret
  6024                                  ; ENDP
  6025                                  
  6026                                  genImmediate:  ; *** PROC ***
  6027                                  
  6028                                  ;-75     if (wflag) genCode16(imme);
  6029                                  
  6030 00003DE3 A0[B901]                 mov al, [wflag]
  6031 00003DE6 08C0                     or  al, al
  6032 00003DE8 0F840D00                 je @@genImmediate228
  6033 00003DEC FF36[C001]               push word [imme]
  6034 00003DF0 E8BAFE                   call genCode16
  6035 00003DF3 83C402                   add  sp, 2
  6036                                  
  6037                                  ;-76     else       genCode8 (imme);  
  6038                                  
  6039 00003DF6 E90A00                   jmp @@genImmediate229
  6040                                  @@genImmediate228:
  6041 00003DF9 FF36[C001]               push word [imme]
  6042 00003DFD E856FE                   call genCode8
  6043 00003E00 83C402                   add  sp, 2
  6044                                  
  6045                                  ;-77 }    
  6046                                  
  6047                                  @@genImmediate229:
  6048 00003E03 C3                       ret
  6049                                  ; ENDP
  6050                                  ;Back to main program: AS.C
  6051                                  
  6052                                  ;-10 
  6053                                  
  6054                                  
  6055                                  ;-11 int process() { 
  6056                                  
  6057                                  
  6058                                  process:  ; *** PROC ***
  6059                                  
  6060                                  ;-12     char c;           
  6061                                  
  6062                                  
  6063                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  6064                                  
  6065                                  ;Function : process, Number of local variables: 1
  6066                                  ;   # type sign width line used address name   list of local variables
  6067                                  ;  200 var sign byte    12 NULL bp-2    c;
  6068 00003E04 C8020000                 ENTER  2,0
  6069 00003E08 66B800000000             mov eax, 0
  6070 00003E0E A2[BC01]                 mov byte [rm], al
  6071 00003E11 A2[B901]                 mov byte [wflag], al
  6072 00003E14 A2[BA01]                 mov byte [dflag], al
  6073 00003E17 A2[B401]                 mov byte [R2No], al
  6074 00003E1A A2[B501]                 mov byte [R1No], al
  6075 00003E1D A2[B601]                 mov byte [R2Type], al
  6076 00003E20 A2[B701]                 mov byte [R1Type], al
  6077 00003E23 A2[AF01]                 mov byte [Op2], al
  6078 00003E26 A2[AE01]                 mov byte [Op], al
  6079                                  
  6080                                  ;-14     disp=imme=0;//int
  6081                                  
  6082 00003E29 66B800000000             mov eax, 0
  6083 00003E2F A3[C001]                 mov word [imme], ax
  6084 00003E32 A3[BE01]                 mov word [disp], ax
  6085                                  
  6086                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  6087                                  
  6088 00003E35 66B801000000             mov eax, 1
  6089 00003E3B A2[BD01]                 mov byte [isDirect], al
  6090                                  
  6091                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  6092                                  
  6093 00003E3E E87EE7                   call getTokeType
  6094                                  
  6095                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  6096                                  
  6097 00003E41 E85CEB                   call getCodeSize
  6098 00003E44 A2[B801]                 mov byte [OpSize], al
  6099                                  
  6100                                  ;-18     getCodes();//set: Code1, Code2, Code3
  6101                                  
  6102 00003E47 E89EFD                   call getCodes
  6103                                  
  6104                                  ;-19 
  6105                                  
  6106                                  
  6107                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  6108                                  
  6109 00003E4A A0[B001]                 mov al, [CodeType]
  6110 00003E4D 3C01                     cmp al, 1
  6111 00003E4F 0F850F00                 jne @@process230
  6112                                  
  6113                                  ;-21         genCode8(Code1);
  6114                                  
  6115 00003E53 A0[B101]                 mov al, byte [Code1]
  6116 00003E56 B400                     mov ah, 0
  6117 00003E58 50                       push ax
  6118 00003E59 E8FAFD                   call genCode8
  6119 00003E5C 83C402                   add  sp, 2
  6120                                  
  6121                                  ;-22         return;
  6122                                  
  6123 00003E5F E91706                   jmp @@retn
  6124                                  
  6125                                  ;-23     }
  6126                                  
  6127                                  
  6128                                  ;-24   
  6129                                  
  6130                                  
  6131                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  6132                                  
  6133                                  @@process230:
  6134 00003E62 A0[B001]                 mov al, [CodeType]
  6135 00003E65 3C02                     cmp al, 2
  6136 00003E67 0F856900                 jne @@process231
  6137                                  
  6138                                  ;-26         getOpL();    
  6139                                  
  6140 00003E6B E823E2                   call getOpL
  6141                                  
  6142                                  ;-27         checkOpL();        
  6143                                  
  6144 00003E6E E843E1                   call checkOpL
  6145                                  
  6146                                  ;-28         if (Code2 <= 1) {//inc,dec
  6147                                  
  6148 00003E71 A0[B201]                 mov al, [Code2]
  6149 00003E74 3C01                     cmp al, 1
  6150 00003E76 0F8F2700                 jg  @@process232
  6151                                  
  6152                                  ;-29   	        if (Op == REG) {//short
  6153                                  
  6154 00003E7A A0[AE01]                 mov al, [Op]
  6155 00003E7D 3C02                     cmp al, 2
  6156 00003E7F 0F851E00                 jne @@process233
  6157                                  
  6158                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  6159                                  
  6160 00003E83 A0[B901]                 mov al, [wflag]
  6161 00003E86 08C0                     or  al, al
  6162 00003E88 0F841500                 je @@process234
  6163 00003E8C A0[B501]                 mov al, byte [R1No]
  6164 00003E8F B400                     mov ah, 0
  6165 00003E91 50                       push ax
  6166 00003E92 A0[B301]                 mov al, byte [Code3]
  6167 00003E95 B400                     mov ah, 0
  6168 00003E97 50                       push ax
  6169 00003E98 E884FD                   call genCode2
  6170 00003E9B 83C404                   add  sp, 4
  6171 00003E9E E9D805                   jmp @@retn
  6172                                  
  6173                                  ;-31             }
  6174                                  
  6175                                  @@process234:
  6176                                  
  6177                                  ;-32         }
  6178                                  
  6179                                  @@process233:
  6180                                  
  6181                                  ;-33         if (Code2 == 5) {//imul extension?
  6182                                  
  6183                                  @@process232:
  6184 00003EA1 A0[B201]                 mov al, [Code2]
  6185 00003EA4 3C05                     cmp al, 5
  6186 00003EA6 0F850F00                 jne @@process235
  6187                                  
  6188                                  ;-34             getTokeType();
  6189                                  
  6190 00003EAA E812E7                   call getTokeType
  6191                                  
  6192                                  ;-35             if (TokeType) implerror();
  6193                                  
  6194 00003EAD A0[AD01]                 mov al, [TokeType]
  6195 00003EB0 08C0                     or  al, al
  6196 00003EB2 0F840300                 je @@process236
  6197 00003EB6 E891F6                   call implerror
  6198                                  
  6199                                  ;-36         }
  6200                                  
  6201                                  @@process236:
  6202                                  
  6203                                  ;-37         genCodeW(Code1);           
  6204                                  
  6205                                  @@process235:
  6206 00003EB9 A0[B101]                 mov al, byte [Code1]
  6207 00003EBC B400                     mov ah, 0
  6208 00003EBE 50                       push ax
  6209 00003EBF E878FD                   call genCodeW
  6210 00003EC2 83C402                   add  sp, 2
  6211                                  
  6212                                  ;-38         writeEA(Code2);
  6213                                  
  6214 00003EC5 A0[B201]                 mov al, byte [Code2]
  6215 00003EC8 B400                     mov ah, 0
  6216 00003ECA 50                       push ax
  6217 00003ECB E800FE                   call writeEA
  6218 00003ECE 83C402                   add  sp, 2
  6219                                  
  6220                                  ;-39         return;
  6221                                  
  6222 00003ED1 E9A505                   jmp @@retn
  6223                                  
  6224                                  ;-40     }
  6225                                  
  6226                                  
  6227                                  ;-41   
  6228                                  
  6229                                  
  6230                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  6231                                  
  6232                                  @@process231:
  6233 00003ED4 A0[B001]                 mov al, [CodeType]
  6234 00003ED7 3C03                     cmp al, 3
  6235 00003ED9 0F855100                 jne @@process237
  6236                                  
  6237                                  ;-43         check2Ops();    //setwflag not applicable
  6238                                  
  6239 00003EDD E856E1                   call check2Ops
  6240                                  
  6241                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  6242                                  
  6243 00003EE0 A0[B701]                 mov al, [R1Type]
  6244 00003EE3 3C02                     cmp al, 2
  6245 00003EE5 0F840300                 je  @@process238
  6246 00003EE9 E8FEF6                   call reg16error
  6247                                  
  6248                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  6249                                  
  6250                                  @@process238:
  6251 00003EEC A0[AF01]                 mov al, [Op2]
  6252 00003EEF 3C04                     cmp al, 4
  6253 00003EF1 0F840300                 je  @@process239
  6254 00003EF5 E813F6                   call addrerror
  6255                                  
  6256                                  ;-46         
  6257                                  
  6258                                  
  6259                                  ;-47         genCode8(Code1);//les,lds,lea
  6260                                  
  6261                                  @@process239:
  6262 00003EF8 A0[B101]                 mov al, byte [Code1]
  6263 00003EFB B400                     mov ah, 0
  6264 00003EFD 50                       push ax
  6265 00003EFE E855FD                   call genCode8
  6266 00003F01 83C402                   add  sp, 2
  6267                                  
  6268                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  6269                                  
  6270 00003F04 A0[B101]                 mov al, [Code1]
  6271 00003F07 3C0F                     cmp al, 15
  6272 00003F09 0F850C00                 jne @@process240
  6273 00003F0D A0[B201]                 mov al, byte [Code2]
  6274 00003F10 B400                     mov ah, 0
  6275 00003F12 50                       push ax
  6276 00003F13 E840FD                   call genCode8
  6277 00003F16 83C402                   add  sp, 2
  6278                                  
  6279                                  ;-49         Op=Op2;//set MEM for writeEA
  6280                                  
  6281                                  @@process240:
  6282 00003F19 A0[AF01]                 mov al, [Op2]
  6283 00003F1C A2[AE01]                 mov byte [Op], al
  6284                                  
  6285                                  ;-50         writeEA(R1No);           
  6286                                  
  6287 00003F1F A0[B501]                 mov al, byte [R1No]
  6288 00003F22 B400                     mov ah, 0
  6289 00003F24 50                       push ax
  6290 00003F25 E8A6FD                   call writeEA
  6291 00003F28 83C402                   add  sp, 2
  6292                                  
  6293                                  ;-51         return;
  6294                                  
  6295 00003F2B E94B05                   jmp @@retn
  6296                                  
  6297                                  ;-52     }
  6298                                  
  6299                                  
  6300                                  ;-53 
  6301                                  
  6302                                  
  6303                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6304                                  
  6305                                  @@process237:
  6306 00003F2E A0[B001]                 mov al, [CodeType]
  6307 00003F31 3C04                     cmp al, 4
  6308 00003F33 0F85EF00                 jne @@process241
  6309                                  
  6310                                  ;-55         check2Ops();    
  6311                                  
  6312 00003F37 E8FCE0                   call check2Ops
  6313                                  
  6314                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  6315                                  
  6316 00003F3A A0[AF01]                 mov al, [Op2]
  6317 00003F3D 3C01                     cmp al, 1
  6318 00003F3F 0F857900                 jne @@process242
  6319                                  
  6320                                  ;-57             setsflag();   
  6321                                  
  6322 00003F43 E8D3E4                   call setsflag
  6323                                  
  6324                                  ;-58             if (Op == REG) {                
  6325                                  
  6326 00003F46 A0[AE01]                 mov al, [Op]
  6327 00003F49 3C02                     cmp al, 2
  6328 00003F4B 0F853100                 jne @@process243
  6329                                  
  6330                                  ;-59                 if (R1No == 0) {// acc,imm   
  6331                                  
  6332 00003F4F A0[B501]                 mov al, [R1No]
  6333 00003F52 3C00                     cmp al, 0
  6334 00003F54 0F852800                 jne @@process244
  6335                                  
  6336                                  ;-60                     if (sflag == 0) {                        
  6337                                  
  6338 00003F58 A0[BB01]                 mov al, [sflag]
  6339 00003F5B 3C00                     cmp al, 0
  6340 00003F5D 0F851F00                 jne @@process245
  6341                                  
  6342                                  ;-61                         c = Code1 << 3;
  6343                                  
  6344 00003F61 A0[B101]                 mov al, [Code1]
  6345 00003F64 C0E003                   shl al, 3
  6346 00003F67 8846FE                   mov byte [bp-2], al
  6347                                  
  6348                                  ;-62                         c += 4;    
  6349                                  
  6350 00003F6A 8046FE04                 add  byte [bp-2], 4
  6351                                  
  6352                                  ;-63                         genCodeW(c);
  6353                                  
  6354 00003F6E 8A46FE                   mov al, byte [bp-2]
  6355 00003F71 B400                     mov ah, 0
  6356 00003F73 50                       push ax
  6357 00003F74 E8C3FC                   call genCodeW
  6358 00003F77 83C402                   add  sp, 2
  6359                                  
  6360                                  ;-64                         genImmediate();
  6361                                  
  6362 00003F7A E866FE                   call genImmediate
  6363                                  
  6364                                  ;-65                         return;
  6365                                  
  6366 00003F7D E9F904                   jmp @@retn
  6367                                  
  6368                                  ;-66                     }
  6369                                  
  6370                                  
  6371                                  ;-67                 }
  6372                                  
  6373                                  @@process245:
  6374                                  
  6375                                  ;-68             }
  6376                                  
  6377                                  @@process244:
  6378                                  
  6379                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6380                                  
  6381                                  
  6382                                  ;-70             c = sflag + 0x80;   
  6383                                  
  6384                                  @@process243:
  6385 00003F80 A0[BB01]                 mov al, [sflag]
  6386 00003F83 0480                     add al, 128
  6387 00003F85 8846FE                   mov byte [bp-2], al
  6388                                  
  6389                                  ;-71             genCodeW(c); 
  6390                                  
  6391 00003F88 8A46FE                   mov al, byte [bp-2]
  6392 00003F8B B400                     mov ah, 0
  6393 00003F8D 50                       push ax
  6394 00003F8E E8A9FC                   call genCodeW
  6395 00003F91 83C402                   add  sp, 2
  6396                                  
  6397                                  ;-72             writeEA(Code1);  
  6398                                  
  6399 00003F94 A0[B101]                 mov al, byte [Code1]
  6400 00003F97 B400                     mov ah, 0
  6401 00003F99 50                       push ax
  6402 00003F9A E831FD                   call writeEA
  6403 00003F9D 83C402                   add  sp, 2
  6404                                  
  6405                                  ;-73             if (sflag) genCode8(imme);
  6406                                  
  6407 00003FA0 A0[BB01]                 mov al, [sflag]
  6408 00003FA3 08C0                     or  al, al
  6409 00003FA5 0F840D00                 je @@process246
  6410 00003FA9 FF36[C001]               push word [imme]
  6411 00003FAD E8A6FC                   call genCode8
  6412 00003FB0 83C402                   add  sp, 2
  6413                                  
  6414                                  ;-74             else genImmediate();    
  6415                                  
  6416 00003FB3 E90300                   jmp @@process247
  6417                                  @@process246:
  6418 00003FB6 E82AFE                   call genImmediate
  6419                                  
  6420                                  ;-75             return;     
  6421                                  
  6422                                  @@process247:
  6423 00003FB9 E9BD04                   jmp @@retn
  6424                                  
  6425                                  ;-76         }  
  6426                                  
  6427                                  
  6428                                  ;-77         c = Code1 << 3;//r/m, r/r  
  6429                                  
  6430                                  @@process242:
  6431 00003FBC A0[B101]                 mov al, [Code1]
  6432 00003FBF C0E003                   shl al, 3
  6433 00003FC2 8846FE                   mov byte [bp-2], al
  6434                                  
  6435                                  ;-78         if (Op == REG) {
  6436                                  
  6437 00003FC5 A0[AE01]                 mov al, [Op]
  6438 00003FC8 3C02                     cmp al, 2
  6439 00003FCA 0F852E00                 jne @@process248
  6440                                  
  6441                                  ;-79             if (Op2 == MEM) {//reg, mem      
  6442                                  
  6443 00003FCE A0[AF01]                 mov al, [Op2]
  6444 00003FD1 3C04                     cmp al, 4
  6445 00003FD3 0F852500                 jne @@process249
  6446                                  
  6447                                  ;-80                 c += 2;//add direction flag
  6448                                  
  6449 00003FD7 8046FE02                 add  byte [bp-2], 2
  6450                                  
  6451                                  ;-81                 genCodeW(c);
  6452                                  
  6453 00003FDB 8A46FE                   mov al, byte [bp-2]
  6454 00003FDE B400                     mov ah, 0
  6455 00003FE0 50                       push ax
  6456 00003FE1 E856FC                   call genCodeW
  6457 00003FE4 83C402                   add  sp, 2
  6458                                  
  6459                                  ;-82                 Op=Op2;//set MEM for writeEA                
  6460                                  
  6461 00003FE7 A0[AF01]                 mov al, [Op2]
  6462 00003FEA A2[AE01]                 mov byte [Op], al
  6463                                  
  6464                                  ;-83                 writeEA(R1No);
  6465                                  
  6466 00003FED A0[B501]                 mov al, byte [R1No]
  6467 00003FF0 B400                     mov ah, 0
  6468 00003FF2 50                       push ax
  6469 00003FF3 E8D8FC                   call writeEA
  6470 00003FF6 83C402                   add  sp, 2
  6471                                  
  6472                                  ;-84                 return;    
  6473                                  
  6474 00003FF9 E97D04                   jmp @@retn
  6475                                  
  6476                                  ;-85             }
  6477                                  
  6478                                  
  6479                                  ;-86         }
  6480                                  
  6481                                  @@process249:
  6482                                  
  6483                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  6484                                  
  6485                                  @@process248:
  6486 00003FFC A0[AF01]                 mov al, [Op2]
  6487 00003FFF 3C02                     cmp al, 2
  6488 00004001 0F851B00                 jne @@process250
  6489                                  
  6490                                  ;-88             genCodeW(c);
  6491                                  
  6492 00004005 8A46FE                   mov al, byte [bp-2]
  6493 00004008 B400                     mov ah, 0
  6494 0000400A 50                       push ax
  6495 0000400B E82CFC                   call genCodeW
  6496 0000400E 83C402                   add  sp, 2
  6497                                  
  6498                                  ;-89             writeEA(R2No);//2. Op in reg-field
  6499                                  
  6500 00004011 A0[B401]                 mov al, byte [R2No]
  6501 00004014 B400                     mov ah, 0
  6502 00004016 50                       push ax
  6503 00004017 E8B4FC                   call writeEA
  6504 0000401A 83C402                   add  sp, 2
  6505                                  
  6506                                  ;-90             return;            
  6507                                  
  6508 0000401D E95904                   jmp @@retn
  6509                                  
  6510                                  ;-91         }          
  6511                                  
  6512                                  
  6513                                  ;-92         syntaxerror();        
  6514                                  
  6515                                  @@process250:
  6516 00004020 E816F6                   call syntaxerror
  6517                                  
  6518                                  ;-93         return;
  6519                                  
  6520 00004023 E95304                   jmp @@retn
  6521                                  
  6522                                  ;-94     }
  6523                                  
  6524                                  
  6525                                  ;-95  
  6526                                  
  6527                                  
  6528                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  6529                                  
  6530                                  @@process241:
  6531 00004026 A0[B001]                 mov al, [CodeType]
  6532 00004029 3C05                     cmp al, 5
  6533 0000402B 0F857F01                 jne @@process251
  6534                                  
  6535                                  ;-97         check2Ops();    
  6536                                  
  6537 0000402F E804E0                   call check2Ops
  6538                                  
  6539                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  6540                                  
  6541                                  
  6542                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6543                                  
  6544                                  
  6545                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6546                                  
  6547                                  
  6548                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6549                                  
  6550                                  
  6551                                  ;-102         if (Op2 == ADR) {
  6552                                  
  6553 00004032 A0[AF01]                 mov al, [Op2]
  6554 00004035 3C03                     cmp al, 3
  6555 00004037 0F850F00                 jne @@process252
  6556                                  
  6557                                  ;-103             imme=disp;
  6558                                  
  6559 0000403B A1[BE01]                 mov ax, [disp]
  6560 0000403E A3[C001]                 mov word [imme], ax
  6561                                  
  6562                                  ;-104             Op2=IMM;//continue with IMM    
  6563                                  
  6564 00004041 66B801000000             mov eax, 1
  6565 00004047 A2[AF01]                 mov byte [Op2], al
  6566                                  
  6567                                  ;-105         }  
  6568                                  
  6569                                  
  6570                                  ;-106         if (Op2 == IMM) {// r,i     
  6571                                  
  6572                                  @@process252:
  6573 0000404A A0[AF01]                 mov al, [Op2]
  6574 0000404D 3C01                     cmp al, 1
  6575 0000404F 0F855400                 jne @@process253
  6576                                  
  6577                                  ;-107             if (Op == REG) {               
  6578                                  
  6579 00004053 A0[AE01]                 mov al, [Op]
  6580 00004056 3C02                     cmp al, 2
  6581 00004058 0F852500                 jne @@process254
  6582                                  
  6583                                  ;-108                 c = wflag << 3;   
  6584                                  
  6585 0000405C A0[B901]                 mov al, [wflag]
  6586 0000405F C0E003                   shl al, 3
  6587 00004062 8846FE                   mov byte [bp-2], al
  6588                                  
  6589                                  ;-109                 c += 0xB0;                                     
  6590                                  
  6591 00004065 8046FEB0                 add  byte [bp-2], 176
  6592                                  
  6593                                  ;-110                 genCode2(c, R1No);   
  6594                                  
  6595 00004069 A0[B501]                 mov al, byte [R1No]
  6596 0000406C B400                     mov ah, 0
  6597 0000406E 50                       push ax
  6598 0000406F 8A46FE                   mov al, byte [bp-2]
  6599 00004072 B400                     mov ah, 0
  6600 00004074 50                       push ax
  6601 00004075 E8A7FB                   call genCode2
  6602 00004078 83C404                   add  sp, 4
  6603                                  
  6604                                  ;-111                 genImmediate();
  6605                                  
  6606 0000407B E865FD                   call genImmediate
  6607                                  
  6608                                  ;-112                 return; 
  6609                                  
  6610 0000407E E9F803                   jmp @@retn
  6611                                  
  6612                                  ;-113             }
  6613                                  
  6614                                  
  6615                                  ;-114             if (Op == MEM) {// m,i  
  6616                                  
  6617                                  @@process254:
  6618 00004081 A0[AE01]                 mov al, [Op]
  6619 00004084 3C04                     cmp al, 4
  6620 00004086 0F851700                 jne @@process255
  6621                                  
  6622                                  ;-115                 genCodeW(0xC6);
  6623                                  
  6624 0000408A 68C600                   push 198
  6625 0000408D E8AAFB                   call genCodeW
  6626 00004090 83C402                   add  sp, 2
  6627                                  
  6628                                  ;-116                 writeEA( 0 );
  6629                                  
  6630 00004093 6A00                     push 0
  6631 00004095 E836FC                   call writeEA
  6632 00004098 83C402                   add  sp, 2
  6633                                  
  6634                                  ;-117                 genImmediate();
  6635                                  
  6636 0000409B E845FD                   call genImmediate
  6637                                  
  6638                                  ;-118                 return;  
  6639                                  
  6640 0000409E E9D803                   jmp @@retn
  6641                                  
  6642                                  ;-119             }
  6643                                  
  6644                                  
  6645                                  ;-120             regmemerror();
  6646                                  
  6647                                  @@process255:
  6648 000040A1 E81CF5                   call regmemerror
  6649                                  
  6650                                  ;-121             return;
  6651                                  
  6652 000040A4 E9D203                   jmp @@retn
  6653                                  
  6654                                  ;-122         }      
  6655                                  
  6656                                  
  6657                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6658                                  
  6659                                  @@process253:
  6660 000040A7 A0[B701]                 mov al, [R1Type]
  6661 000040AA 3C04                     cmp al, 4
  6662 000040AC 0F850300                 jne @@process256
  6663 000040B0 E8BCDE                   call ChangeDirection
  6664                                  
  6665                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6666                                  
  6667                                  @@process256:
  6668 000040B3 A0[B601]                 mov al, [R2Type]
  6669 000040B6 3C04                     cmp al, 4
  6670 000040B8 0F852A00                 jne @@process257
  6671                                  
  6672                                  ;-125             if (OpSize != WORD) reg16error();
  6673                                  
  6674 000040BC A0[B801]                 mov al, [OpSize]
  6675 000040BF 3C02                     cmp al, 2
  6676 000040C1 0F840300                 je  @@process258
  6677 000040C5 E822F5                   call reg16error
  6678                                  
  6679                                  ;-126                 genCode2(0x8C, dflag);
  6680                                  
  6681                                  @@process258:
  6682 000040C8 A0[BA01]                 mov al, byte [dflag]
  6683 000040CB B400                     mov ah, 0
  6684 000040CD 50                       push ax
  6685 000040CE 688C00                   push 140
  6686 000040D1 E84BFB                   call genCode2
  6687 000040D4 83C404                   add  sp, 4
  6688                                  
  6689                                  ;-127                 writeEA(R2No);
  6690                                  
  6691 000040D7 A0[B401]                 mov al, byte [R2No]
  6692 000040DA B400                     mov ah, 0
  6693 000040DC 50                       push ax
  6694 000040DD E8EEFB                   call writeEA
  6695 000040E0 83C402                   add  sp, 2
  6696                                  
  6697                                  ;-128                 return;   
  6698                                  
  6699 000040E3 E99303                   jmp @@retn
  6700                                  
  6701                                  ;-129         }          
  6702                                  
  6703                                  
  6704                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6705                                  
  6706                                  @@process257:
  6707 000040E6 A0[AF01]                 mov al, [Op2]
  6708 000040E9 3C04                     cmp al, 4
  6709 000040EB 0F853100                 jne @@process259
  6710                                  
  6711                                  ;-131             if (Op == REG) {
  6712                                  
  6713 000040EF A0[AE01]                 mov al, [Op]
  6714 000040F2 3C02                     cmp al, 2
  6715 000040F4 0F852800                 jne @@process260
  6716                                  
  6717                                  ;-132                 if (R1No == 0) {
  6718                                  
  6719 000040F8 A0[B501]                 mov al, [R1No]
  6720 000040FB 3C00                     cmp al, 0
  6721 000040FD 0F851F00                 jne @@process261
  6722                                  
  6723                                  ;-133                     if (isDirect) {
  6724                                  
  6725 00004101 A0[BD01]                 mov al, [isDirect]
  6726 00004104 08C0                     or  al, al
  6727 00004106 0F841600                 je @@process262
  6728                                  
  6729                                  ;-134                         genCodeW(0xA0);
  6730                                  
  6731 0000410A 68A000                   push 160
  6732 0000410D E82AFB                   call genCodeW
  6733 00004110 83C402                   add  sp, 2
  6734                                  
  6735                                  ;-135                         genCode16(disp);
  6736                                  
  6737 00004113 FF36[BE01]               push word [disp]
  6738 00004117 E893FB                   call genCode16
  6739 0000411A 83C402                   add  sp, 2
  6740                                  
  6741                                  ;-136                         return;   
  6742                                  
  6743 0000411D E95903                   jmp @@retn
  6744                                  
  6745                                  ;-137                     }   
  6746                                  
  6747                                  
  6748                                  ;-138                 }   
  6749                                  
  6750                                  @@process262:
  6751                                  
  6752                                  ;-139             }   
  6753                                  
  6754                                  @@process261:
  6755                                  
  6756                                  ;-140         } 
  6757                                  
  6758                                  @@process260:
  6759                                  
  6760                                  ;-141         if (Op == MEM) {//moffs16, acc
  6761                                  
  6762                                  @@process259:
  6763 00004120 A0[AE01]                 mov al, [Op]
  6764 00004123 3C04                     cmp al, 4
  6765 00004125 0F853100                 jne @@process263
  6766                                  
  6767                                  ;-142             if (Op2 == REG) {
  6768                                  
  6769 00004129 A0[AF01]                 mov al, [Op2]
  6770 0000412C 3C02                     cmp al, 2
  6771 0000412E 0F852800                 jne @@process264
  6772                                  
  6773                                  ;-143                 if (R2No == 0) {
  6774                                  
  6775 00004132 A0[B401]                 mov al, [R2No]
  6776 00004135 3C00                     cmp al, 0
  6777 00004137 0F851F00                 jne @@process265
  6778                                  
  6779                                  ;-144                     if (isDirect) {
  6780                                  
  6781 0000413B A0[BD01]                 mov al, [isDirect]
  6782 0000413E 08C0                     or  al, al
  6783 00004140 0F841600                 je @@process266
  6784                                  
  6785                                  ;-145                         genCodeW(0xA2);
  6786                                  
  6787 00004144 68A200                   push 162
  6788 00004147 E8F0FA                   call genCodeW
  6789 0000414A 83C402                   add  sp, 2
  6790                                  
  6791                                  ;-146                         genCode16(disp);
  6792                                  
  6793 0000414D FF36[BE01]               push word [disp]
  6794 00004151 E859FB                   call genCode16
  6795 00004154 83C402                   add  sp, 2
  6796                                  
  6797                                  ;-147                         return;   
  6798                                  
  6799 00004157 E91F03                   jmp @@retn
  6800                                  
  6801                                  ;-148                     }   
  6802                                  
  6803                                  
  6804                                  ;-149                 }   
  6805                                  
  6806                                  @@process266:
  6807                                  
  6808                                  ;-150             }
  6809                                  
  6810                                  @@process265:
  6811                                  
  6812                                  ;-151         
  6813                                  
  6814                                  
  6815                                  ;-152         }
  6816                                  
  6817                                  @@process264:
  6818                                  
  6819                                  ;-153         if (Op2 == REG) {//rm, r
  6820                                  
  6821                                  @@process263:
  6822 0000415A A0[AF01]                 mov al, [Op2]
  6823 0000415D 3C02                     cmp al, 2
  6824 0000415F 0F851800                 jne @@process267
  6825                                  
  6826                                  ;-154             genCodeW(0x88);     
  6827                                  
  6828 00004163 688800                   push 136
  6829 00004166 E8D1FA                   call genCodeW
  6830 00004169 83C402                   add  sp, 2
  6831                                  
  6832                                  ;-155             writeEA(R2No);
  6833                                  
  6834 0000416C A0[B401]                 mov al, byte [R2No]
  6835 0000416F B400                     mov ah, 0
  6836 00004171 50                       push ax
  6837 00004172 E859FB                   call writeEA
  6838 00004175 83C402                   add  sp, 2
  6839                                  
  6840                                  ;-156             return;
  6841                                  
  6842 00004178 E9FE02                   jmp @@retn
  6843                                  
  6844                                  ;-157         }
  6845                                  
  6846                                  
  6847                                  ;-158         if (Op2 == MEM) {//r, m
  6848                                  
  6849                                  @@process267:
  6850 0000417B A0[AF01]                 mov al, [Op2]
  6851 0000417E 3C04                     cmp al, 4
  6852 00004180 0F852400                 jne @@process268
  6853                                  
  6854                                  ;-159             if (Op == REG) {
  6855                                  
  6856 00004184 A0[AE01]                 mov al, [Op]
  6857 00004187 3C02                     cmp al, 2
  6858 00004189 0F851B00                 jne @@process269
  6859                                  
  6860                                  ;-160                 ChangeDirection();
  6861                                  
  6862 0000418D E8DFDD                   call ChangeDirection
  6863                                  
  6864                                  ;-161                 genCodeW(0x8A);
  6865                                  
  6866 00004190 688A00                   push 138
  6867 00004193 E8A4FA                   call genCodeW
  6868 00004196 83C402                   add  sp, 2
  6869                                  
  6870                                  ;-162                 writeEA(R2No);
  6871                                  
  6872 00004199 A0[B401]                 mov al, byte [R2No]
  6873 0000419C B400                     mov ah, 0
  6874 0000419E 50                       push ax
  6875 0000419F E82CFB                   call writeEA
  6876 000041A2 83C402                   add  sp, 2
  6877                                  
  6878                                  ;-163                 return;   
  6879                                  
  6880 000041A5 E9D102                   jmp @@retn
  6881                                  
  6882                                  ;-164             }   
  6883                                  
  6884                                  
  6885                                  ;-165         }         
  6886                                  
  6887                                  @@process269:
  6888                                  
  6889                                  ;-166         syntaxerror();
  6890                                  
  6891                                  @@process268:
  6892 000041A8 E88EF4                   call syntaxerror
  6893                                  
  6894                                  ;-167         return;
  6895                                  
  6896 000041AB E9CB02                   jmp @@retn
  6897                                  
  6898                                  ;-168     }    
  6899                                  
  6900                                  
  6901                                  ;-169     
  6902                                  
  6903                                  
  6904                                  ;-170     if (CodeType == 6) {//Jcc short jumps       
  6905                                  
  6906                                  @@process251:
  6907 000041AE A0[B001]                 mov al, [CodeType]
  6908 000041B1 3C06                     cmp al, 6
  6909 000041B3 0F85CF00                 jne @@process270
  6910                                  
  6911                                  ;-171 
  6912                                  
  6913                                  
  6914                                  ;-172 
  6915                                  
  6916                                  
  6917                                  ;-173         if (TokeType == ALNUME) {
  6918                                  
  6919 000041B7 A0[AD01]                 mov al, [TokeType]
  6920 000041BA 3C03                     cmp al, 3
  6921 000041BC 0F85C300                 jne @@process271
  6922                                  
  6923                                  ;-174             LabelIx=searchLabel();
  6924                                  
  6925 000041C0 E8D1E5                   call searchLabel
  6926 000041C3 A3[8006]                 mov word [LabelIx], ax
  6927                                  
  6928                                  ;-175             if (LabelIx > 0) {
  6929                                  
  6930 000041C6 A1[8006]                 mov ax, [LabelIx]
  6931 000041C9 83F800                   cmp ax, 0
  6932 000041CC 0F8E7A00                 jle @@process272
  6933                                  
  6934                                  ;-176                 disp=LabelAddr[LabelIx];
  6935                                  
  6936 000041D0 8B1E[8006]               mov bx, [LabelIx]
  6937 000041D4 D1E3                     shl bx, 1
  6938 000041D6 8B87[B605]               mov ax, [LabelAddr + bx]
  6939 000041DA A3[BE01]                 mov word [disp], ax
  6940                                  
  6941                                  ;-177                 disp = disp - PC;   
  6942                                  
  6943 000041DD A1[BE01]                 mov ax, [disp]
  6944 000041E0 2B06[A601]               sub ax, [PC]
  6945 000041E4 A3[BE01]                 mov word [disp], ax
  6946                                  
  6947                                  ;-178                 disp = disp - Origin;
  6948                                  
  6949 000041E7 A1[BE01]                 mov ax, [disp]
  6950 000041EA 2B06[A801]               sub ax, [Origin]
  6951 000041EE A3[BE01]                 mov word [disp], ax
  6952                                  
  6953                                  ;-179                 if (checkConstSize(disp) ) {
  6954                                  
  6955 000041F1 FF36[BE01]               push word [disp]
  6956 000041F5 E886E2                   call checkConstSize
  6957 000041F8 83C402                   add  sp, 2
  6958 000041FB 08C0                     or  al, al
  6959 000041FD 0F842000                 je @@process273
  6960                                  
  6961                                  ;-180                     genCode2(Code1, 0x70);       
  6962                                  
  6963 00004201 6A70                     push 112
  6964 00004203 A0[B101]                 mov al, byte [Code1]
  6965 00004206 B400                     mov ah, 0
  6966 00004208 50                       push ax
  6967 00004209 E813FA                   call genCode2
  6968 0000420C 83C404                   add  sp, 4
  6969                                  
  6970                                  ;-181                     disp -= 2; 
  6971                                  
  6972 0000420F 832E[BE01]02             sub  word [disp], 2
  6973                                  
  6974                                  ;-182                     genCode8(disp);   
  6975                                  
  6976 00004214 FF36[BE01]               push word [disp]
  6977 00004218 E83BFA                   call genCode8
  6978 0000421B 83C402                   add  sp, 2
  6979                                  
  6980                                  ;-183                 } else {     
  6981                                  
  6982 0000421E E92600                   jmp @@process274
  6983                                  @@process273:
  6984                                  
  6985                                  ;-184                     genCode8(0x0F);
  6986                                  
  6987 00004221 6A0F                     push 15
  6988 00004223 E830FA                   call genCode8
  6989 00004226 83C402                   add  sp, 2
  6990                                  
  6991                                  ;-185                     genCode2(Code1, 0x80);       
  6992                                  
  6993 00004229 688000                   push 128
  6994 0000422C A0[B101]                 mov al, byte [Code1]
  6995 0000422F B400                     mov ah, 0
  6996 00004231 50                       push ax
  6997 00004232 E8EAF9                   call genCode2
  6998 00004235 83C404                   add  sp, 4
  6999                                  
  7000                                  ;-186                     disp -= 4; 
  7001                                  
  7002 00004238 832E[BE01]04             sub  word [disp], 4
  7003                                  
  7004                                  ;-187                     genCode16(disp);                       
  7005                                  
  7006 0000423D FF36[BE01]               push word [disp]
  7007 00004241 E869FA                   call genCode16
  7008 00004244 83C402                   add  sp, 2
  7009                                  
  7010                                  ;-188                 }    
  7011                                  
  7012                                  
  7013                                  ;-189             }
  7014                                  
  7015                                  @@process274:
  7016                                  
  7017                                  ;-190             else {//jump forward
  7018                                  
  7019 00004247 E93900                   jmp @@process275
  7020                                  @@process272:
  7021                                  
  7022                                  ;-191                 genCode8(0x0F);
  7023                                  
  7024 0000424A 6A0F                     push 15
  7025 0000424C E807FA                   call genCode8
  7026 0000424F 83C402                   add  sp, 2
  7027                                  
  7028                                  ;-192                 genCode2(Code1, 0x80);
  7029                                  
  7030 00004252 688000                   push 128
  7031 00004255 A0[B101]                 mov al, byte [Code1]
  7032 00004258 B400                     mov ah, 0
  7033 0000425A 50                       push ax
  7034 0000425B E8C1F9                   call genCode2
  7035 0000425E 83C404                   add  sp, 4
  7036                                  
  7037                                  ;-193                 genCode16(0);
  7038                                  
  7039 00004261 6A00                     push 0
  7040 00004263 E847FA                   call genCode16
  7041 00004266 83C402                   add  sp, 2
  7042                                  
  7043                                  ;-194                 PrintRA='R';
  7044                                  
  7045 00004269 66B852000000             mov eax, 82
  7046 0000426F A2[CB01]                 mov byte [PrintRA], al
  7047                                  
  7048                                  ;-195                 storeJmpCall();
  7049                                  
  7050 00004272 E8E5E3                   call storeJmpCall
  7051                                  
  7052                                  ;-196                 JmpCallRelAbs[JmpCallMaxIx] = 'R';//rel16
  7053                                  
  7054 00004275 66B852000000             mov eax, 82
  7055 0000427B 8B1E[3014]               mov bx, [JmpCallMaxIx]
  7056 0000427F 8887[3C12]               mov [JmpCallRelAbs+bx], al
  7057                                  
  7058                                  ;-197             }   
  7059                                  
  7060                                  
  7061                                  ;-198         }
  7062                                  
  7063                                  @@process275:
  7064                                  
  7065                                  ;-199         return;   
  7066                                  
  7067                                  @@process271:
  7068 00004283 E9F301                   jmp @@retn
  7069                                  
  7070                                  ;-200     }
  7071                                  
  7072                                  
  7073                                  ;-201 
  7074                                  
  7075                                  
  7076                                  ;-202 
  7077                                  
  7078                                  
  7079                                  ;-203     
  7080                                  
  7081                                  
  7082                                  ;-204     if (CodeType ==  8) {//ret,retf
  7083                                  
  7084                                  @@process270:
  7085 00004286 A0[B001]                 mov al, [CodeType]
  7086 00004289 3C08                     cmp al, 8
  7087 0000428B 0F853100                 jne @@process276
  7088                                  
  7089                                  ;-205         if (TokeType == DIGIT) {
  7090                                  
  7091 0000428F A0[AD01]                 mov al, [TokeType]
  7092 00004292 3C01                     cmp al, 1
  7093 00004294 0F851900                 jne @@process277
  7094                                  
  7095                                  ;-206             genCode8(Code2);
  7096                                  
  7097 00004298 A0[B201]                 mov al, byte [Code2]
  7098 0000429B B400                     mov ah, 0
  7099 0000429D 50                       push ax
  7100 0000429E E8B5F9                   call genCode8
  7101 000042A1 83C402                   add  sp, 2
  7102                                  
  7103                                  ;-207             genCode16(SymbolInt);
  7104                                  
  7105 000042A4 FF36[4D00]               push word [SymbolInt]
  7106 000042A8 E802FA                   call genCode16
  7107 000042AB 83C402                   add  sp, 2
  7108                                  
  7109                                  ;-208             return;
  7110                                  
  7111 000042AE E9C801                   jmp @@retn
  7112                                  
  7113                                  ;-209         }
  7114                                  
  7115                                  
  7116                                  ;-210         genCode8(Code1); 
  7117                                  
  7118                                  @@process277:
  7119 000042B1 A0[B101]                 mov al, byte [Code1]
  7120 000042B4 B400                     mov ah, 0
  7121 000042B6 50                       push ax
  7122 000042B7 E89CF9                   call genCode8
  7123 000042BA 83C402                   add  sp, 2
  7124                                  
  7125                                  ;-211         return;
  7126                                  
  7127 000042BD E9B901                   jmp @@retn
  7128                                  
  7129                                  ;-212     }
  7130                                  
  7131                                  
  7132                                  ;-213        
  7133                                  
  7134                                  
  7135                                  ;-214     if (CodeType == 9) {//push, pop  
  7136                                  
  7137                                  @@process276:
  7138 000042C0 A0[B001]                 mov al, [CodeType]
  7139 000042C3 3C09                     cmp al, 9
  7140 000042C5 0F850301                 jne @@process278
  7141                                  
  7142                                  ;-215         getOpL();
  7143                                  
  7144 000042C9 E8C5DD                   call getOpL
  7145                                  
  7146                                  ;-216         if (Code1 == 0x50) {//push only
  7147                                  
  7148 000042CC A0[B101]                 mov al, [Code1]
  7149 000042CF 3C50                     cmp al, 80
  7150 000042D1 0F853D00                 jne @@process279
  7151                                  
  7152                                  ;-217             if (Op == IMM) {//push imm8,16
  7153                                  
  7154 000042D5 A0[AE01]                 mov al, [Op]
  7155 000042D8 3C01                     cmp al, 1
  7156 000042DA 0F853400                 jne @@process280
  7157                                  
  7158                                  ;-218                 setsflag();
  7159                                  
  7160 000042DE E838E1                   call setsflag
  7161                                  
  7162                                  ;-219                 genCode2(0x68, sflag);     
  7163                                  
  7164 000042E1 A0[BB01]                 mov al, byte [sflag]
  7165 000042E4 B400                     mov ah, 0
  7166 000042E6 50                       push ax
  7167 000042E7 6A68                     push 104
  7168 000042E9 E833F9                   call genCode2
  7169 000042EC 83C404                   add  sp, 4
  7170                                  
  7171                                  ;-220                 if (sflag) genCode8 (imme);
  7172                                  
  7173 000042EF A0[BB01]                 mov al, [sflag]
  7174 000042F2 08C0                     or  al, al
  7175 000042F4 0F840D00                 je @@process281
  7176 000042F8 FF36[C001]               push word [imme]
  7177 000042FC E857F9                   call genCode8
  7178 000042FF 83C402                   add  sp, 2
  7179                                  
  7180                                  ;-221                 else       genCode16(imme);    
  7181                                  
  7182 00004302 E90A00                   jmp @@process282
  7183                                  @@process281:
  7184 00004305 FF36[C001]               push word [imme]
  7185 00004309 E8A1F9                   call genCode16
  7186 0000430C 83C402                   add  sp, 2
  7187                                  
  7188                                  ;-222                 return;   
  7189                                  
  7190                                  @@process282:
  7191 0000430F E96701                   jmp @@retn
  7192                                  
  7193                                  ;-223             }   
  7194                                  
  7195                                  
  7196                                  ;-224         }
  7197                                  
  7198                                  @@process280:
  7199                                  
  7200                                  ;-225         if (R1Type == SEGREG) {
  7201                                  
  7202                                  @@process279:
  7203 00004312 A0[B701]                 mov al, [R1Type]
  7204 00004315 3C04                     cmp al, 4
  7205 00004317 0F855A00                 jne @@process283
  7206                                  
  7207                                  ;-226             if (Code1 == 0x58) {
  7208                                  
  7209 0000431B A0[B101]                 mov al, [Code1]
  7210 0000431E 3C58                     cmp al, 88
  7211 00004320 0F851200                 jne @@process284
  7212                                  
  7213                                  ;-227                 if (R1No == 1) error1("pop cs not allowed");   
  7214                                  
  7215 00004324 A0[B501]                 mov al, [R1No]
  7216 00004327 3C01                     cmp al, 1
  7217 00004329 0F850900                 jne @@process285
  7218 0000432D 68[7B44]                 push process_0
  7219 00004330 E847F1                   call error1
  7220 00004333 83C402                   add  sp, 2
  7221                                  
  7222                                  ;-228             }
  7223                                  
  7224                                  @@process285:
  7225                                  
  7226                                  ;-229             c = R1No <<3;
  7227                                  
  7228                                  @@process284:
  7229 00004336 A0[B501]                 mov al, [R1No]
  7230 00004339 C0E003                   shl al, 3
  7231 0000433C 8846FE                   mov byte [bp-2], al
  7232                                  
  7233                                  ;-230             if (R1No > 3) {//FS, GS
  7234                                  
  7235 0000433F A0[B501]                 mov al, [R1No]
  7236 00004342 3C03                     cmp al, 3
  7237 00004344 0F8E0C00                 jle @@process286
  7238                                  
  7239                                  ;-231                 c += 122;
  7240                                  
  7241 00004348 8046FE7A                 add  byte [bp-2], 122
  7242                                  
  7243                                  ;-232                 genCode8(0x0F);
  7244                                  
  7245 0000434C 6A0F                     push 15
  7246 0000434E E805F9                   call genCode8
  7247 00004351 83C402                   add  sp, 2
  7248                                  
  7249                                  ;-233             }
  7250                                  
  7251                                  
  7252                                  ;-234             OpCodePtr++;
  7253                                  
  7254                                  @@process286:
  7255 00004354 FF06[C901]               inc  word [OpCodePtr]
  7256                                  
  7257                                  ;-235             c = c + *OpCodePtr;//is Code4   
  7258                                  
  7259 00004358 8A46FE                   mov al, [bp-2]
  7260 0000435B 8B1E[C901]               mov bx, [OpCodePtr]
  7261 0000435F 0207                     add al, [bx]
  7262 00004361 B400                     mov ah, 0
  7263 00004363 8846FE                   mov byte [bp-2], al
  7264                                  
  7265                                  ;-236             genCode8(c);  
  7266                                  
  7267 00004366 8A46FE                   mov al, byte [bp-2]
  7268 00004369 B400                     mov ah, 0
  7269 0000436B 50                       push ax
  7270 0000436C E8E7F8                   call genCode8
  7271 0000436F 83C402                   add  sp, 2
  7272                                  
  7273                                  ;-237             return; 
  7274                                  
  7275 00004372 E90401                   jmp @@retn
  7276                                  
  7277                                  ;-238         }  
  7278                                  
  7279                                  
  7280                                  ;-239         checkOpL();    
  7281                                  
  7282                                  @@process283:
  7283 00004375 E83CDC                   call checkOpL
  7284                                  
  7285                                  ;-240         if (R1Type == BYTE) reg16error();
  7286                                  
  7287 00004378 A0[B701]                 mov al, [R1Type]
  7288 0000437B 3C01                     cmp al, 1
  7289 0000437D 0F850300                 jne @@process287
  7290 00004381 E866F2                   call reg16error
  7291                                  
  7292                                  ;-241         if (R1Type == WORD) {
  7293                                  
  7294                                  @@process287:
  7295 00004384 A0[B701]                 mov al, [R1Type]
  7296 00004387 3C02                     cmp al, 2
  7297 00004389 0F851500                 jne @@process288
  7298                                  
  7299                                  ;-242             genCode2(Code1, R1No);
  7300                                  
  7301 0000438D A0[B501]                 mov al, byte [R1No]
  7302 00004390 B400                     mov ah, 0
  7303 00004392 50                       push ax
  7304 00004393 A0[B101]                 mov al, byte [Code1]
  7305 00004396 B400                     mov ah, 0
  7306 00004398 50                       push ax
  7307 00004399 E883F8                   call genCode2
  7308 0000439C 83C404                   add  sp, 4
  7309                                  
  7310                                  ;-243             return;   
  7311                                  
  7312 0000439F E9D700                   jmp @@retn
  7313                                  
  7314                                  ;-244         }                
  7315                                  
  7316                                  
  7317                                  ;-245         if (Op == MEM) {
  7318                                  
  7319                                  @@process288:
  7320 000043A2 A0[AE01]                 mov al, [Op]
  7321 000043A5 3C04                     cmp al, 4
  7322 000043A7 0F851B00                 jne @@process289
  7323                                  
  7324                                  ;-246             genCode8(Code2);
  7325                                  
  7326 000043AB A0[B201]                 mov al, byte [Code2]
  7327 000043AE B400                     mov ah, 0
  7328 000043B0 50                       push ax
  7329 000043B1 E8A2F8                   call genCode8
  7330 000043B4 83C402                   add  sp, 2
  7331                                  
  7332                                  ;-247             writeEA(Code3);
  7333                                  
  7334 000043B7 A0[B301]                 mov al, byte [Code3]
  7335 000043BA B400                     mov ah, 0
  7336 000043BC 50                       push ax
  7337 000043BD E80EF9                   call writeEA
  7338 000043C0 83C402                   add  sp, 2
  7339                                  
  7340                                  ;-248             return;   
  7341                                  
  7342 000043C3 E9B300                   jmp @@retn
  7343                                  
  7344                                  ;-249         }
  7345                                  
  7346                                  
  7347                                  ;-250         syntaxerror();
  7348                                  
  7349                                  @@process289:
  7350 000043C6 E870F2                   call syntaxerror
  7351                                  
  7352                                  ;-251         return;        
  7353                                  
  7354 000043C9 E9AD00                   jmp @@retn
  7355                                  
  7356                                  ;-252     }
  7357                                  
  7358                                  
  7359                                  ;-253     
  7360                                  
  7361                                  
  7362                                  ;-254     if (CodeType == 12) {//int
  7363                                  
  7364                                  @@process278:
  7365 000043CC A0[B001]                 mov al, [CodeType]
  7366 000043CF 3C0C                     cmp al, 12
  7367 000043D1 0F852200                 jne @@process290
  7368                                  
  7369                                  ;-255         if (TokeType == DIGIT) {            
  7370                                  
  7371 000043D5 A0[AD01]                 mov al, [TokeType]
  7372 000043D8 3C01                     cmp al, 1
  7373 000043DA 0F851900                 jne @@process291
  7374                                  
  7375                                  ;-256             genCode8(Code1);
  7376                                  
  7377 000043DE A0[B101]                 mov al, byte [Code1]
  7378 000043E1 B400                     mov ah, 0
  7379 000043E3 50                       push ax
  7380 000043E4 E86FF8                   call genCode8
  7381 000043E7 83C402                   add  sp, 2
  7382                                  
  7383                                  ;-257             genCode8(SymbolInt);
  7384                                  
  7385 000043EA FF36[4D00]               push word [SymbolInt]
  7386 000043EE E865F8                   call genCode8
  7387 000043F1 83C402                   add  sp, 2
  7388                                  
  7389                                  ;-258             return;   
  7390                                  
  7391 000043F4 E98200                   jmp @@retn
  7392                                  
  7393                                  ;-259         }
  7394                                  
  7395                                  
  7396                                  ;-260     }
  7397                                  
  7398                                  @@process291:
  7399                                  
  7400                                  ;-261     
  7401                                  
  7402                                  
  7403                                  ;-262     if (CodeType == 30) {//enter i18,i8
  7404                                  
  7405                                  @@process290:
  7406 000043F7 A0[B001]                 mov al, [CodeType]
  7407 000043FA 3C1E                     cmp al, 30
  7408 000043FC 0F855200                 jne @@process292
  7409                                  
  7410                                  ;-263         genCode8(0xC8);
  7411                                  
  7412 00004400 68C800                   push 200
  7413 00004403 E850F8                   call genCode8
  7414 00004406 83C402                   add  sp, 2
  7415                                  
  7416                                  ;-264         Op=getOp1();
  7417                                  
  7418 00004409 E842DD                   call getOp1
  7419 0000440C A2[AE01]                 mov byte [Op], al
  7420                                  
  7421                                  ;-265         if (Op == IMM) genCode16(SymbolInt);
  7422                                  
  7423 0000440F A0[AE01]                 mov al, [Op]
  7424 00004412 3C01                     cmp al, 1
  7425 00004414 0F850D00                 jne @@process293
  7426 00004418 FF36[4D00]               push word [SymbolInt]
  7427 0000441C E88EF8                   call genCode16
  7428 0000441F 83C402                   add  sp, 2
  7429                                  
  7430                                  ;-266         else numbererror();
  7431                                  
  7432 00004422 E90300                   jmp @@process294
  7433                                  @@process293:
  7434 00004425 E87EF1                   call numbererror
  7435                                  
  7436                                  ;-267         need(',');
  7437                                  
  7438                                  @@process294:
  7439 00004428 6A2C                     push 44
  7440 0000442A E824E6                   call need
  7441 0000442D 83C402                   add  sp, 2
  7442                                  
  7443                                  ;-268         Op=getOp1();
  7444                                  
  7445 00004430 E81BDD                   call getOp1
  7446 00004433 A2[AE01]                 mov byte [Op], al
  7447                                  
  7448                                  ;-269         if (Op == IMM) genCode8 (SymbolInt);
  7449                                  
  7450 00004436 A0[AE01]                 mov al, [Op]
  7451 00004439 3C01                     cmp al, 1
  7452 0000443B 0F850D00                 jne @@process295
  7453 0000443F FF36[4D00]               push word [SymbolInt]
  7454 00004443 E810F8                   call genCode8
  7455 00004446 83C402                   add  sp, 2
  7456                                  
  7457                                  ;-270         else numbererror();           
  7458                                  
  7459 00004449 E90300                   jmp @@process296
  7460                                  @@process295:
  7461 0000444C E857F1                   call numbererror
  7462                                  
  7463                                  ;-271         return;
  7464                                  
  7465                                  @@process296:
  7466 0000444F E92700                   jmp @@retn
  7467                                  
  7468                                  ;-272     }
  7469                                  
  7470                                  
  7471                                  ;-273        
  7472                                  
  7473                                  
  7474                                  ;-274     if (CodeType==101) {// ORG nn
  7475                                  
  7476                                  @@process292:
  7477 00004452 A0[B001]                 mov al, [CodeType]
  7478 00004455 3C65                     cmp al, 101
  7479 00004457 0F851500                 jne @@process297
  7480                                  
  7481                                  ;-275         if (TokeType != DIGIT) numbererror();
  7482                                  
  7483 0000445B A0[AD01]                 mov al, [TokeType]
  7484 0000445E 3C01                     cmp al, 1
  7485 00004460 0F840300                 je  @@process298
  7486 00004464 E83FF1                   call numbererror
  7487                                  
  7488                                  ;-276         Origin=SymbolInt;
  7489                                  
  7490                                  @@process298:
  7491 00004467 A1[4D00]                 mov ax, [SymbolInt]
  7492 0000446A A3[A801]                 mov word [Origin], ax
  7493                                  
  7494                                  ;-277         return;
  7495                                  
  7496 0000446D E90900                   jmp @@retn
  7497                                  
  7498                                  ;-278     }
  7499                                  
  7500                                  
  7501                                  ;-279     error1("Command not implemented or syntax error");
  7502                                  
  7503                                  @@process297:
  7504 00004470 68[8E44]                 push process_1
  7505 00004473 E804F0                   call error1
  7506 00004476 83C402                   add  sp, 2
  7507                                  
  7508                                  ;-280 }    
  7509                                  
  7510 00004479 C9                      @@retn: LEAVE
  7511 0000447A C3                       ret
  7512                                  ; ENDP
  7513 0000447B 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  7514 00004484 7420616C6C6F776564-
  7515 0000448D 00                 
  7516 0000448E 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  7517 00004497 6F7420696D706C656D-
  7518 000044A0 656E746564206F7220-
  7519 000044A9 73796E746178206572-
  7520 000044B2 726F7200           
  7521                                   
  7522                                  ; missing functions: 
  7523                                  ; digit
  7524                                  ; strcpy
  7525                                  ; strcpy
  7526                                  ; eqstr
  7527                                  ; strlen
  7528                                  ; eqstr
  7529                                  ; eqstr
  7530                                  ; eqstr
  7531                                  ; eqstr
  7532                                  ; readRL
  7533                                  ; readRL
  7534                                  ; digit
  7535                                  ; digit
  7536                                  ; strcpy
  7537                                  ; toupper
  7538                                  ; strlen
  7539                                  ; strlen
  7540                                  ; eqstr
  7541                                  ; eqstr
  7542                                  ; eqstr
  7543                                  ; eqstr
  7544                                  ; eqstr
  7545                                  ; eqstr
  7546                                  ; eqstr
  7547                                  ; eqstr
  7548                                  ; eqstr
  7549                                  ; eqstr
  7550                                  ; eqstr
  7551                                  ; eqstr
  7552                                  ; eqstr
  7553                                  ; eqstr
  7554                                  ; eqstr
  7555                                  ; eqstr
  7556                                  ; eqstr
  7557                                  ; eqstr
  7558                                  ; eqstr
  7559                                  ; eqstr
  7560                                  ; eqstr
  7561                                  ; eqstr
  7562                                  ; eqstr
  7563                                  ; eqstr
  7564                                  ; eqstr
  7565                                  ; eqstr
  7566                                  ; eqstr
  7567                                  ; eqstr
  7568                                  ; eqstr
  7569                                  ; eqstr
  7570                                  ; writetty
  7571                                  ; writetty
  7572                                  ; fputcR
  7573                                  ; cputs
  7574                                  ; cputs
  7575                                  ; exitR
  7576                                  ; toupper
  7577                                  ; strcpy
  7578                                  ; strcat1
  7579                                  ; strcpy
  7580                                  ; strcat1
  7581                                  ; strcpy
  7582                                  ; strcat1
  7583                                  ; openR
  7584                                  ; cputs
  7585                                  ; cputs
  7586                                  ; exitR
  7587                                  ; creatR
  7588                                  ; cputs
  7589                                  ; cputs
  7590                                  ; exitR
  7591                                  ; creatR
  7592                                  ; cputs
  7593                                  ; cputs
  7594                                  ; exitR
  7595                                  ; strcpy
  7596                                  ; strlen
  7597                                  ; fputcR
  7598                                  ; strlen
  7599                                  ; fcloseR
  7600                                  ; fcloseR
  7601                                  ; fcloseR
  7602                                  ; exitR
  7603                                  ; Number of unresolved CALLs :   80
  7604                                  ;use archive file: AR.C
  7605                                  
  7606                                  ;-281 // AR.C Archive
  7607                                  
  7608                                  ;Number of CALLs:    2 : writetty
  7609                                  
  7610                                  writetty:  ; *** PROC ***
  7611 000044B6 B40E                     mov  ah, 14
  7612 000044B8 BB0000                   mov  bx, 0
  7613 000044BB CD10                     int  16
  7614                                  
  7615                                  ;-282 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  7616                                  
  7617 000044BD C3                       ret
  7618                                  ; ENDP
  7619                                  ;Number of CALLs:    8 : cputs
  7620                                  
  7621                                  cputs:  ; *** PROC ***
  7622                                  ;Function : cputs, Number of local variables: 2
  7623                                  ;   # type sign width line used address name   list of local variables
  7624                                  ;  200 ptr sign byte   282 NULL bp+4    s
  7625                                  ;  201 var sign byte   282 NULL bp-2    c;
  7626 000044BE C8020000                 ENTER  2,0
  7627                                  @@cputs299:
  7628 000044C2 8B5E04                   mov bx, [bp+4]
  7629 000044C5 8A07                     mov al, [bx]
  7630 000044C7 B400                     mov ah, 0
  7631 000044C9 08C0                     or  al, al
  7632 000044CB 0F841B00                 je @@cputs300
  7633 000044CF 8B5E04                   mov bx, [bp+4]
  7634 000044D2 8A07                     mov al, [bx]
  7635 000044D4 B400                     mov ah, 0
  7636 000044D6 8846FE                   mov byte [bp-2], al
  7637 000044D9 8A46FE                   mov al, byte [bp-2]
  7638 000044DC B400                     mov ah, 0
  7639 000044DE 50                       push ax
  7640 000044DF E8C401                   call putch
  7641 000044E2 83C402                   add  sp, 2
  7642 000044E5 FF4604                   inc  word [bp+4]
  7643 000044E8 EBD8                     jmp @@cputs299
  7644                                  @@cputs300:
  7645                                  
  7646                                  ;-283 int mkneg(int n) { n; __asm {neg ax} }
  7647 000044EA C9                       LEAVE
  7648 000044EB C3                       ret
  7649                                  ; ENDP
  7650                                  ;Number of CALLs:    2 : toupper
  7651                                  
  7652                                  toupper:  ; *** PROC ***
  7653                                  ;Function : toupper, Number of local variables: 1
  7654                                  ;   # type sign width line used address name   list of local variables
  7655                                  ;  200 ptr sign byte   283 NULL bp+4    s;
  7656 000044EC C8000000                 ENTER  0,0
  7657                                  @@toupper301:
  7658 000044F0 8B5E04                   mov bx, [bp+4]
  7659 000044F3 8A07                     mov al, [bx]
  7660 000044F5 B400                     mov ah, 0
  7661 000044F7 08C0                     or  al, al
  7662 000044F9 0F843000                 je @@toupper302
  7663 000044FD 8B5E04                   mov bx, [bp+4]
  7664 00004500 8A07                     mov al, [bx]
  7665 00004502 B400                     mov ah, 0
  7666 00004504 83F861                   cmp ax, 97 ;unsigned : 1
  7667 00004507 0F8C1D00                 jl  @@toupper303
  7668 0000450B 8B5E04                   mov bx, [bp+4]
  7669 0000450E 8A07                     mov al, [bx]
  7670 00004510 B400                     mov ah, 0
  7671 00004512 83F87A                   cmp ax, 122
  7672 00004515 0F8F0F00                 jg  @@toupper304
  7673 00004519 8B5E04                   mov bx, [bp+4]
  7674 0000451C 8A07                     mov al, [bx]
  7675 0000451E B400                     mov ah, 0
  7676 00004520 83E820                   sub ax, 32
  7677 00004523 8B5E04                   mov  bx, [bp+4]
  7678 00004526 8807                     mov  [bx], al
  7679                                  @@toupper304:
  7680                                  @@toupper303:
  7681 00004528 FF4604                   inc  word [bp+4]
  7682 0000452B EBC3                     jmp @@toupper301
  7683                                  @@toupper302:
  7684                                  
  7685                                  ;-284 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  7686                                  
  7687                                  
  7688                                  ;-285 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  7689 0000452D C9                       LEAVE
  7690 0000452E C3                       ret
  7691                                  ; ENDP
  7692                                  ;Number of CALLs:    5 : strlen
  7693                                  
  7694                                  strlen:  ; *** PROC ***
  7695                                  ;Function : strlen, Number of local variables: 2
  7696                                  ;   # type sign width line used address name   list of local variables
  7697                                  ;  200 ptr sign byte   285 NULL bp+4    s
  7698                                  ;  201 var sign word   285 NULL bp-2    c;
  7699 0000452F C8020000                 ENTER  2,0
  7700 00004533 66B800000000             mov eax, 0
  7701 00004539 8946FE                   mov word [bp-2], ax
  7702                                  @@strlen305:
  7703 0000453C 8B5E04                   mov bx, [bp+4]
  7704 0000453F 8A07                     mov al, [bx]
  7705 00004541 B400                     mov ah, 0
  7706 00004543 83F800                   cmp ax, 0
  7707 00004546 0F840800                 je  @@strlen306
  7708 0000454A FF4604                   inc  word [bp+4]
  7709 0000454D FF46FE                   inc  word [bp-2]
  7710 00004550 EBEA                     jmp @@strlen305
  7711                                  @@strlen306:
  7712 00004552 8B46FE                   mov ax, [bp-2]
  7713 00004555 E90000                   jmp @@retn
  7714                                  
  7715                                  ;-286 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  7716                                  
  7717 00004558 C9                      @@retn: LEAVE
  7718 00004559 C3                       ret
  7719                                  ; ENDP
  7720                                  ;Number of CALLs:    7 : strcpy
  7721                                  
  7722                                  strcpy:  ; *** PROC ***
  7723                                  ;Function : strcpy, Number of local variables: 2
  7724                                  ;   # type sign width line used address name   list of local variables
  7725                                  ;  200 ptr sign byte   286 NULL bp+4    s
  7726                                  ;  201 ptr sign byte   286 NULL bp+6    t;
  7727 0000455A C8000000                 ENTER  0,0
  7728                                  @@strcpy307:
  7729 0000455E 8B5E06                   mov bx, [bp+6]
  7730 00004561 8A07                     mov al, [bx]
  7731 00004563 B400                     mov ah, 0
  7732 00004565 8B5E04                   mov  bx, [bp+4]
  7733 00004568 8807                     mov  [bx], al
  7734 0000456A FF4604                   inc  word [bp+4]
  7735 0000456D FF4606                   inc  word [bp+6]
  7736                                  
  7737                                  ;-287   while (*t!=0); *s=0; return s; }
  7738                                  
  7739 00004570 8B5E06                   mov bx, [bp+6]
  7740 00004573 8A07                     mov al, [bx]
  7741 00004575 B400                     mov ah, 0
  7742 00004577 83F800                   cmp ax, 0
  7743 0000457A 0F840200                 je  @@strcpy308
  7744 0000457E EBDE                     jmp @@strcpy307
  7745                                  @@strcpy308:
  7746 00004580 66B800000000             mov eax, 0
  7747 00004586 8B5E04                   mov  bx, [bp+4]
  7748 00004589 8807                     mov  [bx], al
  7749 0000458B 8B4604                   mov ax, [bp+4]
  7750 0000458E E90000                   jmp @@retn
  7751                                  
  7752                                  ;-288 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  7753                                  
  7754 00004591 C9                      @@retn: LEAVE
  7755 00004592 C3                       ret
  7756                                  ; ENDP
  7757                                  ;Number of CALLs:    3 : digit
  7758                                  
  7759                                  digit:  ; *** PROC ***
  7760                                  ;Function : digit, Number of local variables: 1
  7761                                  ;   # type sign width line used address name   list of local variables
  7762                                  ;  200 var sign byte   288 NULL bp+4    c;
  7763 00004593 C8000000                 ENTER  0,0
  7764 00004597 8A4604                   mov al, [bp+4]
  7765 0000459A 3C30                     cmp al, 48
  7766 0000459C 0F8D0900                 jge @@digit309
  7767 000045A0 66B800000000             mov eax, 0
  7768 000045A6 E91B00                   jmp @@retn
  7769                                  @@digit309:
  7770 000045A9 8A4604                   mov al, [bp+4]
  7771 000045AC 3C39                     cmp al, 57
  7772 000045AE 0F8E0900                 jle @@digit310
  7773 000045B2 66B800000000             mov eax, 0
  7774 000045B8 E90900                   jmp @@retn
  7775                                  @@digit310:
  7776 000045BB 66B801000000             mov eax, 1
  7777 000045C1 E90000                   jmp @@retn
  7778                                  
  7779                                  ;-289 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  7780                                  
  7781 000045C4 C9                      @@retn: LEAVE
  7782 000045C5 C3                       ret
  7783                                  ; ENDP
  7784                                  ;Number of CALLs:   35 : eqstr
  7785                                  
  7786                                  eqstr:  ; *** PROC ***
  7787                                  ;Function : eqstr, Number of local variables: 2
  7788                                  ;   # type sign width line used address name   list of local variables
  7789                                  ;  200 ptr sign byte   289 NULL bp+4    p
  7790                                  ;  201 ptr sign byte   289 NULL bp+6    q;
  7791 000045C6 C8000000                 ENTER  0,0
  7792                                  @@eqstr311:
  7793 000045CA 8B5E04                   mov bx, [bp+4]
  7794 000045CD 8A07                     mov al, [bx]
  7795 000045CF B400                     mov ah, 0
  7796 000045D1 08C0                     or  al, al
  7797 000045D3 0F842300                 je @@eqstr312
  7798                                  
  7799                                  ;-290     if (*p != *q) return 0; p++; q++; }
  7800                                  
  7801 000045D7 8B5E04                   mov bx, [bp+4]
  7802 000045DA 8A07                     mov al, [bx]
  7803 000045DC B400                     mov ah, 0
  7804 000045DE 8B5E06                   mov bx, [bp+6]
  7805 000045E1 3A07                     cmp al, [bx]
  7806 000045E3 B400                     mov ah, 0
  7807 000045E5 0F840900                 je  @@eqstr313
  7808 000045E9 66B800000000             mov eax, 0
  7809 000045EF E92700                   jmp @@retn
  7810                                  @@eqstr313:
  7811 000045F2 FF4604                   inc  word [bp+4]
  7812 000045F5 FF4606                   inc  word [bp+6]
  7813                                  
  7814                                  ;-291     if(*q) return 0; return 1; }
  7815                                  
  7816 000045F8 EBD0                     jmp @@eqstr311
  7817                                  @@eqstr312:
  7818 000045FA 8B5E06                   mov bx, [bp+6]
  7819 000045FD 8A07                     mov al, [bx]
  7820 000045FF B400                     mov ah, 0
  7821 00004601 08C0                     or  al, al
  7822 00004603 0F840900                 je @@eqstr314
  7823 00004607 66B800000000             mov eax, 0
  7824 0000460D E90900                   jmp @@retn
  7825                                  @@eqstr314:
  7826 00004610 66B801000000             mov eax, 1
  7827 00004616 E90000                   jmp @@retn
  7828                                  
  7829                                  ;-292 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  7830                                  
  7831 00004619 C9                      @@retn: LEAVE
  7832 0000461A C3                       ret
  7833                                  ; ENDP
  7834                                  ;Number of CALLs:    3 : strcat1
  7835                                  
  7836                                  strcat1:  ; *** PROC ***
  7837                                  ;Function : strcat1, Number of local variables: 2
  7838                                  ;   # type sign width line used address name   list of local variables
  7839                                  ;  200 ptr sign byte   292 NULL bp+4    s
  7840                                  ;  201 ptr sign byte   292 NULL bp+6    t;
  7841 0000461B C8000000                 ENTER  0,0
  7842                                  @@strcat1315:
  7843 0000461F 8B5E04                   mov bx, [bp+4]
  7844 00004622 8A07                     mov al, [bx]
  7845 00004624 B400                     mov ah, 0
  7846 00004626 83F800                   cmp ax, 0
  7847 00004629 0F840500                 je  @@strcat1316
  7848 0000462D FF4604                   inc  word [bp+4]
  7849 00004630 EBED                     jmp @@strcat1315
  7850                                  @@strcat1316:
  7851 00004632 FF7606                   push word [bp+6]
  7852 00004635 FF7604                   push word [bp+4]
  7853 00004638 E81FFF                   call strcpy
  7854 0000463B 83C404                   add  sp, 4
  7855                                  
  7856                                  ;-293 int basename(char *s) { char *p; p=0;
  7857 0000463E C9                       LEAVE
  7858 0000463F C3                       ret
  7859                                  ; ENDP
  7860                                  ;Number of CALLs:    1 : openR
  7861                                  
  7862                                  openR:  ; *** PROC ***
  7863                                  ;Function : openR, Number of local variables: 1
  7864                                  ;   # type sign width line used address name   list of local variables
  7865                                  ;  200 ptr sign byte   293 NULL bp+4    s;
  7866 00004640 C8000000                 ENTER  0,0
  7867 00004644 8B5604                   mov  dx, [bp+4]
  7868 00004647 B8023D                   mov  ax, 15618
  7869 0000464A E87200                   call DosInt
  7870                                  
  7871                                  ;-294 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  7872 0000464D C9                       LEAVE
  7873 0000464E C3                       ret
  7874                                  ; ENDP
  7875                                  ;Number of CALLs:    2 : creatR
  7876                                  
  7877                                  creatR:  ; *** PROC ***
  7878                                  ;Function : creatR, Number of local variables: 1
  7879                                  ;   # type sign width line used address name   list of local variables
  7880                                  ;  200 ptr sign byte   294 NULL bp+4    s;
  7881 0000464F C8000000                 ENTER  0,0
  7882 00004653 8B5604                   mov  dx, [bp+4]
  7883 00004656 B90000                   mov  cx, 0
  7884 00004659 B8003C                   mov  ax, 15360
  7885 0000465C E86000                   call DosInt
  7886                                  
  7887                                  ;-295 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  7888 0000465F C9                       LEAVE
  7889 00004660 C3                       ret
  7890                                  ; ENDP
  7891                                  ;Number of CALLs:    2 : readRL
  7892                                  
  7893                                  readRL:  ; *** PROC ***
  7894                                  ;Function : readRL, Number of local variables: 3
  7895                                  ;   # type sign width line used address name   list of local variables
  7896                                  ;  200 ptr sign byte   295 NULL bp+4    s
  7897                                  ;  201 var sign word   295 NULL bp+6    fd
  7898                                  ;  202 var sign word   295 NULL bp+8    len;
  7899 00004661 C8000000                 ENTER  0,0
  7900 00004665 8B5604                   mov  dx, [bp+4]
  7901 00004668 8B4E08                   mov  cx, [bp+8]
  7902 0000466B 8B5E06                   mov  bx, [bp+6]
  7903 0000466E B8003F                   mov  ax, 16128
  7904 00004671 E84B00                   call DosInt
  7905                                  
  7906                                  ;-296 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  7907 00004674 C9                       LEAVE
  7908 00004675 C3                       ret
  7909                                  ; ENDP
  7910                                  ;Number of CALLs:    2 : fputcR
  7911                                  
  7912                                  fputcR:  ; *** PROC ***
  7913                                  ;Function : fputcR, Number of local variables: 2
  7914                                  ;   # type sign width line used address name   list of local variables
  7915                                  ;  200 ptr sign byte   296 NULL bp+4    n
  7916                                  ;  201 var sign word   296 NULL bp+6    fd;
  7917 00004676 C8000000                 ENTER  0,0
  7918 0000467A 8D5604                  lea dx, [bp+4]
  7919                                  
  7920                                  ;-297   cx=1; bx=fd; ax=0x4000; DosInt(); }
  7921                                  
  7922 0000467D B90100                   mov  cx, 1
  7923 00004680 8B5E06                   mov  bx, [bp+6]
  7924 00004683 B80040                   mov  ax, 16384
  7925 00004686 E83600                   call DosInt
  7926                                  
  7927                                  ;-298 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  7928 00004689 C9                       LEAVE
  7929 0000468A C3                       ret
  7930                                  ; ENDP
  7931                                  ;Number of CALLs:    3 : fcloseR
  7932                                  
  7933                                  fcloseR:  ; *** PROC ***
  7934                                  ;Function : fcloseR, Number of local variables: 1
  7935                                  ;   # type sign width line used address name   list of local variables
  7936                                  ;  200 var sign word   298 NULL bp+4    fd;
  7937 0000468B C8000000                 ENTER  0,0
  7938 0000468F 8B5E04                   mov  bx, [bp+4]
  7939 00004692 B8003E                   mov  ax, 15872
  7940 00004695 CD21                     int  33
  7941                                  
  7942                                  ;-299 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  7943 00004697 C9                       LEAVE
  7944 00004698 C3                       ret
  7945                                  ; ENDP
  7946                                  ;Number of CALLs:    5 : exitR
  7947                                  
  7948                                  exitR:  ; *** PROC ***
  7949                                  ;Function : exitR, Number of local variables: 1
  7950                                  ;   # type sign width line used address name   list of local variables
  7951                                  ;  200 var sign byte   299 NULL bp+4    c;
  7952 00004699 C8000000                 ENTER  0,0
  7953 0000469D B44C                     mov  ah, 76
  7954 0000469F 8A4604                   mov  al, [bp+4]
  7955 000046A2 CD21                     int  33
  7956                                  
  7957                                  ;-300 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  7958 000046A4 C9                       LEAVE
  7959 000046A5 C3                       ret
  7960                                  ; ENDP
  7961                                  ;End of archive file. 
  7962                                   
  7963                                  ; missing functions: 
  7964                                  ; putch
  7965                                  ; DosInt
  7966                                  ; DosInt
  7967                                  ; DosInt
  7968                                  ; DosInt
  7969                                  ; Number of unresolved CALLs :    5
  7970                                  ;use archive file: AR.C
  7971                                  
  7972                                  ;-301 // AR.C Archive
  7973                                  
  7974                                  ;Number of CALLs:    1 : putch
  7975                                  
  7976                                  putch:  ; *** PROC ***
  7977                                  ;Function : putch, Number of local variables: 1
  7978                                  ;   # type sign width line used address name   list of local variables
  7979                                  ;  200 var sign byte   301 NULL bp+4    c;
  7980 000046A6 C8000000                 ENTER  0,0
  7981 000046AA 807E040A                cmp byte [bp+4], 10
  7982 000046AE 0F850500                 jne @@putch317
  7983 000046B2 B00D                     mov  al, 13
  7984 000046B4 E8FFFD                   call writetty
  7985                                  @@putch317:
  7986 000046B7 8A4604                   mov  al, [bp+4]
  7987 000046BA E8F9FD                   call writetty
  7988                                  
  7989                                  ;-302 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  7990 000046BD C9                       LEAVE
  7991 000046BE C3                       ret
  7992                                  ; ENDP
  7993                                  ;Number of CALLs:    4 : DosInt
  7994                                  
  7995                                  DosInt:  ; *** PROC ***
  7996 000046BF CD21                     int  33
  7997 000046C1 7304                     jae short @@DosInt318
  7998 000046C3 FF06[9F01]               inc  word [DOS_ERR]
  7999                                  @@DosInt318:
  8000                                  
  8001                                  ;-303 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  8002                                  
  8003 000046C7 C3                       ret
  8004                                  ; ENDP
  8005                                  ;End of archive file. 
  8006                                   
  8007                                  ; missing functions:  All FUNCTIONs in place
  8008 000046C8 E80000                  LastFunctionByt:db 0E8h, 0, 0
  8009 000046CB 58                      pop ax
  8010 000046CC C3                      ret
  8011                                   
  8012                                  ;   # type sign width line used  address name   list of global variables
  8013                                  
  8014                                  ;    1 arr sign byte     1    2        0 Version1[10]
  8015                                  ;    2 var sign byte     1    3        0 LIST
  8016                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  8017                                  ;    4 arr sign byte     3   12        0 Symbol[31]
  8018                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  8019                                  ;    6 var unsg word     5   15        0 SymbolInt
  8020                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  8021                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  8022                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  8023                                  ;   10 arr sign byte     9    5        0 namein[67]
  8024                                  ;   11 arr sign byte    10    6        0 namelst[67]
  8025                                  ;   12 arr sign byte    11    6        0 namebin[67]
  8026                                  ;   13 var sign word    12    4        0 asm_fd
  8027                                  ;   14 var sign word    13    3        0 lst_fd
  8028                                  ;   15 var sign word    14    3        0 bin_fd
  8029                                  ;   16 var sign word    15    6        0 DOS_ERR
  8030                                  ;   17 var sign word    16    4        0 ErrorCount
  8031                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  8032                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  8033                                  ;   20 var unsg word    20    6        0 PC
  8034                                  ;   21 var unsg word    21    4        0 Origin
  8035                                  ;   22 var unsg word    22    2        0 PCStart
  8036                                  ;   23 var sign byte    23    3        0 isLabel
  8037                                  ;   24 def unsg byte    24    -        0 DIGIT=1
  8038                                  ;   25 def unsg byte    25    -        0 LETTERE=2
  8039                                  ;   26 def unsg byte    26    -        0 ALNUME=3
  8040                                  ;   27 def unsg byte    27    -        0 NOALNUME=4
  8041                                  ;   28 var sign byte    28   23        0 TokeType
  8042                                  ;   29 def unsg byte    29    -        0 BYTE=1
  8043                                  ;   30 def unsg byte    30    -        0 WORD=2
  8044                                  ;   31 def unsg byte    31    -        0 DWORD=3
  8045                                  ;   32 def unsg byte    32    -        0 SEGREG=4
  8046                                  ;   33 def unsg byte    33    -        0 IMM=1
  8047                                  ;   34 def unsg byte    34    -        0 REG=2
  8048                                  ;   35 def unsg byte    35    -        0 ADR=3
  8049                                  ;   36 def unsg byte    36    -        0 MEM=4
  8050                                  ;   37 var sign byte    37   28        0 Op
  8051                                  ;   38 var sign byte    38   29        0 Op2
  8052                                  ;   39 var sign byte    39   19        0 CodeType
  8053                                  ;   40 var sign byte    40   16        0 Code1
  8054                                  ;   41 var sign byte    41    7        0 Code2
  8055                                  ;   42 var sign byte    42    3        0 Code3
  8056                                  ;   43 var sign byte    43   18        0 R2No
  8057                                  ;   44 var sign byte    44   16        0 R1No
  8058                                  ;   45 var sign byte    45   17        0 R2Type
  8059                                  ;   46 var sign byte    46   14        0 R1Type
  8060                                  ;   47 var sign byte    47   13        0 OpSize
  8061                                  ;   48 var sign byte    48    8        0 wflag
  8062                                  ;   49 var sign byte    49    3        0 dflag
  8063                                  ;   50 var sign byte    50    8        0 sflag
  8064                                  ;   51 var sign byte    51   15        0 rm
  8065                                  ;   52 var sign byte    52    5        0 isDirect
  8066                                  ;   53 var sign word    53   36        0 disp
  8067                                  ;   54 var unsg word    54   10        0 imme
  8068                                  ;   55 def unsg byte    56    -        0 OPMAXLEN=5
  8069                                  ;   56 arr sign byte    57    2        0 OpPos[5]
  8070                                  ;   57 var sign word    58    6        0 OpPrintIndex
  8071                                  ;   58 ptr sign byte    59   19        0 OpCodePtr
  8072                                  ;   59 var sign byte    60    3        0 PrintRA
  8073                                  ;   60 def unsg byte    62    -        0 LABELNAMESMAX=969
  8074                                  ;   61 arr sign byte    63    4        0 LabelNames[1000]
  8075                                  ;   62 ptr sign byte    64   11        0 LabelNamePtr
  8076                                  ;   63 def unsg byte    65    -        0 LABELADRMAX=100
  8077                                  ;   64 arr unsg word    66    6        0 LabelAddr[100]
  8078                                  ;   65 var sign word    67    7        0 LabelMaxIx
  8079                                  ;   66 var sign word    68    7        0 LabelIx
  8080                                  ;   67 def unsg byte    70    -        0 JMPCALLMAX=500
  8081                                  ;   68 def unsg byte    71    -        0 JMPCALLNAMESMAX=1969
  8082                                  ;   69 arr sign byte    72    3        0 JmpCallNames[2000]
  8083                                  ;   70 ptr sign byte    73    5        0 JmpCallNamePtr
  8084                                  ;   71 arr unsg word    74    2        0 JmpCallAddr[500]
  8085                                  ;   72 arr sign byte    75    3        0 JmpCallRelAbs[500]
  8086                                  ;   73 var sign word    76    8        0 JmpCallMaxIx
  8087                                  ;   74 def unsg byte    78    -        0 FILEBINMAX=2000
  8088                                  ;   75 arr sign byte    79    4        0 FileBin[2000]
  8089                                  ;   76 var unsg word    80    6        0 BinLen
  8090                                  ;   77 ptr sign byte    82    1        0 arglen
  8091                                  ;   78 ptr sign byte    83    4        0 argv
  8092                                  ;   79 var sign byte     1    1        0 I_START
  8093                                  ;   80 arr sign byte     4 NULL        0 I_PUSHA[9]
  8094                                  ;   81 arr sign byte     5 NULL        0 I_POPA[8]
  8095                                  ;   82 arr sign byte     6 NULL        0 I_NOP[7]
  8096                                  ;   83 arr sign byte     7 NULL        0 I_CBW[7]
  8097                                  ;   84 arr sign byte     8 NULL        0 I_CWDE[8]
  8098                                  ;   85 arr sign byte     9 NULL        0 I_CWD[7]
  8099                                  ;   86 arr sign byte    10 NULL        0 I_CDQ[7]
  8100                                  ;   87 arr sign byte    11 NULL        0 I_WAIT[8]
  8101                                  ;   88 arr sign byte    12 NULL        0 I_PUSHF[9]
  8102                                  ;   89 arr sign byte    13 NULL        0 I_POPF[8]
  8103                                  ;   90 arr sign byte    14 NULL        0 I_SAHF[8]
  8104                                  ;   91 arr sign byte    15 NULL        0 I_LAHF[8]
  8105                                  ;   92 arr sign byte    16 NULL        0 I_MOVSB[9]
  8106                                  ;   93 arr sign byte    17 NULL        0 I_MOVSW[9]
  8107                                  ;   94 arr sign byte    18 NULL        0 I_CMPSB[9]
  8108                                  ;   95 arr sign byte    19 NULL        0 I_CMPSW[9]
  8109                                  ;   96 arr sign byte    20 NULL        0 I_STOSB[9]
  8110                                  ;   97 arr sign byte    21 NULL        0 I_STOSW[9]
  8111                                  ;   98 arr sign byte    22 NULL        0 I_LODSB[9]
  8112                                  ;   99 arr sign byte    23 NULL        0 I_LODSW[9]
  8113                                  ;  100 arr sign byte    24 NULL        0 I_SCASB[9]
  8114                                  ;  101 arr sign byte    25 NULL        0 I_SCASW[9]
  8115                                  ;  102 arr sign byte    26 NULL        0 I_LEAVE[9]
  8116                                  ;  103 arr sign byte    27 NULL        0 I_INT3[8]
  8117                                  ;  104 arr sign byte    28 NULL        0 I_INTO[8]
  8118                                  ;  105 arr sign byte    29 NULL        0 I_IRET[8]
  8119                                  ;  106 arr sign byte    30 NULL        0 I_XLAT[8]
  8120                                  ;  107 arr sign byte    31 NULL        0 I_LOCK[8]
  8121                                  ;  108 arr sign byte    32 NULL        0 I_REPNE[9]
  8122                                  ;  109 arr sign byte    33 NULL        0 I_REPNZ[9]
  8123                                  ;  110 arr sign byte    34 NULL        0 I_REPE[8]
  8124                                  ;  111 arr sign byte    35 NULL        0 I_REPZ[8]
  8125                                  ;  112 arr sign byte    36 NULL        0 I_HLT[7]
  8126                                  ;  113 arr sign byte    37 NULL        0 I_CLC[7]
  8127                                  ;  114 arr sign byte    38 NULL        0 I_STC[7]
  8128                                  ;  115 arr sign byte    39 NULL        0 I_CLI[7]
  8129                                  ;  116 arr sign byte    40 NULL        0 I_STI[7]
  8130                                  ;  117 arr sign byte    41 NULL        0 I_CLD[7]
  8131                                  ;  118 arr sign byte    42 NULL        0 I_STD[7]
  8132                                  ;  119 arr sign byte    44 NULL        0 I_INC[9]
  8133                                  ;  120 arr sign byte    45 NULL        0 I_DEC[9]
  8134                                  ;  121 arr sign byte    46 NULL        0 I_NOT[8]
  8135                                  ;  122 arr sign byte    47 NULL        0 I_NEG[8]
  8136                                  ;  123 arr sign byte    48 NULL        0 I_MUL[8]
  8137                                  ;  124 arr sign byte    49 NULL        0 I_IMUL[9]
  8138                                  ;  125 arr sign byte    50 NULL        0 I_DIV[8]
  8139                                  ;  126 arr sign byte    51 NULL        0 I_IDIV[9]
  8140                                  ;  127 arr sign byte    53 NULL        0 I_LES[7]
  8141                                  ;  128 arr sign byte    54 NULL        0 I_LDS[7]
  8142                                  ;  129 arr sign byte    55 NULL        0 I_LEA[7]
  8143                                  ;  130 arr sign byte    56 NULL        0 I_LSS[8]
  8144                                  ;  131 arr sign byte    57 NULL        0 I_LFS[8]
  8145                                  ;  132 arr sign byte    58 NULL        0 I_LGS[8]
  8146                                  ;  133 arr sign byte    60 NULL        0 I_ADD[7]
  8147                                  ;  134 arr sign byte    61 NULL        0 I_OR[6]
  8148                                  ;  135 arr sign byte    62 NULL        0 I_ADC[7]
  8149                                  ;  136 arr sign byte    63 NULL        0 I_SBB[7]
  8150                                  ;  137 arr sign byte    64 NULL        0 I_AND[7]
  8151                                  ;  138 arr sign byte    65 NULL        0 I_SUB[7]
  8152                                  ;  139 arr sign byte    66 NULL        0 I_XOR[7]
  8153                                  ;  140 arr sign byte    67 NULL        0 I_CMP[7]
  8154                                  ;  141 arr sign byte    68 NULL        0 I_TEST[11]
  8155                                  ;  142 arr sign byte    70 NULL        0 I_MOV[6]
  8156                                  ;  143 arr sign byte    71 NULL        0 I_MOVSX[9]
  8157                                  ;  144 arr sign byte    72 NULL        0 I_MOVZX[9]
  8158                                  ;  145 arr sign byte    74 NULL        0 I_JO[6]
  8159                                  ;  146 arr sign byte    75 NULL        0 I_JNO[7]
  8160                                  ;  147 arr sign byte    76 NULL        0 I_JB[6]
  8161                                  ;  148 arr sign byte    77 NULL        0 I_JC[6]
  8162                                  ;  149 arr sign byte    78 NULL        0 I_JNB[7]
  8163                                  ;  150 arr sign byte    79 NULL        0 I_JAE[7]
  8164                                  ;  151 arr sign byte    80 NULL        0 I_JNC[7]
  8165                                  ;  152 arr sign byte    81 NULL        0 I_JE[6]
  8166                                  ;  153 arr sign byte    82 NULL        0 I_JZ[6]
  8167                                  ;  154 arr sign byte    83 NULL        0 I_JNE[7]
  8168                                  ;  155 arr sign byte    84 NULL        0 I_JNZ[7]
  8169                                  ;  156 arr sign byte    85 NULL        0 I_JBE[7]
  8170                                  ;  157 arr sign byte    86 NULL        0 I_JNA[7]
  8171                                  ;  158 arr sign byte    87 NULL        0 I_JA[6]
  8172                                  ;  159 arr sign byte    88 NULL        0 I_JS[6]
  8173                                  ;  160 arr sign byte    89 NULL        0 I_JNS[7]
  8174                                  ;  161 arr sign byte    90 NULL        0 I_JP[6]
  8175                                  ;  162 arr sign byte    91 NULL        0 I_JPE[7]
  8176                                  ;  163 arr sign byte    92 NULL        0 I_JNP[7]
  8177                                  ;  164 arr sign byte    93 NULL        0 I_JPO[7]
  8178                                  ;  165 arr sign byte    94 NULL        0 I_JL[6]
  8179                                  ;  166 arr sign byte    95 NULL        0 I_JNL[7]
  8180                                  ;  167 arr sign byte    96 NULL        0 I_JGE[7]
  8181                                  ;  168 arr sign byte    97 NULL        0 I_JLE[7]
  8182                                  ;  169 arr sign byte    98 NULL        0 I_JNG[7]
  8183                                  ;  170 arr sign byte    99 NULL        0 I_JG[6]
  8184                                  ;  171 arr sign byte   101 NULL        0 I_JMP[8]
  8185                                  ;  172 arr sign byte   102 NULL        0 I_CALL[9]
  8186                                  ;  173 arr sign byte   104 NULL        0 I_RET[8]
  8187                                  ;  174 arr sign byte   105 NULL        0 I_RETF[9]
  8188                                  ;  175 arr sign byte   107 NULL        0 I_PUSH[11]
  8189                                  ;  176 arr sign byte   108 NULL        0 I_POP[10]
  8190                                  ;  177 arr sign byte   110 NULL        0 I_ROL[7]
  8191                                  ;  178 arr sign byte   111 NULL        0 I_ROR[7]
  8192                                  ;  179 arr sign byte   112 NULL        0 I_RCL[7]
  8193                                  ;  180 arr sign byte   113 NULL        0 I_RCR[7]
  8194                                  ;  181 arr sign byte   114 NULL        0 I_SHL[7]
  8195                                  ;  182 arr sign byte   115 NULL        0 I_SAL[7]
  8196                                  ;  183 arr sign byte   116 NULL        0 I_SHR[7]
  8197                                  ;  184 arr sign byte   117 NULL        0 I_SAR[7]
  8198                                  ;  185 arr sign byte   119 NULL        0 I_INT[8]
  8199                                  ;  186 arr sign byte   130 NULL        0 I_XCHG[9]
  8200                                  ;  187 arr sign byte   140 NULL        0 I_ENTER[8]
  8201                                  ;  188 arr sign byte   142 NULL        0 I_ORG[6]
  8202                                  ;  189 arr sign byte   147 NULL        0 I_DB[5]
  8203                                  ;  190 arr sign byte   148 NULL        0 I_DW[5]
  8204                                  ;  191 arr sign byte   149 NULL        0 I_DD[5]
  8205                                  ;  192 arr sign byte   150 NULL        0 I_RESB[7]
  8206                                  ;  193 arr sign byte   151 NULL        0 I_RESW[7]
  8207                                  ;  194 arr sign byte   152 NULL        0 I_RESD[7]
  8208                                  ;  195 var sign byte   153 NULL        0 I_END
  8209                                  
  8210                                  
  8211                                  ;   # Calls Line Width  Name   list of functions
  8212                                  
  8213                                  ;    0    2    1 word   ChangeDirection
  8214                                  ;    1    2    9 word   checkOpL
  8215                                  ;    2    3   18 word   check2Ops
  8216                                  ;    3    1   27 word   get2Ops
  8217                                  ;    4    3   33 word   getOpL
  8218                                  ;    5    2   41 word   getOpR
  8219                                  ;    6    4   51 word   getOp1
  8220                                  ;    7    1   67 word   getMEM
  8221                                  ;    8    1   90 word   getIndReg1
  8222                                  ;    9    1   98 word   getIndReg2
  8223                                  ;   10    2  108 word   setwflag
  8224                                  ;   11    2  119 word   setsflag
  8225                                  ;   12    1  129 word   checkConstSize
  8226                                  ;   13    1    1 word   parse
  8227                                  ;   14   14   35 word   getTokeType
  8228                                  ;   15    1   46 word   storeJmpCall
  8229                                  ;   16    2   59 word   storeLabel
  8230                                  ;   17    4   71 word   searchLabel
  8231                                  ;   18    1   84 word   getVariable
  8232                                  ;   19    2  119 word   lookCode
  8233                                  ;   20    1  135 word   getCodeSize
  8234                                  ;   21    8  143 word   isToken
  8235                                  ;   22    2  151 word   need
  8236                                  ;   23    1  160 word   skipRest
  8237                                  ;   24    1    1 word   getLine
  8238                                  ;   25    1   17 word   ifEOL
  8239                                  ;   26    3   24 word   skipBlank
  8240                                  ;   27    2   29 word   letterE
  8241                                  ;   28    1   39 word   alnumE
  8242                                  ;   29    1   44 word   getDigit
  8243                                  ;   30    1   56 word   getName
  8244                                  ;   31    1   75 word   testReg
  8245                                  ;   32    1    1 word   printLine
  8246                                  ;   33    9   23 word   prc
  8247                                  ;   34    1   35 word   prscomment
  8248                                  ;   35   33   43 word   prs
  8249                                  ;   36    3   65 word   printhex8a
  8250                                  ;   37    2   70 word   printhex4
  8251                                  ;   38    3   75 word   printhex16
  8252                                  ;   39    5   80 word   printIntU
  8253                                  ;   40   25   91 word   error1
  8254                                  ;   41   15   99 word   errorexit
  8255                                  ;   42 NULL  103 word   allowederror
  8256                                  ;   43    3  104 word   addrerror
  8257                                  ;   44    1  105 word   immeerror
  8258                                  ;   45    2  106 word   implerror
  8259                                  ;   46    4  107 word   indexerror
  8260                                  ;   47    3  108 word   invaloperror
  8261                                  ;   48    4  109 word   numbererror
  8262                                  ;   49    1  110 word   regmemerror
  8263                                  ;   50    3  111 word   reg16error
  8264                                  ;   51    1  112 word   segregerror
  8265                                  ;   52    4  113 word   syntaxerror
  8266                                  ;   53 NULL  115 word   addrexit
  8267                                  ;   54 NULL  116 word   internexit
  8268                                  ;   55 NULL    1 word   main
  8269                                  ;   56    1    9 word   getarg
  8270                                  ;   57    1   43 word   fixJmpCall
  8271                                  ;   58    1   88 word   epilog
  8272                                  ;   59    2  132 word   end1
  8273                                  ;   60    1    2 word   getCodes
  8274                                  ;   61    1    7 word   gen66h
  8275                                  ;   62    8    9 word   genCode2
  8276                                  ;   63   10   13 word   genCodeW
  8277                                  ;   64   27   17 word   genCode8
  8278                                  ;   65   10   28 word   genCode16
  8279                                  ;   66   10   32 word   writeEA
  8280                                  ;   67    4   74 word   genImmediate
  8281                                  ;   68    1   11 word   process
  8282                                  ;   69    4  281 word   writetty
  8283                                  ;   70    8  282 word   cputs
  8284                                  ;   71    2  283 word   toupper
  8285                                  ;   72    5  285 word   strlen
  8286                                  ;   73    8  286 word   strcpy
  8287                                  ;   74    3  288 word   digit
  8288                                  ;   75   35  289 word   eqstr
  8289                                  ;   76    3  292 word   strcat1
  8290                                  ;   77    1  293 word   openR
  8291                                  ;   78    2  294 word   creatR
  8292                                  ;   79    2  295 word   readRL
  8293                                  ;   80    2  296 word   fputcR
  8294                                  ;   81    3  298 word   fcloseR
  8295                                  ;   82    5  299 word   exitR
  8296                                  ;   83    1  301 word   putch
  8297                                  ;   84    4  302 word   DosInt
  8298                                  ;   85 NULL  303 word   LastFunctionByt
  8299                                  
  8300                                  ;    #  addr name   list of CALLs
  8301                                  
  8302                                  ;    0  1413 implerror
  8303                                  ;    1  1423 segregerror
  8304                                  ;    2  1435 setwflag
  8305                                  ;    3  1444 error1
  8306                                  ;    4  1451 error1
  8307                                  ;    5  1468 get2Ops
  8308                                  ;    6  1476 addrerror
  8309                                  ;    7  1486 invaloperror
  8310                                  ;    8  1499 immeerror
  8311                                  ;    9  1509 addrerror
  8312                                  ;   10  1519 invaloperror
  8313                                  ;   11  1532 setwflag
  8314                                  ;   12  1549 getOpL
  8315                                  ;   13  1556 need
  8316                                  ;   14  1561 getOpR
  8317                                  ;   15  1575 getOpR
  8318                                  ;   16  1589 getOp1
  8319                                  ;   17  1596 isToken
  8320                                  ;   18  1604 getMEM
  8321                                  ;   19  1611 invaloperror
  8322                                  ;   20  1624 error1
  8323                                  ;   21  1638 testReg
  8324                                  ;   22  1646 searchLabel
  8325                                  ;   23  1658 error1
  8326                                  ;   24  1674 getTokeType
  8327                                  ;   25  1686 getOp1
  8328                                  ;   26  1693 syntaxerror
  8329                                  ;   27  1705 getIndReg2
  8330                                  ;   28  1716 getIndReg1
  8331                                  ;   29  1727 isToken
  8332                                  ;   30  1735 getTokeType
  8333                                  ;   31  1747 numbererror
  8334                                  ;   32  1759 isToken
  8335                                  ;   33  1767 isToken
  8336                                  ;   34  1775 errorexit
  8337                                  ;   35  1796 indexerror
  8338                                  ;   36  1807 indexerror
  8339                                  ;   37  1831 indexerror
  8340                                  ;   38  1842 indexerror
  8341                                  ;   39  1862 gen66h
  8342                                  ;   40  1881 error1
  8343                                  ;   41  1912 getLine
  8344                                  ;   42  1920 getTokeType
  8345                                  ;   43  1932 storeLabel
  8346                                  ;   44  1943 getTokeType
  8347                                  ;   45  1955 lookCode
  8348                                  ;   46  1964 process
  8349                                  ;   47  1972 getVariable
  8350                                  ;   48  1984 skipRest
  8351                                  ;   49  1993 error1
  8352                                  ;   50  2000 error1
  8353                                  ;   51  2007 printLine
  8354                                  ;   52  2031 skipBlank
  8355                                  ;   53  2041 digit
  8356                                  ;   54  2047 getDigit
  8357                                  ;   55  2056 letterE
  8358                                  ;   56  2064 getName
  8359                                  ;   57  2087 errorexit
  8360                                  ;   58  2097 strcpy
  8361                                  ;   59  2104 errorexit
  8362                                  ;   60  2127 errorexit
  8363                                  ;   61  2137 searchLabel
  8364                                  ;   62  2149 error1
  8365                                  ;   63  2156 strcpy
  8366                                  ;   64  2163 errorexit
  8367                                  ;   65  2191 eqstr
  8368                                  ;   66  2197 strlen
  8369                                  ;   67  2218 storeLabel
  8370                                  ;   68  2229 getTokeType
  8371                                  ;   69  2241 lookCode
  8372                                  ;   70  2250 errorexit
  8373                                  ;   71  2260 errorexit
  8374                                  ;   72  2270 getTokeType
  8375                                  ;   73  2282 genCode8
  8376                                  ;   74  2291 skipBlank
  8377                                  ;   75  2301 isToken
  8378                                  ;   76  2309 genCode8
  8379                                  ;   77  2318 isToken
  8380                                  ;   78  2326 getTokeType
  8381                                  ;   79  2338 genCode16
  8382                                  ;   80  2348 isToken
  8383                                  ;   81  2356 errorexit
  8384                                  ;   82  2375 eqstr
  8385                                  ;   83  2393 eqstr
  8386                                  ;   84  2399 getTokeType
  8387                                  ;   85  2411 eqstr
  8388                                  ;   86  2417 getTokeType
  8389                                  ;   87  2429 eqstr
  8390                                  ;   88  2435 getTokeType
  8391                                  ;   89  2457 skipBlank
  8392                                  ;   90  2474 isToken
  8393                                  ;   91  2482 getTokeType
  8394                                  ;   92  2494 error1
  8395                                  ;   93  2501 prs
  8396                                  ;   94  2505 prc
  8397                                  ;   95  2518 getTokeType
  8398                                  ;   96  2530 error1
  8399                                  ;   97  2547 readRL
  8400                                  ;   98  2554 errorexit
  8401                                  ;   99  2564 errorexit
  8402                                  ;  100  2574 ifEOL
  8403                                  ;  101  2588 readRL
  8404                                  ;  102  2624 digit
  8405                                  ;  103  2630 letterE
  8406                                  ;  104  2657 digit
  8407                                  ;  105  2677 alnumE
  8408                                  ;  106  2684 errorexit
  8409                                  ;  107  2694 strcpy
  8410                                  ;  108  2701 toupper
  8411                                  ;  109  2717 strlen
  8412                                  ;  110  2724 strlen
  8413                                  ;  111  2731 eqstr
  8414                                  ;  112  2737 eqstr
  8415                                  ;  113  2743 eqstr
  8416                                  ;  114  2749 eqstr
  8417                                  ;  115  2755 eqstr
  8418                                  ;  116  2761 eqstr
  8419                                  ;  117  2767 eqstr
  8420                                  ;  118  2773 eqstr
  8421                                  ;  119  2779 eqstr
  8422                                  ;  120  2785 eqstr
  8423                                  ;  121  2791 eqstr
  8424                                  ;  122  2797 eqstr
  8425                                  ;  123  2803 eqstr
  8426                                  ;  124  2809 eqstr
  8427                                  ;  125  2815 eqstr
  8428                                  ;  126  2821 eqstr
  8429                                  ;  127  2827 eqstr
  8430                                  ;  128  2833 eqstr
  8431                                  ;  129  2839 eqstr
  8432                                  ;  130  2845 eqstr
  8433                                  ;  131  2851 eqstr
  8434                                  ;  132  2857 eqstr
  8435                                  ;  133  2863 eqstr
  8436                                  ;  134  2869 eqstr
  8437                                  ;  135  2875 eqstr
  8438                                  ;  136  2881 eqstr
  8439                                  ;  137  2887 eqstr
  8440                                  ;  138  2893 eqstr
  8441                                  ;  139  2899 eqstr
  8442                                  ;  140  2905 eqstr
  8443                                  ;  141  2925 prs
  8444                                  ;  142  2929 printhex16
  8445                                  ;  143  2940 prs
  8446                                  ;  144  2944 prc
  8447                                  ;  145  2948 printhex8a
  8448                                  ;  146  2959 prs
  8449                                  ;  147  2963 prc
  8450                                  ;  148  2967 prscomment
  8451                                  ;  149  2984 writetty
  8452                                  ;  150  2993 writetty
  8453                                  ;  151  3002 fputcR
  8454                                  ;  152  3024 prc
  8455                                  ;  153  3040 prc
  8456                                  ;  154  3061 printhex4
  8457                                  ;  155  3071 printhex4
  8458                                  ;  156  3093 prc
  8459                                  ;  157  3115 printhex8a
  8460                                  ;  158  3126 printhex8a
  8461                                  ;  159  3151 printIntU
  8462                                  ;  160  3161 prc
  8463                                  ;  161  3174 prs
  8464                                  ;  162  3178 prs
  8465                                  ;  163  3182 prs
  8466                                  ;  164  3186 prs
  8467                                  ;  165  3202 error1
  8468                                  ;  166  3209 end1
  8469                                  ;  167  3227 error1
  8470                                  ;  168  3244 error1
  8471                                  ;  169  3261 error1
  8472                                  ;  170  3278 error1
  8473                                  ;  171  3296 error1
  8474                                  ;  172  3316 error1
  8475                                  ;  173  3335 error1
  8476                                  ;  174  3354 error1
  8477                                  ;  175  3372 error1
  8478                                  ;  176  3391 error1
  8479                                  ;  177  3410 error1
  8480                                  ;  178  3426 errorexit
  8481                                  ;  179  3447 errorexit
  8482                                  ;  180  3462 getarg
  8483                                  ;  181  3469 parse
  8484                                  ;  182  3475 fixJmpCall
  8485                                  ;  183  3486 epilog
  8486                                  ;  184  3493 end1
  8487                                  ;  185  3517 cputs
  8488                                  ;  186  3523 cputs
  8489                                  ;  187  3529 exitR
  8490                                  ;  188  3535 toupper
  8491                                  ;  189  3543 strcpy
  8492                                  ;  190  3550 strcat1
  8493                                  ;  191  3558 strcpy
  8494                                  ;  192  3565 strcat1
  8495                                  ;  193  3573 strcpy
  8496                                  ;  194  3580 strcat1
  8497                                  ;  195  3588 openR
  8498                                  ;  196  3594 cputs
  8499                                  ;  197  3600 cputs
  8500                                  ;  198  3606 exitR
  8501                                  ;  199  3612 creatR
  8502                                  ;  200  3619 cputs
  8503                                  ;  201  3625 cputs
  8504                                  ;  202  3631 exitR
  8505                                  ;  203  3637 creatR
  8506                                  ;  204  3644 cputs
  8507                                  ;  205  3650 cputs
  8508                                  ;  206  3656 exitR
  8509                                  ;  207  3662 prs
  8510                                  ;  208  3666 prs
  8511                                  ;  209  3670 prs
  8512                                  ;  210  3674 prs
  8513                                  ;  211  3678 prs
  8514                                  ;  212  3682 prs
  8515                                  ;  213  3686 prs
  8516                                  ;  214  3690 prs
  8517                                  ;  215  3694 prs
  8518                                  ;  216  3722 prs
  8519                                  ;  217  3726 printIntU
  8520                                  ;  218  3736 prs
  8521                                  ;  219  3740 strcpy
  8522                                  ;  220  3747 strlen
  8523                                  ;  221  3754 prs
  8524                                  ;  222  3758 prc
  8525                                  ;  223  3762 printhex16
  8526                                  ;  224  3773 searchLabel
  8527                                  ;  225  3785 error1
  8528                                  ;  226  3792 prs
  8529                                  ;  227  3796 errorexit
  8530                                  ;  228  3819 prs
  8531                                  ;  229  3823 printIntU
  8532                                  ;  230  3833 prs
  8533                                  ;  231  3837 prs
  8534                                  ;  232  3841 prs
  8535                                  ;  233  3845 prs
  8536                                  ;  234  3849 prs
  8537                                  ;  235  3853 prs
  8538                                  ;  236  3857 printIntU
  8539                                  ;  237  3867 prs
  8540                                  ;  238  3871 fputcR
  8541                                  ;  239  3878 prs
  8542                                  ;  240  3882 printIntU
  8543                                  ;  241  3892 prs
  8544                                  ;  242  3896 prs
  8545                                  ;  243  3900 prc
  8546                                  ;  244  3904 printhex16
  8547                                  ;  245  3915 prs
  8548                                  ;  246  3919 strlen
  8549                                  ;  247  3933 fcloseR
  8550                                  ;  248  3941 fcloseR
  8551                                  ;  249  3949 fcloseR
  8552                                  ;  250  3957 exitR
  8553                                  ;  251  3979 genCode8
  8554                                  ;  252  4001 genCode8
  8555                                  ;  253  4021 genCode8
  8556                                  ;  254  4041 errorexit
  8557                                  ;  255  4063 genCode8
  8558                                  ;  256  4072 genCode8
  8559                                  ;  257  4097 genCode8
  8560                                  ;  258  4106 genCode8
  8561                                  ;  259  4115 genCode16
  8562                                  ;  260  4138 genCode16
  8563                                  ;  261  4148 genCode8
  8564                                  ;  262  4167 getTokeType
  8565                                  ;  263  4179 getCodeSize
  8566                                  ;  264  4191 getCodes
  8567                                  ;  265  4200 genCode8
  8568                                  ;  266  4209 getOpL
  8569                                  ;  267  4216 checkOpL
  8570                                  ;  268  4225 genCode2
  8571                                  ;  269  4234 getTokeType
  8572                                  ;  270  4246 implerror
  8573                                  ;  271  4256 genCodeW
  8574                                  ;  272  4265 writeEA
  8575                                  ;  273  4273 check2Ops
  8576                                  ;  274  4283 reg16error
  8577                                  ;  275  4294 addrerror
  8578                                  ;  276  4304 genCode8
  8579                                  ;  277  4313 genCode8
  8580                                  ;  278  4322 writeEA
  8581                                  ;  279  4330 check2Ops
  8582                                  ;  280  4340 setsflag
  8583                                  ;  281  4349 genCodeW
  8584                                  ;  282  4358 genImmediate
  8585                                  ;  283  4371 genCodeW
  8586                                  ;  284  4380 writeEA
  8587                                  ;  285  4388 genCode8
  8588                                  ;  286  4397 genImmediate
  8589                                  ;  287  4410 genCodeW
  8590                                  ;  288  4419 writeEA
  8591                                  ;  289  4427 genCodeW
  8592                                  ;  290  4436 writeEA
  8593                                  ;  291  4444 syntaxerror
  8594                                  ;  292  4456 check2Ops
  8595                                  ;  293  4466 genCode2
  8596                                  ;  294  4475 genImmediate
  8597                                  ;  295  4488 genCodeW
  8598                                  ;  296  4497 writeEA
  8599                                  ;  297  4505 genImmediate
  8600                                  ;  298  4518 regmemerror
  8601                                  ;  299  4530 ChangeDirection
  8602                                  ;  300  4546 reg16error
  8603                                  ;  301  4557 genCode2
  8604                                  ;  302  4566 writeEA
  8605                                  ;  303  4574 genCodeW
  8606                                  ;  304  4583 genCode16
  8607                                  ;  305  4593 genCodeW
  8608                                  ;  306  4602 genCode16
  8609                                  ;  307  4612 genCodeW
  8610                                  ;  308  4621 writeEA
  8611                                  ;  309  4629 ChangeDirection
  8612                                  ;  310  4645 genCodeW
  8613                                  ;  311  4654 writeEA
  8614                                  ;  312  4662 syntaxerror
  8615                                  ;  313  4674 searchLabel
  8616                                  ;  314  4686 checkConstSize
  8617                                  ;  315  4701 genCode2
  8618                                  ;  316  4710 genCode8
  8619                                  ;  317  4719 genCode8
  8620                                  ;  318  4728 genCode2
  8621                                  ;  319  4737 genCode16
  8622                                  ;  320  4747 genCode8
  8623                                  ;  321  4756 genCode2
  8624                                  ;  322  4765 genCode16
  8625                                  ;  323  4775 storeJmpCall
  8626                                  ;  324  4788 genCode8
  8627                                  ;  325  4797 genCode16
  8628                                  ;  326  4807 genCode8
  8629                                  ;  327  4816 getOpL
  8630                                  ;  328  4823 setsflag
  8631                                  ;  329  4832 genCode2
  8632                                  ;  330  4841 genCode8
  8633                                  ;  331  4850 genCode16
  8634                                  ;  332  4860 error1
  8635                                  ;  333  4867 genCode8
  8636                                  ;  334  4876 genCode8
  8637                                  ;  335  4885 checkOpL
  8638                                  ;  336  4894 reg16error
  8639                                  ;  337  4905 genCode2
  8640                                  ;  338  4914 genCode8
  8641                                  ;  339  4923 writeEA
  8642                                  ;  340  4931 syntaxerror
  8643                                  ;  341  4943 genCode8
  8644                                  ;  342  4952 genCode8
  8645                                  ;  343  4961 genCode8
  8646                                  ;  344  4970 getOp1
  8647                                  ;  345  4977 genCode16
  8648                                  ;  346  4987 numbererror
  8649                                  ;  347  4999 need
  8650                                  ;  348  5004 getOp1
  8651                                  ;  349  5011 genCode8
  8652                                  ;  350  5020 numbererror
  8653                                  ;  351  5032 numbererror
  8654                                  ;  352  5044 error1
  8655                                  ;  353  5070 putch
  8656                                  ;  354  5138 strcpy
  8657                                  ;  355  5153 DosInt
  8658                                  ;  356  5169 DosInt
  8659                                  ;  357  5192 DosInt
  8660                                  ;  358  5211 DosInt
  8661                                  ;  359  5245 writetty
  8662                                  ;  360  5254 writetty
  8663                                  ;Input: AS.C, List: AS.S,  Lines:  304
  8664                                  ;Glob. variables:  195 max.:  200
  8665                                  ;Local variables:    5 max.:  100, in 'fixJmpCall'
  8666                                  ;Functions      :   86 max.:  300
  8667                                  ;Calls          :  361 max.: 2000, NameField: 5286 max.:    65535
  8668                                  ;Code until     :25998 max.: 30000, free: 4002
  8669                                  ;Data (HeapEnd) :37095, resting stacksize: 28440
  8670                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
