     1                                  
     2                                  ; A.COM CComp V0.7, Arglen: 5, Argv: AS.C, Source: AS.C, Output asm: AS.S
     3                                  ;PROTECTED: 0 V86 OFF.  32bit: ON. 
     4                                  org  256 ; NASM ON
     5 00000000 E97B36                  jmp main
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
   165                                  ;-42 char R2No;              //0 - 7 AL, CL, ...  set in testReg()  
   166                                  
   167 000001B2 00                      R2No db 0
   168                                  
   169                                  ;-43 char R1No;              //temp for 1. register
   170                                  
   171 000001B3 00                      R1No db 0
   172                                  
   173                                  ;-44 char R2Type;            //0=no reg, BYTE, WORD, DWORD, SEGREG
   174                                  
   175 000001B4 00                      R2Type db 0
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
   189                                  ;-48 char dflag;             //directionflag: 1=to reg MOV,ALU    
   190                                  
   191 000001B8 00                      dflag db 0
   192                                  
   193                                  ;-49 char sflag;             //sign extended, imm8 to word PUSH,ALU,IMUL3 
   194                                  
   195 000001B9 00                      sflag db 0
   196                                  
   197                                  ;-50 char rm;                //combination of index and base reg
   198                                  
   199 000001BA 00                      rm db 0
   200                                  
   201                                  ;-51 char isDirect;          //set in process and getMeM, need in WriteEA
   202                                  
   203 000001BB 00                      isDirect db 0
   204                                  
   205                                  ;-52 int disp;               //displacement      0-8 bytes
   206                                  
   207 000001BC 0000                    disp dw 0
   208                                  
   209                                  ;-53 unsigned int imme;      //immediate         0-8 bytes
   210                                  
   211 000001BE 0000                    imme dw 0
   212                                  
   213                                  ;-54 
   214                                  
   215                                  
   216                                  ;-55 #define OPMAXLEN 5
   217                                  
   218                                  
   219                                  ;-56 char OpPos[OPMAXLEN];   //array for one opcode to list
   220                                  
   221 000001C0 <res 00000005>          OpPos resb 5
   222                                  
   223                                  ;-57 int OpPrintIndex;       //0-OPMAXLEN, pos to print opcode, by genCode8
   224                                  
   225 000001C5 0000                    OpPrintIndex dw 0
   226                                  
   227                                  ;-58 char *OpCodePtr;        //position in OpCodeTable by searchSymbol
   228                                  
   229 000001C7 0000                    OpCodePtr dw 0
   230                                  
   231                                  ;-59 char PrintRA;           //print r8, R16, A16 (relocative, absolute)
   232                                  
   233 000001C9 00                      PrintRA db 0
   234                                  
   235                                  ;-60 
   236                                  
   237                                  
   238                                  ;-61 #define LABELNAMESMAX 969//next number - 31
   239                                  
   240                                  
   241                                  ;-62 char LabelNames[1000];  //space for names of all labels
   242                                  
   243 000001CA <res 000003E8>          LabelNames resb 1000
   244                                  
   245                                  ;-63 char *LabelNamePtr;     //first free position
   246                                  
   247 000005B2 0000                    LabelNamePtr dw 0
   248                                  
   249                                  ;-64 #define LABELADRMAX 100
   250                                  
   251                                  
   252                                  ;-65 unsigned int LabelAddr[LABELADRMAX];//addr of each label
   253                                  
   254 000005B4 <res 000000C8>          LabelAddr resw 100
   255                                  
   256                                  ;-66 int LabelMaxIx=0;       //actual number of stored labels. 1 to LABELADRMAX-1
   257                                  
   258 0000067C 0000                    LabelMaxIx dw 0
   259                                  
   260                                  ;-67 int LabelIx;            //actual number of just searched label
   261                                  
   262 0000067E 0000                    LabelIx dw 0
   263                                  
   264                                  ;-68 
   265                                  
   266                                  
   267                                  ;-69 #define JMPCALLMAX 500  //max. jmp and call
   268                                  
   269                                  
   270                                  ;-70 #define JMPCALLNAMESMAX 1969//next number - 31
   271                                  
   272                                  
   273                                  ;-71 char JmpCallNames[2000];//space for names of jmp, call
   274                                  
   275 00000680 <res 000007D0>          JmpCallNames resb 2000
   276                                  
   277                                  ;-72 char *JmpCallNamePtr;   //first free position 
   278                                  
   279 00000E50 0000                    JmpCallNamePtr dw 0
   280                                  
   281                                  ;-73 unsigned int JmpCallAddr[JMPCALLMAX];//addr to be fixed
   282                                  
   283 00000E52 <res 000003E8>          JmpCallAddr resw 500
   284                                  
   285                                  ;-74 char JmpCallRelAbs      [JMPCALLMAX];//r8, R16, A16
   286                                  
   287 0000123A <res 000001F4>          JmpCallRelAbs resb 500
   288                                  
   289                                  ;-75 int JmpCallMaxIx=0;     //actual number of jmp, call. 1 to JMPCALLMAX-1
   290                                  
   291 0000142E 0000                    JmpCallMaxIx dw 0
   292                                  
   293                                  ;-76  
   294                                  
   295                                  
   296                                  ;-77 #define FILEBINMAX 2000 //next number - max. oplength
   297                                  
   298                                  
   299                                  ;-78 char FileBin  [FILEBINMAX];//output binary file
   300                                  
   301 00001430 <res 000007D0>          FileBin resb 2000
   302                                  
   303                                  ;-79 unsigned int BinLen=0;  //length of binary file
   304                                  
   305 00001C00 0000                    BinLen dw 0
   306                                  
   307                                  ;-80 
   308                                  
   309                                  
   310                                  ;-81 char *arglen=0x80;      // for main only
   311                                  
   312 00001C02 8000                    arglen dw 128
   313                                  
   314                                  ;-82 char *argv=0x82;        // for main only
   315                                  
   316 00001C04 8200                    argv dw 130
   317                                  ;Back to main program: AS.C
   318                                  
   319                                  ;-3 #include "OPTABL.C"   
   320                                  
   321                                  ;Use include file: OPTABL.C
   322                                  
   323                                  ;-1 char I_START=0xF1;
   324                                  
   325 00001C06 F1                      I_START db 241
   326                                  
   327                                  ;-2 //OpName, 0, CodeType, OpCode1-n, F1h
   328                                  
   329                                  
   330                                  ;-3 //  1:   1 byte opcode
   331                                  
   332                                  
   333                                  ;-4 char I_PUSHA[]={'P','U','S','H','A',0,  1,0x60,   0xF1};
   334                                  
   335 00001C07 5055534841000160F1      I_PUSHA db 80,85,83,72,65,0,1,96,241
   336                                  
   337                                  ;-5 char I_POPA[]= {'P','O','P','A',0,      1,0x61,   0xF1};
   338                                  
   339 00001C10 504F5041000161F1        I_POPA db 80,79,80,65,0,1,97,241
   340                                  
   341                                  ;-6 char I_NOP[]=  {'N','O','P',0,          1,0x90,   0xF1};
   342                                  
   343 00001C18 4E4F50000190F1          I_NOP db 78,79,80,0,1,144,241
   344                                  
   345                                  ;-7 char I_CBW[]=  {'C','B','W',0,          1,0x98,   0xF1};
   346                                  
   347 00001C1F 434257000198F1          I_CBW db 67,66,87,0,1,152,241
   348                                  
   349                                  ;-8 char I_CWDE[]= {'C','W','D','E',0,      1,0x98,   0xF1};
   350                                  
   351 00001C26 43574445000198F1        I_CWDE db 67,87,68,69,0,1,152,241
   352                                  
   353                                  ;-9 char I_CWD[]=  {'C','W','D',0,          1,0x99,   0xF1};
   354                                  
   355 00001C2E 435744000199F1          I_CWD db 67,87,68,0,1,153,241
   356                                  
   357                                  ;-10 char I_CDQ[]=  {'C','D','Q',0,          1,0x99,   0xF1};
   358                                  
   359 00001C35 434451000199F1          I_CDQ db 67,68,81,0,1,153,241
   360                                  
   361                                  ;-11 char I_WAIT[]= {'W','A','I','T',0,      1,0x9B,   0xF1};
   362                                  
   363 00001C3C 5741495400019BF1        I_WAIT db 87,65,73,84,0,1,155,241
   364                                  
   365                                  ;-12 char I_PUSHF[]={'P','U','S','H','F',0,  1,0x9C,   0xF1};
   366                                  
   367 00001C44 505553484600019CF1      I_PUSHF db 80,85,83,72,70,0,1,156,241
   368                                  
   369                                  ;-13 char I_POPF[]= {'P','O','P','F',0,      1,0x9D,   0xF1};
   370                                  
   371 00001C4D 504F504600019DF1        I_POPF db 80,79,80,70,0,1,157,241
   372                                  
   373                                  ;-14 char I_SAHF[]= {'S','A','H','F',0,      1,0x9E,   0xF1};
   374                                  
   375 00001C55 5341484600019EF1        I_SAHF db 83,65,72,70,0,1,158,241
   376                                  
   377                                  ;-15 char I_LAHF[]= {'L','A','H','F',0,      1,0x9F,   0xF1};
   378                                  
   379 00001C5D 4C41484600019FF1        I_LAHF db 76,65,72,70,0,1,159,241
   380                                  
   381                                  ;-16 char I_MOVSB[]={'M','O','V','S','B',0,  1,0xA4,   0xF1};
   382                                  
   383 00001C65 4D4F5653420001A4F1      I_MOVSB db 77,79,86,83,66,0,1,164,241
   384                                  
   385                                  ;-17 char I_MOVSW[]={'M','O','V','S','W',0,  1,0xA5,   0xF1};
   386                                  
   387 00001C6E 4D4F5653570001A5F1      I_MOVSW db 77,79,86,83,87,0,1,165,241
   388                                  
   389                                  ;-18 char I_CMPSB[]={'C','M','P','S','B',0,  1,0xA6,   0xF1};
   390                                  
   391 00001C77 434D5053420001A6F1      I_CMPSB db 67,77,80,83,66,0,1,166,241
   392                                  
   393                                  ;-19 char I_CMPSW[]={'C','M','P','S','W',0,  1,0xA7,   0xF1};
   394                                  
   395 00001C80 434D5053570001A7F1      I_CMPSW db 67,77,80,83,87,0,1,167,241
   396                                  
   397                                  ;-20 char I_STOSB[]={'S','T','O','S','B',0,  1,0xAA,   0xF1};
   398                                  
   399 00001C89 53544F53420001AAF1      I_STOSB db 83,84,79,83,66,0,1,170,241
   400                                  
   401                                  ;-21 char I_STOSW[]={'S','T','O','S','W',0,  1,0xAB,   0xF1};
   402                                  
   403 00001C92 53544F53570001ABF1      I_STOSW db 83,84,79,83,87,0,1,171,241
   404                                  
   405                                  ;-22 char I_LODSB[]={'L','O','D','S','B',0,  1,0xAC,   0xF1};
   406                                  
   407 00001C9B 4C4F4453420001ACF1      I_LODSB db 76,79,68,83,66,0,1,172,241
   408                                  
   409                                  ;-23 char I_LODSW[]={'L','O','D','S','W',0,  1,0xAD,   0xF1};
   410                                  
   411 00001CA4 4C4F4453570001ADF1      I_LODSW db 76,79,68,83,87,0,1,173,241
   412                                  
   413                                  ;-24 char I_SCASB[]={'S','C','A','S','B',0,  1,0xAE,   0xF1};
   414                                  
   415 00001CAD 53434153420001AEF1      I_SCASB db 83,67,65,83,66,0,1,174,241
   416                                  
   417                                  ;-25 char I_SCASW[]={'S','C','A','S','W',0,  1,0xAF,   0xF1};
   418                                  
   419 00001CB6 53434153570001AFF1      I_SCASW db 83,67,65,83,87,0,1,175,241
   420                                  
   421                                  ;-26 char I_LEAVE[]={'L','E','A','V','E',0,  1,0xC9,   0xF1};
   422                                  
   423 00001CBF 4C454156450001C9F1      I_LEAVE db 76,69,65,86,69,0,1,201,241
   424                                  
   425                                  ;-27 char I_INT3[]= {'I','N','T','3',0,      1,0xCC,   0xF1};
   426                                  
   427 00001CC8 494E54330001CCF1        I_INT3 db 73,78,84,51,0,1,204,241
   428                                  
   429                                  ;-28 char I_INTO[]= {'I','N','T','O',0,      1,0xCE,   0xF1};
   430                                  
   431 00001CD0 494E544F0001CEF1        I_INTO db 73,78,84,79,0,1,206,241
   432                                  
   433                                  ;-29 char I_IRET[]= {'I','R','E','T',0,      1,0xCF,   0xF1};
   434                                  
   435 00001CD8 495245540001CFF1        I_IRET db 73,82,69,84,0,1,207,241
   436                                  
   437                                  ;-30 char I_XLAT[]= {'X','L','A','T',0,      1,0xD7,   0xF1};
   438                                  
   439 00001CE0 584C41540001D7F1        I_XLAT db 88,76,65,84,0,1,215,241
   440                                  
   441                                  ;-31 char I_LOCK[]= {'L','O','C','K',0,      1,0xF0,   0xF1};
   442                                  
   443 00001CE8 4C4F434B0001F0F1        I_LOCK db 76,79,67,75,0,1,240,241
   444                                  
   445                                  ;-32 char I_REPNE[]={'R','E','P','N','E',0,  1,0xF2,   0xF1};
   446                                  
   447 00001CF0 5245504E450001F2F1      I_REPNE db 82,69,80,78,69,0,1,242,241
   448                                  
   449                                  ;-33 char I_REPNZ[]={'R','E','P','N','Z',0,  1,0xF2,   0xF1};
   450                                  
   451 00001CF9 5245504E5A0001F2F1      I_REPNZ db 82,69,80,78,90,0,1,242,241
   452                                  
   453                                  ;-34 char I_REPE[]= {'R','E','P','E',0,      1,0xF3,   0xF1};
   454                                  
   455 00001D02 524550450001F3F1        I_REPE db 82,69,80,69,0,1,243,241
   456                                  
   457                                  ;-35 char I_REPZ[]= {'R','E','P','Z',0,      1,0xF3,   0xF1};
   458                                  
   459 00001D0A 5245505A0001F3F1        I_REPZ db 82,69,80,90,0,1,243,241
   460                                  
   461                                  ;-36 char I_HLT[]=  {'H','L','T',0,          1,0xF4,   0xF1};
   462                                  
   463 00001D12 484C540001F4F1          I_HLT db 72,76,84,0,1,244,241
   464                                  
   465                                  ;-37 char I_CLC[]=  {'C','L','C',0,          1,0xF8,   0xF1};//clear carry
   466                                  
   467 00001D19 434C430001F8F1          I_CLC db 67,76,67,0,1,248,241
   468                                  
   469                                  ;-38 char I_STC[]=  {'S','T','C',0,          1,0xF9,   0xF1};//set carry
   470                                  
   471 00001D20 5354430001F9F1          I_STC db 83,84,67,0,1,249,241
   472                                  
   473                                  ;-39 char I_CLI[]=  {'C','L','I',0,          1,0xFA,   0xF1};//clear interrupt
   474                                  
   475 00001D27 434C490001FAF1          I_CLI db 67,76,73,0,1,250,241
   476                                  
   477                                  ;-40 char I_STI[]=  {'S','T','I',0,          1,0xFB,   0xF1};//set interrupt
   478                                  
   479 00001D2E 5354490001FBF1          I_STI db 83,84,73,0,1,251,241
   480                                  
   481                                  ;-41 char I_CLD[]=  {'C','L','D',0,          1,0xFC,   0xF1};//clear direction
   482                                  
   483 00001D35 434C440001FCF1          I_CLD db 67,76,68,0,1,252,241
   484                                  
   485                                  ;-42 char I_STD[]=  {'S','T','D',0,          1,0xFD,   0xF1};//set direction
   486                                  
   487 00001D3C 5354440001FDF1          I_STD db 83,84,68,0,1,253,241
   488                                  
   489                                  ;-43 // 2: mem reg 16 bit
   490                                  
   491                                  
   492                                  ;-44 char I_INC[]=  {'I','N','C',0,          2,0xFE, 0,0x40,0xF1};
   493                                  
   494 00001D43 494E430002FE0040F1      I_INC db 73,78,67,0,2,254,0,64,241
   495                                  
   496                                  ;-45 char I_DEC[]=  {'D','E','C',0,          2,0xFE, 1,0x48,0xF1};
   497                                  
   498 00001D4C 4445430002FE0148F1      I_DEC db 68,69,67,0,2,254,1,72,241
   499                                  
   500                                  ;-46 char I_NOT[]=  {'N','O','T',0,          2,0xF6, 2,     0xF1};
   501                                  
   502 00001D55 4E4F540002F602F1        I_NOT db 78,79,84,0,2,246,2,241
   503                                  
   504                                  ;-47 char I_NEG[]=  {'N','E','G',0,          2,0xF6, 3,     0xF1};
   505                                  
   506 00001D5D 4E45470002F603F1        I_NEG db 78,69,71,0,2,246,3,241
   507                                  
   508                                  ;-48 char I_MUL[]=  {'M','U','L',0,          2,0xF6, 4,     0xF1};
   509                                  
   510 00001D65 4D554C0002F604F1        I_MUL db 77,85,76,0,2,246,4,241
   511                                  
   512                                  ;-49 char I_IMUL[]= {'I','M','U','L',0,      2,0xF6, 5,     0xF1};//only acc
   513                                  
   514 00001D6D 494D554C0002F605F1      I_IMUL db 73,77,85,76,0,2,246,5,241
   515                                  
   516                                  ;-50 char I_DIV[]=  {'D','I','V',0,          2,0xF6, 6,     0xF1};
   517                                  
   518 00001D76 4449560002F606F1        I_DIV db 68,73,86,0,2,246,6,241
   519                                  
   520                                  ;-51 char I_IDIV[]= {'I','D','I','V',0,      2,0xF6, 7,     0xF1};
   521                                  
   522 00001D7E 494449560002F607F1      I_IDIV db 73,68,73,86,0,2,246,7,241
   523                                  
   524                                  ;-52 //  3: les, lda, lea, lss, lfs, lgs
   525                                  
   526                                  
   527                                  ;-53 char I_LES[]=  {'L','E','S',0,          3,0xC4,     0xF1};
   528                                  
   529 00001D87 4C45530003C4F1          I_LES db 76,69,83,0,3,196,241
   530                                  
   531                                  ;-54 char I_LDS[]=  {'L','D','S',0,          3,0xC5,     0xF1};
   532                                  
   533 00001D8E 4C44530003C5F1          I_LDS db 76,68,83,0,3,197,241
   534                                  
   535                                  ;-55 char I_LEA[]=  {'L','E','A',0,          3,0x8D,     0xF1};//r, m16
   536                                  
   537 00001D95 4C454100038DF1          I_LEA db 76,69,65,0,3,141,241
   538                                  
   539                                  ;-56 char I_LSS[]=  {'L','S','S',0,          3,0x0F,0xB2,0xF1};
   540                                  
   541 00001D9C 4C535300030FB2F1        I_LSS db 76,83,83,0,3,15,178,241
   542                                  
   543                                  ;-57 char I_LFS[]=  {'L','F','S',0,          3,0x0F,0xB4,0xF1};
   544                                  
   545 00001DA4 4C465300030FB4F1        I_LFS db 76,70,83,0,3,15,180,241
   546                                  
   547                                  ;-58 char I_LGS[]=  {'L','G','S',0,          3,0x0F,0xB5,0xF1};
   548                                  
   549 00001DAC 4C475300030FB5F1        I_LGS db 76,71,83,0,3,15,181,241
   550                                  
   551                                  ;-59 //  4: acc,imm  reg,imm  index,reg
   552                                  
   553                                  
   554                                  ;-60 char I_ADD[]=  {'A','D','D',0,          4, 0,     0xF1};
   555                                  
   556 00001DB4 414444000400F1          I_ADD db 65,68,68,0,4,0,241
   557                                  
   558                                  ;-61 char I_OR []=  {'O','R',0,              4, 1,     0xF1};
   559                                  
   560 00001DBB 4F52000401F1            I_OR db 79,82,0,4,1,241
   561                                  
   562                                  ;-62 char I_ADC[]=  {'A','D','C',0,          4, 2,     0xF1};
   563                                  
   564 00001DC1 414443000402F1          I_ADC db 65,68,67,0,4,2,241
   565                                  
   566                                  ;-63 char I_SBB[]=  {'S','B','B',0,          4, 3,     0xF1};
   567                                  
   568 00001DC8 534242000403F1          I_SBB db 83,66,66,0,4,3,241
   569                                  
   570                                  ;-64 char I_AND[]=  {'A','N','D',0,          4, 4,     0xF1};
   571                                  
   572 00001DCF 414E44000404F1          I_AND db 65,78,68,0,4,4,241
   573                                  
   574                                  ;-65 char I_SUB[]=  {'S','U','B',0,          4, 5,     0xF1};
   575                                  
   576 00001DD6 535542000405F1          I_SUB db 83,85,66,0,4,5,241
   577                                  
   578                                  ;-66 char I_XOR[]=  {'X','O','R',0,          4, 6,     0xF1};
   579                                  
   580 00001DDD 584F52000406F1          I_XOR db 88,79,82,0,4,6,241
   581                                  
   582                                  ;-67 char I_CMP[]=  {'C','M','P',0,          4, 7,     0xF1};
   583                                  
   584 00001DE4 434D50000407F1          I_CMP db 67,77,80,0,4,7,241
   585                                  
   586                                  ;-68 char I_TEST[]= {'T','E','S','T',0,     41,0xA8,0x84,0xF6,0,0xF1};
   587                                  
   588 00001DEB 544553540029A884F6-     I_TEST db 84,69,83,84,0,41,168,132,246,0,241
   589 00001DF4 00F1               
   590                                  
   591                                  ;-69 //  5: mov
   592                                  
   593                                  
   594                                  ;-70 char I_MOV[]=  {'M','O','V',0,          5,        0xF1};
   595                                  
   596 00001DF6 4D4F560005F1            I_MOV db 77,79,86,0,5,241
   597                                  
   598                                  ;-71 char I_MOVSX[]={'M','O','V','S','X',0, 51,0xBE,   0xF1};
   599                                  
   600 00001DFC 4D4F5653580033BEF1      I_MOVSX db 77,79,86,83,88,0,51,190,241
   601                                  
   602                                  ;-72 char I_MOVZX[]={'M','O','V','Z','X',0, 51,0xB6,   0xF1};
   603                                  
   604 00001E05 4D4F565A580033B6F1      I_MOVZX db 77,79,86,90,88,0,51,182,241
   605                                  
   606                                  ;-73 //  6: single byte relative jump
   607                                  
   608                                  
   609                                  ;-74 char I_JO []=  {'J','O',0,              6, 0,     0xF1};
   610                                  
   611 00001E0E 4A4F000600F1            I_JO db 74,79,0,6,0,241
   612                                  
   613                                  ;-75 char I_JNO[]=  {'J','N','O',0,          6, 1,     0xF1};
   614                                  
   615 00001E14 4A4E4F000601F1          I_JNO db 74,78,79,0,6,1,241
   616                                  
   617                                  ;-76 char I_JB []=  {'J','B',0,              6, 2,     0xF1};
   618                                  
   619 00001E1B 4A42000602F1            I_JB db 74,66,0,6,2,241
   620                                  
   621                                  ;-77 char I_JC []=  {'J','C',0,              6, 2,     0xF1};
   622                                  
   623 00001E21 4A43000602F1            I_JC db 74,67,0,6,2,241
   624                                  
   625                                  ;-78 char I_JNB[]=  {'J','N','B',0,          6, 3,     0xF1};
   626                                  
   627 00001E27 4A4E42000603F1          I_JNB db 74,78,66,0,6,3,241
   628                                  
   629                                  ;-79 char I_JAE[]=  {'J','A','E',0,          6, 3,     0xF1};
   630                                  
   631 00001E2E 4A4145000603F1          I_JAE db 74,65,69,0,6,3,241
   632                                  
   633                                  ;-80 char I_JNC[]=  {'J','N','C',0,          6, 3,     0xF1};
   634                                  
   635 00001E35 4A4E43000603F1          I_JNC db 74,78,67,0,6,3,241
   636                                  
   637                                  ;-81 char I_JE []=  {'J','E',0,              6, 4,     0xF1};//  74 je i8rel
   638                                  
   639 00001E3C 4A45000604F1            I_JE db 74,69,0,6,4,241
   640                                  
   641                                  ;-82 char I_JZ []=  {'J','Z',0,              6, 4,     0xF1};//0F84 je i16r
   642                                  
   643 00001E42 4A5A000604F1            I_JZ db 74,90,0,6,4,241
   644                                  
   645                                  ;-83 char I_JNE[]=  {'J','N','E',0,          6, 5,     0xF1};
   646                                  
   647 00001E48 4A4E45000605F1          I_JNE db 74,78,69,0,6,5,241
   648                                  
   649                                  ;-84 char I_JNZ[]=  {'J','N','Z',0,          6, 5,     0xF1};
   650                                  
   651 00001E4F 4A4E5A000605F1          I_JNZ db 74,78,90,0,6,5,241
   652                                  
   653                                  ;-85 char I_JBE[]=  {'J','B','E',0,          6, 6,     0xF1};
   654                                  
   655 00001E56 4A4245000606F1          I_JBE db 74,66,69,0,6,6,241
   656                                  
   657                                  ;-86 char I_JNA[]=  {'J','N','A',0,          6, 6,     0xF1};
   658                                  
   659 00001E5D 4A4E41000606F1          I_JNA db 74,78,65,0,6,6,241
   660                                  
   661                                  ;-87 char I_JA []=  {'J','A',0,              6, 7,     0xF1};
   662                                  
   663 00001E64 4A41000607F1            I_JA db 74,65,0,6,7,241
   664                                  
   665                                  ;-88 char I_JS []=  {'J','S',0,              6, 8,     0xF1};
   666                                  
   667 00001E6A 4A53000608F1            I_JS db 74,83,0,6,8,241
   668                                  
   669                                  ;-89 char I_JNS[]=  {'J','N','S',0,          6, 9,     0xF1};
   670                                  
   671 00001E70 4A4E53000609F1          I_JNS db 74,78,83,0,6,9,241
   672                                  
   673                                  ;-90 char I_JP []=  {'J','P',0,              6,10,     0xF1};
   674                                  
   675 00001E77 4A5000060AF1            I_JP db 74,80,0,6,10,241
   676                                  
   677                                  ;-91 char I_JPE[]=  {'J','P','E',0,          6,10,     0xF1};
   678                                  
   679 00001E7D 4A504500060AF1          I_JPE db 74,80,69,0,6,10,241
   680                                  
   681                                  ;-92 char I_JNP[]=  {'J','N','P',0,          6,11,     0xF1};
   682                                  
   683 00001E84 4A4E5000060BF1          I_JNP db 74,78,80,0,6,11,241
   684                                  
   685                                  ;-93 char I_JPO[]=  {'J','P','O',0,          6,11,     0xF1};
   686                                  
   687 00001E8B 4A504F00060BF1          I_JPO db 74,80,79,0,6,11,241
   688                                  
   689                                  ;-94 char I_JL []=  {'J','L',0,              6,12,     0xF1};
   690                                  
   691 00001E92 4A4C00060CF1            I_JL db 74,76,0,6,12,241
   692                                  
   693                                  ;-95 char I_JNL[]=  {'J','N','L',0,          6,13,     0xF1};
   694                                  
   695 00001E98 4A4E4C00060DF1          I_JNL db 74,78,76,0,6,13,241
   696                                  
   697                                  ;-96 char I_JGE[]=  {'J','G','E',0,          6,13,     0xF1};
   698                                  
   699 00001E9F 4A474500060DF1          I_JGE db 74,71,69,0,6,13,241
   700                                  
   701                                  ;-97 char I_JLE[]=  {'J','L','E',0,          6,14,     0xF1};
   702                                  
   703 00001EA6 4A4C4500060EF1          I_JLE db 74,76,69,0,6,14,241
   704                                  
   705                                  ;-98 char I_JNG[]=  {'J','N','G',0,          6,14,     0xF1};
   706                                  
   707 00001EAD 4A4E4700060EF1          I_JNG db 74,78,71,0,6,14,241
   708                                  
   709                                  ;-99 char I_JG []=  {'J','G',0,              6,15,     0xF1};
   710                                  
   711 00001EB4 4A4700060FF1            I_JG db 74,71,0,6,15,241
   712                                  
   713                                  ;-100 //  7: jmp, call
   714                                  
   715                                  
   716                                  ;-101 char I_JMP[]=  {'J','M','P',0,          7,0xE9, 4,0xF1};
   717                                  
   718 00001EBA 4A4D500007E904F1        I_JMP db 74,77,80,0,7,233,4,241
   719                                  
   720                                  ;-102 char I_CALL[]= {'C','A','L','L',0,      7,0xE8, 2,0xF1};
   721                                  
   722 00001EC2 43414C4C0007E802F1      I_CALL db 67,65,76,76,0,7,232,2,241
   723                                  
   724                                  ;-103 //  8: ret
   725                                  
   726                                  
   727                                  ;-104 char I_RET[]=  {'R','E','T',0,          8,0xC3,0xC2,0xF1};
   728                                  
   729 00001ECB 5245540008C3C2F1        I_RET db 82,69,84,0,8,195,194,241
   730                                  
   731                                  ;-105 char I_RETF[]= {'R','E','T','F',0,      8,0xCB,0xCA,0xF1};
   732                                  
   733 00001ED3 524554460008CBCAF1      I_RETF db 82,69,84,70,0,8,203,202,241
   734                                  
   735                                  ;-106 //  9: seg, r/m
   736                                  
   737                                  
   738                                  ;-107 char I_PUSH[]= {'P','U','S','H',0,      9,0x50,0xFF,6,6,0xF1};//r16
   739                                  
   740 00001EDC 50555348000950FF06-     I_PUSH db 80,85,83,72,0,9,80,255,6,6,241
   741 00001EE5 06F1               
   742                                  
   743                                  ;-108 char I_POP[]=  {'P','O','P',0,          9,0x58,0x8F,0,7,0xF1};//r16
   744                                  
   745 00001EE7 504F500009588F0007-     I_POP db 80,79,80,0,9,88,143,0,7,241
   746 00001EF0 F1                 
   747                                  
   748                                  ;-109 //  11: shift, rotates
   749                                  
   750                                  
   751                                  ;-110 char I_ROL[]=  {'R','O','L',0,          11, 0,    0xF1};
   752                                  
   753 00001EF1 524F4C000B00F1          I_ROL db 82,79,76,0,11,0,241
   754                                  
   755                                  ;-111 char I_ROR[]=  {'R','O','R',0,          11, 1,    0xF1};
   756                                  
   757 00001EF8 524F52000B01F1          I_ROR db 82,79,82,0,11,1,241
   758                                  
   759                                  ;-112 char I_RCL[]=  {'R','C','L',0,          11, 2,    0xF1};
   760                                  
   761 00001EFF 52434C000B02F1          I_RCL db 82,67,76,0,11,2,241
   762                                  
   763                                  ;-113 char I_RCR[]=  {'R','C','R',0,          11, 3,    0xF1};
   764                                  
   765 00001F06 524352000B03F1          I_RCR db 82,67,82,0,11,3,241
   766                                  
   767                                  ;-114 char I_SHL[]=  {'S','H','L',0,          11, 4,    0xF1};
   768                                  
   769 00001F0D 53484C000B04F1          I_SHL db 83,72,76,0,11,4,241
   770                                  
   771                                  ;-115 char I_SAL[]=  {'S','A','L',0,          11, 5,    0xF1};
   772                                  
   773 00001F14 53414C000B05F1          I_SAL db 83,65,76,0,11,5,241
   774                                  
   775                                  ;-116 char I_SHR[]=  {'S','H','R',0,          11, 6,    0xF1};
   776                                  
   777 00001F1B 534852000B06F1          I_SHR db 83,72,82,0,11,6,241
   778                                  
   779                                  ;-117 char I_SAR[]=  {'S','A','R',0,          11, 7,    0xF1};
   780                                  
   781 00001F22 534152000B07F1          I_SAR db 83,65,82,0,11,7,241
   782                                  
   783                                  ;-118 //  12: int
   784                                  
   785                                  
   786                                  ;-119 char I_INT[]=  {'I','N','T',0,          12,0xCD,0xCC,0xF1};
   787                                  
   788 00001F29 494E54000CCDCCF1        I_INT db 73,78,84,0,12,205,204,241
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
   822 00001F31 58434847000F8690F1      I_XCHG db 88,67,72,71,0,15,134,144,241
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
   853 00001F3A 454E544552001EF1        I_ENTER db 69,78,84,69,82,0,30,241
   854                                  
   855                                  ;-141 // 100: directives
   856                                  
   857                                  
   858                                  ;-142 char I_ORG[]=  {'O','R','G',0,        101,        0xF1};
   859                                  
   860 00001F42 4F52470065F1            I_ORG db 79,82,71,0,101,241
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
   876 00001F48 444200C8F1              I_DB db 68,66,0,200,241
   877                                  
   878                                  ;-148 char I_DW[]=   {'D','W',0,            201,        0xF1};
   879                                  
   880 00001F4D 445700C9F1              I_DW db 68,87,0,201,241
   881                                  
   882                                  ;-149 char I_DD[]=   {'D','D',0,            202,        0xF1};
   883                                  
   884 00001F52 444400CAF1              I_DD db 68,68,0,202,241
   885                                  
   886                                  ;-150 char I_RESB[]= {'R','E','S','B',0,    205,        0xF1};
   887                                  
   888 00001F57 5245534200CDF1          I_RESB db 82,69,83,66,0,205,241
   889                                  
   890                                  ;-151 char I_RESW[]= {'R','E','S','W',0,    206,        0xF1};
   891                                  
   892 00001F5E 5245535700CEF1          I_RESW db 82,69,83,87,0,206,241
   893                                  
   894                                  ;-152 char I_RESD[]= {'R','E','S','D',0,    207,        0xF1};
   895                                  
   896 00001F65 5245534400CFF1          I_RESD db 82,69,83,68,0,207,241
   897                                  
   898                                  ;-153 char I_END=0;// end of table char
   899                                  
   900 00001F6C 00                      I_END db 0
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
   920 00001F6D C8020000                 ENTER  2,0
   921 00001F71 A0[AC01]                 mov al, [Op]
   922 00001F74 8846FE                   mov byte [bp-2], al
   923 00001F77 A0[AD01]                 mov al, [Op2]
   924 00001F7A A2[AC01]                 mov byte [Op], al
   925 00001F7D 8A46FE                   mov al, [bp-2]
   926 00001F80 A2[AD01]                 mov byte [Op2], al
   927                                  
   928                                  ;-4     c=R1Type; R1Type=R2Type; R2Type=c;
   929                                  
   930 00001F83 A0[B501]                 mov al, [R1Type]
   931 00001F86 8846FE                   mov byte [bp-2], al
   932 00001F89 A0[B401]                 mov al, [R2Type]
   933 00001F8C A2[B501]                 mov byte [R1Type], al
   934 00001F8F 8A46FE                   mov al, [bp-2]
   935 00001F92 A2[B401]                 mov byte [R2Type], al
   936                                  
   937                                  ;-5     c=R1No;   R1No  =R2No;   R2No  =c;
   938                                  
   939 00001F95 A0[B301]                 mov al, [R1No]
   940 00001F98 8846FE                   mov byte [bp-2], al
   941 00001F9B A0[B201]                 mov al, [R2No]
   942 00001F9E A2[B301]                 mov byte [R1No], al
   943 00001FA1 8A46FE                   mov al, [bp-2]
   944 00001FA4 A2[B201]                 mov byte [R2No], al
   945                                  
   946                                  ;-6     dflag=2;     
   947                                  
   948 00001FA7 66B802000000             mov eax, 2
   949 00001FAD A2[B801]                 mov byte [dflag], al
   950                                  
   951                                  ;-7 }
   952                                  
   953                                  
   954                                  ;-8      
   955                                  
   956                                  
   957                                  ;-9 int checkOpL() {
   958 00001FB0 C9                       LEAVE
   959 00001FB1 C3                       ret
   960                                  ; ENDP
   961                                  
   962                                  checkOpL:  ; *** PROC ***
   963                                  
   964                                  ;-10     if (Op == ADR) implerror();
   965                                  
   966 00001FB2 A0[AC01]                 mov al, [Op]
   967 00001FB5 3C03                     cmp al, 3
   968 00001FB7 0F850300                 jne @@checkOpL1
   969 00001FBB E88615                   call implerror
   970                                  
   971                                  ;-11     if (R1Type==SEGREG) {segregerror();return;}//only move,push,pop
   972                                  
   973                                  @@checkOpL1:
   974 00001FBE A0[B501]                 mov al, [R1Type]
   975 00001FC1 3C04                     cmp al, 4
   976 00001FC3 0F850600                 jne @@checkOpL2
   977 00001FC7 E84216                   call segregerror
   978 00001FCA E93E00                   jmp @@retn
   979                                  
   980                                  ;-12     setwflag();
   981                                  
   982                                  @@checkOpL2:
   983 00001FCD E8CB03                   call setwflag
   984                                  
   985                                  ;-13     if (OpSize == 0) error1("no op size declared");
   986                                  
   987 00001FD0 A0[B601]                 mov al, [OpSize]
   988 00001FD3 3C00                     cmp al, 0
   989 00001FD5 0F850900                 jne @@checkOpL3
   990 00001FD9 68[0C20]                 push checkOpL_0
   991 00001FDC E89514                   call error1
   992 00001FDF 83C402                   add  sp, 2
   993                                  
   994                                  ;-14     if (OpSize == R1Type) return;
   995                                  
   996                                  @@checkOpL3:
   997 00001FE2 A0[B601]                 mov al, [OpSize]
   998 00001FE5 3A06[B501]               cmp al, [R1Type]
   999 00001FE9 0F850300                 jne @@checkOpL4
  1000 00001FED E91B00                   jmp @@retn
  1001                                  
  1002                                  ;-15     if (Op == REG) if (R1Type==0) error1("no register defined");
  1003                                  
  1004                                  @@checkOpL4:
  1005 00001FF0 A0[AC01]                 mov al, [Op]
  1006 00001FF3 3C02                     cmp al, 2
  1007 00001FF5 0F851200                 jne @@checkOpL5
  1008 00001FF9 A0[B501]                 mov al, [R1Type]
  1009 00001FFC 3C00                     cmp al, 0
  1010 00001FFE 0F850900                 jne @@checkOpL6
  1011 00002002 68[2020]                 push checkOpL_1
  1012 00002005 E86C14                   call error1
  1013 00002008 83C402                   add  sp, 2
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
  1026 0000200B C3                       ret
  1027                                  ; ENDP
  1028 0000200C 6E6F206F702073697A-     checkOpL_0 db "no op size declared",0
  1029 00002015 65206465636C617265-
  1030 0000201E 6400               
  1031 00002020 6E6F20726567697374-     checkOpL_1 db "no register defined",0
  1032 00002029 657220646566696E65-
  1033 00002032 6400               
  1034                                  
  1035                                  check2Ops:  ; *** PROC ***
  1036                                  
  1037                                  ;-19     get2Ops();
  1038                                  
  1039 00002034 E84900                   call get2Ops
  1040                                  
  1041                                  ;-20     if (Op ==   0) addrerror();
  1042                                  
  1043 00002037 A0[AC01]                 mov al, [Op]
  1044 0000203A 3C00                     cmp al, 0
  1045 0000203C 0F850300                 jne @@check2Ops7
  1046 00002040 E8C214                   call addrerror
  1047                                  
  1048                                  ;-21     if (Op == ADR) invaloperror(); 
  1049                                  
  1050                                  @@check2Ops7:
  1051 00002043 A0[AC01]                 mov al, [Op]
  1052 00002046 3C03                     cmp al, 3
  1053 00002048 0F850300                 jne @@check2Ops8
  1054 0000204C E83015                   call invaloperror
  1055                                  
  1056                                  ;-22     if (Op == IMM) immeerror();   
  1057                                  
  1058                                  @@check2Ops8:
  1059 0000204F A0[AC01]                 mov al, [Op]
  1060 00002052 3C01                     cmp al, 1
  1061 00002054 0F850300                 jne @@check2Ops9
  1062 00002058 E8C414                   call immeerror
  1063                                  
  1064                                  ;-23     if (Op2==   0) addrerror();
  1065                                  
  1066                                  @@check2Ops9:
  1067 0000205B A0[AD01]                 mov al, [Op2]
  1068 0000205E 3C00                     cmp al, 0
  1069 00002060 0F850300                 jne @@check2Ops10
  1070 00002064 E89E14                   call addrerror
  1071                                  
  1072                                  ;-24     if (CodeType != 5) if (Op2==ADR) invaloperror();//allowed in mov           
  1073                                  
  1074                                  @@check2Ops10:
  1075 00002067 A0[AE01]                 mov al, [CodeType]
  1076 0000206A 3C05                     cmp al, 5
  1077 0000206C 0F840C00                 je  @@check2Ops11
  1078 00002070 A0[AD01]                 mov al, [Op2]
  1079 00002073 3C03                     cmp al, 3
  1080 00002075 0F850300                 jne @@check2Ops12
  1081 00002079 E80315                   call invaloperror
  1082                                  
  1083                                  ;-25     setwflag();       
  1084                                  
  1085                                  @@check2Ops12:
  1086                                  @@check2Ops11:
  1087 0000207C E81C03                   call setwflag
  1088                                  
  1089                                  ;-26 }    
  1090                                  
  1091                                  
  1092                                  ;-27 int get2Ops() {
  1093                                  
  1094 0000207F C3                       ret
  1095                                  ; ENDP
  1096                                  
  1097                                  get2Ops:  ; *** PROC ***
  1098                                  
  1099                                  ;-28     getOpL();
  1100                                  
  1101 00002080 E80C00                   call getOpL
  1102                                  
  1103                                  ;-29     need(',');    
  1104                                  
  1105 00002083 6A2C                     push 44
  1106 00002085 E8C309                   call need
  1107 00002088 83C402                   add  sp, 2
  1108                                  
  1109                                  ;-30     getOpR();         
  1110                                  
  1111 0000208B E83200                   call getOpR
  1112                                  
  1113                                  ;-31 } 
  1114                                  
  1115                                  
  1116                                  ;-32         
  1117                                  
  1118                                  
  1119                                  ;-33 int getOpL() {
  1120                                  
  1121 0000208E C3                       ret
  1122                                  ; ENDP
  1123                                  
  1124                                  getOpL:  ; *** PROC ***
  1125                                  
  1126                                  ;-34 //set: op=0,IMM,REG,ADR,MEM
  1127                                  
  1128                                  
  1129                                  ;-35     getOpR();
  1130                                  
  1131 0000208F E82E00                   call getOpR
  1132                                  
  1133                                  ;-36     Op=Op2;         Op2=0;
  1134                                  
  1135 00002092 A0[AD01]                 mov al, [Op2]
  1136 00002095 A2[AC01]                 mov byte [Op], al
  1137 00002098 66B800000000             mov eax, 0
  1138 0000209E A2[AD01]                 mov byte [Op2], al
  1139                                  
  1140                                  ;-37     R1No=R2No;      R2No=0;
  1141                                  
  1142 000020A1 A0[B201]                 mov al, [R2No]
  1143 000020A4 A2[B301]                 mov byte [R1No], al
  1144 000020A7 66B800000000             mov eax, 0
  1145 000020AD A2[B201]                 mov byte [R2No], al
  1146                                  
  1147                                  ;-38     R1Type=R2Type; R2Type=0; 
  1148                                  
  1149 000020B0 A0[B401]                 mov al, [R2Type]
  1150 000020B3 A2[B501]                 mov byte [R1Type], al
  1151 000020B6 66B800000000             mov eax, 0
  1152 000020BC A2[B401]                 mov byte [R2Type], al
  1153                                  
  1154                                  ;-39 }  
  1155                                  
  1156                                  
  1157                                  ;-40 
  1158                                  
  1159                                  
  1160                                  ;-41 int getOpR() {
  1161                                  
  1162 000020BF C3                       ret
  1163                                  ; ENDP
  1164                                  
  1165                                  getOpR:  ; *** PROC ***
  1166                                  
  1167                                  ;-42     Op2=getOp1();
  1168                                  
  1169 000020C0 E88900                   call getOp1
  1170 000020C3 A2[AD01]                 mov byte [Op2], al
  1171                                  
  1172                                  ;-43     if (isToken('[')) {Op2 = MEM; getMEM();    return;}
  1173                                  
  1174 000020C6 6A5B                     push 91
  1175 000020C8 E85209                   call isToken
  1176 000020CB 83C402                   add  sp, 2
  1177 000020CE 08C0                     or  al, al
  1178 000020D0 0F840F00                 je @@getOpR13
  1179 000020D4 66B804000000             mov eax, 4
  1180 000020DA A2[AD01]                 mov byte [Op2], al
  1181 000020DD E8F200                   call getMEM
  1182 000020E0 E94F00                   jmp @@retn
  1183                                  
  1184                                  ;-44     if (Op2 == 0)     {invaloperror();         return;}
  1185                                  
  1186                                  @@getOpR13:
  1187 000020E3 A0[AD01]                 mov al, [Op2]
  1188 000020E6 3C00                     cmp al, 0
  1189 000020E8 0F850600                 jne @@getOpR14
  1190 000020EC E89014                   call invaloperror
  1191 000020EF E94000                   jmp @@retn
  1192                                  
  1193                                  ;-45     if (Op2 == IMM)   {imme=SymbolInt;         return;}
  1194                                  
  1195                                  @@getOpR14:
  1196 000020F2 A0[AD01]                 mov al, [Op2]
  1197 000020F5 3C01                     cmp al, 1
  1198 000020F7 0F850900                 jne @@getOpR15
  1199 000020FB A1[4D00]                 mov ax, [SymbolInt]
  1200 000020FE A3[BE01]                 mov word [imme], ax
  1201 00002101 E92E00                   jmp @@retn
  1202                                  
  1203                                  ;-46     if (Op2 == REG)                            return;
  1204                                  
  1205                                  @@getOpR15:
  1206 00002104 A0[AD01]                 mov al, [Op2]
  1207 00002107 3C02                     cmp al, 2
  1208 00002109 0F850300                 jne @@getOpR16
  1209 0000210D E92200                   jmp @@retn
  1210                                  
  1211                                  ;-47     if (Op2 == ADR)   {disp=LabelAddr[LabelIx];return;}
  1212                                  
  1213                                  @@getOpR16:
  1214 00002110 A0[AD01]                 mov al, [Op2]
  1215 00002113 3C03                     cmp al, 3
  1216 00002115 0F851000                 jne @@getOpR17
  1217 00002119 8B1E[7E06]               mov bx, [LabelIx]
  1218 0000211D D1E3                     shl bx, 1
  1219 0000211F 8B87[B405]               mov ax, [LabelAddr + bx]
  1220 00002123 A3[BC01]                 mov word [disp], ax
  1221 00002126 E90900                   jmp @@retn
  1222                                  
  1223                                  ;-48     error1("Name of operand expected");
  1224                                  
  1225                                  @@getOpR17:
  1226 00002129 68[3321]                 push getOpR_0
  1227 0000212C E84513                   call error1
  1228 0000212F 83C402                   add  sp, 2
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
  1239 00002132 C3                       ret
  1240                                  ; ENDP
  1241 00002133 4E616D65206F66206F-     getOpR_0 db "Name of operand expected",0
  1242 0000213C 706572616E64206578-
  1243 00002145 70656374656400     
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
  1258 0000214C A0[AB01]                 mov al, [TokeType]
  1259 0000214F 3C00                     cmp al, 0
  1260 00002151 0F850900                 jne @@getOp118
  1261 00002155 66B800000000             mov eax, 0
  1262 0000215B E96000                   jmp @@retn
  1263                                  
  1264                                  ;-56     if (TokeType == DIGIT)  return IMM;
  1265                                  
  1266                                  @@getOp118:
  1267 0000215E A0[AB01]                 mov al, [TokeType]
  1268 00002161 3C01                     cmp al, 1
  1269 00002163 0F850900                 jne @@getOp119
  1270 00002167 66B801000000             mov eax, 1
  1271 0000216D E94E00                   jmp @@retn
  1272                                  
  1273                                  ;-57     if (TokeType == ALNUME) {
  1274                                  
  1275                                  @@getOp119:
  1276 00002170 A0[AB01]                 mov al, [TokeType]
  1277 00002173 3C03                     cmp al, 3
  1278 00002175 0F853C00                 jne @@getOp120
  1279                                  
  1280                                  ;-58         R2No=testReg();
  1281                                  
  1282 00002179 E84E0C                   call testReg
  1283 0000217C A2[B201]                 mov byte [R2No], al
  1284                                  
  1285                                  ;-59         if (R2Type)        return REG;
  1286                                  
  1287 0000217F A0[B401]                 mov al, [R2Type]
  1288 00002182 08C0                     or  al, al
  1289 00002184 0F840900                 je @@getOp121
  1290 00002188 66B802000000             mov eax, 2
  1291 0000218E E92D00                   jmp @@retn
  1292                                  
  1293                                  ;-60         LabelIx=searchLabel();
  1294                                  
  1295                                  @@getOp121:
  1296 00002191 E8FA05                   call searchLabel
  1297 00002194 A3[7E06]                 mov word [LabelIx], ax
  1298                                  
  1299                                  ;-61         if (LabelIx)        return ADR;
  1300                                  
  1301 00002197 A1[7E06]                 mov ax, [LabelIx]
  1302 0000219A 08C0                     or  al, al
  1303 0000219C 0F840C00                 je @@getOp122
  1304 000021A0 66B803000000             mov eax, 3
  1305 000021A6 E91500                   jmp @@retn
  1306                                  
  1307                                  ;-62         else error1("variable not found"); 
  1308                                  
  1309 000021A9 E90900                   jmp @@getOp123
  1310                                  @@getOp122:
  1311 000021AC 68[BF21]                 push getOp1_0
  1312 000021AF E8C212                   call error1
  1313 000021B2 83C402                   add  sp, 2
  1314                                  
  1315                                  ;-63     }
  1316                                  
  1317                                  @@getOp123:
  1318                                  
  1319                                  ;-64     return 0;
  1320                                  
  1321                                  @@getOp120:
  1322 000021B5 66B800000000             mov eax, 0
  1323 000021BB E90000                   jmp @@retn
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
  1334 000021BE C3                       ret
  1335                                  ; ENDP
  1336 000021BF 7661726961626C6520-     getOp1_0 db "variable not found",0
  1337 000021C8 6E6F7420666F756E64-
  1338 000021D1 00                 
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
  1353 000021D2 C8020000                 ENTER  2,0
  1354 000021D6 66B800000000             mov eax, 0
  1355 000021DC A3[BC01]                 mov word [disp], ax
  1356 000021DF 66B800000000             mov eax, 0
  1357 000021E5 A2[BA01]                 mov byte [rm], al
  1358                                  
  1359                                  ;-71     do {
  1360                                  
  1361                                  @@getMEM24:
  1362                                  
  1363                                  ;-72         getTokeType();
  1364                                  
  1365 000021E8 E8D203                   call getTokeType
  1366                                  
  1367                                  ;-73         c=getOp1();
  1368                                  
  1369 000021EB E85EFF                   call getOp1
  1370 000021EE 8846FE                   mov byte [bp-2], al
  1371                                  
  1372                                  ;-74         if (c ==   0) syntaxerror();
  1373                                  
  1374 000021F1 8A46FE                   mov al, [bp-2]
  1375 000021F4 3C00                     cmp al, 0
  1376 000021F6 0F850300                 jne @@getMEM25
  1377 000021FA E83614                   call syntaxerror
  1378                                  
  1379                                  ;-75         if (c == REG) {
  1380                                  
  1381                                  @@getMEM25:
  1382 000021FD 8A46FE                   mov al, [bp-2]
  1383 00002200 3C02                     cmp al, 2
  1384 00002202 0F851E00                 jne @@getMEM26
  1385                                  
  1386                                  ;-76             isDirect=0;
  1387                                  
  1388 00002206 66B800000000             mov eax, 0
  1389 0000220C A2[BB01]                 mov byte [isDirect], al
  1390                                  
  1391                                  ;-77             if (rm) rm=getIndReg2();
  1392                                  
  1393 0000220F A0[BA01]                 mov al, [rm]
  1394 00002212 08C0                     or  al, al
  1395 00002214 0F840900                 je @@getMEM27
  1396 00002218 E8F300                   call getIndReg2
  1397 0000221B A2[BA01]                 mov byte [rm], al
  1398                                  
  1399                                  ;-78             else getIndReg1();
  1400                                  
  1401 0000221E E90300                   jmp @@getMEM28
  1402                                  @@getMEM27:
  1403 00002221 E88900                   call getIndReg1
  1404                                  
  1405                                  ;-79         }
  1406                                  
  1407                                  @@getMEM28:
  1408                                  
  1409                                  ;-80         if (c == ADR) disp=disp+LabelAddr[LabelIx];
  1410                                  
  1411                                  @@getMEM26:
  1412 00002224 8A46FE                   mov al, [bp-2]
  1413 00002227 3C03                     cmp al, 3
  1414 00002229 0F851000                 jne @@getMEM29
  1415 0000222D A1[BC01]                 mov ax, [disp]
  1416 00002230 8B1E[7E06]               mov bx, [LabelIx]
  1417 00002234 D1E3                     shl bx, 1
  1418 00002236 0387[B405]               add ax, [LabelAddr + bx]
  1419 0000223A A3[BC01]                 mov word [disp], ax
  1420                                  
  1421                                  ;-81         if (c == IMM) disp=disp+SymbolInt;
  1422                                  
  1423                                  @@getMEM29:
  1424 0000223D 8A46FE                   mov al, [bp-2]
  1425 00002240 3C01                     cmp al, 1
  1426 00002242 0F850A00                 jne @@getMEM30
  1427 00002246 A1[BC01]                 mov ax, [disp]
  1428 00002249 0306[4D00]               add ax, [SymbolInt]
  1429 0000224D A3[BC01]                 mov word [disp], ax
  1430                                  
  1431                                  ;-82         if (isToken('-')) {
  1432                                  
  1433                                  @@getMEM30:
  1434 00002250 6A2D                     push 45
  1435 00002252 E8C807                   call isToken
  1436 00002255 83C402                   add  sp, 2
  1437 00002258 08C0                     or  al, al
  1438 0000225A 0F841900                 je @@getMEM31
  1439                                  
  1440                                  ;-83             getTokeType();
  1441                                  
  1442 0000225E E85C03                   call getTokeType
  1443                                  
  1444                                  ;-84             if (TokeType != DIGIT) numbererror();
  1445                                  
  1446 00002261 A0[AB01]                 mov al, [TokeType]
  1447 00002264 3C01                     cmp al, 1
  1448 00002266 0F840300                 je  @@getMEM32
  1449 0000226A E83313                   call numbererror
  1450                                  
  1451                                  ;-85             disp = disp - SymbolInt;
  1452                                  
  1453                                  @@getMEM32:
  1454 0000226D A1[BC01]                 mov ax, [disp]
  1455 00002270 2B06[4D00]               sub ax, [SymbolInt]
  1456 00002274 A3[BC01]                 mov word [disp], ax
  1457                                  
  1458                                  ;-86         }
  1459                                  
  1460                                  
  1461                                  ;-87     } while (isToken('+'));
  1462                                  
  1463                                  @@getMEM31:
  1464 00002277 6A2B                     push 43
  1465 00002279 E8A107                   call isToken
  1466 0000227C 83C402                   add  sp, 2
  1467 0000227F 08C0                     or  al, al
  1468 00002281 0F840300                 je @@getMEM33
  1469 00002285 E960FF                   jmp @@getMEM24
  1470                                  @@getMEM33:
  1471                                  
  1472                                  ;-88     if (isToken(']') == 0) errorexit("] expected");
  1473                                  
  1474 00002288 6A5D                     push 93
  1475 0000228A E89007                   call isToken
  1476 0000228D 83C402                   add  sp, 2
  1477 00002290 83F800                   cmp ax, 0
  1478 00002293 0F850900                 jne @@getMEM34
  1479 00002297 68[A222]                 push getMEM_0
  1480 0000229A E83612                   call errorexit
  1481 0000229D 83C402                   add  sp, 2
  1482                                  
  1483                                  ;-89 }
  1484                                  
  1485                                  @@getMEM34:
  1486                                  
  1487                                  ;-90 int getIndReg1() {
  1488 000022A0 C9                       LEAVE
  1489 000022A1 C3                       ret
  1490                                  ; ENDP
  1491 000022A2 5D2065787065637465-     getMEM_0 db "] expected",0
  1492 000022AB 6400               
  1493                                  
  1494                                  getIndReg1:  ; *** PROC ***
  1495                                  
  1496                                  ;-91     if (R2Type !=WORD) indexerror();
  1497                                  
  1498 000022AD A0[B401]                 mov al, [R2Type]
  1499 000022B0 3C02                     cmp al, 2
  1500 000022B2 0F840300                 je  @@getIndReg135
  1501 000022B6 E8A512                   call indexerror
  1502                                  
  1503                                  ;-92     if (R2No==3) rm=7;//BX
  1504                                  
  1505                                  @@getIndReg135:
  1506 000022B9 A0[B201]                 mov al, [R2No]
  1507 000022BC 3C03                     cmp al, 3
  1508 000022BE 0F850900                 jne @@getIndReg136
  1509 000022C2 66B807000000             mov eax, 7
  1510 000022C8 A2[BA01]                 mov byte [rm], al
  1511                                  
  1512                                  ;-93     if (R2No==5) rm=6;//BP, change to BP+0
  1513                                  
  1514                                  @@getIndReg136:
  1515 000022CB A0[B201]                 mov al, [R2No]
  1516 000022CE 3C05                     cmp al, 5
  1517 000022D0 0F850900                 jne @@getIndReg137
  1518 000022D4 66B806000000             mov eax, 6
  1519 000022DA A2[BA01]                 mov byte [rm], al
  1520                                  
  1521                                  ;-94     if (R2No==7) rm=5;//DI
  1522                                  
  1523                                  @@getIndReg137:
  1524 000022DD A0[B201]                 mov al, [R2No]
  1525 000022E0 3C07                     cmp al, 7
  1526 000022E2 0F850900                 jne @@getIndReg138
  1527 000022E6 66B805000000             mov eax, 5
  1528 000022EC A2[BA01]                 mov byte [rm], al
  1529                                  
  1530                                  ;-95     if (R2No==6) rm=4;//SI
  1531                                  
  1532                                  @@getIndReg138:
  1533 000022EF A0[B201]                 mov al, [R2No]
  1534 000022F2 3C06                     cmp al, 6
  1535 000022F4 0F850900                 jne @@getIndReg139
  1536 000022F8 66B804000000             mov eax, 4
  1537 000022FE A2[BA01]                 mov byte [rm], al
  1538                                  
  1539                                  ;-96     if (rm==0) indexerror();
  1540                                  
  1541                                  @@getIndReg139:
  1542 00002301 A0[BA01]                 mov al, [rm]
  1543 00002304 3C00                     cmp al, 0
  1544 00002306 0F850300                 jne @@getIndReg140
  1545 0000230A E85112                   call indexerror
  1546                                  
  1547                                  ;-97 }
  1548                                  
  1549                                  @@getIndReg140:
  1550                                  
  1551                                  ;-98 int getIndReg2() {char m; m=4;//because m=0 is BX+DI
  1552                                  
  1553 0000230D C3                       ret
  1554                                  ; ENDP
  1555                                  
  1556                                  getIndReg2:  ; *** PROC ***
  1557                                  ;Function : getIndReg2, Number of local variables: 1
  1558                                  ;   # type sign width line used address name   list of local variables
  1559                                  ;  200 var sign byte    98 NULL bp-2    m;
  1560 0000230E C8020000                 ENTER  2,0
  1561 00002312 66B804000000             mov eax, 4
  1562 00002318 8846FE                   mov byte [bp-2], al
  1563                                  
  1564                                  ;-99     if (R2Type !=WORD) indexerror();
  1565                                  
  1566 0000231B A0[B401]                 mov al, [R2Type]
  1567 0000231E 3C02                     cmp al, 2
  1568 00002320 0F840300                 je  @@getIndReg241
  1569 00002324 E83712                   call indexerror
  1570                                  
  1571                                  ;-100     if (R2No==7) if (rm==6) m=3;//BP+DI
  1572                                  
  1573                                  @@getIndReg241:
  1574 00002327 A0[B201]                 mov al, [R2No]
  1575 0000232A 3C07                     cmp al, 7
  1576 0000232C 0F852700                 jne @@getIndReg242
  1577 00002330 A0[BA01]                 mov al, [rm]
  1578 00002333 3C06                     cmp al, 6
  1579 00002335 0F850C00                 jne @@getIndReg243
  1580 00002339 66B803000000             mov eax, 3
  1581 0000233F 8846FE                   mov byte [bp-2], al
  1582                                  
  1583                                  ;-101              else if (rm==7) m=1;//BX+DI
  1584                                  
  1585 00002342 E91200                   jmp @@getIndReg244
  1586                                  @@getIndReg243:
  1587 00002345 A0[BA01]                 mov al, [rm]
  1588 00002348 3C07                     cmp al, 7
  1589 0000234A 0F850900                 jne @@getIndReg245
  1590 0000234E 66B801000000             mov eax, 1
  1591 00002354 8846FE                   mov byte [bp-2], al
  1592                                  
  1593                                  ;-102     if (R2No==6) if (rm==6) m=2;//BP+SI
  1594                                  
  1595                                  @@getIndReg245:
  1596                                  @@getIndReg244:
  1597                                  @@getIndReg242:
  1598 00002357 A0[B201]                 mov al, [R2No]
  1599 0000235A 3C06                     cmp al, 6
  1600 0000235C 0F852700                 jne @@getIndReg246
  1601 00002360 A0[BA01]                 mov al, [rm]
  1602 00002363 3C06                     cmp al, 6
  1603 00002365 0F850C00                 jne @@getIndReg247
  1604 00002369 66B802000000             mov eax, 2
  1605 0000236F 8846FE                   mov byte [bp-2], al
  1606                                  
  1607                                  ;-103              else if (rm==7) m=0;//BX+SI
  1608                                  
  1609 00002372 E91200                   jmp @@getIndReg248
  1610                                  @@getIndReg247:
  1611 00002375 A0[BA01]                 mov al, [rm]
  1612 00002378 3C07                     cmp al, 7
  1613 0000237A 0F850900                 jne @@getIndReg249
  1614 0000237E 66B800000000             mov eax, 0
  1615 00002384 8846FE                   mov byte [bp-2], al
  1616                                  
  1617                                  ;-104     if (m > 3) indexerror();
  1618                                  
  1619                                  @@getIndReg249:
  1620                                  @@getIndReg248:
  1621                                  @@getIndReg246:
  1622 00002387 8A46FE                   mov al, [bp-2]
  1623 0000238A 3C03                     cmp al, 3
  1624 0000238C 0F8E0300                 jle @@getIndReg250
  1625 00002390 E8CB11                   call indexerror
  1626                                  
  1627                                  ;-105     return m;
  1628                                  
  1629                                  @@getIndReg250:
  1630 00002393 8A46FE                   mov al, [bp-2]
  1631 00002396 E90000                   jmp @@retn
  1632                                  
  1633                                  ;-106 }
  1634                                  
  1635                                  
  1636                                  ;-107                   
  1637                                  
  1638                                  
  1639                                  ;-108 int setwflag() {//word size, bit 0
  1640                                  
  1641 00002399 C9                      @@retn: LEAVE
  1642 0000239A C3                       ret
  1643                                  ; ENDP
  1644                                  
  1645                                  setwflag:  ; *** PROC ***
  1646                                  
  1647                                  ;-109     wflag=0;
  1648                                  
  1649 0000239B 66B800000000             mov eax, 0
  1650 000023A1 A2[B701]                 mov byte [wflag], al
  1651                                  
  1652                                  ;-110     if (OpSize == 0) {//do not override OpSize
  1653                                  
  1654 000023A4 A0[B601]                 mov al, [OpSize]
  1655 000023A7 3C00                     cmp al, 0
  1656 000023A9 0F854200                 jne @@setwflag51
  1657                                  
  1658                                  ;-111         if (Op == REG) OpSize=R1Type;
  1659                                  
  1660 000023AD A0[AC01]                 mov al, [Op]
  1661 000023B0 3C02                     cmp al, 2
  1662 000023B2 0F850600                 jne @@setwflag52
  1663 000023B6 A0[B501]                 mov al, [R1Type]
  1664 000023B9 A2[B601]                 mov byte [OpSize], al
  1665                                  
  1666                                  ;-112         if (Op2== REG) OpSize=R2Type;        
  1667                                  
  1668                                  @@setwflag52:
  1669 000023BC A0[AD01]                 mov al, [Op2]
  1670 000023BF 3C02                     cmp al, 2
  1671 000023C1 0F850600                 jne @@setwflag53
  1672 000023C5 A0[B401]                 mov al, [R2Type]
  1673 000023C8 A2[B601]                 mov byte [OpSize], al
  1674                                  
  1675                                  ;-113         if (R2Type== SEGREG) OpSize=WORD;
  1676                                  
  1677                                  @@setwflag53:
  1678 000023CB A0[B401]                 mov al, [R2Type]
  1679 000023CE 3C04                     cmp al, 4
  1680 000023D0 0F850900                 jne @@setwflag54
  1681 000023D4 66B802000000             mov eax, 2
  1682 000023DA A2[B601]                 mov byte [OpSize], al
  1683                                  
  1684                                  ;-114         if (R1Type == SEGREG) OpSize=WORD;        
  1685                                  
  1686                                  @@setwflag54:
  1687 000023DD A0[B501]                 mov al, [R1Type]
  1688 000023E0 3C04                     cmp al, 4
  1689 000023E2 0F850900                 jne @@setwflag55
  1690 000023E6 66B802000000             mov eax, 2
  1691 000023EC A2[B601]                 mov byte [OpSize], al
  1692                                  
  1693                                  ;-115     }
  1694                                  
  1695                                  @@setwflag55:
  1696                                  
  1697                                  ;-116     if (OpSize  == DWORD) {gen66h(); wflag=1;}
  1698                                  
  1699                                  @@setwflag51:
  1700 000023EF A0[B601]                 mov al, [OpSize]
  1701 000023F2 3C03                     cmp al, 3
  1702 000023F4 0F850C00                 jne @@setwflag56
  1703 000023F8 E8C316                   call gen66h
  1704 000023FB 66B801000000             mov eax, 1
  1705 00002401 A2[B701]                 mov byte [wflag], al
  1706                                  
  1707                                  ;-117     if (OpSize  ==  WORD) wflag=1;
  1708                                  
  1709                                  @@setwflag56:
  1710 00002404 A0[B601]                 mov al, [OpSize]
  1711 00002407 3C02                     cmp al, 2
  1712 00002409 0F850900                 jne @@setwflag57
  1713 0000240D 66B801000000             mov eax, 1
  1714 00002413 A2[B701]                 mov byte [wflag], al
  1715                                  
  1716                                  ;-118 }
  1717                                  
  1718                                  @@setwflag57:
  1719                                  
  1720                                  ;-119 int setsflag() {//sign-extend, bit 1, only PUSH, ALU, IMUL3 
  1721                                  
  1722 00002416 C3                       ret
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
  1735 00002417 C8020000                 ENTER  2,0
  1736 0000241B 66B802000000             mov eax, 2
  1737 00002421 A2[B901]                 mov byte [sflag], al
  1738                                  
  1739                                  ;-122     ui = imme & 0xFF80;//is greater than signed 127? 
  1740                                  
  1741 00002424 A1[BE01]                 mov ax, [imme]
  1742 00002427 2580FF                   and ax, 65408
  1743 0000242A 8946FE                   mov word [bp-2], ax
  1744                                  
  1745                                  ;-123     if(ui != 0) sflag = 0;
  1746                                  
  1747 0000242D 8B46FE                   mov ax, [bp-2]
  1748 00002430 83F800                   cmp ax, 0
  1749 00002433 0F840900                 je  @@setsflag58
  1750 00002437 66B800000000             mov eax, 0
  1751 0000243D A2[B901]                 mov byte [sflag], al
  1752                                  
  1753                                  ;-124     if (OpSize == BYTE) {
  1754                                  
  1755                                  @@setsflag58:
  1756 00002440 A0[B601]                 mov al, [OpSize]
  1757 00002443 3C01                     cmp al, 1
  1758 00002445 0F851C00                 jne @@setsflag59
  1759                                  
  1760                                  ;-125         if (imme > 255) error1("too big for byte r/m");
  1761                                  
  1762 00002449 A1[BE01]                 mov ax, [imme]
  1763 0000244C 3DFF00                   cmp ax, 255
  1764 0000244F 0F8E0900                 jle @@setsflag60
  1765 00002453 68[6724]                 push setsflag_0
  1766 00002456 E81B10                   call error1
  1767 00002459 83C402                   add  sp, 2
  1768                                  
  1769                                  ;-126         sflag=0;//byte reg does not need sign extended   
  1770                                  
  1771                                  @@setsflag60:
  1772 0000245C 66B800000000             mov eax, 0
  1773 00002462 A2[B901]                 mov byte [sflag], al
  1774                                  
  1775                                  ;-127     }
  1776                                  
  1777                                  
  1778                                  ;-128 }
  1779                                  
  1780                                  @@setsflag59:
  1781                                  
  1782                                  ;-129 int checkConstSize(unsigned int ui) {    
  1783 00002465 C9                       LEAVE
  1784 00002466 C3                       ret
  1785                                  ; ENDP
  1786 00002467 746F6F206269672066-     setsflag_0 db "too big for byte r/m",0
  1787 00002470 6F7220627974652072-
  1788 00002479 2F6D00             
  1789                                  
  1790                                  checkConstSize:  ; *** PROC ***
  1791                                  
  1792                                  ;-130     if (ui > 127   ) return 0;//is near; return sflag
  1793                                  
  1794                                  ;Function : checkConstSize, Number of local variables: 1
  1795                                  ;   # type sign width line used address name   list of local variables
  1796                                  ;  200 var unsg word   129 NULL bp+4    ui;
  1797 0000247C C8000000                 ENTER  0,0
  1798 00002480 8B4604                   mov ax, [bp+4]
  1799 00002483 83F87F                   cmp ax, 127
  1800 00002486 0F8E0900                 jle @@checkConstSize61
  1801 0000248A 66B800000000             mov eax, 0
  1802 00002490 E91C00                   jmp @@retn
  1803                                  
  1804                                  ;-131     if (ui < 0xFF80) return 0;//-128dez    
  1805                                  
  1806                                  @@checkConstSize61:
  1807 00002493 8B4604                   mov ax, [bp+4]
  1808 00002496 3D80FF                   cmp ax, 65408
  1809 00002499 0F8D0900                 jge @@checkConstSize62
  1810 0000249D 66B800000000             mov eax, 0
  1811 000024A3 E90900                   jmp @@retn
  1812                                  
  1813                                  ;-132     return 2;// is short        
  1814                                  
  1815                                  @@checkConstSize62:
  1816 000024A6 66B802000000             mov eax, 2
  1817 000024AC E90000                   jmp @@retn
  1818                                  
  1819                                  ;-133 }
  1820                                  
  1821 000024AF C9                      @@retn: LEAVE
  1822 000024B0 C3                       ret
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
  1837 000024B1 B8[CA01]                 mov ax, LabelNames
  1838 000024B4 A3[B205]                 mov word [LabelNamePtr], ax
  1839                                  
  1840                                  ;-3     JmpCallNamePtr= &JmpCallNames;
  1841                                  
  1842 000024B7 B8[8006]                 mov ax, JmpCallNames
  1843 000024BA A3[500E]                 mov word [JmpCallNamePtr], ax
  1844                                  
  1845                                  ;-4     LabelMaxIx=0;    
  1846                                  
  1847 000024BD 66B800000000             mov eax, 0
  1848 000024C3 A3[7C06]                 mov word [LabelMaxIx], ax
  1849                                  
  1850                                  ;-5     JmpCallMaxIx=0;  
  1851                                  
  1852 000024C6 66B800000000             mov eax, 0
  1853 000024CC A3[2E14]                 mov word [JmpCallMaxIx], ax
  1854                                  
  1855                                  ;-6     BinLen=0;
  1856                                  
  1857 000024CF 66B800000000             mov eax, 0
  1858 000024D5 A3[001C]                 mov word [BinLen], ax
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
  1869 000024D8 A1[A601]                 mov ax, [PC]
  1870 000024DB A3[A801]                 mov word [PCStart], ax
  1871                                  
  1872                                  ;-10         OpSize=0;
  1873                                  
  1874 000024DE 66B800000000             mov eax, 0
  1875 000024E4 A2[B601]                 mov byte [OpSize], al
  1876                                  
  1877                                  ;-11         OpPrintIndex=0; 
  1878                                  
  1879 000024E7 66B800000000             mov eax, 0
  1880 000024ED A3[C501]                 mov word [OpPrintIndex], ax
  1881                                  
  1882                                  ;-12         PrintRA=' ';
  1883                                  
  1884 000024F0 66B820000000             mov eax, 32
  1885 000024F6 A2[C901]                 mov byte [PrintRA], al
  1886                                  
  1887                                  ;-13         getLine();
  1888                                  
  1889 000024F9 E8B705                   call getLine
  1890                                  
  1891                                  ;-14         InputPtr = &InputBuf;
  1892                                  
  1893 000024FC B8[4F00]                 mov ax, InputBuf
  1894 000024FF A3[CE00]                 mov word [InputPtr], ax
  1895                                  
  1896                                  ;-15         getTokeType();//getCode in SymbolUpper,set TokeType,isLabel by getName
  1897                                  
  1898 00002502 E8B800                   call getTokeType
  1899                                  
  1900                                  ;-16         if (TokeType == ALNUME) {
  1901                                  
  1902 00002505 A0[AB01]                 mov al, [TokeType]
  1903 00002508 3C03                     cmp al, 3
  1904 0000250A 0F851300                 jne @@parse64
  1905                                  
  1906                                  ;-17             if (isLabel) {//set in getName
  1907                                  
  1908 0000250E A0[AA01]                 mov al, [isLabel]
  1909 00002511 08C0                     or  al, al
  1910 00002513 0F840A00                 je @@parse65
  1911                                  
  1912                                  ;-18                 storeLabel();
  1913                                  
  1914 00002517 E8D101                   call storeLabel
  1915                                  
  1916                                  ;-19                 InputPtr++;//remove :
  1917                                  
  1918 0000251A FF06[CE00]               inc  word [InputPtr]
  1919                                  
  1920                                  ;-20                 getTokeType();
  1921                                  
  1922 0000251E E89C00                   call getTokeType
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
  1934 00002521 A0[AB01]                 mov al, [TokeType]
  1935 00002524 3C03                     cmp al, 3
  1936 00002526 0F851B00                 jne @@parse66
  1937                                  
  1938                                  ;-24             lookCode();// and OpCodePtr
  1939                                  
  1940 0000252A E8F303                   call lookCode
  1941                                  
  1942                                  ;-25             if(CodeType) process();
  1943                                  
  1944 0000252D A0[AE01]                 mov al, [CodeType]
  1945 00002530 08C0                     or  al, al
  1946 00002532 0F840600                 je @@parse67
  1947 00002536 E87317                   call process
  1948                                  
  1949                                  ;-26             else getVariable();
  1950                                  
  1951 00002539 E90300                   jmp @@parse68
  1952                                  @@parse67:
  1953 0000253C E8A902                   call getVariable
  1954                                  
  1955                                  ;-27             skipRest();
  1956                                  
  1957                                  @@parse68:
  1958 0000253F E84805                   call skipRest
  1959                                  
  1960                                  ;-28         }
  1961                                  
  1962                                  
  1963                                  ;-29         else if (TokeType >ALNUME) error1("Label or instruction expected");
  1964                                  
  1965 00002542 E92700                   jmp @@parse69
  1966                                  @@parse66:
  1967 00002545 A0[AB01]                 mov al, [TokeType]
  1968 00002548 3C03                     cmp al, 3
  1969 0000254A 0F8E0C00                 jle @@parse70
  1970 0000254E 68[7D25]                 push parse_0
  1971 00002551 E8200F                   call error1
  1972 00002554 83C402                   add  sp, 2
  1973                                  
  1974                                  ;-30         else if (TokeType==DIGIT ) error1("No digit allowed at start of line");
  1975                                  
  1976 00002557 E91200                   jmp @@parse71
  1977                                  @@parse70:
  1978 0000255A A0[AB01]                 mov al, [TokeType]
  1979 0000255D 3C01                     cmp al, 1
  1980 0000255F 0F850900                 jne @@parse72
  1981 00002563 68[9B25]                 push parse_1
  1982 00002566 E80B0F                   call error1
  1983 00002569 83C402                   add  sp, 2
  1984                                  
  1985                                  ;-31         printLine();
  1986                                  
  1987                                  @@parse72:
  1988                                  @@parse71:
  1989                                  @@parse69:
  1990 0000256C E8970C                   call printLine
  1991                                  
  1992                                  ;-32     } while (DOS_NoBytes != 0 );
  1993                                  
  1994 0000256F A1[A301]                 mov ax, [DOS_NoBytes]
  1995 00002572 83F800                   cmp ax, 0
  1996 00002575 0F840300                 je  @@parse73
  1997 00002579 E95CFF                   jmp @@parse63
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
  2008 0000257C C3                       ret
  2009                                  ; ENDP
  2010 0000257D 4C6162656C206F7220-     parse_0 db "Label or instruction expected",0
  2011 00002586 696E73747275637469-
  2012 0000258F 6F6E20657870656374-
  2013 00002598 656400             
  2014 0000259B 4E6F20646967697420-     parse_1 db "No digit allowed at start of line",0
  2015 000025A4 616C6C6F7765642061-
  2016 000025AD 74207374617274206F-
  2017 000025B6 66206C696E6500     
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
  2029 000025BD C8020000                 ENTER  2,0
  2030 000025C1 E8F105                   call skipBlank
  2031                                  
  2032                                  ;-38     c = *InputPtr;
  2033                                  
  2034 000025C4 8B1E[CE00]               mov bx, [InputPtr]
  2035 000025C8 8A07                     mov al, [bx]
  2036 000025CA B400                     mov ah, 0
  2037 000025CC 8846FE                   mov byte [bp-2], al
  2038                                  
  2039                                  ;-39     if (c == 0)   {TokeType=0; return; }//last line or empty line
  2040                                  
  2041 000025CF 8A46FE                   mov al, [bp-2]
  2042 000025D2 3C00                     cmp al, 0
  2043 000025D4 0F850C00                 jne @@getTokeType74
  2044 000025D8 66B800000000             mov eax, 0
  2045 000025DE A2[AB01]                 mov byte [TokeType], al
  2046 000025E1 E97200                   jmp @@retn
  2047                                  
  2048                                  ;-40     if (c == ';') {TokeType=0; return; }//comment
  2049                                  
  2050                                  @@getTokeType74:
  2051 000025E4 8A46FE                   mov al, [bp-2]
  2052 000025E7 3C3B                     cmp al, 59
  2053 000025E9 0F850C00                 jne @@getTokeType75
  2054 000025ED 66B800000000             mov eax, 0
  2055 000025F3 A2[AB01]                 mov byte [TokeType], al
  2056 000025F6 E95D00                   jmp @@retn
  2057                                  
  2058                                  ;-41     if (digit(c)) {getDigit(c); TokeType=DIGIT; return;}//ret:1=SymbolInt
  2059                                  
  2060                                  @@getTokeType75:
  2061 000025F9 8A46FE                   mov al, byte [bp-2]
  2062 000025FC B400                     mov ah, 0
  2063 000025FE 50                       push ax
  2064 000025FF E82E1E                   call digit
  2065 00002602 83C402                   add  sp, 2
  2066 00002605 08C0                     or  al, al
  2067 00002607 0F841800                 je @@getTokeType76
  2068 0000260B 8A46FE                   mov al, byte [bp-2]
  2069 0000260E B400                     mov ah, 0
  2070 00002610 50                       push ax
  2071 00002611 E8A706                   call getDigit
  2072 00002614 83C402                   add  sp, 2
  2073 00002617 66B801000000             mov eax, 1
  2074 0000261D A2[AB01]                 mov byte [TokeType], al
  2075 00002620 E93300                   jmp @@retn
  2076                                  
  2077                                  ;-42     if (letterE (c)) {getName(c); TokeType=ALNUME; return;}//ret:2=Symbol
  2078                                  
  2079                                  @@getTokeType76:
  2080 00002623 8A46FE                   mov al, byte [bp-2]
  2081 00002626 B400                     mov ah, 0
  2082 00002628 50                       push ax
  2083 00002629 E8B405                   call letterE
  2084 0000262C 83C402                   add  sp, 2
  2085 0000262F 08C0                     or  al, al
  2086 00002631 0F841800                 je @@getTokeType77
  2087 00002635 8A46FE                   mov al, byte [bp-2]
  2088 00002638 B400                     mov ah, 0
  2089 0000263A 50                       push ax
  2090 0000263B E8D406                   call getName
  2091 0000263E 83C402                   add  sp, 2
  2092 00002641 66B803000000             mov eax, 3
  2093 00002647 A2[AB01]                 mov byte [TokeType], al
  2094 0000264A E90900                   jmp @@retn
  2095                                  
  2096                                  ;-43     TokeType=NOALNUME;
  2097                                  
  2098                                  @@getTokeType77:
  2099 0000264D 66B804000000             mov eax, 4
  2100 00002653 A2[AB01]                 mov byte [TokeType], al
  2101                                  
  2102                                  ;-44 }                     
  2103                                  
  2104                                  
  2105                                  ;-45 
  2106                                  
  2107                                  
  2108                                  ;-46 int storeJmpCall() {
  2109                                  
  2110 00002656 C9                      @@retn: LEAVE
  2111 00002657 C3                       ret
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
  2124 00002658 C8020000                 ENTER  2,0
  2125 0000265C FF06[2E14]               inc  word [JmpCallMaxIx]
  2126                                  
  2127                                  ;-49     if (JmpCallMaxIx >= JMPCALLMAX) errorexit("too many JmpCalls");
  2128                                  
  2129 00002660 A1[2E14]                 mov ax, [JmpCallMaxIx]
  2130 00002663 3DF401                   cmp ax, 500 ;unsigned : 1
  2131 00002666 0F8C0900                 jl  @@storeJmpCall78
  2132 0000266A 68[C226]                 push storeJmpCall_0
  2133 0000266D E8630E                   call errorexit
  2134 00002670 83C402                   add  sp, 2
  2135                                  
  2136                                  ;-50     JmpCallNamePtr=strcpy(JmpCallNamePtr, Symbol);
  2137                                  
  2138                                  @@storeJmpCall78:
  2139 00002673 8D06[0F00]               lea  ax, [Symbol]
  2140 00002677 50                       push ax
  2141 00002678 FF36[500E]               push word [JmpCallNamePtr]
  2142 0000267C E8781D                   call strcpy
  2143 0000267F 83C404                   add  sp, 4
  2144 00002682 A3[500E]                 mov word [JmpCallNamePtr], ax
  2145                                  
  2146                                  ;-51     JmpCallNamePtr++;
  2147                                  
  2148 00002685 FF06[500E]               inc  word [JmpCallNamePtr]
  2149                                  
  2150                                  ;-52     i = JmpCallNamePtr - &JmpCallNames;    
  2151                                  
  2152 00002689 A1[500E]                 mov ax, [JmpCallNamePtr]
  2153 0000268C 2D[8006]                 sub ax, JmpCallNames
  2154 0000268F 8946FE                   mov word [bp-2], ax
  2155                                  
  2156                                  ;-53     if ( i >= JMPCALLNAMESMAX) errorexit("too many JmpCall names");
  2157                                  
  2158 00002692 8B46FE                   mov ax, [bp-2]
  2159 00002695 3DB107                   cmp ax, 1969 ;unsigned : 0
  2160 00002698 0F820900                 jb  @@storeJmpCall79
  2161 0000269C 68[D426]                 push storeJmpCall_1
  2162 0000269F E8310E                   call errorexit
  2163 000026A2 83C402                   add  sp, 2
  2164                                  
  2165                                  ;-54     JmpCallAddr[JmpCallMaxIx] = PC;   
  2166                                  
  2167                                  @@storeJmpCall79:
  2168 000026A5 A1[A601]                 mov ax, [PC]
  2169 000026A8 8B1E[2E14]               mov bx, [JmpCallMaxIx]
  2170 000026AC D1E3                     shl bx, 1
  2171 000026AE 8987[520E]               mov [JmpCallAddr+bx], ax
  2172                                  
  2173                                  ;-55     JmpCallRelAbs[JmpCallMaxIx] = '*';
  2174                                  
  2175 000026B2 66B82A000000             mov eax, 42
  2176 000026B8 8B1E[2E14]               mov bx, [JmpCallMaxIx]
  2177 000026BC 8887[3A12]               mov [JmpCallRelAbs+bx], al
  2178                                  
  2179                                  ;-56     //set correct value r,R,A in CodeType 6+7             
  2180                                  
  2181                                  
  2182                                  ;-57 }
  2183                                  
  2184                                  
  2185                                  ;-58 
  2186                                  
  2187                                  
  2188                                  ;-59 int storeLabel() {
  2189 000026C0 C9                       LEAVE
  2190 000026C1 C3                       ret
  2191                                  ; ENDP
  2192 000026C2 746F6F206D616E7920-     storeJmpCall_0 db "too many JmpCalls",0
  2193 000026CB 4A6D7043616C6C7300 
  2194 000026D4 746F6F206D616E7920-     storeJmpCall_1 db "too many JmpCall names",0
  2195 000026DD 4A6D7043616C6C206E-
  2196 000026E6 616D657300         
  2197                                  
  2198                                  storeLabel:  ; *** PROC ***
  2199                                  
  2200                                  ;-60     unsigned int i;
  2201                                  
  2202                                  
  2203                                  ;-61     LabelMaxIx++;
  2204                                  
  2205                                  ;Function : storeLabel, Number of local variables: 1
  2206                                  ;   # type sign width line used address name   list of local variables
  2207                                  ;  200 var unsg word    60 NULL bp-2    i;
  2208 000026EB C8020000                 ENTER  2,0
  2209 000026EF FF06[7C06]               inc  word [LabelMaxIx]
  2210                                  
  2211                                  ;-62     if (LabelMaxIx >= LABELADRMAX) errorexit("too many labels");
  2212                                  
  2213 000026F3 A1[7C06]                 mov ax, [LabelMaxIx]
  2214 000026F6 83F864                   cmp ax, 100 ;unsigned : 1
  2215 000026F9 0F8C0900                 jl  @@storeLabel80
  2216 000026FD 68[5927]                 push storeLabel_0
  2217 00002700 E8D00D                   call errorexit
  2218 00002703 83C402                   add  sp, 2
  2219                                  
  2220                                  ;-63     if(searchLabel()) error1("duplicate label");
  2221                                  
  2222                                  @@storeLabel80:
  2223 00002706 E88500                   call searchLabel
  2224 00002709 08C0                     or  al, al
  2225 0000270B 0F840900                 je @@storeLabel81
  2226 0000270F 68[6927]                 push storeLabel_1
  2227 00002712 E85F0D                   call error1
  2228 00002715 83C402                   add  sp, 2
  2229                                  
  2230                                  ;-64     LabelNamePtr=strcpy(LabelNamePtr, Symbol);
  2231                                  
  2232                                  @@storeLabel81:
  2233 00002718 8D06[0F00]               lea  ax, [Symbol]
  2234 0000271C 50                       push ax
  2235 0000271D FF36[B205]               push word [LabelNamePtr]
  2236 00002721 E8D31C                   call strcpy
  2237 00002724 83C404                   add  sp, 4
  2238 00002727 A3[B205]                 mov word [LabelNamePtr], ax
  2239                                  
  2240                                  ;-65     LabelNamePtr++;
  2241                                  
  2242 0000272A FF06[B205]               inc  word [LabelNamePtr]
  2243                                  
  2244                                  ;-66     i = LabelNamePtr - &LabelNames;
  2245                                  
  2246 0000272E A1[B205]                 mov ax, [LabelNamePtr]
  2247 00002731 2D[CA01]                 sub ax, LabelNames
  2248 00002734 8946FE                   mov word [bp-2], ax
  2249                                  
  2250                                  ;-67     if (i >= LABELNAMESMAX) errorexit("too many label names");
  2251                                  
  2252 00002737 8B46FE                   mov ax, [bp-2]
  2253 0000273A 3DC903                   cmp ax, 969 ;unsigned : 0
  2254 0000273D 0F820900                 jb  @@storeLabel82
  2255 00002741 68[7927]                 push storeLabel_2
  2256 00002744 E88C0D                   call errorexit
  2257 00002747 83C402                   add  sp, 2
  2258                                  
  2259                                  ;-68     LabelAddr[LabelMaxIx] = PC;
  2260                                  
  2261                                  @@storeLabel82:
  2262 0000274A A1[A601]                 mov ax, [PC]
  2263 0000274D 8B1E[7C06]               mov bx, [LabelMaxIx]
  2264 00002751 D1E3                     shl bx, 1
  2265 00002753 8987[B405]               mov [LabelAddr+bx], ax
  2266                                  
  2267                                  ;-69 }   
  2268                                  
  2269                                  
  2270                                  ;-70 
  2271                                  
  2272                                  
  2273                                  ;-71 int searchLabel() {
  2274 00002757 C9                       LEAVE
  2275 00002758 C3                       ret
  2276                                  ; ENDP
  2277 00002759 746F6F206D616E7920-     storeLabel_0 db "too many labels",0
  2278 00002762 6C6162656C7300     
  2279 00002769 6475706C6963617465-     storeLabel_1 db "duplicate label",0
  2280 00002772 206C6162656C00     
  2281 00002779 746F6F206D616E7920-     storeLabel_2 db "too many label names",0
  2282 00002782 6C6162656C206E616D-
  2283 0000278B 657300             
  2284                                  
  2285                                  searchLabel:  ; *** PROC ***
  2286                                  
  2287                                  ;-72     int LIx; char *p;
  2288                                  
  2289                                  
  2290                                  ;-73     p = &LabelNames;
  2291                                  
  2292                                  ;Function : searchLabel, Number of local variables: 2
  2293                                  ;   # type sign width line used address name   list of local variables
  2294                                  ;  200 var sign word    72 NULL bp-2    LIx
  2295                                  ;  201 ptr sign byte    72 NULL bp-4    p;
  2296 0000278E C8040000                 ENTER  4,0
  2297 00002792 B8[CA01]                 mov ax, LabelNames
  2298 00002795 8946FC                   mov word [bp-4], ax
  2299                                  
  2300                                  ;-74     LIx = 1;
  2301                                  
  2302 00002798 66B801000000             mov eax, 1
  2303 0000279E 8946FE                   mov word [bp-2], ax
  2304                                  
  2305                                  ;-75     while (LIx <= LabelMaxIx) {
  2306                                  
  2307                                  @@searchLabel83:
  2308 000027A1 8B46FE                   mov ax, [bp-2]
  2309 000027A4 3B06[7C06]               cmp ax, [LabelMaxIx]
  2310 000027A8 0F8F3100                 jg  @@searchLabel84
  2311                                  
  2312                                  ;-76         if (eqstr(p, Symbol)) return LIx;//pos of label                    
  2313                                  
  2314 000027AC 8D06[0F00]               lea  ax, [Symbol]
  2315 000027B0 50                       push ax
  2316 000027B1 FF76FC                   push word [bp-4]
  2317 000027B4 E8AC1C                   call eqstr
  2318 000027B7 83C404                   add  sp, 4
  2319 000027BA 08C0                     or  al, al
  2320 000027BC 0F840600                 je @@searchLabel85
  2321 000027C0 8B46FE                   mov ax, [bp-2]
  2322 000027C3 E92000                   jmp @@retn
  2323                                  
  2324                                  ;-77         p=strlen(p) + p;                  
  2325                                  
  2326                                  @@searchLabel85:
  2327 000027C6 FF76FC                   push word [bp-4]
  2328 000027C9 E8001C                   call strlen
  2329 000027CC 83C402                   add  sp, 2
  2330 000027CF 0346FC                   add ax, [bp-4]
  2331 000027D2 8946FC                   mov word [bp-4], ax
  2332                                  
  2333                                  ;-78         p++; 
  2334                                  
  2335 000027D5 FF46FC                   inc  word [bp-4]
  2336                                  
  2337                                  ;-79         LIx++;
  2338                                  
  2339 000027D8 FF46FE                   inc  word [bp-2]
  2340                                  
  2341                                  ;-80     }
  2342                                  
  2343                                  
  2344                                  ;-81     return 0;
  2345                                  
  2346 000027DB EBC4                     jmp @@searchLabel83
  2347                                  @@searchLabel84:
  2348 000027DD 66B800000000             mov eax, 0
  2349 000027E3 E90000                   jmp @@retn
  2350                                  
  2351                                  ;-82 }   
  2352                                  
  2353                                  
  2354                                  ;-83 
  2355                                  
  2356                                  
  2357                                  ;-84 int getVariable() { 
  2358                                  
  2359 000027E6 C9                      @@retn: LEAVE
  2360 000027E7 C3                       ret
  2361                                  ; ENDP
  2362                                  
  2363                                  getVariable:  ; *** PROC ***
  2364                                  
  2365                                  ;-85     char c;
  2366                                  
  2367                                  
  2368                                  ;-86     storeLabel();
  2369                                  
  2370                                  ;Function : getVariable, Number of local variables: 1
  2371                                  ;   # type sign width line used address name   list of local variables
  2372                                  ;  200 var sign byte    85 NULL bp-2    c;
  2373 000027E8 C8020000                 ENTER  2,0
  2374 000027EC E8FCFE                   call storeLabel
  2375                                  
  2376                                  ;-87     getTokeType(); 
  2377                                  
  2378 000027EF E8CBFD                   call getTokeType
  2379                                  
  2380                                  ;-88     if(TokeType==ALNUME) {// getName
  2381                                  
  2382 000027F2 A0[AB01]                 mov al, [TokeType]
  2383 000027F5 3C03                     cmp al, 3
  2384 000027F7 0F85CC00                 jne @@getVariable86
  2385                                  
  2386                                  ;-89         lookCode();
  2387                                  
  2388 000027FB E82201                   call lookCode
  2389                                  
  2390                                  ;-90         if (CodeType < 200) errorexit("D or RES B,W,D expected");
  2391                                  
  2392 000027FE A0[AE01]                 mov al, [CodeType]
  2393 00002801 3CC8                     cmp al, 200
  2394 00002803 0F8D0900                 jge @@getVariable87
  2395 00002807 68[D228]                 push getVariable_0
  2396 0000280A E8C60C                   call errorexit
  2397 0000280D 83C402                   add  sp, 2
  2398                                  
  2399                                  ;-91         if (CodeType > 207) errorexit("D or RES B,W,D expected");
  2400                                  
  2401                                  @@getVariable87:
  2402 00002810 A0[AE01]                 mov al, [CodeType]
  2403 00002813 3CCF                     cmp al, 207
  2404 00002815 0F8E0900                 jle @@getVariable88
  2405 00002819 68[EA28]                 push getVariable_1
  2406 0000281C E8B40C                   call errorexit
  2407 0000281F 83C402                   add  sp, 2
  2408                                  
  2409                                  ;-92         if (CodeType== 200) {// DB
  2410                                  
  2411                                  @@getVariable88:
  2412 00002822 A0[AE01]                 mov al, [CodeType]
  2413 00002825 3CC8                     cmp al, 200
  2414 00002827 0F856A00                 jne @@getVariable89
  2415                                  
  2416                                  ;-93             do { 
  2417                                  
  2418                                  @@getVariable90:
  2419                                  
  2420                                  ;-94                 getTokeType();
  2421                                  
  2422 0000282B E88FFD                   call getTokeType
  2423                                  
  2424                                  ;-95                 if (TokeType ==DIGIT) genCode8(SymbolInt);
  2425                                  
  2426 0000282E A0[AB01]                 mov al, [TokeType]
  2427 00002831 3C01                     cmp al, 1
  2428 00002833 0F850D00                 jne @@getVariable91
  2429 00002837 FF36[4D00]               push word [SymbolInt]
  2430 0000283B E8C012                   call genCode8
  2431 0000283E 83C402                   add  sp, 2
  2432                                  
  2433                                  ;-96                 else {
  2434                                  
  2435 00002841 E94100                   jmp @@getVariable92
  2436                                  @@getVariable91:
  2437                                  
  2438                                  ;-97                     skipBlank();
  2439                                  
  2440 00002844 E86E03                   call skipBlank
  2441                                  
  2442                                  ;-98                     if (isToken('"')) {
  2443                                  
  2444 00002847 6A22                     push 34
  2445 00002849 E8D101                   call isToken
  2446 0000284C 83C402                   add  sp, 2
  2447 0000284F 08C0                     or  al, al
  2448 00002851 0F843000                 je @@getVariable93
  2449                                  
  2450                                  ;-99                         do { 
  2451                                  
  2452                                  @@getVariable94:
  2453                                  
  2454                                  ;-100                             c= *InputPtr;
  2455                                  
  2456 00002855 8B1E[CE00]               mov bx, [InputPtr]
  2457 00002859 8A07                     mov al, [bx]
  2458 0000285B B400                     mov ah, 0
  2459 0000285D 8846FE                   mov byte [bp-2], al
  2460                                  
  2461                                  ;-101                             genCode8(c);
  2462                                  
  2463 00002860 8A46FE                   mov al, byte [bp-2]
  2464 00002863 B400                     mov ah, 0
  2465 00002865 50                       push ax
  2466 00002866 E89512                   call genCode8
  2467 00002869 83C402                   add  sp, 2
  2468                                  
  2469                                  ;-102                             InputPtr++;
  2470                                  
  2471 0000286C FF06[CE00]               inc  word [InputPtr]
  2472                                  
  2473                                  ;-103                         } while (*InputPtr != '"' );
  2474                                  
  2475 00002870 8B1E[CE00]               mov bx, [InputPtr]
  2476 00002874 8A07                     mov al, [bx]
  2477 00002876 B400                     mov ah, 0
  2478 00002878 83F822                   cmp ax, 34
  2479 0000287B 0F840200                 je  @@getVariable95
  2480 0000287F EBD4                     jmp @@getVariable94
  2481                                  @@getVariable95:
  2482                                  
  2483                                  ;-104                         InputPtr++;
  2484                                  
  2485 00002881 FF06[CE00]               inc  word [InputPtr]
  2486                                  
  2487                                  ;-105                     }
  2488                                  
  2489                                  
  2490                                  ;-106                 }
  2491                                  
  2492                                  @@getVariable93:
  2493                                  
  2494                                  ;-107             } while (isToken(','));
  2495                                  
  2496                                  @@getVariable92:
  2497 00002885 6A2C                     push 44
  2498 00002887 E89301                   call isToken
  2499 0000288A 83C402                   add  sp, 2
  2500 0000288D 08C0                     or  al, al
  2501 0000288F 0F840200                 je @@getVariable96
  2502 00002893 EB96                     jmp @@getVariable90
  2503                                  @@getVariable96:
  2504                                  
  2505                                  ;-108         }
  2506                                  
  2507                                  
  2508                                  ;-109         if (CodeType== 201) {// DW
  2509                                  
  2510                                  @@getVariable89:
  2511 00002895 A0[AE01]                 mov al, [CodeType]
  2512 00002898 3CC9                     cmp al, 201
  2513 0000289A 0F852600                 jne @@getVariable97
  2514                                  
  2515                                  ;-110             do { 
  2516                                  
  2517                                  @@getVariable98:
  2518                                  
  2519                                  ;-111                 getTokeType();
  2520                                  
  2521 0000289E E81CFD                   call getTokeType
  2522                                  
  2523                                  ;-112                 if (TokeType ==DIGIT) genCode16(SymbolInt);
  2524                                  
  2525 000028A1 A0[AB01]                 mov al, [TokeType]
  2526 000028A4 3C01                     cmp al, 1
  2527 000028A6 0F850A00                 jne @@getVariable99
  2528 000028AA FF36[4D00]               push word [SymbolInt]
  2529 000028AE E8A412                   call genCode16
  2530 000028B1 83C402                   add  sp, 2
  2531                                  
  2532                                  ;-113             } while (isToken(','));
  2533                                  
  2534                                  @@getVariable99:
  2535 000028B4 6A2C                     push 44
  2536 000028B6 E86401                   call isToken
  2537 000028B9 83C402                   add  sp, 2
  2538 000028BC 08C0                     or  al, al
  2539 000028BE 0F840200                 je @@getVariable100
  2540 000028C2 EBDA                     jmp @@getVariable98
  2541                                  @@getVariable100:
  2542                                  
  2543                                  ;-114         }
  2544                                  
  2545                                  
  2546                                  ;-115     }
  2547                                  
  2548                                  @@getVariable97:
  2549                                  
  2550                                  ;-116     else errorexit("DB,DW,DD or RESB,W,D expected");
  2551                                  
  2552 000028C4 E90900                   jmp @@getVariable101
  2553                                  @@getVariable86:
  2554 000028C7 68[0229]                 push getVariable_2
  2555 000028CA E8060C                   call errorexit
  2556 000028CD 83C402                   add  sp, 2
  2557                                  
  2558                                  ;-117 }
  2559                                  
  2560                                  @@getVariable101:
  2561                                  
  2562                                  ;-118 
  2563                                  
  2564                                  
  2565                                  ;-119 int lookCode() {// ret: CodeType, *OpCodePtr
  2566 000028D0 C9                       LEAVE
  2567 000028D1 C3                       ret
  2568                                  ; ENDP
  2569 000028D2 44206F722052455320-     getVariable_0 db "D or RES B,W,D expected",0
  2570 000028DB 422C572C4420657870-
  2571 000028E4 656374656400       
  2572 000028EA 44206F722052455320-     getVariable_1 db "D or RES B,W,D expected",0
  2573 000028F3 422C572C4420657870-
  2574 000028FC 656374656400       
  2575 00002902 44422C44572C444420-     getVariable_2 db "DB,DW,DD or RESB,W,D expected",0
  2576 0000290B 6F7220524553422C57-
  2577 00002914 2C4420657870656374-
  2578 0000291D 656400             
  2579                                  
  2580                                  lookCode:  ; *** PROC ***
  2581                                  
  2582                                  ;-120     CodeType=0;
  2583                                  
  2584 00002920 66B800000000             mov eax, 0
  2585 00002926 A2[AE01]                 mov byte [CodeType], al
  2586                                  
  2587                                  ;-121     OpCodePtr= &I_START;
  2588                                  
  2589 00002929 B8[061C]                 mov ax, I_START
  2590 0000292C A3[C701]                 mov word [OpCodePtr], ax
  2591                                  
  2592                                  ;-122     OpCodePtr++;
  2593                                  
  2594 0000292F FF06[C701]               inc  word [OpCodePtr]
  2595                                  
  2596                                  ;-123     do  {
  2597                                  
  2598                                  @@lookCode102:
  2599                                  
  2600                                  ;-124         if (eqstr(SymbolUpper, OpCodePtr))  {
  2601                                  
  2602 00002933 FF36[C701]               push word [OpCodePtr]
  2603 00002937 8D06[2E00]               lea  ax, [SymbolUpper]
  2604 0000293B 50                       push ax
  2605 0000293C E8241B                   call eqstr
  2606 0000293F 83C404                   add  sp, 4
  2607 00002942 08C0                     or  al, al
  2608 00002944 0F842700                 je @@lookCode103
  2609                                  
  2610                                  ;-125             while(*OpCodePtr!=0) OpCodePtr++;
  2611                                  
  2612                                  @@lookCode104:
  2613 00002948 8B1E[C701]               mov bx, [OpCodePtr]
  2614 0000294C 8A07                     mov al, [bx]
  2615 0000294E B400                     mov ah, 0
  2616 00002950 83F800                   cmp ax, 0
  2617 00002953 0F840600                 je  @@lookCode105
  2618 00002957 FF06[C701]               inc  word [OpCodePtr]
  2619                                  
  2620                                  ;-126             OpCodePtr++; 
  2621                                  
  2622 0000295B EBEB                     jmp @@lookCode104
  2623                                  @@lookCode105:
  2624 0000295D FF06[C701]               inc  word [OpCodePtr]
  2625                                  
  2626                                  ;-127             CodeType =*OpCodePtr;
  2627                                  
  2628 00002961 8B1E[C701]               mov bx, [OpCodePtr]
  2629 00002965 8A07                     mov al, [bx]
  2630 00002967 B400                     mov ah, 0
  2631 00002969 A2[AE01]                 mov byte [CodeType], al
  2632                                  
  2633                                  ;-128             return;
  2634                                  
  2635 0000296C E92A00                   jmp @@retn
  2636                                  
  2637                                  ;-129         }
  2638                                  
  2639                                  
  2640                                  ;-130     while(*OpCodePtr!=0xF1) OpCodePtr++;
  2641                                  
  2642                                  @@lookCode103:
  2643                                  @@lookCode106:
  2644 0000296F 8B1E[C701]               mov bx, [OpCodePtr]
  2645 00002973 8A07                     mov al, [bx]
  2646 00002975 B400                     mov ah, 0
  2647 00002977 3DF100                   cmp ax, 241
  2648 0000297A 0F840600                 je  @@lookCode107
  2649 0000297E FF06[C701]               inc  word [OpCodePtr]
  2650                                  
  2651                                  ;-131     OpCodePtr++;
  2652                                  
  2653 00002982 EBEB                     jmp @@lookCode106
  2654                                  @@lookCode107:
  2655 00002984 FF06[C701]               inc  word [OpCodePtr]
  2656                                  
  2657                                  ;-132     } while(*OpCodePtr!=0);
  2658                                  
  2659 00002988 8B1E[C701]               mov bx, [OpCodePtr]
  2660 0000298C 8A07                     mov al, [bx]
  2661 0000298E B400                     mov ah, 0
  2662 00002990 83F800                   cmp ax, 0
  2663 00002993 0F840200                 je  @@lookCode108
  2664 00002997 EB9A                     jmp @@lookCode102
  2665                                  @@lookCode108:
  2666                                  
  2667                                  ;-133 }
  2668                                  
  2669                                  
  2670                                  ;-134 
  2671                                  
  2672                                  
  2673                                  ;-135 int getCodeSize() {
  2674                                  
  2675                                  @@retn:
  2676 00002999 C3                       ret
  2677                                  ; ENDP
  2678                                  
  2679                                  getCodeSize:  ; *** PROC ***
  2680                                  
  2681                                  ;-136     if (TokeType ==ALNUME) {
  2682                                  
  2683 0000299A A0[AB01]                 mov al, [TokeType]
  2684 0000299D 3C03                     cmp al, 3
  2685 0000299F 0F856000                 jne @@getCodeSize109
  2686                                  
  2687                                  ;-137         if (eqstr(SymbolUpper,"BYTE")) {getTokeType(); return BYTE;}
  2688                                  
  2689 000029A3 68[0D2A]                 push getCodeSize_0
  2690 000029A6 8D06[2E00]               lea  ax, [SymbolUpper]
  2691 000029AA 50                       push ax
  2692 000029AB E8B51A                   call eqstr
  2693 000029AE 83C404                   add  sp, 4
  2694 000029B1 08C0                     or  al, al
  2695 000029B3 0F840C00                 je @@getCodeSize110
  2696 000029B7 E803FC                   call getTokeType
  2697 000029BA 66B801000000             mov eax, 1
  2698 000029C0 E94900                   jmp @@retn
  2699                                  
  2700                                  ;-138         if (eqstr(SymbolUpper,"WORD")) {getTokeType(); return WORD;}
  2701                                  
  2702                                  @@getCodeSize110:
  2703 000029C3 68[122A]                 push getCodeSize_1
  2704 000029C6 8D06[2E00]               lea  ax, [SymbolUpper]
  2705 000029CA 50                       push ax
  2706 000029CB E8951A                   call eqstr
  2707 000029CE 83C404                   add  sp, 4
  2708 000029D1 08C0                     or  al, al
  2709 000029D3 0F840C00                 je @@getCodeSize111
  2710 000029D7 E8E3FB                   call getTokeType
  2711 000029DA 66B802000000             mov eax, 2
  2712 000029E0 E92900                   jmp @@retn
  2713                                  
  2714                                  ;-139         if (eqstr(SymbolUpper,"DWORD")){getTokeType(); return DWORD;}
  2715                                  
  2716                                  @@getCodeSize111:
  2717 000029E3 68[172A]                 push getCodeSize_2
  2718 000029E6 8D06[2E00]               lea  ax, [SymbolUpper]
  2719 000029EA 50                       push ax
  2720 000029EB E8751A                   call eqstr
  2721 000029EE 83C404                   add  sp, 4
  2722 000029F1 08C0                     or  al, al
  2723 000029F3 0F840C00                 je @@getCodeSize112
  2724 000029F7 E8C3FB                   call getTokeType
  2725 000029FA 66B803000000             mov eax, 3
  2726 00002A00 E90900                   jmp @@retn
  2727                                  
  2728                                  ;-140     } 
  2729                                  
  2730                                  @@getCodeSize112:
  2731                                  
  2732                                  ;-141     return 0;
  2733                                  
  2734                                  @@getCodeSize109:
  2735 00002A03 66B800000000             mov eax, 0
  2736 00002A09 E90000                   jmp @@retn
  2737                                  
  2738                                  ;-142 }
  2739                                  
  2740                                  
  2741                                  ;-143 int isToken(char c) {
  2742                                  
  2743                                  @@retn:
  2744 00002A0C C3                       ret
  2745                                  ; ENDP
  2746 00002A0D 4259544500              getCodeSize_0 db "BYTE",0
  2747 00002A12 574F524400              getCodeSize_1 db "WORD",0
  2748 00002A17 44574F524400            getCodeSize_2 db "DWORD",0
  2749                                  
  2750                                  isToken:  ; *** PROC ***
  2751                                  
  2752                                  ;-144     skipBlank();
  2753                                  
  2754                                  ;Function : isToken, Number of local variables: 1
  2755                                  ;   # type sign width line used address name   list of local variables
  2756                                  ;  200 var sign byte   143 NULL bp+4    c;
  2757 00002A1D C8000000                 ENTER  0,0
  2758 00002A21 E89101                   call skipBlank
  2759                                  
  2760                                  ;-145     if (*InputPtr == c) {
  2761                                  
  2762 00002A24 8B1E[CE00]               mov bx, [InputPtr]
  2763 00002A28 8A07                     mov al, [bx]
  2764 00002A2A B400                     mov ah, 0
  2765 00002A2C 3A4604                   cmp al, [bp+4]
  2766 00002A2F 0F850D00                 jne @@isToken113
  2767                                  
  2768                                  ;-146         InputPtr++; 
  2769                                  
  2770 00002A33 FF06[CE00]               inc  word [InputPtr]
  2771                                  
  2772                                  ;-147         return 1;
  2773                                  
  2774 00002A37 66B801000000             mov eax, 1
  2775 00002A3D E90900                   jmp @@retn
  2776                                  
  2777                                  ;-148         } 
  2778                                  
  2779                                  
  2780                                  ;-149     return 0;
  2781                                  
  2782                                  @@isToken113:
  2783 00002A40 66B800000000             mov eax, 0
  2784 00002A46 E90000                   jmp @@retn
  2785                                  
  2786                                  ;-150 }
  2787                                  
  2788                                  
  2789                                  ;-151 int need(char c) {
  2790                                  
  2791 00002A49 C9                      @@retn: LEAVE
  2792 00002A4A C3                       ret
  2793                                  ; ENDP
  2794                                  
  2795                                  need:  ; *** PROC ***
  2796                                  
  2797                                  ;-152     if (isToken(c)) {
  2798                                  
  2799                                  ;Function : need, Number of local variables: 1
  2800                                  ;   # type sign width line used address name   list of local variables
  2801                                  ;  200 var sign byte   151 NULL bp+4    c;
  2802 00002A4B C8000000                 ENTER  0,0
  2803 00002A4F 8A4604                   mov al, byte [bp+4]
  2804 00002A52 B400                     mov ah, 0
  2805 00002A54 50                       push ax
  2806 00002A55 E8C5FF                   call isToken
  2807 00002A58 83C402                   add  sp, 2
  2808 00002A5B 08C0                     or  al, al
  2809 00002A5D 0F840600                 je @@need114
  2810                                  
  2811                                  ;-153         getTokeType();
  2812                                  
  2813 00002A61 E859FB                   call getTokeType
  2814                                  
  2815                                  ;-154         return;
  2816                                  
  2817 00002A64 E91800                   jmp @@retn
  2818                                  
  2819                                  ;-155         }
  2820                                  
  2821                                  
  2822                                  ;-156     error1();
  2823                                  
  2824                                  @@need114:
  2825 00002A67 E80A0A                   call error1
  2826                                  
  2827                                  ;-157     prs(". need: ");
  2828                                  
  2829 00002A6A 68[812A]                 push need_0
  2830 00002A6D E8A308                   call prs
  2831 00002A70 83C402                   add  sp, 2
  2832                                  
  2833                                  ;-158     prc(c);
  2834                                  
  2835 00002A73 8A4604                   mov al, byte [bp+4]
  2836 00002A76 B400                     mov ah, 0
  2837 00002A78 50                       push ax
  2838 00002A79 E83608                   call prc
  2839 00002A7C 83C402                   add  sp, 2
  2840                                  
  2841                                  ;-159 }
  2842                                  
  2843                                  
  2844                                  ;-160 int skipRest() {
  2845                                  
  2846 00002A7F C9                      @@retn: LEAVE
  2847 00002A80 C3                       ret
  2848                                  ; ENDP
  2849 00002A81 2E206E6565643A2000      need_0 db ". need: ",0
  2850                                  
  2851                                  skipRest:  ; *** PROC ***
  2852                                  
  2853                                  ;-161     getTokeType(); 
  2854                                  
  2855 00002A8A E830FB                   call getTokeType
  2856                                  
  2857                                  ;-162     if(TokeType)error1("extra char ignored");
  2858                                  
  2859 00002A8D A0[AB01]                 mov al, [TokeType]
  2860 00002A90 08C0                     or  al, al
  2861 00002A92 0F840900                 je @@skipRest115
  2862 00002A96 68[A02A]                 push skipRest_0
  2863 00002A99 E8D809                   call error1
  2864 00002A9C 83C402                   add  sp, 2
  2865                                  
  2866                                  ;-163 }
  2867                                  
  2868                                  @@skipRest115:
  2869 00002A9F C3                       ret
  2870                                  ; ENDP
  2871 00002AA0 657874726120636861-     skipRest_0 db "extra char ignored",0
  2872 00002AA9 722069676E6F726564-
  2873 00002AB2 00                 
  2874                                  ;Back to main program: AS.C
  2875                                  
  2876                                  ;-6 #include "HELPER.C"
  2877                                  
  2878                                  ;Use include file: HELPER.C
  2879                                  
  2880                                  ;-1 int getLine() {// make ASCIIZ, skip LF=10 and CR=13
  2881                                  
  2882                                  
  2883                                  getLine:  ; *** PROC ***
  2884                                  
  2885                                  ;-2   unsigned int i;
  2886                                  
  2887                                  
  2888                                  ;-3   InputPtr= &InputBuf;
  2889                                  
  2890                                  ;Function : getLine, Number of local variables: 1
  2891                                  ;   # type sign width line used address name   list of local variables
  2892                                  ;  200 var unsg word     2 NULL bp-2    i;
  2893 00002AB3 C8020000                 ENTER  2,0
  2894 00002AB7 B8[4F00]                 mov ax, InputBuf
  2895 00002ABA A3[CE00]                 mov word [InputPtr], ax
  2896                                  
  2897                                  ;-4   *InputPtr=0;//if last line is empty
  2898                                  
  2899 00002ABD 66B800000000             mov eax, 0
  2900 00002AC3 8B1E[CE00]               mov  bx, [InputPtr]
  2901 00002AC7 8807                     mov  [bx], al
  2902                                  
  2903                                  ;-5   do {
  2904                                  
  2905                                  @@getLine116:
  2906                                  
  2907                                  ;-6     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  2908                                  
  2909 00002AC9 6A01                     push 1
  2910 00002ACB FF36[9901]               push word [asm_fd]
  2911 00002ACF 8D06[A501]               lea  ax, [DOS_ByteRead]
  2912 00002AD3 50                       push ax
  2913 00002AD4 E8271A                   call readRL
  2914 00002AD7 83C406                   add  sp, 6
  2915 00002ADA A3[A301]                 mov word [DOS_NoBytes], ax
  2916                                  
  2917                                  ;-7     if (DOS_ERR) errorexit("Reading Source");
  2918                                  
  2919 00002ADD A1[9F01]                 mov ax, [DOS_ERR]
  2920 00002AE0 08C0                     or  al, al
  2921 00002AE2 0F840900                 je @@getLine117
  2922 00002AE6 68[4B2B]                 push getLine_0
  2923 00002AE9 E8E709                   call errorexit
  2924 00002AEC 83C402                   add  sp, 2
  2925                                  
  2926                                  ;-8     if (DOS_NoBytes == 0) return;
  2927                                  
  2928                                  @@getLine117:
  2929 00002AEF A1[A301]                 mov ax, [DOS_NoBytes]
  2930 00002AF2 83F800                   cmp ax, 0
  2931 00002AF5 0F850300                 jne @@getLine118
  2932 00002AF9 E94D00                   jmp @@retn
  2933                                  
  2934                                  ;-9     *InputPtr = DOS_ByteRead;
  2935                                  
  2936                                  @@getLine118:
  2937 00002AFC A0[A501]                 mov al, [DOS_ByteRead]
  2938 00002AFF 8B1E[CE00]               mov  bx, [InputPtr]
  2939 00002B03 8807                     mov  [bx], al
  2940                                  
  2941                                  ;-10     InputPtr++;
  2942                                  
  2943 00002B05 FF06[CE00]               inc  word [InputPtr]
  2944                                  
  2945                                  ;-11     i = InputPtr - &InputBuf;
  2946                                  
  2947 00002B09 A1[CE00]                 mov ax, [InputPtr]
  2948 00002B0C 2D[4F00]                 sub ax, InputBuf
  2949 00002B0F 8946FE                   mov word [bp-2], ax
  2950                                  
  2951                                  ;-12     if (i >= INPUTBUFMAX) errorexit("input line too long");
  2952                                  
  2953 00002B12 8B46FE                   mov ax, [bp-2]
  2954 00002B15 83F87F                   cmp ax, 127 ;unsigned : 0
  2955 00002B18 0F820900                 jb  @@getLine119
  2956 00002B1C 68[5A2B]                 push getLine_1
  2957 00002B1F E8B109                   call errorexit
  2958 00002B22 83C402                   add  sp, 2
  2959                                  
  2960                                  ;-13   } while (ifEOL(DOS_ByteRead) == 0);
  2961                                  
  2962                                  @@getLine119:
  2963 00002B25 A0[A501]                 mov al, byte [DOS_ByteRead]
  2964 00002B28 B400                     mov ah, 0
  2965 00002B2A 50                       push ax
  2966 00002B2B E84000                   call ifEOL
  2967 00002B2E 83C402                   add  sp, 2
  2968 00002B31 3C00                     cmp al, 0
  2969 00002B33 0F850200                 jne @@getLine120
  2970 00002B37 EB90                     jmp @@getLine116
  2971                                  @@getLine120:
  2972                                  
  2973                                  ;-14   InputPtr--;
  2974                                  
  2975 00002B39 FF0E[CE00]               dec  word [InputPtr]
  2976                                  
  2977                                  ;-15   *InputPtr=0;
  2978                                  
  2979 00002B3D 66B800000000             mov eax, 0
  2980 00002B43 8B1E[CE00]               mov  bx, [InputPtr]
  2981 00002B47 8807                     mov  [bx], al
  2982                                  
  2983                                  ;-16 }
  2984                                  
  2985                                  
  2986                                  ;-17 int ifEOL(char c) {
  2987                                  
  2988 00002B49 C9                      @@retn: LEAVE
  2989 00002B4A C3                       ret
  2990                                  ; ENDP
  2991 00002B4B 52656164696E672053-     getLine_0 db "Reading Source",0
  2992 00002B54 6F7572636500       
  2993 00002B5A 696E707574206C696E-     getLine_1 db "input line too long",0
  2994 00002B63 6520746F6F206C6F6E-
  2995 00002B6C 6700               
  2996                                  
  2997                                  ifEOL:  ; *** PROC ***
  2998                                  
  2999                                  ;-18   if (c == 10) return 1;
  3000                                  
  3001                                  ;Function : ifEOL, Number of local variables: 1
  3002                                  ;   # type sign width line used address name   list of local variables
  3003                                  ;  200 var sign byte    17 NULL bp+4    c;
  3004 00002B6E C8000000                 ENTER  0,0
  3005 00002B72 8A4604                   mov al, [bp+4]
  3006 00002B75 3C0A                     cmp al, 10
  3007 00002B77 0F850900                 jne @@ifEOL121
  3008 00002B7B 66B801000000             mov eax, 1
  3009 00002B81 E92F00                   jmp @@retn
  3010                                  
  3011                                  ;-19   if (c == 13) {
  3012                                  
  3013                                  @@ifEOL121:
  3014 00002B84 8A4604                   mov al, [bp+4]
  3015 00002B87 3C0D                     cmp al, 13
  3016 00002B89 0F851D00                 jne @@ifEOL122
  3017                                  
  3018                                  ;-20     DOS_NoBytes=readRL(&DOS_ByteRead, asm_fd, 1);
  3019                                  
  3020 00002B8D 6A01                     push 1
  3021 00002B8F FF36[9901]               push word [asm_fd]
  3022 00002B93 8D06[A501]               lea  ax, [DOS_ByteRead]
  3023 00002B97 50                       push ax
  3024 00002B98 E86319                   call readRL
  3025 00002B9B 83C406                   add  sp, 6
  3026 00002B9E A3[A301]                 mov word [DOS_NoBytes], ax
  3027                                  
  3028                                  ;-21     return 1;}
  3029                                  
  3030 00002BA1 66B801000000             mov eax, 1
  3031 00002BA7 E90900                   jmp @@retn
  3032                                  
  3033                                  ;-22   return 0;
  3034                                  
  3035                                  @@ifEOL122:
  3036 00002BAA 66B800000000             mov eax, 0
  3037 00002BB0 E90000                   jmp @@retn
  3038                                  
  3039                                  ;-23 }
  3040                                  
  3041                                  
  3042                                  ;-24 int skipBlank() {
  3043                                  
  3044 00002BB3 C9                      @@retn: LEAVE
  3045 00002BB4 C3                       ret
  3046                                  ; ENDP
  3047                                  
  3048                                  skipBlank:  ; *** PROC ***
  3049                                  
  3050                                  ;-25   skipblank1:
  3051                                  
  3052                                  @@skipblank1:
  3053                                  
  3054                                  ;-26     if (*InputPtr == ' ') { InputPtr++; goto skipblank1; }
  3055                                  
  3056 00002BB5 8B1E[CE00]               mov bx, [InputPtr]
  3057 00002BB9 8A07                     mov al, [bx]
  3058 00002BBB B400                     mov ah, 0
  3059 00002BBD 83F820                   cmp ax, 32
  3060 00002BC0 0F850600                 jne @@skipBlank123
  3061 00002BC4 FF06[CE00]               inc  word [InputPtr]
  3062 00002BC8 EBEB                     jmp @@skipblank1
  3063                                  
  3064                                  ;-27     if (*InputPtr == 9  ) { InputPtr++; goto skipblank1; }
  3065                                  
  3066                                  @@skipBlank123:
  3067 00002BCA 8B1E[CE00]               mov bx, [InputPtr]
  3068 00002BCE 8A07                     mov al, [bx]
  3069 00002BD0 B400                     mov ah, 0
  3070 00002BD2 83F809                   cmp ax, 9
  3071 00002BD5 0F850600                 jne @@skipBlank124
  3072 00002BD9 FF06[CE00]               inc  word [InputPtr]
  3073 00002BDD EBD6                     jmp @@skipblank1
  3074                                  
  3075                                  ;-28 }
  3076                                  
  3077                                  @@skipBlank124:
  3078                                  
  3079                                  ;-29 int letterE(char c) {
  3080                                  
  3081 00002BDF C3                       ret
  3082                                  ; ENDP
  3083                                  
  3084                                  letterE:  ; *** PROC ***
  3085                                  
  3086                                  ;-30   if (c=='_') return 1;
  3087                                  
  3088                                  ;Function : letterE, Number of local variables: 1
  3089                                  ;   # type sign width line used address name   list of local variables
  3090                                  ;  200 var sign byte    29 NULL bp+4    c;
  3091 00002BE0 C8000000                 ENTER  0,0
  3092 00002BE4 8A4604                   mov al, [bp+4]
  3093 00002BE7 3C5F                     cmp al, 95
  3094 00002BE9 0F850900                 jne @@letterE125
  3095 00002BED 66B801000000             mov eax, 1
  3096 00002BF3 E97E00                   jmp @@retn
  3097                                  
  3098                                  ;-31   if (c=='.') return 1;
  3099                                  
  3100                                  @@letterE125:
  3101 00002BF6 8A4604                   mov al, [bp+4]
  3102 00002BF9 3C2E                     cmp al, 46
  3103 00002BFB 0F850900                 jne @@letterE126
  3104 00002BFF 66B801000000             mov eax, 1
  3105 00002C05 E96C00                   jmp @@retn
  3106                                  
  3107                                  ;-32   if (c=='?') return 1;
  3108                                  
  3109                                  @@letterE126:
  3110 00002C08 8A4604                   mov al, [bp+4]
  3111 00002C0B 3C3F                     cmp al, 63
  3112 00002C0D 0F850900                 jne @@letterE127
  3113 00002C11 66B801000000             mov eax, 1
  3114 00002C17 E95A00                   jmp @@retn
  3115                                  
  3116                                  ;-33   if (c=='$') return 1;
  3117                                  
  3118                                  @@letterE127:
  3119 00002C1A 8A4604                   mov al, [bp+4]
  3120 00002C1D 3C24                     cmp al, 36
  3121 00002C1F 0F850900                 jne @@letterE128
  3122 00002C23 66B801000000             mov eax, 1
  3123 00002C29 E94800                   jmp @@retn
  3124                                  
  3125                                  ;-34   if (c> 'z') return 0;
  3126                                  
  3127                                  @@letterE128:
  3128 00002C2C 8A4604                   mov al, [bp+4]
  3129 00002C2F 3C7A                     cmp al, 122
  3130 00002C31 0F8E0900                 jle @@letterE129
  3131 00002C35 66B800000000             mov eax, 0
  3132 00002C3B E93600                   jmp @@retn
  3133                                  
  3134                                  ;-35   if (c< '@') return 0; // at included
  3135                                  
  3136                                  @@letterE129:
  3137 00002C3E 8A4604                   mov al, [bp+4]
  3138 00002C41 3C40                     cmp al, 64
  3139 00002C43 0F8D0900                 jge @@letterE130
  3140 00002C47 66B800000000             mov eax, 0
  3141 00002C4D E92400                   jmp @@retn
  3142                                  
  3143                                  ;-36   if (c> 'Z') { if (c< 'a') return 0; }
  3144                                  
  3145                                  @@letterE130:
  3146 00002C50 8A4604                   mov al, [bp+4]
  3147 00002C53 3C5A                     cmp al, 90
  3148 00002C55 0F8E1200                 jle @@letterE131
  3149 00002C59 8A4604                   mov al, [bp+4]
  3150 00002C5C 3C61                     cmp al, 97
  3151 00002C5E 0F8D0900                 jge @@letterE132
  3152 00002C62 66B800000000             mov eax, 0
  3153 00002C68 E90900                   jmp @@retn
  3154                                  @@letterE132:
  3155                                  
  3156                                  ;-37   return 1;
  3157                                  
  3158                                  @@letterE131:
  3159 00002C6B 66B801000000             mov eax, 1
  3160 00002C71 E90000                   jmp @@retn
  3161                                  
  3162                                  ;-38 }
  3163                                  
  3164                                  
  3165                                  ;-39 int alnumE(char c) {
  3166                                  
  3167 00002C74 C9                      @@retn: LEAVE
  3168 00002C75 C3                       ret
  3169                                  ; ENDP
  3170                                  
  3171                                  alnumE:  ; *** PROC ***
  3172                                  
  3173                                  ;-40   if (digit(c)) return 1;
  3174                                  
  3175                                  ;Function : alnumE, Number of local variables: 1
  3176                                  ;   # type sign width line used address name   list of local variables
  3177                                  ;  200 var sign byte    39 NULL bp+4    c;
  3178 00002C76 C8000000                 ENTER  0,0
  3179 00002C7A 8A4604                   mov al, byte [bp+4]
  3180 00002C7D B400                     mov ah, 0
  3181 00002C7F 50                       push ax
  3182 00002C80 E8AD17                   call digit
  3183 00002C83 83C402                   add  sp, 2
  3184 00002C86 08C0                     or  al, al
  3185 00002C88 0F840900                 je @@alnumE133
  3186 00002C8C 66B801000000             mov eax, 1
  3187 00002C92 E92400                   jmp @@retn
  3188                                  
  3189                                  ;-41   if (letterE(c)) return 1;
  3190                                  
  3191                                  @@alnumE133:
  3192 00002C95 8A4604                   mov al, byte [bp+4]
  3193 00002C98 B400                     mov ah, 0
  3194 00002C9A 50                       push ax
  3195 00002C9B E842FF                   call letterE
  3196 00002C9E 83C402                   add  sp, 2
  3197 00002CA1 08C0                     or  al, al
  3198 00002CA3 0F840900                 je @@alnumE134
  3199 00002CA7 66B801000000             mov eax, 1
  3200 00002CAD E90900                   jmp @@retn
  3201                                  
  3202                                  ;-42   return 0;
  3203                                  
  3204                                  @@alnumE134:
  3205 00002CB0 66B800000000             mov eax, 0
  3206 00002CB6 E90000                   jmp @@retn
  3207                                  
  3208                                  ;-43 }
  3209                                  
  3210                                  
  3211                                  ;-44 int getDigit(unsigned char c) {//ret: SymbolInt
  3212                                  
  3213 00002CB9 C9                      @@retn: LEAVE
  3214 00002CBA C3                       ret
  3215                                  ; ENDP
  3216                                  
  3217                                  getDigit:  ; *** PROC ***
  3218                                  
  3219                                  ;-45   unsigned int CastInt;
  3220                                  
  3221                                  
  3222                                  ;-46   SymbolInt=0;
  3223                                  
  3224                                  ;Function : getDigit, Number of local variables: 2
  3225                                  ;   # type sign width line used address name   list of local variables
  3226                                  ;  200 var unsg byte    44 NULL bp+4    c
  3227                                  ;  201 var unsg word    45 NULL bp-2    CastInt;
  3228 00002CBB C8020000                 ENTER  2,0
  3229 00002CBF 66B800000000             mov eax, 0
  3230 00002CC5 A3[4D00]                 mov word [SymbolInt], ax
  3231                                  
  3232                                  ;-47   do {
  3233                                  
  3234                                  @@getDigit135:
  3235                                  
  3236                                  ;-48     c-='0';
  3237                                  
  3238 00002CC8 806E0430                 sub  byte [bp+4], 48
  3239                                  
  3240                                  ;-49     SymbolInt=SymbolInt*10;
  3241                                  
  3242 00002CCC A1[4D00]                 mov ax, [SymbolInt]
  3243 00002CCF 66BB0A000000             mov ebx, 10
  3244 00002CD5 66F7E3                   mul ebx
  3245 00002CD8 A3[4D00]                 mov word [SymbolInt], ax
  3246                                  
  3247                                  ;-50     ax=0; CastInt=c; //cast b2w
  3248                                  
  3249 00002CDB B80000                   mov  ax, 0
  3250 00002CDE 8A4604                   mov al, [bp+4]
  3251 00002CE1 8946FE                   mov word [bp-2], ax
  3252                                  
  3253                                  ;-51     SymbolInt=SymbolInt+CastInt;
  3254                                  
  3255 00002CE4 A1[4D00]                 mov ax, [SymbolInt]
  3256 00002CE7 0346FE                   add ax, [bp-2]
  3257 00002CEA A3[4D00]                 mov word [SymbolInt], ax
  3258                                  
  3259                                  ;-52     InputPtr++;
  3260                                  
  3261 00002CED FF06[CE00]               inc  word [InputPtr]
  3262                                  
  3263                                  ;-53     c = *InputPtr;
  3264                                  
  3265 00002CF1 8B1E[CE00]               mov bx, [InputPtr]
  3266 00002CF5 8A07                     mov al, [bx]
  3267 00002CF7 B400                     mov ah, 0
  3268 00002CF9 884604                   mov byte [bp+4], al
  3269                                  
  3270                                  ;-54   } while(digit(c));
  3271                                  
  3272 00002CFC 8A4604                   mov al, byte [bp+4]
  3273 00002CFF B400                     mov ah, 0
  3274 00002D01 50                       push ax
  3275 00002D02 E82B17                   call digit
  3276 00002D05 83C402                   add  sp, 2
  3277 00002D08 08C0                     or  al, al
  3278 00002D0A 0F840200                 je @@getDigit136
  3279 00002D0E EBB8                     jmp @@getDigit135
  3280                                  @@getDigit136:
  3281                                  
  3282                                  ;-55 }
  3283                                  
  3284                                  
  3285                                  ;-56 int getName(unsigned char c) {//ret: Symbol, SymbolUpper, isLabel
  3286 00002D10 C9                       LEAVE
  3287 00002D11 C3                       ret
  3288                                  ; ENDP
  3289                                  
  3290                                  getName:  ; *** PROC ***
  3291                                  
  3292                                  ;-57   char *p; unsigned int i;
  3293                                  
  3294                                  
  3295                                  ;-58   p = &Symbol;
  3296                                  
  3297                                  ;Function : getName, Number of local variables: 3
  3298                                  ;   # type sign width line used address name   list of local variables
  3299                                  ;  200 var unsg byte    56 NULL bp+4    c
  3300                                  ;  201 ptr sign byte    57 NULL bp-2    p
  3301                                  ;  202 var unsg word    57 NULL bp-4    i;
  3302 00002D12 C8040000                 ENTER  4,0
  3303 00002D16 B8[0F00]                 mov ax, Symbol
  3304 00002D19 8946FE                   mov word [bp-2], ax
  3305                                  
  3306                                  ;-59   *p = c;
  3307                                  
  3308 00002D1C 8A4604                   mov al, [bp+4]
  3309 00002D1F 8B5EFE                   mov  bx, [bp-2]
  3310 00002D22 8807                     mov  [bx], al
  3311                                  
  3312                                  ;-60   p++;
  3313                                  
  3314 00002D24 FF46FE                   inc  word [bp-2]
  3315                                  
  3316                                  ;-61   while (alnumE(c)) {
  3317                                  
  3318                                  @@getName137:
  3319 00002D27 8A4604                   mov al, byte [bp+4]
  3320 00002D2A B400                     mov ah, 0
  3321 00002D2C 50                       push ax
  3322 00002D2D E846FF                   call alnumE
  3323 00002D30 83C402                   add  sp, 2
  3324 00002D33 08C0                     or  al, al
  3325 00002D35 0F843800                 je @@getName138
  3326                                  
  3327                                  ;-62     InputPtr++;
  3328                                  
  3329 00002D39 FF06[CE00]               inc  word [InputPtr]
  3330                                  
  3331                                  ;-63     c = *InputPtr;
  3332                                  
  3333 00002D3D 8B1E[CE00]               mov bx, [InputPtr]
  3334 00002D41 8A07                     mov al, [bx]
  3335 00002D43 B400                     mov ah, 0
  3336 00002D45 884604                   mov byte [bp+4], al
  3337                                  
  3338                                  ;-64     *p = c;
  3339                                  
  3340 00002D48 8A4604                   mov al, [bp+4]
  3341 00002D4B 8B5EFE                   mov  bx, [bp-2]
  3342 00002D4E 8807                     mov  [bx], al
  3343                                  
  3344                                  ;-65     p++;
  3345                                  
  3346 00002D50 FF46FE                   inc  word [bp-2]
  3347                                  
  3348                                  ;-66     i = p - &Symbol;
  3349                                  
  3350 00002D53 8B46FE                   mov ax, [bp-2]
  3351 00002D56 2D[0F00]                 sub ax, Symbol
  3352 00002D59 8946FC                   mov word [bp-4], ax
  3353                                  
  3354                                  ;-67     if (i >= SYMBOLMAX) errorexit("symbol too long");
  3355                                  
  3356 00002D5C 8B46FC                   mov ax, [bp-4]
  3357 00002D5F 83F81F                   cmp ax, 31 ;unsigned : 0
  3358 00002D62 0F820900                 jb  @@getName139
  3359 00002D66 68[BA2D]                 push getName_0
  3360 00002D69 E86707                   call errorexit
  3361 00002D6C 83C402                   add  sp, 2
  3362                                  
  3363                                  ;-68   }
  3364                                  
  3365                                  @@getName139:
  3366                                  
  3367                                  ;-69   if (c == ':') isLabel=1; else isLabel=0;
  3368                                  
  3369 00002D6F EBB6                     jmp @@getName137
  3370                                  @@getName138:
  3371 00002D71 8A4604                   mov al, [bp+4]
  3372 00002D74 3C3A                     cmp al, 58
  3373 00002D76 0F850C00                 jne @@getName140
  3374 00002D7A 66B801000000             mov eax, 1
  3375 00002D80 A2[AA01]                 mov byte [isLabel], al
  3376 00002D83 E90900                   jmp @@getName141
  3377                                  @@getName140:
  3378 00002D86 66B800000000             mov eax, 0
  3379 00002D8C A2[AA01]                 mov byte [isLabel], al
  3380                                  
  3381                                  ;-70   p--;
  3382                                  
  3383                                  @@getName141:
  3384 00002D8F FF4EFE                   dec  word [bp-2]
  3385                                  
  3386                                  ;-71   *p = 0;
  3387                                  
  3388 00002D92 66B800000000             mov eax, 0
  3389 00002D98 8B5EFE                   mov  bx, [bp-2]
  3390 00002D9B 8807                     mov  [bx], al
  3391                                  
  3392                                  ;-72   strcpy(SymbolUpper, Symbol);
  3393                                  
  3394 00002D9D 8D06[0F00]               lea  ax, [Symbol]
  3395 00002DA1 50                       push ax
  3396 00002DA2 8D06[2E00]               lea  ax, [SymbolUpper]
  3397 00002DA6 50                       push ax
  3398 00002DA7 E84D16                   call strcpy
  3399 00002DAA 83C404                   add  sp, 4
  3400                                  
  3401                                  ;-73   toupper(SymbolUpper);
  3402                                  
  3403 00002DAD 8D06[2E00]               lea  ax, [SymbolUpper]
  3404 00002DB1 50                       push ax
  3405 00002DB2 E8D415                   call toupper
  3406 00002DB5 83C402                   add  sp, 2
  3407                                  
  3408                                  ;-74 }
  3409                                  
  3410                                  
  3411                                  ;-75 int testReg() {
  3412 00002DB8 C9                       LEAVE
  3413 00002DB9 C3                       ret
  3414                                  ; ENDP
  3415 00002DBA 73796D626F6C20746F-     getName_0 db "symbol too long",0
  3416 00002DC3 6F206C6F6E6700     
  3417                                  
  3418                                  testReg:  ; *** PROC ***
  3419                                  
  3420                                  ;-76 //ret:RegNo: 0 - 7 AL, CL  set:R2Type: 0=no reg,BYTE,WORD,SEGREG,DWORD
  3421                                  
  3422                                  
  3423                                  ;-77   R2Type=0;
  3424                                  
  3425 00002DCA 66B800000000             mov eax, 0
  3426 00002DD0 A2[B401]                 mov byte [R2Type], al
  3427                                  
  3428                                  ;-78   if (strlen(Symbol) < 2) return 0;
  3429                                  
  3430 00002DD3 8D06[0F00]               lea  ax, [Symbol]
  3431 00002DD7 50                       push ax
  3432 00002DD8 E8F115                   call strlen
  3433 00002DDB 83C402                   add  sp, 2
  3434 00002DDE 3C02                     cmp al, 2
  3435 00002DE0 0F8D0900                 jge @@testReg142
  3436 00002DE4 66B800000000             mov eax, 0
  3437 00002DEA E9B603                   jmp @@retn
  3438                                  
  3439                                  ;-79   if (strlen(Symbol) > 3) return 0;
  3440                                  
  3441                                  @@testReg142:
  3442 00002DED 8D06[0F00]               lea  ax, [Symbol]
  3443 00002DF1 50                       push ax
  3444 00002DF2 E8D715                   call strlen
  3445 00002DF5 83C402                   add  sp, 2
  3446 00002DF8 3C03                     cmp al, 3
  3447 00002DFA 0F8E0900                 jle @@testReg143
  3448 00002DFE 66B800000000             mov eax, 0
  3449 00002E04 E99C03                   jmp @@retn
  3450                                  
  3451                                  ;-80   R2Type=BYTE;
  3452                                  
  3453                                  @@testReg143:
  3454 00002E07 66B801000000             mov eax, 1
  3455 00002E0D A2[B401]                 mov byte [R2Type], al
  3456                                  
  3457                                  ;-81   if (eqstr(SymbolUpper, "AL")) return 0;
  3458                                  
  3459 00002E10 68[A431]                 push testReg_0
  3460 00002E13 8D06[2E00]               lea  ax, [SymbolUpper]
  3461 00002E17 50                       push ax
  3462 00002E18 E84816                   call eqstr
  3463 00002E1B 83C404                   add  sp, 4
  3464 00002E1E 08C0                     or  al, al
  3465 00002E20 0F840900                 je @@testReg144
  3466 00002E24 66B800000000             mov eax, 0
  3467 00002E2A E97603                   jmp @@retn
  3468                                  
  3469                                  ;-82   if (eqstr(SymbolUpper, "CL")) return 1;
  3470                                  
  3471                                  @@testReg144:
  3472 00002E2D 68[A731]                 push testReg_1
  3473 00002E30 8D06[2E00]               lea  ax, [SymbolUpper]
  3474 00002E34 50                       push ax
  3475 00002E35 E82B16                   call eqstr
  3476 00002E38 83C404                   add  sp, 4
  3477 00002E3B 08C0                     or  al, al
  3478 00002E3D 0F840900                 je @@testReg145
  3479 00002E41 66B801000000             mov eax, 1
  3480 00002E47 E95903                   jmp @@retn
  3481                                  
  3482                                  ;-83   if (eqstr(SymbolUpper, "DL")) return 2;
  3483                                  
  3484                                  @@testReg145:
  3485 00002E4A 68[AA31]                 push testReg_2
  3486 00002E4D 8D06[2E00]               lea  ax, [SymbolUpper]
  3487 00002E51 50                       push ax
  3488 00002E52 E80E16                   call eqstr
  3489 00002E55 83C404                   add  sp, 4
  3490 00002E58 08C0                     or  al, al
  3491 00002E5A 0F840900                 je @@testReg146
  3492 00002E5E 66B802000000             mov eax, 2
  3493 00002E64 E93C03                   jmp @@retn
  3494                                  
  3495                                  ;-84   if (eqstr(SymbolUpper, "BL")) return 3;
  3496                                  
  3497                                  @@testReg146:
  3498 00002E67 68[AD31]                 push testReg_3
  3499 00002E6A 8D06[2E00]               lea  ax, [SymbolUpper]
  3500 00002E6E 50                       push ax
  3501 00002E6F E8F115                   call eqstr
  3502 00002E72 83C404                   add  sp, 4
  3503 00002E75 08C0                     or  al, al
  3504 00002E77 0F840900                 je @@testReg147
  3505 00002E7B 66B803000000             mov eax, 3
  3506 00002E81 E91F03                   jmp @@retn
  3507                                  
  3508                                  ;-85   if (eqstr(SymbolUpper, "AH")) return 4;
  3509                                  
  3510                                  @@testReg147:
  3511 00002E84 68[B031]                 push testReg_4
  3512 00002E87 8D06[2E00]               lea  ax, [SymbolUpper]
  3513 00002E8B 50                       push ax
  3514 00002E8C E8D415                   call eqstr
  3515 00002E8F 83C404                   add  sp, 4
  3516 00002E92 08C0                     or  al, al
  3517 00002E94 0F840900                 je @@testReg148
  3518 00002E98 66B804000000             mov eax, 4
  3519 00002E9E E90203                   jmp @@retn
  3520                                  
  3521                                  ;-86   if (eqstr(SymbolUpper, "CH")) return 5;
  3522                                  
  3523                                  @@testReg148:
  3524 00002EA1 68[B331]                 push testReg_5
  3525 00002EA4 8D06[2E00]               lea  ax, [SymbolUpper]
  3526 00002EA8 50                       push ax
  3527 00002EA9 E8B715                   call eqstr
  3528 00002EAC 83C404                   add  sp, 4
  3529 00002EAF 08C0                     or  al, al
  3530 00002EB1 0F840900                 je @@testReg149
  3531 00002EB5 66B805000000             mov eax, 5
  3532 00002EBB E9E502                   jmp @@retn
  3533                                  
  3534                                  ;-87   if (eqstr(SymbolUpper, "DH")) return 6;
  3535                                  
  3536                                  @@testReg149:
  3537 00002EBE 68[B631]                 push testReg_6
  3538 00002EC1 8D06[2E00]               lea  ax, [SymbolUpper]
  3539 00002EC5 50                       push ax
  3540 00002EC6 E89A15                   call eqstr
  3541 00002EC9 83C404                   add  sp, 4
  3542 00002ECC 08C0                     or  al, al
  3543 00002ECE 0F840900                 je @@testReg150
  3544 00002ED2 66B806000000             mov eax, 6
  3545 00002ED8 E9C802                   jmp @@retn
  3546                                  
  3547                                  ;-88   if (eqstr(SymbolUpper, "BH")) return 7;
  3548                                  
  3549                                  @@testReg150:
  3550 00002EDB 68[B931]                 push testReg_7
  3551 00002EDE 8D06[2E00]               lea  ax, [SymbolUpper]
  3552 00002EE2 50                       push ax
  3553 00002EE3 E87D15                   call eqstr
  3554 00002EE6 83C404                   add  sp, 4
  3555 00002EE9 08C0                     or  al, al
  3556 00002EEB 0F840900                 je @@testReg151
  3557 00002EEF 66B807000000             mov eax, 7
  3558 00002EF5 E9AB02                   jmp @@retn
  3559                                  
  3560                                  ;-89   R2Type=WORD;
  3561                                  
  3562                                  @@testReg151:
  3563 00002EF8 66B802000000             mov eax, 2
  3564 00002EFE A2[B401]                 mov byte [R2Type], al
  3565                                  
  3566                                  ;-90   if (eqstr(SymbolUpper, "AX")) return 0;
  3567                                  
  3568 00002F01 68[BC31]                 push testReg_8
  3569 00002F04 8D06[2E00]               lea  ax, [SymbolUpper]
  3570 00002F08 50                       push ax
  3571 00002F09 E85715                   call eqstr
  3572 00002F0C 83C404                   add  sp, 4
  3573 00002F0F 08C0                     or  al, al
  3574 00002F11 0F840900                 je @@testReg152
  3575 00002F15 66B800000000             mov eax, 0
  3576 00002F1B E98502                   jmp @@retn
  3577                                  
  3578                                  ;-91   if (eqstr(SymbolUpper, "CX")) return 1;
  3579                                  
  3580                                  @@testReg152:
  3581 00002F1E 68[BF31]                 push testReg_9
  3582 00002F21 8D06[2E00]               lea  ax, [SymbolUpper]
  3583 00002F25 50                       push ax
  3584 00002F26 E83A15                   call eqstr
  3585 00002F29 83C404                   add  sp, 4
  3586 00002F2C 08C0                     or  al, al
  3587 00002F2E 0F840900                 je @@testReg153
  3588 00002F32 66B801000000             mov eax, 1
  3589 00002F38 E96802                   jmp @@retn
  3590                                  
  3591                                  ;-92   if (eqstr(SymbolUpper, "DX")) return 2;
  3592                                  
  3593                                  @@testReg153:
  3594 00002F3B 68[C231]                 push testReg_10
  3595 00002F3E 8D06[2E00]               lea  ax, [SymbolUpper]
  3596 00002F42 50                       push ax
  3597 00002F43 E81D15                   call eqstr
  3598 00002F46 83C404                   add  sp, 4
  3599 00002F49 08C0                     or  al, al
  3600 00002F4B 0F840900                 je @@testReg154
  3601 00002F4F 66B802000000             mov eax, 2
  3602 00002F55 E94B02                   jmp @@retn
  3603                                  
  3604                                  ;-93   if (eqstr(SymbolUpper, "BX")) return 3;
  3605                                  
  3606                                  @@testReg154:
  3607 00002F58 68[C531]                 push testReg_11
  3608 00002F5B 8D06[2E00]               lea  ax, [SymbolUpper]
  3609 00002F5F 50                       push ax
  3610 00002F60 E80015                   call eqstr
  3611 00002F63 83C404                   add  sp, 4
  3612 00002F66 08C0                     or  al, al
  3613 00002F68 0F840900                 je @@testReg155
  3614 00002F6C 66B803000000             mov eax, 3
  3615 00002F72 E92E02                   jmp @@retn
  3616                                  
  3617                                  ;-94   if (eqstr(SymbolUpper, "SP")) return 4;
  3618                                  
  3619                                  @@testReg155:
  3620 00002F75 68[C831]                 push testReg_12
  3621 00002F78 8D06[2E00]               lea  ax, [SymbolUpper]
  3622 00002F7C 50                       push ax
  3623 00002F7D E8E314                   call eqstr
  3624 00002F80 83C404                   add  sp, 4
  3625 00002F83 08C0                     or  al, al
  3626 00002F85 0F840900                 je @@testReg156
  3627 00002F89 66B804000000             mov eax, 4
  3628 00002F8F E91102                   jmp @@retn
  3629                                  
  3630                                  ;-95   if (eqstr(SymbolUpper, "BP")) return 5;
  3631                                  
  3632                                  @@testReg156:
  3633 00002F92 68[CB31]                 push testReg_13
  3634 00002F95 8D06[2E00]               lea  ax, [SymbolUpper]
  3635 00002F99 50                       push ax
  3636 00002F9A E8C614                   call eqstr
  3637 00002F9D 83C404                   add  sp, 4
  3638 00002FA0 08C0                     or  al, al
  3639 00002FA2 0F840900                 je @@testReg157
  3640 00002FA6 66B805000000             mov eax, 5
  3641 00002FAC E9F401                   jmp @@retn
  3642                                  
  3643                                  ;-96   if (eqstr(SymbolUpper, "SI")) return 6;
  3644                                  
  3645                                  @@testReg157:
  3646 00002FAF 68[CE31]                 push testReg_14
  3647 00002FB2 8D06[2E00]               lea  ax, [SymbolUpper]
  3648 00002FB6 50                       push ax
  3649 00002FB7 E8A914                   call eqstr
  3650 00002FBA 83C404                   add  sp, 4
  3651 00002FBD 08C0                     or  al, al
  3652 00002FBF 0F840900                 je @@testReg158
  3653 00002FC3 66B806000000             mov eax, 6
  3654 00002FC9 E9D701                   jmp @@retn
  3655                                  
  3656                                  ;-97   if (eqstr(SymbolUpper, "DI")) return 7;
  3657                                  
  3658                                  @@testReg158:
  3659 00002FCC 68[D131]                 push testReg_15
  3660 00002FCF 8D06[2E00]               lea  ax, [SymbolUpper]
  3661 00002FD3 50                       push ax
  3662 00002FD4 E88C14                   call eqstr
  3663 00002FD7 83C404                   add  sp, 4
  3664 00002FDA 08C0                     or  al, al
  3665 00002FDC 0F840900                 je @@testReg159
  3666 00002FE0 66B807000000             mov eax, 7
  3667 00002FE6 E9BA01                   jmp @@retn
  3668                                  
  3669                                  ;-98   R2Type=SEGREG;
  3670                                  
  3671                                  @@testReg159:
  3672 00002FE9 66B804000000             mov eax, 4
  3673 00002FEF A2[B401]                 mov byte [R2Type], al
  3674                                  
  3675                                  ;-99   if (eqstr(SymbolUpper, "ES")) return 0;
  3676                                  
  3677 00002FF2 68[D431]                 push testReg_16
  3678 00002FF5 8D06[2E00]               lea  ax, [SymbolUpper]
  3679 00002FF9 50                       push ax
  3680 00002FFA E86614                   call eqstr
  3681 00002FFD 83C404                   add  sp, 4
  3682 00003000 08C0                     or  al, al
  3683 00003002 0F840900                 je @@testReg160
  3684 00003006 66B800000000             mov eax, 0
  3685 0000300C E99401                   jmp @@retn
  3686                                  
  3687                                  ;-100   if (eqstr(SymbolUpper, "CS")) return 1;
  3688                                  
  3689                                  @@testReg160:
  3690 0000300F 68[D731]                 push testReg_17
  3691 00003012 8D06[2E00]               lea  ax, [SymbolUpper]
  3692 00003016 50                       push ax
  3693 00003017 E84914                   call eqstr
  3694 0000301A 83C404                   add  sp, 4
  3695 0000301D 08C0                     or  al, al
  3696 0000301F 0F840900                 je @@testReg161
  3697 00003023 66B801000000             mov eax, 1
  3698 00003029 E97701                   jmp @@retn
  3699                                  
  3700                                  ;-101   if (eqstr(SymbolUpper, "SS")) return 2;
  3701                                  
  3702                                  @@testReg161:
  3703 0000302C 68[DA31]                 push testReg_18
  3704 0000302F 8D06[2E00]               lea  ax, [SymbolUpper]
  3705 00003033 50                       push ax
  3706 00003034 E82C14                   call eqstr
  3707 00003037 83C404                   add  sp, 4
  3708 0000303A 08C0                     or  al, al
  3709 0000303C 0F840900                 je @@testReg162
  3710 00003040 66B802000000             mov eax, 2
  3711 00003046 E95A01                   jmp @@retn
  3712                                  
  3713                                  ;-102   if (eqstr(SymbolUpper, "DS")) return 3;
  3714                                  
  3715                                  @@testReg162:
  3716 00003049 68[DD31]                 push testReg_19
  3717 0000304C 8D06[2E00]               lea  ax, [SymbolUpper]
  3718 00003050 50                       push ax
  3719 00003051 E80F14                   call eqstr
  3720 00003054 83C404                   add  sp, 4
  3721 00003057 08C0                     or  al, al
  3722 00003059 0F840900                 je @@testReg163
  3723 0000305D 66B803000000             mov eax, 3
  3724 00003063 E93D01                   jmp @@retn
  3725                                  
  3726                                  ;-103   if (eqstr(SymbolUpper, "FS")) return 4;
  3727                                  
  3728                                  @@testReg163:
  3729 00003066 68[E031]                 push testReg_20
  3730 00003069 8D06[2E00]               lea  ax, [SymbolUpper]
  3731 0000306D 50                       push ax
  3732 0000306E E8F213                   call eqstr
  3733 00003071 83C404                   add  sp, 4
  3734 00003074 08C0                     or  al, al
  3735 00003076 0F840900                 je @@testReg164
  3736 0000307A 66B804000000             mov eax, 4
  3737 00003080 E92001                   jmp @@retn
  3738                                  
  3739                                  ;-104   if (eqstr(SymbolUpper, "GS")) return 5;
  3740                                  
  3741                                  @@testReg164:
  3742 00003083 68[E331]                 push testReg_21
  3743 00003086 8D06[2E00]               lea  ax, [SymbolUpper]
  3744 0000308A 50                       push ax
  3745 0000308B E8D513                   call eqstr
  3746 0000308E 83C404                   add  sp, 4
  3747 00003091 08C0                     or  al, al
  3748 00003093 0F840900                 je @@testReg165
  3749 00003097 66B805000000             mov eax, 5
  3750 0000309D E90301                   jmp @@retn
  3751                                  
  3752                                  ;-105   R2Type=DWORD;                         
  3753                                  
  3754                                  @@testReg165:
  3755 000030A0 66B803000000             mov eax, 3
  3756 000030A6 A2[B401]                 mov byte [R2Type], al
  3757                                  
  3758                                  ;-106   if (eqstr(SymbolUpper, "EAX"))return 0;
  3759                                  
  3760 000030A9 68[E631]                 push testReg_22
  3761 000030AC 8D06[2E00]               lea  ax, [SymbolUpper]
  3762 000030B0 50                       push ax
  3763 000030B1 E8AF13                   call eqstr
  3764 000030B4 83C404                   add  sp, 4
  3765 000030B7 08C0                     or  al, al
  3766 000030B9 0F840900                 je @@testReg166
  3767 000030BD 66B800000000             mov eax, 0
  3768 000030C3 E9DD00                   jmp @@retn
  3769                                  
  3770                                  ;-107   if (eqstr(SymbolUpper, "ECX"))return 1;
  3771                                  
  3772                                  @@testReg166:
  3773 000030C6 68[EA31]                 push testReg_23
  3774 000030C9 8D06[2E00]               lea  ax, [SymbolUpper]
  3775 000030CD 50                       push ax
  3776 000030CE E89213                   call eqstr
  3777 000030D1 83C404                   add  sp, 4
  3778 000030D4 08C0                     or  al, al
  3779 000030D6 0F840900                 je @@testReg167
  3780 000030DA 66B801000000             mov eax, 1
  3781 000030E0 E9C000                   jmp @@retn
  3782                                  
  3783                                  ;-108   if (eqstr(SymbolUpper, "EDX"))return 2;
  3784                                  
  3785                                  @@testReg167:
  3786 000030E3 68[EE31]                 push testReg_24
  3787 000030E6 8D06[2E00]               lea  ax, [SymbolUpper]
  3788 000030EA 50                       push ax
  3789 000030EB E87513                   call eqstr
  3790 000030EE 83C404                   add  sp, 4
  3791 000030F1 08C0                     or  al, al
  3792 000030F3 0F840900                 je @@testReg168
  3793 000030F7 66B802000000             mov eax, 2
  3794 000030FD E9A300                   jmp @@retn
  3795                                  
  3796                                  ;-109   if (eqstr(SymbolUpper, "EBX"))return 3;
  3797                                  
  3798                                  @@testReg168:
  3799 00003100 68[F231]                 push testReg_25
  3800 00003103 8D06[2E00]               lea  ax, [SymbolUpper]
  3801 00003107 50                       push ax
  3802 00003108 E85813                   call eqstr
  3803 0000310B 83C404                   add  sp, 4
  3804 0000310E 08C0                     or  al, al
  3805 00003110 0F840900                 je @@testReg169
  3806 00003114 66B803000000             mov eax, 3
  3807 0000311A E98600                   jmp @@retn
  3808                                  
  3809                                  ;-110   if (eqstr(SymbolUpper, "ESP"))return 4;
  3810                                  
  3811                                  @@testReg169:
  3812 0000311D 68[F631]                 push testReg_26
  3813 00003120 8D06[2E00]               lea  ax, [SymbolUpper]
  3814 00003124 50                       push ax
  3815 00003125 E83B13                   call eqstr
  3816 00003128 83C404                   add  sp, 4
  3817 0000312B 08C0                     or  al, al
  3818 0000312D 0F840900                 je @@testReg170
  3819 00003131 66B804000000             mov eax, 4
  3820 00003137 E96900                   jmp @@retn
  3821                                  
  3822                                  ;-111   if (eqstr(SymbolUpper, "EBP"))return 5;
  3823                                  
  3824                                  @@testReg170:
  3825 0000313A 68[FA31]                 push testReg_27
  3826 0000313D 8D06[2E00]               lea  ax, [SymbolUpper]
  3827 00003141 50                       push ax
  3828 00003142 E81E13                   call eqstr
  3829 00003145 83C404                   add  sp, 4
  3830 00003148 08C0                     or  al, al
  3831 0000314A 0F840900                 je @@testReg171
  3832 0000314E 66B805000000             mov eax, 5
  3833 00003154 E94C00                   jmp @@retn
  3834                                  
  3835                                  ;-112   if (eqstr(SymbolUpper, "ESI"))return 6;
  3836                                  
  3837                                  @@testReg171:
  3838 00003157 68[FE31]                 push testReg_28
  3839 0000315A 8D06[2E00]               lea  ax, [SymbolUpper]
  3840 0000315E 50                       push ax
  3841 0000315F E80113                   call eqstr
  3842 00003162 83C404                   add  sp, 4
  3843 00003165 08C0                     or  al, al
  3844 00003167 0F840900                 je @@testReg172
  3845 0000316B 66B806000000             mov eax, 6
  3846 00003171 E92F00                   jmp @@retn
  3847                                  
  3848                                  ;-113   if (eqstr(SymbolUpper, "EDI"))return 7;
  3849                                  
  3850                                  @@testReg172:
  3851 00003174 68[0232]                 push testReg_29
  3852 00003177 8D06[2E00]               lea  ax, [SymbolUpper]
  3853 0000317B 50                       push ax
  3854 0000317C E8E412                   call eqstr
  3855 0000317F 83C404                   add  sp, 4
  3856 00003182 08C0                     or  al, al
  3857 00003184 0F840900                 je @@testReg173
  3858 00003188 66B807000000             mov eax, 7
  3859 0000318E E91200                   jmp @@retn
  3860                                  
  3861                                  ;-114   R2Type=0; return 0;
  3862                                  
  3863                                  @@testReg173:
  3864 00003191 66B800000000             mov eax, 0
  3865 00003197 A2[B401]                 mov byte [R2Type], al
  3866 0000319A 66B800000000             mov eax, 0
  3867 000031A0 E90000                   jmp @@retn
  3868                                  
  3869                                  ;-115 }
  3870                                  
  3871                                  @@retn:
  3872 000031A3 C3                       ret
  3873                                  ; ENDP
  3874 000031A4 414C00                  testReg_0 db "AL",0
  3875 000031A7 434C00                  testReg_1 db "CL",0
  3876 000031AA 444C00                  testReg_2 db "DL",0
  3877 000031AD 424C00                  testReg_3 db "BL",0
  3878 000031B0 414800                  testReg_4 db "AH",0
  3879 000031B3 434800                  testReg_5 db "CH",0
  3880 000031B6 444800                  testReg_6 db "DH",0
  3881 000031B9 424800                  testReg_7 db "BH",0
  3882 000031BC 415800                  testReg_8 db "AX",0
  3883 000031BF 435800                  testReg_9 db "CX",0
  3884 000031C2 445800                  testReg_10 db "DX",0
  3885 000031C5 425800                  testReg_11 db "BX",0
  3886 000031C8 535000                  testReg_12 db "SP",0
  3887 000031CB 425000                  testReg_13 db "BP",0
  3888 000031CE 534900                  testReg_14 db "SI",0
  3889 000031D1 444900                  testReg_15 db "DI",0
  3890 000031D4 455300                  testReg_16 db "ES",0
  3891 000031D7 435300                  testReg_17 db "CS",0
  3892 000031DA 535300                  testReg_18 db "SS",0
  3893 000031DD 445300                  testReg_19 db "DS",0
  3894 000031E0 465300                  testReg_20 db "FS",0
  3895 000031E3 475300                  testReg_21 db "GS",0
  3896 000031E6 45415800                testReg_22 db "EAX",0
  3897 000031EA 45435800                testReg_23 db "ECX",0
  3898 000031EE 45445800                testReg_24 db "EDX",0
  3899 000031F2 45425800                testReg_25 db "EBX",0
  3900 000031F6 45535000                testReg_26 db "ESP",0
  3901 000031FA 45425000                testReg_27 db "EBP",0
  3902 000031FE 45534900                testReg_28 db "ESI",0
  3903 00003202 45444900                testReg_29 db "EDI",0
  3904                                  ;Back to main program: AS.C
  3905                                  
  3906                                  ;-7 #include "OUTPUT.C"
  3907                                  
  3908                                  ;Use include file: OUTPUT.C
  3909                                  
  3910                                  ;-1 int printLine() { 
  3911                                  
  3912                                  
  3913                                  printLine:  ; *** PROC ***
  3914                                  
  3915                                  ;-2     int i; char c;
  3916                                  
  3917                                  
  3918                                  ;-3     prs("\n"); 
  3919                                  
  3920                                  ;Function : printLine, Number of local variables: 2
  3921                                  ;   # type sign width line used address name   list of local variables
  3922                                  ;  200 var sign word     2 NULL bp-2    i
  3923                                  ;  201 var sign byte     2 NULL bp-4    c;
  3924 00003206 C8040000                 ENTER  4,0
  3925 0000320A 68[9B32]                 push printLine_0
  3926 0000320D E80301                   call prs
  3927 00003210 83C402                   add  sp, 2
  3928                                  
  3929                                  ;-4     printhex16(PCStart);
  3930                                  
  3931 00003213 FF36[A801]               push word [PCStart]
  3932 00003217 E8EE01                   call printhex16
  3933 0000321A 83C402                   add  sp, 2
  3934                                  
  3935                                  ;-5     if (OpPrintIndex == 0) prs("               ");
  3936                                  
  3937 0000321D A1[C501]                 mov ax, [OpPrintIndex]
  3938 00003220 83F800                   cmp ax, 0
  3939 00003223 0F850C00                 jne @@printLine174
  3940 00003227 68[9E32]                 push printLine_1
  3941 0000322A E8E600                   call prs
  3942 0000322D 83C402                   add  sp, 2
  3943                                  
  3944                                  ;-6     else {
  3945                                  
  3946 00003230 E94F00                   jmp @@printLine175
  3947                                  @@printLine174:
  3948                                  
  3949                                  ;-7 //        prc(' ');
  3950                                  
  3951                                  
  3952                                  ;-8         i=0;
  3953                                  
  3954 00003233 66B800000000             mov eax, 0
  3955 00003239 8946FE                   mov word [bp-2], ax
  3956                                  
  3957                                  ;-9         do {
  3958                                  
  3959                                  @@printLine176:
  3960                                  
  3961                                  ;-10             c=OpPos[i];
  3962                                  
  3963 0000323C 8B5EFE                   mov bx, [bp-2]
  3964 0000323F 8A87[C001]               mov al, [OpPos + bx]
  3965 00003243 8846FC                   mov byte [bp-4], al
  3966                                  
  3967                                  ;-11             prc(' ');
  3968                                  
  3969 00003246 6A20                     push 32
  3970 00003248 E86700                   call prc
  3971 0000324B 83C402                   add  sp, 2
  3972                                  
  3973                                  ;-12             printhex8a(c); 
  3974                                  
  3975 0000324E 8A46FC                   mov al, byte [bp-4]
  3976 00003251 B400                     mov ah, 0
  3977 00003253 50                       push ax
  3978 00003254 E85F01                   call printhex8a
  3979 00003257 83C402                   add  sp, 2
  3980                                  
  3981                                  ;-13             i++;
  3982                                  
  3983 0000325A FF46FE                   inc  word [bp-2]
  3984                                  
  3985                                  ;-14         } while (i < OpPrintIndex);
  3986                                  
  3987 0000325D 8B46FE                   mov ax, [bp-2]
  3988 00003260 3B06[C501]               cmp ax, [OpPrintIndex]
  3989 00003264 0F8D0200                 jge @@printLine177
  3990 00003268 EBD2                     jmp @@printLine176
  3991                                  @@printLine177:
  3992                                  
  3993                                  ;-15         while (i < OPMAXLEN) {// fill rest with blank
  3994                                  
  3995                                  @@printLine178:
  3996 0000326A 8B46FE                   mov ax, [bp-2]
  3997 0000326D 83F805                   cmp ax, 5
  3998 00003270 0F8D0E00                 jge @@printLine179
  3999                                  
  4000                                  ;-16             prs("   ");
  4001                                  
  4002 00003274 68[AE32]                 push printLine_2
  4003 00003277 E89900                   call prs
  4004 0000327A 83C402                   add  sp, 2
  4005                                  
  4006                                  ;-17             i++;
  4007                                  
  4008 0000327D FF46FE                   inc  word [bp-2]
  4009                                  
  4010                                  ;-18         }
  4011                                  
  4012                                  
  4013                                  ;-19     }
  4014                                  
  4015 00003280 EBE8                     jmp @@printLine178
  4016                                  @@printLine179:
  4017                                  
  4018                                  ;-20     prc(PrintRA);
  4019                                  
  4020                                  @@printLine175:
  4021 00003282 A0[C901]                 mov al, byte [PrintRA]
  4022 00003285 B400                     mov ah, 0
  4023 00003287 50                       push ax
  4024 00003288 E82700                   call prc
  4025 0000328B 83C402                   add  sp, 2
  4026                                  
  4027                                  ;-21     prscomment(InputBuf);
  4028                                  
  4029 0000328E 8D06[4F00]               lea  ax, [InputBuf]
  4030 00003292 50                       push ax
  4031 00003293 E84F00                   call prscomment
  4032 00003296 83C402                   add  sp, 2
  4033                                  
  4034                                  ;-22 }
  4035                                  
  4036                                  
  4037                                  ;-23 int prc(unsigned char c) {//print char 
  4038 00003299 C9                       LEAVE
  4039 0000329A C3                       ret
  4040                                  ; ENDP
  4041 0000329B 5C6E00                  printLine_0 db "\n",0
  4042 0000329E 202020202020202020-     printLine_1 db "               ",0
  4043 000032A7 20202020202000     
  4044 000032AE 20202000                printLine_2 db "   ",0
  4045                                  
  4046                                  prc:  ; *** PROC ***
  4047                                  
  4048                                  ;-24     if (LIST) { 
  4049                                  
  4050                                  ;Function : prc, Number of local variables: 1
  4051                                  ;   # type sign width line used address name   list of local variables
  4052                                  ;  200 var unsg byte    23 NULL bp+4    c;
  4053 000032B2 C8000000                 ENTER  0,0
  4054 000032B6 A0[0E00]                 mov al, [LIST]
  4055 000032B9 08C0                     or  al, al
  4056 000032BB 0F841400                 je @@prc180
  4057                                  
  4058                                  ;-25         if ( _ c==10) {
  4059                                  
  4060 000032BF 807E040A                cmp byte [bp+4], 10
  4061 000032C3 0F850600                 jne @@prc181
  4062                                  
  4063                                  ;-26             ax=13; 
  4064                                  
  4065 000032C7 B80D00                   mov  ax, 13
  4066                                  
  4067                                  ;-27             writetty(); 
  4068                                  
  4069 000032CA E88610                   call writetty
  4070                                  
  4071                                  ;-28             }
  4072                                  
  4073                                  
  4074                                  ;-29         al=c; 
  4075                                  
  4076                                  @@prc181:
  4077 000032CD 8A4604                   mov  al, [bp+4]
  4078                                  
  4079                                  ;-30         writetty(); 
  4080                                  
  4081 000032D0 E88010                   call writetty
  4082                                  
  4083                                  ;-31         }
  4084                                  
  4085                                  
  4086                                  ;-32     fputcR(c,lst_fd); 
  4087                                  
  4088                                  @@prc180:
  4089 000032D3 FF36[9B01]               push word [lst_fd]
  4090 000032D7 8A4604                   mov al, byte [bp+4]
  4091 000032DA B400                     mov ah, 0
  4092 000032DC 50                       push ax
  4093 000032DD E83312                   call fputcR
  4094 000032E0 83C404                   add  sp, 4
  4095                                  
  4096                                  ;-33 }
  4097                                  
  4098                                  
  4099                                  ;-34 
  4100                                  
  4101                                  
  4102                                  ;-35 int prscomment(unsigned char *s) {
  4103 000032E3 C9                       LEAVE
  4104 000032E4 C3                       ret
  4105                                  ; ENDP
  4106                                  
  4107                                  prscomment:  ; *** PROC ***
  4108                                  
  4109                                  ;-36     unsigned char c;
  4110                                  
  4111                                  
  4112                                  ;-37     while (*s){
  4113                                  
  4114                                  ;Function : prscomment, Number of local variables: 2
  4115                                  ;   # type sign width line used address name   list of local variables
  4116                                  ;  200 ptr unsg byte    35 NULL bp+4    s
  4117                                  ;  201 var unsg byte    36 NULL bp-2    c;
  4118 000032E5 C8020000                 ENTER  2,0
  4119                                  @@prscomment182:
  4120 000032E9 8B5E04                   mov bx, [bp+4]
  4121 000032EC 8A07                     mov al, [bx]
  4122 000032EE B400                     mov ah, 0
  4123 000032F0 08C0                     or  al, al
  4124 000032F2 0F841B00                 je @@prscomment183
  4125                                  
  4126                                  ;-38         c=*s;
  4127                                  
  4128 000032F6 8B5E04                   mov bx, [bp+4]
  4129 000032F9 8A07                     mov al, [bx]
  4130 000032FB B400                     mov ah, 0
  4131 000032FD 8846FE                   mov byte [bp-2], al
  4132                                  
  4133                                  ;-39         prc(c);
  4134                                  
  4135 00003300 8A46FE                   mov al, byte [bp-2]
  4136 00003303 B400                     mov ah, 0
  4137 00003305 50                       push ax
  4138 00003306 E8A9FF                   call prc
  4139 00003309 83C402                   add  sp, 2
  4140                                  
  4141                                  ;-40         s++;
  4142                                  
  4143 0000330C FF4604                   inc  word [bp+4]
  4144                                  
  4145                                  ;-41     }
  4146                                  
  4147                                  
  4148                                  ;-42 }
  4149                                  
  4150 0000330F EBD8                     jmp @@prscomment182
  4151                                  @@prscomment183:
  4152                                  
  4153                                  ;-43 int prs(unsigned char *s) {
  4154 00003311 C9                       LEAVE
  4155 00003312 C3                       ret
  4156                                  ; ENDP
  4157                                  
  4158                                  prs:  ; *** PROC ***
  4159                                  
  4160                                  ;-44     unsigned char c; 
  4161                                  
  4162                                  
  4163                                  ;-45     int com; 
  4164                                  
  4165                                  
  4166                                  ;-46     com=0;
  4167                                  
  4168                                  ;Function : prs, Number of local variables: 3
  4169                                  ;   # type sign width line used address name   list of local variables
  4170                                  ;  200 ptr unsg byte    43 NULL bp+4    s
  4171                                  ;  201 var unsg byte    44 NULL bp-2    c
  4172                                  ;  202 var sign word    45 NULL bp-4    com;
  4173 00003313 C8040000                 ENTER  4,0
  4174 00003317 66B800000000             mov eax, 0
  4175 0000331D 8946FC                   mov word [bp-4], ax
  4176                                  
  4177                                  ;-47     while (*s) { 
  4178                                  
  4179                                  @@prs184:
  4180 00003320 8B5E04                   mov bx, [bp+4]
  4181 00003323 8A07                     mov al, [bx]
  4182 00003325 B400                     mov ah, 0
  4183 00003327 08C0                     or  al, al
  4184 00003329 0F848700                 je @@prs185
  4185                                  
  4186                                  ;-48         c=*s; 
  4187                                  
  4188 0000332D 8B5E04                   mov bx, [bp+4]
  4189 00003330 8A07                     mov al, [bx]
  4190 00003332 B400                     mov ah, 0
  4191 00003334 8846FE                   mov byte [bp-2], al
  4192                                  
  4193                                  ;-49         if (c==34) {
  4194                                  
  4195 00003337 8A46FE                   mov al, [bp-2]
  4196 0000333A 3C22                     cmp al, 34
  4197 0000333C 0F851E00                 jne @@prs186
  4198                                  
  4199                                  ;-50             if (com) com=0; 
  4200                                  
  4201 00003340 8B46FC                   mov ax, [bp-4]
  4202 00003343 08C0                     or  al, al
  4203 00003345 0F840C00                 je @@prs187
  4204 00003349 66B800000000             mov eax, 0
  4205 0000334F 8946FC                   mov word [bp-4], ax
  4206                                  
  4207                                  ;-51                 else com=1;  
  4208                                  
  4209 00003352 E90900                   jmp @@prs188
  4210                                  @@prs187:
  4211 00003355 66B801000000             mov eax, 1
  4212 0000335B 8946FC                   mov word [bp-4], ax
  4213                                  
  4214                                  ;-52         }
  4215                                  
  4216                                  @@prs188:
  4217                                  
  4218                                  ;-53         if (c==92) { 
  4219                                  
  4220                                  @@prs186:
  4221 0000335E 8A46FE                   mov al, [bp-2]
  4222 00003361 3C5C                     cmp al, 92
  4223 00003363 0F853B00                 jne @@prs189
  4224                                  
  4225                                  ;-54             if (com==0) { 
  4226                                  
  4227 00003367 8B46FC                   mov ax, [bp-4]
  4228 0000336A 83F800                   cmp ax, 0
  4229 0000336D 0F853100                 jne @@prs190
  4230                                  
  4231                                  ;-55                 s++; 
  4232                                  
  4233 00003371 FF4604                   inc  word [bp+4]
  4234                                  
  4235                                  ;-56                 c=*s;
  4236                                  
  4237 00003374 8B5E04                   mov bx, [bp+4]
  4238 00003377 8A07                     mov al, [bx]
  4239 00003379 B400                     mov ah, 0
  4240 0000337B 8846FE                   mov byte [bp-2], al
  4241                                  
  4242                                  ;-57                 if (c=='n') c=10; 
  4243                                  
  4244 0000337E 8A46FE                   mov al, [bp-2]
  4245 00003381 3C6E                     cmp al, 110
  4246 00003383 0F850900                 jne @@prs191
  4247 00003387 66B80A000000             mov eax, 10
  4248 0000338D 8846FE                   mov byte [bp-2], al
  4249                                  
  4250                                  ;-58                 if (c=='t') c= 9; 
  4251                                  
  4252                                  @@prs191:
  4253 00003390 8A46FE                   mov al, [bp-2]
  4254 00003393 3C74                     cmp al, 116
  4255 00003395 0F850900                 jne @@prs192
  4256 00003399 66B809000000             mov eax, 9
  4257 0000339F 8846FE                   mov byte [bp-2], al
  4258                                  
  4259                                  ;-59             } 
  4260                                  
  4261                                  @@prs192:
  4262                                  
  4263                                  ;-60         } 
  4264                                  
  4265                                  @@prs190:
  4266                                  
  4267                                  ;-61         prc(c); 
  4268                                  
  4269                                  @@prs189:
  4270 000033A2 8A46FE                   mov al, byte [bp-2]
  4271 000033A5 B400                     mov ah, 0
  4272 000033A7 50                       push ax
  4273 000033A8 E807FF                   call prc
  4274 000033AB 83C402                   add  sp, 2
  4275                                  
  4276                                  ;-62         s++;  
  4277                                  
  4278 000033AE FF4604                   inc  word [bp+4]
  4279                                  
  4280                                  ;-63     }
  4281                                  
  4282                                  
  4283                                  ;-64 }
  4284                                  
  4285 000033B1 E96CFF                   jmp @@prs184
  4286                                  @@prs185:
  4287                                  
  4288                                  ;-65 int printhex8a(unsigned char c) { 
  4289 000033B4 C9                       LEAVE
  4290 000033B5 C3                       ret
  4291                                  ; ENDP
  4292                                  
  4293                                  printhex8a:  ; *** PROC ***
  4294                                  
  4295                                  ;-66     unsigned char nib;
  4296                                  
  4297                                  
  4298                                  ;-67     nib = c >> 4; printhex4(nib);                    
  4299                                  
  4300                                  ;Function : printhex8a, Number of local variables: 2
  4301                                  ;   # type sign width line used address name   list of local variables
  4302                                  ;  200 var unsg byte    65 NULL bp+4    c
  4303                                  ;  201 var unsg byte    66 NULL bp-2    nib;
  4304 000033B6 C8020000                 ENTER  2,0
  4305 000033BA 8A4604                   mov al, [bp+4]
  4306 000033BD C0E804                   shr al, 4
  4307 000033C0 8846FE                   mov byte [bp-2], al
  4308 000033C3 8A46FE                   mov al, byte [bp-2]
  4309 000033C6 B400                     mov ah, 0
  4310 000033C8 50                       push ax
  4311 000033C9 E81900                   call printhex4
  4312 000033CC 83C402                   add  sp, 2
  4313                                  
  4314                                  ;-68     nib = c & 15; printhex4(nib);                    
  4315                                  
  4316 000033CF 8A4604                   mov al, [bp+4]
  4317 000033D2 240F                     and al, 15
  4318 000033D4 8846FE                   mov byte [bp-2], al
  4319 000033D7 8A46FE                   mov al, byte [bp-2]
  4320 000033DA B400                     mov ah, 0
  4321 000033DC 50                       push ax
  4322 000033DD E80500                   call printhex4
  4323 000033E0 83C402                   add  sp, 2
  4324                                  
  4325                                  ;-69 } 
  4326                                  
  4327                                  
  4328                                  ;-70 int printhex4(unsigned char c) {
  4329 000033E3 C9                       LEAVE
  4330 000033E4 C3                       ret
  4331                                  ; ENDP
  4332                                  
  4333                                  printhex4:  ; *** PROC ***
  4334                                  
  4335                                  ;-71     c += 48; 
  4336                                  
  4337                                  ;Function : printhex4, Number of local variables: 1
  4338                                  ;   # type sign width line used address name   list of local variables
  4339                                  ;  200 var unsg byte    70 NULL bp+4    c;
  4340 000033E5 C8000000                 ENTER  0,0
  4341 000033E9 80460430                 add  byte [bp+4], 48
  4342                                  
  4343                                  ;-72     if (c > 57) c += 7; 
  4344                                  
  4345 000033ED 8A4604                   mov al, [bp+4]
  4346 000033F0 3C39                     cmp al, 57
  4347 000033F2 0F8E0400                 jle @@printhex4193
  4348 000033F6 80460407                 add  byte [bp+4], 7
  4349                                  
  4350                                  ;-73     prc(c);      
  4351                                  
  4352                                  @@printhex4193:
  4353 000033FA 8A4604                   mov al, byte [bp+4]
  4354 000033FD B400                     mov ah, 0
  4355 000033FF 50                       push ax
  4356 00003400 E8AFFE                   call prc
  4357 00003403 83C402                   add  sp, 2
  4358                                  
  4359                                  ;-74 }
  4360                                  
  4361                                  
  4362                                  ;-75 int printhex16(unsigned int i) {
  4363 00003406 C9                       LEAVE
  4364 00003407 C3                       ret
  4365                                  ; ENDP
  4366                                  
  4367                                  printhex16:  ; *** PROC ***
  4368                                  
  4369                                  ;-76     unsigned int half;
  4370                                  
  4371                                  
  4372                                  ;-77     half = i >>  8; printhex8a(half); 
  4373                                  
  4374                                  ;Function : printhex16, Number of local variables: 2
  4375                                  ;   # type sign width line used address name   list of local variables
  4376                                  ;  200 var unsg word    75 NULL bp+4    i
  4377                                  ;  201 var unsg word    76 NULL bp-2    half;
  4378 00003408 C8020000                 ENTER  2,0
  4379 0000340C 8B4604                   mov ax, [bp+4]
  4380 0000340F C1E808                   shr ax, 8
  4381 00003412 8946FE                   mov word [bp-2], ax
  4382 00003415 FF76FE                   push word [bp-2]
  4383 00003418 E89BFF                   call printhex8a
  4384 0000341B 83C402                   add  sp, 2
  4385                                  
  4386                                  ;-78     half = i & 255; printhex8a(half);
  4387                                  
  4388 0000341E 8B4604                   mov ax, [bp+4]
  4389 00003421 25FF00                   and ax, 255
  4390 00003424 8946FE                   mov word [bp-2], ax
  4391 00003427 FF76FE                   push word [bp-2]
  4392 0000342A E889FF                   call printhex8a
  4393 0000342D 83C402                   add  sp, 2
  4394                                  
  4395                                  ;-79 }
  4396                                  
  4397                                  
  4398                                  ;-80 int printIntU(unsigned int n) { 
  4399 00003430 C9                       LEAVE
  4400 00003431 C3                       ret
  4401                                  ; ENDP
  4402                                  
  4403                                  printIntU:  ; *** PROC ***
  4404                                  
  4405                                  ;-81     unsigned int e;
  4406                                  
  4407                                  
  4408                                  ;-82     if ( _ n >= 10) {  
  4409                                  
  4410                                  ;Function : printIntU, Number of local variables: 2
  4411                                  ;   # type sign width line used address name   list of local variables
  4412                                  ;  200 var unsg word    80 NULL bp+4    n
  4413                                  ;  201 var unsg word    81 NULL bp-2    e;
  4414 00003432 C8020000                 ENTER  2,0
  4415 00003436 837E040A                cmp word [bp+4], 10 ;unsigned : 0
  4416 0000343A 0F821700                 jb  @@printIntU194
  4417                                  
  4418                                  ;-83         e=n/10; //DIV
  4419                                  
  4420 0000343E 8B4604                   mov ax, [bp+4]
  4421 00003441 BB0A00                   mov bx, 10
  4422 00003444 BA0000                   mov dx, 0
  4423 00003447 F7F3                     div bx
  4424 00003449 8946FE                   mov word [bp-2], ax
  4425                                  
  4426                                  ;-84         printIntU(e); 
  4427                                  
  4428 0000344C FF76FE                   push word [bp-2]
  4429 0000344F E8E0FF                   call printIntU
  4430 00003452 83C402                   add  sp, 2
  4431                                  
  4432                                  ;-85     }
  4433                                  
  4434                                  
  4435                                  ;-86     n = n % 10; //unsigned mod
  4436                                  
  4437                                  @@printIntU194:
  4438 00003455 8B4604                   mov ax, [bp+4]
  4439 00003458 BB0A00                   mov bx, 10
  4440 0000345B BA0000                   mov dx, 0
  4441 0000345E F7F3                     div bx
  4442 00003460 89D0                     mov ax, dx
  4443 00003462 894604                   mov word [bp+4], ax
  4444                                  
  4445                                  ;-87     n += '0'; 
  4446                                  
  4447 00003465 83460430                 add  word [bp+4], 48
  4448                                  
  4449                                  ;-88     prc(n);
  4450                                  
  4451 00003469 FF7604                   push word [bp+4]
  4452 0000346C E843FE                   call prc
  4453 0000346F 83C402                   add  sp, 2
  4454                                  
  4455                                  ;-89 }
  4456                                  
  4457                                  
  4458                                  ;-90 
  4459                                  
  4460                                  
  4461                                  ;-91 int error1(char *s) { 
  4462 00003472 C9                       LEAVE
  4463 00003473 C3                       ret
  4464                                  ; ENDP
  4465                                  
  4466                                  error1:  ; *** PROC ***
  4467                                  
  4468                                  ;-92     LIST=1; 
  4469                                  
  4470                                  ;Function : error1, Number of local variables: 1
  4471                                  ;   # type sign width line used address name   list of local variables
  4472                                  ;  200 ptr sign byte    91 NULL bp+4    s;
  4473 00003474 C8000000                 ENTER  0,0
  4474 00003478 66B801000000             mov eax, 1
  4475 0000347E A2[0E00]                 mov byte [LIST], al
  4476                                  
  4477                                  ;-93     ErrorCount++;
  4478                                  
  4479 00003481 FF06[A101]               inc  word [ErrorCount]
  4480                                  
  4481                                  ;-94     prs("\n;***** next line ERROR: "); 
  4482                                  
  4483 00003485 68[AD34]                 push error1_0
  4484 00003488 E888FE                   call prs
  4485 0000348B 83C402                   add  sp, 2
  4486                                  
  4487                                  ;-95     prs(s);
  4488                                  
  4489 0000348E FF7604                   push word [bp+4]
  4490 00003491 E87FFE                   call prs
  4491 00003494 83C402                   add  sp, 2
  4492                                  
  4493                                  ;-96     prs(", Symbol: "); 
  4494                                  
  4495 00003497 68[C834]                 push error1_1
  4496 0000349A E876FE                   call prs
  4497 0000349D 83C402                   add  sp, 2
  4498                                  
  4499                                  ;-97     prs(Symbol);
  4500                                  
  4501 000034A0 8D06[0F00]               lea  ax, [Symbol]
  4502 000034A4 50                       push ax
  4503 000034A5 E86BFE                   call prs
  4504 000034A8 83C402                   add  sp, 2
  4505                                  
  4506                                  ;-98 }
  4507                                  
  4508                                  
  4509                                  ;-99 int errorexit(char *s) { 
  4510 000034AB C9                       LEAVE
  4511 000034AC C3                       ret
  4512                                  ; ENDP
  4513 000034AD 5C6E3B2A2A2A2A2A20-     error1_0 db "\n;***** next line ERROR: ",0
  4514 000034B6 6E657874206C696E65-
  4515 000034BF 204552524F523A2000 
  4516 000034C8 2C2053796D626F6C3A-     error1_1 db ", Symbol: ",0
  4517 000034D1 2000               
  4518                                  
  4519                                  errorexit:  ; *** PROC ***
  4520                                  
  4521                                  ;-100     error1(s); 
  4522                                  
  4523                                  ;Function : errorexit, Number of local variables: 1
  4524                                  ;   # type sign width line used address name   list of local variables
  4525                                  ;  200 ptr sign byte    99 NULL bp+4    s;
  4526 000034D3 C8000000                 ENTER  0,0
  4527 000034D7 FF7604                   push word [bp+4]
  4528 000034DA E897FF                   call error1
  4529 000034DD 83C402                   add  sp, 2
  4530                                  
  4531                                  ;-101     end1(1);
  4532                                  
  4533 000034E0 6A01                     push 1
  4534 000034E2 E87E05                   call end1
  4535 000034E5 83C402                   add  sp, 2
  4536                                  
  4537                                  ;-102 }
  4538                                  
  4539                                  
  4540                                  ;-103 int allowederror() {error1("not allowed here"); }
  4541 000034E8 C9                       LEAVE
  4542 000034E9 C3                       ret
  4543                                  ; ENDP
  4544                                  
  4545                                  allowederror:  ; *** PROC ***
  4546 000034EA 68[F434]                 push allowederror_0
  4547 000034ED E884FF                   call error1
  4548 000034F0 83C402                   add  sp, 2
  4549                                  
  4550                                  ;-104 int addrerror()    {error1("address missing");} 
  4551                                  
  4552 000034F3 C3                       ret
  4553                                  ; ENDP
  4554 000034F4 6E6F7420616C6C6F77-     allowederror_0 db "not allowed here",0
  4555 000034FD 6564206865726500   
  4556                                  
  4557                                  addrerror:  ; *** PROC ***
  4558 00003505 68[0F35]                 push addrerror_0
  4559 00003508 E869FF                   call error1
  4560 0000350B 83C402                   add  sp, 2
  4561                                  
  4562                                  ;-105 int immeerror()    {error1("immediate not allowed here");}
  4563                                  
  4564 0000350E C3                       ret
  4565                                  ; ENDP
  4566 0000350F 61646472657373206D-     addrerror_0 db "address missing",0
  4567 00003518 697373696E6700     
  4568                                  
  4569                                  immeerror:  ; *** PROC ***
  4570 0000351F 68[2935]                 push immeerror_0
  4571 00003522 E84FFF                   call error1
  4572 00003525 83C402                   add  sp, 2
  4573                                  
  4574                                  ;-106 int implerror()    {error1("not implemented");}
  4575                                  
  4576 00003528 C3                       ret
  4577                                  ; ENDP
  4578 00003529 696D6D656469617465-     immeerror_0 db "immediate not allowed here",0
  4579 00003532 206E6F7420616C6C6F-
  4580 0000353B 776564206865726500 
  4581                                  
  4582                                  implerror:  ; *** PROC ***
  4583 00003544 68[4E35]                 push implerror_0
  4584 00003547 E82AFF                   call error1
  4585 0000354A 83C402                   add  sp, 2
  4586                                  
  4587                                  ;-107 int indexerror()   {error1("invalid index register");}
  4588                                  
  4589 0000354D C3                       ret
  4590                                  ; ENDP
  4591 0000354E 6E6F7420696D706C65-     implerror_0 db "not implemented",0
  4592 00003557 6D656E74656400     
  4593                                  
  4594                                  indexerror:  ; *** PROC ***
  4595 0000355E 68[6835]                 push indexerror_0
  4596 00003561 E810FF                   call error1
  4597 00003564 83C402                   add  sp, 2
  4598                                  
  4599                                  ;-108 int invaloperror() {error1("invalid or no operands");}
  4600                                  
  4601 00003567 C3                       ret
  4602                                  ; ENDP
  4603 00003568 696E76616C69642069-     indexerror_0 db "invalid index register",0
  4604 00003571 6E6465782072656769-
  4605 0000357A 7374657200         
  4606                                  
  4607                                  invaloperror:  ; *** PROC ***
  4608 0000357F 68[8935]                 push invaloperror_0
  4609 00003582 E8EFFE                   call error1
  4610 00003585 83C402                   add  sp, 2
  4611                                  
  4612                                  ;-109 int numbererror()  {error1("number expected");}
  4613                                  
  4614 00003588 C3                       ret
  4615                                  ; ENDP
  4616 00003589 696E76616C6964206F-     invaloperror_0 db "invalid or no operands",0
  4617 00003592 72206E6F206F706572-
  4618 0000359B 616E647300         
  4619                                  
  4620                                  numbererror:  ; *** PROC ***
  4621 000035A0 68[AA35]                 push numbererror_0
  4622 000035A3 E8CEFE                   call error1
  4623 000035A6 83C402                   add  sp, 2
  4624                                  
  4625                                  ;-110 int regmemerror()  {error1("only register or memory allowed");}
  4626                                  
  4627 000035A9 C3                       ret
  4628                                  ; ENDP
  4629 000035AA 6E756D626572206578-     numbererror_0 db "number expected",0
  4630 000035B3 70656374656400     
  4631                                  
  4632                                  regmemerror:  ; *** PROC ***
  4633 000035BA 68[C435]                 push regmemerror_0
  4634 000035BD E8B4FE                   call error1
  4635 000035C0 83C402                   add  sp, 2
  4636                                  
  4637                                  ;-111 int reg16error()   {error1("only reg16, no segreg allowed");}
  4638                                  
  4639 000035C3 C3                       ret
  4640                                  ; ENDP
  4641 000035C4 6F6E6C792072656769-     regmemerror_0 db "only register or memory allowed",0
  4642 000035CD 73746572206F72206D-
  4643 000035D6 656D6F727920616C6C-
  4644 000035DF 6F77656400         
  4645                                  
  4646                                  reg16error:  ; *** PROC ***
  4647 000035E4 68[EE35]                 push reg16error_0
  4648 000035E7 E88AFE                   call error1
  4649 000035EA 83C402                   add  sp, 2
  4650                                  
  4651                                  ;-112 int segregerror()  {error1("segment register not allowed");}
  4652                                  
  4653 000035ED C3                       ret
  4654                                  ; ENDP
  4655 000035EE 6F6E6C792072656731-     reg16error_0 db "only reg16, no segreg allowed",0
  4656 000035F7 362C206E6F20736567-
  4657 00003600 72656720616C6C6F77-
  4658 00003609 656400             
  4659                                  
  4660                                  segregerror:  ; *** PROC ***
  4661 0000360C 68[1636]                 push segregerror_0
  4662 0000360F E862FE                   call error1
  4663 00003612 83C402                   add  sp, 2
  4664                                  
  4665                                  ;-113 int syntaxerror()  {error1("syntax");}
  4666                                  
  4667 00003615 C3                       ret
  4668                                  ; ENDP
  4669 00003616 7365676D656E742072-     segregerror_0 db "segment register not allowed",0
  4670 0000361F 65676973746572206E-
  4671 00003628 6F7420616C6C6F7765-
  4672 00003631 6400               
  4673                                  
  4674                                  syntaxerror:  ; *** PROC ***
  4675 00003633 68[3D36]                 push syntaxerror_0
  4676 00003636 E83BFE                   call error1
  4677 00003639 83C402                   add  sp, 2
  4678                                  
  4679                                  ;-114          
  4680                                  
  4681                                  
  4682                                  ;-115 int addrexit()     {errorexit("illegal address");}
  4683                                  
  4684 0000363C C3                       ret
  4685                                  ; ENDP
  4686 0000363D 73796E74617800          syntaxerror_0 db "syntax",0
  4687                                  
  4688                                  addrexit:  ; *** PROC ***
  4689 00003644 68[4E36]                 push addrexit_0
  4690 00003647 E889FE                   call errorexit
  4691 0000364A 83C402                   add  sp, 2
  4692                                  
  4693                                  ;-116 int internexit()   {errorexit("intern compiler error");}
  4694                                  
  4695 0000364D C3                       ret
  4696                                  ; ENDP
  4697 0000364E 696C6C6567616C2061-     addrexit_0 db "illegal address",0
  4698 00003657 64647265737300     
  4699                                  
  4700                                  internexit:  ; *** PROC ***
  4701 0000365E 68[6836]                 push internexit_0
  4702 00003661 E86FFE                   call errorexit
  4703 00003664 83C402                   add  sp, 2
  4704 00003667 C3                       ret
  4705                                  ; ENDP
  4706 00003668 696E7465726E20636F-     internexit_0 db "intern compiler error",0
  4707 00003671 6D70696C6572206572-
  4708 0000367A 726F7200           
  4709                                  ;Back to main program: AS.C
  4710                                  
  4711                                  ;-8 #include "MAIN.C"
  4712                                  
  4713                                  ;Use include file: MAIN.C
  4714                                  
  4715                                  ;-1 int main() {
  4716                                  
  4717                                  
  4718                                  main:  ; *** PROC ***
  4719                                  
  4720                                  ;-2     getarg(); 
  4721                                  
  4722 0000367E E80D00                   call getarg
  4723                                  
  4724                                  ;-3     parse(); 
  4725                                  
  4726 00003681 E82DEE                   call parse
  4727                                  
  4728                                  ;-4     fixJmpCall();
  4729                                  
  4730 00003684 E85F02                   call fixJmpCall
  4731                                  
  4732                                  ;-5     epilog(); 
  4733                                  
  4734 00003687 E80503                   call epilog
  4735                                  
  4736                                  ;-6     end1();
  4737                                  
  4738 0000368A E8D603                   call end1
  4739                                  
  4740                                  ;-7 }
  4741                                  
  4742                                  
  4743                                  ;-8 
  4744                                  
  4745                                  
  4746                                  ;-9 int getarg() { 
  4747                                  
  4748 0000368D C3                       ret
  4749                                  ; ENDP
  4750                                  
  4751                                  getarg:  ; *** PROC ***
  4752                                  
  4753                                  ;-10     int arglen1; int i; char *c;
  4754                                  
  4755                                  
  4756                                  ;-11     arglen1=*arglen;
  4757                                  
  4758                                  ;Function : getarg, Number of local variables: 3
  4759                                  ;   # type sign width line used address name   list of local variables
  4760                                  ;  200 var sign word    10 NULL bp-2    arglen1
  4761                                  ;  201 var sign word    10 NULL bp-4    i
  4762                                  ;  202 ptr sign byte    10 NULL bp-6    c;
  4763 0000368E C8060000                 ENTER  6,0
  4764 00003692 8B1E[021C]               mov bx, [arglen]
  4765 00003696 8A07                     mov al, [bx]
  4766 00003698 B400                     mov ah, 0
  4767 0000369A 8946FE                   mov word [bp-2], ax
  4768                                  
  4769                                  ;-12     if (arglen1==0) {
  4770                                  
  4771 0000369D 8B46FE                   mov ax, [bp-2]
  4772 000036A0 83F800                   cmp ax, 0
  4773 000036A3 0F851C00                 jne @@getarg195
  4774                                  
  4775                                  ;-13         cputs(Version1);
  4776                                  
  4777 000036A7 8D06[0300]               lea  ax, [Version1]
  4778 000036AB 50                       push ax
  4779 000036AC E8AC0C                   call cputs
  4780 000036AF 83C402                   add  sp, 2
  4781                                  
  4782                                  ;-14         cputs(", Usage: AS.COM filename [w/o .S] : ");
  4783                                  
  4784 000036B2 68[5338]                 push getarg_0
  4785 000036B5 E8A30C                   call cputs
  4786 000036B8 83C402                   add  sp, 2
  4787                                  
  4788                                  ;-15         exitR(3);
  4789                                  
  4790 000036BB 6A03                     push 3
  4791 000036BD E8760E                   call exitR
  4792 000036C0 83C402                   add  sp, 2
  4793                                  
  4794                                  ;-16     }
  4795                                  
  4796                                  
  4797                                  ;-17     i=arglen1+129; 
  4798                                  
  4799                                  @@getarg195:
  4800 000036C3 8B46FE                   mov ax, [bp-2]
  4801 000036C6 058100                   add ax, 129
  4802 000036C9 8946FC                   mov word [bp-4], ax
  4803                                  
  4804                                  ;-18     *i=0;  
  4805                                  
  4806 000036CC 66B800000000             mov eax, 0
  4807 000036D2 8B5EFC                   mov  bx, [bp-4]
  4808 000036D5 8907                     mov  [bx], ax
  4809                                  
  4810                                  ;-19     arglen1--;
  4811                                  
  4812 000036D7 FF4EFE                   dec  word [bp-2]
  4813                                  
  4814                                  ;-20     toupper(argv);
  4815                                  
  4816 000036DA FF36[041C]               push word [argv]
  4817 000036DE E8A80C                   call toupper
  4818 000036E1 83C402                   add  sp, 2
  4819                                  
  4820                                  ;-21   
  4821                                  
  4822                                  
  4823                                  ;-22     strcpy(namein, argv); strcat1(namein, ".S");
  4824                                  
  4825 000036E4 FF36[041C]               push word [argv]
  4826 000036E8 8D06[D000]               lea  ax, [namein]
  4827 000036EC 50                       push ax
  4828 000036ED E8070D                   call strcpy
  4829 000036F0 83C404                   add  sp, 4
  4830 000036F3 68[7838]                 push getarg_1
  4831 000036F6 8D06[D000]               lea  ax, [namein]
  4832 000036FA 50                       push ax
  4833 000036FB E8BA0D                   call strcat1
  4834 000036FE 83C404                   add  sp, 4
  4835                                  
  4836                                  ;-23     strcpy(namelst,argv); strcat1(namelst,".LST");
  4837                                  
  4838 00003701 FF36[041C]               push word [argv]
  4839 00003705 8D06[1301]               lea  ax, [namelst]
  4840 00003709 50                       push ax
  4841 0000370A E8EA0C                   call strcpy
  4842 0000370D 83C404                   add  sp, 4
  4843 00003710 68[7B38]                 push getarg_2
  4844 00003713 8D06[1301]               lea  ax, [namelst]
  4845 00003717 50                       push ax
  4846 00003718 E89D0D                   call strcat1
  4847 0000371B 83C404                   add  sp, 4
  4848                                  
  4849                                  ;-24     strcpy(namebin,argv); strcat1(namebin,".COM");
  4850                                  
  4851 0000371E FF36[041C]               push word [argv]
  4852 00003722 8D06[5601]               lea  ax, [namebin]
  4853 00003726 50                       push ax
  4854 00003727 E8CD0C                   call strcpy
  4855 0000372A 83C404                   add  sp, 4
  4856 0000372D 68[8038]                 push getarg_3
  4857 00003730 8D06[5601]               lea  ax, [namebin]
  4858 00003734 50                       push ax
  4859 00003735 E8800D                   call strcat1
  4860 00003738 83C404                   add  sp, 4
  4861                                  
  4862                                  ;-25 
  4863                                  
  4864                                  
  4865                                  ;-26     LIST=1; DOS_ERR=0; PC=0; ErrorCount=0;
  4866                                  
  4867 0000373B 66B801000000             mov eax, 1
  4868 00003741 A2[0E00]                 mov byte [LIST], al
  4869 00003744 66B800000000             mov eax, 0
  4870 0000374A A3[9F01]                 mov word [DOS_ERR], ax
  4871 0000374D 66B800000000             mov eax, 0
  4872 00003753 A3[A601]                 mov word [PC], ax
  4873 00003756 66B800000000             mov eax, 0
  4874 0000375C A3[A101]                 mov word [ErrorCount], ax
  4875                                  
  4876                                  ;-27   
  4877                                  
  4878                                  
  4879                                  ;-28     asm_fd=openR (namein);
  4880                                  
  4881 0000375F 8D06[D000]               lea  ax, [namein]
  4882 00003763 50                       push ax
  4883 00003764 E8760D                   call openR
  4884 00003767 83C402                   add  sp, 2
  4885 0000376A A3[9901]                 mov word [asm_fd], ax
  4886                                  
  4887                                  ;-29     if(DOS_ERR){cputs("Source file missing: ") ;cputs(namein );exitR(1);}
  4888                                  
  4889 0000376D A1[9F01]                 mov ax, [DOS_ERR]
  4890 00003770 08C0                     or  al, al
  4891 00003772 0F841C00                 je @@getarg196
  4892 00003776 68[8538]                 push getarg_4
  4893 00003779 E8DF0B                   call cputs
  4894 0000377C 83C402                   add  sp, 2
  4895 0000377F 8D06[D000]               lea  ax, [namein]
  4896 00003783 50                       push ax
  4897 00003784 E8D40B                   call cputs
  4898 00003787 83C402                   add  sp, 2
  4899 0000378A 6A01                     push 1
  4900 0000378C E8A70D                   call exitR
  4901 0000378F 83C402                   add  sp, 2
  4902                                  
  4903                                  ;-30     lst_fd=creatR(namelst);
  4904                                  
  4905                                  @@getarg196:
  4906 00003792 8D06[1301]               lea  ax, [namelst]
  4907 00003796 50                       push ax
  4908 00003797 E8520D                   call creatR
  4909 0000379A 83C402                   add  sp, 2
  4910 0000379D A3[9B01]                 mov word [lst_fd], ax
  4911                                  
  4912                                  ;-31     if(DOS_ERR){cputs("List file not create: ");cputs(namelst);exitR(2);}
  4913                                  
  4914 000037A0 A1[9F01]                 mov ax, [DOS_ERR]
  4915 000037A3 08C0                     or  al, al
  4916 000037A5 0F841C00                 je @@getarg197
  4917 000037A9 68[9B38]                 push getarg_5
  4918 000037AC E8AC0B                   call cputs
  4919 000037AF 83C402                   add  sp, 2
  4920 000037B2 8D06[1301]               lea  ax, [namelst]
  4921 000037B6 50                       push ax
  4922 000037B7 E8A10B                   call cputs
  4923 000037BA 83C402                   add  sp, 2
  4924 000037BD 6A02                     push 2
  4925 000037BF E8740D                   call exitR
  4926 000037C2 83C402                   add  sp, 2
  4927                                  
  4928                                  ;-32     bin_fd=creatR(namebin);
  4929                                  
  4930                                  @@getarg197:
  4931 000037C5 8D06[5601]               lea  ax, [namebin]
  4932 000037C9 50                       push ax
  4933 000037CA E81F0D                   call creatR
  4934 000037CD 83C402                   add  sp, 2
  4935 000037D0 A3[9D01]                 mov word [bin_fd], ax
  4936                                  
  4937                                  ;-33     if(DOS_ERR){cputs("COM file not create: ") ;cputs(namebin);exitR(2);}
  4938                                  
  4939 000037D3 A1[9F01]                 mov ax, [DOS_ERR]
  4940 000037D6 08C0                     or  al, al
  4941 000037D8 0F841C00                 je @@getarg198
  4942 000037DC 68[B238]                 push getarg_6
  4943 000037DF E8790B                   call cputs
  4944 000037E2 83C402                   add  sp, 2
  4945 000037E5 8D06[5601]               lea  ax, [namebin]
  4946 000037E9 50                       push ax
  4947 000037EA E86E0B                   call cputs
  4948 000037ED 83C402                   add  sp, 2
  4949 000037F0 6A02                     push 2
  4950 000037F2 E8410D                   call exitR
  4951 000037F5 83C402                   add  sp, 2
  4952                                  
  4953                                  ;-34   
  4954                                  
  4955                                  
  4956                                  ;-35     prs(";"); 
  4957                                  
  4958                                  @@getarg198:
  4959 000037F8 68[C838]                 push getarg_7
  4960 000037FB E815FB                   call prs
  4961 000037FE 83C402                   add  sp, 2
  4962                                  
  4963                                  ;-36     prs(Version1);
  4964                                  
  4965 00003801 8D06[0300]               lea  ax, [Version1]
  4966 00003805 50                       push ax
  4967 00003806 E80AFB                   call prs
  4968 00003809 83C402                   add  sp, 2
  4969                                  
  4970                                  ;-37     prs(", Source: "); prs(namein);  
  4971                                  
  4972 0000380C 68[CA38]                 push getarg_8
  4973 0000380F E801FB                   call prs
  4974 00003812 83C402                   add  sp, 2
  4975 00003815 8D06[D000]               lea  ax, [namein]
  4976 00003819 50                       push ax
  4977 0000381A E8F6FA                   call prs
  4978 0000381D 83C402                   add  sp, 2
  4979                                  
  4980                                  ;-38     prs(", Output: "); prs(namelst);
  4981                                  
  4982 00003820 68[D538]                 push getarg_9
  4983 00003823 E8EDFA                   call prs
  4984 00003826 83C402                   add  sp, 2
  4985 00003829 8D06[1301]               lea  ax, [namelst]
  4986 0000382D 50                       push ax
  4987 0000382E E8E2FA                   call prs
  4988 00003831 83C402                   add  sp, 2
  4989                                  
  4990                                  ;-39     prs(", "); prs(namebin);
  4991                                  
  4992 00003834 68[E038]                 push getarg_10
  4993 00003837 E8D9FA                   call prs
  4994 0000383A 83C402                   add  sp, 2
  4995 0000383D 8D06[5601]               lea  ax, [namebin]
  4996 00003841 50                       push ax
  4997 00003842 E8CEFA                   call prs
  4998 00003845 83C402                   add  sp, 2
  4999                                  
  5000                                  ;-40     prs("\n");
  5001                                  
  5002 00003848 68[E338]                 push getarg_11
  5003 0000384B E8C5FA                   call prs
  5004 0000384E 83C402                   add  sp, 2
  5005                                  
  5006                                  ;-41 }
  5007                                  
  5008                                  
  5009                                  ;-42 
  5010                                  
  5011                                  
  5012                                  ;-43 int fixJmpCall() {
  5013 00003851 C9                       LEAVE
  5014 00003852 C3                       ret
  5015                                  ; ENDP
  5016 00003853 2C2055736167653A20-     getarg_0 db ", Usage: AS.COM filename [w/o .S] : ",0
  5017 0000385C 41532E434F4D206669-
  5018 00003865 6C656E616D65205B77-
  5019 0000386E 2F6F202E535D203A20-
  5020 00003877 00                 
  5021 00003878 2E5300                  getarg_1 db ".S",0
  5022 0000387B 2E4C535400              getarg_2 db ".LST",0
  5023 00003880 2E434F4D00              getarg_3 db ".COM",0
  5024 00003885 536F75726365206669-     getarg_4 db "Source file missing: ",0
  5025 0000388E 6C65206D697373696E-
  5026 00003897 673A2000           
  5027 0000389B 4C6973742066696C65-     getarg_5 db "List file not create: ",0
  5028 000038A4 206E6F742063726561-
  5029 000038AD 74653A2000         
  5030 000038B2 434F4D2066696C6520-     getarg_6 db "COM file not create: ",0
  5031 000038BB 6E6F74206372656174-
  5032 000038C4 653A2000           
  5033 000038C8 3B00                    getarg_7 db ";",0
  5034 000038CA 2C20536F757263653A-     getarg_8 db ", Source: ",0
  5035 000038D3 2000               
  5036 000038D5 2C204F75747075743A-     getarg_9 db ", Output: ",0
  5037 000038DE 2000               
  5038 000038E0 2C2000                  getarg_10 db ", ",0
  5039 000038E3 5C6E00                  getarg_11 db "\n",0
  5040                                  
  5041                                  fixJmpCall:  ; *** PROC ***
  5042                                  
  5043                                  ;-44     int i;  unsigned int hex;  char *p;
  5044                                  
  5045                                  
  5046                                  ;-45     i=0;     
  5047                                  
  5048                                  ;Function : fixJmpCall, Number of local variables: 3
  5049                                  ;   # type sign width line used address name   list of local variables
  5050                                  ;  200 var sign word    44 NULL bp-2    i
  5051                                  ;  201 var unsg word    44 NULL bp-4    hex
  5052                                  ;  202 ptr sign byte    44 NULL bp-6    p;
  5053 000038E6 C8060000                 ENTER  6,0
  5054 000038EA 66B800000000             mov eax, 0
  5055 000038F0 8946FE                   mov word [bp-2], ax
  5056                                  
  5057                                  ;-46     prs("\n;END open jmp/call: "); 
  5058                                  
  5059 000038F3 68[7839]                 push fixJmpCall_0
  5060 000038F6 E81AFA                   call prs
  5061 000038F9 83C402                   add  sp, 2
  5062                                  
  5063                                  ;-47     printIntU(JmpCallMaxIx);      
  5064                                  
  5065 000038FC FF36[2E14]               push word [JmpCallMaxIx]
  5066 00003900 E82FFB                   call printIntU
  5067 00003903 83C402                   add  sp, 2
  5068                                  
  5069                                  ;-48     p = &JmpCallNames;
  5070                                  
  5071 00003906 B8[8006]                 mov ax, JmpCallNames
  5072 00003909 8946FA                   mov word [bp-6], ax
  5073                                  
  5074                                  ;-49     while (i <= JmpCallMaxIx) {
  5075                                  
  5076                                  @@fixJmpCall199:
  5077 0000390C 8B46FE                   mov ax, [bp-2]
  5078 0000390F 3B06[2E14]               cmp ax, [JmpCallMaxIx]
  5079 00003913 0F8F5F00                 jg  @@fixJmpCall200
  5080                                  
  5081                                  ;-50         strcpy(Symbol, p);
  5082                                  
  5083 00003917 FF76FA                   push word [bp-6]
  5084 0000391A 8D06[0F00]               lea  ax, [Symbol]
  5085 0000391E 50                       push ax
  5086 0000391F E8D50A                   call strcpy
  5087 00003922 83C404                   add  sp, 4
  5088                                  
  5089                                  ;-51         p = strlen(Symbol) + p;
  5090                                  
  5091 00003925 8D06[0F00]               lea  ax, [Symbol]
  5092 00003929 50                       push ax
  5093 0000392A E89F0A                   call strlen
  5094 0000392D 83C402                   add  sp, 2
  5095 00003930 0346FA                   add ax, [bp-6]
  5096 00003933 8946FA                   mov word [bp-6], ax
  5097                                  
  5098                                  ;-52         p++;
  5099                                  
  5100 00003936 FF46FA                   inc  word [bp-6]
  5101                                  
  5102                                  ;-53         prc(' '); 
  5103                                  
  5104 00003939 6A20                     push 32
  5105 0000393B E874F9                   call prc
  5106 0000393E 83C402                   add  sp, 2
  5107                                  
  5108                                  ;-54         prs(Symbol);
  5109                                  
  5110 00003941 8D06[0F00]               lea  ax, [Symbol]
  5111 00003945 50                       push ax
  5112 00003946 E8CAF9                   call prs
  5113 00003949 83C402                   add  sp, 2
  5114                                  
  5115                                  ;-55         prc('[');  
  5116                                  
  5117 0000394C 6A5B                     push 91
  5118 0000394E E861F9                   call prc
  5119 00003951 83C402                   add  sp, 2
  5120                                  
  5121                                  ;-56         hex = JmpCallAddr[i];
  5122                                  
  5123 00003954 8B5EFE                   mov bx, [bp-2]
  5124 00003957 D1E3                     shl bx, 1
  5125 00003959 8B87[520E]               mov ax, [JmpCallAddr + bx]
  5126 0000395D 8946FC                   mov word [bp-4], ax
  5127                                  
  5128                                  ;-57         printhex16(hex);
  5129                                  
  5130 00003960 FF76FC                   push word [bp-4]
  5131 00003963 E8A2FA                   call printhex16
  5132 00003966 83C402                   add  sp, 2
  5133                                  
  5134                                  ;-58         prc(']');
  5135                                  
  5136 00003969 6A5D                     push 93
  5137 0000396B E844F9                   call prc
  5138 0000396E 83C402                   add  sp, 2
  5139                                  
  5140                                  ;-59             
  5141                                  
  5142                                  
  5143                                  ;-60             
  5144                                  
  5145                                  
  5146                                  ;-61         i++;
  5147                                  
  5148 00003971 FF46FE                   inc  word [bp-2]
  5149                                  
  5150                                  ;-62     }
  5151                                  
  5152                                  
  5153                                  ;-63 }
  5154                                  
  5155 00003974 EB96                     jmp @@fixJmpCall199
  5156                                  @@fixJmpCall200:
  5157                                  
  5158                                  ;-64 
  5159                                  
  5160                                  
  5161                                  ;-65 int epilog() { 
  5162 00003976 C9                       LEAVE
  5163 00003977 C3                       ret
  5164                                  ; ENDP
  5165 00003978 5C6E3B454E44206F70-     fixJmpCall_0 db "\n;END open jmp/call: ",0
  5166 00003981 656E206A6D702F6361-
  5167 0000398A 6C6C3A2000         
  5168                                  
  5169                                  epilog:  ; *** PROC ***
  5170                                  
  5171                                  ;-66     unsigned int i; char c;
  5172                                  
  5173                                  
  5174                                  ;-67     prs("\, Errors: "); 
  5175                                  
  5176                                  ;Function : epilog, Number of local variables: 2
  5177                                  ;   # type sign width line used address name   list of local variables
  5178                                  ;  200 var unsg word    66 NULL bp-2    i
  5179                                  ;  201 var sign byte    66 NULL bp-4    c;
  5180 0000398F C8040000                 ENTER  4,0
  5181 00003993 68[313A]                 push epilog_0
  5182 00003996 E87AF9                   call prs
  5183 00003999 83C402                   add  sp, 2
  5184                                  
  5185                                  ;-68     printIntU(ErrorCount);
  5186                                  
  5187 0000399C FF36[A101]               push word [ErrorCount]
  5188 000039A0 E88FFA                   call printIntU
  5189 000039A3 83C402                   add  sp, 2
  5190                                  
  5191                                  ;-69     if (ErrorCount) prs(" ***ERROR*** ");
  5192                                  
  5193 000039A6 A1[A101]                 mov ax, [ErrorCount]
  5194 000039A9 08C0                     or  al, al
  5195 000039AB 0F840900                 je @@epilog201
  5196 000039AF 68[3D3A]                 push epilog_1
  5197 000039B2 E85EF9                   call prs
  5198 000039B5 83C402                   add  sp, 2
  5199                                  
  5200                                  ;-70     prs(", Output: "); 
  5201                                  
  5202                                  @@epilog201:
  5203 000039B8 68[4B3A]                 push epilog_2
  5204 000039BB E855F9                   call prs
  5205 000039BE 83C402                   add  sp, 2
  5206                                  
  5207                                  ;-71     prs(namelst);
  5208                                  
  5209 000039C1 8D06[1301]               lea  ax, [namelst]
  5210 000039C5 50                       push ax
  5211 000039C6 E84AF9                   call prs
  5212 000039C9 83C402                   add  sp, 2
  5213                                  
  5214                                  ;-72     prs(", ");
  5215                                  
  5216 000039CC 68[563A]                 push epilog_3
  5217 000039CF E841F9                   call prs
  5218 000039D2 83C402                   add  sp, 2
  5219                                  
  5220                                  ;-73     prs(namebin); 
  5221                                  
  5222 000039D5 8D06[5601]               lea  ax, [namebin]
  5223 000039D9 50                       push ax
  5224 000039DA E836F9                   call prs
  5225 000039DD 83C402                   add  sp, 2
  5226                                  
  5227                                  ;-74     prs("= ");
  5228                                  
  5229 000039E0 68[593A]                 push epilog_4
  5230 000039E3 E82DF9                   call prs
  5231 000039E6 83C402                   add  sp, 2
  5232                                  
  5233                                  ;-75     printIntU(BinLen); 
  5234                                  
  5235 000039E9 FF36[001C]               push word [BinLen]
  5236 000039ED E842FA                   call printIntU
  5237 000039F0 83C402                   add  sp, 2
  5238                                  
  5239                                  ;-76     prs(" bytes");
  5240                                  
  5241 000039F3 68[5C3A]                 push epilog_5
  5242 000039F6 E81AF9                   call prs
  5243 000039F9 83C402                   add  sp, 2
  5244                                  
  5245                                  ;-77 
  5246                                  
  5247                                  
  5248                                  ;-78     i=0;
  5249                                  
  5250 000039FC 66B800000000             mov eax, 0
  5251 00003A02 8946FE                   mov word [bp-2], ax
  5252                                  
  5253                                  ;-79     do {
  5254                                  
  5255                                  @@epilog202:
  5256                                  
  5257                                  ;-80         c = FileBin[i];
  5258                                  
  5259 00003A05 8B5EFE                   mov bx, [bp-2]
  5260 00003A08 8A87[3014]               mov al, [FileBin + bx]
  5261 00003A0C 8846FC                   mov byte [bp-4], al
  5262                                  
  5263                                  ;-81         fputcR(c, bin_fd);
  5264                                  
  5265 00003A0F FF36[9D01]               push word [bin_fd]
  5266 00003A13 8A46FC                   mov al, byte [bp-4]
  5267 00003A16 B400                     mov ah, 0
  5268 00003A18 50                       push ax
  5269 00003A19 E8F70A                   call fputcR
  5270 00003A1C 83C404                   add  sp, 4
  5271                                  
  5272                                  ;-82         i++;
  5273                                  
  5274 00003A1F FF46FE                   inc  word [bp-2]
  5275                                  
  5276                                  ;-83     } while (i < BinLen);
  5277                                  
  5278 00003A22 8B46FE                   mov ax, [bp-2]
  5279 00003A25 3B06[001C]               cmp ax, [BinLen]
  5280 00003A29 0F8D0200                 jge @@epilog203
  5281 00003A2D EBD6                     jmp @@epilog202
  5282                                  @@epilog203:
  5283                                  
  5284                                  ;-84 }
  5285                                  
  5286                                  
  5287                                  ;-85 
  5288                                  
  5289                                  
  5290                                  ;-86 int end1(int n) {
  5291 00003A2F C9                       LEAVE
  5292 00003A30 C3                       ret
  5293                                  ; ENDP
  5294 00003A31 5C2C204572726F7273-     epilog_0 db "\, Errors: ",0
  5295 00003A3A 3A2000             
  5296 00003A3D 202A2A2A4552524F52-     epilog_1 db " ***ERROR*** ",0
  5297 00003A46 2A2A2A2000         
  5298 00003A4B 2C204F75747075743A-     epilog_2 db ", Output: ",0
  5299 00003A54 2000               
  5300 00003A56 2C2000                  epilog_3 db ", ",0
  5301 00003A59 3D2000                  epilog_4 db "= ",0
  5302 00003A5C 20627974657300          epilog_5 db " bytes",0
  5303                                  
  5304                                  end1:  ; *** PROC ***
  5305                                  
  5306                                  ;-87     fcloseR(asm_fd);
  5307                                  
  5308                                  ;Function : end1, Number of local variables: 1
  5309                                  ;   # type sign width line used address name   list of local variables
  5310                                  ;  200 var sign word    86 NULL bp+4    n;
  5311 00003A63 C8000000                 ENTER  0,0
  5312 00003A67 FF36[9901]               push word [asm_fd]
  5313 00003A6B E8BA0A                   call fcloseR
  5314 00003A6E 83C402                   add  sp, 2
  5315                                  
  5316                                  ;-88     fcloseR(lst_fd);
  5317                                  
  5318 00003A71 FF36[9B01]               push word [lst_fd]
  5319 00003A75 E8B00A                   call fcloseR
  5320 00003A78 83C402                   add  sp, 2
  5321                                  
  5322                                  ;-89     fcloseR(bin_fd);
  5323                                  
  5324 00003A7B FF36[9D01]               push word [bin_fd]
  5325 00003A7F E8A60A                   call fcloseR
  5326 00003A82 83C402                   add  sp, 2
  5327                                  
  5328                                  ;-90     exitR(n);
  5329                                  
  5330 00003A85 FF7604                   push word [bp+4]
  5331 00003A88 E8AB0A                   call exitR
  5332 00003A8B 83C402                   add  sp, 2
  5333                                  
  5334                                  ;-91 }
  5335 00003A8E C9                       LEAVE
  5336 00003A8F C3                       ret
  5337                                  ; ENDP
  5338                                  ;Back to main program: AS.C
  5339                                  
  5340                                  ;-9 #include "GENCODE.C"
  5341                                  
  5342                                  ;Use include file: GENCODE.C
  5343                                  
  5344                                  ;-1 // generate code
  5345                                  
  5346                                  
  5347                                  ;-2 int getCodes() {
  5348                                  
  5349                                  
  5350                                  getCodes:  ; *** PROC ***
  5351                                  
  5352                                  ;-3     OpCodePtr ++; Code1 = *OpCodePtr;
  5353                                  
  5354 00003A90 FF06[C701]               inc  word [OpCodePtr]
  5355 00003A94 8B1E[C701]               mov bx, [OpCodePtr]
  5356 00003A98 8A07                     mov al, [bx]
  5357 00003A9A B400                     mov ah, 0
  5358 00003A9C A2[AF01]                 mov byte [Code1], al
  5359                                  
  5360                                  ;-4     OpCodePtr ++; Code2 = *OpCodePtr;
  5361                                  
  5362 00003A9F FF06[C701]               inc  word [OpCodePtr]
  5363 00003AA3 8B1E[C701]               mov bx, [OpCodePtr]
  5364 00003AA7 8A07                     mov al, [bx]
  5365 00003AA9 B400                     mov ah, 0
  5366 00003AAB A2[B001]                 mov byte [Code2], al
  5367                                  
  5368                                  ;-5     OpCodePtr ++; Code3 = *OpCodePtr;
  5369                                  
  5370 00003AAE FF06[C701]               inc  word [OpCodePtr]
  5371 00003AB2 8B1E[C701]               mov bx, [OpCodePtr]
  5372 00003AB6 8A07                     mov al, [bx]
  5373 00003AB8 B400                     mov ah, 0
  5374 00003ABA A2[B101]                 mov byte [Code3], al
  5375                                  
  5376                                  ;-6 }
  5377                                  
  5378                                  
  5379                                  ;-7 int gen66h() {genCode8(0x66);
  5380                                  
  5381 00003ABD C3                       ret
  5382                                  ; ENDP
  5383                                  
  5384                                  gen66h:  ; *** PROC ***
  5385 00003ABE 6A66                     push 102
  5386 00003AC0 E83B00                   call genCode8
  5387 00003AC3 83C402                   add  sp, 2
  5388                                  
  5389                                  ;-8 }
  5390                                  
  5391                                  
  5392                                  ;-9 int genCode2(char c, char d) {
  5393                                  
  5394 00003AC6 C3                       ret
  5395                                  ; ENDP
  5396                                  
  5397                                  genCode2:  ; *** PROC ***
  5398                                  
  5399                                  ;-10     c = c + d;
  5400                                  
  5401                                  ;Function : genCode2, Number of local variables: 2
  5402                                  ;   # type sign width line used address name   list of local variables
  5403                                  ;  200 var sign byte     9 NULL bp+4    c
  5404                                  ;  201 var sign byte     9 NULL bp+6    d;
  5405 00003AC7 C8000000                 ENTER  0,0
  5406 00003ACB 8A4604                   mov al, [bp+4]
  5407 00003ACE 024606                   add al, [bp+6]
  5408 00003AD1 884604                   mov byte [bp+4], al
  5409                                  
  5410                                  ;-11     genCode8(c);
  5411                                  
  5412 00003AD4 8A4604                   mov al, byte [bp+4]
  5413 00003AD7 B400                     mov ah, 0
  5414 00003AD9 50                       push ax
  5415 00003ADA E82100                   call genCode8
  5416 00003ADD 83C402                   add  sp, 2
  5417                                  
  5418                                  ;-12 }                             
  5419                                  
  5420                                  
  5421                                  ;-13 int genCodeW(char c) {
  5422 00003AE0 C9                       LEAVE
  5423 00003AE1 C3                       ret
  5424                                  ; ENDP
  5425                                  
  5426                                  genCodeW:  ; *** PROC ***
  5427                                  
  5428                                  ;-14     c = c + wflag;  
  5429                                  
  5430                                  ;Function : genCodeW, Number of local variables: 1
  5431                                  ;   # type sign width line used address name   list of local variables
  5432                                  ;  200 var sign byte    13 NULL bp+4    c;
  5433 00003AE2 C8000000                 ENTER  0,0
  5434 00003AE6 8A4604                   mov al, [bp+4]
  5435 00003AE9 0206[B701]               add al, [wflag]
  5436 00003AED 884604                   mov byte [bp+4], al
  5437                                  
  5438                                  ;-15     genCode8(c);
  5439                                  
  5440 00003AF0 8A4604                   mov al, byte [bp+4]
  5441 00003AF3 B400                     mov ah, 0
  5442 00003AF5 50                       push ax
  5443 00003AF6 E80500                   call genCode8
  5444 00003AF9 83C402                   add  sp, 2
  5445                                  
  5446                                  ;-16 }   
  5447                                  
  5448                                  
  5449                                  ;-17 int genCode8(char c) {
  5450 00003AFC C9                       LEAVE
  5451 00003AFD C3                       ret
  5452                                  ; ENDP
  5453                                  
  5454                                  genCode8:  ; *** PROC ***
  5455                                  
  5456                                  ;-18 //set: BinLen++, OpPrintIndex++
  5457                                  
  5458                                  
  5459                                  ;-19     FileBin[BinLen]=c;
  5460                                  
  5461                                  ;Function : genCode8, Number of local variables: 1
  5462                                  ;   # type sign width line used address name   list of local variables
  5463                                  ;  200 var sign byte    17 NULL bp+4    c;
  5464 00003AFE C8000000                 ENTER  0,0
  5465 00003B02 8A4604                   mov al, [bp+4]
  5466 00003B05 8B1E[001C]               mov bx, [BinLen]
  5467 00003B09 8887[3014]               mov [FileBin+bx], al
  5468                                  
  5469                                  ;-20     BinLen++;
  5470                                  
  5471 00003B0D FF06[001C]               inc  word [BinLen]
  5472                                  
  5473                                  ;-21     PC++;
  5474                                  
  5475 00003B11 FF06[A601]               inc  word [PC]
  5476                                  
  5477                                  ;-22     if (BinLen >= FILEBINMAX) errorexit("COM file too long");
  5478                                  
  5479 00003B15 A1[001C]                 mov ax, [BinLen]
  5480 00003B18 3DD007                   cmp ax, 2000 ;unsigned : 0
  5481 00003B1B 0F820900                 jb  @@genCode8204
  5482 00003B1F 68[433B]                 push genCode8_0
  5483 00003B22 E8AEF9                   call errorexit
  5484 00003B25 83C402                   add  sp, 2
  5485                                  
  5486                                  ;-23     if (OpPrintIndex < OPMAXLEN) {
  5487                                  
  5488                                  @@genCode8204:
  5489 00003B28 A1[C501]                 mov ax, [OpPrintIndex]
  5490 00003B2B 83F805                   cmp ax, 5
  5491 00003B2E 0F8D0F00                 jge @@genCode8205
  5492                                  
  5493                                  ;-24         OpPos[OpPrintIndex]=c;
  5494                                  
  5495 00003B32 8A4604                   mov al, [bp+4]
  5496 00003B35 8B1E[C501]               mov bx, [OpPrintIndex]
  5497 00003B39 8887[C001]               mov [OpPos+bx], al
  5498                                  
  5499                                  ;-25         OpPrintIndex++;
  5500                                  
  5501 00003B3D FF06[C501]               inc  word [OpPrintIndex]
  5502                                  
  5503                                  ;-26     }
  5504                                  
  5505                                  
  5506                                  ;-27 }
  5507                                  
  5508                                  @@genCode8205:
  5509                                  
  5510                                  ;-28 int genCode16(unsigned int i) {
  5511 00003B41 C9                       LEAVE
  5512 00003B42 C3                       ret
  5513                                  ; ENDP
  5514 00003B43 434F4D2066696C6520-     genCode8_0 db "COM file too long",0
  5515 00003B4C 746F6F206C6F6E6700 
  5516                                  
  5517                                  genCode16:  ; *** PROC ***
  5518                                  
  5519                                  ;-29     genCode8(i); i=i >> 8;
  5520                                  
  5521                                  ;Function : genCode16, Number of local variables: 1
  5522                                  ;   # type sign width line used address name   list of local variables
  5523                                  ;  200 var unsg word    28 NULL bp+4    i;
  5524 00003B55 C8000000                 ENTER  0,0
  5525 00003B59 FF7604                   push word [bp+4]
  5526 00003B5C E89FFF                   call genCode8
  5527 00003B5F 83C402                   add  sp, 2
  5528 00003B62 8B4604                   mov ax, [bp+4]
  5529 00003B65 C1E808                   shr ax, 8
  5530 00003B68 894604                   mov word [bp+4], ax
  5531                                  
  5532                                  ;-30     genCode8(i);
  5533                                  
  5534 00003B6B FF7604                   push word [bp+4]
  5535 00003B6E E88DFF                   call genCode8
  5536 00003B71 83C402                   add  sp, 2
  5537                                  
  5538                                  ;-31 }
  5539                                  
  5540                                  
  5541                                  ;-32 int writeEA(char xxx) {//value for reg/operand
  5542 00003B74 C9                       LEAVE
  5543 00003B75 C3                       ret
  5544                                  ; ENDP
  5545                                  
  5546                                  writeEA:  ; *** PROC ***
  5547                                  
  5548                                  ;-33 //need: Op, Op2, disp, R1No, R2No, rm, isDirect
  5549                                  
  5550                                  
  5551                                  ;-34 //mod-bits: mode76, reg/opcode543, r/m210   
  5552                                  
  5553                                  
  5554                                  ;-35 //Op: 0, IMM, REG, ADR, MEM   
  5555                                  
  5556                                  
  5557                                  ;-36     char len;
  5558                                  
  5559                                  
  5560                                  ;-37     len=0;   
  5561                                  
  5562                                  ;Function : writeEA, Number of local variables: 2
  5563                                  ;   # type sign width line used address name   list of local variables
  5564                                  ;  200 var sign byte    32 NULL bp+4    xxx
  5565                                  ;  201 var sign byte    36 NULL bp-2    len;
  5566 00003B76 C8020000                 ENTER  2,0
  5567 00003B7A 66B800000000             mov eax, 0
  5568 00003B80 8846FE                   mov byte [bp-2], al
  5569                                  
  5570                                  ;-38     xxx = xxx << 3;//in reg/opcode field      
  5571                                  
  5572 00003B83 8A4604                   mov al, [bp+4]
  5573 00003B86 C0E003                   shl al, 3
  5574 00003B89 884604                   mov byte [bp+4], al
  5575                                  
  5576                                  ;-39     if (Op == REG) {
  5577                                  
  5578 00003B8C A0[AC01]                 mov al, [Op]
  5579 00003B8F 3C02                     cmp al, 2
  5580 00003B91 0F853A00                 jne @@writeEA206
  5581                                  
  5582                                  ;-40         xxx |= 0xC0;     
  5583                                  
  5584 00003B95 804E04C0                 or  byte [bp+4], 192
  5585                                  
  5586                                  ;-41         if (Op2 <= IMM) xxx = xxx + R1No;//empty or IMM 
  5587                                  
  5588 00003B99 A0[AD01]                 mov al, [Op2]
  5589 00003B9C 3C01                     cmp al, 1
  5590 00003B9E 0F8F0D00                 jg  @@writeEA207
  5591 00003BA2 8A4604                   mov al, [bp+4]
  5592 00003BA5 0206[B301]               add al, [R1No]
  5593 00003BA9 884604                   mov byte [bp+4], al
  5594                                  
  5595                                  ;-42             else {
  5596                                  
  5597 00003BAC E92000                   jmp @@writeEA208
  5598                                  @@writeEA207:
  5599                                  
  5600                                  ;-43                 if (Op2 == REG) xxx = xxx + R1No;
  5601                                  
  5602 00003BAF A0[AD01]                 mov al, [Op2]
  5603 00003BB2 3C02                     cmp al, 2
  5604 00003BB4 0F850D00                 jne @@writeEA209
  5605 00003BB8 8A4604                   mov al, [bp+4]
  5606 00003BBB 0206[B301]               add al, [R1No]
  5607 00003BBF 884604                   mov byte [bp+4], al
  5608                                  
  5609                                  ;-44                 else            xxx = xxx + R2No;  
  5610                                  
  5611 00003BC2 E90A00                   jmp @@writeEA210
  5612                                  @@writeEA209:
  5613 00003BC5 8A4604                   mov al, [bp+4]
  5614 00003BC8 0206[B201]               add al, [R2No]
  5615 00003BCC 884604                   mov byte [bp+4], al
  5616                                  
  5617                                  ;-45             }
  5618                                  
  5619                                  @@writeEA210:
  5620                                  
  5621                                  ;-46         } 
  5622                                  
  5623                                  @@writeEA208:
  5624                                  
  5625                                  ;-47     if (Op == MEM) {
  5626                                  
  5627                                  @@writeEA206:
  5628 00003BCF A0[AC01]                 mov al, [Op]
  5629 00003BD2 3C04                     cmp al, 4
  5630 00003BD4 0F857F00                 jne @@writeEA211
  5631                                  
  5632                                  ;-48         if (isDirect) {
  5633                                  
  5634 00003BD8 A0[BB01]                 mov al, [isDirect]
  5635 00003BDB 08C0                     or  al, al
  5636 00003BDD 0F841000                 je @@writeEA212
  5637                                  
  5638                                  ;-49             xxx |= 6;
  5639                                  
  5640 00003BE1 804E0406                 or  byte [bp+4], 6
  5641                                  
  5642                                  ;-50             len = 2;
  5643                                  
  5644 00003BE5 66B802000000             mov eax, 2
  5645 00003BEB 8846FE                   mov byte [bp-2], al
  5646                                  
  5647                                  ;-51         }
  5648                                  
  5649                                  
  5650                                  ;-52         else { 
  5651                                  
  5652 00003BEE E96600                   jmp @@writeEA213
  5653                                  @@writeEA212:
  5654                                  
  5655                                  ;-53             xxx = xxx + rm;   
  5656                                  
  5657 00003BF1 8A4604                   mov al, [bp+4]
  5658 00003BF4 0206[BA01]               add al, [rm]
  5659 00003BF8 884604                   mov byte [bp+4], al
  5660                                  
  5661                                  ;-54             if (rm == 6) {//make [BP+00]
  5662                                  
  5663 00003BFB A0[BA01]                 mov al, [rm]
  5664 00003BFE 3C06                     cmp al, 6
  5665 00003C00 0F851700                 jne @@writeEA214
  5666                                  
  5667                                  ;-55                 len=1;
  5668                                  
  5669 00003C04 66B801000000             mov eax, 1
  5670 00003C0A 8846FE                   mov byte [bp-2], al
  5671                                  
  5672                                  ;-56                 if (disp == 0) xxx |= 0x40;
  5673                                  
  5674 00003C0D A1[BC01]                 mov ax, [disp]
  5675 00003C10 83F800                   cmp ax, 0
  5676 00003C13 0F850400                 jne @@writeEA215
  5677 00003C17 804E0440                 or  byte [bp+4], 64
  5678                                  
  5679                                  ;-57             }
  5680                                  
  5681                                  @@writeEA215:
  5682                                  
  5683                                  ;-58 
  5684                                  
  5685                                  
  5686                                  ;-59             if (disp) {
  5687                                  
  5688                                  @@writeEA214:
  5689 00003C1B A1[BC01]                 mov ax, [disp]
  5690 00003C1E 08C0                     or  al, al
  5691 00003C20 0F843300                 je @@writeEA216
  5692                                  
  5693                                  ;-60                 ax = disp;
  5694                                  
  5695 00003C24 A1[BC01]                 mov  ax, [disp]
  5696                                  
  5697                                  ;-61                 if(ax > 127) len=2;
  5698                                  
  5699 00003C27 83F87F                   cmp  ax, 127
  5700 00003C2A 0F8E0C00                 jle @@writeEA217
  5701 00003C2E 66B802000000             mov eax, 2
  5702 00003C34 8846FE                   mov byte [bp-2], al
  5703                                  
  5704                                  ;-62                 else len=1;
  5705                                  
  5706 00003C37 E90900                   jmp @@writeEA218
  5707                                  @@writeEA217:
  5708 00003C3A 66B801000000             mov eax, 1
  5709 00003C40 8846FE                   mov byte [bp-2], al
  5710                                  
  5711                                  ;-63                 if (len == 1) xxx |= 0x40;
  5712                                  
  5713                                  @@writeEA218:
  5714 00003C43 8A46FE                   mov al, [bp-2]
  5715 00003C46 3C01                     cmp al, 1
  5716 00003C48 0F850700                 jne @@writeEA219
  5717 00003C4C 804E0440                 or  byte [bp+4], 64
  5718                                  
  5719                                  ;-64                 else xxx |= 0x80;
  5720                                  
  5721 00003C50 E90400                   jmp @@writeEA220
  5722                                  @@writeEA219:
  5723 00003C53 804E0480                 or  byte [bp+4], 128
  5724                                  
  5725                                  ;-65             }
  5726                                  
  5727                                  @@writeEA220:
  5728                                  
  5729                                  ;-66         }
  5730                                  
  5731                                  @@writeEA216:
  5732                                  
  5733                                  ;-67     }  
  5734                                  
  5735                                  @@writeEA213:
  5736                                  
  5737                                  ;-68     
  5738                                  
  5739                                  
  5740                                  ;-69     genCode8(xxx);// gen second byte
  5741                                  
  5742                                  @@writeEA211:
  5743 00003C57 8A4604                   mov al, byte [bp+4]
  5744 00003C5A B400                     mov ah, 0
  5745 00003C5C 50                       push ax
  5746 00003C5D E89EFE                   call genCode8
  5747 00003C60 83C402                   add  sp, 2
  5748                                  
  5749                                  ;-70     if (len == 1) genCode8 (disp);
  5750                                  
  5751 00003C63 8A46FE                   mov al, [bp-2]
  5752 00003C66 3C01                     cmp al, 1
  5753 00003C68 0F850A00                 jne @@writeEA221
  5754 00003C6C FF36[BC01]               push word [disp]
  5755 00003C70 E88BFE                   call genCode8
  5756 00003C73 83C402                   add  sp, 2
  5757                                  
  5758                                  ;-71     if (len == 2) genCode16(disp);
  5759                                  
  5760                                  @@writeEA221:
  5761 00003C76 8A46FE                   mov al, [bp-2]
  5762 00003C79 3C02                     cmp al, 2
  5763 00003C7B 0F850A00                 jne @@writeEA222
  5764 00003C7F FF36[BC01]               push word [disp]
  5765 00003C83 E8CFFE                   call genCode16
  5766 00003C86 83C402                   add  sp, 2
  5767                                  
  5768                                  ;-72 }
  5769                                  
  5770                                  @@writeEA222:
  5771                                  
  5772                                  ;-73 
  5773                                  
  5774                                  
  5775                                  ;-74 int genImmediate() { 
  5776 00003C89 C9                       LEAVE
  5777 00003C8A C3                       ret
  5778                                  ; ENDP
  5779                                  
  5780                                  genImmediate:  ; *** PROC ***
  5781                                  
  5782                                  ;-75     if (wflag) genCode16(imme);
  5783                                  
  5784 00003C8B A0[B701]                 mov al, [wflag]
  5785 00003C8E 08C0                     or  al, al
  5786 00003C90 0F840D00                 je @@genImmediate223
  5787 00003C94 FF36[BE01]               push word [imme]
  5788 00003C98 E8BAFE                   call genCode16
  5789 00003C9B 83C402                   add  sp, 2
  5790                                  
  5791                                  ;-76     else       genCode8 (imme);  
  5792                                  
  5793 00003C9E E90A00                   jmp @@genImmediate224
  5794                                  @@genImmediate223:
  5795 00003CA1 FF36[BE01]               push word [imme]
  5796 00003CA5 E856FE                   call genCode8
  5797 00003CA8 83C402                   add  sp, 2
  5798                                  
  5799                                  ;-77 }    
  5800                                  
  5801                                  @@genImmediate224:
  5802 00003CAB C3                       ret
  5803                                  ; ENDP
  5804                                  ;Back to main program: AS.C
  5805                                  
  5806                                  ;-10 
  5807                                  
  5808                                  
  5809                                  ;-11 int process() { 
  5810                                  
  5811                                  
  5812                                  process:  ; *** PROC ***
  5813                                  
  5814                                  ;-12     char c;           
  5815                                  
  5816                                  
  5817                                  ;-13     Op=Op2=R1Type=R2Type=R1No=R2No=dflag=wflag=rm=0;//char
  5818                                  
  5819                                  ;Function : process, Number of local variables: 1
  5820                                  ;   # type sign width line used address name   list of local variables
  5821                                  ;  200 var sign byte    12 NULL bp-2    c;
  5822 00003CAC C8020000                 ENTER  2,0
  5823 00003CB0 66B800000000             mov eax, 0
  5824 00003CB6 A2[BA01]                 mov byte [rm], al
  5825 00003CB9 A2[B701]                 mov byte [wflag], al
  5826 00003CBC A2[B801]                 mov byte [dflag], al
  5827 00003CBF A2[B201]                 mov byte [R2No], al
  5828 00003CC2 A2[B301]                 mov byte [R1No], al
  5829 00003CC5 A2[B401]                 mov byte [R2Type], al
  5830 00003CC8 A2[B501]                 mov byte [R1Type], al
  5831 00003CCB A2[AD01]                 mov byte [Op2], al
  5832 00003CCE A2[AC01]                 mov byte [Op], al
  5833                                  
  5834                                  ;-14     disp=imme=0;//int
  5835                                  
  5836 00003CD1 66B800000000             mov eax, 0
  5837 00003CD7 A3[BE01]                 mov word [imme], ax
  5838 00003CDA A3[BC01]                 mov word [disp], ax
  5839                                  
  5840                                  ;-15     isDirect=1; //set in getMeM=0, need in WriteEA
  5841                                  
  5842 00003CDD 66B801000000             mov eax, 1
  5843 00003CE3 A2[BB01]                 mov byte [isDirect], al
  5844                                  
  5845                                  ;-16     getTokeType();//0, DIGIT, ALNUME, NOALNUME
  5846                                  
  5847 00003CE6 E8D4E8                   call getTokeType
  5848                                  
  5849                                  ;-17     OpSize=getCodeSize();//0, BYTE, WORD, DWORD
  5850                                  
  5851 00003CE9 E8AEEC                   call getCodeSize
  5852 00003CEC A2[B601]                 mov byte [OpSize], al
  5853                                  
  5854                                  ;-18     getCodes();//set: Code1, Code2, Code3
  5855                                  
  5856 00003CEF E89EFD                   call getCodes
  5857                                  
  5858                                  ;-19 
  5859                                  
  5860                                  
  5861                                  ;-20     if (CodeType ==  1) {//1 byte opcode
  5862                                  
  5863 00003CF2 A0[AE01]                 mov al, [CodeType]
  5864 00003CF5 3C01                     cmp al, 1
  5865 00003CF7 0F850F00                 jne @@process225
  5866                                  
  5867                                  ;-21         genCode8(Code1);
  5868                                  
  5869 00003CFB A0[AF01]                 mov al, byte [Code1]
  5870 00003CFE B400                     mov ah, 0
  5871 00003D00 50                       push ax
  5872 00003D01 E8FAFD                   call genCode8
  5873 00003D04 83C402                   add  sp, 2
  5874                                  
  5875                                  ;-22         return;
  5876                                  
  5877 00003D07 E90C06                   jmp @@retn
  5878                                  
  5879                                  ;-23     }
  5880                                  
  5881                                  
  5882                                  ;-24   
  5883                                  
  5884                                  
  5885                                  ;-25     if (CodeType ==  2) {//inc,dec,not,neg,mul,imul,div,idiv     
  5886                                  
  5887                                  @@process225:
  5888 00003D0A A0[AE01]                 mov al, [CodeType]
  5889 00003D0D 3C02                     cmp al, 2
  5890 00003D0F 0F856900                 jne @@process226
  5891                                  
  5892                                  ;-26         getOpL();    
  5893                                  
  5894 00003D13 E879E3                   call getOpL
  5895                                  
  5896                                  ;-27         checkOpL();        
  5897                                  
  5898 00003D16 E899E2                   call checkOpL
  5899                                  
  5900                                  ;-28         if (Code2 <= 1) {//inc,dec
  5901                                  
  5902 00003D19 A0[B001]                 mov al, [Code2]
  5903 00003D1C 3C01                     cmp al, 1
  5904 00003D1E 0F8F2700                 jg  @@process227
  5905                                  
  5906                                  ;-29   	        if (Op == REG) {//short
  5907                                  
  5908 00003D22 A0[AC01]                 mov al, [Op]
  5909 00003D25 3C02                     cmp al, 2
  5910 00003D27 0F851E00                 jne @@process228
  5911                                  
  5912                                  ;-30                 if (wflag) {genCode2(Code3, R1No); return; }
  5913                                  
  5914 00003D2B A0[B701]                 mov al, [wflag]
  5915 00003D2E 08C0                     or  al, al
  5916 00003D30 0F841500                 je @@process229
  5917 00003D34 A0[B301]                 mov al, byte [R1No]
  5918 00003D37 B400                     mov ah, 0
  5919 00003D39 50                       push ax
  5920 00003D3A A0[B101]                 mov al, byte [Code3]
  5921 00003D3D B400                     mov ah, 0
  5922 00003D3F 50                       push ax
  5923 00003D40 E884FD                   call genCode2
  5924 00003D43 83C404                   add  sp, 4
  5925 00003D46 E9CD05                   jmp @@retn
  5926                                  
  5927                                  ;-31             }
  5928                                  
  5929                                  @@process229:
  5930                                  
  5931                                  ;-32         }
  5932                                  
  5933                                  @@process228:
  5934                                  
  5935                                  ;-33         if (Code2 == 5) {//imul extension?
  5936                                  
  5937                                  @@process227:
  5938 00003D49 A0[B001]                 mov al, [Code2]
  5939 00003D4C 3C05                     cmp al, 5
  5940 00003D4E 0F850F00                 jne @@process230
  5941                                  
  5942                                  ;-34             getTokeType();
  5943                                  
  5944 00003D52 E868E8                   call getTokeType
  5945                                  
  5946                                  ;-35             if (TokeType) implerror();
  5947                                  
  5948 00003D55 A0[AB01]                 mov al, [TokeType]
  5949 00003D58 08C0                     or  al, al
  5950 00003D5A 0F840300                 je @@process231
  5951 00003D5E E8E3F7                   call implerror
  5952                                  
  5953                                  ;-36         }
  5954                                  
  5955                                  @@process231:
  5956                                  
  5957                                  ;-37         genCodeW(Code1);           
  5958                                  
  5959                                  @@process230:
  5960 00003D61 A0[AF01]                 mov al, byte [Code1]
  5961 00003D64 B400                     mov ah, 0
  5962 00003D66 50                       push ax
  5963 00003D67 E878FD                   call genCodeW
  5964 00003D6A 83C402                   add  sp, 2
  5965                                  
  5966                                  ;-38         writeEA(Code2);
  5967                                  
  5968 00003D6D A0[B001]                 mov al, byte [Code2]
  5969 00003D70 B400                     mov ah, 0
  5970 00003D72 50                       push ax
  5971 00003D73 E800FE                   call writeEA
  5972 00003D76 83C402                   add  sp, 2
  5973                                  
  5974                                  ;-39         return;
  5975                                  
  5976 00003D79 E99A05                   jmp @@retn
  5977                                  
  5978                                  ;-40     }
  5979                                  
  5980                                  
  5981                                  ;-41   
  5982                                  
  5983                                  
  5984                                  ;-42     if (CodeType == 3) {//les,lds,lea,lss,lfs,lgs
  5985                                  
  5986                                  @@process226:
  5987 00003D7C A0[AE01]                 mov al, [CodeType]
  5988 00003D7F 3C03                     cmp al, 3
  5989 00003D81 0F855100                 jne @@process232
  5990                                  
  5991                                  ;-43         check2Ops();    //setwflag not applicable
  5992                                  
  5993 00003D85 E8ACE2                   call check2Ops
  5994                                  
  5995                                  ;-44         if (R1Type != WORD) reg16error();//only r16
  5996                                  
  5997 00003D88 A0[B501]                 mov al, [R1Type]
  5998 00003D8B 3C02                     cmp al, 2
  5999 00003D8D 0F840300                 je  @@process233
  6000 00003D91 E850F8                   call reg16error
  6001                                  
  6002                                  ;-45         if (Op2 != MEM) addrerror();//only m16 
  6003                                  
  6004                                  @@process233:
  6005 00003D94 A0[AD01]                 mov al, [Op2]
  6006 00003D97 3C04                     cmp al, 4
  6007 00003D99 0F840300                 je  @@process234
  6008 00003D9D E865F7                   call addrerror
  6009                                  
  6010                                  ;-46         
  6011                                  
  6012                                  
  6013                                  ;-47         genCode8(Code1);//les,lds,lea
  6014                                  
  6015                                  @@process234:
  6016 00003DA0 A0[AF01]                 mov al, byte [Code1]
  6017 00003DA3 B400                     mov ah, 0
  6018 00003DA5 50                       push ax
  6019 00003DA6 E855FD                   call genCode8
  6020 00003DA9 83C402                   add  sp, 2
  6021                                  
  6022                                  ;-48         if (Code1 == 0x0F) genCode8(Code2);//lss,lfs,lgs   
  6023                                  
  6024 00003DAC A0[AF01]                 mov al, [Code1]
  6025 00003DAF 3C0F                     cmp al, 15
  6026 00003DB1 0F850C00                 jne @@process235
  6027 00003DB5 A0[B001]                 mov al, byte [Code2]
  6028 00003DB8 B400                     mov ah, 0
  6029 00003DBA 50                       push ax
  6030 00003DBB E840FD                   call genCode8
  6031 00003DBE 83C402                   add  sp, 2
  6032                                  
  6033                                  ;-49         Op=Op2;//set MEM for writeEA
  6034                                  
  6035                                  @@process235:
  6036 00003DC1 A0[AD01]                 mov al, [Op2]
  6037 00003DC4 A2[AC01]                 mov byte [Op], al
  6038                                  
  6039                                  ;-50         writeEA(R1No);           
  6040                                  
  6041 00003DC7 A0[B301]                 mov al, byte [R1No]
  6042 00003DCA B400                     mov ah, 0
  6043 00003DCC 50                       push ax
  6044 00003DCD E8A6FD                   call writeEA
  6045 00003DD0 83C402                   add  sp, 2
  6046                                  
  6047                                  ;-51         return;
  6048                                  
  6049 00003DD3 E94005                   jmp @@retn
  6050                                  
  6051                                  ;-52     }
  6052                                  
  6053                                  
  6054                                  ;-53 
  6055                                  
  6056                                  
  6057                                  ;-54     if (CodeType == 4) {//add,or,adc,sbb,and,sub,xor,cmp,->test
  6058                                  
  6059                                  @@process232:
  6060 00003DD6 A0[AE01]                 mov al, [CodeType]
  6061 00003DD9 3C04                     cmp al, 4
  6062 00003DDB 0F85EF00                 jne @@process236
  6063                                  
  6064                                  ;-55         check2Ops();    
  6065                                  
  6066 00003DDF E852E2                   call check2Ops
  6067                                  
  6068                                  ;-56         if (Op2 == IMM) {//second operand is imm     
  6069                                  
  6070 00003DE2 A0[AD01]                 mov al, [Op2]
  6071 00003DE5 3C01                     cmp al, 1
  6072 00003DE7 0F857900                 jne @@process237
  6073                                  
  6074                                  ;-57             setsflag();   
  6075                                  
  6076 00003DEB E829E6                   call setsflag
  6077                                  
  6078                                  ;-58             if (Op == REG) {                
  6079                                  
  6080 00003DEE A0[AC01]                 mov al, [Op]
  6081 00003DF1 3C02                     cmp al, 2
  6082 00003DF3 0F853100                 jne @@process238
  6083                                  
  6084                                  ;-59                 if (R1No == 0) {// acc,imm   
  6085                                  
  6086 00003DF7 A0[B301]                 mov al, [R1No]
  6087 00003DFA 3C00                     cmp al, 0
  6088 00003DFC 0F852800                 jne @@process239
  6089                                  
  6090                                  ;-60                     if (sflag == 0) {                        
  6091                                  
  6092 00003E00 A0[B901]                 mov al, [sflag]
  6093 00003E03 3C00                     cmp al, 0
  6094 00003E05 0F851F00                 jne @@process240
  6095                                  
  6096                                  ;-61                         c = Code1 << 3;
  6097                                  
  6098 00003E09 A0[AF01]                 mov al, [Code1]
  6099 00003E0C C0E003                   shl al, 3
  6100 00003E0F 8846FE                   mov byte [bp-2], al
  6101                                  
  6102                                  ;-62                         c += 4;    
  6103                                  
  6104 00003E12 8046FE04                 add  byte [bp-2], 4
  6105                                  
  6106                                  ;-63                         genCodeW(c);
  6107                                  
  6108 00003E16 8A46FE                   mov al, byte [bp-2]
  6109 00003E19 B400                     mov ah, 0
  6110 00003E1B 50                       push ax
  6111 00003E1C E8C3FC                   call genCodeW
  6112 00003E1F 83C402                   add  sp, 2
  6113                                  
  6114                                  ;-64                         genImmediate();
  6115                                  
  6116 00003E22 E866FE                   call genImmediate
  6117                                  
  6118                                  ;-65                         return;
  6119                                  
  6120 00003E25 E9EE04                   jmp @@retn
  6121                                  
  6122                                  ;-66                     }
  6123                                  
  6124                                  
  6125                                  ;-67                 }
  6126                                  
  6127                                  @@process240:
  6128                                  
  6129                                  ;-68             }
  6130                                  
  6131                                  @@process239:
  6132                                  
  6133                                  ;-69             //r/m, imm: 80 sign-extended,TTT,imm
  6134                                  
  6135                                  
  6136                                  ;-70             c = sflag + 0x80;   
  6137                                  
  6138                                  @@process238:
  6139 00003E28 A0[B901]                 mov al, [sflag]
  6140 00003E2B 0480                     add al, 128
  6141 00003E2D 8846FE                   mov byte [bp-2], al
  6142                                  
  6143                                  ;-71             genCodeW(c); 
  6144                                  
  6145 00003E30 8A46FE                   mov al, byte [bp-2]
  6146 00003E33 B400                     mov ah, 0
  6147 00003E35 50                       push ax
  6148 00003E36 E8A9FC                   call genCodeW
  6149 00003E39 83C402                   add  sp, 2
  6150                                  
  6151                                  ;-72             writeEA(Code1);  
  6152                                  
  6153 00003E3C A0[AF01]                 mov al, byte [Code1]
  6154 00003E3F B400                     mov ah, 0
  6155 00003E41 50                       push ax
  6156 00003E42 E831FD                   call writeEA
  6157 00003E45 83C402                   add  sp, 2
  6158                                  
  6159                                  ;-73             if (sflag) genCode8(imme);
  6160                                  
  6161 00003E48 A0[B901]                 mov al, [sflag]
  6162 00003E4B 08C0                     or  al, al
  6163 00003E4D 0F840D00                 je @@process241
  6164 00003E51 FF36[BE01]               push word [imme]
  6165 00003E55 E8A6FC                   call genCode8
  6166 00003E58 83C402                   add  sp, 2
  6167                                  
  6168                                  ;-74             else genImmediate();    
  6169                                  
  6170 00003E5B E90300                   jmp @@process242
  6171                                  @@process241:
  6172 00003E5E E82AFE                   call genImmediate
  6173                                  
  6174                                  ;-75             return;     
  6175                                  
  6176                                  @@process242:
  6177 00003E61 E9B204                   jmp @@retn
  6178                                  
  6179                                  ;-76         }  
  6180                                  
  6181                                  
  6182                                  ;-77         c = Code1 << 3;//r/m, r/r  
  6183                                  
  6184                                  @@process237:
  6185 00003E64 A0[AF01]                 mov al, [Code1]
  6186 00003E67 C0E003                   shl al, 3
  6187 00003E6A 8846FE                   mov byte [bp-2], al
  6188                                  
  6189                                  ;-78         if (Op == REG) {
  6190                                  
  6191 00003E6D A0[AC01]                 mov al, [Op]
  6192 00003E70 3C02                     cmp al, 2
  6193 00003E72 0F852E00                 jne @@process243
  6194                                  
  6195                                  ;-79             if (Op2 == MEM) {//reg, mem      
  6196                                  
  6197 00003E76 A0[AD01]                 mov al, [Op2]
  6198 00003E79 3C04                     cmp al, 4
  6199 00003E7B 0F852500                 jne @@process244
  6200                                  
  6201                                  ;-80                 c += 2;//add direction flag
  6202                                  
  6203 00003E7F 8046FE02                 add  byte [bp-2], 2
  6204                                  
  6205                                  ;-81                 genCodeW(c);
  6206                                  
  6207 00003E83 8A46FE                   mov al, byte [bp-2]
  6208 00003E86 B400                     mov ah, 0
  6209 00003E88 50                       push ax
  6210 00003E89 E856FC                   call genCodeW
  6211 00003E8C 83C402                   add  sp, 2
  6212                                  
  6213                                  ;-82                 Op=Op2;//set MEM for writeEA                
  6214                                  
  6215 00003E8F A0[AD01]                 mov al, [Op2]
  6216 00003E92 A2[AC01]                 mov byte [Op], al
  6217                                  
  6218                                  ;-83                 writeEA(R1No);
  6219                                  
  6220 00003E95 A0[B301]                 mov al, byte [R1No]
  6221 00003E98 B400                     mov ah, 0
  6222 00003E9A 50                       push ax
  6223 00003E9B E8D8FC                   call writeEA
  6224 00003E9E 83C402                   add  sp, 2
  6225                                  
  6226                                  ;-84                 return;    
  6227                                  
  6228 00003EA1 E97204                   jmp @@retn
  6229                                  
  6230                                  ;-85             }
  6231                                  
  6232                                  
  6233                                  ;-86         }
  6234                                  
  6235                                  @@process244:
  6236                                  
  6237                                  ;-87         if (Op2 == REG) {//mem,reg    reg,reg
  6238                                  
  6239                                  @@process243:
  6240 00003EA4 A0[AD01]                 mov al, [Op2]
  6241 00003EA7 3C02                     cmp al, 2
  6242 00003EA9 0F851B00                 jne @@process245
  6243                                  
  6244                                  ;-88             genCodeW(c);
  6245                                  
  6246 00003EAD 8A46FE                   mov al, byte [bp-2]
  6247 00003EB0 B400                     mov ah, 0
  6248 00003EB2 50                       push ax
  6249 00003EB3 E82CFC                   call genCodeW
  6250 00003EB6 83C402                   add  sp, 2
  6251                                  
  6252                                  ;-89             writeEA(R2No);//2. Op in reg-field
  6253                                  
  6254 00003EB9 A0[B201]                 mov al, byte [R2No]
  6255 00003EBC B400                     mov ah, 0
  6256 00003EBE 50                       push ax
  6257 00003EBF E8B4FC                   call writeEA
  6258 00003EC2 83C402                   add  sp, 2
  6259                                  
  6260                                  ;-90             return;            
  6261                                  
  6262 00003EC5 E94E04                   jmp @@retn
  6263                                  
  6264                                  ;-91         }          
  6265                                  
  6266                                  
  6267                                  ;-92         syntaxerror();        
  6268                                  
  6269                                  @@process245:
  6270 00003EC8 E868F7                   call syntaxerror
  6271                                  
  6272                                  ;-93         return;
  6273                                  
  6274 00003ECB E94804                   jmp @@retn
  6275                                  
  6276                                  ;-94     }
  6277                                  
  6278                                  
  6279                                  ;-95  
  6280                                  
  6281                                  
  6282                                  ;-96     if (CodeType == 5) {//mov (movsx, movzx=51)
  6283                                  
  6284                                  @@process236:
  6285 00003ECE A0[AE01]                 mov al, [CodeType]
  6286 00003ED1 3C05                     cmp al, 5
  6287 00003ED3 0F857F01                 jne @@process246
  6288                                  
  6289                                  ;-97         check2Ops();    
  6290                                  
  6291 00003ED7 E85AE1                   call check2Ops
  6292                                  
  6293                                  ;-98 /*    prs("\n Op:"); printhex8a(Op);
  6294                                  
  6295                                  
  6296                                  ;-99     prs(", Op2:"); printhex8a(Op2);
  6297                                  
  6298                                  
  6299                                  ;-100     prs(", R1No:"); printhex8a(R1No);
  6300                                  
  6301                                  
  6302                                  ;-101     prs(", R2No:"); printhex8a(R2No);   */  
  6303                                  
  6304                                  
  6305                                  ;-102         if (Op2 == ADR) {
  6306                                  
  6307 00003EDA A0[AD01]                 mov al, [Op2]
  6308 00003EDD 3C03                     cmp al, 3
  6309 00003EDF 0F850F00                 jne @@process247
  6310                                  
  6311                                  ;-103             imme=disp;
  6312                                  
  6313 00003EE3 A1[BC01]                 mov ax, [disp]
  6314 00003EE6 A3[BE01]                 mov word [imme], ax
  6315                                  
  6316                                  ;-104             Op2=IMM;//continue with IMM    
  6317                                  
  6318 00003EE9 66B801000000             mov eax, 1
  6319 00003EEF A2[AD01]                 mov byte [Op2], al
  6320                                  
  6321                                  ;-105         }  
  6322                                  
  6323                                  
  6324                                  ;-106         if (Op2 == IMM) {// r,i     
  6325                                  
  6326                                  @@process247:
  6327 00003EF2 A0[AD01]                 mov al, [Op2]
  6328 00003EF5 3C01                     cmp al, 1
  6329 00003EF7 0F855400                 jne @@process248
  6330                                  
  6331                                  ;-107             if (Op == REG) {               
  6332                                  
  6333 00003EFB A0[AC01]                 mov al, [Op]
  6334 00003EFE 3C02                     cmp al, 2
  6335 00003F00 0F852500                 jne @@process249
  6336                                  
  6337                                  ;-108                 c = wflag << 3;   
  6338                                  
  6339 00003F04 A0[B701]                 mov al, [wflag]
  6340 00003F07 C0E003                   shl al, 3
  6341 00003F0A 8846FE                   mov byte [bp-2], al
  6342                                  
  6343                                  ;-109                 c += 0xB0;                                     
  6344                                  
  6345 00003F0D 8046FEB0                 add  byte [bp-2], 176
  6346                                  
  6347                                  ;-110                 genCode2(c, R1No);   
  6348                                  
  6349 00003F11 A0[B301]                 mov al, byte [R1No]
  6350 00003F14 B400                     mov ah, 0
  6351 00003F16 50                       push ax
  6352 00003F17 8A46FE                   mov al, byte [bp-2]
  6353 00003F1A B400                     mov ah, 0
  6354 00003F1C 50                       push ax
  6355 00003F1D E8A7FB                   call genCode2
  6356 00003F20 83C404                   add  sp, 4
  6357                                  
  6358                                  ;-111                 genImmediate();
  6359                                  
  6360 00003F23 E865FD                   call genImmediate
  6361                                  
  6362                                  ;-112                 return; 
  6363                                  
  6364 00003F26 E9ED03                   jmp @@retn
  6365                                  
  6366                                  ;-113             }
  6367                                  
  6368                                  
  6369                                  ;-114             if (Op == MEM) {// m,i  
  6370                                  
  6371                                  @@process249:
  6372 00003F29 A0[AC01]                 mov al, [Op]
  6373 00003F2C 3C04                     cmp al, 4
  6374 00003F2E 0F851700                 jne @@process250
  6375                                  
  6376                                  ;-115                 genCodeW(0xC6);
  6377                                  
  6378 00003F32 68C600                   push 198
  6379 00003F35 E8AAFB                   call genCodeW
  6380 00003F38 83C402                   add  sp, 2
  6381                                  
  6382                                  ;-116                 writeEA( 0 );
  6383                                  
  6384 00003F3B 6A00                     push 0
  6385 00003F3D E836FC                   call writeEA
  6386 00003F40 83C402                   add  sp, 2
  6387                                  
  6388                                  ;-117                 genImmediate();
  6389                                  
  6390 00003F43 E845FD                   call genImmediate
  6391                                  
  6392                                  ;-118                 return;  
  6393                                  
  6394 00003F46 E9CD03                   jmp @@retn
  6395                                  
  6396                                  ;-119             }
  6397                                  
  6398                                  
  6399                                  ;-120             regmemerror();
  6400                                  
  6401                                  @@process250:
  6402 00003F49 E86EF6                   call regmemerror
  6403                                  
  6404                                  ;-121             return;
  6405                                  
  6406 00003F4C E9C703                   jmp @@retn
  6407                                  
  6408                                  ;-122         }      
  6409                                  
  6410                                  
  6411                                  ;-123         if (R1Type == SEGREG) ChangeDirection();//sreg,rm
  6412                                  
  6413                                  @@process248:
  6414 00003F4F A0[B501]                 mov al, [R1Type]
  6415 00003F52 3C04                     cmp al, 4
  6416 00003F54 0F850300                 jne @@process251
  6417 00003F58 E812E0                   call ChangeDirection
  6418                                  
  6419                                  ;-124         if (R2Type == SEGREG) {//rm,sreg
  6420                                  
  6421                                  @@process251:
  6422 00003F5B A0[B401]                 mov al, [R2Type]
  6423 00003F5E 3C04                     cmp al, 4
  6424 00003F60 0F852A00                 jne @@process252
  6425                                  
  6426                                  ;-125             if (OpSize != WORD) reg16error();
  6427                                  
  6428 00003F64 A0[B601]                 mov al, [OpSize]
  6429 00003F67 3C02                     cmp al, 2
  6430 00003F69 0F840300                 je  @@process253
  6431 00003F6D E874F6                   call reg16error
  6432                                  
  6433                                  ;-126                 genCode2(0x8C, dflag);
  6434                                  
  6435                                  @@process253:
  6436 00003F70 A0[B801]                 mov al, byte [dflag]
  6437 00003F73 B400                     mov ah, 0
  6438 00003F75 50                       push ax
  6439 00003F76 688C00                   push 140
  6440 00003F79 E84BFB                   call genCode2
  6441 00003F7C 83C404                   add  sp, 4
  6442                                  
  6443                                  ;-127                 writeEA(R2No);
  6444                                  
  6445 00003F7F A0[B201]                 mov al, byte [R2No]
  6446 00003F82 B400                     mov ah, 0
  6447 00003F84 50                       push ax
  6448 00003F85 E8EEFB                   call writeEA
  6449 00003F88 83C402                   add  sp, 2
  6450                                  
  6451                                  ;-128                 return;   
  6452                                  
  6453 00003F8B E98803                   jmp @@retn
  6454                                  
  6455                                  ;-129         }          
  6456                                  
  6457                                  
  6458                                  ;-130         if (Op2 == MEM) {//acc, moffs16
  6459                                  
  6460                                  @@process252:
  6461 00003F8E A0[AD01]                 mov al, [Op2]
  6462 00003F91 3C04                     cmp al, 4
  6463 00003F93 0F853100                 jne @@process254
  6464                                  
  6465                                  ;-131             if (Op == REG) {
  6466                                  
  6467 00003F97 A0[AC01]                 mov al, [Op]
  6468 00003F9A 3C02                     cmp al, 2
  6469 00003F9C 0F852800                 jne @@process255
  6470                                  
  6471                                  ;-132                 if (R1No == 0) {
  6472                                  
  6473 00003FA0 A0[B301]                 mov al, [R1No]
  6474 00003FA3 3C00                     cmp al, 0
  6475 00003FA5 0F851F00                 jne @@process256
  6476                                  
  6477                                  ;-133                     if (isDirect) {
  6478                                  
  6479 00003FA9 A0[BB01]                 mov al, [isDirect]
  6480 00003FAC 08C0                     or  al, al
  6481 00003FAE 0F841600                 je @@process257
  6482                                  
  6483                                  ;-134                         genCodeW(0xA0);
  6484                                  
  6485 00003FB2 68A000                   push 160
  6486 00003FB5 E82AFB                   call genCodeW
  6487 00003FB8 83C402                   add  sp, 2
  6488                                  
  6489                                  ;-135                         genCode16(disp);
  6490                                  
  6491 00003FBB FF36[BC01]               push word [disp]
  6492 00003FBF E893FB                   call genCode16
  6493 00003FC2 83C402                   add  sp, 2
  6494                                  
  6495                                  ;-136                         return;   
  6496                                  
  6497 00003FC5 E94E03                   jmp @@retn
  6498                                  
  6499                                  ;-137                     }   
  6500                                  
  6501                                  
  6502                                  ;-138                 }   
  6503                                  
  6504                                  @@process257:
  6505                                  
  6506                                  ;-139             }   
  6507                                  
  6508                                  @@process256:
  6509                                  
  6510                                  ;-140         } 
  6511                                  
  6512                                  @@process255:
  6513                                  
  6514                                  ;-141         if (Op == MEM) {//moffs16, acc
  6515                                  
  6516                                  @@process254:
  6517 00003FC8 A0[AC01]                 mov al, [Op]
  6518 00003FCB 3C04                     cmp al, 4
  6519 00003FCD 0F853100                 jne @@process258
  6520                                  
  6521                                  ;-142             if (Op2 == REG) {
  6522                                  
  6523 00003FD1 A0[AD01]                 mov al, [Op2]
  6524 00003FD4 3C02                     cmp al, 2
  6525 00003FD6 0F852800                 jne @@process259
  6526                                  
  6527                                  ;-143                 if (R2No == 0) {
  6528                                  
  6529 00003FDA A0[B201]                 mov al, [R2No]
  6530 00003FDD 3C00                     cmp al, 0
  6531 00003FDF 0F851F00                 jne @@process260
  6532                                  
  6533                                  ;-144                     if (isDirect) {
  6534                                  
  6535 00003FE3 A0[BB01]                 mov al, [isDirect]
  6536 00003FE6 08C0                     or  al, al
  6537 00003FE8 0F841600                 je @@process261
  6538                                  
  6539                                  ;-145                         genCodeW(0xA2);
  6540                                  
  6541 00003FEC 68A200                   push 162
  6542 00003FEF E8F0FA                   call genCodeW
  6543 00003FF2 83C402                   add  sp, 2
  6544                                  
  6545                                  ;-146                         genCode16(disp);
  6546                                  
  6547 00003FF5 FF36[BC01]               push word [disp]
  6548 00003FF9 E859FB                   call genCode16
  6549 00003FFC 83C402                   add  sp, 2
  6550                                  
  6551                                  ;-147                         return;   
  6552                                  
  6553 00003FFF E91403                   jmp @@retn
  6554                                  
  6555                                  ;-148                     }   
  6556                                  
  6557                                  
  6558                                  ;-149                 }   
  6559                                  
  6560                                  @@process261:
  6561                                  
  6562                                  ;-150             }
  6563                                  
  6564                                  @@process260:
  6565                                  
  6566                                  ;-151         
  6567                                  
  6568                                  
  6569                                  ;-152         }
  6570                                  
  6571                                  @@process259:
  6572                                  
  6573                                  ;-153         if (Op2 == REG) {//rm, r
  6574                                  
  6575                                  @@process258:
  6576 00004002 A0[AD01]                 mov al, [Op2]
  6577 00004005 3C02                     cmp al, 2
  6578 00004007 0F851800                 jne @@process262
  6579                                  
  6580                                  ;-154             genCodeW(0x88);     
  6581                                  
  6582 0000400B 688800                   push 136
  6583 0000400E E8D1FA                   call genCodeW
  6584 00004011 83C402                   add  sp, 2
  6585                                  
  6586                                  ;-155             writeEA(R2No);
  6587                                  
  6588 00004014 A0[B201]                 mov al, byte [R2No]
  6589 00004017 B400                     mov ah, 0
  6590 00004019 50                       push ax
  6591 0000401A E859FB                   call writeEA
  6592 0000401D 83C402                   add  sp, 2
  6593                                  
  6594                                  ;-156             return;
  6595                                  
  6596 00004020 E9F302                   jmp @@retn
  6597                                  
  6598                                  ;-157         }
  6599                                  
  6600                                  
  6601                                  ;-158         if (Op2 == MEM) {//r, m
  6602                                  
  6603                                  @@process262:
  6604 00004023 A0[AD01]                 mov al, [Op2]
  6605 00004026 3C04                     cmp al, 4
  6606 00004028 0F852400                 jne @@process263
  6607                                  
  6608                                  ;-159             if (Op == REG) {
  6609                                  
  6610 0000402C A0[AC01]                 mov al, [Op]
  6611 0000402F 3C02                     cmp al, 2
  6612 00004031 0F851B00                 jne @@process264
  6613                                  
  6614                                  ;-160                 ChangeDirection();
  6615                                  
  6616 00004035 E835DF                   call ChangeDirection
  6617                                  
  6618                                  ;-161                 genCodeW(0x8A);
  6619                                  
  6620 00004038 688A00                   push 138
  6621 0000403B E8A4FA                   call genCodeW
  6622 0000403E 83C402                   add  sp, 2
  6623                                  
  6624                                  ;-162                 writeEA(R2No);
  6625                                  
  6626 00004041 A0[B201]                 mov al, byte [R2No]
  6627 00004044 B400                     mov ah, 0
  6628 00004046 50                       push ax
  6629 00004047 E82CFB                   call writeEA
  6630 0000404A 83C402                   add  sp, 2
  6631                                  
  6632                                  ;-163                 return;   
  6633                                  
  6634 0000404D E9C602                   jmp @@retn
  6635                                  
  6636                                  ;-164             }   
  6637                                  
  6638                                  
  6639                                  ;-165         }         
  6640                                  
  6641                                  @@process264:
  6642                                  
  6643                                  ;-166         syntaxerror();
  6644                                  
  6645                                  @@process263:
  6646 00004050 E8E0F5                   call syntaxerror
  6647                                  
  6648                                  ;-167         return;
  6649                                  
  6650 00004053 E9C002                   jmp @@retn
  6651                                  
  6652                                  ;-168     }    
  6653                                  
  6654                                  
  6655                                  ;-169     
  6656                                  
  6657                                  
  6658                                  ;-170     if (CodeType == 6) {//Jcc short jumps       
  6659                                  
  6660                                  @@process246:
  6661 00004056 A0[AE01]                 mov al, [CodeType]
  6662 00004059 3C06                     cmp al, 6
  6663 0000405B 0F85C400                 jne @@process265
  6664                                  
  6665                                  ;-171 
  6666                                  
  6667                                  
  6668                                  ;-172 
  6669                                  
  6670                                  
  6671                                  ;-173         if (TokeType == ALNUME) {
  6672                                  
  6673 0000405F A0[AB01]                 mov al, [TokeType]
  6674 00004062 3C03                     cmp al, 3
  6675 00004064 0F85B800                 jne @@process266
  6676                                  
  6677                                  ;-174             LabelIx=searchLabel();
  6678                                  
  6679 00004068 E823E7                   call searchLabel
  6680 0000406B A3[7E06]                 mov word [LabelIx], ax
  6681                                  
  6682                                  ;-175             if (LabelIx) {//vvv
  6683                                  
  6684 0000406E A1[7E06]                 mov ax, [LabelIx]
  6685 00004071 08C0                     or  al, al
  6686 00004073 0F847000                 je @@process267
  6687                                  
  6688                                  ;-176                 disp=LabelAddr[LabelIx];
  6689                                  
  6690 00004077 8B1E[7E06]               mov bx, [LabelIx]
  6691 0000407B D1E3                     shl bx, 1
  6692 0000407D 8B87[B405]               mov ax, [LabelAddr + bx]
  6693 00004081 A3[BC01]                 mov word [disp], ax
  6694                                  
  6695                                  ;-177                 disp = disp - PC;
  6696                                  
  6697 00004084 A1[BC01]                 mov ax, [disp]
  6698 00004087 2B06[A601]               sub ax, [PC]
  6699 0000408B A3[BC01]                 mov word [disp], ax
  6700                                  
  6701                                  ;-178                 if (checkConstSize(disp) ) {
  6702                                  
  6703 0000408E FF36[BC01]               push word [disp]
  6704 00004092 E8E7E3                   call checkConstSize
  6705 00004095 83C402                   add  sp, 2
  6706 00004098 08C0                     or  al, al
  6707 0000409A 0F842000                 je @@process268
  6708                                  
  6709                                  ;-179                     genCode2(Code1, 0x70);       
  6710                                  
  6711 0000409E 6A70                     push 112
  6712 000040A0 A0[AF01]                 mov al, byte [Code1]
  6713 000040A3 B400                     mov ah, 0
  6714 000040A5 50                       push ax
  6715 000040A6 E81EFA                   call genCode2
  6716 000040A9 83C404                   add  sp, 4
  6717                                  
  6718                                  ;-180                     disp -= 2; 
  6719                                  
  6720 000040AC 832E[BC01]02             sub  word [disp], 2
  6721                                  
  6722                                  ;-181                     genCode8(disp);   
  6723                                  
  6724 000040B1 FF36[BC01]               push word [disp]
  6725 000040B5 E846FA                   call genCode8
  6726 000040B8 83C402                   add  sp, 2
  6727                                  
  6728                                  ;-182                 } else {     
  6729                                  
  6730 000040BB E92600                   jmp @@process269
  6731                                  @@process268:
  6732                                  
  6733                                  ;-183                     genCode8(0x0F);
  6734                                  
  6735 000040BE 6A0F                     push 15
  6736 000040C0 E83BFA                   call genCode8
  6737 000040C3 83C402                   add  sp, 2
  6738                                  
  6739                                  ;-184                     genCode2(Code1, 0x80);       
  6740                                  
  6741 000040C6 688000                   push 128
  6742 000040C9 A0[AF01]                 mov al, byte [Code1]
  6743 000040CC B400                     mov ah, 0
  6744 000040CE 50                       push ax
  6745 000040CF E8F5F9                   call genCode2
  6746 000040D2 83C404                   add  sp, 4
  6747                                  
  6748                                  ;-185                     disp -= 4; 
  6749                                  
  6750 000040D5 832E[BC01]04             sub  word [disp], 4
  6751                                  
  6752                                  ;-186                     genCode16(disp);                       
  6753                                  
  6754 000040DA FF36[BC01]               push word [disp]
  6755 000040DE E874FA                   call genCode16
  6756 000040E1 83C402                   add  sp, 2
  6757                                  
  6758                                  ;-187                 }    
  6759                                  
  6760                                  
  6761                                  ;-188             }
  6762                                  
  6763                                  @@process269:
  6764                                  
  6765                                  ;-189             else {//jump forward
  6766                                  
  6767 000040E4 E93900                   jmp @@process270
  6768                                  @@process267:
  6769                                  
  6770                                  ;-190                 genCode8(0x0F);
  6771                                  
  6772 000040E7 6A0F                     push 15
  6773 000040E9 E812FA                   call genCode8
  6774 000040EC 83C402                   add  sp, 2
  6775                                  
  6776                                  ;-191                 genCode2(Code1, 0x80);
  6777                                  
  6778 000040EF 688000                   push 128
  6779 000040F2 A0[AF01]                 mov al, byte [Code1]
  6780 000040F5 B400                     mov ah, 0
  6781 000040F7 50                       push ax
  6782 000040F8 E8CCF9                   call genCode2
  6783 000040FB 83C404                   add  sp, 4
  6784                                  
  6785                                  ;-192                 genCode16(0);
  6786                                  
  6787 000040FE 6A00                     push 0
  6788 00004100 E852FA                   call genCode16
  6789 00004103 83C402                   add  sp, 2
  6790                                  
  6791                                  ;-193                 PrintRA='R';
  6792                                  
  6793 00004106 66B852000000             mov eax, 82
  6794 0000410C A2[C901]                 mov byte [PrintRA], al
  6795                                  
  6796                                  ;-194                 storeJmpCall();
  6797                                  
  6798 0000410F E846E5                   call storeJmpCall
  6799                                  
  6800                                  ;-195                 JmpCallRelAbs[JmpCallMaxIx] = 'R';//rel16
  6801                                  
  6802 00004112 66B852000000             mov eax, 82
  6803 00004118 8B1E[2E14]               mov bx, [JmpCallMaxIx]
  6804 0000411C 8887[3A12]               mov [JmpCallRelAbs+bx], al
  6805                                  
  6806                                  ;-196             }   
  6807                                  
  6808                                  
  6809                                  ;-197         }
  6810                                  
  6811                                  @@process270:
  6812                                  
  6813                                  ;-198         return;   
  6814                                  
  6815                                  @@process266:
  6816 00004120 E9F301                   jmp @@retn
  6817                                  
  6818                                  ;-199     }
  6819                                  
  6820                                  
  6821                                  ;-200 
  6822                                  
  6823                                  
  6824                                  ;-201 
  6825                                  
  6826                                  
  6827                                  ;-202     
  6828                                  
  6829                                  
  6830                                  ;-203     if (CodeType ==  8) {//ret,retf
  6831                                  
  6832                                  @@process265:
  6833 00004123 A0[AE01]                 mov al, [CodeType]
  6834 00004126 3C08                     cmp al, 8
  6835 00004128 0F853100                 jne @@process271
  6836                                  
  6837                                  ;-204         if (TokeType == DIGIT) {
  6838                                  
  6839 0000412C A0[AB01]                 mov al, [TokeType]
  6840 0000412F 3C01                     cmp al, 1
  6841 00004131 0F851900                 jne @@process272
  6842                                  
  6843                                  ;-205             genCode8(Code2);
  6844                                  
  6845 00004135 A0[B001]                 mov al, byte [Code2]
  6846 00004138 B400                     mov ah, 0
  6847 0000413A 50                       push ax
  6848 0000413B E8C0F9                   call genCode8
  6849 0000413E 83C402                   add  sp, 2
  6850                                  
  6851                                  ;-206             genCode16(SymbolInt);
  6852                                  
  6853 00004141 FF36[4D00]               push word [SymbolInt]
  6854 00004145 E80DFA                   call genCode16
  6855 00004148 83C402                   add  sp, 2
  6856                                  
  6857                                  ;-207             return;
  6858                                  
  6859 0000414B E9C801                   jmp @@retn
  6860                                  
  6861                                  ;-208         }
  6862                                  
  6863                                  
  6864                                  ;-209         genCode8(Code1); 
  6865                                  
  6866                                  @@process272:
  6867 0000414E A0[AF01]                 mov al, byte [Code1]
  6868 00004151 B400                     mov ah, 0
  6869 00004153 50                       push ax
  6870 00004154 E8A7F9                   call genCode8
  6871 00004157 83C402                   add  sp, 2
  6872                                  
  6873                                  ;-210         return;
  6874                                  
  6875 0000415A E9B901                   jmp @@retn
  6876                                  
  6877                                  ;-211     }
  6878                                  
  6879                                  
  6880                                  ;-212        
  6881                                  
  6882                                  
  6883                                  ;-213     if (CodeType == 9) {//push, pop  
  6884                                  
  6885                                  @@process271:
  6886 0000415D A0[AE01]                 mov al, [CodeType]
  6887 00004160 3C09                     cmp al, 9
  6888 00004162 0F850301                 jne @@process273
  6889                                  
  6890                                  ;-214         getOpL();
  6891                                  
  6892 00004166 E826DF                   call getOpL
  6893                                  
  6894                                  ;-215         if (Code1 == 0x50) {//push only
  6895                                  
  6896 00004169 A0[AF01]                 mov al, [Code1]
  6897 0000416C 3C50                     cmp al, 80
  6898 0000416E 0F853D00                 jne @@process274
  6899                                  
  6900                                  ;-216             if (Op == IMM) {//push imm8,16
  6901                                  
  6902 00004172 A0[AC01]                 mov al, [Op]
  6903 00004175 3C01                     cmp al, 1
  6904 00004177 0F853400                 jne @@process275
  6905                                  
  6906                                  ;-217                 setsflag();
  6907                                  
  6908 0000417B E899E2                   call setsflag
  6909                                  
  6910                                  ;-218                 genCode2(0x68, sflag);     
  6911                                  
  6912 0000417E A0[B901]                 mov al, byte [sflag]
  6913 00004181 B400                     mov ah, 0
  6914 00004183 50                       push ax
  6915 00004184 6A68                     push 104
  6916 00004186 E83EF9                   call genCode2
  6917 00004189 83C404                   add  sp, 4
  6918                                  
  6919                                  ;-219                 if (sflag) genCode8 (imme);
  6920                                  
  6921 0000418C A0[B901]                 mov al, [sflag]
  6922 0000418F 08C0                     or  al, al
  6923 00004191 0F840D00                 je @@process276
  6924 00004195 FF36[BE01]               push word [imme]
  6925 00004199 E862F9                   call genCode8
  6926 0000419C 83C402                   add  sp, 2
  6927                                  
  6928                                  ;-220                 else       genCode16(imme);    
  6929                                  
  6930 0000419F E90A00                   jmp @@process277
  6931                                  @@process276:
  6932 000041A2 FF36[BE01]               push word [imme]
  6933 000041A6 E8ACF9                   call genCode16
  6934 000041A9 83C402                   add  sp, 2
  6935                                  
  6936                                  ;-221                 return;   
  6937                                  
  6938                                  @@process277:
  6939 000041AC E96701                   jmp @@retn
  6940                                  
  6941                                  ;-222             }   
  6942                                  
  6943                                  
  6944                                  ;-223         }
  6945                                  
  6946                                  @@process275:
  6947                                  
  6948                                  ;-224         if (R1Type == SEGREG) {
  6949                                  
  6950                                  @@process274:
  6951 000041AF A0[B501]                 mov al, [R1Type]
  6952 000041B2 3C04                     cmp al, 4
  6953 000041B4 0F855A00                 jne @@process278
  6954                                  
  6955                                  ;-225             if (Code1 == 0x58) {
  6956                                  
  6957 000041B8 A0[AF01]                 mov al, [Code1]
  6958 000041BB 3C58                     cmp al, 88
  6959 000041BD 0F851200                 jne @@process279
  6960                                  
  6961                                  ;-226                 if (R1No == 1) error1("pop cs not allowed");   
  6962                                  
  6963 000041C1 A0[B301]                 mov al, [R1No]
  6964 000041C4 3C01                     cmp al, 1
  6965 000041C6 0F850900                 jne @@process280
  6966 000041CA 68[1843]                 push process_0
  6967 000041CD E8A4F2                   call error1
  6968 000041D0 83C402                   add  sp, 2
  6969                                  
  6970                                  ;-227             }
  6971                                  
  6972                                  @@process280:
  6973                                  
  6974                                  ;-228             c = R1No <<3;
  6975                                  
  6976                                  @@process279:
  6977 000041D3 A0[B301]                 mov al, [R1No]
  6978 000041D6 C0E003                   shl al, 3
  6979 000041D9 8846FE                   mov byte [bp-2], al
  6980                                  
  6981                                  ;-229             if (R1No > 3) {//FS, GS
  6982                                  
  6983 000041DC A0[B301]                 mov al, [R1No]
  6984 000041DF 3C03                     cmp al, 3
  6985 000041E1 0F8E0C00                 jle @@process281
  6986                                  
  6987                                  ;-230                 c += 122;
  6988                                  
  6989 000041E5 8046FE7A                 add  byte [bp-2], 122
  6990                                  
  6991                                  ;-231                 genCode8(0x0F);
  6992                                  
  6993 000041E9 6A0F                     push 15
  6994 000041EB E810F9                   call genCode8
  6995 000041EE 83C402                   add  sp, 2
  6996                                  
  6997                                  ;-232             }
  6998                                  
  6999                                  
  7000                                  ;-233             OpCodePtr++;
  7001                                  
  7002                                  @@process281:
  7003 000041F1 FF06[C701]               inc  word [OpCodePtr]
  7004                                  
  7005                                  ;-234             c = c + *OpCodePtr;//is Code4   
  7006                                  
  7007 000041F5 8A46FE                   mov al, [bp-2]
  7008 000041F8 8B1E[C701]               mov bx, [OpCodePtr]
  7009 000041FC 0207                     add al, [bx]
  7010 000041FE B400                     mov ah, 0
  7011 00004200 8846FE                   mov byte [bp-2], al
  7012                                  
  7013                                  ;-235             genCode8(c);  
  7014                                  
  7015 00004203 8A46FE                   mov al, byte [bp-2]
  7016 00004206 B400                     mov ah, 0
  7017 00004208 50                       push ax
  7018 00004209 E8F2F8                   call genCode8
  7019 0000420C 83C402                   add  sp, 2
  7020                                  
  7021                                  ;-236             return; 
  7022                                  
  7023 0000420F E90401                   jmp @@retn
  7024                                  
  7025                                  ;-237         }  
  7026                                  
  7027                                  
  7028                                  ;-238         checkOpL();    
  7029                                  
  7030                                  @@process278:
  7031 00004212 E89DDD                   call checkOpL
  7032                                  
  7033                                  ;-239         if (R1Type == BYTE) reg16error();
  7034                                  
  7035 00004215 A0[B501]                 mov al, [R1Type]
  7036 00004218 3C01                     cmp al, 1
  7037 0000421A 0F850300                 jne @@process282
  7038 0000421E E8C3F3                   call reg16error
  7039                                  
  7040                                  ;-240         if (R1Type == WORD) {
  7041                                  
  7042                                  @@process282:
  7043 00004221 A0[B501]                 mov al, [R1Type]
  7044 00004224 3C02                     cmp al, 2
  7045 00004226 0F851500                 jne @@process283
  7046                                  
  7047                                  ;-241             genCode2(Code1, R1No);
  7048                                  
  7049 0000422A A0[B301]                 mov al, byte [R1No]
  7050 0000422D B400                     mov ah, 0
  7051 0000422F 50                       push ax
  7052 00004230 A0[AF01]                 mov al, byte [Code1]
  7053 00004233 B400                     mov ah, 0
  7054 00004235 50                       push ax
  7055 00004236 E88EF8                   call genCode2
  7056 00004239 83C404                   add  sp, 4
  7057                                  
  7058                                  ;-242             return;   
  7059                                  
  7060 0000423C E9D700                   jmp @@retn
  7061                                  
  7062                                  ;-243         }                
  7063                                  
  7064                                  
  7065                                  ;-244         if (Op == MEM) {
  7066                                  
  7067                                  @@process283:
  7068 0000423F A0[AC01]                 mov al, [Op]
  7069 00004242 3C04                     cmp al, 4
  7070 00004244 0F851B00                 jne @@process284
  7071                                  
  7072                                  ;-245             genCode8(Code2);
  7073                                  
  7074 00004248 A0[B001]                 mov al, byte [Code2]
  7075 0000424B B400                     mov ah, 0
  7076 0000424D 50                       push ax
  7077 0000424E E8ADF8                   call genCode8
  7078 00004251 83C402                   add  sp, 2
  7079                                  
  7080                                  ;-246             writeEA(Code3);
  7081                                  
  7082 00004254 A0[B101]                 mov al, byte [Code3]
  7083 00004257 B400                     mov ah, 0
  7084 00004259 50                       push ax
  7085 0000425A E819F9                   call writeEA
  7086 0000425D 83C402                   add  sp, 2
  7087                                  
  7088                                  ;-247             return;   
  7089                                  
  7090 00004260 E9B300                   jmp @@retn
  7091                                  
  7092                                  ;-248         }
  7093                                  
  7094                                  
  7095                                  ;-249         syntaxerror();
  7096                                  
  7097                                  @@process284:
  7098 00004263 E8CDF3                   call syntaxerror
  7099                                  
  7100                                  ;-250         return;        
  7101                                  
  7102 00004266 E9AD00                   jmp @@retn
  7103                                  
  7104                                  ;-251     }
  7105                                  
  7106                                  
  7107                                  ;-252     
  7108                                  
  7109                                  
  7110                                  ;-253     if (CodeType == 12) {//int
  7111                                  
  7112                                  @@process273:
  7113 00004269 A0[AE01]                 mov al, [CodeType]
  7114 0000426C 3C0C                     cmp al, 12
  7115 0000426E 0F852200                 jne @@process285
  7116                                  
  7117                                  ;-254         if (TokeType == DIGIT) {            
  7118                                  
  7119 00004272 A0[AB01]                 mov al, [TokeType]
  7120 00004275 3C01                     cmp al, 1
  7121 00004277 0F851900                 jne @@process286
  7122                                  
  7123                                  ;-255             genCode8(Code1);
  7124                                  
  7125 0000427B A0[AF01]                 mov al, byte [Code1]
  7126 0000427E B400                     mov ah, 0
  7127 00004280 50                       push ax
  7128 00004281 E87AF8                   call genCode8
  7129 00004284 83C402                   add  sp, 2
  7130                                  
  7131                                  ;-256             genCode8(SymbolInt);
  7132                                  
  7133 00004287 FF36[4D00]               push word [SymbolInt]
  7134 0000428B E870F8                   call genCode8
  7135 0000428E 83C402                   add  sp, 2
  7136                                  
  7137                                  ;-257             return;   
  7138                                  
  7139 00004291 E98200                   jmp @@retn
  7140                                  
  7141                                  ;-258         }
  7142                                  
  7143                                  
  7144                                  ;-259     }
  7145                                  
  7146                                  @@process286:
  7147                                  
  7148                                  ;-260     
  7149                                  
  7150                                  
  7151                                  ;-261     if (CodeType == 30) {//enter i18,i8
  7152                                  
  7153                                  @@process285:
  7154 00004294 A0[AE01]                 mov al, [CodeType]
  7155 00004297 3C1E                     cmp al, 30
  7156 00004299 0F855200                 jne @@process287
  7157                                  
  7158                                  ;-262         genCode8(0xC8);
  7159                                  
  7160 0000429D 68C800                   push 200
  7161 000042A0 E85BF8                   call genCode8
  7162 000042A3 83C402                   add  sp, 2
  7163                                  
  7164                                  ;-263         Op=getOp1();
  7165                                  
  7166 000042A6 E8A3DE                   call getOp1
  7167 000042A9 A2[AC01]                 mov byte [Op], al
  7168                                  
  7169                                  ;-264         if (Op == IMM) genCode16(SymbolInt);
  7170                                  
  7171 000042AC A0[AC01]                 mov al, [Op]
  7172 000042AF 3C01                     cmp al, 1
  7173 000042B1 0F850D00                 jne @@process288
  7174 000042B5 FF36[4D00]               push word [SymbolInt]
  7175 000042B9 E899F8                   call genCode16
  7176 000042BC 83C402                   add  sp, 2
  7177                                  
  7178                                  ;-265         else numbererror();
  7179                                  
  7180 000042BF E90300                   jmp @@process289
  7181                                  @@process288:
  7182 000042C2 E8DBF2                   call numbererror
  7183                                  
  7184                                  ;-266         need(',');
  7185                                  
  7186                                  @@process289:
  7187 000042C5 6A2C                     push 44
  7188 000042C7 E881E7                   call need
  7189 000042CA 83C402                   add  sp, 2
  7190                                  
  7191                                  ;-267         Op=getOp1();
  7192                                  
  7193 000042CD E87CDE                   call getOp1
  7194 000042D0 A2[AC01]                 mov byte [Op], al
  7195                                  
  7196                                  ;-268         if (Op == IMM) genCode8 (SymbolInt);
  7197                                  
  7198 000042D3 A0[AC01]                 mov al, [Op]
  7199 000042D6 3C01                     cmp al, 1
  7200 000042D8 0F850D00                 jne @@process290
  7201 000042DC FF36[4D00]               push word [SymbolInt]
  7202 000042E0 E81BF8                   call genCode8
  7203 000042E3 83C402                   add  sp, 2
  7204                                  
  7205                                  ;-269         else numbererror();           
  7206                                  
  7207 000042E6 E90300                   jmp @@process291
  7208                                  @@process290:
  7209 000042E9 E8B4F2                   call numbererror
  7210                                  
  7211                                  ;-270         return;
  7212                                  
  7213                                  @@process291:
  7214 000042EC E92700                   jmp @@retn
  7215                                  
  7216                                  ;-271     }
  7217                                  
  7218                                  
  7219                                  ;-272        
  7220                                  
  7221                                  
  7222                                  ;-273     if (CodeType==101) {// ORG nn
  7223                                  
  7224                                  @@process287:
  7225 000042EF A0[AE01]                 mov al, [CodeType]
  7226 000042F2 3C65                     cmp al, 101
  7227 000042F4 0F851500                 jne @@process292
  7228                                  
  7229                                  ;-274         if (TokeType != DIGIT) numbererror();
  7230                                  
  7231 000042F8 A0[AB01]                 mov al, [TokeType]
  7232 000042FB 3C01                     cmp al, 1
  7233 000042FD 0F840300                 je  @@process293
  7234 00004301 E89CF2                   call numbererror
  7235                                  
  7236                                  ;-275         PC=SymbolInt;
  7237                                  
  7238                                  @@process293:
  7239 00004304 A1[4D00]                 mov ax, [SymbolInt]
  7240 00004307 A3[A601]                 mov word [PC], ax
  7241                                  
  7242                                  ;-276         return;
  7243                                  
  7244 0000430A E90900                   jmp @@retn
  7245                                  
  7246                                  ;-277     }
  7247                                  
  7248                                  
  7249                                  ;-278     error1("Command not implemented or syntax error");
  7250                                  
  7251                                  @@process292:
  7252 0000430D 68[2B43]                 push process_1
  7253 00004310 E861F1                   call error1
  7254 00004313 83C402                   add  sp, 2
  7255                                  
  7256                                  ;-279 }    
  7257                                  
  7258 00004316 C9                      @@retn: LEAVE
  7259 00004317 C3                       ret
  7260                                  ; ENDP
  7261 00004318 706F70206373206E6F-     process_0 db "pop cs not allowed",0
  7262 00004321 7420616C6C6F776564-
  7263 0000432A 00                 
  7264 0000432B 436F6D6D616E64206E-     process_1 db "Command not implemented or syntax error",0
  7265 00004334 6F7420696D706C656D-
  7266 0000433D 656E746564206F7220-
  7267 00004346 73796E746178206572-
  7268 0000434F 726F7200           
  7269                                   
  7270                                  ; missing functions: 
  7271                                  ; digit
  7272                                  ; strcpy
  7273                                  ; strcpy
  7274                                  ; eqstr
  7275                                  ; strlen
  7276                                  ; eqstr
  7277                                  ; eqstr
  7278                                  ; eqstr
  7279                                  ; eqstr
  7280                                  ; readRL
  7281                                  ; readRL
  7282                                  ; digit
  7283                                  ; digit
  7284                                  ; strcpy
  7285                                  ; toupper
  7286                                  ; strlen
  7287                                  ; strlen
  7288                                  ; eqstr
  7289                                  ; eqstr
  7290                                  ; eqstr
  7291                                  ; eqstr
  7292                                  ; eqstr
  7293                                  ; eqstr
  7294                                  ; eqstr
  7295                                  ; eqstr
  7296                                  ; eqstr
  7297                                  ; eqstr
  7298                                  ; eqstr
  7299                                  ; eqstr
  7300                                  ; eqstr
  7301                                  ; eqstr
  7302                                  ; eqstr
  7303                                  ; eqstr
  7304                                  ; eqstr
  7305                                  ; eqstr
  7306                                  ; eqstr
  7307                                  ; eqstr
  7308                                  ; eqstr
  7309                                  ; eqstr
  7310                                  ; eqstr
  7311                                  ; eqstr
  7312                                  ; eqstr
  7313                                  ; eqstr
  7314                                  ; eqstr
  7315                                  ; eqstr
  7316                                  ; eqstr
  7317                                  ; eqstr
  7318                                  ; writetty
  7319                                  ; writetty
  7320                                  ; fputcR
  7321                                  ; cputs
  7322                                  ; cputs
  7323                                  ; exitR
  7324                                  ; toupper
  7325                                  ; strcpy
  7326                                  ; strcat1
  7327                                  ; strcpy
  7328                                  ; strcat1
  7329                                  ; strcpy
  7330                                  ; strcat1
  7331                                  ; openR
  7332                                  ; cputs
  7333                                  ; cputs
  7334                                  ; exitR
  7335                                  ; creatR
  7336                                  ; cputs
  7337                                  ; cputs
  7338                                  ; exitR
  7339                                  ; creatR
  7340                                  ; cputs
  7341                                  ; cputs
  7342                                  ; exitR
  7343                                  ; strcpy
  7344                                  ; strlen
  7345                                  ; fputcR
  7346                                  ; fcloseR
  7347                                  ; fcloseR
  7348                                  ; fcloseR
  7349                                  ; exitR
  7350                                  ; Number of unresolved CALLs :   79
  7351                                  ;use archive file: AR.C
  7352                                  
  7353                                  ;-280 // AR.C Archive
  7354                                  
  7355                                  ;Number of CALLs:    2 : writetty
  7356                                  
  7357                                  writetty:  ; *** PROC ***
  7358 00004353 B40E                     mov  ah, 14
  7359 00004355 BB0000                   mov  bx, 0
  7360 00004358 CD10                     int  16
  7361                                  
  7362                                  ;-281 int putch(char c)  {if (_ c==10) {al=13; writetty();} al=c; writetty(); }
  7363                                  
  7364 0000435A C3                       ret
  7365                                  ; ENDP
  7366                                  ;Number of CALLs:    8 : cputs
  7367                                  
  7368                                  cputs:  ; *** PROC ***
  7369                                  ;Function : cputs, Number of local variables: 2
  7370                                  ;   # type sign width line used address name   list of local variables
  7371                                  ;  200 ptr sign byte   281 NULL bp+4    s
  7372                                  ;  201 var sign byte   281 NULL bp-2    c;
  7373 0000435B C8020000                 ENTER  2,0
  7374                                  @@cputs294:
  7375 0000435F 8B5E04                   mov bx, [bp+4]
  7376 00004362 8A07                     mov al, [bx]
  7377 00004364 B400                     mov ah, 0
  7378 00004366 08C0                     or  al, al
  7379 00004368 0F841B00                 je @@cputs295
  7380 0000436C 8B5E04                   mov bx, [bp+4]
  7381 0000436F 8A07                     mov al, [bx]
  7382 00004371 B400                     mov ah, 0
  7383 00004373 8846FE                   mov byte [bp-2], al
  7384 00004376 8A46FE                   mov al, byte [bp-2]
  7385 00004379 B400                     mov ah, 0
  7386 0000437B 50                       push ax
  7387 0000437C E8C401                   call putch
  7388 0000437F 83C402                   add  sp, 2
  7389 00004382 FF4604                   inc  word [bp+4]
  7390 00004385 EBD8                     jmp @@cputs294
  7391                                  @@cputs295:
  7392                                  
  7393                                  ;-282 int mkneg(int n) { n; __asm {neg ax} }
  7394 00004387 C9                       LEAVE
  7395 00004388 C3                       ret
  7396                                  ; ENDP
  7397                                  ;Number of CALLs:    2 : toupper
  7398                                  
  7399                                  toupper:  ; *** PROC ***
  7400                                  ;Function : toupper, Number of local variables: 1
  7401                                  ;   # type sign width line used address name   list of local variables
  7402                                  ;  200 ptr sign byte   282 NULL bp+4    s;
  7403 00004389 C8000000                 ENTER  0,0
  7404                                  @@toupper296:
  7405 0000438D 8B5E04                   mov bx, [bp+4]
  7406 00004390 8A07                     mov al, [bx]
  7407 00004392 B400                     mov ah, 0
  7408 00004394 08C0                     or  al, al
  7409 00004396 0F843000                 je @@toupper297
  7410 0000439A 8B5E04                   mov bx, [bp+4]
  7411 0000439D 8A07                     mov al, [bx]
  7412 0000439F B400                     mov ah, 0
  7413 000043A1 83F861                   cmp ax, 97 ;unsigned : 1
  7414 000043A4 0F8C1D00                 jl  @@toupper298
  7415 000043A8 8B5E04                   mov bx, [bp+4]
  7416 000043AB 8A07                     mov al, [bx]
  7417 000043AD B400                     mov ah, 0
  7418 000043AF 83F87A                   cmp ax, 122
  7419 000043B2 0F8F0F00                 jg  @@toupper299
  7420 000043B6 8B5E04                   mov bx, [bp+4]
  7421 000043B9 8A07                     mov al, [bx]
  7422 000043BB B400                     mov ah, 0
  7423 000043BD 83E820                   sub ax, 32
  7424 000043C0 8B5E04                   mov  bx, [bp+4]
  7425 000043C3 8807                     mov  [bx], al
  7426                                  @@toupper299:
  7427                                  @@toupper298:
  7428 000043C5 FF4604                   inc  word [bp+4]
  7429 000043C8 EBC3                     jmp @@toupper296
  7430                                  @@toupper297:
  7431                                  
  7432                                  ;-283 //int head1  (char *s) {char c; do{c=*s; c=letter(c); s++; }while(c) *s=0; }
  7433                                  
  7434                                  
  7435                                  ;-284 int strlen(char *s) { int c; c=0; while (*s!=0) {s++; c++;} return c; }
  7436 000043CA C9                       LEAVE
  7437 000043CB C3                       ret
  7438                                  ; ENDP
  7439                                  ;Number of CALLs:    4 : strlen
  7440                                  
  7441                                  strlen:  ; *** PROC ***
  7442                                  ;Function : strlen, Number of local variables: 2
  7443                                  ;   # type sign width line used address name   list of local variables
  7444                                  ;  200 ptr sign byte   284 NULL bp+4    s
  7445                                  ;  201 var sign word   284 NULL bp-2    c;
  7446 000043CC C8020000                 ENTER  2,0
  7447 000043D0 66B800000000             mov eax, 0
  7448 000043D6 8946FE                   mov word [bp-2], ax
  7449                                  @@strlen300:
  7450 000043D9 8B5E04                   mov bx, [bp+4]
  7451 000043DC 8A07                     mov al, [bx]
  7452 000043DE B400                     mov ah, 0
  7453 000043E0 83F800                   cmp ax, 0
  7454 000043E3 0F840800                 je  @@strlen301
  7455 000043E7 FF4604                   inc  word [bp+4]
  7456 000043EA FF46FE                   inc  word [bp-2]
  7457 000043ED EBEA                     jmp @@strlen300
  7458                                  @@strlen301:
  7459 000043EF 8B46FE                   mov ax, [bp-2]
  7460 000043F2 E90000                   jmp @@retn
  7461                                  
  7462                                  ;-285 int strcpy1(char *s, char *t) {do { *s=*t; s++; t++; } while (*t!=0); *s=0; }
  7463                                  
  7464 000043F5 C9                      @@retn: LEAVE
  7465 000043F6 C3                       ret
  7466                                  ; ENDP
  7467                                  ;Number of CALLs:    7 : strcpy
  7468                                  
  7469                                  strcpy:  ; *** PROC ***
  7470                                  ;Function : strcpy, Number of local variables: 2
  7471                                  ;   # type sign width line used address name   list of local variables
  7472                                  ;  200 ptr sign byte   285 NULL bp+4    s
  7473                                  ;  201 ptr sign byte   285 NULL bp+6    t;
  7474 000043F7 C8000000                 ENTER  0,0
  7475                                  @@strcpy302:
  7476 000043FB 8B5E06                   mov bx, [bp+6]
  7477 000043FE 8A07                     mov al, [bx]
  7478 00004400 B400                     mov ah, 0
  7479 00004402 8B5E04                   mov  bx, [bp+4]
  7480 00004405 8807                     mov  [bx], al
  7481 00004407 FF4604                   inc  word [bp+4]
  7482 0000440A FF4606                   inc  word [bp+6]
  7483                                  
  7484                                  ;-286   while (*t!=0); *s=0; return s; }
  7485                                  
  7486 0000440D 8B5E06                   mov bx, [bp+6]
  7487 00004410 8A07                     mov al, [bx]
  7488 00004412 B400                     mov ah, 0
  7489 00004414 83F800                   cmp ax, 0
  7490 00004417 0F840200                 je  @@strcpy303
  7491 0000441B EBDE                     jmp @@strcpy302
  7492                                  @@strcpy303:
  7493 0000441D 66B800000000             mov eax, 0
  7494 00004423 8B5E04                   mov  bx, [bp+4]
  7495 00004426 8807                     mov  [bx], al
  7496 00004428 8B4604                   mov ax, [bp+4]
  7497 0000442B E90000                   jmp @@retn
  7498                                  
  7499                                  ;-287 int strncpy(char *s, char *t, int n) { if (_ n==0) return;
  7500                                  
  7501 0000442E C9                      @@retn: LEAVE
  7502 0000442F C3                       ret
  7503                                  ; ENDP
  7504                                  ;Number of CALLs:    3 : digit
  7505                                  
  7506                                  digit:  ; *** PROC ***
  7507                                  ;Function : digit, Number of local variables: 1
  7508                                  ;   # type sign width line used address name   list of local variables
  7509                                  ;  200 var sign byte   287 NULL bp+4    c;
  7510 00004430 C8000000                 ENTER  0,0
  7511 00004434 8A4604                   mov al, [bp+4]
  7512 00004437 3C30                     cmp al, 48
  7513 00004439 0F8D0900                 jge @@digit304
  7514 0000443D 66B800000000             mov eax, 0
  7515 00004443 E91B00                   jmp @@retn
  7516                                  @@digit304:
  7517 00004446 8A4604                   mov al, [bp+4]
  7518 00004449 3C39                     cmp al, 57
  7519 0000444B 0F8E0900                 jle @@digit305
  7520 0000444F 66B800000000             mov eax, 0
  7521 00004455 E90900                   jmp @@retn
  7522                                  @@digit305:
  7523 00004458 66B801000000             mov eax, 1
  7524 0000445E E90000                   jmp @@retn
  7525                                  
  7526                                  ;-288 int letter(char c) { if (digit(c)) return 1; if (c=='_') return 1; //XXXXXXXXXX
  7527                                  
  7528 00004461 C9                      @@retn: LEAVE
  7529 00004462 C3                       ret
  7530                                  ; ENDP
  7531                                  ;Number of CALLs:   35 : eqstr
  7532                                  
  7533                                  eqstr:  ; *** PROC ***
  7534                                  ;Function : eqstr, Number of local variables: 2
  7535                                  ;   # type sign width line used address name   list of local variables
  7536                                  ;  200 ptr sign byte   288 NULL bp+4    p
  7537                                  ;  201 ptr sign byte   288 NULL bp+6    q;
  7538 00004463 C8000000                 ENTER  0,0
  7539                                  @@eqstr306:
  7540 00004467 8B5E04                   mov bx, [bp+4]
  7541 0000446A 8A07                     mov al, [bx]
  7542 0000446C B400                     mov ah, 0
  7543 0000446E 08C0                     or  al, al
  7544 00004470 0F842300                 je @@eqstr307
  7545                                  
  7546                                  ;-289     if (*p != *q) return 0; p++; q++; }
  7547                                  
  7548 00004474 8B5E04                   mov bx, [bp+4]
  7549 00004477 8A07                     mov al, [bx]
  7550 00004479 B400                     mov ah, 0
  7551 0000447B 8B5E06                   mov bx, [bp+6]
  7552 0000447E 3A07                     cmp al, [bx]
  7553 00004480 B400                     mov ah, 0
  7554 00004482 0F840900                 je  @@eqstr308
  7555 00004486 66B800000000             mov eax, 0
  7556 0000448C E92700                   jmp @@retn
  7557                                  @@eqstr308:
  7558 0000448F FF4604                   inc  word [bp+4]
  7559 00004492 FF4606                   inc  word [bp+6]
  7560                                  
  7561                                  ;-290     if(*q) return 0; return 1; }
  7562                                  
  7563 00004495 EBD0                     jmp @@eqstr306
  7564                                  @@eqstr307:
  7565 00004497 8B5E06                   mov bx, [bp+6]
  7566 0000449A 8A07                     mov al, [bx]
  7567 0000449C B400                     mov ah, 0
  7568 0000449E 08C0                     or  al, al
  7569 000044A0 0F840900                 je @@eqstr309
  7570 000044A4 66B800000000             mov eax, 0
  7571 000044AA E90900                   jmp @@retn
  7572                                  @@eqstr309:
  7573 000044AD 66B801000000             mov eax, 1
  7574 000044B3 E90000                   jmp @@retn
  7575                                  
  7576                                  ;-291 int strcat1(char *s, char *t) { while (*s != 0) s++; strcpy(s, t);  }
  7577                                  
  7578 000044B6 C9                      @@retn: LEAVE
  7579 000044B7 C3                       ret
  7580                                  ; ENDP
  7581                                  ;Number of CALLs:    3 : strcat1
  7582                                  
  7583                                  strcat1:  ; *** PROC ***
  7584                                  ;Function : strcat1, Number of local variables: 2
  7585                                  ;   # type sign width line used address name   list of local variables
  7586                                  ;  200 ptr sign byte   291 NULL bp+4    s
  7587                                  ;  201 ptr sign byte   291 NULL bp+6    t;
  7588 000044B8 C8000000                 ENTER  0,0
  7589                                  @@strcat1310:
  7590 000044BC 8B5E04                   mov bx, [bp+4]
  7591 000044BF 8A07                     mov al, [bx]
  7592 000044C1 B400                     mov ah, 0
  7593 000044C3 83F800                   cmp ax, 0
  7594 000044C6 0F840500                 je  @@strcat1311
  7595 000044CA FF4604                   inc  word [bp+4]
  7596 000044CD EBED                     jmp @@strcat1310
  7597                                  @@strcat1311:
  7598 000044CF FF7606                   push word [bp+6]
  7599 000044D2 FF7604                   push word [bp+4]
  7600 000044D5 E81FFF                   call strcpy
  7601 000044D8 83C404                   add  sp, 4
  7602                                  
  7603                                  ;-292 int basename(char *s) { char *p; p=0;
  7604 000044DB C9                       LEAVE
  7605 000044DC C3                       ret
  7606                                  ; ENDP
  7607                                  ;Number of CALLs:    1 : openR
  7608                                  
  7609                                  openR:  ; *** PROC ***
  7610                                  ;Function : openR, Number of local variables: 1
  7611                                  ;   # type sign width line used address name   list of local variables
  7612                                  ;  200 ptr sign byte   292 NULL bp+4    s;
  7613 000044DD C8000000                 ENTER  0,0
  7614 000044E1 8B5604                   mov  dx, [bp+4]
  7615 000044E4 B8023D                   mov  ax, 15618
  7616 000044E7 E87200                   call DosInt
  7617                                  
  7618                                  ;-293 int creatR(char *s) { dx=s; cx=0; ax=0x3C00; DosInt(); }
  7619 000044EA C9                       LEAVE
  7620 000044EB C3                       ret
  7621                                  ; ENDP
  7622                                  ;Number of CALLs:    2 : creatR
  7623                                  
  7624                                  creatR:  ; *** PROC ***
  7625                                  ;Function : creatR, Number of local variables: 1
  7626                                  ;   # type sign width line used address name   list of local variables
  7627                                  ;  200 ptr sign byte   293 NULL bp+4    s;
  7628 000044EC C8000000                 ENTER  0,0
  7629 000044F0 8B5604                   mov  dx, [bp+4]
  7630 000044F3 B90000                   mov  cx, 0
  7631 000044F6 B8003C                   mov  ax, 15360
  7632 000044F9 E86000                   call DosInt
  7633                                  
  7634                                  ;-294 int readR (char *s, int fd) {dx=s; cx=1; bx=fd; ax=0x3F00; DosInt(); }
  7635 000044FC C9                       LEAVE
  7636 000044FD C3                       ret
  7637                                  ; ENDP
  7638                                  ;Number of CALLs:    2 : readRL
  7639                                  
  7640                                  readRL:  ; *** PROC ***
  7641                                  ;Function : readRL, Number of local variables: 3
  7642                                  ;   # type sign width line used address name   list of local variables
  7643                                  ;  200 ptr sign byte   294 NULL bp+4    s
  7644                                  ;  201 var sign word   294 NULL bp+6    fd
  7645                                  ;  202 var sign word   294 NULL bp+8    len;
  7646 000044FE C8000000                 ENTER  0,0
  7647 00004502 8B5604                   mov  dx, [bp+4]
  7648 00004505 8B4E08                   mov  cx, [bp+8]
  7649 00004508 8B5E06                   mov  bx, [bp+6]
  7650 0000450B B8003F                   mov  ax, 16128
  7651 0000450E E84B00                   call DosInt
  7652                                  
  7653                                  ;-295 int fputcR(char *n, int fd) { __asm{lea dx, [bp+4]}; /* = *n */
  7654 00004511 C9                       LEAVE
  7655 00004512 C3                       ret
  7656                                  ; ENDP
  7657                                  ;Number of CALLs:    2 : fputcR
  7658                                  
  7659                                  fputcR:  ; *** PROC ***
  7660                                  ;Function : fputcR, Number of local variables: 2
  7661                                  ;   # type sign width line used address name   list of local variables
  7662                                  ;  200 ptr sign byte   295 NULL bp+4    n
  7663                                  ;  201 var sign word   295 NULL bp+6    fd;
  7664 00004513 C8000000                 ENTER  0,0
  7665 00004517 8D5604                  lea dx, [bp+4]
  7666                                  
  7667                                  ;-296   cx=1; bx=fd; ax=0x4000; DosInt(); }
  7668                                  
  7669 0000451A B90100                   mov  cx, 1
  7670 0000451D 8B5E06                   mov  bx, [bp+6]
  7671 00004520 B80040                   mov  ax, 16384
  7672 00004523 E83600                   call DosInt
  7673                                  
  7674                                  ;-297 int writeRL(char *s, int fd, int len){dx=s; cx=len; bx=fd; ax=0x4000; DosInt();}
  7675 00004526 C9                       LEAVE
  7676 00004527 C3                       ret
  7677                                  ; ENDP
  7678                                  ;Number of CALLs:    3 : fcloseR
  7679                                  
  7680                                  fcloseR:  ; *** PROC ***
  7681                                  ;Function : fcloseR, Number of local variables: 1
  7682                                  ;   # type sign width line used address name   list of local variables
  7683                                  ;  200 var sign word   297 NULL bp+4    fd;
  7684 00004528 C8000000                 ENTER  0,0
  7685 0000452C 8B5E04                   mov  bx, [bp+4]
  7686 0000452F B8003E                   mov  ax, 15872
  7687 00004532 CD21                     int  33
  7688                                  
  7689                                  ;-298 int exitR(char c) {ah=0x4C; al=c; inth 0x21; }
  7690 00004534 C9                       LEAVE
  7691 00004535 C3                       ret
  7692                                  ; ENDP
  7693                                  ;Number of CALLs:    5 : exitR
  7694                                  
  7695                                  exitR:  ; *** PROC ***
  7696                                  ;Function : exitR, Number of local variables: 1
  7697                                  ;   # type sign width line used address name   list of local variables
  7698                                  ;  200 var sign byte   298 NULL bp+4    c;
  7699 00004536 C8000000                 ENTER  0,0
  7700 0000453A B44C                     mov  ah, 76
  7701 0000453C 8A4604                   mov  al, [bp+4]
  7702 0000453F CD21                     int  33
  7703                                  
  7704                                  ;-299 int setdta(char *s) {dx=s; ah=0x1A; inth 0x21; }
  7705 00004541 C9                       LEAVE
  7706 00004542 C3                       ret
  7707                                  ; ENDP
  7708                                  ;End of archive file. 
  7709                                   
  7710                                  ; missing functions: 
  7711                                  ; putch
  7712                                  ; DosInt
  7713                                  ; DosInt
  7714                                  ; DosInt
  7715                                  ; DosInt
  7716                                  ; Number of unresolved CALLs :    5
  7717                                  ;use archive file: AR.C
  7718                                  
  7719                                  ;-300 // AR.C Archive
  7720                                  
  7721                                  ;Number of CALLs:    1 : putch
  7722                                  
  7723                                  putch:  ; *** PROC ***
  7724                                  ;Function : putch, Number of local variables: 1
  7725                                  ;   # type sign width line used address name   list of local variables
  7726                                  ;  200 var sign byte   300 NULL bp+4    c;
  7727 00004543 C8000000                 ENTER  0,0
  7728 00004547 807E040A                cmp byte [bp+4], 10
  7729 0000454B 0F850500                 jne @@putch312
  7730 0000454F B00D                     mov  al, 13
  7731 00004551 E8FFFD                   call writetty
  7732                                  @@putch312:
  7733 00004554 8A4604                   mov  al, [bp+4]
  7734 00004557 E8F9FD                   call writetty
  7735                                  
  7736                                  ;-301 int cputs(char *s) {char c;  while(*s) { c=*s; putch(c); s++; } }
  7737 0000455A C9                       LEAVE
  7738 0000455B C3                       ret
  7739                                  ; ENDP
  7740                                  ;Number of CALLs:    4 : DosInt
  7741                                  
  7742                                  DosInt:  ; *** PROC ***
  7743 0000455C CD21                     int  33
  7744 0000455E 7304                     jae short @@DosInt313
  7745 00004560 FF06[9F01]               inc  word [DOS_ERR]
  7746                                  @@DosInt313:
  7747                                  
  7748                                  ;-302 int openR (char *s) { dx=s; ax=0x3D02;  DosInt(); }
  7749                                  
  7750 00004564 C3                       ret
  7751                                  ; ENDP
  7752                                  ;End of archive file. 
  7753                                   
  7754                                  ; missing functions:  All FUNCTIONs in place
  7755 00004565 E80000                  LastFunctionByt:db 0E8h, 0, 0
  7756 00004568 58                      pop ax
  7757 00004569 C3                      ret
  7758                                   
  7759                                  ;   # type sign width line used  address name   list of global variables
  7760                                  
  7761                                  ;    1 arr sign byte     1    2        0 Version1[10]
  7762                                  ;    2 var sign byte     1    3        0 LIST
  7763                                  ;    3 def unsg byte     2    -        0 SYMBOLMAX=31
  7764                                  ;    4 arr sign byte     3   12        0 Symbol[31]
  7765                                  ;    5 arr sign byte     4   36        0 SymbolUpper[31]
  7766                                  ;    6 var unsg word     5   15        0 SymbolInt
  7767                                  ;    7 def unsg byte     6    -        0 INPUTBUFMAX=127
  7768                                  ;    8 arr sign byte     7    4        0 InputBuf[127]
  7769                                  ;    9 ptr unsg byte     8   24        0 InputPtr
  7770                                  ;   10 arr sign byte     9    5        0 namein[67]
  7771                                  ;   11 arr sign byte    10    6        0 namelst[67]
  7772                                  ;   12 arr sign byte    11    6        0 namebin[67]
  7773                                  ;   13 var sign word    12    4        0 asm_fd
  7774                                  ;   14 var sign word    13    3        0 lst_fd
  7775                                  ;   15 var sign word    14    3        0 bin_fd
  7776                                  ;   16 var sign word    15    6        0 DOS_ERR
  7777                                  ;   17 var sign word    16    4        0 ErrorCount
  7778                                  ;   18 var sign word    17    4        0 DOS_NoBytes
  7779                                  ;   19 var sign byte    18    4        0 DOS_ByteRead
  7780                                  ;   20 var unsg word    20    7        0 PC
  7781                                  ;   21 var unsg word    21    2        0 PCStart
  7782                                  ;   22 var sign byte    22    3        0 isLabel
  7783                                  ;   23 def unsg byte    23    -        0 DIGIT=1
  7784                                  ;   24 def unsg byte    24    -        0 LETTERE=2
  7785                                  ;   25 def unsg byte    25    -        0 ALNUME=3
  7786                                  ;   26 def unsg byte    26    -        0 NOALNUME=4
  7787                                  ;   27 var sign byte    27   23        0 TokeType
  7788                                  ;   28 def unsg byte    28    -        0 BYTE=1
  7789                                  ;   29 def unsg byte    29    -        0 WORD=2
  7790                                  ;   30 def unsg byte    30    -        0 DWORD=3
  7791                                  ;   31 def unsg byte    31    -        0 SEGREG=4
  7792                                  ;   32 def unsg byte    32    -        0 IMM=1
  7793                                  ;   33 def unsg byte    33    -        0 REG=2
  7794                                  ;   34 def unsg byte    34    -        0 ADR=3
  7795                                  ;   35 def unsg byte    35    -        0 MEM=4
  7796                                  ;   36 var sign byte    36   28        0 Op
  7797                                  ;   37 var sign byte    37   29        0 Op2
  7798                                  ;   38 var sign byte    38   19        0 CodeType
  7799                                  ;   39 var sign byte    39   16        0 Code1
  7800                                  ;   40 var sign byte    40    7        0 Code2
  7801                                  ;   41 var sign byte    41    3        0 Code3
  7802                                  ;   42 var sign byte    42   18        0 R2No
  7803                                  ;   43 var sign byte    43   16        0 R1No
  7804                                  ;   44 var sign byte    44   17        0 R2Type
  7805                                  ;   45 var sign byte    45   14        0 R1Type
  7806                                  ;   46 var sign byte    46   13        0 OpSize
  7807                                  ;   47 var sign byte    47    8        0 wflag
  7808                                  ;   48 var sign byte    48    3        0 dflag
  7809                                  ;   49 var sign byte    49    8        0 sflag
  7810                                  ;   50 var sign byte    50   15        0 rm
  7811                                  ;   51 var sign byte    51    5        0 isDirect
  7812                                  ;   52 var sign word    52   25        0 disp
  7813                                  ;   53 var unsg word    53   10        0 imme
  7814                                  ;   54 def unsg byte    55    -        0 OPMAXLEN=5
  7815                                  ;   55 arr sign byte    56    2        0 OpPos[5]
  7816                                  ;   56 var sign word    57    6        0 OpPrintIndex
  7817                                  ;   57 ptr sign byte    58   19        0 OpCodePtr
  7818                                  ;   58 var sign byte    59    3        0 PrintRA
  7819                                  ;   59 def unsg byte    61    -        0 LABELNAMESMAX=969
  7820                                  ;   60 arr sign byte    62    3        0 LabelNames[1000]
  7821                                  ;   61 ptr sign byte    63    5        0 LabelNamePtr
  7822                                  ;   62 def unsg byte    64    -        0 LABELADRMAX=100
  7823                                  ;   63 arr unsg word    65    4        0 LabelAddr[100]
  7824                                  ;   64 var sign word    66    5        0 LabelMaxIx
  7825                                  ;   65 var sign word    67    7        0 LabelIx
  7826                                  ;   66 def unsg byte    69    -        0 JMPCALLMAX=500
  7827                                  ;   67 def unsg byte    70    -        0 JMPCALLNAMESMAX=1969
  7828                                  ;   68 arr sign byte    71    3        0 JmpCallNames[2000]
  7829                                  ;   69 ptr sign byte    72    5        0 JmpCallNamePtr
  7830                                  ;   70 arr unsg word    73    2        0 JmpCallAddr[500]
  7831                                  ;   71 arr sign byte    74    2        0 JmpCallRelAbs[500]
  7832                                  ;   72 var sign word    75    8        0 JmpCallMaxIx
  7833                                  ;   73 def unsg byte    77    -        0 FILEBINMAX=2000
  7834                                  ;   74 arr sign byte    78    2        0 FileBin[2000]
  7835                                  ;   75 var unsg word    79    6        0 BinLen
  7836                                  ;   76 ptr sign byte    81    1        0 arglen
  7837                                  ;   77 ptr sign byte    82    4        0 argv
  7838                                  ;   78 var sign byte     1    1        0 I_START
  7839                                  ;   79 arr sign byte     4 NULL        0 I_PUSHA[9]
  7840                                  ;   80 arr sign byte     5 NULL        0 I_POPA[8]
  7841                                  ;   81 arr sign byte     6 NULL        0 I_NOP[7]
  7842                                  ;   82 arr sign byte     7 NULL        0 I_CBW[7]
  7843                                  ;   83 arr sign byte     8 NULL        0 I_CWDE[8]
  7844                                  ;   84 arr sign byte     9 NULL        0 I_CWD[7]
  7845                                  ;   85 arr sign byte    10 NULL        0 I_CDQ[7]
  7846                                  ;   86 arr sign byte    11 NULL        0 I_WAIT[8]
  7847                                  ;   87 arr sign byte    12 NULL        0 I_PUSHF[9]
  7848                                  ;   88 arr sign byte    13 NULL        0 I_POPF[8]
  7849                                  ;   89 arr sign byte    14 NULL        0 I_SAHF[8]
  7850                                  ;   90 arr sign byte    15 NULL        0 I_LAHF[8]
  7851                                  ;   91 arr sign byte    16 NULL        0 I_MOVSB[9]
  7852                                  ;   92 arr sign byte    17 NULL        0 I_MOVSW[9]
  7853                                  ;   93 arr sign byte    18 NULL        0 I_CMPSB[9]
  7854                                  ;   94 arr sign byte    19 NULL        0 I_CMPSW[9]
  7855                                  ;   95 arr sign byte    20 NULL        0 I_STOSB[9]
  7856                                  ;   96 arr sign byte    21 NULL        0 I_STOSW[9]
  7857                                  ;   97 arr sign byte    22 NULL        0 I_LODSB[9]
  7858                                  ;   98 arr sign byte    23 NULL        0 I_LODSW[9]
  7859                                  ;   99 arr sign byte    24 NULL        0 I_SCASB[9]
  7860                                  ;  100 arr sign byte    25 NULL        0 I_SCASW[9]
  7861                                  ;  101 arr sign byte    26 NULL        0 I_LEAVE[9]
  7862                                  ;  102 arr sign byte    27 NULL        0 I_INT3[8]
  7863                                  ;  103 arr sign byte    28 NULL        0 I_INTO[8]
  7864                                  ;  104 arr sign byte    29 NULL        0 I_IRET[8]
  7865                                  ;  105 arr sign byte    30 NULL        0 I_XLAT[8]
  7866                                  ;  106 arr sign byte    31 NULL        0 I_LOCK[8]
  7867                                  ;  107 arr sign byte    32 NULL        0 I_REPNE[9]
  7868                                  ;  108 arr sign byte    33 NULL        0 I_REPNZ[9]
  7869                                  ;  109 arr sign byte    34 NULL        0 I_REPE[8]
  7870                                  ;  110 arr sign byte    35 NULL        0 I_REPZ[8]
  7871                                  ;  111 arr sign byte    36 NULL        0 I_HLT[7]
  7872                                  ;  112 arr sign byte    37 NULL        0 I_CLC[7]
  7873                                  ;  113 arr sign byte    38 NULL        0 I_STC[7]
  7874                                  ;  114 arr sign byte    39 NULL        0 I_CLI[7]
  7875                                  ;  115 arr sign byte    40 NULL        0 I_STI[7]
  7876                                  ;  116 arr sign byte    41 NULL        0 I_CLD[7]
  7877                                  ;  117 arr sign byte    42 NULL        0 I_STD[7]
  7878                                  ;  118 arr sign byte    44 NULL        0 I_INC[9]
  7879                                  ;  119 arr sign byte    45 NULL        0 I_DEC[9]
  7880                                  ;  120 arr sign byte    46 NULL        0 I_NOT[8]
  7881                                  ;  121 arr sign byte    47 NULL        0 I_NEG[8]
  7882                                  ;  122 arr sign byte    48 NULL        0 I_MUL[8]
  7883                                  ;  123 arr sign byte    49 NULL        0 I_IMUL[9]
  7884                                  ;  124 arr sign byte    50 NULL        0 I_DIV[8]
  7885                                  ;  125 arr sign byte    51 NULL        0 I_IDIV[9]
  7886                                  ;  126 arr sign byte    53 NULL        0 I_LES[7]
  7887                                  ;  127 arr sign byte    54 NULL        0 I_LDS[7]
  7888                                  ;  128 arr sign byte    55 NULL        0 I_LEA[7]
  7889                                  ;  129 arr sign byte    56 NULL        0 I_LSS[8]
  7890                                  ;  130 arr sign byte    57 NULL        0 I_LFS[8]
  7891                                  ;  131 arr sign byte    58 NULL        0 I_LGS[8]
  7892                                  ;  132 arr sign byte    60 NULL        0 I_ADD[7]
  7893                                  ;  133 arr sign byte    61 NULL        0 I_OR[6]
  7894                                  ;  134 arr sign byte    62 NULL        0 I_ADC[7]
  7895                                  ;  135 arr sign byte    63 NULL        0 I_SBB[7]
  7896                                  ;  136 arr sign byte    64 NULL        0 I_AND[7]
  7897                                  ;  137 arr sign byte    65 NULL        0 I_SUB[7]
  7898                                  ;  138 arr sign byte    66 NULL        0 I_XOR[7]
  7899                                  ;  139 arr sign byte    67 NULL        0 I_CMP[7]
  7900                                  ;  140 arr sign byte    68 NULL        0 I_TEST[11]
  7901                                  ;  141 arr sign byte    70 NULL        0 I_MOV[6]
  7902                                  ;  142 arr sign byte    71 NULL        0 I_MOVSX[9]
  7903                                  ;  143 arr sign byte    72 NULL        0 I_MOVZX[9]
  7904                                  ;  144 arr sign byte    74 NULL        0 I_JO[6]
  7905                                  ;  145 arr sign byte    75 NULL        0 I_JNO[7]
  7906                                  ;  146 arr sign byte    76 NULL        0 I_JB[6]
  7907                                  ;  147 arr sign byte    77 NULL        0 I_JC[6]
  7908                                  ;  148 arr sign byte    78 NULL        0 I_JNB[7]
  7909                                  ;  149 arr sign byte    79 NULL        0 I_JAE[7]
  7910                                  ;  150 arr sign byte    80 NULL        0 I_JNC[7]
  7911                                  ;  151 arr sign byte    81 NULL        0 I_JE[6]
  7912                                  ;  152 arr sign byte    82 NULL        0 I_JZ[6]
  7913                                  ;  153 arr sign byte    83 NULL        0 I_JNE[7]
  7914                                  ;  154 arr sign byte    84 NULL        0 I_JNZ[7]
  7915                                  ;  155 arr sign byte    85 NULL        0 I_JBE[7]
  7916                                  ;  156 arr sign byte    86 NULL        0 I_JNA[7]
  7917                                  ;  157 arr sign byte    87 NULL        0 I_JA[6]
  7918                                  ;  158 arr sign byte    88 NULL        0 I_JS[6]
  7919                                  ;  159 arr sign byte    89 NULL        0 I_JNS[7]
  7920                                  ;  160 arr sign byte    90 NULL        0 I_JP[6]
  7921                                  ;  161 arr sign byte    91 NULL        0 I_JPE[7]
  7922                                  ;  162 arr sign byte    92 NULL        0 I_JNP[7]
  7923                                  ;  163 arr sign byte    93 NULL        0 I_JPO[7]
  7924                                  ;  164 arr sign byte    94 NULL        0 I_JL[6]
  7925                                  ;  165 arr sign byte    95 NULL        0 I_JNL[7]
  7926                                  ;  166 arr sign byte    96 NULL        0 I_JGE[7]
  7927                                  ;  167 arr sign byte    97 NULL        0 I_JLE[7]
  7928                                  ;  168 arr sign byte    98 NULL        0 I_JNG[7]
  7929                                  ;  169 arr sign byte    99 NULL        0 I_JG[6]
  7930                                  ;  170 arr sign byte   101 NULL        0 I_JMP[8]
  7931                                  ;  171 arr sign byte   102 NULL        0 I_CALL[9]
  7932                                  ;  172 arr sign byte   104 NULL        0 I_RET[8]
  7933                                  ;  173 arr sign byte   105 NULL        0 I_RETF[9]
  7934                                  ;  174 arr sign byte   107 NULL        0 I_PUSH[11]
  7935                                  ;  175 arr sign byte   108 NULL        0 I_POP[10]
  7936                                  ;  176 arr sign byte   110 NULL        0 I_ROL[7]
  7937                                  ;  177 arr sign byte   111 NULL        0 I_ROR[7]
  7938                                  ;  178 arr sign byte   112 NULL        0 I_RCL[7]
  7939                                  ;  179 arr sign byte   113 NULL        0 I_RCR[7]
  7940                                  ;  180 arr sign byte   114 NULL        0 I_SHL[7]
  7941                                  ;  181 arr sign byte   115 NULL        0 I_SAL[7]
  7942                                  ;  182 arr sign byte   116 NULL        0 I_SHR[7]
  7943                                  ;  183 arr sign byte   117 NULL        0 I_SAR[7]
  7944                                  ;  184 arr sign byte   119 NULL        0 I_INT[8]
  7945                                  ;  185 arr sign byte   130 NULL        0 I_XCHG[9]
  7946                                  ;  186 arr sign byte   140 NULL        0 I_ENTER[8]
  7947                                  ;  187 arr sign byte   142 NULL        0 I_ORG[6]
  7948                                  ;  188 arr sign byte   147 NULL        0 I_DB[5]
  7949                                  ;  189 arr sign byte   148 NULL        0 I_DW[5]
  7950                                  ;  190 arr sign byte   149 NULL        0 I_DD[5]
  7951                                  ;  191 arr sign byte   150 NULL        0 I_RESB[7]
  7952                                  ;  192 arr sign byte   151 NULL        0 I_RESW[7]
  7953                                  ;  193 arr sign byte   152 NULL        0 I_RESD[7]
  7954                                  ;  194 var sign byte   153 NULL        0 I_END
  7955                                  
  7956                                  
  7957                                  ;   # Calls Line Width  Name   list of functions
  7958                                  
  7959                                  ;    0    2    1 word   ChangeDirection
  7960                                  ;    1    2    9 word   checkOpL
  7961                                  ;    2    3   18 word   check2Ops
  7962                                  ;    3    1   27 word   get2Ops
  7963                                  ;    4    3   33 word   getOpL
  7964                                  ;    5    2   41 word   getOpR
  7965                                  ;    6    4   51 word   getOp1
  7966                                  ;    7    1   67 word   getMEM
  7967                                  ;    8    1   90 word   getIndReg1
  7968                                  ;    9    1   98 word   getIndReg2
  7969                                  ;   10    2  108 word   setwflag
  7970                                  ;   11    2  119 word   setsflag
  7971                                  ;   12    1  129 word   checkConstSize
  7972                                  ;   13    1    1 word   parse
  7973                                  ;   14   14   35 word   getTokeType
  7974                                  ;   15    1   46 word   storeJmpCall
  7975                                  ;   16    2   59 word   storeLabel
  7976                                  ;   17    3   71 word   searchLabel
  7977                                  ;   18    1   84 word   getVariable
  7978                                  ;   19    2  119 word   lookCode
  7979                                  ;   20    1  135 word   getCodeSize
  7980                                  ;   21    8  143 word   isToken
  7981                                  ;   22    2  151 word   need
  7982                                  ;   23    1  160 word   skipRest
  7983                                  ;   24    1    1 word   getLine
  7984                                  ;   25    1   17 word   ifEOL
  7985                                  ;   26    3   24 word   skipBlank
  7986                                  ;   27    2   29 word   letterE
  7987                                  ;   28    1   39 word   alnumE
  7988                                  ;   29    1   44 word   getDigit
  7989                                  ;   30    1   56 word   getName
  7990                                  ;   31    1   75 word   testReg
  7991                                  ;   32    1    1 word   printLine
  7992                                  ;   33   10   23 word   prc
  7993                                  ;   34    1   35 word   prscomment
  7994                                  ;   35   27   43 word   prs
  7995                                  ;   36    3   65 word   printhex8a
  7996                                  ;   37    2   70 word   printhex4
  7997                                  ;   38    2   75 word   printhex16
  7998                                  ;   39    4   80 word   printIntU
  7999                                  ;   40   24   91 word   error1
  8000                                  ;   41   14   99 word   errorexit
  8001                                  ;   42 NULL  103 word   allowederror
  8002                                  ;   43    3  104 word   addrerror
  8003                                  ;   44    1  105 word   immeerror
  8004                                  ;   45    2  106 word   implerror
  8005                                  ;   46    4  107 word   indexerror
  8006                                  ;   47    3  108 word   invaloperror
  8007                                  ;   48    4  109 word   numbererror
  8008                                  ;   49    1  110 word   regmemerror
  8009                                  ;   50    3  111 word   reg16error
  8010                                  ;   51    1  112 word   segregerror
  8011                                  ;   52    4  113 word   syntaxerror
  8012                                  ;   53 NULL  115 word   addrexit
  8013                                  ;   54 NULL  116 word   internexit
  8014                                  ;   55 NULL    1 word   main
  8015                                  ;   56    1    9 word   getarg
  8016                                  ;   57    1   43 word   fixJmpCall
  8017                                  ;   58    1   65 word   epilog
  8018                                  ;   59    2   86 word   end1
  8019                                  ;   60    1    2 word   getCodes
  8020                                  ;   61    1    7 word   gen66h
  8021                                  ;   62    8    9 word   genCode2
  8022                                  ;   63   10   13 word   genCodeW
  8023                                  ;   64   27   17 word   genCode8
  8024                                  ;   65   10   28 word   genCode16
  8025                                  ;   66   10   32 word   writeEA
  8026                                  ;   67    4   74 word   genImmediate
  8027                                  ;   68    1   11 word   process
  8028                                  ;   69    4  280 word   writetty
  8029                                  ;   70    8  281 word   cputs
  8030                                  ;   71    2  282 word   toupper
  8031                                  ;   72    4  284 word   strlen
  8032                                  ;   73    8  285 word   strcpy
  8033                                  ;   74    3  287 word   digit
  8034                                  ;   75   35  288 word   eqstr
  8035                                  ;   76    3  291 word   strcat1
  8036                                  ;   77    1  292 word   openR
  8037                                  ;   78    2  293 word   creatR
  8038                                  ;   79    2  294 word   readRL
  8039                                  ;   80    2  295 word   fputcR
  8040                                  ;   81    3  297 word   fcloseR
  8041                                  ;   82    5  298 word   exitR
  8042                                  ;   83    1  300 word   putch
  8043                                  ;   84    4  301 word   DosInt
  8044                                  ;   85 NULL  302 word   LastFunctionByt
  8045                                  
  8046                                  ;    #  addr name   list of CALLs
  8047                                  
  8048                                  ;    0  1406 implerror
  8049                                  ;    1  1416 segregerror
  8050                                  ;    2  1428 setwflag
  8051                                  ;    3  1437 error1
  8052                                  ;    4  1444 error1
  8053                                  ;    5  1461 get2Ops
  8054                                  ;    6  1469 addrerror
  8055                                  ;    7  1479 invaloperror
  8056                                  ;    8  1492 immeerror
  8057                                  ;    9  1502 addrerror
  8058                                  ;   10  1512 invaloperror
  8059                                  ;   11  1525 setwflag
  8060                                  ;   12  1542 getOpL
  8061                                  ;   13  1549 need
  8062                                  ;   14  1554 getOpR
  8063                                  ;   15  1568 getOpR
  8064                                  ;   16  1582 getOp1
  8065                                  ;   17  1589 isToken
  8066                                  ;   18  1597 getMEM
  8067                                  ;   19  1604 invaloperror
  8068                                  ;   20  1617 error1
  8069                                  ;   21  1631 testReg
  8070                                  ;   22  1639 searchLabel
  8071                                  ;   23  1651 error1
  8072                                  ;   24  1667 getTokeType
  8073                                  ;   25  1679 getOp1
  8074                                  ;   26  1686 syntaxerror
  8075                                  ;   27  1698 getIndReg2
  8076                                  ;   28  1709 getIndReg1
  8077                                  ;   29  1720 isToken
  8078                                  ;   30  1728 getTokeType
  8079                                  ;   31  1740 numbererror
  8080                                  ;   32  1752 isToken
  8081                                  ;   33  1760 isToken
  8082                                  ;   34  1768 errorexit
  8083                                  ;   35  1789 indexerror
  8084                                  ;   36  1800 indexerror
  8085                                  ;   37  1824 indexerror
  8086                                  ;   38  1835 indexerror
  8087                                  ;   39  1855 gen66h
  8088                                  ;   40  1874 error1
  8089                                  ;   41  1905 getLine
  8090                                  ;   42  1913 getTokeType
  8091                                  ;   43  1925 storeLabel
  8092                                  ;   44  1936 getTokeType
  8093                                  ;   45  1948 lookCode
  8094                                  ;   46  1957 process
  8095                                  ;   47  1965 getVariable
  8096                                  ;   48  1977 skipRest
  8097                                  ;   49  1986 error1
  8098                                  ;   50  1993 error1
  8099                                  ;   51  2000 printLine
  8100                                  ;   52  2024 skipBlank
  8101                                  ;   53  2034 digit
  8102                                  ;   54  2040 getDigit
  8103                                  ;   55  2049 letterE
  8104                                  ;   56  2057 getName
  8105                                  ;   57  2080 errorexit
  8106                                  ;   58  2090 strcpy
  8107                                  ;   59  2097 errorexit
  8108                                  ;   60  2120 errorexit
  8109                                  ;   61  2130 searchLabel
  8110                                  ;   62  2142 error1
  8111                                  ;   63  2149 strcpy
  8112                                  ;   64  2156 errorexit
  8113                                  ;   65  2184 eqstr
  8114                                  ;   66  2190 strlen
  8115                                  ;   67  2211 storeLabel
  8116                                  ;   68  2222 getTokeType
  8117                                  ;   69  2234 lookCode
  8118                                  ;   70  2243 errorexit
  8119                                  ;   71  2253 errorexit
  8120                                  ;   72  2263 getTokeType
  8121                                  ;   73  2275 genCode8
  8122                                  ;   74  2284 skipBlank
  8123                                  ;   75  2294 isToken
  8124                                  ;   76  2302 genCode8
  8125                                  ;   77  2311 isToken
  8126                                  ;   78  2319 getTokeType
  8127                                  ;   79  2331 genCode16
  8128                                  ;   80  2341 isToken
  8129                                  ;   81  2349 errorexit
  8130                                  ;   82  2368 eqstr
  8131                                  ;   83  2386 eqstr
  8132                                  ;   84  2392 getTokeType
  8133                                  ;   85  2404 eqstr
  8134                                  ;   86  2410 getTokeType
  8135                                  ;   87  2422 eqstr
  8136                                  ;   88  2428 getTokeType
  8137                                  ;   89  2450 skipBlank
  8138                                  ;   90  2467 isToken
  8139                                  ;   91  2475 getTokeType
  8140                                  ;   92  2487 error1
  8141                                  ;   93  2494 prs
  8142                                  ;   94  2498 prc
  8143                                  ;   95  2511 getTokeType
  8144                                  ;   96  2523 error1
  8145                                  ;   97  2540 readRL
  8146                                  ;   98  2547 errorexit
  8147                                  ;   99  2557 errorexit
  8148                                  ;  100  2567 ifEOL
  8149                                  ;  101  2581 readRL
  8150                                  ;  102  2617 digit
  8151                                  ;  103  2623 letterE
  8152                                  ;  104  2650 digit
  8153                                  ;  105  2670 alnumE
  8154                                  ;  106  2677 errorexit
  8155                                  ;  107  2687 strcpy
  8156                                  ;  108  2694 toupper
  8157                                  ;  109  2710 strlen
  8158                                  ;  110  2717 strlen
  8159                                  ;  111  2724 eqstr
  8160                                  ;  112  2730 eqstr
  8161                                  ;  113  2736 eqstr
  8162                                  ;  114  2742 eqstr
  8163                                  ;  115  2748 eqstr
  8164                                  ;  116  2754 eqstr
  8165                                  ;  117  2760 eqstr
  8166                                  ;  118  2766 eqstr
  8167                                  ;  119  2772 eqstr
  8168                                  ;  120  2778 eqstr
  8169                                  ;  121  2784 eqstr
  8170                                  ;  122  2790 eqstr
  8171                                  ;  123  2796 eqstr
  8172                                  ;  124  2802 eqstr
  8173                                  ;  125  2808 eqstr
  8174                                  ;  126  2814 eqstr
  8175                                  ;  127  2820 eqstr
  8176                                  ;  128  2826 eqstr
  8177                                  ;  129  2832 eqstr
  8178                                  ;  130  2838 eqstr
  8179                                  ;  131  2844 eqstr
  8180                                  ;  132  2850 eqstr
  8181                                  ;  133  2856 eqstr
  8182                                  ;  134  2862 eqstr
  8183                                  ;  135  2868 eqstr
  8184                                  ;  136  2874 eqstr
  8185                                  ;  137  2880 eqstr
  8186                                  ;  138  2886 eqstr
  8187                                  ;  139  2892 eqstr
  8188                                  ;  140  2898 eqstr
  8189                                  ;  141  2918 prs
  8190                                  ;  142  2922 printhex16
  8191                                  ;  143  2933 prs
  8192                                  ;  144  2937 prc
  8193                                  ;  145  2941 printhex8a
  8194                                  ;  146  2952 prs
  8195                                  ;  147  2956 prc
  8196                                  ;  148  2960 prscomment
  8197                                  ;  149  2977 writetty
  8198                                  ;  150  2986 writetty
  8199                                  ;  151  2995 fputcR
  8200                                  ;  152  3017 prc
  8201                                  ;  153  3033 prc
  8202                                  ;  154  3054 printhex4
  8203                                  ;  155  3064 printhex4
  8204                                  ;  156  3086 prc
  8205                                  ;  157  3108 printhex8a
  8206                                  ;  158  3119 printhex8a
  8207                                  ;  159  3144 printIntU
  8208                                  ;  160  3154 prc
  8209                                  ;  161  3167 prs
  8210                                  ;  162  3171 prs
  8211                                  ;  163  3175 prs
  8212                                  ;  164  3179 prs
  8213                                  ;  165  3195 error1
  8214                                  ;  166  3202 end1
  8215                                  ;  167  3220 error1
  8216                                  ;  168  3237 error1
  8217                                  ;  169  3254 error1
  8218                                  ;  170  3271 error1
  8219                                  ;  171  3289 error1
  8220                                  ;  172  3309 error1
  8221                                  ;  173  3328 error1
  8222                                  ;  174  3347 error1
  8223                                  ;  175  3365 error1
  8224                                  ;  176  3384 error1
  8225                                  ;  177  3403 error1
  8226                                  ;  178  3419 errorexit
  8227                                  ;  179  3440 errorexit
  8228                                  ;  180  3455 getarg
  8229                                  ;  181  3462 parse
  8230                                  ;  182  3468 fixJmpCall
  8231                                  ;  183  3479 epilog
  8232                                  ;  184  3486 end1
  8233                                  ;  185  3510 cputs
  8234                                  ;  186  3516 cputs
  8235                                  ;  187  3522 exitR
  8236                                  ;  188  3528 toupper
  8237                                  ;  189  3536 strcpy
  8238                                  ;  190  3543 strcat1
  8239                                  ;  191  3551 strcpy
  8240                                  ;  192  3558 strcat1
  8241                                  ;  193  3566 strcpy
  8242                                  ;  194  3573 strcat1
  8243                                  ;  195  3581 openR
  8244                                  ;  196  3587 cputs
  8245                                  ;  197  3593 cputs
  8246                                  ;  198  3599 exitR
  8247                                  ;  199  3605 creatR
  8248                                  ;  200  3612 cputs
  8249                                  ;  201  3618 cputs
  8250                                  ;  202  3624 exitR
  8251                                  ;  203  3630 creatR
  8252                                  ;  204  3637 cputs
  8253                                  ;  205  3643 cputs
  8254                                  ;  206  3649 exitR
  8255                                  ;  207  3655 prs
  8256                                  ;  208  3659 prs
  8257                                  ;  209  3663 prs
  8258                                  ;  210  3667 prs
  8259                                  ;  211  3671 prs
  8260                                  ;  212  3675 prs
  8261                                  ;  213  3679 prs
  8262                                  ;  214  3683 prs
  8263                                  ;  215  3687 prs
  8264                                  ;  216  3710 prs
  8265                                  ;  217  3714 printIntU
  8266                                  ;  218  3724 strcpy
  8267                                  ;  219  3731 strlen
  8268                                  ;  220  3738 prc
  8269                                  ;  221  3742 prs
  8270                                  ;  222  3746 prc
  8271                                  ;  223  3750 printhex16
  8272                                  ;  224  3761 prc
  8273                                  ;  225  3776 prs
  8274                                  ;  226  3780 printIntU
  8275                                  ;  227  3790 prs
  8276                                  ;  228  3794 prs
  8277                                  ;  229  3798 prs
  8278                                  ;  230  3802 prs
  8279                                  ;  231  3806 prs
  8280                                  ;  232  3810 prs
  8281                                  ;  233  3814 printIntU
  8282                                  ;  234  3824 prs
  8283                                  ;  235  3828 fputcR
  8284                                  ;  236  3842 fcloseR
  8285                                  ;  237  3850 fcloseR
  8286                                  ;  238  3858 fcloseR
  8287                                  ;  239  3866 exitR
  8288                                  ;  240  3888 genCode8
  8289                                  ;  241  3910 genCode8
  8290                                  ;  242  3930 genCode8
  8291                                  ;  243  3950 errorexit
  8292                                  ;  244  3972 genCode8
  8293                                  ;  245  3981 genCode8
  8294                                  ;  246  4006 genCode8
  8295                                  ;  247  4015 genCode8
  8296                                  ;  248  4024 genCode16
  8297                                  ;  249  4047 genCode16
  8298                                  ;  250  4057 genCode8
  8299                                  ;  251  4076 getTokeType
  8300                                  ;  252  4088 getCodeSize
  8301                                  ;  253  4100 getCodes
  8302                                  ;  254  4109 genCode8
  8303                                  ;  255  4118 getOpL
  8304                                  ;  256  4125 checkOpL
  8305                                  ;  257  4134 genCode2
  8306                                  ;  258  4143 getTokeType
  8307                                  ;  259  4155 implerror
  8308                                  ;  260  4165 genCodeW
  8309                                  ;  261  4174 writeEA
  8310                                  ;  262  4182 check2Ops
  8311                                  ;  263  4192 reg16error
  8312                                  ;  264  4203 addrerror
  8313                                  ;  265  4213 genCode8
  8314                                  ;  266  4222 genCode8
  8315                                  ;  267  4231 writeEA
  8316                                  ;  268  4239 check2Ops
  8317                                  ;  269  4249 setsflag
  8318                                  ;  270  4258 genCodeW
  8319                                  ;  271  4267 genImmediate
  8320                                  ;  272  4280 genCodeW
  8321                                  ;  273  4289 writeEA
  8322                                  ;  274  4297 genCode8
  8323                                  ;  275  4306 genImmediate
  8324                                  ;  276  4319 genCodeW
  8325                                  ;  277  4328 writeEA
  8326                                  ;  278  4336 genCodeW
  8327                                  ;  279  4345 writeEA
  8328                                  ;  280  4353 syntaxerror
  8329                                  ;  281  4365 check2Ops
  8330                                  ;  282  4375 genCode2
  8331                                  ;  283  4384 genImmediate
  8332                                  ;  284  4397 genCodeW
  8333                                  ;  285  4406 writeEA
  8334                                  ;  286  4414 genImmediate
  8335                                  ;  287  4427 regmemerror
  8336                                  ;  288  4439 ChangeDirection
  8337                                  ;  289  4455 reg16error
  8338                                  ;  290  4466 genCode2
  8339                                  ;  291  4475 writeEA
  8340                                  ;  292  4483 genCodeW
  8341                                  ;  293  4492 genCode16
  8342                                  ;  294  4502 genCodeW
  8343                                  ;  295  4511 genCode16
  8344                                  ;  296  4521 genCodeW
  8345                                  ;  297  4530 writeEA
  8346                                  ;  298  4538 ChangeDirection
  8347                                  ;  299  4554 genCodeW
  8348                                  ;  300  4563 writeEA
  8349                                  ;  301  4571 syntaxerror
  8350                                  ;  302  4583 searchLabel
  8351                                  ;  303  4595 checkConstSize
  8352                                  ;  304  4610 genCode2
  8353                                  ;  305  4619 genCode8
  8354                                  ;  306  4628 genCode8
  8355                                  ;  307  4637 genCode2
  8356                                  ;  308  4646 genCode16
  8357                                  ;  309  4656 genCode8
  8358                                  ;  310  4665 genCode2
  8359                                  ;  311  4674 genCode16
  8360                                  ;  312  4684 storeJmpCall
  8361                                  ;  313  4697 genCode8
  8362                                  ;  314  4706 genCode16
  8363                                  ;  315  4716 genCode8
  8364                                  ;  316  4725 getOpL
  8365                                  ;  317  4732 setsflag
  8366                                  ;  318  4741 genCode2
  8367                                  ;  319  4750 genCode8
  8368                                  ;  320  4759 genCode16
  8369                                  ;  321  4769 error1
  8370                                  ;  322  4776 genCode8
  8371                                  ;  323  4785 genCode8
  8372                                  ;  324  4794 checkOpL
  8373                                  ;  325  4803 reg16error
  8374                                  ;  326  4814 genCode2
  8375                                  ;  327  4823 genCode8
  8376                                  ;  328  4832 writeEA
  8377                                  ;  329  4840 syntaxerror
  8378                                  ;  330  4852 genCode8
  8379                                  ;  331  4861 genCode8
  8380                                  ;  332  4870 genCode8
  8381                                  ;  333  4879 getOp1
  8382                                  ;  334  4886 genCode16
  8383                                  ;  335  4896 numbererror
  8384                                  ;  336  4908 need
  8385                                  ;  337  4913 getOp1
  8386                                  ;  338  4920 genCode8
  8387                                  ;  339  4929 numbererror
  8388                                  ;  340  4941 numbererror
  8389                                  ;  341  4953 error1
  8390                                  ;  342  4979 putch
  8391                                  ;  343  5047 strcpy
  8392                                  ;  344  5062 DosInt
  8393                                  ;  345  5078 DosInt
  8394                                  ;  346  5101 DosInt
  8395                                  ;  347  5120 DosInt
  8396                                  ;  348  5154 writetty
  8397                                  ;  349  5163 writetty
  8398                                  ;Input: AS.C, List: AS.S,  Lines:  303
  8399                                  ;Glob. variables:  194 max.:  200
  8400                                  ;Local variables:    3 max.:  100, in 'getName'
  8401                                  ;Functions      :   86 max.:  300
  8402                                  ;Calls          :  350 max.: 2000, NameField: 5195 max.:    65535
  8403                                  ;Code until     :25998 max.: 30000, free: 4002
  8404                                  ;Data (HeapEnd) :37095, resting stacksize: 28440
  8405                                  ;Max. Const in 'testReg' :  658 max. 3000, free: 2342
